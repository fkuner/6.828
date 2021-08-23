
obj/user/testfile.debug:     file format elf32-i386


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
  80002c:	e8 54 06 00 00       	call   800685 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <xopen>:

#define FVA ((struct Fd*)0xCCCCC000)

static int
xopen(const char *path, int mode)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 0c             	sub    $0xc,%esp
  80003a:	89 d3                	mov    %edx,%ebx
	extern union Fsipc fsipcbuf;
	envid_t fsenv;
	
	strcpy(fsipcbuf.open.req_path, path);
  80003c:	50                   	push   %eax
  80003d:	68 00 60 80 00       	push   $0x806000
  800042:	e8 16 0e 00 00       	call   800e5d <strcpy>
	fsipcbuf.open.req_omode = mode;
  800047:	89 1d 00 64 80 00    	mov    %ebx,0x806400

	fsenv = ipc_find_env(ENV_TYPE_FS);
  80004d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800054:	e8 cf 14 00 00       	call   801528 <ipc_find_env>
	ipc_send(fsenv, FSREQ_OPEN, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800059:	6a 07                	push   $0x7
  80005b:	68 00 60 80 00       	push   $0x806000
  800060:	6a 01                	push   $0x1
  800062:	50                   	push   %eax
  800063:	e8 67 14 00 00       	call   8014cf <ipc_send>
	return ipc_recv(NULL, FVA, NULL);
  800068:	83 c4 1c             	add    $0x1c,%esp
  80006b:	6a 00                	push   $0x0
  80006d:	68 00 c0 cc cc       	push   $0xccccc000
  800072:	6a 00                	push   $0x0
  800074:	e8 ed 13 00 00       	call   801466 <ipc_recv>
}
  800079:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80007c:	c9                   	leave  
  80007d:	c3                   	ret    

0080007e <umain>:

void
umain(int argc, char **argv)
{
  80007e:	55                   	push   %ebp
  80007f:	89 e5                	mov    %esp,%ebp
  800081:	57                   	push   %edi
  800082:	56                   	push   %esi
  800083:	53                   	push   %ebx
  800084:	81 ec ac 02 00 00    	sub    $0x2ac,%esp
	struct Fd fdcopy;
	struct Stat st;
	char buf[512];

	// We open files manually first, to avoid the FD layer
	if ((r = xopen("/not-found", O_RDONLY)) < 0 && r != -E_NOT_FOUND)
  80008a:	ba 00 00 00 00       	mov    $0x0,%edx
  80008f:	b8 40 29 80 00       	mov    $0x802940,%eax
  800094:	e8 9a ff ff ff       	call   800033 <xopen>
  800099:	83 f8 f5             	cmp    $0xfffffff5,%eax
  80009c:	74 08                	je     8000a6 <umain+0x28>
  80009e:	85 c0                	test   %eax,%eax
  8000a0:	0f 88 e9 03 00 00    	js     80048f <umain+0x411>
		panic("serve_open /not-found: %e", r);
	else if (r >= 0)
  8000a6:	85 c0                	test   %eax,%eax
  8000a8:	0f 89 f3 03 00 00    	jns    8004a1 <umain+0x423>
		panic("serve_open /not-found succeeded!");

	if ((r = xopen("/newmotd", O_RDONLY)) < 0)
  8000ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8000b3:	b8 75 29 80 00       	mov    $0x802975,%eax
  8000b8:	e8 76 ff ff ff       	call   800033 <xopen>
  8000bd:	85 c0                	test   %eax,%eax
  8000bf:	0f 88 f0 03 00 00    	js     8004b5 <umain+0x437>
		panic("serve_open /newmotd: %e", r);
	if (FVA->fd_dev_id != 'f' || FVA->fd_offset != 0 || FVA->fd_omode != O_RDONLY)
  8000c5:	83 3d 00 c0 cc cc 66 	cmpl   $0x66,0xccccc000
  8000cc:	0f 85 f5 03 00 00    	jne    8004c7 <umain+0x449>
  8000d2:	83 3d 04 c0 cc cc 00 	cmpl   $0x0,0xccccc004
  8000d9:	0f 85 e8 03 00 00    	jne    8004c7 <umain+0x449>
  8000df:	83 3d 08 c0 cc cc 00 	cmpl   $0x0,0xccccc008
  8000e6:	0f 85 db 03 00 00    	jne    8004c7 <umain+0x449>
		panic("serve_open did not fill struct Fd correctly\n");
	cprintf("serve_open is good\n");
  8000ec:	83 ec 0c             	sub    $0xc,%esp
  8000ef:	68 96 29 80 00       	push   $0x802996
  8000f4:	e8 c7 06 00 00       	call   8007c0 <cprintf>

	if ((r = devfile.dev_stat(FVA, &st)) < 0)
  8000f9:	83 c4 08             	add    $0x8,%esp
  8000fc:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  800102:	50                   	push   %eax
  800103:	68 00 c0 cc cc       	push   $0xccccc000
  800108:	ff 15 1c 40 80 00    	call   *0x80401c
  80010e:	83 c4 10             	add    $0x10,%esp
  800111:	85 c0                	test   %eax,%eax
  800113:	0f 88 c2 03 00 00    	js     8004db <umain+0x45d>
		panic("file_stat: %e", r);
	if (strlen(msg) != st.st_size)
  800119:	83 ec 0c             	sub    $0xc,%esp
  80011c:	ff 35 00 40 80 00    	pushl  0x804000
  800122:	e8 ff 0c 00 00       	call   800e26 <strlen>
  800127:	83 c4 10             	add    $0x10,%esp
  80012a:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  80012d:	0f 85 ba 03 00 00    	jne    8004ed <umain+0x46f>
		panic("file_stat returned size %d wanted %d\n", st.st_size, strlen(msg));
	cprintf("file_stat is good\n");
  800133:	83 ec 0c             	sub    $0xc,%esp
  800136:	68 b8 29 80 00       	push   $0x8029b8
  80013b:	e8 80 06 00 00       	call   8007c0 <cprintf>

	memset(buf, 0, sizeof buf);
  800140:	83 c4 0c             	add    $0xc,%esp
  800143:	68 00 02 00 00       	push   $0x200
  800148:	6a 00                	push   $0x0
  80014a:	8d 9d 4c fd ff ff    	lea    -0x2b4(%ebp),%ebx
  800150:	53                   	push   %ebx
  800151:	e8 48 0e 00 00       	call   800f9e <memset>
	if ((r = devfile.dev_read(FVA, buf, sizeof buf)) < 0)
  800156:	83 c4 0c             	add    $0xc,%esp
  800159:	68 00 02 00 00       	push   $0x200
  80015e:	53                   	push   %ebx
  80015f:	68 00 c0 cc cc       	push   $0xccccc000
  800164:	ff 15 10 40 80 00    	call   *0x804010
  80016a:	83 c4 10             	add    $0x10,%esp
  80016d:	85 c0                	test   %eax,%eax
  80016f:	0f 88 9d 03 00 00    	js     800512 <umain+0x494>
		panic("file_read: %e", r);
	if (strcmp(buf, msg) != 0)
  800175:	83 ec 08             	sub    $0x8,%esp
  800178:	ff 35 00 40 80 00    	pushl  0x804000
  80017e:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  800184:	50                   	push   %eax
  800185:	e8 79 0d 00 00       	call   800f03 <strcmp>
  80018a:	83 c4 10             	add    $0x10,%esp
  80018d:	85 c0                	test   %eax,%eax
  80018f:	0f 85 8f 03 00 00    	jne    800524 <umain+0x4a6>
		panic("file_read returned wrong data");
	cprintf("file_read is good\n");
  800195:	83 ec 0c             	sub    $0xc,%esp
  800198:	68 f7 29 80 00       	push   $0x8029f7
  80019d:	e8 1e 06 00 00       	call   8007c0 <cprintf>

	if ((r = devfile.dev_close(FVA)) < 0)
  8001a2:	c7 04 24 00 c0 cc cc 	movl   $0xccccc000,(%esp)
  8001a9:	ff 15 18 40 80 00    	call   *0x804018
  8001af:	83 c4 10             	add    $0x10,%esp
  8001b2:	85 c0                	test   %eax,%eax
  8001b4:	0f 88 7e 03 00 00    	js     800538 <umain+0x4ba>
		panic("file_close: %e", r);
	cprintf("file_close is good\n");
  8001ba:	83 ec 0c             	sub    $0xc,%esp
  8001bd:	68 19 2a 80 00       	push   $0x802a19
  8001c2:	e8 f9 05 00 00       	call   8007c0 <cprintf>

	// We're about to unmap the FD, but still need a way to get
	// the stale filenum to serve_read, so we make a local copy.
	// The file server won't think it's stale until we unmap the
	// FD page.
	fdcopy = *FVA;
  8001c7:	a1 00 c0 cc cc       	mov    0xccccc000,%eax
  8001cc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001cf:	a1 04 c0 cc cc       	mov    0xccccc004,%eax
  8001d4:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8001d7:	a1 08 c0 cc cc       	mov    0xccccc008,%eax
  8001dc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001df:	a1 0c c0 cc cc       	mov    0xccccc00c,%eax
  8001e4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	sys_page_unmap(0, FVA);
  8001e7:	83 c4 08             	add    $0x8,%esp
  8001ea:	68 00 c0 cc cc       	push   $0xccccc000
  8001ef:	6a 00                	push   $0x0
  8001f1:	e8 e5 10 00 00       	call   8012db <sys_page_unmap>

	if ((r = devfile.dev_read(&fdcopy, buf, sizeof buf)) != -E_INVAL)
  8001f6:	83 c4 0c             	add    $0xc,%esp
  8001f9:	68 00 02 00 00       	push   $0x200
  8001fe:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  800204:	50                   	push   %eax
  800205:	8d 45 d8             	lea    -0x28(%ebp),%eax
  800208:	50                   	push   %eax
  800209:	ff 15 10 40 80 00    	call   *0x804010
  80020f:	83 c4 10             	add    $0x10,%esp
  800212:	83 f8 fd             	cmp    $0xfffffffd,%eax
  800215:	0f 85 2f 03 00 00    	jne    80054a <umain+0x4cc>
		panic("serve_read does not handle stale fileids correctly: %e", r);
	cprintf("stale fileid is good\n");
  80021b:	83 ec 0c             	sub    $0xc,%esp
  80021e:	68 2d 2a 80 00       	push   $0x802a2d
  800223:	e8 98 05 00 00       	call   8007c0 <cprintf>

	// Try writing
	if ((r = xopen("/new-file", O_RDWR|O_CREAT)) < 0)
  800228:	ba 02 01 00 00       	mov    $0x102,%edx
  80022d:	b8 43 2a 80 00       	mov    $0x802a43,%eax
  800232:	e8 fc fd ff ff       	call   800033 <xopen>
  800237:	83 c4 10             	add    $0x10,%esp
  80023a:	85 c0                	test   %eax,%eax
  80023c:	0f 88 1a 03 00 00    	js     80055c <umain+0x4de>
		panic("serve_open /new-file: %e", r);

	if ((r = devfile.dev_write(FVA, msg, strlen(msg))) != strlen(msg))
  800242:	8b 1d 14 40 80 00    	mov    0x804014,%ebx
  800248:	83 ec 0c             	sub    $0xc,%esp
  80024b:	ff 35 00 40 80 00    	pushl  0x804000
  800251:	e8 d0 0b 00 00       	call   800e26 <strlen>
  800256:	83 c4 0c             	add    $0xc,%esp
  800259:	50                   	push   %eax
  80025a:	ff 35 00 40 80 00    	pushl  0x804000
  800260:	68 00 c0 cc cc       	push   $0xccccc000
  800265:	ff d3                	call   *%ebx
  800267:	89 c3                	mov    %eax,%ebx
  800269:	83 c4 04             	add    $0x4,%esp
  80026c:	ff 35 00 40 80 00    	pushl  0x804000
  800272:	e8 af 0b 00 00       	call   800e26 <strlen>
  800277:	83 c4 10             	add    $0x10,%esp
  80027a:	39 d8                	cmp    %ebx,%eax
  80027c:	0f 85 ec 02 00 00    	jne    80056e <umain+0x4f0>
		panic("file_write: %e", r);
	cprintf("file_write is good\n");
  800282:	83 ec 0c             	sub    $0xc,%esp
  800285:	68 75 2a 80 00       	push   $0x802a75
  80028a:	e8 31 05 00 00       	call   8007c0 <cprintf>

	FVA->fd_offset = 0;
  80028f:	c7 05 04 c0 cc cc 00 	movl   $0x0,0xccccc004
  800296:	00 00 00 
	memset(buf, 0, sizeof buf);
  800299:	83 c4 0c             	add    $0xc,%esp
  80029c:	68 00 02 00 00       	push   $0x200
  8002a1:	6a 00                	push   $0x0
  8002a3:	8d 9d 4c fd ff ff    	lea    -0x2b4(%ebp),%ebx
  8002a9:	53                   	push   %ebx
  8002aa:	e8 ef 0c 00 00       	call   800f9e <memset>
	if ((r = devfile.dev_read(FVA, buf, sizeof buf)) < 0)
  8002af:	83 c4 0c             	add    $0xc,%esp
  8002b2:	68 00 02 00 00       	push   $0x200
  8002b7:	53                   	push   %ebx
  8002b8:	68 00 c0 cc cc       	push   $0xccccc000
  8002bd:	ff 15 10 40 80 00    	call   *0x804010
  8002c3:	89 c3                	mov    %eax,%ebx
  8002c5:	83 c4 10             	add    $0x10,%esp
  8002c8:	85 c0                	test   %eax,%eax
  8002ca:	0f 88 b0 02 00 00    	js     800580 <umain+0x502>
		panic("file_read after file_write: %e", r);
	if (r != strlen(msg))
  8002d0:	83 ec 0c             	sub    $0xc,%esp
  8002d3:	ff 35 00 40 80 00    	pushl  0x804000
  8002d9:	e8 48 0b 00 00       	call   800e26 <strlen>
  8002de:	83 c4 10             	add    $0x10,%esp
  8002e1:	39 d8                	cmp    %ebx,%eax
  8002e3:	0f 85 a9 02 00 00    	jne    800592 <umain+0x514>
		panic("file_read after file_write returned wrong length: %d", r);
	if (strcmp(buf, msg) != 0)
  8002e9:	83 ec 08             	sub    $0x8,%esp
  8002ec:	ff 35 00 40 80 00    	pushl  0x804000
  8002f2:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  8002f8:	50                   	push   %eax
  8002f9:	e8 05 0c 00 00       	call   800f03 <strcmp>
  8002fe:	83 c4 10             	add    $0x10,%esp
  800301:	85 c0                	test   %eax,%eax
  800303:	0f 85 9b 02 00 00    	jne    8005a4 <umain+0x526>
		panic("file_read after file_write returned wrong data");
	cprintf("file_read after file_write is good\n");
  800309:	83 ec 0c             	sub    $0xc,%esp
  80030c:	68 3c 2c 80 00       	push   $0x802c3c
  800311:	e8 aa 04 00 00       	call   8007c0 <cprintf>

	// Now we'll try out open
	if ((r = open("/not-found", O_RDONLY)) < 0 && r != -E_NOT_FOUND)
  800316:	83 c4 08             	add    $0x8,%esp
  800319:	6a 00                	push   $0x0
  80031b:	68 40 29 80 00       	push   $0x802940
  800320:	e8 c7 19 00 00       	call   801cec <open>
  800325:	83 c4 10             	add    $0x10,%esp
  800328:	83 f8 f5             	cmp    $0xfffffff5,%eax
  80032b:	74 08                	je     800335 <umain+0x2b7>
  80032d:	85 c0                	test   %eax,%eax
  80032f:	0f 88 83 02 00 00    	js     8005b8 <umain+0x53a>
		panic("open /not-found: %e", r);
	else if (r >= 0)
  800335:	85 c0                	test   %eax,%eax
  800337:	0f 89 8d 02 00 00    	jns    8005ca <umain+0x54c>
		panic("open /not-found succeeded!");

	if ((r = open("/newmotd", O_RDONLY)) < 0)
  80033d:	83 ec 08             	sub    $0x8,%esp
  800340:	6a 00                	push   $0x0
  800342:	68 75 29 80 00       	push   $0x802975
  800347:	e8 a0 19 00 00       	call   801cec <open>
  80034c:	83 c4 10             	add    $0x10,%esp
  80034f:	85 c0                	test   %eax,%eax
  800351:	0f 88 87 02 00 00    	js     8005de <umain+0x560>
		panic("open /newmotd: %e", r);
	fd = (struct Fd*) (0xD0000000 + r*PGSIZE);
  800357:	c1 e0 0c             	shl    $0xc,%eax
	if (fd->fd_dev_id != 'f' || fd->fd_offset != 0 || fd->fd_omode != O_RDONLY)
  80035a:	83 b8 00 00 00 d0 66 	cmpl   $0x66,-0x30000000(%eax)
  800361:	0f 85 89 02 00 00    	jne    8005f0 <umain+0x572>
  800367:	83 b8 04 00 00 d0 00 	cmpl   $0x0,-0x2ffffffc(%eax)
  80036e:	0f 85 7c 02 00 00    	jne    8005f0 <umain+0x572>
  800374:	8b 98 08 00 00 d0    	mov    -0x2ffffff8(%eax),%ebx
  80037a:	85 db                	test   %ebx,%ebx
  80037c:	0f 85 6e 02 00 00    	jne    8005f0 <umain+0x572>
		panic("open did not fill struct Fd correctly\n");
	cprintf("open is good\n");
  800382:	83 ec 0c             	sub    $0xc,%esp
  800385:	68 9c 29 80 00       	push   $0x80299c
  80038a:	e8 31 04 00 00       	call   8007c0 <cprintf>

	// Try files with indirect blocks
	if ((f = open("/big", O_WRONLY|O_CREAT)) < 0)
  80038f:	83 c4 08             	add    $0x8,%esp
  800392:	68 01 01 00 00       	push   $0x101
  800397:	68 a4 2a 80 00       	push   $0x802aa4
  80039c:	e8 4b 19 00 00       	call   801cec <open>
  8003a1:	89 c7                	mov    %eax,%edi
  8003a3:	83 c4 10             	add    $0x10,%esp
  8003a6:	85 c0                	test   %eax,%eax
  8003a8:	0f 88 56 02 00 00    	js     800604 <umain+0x586>
		panic("creat /big: %e", f);
	memset(buf, 0, sizeof(buf));
  8003ae:	83 ec 04             	sub    $0x4,%esp
  8003b1:	68 00 02 00 00       	push   $0x200
  8003b6:	6a 00                	push   $0x0
  8003b8:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  8003be:	50                   	push   %eax
  8003bf:	e8 da 0b 00 00       	call   800f9e <memset>
  8003c4:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  8003c7:	89 de                	mov    %ebx,%esi
		*(int*)buf = i;
  8003c9:	89 b5 4c fd ff ff    	mov    %esi,-0x2b4(%ebp)
		if ((r = write(f, buf, sizeof(buf))) < 0)
  8003cf:	83 ec 04             	sub    $0x4,%esp
  8003d2:	68 00 02 00 00       	push   $0x200
  8003d7:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  8003dd:	50                   	push   %eax
  8003de:	57                   	push   %edi
  8003df:	e8 32 15 00 00       	call   801916 <write>
  8003e4:	83 c4 10             	add    $0x10,%esp
  8003e7:	85 c0                	test   %eax,%eax
  8003e9:	0f 88 27 02 00 00    	js     800616 <umain+0x598>
  8003ef:	81 c6 00 02 00 00    	add    $0x200,%esi
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  8003f5:	81 fe 00 e0 01 00    	cmp    $0x1e000,%esi
  8003fb:	75 cc                	jne    8003c9 <umain+0x34b>
			panic("write /big@%d: %e", i, r);
	}
	close(f);
  8003fd:	83 ec 0c             	sub    $0xc,%esp
  800400:	57                   	push   %edi
  800401:	e8 06 13 00 00       	call   80170c <close>

	if ((f = open("/big", O_RDONLY)) < 0)
  800406:	83 c4 08             	add    $0x8,%esp
  800409:	6a 00                	push   $0x0
  80040b:	68 a4 2a 80 00       	push   $0x802aa4
  800410:	e8 d7 18 00 00       	call   801cec <open>
  800415:	89 c6                	mov    %eax,%esi
  800417:	83 c4 10             	add    $0x10,%esp
  80041a:	85 c0                	test   %eax,%eax
  80041c:	0f 88 0a 02 00 00    	js     80062c <umain+0x5ae>
		panic("open /big: %e", f);
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
		*(int*)buf = i;
		if ((r = readn(f, buf, sizeof(buf))) < 0)
  800422:	8d bd 4c fd ff ff    	lea    -0x2b4(%ebp),%edi
		*(int*)buf = i;
  800428:	89 9d 4c fd ff ff    	mov    %ebx,-0x2b4(%ebp)
		if ((r = readn(f, buf, sizeof(buf))) < 0)
  80042e:	83 ec 04             	sub    $0x4,%esp
  800431:	68 00 02 00 00       	push   $0x200
  800436:	57                   	push   %edi
  800437:	56                   	push   %esi
  800438:	e8 92 14 00 00       	call   8018cf <readn>
  80043d:	83 c4 10             	add    $0x10,%esp
  800440:	85 c0                	test   %eax,%eax
  800442:	0f 88 f6 01 00 00    	js     80063e <umain+0x5c0>
			panic("read /big@%d: %e", i, r);
		if (r != sizeof(buf))
  800448:	3d 00 02 00 00       	cmp    $0x200,%eax
  80044d:	0f 85 01 02 00 00    	jne    800654 <umain+0x5d6>
			panic("read /big from %d returned %d < %d bytes",
			      i, r, sizeof(buf));
		if (*(int*)buf != i)
  800453:	8b 85 4c fd ff ff    	mov    -0x2b4(%ebp),%eax
  800459:	39 d8                	cmp    %ebx,%eax
  80045b:	0f 85 0e 02 00 00    	jne    80066f <umain+0x5f1>
  800461:	81 c3 00 02 00 00    	add    $0x200,%ebx
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  800467:	81 fb 00 e0 01 00    	cmp    $0x1e000,%ebx
  80046d:	75 b9                	jne    800428 <umain+0x3aa>
			panic("read /big from %d returned bad data %d",
			      i, *(int*)buf);
	}
	close(f);
  80046f:	83 ec 0c             	sub    $0xc,%esp
  800472:	56                   	push   %esi
  800473:	e8 94 12 00 00       	call   80170c <close>
	cprintf("large file is good\n");
  800478:	c7 04 24 e9 2a 80 00 	movl   $0x802ae9,(%esp)
  80047f:	e8 3c 03 00 00       	call   8007c0 <cprintf>
}
  800484:	83 c4 10             	add    $0x10,%esp
  800487:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80048a:	5b                   	pop    %ebx
  80048b:	5e                   	pop    %esi
  80048c:	5f                   	pop    %edi
  80048d:	5d                   	pop    %ebp
  80048e:	c3                   	ret    
		panic("serve_open /not-found: %e", r);
  80048f:	50                   	push   %eax
  800490:	68 4b 29 80 00       	push   $0x80294b
  800495:	6a 20                	push   $0x20
  800497:	68 65 29 80 00       	push   $0x802965
  80049c:	e8 44 02 00 00       	call   8006e5 <_panic>
		panic("serve_open /not-found succeeded!");
  8004a1:	83 ec 04             	sub    $0x4,%esp
  8004a4:	68 00 2b 80 00       	push   $0x802b00
  8004a9:	6a 22                	push   $0x22
  8004ab:	68 65 29 80 00       	push   $0x802965
  8004b0:	e8 30 02 00 00       	call   8006e5 <_panic>
		panic("serve_open /newmotd: %e", r);
  8004b5:	50                   	push   %eax
  8004b6:	68 7e 29 80 00       	push   $0x80297e
  8004bb:	6a 25                	push   $0x25
  8004bd:	68 65 29 80 00       	push   $0x802965
  8004c2:	e8 1e 02 00 00       	call   8006e5 <_panic>
		panic("serve_open did not fill struct Fd correctly\n");
  8004c7:	83 ec 04             	sub    $0x4,%esp
  8004ca:	68 24 2b 80 00       	push   $0x802b24
  8004cf:	6a 27                	push   $0x27
  8004d1:	68 65 29 80 00       	push   $0x802965
  8004d6:	e8 0a 02 00 00       	call   8006e5 <_panic>
		panic("file_stat: %e", r);
  8004db:	50                   	push   %eax
  8004dc:	68 aa 29 80 00       	push   $0x8029aa
  8004e1:	6a 2b                	push   $0x2b
  8004e3:	68 65 29 80 00       	push   $0x802965
  8004e8:	e8 f8 01 00 00       	call   8006e5 <_panic>
		panic("file_stat returned size %d wanted %d\n", st.st_size, strlen(msg));
  8004ed:	83 ec 0c             	sub    $0xc,%esp
  8004f0:	ff 35 00 40 80 00    	pushl  0x804000
  8004f6:	e8 2b 09 00 00       	call   800e26 <strlen>
  8004fb:	89 04 24             	mov    %eax,(%esp)
  8004fe:	ff 75 cc             	pushl  -0x34(%ebp)
  800501:	68 54 2b 80 00       	push   $0x802b54
  800506:	6a 2d                	push   $0x2d
  800508:	68 65 29 80 00       	push   $0x802965
  80050d:	e8 d3 01 00 00       	call   8006e5 <_panic>
		panic("file_read: %e", r);
  800512:	50                   	push   %eax
  800513:	68 cb 29 80 00       	push   $0x8029cb
  800518:	6a 32                	push   $0x32
  80051a:	68 65 29 80 00       	push   $0x802965
  80051f:	e8 c1 01 00 00       	call   8006e5 <_panic>
		panic("file_read returned wrong data");
  800524:	83 ec 04             	sub    $0x4,%esp
  800527:	68 d9 29 80 00       	push   $0x8029d9
  80052c:	6a 34                	push   $0x34
  80052e:	68 65 29 80 00       	push   $0x802965
  800533:	e8 ad 01 00 00       	call   8006e5 <_panic>
		panic("file_close: %e", r);
  800538:	50                   	push   %eax
  800539:	68 0a 2a 80 00       	push   $0x802a0a
  80053e:	6a 38                	push   $0x38
  800540:	68 65 29 80 00       	push   $0x802965
  800545:	e8 9b 01 00 00       	call   8006e5 <_panic>
		panic("serve_read does not handle stale fileids correctly: %e", r);
  80054a:	50                   	push   %eax
  80054b:	68 7c 2b 80 00       	push   $0x802b7c
  800550:	6a 43                	push   $0x43
  800552:	68 65 29 80 00       	push   $0x802965
  800557:	e8 89 01 00 00       	call   8006e5 <_panic>
		panic("serve_open /new-file: %e", r);
  80055c:	50                   	push   %eax
  80055d:	68 4d 2a 80 00       	push   $0x802a4d
  800562:	6a 48                	push   $0x48
  800564:	68 65 29 80 00       	push   $0x802965
  800569:	e8 77 01 00 00       	call   8006e5 <_panic>
		panic("file_write: %e", r);
  80056e:	53                   	push   %ebx
  80056f:	68 66 2a 80 00       	push   $0x802a66
  800574:	6a 4b                	push   $0x4b
  800576:	68 65 29 80 00       	push   $0x802965
  80057b:	e8 65 01 00 00       	call   8006e5 <_panic>
		panic("file_read after file_write: %e", r);
  800580:	50                   	push   %eax
  800581:	68 b4 2b 80 00       	push   $0x802bb4
  800586:	6a 51                	push   $0x51
  800588:	68 65 29 80 00       	push   $0x802965
  80058d:	e8 53 01 00 00       	call   8006e5 <_panic>
		panic("file_read after file_write returned wrong length: %d", r);
  800592:	53                   	push   %ebx
  800593:	68 d4 2b 80 00       	push   $0x802bd4
  800598:	6a 53                	push   $0x53
  80059a:	68 65 29 80 00       	push   $0x802965
  80059f:	e8 41 01 00 00       	call   8006e5 <_panic>
		panic("file_read after file_write returned wrong data");
  8005a4:	83 ec 04             	sub    $0x4,%esp
  8005a7:	68 0c 2c 80 00       	push   $0x802c0c
  8005ac:	6a 55                	push   $0x55
  8005ae:	68 65 29 80 00       	push   $0x802965
  8005b3:	e8 2d 01 00 00       	call   8006e5 <_panic>
		panic("open /not-found: %e", r);
  8005b8:	50                   	push   %eax
  8005b9:	68 51 29 80 00       	push   $0x802951
  8005be:	6a 5a                	push   $0x5a
  8005c0:	68 65 29 80 00       	push   $0x802965
  8005c5:	e8 1b 01 00 00       	call   8006e5 <_panic>
		panic("open /not-found succeeded!");
  8005ca:	83 ec 04             	sub    $0x4,%esp
  8005cd:	68 89 2a 80 00       	push   $0x802a89
  8005d2:	6a 5c                	push   $0x5c
  8005d4:	68 65 29 80 00       	push   $0x802965
  8005d9:	e8 07 01 00 00       	call   8006e5 <_panic>
		panic("open /newmotd: %e", r);
  8005de:	50                   	push   %eax
  8005df:	68 84 29 80 00       	push   $0x802984
  8005e4:	6a 5f                	push   $0x5f
  8005e6:	68 65 29 80 00       	push   $0x802965
  8005eb:	e8 f5 00 00 00       	call   8006e5 <_panic>
		panic("open did not fill struct Fd correctly\n");
  8005f0:	83 ec 04             	sub    $0x4,%esp
  8005f3:	68 60 2c 80 00       	push   $0x802c60
  8005f8:	6a 62                	push   $0x62
  8005fa:	68 65 29 80 00       	push   $0x802965
  8005ff:	e8 e1 00 00 00       	call   8006e5 <_panic>
		panic("creat /big: %e", f);
  800604:	50                   	push   %eax
  800605:	68 a9 2a 80 00       	push   $0x802aa9
  80060a:	6a 67                	push   $0x67
  80060c:	68 65 29 80 00       	push   $0x802965
  800611:	e8 cf 00 00 00       	call   8006e5 <_panic>
			panic("write /big@%d: %e", i, r);
  800616:	83 ec 0c             	sub    $0xc,%esp
  800619:	50                   	push   %eax
  80061a:	56                   	push   %esi
  80061b:	68 b8 2a 80 00       	push   $0x802ab8
  800620:	6a 6c                	push   $0x6c
  800622:	68 65 29 80 00       	push   $0x802965
  800627:	e8 b9 00 00 00       	call   8006e5 <_panic>
		panic("open /big: %e", f);
  80062c:	50                   	push   %eax
  80062d:	68 ca 2a 80 00       	push   $0x802aca
  800632:	6a 71                	push   $0x71
  800634:	68 65 29 80 00       	push   $0x802965
  800639:	e8 a7 00 00 00       	call   8006e5 <_panic>
			panic("read /big@%d: %e", i, r);
  80063e:	83 ec 0c             	sub    $0xc,%esp
  800641:	50                   	push   %eax
  800642:	53                   	push   %ebx
  800643:	68 d8 2a 80 00       	push   $0x802ad8
  800648:	6a 75                	push   $0x75
  80064a:	68 65 29 80 00       	push   $0x802965
  80064f:	e8 91 00 00 00       	call   8006e5 <_panic>
			panic("read /big from %d returned %d < %d bytes",
  800654:	83 ec 08             	sub    $0x8,%esp
  800657:	68 00 02 00 00       	push   $0x200
  80065c:	50                   	push   %eax
  80065d:	53                   	push   %ebx
  80065e:	68 88 2c 80 00       	push   $0x802c88
  800663:	6a 78                	push   $0x78
  800665:	68 65 29 80 00       	push   $0x802965
  80066a:	e8 76 00 00 00       	call   8006e5 <_panic>
			panic("read /big from %d returned bad data %d",
  80066f:	83 ec 0c             	sub    $0xc,%esp
  800672:	50                   	push   %eax
  800673:	53                   	push   %ebx
  800674:	68 b4 2c 80 00       	push   $0x802cb4
  800679:	6a 7b                	push   $0x7b
  80067b:	68 65 29 80 00       	push   $0x802965
  800680:	e8 60 00 00 00       	call   8006e5 <_panic>

00800685 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800685:	55                   	push   %ebp
  800686:	89 e5                	mov    %esp,%ebp
  800688:	56                   	push   %esi
  800689:	53                   	push   %ebx
  80068a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80068d:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
    thisenv = &envs[ENVX(sys_getenvid())];
  800690:	e8 83 0b 00 00       	call   801218 <sys_getenvid>
  800695:	25 ff 03 00 00       	and    $0x3ff,%eax
  80069a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80069d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8006a2:	a3 08 50 80 00       	mov    %eax,0x805008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8006a7:	85 db                	test   %ebx,%ebx
  8006a9:	7e 07                	jle    8006b2 <libmain+0x2d>
		binaryname = argv[0];
  8006ab:	8b 06                	mov    (%esi),%eax
  8006ad:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	umain(argc, argv);
  8006b2:	83 ec 08             	sub    $0x8,%esp
  8006b5:	56                   	push   %esi
  8006b6:	53                   	push   %ebx
  8006b7:	e8 c2 f9 ff ff       	call   80007e <umain>

	// exit gracefully
	exit();
  8006bc:	e8 0a 00 00 00       	call   8006cb <exit>
}
  8006c1:	83 c4 10             	add    $0x10,%esp
  8006c4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8006c7:	5b                   	pop    %ebx
  8006c8:	5e                   	pop    %esi
  8006c9:	5d                   	pop    %ebp
  8006ca:	c3                   	ret    

008006cb <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8006cb:	55                   	push   %ebp
  8006cc:	89 e5                	mov    %esp,%ebp
  8006ce:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8006d1:	e8 61 10 00 00       	call   801737 <close_all>
	sys_env_destroy(0);
  8006d6:	83 ec 0c             	sub    $0xc,%esp
  8006d9:	6a 00                	push   $0x0
  8006db:	e8 f7 0a 00 00       	call   8011d7 <sys_env_destroy>
}
  8006e0:	83 c4 10             	add    $0x10,%esp
  8006e3:	c9                   	leave  
  8006e4:	c3                   	ret    

