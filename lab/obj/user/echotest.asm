
obj/user/echotest.debug:     file format elf32-i386


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
  80002c:	e8 82 04 00 00       	call   8004b3 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <die>:

const char *msg = "Hello world!\n";

static void
die(char *m)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	cprintf("%s\n", m);
  800039:	50                   	push   %eax
  80003a:	68 80 27 80 00       	push   $0x802780
  80003f:	e8 64 05 00 00       	call   8005a8 <cprintf>
	exit();
  800044:	e8 b0 04 00 00       	call   8004f9 <exit>
}
  800049:	83 c4 10             	add    $0x10,%esp
  80004c:	c9                   	leave  
  80004d:	c3                   	ret    

0080004e <umain>:

void umain(int argc, char **argv)
{
  80004e:	55                   	push   %ebp
  80004f:	89 e5                	mov    %esp,%ebp
  800051:	57                   	push   %edi
  800052:	56                   	push   %esi
  800053:	53                   	push   %ebx
  800054:	83 ec 58             	sub    $0x58,%esp
	struct sockaddr_in echoserver;
	char buffer[BUFFSIZE];
	unsigned int echolen;
	int received = 0;

	cprintf("Connecting to:\n");
  800057:	68 84 27 80 00       	push   $0x802784
  80005c:	e8 47 05 00 00       	call   8005a8 <cprintf>
	cprintf("\tip address %s = %x\n", IPADDR, inet_addr(IPADDR));
  800061:	c7 04 24 94 27 80 00 	movl   $0x802794,(%esp)
  800068:	e8 14 04 00 00       	call   800481 <inet_addr>
  80006d:	83 c4 0c             	add    $0xc,%esp
  800070:	50                   	push   %eax
  800071:	68 94 27 80 00       	push   $0x802794
  800076:	68 9e 27 80 00       	push   $0x80279e
  80007b:	e8 28 05 00 00       	call   8005a8 <cprintf>

	// Create the TCP socket
	if ((sock = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0)
  800080:	83 c4 0c             	add    $0xc,%esp
  800083:	6a 06                	push   $0x6
  800085:	6a 01                	push   $0x1
  800087:	6a 02                	push   $0x2
  800089:	e8 28 1f 00 00       	call   801fb6 <socket>
  80008e:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  800091:	83 c4 10             	add    $0x10,%esp
  800094:	85 c0                	test   %eax,%eax
  800096:	0f 88 b4 00 00 00    	js     800150 <umain+0x102>
		die("Failed to create socket");

	cprintf("opened socket\n");
  80009c:	83 ec 0c             	sub    $0xc,%esp
  80009f:	68 cb 27 80 00       	push   $0x8027cb
  8000a4:	e8 ff 04 00 00       	call   8005a8 <cprintf>

	// Construct the server sockaddr_in structure
	memset(&echoserver, 0, sizeof(echoserver));       // Clear struct
  8000a9:	83 c4 0c             	add    $0xc,%esp
  8000ac:	6a 10                	push   $0x10
  8000ae:	6a 00                	push   $0x0
  8000b0:	8d 5d d8             	lea    -0x28(%ebp),%ebx
  8000b3:	53                   	push   %ebx
  8000b4:	e8 cd 0c 00 00       	call   800d86 <memset>
	echoserver.sin_family = AF_INET;                  // Internet/IP
  8000b9:	c6 45 d9 02          	movb   $0x2,-0x27(%ebp)
	echoserver.sin_addr.s_addr = inet_addr(IPADDR);   // IP address
  8000bd:	c7 04 24 94 27 80 00 	movl   $0x802794,(%esp)
  8000c4:	e8 b8 03 00 00       	call   800481 <inet_addr>
  8000c9:	89 45 dc             	mov    %eax,-0x24(%ebp)
	echoserver.sin_port = htons(PORT);		  // server port
  8000cc:	c7 04 24 10 27 00 00 	movl   $0x2710,(%esp)
  8000d3:	e8 93 01 00 00       	call   80026b <htons>
  8000d8:	66 89 45 da          	mov    %ax,-0x26(%ebp)

	cprintf("trying to connect to server\n");
  8000dc:	c7 04 24 da 27 80 00 	movl   $0x8027da,(%esp)
  8000e3:	e8 c0 04 00 00       	call   8005a8 <cprintf>

	// Establish connection
	if (connect(sock, (struct sockaddr *) &echoserver, sizeof(echoserver)) < 0)
  8000e8:	83 c4 0c             	add    $0xc,%esp
  8000eb:	6a 10                	push   $0x10
  8000ed:	53                   	push   %ebx
  8000ee:	ff 75 b4             	pushl  -0x4c(%ebp)
  8000f1:	e8 77 1e 00 00       	call   801f6d <connect>
  8000f6:	83 c4 10             	add    $0x10,%esp
  8000f9:	85 c0                	test   %eax,%eax
  8000fb:	78 62                	js     80015f <umain+0x111>
		die("Failed to connect with server");

	cprintf("connected to server\n");
  8000fd:	83 ec 0c             	sub    $0xc,%esp
  800100:	68 15 28 80 00       	push   $0x802815
  800105:	e8 9e 04 00 00       	call   8005a8 <cprintf>

	// Send the word to the server
	echolen = strlen(msg);
  80010a:	83 c4 04             	add    $0x4,%esp
  80010d:	ff 35 00 30 80 00    	pushl  0x803000
  800113:	e8 f6 0a 00 00       	call   800c0e <strlen>
  800118:	89 c7                	mov    %eax,%edi
  80011a:	89 45 b0             	mov    %eax,-0x50(%ebp)
	if (write(sock, msg, echolen) != echolen)
  80011d:	83 c4 0c             	add    $0xc,%esp
  800120:	50                   	push   %eax
  800121:	ff 35 00 30 80 00    	pushl  0x803000
  800127:	ff 75 b4             	pushl  -0x4c(%ebp)
  80012a:	e8 d4 14 00 00       	call   801603 <write>
  80012f:	83 c4 10             	add    $0x10,%esp
  800132:	39 c7                	cmp    %eax,%edi
  800134:	75 35                	jne    80016b <umain+0x11d>
		die("Mismatch in number of sent bytes");

	// Receive the word back from the server
	cprintf("Received: \n");
  800136:	83 ec 0c             	sub    $0xc,%esp
  800139:	68 2a 28 80 00       	push   $0x80282a
  80013e:	e8 65 04 00 00       	call   8005a8 <cprintf>
	while (received < echolen) {
  800143:	83 c4 10             	add    $0x10,%esp
	int received = 0;
  800146:	be 00 00 00 00       	mov    $0x0,%esi
		int bytes = 0;
		if ((bytes = read(sock, buffer, BUFFSIZE-1)) < 1) {
  80014b:	8d 7d b8             	lea    -0x48(%ebp),%edi
	while (received < echolen) {
  80014e:	eb 3a                	jmp    80018a <umain+0x13c>
		die("Failed to create socket");
  800150:	b8 b3 27 80 00       	mov    $0x8027b3,%eax
  800155:	e8 d9 fe ff ff       	call   800033 <die>
  80015a:	e9 3d ff ff ff       	jmp    80009c <umain+0x4e>
		die("Failed to connect with server");
  80015f:	b8 f7 27 80 00       	mov    $0x8027f7,%eax
  800164:	e8 ca fe ff ff       	call   800033 <die>
  800169:	eb 92                	jmp    8000fd <umain+0xaf>
		die("Mismatch in number of sent bytes");
  80016b:	b8 44 28 80 00       	mov    $0x802844,%eax
  800170:	e8 be fe ff ff       	call   800033 <die>
  800175:	eb bf                	jmp    800136 <umain+0xe8>
			die("Failed to receive bytes from server");
		}
		received += bytes;
  800177:	01 de                	add    %ebx,%esi
		buffer[bytes] = '\0';        // Assure null terminated string
  800179:	c6 44 1d b8 00       	movb   $0x0,-0x48(%ebp,%ebx,1)
		cprintf(buffer);
  80017e:	83 ec 0c             	sub    $0xc,%esp
  800181:	57                   	push   %edi
  800182:	e8 21 04 00 00       	call   8005a8 <cprintf>
  800187:	83 c4 10             	add    $0x10,%esp
	while (received < echolen) {
  80018a:	3b 75 b0             	cmp    -0x50(%ebp),%esi
  80018d:	73 23                	jae    8001b2 <umain+0x164>
		if ((bytes = read(sock, buffer, BUFFSIZE-1)) < 1) {
  80018f:	83 ec 04             	sub    $0x4,%esp
  800192:	6a 1f                	push   $0x1f
  800194:	57                   	push   %edi
  800195:	ff 75 b4             	pushl  -0x4c(%ebp)
  800198:	e8 98 13 00 00       	call   801535 <read>
  80019d:	89 c3                	mov    %eax,%ebx
  80019f:	83 c4 10             	add    $0x10,%esp
  8001a2:	85 c0                	test   %eax,%eax
  8001a4:	7f d1                	jg     800177 <umain+0x129>
			die("Failed to receive bytes from server");
  8001a6:	b8 68 28 80 00       	mov    $0x802868,%eax
  8001ab:	e8 83 fe ff ff       	call   800033 <die>
  8001b0:	eb c5                	jmp    800177 <umain+0x129>
	}
	cprintf("\n");
  8001b2:	83 ec 0c             	sub    $0xc,%esp
  8001b5:	68 34 28 80 00       	push   $0x802834
  8001ba:	e8 e9 03 00 00       	call   8005a8 <cprintf>

	close(sock);
  8001bf:	83 c4 04             	add    $0x4,%esp
  8001c2:	ff 75 b4             	pushl  -0x4c(%ebp)
  8001c5:	e8 2f 12 00 00       	call   8013f9 <close>
}
  8001ca:	83 c4 10             	add    $0x10,%esp
  8001cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001d0:	5b                   	pop    %ebx
  8001d1:	5e                   	pop    %esi
  8001d2:	5f                   	pop    %edi
  8001d3:	5d                   	pop    %ebp
  8001d4:	c3                   	ret    

008001d5 <inet_ntoa>:
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
{
  8001d5:	55                   	push   %ebp
  8001d6:	89 e5                	mov    %esp,%ebp
  8001d8:	57                   	push   %edi
  8001d9:	56                   	push   %esi
  8001da:	53                   	push   %ebx
  8001db:	83 ec 14             	sub    $0x14,%esp
  static char str[16];
  u32_t s_addr = addr.s_addr;
  8001de:	8b 45 08             	mov    0x8(%ebp),%eax
  8001e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  8001e4:	8d 7d f0             	lea    -0x10(%ebp),%edi
  rp = str;
  8001e7:	c7 45 e0 00 40 80 00 	movl   $0x804000,-0x20(%ebp)
  8001ee:	eb 30                	jmp    800220 <inet_ntoa+0x4b>
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
      *rp++ = inv[i];
  8001f0:	0f b6 c2             	movzbl %dl,%eax
  8001f3:	0f b6 44 05 ed       	movzbl -0x13(%ebp,%eax,1),%eax
  8001f8:	88 01                	mov    %al,(%ecx)
  8001fa:	83 c1 01             	add    $0x1,%ecx
    while(i--)
  8001fd:	83 ea 01             	sub    $0x1,%edx
  800200:	80 fa ff             	cmp    $0xff,%dl
  800203:	75 eb                	jne    8001f0 <inet_ntoa+0x1b>
  800205:	89 f0                	mov    %esi,%eax
  800207:	0f b6 f0             	movzbl %al,%esi
  80020a:	03 75 e0             	add    -0x20(%ebp),%esi
    *rp++ = '.';
  80020d:	8d 46 01             	lea    0x1(%esi),%eax
  800210:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800213:	c6 06 2e             	movb   $0x2e,(%esi)
  800216:	83 c7 01             	add    $0x1,%edi
  for(n = 0; n < 4; n++) {
  800219:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80021c:	39 c7                	cmp    %eax,%edi
  80021e:	74 3b                	je     80025b <inet_ntoa+0x86>
  rp = str;
  800220:	b9 00 00 00 00       	mov    $0x0,%ecx
      rem = *ap % (u8_t)10;
  800225:	0f b6 17             	movzbl (%edi),%edx
      *ap /= (u8_t)10;
  800228:	0f b6 da             	movzbl %dl,%ebx
  80022b:	8d 04 9b             	lea    (%ebx,%ebx,4),%eax
  80022e:	8d 04 c3             	lea    (%ebx,%eax,8),%eax
  800231:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800234:	66 c1 e8 0b          	shr    $0xb,%ax
  800238:	88 07                	mov    %al,(%edi)
      inv[i++] = '0' + rem;
  80023a:	8d 71 01             	lea    0x1(%ecx),%esi
  80023d:	0f b6 c9             	movzbl %cl,%ecx
      rem = *ap % (u8_t)10;
  800240:	8d 1c 80             	lea    (%eax,%eax,4),%ebx
  800243:	01 db                	add    %ebx,%ebx
  800245:	29 da                	sub    %ebx,%edx
      inv[i++] = '0' + rem;
  800247:	83 c2 30             	add    $0x30,%edx
  80024a:	88 54 0d ed          	mov    %dl,-0x13(%ebp,%ecx,1)
  80024e:	89 f1                	mov    %esi,%ecx
    } while(*ap);
  800250:	84 c0                	test   %al,%al
  800252:	75 d1                	jne    800225 <inet_ntoa+0x50>
  800254:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      inv[i++] = '0' + rem;
  800257:	89 f2                	mov    %esi,%edx
  800259:	eb a2                	jmp    8001fd <inet_ntoa+0x28>
    ap++;
  }
  *--rp = 0;
  80025b:	c6 06 00             	movb   $0x0,(%esi)
  return str;
}
  80025e:	b8 00 40 80 00       	mov    $0x804000,%eax
  800263:	83 c4 14             	add    $0x14,%esp
  800266:	5b                   	pop    %ebx
  800267:	5e                   	pop    %esi
  800268:	5f                   	pop    %edi
  800269:	5d                   	pop    %ebp
  80026a:	c3                   	ret    

0080026b <htons>:
 * @param n u16_t in host byte order
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  80026b:	55                   	push   %ebp
  80026c:	89 e5                	mov    %esp,%ebp
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  80026e:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  800272:	66 c1 c0 08          	rol    $0x8,%ax
}
  800276:	5d                   	pop    %ebp
  800277:	c3                   	ret    

00800278 <ntohs>:
 * @param n u16_t in network byte order
 * @return n in host byte order
 */
u16_t
ntohs(u16_t n)
{
  800278:	55                   	push   %ebp
  800279:	89 e5                	mov    %esp,%ebp
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  80027b:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  80027f:	66 c1 c0 08          	rol    $0x8,%ax
  return htons(n);
}
  800283:	5d                   	pop    %ebp
  800284:	c3                   	ret    

00800285 <htonl>:
 * @param n u32_t in host byte order
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  800285:	55                   	push   %ebp
  800286:	89 e5                	mov    %esp,%ebp
  800288:	8b 55 08             	mov    0x8(%ebp),%edx
  return ((n & 0xff) << 24) |
  80028b:	89 d0                	mov    %edx,%eax
  80028d:	c1 e0 18             	shl    $0x18,%eax
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
  800290:	89 d1                	mov    %edx,%ecx
  800292:	c1 e9 18             	shr    $0x18,%ecx
    ((n & 0xff0000UL) >> 8) |
  800295:	09 c8                	or     %ecx,%eax
    ((n & 0xff00) << 8) |
  800297:	89 d1                	mov    %edx,%ecx
  800299:	c1 e1 08             	shl    $0x8,%ecx
  80029c:	81 e1 00 00 ff 00    	and    $0xff0000,%ecx
    ((n & 0xff0000UL) >> 8) |
  8002a2:	09 c8                	or     %ecx,%eax
  8002a4:	c1 ea 08             	shr    $0x8,%edx
  8002a7:	81 e2 00 ff 00 00    	and    $0xff00,%edx
  8002ad:	09 d0                	or     %edx,%eax
}
  8002af:	5d                   	pop    %ebp
  8002b0:	c3                   	ret    

008002b1 <inet_aton>:
{
  8002b1:	55                   	push   %ebp
  8002b2:	89 e5                	mov    %esp,%ebp
  8002b4:	57                   	push   %edi
  8002b5:	56                   	push   %esi
  8002b6:	53                   	push   %ebx
  8002b7:	83 ec 1c             	sub    $0x1c,%esp
  8002ba:	8b 45 08             	mov    0x8(%ebp),%eax
  c = *cp;
  8002bd:	0f be 10             	movsbl (%eax),%edx
  u32_t *pp = parts;
  8002c0:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  8002c3:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8002c6:	e9 a9 00 00 00       	jmp    800374 <inet_aton+0xc3>
      c = *++cp;
  8002cb:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      if (c == 'x' || c == 'X') {
  8002cf:	89 d1                	mov    %edx,%ecx
  8002d1:	83 e1 df             	and    $0xffffffdf,%ecx
  8002d4:	80 f9 58             	cmp    $0x58,%cl
  8002d7:	74 12                	je     8002eb <inet_aton+0x3a>
      c = *++cp;
  8002d9:	83 c0 01             	add    $0x1,%eax
  8002dc:	0f be d2             	movsbl %dl,%edx
        base = 8;
  8002df:	c7 45 dc 08 00 00 00 	movl   $0x8,-0x24(%ebp)
  8002e6:	e9 a5 00 00 00       	jmp    800390 <inet_aton+0xdf>
        c = *++cp;
  8002eb:	0f be 50 02          	movsbl 0x2(%eax),%edx
  8002ef:	8d 40 02             	lea    0x2(%eax),%eax
        base = 16;
  8002f2:	c7 45 dc 10 00 00 00 	movl   $0x10,-0x24(%ebp)
  8002f9:	e9 92 00 00 00       	jmp    800390 <inet_aton+0xdf>
      } else if (base == 16 && isxdigit(c)) {
  8002fe:	83 7d dc 10          	cmpl   $0x10,-0x24(%ebp)
  800302:	75 4a                	jne    80034e <inet_aton+0x9d>
  800304:	8d 5e 9f             	lea    -0x61(%esi),%ebx
  800307:	89 d1                	mov    %edx,%ecx
  800309:	83 e1 df             	and    $0xffffffdf,%ecx
  80030c:	83 e9 41             	sub    $0x41,%ecx
  80030f:	80 f9 05             	cmp    $0x5,%cl
  800312:	77 3a                	ja     80034e <inet_aton+0x9d>
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
  800314:	c1 e7 04             	shl    $0x4,%edi
  800317:	83 c2 0a             	add    $0xa,%edx
  80031a:	80 fb 1a             	cmp    $0x1a,%bl
  80031d:	19 c9                	sbb    %ecx,%ecx
  80031f:	83 e1 20             	and    $0x20,%ecx
  800322:	83 c1 41             	add    $0x41,%ecx
  800325:	29 ca                	sub    %ecx,%edx
  800327:	09 d7                	or     %edx,%edi
        c = *++cp;
  800329:	8b 75 e0             	mov    -0x20(%ebp),%esi
  80032c:	0f be 56 01          	movsbl 0x1(%esi),%edx
  800330:	83 c0 01             	add    $0x1,%eax
  800333:	89 45 e0             	mov    %eax,-0x20(%ebp)
      if (isdigit(c)) {
  800336:	89 d6                	mov    %edx,%esi
  800338:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80033b:	80 f9 09             	cmp    $0x9,%cl
  80033e:	77 be                	ja     8002fe <inet_aton+0x4d>
        val = (val * base) + (int)(c - '0');
  800340:	0f af 7d dc          	imul   -0x24(%ebp),%edi
  800344:	8d 7c 3a d0          	lea    -0x30(%edx,%edi,1),%edi
        c = *++cp;
  800348:	0f be 50 01          	movsbl 0x1(%eax),%edx
  80034c:	eb e2                	jmp    800330 <inet_aton+0x7f>
    if (c == '.') {
  80034e:	83 fa 2e             	cmp    $0x2e,%edx
  800351:	75 44                	jne    800397 <inet_aton+0xe6>
      if (pp >= parts + 3)
  800353:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800356:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800359:	39 c3                	cmp    %eax,%ebx
  80035b:	0f 84 13 01 00 00    	je     800474 <inet_aton+0x1c3>
      *pp++ = val;
  800361:	83 c3 04             	add    $0x4,%ebx
  800364:	89 5d d8             	mov    %ebx,-0x28(%ebp)
  800367:	89 7b fc             	mov    %edi,-0x4(%ebx)
      c = *++cp;
  80036a:	8b 75 e0             	mov    -0x20(%ebp),%esi
  80036d:	8d 46 01             	lea    0x1(%esi),%eax
  800370:	0f be 56 01          	movsbl 0x1(%esi),%edx
    if (!isdigit(c))
  800374:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800377:	80 f9 09             	cmp    $0x9,%cl
  80037a:	0f 87 ed 00 00 00    	ja     80046d <inet_aton+0x1bc>
    base = 10;
  800380:	c7 45 dc 0a 00 00 00 	movl   $0xa,-0x24(%ebp)
    if (c == '0') {
  800387:	83 fa 30             	cmp    $0x30,%edx
  80038a:	0f 84 3b ff ff ff    	je     8002cb <inet_aton+0x1a>
        base = 8;
  800390:	bf 00 00 00 00       	mov    $0x0,%edi
  800395:	eb 9c                	jmp    800333 <inet_aton+0x82>
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  800397:	85 d2                	test   %edx,%edx
  800399:	74 29                	je     8003c4 <inet_aton+0x113>
    return (0);
  80039b:	b8 00 00 00 00       	mov    $0x0,%eax
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  8003a0:	89 f3                	mov    %esi,%ebx
  8003a2:	80 fb 1f             	cmp    $0x1f,%bl
  8003a5:	0f 86 ce 00 00 00    	jbe    800479 <inet_aton+0x1c8>
  8003ab:	84 d2                	test   %dl,%dl
  8003ad:	0f 88 c6 00 00 00    	js     800479 <inet_aton+0x1c8>
  8003b3:	83 fa 20             	cmp    $0x20,%edx
  8003b6:	74 0c                	je     8003c4 <inet_aton+0x113>
  8003b8:	83 ea 09             	sub    $0x9,%edx
  8003bb:	83 fa 04             	cmp    $0x4,%edx
  8003be:	0f 87 b5 00 00 00    	ja     800479 <inet_aton+0x1c8>
  n = pp - parts + 1;
  8003c4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8003c7:	8b 75 d8             	mov    -0x28(%ebp),%esi
  8003ca:	29 c6                	sub    %eax,%esi
  8003cc:	89 f0                	mov    %esi,%eax
  8003ce:	c1 f8 02             	sar    $0x2,%eax
  8003d1:	83 c0 01             	add    $0x1,%eax
  switch (n) {
  8003d4:	83 f8 02             	cmp    $0x2,%eax
  8003d7:	74 5e                	je     800437 <inet_aton+0x186>
  8003d9:	83 f8 02             	cmp    $0x2,%eax
  8003dc:	7e 35                	jle    800413 <inet_aton+0x162>
  8003de:	83 f8 03             	cmp    $0x3,%eax
  8003e1:	74 6b                	je     80044e <inet_aton+0x19d>
  8003e3:	83 f8 04             	cmp    $0x4,%eax
  8003e6:	75 2f                	jne    800417 <inet_aton+0x166>
      return (0);
  8003e8:	b8 00 00 00 00       	mov    $0x0,%eax
    if (val > 0xff)
  8003ed:	81 ff ff 00 00 00    	cmp    $0xff,%edi
  8003f3:	0f 87 80 00 00 00    	ja     800479 <inet_aton+0x1c8>
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
  8003f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003fc:	c1 e0 18             	shl    $0x18,%eax
  8003ff:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800402:	c1 e2 10             	shl    $0x10,%edx
  800405:	09 d0                	or     %edx,%eax
  800407:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80040a:	c1 e2 08             	shl    $0x8,%edx
  80040d:	09 d0                	or     %edx,%eax
  80040f:	09 c7                	or     %eax,%edi
    break;
  800411:	eb 04                	jmp    800417 <inet_aton+0x166>
  switch (n) {
  800413:	85 c0                	test   %eax,%eax
  800415:	74 62                	je     800479 <inet_aton+0x1c8>
  return (1);
  800417:	b8 01 00 00 00       	mov    $0x1,%eax
  if (addr)
  80041c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800420:	74 57                	je     800479 <inet_aton+0x1c8>
    addr->s_addr = htonl(val);
  800422:	57                   	push   %edi
  800423:	e8 5d fe ff ff       	call   800285 <htonl>
  800428:	83 c4 04             	add    $0x4,%esp
  80042b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80042e:	89 06                	mov    %eax,(%esi)
  return (1);
  800430:	b8 01 00 00 00       	mov    $0x1,%eax
  800435:	eb 42                	jmp    800479 <inet_aton+0x1c8>
      return (0);
  800437:	b8 00 00 00 00       	mov    $0x0,%eax
    if (val > 0xffffffUL)
  80043c:	81 ff ff ff ff 00    	cmp    $0xffffff,%edi
  800442:	77 35                	ja     800479 <inet_aton+0x1c8>
    val |= parts[0] << 24;
  800444:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800447:	c1 e0 18             	shl    $0x18,%eax
  80044a:	09 c7                	or     %eax,%edi
    break;
  80044c:	eb c9                	jmp    800417 <inet_aton+0x166>
      return (0);
  80044e:	b8 00 00 00 00       	mov    $0x0,%eax
    if (val > 0xffff)
  800453:	81 ff ff ff 00 00    	cmp    $0xffff,%edi
  800459:	77 1e                	ja     800479 <inet_aton+0x1c8>
    val |= (parts[0] << 24) | (parts[1] << 16);
  80045b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80045e:	c1 e0 18             	shl    $0x18,%eax
  800461:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800464:	c1 e2 10             	shl    $0x10,%edx
  800467:	09 d0                	or     %edx,%eax
  800469:	09 c7                	or     %eax,%edi
    break;
  80046b:	eb aa                	jmp    800417 <inet_aton+0x166>
      return (0);
  80046d:	b8 00 00 00 00       	mov    $0x0,%eax
  800472:	eb 05                	jmp    800479 <inet_aton+0x1c8>
        return (0);
  800474:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800479:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80047c:	5b                   	pop    %ebx
  80047d:	5e                   	pop    %esi
  80047e:	5f                   	pop    %edi
  80047f:	5d                   	pop    %ebp
  800480:	c3                   	ret    

00800481 <inet_addr>:
{
  800481:	55                   	push   %ebp
  800482:	89 e5                	mov    %esp,%ebp
  800484:	83 ec 10             	sub    $0x10,%esp
  if (inet_aton(cp, &val)) {
  800487:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80048a:	50                   	push   %eax
  80048b:	ff 75 08             	pushl  0x8(%ebp)
  80048e:	e8 1e fe ff ff       	call   8002b1 <inet_aton>
  800493:	83 c4 08             	add    $0x8,%esp
    return (val.s_addr);
  800496:	85 c0                	test   %eax,%eax
  800498:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  80049d:	0f 45 45 fc          	cmovne -0x4(%ebp),%eax
}
  8004a1:	c9                   	leave  
  8004a2:	c3                   	ret    

008004a3 <ntohl>:
 * @param n u32_t in network byte order
 * @return n in host byte order
 */
u32_t
ntohl(u32_t n)
{
  8004a3:	55                   	push   %ebp
  8004a4:	89 e5                	mov    %esp,%ebp
  return htonl(n);
  8004a6:	ff 75 08             	pushl  0x8(%ebp)
  8004a9:	e8 d7 fd ff ff       	call   800285 <htonl>
  8004ae:	83 c4 04             	add    $0x4,%esp
}
  8004b1:	c9                   	leave  
  8004b2:	c3                   	ret    

008004b3 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8004b3:	55                   	push   %ebp
  8004b4:	89 e5                	mov    %esp,%ebp
  8004b6:	56                   	push   %esi
  8004b7:	53                   	push   %ebx
  8004b8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8004bb:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
    thisenv = &envs[ENVX(sys_getenvid())];
  8004be:	e8 3d 0b 00 00       	call   801000 <sys_getenvid>
  8004c3:	25 ff 03 00 00       	and    $0x3ff,%eax
  8004c8:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8004cb:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8004d0:	a3 18 40 80 00       	mov    %eax,0x804018

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8004d5:	85 db                	test   %ebx,%ebx
  8004d7:	7e 07                	jle    8004e0 <libmain+0x2d>
		binaryname = argv[0];
  8004d9:	8b 06                	mov    (%esi),%eax
  8004db:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	umain(argc, argv);
  8004e0:	83 ec 08             	sub    $0x8,%esp
  8004e3:	56                   	push   %esi
  8004e4:	53                   	push   %ebx
  8004e5:	e8 64 fb ff ff       	call   80004e <umain>

	// exit gracefully
	exit();
  8004ea:	e8 0a 00 00 00       	call   8004f9 <exit>
}
  8004ef:	83 c4 10             	add    $0x10,%esp
  8004f2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8004f5:	5b                   	pop    %ebx
  8004f6:	5e                   	pop    %esi
  8004f7:	5d                   	pop    %ebp
  8004f8:	c3                   	ret    

008004f9 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8004f9:	55                   	push   %ebp
  8004fa:	89 e5                	mov    %esp,%ebp
  8004fc:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8004ff:	e8 20 0f 00 00       	call   801424 <close_all>
	sys_env_destroy(0);
  800504:	83 ec 0c             	sub    $0xc,%esp
  800507:	6a 00                	push   $0x0
  800509:	e8 b1 0a 00 00       	call   800fbf <sys_env_destroy>
}
  80050e:	83 c4 10             	add    $0x10,%esp
  800511:	c9                   	leave  
  800512:	c3                   	ret    

00800513 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800513:	55                   	push   %ebp
  800514:	89 e5                	mov    %esp,%ebp
  800516:	53                   	push   %ebx
  800517:	83 ec 04             	sub    $0x4,%esp
  80051a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80051d:	8b 13                	mov    (%ebx),%edx
  80051f:	8d 42 01             	lea    0x1(%edx),%eax
  800522:	89 03                	mov    %eax,(%ebx)
  800524:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800527:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80052b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800530:	74 09                	je     80053b <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800532:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800536:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800539:	c9                   	leave  
  80053a:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80053b:	83 ec 08             	sub    $0x8,%esp
  80053e:	68 ff 00 00 00       	push   $0xff
  800543:	8d 43 08             	lea    0x8(%ebx),%eax
  800546:	50                   	push   %eax
  800547:	e8 36 0a 00 00       	call   800f82 <sys_cputs>
		b->idx = 0;
  80054c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800552:	83 c4 10             	add    $0x10,%esp
  800555:	eb db                	jmp    800532 <putch+0x1f>

00800557 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800557:	55                   	push   %ebp
  800558:	89 e5                	mov    %esp,%ebp
  80055a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800560:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800567:	00 00 00 
	b.cnt = 0;
  80056a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800571:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800574:	ff 75 0c             	pushl  0xc(%ebp)
  800577:	ff 75 08             	pushl  0x8(%ebp)
  80057a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800580:	50                   	push   %eax
  800581:	68 13 05 80 00       	push   $0x800513
  800586:	e8 1a 01 00 00       	call   8006a5 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80058b:	83 c4 08             	add    $0x8,%esp
  80058e:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800594:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80059a:	50                   	push   %eax
  80059b:	e8 e2 09 00 00       	call   800f82 <sys_cputs>

	return b.cnt;
}
  8005a0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8005a6:	c9                   	leave  
  8005a7:	c3                   	ret    

008005a8 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8005a8:	55                   	push   %ebp
  8005a9:	89 e5                	mov    %esp,%ebp
  8005ab:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8005ae:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8005b1:	50                   	push   %eax
  8005b2:	ff 75 08             	pushl  0x8(%ebp)
  8005b5:	e8 9d ff ff ff       	call   800557 <vcprintf>
	va_end(ap);

	return cnt;
}
  8005ba:	c9                   	leave  
  8005bb:	c3                   	ret    

008005bc <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005bc:	55                   	push   %ebp
  8005bd:	89 e5                	mov    %esp,%ebp
  8005bf:	57                   	push   %edi
  8005c0:	56                   	push   %esi
  8005c1:	53                   	push   %ebx
  8005c2:	83 ec 1c             	sub    $0x1c,%esp
  8005c5:	89 c7                	mov    %eax,%edi
  8005c7:	89 d6                	mov    %edx,%esi
  8005c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8005cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005cf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005d2:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005d5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8005d8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8005dd:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8005e0:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8005e3:	39 d3                	cmp    %edx,%ebx
  8005e5:	72 05                	jb     8005ec <printnum+0x30>
  8005e7:	39 45 10             	cmp    %eax,0x10(%ebp)
  8005ea:	77 7a                	ja     800666 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005ec:	83 ec 0c             	sub    $0xc,%esp
  8005ef:	ff 75 18             	pushl  0x18(%ebp)
  8005f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f5:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005f8:	53                   	push   %ebx
  8005f9:	ff 75 10             	pushl  0x10(%ebp)
  8005fc:	83 ec 08             	sub    $0x8,%esp
  8005ff:	ff 75 e4             	pushl  -0x1c(%ebp)
  800602:	ff 75 e0             	pushl  -0x20(%ebp)
  800605:	ff 75 dc             	pushl  -0x24(%ebp)
  800608:	ff 75 d8             	pushl  -0x28(%ebp)
  80060b:	e8 20 1f 00 00       	call   802530 <__udivdi3>
  800610:	83 c4 18             	add    $0x18,%esp
  800613:	52                   	push   %edx
  800614:	50                   	push   %eax
  800615:	89 f2                	mov    %esi,%edx
  800617:	89 f8                	mov    %edi,%eax
  800619:	e8 9e ff ff ff       	call   8005bc <printnum>
  80061e:	83 c4 20             	add    $0x20,%esp
  800621:	eb 13                	jmp    800636 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800623:	83 ec 08             	sub    $0x8,%esp
  800626:	56                   	push   %esi
  800627:	ff 75 18             	pushl  0x18(%ebp)
  80062a:	ff d7                	call   *%edi
  80062c:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80062f:	83 eb 01             	sub    $0x1,%ebx
  800632:	85 db                	test   %ebx,%ebx
  800634:	7f ed                	jg     800623 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800636:	83 ec 08             	sub    $0x8,%esp
  800639:	56                   	push   %esi
  80063a:	83 ec 04             	sub    $0x4,%esp
  80063d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800640:	ff 75 e0             	pushl  -0x20(%ebp)
  800643:	ff 75 dc             	pushl  -0x24(%ebp)
  800646:	ff 75 d8             	pushl  -0x28(%ebp)
  800649:	e8 02 20 00 00       	call   802650 <__umoddi3>
  80064e:	83 c4 14             	add    $0x14,%esp
  800651:	0f be 80 96 28 80 00 	movsbl 0x802896(%eax),%eax
  800658:	50                   	push   %eax
  800659:	ff d7                	call   *%edi
}
  80065b:	83 c4 10             	add    $0x10,%esp
  80065e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800661:	5b                   	pop    %ebx
  800662:	5e                   	pop    %esi
  800663:	5f                   	pop    %edi
  800664:	5d                   	pop    %ebp
  800665:	c3                   	ret    
  800666:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800669:	eb c4                	jmp    80062f <printnum+0x73>

0080066b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80066b:	55                   	push   %ebp
  80066c:	89 e5                	mov    %esp,%ebp
  80066e:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800671:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800675:	8b 10                	mov    (%eax),%edx
  800677:	3b 50 04             	cmp    0x4(%eax),%edx
  80067a:	73 0a                	jae    800686 <sprintputch+0x1b>
		*b->buf++ = ch;
  80067c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80067f:	89 08                	mov    %ecx,(%eax)
  800681:	8b 45 08             	mov    0x8(%ebp),%eax
  800684:	88 02                	mov    %al,(%edx)
}
  800686:	5d                   	pop    %ebp
  800687:	c3                   	ret    

00800688 <printfmt>:
{
  800688:	55                   	push   %ebp
  800689:	89 e5                	mov    %esp,%ebp
  80068b:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80068e:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800691:	50                   	push   %eax
  800692:	ff 75 10             	pushl  0x10(%ebp)
  800695:	ff 75 0c             	pushl  0xc(%ebp)
  800698:	ff 75 08             	pushl  0x8(%ebp)
  80069b:	e8 05 00 00 00       	call   8006a5 <vprintfmt>
}
  8006a0:	83 c4 10             	add    $0x10,%esp
  8006a3:	c9                   	leave  
  8006a4:	c3                   	ret    

008006a5 <vprintfmt>:
{
  8006a5:	55                   	push   %ebp
  8006a6:	89 e5                	mov    %esp,%ebp
  8006a8:	57                   	push   %edi
  8006a9:	56                   	push   %esi
  8006aa:	53                   	push   %ebx
  8006ab:	83 ec 2c             	sub    $0x2c,%esp
  8006ae:	8b 75 08             	mov    0x8(%ebp),%esi
  8006b1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8006b4:	8b 7d 10             	mov    0x10(%ebp),%edi
  8006b7:	e9 21 04 00 00       	jmp    800add <vprintfmt+0x438>
		padc = ' ';
  8006bc:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8006c0:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8006c7:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  8006ce:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8006d5:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8006da:	8d 47 01             	lea    0x1(%edi),%eax
  8006dd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006e0:	0f b6 17             	movzbl (%edi),%edx
  8006e3:	8d 42 dd             	lea    -0x23(%edx),%eax
  8006e6:	3c 55                	cmp    $0x55,%al
  8006e8:	0f 87 90 04 00 00    	ja     800b7e <vprintfmt+0x4d9>
  8006ee:	0f b6 c0             	movzbl %al,%eax
  8006f1:	ff 24 85 e0 29 80 00 	jmp    *0x8029e0(,%eax,4)
  8006f8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8006fb:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8006ff:	eb d9                	jmp    8006da <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800701:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800704:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800708:	eb d0                	jmp    8006da <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80070a:	0f b6 d2             	movzbl %dl,%edx
  80070d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800710:	b8 00 00 00 00       	mov    $0x0,%eax
  800715:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800718:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80071b:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80071f:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800722:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800725:	83 f9 09             	cmp    $0x9,%ecx
  800728:	77 55                	ja     80077f <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  80072a:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80072d:	eb e9                	jmp    800718 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  80072f:	8b 45 14             	mov    0x14(%ebp),%eax
  800732:	8b 00                	mov    (%eax),%eax
  800734:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800737:	8b 45 14             	mov    0x14(%ebp),%eax
  80073a:	8d 40 04             	lea    0x4(%eax),%eax
  80073d:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800740:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800743:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800747:	79 91                	jns    8006da <vprintfmt+0x35>
				width = precision, precision = -1;
  800749:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80074c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80074f:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800756:	eb 82                	jmp    8006da <vprintfmt+0x35>
  800758:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80075b:	85 c0                	test   %eax,%eax
  80075d:	ba 00 00 00 00       	mov    $0x0,%edx
  800762:	0f 49 d0             	cmovns %eax,%edx
  800765:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800768:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80076b:	e9 6a ff ff ff       	jmp    8006da <vprintfmt+0x35>
  800770:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800773:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  80077a:	e9 5b ff ff ff       	jmp    8006da <vprintfmt+0x35>
  80077f:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800782:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800785:	eb bc                	jmp    800743 <vprintfmt+0x9e>
			lflag++;
  800787:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80078a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80078d:	e9 48 ff ff ff       	jmp    8006da <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800792:	8b 45 14             	mov    0x14(%ebp),%eax
  800795:	8d 78 04             	lea    0x4(%eax),%edi
  800798:	83 ec 08             	sub    $0x8,%esp
  80079b:	53                   	push   %ebx
  80079c:	ff 30                	pushl  (%eax)
  80079e:	ff d6                	call   *%esi
			break;
  8007a0:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8007a3:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8007a6:	e9 2f 03 00 00       	jmp    800ada <vprintfmt+0x435>
			err = va_arg(ap, int);
  8007ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ae:	8d 78 04             	lea    0x4(%eax),%edi
  8007b1:	8b 00                	mov    (%eax),%eax
  8007b3:	99                   	cltd   
  8007b4:	31 d0                	xor    %edx,%eax
  8007b6:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8007b8:	83 f8 0f             	cmp    $0xf,%eax
  8007bb:	7f 23                	jg     8007e0 <vprintfmt+0x13b>
  8007bd:	8b 14 85 40 2b 80 00 	mov    0x802b40(,%eax,4),%edx
  8007c4:	85 d2                	test   %edx,%edx
  8007c6:	74 18                	je     8007e0 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  8007c8:	52                   	push   %edx
  8007c9:	68 9b 2c 80 00       	push   $0x802c9b
  8007ce:	53                   	push   %ebx
  8007cf:	56                   	push   %esi
  8007d0:	e8 b3 fe ff ff       	call   800688 <printfmt>
  8007d5:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8007d8:	89 7d 14             	mov    %edi,0x14(%ebp)
  8007db:	e9 fa 02 00 00       	jmp    800ada <vprintfmt+0x435>
				printfmt(putch, putdat, "error %d", err);
  8007e0:	50                   	push   %eax
  8007e1:	68 ae 28 80 00       	push   $0x8028ae
  8007e6:	53                   	push   %ebx
  8007e7:	56                   	push   %esi
  8007e8:	e8 9b fe ff ff       	call   800688 <printfmt>
  8007ed:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8007f0:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8007f3:	e9 e2 02 00 00       	jmp    800ada <vprintfmt+0x435>
			if ((p = va_arg(ap, char *)) == NULL)
  8007f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fb:	83 c0 04             	add    $0x4,%eax
  8007fe:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800801:	8b 45 14             	mov    0x14(%ebp),%eax
  800804:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800806:	85 ff                	test   %edi,%edi
  800808:	b8 a7 28 80 00       	mov    $0x8028a7,%eax
  80080d:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800810:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800814:	0f 8e bd 00 00 00    	jle    8008d7 <vprintfmt+0x232>
  80081a:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80081e:	75 0e                	jne    80082e <vprintfmt+0x189>
  800820:	89 75 08             	mov    %esi,0x8(%ebp)
  800823:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800826:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800829:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80082c:	eb 6d                	jmp    80089b <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  80082e:	83 ec 08             	sub    $0x8,%esp
  800831:	ff 75 d0             	pushl  -0x30(%ebp)
  800834:	57                   	push   %edi
  800835:	e8 ec 03 00 00       	call   800c26 <strnlen>
  80083a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80083d:	29 c1                	sub    %eax,%ecx
  80083f:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800842:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800845:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800849:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80084c:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  80084f:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800851:	eb 0f                	jmp    800862 <vprintfmt+0x1bd>
					putch(padc, putdat);
  800853:	83 ec 08             	sub    $0x8,%esp
  800856:	53                   	push   %ebx
  800857:	ff 75 e0             	pushl  -0x20(%ebp)
  80085a:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80085c:	83 ef 01             	sub    $0x1,%edi
  80085f:	83 c4 10             	add    $0x10,%esp
  800862:	85 ff                	test   %edi,%edi
  800864:	7f ed                	jg     800853 <vprintfmt+0x1ae>
  800866:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800869:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  80086c:	85 c9                	test   %ecx,%ecx
  80086e:	b8 00 00 00 00       	mov    $0x0,%eax
  800873:	0f 49 c1             	cmovns %ecx,%eax
  800876:	29 c1                	sub    %eax,%ecx
  800878:	89 75 08             	mov    %esi,0x8(%ebp)
  80087b:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80087e:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800881:	89 cb                	mov    %ecx,%ebx
  800883:	eb 16                	jmp    80089b <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  800885:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800889:	75 31                	jne    8008bc <vprintfmt+0x217>
					putch(ch, putdat);
  80088b:	83 ec 08             	sub    $0x8,%esp
  80088e:	ff 75 0c             	pushl  0xc(%ebp)
  800891:	50                   	push   %eax
  800892:	ff 55 08             	call   *0x8(%ebp)
  800895:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800898:	83 eb 01             	sub    $0x1,%ebx
  80089b:	83 c7 01             	add    $0x1,%edi
  80089e:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8008a2:	0f be c2             	movsbl %dl,%eax
  8008a5:	85 c0                	test   %eax,%eax
  8008a7:	74 59                	je     800902 <vprintfmt+0x25d>
  8008a9:	85 f6                	test   %esi,%esi
  8008ab:	78 d8                	js     800885 <vprintfmt+0x1e0>
  8008ad:	83 ee 01             	sub    $0x1,%esi
  8008b0:	79 d3                	jns    800885 <vprintfmt+0x1e0>
  8008b2:	89 df                	mov    %ebx,%edi
  8008b4:	8b 75 08             	mov    0x8(%ebp),%esi
  8008b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8008ba:	eb 37                	jmp    8008f3 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  8008bc:	0f be d2             	movsbl %dl,%edx
  8008bf:	83 ea 20             	sub    $0x20,%edx
  8008c2:	83 fa 5e             	cmp    $0x5e,%edx
  8008c5:	76 c4                	jbe    80088b <vprintfmt+0x1e6>
					putch('?', putdat);
  8008c7:	83 ec 08             	sub    $0x8,%esp
  8008ca:	ff 75 0c             	pushl  0xc(%ebp)
  8008cd:	6a 3f                	push   $0x3f
  8008cf:	ff 55 08             	call   *0x8(%ebp)
  8008d2:	83 c4 10             	add    $0x10,%esp
  8008d5:	eb c1                	jmp    800898 <vprintfmt+0x1f3>
  8008d7:	89 75 08             	mov    %esi,0x8(%ebp)
  8008da:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8008dd:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8008e0:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8008e3:	eb b6                	jmp    80089b <vprintfmt+0x1f6>
				putch(' ', putdat);
  8008e5:	83 ec 08             	sub    $0x8,%esp
  8008e8:	53                   	push   %ebx
  8008e9:	6a 20                	push   $0x20
  8008eb:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8008ed:	83 ef 01             	sub    $0x1,%edi
  8008f0:	83 c4 10             	add    $0x10,%esp
  8008f3:	85 ff                	test   %edi,%edi
  8008f5:	7f ee                	jg     8008e5 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  8008f7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8008fa:	89 45 14             	mov    %eax,0x14(%ebp)
  8008fd:	e9 d8 01 00 00       	jmp    800ada <vprintfmt+0x435>
  800902:	89 df                	mov    %ebx,%edi
  800904:	8b 75 08             	mov    0x8(%ebp),%esi
  800907:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80090a:	eb e7                	jmp    8008f3 <vprintfmt+0x24e>
	if (lflag >= 2)
  80090c:	83 f9 01             	cmp    $0x1,%ecx
  80090f:	7e 45                	jle    800956 <vprintfmt+0x2b1>
		return va_arg(*ap, long long);
  800911:	8b 45 14             	mov    0x14(%ebp),%eax
  800914:	8b 50 04             	mov    0x4(%eax),%edx
  800917:	8b 00                	mov    (%eax),%eax
  800919:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80091c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80091f:	8b 45 14             	mov    0x14(%ebp),%eax
  800922:	8d 40 08             	lea    0x8(%eax),%eax
  800925:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800928:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80092c:	79 62                	jns    800990 <vprintfmt+0x2eb>
				putch('-', putdat);
  80092e:	83 ec 08             	sub    $0x8,%esp
  800931:	53                   	push   %ebx
  800932:	6a 2d                	push   $0x2d
  800934:	ff d6                	call   *%esi
				num = -(long long) num;
  800936:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800939:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80093c:	f7 d8                	neg    %eax
  80093e:	83 d2 00             	adc    $0x0,%edx
  800941:	f7 da                	neg    %edx
  800943:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800946:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800949:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80094c:	ba 0a 00 00 00       	mov    $0xa,%edx
  800951:	e9 66 01 00 00       	jmp    800abc <vprintfmt+0x417>
	else if (lflag)
  800956:	85 c9                	test   %ecx,%ecx
  800958:	75 1b                	jne    800975 <vprintfmt+0x2d0>
		return va_arg(*ap, int);
  80095a:	8b 45 14             	mov    0x14(%ebp),%eax
  80095d:	8b 00                	mov    (%eax),%eax
  80095f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800962:	89 c1                	mov    %eax,%ecx
  800964:	c1 f9 1f             	sar    $0x1f,%ecx
  800967:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80096a:	8b 45 14             	mov    0x14(%ebp),%eax
  80096d:	8d 40 04             	lea    0x4(%eax),%eax
  800970:	89 45 14             	mov    %eax,0x14(%ebp)
  800973:	eb b3                	jmp    800928 <vprintfmt+0x283>
		return va_arg(*ap, long);
  800975:	8b 45 14             	mov    0x14(%ebp),%eax
  800978:	8b 00                	mov    (%eax),%eax
  80097a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80097d:	89 c1                	mov    %eax,%ecx
  80097f:	c1 f9 1f             	sar    $0x1f,%ecx
  800982:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800985:	8b 45 14             	mov    0x14(%ebp),%eax
  800988:	8d 40 04             	lea    0x4(%eax),%eax
  80098b:	89 45 14             	mov    %eax,0x14(%ebp)
  80098e:	eb 98                	jmp    800928 <vprintfmt+0x283>
			base = 10;
  800990:	ba 0a 00 00 00       	mov    $0xa,%edx
  800995:	e9 22 01 00 00       	jmp    800abc <vprintfmt+0x417>
	if (lflag >= 2)
  80099a:	83 f9 01             	cmp    $0x1,%ecx
  80099d:	7e 21                	jle    8009c0 <vprintfmt+0x31b>
		return va_arg(*ap, unsigned long long);
  80099f:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a2:	8b 50 04             	mov    0x4(%eax),%edx
  8009a5:	8b 00                	mov    (%eax),%eax
  8009a7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009aa:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b0:	8d 40 08             	lea    0x8(%eax),%eax
  8009b3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8009b6:	ba 0a 00 00 00       	mov    $0xa,%edx
  8009bb:	e9 fc 00 00 00       	jmp    800abc <vprintfmt+0x417>
	else if (lflag)
  8009c0:	85 c9                	test   %ecx,%ecx
  8009c2:	75 23                	jne    8009e7 <vprintfmt+0x342>
		return va_arg(*ap, unsigned int);
  8009c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c7:	8b 00                	mov    (%eax),%eax
  8009c9:	ba 00 00 00 00       	mov    $0x0,%edx
  8009ce:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009d1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d7:	8d 40 04             	lea    0x4(%eax),%eax
  8009da:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8009dd:	ba 0a 00 00 00       	mov    $0xa,%edx
  8009e2:	e9 d5 00 00 00       	jmp    800abc <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
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
  800a05:	e9 b2 00 00 00       	jmp    800abc <vprintfmt+0x417>
	if (lflag >= 2)
  800a0a:	83 f9 01             	cmp    $0x1,%ecx
  800a0d:	7e 42                	jle    800a51 <vprintfmt+0x3ac>
		return va_arg(*ap, unsigned long long);
  800a0f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a12:	8b 50 04             	mov    0x4(%eax),%edx
  800a15:	8b 00                	mov    (%eax),%eax
  800a17:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a1a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a1d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a20:	8d 40 08             	lea    0x8(%eax),%eax
  800a23:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800a26:	ba 08 00 00 00       	mov    $0x8,%edx
			if ((long long) num < 0) {
  800a2b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a2f:	0f 89 87 00 00 00    	jns    800abc <vprintfmt+0x417>
				putch('-', putdat);
  800a35:	83 ec 08             	sub    $0x8,%esp
  800a38:	53                   	push   %ebx
  800a39:	6a 2d                	push   $0x2d
  800a3b:	ff d6                	call   *%esi
				num = -(long long) num;
  800a3d:	f7 5d d8             	negl   -0x28(%ebp)
  800a40:	83 55 dc 00          	adcl   $0x0,-0x24(%ebp)
  800a44:	f7 5d dc             	negl   -0x24(%ebp)
  800a47:	83 c4 10             	add    $0x10,%esp
			base = 8;
  800a4a:	ba 08 00 00 00       	mov    $0x8,%edx
  800a4f:	eb 6b                	jmp    800abc <vprintfmt+0x417>
	else if (lflag)
  800a51:	85 c9                	test   %ecx,%ecx
  800a53:	75 1b                	jne    800a70 <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  800a55:	8b 45 14             	mov    0x14(%ebp),%eax
  800a58:	8b 00                	mov    (%eax),%eax
  800a5a:	ba 00 00 00 00       	mov    $0x0,%edx
  800a5f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a62:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a65:	8b 45 14             	mov    0x14(%ebp),%eax
  800a68:	8d 40 04             	lea    0x4(%eax),%eax
  800a6b:	89 45 14             	mov    %eax,0x14(%ebp)
  800a6e:	eb b6                	jmp    800a26 <vprintfmt+0x381>
		return va_arg(*ap, unsigned long);
  800a70:	8b 45 14             	mov    0x14(%ebp),%eax
  800a73:	8b 00                	mov    (%eax),%eax
  800a75:	ba 00 00 00 00       	mov    $0x0,%edx
  800a7a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a7d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a80:	8b 45 14             	mov    0x14(%ebp),%eax
  800a83:	8d 40 04             	lea    0x4(%eax),%eax
  800a86:	89 45 14             	mov    %eax,0x14(%ebp)
  800a89:	eb 9b                	jmp    800a26 <vprintfmt+0x381>
			putch('0', putdat);
  800a8b:	83 ec 08             	sub    $0x8,%esp
  800a8e:	53                   	push   %ebx
  800a8f:	6a 30                	push   $0x30
  800a91:	ff d6                	call   *%esi
			putch('x', putdat);
  800a93:	83 c4 08             	add    $0x8,%esp
  800a96:	53                   	push   %ebx
  800a97:	6a 78                	push   $0x78
  800a99:	ff d6                	call   *%esi
			num = (unsigned long long)
  800a9b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a9e:	8b 00                	mov    (%eax),%eax
  800aa0:	ba 00 00 00 00       	mov    $0x0,%edx
  800aa5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800aa8:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800aab:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800aae:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab1:	8d 40 04             	lea    0x4(%eax),%eax
  800ab4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800ab7:	ba 10 00 00 00       	mov    $0x10,%edx
			printnum(putch, putdat, num, base, width, padc);
  800abc:	83 ec 0c             	sub    $0xc,%esp
  800abf:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800ac3:	50                   	push   %eax
  800ac4:	ff 75 e0             	pushl  -0x20(%ebp)
  800ac7:	52                   	push   %edx
  800ac8:	ff 75 dc             	pushl  -0x24(%ebp)
  800acb:	ff 75 d8             	pushl  -0x28(%ebp)
  800ace:	89 da                	mov    %ebx,%edx
  800ad0:	89 f0                	mov    %esi,%eax
  800ad2:	e8 e5 fa ff ff       	call   8005bc <printnum>
			break;
  800ad7:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800ada:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800add:	83 c7 01             	add    $0x1,%edi
  800ae0:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800ae4:	83 f8 25             	cmp    $0x25,%eax
  800ae7:	0f 84 cf fb ff ff    	je     8006bc <vprintfmt+0x17>
			if (ch == '\0')
  800aed:	85 c0                	test   %eax,%eax
  800aef:	0f 84 a9 00 00 00    	je     800b9e <vprintfmt+0x4f9>
			putch(ch, putdat);
  800af5:	83 ec 08             	sub    $0x8,%esp
  800af8:	53                   	push   %ebx
  800af9:	50                   	push   %eax
  800afa:	ff d6                	call   *%esi
  800afc:	83 c4 10             	add    $0x10,%esp
  800aff:	eb dc                	jmp    800add <vprintfmt+0x438>
	if (lflag >= 2)
  800b01:	83 f9 01             	cmp    $0x1,%ecx
  800b04:	7e 1e                	jle    800b24 <vprintfmt+0x47f>
		return va_arg(*ap, unsigned long long);
  800b06:	8b 45 14             	mov    0x14(%ebp),%eax
  800b09:	8b 50 04             	mov    0x4(%eax),%edx
  800b0c:	8b 00                	mov    (%eax),%eax
  800b0e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b11:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b14:	8b 45 14             	mov    0x14(%ebp),%eax
  800b17:	8d 40 08             	lea    0x8(%eax),%eax
  800b1a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800b1d:	ba 10 00 00 00       	mov    $0x10,%edx
  800b22:	eb 98                	jmp    800abc <vprintfmt+0x417>
	else if (lflag)
  800b24:	85 c9                	test   %ecx,%ecx
  800b26:	75 23                	jne    800b4b <vprintfmt+0x4a6>
		return va_arg(*ap, unsigned int);
  800b28:	8b 45 14             	mov    0x14(%ebp),%eax
  800b2b:	8b 00                	mov    (%eax),%eax
  800b2d:	ba 00 00 00 00       	mov    $0x0,%edx
  800b32:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b35:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b38:	8b 45 14             	mov    0x14(%ebp),%eax
  800b3b:	8d 40 04             	lea    0x4(%eax),%eax
  800b3e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800b41:	ba 10 00 00 00       	mov    $0x10,%edx
  800b46:	e9 71 ff ff ff       	jmp    800abc <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
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
  800b69:	e9 4e ff ff ff       	jmp    800abc <vprintfmt+0x417>
			putch(ch, putdat);
  800b6e:	83 ec 08             	sub    $0x8,%esp
  800b71:	53                   	push   %ebx
  800b72:	6a 25                	push   $0x25
  800b74:	ff d6                	call   *%esi
			break;
  800b76:	83 c4 10             	add    $0x10,%esp
  800b79:	e9 5c ff ff ff       	jmp    800ada <vprintfmt+0x435>
			putch('%', putdat);
  800b7e:	83 ec 08             	sub    $0x8,%esp
  800b81:	53                   	push   %ebx
  800b82:	6a 25                	push   $0x25
  800b84:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b86:	83 c4 10             	add    $0x10,%esp
  800b89:	89 f8                	mov    %edi,%eax
  800b8b:	eb 03                	jmp    800b90 <vprintfmt+0x4eb>
  800b8d:	83 e8 01             	sub    $0x1,%eax
  800b90:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800b94:	75 f7                	jne    800b8d <vprintfmt+0x4e8>
  800b96:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b99:	e9 3c ff ff ff       	jmp    800ada <vprintfmt+0x435>
}
  800b9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ba1:	5b                   	pop    %ebx
  800ba2:	5e                   	pop    %esi
  800ba3:	5f                   	pop    %edi
  800ba4:	5d                   	pop    %ebp
  800ba5:	c3                   	ret    

00800ba6 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ba6:	55                   	push   %ebp
  800ba7:	89 e5                	mov    %esp,%ebp
  800ba9:	83 ec 18             	sub    $0x18,%esp
  800bac:	8b 45 08             	mov    0x8(%ebp),%eax
  800baf:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800bb2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800bb5:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800bb9:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800bbc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800bc3:	85 c0                	test   %eax,%eax
  800bc5:	74 26                	je     800bed <vsnprintf+0x47>
  800bc7:	85 d2                	test   %edx,%edx
  800bc9:	7e 22                	jle    800bed <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800bcb:	ff 75 14             	pushl  0x14(%ebp)
  800bce:	ff 75 10             	pushl  0x10(%ebp)
  800bd1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bd4:	50                   	push   %eax
  800bd5:	68 6b 06 80 00       	push   $0x80066b
  800bda:	e8 c6 fa ff ff       	call   8006a5 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800bdf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800be2:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800be5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800be8:	83 c4 10             	add    $0x10,%esp
}
  800beb:	c9                   	leave  
  800bec:	c3                   	ret    
		return -E_INVAL;
  800bed:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800bf2:	eb f7                	jmp    800beb <vsnprintf+0x45>

00800bf4 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bf4:	55                   	push   %ebp
  800bf5:	89 e5                	mov    %esp,%ebp
  800bf7:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bfa:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800bfd:	50                   	push   %eax
  800bfe:	ff 75 10             	pushl  0x10(%ebp)
  800c01:	ff 75 0c             	pushl  0xc(%ebp)
  800c04:	ff 75 08             	pushl  0x8(%ebp)
  800c07:	e8 9a ff ff ff       	call   800ba6 <vsnprintf>
	va_end(ap);

	return rc;
}
  800c0c:	c9                   	leave  
  800c0d:	c3                   	ret    

00800c0e <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800c0e:	55                   	push   %ebp
  800c0f:	89 e5                	mov    %esp,%ebp
  800c11:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800c14:	b8 00 00 00 00       	mov    $0x0,%eax
  800c19:	eb 03                	jmp    800c1e <strlen+0x10>
		n++;
  800c1b:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800c1e:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800c22:	75 f7                	jne    800c1b <strlen+0xd>
	return n;
}
  800c24:	5d                   	pop    %ebp
  800c25:	c3                   	ret    

00800c26 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800c26:	55                   	push   %ebp
  800c27:	89 e5                	mov    %esp,%ebp
  800c29:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c2c:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c2f:	b8 00 00 00 00       	mov    $0x0,%eax
  800c34:	eb 03                	jmp    800c39 <strnlen+0x13>
		n++;
  800c36:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c39:	39 d0                	cmp    %edx,%eax
  800c3b:	74 06                	je     800c43 <strnlen+0x1d>
  800c3d:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800c41:	75 f3                	jne    800c36 <strnlen+0x10>
	return n;
}
  800c43:	5d                   	pop    %ebp
  800c44:	c3                   	ret    

