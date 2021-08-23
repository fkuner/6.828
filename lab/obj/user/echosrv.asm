
obj/user/echosrv.debug:     file format elf32-i386


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
  80002c:	e8 a0 04 00 00       	call   8004d1 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <die>:
#define BUFFSIZE 32
#define MAXPENDING 5    // Max connection requests

static void
die(char *m)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	cprintf("%s\n", m);
  800039:	50                   	push   %eax
  80003a:	68 f0 27 80 00       	push   $0x8027f0
  80003f:	e8 82 05 00 00       	call   8005c6 <cprintf>
	exit();
  800044:	e8 ce 04 00 00       	call   800517 <exit>
}
  800049:	83 c4 10             	add    $0x10,%esp
  80004c:	c9                   	leave  
  80004d:	c3                   	ret    

0080004e <handle_client>:

void
handle_client(int sock)
{
  80004e:	55                   	push   %ebp
  80004f:	89 e5                	mov    %esp,%ebp
  800051:	57                   	push   %edi
  800052:	56                   	push   %esi
  800053:	53                   	push   %ebx
  800054:	83 ec 30             	sub    $0x30,%esp
  800057:	8b 75 08             	mov    0x8(%ebp),%esi
	char buffer[BUFFSIZE];
	int received = -1;
	// Receive message
	if ((received = read(sock, buffer, BUFFSIZE)) < 0)
  80005a:	6a 20                	push   $0x20
  80005c:	8d 45 c8             	lea    -0x38(%ebp),%eax
  80005f:	50                   	push   %eax
  800060:	56                   	push   %esi
  800061:	e8 ed 14 00 00       	call   801553 <read>
  800066:	89 c3                	mov    %eax,%ebx
  800068:	83 c4 10             	add    $0x10,%esp
  80006b:	85 c0                	test   %eax,%eax
  80006d:	78 05                	js     800074 <handle_client+0x26>
		die("Failed to receive initial bytes from client");

	// Send bytes and check for more incoming data in loop
	while (received > 0) {
		// Send back received data
		if (write(sock, buffer, received) != received)
  80006f:	8d 7d c8             	lea    -0x38(%ebp),%edi
  800072:	eb 21                	jmp    800095 <handle_client+0x47>
		die("Failed to receive initial bytes from client");
  800074:	b8 f4 27 80 00       	mov    $0x8027f4,%eax
  800079:	e8 b5 ff ff ff       	call   800033 <die>
  80007e:	eb ef                	jmp    80006f <handle_client+0x21>
			die("Failed to send bytes to client");

		// Check for more data
		if ((received = read(sock, buffer, BUFFSIZE)) < 0)
  800080:	83 ec 04             	sub    $0x4,%esp
  800083:	6a 20                	push   $0x20
  800085:	57                   	push   %edi
  800086:	56                   	push   %esi
  800087:	e8 c7 14 00 00       	call   801553 <read>
  80008c:	89 c3                	mov    %eax,%ebx
  80008e:	83 c4 10             	add    $0x10,%esp
  800091:	85 c0                	test   %eax,%eax
  800093:	78 22                	js     8000b7 <handle_client+0x69>
	while (received > 0) {
  800095:	85 db                	test   %ebx,%ebx
  800097:	7e 2a                	jle    8000c3 <handle_client+0x75>
		if (write(sock, buffer, received) != received)
  800099:	83 ec 04             	sub    $0x4,%esp
  80009c:	53                   	push   %ebx
  80009d:	57                   	push   %edi
  80009e:	56                   	push   %esi
  80009f:	e8 7d 15 00 00       	call   801621 <write>
  8000a4:	83 c4 10             	add    $0x10,%esp
  8000a7:	39 d8                	cmp    %ebx,%eax
  8000a9:	74 d5                	je     800080 <handle_client+0x32>
			die("Failed to send bytes to client");
  8000ab:	b8 20 28 80 00       	mov    $0x802820,%eax
  8000b0:	e8 7e ff ff ff       	call   800033 <die>
  8000b5:	eb c9                	jmp    800080 <handle_client+0x32>
			die("Failed to receive additional bytes from client");
  8000b7:	b8 40 28 80 00       	mov    $0x802840,%eax
  8000bc:	e8 72 ff ff ff       	call   800033 <die>
  8000c1:	eb d2                	jmp    800095 <handle_client+0x47>
	}
	close(sock);
  8000c3:	83 ec 0c             	sub    $0xc,%esp
  8000c6:	56                   	push   %esi
  8000c7:	e8 4b 13 00 00       	call   801417 <close>
}
  8000cc:	83 c4 10             	add    $0x10,%esp
  8000cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000d2:	5b                   	pop    %ebx
  8000d3:	5e                   	pop    %esi
  8000d4:	5f                   	pop    %edi
  8000d5:	5d                   	pop    %ebp
  8000d6:	c3                   	ret    

008000d7 <umain>:

void
umain(int argc, char **argv)
{
  8000d7:	55                   	push   %ebp
  8000d8:	89 e5                	mov    %esp,%ebp
  8000da:	57                   	push   %edi
  8000db:	56                   	push   %esi
  8000dc:	53                   	push   %ebx
  8000dd:	83 ec 40             	sub    $0x40,%esp
	char buffer[BUFFSIZE];
	unsigned int echolen;
	int received = 0;

	// Create the TCP socket
	if ((serversock = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0)
  8000e0:	6a 06                	push   $0x6
  8000e2:	6a 01                	push   $0x1
  8000e4:	6a 02                	push   $0x2
  8000e6:	e8 e9 1e 00 00       	call   801fd4 <socket>
  8000eb:	89 c6                	mov    %eax,%esi
  8000ed:	83 c4 10             	add    $0x10,%esp
  8000f0:	85 c0                	test   %eax,%eax
  8000f2:	0f 88 86 00 00 00    	js     80017e <umain+0xa7>
		die("Failed to create socket");

	cprintf("opened socket\n");
  8000f8:	83 ec 0c             	sub    $0xc,%esp
  8000fb:	68 b8 27 80 00       	push   $0x8027b8
  800100:	e8 c1 04 00 00       	call   8005c6 <cprintf>

	// Construct the server sockaddr_in structure
	memset(&echoserver, 0, sizeof(echoserver));       // Clear struct
  800105:	83 c4 0c             	add    $0xc,%esp
  800108:	6a 10                	push   $0x10
  80010a:	6a 00                	push   $0x0
  80010c:	8d 5d d8             	lea    -0x28(%ebp),%ebx
  80010f:	53                   	push   %ebx
  800110:	e8 8f 0c 00 00       	call   800da4 <memset>
	echoserver.sin_family = AF_INET;                  // Internet/IP
  800115:	c6 45 d9 02          	movb   $0x2,-0x27(%ebp)
	echoserver.sin_addr.s_addr = htonl(INADDR_ANY);   // IP address
  800119:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800120:	e8 7e 01 00 00       	call   8002a3 <htonl>
  800125:	89 45 dc             	mov    %eax,-0x24(%ebp)
	echoserver.sin_port = htons(PORT);		  // server port
  800128:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  80012f:	e8 55 01 00 00       	call   800289 <htons>
  800134:	66 89 45 da          	mov    %ax,-0x26(%ebp)

	cprintf("trying to bind\n");
  800138:	c7 04 24 c7 27 80 00 	movl   $0x8027c7,(%esp)
  80013f:	e8 82 04 00 00       	call   8005c6 <cprintf>

	// Bind the server socket
	if (bind(serversock, (struct sockaddr *) &echoserver,
  800144:	83 c4 0c             	add    $0xc,%esp
  800147:	6a 10                	push   $0x10
  800149:	53                   	push   %ebx
  80014a:	56                   	push   %esi
  80014b:	e8 f2 1d 00 00       	call   801f42 <bind>
  800150:	83 c4 10             	add    $0x10,%esp
  800153:	85 c0                	test   %eax,%eax
  800155:	78 36                	js     80018d <umain+0xb6>
		 sizeof(echoserver)) < 0) {
		die("Failed to bind the server socket");
	}

	// Listen on the server socket
	if (listen(serversock, MAXPENDING) < 0)
  800157:	83 ec 08             	sub    $0x8,%esp
  80015a:	6a 05                	push   $0x5
  80015c:	56                   	push   %esi
  80015d:	e8 4f 1e 00 00       	call   801fb1 <listen>
  800162:	83 c4 10             	add    $0x10,%esp
  800165:	85 c0                	test   %eax,%eax
  800167:	78 30                	js     800199 <umain+0xc2>
		die("Failed to listen on server socket");

	cprintf("bound\n");
  800169:	83 ec 0c             	sub    $0xc,%esp
  80016c:	68 d7 27 80 00       	push   $0x8027d7
  800171:	e8 50 04 00 00       	call   8005c6 <cprintf>
  800176:	83 c4 10             	add    $0x10,%esp

	// Run until canceled
	while (1) {
		unsigned int clientlen = sizeof(echoclient);
		// Wait for client connection
		if ((clientsock =
  800179:	8d 7d c4             	lea    -0x3c(%ebp),%edi
  80017c:	eb 4b                	jmp    8001c9 <umain+0xf2>
		die("Failed to create socket");
  80017e:	b8 a0 27 80 00       	mov    $0x8027a0,%eax
  800183:	e8 ab fe ff ff       	call   800033 <die>
  800188:	e9 6b ff ff ff       	jmp    8000f8 <umain+0x21>
		die("Failed to bind the server socket");
  80018d:	b8 70 28 80 00       	mov    $0x802870,%eax
  800192:	e8 9c fe ff ff       	call   800033 <die>
  800197:	eb be                	jmp    800157 <umain+0x80>
		die("Failed to listen on server socket");
  800199:	b8 94 28 80 00       	mov    $0x802894,%eax
  80019e:	e8 90 fe ff ff       	call   800033 <die>
  8001a3:	eb c4                	jmp    800169 <umain+0x92>
		     accept(serversock, (struct sockaddr *) &echoclient,
			    &clientlen)) < 0) {
			die("Failed to accept client connection");
		}
		cprintf("Client connected: %s\n", inet_ntoa(echoclient.sin_addr));
  8001a5:	83 ec 0c             	sub    $0xc,%esp
  8001a8:	ff 75 cc             	pushl  -0x34(%ebp)
  8001ab:	e8 43 00 00 00       	call   8001f3 <inet_ntoa>
  8001b0:	83 c4 08             	add    $0x8,%esp
  8001b3:	50                   	push   %eax
  8001b4:	68 de 27 80 00       	push   $0x8027de
  8001b9:	e8 08 04 00 00       	call   8005c6 <cprintf>
		handle_client(clientsock);
  8001be:	89 1c 24             	mov    %ebx,(%esp)
  8001c1:	e8 88 fe ff ff       	call   80004e <handle_client>
	while (1) {
  8001c6:	83 c4 10             	add    $0x10,%esp
		unsigned int clientlen = sizeof(echoclient);
  8001c9:	c7 45 c4 10 00 00 00 	movl   $0x10,-0x3c(%ebp)
		if ((clientsock =
  8001d0:	83 ec 04             	sub    $0x4,%esp
  8001d3:	57                   	push   %edi
  8001d4:	8d 45 c8             	lea    -0x38(%ebp),%eax
  8001d7:	50                   	push   %eax
  8001d8:	56                   	push   %esi
  8001d9:	e8 35 1d 00 00       	call   801f13 <accept>
  8001de:	89 c3                	mov    %eax,%ebx
  8001e0:	83 c4 10             	add    $0x10,%esp
  8001e3:	85 c0                	test   %eax,%eax
  8001e5:	79 be                	jns    8001a5 <umain+0xce>
			die("Failed to accept client connection");
  8001e7:	b8 b8 28 80 00       	mov    $0x8028b8,%eax
  8001ec:	e8 42 fe ff ff       	call   800033 <die>
  8001f1:	eb b2                	jmp    8001a5 <umain+0xce>

008001f3 <inet_ntoa>:
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
{
  8001f3:	55                   	push   %ebp
  8001f4:	89 e5                	mov    %esp,%ebp
  8001f6:	57                   	push   %edi
  8001f7:	56                   	push   %esi
  8001f8:	53                   	push   %ebx
  8001f9:	83 ec 14             	sub    $0x14,%esp
  static char str[16];
  u32_t s_addr = addr.s_addr;
  8001fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8001ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  800202:	8d 7d f0             	lea    -0x10(%ebp),%edi
  rp = str;
  800205:	c7 45 e0 00 40 80 00 	movl   $0x804000,-0x20(%ebp)
  80020c:	eb 30                	jmp    80023e <inet_ntoa+0x4b>
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
      *rp++ = inv[i];
  80020e:	0f b6 c2             	movzbl %dl,%eax
  800211:	0f b6 44 05 ed       	movzbl -0x13(%ebp,%eax,1),%eax
  800216:	88 01                	mov    %al,(%ecx)
  800218:	83 c1 01             	add    $0x1,%ecx
    while(i--)
  80021b:	83 ea 01             	sub    $0x1,%edx
  80021e:	80 fa ff             	cmp    $0xff,%dl
  800221:	75 eb                	jne    80020e <inet_ntoa+0x1b>
  800223:	89 f0                	mov    %esi,%eax
  800225:	0f b6 f0             	movzbl %al,%esi
  800228:	03 75 e0             	add    -0x20(%ebp),%esi
    *rp++ = '.';
  80022b:	8d 46 01             	lea    0x1(%esi),%eax
  80022e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800231:	c6 06 2e             	movb   $0x2e,(%esi)
  800234:	83 c7 01             	add    $0x1,%edi
  for(n = 0; n < 4; n++) {
  800237:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80023a:	39 c7                	cmp    %eax,%edi
  80023c:	74 3b                	je     800279 <inet_ntoa+0x86>
  rp = str;
  80023e:	b9 00 00 00 00       	mov    $0x0,%ecx
      rem = *ap % (u8_t)10;
  800243:	0f b6 17             	movzbl (%edi),%edx
      *ap /= (u8_t)10;
  800246:	0f b6 da             	movzbl %dl,%ebx
  800249:	8d 04 9b             	lea    (%ebx,%ebx,4),%eax
  80024c:	8d 04 c3             	lea    (%ebx,%eax,8),%eax
  80024f:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800252:	66 c1 e8 0b          	shr    $0xb,%ax
  800256:	88 07                	mov    %al,(%edi)
      inv[i++] = '0' + rem;
  800258:	8d 71 01             	lea    0x1(%ecx),%esi
  80025b:	0f b6 c9             	movzbl %cl,%ecx
      rem = *ap % (u8_t)10;
  80025e:	8d 1c 80             	lea    (%eax,%eax,4),%ebx
  800261:	01 db                	add    %ebx,%ebx
  800263:	29 da                	sub    %ebx,%edx
      inv[i++] = '0' + rem;
  800265:	83 c2 30             	add    $0x30,%edx
  800268:	88 54 0d ed          	mov    %dl,-0x13(%ebp,%ecx,1)
  80026c:	89 f1                	mov    %esi,%ecx
    } while(*ap);
  80026e:	84 c0                	test   %al,%al
  800270:	75 d1                	jne    800243 <inet_ntoa+0x50>
  800272:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      inv[i++] = '0' + rem;
  800275:	89 f2                	mov    %esi,%edx
  800277:	eb a2                	jmp    80021b <inet_ntoa+0x28>
    ap++;
  }
  *--rp = 0;
  800279:	c6 06 00             	movb   $0x0,(%esi)
  return str;
}
  80027c:	b8 00 40 80 00       	mov    $0x804000,%eax
  800281:	83 c4 14             	add    $0x14,%esp
  800284:	5b                   	pop    %ebx
  800285:	5e                   	pop    %esi
  800286:	5f                   	pop    %edi
  800287:	5d                   	pop    %ebp
  800288:	c3                   	ret    

00800289 <htons>:
 * @param n u16_t in host byte order
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  800289:	55                   	push   %ebp
  80028a:	89 e5                	mov    %esp,%ebp
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  80028c:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  800290:	66 c1 c0 08          	rol    $0x8,%ax
}
  800294:	5d                   	pop    %ebp
  800295:	c3                   	ret    

00800296 <ntohs>:
 * @param n u16_t in network byte order
 * @return n in host byte order
 */
u16_t
ntohs(u16_t n)
{
  800296:	55                   	push   %ebp
  800297:	89 e5                	mov    %esp,%ebp
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  800299:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  80029d:	66 c1 c0 08          	rol    $0x8,%ax
  return htons(n);
}
  8002a1:	5d                   	pop    %ebp
  8002a2:	c3                   	ret    

008002a3 <htonl>:
 * @param n u32_t in host byte order
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  8002a3:	55                   	push   %ebp
  8002a4:	89 e5                	mov    %esp,%ebp
  8002a6:	8b 55 08             	mov    0x8(%ebp),%edx
  return ((n & 0xff) << 24) |
  8002a9:	89 d0                	mov    %edx,%eax
  8002ab:	c1 e0 18             	shl    $0x18,%eax
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
  8002ae:	89 d1                	mov    %edx,%ecx
  8002b0:	c1 e9 18             	shr    $0x18,%ecx
    ((n & 0xff0000UL) >> 8) |
  8002b3:	09 c8                	or     %ecx,%eax
    ((n & 0xff00) << 8) |
  8002b5:	89 d1                	mov    %edx,%ecx
  8002b7:	c1 e1 08             	shl    $0x8,%ecx
  8002ba:	81 e1 00 00 ff 00    	and    $0xff0000,%ecx
    ((n & 0xff0000UL) >> 8) |
  8002c0:	09 c8                	or     %ecx,%eax
  8002c2:	c1 ea 08             	shr    $0x8,%edx
  8002c5:	81 e2 00 ff 00 00    	and    $0xff00,%edx
  8002cb:	09 d0                	or     %edx,%eax
}
  8002cd:	5d                   	pop    %ebp
  8002ce:	c3                   	ret    

008002cf <inet_aton>:
{
  8002cf:	55                   	push   %ebp
  8002d0:	89 e5                	mov    %esp,%ebp
  8002d2:	57                   	push   %edi
  8002d3:	56                   	push   %esi
  8002d4:	53                   	push   %ebx
  8002d5:	83 ec 1c             	sub    $0x1c,%esp
  8002d8:	8b 45 08             	mov    0x8(%ebp),%eax
  c = *cp;
  8002db:	0f be 10             	movsbl (%eax),%edx
  u32_t *pp = parts;
  8002de:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  8002e1:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8002e4:	e9 a9 00 00 00       	jmp    800392 <inet_aton+0xc3>
      c = *++cp;
  8002e9:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      if (c == 'x' || c == 'X') {
  8002ed:	89 d1                	mov    %edx,%ecx
  8002ef:	83 e1 df             	and    $0xffffffdf,%ecx
  8002f2:	80 f9 58             	cmp    $0x58,%cl
  8002f5:	74 12                	je     800309 <inet_aton+0x3a>
      c = *++cp;
  8002f7:	83 c0 01             	add    $0x1,%eax
  8002fa:	0f be d2             	movsbl %dl,%edx
        base = 8;
  8002fd:	c7 45 dc 08 00 00 00 	movl   $0x8,-0x24(%ebp)
  800304:	e9 a5 00 00 00       	jmp    8003ae <inet_aton+0xdf>
        c = *++cp;
  800309:	0f be 50 02          	movsbl 0x2(%eax),%edx
  80030d:	8d 40 02             	lea    0x2(%eax),%eax
        base = 16;
  800310:	c7 45 dc 10 00 00 00 	movl   $0x10,-0x24(%ebp)
  800317:	e9 92 00 00 00       	jmp    8003ae <inet_aton+0xdf>
      } else if (base == 16 && isxdigit(c)) {
  80031c:	83 7d dc 10          	cmpl   $0x10,-0x24(%ebp)
  800320:	75 4a                	jne    80036c <inet_aton+0x9d>
  800322:	8d 5e 9f             	lea    -0x61(%esi),%ebx
  800325:	89 d1                	mov    %edx,%ecx
  800327:	83 e1 df             	and    $0xffffffdf,%ecx
  80032a:	83 e9 41             	sub    $0x41,%ecx
  80032d:	80 f9 05             	cmp    $0x5,%cl
  800330:	77 3a                	ja     80036c <inet_aton+0x9d>
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
  800332:	c1 e7 04             	shl    $0x4,%edi
  800335:	83 c2 0a             	add    $0xa,%edx
  800338:	80 fb 1a             	cmp    $0x1a,%bl
  80033b:	19 c9                	sbb    %ecx,%ecx
  80033d:	83 e1 20             	and    $0x20,%ecx
  800340:	83 c1 41             	add    $0x41,%ecx
  800343:	29 ca                	sub    %ecx,%edx
  800345:	09 d7                	or     %edx,%edi
        c = *++cp;
  800347:	8b 75 e0             	mov    -0x20(%ebp),%esi
  80034a:	0f be 56 01          	movsbl 0x1(%esi),%edx
  80034e:	83 c0 01             	add    $0x1,%eax
  800351:	89 45 e0             	mov    %eax,-0x20(%ebp)
      if (isdigit(c)) {
  800354:	89 d6                	mov    %edx,%esi
  800356:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800359:	80 f9 09             	cmp    $0x9,%cl
  80035c:	77 be                	ja     80031c <inet_aton+0x4d>
        val = (val * base) + (int)(c - '0');
  80035e:	0f af 7d dc          	imul   -0x24(%ebp),%edi
  800362:	8d 7c 3a d0          	lea    -0x30(%edx,%edi,1),%edi
        c = *++cp;
  800366:	0f be 50 01          	movsbl 0x1(%eax),%edx
  80036a:	eb e2                	jmp    80034e <inet_aton+0x7f>
    if (c == '.') {
  80036c:	83 fa 2e             	cmp    $0x2e,%edx
  80036f:	75 44                	jne    8003b5 <inet_aton+0xe6>
      if (pp >= parts + 3)
  800371:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800374:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800377:	39 c3                	cmp    %eax,%ebx
  800379:	0f 84 13 01 00 00    	je     800492 <inet_aton+0x1c3>
      *pp++ = val;
  80037f:	83 c3 04             	add    $0x4,%ebx
  800382:	89 5d d8             	mov    %ebx,-0x28(%ebp)
  800385:	89 7b fc             	mov    %edi,-0x4(%ebx)
      c = *++cp;
  800388:	8b 75 e0             	mov    -0x20(%ebp),%esi
  80038b:	8d 46 01             	lea    0x1(%esi),%eax
  80038e:	0f be 56 01          	movsbl 0x1(%esi),%edx
    if (!isdigit(c))
  800392:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800395:	80 f9 09             	cmp    $0x9,%cl
  800398:	0f 87 ed 00 00 00    	ja     80048b <inet_aton+0x1bc>
    base = 10;
  80039e:	c7 45 dc 0a 00 00 00 	movl   $0xa,-0x24(%ebp)
    if (c == '0') {
  8003a5:	83 fa 30             	cmp    $0x30,%edx
  8003a8:	0f 84 3b ff ff ff    	je     8002e9 <inet_aton+0x1a>
        base = 8;
  8003ae:	bf 00 00 00 00       	mov    $0x0,%edi
  8003b3:	eb 9c                	jmp    800351 <inet_aton+0x82>
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  8003b5:	85 d2                	test   %edx,%edx
  8003b7:	74 29                	je     8003e2 <inet_aton+0x113>
    return (0);
  8003b9:	b8 00 00 00 00       	mov    $0x0,%eax
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  8003be:	89 f3                	mov    %esi,%ebx
  8003c0:	80 fb 1f             	cmp    $0x1f,%bl
  8003c3:	0f 86 ce 00 00 00    	jbe    800497 <inet_aton+0x1c8>
  8003c9:	84 d2                	test   %dl,%dl
  8003cb:	0f 88 c6 00 00 00    	js     800497 <inet_aton+0x1c8>
  8003d1:	83 fa 20             	cmp    $0x20,%edx
  8003d4:	74 0c                	je     8003e2 <inet_aton+0x113>
  8003d6:	83 ea 09             	sub    $0x9,%edx
  8003d9:	83 fa 04             	cmp    $0x4,%edx
  8003dc:	0f 87 b5 00 00 00    	ja     800497 <inet_aton+0x1c8>
  n = pp - parts + 1;
  8003e2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8003e5:	8b 75 d8             	mov    -0x28(%ebp),%esi
  8003e8:	29 c6                	sub    %eax,%esi
  8003ea:	89 f0                	mov    %esi,%eax
  8003ec:	c1 f8 02             	sar    $0x2,%eax
  8003ef:	83 c0 01             	add    $0x1,%eax
  switch (n) {
  8003f2:	83 f8 02             	cmp    $0x2,%eax
  8003f5:	74 5e                	je     800455 <inet_aton+0x186>
  8003f7:	83 f8 02             	cmp    $0x2,%eax
  8003fa:	7e 35                	jle    800431 <inet_aton+0x162>
  8003fc:	83 f8 03             	cmp    $0x3,%eax
  8003ff:	74 6b                	je     80046c <inet_aton+0x19d>
  800401:	83 f8 04             	cmp    $0x4,%eax
  800404:	75 2f                	jne    800435 <inet_aton+0x166>
      return (0);
  800406:	b8 00 00 00 00       	mov    $0x0,%eax
    if (val > 0xff)
  80040b:	81 ff ff 00 00 00    	cmp    $0xff,%edi
  800411:	0f 87 80 00 00 00    	ja     800497 <inet_aton+0x1c8>
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
  800417:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80041a:	c1 e0 18             	shl    $0x18,%eax
  80041d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800420:	c1 e2 10             	shl    $0x10,%edx
  800423:	09 d0                	or     %edx,%eax
  800425:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800428:	c1 e2 08             	shl    $0x8,%edx
  80042b:	09 d0                	or     %edx,%eax
  80042d:	09 c7                	or     %eax,%edi
    break;
  80042f:	eb 04                	jmp    800435 <inet_aton+0x166>
  switch (n) {
  800431:	85 c0                	test   %eax,%eax
  800433:	74 62                	je     800497 <inet_aton+0x1c8>
  return (1);
  800435:	b8 01 00 00 00       	mov    $0x1,%eax
  if (addr)
  80043a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80043e:	74 57                	je     800497 <inet_aton+0x1c8>
    addr->s_addr = htonl(val);
  800440:	57                   	push   %edi
  800441:	e8 5d fe ff ff       	call   8002a3 <htonl>
  800446:	83 c4 04             	add    $0x4,%esp
  800449:	8b 75 0c             	mov    0xc(%ebp),%esi
  80044c:	89 06                	mov    %eax,(%esi)
  return (1);
  80044e:	b8 01 00 00 00       	mov    $0x1,%eax
  800453:	eb 42                	jmp    800497 <inet_aton+0x1c8>
      return (0);
  800455:	b8 00 00 00 00       	mov    $0x0,%eax
    if (val > 0xffffffUL)
  80045a:	81 ff ff ff ff 00    	cmp    $0xffffff,%edi
  800460:	77 35                	ja     800497 <inet_aton+0x1c8>
    val |= parts[0] << 24;
  800462:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800465:	c1 e0 18             	shl    $0x18,%eax
  800468:	09 c7                	or     %eax,%edi
    break;
  80046a:	eb c9                	jmp    800435 <inet_aton+0x166>
      return (0);
  80046c:	b8 00 00 00 00       	mov    $0x0,%eax
    if (val > 0xffff)
  800471:	81 ff ff ff 00 00    	cmp    $0xffff,%edi
  800477:	77 1e                	ja     800497 <inet_aton+0x1c8>
    val |= (parts[0] << 24) | (parts[1] << 16);
  800479:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80047c:	c1 e0 18             	shl    $0x18,%eax
  80047f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800482:	c1 e2 10             	shl    $0x10,%edx
  800485:	09 d0                	or     %edx,%eax
  800487:	09 c7                	or     %eax,%edi
    break;
  800489:	eb aa                	jmp    800435 <inet_aton+0x166>
      return (0);
  80048b:	b8 00 00 00 00       	mov    $0x0,%eax
  800490:	eb 05                	jmp    800497 <inet_aton+0x1c8>
        return (0);
  800492:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800497:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80049a:	5b                   	pop    %ebx
  80049b:	5e                   	pop    %esi
  80049c:	5f                   	pop    %edi
  80049d:	5d                   	pop    %ebp
  80049e:	c3                   	ret    

0080049f <inet_addr>:
{
  80049f:	55                   	push   %ebp
  8004a0:	89 e5                	mov    %esp,%ebp
  8004a2:	83 ec 10             	sub    $0x10,%esp
  if (inet_aton(cp, &val)) {
  8004a5:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8004a8:	50                   	push   %eax
  8004a9:	ff 75 08             	pushl  0x8(%ebp)
  8004ac:	e8 1e fe ff ff       	call   8002cf <inet_aton>
  8004b1:	83 c4 08             	add    $0x8,%esp
    return (val.s_addr);
  8004b4:	85 c0                	test   %eax,%eax
  8004b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8004bb:	0f 45 45 fc          	cmovne -0x4(%ebp),%eax
}
  8004bf:	c9                   	leave  
  8004c0:	c3                   	ret    

008004c1 <ntohl>:
 * @param n u32_t in network byte order
 * @return n in host byte order
 */
u32_t
ntohl(u32_t n)
{
  8004c1:	55                   	push   %ebp
  8004c2:	89 e5                	mov    %esp,%ebp
  return htonl(n);
  8004c4:	ff 75 08             	pushl  0x8(%ebp)
  8004c7:	e8 d7 fd ff ff       	call   8002a3 <htonl>
  8004cc:	83 c4 04             	add    $0x4,%esp
}
  8004cf:	c9                   	leave  
  8004d0:	c3                   	ret    

008004d1 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8004d1:	55                   	push   %ebp
  8004d2:	89 e5                	mov    %esp,%ebp
  8004d4:	56                   	push   %esi
  8004d5:	53                   	push   %ebx
  8004d6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8004d9:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
    thisenv = &envs[ENVX(sys_getenvid())];
  8004dc:	e8 3d 0b 00 00       	call   80101e <sys_getenvid>
  8004e1:	25 ff 03 00 00       	and    $0x3ff,%eax
  8004e6:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8004e9:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8004ee:	a3 18 40 80 00       	mov    %eax,0x804018

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8004f3:	85 db                	test   %ebx,%ebx
  8004f5:	7e 07                	jle    8004fe <libmain+0x2d>
		binaryname = argv[0];
  8004f7:	8b 06                	mov    (%esi),%eax
  8004f9:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8004fe:	83 ec 08             	sub    $0x8,%esp
  800501:	56                   	push   %esi
  800502:	53                   	push   %ebx
  800503:	e8 cf fb ff ff       	call   8000d7 <umain>

	// exit gracefully
	exit();
  800508:	e8 0a 00 00 00       	call   800517 <exit>
}
  80050d:	83 c4 10             	add    $0x10,%esp
  800510:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800513:	5b                   	pop    %ebx
  800514:	5e                   	pop    %esi
  800515:	5d                   	pop    %ebp
  800516:	c3                   	ret    

00800517 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800517:	55                   	push   %ebp
  800518:	89 e5                	mov    %esp,%ebp
  80051a:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80051d:	e8 20 0f 00 00       	call   801442 <close_all>
	sys_env_destroy(0);
  800522:	83 ec 0c             	sub    $0xc,%esp
  800525:	6a 00                	push   $0x0
  800527:	e8 b1 0a 00 00       	call   800fdd <sys_env_destroy>
}
  80052c:	83 c4 10             	add    $0x10,%esp
  80052f:	c9                   	leave  
  800530:	c3                   	ret    

00800531 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800531:	55                   	push   %ebp
  800532:	89 e5                	mov    %esp,%ebp
  800534:	53                   	push   %ebx
  800535:	83 ec 04             	sub    $0x4,%esp
  800538:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80053b:	8b 13                	mov    (%ebx),%edx
  80053d:	8d 42 01             	lea    0x1(%edx),%eax
  800540:	89 03                	mov    %eax,(%ebx)
  800542:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800545:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800549:	3d ff 00 00 00       	cmp    $0xff,%eax
  80054e:	74 09                	je     800559 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800550:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800554:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800557:	c9                   	leave  
  800558:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800559:	83 ec 08             	sub    $0x8,%esp
  80055c:	68 ff 00 00 00       	push   $0xff
  800561:	8d 43 08             	lea    0x8(%ebx),%eax
  800564:	50                   	push   %eax
  800565:	e8 36 0a 00 00       	call   800fa0 <sys_cputs>
		b->idx = 0;
  80056a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800570:	83 c4 10             	add    $0x10,%esp
  800573:	eb db                	jmp    800550 <putch+0x1f>

00800575 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800575:	55                   	push   %ebp
  800576:	89 e5                	mov    %esp,%ebp
  800578:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80057e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800585:	00 00 00 
	b.cnt = 0;
  800588:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80058f:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800592:	ff 75 0c             	pushl  0xc(%ebp)
  800595:	ff 75 08             	pushl  0x8(%ebp)
  800598:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80059e:	50                   	push   %eax
  80059f:	68 31 05 80 00       	push   $0x800531
  8005a4:	e8 1a 01 00 00       	call   8006c3 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8005a9:	83 c4 08             	add    $0x8,%esp
  8005ac:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8005b2:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8005b8:	50                   	push   %eax
  8005b9:	e8 e2 09 00 00       	call   800fa0 <sys_cputs>

	return b.cnt;
}
  8005be:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8005c4:	c9                   	leave  
  8005c5:	c3                   	ret    

008005c6 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8005c6:	55                   	push   %ebp
  8005c7:	89 e5                	mov    %esp,%ebp
  8005c9:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8005cc:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8005cf:	50                   	push   %eax
  8005d0:	ff 75 08             	pushl  0x8(%ebp)
  8005d3:	e8 9d ff ff ff       	call   800575 <vcprintf>
	va_end(ap);

	return cnt;
}
  8005d8:	c9                   	leave  
  8005d9:	c3                   	ret    

008005da <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005da:	55                   	push   %ebp
  8005db:	89 e5                	mov    %esp,%ebp
  8005dd:	57                   	push   %edi
  8005de:	56                   	push   %esi
  8005df:	53                   	push   %ebx
  8005e0:	83 ec 1c             	sub    $0x1c,%esp
  8005e3:	89 c7                	mov    %eax,%edi
  8005e5:	89 d6                	mov    %edx,%esi
  8005e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005ed:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005f0:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005f3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8005f6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8005fb:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8005fe:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800601:	39 d3                	cmp    %edx,%ebx
  800603:	72 05                	jb     80060a <printnum+0x30>
  800605:	39 45 10             	cmp    %eax,0x10(%ebp)
  800608:	77 7a                	ja     800684 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80060a:	83 ec 0c             	sub    $0xc,%esp
  80060d:	ff 75 18             	pushl  0x18(%ebp)
  800610:	8b 45 14             	mov    0x14(%ebp),%eax
  800613:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800616:	53                   	push   %ebx
  800617:	ff 75 10             	pushl  0x10(%ebp)
  80061a:	83 ec 08             	sub    $0x8,%esp
  80061d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800620:	ff 75 e0             	pushl  -0x20(%ebp)
  800623:	ff 75 dc             	pushl  -0x24(%ebp)
  800626:	ff 75 d8             	pushl  -0x28(%ebp)
  800629:	e8 22 1f 00 00       	call   802550 <__udivdi3>
  80062e:	83 c4 18             	add    $0x18,%esp
  800631:	52                   	push   %edx
  800632:	50                   	push   %eax
  800633:	89 f2                	mov    %esi,%edx
  800635:	89 f8                	mov    %edi,%eax
  800637:	e8 9e ff ff ff       	call   8005da <printnum>
  80063c:	83 c4 20             	add    $0x20,%esp
  80063f:	eb 13                	jmp    800654 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800641:	83 ec 08             	sub    $0x8,%esp
  800644:	56                   	push   %esi
  800645:	ff 75 18             	pushl  0x18(%ebp)
  800648:	ff d7                	call   *%edi
  80064a:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80064d:	83 eb 01             	sub    $0x1,%ebx
  800650:	85 db                	test   %ebx,%ebx
  800652:	7f ed                	jg     800641 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800654:	83 ec 08             	sub    $0x8,%esp
  800657:	56                   	push   %esi
  800658:	83 ec 04             	sub    $0x4,%esp
  80065b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80065e:	ff 75 e0             	pushl  -0x20(%ebp)
  800661:	ff 75 dc             	pushl  -0x24(%ebp)
  800664:	ff 75 d8             	pushl  -0x28(%ebp)
  800667:	e8 04 20 00 00       	call   802670 <__umoddi3>
  80066c:	83 c4 14             	add    $0x14,%esp
  80066f:	0f be 80 e5 28 80 00 	movsbl 0x8028e5(%eax),%eax
  800676:	50                   	push   %eax
  800677:	ff d7                	call   *%edi
}
  800679:	83 c4 10             	add    $0x10,%esp
  80067c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80067f:	5b                   	pop    %ebx
  800680:	5e                   	pop    %esi
  800681:	5f                   	pop    %edi
  800682:	5d                   	pop    %ebp
  800683:	c3                   	ret    
  800684:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800687:	eb c4                	jmp    80064d <printnum+0x73>

00800689 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800689:	55                   	push   %ebp
  80068a:	89 e5                	mov    %esp,%ebp
  80068c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80068f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800693:	8b 10                	mov    (%eax),%edx
  800695:	3b 50 04             	cmp    0x4(%eax),%edx
  800698:	73 0a                	jae    8006a4 <sprintputch+0x1b>
		*b->buf++ = ch;
  80069a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80069d:	89 08                	mov    %ecx,(%eax)
  80069f:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a2:	88 02                	mov    %al,(%edx)
}
  8006a4:	5d                   	pop    %ebp
  8006a5:	c3                   	ret    

008006a6 <printfmt>:
{
  8006a6:	55                   	push   %ebp
  8006a7:	89 e5                	mov    %esp,%ebp
  8006a9:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8006ac:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8006af:	50                   	push   %eax
  8006b0:	ff 75 10             	pushl  0x10(%ebp)
  8006b3:	ff 75 0c             	pushl  0xc(%ebp)
  8006b6:	ff 75 08             	pushl  0x8(%ebp)
  8006b9:	e8 05 00 00 00       	call   8006c3 <vprintfmt>
}
  8006be:	83 c4 10             	add    $0x10,%esp
  8006c1:	c9                   	leave  
  8006c2:	c3                   	ret    

008006c3 <vprintfmt>:
{
  8006c3:	55                   	push   %ebp
  8006c4:	89 e5                	mov    %esp,%ebp
  8006c6:	57                   	push   %edi
  8006c7:	56                   	push   %esi
  8006c8:	53                   	push   %ebx
  8006c9:	83 ec 2c             	sub    $0x2c,%esp
  8006cc:	8b 75 08             	mov    0x8(%ebp),%esi
  8006cf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8006d2:	8b 7d 10             	mov    0x10(%ebp),%edi
  8006d5:	e9 21 04 00 00       	jmp    800afb <vprintfmt+0x438>
		padc = ' ';
  8006da:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8006de:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8006e5:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  8006ec:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8006f3:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8006f8:	8d 47 01             	lea    0x1(%edi),%eax
  8006fb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006fe:	0f b6 17             	movzbl (%edi),%edx
  800701:	8d 42 dd             	lea    -0x23(%edx),%eax
  800704:	3c 55                	cmp    $0x55,%al
  800706:	0f 87 90 04 00 00    	ja     800b9c <vprintfmt+0x4d9>
  80070c:	0f b6 c0             	movzbl %al,%eax
  80070f:	ff 24 85 20 2a 80 00 	jmp    *0x802a20(,%eax,4)
  800716:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800719:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  80071d:	eb d9                	jmp    8006f8 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80071f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800722:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800726:	eb d0                	jmp    8006f8 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800728:	0f b6 d2             	movzbl %dl,%edx
  80072b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80072e:	b8 00 00 00 00       	mov    $0x0,%eax
  800733:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800736:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800739:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80073d:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800740:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800743:	83 f9 09             	cmp    $0x9,%ecx
  800746:	77 55                	ja     80079d <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  800748:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80074b:	eb e9                	jmp    800736 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  80074d:	8b 45 14             	mov    0x14(%ebp),%eax
  800750:	8b 00                	mov    (%eax),%eax
  800752:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800755:	8b 45 14             	mov    0x14(%ebp),%eax
  800758:	8d 40 04             	lea    0x4(%eax),%eax
  80075b:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80075e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800761:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800765:	79 91                	jns    8006f8 <vprintfmt+0x35>
				width = precision, precision = -1;
  800767:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80076a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80076d:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800774:	eb 82                	jmp    8006f8 <vprintfmt+0x35>
  800776:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800779:	85 c0                	test   %eax,%eax
  80077b:	ba 00 00 00 00       	mov    $0x0,%edx
  800780:	0f 49 d0             	cmovns %eax,%edx
  800783:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800786:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800789:	e9 6a ff ff ff       	jmp    8006f8 <vprintfmt+0x35>
  80078e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800791:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800798:	e9 5b ff ff ff       	jmp    8006f8 <vprintfmt+0x35>
  80079d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8007a0:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8007a3:	eb bc                	jmp    800761 <vprintfmt+0x9e>
			lflag++;
  8007a5:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8007a8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8007ab:	e9 48 ff ff ff       	jmp    8006f8 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8007b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b3:	8d 78 04             	lea    0x4(%eax),%edi
  8007b6:	83 ec 08             	sub    $0x8,%esp
  8007b9:	53                   	push   %ebx
  8007ba:	ff 30                	pushl  (%eax)
  8007bc:	ff d6                	call   *%esi
			break;
  8007be:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8007c1:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8007c4:	e9 2f 03 00 00       	jmp    800af8 <vprintfmt+0x435>
			err = va_arg(ap, int);
  8007c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cc:	8d 78 04             	lea    0x4(%eax),%edi
  8007cf:	8b 00                	mov    (%eax),%eax
  8007d1:	99                   	cltd   
  8007d2:	31 d0                	xor    %edx,%eax
  8007d4:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8007d6:	83 f8 0f             	cmp    $0xf,%eax
  8007d9:	7f 23                	jg     8007fe <vprintfmt+0x13b>
  8007db:	8b 14 85 80 2b 80 00 	mov    0x802b80(,%eax,4),%edx
  8007e2:	85 d2                	test   %edx,%edx
  8007e4:	74 18                	je     8007fe <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  8007e6:	52                   	push   %edx
  8007e7:	68 db 2c 80 00       	push   $0x802cdb
  8007ec:	53                   	push   %ebx
  8007ed:	56                   	push   %esi
  8007ee:	e8 b3 fe ff ff       	call   8006a6 <printfmt>
  8007f3:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8007f6:	89 7d 14             	mov    %edi,0x14(%ebp)
  8007f9:	e9 fa 02 00 00       	jmp    800af8 <vprintfmt+0x435>
				printfmt(putch, putdat, "error %d", err);
  8007fe:	50                   	push   %eax
  8007ff:	68 fd 28 80 00       	push   $0x8028fd
  800804:	53                   	push   %ebx
  800805:	56                   	push   %esi
  800806:	e8 9b fe ff ff       	call   8006a6 <printfmt>
  80080b:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80080e:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800811:	e9 e2 02 00 00       	jmp    800af8 <vprintfmt+0x435>
			if ((p = va_arg(ap, char *)) == NULL)
  800816:	8b 45 14             	mov    0x14(%ebp),%eax
  800819:	83 c0 04             	add    $0x4,%eax
  80081c:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80081f:	8b 45 14             	mov    0x14(%ebp),%eax
  800822:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800824:	85 ff                	test   %edi,%edi
  800826:	b8 f6 28 80 00       	mov    $0x8028f6,%eax
  80082b:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  80082e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800832:	0f 8e bd 00 00 00    	jle    8008f5 <vprintfmt+0x232>
  800838:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80083c:	75 0e                	jne    80084c <vprintfmt+0x189>
  80083e:	89 75 08             	mov    %esi,0x8(%ebp)
  800841:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800844:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800847:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80084a:	eb 6d                	jmp    8008b9 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  80084c:	83 ec 08             	sub    $0x8,%esp
  80084f:	ff 75 d0             	pushl  -0x30(%ebp)
  800852:	57                   	push   %edi
  800853:	e8 ec 03 00 00       	call   800c44 <strnlen>
  800858:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80085b:	29 c1                	sub    %eax,%ecx
  80085d:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800860:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800863:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800867:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80086a:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  80086d:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  80086f:	eb 0f                	jmp    800880 <vprintfmt+0x1bd>
					putch(padc, putdat);
  800871:	83 ec 08             	sub    $0x8,%esp
  800874:	53                   	push   %ebx
  800875:	ff 75 e0             	pushl  -0x20(%ebp)
  800878:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80087a:	83 ef 01             	sub    $0x1,%edi
  80087d:	83 c4 10             	add    $0x10,%esp
  800880:	85 ff                	test   %edi,%edi
  800882:	7f ed                	jg     800871 <vprintfmt+0x1ae>
  800884:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800887:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  80088a:	85 c9                	test   %ecx,%ecx
  80088c:	b8 00 00 00 00       	mov    $0x0,%eax
  800891:	0f 49 c1             	cmovns %ecx,%eax
  800894:	29 c1                	sub    %eax,%ecx
  800896:	89 75 08             	mov    %esi,0x8(%ebp)
  800899:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80089c:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80089f:	89 cb                	mov    %ecx,%ebx
  8008a1:	eb 16                	jmp    8008b9 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8008a3:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8008a7:	75 31                	jne    8008da <vprintfmt+0x217>
					putch(ch, putdat);
  8008a9:	83 ec 08             	sub    $0x8,%esp
  8008ac:	ff 75 0c             	pushl  0xc(%ebp)
  8008af:	50                   	push   %eax
  8008b0:	ff 55 08             	call   *0x8(%ebp)
  8008b3:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008b6:	83 eb 01             	sub    $0x1,%ebx
  8008b9:	83 c7 01             	add    $0x1,%edi
  8008bc:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8008c0:	0f be c2             	movsbl %dl,%eax
  8008c3:	85 c0                	test   %eax,%eax
  8008c5:	74 59                	je     800920 <vprintfmt+0x25d>
  8008c7:	85 f6                	test   %esi,%esi
  8008c9:	78 d8                	js     8008a3 <vprintfmt+0x1e0>
  8008cb:	83 ee 01             	sub    $0x1,%esi
  8008ce:	79 d3                	jns    8008a3 <vprintfmt+0x1e0>
  8008d0:	89 df                	mov    %ebx,%edi
  8008d2:	8b 75 08             	mov    0x8(%ebp),%esi
  8008d5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8008d8:	eb 37                	jmp    800911 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  8008da:	0f be d2             	movsbl %dl,%edx
  8008dd:	83 ea 20             	sub    $0x20,%edx
  8008e0:	83 fa 5e             	cmp    $0x5e,%edx
  8008e3:	76 c4                	jbe    8008a9 <vprintfmt+0x1e6>
					putch('?', putdat);
  8008e5:	83 ec 08             	sub    $0x8,%esp
  8008e8:	ff 75 0c             	pushl  0xc(%ebp)
  8008eb:	6a 3f                	push   $0x3f
  8008ed:	ff 55 08             	call   *0x8(%ebp)
  8008f0:	83 c4 10             	add    $0x10,%esp
  8008f3:	eb c1                	jmp    8008b6 <vprintfmt+0x1f3>
  8008f5:	89 75 08             	mov    %esi,0x8(%ebp)
  8008f8:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8008fb:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8008fe:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800901:	eb b6                	jmp    8008b9 <vprintfmt+0x1f6>
				putch(' ', putdat);
  800903:	83 ec 08             	sub    $0x8,%esp
  800906:	53                   	push   %ebx
  800907:	6a 20                	push   $0x20
  800909:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80090b:	83 ef 01             	sub    $0x1,%edi
  80090e:	83 c4 10             	add    $0x10,%esp
  800911:	85 ff                	test   %edi,%edi
  800913:	7f ee                	jg     800903 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  800915:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800918:	89 45 14             	mov    %eax,0x14(%ebp)
  80091b:	e9 d8 01 00 00       	jmp    800af8 <vprintfmt+0x435>
  800920:	89 df                	mov    %ebx,%edi
  800922:	8b 75 08             	mov    0x8(%ebp),%esi
  800925:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800928:	eb e7                	jmp    800911 <vprintfmt+0x24e>
	if (lflag >= 2)
  80092a:	83 f9 01             	cmp    $0x1,%ecx
  80092d:	7e 45                	jle    800974 <vprintfmt+0x2b1>
		return va_arg(*ap, long long);
  80092f:	8b 45 14             	mov    0x14(%ebp),%eax
  800932:	8b 50 04             	mov    0x4(%eax),%edx
  800935:	8b 00                	mov    (%eax),%eax
  800937:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80093a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80093d:	8b 45 14             	mov    0x14(%ebp),%eax
  800940:	8d 40 08             	lea    0x8(%eax),%eax
  800943:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800946:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80094a:	79 62                	jns    8009ae <vprintfmt+0x2eb>
				putch('-', putdat);
  80094c:	83 ec 08             	sub    $0x8,%esp
  80094f:	53                   	push   %ebx
  800950:	6a 2d                	push   $0x2d
  800952:	ff d6                	call   *%esi
				num = -(long long) num;
  800954:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800957:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80095a:	f7 d8                	neg    %eax
  80095c:	83 d2 00             	adc    $0x0,%edx
  80095f:	f7 da                	neg    %edx
  800961:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800964:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800967:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80096a:	ba 0a 00 00 00       	mov    $0xa,%edx
  80096f:	e9 66 01 00 00       	jmp    800ada <vprintfmt+0x417>
	else if (lflag)
  800974:	85 c9                	test   %ecx,%ecx
  800976:	75 1b                	jne    800993 <vprintfmt+0x2d0>
		return va_arg(*ap, int);
  800978:	8b 45 14             	mov    0x14(%ebp),%eax
  80097b:	8b 00                	mov    (%eax),%eax
  80097d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800980:	89 c1                	mov    %eax,%ecx
  800982:	c1 f9 1f             	sar    $0x1f,%ecx
  800985:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800988:	8b 45 14             	mov    0x14(%ebp),%eax
  80098b:	8d 40 04             	lea    0x4(%eax),%eax
  80098e:	89 45 14             	mov    %eax,0x14(%ebp)
  800991:	eb b3                	jmp    800946 <vprintfmt+0x283>
		return va_arg(*ap, long);
  800993:	8b 45 14             	mov    0x14(%ebp),%eax
  800996:	8b 00                	mov    (%eax),%eax
  800998:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80099b:	89 c1                	mov    %eax,%ecx
  80099d:	c1 f9 1f             	sar    $0x1f,%ecx
  8009a0:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8009a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a6:	8d 40 04             	lea    0x4(%eax),%eax
  8009a9:	89 45 14             	mov    %eax,0x14(%ebp)
  8009ac:	eb 98                	jmp    800946 <vprintfmt+0x283>
			base = 10;
  8009ae:	ba 0a 00 00 00       	mov    $0xa,%edx
  8009b3:	e9 22 01 00 00       	jmp    800ada <vprintfmt+0x417>
	if (lflag >= 2)
  8009b8:	83 f9 01             	cmp    $0x1,%ecx
  8009bb:	7e 21                	jle    8009de <vprintfmt+0x31b>
		return va_arg(*ap, unsigned long long);
  8009bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c0:	8b 50 04             	mov    0x4(%eax),%edx
  8009c3:	8b 00                	mov    (%eax),%eax
  8009c5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009c8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ce:	8d 40 08             	lea    0x8(%eax),%eax
  8009d1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8009d4:	ba 0a 00 00 00       	mov    $0xa,%edx
  8009d9:	e9 fc 00 00 00       	jmp    800ada <vprintfmt+0x417>
	else if (lflag)
  8009de:	85 c9                	test   %ecx,%ecx
  8009e0:	75 23                	jne    800a05 <vprintfmt+0x342>
		return va_arg(*ap, unsigned int);
  8009e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e5:	8b 00                	mov    (%eax),%eax
  8009e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8009ec:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009ef:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f5:	8d 40 04             	lea    0x4(%eax),%eax
  8009f8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8009fb:	ba 0a 00 00 00       	mov    $0xa,%edx
  800a00:	e9 d5 00 00 00       	jmp    800ada <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  800a05:	8b 45 14             	mov    0x14(%ebp),%eax
  800a08:	8b 00                	mov    (%eax),%eax
  800a0a:	ba 00 00 00 00       	mov    $0x0,%edx
  800a0f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a12:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a15:	8b 45 14             	mov    0x14(%ebp),%eax
  800a18:	8d 40 04             	lea    0x4(%eax),%eax
  800a1b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800a1e:	ba 0a 00 00 00       	mov    $0xa,%edx
  800a23:	e9 b2 00 00 00       	jmp    800ada <vprintfmt+0x417>
	if (lflag >= 2)
  800a28:	83 f9 01             	cmp    $0x1,%ecx
  800a2b:	7e 42                	jle    800a6f <vprintfmt+0x3ac>
		return va_arg(*ap, unsigned long long);
  800a2d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a30:	8b 50 04             	mov    0x4(%eax),%edx
  800a33:	8b 00                	mov    (%eax),%eax
  800a35:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a38:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a3b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a3e:	8d 40 08             	lea    0x8(%eax),%eax
  800a41:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800a44:	ba 08 00 00 00       	mov    $0x8,%edx
			if ((long long) num < 0) {
  800a49:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a4d:	0f 89 87 00 00 00    	jns    800ada <vprintfmt+0x417>
				putch('-', putdat);
  800a53:	83 ec 08             	sub    $0x8,%esp
  800a56:	53                   	push   %ebx
  800a57:	6a 2d                	push   $0x2d
  800a59:	ff d6                	call   *%esi
				num = -(long long) num;
  800a5b:	f7 5d d8             	negl   -0x28(%ebp)
  800a5e:	83 55 dc 00          	adcl   $0x0,-0x24(%ebp)
  800a62:	f7 5d dc             	negl   -0x24(%ebp)
  800a65:	83 c4 10             	add    $0x10,%esp
			base = 8;
  800a68:	ba 08 00 00 00       	mov    $0x8,%edx
  800a6d:	eb 6b                	jmp    800ada <vprintfmt+0x417>
	else if (lflag)
  800a6f:	85 c9                	test   %ecx,%ecx
  800a71:	75 1b                	jne    800a8e <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  800a73:	8b 45 14             	mov    0x14(%ebp),%eax
  800a76:	8b 00                	mov    (%eax),%eax
  800a78:	ba 00 00 00 00       	mov    $0x0,%edx
  800a7d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a80:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a83:	8b 45 14             	mov    0x14(%ebp),%eax
  800a86:	8d 40 04             	lea    0x4(%eax),%eax
  800a89:	89 45 14             	mov    %eax,0x14(%ebp)
  800a8c:	eb b6                	jmp    800a44 <vprintfmt+0x381>
		return va_arg(*ap, unsigned long);
  800a8e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a91:	8b 00                	mov    (%eax),%eax
  800a93:	ba 00 00 00 00       	mov    $0x0,%edx
  800a98:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a9b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a9e:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa1:	8d 40 04             	lea    0x4(%eax),%eax
  800aa4:	89 45 14             	mov    %eax,0x14(%ebp)
  800aa7:	eb 9b                	jmp    800a44 <vprintfmt+0x381>
			putch('0', putdat);
  800aa9:	83 ec 08             	sub    $0x8,%esp
  800aac:	53                   	push   %ebx
  800aad:	6a 30                	push   $0x30
  800aaf:	ff d6                	call   *%esi
			putch('x', putdat);
  800ab1:	83 c4 08             	add    $0x8,%esp
  800ab4:	53                   	push   %ebx
  800ab5:	6a 78                	push   $0x78
  800ab7:	ff d6                	call   *%esi
			num = (unsigned long long)
  800ab9:	8b 45 14             	mov    0x14(%ebp),%eax
  800abc:	8b 00                	mov    (%eax),%eax
  800abe:	ba 00 00 00 00       	mov    $0x0,%edx
  800ac3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ac6:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800ac9:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800acc:	8b 45 14             	mov    0x14(%ebp),%eax
  800acf:	8d 40 04             	lea    0x4(%eax),%eax
  800ad2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800ad5:	ba 10 00 00 00       	mov    $0x10,%edx
			printnum(putch, putdat, num, base, width, padc);
  800ada:	83 ec 0c             	sub    $0xc,%esp
  800add:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800ae1:	50                   	push   %eax
  800ae2:	ff 75 e0             	pushl  -0x20(%ebp)
  800ae5:	52                   	push   %edx
  800ae6:	ff 75 dc             	pushl  -0x24(%ebp)
  800ae9:	ff 75 d8             	pushl  -0x28(%ebp)
  800aec:	89 da                	mov    %ebx,%edx
  800aee:	89 f0                	mov    %esi,%eax
  800af0:	e8 e5 fa ff ff       	call   8005da <printnum>
			break;
  800af5:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800af8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800afb:	83 c7 01             	add    $0x1,%edi
  800afe:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800b02:	83 f8 25             	cmp    $0x25,%eax
  800b05:	0f 84 cf fb ff ff    	je     8006da <vprintfmt+0x17>
			if (ch == '\0')
  800b0b:	85 c0                	test   %eax,%eax
  800b0d:	0f 84 a9 00 00 00    	je     800bbc <vprintfmt+0x4f9>
			putch(ch, putdat);
  800b13:	83 ec 08             	sub    $0x8,%esp
  800b16:	53                   	push   %ebx
  800b17:	50                   	push   %eax
  800b18:	ff d6                	call   *%esi
  800b1a:	83 c4 10             	add    $0x10,%esp
  800b1d:	eb dc                	jmp    800afb <vprintfmt+0x438>
	if (lflag >= 2)
  800b1f:	83 f9 01             	cmp    $0x1,%ecx
  800b22:	7e 1e                	jle    800b42 <vprintfmt+0x47f>
		return va_arg(*ap, unsigned long long);
  800b24:	8b 45 14             	mov    0x14(%ebp),%eax
  800b27:	8b 50 04             	mov    0x4(%eax),%edx
  800b2a:	8b 00                	mov    (%eax),%eax
  800b2c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b2f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b32:	8b 45 14             	mov    0x14(%ebp),%eax
  800b35:	8d 40 08             	lea    0x8(%eax),%eax
  800b38:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800b3b:	ba 10 00 00 00       	mov    $0x10,%edx
  800b40:	eb 98                	jmp    800ada <vprintfmt+0x417>
	else if (lflag)
  800b42:	85 c9                	test   %ecx,%ecx
  800b44:	75 23                	jne    800b69 <vprintfmt+0x4a6>
		return va_arg(*ap, unsigned int);
  800b46:	8b 45 14             	mov    0x14(%ebp),%eax
  800b49:	8b 00                	mov    (%eax),%eax
  800b4b:	ba 00 00 00 00       	mov    $0x0,%edx
  800b50:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b53:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b56:	8b 45 14             	mov    0x14(%ebp),%eax
  800b59:	8d 40 04             	lea    0x4(%eax),%eax
  800b5c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800b5f:	ba 10 00 00 00       	mov    $0x10,%edx
  800b64:	e9 71 ff ff ff       	jmp    800ada <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  800b69:	8b 45 14             	mov    0x14(%ebp),%eax
  800b6c:	8b 00                	mov    (%eax),%eax
  800b6e:	ba 00 00 00 00       	mov    $0x0,%edx
  800b73:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b76:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b79:	8b 45 14             	mov    0x14(%ebp),%eax
  800b7c:	8d 40 04             	lea    0x4(%eax),%eax
  800b7f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800b82:	ba 10 00 00 00       	mov    $0x10,%edx
  800b87:	e9 4e ff ff ff       	jmp    800ada <vprintfmt+0x417>
			putch(ch, putdat);
  800b8c:	83 ec 08             	sub    $0x8,%esp
  800b8f:	53                   	push   %ebx
  800b90:	6a 25                	push   $0x25
  800b92:	ff d6                	call   *%esi
			break;
  800b94:	83 c4 10             	add    $0x10,%esp
  800b97:	e9 5c ff ff ff       	jmp    800af8 <vprintfmt+0x435>
			putch('%', putdat);
  800b9c:	83 ec 08             	sub    $0x8,%esp
  800b9f:	53                   	push   %ebx
  800ba0:	6a 25                	push   $0x25
  800ba2:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ba4:	83 c4 10             	add    $0x10,%esp
  800ba7:	89 f8                	mov    %edi,%eax
  800ba9:	eb 03                	jmp    800bae <vprintfmt+0x4eb>
  800bab:	83 e8 01             	sub    $0x1,%eax
  800bae:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800bb2:	75 f7                	jne    800bab <vprintfmt+0x4e8>
  800bb4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800bb7:	e9 3c ff ff ff       	jmp    800af8 <vprintfmt+0x435>
}
  800bbc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bbf:	5b                   	pop    %ebx
  800bc0:	5e                   	pop    %esi
  800bc1:	5f                   	pop    %edi
  800bc2:	5d                   	pop    %ebp
  800bc3:	c3                   	ret    

00800bc4 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800bc4:	55                   	push   %ebp
  800bc5:	89 e5                	mov    %esp,%ebp
  800bc7:	83 ec 18             	sub    $0x18,%esp
  800bca:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcd:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800bd0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800bd3:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800bd7:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800bda:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800be1:	85 c0                	test   %eax,%eax
  800be3:	74 26                	je     800c0b <vsnprintf+0x47>
  800be5:	85 d2                	test   %edx,%edx
  800be7:	7e 22                	jle    800c0b <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800be9:	ff 75 14             	pushl  0x14(%ebp)
  800bec:	ff 75 10             	pushl  0x10(%ebp)
  800bef:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bf2:	50                   	push   %eax
  800bf3:	68 89 06 80 00       	push   $0x800689
  800bf8:	e8 c6 fa ff ff       	call   8006c3 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800bfd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c00:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c06:	83 c4 10             	add    $0x10,%esp
}
  800c09:	c9                   	leave  
  800c0a:	c3                   	ret    
		return -E_INVAL;
  800c0b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c10:	eb f7                	jmp    800c09 <vsnprintf+0x45>

00800c12 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c12:	55                   	push   %ebp
  800c13:	89 e5                	mov    %esp,%ebp
  800c15:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c18:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800c1b:	50                   	push   %eax
  800c1c:	ff 75 10             	pushl  0x10(%ebp)
  800c1f:	ff 75 0c             	pushl  0xc(%ebp)
  800c22:	ff 75 08             	pushl  0x8(%ebp)
  800c25:	e8 9a ff ff ff       	call   800bc4 <vsnprintf>
	va_end(ap);

	return rc;
}
  800c2a:	c9                   	leave  
  800c2b:	c3                   	ret    

00800c2c <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800c2c:	55                   	push   %ebp
  800c2d:	89 e5                	mov    %esp,%ebp
  800c2f:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800c32:	b8 00 00 00 00       	mov    $0x0,%eax
  800c37:	eb 03                	jmp    800c3c <strlen+0x10>
		n++;
  800c39:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800c3c:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800c40:	75 f7                	jne    800c39 <strlen+0xd>
	return n;
}
  800c42:	5d                   	pop    %ebp
  800c43:	c3                   	ret    

00800c44 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800c44:	55                   	push   %ebp
  800c45:	89 e5                	mov    %esp,%ebp
  800c47:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c4a:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c4d:	b8 00 00 00 00       	mov    $0x0,%eax
  800c52:	eb 03                	jmp    800c57 <strnlen+0x13>
		n++;
  800c54:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c57:	39 d0                	cmp    %edx,%eax
  800c59:	74 06                	je     800c61 <strnlen+0x1d>
  800c5b:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800c5f:	75 f3                	jne    800c54 <strnlen+0x10>
	return n;
}
  800c61:	5d                   	pop    %ebp
  800c62:	c3                   	ret    

00800c63 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c63:	55                   	push   %ebp
  800c64:	89 e5                	mov    %esp,%ebp
  800c66:	53                   	push   %ebx
  800c67:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800c6d:	89 c2                	mov    %eax,%edx
  800c6f:	83 c1 01             	add    $0x1,%ecx
  800c72:	83 c2 01             	add    $0x1,%edx
  800c75:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800c79:	88 5a ff             	mov    %bl,-0x1(%edx)
  800c7c:	84 db                	test   %bl,%bl
  800c7e:	75 ef                	jne    800c6f <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800c80:	5b                   	pop    %ebx
  800c81:	5d                   	pop    %ebp
  800c82:	c3                   	ret    

00800c83 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800c83:	55                   	push   %ebp
  800c84:	89 e5                	mov    %esp,%ebp
  800c86:	53                   	push   %ebx
  800c87:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800c8a:	53                   	push   %ebx
  800c8b:	e8 9c ff ff ff       	call   800c2c <strlen>
  800c90:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800c93:	ff 75 0c             	pushl  0xc(%ebp)
  800c96:	01 d8                	add    %ebx,%eax
  800c98:	50                   	push   %eax
  800c99:	e8 c5 ff ff ff       	call   800c63 <strcpy>
	return dst;
}
  800c9e:	89 d8                	mov    %ebx,%eax
  800ca0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ca3:	c9                   	leave  
  800ca4:	c3                   	ret    

00800ca5 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800ca5:	55                   	push   %ebp
  800ca6:	89 e5                	mov    %esp,%ebp
  800ca8:	56                   	push   %esi
  800ca9:	53                   	push   %ebx
  800caa:	8b 75 08             	mov    0x8(%ebp),%esi
  800cad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cb0:	89 f3                	mov    %esi,%ebx
  800cb2:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800cb5:	89 f2                	mov    %esi,%edx
  800cb7:	eb 0f                	jmp    800cc8 <strncpy+0x23>
		*dst++ = *src;
  800cb9:	83 c2 01             	add    $0x1,%edx
  800cbc:	0f b6 01             	movzbl (%ecx),%eax
  800cbf:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800cc2:	80 39 01             	cmpb   $0x1,(%ecx)
  800cc5:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800cc8:	39 da                	cmp    %ebx,%edx
  800cca:	75 ed                	jne    800cb9 <strncpy+0x14>
	}
	return ret;
}
  800ccc:	89 f0                	mov    %esi,%eax
  800cce:	5b                   	pop    %ebx
  800ccf:	5e                   	pop    %esi
  800cd0:	5d                   	pop    %ebp
  800cd1:	c3                   	ret    