008006e5 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8006e5:	55                   	push   %ebp
  8006e6:	89 e5                	mov    %esp,%ebp
  8006e8:	56                   	push   %esi
  8006e9:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8006ea:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8006ed:	8b 35 04 40 80 00    	mov    0x804004,%esi
  8006f3:	e8 20 0b 00 00       	call   801218 <sys_getenvid>
  8006f8:	83 ec 0c             	sub    $0xc,%esp
  8006fb:	ff 75 0c             	pushl  0xc(%ebp)
  8006fe:	ff 75 08             	pushl  0x8(%ebp)
  800701:	56                   	push   %esi
  800702:	50                   	push   %eax
  800703:	68 0c 2d 80 00       	push   $0x802d0c
  800708:	e8 b3 00 00 00       	call   8007c0 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80070d:	83 c4 18             	add    $0x18,%esp
  800710:	53                   	push   %ebx
  800711:	ff 75 10             	pushl  0x10(%ebp)
  800714:	e8 56 00 00 00       	call   80076f <vcprintf>
	cprintf("\n");
  800719:	c7 04 24 8f 31 80 00 	movl   $0x80318f,(%esp)
  800720:	e8 9b 00 00 00       	call   8007c0 <cprintf>
  800725:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800728:	cc                   	int3   
  800729:	eb fd                	jmp    800728 <_panic+0x43>

0080072b <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80072b:	55                   	push   %ebp
  80072c:	89 e5                	mov    %esp,%ebp
  80072e:	53                   	push   %ebx
  80072f:	83 ec 04             	sub    $0x4,%esp
  800732:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800735:	8b 13                	mov    (%ebx),%edx
  800737:	8d 42 01             	lea    0x1(%edx),%eax
  80073a:	89 03                	mov    %eax,(%ebx)
  80073c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80073f:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800743:	3d ff 00 00 00       	cmp    $0xff,%eax
  800748:	74 09                	je     800753 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80074a:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80074e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800751:	c9                   	leave  
  800752:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800753:	83 ec 08             	sub    $0x8,%esp
  800756:	68 ff 00 00 00       	push   $0xff
  80075b:	8d 43 08             	lea    0x8(%ebx),%eax
  80075e:	50                   	push   %eax
  80075f:	e8 36 0a 00 00       	call   80119a <sys_cputs>
		b->idx = 0;
  800764:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80076a:	83 c4 10             	add    $0x10,%esp
  80076d:	eb db                	jmp    80074a <putch+0x1f>

0080076f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80076f:	55                   	push   %ebp
  800770:	89 e5                	mov    %esp,%ebp
  800772:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800778:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80077f:	00 00 00 
	b.cnt = 0;
  800782:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800789:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80078c:	ff 75 0c             	pushl  0xc(%ebp)
  80078f:	ff 75 08             	pushl  0x8(%ebp)
  800792:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800798:	50                   	push   %eax
  800799:	68 2b 07 80 00       	push   $0x80072b
  80079e:	e8 1a 01 00 00       	call   8008bd <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8007a3:	83 c4 08             	add    $0x8,%esp
  8007a6:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8007ac:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8007b2:	50                   	push   %eax
  8007b3:	e8 e2 09 00 00       	call   80119a <sys_cputs>

	return b.cnt;
}
  8007b8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8007be:	c9                   	leave  
  8007bf:	c3                   	ret    

008007c0 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8007c0:	55                   	push   %ebp
  8007c1:	89 e5                	mov    %esp,%ebp
  8007c3:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8007c6:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8007c9:	50                   	push   %eax
  8007ca:	ff 75 08             	pushl  0x8(%ebp)
  8007cd:	e8 9d ff ff ff       	call   80076f <vcprintf>
	va_end(ap);

	return cnt;
}
  8007d2:	c9                   	leave  
  8007d3:	c3                   	ret    

008007d4 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007d4:	55                   	push   %ebp
  8007d5:	89 e5                	mov    %esp,%ebp
  8007d7:	57                   	push   %edi
  8007d8:	56                   	push   %esi
  8007d9:	53                   	push   %ebx
  8007da:	83 ec 1c             	sub    $0x1c,%esp
  8007dd:	89 c7                	mov    %eax,%edi
  8007df:	89 d6                	mov    %edx,%esi
  8007e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007e7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007ea:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007ed:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8007f0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8007f5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8007f8:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8007fb:	39 d3                	cmp    %edx,%ebx
  8007fd:	72 05                	jb     800804 <printnum+0x30>
  8007ff:	39 45 10             	cmp    %eax,0x10(%ebp)
  800802:	77 7a                	ja     80087e <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800804:	83 ec 0c             	sub    $0xc,%esp
  800807:	ff 75 18             	pushl  0x18(%ebp)
  80080a:	8b 45 14             	mov    0x14(%ebp),%eax
  80080d:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800810:	53                   	push   %ebx
  800811:	ff 75 10             	pushl  0x10(%ebp)
  800814:	83 ec 08             	sub    $0x8,%esp
  800817:	ff 75 e4             	pushl  -0x1c(%ebp)
  80081a:	ff 75 e0             	pushl  -0x20(%ebp)
  80081d:	ff 75 dc             	pushl  -0x24(%ebp)
  800820:	ff 75 d8             	pushl  -0x28(%ebp)
  800823:	e8 d8 1e 00 00       	call   802700 <__udivdi3>
  800828:	83 c4 18             	add    $0x18,%esp
  80082b:	52                   	push   %edx
  80082c:	50                   	push   %eax
  80082d:	89 f2                	mov    %esi,%edx
  80082f:	89 f8                	mov    %edi,%eax
  800831:	e8 9e ff ff ff       	call   8007d4 <printnum>
  800836:	83 c4 20             	add    $0x20,%esp
  800839:	eb 13                	jmp    80084e <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80083b:	83 ec 08             	sub    $0x8,%esp
  80083e:	56                   	push   %esi
  80083f:	ff 75 18             	pushl  0x18(%ebp)
  800842:	ff d7                	call   *%edi
  800844:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800847:	83 eb 01             	sub    $0x1,%ebx
  80084a:	85 db                	test   %ebx,%ebx
  80084c:	7f ed                	jg     80083b <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80084e:	83 ec 08             	sub    $0x8,%esp
  800851:	56                   	push   %esi
  800852:	83 ec 04             	sub    $0x4,%esp
  800855:	ff 75 e4             	pushl  -0x1c(%ebp)
  800858:	ff 75 e0             	pushl  -0x20(%ebp)
  80085b:	ff 75 dc             	pushl  -0x24(%ebp)
  80085e:	ff 75 d8             	pushl  -0x28(%ebp)
  800861:	e8 ba 1f 00 00       	call   802820 <__umoddi3>
  800866:	83 c4 14             	add    $0x14,%esp
  800869:	0f be 80 2f 2d 80 00 	movsbl 0x802d2f(%eax),%eax
  800870:	50                   	push   %eax
  800871:	ff d7                	call   *%edi
}
  800873:	83 c4 10             	add    $0x10,%esp
  800876:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800879:	5b                   	pop    %ebx
  80087a:	5e                   	pop    %esi
  80087b:	5f                   	pop    %edi
  80087c:	5d                   	pop    %ebp
  80087d:	c3                   	ret    
  80087e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800881:	eb c4                	jmp    800847 <printnum+0x73>

00800883 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800883:	55                   	push   %ebp
  800884:	89 e5                	mov    %esp,%ebp
  800886:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800889:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80088d:	8b 10                	mov    (%eax),%edx
  80088f:	3b 50 04             	cmp    0x4(%eax),%edx
  800892:	73 0a                	jae    80089e <sprintputch+0x1b>
		*b->buf++ = ch;
  800894:	8d 4a 01             	lea    0x1(%edx),%ecx
  800897:	89 08                	mov    %ecx,(%eax)
  800899:	8b 45 08             	mov    0x8(%ebp),%eax
  80089c:	88 02                	mov    %al,(%edx)
}
  80089e:	5d                   	pop    %ebp
  80089f:	c3                   	ret    

008008a0 <printfmt>:
{
  8008a0:	55                   	push   %ebp
  8008a1:	89 e5                	mov    %esp,%ebp
  8008a3:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8008a6:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8008a9:	50                   	push   %eax
  8008aa:	ff 75 10             	pushl  0x10(%ebp)
  8008ad:	ff 75 0c             	pushl  0xc(%ebp)
  8008b0:	ff 75 08             	pushl  0x8(%ebp)
  8008b3:	e8 05 00 00 00       	call   8008bd <vprintfmt>
}
  8008b8:	83 c4 10             	add    $0x10,%esp
  8008bb:	c9                   	leave  
  8008bc:	c3                   	ret    