00800c45 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c45:	55                   	push   %ebp
  800c46:	89 e5                	mov    %esp,%ebp
  800c48:	53                   	push   %ebx
  800c49:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800c4f:	89 c2                	mov    %eax,%edx
  800c51:	83 c1 01             	add    $0x1,%ecx
  800c54:	83 c2 01             	add    $0x1,%edx
  800c57:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800c5b:	88 5a ff             	mov    %bl,-0x1(%edx)
  800c5e:	84 db                	test   %bl,%bl
  800c60:	75 ef                	jne    800c51 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800c62:	5b                   	pop    %ebx
  800c63:	5d                   	pop    %ebp
  800c64:	c3                   	ret    

00800c65 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800c65:	55                   	push   %ebp
  800c66:	89 e5                	mov    %esp,%ebp
  800c68:	53                   	push   %ebx
  800c69:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800c6c:	53                   	push   %ebx
  800c6d:	e8 9c ff ff ff       	call   800c0e <strlen>
  800c72:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800c75:	ff 75 0c             	pushl  0xc(%ebp)
  800c78:	01 d8                	add    %ebx,%eax
  800c7a:	50                   	push   %eax
  800c7b:	e8 c5 ff ff ff       	call   800c45 <strcpy>
	return dst;
}
  800c80:	89 d8                	mov    %ebx,%eax
  800c82:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c85:	c9                   	leave  
  800c86:	c3                   	ret    