00800cd2 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800cd2:	55                   	push   %ebp
  800cd3:	89 e5                	mov    %esp,%ebp
  800cd5:	56                   	push   %esi
  800cd6:	53                   	push   %ebx
  800cd7:	8b 75 08             	mov    0x8(%ebp),%esi
  800cda:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cdd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800ce0:	89 f0                	mov    %esi,%eax
  800ce2:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800ce6:	85 c9                	test   %ecx,%ecx
  800ce8:	75 0b                	jne    800cf5 <strlcpy+0x23>
  800cea:	eb 17                	jmp    800d03 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800cec:	83 c2 01             	add    $0x1,%edx
  800cef:	83 c0 01             	add    $0x1,%eax
  800cf2:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800cf5:	39 d8                	cmp    %ebx,%eax
  800cf7:	74 07                	je     800d00 <strlcpy+0x2e>
  800cf9:	0f b6 0a             	movzbl (%edx),%ecx
  800cfc:	84 c9                	test   %cl,%cl
  800cfe:	75 ec                	jne    800cec <strlcpy+0x1a>
		*dst = '\0';
  800d00:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d03:	29 f0                	sub    %esi,%eax
}
  800d05:	5b                   	pop    %ebx
  800d06:	5e                   	pop    %esi
  800d07:	5d                   	pop    %ebp
  800d08:	c3                   	ret    