008008bd <vprintfmt>:
{
  8008bd:	55                   	push   %ebp
  8008be:	89 e5                	mov    %esp,%ebp
  8008c0:	57                   	push   %edi
  8008c1:	56                   	push   %esi
  8008c2:	53                   	push   %ebx
  8008c3:	83 ec 2c             	sub    $0x2c,%esp
  8008c6:	8b 75 08             	mov    0x8(%ebp),%esi
  8008c9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8008cc:	8b 7d 10             	mov    0x10(%ebp),%edi
  8008cf:	e9 21 04 00 00       	jmp    800cf5 <vprintfmt+0x438>
		padc = ' ';
  8008d4:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8008d8:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8008df:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  8008e6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8008ed:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8008f2:	8d 47 01             	lea    0x1(%edi),%eax
  8008f5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008f8:	0f b6 17             	movzbl (%edi),%edx
  8008fb:	8d 42 dd             	lea    -0x23(%edx),%eax
  8008fe:	3c 55                	cmp    $0x55,%al
  800900:	0f 87 90 04 00 00    	ja     800d96 <vprintfmt+0x4d9>
  800906:	0f b6 c0             	movzbl %al,%eax
  800909:	ff 24 85 80 2e 80 00 	jmp    *0x802e80(,%eax,4)
  800910:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800913:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800917:	eb d9                	jmp    8008f2 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800919:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80091c:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800920:	eb d0                	jmp    8008f2 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800922:	0f b6 d2             	movzbl %dl,%edx
  800925:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800928:	b8 00 00 00 00       	mov    $0x0,%eax
  80092d:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800930:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800933:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800937:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80093a:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80093d:	83 f9 09             	cmp    $0x9,%ecx
  800940:	77 55                	ja     800997 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  800942:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800945:	eb e9                	jmp    800930 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  800947:	8b 45 14             	mov    0x14(%ebp),%eax
  80094a:	8b 00                	mov    (%eax),%eax
  80094c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80094f:	8b 45 14             	mov    0x14(%ebp),%eax
  800952:	8d 40 04             	lea    0x4(%eax),%eax
  800955:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800958:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80095b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80095f:	79 91                	jns    8008f2 <vprintfmt+0x35>
				width = precision, precision = -1;
  800961:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800964:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800967:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80096e:	eb 82                	jmp    8008f2 <vprintfmt+0x35>
  800970:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800973:	85 c0                	test   %eax,%eax
  800975:	ba 00 00 00 00       	mov    $0x0,%edx
  80097a:	0f 49 d0             	cmovns %eax,%edx
  80097d:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800980:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800983:	e9 6a ff ff ff       	jmp    8008f2 <vprintfmt+0x35>
  800988:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80098b:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800992:	e9 5b ff ff ff       	jmp    8008f2 <vprintfmt+0x35>
  800997:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80099a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80099d:	eb bc                	jmp    80095b <vprintfmt+0x9e>
			lflag++;
  80099f:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8009a2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8009a5:	e9 48 ff ff ff       	jmp    8008f2 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8009aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ad:	8d 78 04             	lea    0x4(%eax),%edi
  8009b0:	83 ec 08             	sub    $0x8,%esp
  8009b3:	53                   	push   %ebx
  8009b4:	ff 30                	pushl  (%eax)
  8009b6:	ff d6                	call   *%esi
			break;
  8009b8:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8009bb:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8009be:	e9 2f 03 00 00       	jmp    800cf2 <vprintfmt+0x435>
			err = va_arg(ap, int);
  8009c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c6:	8d 78 04             	lea    0x4(%eax),%edi
  8009c9:	8b 00                	mov    (%eax),%eax
  8009cb:	99                   	cltd   
  8009cc:	31 d0                	xor    %edx,%eax
  8009ce:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8009d0:	83 f8 0f             	cmp    $0xf,%eax
  8009d3:	7f 23                	jg     8009f8 <vprintfmt+0x13b>
  8009d5:	8b 14 85 e0 2f 80 00 	mov    0x802fe0(,%eax,4),%edx
  8009dc:	85 d2                	test   %edx,%edx
  8009de:	74 18                	je     8009f8 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  8009e0:	52                   	push   %edx
  8009e1:	68 56 31 80 00       	push   $0x803156
  8009e6:	53                   	push   %ebx
  8009e7:	56                   	push   %esi
  8009e8:	e8 b3 fe ff ff       	call   8008a0 <printfmt>
  8009ed:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8009f0:	89 7d 14             	mov    %edi,0x14(%ebp)
  8009f3:	e9 fa 02 00 00       	jmp    800cf2 <vprintfmt+0x435>
				printfmt(putch, putdat, "error %d", err);
  8009f8:	50                   	push   %eax
  8009f9:	68 47 2d 80 00       	push   $0x802d47
  8009fe:	53                   	push   %ebx
  8009ff:	56                   	push   %esi
  800a00:	e8 9b fe ff ff       	call   8008a0 <printfmt>
  800a05:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800a08:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800a0b:	e9 e2 02 00 00       	jmp    800cf2 <vprintfmt+0x435>
			if ((p = va_arg(ap, char *)) == NULL)
  800a10:	8b 45 14             	mov    0x14(%ebp),%eax
  800a13:	83 c0 04             	add    $0x4,%eax
  800a16:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800a19:	8b 45 14             	mov    0x14(%ebp),%eax
  800a1c:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800a1e:	85 ff                	test   %edi,%edi
  800a20:	b8 40 2d 80 00       	mov    $0x802d40,%eax
  800a25:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800a28:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a2c:	0f 8e bd 00 00 00    	jle    800aef <vprintfmt+0x232>
  800a32:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800a36:	75 0e                	jne    800a46 <vprintfmt+0x189>
  800a38:	89 75 08             	mov    %esi,0x8(%ebp)
  800a3b:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800a3e:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800a41:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800a44:	eb 6d                	jmp    800ab3 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a46:	83 ec 08             	sub    $0x8,%esp
  800a49:	ff 75 d0             	pushl  -0x30(%ebp)
  800a4c:	57                   	push   %edi
  800a4d:	e8 ec 03 00 00       	call   800e3e <strnlen>
  800a52:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800a55:	29 c1                	sub    %eax,%ecx
  800a57:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800a5a:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800a5d:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800a61:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800a64:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800a67:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800a69:	eb 0f                	jmp    800a7a <vprintfmt+0x1bd>
					putch(padc, putdat);
  800a6b:	83 ec 08             	sub    $0x8,%esp
  800a6e:	53                   	push   %ebx
  800a6f:	ff 75 e0             	pushl  -0x20(%ebp)
  800a72:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800a74:	83 ef 01             	sub    $0x1,%edi
  800a77:	83 c4 10             	add    $0x10,%esp
  800a7a:	85 ff                	test   %edi,%edi
  800a7c:	7f ed                	jg     800a6b <vprintfmt+0x1ae>
  800a7e:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800a81:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800a84:	85 c9                	test   %ecx,%ecx
  800a86:	b8 00 00 00 00       	mov    $0x0,%eax
  800a8b:	0f 49 c1             	cmovns %ecx,%eax
  800a8e:	29 c1                	sub    %eax,%ecx
  800a90:	89 75 08             	mov    %esi,0x8(%ebp)
  800a93:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800a96:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800a99:	89 cb                	mov    %ecx,%ebx
  800a9b:	eb 16                	jmp    800ab3 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  800a9d:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800aa1:	75 31                	jne    800ad4 <vprintfmt+0x217>
					putch(ch, putdat);
  800aa3:	83 ec 08             	sub    $0x8,%esp
  800aa6:	ff 75 0c             	pushl  0xc(%ebp)
  800aa9:	50                   	push   %eax
  800aaa:	ff 55 08             	call   *0x8(%ebp)
  800aad:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ab0:	83 eb 01             	sub    $0x1,%ebx
  800ab3:	83 c7 01             	add    $0x1,%edi
  800ab6:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800aba:	0f be c2             	movsbl %dl,%eax
  800abd:	85 c0                	test   %eax,%eax
  800abf:	74 59                	je     800b1a <vprintfmt+0x25d>
  800ac1:	85 f6                	test   %esi,%esi
  800ac3:	78 d8                	js     800a9d <vprintfmt+0x1e0>
  800ac5:	83 ee 01             	sub    $0x1,%esi
  800ac8:	79 d3                	jns    800a9d <vprintfmt+0x1e0>
  800aca:	89 df                	mov    %ebx,%edi
  800acc:	8b 75 08             	mov    0x8(%ebp),%esi
  800acf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800ad2:	eb 37                	jmp    800b0b <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  800ad4:	0f be d2             	movsbl %dl,%edx
  800ad7:	83 ea 20             	sub    $0x20,%edx
  800ada:	83 fa 5e             	cmp    $0x5e,%edx
  800add:	76 c4                	jbe    800aa3 <vprintfmt+0x1e6>
					putch('?', putdat);
  800adf:	83 ec 08             	sub    $0x8,%esp
  800ae2:	ff 75 0c             	pushl  0xc(%ebp)
  800ae5:	6a 3f                	push   $0x3f
  800ae7:	ff 55 08             	call   *0x8(%ebp)
  800aea:	83 c4 10             	add    $0x10,%esp
  800aed:	eb c1                	jmp    800ab0 <vprintfmt+0x1f3>
  800aef:	89 75 08             	mov    %esi,0x8(%ebp)
  800af2:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800af5:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800af8:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800afb:	eb b6                	jmp    800ab3 <vprintfmt+0x1f6>
				putch(' ', putdat);
  800afd:	83 ec 08             	sub    $0x8,%esp
  800b00:	53                   	push   %ebx
  800b01:	6a 20                	push   $0x20
  800b03:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800b05:	83 ef 01             	sub    $0x1,%edi
  800b08:	83 c4 10             	add    $0x10,%esp
  800b0b:	85 ff                	test   %edi,%edi
  800b0d:	7f ee                	jg     800afd <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  800b0f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800b12:	89 45 14             	mov    %eax,0x14(%ebp)
  800b15:	e9 d8 01 00 00       	jmp    800cf2 <vprintfmt+0x435>
  800b1a:	89 df                	mov    %ebx,%edi
  800b1c:	8b 75 08             	mov    0x8(%ebp),%esi
  800b1f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800b22:	eb e7                	jmp    800b0b <vprintfmt+0x24e>
	if (lflag >= 2)
  800b24:	83 f9 01             	cmp    $0x1,%ecx
  800b27:	7e 45                	jle    800b6e <vprintfmt+0x2b1>
		return va_arg(*ap, long long);
  800b29:	8b 45 14             	mov    0x14(%ebp),%eax
  800b2c:	8b 50 04             	mov    0x4(%eax),%edx
  800b2f:	8b 00                	mov    (%eax),%eax
  800b31:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b34:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b37:	8b 45 14             	mov    0x14(%ebp),%eax
  800b3a:	8d 40 08             	lea    0x8(%eax),%eax
  800b3d:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800b40:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b44:	79 62                	jns    800ba8 <vprintfmt+0x2eb>
				putch('-', putdat);
  800b46:	83 ec 08             	sub    $0x8,%esp
  800b49:	53                   	push   %ebx
  800b4a:	6a 2d                	push   $0x2d
  800b4c:	ff d6                	call   *%esi
				num = -(long long) num;
  800b4e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800b51:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800b54:	f7 d8                	neg    %eax
  800b56:	83 d2 00             	adc    $0x0,%edx
  800b59:	f7 da                	neg    %edx
  800b5b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b5e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b61:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800b64:	ba 0a 00 00 00       	mov    $0xa,%edx
  800b69:	e9 66 01 00 00       	jmp    800cd4 <vprintfmt+0x417>
	else if (lflag)
  800b6e:	85 c9                	test   %ecx,%ecx
  800b70:	75 1b                	jne    800b8d <vprintfmt+0x2d0>
		return va_arg(*ap, int);
  800b72:	8b 45 14             	mov    0x14(%ebp),%eax
  800b75:	8b 00                	mov    (%eax),%eax
  800b77:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b7a:	89 c1                	mov    %eax,%ecx
  800b7c:	c1 f9 1f             	sar    $0x1f,%ecx
  800b7f:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800b82:	8b 45 14             	mov    0x14(%ebp),%eax
  800b85:	8d 40 04             	lea    0x4(%eax),%eax
  800b88:	89 45 14             	mov    %eax,0x14(%ebp)
  800b8b:	eb b3                	jmp    800b40 <vprintfmt+0x283>
		return va_arg(*ap, long);
  800b8d:	8b 45 14             	mov    0x14(%ebp),%eax
  800b90:	8b 00                	mov    (%eax),%eax
  800b92:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b95:	89 c1                	mov    %eax,%ecx
  800b97:	c1 f9 1f             	sar    $0x1f,%ecx
  800b9a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800b9d:	8b 45 14             	mov    0x14(%ebp),%eax
  800ba0:	8d 40 04             	lea    0x4(%eax),%eax
  800ba3:	89 45 14             	mov    %eax,0x14(%ebp)
  800ba6:	eb 98                	jmp    800b40 <vprintfmt+0x283>
			base = 10;
  800ba8:	ba 0a 00 00 00       	mov    $0xa,%edx
  800bad:	e9 22 01 00 00       	jmp    800cd4 <vprintfmt+0x417>
	if (lflag >= 2)
  800bb2:	83 f9 01             	cmp    $0x1,%ecx
  800bb5:	7e 21                	jle    800bd8 <vprintfmt+0x31b>
		return va_arg(*ap, unsigned long long);
  800bb7:	8b 45 14             	mov    0x14(%ebp),%eax
  800bba:	8b 50 04             	mov    0x4(%eax),%edx
  800bbd:	8b 00                	mov    (%eax),%eax
  800bbf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800bc2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800bc5:	8b 45 14             	mov    0x14(%ebp),%eax
  800bc8:	8d 40 08             	lea    0x8(%eax),%eax
  800bcb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800bce:	ba 0a 00 00 00       	mov    $0xa,%edx
  800bd3:	e9 fc 00 00 00       	jmp    800cd4 <vprintfmt+0x417>
	else if (lflag)
  800bd8:	85 c9                	test   %ecx,%ecx
  800bda:	75 23                	jne    800bff <vprintfmt+0x342>
		return va_arg(*ap, unsigned int);
  800bdc:	8b 45 14             	mov    0x14(%ebp),%eax
  800bdf:	8b 00                	mov    (%eax),%eax
  800be1:	ba 00 00 00 00       	mov    $0x0,%edx
  800be6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800be9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800bec:	8b 45 14             	mov    0x14(%ebp),%eax
  800bef:	8d 40 04             	lea    0x4(%eax),%eax
  800bf2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800bf5:	ba 0a 00 00 00       	mov    $0xa,%edx
  800bfa:	e9 d5 00 00 00       	jmp    800cd4 <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  800bff:	8b 45 14             	mov    0x14(%ebp),%eax
  800c02:	8b 00                	mov    (%eax),%eax
  800c04:	ba 00 00 00 00       	mov    $0x0,%edx
  800c09:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c0c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800c0f:	8b 45 14             	mov    0x14(%ebp),%eax
  800c12:	8d 40 04             	lea    0x4(%eax),%eax
  800c15:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800c18:	ba 0a 00 00 00       	mov    $0xa,%edx
  800c1d:	e9 b2 00 00 00       	jmp    800cd4 <vprintfmt+0x417>
	if (lflag >= 2)
  800c22:	83 f9 01             	cmp    $0x1,%ecx
  800c25:	7e 42                	jle    800c69 <vprintfmt+0x3ac>
		return va_arg(*ap, unsigned long long);
  800c27:	8b 45 14             	mov    0x14(%ebp),%eax
  800c2a:	8b 50 04             	mov    0x4(%eax),%edx
  800c2d:	8b 00                	mov    (%eax),%eax
  800c2f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c32:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800c35:	8b 45 14             	mov    0x14(%ebp),%eax
  800c38:	8d 40 08             	lea    0x8(%eax),%eax
  800c3b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800c3e:	ba 08 00 00 00       	mov    $0x8,%edx
			if ((long long) num < 0) {
  800c43:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800c47:	0f 89 87 00 00 00    	jns    800cd4 <vprintfmt+0x417>
				putch('-', putdat);
  800c4d:	83 ec 08             	sub    $0x8,%esp
  800c50:	53                   	push   %ebx
  800c51:	6a 2d                	push   $0x2d
  800c53:	ff d6                	call   *%esi
				num = -(long long) num;
  800c55:	f7 5d d8             	negl   -0x28(%ebp)
  800c58:	83 55 dc 00          	adcl   $0x0,-0x24(%ebp)
  800c5c:	f7 5d dc             	negl   -0x24(%ebp)
  800c5f:	83 c4 10             	add    $0x10,%esp
			base = 8;
  800c62:	ba 08 00 00 00       	mov    $0x8,%edx
  800c67:	eb 6b                	jmp    800cd4 <vprintfmt+0x417>
	else if (lflag)
  800c69:	85 c9                	test   %ecx,%ecx
  800c6b:	75 1b                	jne    800c88 <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  800c6d:	8b 45 14             	mov    0x14(%ebp),%eax
  800c70:	8b 00                	mov    (%eax),%eax
  800c72:	ba 00 00 00 00       	mov    $0x0,%edx
  800c77:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c7a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800c7d:	8b 45 14             	mov    0x14(%ebp),%eax
  800c80:	8d 40 04             	lea    0x4(%eax),%eax
  800c83:	89 45 14             	mov    %eax,0x14(%ebp)
  800c86:	eb b6                	jmp    800c3e <vprintfmt+0x381>
		return va_arg(*ap, unsigned long);
  800c88:	8b 45 14             	mov    0x14(%ebp),%eax
  800c8b:	8b 00                	mov    (%eax),%eax
  800c8d:	ba 00 00 00 00       	mov    $0x0,%edx
  800c92:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c95:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800c98:	8b 45 14             	mov    0x14(%ebp),%eax
  800c9b:	8d 40 04             	lea    0x4(%eax),%eax
  800c9e:	89 45 14             	mov    %eax,0x14(%ebp)
  800ca1:	eb 9b                	jmp    800c3e <vprintfmt+0x381>
			putch('0', putdat);
  800ca3:	83 ec 08             	sub    $0x8,%esp
  800ca6:	53                   	push   %ebx
  800ca7:	6a 30                	push   $0x30
  800ca9:	ff d6                	call   *%esi
			putch('x', putdat);
  800cab:	83 c4 08             	add    $0x8,%esp
  800cae:	53                   	push   %ebx
  800caf:	6a 78                	push   $0x78
  800cb1:	ff d6                	call   *%esi
			num = (unsigned long long)
  800cb3:	8b 45 14             	mov    0x14(%ebp),%eax
  800cb6:	8b 00                	mov    (%eax),%eax
  800cb8:	ba 00 00 00 00       	mov    $0x0,%edx
  800cbd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800cc0:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800cc3:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800cc6:	8b 45 14             	mov    0x14(%ebp),%eax
  800cc9:	8d 40 04             	lea    0x4(%eax),%eax
  800ccc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800ccf:	ba 10 00 00 00       	mov    $0x10,%edx
			printnum(putch, putdat, num, base, width, padc);
  800cd4:	83 ec 0c             	sub    $0xc,%esp
  800cd7:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800cdb:	50                   	push   %eax
  800cdc:	ff 75 e0             	pushl  -0x20(%ebp)
  800cdf:	52                   	push   %edx
  800ce0:	ff 75 dc             	pushl  -0x24(%ebp)
  800ce3:	ff 75 d8             	pushl  -0x28(%ebp)
  800ce6:	89 da                	mov    %ebx,%edx
  800ce8:	89 f0                	mov    %esi,%eax
  800cea:	e8 e5 fa ff ff       	call   8007d4 <printnum>
			break;
  800cef:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800cf2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800cf5:	83 c7 01             	add    $0x1,%edi
  800cf8:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800cfc:	83 f8 25             	cmp    $0x25,%eax
  800cff:	0f 84 cf fb ff ff    	je     8008d4 <vprintfmt+0x17>
			if (ch == '\0')
  800d05:	85 c0                	test   %eax,%eax
  800d07:	0f 84 a9 00 00 00    	je     800db6 <vprintfmt+0x4f9>
			putch(ch, putdat);
  800d0d:	83 ec 08             	sub    $0x8,%esp
  800d10:	53                   	push   %ebx
  800d11:	50                   	push   %eax
  800d12:	ff d6                	call   *%esi
  800d14:	83 c4 10             	add    $0x10,%esp
  800d17:	eb dc                	jmp    800cf5 <vprintfmt+0x438>
	if (lflag >= 2)
  800d19:	83 f9 01             	cmp    $0x1,%ecx
  800d1c:	7e 1e                	jle    800d3c <vprintfmt+0x47f>
		return va_arg(*ap, unsigned long long);
  800d1e:	8b 45 14             	mov    0x14(%ebp),%eax
  800d21:	8b 50 04             	mov    0x4(%eax),%edx
  800d24:	8b 00                	mov    (%eax),%eax
  800d26:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800d29:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800d2c:	8b 45 14             	mov    0x14(%ebp),%eax
  800d2f:	8d 40 08             	lea    0x8(%eax),%eax
  800d32:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800d35:	ba 10 00 00 00       	mov    $0x10,%edx
  800d3a:	eb 98                	jmp    800cd4 <vprintfmt+0x417>
	else if (lflag)
  800d3c:	85 c9                	test   %ecx,%ecx
  800d3e:	75 23                	jne    800d63 <vprintfmt+0x4a6>
		return va_arg(*ap, unsigned int);
  800d40:	8b 45 14             	mov    0x14(%ebp),%eax
  800d43:	8b 00                	mov    (%eax),%eax
  800d45:	ba 00 00 00 00       	mov    $0x0,%edx
  800d4a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800d4d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800d50:	8b 45 14             	mov    0x14(%ebp),%eax
  800d53:	8d 40 04             	lea    0x4(%eax),%eax
  800d56:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800d59:	ba 10 00 00 00       	mov    $0x10,%edx
  800d5e:	e9 71 ff ff ff       	jmp    800cd4 <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  800d63:	8b 45 14             	mov    0x14(%ebp),%eax
  800d66:	8b 00                	mov    (%eax),%eax
  800d68:	ba 00 00 00 00       	mov    $0x0,%edx
  800d6d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800d70:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800d73:	8b 45 14             	mov    0x14(%ebp),%eax
  800d76:	8d 40 04             	lea    0x4(%eax),%eax
  800d79:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800d7c:	ba 10 00 00 00       	mov    $0x10,%edx
  800d81:	e9 4e ff ff ff       	jmp    800cd4 <vprintfmt+0x417>
			putch(ch, putdat);
  800d86:	83 ec 08             	sub    $0x8,%esp
  800d89:	53                   	push   %ebx
  800d8a:	6a 25                	push   $0x25
  800d8c:	ff d6                	call   *%esi
			break;
  800d8e:	83 c4 10             	add    $0x10,%esp
  800d91:	e9 5c ff ff ff       	jmp    800cf2 <vprintfmt+0x435>
			putch('%', putdat);
  800d96:	83 ec 08             	sub    $0x8,%esp
  800d99:	53                   	push   %ebx
  800d9a:	6a 25                	push   $0x25
  800d9c:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d9e:	83 c4 10             	add    $0x10,%esp
  800da1:	89 f8                	mov    %edi,%eax
  800da3:	eb 03                	jmp    800da8 <vprintfmt+0x4eb>
  800da5:	83 e8 01             	sub    $0x1,%eax
  800da8:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800dac:	75 f7                	jne    800da5 <vprintfmt+0x4e8>
  800dae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800db1:	e9 3c ff ff ff       	jmp    800cf2 <vprintfmt+0x435>
}
  800db6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800db9:	5b                   	pop    %ebx
  800dba:	5e                   	pop    %esi
  800dbb:	5f                   	pop    %edi
  800dbc:	5d                   	pop    %ebp
  800dbd:	c3                   	ret    

00800dbe <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800dbe:	55                   	push   %ebp
  800dbf:	89 e5                	mov    %esp,%ebp
  800dc1:	83 ec 18             	sub    $0x18,%esp
  800dc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc7:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800dca:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800dcd:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800dd1:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800dd4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ddb:	85 c0                	test   %eax,%eax
  800ddd:	74 26                	je     800e05 <vsnprintf+0x47>
  800ddf:	85 d2                	test   %edx,%edx
  800de1:	7e 22                	jle    800e05 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800de3:	ff 75 14             	pushl  0x14(%ebp)
  800de6:	ff 75 10             	pushl  0x10(%ebp)
  800de9:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800dec:	50                   	push   %eax
  800ded:	68 83 08 80 00       	push   $0x800883
  800df2:	e8 c6 fa ff ff       	call   8008bd <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800df7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800dfa:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800dfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e00:	83 c4 10             	add    $0x10,%esp
}
  800e03:	c9                   	leave  
  800e04:	c3                   	ret    
		return -E_INVAL;
  800e05:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e0a:	eb f7                	jmp    800e03 <vsnprintf+0x45>

00800e0c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e0c:	55                   	push   %ebp
  800e0d:	89 e5                	mov    %esp,%ebp
  800e0f:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e12:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800e15:	50                   	push   %eax
  800e16:	ff 75 10             	pushl  0x10(%ebp)
  800e19:	ff 75 0c             	pushl  0xc(%ebp)
  800e1c:	ff 75 08             	pushl  0x8(%ebp)
  800e1f:	e8 9a ff ff ff       	call   800dbe <vsnprintf>
	va_end(ap);

	return rc;
}
  800e24:	c9                   	leave  
  800e25:	c3                   	ret    

00800e26 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800e26:	55                   	push   %ebp
  800e27:	89 e5                	mov    %esp,%ebp
  800e29:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800e2c:	b8 00 00 00 00       	mov    $0x0,%eax
  800e31:	eb 03                	jmp    800e36 <strlen+0x10>
		n++;
  800e33:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800e36:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800e3a:	75 f7                	jne    800e33 <strlen+0xd>
	return n;
}
  800e3c:	5d                   	pop    %ebp
  800e3d:	c3                   	ret    

00800e3e <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800e3e:	55                   	push   %ebp
  800e3f:	89 e5                	mov    %esp,%ebp
  800e41:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e44:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e47:	b8 00 00 00 00       	mov    $0x0,%eax
  800e4c:	eb 03                	jmp    800e51 <strnlen+0x13>
		n++;
  800e4e:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e51:	39 d0                	cmp    %edx,%eax
  800e53:	74 06                	je     800e5b <strnlen+0x1d>
  800e55:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800e59:	75 f3                	jne    800e4e <strnlen+0x10>
	return n;
}
  800e5b:	5d                   	pop    %ebp
  800e5c:	c3                   	ret    

00800e5d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e5d:	55                   	push   %ebp
  800e5e:	89 e5                	mov    %esp,%ebp
  800e60:	53                   	push   %ebx
  800e61:	8b 45 08             	mov    0x8(%ebp),%eax
  800e64:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800e67:	89 c2                	mov    %eax,%edx
  800e69:	83 c1 01             	add    $0x1,%ecx
  800e6c:	83 c2 01             	add    $0x1,%edx
  800e6f:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800e73:	88 5a ff             	mov    %bl,-0x1(%edx)
  800e76:	84 db                	test   %bl,%bl
  800e78:	75 ef                	jne    800e69 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800e7a:	5b                   	pop    %ebx
  800e7b:	5d                   	pop    %ebp
  800e7c:	c3                   	ret    

00800e7d <strcat>:

char *
strcat(char *dst, const char *src)
{
  800e7d:	55                   	push   %ebp
  800e7e:	89 e5                	mov    %esp,%ebp
  800e80:	53                   	push   %ebx
  800e81:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800e84:	53                   	push   %ebx
  800e85:	e8 9c ff ff ff       	call   800e26 <strlen>
  800e8a:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800e8d:	ff 75 0c             	pushl  0xc(%ebp)
  800e90:	01 d8                	add    %ebx,%eax
  800e92:	50                   	push   %eax
  800e93:	e8 c5 ff ff ff       	call   800e5d <strcpy>
	return dst;
}
  800e98:	89 d8                	mov    %ebx,%eax
  800e9a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800e9d:	c9                   	leave  
  800e9e:	c3                   	ret    

00800e9f <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800e9f:	55                   	push   %ebp
  800ea0:	89 e5                	mov    %esp,%ebp
  800ea2:	56                   	push   %esi
  800ea3:	53                   	push   %ebx
  800ea4:	8b 75 08             	mov    0x8(%ebp),%esi
  800ea7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eaa:	89 f3                	mov    %esi,%ebx
  800eac:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800eaf:	89 f2                	mov    %esi,%edx
  800eb1:	eb 0f                	jmp    800ec2 <strncpy+0x23>
		*dst++ = *src;
  800eb3:	83 c2 01             	add    $0x1,%edx
  800eb6:	0f b6 01             	movzbl (%ecx),%eax
  800eb9:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800ebc:	80 39 01             	cmpb   $0x1,(%ecx)
  800ebf:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800ec2:	39 da                	cmp    %ebx,%edx
  800ec4:	75 ed                	jne    800eb3 <strncpy+0x14>
	}
	return ret;
}
  800ec6:	89 f0                	mov    %esi,%eax
  800ec8:	5b                   	pop    %ebx
  800ec9:	5e                   	pop    %esi
  800eca:	5d                   	pop    %ebp
  800ecb:	c3                   	ret    

00800ecc <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800ecc:	55                   	push   %ebp
  800ecd:	89 e5                	mov    %esp,%ebp
  800ecf:	56                   	push   %esi
  800ed0:	53                   	push   %ebx
  800ed1:	8b 75 08             	mov    0x8(%ebp),%esi
  800ed4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ed7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800eda:	89 f0                	mov    %esi,%eax
  800edc:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800ee0:	85 c9                	test   %ecx,%ecx
  800ee2:	75 0b                	jne    800eef <strlcpy+0x23>
  800ee4:	eb 17                	jmp    800efd <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800ee6:	83 c2 01             	add    $0x1,%edx
  800ee9:	83 c0 01             	add    $0x1,%eax
  800eec:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800eef:	39 d8                	cmp    %ebx,%eax
  800ef1:	74 07                	je     800efa <strlcpy+0x2e>
  800ef3:	0f b6 0a             	movzbl (%edx),%ecx
  800ef6:	84 c9                	test   %cl,%cl
  800ef8:	75 ec                	jne    800ee6 <strlcpy+0x1a>
		*dst = '\0';
  800efa:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800efd:	29 f0                	sub    %esi,%eax
}
  800eff:	5b                   	pop    %ebx
  800f00:	5e                   	pop    %esi
  800f01:	5d                   	pop    %ebp
  800f02:	c3                   	ret    

00800f03 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f03:	55                   	push   %ebp
  800f04:	89 e5                	mov    %esp,%ebp
  800f06:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f09:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800f0c:	eb 06                	jmp    800f14 <strcmp+0x11>
		p++, q++;
  800f0e:	83 c1 01             	add    $0x1,%ecx
  800f11:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800f14:	0f b6 01             	movzbl (%ecx),%eax
  800f17:	84 c0                	test   %al,%al
  800f19:	74 04                	je     800f1f <strcmp+0x1c>
  800f1b:	3a 02                	cmp    (%edx),%al
  800f1d:	74 ef                	je     800f0e <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f1f:	0f b6 c0             	movzbl %al,%eax
  800f22:	0f b6 12             	movzbl (%edx),%edx
  800f25:	29 d0                	sub    %edx,%eax
}
  800f27:	5d                   	pop    %ebp
  800f28:	c3                   	ret    

00800f29 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800f29:	55                   	push   %ebp
  800f2a:	89 e5                	mov    %esp,%ebp
  800f2c:	53                   	push   %ebx
  800f2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f30:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f33:	89 c3                	mov    %eax,%ebx
  800f35:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800f38:	eb 06                	jmp    800f40 <strncmp+0x17>
		n--, p++, q++;
  800f3a:	83 c0 01             	add    $0x1,%eax
  800f3d:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800f40:	39 d8                	cmp    %ebx,%eax
  800f42:	74 16                	je     800f5a <strncmp+0x31>
  800f44:	0f b6 08             	movzbl (%eax),%ecx
  800f47:	84 c9                	test   %cl,%cl
  800f49:	74 04                	je     800f4f <strncmp+0x26>
  800f4b:	3a 0a                	cmp    (%edx),%cl
  800f4d:	74 eb                	je     800f3a <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f4f:	0f b6 00             	movzbl (%eax),%eax
  800f52:	0f b6 12             	movzbl (%edx),%edx
  800f55:	29 d0                	sub    %edx,%eax
}
  800f57:	5b                   	pop    %ebx
  800f58:	5d                   	pop    %ebp
  800f59:	c3                   	ret    
		return 0;
  800f5a:	b8 00 00 00 00       	mov    $0x0,%eax
  800f5f:	eb f6                	jmp    800f57 <strncmp+0x2e>

00800f61 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f61:	55                   	push   %ebp
  800f62:	89 e5                	mov    %esp,%ebp
  800f64:	8b 45 08             	mov    0x8(%ebp),%eax
  800f67:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800f6b:	0f b6 10             	movzbl (%eax),%edx
  800f6e:	84 d2                	test   %dl,%dl
  800f70:	74 09                	je     800f7b <strchr+0x1a>
		if (*s == c)
  800f72:	38 ca                	cmp    %cl,%dl
  800f74:	74 0a                	je     800f80 <strchr+0x1f>
	for (; *s; s++)
  800f76:	83 c0 01             	add    $0x1,%eax
  800f79:	eb f0                	jmp    800f6b <strchr+0xa>
			return (char *) s;
	return 0;
  800f7b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f80:	5d                   	pop    %ebp
  800f81:	c3                   	ret    

00800f82 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f82:	55                   	push   %ebp
  800f83:	89 e5                	mov    %esp,%ebp
  800f85:	8b 45 08             	mov    0x8(%ebp),%eax
  800f88:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800f8c:	eb 03                	jmp    800f91 <strfind+0xf>
  800f8e:	83 c0 01             	add    $0x1,%eax
  800f91:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800f94:	38 ca                	cmp    %cl,%dl
  800f96:	74 04                	je     800f9c <strfind+0x1a>
  800f98:	84 d2                	test   %dl,%dl
  800f9a:	75 f2                	jne    800f8e <strfind+0xc>
			break;
	return (char *) s;
}
  800f9c:	5d                   	pop    %ebp
  800f9d:	c3                   	ret    