00800c87 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800c87:	55                   	push   %ebp
  800c88:	89 e5                	mov    %esp,%ebp
  800c8a:	56                   	push   %esi
  800c8b:	53                   	push   %ebx
  800c8c:	8b 75 08             	mov    0x8(%ebp),%esi
  800c8f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c92:	89 f3                	mov    %esi,%ebx
  800c94:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c97:	89 f2                	mov    %esi,%edx
  800c99:	eb 0f                	jmp    800caa <strncpy+0x23>
		*dst++ = *src;
  800c9b:	83 c2 01             	add    $0x1,%edx
  800c9e:	0f b6 01             	movzbl (%ecx),%eax
  800ca1:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800ca4:	80 39 01             	cmpb   $0x1,(%ecx)
  800ca7:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800caa:	39 da                	cmp    %ebx,%edx
  800cac:	75 ed                	jne    800c9b <strncpy+0x14>
	}
	return ret;
}
  800cae:	89 f0                	mov    %esi,%eax
  800cb0:	5b                   	pop    %ebx
  800cb1:	5e                   	pop    %esi
  800cb2:	5d                   	pop    %ebp
  800cb3:	c3                   	ret    

00800cb4 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800cb4:	55                   	push   %ebp
  800cb5:	89 e5                	mov    %esp,%ebp
  800cb7:	56                   	push   %esi
  800cb8:	53                   	push   %ebx
  800cb9:	8b 75 08             	mov    0x8(%ebp),%esi
  800cbc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cbf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800cc2:	89 f0                	mov    %esi,%eax
  800cc4:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800cc8:	85 c9                	test   %ecx,%ecx
  800cca:	75 0b                	jne    800cd7 <strlcpy+0x23>
  800ccc:	eb 17                	jmp    800ce5 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800cce:	83 c2 01             	add    $0x1,%edx
  800cd1:	83 c0 01             	add    $0x1,%eax
  800cd4:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800cd7:	39 d8                	cmp    %ebx,%eax
  800cd9:	74 07                	je     800ce2 <strlcpy+0x2e>
  800cdb:	0f b6 0a             	movzbl (%edx),%ecx
  800cde:	84 c9                	test   %cl,%cl
  800ce0:	75 ec                	jne    800cce <strlcpy+0x1a>
		*dst = '\0';
  800ce2:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ce5:	29 f0                	sub    %esi,%eax
}
  800ce7:	5b                   	pop    %ebx
  800ce8:	5e                   	pop    %esi
  800ce9:	5d                   	pop    %ebp
  800cea:	c3                   	ret    

00800ceb <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ceb:	55                   	push   %ebp
  800cec:	89 e5                	mov    %esp,%ebp
  800cee:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cf1:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800cf4:	eb 06                	jmp    800cfc <strcmp+0x11>
		p++, q++;
  800cf6:	83 c1 01             	add    $0x1,%ecx
  800cf9:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800cfc:	0f b6 01             	movzbl (%ecx),%eax
  800cff:	84 c0                	test   %al,%al
  800d01:	74 04                	je     800d07 <strcmp+0x1c>
  800d03:	3a 02                	cmp    (%edx),%al
  800d05:	74 ef                	je     800cf6 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d07:	0f b6 c0             	movzbl %al,%eax
  800d0a:	0f b6 12             	movzbl (%edx),%edx
  800d0d:	29 d0                	sub    %edx,%eax
}
  800d0f:	5d                   	pop    %ebp
  800d10:	c3                   	ret    

00800d11 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800d11:	55                   	push   %ebp
  800d12:	89 e5                	mov    %esp,%ebp
  800d14:	53                   	push   %ebx
  800d15:	8b 45 08             	mov    0x8(%ebp),%eax
  800d18:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d1b:	89 c3                	mov    %eax,%ebx
  800d1d:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800d20:	eb 06                	jmp    800d28 <strncmp+0x17>
		n--, p++, q++;
  800d22:	83 c0 01             	add    $0x1,%eax
  800d25:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800d28:	39 d8                	cmp    %ebx,%eax
  800d2a:	74 16                	je     800d42 <strncmp+0x31>
  800d2c:	0f b6 08             	movzbl (%eax),%ecx
  800d2f:	84 c9                	test   %cl,%cl
  800d31:	74 04                	je     800d37 <strncmp+0x26>
  800d33:	3a 0a                	cmp    (%edx),%cl
  800d35:	74 eb                	je     800d22 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d37:	0f b6 00             	movzbl (%eax),%eax
  800d3a:	0f b6 12             	movzbl (%edx),%edx
  800d3d:	29 d0                	sub    %edx,%eax
}
  800d3f:	5b                   	pop    %ebx
  800d40:	5d                   	pop    %ebp
  800d41:	c3                   	ret    
		return 0;
  800d42:	b8 00 00 00 00       	mov    $0x0,%eax
  800d47:	eb f6                	jmp    800d3f <strncmp+0x2e>

00800d49 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d49:	55                   	push   %ebp
  800d4a:	89 e5                	mov    %esp,%ebp
  800d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d53:	0f b6 10             	movzbl (%eax),%edx
  800d56:	84 d2                	test   %dl,%dl
  800d58:	74 09                	je     800d63 <strchr+0x1a>
		if (*s == c)
  800d5a:	38 ca                	cmp    %cl,%dl
  800d5c:	74 0a                	je     800d68 <strchr+0x1f>
	for (; *s; s++)
  800d5e:	83 c0 01             	add    $0x1,%eax
  800d61:	eb f0                	jmp    800d53 <strchr+0xa>
			return (char *) s;
	return 0;
  800d63:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d68:	5d                   	pop    %ebp
  800d69:	c3                   	ret    

00800d6a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d6a:	55                   	push   %ebp
  800d6b:	89 e5                	mov    %esp,%ebp
  800d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d70:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d74:	eb 03                	jmp    800d79 <strfind+0xf>
  800d76:	83 c0 01             	add    $0x1,%eax
  800d79:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800d7c:	38 ca                	cmp    %cl,%dl
  800d7e:	74 04                	je     800d84 <strfind+0x1a>
  800d80:	84 d2                	test   %dl,%dl
  800d82:	75 f2                	jne    800d76 <strfind+0xc>
			break;
	return (char *) s;
}
  800d84:	5d                   	pop    %ebp
  800d85:	c3                   	ret    

00800d86 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800d86:	55                   	push   %ebp
  800d87:	89 e5                	mov    %esp,%ebp
  800d89:	57                   	push   %edi
  800d8a:	56                   	push   %esi
  800d8b:	53                   	push   %ebx
  800d8c:	8b 7d 08             	mov    0x8(%ebp),%edi
  800d8f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800d92:	85 c9                	test   %ecx,%ecx
  800d94:	74 13                	je     800da9 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800d96:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800d9c:	75 05                	jne    800da3 <memset+0x1d>
  800d9e:	f6 c1 03             	test   $0x3,%cl
  800da1:	74 0d                	je     800db0 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800da3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da6:	fc                   	cld    
  800da7:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800da9:	89 f8                	mov    %edi,%eax
  800dab:	5b                   	pop    %ebx
  800dac:	5e                   	pop    %esi
  800dad:	5f                   	pop    %edi
  800dae:	5d                   	pop    %ebp
  800daf:	c3                   	ret    
		c &= 0xFF;
  800db0:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800db4:	89 d3                	mov    %edx,%ebx
  800db6:	c1 e3 08             	shl    $0x8,%ebx
  800db9:	89 d0                	mov    %edx,%eax
  800dbb:	c1 e0 18             	shl    $0x18,%eax
  800dbe:	89 d6                	mov    %edx,%esi
  800dc0:	c1 e6 10             	shl    $0x10,%esi
  800dc3:	09 f0                	or     %esi,%eax
  800dc5:	09 c2                	or     %eax,%edx
  800dc7:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800dc9:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800dcc:	89 d0                	mov    %edx,%eax
  800dce:	fc                   	cld    
  800dcf:	f3 ab                	rep stos %eax,%es:(%edi)
  800dd1:	eb d6                	jmp    800da9 <memset+0x23>

00800dd3 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800dd3:	55                   	push   %ebp
  800dd4:	89 e5                	mov    %esp,%ebp
  800dd6:	57                   	push   %edi
  800dd7:	56                   	push   %esi
  800dd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddb:	8b 75 0c             	mov    0xc(%ebp),%esi
  800dde:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800de1:	39 c6                	cmp    %eax,%esi
  800de3:	73 35                	jae    800e1a <memmove+0x47>
  800de5:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800de8:	39 c2                	cmp    %eax,%edx
  800dea:	76 2e                	jbe    800e1a <memmove+0x47>
		s += n;
		d += n;
  800dec:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800def:	89 d6                	mov    %edx,%esi
  800df1:	09 fe                	or     %edi,%esi
  800df3:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800df9:	74 0c                	je     800e07 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800dfb:	83 ef 01             	sub    $0x1,%edi
  800dfe:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800e01:	fd                   	std    
  800e02:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800e04:	fc                   	cld    
  800e05:	eb 21                	jmp    800e28 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800e07:	f6 c1 03             	test   $0x3,%cl
  800e0a:	75 ef                	jne    800dfb <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800e0c:	83 ef 04             	sub    $0x4,%edi
  800e0f:	8d 72 fc             	lea    -0x4(%edx),%esi
  800e12:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800e15:	fd                   	std    
  800e16:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800e18:	eb ea                	jmp    800e04 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800e1a:	89 f2                	mov    %esi,%edx
  800e1c:	09 c2                	or     %eax,%edx
  800e1e:	f6 c2 03             	test   $0x3,%dl
  800e21:	74 09                	je     800e2c <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800e23:	89 c7                	mov    %eax,%edi
  800e25:	fc                   	cld    
  800e26:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800e28:	5e                   	pop    %esi
  800e29:	5f                   	pop    %edi
  800e2a:	5d                   	pop    %ebp
  800e2b:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800e2c:	f6 c1 03             	test   $0x3,%cl
  800e2f:	75 f2                	jne    800e23 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800e31:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800e34:	89 c7                	mov    %eax,%edi
  800e36:	fc                   	cld    
  800e37:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800e39:	eb ed                	jmp    800e28 <memmove+0x55>

00800e3b <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800e3b:	55                   	push   %ebp
  800e3c:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800e3e:	ff 75 10             	pushl  0x10(%ebp)
  800e41:	ff 75 0c             	pushl  0xc(%ebp)
  800e44:	ff 75 08             	pushl  0x8(%ebp)
  800e47:	e8 87 ff ff ff       	call   800dd3 <memmove>
}
  800e4c:	c9                   	leave  
  800e4d:	c3                   	ret    

00800e4e <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800e4e:	55                   	push   %ebp
  800e4f:	89 e5                	mov    %esp,%ebp
  800e51:	56                   	push   %esi
  800e52:	53                   	push   %ebx
  800e53:	8b 45 08             	mov    0x8(%ebp),%eax
  800e56:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e59:	89 c6                	mov    %eax,%esi
  800e5b:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800e5e:	39 f0                	cmp    %esi,%eax
  800e60:	74 1c                	je     800e7e <memcmp+0x30>
		if (*s1 != *s2)
  800e62:	0f b6 08             	movzbl (%eax),%ecx
  800e65:	0f b6 1a             	movzbl (%edx),%ebx
  800e68:	38 d9                	cmp    %bl,%cl
  800e6a:	75 08                	jne    800e74 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800e6c:	83 c0 01             	add    $0x1,%eax
  800e6f:	83 c2 01             	add    $0x1,%edx
  800e72:	eb ea                	jmp    800e5e <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800e74:	0f b6 c1             	movzbl %cl,%eax
  800e77:	0f b6 db             	movzbl %bl,%ebx
  800e7a:	29 d8                	sub    %ebx,%eax
  800e7c:	eb 05                	jmp    800e83 <memcmp+0x35>
	}

	return 0;
  800e7e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e83:	5b                   	pop    %ebx
  800e84:	5e                   	pop    %esi
  800e85:	5d                   	pop    %ebp
  800e86:	c3                   	ret    