00800d09 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d09:	55                   	push   %ebp
  800d0a:	89 e5                	mov    %esp,%ebp
  800d0c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d0f:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800d12:	eb 06                	jmp    800d1a <strcmp+0x11>
		p++, q++;
  800d14:	83 c1 01             	add    $0x1,%ecx
  800d17:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800d1a:	0f b6 01             	movzbl (%ecx),%eax
  800d1d:	84 c0                	test   %al,%al
  800d1f:	74 04                	je     800d25 <strcmp+0x1c>
  800d21:	3a 02                	cmp    (%edx),%al
  800d23:	74 ef                	je     800d14 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d25:	0f b6 c0             	movzbl %al,%eax
  800d28:	0f b6 12             	movzbl (%edx),%edx
  800d2b:	29 d0                	sub    %edx,%eax
}
  800d2d:	5d                   	pop    %ebp
  800d2e:	c3                   	ret    

00800d2f <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800d2f:	55                   	push   %ebp
  800d30:	89 e5                	mov    %esp,%ebp
  800d32:	53                   	push   %ebx
  800d33:	8b 45 08             	mov    0x8(%ebp),%eax
  800d36:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d39:	89 c3                	mov    %eax,%ebx
  800d3b:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800d3e:	eb 06                	jmp    800d46 <strncmp+0x17>
		n--, p++, q++;
  800d40:	83 c0 01             	add    $0x1,%eax
  800d43:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800d46:	39 d8                	cmp    %ebx,%eax
  800d48:	74 16                	je     800d60 <strncmp+0x31>
  800d4a:	0f b6 08             	movzbl (%eax),%ecx
  800d4d:	84 c9                	test   %cl,%cl
  800d4f:	74 04                	je     800d55 <strncmp+0x26>
  800d51:	3a 0a                	cmp    (%edx),%cl
  800d53:	74 eb                	je     800d40 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d55:	0f b6 00             	movzbl (%eax),%eax
  800d58:	0f b6 12             	movzbl (%edx),%edx
  800d5b:	29 d0                	sub    %edx,%eax
}
  800d5d:	5b                   	pop    %ebx
  800d5e:	5d                   	pop    %ebp
  800d5f:	c3                   	ret    
		return 0;
  800d60:	b8 00 00 00 00       	mov    $0x0,%eax
  800d65:	eb f6                	jmp    800d5d <strncmp+0x2e>

00800d67 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d67:	55                   	push   %ebp
  800d68:	89 e5                	mov    %esp,%ebp
  800d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d71:	0f b6 10             	movzbl (%eax),%edx
  800d74:	84 d2                	test   %dl,%dl
  800d76:	74 09                	je     800d81 <strchr+0x1a>
		if (*s == c)
  800d78:	38 ca                	cmp    %cl,%dl
  800d7a:	74 0a                	je     800d86 <strchr+0x1f>
	for (; *s; s++)
  800d7c:	83 c0 01             	add    $0x1,%eax
  800d7f:	eb f0                	jmp    800d71 <strchr+0xa>
			return (char *) s;
	return 0;
  800d81:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d86:	5d                   	pop    %ebp
  800d87:	c3                   	ret    

00800d88 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d88:	55                   	push   %ebp
  800d89:	89 e5                	mov    %esp,%ebp
  800d8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d92:	eb 03                	jmp    800d97 <strfind+0xf>
  800d94:	83 c0 01             	add    $0x1,%eax
  800d97:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800d9a:	38 ca                	cmp    %cl,%dl
  800d9c:	74 04                	je     800da2 <strfind+0x1a>
  800d9e:	84 d2                	test   %dl,%dl
  800da0:	75 f2                	jne    800d94 <strfind+0xc>
			break;
	return (char *) s;
}
  800da2:	5d                   	pop    %ebp
  800da3:	c3                   	ret    

00800da4 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800da4:	55                   	push   %ebp
  800da5:	89 e5                	mov    %esp,%ebp
  800da7:	57                   	push   %edi
  800da8:	56                   	push   %esi
  800da9:	53                   	push   %ebx
  800daa:	8b 7d 08             	mov    0x8(%ebp),%edi
  800dad:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800db0:	85 c9                	test   %ecx,%ecx
  800db2:	74 13                	je     800dc7 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800db4:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800dba:	75 05                	jne    800dc1 <memset+0x1d>
  800dbc:	f6 c1 03             	test   $0x3,%cl
  800dbf:	74 0d                	je     800dce <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800dc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc4:	fc                   	cld    
  800dc5:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800dc7:	89 f8                	mov    %edi,%eax
  800dc9:	5b                   	pop    %ebx
  800dca:	5e                   	pop    %esi
  800dcb:	5f                   	pop    %edi
  800dcc:	5d                   	pop    %ebp
  800dcd:	c3                   	ret    
		c &= 0xFF;
  800dce:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800dd2:	89 d3                	mov    %edx,%ebx
  800dd4:	c1 e3 08             	shl    $0x8,%ebx
  800dd7:	89 d0                	mov    %edx,%eax
  800dd9:	c1 e0 18             	shl    $0x18,%eax
  800ddc:	89 d6                	mov    %edx,%esi
  800dde:	c1 e6 10             	shl    $0x10,%esi
  800de1:	09 f0                	or     %esi,%eax
  800de3:	09 c2                	or     %eax,%edx
  800de5:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800de7:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800dea:	89 d0                	mov    %edx,%eax
  800dec:	fc                   	cld    
  800ded:	f3 ab                	rep stos %eax,%es:(%edi)
  800def:	eb d6                	jmp    800dc7 <memset+0x23>

00800df1 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800df1:	55                   	push   %ebp
  800df2:	89 e5                	mov    %esp,%ebp
  800df4:	57                   	push   %edi
  800df5:	56                   	push   %esi
  800df6:	8b 45 08             	mov    0x8(%ebp),%eax
  800df9:	8b 75 0c             	mov    0xc(%ebp),%esi
  800dfc:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800dff:	39 c6                	cmp    %eax,%esi
  800e01:	73 35                	jae    800e38 <memmove+0x47>
  800e03:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800e06:	39 c2                	cmp    %eax,%edx
  800e08:	76 2e                	jbe    800e38 <memmove+0x47>
		s += n;
		d += n;
  800e0a:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800e0d:	89 d6                	mov    %edx,%esi
  800e0f:	09 fe                	or     %edi,%esi
  800e11:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800e17:	74 0c                	je     800e25 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800e19:	83 ef 01             	sub    $0x1,%edi
  800e1c:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800e1f:	fd                   	std    
  800e20:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800e22:	fc                   	cld    
  800e23:	eb 21                	jmp    800e46 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800e25:	f6 c1 03             	test   $0x3,%cl
  800e28:	75 ef                	jne    800e19 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800e2a:	83 ef 04             	sub    $0x4,%edi
  800e2d:	8d 72 fc             	lea    -0x4(%edx),%esi
  800e30:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800e33:	fd                   	std    
  800e34:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800e36:	eb ea                	jmp    800e22 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800e38:	89 f2                	mov    %esi,%edx
  800e3a:	09 c2                	or     %eax,%edx
  800e3c:	f6 c2 03             	test   $0x3,%dl
  800e3f:	74 09                	je     800e4a <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800e41:	89 c7                	mov    %eax,%edi
  800e43:	fc                   	cld    
  800e44:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800e46:	5e                   	pop    %esi
  800e47:	5f                   	pop    %edi
  800e48:	5d                   	pop    %ebp
  800e49:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800e4a:	f6 c1 03             	test   $0x3,%cl
  800e4d:	75 f2                	jne    800e41 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800e4f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800e52:	89 c7                	mov    %eax,%edi
  800e54:	fc                   	cld    
  800e55:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800e57:	eb ed                	jmp    800e46 <memmove+0x55>