00800f9e <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800f9e:	55                   	push   %ebp
  800f9f:	89 e5                	mov    %esp,%ebp
  800fa1:	57                   	push   %edi
  800fa2:	56                   	push   %esi
  800fa3:	53                   	push   %ebx
  800fa4:	8b 7d 08             	mov    0x8(%ebp),%edi
  800fa7:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800faa:	85 c9                	test   %ecx,%ecx
  800fac:	74 13                	je     800fc1 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800fae:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800fb4:	75 05                	jne    800fbb <memset+0x1d>
  800fb6:	f6 c1 03             	test   $0x3,%cl
  800fb9:	74 0d                	je     800fc8 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800fbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fbe:	fc                   	cld    
  800fbf:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800fc1:	89 f8                	mov    %edi,%eax
  800fc3:	5b                   	pop    %ebx
  800fc4:	5e                   	pop    %esi
  800fc5:	5f                   	pop    %edi
  800fc6:	5d                   	pop    %ebp
  800fc7:	c3                   	ret    
		c &= 0xFF;
  800fc8:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800fcc:	89 d3                	mov    %edx,%ebx
  800fce:	c1 e3 08             	shl    $0x8,%ebx
  800fd1:	89 d0                	mov    %edx,%eax
  800fd3:	c1 e0 18             	shl    $0x18,%eax
  800fd6:	89 d6                	mov    %edx,%esi
  800fd8:	c1 e6 10             	shl    $0x10,%esi
  800fdb:	09 f0                	or     %esi,%eax
  800fdd:	09 c2                	or     %eax,%edx
  800fdf:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800fe1:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800fe4:	89 d0                	mov    %edx,%eax
  800fe6:	fc                   	cld    
  800fe7:	f3 ab                	rep stos %eax,%es:(%edi)
  800fe9:	eb d6                	jmp    800fc1 <memset+0x23>

00800feb <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800feb:	55                   	push   %ebp
  800fec:	89 e5                	mov    %esp,%ebp
  800fee:	57                   	push   %edi
  800fef:	56                   	push   %esi
  800ff0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff3:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ff6:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ff9:	39 c6                	cmp    %eax,%esi
  800ffb:	73 35                	jae    801032 <memmove+0x47>
  800ffd:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801000:	39 c2                	cmp    %eax,%edx
  801002:	76 2e                	jbe    801032 <memmove+0x47>
		s += n;
		d += n;
  801004:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801007:	89 d6                	mov    %edx,%esi
  801009:	09 fe                	or     %edi,%esi
  80100b:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801011:	74 0c                	je     80101f <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801013:	83 ef 01             	sub    $0x1,%edi
  801016:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  801019:	fd                   	std    
  80101a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80101c:	fc                   	cld    
  80101d:	eb 21                	jmp    801040 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80101f:	f6 c1 03             	test   $0x3,%cl
  801022:	75 ef                	jne    801013 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801024:	83 ef 04             	sub    $0x4,%edi
  801027:	8d 72 fc             	lea    -0x4(%edx),%esi
  80102a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  80102d:	fd                   	std    
  80102e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801030:	eb ea                	jmp    80101c <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801032:	89 f2                	mov    %esi,%edx
  801034:	09 c2                	or     %eax,%edx
  801036:	f6 c2 03             	test   $0x3,%dl
  801039:	74 09                	je     801044 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80103b:	89 c7                	mov    %eax,%edi
  80103d:	fc                   	cld    
  80103e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801040:	5e                   	pop    %esi
  801041:	5f                   	pop    %edi
  801042:	5d                   	pop    %ebp
  801043:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801044:	f6 c1 03             	test   $0x3,%cl
  801047:	75 f2                	jne    80103b <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801049:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  80104c:	89 c7                	mov    %eax,%edi
  80104e:	fc                   	cld    
  80104f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801051:	eb ed                	jmp    801040 <memmove+0x55>

00801053 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801053:	55                   	push   %ebp
  801054:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  801056:	ff 75 10             	pushl  0x10(%ebp)
  801059:	ff 75 0c             	pushl  0xc(%ebp)
  80105c:	ff 75 08             	pushl  0x8(%ebp)
  80105f:	e8 87 ff ff ff       	call   800feb <memmove>
}
  801064:	c9                   	leave  
  801065:	c3                   	ret    

00801066 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801066:	55                   	push   %ebp
  801067:	89 e5                	mov    %esp,%ebp
  801069:	56                   	push   %esi
  80106a:	53                   	push   %ebx
  80106b:	8b 45 08             	mov    0x8(%ebp),%eax
  80106e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801071:	89 c6                	mov    %eax,%esi
  801073:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801076:	39 f0                	cmp    %esi,%eax
  801078:	74 1c                	je     801096 <memcmp+0x30>
		if (*s1 != *s2)
  80107a:	0f b6 08             	movzbl (%eax),%ecx
  80107d:	0f b6 1a             	movzbl (%edx),%ebx
  801080:	38 d9                	cmp    %bl,%cl
  801082:	75 08                	jne    80108c <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801084:	83 c0 01             	add    $0x1,%eax
  801087:	83 c2 01             	add    $0x1,%edx
  80108a:	eb ea                	jmp    801076 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  80108c:	0f b6 c1             	movzbl %cl,%eax
  80108f:	0f b6 db             	movzbl %bl,%ebx
  801092:	29 d8                	sub    %ebx,%eax
  801094:	eb 05                	jmp    80109b <memcmp+0x35>
	}

	return 0;
  801096:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80109b:	5b                   	pop    %ebx
  80109c:	5e                   	pop    %esi
  80109d:	5d                   	pop    %ebp
  80109e:	c3                   	ret    

0080109f <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80109f:	55                   	push   %ebp
  8010a0:	89 e5                	mov    %esp,%ebp
  8010a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8010a8:	89 c2                	mov    %eax,%edx
  8010aa:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8010ad:	39 d0                	cmp    %edx,%eax
  8010af:	73 09                	jae    8010ba <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  8010b1:	38 08                	cmp    %cl,(%eax)
  8010b3:	74 05                	je     8010ba <memfind+0x1b>
	for (; s < ends; s++)
  8010b5:	83 c0 01             	add    $0x1,%eax
  8010b8:	eb f3                	jmp    8010ad <memfind+0xe>
			break;
	return (void *) s;
}
  8010ba:	5d                   	pop    %ebp
  8010bb:	c3                   	ret    

008010bc <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8010bc:	55                   	push   %ebp
  8010bd:	89 e5                	mov    %esp,%ebp
  8010bf:	57                   	push   %edi
  8010c0:	56                   	push   %esi
  8010c1:	53                   	push   %ebx
  8010c2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010c5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010c8:	eb 03                	jmp    8010cd <strtol+0x11>
		s++;
  8010ca:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  8010cd:	0f b6 01             	movzbl (%ecx),%eax
  8010d0:	3c 20                	cmp    $0x20,%al
  8010d2:	74 f6                	je     8010ca <strtol+0xe>
  8010d4:	3c 09                	cmp    $0x9,%al
  8010d6:	74 f2                	je     8010ca <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  8010d8:	3c 2b                	cmp    $0x2b,%al
  8010da:	74 2e                	je     80110a <strtol+0x4e>
	int neg = 0;
  8010dc:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  8010e1:	3c 2d                	cmp    $0x2d,%al
  8010e3:	74 2f                	je     801114 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010e5:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  8010eb:	75 05                	jne    8010f2 <strtol+0x36>
  8010ed:	80 39 30             	cmpb   $0x30,(%ecx)
  8010f0:	74 2c                	je     80111e <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  8010f2:	85 db                	test   %ebx,%ebx
  8010f4:	75 0a                	jne    801100 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8010f6:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  8010fb:	80 39 30             	cmpb   $0x30,(%ecx)
  8010fe:	74 28                	je     801128 <strtol+0x6c>
		base = 10;
  801100:	b8 00 00 00 00       	mov    $0x0,%eax
  801105:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801108:	eb 50                	jmp    80115a <strtol+0x9e>
		s++;
  80110a:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  80110d:	bf 00 00 00 00       	mov    $0x0,%edi
  801112:	eb d1                	jmp    8010e5 <strtol+0x29>
		s++, neg = 1;
  801114:	83 c1 01             	add    $0x1,%ecx
  801117:	bf 01 00 00 00       	mov    $0x1,%edi
  80111c:	eb c7                	jmp    8010e5 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80111e:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801122:	74 0e                	je     801132 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  801124:	85 db                	test   %ebx,%ebx
  801126:	75 d8                	jne    801100 <strtol+0x44>
		s++, base = 8;
  801128:	83 c1 01             	add    $0x1,%ecx
  80112b:	bb 08 00 00 00       	mov    $0x8,%ebx
  801130:	eb ce                	jmp    801100 <strtol+0x44>
		s += 2, base = 16;
  801132:	83 c1 02             	add    $0x2,%ecx
  801135:	bb 10 00 00 00       	mov    $0x10,%ebx
  80113a:	eb c4                	jmp    801100 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  80113c:	8d 72 9f             	lea    -0x61(%edx),%esi
  80113f:	89 f3                	mov    %esi,%ebx
  801141:	80 fb 19             	cmp    $0x19,%bl
  801144:	77 29                	ja     80116f <strtol+0xb3>
			dig = *s - 'a' + 10;
  801146:	0f be d2             	movsbl %dl,%edx
  801149:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  80114c:	3b 55 10             	cmp    0x10(%ebp),%edx
  80114f:	7d 30                	jge    801181 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  801151:	83 c1 01             	add    $0x1,%ecx
  801154:	0f af 45 10          	imul   0x10(%ebp),%eax
  801158:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  80115a:	0f b6 11             	movzbl (%ecx),%edx
  80115d:	8d 72 d0             	lea    -0x30(%edx),%esi
  801160:	89 f3                	mov    %esi,%ebx
  801162:	80 fb 09             	cmp    $0x9,%bl
  801165:	77 d5                	ja     80113c <strtol+0x80>
			dig = *s - '0';
  801167:	0f be d2             	movsbl %dl,%edx
  80116a:	83 ea 30             	sub    $0x30,%edx
  80116d:	eb dd                	jmp    80114c <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  80116f:	8d 72 bf             	lea    -0x41(%edx),%esi
  801172:	89 f3                	mov    %esi,%ebx
  801174:	80 fb 19             	cmp    $0x19,%bl
  801177:	77 08                	ja     801181 <strtol+0xc5>
			dig = *s - 'A' + 10;
  801179:	0f be d2             	movsbl %dl,%edx
  80117c:	83 ea 37             	sub    $0x37,%edx
  80117f:	eb cb                	jmp    80114c <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  801181:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801185:	74 05                	je     80118c <strtol+0xd0>
		*endptr = (char *) s;
  801187:	8b 75 0c             	mov    0xc(%ebp),%esi
  80118a:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  80118c:	89 c2                	mov    %eax,%edx
  80118e:	f7 da                	neg    %edx
  801190:	85 ff                	test   %edi,%edi
  801192:	0f 45 c2             	cmovne %edx,%eax
}
  801195:	5b                   	pop    %ebx
  801196:	5e                   	pop    %esi
  801197:	5f                   	pop    %edi
  801198:	5d                   	pop    %ebp
  801199:	c3                   	ret    

0080119a <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  80119a:	55                   	push   %ebp
  80119b:	89 e5                	mov    %esp,%ebp
  80119d:	57                   	push   %edi
  80119e:	56                   	push   %esi
  80119f:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8011a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8011a8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011ab:	89 c3                	mov    %eax,%ebx
  8011ad:	89 c7                	mov    %eax,%edi
  8011af:	89 c6                	mov    %eax,%esi
  8011b1:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8011b3:	5b                   	pop    %ebx
  8011b4:	5e                   	pop    %esi
  8011b5:	5f                   	pop    %edi
  8011b6:	5d                   	pop    %ebp
  8011b7:	c3                   	ret    

008011b8 <sys_cgetc>:

int
sys_cgetc(void)
{
  8011b8:	55                   	push   %ebp
  8011b9:	89 e5                	mov    %esp,%ebp
  8011bb:	57                   	push   %edi
  8011bc:	56                   	push   %esi
  8011bd:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011be:	ba 00 00 00 00       	mov    $0x0,%edx
  8011c3:	b8 01 00 00 00       	mov    $0x1,%eax
  8011c8:	89 d1                	mov    %edx,%ecx
  8011ca:	89 d3                	mov    %edx,%ebx
  8011cc:	89 d7                	mov    %edx,%edi
  8011ce:	89 d6                	mov    %edx,%esi
  8011d0:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8011d2:	5b                   	pop    %ebx
  8011d3:	5e                   	pop    %esi
  8011d4:	5f                   	pop    %edi
  8011d5:	5d                   	pop    %ebp
  8011d6:	c3                   	ret    

008011d7 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8011d7:	55                   	push   %ebp
  8011d8:	89 e5                	mov    %esp,%ebp
  8011da:	57                   	push   %edi
  8011db:	56                   	push   %esi
  8011dc:	53                   	push   %ebx
  8011dd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011e0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8011e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8011e8:	b8 03 00 00 00       	mov    $0x3,%eax
  8011ed:	89 cb                	mov    %ecx,%ebx
  8011ef:	89 cf                	mov    %ecx,%edi
  8011f1:	89 ce                	mov    %ecx,%esi
  8011f3:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011f5:	85 c0                	test   %eax,%eax
  8011f7:	7f 08                	jg     801201 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8011f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011fc:	5b                   	pop    %ebx
  8011fd:	5e                   	pop    %esi
  8011fe:	5f                   	pop    %edi
  8011ff:	5d                   	pop    %ebp
  801200:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801201:	83 ec 0c             	sub    $0xc,%esp
  801204:	50                   	push   %eax
  801205:	6a 03                	push   $0x3
  801207:	68 3f 30 80 00       	push   $0x80303f
  80120c:	6a 23                	push   $0x23
  80120e:	68 5c 30 80 00       	push   $0x80305c
  801213:	e8 cd f4 ff ff       	call   8006e5 <_panic>

00801218 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801218:	55                   	push   %ebp
  801219:	89 e5                	mov    %esp,%ebp
  80121b:	57                   	push   %edi
  80121c:	56                   	push   %esi
  80121d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80121e:	ba 00 00 00 00       	mov    $0x0,%edx
  801223:	b8 02 00 00 00       	mov    $0x2,%eax
  801228:	89 d1                	mov    %edx,%ecx
  80122a:	89 d3                	mov    %edx,%ebx
  80122c:	89 d7                	mov    %edx,%edi
  80122e:	89 d6                	mov    %edx,%esi
  801230:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801232:	5b                   	pop    %ebx
  801233:	5e                   	pop    %esi
  801234:	5f                   	pop    %edi
  801235:	5d                   	pop    %ebp
  801236:	c3                   	ret    

00801237 <sys_yield>:

void
sys_yield(void)
{
  801237:	55                   	push   %ebp
  801238:	89 e5                	mov    %esp,%ebp
  80123a:	57                   	push   %edi
  80123b:	56                   	push   %esi
  80123c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80123d:	ba 00 00 00 00       	mov    $0x0,%edx
  801242:	b8 0b 00 00 00       	mov    $0xb,%eax
  801247:	89 d1                	mov    %edx,%ecx
  801249:	89 d3                	mov    %edx,%ebx
  80124b:	89 d7                	mov    %edx,%edi
  80124d:	89 d6                	mov    %edx,%esi
  80124f:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801251:	5b                   	pop    %ebx
  801252:	5e                   	pop    %esi
  801253:	5f                   	pop    %edi
  801254:	5d                   	pop    %ebp
  801255:	c3                   	ret    

00801256 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801256:	55                   	push   %ebp
  801257:	89 e5                	mov    %esp,%ebp
  801259:	57                   	push   %edi
  80125a:	56                   	push   %esi
  80125b:	53                   	push   %ebx
  80125c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80125f:	be 00 00 00 00       	mov    $0x0,%esi
  801264:	8b 55 08             	mov    0x8(%ebp),%edx
  801267:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80126a:	b8 04 00 00 00       	mov    $0x4,%eax
  80126f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801272:	89 f7                	mov    %esi,%edi
  801274:	cd 30                	int    $0x30
	if(check && ret > 0)
  801276:	85 c0                	test   %eax,%eax
  801278:	7f 08                	jg     801282 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80127a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80127d:	5b                   	pop    %ebx
  80127e:	5e                   	pop    %esi
  80127f:	5f                   	pop    %edi
  801280:	5d                   	pop    %ebp
  801281:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801282:	83 ec 0c             	sub    $0xc,%esp
  801285:	50                   	push   %eax
  801286:	6a 04                	push   $0x4
  801288:	68 3f 30 80 00       	push   $0x80303f
  80128d:	6a 23                	push   $0x23
  80128f:	68 5c 30 80 00       	push   $0x80305c
  801294:	e8 4c f4 ff ff       	call   8006e5 <_panic>

00801299 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801299:	55                   	push   %ebp
  80129a:	89 e5                	mov    %esp,%ebp
  80129c:	57                   	push   %edi
  80129d:	56                   	push   %esi
  80129e:	53                   	push   %ebx
  80129f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8012a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8012a5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012a8:	b8 05 00 00 00       	mov    $0x5,%eax
  8012ad:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8012b0:	8b 7d 14             	mov    0x14(%ebp),%edi
  8012b3:	8b 75 18             	mov    0x18(%ebp),%esi
  8012b6:	cd 30                	int    $0x30
	if(check && ret > 0)
  8012b8:	85 c0                	test   %eax,%eax
  8012ba:	7f 08                	jg     8012c4 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8012bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012bf:	5b                   	pop    %ebx
  8012c0:	5e                   	pop    %esi
  8012c1:	5f                   	pop    %edi
  8012c2:	5d                   	pop    %ebp
  8012c3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8012c4:	83 ec 0c             	sub    $0xc,%esp
  8012c7:	50                   	push   %eax
  8012c8:	6a 05                	push   $0x5
  8012ca:	68 3f 30 80 00       	push   $0x80303f
  8012cf:	6a 23                	push   $0x23
  8012d1:	68 5c 30 80 00       	push   $0x80305c
  8012d6:	e8 0a f4 ff ff       	call   8006e5 <_panic>

008012db <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8012db:	55                   	push   %ebp
  8012dc:	89 e5                	mov    %esp,%ebp
  8012de:	57                   	push   %edi
  8012df:	56                   	push   %esi
  8012e0:	53                   	push   %ebx
  8012e1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8012e4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8012ec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012ef:	b8 06 00 00 00       	mov    $0x6,%eax
  8012f4:	89 df                	mov    %ebx,%edi
  8012f6:	89 de                	mov    %ebx,%esi
  8012f8:	cd 30                	int    $0x30
	if(check && ret > 0)
  8012fa:	85 c0                	test   %eax,%eax
  8012fc:	7f 08                	jg     801306 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8012fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801301:	5b                   	pop    %ebx
  801302:	5e                   	pop    %esi
  801303:	5f                   	pop    %edi
  801304:	5d                   	pop    %ebp
  801305:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801306:	83 ec 0c             	sub    $0xc,%esp
  801309:	50                   	push   %eax
  80130a:	6a 06                	push   $0x6
  80130c:	68 3f 30 80 00       	push   $0x80303f
  801311:	6a 23                	push   $0x23
  801313:	68 5c 30 80 00       	push   $0x80305c
  801318:	e8 c8 f3 ff ff       	call   8006e5 <_panic>

0080131d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80131d:	55                   	push   %ebp
  80131e:	89 e5                	mov    %esp,%ebp
  801320:	57                   	push   %edi
  801321:	56                   	push   %esi
  801322:	53                   	push   %ebx
  801323:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801326:	bb 00 00 00 00       	mov    $0x0,%ebx
  80132b:	8b 55 08             	mov    0x8(%ebp),%edx
  80132e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801331:	b8 08 00 00 00       	mov    $0x8,%eax
  801336:	89 df                	mov    %ebx,%edi
  801338:	89 de                	mov    %ebx,%esi
  80133a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80133c:	85 c0                	test   %eax,%eax
  80133e:	7f 08                	jg     801348 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801340:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801343:	5b                   	pop    %ebx
  801344:	5e                   	pop    %esi
  801345:	5f                   	pop    %edi
  801346:	5d                   	pop    %ebp
  801347:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801348:	83 ec 0c             	sub    $0xc,%esp
  80134b:	50                   	push   %eax
  80134c:	6a 08                	push   $0x8
  80134e:	68 3f 30 80 00       	push   $0x80303f
  801353:	6a 23                	push   $0x23
  801355:	68 5c 30 80 00       	push   $0x80305c
  80135a:	e8 86 f3 ff ff       	call   8006e5 <_panic>

0080135f <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80135f:	55                   	push   %ebp
  801360:	89 e5                	mov    %esp,%ebp
  801362:	57                   	push   %edi
  801363:	56                   	push   %esi
  801364:	53                   	push   %ebx
  801365:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801368:	bb 00 00 00 00       	mov    $0x0,%ebx
  80136d:	8b 55 08             	mov    0x8(%ebp),%edx
  801370:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801373:	b8 09 00 00 00       	mov    $0x9,%eax
  801378:	89 df                	mov    %ebx,%edi
  80137a:	89 de                	mov    %ebx,%esi
  80137c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80137e:	85 c0                	test   %eax,%eax
  801380:	7f 08                	jg     80138a <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801382:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801385:	5b                   	pop    %ebx
  801386:	5e                   	pop    %esi
  801387:	5f                   	pop    %edi
  801388:	5d                   	pop    %ebp
  801389:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80138a:	83 ec 0c             	sub    $0xc,%esp
  80138d:	50                   	push   %eax
  80138e:	6a 09                	push   $0x9
  801390:	68 3f 30 80 00       	push   $0x80303f
  801395:	6a 23                	push   $0x23
  801397:	68 5c 30 80 00       	push   $0x80305c
  80139c:	e8 44 f3 ff ff       	call   8006e5 <_panic>

008013a1 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8013a1:	55                   	push   %ebp
  8013a2:	89 e5                	mov    %esp,%ebp
  8013a4:	57                   	push   %edi
  8013a5:	56                   	push   %esi
  8013a6:	53                   	push   %ebx
  8013a7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8013aa:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013af:	8b 55 08             	mov    0x8(%ebp),%edx
  8013b2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013b5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8013ba:	89 df                	mov    %ebx,%edi
  8013bc:	89 de                	mov    %ebx,%esi
  8013be:	cd 30                	int    $0x30
	if(check && ret > 0)
  8013c0:	85 c0                	test   %eax,%eax
  8013c2:	7f 08                	jg     8013cc <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8013c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013c7:	5b                   	pop    %ebx
  8013c8:	5e                   	pop    %esi
  8013c9:	5f                   	pop    %edi
  8013ca:	5d                   	pop    %ebp
  8013cb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8013cc:	83 ec 0c             	sub    $0xc,%esp
  8013cf:	50                   	push   %eax
  8013d0:	6a 0a                	push   $0xa
  8013d2:	68 3f 30 80 00       	push   $0x80303f
  8013d7:	6a 23                	push   $0x23
  8013d9:	68 5c 30 80 00       	push   $0x80305c
  8013de:	e8 02 f3 ff ff       	call   8006e5 <_panic>

008013e3 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8013e3:	55                   	push   %ebp
  8013e4:	89 e5                	mov    %esp,%ebp
  8013e6:	57                   	push   %edi
  8013e7:	56                   	push   %esi
  8013e8:	53                   	push   %ebx
	asm volatile("int %1\n"
  8013e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8013ec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013ef:	b8 0c 00 00 00       	mov    $0xc,%eax
  8013f4:	be 00 00 00 00       	mov    $0x0,%esi
  8013f9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8013fc:	8b 7d 14             	mov    0x14(%ebp),%edi
  8013ff:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801401:	5b                   	pop    %ebx
  801402:	5e                   	pop    %esi
  801403:	5f                   	pop    %edi
  801404:	5d                   	pop    %ebp
  801405:	c3                   	ret    

00801406 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801406:	55                   	push   %ebp
  801407:	89 e5                	mov    %esp,%ebp
  801409:	57                   	push   %edi
  80140a:	56                   	push   %esi
  80140b:	53                   	push   %ebx
  80140c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80140f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801414:	8b 55 08             	mov    0x8(%ebp),%edx
  801417:	b8 0d 00 00 00       	mov    $0xd,%eax
  80141c:	89 cb                	mov    %ecx,%ebx
  80141e:	89 cf                	mov    %ecx,%edi
  801420:	89 ce                	mov    %ecx,%esi
  801422:	cd 30                	int    $0x30
	if(check && ret > 0)
  801424:	85 c0                	test   %eax,%eax
  801426:	7f 08                	jg     801430 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801428:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80142b:	5b                   	pop    %ebx
  80142c:	5e                   	pop    %esi
  80142d:	5f                   	pop    %edi
  80142e:	5d                   	pop    %ebp
  80142f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801430:	83 ec 0c             	sub    $0xc,%esp
  801433:	50                   	push   %eax
  801434:	6a 0d                	push   $0xd
  801436:	68 3f 30 80 00       	push   $0x80303f
  80143b:	6a 23                	push   $0x23
  80143d:	68 5c 30 80 00       	push   $0x80305c
  801442:	e8 9e f2 ff ff       	call   8006e5 <_panic>

00801447 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801447:	55                   	push   %ebp
  801448:	89 e5                	mov    %esp,%ebp
  80144a:	57                   	push   %edi
  80144b:	56                   	push   %esi
  80144c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80144d:	ba 00 00 00 00       	mov    $0x0,%edx
  801452:	b8 0e 00 00 00       	mov    $0xe,%eax
  801457:	89 d1                	mov    %edx,%ecx
  801459:	89 d3                	mov    %edx,%ebx
  80145b:	89 d7                	mov    %edx,%edi
  80145d:	89 d6                	mov    %edx,%esi
  80145f:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801461:	5b                   	pop    %ebx
  801462:	5e                   	pop    %esi
  801463:	5f                   	pop    %edi
  801464:	5d                   	pop    %ebp
  801465:	c3                   	ret    

00801466 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801466:	55                   	push   %ebp
  801467:	89 e5                	mov    %esp,%ebp
  801469:	56                   	push   %esi
  80146a:	53                   	push   %ebx
  80146b:	8b 75 08             	mov    0x8(%ebp),%esi
  80146e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801471:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
  801474:	85 c0                	test   %eax,%eax
	    pg = (void *)UTOP;
  801476:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80147b:	0f 44 c2             	cmove  %edx,%eax
	}
	if ((r = sys_ipc_recv(pg)) < 0) {
  80147e:	83 ec 0c             	sub    $0xc,%esp
  801481:	50                   	push   %eax
  801482:	e8 7f ff ff ff       	call   801406 <sys_ipc_recv>
  801487:	83 c4 10             	add    $0x10,%esp
  80148a:	85 c0                	test   %eax,%eax
  80148c:	78 2b                	js     8014b9 <ipc_recv+0x53>
	    if (perm_store != NULL) {
	        *perm_store = 0;
	    }
	    return r;
	}
	if (from_env_store != NULL) {
  80148e:	85 f6                	test   %esi,%esi
  801490:	74 0a                	je     80149c <ipc_recv+0x36>
	    *from_env_store = thisenv->env_ipc_from;
  801492:	a1 08 50 80 00       	mov    0x805008,%eax
  801497:	8b 40 74             	mov    0x74(%eax),%eax
  80149a:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store != NULL) {
  80149c:	85 db                	test   %ebx,%ebx
  80149e:	74 0a                	je     8014aa <ipc_recv+0x44>
	    *perm_store = thisenv->env_ipc_perm;
  8014a0:	a1 08 50 80 00       	mov    0x805008,%eax
  8014a5:	8b 40 78             	mov    0x78(%eax),%eax
  8014a8:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  8014aa:	a1 08 50 80 00       	mov    0x805008,%eax
  8014af:	8b 40 70             	mov    0x70(%eax),%eax
}
  8014b2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014b5:	5b                   	pop    %ebx
  8014b6:	5e                   	pop    %esi
  8014b7:	5d                   	pop    %ebp
  8014b8:	c3                   	ret    
	    if (from_env_store != NULL) {
  8014b9:	85 f6                	test   %esi,%esi
  8014bb:	74 06                	je     8014c3 <ipc_recv+0x5d>
	        *from_env_store = 0;
  8014bd:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	    if (perm_store != NULL) {
  8014c3:	85 db                	test   %ebx,%ebx
  8014c5:	74 eb                	je     8014b2 <ipc_recv+0x4c>
	        *perm_store = 0;
  8014c7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8014cd:	eb e3                	jmp    8014b2 <ipc_recv+0x4c>

008014cf <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8014cf:	55                   	push   %ebp
  8014d0:	89 e5                	mov    %esp,%ebp
  8014d2:	57                   	push   %edi
  8014d3:	56                   	push   %esi
  8014d4:	53                   	push   %ebx
  8014d5:	83 ec 0c             	sub    $0xc,%esp
  8014d8:	8b 7d 08             	mov    0x8(%ebp),%edi
  8014db:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
	    pg = (void *)UTOP;
  8014de:	85 f6                	test   %esi,%esi
  8014e0:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8014e5:	0f 44 f0             	cmove  %eax,%esi
  8014e8:	eb 09                	jmp    8014f3 <ipc_send+0x24>
	do {
	    r = sys_ipc_try_send(to_env, val, pg, perm);
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
	        panic("ipc_send: %e", r);
	    }
	    sys_yield();
  8014ea:	e8 48 fd ff ff       	call   801237 <sys_yield>
	} while(r != 0);
  8014ef:	85 db                	test   %ebx,%ebx
  8014f1:	74 2d                	je     801520 <ipc_send+0x51>
	    r = sys_ipc_try_send(to_env, val, pg, perm);
  8014f3:	ff 75 14             	pushl  0x14(%ebp)
  8014f6:	56                   	push   %esi
  8014f7:	ff 75 0c             	pushl  0xc(%ebp)
  8014fa:	57                   	push   %edi
  8014fb:	e8 e3 fe ff ff       	call   8013e3 <sys_ipc_try_send>
  801500:	89 c3                	mov    %eax,%ebx
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
  801502:	83 c4 10             	add    $0x10,%esp
  801505:	85 c0                	test   %eax,%eax
  801507:	79 e1                	jns    8014ea <ipc_send+0x1b>
  801509:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80150c:	74 dc                	je     8014ea <ipc_send+0x1b>
	        panic("ipc_send: %e", r);
  80150e:	50                   	push   %eax
  80150f:	68 6a 30 80 00       	push   $0x80306a
  801514:	6a 45                	push   $0x45
  801516:	68 77 30 80 00       	push   $0x803077
  80151b:	e8 c5 f1 ff ff       	call   8006e5 <_panic>
}
  801520:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801523:	5b                   	pop    %ebx
  801524:	5e                   	pop    %esi
  801525:	5f                   	pop    %edi
  801526:	5d                   	pop    %ebp
  801527:	c3                   	ret    

00801528 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801528:	55                   	push   %ebp
  801529:	89 e5                	mov    %esp,%ebp
  80152b:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80152e:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801533:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801536:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80153c:	8b 52 50             	mov    0x50(%edx),%edx
  80153f:	39 ca                	cmp    %ecx,%edx
  801541:	74 11                	je     801554 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  801543:	83 c0 01             	add    $0x1,%eax
  801546:	3d 00 04 00 00       	cmp    $0x400,%eax
  80154b:	75 e6                	jne    801533 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80154d:	b8 00 00 00 00       	mov    $0x0,%eax
  801552:	eb 0b                	jmp    80155f <ipc_find_env+0x37>
			return envs[i].env_id;
  801554:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801557:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80155c:	8b 40 48             	mov    0x48(%eax),%eax
}
  80155f:	5d                   	pop    %ebp
  801560:	c3                   	ret    

00801561 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801561:	55                   	push   %ebp
  801562:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801564:	8b 45 08             	mov    0x8(%ebp),%eax
  801567:	05 00 00 00 30       	add    $0x30000000,%eax
  80156c:	c1 e8 0c             	shr    $0xc,%eax
}
  80156f:	5d                   	pop    %ebp
  801570:	c3                   	ret    