00800e87 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800e87:	55                   	push   %ebp
  800e88:	89 e5                	mov    %esp,%ebp
  800e8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800e90:	89 c2                	mov    %eax,%edx
  800e92:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800e95:	39 d0                	cmp    %edx,%eax
  800e97:	73 09                	jae    800ea2 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e99:	38 08                	cmp    %cl,(%eax)
  800e9b:	74 05                	je     800ea2 <memfind+0x1b>
	for (; s < ends; s++)
  800e9d:	83 c0 01             	add    $0x1,%eax
  800ea0:	eb f3                	jmp    800e95 <memfind+0xe>
			break;
	return (void *) s;
}
  800ea2:	5d                   	pop    %ebp
  800ea3:	c3                   	ret    

00800ea4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ea4:	55                   	push   %ebp
  800ea5:	89 e5                	mov    %esp,%ebp
  800ea7:	57                   	push   %edi
  800ea8:	56                   	push   %esi
  800ea9:	53                   	push   %ebx
  800eaa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ead:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800eb0:	eb 03                	jmp    800eb5 <strtol+0x11>
		s++;
  800eb2:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800eb5:	0f b6 01             	movzbl (%ecx),%eax
  800eb8:	3c 20                	cmp    $0x20,%al
  800eba:	74 f6                	je     800eb2 <strtol+0xe>
  800ebc:	3c 09                	cmp    $0x9,%al
  800ebe:	74 f2                	je     800eb2 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800ec0:	3c 2b                	cmp    $0x2b,%al
  800ec2:	74 2e                	je     800ef2 <strtol+0x4e>
	int neg = 0;
  800ec4:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800ec9:	3c 2d                	cmp    $0x2d,%al
  800ecb:	74 2f                	je     800efc <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ecd:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800ed3:	75 05                	jne    800eda <strtol+0x36>
  800ed5:	80 39 30             	cmpb   $0x30,(%ecx)
  800ed8:	74 2c                	je     800f06 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800eda:	85 db                	test   %ebx,%ebx
  800edc:	75 0a                	jne    800ee8 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ede:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800ee3:	80 39 30             	cmpb   $0x30,(%ecx)
  800ee6:	74 28                	je     800f10 <strtol+0x6c>
		base = 10;
  800ee8:	b8 00 00 00 00       	mov    $0x0,%eax
  800eed:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ef0:	eb 50                	jmp    800f42 <strtol+0x9e>
		s++;
  800ef2:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800ef5:	bf 00 00 00 00       	mov    $0x0,%edi
  800efa:	eb d1                	jmp    800ecd <strtol+0x29>
		s++, neg = 1;
  800efc:	83 c1 01             	add    $0x1,%ecx
  800eff:	bf 01 00 00 00       	mov    $0x1,%edi
  800f04:	eb c7                	jmp    800ecd <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f06:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800f0a:	74 0e                	je     800f1a <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800f0c:	85 db                	test   %ebx,%ebx
  800f0e:	75 d8                	jne    800ee8 <strtol+0x44>
		s++, base = 8;
  800f10:	83 c1 01             	add    $0x1,%ecx
  800f13:	bb 08 00 00 00       	mov    $0x8,%ebx
  800f18:	eb ce                	jmp    800ee8 <strtol+0x44>
		s += 2, base = 16;
  800f1a:	83 c1 02             	add    $0x2,%ecx
  800f1d:	bb 10 00 00 00       	mov    $0x10,%ebx
  800f22:	eb c4                	jmp    800ee8 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800f24:	8d 72 9f             	lea    -0x61(%edx),%esi
  800f27:	89 f3                	mov    %esi,%ebx
  800f29:	80 fb 19             	cmp    $0x19,%bl
  800f2c:	77 29                	ja     800f57 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800f2e:	0f be d2             	movsbl %dl,%edx
  800f31:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800f34:	3b 55 10             	cmp    0x10(%ebp),%edx
  800f37:	7d 30                	jge    800f69 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800f39:	83 c1 01             	add    $0x1,%ecx
  800f3c:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f40:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800f42:	0f b6 11             	movzbl (%ecx),%edx
  800f45:	8d 72 d0             	lea    -0x30(%edx),%esi
  800f48:	89 f3                	mov    %esi,%ebx
  800f4a:	80 fb 09             	cmp    $0x9,%bl
  800f4d:	77 d5                	ja     800f24 <strtol+0x80>
			dig = *s - '0';
  800f4f:	0f be d2             	movsbl %dl,%edx
  800f52:	83 ea 30             	sub    $0x30,%edx
  800f55:	eb dd                	jmp    800f34 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800f57:	8d 72 bf             	lea    -0x41(%edx),%esi
  800f5a:	89 f3                	mov    %esi,%ebx
  800f5c:	80 fb 19             	cmp    $0x19,%bl
  800f5f:	77 08                	ja     800f69 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800f61:	0f be d2             	movsbl %dl,%edx
  800f64:	83 ea 37             	sub    $0x37,%edx
  800f67:	eb cb                	jmp    800f34 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800f69:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f6d:	74 05                	je     800f74 <strtol+0xd0>
		*endptr = (char *) s;
  800f6f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f72:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800f74:	89 c2                	mov    %eax,%edx
  800f76:	f7 da                	neg    %edx
  800f78:	85 ff                	test   %edi,%edi
  800f7a:	0f 45 c2             	cmovne %edx,%eax
}
  800f7d:	5b                   	pop    %ebx
  800f7e:	5e                   	pop    %esi
  800f7f:	5f                   	pop    %edi
  800f80:	5d                   	pop    %ebp
  800f81:	c3                   	ret    

00800f82 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800f82:	55                   	push   %ebp
  800f83:	89 e5                	mov    %esp,%ebp
  800f85:	57                   	push   %edi
  800f86:	56                   	push   %esi
  800f87:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f88:	b8 00 00 00 00       	mov    $0x0,%eax
  800f8d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f90:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f93:	89 c3                	mov    %eax,%ebx
  800f95:	89 c7                	mov    %eax,%edi
  800f97:	89 c6                	mov    %eax,%esi
  800f99:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800f9b:	5b                   	pop    %ebx
  800f9c:	5e                   	pop    %esi
  800f9d:	5f                   	pop    %edi
  800f9e:	5d                   	pop    %ebp
  800f9f:	c3                   	ret    

00800fa0 <sys_cgetc>:

int
sys_cgetc(void)
{
  800fa0:	55                   	push   %ebp
  800fa1:	89 e5                	mov    %esp,%ebp
  800fa3:	57                   	push   %edi
  800fa4:	56                   	push   %esi
  800fa5:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fa6:	ba 00 00 00 00       	mov    $0x0,%edx
  800fab:	b8 01 00 00 00       	mov    $0x1,%eax
  800fb0:	89 d1                	mov    %edx,%ecx
  800fb2:	89 d3                	mov    %edx,%ebx
  800fb4:	89 d7                	mov    %edx,%edi
  800fb6:	89 d6                	mov    %edx,%esi
  800fb8:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800fba:	5b                   	pop    %ebx
  800fbb:	5e                   	pop    %esi
  800fbc:	5f                   	pop    %edi
  800fbd:	5d                   	pop    %ebp
  800fbe:	c3                   	ret    

00800fbf <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800fbf:	55                   	push   %ebp
  800fc0:	89 e5                	mov    %esp,%ebp
  800fc2:	57                   	push   %edi
  800fc3:	56                   	push   %esi
  800fc4:	53                   	push   %ebx
  800fc5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fc8:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fcd:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd0:	b8 03 00 00 00       	mov    $0x3,%eax
  800fd5:	89 cb                	mov    %ecx,%ebx
  800fd7:	89 cf                	mov    %ecx,%edi
  800fd9:	89 ce                	mov    %ecx,%esi
  800fdb:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fdd:	85 c0                	test   %eax,%eax
  800fdf:	7f 08                	jg     800fe9 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800fe1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fe4:	5b                   	pop    %ebx
  800fe5:	5e                   	pop    %esi
  800fe6:	5f                   	pop    %edi
  800fe7:	5d                   	pop    %ebp
  800fe8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fe9:	83 ec 0c             	sub    $0xc,%esp
  800fec:	50                   	push   %eax
  800fed:	6a 03                	push   $0x3
  800fef:	68 9f 2b 80 00       	push   $0x802b9f
  800ff4:	6a 23                	push   $0x23
  800ff6:	68 bc 2b 80 00       	push   $0x802bbc
  800ffb:	e8 ad 13 00 00       	call   8023ad <_panic>

00801000 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801000:	55                   	push   %ebp
  801001:	89 e5                	mov    %esp,%ebp
  801003:	57                   	push   %edi
  801004:	56                   	push   %esi
  801005:	53                   	push   %ebx
	asm volatile("int %1\n"
  801006:	ba 00 00 00 00       	mov    $0x0,%edx
  80100b:	b8 02 00 00 00       	mov    $0x2,%eax
  801010:	89 d1                	mov    %edx,%ecx
  801012:	89 d3                	mov    %edx,%ebx
  801014:	89 d7                	mov    %edx,%edi
  801016:	89 d6                	mov    %edx,%esi
  801018:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80101a:	5b                   	pop    %ebx
  80101b:	5e                   	pop    %esi
  80101c:	5f                   	pop    %edi
  80101d:	5d                   	pop    %ebp
  80101e:	c3                   	ret    

0080101f <sys_yield>:

void
sys_yield(void)
{
  80101f:	55                   	push   %ebp
  801020:	89 e5                	mov    %esp,%ebp
  801022:	57                   	push   %edi
  801023:	56                   	push   %esi
  801024:	53                   	push   %ebx
	asm volatile("int %1\n"
  801025:	ba 00 00 00 00       	mov    $0x0,%edx
  80102a:	b8 0b 00 00 00       	mov    $0xb,%eax
  80102f:	89 d1                	mov    %edx,%ecx
  801031:	89 d3                	mov    %edx,%ebx
  801033:	89 d7                	mov    %edx,%edi
  801035:	89 d6                	mov    %edx,%esi
  801037:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801039:	5b                   	pop    %ebx
  80103a:	5e                   	pop    %esi
  80103b:	5f                   	pop    %edi
  80103c:	5d                   	pop    %ebp
  80103d:	c3                   	ret    

0080103e <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80103e:	55                   	push   %ebp
  80103f:	89 e5                	mov    %esp,%ebp
  801041:	57                   	push   %edi
  801042:	56                   	push   %esi
  801043:	53                   	push   %ebx
  801044:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801047:	be 00 00 00 00       	mov    $0x0,%esi
  80104c:	8b 55 08             	mov    0x8(%ebp),%edx
  80104f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801052:	b8 04 00 00 00       	mov    $0x4,%eax
  801057:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80105a:	89 f7                	mov    %esi,%edi
  80105c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80105e:	85 c0                	test   %eax,%eax
  801060:	7f 08                	jg     80106a <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801062:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801065:	5b                   	pop    %ebx
  801066:	5e                   	pop    %esi
  801067:	5f                   	pop    %edi
  801068:	5d                   	pop    %ebp
  801069:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80106a:	83 ec 0c             	sub    $0xc,%esp
  80106d:	50                   	push   %eax
  80106e:	6a 04                	push   $0x4
  801070:	68 9f 2b 80 00       	push   $0x802b9f
  801075:	6a 23                	push   $0x23
  801077:	68 bc 2b 80 00       	push   $0x802bbc
  80107c:	e8 2c 13 00 00       	call   8023ad <_panic>

00801081 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801081:	55                   	push   %ebp
  801082:	89 e5                	mov    %esp,%ebp
  801084:	57                   	push   %edi
  801085:	56                   	push   %esi
  801086:	53                   	push   %ebx
  801087:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80108a:	8b 55 08             	mov    0x8(%ebp),%edx
  80108d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801090:	b8 05 00 00 00       	mov    $0x5,%eax
  801095:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801098:	8b 7d 14             	mov    0x14(%ebp),%edi
  80109b:	8b 75 18             	mov    0x18(%ebp),%esi
  80109e:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010a0:	85 c0                	test   %eax,%eax
  8010a2:	7f 08                	jg     8010ac <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8010a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010a7:	5b                   	pop    %ebx
  8010a8:	5e                   	pop    %esi
  8010a9:	5f                   	pop    %edi
  8010aa:	5d                   	pop    %ebp
  8010ab:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010ac:	83 ec 0c             	sub    $0xc,%esp
  8010af:	50                   	push   %eax
  8010b0:	6a 05                	push   $0x5
  8010b2:	68 9f 2b 80 00       	push   $0x802b9f
  8010b7:	6a 23                	push   $0x23
  8010b9:	68 bc 2b 80 00       	push   $0x802bbc
  8010be:	e8 ea 12 00 00       	call   8023ad <_panic>

008010c3 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8010c3:	55                   	push   %ebp
  8010c4:	89 e5                	mov    %esp,%ebp
  8010c6:	57                   	push   %edi
  8010c7:	56                   	push   %esi
  8010c8:	53                   	push   %ebx
  8010c9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010cc:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8010d4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010d7:	b8 06 00 00 00       	mov    $0x6,%eax
  8010dc:	89 df                	mov    %ebx,%edi
  8010de:	89 de                	mov    %ebx,%esi
  8010e0:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010e2:	85 c0                	test   %eax,%eax
  8010e4:	7f 08                	jg     8010ee <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8010e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010e9:	5b                   	pop    %ebx
  8010ea:	5e                   	pop    %esi
  8010eb:	5f                   	pop    %edi
  8010ec:	5d                   	pop    %ebp
  8010ed:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010ee:	83 ec 0c             	sub    $0xc,%esp
  8010f1:	50                   	push   %eax
  8010f2:	6a 06                	push   $0x6
  8010f4:	68 9f 2b 80 00       	push   $0x802b9f
  8010f9:	6a 23                	push   $0x23
  8010fb:	68 bc 2b 80 00       	push   $0x802bbc
  801100:	e8 a8 12 00 00       	call   8023ad <_panic>

00801105 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801105:	55                   	push   %ebp
  801106:	89 e5                	mov    %esp,%ebp
  801108:	57                   	push   %edi
  801109:	56                   	push   %esi
  80110a:	53                   	push   %ebx
  80110b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80110e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801113:	8b 55 08             	mov    0x8(%ebp),%edx
  801116:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801119:	b8 08 00 00 00       	mov    $0x8,%eax
  80111e:	89 df                	mov    %ebx,%edi
  801120:	89 de                	mov    %ebx,%esi
  801122:	cd 30                	int    $0x30
	if(check && ret > 0)
  801124:	85 c0                	test   %eax,%eax
  801126:	7f 08                	jg     801130 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801128:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80112b:	5b                   	pop    %ebx
  80112c:	5e                   	pop    %esi
  80112d:	5f                   	pop    %edi
  80112e:	5d                   	pop    %ebp
  80112f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801130:	83 ec 0c             	sub    $0xc,%esp
  801133:	50                   	push   %eax
  801134:	6a 08                	push   $0x8
  801136:	68 9f 2b 80 00       	push   $0x802b9f
  80113b:	6a 23                	push   $0x23
  80113d:	68 bc 2b 80 00       	push   $0x802bbc
  801142:	e8 66 12 00 00       	call   8023ad <_panic>

00801147 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801147:	55                   	push   %ebp
  801148:	89 e5                	mov    %esp,%ebp
  80114a:	57                   	push   %edi
  80114b:	56                   	push   %esi
  80114c:	53                   	push   %ebx
  80114d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801150:	bb 00 00 00 00       	mov    $0x0,%ebx
  801155:	8b 55 08             	mov    0x8(%ebp),%edx
  801158:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80115b:	b8 09 00 00 00       	mov    $0x9,%eax
  801160:	89 df                	mov    %ebx,%edi
  801162:	89 de                	mov    %ebx,%esi
  801164:	cd 30                	int    $0x30
	if(check && ret > 0)
  801166:	85 c0                	test   %eax,%eax
  801168:	7f 08                	jg     801172 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80116a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80116d:	5b                   	pop    %ebx
  80116e:	5e                   	pop    %esi
  80116f:	5f                   	pop    %edi
  801170:	5d                   	pop    %ebp
  801171:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801172:	83 ec 0c             	sub    $0xc,%esp
  801175:	50                   	push   %eax
  801176:	6a 09                	push   $0x9
  801178:	68 9f 2b 80 00       	push   $0x802b9f
  80117d:	6a 23                	push   $0x23
  80117f:	68 bc 2b 80 00       	push   $0x802bbc
  801184:	e8 24 12 00 00       	call   8023ad <_panic>

00801189 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801189:	55                   	push   %ebp
  80118a:	89 e5                	mov    %esp,%ebp
  80118c:	57                   	push   %edi
  80118d:	56                   	push   %esi
  80118e:	53                   	push   %ebx
  80118f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801192:	bb 00 00 00 00       	mov    $0x0,%ebx
  801197:	8b 55 08             	mov    0x8(%ebp),%edx
  80119a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80119d:	b8 0a 00 00 00       	mov    $0xa,%eax
  8011a2:	89 df                	mov    %ebx,%edi
  8011a4:	89 de                	mov    %ebx,%esi
  8011a6:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011a8:	85 c0                	test   %eax,%eax
  8011aa:	7f 08                	jg     8011b4 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8011ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011af:	5b                   	pop    %ebx
  8011b0:	5e                   	pop    %esi
  8011b1:	5f                   	pop    %edi
  8011b2:	5d                   	pop    %ebp
  8011b3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011b4:	83 ec 0c             	sub    $0xc,%esp
  8011b7:	50                   	push   %eax
  8011b8:	6a 0a                	push   $0xa
  8011ba:	68 9f 2b 80 00       	push   $0x802b9f
  8011bf:	6a 23                	push   $0x23
  8011c1:	68 bc 2b 80 00       	push   $0x802bbc
  8011c6:	e8 e2 11 00 00       	call   8023ad <_panic>

008011cb <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8011cb:	55                   	push   %ebp
  8011cc:	89 e5                	mov    %esp,%ebp
  8011ce:	57                   	push   %edi
  8011cf:	56                   	push   %esi
  8011d0:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8011d4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011d7:	b8 0c 00 00 00       	mov    $0xc,%eax
  8011dc:	be 00 00 00 00       	mov    $0x0,%esi
  8011e1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8011e4:	8b 7d 14             	mov    0x14(%ebp),%edi
  8011e7:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8011e9:	5b                   	pop    %ebx
  8011ea:	5e                   	pop    %esi
  8011eb:	5f                   	pop    %edi
  8011ec:	5d                   	pop    %ebp
  8011ed:	c3                   	ret    

008011ee <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8011ee:	55                   	push   %ebp
  8011ef:	89 e5                	mov    %esp,%ebp
  8011f1:	57                   	push   %edi
  8011f2:	56                   	push   %esi
  8011f3:	53                   	push   %ebx
  8011f4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011f7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8011fc:	8b 55 08             	mov    0x8(%ebp),%edx
  8011ff:	b8 0d 00 00 00       	mov    $0xd,%eax
  801204:	89 cb                	mov    %ecx,%ebx
  801206:	89 cf                	mov    %ecx,%edi
  801208:	89 ce                	mov    %ecx,%esi
  80120a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80120c:	85 c0                	test   %eax,%eax
  80120e:	7f 08                	jg     801218 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801210:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801213:	5b                   	pop    %ebx
  801214:	5e                   	pop    %esi
  801215:	5f                   	pop    %edi
  801216:	5d                   	pop    %ebp
  801217:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801218:	83 ec 0c             	sub    $0xc,%esp
  80121b:	50                   	push   %eax
  80121c:	6a 0d                	push   $0xd
  80121e:	68 9f 2b 80 00       	push   $0x802b9f
  801223:	6a 23                	push   $0x23
  801225:	68 bc 2b 80 00       	push   $0x802bbc
  80122a:	e8 7e 11 00 00       	call   8023ad <_panic>

0080122f <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80122f:	55                   	push   %ebp
  801230:	89 e5                	mov    %esp,%ebp
  801232:	57                   	push   %edi
  801233:	56                   	push   %esi
  801234:	53                   	push   %ebx
	asm volatile("int %1\n"
  801235:	ba 00 00 00 00       	mov    $0x0,%edx
  80123a:	b8 0e 00 00 00       	mov    $0xe,%eax
  80123f:	89 d1                	mov    %edx,%ecx
  801241:	89 d3                	mov    %edx,%ebx
  801243:	89 d7                	mov    %edx,%edi
  801245:	89 d6                	mov    %edx,%esi
  801247:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801249:	5b                   	pop    %ebx
  80124a:	5e                   	pop    %esi
  80124b:	5f                   	pop    %edi
  80124c:	5d                   	pop    %ebp
  80124d:	c3                   	ret    

0080124e <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80124e:	55                   	push   %ebp
  80124f:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801251:	8b 45 08             	mov    0x8(%ebp),%eax
  801254:	05 00 00 00 30       	add    $0x30000000,%eax
  801259:	c1 e8 0c             	shr    $0xc,%eax
}
  80125c:	5d                   	pop    %ebp
  80125d:	c3                   	ret    

0080125e <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80125e:	55                   	push   %ebp
  80125f:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801261:	8b 45 08             	mov    0x8(%ebp),%eax
  801264:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801269:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80126e:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801273:	5d                   	pop    %ebp
  801274:	c3                   	ret    

00801275 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801275:	55                   	push   %ebp
  801276:	89 e5                	mov    %esp,%ebp
  801278:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80127b:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801280:	89 c2                	mov    %eax,%edx
  801282:	c1 ea 16             	shr    $0x16,%edx
  801285:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80128c:	f6 c2 01             	test   $0x1,%dl
  80128f:	74 2a                	je     8012bb <fd_alloc+0x46>
  801291:	89 c2                	mov    %eax,%edx
  801293:	c1 ea 0c             	shr    $0xc,%edx
  801296:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80129d:	f6 c2 01             	test   $0x1,%dl
  8012a0:	74 19                	je     8012bb <fd_alloc+0x46>
  8012a2:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8012a7:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8012ac:	75 d2                	jne    801280 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8012ae:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8012b4:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8012b9:	eb 07                	jmp    8012c2 <fd_alloc+0x4d>
			*fd_store = fd;
  8012bb:	89 01                	mov    %eax,(%ecx)
			return 0;
  8012bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012c2:	5d                   	pop    %ebp
  8012c3:	c3                   	ret    

008012c4 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8012c4:	55                   	push   %ebp
  8012c5:	89 e5                	mov    %esp,%ebp
  8012c7:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8012ca:	83 f8 1f             	cmp    $0x1f,%eax
  8012cd:	77 36                	ja     801305 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8012cf:	c1 e0 0c             	shl    $0xc,%eax
  8012d2:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8012d7:	89 c2                	mov    %eax,%edx
  8012d9:	c1 ea 16             	shr    $0x16,%edx
  8012dc:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8012e3:	f6 c2 01             	test   $0x1,%dl
  8012e6:	74 24                	je     80130c <fd_lookup+0x48>
  8012e8:	89 c2                	mov    %eax,%edx
  8012ea:	c1 ea 0c             	shr    $0xc,%edx
  8012ed:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012f4:	f6 c2 01             	test   $0x1,%dl
  8012f7:	74 1a                	je     801313 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8012f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012fc:	89 02                	mov    %eax,(%edx)
	return 0;
  8012fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801303:	5d                   	pop    %ebp
  801304:	c3                   	ret    
		return -E_INVAL;
  801305:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80130a:	eb f7                	jmp    801303 <fd_lookup+0x3f>
		return -E_INVAL;
  80130c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801311:	eb f0                	jmp    801303 <fd_lookup+0x3f>
  801313:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801318:	eb e9                	jmp    801303 <fd_lookup+0x3f>

0080131a <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80131a:	55                   	push   %ebp
  80131b:	89 e5                	mov    %esp,%ebp
  80131d:	83 ec 08             	sub    $0x8,%esp
  801320:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801323:	ba 48 2c 80 00       	mov    $0x802c48,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801328:	b8 08 30 80 00       	mov    $0x803008,%eax
		if (devtab[i]->dev_id == dev_id) {
  80132d:	39 08                	cmp    %ecx,(%eax)
  80132f:	74 33                	je     801364 <dev_lookup+0x4a>
  801331:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801334:	8b 02                	mov    (%edx),%eax
  801336:	85 c0                	test   %eax,%eax
  801338:	75 f3                	jne    80132d <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80133a:	a1 18 40 80 00       	mov    0x804018,%eax
  80133f:	8b 40 48             	mov    0x48(%eax),%eax
  801342:	83 ec 04             	sub    $0x4,%esp
  801345:	51                   	push   %ecx
  801346:	50                   	push   %eax
  801347:	68 cc 2b 80 00       	push   $0x802bcc
  80134c:	e8 57 f2 ff ff       	call   8005a8 <cprintf>
	*dev = 0;
  801351:	8b 45 0c             	mov    0xc(%ebp),%eax
  801354:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80135a:	83 c4 10             	add    $0x10,%esp
  80135d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801362:	c9                   	leave  
  801363:	c3                   	ret    
			*dev = devtab[i];
  801364:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801367:	89 01                	mov    %eax,(%ecx)
			return 0;
  801369:	b8 00 00 00 00       	mov    $0x0,%eax
  80136e:	eb f2                	jmp    801362 <dev_lookup+0x48>

00801370 <fd_close>:
{
  801370:	55                   	push   %ebp
  801371:	89 e5                	mov    %esp,%ebp
  801373:	57                   	push   %edi
  801374:	56                   	push   %esi
  801375:	53                   	push   %ebx
  801376:	83 ec 1c             	sub    $0x1c,%esp
  801379:	8b 75 08             	mov    0x8(%ebp),%esi
  80137c:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80137f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801382:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801383:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801389:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80138c:	50                   	push   %eax
  80138d:	e8 32 ff ff ff       	call   8012c4 <fd_lookup>
  801392:	89 c3                	mov    %eax,%ebx
  801394:	83 c4 08             	add    $0x8,%esp
  801397:	85 c0                	test   %eax,%eax
  801399:	78 05                	js     8013a0 <fd_close+0x30>
	    || fd != fd2)
  80139b:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80139e:	74 16                	je     8013b6 <fd_close+0x46>
		return (must_exist ? r : 0);
  8013a0:	89 f8                	mov    %edi,%eax
  8013a2:	84 c0                	test   %al,%al
  8013a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8013a9:	0f 44 d8             	cmove  %eax,%ebx
}
  8013ac:	89 d8                	mov    %ebx,%eax
  8013ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013b1:	5b                   	pop    %ebx
  8013b2:	5e                   	pop    %esi
  8013b3:	5f                   	pop    %edi
  8013b4:	5d                   	pop    %ebp
  8013b5:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8013b6:	83 ec 08             	sub    $0x8,%esp
  8013b9:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8013bc:	50                   	push   %eax
  8013bd:	ff 36                	pushl  (%esi)
  8013bf:	e8 56 ff ff ff       	call   80131a <dev_lookup>
  8013c4:	89 c3                	mov    %eax,%ebx
  8013c6:	83 c4 10             	add    $0x10,%esp
  8013c9:	85 c0                	test   %eax,%eax
  8013cb:	78 15                	js     8013e2 <fd_close+0x72>
		if (dev->dev_close)
  8013cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013d0:	8b 40 10             	mov    0x10(%eax),%eax
  8013d3:	85 c0                	test   %eax,%eax
  8013d5:	74 1b                	je     8013f2 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  8013d7:	83 ec 0c             	sub    $0xc,%esp
  8013da:	56                   	push   %esi
  8013db:	ff d0                	call   *%eax
  8013dd:	89 c3                	mov    %eax,%ebx
  8013df:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8013e2:	83 ec 08             	sub    $0x8,%esp
  8013e5:	56                   	push   %esi
  8013e6:	6a 00                	push   $0x0
  8013e8:	e8 d6 fc ff ff       	call   8010c3 <sys_page_unmap>
	return r;
  8013ed:	83 c4 10             	add    $0x10,%esp
  8013f0:	eb ba                	jmp    8013ac <fd_close+0x3c>
			r = 0;
  8013f2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013f7:	eb e9                	jmp    8013e2 <fd_close+0x72>

008013f9 <close>:

int
close(int fdnum)
{
  8013f9:	55                   	push   %ebp
  8013fa:	89 e5                	mov    %esp,%ebp
  8013fc:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8013ff:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801402:	50                   	push   %eax
  801403:	ff 75 08             	pushl  0x8(%ebp)
  801406:	e8 b9 fe ff ff       	call   8012c4 <fd_lookup>
  80140b:	83 c4 08             	add    $0x8,%esp
  80140e:	85 c0                	test   %eax,%eax
  801410:	78 10                	js     801422 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  801412:	83 ec 08             	sub    $0x8,%esp
  801415:	6a 01                	push   $0x1
  801417:	ff 75 f4             	pushl  -0xc(%ebp)
  80141a:	e8 51 ff ff ff       	call   801370 <fd_close>
  80141f:	83 c4 10             	add    $0x10,%esp
}
  801422:	c9                   	leave  
  801423:	c3                   	ret    

00801424 <close_all>:

void
close_all(void)
{
  801424:	55                   	push   %ebp
  801425:	89 e5                	mov    %esp,%ebp
  801427:	53                   	push   %ebx
  801428:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80142b:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801430:	83 ec 0c             	sub    $0xc,%esp
  801433:	53                   	push   %ebx
  801434:	e8 c0 ff ff ff       	call   8013f9 <close>
	for (i = 0; i < MAXFD; i++)
  801439:	83 c3 01             	add    $0x1,%ebx
  80143c:	83 c4 10             	add    $0x10,%esp
  80143f:	83 fb 20             	cmp    $0x20,%ebx
  801442:	75 ec                	jne    801430 <close_all+0xc>
}
  801444:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801447:	c9                   	leave  
  801448:	c3                   	ret    

00801449 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801449:	55                   	push   %ebp
  80144a:	89 e5                	mov    %esp,%ebp
  80144c:	57                   	push   %edi
  80144d:	56                   	push   %esi
  80144e:	53                   	push   %ebx
  80144f:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801452:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801455:	50                   	push   %eax
  801456:	ff 75 08             	pushl  0x8(%ebp)
  801459:	e8 66 fe ff ff       	call   8012c4 <fd_lookup>
  80145e:	89 c3                	mov    %eax,%ebx
  801460:	83 c4 08             	add    $0x8,%esp
  801463:	85 c0                	test   %eax,%eax
  801465:	0f 88 81 00 00 00    	js     8014ec <dup+0xa3>
		return r;
	close(newfdnum);
  80146b:	83 ec 0c             	sub    $0xc,%esp
  80146e:	ff 75 0c             	pushl  0xc(%ebp)
  801471:	e8 83 ff ff ff       	call   8013f9 <close>

	newfd = INDEX2FD(newfdnum);
  801476:	8b 75 0c             	mov    0xc(%ebp),%esi
  801479:	c1 e6 0c             	shl    $0xc,%esi
  80147c:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801482:	83 c4 04             	add    $0x4,%esp
  801485:	ff 75 e4             	pushl  -0x1c(%ebp)
  801488:	e8 d1 fd ff ff       	call   80125e <fd2data>
  80148d:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80148f:	89 34 24             	mov    %esi,(%esp)
  801492:	e8 c7 fd ff ff       	call   80125e <fd2data>
  801497:	83 c4 10             	add    $0x10,%esp
  80149a:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80149c:	89 d8                	mov    %ebx,%eax
  80149e:	c1 e8 16             	shr    $0x16,%eax
  8014a1:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8014a8:	a8 01                	test   $0x1,%al
  8014aa:	74 11                	je     8014bd <dup+0x74>
  8014ac:	89 d8                	mov    %ebx,%eax
  8014ae:	c1 e8 0c             	shr    $0xc,%eax
  8014b1:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8014b8:	f6 c2 01             	test   $0x1,%dl
  8014bb:	75 39                	jne    8014f6 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8014bd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8014c0:	89 d0                	mov    %edx,%eax
  8014c2:	c1 e8 0c             	shr    $0xc,%eax
  8014c5:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8014cc:	83 ec 0c             	sub    $0xc,%esp
  8014cf:	25 07 0e 00 00       	and    $0xe07,%eax
  8014d4:	50                   	push   %eax
  8014d5:	56                   	push   %esi
  8014d6:	6a 00                	push   $0x0
  8014d8:	52                   	push   %edx
  8014d9:	6a 00                	push   $0x0
  8014db:	e8 a1 fb ff ff       	call   801081 <sys_page_map>
  8014e0:	89 c3                	mov    %eax,%ebx
  8014e2:	83 c4 20             	add    $0x20,%esp
  8014e5:	85 c0                	test   %eax,%eax
  8014e7:	78 31                	js     80151a <dup+0xd1>
		goto err;

	return newfdnum;
  8014e9:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8014ec:	89 d8                	mov    %ebx,%eax
  8014ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014f1:	5b                   	pop    %ebx
  8014f2:	5e                   	pop    %esi
  8014f3:	5f                   	pop    %edi
  8014f4:	5d                   	pop    %ebp
  8014f5:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8014f6:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8014fd:	83 ec 0c             	sub    $0xc,%esp
  801500:	25 07 0e 00 00       	and    $0xe07,%eax
  801505:	50                   	push   %eax
  801506:	57                   	push   %edi
  801507:	6a 00                	push   $0x0
  801509:	53                   	push   %ebx
  80150a:	6a 00                	push   $0x0
  80150c:	e8 70 fb ff ff       	call   801081 <sys_page_map>
  801511:	89 c3                	mov    %eax,%ebx
  801513:	83 c4 20             	add    $0x20,%esp
  801516:	85 c0                	test   %eax,%eax
  801518:	79 a3                	jns    8014bd <dup+0x74>
	sys_page_unmap(0, newfd);
  80151a:	83 ec 08             	sub    $0x8,%esp
  80151d:	56                   	push   %esi
  80151e:	6a 00                	push   $0x0
  801520:	e8 9e fb ff ff       	call   8010c3 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801525:	83 c4 08             	add    $0x8,%esp
  801528:	57                   	push   %edi
  801529:	6a 00                	push   $0x0
  80152b:	e8 93 fb ff ff       	call   8010c3 <sys_page_unmap>
	return r;
  801530:	83 c4 10             	add    $0x10,%esp
  801533:	eb b7                	jmp    8014ec <dup+0xa3>

00801535 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801535:	55                   	push   %ebp
  801536:	89 e5                	mov    %esp,%ebp
  801538:	53                   	push   %ebx
  801539:	83 ec 14             	sub    $0x14,%esp
  80153c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80153f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801542:	50                   	push   %eax
  801543:	53                   	push   %ebx
  801544:	e8 7b fd ff ff       	call   8012c4 <fd_lookup>
  801549:	83 c4 08             	add    $0x8,%esp
  80154c:	85 c0                	test   %eax,%eax
  80154e:	78 3f                	js     80158f <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801550:	83 ec 08             	sub    $0x8,%esp
  801553:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801556:	50                   	push   %eax
  801557:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80155a:	ff 30                	pushl  (%eax)
  80155c:	e8 b9 fd ff ff       	call   80131a <dev_lookup>
  801561:	83 c4 10             	add    $0x10,%esp
  801564:	85 c0                	test   %eax,%eax
  801566:	78 27                	js     80158f <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801568:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80156b:	8b 42 08             	mov    0x8(%edx),%eax
  80156e:	83 e0 03             	and    $0x3,%eax
  801571:	83 f8 01             	cmp    $0x1,%eax
  801574:	74 1e                	je     801594 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801576:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801579:	8b 40 08             	mov    0x8(%eax),%eax
  80157c:	85 c0                	test   %eax,%eax
  80157e:	74 35                	je     8015b5 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801580:	83 ec 04             	sub    $0x4,%esp
  801583:	ff 75 10             	pushl  0x10(%ebp)
  801586:	ff 75 0c             	pushl  0xc(%ebp)
  801589:	52                   	push   %edx
  80158a:	ff d0                	call   *%eax
  80158c:	83 c4 10             	add    $0x10,%esp
}
  80158f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801592:	c9                   	leave  
  801593:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801594:	a1 18 40 80 00       	mov    0x804018,%eax
  801599:	8b 40 48             	mov    0x48(%eax),%eax
  80159c:	83 ec 04             	sub    $0x4,%esp
  80159f:	53                   	push   %ebx
  8015a0:	50                   	push   %eax
  8015a1:	68 0d 2c 80 00       	push   $0x802c0d
  8015a6:	e8 fd ef ff ff       	call   8005a8 <cprintf>
		return -E_INVAL;
  8015ab:	83 c4 10             	add    $0x10,%esp
  8015ae:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015b3:	eb da                	jmp    80158f <read+0x5a>
		return -E_NOT_SUPP;
  8015b5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015ba:	eb d3                	jmp    80158f <read+0x5a>

008015bc <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8015bc:	55                   	push   %ebp
  8015bd:	89 e5                	mov    %esp,%ebp
  8015bf:	57                   	push   %edi
  8015c0:	56                   	push   %esi
  8015c1:	53                   	push   %ebx
  8015c2:	83 ec 0c             	sub    $0xc,%esp
  8015c5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8015c8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8015cb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015d0:	39 f3                	cmp    %esi,%ebx
  8015d2:	73 25                	jae    8015f9 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8015d4:	83 ec 04             	sub    $0x4,%esp
  8015d7:	89 f0                	mov    %esi,%eax
  8015d9:	29 d8                	sub    %ebx,%eax
  8015db:	50                   	push   %eax
  8015dc:	89 d8                	mov    %ebx,%eax
  8015de:	03 45 0c             	add    0xc(%ebp),%eax
  8015e1:	50                   	push   %eax
  8015e2:	57                   	push   %edi
  8015e3:	e8 4d ff ff ff       	call   801535 <read>
		if (m < 0)
  8015e8:	83 c4 10             	add    $0x10,%esp
  8015eb:	85 c0                	test   %eax,%eax
  8015ed:	78 08                	js     8015f7 <readn+0x3b>
			return m;
		if (m == 0)
  8015ef:	85 c0                	test   %eax,%eax
  8015f1:	74 06                	je     8015f9 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  8015f3:	01 c3                	add    %eax,%ebx
  8015f5:	eb d9                	jmp    8015d0 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8015f7:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8015f9:	89 d8                	mov    %ebx,%eax
  8015fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015fe:	5b                   	pop    %ebx
  8015ff:	5e                   	pop    %esi
  801600:	5f                   	pop    %edi
  801601:	5d                   	pop    %ebp
  801602:	c3                   	ret    

00801603 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801603:	55                   	push   %ebp
  801604:	89 e5                	mov    %esp,%ebp
  801606:	53                   	push   %ebx
  801607:	83 ec 14             	sub    $0x14,%esp
  80160a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80160d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801610:	50                   	push   %eax
  801611:	53                   	push   %ebx
  801612:	e8 ad fc ff ff       	call   8012c4 <fd_lookup>
  801617:	83 c4 08             	add    $0x8,%esp
  80161a:	85 c0                	test   %eax,%eax
  80161c:	78 3a                	js     801658 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80161e:	83 ec 08             	sub    $0x8,%esp
  801621:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801624:	50                   	push   %eax
  801625:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801628:	ff 30                	pushl  (%eax)
  80162a:	e8 eb fc ff ff       	call   80131a <dev_lookup>
  80162f:	83 c4 10             	add    $0x10,%esp
  801632:	85 c0                	test   %eax,%eax
  801634:	78 22                	js     801658 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801636:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801639:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80163d:	74 1e                	je     80165d <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80163f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801642:	8b 52 0c             	mov    0xc(%edx),%edx
  801645:	85 d2                	test   %edx,%edx
  801647:	74 35                	je     80167e <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801649:	83 ec 04             	sub    $0x4,%esp
  80164c:	ff 75 10             	pushl  0x10(%ebp)
  80164f:	ff 75 0c             	pushl  0xc(%ebp)
  801652:	50                   	push   %eax
  801653:	ff d2                	call   *%edx
  801655:	83 c4 10             	add    $0x10,%esp
}
  801658:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80165b:	c9                   	leave  
  80165c:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80165d:	a1 18 40 80 00       	mov    0x804018,%eax
  801662:	8b 40 48             	mov    0x48(%eax),%eax
  801665:	83 ec 04             	sub    $0x4,%esp
  801668:	53                   	push   %ebx
  801669:	50                   	push   %eax
  80166a:	68 29 2c 80 00       	push   $0x802c29
  80166f:	e8 34 ef ff ff       	call   8005a8 <cprintf>
		return -E_INVAL;
  801674:	83 c4 10             	add    $0x10,%esp
  801677:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80167c:	eb da                	jmp    801658 <write+0x55>
		return -E_NOT_SUPP;
  80167e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801683:	eb d3                	jmp    801658 <write+0x55>

00801685 <seek>:

int
seek(int fdnum, off_t offset)
{
  801685:	55                   	push   %ebp
  801686:	89 e5                	mov    %esp,%ebp
  801688:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80168b:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80168e:	50                   	push   %eax
  80168f:	ff 75 08             	pushl  0x8(%ebp)
  801692:	e8 2d fc ff ff       	call   8012c4 <fd_lookup>
  801697:	83 c4 08             	add    $0x8,%esp
  80169a:	85 c0                	test   %eax,%eax
  80169c:	78 0e                	js     8016ac <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80169e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016a4:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8016a7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016ac:	c9                   	leave  
  8016ad:	c3                   	ret    

008016ae <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8016ae:	55                   	push   %ebp
  8016af:	89 e5                	mov    %esp,%ebp
  8016b1:	53                   	push   %ebx
  8016b2:	83 ec 14             	sub    $0x14,%esp
  8016b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016b8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016bb:	50                   	push   %eax
  8016bc:	53                   	push   %ebx
  8016bd:	e8 02 fc ff ff       	call   8012c4 <fd_lookup>
  8016c2:	83 c4 08             	add    $0x8,%esp
  8016c5:	85 c0                	test   %eax,%eax
  8016c7:	78 37                	js     801700 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016c9:	83 ec 08             	sub    $0x8,%esp
  8016cc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016cf:	50                   	push   %eax
  8016d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016d3:	ff 30                	pushl  (%eax)
  8016d5:	e8 40 fc ff ff       	call   80131a <dev_lookup>
  8016da:	83 c4 10             	add    $0x10,%esp
  8016dd:	85 c0                	test   %eax,%eax
  8016df:	78 1f                	js     801700 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8016e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016e4:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8016e8:	74 1b                	je     801705 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8016ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016ed:	8b 52 18             	mov    0x18(%edx),%edx
  8016f0:	85 d2                	test   %edx,%edx
  8016f2:	74 32                	je     801726 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8016f4:	83 ec 08             	sub    $0x8,%esp
  8016f7:	ff 75 0c             	pushl  0xc(%ebp)
  8016fa:	50                   	push   %eax
  8016fb:	ff d2                	call   *%edx
  8016fd:	83 c4 10             	add    $0x10,%esp
}
  801700:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801703:	c9                   	leave  
  801704:	c3                   	ret    
			thisenv->env_id, fdnum);
  801705:	a1 18 40 80 00       	mov    0x804018,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80170a:	8b 40 48             	mov    0x48(%eax),%eax
  80170d:	83 ec 04             	sub    $0x4,%esp
  801710:	53                   	push   %ebx
  801711:	50                   	push   %eax
  801712:	68 ec 2b 80 00       	push   $0x802bec
  801717:	e8 8c ee ff ff       	call   8005a8 <cprintf>
		return -E_INVAL;
  80171c:	83 c4 10             	add    $0x10,%esp
  80171f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801724:	eb da                	jmp    801700 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801726:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80172b:	eb d3                	jmp    801700 <ftruncate+0x52>

0080172d <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80172d:	55                   	push   %ebp
  80172e:	89 e5                	mov    %esp,%ebp
  801730:	53                   	push   %ebx
  801731:	83 ec 14             	sub    $0x14,%esp
  801734:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801737:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80173a:	50                   	push   %eax
  80173b:	ff 75 08             	pushl  0x8(%ebp)
  80173e:	e8 81 fb ff ff       	call   8012c4 <fd_lookup>
  801743:	83 c4 08             	add    $0x8,%esp
  801746:	85 c0                	test   %eax,%eax
  801748:	78 4b                	js     801795 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80174a:	83 ec 08             	sub    $0x8,%esp
  80174d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801750:	50                   	push   %eax
  801751:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801754:	ff 30                	pushl  (%eax)
  801756:	e8 bf fb ff ff       	call   80131a <dev_lookup>
  80175b:	83 c4 10             	add    $0x10,%esp
  80175e:	85 c0                	test   %eax,%eax
  801760:	78 33                	js     801795 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801762:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801765:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801769:	74 2f                	je     80179a <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80176b:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80176e:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801775:	00 00 00 
	stat->st_isdir = 0;
  801778:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80177f:	00 00 00 
	stat->st_dev = dev;
  801782:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801788:	83 ec 08             	sub    $0x8,%esp
  80178b:	53                   	push   %ebx
  80178c:	ff 75 f0             	pushl  -0x10(%ebp)
  80178f:	ff 50 14             	call   *0x14(%eax)
  801792:	83 c4 10             	add    $0x10,%esp
}
  801795:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801798:	c9                   	leave  
  801799:	c3                   	ret    
		return -E_NOT_SUPP;
  80179a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80179f:	eb f4                	jmp    801795 <fstat+0x68>

008017a1 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8017a1:	55                   	push   %ebp
  8017a2:	89 e5                	mov    %esp,%ebp
  8017a4:	56                   	push   %esi
  8017a5:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8017a6:	83 ec 08             	sub    $0x8,%esp
  8017a9:	6a 00                	push   $0x0
  8017ab:	ff 75 08             	pushl  0x8(%ebp)
  8017ae:	e8 26 02 00 00       	call   8019d9 <open>
  8017b3:	89 c3                	mov    %eax,%ebx
  8017b5:	83 c4 10             	add    $0x10,%esp
  8017b8:	85 c0                	test   %eax,%eax
  8017ba:	78 1b                	js     8017d7 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8017bc:	83 ec 08             	sub    $0x8,%esp
  8017bf:	ff 75 0c             	pushl  0xc(%ebp)
  8017c2:	50                   	push   %eax
  8017c3:	e8 65 ff ff ff       	call   80172d <fstat>
  8017c8:	89 c6                	mov    %eax,%esi
	close(fd);
  8017ca:	89 1c 24             	mov    %ebx,(%esp)
  8017cd:	e8 27 fc ff ff       	call   8013f9 <close>
	return r;
  8017d2:	83 c4 10             	add    $0x10,%esp
  8017d5:	89 f3                	mov    %esi,%ebx
}
  8017d7:	89 d8                	mov    %ebx,%eax
  8017d9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017dc:	5b                   	pop    %ebx
  8017dd:	5e                   	pop    %esi
  8017de:	5d                   	pop    %ebp
  8017df:	c3                   	ret    

008017e0 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8017e0:	55                   	push   %ebp
  8017e1:	89 e5                	mov    %esp,%ebp
  8017e3:	56                   	push   %esi
  8017e4:	53                   	push   %ebx
  8017e5:	89 c6                	mov    %eax,%esi
  8017e7:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8017e9:	83 3d 10 40 80 00 00 	cmpl   $0x0,0x804010
  8017f0:	74 27                	je     801819 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8017f2:	6a 07                	push   $0x7
  8017f4:	68 00 50 80 00       	push   $0x805000
  8017f9:	56                   	push   %esi
  8017fa:	ff 35 10 40 80 00    	pushl  0x804010
  801800:	e8 57 0c 00 00       	call   80245c <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801805:	83 c4 0c             	add    $0xc,%esp
  801808:	6a 00                	push   $0x0
  80180a:	53                   	push   %ebx
  80180b:	6a 00                	push   $0x0
  80180d:	e8 e1 0b 00 00       	call   8023f3 <ipc_recv>
}
  801812:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801815:	5b                   	pop    %ebx
  801816:	5e                   	pop    %esi
  801817:	5d                   	pop    %ebp
  801818:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801819:	83 ec 0c             	sub    $0xc,%esp
  80181c:	6a 01                	push   $0x1
  80181e:	e8 92 0c 00 00       	call   8024b5 <ipc_find_env>
  801823:	a3 10 40 80 00       	mov    %eax,0x804010
  801828:	83 c4 10             	add    $0x10,%esp
  80182b:	eb c5                	jmp    8017f2 <fsipc+0x12>

0080182d <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80182d:	55                   	push   %ebp
  80182e:	89 e5                	mov    %esp,%ebp
  801830:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801833:	8b 45 08             	mov    0x8(%ebp),%eax
  801836:	8b 40 0c             	mov    0xc(%eax),%eax
  801839:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80183e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801841:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801846:	ba 00 00 00 00       	mov    $0x0,%edx
  80184b:	b8 02 00 00 00       	mov    $0x2,%eax
  801850:	e8 8b ff ff ff       	call   8017e0 <fsipc>
}
  801855:	c9                   	leave  
  801856:	c3                   	ret    

00801857 <devfile_flush>:
{
  801857:	55                   	push   %ebp
  801858:	89 e5                	mov    %esp,%ebp
  80185a:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80185d:	8b 45 08             	mov    0x8(%ebp),%eax
  801860:	8b 40 0c             	mov    0xc(%eax),%eax
  801863:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801868:	ba 00 00 00 00       	mov    $0x0,%edx
  80186d:	b8 06 00 00 00       	mov    $0x6,%eax
  801872:	e8 69 ff ff ff       	call   8017e0 <fsipc>
}
  801877:	c9                   	leave  
  801878:	c3                   	ret    