00800e59 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800e59:	55                   	push   %ebp
  800e5a:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800e5c:	ff 75 10             	pushl  0x10(%ebp)
  800e5f:	ff 75 0c             	pushl  0xc(%ebp)
  800e62:	ff 75 08             	pushl  0x8(%ebp)
  800e65:	e8 87 ff ff ff       	call   800df1 <memmove>
}
  800e6a:	c9                   	leave  
  800e6b:	c3                   	ret    

00800e6c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800e6c:	55                   	push   %ebp
  800e6d:	89 e5                	mov    %esp,%ebp
  800e6f:	56                   	push   %esi
  800e70:	53                   	push   %ebx
  800e71:	8b 45 08             	mov    0x8(%ebp),%eax
  800e74:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e77:	89 c6                	mov    %eax,%esi
  800e79:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800e7c:	39 f0                	cmp    %esi,%eax
  800e7e:	74 1c                	je     800e9c <memcmp+0x30>
		if (*s1 != *s2)
  800e80:	0f b6 08             	movzbl (%eax),%ecx
  800e83:	0f b6 1a             	movzbl (%edx),%ebx
  800e86:	38 d9                	cmp    %bl,%cl
  800e88:	75 08                	jne    800e92 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800e8a:	83 c0 01             	add    $0x1,%eax
  800e8d:	83 c2 01             	add    $0x1,%edx
  800e90:	eb ea                	jmp    800e7c <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800e92:	0f b6 c1             	movzbl %cl,%eax
  800e95:	0f b6 db             	movzbl %bl,%ebx
  800e98:	29 d8                	sub    %ebx,%eax
  800e9a:	eb 05                	jmp    800ea1 <memcmp+0x35>
	}

	return 0;
  800e9c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ea1:	5b                   	pop    %ebx
  800ea2:	5e                   	pop    %esi
  800ea3:	5d                   	pop    %ebp
  800ea4:	c3                   	ret    

00800ea5 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ea5:	55                   	push   %ebp
  800ea6:	89 e5                	mov    %esp,%ebp
  800ea8:	8b 45 08             	mov    0x8(%ebp),%eax
  800eab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800eae:	89 c2                	mov    %eax,%edx
  800eb0:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800eb3:	39 d0                	cmp    %edx,%eax
  800eb5:	73 09                	jae    800ec0 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800eb7:	38 08                	cmp    %cl,(%eax)
  800eb9:	74 05                	je     800ec0 <memfind+0x1b>
	for (; s < ends; s++)
  800ebb:	83 c0 01             	add    $0x1,%eax
  800ebe:	eb f3                	jmp    800eb3 <memfind+0xe>
			break;
	return (void *) s;
}
  800ec0:	5d                   	pop    %ebp
  800ec1:	c3                   	ret    

00800ec2 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ec2:	55                   	push   %ebp
  800ec3:	89 e5                	mov    %esp,%ebp
  800ec5:	57                   	push   %edi
  800ec6:	56                   	push   %esi
  800ec7:	53                   	push   %ebx
  800ec8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ecb:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ece:	eb 03                	jmp    800ed3 <strtol+0x11>
		s++;
  800ed0:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800ed3:	0f b6 01             	movzbl (%ecx),%eax
  800ed6:	3c 20                	cmp    $0x20,%al
  800ed8:	74 f6                	je     800ed0 <strtol+0xe>
  800eda:	3c 09                	cmp    $0x9,%al
  800edc:	74 f2                	je     800ed0 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800ede:	3c 2b                	cmp    $0x2b,%al
  800ee0:	74 2e                	je     800f10 <strtol+0x4e>
	int neg = 0;
  800ee2:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800ee7:	3c 2d                	cmp    $0x2d,%al
  800ee9:	74 2f                	je     800f1a <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800eeb:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800ef1:	75 05                	jne    800ef8 <strtol+0x36>
  800ef3:	80 39 30             	cmpb   $0x30,(%ecx)
  800ef6:	74 2c                	je     800f24 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800ef8:	85 db                	test   %ebx,%ebx
  800efa:	75 0a                	jne    800f06 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800efc:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800f01:	80 39 30             	cmpb   $0x30,(%ecx)
  800f04:	74 28                	je     800f2e <strtol+0x6c>
		base = 10;
  800f06:	b8 00 00 00 00       	mov    $0x0,%eax
  800f0b:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800f0e:	eb 50                	jmp    800f60 <strtol+0x9e>
		s++;
  800f10:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800f13:	bf 00 00 00 00       	mov    $0x0,%edi
  800f18:	eb d1                	jmp    800eeb <strtol+0x29>
		s++, neg = 1;
  800f1a:	83 c1 01             	add    $0x1,%ecx
  800f1d:	bf 01 00 00 00       	mov    $0x1,%edi
  800f22:	eb c7                	jmp    800eeb <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f24:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800f28:	74 0e                	je     800f38 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800f2a:	85 db                	test   %ebx,%ebx
  800f2c:	75 d8                	jne    800f06 <strtol+0x44>
		s++, base = 8;
  800f2e:	83 c1 01             	add    $0x1,%ecx
  800f31:	bb 08 00 00 00       	mov    $0x8,%ebx
  800f36:	eb ce                	jmp    800f06 <strtol+0x44>
		s += 2, base = 16;
  800f38:	83 c1 02             	add    $0x2,%ecx
  800f3b:	bb 10 00 00 00       	mov    $0x10,%ebx
  800f40:	eb c4                	jmp    800f06 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800f42:	8d 72 9f             	lea    -0x61(%edx),%esi
  800f45:	89 f3                	mov    %esi,%ebx
  800f47:	80 fb 19             	cmp    $0x19,%bl
  800f4a:	77 29                	ja     800f75 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800f4c:	0f be d2             	movsbl %dl,%edx
  800f4f:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800f52:	3b 55 10             	cmp    0x10(%ebp),%edx
  800f55:	7d 30                	jge    800f87 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800f57:	83 c1 01             	add    $0x1,%ecx
  800f5a:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f5e:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800f60:	0f b6 11             	movzbl (%ecx),%edx
  800f63:	8d 72 d0             	lea    -0x30(%edx),%esi
  800f66:	89 f3                	mov    %esi,%ebx
  800f68:	80 fb 09             	cmp    $0x9,%bl
  800f6b:	77 d5                	ja     800f42 <strtol+0x80>
			dig = *s - '0';
  800f6d:	0f be d2             	movsbl %dl,%edx
  800f70:	83 ea 30             	sub    $0x30,%edx
  800f73:	eb dd                	jmp    800f52 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800f75:	8d 72 bf             	lea    -0x41(%edx),%esi
  800f78:	89 f3                	mov    %esi,%ebx
  800f7a:	80 fb 19             	cmp    $0x19,%bl
  800f7d:	77 08                	ja     800f87 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800f7f:	0f be d2             	movsbl %dl,%edx
  800f82:	83 ea 37             	sub    $0x37,%edx
  800f85:	eb cb                	jmp    800f52 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800f87:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f8b:	74 05                	je     800f92 <strtol+0xd0>
		*endptr = (char *) s;
  800f8d:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f90:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800f92:	89 c2                	mov    %eax,%edx
  800f94:	f7 da                	neg    %edx
  800f96:	85 ff                	test   %edi,%edi
  800f98:	0f 45 c2             	cmovne %edx,%eax
}
  800f9b:	5b                   	pop    %ebx
  800f9c:	5e                   	pop    %esi
  800f9d:	5f                   	pop    %edi
  800f9e:	5d                   	pop    %ebp
  800f9f:	c3                   	ret    

00800fa0 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800fa0:	55                   	push   %ebp
  800fa1:	89 e5                	mov    %esp,%ebp
  800fa3:	57                   	push   %edi
  800fa4:	56                   	push   %esi
  800fa5:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fa6:	b8 00 00 00 00       	mov    $0x0,%eax
  800fab:	8b 55 08             	mov    0x8(%ebp),%edx
  800fae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fb1:	89 c3                	mov    %eax,%ebx
  800fb3:	89 c7                	mov    %eax,%edi
  800fb5:	89 c6                	mov    %eax,%esi
  800fb7:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800fb9:	5b                   	pop    %ebx
  800fba:	5e                   	pop    %esi
  800fbb:	5f                   	pop    %edi
  800fbc:	5d                   	pop    %ebp
  800fbd:	c3                   	ret    

00800fbe <sys_cgetc>:

int
sys_cgetc(void)
{
  800fbe:	55                   	push   %ebp
  800fbf:	89 e5                	mov    %esp,%ebp
  800fc1:	57                   	push   %edi
  800fc2:	56                   	push   %esi
  800fc3:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fc4:	ba 00 00 00 00       	mov    $0x0,%edx
  800fc9:	b8 01 00 00 00       	mov    $0x1,%eax
  800fce:	89 d1                	mov    %edx,%ecx
  800fd0:	89 d3                	mov    %edx,%ebx
  800fd2:	89 d7                	mov    %edx,%edi
  800fd4:	89 d6                	mov    %edx,%esi
  800fd6:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800fd8:	5b                   	pop    %ebx
  800fd9:	5e                   	pop    %esi
  800fda:	5f                   	pop    %edi
  800fdb:	5d                   	pop    %ebp
  800fdc:	c3                   	ret    

00800fdd <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800fdd:	55                   	push   %ebp
  800fde:	89 e5                	mov    %esp,%ebp
  800fe0:	57                   	push   %edi
  800fe1:	56                   	push   %esi
  800fe2:	53                   	push   %ebx
  800fe3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fe6:	b9 00 00 00 00       	mov    $0x0,%ecx
  800feb:	8b 55 08             	mov    0x8(%ebp),%edx
  800fee:	b8 03 00 00 00       	mov    $0x3,%eax
  800ff3:	89 cb                	mov    %ecx,%ebx
  800ff5:	89 cf                	mov    %ecx,%edi
  800ff7:	89 ce                	mov    %ecx,%esi
  800ff9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ffb:	85 c0                	test   %eax,%eax
  800ffd:	7f 08                	jg     801007 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800fff:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801002:	5b                   	pop    %ebx
  801003:	5e                   	pop    %esi
  801004:	5f                   	pop    %edi
  801005:	5d                   	pop    %ebp
  801006:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801007:	83 ec 0c             	sub    $0xc,%esp
  80100a:	50                   	push   %eax
  80100b:	6a 03                	push   $0x3
  80100d:	68 df 2b 80 00       	push   $0x802bdf
  801012:	6a 23                	push   $0x23
  801014:	68 fc 2b 80 00       	push   $0x802bfc
  801019:	e8 ad 13 00 00       	call   8023cb <_panic>

0080101e <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80101e:	55                   	push   %ebp
  80101f:	89 e5                	mov    %esp,%ebp
  801021:	57                   	push   %edi
  801022:	56                   	push   %esi
  801023:	53                   	push   %ebx
	asm volatile("int %1\n"
  801024:	ba 00 00 00 00       	mov    $0x0,%edx
  801029:	b8 02 00 00 00       	mov    $0x2,%eax
  80102e:	89 d1                	mov    %edx,%ecx
  801030:	89 d3                	mov    %edx,%ebx
  801032:	89 d7                	mov    %edx,%edi
  801034:	89 d6                	mov    %edx,%esi
  801036:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801038:	5b                   	pop    %ebx
  801039:	5e                   	pop    %esi
  80103a:	5f                   	pop    %edi
  80103b:	5d                   	pop    %ebp
  80103c:	c3                   	ret    

0080103d <sys_yield>:

void
sys_yield(void)
{
  80103d:	55                   	push   %ebp
  80103e:	89 e5                	mov    %esp,%ebp
  801040:	57                   	push   %edi
  801041:	56                   	push   %esi
  801042:	53                   	push   %ebx
	asm volatile("int %1\n"
  801043:	ba 00 00 00 00       	mov    $0x0,%edx
  801048:	b8 0b 00 00 00       	mov    $0xb,%eax
  80104d:	89 d1                	mov    %edx,%ecx
  80104f:	89 d3                	mov    %edx,%ebx
  801051:	89 d7                	mov    %edx,%edi
  801053:	89 d6                	mov    %edx,%esi
  801055:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801057:	5b                   	pop    %ebx
  801058:	5e                   	pop    %esi
  801059:	5f                   	pop    %edi
  80105a:	5d                   	pop    %ebp
  80105b:	c3                   	ret    

0080105c <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80105c:	55                   	push   %ebp
  80105d:	89 e5                	mov    %esp,%ebp
  80105f:	57                   	push   %edi
  801060:	56                   	push   %esi
  801061:	53                   	push   %ebx
  801062:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801065:	be 00 00 00 00       	mov    $0x0,%esi
  80106a:	8b 55 08             	mov    0x8(%ebp),%edx
  80106d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801070:	b8 04 00 00 00       	mov    $0x4,%eax
  801075:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801078:	89 f7                	mov    %esi,%edi
  80107a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80107c:	85 c0                	test   %eax,%eax
  80107e:	7f 08                	jg     801088 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801080:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801083:	5b                   	pop    %ebx
  801084:	5e                   	pop    %esi
  801085:	5f                   	pop    %edi
  801086:	5d                   	pop    %ebp
  801087:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801088:	83 ec 0c             	sub    $0xc,%esp
  80108b:	50                   	push   %eax
  80108c:	6a 04                	push   $0x4
  80108e:	68 df 2b 80 00       	push   $0x802bdf
  801093:	6a 23                	push   $0x23
  801095:	68 fc 2b 80 00       	push   $0x802bfc
  80109a:	e8 2c 13 00 00       	call   8023cb <_panic>

0080109f <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80109f:	55                   	push   %ebp
  8010a0:	89 e5                	mov    %esp,%ebp
  8010a2:	57                   	push   %edi
  8010a3:	56                   	push   %esi
  8010a4:	53                   	push   %ebx
  8010a5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010ae:	b8 05 00 00 00       	mov    $0x5,%eax
  8010b3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010b6:	8b 7d 14             	mov    0x14(%ebp),%edi
  8010b9:	8b 75 18             	mov    0x18(%ebp),%esi
  8010bc:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010be:	85 c0                	test   %eax,%eax
  8010c0:	7f 08                	jg     8010ca <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8010c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010c5:	5b                   	pop    %ebx
  8010c6:	5e                   	pop    %esi
  8010c7:	5f                   	pop    %edi
  8010c8:	5d                   	pop    %ebp
  8010c9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010ca:	83 ec 0c             	sub    $0xc,%esp
  8010cd:	50                   	push   %eax
  8010ce:	6a 05                	push   $0x5
  8010d0:	68 df 2b 80 00       	push   $0x802bdf
  8010d5:	6a 23                	push   $0x23
  8010d7:	68 fc 2b 80 00       	push   $0x802bfc
  8010dc:	e8 ea 12 00 00       	call   8023cb <_panic>

008010e1 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8010e1:	55                   	push   %ebp
  8010e2:	89 e5                	mov    %esp,%ebp
  8010e4:	57                   	push   %edi
  8010e5:	56                   	push   %esi
  8010e6:	53                   	push   %ebx
  8010e7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010ea:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8010f2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010f5:	b8 06 00 00 00       	mov    $0x6,%eax
  8010fa:	89 df                	mov    %ebx,%edi
  8010fc:	89 de                	mov    %ebx,%esi
  8010fe:	cd 30                	int    $0x30
	if(check && ret > 0)
  801100:	85 c0                	test   %eax,%eax
  801102:	7f 08                	jg     80110c <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801104:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801107:	5b                   	pop    %ebx
  801108:	5e                   	pop    %esi
  801109:	5f                   	pop    %edi
  80110a:	5d                   	pop    %ebp
  80110b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80110c:	83 ec 0c             	sub    $0xc,%esp
  80110f:	50                   	push   %eax
  801110:	6a 06                	push   $0x6
  801112:	68 df 2b 80 00       	push   $0x802bdf
  801117:	6a 23                	push   $0x23
  801119:	68 fc 2b 80 00       	push   $0x802bfc
  80111e:	e8 a8 12 00 00       	call   8023cb <_panic>

00801123 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801123:	55                   	push   %ebp
  801124:	89 e5                	mov    %esp,%ebp
  801126:	57                   	push   %edi
  801127:	56                   	push   %esi
  801128:	53                   	push   %ebx
  801129:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80112c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801131:	8b 55 08             	mov    0x8(%ebp),%edx
  801134:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801137:	b8 08 00 00 00       	mov    $0x8,%eax
  80113c:	89 df                	mov    %ebx,%edi
  80113e:	89 de                	mov    %ebx,%esi
  801140:	cd 30                	int    $0x30
	if(check && ret > 0)
  801142:	85 c0                	test   %eax,%eax
  801144:	7f 08                	jg     80114e <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801146:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801149:	5b                   	pop    %ebx
  80114a:	5e                   	pop    %esi
  80114b:	5f                   	pop    %edi
  80114c:	5d                   	pop    %ebp
  80114d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80114e:	83 ec 0c             	sub    $0xc,%esp
  801151:	50                   	push   %eax
  801152:	6a 08                	push   $0x8
  801154:	68 df 2b 80 00       	push   $0x802bdf
  801159:	6a 23                	push   $0x23
  80115b:	68 fc 2b 80 00       	push   $0x802bfc
  801160:	e8 66 12 00 00       	call   8023cb <_panic>

00801165 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801165:	55                   	push   %ebp
  801166:	89 e5                	mov    %esp,%ebp
  801168:	57                   	push   %edi
  801169:	56                   	push   %esi
  80116a:	53                   	push   %ebx
  80116b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80116e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801173:	8b 55 08             	mov    0x8(%ebp),%edx
  801176:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801179:	b8 09 00 00 00       	mov    $0x9,%eax
  80117e:	89 df                	mov    %ebx,%edi
  801180:	89 de                	mov    %ebx,%esi
  801182:	cd 30                	int    $0x30
	if(check && ret > 0)
  801184:	85 c0                	test   %eax,%eax
  801186:	7f 08                	jg     801190 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801188:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80118b:	5b                   	pop    %ebx
  80118c:	5e                   	pop    %esi
  80118d:	5f                   	pop    %edi
  80118e:	5d                   	pop    %ebp
  80118f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801190:	83 ec 0c             	sub    $0xc,%esp
  801193:	50                   	push   %eax
  801194:	6a 09                	push   $0x9
  801196:	68 df 2b 80 00       	push   $0x802bdf
  80119b:	6a 23                	push   $0x23
  80119d:	68 fc 2b 80 00       	push   $0x802bfc
  8011a2:	e8 24 12 00 00       	call   8023cb <_panic>

008011a7 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8011a7:	55                   	push   %ebp
  8011a8:	89 e5                	mov    %esp,%ebp
  8011aa:	57                   	push   %edi
  8011ab:	56                   	push   %esi
  8011ac:	53                   	push   %ebx
  8011ad:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011b0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011b5:	8b 55 08             	mov    0x8(%ebp),%edx
  8011b8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011bb:	b8 0a 00 00 00       	mov    $0xa,%eax
  8011c0:	89 df                	mov    %ebx,%edi
  8011c2:	89 de                	mov    %ebx,%esi
  8011c4:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011c6:	85 c0                	test   %eax,%eax
  8011c8:	7f 08                	jg     8011d2 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8011ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011cd:	5b                   	pop    %ebx
  8011ce:	5e                   	pop    %esi
  8011cf:	5f                   	pop    %edi
  8011d0:	5d                   	pop    %ebp
  8011d1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011d2:	83 ec 0c             	sub    $0xc,%esp
  8011d5:	50                   	push   %eax
  8011d6:	6a 0a                	push   $0xa
  8011d8:	68 df 2b 80 00       	push   $0x802bdf
  8011dd:	6a 23                	push   $0x23
  8011df:	68 fc 2b 80 00       	push   $0x802bfc
  8011e4:	e8 e2 11 00 00       	call   8023cb <_panic>

008011e9 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8011e9:	55                   	push   %ebp
  8011ea:	89 e5                	mov    %esp,%ebp
  8011ec:	57                   	push   %edi
  8011ed:	56                   	push   %esi
  8011ee:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8011f2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011f5:	b8 0c 00 00 00       	mov    $0xc,%eax
  8011fa:	be 00 00 00 00       	mov    $0x0,%esi
  8011ff:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801202:	8b 7d 14             	mov    0x14(%ebp),%edi
  801205:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801207:	5b                   	pop    %ebx
  801208:	5e                   	pop    %esi
  801209:	5f                   	pop    %edi
  80120a:	5d                   	pop    %ebp
  80120b:	c3                   	ret    

0080120c <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80120c:	55                   	push   %ebp
  80120d:	89 e5                	mov    %esp,%ebp
  80120f:	57                   	push   %edi
  801210:	56                   	push   %esi
  801211:	53                   	push   %ebx
  801212:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801215:	b9 00 00 00 00       	mov    $0x0,%ecx
  80121a:	8b 55 08             	mov    0x8(%ebp),%edx
  80121d:	b8 0d 00 00 00       	mov    $0xd,%eax
  801222:	89 cb                	mov    %ecx,%ebx
  801224:	89 cf                	mov    %ecx,%edi
  801226:	89 ce                	mov    %ecx,%esi
  801228:	cd 30                	int    $0x30
	if(check && ret > 0)
  80122a:	85 c0                	test   %eax,%eax
  80122c:	7f 08                	jg     801236 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80122e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801231:	5b                   	pop    %ebx
  801232:	5e                   	pop    %esi
  801233:	5f                   	pop    %edi
  801234:	5d                   	pop    %ebp
  801235:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801236:	83 ec 0c             	sub    $0xc,%esp
  801239:	50                   	push   %eax
  80123a:	6a 0d                	push   $0xd
  80123c:	68 df 2b 80 00       	push   $0x802bdf
  801241:	6a 23                	push   $0x23
  801243:	68 fc 2b 80 00       	push   $0x802bfc
  801248:	e8 7e 11 00 00       	call   8023cb <_panic>

0080124d <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80124d:	55                   	push   %ebp
  80124e:	89 e5                	mov    %esp,%ebp
  801250:	57                   	push   %edi
  801251:	56                   	push   %esi
  801252:	53                   	push   %ebx
	asm volatile("int %1\n"
  801253:	ba 00 00 00 00       	mov    $0x0,%edx
  801258:	b8 0e 00 00 00       	mov    $0xe,%eax
  80125d:	89 d1                	mov    %edx,%ecx
  80125f:	89 d3                	mov    %edx,%ebx
  801261:	89 d7                	mov    %edx,%edi
  801263:	89 d6                	mov    %edx,%esi
  801265:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801267:	5b                   	pop    %ebx
  801268:	5e                   	pop    %esi
  801269:	5f                   	pop    %edi
  80126a:	5d                   	pop    %ebp
  80126b:	c3                   	ret    

0080126c <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80126c:	55                   	push   %ebp
  80126d:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80126f:	8b 45 08             	mov    0x8(%ebp),%eax
  801272:	05 00 00 00 30       	add    $0x30000000,%eax
  801277:	c1 e8 0c             	shr    $0xc,%eax
}
  80127a:	5d                   	pop    %ebp
  80127b:	c3                   	ret    

0080127c <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80127c:	55                   	push   %ebp
  80127d:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80127f:	8b 45 08             	mov    0x8(%ebp),%eax
  801282:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801287:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80128c:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801291:	5d                   	pop    %ebp
  801292:	c3                   	ret    

00801293 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801293:	55                   	push   %ebp
  801294:	89 e5                	mov    %esp,%ebp
  801296:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801299:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80129e:	89 c2                	mov    %eax,%edx
  8012a0:	c1 ea 16             	shr    $0x16,%edx
  8012a3:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8012aa:	f6 c2 01             	test   $0x1,%dl
  8012ad:	74 2a                	je     8012d9 <fd_alloc+0x46>
  8012af:	89 c2                	mov    %eax,%edx
  8012b1:	c1 ea 0c             	shr    $0xc,%edx
  8012b4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012bb:	f6 c2 01             	test   $0x1,%dl
  8012be:	74 19                	je     8012d9 <fd_alloc+0x46>
  8012c0:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8012c5:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8012ca:	75 d2                	jne    80129e <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8012cc:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8012d2:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8012d7:	eb 07                	jmp    8012e0 <fd_alloc+0x4d>
			*fd_store = fd;
  8012d9:	89 01                	mov    %eax,(%ecx)
			return 0;
  8012db:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012e0:	5d                   	pop    %ebp
  8012e1:	c3                   	ret    

008012e2 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8012e2:	55                   	push   %ebp
  8012e3:	89 e5                	mov    %esp,%ebp
  8012e5:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8012e8:	83 f8 1f             	cmp    $0x1f,%eax
  8012eb:	77 36                	ja     801323 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8012ed:	c1 e0 0c             	shl    $0xc,%eax
  8012f0:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8012f5:	89 c2                	mov    %eax,%edx
  8012f7:	c1 ea 16             	shr    $0x16,%edx
  8012fa:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801301:	f6 c2 01             	test   $0x1,%dl
  801304:	74 24                	je     80132a <fd_lookup+0x48>
  801306:	89 c2                	mov    %eax,%edx
  801308:	c1 ea 0c             	shr    $0xc,%edx
  80130b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801312:	f6 c2 01             	test   $0x1,%dl
  801315:	74 1a                	je     801331 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801317:	8b 55 0c             	mov    0xc(%ebp),%edx
  80131a:	89 02                	mov    %eax,(%edx)
	return 0;
  80131c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801321:	5d                   	pop    %ebp
  801322:	c3                   	ret    
		return -E_INVAL;
  801323:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801328:	eb f7                	jmp    801321 <fd_lookup+0x3f>
		return -E_INVAL;
  80132a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80132f:	eb f0                	jmp    801321 <fd_lookup+0x3f>
  801331:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801336:	eb e9                	jmp    801321 <fd_lookup+0x3f>

00801338 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801338:	55                   	push   %ebp
  801339:	89 e5                	mov    %esp,%ebp
  80133b:	83 ec 08             	sub    $0x8,%esp
  80133e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801341:	ba 88 2c 80 00       	mov    $0x802c88,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801346:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80134b:	39 08                	cmp    %ecx,(%eax)
  80134d:	74 33                	je     801382 <dev_lookup+0x4a>
  80134f:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801352:	8b 02                	mov    (%edx),%eax
  801354:	85 c0                	test   %eax,%eax
  801356:	75 f3                	jne    80134b <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801358:	a1 18 40 80 00       	mov    0x804018,%eax
  80135d:	8b 40 48             	mov    0x48(%eax),%eax
  801360:	83 ec 04             	sub    $0x4,%esp
  801363:	51                   	push   %ecx
  801364:	50                   	push   %eax
  801365:	68 0c 2c 80 00       	push   $0x802c0c
  80136a:	e8 57 f2 ff ff       	call   8005c6 <cprintf>
	*dev = 0;
  80136f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801372:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801378:	83 c4 10             	add    $0x10,%esp
  80137b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801380:	c9                   	leave  
  801381:	c3                   	ret    
			*dev = devtab[i];
  801382:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801385:	89 01                	mov    %eax,(%ecx)
			return 0;
  801387:	b8 00 00 00 00       	mov    $0x0,%eax
  80138c:	eb f2                	jmp    801380 <dev_lookup+0x48>

0080138e <fd_close>:
{
  80138e:	55                   	push   %ebp
  80138f:	89 e5                	mov    %esp,%ebp
  801391:	57                   	push   %edi
  801392:	56                   	push   %esi
  801393:	53                   	push   %ebx
  801394:	83 ec 1c             	sub    $0x1c,%esp
  801397:	8b 75 08             	mov    0x8(%ebp),%esi
  80139a:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80139d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8013a0:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013a1:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8013a7:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8013aa:	50                   	push   %eax
  8013ab:	e8 32 ff ff ff       	call   8012e2 <fd_lookup>
  8013b0:	89 c3                	mov    %eax,%ebx
  8013b2:	83 c4 08             	add    $0x8,%esp
  8013b5:	85 c0                	test   %eax,%eax
  8013b7:	78 05                	js     8013be <fd_close+0x30>
	    || fd != fd2)
  8013b9:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8013bc:	74 16                	je     8013d4 <fd_close+0x46>
		return (must_exist ? r : 0);
  8013be:	89 f8                	mov    %edi,%eax
  8013c0:	84 c0                	test   %al,%al
  8013c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8013c7:	0f 44 d8             	cmove  %eax,%ebx
}
  8013ca:	89 d8                	mov    %ebx,%eax
  8013cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013cf:	5b                   	pop    %ebx
  8013d0:	5e                   	pop    %esi
  8013d1:	5f                   	pop    %edi
  8013d2:	5d                   	pop    %ebp
  8013d3:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8013d4:	83 ec 08             	sub    $0x8,%esp
  8013d7:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8013da:	50                   	push   %eax
  8013db:	ff 36                	pushl  (%esi)
  8013dd:	e8 56 ff ff ff       	call   801338 <dev_lookup>
  8013e2:	89 c3                	mov    %eax,%ebx
  8013e4:	83 c4 10             	add    $0x10,%esp
  8013e7:	85 c0                	test   %eax,%eax
  8013e9:	78 15                	js     801400 <fd_close+0x72>
		if (dev->dev_close)
  8013eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013ee:	8b 40 10             	mov    0x10(%eax),%eax
  8013f1:	85 c0                	test   %eax,%eax
  8013f3:	74 1b                	je     801410 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  8013f5:	83 ec 0c             	sub    $0xc,%esp
  8013f8:	56                   	push   %esi
  8013f9:	ff d0                	call   *%eax
  8013fb:	89 c3                	mov    %eax,%ebx
  8013fd:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801400:	83 ec 08             	sub    $0x8,%esp
  801403:	56                   	push   %esi
  801404:	6a 00                	push   $0x0
  801406:	e8 d6 fc ff ff       	call   8010e1 <sys_page_unmap>
	return r;
  80140b:	83 c4 10             	add    $0x10,%esp
  80140e:	eb ba                	jmp    8013ca <fd_close+0x3c>
			r = 0;
  801410:	bb 00 00 00 00       	mov    $0x0,%ebx
  801415:	eb e9                	jmp    801400 <fd_close+0x72>

00801417 <close>:

int
close(int fdnum)
{
  801417:	55                   	push   %ebp
  801418:	89 e5                	mov    %esp,%ebp
  80141a:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80141d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801420:	50                   	push   %eax
  801421:	ff 75 08             	pushl  0x8(%ebp)
  801424:	e8 b9 fe ff ff       	call   8012e2 <fd_lookup>
  801429:	83 c4 08             	add    $0x8,%esp
  80142c:	85 c0                	test   %eax,%eax
  80142e:	78 10                	js     801440 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  801430:	83 ec 08             	sub    $0x8,%esp
  801433:	6a 01                	push   $0x1
  801435:	ff 75 f4             	pushl  -0xc(%ebp)
  801438:	e8 51 ff ff ff       	call   80138e <fd_close>
  80143d:	83 c4 10             	add    $0x10,%esp
}
  801440:	c9                   	leave  
  801441:	c3                   	ret    

00801442 <close_all>:

void
close_all(void)
{
  801442:	55                   	push   %ebp
  801443:	89 e5                	mov    %esp,%ebp
  801445:	53                   	push   %ebx
  801446:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801449:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80144e:	83 ec 0c             	sub    $0xc,%esp
  801451:	53                   	push   %ebx
  801452:	e8 c0 ff ff ff       	call   801417 <close>
	for (i = 0; i < MAXFD; i++)
  801457:	83 c3 01             	add    $0x1,%ebx
  80145a:	83 c4 10             	add    $0x10,%esp
  80145d:	83 fb 20             	cmp    $0x20,%ebx
  801460:	75 ec                	jne    80144e <close_all+0xc>
}
  801462:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801465:	c9                   	leave  
  801466:	c3                   	ret    

00801467 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801467:	55                   	push   %ebp
  801468:	89 e5                	mov    %esp,%ebp
  80146a:	57                   	push   %edi
  80146b:	56                   	push   %esi
  80146c:	53                   	push   %ebx
  80146d:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801470:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801473:	50                   	push   %eax
  801474:	ff 75 08             	pushl  0x8(%ebp)
  801477:	e8 66 fe ff ff       	call   8012e2 <fd_lookup>
  80147c:	89 c3                	mov    %eax,%ebx
  80147e:	83 c4 08             	add    $0x8,%esp
  801481:	85 c0                	test   %eax,%eax
  801483:	0f 88 81 00 00 00    	js     80150a <dup+0xa3>
		return r;
	close(newfdnum);
  801489:	83 ec 0c             	sub    $0xc,%esp
  80148c:	ff 75 0c             	pushl  0xc(%ebp)
  80148f:	e8 83 ff ff ff       	call   801417 <close>

	newfd = INDEX2FD(newfdnum);
  801494:	8b 75 0c             	mov    0xc(%ebp),%esi
  801497:	c1 e6 0c             	shl    $0xc,%esi
  80149a:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8014a0:	83 c4 04             	add    $0x4,%esp
  8014a3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8014a6:	e8 d1 fd ff ff       	call   80127c <fd2data>
  8014ab:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8014ad:	89 34 24             	mov    %esi,(%esp)
  8014b0:	e8 c7 fd ff ff       	call   80127c <fd2data>
  8014b5:	83 c4 10             	add    $0x10,%esp
  8014b8:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8014ba:	89 d8                	mov    %ebx,%eax
  8014bc:	c1 e8 16             	shr    $0x16,%eax
  8014bf:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8014c6:	a8 01                	test   $0x1,%al
  8014c8:	74 11                	je     8014db <dup+0x74>
  8014ca:	89 d8                	mov    %ebx,%eax
  8014cc:	c1 e8 0c             	shr    $0xc,%eax
  8014cf:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8014d6:	f6 c2 01             	test   $0x1,%dl
  8014d9:	75 39                	jne    801514 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8014db:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8014de:	89 d0                	mov    %edx,%eax
  8014e0:	c1 e8 0c             	shr    $0xc,%eax
  8014e3:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8014ea:	83 ec 0c             	sub    $0xc,%esp
  8014ed:	25 07 0e 00 00       	and    $0xe07,%eax
  8014f2:	50                   	push   %eax
  8014f3:	56                   	push   %esi
  8014f4:	6a 00                	push   $0x0
  8014f6:	52                   	push   %edx
  8014f7:	6a 00                	push   $0x0
  8014f9:	e8 a1 fb ff ff       	call   80109f <sys_page_map>
  8014fe:	89 c3                	mov    %eax,%ebx
  801500:	83 c4 20             	add    $0x20,%esp
  801503:	85 c0                	test   %eax,%eax
  801505:	78 31                	js     801538 <dup+0xd1>
		goto err;

	return newfdnum;
  801507:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80150a:	89 d8                	mov    %ebx,%eax
  80150c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80150f:	5b                   	pop    %ebx
  801510:	5e                   	pop    %esi
  801511:	5f                   	pop    %edi
  801512:	5d                   	pop    %ebp
  801513:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801514:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80151b:	83 ec 0c             	sub    $0xc,%esp
  80151e:	25 07 0e 00 00       	and    $0xe07,%eax
  801523:	50                   	push   %eax
  801524:	57                   	push   %edi
  801525:	6a 00                	push   $0x0
  801527:	53                   	push   %ebx
  801528:	6a 00                	push   $0x0
  80152a:	e8 70 fb ff ff       	call   80109f <sys_page_map>
  80152f:	89 c3                	mov    %eax,%ebx
  801531:	83 c4 20             	add    $0x20,%esp
  801534:	85 c0                	test   %eax,%eax
  801536:	79 a3                	jns    8014db <dup+0x74>
	sys_page_unmap(0, newfd);
  801538:	83 ec 08             	sub    $0x8,%esp
  80153b:	56                   	push   %esi
  80153c:	6a 00                	push   $0x0
  80153e:	e8 9e fb ff ff       	call   8010e1 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801543:	83 c4 08             	add    $0x8,%esp
  801546:	57                   	push   %edi
  801547:	6a 00                	push   $0x0
  801549:	e8 93 fb ff ff       	call   8010e1 <sys_page_unmap>
	return r;
  80154e:	83 c4 10             	add    $0x10,%esp
  801551:	eb b7                	jmp    80150a <dup+0xa3>

00801553 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801553:	55                   	push   %ebp
  801554:	89 e5                	mov    %esp,%ebp
  801556:	53                   	push   %ebx
  801557:	83 ec 14             	sub    $0x14,%esp
  80155a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80155d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801560:	50                   	push   %eax
  801561:	53                   	push   %ebx
  801562:	e8 7b fd ff ff       	call   8012e2 <fd_lookup>
  801567:	83 c4 08             	add    $0x8,%esp
  80156a:	85 c0                	test   %eax,%eax
  80156c:	78 3f                	js     8015ad <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80156e:	83 ec 08             	sub    $0x8,%esp
  801571:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801574:	50                   	push   %eax
  801575:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801578:	ff 30                	pushl  (%eax)
  80157a:	e8 b9 fd ff ff       	call   801338 <dev_lookup>
  80157f:	83 c4 10             	add    $0x10,%esp
  801582:	85 c0                	test   %eax,%eax
  801584:	78 27                	js     8015ad <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801586:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801589:	8b 42 08             	mov    0x8(%edx),%eax
  80158c:	83 e0 03             	and    $0x3,%eax
  80158f:	83 f8 01             	cmp    $0x1,%eax
  801592:	74 1e                	je     8015b2 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801594:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801597:	8b 40 08             	mov    0x8(%eax),%eax
  80159a:	85 c0                	test   %eax,%eax
  80159c:	74 35                	je     8015d3 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80159e:	83 ec 04             	sub    $0x4,%esp
  8015a1:	ff 75 10             	pushl  0x10(%ebp)
  8015a4:	ff 75 0c             	pushl  0xc(%ebp)
  8015a7:	52                   	push   %edx
  8015a8:	ff d0                	call   *%eax
  8015aa:	83 c4 10             	add    $0x10,%esp
}
  8015ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015b0:	c9                   	leave  
  8015b1:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8015b2:	a1 18 40 80 00       	mov    0x804018,%eax
  8015b7:	8b 40 48             	mov    0x48(%eax),%eax
  8015ba:	83 ec 04             	sub    $0x4,%esp
  8015bd:	53                   	push   %ebx
  8015be:	50                   	push   %eax
  8015bf:	68 4d 2c 80 00       	push   $0x802c4d
  8015c4:	e8 fd ef ff ff       	call   8005c6 <cprintf>
		return -E_INVAL;
  8015c9:	83 c4 10             	add    $0x10,%esp
  8015cc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015d1:	eb da                	jmp    8015ad <read+0x5a>
		return -E_NOT_SUPP;
  8015d3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015d8:	eb d3                	jmp    8015ad <read+0x5a>

008015da <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8015da:	55                   	push   %ebp
  8015db:	89 e5                	mov    %esp,%ebp
  8015dd:	57                   	push   %edi
  8015de:	56                   	push   %esi
  8015df:	53                   	push   %ebx
  8015e0:	83 ec 0c             	sub    $0xc,%esp
  8015e3:	8b 7d 08             	mov    0x8(%ebp),%edi
  8015e6:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8015e9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015ee:	39 f3                	cmp    %esi,%ebx
  8015f0:	73 25                	jae    801617 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8015f2:	83 ec 04             	sub    $0x4,%esp
  8015f5:	89 f0                	mov    %esi,%eax
  8015f7:	29 d8                	sub    %ebx,%eax
  8015f9:	50                   	push   %eax
  8015fa:	89 d8                	mov    %ebx,%eax
  8015fc:	03 45 0c             	add    0xc(%ebp),%eax
  8015ff:	50                   	push   %eax
  801600:	57                   	push   %edi
  801601:	e8 4d ff ff ff       	call   801553 <read>
		if (m < 0)
  801606:	83 c4 10             	add    $0x10,%esp
  801609:	85 c0                	test   %eax,%eax
  80160b:	78 08                	js     801615 <readn+0x3b>
			return m;
		if (m == 0)
  80160d:	85 c0                	test   %eax,%eax
  80160f:	74 06                	je     801617 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  801611:	01 c3                	add    %eax,%ebx
  801613:	eb d9                	jmp    8015ee <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801615:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801617:	89 d8                	mov    %ebx,%eax
  801619:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80161c:	5b                   	pop    %ebx
  80161d:	5e                   	pop    %esi
  80161e:	5f                   	pop    %edi
  80161f:	5d                   	pop    %ebp
  801620:	c3                   	ret    

00801621 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801621:	55                   	push   %ebp
  801622:	89 e5                	mov    %esp,%ebp
  801624:	53                   	push   %ebx
  801625:	83 ec 14             	sub    $0x14,%esp
  801628:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80162b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80162e:	50                   	push   %eax
  80162f:	53                   	push   %ebx
  801630:	e8 ad fc ff ff       	call   8012e2 <fd_lookup>
  801635:	83 c4 08             	add    $0x8,%esp
  801638:	85 c0                	test   %eax,%eax
  80163a:	78 3a                	js     801676 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80163c:	83 ec 08             	sub    $0x8,%esp
  80163f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801642:	50                   	push   %eax
  801643:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801646:	ff 30                	pushl  (%eax)
  801648:	e8 eb fc ff ff       	call   801338 <dev_lookup>
  80164d:	83 c4 10             	add    $0x10,%esp
  801650:	85 c0                	test   %eax,%eax
  801652:	78 22                	js     801676 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801654:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801657:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80165b:	74 1e                	je     80167b <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80165d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801660:	8b 52 0c             	mov    0xc(%edx),%edx
  801663:	85 d2                	test   %edx,%edx
  801665:	74 35                	je     80169c <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801667:	83 ec 04             	sub    $0x4,%esp
  80166a:	ff 75 10             	pushl  0x10(%ebp)
  80166d:	ff 75 0c             	pushl  0xc(%ebp)
  801670:	50                   	push   %eax
  801671:	ff d2                	call   *%edx
  801673:	83 c4 10             	add    $0x10,%esp
}
  801676:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801679:	c9                   	leave  
  80167a:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80167b:	a1 18 40 80 00       	mov    0x804018,%eax
  801680:	8b 40 48             	mov    0x48(%eax),%eax
  801683:	83 ec 04             	sub    $0x4,%esp
  801686:	53                   	push   %ebx
  801687:	50                   	push   %eax
  801688:	68 69 2c 80 00       	push   $0x802c69
  80168d:	e8 34 ef ff ff       	call   8005c6 <cprintf>
		return -E_INVAL;
  801692:	83 c4 10             	add    $0x10,%esp
  801695:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80169a:	eb da                	jmp    801676 <write+0x55>
		return -E_NOT_SUPP;
  80169c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016a1:	eb d3                	jmp    801676 <write+0x55>

008016a3 <seek>:

int
seek(int fdnum, off_t offset)
{
  8016a3:	55                   	push   %ebp
  8016a4:	89 e5                	mov    %esp,%ebp
  8016a6:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8016a9:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8016ac:	50                   	push   %eax
  8016ad:	ff 75 08             	pushl  0x8(%ebp)
  8016b0:	e8 2d fc ff ff       	call   8012e2 <fd_lookup>
  8016b5:	83 c4 08             	add    $0x8,%esp
  8016b8:	85 c0                	test   %eax,%eax
  8016ba:	78 0e                	js     8016ca <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8016bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016c2:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8016c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016ca:	c9                   	leave  
  8016cb:	c3                   	ret    

008016cc <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8016cc:	55                   	push   %ebp
  8016cd:	89 e5                	mov    %esp,%ebp
  8016cf:	53                   	push   %ebx
  8016d0:	83 ec 14             	sub    $0x14,%esp
  8016d3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016d6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016d9:	50                   	push   %eax
  8016da:	53                   	push   %ebx
  8016db:	e8 02 fc ff ff       	call   8012e2 <fd_lookup>
  8016e0:	83 c4 08             	add    $0x8,%esp
  8016e3:	85 c0                	test   %eax,%eax
  8016e5:	78 37                	js     80171e <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016e7:	83 ec 08             	sub    $0x8,%esp
  8016ea:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016ed:	50                   	push   %eax
  8016ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016f1:	ff 30                	pushl  (%eax)
  8016f3:	e8 40 fc ff ff       	call   801338 <dev_lookup>
  8016f8:	83 c4 10             	add    $0x10,%esp
  8016fb:	85 c0                	test   %eax,%eax
  8016fd:	78 1f                	js     80171e <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8016ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801702:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801706:	74 1b                	je     801723 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801708:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80170b:	8b 52 18             	mov    0x18(%edx),%edx
  80170e:	85 d2                	test   %edx,%edx
  801710:	74 32                	je     801744 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801712:	83 ec 08             	sub    $0x8,%esp
  801715:	ff 75 0c             	pushl  0xc(%ebp)
  801718:	50                   	push   %eax
  801719:	ff d2                	call   *%edx
  80171b:	83 c4 10             	add    $0x10,%esp
}
  80171e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801721:	c9                   	leave  
  801722:	c3                   	ret    
			thisenv->env_id, fdnum);
  801723:	a1 18 40 80 00       	mov    0x804018,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801728:	8b 40 48             	mov    0x48(%eax),%eax
  80172b:	83 ec 04             	sub    $0x4,%esp
  80172e:	53                   	push   %ebx
  80172f:	50                   	push   %eax
  801730:	68 2c 2c 80 00       	push   $0x802c2c
  801735:	e8 8c ee ff ff       	call   8005c6 <cprintf>
		return -E_INVAL;
  80173a:	83 c4 10             	add    $0x10,%esp
  80173d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801742:	eb da                	jmp    80171e <ftruncate+0x52>
		return -E_NOT_SUPP;
  801744:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801749:	eb d3                	jmp    80171e <ftruncate+0x52>

0080174b <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80174b:	55                   	push   %ebp
  80174c:	89 e5                	mov    %esp,%ebp
  80174e:	53                   	push   %ebx
  80174f:	83 ec 14             	sub    $0x14,%esp
  801752:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801755:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801758:	50                   	push   %eax
  801759:	ff 75 08             	pushl  0x8(%ebp)
  80175c:	e8 81 fb ff ff       	call   8012e2 <fd_lookup>
  801761:	83 c4 08             	add    $0x8,%esp
  801764:	85 c0                	test   %eax,%eax
  801766:	78 4b                	js     8017b3 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801768:	83 ec 08             	sub    $0x8,%esp
  80176b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80176e:	50                   	push   %eax
  80176f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801772:	ff 30                	pushl  (%eax)
  801774:	e8 bf fb ff ff       	call   801338 <dev_lookup>
  801779:	83 c4 10             	add    $0x10,%esp
  80177c:	85 c0                	test   %eax,%eax
  80177e:	78 33                	js     8017b3 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801780:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801783:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801787:	74 2f                	je     8017b8 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801789:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80178c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801793:	00 00 00 
	stat->st_isdir = 0;
  801796:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80179d:	00 00 00 
	stat->st_dev = dev;
  8017a0:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8017a6:	83 ec 08             	sub    $0x8,%esp
  8017a9:	53                   	push   %ebx
  8017aa:	ff 75 f0             	pushl  -0x10(%ebp)
  8017ad:	ff 50 14             	call   *0x14(%eax)
  8017b0:	83 c4 10             	add    $0x10,%esp
}
  8017b3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017b6:	c9                   	leave  
  8017b7:	c3                   	ret    
		return -E_NOT_SUPP;
  8017b8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017bd:	eb f4                	jmp    8017b3 <fstat+0x68>

008017bf <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8017bf:	55                   	push   %ebp
  8017c0:	89 e5                	mov    %esp,%ebp
  8017c2:	56                   	push   %esi
  8017c3:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8017c4:	83 ec 08             	sub    $0x8,%esp
  8017c7:	6a 00                	push   $0x0
  8017c9:	ff 75 08             	pushl  0x8(%ebp)
  8017cc:	e8 26 02 00 00       	call   8019f7 <open>
  8017d1:	89 c3                	mov    %eax,%ebx
  8017d3:	83 c4 10             	add    $0x10,%esp
  8017d6:	85 c0                	test   %eax,%eax
  8017d8:	78 1b                	js     8017f5 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8017da:	83 ec 08             	sub    $0x8,%esp
  8017dd:	ff 75 0c             	pushl  0xc(%ebp)
  8017e0:	50                   	push   %eax
  8017e1:	e8 65 ff ff ff       	call   80174b <fstat>
  8017e6:	89 c6                	mov    %eax,%esi
	close(fd);
  8017e8:	89 1c 24             	mov    %ebx,(%esp)
  8017eb:	e8 27 fc ff ff       	call   801417 <close>
	return r;
  8017f0:	83 c4 10             	add    $0x10,%esp
  8017f3:	89 f3                	mov    %esi,%ebx
}
  8017f5:	89 d8                	mov    %ebx,%eax
  8017f7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017fa:	5b                   	pop    %ebx
  8017fb:	5e                   	pop    %esi
  8017fc:	5d                   	pop    %ebp
  8017fd:	c3                   	ret    

008017fe <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8017fe:	55                   	push   %ebp
  8017ff:	89 e5                	mov    %esp,%ebp
  801801:	56                   	push   %esi
  801802:	53                   	push   %ebx
  801803:	89 c6                	mov    %eax,%esi
  801805:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801807:	83 3d 10 40 80 00 00 	cmpl   $0x0,0x804010
  80180e:	74 27                	je     801837 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801810:	6a 07                	push   $0x7
  801812:	68 00 50 80 00       	push   $0x805000
  801817:	56                   	push   %esi
  801818:	ff 35 10 40 80 00    	pushl  0x804010
  80181e:	e8 57 0c 00 00       	call   80247a <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801823:	83 c4 0c             	add    $0xc,%esp
  801826:	6a 00                	push   $0x0
  801828:	53                   	push   %ebx
  801829:	6a 00                	push   $0x0
  80182b:	e8 e1 0b 00 00       	call   802411 <ipc_recv>
}
  801830:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801833:	5b                   	pop    %ebx
  801834:	5e                   	pop    %esi
  801835:	5d                   	pop    %ebp
  801836:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801837:	83 ec 0c             	sub    $0xc,%esp
  80183a:	6a 01                	push   $0x1
  80183c:	e8 92 0c 00 00       	call   8024d3 <ipc_find_env>
  801841:	a3 10 40 80 00       	mov    %eax,0x804010
  801846:	83 c4 10             	add    $0x10,%esp
  801849:	eb c5                	jmp    801810 <fsipc+0x12>