00801571 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801571:	55                   	push   %ebp
  801572:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801574:	8b 45 08             	mov    0x8(%ebp),%eax
  801577:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80157c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801581:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801586:	5d                   	pop    %ebp
  801587:	c3                   	ret    

00801588 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801588:	55                   	push   %ebp
  801589:	89 e5                	mov    %esp,%ebp
  80158b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80158e:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801593:	89 c2                	mov    %eax,%edx
  801595:	c1 ea 16             	shr    $0x16,%edx
  801598:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80159f:	f6 c2 01             	test   $0x1,%dl
  8015a2:	74 2a                	je     8015ce <fd_alloc+0x46>
  8015a4:	89 c2                	mov    %eax,%edx
  8015a6:	c1 ea 0c             	shr    $0xc,%edx
  8015a9:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8015b0:	f6 c2 01             	test   $0x1,%dl
  8015b3:	74 19                	je     8015ce <fd_alloc+0x46>
  8015b5:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8015ba:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8015bf:	75 d2                	jne    801593 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8015c1:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8015c7:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8015cc:	eb 07                	jmp    8015d5 <fd_alloc+0x4d>
			*fd_store = fd;
  8015ce:	89 01                	mov    %eax,(%ecx)
			return 0;
  8015d0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015d5:	5d                   	pop    %ebp
  8015d6:	c3                   	ret    

008015d7 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8015d7:	55                   	push   %ebp
  8015d8:	89 e5                	mov    %esp,%ebp
  8015da:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8015dd:	83 f8 1f             	cmp    $0x1f,%eax
  8015e0:	77 36                	ja     801618 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8015e2:	c1 e0 0c             	shl    $0xc,%eax
  8015e5:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8015ea:	89 c2                	mov    %eax,%edx
  8015ec:	c1 ea 16             	shr    $0x16,%edx
  8015ef:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8015f6:	f6 c2 01             	test   $0x1,%dl
  8015f9:	74 24                	je     80161f <fd_lookup+0x48>
  8015fb:	89 c2                	mov    %eax,%edx
  8015fd:	c1 ea 0c             	shr    $0xc,%edx
  801600:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801607:	f6 c2 01             	test   $0x1,%dl
  80160a:	74 1a                	je     801626 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80160c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80160f:	89 02                	mov    %eax,(%edx)
	return 0;
  801611:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801616:	5d                   	pop    %ebp
  801617:	c3                   	ret    
		return -E_INVAL;
  801618:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80161d:	eb f7                	jmp    801616 <fd_lookup+0x3f>
		return -E_INVAL;
  80161f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801624:	eb f0                	jmp    801616 <fd_lookup+0x3f>
  801626:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80162b:	eb e9                	jmp    801616 <fd_lookup+0x3f>

0080162d <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80162d:	55                   	push   %ebp
  80162e:	89 e5                	mov    %esp,%ebp
  801630:	83 ec 08             	sub    $0x8,%esp
  801633:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801636:	ba 00 31 80 00       	mov    $0x803100,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  80163b:	b8 08 40 80 00       	mov    $0x804008,%eax
		if (devtab[i]->dev_id == dev_id) {
  801640:	39 08                	cmp    %ecx,(%eax)
  801642:	74 33                	je     801677 <dev_lookup+0x4a>
  801644:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801647:	8b 02                	mov    (%edx),%eax
  801649:	85 c0                	test   %eax,%eax
  80164b:	75 f3                	jne    801640 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80164d:	a1 08 50 80 00       	mov    0x805008,%eax
  801652:	8b 40 48             	mov    0x48(%eax),%eax
  801655:	83 ec 04             	sub    $0x4,%esp
  801658:	51                   	push   %ecx
  801659:	50                   	push   %eax
  80165a:	68 84 30 80 00       	push   $0x803084
  80165f:	e8 5c f1 ff ff       	call   8007c0 <cprintf>
	*dev = 0;
  801664:	8b 45 0c             	mov    0xc(%ebp),%eax
  801667:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80166d:	83 c4 10             	add    $0x10,%esp
  801670:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801675:	c9                   	leave  
  801676:	c3                   	ret    
			*dev = devtab[i];
  801677:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80167a:	89 01                	mov    %eax,(%ecx)
			return 0;
  80167c:	b8 00 00 00 00       	mov    $0x0,%eax
  801681:	eb f2                	jmp    801675 <dev_lookup+0x48>

00801683 <fd_close>:
{
  801683:	55                   	push   %ebp
  801684:	89 e5                	mov    %esp,%ebp
  801686:	57                   	push   %edi
  801687:	56                   	push   %esi
  801688:	53                   	push   %ebx
  801689:	83 ec 1c             	sub    $0x1c,%esp
  80168c:	8b 75 08             	mov    0x8(%ebp),%esi
  80168f:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801692:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801695:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801696:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80169c:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80169f:	50                   	push   %eax
  8016a0:	e8 32 ff ff ff       	call   8015d7 <fd_lookup>
  8016a5:	89 c3                	mov    %eax,%ebx
  8016a7:	83 c4 08             	add    $0x8,%esp
  8016aa:	85 c0                	test   %eax,%eax
  8016ac:	78 05                	js     8016b3 <fd_close+0x30>
	    || fd != fd2)
  8016ae:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8016b1:	74 16                	je     8016c9 <fd_close+0x46>
		return (must_exist ? r : 0);
  8016b3:	89 f8                	mov    %edi,%eax
  8016b5:	84 c0                	test   %al,%al
  8016b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8016bc:	0f 44 d8             	cmove  %eax,%ebx
}
  8016bf:	89 d8                	mov    %ebx,%eax
  8016c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016c4:	5b                   	pop    %ebx
  8016c5:	5e                   	pop    %esi
  8016c6:	5f                   	pop    %edi
  8016c7:	5d                   	pop    %ebp
  8016c8:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8016c9:	83 ec 08             	sub    $0x8,%esp
  8016cc:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8016cf:	50                   	push   %eax
  8016d0:	ff 36                	pushl  (%esi)
  8016d2:	e8 56 ff ff ff       	call   80162d <dev_lookup>
  8016d7:	89 c3                	mov    %eax,%ebx
  8016d9:	83 c4 10             	add    $0x10,%esp
  8016dc:	85 c0                	test   %eax,%eax
  8016de:	78 15                	js     8016f5 <fd_close+0x72>
		if (dev->dev_close)
  8016e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016e3:	8b 40 10             	mov    0x10(%eax),%eax
  8016e6:	85 c0                	test   %eax,%eax
  8016e8:	74 1b                	je     801705 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  8016ea:	83 ec 0c             	sub    $0xc,%esp
  8016ed:	56                   	push   %esi
  8016ee:	ff d0                	call   *%eax
  8016f0:	89 c3                	mov    %eax,%ebx
  8016f2:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8016f5:	83 ec 08             	sub    $0x8,%esp
  8016f8:	56                   	push   %esi
  8016f9:	6a 00                	push   $0x0
  8016fb:	e8 db fb ff ff       	call   8012db <sys_page_unmap>
	return r;
  801700:	83 c4 10             	add    $0x10,%esp
  801703:	eb ba                	jmp    8016bf <fd_close+0x3c>
			r = 0;
  801705:	bb 00 00 00 00       	mov    $0x0,%ebx
  80170a:	eb e9                	jmp    8016f5 <fd_close+0x72>

0080170c <close>:

int
close(int fdnum)
{
  80170c:	55                   	push   %ebp
  80170d:	89 e5                	mov    %esp,%ebp
  80170f:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801712:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801715:	50                   	push   %eax
  801716:	ff 75 08             	pushl  0x8(%ebp)
  801719:	e8 b9 fe ff ff       	call   8015d7 <fd_lookup>
  80171e:	83 c4 08             	add    $0x8,%esp
  801721:	85 c0                	test   %eax,%eax
  801723:	78 10                	js     801735 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  801725:	83 ec 08             	sub    $0x8,%esp
  801728:	6a 01                	push   $0x1
  80172a:	ff 75 f4             	pushl  -0xc(%ebp)
  80172d:	e8 51 ff ff ff       	call   801683 <fd_close>
  801732:	83 c4 10             	add    $0x10,%esp
}
  801735:	c9                   	leave  
  801736:	c3                   	ret    

00801737 <close_all>:

void
close_all(void)
{
  801737:	55                   	push   %ebp
  801738:	89 e5                	mov    %esp,%ebp
  80173a:	53                   	push   %ebx
  80173b:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80173e:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801743:	83 ec 0c             	sub    $0xc,%esp
  801746:	53                   	push   %ebx
  801747:	e8 c0 ff ff ff       	call   80170c <close>
	for (i = 0; i < MAXFD; i++)
  80174c:	83 c3 01             	add    $0x1,%ebx
  80174f:	83 c4 10             	add    $0x10,%esp
  801752:	83 fb 20             	cmp    $0x20,%ebx
  801755:	75 ec                	jne    801743 <close_all+0xc>
}
  801757:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80175a:	c9                   	leave  
  80175b:	c3                   	ret    

0080175c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80175c:	55                   	push   %ebp
  80175d:	89 e5                	mov    %esp,%ebp
  80175f:	57                   	push   %edi
  801760:	56                   	push   %esi
  801761:	53                   	push   %ebx
  801762:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801765:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801768:	50                   	push   %eax
  801769:	ff 75 08             	pushl  0x8(%ebp)
  80176c:	e8 66 fe ff ff       	call   8015d7 <fd_lookup>
  801771:	89 c3                	mov    %eax,%ebx
  801773:	83 c4 08             	add    $0x8,%esp
  801776:	85 c0                	test   %eax,%eax
  801778:	0f 88 81 00 00 00    	js     8017ff <dup+0xa3>
		return r;
	close(newfdnum);
  80177e:	83 ec 0c             	sub    $0xc,%esp
  801781:	ff 75 0c             	pushl  0xc(%ebp)
  801784:	e8 83 ff ff ff       	call   80170c <close>

	newfd = INDEX2FD(newfdnum);
  801789:	8b 75 0c             	mov    0xc(%ebp),%esi
  80178c:	c1 e6 0c             	shl    $0xc,%esi
  80178f:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801795:	83 c4 04             	add    $0x4,%esp
  801798:	ff 75 e4             	pushl  -0x1c(%ebp)
  80179b:	e8 d1 fd ff ff       	call   801571 <fd2data>
  8017a0:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8017a2:	89 34 24             	mov    %esi,(%esp)
  8017a5:	e8 c7 fd ff ff       	call   801571 <fd2data>
  8017aa:	83 c4 10             	add    $0x10,%esp
  8017ad:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8017af:	89 d8                	mov    %ebx,%eax
  8017b1:	c1 e8 16             	shr    $0x16,%eax
  8017b4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8017bb:	a8 01                	test   $0x1,%al
  8017bd:	74 11                	je     8017d0 <dup+0x74>
  8017bf:	89 d8                	mov    %ebx,%eax
  8017c1:	c1 e8 0c             	shr    $0xc,%eax
  8017c4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8017cb:	f6 c2 01             	test   $0x1,%dl
  8017ce:	75 39                	jne    801809 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8017d0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8017d3:	89 d0                	mov    %edx,%eax
  8017d5:	c1 e8 0c             	shr    $0xc,%eax
  8017d8:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8017df:	83 ec 0c             	sub    $0xc,%esp
  8017e2:	25 07 0e 00 00       	and    $0xe07,%eax
  8017e7:	50                   	push   %eax
  8017e8:	56                   	push   %esi
  8017e9:	6a 00                	push   $0x0
  8017eb:	52                   	push   %edx
  8017ec:	6a 00                	push   $0x0
  8017ee:	e8 a6 fa ff ff       	call   801299 <sys_page_map>
  8017f3:	89 c3                	mov    %eax,%ebx
  8017f5:	83 c4 20             	add    $0x20,%esp
  8017f8:	85 c0                	test   %eax,%eax
  8017fa:	78 31                	js     80182d <dup+0xd1>
		goto err;

	return newfdnum;
  8017fc:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8017ff:	89 d8                	mov    %ebx,%eax
  801801:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801804:	5b                   	pop    %ebx
  801805:	5e                   	pop    %esi
  801806:	5f                   	pop    %edi
  801807:	5d                   	pop    %ebp
  801808:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801809:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801810:	83 ec 0c             	sub    $0xc,%esp
  801813:	25 07 0e 00 00       	and    $0xe07,%eax
  801818:	50                   	push   %eax
  801819:	57                   	push   %edi
  80181a:	6a 00                	push   $0x0
  80181c:	53                   	push   %ebx
  80181d:	6a 00                	push   $0x0
  80181f:	e8 75 fa ff ff       	call   801299 <sys_page_map>
  801824:	89 c3                	mov    %eax,%ebx
  801826:	83 c4 20             	add    $0x20,%esp
  801829:	85 c0                	test   %eax,%eax
  80182b:	79 a3                	jns    8017d0 <dup+0x74>
	sys_page_unmap(0, newfd);
  80182d:	83 ec 08             	sub    $0x8,%esp
  801830:	56                   	push   %esi
  801831:	6a 00                	push   $0x0
  801833:	e8 a3 fa ff ff       	call   8012db <sys_page_unmap>
	sys_page_unmap(0, nva);
  801838:	83 c4 08             	add    $0x8,%esp
  80183b:	57                   	push   %edi
  80183c:	6a 00                	push   $0x0
  80183e:	e8 98 fa ff ff       	call   8012db <sys_page_unmap>
	return r;
  801843:	83 c4 10             	add    $0x10,%esp
  801846:	eb b7                	jmp    8017ff <dup+0xa3>

00801848 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801848:	55                   	push   %ebp
  801849:	89 e5                	mov    %esp,%ebp
  80184b:	53                   	push   %ebx
  80184c:	83 ec 14             	sub    $0x14,%esp
  80184f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801852:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801855:	50                   	push   %eax
  801856:	53                   	push   %ebx
  801857:	e8 7b fd ff ff       	call   8015d7 <fd_lookup>
  80185c:	83 c4 08             	add    $0x8,%esp
  80185f:	85 c0                	test   %eax,%eax
  801861:	78 3f                	js     8018a2 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801863:	83 ec 08             	sub    $0x8,%esp
  801866:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801869:	50                   	push   %eax
  80186a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80186d:	ff 30                	pushl  (%eax)
  80186f:	e8 b9 fd ff ff       	call   80162d <dev_lookup>
  801874:	83 c4 10             	add    $0x10,%esp
  801877:	85 c0                	test   %eax,%eax
  801879:	78 27                	js     8018a2 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80187b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80187e:	8b 42 08             	mov    0x8(%edx),%eax
  801881:	83 e0 03             	and    $0x3,%eax
  801884:	83 f8 01             	cmp    $0x1,%eax
  801887:	74 1e                	je     8018a7 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801889:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80188c:	8b 40 08             	mov    0x8(%eax),%eax
  80188f:	85 c0                	test   %eax,%eax
  801891:	74 35                	je     8018c8 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801893:	83 ec 04             	sub    $0x4,%esp
  801896:	ff 75 10             	pushl  0x10(%ebp)
  801899:	ff 75 0c             	pushl  0xc(%ebp)
  80189c:	52                   	push   %edx
  80189d:	ff d0                	call   *%eax
  80189f:	83 c4 10             	add    $0x10,%esp
}
  8018a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018a5:	c9                   	leave  
  8018a6:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8018a7:	a1 08 50 80 00       	mov    0x805008,%eax
  8018ac:	8b 40 48             	mov    0x48(%eax),%eax
  8018af:	83 ec 04             	sub    $0x4,%esp
  8018b2:	53                   	push   %ebx
  8018b3:	50                   	push   %eax
  8018b4:	68 c5 30 80 00       	push   $0x8030c5
  8018b9:	e8 02 ef ff ff       	call   8007c0 <cprintf>
		return -E_INVAL;
  8018be:	83 c4 10             	add    $0x10,%esp
  8018c1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018c6:	eb da                	jmp    8018a2 <read+0x5a>
		return -E_NOT_SUPP;
  8018c8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018cd:	eb d3                	jmp    8018a2 <read+0x5a>

008018cf <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8018cf:	55                   	push   %ebp
  8018d0:	89 e5                	mov    %esp,%ebp
  8018d2:	57                   	push   %edi
  8018d3:	56                   	push   %esi
  8018d4:	53                   	push   %ebx
  8018d5:	83 ec 0c             	sub    $0xc,%esp
  8018d8:	8b 7d 08             	mov    0x8(%ebp),%edi
  8018db:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8018de:	bb 00 00 00 00       	mov    $0x0,%ebx
  8018e3:	39 f3                	cmp    %esi,%ebx
  8018e5:	73 25                	jae    80190c <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8018e7:	83 ec 04             	sub    $0x4,%esp
  8018ea:	89 f0                	mov    %esi,%eax
  8018ec:	29 d8                	sub    %ebx,%eax
  8018ee:	50                   	push   %eax
  8018ef:	89 d8                	mov    %ebx,%eax
  8018f1:	03 45 0c             	add    0xc(%ebp),%eax
  8018f4:	50                   	push   %eax
  8018f5:	57                   	push   %edi
  8018f6:	e8 4d ff ff ff       	call   801848 <read>
		if (m < 0)
  8018fb:	83 c4 10             	add    $0x10,%esp
  8018fe:	85 c0                	test   %eax,%eax
  801900:	78 08                	js     80190a <readn+0x3b>
			return m;
		if (m == 0)
  801902:	85 c0                	test   %eax,%eax
  801904:	74 06                	je     80190c <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  801906:	01 c3                	add    %eax,%ebx
  801908:	eb d9                	jmp    8018e3 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80190a:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80190c:	89 d8                	mov    %ebx,%eax
  80190e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801911:	5b                   	pop    %ebx
  801912:	5e                   	pop    %esi
  801913:	5f                   	pop    %edi
  801914:	5d                   	pop    %ebp
  801915:	c3                   	ret    

00801916 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801916:	55                   	push   %ebp
  801917:	89 e5                	mov    %esp,%ebp
  801919:	53                   	push   %ebx
  80191a:	83 ec 14             	sub    $0x14,%esp
  80191d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801920:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801923:	50                   	push   %eax
  801924:	53                   	push   %ebx
  801925:	e8 ad fc ff ff       	call   8015d7 <fd_lookup>
  80192a:	83 c4 08             	add    $0x8,%esp
  80192d:	85 c0                	test   %eax,%eax
  80192f:	78 3a                	js     80196b <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801931:	83 ec 08             	sub    $0x8,%esp
  801934:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801937:	50                   	push   %eax
  801938:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80193b:	ff 30                	pushl  (%eax)
  80193d:	e8 eb fc ff ff       	call   80162d <dev_lookup>
  801942:	83 c4 10             	add    $0x10,%esp
  801945:	85 c0                	test   %eax,%eax
  801947:	78 22                	js     80196b <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801949:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80194c:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801950:	74 1e                	je     801970 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801952:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801955:	8b 52 0c             	mov    0xc(%edx),%edx
  801958:	85 d2                	test   %edx,%edx
  80195a:	74 35                	je     801991 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80195c:	83 ec 04             	sub    $0x4,%esp
  80195f:	ff 75 10             	pushl  0x10(%ebp)
  801962:	ff 75 0c             	pushl  0xc(%ebp)
  801965:	50                   	push   %eax
  801966:	ff d2                	call   *%edx
  801968:	83 c4 10             	add    $0x10,%esp
}
  80196b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80196e:	c9                   	leave  
  80196f:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801970:	a1 08 50 80 00       	mov    0x805008,%eax
  801975:	8b 40 48             	mov    0x48(%eax),%eax
  801978:	83 ec 04             	sub    $0x4,%esp
  80197b:	53                   	push   %ebx
  80197c:	50                   	push   %eax
  80197d:	68 e1 30 80 00       	push   $0x8030e1
  801982:	e8 39 ee ff ff       	call   8007c0 <cprintf>
		return -E_INVAL;
  801987:	83 c4 10             	add    $0x10,%esp
  80198a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80198f:	eb da                	jmp    80196b <write+0x55>
		return -E_NOT_SUPP;
  801991:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801996:	eb d3                	jmp    80196b <write+0x55>

