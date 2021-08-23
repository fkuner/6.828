
obj/fs/fs:     file format elf32-i386


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
  80002c:	e8 9b 1a 00 00       	call   801acc <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <ide_wait_ready>:

static int diskno = 1;

static int
ide_wait_ready(bool check_error)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	89 c1                	mov    %eax,%ecx

static inline uint8_t
inb(int port)
{
	uint8_t data;
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  800039:	ba f7 01 00 00       	mov    $0x1f7,%edx
  80003e:	ec                   	in     (%dx),%al
  80003f:	89 c3                	mov    %eax,%ebx
	int r;

	while (((r = inb(0x1F7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
  800041:	83 e0 c0             	and    $0xffffffc0,%eax
  800044:	3c 40                	cmp    $0x40,%al
  800046:	75 f6                	jne    80003e <ide_wait_ready+0xb>
		/* do nothing */;

	if (check_error && (r & (IDE_DF|IDE_ERR)) != 0)
		return -1;
	return 0;
  800048:	b8 00 00 00 00       	mov    $0x0,%eax
	if (check_error && (r & (IDE_DF|IDE_ERR)) != 0)
  80004d:	84 c9                	test   %cl,%cl
  80004f:	74 0b                	je     80005c <ide_wait_ready+0x29>
  800051:	f6 c3 21             	test   $0x21,%bl
  800054:	0f 95 c0             	setne  %al
  800057:	0f b6 c0             	movzbl %al,%eax
  80005a:	f7 d8                	neg    %eax
}
  80005c:	5b                   	pop    %ebx
  80005d:	5d                   	pop    %ebp
  80005e:	c3                   	ret    

0080005f <ide_probe_disk1>:

bool
ide_probe_disk1(void)
{
  80005f:	55                   	push   %ebp
  800060:	89 e5                	mov    %esp,%ebp
  800062:	53                   	push   %ebx
  800063:	83 ec 04             	sub    $0x4,%esp
	int r, x;

	// wait for Device 0 to be ready
	ide_wait_ready(0);
  800066:	b8 00 00 00 00       	mov    $0x0,%eax
  80006b:	e8 c3 ff ff ff       	call   800033 <ide_wait_ready>
}

static inline void
outb(int port, uint8_t data)
{
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
  800070:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800075:	ba f6 01 00 00       	mov    $0x1f6,%edx
  80007a:	ee                   	out    %al,(%dx)

	// switch to Device 1
	outb(0x1F6, 0xE0 | (1<<4));

	// check for Device 1 to be ready for a while
	for (x = 0;
  80007b:	b9 00 00 00 00       	mov    $0x0,%ecx
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  800080:	ba f7 01 00 00       	mov    $0x1f7,%edx
  800085:	ec                   	in     (%dx),%al
	     x < 1000 && ((r = inb(0x1F7)) & (IDE_BSY|IDE_DF|IDE_ERR)) != 0;
  800086:	a8 a1                	test   $0xa1,%al
  800088:	74 0b                	je     800095 <ide_probe_disk1+0x36>
	     x++)
  80008a:	83 c1 01             	add    $0x1,%ecx
	for (x = 0;
  80008d:	81 f9 e8 03 00 00    	cmp    $0x3e8,%ecx
  800093:	75 f0                	jne    800085 <ide_probe_disk1+0x26>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
  800095:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
  80009a:	ba f6 01 00 00       	mov    $0x1f6,%edx
  80009f:	ee                   	out    %al,(%dx)
		/* do nothing */;

	// switch back to Device 0
	outb(0x1F6, 0xE0 | (0<<4));

	cprintf("Device 1 presence: %d\n", (x < 1000));
  8000a0:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
  8000a6:	0f 9e c3             	setle  %bl
  8000a9:	83 ec 08             	sub    $0x8,%esp
  8000ac:	0f b6 c3             	movzbl %bl,%eax
  8000af:	50                   	push   %eax
  8000b0:	68 40 3e 80 00       	push   $0x803e40
  8000b5:	e8 4d 1b 00 00       	call   801c07 <cprintf>
	return (x < 1000);
}
  8000ba:	89 d8                	mov    %ebx,%eax
  8000bc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000bf:	c9                   	leave  
  8000c0:	c3                   	ret    

008000c1 <ide_set_disk>:

void
ide_set_disk(int d)
{
  8000c1:	55                   	push   %ebp
  8000c2:	89 e5                	mov    %esp,%ebp
  8000c4:	83 ec 08             	sub    $0x8,%esp
  8000c7:	8b 45 08             	mov    0x8(%ebp),%eax
	if (d != 0 && d != 1)
  8000ca:	83 f8 01             	cmp    $0x1,%eax
  8000cd:	77 07                	ja     8000d6 <ide_set_disk+0x15>
		panic("bad disk number");
	diskno = d;
  8000cf:	a3 00 50 80 00       	mov    %eax,0x805000
}
  8000d4:	c9                   	leave  
  8000d5:	c3                   	ret    
		panic("bad disk number");
  8000d6:	83 ec 04             	sub    $0x4,%esp
  8000d9:	68 57 3e 80 00       	push   $0x803e57
  8000de:	6a 3a                	push   $0x3a
  8000e0:	68 67 3e 80 00       	push   $0x803e67
  8000e5:	e8 42 1a 00 00       	call   801b2c <_panic>

008000ea <ide_read>:


int
ide_read(uint32_t secno, void *dst, size_t nsecs)
{
  8000ea:	55                   	push   %ebp
  8000eb:	89 e5                	mov    %esp,%ebp
  8000ed:	57                   	push   %edi
  8000ee:	56                   	push   %esi
  8000ef:	53                   	push   %ebx
  8000f0:	83 ec 0c             	sub    $0xc,%esp
  8000f3:	8b 7d 08             	mov    0x8(%ebp),%edi
  8000f6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8000f9:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	assert(nsecs <= 256);
  8000fc:	81 fe 00 01 00 00    	cmp    $0x100,%esi
  800102:	0f 87 87 00 00 00    	ja     80018f <ide_read+0xa5>

	ide_wait_ready(0);
  800108:	b8 00 00 00 00       	mov    $0x0,%eax
  80010d:	e8 21 ff ff ff       	call   800033 <ide_wait_ready>
  800112:	ba f2 01 00 00       	mov    $0x1f2,%edx
  800117:	89 f0                	mov    %esi,%eax
  800119:	ee                   	out    %al,(%dx)
  80011a:	ba f3 01 00 00       	mov    $0x1f3,%edx
  80011f:	89 f8                	mov    %edi,%eax
  800121:	ee                   	out    %al,(%dx)

	outb(0x1F2, nsecs);
	outb(0x1F3, secno & 0xFF);
	outb(0x1F4, (secno >> 8) & 0xFF);
  800122:	89 f8                	mov    %edi,%eax
  800124:	c1 e8 08             	shr    $0x8,%eax
  800127:	ba f4 01 00 00       	mov    $0x1f4,%edx
  80012c:	ee                   	out    %al,(%dx)
	outb(0x1F5, (secno >> 16) & 0xFF);
  80012d:	89 f8                	mov    %edi,%eax
  80012f:	c1 e8 10             	shr    $0x10,%eax
  800132:	ba f5 01 00 00       	mov    $0x1f5,%edx
  800137:	ee                   	out    %al,(%dx)
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
  800138:	0f b6 05 00 50 80 00 	movzbl 0x805000,%eax
  80013f:	c1 e0 04             	shl    $0x4,%eax
  800142:	83 e0 10             	and    $0x10,%eax
  800145:	83 c8 e0             	or     $0xffffffe0,%eax
  800148:	c1 ef 18             	shr    $0x18,%edi
  80014b:	83 e7 0f             	and    $0xf,%edi
  80014e:	09 f8                	or     %edi,%eax
  800150:	ba f6 01 00 00       	mov    $0x1f6,%edx
  800155:	ee                   	out    %al,(%dx)
  800156:	b8 20 00 00 00       	mov    $0x20,%eax
  80015b:	ba f7 01 00 00       	mov    $0x1f7,%edx
  800160:	ee                   	out    %al,(%dx)
  800161:	c1 e6 09             	shl    $0x9,%esi
  800164:	01 de                	add    %ebx,%esi
	outb(0x1F7, 0x20);	// CMD 0x20 means read sector

	for (; nsecs > 0; nsecs--, dst += SECTSIZE) {
  800166:	39 f3                	cmp    %esi,%ebx
  800168:	74 3b                	je     8001a5 <ide_read+0xbb>
		if ((r = ide_wait_ready(1)) < 0)
  80016a:	b8 01 00 00 00       	mov    $0x1,%eax
  80016f:	e8 bf fe ff ff       	call   800033 <ide_wait_ready>
  800174:	85 c0                	test   %eax,%eax
  800176:	78 32                	js     8001aa <ide_read+0xc0>
	asm volatile("cld\n\trepne\n\tinsl"
  800178:	89 df                	mov    %ebx,%edi
  80017a:	b9 80 00 00 00       	mov    $0x80,%ecx
  80017f:	ba f0 01 00 00       	mov    $0x1f0,%edx
  800184:	fc                   	cld    
  800185:	f2 6d                	repnz insl (%dx),%es:(%edi)
	for (; nsecs > 0; nsecs--, dst += SECTSIZE) {
  800187:	81 c3 00 02 00 00    	add    $0x200,%ebx
  80018d:	eb d7                	jmp    800166 <ide_read+0x7c>
	assert(nsecs <= 256);
  80018f:	68 70 3e 80 00       	push   $0x803e70
  800194:	68 7d 3e 80 00       	push   $0x803e7d
  800199:	6a 44                	push   $0x44
  80019b:	68 67 3e 80 00       	push   $0x803e67
  8001a0:	e8 87 19 00 00       	call   801b2c <_panic>
			return r;
		insl(0x1F0, dst, SECTSIZE/4);
	}

	return 0;
  8001a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8001aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001ad:	5b                   	pop    %ebx
  8001ae:	5e                   	pop    %esi
  8001af:	5f                   	pop    %edi
  8001b0:	5d                   	pop    %ebp
  8001b1:	c3                   	ret    

008001b2 <ide_write>:

int
ide_write(uint32_t secno, const void *src, size_t nsecs)
{
  8001b2:	55                   	push   %ebp
  8001b3:	89 e5                	mov    %esp,%ebp
  8001b5:	57                   	push   %edi
  8001b6:	56                   	push   %esi
  8001b7:	53                   	push   %ebx
  8001b8:	83 ec 0c             	sub    $0xc,%esp
  8001bb:	8b 75 08             	mov    0x8(%ebp),%esi
  8001be:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8001c1:	8b 7d 10             	mov    0x10(%ebp),%edi
	int r;

	assert(nsecs <= 256);
  8001c4:	81 ff 00 01 00 00    	cmp    $0x100,%edi
  8001ca:	0f 87 87 00 00 00    	ja     800257 <ide_write+0xa5>

	ide_wait_ready(0);
  8001d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8001d5:	e8 59 fe ff ff       	call   800033 <ide_wait_ready>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
  8001da:	ba f2 01 00 00       	mov    $0x1f2,%edx
  8001df:	89 f8                	mov    %edi,%eax
  8001e1:	ee                   	out    %al,(%dx)
  8001e2:	ba f3 01 00 00       	mov    $0x1f3,%edx
  8001e7:	89 f0                	mov    %esi,%eax
  8001e9:	ee                   	out    %al,(%dx)

	outb(0x1F2, nsecs);
	outb(0x1F3, secno & 0xFF);
	outb(0x1F4, (secno >> 8) & 0xFF);
  8001ea:	89 f0                	mov    %esi,%eax
  8001ec:	c1 e8 08             	shr    $0x8,%eax
  8001ef:	ba f4 01 00 00       	mov    $0x1f4,%edx
  8001f4:	ee                   	out    %al,(%dx)
	outb(0x1F5, (secno >> 16) & 0xFF);
  8001f5:	89 f0                	mov    %esi,%eax
  8001f7:	c1 e8 10             	shr    $0x10,%eax
  8001fa:	ba f5 01 00 00       	mov    $0x1f5,%edx
  8001ff:	ee                   	out    %al,(%dx)
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
  800200:	0f b6 05 00 50 80 00 	movzbl 0x805000,%eax
  800207:	c1 e0 04             	shl    $0x4,%eax
  80020a:	83 e0 10             	and    $0x10,%eax
  80020d:	83 c8 e0             	or     $0xffffffe0,%eax
  800210:	c1 ee 18             	shr    $0x18,%esi
  800213:	83 e6 0f             	and    $0xf,%esi
  800216:	09 f0                	or     %esi,%eax
  800218:	ba f6 01 00 00       	mov    $0x1f6,%edx
  80021d:	ee                   	out    %al,(%dx)
  80021e:	b8 30 00 00 00       	mov    $0x30,%eax
  800223:	ba f7 01 00 00       	mov    $0x1f7,%edx
  800228:	ee                   	out    %al,(%dx)
  800229:	c1 e7 09             	shl    $0x9,%edi
  80022c:	01 df                	add    %ebx,%edi
	outb(0x1F7, 0x30);	// CMD 0x30 means write sector

	for (; nsecs > 0; nsecs--, src += SECTSIZE) {
  80022e:	39 fb                	cmp    %edi,%ebx
  800230:	74 3b                	je     80026d <ide_write+0xbb>
		if ((r = ide_wait_ready(1)) < 0)
  800232:	b8 01 00 00 00       	mov    $0x1,%eax
  800237:	e8 f7 fd ff ff       	call   800033 <ide_wait_ready>
  80023c:	85 c0                	test   %eax,%eax
  80023e:	78 32                	js     800272 <ide_write+0xc0>
}

static inline void
outsl(int port, const void *addr, int cnt)
{
	asm volatile("cld\n\trepne\n\toutsl"
  800240:	89 de                	mov    %ebx,%esi
  800242:	b9 80 00 00 00       	mov    $0x80,%ecx
  800247:	ba f0 01 00 00       	mov    $0x1f0,%edx
  80024c:	fc                   	cld    
  80024d:	f2 6f                	repnz outsl %ds:(%esi),(%dx)
	for (; nsecs > 0; nsecs--, src += SECTSIZE) {
  80024f:	81 c3 00 02 00 00    	add    $0x200,%ebx
  800255:	eb d7                	jmp    80022e <ide_write+0x7c>
	assert(nsecs <= 256);
  800257:	68 70 3e 80 00       	push   $0x803e70
  80025c:	68 7d 3e 80 00       	push   $0x803e7d
  800261:	6a 5d                	push   $0x5d
  800263:	68 67 3e 80 00       	push   $0x803e67
  800268:	e8 bf 18 00 00       	call   801b2c <_panic>
			return r;
		outsl(0x1F0, src, SECTSIZE/4);
	}

	return 0;
  80026d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800272:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800275:	5b                   	pop    %ebx
  800276:	5e                   	pop    %esi
  800277:	5f                   	pop    %edi
  800278:	5d                   	pop    %ebp
  800279:	c3                   	ret    

0080027a <bc_pgfault>:

// Fault any disk block that is read in to memory by
// loading it from disk.
static void
bc_pgfault(struct UTrapframe *utf)
{
  80027a:	55                   	push   %ebp
  80027b:	89 e5                	mov    %esp,%ebp
  80027d:	56                   	push   %esi
  80027e:	53                   	push   %ebx
  80027f:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  800282:	8b 1a                	mov    (%edx),%ebx
	uint32_t blockno = ((uint32_t)addr - DISKMAP) / BLKSIZE;
  800284:	8d 83 00 00 00 f0    	lea    -0x10000000(%ebx),%eax
  80028a:	89 c6                	mov    %eax,%esi
  80028c:	c1 ee 0c             	shr    $0xc,%esi
	int r;

	// Check that the fault was within the block cache region
	if (addr < (void*)DISKMAP || addr >= (void*)(DISKMAP + DISKSIZE))
  80028f:	3d ff ff ff bf       	cmp    $0xbfffffff,%eax
  800294:	0f 87 95 00 00 00    	ja     80032f <bc_pgfault+0xb5>
		panic("page fault in FS: eip %08x, va %08x, err %04x",
		      utf->utf_eip, addr, utf->utf_err);

	// Sanity check the block number.
	if (super && blockno >= super->s_nblocks)
  80029a:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  80029f:	85 c0                	test   %eax,%eax
  8002a1:	74 09                	je     8002ac <bc_pgfault+0x32>
  8002a3:	39 70 04             	cmp    %esi,0x4(%eax)
  8002a6:	0f 86 9e 00 00 00    	jbe    80034a <bc_pgfault+0xd0>
	// of the block from the disk into that page.
	// Hint: first round addr to page boundary. fs/ide.c has code to read
	// the disk.
	//
	// LAB 5: you code here:
	addr = ROUNDDOWN(addr, PGSIZE);
  8002ac:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	if ((r = sys_page_alloc(0, addr, PTE_W | PTE_U | PTE_P)) != 0) {
  8002b2:	83 ec 04             	sub    $0x4,%esp
  8002b5:	6a 07                	push   $0x7
  8002b7:	53                   	push   %ebx
  8002b8:	6a 00                	push   $0x0
  8002ba:	e8 de 23 00 00       	call   80269d <sys_page_alloc>
  8002bf:	83 c4 10             	add    $0x10,%esp
  8002c2:	85 c0                	test   %eax,%eax
  8002c4:	0f 85 92 00 00 00    	jne    80035c <bc_pgfault+0xe2>
	    panic("bc_pgfault: %e", r);
	}
	if ((r = ide_read(blockno * BLKSECTS, addr, BLKSECTS)) != 0) {
  8002ca:	83 ec 04             	sub    $0x4,%esp
  8002cd:	6a 08                	push   $0x8
  8002cf:	53                   	push   %ebx
  8002d0:	8d 04 f5 00 00 00 00 	lea    0x0(,%esi,8),%eax
  8002d7:	50                   	push   %eax
  8002d8:	e8 0d fe ff ff       	call   8000ea <ide_read>
  8002dd:	83 c4 10             	add    $0x10,%esp
  8002e0:	85 c0                	test   %eax,%eax
  8002e2:	0f 85 86 00 00 00    	jne    80036e <bc_pgfault+0xf4>
	    panic("bc_pgfault: %e", r);
	}

	// Clear the dirty bit for the disk block page since we just read the
	// block from disk
	if ((r = sys_page_map(0, addr, 0, addr, uvpt[PGNUM(addr)] & PTE_SYSCALL)) < 0)
  8002e8:	89 d8                	mov    %ebx,%eax
  8002ea:	c1 e8 0c             	shr    $0xc,%eax
  8002ed:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8002f4:	83 ec 0c             	sub    $0xc,%esp
  8002f7:	25 07 0e 00 00       	and    $0xe07,%eax
  8002fc:	50                   	push   %eax
  8002fd:	53                   	push   %ebx
  8002fe:	6a 00                	push   $0x0
  800300:	53                   	push   %ebx
  800301:	6a 00                	push   $0x0
  800303:	e8 d8 23 00 00       	call   8026e0 <sys_page_map>
  800308:	83 c4 20             	add    $0x20,%esp
  80030b:	85 c0                	test   %eax,%eax
  80030d:	78 71                	js     800380 <bc_pgfault+0x106>
		panic("in bc_pgfault, sys_page_map: %e", r);

	// Check that the block we read was allocated. (exercise for
	// the reader: why do we do this *after* reading the block
	// in?)
	if (bitmap && block_is_free(blockno))
  80030f:	83 3d 08 a0 80 00 00 	cmpl   $0x0,0x80a008
  800316:	74 10                	je     800328 <bc_pgfault+0xae>
  800318:	83 ec 0c             	sub    $0xc,%esp
  80031b:	56                   	push   %esi
  80031c:	e8 0d 05 00 00       	call   80082e <block_is_free>
  800321:	83 c4 10             	add    $0x10,%esp
  800324:	84 c0                	test   %al,%al
  800326:	75 6a                	jne    800392 <bc_pgfault+0x118>
		panic("reading free block %08x\n", blockno);
}
  800328:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80032b:	5b                   	pop    %ebx
  80032c:	5e                   	pop    %esi
  80032d:	5d                   	pop    %ebp
  80032e:	c3                   	ret    
		panic("page fault in FS: eip %08x, va %08x, err %04x",
  80032f:	83 ec 08             	sub    $0x8,%esp
  800332:	ff 72 04             	pushl  0x4(%edx)
  800335:	53                   	push   %ebx
  800336:	ff 72 28             	pushl  0x28(%edx)
  800339:	68 94 3e 80 00       	push   $0x803e94
  80033e:	6a 27                	push   $0x27
  800340:	68 50 3f 80 00       	push   $0x803f50
  800345:	e8 e2 17 00 00       	call   801b2c <_panic>
		panic("reading non-existent block %08x\n", blockno);
  80034a:	56                   	push   %esi
  80034b:	68 c4 3e 80 00       	push   $0x803ec4
  800350:	6a 2b                	push   $0x2b
  800352:	68 50 3f 80 00       	push   $0x803f50
  800357:	e8 d0 17 00 00       	call   801b2c <_panic>
	    panic("bc_pgfault: %e", r);
  80035c:	50                   	push   %eax
  80035d:	68 58 3f 80 00       	push   $0x803f58
  800362:	6a 35                	push   $0x35
  800364:	68 50 3f 80 00       	push   $0x803f50
  800369:	e8 be 17 00 00       	call   801b2c <_panic>
	    panic("bc_pgfault: %e", r);
  80036e:	50                   	push   %eax
  80036f:	68 58 3f 80 00       	push   $0x803f58
  800374:	6a 38                	push   $0x38
  800376:	68 50 3f 80 00       	push   $0x803f50
  80037b:	e8 ac 17 00 00       	call   801b2c <_panic>
		panic("in bc_pgfault, sys_page_map: %e", r);
  800380:	50                   	push   %eax
  800381:	68 e8 3e 80 00       	push   $0x803ee8
  800386:	6a 3e                	push   $0x3e
  800388:	68 50 3f 80 00       	push   $0x803f50
  80038d:	e8 9a 17 00 00       	call   801b2c <_panic>
		panic("reading free block %08x\n", blockno);
  800392:	56                   	push   %esi
  800393:	68 67 3f 80 00       	push   $0x803f67
  800398:	6a 44                	push   $0x44
  80039a:	68 50 3f 80 00       	push   $0x803f50
  80039f:	e8 88 17 00 00       	call   801b2c <_panic>

008003a4 <diskaddr>:
{
  8003a4:	55                   	push   %ebp
  8003a5:	89 e5                	mov    %esp,%ebp
  8003a7:	83 ec 08             	sub    $0x8,%esp
  8003aa:	8b 45 08             	mov    0x8(%ebp),%eax
	if (blockno == 0 || (super && blockno >= super->s_nblocks))
  8003ad:	85 c0                	test   %eax,%eax
  8003af:	74 19                	je     8003ca <diskaddr+0x26>
  8003b1:	8b 15 0c a0 80 00    	mov    0x80a00c,%edx
  8003b7:	85 d2                	test   %edx,%edx
  8003b9:	74 05                	je     8003c0 <diskaddr+0x1c>
  8003bb:	39 42 04             	cmp    %eax,0x4(%edx)
  8003be:	76 0a                	jbe    8003ca <diskaddr+0x26>
	return (char*) (DISKMAP + blockno * BLKSIZE);
  8003c0:	05 00 00 01 00       	add    $0x10000,%eax
  8003c5:	c1 e0 0c             	shl    $0xc,%eax
}
  8003c8:	c9                   	leave  
  8003c9:	c3                   	ret    
		panic("bad block number %08x in diskaddr", blockno);
  8003ca:	50                   	push   %eax
  8003cb:	68 08 3f 80 00       	push   $0x803f08
  8003d0:	6a 09                	push   $0x9
  8003d2:	68 50 3f 80 00       	push   $0x803f50
  8003d7:	e8 50 17 00 00       	call   801b2c <_panic>

008003dc <va_is_mapped>:
{
  8003dc:	55                   	push   %ebp
  8003dd:	89 e5                	mov    %esp,%ebp
  8003df:	8b 55 08             	mov    0x8(%ebp),%edx
	return (uvpd[PDX(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P);
  8003e2:	89 d0                	mov    %edx,%eax
  8003e4:	c1 e8 16             	shr    $0x16,%eax
  8003e7:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
  8003ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8003f3:	f6 c1 01             	test   $0x1,%cl
  8003f6:	74 0d                	je     800405 <va_is_mapped+0x29>
  8003f8:	c1 ea 0c             	shr    $0xc,%edx
  8003fb:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  800402:	83 e0 01             	and    $0x1,%eax
  800405:	83 e0 01             	and    $0x1,%eax
}
  800408:	5d                   	pop    %ebp
  800409:	c3                   	ret    

0080040a <va_is_dirty>:
{
  80040a:	55                   	push   %ebp
  80040b:	89 e5                	mov    %esp,%ebp
	return (uvpt[PGNUM(va)] & PTE_D) != 0;
  80040d:	8b 45 08             	mov    0x8(%ebp),%eax
  800410:	c1 e8 0c             	shr    $0xc,%eax
  800413:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80041a:	c1 e8 06             	shr    $0x6,%eax
  80041d:	83 e0 01             	and    $0x1,%eax
}
  800420:	5d                   	pop    %ebp
  800421:	c3                   	ret    

00800422 <flush_block>:
// Hint: Use va_is_mapped, va_is_dirty, and ide_write.
// Hint: Use the PTE_SYSCALL constant when calling sys_page_map.
// Hint: Don't forget to round addr down.
void
flush_block(void *addr)
{
  800422:	55                   	push   %ebp
  800423:	89 e5                	mov    %esp,%ebp
  800425:	56                   	push   %esi
  800426:	53                   	push   %ebx
  800427:	8b 5d 08             	mov    0x8(%ebp),%ebx
	uint32_t blockno = ((uint32_t)addr - DISKMAP) / BLKSIZE;
	int r;

	if (addr < (void*)DISKMAP || addr >= (void*)(DISKMAP + DISKSIZE))
  80042a:	8d 83 00 00 00 f0    	lea    -0x10000000(%ebx),%eax
  800430:	3d ff ff ff bf       	cmp    $0xbfffffff,%eax
  800435:	77 17                	ja     80044e <flush_block+0x2c>
		panic("flush_block of bad va %08x", addr);

	// LAB 5: Your code here.
	if (!va_is_mapped(addr) || !va_is_dirty(addr)) {
  800437:	83 ec 0c             	sub    $0xc,%esp
  80043a:	53                   	push   %ebx
  80043b:	e8 9c ff ff ff       	call   8003dc <va_is_mapped>
  800440:	83 c4 10             	add    $0x10,%esp
  800443:	84 c0                	test   %al,%al
  800445:	75 19                	jne    800460 <flush_block+0x3e>
	    panic("flush_block: %e", r);
	}
	if ((r = sys_page_map(0, addr, 0, addr, uvpt[PGNUM(addr)] & PTE_SYSCALL)) != 0) {
	    panic("flush_block: %e", r);
	}
}
  800447:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80044a:	5b                   	pop    %ebx
  80044b:	5e                   	pop    %esi
  80044c:	5d                   	pop    %ebp
  80044d:	c3                   	ret    
		panic("flush_block of bad va %08x", addr);
  80044e:	53                   	push   %ebx
  80044f:	68 80 3f 80 00       	push   $0x803f80
  800454:	6a 55                	push   $0x55
  800456:	68 50 3f 80 00       	push   $0x803f50
  80045b:	e8 cc 16 00 00       	call   801b2c <_panic>
	if (!va_is_mapped(addr) || !va_is_dirty(addr)) {
  800460:	83 ec 0c             	sub    $0xc,%esp
  800463:	53                   	push   %ebx
  800464:	e8 a1 ff ff ff       	call   80040a <va_is_dirty>
  800469:	83 c4 10             	add    $0x10,%esp
  80046c:	84 c0                	test   %al,%al
  80046e:	74 d7                	je     800447 <flush_block+0x25>
	addr = ROUNDDOWN(addr, PGSIZE);
  800470:	89 de                	mov    %ebx,%esi
  800472:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
	if ((r = ide_write(blockno * BLKSECTS, addr, BLKSECTS)) != 0) {
  800478:	83 ec 04             	sub    $0x4,%esp
  80047b:	6a 08                	push   $0x8
  80047d:	56                   	push   %esi
	uint32_t blockno = ((uint32_t)addr - DISKMAP) / BLKSIZE;
  80047e:	81 eb 00 00 00 10    	sub    $0x10000000,%ebx
  800484:	c1 eb 0c             	shr    $0xc,%ebx
	if ((r = ide_write(blockno * BLKSECTS, addr, BLKSECTS)) != 0) {
  800487:	c1 e3 03             	shl    $0x3,%ebx
  80048a:	53                   	push   %ebx
  80048b:	e8 22 fd ff ff       	call   8001b2 <ide_write>
  800490:	83 c4 10             	add    $0x10,%esp
  800493:	85 c0                	test   %eax,%eax
  800495:	75 39                	jne    8004d0 <flush_block+0xae>
	if ((r = sys_page_map(0, addr, 0, addr, uvpt[PGNUM(addr)] & PTE_SYSCALL)) != 0) {
  800497:	89 f0                	mov    %esi,%eax
  800499:	c1 e8 0c             	shr    $0xc,%eax
  80049c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8004a3:	83 ec 0c             	sub    $0xc,%esp
  8004a6:	25 07 0e 00 00       	and    $0xe07,%eax
  8004ab:	50                   	push   %eax
  8004ac:	56                   	push   %esi
  8004ad:	6a 00                	push   $0x0
  8004af:	56                   	push   %esi
  8004b0:	6a 00                	push   $0x0
  8004b2:	e8 29 22 00 00       	call   8026e0 <sys_page_map>
  8004b7:	83 c4 20             	add    $0x20,%esp
  8004ba:	85 c0                	test   %eax,%eax
  8004bc:	74 89                	je     800447 <flush_block+0x25>
	    panic("flush_block: %e", r);
  8004be:	50                   	push   %eax
  8004bf:	68 9b 3f 80 00       	push   $0x803f9b
  8004c4:	6a 60                	push   $0x60
  8004c6:	68 50 3f 80 00       	push   $0x803f50
  8004cb:	e8 5c 16 00 00       	call   801b2c <_panic>
	    panic("flush_block: %e", r);
  8004d0:	50                   	push   %eax
  8004d1:	68 9b 3f 80 00       	push   $0x803f9b
  8004d6:	6a 5d                	push   $0x5d
  8004d8:	68 50 3f 80 00       	push   $0x803f50
  8004dd:	e8 4a 16 00 00       	call   801b2c <_panic>

008004e2 <bc_init>:
	cprintf("block cache is good\n");
}

void
bc_init(void)
{
  8004e2:	55                   	push   %ebp
  8004e3:	89 e5                	mov    %esp,%ebp
  8004e5:	53                   	push   %ebx
  8004e6:	81 ec 20 02 00 00    	sub    $0x220,%esp
	struct Super super;
	set_pgfault_handler(bc_pgfault);
  8004ec:	68 7a 02 80 00       	push   $0x80027a
  8004f1:	e8 b7 23 00 00       	call   8028ad <set_pgfault_handler>
	memmove(&backup, diskaddr(1), sizeof backup);
  8004f6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8004fd:	e8 a2 fe ff ff       	call   8003a4 <diskaddr>
  800502:	83 c4 0c             	add    $0xc,%esp
  800505:	68 08 01 00 00       	push   $0x108
  80050a:	50                   	push   %eax
  80050b:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  800511:	50                   	push   %eax
  800512:	e8 1b 1f 00 00       	call   802432 <memmove>
	strcpy(diskaddr(1), "OOPS!\n");
  800517:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80051e:	e8 81 fe ff ff       	call   8003a4 <diskaddr>
  800523:	83 c4 08             	add    $0x8,%esp
  800526:	68 ab 3f 80 00       	push   $0x803fab
  80052b:	50                   	push   %eax
  80052c:	e8 73 1d 00 00       	call   8022a4 <strcpy>
	flush_block(diskaddr(1));
  800531:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800538:	e8 67 fe ff ff       	call   8003a4 <diskaddr>
  80053d:	89 04 24             	mov    %eax,(%esp)
  800540:	e8 dd fe ff ff       	call   800422 <flush_block>
	assert(va_is_mapped(diskaddr(1)));
  800545:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80054c:	e8 53 fe ff ff       	call   8003a4 <diskaddr>
  800551:	89 04 24             	mov    %eax,(%esp)
  800554:	e8 83 fe ff ff       	call   8003dc <va_is_mapped>
  800559:	83 c4 10             	add    $0x10,%esp
  80055c:	84 c0                	test   %al,%al
  80055e:	0f 84 d1 01 00 00    	je     800735 <bc_init+0x253>
	assert(!va_is_dirty(diskaddr(1)));
  800564:	83 ec 0c             	sub    $0xc,%esp
  800567:	6a 01                	push   $0x1
  800569:	e8 36 fe ff ff       	call   8003a4 <diskaddr>
  80056e:	89 04 24             	mov    %eax,(%esp)
  800571:	e8 94 fe ff ff       	call   80040a <va_is_dirty>
  800576:	83 c4 10             	add    $0x10,%esp
  800579:	84 c0                	test   %al,%al
  80057b:	0f 85 ca 01 00 00    	jne    80074b <bc_init+0x269>
	sys_page_unmap(0, diskaddr(1));
  800581:	83 ec 0c             	sub    $0xc,%esp
  800584:	6a 01                	push   $0x1
  800586:	e8 19 fe ff ff       	call   8003a4 <diskaddr>
  80058b:	83 c4 08             	add    $0x8,%esp
  80058e:	50                   	push   %eax
  80058f:	6a 00                	push   $0x0
  800591:	e8 8c 21 00 00       	call   802722 <sys_page_unmap>
	assert(!va_is_mapped(diskaddr(1)));
  800596:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80059d:	e8 02 fe ff ff       	call   8003a4 <diskaddr>
  8005a2:	89 04 24             	mov    %eax,(%esp)
  8005a5:	e8 32 fe ff ff       	call   8003dc <va_is_mapped>
  8005aa:	83 c4 10             	add    $0x10,%esp
  8005ad:	84 c0                	test   %al,%al
  8005af:	0f 85 ac 01 00 00    	jne    800761 <bc_init+0x27f>
	assert(strcmp(diskaddr(1), "OOPS!\n") == 0);
  8005b5:	83 ec 0c             	sub    $0xc,%esp
  8005b8:	6a 01                	push   $0x1
  8005ba:	e8 e5 fd ff ff       	call   8003a4 <diskaddr>
  8005bf:	83 c4 08             	add    $0x8,%esp
  8005c2:	68 ab 3f 80 00       	push   $0x803fab
  8005c7:	50                   	push   %eax
  8005c8:	e8 7d 1d 00 00       	call   80234a <strcmp>
  8005cd:	83 c4 10             	add    $0x10,%esp
  8005d0:	85 c0                	test   %eax,%eax
  8005d2:	0f 85 9f 01 00 00    	jne    800777 <bc_init+0x295>
	memmove(diskaddr(1), &backup, sizeof backup);
  8005d8:	83 ec 0c             	sub    $0xc,%esp
  8005db:	6a 01                	push   $0x1
  8005dd:	e8 c2 fd ff ff       	call   8003a4 <diskaddr>
  8005e2:	83 c4 0c             	add    $0xc,%esp
  8005e5:	68 08 01 00 00       	push   $0x108
  8005ea:	8d 9d e8 fd ff ff    	lea    -0x218(%ebp),%ebx
  8005f0:	53                   	push   %ebx
  8005f1:	50                   	push   %eax
  8005f2:	e8 3b 1e 00 00       	call   802432 <memmove>
	flush_block(diskaddr(1));
  8005f7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8005fe:	e8 a1 fd ff ff       	call   8003a4 <diskaddr>
  800603:	89 04 24             	mov    %eax,(%esp)
  800606:	e8 17 fe ff ff       	call   800422 <flush_block>
	memmove(&backup, diskaddr(1), sizeof backup);
  80060b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800612:	e8 8d fd ff ff       	call   8003a4 <diskaddr>
  800617:	83 c4 0c             	add    $0xc,%esp
  80061a:	68 08 01 00 00       	push   $0x108
  80061f:	50                   	push   %eax
  800620:	53                   	push   %ebx
  800621:	e8 0c 1e 00 00       	call   802432 <memmove>
	strcpy(diskaddr(1), "OOPS!\n");
  800626:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80062d:	e8 72 fd ff ff       	call   8003a4 <diskaddr>
  800632:	83 c4 08             	add    $0x8,%esp
  800635:	68 ab 3f 80 00       	push   $0x803fab
  80063a:	50                   	push   %eax
  80063b:	e8 64 1c 00 00       	call   8022a4 <strcpy>
	flush_block(diskaddr(1) + 20);
  800640:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800647:	e8 58 fd ff ff       	call   8003a4 <diskaddr>
  80064c:	83 c0 14             	add    $0x14,%eax
  80064f:	89 04 24             	mov    %eax,(%esp)
  800652:	e8 cb fd ff ff       	call   800422 <flush_block>
	assert(va_is_mapped(diskaddr(1)));
  800657:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80065e:	e8 41 fd ff ff       	call   8003a4 <diskaddr>
  800663:	89 04 24             	mov    %eax,(%esp)
  800666:	e8 71 fd ff ff       	call   8003dc <va_is_mapped>
  80066b:	83 c4 10             	add    $0x10,%esp
  80066e:	84 c0                	test   %al,%al
  800670:	0f 84 17 01 00 00    	je     80078d <bc_init+0x2ab>
	sys_page_unmap(0, diskaddr(1));
  800676:	83 ec 0c             	sub    $0xc,%esp
  800679:	6a 01                	push   $0x1
  80067b:	e8 24 fd ff ff       	call   8003a4 <diskaddr>
  800680:	83 c4 08             	add    $0x8,%esp
  800683:	50                   	push   %eax
  800684:	6a 00                	push   $0x0
  800686:	e8 97 20 00 00       	call   802722 <sys_page_unmap>
	assert(!va_is_mapped(diskaddr(1)));
  80068b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800692:	e8 0d fd ff ff       	call   8003a4 <diskaddr>
  800697:	89 04 24             	mov    %eax,(%esp)
  80069a:	e8 3d fd ff ff       	call   8003dc <va_is_mapped>
  80069f:	83 c4 10             	add    $0x10,%esp
  8006a2:	84 c0                	test   %al,%al
  8006a4:	0f 85 fc 00 00 00    	jne    8007a6 <bc_init+0x2c4>
	assert(strcmp(diskaddr(1), "OOPS!\n") == 0);
  8006aa:	83 ec 0c             	sub    $0xc,%esp
  8006ad:	6a 01                	push   $0x1
  8006af:	e8 f0 fc ff ff       	call   8003a4 <diskaddr>
  8006b4:	83 c4 08             	add    $0x8,%esp
  8006b7:	68 ab 3f 80 00       	push   $0x803fab
  8006bc:	50                   	push   %eax
  8006bd:	e8 88 1c 00 00       	call   80234a <strcmp>
  8006c2:	83 c4 10             	add    $0x10,%esp
  8006c5:	85 c0                	test   %eax,%eax
  8006c7:	0f 85 f2 00 00 00    	jne    8007bf <bc_init+0x2dd>
	memmove(diskaddr(1), &backup, sizeof backup);
  8006cd:	83 ec 0c             	sub    $0xc,%esp
  8006d0:	6a 01                	push   $0x1
  8006d2:	e8 cd fc ff ff       	call   8003a4 <diskaddr>
  8006d7:	83 c4 0c             	add    $0xc,%esp
  8006da:	68 08 01 00 00       	push   $0x108
  8006df:	8d 95 e8 fd ff ff    	lea    -0x218(%ebp),%edx
  8006e5:	52                   	push   %edx
  8006e6:	50                   	push   %eax
  8006e7:	e8 46 1d 00 00       	call   802432 <memmove>
	flush_block(diskaddr(1));
  8006ec:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8006f3:	e8 ac fc ff ff       	call   8003a4 <diskaddr>
  8006f8:	89 04 24             	mov    %eax,(%esp)
  8006fb:	e8 22 fd ff ff       	call   800422 <flush_block>
	cprintf("block cache is good\n");
  800700:	c7 04 24 e7 3f 80 00 	movl   $0x803fe7,(%esp)
  800707:	e8 fb 14 00 00       	call   801c07 <cprintf>
	check_bc();

	// cache the super block by reading it once
	memmove(&super, diskaddr(1), sizeof super);
  80070c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800713:	e8 8c fc ff ff       	call   8003a4 <diskaddr>
  800718:	83 c4 0c             	add    $0xc,%esp
  80071b:	68 08 01 00 00       	push   $0x108
  800720:	50                   	push   %eax
  800721:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800727:	50                   	push   %eax
  800728:	e8 05 1d 00 00       	call   802432 <memmove>
}
  80072d:	83 c4 10             	add    $0x10,%esp
  800730:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800733:	c9                   	leave  
  800734:	c3                   	ret    
	assert(va_is_mapped(diskaddr(1)));
  800735:	68 cd 3f 80 00       	push   $0x803fcd
  80073a:	68 7d 3e 80 00       	push   $0x803e7d
  80073f:	6a 71                	push   $0x71
  800741:	68 50 3f 80 00       	push   $0x803f50
  800746:	e8 e1 13 00 00       	call   801b2c <_panic>
	assert(!va_is_dirty(diskaddr(1)));
  80074b:	68 b2 3f 80 00       	push   $0x803fb2
  800750:	68 7d 3e 80 00       	push   $0x803e7d
  800755:	6a 72                	push   $0x72
  800757:	68 50 3f 80 00       	push   $0x803f50
  80075c:	e8 cb 13 00 00       	call   801b2c <_panic>
	assert(!va_is_mapped(diskaddr(1)));
  800761:	68 cc 3f 80 00       	push   $0x803fcc
  800766:	68 7d 3e 80 00       	push   $0x803e7d
  80076b:	6a 76                	push   $0x76
  80076d:	68 50 3f 80 00       	push   $0x803f50
  800772:	e8 b5 13 00 00       	call   801b2c <_panic>
	assert(strcmp(diskaddr(1), "OOPS!\n") == 0);
  800777:	68 2c 3f 80 00       	push   $0x803f2c
  80077c:	68 7d 3e 80 00       	push   $0x803e7d
  800781:	6a 79                	push   $0x79
  800783:	68 50 3f 80 00       	push   $0x803f50
  800788:	e8 9f 13 00 00       	call   801b2c <_panic>
	assert(va_is_mapped(diskaddr(1)));
  80078d:	68 cd 3f 80 00       	push   $0x803fcd
  800792:	68 7d 3e 80 00       	push   $0x803e7d
  800797:	68 8a 00 00 00       	push   $0x8a
  80079c:	68 50 3f 80 00       	push   $0x803f50
  8007a1:	e8 86 13 00 00       	call   801b2c <_panic>
	assert(!va_is_mapped(diskaddr(1)));
  8007a6:	68 cc 3f 80 00       	push   $0x803fcc
  8007ab:	68 7d 3e 80 00       	push   $0x803e7d
  8007b0:	68 92 00 00 00       	push   $0x92
  8007b5:	68 50 3f 80 00       	push   $0x803f50
  8007ba:	e8 6d 13 00 00       	call   801b2c <_panic>
	assert(strcmp(diskaddr(1), "OOPS!\n") == 0);
  8007bf:	68 2c 3f 80 00       	push   $0x803f2c
  8007c4:	68 7d 3e 80 00       	push   $0x803e7d
  8007c9:	68 95 00 00 00       	push   $0x95
  8007ce:	68 50 3f 80 00       	push   $0x803f50
  8007d3:	e8 54 13 00 00       	call   801b2c <_panic>

008007d8 <check_super>:
// --------------------------------------------------------------

// Validate the file system super-block.
void
check_super(void)
{
  8007d8:	55                   	push   %ebp
  8007d9:	89 e5                	mov    %esp,%ebp
  8007db:	83 ec 08             	sub    $0x8,%esp
	if (super->s_magic != FS_MAGIC)
  8007de:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  8007e3:	81 38 ae 30 05 4a    	cmpl   $0x4a0530ae,(%eax)
  8007e9:	75 1b                	jne    800806 <check_super+0x2e>
		panic("bad file system magic number");

	if (super->s_nblocks > DISKSIZE/BLKSIZE)
  8007eb:	81 78 04 00 00 0c 00 	cmpl   $0xc0000,0x4(%eax)
  8007f2:	77 26                	ja     80081a <check_super+0x42>
		panic("file system is too large");

	cprintf("superblock is good\n");
  8007f4:	83 ec 0c             	sub    $0xc,%esp
  8007f7:	68 3a 40 80 00       	push   $0x80403a
  8007fc:	e8 06 14 00 00       	call   801c07 <cprintf>
}
  800801:	83 c4 10             	add    $0x10,%esp
  800804:	c9                   	leave  
  800805:	c3                   	ret    
		panic("bad file system magic number");
  800806:	83 ec 04             	sub    $0x4,%esp
  800809:	68 fc 3f 80 00       	push   $0x803ffc
  80080e:	6a 0f                	push   $0xf
  800810:	68 19 40 80 00       	push   $0x804019
  800815:	e8 12 13 00 00       	call   801b2c <_panic>
		panic("file system is too large");
  80081a:	83 ec 04             	sub    $0x4,%esp
  80081d:	68 21 40 80 00       	push   $0x804021
  800822:	6a 12                	push   $0x12
  800824:	68 19 40 80 00       	push   $0x804019
  800829:	e8 fe 12 00 00       	call   801b2c <_panic>

0080082e <block_is_free>:

// Check to see if the block bitmap indicates that block 'blockno' is free.
// Return 1 if the block is free, 0 if not.
bool
block_is_free(uint32_t blockno)
{
  80082e:	55                   	push   %ebp
  80082f:	89 e5                	mov    %esp,%ebp
  800831:	53                   	push   %ebx
  800832:	8b 4d 08             	mov    0x8(%ebp),%ecx
	if (super == 0 || blockno >= super->s_nblocks)
  800835:	8b 15 0c a0 80 00    	mov    0x80a00c,%edx
		return 0;
  80083b:	b8 00 00 00 00       	mov    $0x0,%eax
	if (super == 0 || blockno >= super->s_nblocks)
  800840:	85 d2                	test   %edx,%edx
  800842:	74 1d                	je     800861 <block_is_free+0x33>
  800844:	39 4a 04             	cmp    %ecx,0x4(%edx)
  800847:	76 18                	jbe    800861 <block_is_free+0x33>
	if (bitmap[blockno / 32] & (1 << (blockno % 32)))
  800849:	89 cb                	mov    %ecx,%ebx
  80084b:	c1 eb 05             	shr    $0x5,%ebx
  80084e:	b8 01 00 00 00       	mov    $0x1,%eax
  800853:	d3 e0                	shl    %cl,%eax
  800855:	8b 15 08 a0 80 00    	mov    0x80a008,%edx
  80085b:	85 04 9a             	test   %eax,(%edx,%ebx,4)
  80085e:	0f 95 c0             	setne  %al
		return 1;
	return 0;
}
  800861:	5b                   	pop    %ebx
  800862:	5d                   	pop    %ebp
  800863:	c3                   	ret    

00800864 <free_block>:

// Mark a block free in the bitmap
void
free_block(uint32_t blockno)
{
  800864:	55                   	push   %ebp
  800865:	89 e5                	mov    %esp,%ebp
  800867:	53                   	push   %ebx
  800868:	83 ec 04             	sub    $0x4,%esp
  80086b:	8b 4d 08             	mov    0x8(%ebp),%ecx
	// Blockno zero is the null pointer of block numbers.
	if (blockno == 0)
  80086e:	85 c9                	test   %ecx,%ecx
  800870:	74 1a                	je     80088c <free_block+0x28>
		panic("attempt to free zero block");
	bitmap[blockno/32] |= 1<<(blockno%32);
  800872:	89 cb                	mov    %ecx,%ebx
  800874:	c1 eb 05             	shr    $0x5,%ebx
  800877:	8b 15 08 a0 80 00    	mov    0x80a008,%edx
  80087d:	b8 01 00 00 00       	mov    $0x1,%eax
  800882:	d3 e0                	shl    %cl,%eax
  800884:	09 04 9a             	or     %eax,(%edx,%ebx,4)
}
  800887:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80088a:	c9                   	leave  
  80088b:	c3                   	ret    
		panic("attempt to free zero block");
  80088c:	83 ec 04             	sub    $0x4,%esp
  80088f:	68 4e 40 80 00       	push   $0x80404e
  800894:	6a 2d                	push   $0x2d
  800896:	68 19 40 80 00       	push   $0x804019
  80089b:	e8 8c 12 00 00       	call   801b2c <_panic>

008008a0 <alloc_block>:
// -E_NO_DISK if we are out of blocks.
//
// Hint: use free_block as an example for manipulating the bitmap.
int
alloc_block(void)
{
  8008a0:	55                   	push   %ebp
  8008a1:	89 e5                	mov    %esp,%ebp
  8008a3:	56                   	push   %esi
  8008a4:	53                   	push   %ebx
	// super->s_nblocks blocks in the disk altogether.

	// LAB 5: Your code here.
	int i;

	for (i = 0; i < super->s_nblocks; i++) {
  8008a5:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  8008aa:	8b 70 04             	mov    0x4(%eax),%esi
  8008ad:	bb 00 00 00 00       	mov    $0x0,%ebx
  8008b2:	39 f3                	cmp    %esi,%ebx
  8008b4:	74 55                	je     80090b <alloc_block+0x6b>
	    if (block_is_free(i)) {
  8008b6:	53                   	push   %ebx
  8008b7:	e8 72 ff ff ff       	call   80082e <block_is_free>
  8008bc:	83 c4 04             	add    $0x4,%esp
  8008bf:	84 c0                	test   %al,%al
  8008c1:	75 05                	jne    8008c8 <alloc_block+0x28>
	for (i = 0; i < super->s_nblocks; i++) {
  8008c3:	83 c3 01             	add    $0x1,%ebx
  8008c6:	eb ea                	jmp    8008b2 <alloc_block+0x12>
	        bitmap[i / 32] &= ~(1 << (i % 32));
  8008c8:	8d 43 1f             	lea    0x1f(%ebx),%eax
  8008cb:	85 db                	test   %ebx,%ebx
  8008cd:	0f 49 c3             	cmovns %ebx,%eax
  8008d0:	c1 f8 05             	sar    $0x5,%eax
  8008d3:	c1 e0 02             	shl    $0x2,%eax
  8008d6:	89 c2                	mov    %eax,%edx
  8008d8:	03 15 08 a0 80 00    	add    0x80a008,%edx
  8008de:	89 de                	mov    %ebx,%esi
  8008e0:	c1 fe 1f             	sar    $0x1f,%esi
  8008e3:	c1 ee 1b             	shr    $0x1b,%esi
  8008e6:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
  8008e9:	83 e1 1f             	and    $0x1f,%ecx
  8008ec:	29 f1                	sub    %esi,%ecx
  8008ee:	be fe ff ff ff       	mov    $0xfffffffe,%esi
  8008f3:	d3 c6                	rol    %cl,%esi
  8008f5:	21 32                	and    %esi,(%edx)
	        flush_block(&bitmap[i / 32]);
  8008f7:	83 ec 0c             	sub    $0xc,%esp
  8008fa:	03 05 08 a0 80 00    	add    0x80a008,%eax
  800900:	50                   	push   %eax
  800901:	e8 1c fb ff ff       	call   800422 <flush_block>
	        return i;
  800906:	83 c4 10             	add    $0x10,%esp
  800909:	eb 05                	jmp    800910 <alloc_block+0x70>
	    }
	}
	return -E_NO_DISK;
  80090b:	bb f7 ff ff ff       	mov    $0xfffffff7,%ebx
}
  800910:	89 d8                	mov    %ebx,%eax
  800912:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800915:	5b                   	pop    %ebx
  800916:	5e                   	pop    %esi
  800917:	5d                   	pop    %ebp
  800918:	c3                   	ret    

00800919 <file_block_walk>:
//
// Analogy: This is like pgdir_walk for files.
// Hint: Don't forget to clear any block you allocate.
static int
file_block_walk(struct File *f, uint32_t filebno, uint32_t **ppdiskbno, bool alloc)
{
  800919:	55                   	push   %ebp
  80091a:	89 e5                	mov    %esp,%ebp
  80091c:	57                   	push   %edi
  80091d:	56                   	push   %esi
  80091e:	53                   	push   %ebx
  80091f:	83 ec 0c             	sub    $0xc,%esp
  800922:	89 ce                	mov    %ecx,%esi
  800924:	8b 4d 08             	mov    0x8(%ebp),%ecx
    // LAB 5: Your code here.
    if (filebno >= NDIRECT + NINDIRECT) {
  800927:	81 fa 09 04 00 00    	cmp    $0x409,%edx
  80092d:	77 7c                	ja     8009ab <file_block_walk+0x92>
  80092f:	89 d3                	mov    %edx,%ebx
        return -E_INVAL;
    }
    if (filebno < NDIRECT) {
  800931:	83 fa 09             	cmp    $0x9,%edx
  800934:	76 3c                	jbe    800972 <file_block_walk+0x59>
        *ppdiskbno = &f->f_direct[filebno];
    } else {
        if (!f->f_indirect && !alloc) {
  800936:	8b 90 b0 00 00 00    	mov    0xb0(%eax),%edx
  80093c:	85 d2                	test   %edx,%edx
  80093e:	75 04                	jne    800944 <file_block_walk+0x2b>
  800940:	84 c9                	test   %cl,%cl
  800942:	74 6e                	je     8009b2 <file_block_walk+0x99>
  800944:	89 c7                	mov    %eax,%edi
            return -E_NOT_FOUND;
        }
        if (!f->f_indirect && alloc) {
  800946:	85 d2                	test   %edx,%edx
  800948:	75 04                	jne    80094e <file_block_walk+0x35>
  80094a:	84 c9                	test   %cl,%cl
  80094c:	75 34                	jne    800982 <file_block_walk+0x69>
                return -E_NO_DISK;
            }
            f->f_indirect = newbno;
            memset(diskaddr(newbno), 0, BLKSIZE);
        }
        *ppdiskbno = &((uint32_t *)diskaddr(f->f_indirect))[filebno - NDIRECT];
  80094e:	83 ec 0c             	sub    $0xc,%esp
  800951:	ff b7 b0 00 00 00    	pushl  0xb0(%edi)
  800957:	e8 48 fa ff ff       	call   8003a4 <diskaddr>
  80095c:	8d 44 98 d8          	lea    -0x28(%eax,%ebx,4),%eax
  800960:	89 06                	mov    %eax,(%esi)
  800962:	83 c4 10             	add    $0x10,%esp
    }
    return 0;
  800965:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80096a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80096d:	5b                   	pop    %ebx
  80096e:	5e                   	pop    %esi
  80096f:	5f                   	pop    %edi
  800970:	5d                   	pop    %ebp
  800971:	c3                   	ret    
        *ppdiskbno = &f->f_direct[filebno];
  800972:	8d 84 90 88 00 00 00 	lea    0x88(%eax,%edx,4),%eax
  800979:	89 06                	mov    %eax,(%esi)
    return 0;
  80097b:	b8 00 00 00 00       	mov    $0x0,%eax
  800980:	eb e8                	jmp    80096a <file_block_walk+0x51>
            if ((newbno = alloc_block()) < 0) {
  800982:	e8 19 ff ff ff       	call   8008a0 <alloc_block>
            f->f_indirect = newbno;
  800987:	89 87 b0 00 00 00    	mov    %eax,0xb0(%edi)
            memset(diskaddr(newbno), 0, BLKSIZE);
  80098d:	83 ec 0c             	sub    $0xc,%esp
  800990:	50                   	push   %eax
  800991:	e8 0e fa ff ff       	call   8003a4 <diskaddr>
  800996:	83 c4 0c             	add    $0xc,%esp
  800999:	68 00 10 00 00       	push   $0x1000
  80099e:	6a 00                	push   $0x0
  8009a0:	50                   	push   %eax
  8009a1:	e8 3f 1a 00 00       	call   8023e5 <memset>
  8009a6:	83 c4 10             	add    $0x10,%esp
  8009a9:	eb a3                	jmp    80094e <file_block_walk+0x35>
        return -E_INVAL;
  8009ab:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009b0:	eb b8                	jmp    80096a <file_block_walk+0x51>
            return -E_NOT_FOUND;
  8009b2:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
  8009b7:	eb b1                	jmp    80096a <file_block_walk+0x51>

008009b9 <check_bitmap>:
{
  8009b9:	55                   	push   %ebp
  8009ba:	89 e5                	mov    %esp,%ebp
  8009bc:	56                   	push   %esi
  8009bd:	53                   	push   %ebx
	for (i = 0; i * BLKBITSIZE < super->s_nblocks; i++)
  8009be:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  8009c3:	8b 70 04             	mov    0x4(%eax),%esi
  8009c6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8009cb:	89 d8                	mov    %ebx,%eax
  8009cd:	c1 e0 0f             	shl    $0xf,%eax
  8009d0:	39 c6                	cmp    %eax,%esi
  8009d2:	76 2b                	jbe    8009ff <check_bitmap+0x46>
		assert(!block_is_free(2+i));
  8009d4:	8d 43 02             	lea    0x2(%ebx),%eax
  8009d7:	50                   	push   %eax
  8009d8:	e8 51 fe ff ff       	call   80082e <block_is_free>
  8009dd:	83 c4 04             	add    $0x4,%esp
  8009e0:	84 c0                	test   %al,%al
  8009e2:	75 05                	jne    8009e9 <check_bitmap+0x30>
	for (i = 0; i * BLKBITSIZE < super->s_nblocks; i++)
  8009e4:	83 c3 01             	add    $0x1,%ebx
  8009e7:	eb e2                	jmp    8009cb <check_bitmap+0x12>
		assert(!block_is_free(2+i));
  8009e9:	68 69 40 80 00       	push   $0x804069
  8009ee:	68 7d 3e 80 00       	push   $0x803e7d
  8009f3:	6a 58                	push   $0x58
  8009f5:	68 19 40 80 00       	push   $0x804019
  8009fa:	e8 2d 11 00 00       	call   801b2c <_panic>
	assert(!block_is_free(0));
  8009ff:	83 ec 0c             	sub    $0xc,%esp
  800a02:	6a 00                	push   $0x0
  800a04:	e8 25 fe ff ff       	call   80082e <block_is_free>
  800a09:	83 c4 10             	add    $0x10,%esp
  800a0c:	84 c0                	test   %al,%al
  800a0e:	75 28                	jne    800a38 <check_bitmap+0x7f>
	assert(!block_is_free(1));
  800a10:	83 ec 0c             	sub    $0xc,%esp
  800a13:	6a 01                	push   $0x1
  800a15:	e8 14 fe ff ff       	call   80082e <block_is_free>
  800a1a:	83 c4 10             	add    $0x10,%esp
  800a1d:	84 c0                	test   %al,%al
  800a1f:	75 2d                	jne    800a4e <check_bitmap+0x95>
	cprintf("bitmap is good\n");
  800a21:	83 ec 0c             	sub    $0xc,%esp
  800a24:	68 a1 40 80 00       	push   $0x8040a1
  800a29:	e8 d9 11 00 00       	call   801c07 <cprintf>
}
  800a2e:	83 c4 10             	add    $0x10,%esp
  800a31:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a34:	5b                   	pop    %ebx
  800a35:	5e                   	pop    %esi
  800a36:	5d                   	pop    %ebp
  800a37:	c3                   	ret    
	assert(!block_is_free(0));
  800a38:	68 7d 40 80 00       	push   $0x80407d
  800a3d:	68 7d 3e 80 00       	push   $0x803e7d
  800a42:	6a 5b                	push   $0x5b
  800a44:	68 19 40 80 00       	push   $0x804019
  800a49:	e8 de 10 00 00       	call   801b2c <_panic>
	assert(!block_is_free(1));
  800a4e:	68 8f 40 80 00       	push   $0x80408f
  800a53:	68 7d 3e 80 00       	push   $0x803e7d
  800a58:	6a 5c                	push   $0x5c
  800a5a:	68 19 40 80 00       	push   $0x804019
  800a5f:	e8 c8 10 00 00       	call   801b2c <_panic>

00800a64 <fs_init>:
{
  800a64:	55                   	push   %ebp
  800a65:	89 e5                	mov    %esp,%ebp
  800a67:	83 ec 08             	sub    $0x8,%esp
	if (ide_probe_disk1())
  800a6a:	e8 f0 f5 ff ff       	call   80005f <ide_probe_disk1>
  800a6f:	84 c0                	test   %al,%al
  800a71:	75 41                	jne    800ab4 <fs_init+0x50>
		ide_set_disk(0);
  800a73:	83 ec 0c             	sub    $0xc,%esp
  800a76:	6a 00                	push   $0x0
  800a78:	e8 44 f6 ff ff       	call   8000c1 <ide_set_disk>
  800a7d:	83 c4 10             	add    $0x10,%esp
	bc_init();
  800a80:	e8 5d fa ff ff       	call   8004e2 <bc_init>
	super = diskaddr(1);
  800a85:	83 ec 0c             	sub    $0xc,%esp
  800a88:	6a 01                	push   $0x1
  800a8a:	e8 15 f9 ff ff       	call   8003a4 <diskaddr>
  800a8f:	a3 0c a0 80 00       	mov    %eax,0x80a00c
	check_super();
  800a94:	e8 3f fd ff ff       	call   8007d8 <check_super>
	bitmap = diskaddr(2);
  800a99:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  800aa0:	e8 ff f8 ff ff       	call   8003a4 <diskaddr>
  800aa5:	a3 08 a0 80 00       	mov    %eax,0x80a008
	check_bitmap();
  800aaa:	e8 0a ff ff ff       	call   8009b9 <check_bitmap>
}
  800aaf:	83 c4 10             	add    $0x10,%esp
  800ab2:	c9                   	leave  
  800ab3:	c3                   	ret    
		ide_set_disk(1);
  800ab4:	83 ec 0c             	sub    $0xc,%esp
  800ab7:	6a 01                	push   $0x1
  800ab9:	e8 03 f6 ff ff       	call   8000c1 <ide_set_disk>
  800abe:	83 c4 10             	add    $0x10,%esp
  800ac1:	eb bd                	jmp    800a80 <fs_init+0x1c>

00800ac3 <file_get_block>:
//	-E_INVAL if filebno is out of range.
//
// Hint: Use file_block_walk and alloc_block.
int
file_get_block(struct File *f, uint32_t filebno, char **blk)
{
  800ac3:	55                   	push   %ebp
  800ac4:	89 e5                	mov    %esp,%ebp
  800ac6:	53                   	push   %ebx
  800ac7:	83 ec 20             	sub    $0x20,%esp
    // LAB 5: Your code here.
    uint32_t *pdiskbno;
    int r;

    if ((r = file_block_walk(f, filebno, &pdiskbno, 1)) != 0) {
  800aca:	6a 01                	push   $0x1
  800acc:	8d 4d f4             	lea    -0xc(%ebp),%ecx
  800acf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad5:	e8 3f fe ff ff       	call   800919 <file_block_walk>
  800ada:	89 c3                	mov    %eax,%ebx
  800adc:	83 c4 10             	add    $0x10,%esp
  800adf:	85 c0                	test   %eax,%eax
  800ae1:	75 1d                	jne    800b00 <file_get_block+0x3d>
        return r;
    }
    if (!*pdiskbno) {
  800ae3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ae6:	83 38 00             	cmpl   $0x0,(%eax)
  800ae9:	74 1c                	je     800b07 <file_get_block+0x44>
            return -E_NO_DISK;
        }
        *pdiskbno = newbno;
        memset(diskaddr(newbno), 0, BLKSIZE);
    }
    *blk = diskaddr(*pdiskbno);
  800aeb:	83 ec 0c             	sub    $0xc,%esp
  800aee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800af1:	ff 30                	pushl  (%eax)
  800af3:	e8 ac f8 ff ff       	call   8003a4 <diskaddr>
  800af8:	8b 55 10             	mov    0x10(%ebp),%edx
  800afb:	89 02                	mov    %eax,(%edx)
    return 0;
  800afd:	83 c4 10             	add    $0x10,%esp
}
  800b00:	89 d8                	mov    %ebx,%eax
  800b02:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b05:	c9                   	leave  
  800b06:	c3                   	ret    
        if ((newbno = alloc_block()) < 0) {
  800b07:	e8 94 fd ff ff       	call   8008a0 <alloc_block>
        *pdiskbno = newbno;
  800b0c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b0f:	89 02                	mov    %eax,(%edx)
        memset(diskaddr(newbno), 0, BLKSIZE);
  800b11:	83 ec 0c             	sub    $0xc,%esp
  800b14:	50                   	push   %eax
  800b15:	e8 8a f8 ff ff       	call   8003a4 <diskaddr>
  800b1a:	83 c4 0c             	add    $0xc,%esp
  800b1d:	68 00 10 00 00       	push   $0x1000
  800b22:	6a 00                	push   $0x0
  800b24:	50                   	push   %eax
  800b25:	e8 bb 18 00 00       	call   8023e5 <memset>
  800b2a:	83 c4 10             	add    $0x10,%esp
  800b2d:	eb bc                	jmp    800aeb <file_get_block+0x28>

00800b2f <walk_path>:
// If we cannot find the file but find the directory
// it should be in, set *pdir and copy the final path
// element into lastelem.
static int
walk_path(const char *path, struct File **pdir, struct File **pf, char *lastelem)
{
  800b2f:	55                   	push   %ebp
  800b30:	89 e5                	mov    %esp,%ebp
  800b32:	57                   	push   %edi
  800b33:	56                   	push   %esi
  800b34:	53                   	push   %ebx
  800b35:	81 ec bc 00 00 00    	sub    $0xbc,%esp
  800b3b:	89 95 40 ff ff ff    	mov    %edx,-0xc0(%ebp)
  800b41:	89 8d 3c ff ff ff    	mov    %ecx,-0xc4(%ebp)
  800b47:	eb 03                	jmp    800b4c <walk_path+0x1d>
		p++;
  800b49:	83 c0 01             	add    $0x1,%eax
	while (*p == '/')
  800b4c:	80 38 2f             	cmpb   $0x2f,(%eax)
  800b4f:	74 f8                	je     800b49 <walk_path+0x1a>
	int r;

	// if (*path != '/')
	//	return -E_BAD_PATH;
	path = skip_slash(path);
	f = &super->s_root;
  800b51:	8b 0d 0c a0 80 00    	mov    0x80a00c,%ecx
  800b57:	83 c1 08             	add    $0x8,%ecx
  800b5a:	89 8d 4c ff ff ff    	mov    %ecx,-0xb4(%ebp)
	dir = 0;
	name[0] = 0;
  800b60:	c6 85 68 ff ff ff 00 	movb   $0x0,-0x98(%ebp)

	if (pdir)
  800b67:	8b 8d 40 ff ff ff    	mov    -0xc0(%ebp),%ecx
  800b6d:	85 c9                	test   %ecx,%ecx
  800b6f:	74 06                	je     800b77 <walk_path+0x48>
		*pdir = 0;
  800b71:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	*pf = 0;
  800b77:	8b 8d 3c ff ff ff    	mov    -0xc4(%ebp),%ecx
  800b7d:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	dir = 0;
  800b83:	ba 00 00 00 00       	mov    $0x0,%edx
	while (*path != '\0') {
  800b88:	e9 b4 01 00 00       	jmp    800d41 <walk_path+0x212>
		dir = f;
		p = path;
		while (*path != '/' && *path != '\0')
			path++;
  800b8d:	83 c7 01             	add    $0x1,%edi
		while (*path != '/' && *path != '\0')
  800b90:	0f b6 17             	movzbl (%edi),%edx
  800b93:	80 fa 2f             	cmp    $0x2f,%dl
  800b96:	74 04                	je     800b9c <walk_path+0x6d>
  800b98:	84 d2                	test   %dl,%dl
  800b9a:	75 f1                	jne    800b8d <walk_path+0x5e>
		if (path - p >= MAXNAMELEN)
  800b9c:	89 fb                	mov    %edi,%ebx
  800b9e:	29 c3                	sub    %eax,%ebx
  800ba0:	83 fb 7f             	cmp    $0x7f,%ebx
  800ba3:	0f 8f 70 01 00 00    	jg     800d19 <walk_path+0x1ea>
			return -E_BAD_PATH;
		memmove(name, p, path - p);
  800ba9:	83 ec 04             	sub    $0x4,%esp
  800bac:	53                   	push   %ebx
  800bad:	50                   	push   %eax
  800bae:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  800bb4:	50                   	push   %eax
  800bb5:	e8 78 18 00 00       	call   802432 <memmove>
		name[path - p] = '\0';
  800bba:	c6 84 1d 68 ff ff ff 	movb   $0x0,-0x98(%ebp,%ebx,1)
  800bc1:	00 
  800bc2:	83 c4 10             	add    $0x10,%esp
  800bc5:	eb 03                	jmp    800bca <walk_path+0x9b>
		p++;
  800bc7:	83 c7 01             	add    $0x1,%edi
	while (*p == '/')
  800bca:	80 3f 2f             	cmpb   $0x2f,(%edi)
  800bcd:	74 f8                	je     800bc7 <walk_path+0x98>
		path = skip_slash(path);

		if (dir->f_type != FTYPE_DIR)
  800bcf:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  800bd5:	83 b8 84 00 00 00 01 	cmpl   $0x1,0x84(%eax)
  800bdc:	0f 85 3e 01 00 00    	jne    800d20 <walk_path+0x1f1>
	assert((dir->f_size % BLKSIZE) == 0);
  800be2:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
  800be8:	a9 ff 0f 00 00       	test   $0xfff,%eax
  800bed:	0f 85 98 00 00 00    	jne    800c8b <walk_path+0x15c>
	nblock = dir->f_size / BLKSIZE;
  800bf3:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
  800bf9:	85 c0                	test   %eax,%eax
  800bfb:	0f 48 c2             	cmovs  %edx,%eax
  800bfe:	c1 f8 0c             	sar    $0xc,%eax
  800c01:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)
	for (i = 0; i < nblock; i++) {
  800c07:	c7 85 50 ff ff ff 00 	movl   $0x0,-0xb0(%ebp)
  800c0e:	00 00 00 
			if (strcmp(f[j].f_name, name) == 0) {
  800c11:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  800c17:	89 bd 44 ff ff ff    	mov    %edi,-0xbc(%ebp)
	for (i = 0; i < nblock; i++) {
  800c1d:	8b 8d 50 ff ff ff    	mov    -0xb0(%ebp),%ecx
  800c23:	39 8d 48 ff ff ff    	cmp    %ecx,-0xb8(%ebp)
  800c29:	74 79                	je     800ca4 <walk_path+0x175>
		if ((r = file_get_block(dir, i, &blk)) < 0)
  800c2b:	83 ec 04             	sub    $0x4,%esp
  800c2e:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
  800c34:	50                   	push   %eax
  800c35:	ff b5 50 ff ff ff    	pushl  -0xb0(%ebp)
  800c3b:	ff b5 4c ff ff ff    	pushl  -0xb4(%ebp)
  800c41:	e8 7d fe ff ff       	call   800ac3 <file_get_block>
  800c46:	83 c4 10             	add    $0x10,%esp
  800c49:	85 c0                	test   %eax,%eax
  800c4b:	0f 88 fc 00 00 00    	js     800d4d <walk_path+0x21e>
  800c51:	8b 9d 64 ff ff ff    	mov    -0x9c(%ebp),%ebx
  800c57:	8d bb 00 10 00 00    	lea    0x1000(%ebx),%edi
			if (strcmp(f[j].f_name, name) == 0) {
  800c5d:	89 9d 54 ff ff ff    	mov    %ebx,-0xac(%ebp)
  800c63:	83 ec 08             	sub    $0x8,%esp
  800c66:	56                   	push   %esi
  800c67:	53                   	push   %ebx
  800c68:	e8 dd 16 00 00       	call   80234a <strcmp>
  800c6d:	83 c4 10             	add    $0x10,%esp
  800c70:	85 c0                	test   %eax,%eax
  800c72:	0f 84 af 00 00 00    	je     800d27 <walk_path+0x1f8>
  800c78:	81 c3 00 01 00 00    	add    $0x100,%ebx
		for (j = 0; j < BLKFILES; j++)
  800c7e:	39 fb                	cmp    %edi,%ebx
  800c80:	75 db                	jne    800c5d <walk_path+0x12e>
	for (i = 0; i < nblock; i++) {
  800c82:	83 85 50 ff ff ff 01 	addl   $0x1,-0xb0(%ebp)
  800c89:	eb 92                	jmp    800c1d <walk_path+0xee>
	assert((dir->f_size % BLKSIZE) == 0);
  800c8b:	68 b1 40 80 00       	push   $0x8040b1
  800c90:	68 7d 3e 80 00       	push   $0x803e7d
  800c95:	68 d7 00 00 00       	push   $0xd7
  800c9a:	68 19 40 80 00       	push   $0x804019
  800c9f:	e8 88 0e 00 00       	call   801b2c <_panic>
  800ca4:	8b bd 44 ff ff ff    	mov    -0xbc(%ebp),%edi
					*pdir = dir;
				if (lastelem)
					strcpy(lastelem, name);
				*pf = 0;
			}
			return r;
  800caa:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
			if (r == -E_NOT_FOUND && *path == '\0') {
  800caf:	80 3f 00             	cmpb   $0x0,(%edi)
  800cb2:	0f 85 a4 00 00 00    	jne    800d5c <walk_path+0x22d>
				if (pdir)
  800cb8:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800cbe:	85 c0                	test   %eax,%eax
  800cc0:	74 08                	je     800cca <walk_path+0x19b>
					*pdir = dir;
  800cc2:	8b 8d 4c ff ff ff    	mov    -0xb4(%ebp),%ecx
  800cc8:	89 08                	mov    %ecx,(%eax)
				if (lastelem)
  800cca:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800cce:	74 15                	je     800ce5 <walk_path+0x1b6>
					strcpy(lastelem, name);
  800cd0:	83 ec 08             	sub    $0x8,%esp
  800cd3:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  800cd9:	50                   	push   %eax
  800cda:	ff 75 08             	pushl  0x8(%ebp)
  800cdd:	e8 c2 15 00 00       	call   8022a4 <strcpy>
  800ce2:	83 c4 10             	add    $0x10,%esp
				*pf = 0;
  800ce5:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800ceb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			return r;
  800cf1:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
  800cf6:	eb 64                	jmp    800d5c <walk_path+0x22d>
		}
	}

	if (pdir)
  800cf8:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800cfe:	85 c0                	test   %eax,%eax
  800d00:	74 02                	je     800d04 <walk_path+0x1d5>
		*pdir = dir;
  800d02:	89 10                	mov    %edx,(%eax)
	*pf = f;
  800d04:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800d0a:	8b 8d 4c ff ff ff    	mov    -0xb4(%ebp),%ecx
  800d10:	89 08                	mov    %ecx,(%eax)
	return 0;
  800d12:	b8 00 00 00 00       	mov    $0x0,%eax
  800d17:	eb 43                	jmp    800d5c <walk_path+0x22d>
			return -E_BAD_PATH;
  800d19:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  800d1e:	eb 3c                	jmp    800d5c <walk_path+0x22d>
			return -E_NOT_FOUND;
  800d20:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
  800d25:	eb 35                	jmp    800d5c <walk_path+0x22d>
  800d27:	8b bd 44 ff ff ff    	mov    -0xbc(%ebp),%edi
  800d2d:	89 f8                	mov    %edi,%eax
  800d2f:	8b 95 4c ff ff ff    	mov    -0xb4(%ebp),%edx
			if (strcmp(f[j].f_name, name) == 0) {
  800d35:	8b 8d 54 ff ff ff    	mov    -0xac(%ebp),%ecx
  800d3b:	89 8d 4c ff ff ff    	mov    %ecx,-0xb4(%ebp)
	while (*path != '\0') {
  800d41:	80 38 00             	cmpb   $0x0,(%eax)
  800d44:	74 b2                	je     800cf8 <walk_path+0x1c9>
  800d46:	89 c7                	mov    %eax,%edi
  800d48:	e9 43 fe ff ff       	jmp    800b90 <walk_path+0x61>
  800d4d:	8b bd 44 ff ff ff    	mov    -0xbc(%ebp),%edi
			if (r == -E_NOT_FOUND && *path == '\0') {
  800d53:	83 f8 f5             	cmp    $0xfffffff5,%eax
  800d56:	0f 84 4e ff ff ff    	je     800caa <walk_path+0x17b>
}
  800d5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d5f:	5b                   	pop    %ebx
  800d60:	5e                   	pop    %esi
  800d61:	5f                   	pop    %edi
  800d62:	5d                   	pop    %ebp
  800d63:	c3                   	ret    

00800d64 <file_open>:

// Open "path".  On success set *pf to point at the file and return 0.
// On error return < 0.
int
file_open(const char *path, struct File **pf)
{
  800d64:	55                   	push   %ebp
  800d65:	89 e5                	mov    %esp,%ebp
  800d67:	83 ec 14             	sub    $0x14,%esp
	return walk_path(path, 0, pf, 0);
  800d6a:	6a 00                	push   $0x0
  800d6c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d6f:	ba 00 00 00 00       	mov    $0x0,%edx
  800d74:	8b 45 08             	mov    0x8(%ebp),%eax
  800d77:	e8 b3 fd ff ff       	call   800b2f <walk_path>
}
  800d7c:	c9                   	leave  
  800d7d:	c3                   	ret    

00800d7e <file_read>:
// Read count bytes from f into buf, starting from seek position
// offset.  This meant to mimic the standard pread function.
// Returns the number of bytes read, < 0 on error.
ssize_t
file_read(struct File *f, void *buf, size_t count, off_t offset)
{
  800d7e:	55                   	push   %ebp
  800d7f:	89 e5                	mov    %esp,%ebp
  800d81:	57                   	push   %edi
  800d82:	56                   	push   %esi
  800d83:	53                   	push   %ebx
  800d84:	83 ec 2c             	sub    $0x2c,%esp
  800d87:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800d8a:	8b 4d 14             	mov    0x14(%ebp),%ecx
	int r, bn;
	off_t pos;
	char *blk;

	if (offset >= f->f_size)
  800d8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d90:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
		return 0;
  800d96:	b8 00 00 00 00       	mov    $0x0,%eax
	if (offset >= f->f_size)
  800d9b:	39 ca                	cmp    %ecx,%edx
  800d9d:	0f 8e 80 00 00 00    	jle    800e23 <file_read+0xa5>

	count = MIN(count, f->f_size - offset);
  800da3:	29 ca                	sub    %ecx,%edx
  800da5:	3b 55 10             	cmp    0x10(%ebp),%edx
  800da8:	89 d0                	mov    %edx,%eax
  800daa:	0f 47 45 10          	cmova  0x10(%ebp),%eax
  800dae:	89 45 d0             	mov    %eax,-0x30(%ebp)

	for (pos = offset; pos < offset + count; ) {
  800db1:	89 ce                	mov    %ecx,%esi
  800db3:	01 c1                	add    %eax,%ecx
  800db5:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800db8:	89 f3                	mov    %esi,%ebx
  800dba:	39 75 d4             	cmp    %esi,-0x2c(%ebp)
  800dbd:	76 61                	jbe    800e20 <file_read+0xa2>
		if ((r = file_get_block(f, pos / BLKSIZE, &blk)) < 0)
  800dbf:	83 ec 04             	sub    $0x4,%esp
  800dc2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800dc5:	50                   	push   %eax
  800dc6:	8d 86 ff 0f 00 00    	lea    0xfff(%esi),%eax
  800dcc:	85 f6                	test   %esi,%esi
  800dce:	0f 49 c6             	cmovns %esi,%eax
  800dd1:	c1 f8 0c             	sar    $0xc,%eax
  800dd4:	50                   	push   %eax
  800dd5:	ff 75 08             	pushl  0x8(%ebp)
  800dd8:	e8 e6 fc ff ff       	call   800ac3 <file_get_block>
  800ddd:	83 c4 10             	add    $0x10,%esp
  800de0:	85 c0                	test   %eax,%eax
  800de2:	78 3f                	js     800e23 <file_read+0xa5>
			return r;
		bn = MIN(BLKSIZE - pos % BLKSIZE, offset + count - pos);
  800de4:	89 f2                	mov    %esi,%edx
  800de6:	c1 fa 1f             	sar    $0x1f,%edx
  800de9:	c1 ea 14             	shr    $0x14,%edx
  800dec:	8d 04 16             	lea    (%esi,%edx,1),%eax
  800def:	25 ff 0f 00 00       	and    $0xfff,%eax
  800df4:	29 d0                	sub    %edx,%eax
  800df6:	ba 00 10 00 00       	mov    $0x1000,%edx
  800dfb:	29 c2                	sub    %eax,%edx
  800dfd:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  800e00:	29 d9                	sub    %ebx,%ecx
  800e02:	89 cb                	mov    %ecx,%ebx
  800e04:	39 ca                	cmp    %ecx,%edx
  800e06:	0f 46 da             	cmovbe %edx,%ebx
		memmove(buf, blk + pos % BLKSIZE, bn);
  800e09:	83 ec 04             	sub    $0x4,%esp
  800e0c:	53                   	push   %ebx
  800e0d:	03 45 e4             	add    -0x1c(%ebp),%eax
  800e10:	50                   	push   %eax
  800e11:	57                   	push   %edi
  800e12:	e8 1b 16 00 00       	call   802432 <memmove>
		pos += bn;
  800e17:	01 de                	add    %ebx,%esi
		buf += bn;
  800e19:	01 df                	add    %ebx,%edi
  800e1b:	83 c4 10             	add    $0x10,%esp
  800e1e:	eb 98                	jmp    800db8 <file_read+0x3a>
	}

	return count;
  800e20:	8b 45 d0             	mov    -0x30(%ebp),%eax
}
  800e23:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e26:	5b                   	pop    %ebx
  800e27:	5e                   	pop    %esi
  800e28:	5f                   	pop    %edi
  800e29:	5d                   	pop    %ebp
  800e2a:	c3                   	ret    

00800e2b <file_set_size>:
}

// Set the size of file f, truncating or extending as necessary.
int
file_set_size(struct File *f, off_t newsize)
{
  800e2b:	55                   	push   %ebp
  800e2c:	89 e5                	mov    %esp,%ebp
  800e2e:	57                   	push   %edi
  800e2f:	56                   	push   %esi
  800e30:	53                   	push   %ebx
  800e31:	83 ec 2c             	sub    $0x2c,%esp
  800e34:	8b 75 08             	mov    0x8(%ebp),%esi
	if (f->f_size > newsize)
  800e37:	8b 86 80 00 00 00    	mov    0x80(%esi),%eax
  800e3d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800e40:	7f 1f                	jg     800e61 <file_set_size+0x36>
		file_truncate_blocks(f, newsize);
	f->f_size = newsize;
  800e42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e45:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	flush_block(f);
  800e4b:	83 ec 0c             	sub    $0xc,%esp
  800e4e:	56                   	push   %esi
  800e4f:	e8 ce f5 ff ff       	call   800422 <flush_block>
	return 0;
}
  800e54:	b8 00 00 00 00       	mov    $0x0,%eax
  800e59:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e5c:	5b                   	pop    %ebx
  800e5d:	5e                   	pop    %esi
  800e5e:	5f                   	pop    %edi
  800e5f:	5d                   	pop    %ebp
  800e60:	c3                   	ret    
	old_nblocks = (f->f_size + BLKSIZE - 1) / BLKSIZE;
  800e61:	8d b8 fe 1f 00 00    	lea    0x1ffe(%eax),%edi
  800e67:	05 ff 0f 00 00       	add    $0xfff,%eax
  800e6c:	0f 49 f8             	cmovns %eax,%edi
  800e6f:	c1 ff 0c             	sar    $0xc,%edi
	new_nblocks = (newsize + BLKSIZE - 1) / BLKSIZE;
  800e72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e75:	05 fe 1f 00 00       	add    $0x1ffe,%eax
  800e7a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e7d:	81 c2 ff 0f 00 00    	add    $0xfff,%edx
  800e83:	0f 49 c2             	cmovns %edx,%eax
  800e86:	c1 f8 0c             	sar    $0xc,%eax
  800e89:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	for (bno = new_nblocks; bno < old_nblocks; bno++)
  800e8c:	89 c3                	mov    %eax,%ebx
  800e8e:	eb 3c                	jmp    800ecc <file_set_size+0xa1>
	if (new_nblocks <= NDIRECT && f->f_indirect) {
  800e90:	83 7d d4 0a          	cmpl   $0xa,-0x2c(%ebp)
  800e94:	77 ac                	ja     800e42 <file_set_size+0x17>
  800e96:	8b 86 b0 00 00 00    	mov    0xb0(%esi),%eax
  800e9c:	85 c0                	test   %eax,%eax
  800e9e:	74 a2                	je     800e42 <file_set_size+0x17>
		free_block(f->f_indirect);
  800ea0:	83 ec 0c             	sub    $0xc,%esp
  800ea3:	50                   	push   %eax
  800ea4:	e8 bb f9 ff ff       	call   800864 <free_block>
		f->f_indirect = 0;
  800ea9:	c7 86 b0 00 00 00 00 	movl   $0x0,0xb0(%esi)
  800eb0:	00 00 00 
  800eb3:	83 c4 10             	add    $0x10,%esp
  800eb6:	eb 8a                	jmp    800e42 <file_set_size+0x17>
			cprintf("warning: file_free_block: %e", r);
  800eb8:	83 ec 08             	sub    $0x8,%esp
  800ebb:	50                   	push   %eax
  800ebc:	68 ce 40 80 00       	push   $0x8040ce
  800ec1:	e8 41 0d 00 00       	call   801c07 <cprintf>
  800ec6:	83 c4 10             	add    $0x10,%esp
	for (bno = new_nblocks; bno < old_nblocks; bno++)
  800ec9:	83 c3 01             	add    $0x1,%ebx
  800ecc:	39 df                	cmp    %ebx,%edi
  800ece:	76 c0                	jbe    800e90 <file_set_size+0x65>
	if ((r = file_block_walk(f, filebno, &ptr, 0)) < 0)
  800ed0:	83 ec 0c             	sub    $0xc,%esp
  800ed3:	6a 00                	push   $0x0
  800ed5:	8d 4d e4             	lea    -0x1c(%ebp),%ecx
  800ed8:	89 da                	mov    %ebx,%edx
  800eda:	89 f0                	mov    %esi,%eax
  800edc:	e8 38 fa ff ff       	call   800919 <file_block_walk>
  800ee1:	83 c4 10             	add    $0x10,%esp
  800ee4:	85 c0                	test   %eax,%eax
  800ee6:	78 d0                	js     800eb8 <file_set_size+0x8d>
	if (*ptr) {
  800ee8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800eeb:	8b 00                	mov    (%eax),%eax
  800eed:	85 c0                	test   %eax,%eax
  800eef:	74 d8                	je     800ec9 <file_set_size+0x9e>
		free_block(*ptr);
  800ef1:	83 ec 0c             	sub    $0xc,%esp
  800ef4:	50                   	push   %eax
  800ef5:	e8 6a f9 ff ff       	call   800864 <free_block>
		*ptr = 0;
  800efa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800efd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  800f03:	83 c4 10             	add    $0x10,%esp
  800f06:	eb c1                	jmp    800ec9 <file_set_size+0x9e>

00800f08 <file_write>:
{
  800f08:	55                   	push   %ebp
  800f09:	89 e5                	mov    %esp,%ebp
  800f0b:	57                   	push   %edi
  800f0c:	56                   	push   %esi
  800f0d:	53                   	push   %ebx
  800f0e:	83 ec 2c             	sub    $0x2c,%esp
  800f11:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800f14:	8b 75 14             	mov    0x14(%ebp),%esi
	if (offset + count > f->f_size)
  800f17:	89 f0                	mov    %esi,%eax
  800f19:	03 45 10             	add    0x10(%ebp),%eax
  800f1c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800f1f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f22:	3b 81 80 00 00 00    	cmp    0x80(%ecx),%eax
  800f28:	77 68                	ja     800f92 <file_write+0x8a>
	for (pos = offset; pos < offset + count; ) {
  800f2a:	89 f3                	mov    %esi,%ebx
  800f2c:	39 75 d4             	cmp    %esi,-0x2c(%ebp)
  800f2f:	76 74                	jbe    800fa5 <file_write+0x9d>
		if ((r = file_get_block(f, pos / BLKSIZE, &blk)) < 0)
  800f31:	83 ec 04             	sub    $0x4,%esp
  800f34:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800f37:	50                   	push   %eax
  800f38:	8d 86 ff 0f 00 00    	lea    0xfff(%esi),%eax
  800f3e:	85 f6                	test   %esi,%esi
  800f40:	0f 49 c6             	cmovns %esi,%eax
  800f43:	c1 f8 0c             	sar    $0xc,%eax
  800f46:	50                   	push   %eax
  800f47:	ff 75 08             	pushl  0x8(%ebp)
  800f4a:	e8 74 fb ff ff       	call   800ac3 <file_get_block>
  800f4f:	83 c4 10             	add    $0x10,%esp
  800f52:	85 c0                	test   %eax,%eax
  800f54:	78 52                	js     800fa8 <file_write+0xa0>
		bn = MIN(BLKSIZE - pos % BLKSIZE, offset + count - pos);
  800f56:	89 f2                	mov    %esi,%edx
  800f58:	c1 fa 1f             	sar    $0x1f,%edx
  800f5b:	c1 ea 14             	shr    $0x14,%edx
  800f5e:	8d 04 16             	lea    (%esi,%edx,1),%eax
  800f61:	25 ff 0f 00 00       	and    $0xfff,%eax
  800f66:	29 d0                	sub    %edx,%eax
  800f68:	b9 00 10 00 00       	mov    $0x1000,%ecx
  800f6d:	29 c1                	sub    %eax,%ecx
  800f6f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800f72:	29 da                	sub    %ebx,%edx
  800f74:	39 d1                	cmp    %edx,%ecx
  800f76:	89 d3                	mov    %edx,%ebx
  800f78:	0f 46 d9             	cmovbe %ecx,%ebx
		memmove(blk + pos % BLKSIZE, buf, bn);
  800f7b:	83 ec 04             	sub    $0x4,%esp
  800f7e:	53                   	push   %ebx
  800f7f:	57                   	push   %edi
  800f80:	03 45 e4             	add    -0x1c(%ebp),%eax
  800f83:	50                   	push   %eax
  800f84:	e8 a9 14 00 00       	call   802432 <memmove>
		pos += bn;
  800f89:	01 de                	add    %ebx,%esi
		buf += bn;
  800f8b:	01 df                	add    %ebx,%edi
  800f8d:	83 c4 10             	add    $0x10,%esp
  800f90:	eb 98                	jmp    800f2a <file_write+0x22>
		if ((r = file_set_size(f, offset + count)) < 0)
  800f92:	83 ec 08             	sub    $0x8,%esp
  800f95:	50                   	push   %eax
  800f96:	51                   	push   %ecx
  800f97:	e8 8f fe ff ff       	call   800e2b <file_set_size>
  800f9c:	83 c4 10             	add    $0x10,%esp
  800f9f:	85 c0                	test   %eax,%eax
  800fa1:	79 87                	jns    800f2a <file_write+0x22>
  800fa3:	eb 03                	jmp    800fa8 <file_write+0xa0>
	return count;
  800fa5:	8b 45 10             	mov    0x10(%ebp),%eax
}
  800fa8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fab:	5b                   	pop    %ebx
  800fac:	5e                   	pop    %esi
  800fad:	5f                   	pop    %edi
  800fae:	5d                   	pop    %ebp
  800faf:	c3                   	ret    

00800fb0 <file_flush>:
// Loop over all the blocks in file.
// Translate the file block number into a disk block number
// and then check whether that disk block is dirty.  If so, write it out.
void
file_flush(struct File *f)
{
  800fb0:	55                   	push   %ebp
  800fb1:	89 e5                	mov    %esp,%ebp
  800fb3:	56                   	push   %esi
  800fb4:	53                   	push   %ebx
  800fb5:	83 ec 10             	sub    $0x10,%esp
  800fb8:	8b 75 08             	mov    0x8(%ebp),%esi
	int i;
	uint32_t *pdiskbno;

	for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
  800fbb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fc0:	eb 03                	jmp    800fc5 <file_flush+0x15>
  800fc2:	83 c3 01             	add    $0x1,%ebx
  800fc5:	8b 96 80 00 00 00    	mov    0x80(%esi),%edx
  800fcb:	8d 8a ff 0f 00 00    	lea    0xfff(%edx),%ecx
  800fd1:	8d 82 fe 1f 00 00    	lea    0x1ffe(%edx),%eax
  800fd7:	85 c9                	test   %ecx,%ecx
  800fd9:	0f 49 c1             	cmovns %ecx,%eax
  800fdc:	c1 f8 0c             	sar    $0xc,%eax
  800fdf:	39 d8                	cmp    %ebx,%eax
  800fe1:	7e 3b                	jle    80101e <file_flush+0x6e>
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
  800fe3:	83 ec 0c             	sub    $0xc,%esp
  800fe6:	6a 00                	push   $0x0
  800fe8:	8d 4d f4             	lea    -0xc(%ebp),%ecx
  800feb:	89 da                	mov    %ebx,%edx
  800fed:	89 f0                	mov    %esi,%eax
  800fef:	e8 25 f9 ff ff       	call   800919 <file_block_walk>
  800ff4:	83 c4 10             	add    $0x10,%esp
  800ff7:	85 c0                	test   %eax,%eax
  800ff9:	78 c7                	js     800fc2 <file_flush+0x12>
		    pdiskbno == NULL || *pdiskbno == 0)
  800ffb:	8b 45 f4             	mov    -0xc(%ebp),%eax
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
  800ffe:	85 c0                	test   %eax,%eax
  801000:	74 c0                	je     800fc2 <file_flush+0x12>
		    pdiskbno == NULL || *pdiskbno == 0)
  801002:	8b 00                	mov    (%eax),%eax
  801004:	85 c0                	test   %eax,%eax
  801006:	74 ba                	je     800fc2 <file_flush+0x12>
			continue;
		flush_block(diskaddr(*pdiskbno));
  801008:	83 ec 0c             	sub    $0xc,%esp
  80100b:	50                   	push   %eax
  80100c:	e8 93 f3 ff ff       	call   8003a4 <diskaddr>
  801011:	89 04 24             	mov    %eax,(%esp)
  801014:	e8 09 f4 ff ff       	call   800422 <flush_block>
  801019:	83 c4 10             	add    $0x10,%esp
  80101c:	eb a4                	jmp    800fc2 <file_flush+0x12>
	}
	flush_block(f);
  80101e:	83 ec 0c             	sub    $0xc,%esp
  801021:	56                   	push   %esi
  801022:	e8 fb f3 ff ff       	call   800422 <flush_block>
	if (f->f_indirect)
  801027:	8b 86 b0 00 00 00    	mov    0xb0(%esi),%eax
  80102d:	83 c4 10             	add    $0x10,%esp
  801030:	85 c0                	test   %eax,%eax
  801032:	75 07                	jne    80103b <file_flush+0x8b>
		flush_block(diskaddr(f->f_indirect));
}
  801034:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801037:	5b                   	pop    %ebx
  801038:	5e                   	pop    %esi
  801039:	5d                   	pop    %ebp
  80103a:	c3                   	ret    
		flush_block(diskaddr(f->f_indirect));
  80103b:	83 ec 0c             	sub    $0xc,%esp
  80103e:	50                   	push   %eax
  80103f:	e8 60 f3 ff ff       	call   8003a4 <diskaddr>
  801044:	89 04 24             	mov    %eax,(%esp)
  801047:	e8 d6 f3 ff ff       	call   800422 <flush_block>
  80104c:	83 c4 10             	add    $0x10,%esp
}
  80104f:	eb e3                	jmp    801034 <file_flush+0x84>

00801051 <file_create>:
{
  801051:	55                   	push   %ebp
  801052:	89 e5                	mov    %esp,%ebp
  801054:	57                   	push   %edi
  801055:	56                   	push   %esi
  801056:	53                   	push   %ebx
  801057:	81 ec b8 00 00 00    	sub    $0xb8,%esp
	if ((r = walk_path(path, &dir, &f, name)) == 0)
  80105d:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  801063:	50                   	push   %eax
  801064:	8d 8d 60 ff ff ff    	lea    -0xa0(%ebp),%ecx
  80106a:	8d 95 64 ff ff ff    	lea    -0x9c(%ebp),%edx
  801070:	8b 45 08             	mov    0x8(%ebp),%eax
  801073:	e8 b7 fa ff ff       	call   800b2f <walk_path>
  801078:	83 c4 10             	add    $0x10,%esp
  80107b:	85 c0                	test   %eax,%eax
  80107d:	0f 84 0e 01 00 00    	je     801191 <file_create+0x140>
	if (r != -E_NOT_FOUND || dir == 0)
  801083:	83 f8 f5             	cmp    $0xfffffff5,%eax
  801086:	74 08                	je     801090 <file_create+0x3f>
}
  801088:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80108b:	5b                   	pop    %ebx
  80108c:	5e                   	pop    %esi
  80108d:	5f                   	pop    %edi
  80108e:	5d                   	pop    %ebp
  80108f:	c3                   	ret    
	if (r != -E_NOT_FOUND || dir == 0)
  801090:	8b 9d 64 ff ff ff    	mov    -0x9c(%ebp),%ebx
  801096:	85 db                	test   %ebx,%ebx
  801098:	74 ee                	je     801088 <file_create+0x37>
	assert((dir->f_size % BLKSIZE) == 0);
  80109a:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
  8010a0:	a9 ff 0f 00 00       	test   $0xfff,%eax
  8010a5:	75 5c                	jne    801103 <file_create+0xb2>
	nblock = dir->f_size / BLKSIZE;
  8010a7:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
  8010ad:	85 c0                	test   %eax,%eax
  8010af:	0f 48 c2             	cmovs  %edx,%eax
  8010b2:	c1 f8 0c             	sar    $0xc,%eax
  8010b5:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
	for (i = 0; i < nblock; i++) {
  8010bb:	be 00 00 00 00       	mov    $0x0,%esi
		if ((r = file_get_block(dir, i, &blk)) < 0)
  8010c0:	8d bd 5c ff ff ff    	lea    -0xa4(%ebp),%edi
	for (i = 0; i < nblock; i++) {
  8010c6:	39 b5 54 ff ff ff    	cmp    %esi,-0xac(%ebp)
  8010cc:	0f 84 8b 00 00 00    	je     80115d <file_create+0x10c>
		if ((r = file_get_block(dir, i, &blk)) < 0)
  8010d2:	83 ec 04             	sub    $0x4,%esp
  8010d5:	57                   	push   %edi
  8010d6:	56                   	push   %esi
  8010d7:	53                   	push   %ebx
  8010d8:	e8 e6 f9 ff ff       	call   800ac3 <file_get_block>
  8010dd:	83 c4 10             	add    $0x10,%esp
  8010e0:	85 c0                	test   %eax,%eax
  8010e2:	78 a4                	js     801088 <file_create+0x37>
  8010e4:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  8010ea:	8d 88 00 10 00 00    	lea    0x1000(%eax),%ecx
			if (f[j].f_name[0] == '\0') {
  8010f0:	80 38 00             	cmpb   $0x0,(%eax)
  8010f3:	74 27                	je     80111c <file_create+0xcb>
  8010f5:	05 00 01 00 00       	add    $0x100,%eax
		for (j = 0; j < BLKFILES; j++)
  8010fa:	39 c8                	cmp    %ecx,%eax
  8010fc:	75 f2                	jne    8010f0 <file_create+0x9f>
	for (i = 0; i < nblock; i++) {
  8010fe:	83 c6 01             	add    $0x1,%esi
  801101:	eb c3                	jmp    8010c6 <file_create+0x75>
	assert((dir->f_size % BLKSIZE) == 0);
  801103:	68 b1 40 80 00       	push   $0x8040b1
  801108:	68 7d 3e 80 00       	push   $0x803e7d
  80110d:	68 f0 00 00 00       	push   $0xf0
  801112:	68 19 40 80 00       	push   $0x804019
  801117:	e8 10 0a 00 00       	call   801b2c <_panic>
				*file = &f[j];
  80111c:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
	strcpy(f->f_name, name);
  801122:	83 ec 08             	sub    $0x8,%esp
  801125:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  80112b:	50                   	push   %eax
  80112c:	ff b5 60 ff ff ff    	pushl  -0xa0(%ebp)
  801132:	e8 6d 11 00 00       	call   8022a4 <strcpy>
	*pf = f;
  801137:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113a:	8b 95 60 ff ff ff    	mov    -0xa0(%ebp),%edx
  801140:	89 10                	mov    %edx,(%eax)
	file_flush(dir);
  801142:	83 c4 04             	add    $0x4,%esp
  801145:	ff b5 64 ff ff ff    	pushl  -0x9c(%ebp)
  80114b:	e8 60 fe ff ff       	call   800fb0 <file_flush>
	return 0;
  801150:	83 c4 10             	add    $0x10,%esp
  801153:	b8 00 00 00 00       	mov    $0x0,%eax
  801158:	e9 2b ff ff ff       	jmp    801088 <file_create+0x37>
	dir->f_size += BLKSIZE;
  80115d:	81 83 80 00 00 00 00 	addl   $0x1000,0x80(%ebx)
  801164:	10 00 00 
	if ((r = file_get_block(dir, i, &blk)) < 0)
  801167:	83 ec 04             	sub    $0x4,%esp
  80116a:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
  801170:	50                   	push   %eax
  801171:	56                   	push   %esi
  801172:	53                   	push   %ebx
  801173:	e8 4b f9 ff ff       	call   800ac3 <file_get_block>
  801178:	83 c4 10             	add    $0x10,%esp
  80117b:	85 c0                	test   %eax,%eax
  80117d:	0f 88 05 ff ff ff    	js     801088 <file_create+0x37>
	*file = &f[0];
  801183:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  801189:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  80118f:	eb 91                	jmp    801122 <file_create+0xd1>
		return -E_FILE_EXISTS;
  801191:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  801196:	e9 ed fe ff ff       	jmp    801088 <file_create+0x37>

0080119b <fs_sync>:


// Sync the entire file system.  A big hammer.
void
fs_sync(void)
{
  80119b:	55                   	push   %ebp
  80119c:	89 e5                	mov    %esp,%ebp
  80119e:	53                   	push   %ebx
  80119f:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 1; i < super->s_nblocks; i++)
  8011a2:	bb 01 00 00 00       	mov    $0x1,%ebx
  8011a7:	eb 17                	jmp    8011c0 <fs_sync+0x25>
		flush_block(diskaddr(i));
  8011a9:	83 ec 0c             	sub    $0xc,%esp
  8011ac:	53                   	push   %ebx
  8011ad:	e8 f2 f1 ff ff       	call   8003a4 <diskaddr>
  8011b2:	89 04 24             	mov    %eax,(%esp)
  8011b5:	e8 68 f2 ff ff       	call   800422 <flush_block>
	for (i = 1; i < super->s_nblocks; i++)
  8011ba:	83 c3 01             	add    $0x1,%ebx
  8011bd:	83 c4 10             	add    $0x10,%esp
  8011c0:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  8011c5:	39 58 04             	cmp    %ebx,0x4(%eax)
  8011c8:	77 df                	ja     8011a9 <fs_sync+0xe>
}
  8011ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011cd:	c9                   	leave  
  8011ce:	c3                   	ret    

008011cf <serve_sync>:
}


int
serve_sync(envid_t envid, union Fsipc *req)
{
  8011cf:	55                   	push   %ebp
  8011d0:	89 e5                	mov    %esp,%ebp
  8011d2:	83 ec 08             	sub    $0x8,%esp
	fs_sync();
  8011d5:	e8 c1 ff ff ff       	call   80119b <fs_sync>
	return 0;
}
  8011da:	b8 00 00 00 00       	mov    $0x0,%eax
  8011df:	c9                   	leave  
  8011e0:	c3                   	ret    

008011e1 <serve_init>:
{
  8011e1:	55                   	push   %ebp
  8011e2:	89 e5                	mov    %esp,%ebp
  8011e4:	ba 60 50 80 00       	mov    $0x805060,%edx
	uintptr_t va = FILEVA;
  8011e9:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
	for (i = 0; i < MAXOPEN; i++) {
  8011ee:	b8 00 00 00 00       	mov    $0x0,%eax
		opentab[i].o_fileid = i;
  8011f3:	89 02                	mov    %eax,(%edx)
		opentab[i].o_fd = (struct Fd*) va;
  8011f5:	89 4a 0c             	mov    %ecx,0xc(%edx)
		va += PGSIZE;
  8011f8:	81 c1 00 10 00 00    	add    $0x1000,%ecx
	for (i = 0; i < MAXOPEN; i++) {
  8011fe:	83 c0 01             	add    $0x1,%eax
  801201:	83 c2 10             	add    $0x10,%edx
  801204:	3d 00 04 00 00       	cmp    $0x400,%eax
  801209:	75 e8                	jne    8011f3 <serve_init+0x12>
}
  80120b:	5d                   	pop    %ebp
  80120c:	c3                   	ret    

0080120d <openfile_alloc>:
{
  80120d:	55                   	push   %ebp
  80120e:	89 e5                	mov    %esp,%ebp
  801210:	57                   	push   %edi
  801211:	56                   	push   %esi
  801212:	53                   	push   %ebx
  801213:	83 ec 0c             	sub    $0xc,%esp
  801216:	8b 7d 08             	mov    0x8(%ebp),%edi
	for (i = 0; i < MAXOPEN; i++) {
  801219:	bb 00 00 00 00       	mov    $0x0,%ebx
  80121e:	89 de                	mov    %ebx,%esi
  801220:	c1 e6 04             	shl    $0x4,%esi
		switch (pageref(opentab[i].o_fd)) {
  801223:	83 ec 0c             	sub    $0xc,%esp
  801226:	ff b6 6c 50 80 00    	pushl  0x80506c(%esi)
  80122c:	e8 46 20 00 00       	call   803277 <pageref>
  801231:	83 c4 10             	add    $0x10,%esp
  801234:	85 c0                	test   %eax,%eax
  801236:	74 17                	je     80124f <openfile_alloc+0x42>
  801238:	83 f8 01             	cmp    $0x1,%eax
  80123b:	74 30                	je     80126d <openfile_alloc+0x60>
	for (i = 0; i < MAXOPEN; i++) {
  80123d:	83 c3 01             	add    $0x1,%ebx
  801240:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
  801246:	75 d6                	jne    80121e <openfile_alloc+0x11>
	return -E_MAX_OPEN;
  801248:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80124d:	eb 4f                	jmp    80129e <openfile_alloc+0x91>
			if ((r = sys_page_alloc(0, opentab[i].o_fd, PTE_P|PTE_U|PTE_W)) < 0)
  80124f:	83 ec 04             	sub    $0x4,%esp
  801252:	6a 07                	push   $0x7
  801254:	89 d8                	mov    %ebx,%eax
  801256:	c1 e0 04             	shl    $0x4,%eax
  801259:	ff b0 6c 50 80 00    	pushl  0x80506c(%eax)
  80125f:	6a 00                	push   $0x0
  801261:	e8 37 14 00 00       	call   80269d <sys_page_alloc>
  801266:	83 c4 10             	add    $0x10,%esp
  801269:	85 c0                	test   %eax,%eax
  80126b:	78 31                	js     80129e <openfile_alloc+0x91>
			opentab[i].o_fileid += MAXOPEN;
  80126d:	c1 e3 04             	shl    $0x4,%ebx
  801270:	81 83 60 50 80 00 00 	addl   $0x400,0x805060(%ebx)
  801277:	04 00 00 
			*o = &opentab[i];
  80127a:	81 c6 60 50 80 00    	add    $0x805060,%esi
  801280:	89 37                	mov    %esi,(%edi)
			memset(opentab[i].o_fd, 0, PGSIZE);
  801282:	83 ec 04             	sub    $0x4,%esp
  801285:	68 00 10 00 00       	push   $0x1000
  80128a:	6a 00                	push   $0x0
  80128c:	ff b3 6c 50 80 00    	pushl  0x80506c(%ebx)
  801292:	e8 4e 11 00 00       	call   8023e5 <memset>
			return (*o)->o_fileid;
  801297:	8b 07                	mov    (%edi),%eax
  801299:	8b 00                	mov    (%eax),%eax
  80129b:	83 c4 10             	add    $0x10,%esp
}
  80129e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012a1:	5b                   	pop    %ebx
  8012a2:	5e                   	pop    %esi
  8012a3:	5f                   	pop    %edi
  8012a4:	5d                   	pop    %ebp
  8012a5:	c3                   	ret    

008012a6 <openfile_lookup>:
{
  8012a6:	55                   	push   %ebp
  8012a7:	89 e5                	mov    %esp,%ebp
  8012a9:	57                   	push   %edi
  8012aa:	56                   	push   %esi
  8012ab:	53                   	push   %ebx
  8012ac:	83 ec 18             	sub    $0x18,%esp
  8012af:	8b 7d 0c             	mov    0xc(%ebp),%edi
	o = &opentab[fileid % MAXOPEN];
  8012b2:	89 fb                	mov    %edi,%ebx
  8012b4:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  8012ba:	89 de                	mov    %ebx,%esi
  8012bc:	c1 e6 04             	shl    $0x4,%esi
	if (pageref(o->o_fd) <= 1 || o->o_fileid != fileid)
  8012bf:	ff b6 6c 50 80 00    	pushl  0x80506c(%esi)
	o = &opentab[fileid % MAXOPEN];
  8012c5:	81 c6 60 50 80 00    	add    $0x805060,%esi
	if (pageref(o->o_fd) <= 1 || o->o_fileid != fileid)
  8012cb:	e8 a7 1f 00 00       	call   803277 <pageref>
  8012d0:	83 c4 10             	add    $0x10,%esp
  8012d3:	83 f8 01             	cmp    $0x1,%eax
  8012d6:	7e 1d                	jle    8012f5 <openfile_lookup+0x4f>
  8012d8:	c1 e3 04             	shl    $0x4,%ebx
  8012db:	39 bb 60 50 80 00    	cmp    %edi,0x805060(%ebx)
  8012e1:	75 19                	jne    8012fc <openfile_lookup+0x56>
	*po = o;
  8012e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8012e6:	89 30                	mov    %esi,(%eax)
	return 0;
  8012e8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012f0:	5b                   	pop    %ebx
  8012f1:	5e                   	pop    %esi
  8012f2:	5f                   	pop    %edi
  8012f3:	5d                   	pop    %ebp
  8012f4:	c3                   	ret    
		return -E_INVAL;
  8012f5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012fa:	eb f1                	jmp    8012ed <openfile_lookup+0x47>
  8012fc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801301:	eb ea                	jmp    8012ed <openfile_lookup+0x47>

00801303 <serve_set_size>:
{
  801303:	55                   	push   %ebp
  801304:	89 e5                	mov    %esp,%ebp
  801306:	53                   	push   %ebx
  801307:	83 ec 18             	sub    $0x18,%esp
  80130a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  80130d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801310:	50                   	push   %eax
  801311:	ff 33                	pushl  (%ebx)
  801313:	ff 75 08             	pushl  0x8(%ebp)
  801316:	e8 8b ff ff ff       	call   8012a6 <openfile_lookup>
  80131b:	83 c4 10             	add    $0x10,%esp
  80131e:	85 c0                	test   %eax,%eax
  801320:	78 14                	js     801336 <serve_set_size+0x33>
	return file_set_size(o->o_file, req->req_size);
  801322:	83 ec 08             	sub    $0x8,%esp
  801325:	ff 73 04             	pushl  0x4(%ebx)
  801328:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80132b:	ff 70 04             	pushl  0x4(%eax)
  80132e:	e8 f8 fa ff ff       	call   800e2b <file_set_size>
  801333:	83 c4 10             	add    $0x10,%esp
}
  801336:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801339:	c9                   	leave  
  80133a:	c3                   	ret    

0080133b <serve_read>:
{
  80133b:	55                   	push   %ebp
  80133c:	89 e5                	mov    %esp,%ebp
  80133e:	53                   	push   %ebx
  80133f:	83 ec 18             	sub    $0x18,%esp
  801342:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) != 0) {
  801345:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801348:	50                   	push   %eax
  801349:	ff 33                	pushl  (%ebx)
  80134b:	ff 75 08             	pushl  0x8(%ebp)
  80134e:	e8 53 ff ff ff       	call   8012a6 <openfile_lookup>
  801353:	83 c4 10             	add    $0x10,%esp
  801356:	85 c0                	test   %eax,%eax
  801358:	74 05                	je     80135f <serve_read+0x24>
}
  80135a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80135d:	c9                   	leave  
  80135e:	c3                   	ret    
	if ((r = file_read(o->o_file, ret->ret_buf, req->req_n, o->o_fd->fd_offset)) > 0) {
  80135f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801362:	8b 50 0c             	mov    0xc(%eax),%edx
  801365:	ff 72 04             	pushl  0x4(%edx)
  801368:	ff 73 04             	pushl  0x4(%ebx)
  80136b:	53                   	push   %ebx
  80136c:	ff 70 04             	pushl  0x4(%eax)
  80136f:	e8 0a fa ff ff       	call   800d7e <file_read>
  801374:	83 c4 10             	add    $0x10,%esp
  801377:	85 c0                	test   %eax,%eax
  801379:	7e df                	jle    80135a <serve_read+0x1f>
	    o->o_fd->fd_offset += r;
  80137b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80137e:	8b 52 0c             	mov    0xc(%edx),%edx
  801381:	01 42 04             	add    %eax,0x4(%edx)
  801384:	eb d4                	jmp    80135a <serve_read+0x1f>

00801386 <serve_write>:
{
  801386:	55                   	push   %ebp
  801387:	89 e5                	mov    %esp,%ebp
  801389:	53                   	push   %ebx
  80138a:	83 ec 18             	sub    $0x18,%esp
  80138d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) != 0) {
  801390:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801393:	50                   	push   %eax
  801394:	ff 33                	pushl  (%ebx)
  801396:	ff 75 08             	pushl  0x8(%ebp)
  801399:	e8 08 ff ff ff       	call   8012a6 <openfile_lookup>
  80139e:	83 c4 10             	add    $0x10,%esp
  8013a1:	85 c0                	test   %eax,%eax
  8013a3:	74 05                	je     8013aa <serve_write+0x24>
}
  8013a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013a8:	c9                   	leave  
  8013a9:	c3                   	ret    
	if ((r = file_write(o->o_file, req->req_buf, req->req_n, o->o_fd->fd_offset)) > 0) {
  8013aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013ad:	8b 50 0c             	mov    0xc(%eax),%edx
  8013b0:	ff 72 04             	pushl  0x4(%edx)
  8013b3:	ff 73 04             	pushl  0x4(%ebx)
  8013b6:	83 c3 08             	add    $0x8,%ebx
  8013b9:	53                   	push   %ebx
  8013ba:	ff 70 04             	pushl  0x4(%eax)
  8013bd:	e8 46 fb ff ff       	call   800f08 <file_write>
  8013c2:	83 c4 10             	add    $0x10,%esp
  8013c5:	85 c0                	test   %eax,%eax
  8013c7:	7e dc                	jle    8013a5 <serve_write+0x1f>
	    o->o_fd->fd_offset += r;
  8013c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013cc:	8b 52 0c             	mov    0xc(%edx),%edx
  8013cf:	01 42 04             	add    %eax,0x4(%edx)
  8013d2:	eb d1                	jmp    8013a5 <serve_write+0x1f>

008013d4 <serve_stat>:
{
  8013d4:	55                   	push   %ebp
  8013d5:	89 e5                	mov    %esp,%ebp
  8013d7:	53                   	push   %ebx
  8013d8:	83 ec 18             	sub    $0x18,%esp
  8013db:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  8013de:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013e1:	50                   	push   %eax
  8013e2:	ff 33                	pushl  (%ebx)
  8013e4:	ff 75 08             	pushl  0x8(%ebp)
  8013e7:	e8 ba fe ff ff       	call   8012a6 <openfile_lookup>
  8013ec:	83 c4 10             	add    $0x10,%esp
  8013ef:	85 c0                	test   %eax,%eax
  8013f1:	78 3f                	js     801432 <serve_stat+0x5e>
	strcpy(ret->ret_name, o->o_file->f_name);
  8013f3:	83 ec 08             	sub    $0x8,%esp
  8013f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013f9:	ff 70 04             	pushl  0x4(%eax)
  8013fc:	53                   	push   %ebx
  8013fd:	e8 a2 0e 00 00       	call   8022a4 <strcpy>
	ret->ret_size = o->o_file->f_size;
  801402:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801405:	8b 50 04             	mov    0x4(%eax),%edx
  801408:	8b 92 80 00 00 00    	mov    0x80(%edx),%edx
  80140e:	89 93 80 00 00 00    	mov    %edx,0x80(%ebx)
	ret->ret_isdir = (o->o_file->f_type == FTYPE_DIR);
  801414:	8b 40 04             	mov    0x4(%eax),%eax
  801417:	83 c4 10             	add    $0x10,%esp
  80141a:	83 b8 84 00 00 00 01 	cmpl   $0x1,0x84(%eax)
  801421:	0f 94 c0             	sete   %al
  801424:	0f b6 c0             	movzbl %al,%eax
  801427:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80142d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801432:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801435:	c9                   	leave  
  801436:	c3                   	ret    

00801437 <serve_flush>:
{
  801437:	55                   	push   %ebp
  801438:	89 e5                	mov    %esp,%ebp
  80143a:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  80143d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801440:	50                   	push   %eax
  801441:	8b 45 0c             	mov    0xc(%ebp),%eax
  801444:	ff 30                	pushl  (%eax)
  801446:	ff 75 08             	pushl  0x8(%ebp)
  801449:	e8 58 fe ff ff       	call   8012a6 <openfile_lookup>
  80144e:	83 c4 10             	add    $0x10,%esp
  801451:	85 c0                	test   %eax,%eax
  801453:	78 16                	js     80146b <serve_flush+0x34>
	file_flush(o->o_file);
  801455:	83 ec 0c             	sub    $0xc,%esp
  801458:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80145b:	ff 70 04             	pushl  0x4(%eax)
  80145e:	e8 4d fb ff ff       	call   800fb0 <file_flush>
	return 0;
  801463:	83 c4 10             	add    $0x10,%esp
  801466:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80146b:	c9                   	leave  
  80146c:	c3                   	ret    

0080146d <serve_open>:
{
  80146d:	55                   	push   %ebp
  80146e:	89 e5                	mov    %esp,%ebp
  801470:	53                   	push   %ebx
  801471:	81 ec 18 04 00 00    	sub    $0x418,%esp
  801477:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	memmove(path, req->req_path, MAXPATHLEN);
  80147a:	68 00 04 00 00       	push   $0x400
  80147f:	53                   	push   %ebx
  801480:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  801486:	50                   	push   %eax
  801487:	e8 a6 0f 00 00       	call   802432 <memmove>
	path[MAXPATHLEN-1] = 0;
  80148c:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
	if ((r = openfile_alloc(&o)) < 0) {
  801490:	8d 85 f0 fb ff ff    	lea    -0x410(%ebp),%eax
  801496:	89 04 24             	mov    %eax,(%esp)
  801499:	e8 6f fd ff ff       	call   80120d <openfile_alloc>
  80149e:	83 c4 10             	add    $0x10,%esp
  8014a1:	85 c0                	test   %eax,%eax
  8014a3:	0f 88 f0 00 00 00    	js     801599 <serve_open+0x12c>
	if (req->req_omode & O_CREAT) {
  8014a9:	f6 83 01 04 00 00 01 	testb  $0x1,0x401(%ebx)
  8014b0:	74 33                	je     8014e5 <serve_open+0x78>
		if ((r = file_create(path, &f)) < 0) {
  8014b2:	83 ec 08             	sub    $0x8,%esp
  8014b5:	8d 85 f4 fb ff ff    	lea    -0x40c(%ebp),%eax
  8014bb:	50                   	push   %eax
  8014bc:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  8014c2:	50                   	push   %eax
  8014c3:	e8 89 fb ff ff       	call   801051 <file_create>
  8014c8:	83 c4 10             	add    $0x10,%esp
  8014cb:	85 c0                	test   %eax,%eax
  8014cd:	79 37                	jns    801506 <serve_open+0x99>
			if (!(req->req_omode & O_EXCL) && r == -E_FILE_EXISTS)
  8014cf:	f6 83 01 04 00 00 04 	testb  $0x4,0x401(%ebx)
  8014d6:	0f 85 bd 00 00 00    	jne    801599 <serve_open+0x12c>
  8014dc:	83 f8 f3             	cmp    $0xfffffff3,%eax
  8014df:	0f 85 b4 00 00 00    	jne    801599 <serve_open+0x12c>
		if ((r = file_open(path, &f)) < 0) {
  8014e5:	83 ec 08             	sub    $0x8,%esp
  8014e8:	8d 85 f4 fb ff ff    	lea    -0x40c(%ebp),%eax
  8014ee:	50                   	push   %eax
  8014ef:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  8014f5:	50                   	push   %eax
  8014f6:	e8 69 f8 ff ff       	call   800d64 <file_open>
  8014fb:	83 c4 10             	add    $0x10,%esp
  8014fe:	85 c0                	test   %eax,%eax
  801500:	0f 88 93 00 00 00    	js     801599 <serve_open+0x12c>
	if (req->req_omode & O_TRUNC) {
  801506:	f6 83 01 04 00 00 02 	testb  $0x2,0x401(%ebx)
  80150d:	74 17                	je     801526 <serve_open+0xb9>
		if ((r = file_set_size(f, 0)) < 0) {
  80150f:	83 ec 08             	sub    $0x8,%esp
  801512:	6a 00                	push   $0x0
  801514:	ff b5 f4 fb ff ff    	pushl  -0x40c(%ebp)
  80151a:	e8 0c f9 ff ff       	call   800e2b <file_set_size>
  80151f:	83 c4 10             	add    $0x10,%esp
  801522:	85 c0                	test   %eax,%eax
  801524:	78 73                	js     801599 <serve_open+0x12c>
	if ((r = file_open(path, &f)) < 0) {
  801526:	83 ec 08             	sub    $0x8,%esp
  801529:	8d 85 f4 fb ff ff    	lea    -0x40c(%ebp),%eax
  80152f:	50                   	push   %eax
  801530:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  801536:	50                   	push   %eax
  801537:	e8 28 f8 ff ff       	call   800d64 <file_open>
  80153c:	83 c4 10             	add    $0x10,%esp
  80153f:	85 c0                	test   %eax,%eax
  801541:	78 56                	js     801599 <serve_open+0x12c>
	o->o_file = f;
  801543:	8b 85 f0 fb ff ff    	mov    -0x410(%ebp),%eax
  801549:	8b 95 f4 fb ff ff    	mov    -0x40c(%ebp),%edx
  80154f:	89 50 04             	mov    %edx,0x4(%eax)
	o->o_fd->fd_file.id = o->o_fileid;
  801552:	8b 50 0c             	mov    0xc(%eax),%edx
  801555:	8b 08                	mov    (%eax),%ecx
  801557:	89 4a 0c             	mov    %ecx,0xc(%edx)
	o->o_fd->fd_omode = req->req_omode & O_ACCMODE;
  80155a:	8b 48 0c             	mov    0xc(%eax),%ecx
  80155d:	8b 93 00 04 00 00    	mov    0x400(%ebx),%edx
  801563:	83 e2 03             	and    $0x3,%edx
  801566:	89 51 08             	mov    %edx,0x8(%ecx)
	o->o_fd->fd_dev_id = devfile.dev_id;
  801569:	8b 40 0c             	mov    0xc(%eax),%eax
  80156c:	8b 15 64 90 80 00    	mov    0x809064,%edx
  801572:	89 10                	mov    %edx,(%eax)
	o->o_mode = req->req_omode;
  801574:	8b 85 f0 fb ff ff    	mov    -0x410(%ebp),%eax
  80157a:	8b 93 00 04 00 00    	mov    0x400(%ebx),%edx
  801580:	89 50 08             	mov    %edx,0x8(%eax)
	*pg_store = o->o_fd;
  801583:	8b 50 0c             	mov    0xc(%eax),%edx
  801586:	8b 45 10             	mov    0x10(%ebp),%eax
  801589:	89 10                	mov    %edx,(%eax)
	*perm_store = PTE_P|PTE_U|PTE_W|PTE_SHARE;
  80158b:	8b 45 14             	mov    0x14(%ebp),%eax
  80158e:	c7 00 07 04 00 00    	movl   $0x407,(%eax)
	return 0;
  801594:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801599:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80159c:	c9                   	leave  
  80159d:	c3                   	ret    

0080159e <serve>:
	[FSREQ_SYNC] =		serve_sync
};

void
serve(void)
{
  80159e:	55                   	push   %ebp
  80159f:	89 e5                	mov    %esp,%ebp
  8015a1:	56                   	push   %esi
  8015a2:	53                   	push   %ebx
  8015a3:	83 ec 10             	sub    $0x10,%esp
	int perm, r;
	void *pg;

	while (1) {
		perm = 0;
		req = ipc_recv((int32_t *) &whom, fsreq, &perm);
  8015a6:	8d 5d f0             	lea    -0x10(%ebp),%ebx
  8015a9:	8d 75 f4             	lea    -0xc(%ebp),%esi
  8015ac:	eb 68                	jmp    801616 <serve+0x78>
			cprintf("fs req %d from %08x [page %08x: %s]\n",
				req, whom, uvpt[PGNUM(fsreq)], fsreq);

		// All requests must contain an argument page
		if (!(perm & PTE_P)) {
			cprintf("Invalid request from %08x: no argument page\n",
  8015ae:	83 ec 08             	sub    $0x8,%esp
  8015b1:	ff 75 f4             	pushl  -0xc(%ebp)
  8015b4:	68 ec 40 80 00       	push   $0x8040ec
  8015b9:	e8 49 06 00 00       	call   801c07 <cprintf>
				whom);
			continue; // just leave it hanging...
  8015be:	83 c4 10             	add    $0x10,%esp
  8015c1:	eb 53                	jmp    801616 <serve+0x78>
		}

		pg = NULL;
		if (req == FSREQ_OPEN) {
			r = serve_open(whom, (struct Fsreq_open*)fsreq, &pg, &perm);
  8015c3:	53                   	push   %ebx
  8015c4:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8015c7:	50                   	push   %eax
  8015c8:	ff 35 44 50 80 00    	pushl  0x805044
  8015ce:	ff 75 f4             	pushl  -0xc(%ebp)
  8015d1:	e8 97 fe ff ff       	call   80146d <serve_open>
  8015d6:	83 c4 10             	add    $0x10,%esp
  8015d9:	eb 19                	jmp    8015f4 <serve+0x56>
		} else if (req < ARRAY_SIZE(handlers) && handlers[req]) {
			r = handlers[req](whom, fsreq);
		} else {
			cprintf("Invalid request code %d from %08x\n", req, whom);
  8015db:	83 ec 04             	sub    $0x4,%esp
  8015de:	ff 75 f4             	pushl  -0xc(%ebp)
  8015e1:	50                   	push   %eax
  8015e2:	68 1c 41 80 00       	push   $0x80411c
  8015e7:	e8 1b 06 00 00       	call   801c07 <cprintf>
  8015ec:	83 c4 10             	add    $0x10,%esp
			r = -E_INVAL;
  8015ef:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		}
		ipc_send(whom, r, pg, perm);
  8015f4:	ff 75 f0             	pushl  -0x10(%ebp)
  8015f7:	ff 75 ec             	pushl  -0x14(%ebp)
  8015fa:	50                   	push   %eax
  8015fb:	ff 75 f4             	pushl  -0xc(%ebp)
  8015fe:	e8 b2 13 00 00       	call   8029b5 <ipc_send>
		sys_page_unmap(0, fsreq);
  801603:	83 c4 08             	add    $0x8,%esp
  801606:	ff 35 44 50 80 00    	pushl  0x805044
  80160c:	6a 00                	push   $0x0
  80160e:	e8 0f 11 00 00       	call   802722 <sys_page_unmap>
  801613:	83 c4 10             	add    $0x10,%esp
		perm = 0;
  801616:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		req = ipc_recv((int32_t *) &whom, fsreq, &perm);
  80161d:	83 ec 04             	sub    $0x4,%esp
  801620:	53                   	push   %ebx
  801621:	ff 35 44 50 80 00    	pushl  0x805044
  801627:	56                   	push   %esi
  801628:	e8 1f 13 00 00       	call   80294c <ipc_recv>
		if (!(perm & PTE_P)) {
  80162d:	83 c4 10             	add    $0x10,%esp
  801630:	f6 45 f0 01          	testb  $0x1,-0x10(%ebp)
  801634:	0f 84 74 ff ff ff    	je     8015ae <serve+0x10>
		pg = NULL;
  80163a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		if (req == FSREQ_OPEN) {
  801641:	83 f8 01             	cmp    $0x1,%eax
  801644:	0f 84 79 ff ff ff    	je     8015c3 <serve+0x25>
		} else if (req < ARRAY_SIZE(handlers) && handlers[req]) {
  80164a:	83 f8 08             	cmp    $0x8,%eax
  80164d:	77 8c                	ja     8015db <serve+0x3d>
  80164f:	8b 14 85 20 50 80 00 	mov    0x805020(,%eax,4),%edx
  801656:	85 d2                	test   %edx,%edx
  801658:	74 81                	je     8015db <serve+0x3d>
			r = handlers[req](whom, fsreq);
  80165a:	83 ec 08             	sub    $0x8,%esp
  80165d:	ff 35 44 50 80 00    	pushl  0x805044
  801663:	ff 75 f4             	pushl  -0xc(%ebp)
  801666:	ff d2                	call   *%edx
  801668:	83 c4 10             	add    $0x10,%esp
  80166b:	eb 87                	jmp    8015f4 <serve+0x56>

0080166d <umain>:
	}
}

void
umain(int argc, char **argv)
{
  80166d:	55                   	push   %ebp
  80166e:	89 e5                	mov    %esp,%ebp
  801670:	83 ec 14             	sub    $0x14,%esp
	static_assert(sizeof(struct File) == 256);
	binaryname = "fs";
  801673:	c7 05 60 90 80 00 3f 	movl   $0x80413f,0x809060
  80167a:	41 80 00 
	cprintf("FS is running\n");
  80167d:	68 42 41 80 00       	push   $0x804142
  801682:	e8 80 05 00 00       	call   801c07 <cprintf>
	asm volatile("outw %0,%w1" : : "a" (data), "d" (port));
  801687:	b8 00 8a ff ff       	mov    $0xffff8a00,%eax
  80168c:	ba 00 8a 00 00       	mov    $0x8a00,%edx
  801691:	66 ef                	out    %ax,(%dx)

	// Check that we are able to do I/O
	outw(0x8A00, 0x8A00);
	cprintf("FS can do I/O\n");
  801693:	c7 04 24 51 41 80 00 	movl   $0x804151,(%esp)
  80169a:	e8 68 05 00 00       	call   801c07 <cprintf>

	serve_init();
  80169f:	e8 3d fb ff ff       	call   8011e1 <serve_init>
	fs_init();
  8016a4:	e8 bb f3 ff ff       	call   800a64 <fs_init>
	serve();
  8016a9:	e8 f0 fe ff ff       	call   80159e <serve>

008016ae <fs_test>:

static char *msg = "This is the NEW message of the day!\n\n";

void
fs_test(void)
{
  8016ae:	55                   	push   %ebp
  8016af:	89 e5                	mov    %esp,%ebp
  8016b1:	53                   	push   %ebx
  8016b2:	83 ec 18             	sub    $0x18,%esp
	int r;
	char *blk;
	uint32_t *bits;

	// back up bitmap
	if ((r = sys_page_alloc(0, (void*) PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  8016b5:	6a 07                	push   $0x7
  8016b7:	68 00 10 00 00       	push   $0x1000
  8016bc:	6a 00                	push   $0x0
  8016be:	e8 da 0f 00 00       	call   80269d <sys_page_alloc>
  8016c3:	83 c4 10             	add    $0x10,%esp
  8016c6:	85 c0                	test   %eax,%eax
  8016c8:	0f 88 6a 02 00 00    	js     801938 <fs_test+0x28a>
		panic("sys_page_alloc: %e", r);
	bits = (uint32_t*) PGSIZE;
	memmove(bits, bitmap, PGSIZE);
  8016ce:	83 ec 04             	sub    $0x4,%esp
  8016d1:	68 00 10 00 00       	push   $0x1000
  8016d6:	ff 35 08 a0 80 00    	pushl  0x80a008
  8016dc:	68 00 10 00 00       	push   $0x1000
  8016e1:	e8 4c 0d 00 00       	call   802432 <memmove>
	// allocate block
	if ((r = alloc_block()) < 0)
  8016e6:	e8 b5 f1 ff ff       	call   8008a0 <alloc_block>
  8016eb:	83 c4 10             	add    $0x10,%esp
  8016ee:	85 c0                	test   %eax,%eax
  8016f0:	0f 88 54 02 00 00    	js     80194a <fs_test+0x29c>
		panic("alloc_block: %e", r);
	// check that block was free
	assert(bits[r/32] & (1 << (r%32)));
  8016f6:	8d 50 1f             	lea    0x1f(%eax),%edx
  8016f9:	85 c0                	test   %eax,%eax
  8016fb:	0f 49 d0             	cmovns %eax,%edx
  8016fe:	c1 fa 05             	sar    $0x5,%edx
  801701:	89 c3                	mov    %eax,%ebx
  801703:	c1 fb 1f             	sar    $0x1f,%ebx
  801706:	c1 eb 1b             	shr    $0x1b,%ebx
  801709:	8d 0c 18             	lea    (%eax,%ebx,1),%ecx
  80170c:	83 e1 1f             	and    $0x1f,%ecx
  80170f:	29 d9                	sub    %ebx,%ecx
  801711:	b8 01 00 00 00       	mov    $0x1,%eax
  801716:	d3 e0                	shl    %cl,%eax
  801718:	85 04 95 00 10 00 00 	test   %eax,0x1000(,%edx,4)
  80171f:	0f 84 37 02 00 00    	je     80195c <fs_test+0x2ae>
	// and is not free any more
	assert(!(bitmap[r/32] & (1 << (r%32))));
  801725:	8b 0d 08 a0 80 00    	mov    0x80a008,%ecx
  80172b:	85 04 91             	test   %eax,(%ecx,%edx,4)
  80172e:	0f 85 3e 02 00 00    	jne    801972 <fs_test+0x2c4>
	cprintf("alloc_block is good\n");
  801734:	83 ec 0c             	sub    $0xc,%esp
  801737:	68 a8 41 80 00       	push   $0x8041a8
  80173c:	e8 c6 04 00 00       	call   801c07 <cprintf>

	if ((r = file_open("/not-found", &f)) < 0 && r != -E_NOT_FOUND)
  801741:	83 c4 08             	add    $0x8,%esp
  801744:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801747:	50                   	push   %eax
  801748:	68 bd 41 80 00       	push   $0x8041bd
  80174d:	e8 12 f6 ff ff       	call   800d64 <file_open>
  801752:	83 c4 10             	add    $0x10,%esp
  801755:	83 f8 f5             	cmp    $0xfffffff5,%eax
  801758:	74 08                	je     801762 <fs_test+0xb4>
  80175a:	85 c0                	test   %eax,%eax
  80175c:	0f 88 26 02 00 00    	js     801988 <fs_test+0x2da>
		panic("file_open /not-found: %e", r);
	else if (r == 0)
  801762:	85 c0                	test   %eax,%eax
  801764:	0f 84 30 02 00 00    	je     80199a <fs_test+0x2ec>
		panic("file_open /not-found succeeded!");
	if ((r = file_open("/newmotd", &f)) < 0)
  80176a:	83 ec 08             	sub    $0x8,%esp
  80176d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801770:	50                   	push   %eax
  801771:	68 e1 41 80 00       	push   $0x8041e1
  801776:	e8 e9 f5 ff ff       	call   800d64 <file_open>
  80177b:	83 c4 10             	add    $0x10,%esp
  80177e:	85 c0                	test   %eax,%eax
  801780:	0f 88 28 02 00 00    	js     8019ae <fs_test+0x300>
		panic("file_open /newmotd: %e", r);
	cprintf("file_open is good\n");
  801786:	83 ec 0c             	sub    $0xc,%esp
  801789:	68 01 42 80 00       	push   $0x804201
  80178e:	e8 74 04 00 00       	call   801c07 <cprintf>

	if ((r = file_get_block(f, 0, &blk)) < 0)
  801793:	83 c4 0c             	add    $0xc,%esp
  801796:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801799:	50                   	push   %eax
  80179a:	6a 00                	push   $0x0
  80179c:	ff 75 f4             	pushl  -0xc(%ebp)
  80179f:	e8 1f f3 ff ff       	call   800ac3 <file_get_block>
  8017a4:	83 c4 10             	add    $0x10,%esp
  8017a7:	85 c0                	test   %eax,%eax
  8017a9:	0f 88 11 02 00 00    	js     8019c0 <fs_test+0x312>
		panic("file_get_block: %e", r);
	if (strcmp(blk, msg) != 0)
  8017af:	83 ec 08             	sub    $0x8,%esp
  8017b2:	68 48 43 80 00       	push   $0x804348
  8017b7:	ff 75 f0             	pushl  -0x10(%ebp)
  8017ba:	e8 8b 0b 00 00       	call   80234a <strcmp>
  8017bf:	83 c4 10             	add    $0x10,%esp
  8017c2:	85 c0                	test   %eax,%eax
  8017c4:	0f 85 08 02 00 00    	jne    8019d2 <fs_test+0x324>
		panic("file_get_block returned wrong data");
	cprintf("file_get_block is good\n");
  8017ca:	83 ec 0c             	sub    $0xc,%esp
  8017cd:	68 27 42 80 00       	push   $0x804227
  8017d2:	e8 30 04 00 00       	call   801c07 <cprintf>

	*(volatile char*)blk = *(volatile char*)blk;
  8017d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017da:	0f b6 10             	movzbl (%eax),%edx
  8017dd:	88 10                	mov    %dl,(%eax)
	assert((uvpt[PGNUM(blk)] & PTE_D));
  8017df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017e2:	c1 e8 0c             	shr    $0xc,%eax
  8017e5:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8017ec:	83 c4 10             	add    $0x10,%esp
  8017ef:	a8 40                	test   $0x40,%al
  8017f1:	0f 84 ef 01 00 00    	je     8019e6 <fs_test+0x338>
	file_flush(f);
  8017f7:	83 ec 0c             	sub    $0xc,%esp
  8017fa:	ff 75 f4             	pushl  -0xc(%ebp)
  8017fd:	e8 ae f7 ff ff       	call   800fb0 <file_flush>
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  801802:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801805:	c1 e8 0c             	shr    $0xc,%eax
  801808:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80180f:	83 c4 10             	add    $0x10,%esp
  801812:	a8 40                	test   $0x40,%al
  801814:	0f 85 e2 01 00 00    	jne    8019fc <fs_test+0x34e>
	cprintf("file_flush is good\n");
  80181a:	83 ec 0c             	sub    $0xc,%esp
  80181d:	68 5b 42 80 00       	push   $0x80425b
  801822:	e8 e0 03 00 00       	call   801c07 <cprintf>

	if ((r = file_set_size(f, 0)) < 0)
  801827:	83 c4 08             	add    $0x8,%esp
  80182a:	6a 00                	push   $0x0
  80182c:	ff 75 f4             	pushl  -0xc(%ebp)
  80182f:	e8 f7 f5 ff ff       	call   800e2b <file_set_size>
  801834:	83 c4 10             	add    $0x10,%esp
  801837:	85 c0                	test   %eax,%eax
  801839:	0f 88 d3 01 00 00    	js     801a12 <fs_test+0x364>
		panic("file_set_size: %e", r);
	assert(f->f_direct[0] == 0);
  80183f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801842:	83 b8 88 00 00 00 00 	cmpl   $0x0,0x88(%eax)
  801849:	0f 85 d5 01 00 00    	jne    801a24 <fs_test+0x376>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  80184f:	c1 e8 0c             	shr    $0xc,%eax
  801852:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801859:	a8 40                	test   $0x40,%al
  80185b:	0f 85 d9 01 00 00    	jne    801a3a <fs_test+0x38c>
	cprintf("file_truncate is good\n");
  801861:	83 ec 0c             	sub    $0xc,%esp
  801864:	68 af 42 80 00       	push   $0x8042af
  801869:	e8 99 03 00 00       	call   801c07 <cprintf>

	if ((r = file_set_size(f, strlen(msg))) < 0)
  80186e:	c7 04 24 48 43 80 00 	movl   $0x804348,(%esp)
  801875:	e8 f3 09 00 00       	call   80226d <strlen>
  80187a:	83 c4 08             	add    $0x8,%esp
  80187d:	50                   	push   %eax
  80187e:	ff 75 f4             	pushl  -0xc(%ebp)
  801881:	e8 a5 f5 ff ff       	call   800e2b <file_set_size>
  801886:	83 c4 10             	add    $0x10,%esp
  801889:	85 c0                	test   %eax,%eax
  80188b:	0f 88 bf 01 00 00    	js     801a50 <fs_test+0x3a2>
		panic("file_set_size 2: %e", r);
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801891:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801894:	89 c2                	mov    %eax,%edx
  801896:	c1 ea 0c             	shr    $0xc,%edx
  801899:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8018a0:	f6 c2 40             	test   $0x40,%dl
  8018a3:	0f 85 b9 01 00 00    	jne    801a62 <fs_test+0x3b4>
	if ((r = file_get_block(f, 0, &blk)) < 0)
  8018a9:	83 ec 04             	sub    $0x4,%esp
  8018ac:	8d 55 f0             	lea    -0x10(%ebp),%edx
  8018af:	52                   	push   %edx
  8018b0:	6a 00                	push   $0x0
  8018b2:	50                   	push   %eax
  8018b3:	e8 0b f2 ff ff       	call   800ac3 <file_get_block>
  8018b8:	83 c4 10             	add    $0x10,%esp
  8018bb:	85 c0                	test   %eax,%eax
  8018bd:	0f 88 b5 01 00 00    	js     801a78 <fs_test+0x3ca>
		panic("file_get_block 2: %e", r);
	strcpy(blk, msg);
  8018c3:	83 ec 08             	sub    $0x8,%esp
  8018c6:	68 48 43 80 00       	push   $0x804348
  8018cb:	ff 75 f0             	pushl  -0x10(%ebp)
  8018ce:	e8 d1 09 00 00       	call   8022a4 <strcpy>
	assert((uvpt[PGNUM(blk)] & PTE_D));
  8018d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018d6:	c1 e8 0c             	shr    $0xc,%eax
  8018d9:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8018e0:	83 c4 10             	add    $0x10,%esp
  8018e3:	a8 40                	test   $0x40,%al
  8018e5:	0f 84 9f 01 00 00    	je     801a8a <fs_test+0x3dc>
	file_flush(f);
  8018eb:	83 ec 0c             	sub    $0xc,%esp
  8018ee:	ff 75 f4             	pushl  -0xc(%ebp)
  8018f1:	e8 ba f6 ff ff       	call   800fb0 <file_flush>
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  8018f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018f9:	c1 e8 0c             	shr    $0xc,%eax
  8018fc:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801903:	83 c4 10             	add    $0x10,%esp
  801906:	a8 40                	test   $0x40,%al
  801908:	0f 85 92 01 00 00    	jne    801aa0 <fs_test+0x3f2>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  80190e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801911:	c1 e8 0c             	shr    $0xc,%eax
  801914:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80191b:	a8 40                	test   $0x40,%al
  80191d:	0f 85 93 01 00 00    	jne    801ab6 <fs_test+0x408>
	cprintf("file rewrite is good\n");
  801923:	83 ec 0c             	sub    $0xc,%esp
  801926:	68 ef 42 80 00       	push   $0x8042ef
  80192b:	e8 d7 02 00 00       	call   801c07 <cprintf>
}
  801930:	83 c4 10             	add    $0x10,%esp
  801933:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801936:	c9                   	leave  
  801937:	c3                   	ret    
		panic("sys_page_alloc: %e", r);
  801938:	50                   	push   %eax
  801939:	68 60 41 80 00       	push   $0x804160
  80193e:	6a 12                	push   $0x12
  801940:	68 73 41 80 00       	push   $0x804173
  801945:	e8 e2 01 00 00       	call   801b2c <_panic>
		panic("alloc_block: %e", r);
  80194a:	50                   	push   %eax
  80194b:	68 7d 41 80 00       	push   $0x80417d
  801950:	6a 17                	push   $0x17
  801952:	68 73 41 80 00       	push   $0x804173
  801957:	e8 d0 01 00 00       	call   801b2c <_panic>
	assert(bits[r/32] & (1 << (r%32)));
  80195c:	68 8d 41 80 00       	push   $0x80418d
  801961:	68 7d 3e 80 00       	push   $0x803e7d
  801966:	6a 19                	push   $0x19
  801968:	68 73 41 80 00       	push   $0x804173
  80196d:	e8 ba 01 00 00       	call   801b2c <_panic>
	assert(!(bitmap[r/32] & (1 << (r%32))));
  801972:	68 08 43 80 00       	push   $0x804308
  801977:	68 7d 3e 80 00       	push   $0x803e7d
  80197c:	6a 1b                	push   $0x1b
  80197e:	68 73 41 80 00       	push   $0x804173
  801983:	e8 a4 01 00 00       	call   801b2c <_panic>
		panic("file_open /not-found: %e", r);
  801988:	50                   	push   %eax
  801989:	68 c8 41 80 00       	push   $0x8041c8
  80198e:	6a 1f                	push   $0x1f
  801990:	68 73 41 80 00       	push   $0x804173
  801995:	e8 92 01 00 00       	call   801b2c <_panic>
		panic("file_open /not-found succeeded!");
  80199a:	83 ec 04             	sub    $0x4,%esp
  80199d:	68 28 43 80 00       	push   $0x804328
  8019a2:	6a 21                	push   $0x21
  8019a4:	68 73 41 80 00       	push   $0x804173
  8019a9:	e8 7e 01 00 00       	call   801b2c <_panic>
		panic("file_open /newmotd: %e", r);
  8019ae:	50                   	push   %eax
  8019af:	68 ea 41 80 00       	push   $0x8041ea
  8019b4:	6a 23                	push   $0x23
  8019b6:	68 73 41 80 00       	push   $0x804173
  8019bb:	e8 6c 01 00 00       	call   801b2c <_panic>
		panic("file_get_block: %e", r);
  8019c0:	50                   	push   %eax
  8019c1:	68 14 42 80 00       	push   $0x804214
  8019c6:	6a 27                	push   $0x27
  8019c8:	68 73 41 80 00       	push   $0x804173
  8019cd:	e8 5a 01 00 00       	call   801b2c <_panic>
		panic("file_get_block returned wrong data");
  8019d2:	83 ec 04             	sub    $0x4,%esp
  8019d5:	68 70 43 80 00       	push   $0x804370
  8019da:	6a 29                	push   $0x29
  8019dc:	68 73 41 80 00       	push   $0x804173
  8019e1:	e8 46 01 00 00       	call   801b2c <_panic>
	assert((uvpt[PGNUM(blk)] & PTE_D));
  8019e6:	68 40 42 80 00       	push   $0x804240
  8019eb:	68 7d 3e 80 00       	push   $0x803e7d
  8019f0:	6a 2d                	push   $0x2d
  8019f2:	68 73 41 80 00       	push   $0x804173
  8019f7:	e8 30 01 00 00       	call   801b2c <_panic>
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  8019fc:	68 3f 42 80 00       	push   $0x80423f
  801a01:	68 7d 3e 80 00       	push   $0x803e7d
  801a06:	6a 2f                	push   $0x2f
  801a08:	68 73 41 80 00       	push   $0x804173
  801a0d:	e8 1a 01 00 00       	call   801b2c <_panic>
		panic("file_set_size: %e", r);
  801a12:	50                   	push   %eax
  801a13:	68 6f 42 80 00       	push   $0x80426f
  801a18:	6a 33                	push   $0x33
  801a1a:	68 73 41 80 00       	push   $0x804173
  801a1f:	e8 08 01 00 00       	call   801b2c <_panic>
	assert(f->f_direct[0] == 0);
  801a24:	68 81 42 80 00       	push   $0x804281
  801a29:	68 7d 3e 80 00       	push   $0x803e7d
  801a2e:	6a 34                	push   $0x34
  801a30:	68 73 41 80 00       	push   $0x804173
  801a35:	e8 f2 00 00 00       	call   801b2c <_panic>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801a3a:	68 95 42 80 00       	push   $0x804295
  801a3f:	68 7d 3e 80 00       	push   $0x803e7d
  801a44:	6a 35                	push   $0x35
  801a46:	68 73 41 80 00       	push   $0x804173
  801a4b:	e8 dc 00 00 00       	call   801b2c <_panic>
		panic("file_set_size 2: %e", r);
  801a50:	50                   	push   %eax
  801a51:	68 c6 42 80 00       	push   $0x8042c6
  801a56:	6a 39                	push   $0x39
  801a58:	68 73 41 80 00       	push   $0x804173
  801a5d:	e8 ca 00 00 00       	call   801b2c <_panic>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801a62:	68 95 42 80 00       	push   $0x804295
  801a67:	68 7d 3e 80 00       	push   $0x803e7d
  801a6c:	6a 3a                	push   $0x3a
  801a6e:	68 73 41 80 00       	push   $0x804173
  801a73:	e8 b4 00 00 00       	call   801b2c <_panic>
		panic("file_get_block 2: %e", r);
  801a78:	50                   	push   %eax
  801a79:	68 da 42 80 00       	push   $0x8042da
  801a7e:	6a 3c                	push   $0x3c
  801a80:	68 73 41 80 00       	push   $0x804173
  801a85:	e8 a2 00 00 00       	call   801b2c <_panic>
	assert((uvpt[PGNUM(blk)] & PTE_D));
  801a8a:	68 40 42 80 00       	push   $0x804240
  801a8f:	68 7d 3e 80 00       	push   $0x803e7d
  801a94:	6a 3e                	push   $0x3e
  801a96:	68 73 41 80 00       	push   $0x804173
  801a9b:	e8 8c 00 00 00       	call   801b2c <_panic>
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  801aa0:	68 3f 42 80 00       	push   $0x80423f
  801aa5:	68 7d 3e 80 00       	push   $0x803e7d
  801aaa:	6a 40                	push   $0x40
  801aac:	68 73 41 80 00       	push   $0x804173
  801ab1:	e8 76 00 00 00       	call   801b2c <_panic>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801ab6:	68 95 42 80 00       	push   $0x804295
  801abb:	68 7d 3e 80 00       	push   $0x803e7d
  801ac0:	6a 41                	push   $0x41
  801ac2:	68 73 41 80 00       	push   $0x804173
  801ac7:	e8 60 00 00 00       	call   801b2c <_panic>

00801acc <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  801acc:	55                   	push   %ebp
  801acd:	89 e5                	mov    %esp,%ebp
  801acf:	56                   	push   %esi
  801ad0:	53                   	push   %ebx
  801ad1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801ad4:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
    thisenv = &envs[ENVX(sys_getenvid())];
  801ad7:	e8 83 0b 00 00       	call   80265f <sys_getenvid>
  801adc:	25 ff 03 00 00       	and    $0x3ff,%eax
  801ae1:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801ae4:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801ae9:	a3 10 a0 80 00       	mov    %eax,0x80a010

	// save the name of the program so that panic() can use it
	if (argc > 0)
  801aee:	85 db                	test   %ebx,%ebx
  801af0:	7e 07                	jle    801af9 <libmain+0x2d>
		binaryname = argv[0];
  801af2:	8b 06                	mov    (%esi),%eax
  801af4:	a3 60 90 80 00       	mov    %eax,0x809060

	// call user main routine
	umain(argc, argv);
  801af9:	83 ec 08             	sub    $0x8,%esp
  801afc:	56                   	push   %esi
  801afd:	53                   	push   %ebx
  801afe:	e8 6a fb ff ff       	call   80166d <umain>

	// exit gracefully
	exit();
  801b03:	e8 0a 00 00 00       	call   801b12 <exit>
}
  801b08:	83 c4 10             	add    $0x10,%esp
  801b0b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b0e:	5b                   	pop    %ebx
  801b0f:	5e                   	pop    %esi
  801b10:	5d                   	pop    %ebp
  801b11:	c3                   	ret    

00801b12 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  801b12:	55                   	push   %ebp
  801b13:	89 e5                	mov    %esp,%ebp
  801b15:	83 ec 08             	sub    $0x8,%esp
	close_all();
  801b18:	e8 00 11 00 00       	call   802c1d <close_all>
	sys_env_destroy(0);
  801b1d:	83 ec 0c             	sub    $0xc,%esp
  801b20:	6a 00                	push   $0x0
  801b22:	e8 f7 0a 00 00       	call   80261e <sys_env_destroy>
}
  801b27:	83 c4 10             	add    $0x10,%esp
  801b2a:	c9                   	leave  
  801b2b:	c3                   	ret    

00801b2c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801b2c:	55                   	push   %ebp
  801b2d:	89 e5                	mov    %esp,%ebp
  801b2f:	56                   	push   %esi
  801b30:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801b31:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801b34:	8b 35 60 90 80 00    	mov    0x809060,%esi
  801b3a:	e8 20 0b 00 00       	call   80265f <sys_getenvid>
  801b3f:	83 ec 0c             	sub    $0xc,%esp
  801b42:	ff 75 0c             	pushl  0xc(%ebp)
  801b45:	ff 75 08             	pushl  0x8(%ebp)
  801b48:	56                   	push   %esi
  801b49:	50                   	push   %eax
  801b4a:	68 a0 43 80 00       	push   $0x8043a0
  801b4f:	e8 b3 00 00 00       	call   801c07 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801b54:	83 c4 18             	add    $0x18,%esp
  801b57:	53                   	push   %ebx
  801b58:	ff 75 10             	pushl  0x10(%ebp)
  801b5b:	e8 56 00 00 00       	call   801bb6 <vcprintf>
	cprintf("\n");
  801b60:	c7 04 24 b0 3f 80 00 	movl   $0x803fb0,(%esp)
  801b67:	e8 9b 00 00 00       	call   801c07 <cprintf>
  801b6c:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801b6f:	cc                   	int3   
  801b70:	eb fd                	jmp    801b6f <_panic+0x43>

00801b72 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  801b72:	55                   	push   %ebp
  801b73:	89 e5                	mov    %esp,%ebp
  801b75:	53                   	push   %ebx
  801b76:	83 ec 04             	sub    $0x4,%esp
  801b79:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801b7c:	8b 13                	mov    (%ebx),%edx
  801b7e:	8d 42 01             	lea    0x1(%edx),%eax
  801b81:	89 03                	mov    %eax,(%ebx)
  801b83:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b86:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801b8a:	3d ff 00 00 00       	cmp    $0xff,%eax
  801b8f:	74 09                	je     801b9a <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  801b91:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  801b95:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b98:	c9                   	leave  
  801b99:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  801b9a:	83 ec 08             	sub    $0x8,%esp
  801b9d:	68 ff 00 00 00       	push   $0xff
  801ba2:	8d 43 08             	lea    0x8(%ebx),%eax
  801ba5:	50                   	push   %eax
  801ba6:	e8 36 0a 00 00       	call   8025e1 <sys_cputs>
		b->idx = 0;
  801bab:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801bb1:	83 c4 10             	add    $0x10,%esp
  801bb4:	eb db                	jmp    801b91 <putch+0x1f>

00801bb6 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  801bb6:	55                   	push   %ebp
  801bb7:	89 e5                	mov    %esp,%ebp
  801bb9:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801bbf:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801bc6:	00 00 00 
	b.cnt = 0;
  801bc9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801bd0:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  801bd3:	ff 75 0c             	pushl  0xc(%ebp)
  801bd6:	ff 75 08             	pushl  0x8(%ebp)
  801bd9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801bdf:	50                   	push   %eax
  801be0:	68 72 1b 80 00       	push   $0x801b72
  801be5:	e8 1a 01 00 00       	call   801d04 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801bea:	83 c4 08             	add    $0x8,%esp
  801bed:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  801bf3:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  801bf9:	50                   	push   %eax
  801bfa:	e8 e2 09 00 00       	call   8025e1 <sys_cputs>

	return b.cnt;
}
  801bff:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  801c05:	c9                   	leave  
  801c06:	c3                   	ret    

00801c07 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  801c07:	55                   	push   %ebp
  801c08:	89 e5                	mov    %esp,%ebp
  801c0a:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801c0d:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  801c10:	50                   	push   %eax
  801c11:	ff 75 08             	pushl  0x8(%ebp)
  801c14:	e8 9d ff ff ff       	call   801bb6 <vcprintf>
	va_end(ap);

	return cnt;
}
  801c19:	c9                   	leave  
  801c1a:	c3                   	ret    

00801c1b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801c1b:	55                   	push   %ebp
  801c1c:	89 e5                	mov    %esp,%ebp
  801c1e:	57                   	push   %edi
  801c1f:	56                   	push   %esi
  801c20:	53                   	push   %ebx
  801c21:	83 ec 1c             	sub    $0x1c,%esp
  801c24:	89 c7                	mov    %eax,%edi
  801c26:	89 d6                	mov    %edx,%esi
  801c28:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c2e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801c31:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801c34:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c37:	bb 00 00 00 00       	mov    $0x0,%ebx
  801c3c:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  801c3f:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  801c42:	39 d3                	cmp    %edx,%ebx
  801c44:	72 05                	jb     801c4b <printnum+0x30>
  801c46:	39 45 10             	cmp    %eax,0x10(%ebp)
  801c49:	77 7a                	ja     801cc5 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801c4b:	83 ec 0c             	sub    $0xc,%esp
  801c4e:	ff 75 18             	pushl  0x18(%ebp)
  801c51:	8b 45 14             	mov    0x14(%ebp),%eax
  801c54:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801c57:	53                   	push   %ebx
  801c58:	ff 75 10             	pushl  0x10(%ebp)
  801c5b:	83 ec 08             	sub    $0x8,%esp
  801c5e:	ff 75 e4             	pushl  -0x1c(%ebp)
  801c61:	ff 75 e0             	pushl  -0x20(%ebp)
  801c64:	ff 75 dc             	pushl  -0x24(%ebp)
  801c67:	ff 75 d8             	pushl  -0x28(%ebp)
  801c6a:	e8 81 1f 00 00       	call   803bf0 <__udivdi3>
  801c6f:	83 c4 18             	add    $0x18,%esp
  801c72:	52                   	push   %edx
  801c73:	50                   	push   %eax
  801c74:	89 f2                	mov    %esi,%edx
  801c76:	89 f8                	mov    %edi,%eax
  801c78:	e8 9e ff ff ff       	call   801c1b <printnum>
  801c7d:	83 c4 20             	add    $0x20,%esp
  801c80:	eb 13                	jmp    801c95 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801c82:	83 ec 08             	sub    $0x8,%esp
  801c85:	56                   	push   %esi
  801c86:	ff 75 18             	pushl  0x18(%ebp)
  801c89:	ff d7                	call   *%edi
  801c8b:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  801c8e:	83 eb 01             	sub    $0x1,%ebx
  801c91:	85 db                	test   %ebx,%ebx
  801c93:	7f ed                	jg     801c82 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801c95:	83 ec 08             	sub    $0x8,%esp
  801c98:	56                   	push   %esi
  801c99:	83 ec 04             	sub    $0x4,%esp
  801c9c:	ff 75 e4             	pushl  -0x1c(%ebp)
  801c9f:	ff 75 e0             	pushl  -0x20(%ebp)
  801ca2:	ff 75 dc             	pushl  -0x24(%ebp)
  801ca5:	ff 75 d8             	pushl  -0x28(%ebp)
  801ca8:	e8 63 20 00 00       	call   803d10 <__umoddi3>
  801cad:	83 c4 14             	add    $0x14,%esp
  801cb0:	0f be 80 c3 43 80 00 	movsbl 0x8043c3(%eax),%eax
  801cb7:	50                   	push   %eax
  801cb8:	ff d7                	call   *%edi
}
  801cba:	83 c4 10             	add    $0x10,%esp
  801cbd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801cc0:	5b                   	pop    %ebx
  801cc1:	5e                   	pop    %esi
  801cc2:	5f                   	pop    %edi
  801cc3:	5d                   	pop    %ebp
  801cc4:	c3                   	ret    
  801cc5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cc8:	eb c4                	jmp    801c8e <printnum+0x73>

00801cca <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801cca:	55                   	push   %ebp
  801ccb:	89 e5                	mov    %esp,%ebp
  801ccd:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801cd0:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  801cd4:	8b 10                	mov    (%eax),%edx
  801cd6:	3b 50 04             	cmp    0x4(%eax),%edx
  801cd9:	73 0a                	jae    801ce5 <sprintputch+0x1b>
		*b->buf++ = ch;
  801cdb:	8d 4a 01             	lea    0x1(%edx),%ecx
  801cde:	89 08                	mov    %ecx,(%eax)
  801ce0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce3:	88 02                	mov    %al,(%edx)
}
  801ce5:	5d                   	pop    %ebp
  801ce6:	c3                   	ret    

00801ce7 <printfmt>:
{
  801ce7:	55                   	push   %ebp
  801ce8:	89 e5                	mov    %esp,%ebp
  801cea:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  801ced:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  801cf0:	50                   	push   %eax
  801cf1:	ff 75 10             	pushl  0x10(%ebp)
  801cf4:	ff 75 0c             	pushl  0xc(%ebp)
  801cf7:	ff 75 08             	pushl  0x8(%ebp)
  801cfa:	e8 05 00 00 00       	call   801d04 <vprintfmt>
}
  801cff:	83 c4 10             	add    $0x10,%esp
  801d02:	c9                   	leave  
  801d03:	c3                   	ret    

00801d04 <vprintfmt>:
{
  801d04:	55                   	push   %ebp
  801d05:	89 e5                	mov    %esp,%ebp
  801d07:	57                   	push   %edi
  801d08:	56                   	push   %esi
  801d09:	53                   	push   %ebx
  801d0a:	83 ec 2c             	sub    $0x2c,%esp
  801d0d:	8b 75 08             	mov    0x8(%ebp),%esi
  801d10:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801d13:	8b 7d 10             	mov    0x10(%ebp),%edi
  801d16:	e9 21 04 00 00       	jmp    80213c <vprintfmt+0x438>
		padc = ' ';
  801d1b:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  801d1f:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  801d26:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  801d2d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801d34:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801d39:	8d 47 01             	lea    0x1(%edi),%eax
  801d3c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d3f:	0f b6 17             	movzbl (%edi),%edx
  801d42:	8d 42 dd             	lea    -0x23(%edx),%eax
  801d45:	3c 55                	cmp    $0x55,%al
  801d47:	0f 87 90 04 00 00    	ja     8021dd <vprintfmt+0x4d9>
  801d4d:	0f b6 c0             	movzbl %al,%eax
  801d50:	ff 24 85 00 45 80 00 	jmp    *0x804500(,%eax,4)
  801d57:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  801d5a:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  801d5e:	eb d9                	jmp    801d39 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  801d60:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  801d63:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  801d67:	eb d0                	jmp    801d39 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  801d69:	0f b6 d2             	movzbl %dl,%edx
  801d6c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  801d6f:	b8 00 00 00 00       	mov    $0x0,%eax
  801d74:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  801d77:	8d 04 80             	lea    (%eax,%eax,4),%eax
  801d7a:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  801d7e:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  801d81:	8d 4a d0             	lea    -0x30(%edx),%ecx
  801d84:	83 f9 09             	cmp    $0x9,%ecx
  801d87:	77 55                	ja     801dde <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  801d89:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  801d8c:	eb e9                	jmp    801d77 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  801d8e:	8b 45 14             	mov    0x14(%ebp),%eax
  801d91:	8b 00                	mov    (%eax),%eax
  801d93:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801d96:	8b 45 14             	mov    0x14(%ebp),%eax
  801d99:	8d 40 04             	lea    0x4(%eax),%eax
  801d9c:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801d9f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  801da2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801da6:	79 91                	jns    801d39 <vprintfmt+0x35>
				width = precision, precision = -1;
  801da8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801dab:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801dae:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  801db5:	eb 82                	jmp    801d39 <vprintfmt+0x35>
  801db7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801dba:	85 c0                	test   %eax,%eax
  801dbc:	ba 00 00 00 00       	mov    $0x0,%edx
  801dc1:	0f 49 d0             	cmovns %eax,%edx
  801dc4:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801dc7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801dca:	e9 6a ff ff ff       	jmp    801d39 <vprintfmt+0x35>
  801dcf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  801dd2:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  801dd9:	e9 5b ff ff ff       	jmp    801d39 <vprintfmt+0x35>
  801dde:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  801de1:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801de4:	eb bc                	jmp    801da2 <vprintfmt+0x9e>
			lflag++;
  801de6:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801de9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  801dec:	e9 48 ff ff ff       	jmp    801d39 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  801df1:	8b 45 14             	mov    0x14(%ebp),%eax
  801df4:	8d 78 04             	lea    0x4(%eax),%edi
  801df7:	83 ec 08             	sub    $0x8,%esp
  801dfa:	53                   	push   %ebx
  801dfb:	ff 30                	pushl  (%eax)
  801dfd:	ff d6                	call   *%esi
			break;
  801dff:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  801e02:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  801e05:	e9 2f 03 00 00       	jmp    802139 <vprintfmt+0x435>
			err = va_arg(ap, int);
  801e0a:	8b 45 14             	mov    0x14(%ebp),%eax
  801e0d:	8d 78 04             	lea    0x4(%eax),%edi
  801e10:	8b 00                	mov    (%eax),%eax
  801e12:	99                   	cltd   
  801e13:	31 d0                	xor    %edx,%eax
  801e15:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  801e17:	83 f8 0f             	cmp    $0xf,%eax
  801e1a:	7f 23                	jg     801e3f <vprintfmt+0x13b>
  801e1c:	8b 14 85 60 46 80 00 	mov    0x804660(,%eax,4),%edx
  801e23:	85 d2                	test   %edx,%edx
  801e25:	74 18                	je     801e3f <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  801e27:	52                   	push   %edx
  801e28:	68 8f 3e 80 00       	push   $0x803e8f
  801e2d:	53                   	push   %ebx
  801e2e:	56                   	push   %esi
  801e2f:	e8 b3 fe ff ff       	call   801ce7 <printfmt>
  801e34:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801e37:	89 7d 14             	mov    %edi,0x14(%ebp)
  801e3a:	e9 fa 02 00 00       	jmp    802139 <vprintfmt+0x435>
				printfmt(putch, putdat, "error %d", err);
  801e3f:	50                   	push   %eax
  801e40:	68 db 43 80 00       	push   $0x8043db
  801e45:	53                   	push   %ebx
  801e46:	56                   	push   %esi
  801e47:	e8 9b fe ff ff       	call   801ce7 <printfmt>
  801e4c:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801e4f:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  801e52:	e9 e2 02 00 00       	jmp    802139 <vprintfmt+0x435>
			if ((p = va_arg(ap, char *)) == NULL)
  801e57:	8b 45 14             	mov    0x14(%ebp),%eax
  801e5a:	83 c0 04             	add    $0x4,%eax
  801e5d:	89 45 cc             	mov    %eax,-0x34(%ebp)
  801e60:	8b 45 14             	mov    0x14(%ebp),%eax
  801e63:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  801e65:	85 ff                	test   %edi,%edi
  801e67:	b8 d4 43 80 00       	mov    $0x8043d4,%eax
  801e6c:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  801e6f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801e73:	0f 8e bd 00 00 00    	jle    801f36 <vprintfmt+0x232>
  801e79:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  801e7d:	75 0e                	jne    801e8d <vprintfmt+0x189>
  801e7f:	89 75 08             	mov    %esi,0x8(%ebp)
  801e82:	8b 75 d0             	mov    -0x30(%ebp),%esi
  801e85:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  801e88:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  801e8b:	eb 6d                	jmp    801efa <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  801e8d:	83 ec 08             	sub    $0x8,%esp
  801e90:	ff 75 d0             	pushl  -0x30(%ebp)
  801e93:	57                   	push   %edi
  801e94:	e8 ec 03 00 00       	call   802285 <strnlen>
  801e99:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  801e9c:	29 c1                	sub    %eax,%ecx
  801e9e:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  801ea1:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  801ea4:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  801ea8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801eab:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  801eae:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  801eb0:	eb 0f                	jmp    801ec1 <vprintfmt+0x1bd>
					putch(padc, putdat);
  801eb2:	83 ec 08             	sub    $0x8,%esp
  801eb5:	53                   	push   %ebx
  801eb6:	ff 75 e0             	pushl  -0x20(%ebp)
  801eb9:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  801ebb:	83 ef 01             	sub    $0x1,%edi
  801ebe:	83 c4 10             	add    $0x10,%esp
  801ec1:	85 ff                	test   %edi,%edi
  801ec3:	7f ed                	jg     801eb2 <vprintfmt+0x1ae>
  801ec5:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  801ec8:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  801ecb:	85 c9                	test   %ecx,%ecx
  801ecd:	b8 00 00 00 00       	mov    $0x0,%eax
  801ed2:	0f 49 c1             	cmovns %ecx,%eax
  801ed5:	29 c1                	sub    %eax,%ecx
  801ed7:	89 75 08             	mov    %esi,0x8(%ebp)
  801eda:	8b 75 d0             	mov    -0x30(%ebp),%esi
  801edd:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  801ee0:	89 cb                	mov    %ecx,%ebx
  801ee2:	eb 16                	jmp    801efa <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  801ee4:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801ee8:	75 31                	jne    801f1b <vprintfmt+0x217>
					putch(ch, putdat);
  801eea:	83 ec 08             	sub    $0x8,%esp
  801eed:	ff 75 0c             	pushl  0xc(%ebp)
  801ef0:	50                   	push   %eax
  801ef1:	ff 55 08             	call   *0x8(%ebp)
  801ef4:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801ef7:	83 eb 01             	sub    $0x1,%ebx
  801efa:	83 c7 01             	add    $0x1,%edi
  801efd:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  801f01:	0f be c2             	movsbl %dl,%eax
  801f04:	85 c0                	test   %eax,%eax
  801f06:	74 59                	je     801f61 <vprintfmt+0x25d>
  801f08:	85 f6                	test   %esi,%esi
  801f0a:	78 d8                	js     801ee4 <vprintfmt+0x1e0>
  801f0c:	83 ee 01             	sub    $0x1,%esi
  801f0f:	79 d3                	jns    801ee4 <vprintfmt+0x1e0>
  801f11:	89 df                	mov    %ebx,%edi
  801f13:	8b 75 08             	mov    0x8(%ebp),%esi
  801f16:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801f19:	eb 37                	jmp    801f52 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  801f1b:	0f be d2             	movsbl %dl,%edx
  801f1e:	83 ea 20             	sub    $0x20,%edx
  801f21:	83 fa 5e             	cmp    $0x5e,%edx
  801f24:	76 c4                	jbe    801eea <vprintfmt+0x1e6>
					putch('?', putdat);
  801f26:	83 ec 08             	sub    $0x8,%esp
  801f29:	ff 75 0c             	pushl  0xc(%ebp)
  801f2c:	6a 3f                	push   $0x3f
  801f2e:	ff 55 08             	call   *0x8(%ebp)
  801f31:	83 c4 10             	add    $0x10,%esp
  801f34:	eb c1                	jmp    801ef7 <vprintfmt+0x1f3>
  801f36:	89 75 08             	mov    %esi,0x8(%ebp)
  801f39:	8b 75 d0             	mov    -0x30(%ebp),%esi
  801f3c:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  801f3f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  801f42:	eb b6                	jmp    801efa <vprintfmt+0x1f6>
				putch(' ', putdat);
  801f44:	83 ec 08             	sub    $0x8,%esp
  801f47:	53                   	push   %ebx
  801f48:	6a 20                	push   $0x20
  801f4a:	ff d6                	call   *%esi
			for (; width > 0; width--)
  801f4c:	83 ef 01             	sub    $0x1,%edi
  801f4f:	83 c4 10             	add    $0x10,%esp
  801f52:	85 ff                	test   %edi,%edi
  801f54:	7f ee                	jg     801f44 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  801f56:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801f59:	89 45 14             	mov    %eax,0x14(%ebp)
  801f5c:	e9 d8 01 00 00       	jmp    802139 <vprintfmt+0x435>
  801f61:	89 df                	mov    %ebx,%edi
  801f63:	8b 75 08             	mov    0x8(%ebp),%esi
  801f66:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801f69:	eb e7                	jmp    801f52 <vprintfmt+0x24e>
	if (lflag >= 2)
  801f6b:	83 f9 01             	cmp    $0x1,%ecx
  801f6e:	7e 45                	jle    801fb5 <vprintfmt+0x2b1>
		return va_arg(*ap, long long);
  801f70:	8b 45 14             	mov    0x14(%ebp),%eax
  801f73:	8b 50 04             	mov    0x4(%eax),%edx
  801f76:	8b 00                	mov    (%eax),%eax
  801f78:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801f7b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801f7e:	8b 45 14             	mov    0x14(%ebp),%eax
  801f81:	8d 40 08             	lea    0x8(%eax),%eax
  801f84:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  801f87:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801f8b:	79 62                	jns    801fef <vprintfmt+0x2eb>
				putch('-', putdat);
  801f8d:	83 ec 08             	sub    $0x8,%esp
  801f90:	53                   	push   %ebx
  801f91:	6a 2d                	push   $0x2d
  801f93:	ff d6                	call   *%esi
				num = -(long long) num;
  801f95:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801f98:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801f9b:	f7 d8                	neg    %eax
  801f9d:	83 d2 00             	adc    $0x0,%edx
  801fa0:	f7 da                	neg    %edx
  801fa2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801fa5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801fa8:	83 c4 10             	add    $0x10,%esp
			base = 10;
  801fab:	ba 0a 00 00 00       	mov    $0xa,%edx
  801fb0:	e9 66 01 00 00       	jmp    80211b <vprintfmt+0x417>
	else if (lflag)
  801fb5:	85 c9                	test   %ecx,%ecx
  801fb7:	75 1b                	jne    801fd4 <vprintfmt+0x2d0>
		return va_arg(*ap, int);
  801fb9:	8b 45 14             	mov    0x14(%ebp),%eax
  801fbc:	8b 00                	mov    (%eax),%eax
  801fbe:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801fc1:	89 c1                	mov    %eax,%ecx
  801fc3:	c1 f9 1f             	sar    $0x1f,%ecx
  801fc6:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  801fc9:	8b 45 14             	mov    0x14(%ebp),%eax
  801fcc:	8d 40 04             	lea    0x4(%eax),%eax
  801fcf:	89 45 14             	mov    %eax,0x14(%ebp)
  801fd2:	eb b3                	jmp    801f87 <vprintfmt+0x283>
		return va_arg(*ap, long);
  801fd4:	8b 45 14             	mov    0x14(%ebp),%eax
  801fd7:	8b 00                	mov    (%eax),%eax
  801fd9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801fdc:	89 c1                	mov    %eax,%ecx
  801fde:	c1 f9 1f             	sar    $0x1f,%ecx
  801fe1:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  801fe4:	8b 45 14             	mov    0x14(%ebp),%eax
  801fe7:	8d 40 04             	lea    0x4(%eax),%eax
  801fea:	89 45 14             	mov    %eax,0x14(%ebp)
  801fed:	eb 98                	jmp    801f87 <vprintfmt+0x283>
			base = 10;
  801fef:	ba 0a 00 00 00       	mov    $0xa,%edx
  801ff4:	e9 22 01 00 00       	jmp    80211b <vprintfmt+0x417>
	if (lflag >= 2)
  801ff9:	83 f9 01             	cmp    $0x1,%ecx
  801ffc:	7e 21                	jle    80201f <vprintfmt+0x31b>
		return va_arg(*ap, unsigned long long);
  801ffe:	8b 45 14             	mov    0x14(%ebp),%eax
  802001:	8b 50 04             	mov    0x4(%eax),%edx
  802004:	8b 00                	mov    (%eax),%eax
  802006:	89 45 d8             	mov    %eax,-0x28(%ebp)
  802009:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80200c:	8b 45 14             	mov    0x14(%ebp),%eax
  80200f:	8d 40 08             	lea    0x8(%eax),%eax
  802012:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  802015:	ba 0a 00 00 00       	mov    $0xa,%edx
  80201a:	e9 fc 00 00 00       	jmp    80211b <vprintfmt+0x417>
	else if (lflag)
  80201f:	85 c9                	test   %ecx,%ecx
  802021:	75 23                	jne    802046 <vprintfmt+0x342>
		return va_arg(*ap, unsigned int);
  802023:	8b 45 14             	mov    0x14(%ebp),%eax
  802026:	8b 00                	mov    (%eax),%eax
  802028:	ba 00 00 00 00       	mov    $0x0,%edx
  80202d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  802030:	89 55 dc             	mov    %edx,-0x24(%ebp)
  802033:	8b 45 14             	mov    0x14(%ebp),%eax
  802036:	8d 40 04             	lea    0x4(%eax),%eax
  802039:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80203c:	ba 0a 00 00 00       	mov    $0xa,%edx
  802041:	e9 d5 00 00 00       	jmp    80211b <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  802046:	8b 45 14             	mov    0x14(%ebp),%eax
  802049:	8b 00                	mov    (%eax),%eax
  80204b:	ba 00 00 00 00       	mov    $0x0,%edx
  802050:	89 45 d8             	mov    %eax,-0x28(%ebp)
  802053:	89 55 dc             	mov    %edx,-0x24(%ebp)
  802056:	8b 45 14             	mov    0x14(%ebp),%eax
  802059:	8d 40 04             	lea    0x4(%eax),%eax
  80205c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80205f:	ba 0a 00 00 00       	mov    $0xa,%edx
  802064:	e9 b2 00 00 00       	jmp    80211b <vprintfmt+0x417>
	if (lflag >= 2)
  802069:	83 f9 01             	cmp    $0x1,%ecx
  80206c:	7e 42                	jle    8020b0 <vprintfmt+0x3ac>
		return va_arg(*ap, unsigned long long);
  80206e:	8b 45 14             	mov    0x14(%ebp),%eax
  802071:	8b 50 04             	mov    0x4(%eax),%edx
  802074:	8b 00                	mov    (%eax),%eax
  802076:	89 45 d8             	mov    %eax,-0x28(%ebp)
  802079:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80207c:	8b 45 14             	mov    0x14(%ebp),%eax
  80207f:	8d 40 08             	lea    0x8(%eax),%eax
  802082:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  802085:	ba 08 00 00 00       	mov    $0x8,%edx
			if ((long long) num < 0) {
  80208a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80208e:	0f 89 87 00 00 00    	jns    80211b <vprintfmt+0x417>
				putch('-', putdat);
  802094:	83 ec 08             	sub    $0x8,%esp
  802097:	53                   	push   %ebx
  802098:	6a 2d                	push   $0x2d
  80209a:	ff d6                	call   *%esi
				num = -(long long) num;
  80209c:	f7 5d d8             	negl   -0x28(%ebp)
  80209f:	83 55 dc 00          	adcl   $0x0,-0x24(%ebp)
  8020a3:	f7 5d dc             	negl   -0x24(%ebp)
  8020a6:	83 c4 10             	add    $0x10,%esp
			base = 8;
  8020a9:	ba 08 00 00 00       	mov    $0x8,%edx
  8020ae:	eb 6b                	jmp    80211b <vprintfmt+0x417>
	else if (lflag)
  8020b0:	85 c9                	test   %ecx,%ecx
  8020b2:	75 1b                	jne    8020cf <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  8020b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8020b7:	8b 00                	mov    (%eax),%eax
  8020b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8020be:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8020c1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8020c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8020c7:	8d 40 04             	lea    0x4(%eax),%eax
  8020ca:	89 45 14             	mov    %eax,0x14(%ebp)
  8020cd:	eb b6                	jmp    802085 <vprintfmt+0x381>
		return va_arg(*ap, unsigned long);
  8020cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8020d2:	8b 00                	mov    (%eax),%eax
  8020d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8020d9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8020dc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8020df:	8b 45 14             	mov    0x14(%ebp),%eax
  8020e2:	8d 40 04             	lea    0x4(%eax),%eax
  8020e5:	89 45 14             	mov    %eax,0x14(%ebp)
  8020e8:	eb 9b                	jmp    802085 <vprintfmt+0x381>
			putch('0', putdat);
  8020ea:	83 ec 08             	sub    $0x8,%esp
  8020ed:	53                   	push   %ebx
  8020ee:	6a 30                	push   $0x30
  8020f0:	ff d6                	call   *%esi
			putch('x', putdat);
  8020f2:	83 c4 08             	add    $0x8,%esp
  8020f5:	53                   	push   %ebx
  8020f6:	6a 78                	push   $0x78
  8020f8:	ff d6                	call   *%esi
			num = (unsigned long long)
  8020fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8020fd:	8b 00                	mov    (%eax),%eax
  8020ff:	ba 00 00 00 00       	mov    $0x0,%edx
  802104:	89 45 d8             	mov    %eax,-0x28(%ebp)
  802107:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  80210a:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80210d:	8b 45 14             	mov    0x14(%ebp),%eax
  802110:	8d 40 04             	lea    0x4(%eax),%eax
  802113:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  802116:	ba 10 00 00 00       	mov    $0x10,%edx
			printnum(putch, putdat, num, base, width, padc);
  80211b:	83 ec 0c             	sub    $0xc,%esp
  80211e:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  802122:	50                   	push   %eax
  802123:	ff 75 e0             	pushl  -0x20(%ebp)
  802126:	52                   	push   %edx
  802127:	ff 75 dc             	pushl  -0x24(%ebp)
  80212a:	ff 75 d8             	pushl  -0x28(%ebp)
  80212d:	89 da                	mov    %ebx,%edx
  80212f:	89 f0                	mov    %esi,%eax
  802131:	e8 e5 fa ff ff       	call   801c1b <printnum>
			break;
  802136:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  802139:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80213c:	83 c7 01             	add    $0x1,%edi
  80213f:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  802143:	83 f8 25             	cmp    $0x25,%eax
  802146:	0f 84 cf fb ff ff    	je     801d1b <vprintfmt+0x17>
			if (ch == '\0')
  80214c:	85 c0                	test   %eax,%eax
  80214e:	0f 84 a9 00 00 00    	je     8021fd <vprintfmt+0x4f9>
			putch(ch, putdat);
  802154:	83 ec 08             	sub    $0x8,%esp
  802157:	53                   	push   %ebx
  802158:	50                   	push   %eax
  802159:	ff d6                	call   *%esi
  80215b:	83 c4 10             	add    $0x10,%esp
  80215e:	eb dc                	jmp    80213c <vprintfmt+0x438>
	if (lflag >= 2)
  802160:	83 f9 01             	cmp    $0x1,%ecx
  802163:	7e 1e                	jle    802183 <vprintfmt+0x47f>
		return va_arg(*ap, unsigned long long);
  802165:	8b 45 14             	mov    0x14(%ebp),%eax
  802168:	8b 50 04             	mov    0x4(%eax),%edx
  80216b:	8b 00                	mov    (%eax),%eax
  80216d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  802170:	89 55 dc             	mov    %edx,-0x24(%ebp)
  802173:	8b 45 14             	mov    0x14(%ebp),%eax
  802176:	8d 40 08             	lea    0x8(%eax),%eax
  802179:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80217c:	ba 10 00 00 00       	mov    $0x10,%edx
  802181:	eb 98                	jmp    80211b <vprintfmt+0x417>
	else if (lflag)
  802183:	85 c9                	test   %ecx,%ecx
  802185:	75 23                	jne    8021aa <vprintfmt+0x4a6>
		return va_arg(*ap, unsigned int);
  802187:	8b 45 14             	mov    0x14(%ebp),%eax
  80218a:	8b 00                	mov    (%eax),%eax
  80218c:	ba 00 00 00 00       	mov    $0x0,%edx
  802191:	89 45 d8             	mov    %eax,-0x28(%ebp)
  802194:	89 55 dc             	mov    %edx,-0x24(%ebp)
  802197:	8b 45 14             	mov    0x14(%ebp),%eax
  80219a:	8d 40 04             	lea    0x4(%eax),%eax
  80219d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8021a0:	ba 10 00 00 00       	mov    $0x10,%edx
  8021a5:	e9 71 ff ff ff       	jmp    80211b <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  8021aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8021ad:	8b 00                	mov    (%eax),%eax
  8021af:	ba 00 00 00 00       	mov    $0x0,%edx
  8021b4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8021b7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8021ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8021bd:	8d 40 04             	lea    0x4(%eax),%eax
  8021c0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8021c3:	ba 10 00 00 00       	mov    $0x10,%edx
  8021c8:	e9 4e ff ff ff       	jmp    80211b <vprintfmt+0x417>
			putch(ch, putdat);
  8021cd:	83 ec 08             	sub    $0x8,%esp
  8021d0:	53                   	push   %ebx
  8021d1:	6a 25                	push   $0x25
  8021d3:	ff d6                	call   *%esi
			break;
  8021d5:	83 c4 10             	add    $0x10,%esp
  8021d8:	e9 5c ff ff ff       	jmp    802139 <vprintfmt+0x435>
			putch('%', putdat);
  8021dd:	83 ec 08             	sub    $0x8,%esp
  8021e0:	53                   	push   %ebx
  8021e1:	6a 25                	push   $0x25
  8021e3:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8021e5:	83 c4 10             	add    $0x10,%esp
  8021e8:	89 f8                	mov    %edi,%eax
  8021ea:	eb 03                	jmp    8021ef <vprintfmt+0x4eb>
  8021ec:	83 e8 01             	sub    $0x1,%eax
  8021ef:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8021f3:	75 f7                	jne    8021ec <vprintfmt+0x4e8>
  8021f5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8021f8:	e9 3c ff ff ff       	jmp    802139 <vprintfmt+0x435>
}
  8021fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802200:	5b                   	pop    %ebx
  802201:	5e                   	pop    %esi
  802202:	5f                   	pop    %edi
  802203:	5d                   	pop    %ebp
  802204:	c3                   	ret    

00802205 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  802205:	55                   	push   %ebp
  802206:	89 e5                	mov    %esp,%ebp
  802208:	83 ec 18             	sub    $0x18,%esp
  80220b:	8b 45 08             	mov    0x8(%ebp),%eax
  80220e:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  802211:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802214:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  802218:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80221b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  802222:	85 c0                	test   %eax,%eax
  802224:	74 26                	je     80224c <vsnprintf+0x47>
  802226:	85 d2                	test   %edx,%edx
  802228:	7e 22                	jle    80224c <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80222a:	ff 75 14             	pushl  0x14(%ebp)
  80222d:	ff 75 10             	pushl  0x10(%ebp)
  802230:	8d 45 ec             	lea    -0x14(%ebp),%eax
  802233:	50                   	push   %eax
  802234:	68 ca 1c 80 00       	push   $0x801cca
  802239:	e8 c6 fa ff ff       	call   801d04 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80223e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802241:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  802244:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802247:	83 c4 10             	add    $0x10,%esp
}
  80224a:	c9                   	leave  
  80224b:	c3                   	ret    
		return -E_INVAL;
  80224c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802251:	eb f7                	jmp    80224a <vsnprintf+0x45>

00802253 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  802253:	55                   	push   %ebp
  802254:	89 e5                	mov    %esp,%ebp
  802256:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  802259:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80225c:	50                   	push   %eax
  80225d:	ff 75 10             	pushl  0x10(%ebp)
  802260:	ff 75 0c             	pushl  0xc(%ebp)
  802263:	ff 75 08             	pushl  0x8(%ebp)
  802266:	e8 9a ff ff ff       	call   802205 <vsnprintf>
	va_end(ap);

	return rc;
}
  80226b:	c9                   	leave  
  80226c:	c3                   	ret    

0080226d <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80226d:	55                   	push   %ebp
  80226e:	89 e5                	mov    %esp,%ebp
  802270:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  802273:	b8 00 00 00 00       	mov    $0x0,%eax
  802278:	eb 03                	jmp    80227d <strlen+0x10>
		n++;
  80227a:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  80227d:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  802281:	75 f7                	jne    80227a <strlen+0xd>
	return n;
}
  802283:	5d                   	pop    %ebp
  802284:	c3                   	ret    

00802285 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  802285:	55                   	push   %ebp
  802286:	89 e5                	mov    %esp,%ebp
  802288:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80228b:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80228e:	b8 00 00 00 00       	mov    $0x0,%eax
  802293:	eb 03                	jmp    802298 <strnlen+0x13>
		n++;
  802295:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802298:	39 d0                	cmp    %edx,%eax
  80229a:	74 06                	je     8022a2 <strnlen+0x1d>
  80229c:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8022a0:	75 f3                	jne    802295 <strnlen+0x10>
	return n;
}
  8022a2:	5d                   	pop    %ebp
  8022a3:	c3                   	ret    

008022a4 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8022a4:	55                   	push   %ebp
  8022a5:	89 e5                	mov    %esp,%ebp
  8022a7:	53                   	push   %ebx
  8022a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8022ae:	89 c2                	mov    %eax,%edx
  8022b0:	83 c1 01             	add    $0x1,%ecx
  8022b3:	83 c2 01             	add    $0x1,%edx
  8022b6:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8022ba:	88 5a ff             	mov    %bl,-0x1(%edx)
  8022bd:	84 db                	test   %bl,%bl
  8022bf:	75 ef                	jne    8022b0 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8022c1:	5b                   	pop    %ebx
  8022c2:	5d                   	pop    %ebp
  8022c3:	c3                   	ret    

008022c4 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8022c4:	55                   	push   %ebp
  8022c5:	89 e5                	mov    %esp,%ebp
  8022c7:	53                   	push   %ebx
  8022c8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8022cb:	53                   	push   %ebx
  8022cc:	e8 9c ff ff ff       	call   80226d <strlen>
  8022d1:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  8022d4:	ff 75 0c             	pushl  0xc(%ebp)
  8022d7:	01 d8                	add    %ebx,%eax
  8022d9:	50                   	push   %eax
  8022da:	e8 c5 ff ff ff       	call   8022a4 <strcpy>
	return dst;
}
  8022df:	89 d8                	mov    %ebx,%eax
  8022e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022e4:	c9                   	leave  
  8022e5:	c3                   	ret    

008022e6 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8022e6:	55                   	push   %ebp
  8022e7:	89 e5                	mov    %esp,%ebp
  8022e9:	56                   	push   %esi
  8022ea:	53                   	push   %ebx
  8022eb:	8b 75 08             	mov    0x8(%ebp),%esi
  8022ee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8022f1:	89 f3                	mov    %esi,%ebx
  8022f3:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8022f6:	89 f2                	mov    %esi,%edx
  8022f8:	eb 0f                	jmp    802309 <strncpy+0x23>
		*dst++ = *src;
  8022fa:	83 c2 01             	add    $0x1,%edx
  8022fd:	0f b6 01             	movzbl (%ecx),%eax
  802300:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  802303:	80 39 01             	cmpb   $0x1,(%ecx)
  802306:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  802309:	39 da                	cmp    %ebx,%edx
  80230b:	75 ed                	jne    8022fa <strncpy+0x14>
	}
	return ret;
}
  80230d:	89 f0                	mov    %esi,%eax
  80230f:	5b                   	pop    %ebx
  802310:	5e                   	pop    %esi
  802311:	5d                   	pop    %ebp
  802312:	c3                   	ret    

00802313 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  802313:	55                   	push   %ebp
  802314:	89 e5                	mov    %esp,%ebp
  802316:	56                   	push   %esi
  802317:	53                   	push   %ebx
  802318:	8b 75 08             	mov    0x8(%ebp),%esi
  80231b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80231e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802321:	89 f0                	mov    %esi,%eax
  802323:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  802327:	85 c9                	test   %ecx,%ecx
  802329:	75 0b                	jne    802336 <strlcpy+0x23>
  80232b:	eb 17                	jmp    802344 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  80232d:	83 c2 01             	add    $0x1,%edx
  802330:	83 c0 01             	add    $0x1,%eax
  802333:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  802336:	39 d8                	cmp    %ebx,%eax
  802338:	74 07                	je     802341 <strlcpy+0x2e>
  80233a:	0f b6 0a             	movzbl (%edx),%ecx
  80233d:	84 c9                	test   %cl,%cl
  80233f:	75 ec                	jne    80232d <strlcpy+0x1a>
		*dst = '\0';
  802341:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  802344:	29 f0                	sub    %esi,%eax
}
  802346:	5b                   	pop    %ebx
  802347:	5e                   	pop    %esi
  802348:	5d                   	pop    %ebp
  802349:	c3                   	ret    

0080234a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80234a:	55                   	push   %ebp
  80234b:	89 e5                	mov    %esp,%ebp
  80234d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802350:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  802353:	eb 06                	jmp    80235b <strcmp+0x11>
		p++, q++;
  802355:	83 c1 01             	add    $0x1,%ecx
  802358:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  80235b:	0f b6 01             	movzbl (%ecx),%eax
  80235e:	84 c0                	test   %al,%al
  802360:	74 04                	je     802366 <strcmp+0x1c>
  802362:	3a 02                	cmp    (%edx),%al
  802364:	74 ef                	je     802355 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  802366:	0f b6 c0             	movzbl %al,%eax
  802369:	0f b6 12             	movzbl (%edx),%edx
  80236c:	29 d0                	sub    %edx,%eax
}
  80236e:	5d                   	pop    %ebp
  80236f:	c3                   	ret    

00802370 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  802370:	55                   	push   %ebp
  802371:	89 e5                	mov    %esp,%ebp
  802373:	53                   	push   %ebx
  802374:	8b 45 08             	mov    0x8(%ebp),%eax
  802377:	8b 55 0c             	mov    0xc(%ebp),%edx
  80237a:	89 c3                	mov    %eax,%ebx
  80237c:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80237f:	eb 06                	jmp    802387 <strncmp+0x17>
		n--, p++, q++;
  802381:	83 c0 01             	add    $0x1,%eax
  802384:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  802387:	39 d8                	cmp    %ebx,%eax
  802389:	74 16                	je     8023a1 <strncmp+0x31>
  80238b:	0f b6 08             	movzbl (%eax),%ecx
  80238e:	84 c9                	test   %cl,%cl
  802390:	74 04                	je     802396 <strncmp+0x26>
  802392:	3a 0a                	cmp    (%edx),%cl
  802394:	74 eb                	je     802381 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  802396:	0f b6 00             	movzbl (%eax),%eax
  802399:	0f b6 12             	movzbl (%edx),%edx
  80239c:	29 d0                	sub    %edx,%eax
}
  80239e:	5b                   	pop    %ebx
  80239f:	5d                   	pop    %ebp
  8023a0:	c3                   	ret    
		return 0;
  8023a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8023a6:	eb f6                	jmp    80239e <strncmp+0x2e>

008023a8 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8023a8:	55                   	push   %ebp
  8023a9:	89 e5                	mov    %esp,%ebp
  8023ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ae:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8023b2:	0f b6 10             	movzbl (%eax),%edx
  8023b5:	84 d2                	test   %dl,%dl
  8023b7:	74 09                	je     8023c2 <strchr+0x1a>
		if (*s == c)
  8023b9:	38 ca                	cmp    %cl,%dl
  8023bb:	74 0a                	je     8023c7 <strchr+0x1f>
	for (; *s; s++)
  8023bd:	83 c0 01             	add    $0x1,%eax
  8023c0:	eb f0                	jmp    8023b2 <strchr+0xa>
			return (char *) s;
	return 0;
  8023c2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023c7:	5d                   	pop    %ebp
  8023c8:	c3                   	ret    

008023c9 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8023c9:	55                   	push   %ebp
  8023ca:	89 e5                	mov    %esp,%ebp
  8023cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8023cf:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8023d3:	eb 03                	jmp    8023d8 <strfind+0xf>
  8023d5:	83 c0 01             	add    $0x1,%eax
  8023d8:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8023db:	38 ca                	cmp    %cl,%dl
  8023dd:	74 04                	je     8023e3 <strfind+0x1a>
  8023df:	84 d2                	test   %dl,%dl
  8023e1:	75 f2                	jne    8023d5 <strfind+0xc>
			break;
	return (char *) s;
}
  8023e3:	5d                   	pop    %ebp
  8023e4:	c3                   	ret    

008023e5 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8023e5:	55                   	push   %ebp
  8023e6:	89 e5                	mov    %esp,%ebp
  8023e8:	57                   	push   %edi
  8023e9:	56                   	push   %esi
  8023ea:	53                   	push   %ebx
  8023eb:	8b 7d 08             	mov    0x8(%ebp),%edi
  8023ee:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8023f1:	85 c9                	test   %ecx,%ecx
  8023f3:	74 13                	je     802408 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8023f5:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8023fb:	75 05                	jne    802402 <memset+0x1d>
  8023fd:	f6 c1 03             	test   $0x3,%cl
  802400:	74 0d                	je     80240f <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  802402:	8b 45 0c             	mov    0xc(%ebp),%eax
  802405:	fc                   	cld    
  802406:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  802408:	89 f8                	mov    %edi,%eax
  80240a:	5b                   	pop    %ebx
  80240b:	5e                   	pop    %esi
  80240c:	5f                   	pop    %edi
  80240d:	5d                   	pop    %ebp
  80240e:	c3                   	ret    
		c &= 0xFF;
  80240f:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  802413:	89 d3                	mov    %edx,%ebx
  802415:	c1 e3 08             	shl    $0x8,%ebx
  802418:	89 d0                	mov    %edx,%eax
  80241a:	c1 e0 18             	shl    $0x18,%eax
  80241d:	89 d6                	mov    %edx,%esi
  80241f:	c1 e6 10             	shl    $0x10,%esi
  802422:	09 f0                	or     %esi,%eax
  802424:	09 c2                	or     %eax,%edx
  802426:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  802428:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  80242b:	89 d0                	mov    %edx,%eax
  80242d:	fc                   	cld    
  80242e:	f3 ab                	rep stos %eax,%es:(%edi)
  802430:	eb d6                	jmp    802408 <memset+0x23>

00802432 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  802432:	55                   	push   %ebp
  802433:	89 e5                	mov    %esp,%ebp
  802435:	57                   	push   %edi
  802436:	56                   	push   %esi
  802437:	8b 45 08             	mov    0x8(%ebp),%eax
  80243a:	8b 75 0c             	mov    0xc(%ebp),%esi
  80243d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  802440:	39 c6                	cmp    %eax,%esi
  802442:	73 35                	jae    802479 <memmove+0x47>
  802444:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  802447:	39 c2                	cmp    %eax,%edx
  802449:	76 2e                	jbe    802479 <memmove+0x47>
		s += n;
		d += n;
  80244b:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80244e:	89 d6                	mov    %edx,%esi
  802450:	09 fe                	or     %edi,%esi
  802452:	f7 c6 03 00 00 00    	test   $0x3,%esi
  802458:	74 0c                	je     802466 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80245a:	83 ef 01             	sub    $0x1,%edi
  80245d:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  802460:	fd                   	std    
  802461:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  802463:	fc                   	cld    
  802464:	eb 21                	jmp    802487 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  802466:	f6 c1 03             	test   $0x3,%cl
  802469:	75 ef                	jne    80245a <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80246b:	83 ef 04             	sub    $0x4,%edi
  80246e:	8d 72 fc             	lea    -0x4(%edx),%esi
  802471:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  802474:	fd                   	std    
  802475:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  802477:	eb ea                	jmp    802463 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  802479:	89 f2                	mov    %esi,%edx
  80247b:	09 c2                	or     %eax,%edx
  80247d:	f6 c2 03             	test   $0x3,%dl
  802480:	74 09                	je     80248b <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  802482:	89 c7                	mov    %eax,%edi
  802484:	fc                   	cld    
  802485:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  802487:	5e                   	pop    %esi
  802488:	5f                   	pop    %edi
  802489:	5d                   	pop    %ebp
  80248a:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80248b:	f6 c1 03             	test   $0x3,%cl
  80248e:	75 f2                	jne    802482 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  802490:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  802493:	89 c7                	mov    %eax,%edi
  802495:	fc                   	cld    
  802496:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  802498:	eb ed                	jmp    802487 <memmove+0x55>

0080249a <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80249a:	55                   	push   %ebp
  80249b:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  80249d:	ff 75 10             	pushl  0x10(%ebp)
  8024a0:	ff 75 0c             	pushl  0xc(%ebp)
  8024a3:	ff 75 08             	pushl  0x8(%ebp)
  8024a6:	e8 87 ff ff ff       	call   802432 <memmove>
}
  8024ab:	c9                   	leave  
  8024ac:	c3                   	ret    

008024ad <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8024ad:	55                   	push   %ebp
  8024ae:	89 e5                	mov    %esp,%ebp
  8024b0:	56                   	push   %esi
  8024b1:	53                   	push   %ebx
  8024b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024b8:	89 c6                	mov    %eax,%esi
  8024ba:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8024bd:	39 f0                	cmp    %esi,%eax
  8024bf:	74 1c                	je     8024dd <memcmp+0x30>
		if (*s1 != *s2)
  8024c1:	0f b6 08             	movzbl (%eax),%ecx
  8024c4:	0f b6 1a             	movzbl (%edx),%ebx
  8024c7:	38 d9                	cmp    %bl,%cl
  8024c9:	75 08                	jne    8024d3 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8024cb:	83 c0 01             	add    $0x1,%eax
  8024ce:	83 c2 01             	add    $0x1,%edx
  8024d1:	eb ea                	jmp    8024bd <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  8024d3:	0f b6 c1             	movzbl %cl,%eax
  8024d6:	0f b6 db             	movzbl %bl,%ebx
  8024d9:	29 d8                	sub    %ebx,%eax
  8024db:	eb 05                	jmp    8024e2 <memcmp+0x35>
	}

	return 0;
  8024dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024e2:	5b                   	pop    %ebx
  8024e3:	5e                   	pop    %esi
  8024e4:	5d                   	pop    %ebp
  8024e5:	c3                   	ret    

008024e6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8024e6:	55                   	push   %ebp
  8024e7:	89 e5                	mov    %esp,%ebp
  8024e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8024ef:	89 c2                	mov    %eax,%edx
  8024f1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8024f4:	39 d0                	cmp    %edx,%eax
  8024f6:	73 09                	jae    802501 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  8024f8:	38 08                	cmp    %cl,(%eax)
  8024fa:	74 05                	je     802501 <memfind+0x1b>
	for (; s < ends; s++)
  8024fc:	83 c0 01             	add    $0x1,%eax
  8024ff:	eb f3                	jmp    8024f4 <memfind+0xe>
			break;
	return (void *) s;
}
  802501:	5d                   	pop    %ebp
  802502:	c3                   	ret    

00802503 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  802503:	55                   	push   %ebp
  802504:	89 e5                	mov    %esp,%ebp
  802506:	57                   	push   %edi
  802507:	56                   	push   %esi
  802508:	53                   	push   %ebx
  802509:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80250c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80250f:	eb 03                	jmp    802514 <strtol+0x11>
		s++;
  802511:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  802514:	0f b6 01             	movzbl (%ecx),%eax
  802517:	3c 20                	cmp    $0x20,%al
  802519:	74 f6                	je     802511 <strtol+0xe>
  80251b:	3c 09                	cmp    $0x9,%al
  80251d:	74 f2                	je     802511 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  80251f:	3c 2b                	cmp    $0x2b,%al
  802521:	74 2e                	je     802551 <strtol+0x4e>
	int neg = 0;
  802523:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  802528:	3c 2d                	cmp    $0x2d,%al
  80252a:	74 2f                	je     80255b <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80252c:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  802532:	75 05                	jne    802539 <strtol+0x36>
  802534:	80 39 30             	cmpb   $0x30,(%ecx)
  802537:	74 2c                	je     802565 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  802539:	85 db                	test   %ebx,%ebx
  80253b:	75 0a                	jne    802547 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  80253d:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  802542:	80 39 30             	cmpb   $0x30,(%ecx)
  802545:	74 28                	je     80256f <strtol+0x6c>
		base = 10;
  802547:	b8 00 00 00 00       	mov    $0x0,%eax
  80254c:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80254f:	eb 50                	jmp    8025a1 <strtol+0x9e>
		s++;
  802551:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  802554:	bf 00 00 00 00       	mov    $0x0,%edi
  802559:	eb d1                	jmp    80252c <strtol+0x29>
		s++, neg = 1;
  80255b:	83 c1 01             	add    $0x1,%ecx
  80255e:	bf 01 00 00 00       	mov    $0x1,%edi
  802563:	eb c7                	jmp    80252c <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  802565:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  802569:	74 0e                	je     802579 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  80256b:	85 db                	test   %ebx,%ebx
  80256d:	75 d8                	jne    802547 <strtol+0x44>
		s++, base = 8;
  80256f:	83 c1 01             	add    $0x1,%ecx
  802572:	bb 08 00 00 00       	mov    $0x8,%ebx
  802577:	eb ce                	jmp    802547 <strtol+0x44>
		s += 2, base = 16;
  802579:	83 c1 02             	add    $0x2,%ecx
  80257c:	bb 10 00 00 00       	mov    $0x10,%ebx
  802581:	eb c4                	jmp    802547 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  802583:	8d 72 9f             	lea    -0x61(%edx),%esi
  802586:	89 f3                	mov    %esi,%ebx
  802588:	80 fb 19             	cmp    $0x19,%bl
  80258b:	77 29                	ja     8025b6 <strtol+0xb3>
			dig = *s - 'a' + 10;
  80258d:	0f be d2             	movsbl %dl,%edx
  802590:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  802593:	3b 55 10             	cmp    0x10(%ebp),%edx
  802596:	7d 30                	jge    8025c8 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  802598:	83 c1 01             	add    $0x1,%ecx
  80259b:	0f af 45 10          	imul   0x10(%ebp),%eax
  80259f:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  8025a1:	0f b6 11             	movzbl (%ecx),%edx
  8025a4:	8d 72 d0             	lea    -0x30(%edx),%esi
  8025a7:	89 f3                	mov    %esi,%ebx
  8025a9:	80 fb 09             	cmp    $0x9,%bl
  8025ac:	77 d5                	ja     802583 <strtol+0x80>
			dig = *s - '0';
  8025ae:	0f be d2             	movsbl %dl,%edx
  8025b1:	83 ea 30             	sub    $0x30,%edx
  8025b4:	eb dd                	jmp    802593 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  8025b6:	8d 72 bf             	lea    -0x41(%edx),%esi
  8025b9:	89 f3                	mov    %esi,%ebx
  8025bb:	80 fb 19             	cmp    $0x19,%bl
  8025be:	77 08                	ja     8025c8 <strtol+0xc5>
			dig = *s - 'A' + 10;
  8025c0:	0f be d2             	movsbl %dl,%edx
  8025c3:	83 ea 37             	sub    $0x37,%edx
  8025c6:	eb cb                	jmp    802593 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  8025c8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8025cc:	74 05                	je     8025d3 <strtol+0xd0>
		*endptr = (char *) s;
  8025ce:	8b 75 0c             	mov    0xc(%ebp),%esi
  8025d1:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  8025d3:	89 c2                	mov    %eax,%edx
  8025d5:	f7 da                	neg    %edx
  8025d7:	85 ff                	test   %edi,%edi
  8025d9:	0f 45 c2             	cmovne %edx,%eax
}
  8025dc:	5b                   	pop    %ebx
  8025dd:	5e                   	pop    %esi
  8025de:	5f                   	pop    %edi
  8025df:	5d                   	pop    %ebp
  8025e0:	c3                   	ret    

008025e1 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8025e1:	55                   	push   %ebp
  8025e2:	89 e5                	mov    %esp,%ebp
  8025e4:	57                   	push   %edi
  8025e5:	56                   	push   %esi
  8025e6:	53                   	push   %ebx
	asm volatile("int %1\n"
  8025e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8025ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8025ef:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8025f2:	89 c3                	mov    %eax,%ebx
  8025f4:	89 c7                	mov    %eax,%edi
  8025f6:	89 c6                	mov    %eax,%esi
  8025f8:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8025fa:	5b                   	pop    %ebx
  8025fb:	5e                   	pop    %esi
  8025fc:	5f                   	pop    %edi
  8025fd:	5d                   	pop    %ebp
  8025fe:	c3                   	ret    

008025ff <sys_cgetc>:

int
sys_cgetc(void)
{
  8025ff:	55                   	push   %ebp
  802600:	89 e5                	mov    %esp,%ebp
  802602:	57                   	push   %edi
  802603:	56                   	push   %esi
  802604:	53                   	push   %ebx
	asm volatile("int %1\n"
  802605:	ba 00 00 00 00       	mov    $0x0,%edx
  80260a:	b8 01 00 00 00       	mov    $0x1,%eax
  80260f:	89 d1                	mov    %edx,%ecx
  802611:	89 d3                	mov    %edx,%ebx
  802613:	89 d7                	mov    %edx,%edi
  802615:	89 d6                	mov    %edx,%esi
  802617:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  802619:	5b                   	pop    %ebx
  80261a:	5e                   	pop    %esi
  80261b:	5f                   	pop    %edi
  80261c:	5d                   	pop    %ebp
  80261d:	c3                   	ret    

0080261e <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80261e:	55                   	push   %ebp
  80261f:	89 e5                	mov    %esp,%ebp
  802621:	57                   	push   %edi
  802622:	56                   	push   %esi
  802623:	53                   	push   %ebx
  802624:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  802627:	b9 00 00 00 00       	mov    $0x0,%ecx
  80262c:	8b 55 08             	mov    0x8(%ebp),%edx
  80262f:	b8 03 00 00 00       	mov    $0x3,%eax
  802634:	89 cb                	mov    %ecx,%ebx
  802636:	89 cf                	mov    %ecx,%edi
  802638:	89 ce                	mov    %ecx,%esi
  80263a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80263c:	85 c0                	test   %eax,%eax
  80263e:	7f 08                	jg     802648 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  802640:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802643:	5b                   	pop    %ebx
  802644:	5e                   	pop    %esi
  802645:	5f                   	pop    %edi
  802646:	5d                   	pop    %ebp
  802647:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  802648:	83 ec 0c             	sub    $0xc,%esp
  80264b:	50                   	push   %eax
  80264c:	6a 03                	push   $0x3
  80264e:	68 bf 46 80 00       	push   $0x8046bf
  802653:	6a 23                	push   $0x23
  802655:	68 dc 46 80 00       	push   $0x8046dc
  80265a:	e8 cd f4 ff ff       	call   801b2c <_panic>

0080265f <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80265f:	55                   	push   %ebp
  802660:	89 e5                	mov    %esp,%ebp
  802662:	57                   	push   %edi
  802663:	56                   	push   %esi
  802664:	53                   	push   %ebx
	asm volatile("int %1\n"
  802665:	ba 00 00 00 00       	mov    $0x0,%edx
  80266a:	b8 02 00 00 00       	mov    $0x2,%eax
  80266f:	89 d1                	mov    %edx,%ecx
  802671:	89 d3                	mov    %edx,%ebx
  802673:	89 d7                	mov    %edx,%edi
  802675:	89 d6                	mov    %edx,%esi
  802677:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  802679:	5b                   	pop    %ebx
  80267a:	5e                   	pop    %esi
  80267b:	5f                   	pop    %edi
  80267c:	5d                   	pop    %ebp
  80267d:	c3                   	ret    

0080267e <sys_yield>:

void
sys_yield(void)
{
  80267e:	55                   	push   %ebp
  80267f:	89 e5                	mov    %esp,%ebp
  802681:	57                   	push   %edi
  802682:	56                   	push   %esi
  802683:	53                   	push   %ebx
	asm volatile("int %1\n"
  802684:	ba 00 00 00 00       	mov    $0x0,%edx
  802689:	b8 0b 00 00 00       	mov    $0xb,%eax
  80268e:	89 d1                	mov    %edx,%ecx
  802690:	89 d3                	mov    %edx,%ebx
  802692:	89 d7                	mov    %edx,%edi
  802694:	89 d6                	mov    %edx,%esi
  802696:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  802698:	5b                   	pop    %ebx
  802699:	5e                   	pop    %esi
  80269a:	5f                   	pop    %edi
  80269b:	5d                   	pop    %ebp
  80269c:	c3                   	ret    

0080269d <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80269d:	55                   	push   %ebp
  80269e:	89 e5                	mov    %esp,%ebp
  8026a0:	57                   	push   %edi
  8026a1:	56                   	push   %esi
  8026a2:	53                   	push   %ebx
  8026a3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8026a6:	be 00 00 00 00       	mov    $0x0,%esi
  8026ab:	8b 55 08             	mov    0x8(%ebp),%edx
  8026ae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8026b1:	b8 04 00 00 00       	mov    $0x4,%eax
  8026b6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8026b9:	89 f7                	mov    %esi,%edi
  8026bb:	cd 30                	int    $0x30
	if(check && ret > 0)
  8026bd:	85 c0                	test   %eax,%eax
  8026bf:	7f 08                	jg     8026c9 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8026c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8026c4:	5b                   	pop    %ebx
  8026c5:	5e                   	pop    %esi
  8026c6:	5f                   	pop    %edi
  8026c7:	5d                   	pop    %ebp
  8026c8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8026c9:	83 ec 0c             	sub    $0xc,%esp
  8026cc:	50                   	push   %eax
  8026cd:	6a 04                	push   $0x4
  8026cf:	68 bf 46 80 00       	push   $0x8046bf
  8026d4:	6a 23                	push   $0x23
  8026d6:	68 dc 46 80 00       	push   $0x8046dc
  8026db:	e8 4c f4 ff ff       	call   801b2c <_panic>

008026e0 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8026e0:	55                   	push   %ebp
  8026e1:	89 e5                	mov    %esp,%ebp
  8026e3:	57                   	push   %edi
  8026e4:	56                   	push   %esi
  8026e5:	53                   	push   %ebx
  8026e6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8026e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8026ec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8026ef:	b8 05 00 00 00       	mov    $0x5,%eax
  8026f4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8026f7:	8b 7d 14             	mov    0x14(%ebp),%edi
  8026fa:	8b 75 18             	mov    0x18(%ebp),%esi
  8026fd:	cd 30                	int    $0x30
	if(check && ret > 0)
  8026ff:	85 c0                	test   %eax,%eax
  802701:	7f 08                	jg     80270b <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  802703:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802706:	5b                   	pop    %ebx
  802707:	5e                   	pop    %esi
  802708:	5f                   	pop    %edi
  802709:	5d                   	pop    %ebp
  80270a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80270b:	83 ec 0c             	sub    $0xc,%esp
  80270e:	50                   	push   %eax
  80270f:	6a 05                	push   $0x5
  802711:	68 bf 46 80 00       	push   $0x8046bf
  802716:	6a 23                	push   $0x23
  802718:	68 dc 46 80 00       	push   $0x8046dc
  80271d:	e8 0a f4 ff ff       	call   801b2c <_panic>

00802722 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  802722:	55                   	push   %ebp
  802723:	89 e5                	mov    %esp,%ebp
  802725:	57                   	push   %edi
  802726:	56                   	push   %esi
  802727:	53                   	push   %ebx
  802728:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80272b:	bb 00 00 00 00       	mov    $0x0,%ebx
  802730:	8b 55 08             	mov    0x8(%ebp),%edx
  802733:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802736:	b8 06 00 00 00       	mov    $0x6,%eax
  80273b:	89 df                	mov    %ebx,%edi
  80273d:	89 de                	mov    %ebx,%esi
  80273f:	cd 30                	int    $0x30
	if(check && ret > 0)
  802741:	85 c0                	test   %eax,%eax
  802743:	7f 08                	jg     80274d <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  802745:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802748:	5b                   	pop    %ebx
  802749:	5e                   	pop    %esi
  80274a:	5f                   	pop    %edi
  80274b:	5d                   	pop    %ebp
  80274c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80274d:	83 ec 0c             	sub    $0xc,%esp
  802750:	50                   	push   %eax
  802751:	6a 06                	push   $0x6
  802753:	68 bf 46 80 00       	push   $0x8046bf
  802758:	6a 23                	push   $0x23
  80275a:	68 dc 46 80 00       	push   $0x8046dc
  80275f:	e8 c8 f3 ff ff       	call   801b2c <_panic>

00802764 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  802764:	55                   	push   %ebp
  802765:	89 e5                	mov    %esp,%ebp
  802767:	57                   	push   %edi
  802768:	56                   	push   %esi
  802769:	53                   	push   %ebx
  80276a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80276d:	bb 00 00 00 00       	mov    $0x0,%ebx
  802772:	8b 55 08             	mov    0x8(%ebp),%edx
  802775:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802778:	b8 08 00 00 00       	mov    $0x8,%eax
  80277d:	89 df                	mov    %ebx,%edi
  80277f:	89 de                	mov    %ebx,%esi
  802781:	cd 30                	int    $0x30
	if(check && ret > 0)
  802783:	85 c0                	test   %eax,%eax
  802785:	7f 08                	jg     80278f <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  802787:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80278a:	5b                   	pop    %ebx
  80278b:	5e                   	pop    %esi
  80278c:	5f                   	pop    %edi
  80278d:	5d                   	pop    %ebp
  80278e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80278f:	83 ec 0c             	sub    $0xc,%esp
  802792:	50                   	push   %eax
  802793:	6a 08                	push   $0x8
  802795:	68 bf 46 80 00       	push   $0x8046bf
  80279a:	6a 23                	push   $0x23
  80279c:	68 dc 46 80 00       	push   $0x8046dc
  8027a1:	e8 86 f3 ff ff       	call   801b2c <_panic>

008027a6 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8027a6:	55                   	push   %ebp
  8027a7:	89 e5                	mov    %esp,%ebp
  8027a9:	57                   	push   %edi
  8027aa:	56                   	push   %esi
  8027ab:	53                   	push   %ebx
  8027ac:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8027af:	bb 00 00 00 00       	mov    $0x0,%ebx
  8027b4:	8b 55 08             	mov    0x8(%ebp),%edx
  8027b7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8027ba:	b8 09 00 00 00       	mov    $0x9,%eax
  8027bf:	89 df                	mov    %ebx,%edi
  8027c1:	89 de                	mov    %ebx,%esi
  8027c3:	cd 30                	int    $0x30
	if(check && ret > 0)
  8027c5:	85 c0                	test   %eax,%eax
  8027c7:	7f 08                	jg     8027d1 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8027c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8027cc:	5b                   	pop    %ebx
  8027cd:	5e                   	pop    %esi
  8027ce:	5f                   	pop    %edi
  8027cf:	5d                   	pop    %ebp
  8027d0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8027d1:	83 ec 0c             	sub    $0xc,%esp
  8027d4:	50                   	push   %eax
  8027d5:	6a 09                	push   $0x9
  8027d7:	68 bf 46 80 00       	push   $0x8046bf
  8027dc:	6a 23                	push   $0x23
  8027de:	68 dc 46 80 00       	push   $0x8046dc
  8027e3:	e8 44 f3 ff ff       	call   801b2c <_panic>

008027e8 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8027e8:	55                   	push   %ebp
  8027e9:	89 e5                	mov    %esp,%ebp
  8027eb:	57                   	push   %edi
  8027ec:	56                   	push   %esi
  8027ed:	53                   	push   %ebx
  8027ee:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8027f1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8027f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8027f9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8027fc:	b8 0a 00 00 00       	mov    $0xa,%eax
  802801:	89 df                	mov    %ebx,%edi
  802803:	89 de                	mov    %ebx,%esi
  802805:	cd 30                	int    $0x30
	if(check && ret > 0)
  802807:	85 c0                	test   %eax,%eax
  802809:	7f 08                	jg     802813 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80280b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80280e:	5b                   	pop    %ebx
  80280f:	5e                   	pop    %esi
  802810:	5f                   	pop    %edi
  802811:	5d                   	pop    %ebp
  802812:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  802813:	83 ec 0c             	sub    $0xc,%esp
  802816:	50                   	push   %eax
  802817:	6a 0a                	push   $0xa
  802819:	68 bf 46 80 00       	push   $0x8046bf
  80281e:	6a 23                	push   $0x23
  802820:	68 dc 46 80 00       	push   $0x8046dc
  802825:	e8 02 f3 ff ff       	call   801b2c <_panic>

0080282a <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80282a:	55                   	push   %ebp
  80282b:	89 e5                	mov    %esp,%ebp
  80282d:	57                   	push   %edi
  80282e:	56                   	push   %esi
  80282f:	53                   	push   %ebx
	asm volatile("int %1\n"
  802830:	8b 55 08             	mov    0x8(%ebp),%edx
  802833:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802836:	b8 0c 00 00 00       	mov    $0xc,%eax
  80283b:	be 00 00 00 00       	mov    $0x0,%esi
  802840:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802843:	8b 7d 14             	mov    0x14(%ebp),%edi
  802846:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  802848:	5b                   	pop    %ebx
  802849:	5e                   	pop    %esi
  80284a:	5f                   	pop    %edi
  80284b:	5d                   	pop    %ebp
  80284c:	c3                   	ret    

0080284d <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80284d:	55                   	push   %ebp
  80284e:	89 e5                	mov    %esp,%ebp
  802850:	57                   	push   %edi
  802851:	56                   	push   %esi
  802852:	53                   	push   %ebx
  802853:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  802856:	b9 00 00 00 00       	mov    $0x0,%ecx
  80285b:	8b 55 08             	mov    0x8(%ebp),%edx
  80285e:	b8 0d 00 00 00       	mov    $0xd,%eax
  802863:	89 cb                	mov    %ecx,%ebx
  802865:	89 cf                	mov    %ecx,%edi
  802867:	89 ce                	mov    %ecx,%esi
  802869:	cd 30                	int    $0x30
	if(check && ret > 0)
  80286b:	85 c0                	test   %eax,%eax
  80286d:	7f 08                	jg     802877 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80286f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802872:	5b                   	pop    %ebx
  802873:	5e                   	pop    %esi
  802874:	5f                   	pop    %edi
  802875:	5d                   	pop    %ebp
  802876:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  802877:	83 ec 0c             	sub    $0xc,%esp
  80287a:	50                   	push   %eax
  80287b:	6a 0d                	push   $0xd
  80287d:	68 bf 46 80 00       	push   $0x8046bf
  802882:	6a 23                	push   $0x23
  802884:	68 dc 46 80 00       	push   $0x8046dc
  802889:	e8 9e f2 ff ff       	call   801b2c <_panic>

0080288e <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80288e:	55                   	push   %ebp
  80288f:	89 e5                	mov    %esp,%ebp
  802891:	57                   	push   %edi
  802892:	56                   	push   %esi
  802893:	53                   	push   %ebx
	asm volatile("int %1\n"
  802894:	ba 00 00 00 00       	mov    $0x0,%edx
  802899:	b8 0e 00 00 00       	mov    $0xe,%eax
  80289e:	89 d1                	mov    %edx,%ecx
  8028a0:	89 d3                	mov    %edx,%ebx
  8028a2:	89 d7                	mov    %edx,%edi
  8028a4:	89 d6                	mov    %edx,%esi
  8028a6:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8028a8:	5b                   	pop    %ebx
  8028a9:	5e                   	pop    %esi
  8028aa:	5f                   	pop    %edi
  8028ab:	5d                   	pop    %ebp
  8028ac:	c3                   	ret    

008028ad <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8028ad:	55                   	push   %ebp
  8028ae:	89 e5                	mov    %esp,%ebp
  8028b0:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8028b3:	83 3d 14 a0 80 00 00 	cmpl   $0x0,0x80a014
  8028ba:	74 0a                	je     8028c6 <set_pgfault_handler+0x19>
		    panic("set_pgfault_handler: %e", r);
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8028bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8028bf:	a3 14 a0 80 00       	mov    %eax,0x80a014
}
  8028c4:	c9                   	leave  
  8028c5:	c3                   	ret    
		if ((r = sys_page_alloc(thisenv->env_id, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P)) != 0) {
  8028c6:	a1 10 a0 80 00       	mov    0x80a010,%eax
  8028cb:	8b 40 48             	mov    0x48(%eax),%eax
  8028ce:	83 ec 04             	sub    $0x4,%esp
  8028d1:	6a 07                	push   $0x7
  8028d3:	68 00 f0 bf ee       	push   $0xeebff000
  8028d8:	50                   	push   %eax
  8028d9:	e8 bf fd ff ff       	call   80269d <sys_page_alloc>
  8028de:	83 c4 10             	add    $0x10,%esp
  8028e1:	85 c0                	test   %eax,%eax
  8028e3:	75 2f                	jne    802914 <set_pgfault_handler+0x67>
		if ((r = sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall)) != 0) {
  8028e5:	a1 10 a0 80 00       	mov    0x80a010,%eax
  8028ea:	8b 40 48             	mov    0x48(%eax),%eax
  8028ed:	83 ec 08             	sub    $0x8,%esp
  8028f0:	68 26 29 80 00       	push   $0x802926
  8028f5:	50                   	push   %eax
  8028f6:	e8 ed fe ff ff       	call   8027e8 <sys_env_set_pgfault_upcall>
  8028fb:	83 c4 10             	add    $0x10,%esp
  8028fe:	85 c0                	test   %eax,%eax
  802900:	74 ba                	je     8028bc <set_pgfault_handler+0xf>
		    panic("set_pgfault_handler: %e", r);
  802902:	50                   	push   %eax
  802903:	68 ea 46 80 00       	push   $0x8046ea
  802908:	6a 24                	push   $0x24
  80290a:	68 02 47 80 00       	push   $0x804702
  80290f:	e8 18 f2 ff ff       	call   801b2c <_panic>
		    panic("set_pgfault_handler: %e", r);
  802914:	50                   	push   %eax
  802915:	68 ea 46 80 00       	push   $0x8046ea
  80291a:	6a 21                	push   $0x21
  80291c:	68 02 47 80 00       	push   $0x804702
  802921:	e8 06 f2 ff ff       	call   801b2c <_panic>

00802926 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802926:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802927:	a1 14 a0 80 00       	mov    0x80a014,%eax
	call *%eax
  80292c:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80292e:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x30(%esp), %ecx    // save trap-time esp in ecx
  802931:	8b 4c 24 30          	mov    0x30(%esp),%ecx
	subl $4, %ecx            // enlarge the previous stack for 4 bytes
  802935:	83 e9 04             	sub    $0x4,%ecx
	movl %ecx, 0x30(%esp)    // write the modified esp back
  802938:	89 4c 24 30          	mov    %ecx,0x30(%esp)
	movl 0x28(%esp), %edx    // save trap-time eip in edx
  80293c:	8b 54 24 28          	mov    0x28(%esp),%edx
	movl %edx, (%ecx)        // save eip at new esp for return
  802940:	89 11                	mov    %edx,(%ecx)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp            // skip fault_va and tf_err
  802942:	83 c4 08             	add    $0x8,%esp
	popal                    // pop PushRegs
  802945:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4, %esp            // skip eip
  802946:	83 c4 04             	add    $0x4,%esp
	popfl                    // pop eflags
  802949:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	pop %esp
  80294a:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  80294b:	c3                   	ret    

0080294c <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80294c:	55                   	push   %ebp
  80294d:	89 e5                	mov    %esp,%ebp
  80294f:	56                   	push   %esi
  802950:	53                   	push   %ebx
  802951:	8b 75 08             	mov    0x8(%ebp),%esi
  802954:	8b 45 0c             	mov    0xc(%ebp),%eax
  802957:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
  80295a:	85 c0                	test   %eax,%eax
	    pg = (void *)UTOP;
  80295c:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802961:	0f 44 c2             	cmove  %edx,%eax
	}
	if ((r = sys_ipc_recv(pg)) < 0) {
  802964:	83 ec 0c             	sub    $0xc,%esp
  802967:	50                   	push   %eax
  802968:	e8 e0 fe ff ff       	call   80284d <sys_ipc_recv>
  80296d:	83 c4 10             	add    $0x10,%esp
  802970:	85 c0                	test   %eax,%eax
  802972:	78 2b                	js     80299f <ipc_recv+0x53>
	    if (perm_store != NULL) {
	        *perm_store = 0;
	    }
	    return r;
	}
	if (from_env_store != NULL) {
  802974:	85 f6                	test   %esi,%esi
  802976:	74 0a                	je     802982 <ipc_recv+0x36>
	    *from_env_store = thisenv->env_ipc_from;
  802978:	a1 10 a0 80 00       	mov    0x80a010,%eax
  80297d:	8b 40 74             	mov    0x74(%eax),%eax
  802980:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store != NULL) {
  802982:	85 db                	test   %ebx,%ebx
  802984:	74 0a                	je     802990 <ipc_recv+0x44>
	    *perm_store = thisenv->env_ipc_perm;
  802986:	a1 10 a0 80 00       	mov    0x80a010,%eax
  80298b:	8b 40 78             	mov    0x78(%eax),%eax
  80298e:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  802990:	a1 10 a0 80 00       	mov    0x80a010,%eax
  802995:	8b 40 70             	mov    0x70(%eax),%eax
}
  802998:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80299b:	5b                   	pop    %ebx
  80299c:	5e                   	pop    %esi
  80299d:	5d                   	pop    %ebp
  80299e:	c3                   	ret    
	    if (from_env_store != NULL) {
  80299f:	85 f6                	test   %esi,%esi
  8029a1:	74 06                	je     8029a9 <ipc_recv+0x5d>
	        *from_env_store = 0;
  8029a3:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	    if (perm_store != NULL) {
  8029a9:	85 db                	test   %ebx,%ebx
  8029ab:	74 eb                	je     802998 <ipc_recv+0x4c>
	        *perm_store = 0;
  8029ad:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8029b3:	eb e3                	jmp    802998 <ipc_recv+0x4c>

008029b5 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8029b5:	55                   	push   %ebp
  8029b6:	89 e5                	mov    %esp,%ebp
  8029b8:	57                   	push   %edi
  8029b9:	56                   	push   %esi
  8029ba:	53                   	push   %ebx
  8029bb:	83 ec 0c             	sub    $0xc,%esp
  8029be:	8b 7d 08             	mov    0x8(%ebp),%edi
  8029c1:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
	    pg = (void *)UTOP;
  8029c4:	85 f6                	test   %esi,%esi
  8029c6:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8029cb:	0f 44 f0             	cmove  %eax,%esi
  8029ce:	eb 09                	jmp    8029d9 <ipc_send+0x24>
	do {
	    r = sys_ipc_try_send(to_env, val, pg, perm);
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
	        panic("ipc_send: %e", r);
	    }
	    sys_yield();
  8029d0:	e8 a9 fc ff ff       	call   80267e <sys_yield>
	} while(r != 0);
  8029d5:	85 db                	test   %ebx,%ebx
  8029d7:	74 2d                	je     802a06 <ipc_send+0x51>
	    r = sys_ipc_try_send(to_env, val, pg, perm);
  8029d9:	ff 75 14             	pushl  0x14(%ebp)
  8029dc:	56                   	push   %esi
  8029dd:	ff 75 0c             	pushl  0xc(%ebp)
  8029e0:	57                   	push   %edi
  8029e1:	e8 44 fe ff ff       	call   80282a <sys_ipc_try_send>
  8029e6:	89 c3                	mov    %eax,%ebx
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
  8029e8:	83 c4 10             	add    $0x10,%esp
  8029eb:	85 c0                	test   %eax,%eax
  8029ed:	79 e1                	jns    8029d0 <ipc_send+0x1b>
  8029ef:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8029f2:	74 dc                	je     8029d0 <ipc_send+0x1b>
	        panic("ipc_send: %e", r);
  8029f4:	50                   	push   %eax
  8029f5:	68 10 47 80 00       	push   $0x804710
  8029fa:	6a 45                	push   $0x45
  8029fc:	68 1d 47 80 00       	push   $0x80471d
  802a01:	e8 26 f1 ff ff       	call   801b2c <_panic>
}
  802a06:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802a09:	5b                   	pop    %ebx
  802a0a:	5e                   	pop    %esi
  802a0b:	5f                   	pop    %edi
  802a0c:	5d                   	pop    %ebp
  802a0d:	c3                   	ret    

00802a0e <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802a0e:	55                   	push   %ebp
  802a0f:	89 e5                	mov    %esp,%ebp
  802a11:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802a14:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802a19:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802a1c:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802a22:	8b 52 50             	mov    0x50(%edx),%edx
  802a25:	39 ca                	cmp    %ecx,%edx
  802a27:	74 11                	je     802a3a <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  802a29:	83 c0 01             	add    $0x1,%eax
  802a2c:	3d 00 04 00 00       	cmp    $0x400,%eax
  802a31:	75 e6                	jne    802a19 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802a33:	b8 00 00 00 00       	mov    $0x0,%eax
  802a38:	eb 0b                	jmp    802a45 <ipc_find_env+0x37>
			return envs[i].env_id;
  802a3a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802a3d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802a42:	8b 40 48             	mov    0x48(%eax),%eax
}
  802a45:	5d                   	pop    %ebp
  802a46:	c3                   	ret    

00802a47 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  802a47:	55                   	push   %ebp
  802a48:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a4d:	05 00 00 00 30       	add    $0x30000000,%eax
  802a52:	c1 e8 0c             	shr    $0xc,%eax
}
  802a55:	5d                   	pop    %ebp
  802a56:	c3                   	ret    

00802a57 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802a57:	55                   	push   %ebp
  802a58:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a5d:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  802a62:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802a67:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  802a6c:	5d                   	pop    %ebp
  802a6d:	c3                   	ret    

00802a6e <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802a6e:	55                   	push   %ebp
  802a6f:	89 e5                	mov    %esp,%ebp
  802a71:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802a74:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802a79:	89 c2                	mov    %eax,%edx
  802a7b:	c1 ea 16             	shr    $0x16,%edx
  802a7e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  802a85:	f6 c2 01             	test   $0x1,%dl
  802a88:	74 2a                	je     802ab4 <fd_alloc+0x46>
  802a8a:	89 c2                	mov    %eax,%edx
  802a8c:	c1 ea 0c             	shr    $0xc,%edx
  802a8f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  802a96:	f6 c2 01             	test   $0x1,%dl
  802a99:	74 19                	je     802ab4 <fd_alloc+0x46>
  802a9b:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  802aa0:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  802aa5:	75 d2                	jne    802a79 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802aa7:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  802aad:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  802ab2:	eb 07                	jmp    802abb <fd_alloc+0x4d>
			*fd_store = fd;
  802ab4:	89 01                	mov    %eax,(%ecx)
			return 0;
  802ab6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802abb:	5d                   	pop    %ebp
  802abc:	c3                   	ret    

00802abd <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802abd:	55                   	push   %ebp
  802abe:	89 e5                	mov    %esp,%ebp
  802ac0:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802ac3:	83 f8 1f             	cmp    $0x1f,%eax
  802ac6:	77 36                	ja     802afe <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  802ac8:	c1 e0 0c             	shl    $0xc,%eax
  802acb:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802ad0:	89 c2                	mov    %eax,%edx
  802ad2:	c1 ea 16             	shr    $0x16,%edx
  802ad5:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  802adc:	f6 c2 01             	test   $0x1,%dl
  802adf:	74 24                	je     802b05 <fd_lookup+0x48>
  802ae1:	89 c2                	mov    %eax,%edx
  802ae3:	c1 ea 0c             	shr    $0xc,%edx
  802ae6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  802aed:	f6 c2 01             	test   $0x1,%dl
  802af0:	74 1a                	je     802b0c <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  802af2:	8b 55 0c             	mov    0xc(%ebp),%edx
  802af5:	89 02                	mov    %eax,(%edx)
	return 0;
  802af7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802afc:	5d                   	pop    %ebp
  802afd:	c3                   	ret    
		return -E_INVAL;
  802afe:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802b03:	eb f7                	jmp    802afc <fd_lookup+0x3f>
		return -E_INVAL;
  802b05:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802b0a:	eb f0                	jmp    802afc <fd_lookup+0x3f>
  802b0c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802b11:	eb e9                	jmp    802afc <fd_lookup+0x3f>

00802b13 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802b13:	55                   	push   %ebp
  802b14:	89 e5                	mov    %esp,%ebp
  802b16:	83 ec 08             	sub    $0x8,%esp
  802b19:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802b1c:	ba a4 47 80 00       	mov    $0x8047a4,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  802b21:	b8 64 90 80 00       	mov    $0x809064,%eax
		if (devtab[i]->dev_id == dev_id) {
  802b26:	39 08                	cmp    %ecx,(%eax)
  802b28:	74 33                	je     802b5d <dev_lookup+0x4a>
  802b2a:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  802b2d:	8b 02                	mov    (%edx),%eax
  802b2f:	85 c0                	test   %eax,%eax
  802b31:	75 f3                	jne    802b26 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802b33:	a1 10 a0 80 00       	mov    0x80a010,%eax
  802b38:	8b 40 48             	mov    0x48(%eax),%eax
  802b3b:	83 ec 04             	sub    $0x4,%esp
  802b3e:	51                   	push   %ecx
  802b3f:	50                   	push   %eax
  802b40:	68 28 47 80 00       	push   $0x804728
  802b45:	e8 bd f0 ff ff       	call   801c07 <cprintf>
	*dev = 0;
  802b4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b4d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  802b53:	83 c4 10             	add    $0x10,%esp
  802b56:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802b5b:	c9                   	leave  
  802b5c:	c3                   	ret    
			*dev = devtab[i];
  802b5d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802b60:	89 01                	mov    %eax,(%ecx)
			return 0;
  802b62:	b8 00 00 00 00       	mov    $0x0,%eax
  802b67:	eb f2                	jmp    802b5b <dev_lookup+0x48>

00802b69 <fd_close>:
{
  802b69:	55                   	push   %ebp
  802b6a:	89 e5                	mov    %esp,%ebp
  802b6c:	57                   	push   %edi
  802b6d:	56                   	push   %esi
  802b6e:	53                   	push   %ebx
  802b6f:	83 ec 1c             	sub    $0x1c,%esp
  802b72:	8b 75 08             	mov    0x8(%ebp),%esi
  802b75:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802b78:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  802b7b:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802b7c:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  802b82:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802b85:	50                   	push   %eax
  802b86:	e8 32 ff ff ff       	call   802abd <fd_lookup>
  802b8b:	89 c3                	mov    %eax,%ebx
  802b8d:	83 c4 08             	add    $0x8,%esp
  802b90:	85 c0                	test   %eax,%eax
  802b92:	78 05                	js     802b99 <fd_close+0x30>
	    || fd != fd2)
  802b94:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  802b97:	74 16                	je     802baf <fd_close+0x46>
		return (must_exist ? r : 0);
  802b99:	89 f8                	mov    %edi,%eax
  802b9b:	84 c0                	test   %al,%al
  802b9d:	b8 00 00 00 00       	mov    $0x0,%eax
  802ba2:	0f 44 d8             	cmove  %eax,%ebx
}
  802ba5:	89 d8                	mov    %ebx,%eax
  802ba7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802baa:	5b                   	pop    %ebx
  802bab:	5e                   	pop    %esi
  802bac:	5f                   	pop    %edi
  802bad:	5d                   	pop    %ebp
  802bae:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802baf:	83 ec 08             	sub    $0x8,%esp
  802bb2:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802bb5:	50                   	push   %eax
  802bb6:	ff 36                	pushl  (%esi)
  802bb8:	e8 56 ff ff ff       	call   802b13 <dev_lookup>
  802bbd:	89 c3                	mov    %eax,%ebx
  802bbf:	83 c4 10             	add    $0x10,%esp
  802bc2:	85 c0                	test   %eax,%eax
  802bc4:	78 15                	js     802bdb <fd_close+0x72>
		if (dev->dev_close)
  802bc6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bc9:	8b 40 10             	mov    0x10(%eax),%eax
  802bcc:	85 c0                	test   %eax,%eax
  802bce:	74 1b                	je     802beb <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  802bd0:	83 ec 0c             	sub    $0xc,%esp
  802bd3:	56                   	push   %esi
  802bd4:	ff d0                	call   *%eax
  802bd6:	89 c3                	mov    %eax,%ebx
  802bd8:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  802bdb:	83 ec 08             	sub    $0x8,%esp
  802bde:	56                   	push   %esi
  802bdf:	6a 00                	push   $0x0
  802be1:	e8 3c fb ff ff       	call   802722 <sys_page_unmap>
	return r;
  802be6:	83 c4 10             	add    $0x10,%esp
  802be9:	eb ba                	jmp    802ba5 <fd_close+0x3c>
			r = 0;
  802beb:	bb 00 00 00 00       	mov    $0x0,%ebx
  802bf0:	eb e9                	jmp    802bdb <fd_close+0x72>

00802bf2 <close>:

int
close(int fdnum)
{
  802bf2:	55                   	push   %ebp
  802bf3:	89 e5                	mov    %esp,%ebp
  802bf5:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802bf8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802bfb:	50                   	push   %eax
  802bfc:	ff 75 08             	pushl  0x8(%ebp)
  802bff:	e8 b9 fe ff ff       	call   802abd <fd_lookup>
  802c04:	83 c4 08             	add    $0x8,%esp
  802c07:	85 c0                	test   %eax,%eax
  802c09:	78 10                	js     802c1b <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  802c0b:	83 ec 08             	sub    $0x8,%esp
  802c0e:	6a 01                	push   $0x1
  802c10:	ff 75 f4             	pushl  -0xc(%ebp)
  802c13:	e8 51 ff ff ff       	call   802b69 <fd_close>
  802c18:	83 c4 10             	add    $0x10,%esp
}
  802c1b:	c9                   	leave  
  802c1c:	c3                   	ret    

00802c1d <close_all>:

void
close_all(void)
{
  802c1d:	55                   	push   %ebp
  802c1e:	89 e5                	mov    %esp,%ebp
  802c20:	53                   	push   %ebx
  802c21:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  802c24:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  802c29:	83 ec 0c             	sub    $0xc,%esp
  802c2c:	53                   	push   %ebx
  802c2d:	e8 c0 ff ff ff       	call   802bf2 <close>
	for (i = 0; i < MAXFD; i++)
  802c32:	83 c3 01             	add    $0x1,%ebx
  802c35:	83 c4 10             	add    $0x10,%esp
  802c38:	83 fb 20             	cmp    $0x20,%ebx
  802c3b:	75 ec                	jne    802c29 <close_all+0xc>
}
  802c3d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802c40:	c9                   	leave  
  802c41:	c3                   	ret    

00802c42 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802c42:	55                   	push   %ebp
  802c43:	89 e5                	mov    %esp,%ebp
  802c45:	57                   	push   %edi
  802c46:	56                   	push   %esi
  802c47:	53                   	push   %ebx
  802c48:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802c4b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  802c4e:	50                   	push   %eax
  802c4f:	ff 75 08             	pushl  0x8(%ebp)
  802c52:	e8 66 fe ff ff       	call   802abd <fd_lookup>
  802c57:	89 c3                	mov    %eax,%ebx
  802c59:	83 c4 08             	add    $0x8,%esp
  802c5c:	85 c0                	test   %eax,%eax
  802c5e:	0f 88 81 00 00 00    	js     802ce5 <dup+0xa3>
		return r;
	close(newfdnum);
  802c64:	83 ec 0c             	sub    $0xc,%esp
  802c67:	ff 75 0c             	pushl  0xc(%ebp)
  802c6a:	e8 83 ff ff ff       	call   802bf2 <close>

	newfd = INDEX2FD(newfdnum);
  802c6f:	8b 75 0c             	mov    0xc(%ebp),%esi
  802c72:	c1 e6 0c             	shl    $0xc,%esi
  802c75:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  802c7b:	83 c4 04             	add    $0x4,%esp
  802c7e:	ff 75 e4             	pushl  -0x1c(%ebp)
  802c81:	e8 d1 fd ff ff       	call   802a57 <fd2data>
  802c86:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  802c88:	89 34 24             	mov    %esi,(%esp)
  802c8b:	e8 c7 fd ff ff       	call   802a57 <fd2data>
  802c90:	83 c4 10             	add    $0x10,%esp
  802c93:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802c95:	89 d8                	mov    %ebx,%eax
  802c97:	c1 e8 16             	shr    $0x16,%eax
  802c9a:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  802ca1:	a8 01                	test   $0x1,%al
  802ca3:	74 11                	je     802cb6 <dup+0x74>
  802ca5:	89 d8                	mov    %ebx,%eax
  802ca7:	c1 e8 0c             	shr    $0xc,%eax
  802caa:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  802cb1:	f6 c2 01             	test   $0x1,%dl
  802cb4:	75 39                	jne    802cef <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802cb6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802cb9:	89 d0                	mov    %edx,%eax
  802cbb:	c1 e8 0c             	shr    $0xc,%eax
  802cbe:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  802cc5:	83 ec 0c             	sub    $0xc,%esp
  802cc8:	25 07 0e 00 00       	and    $0xe07,%eax
  802ccd:	50                   	push   %eax
  802cce:	56                   	push   %esi
  802ccf:	6a 00                	push   $0x0
  802cd1:	52                   	push   %edx
  802cd2:	6a 00                	push   $0x0
  802cd4:	e8 07 fa ff ff       	call   8026e0 <sys_page_map>
  802cd9:	89 c3                	mov    %eax,%ebx
  802cdb:	83 c4 20             	add    $0x20,%esp
  802cde:	85 c0                	test   %eax,%eax
  802ce0:	78 31                	js     802d13 <dup+0xd1>
		goto err;

	return newfdnum;
  802ce2:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  802ce5:	89 d8                	mov    %ebx,%eax
  802ce7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802cea:	5b                   	pop    %ebx
  802ceb:	5e                   	pop    %esi
  802cec:	5f                   	pop    %edi
  802ced:	5d                   	pop    %ebp
  802cee:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802cef:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  802cf6:	83 ec 0c             	sub    $0xc,%esp
  802cf9:	25 07 0e 00 00       	and    $0xe07,%eax
  802cfe:	50                   	push   %eax
  802cff:	57                   	push   %edi
  802d00:	6a 00                	push   $0x0
  802d02:	53                   	push   %ebx
  802d03:	6a 00                	push   $0x0
  802d05:	e8 d6 f9 ff ff       	call   8026e0 <sys_page_map>
  802d0a:	89 c3                	mov    %eax,%ebx
  802d0c:	83 c4 20             	add    $0x20,%esp
  802d0f:	85 c0                	test   %eax,%eax
  802d11:	79 a3                	jns    802cb6 <dup+0x74>
	sys_page_unmap(0, newfd);
  802d13:	83 ec 08             	sub    $0x8,%esp
  802d16:	56                   	push   %esi
  802d17:	6a 00                	push   $0x0
  802d19:	e8 04 fa ff ff       	call   802722 <sys_page_unmap>
	sys_page_unmap(0, nva);
  802d1e:	83 c4 08             	add    $0x8,%esp
  802d21:	57                   	push   %edi
  802d22:	6a 00                	push   $0x0
  802d24:	e8 f9 f9 ff ff       	call   802722 <sys_page_unmap>
	return r;
  802d29:	83 c4 10             	add    $0x10,%esp
  802d2c:	eb b7                	jmp    802ce5 <dup+0xa3>

00802d2e <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802d2e:	55                   	push   %ebp
  802d2f:	89 e5                	mov    %esp,%ebp
  802d31:	53                   	push   %ebx
  802d32:	83 ec 14             	sub    $0x14,%esp
  802d35:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802d38:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802d3b:	50                   	push   %eax
  802d3c:	53                   	push   %ebx
  802d3d:	e8 7b fd ff ff       	call   802abd <fd_lookup>
  802d42:	83 c4 08             	add    $0x8,%esp
  802d45:	85 c0                	test   %eax,%eax
  802d47:	78 3f                	js     802d88 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802d49:	83 ec 08             	sub    $0x8,%esp
  802d4c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802d4f:	50                   	push   %eax
  802d50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d53:	ff 30                	pushl  (%eax)
  802d55:	e8 b9 fd ff ff       	call   802b13 <dev_lookup>
  802d5a:	83 c4 10             	add    $0x10,%esp
  802d5d:	85 c0                	test   %eax,%eax
  802d5f:	78 27                	js     802d88 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802d61:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d64:	8b 42 08             	mov    0x8(%edx),%eax
  802d67:	83 e0 03             	and    $0x3,%eax
  802d6a:	83 f8 01             	cmp    $0x1,%eax
  802d6d:	74 1e                	je     802d8d <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  802d6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d72:	8b 40 08             	mov    0x8(%eax),%eax
  802d75:	85 c0                	test   %eax,%eax
  802d77:	74 35                	je     802dae <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  802d79:	83 ec 04             	sub    $0x4,%esp
  802d7c:	ff 75 10             	pushl  0x10(%ebp)
  802d7f:	ff 75 0c             	pushl  0xc(%ebp)
  802d82:	52                   	push   %edx
  802d83:	ff d0                	call   *%eax
  802d85:	83 c4 10             	add    $0x10,%esp
}
  802d88:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802d8b:	c9                   	leave  
  802d8c:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802d8d:	a1 10 a0 80 00       	mov    0x80a010,%eax
  802d92:	8b 40 48             	mov    0x48(%eax),%eax
  802d95:	83 ec 04             	sub    $0x4,%esp
  802d98:	53                   	push   %ebx
  802d99:	50                   	push   %eax
  802d9a:	68 69 47 80 00       	push   $0x804769
  802d9f:	e8 63 ee ff ff       	call   801c07 <cprintf>
		return -E_INVAL;
  802da4:	83 c4 10             	add    $0x10,%esp
  802da7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802dac:	eb da                	jmp    802d88 <read+0x5a>
		return -E_NOT_SUPP;
  802dae:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802db3:	eb d3                	jmp    802d88 <read+0x5a>

00802db5 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802db5:	55                   	push   %ebp
  802db6:	89 e5                	mov    %esp,%ebp
  802db8:	57                   	push   %edi
  802db9:	56                   	push   %esi
  802dba:	53                   	push   %ebx
  802dbb:	83 ec 0c             	sub    $0xc,%esp
  802dbe:	8b 7d 08             	mov    0x8(%ebp),%edi
  802dc1:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802dc4:	bb 00 00 00 00       	mov    $0x0,%ebx
  802dc9:	39 f3                	cmp    %esi,%ebx
  802dcb:	73 25                	jae    802df2 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802dcd:	83 ec 04             	sub    $0x4,%esp
  802dd0:	89 f0                	mov    %esi,%eax
  802dd2:	29 d8                	sub    %ebx,%eax
  802dd4:	50                   	push   %eax
  802dd5:	89 d8                	mov    %ebx,%eax
  802dd7:	03 45 0c             	add    0xc(%ebp),%eax
  802dda:	50                   	push   %eax
  802ddb:	57                   	push   %edi
  802ddc:	e8 4d ff ff ff       	call   802d2e <read>
		if (m < 0)
  802de1:	83 c4 10             	add    $0x10,%esp
  802de4:	85 c0                	test   %eax,%eax
  802de6:	78 08                	js     802df0 <readn+0x3b>
			return m;
		if (m == 0)
  802de8:	85 c0                	test   %eax,%eax
  802dea:	74 06                	je     802df2 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  802dec:	01 c3                	add    %eax,%ebx
  802dee:	eb d9                	jmp    802dc9 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802df0:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  802df2:	89 d8                	mov    %ebx,%eax
  802df4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802df7:	5b                   	pop    %ebx
  802df8:	5e                   	pop    %esi
  802df9:	5f                   	pop    %edi
  802dfa:	5d                   	pop    %ebp
  802dfb:	c3                   	ret    

00802dfc <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802dfc:	55                   	push   %ebp
  802dfd:	89 e5                	mov    %esp,%ebp
  802dff:	53                   	push   %ebx
  802e00:	83 ec 14             	sub    $0x14,%esp
  802e03:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802e06:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802e09:	50                   	push   %eax
  802e0a:	53                   	push   %ebx
  802e0b:	e8 ad fc ff ff       	call   802abd <fd_lookup>
  802e10:	83 c4 08             	add    $0x8,%esp
  802e13:	85 c0                	test   %eax,%eax
  802e15:	78 3a                	js     802e51 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802e17:	83 ec 08             	sub    $0x8,%esp
  802e1a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802e1d:	50                   	push   %eax
  802e1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e21:	ff 30                	pushl  (%eax)
  802e23:	e8 eb fc ff ff       	call   802b13 <dev_lookup>
  802e28:	83 c4 10             	add    $0x10,%esp
  802e2b:	85 c0                	test   %eax,%eax
  802e2d:	78 22                	js     802e51 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802e2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e32:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  802e36:	74 1e                	je     802e56 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802e38:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e3b:	8b 52 0c             	mov    0xc(%edx),%edx
  802e3e:	85 d2                	test   %edx,%edx
  802e40:	74 35                	je     802e77 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  802e42:	83 ec 04             	sub    $0x4,%esp
  802e45:	ff 75 10             	pushl  0x10(%ebp)
  802e48:	ff 75 0c             	pushl  0xc(%ebp)
  802e4b:	50                   	push   %eax
  802e4c:	ff d2                	call   *%edx
  802e4e:	83 c4 10             	add    $0x10,%esp
}
  802e51:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802e54:	c9                   	leave  
  802e55:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802e56:	a1 10 a0 80 00       	mov    0x80a010,%eax
  802e5b:	8b 40 48             	mov    0x48(%eax),%eax
  802e5e:	83 ec 04             	sub    $0x4,%esp
  802e61:	53                   	push   %ebx
  802e62:	50                   	push   %eax
  802e63:	68 85 47 80 00       	push   $0x804785
  802e68:	e8 9a ed ff ff       	call   801c07 <cprintf>
		return -E_INVAL;
  802e6d:	83 c4 10             	add    $0x10,%esp
  802e70:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802e75:	eb da                	jmp    802e51 <write+0x55>
		return -E_NOT_SUPP;
  802e77:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802e7c:	eb d3                	jmp    802e51 <write+0x55>

00802e7e <seek>:

int
seek(int fdnum, off_t offset)
{
  802e7e:	55                   	push   %ebp
  802e7f:	89 e5                	mov    %esp,%ebp
  802e81:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802e84:	8d 45 fc             	lea    -0x4(%ebp),%eax
  802e87:	50                   	push   %eax
  802e88:	ff 75 08             	pushl  0x8(%ebp)
  802e8b:	e8 2d fc ff ff       	call   802abd <fd_lookup>
  802e90:	83 c4 08             	add    $0x8,%esp
  802e93:	85 c0                	test   %eax,%eax
  802e95:	78 0e                	js     802ea5 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  802e97:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e9a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802e9d:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  802ea0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ea5:	c9                   	leave  
  802ea6:	c3                   	ret    

00802ea7 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802ea7:	55                   	push   %ebp
  802ea8:	89 e5                	mov    %esp,%ebp
  802eaa:	53                   	push   %ebx
  802eab:	83 ec 14             	sub    $0x14,%esp
  802eae:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802eb1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802eb4:	50                   	push   %eax
  802eb5:	53                   	push   %ebx
  802eb6:	e8 02 fc ff ff       	call   802abd <fd_lookup>
  802ebb:	83 c4 08             	add    $0x8,%esp
  802ebe:	85 c0                	test   %eax,%eax
  802ec0:	78 37                	js     802ef9 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802ec2:	83 ec 08             	sub    $0x8,%esp
  802ec5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802ec8:	50                   	push   %eax
  802ec9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ecc:	ff 30                	pushl  (%eax)
  802ece:	e8 40 fc ff ff       	call   802b13 <dev_lookup>
  802ed3:	83 c4 10             	add    $0x10,%esp
  802ed6:	85 c0                	test   %eax,%eax
  802ed8:	78 1f                	js     802ef9 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802eda:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802edd:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  802ee1:	74 1b                	je     802efe <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  802ee3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ee6:	8b 52 18             	mov    0x18(%edx),%edx
  802ee9:	85 d2                	test   %edx,%edx
  802eeb:	74 32                	je     802f1f <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  802eed:	83 ec 08             	sub    $0x8,%esp
  802ef0:	ff 75 0c             	pushl  0xc(%ebp)
  802ef3:	50                   	push   %eax
  802ef4:	ff d2                	call   *%edx
  802ef6:	83 c4 10             	add    $0x10,%esp
}
  802ef9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802efc:	c9                   	leave  
  802efd:	c3                   	ret    
			thisenv->env_id, fdnum);
  802efe:	a1 10 a0 80 00       	mov    0x80a010,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802f03:	8b 40 48             	mov    0x48(%eax),%eax
  802f06:	83 ec 04             	sub    $0x4,%esp
  802f09:	53                   	push   %ebx
  802f0a:	50                   	push   %eax
  802f0b:	68 48 47 80 00       	push   $0x804748
  802f10:	e8 f2 ec ff ff       	call   801c07 <cprintf>
		return -E_INVAL;
  802f15:	83 c4 10             	add    $0x10,%esp
  802f18:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802f1d:	eb da                	jmp    802ef9 <ftruncate+0x52>
		return -E_NOT_SUPP;
  802f1f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802f24:	eb d3                	jmp    802ef9 <ftruncate+0x52>

00802f26 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802f26:	55                   	push   %ebp
  802f27:	89 e5                	mov    %esp,%ebp
  802f29:	53                   	push   %ebx
  802f2a:	83 ec 14             	sub    $0x14,%esp
  802f2d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802f30:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802f33:	50                   	push   %eax
  802f34:	ff 75 08             	pushl  0x8(%ebp)
  802f37:	e8 81 fb ff ff       	call   802abd <fd_lookup>
  802f3c:	83 c4 08             	add    $0x8,%esp
  802f3f:	85 c0                	test   %eax,%eax
  802f41:	78 4b                	js     802f8e <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802f43:	83 ec 08             	sub    $0x8,%esp
  802f46:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802f49:	50                   	push   %eax
  802f4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f4d:	ff 30                	pushl  (%eax)
  802f4f:	e8 bf fb ff ff       	call   802b13 <dev_lookup>
  802f54:	83 c4 10             	add    $0x10,%esp
  802f57:	85 c0                	test   %eax,%eax
  802f59:	78 33                	js     802f8e <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  802f5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5e:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  802f62:	74 2f                	je     802f93 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  802f64:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  802f67:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  802f6e:	00 00 00 
	stat->st_isdir = 0;
  802f71:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802f78:	00 00 00 
	stat->st_dev = dev;
  802f7b:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  802f81:	83 ec 08             	sub    $0x8,%esp
  802f84:	53                   	push   %ebx
  802f85:	ff 75 f0             	pushl  -0x10(%ebp)
  802f88:	ff 50 14             	call   *0x14(%eax)
  802f8b:	83 c4 10             	add    $0x10,%esp
}
  802f8e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802f91:	c9                   	leave  
  802f92:	c3                   	ret    
		return -E_NOT_SUPP;
  802f93:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802f98:	eb f4                	jmp    802f8e <fstat+0x68>

00802f9a <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802f9a:	55                   	push   %ebp
  802f9b:	89 e5                	mov    %esp,%ebp
  802f9d:	56                   	push   %esi
  802f9e:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802f9f:	83 ec 08             	sub    $0x8,%esp
  802fa2:	6a 00                	push   $0x0
  802fa4:	ff 75 08             	pushl  0x8(%ebp)
  802fa7:	e8 26 02 00 00       	call   8031d2 <open>
  802fac:	89 c3                	mov    %eax,%ebx
  802fae:	83 c4 10             	add    $0x10,%esp
  802fb1:	85 c0                	test   %eax,%eax
  802fb3:	78 1b                	js     802fd0 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  802fb5:	83 ec 08             	sub    $0x8,%esp
  802fb8:	ff 75 0c             	pushl  0xc(%ebp)
  802fbb:	50                   	push   %eax
  802fbc:	e8 65 ff ff ff       	call   802f26 <fstat>
  802fc1:	89 c6                	mov    %eax,%esi
	close(fd);
  802fc3:	89 1c 24             	mov    %ebx,(%esp)
  802fc6:	e8 27 fc ff ff       	call   802bf2 <close>
	return r;
  802fcb:	83 c4 10             	add    $0x10,%esp
  802fce:	89 f3                	mov    %esi,%ebx
}
  802fd0:	89 d8                	mov    %ebx,%eax
  802fd2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802fd5:	5b                   	pop    %ebx
  802fd6:	5e                   	pop    %esi
  802fd7:	5d                   	pop    %ebp
  802fd8:	c3                   	ret    

00802fd9 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802fd9:	55                   	push   %ebp
  802fda:	89 e5                	mov    %esp,%ebp
  802fdc:	56                   	push   %esi
  802fdd:	53                   	push   %ebx
  802fde:	89 c6                	mov    %eax,%esi
  802fe0:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  802fe2:	83 3d 00 a0 80 00 00 	cmpl   $0x0,0x80a000
  802fe9:	74 27                	je     803012 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802feb:	6a 07                	push   $0x7
  802fed:	68 00 b0 80 00       	push   $0x80b000
  802ff2:	56                   	push   %esi
  802ff3:	ff 35 00 a0 80 00    	pushl  0x80a000
  802ff9:	e8 b7 f9 ff ff       	call   8029b5 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  802ffe:	83 c4 0c             	add    $0xc,%esp
  803001:	6a 00                	push   $0x0
  803003:	53                   	push   %ebx
  803004:	6a 00                	push   $0x0
  803006:	e8 41 f9 ff ff       	call   80294c <ipc_recv>
}
  80300b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80300e:	5b                   	pop    %ebx
  80300f:	5e                   	pop    %esi
  803010:	5d                   	pop    %ebp
  803011:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  803012:	83 ec 0c             	sub    $0xc,%esp
  803015:	6a 01                	push   $0x1
  803017:	e8 f2 f9 ff ff       	call   802a0e <ipc_find_env>
  80301c:	a3 00 a0 80 00       	mov    %eax,0x80a000
  803021:	83 c4 10             	add    $0x10,%esp
  803024:	eb c5                	jmp    802feb <fsipc+0x12>

00803026 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  803026:	55                   	push   %ebp
  803027:	89 e5                	mov    %esp,%ebp
  803029:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80302c:	8b 45 08             	mov    0x8(%ebp),%eax
  80302f:	8b 40 0c             	mov    0xc(%eax),%eax
  803032:	a3 00 b0 80 00       	mov    %eax,0x80b000
	fsipcbuf.set_size.req_size = newsize;
  803037:	8b 45 0c             	mov    0xc(%ebp),%eax
  80303a:	a3 04 b0 80 00       	mov    %eax,0x80b004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80303f:	ba 00 00 00 00       	mov    $0x0,%edx
  803044:	b8 02 00 00 00       	mov    $0x2,%eax
  803049:	e8 8b ff ff ff       	call   802fd9 <fsipc>
}
  80304e:	c9                   	leave  
  80304f:	c3                   	ret    

00803050 <devfile_flush>:
{
  803050:	55                   	push   %ebp
  803051:	89 e5                	mov    %esp,%ebp
  803053:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  803056:	8b 45 08             	mov    0x8(%ebp),%eax
  803059:	8b 40 0c             	mov    0xc(%eax),%eax
  80305c:	a3 00 b0 80 00       	mov    %eax,0x80b000
	return fsipc(FSREQ_FLUSH, NULL);
  803061:	ba 00 00 00 00       	mov    $0x0,%edx
  803066:	b8 06 00 00 00       	mov    $0x6,%eax
  80306b:	e8 69 ff ff ff       	call   802fd9 <fsipc>
}
  803070:	c9                   	leave  
  803071:	c3                   	ret    

00803072 <devfile_stat>:
{
  803072:	55                   	push   %ebp
  803073:	89 e5                	mov    %esp,%ebp
  803075:	53                   	push   %ebx
  803076:	83 ec 04             	sub    $0x4,%esp
  803079:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80307c:	8b 45 08             	mov    0x8(%ebp),%eax
  80307f:	8b 40 0c             	mov    0xc(%eax),%eax
  803082:	a3 00 b0 80 00       	mov    %eax,0x80b000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  803087:	ba 00 00 00 00       	mov    $0x0,%edx
  80308c:	b8 05 00 00 00       	mov    $0x5,%eax
  803091:	e8 43 ff ff ff       	call   802fd9 <fsipc>
  803096:	85 c0                	test   %eax,%eax
  803098:	78 2c                	js     8030c6 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80309a:	83 ec 08             	sub    $0x8,%esp
  80309d:	68 00 b0 80 00       	push   $0x80b000
  8030a2:	53                   	push   %ebx
  8030a3:	e8 fc f1 ff ff       	call   8022a4 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8030a8:	a1 80 b0 80 00       	mov    0x80b080,%eax
  8030ad:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8030b3:	a1 84 b0 80 00       	mov    0x80b084,%eax
  8030b8:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8030be:	83 c4 10             	add    $0x10,%esp
  8030c1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8030c6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8030c9:	c9                   	leave  
  8030ca:	c3                   	ret    

008030cb <devfile_write>:
{
  8030cb:	55                   	push   %ebp
  8030cc:	89 e5                	mov    %esp,%ebp
  8030ce:	53                   	push   %ebx
  8030cf:	83 ec 04             	sub    $0x4,%esp
  8030d2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8030d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d8:	8b 40 0c             	mov    0xc(%eax),%eax
  8030db:	a3 00 b0 80 00       	mov    %eax,0x80b000
	fsipcbuf.write.req_n = n;
  8030e0:	89 1d 04 b0 80 00    	mov    %ebx,0x80b004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  8030e6:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  8030ec:	77 30                	ja     80311e <devfile_write+0x53>
	memmove(fsipcbuf.write.req_buf, buf, n);
  8030ee:	83 ec 04             	sub    $0x4,%esp
  8030f1:	53                   	push   %ebx
  8030f2:	ff 75 0c             	pushl  0xc(%ebp)
  8030f5:	68 08 b0 80 00       	push   $0x80b008
  8030fa:	e8 33 f3 ff ff       	call   802432 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8030ff:	ba 00 00 00 00       	mov    $0x0,%edx
  803104:	b8 04 00 00 00       	mov    $0x4,%eax
  803109:	e8 cb fe ff ff       	call   802fd9 <fsipc>
  80310e:	83 c4 10             	add    $0x10,%esp
  803111:	85 c0                	test   %eax,%eax
  803113:	78 04                	js     803119 <devfile_write+0x4e>
	assert(r <= n);
  803115:	39 d8                	cmp    %ebx,%eax
  803117:	77 1e                	ja     803137 <devfile_write+0x6c>
}
  803119:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80311c:	c9                   	leave  
  80311d:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  80311e:	68 b8 47 80 00       	push   $0x8047b8
  803123:	68 7d 3e 80 00       	push   $0x803e7d
  803128:	68 94 00 00 00       	push   $0x94
  80312d:	68 e8 47 80 00       	push   $0x8047e8
  803132:	e8 f5 e9 ff ff       	call   801b2c <_panic>
	assert(r <= n);
  803137:	68 f3 47 80 00       	push   $0x8047f3
  80313c:	68 7d 3e 80 00       	push   $0x803e7d
  803141:	68 98 00 00 00       	push   $0x98
  803146:	68 e8 47 80 00       	push   $0x8047e8
  80314b:	e8 dc e9 ff ff       	call   801b2c <_panic>

00803150 <devfile_read>:
{
  803150:	55                   	push   %ebp
  803151:	89 e5                	mov    %esp,%ebp
  803153:	56                   	push   %esi
  803154:	53                   	push   %ebx
  803155:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  803158:	8b 45 08             	mov    0x8(%ebp),%eax
  80315b:	8b 40 0c             	mov    0xc(%eax),%eax
  80315e:	a3 00 b0 80 00       	mov    %eax,0x80b000
	fsipcbuf.read.req_n = n;
  803163:	89 35 04 b0 80 00    	mov    %esi,0x80b004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  803169:	ba 00 00 00 00       	mov    $0x0,%edx
  80316e:	b8 03 00 00 00       	mov    $0x3,%eax
  803173:	e8 61 fe ff ff       	call   802fd9 <fsipc>
  803178:	89 c3                	mov    %eax,%ebx
  80317a:	85 c0                	test   %eax,%eax
  80317c:	78 1f                	js     80319d <devfile_read+0x4d>
	assert(r <= n);
  80317e:	39 f0                	cmp    %esi,%eax
  803180:	77 24                	ja     8031a6 <devfile_read+0x56>
	assert(r <= PGSIZE);
  803182:	3d 00 10 00 00       	cmp    $0x1000,%eax
  803187:	7f 33                	jg     8031bc <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  803189:	83 ec 04             	sub    $0x4,%esp
  80318c:	50                   	push   %eax
  80318d:	68 00 b0 80 00       	push   $0x80b000
  803192:	ff 75 0c             	pushl  0xc(%ebp)
  803195:	e8 98 f2 ff ff       	call   802432 <memmove>
	return r;
  80319a:	83 c4 10             	add    $0x10,%esp
}
  80319d:	89 d8                	mov    %ebx,%eax
  80319f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8031a2:	5b                   	pop    %ebx
  8031a3:	5e                   	pop    %esi
  8031a4:	5d                   	pop    %ebp
  8031a5:	c3                   	ret    
	assert(r <= n);
  8031a6:	68 f3 47 80 00       	push   $0x8047f3
  8031ab:	68 7d 3e 80 00       	push   $0x803e7d
  8031b0:	6a 7c                	push   $0x7c
  8031b2:	68 e8 47 80 00       	push   $0x8047e8
  8031b7:	e8 70 e9 ff ff       	call   801b2c <_panic>
	assert(r <= PGSIZE);
  8031bc:	68 fa 47 80 00       	push   $0x8047fa
  8031c1:	68 7d 3e 80 00       	push   $0x803e7d
  8031c6:	6a 7d                	push   $0x7d
  8031c8:	68 e8 47 80 00       	push   $0x8047e8
  8031cd:	e8 5a e9 ff ff       	call   801b2c <_panic>

008031d2 <open>:
{
  8031d2:	55                   	push   %ebp
  8031d3:	89 e5                	mov    %esp,%ebp
  8031d5:	56                   	push   %esi
  8031d6:	53                   	push   %ebx
  8031d7:	83 ec 1c             	sub    $0x1c,%esp
  8031da:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8031dd:	56                   	push   %esi
  8031de:	e8 8a f0 ff ff       	call   80226d <strlen>
  8031e3:	83 c4 10             	add    $0x10,%esp
  8031e6:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8031eb:	7f 6c                	jg     803259 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8031ed:	83 ec 0c             	sub    $0xc,%esp
  8031f0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8031f3:	50                   	push   %eax
  8031f4:	e8 75 f8 ff ff       	call   802a6e <fd_alloc>
  8031f9:	89 c3                	mov    %eax,%ebx
  8031fb:	83 c4 10             	add    $0x10,%esp
  8031fe:	85 c0                	test   %eax,%eax
  803200:	78 3c                	js     80323e <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  803202:	83 ec 08             	sub    $0x8,%esp
  803205:	56                   	push   %esi
  803206:	68 00 b0 80 00       	push   $0x80b000
  80320b:	e8 94 f0 ff ff       	call   8022a4 <strcpy>
	fsipcbuf.open.req_omode = mode;
  803210:	8b 45 0c             	mov    0xc(%ebp),%eax
  803213:	a3 00 b4 80 00       	mov    %eax,0x80b400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  803218:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80321b:	b8 01 00 00 00       	mov    $0x1,%eax
  803220:	e8 b4 fd ff ff       	call   802fd9 <fsipc>
  803225:	89 c3                	mov    %eax,%ebx
  803227:	83 c4 10             	add    $0x10,%esp
  80322a:	85 c0                	test   %eax,%eax
  80322c:	78 19                	js     803247 <open+0x75>
	return fd2num(fd);
  80322e:	83 ec 0c             	sub    $0xc,%esp
  803231:	ff 75 f4             	pushl  -0xc(%ebp)
  803234:	e8 0e f8 ff ff       	call   802a47 <fd2num>
  803239:	89 c3                	mov    %eax,%ebx
  80323b:	83 c4 10             	add    $0x10,%esp
}
  80323e:	89 d8                	mov    %ebx,%eax
  803240:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803243:	5b                   	pop    %ebx
  803244:	5e                   	pop    %esi
  803245:	5d                   	pop    %ebp
  803246:	c3                   	ret    
		fd_close(fd, 0);
  803247:	83 ec 08             	sub    $0x8,%esp
  80324a:	6a 00                	push   $0x0
  80324c:	ff 75 f4             	pushl  -0xc(%ebp)
  80324f:	e8 15 f9 ff ff       	call   802b69 <fd_close>
		return r;
  803254:	83 c4 10             	add    $0x10,%esp
  803257:	eb e5                	jmp    80323e <open+0x6c>
		return -E_BAD_PATH;
  803259:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80325e:	eb de                	jmp    80323e <open+0x6c>

00803260 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  803260:	55                   	push   %ebp
  803261:	89 e5                	mov    %esp,%ebp
  803263:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  803266:	ba 00 00 00 00       	mov    $0x0,%edx
  80326b:	b8 08 00 00 00       	mov    $0x8,%eax
  803270:	e8 64 fd ff ff       	call   802fd9 <fsipc>
}
  803275:	c9                   	leave  
  803276:	c3                   	ret    

00803277 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803277:	55                   	push   %ebp
  803278:	89 e5                	mov    %esp,%ebp
  80327a:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80327d:	89 d0                	mov    %edx,%eax
  80327f:	c1 e8 16             	shr    $0x16,%eax
  803282:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  803289:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80328e:	f6 c1 01             	test   $0x1,%cl
  803291:	74 1d                	je     8032b0 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  803293:	c1 ea 0c             	shr    $0xc,%edx
  803296:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80329d:	f6 c2 01             	test   $0x1,%dl
  8032a0:	74 0e                	je     8032b0 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8032a2:	c1 ea 0c             	shr    $0xc,%edx
  8032a5:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8032ac:	ef 
  8032ad:	0f b7 c0             	movzwl %ax,%eax
}
  8032b0:	5d                   	pop    %ebp
  8032b1:	c3                   	ret    

008032b2 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8032b2:	55                   	push   %ebp
  8032b3:	89 e5                	mov    %esp,%ebp
  8032b5:	56                   	push   %esi
  8032b6:	53                   	push   %ebx
  8032b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8032ba:	83 ec 0c             	sub    $0xc,%esp
  8032bd:	ff 75 08             	pushl  0x8(%ebp)
  8032c0:	e8 92 f7 ff ff       	call   802a57 <fd2data>
  8032c5:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8032c7:	83 c4 08             	add    $0x8,%esp
  8032ca:	68 06 48 80 00       	push   $0x804806
  8032cf:	53                   	push   %ebx
  8032d0:	e8 cf ef ff ff       	call   8022a4 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8032d5:	8b 46 04             	mov    0x4(%esi),%eax
  8032d8:	2b 06                	sub    (%esi),%eax
  8032da:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8032e0:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8032e7:	00 00 00 
	stat->st_dev = &devpipe;
  8032ea:	c7 83 88 00 00 00 80 	movl   $0x809080,0x88(%ebx)
  8032f1:	90 80 00 
	return 0;
}
  8032f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8032f9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8032fc:	5b                   	pop    %ebx
  8032fd:	5e                   	pop    %esi
  8032fe:	5d                   	pop    %ebp
  8032ff:	c3                   	ret    

00803300 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803300:	55                   	push   %ebp
  803301:	89 e5                	mov    %esp,%ebp
  803303:	53                   	push   %ebx
  803304:	83 ec 0c             	sub    $0xc,%esp
  803307:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80330a:	53                   	push   %ebx
  80330b:	6a 00                	push   $0x0
  80330d:	e8 10 f4 ff ff       	call   802722 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  803312:	89 1c 24             	mov    %ebx,(%esp)
  803315:	e8 3d f7 ff ff       	call   802a57 <fd2data>
  80331a:	83 c4 08             	add    $0x8,%esp
  80331d:	50                   	push   %eax
  80331e:	6a 00                	push   $0x0
  803320:	e8 fd f3 ff ff       	call   802722 <sys_page_unmap>
}
  803325:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803328:	c9                   	leave  
  803329:	c3                   	ret    

0080332a <_pipeisclosed>:
{
  80332a:	55                   	push   %ebp
  80332b:	89 e5                	mov    %esp,%ebp
  80332d:	57                   	push   %edi
  80332e:	56                   	push   %esi
  80332f:	53                   	push   %ebx
  803330:	83 ec 1c             	sub    $0x1c,%esp
  803333:	89 c7                	mov    %eax,%edi
  803335:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  803337:	a1 10 a0 80 00       	mov    0x80a010,%eax
  80333c:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  80333f:	83 ec 0c             	sub    $0xc,%esp
  803342:	57                   	push   %edi
  803343:	e8 2f ff ff ff       	call   803277 <pageref>
  803348:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80334b:	89 34 24             	mov    %esi,(%esp)
  80334e:	e8 24 ff ff ff       	call   803277 <pageref>
		nn = thisenv->env_runs;
  803353:	8b 15 10 a0 80 00    	mov    0x80a010,%edx
  803359:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80335c:	83 c4 10             	add    $0x10,%esp
  80335f:	39 cb                	cmp    %ecx,%ebx
  803361:	74 1b                	je     80337e <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  803363:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  803366:	75 cf                	jne    803337 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803368:	8b 42 58             	mov    0x58(%edx),%eax
  80336b:	6a 01                	push   $0x1
  80336d:	50                   	push   %eax
  80336e:	53                   	push   %ebx
  80336f:	68 0d 48 80 00       	push   $0x80480d
  803374:	e8 8e e8 ff ff       	call   801c07 <cprintf>
  803379:	83 c4 10             	add    $0x10,%esp
  80337c:	eb b9                	jmp    803337 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  80337e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  803381:	0f 94 c0             	sete   %al
  803384:	0f b6 c0             	movzbl %al,%eax
}
  803387:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80338a:	5b                   	pop    %ebx
  80338b:	5e                   	pop    %esi
  80338c:	5f                   	pop    %edi
  80338d:	5d                   	pop    %ebp
  80338e:	c3                   	ret    

0080338f <devpipe_write>:
{
  80338f:	55                   	push   %ebp
  803390:	89 e5                	mov    %esp,%ebp
  803392:	57                   	push   %edi
  803393:	56                   	push   %esi
  803394:	53                   	push   %ebx
  803395:	83 ec 28             	sub    $0x28,%esp
  803398:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80339b:	56                   	push   %esi
  80339c:	e8 b6 f6 ff ff       	call   802a57 <fd2data>
  8033a1:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8033a3:	83 c4 10             	add    $0x10,%esp
  8033a6:	bf 00 00 00 00       	mov    $0x0,%edi
  8033ab:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8033ae:	74 4f                	je     8033ff <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8033b0:	8b 43 04             	mov    0x4(%ebx),%eax
  8033b3:	8b 0b                	mov    (%ebx),%ecx
  8033b5:	8d 51 20             	lea    0x20(%ecx),%edx
  8033b8:	39 d0                	cmp    %edx,%eax
  8033ba:	72 14                	jb     8033d0 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8033bc:	89 da                	mov    %ebx,%edx
  8033be:	89 f0                	mov    %esi,%eax
  8033c0:	e8 65 ff ff ff       	call   80332a <_pipeisclosed>
  8033c5:	85 c0                	test   %eax,%eax
  8033c7:	75 3a                	jne    803403 <devpipe_write+0x74>
			sys_yield();
  8033c9:	e8 b0 f2 ff ff       	call   80267e <sys_yield>
  8033ce:	eb e0                	jmp    8033b0 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8033d0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8033d3:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8033d7:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8033da:	89 c2                	mov    %eax,%edx
  8033dc:	c1 fa 1f             	sar    $0x1f,%edx
  8033df:	89 d1                	mov    %edx,%ecx
  8033e1:	c1 e9 1b             	shr    $0x1b,%ecx
  8033e4:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8033e7:	83 e2 1f             	and    $0x1f,%edx
  8033ea:	29 ca                	sub    %ecx,%edx
  8033ec:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8033f0:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8033f4:	83 c0 01             	add    $0x1,%eax
  8033f7:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8033fa:	83 c7 01             	add    $0x1,%edi
  8033fd:	eb ac                	jmp    8033ab <devpipe_write+0x1c>
	return i;
  8033ff:	89 f8                	mov    %edi,%eax
  803401:	eb 05                	jmp    803408 <devpipe_write+0x79>
				return 0;
  803403:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803408:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80340b:	5b                   	pop    %ebx
  80340c:	5e                   	pop    %esi
  80340d:	5f                   	pop    %edi
  80340e:	5d                   	pop    %ebp
  80340f:	c3                   	ret    

00803410 <devpipe_read>:
{
  803410:	55                   	push   %ebp
  803411:	89 e5                	mov    %esp,%ebp
  803413:	57                   	push   %edi
  803414:	56                   	push   %esi
  803415:	53                   	push   %ebx
  803416:	83 ec 18             	sub    $0x18,%esp
  803419:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80341c:	57                   	push   %edi
  80341d:	e8 35 f6 ff ff       	call   802a57 <fd2data>
  803422:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  803424:	83 c4 10             	add    $0x10,%esp
  803427:	be 00 00 00 00       	mov    $0x0,%esi
  80342c:	3b 75 10             	cmp    0x10(%ebp),%esi
  80342f:	74 47                	je     803478 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  803431:	8b 03                	mov    (%ebx),%eax
  803433:	3b 43 04             	cmp    0x4(%ebx),%eax
  803436:	75 22                	jne    80345a <devpipe_read+0x4a>
			if (i > 0)
  803438:	85 f6                	test   %esi,%esi
  80343a:	75 14                	jne    803450 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  80343c:	89 da                	mov    %ebx,%edx
  80343e:	89 f8                	mov    %edi,%eax
  803440:	e8 e5 fe ff ff       	call   80332a <_pipeisclosed>
  803445:	85 c0                	test   %eax,%eax
  803447:	75 33                	jne    80347c <devpipe_read+0x6c>
			sys_yield();
  803449:	e8 30 f2 ff ff       	call   80267e <sys_yield>
  80344e:	eb e1                	jmp    803431 <devpipe_read+0x21>
				return i;
  803450:	89 f0                	mov    %esi,%eax
}
  803452:	8d 65 f4             	lea    -0xc(%ebp),%esp
  803455:	5b                   	pop    %ebx
  803456:	5e                   	pop    %esi
  803457:	5f                   	pop    %edi
  803458:	5d                   	pop    %ebp
  803459:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80345a:	99                   	cltd   
  80345b:	c1 ea 1b             	shr    $0x1b,%edx
  80345e:	01 d0                	add    %edx,%eax
  803460:	83 e0 1f             	and    $0x1f,%eax
  803463:	29 d0                	sub    %edx,%eax
  803465:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80346a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80346d:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  803470:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  803473:	83 c6 01             	add    $0x1,%esi
  803476:	eb b4                	jmp    80342c <devpipe_read+0x1c>
	return i;
  803478:	89 f0                	mov    %esi,%eax
  80347a:	eb d6                	jmp    803452 <devpipe_read+0x42>
				return 0;
  80347c:	b8 00 00 00 00       	mov    $0x0,%eax
  803481:	eb cf                	jmp    803452 <devpipe_read+0x42>

00803483 <pipe>:
{
  803483:	55                   	push   %ebp
  803484:	89 e5                	mov    %esp,%ebp
  803486:	56                   	push   %esi
  803487:	53                   	push   %ebx
  803488:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80348b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80348e:	50                   	push   %eax
  80348f:	e8 da f5 ff ff       	call   802a6e <fd_alloc>
  803494:	89 c3                	mov    %eax,%ebx
  803496:	83 c4 10             	add    $0x10,%esp
  803499:	85 c0                	test   %eax,%eax
  80349b:	78 5b                	js     8034f8 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80349d:	83 ec 04             	sub    $0x4,%esp
  8034a0:	68 07 04 00 00       	push   $0x407
  8034a5:	ff 75 f4             	pushl  -0xc(%ebp)
  8034a8:	6a 00                	push   $0x0
  8034aa:	e8 ee f1 ff ff       	call   80269d <sys_page_alloc>
  8034af:	89 c3                	mov    %eax,%ebx
  8034b1:	83 c4 10             	add    $0x10,%esp
  8034b4:	85 c0                	test   %eax,%eax
  8034b6:	78 40                	js     8034f8 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  8034b8:	83 ec 0c             	sub    $0xc,%esp
  8034bb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8034be:	50                   	push   %eax
  8034bf:	e8 aa f5 ff ff       	call   802a6e <fd_alloc>
  8034c4:	89 c3                	mov    %eax,%ebx
  8034c6:	83 c4 10             	add    $0x10,%esp
  8034c9:	85 c0                	test   %eax,%eax
  8034cb:	78 1b                	js     8034e8 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8034cd:	83 ec 04             	sub    $0x4,%esp
  8034d0:	68 07 04 00 00       	push   $0x407
  8034d5:	ff 75 f0             	pushl  -0x10(%ebp)
  8034d8:	6a 00                	push   $0x0
  8034da:	e8 be f1 ff ff       	call   80269d <sys_page_alloc>
  8034df:	89 c3                	mov    %eax,%ebx
  8034e1:	83 c4 10             	add    $0x10,%esp
  8034e4:	85 c0                	test   %eax,%eax
  8034e6:	79 19                	jns    803501 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  8034e8:	83 ec 08             	sub    $0x8,%esp
  8034eb:	ff 75 f4             	pushl  -0xc(%ebp)
  8034ee:	6a 00                	push   $0x0
  8034f0:	e8 2d f2 ff ff       	call   802722 <sys_page_unmap>
  8034f5:	83 c4 10             	add    $0x10,%esp
}
  8034f8:	89 d8                	mov    %ebx,%eax
  8034fa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8034fd:	5b                   	pop    %ebx
  8034fe:	5e                   	pop    %esi
  8034ff:	5d                   	pop    %ebp
  803500:	c3                   	ret    
	va = fd2data(fd0);
  803501:	83 ec 0c             	sub    $0xc,%esp
  803504:	ff 75 f4             	pushl  -0xc(%ebp)
  803507:	e8 4b f5 ff ff       	call   802a57 <fd2data>
  80350c:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80350e:	83 c4 0c             	add    $0xc,%esp
  803511:	68 07 04 00 00       	push   $0x407
  803516:	50                   	push   %eax
  803517:	6a 00                	push   $0x0
  803519:	e8 7f f1 ff ff       	call   80269d <sys_page_alloc>
  80351e:	89 c3                	mov    %eax,%ebx
  803520:	83 c4 10             	add    $0x10,%esp
  803523:	85 c0                	test   %eax,%eax
  803525:	0f 88 8c 00 00 00    	js     8035b7 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80352b:	83 ec 0c             	sub    $0xc,%esp
  80352e:	ff 75 f0             	pushl  -0x10(%ebp)
  803531:	e8 21 f5 ff ff       	call   802a57 <fd2data>
  803536:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80353d:	50                   	push   %eax
  80353e:	6a 00                	push   $0x0
  803540:	56                   	push   %esi
  803541:	6a 00                	push   $0x0
  803543:	e8 98 f1 ff ff       	call   8026e0 <sys_page_map>
  803548:	89 c3                	mov    %eax,%ebx
  80354a:	83 c4 20             	add    $0x20,%esp
  80354d:	85 c0                	test   %eax,%eax
  80354f:	78 58                	js     8035a9 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  803551:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803554:	8b 15 80 90 80 00    	mov    0x809080,%edx
  80355a:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80355c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80355f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  803566:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803569:	8b 15 80 90 80 00    	mov    0x809080,%edx
  80356f:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  803571:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803574:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80357b:	83 ec 0c             	sub    $0xc,%esp
  80357e:	ff 75 f4             	pushl  -0xc(%ebp)
  803581:	e8 c1 f4 ff ff       	call   802a47 <fd2num>
  803586:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803589:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80358b:	83 c4 04             	add    $0x4,%esp
  80358e:	ff 75 f0             	pushl  -0x10(%ebp)
  803591:	e8 b1 f4 ff ff       	call   802a47 <fd2num>
  803596:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803599:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80359c:	83 c4 10             	add    $0x10,%esp
  80359f:	bb 00 00 00 00       	mov    $0x0,%ebx
  8035a4:	e9 4f ff ff ff       	jmp    8034f8 <pipe+0x75>
	sys_page_unmap(0, va);
  8035a9:	83 ec 08             	sub    $0x8,%esp
  8035ac:	56                   	push   %esi
  8035ad:	6a 00                	push   $0x0
  8035af:	e8 6e f1 ff ff       	call   802722 <sys_page_unmap>
  8035b4:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8035b7:	83 ec 08             	sub    $0x8,%esp
  8035ba:	ff 75 f0             	pushl  -0x10(%ebp)
  8035bd:	6a 00                	push   $0x0
  8035bf:	e8 5e f1 ff ff       	call   802722 <sys_page_unmap>
  8035c4:	83 c4 10             	add    $0x10,%esp
  8035c7:	e9 1c ff ff ff       	jmp    8034e8 <pipe+0x65>

008035cc <pipeisclosed>:
{
  8035cc:	55                   	push   %ebp
  8035cd:	89 e5                	mov    %esp,%ebp
  8035cf:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8035d2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8035d5:	50                   	push   %eax
  8035d6:	ff 75 08             	pushl  0x8(%ebp)
  8035d9:	e8 df f4 ff ff       	call   802abd <fd_lookup>
  8035de:	83 c4 10             	add    $0x10,%esp
  8035e1:	85 c0                	test   %eax,%eax
  8035e3:	78 18                	js     8035fd <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8035e5:	83 ec 0c             	sub    $0xc,%esp
  8035e8:	ff 75 f4             	pushl  -0xc(%ebp)
  8035eb:	e8 67 f4 ff ff       	call   802a57 <fd2data>
	return _pipeisclosed(fd, p);
  8035f0:	89 c2                	mov    %eax,%edx
  8035f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035f5:	e8 30 fd ff ff       	call   80332a <_pipeisclosed>
  8035fa:	83 c4 10             	add    $0x10,%esp
}
  8035fd:	c9                   	leave  
  8035fe:	c3                   	ret    

008035ff <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8035ff:	55                   	push   %ebp
  803600:	89 e5                	mov    %esp,%ebp
  803602:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  803605:	68 25 48 80 00       	push   $0x804825
  80360a:	ff 75 0c             	pushl  0xc(%ebp)
  80360d:	e8 92 ec ff ff       	call   8022a4 <strcpy>
	return 0;
}
  803612:	b8 00 00 00 00       	mov    $0x0,%eax
  803617:	c9                   	leave  
  803618:	c3                   	ret    

00803619 <devsock_close>:
{
  803619:	55                   	push   %ebp
  80361a:	89 e5                	mov    %esp,%ebp
  80361c:	53                   	push   %ebx
  80361d:	83 ec 10             	sub    $0x10,%esp
  803620:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  803623:	53                   	push   %ebx
  803624:	e8 4e fc ff ff       	call   803277 <pageref>
  803629:	83 c4 10             	add    $0x10,%esp
		return 0;
  80362c:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  803631:	83 f8 01             	cmp    $0x1,%eax
  803634:	74 07                	je     80363d <devsock_close+0x24>
}
  803636:	89 d0                	mov    %edx,%eax
  803638:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80363b:	c9                   	leave  
  80363c:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  80363d:	83 ec 0c             	sub    $0xc,%esp
  803640:	ff 73 0c             	pushl  0xc(%ebx)
  803643:	e8 b7 02 00 00       	call   8038ff <nsipc_close>
  803648:	89 c2                	mov    %eax,%edx
  80364a:	83 c4 10             	add    $0x10,%esp
  80364d:	eb e7                	jmp    803636 <devsock_close+0x1d>

0080364f <devsock_write>:
{
  80364f:	55                   	push   %ebp
  803650:	89 e5                	mov    %esp,%ebp
  803652:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803655:	6a 00                	push   $0x0
  803657:	ff 75 10             	pushl  0x10(%ebp)
  80365a:	ff 75 0c             	pushl  0xc(%ebp)
  80365d:	8b 45 08             	mov    0x8(%ebp),%eax
  803660:	ff 70 0c             	pushl  0xc(%eax)
  803663:	e8 74 03 00 00       	call   8039dc <nsipc_send>
}
  803668:	c9                   	leave  
  803669:	c3                   	ret    

0080366a <devsock_read>:
{
  80366a:	55                   	push   %ebp
  80366b:	89 e5                	mov    %esp,%ebp
  80366d:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803670:	6a 00                	push   $0x0
  803672:	ff 75 10             	pushl  0x10(%ebp)
  803675:	ff 75 0c             	pushl  0xc(%ebp)
  803678:	8b 45 08             	mov    0x8(%ebp),%eax
  80367b:	ff 70 0c             	pushl  0xc(%eax)
  80367e:	e8 ed 02 00 00       	call   803970 <nsipc_recv>
}
  803683:	c9                   	leave  
  803684:	c3                   	ret    

00803685 <fd2sockid>:
{
  803685:	55                   	push   %ebp
  803686:	89 e5                	mov    %esp,%ebp
  803688:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  80368b:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80368e:	52                   	push   %edx
  80368f:	50                   	push   %eax
  803690:	e8 28 f4 ff ff       	call   802abd <fd_lookup>
  803695:	83 c4 10             	add    $0x10,%esp
  803698:	85 c0                	test   %eax,%eax
  80369a:	78 10                	js     8036ac <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  80369c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80369f:	8b 0d 9c 90 80 00    	mov    0x80909c,%ecx
  8036a5:	39 08                	cmp    %ecx,(%eax)
  8036a7:	75 05                	jne    8036ae <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8036a9:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8036ac:	c9                   	leave  
  8036ad:	c3                   	ret    
		return -E_NOT_SUPP;
  8036ae:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8036b3:	eb f7                	jmp    8036ac <fd2sockid+0x27>

008036b5 <alloc_sockfd>:
{
  8036b5:	55                   	push   %ebp
  8036b6:	89 e5                	mov    %esp,%ebp
  8036b8:	56                   	push   %esi
  8036b9:	53                   	push   %ebx
  8036ba:	83 ec 1c             	sub    $0x1c,%esp
  8036bd:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  8036bf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8036c2:	50                   	push   %eax
  8036c3:	e8 a6 f3 ff ff       	call   802a6e <fd_alloc>
  8036c8:	89 c3                	mov    %eax,%ebx
  8036ca:	83 c4 10             	add    $0x10,%esp
  8036cd:	85 c0                	test   %eax,%eax
  8036cf:	78 43                	js     803714 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8036d1:	83 ec 04             	sub    $0x4,%esp
  8036d4:	68 07 04 00 00       	push   $0x407
  8036d9:	ff 75 f4             	pushl  -0xc(%ebp)
  8036dc:	6a 00                	push   $0x0
  8036de:	e8 ba ef ff ff       	call   80269d <sys_page_alloc>
  8036e3:	89 c3                	mov    %eax,%ebx
  8036e5:	83 c4 10             	add    $0x10,%esp
  8036e8:	85 c0                	test   %eax,%eax
  8036ea:	78 28                	js     803714 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  8036ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036ef:	8b 15 9c 90 80 00    	mov    0x80909c,%edx
  8036f5:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8036f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036fa:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  803701:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  803704:	83 ec 0c             	sub    $0xc,%esp
  803707:	50                   	push   %eax
  803708:	e8 3a f3 ff ff       	call   802a47 <fd2num>
  80370d:	89 c3                	mov    %eax,%ebx
  80370f:	83 c4 10             	add    $0x10,%esp
  803712:	eb 0c                	jmp    803720 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  803714:	83 ec 0c             	sub    $0xc,%esp
  803717:	56                   	push   %esi
  803718:	e8 e2 01 00 00       	call   8038ff <nsipc_close>
		return r;
  80371d:	83 c4 10             	add    $0x10,%esp
}
  803720:	89 d8                	mov    %ebx,%eax
  803722:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803725:	5b                   	pop    %ebx
  803726:	5e                   	pop    %esi
  803727:	5d                   	pop    %ebp
  803728:	c3                   	ret    

00803729 <accept>:
{
  803729:	55                   	push   %ebp
  80372a:	89 e5                	mov    %esp,%ebp
  80372c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80372f:	8b 45 08             	mov    0x8(%ebp),%eax
  803732:	e8 4e ff ff ff       	call   803685 <fd2sockid>
  803737:	85 c0                	test   %eax,%eax
  803739:	78 1b                	js     803756 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80373b:	83 ec 04             	sub    $0x4,%esp
  80373e:	ff 75 10             	pushl  0x10(%ebp)
  803741:	ff 75 0c             	pushl  0xc(%ebp)
  803744:	50                   	push   %eax
  803745:	e8 0e 01 00 00       	call   803858 <nsipc_accept>
  80374a:	83 c4 10             	add    $0x10,%esp
  80374d:	85 c0                	test   %eax,%eax
  80374f:	78 05                	js     803756 <accept+0x2d>
	return alloc_sockfd(r);
  803751:	e8 5f ff ff ff       	call   8036b5 <alloc_sockfd>
}
  803756:	c9                   	leave  
  803757:	c3                   	ret    

00803758 <bind>:
{
  803758:	55                   	push   %ebp
  803759:	89 e5                	mov    %esp,%ebp
  80375b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80375e:	8b 45 08             	mov    0x8(%ebp),%eax
  803761:	e8 1f ff ff ff       	call   803685 <fd2sockid>
  803766:	85 c0                	test   %eax,%eax
  803768:	78 12                	js     80377c <bind+0x24>
	return nsipc_bind(r, name, namelen);
  80376a:	83 ec 04             	sub    $0x4,%esp
  80376d:	ff 75 10             	pushl  0x10(%ebp)
  803770:	ff 75 0c             	pushl  0xc(%ebp)
  803773:	50                   	push   %eax
  803774:	e8 2f 01 00 00       	call   8038a8 <nsipc_bind>
  803779:	83 c4 10             	add    $0x10,%esp
}
  80377c:	c9                   	leave  
  80377d:	c3                   	ret    

0080377e <shutdown>:
{
  80377e:	55                   	push   %ebp
  80377f:	89 e5                	mov    %esp,%ebp
  803781:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  803784:	8b 45 08             	mov    0x8(%ebp),%eax
  803787:	e8 f9 fe ff ff       	call   803685 <fd2sockid>
  80378c:	85 c0                	test   %eax,%eax
  80378e:	78 0f                	js     80379f <shutdown+0x21>
	return nsipc_shutdown(r, how);
  803790:	83 ec 08             	sub    $0x8,%esp
  803793:	ff 75 0c             	pushl  0xc(%ebp)
  803796:	50                   	push   %eax
  803797:	e8 41 01 00 00       	call   8038dd <nsipc_shutdown>
  80379c:	83 c4 10             	add    $0x10,%esp
}
  80379f:	c9                   	leave  
  8037a0:	c3                   	ret    

008037a1 <connect>:
{
  8037a1:	55                   	push   %ebp
  8037a2:	89 e5                	mov    %esp,%ebp
  8037a4:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8037a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8037aa:	e8 d6 fe ff ff       	call   803685 <fd2sockid>
  8037af:	85 c0                	test   %eax,%eax
  8037b1:	78 12                	js     8037c5 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8037b3:	83 ec 04             	sub    $0x4,%esp
  8037b6:	ff 75 10             	pushl  0x10(%ebp)
  8037b9:	ff 75 0c             	pushl  0xc(%ebp)
  8037bc:	50                   	push   %eax
  8037bd:	e8 57 01 00 00       	call   803919 <nsipc_connect>
  8037c2:	83 c4 10             	add    $0x10,%esp
}
  8037c5:	c9                   	leave  
  8037c6:	c3                   	ret    

008037c7 <listen>:
{
  8037c7:	55                   	push   %ebp
  8037c8:	89 e5                	mov    %esp,%ebp
  8037ca:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8037cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8037d0:	e8 b0 fe ff ff       	call   803685 <fd2sockid>
  8037d5:	85 c0                	test   %eax,%eax
  8037d7:	78 0f                	js     8037e8 <listen+0x21>
	return nsipc_listen(r, backlog);
  8037d9:	83 ec 08             	sub    $0x8,%esp
  8037dc:	ff 75 0c             	pushl  0xc(%ebp)
  8037df:	50                   	push   %eax
  8037e0:	e8 69 01 00 00       	call   80394e <nsipc_listen>
  8037e5:	83 c4 10             	add    $0x10,%esp
}
  8037e8:	c9                   	leave  
  8037e9:	c3                   	ret    

008037ea <socket>:

int
socket(int domain, int type, int protocol)
{
  8037ea:	55                   	push   %ebp
  8037eb:	89 e5                	mov    %esp,%ebp
  8037ed:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8037f0:	ff 75 10             	pushl  0x10(%ebp)
  8037f3:	ff 75 0c             	pushl  0xc(%ebp)
  8037f6:	ff 75 08             	pushl  0x8(%ebp)
  8037f9:	e8 3c 02 00 00       	call   803a3a <nsipc_socket>
  8037fe:	83 c4 10             	add    $0x10,%esp
  803801:	85 c0                	test   %eax,%eax
  803803:	78 05                	js     80380a <socket+0x20>
		return r;
	return alloc_sockfd(r);
  803805:	e8 ab fe ff ff       	call   8036b5 <alloc_sockfd>
}
  80380a:	c9                   	leave  
  80380b:	c3                   	ret    

0080380c <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80380c:	55                   	push   %ebp
  80380d:	89 e5                	mov    %esp,%ebp
  80380f:	53                   	push   %ebx
  803810:	83 ec 04             	sub    $0x4,%esp
  803813:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  803815:	83 3d 04 a0 80 00 00 	cmpl   $0x0,0x80a004
  80381c:	74 26                	je     803844 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80381e:	6a 07                	push   $0x7
  803820:	68 00 c0 80 00       	push   $0x80c000
  803825:	53                   	push   %ebx
  803826:	ff 35 04 a0 80 00    	pushl  0x80a004
  80382c:	e8 84 f1 ff ff       	call   8029b5 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  803831:	83 c4 0c             	add    $0xc,%esp
  803834:	6a 00                	push   $0x0
  803836:	6a 00                	push   $0x0
  803838:	6a 00                	push   $0x0
  80383a:	e8 0d f1 ff ff       	call   80294c <ipc_recv>
}
  80383f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803842:	c9                   	leave  
  803843:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803844:	83 ec 0c             	sub    $0xc,%esp
  803847:	6a 02                	push   $0x2
  803849:	e8 c0 f1 ff ff       	call   802a0e <ipc_find_env>
  80384e:	a3 04 a0 80 00       	mov    %eax,0x80a004
  803853:	83 c4 10             	add    $0x10,%esp
  803856:	eb c6                	jmp    80381e <nsipc+0x12>

00803858 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803858:	55                   	push   %ebp
  803859:	89 e5                	mov    %esp,%ebp
  80385b:	56                   	push   %esi
  80385c:	53                   	push   %ebx
  80385d:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  803860:	8b 45 08             	mov    0x8(%ebp),%eax
  803863:	a3 00 c0 80 00       	mov    %eax,0x80c000
	nsipcbuf.accept.req_addrlen = *addrlen;
  803868:	8b 06                	mov    (%esi),%eax
  80386a:	a3 04 c0 80 00       	mov    %eax,0x80c004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80386f:	b8 01 00 00 00       	mov    $0x1,%eax
  803874:	e8 93 ff ff ff       	call   80380c <nsipc>
  803879:	89 c3                	mov    %eax,%ebx
  80387b:	85 c0                	test   %eax,%eax
  80387d:	78 20                	js     80389f <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80387f:	83 ec 04             	sub    $0x4,%esp
  803882:	ff 35 10 c0 80 00    	pushl  0x80c010
  803888:	68 00 c0 80 00       	push   $0x80c000
  80388d:	ff 75 0c             	pushl  0xc(%ebp)
  803890:	e8 9d eb ff ff       	call   802432 <memmove>
		*addrlen = ret->ret_addrlen;
  803895:	a1 10 c0 80 00       	mov    0x80c010,%eax
  80389a:	89 06                	mov    %eax,(%esi)
  80389c:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  80389f:	89 d8                	mov    %ebx,%eax
  8038a1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8038a4:	5b                   	pop    %ebx
  8038a5:	5e                   	pop    %esi
  8038a6:	5d                   	pop    %ebp
  8038a7:	c3                   	ret    

008038a8 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8038a8:	55                   	push   %ebp
  8038a9:	89 e5                	mov    %esp,%ebp
  8038ab:	53                   	push   %ebx
  8038ac:	83 ec 08             	sub    $0x8,%esp
  8038af:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8038b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8038b5:	a3 00 c0 80 00       	mov    %eax,0x80c000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8038ba:	53                   	push   %ebx
  8038bb:	ff 75 0c             	pushl  0xc(%ebp)
  8038be:	68 04 c0 80 00       	push   $0x80c004
  8038c3:	e8 6a eb ff ff       	call   802432 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8038c8:	89 1d 14 c0 80 00    	mov    %ebx,0x80c014
	return nsipc(NSREQ_BIND);
  8038ce:	b8 02 00 00 00       	mov    $0x2,%eax
  8038d3:	e8 34 ff ff ff       	call   80380c <nsipc>
}
  8038d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8038db:	c9                   	leave  
  8038dc:	c3                   	ret    

008038dd <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8038dd:	55                   	push   %ebp
  8038de:	89 e5                	mov    %esp,%ebp
  8038e0:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8038e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8038e6:	a3 00 c0 80 00       	mov    %eax,0x80c000
	nsipcbuf.shutdown.req_how = how;
  8038eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038ee:	a3 04 c0 80 00       	mov    %eax,0x80c004
	return nsipc(NSREQ_SHUTDOWN);
  8038f3:	b8 03 00 00 00       	mov    $0x3,%eax
  8038f8:	e8 0f ff ff ff       	call   80380c <nsipc>
}
  8038fd:	c9                   	leave  
  8038fe:	c3                   	ret    

008038ff <nsipc_close>:

int
nsipc_close(int s)
{
  8038ff:	55                   	push   %ebp
  803900:	89 e5                	mov    %esp,%ebp
  803902:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  803905:	8b 45 08             	mov    0x8(%ebp),%eax
  803908:	a3 00 c0 80 00       	mov    %eax,0x80c000
	return nsipc(NSREQ_CLOSE);
  80390d:	b8 04 00 00 00       	mov    $0x4,%eax
  803912:	e8 f5 fe ff ff       	call   80380c <nsipc>
}
  803917:	c9                   	leave  
  803918:	c3                   	ret    

00803919 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803919:	55                   	push   %ebp
  80391a:	89 e5                	mov    %esp,%ebp
  80391c:	53                   	push   %ebx
  80391d:	83 ec 08             	sub    $0x8,%esp
  803920:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  803923:	8b 45 08             	mov    0x8(%ebp),%eax
  803926:	a3 00 c0 80 00       	mov    %eax,0x80c000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80392b:	53                   	push   %ebx
  80392c:	ff 75 0c             	pushl  0xc(%ebp)
  80392f:	68 04 c0 80 00       	push   $0x80c004
  803934:	e8 f9 ea ff ff       	call   802432 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  803939:	89 1d 14 c0 80 00    	mov    %ebx,0x80c014
	return nsipc(NSREQ_CONNECT);
  80393f:	b8 05 00 00 00       	mov    $0x5,%eax
  803944:	e8 c3 fe ff ff       	call   80380c <nsipc>
}
  803949:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80394c:	c9                   	leave  
  80394d:	c3                   	ret    

0080394e <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80394e:	55                   	push   %ebp
  80394f:	89 e5                	mov    %esp,%ebp
  803951:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  803954:	8b 45 08             	mov    0x8(%ebp),%eax
  803957:	a3 00 c0 80 00       	mov    %eax,0x80c000
	nsipcbuf.listen.req_backlog = backlog;
  80395c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80395f:	a3 04 c0 80 00       	mov    %eax,0x80c004
	return nsipc(NSREQ_LISTEN);
  803964:	b8 06 00 00 00       	mov    $0x6,%eax
  803969:	e8 9e fe ff ff       	call   80380c <nsipc>
}
  80396e:	c9                   	leave  
  80396f:	c3                   	ret    

00803970 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803970:	55                   	push   %ebp
  803971:	89 e5                	mov    %esp,%ebp
  803973:	56                   	push   %esi
  803974:	53                   	push   %ebx
  803975:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  803978:	8b 45 08             	mov    0x8(%ebp),%eax
  80397b:	a3 00 c0 80 00       	mov    %eax,0x80c000
	nsipcbuf.recv.req_len = len;
  803980:	89 35 04 c0 80 00    	mov    %esi,0x80c004
	nsipcbuf.recv.req_flags = flags;
  803986:	8b 45 14             	mov    0x14(%ebp),%eax
  803989:	a3 08 c0 80 00       	mov    %eax,0x80c008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80398e:	b8 07 00 00 00       	mov    $0x7,%eax
  803993:	e8 74 fe ff ff       	call   80380c <nsipc>
  803998:	89 c3                	mov    %eax,%ebx
  80399a:	85 c0                	test   %eax,%eax
  80399c:	78 1f                	js     8039bd <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  80399e:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8039a3:	7f 21                	jg     8039c6 <nsipc_recv+0x56>
  8039a5:	39 c6                	cmp    %eax,%esi
  8039a7:	7c 1d                	jl     8039c6 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8039a9:	83 ec 04             	sub    $0x4,%esp
  8039ac:	50                   	push   %eax
  8039ad:	68 00 c0 80 00       	push   $0x80c000
  8039b2:	ff 75 0c             	pushl  0xc(%ebp)
  8039b5:	e8 78 ea ff ff       	call   802432 <memmove>
  8039ba:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8039bd:	89 d8                	mov    %ebx,%eax
  8039bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8039c2:	5b                   	pop    %ebx
  8039c3:	5e                   	pop    %esi
  8039c4:	5d                   	pop    %ebp
  8039c5:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8039c6:	68 31 48 80 00       	push   $0x804831
  8039cb:	68 7d 3e 80 00       	push   $0x803e7d
  8039d0:	6a 62                	push   $0x62
  8039d2:	68 46 48 80 00       	push   $0x804846
  8039d7:	e8 50 e1 ff ff       	call   801b2c <_panic>

008039dc <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8039dc:	55                   	push   %ebp
  8039dd:	89 e5                	mov    %esp,%ebp
  8039df:	53                   	push   %ebx
  8039e0:	83 ec 04             	sub    $0x4,%esp
  8039e3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8039e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8039e9:	a3 00 c0 80 00       	mov    %eax,0x80c000
	assert(size < 1600);
  8039ee:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8039f4:	7f 2e                	jg     803a24 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8039f6:	83 ec 04             	sub    $0x4,%esp
  8039f9:	53                   	push   %ebx
  8039fa:	ff 75 0c             	pushl  0xc(%ebp)
  8039fd:	68 0c c0 80 00       	push   $0x80c00c
  803a02:	e8 2b ea ff ff       	call   802432 <memmove>
	nsipcbuf.send.req_size = size;
  803a07:	89 1d 04 c0 80 00    	mov    %ebx,0x80c004
	nsipcbuf.send.req_flags = flags;
  803a0d:	8b 45 14             	mov    0x14(%ebp),%eax
  803a10:	a3 08 c0 80 00       	mov    %eax,0x80c008
	return nsipc(NSREQ_SEND);
  803a15:	b8 08 00 00 00       	mov    $0x8,%eax
  803a1a:	e8 ed fd ff ff       	call   80380c <nsipc>
}
  803a1f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803a22:	c9                   	leave  
  803a23:	c3                   	ret    
	assert(size < 1600);
  803a24:	68 52 48 80 00       	push   $0x804852
  803a29:	68 7d 3e 80 00       	push   $0x803e7d
  803a2e:	6a 6d                	push   $0x6d
  803a30:	68 46 48 80 00       	push   $0x804846
  803a35:	e8 f2 e0 ff ff       	call   801b2c <_panic>

00803a3a <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803a3a:	55                   	push   %ebp
  803a3b:	89 e5                	mov    %esp,%ebp
  803a3d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  803a40:	8b 45 08             	mov    0x8(%ebp),%eax
  803a43:	a3 00 c0 80 00       	mov    %eax,0x80c000
	nsipcbuf.socket.req_type = type;
  803a48:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a4b:	a3 04 c0 80 00       	mov    %eax,0x80c004
	nsipcbuf.socket.req_protocol = protocol;
  803a50:	8b 45 10             	mov    0x10(%ebp),%eax
  803a53:	a3 08 c0 80 00       	mov    %eax,0x80c008
	return nsipc(NSREQ_SOCKET);
  803a58:	b8 09 00 00 00       	mov    $0x9,%eax
  803a5d:	e8 aa fd ff ff       	call   80380c <nsipc>
}
  803a62:	c9                   	leave  
  803a63:	c3                   	ret    

00803a64 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  803a64:	55                   	push   %ebp
  803a65:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  803a67:	b8 00 00 00 00       	mov    $0x0,%eax
  803a6c:	5d                   	pop    %ebp
  803a6d:	c3                   	ret    

00803a6e <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803a6e:	55                   	push   %ebp
  803a6f:	89 e5                	mov    %esp,%ebp
  803a71:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  803a74:	68 5e 48 80 00       	push   $0x80485e
  803a79:	ff 75 0c             	pushl  0xc(%ebp)
  803a7c:	e8 23 e8 ff ff       	call   8022a4 <strcpy>
	return 0;
}
  803a81:	b8 00 00 00 00       	mov    $0x0,%eax
  803a86:	c9                   	leave  
  803a87:	c3                   	ret    

00803a88 <devcons_write>:
{
  803a88:	55                   	push   %ebp
  803a89:	89 e5                	mov    %esp,%ebp
  803a8b:	57                   	push   %edi
  803a8c:	56                   	push   %esi
  803a8d:	53                   	push   %ebx
  803a8e:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  803a94:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  803a99:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  803a9f:	eb 2f                	jmp    803ad0 <devcons_write+0x48>
		m = n - tot;
  803aa1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  803aa4:	29 f3                	sub    %esi,%ebx
  803aa6:	83 fb 7f             	cmp    $0x7f,%ebx
  803aa9:	b8 7f 00 00 00       	mov    $0x7f,%eax
  803aae:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  803ab1:	83 ec 04             	sub    $0x4,%esp
  803ab4:	53                   	push   %ebx
  803ab5:	89 f0                	mov    %esi,%eax
  803ab7:	03 45 0c             	add    0xc(%ebp),%eax
  803aba:	50                   	push   %eax
  803abb:	57                   	push   %edi
  803abc:	e8 71 e9 ff ff       	call   802432 <memmove>
		sys_cputs(buf, m);
  803ac1:	83 c4 08             	add    $0x8,%esp
  803ac4:	53                   	push   %ebx
  803ac5:	57                   	push   %edi
  803ac6:	e8 16 eb ff ff       	call   8025e1 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  803acb:	01 de                	add    %ebx,%esi
  803acd:	83 c4 10             	add    $0x10,%esp
  803ad0:	3b 75 10             	cmp    0x10(%ebp),%esi
  803ad3:	72 cc                	jb     803aa1 <devcons_write+0x19>
}
  803ad5:	89 f0                	mov    %esi,%eax
  803ad7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  803ada:	5b                   	pop    %ebx
  803adb:	5e                   	pop    %esi
  803adc:	5f                   	pop    %edi
  803add:	5d                   	pop    %ebp
  803ade:	c3                   	ret    

00803adf <devcons_read>:
{
  803adf:	55                   	push   %ebp
  803ae0:	89 e5                	mov    %esp,%ebp
  803ae2:	83 ec 08             	sub    $0x8,%esp
  803ae5:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  803aea:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  803aee:	75 07                	jne    803af7 <devcons_read+0x18>
}
  803af0:	c9                   	leave  
  803af1:	c3                   	ret    
		sys_yield();
  803af2:	e8 87 eb ff ff       	call   80267e <sys_yield>
	while ((c = sys_cgetc()) == 0)
  803af7:	e8 03 eb ff ff       	call   8025ff <sys_cgetc>
  803afc:	85 c0                	test   %eax,%eax
  803afe:	74 f2                	je     803af2 <devcons_read+0x13>
	if (c < 0)
  803b00:	85 c0                	test   %eax,%eax
  803b02:	78 ec                	js     803af0 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  803b04:	83 f8 04             	cmp    $0x4,%eax
  803b07:	74 0c                	je     803b15 <devcons_read+0x36>
	*(char*)vbuf = c;
  803b09:	8b 55 0c             	mov    0xc(%ebp),%edx
  803b0c:	88 02                	mov    %al,(%edx)
	return 1;
  803b0e:	b8 01 00 00 00       	mov    $0x1,%eax
  803b13:	eb db                	jmp    803af0 <devcons_read+0x11>
		return 0;
  803b15:	b8 00 00 00 00       	mov    $0x0,%eax
  803b1a:	eb d4                	jmp    803af0 <devcons_read+0x11>

00803b1c <cputchar>:
{
  803b1c:	55                   	push   %ebp
  803b1d:	89 e5                	mov    %esp,%ebp
  803b1f:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  803b22:	8b 45 08             	mov    0x8(%ebp),%eax
  803b25:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  803b28:	6a 01                	push   $0x1
  803b2a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  803b2d:	50                   	push   %eax
  803b2e:	e8 ae ea ff ff       	call   8025e1 <sys_cputs>
}
  803b33:	83 c4 10             	add    $0x10,%esp
  803b36:	c9                   	leave  
  803b37:	c3                   	ret    

00803b38 <getchar>:
{
  803b38:	55                   	push   %ebp
  803b39:	89 e5                	mov    %esp,%ebp
  803b3b:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  803b3e:	6a 01                	push   $0x1
  803b40:	8d 45 f7             	lea    -0x9(%ebp),%eax
  803b43:	50                   	push   %eax
  803b44:	6a 00                	push   $0x0
  803b46:	e8 e3 f1 ff ff       	call   802d2e <read>
	if (r < 0)
  803b4b:	83 c4 10             	add    $0x10,%esp
  803b4e:	85 c0                	test   %eax,%eax
  803b50:	78 08                	js     803b5a <getchar+0x22>
	if (r < 1)
  803b52:	85 c0                	test   %eax,%eax
  803b54:	7e 06                	jle    803b5c <getchar+0x24>
	return c;
  803b56:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  803b5a:	c9                   	leave  
  803b5b:	c3                   	ret    
		return -E_EOF;
  803b5c:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  803b61:	eb f7                	jmp    803b5a <getchar+0x22>

00803b63 <iscons>:
{
  803b63:	55                   	push   %ebp
  803b64:	89 e5                	mov    %esp,%ebp
  803b66:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803b69:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803b6c:	50                   	push   %eax
  803b6d:	ff 75 08             	pushl  0x8(%ebp)
  803b70:	e8 48 ef ff ff       	call   802abd <fd_lookup>
  803b75:	83 c4 10             	add    $0x10,%esp
  803b78:	85 c0                	test   %eax,%eax
  803b7a:	78 11                	js     803b8d <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  803b7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b7f:	8b 15 b8 90 80 00    	mov    0x8090b8,%edx
  803b85:	39 10                	cmp    %edx,(%eax)
  803b87:	0f 94 c0             	sete   %al
  803b8a:	0f b6 c0             	movzbl %al,%eax
}
  803b8d:	c9                   	leave  
  803b8e:	c3                   	ret    

00803b8f <opencons>:
{
  803b8f:	55                   	push   %ebp
  803b90:	89 e5                	mov    %esp,%ebp
  803b92:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  803b95:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803b98:	50                   	push   %eax
  803b99:	e8 d0 ee ff ff       	call   802a6e <fd_alloc>
  803b9e:	83 c4 10             	add    $0x10,%esp
  803ba1:	85 c0                	test   %eax,%eax
  803ba3:	78 3a                	js     803bdf <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803ba5:	83 ec 04             	sub    $0x4,%esp
  803ba8:	68 07 04 00 00       	push   $0x407
  803bad:	ff 75 f4             	pushl  -0xc(%ebp)
  803bb0:	6a 00                	push   $0x0
  803bb2:	e8 e6 ea ff ff       	call   80269d <sys_page_alloc>
  803bb7:	83 c4 10             	add    $0x10,%esp
  803bba:	85 c0                	test   %eax,%eax
  803bbc:	78 21                	js     803bdf <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  803bbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bc1:	8b 15 b8 90 80 00    	mov    0x8090b8,%edx
  803bc7:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  803bc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bcc:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  803bd3:	83 ec 0c             	sub    $0xc,%esp
  803bd6:	50                   	push   %eax
  803bd7:	e8 6b ee ff ff       	call   802a47 <fd2num>
  803bdc:	83 c4 10             	add    $0x10,%esp
}
  803bdf:	c9                   	leave  
  803be0:	c3                   	ret    
  803be1:	66 90                	xchg   %ax,%ax
  803be3:	66 90                	xchg   %ax,%ax
  803be5:	66 90                	xchg   %ax,%ax
  803be7:	66 90                	xchg   %ax,%ax
  803be9:	66 90                	xchg   %ax,%ax
  803beb:	66 90                	xchg   %ax,%ax
  803bed:	66 90                	xchg   %ax,%ax
  803bef:	90                   	nop

00803bf0 <__udivdi3>:
  803bf0:	55                   	push   %ebp
  803bf1:	57                   	push   %edi
  803bf2:	56                   	push   %esi
  803bf3:	53                   	push   %ebx
  803bf4:	83 ec 1c             	sub    $0x1c,%esp
  803bf7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  803bfb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  803bff:	8b 74 24 34          	mov    0x34(%esp),%esi
  803c03:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  803c07:	85 d2                	test   %edx,%edx
  803c09:	75 35                	jne    803c40 <__udivdi3+0x50>
  803c0b:	39 f3                	cmp    %esi,%ebx
  803c0d:	0f 87 bd 00 00 00    	ja     803cd0 <__udivdi3+0xe0>
  803c13:	85 db                	test   %ebx,%ebx
  803c15:	89 d9                	mov    %ebx,%ecx
  803c17:	75 0b                	jne    803c24 <__udivdi3+0x34>
  803c19:	b8 01 00 00 00       	mov    $0x1,%eax
  803c1e:	31 d2                	xor    %edx,%edx
  803c20:	f7 f3                	div    %ebx
  803c22:	89 c1                	mov    %eax,%ecx
  803c24:	31 d2                	xor    %edx,%edx
  803c26:	89 f0                	mov    %esi,%eax
  803c28:	f7 f1                	div    %ecx
  803c2a:	89 c6                	mov    %eax,%esi
  803c2c:	89 e8                	mov    %ebp,%eax
  803c2e:	89 f7                	mov    %esi,%edi
  803c30:	f7 f1                	div    %ecx
  803c32:	89 fa                	mov    %edi,%edx
  803c34:	83 c4 1c             	add    $0x1c,%esp
  803c37:	5b                   	pop    %ebx
  803c38:	5e                   	pop    %esi
  803c39:	5f                   	pop    %edi
  803c3a:	5d                   	pop    %ebp
  803c3b:	c3                   	ret    
  803c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803c40:	39 f2                	cmp    %esi,%edx
  803c42:	77 7c                	ja     803cc0 <__udivdi3+0xd0>
  803c44:	0f bd fa             	bsr    %edx,%edi
  803c47:	83 f7 1f             	xor    $0x1f,%edi
  803c4a:	0f 84 98 00 00 00    	je     803ce8 <__udivdi3+0xf8>
  803c50:	89 f9                	mov    %edi,%ecx
  803c52:	b8 20 00 00 00       	mov    $0x20,%eax
  803c57:	29 f8                	sub    %edi,%eax
  803c59:	d3 e2                	shl    %cl,%edx
  803c5b:	89 54 24 08          	mov    %edx,0x8(%esp)
  803c5f:	89 c1                	mov    %eax,%ecx
  803c61:	89 da                	mov    %ebx,%edx
  803c63:	d3 ea                	shr    %cl,%edx
  803c65:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  803c69:	09 d1                	or     %edx,%ecx
  803c6b:	89 f2                	mov    %esi,%edx
  803c6d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803c71:	89 f9                	mov    %edi,%ecx
  803c73:	d3 e3                	shl    %cl,%ebx
  803c75:	89 c1                	mov    %eax,%ecx
  803c77:	d3 ea                	shr    %cl,%edx
  803c79:	89 f9                	mov    %edi,%ecx
  803c7b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  803c7f:	d3 e6                	shl    %cl,%esi
  803c81:	89 eb                	mov    %ebp,%ebx
  803c83:	89 c1                	mov    %eax,%ecx
  803c85:	d3 eb                	shr    %cl,%ebx
  803c87:	09 de                	or     %ebx,%esi
  803c89:	89 f0                	mov    %esi,%eax
  803c8b:	f7 74 24 08          	divl   0x8(%esp)
  803c8f:	89 d6                	mov    %edx,%esi
  803c91:	89 c3                	mov    %eax,%ebx
  803c93:	f7 64 24 0c          	mull   0xc(%esp)
  803c97:	39 d6                	cmp    %edx,%esi
  803c99:	72 0c                	jb     803ca7 <__udivdi3+0xb7>
  803c9b:	89 f9                	mov    %edi,%ecx
  803c9d:	d3 e5                	shl    %cl,%ebp
  803c9f:	39 c5                	cmp    %eax,%ebp
  803ca1:	73 5d                	jae    803d00 <__udivdi3+0x110>
  803ca3:	39 d6                	cmp    %edx,%esi
  803ca5:	75 59                	jne    803d00 <__udivdi3+0x110>
  803ca7:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803caa:	31 ff                	xor    %edi,%edi
  803cac:	89 fa                	mov    %edi,%edx
  803cae:	83 c4 1c             	add    $0x1c,%esp
  803cb1:	5b                   	pop    %ebx
  803cb2:	5e                   	pop    %esi
  803cb3:	5f                   	pop    %edi
  803cb4:	5d                   	pop    %ebp
  803cb5:	c3                   	ret    
  803cb6:	8d 76 00             	lea    0x0(%esi),%esi
  803cb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  803cc0:	31 ff                	xor    %edi,%edi
  803cc2:	31 c0                	xor    %eax,%eax
  803cc4:	89 fa                	mov    %edi,%edx
  803cc6:	83 c4 1c             	add    $0x1c,%esp
  803cc9:	5b                   	pop    %ebx
  803cca:	5e                   	pop    %esi
  803ccb:	5f                   	pop    %edi
  803ccc:	5d                   	pop    %ebp
  803ccd:	c3                   	ret    
  803cce:	66 90                	xchg   %ax,%ax
  803cd0:	31 ff                	xor    %edi,%edi
  803cd2:	89 e8                	mov    %ebp,%eax
  803cd4:	89 f2                	mov    %esi,%edx
  803cd6:	f7 f3                	div    %ebx
  803cd8:	89 fa                	mov    %edi,%edx
  803cda:	83 c4 1c             	add    $0x1c,%esp
  803cdd:	5b                   	pop    %ebx
  803cde:	5e                   	pop    %esi
  803cdf:	5f                   	pop    %edi
  803ce0:	5d                   	pop    %ebp
  803ce1:	c3                   	ret    
  803ce2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  803ce8:	39 f2                	cmp    %esi,%edx
  803cea:	72 06                	jb     803cf2 <__udivdi3+0x102>
  803cec:	31 c0                	xor    %eax,%eax
  803cee:	39 eb                	cmp    %ebp,%ebx
  803cf0:	77 d2                	ja     803cc4 <__udivdi3+0xd4>
  803cf2:	b8 01 00 00 00       	mov    $0x1,%eax
  803cf7:	eb cb                	jmp    803cc4 <__udivdi3+0xd4>
  803cf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803d00:	89 d8                	mov    %ebx,%eax
  803d02:	31 ff                	xor    %edi,%edi
  803d04:	eb be                	jmp    803cc4 <__udivdi3+0xd4>
  803d06:	66 90                	xchg   %ax,%ax
  803d08:	66 90                	xchg   %ax,%ax
  803d0a:	66 90                	xchg   %ax,%ax
  803d0c:	66 90                	xchg   %ax,%ax
  803d0e:	66 90                	xchg   %ax,%ax

00803d10 <__umoddi3>:
  803d10:	55                   	push   %ebp
  803d11:	57                   	push   %edi
  803d12:	56                   	push   %esi
  803d13:	53                   	push   %ebx
  803d14:	83 ec 1c             	sub    $0x1c,%esp
  803d17:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  803d1b:	8b 74 24 30          	mov    0x30(%esp),%esi
  803d1f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  803d23:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803d27:	85 ed                	test   %ebp,%ebp
  803d29:	89 f0                	mov    %esi,%eax
  803d2b:	89 da                	mov    %ebx,%edx
  803d2d:	75 19                	jne    803d48 <__umoddi3+0x38>
  803d2f:	39 df                	cmp    %ebx,%edi
  803d31:	0f 86 b1 00 00 00    	jbe    803de8 <__umoddi3+0xd8>
  803d37:	f7 f7                	div    %edi
  803d39:	89 d0                	mov    %edx,%eax
  803d3b:	31 d2                	xor    %edx,%edx
  803d3d:	83 c4 1c             	add    $0x1c,%esp
  803d40:	5b                   	pop    %ebx
  803d41:	5e                   	pop    %esi
  803d42:	5f                   	pop    %edi
  803d43:	5d                   	pop    %ebp
  803d44:	c3                   	ret    
  803d45:	8d 76 00             	lea    0x0(%esi),%esi
  803d48:	39 dd                	cmp    %ebx,%ebp
  803d4a:	77 f1                	ja     803d3d <__umoddi3+0x2d>
  803d4c:	0f bd cd             	bsr    %ebp,%ecx
  803d4f:	83 f1 1f             	xor    $0x1f,%ecx
  803d52:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d56:	0f 84 b4 00 00 00    	je     803e10 <__umoddi3+0x100>
  803d5c:	b8 20 00 00 00       	mov    $0x20,%eax
  803d61:	89 c2                	mov    %eax,%edx
  803d63:	8b 44 24 04          	mov    0x4(%esp),%eax
  803d67:	29 c2                	sub    %eax,%edx
  803d69:	89 c1                	mov    %eax,%ecx
  803d6b:	89 f8                	mov    %edi,%eax
  803d6d:	d3 e5                	shl    %cl,%ebp
  803d6f:	89 d1                	mov    %edx,%ecx
  803d71:	89 54 24 0c          	mov    %edx,0xc(%esp)
  803d75:	d3 e8                	shr    %cl,%eax
  803d77:	09 c5                	or     %eax,%ebp
  803d79:	8b 44 24 04          	mov    0x4(%esp),%eax
  803d7d:	89 c1                	mov    %eax,%ecx
  803d7f:	d3 e7                	shl    %cl,%edi
  803d81:	89 d1                	mov    %edx,%ecx
  803d83:	89 7c 24 08          	mov    %edi,0x8(%esp)
  803d87:	89 df                	mov    %ebx,%edi
  803d89:	d3 ef                	shr    %cl,%edi
  803d8b:	89 c1                	mov    %eax,%ecx
  803d8d:	89 f0                	mov    %esi,%eax
  803d8f:	d3 e3                	shl    %cl,%ebx
  803d91:	89 d1                	mov    %edx,%ecx
  803d93:	89 fa                	mov    %edi,%edx
  803d95:	d3 e8                	shr    %cl,%eax
  803d97:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  803d9c:	09 d8                	or     %ebx,%eax
  803d9e:	f7 f5                	div    %ebp
  803da0:	d3 e6                	shl    %cl,%esi
  803da2:	89 d1                	mov    %edx,%ecx
  803da4:	f7 64 24 08          	mull   0x8(%esp)
  803da8:	39 d1                	cmp    %edx,%ecx
  803daa:	89 c3                	mov    %eax,%ebx
  803dac:	89 d7                	mov    %edx,%edi
  803dae:	72 06                	jb     803db6 <__umoddi3+0xa6>
  803db0:	75 0e                	jne    803dc0 <__umoddi3+0xb0>
  803db2:	39 c6                	cmp    %eax,%esi
  803db4:	73 0a                	jae    803dc0 <__umoddi3+0xb0>
  803db6:	2b 44 24 08          	sub    0x8(%esp),%eax
  803dba:	19 ea                	sbb    %ebp,%edx
  803dbc:	89 d7                	mov    %edx,%edi
  803dbe:	89 c3                	mov    %eax,%ebx
  803dc0:	89 ca                	mov    %ecx,%edx
  803dc2:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  803dc7:	29 de                	sub    %ebx,%esi
  803dc9:	19 fa                	sbb    %edi,%edx
  803dcb:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  803dcf:	89 d0                	mov    %edx,%eax
  803dd1:	d3 e0                	shl    %cl,%eax
  803dd3:	89 d9                	mov    %ebx,%ecx
  803dd5:	d3 ee                	shr    %cl,%esi
  803dd7:	d3 ea                	shr    %cl,%edx
  803dd9:	09 f0                	or     %esi,%eax
  803ddb:	83 c4 1c             	add    $0x1c,%esp
  803dde:	5b                   	pop    %ebx
  803ddf:	5e                   	pop    %esi
  803de0:	5f                   	pop    %edi
  803de1:	5d                   	pop    %ebp
  803de2:	c3                   	ret    
  803de3:	90                   	nop
  803de4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803de8:	85 ff                	test   %edi,%edi
  803dea:	89 f9                	mov    %edi,%ecx
  803dec:	75 0b                	jne    803df9 <__umoddi3+0xe9>
  803dee:	b8 01 00 00 00       	mov    $0x1,%eax
  803df3:	31 d2                	xor    %edx,%edx
  803df5:	f7 f7                	div    %edi
  803df7:	89 c1                	mov    %eax,%ecx
  803df9:	89 d8                	mov    %ebx,%eax
  803dfb:	31 d2                	xor    %edx,%edx
  803dfd:	f7 f1                	div    %ecx
  803dff:	89 f0                	mov    %esi,%eax
  803e01:	f7 f1                	div    %ecx
  803e03:	e9 31 ff ff ff       	jmp    803d39 <__umoddi3+0x29>
  803e08:	90                   	nop
  803e09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803e10:	39 dd                	cmp    %ebx,%ebp
  803e12:	72 08                	jb     803e1c <__umoddi3+0x10c>
  803e14:	39 f7                	cmp    %esi,%edi
  803e16:	0f 87 21 ff ff ff    	ja     803d3d <__umoddi3+0x2d>
  803e1c:	89 da                	mov    %ebx,%edx
  803e1e:	89 f0                	mov    %esi,%eax
  803e20:	29 f8                	sub    %edi,%eax
  803e22:	19 ea                	sbb    %ebp,%edx
  803e24:	e9 14 ff ff ff       	jmp    803d3d <__umoddi3+0x2d>