0080184b <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80184b:	55                   	push   %ebp
  80184c:	89 e5                	mov    %esp,%ebp
  80184e:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801851:	8b 45 08             	mov    0x8(%ebp),%eax
  801854:	8b 40 0c             	mov    0xc(%eax),%eax
  801857:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80185c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80185f:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801864:	ba 00 00 00 00       	mov    $0x0,%edx
  801869:	b8 02 00 00 00       	mov    $0x2,%eax
  80186e:	e8 8b ff ff ff       	call   8017fe <fsipc>
}
  801873:	c9                   	leave  
  801874:	c3                   	ret    

00801875 <devfile_flush>:
{
  801875:	55                   	push   %ebp
  801876:	89 e5                	mov    %esp,%ebp
  801878:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80187b:	8b 45 08             	mov    0x8(%ebp),%eax
  80187e:	8b 40 0c             	mov    0xc(%eax),%eax
  801881:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801886:	ba 00 00 00 00       	mov    $0x0,%edx
  80188b:	b8 06 00 00 00       	mov    $0x6,%eax
  801890:	e8 69 ff ff ff       	call   8017fe <fsipc>
}
  801895:	c9                   	leave  
  801896:	c3                   	ret    

00801897 <devfile_stat>:
{
  801897:	55                   	push   %ebp
  801898:	89 e5                	mov    %esp,%ebp
  80189a:	53                   	push   %ebx
  80189b:	83 ec 04             	sub    $0x4,%esp
  80189e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8018a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a4:	8b 40 0c             	mov    0xc(%eax),%eax
  8018a7:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8018ac:	ba 00 00 00 00       	mov    $0x0,%edx
  8018b1:	b8 05 00 00 00       	mov    $0x5,%eax
  8018b6:	e8 43 ff ff ff       	call   8017fe <fsipc>
  8018bb:	85 c0                	test   %eax,%eax
  8018bd:	78 2c                	js     8018eb <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8018bf:	83 ec 08             	sub    $0x8,%esp
  8018c2:	68 00 50 80 00       	push   $0x805000
  8018c7:	53                   	push   %ebx
  8018c8:	e8 96 f3 ff ff       	call   800c63 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8018cd:	a1 80 50 80 00       	mov    0x805080,%eax
  8018d2:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8018d8:	a1 84 50 80 00       	mov    0x805084,%eax
  8018dd:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8018e3:	83 c4 10             	add    $0x10,%esp
  8018e6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018eb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018ee:	c9                   	leave  
  8018ef:	c3                   	ret    

008018f0 <devfile_write>:
{
  8018f0:	55                   	push   %ebp
  8018f1:	89 e5                	mov    %esp,%ebp
  8018f3:	53                   	push   %ebx
  8018f4:	83 ec 04             	sub    $0x4,%esp
  8018f7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8018fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fd:	8b 40 0c             	mov    0xc(%eax),%eax
  801900:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  801905:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  80190b:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  801911:	77 30                	ja     801943 <devfile_write+0x53>
	memmove(fsipcbuf.write.req_buf, buf, n);
  801913:	83 ec 04             	sub    $0x4,%esp
  801916:	53                   	push   %ebx
  801917:	ff 75 0c             	pushl  0xc(%ebp)
  80191a:	68 08 50 80 00       	push   $0x805008
  80191f:	e8 cd f4 ff ff       	call   800df1 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801924:	ba 00 00 00 00       	mov    $0x0,%edx
  801929:	b8 04 00 00 00       	mov    $0x4,%eax
  80192e:	e8 cb fe ff ff       	call   8017fe <fsipc>
  801933:	83 c4 10             	add    $0x10,%esp
  801936:	85 c0                	test   %eax,%eax
  801938:	78 04                	js     80193e <devfile_write+0x4e>
	assert(r <= n);
  80193a:	39 d8                	cmp    %ebx,%eax
  80193c:	77 1e                	ja     80195c <devfile_write+0x6c>
}
  80193e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801941:	c9                   	leave  
  801942:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  801943:	68 9c 2c 80 00       	push   $0x802c9c
  801948:	68 c9 2c 80 00       	push   $0x802cc9
  80194d:	68 94 00 00 00       	push   $0x94
  801952:	68 de 2c 80 00       	push   $0x802cde
  801957:	e8 6f 0a 00 00       	call   8023cb <_panic>
	assert(r <= n);
  80195c:	68 e9 2c 80 00       	push   $0x802ce9
  801961:	68 c9 2c 80 00       	push   $0x802cc9
  801966:	68 98 00 00 00       	push   $0x98
  80196b:	68 de 2c 80 00       	push   $0x802cde
  801970:	e8 56 0a 00 00       	call   8023cb <_panic>

00801975 <devfile_read>:
{
  801975:	55                   	push   %ebp
  801976:	89 e5                	mov    %esp,%ebp
  801978:	56                   	push   %esi
  801979:	53                   	push   %ebx
  80197a:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80197d:	8b 45 08             	mov    0x8(%ebp),%eax
  801980:	8b 40 0c             	mov    0xc(%eax),%eax
  801983:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801988:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80198e:	ba 00 00 00 00       	mov    $0x0,%edx
  801993:	b8 03 00 00 00       	mov    $0x3,%eax
  801998:	e8 61 fe ff ff       	call   8017fe <fsipc>
  80199d:	89 c3                	mov    %eax,%ebx
  80199f:	85 c0                	test   %eax,%eax
  8019a1:	78 1f                	js     8019c2 <devfile_read+0x4d>
	assert(r <= n);
  8019a3:	39 f0                	cmp    %esi,%eax
  8019a5:	77 24                	ja     8019cb <devfile_read+0x56>
	assert(r <= PGSIZE);
  8019a7:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8019ac:	7f 33                	jg     8019e1 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8019ae:	83 ec 04             	sub    $0x4,%esp
  8019b1:	50                   	push   %eax
  8019b2:	68 00 50 80 00       	push   $0x805000
  8019b7:	ff 75 0c             	pushl  0xc(%ebp)
  8019ba:	e8 32 f4 ff ff       	call   800df1 <memmove>
	return r;
  8019bf:	83 c4 10             	add    $0x10,%esp
}
  8019c2:	89 d8                	mov    %ebx,%eax
  8019c4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019c7:	5b                   	pop    %ebx
  8019c8:	5e                   	pop    %esi
  8019c9:	5d                   	pop    %ebp
  8019ca:	c3                   	ret    
	assert(r <= n);
  8019cb:	68 e9 2c 80 00       	push   $0x802ce9
  8019d0:	68 c9 2c 80 00       	push   $0x802cc9
  8019d5:	6a 7c                	push   $0x7c
  8019d7:	68 de 2c 80 00       	push   $0x802cde
  8019dc:	e8 ea 09 00 00       	call   8023cb <_panic>
	assert(r <= PGSIZE);
  8019e1:	68 f0 2c 80 00       	push   $0x802cf0
  8019e6:	68 c9 2c 80 00       	push   $0x802cc9
  8019eb:	6a 7d                	push   $0x7d
  8019ed:	68 de 2c 80 00       	push   $0x802cde
  8019f2:	e8 d4 09 00 00       	call   8023cb <_panic>

008019f7 <open>:
{
  8019f7:	55                   	push   %ebp
  8019f8:	89 e5                	mov    %esp,%ebp
  8019fa:	56                   	push   %esi
  8019fb:	53                   	push   %ebx
  8019fc:	83 ec 1c             	sub    $0x1c,%esp
  8019ff:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801a02:	56                   	push   %esi
  801a03:	e8 24 f2 ff ff       	call   800c2c <strlen>
  801a08:	83 c4 10             	add    $0x10,%esp
  801a0b:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801a10:	7f 6c                	jg     801a7e <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801a12:	83 ec 0c             	sub    $0xc,%esp
  801a15:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a18:	50                   	push   %eax
  801a19:	e8 75 f8 ff ff       	call   801293 <fd_alloc>
  801a1e:	89 c3                	mov    %eax,%ebx
  801a20:	83 c4 10             	add    $0x10,%esp
  801a23:	85 c0                	test   %eax,%eax
  801a25:	78 3c                	js     801a63 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801a27:	83 ec 08             	sub    $0x8,%esp
  801a2a:	56                   	push   %esi
  801a2b:	68 00 50 80 00       	push   $0x805000
  801a30:	e8 2e f2 ff ff       	call   800c63 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801a35:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a38:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801a3d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a40:	b8 01 00 00 00       	mov    $0x1,%eax
  801a45:	e8 b4 fd ff ff       	call   8017fe <fsipc>
  801a4a:	89 c3                	mov    %eax,%ebx
  801a4c:	83 c4 10             	add    $0x10,%esp
  801a4f:	85 c0                	test   %eax,%eax
  801a51:	78 19                	js     801a6c <open+0x75>
	return fd2num(fd);
  801a53:	83 ec 0c             	sub    $0xc,%esp
  801a56:	ff 75 f4             	pushl  -0xc(%ebp)
  801a59:	e8 0e f8 ff ff       	call   80126c <fd2num>
  801a5e:	89 c3                	mov    %eax,%ebx
  801a60:	83 c4 10             	add    $0x10,%esp
}
  801a63:	89 d8                	mov    %ebx,%eax
  801a65:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a68:	5b                   	pop    %ebx
  801a69:	5e                   	pop    %esi
  801a6a:	5d                   	pop    %ebp
  801a6b:	c3                   	ret    
		fd_close(fd, 0);
  801a6c:	83 ec 08             	sub    $0x8,%esp
  801a6f:	6a 00                	push   $0x0
  801a71:	ff 75 f4             	pushl  -0xc(%ebp)
  801a74:	e8 15 f9 ff ff       	call   80138e <fd_close>
		return r;
  801a79:	83 c4 10             	add    $0x10,%esp
  801a7c:	eb e5                	jmp    801a63 <open+0x6c>
		return -E_BAD_PATH;
  801a7e:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801a83:	eb de                	jmp    801a63 <open+0x6c>

00801a85 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801a85:	55                   	push   %ebp
  801a86:	89 e5                	mov    %esp,%ebp
  801a88:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801a8b:	ba 00 00 00 00       	mov    $0x0,%edx
  801a90:	b8 08 00 00 00       	mov    $0x8,%eax
  801a95:	e8 64 fd ff ff       	call   8017fe <fsipc>
}
  801a9a:	c9                   	leave  
  801a9b:	c3                   	ret    

00801a9c <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801a9c:	55                   	push   %ebp
  801a9d:	89 e5                	mov    %esp,%ebp
  801a9f:	56                   	push   %esi
  801aa0:	53                   	push   %ebx
  801aa1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801aa4:	83 ec 0c             	sub    $0xc,%esp
  801aa7:	ff 75 08             	pushl  0x8(%ebp)
  801aaa:	e8 cd f7 ff ff       	call   80127c <fd2data>
  801aaf:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801ab1:	83 c4 08             	add    $0x8,%esp
  801ab4:	68 fc 2c 80 00       	push   $0x802cfc
  801ab9:	53                   	push   %ebx
  801aba:	e8 a4 f1 ff ff       	call   800c63 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801abf:	8b 46 04             	mov    0x4(%esi),%eax
  801ac2:	2b 06                	sub    (%esi),%eax
  801ac4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801aca:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801ad1:	00 00 00 
	stat->st_dev = &devpipe;
  801ad4:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801adb:	30 80 00 
	return 0;
}
  801ade:	b8 00 00 00 00       	mov    $0x0,%eax
  801ae3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ae6:	5b                   	pop    %ebx
  801ae7:	5e                   	pop    %esi
  801ae8:	5d                   	pop    %ebp
  801ae9:	c3                   	ret    

00801aea <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801aea:	55                   	push   %ebp
  801aeb:	89 e5                	mov    %esp,%ebp
  801aed:	53                   	push   %ebx
  801aee:	83 ec 0c             	sub    $0xc,%esp
  801af1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801af4:	53                   	push   %ebx
  801af5:	6a 00                	push   $0x0
  801af7:	e8 e5 f5 ff ff       	call   8010e1 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801afc:	89 1c 24             	mov    %ebx,(%esp)
  801aff:	e8 78 f7 ff ff       	call   80127c <fd2data>
  801b04:	83 c4 08             	add    $0x8,%esp
  801b07:	50                   	push   %eax
  801b08:	6a 00                	push   $0x0
  801b0a:	e8 d2 f5 ff ff       	call   8010e1 <sys_page_unmap>
}
  801b0f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b12:	c9                   	leave  
  801b13:	c3                   	ret    

00801b14 <_pipeisclosed>:
{
  801b14:	55                   	push   %ebp
  801b15:	89 e5                	mov    %esp,%ebp
  801b17:	57                   	push   %edi
  801b18:	56                   	push   %esi
  801b19:	53                   	push   %ebx
  801b1a:	83 ec 1c             	sub    $0x1c,%esp
  801b1d:	89 c7                	mov    %eax,%edi
  801b1f:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801b21:	a1 18 40 80 00       	mov    0x804018,%eax
  801b26:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801b29:	83 ec 0c             	sub    $0xc,%esp
  801b2c:	57                   	push   %edi
  801b2d:	e8 da 09 00 00       	call   80250c <pageref>
  801b32:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801b35:	89 34 24             	mov    %esi,(%esp)
  801b38:	e8 cf 09 00 00       	call   80250c <pageref>
		nn = thisenv->env_runs;
  801b3d:	8b 15 18 40 80 00    	mov    0x804018,%edx
  801b43:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801b46:	83 c4 10             	add    $0x10,%esp
  801b49:	39 cb                	cmp    %ecx,%ebx
  801b4b:	74 1b                	je     801b68 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801b4d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801b50:	75 cf                	jne    801b21 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801b52:	8b 42 58             	mov    0x58(%edx),%eax
  801b55:	6a 01                	push   $0x1
  801b57:	50                   	push   %eax
  801b58:	53                   	push   %ebx
  801b59:	68 03 2d 80 00       	push   $0x802d03
  801b5e:	e8 63 ea ff ff       	call   8005c6 <cprintf>
  801b63:	83 c4 10             	add    $0x10,%esp
  801b66:	eb b9                	jmp    801b21 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801b68:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801b6b:	0f 94 c0             	sete   %al
  801b6e:	0f b6 c0             	movzbl %al,%eax
}
  801b71:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b74:	5b                   	pop    %ebx
  801b75:	5e                   	pop    %esi
  801b76:	5f                   	pop    %edi
  801b77:	5d                   	pop    %ebp
  801b78:	c3                   	ret    

00801b79 <devpipe_write>:
{
  801b79:	55                   	push   %ebp
  801b7a:	89 e5                	mov    %esp,%ebp
  801b7c:	57                   	push   %edi
  801b7d:	56                   	push   %esi
  801b7e:	53                   	push   %ebx
  801b7f:	83 ec 28             	sub    $0x28,%esp
  801b82:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801b85:	56                   	push   %esi
  801b86:	e8 f1 f6 ff ff       	call   80127c <fd2data>
  801b8b:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801b8d:	83 c4 10             	add    $0x10,%esp
  801b90:	bf 00 00 00 00       	mov    $0x0,%edi
  801b95:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801b98:	74 4f                	je     801be9 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801b9a:	8b 43 04             	mov    0x4(%ebx),%eax
  801b9d:	8b 0b                	mov    (%ebx),%ecx
  801b9f:	8d 51 20             	lea    0x20(%ecx),%edx
  801ba2:	39 d0                	cmp    %edx,%eax
  801ba4:	72 14                	jb     801bba <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801ba6:	89 da                	mov    %ebx,%edx
  801ba8:	89 f0                	mov    %esi,%eax
  801baa:	e8 65 ff ff ff       	call   801b14 <_pipeisclosed>
  801baf:	85 c0                	test   %eax,%eax
  801bb1:	75 3a                	jne    801bed <devpipe_write+0x74>
			sys_yield();
  801bb3:	e8 85 f4 ff ff       	call   80103d <sys_yield>
  801bb8:	eb e0                	jmp    801b9a <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801bba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801bbd:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801bc1:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801bc4:	89 c2                	mov    %eax,%edx
  801bc6:	c1 fa 1f             	sar    $0x1f,%edx
  801bc9:	89 d1                	mov    %edx,%ecx
  801bcb:	c1 e9 1b             	shr    $0x1b,%ecx
  801bce:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801bd1:	83 e2 1f             	and    $0x1f,%edx
  801bd4:	29 ca                	sub    %ecx,%edx
  801bd6:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801bda:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801bde:	83 c0 01             	add    $0x1,%eax
  801be1:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801be4:	83 c7 01             	add    $0x1,%edi
  801be7:	eb ac                	jmp    801b95 <devpipe_write+0x1c>
	return i;
  801be9:	89 f8                	mov    %edi,%eax
  801beb:	eb 05                	jmp    801bf2 <devpipe_write+0x79>
				return 0;
  801bed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bf2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801bf5:	5b                   	pop    %ebx
  801bf6:	5e                   	pop    %esi
  801bf7:	5f                   	pop    %edi
  801bf8:	5d                   	pop    %ebp
  801bf9:	c3                   	ret    

00801bfa <devpipe_read>:
{
  801bfa:	55                   	push   %ebp
  801bfb:	89 e5                	mov    %esp,%ebp
  801bfd:	57                   	push   %edi
  801bfe:	56                   	push   %esi
  801bff:	53                   	push   %ebx
  801c00:	83 ec 18             	sub    $0x18,%esp
  801c03:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801c06:	57                   	push   %edi
  801c07:	e8 70 f6 ff ff       	call   80127c <fd2data>
  801c0c:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801c0e:	83 c4 10             	add    $0x10,%esp
  801c11:	be 00 00 00 00       	mov    $0x0,%esi
  801c16:	3b 75 10             	cmp    0x10(%ebp),%esi
  801c19:	74 47                	je     801c62 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801c1b:	8b 03                	mov    (%ebx),%eax
  801c1d:	3b 43 04             	cmp    0x4(%ebx),%eax
  801c20:	75 22                	jne    801c44 <devpipe_read+0x4a>
			if (i > 0)
  801c22:	85 f6                	test   %esi,%esi
  801c24:	75 14                	jne    801c3a <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801c26:	89 da                	mov    %ebx,%edx
  801c28:	89 f8                	mov    %edi,%eax
  801c2a:	e8 e5 fe ff ff       	call   801b14 <_pipeisclosed>
  801c2f:	85 c0                	test   %eax,%eax
  801c31:	75 33                	jne    801c66 <devpipe_read+0x6c>
			sys_yield();
  801c33:	e8 05 f4 ff ff       	call   80103d <sys_yield>
  801c38:	eb e1                	jmp    801c1b <devpipe_read+0x21>
				return i;
  801c3a:	89 f0                	mov    %esi,%eax
}
  801c3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c3f:	5b                   	pop    %ebx
  801c40:	5e                   	pop    %esi
  801c41:	5f                   	pop    %edi
  801c42:	5d                   	pop    %ebp
  801c43:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801c44:	99                   	cltd   
  801c45:	c1 ea 1b             	shr    $0x1b,%edx
  801c48:	01 d0                	add    %edx,%eax
  801c4a:	83 e0 1f             	and    $0x1f,%eax
  801c4d:	29 d0                	sub    %edx,%eax
  801c4f:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801c54:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c57:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801c5a:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801c5d:	83 c6 01             	add    $0x1,%esi
  801c60:	eb b4                	jmp    801c16 <devpipe_read+0x1c>
	return i;
  801c62:	89 f0                	mov    %esi,%eax
  801c64:	eb d6                	jmp    801c3c <devpipe_read+0x42>
				return 0;
  801c66:	b8 00 00 00 00       	mov    $0x0,%eax
  801c6b:	eb cf                	jmp    801c3c <devpipe_read+0x42>

00801c6d <pipe>:
{
  801c6d:	55                   	push   %ebp
  801c6e:	89 e5                	mov    %esp,%ebp
  801c70:	56                   	push   %esi
  801c71:	53                   	push   %ebx
  801c72:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801c75:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c78:	50                   	push   %eax
  801c79:	e8 15 f6 ff ff       	call   801293 <fd_alloc>
  801c7e:	89 c3                	mov    %eax,%ebx
  801c80:	83 c4 10             	add    $0x10,%esp
  801c83:	85 c0                	test   %eax,%eax
  801c85:	78 5b                	js     801ce2 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c87:	83 ec 04             	sub    $0x4,%esp
  801c8a:	68 07 04 00 00       	push   $0x407
  801c8f:	ff 75 f4             	pushl  -0xc(%ebp)
  801c92:	6a 00                	push   $0x0
  801c94:	e8 c3 f3 ff ff       	call   80105c <sys_page_alloc>
  801c99:	89 c3                	mov    %eax,%ebx
  801c9b:	83 c4 10             	add    $0x10,%esp
  801c9e:	85 c0                	test   %eax,%eax
  801ca0:	78 40                	js     801ce2 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  801ca2:	83 ec 0c             	sub    $0xc,%esp
  801ca5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ca8:	50                   	push   %eax
  801ca9:	e8 e5 f5 ff ff       	call   801293 <fd_alloc>
  801cae:	89 c3                	mov    %eax,%ebx
  801cb0:	83 c4 10             	add    $0x10,%esp
  801cb3:	85 c0                	test   %eax,%eax
  801cb5:	78 1b                	js     801cd2 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801cb7:	83 ec 04             	sub    $0x4,%esp
  801cba:	68 07 04 00 00       	push   $0x407
  801cbf:	ff 75 f0             	pushl  -0x10(%ebp)
  801cc2:	6a 00                	push   $0x0
  801cc4:	e8 93 f3 ff ff       	call   80105c <sys_page_alloc>
  801cc9:	89 c3                	mov    %eax,%ebx
  801ccb:	83 c4 10             	add    $0x10,%esp
  801cce:	85 c0                	test   %eax,%eax
  801cd0:	79 19                	jns    801ceb <pipe+0x7e>
	sys_page_unmap(0, fd0);
  801cd2:	83 ec 08             	sub    $0x8,%esp
  801cd5:	ff 75 f4             	pushl  -0xc(%ebp)
  801cd8:	6a 00                	push   $0x0
  801cda:	e8 02 f4 ff ff       	call   8010e1 <sys_page_unmap>
  801cdf:	83 c4 10             	add    $0x10,%esp
}
  801ce2:	89 d8                	mov    %ebx,%eax
  801ce4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ce7:	5b                   	pop    %ebx
  801ce8:	5e                   	pop    %esi
  801ce9:	5d                   	pop    %ebp
  801cea:	c3                   	ret    
	va = fd2data(fd0);
  801ceb:	83 ec 0c             	sub    $0xc,%esp
  801cee:	ff 75 f4             	pushl  -0xc(%ebp)
  801cf1:	e8 86 f5 ff ff       	call   80127c <fd2data>
  801cf6:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801cf8:	83 c4 0c             	add    $0xc,%esp
  801cfb:	68 07 04 00 00       	push   $0x407
  801d00:	50                   	push   %eax
  801d01:	6a 00                	push   $0x0
  801d03:	e8 54 f3 ff ff       	call   80105c <sys_page_alloc>
  801d08:	89 c3                	mov    %eax,%ebx
  801d0a:	83 c4 10             	add    $0x10,%esp
  801d0d:	85 c0                	test   %eax,%eax
  801d0f:	0f 88 8c 00 00 00    	js     801da1 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d15:	83 ec 0c             	sub    $0xc,%esp
  801d18:	ff 75 f0             	pushl  -0x10(%ebp)
  801d1b:	e8 5c f5 ff ff       	call   80127c <fd2data>
  801d20:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801d27:	50                   	push   %eax
  801d28:	6a 00                	push   $0x0
  801d2a:	56                   	push   %esi
  801d2b:	6a 00                	push   $0x0
  801d2d:	e8 6d f3 ff ff       	call   80109f <sys_page_map>
  801d32:	89 c3                	mov    %eax,%ebx
  801d34:	83 c4 20             	add    $0x20,%esp
  801d37:	85 c0                	test   %eax,%eax
  801d39:	78 58                	js     801d93 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801d3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d3e:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801d44:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801d46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d49:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801d50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d53:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801d59:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801d5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d5e:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801d65:	83 ec 0c             	sub    $0xc,%esp
  801d68:	ff 75 f4             	pushl  -0xc(%ebp)
  801d6b:	e8 fc f4 ff ff       	call   80126c <fd2num>
  801d70:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d73:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801d75:	83 c4 04             	add    $0x4,%esp
  801d78:	ff 75 f0             	pushl  -0x10(%ebp)
  801d7b:	e8 ec f4 ff ff       	call   80126c <fd2num>
  801d80:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d83:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801d86:	83 c4 10             	add    $0x10,%esp
  801d89:	bb 00 00 00 00       	mov    $0x0,%ebx
  801d8e:	e9 4f ff ff ff       	jmp    801ce2 <pipe+0x75>
	sys_page_unmap(0, va);
  801d93:	83 ec 08             	sub    $0x8,%esp
  801d96:	56                   	push   %esi
  801d97:	6a 00                	push   $0x0
  801d99:	e8 43 f3 ff ff       	call   8010e1 <sys_page_unmap>
  801d9e:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801da1:	83 ec 08             	sub    $0x8,%esp
  801da4:	ff 75 f0             	pushl  -0x10(%ebp)
  801da7:	6a 00                	push   $0x0
  801da9:	e8 33 f3 ff ff       	call   8010e1 <sys_page_unmap>
  801dae:	83 c4 10             	add    $0x10,%esp
  801db1:	e9 1c ff ff ff       	jmp    801cd2 <pipe+0x65>

00801db6 <pipeisclosed>:
{
  801db6:	55                   	push   %ebp
  801db7:	89 e5                	mov    %esp,%ebp
  801db9:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801dbc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801dbf:	50                   	push   %eax
  801dc0:	ff 75 08             	pushl  0x8(%ebp)
  801dc3:	e8 1a f5 ff ff       	call   8012e2 <fd_lookup>
  801dc8:	83 c4 10             	add    $0x10,%esp
  801dcb:	85 c0                	test   %eax,%eax
  801dcd:	78 18                	js     801de7 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801dcf:	83 ec 0c             	sub    $0xc,%esp
  801dd2:	ff 75 f4             	pushl  -0xc(%ebp)
  801dd5:	e8 a2 f4 ff ff       	call   80127c <fd2data>
	return _pipeisclosed(fd, p);
  801dda:	89 c2                	mov    %eax,%edx
  801ddc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ddf:	e8 30 fd ff ff       	call   801b14 <_pipeisclosed>
  801de4:	83 c4 10             	add    $0x10,%esp
}
  801de7:	c9                   	leave  
  801de8:	c3                   	ret    

00801de9 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801de9:	55                   	push   %ebp
  801dea:	89 e5                	mov    %esp,%ebp
  801dec:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801def:	68 1b 2d 80 00       	push   $0x802d1b
  801df4:	ff 75 0c             	pushl  0xc(%ebp)
  801df7:	e8 67 ee ff ff       	call   800c63 <strcpy>
	return 0;
}
  801dfc:	b8 00 00 00 00       	mov    $0x0,%eax
  801e01:	c9                   	leave  
  801e02:	c3                   	ret    