00801998 <seek>:

int
seek(int fdnum, off_t offset)
{
  801998:	55                   	push   %ebp
  801999:	89 e5                	mov    %esp,%ebp
  80199b:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80199e:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8019a1:	50                   	push   %eax
  8019a2:	ff 75 08             	pushl  0x8(%ebp)
  8019a5:	e8 2d fc ff ff       	call   8015d7 <fd_lookup>
  8019aa:	83 c4 08             	add    $0x8,%esp
  8019ad:	85 c0                	test   %eax,%eax
  8019af:	78 0e                	js     8019bf <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8019b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019b7:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8019ba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019bf:	c9                   	leave  
  8019c0:	c3                   	ret    

008019c1 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8019c1:	55                   	push   %ebp
  8019c2:	89 e5                	mov    %esp,%ebp
  8019c4:	53                   	push   %ebx
  8019c5:	83 ec 14             	sub    $0x14,%esp
  8019c8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019cb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019ce:	50                   	push   %eax
  8019cf:	53                   	push   %ebx
  8019d0:	e8 02 fc ff ff       	call   8015d7 <fd_lookup>
  8019d5:	83 c4 08             	add    $0x8,%esp
  8019d8:	85 c0                	test   %eax,%eax
  8019da:	78 37                	js     801a13 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019dc:	83 ec 08             	sub    $0x8,%esp
  8019df:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019e2:	50                   	push   %eax
  8019e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019e6:	ff 30                	pushl  (%eax)
  8019e8:	e8 40 fc ff ff       	call   80162d <dev_lookup>
  8019ed:	83 c4 10             	add    $0x10,%esp
  8019f0:	85 c0                	test   %eax,%eax
  8019f2:	78 1f                	js     801a13 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8019f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019f7:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8019fb:	74 1b                	je     801a18 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8019fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a00:	8b 52 18             	mov    0x18(%edx),%edx
  801a03:	85 d2                	test   %edx,%edx
  801a05:	74 32                	je     801a39 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801a07:	83 ec 08             	sub    $0x8,%esp
  801a0a:	ff 75 0c             	pushl  0xc(%ebp)
  801a0d:	50                   	push   %eax
  801a0e:	ff d2                	call   *%edx
  801a10:	83 c4 10             	add    $0x10,%esp
}
  801a13:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a16:	c9                   	leave  
  801a17:	c3                   	ret    
			thisenv->env_id, fdnum);
  801a18:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801a1d:	8b 40 48             	mov    0x48(%eax),%eax
  801a20:	83 ec 04             	sub    $0x4,%esp
  801a23:	53                   	push   %ebx
  801a24:	50                   	push   %eax
  801a25:	68 a4 30 80 00       	push   $0x8030a4
  801a2a:	e8 91 ed ff ff       	call   8007c0 <cprintf>
		return -E_INVAL;
  801a2f:	83 c4 10             	add    $0x10,%esp
  801a32:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a37:	eb da                	jmp    801a13 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801a39:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a3e:	eb d3                	jmp    801a13 <ftruncate+0x52>

00801a40 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801a40:	55                   	push   %ebp
  801a41:	89 e5                	mov    %esp,%ebp
  801a43:	53                   	push   %ebx
  801a44:	83 ec 14             	sub    $0x14,%esp
  801a47:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a4a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a4d:	50                   	push   %eax
  801a4e:	ff 75 08             	pushl  0x8(%ebp)
  801a51:	e8 81 fb ff ff       	call   8015d7 <fd_lookup>
  801a56:	83 c4 08             	add    $0x8,%esp
  801a59:	85 c0                	test   %eax,%eax
  801a5b:	78 4b                	js     801aa8 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a5d:	83 ec 08             	sub    $0x8,%esp
  801a60:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a63:	50                   	push   %eax
  801a64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a67:	ff 30                	pushl  (%eax)
  801a69:	e8 bf fb ff ff       	call   80162d <dev_lookup>
  801a6e:	83 c4 10             	add    $0x10,%esp
  801a71:	85 c0                	test   %eax,%eax
  801a73:	78 33                	js     801aa8 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801a75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a78:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801a7c:	74 2f                	je     801aad <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801a7e:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801a81:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801a88:	00 00 00 
	stat->st_isdir = 0;
  801a8b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801a92:	00 00 00 
	stat->st_dev = dev;
  801a95:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801a9b:	83 ec 08             	sub    $0x8,%esp
  801a9e:	53                   	push   %ebx
  801a9f:	ff 75 f0             	pushl  -0x10(%ebp)
  801aa2:	ff 50 14             	call   *0x14(%eax)
  801aa5:	83 c4 10             	add    $0x10,%esp
}
  801aa8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801aab:	c9                   	leave  
  801aac:	c3                   	ret    
		return -E_NOT_SUPP;
  801aad:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801ab2:	eb f4                	jmp    801aa8 <fstat+0x68>

00801ab4 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801ab4:	55                   	push   %ebp
  801ab5:	89 e5                	mov    %esp,%ebp
  801ab7:	56                   	push   %esi
  801ab8:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801ab9:	83 ec 08             	sub    $0x8,%esp
  801abc:	6a 00                	push   $0x0
  801abe:	ff 75 08             	pushl  0x8(%ebp)
  801ac1:	e8 26 02 00 00       	call   801cec <open>
  801ac6:	89 c3                	mov    %eax,%ebx
  801ac8:	83 c4 10             	add    $0x10,%esp
  801acb:	85 c0                	test   %eax,%eax
  801acd:	78 1b                	js     801aea <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801acf:	83 ec 08             	sub    $0x8,%esp
  801ad2:	ff 75 0c             	pushl  0xc(%ebp)
  801ad5:	50                   	push   %eax
  801ad6:	e8 65 ff ff ff       	call   801a40 <fstat>
  801adb:	89 c6                	mov    %eax,%esi
	close(fd);
  801add:	89 1c 24             	mov    %ebx,(%esp)
  801ae0:	e8 27 fc ff ff       	call   80170c <close>
	return r;
  801ae5:	83 c4 10             	add    $0x10,%esp
  801ae8:	89 f3                	mov    %esi,%ebx
}
  801aea:	89 d8                	mov    %ebx,%eax
  801aec:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801aef:	5b                   	pop    %ebx
  801af0:	5e                   	pop    %esi
  801af1:	5d                   	pop    %ebp
  801af2:	c3                   	ret    

00801af3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801af3:	55                   	push   %ebp
  801af4:	89 e5                	mov    %esp,%ebp
  801af6:	56                   	push   %esi
  801af7:	53                   	push   %ebx
  801af8:	89 c6                	mov    %eax,%esi
  801afa:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801afc:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801b03:	74 27                	je     801b2c <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801b05:	6a 07                	push   $0x7
  801b07:	68 00 60 80 00       	push   $0x806000
  801b0c:	56                   	push   %esi
  801b0d:	ff 35 00 50 80 00    	pushl  0x805000
  801b13:	e8 b7 f9 ff ff       	call   8014cf <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801b18:	83 c4 0c             	add    $0xc,%esp
  801b1b:	6a 00                	push   $0x0
  801b1d:	53                   	push   %ebx
  801b1e:	6a 00                	push   $0x0
  801b20:	e8 41 f9 ff ff       	call   801466 <ipc_recv>
}
  801b25:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b28:	5b                   	pop    %ebx
  801b29:	5e                   	pop    %esi
  801b2a:	5d                   	pop    %ebp
  801b2b:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801b2c:	83 ec 0c             	sub    $0xc,%esp
  801b2f:	6a 01                	push   $0x1
  801b31:	e8 f2 f9 ff ff       	call   801528 <ipc_find_env>
  801b36:	a3 00 50 80 00       	mov    %eax,0x805000
  801b3b:	83 c4 10             	add    $0x10,%esp
  801b3e:	eb c5                	jmp    801b05 <fsipc+0x12>

00801b40 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801b40:	55                   	push   %ebp
  801b41:	89 e5                	mov    %esp,%ebp
  801b43:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801b46:	8b 45 08             	mov    0x8(%ebp),%eax
  801b49:	8b 40 0c             	mov    0xc(%eax),%eax
  801b4c:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801b51:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b54:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801b59:	ba 00 00 00 00       	mov    $0x0,%edx
  801b5e:	b8 02 00 00 00       	mov    $0x2,%eax
  801b63:	e8 8b ff ff ff       	call   801af3 <fsipc>
}
  801b68:	c9                   	leave  
  801b69:	c3                   	ret    

00801b6a <devfile_flush>:
{
  801b6a:	55                   	push   %ebp
  801b6b:	89 e5                	mov    %esp,%ebp
  801b6d:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801b70:	8b 45 08             	mov    0x8(%ebp),%eax
  801b73:	8b 40 0c             	mov    0xc(%eax),%eax
  801b76:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801b7b:	ba 00 00 00 00       	mov    $0x0,%edx
  801b80:	b8 06 00 00 00       	mov    $0x6,%eax
  801b85:	e8 69 ff ff ff       	call   801af3 <fsipc>
}
  801b8a:	c9                   	leave  
  801b8b:	c3                   	ret    

00801b8c <devfile_stat>:
{
  801b8c:	55                   	push   %ebp
  801b8d:	89 e5                	mov    %esp,%ebp
  801b8f:	53                   	push   %ebx
  801b90:	83 ec 04             	sub    $0x4,%esp
  801b93:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801b96:	8b 45 08             	mov    0x8(%ebp),%eax
  801b99:	8b 40 0c             	mov    0xc(%eax),%eax
  801b9c:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801ba1:	ba 00 00 00 00       	mov    $0x0,%edx
  801ba6:	b8 05 00 00 00       	mov    $0x5,%eax
  801bab:	e8 43 ff ff ff       	call   801af3 <fsipc>
  801bb0:	85 c0                	test   %eax,%eax
  801bb2:	78 2c                	js     801be0 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801bb4:	83 ec 08             	sub    $0x8,%esp
  801bb7:	68 00 60 80 00       	push   $0x806000
  801bbc:	53                   	push   %ebx
  801bbd:	e8 9b f2 ff ff       	call   800e5d <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801bc2:	a1 80 60 80 00       	mov    0x806080,%eax
  801bc7:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801bcd:	a1 84 60 80 00       	mov    0x806084,%eax
  801bd2:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801bd8:	83 c4 10             	add    $0x10,%esp
  801bdb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801be0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801be3:	c9                   	leave  
  801be4:	c3                   	ret    

00801be5 <devfile_write>:
{
  801be5:	55                   	push   %ebp
  801be6:	89 e5                	mov    %esp,%ebp
  801be8:	53                   	push   %ebx
  801be9:	83 ec 04             	sub    $0x4,%esp
  801bec:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801bef:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf2:	8b 40 0c             	mov    0xc(%eax),%eax
  801bf5:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801bfa:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  801c00:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  801c06:	77 30                	ja     801c38 <devfile_write+0x53>
	memmove(fsipcbuf.write.req_buf, buf, n);
  801c08:	83 ec 04             	sub    $0x4,%esp
  801c0b:	53                   	push   %ebx
  801c0c:	ff 75 0c             	pushl  0xc(%ebp)
  801c0f:	68 08 60 80 00       	push   $0x806008
  801c14:	e8 d2 f3 ff ff       	call   800feb <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801c19:	ba 00 00 00 00       	mov    $0x0,%edx
  801c1e:	b8 04 00 00 00       	mov    $0x4,%eax
  801c23:	e8 cb fe ff ff       	call   801af3 <fsipc>
  801c28:	83 c4 10             	add    $0x10,%esp
  801c2b:	85 c0                	test   %eax,%eax
  801c2d:	78 04                	js     801c33 <devfile_write+0x4e>
	assert(r <= n);
  801c2f:	39 d8                	cmp    %ebx,%eax
  801c31:	77 1e                	ja     801c51 <devfile_write+0x6c>
}
  801c33:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c36:	c9                   	leave  
  801c37:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  801c38:	68 14 31 80 00       	push   $0x803114
  801c3d:	68 44 31 80 00       	push   $0x803144
  801c42:	68 94 00 00 00       	push   $0x94
  801c47:	68 59 31 80 00       	push   $0x803159
  801c4c:	e8 94 ea ff ff       	call   8006e5 <_panic>
	assert(r <= n);
  801c51:	68 64 31 80 00       	push   $0x803164
  801c56:	68 44 31 80 00       	push   $0x803144
  801c5b:	68 98 00 00 00       	push   $0x98
  801c60:	68 59 31 80 00       	push   $0x803159
  801c65:	e8 7b ea ff ff       	call   8006e5 <_panic>

00801c6a <devfile_read>:
{
  801c6a:	55                   	push   %ebp
  801c6b:	89 e5                	mov    %esp,%ebp
  801c6d:	56                   	push   %esi
  801c6e:	53                   	push   %ebx
  801c6f:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801c72:	8b 45 08             	mov    0x8(%ebp),%eax
  801c75:	8b 40 0c             	mov    0xc(%eax),%eax
  801c78:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801c7d:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801c83:	ba 00 00 00 00       	mov    $0x0,%edx
  801c88:	b8 03 00 00 00       	mov    $0x3,%eax
  801c8d:	e8 61 fe ff ff       	call   801af3 <fsipc>
  801c92:	89 c3                	mov    %eax,%ebx
  801c94:	85 c0                	test   %eax,%eax
  801c96:	78 1f                	js     801cb7 <devfile_read+0x4d>
	assert(r <= n);
  801c98:	39 f0                	cmp    %esi,%eax
  801c9a:	77 24                	ja     801cc0 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801c9c:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801ca1:	7f 33                	jg     801cd6 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801ca3:	83 ec 04             	sub    $0x4,%esp
  801ca6:	50                   	push   %eax
  801ca7:	68 00 60 80 00       	push   $0x806000
  801cac:	ff 75 0c             	pushl  0xc(%ebp)
  801caf:	e8 37 f3 ff ff       	call   800feb <memmove>
	return r;
  801cb4:	83 c4 10             	add    $0x10,%esp
}
  801cb7:	89 d8                	mov    %ebx,%eax
  801cb9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cbc:	5b                   	pop    %ebx
  801cbd:	5e                   	pop    %esi
  801cbe:	5d                   	pop    %ebp
  801cbf:	c3                   	ret    
	assert(r <= n);
  801cc0:	68 64 31 80 00       	push   $0x803164
  801cc5:	68 44 31 80 00       	push   $0x803144
  801cca:	6a 7c                	push   $0x7c
  801ccc:	68 59 31 80 00       	push   $0x803159
  801cd1:	e8 0f ea ff ff       	call   8006e5 <_panic>
	assert(r <= PGSIZE);
  801cd6:	68 6b 31 80 00       	push   $0x80316b
  801cdb:	68 44 31 80 00       	push   $0x803144
  801ce0:	6a 7d                	push   $0x7d
  801ce2:	68 59 31 80 00       	push   $0x803159
  801ce7:	e8 f9 e9 ff ff       	call   8006e5 <_panic>

00801cec <open>:
{
  801cec:	55                   	push   %ebp
  801ced:	89 e5                	mov    %esp,%ebp
  801cef:	56                   	push   %esi
  801cf0:	53                   	push   %ebx
  801cf1:	83 ec 1c             	sub    $0x1c,%esp
  801cf4:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801cf7:	56                   	push   %esi
  801cf8:	e8 29 f1 ff ff       	call   800e26 <strlen>
  801cfd:	83 c4 10             	add    $0x10,%esp
  801d00:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801d05:	7f 6c                	jg     801d73 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801d07:	83 ec 0c             	sub    $0xc,%esp
  801d0a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d0d:	50                   	push   %eax
  801d0e:	e8 75 f8 ff ff       	call   801588 <fd_alloc>
  801d13:	89 c3                	mov    %eax,%ebx
  801d15:	83 c4 10             	add    $0x10,%esp
  801d18:	85 c0                	test   %eax,%eax
  801d1a:	78 3c                	js     801d58 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801d1c:	83 ec 08             	sub    $0x8,%esp
  801d1f:	56                   	push   %esi
  801d20:	68 00 60 80 00       	push   $0x806000
  801d25:	e8 33 f1 ff ff       	call   800e5d <strcpy>
	fsipcbuf.open.req_omode = mode;
  801d2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d2d:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801d32:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d35:	b8 01 00 00 00       	mov    $0x1,%eax
  801d3a:	e8 b4 fd ff ff       	call   801af3 <fsipc>
  801d3f:	89 c3                	mov    %eax,%ebx
  801d41:	83 c4 10             	add    $0x10,%esp
  801d44:	85 c0                	test   %eax,%eax
  801d46:	78 19                	js     801d61 <open+0x75>
	return fd2num(fd);
  801d48:	83 ec 0c             	sub    $0xc,%esp
  801d4b:	ff 75 f4             	pushl  -0xc(%ebp)
  801d4e:	e8 0e f8 ff ff       	call   801561 <fd2num>
  801d53:	89 c3                	mov    %eax,%ebx
  801d55:	83 c4 10             	add    $0x10,%esp
}
  801d58:	89 d8                	mov    %ebx,%eax
  801d5a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d5d:	5b                   	pop    %ebx
  801d5e:	5e                   	pop    %esi
  801d5f:	5d                   	pop    %ebp
  801d60:	c3                   	ret    
		fd_close(fd, 0);
  801d61:	83 ec 08             	sub    $0x8,%esp
  801d64:	6a 00                	push   $0x0
  801d66:	ff 75 f4             	pushl  -0xc(%ebp)
  801d69:	e8 15 f9 ff ff       	call   801683 <fd_close>
		return r;
  801d6e:	83 c4 10             	add    $0x10,%esp
  801d71:	eb e5                	jmp    801d58 <open+0x6c>
		return -E_BAD_PATH;
  801d73:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801d78:	eb de                	jmp    801d58 <open+0x6c>

00801d7a <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801d7a:	55                   	push   %ebp
  801d7b:	89 e5                	mov    %esp,%ebp
  801d7d:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801d80:	ba 00 00 00 00       	mov    $0x0,%edx
  801d85:	b8 08 00 00 00       	mov    $0x8,%eax
  801d8a:	e8 64 fd ff ff       	call   801af3 <fsipc>
}
  801d8f:	c9                   	leave  
  801d90:	c3                   	ret    

00801d91 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801d91:	55                   	push   %ebp
  801d92:	89 e5                	mov    %esp,%ebp
  801d94:	56                   	push   %esi
  801d95:	53                   	push   %ebx
  801d96:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801d99:	83 ec 0c             	sub    $0xc,%esp
  801d9c:	ff 75 08             	pushl  0x8(%ebp)
  801d9f:	e8 cd f7 ff ff       	call   801571 <fd2data>
  801da4:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801da6:	83 c4 08             	add    $0x8,%esp
  801da9:	68 77 31 80 00       	push   $0x803177
  801dae:	53                   	push   %ebx
  801daf:	e8 a9 f0 ff ff       	call   800e5d <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801db4:	8b 46 04             	mov    0x4(%esi),%eax
  801db7:	2b 06                	sub    (%esi),%eax
  801db9:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801dbf:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801dc6:	00 00 00 
	stat->st_dev = &devpipe;
  801dc9:	c7 83 88 00 00 00 24 	movl   $0x804024,0x88(%ebx)
  801dd0:	40 80 00 
	return 0;
}
  801dd3:	b8 00 00 00 00       	mov    $0x0,%eax
  801dd8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ddb:	5b                   	pop    %ebx
  801ddc:	5e                   	pop    %esi
  801ddd:	5d                   	pop    %ebp
  801dde:	c3                   	ret    

00801ddf <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801ddf:	55                   	push   %ebp
  801de0:	89 e5                	mov    %esp,%ebp
  801de2:	53                   	push   %ebx
  801de3:	83 ec 0c             	sub    $0xc,%esp
  801de6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801de9:	53                   	push   %ebx
  801dea:	6a 00                	push   $0x0
  801dec:	e8 ea f4 ff ff       	call   8012db <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801df1:	89 1c 24             	mov    %ebx,(%esp)
  801df4:	e8 78 f7 ff ff       	call   801571 <fd2data>
  801df9:	83 c4 08             	add    $0x8,%esp
  801dfc:	50                   	push   %eax
  801dfd:	6a 00                	push   $0x0
  801dff:	e8 d7 f4 ff ff       	call   8012db <sys_page_unmap>
}
  801e04:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e07:	c9                   	leave  
  801e08:	c3                   	ret    

00801e09 <_pipeisclosed>:
{
  801e09:	55                   	push   %ebp
  801e0a:	89 e5                	mov    %esp,%ebp
  801e0c:	57                   	push   %edi
  801e0d:	56                   	push   %esi
  801e0e:	53                   	push   %ebx
  801e0f:	83 ec 1c             	sub    $0x1c,%esp
  801e12:	89 c7                	mov    %eax,%edi
  801e14:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801e16:	a1 08 50 80 00       	mov    0x805008,%eax
  801e1b:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801e1e:	83 ec 0c             	sub    $0xc,%esp
  801e21:	57                   	push   %edi
  801e22:	e8 99 08 00 00       	call   8026c0 <pageref>
  801e27:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801e2a:	89 34 24             	mov    %esi,(%esp)
  801e2d:	e8 8e 08 00 00       	call   8026c0 <pageref>
		nn = thisenv->env_runs;
  801e32:	8b 15 08 50 80 00    	mov    0x805008,%edx
  801e38:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801e3b:	83 c4 10             	add    $0x10,%esp
  801e3e:	39 cb                	cmp    %ecx,%ebx
  801e40:	74 1b                	je     801e5d <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801e42:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801e45:	75 cf                	jne    801e16 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801e47:	8b 42 58             	mov    0x58(%edx),%eax
  801e4a:	6a 01                	push   $0x1
  801e4c:	50                   	push   %eax
  801e4d:	53                   	push   %ebx
  801e4e:	68 7e 31 80 00       	push   $0x80317e
  801e53:	e8 68 e9 ff ff       	call   8007c0 <cprintf>
  801e58:	83 c4 10             	add    $0x10,%esp
  801e5b:	eb b9                	jmp    801e16 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801e5d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801e60:	0f 94 c0             	sete   %al
  801e63:	0f b6 c0             	movzbl %al,%eax
}
  801e66:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e69:	5b                   	pop    %ebx
  801e6a:	5e                   	pop    %esi
  801e6b:	5f                   	pop    %edi
  801e6c:	5d                   	pop    %ebp
  801e6d:	c3                   	ret    