00801879 <devfile_stat>:
{
  801879:	55                   	push   %ebp
  80187a:	89 e5                	mov    %esp,%ebp
  80187c:	53                   	push   %ebx
  80187d:	83 ec 04             	sub    $0x4,%esp
  801880:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801883:	8b 45 08             	mov    0x8(%ebp),%eax
  801886:	8b 40 0c             	mov    0xc(%eax),%eax
  801889:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80188e:	ba 00 00 00 00       	mov    $0x0,%edx
  801893:	b8 05 00 00 00       	mov    $0x5,%eax
  801898:	e8 43 ff ff ff       	call   8017e0 <fsipc>
  80189d:	85 c0                	test   %eax,%eax
  80189f:	78 2c                	js     8018cd <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8018a1:	83 ec 08             	sub    $0x8,%esp
  8018a4:	68 00 50 80 00       	push   $0x805000
  8018a9:	53                   	push   %ebx
  8018aa:	e8 96 f3 ff ff       	call   800c45 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8018af:	a1 80 50 80 00       	mov    0x805080,%eax
  8018b4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8018ba:	a1 84 50 80 00       	mov    0x805084,%eax
  8018bf:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8018c5:	83 c4 10             	add    $0x10,%esp
  8018c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018d0:	c9                   	leave  
  8018d1:	c3                   	ret    

008018d2 <devfile_write>:
{
  8018d2:	55                   	push   %ebp
  8018d3:	89 e5                	mov    %esp,%ebp
  8018d5:	53                   	push   %ebx
  8018d6:	83 ec 04             	sub    $0x4,%esp
  8018d9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8018dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018df:	8b 40 0c             	mov    0xc(%eax),%eax
  8018e2:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  8018e7:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  8018ed:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  8018f3:	77 30                	ja     801925 <devfile_write+0x53>
	memmove(fsipcbuf.write.req_buf, buf, n);
  8018f5:	83 ec 04             	sub    $0x4,%esp
  8018f8:	53                   	push   %ebx
  8018f9:	ff 75 0c             	pushl  0xc(%ebp)
  8018fc:	68 08 50 80 00       	push   $0x805008
  801901:	e8 cd f4 ff ff       	call   800dd3 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801906:	ba 00 00 00 00       	mov    $0x0,%edx
  80190b:	b8 04 00 00 00       	mov    $0x4,%eax
  801910:	e8 cb fe ff ff       	call   8017e0 <fsipc>
  801915:	83 c4 10             	add    $0x10,%esp
  801918:	85 c0                	test   %eax,%eax
  80191a:	78 04                	js     801920 <devfile_write+0x4e>
	assert(r <= n);
  80191c:	39 d8                	cmp    %ebx,%eax
  80191e:	77 1e                	ja     80193e <devfile_write+0x6c>
}
  801920:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801923:	c9                   	leave  
  801924:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  801925:	68 5c 2c 80 00       	push   $0x802c5c
  80192a:	68 89 2c 80 00       	push   $0x802c89
  80192f:	68 94 00 00 00       	push   $0x94
  801934:	68 9e 2c 80 00       	push   $0x802c9e
  801939:	e8 6f 0a 00 00       	call   8023ad <_panic>
	assert(r <= n);
  80193e:	68 a9 2c 80 00       	push   $0x802ca9
  801943:	68 89 2c 80 00       	push   $0x802c89
  801948:	68 98 00 00 00       	push   $0x98
  80194d:	68 9e 2c 80 00       	push   $0x802c9e
  801952:	e8 56 0a 00 00       	call   8023ad <_panic>

00801957 <devfile_read>:
{
  801957:	55                   	push   %ebp
  801958:	89 e5                	mov    %esp,%ebp
  80195a:	56                   	push   %esi
  80195b:	53                   	push   %ebx
  80195c:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80195f:	8b 45 08             	mov    0x8(%ebp),%eax
  801962:	8b 40 0c             	mov    0xc(%eax),%eax
  801965:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80196a:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801970:	ba 00 00 00 00       	mov    $0x0,%edx
  801975:	b8 03 00 00 00       	mov    $0x3,%eax
  80197a:	e8 61 fe ff ff       	call   8017e0 <fsipc>
  80197f:	89 c3                	mov    %eax,%ebx
  801981:	85 c0                	test   %eax,%eax
  801983:	78 1f                	js     8019a4 <devfile_read+0x4d>
	assert(r <= n);
  801985:	39 f0                	cmp    %esi,%eax
  801987:	77 24                	ja     8019ad <devfile_read+0x56>
	assert(r <= PGSIZE);
  801989:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80198e:	7f 33                	jg     8019c3 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801990:	83 ec 04             	sub    $0x4,%esp
  801993:	50                   	push   %eax
  801994:	68 00 50 80 00       	push   $0x805000
  801999:	ff 75 0c             	pushl  0xc(%ebp)
  80199c:	e8 32 f4 ff ff       	call   800dd3 <memmove>
	return r;
  8019a1:	83 c4 10             	add    $0x10,%esp
}
  8019a4:	89 d8                	mov    %ebx,%eax
  8019a6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019a9:	5b                   	pop    %ebx
  8019aa:	5e                   	pop    %esi
  8019ab:	5d                   	pop    %ebp
  8019ac:	c3                   	ret    
	assert(r <= n);
  8019ad:	68 a9 2c 80 00       	push   $0x802ca9
  8019b2:	68 89 2c 80 00       	push   $0x802c89
  8019b7:	6a 7c                	push   $0x7c
  8019b9:	68 9e 2c 80 00       	push   $0x802c9e
  8019be:	e8 ea 09 00 00       	call   8023ad <_panic>
	assert(r <= PGSIZE);
  8019c3:	68 b0 2c 80 00       	push   $0x802cb0
  8019c8:	68 89 2c 80 00       	push   $0x802c89
  8019cd:	6a 7d                	push   $0x7d
  8019cf:	68 9e 2c 80 00       	push   $0x802c9e
  8019d4:	e8 d4 09 00 00       	call   8023ad <_panic>

008019d9 <open>:
{
  8019d9:	55                   	push   %ebp
  8019da:	89 e5                	mov    %esp,%ebp
  8019dc:	56                   	push   %esi
  8019dd:	53                   	push   %ebx
  8019de:	83 ec 1c             	sub    $0x1c,%esp
  8019e1:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8019e4:	56                   	push   %esi
  8019e5:	e8 24 f2 ff ff       	call   800c0e <strlen>
  8019ea:	83 c4 10             	add    $0x10,%esp
  8019ed:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8019f2:	7f 6c                	jg     801a60 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8019f4:	83 ec 0c             	sub    $0xc,%esp
  8019f7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019fa:	50                   	push   %eax
  8019fb:	e8 75 f8 ff ff       	call   801275 <fd_alloc>
  801a00:	89 c3                	mov    %eax,%ebx
  801a02:	83 c4 10             	add    $0x10,%esp
  801a05:	85 c0                	test   %eax,%eax
  801a07:	78 3c                	js     801a45 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801a09:	83 ec 08             	sub    $0x8,%esp
  801a0c:	56                   	push   %esi
  801a0d:	68 00 50 80 00       	push   $0x805000
  801a12:	e8 2e f2 ff ff       	call   800c45 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801a17:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a1a:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801a1f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a22:	b8 01 00 00 00       	mov    $0x1,%eax
  801a27:	e8 b4 fd ff ff       	call   8017e0 <fsipc>
  801a2c:	89 c3                	mov    %eax,%ebx
  801a2e:	83 c4 10             	add    $0x10,%esp
  801a31:	85 c0                	test   %eax,%eax
  801a33:	78 19                	js     801a4e <open+0x75>
	return fd2num(fd);
  801a35:	83 ec 0c             	sub    $0xc,%esp
  801a38:	ff 75 f4             	pushl  -0xc(%ebp)
  801a3b:	e8 0e f8 ff ff       	call   80124e <fd2num>
  801a40:	89 c3                	mov    %eax,%ebx
  801a42:	83 c4 10             	add    $0x10,%esp
}
  801a45:	89 d8                	mov    %ebx,%eax
  801a47:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a4a:	5b                   	pop    %ebx
  801a4b:	5e                   	pop    %esi
  801a4c:	5d                   	pop    %ebp
  801a4d:	c3                   	ret    
		fd_close(fd, 0);
  801a4e:	83 ec 08             	sub    $0x8,%esp
  801a51:	6a 00                	push   $0x0
  801a53:	ff 75 f4             	pushl  -0xc(%ebp)
  801a56:	e8 15 f9 ff ff       	call   801370 <fd_close>
		return r;
  801a5b:	83 c4 10             	add    $0x10,%esp
  801a5e:	eb e5                	jmp    801a45 <open+0x6c>
		return -E_BAD_PATH;
  801a60:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801a65:	eb de                	jmp    801a45 <open+0x6c>

00801a67 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801a67:	55                   	push   %ebp
  801a68:	89 e5                	mov    %esp,%ebp
  801a6a:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801a6d:	ba 00 00 00 00       	mov    $0x0,%edx
  801a72:	b8 08 00 00 00       	mov    $0x8,%eax
  801a77:	e8 64 fd ff ff       	call   8017e0 <fsipc>
}
  801a7c:	c9                   	leave  
  801a7d:	c3                   	ret    

00801a7e <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801a7e:	55                   	push   %ebp
  801a7f:	89 e5                	mov    %esp,%ebp
  801a81:	56                   	push   %esi
  801a82:	53                   	push   %ebx
  801a83:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801a86:	83 ec 0c             	sub    $0xc,%esp
  801a89:	ff 75 08             	pushl  0x8(%ebp)
  801a8c:	e8 cd f7 ff ff       	call   80125e <fd2data>
  801a91:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801a93:	83 c4 08             	add    $0x8,%esp
  801a96:	68 bc 2c 80 00       	push   $0x802cbc
  801a9b:	53                   	push   %ebx
  801a9c:	e8 a4 f1 ff ff       	call   800c45 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801aa1:	8b 46 04             	mov    0x4(%esi),%eax
  801aa4:	2b 06                	sub    (%esi),%eax
  801aa6:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801aac:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801ab3:	00 00 00 
	stat->st_dev = &devpipe;
  801ab6:	c7 83 88 00 00 00 24 	movl   $0x803024,0x88(%ebx)
  801abd:	30 80 00 
	return 0;
}
  801ac0:	b8 00 00 00 00       	mov    $0x0,%eax
  801ac5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ac8:	5b                   	pop    %ebx
  801ac9:	5e                   	pop    %esi
  801aca:	5d                   	pop    %ebp
  801acb:	c3                   	ret    

00801acc <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801acc:	55                   	push   %ebp
  801acd:	89 e5                	mov    %esp,%ebp
  801acf:	53                   	push   %ebx
  801ad0:	83 ec 0c             	sub    $0xc,%esp
  801ad3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801ad6:	53                   	push   %ebx
  801ad7:	6a 00                	push   $0x0
  801ad9:	e8 e5 f5 ff ff       	call   8010c3 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801ade:	89 1c 24             	mov    %ebx,(%esp)
  801ae1:	e8 78 f7 ff ff       	call   80125e <fd2data>
  801ae6:	83 c4 08             	add    $0x8,%esp
  801ae9:	50                   	push   %eax
  801aea:	6a 00                	push   $0x0
  801aec:	e8 d2 f5 ff ff       	call   8010c3 <sys_page_unmap>
}
  801af1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801af4:	c9                   	leave  
  801af5:	c3                   	ret    

00801af6 <_pipeisclosed>:
{
  801af6:	55                   	push   %ebp
  801af7:	89 e5                	mov    %esp,%ebp
  801af9:	57                   	push   %edi
  801afa:	56                   	push   %esi
  801afb:	53                   	push   %ebx
  801afc:	83 ec 1c             	sub    $0x1c,%esp
  801aff:	89 c7                	mov    %eax,%edi
  801b01:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801b03:	a1 18 40 80 00       	mov    0x804018,%eax
  801b08:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801b0b:	83 ec 0c             	sub    $0xc,%esp
  801b0e:	57                   	push   %edi
  801b0f:	e8 da 09 00 00       	call   8024ee <pageref>
  801b14:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801b17:	89 34 24             	mov    %esi,(%esp)
  801b1a:	e8 cf 09 00 00       	call   8024ee <pageref>
		nn = thisenv->env_runs;
  801b1f:	8b 15 18 40 80 00    	mov    0x804018,%edx
  801b25:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801b28:	83 c4 10             	add    $0x10,%esp
  801b2b:	39 cb                	cmp    %ecx,%ebx
  801b2d:	74 1b                	je     801b4a <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801b2f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801b32:	75 cf                	jne    801b03 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801b34:	8b 42 58             	mov    0x58(%edx),%eax
  801b37:	6a 01                	push   $0x1
  801b39:	50                   	push   %eax
  801b3a:	53                   	push   %ebx
  801b3b:	68 c3 2c 80 00       	push   $0x802cc3
  801b40:	e8 63 ea ff ff       	call   8005a8 <cprintf>
  801b45:	83 c4 10             	add    $0x10,%esp
  801b48:	eb b9                	jmp    801b03 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801b4a:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801b4d:	0f 94 c0             	sete   %al
  801b50:	0f b6 c0             	movzbl %al,%eax
}
  801b53:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b56:	5b                   	pop    %ebx
  801b57:	5e                   	pop    %esi
  801b58:	5f                   	pop    %edi
  801b59:	5d                   	pop    %ebp
  801b5a:	c3                   	ret    

00801b5b <devpipe_write>:
{
  801b5b:	55                   	push   %ebp
  801b5c:	89 e5                	mov    %esp,%ebp
  801b5e:	57                   	push   %edi
  801b5f:	56                   	push   %esi
  801b60:	53                   	push   %ebx
  801b61:	83 ec 28             	sub    $0x28,%esp
  801b64:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801b67:	56                   	push   %esi
  801b68:	e8 f1 f6 ff ff       	call   80125e <fd2data>
  801b6d:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801b6f:	83 c4 10             	add    $0x10,%esp
  801b72:	bf 00 00 00 00       	mov    $0x0,%edi
  801b77:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801b7a:	74 4f                	je     801bcb <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801b7c:	8b 43 04             	mov    0x4(%ebx),%eax
  801b7f:	8b 0b                	mov    (%ebx),%ecx
  801b81:	8d 51 20             	lea    0x20(%ecx),%edx
  801b84:	39 d0                	cmp    %edx,%eax
  801b86:	72 14                	jb     801b9c <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801b88:	89 da                	mov    %ebx,%edx
  801b8a:	89 f0                	mov    %esi,%eax
  801b8c:	e8 65 ff ff ff       	call   801af6 <_pipeisclosed>
  801b91:	85 c0                	test   %eax,%eax
  801b93:	75 3a                	jne    801bcf <devpipe_write+0x74>
			sys_yield();
  801b95:	e8 85 f4 ff ff       	call   80101f <sys_yield>
  801b9a:	eb e0                	jmp    801b7c <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801b9c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b9f:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801ba3:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801ba6:	89 c2                	mov    %eax,%edx
  801ba8:	c1 fa 1f             	sar    $0x1f,%edx
  801bab:	89 d1                	mov    %edx,%ecx
  801bad:	c1 e9 1b             	shr    $0x1b,%ecx
  801bb0:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801bb3:	83 e2 1f             	and    $0x1f,%edx
  801bb6:	29 ca                	sub    %ecx,%edx
  801bb8:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801bbc:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801bc0:	83 c0 01             	add    $0x1,%eax
  801bc3:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801bc6:	83 c7 01             	add    $0x1,%edi
  801bc9:	eb ac                	jmp    801b77 <devpipe_write+0x1c>
	return i;
  801bcb:	89 f8                	mov    %edi,%eax
  801bcd:	eb 05                	jmp    801bd4 <devpipe_write+0x79>
				return 0;
  801bcf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bd4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801bd7:	5b                   	pop    %ebx
  801bd8:	5e                   	pop    %esi
  801bd9:	5f                   	pop    %edi
  801bda:	5d                   	pop    %ebp
  801bdb:	c3                   	ret    

00801bdc <devpipe_read>:
{
  801bdc:	55                   	push   %ebp
  801bdd:	89 e5                	mov    %esp,%ebp
  801bdf:	57                   	push   %edi
  801be0:	56                   	push   %esi
  801be1:	53                   	push   %ebx
  801be2:	83 ec 18             	sub    $0x18,%esp
  801be5:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801be8:	57                   	push   %edi
  801be9:	e8 70 f6 ff ff       	call   80125e <fd2data>
  801bee:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801bf0:	83 c4 10             	add    $0x10,%esp
  801bf3:	be 00 00 00 00       	mov    $0x0,%esi
  801bf8:	3b 75 10             	cmp    0x10(%ebp),%esi
  801bfb:	74 47                	je     801c44 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801bfd:	8b 03                	mov    (%ebx),%eax
  801bff:	3b 43 04             	cmp    0x4(%ebx),%eax
  801c02:	75 22                	jne    801c26 <devpipe_read+0x4a>
			if (i > 0)
  801c04:	85 f6                	test   %esi,%esi
  801c06:	75 14                	jne    801c1c <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801c08:	89 da                	mov    %ebx,%edx
  801c0a:	89 f8                	mov    %edi,%eax
  801c0c:	e8 e5 fe ff ff       	call   801af6 <_pipeisclosed>
  801c11:	85 c0                	test   %eax,%eax
  801c13:	75 33                	jne    801c48 <devpipe_read+0x6c>
			sys_yield();
  801c15:	e8 05 f4 ff ff       	call   80101f <sys_yield>
  801c1a:	eb e1                	jmp    801bfd <devpipe_read+0x21>
				return i;
  801c1c:	89 f0                	mov    %esi,%eax
}
  801c1e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c21:	5b                   	pop    %ebx
  801c22:	5e                   	pop    %esi
  801c23:	5f                   	pop    %edi
  801c24:	5d                   	pop    %ebp
  801c25:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801c26:	99                   	cltd   
  801c27:	c1 ea 1b             	shr    $0x1b,%edx
  801c2a:	01 d0                	add    %edx,%eax
  801c2c:	83 e0 1f             	and    $0x1f,%eax
  801c2f:	29 d0                	sub    %edx,%eax
  801c31:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801c36:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c39:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801c3c:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801c3f:	83 c6 01             	add    $0x1,%esi
  801c42:	eb b4                	jmp    801bf8 <devpipe_read+0x1c>
	return i;
  801c44:	89 f0                	mov    %esi,%eax
  801c46:	eb d6                	jmp    801c1e <devpipe_read+0x42>
				return 0;
  801c48:	b8 00 00 00 00       	mov    $0x0,%eax
  801c4d:	eb cf                	jmp    801c1e <devpipe_read+0x42>

00801c4f <pipe>:
{
  801c4f:	55                   	push   %ebp
  801c50:	89 e5                	mov    %esp,%ebp
  801c52:	56                   	push   %esi
  801c53:	53                   	push   %ebx
  801c54:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801c57:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c5a:	50                   	push   %eax
  801c5b:	e8 15 f6 ff ff       	call   801275 <fd_alloc>
  801c60:	89 c3                	mov    %eax,%ebx
  801c62:	83 c4 10             	add    $0x10,%esp
  801c65:	85 c0                	test   %eax,%eax
  801c67:	78 5b                	js     801cc4 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c69:	83 ec 04             	sub    $0x4,%esp
  801c6c:	68 07 04 00 00       	push   $0x407
  801c71:	ff 75 f4             	pushl  -0xc(%ebp)
  801c74:	6a 00                	push   $0x0
  801c76:	e8 c3 f3 ff ff       	call   80103e <sys_page_alloc>
  801c7b:	89 c3                	mov    %eax,%ebx
  801c7d:	83 c4 10             	add    $0x10,%esp
  801c80:	85 c0                	test   %eax,%eax
  801c82:	78 40                	js     801cc4 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  801c84:	83 ec 0c             	sub    $0xc,%esp
  801c87:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c8a:	50                   	push   %eax
  801c8b:	e8 e5 f5 ff ff       	call   801275 <fd_alloc>
  801c90:	89 c3                	mov    %eax,%ebx
  801c92:	83 c4 10             	add    $0x10,%esp
  801c95:	85 c0                	test   %eax,%eax
  801c97:	78 1b                	js     801cb4 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c99:	83 ec 04             	sub    $0x4,%esp
  801c9c:	68 07 04 00 00       	push   $0x407
  801ca1:	ff 75 f0             	pushl  -0x10(%ebp)
  801ca4:	6a 00                	push   $0x0
  801ca6:	e8 93 f3 ff ff       	call   80103e <sys_page_alloc>
  801cab:	89 c3                	mov    %eax,%ebx
  801cad:	83 c4 10             	add    $0x10,%esp
  801cb0:	85 c0                	test   %eax,%eax
  801cb2:	79 19                	jns    801ccd <pipe+0x7e>
	sys_page_unmap(0, fd0);
  801cb4:	83 ec 08             	sub    $0x8,%esp
  801cb7:	ff 75 f4             	pushl  -0xc(%ebp)
  801cba:	6a 00                	push   $0x0
  801cbc:	e8 02 f4 ff ff       	call   8010c3 <sys_page_unmap>
  801cc1:	83 c4 10             	add    $0x10,%esp
}
  801cc4:	89 d8                	mov    %ebx,%eax
  801cc6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cc9:	5b                   	pop    %ebx
  801cca:	5e                   	pop    %esi
  801ccb:	5d                   	pop    %ebp
  801ccc:	c3                   	ret    
	va = fd2data(fd0);
  801ccd:	83 ec 0c             	sub    $0xc,%esp
  801cd0:	ff 75 f4             	pushl  -0xc(%ebp)
  801cd3:	e8 86 f5 ff ff       	call   80125e <fd2data>
  801cd8:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801cda:	83 c4 0c             	add    $0xc,%esp
  801cdd:	68 07 04 00 00       	push   $0x407
  801ce2:	50                   	push   %eax
  801ce3:	6a 00                	push   $0x0
  801ce5:	e8 54 f3 ff ff       	call   80103e <sys_page_alloc>
  801cea:	89 c3                	mov    %eax,%ebx
  801cec:	83 c4 10             	add    $0x10,%esp
  801cef:	85 c0                	test   %eax,%eax
  801cf1:	0f 88 8c 00 00 00    	js     801d83 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801cf7:	83 ec 0c             	sub    $0xc,%esp
  801cfa:	ff 75 f0             	pushl  -0x10(%ebp)
  801cfd:	e8 5c f5 ff ff       	call   80125e <fd2data>
  801d02:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801d09:	50                   	push   %eax
  801d0a:	6a 00                	push   $0x0
  801d0c:	56                   	push   %esi
  801d0d:	6a 00                	push   $0x0
  801d0f:	e8 6d f3 ff ff       	call   801081 <sys_page_map>
  801d14:	89 c3                	mov    %eax,%ebx
  801d16:	83 c4 20             	add    $0x20,%esp
  801d19:	85 c0                	test   %eax,%eax
  801d1b:	78 58                	js     801d75 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801d1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d20:	8b 15 24 30 80 00    	mov    0x803024,%edx
  801d26:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801d28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d2b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801d32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d35:	8b 15 24 30 80 00    	mov    0x803024,%edx
  801d3b:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801d3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d40:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801d47:	83 ec 0c             	sub    $0xc,%esp
  801d4a:	ff 75 f4             	pushl  -0xc(%ebp)
  801d4d:	e8 fc f4 ff ff       	call   80124e <fd2num>
  801d52:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d55:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801d57:	83 c4 04             	add    $0x4,%esp
  801d5a:	ff 75 f0             	pushl  -0x10(%ebp)
  801d5d:	e8 ec f4 ff ff       	call   80124e <fd2num>
  801d62:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d65:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801d68:	83 c4 10             	add    $0x10,%esp
  801d6b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801d70:	e9 4f ff ff ff       	jmp    801cc4 <pipe+0x75>
	sys_page_unmap(0, va);
  801d75:	83 ec 08             	sub    $0x8,%esp
  801d78:	56                   	push   %esi
  801d79:	6a 00                	push   $0x0
  801d7b:	e8 43 f3 ff ff       	call   8010c3 <sys_page_unmap>
  801d80:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801d83:	83 ec 08             	sub    $0x8,%esp
  801d86:	ff 75 f0             	pushl  -0x10(%ebp)
  801d89:	6a 00                	push   $0x0
  801d8b:	e8 33 f3 ff ff       	call   8010c3 <sys_page_unmap>
  801d90:	83 c4 10             	add    $0x10,%esp
  801d93:	e9 1c ff ff ff       	jmp    801cb4 <pipe+0x65>

00801d98 <pipeisclosed>:
{
  801d98:	55                   	push   %ebp
  801d99:	89 e5                	mov    %esp,%ebp
  801d9b:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801d9e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801da1:	50                   	push   %eax
  801da2:	ff 75 08             	pushl  0x8(%ebp)
  801da5:	e8 1a f5 ff ff       	call   8012c4 <fd_lookup>
  801daa:	83 c4 10             	add    $0x10,%esp
  801dad:	85 c0                	test   %eax,%eax
  801daf:	78 18                	js     801dc9 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801db1:	83 ec 0c             	sub    $0xc,%esp
  801db4:	ff 75 f4             	pushl  -0xc(%ebp)
  801db7:	e8 a2 f4 ff ff       	call   80125e <fd2data>
	return _pipeisclosed(fd, p);
  801dbc:	89 c2                	mov    %eax,%edx
  801dbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dc1:	e8 30 fd ff ff       	call   801af6 <_pipeisclosed>
  801dc6:	83 c4 10             	add    $0x10,%esp
}
  801dc9:	c9                   	leave  
  801dca:	c3                   	ret    

00801dcb <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801dcb:	55                   	push   %ebp
  801dcc:	89 e5                	mov    %esp,%ebp
  801dce:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801dd1:	68 db 2c 80 00       	push   $0x802cdb
  801dd6:	ff 75 0c             	pushl  0xc(%ebp)
  801dd9:	e8 67 ee ff ff       	call   800c45 <strcpy>
	return 0;
}
  801dde:	b8 00 00 00 00       	mov    $0x0,%eax
  801de3:	c9                   	leave  
  801de4:	c3                   	ret    