00801e03 <devsock_close>:
{
  801e03:	55                   	push   %ebp
  801e04:	89 e5                	mov    %esp,%ebp
  801e06:	53                   	push   %ebx
  801e07:	83 ec 10             	sub    $0x10,%esp
  801e0a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801e0d:	53                   	push   %ebx
  801e0e:	e8 f9 06 00 00       	call   80250c <pageref>
  801e13:	83 c4 10             	add    $0x10,%esp
		return 0;
  801e16:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801e1b:	83 f8 01             	cmp    $0x1,%eax
  801e1e:	74 07                	je     801e27 <devsock_close+0x24>
}
  801e20:	89 d0                	mov    %edx,%eax
  801e22:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e25:	c9                   	leave  
  801e26:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801e27:	83 ec 0c             	sub    $0xc,%esp
  801e2a:	ff 73 0c             	pushl  0xc(%ebx)
  801e2d:	e8 b7 02 00 00       	call   8020e9 <nsipc_close>
  801e32:	89 c2                	mov    %eax,%edx
  801e34:	83 c4 10             	add    $0x10,%esp
  801e37:	eb e7                	jmp    801e20 <devsock_close+0x1d>

00801e39 <devsock_write>:
{
  801e39:	55                   	push   %ebp
  801e3a:	89 e5                	mov    %esp,%ebp
  801e3c:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801e3f:	6a 00                	push   $0x0
  801e41:	ff 75 10             	pushl  0x10(%ebp)
  801e44:	ff 75 0c             	pushl  0xc(%ebp)
  801e47:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4a:	ff 70 0c             	pushl  0xc(%eax)
  801e4d:	e8 74 03 00 00       	call   8021c6 <nsipc_send>
}
  801e52:	c9                   	leave  
  801e53:	c3                   	ret    

00801e54 <devsock_read>:
{
  801e54:	55                   	push   %ebp
  801e55:	89 e5                	mov    %esp,%ebp
  801e57:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801e5a:	6a 00                	push   $0x0
  801e5c:	ff 75 10             	pushl  0x10(%ebp)
  801e5f:	ff 75 0c             	pushl  0xc(%ebp)
  801e62:	8b 45 08             	mov    0x8(%ebp),%eax
  801e65:	ff 70 0c             	pushl  0xc(%eax)
  801e68:	e8 ed 02 00 00       	call   80215a <nsipc_recv>
}
  801e6d:	c9                   	leave  
  801e6e:	c3                   	ret    

00801e6f <fd2sockid>:
{
  801e6f:	55                   	push   %ebp
  801e70:	89 e5                	mov    %esp,%ebp
  801e72:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801e75:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801e78:	52                   	push   %edx
  801e79:	50                   	push   %eax
  801e7a:	e8 63 f4 ff ff       	call   8012e2 <fd_lookup>
  801e7f:	83 c4 10             	add    $0x10,%esp
  801e82:	85 c0                	test   %eax,%eax
  801e84:	78 10                	js     801e96 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801e86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e89:	8b 0d 3c 30 80 00    	mov    0x80303c,%ecx
  801e8f:	39 08                	cmp    %ecx,(%eax)
  801e91:	75 05                	jne    801e98 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801e93:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801e96:	c9                   	leave  
  801e97:	c3                   	ret    
		return -E_NOT_SUPP;
  801e98:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801e9d:	eb f7                	jmp    801e96 <fd2sockid+0x27>

00801e9f <alloc_sockfd>:
{
  801e9f:	55                   	push   %ebp
  801ea0:	89 e5                	mov    %esp,%ebp
  801ea2:	56                   	push   %esi
  801ea3:	53                   	push   %ebx
  801ea4:	83 ec 1c             	sub    $0x1c,%esp
  801ea7:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801ea9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801eac:	50                   	push   %eax
  801ead:	e8 e1 f3 ff ff       	call   801293 <fd_alloc>
  801eb2:	89 c3                	mov    %eax,%ebx
  801eb4:	83 c4 10             	add    $0x10,%esp
  801eb7:	85 c0                	test   %eax,%eax
  801eb9:	78 43                	js     801efe <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801ebb:	83 ec 04             	sub    $0x4,%esp
  801ebe:	68 07 04 00 00       	push   $0x407
  801ec3:	ff 75 f4             	pushl  -0xc(%ebp)
  801ec6:	6a 00                	push   $0x0
  801ec8:	e8 8f f1 ff ff       	call   80105c <sys_page_alloc>
  801ecd:	89 c3                	mov    %eax,%ebx
  801ecf:	83 c4 10             	add    $0x10,%esp
  801ed2:	85 c0                	test   %eax,%eax
  801ed4:	78 28                	js     801efe <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801ed6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed9:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801edf:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801ee1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee4:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801eeb:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801eee:	83 ec 0c             	sub    $0xc,%esp
  801ef1:	50                   	push   %eax
  801ef2:	e8 75 f3 ff ff       	call   80126c <fd2num>
  801ef7:	89 c3                	mov    %eax,%ebx
  801ef9:	83 c4 10             	add    $0x10,%esp
  801efc:	eb 0c                	jmp    801f0a <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801efe:	83 ec 0c             	sub    $0xc,%esp
  801f01:	56                   	push   %esi
  801f02:	e8 e2 01 00 00       	call   8020e9 <nsipc_close>
		return r;
  801f07:	83 c4 10             	add    $0x10,%esp
}
  801f0a:	89 d8                	mov    %ebx,%eax
  801f0c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f0f:	5b                   	pop    %ebx
  801f10:	5e                   	pop    %esi
  801f11:	5d                   	pop    %ebp
  801f12:	c3                   	ret    

00801f13 <accept>:
{
  801f13:	55                   	push   %ebp
  801f14:	89 e5                	mov    %esp,%ebp
  801f16:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f19:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1c:	e8 4e ff ff ff       	call   801e6f <fd2sockid>
  801f21:	85 c0                	test   %eax,%eax
  801f23:	78 1b                	js     801f40 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801f25:	83 ec 04             	sub    $0x4,%esp
  801f28:	ff 75 10             	pushl  0x10(%ebp)
  801f2b:	ff 75 0c             	pushl  0xc(%ebp)
  801f2e:	50                   	push   %eax
  801f2f:	e8 0e 01 00 00       	call   802042 <nsipc_accept>
  801f34:	83 c4 10             	add    $0x10,%esp
  801f37:	85 c0                	test   %eax,%eax
  801f39:	78 05                	js     801f40 <accept+0x2d>
	return alloc_sockfd(r);
  801f3b:	e8 5f ff ff ff       	call   801e9f <alloc_sockfd>
}
  801f40:	c9                   	leave  
  801f41:	c3                   	ret    

00801f42 <bind>:
{
  801f42:	55                   	push   %ebp
  801f43:	89 e5                	mov    %esp,%ebp
  801f45:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f48:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4b:	e8 1f ff ff ff       	call   801e6f <fd2sockid>
  801f50:	85 c0                	test   %eax,%eax
  801f52:	78 12                	js     801f66 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801f54:	83 ec 04             	sub    $0x4,%esp
  801f57:	ff 75 10             	pushl  0x10(%ebp)
  801f5a:	ff 75 0c             	pushl  0xc(%ebp)
  801f5d:	50                   	push   %eax
  801f5e:	e8 2f 01 00 00       	call   802092 <nsipc_bind>
  801f63:	83 c4 10             	add    $0x10,%esp
}
  801f66:	c9                   	leave  
  801f67:	c3                   	ret    

00801f68 <shutdown>:
{
  801f68:	55                   	push   %ebp
  801f69:	89 e5                	mov    %esp,%ebp
  801f6b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f71:	e8 f9 fe ff ff       	call   801e6f <fd2sockid>
  801f76:	85 c0                	test   %eax,%eax
  801f78:	78 0f                	js     801f89 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801f7a:	83 ec 08             	sub    $0x8,%esp
  801f7d:	ff 75 0c             	pushl  0xc(%ebp)
  801f80:	50                   	push   %eax
  801f81:	e8 41 01 00 00       	call   8020c7 <nsipc_shutdown>
  801f86:	83 c4 10             	add    $0x10,%esp
}
  801f89:	c9                   	leave  
  801f8a:	c3                   	ret    

00801f8b <connect>:
{
  801f8b:	55                   	push   %ebp
  801f8c:	89 e5                	mov    %esp,%ebp
  801f8e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f91:	8b 45 08             	mov    0x8(%ebp),%eax
  801f94:	e8 d6 fe ff ff       	call   801e6f <fd2sockid>
  801f99:	85 c0                	test   %eax,%eax
  801f9b:	78 12                	js     801faf <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801f9d:	83 ec 04             	sub    $0x4,%esp
  801fa0:	ff 75 10             	pushl  0x10(%ebp)
  801fa3:	ff 75 0c             	pushl  0xc(%ebp)
  801fa6:	50                   	push   %eax
  801fa7:	e8 57 01 00 00       	call   802103 <nsipc_connect>
  801fac:	83 c4 10             	add    $0x10,%esp
}
  801faf:	c9                   	leave  
  801fb0:	c3                   	ret    

00801fb1 <listen>:
{
  801fb1:	55                   	push   %ebp
  801fb2:	89 e5                	mov    %esp,%ebp
  801fb4:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801fb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801fba:	e8 b0 fe ff ff       	call   801e6f <fd2sockid>
  801fbf:	85 c0                	test   %eax,%eax
  801fc1:	78 0f                	js     801fd2 <listen+0x21>
	return nsipc_listen(r, backlog);
  801fc3:	83 ec 08             	sub    $0x8,%esp
  801fc6:	ff 75 0c             	pushl  0xc(%ebp)
  801fc9:	50                   	push   %eax
  801fca:	e8 69 01 00 00       	call   802138 <nsipc_listen>
  801fcf:	83 c4 10             	add    $0x10,%esp
}
  801fd2:	c9                   	leave  
  801fd3:	c3                   	ret    

00801fd4 <socket>:

int
socket(int domain, int type, int protocol)
{
  801fd4:	55                   	push   %ebp
  801fd5:	89 e5                	mov    %esp,%ebp
  801fd7:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801fda:	ff 75 10             	pushl  0x10(%ebp)
  801fdd:	ff 75 0c             	pushl  0xc(%ebp)
  801fe0:	ff 75 08             	pushl  0x8(%ebp)
  801fe3:	e8 3c 02 00 00       	call   802224 <nsipc_socket>
  801fe8:	83 c4 10             	add    $0x10,%esp
  801feb:	85 c0                	test   %eax,%eax
  801fed:	78 05                	js     801ff4 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801fef:	e8 ab fe ff ff       	call   801e9f <alloc_sockfd>
}
  801ff4:	c9                   	leave  
  801ff5:	c3                   	ret    

00801ff6 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801ff6:	55                   	push   %ebp
  801ff7:	89 e5                	mov    %esp,%ebp
  801ff9:	53                   	push   %ebx
  801ffa:	83 ec 04             	sub    $0x4,%esp
  801ffd:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801fff:	83 3d 14 40 80 00 00 	cmpl   $0x0,0x804014
  802006:	74 26                	je     80202e <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802008:	6a 07                	push   $0x7
  80200a:	68 00 60 80 00       	push   $0x806000
  80200f:	53                   	push   %ebx
  802010:	ff 35 14 40 80 00    	pushl  0x804014
  802016:	e8 5f 04 00 00       	call   80247a <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  80201b:	83 c4 0c             	add    $0xc,%esp
  80201e:	6a 00                	push   $0x0
  802020:	6a 00                	push   $0x0
  802022:	6a 00                	push   $0x0
  802024:	e8 e8 03 00 00       	call   802411 <ipc_recv>
}
  802029:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80202c:	c9                   	leave  
  80202d:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80202e:	83 ec 0c             	sub    $0xc,%esp
  802031:	6a 02                	push   $0x2
  802033:	e8 9b 04 00 00       	call   8024d3 <ipc_find_env>
  802038:	a3 14 40 80 00       	mov    %eax,0x804014
  80203d:	83 c4 10             	add    $0x10,%esp
  802040:	eb c6                	jmp    802008 <nsipc+0x12>

00802042 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802042:	55                   	push   %ebp
  802043:	89 e5                	mov    %esp,%ebp
  802045:	56                   	push   %esi
  802046:	53                   	push   %ebx
  802047:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  80204a:	8b 45 08             	mov    0x8(%ebp),%eax
  80204d:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802052:	8b 06                	mov    (%esi),%eax
  802054:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802059:	b8 01 00 00 00       	mov    $0x1,%eax
  80205e:	e8 93 ff ff ff       	call   801ff6 <nsipc>
  802063:	89 c3                	mov    %eax,%ebx
  802065:	85 c0                	test   %eax,%eax
  802067:	78 20                	js     802089 <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802069:	83 ec 04             	sub    $0x4,%esp
  80206c:	ff 35 10 60 80 00    	pushl  0x806010
  802072:	68 00 60 80 00       	push   $0x806000
  802077:	ff 75 0c             	pushl  0xc(%ebp)
  80207a:	e8 72 ed ff ff       	call   800df1 <memmove>
		*addrlen = ret->ret_addrlen;
  80207f:	a1 10 60 80 00       	mov    0x806010,%eax
  802084:	89 06                	mov    %eax,(%esi)
  802086:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  802089:	89 d8                	mov    %ebx,%eax
  80208b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80208e:	5b                   	pop    %ebx
  80208f:	5e                   	pop    %esi
  802090:	5d                   	pop    %ebp
  802091:	c3                   	ret    

00802092 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802092:	55                   	push   %ebp
  802093:	89 e5                	mov    %esp,%ebp
  802095:	53                   	push   %ebx
  802096:	83 ec 08             	sub    $0x8,%esp
  802099:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  80209c:	8b 45 08             	mov    0x8(%ebp),%eax
  80209f:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8020a4:	53                   	push   %ebx
  8020a5:	ff 75 0c             	pushl  0xc(%ebp)
  8020a8:	68 04 60 80 00       	push   $0x806004
  8020ad:	e8 3f ed ff ff       	call   800df1 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8020b2:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  8020b8:	b8 02 00 00 00       	mov    $0x2,%eax
  8020bd:	e8 34 ff ff ff       	call   801ff6 <nsipc>
}
  8020c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020c5:	c9                   	leave  
  8020c6:	c3                   	ret    

008020c7 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8020c7:	55                   	push   %ebp
  8020c8:	89 e5                	mov    %esp,%ebp
  8020ca:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8020cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d0:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  8020d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020d8:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  8020dd:	b8 03 00 00 00       	mov    $0x3,%eax
  8020e2:	e8 0f ff ff ff       	call   801ff6 <nsipc>
}
  8020e7:	c9                   	leave  
  8020e8:	c3                   	ret    

008020e9 <nsipc_close>:

int
nsipc_close(int s)
{
  8020e9:	55                   	push   %ebp
  8020ea:	89 e5                	mov    %esp,%ebp
  8020ec:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8020ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f2:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  8020f7:	b8 04 00 00 00       	mov    $0x4,%eax
  8020fc:	e8 f5 fe ff ff       	call   801ff6 <nsipc>
}
  802101:	c9                   	leave  
  802102:	c3                   	ret    

00802103 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802103:	55                   	push   %ebp
  802104:	89 e5                	mov    %esp,%ebp
  802106:	53                   	push   %ebx
  802107:	83 ec 08             	sub    $0x8,%esp
  80210a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80210d:	8b 45 08             	mov    0x8(%ebp),%eax
  802110:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802115:	53                   	push   %ebx
  802116:	ff 75 0c             	pushl  0xc(%ebp)
  802119:	68 04 60 80 00       	push   $0x806004
  80211e:	e8 ce ec ff ff       	call   800df1 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802123:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  802129:	b8 05 00 00 00       	mov    $0x5,%eax
  80212e:	e8 c3 fe ff ff       	call   801ff6 <nsipc>
}
  802133:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802136:	c9                   	leave  
  802137:	c3                   	ret    

00802138 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802138:	55                   	push   %ebp
  802139:	89 e5                	mov    %esp,%ebp
  80213b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80213e:	8b 45 08             	mov    0x8(%ebp),%eax
  802141:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  802146:	8b 45 0c             	mov    0xc(%ebp),%eax
  802149:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  80214e:	b8 06 00 00 00       	mov    $0x6,%eax
  802153:	e8 9e fe ff ff       	call   801ff6 <nsipc>
}
  802158:	c9                   	leave  
  802159:	c3                   	ret    

0080215a <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80215a:	55                   	push   %ebp
  80215b:	89 e5                	mov    %esp,%ebp
  80215d:	56                   	push   %esi
  80215e:	53                   	push   %ebx
  80215f:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802162:	8b 45 08             	mov    0x8(%ebp),%eax
  802165:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  80216a:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  802170:	8b 45 14             	mov    0x14(%ebp),%eax
  802173:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802178:	b8 07 00 00 00       	mov    $0x7,%eax
  80217d:	e8 74 fe ff ff       	call   801ff6 <nsipc>
  802182:	89 c3                	mov    %eax,%ebx
  802184:	85 c0                	test   %eax,%eax
  802186:	78 1f                	js     8021a7 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  802188:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  80218d:	7f 21                	jg     8021b0 <nsipc_recv+0x56>
  80218f:	39 c6                	cmp    %eax,%esi
  802191:	7c 1d                	jl     8021b0 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802193:	83 ec 04             	sub    $0x4,%esp
  802196:	50                   	push   %eax
  802197:	68 00 60 80 00       	push   $0x806000
  80219c:	ff 75 0c             	pushl  0xc(%ebp)
  80219f:	e8 4d ec ff ff       	call   800df1 <memmove>
  8021a4:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8021a7:	89 d8                	mov    %ebx,%eax
  8021a9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021ac:	5b                   	pop    %ebx
  8021ad:	5e                   	pop    %esi
  8021ae:	5d                   	pop    %ebp
  8021af:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8021b0:	68 27 2d 80 00       	push   $0x802d27
  8021b5:	68 c9 2c 80 00       	push   $0x802cc9
  8021ba:	6a 62                	push   $0x62
  8021bc:	68 3c 2d 80 00       	push   $0x802d3c
  8021c1:	e8 05 02 00 00       	call   8023cb <_panic>

008021c6 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8021c6:	55                   	push   %ebp
  8021c7:	89 e5                	mov    %esp,%ebp
  8021c9:	53                   	push   %ebx
  8021ca:	83 ec 04             	sub    $0x4,%esp
  8021cd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8021d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d3:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  8021d8:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8021de:	7f 2e                	jg     80220e <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8021e0:	83 ec 04             	sub    $0x4,%esp
  8021e3:	53                   	push   %ebx
  8021e4:	ff 75 0c             	pushl  0xc(%ebp)
  8021e7:	68 0c 60 80 00       	push   $0x80600c
  8021ec:	e8 00 ec ff ff       	call   800df1 <memmove>
	nsipcbuf.send.req_size = size;
  8021f1:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  8021f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8021fa:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  8021ff:	b8 08 00 00 00       	mov    $0x8,%eax
  802204:	e8 ed fd ff ff       	call   801ff6 <nsipc>
}
  802209:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80220c:	c9                   	leave  
  80220d:	c3                   	ret    
	assert(size < 1600);
  80220e:	68 48 2d 80 00       	push   $0x802d48
  802213:	68 c9 2c 80 00       	push   $0x802cc9
  802218:	6a 6d                	push   $0x6d
  80221a:	68 3c 2d 80 00       	push   $0x802d3c
  80221f:	e8 a7 01 00 00       	call   8023cb <_panic>

00802224 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802224:	55                   	push   %ebp
  802225:	89 e5                	mov    %esp,%ebp
  802227:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80222a:	8b 45 08             	mov    0x8(%ebp),%eax
  80222d:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  802232:	8b 45 0c             	mov    0xc(%ebp),%eax
  802235:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  80223a:	8b 45 10             	mov    0x10(%ebp),%eax
  80223d:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  802242:	b8 09 00 00 00       	mov    $0x9,%eax
  802247:	e8 aa fd ff ff       	call   801ff6 <nsipc>
}
  80224c:	c9                   	leave  
  80224d:	c3                   	ret    

0080224e <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  80224e:	55                   	push   %ebp
  80224f:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802251:	b8 00 00 00 00       	mov    $0x0,%eax
  802256:	5d                   	pop    %ebp
  802257:	c3                   	ret    

00802258 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802258:	55                   	push   %ebp
  802259:	89 e5                	mov    %esp,%ebp
  80225b:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80225e:	68 54 2d 80 00       	push   $0x802d54
  802263:	ff 75 0c             	pushl  0xc(%ebp)
  802266:	e8 f8 e9 ff ff       	call   800c63 <strcpy>
	return 0;
}
  80226b:	b8 00 00 00 00       	mov    $0x0,%eax
  802270:	c9                   	leave  
  802271:	c3                   	ret    

00802272 <devcons_write>:
{
  802272:	55                   	push   %ebp
  802273:	89 e5                	mov    %esp,%ebp
  802275:	57                   	push   %edi
  802276:	56                   	push   %esi
  802277:	53                   	push   %ebx
  802278:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80227e:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802283:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802289:	eb 2f                	jmp    8022ba <devcons_write+0x48>
		m = n - tot;
  80228b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80228e:	29 f3                	sub    %esi,%ebx
  802290:	83 fb 7f             	cmp    $0x7f,%ebx
  802293:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802298:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80229b:	83 ec 04             	sub    $0x4,%esp
  80229e:	53                   	push   %ebx
  80229f:	89 f0                	mov    %esi,%eax
  8022a1:	03 45 0c             	add    0xc(%ebp),%eax
  8022a4:	50                   	push   %eax
  8022a5:	57                   	push   %edi
  8022a6:	e8 46 eb ff ff       	call   800df1 <memmove>
		sys_cputs(buf, m);
  8022ab:	83 c4 08             	add    $0x8,%esp
  8022ae:	53                   	push   %ebx
  8022af:	57                   	push   %edi
  8022b0:	e8 eb ec ff ff       	call   800fa0 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8022b5:	01 de                	add    %ebx,%esi
  8022b7:	83 c4 10             	add    $0x10,%esp
  8022ba:	3b 75 10             	cmp    0x10(%ebp),%esi
  8022bd:	72 cc                	jb     80228b <devcons_write+0x19>
}
  8022bf:	89 f0                	mov    %esi,%eax
  8022c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022c4:	5b                   	pop    %ebx
  8022c5:	5e                   	pop    %esi
  8022c6:	5f                   	pop    %edi
  8022c7:	5d                   	pop    %ebp
  8022c8:	c3                   	ret    