00801e6e <devpipe_write>:
{
  801e6e:	55                   	push   %ebp
  801e6f:	89 e5                	mov    %esp,%ebp
  801e71:	57                   	push   %edi
  801e72:	56                   	push   %esi
  801e73:	53                   	push   %ebx
  801e74:	83 ec 28             	sub    $0x28,%esp
  801e77:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801e7a:	56                   	push   %esi
  801e7b:	e8 f1 f6 ff ff       	call   801571 <fd2data>
  801e80:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e82:	83 c4 10             	add    $0x10,%esp
  801e85:	bf 00 00 00 00       	mov    $0x0,%edi
  801e8a:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801e8d:	74 4f                	je     801ede <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801e8f:	8b 43 04             	mov    0x4(%ebx),%eax
  801e92:	8b 0b                	mov    (%ebx),%ecx
  801e94:	8d 51 20             	lea    0x20(%ecx),%edx
  801e97:	39 d0                	cmp    %edx,%eax
  801e99:	72 14                	jb     801eaf <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801e9b:	89 da                	mov    %ebx,%edx
  801e9d:	89 f0                	mov    %esi,%eax
  801e9f:	e8 65 ff ff ff       	call   801e09 <_pipeisclosed>
  801ea4:	85 c0                	test   %eax,%eax
  801ea6:	75 3a                	jne    801ee2 <devpipe_write+0x74>
			sys_yield();
  801ea8:	e8 8a f3 ff ff       	call   801237 <sys_yield>
  801ead:	eb e0                	jmp    801e8f <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801eaf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801eb2:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801eb6:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801eb9:	89 c2                	mov    %eax,%edx
  801ebb:	c1 fa 1f             	sar    $0x1f,%edx
  801ebe:	89 d1                	mov    %edx,%ecx
  801ec0:	c1 e9 1b             	shr    $0x1b,%ecx
  801ec3:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801ec6:	83 e2 1f             	and    $0x1f,%edx
  801ec9:	29 ca                	sub    %ecx,%edx
  801ecb:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801ecf:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801ed3:	83 c0 01             	add    $0x1,%eax
  801ed6:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801ed9:	83 c7 01             	add    $0x1,%edi
  801edc:	eb ac                	jmp    801e8a <devpipe_write+0x1c>
	return i;
  801ede:	89 f8                	mov    %edi,%eax
  801ee0:	eb 05                	jmp    801ee7 <devpipe_write+0x79>
				return 0;
  801ee2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ee7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801eea:	5b                   	pop    %ebx
  801eeb:	5e                   	pop    %esi
  801eec:	5f                   	pop    %edi
  801eed:	5d                   	pop    %ebp
  801eee:	c3                   	ret    

00801eef <devpipe_read>:
{
  801eef:	55                   	push   %ebp
  801ef0:	89 e5                	mov    %esp,%ebp
  801ef2:	57                   	push   %edi
  801ef3:	56                   	push   %esi
  801ef4:	53                   	push   %ebx
  801ef5:	83 ec 18             	sub    $0x18,%esp
  801ef8:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801efb:	57                   	push   %edi
  801efc:	e8 70 f6 ff ff       	call   801571 <fd2data>
  801f01:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801f03:	83 c4 10             	add    $0x10,%esp
  801f06:	be 00 00 00 00       	mov    $0x0,%esi
  801f0b:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f0e:	74 47                	je     801f57 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801f10:	8b 03                	mov    (%ebx),%eax
  801f12:	3b 43 04             	cmp    0x4(%ebx),%eax
  801f15:	75 22                	jne    801f39 <devpipe_read+0x4a>
			if (i > 0)
  801f17:	85 f6                	test   %esi,%esi
  801f19:	75 14                	jne    801f2f <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801f1b:	89 da                	mov    %ebx,%edx
  801f1d:	89 f8                	mov    %edi,%eax
  801f1f:	e8 e5 fe ff ff       	call   801e09 <_pipeisclosed>
  801f24:	85 c0                	test   %eax,%eax
  801f26:	75 33                	jne    801f5b <devpipe_read+0x6c>
			sys_yield();
  801f28:	e8 0a f3 ff ff       	call   801237 <sys_yield>
  801f2d:	eb e1                	jmp    801f10 <devpipe_read+0x21>
				return i;
  801f2f:	89 f0                	mov    %esi,%eax
}
  801f31:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f34:	5b                   	pop    %ebx
  801f35:	5e                   	pop    %esi
  801f36:	5f                   	pop    %edi
  801f37:	5d                   	pop    %ebp
  801f38:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801f39:	99                   	cltd   
  801f3a:	c1 ea 1b             	shr    $0x1b,%edx
  801f3d:	01 d0                	add    %edx,%eax
  801f3f:	83 e0 1f             	and    $0x1f,%eax
  801f42:	29 d0                	sub    %edx,%eax
  801f44:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801f49:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f4c:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801f4f:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801f52:	83 c6 01             	add    $0x1,%esi
  801f55:	eb b4                	jmp    801f0b <devpipe_read+0x1c>
	return i;
  801f57:	89 f0                	mov    %esi,%eax
  801f59:	eb d6                	jmp    801f31 <devpipe_read+0x42>
				return 0;
  801f5b:	b8 00 00 00 00       	mov    $0x0,%eax
  801f60:	eb cf                	jmp    801f31 <devpipe_read+0x42>

00801f62 <pipe>:
{
  801f62:	55                   	push   %ebp
  801f63:	89 e5                	mov    %esp,%ebp
  801f65:	56                   	push   %esi
  801f66:	53                   	push   %ebx
  801f67:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801f6a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f6d:	50                   	push   %eax
  801f6e:	e8 15 f6 ff ff       	call   801588 <fd_alloc>
  801f73:	89 c3                	mov    %eax,%ebx
  801f75:	83 c4 10             	add    $0x10,%esp
  801f78:	85 c0                	test   %eax,%eax
  801f7a:	78 5b                	js     801fd7 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f7c:	83 ec 04             	sub    $0x4,%esp
  801f7f:	68 07 04 00 00       	push   $0x407
  801f84:	ff 75 f4             	pushl  -0xc(%ebp)
  801f87:	6a 00                	push   $0x0
  801f89:	e8 c8 f2 ff ff       	call   801256 <sys_page_alloc>
  801f8e:	89 c3                	mov    %eax,%ebx
  801f90:	83 c4 10             	add    $0x10,%esp
  801f93:	85 c0                	test   %eax,%eax
  801f95:	78 40                	js     801fd7 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  801f97:	83 ec 0c             	sub    $0xc,%esp
  801f9a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801f9d:	50                   	push   %eax
  801f9e:	e8 e5 f5 ff ff       	call   801588 <fd_alloc>
  801fa3:	89 c3                	mov    %eax,%ebx
  801fa5:	83 c4 10             	add    $0x10,%esp
  801fa8:	85 c0                	test   %eax,%eax
  801faa:	78 1b                	js     801fc7 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fac:	83 ec 04             	sub    $0x4,%esp
  801faf:	68 07 04 00 00       	push   $0x407
  801fb4:	ff 75 f0             	pushl  -0x10(%ebp)
  801fb7:	6a 00                	push   $0x0
  801fb9:	e8 98 f2 ff ff       	call   801256 <sys_page_alloc>
  801fbe:	89 c3                	mov    %eax,%ebx
  801fc0:	83 c4 10             	add    $0x10,%esp
  801fc3:	85 c0                	test   %eax,%eax
  801fc5:	79 19                	jns    801fe0 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  801fc7:	83 ec 08             	sub    $0x8,%esp
  801fca:	ff 75 f4             	pushl  -0xc(%ebp)
  801fcd:	6a 00                	push   $0x0
  801fcf:	e8 07 f3 ff ff       	call   8012db <sys_page_unmap>
  801fd4:	83 c4 10             	add    $0x10,%esp
}
  801fd7:	89 d8                	mov    %ebx,%eax
  801fd9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fdc:	5b                   	pop    %ebx
  801fdd:	5e                   	pop    %esi
  801fde:	5d                   	pop    %ebp
  801fdf:	c3                   	ret    
	va = fd2data(fd0);
  801fe0:	83 ec 0c             	sub    $0xc,%esp
  801fe3:	ff 75 f4             	pushl  -0xc(%ebp)
  801fe6:	e8 86 f5 ff ff       	call   801571 <fd2data>
  801feb:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fed:	83 c4 0c             	add    $0xc,%esp
  801ff0:	68 07 04 00 00       	push   $0x407
  801ff5:	50                   	push   %eax
  801ff6:	6a 00                	push   $0x0
  801ff8:	e8 59 f2 ff ff       	call   801256 <sys_page_alloc>
  801ffd:	89 c3                	mov    %eax,%ebx
  801fff:	83 c4 10             	add    $0x10,%esp
  802002:	85 c0                	test   %eax,%eax
  802004:	0f 88 8c 00 00 00    	js     802096 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80200a:	83 ec 0c             	sub    $0xc,%esp
  80200d:	ff 75 f0             	pushl  -0x10(%ebp)
  802010:	e8 5c f5 ff ff       	call   801571 <fd2data>
  802015:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80201c:	50                   	push   %eax
  80201d:	6a 00                	push   $0x0
  80201f:	56                   	push   %esi
  802020:	6a 00                	push   $0x0
  802022:	e8 72 f2 ff ff       	call   801299 <sys_page_map>
  802027:	89 c3                	mov    %eax,%ebx
  802029:	83 c4 20             	add    $0x20,%esp
  80202c:	85 c0                	test   %eax,%eax
  80202e:	78 58                	js     802088 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  802030:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802033:	8b 15 24 40 80 00    	mov    0x804024,%edx
  802039:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80203b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80203e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  802045:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802048:	8b 15 24 40 80 00    	mov    0x804024,%edx
  80204e:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802050:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802053:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80205a:	83 ec 0c             	sub    $0xc,%esp
  80205d:	ff 75 f4             	pushl  -0xc(%ebp)
  802060:	e8 fc f4 ff ff       	call   801561 <fd2num>
  802065:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802068:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80206a:	83 c4 04             	add    $0x4,%esp
  80206d:	ff 75 f0             	pushl  -0x10(%ebp)
  802070:	e8 ec f4 ff ff       	call   801561 <fd2num>
  802075:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802078:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80207b:	83 c4 10             	add    $0x10,%esp
  80207e:	bb 00 00 00 00       	mov    $0x0,%ebx
  802083:	e9 4f ff ff ff       	jmp    801fd7 <pipe+0x75>
	sys_page_unmap(0, va);
  802088:	83 ec 08             	sub    $0x8,%esp
  80208b:	56                   	push   %esi
  80208c:	6a 00                	push   $0x0
  80208e:	e8 48 f2 ff ff       	call   8012db <sys_page_unmap>
  802093:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802096:	83 ec 08             	sub    $0x8,%esp
  802099:	ff 75 f0             	pushl  -0x10(%ebp)
  80209c:	6a 00                	push   $0x0
  80209e:	e8 38 f2 ff ff       	call   8012db <sys_page_unmap>
  8020a3:	83 c4 10             	add    $0x10,%esp
  8020a6:	e9 1c ff ff ff       	jmp    801fc7 <pipe+0x65>

008020ab <pipeisclosed>:
{
  8020ab:	55                   	push   %ebp
  8020ac:	89 e5                	mov    %esp,%ebp
  8020ae:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020b1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020b4:	50                   	push   %eax
  8020b5:	ff 75 08             	pushl  0x8(%ebp)
  8020b8:	e8 1a f5 ff ff       	call   8015d7 <fd_lookup>
  8020bd:	83 c4 10             	add    $0x10,%esp
  8020c0:	85 c0                	test   %eax,%eax
  8020c2:	78 18                	js     8020dc <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8020c4:	83 ec 0c             	sub    $0xc,%esp
  8020c7:	ff 75 f4             	pushl  -0xc(%ebp)
  8020ca:	e8 a2 f4 ff ff       	call   801571 <fd2data>
	return _pipeisclosed(fd, p);
  8020cf:	89 c2                	mov    %eax,%edx
  8020d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d4:	e8 30 fd ff ff       	call   801e09 <_pipeisclosed>
  8020d9:	83 c4 10             	add    $0x10,%esp
}
  8020dc:	c9                   	leave  
  8020dd:	c3                   	ret    

008020de <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8020de:	55                   	push   %ebp
  8020df:	89 e5                	mov    %esp,%ebp
  8020e1:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  8020e4:	68 96 31 80 00       	push   $0x803196
  8020e9:	ff 75 0c             	pushl  0xc(%ebp)
  8020ec:	e8 6c ed ff ff       	call   800e5d <strcpy>
	return 0;
}
  8020f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8020f6:	c9                   	leave  
  8020f7:	c3                   	ret    

008020f8 <devsock_close>:
{
  8020f8:	55                   	push   %ebp
  8020f9:	89 e5                	mov    %esp,%ebp
  8020fb:	53                   	push   %ebx
  8020fc:	83 ec 10             	sub    $0x10,%esp
  8020ff:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  802102:	53                   	push   %ebx
  802103:	e8 b8 05 00 00       	call   8026c0 <pageref>
  802108:	83 c4 10             	add    $0x10,%esp
		return 0;
  80210b:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  802110:	83 f8 01             	cmp    $0x1,%eax
  802113:	74 07                	je     80211c <devsock_close+0x24>
}
  802115:	89 d0                	mov    %edx,%eax
  802117:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80211a:	c9                   	leave  
  80211b:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  80211c:	83 ec 0c             	sub    $0xc,%esp
  80211f:	ff 73 0c             	pushl  0xc(%ebx)
  802122:	e8 b7 02 00 00       	call   8023de <nsipc_close>
  802127:	89 c2                	mov    %eax,%edx
  802129:	83 c4 10             	add    $0x10,%esp
  80212c:	eb e7                	jmp    802115 <devsock_close+0x1d>

0080212e <devsock_write>:
{
  80212e:	55                   	push   %ebp
  80212f:	89 e5                	mov    %esp,%ebp
  802131:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802134:	6a 00                	push   $0x0
  802136:	ff 75 10             	pushl  0x10(%ebp)
  802139:	ff 75 0c             	pushl  0xc(%ebp)
  80213c:	8b 45 08             	mov    0x8(%ebp),%eax
  80213f:	ff 70 0c             	pushl  0xc(%eax)
  802142:	e8 74 03 00 00       	call   8024bb <nsipc_send>
}
  802147:	c9                   	leave  
  802148:	c3                   	ret    

00802149 <devsock_read>:
{
  802149:	55                   	push   %ebp
  80214a:	89 e5                	mov    %esp,%ebp
  80214c:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80214f:	6a 00                	push   $0x0
  802151:	ff 75 10             	pushl  0x10(%ebp)
  802154:	ff 75 0c             	pushl  0xc(%ebp)
  802157:	8b 45 08             	mov    0x8(%ebp),%eax
  80215a:	ff 70 0c             	pushl  0xc(%eax)
  80215d:	e8 ed 02 00 00       	call   80244f <nsipc_recv>
}
  802162:	c9                   	leave  
  802163:	c3                   	ret    

00802164 <fd2sockid>:
{
  802164:	55                   	push   %ebp
  802165:	89 e5                	mov    %esp,%ebp
  802167:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  80216a:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80216d:	52                   	push   %edx
  80216e:	50                   	push   %eax
  80216f:	e8 63 f4 ff ff       	call   8015d7 <fd_lookup>
  802174:	83 c4 10             	add    $0x10,%esp
  802177:	85 c0                	test   %eax,%eax
  802179:	78 10                	js     80218b <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  80217b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80217e:	8b 0d 40 40 80 00    	mov    0x804040,%ecx
  802184:	39 08                	cmp    %ecx,(%eax)
  802186:	75 05                	jne    80218d <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  802188:	8b 40 0c             	mov    0xc(%eax),%eax
}
  80218b:	c9                   	leave  
  80218c:	c3                   	ret    
		return -E_NOT_SUPP;
  80218d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802192:	eb f7                	jmp    80218b <fd2sockid+0x27>

00802194 <alloc_sockfd>:
{
  802194:	55                   	push   %ebp
  802195:	89 e5                	mov    %esp,%ebp
  802197:	56                   	push   %esi
  802198:	53                   	push   %ebx
  802199:	83 ec 1c             	sub    $0x1c,%esp
  80219c:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  80219e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021a1:	50                   	push   %eax
  8021a2:	e8 e1 f3 ff ff       	call   801588 <fd_alloc>
  8021a7:	89 c3                	mov    %eax,%ebx
  8021a9:	83 c4 10             	add    $0x10,%esp
  8021ac:	85 c0                	test   %eax,%eax
  8021ae:	78 43                	js     8021f3 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8021b0:	83 ec 04             	sub    $0x4,%esp
  8021b3:	68 07 04 00 00       	push   $0x407
  8021b8:	ff 75 f4             	pushl  -0xc(%ebp)
  8021bb:	6a 00                	push   $0x0
  8021bd:	e8 94 f0 ff ff       	call   801256 <sys_page_alloc>
  8021c2:	89 c3                	mov    %eax,%ebx
  8021c4:	83 c4 10             	add    $0x10,%esp
  8021c7:	85 c0                	test   %eax,%eax
  8021c9:	78 28                	js     8021f3 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  8021cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ce:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8021d4:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8021d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d9:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8021e0:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8021e3:	83 ec 0c             	sub    $0xc,%esp
  8021e6:	50                   	push   %eax
  8021e7:	e8 75 f3 ff ff       	call   801561 <fd2num>
  8021ec:	89 c3                	mov    %eax,%ebx
  8021ee:	83 c4 10             	add    $0x10,%esp
  8021f1:	eb 0c                	jmp    8021ff <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8021f3:	83 ec 0c             	sub    $0xc,%esp
  8021f6:	56                   	push   %esi
  8021f7:	e8 e2 01 00 00       	call   8023de <nsipc_close>
		return r;
  8021fc:	83 c4 10             	add    $0x10,%esp
}
  8021ff:	89 d8                	mov    %ebx,%eax
  802201:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802204:	5b                   	pop    %ebx
  802205:	5e                   	pop    %esi
  802206:	5d                   	pop    %ebp
  802207:	c3                   	ret    

00802208 <accept>:
{
  802208:	55                   	push   %ebp
  802209:	89 e5                	mov    %esp,%ebp
  80220b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80220e:	8b 45 08             	mov    0x8(%ebp),%eax
  802211:	e8 4e ff ff ff       	call   802164 <fd2sockid>
  802216:	85 c0                	test   %eax,%eax
  802218:	78 1b                	js     802235 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80221a:	83 ec 04             	sub    $0x4,%esp
  80221d:	ff 75 10             	pushl  0x10(%ebp)
  802220:	ff 75 0c             	pushl  0xc(%ebp)
  802223:	50                   	push   %eax
  802224:	e8 0e 01 00 00       	call   802337 <nsipc_accept>
  802229:	83 c4 10             	add    $0x10,%esp
  80222c:	85 c0                	test   %eax,%eax
  80222e:	78 05                	js     802235 <accept+0x2d>
	return alloc_sockfd(r);
  802230:	e8 5f ff ff ff       	call   802194 <alloc_sockfd>
}
  802235:	c9                   	leave  
  802236:	c3                   	ret    

00802237 <bind>:
{
  802237:	55                   	push   %ebp
  802238:	89 e5                	mov    %esp,%ebp
  80223a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80223d:	8b 45 08             	mov    0x8(%ebp),%eax
  802240:	e8 1f ff ff ff       	call   802164 <fd2sockid>
  802245:	85 c0                	test   %eax,%eax
  802247:	78 12                	js     80225b <bind+0x24>
	return nsipc_bind(r, name, namelen);
  802249:	83 ec 04             	sub    $0x4,%esp
  80224c:	ff 75 10             	pushl  0x10(%ebp)
  80224f:	ff 75 0c             	pushl  0xc(%ebp)
  802252:	50                   	push   %eax
  802253:	e8 2f 01 00 00       	call   802387 <nsipc_bind>
  802258:	83 c4 10             	add    $0x10,%esp
}
  80225b:	c9                   	leave  
  80225c:	c3                   	ret    

0080225d <shutdown>:
{
  80225d:	55                   	push   %ebp
  80225e:	89 e5                	mov    %esp,%ebp
  802260:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802263:	8b 45 08             	mov    0x8(%ebp),%eax
  802266:	e8 f9 fe ff ff       	call   802164 <fd2sockid>
  80226b:	85 c0                	test   %eax,%eax
  80226d:	78 0f                	js     80227e <shutdown+0x21>
	return nsipc_shutdown(r, how);
  80226f:	83 ec 08             	sub    $0x8,%esp
  802272:	ff 75 0c             	pushl  0xc(%ebp)
  802275:	50                   	push   %eax
  802276:	e8 41 01 00 00       	call   8023bc <nsipc_shutdown>
  80227b:	83 c4 10             	add    $0x10,%esp
}
  80227e:	c9                   	leave  
  80227f:	c3                   	ret    

00802280 <connect>:
{
  802280:	55                   	push   %ebp
  802281:	89 e5                	mov    %esp,%ebp
  802283:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802286:	8b 45 08             	mov    0x8(%ebp),%eax
  802289:	e8 d6 fe ff ff       	call   802164 <fd2sockid>
  80228e:	85 c0                	test   %eax,%eax
  802290:	78 12                	js     8022a4 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  802292:	83 ec 04             	sub    $0x4,%esp
  802295:	ff 75 10             	pushl  0x10(%ebp)
  802298:	ff 75 0c             	pushl  0xc(%ebp)
  80229b:	50                   	push   %eax
  80229c:	e8 57 01 00 00       	call   8023f8 <nsipc_connect>
  8022a1:	83 c4 10             	add    $0x10,%esp
}
  8022a4:	c9                   	leave  
  8022a5:	c3                   	ret    

008022a6 <listen>:
{
  8022a6:	55                   	push   %ebp
  8022a7:	89 e5                	mov    %esp,%ebp
  8022a9:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8022ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8022af:	e8 b0 fe ff ff       	call   802164 <fd2sockid>
  8022b4:	85 c0                	test   %eax,%eax
  8022b6:	78 0f                	js     8022c7 <listen+0x21>
	return nsipc_listen(r, backlog);
  8022b8:	83 ec 08             	sub    $0x8,%esp
  8022bb:	ff 75 0c             	pushl  0xc(%ebp)
  8022be:	50                   	push   %eax
  8022bf:	e8 69 01 00 00       	call   80242d <nsipc_listen>
  8022c4:	83 c4 10             	add    $0x10,%esp
}
  8022c7:	c9                   	leave  
  8022c8:	c3                   	ret    

008022c9 <socket>:

int
socket(int domain, int type, int protocol)
{
  8022c9:	55                   	push   %ebp
  8022ca:	89 e5                	mov    %esp,%ebp
  8022cc:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8022cf:	ff 75 10             	pushl  0x10(%ebp)
  8022d2:	ff 75 0c             	pushl  0xc(%ebp)
  8022d5:	ff 75 08             	pushl  0x8(%ebp)
  8022d8:	e8 3c 02 00 00       	call   802519 <nsipc_socket>
  8022dd:	83 c4 10             	add    $0x10,%esp
  8022e0:	85 c0                	test   %eax,%eax
  8022e2:	78 05                	js     8022e9 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8022e4:	e8 ab fe ff ff       	call   802194 <alloc_sockfd>
}
  8022e9:	c9                   	leave  
  8022ea:	c3                   	ret    

008022eb <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8022eb:	55                   	push   %ebp
  8022ec:	89 e5                	mov    %esp,%ebp
  8022ee:	53                   	push   %ebx
  8022ef:	83 ec 04             	sub    $0x4,%esp
  8022f2:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8022f4:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  8022fb:	74 26                	je     802323 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8022fd:	6a 07                	push   $0x7
  8022ff:	68 00 70 80 00       	push   $0x807000
  802304:	53                   	push   %ebx
  802305:	ff 35 04 50 80 00    	pushl  0x805004
  80230b:	e8 bf f1 ff ff       	call   8014cf <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802310:	83 c4 0c             	add    $0xc,%esp
  802313:	6a 00                	push   $0x0
  802315:	6a 00                	push   $0x0
  802317:	6a 00                	push   $0x0
  802319:	e8 48 f1 ff ff       	call   801466 <ipc_recv>
}
  80231e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802321:	c9                   	leave  
  802322:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802323:	83 ec 0c             	sub    $0xc,%esp
  802326:	6a 02                	push   $0x2
  802328:	e8 fb f1 ff ff       	call   801528 <ipc_find_env>
  80232d:	a3 04 50 80 00       	mov    %eax,0x805004
  802332:	83 c4 10             	add    $0x10,%esp
  802335:	eb c6                	jmp    8022fd <nsipc+0x12>

00802337 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802337:	55                   	push   %ebp
  802338:	89 e5                	mov    %esp,%ebp
  80233a:	56                   	push   %esi
  80233b:	53                   	push   %ebx
  80233c:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  80233f:	8b 45 08             	mov    0x8(%ebp),%eax
  802342:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802347:	8b 06                	mov    (%esi),%eax
  802349:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80234e:	b8 01 00 00 00       	mov    $0x1,%eax
  802353:	e8 93 ff ff ff       	call   8022eb <nsipc>
  802358:	89 c3                	mov    %eax,%ebx
  80235a:	85 c0                	test   %eax,%eax
  80235c:	78 20                	js     80237e <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80235e:	83 ec 04             	sub    $0x4,%esp
  802361:	ff 35 10 70 80 00    	pushl  0x807010
  802367:	68 00 70 80 00       	push   $0x807000
  80236c:	ff 75 0c             	pushl  0xc(%ebp)
  80236f:	e8 77 ec ff ff       	call   800feb <memmove>
		*addrlen = ret->ret_addrlen;
  802374:	a1 10 70 80 00       	mov    0x807010,%eax
  802379:	89 06                	mov    %eax,(%esi)
  80237b:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  80237e:	89 d8                	mov    %ebx,%eax
  802380:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802383:	5b                   	pop    %ebx
  802384:	5e                   	pop    %esi
  802385:	5d                   	pop    %ebp
  802386:	c3                   	ret    

00802387 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802387:	55                   	push   %ebp
  802388:	89 e5                	mov    %esp,%ebp
  80238a:	53                   	push   %ebx
  80238b:	83 ec 08             	sub    $0x8,%esp
  80238e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802391:	8b 45 08             	mov    0x8(%ebp),%eax
  802394:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802399:	53                   	push   %ebx
  80239a:	ff 75 0c             	pushl  0xc(%ebp)
  80239d:	68 04 70 80 00       	push   $0x807004
  8023a2:	e8 44 ec ff ff       	call   800feb <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8023a7:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  8023ad:	b8 02 00 00 00       	mov    $0x2,%eax
  8023b2:	e8 34 ff ff ff       	call   8022eb <nsipc>
}
  8023b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023ba:	c9                   	leave  
  8023bb:	c3                   	ret    

008023bc <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8023bc:	55                   	push   %ebp
  8023bd:	89 e5                	mov    %esp,%ebp
  8023bf:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8023c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c5:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  8023ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023cd:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  8023d2:	b8 03 00 00 00       	mov    $0x3,%eax
  8023d7:	e8 0f ff ff ff       	call   8022eb <nsipc>
}
  8023dc:	c9                   	leave  
  8023dd:	c3                   	ret    

008023de <nsipc_close>:

int
nsipc_close(int s)
{
  8023de:	55                   	push   %ebp
  8023df:	89 e5                	mov    %esp,%ebp
  8023e1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8023e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e7:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8023ec:	b8 04 00 00 00       	mov    $0x4,%eax
  8023f1:	e8 f5 fe ff ff       	call   8022eb <nsipc>
}
  8023f6:	c9                   	leave  
  8023f7:	c3                   	ret    

008023f8 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8023f8:	55                   	push   %ebp
  8023f9:	89 e5                	mov    %esp,%ebp
  8023fb:	53                   	push   %ebx
  8023fc:	83 ec 08             	sub    $0x8,%esp
  8023ff:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802402:	8b 45 08             	mov    0x8(%ebp),%eax
  802405:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80240a:	53                   	push   %ebx
  80240b:	ff 75 0c             	pushl  0xc(%ebp)
  80240e:	68 04 70 80 00       	push   $0x807004
  802413:	e8 d3 eb ff ff       	call   800feb <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802418:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  80241e:	b8 05 00 00 00       	mov    $0x5,%eax
  802423:	e8 c3 fe ff ff       	call   8022eb <nsipc>
}
  802428:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80242b:	c9                   	leave  
  80242c:	c3                   	ret    