00801de5 <devsock_close>:
{
  801de5:	55                   	push   %ebp
  801de6:	89 e5                	mov    %esp,%ebp
  801de8:	53                   	push   %ebx
  801de9:	83 ec 10             	sub    $0x10,%esp
  801dec:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801def:	53                   	push   %ebx
  801df0:	e8 f9 06 00 00       	call   8024ee <pageref>
  801df5:	83 c4 10             	add    $0x10,%esp
		return 0;
  801df8:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801dfd:	83 f8 01             	cmp    $0x1,%eax
  801e00:	74 07                	je     801e09 <devsock_close+0x24>
}
  801e02:	89 d0                	mov    %edx,%eax
  801e04:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e07:	c9                   	leave  
  801e08:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801e09:	83 ec 0c             	sub    $0xc,%esp
  801e0c:	ff 73 0c             	pushl  0xc(%ebx)
  801e0f:	e8 b7 02 00 00       	call   8020cb <nsipc_close>
  801e14:	89 c2                	mov    %eax,%edx
  801e16:	83 c4 10             	add    $0x10,%esp
  801e19:	eb e7                	jmp    801e02 <devsock_close+0x1d>

00801e1b <devsock_write>:
{
  801e1b:	55                   	push   %ebp
  801e1c:	89 e5                	mov    %esp,%ebp
  801e1e:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801e21:	6a 00                	push   $0x0
  801e23:	ff 75 10             	pushl  0x10(%ebp)
  801e26:	ff 75 0c             	pushl  0xc(%ebp)
  801e29:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2c:	ff 70 0c             	pushl  0xc(%eax)
  801e2f:	e8 74 03 00 00       	call   8021a8 <nsipc_send>
}
  801e34:	c9                   	leave  
  801e35:	c3                   	ret    

00801e36 <devsock_read>:
{
  801e36:	55                   	push   %ebp
  801e37:	89 e5                	mov    %esp,%ebp
  801e39:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801e3c:	6a 00                	push   $0x0
  801e3e:	ff 75 10             	pushl  0x10(%ebp)
  801e41:	ff 75 0c             	pushl  0xc(%ebp)
  801e44:	8b 45 08             	mov    0x8(%ebp),%eax
  801e47:	ff 70 0c             	pushl  0xc(%eax)
  801e4a:	e8 ed 02 00 00       	call   80213c <nsipc_recv>
}
  801e4f:	c9                   	leave  
  801e50:	c3                   	ret    

00801e51 <fd2sockid>:
{
  801e51:	55                   	push   %ebp
  801e52:	89 e5                	mov    %esp,%ebp
  801e54:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801e57:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801e5a:	52                   	push   %edx
  801e5b:	50                   	push   %eax
  801e5c:	e8 63 f4 ff ff       	call   8012c4 <fd_lookup>
  801e61:	83 c4 10             	add    $0x10,%esp
  801e64:	85 c0                	test   %eax,%eax
  801e66:	78 10                	js     801e78 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801e68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e6b:	8b 0d 40 30 80 00    	mov    0x803040,%ecx
  801e71:	39 08                	cmp    %ecx,(%eax)
  801e73:	75 05                	jne    801e7a <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801e75:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801e78:	c9                   	leave  
  801e79:	c3                   	ret    
		return -E_NOT_SUPP;
  801e7a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801e7f:	eb f7                	jmp    801e78 <fd2sockid+0x27>

00801e81 <alloc_sockfd>:
{
  801e81:	55                   	push   %ebp
  801e82:	89 e5                	mov    %esp,%ebp
  801e84:	56                   	push   %esi
  801e85:	53                   	push   %ebx
  801e86:	83 ec 1c             	sub    $0x1c,%esp
  801e89:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801e8b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e8e:	50                   	push   %eax
  801e8f:	e8 e1 f3 ff ff       	call   801275 <fd_alloc>
  801e94:	89 c3                	mov    %eax,%ebx
  801e96:	83 c4 10             	add    $0x10,%esp
  801e99:	85 c0                	test   %eax,%eax
  801e9b:	78 43                	js     801ee0 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801e9d:	83 ec 04             	sub    $0x4,%esp
  801ea0:	68 07 04 00 00       	push   $0x407
  801ea5:	ff 75 f4             	pushl  -0xc(%ebp)
  801ea8:	6a 00                	push   $0x0
  801eaa:	e8 8f f1 ff ff       	call   80103e <sys_page_alloc>
  801eaf:	89 c3                	mov    %eax,%ebx
  801eb1:	83 c4 10             	add    $0x10,%esp
  801eb4:	85 c0                	test   %eax,%eax
  801eb6:	78 28                	js     801ee0 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801eb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ebb:	8b 15 40 30 80 00    	mov    0x803040,%edx
  801ec1:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801ec3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec6:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801ecd:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801ed0:	83 ec 0c             	sub    $0xc,%esp
  801ed3:	50                   	push   %eax
  801ed4:	e8 75 f3 ff ff       	call   80124e <fd2num>
  801ed9:	89 c3                	mov    %eax,%ebx
  801edb:	83 c4 10             	add    $0x10,%esp
  801ede:	eb 0c                	jmp    801eec <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801ee0:	83 ec 0c             	sub    $0xc,%esp
  801ee3:	56                   	push   %esi
  801ee4:	e8 e2 01 00 00       	call   8020cb <nsipc_close>
		return r;
  801ee9:	83 c4 10             	add    $0x10,%esp
}
  801eec:	89 d8                	mov    %ebx,%eax
  801eee:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ef1:	5b                   	pop    %ebx
  801ef2:	5e                   	pop    %esi
  801ef3:	5d                   	pop    %ebp
  801ef4:	c3                   	ret    

00801ef5 <accept>:
{
  801ef5:	55                   	push   %ebp
  801ef6:	89 e5                	mov    %esp,%ebp
  801ef8:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801efb:	8b 45 08             	mov    0x8(%ebp),%eax
  801efe:	e8 4e ff ff ff       	call   801e51 <fd2sockid>
  801f03:	85 c0                	test   %eax,%eax
  801f05:	78 1b                	js     801f22 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801f07:	83 ec 04             	sub    $0x4,%esp
  801f0a:	ff 75 10             	pushl  0x10(%ebp)
  801f0d:	ff 75 0c             	pushl  0xc(%ebp)
  801f10:	50                   	push   %eax
  801f11:	e8 0e 01 00 00       	call   802024 <nsipc_accept>
  801f16:	83 c4 10             	add    $0x10,%esp
  801f19:	85 c0                	test   %eax,%eax
  801f1b:	78 05                	js     801f22 <accept+0x2d>
	return alloc_sockfd(r);
  801f1d:	e8 5f ff ff ff       	call   801e81 <alloc_sockfd>
}
  801f22:	c9                   	leave  
  801f23:	c3                   	ret    

00801f24 <bind>:
{
  801f24:	55                   	push   %ebp
  801f25:	89 e5                	mov    %esp,%ebp
  801f27:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2d:	e8 1f ff ff ff       	call   801e51 <fd2sockid>
  801f32:	85 c0                	test   %eax,%eax
  801f34:	78 12                	js     801f48 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801f36:	83 ec 04             	sub    $0x4,%esp
  801f39:	ff 75 10             	pushl  0x10(%ebp)
  801f3c:	ff 75 0c             	pushl  0xc(%ebp)
  801f3f:	50                   	push   %eax
  801f40:	e8 2f 01 00 00       	call   802074 <nsipc_bind>
  801f45:	83 c4 10             	add    $0x10,%esp
}
  801f48:	c9                   	leave  
  801f49:	c3                   	ret    

00801f4a <shutdown>:
{
  801f4a:	55                   	push   %ebp
  801f4b:	89 e5                	mov    %esp,%ebp
  801f4d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f50:	8b 45 08             	mov    0x8(%ebp),%eax
  801f53:	e8 f9 fe ff ff       	call   801e51 <fd2sockid>
  801f58:	85 c0                	test   %eax,%eax
  801f5a:	78 0f                	js     801f6b <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801f5c:	83 ec 08             	sub    $0x8,%esp
  801f5f:	ff 75 0c             	pushl  0xc(%ebp)
  801f62:	50                   	push   %eax
  801f63:	e8 41 01 00 00       	call   8020a9 <nsipc_shutdown>
  801f68:	83 c4 10             	add    $0x10,%esp
}
  801f6b:	c9                   	leave  
  801f6c:	c3                   	ret    

00801f6d <connect>:
{
  801f6d:	55                   	push   %ebp
  801f6e:	89 e5                	mov    %esp,%ebp
  801f70:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f73:	8b 45 08             	mov    0x8(%ebp),%eax
  801f76:	e8 d6 fe ff ff       	call   801e51 <fd2sockid>
  801f7b:	85 c0                	test   %eax,%eax
  801f7d:	78 12                	js     801f91 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801f7f:	83 ec 04             	sub    $0x4,%esp
  801f82:	ff 75 10             	pushl  0x10(%ebp)
  801f85:	ff 75 0c             	pushl  0xc(%ebp)
  801f88:	50                   	push   %eax
  801f89:	e8 57 01 00 00       	call   8020e5 <nsipc_connect>
  801f8e:	83 c4 10             	add    $0x10,%esp
}
  801f91:	c9                   	leave  
  801f92:	c3                   	ret    

00801f93 <listen>:
{
  801f93:	55                   	push   %ebp
  801f94:	89 e5                	mov    %esp,%ebp
  801f96:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f99:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9c:	e8 b0 fe ff ff       	call   801e51 <fd2sockid>
  801fa1:	85 c0                	test   %eax,%eax
  801fa3:	78 0f                	js     801fb4 <listen+0x21>
	return nsipc_listen(r, backlog);
  801fa5:	83 ec 08             	sub    $0x8,%esp
  801fa8:	ff 75 0c             	pushl  0xc(%ebp)
  801fab:	50                   	push   %eax
  801fac:	e8 69 01 00 00       	call   80211a <nsipc_listen>
  801fb1:	83 c4 10             	add    $0x10,%esp
}
  801fb4:	c9                   	leave  
  801fb5:	c3                   	ret    

00801fb6 <socket>:

int
socket(int domain, int type, int protocol)
{
  801fb6:	55                   	push   %ebp
  801fb7:	89 e5                	mov    %esp,%ebp
  801fb9:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801fbc:	ff 75 10             	pushl  0x10(%ebp)
  801fbf:	ff 75 0c             	pushl  0xc(%ebp)
  801fc2:	ff 75 08             	pushl  0x8(%ebp)
  801fc5:	e8 3c 02 00 00       	call   802206 <nsipc_socket>
  801fca:	83 c4 10             	add    $0x10,%esp
  801fcd:	85 c0                	test   %eax,%eax
  801fcf:	78 05                	js     801fd6 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801fd1:	e8 ab fe ff ff       	call   801e81 <alloc_sockfd>
}
  801fd6:	c9                   	leave  
  801fd7:	c3                   	ret    

00801fd8 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801fd8:	55                   	push   %ebp
  801fd9:	89 e5                	mov    %esp,%ebp
  801fdb:	53                   	push   %ebx
  801fdc:	83 ec 04             	sub    $0x4,%esp
  801fdf:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801fe1:	83 3d 14 40 80 00 00 	cmpl   $0x0,0x804014
  801fe8:	74 26                	je     802010 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801fea:	6a 07                	push   $0x7
  801fec:	68 00 60 80 00       	push   $0x806000
  801ff1:	53                   	push   %ebx
  801ff2:	ff 35 14 40 80 00    	pushl  0x804014
  801ff8:	e8 5f 04 00 00       	call   80245c <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801ffd:	83 c4 0c             	add    $0xc,%esp
  802000:	6a 00                	push   $0x0
  802002:	6a 00                	push   $0x0
  802004:	6a 00                	push   $0x0
  802006:	e8 e8 03 00 00       	call   8023f3 <ipc_recv>
}
  80200b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80200e:	c9                   	leave  
  80200f:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802010:	83 ec 0c             	sub    $0xc,%esp
  802013:	6a 02                	push   $0x2
  802015:	e8 9b 04 00 00       	call   8024b5 <ipc_find_env>
  80201a:	a3 14 40 80 00       	mov    %eax,0x804014
  80201f:	83 c4 10             	add    $0x10,%esp
  802022:	eb c6                	jmp    801fea <nsipc+0x12>

00802024 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802024:	55                   	push   %ebp
  802025:	89 e5                	mov    %esp,%ebp
  802027:	56                   	push   %esi
  802028:	53                   	push   %ebx
  802029:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  80202c:	8b 45 08             	mov    0x8(%ebp),%eax
  80202f:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802034:	8b 06                	mov    (%esi),%eax
  802036:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80203b:	b8 01 00 00 00       	mov    $0x1,%eax
  802040:	e8 93 ff ff ff       	call   801fd8 <nsipc>
  802045:	89 c3                	mov    %eax,%ebx
  802047:	85 c0                	test   %eax,%eax
  802049:	78 20                	js     80206b <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80204b:	83 ec 04             	sub    $0x4,%esp
  80204e:	ff 35 10 60 80 00    	pushl  0x806010
  802054:	68 00 60 80 00       	push   $0x806000
  802059:	ff 75 0c             	pushl  0xc(%ebp)
  80205c:	e8 72 ed ff ff       	call   800dd3 <memmove>
		*addrlen = ret->ret_addrlen;
  802061:	a1 10 60 80 00       	mov    0x806010,%eax
  802066:	89 06                	mov    %eax,(%esi)
  802068:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  80206b:	89 d8                	mov    %ebx,%eax
  80206d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802070:	5b                   	pop    %ebx
  802071:	5e                   	pop    %esi
  802072:	5d                   	pop    %ebp
  802073:	c3                   	ret    

00802074 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802074:	55                   	push   %ebp
  802075:	89 e5                	mov    %esp,%ebp
  802077:	53                   	push   %ebx
  802078:	83 ec 08             	sub    $0x8,%esp
  80207b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  80207e:	8b 45 08             	mov    0x8(%ebp),%eax
  802081:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802086:	53                   	push   %ebx
  802087:	ff 75 0c             	pushl  0xc(%ebp)
  80208a:	68 04 60 80 00       	push   $0x806004
  80208f:	e8 3f ed ff ff       	call   800dd3 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802094:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  80209a:	b8 02 00 00 00       	mov    $0x2,%eax
  80209f:	e8 34 ff ff ff       	call   801fd8 <nsipc>
}
  8020a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020a7:	c9                   	leave  
  8020a8:	c3                   	ret    

008020a9 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8020a9:	55                   	push   %ebp
  8020aa:	89 e5                	mov    %esp,%ebp
  8020ac:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8020af:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b2:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  8020b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020ba:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  8020bf:	b8 03 00 00 00       	mov    $0x3,%eax
  8020c4:	e8 0f ff ff ff       	call   801fd8 <nsipc>
}
  8020c9:	c9                   	leave  
  8020ca:	c3                   	ret    

008020cb <nsipc_close>:

int
nsipc_close(int s)
{
  8020cb:	55                   	push   %ebp
  8020cc:	89 e5                	mov    %esp,%ebp
  8020ce:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8020d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d4:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  8020d9:	b8 04 00 00 00       	mov    $0x4,%eax
  8020de:	e8 f5 fe ff ff       	call   801fd8 <nsipc>
}
  8020e3:	c9                   	leave  
  8020e4:	c3                   	ret    

008020e5 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8020e5:	55                   	push   %ebp
  8020e6:	89 e5                	mov    %esp,%ebp
  8020e8:	53                   	push   %ebx
  8020e9:	83 ec 08             	sub    $0x8,%esp
  8020ec:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8020ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f2:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8020f7:	53                   	push   %ebx
  8020f8:	ff 75 0c             	pushl  0xc(%ebp)
  8020fb:	68 04 60 80 00       	push   $0x806004
  802100:	e8 ce ec ff ff       	call   800dd3 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802105:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  80210b:	b8 05 00 00 00       	mov    $0x5,%eax
  802110:	e8 c3 fe ff ff       	call   801fd8 <nsipc>
}
  802115:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802118:	c9                   	leave  
  802119:	c3                   	ret    

0080211a <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80211a:	55                   	push   %ebp
  80211b:	89 e5                	mov    %esp,%ebp
  80211d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802120:	8b 45 08             	mov    0x8(%ebp),%eax
  802123:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  802128:	8b 45 0c             	mov    0xc(%ebp),%eax
  80212b:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  802130:	b8 06 00 00 00       	mov    $0x6,%eax
  802135:	e8 9e fe ff ff       	call   801fd8 <nsipc>
}
  80213a:	c9                   	leave  
  80213b:	c3                   	ret    

0080213c <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80213c:	55                   	push   %ebp
  80213d:	89 e5                	mov    %esp,%ebp
  80213f:	56                   	push   %esi
  802140:	53                   	push   %ebx
  802141:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802144:	8b 45 08             	mov    0x8(%ebp),%eax
  802147:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  80214c:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  802152:	8b 45 14             	mov    0x14(%ebp),%eax
  802155:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80215a:	b8 07 00 00 00       	mov    $0x7,%eax
  80215f:	e8 74 fe ff ff       	call   801fd8 <nsipc>
  802164:	89 c3                	mov    %eax,%ebx
  802166:	85 c0                	test   %eax,%eax
  802168:	78 1f                	js     802189 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  80216a:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  80216f:	7f 21                	jg     802192 <nsipc_recv+0x56>
  802171:	39 c6                	cmp    %eax,%esi
  802173:	7c 1d                	jl     802192 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802175:	83 ec 04             	sub    $0x4,%esp
  802178:	50                   	push   %eax
  802179:	68 00 60 80 00       	push   $0x806000
  80217e:	ff 75 0c             	pushl  0xc(%ebp)
  802181:	e8 4d ec ff ff       	call   800dd3 <memmove>
  802186:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802189:	89 d8                	mov    %ebx,%eax
  80218b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80218e:	5b                   	pop    %ebx
  80218f:	5e                   	pop    %esi
  802190:	5d                   	pop    %ebp
  802191:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802192:	68 e7 2c 80 00       	push   $0x802ce7
  802197:	68 89 2c 80 00       	push   $0x802c89
  80219c:	6a 62                	push   $0x62
  80219e:	68 fc 2c 80 00       	push   $0x802cfc
  8021a3:	e8 05 02 00 00       	call   8023ad <_panic>

008021a8 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8021a8:	55                   	push   %ebp
  8021a9:	89 e5                	mov    %esp,%ebp
  8021ab:	53                   	push   %ebx
  8021ac:	83 ec 04             	sub    $0x4,%esp
  8021af:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8021b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b5:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  8021ba:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8021c0:	7f 2e                	jg     8021f0 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8021c2:	83 ec 04             	sub    $0x4,%esp
  8021c5:	53                   	push   %ebx
  8021c6:	ff 75 0c             	pushl  0xc(%ebp)
  8021c9:	68 0c 60 80 00       	push   $0x80600c
  8021ce:	e8 00 ec ff ff       	call   800dd3 <memmove>
	nsipcbuf.send.req_size = size;
  8021d3:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  8021d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8021dc:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  8021e1:	b8 08 00 00 00       	mov    $0x8,%eax
  8021e6:	e8 ed fd ff ff       	call   801fd8 <nsipc>
}
  8021eb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021ee:	c9                   	leave  
  8021ef:	c3                   	ret    
	assert(size < 1600);
  8021f0:	68 08 2d 80 00       	push   $0x802d08
  8021f5:	68 89 2c 80 00       	push   $0x802c89
  8021fa:	6a 6d                	push   $0x6d
  8021fc:	68 fc 2c 80 00       	push   $0x802cfc
  802201:	e8 a7 01 00 00       	call   8023ad <_panic>

00802206 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802206:	55                   	push   %ebp
  802207:	89 e5                	mov    %esp,%ebp
  802209:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80220c:	8b 45 08             	mov    0x8(%ebp),%eax
  80220f:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  802214:	8b 45 0c             	mov    0xc(%ebp),%eax
  802217:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  80221c:	8b 45 10             	mov    0x10(%ebp),%eax
  80221f:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  802224:	b8 09 00 00 00       	mov    $0x9,%eax
  802229:	e8 aa fd ff ff       	call   801fd8 <nsipc>
}
  80222e:	c9                   	leave  
  80222f:	c3                   	ret    

00802230 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802230:	55                   	push   %ebp
  802231:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802233:	b8 00 00 00 00       	mov    $0x0,%eax
  802238:	5d                   	pop    %ebp
  802239:	c3                   	ret    

0080223a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80223a:	55                   	push   %ebp
  80223b:	89 e5                	mov    %esp,%ebp
  80223d:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802240:	68 14 2d 80 00       	push   $0x802d14
  802245:	ff 75 0c             	pushl  0xc(%ebp)
  802248:	e8 f8 e9 ff ff       	call   800c45 <strcpy>
	return 0;
}
  80224d:	b8 00 00 00 00       	mov    $0x0,%eax
  802252:	c9                   	leave  
  802253:	c3                   	ret    

00802254 <devcons_write>:
{
  802254:	55                   	push   %ebp
  802255:	89 e5                	mov    %esp,%ebp
  802257:	57                   	push   %edi
  802258:	56                   	push   %esi
  802259:	53                   	push   %ebx
  80225a:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802260:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802265:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80226b:	eb 2f                	jmp    80229c <devcons_write+0x48>
		m = n - tot;
  80226d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802270:	29 f3                	sub    %esi,%ebx
  802272:	83 fb 7f             	cmp    $0x7f,%ebx
  802275:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80227a:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80227d:	83 ec 04             	sub    $0x4,%esp
  802280:	53                   	push   %ebx
  802281:	89 f0                	mov    %esi,%eax
  802283:	03 45 0c             	add    0xc(%ebp),%eax
  802286:	50                   	push   %eax
  802287:	57                   	push   %edi
  802288:	e8 46 eb ff ff       	call   800dd3 <memmove>
		sys_cputs(buf, m);
  80228d:	83 c4 08             	add    $0x8,%esp
  802290:	53                   	push   %ebx
  802291:	57                   	push   %edi
  802292:	e8 eb ec ff ff       	call   800f82 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802297:	01 de                	add    %ebx,%esi
  802299:	83 c4 10             	add    $0x10,%esp
  80229c:	3b 75 10             	cmp    0x10(%ebp),%esi
  80229f:	72 cc                	jb     80226d <devcons_write+0x19>
}
  8022a1:	89 f0                	mov    %esi,%eax
  8022a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022a6:	5b                   	pop    %ebx
  8022a7:	5e                   	pop    %esi
  8022a8:	5f                   	pop    %edi
  8022a9:	5d                   	pop    %ebp
  8022aa:	c3                   	ret    

008022ab <devcons_read>:
{
  8022ab:	55                   	push   %ebp
  8022ac:	89 e5                	mov    %esp,%ebp
  8022ae:	83 ec 08             	sub    $0x8,%esp
  8022b1:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8022b6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8022ba:	75 07                	jne    8022c3 <devcons_read+0x18>
}
  8022bc:	c9                   	leave  
  8022bd:	c3                   	ret    
		sys_yield();
  8022be:	e8 5c ed ff ff       	call   80101f <sys_yield>
	while ((c = sys_cgetc()) == 0)
  8022c3:	e8 d8 ec ff ff       	call   800fa0 <sys_cgetc>
  8022c8:	85 c0                	test   %eax,%eax
  8022ca:	74 f2                	je     8022be <devcons_read+0x13>
	if (c < 0)
  8022cc:	85 c0                	test   %eax,%eax
  8022ce:	78 ec                	js     8022bc <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  8022d0:	83 f8 04             	cmp    $0x4,%eax
  8022d3:	74 0c                	je     8022e1 <devcons_read+0x36>
	*(char*)vbuf = c;
  8022d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022d8:	88 02                	mov    %al,(%edx)
	return 1;
  8022da:	b8 01 00 00 00       	mov    $0x1,%eax
  8022df:	eb db                	jmp    8022bc <devcons_read+0x11>
		return 0;
  8022e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8022e6:	eb d4                	jmp    8022bc <devcons_read+0x11>