008022c9 <devcons_read>:
{
  8022c9:	55                   	push   %ebp
  8022ca:	89 e5                	mov    %esp,%ebp
  8022cc:	83 ec 08             	sub    $0x8,%esp
  8022cf:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8022d4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8022d8:	75 07                	jne    8022e1 <devcons_read+0x18>
}
  8022da:	c9                   	leave  
  8022db:	c3                   	ret    
		sys_yield();
  8022dc:	e8 5c ed ff ff       	call   80103d <sys_yield>
	while ((c = sys_cgetc()) == 0)
  8022e1:	e8 d8 ec ff ff       	call   800fbe <sys_cgetc>
  8022e6:	85 c0                	test   %eax,%eax
  8022e8:	74 f2                	je     8022dc <devcons_read+0x13>
	if (c < 0)
  8022ea:	85 c0                	test   %eax,%eax
  8022ec:	78 ec                	js     8022da <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  8022ee:	83 f8 04             	cmp    $0x4,%eax
  8022f1:	74 0c                	je     8022ff <devcons_read+0x36>
	*(char*)vbuf = c;
  8022f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022f6:	88 02                	mov    %al,(%edx)
	return 1;
  8022f8:	b8 01 00 00 00       	mov    $0x1,%eax
  8022fd:	eb db                	jmp    8022da <devcons_read+0x11>
		return 0;
  8022ff:	b8 00 00 00 00       	mov    $0x0,%eax
  802304:	eb d4                	jmp    8022da <devcons_read+0x11>

00802306 <cputchar>:
{
  802306:	55                   	push   %ebp
  802307:	89 e5                	mov    %esp,%ebp
  802309:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80230c:	8b 45 08             	mov    0x8(%ebp),%eax
  80230f:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802312:	6a 01                	push   $0x1
  802314:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802317:	50                   	push   %eax
  802318:	e8 83 ec ff ff       	call   800fa0 <sys_cputs>
}
  80231d:	83 c4 10             	add    $0x10,%esp
  802320:	c9                   	leave  
  802321:	c3                   	ret    

00802322 <getchar>:
{
  802322:	55                   	push   %ebp
  802323:	89 e5                	mov    %esp,%ebp
  802325:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802328:	6a 01                	push   $0x1
  80232a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80232d:	50                   	push   %eax
  80232e:	6a 00                	push   $0x0
  802330:	e8 1e f2 ff ff       	call   801553 <read>
	if (r < 0)
  802335:	83 c4 10             	add    $0x10,%esp
  802338:	85 c0                	test   %eax,%eax
  80233a:	78 08                	js     802344 <getchar+0x22>
	if (r < 1)
  80233c:	85 c0                	test   %eax,%eax
  80233e:	7e 06                	jle    802346 <getchar+0x24>
	return c;
  802340:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802344:	c9                   	leave  
  802345:	c3                   	ret    
		return -E_EOF;
  802346:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80234b:	eb f7                	jmp    802344 <getchar+0x22>

0080234d <iscons>:
{
  80234d:	55                   	push   %ebp
  80234e:	89 e5                	mov    %esp,%ebp
  802350:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802353:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802356:	50                   	push   %eax
  802357:	ff 75 08             	pushl  0x8(%ebp)
  80235a:	e8 83 ef ff ff       	call   8012e2 <fd_lookup>
  80235f:	83 c4 10             	add    $0x10,%esp
  802362:	85 c0                	test   %eax,%eax
  802364:	78 11                	js     802377 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802366:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802369:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80236f:	39 10                	cmp    %edx,(%eax)
  802371:	0f 94 c0             	sete   %al
  802374:	0f b6 c0             	movzbl %al,%eax
}
  802377:	c9                   	leave  
  802378:	c3                   	ret    

00802379 <opencons>:
{
  802379:	55                   	push   %ebp
  80237a:	89 e5                	mov    %esp,%ebp
  80237c:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80237f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802382:	50                   	push   %eax
  802383:	e8 0b ef ff ff       	call   801293 <fd_alloc>
  802388:	83 c4 10             	add    $0x10,%esp
  80238b:	85 c0                	test   %eax,%eax
  80238d:	78 3a                	js     8023c9 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80238f:	83 ec 04             	sub    $0x4,%esp
  802392:	68 07 04 00 00       	push   $0x407
  802397:	ff 75 f4             	pushl  -0xc(%ebp)
  80239a:	6a 00                	push   $0x0
  80239c:	e8 bb ec ff ff       	call   80105c <sys_page_alloc>
  8023a1:	83 c4 10             	add    $0x10,%esp
  8023a4:	85 c0                	test   %eax,%eax
  8023a6:	78 21                	js     8023c9 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8023a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ab:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8023b1:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8023b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b6:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8023bd:	83 ec 0c             	sub    $0xc,%esp
  8023c0:	50                   	push   %eax
  8023c1:	e8 a6 ee ff ff       	call   80126c <fd2num>
  8023c6:	83 c4 10             	add    $0x10,%esp
}
  8023c9:	c9                   	leave  
  8023ca:	c3                   	ret    

008023cb <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8023cb:	55                   	push   %ebp
  8023cc:	89 e5                	mov    %esp,%ebp
  8023ce:	56                   	push   %esi
  8023cf:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8023d0:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8023d3:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8023d9:	e8 40 ec ff ff       	call   80101e <sys_getenvid>
  8023de:	83 ec 0c             	sub    $0xc,%esp
  8023e1:	ff 75 0c             	pushl  0xc(%ebp)
  8023e4:	ff 75 08             	pushl  0x8(%ebp)
  8023e7:	56                   	push   %esi
  8023e8:	50                   	push   %eax
  8023e9:	68 60 2d 80 00       	push   $0x802d60
  8023ee:	e8 d3 e1 ff ff       	call   8005c6 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8023f3:	83 c4 18             	add    $0x18,%esp
  8023f6:	53                   	push   %ebx
  8023f7:	ff 75 10             	pushl  0x10(%ebp)
  8023fa:	e8 76 e1 ff ff       	call   800575 <vcprintf>
	cprintf("\n");
  8023ff:	c7 04 24 14 2d 80 00 	movl   $0x802d14,(%esp)
  802406:	e8 bb e1 ff ff       	call   8005c6 <cprintf>
  80240b:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80240e:	cc                   	int3   
  80240f:	eb fd                	jmp    80240e <_panic+0x43>

00802411 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802411:	55                   	push   %ebp
  802412:	89 e5                	mov    %esp,%ebp
  802414:	56                   	push   %esi
  802415:	53                   	push   %ebx
  802416:	8b 75 08             	mov    0x8(%ebp),%esi
  802419:	8b 45 0c             	mov    0xc(%ebp),%eax
  80241c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
  80241f:	85 c0                	test   %eax,%eax
	    pg = (void *)UTOP;
  802421:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802426:	0f 44 c2             	cmove  %edx,%eax
	}
	if ((r = sys_ipc_recv(pg)) < 0) {
  802429:	83 ec 0c             	sub    $0xc,%esp
  80242c:	50                   	push   %eax
  80242d:	e8 da ed ff ff       	call   80120c <sys_ipc_recv>
  802432:	83 c4 10             	add    $0x10,%esp
  802435:	85 c0                	test   %eax,%eax
  802437:	78 2b                	js     802464 <ipc_recv+0x53>
	    if (perm_store != NULL) {
	        *perm_store = 0;
	    }
	    return r;
	}
	if (from_env_store != NULL) {
  802439:	85 f6                	test   %esi,%esi
  80243b:	74 0a                	je     802447 <ipc_recv+0x36>
	    *from_env_store = thisenv->env_ipc_from;
  80243d:	a1 18 40 80 00       	mov    0x804018,%eax
  802442:	8b 40 74             	mov    0x74(%eax),%eax
  802445:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store != NULL) {
  802447:	85 db                	test   %ebx,%ebx
  802449:	74 0a                	je     802455 <ipc_recv+0x44>
	    *perm_store = thisenv->env_ipc_perm;
  80244b:	a1 18 40 80 00       	mov    0x804018,%eax
  802450:	8b 40 78             	mov    0x78(%eax),%eax
  802453:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  802455:	a1 18 40 80 00       	mov    0x804018,%eax
  80245a:	8b 40 70             	mov    0x70(%eax),%eax
}
  80245d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802460:	5b                   	pop    %ebx
  802461:	5e                   	pop    %esi
  802462:	5d                   	pop    %ebp
  802463:	c3                   	ret    
	    if (from_env_store != NULL) {
  802464:	85 f6                	test   %esi,%esi
  802466:	74 06                	je     80246e <ipc_recv+0x5d>
	        *from_env_store = 0;
  802468:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	    if (perm_store != NULL) {
  80246e:	85 db                	test   %ebx,%ebx
  802470:	74 eb                	je     80245d <ipc_recv+0x4c>
	        *perm_store = 0;
  802472:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802478:	eb e3                	jmp    80245d <ipc_recv+0x4c>

0080247a <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80247a:	55                   	push   %ebp
  80247b:	89 e5                	mov    %esp,%ebp
  80247d:	57                   	push   %edi
  80247e:	56                   	push   %esi
  80247f:	53                   	push   %ebx
  802480:	83 ec 0c             	sub    $0xc,%esp
  802483:	8b 7d 08             	mov    0x8(%ebp),%edi
  802486:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
	    pg = (void *)UTOP;
  802489:	85 f6                	test   %esi,%esi
  80248b:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802490:	0f 44 f0             	cmove  %eax,%esi
  802493:	eb 09                	jmp    80249e <ipc_send+0x24>
	do {
	    r = sys_ipc_try_send(to_env, val, pg, perm);
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
	        panic("ipc_send: %e", r);
	    }
	    sys_yield();
  802495:	e8 a3 eb ff ff       	call   80103d <sys_yield>
	} while(r != 0);
  80249a:	85 db                	test   %ebx,%ebx
  80249c:	74 2d                	je     8024cb <ipc_send+0x51>
	    r = sys_ipc_try_send(to_env, val, pg, perm);
  80249e:	ff 75 14             	pushl  0x14(%ebp)
  8024a1:	56                   	push   %esi
  8024a2:	ff 75 0c             	pushl  0xc(%ebp)
  8024a5:	57                   	push   %edi
  8024a6:	e8 3e ed ff ff       	call   8011e9 <sys_ipc_try_send>
  8024ab:	89 c3                	mov    %eax,%ebx
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
  8024ad:	83 c4 10             	add    $0x10,%esp
  8024b0:	85 c0                	test   %eax,%eax
  8024b2:	79 e1                	jns    802495 <ipc_send+0x1b>
  8024b4:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8024b7:	74 dc                	je     802495 <ipc_send+0x1b>
	        panic("ipc_send: %e", r);
  8024b9:	50                   	push   %eax
  8024ba:	68 84 2d 80 00       	push   $0x802d84
  8024bf:	6a 45                	push   $0x45
  8024c1:	68 91 2d 80 00       	push   $0x802d91
  8024c6:	e8 00 ff ff ff       	call   8023cb <_panic>
}
  8024cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024ce:	5b                   	pop    %ebx
  8024cf:	5e                   	pop    %esi
  8024d0:	5f                   	pop    %edi
  8024d1:	5d                   	pop    %ebp
  8024d2:	c3                   	ret    

008024d3 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8024d3:	55                   	push   %ebp
  8024d4:	89 e5                	mov    %esp,%ebp
  8024d6:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8024d9:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8024de:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8024e1:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8024e7:	8b 52 50             	mov    0x50(%edx),%edx
  8024ea:	39 ca                	cmp    %ecx,%edx
  8024ec:	74 11                	je     8024ff <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  8024ee:	83 c0 01             	add    $0x1,%eax
  8024f1:	3d 00 04 00 00       	cmp    $0x400,%eax
  8024f6:	75 e6                	jne    8024de <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8024f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8024fd:	eb 0b                	jmp    80250a <ipc_find_env+0x37>
			return envs[i].env_id;
  8024ff:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802502:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802507:	8b 40 48             	mov    0x48(%eax),%eax
}
  80250a:	5d                   	pop    %ebp
  80250b:	c3                   	ret    

0080250c <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80250c:	55                   	push   %ebp
  80250d:	89 e5                	mov    %esp,%ebp
  80250f:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802512:	89 d0                	mov    %edx,%eax
  802514:	c1 e8 16             	shr    $0x16,%eax
  802517:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80251e:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802523:	f6 c1 01             	test   $0x1,%cl
  802526:	74 1d                	je     802545 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802528:	c1 ea 0c             	shr    $0xc,%edx
  80252b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802532:	f6 c2 01             	test   $0x1,%dl
  802535:	74 0e                	je     802545 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802537:	c1 ea 0c             	shr    $0xc,%edx
  80253a:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802541:	ef 
  802542:	0f b7 c0             	movzwl %ax,%eax
}
  802545:	5d                   	pop    %ebp
  802546:	c3                   	ret    
  802547:	66 90                	xchg   %ax,%ax
  802549:	66 90                	xchg   %ax,%ax
  80254b:	66 90                	xchg   %ax,%ax
  80254d:	66 90                	xchg   %ax,%ax
  80254f:	90                   	nop

00802550 <__udivdi3>:
  802550:	55                   	push   %ebp
  802551:	57                   	push   %edi
  802552:	56                   	push   %esi
  802553:	53                   	push   %ebx
  802554:	83 ec 1c             	sub    $0x1c,%esp
  802557:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80255b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80255f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802563:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802567:	85 d2                	test   %edx,%edx
  802569:	75 35                	jne    8025a0 <__udivdi3+0x50>
  80256b:	39 f3                	cmp    %esi,%ebx
  80256d:	0f 87 bd 00 00 00    	ja     802630 <__udivdi3+0xe0>
  802573:	85 db                	test   %ebx,%ebx
  802575:	89 d9                	mov    %ebx,%ecx
  802577:	75 0b                	jne    802584 <__udivdi3+0x34>
  802579:	b8 01 00 00 00       	mov    $0x1,%eax
  80257e:	31 d2                	xor    %edx,%edx
  802580:	f7 f3                	div    %ebx
  802582:	89 c1                	mov    %eax,%ecx
  802584:	31 d2                	xor    %edx,%edx
  802586:	89 f0                	mov    %esi,%eax
  802588:	f7 f1                	div    %ecx
  80258a:	89 c6                	mov    %eax,%esi
  80258c:	89 e8                	mov    %ebp,%eax
  80258e:	89 f7                	mov    %esi,%edi
  802590:	f7 f1                	div    %ecx
  802592:	89 fa                	mov    %edi,%edx
  802594:	83 c4 1c             	add    $0x1c,%esp
  802597:	5b                   	pop    %ebx
  802598:	5e                   	pop    %esi
  802599:	5f                   	pop    %edi
  80259a:	5d                   	pop    %ebp
  80259b:	c3                   	ret    
  80259c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8025a0:	39 f2                	cmp    %esi,%edx
  8025a2:	77 7c                	ja     802620 <__udivdi3+0xd0>
  8025a4:	0f bd fa             	bsr    %edx,%edi
  8025a7:	83 f7 1f             	xor    $0x1f,%edi
  8025aa:	0f 84 98 00 00 00    	je     802648 <__udivdi3+0xf8>
  8025b0:	89 f9                	mov    %edi,%ecx
  8025b2:	b8 20 00 00 00       	mov    $0x20,%eax
  8025b7:	29 f8                	sub    %edi,%eax
  8025b9:	d3 e2                	shl    %cl,%edx
  8025bb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8025bf:	89 c1                	mov    %eax,%ecx
  8025c1:	89 da                	mov    %ebx,%edx
  8025c3:	d3 ea                	shr    %cl,%edx
  8025c5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8025c9:	09 d1                	or     %edx,%ecx
  8025cb:	89 f2                	mov    %esi,%edx
  8025cd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8025d1:	89 f9                	mov    %edi,%ecx
  8025d3:	d3 e3                	shl    %cl,%ebx
  8025d5:	89 c1                	mov    %eax,%ecx
  8025d7:	d3 ea                	shr    %cl,%edx
  8025d9:	89 f9                	mov    %edi,%ecx
  8025db:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8025df:	d3 e6                	shl    %cl,%esi
  8025e1:	89 eb                	mov    %ebp,%ebx
  8025e3:	89 c1                	mov    %eax,%ecx
  8025e5:	d3 eb                	shr    %cl,%ebx
  8025e7:	09 de                	or     %ebx,%esi
  8025e9:	89 f0                	mov    %esi,%eax
  8025eb:	f7 74 24 08          	divl   0x8(%esp)
  8025ef:	89 d6                	mov    %edx,%esi
  8025f1:	89 c3                	mov    %eax,%ebx
  8025f3:	f7 64 24 0c          	mull   0xc(%esp)
  8025f7:	39 d6                	cmp    %edx,%esi
  8025f9:	72 0c                	jb     802607 <__udivdi3+0xb7>
  8025fb:	89 f9                	mov    %edi,%ecx
  8025fd:	d3 e5                	shl    %cl,%ebp
  8025ff:	39 c5                	cmp    %eax,%ebp
  802601:	73 5d                	jae    802660 <__udivdi3+0x110>
  802603:	39 d6                	cmp    %edx,%esi
  802605:	75 59                	jne    802660 <__udivdi3+0x110>
  802607:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80260a:	31 ff                	xor    %edi,%edi
  80260c:	89 fa                	mov    %edi,%edx
  80260e:	83 c4 1c             	add    $0x1c,%esp
  802611:	5b                   	pop    %ebx
  802612:	5e                   	pop    %esi
  802613:	5f                   	pop    %edi
  802614:	5d                   	pop    %ebp
  802615:	c3                   	ret    
  802616:	8d 76 00             	lea    0x0(%esi),%esi
  802619:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  802620:	31 ff                	xor    %edi,%edi
  802622:	31 c0                	xor    %eax,%eax
  802624:	89 fa                	mov    %edi,%edx
  802626:	83 c4 1c             	add    $0x1c,%esp
  802629:	5b                   	pop    %ebx
  80262a:	5e                   	pop    %esi
  80262b:	5f                   	pop    %edi
  80262c:	5d                   	pop    %ebp
  80262d:	c3                   	ret    
  80262e:	66 90                	xchg   %ax,%ax
  802630:	31 ff                	xor    %edi,%edi
  802632:	89 e8                	mov    %ebp,%eax
  802634:	89 f2                	mov    %esi,%edx
  802636:	f7 f3                	div    %ebx
  802638:	89 fa                	mov    %edi,%edx
  80263a:	83 c4 1c             	add    $0x1c,%esp
  80263d:	5b                   	pop    %ebx
  80263e:	5e                   	pop    %esi
  80263f:	5f                   	pop    %edi
  802640:	5d                   	pop    %ebp
  802641:	c3                   	ret    
  802642:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802648:	39 f2                	cmp    %esi,%edx
  80264a:	72 06                	jb     802652 <__udivdi3+0x102>
  80264c:	31 c0                	xor    %eax,%eax
  80264e:	39 eb                	cmp    %ebp,%ebx
  802650:	77 d2                	ja     802624 <__udivdi3+0xd4>
  802652:	b8 01 00 00 00       	mov    $0x1,%eax
  802657:	eb cb                	jmp    802624 <__udivdi3+0xd4>
  802659:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802660:	89 d8                	mov    %ebx,%eax
  802662:	31 ff                	xor    %edi,%edi
  802664:	eb be                	jmp    802624 <__udivdi3+0xd4>
  802666:	66 90                	xchg   %ax,%ax
  802668:	66 90                	xchg   %ax,%ax
  80266a:	66 90                	xchg   %ax,%ax
  80266c:	66 90                	xchg   %ax,%ax
  80266e:	66 90                	xchg   %ax,%ax

00802670 <__umoddi3>:
  802670:	55                   	push   %ebp
  802671:	57                   	push   %edi
  802672:	56                   	push   %esi
  802673:	53                   	push   %ebx
  802674:	83 ec 1c             	sub    $0x1c,%esp
  802677:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  80267b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80267f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802683:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802687:	85 ed                	test   %ebp,%ebp
  802689:	89 f0                	mov    %esi,%eax
  80268b:	89 da                	mov    %ebx,%edx
  80268d:	75 19                	jne    8026a8 <__umoddi3+0x38>
  80268f:	39 df                	cmp    %ebx,%edi
  802691:	0f 86 b1 00 00 00    	jbe    802748 <__umoddi3+0xd8>
  802697:	f7 f7                	div    %edi
  802699:	89 d0                	mov    %edx,%eax
  80269b:	31 d2                	xor    %edx,%edx
  80269d:	83 c4 1c             	add    $0x1c,%esp
  8026a0:	5b                   	pop    %ebx
  8026a1:	5e                   	pop    %esi
  8026a2:	5f                   	pop    %edi
  8026a3:	5d                   	pop    %ebp
  8026a4:	c3                   	ret    
  8026a5:	8d 76 00             	lea    0x0(%esi),%esi
  8026a8:	39 dd                	cmp    %ebx,%ebp
  8026aa:	77 f1                	ja     80269d <__umoddi3+0x2d>
  8026ac:	0f bd cd             	bsr    %ebp,%ecx
  8026af:	83 f1 1f             	xor    $0x1f,%ecx
  8026b2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8026b6:	0f 84 b4 00 00 00    	je     802770 <__umoddi3+0x100>
  8026bc:	b8 20 00 00 00       	mov    $0x20,%eax
  8026c1:	89 c2                	mov    %eax,%edx
  8026c3:	8b 44 24 04          	mov    0x4(%esp),%eax
  8026c7:	29 c2                	sub    %eax,%edx
  8026c9:	89 c1                	mov    %eax,%ecx
  8026cb:	89 f8                	mov    %edi,%eax
  8026cd:	d3 e5                	shl    %cl,%ebp
  8026cf:	89 d1                	mov    %edx,%ecx
  8026d1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8026d5:	d3 e8                	shr    %cl,%eax
  8026d7:	09 c5                	or     %eax,%ebp
  8026d9:	8b 44 24 04          	mov    0x4(%esp),%eax
  8026dd:	89 c1                	mov    %eax,%ecx
  8026df:	d3 e7                	shl    %cl,%edi
  8026e1:	89 d1                	mov    %edx,%ecx
  8026e3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8026e7:	89 df                	mov    %ebx,%edi
  8026e9:	d3 ef                	shr    %cl,%edi
  8026eb:	89 c1                	mov    %eax,%ecx
  8026ed:	89 f0                	mov    %esi,%eax
  8026ef:	d3 e3                	shl    %cl,%ebx
  8026f1:	89 d1                	mov    %edx,%ecx
  8026f3:	89 fa                	mov    %edi,%edx
  8026f5:	d3 e8                	shr    %cl,%eax
  8026f7:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8026fc:	09 d8                	or     %ebx,%eax
  8026fe:	f7 f5                	div    %ebp
  802700:	d3 e6                	shl    %cl,%esi
  802702:	89 d1                	mov    %edx,%ecx
  802704:	f7 64 24 08          	mull   0x8(%esp)
  802708:	39 d1                	cmp    %edx,%ecx
  80270a:	89 c3                	mov    %eax,%ebx
  80270c:	89 d7                	mov    %edx,%edi
  80270e:	72 06                	jb     802716 <__umoddi3+0xa6>
  802710:	75 0e                	jne    802720 <__umoddi3+0xb0>
  802712:	39 c6                	cmp    %eax,%esi
  802714:	73 0a                	jae    802720 <__umoddi3+0xb0>
  802716:	2b 44 24 08          	sub    0x8(%esp),%eax
  80271a:	19 ea                	sbb    %ebp,%edx
  80271c:	89 d7                	mov    %edx,%edi
  80271e:	89 c3                	mov    %eax,%ebx
  802720:	89 ca                	mov    %ecx,%edx
  802722:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  802727:	29 de                	sub    %ebx,%esi
  802729:	19 fa                	sbb    %edi,%edx
  80272b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  80272f:	89 d0                	mov    %edx,%eax
  802731:	d3 e0                	shl    %cl,%eax
  802733:	89 d9                	mov    %ebx,%ecx
  802735:	d3 ee                	shr    %cl,%esi
  802737:	d3 ea                	shr    %cl,%edx
  802739:	09 f0                	or     %esi,%eax
  80273b:	83 c4 1c             	add    $0x1c,%esp
  80273e:	5b                   	pop    %ebx
  80273f:	5e                   	pop    %esi
  802740:	5f                   	pop    %edi
  802741:	5d                   	pop    %ebp
  802742:	c3                   	ret    
  802743:	90                   	nop
  802744:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802748:	85 ff                	test   %edi,%edi
  80274a:	89 f9                	mov    %edi,%ecx
  80274c:	75 0b                	jne    802759 <__umoddi3+0xe9>
  80274e:	b8 01 00 00 00       	mov    $0x1,%eax
  802753:	31 d2                	xor    %edx,%edx
  802755:	f7 f7                	div    %edi
  802757:	89 c1                	mov    %eax,%ecx
  802759:	89 d8                	mov    %ebx,%eax
  80275b:	31 d2                	xor    %edx,%edx
  80275d:	f7 f1                	div    %ecx
  80275f:	89 f0                	mov    %esi,%eax
  802761:	f7 f1                	div    %ecx
  802763:	e9 31 ff ff ff       	jmp    802699 <__umoddi3+0x29>
  802768:	90                   	nop
  802769:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802770:	39 dd                	cmp    %ebx,%ebp
  802772:	72 08                	jb     80277c <__umoddi3+0x10c>
  802774:	39 f7                	cmp    %esi,%edi
  802776:	0f 87 21 ff ff ff    	ja     80269d <__umoddi3+0x2d>
  80277c:	89 da                	mov    %ebx,%edx
  80277e:	89 f0                	mov    %esi,%eax
  802780:	29 f8                	sub    %edi,%eax
  802782:	19 ea                	sbb    %ebp,%edx
  802784:	e9 14 ff ff ff       	jmp    80269d <__umoddi3+0x2d>