0080242d <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80242d:	55                   	push   %ebp
  80242e:	89 e5                	mov    %esp,%ebp
  802430:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802433:	8b 45 08             	mov    0x8(%ebp),%eax
  802436:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  80243b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80243e:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  802443:	b8 06 00 00 00       	mov    $0x6,%eax
  802448:	e8 9e fe ff ff       	call   8022eb <nsipc>
}
  80244d:	c9                   	leave  
  80244e:	c3                   	ret    

0080244f <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80244f:	55                   	push   %ebp
  802450:	89 e5                	mov    %esp,%ebp
  802452:	56                   	push   %esi
  802453:	53                   	push   %ebx
  802454:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802457:	8b 45 08             	mov    0x8(%ebp),%eax
  80245a:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  80245f:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802465:	8b 45 14             	mov    0x14(%ebp),%eax
  802468:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80246d:	b8 07 00 00 00       	mov    $0x7,%eax
  802472:	e8 74 fe ff ff       	call   8022eb <nsipc>
  802477:	89 c3                	mov    %eax,%ebx
  802479:	85 c0                	test   %eax,%eax
  80247b:	78 1f                	js     80249c <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  80247d:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802482:	7f 21                	jg     8024a5 <nsipc_recv+0x56>
  802484:	39 c6                	cmp    %eax,%esi
  802486:	7c 1d                	jl     8024a5 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802488:	83 ec 04             	sub    $0x4,%esp
  80248b:	50                   	push   %eax
  80248c:	68 00 70 80 00       	push   $0x807000
  802491:	ff 75 0c             	pushl  0xc(%ebp)
  802494:	e8 52 eb ff ff       	call   800feb <memmove>
  802499:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  80249c:	89 d8                	mov    %ebx,%eax
  80249e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8024a1:	5b                   	pop    %ebx
  8024a2:	5e                   	pop    %esi
  8024a3:	5d                   	pop    %ebp
  8024a4:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8024a5:	68 a2 31 80 00       	push   $0x8031a2
  8024aa:	68 44 31 80 00       	push   $0x803144
  8024af:	6a 62                	push   $0x62
  8024b1:	68 b7 31 80 00       	push   $0x8031b7
  8024b6:	e8 2a e2 ff ff       	call   8006e5 <_panic>

008024bb <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8024bb:	55                   	push   %ebp
  8024bc:	89 e5                	mov    %esp,%ebp
  8024be:	53                   	push   %ebx
  8024bf:	83 ec 04             	sub    $0x4,%esp
  8024c2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8024c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c8:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8024cd:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8024d3:	7f 2e                	jg     802503 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8024d5:	83 ec 04             	sub    $0x4,%esp
  8024d8:	53                   	push   %ebx
  8024d9:	ff 75 0c             	pushl  0xc(%ebp)
  8024dc:	68 0c 70 80 00       	push   $0x80700c
  8024e1:	e8 05 eb ff ff       	call   800feb <memmove>
	nsipcbuf.send.req_size = size;
  8024e6:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8024ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8024ef:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8024f4:	b8 08 00 00 00       	mov    $0x8,%eax
  8024f9:	e8 ed fd ff ff       	call   8022eb <nsipc>
}
  8024fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802501:	c9                   	leave  
  802502:	c3                   	ret    
	assert(size < 1600);
  802503:	68 c3 31 80 00       	push   $0x8031c3
  802508:	68 44 31 80 00       	push   $0x803144
  80250d:	6a 6d                	push   $0x6d
  80250f:	68 b7 31 80 00       	push   $0x8031b7
  802514:	e8 cc e1 ff ff       	call   8006e5 <_panic>

00802519 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802519:	55                   	push   %ebp
  80251a:	89 e5                	mov    %esp,%ebp
  80251c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80251f:	8b 45 08             	mov    0x8(%ebp),%eax
  802522:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802527:	8b 45 0c             	mov    0xc(%ebp),%eax
  80252a:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  80252f:	8b 45 10             	mov    0x10(%ebp),%eax
  802532:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802537:	b8 09 00 00 00       	mov    $0x9,%eax
  80253c:	e8 aa fd ff ff       	call   8022eb <nsipc>
}
  802541:	c9                   	leave  
  802542:	c3                   	ret    

00802543 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802543:	55                   	push   %ebp
  802544:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802546:	b8 00 00 00 00       	mov    $0x0,%eax
  80254b:	5d                   	pop    %ebp
  80254c:	c3                   	ret    

0080254d <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80254d:	55                   	push   %ebp
  80254e:	89 e5                	mov    %esp,%ebp
  802550:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802553:	68 cf 31 80 00       	push   $0x8031cf
  802558:	ff 75 0c             	pushl  0xc(%ebp)
  80255b:	e8 fd e8 ff ff       	call   800e5d <strcpy>
	return 0;
}
  802560:	b8 00 00 00 00       	mov    $0x0,%eax
  802565:	c9                   	leave  
  802566:	c3                   	ret    

00802567 <devcons_write>:
{
  802567:	55                   	push   %ebp
  802568:	89 e5                	mov    %esp,%ebp
  80256a:	57                   	push   %edi
  80256b:	56                   	push   %esi
  80256c:	53                   	push   %ebx
  80256d:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802573:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802578:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80257e:	eb 2f                	jmp    8025af <devcons_write+0x48>
		m = n - tot;
  802580:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802583:	29 f3                	sub    %esi,%ebx
  802585:	83 fb 7f             	cmp    $0x7f,%ebx
  802588:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80258d:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802590:	83 ec 04             	sub    $0x4,%esp
  802593:	53                   	push   %ebx
  802594:	89 f0                	mov    %esi,%eax
  802596:	03 45 0c             	add    0xc(%ebp),%eax
  802599:	50                   	push   %eax
  80259a:	57                   	push   %edi
  80259b:	e8 4b ea ff ff       	call   800feb <memmove>
		sys_cputs(buf, m);
  8025a0:	83 c4 08             	add    $0x8,%esp
  8025a3:	53                   	push   %ebx
  8025a4:	57                   	push   %edi
  8025a5:	e8 f0 eb ff ff       	call   80119a <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8025aa:	01 de                	add    %ebx,%esi
  8025ac:	83 c4 10             	add    $0x10,%esp
  8025af:	3b 75 10             	cmp    0x10(%ebp),%esi
  8025b2:	72 cc                	jb     802580 <devcons_write+0x19>
}
  8025b4:	89 f0                	mov    %esi,%eax
  8025b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8025b9:	5b                   	pop    %ebx
  8025ba:	5e                   	pop    %esi
  8025bb:	5f                   	pop    %edi
  8025bc:	5d                   	pop    %ebp
  8025bd:	c3                   	ret    

008025be <devcons_read>:
{
  8025be:	55                   	push   %ebp
  8025bf:	89 e5                	mov    %esp,%ebp
  8025c1:	83 ec 08             	sub    $0x8,%esp
  8025c4:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8025c9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8025cd:	75 07                	jne    8025d6 <devcons_read+0x18>
}
  8025cf:	c9                   	leave  
  8025d0:	c3                   	ret    
		sys_yield();
  8025d1:	e8 61 ec ff ff       	call   801237 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  8025d6:	e8 dd eb ff ff       	call   8011b8 <sys_cgetc>
  8025db:	85 c0                	test   %eax,%eax
  8025dd:	74 f2                	je     8025d1 <devcons_read+0x13>
	if (c < 0)
  8025df:	85 c0                	test   %eax,%eax
  8025e1:	78 ec                	js     8025cf <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  8025e3:	83 f8 04             	cmp    $0x4,%eax
  8025e6:	74 0c                	je     8025f4 <devcons_read+0x36>
	*(char*)vbuf = c;
  8025e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025eb:	88 02                	mov    %al,(%edx)
	return 1;
  8025ed:	b8 01 00 00 00       	mov    $0x1,%eax
  8025f2:	eb db                	jmp    8025cf <devcons_read+0x11>
		return 0;
  8025f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8025f9:	eb d4                	jmp    8025cf <devcons_read+0x11>

008025fb <cputchar>:
{
  8025fb:	55                   	push   %ebp
  8025fc:	89 e5                	mov    %esp,%ebp
  8025fe:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802601:	8b 45 08             	mov    0x8(%ebp),%eax
  802604:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802607:	6a 01                	push   $0x1
  802609:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80260c:	50                   	push   %eax
  80260d:	e8 88 eb ff ff       	call   80119a <sys_cputs>
}
  802612:	83 c4 10             	add    $0x10,%esp
  802615:	c9                   	leave  
  802616:	c3                   	ret    

00802617 <getchar>:
{
  802617:	55                   	push   %ebp
  802618:	89 e5                	mov    %esp,%ebp
  80261a:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80261d:	6a 01                	push   $0x1
  80261f:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802622:	50                   	push   %eax
  802623:	6a 00                	push   $0x0
  802625:	e8 1e f2 ff ff       	call   801848 <read>
	if (r < 0)
  80262a:	83 c4 10             	add    $0x10,%esp
  80262d:	85 c0                	test   %eax,%eax
  80262f:	78 08                	js     802639 <getchar+0x22>
	if (r < 1)
  802631:	85 c0                	test   %eax,%eax
  802633:	7e 06                	jle    80263b <getchar+0x24>
	return c;
  802635:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802639:	c9                   	leave  
  80263a:	c3                   	ret    
		return -E_EOF;
  80263b:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802640:	eb f7                	jmp    802639 <getchar+0x22>

00802642 <iscons>:
{
  802642:	55                   	push   %ebp
  802643:	89 e5                	mov    %esp,%ebp
  802645:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802648:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80264b:	50                   	push   %eax
  80264c:	ff 75 08             	pushl  0x8(%ebp)
  80264f:	e8 83 ef ff ff       	call   8015d7 <fd_lookup>
  802654:	83 c4 10             	add    $0x10,%esp
  802657:	85 c0                	test   %eax,%eax
  802659:	78 11                	js     80266c <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80265b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265e:	8b 15 5c 40 80 00    	mov    0x80405c,%edx
  802664:	39 10                	cmp    %edx,(%eax)
  802666:	0f 94 c0             	sete   %al
  802669:	0f b6 c0             	movzbl %al,%eax
}
  80266c:	c9                   	leave  
  80266d:	c3                   	ret    

0080266e <opencons>:
{
  80266e:	55                   	push   %ebp
  80266f:	89 e5                	mov    %esp,%ebp
  802671:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802674:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802677:	50                   	push   %eax
  802678:	e8 0b ef ff ff       	call   801588 <fd_alloc>
  80267d:	83 c4 10             	add    $0x10,%esp
  802680:	85 c0                	test   %eax,%eax
  802682:	78 3a                	js     8026be <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802684:	83 ec 04             	sub    $0x4,%esp
  802687:	68 07 04 00 00       	push   $0x407
  80268c:	ff 75 f4             	pushl  -0xc(%ebp)
  80268f:	6a 00                	push   $0x0
  802691:	e8 c0 eb ff ff       	call   801256 <sys_page_alloc>
  802696:	83 c4 10             	add    $0x10,%esp
  802699:	85 c0                	test   %eax,%eax
  80269b:	78 21                	js     8026be <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80269d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a0:	8b 15 5c 40 80 00    	mov    0x80405c,%edx
  8026a6:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8026a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ab:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8026b2:	83 ec 0c             	sub    $0xc,%esp
  8026b5:	50                   	push   %eax
  8026b6:	e8 a6 ee ff ff       	call   801561 <fd2num>
  8026bb:	83 c4 10             	add    $0x10,%esp
}
  8026be:	c9                   	leave  
  8026bf:	c3                   	ret    

008026c0 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8026c0:	55                   	push   %ebp
  8026c1:	89 e5                	mov    %esp,%ebp
  8026c3:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8026c6:	89 d0                	mov    %edx,%eax
  8026c8:	c1 e8 16             	shr    $0x16,%eax
  8026cb:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8026d2:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8026d7:	f6 c1 01             	test   $0x1,%cl
  8026da:	74 1d                	je     8026f9 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8026dc:	c1 ea 0c             	shr    $0xc,%edx
  8026df:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8026e6:	f6 c2 01             	test   $0x1,%dl
  8026e9:	74 0e                	je     8026f9 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8026eb:	c1 ea 0c             	shr    $0xc,%edx
  8026ee:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8026f5:	ef 
  8026f6:	0f b7 c0             	movzwl %ax,%eax
}
  8026f9:	5d                   	pop    %ebp
  8026fa:	c3                   	ret    
  8026fb:	66 90                	xchg   %ax,%ax
  8026fd:	66 90                	xchg   %ax,%ax
  8026ff:	90                   	nop

00802700 <__udivdi3>:
  802700:	55                   	push   %ebp
  802701:	57                   	push   %edi
  802702:	56                   	push   %esi
  802703:	53                   	push   %ebx
  802704:	83 ec 1c             	sub    $0x1c,%esp
  802707:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80270b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80270f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802713:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802717:	85 d2                	test   %edx,%edx
  802719:	75 35                	jne    802750 <__udivdi3+0x50>
  80271b:	39 f3                	cmp    %esi,%ebx
  80271d:	0f 87 bd 00 00 00    	ja     8027e0 <__udivdi3+0xe0>
  802723:	85 db                	test   %ebx,%ebx
  802725:	89 d9                	mov    %ebx,%ecx
  802727:	75 0b                	jne    802734 <__udivdi3+0x34>
  802729:	b8 01 00 00 00       	mov    $0x1,%eax
  80272e:	31 d2                	xor    %edx,%edx
  802730:	f7 f3                	div    %ebx
  802732:	89 c1                	mov    %eax,%ecx
  802734:	31 d2                	xor    %edx,%edx
  802736:	89 f0                	mov    %esi,%eax
  802738:	f7 f1                	div    %ecx
  80273a:	89 c6                	mov    %eax,%esi
  80273c:	89 e8                	mov    %ebp,%eax
  80273e:	89 f7                	mov    %esi,%edi
  802740:	f7 f1                	div    %ecx
  802742:	89 fa                	mov    %edi,%edx
  802744:	83 c4 1c             	add    $0x1c,%esp
  802747:	5b                   	pop    %ebx
  802748:	5e                   	pop    %esi
  802749:	5f                   	pop    %edi
  80274a:	5d                   	pop    %ebp
  80274b:	c3                   	ret    
  80274c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802750:	39 f2                	cmp    %esi,%edx
  802752:	77 7c                	ja     8027d0 <__udivdi3+0xd0>
  802754:	0f bd fa             	bsr    %edx,%edi
  802757:	83 f7 1f             	xor    $0x1f,%edi
  80275a:	0f 84 98 00 00 00    	je     8027f8 <__udivdi3+0xf8>
  802760:	89 f9                	mov    %edi,%ecx
  802762:	b8 20 00 00 00       	mov    $0x20,%eax
  802767:	29 f8                	sub    %edi,%eax
  802769:	d3 e2                	shl    %cl,%edx
  80276b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80276f:	89 c1                	mov    %eax,%ecx
  802771:	89 da                	mov    %ebx,%edx
  802773:	d3 ea                	shr    %cl,%edx
  802775:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802779:	09 d1                	or     %edx,%ecx
  80277b:	89 f2                	mov    %esi,%edx
  80277d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802781:	89 f9                	mov    %edi,%ecx
  802783:	d3 e3                	shl    %cl,%ebx
  802785:	89 c1                	mov    %eax,%ecx
  802787:	d3 ea                	shr    %cl,%edx
  802789:	89 f9                	mov    %edi,%ecx
  80278b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80278f:	d3 e6                	shl    %cl,%esi
  802791:	89 eb                	mov    %ebp,%ebx
  802793:	89 c1                	mov    %eax,%ecx
  802795:	d3 eb                	shr    %cl,%ebx
  802797:	09 de                	or     %ebx,%esi
  802799:	89 f0                	mov    %esi,%eax
  80279b:	f7 74 24 08          	divl   0x8(%esp)
  80279f:	89 d6                	mov    %edx,%esi
  8027a1:	89 c3                	mov    %eax,%ebx
  8027a3:	f7 64 24 0c          	mull   0xc(%esp)
  8027a7:	39 d6                	cmp    %edx,%esi
  8027a9:	72 0c                	jb     8027b7 <__udivdi3+0xb7>
  8027ab:	89 f9                	mov    %edi,%ecx
  8027ad:	d3 e5                	shl    %cl,%ebp
  8027af:	39 c5                	cmp    %eax,%ebp
  8027b1:	73 5d                	jae    802810 <__udivdi3+0x110>
  8027b3:	39 d6                	cmp    %edx,%esi
  8027b5:	75 59                	jne    802810 <__udivdi3+0x110>
  8027b7:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8027ba:	31 ff                	xor    %edi,%edi
  8027bc:	89 fa                	mov    %edi,%edx
  8027be:	83 c4 1c             	add    $0x1c,%esp
  8027c1:	5b                   	pop    %ebx
  8027c2:	5e                   	pop    %esi
  8027c3:	5f                   	pop    %edi
  8027c4:	5d                   	pop    %ebp
  8027c5:	c3                   	ret    
  8027c6:	8d 76 00             	lea    0x0(%esi),%esi
  8027c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  8027d0:	31 ff                	xor    %edi,%edi
  8027d2:	31 c0                	xor    %eax,%eax
  8027d4:	89 fa                	mov    %edi,%edx
  8027d6:	83 c4 1c             	add    $0x1c,%esp
  8027d9:	5b                   	pop    %ebx
  8027da:	5e                   	pop    %esi
  8027db:	5f                   	pop    %edi
  8027dc:	5d                   	pop    %ebp
  8027dd:	c3                   	ret    
  8027de:	66 90                	xchg   %ax,%ax
  8027e0:	31 ff                	xor    %edi,%edi
  8027e2:	89 e8                	mov    %ebp,%eax
  8027e4:	89 f2                	mov    %esi,%edx
  8027e6:	f7 f3                	div    %ebx
  8027e8:	89 fa                	mov    %edi,%edx
  8027ea:	83 c4 1c             	add    $0x1c,%esp
  8027ed:	5b                   	pop    %ebx
  8027ee:	5e                   	pop    %esi
  8027ef:	5f                   	pop    %edi
  8027f0:	5d                   	pop    %ebp
  8027f1:	c3                   	ret    
  8027f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8027f8:	39 f2                	cmp    %esi,%edx
  8027fa:	72 06                	jb     802802 <__udivdi3+0x102>
  8027fc:	31 c0                	xor    %eax,%eax
  8027fe:	39 eb                	cmp    %ebp,%ebx
  802800:	77 d2                	ja     8027d4 <__udivdi3+0xd4>
  802802:	b8 01 00 00 00       	mov    $0x1,%eax
  802807:	eb cb                	jmp    8027d4 <__udivdi3+0xd4>
  802809:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802810:	89 d8                	mov    %ebx,%eax
  802812:	31 ff                	xor    %edi,%edi
  802814:	eb be                	jmp    8027d4 <__udivdi3+0xd4>
  802816:	66 90                	xchg   %ax,%ax
  802818:	66 90                	xchg   %ax,%ax
  80281a:	66 90                	xchg   %ax,%ax
  80281c:	66 90                	xchg   %ax,%ax
  80281e:	66 90                	xchg   %ax,%ax

00802820 <__umoddi3>:
  802820:	55                   	push   %ebp
  802821:	57                   	push   %edi
  802822:	56                   	push   %esi
  802823:	53                   	push   %ebx
  802824:	83 ec 1c             	sub    $0x1c,%esp
  802827:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  80282b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80282f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802833:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802837:	85 ed                	test   %ebp,%ebp
  802839:	89 f0                	mov    %esi,%eax
  80283b:	89 da                	mov    %ebx,%edx
  80283d:	75 19                	jne    802858 <__umoddi3+0x38>
  80283f:	39 df                	cmp    %ebx,%edi
  802841:	0f 86 b1 00 00 00    	jbe    8028f8 <__umoddi3+0xd8>
  802847:	f7 f7                	div    %edi
  802849:	89 d0                	mov    %edx,%eax
  80284b:	31 d2                	xor    %edx,%edx
  80284d:	83 c4 1c             	add    $0x1c,%esp
  802850:	5b                   	pop    %ebx
  802851:	5e                   	pop    %esi
  802852:	5f                   	pop    %edi
  802853:	5d                   	pop    %ebp
  802854:	c3                   	ret    
  802855:	8d 76 00             	lea    0x0(%esi),%esi
  802858:	39 dd                	cmp    %ebx,%ebp
  80285a:	77 f1                	ja     80284d <__umoddi3+0x2d>
  80285c:	0f bd cd             	bsr    %ebp,%ecx
  80285f:	83 f1 1f             	xor    $0x1f,%ecx
  802862:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802866:	0f 84 b4 00 00 00    	je     802920 <__umoddi3+0x100>
  80286c:	b8 20 00 00 00       	mov    $0x20,%eax
  802871:	89 c2                	mov    %eax,%edx
  802873:	8b 44 24 04          	mov    0x4(%esp),%eax
  802877:	29 c2                	sub    %eax,%edx
  802879:	89 c1                	mov    %eax,%ecx
  80287b:	89 f8                	mov    %edi,%eax
  80287d:	d3 e5                	shl    %cl,%ebp
  80287f:	89 d1                	mov    %edx,%ecx
  802881:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802885:	d3 e8                	shr    %cl,%eax
  802887:	09 c5                	or     %eax,%ebp
  802889:	8b 44 24 04          	mov    0x4(%esp),%eax
  80288d:	89 c1                	mov    %eax,%ecx
  80288f:	d3 e7                	shl    %cl,%edi
  802891:	89 d1                	mov    %edx,%ecx
  802893:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802897:	89 df                	mov    %ebx,%edi
  802899:	d3 ef                	shr    %cl,%edi
  80289b:	89 c1                	mov    %eax,%ecx
  80289d:	89 f0                	mov    %esi,%eax
  80289f:	d3 e3                	shl    %cl,%ebx
  8028a1:	89 d1                	mov    %edx,%ecx
  8028a3:	89 fa                	mov    %edi,%edx
  8028a5:	d3 e8                	shr    %cl,%eax
  8028a7:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8028ac:	09 d8                	or     %ebx,%eax
  8028ae:	f7 f5                	div    %ebp
  8028b0:	d3 e6                	shl    %cl,%esi
  8028b2:	89 d1                	mov    %edx,%ecx
  8028b4:	f7 64 24 08          	mull   0x8(%esp)
  8028b8:	39 d1                	cmp    %edx,%ecx
  8028ba:	89 c3                	mov    %eax,%ebx
  8028bc:	89 d7                	mov    %edx,%edi
  8028be:	72 06                	jb     8028c6 <__umoddi3+0xa6>
  8028c0:	75 0e                	jne    8028d0 <__umoddi3+0xb0>
  8028c2:	39 c6                	cmp    %eax,%esi
  8028c4:	73 0a                	jae    8028d0 <__umoddi3+0xb0>
  8028c6:	2b 44 24 08          	sub    0x8(%esp),%eax
  8028ca:	19 ea                	sbb    %ebp,%edx
  8028cc:	89 d7                	mov    %edx,%edi
  8028ce:	89 c3                	mov    %eax,%ebx
  8028d0:	89 ca                	mov    %ecx,%edx
  8028d2:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  8028d7:	29 de                	sub    %ebx,%esi
  8028d9:	19 fa                	sbb    %edi,%edx
  8028db:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  8028df:	89 d0                	mov    %edx,%eax
  8028e1:	d3 e0                	shl    %cl,%eax
  8028e3:	89 d9                	mov    %ebx,%ecx
  8028e5:	d3 ee                	shr    %cl,%esi
  8028e7:	d3 ea                	shr    %cl,%edx
  8028e9:	09 f0                	or     %esi,%eax
  8028eb:	83 c4 1c             	add    $0x1c,%esp
  8028ee:	5b                   	pop    %ebx
  8028ef:	5e                   	pop    %esi
  8028f0:	5f                   	pop    %edi
  8028f1:	5d                   	pop    %ebp
  8028f2:	c3                   	ret    
  8028f3:	90                   	nop
  8028f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8028f8:	85 ff                	test   %edi,%edi
  8028fa:	89 f9                	mov    %edi,%ecx
  8028fc:	75 0b                	jne    802909 <__umoddi3+0xe9>
  8028fe:	b8 01 00 00 00       	mov    $0x1,%eax
  802903:	31 d2                	xor    %edx,%edx
  802905:	f7 f7                	div    %edi
  802907:	89 c1                	mov    %eax,%ecx
  802909:	89 d8                	mov    %ebx,%eax
  80290b:	31 d2                	xor    %edx,%edx
  80290d:	f7 f1                	div    %ecx
  80290f:	89 f0                	mov    %esi,%eax
  802911:	f7 f1                	div    %ecx
  802913:	e9 31 ff ff ff       	jmp    802849 <__umoddi3+0x29>
  802918:	90                   	nop
  802919:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802920:	39 dd                	cmp    %ebx,%ebp
  802922:	72 08                	jb     80292c <__umoddi3+0x10c>
  802924:	39 f7                	cmp    %esi,%edi
  802926:	0f 87 21 ff ff ff    	ja     80284d <__umoddi3+0x2d>
  80292c:	89 da                	mov    %ebx,%edx
  80292e:	89 f0                	mov    %esi,%eax
  802930:	29 f8                	sub    %edi,%eax
  802932:	19 ea                	sbb    %ebp,%edx
  802934:	e9 14 ff ff ff       	jmp    80284d <__umoddi3+0x2d>