008022e8 <cputchar>:
{
  8022e8:	55                   	push   %ebp
  8022e9:	89 e5                	mov    %esp,%ebp
  8022eb:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8022ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f1:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8022f4:	6a 01                	push   $0x1
  8022f6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8022f9:	50                   	push   %eax
  8022fa:	e8 83 ec ff ff       	call   800f82 <sys_cputs>
}
  8022ff:	83 c4 10             	add    $0x10,%esp
  802302:	c9                   	leave  
  802303:	c3                   	ret    

00802304 <getchar>:
{
  802304:	55                   	push   %ebp
  802305:	89 e5                	mov    %esp,%ebp
  802307:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80230a:	6a 01                	push   $0x1
  80230c:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80230f:	50                   	push   %eax
  802310:	6a 00                	push   $0x0
  802312:	e8 1e f2 ff ff       	call   801535 <read>
	if (r < 0)
  802317:	83 c4 10             	add    $0x10,%esp
  80231a:	85 c0                	test   %eax,%eax
  80231c:	78 08                	js     802326 <getchar+0x22>
	if (r < 1)
  80231e:	85 c0                	test   %eax,%eax
  802320:	7e 06                	jle    802328 <getchar+0x24>
	return c;
  802322:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802326:	c9                   	leave  
  802327:	c3                   	ret    
		return -E_EOF;
  802328:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80232d:	eb f7                	jmp    802326 <getchar+0x22>

0080232f <iscons>:
{
  80232f:	55                   	push   %ebp
  802330:	89 e5                	mov    %esp,%ebp
  802332:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802335:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802338:	50                   	push   %eax
  802339:	ff 75 08             	pushl  0x8(%ebp)
  80233c:	e8 83 ef ff ff       	call   8012c4 <fd_lookup>
  802341:	83 c4 10             	add    $0x10,%esp
  802344:	85 c0                	test   %eax,%eax
  802346:	78 11                	js     802359 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802348:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234b:	8b 15 5c 30 80 00    	mov    0x80305c,%edx
  802351:	39 10                	cmp    %edx,(%eax)
  802353:	0f 94 c0             	sete   %al
  802356:	0f b6 c0             	movzbl %al,%eax
}
  802359:	c9                   	leave  
  80235a:	c3                   	ret    

0080235b <opencons>:
{
  80235b:	55                   	push   %ebp
  80235c:	89 e5                	mov    %esp,%ebp
  80235e:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802361:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802364:	50                   	push   %eax
  802365:	e8 0b ef ff ff       	call   801275 <fd_alloc>
  80236a:	83 c4 10             	add    $0x10,%esp
  80236d:	85 c0                	test   %eax,%eax
  80236f:	78 3a                	js     8023ab <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802371:	83 ec 04             	sub    $0x4,%esp
  802374:	68 07 04 00 00       	push   $0x407
  802379:	ff 75 f4             	pushl  -0xc(%ebp)
  80237c:	6a 00                	push   $0x0
  80237e:	e8 bb ec ff ff       	call   80103e <sys_page_alloc>
  802383:	83 c4 10             	add    $0x10,%esp
  802386:	85 c0                	test   %eax,%eax
  802388:	78 21                	js     8023ab <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80238a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238d:	8b 15 5c 30 80 00    	mov    0x80305c,%edx
  802393:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802395:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802398:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80239f:	83 ec 0c             	sub    $0xc,%esp
  8023a2:	50                   	push   %eax
  8023a3:	e8 a6 ee ff ff       	call   80124e <fd2num>
  8023a8:	83 c4 10             	add    $0x10,%esp
}
  8023ab:	c9                   	leave  
  8023ac:	c3                   	ret    

008023ad <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8023ad:	55                   	push   %ebp
  8023ae:	89 e5                	mov    %esp,%ebp
  8023b0:	56                   	push   %esi
  8023b1:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8023b2:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8023b5:	8b 35 04 30 80 00    	mov    0x803004,%esi
  8023bb:	e8 40 ec ff ff       	call   801000 <sys_getenvid>
  8023c0:	83 ec 0c             	sub    $0xc,%esp
  8023c3:	ff 75 0c             	pushl  0xc(%ebp)
  8023c6:	ff 75 08             	pushl  0x8(%ebp)
  8023c9:	56                   	push   %esi
  8023ca:	50                   	push   %eax
  8023cb:	68 20 2d 80 00       	push   $0x802d20
  8023d0:	e8 d3 e1 ff ff       	call   8005a8 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8023d5:	83 c4 18             	add    $0x18,%esp
  8023d8:	53                   	push   %ebx
  8023d9:	ff 75 10             	pushl  0x10(%ebp)
  8023dc:	e8 76 e1 ff ff       	call   800557 <vcprintf>
	cprintf("\n");
  8023e1:	c7 04 24 34 28 80 00 	movl   $0x802834,(%esp)
  8023e8:	e8 bb e1 ff ff       	call   8005a8 <cprintf>
  8023ed:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8023f0:	cc                   	int3   
  8023f1:	eb fd                	jmp    8023f0 <_panic+0x43>

008023f3 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8023f3:	55                   	push   %ebp
  8023f4:	89 e5                	mov    %esp,%ebp
  8023f6:	56                   	push   %esi
  8023f7:	53                   	push   %ebx
  8023f8:	8b 75 08             	mov    0x8(%ebp),%esi
  8023fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023fe:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
  802401:	85 c0                	test   %eax,%eax
	    pg = (void *)UTOP;
  802403:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802408:	0f 44 c2             	cmove  %edx,%eax
	}
	if ((r = sys_ipc_recv(pg)) < 0) {
  80240b:	83 ec 0c             	sub    $0xc,%esp
  80240e:	50                   	push   %eax
  80240f:	e8 da ed ff ff       	call   8011ee <sys_ipc_recv>
  802414:	83 c4 10             	add    $0x10,%esp
  802417:	85 c0                	test   %eax,%eax
  802419:	78 2b                	js     802446 <ipc_recv+0x53>
	    if (perm_store != NULL) {
	        *perm_store = 0;
	    }
	    return r;
	}
	if (from_env_store != NULL) {
  80241b:	85 f6                	test   %esi,%esi
  80241d:	74 0a                	je     802429 <ipc_recv+0x36>
	    *from_env_store = thisenv->env_ipc_from;
  80241f:	a1 18 40 80 00       	mov    0x804018,%eax
  802424:	8b 40 74             	mov    0x74(%eax),%eax
  802427:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store != NULL) {
  802429:	85 db                	test   %ebx,%ebx
  80242b:	74 0a                	je     802437 <ipc_recv+0x44>
	    *perm_store = thisenv->env_ipc_perm;
  80242d:	a1 18 40 80 00       	mov    0x804018,%eax
  802432:	8b 40 78             	mov    0x78(%eax),%eax
  802435:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  802437:	a1 18 40 80 00       	mov    0x804018,%eax
  80243c:	8b 40 70             	mov    0x70(%eax),%eax
}
  80243f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802442:	5b                   	pop    %ebx
  802443:	5e                   	pop    %esi
  802444:	5d                   	pop    %ebp
  802445:	c3                   	ret    
	    if (from_env_store != NULL) {
  802446:	85 f6                	test   %esi,%esi
  802448:	74 06                	je     802450 <ipc_recv+0x5d>
	        *from_env_store = 0;
  80244a:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	    if (perm_store != NULL) {
  802450:	85 db                	test   %ebx,%ebx
  802452:	74 eb                	je     80243f <ipc_recv+0x4c>
	        *perm_store = 0;
  802454:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80245a:	eb e3                	jmp    80243f <ipc_recv+0x4c>

0080245c <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80245c:	55                   	push   %ebp
  80245d:	89 e5                	mov    %esp,%ebp
  80245f:	57                   	push   %edi
  802460:	56                   	push   %esi
  802461:	53                   	push   %ebx
  802462:	83 ec 0c             	sub    $0xc,%esp
  802465:	8b 7d 08             	mov    0x8(%ebp),%edi
  802468:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
	    pg = (void *)UTOP;
  80246b:	85 f6                	test   %esi,%esi
  80246d:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802472:	0f 44 f0             	cmove  %eax,%esi
  802475:	eb 09                	jmp    802480 <ipc_send+0x24>
	do {
	    r = sys_ipc_try_send(to_env, val, pg, perm);
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
	        panic("ipc_send: %e", r);
	    }
	    sys_yield();
  802477:	e8 a3 eb ff ff       	call   80101f <sys_yield>
	} while(r != 0);
  80247c:	85 db                	test   %ebx,%ebx
  80247e:	74 2d                	je     8024ad <ipc_send+0x51>
	    r = sys_ipc_try_send(to_env, val, pg, perm);
  802480:	ff 75 14             	pushl  0x14(%ebp)
  802483:	56                   	push   %esi
  802484:	ff 75 0c             	pushl  0xc(%ebp)
  802487:	57                   	push   %edi
  802488:	e8 3e ed ff ff       	call   8011cb <sys_ipc_try_send>
  80248d:	89 c3                	mov    %eax,%ebx
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
  80248f:	83 c4 10             	add    $0x10,%esp
  802492:	85 c0                	test   %eax,%eax
  802494:	79 e1                	jns    802477 <ipc_send+0x1b>
  802496:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802499:	74 dc                	je     802477 <ipc_send+0x1b>
	        panic("ipc_send: %e", r);
  80249b:	50                   	push   %eax
  80249c:	68 44 2d 80 00       	push   $0x802d44
  8024a1:	6a 45                	push   $0x45
  8024a3:	68 51 2d 80 00       	push   $0x802d51
  8024a8:	e8 00 ff ff ff       	call   8023ad <_panic>
}
  8024ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024b0:	5b                   	pop    %ebx
  8024b1:	5e                   	pop    %esi
  8024b2:	5f                   	pop    %edi
  8024b3:	5d                   	pop    %ebp
  8024b4:	c3                   	ret    

008024b5 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8024b5:	55                   	push   %ebp
  8024b6:	89 e5                	mov    %esp,%ebp
  8024b8:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8024bb:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8024c0:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8024c3:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8024c9:	8b 52 50             	mov    0x50(%edx),%edx
  8024cc:	39 ca                	cmp    %ecx,%edx
  8024ce:	74 11                	je     8024e1 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  8024d0:	83 c0 01             	add    $0x1,%eax
  8024d3:	3d 00 04 00 00       	cmp    $0x400,%eax
  8024d8:	75 e6                	jne    8024c0 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8024da:	b8 00 00 00 00       	mov    $0x0,%eax
  8024df:	eb 0b                	jmp    8024ec <ipc_find_env+0x37>
			return envs[i].env_id;
  8024e1:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8024e4:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8024e9:	8b 40 48             	mov    0x48(%eax),%eax
}
  8024ec:	5d                   	pop    %ebp
  8024ed:	c3                   	ret    

008024ee <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8024ee:	55                   	push   %ebp
  8024ef:	89 e5                	mov    %esp,%ebp
  8024f1:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8024f4:	89 d0                	mov    %edx,%eax
  8024f6:	c1 e8 16             	shr    $0x16,%eax
  8024f9:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802500:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802505:	f6 c1 01             	test   $0x1,%cl
  802508:	74 1d                	je     802527 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80250a:	c1 ea 0c             	shr    $0xc,%edx
  80250d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802514:	f6 c2 01             	test   $0x1,%dl
  802517:	74 0e                	je     802527 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802519:	c1 ea 0c             	shr    $0xc,%edx
  80251c:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802523:	ef 
  802524:	0f b7 c0             	movzwl %ax,%eax
}
  802527:	5d                   	pop    %ebp
  802528:	c3                   	ret    
  802529:	66 90                	xchg   %ax,%ax
  80252b:	66 90                	xchg   %ax,%ax
  80252d:	66 90                	xchg   %ax,%ax
  80252f:	90                   	nop

00802530 <__udivdi3>:
  802530:	55                   	push   %ebp
  802531:	57                   	push   %edi
  802532:	56                   	push   %esi
  802533:	53                   	push   %ebx
  802534:	83 ec 1c             	sub    $0x1c,%esp
  802537:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80253b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80253f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802543:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802547:	85 d2                	test   %edx,%edx
  802549:	75 35                	jne    802580 <__udivdi3+0x50>
  80254b:	39 f3                	cmp    %esi,%ebx
  80254d:	0f 87 bd 00 00 00    	ja     802610 <__udivdi3+0xe0>
  802553:	85 db                	test   %ebx,%ebx
  802555:	89 d9                	mov    %ebx,%ecx
  802557:	75 0b                	jne    802564 <__udivdi3+0x34>
  802559:	b8 01 00 00 00       	mov    $0x1,%eax
  80255e:	31 d2                	xor    %edx,%edx
  802560:	f7 f3                	div    %ebx
  802562:	89 c1                	mov    %eax,%ecx
  802564:	31 d2                	xor    %edx,%edx
  802566:	89 f0                	mov    %esi,%eax
  802568:	f7 f1                	div    %ecx
  80256a:	89 c6                	mov    %eax,%esi
  80256c:	89 e8                	mov    %ebp,%eax
  80256e:	89 f7                	mov    %esi,%edi
  802570:	f7 f1                	div    %ecx
  802572:	89 fa                	mov    %edi,%edx
  802574:	83 c4 1c             	add    $0x1c,%esp
  802577:	5b                   	pop    %ebx
  802578:	5e                   	pop    %esi
  802579:	5f                   	pop    %edi
  80257a:	5d                   	pop    %ebp
  80257b:	c3                   	ret    
  80257c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802580:	39 f2                	cmp    %esi,%edx
  802582:	77 7c                	ja     802600 <__udivdi3+0xd0>
  802584:	0f bd fa             	bsr    %edx,%edi
  802587:	83 f7 1f             	xor    $0x1f,%edi
  80258a:	0f 84 98 00 00 00    	je     802628 <__udivdi3+0xf8>
  802590:	89 f9                	mov    %edi,%ecx
  802592:	b8 20 00 00 00       	mov    $0x20,%eax
  802597:	29 f8                	sub    %edi,%eax
  802599:	d3 e2                	shl    %cl,%edx
  80259b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80259f:	89 c1                	mov    %eax,%ecx
  8025a1:	89 da                	mov    %ebx,%edx
  8025a3:	d3 ea                	shr    %cl,%edx
  8025a5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8025a9:	09 d1                	or     %edx,%ecx
  8025ab:	89 f2                	mov    %esi,%edx
  8025ad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8025b1:	89 f9                	mov    %edi,%ecx
  8025b3:	d3 e3                	shl    %cl,%ebx
  8025b5:	89 c1                	mov    %eax,%ecx
  8025b7:	d3 ea                	shr    %cl,%edx
  8025b9:	89 f9                	mov    %edi,%ecx
  8025bb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8025bf:	d3 e6                	shl    %cl,%esi
  8025c1:	89 eb                	mov    %ebp,%ebx
  8025c3:	89 c1                	mov    %eax,%ecx
  8025c5:	d3 eb                	shr    %cl,%ebx
  8025c7:	09 de                	or     %ebx,%esi
  8025c9:	89 f0                	mov    %esi,%eax
  8025cb:	f7 74 24 08          	divl   0x8(%esp)
  8025cf:	89 d6                	mov    %edx,%esi
  8025d1:	89 c3                	mov    %eax,%ebx
  8025d3:	f7 64 24 0c          	mull   0xc(%esp)
  8025d7:	39 d6                	cmp    %edx,%esi
  8025d9:	72 0c                	jb     8025e7 <__udivdi3+0xb7>
  8025db:	89 f9                	mov    %edi,%ecx
  8025dd:	d3 e5                	shl    %cl,%ebp
  8025df:	39 c5                	cmp    %eax,%ebp
  8025e1:	73 5d                	jae    802640 <__udivdi3+0x110>
  8025e3:	39 d6                	cmp    %edx,%esi
  8025e5:	75 59                	jne    802640 <__udivdi3+0x110>
  8025e7:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8025ea:	31 ff                	xor    %edi,%edi
  8025ec:	89 fa                	mov    %edi,%edx
  8025ee:	83 c4 1c             	add    $0x1c,%esp
  8025f1:	5b                   	pop    %ebx
  8025f2:	5e                   	pop    %esi
  8025f3:	5f                   	pop    %edi
  8025f4:	5d                   	pop    %ebp
  8025f5:	c3                   	ret    
  8025f6:	8d 76 00             	lea    0x0(%esi),%esi
  8025f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  802600:	31 ff                	xor    %edi,%edi
  802602:	31 c0                	xor    %eax,%eax
  802604:	89 fa                	mov    %edi,%edx
  802606:	83 c4 1c             	add    $0x1c,%esp
  802609:	5b                   	pop    %ebx
  80260a:	5e                   	pop    %esi
  80260b:	5f                   	pop    %edi
  80260c:	5d                   	pop    %ebp
  80260d:	c3                   	ret    
  80260e:	66 90                	xchg   %ax,%ax
  802610:	31 ff                	xor    %edi,%edi
  802612:	89 e8                	mov    %ebp,%eax
  802614:	89 f2                	mov    %esi,%edx
  802616:	f7 f3                	div    %ebx
  802618:	89 fa                	mov    %edi,%edx
  80261a:	83 c4 1c             	add    $0x1c,%esp
  80261d:	5b                   	pop    %ebx
  80261e:	5e                   	pop    %esi
  80261f:	5f                   	pop    %edi
  802620:	5d                   	pop    %ebp
  802621:	c3                   	ret    
  802622:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802628:	39 f2                	cmp    %esi,%edx
  80262a:	72 06                	jb     802632 <__udivdi3+0x102>
  80262c:	31 c0                	xor    %eax,%eax
  80262e:	39 eb                	cmp    %ebp,%ebx
  802630:	77 d2                	ja     802604 <__udivdi3+0xd4>
  802632:	b8 01 00 00 00       	mov    $0x1,%eax
  802637:	eb cb                	jmp    802604 <__udivdi3+0xd4>
  802639:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802640:	89 d8                	mov    %ebx,%eax
  802642:	31 ff                	xor    %edi,%edi
  802644:	eb be                	jmp    802604 <__udivdi3+0xd4>
  802646:	66 90                	xchg   %ax,%ax
  802648:	66 90                	xchg   %ax,%ax
  80264a:	66 90                	xchg   %ax,%ax
  80264c:	66 90                	xchg   %ax,%ax
  80264e:	66 90                	xchg   %ax,%ax

00802650 <__umoddi3>:
  802650:	55                   	push   %ebp
  802651:	57                   	push   %edi
  802652:	56                   	push   %esi
  802653:	53                   	push   %ebx
  802654:	83 ec 1c             	sub    $0x1c,%esp
  802657:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  80265b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80265f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802663:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802667:	85 ed                	test   %ebp,%ebp
  802669:	89 f0                	mov    %esi,%eax
  80266b:	89 da                	mov    %ebx,%edx
  80266d:	75 19                	jne    802688 <__umoddi3+0x38>
  80266f:	39 df                	cmp    %ebx,%edi
  802671:	0f 86 b1 00 00 00    	jbe    802728 <__umoddi3+0xd8>
  802677:	f7 f7                	div    %edi
  802679:	89 d0                	mov    %edx,%eax
  80267b:	31 d2                	xor    %edx,%edx
  80267d:	83 c4 1c             	add    $0x1c,%esp
  802680:	5b                   	pop    %ebx
  802681:	5e                   	pop    %esi
  802682:	5f                   	pop    %edi
  802683:	5d                   	pop    %ebp
  802684:	c3                   	ret    
  802685:	8d 76 00             	lea    0x0(%esi),%esi
  802688:	39 dd                	cmp    %ebx,%ebp
  80268a:	77 f1                	ja     80267d <__umoddi3+0x2d>
  80268c:	0f bd cd             	bsr    %ebp,%ecx
  80268f:	83 f1 1f             	xor    $0x1f,%ecx
  802692:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802696:	0f 84 b4 00 00 00    	je     802750 <__umoddi3+0x100>
  80269c:	b8 20 00 00 00       	mov    $0x20,%eax
  8026a1:	89 c2                	mov    %eax,%edx
  8026a3:	8b 44 24 04          	mov    0x4(%esp),%eax
  8026a7:	29 c2                	sub    %eax,%edx
  8026a9:	89 c1                	mov    %eax,%ecx
  8026ab:	89 f8                	mov    %edi,%eax
  8026ad:	d3 e5                	shl    %cl,%ebp
  8026af:	89 d1                	mov    %edx,%ecx
  8026b1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8026b5:	d3 e8                	shr    %cl,%eax
  8026b7:	09 c5                	or     %eax,%ebp
  8026b9:	8b 44 24 04          	mov    0x4(%esp),%eax
  8026bd:	89 c1                	mov    %eax,%ecx
  8026bf:	d3 e7                	shl    %cl,%edi
  8026c1:	89 d1                	mov    %edx,%ecx
  8026c3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8026c7:	89 df                	mov    %ebx,%edi
  8026c9:	d3 ef                	shr    %cl,%edi
  8026cb:	89 c1                	mov    %eax,%ecx
  8026cd:	89 f0                	mov    %esi,%eax
  8026cf:	d3 e3                	shl    %cl,%ebx
  8026d1:	89 d1                	mov    %edx,%ecx
  8026d3:	89 fa                	mov    %edi,%edx
  8026d5:	d3 e8                	shr    %cl,%eax
  8026d7:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8026dc:	09 d8                	or     %ebx,%eax
  8026de:	f7 f5                	div    %ebp
  8026e0:	d3 e6                	shl    %cl,%esi
  8026e2:	89 d1                	mov    %edx,%ecx
  8026e4:	f7 64 24 08          	mull   0x8(%esp)
  8026e8:	39 d1                	cmp    %edx,%ecx
  8026ea:	89 c3                	mov    %eax,%ebx
  8026ec:	89 d7                	mov    %edx,%edi
  8026ee:	72 06                	jb     8026f6 <__umoddi3+0xa6>
  8026f0:	75 0e                	jne    802700 <__umoddi3+0xb0>
  8026f2:	39 c6                	cmp    %eax,%esi
  8026f4:	73 0a                	jae    802700 <__umoddi3+0xb0>
  8026f6:	2b 44 24 08          	sub    0x8(%esp),%eax
  8026fa:	19 ea                	sbb    %ebp,%edx
  8026fc:	89 d7                	mov    %edx,%edi
  8026fe:	89 c3                	mov    %eax,%ebx
  802700:	89 ca                	mov    %ecx,%edx
  802702:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  802707:	29 de                	sub    %ebx,%esi
  802709:	19 fa                	sbb    %edi,%edx
  80270b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  80270f:	89 d0                	mov    %edx,%eax
  802711:	d3 e0                	shl    %cl,%eax
  802713:	89 d9                	mov    %ebx,%ecx
  802715:	d3 ee                	shr    %cl,%esi
  802717:	d3 ea                	shr    %cl,%edx
  802719:	09 f0                	or     %esi,%eax
  80271b:	83 c4 1c             	add    $0x1c,%esp
  80271e:	5b                   	pop    %ebx
  80271f:	5e                   	pop    %esi
  802720:	5f                   	pop    %edi
  802721:	5d                   	pop    %ebp
  802722:	c3                   	ret    
  802723:	90                   	nop
  802724:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802728:	85 ff                	test   %edi,%edi
  80272a:	89 f9                	mov    %edi,%ecx
  80272c:	75 0b                	jne    802739 <__umoddi3+0xe9>
  80272e:	b8 01 00 00 00       	mov    $0x1,%eax
  802733:	31 d2                	xor    %edx,%edx
  802735:	f7 f7                	div    %edi
  802737:	89 c1                	mov    %eax,%ecx
  802739:	89 d8                	mov    %ebx,%eax
  80273b:	31 d2                	xor    %edx,%edx
  80273d:	f7 f1                	div    %ecx
  80273f:	89 f0                	mov    %esi,%eax
  802741:	f7 f1                	div    %ecx
  802743:	e9 31 ff ff ff       	jmp    802679 <__umoddi3+0x29>
  802748:	90                   	nop
  802749:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802750:	39 dd                	cmp    %ebx,%ebp
  802752:	72 08                	jb     80275c <__umoddi3+0x10c>
  802754:	39 f7                	cmp    %esi,%edi
  802756:	0f 87 21 ff ff ff    	ja     80267d <__umoddi3+0x2d>
  80275c:	89 da                	mov    %ebx,%edx
  80275e:	89 f0                	mov    %esi,%eax
  802760:	29 f8                	sub    %edi,%eax
  802762:	19 ea                	sbb    %ebp,%edx
  802764:	e9 14 ff ff ff       	jmp    80267d <__umoddi3+0x2d>
