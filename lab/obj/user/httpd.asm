
obj/user/httpd.debug:     file format elf32-i386


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
  80002c:	e8 5d 05 00 00       	call   80058e <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <die>:
	{404, "Not Found"},
};

static void
die(char *m)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	cprintf("%s\n", m);
  800039:	50                   	push   %eax
  80003a:	68 e0 2a 80 00       	push   $0x802ae0
  80003f:	e8 85 06 00 00       	call   8006c9 <cprintf>
	exit();
  800044:	e8 8b 05 00 00       	call   8005d4 <exit>
}
  800049:	83 c4 10             	add    $0x10,%esp
  80004c:	c9                   	leave  
  80004d:	c3                   	ret    

0080004e <handle_client>:
	return r;
}

static void
handle_client(int sock)
{
  80004e:	55                   	push   %ebp
  80004f:	89 e5                	mov    %esp,%ebp
  800051:	57                   	push   %edi
  800052:	56                   	push   %esi
  800053:	53                   	push   %ebx
  800054:	81 ec 20 04 00 00    	sub    $0x420,%esp
  80005a:	89 c3                	mov    %eax,%ebx
	struct http_request *req = &con_d;

	while (1)
	{
		// Receive message
		if ((received = read(sock, buffer, BUFFSIZE)) < 0)
  80005c:	68 00 02 00 00       	push   $0x200
  800061:	8d 85 dc fd ff ff    	lea    -0x224(%ebp),%eax
  800067:	50                   	push   %eax
  800068:	53                   	push   %ebx
  800069:	e8 e8 15 00 00       	call   801656 <read>
  80006e:	83 c4 10             	add    $0x10,%esp
  800071:	85 c0                	test   %eax,%eax
  800073:	78 3c                	js     8000b1 <handle_client+0x63>
			panic("failed to read");

		memset(req, 0, sizeof(*req));
  800075:	83 ec 04             	sub    $0x4,%esp
  800078:	6a 0c                	push   $0xc
  80007a:	6a 00                	push   $0x0
  80007c:	8d 45 dc             	lea    -0x24(%ebp),%eax
  80007f:	50                   	push   %eax
  800080:	e8 22 0e 00 00       	call   800ea7 <memset>

		req->sock = sock;
  800085:	89 5d dc             	mov    %ebx,-0x24(%ebp)
	if (strncmp(request, "GET ", 4) != 0)
  800088:	83 c4 0c             	add    $0xc,%esp
  80008b:	6a 04                	push   $0x4
  80008d:	68 00 2b 80 00       	push   $0x802b00
  800092:	8d 85 dc fd ff ff    	lea    -0x224(%ebp),%eax
  800098:	50                   	push   %eax
  800099:	e8 94 0d 00 00       	call   800e32 <strncmp>
  80009e:	83 c4 10             	add    $0x10,%esp
  8000a1:	85 c0                	test   %eax,%eax
  8000a3:	0f 85 17 01 00 00    	jne    8001c0 <handle_client+0x172>
	request += 4;
  8000a9:	8d 9d e0 fd ff ff    	lea    -0x220(%ebp),%ebx
  8000af:	eb 1a                	jmp    8000cb <handle_client+0x7d>
			panic("failed to read");
  8000b1:	83 ec 04             	sub    $0x4,%esp
  8000b4:	68 e4 2a 80 00       	push   $0x802ae4
  8000b9:	68 04 01 00 00       	push   $0x104
  8000be:	68 f3 2a 80 00       	push   $0x802af3
  8000c3:	e8 26 05 00 00       	call   8005ee <_panic>
		request++;
  8000c8:	83 c3 01             	add    $0x1,%ebx
	while (*request && *request != ' ')
  8000cb:	f6 03 df             	testb  $0xdf,(%ebx)
  8000ce:	75 f8                	jne    8000c8 <handle_client+0x7a>
	url_len = request - url;
  8000d0:	8d bd e0 fd ff ff    	lea    -0x220(%ebp),%edi
  8000d6:	89 de                	mov    %ebx,%esi
  8000d8:	29 fe                	sub    %edi,%esi
	req->url = malloc(url_len + 1);
  8000da:	83 ec 0c             	sub    $0xc,%esp
  8000dd:	8d 46 01             	lea    0x1(%esi),%eax
  8000e0:	50                   	push   %eax
  8000e1:	e8 19 23 00 00       	call   8023ff <malloc>
  8000e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
	memmove(req->url, url, url_len);
  8000e9:	83 c4 0c             	add    $0xc,%esp
  8000ec:	56                   	push   %esi
  8000ed:	57                   	push   %edi
  8000ee:	50                   	push   %eax
  8000ef:	e8 00 0e 00 00       	call   800ef4 <memmove>
	req->url[url_len] = '\0';
  8000f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8000f7:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
	request++;
  8000fb:	8d 73 01             	lea    0x1(%ebx),%esi
  8000fe:	83 c4 10             	add    $0x10,%esp
  800101:	89 f0                	mov    %esi,%eax
  800103:	eb 03                	jmp    800108 <handle_client+0xba>
		request++;
  800105:	83 c0 01             	add    $0x1,%eax
	while (*request && *request != '\n')
  800108:	0f b6 10             	movzbl (%eax),%edx
  80010b:	84 d2                	test   %dl,%dl
  80010d:	74 05                	je     800114 <handle_client+0xc6>
  80010f:	80 fa 0a             	cmp    $0xa,%dl
  800112:	75 f1                	jne    800105 <handle_client+0xb7>
	version_len = request - version;
  800114:	29 f0                	sub    %esi,%eax
  800116:	89 c3                	mov    %eax,%ebx
	req->version = malloc(version_len + 1);
  800118:	83 ec 0c             	sub    $0xc,%esp
  80011b:	8d 40 01             	lea    0x1(%eax),%eax
  80011e:	50                   	push   %eax
  80011f:	e8 db 22 00 00       	call   8023ff <malloc>
  800124:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	memmove(req->version, version, version_len);
  800127:	83 c4 0c             	add    $0xc,%esp
  80012a:	53                   	push   %ebx
  80012b:	56                   	push   %esi
  80012c:	50                   	push   %eax
  80012d:	e8 c2 0d 00 00       	call   800ef4 <memmove>
	req->version[version_len] = '\0';
  800132:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800135:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
	panic("send_file not implemented");
  800139:	83 c4 0c             	add    $0xc,%esp
  80013c:	68 05 2b 80 00       	push   $0x802b05
  800141:	68 e2 00 00 00       	push   $0xe2
  800146:	68 f3 2a 80 00       	push   $0x802af3
  80014b:	e8 9e 04 00 00       	call   8005ee <_panic>
		e++;
  800150:	83 c0 08             	add    $0x8,%eax
	while (e->code != 0 && e->msg != 0) {
  800153:	8b 10                	mov    (%eax),%edx
  800155:	85 d2                	test   %edx,%edx
  800157:	74 3e                	je     800197 <handle_client+0x149>
		if (e->code == code)
  800159:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
  80015d:	74 08                	je     800167 <handle_client+0x119>
  80015f:	81 fa 90 01 00 00    	cmp    $0x190,%edx
  800165:	75 e9                	jne    800150 <handle_client+0x102>
	r = snprintf(buf, 512, "HTTP/" HTTP_VERSION" %d %s\r\n"
  800167:	8b 40 04             	mov    0x4(%eax),%eax
  80016a:	83 ec 04             	sub    $0x4,%esp
  80016d:	50                   	push   %eax
  80016e:	52                   	push   %edx
  80016f:	50                   	push   %eax
  800170:	52                   	push   %edx
  800171:	68 54 2b 80 00       	push   $0x802b54
  800176:	68 00 02 00 00       	push   $0x200
  80017b:	8d b5 dc fb ff ff    	lea    -0x424(%ebp),%esi
  800181:	56                   	push   %esi
  800182:	e8 8e 0b 00 00       	call   800d15 <snprintf>
	if (write(req->sock, buf, r) != r)
  800187:	83 c4 1c             	add    $0x1c,%esp
  80018a:	50                   	push   %eax
  80018b:	56                   	push   %esi
  80018c:	ff 75 dc             	pushl  -0x24(%ebp)
  80018f:	e8 90 15 00 00       	call   801724 <write>
  800194:	83 c4 10             	add    $0x10,%esp
	free(req->url);
  800197:	83 ec 0c             	sub    $0xc,%esp
  80019a:	ff 75 e0             	pushl  -0x20(%ebp)
  80019d:	e8 af 21 00 00       	call   802351 <free>
	free(req->version);
  8001a2:	83 c4 04             	add    $0x4,%esp
  8001a5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001a8:	e8 a4 21 00 00       	call   802351 <free>

		// no keep alive
		break;
	}

	close(sock);
  8001ad:	89 1c 24             	mov    %ebx,(%esp)
  8001b0:	e8 65 13 00 00       	call   80151a <close>
}
  8001b5:	83 c4 10             	add    $0x10,%esp
  8001b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001bb:	5b                   	pop    %ebx
  8001bc:	5e                   	pop    %esi
  8001bd:	5f                   	pop    %edi
  8001be:	5d                   	pop    %ebp
  8001bf:	c3                   	ret    
	struct error_messages *e = errors;
  8001c0:	b8 00 40 80 00       	mov    $0x804000,%eax
  8001c5:	eb 8c                	jmp    800153 <handle_client+0x105>

008001c7 <umain>:

void
umain(int argc, char **argv)
{
  8001c7:	55                   	push   %ebp
  8001c8:	89 e5                	mov    %esp,%ebp
  8001ca:	57                   	push   %edi
  8001cb:	56                   	push   %esi
  8001cc:	53                   	push   %ebx
  8001cd:	83 ec 40             	sub    $0x40,%esp
	int serversock, clientsock;
	struct sockaddr_in server, client;

	binaryname = "jhttpd";
  8001d0:	c7 05 20 40 80 00 1f 	movl   $0x802b1f,0x804020
  8001d7:	2b 80 00 

	// Create the TCP socket
	if ((serversock = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0)
  8001da:	6a 06                	push   $0x6
  8001dc:	6a 01                	push   $0x1
  8001de:	6a 02                	push   $0x2
  8001e0:	e8 f2 1e 00 00       	call   8020d7 <socket>
  8001e5:	89 c6                	mov    %eax,%esi
  8001e7:	83 c4 10             	add    $0x10,%esp
  8001ea:	85 c0                	test   %eax,%eax
  8001ec:	78 6d                	js     80025b <umain+0x94>
		die("Failed to create socket");

	// Construct the server sockaddr_in structure
	memset(&server, 0, sizeof(server));		// Clear struct
  8001ee:	83 ec 04             	sub    $0x4,%esp
  8001f1:	6a 10                	push   $0x10
  8001f3:	6a 00                	push   $0x0
  8001f5:	8d 5d d8             	lea    -0x28(%ebp),%ebx
  8001f8:	53                   	push   %ebx
  8001f9:	e8 a9 0c 00 00       	call   800ea7 <memset>
	server.sin_family = AF_INET;			// Internet/IP
  8001fe:	c6 45 d9 02          	movb   $0x2,-0x27(%ebp)
	server.sin_addr.s_addr = htonl(INADDR_ANY);	// IP address
  800202:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800209:	e8 52 01 00 00       	call   800360 <htonl>
  80020e:	89 45 dc             	mov    %eax,-0x24(%ebp)
	server.sin_port = htons(PORT);			// server port
  800211:	c7 04 24 50 00 00 00 	movl   $0x50,(%esp)
  800218:	e8 29 01 00 00       	call   800346 <htons>
  80021d:	66 89 45 da          	mov    %ax,-0x26(%ebp)

	// Bind the server socket
	if (bind(serversock, (struct sockaddr *) &server,
  800221:	83 c4 0c             	add    $0xc,%esp
  800224:	6a 10                	push   $0x10
  800226:	53                   	push   %ebx
  800227:	56                   	push   %esi
  800228:	e8 18 1e 00 00       	call   802045 <bind>
  80022d:	83 c4 10             	add    $0x10,%esp
  800230:	85 c0                	test   %eax,%eax
  800232:	78 33                	js     800267 <umain+0xa0>
	{
		die("Failed to bind the server socket");
	}

	// Listen on the server socket
	if (listen(serversock, MAXPENDING) < 0)
  800234:	83 ec 08             	sub    $0x8,%esp
  800237:	6a 05                	push   $0x5
  800239:	56                   	push   %esi
  80023a:	e8 75 1e 00 00       	call   8020b4 <listen>
  80023f:	83 c4 10             	add    $0x10,%esp
  800242:	85 c0                	test   %eax,%eax
  800244:	78 2d                	js     800273 <umain+0xac>
		die("Failed to listen on server socket");

	cprintf("Waiting for http connections...\n");
  800246:	83 ec 0c             	sub    $0xc,%esp
  800249:	68 18 2c 80 00       	push   $0x802c18
  80024e:	e8 76 04 00 00       	call   8006c9 <cprintf>
  800253:	83 c4 10             	add    $0x10,%esp

	while (1) {
		unsigned int clientlen = sizeof(client);
		// Wait for client connection
		if ((clientsock = accept(serversock,
  800256:	8d 7d c4             	lea    -0x3c(%ebp),%edi
  800259:	eb 2b                	jmp    800286 <umain+0xbf>
		die("Failed to create socket");
  80025b:	b8 26 2b 80 00       	mov    $0x802b26,%eax
  800260:	e8 ce fd ff ff       	call   800033 <die>
  800265:	eb 87                	jmp    8001ee <umain+0x27>
		die("Failed to bind the server socket");
  800267:	b8 d0 2b 80 00       	mov    $0x802bd0,%eax
  80026c:	e8 c2 fd ff ff       	call   800033 <die>
  800271:	eb c1                	jmp    800234 <umain+0x6d>
		die("Failed to listen on server socket");
  800273:	b8 f4 2b 80 00       	mov    $0x802bf4,%eax
  800278:	e8 b6 fd ff ff       	call   800033 <die>
  80027d:	eb c7                	jmp    800246 <umain+0x7f>
					 (struct sockaddr *) &client,
					 &clientlen)) < 0)
		{
			die("Failed to accept client connection");
		}
		handle_client(clientsock);
  80027f:	89 d8                	mov    %ebx,%eax
  800281:	e8 c8 fd ff ff       	call   80004e <handle_client>
		unsigned int clientlen = sizeof(client);
  800286:	c7 45 c4 10 00 00 00 	movl   $0x10,-0x3c(%ebp)
		if ((clientsock = accept(serversock,
  80028d:	83 ec 04             	sub    $0x4,%esp
  800290:	57                   	push   %edi
  800291:	8d 45 c8             	lea    -0x38(%ebp),%eax
  800294:	50                   	push   %eax
  800295:	56                   	push   %esi
  800296:	e8 7b 1d 00 00       	call   802016 <accept>
  80029b:	89 c3                	mov    %eax,%ebx
  80029d:	83 c4 10             	add    $0x10,%esp
  8002a0:	85 c0                	test   %eax,%eax
  8002a2:	79 db                	jns    80027f <umain+0xb8>
			die("Failed to accept client connection");
  8002a4:	b8 3c 2c 80 00       	mov    $0x802c3c,%eax
  8002a9:	e8 85 fd ff ff       	call   800033 <die>
  8002ae:	eb cf                	jmp    80027f <umain+0xb8>

008002b0 <inet_ntoa>:
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
{
  8002b0:	55                   	push   %ebp
  8002b1:	89 e5                	mov    %esp,%ebp
  8002b3:	57                   	push   %edi
  8002b4:	56                   	push   %esi
  8002b5:	53                   	push   %ebx
  8002b6:	83 ec 14             	sub    $0x14,%esp
  static char str[16];
  u32_t s_addr = addr.s_addr;
  8002b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8002bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  8002bf:	8d 7d f0             	lea    -0x10(%ebp),%edi
  rp = str;
  8002c2:	c7 45 e0 00 50 80 00 	movl   $0x805000,-0x20(%ebp)
  8002c9:	eb 30                	jmp    8002fb <inet_ntoa+0x4b>
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
      *rp++ = inv[i];
  8002cb:	0f b6 c2             	movzbl %dl,%eax
  8002ce:	0f b6 44 05 ed       	movzbl -0x13(%ebp,%eax,1),%eax
  8002d3:	88 01                	mov    %al,(%ecx)
  8002d5:	83 c1 01             	add    $0x1,%ecx
    while(i--)
  8002d8:	83 ea 01             	sub    $0x1,%edx
  8002db:	80 fa ff             	cmp    $0xff,%dl
  8002de:	75 eb                	jne    8002cb <inet_ntoa+0x1b>
  8002e0:	89 f0                	mov    %esi,%eax
  8002e2:	0f b6 f0             	movzbl %al,%esi
  8002e5:	03 75 e0             	add    -0x20(%ebp),%esi
    *rp++ = '.';
  8002e8:	8d 46 01             	lea    0x1(%esi),%eax
  8002eb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002ee:	c6 06 2e             	movb   $0x2e,(%esi)
  8002f1:	83 c7 01             	add    $0x1,%edi
  for(n = 0; n < 4; n++) {
  8002f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8002f7:	39 c7                	cmp    %eax,%edi
  8002f9:	74 3b                	je     800336 <inet_ntoa+0x86>
  rp = str;
  8002fb:	b9 00 00 00 00       	mov    $0x0,%ecx
      rem = *ap % (u8_t)10;
  800300:	0f b6 17             	movzbl (%edi),%edx
      *ap /= (u8_t)10;
  800303:	0f b6 da             	movzbl %dl,%ebx
  800306:	8d 04 9b             	lea    (%ebx,%ebx,4),%eax
  800309:	8d 04 c3             	lea    (%ebx,%eax,8),%eax
  80030c:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80030f:	66 c1 e8 0b          	shr    $0xb,%ax
  800313:	88 07                	mov    %al,(%edi)
      inv[i++] = '0' + rem;
  800315:	8d 71 01             	lea    0x1(%ecx),%esi
  800318:	0f b6 c9             	movzbl %cl,%ecx
      rem = *ap % (u8_t)10;
  80031b:	8d 1c 80             	lea    (%eax,%eax,4),%ebx
  80031e:	01 db                	add    %ebx,%ebx
  800320:	29 da                	sub    %ebx,%edx
      inv[i++] = '0' + rem;
  800322:	83 c2 30             	add    $0x30,%edx
  800325:	88 54 0d ed          	mov    %dl,-0x13(%ebp,%ecx,1)
  800329:	89 f1                	mov    %esi,%ecx
    } while(*ap);
  80032b:	84 c0                	test   %al,%al
  80032d:	75 d1                	jne    800300 <inet_ntoa+0x50>
  80032f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      inv[i++] = '0' + rem;
  800332:	89 f2                	mov    %esi,%edx
  800334:	eb a2                	jmp    8002d8 <inet_ntoa+0x28>
    ap++;
  }
  *--rp = 0;
  800336:	c6 06 00             	movb   $0x0,(%esi)
  return str;
}
  800339:	b8 00 50 80 00       	mov    $0x805000,%eax
  80033e:	83 c4 14             	add    $0x14,%esp
  800341:	5b                   	pop    %ebx
  800342:	5e                   	pop    %esi
  800343:	5f                   	pop    %edi
  800344:	5d                   	pop    %ebp
  800345:	c3                   	ret    

00800346 <htons>:
 * @param n u16_t in host byte order
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  800346:	55                   	push   %ebp
  800347:	89 e5                	mov    %esp,%ebp
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  800349:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  80034d:	66 c1 c0 08          	rol    $0x8,%ax
}
  800351:	5d                   	pop    %ebp
  800352:	c3                   	ret    

00800353 <ntohs>:
 * @param n u16_t in network byte order
 * @return n in host byte order
 */
u16_t
ntohs(u16_t n)
{
  800353:	55                   	push   %ebp
  800354:	89 e5                	mov    %esp,%ebp
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  800356:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  80035a:	66 c1 c0 08          	rol    $0x8,%ax
  return htons(n);
}
  80035e:	5d                   	pop    %ebp
  80035f:	c3                   	ret    

00800360 <htonl>:
 * @param n u32_t in host byte order
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  800360:	55                   	push   %ebp
  800361:	89 e5                	mov    %esp,%ebp
  800363:	8b 55 08             	mov    0x8(%ebp),%edx
  return ((n & 0xff) << 24) |
  800366:	89 d0                	mov    %edx,%eax
  800368:	c1 e0 18             	shl    $0x18,%eax
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
  80036b:	89 d1                	mov    %edx,%ecx
  80036d:	c1 e9 18             	shr    $0x18,%ecx
    ((n & 0xff0000UL) >> 8) |
  800370:	09 c8                	or     %ecx,%eax
    ((n & 0xff00) << 8) |
  800372:	89 d1                	mov    %edx,%ecx
  800374:	c1 e1 08             	shl    $0x8,%ecx
  800377:	81 e1 00 00 ff 00    	and    $0xff0000,%ecx
    ((n & 0xff0000UL) >> 8) |
  80037d:	09 c8                	or     %ecx,%eax
  80037f:	c1 ea 08             	shr    $0x8,%edx
  800382:	81 e2 00 ff 00 00    	and    $0xff00,%edx
  800388:	09 d0                	or     %edx,%eax
}
  80038a:	5d                   	pop    %ebp
  80038b:	c3                   	ret    

0080038c <inet_aton>:
{
  80038c:	55                   	push   %ebp
  80038d:	89 e5                	mov    %esp,%ebp
  80038f:	57                   	push   %edi
  800390:	56                   	push   %esi
  800391:	53                   	push   %ebx
  800392:	83 ec 1c             	sub    $0x1c,%esp
  800395:	8b 45 08             	mov    0x8(%ebp),%eax
  c = *cp;
  800398:	0f be 10             	movsbl (%eax),%edx
  u32_t *pp = parts;
  80039b:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  80039e:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8003a1:	e9 a9 00 00 00       	jmp    80044f <inet_aton+0xc3>
      c = *++cp;
  8003a6:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      if (c == 'x' || c == 'X') {
  8003aa:	89 d1                	mov    %edx,%ecx
  8003ac:	83 e1 df             	and    $0xffffffdf,%ecx
  8003af:	80 f9 58             	cmp    $0x58,%cl
  8003b2:	74 12                	je     8003c6 <inet_aton+0x3a>
      c = *++cp;
  8003b4:	83 c0 01             	add    $0x1,%eax
  8003b7:	0f be d2             	movsbl %dl,%edx
        base = 8;
  8003ba:	c7 45 dc 08 00 00 00 	movl   $0x8,-0x24(%ebp)
  8003c1:	e9 a5 00 00 00       	jmp    80046b <inet_aton+0xdf>
        c = *++cp;
  8003c6:	0f be 50 02          	movsbl 0x2(%eax),%edx
  8003ca:	8d 40 02             	lea    0x2(%eax),%eax
        base = 16;
  8003cd:	c7 45 dc 10 00 00 00 	movl   $0x10,-0x24(%ebp)
  8003d4:	e9 92 00 00 00       	jmp    80046b <inet_aton+0xdf>
      } else if (base == 16 && isxdigit(c)) {
  8003d9:	83 7d dc 10          	cmpl   $0x10,-0x24(%ebp)
  8003dd:	75 4a                	jne    800429 <inet_aton+0x9d>
  8003df:	8d 5e 9f             	lea    -0x61(%esi),%ebx
  8003e2:	89 d1                	mov    %edx,%ecx
  8003e4:	83 e1 df             	and    $0xffffffdf,%ecx
  8003e7:	83 e9 41             	sub    $0x41,%ecx
  8003ea:	80 f9 05             	cmp    $0x5,%cl
  8003ed:	77 3a                	ja     800429 <inet_aton+0x9d>
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
  8003ef:	c1 e7 04             	shl    $0x4,%edi
  8003f2:	83 c2 0a             	add    $0xa,%edx
  8003f5:	80 fb 1a             	cmp    $0x1a,%bl
  8003f8:	19 c9                	sbb    %ecx,%ecx
  8003fa:	83 e1 20             	and    $0x20,%ecx
  8003fd:	83 c1 41             	add    $0x41,%ecx
  800400:	29 ca                	sub    %ecx,%edx
  800402:	09 d7                	or     %edx,%edi
        c = *++cp;
  800404:	8b 75 e0             	mov    -0x20(%ebp),%esi
  800407:	0f be 56 01          	movsbl 0x1(%esi),%edx
  80040b:	83 c0 01             	add    $0x1,%eax
  80040e:	89 45 e0             	mov    %eax,-0x20(%ebp)
      if (isdigit(c)) {
  800411:	89 d6                	mov    %edx,%esi
  800413:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800416:	80 f9 09             	cmp    $0x9,%cl
  800419:	77 be                	ja     8003d9 <inet_aton+0x4d>
        val = (val * base) + (int)(c - '0');
  80041b:	0f af 7d dc          	imul   -0x24(%ebp),%edi
  80041f:	8d 7c 3a d0          	lea    -0x30(%edx,%edi,1),%edi
        c = *++cp;
  800423:	0f be 50 01          	movsbl 0x1(%eax),%edx
  800427:	eb e2                	jmp    80040b <inet_aton+0x7f>
    if (c == '.') {
  800429:	83 fa 2e             	cmp    $0x2e,%edx
  80042c:	75 44                	jne    800472 <inet_aton+0xe6>
      if (pp >= parts + 3)
  80042e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800431:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800434:	39 c3                	cmp    %eax,%ebx
  800436:	0f 84 13 01 00 00    	je     80054f <inet_aton+0x1c3>
      *pp++ = val;
  80043c:	83 c3 04             	add    $0x4,%ebx
  80043f:	89 5d d8             	mov    %ebx,-0x28(%ebp)
  800442:	89 7b fc             	mov    %edi,-0x4(%ebx)
      c = *++cp;
  800445:	8b 75 e0             	mov    -0x20(%ebp),%esi
  800448:	8d 46 01             	lea    0x1(%esi),%eax
  80044b:	0f be 56 01          	movsbl 0x1(%esi),%edx
    if (!isdigit(c))
  80044f:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800452:	80 f9 09             	cmp    $0x9,%cl
  800455:	0f 87 ed 00 00 00    	ja     800548 <inet_aton+0x1bc>
    base = 10;
  80045b:	c7 45 dc 0a 00 00 00 	movl   $0xa,-0x24(%ebp)
    if (c == '0') {
  800462:	83 fa 30             	cmp    $0x30,%edx
  800465:	0f 84 3b ff ff ff    	je     8003a6 <inet_aton+0x1a>
        base = 8;
  80046b:	bf 00 00 00 00       	mov    $0x0,%edi
  800470:	eb 9c                	jmp    80040e <inet_aton+0x82>
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  800472:	85 d2                	test   %edx,%edx
  800474:	74 29                	je     80049f <inet_aton+0x113>
    return (0);
  800476:	b8 00 00 00 00       	mov    $0x0,%eax
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  80047b:	89 f3                	mov    %esi,%ebx
  80047d:	80 fb 1f             	cmp    $0x1f,%bl
  800480:	0f 86 ce 00 00 00    	jbe    800554 <inet_aton+0x1c8>
  800486:	84 d2                	test   %dl,%dl
  800488:	0f 88 c6 00 00 00    	js     800554 <inet_aton+0x1c8>
  80048e:	83 fa 20             	cmp    $0x20,%edx
  800491:	74 0c                	je     80049f <inet_aton+0x113>
  800493:	83 ea 09             	sub    $0x9,%edx
  800496:	83 fa 04             	cmp    $0x4,%edx
  800499:	0f 87 b5 00 00 00    	ja     800554 <inet_aton+0x1c8>
  n = pp - parts + 1;
  80049f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8004a2:	8b 75 d8             	mov    -0x28(%ebp),%esi
  8004a5:	29 c6                	sub    %eax,%esi
  8004a7:	89 f0                	mov    %esi,%eax
  8004a9:	c1 f8 02             	sar    $0x2,%eax
  8004ac:	83 c0 01             	add    $0x1,%eax
  switch (n) {
  8004af:	83 f8 02             	cmp    $0x2,%eax
  8004b2:	74 5e                	je     800512 <inet_aton+0x186>
  8004b4:	83 f8 02             	cmp    $0x2,%eax
  8004b7:	7e 35                	jle    8004ee <inet_aton+0x162>
  8004b9:	83 f8 03             	cmp    $0x3,%eax
  8004bc:	74 6b                	je     800529 <inet_aton+0x19d>
  8004be:	83 f8 04             	cmp    $0x4,%eax
  8004c1:	75 2f                	jne    8004f2 <inet_aton+0x166>
      return (0);
  8004c3:	b8 00 00 00 00       	mov    $0x0,%eax
    if (val > 0xff)
  8004c8:	81 ff ff 00 00 00    	cmp    $0xff,%edi
  8004ce:	0f 87 80 00 00 00    	ja     800554 <inet_aton+0x1c8>
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
  8004d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004d7:	c1 e0 18             	shl    $0x18,%eax
  8004da:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004dd:	c1 e2 10             	shl    $0x10,%edx
  8004e0:	09 d0                	or     %edx,%eax
  8004e2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8004e5:	c1 e2 08             	shl    $0x8,%edx
  8004e8:	09 d0                	or     %edx,%eax
  8004ea:	09 c7                	or     %eax,%edi
    break;
  8004ec:	eb 04                	jmp    8004f2 <inet_aton+0x166>
  switch (n) {
  8004ee:	85 c0                	test   %eax,%eax
  8004f0:	74 62                	je     800554 <inet_aton+0x1c8>
  return (1);
  8004f2:	b8 01 00 00 00       	mov    $0x1,%eax
  if (addr)
  8004f7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004fb:	74 57                	je     800554 <inet_aton+0x1c8>
    addr->s_addr = htonl(val);
  8004fd:	57                   	push   %edi
  8004fe:	e8 5d fe ff ff       	call   800360 <htonl>
  800503:	83 c4 04             	add    $0x4,%esp
  800506:	8b 75 0c             	mov    0xc(%ebp),%esi
  800509:	89 06                	mov    %eax,(%esi)
  return (1);
  80050b:	b8 01 00 00 00       	mov    $0x1,%eax
  800510:	eb 42                	jmp    800554 <inet_aton+0x1c8>
      return (0);
  800512:	b8 00 00 00 00       	mov    $0x0,%eax
    if (val > 0xffffffUL)
  800517:	81 ff ff ff ff 00    	cmp    $0xffffff,%edi
  80051d:	77 35                	ja     800554 <inet_aton+0x1c8>
    val |= parts[0] << 24;
  80051f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800522:	c1 e0 18             	shl    $0x18,%eax
  800525:	09 c7                	or     %eax,%edi
    break;
  800527:	eb c9                	jmp    8004f2 <inet_aton+0x166>
      return (0);
  800529:	b8 00 00 00 00       	mov    $0x0,%eax
    if (val > 0xffff)
  80052e:	81 ff ff ff 00 00    	cmp    $0xffff,%edi
  800534:	77 1e                	ja     800554 <inet_aton+0x1c8>
    val |= (parts[0] << 24) | (parts[1] << 16);
  800536:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800539:	c1 e0 18             	shl    $0x18,%eax
  80053c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80053f:	c1 e2 10             	shl    $0x10,%edx
  800542:	09 d0                	or     %edx,%eax
  800544:	09 c7                	or     %eax,%edi
    break;
  800546:	eb aa                	jmp    8004f2 <inet_aton+0x166>
      return (0);
  800548:	b8 00 00 00 00       	mov    $0x0,%eax
  80054d:	eb 05                	jmp    800554 <inet_aton+0x1c8>
        return (0);
  80054f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800554:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800557:	5b                   	pop    %ebx
  800558:	5e                   	pop    %esi
  800559:	5f                   	pop    %edi
  80055a:	5d                   	pop    %ebp
  80055b:	c3                   	ret    

0080055c <inet_addr>:
{
  80055c:	55                   	push   %ebp
  80055d:	89 e5                	mov    %esp,%ebp
  80055f:	83 ec 10             	sub    $0x10,%esp
  if (inet_aton(cp, &val)) {
  800562:	8d 45 fc             	lea    -0x4(%ebp),%eax
  800565:	50                   	push   %eax
  800566:	ff 75 08             	pushl  0x8(%ebp)
  800569:	e8 1e fe ff ff       	call   80038c <inet_aton>
  80056e:	83 c4 08             	add    $0x8,%esp
    return (val.s_addr);
  800571:	85 c0                	test   %eax,%eax
  800573:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800578:	0f 45 45 fc          	cmovne -0x4(%ebp),%eax
}
  80057c:	c9                   	leave  
  80057d:	c3                   	ret    

0080057e <ntohl>:
 * @param n u32_t in network byte order
 * @return n in host byte order
 */
u32_t
ntohl(u32_t n)
{
  80057e:	55                   	push   %ebp
  80057f:	89 e5                	mov    %esp,%ebp
  return htonl(n);
  800581:	ff 75 08             	pushl  0x8(%ebp)
  800584:	e8 d7 fd ff ff       	call   800360 <htonl>
  800589:	83 c4 04             	add    $0x4,%esp
}
  80058c:	c9                   	leave  
  80058d:	c3                   	ret    

0080058e <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80058e:	55                   	push   %ebp
  80058f:	89 e5                	mov    %esp,%ebp
  800591:	56                   	push   %esi
  800592:	53                   	push   %ebx
  800593:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800596:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
    thisenv = &envs[ENVX(sys_getenvid())];
  800599:	e8 83 0b 00 00       	call   801121 <sys_getenvid>
  80059e:	25 ff 03 00 00       	and    $0x3ff,%eax
  8005a3:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8005a6:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8005ab:	a3 1c 50 80 00       	mov    %eax,0x80501c

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8005b0:	85 db                	test   %ebx,%ebx
  8005b2:	7e 07                	jle    8005bb <libmain+0x2d>
		binaryname = argv[0];
  8005b4:	8b 06                	mov    (%esi),%eax
  8005b6:	a3 20 40 80 00       	mov    %eax,0x804020

	// call user main routine
	umain(argc, argv);
  8005bb:	83 ec 08             	sub    $0x8,%esp
  8005be:	56                   	push   %esi
  8005bf:	53                   	push   %ebx
  8005c0:	e8 02 fc ff ff       	call   8001c7 <umain>

	// exit gracefully
	exit();
  8005c5:	e8 0a 00 00 00       	call   8005d4 <exit>
}
  8005ca:	83 c4 10             	add    $0x10,%esp
  8005cd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8005d0:	5b                   	pop    %ebx
  8005d1:	5e                   	pop    %esi
  8005d2:	5d                   	pop    %ebp
  8005d3:	c3                   	ret    

008005d4 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8005d4:	55                   	push   %ebp
  8005d5:	89 e5                	mov    %esp,%ebp
  8005d7:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8005da:	e8 66 0f 00 00       	call   801545 <close_all>
	sys_env_destroy(0);
  8005df:	83 ec 0c             	sub    $0xc,%esp
  8005e2:	6a 00                	push   $0x0
  8005e4:	e8 f7 0a 00 00       	call   8010e0 <sys_env_destroy>
}
  8005e9:	83 c4 10             	add    $0x10,%esp
  8005ec:	c9                   	leave  
  8005ed:	c3                   	ret    

008005ee <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8005ee:	55                   	push   %ebp
  8005ef:	89 e5                	mov    %esp,%ebp
  8005f1:	56                   	push   %esi
  8005f2:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8005f3:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8005f6:	8b 35 20 40 80 00    	mov    0x804020,%esi
  8005fc:	e8 20 0b 00 00       	call   801121 <sys_getenvid>
  800601:	83 ec 0c             	sub    $0xc,%esp
  800604:	ff 75 0c             	pushl  0xc(%ebp)
  800607:	ff 75 08             	pushl  0x8(%ebp)
  80060a:	56                   	push   %esi
  80060b:	50                   	push   %eax
  80060c:	68 90 2c 80 00       	push   $0x802c90
  800611:	e8 b3 00 00 00       	call   8006c9 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800616:	83 c4 18             	add    $0x18,%esp
  800619:	53                   	push   %ebx
  80061a:	ff 75 10             	pushl  0x10(%ebp)
  80061d:	e8 56 00 00 00       	call   800678 <vcprintf>
	cprintf("\n");
  800622:	c7 04 24 f4 30 80 00 	movl   $0x8030f4,(%esp)
  800629:	e8 9b 00 00 00       	call   8006c9 <cprintf>
  80062e:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800631:	cc                   	int3   
  800632:	eb fd                	jmp    800631 <_panic+0x43>

00800634 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800634:	55                   	push   %ebp
  800635:	89 e5                	mov    %esp,%ebp
  800637:	53                   	push   %ebx
  800638:	83 ec 04             	sub    $0x4,%esp
  80063b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80063e:	8b 13                	mov    (%ebx),%edx
  800640:	8d 42 01             	lea    0x1(%edx),%eax
  800643:	89 03                	mov    %eax,(%ebx)
  800645:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800648:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80064c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800651:	74 09                	je     80065c <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800653:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800657:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80065a:	c9                   	leave  
  80065b:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80065c:	83 ec 08             	sub    $0x8,%esp
  80065f:	68 ff 00 00 00       	push   $0xff
  800664:	8d 43 08             	lea    0x8(%ebx),%eax
  800667:	50                   	push   %eax
  800668:	e8 36 0a 00 00       	call   8010a3 <sys_cputs>
		b->idx = 0;
  80066d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800673:	83 c4 10             	add    $0x10,%esp
  800676:	eb db                	jmp    800653 <putch+0x1f>

00800678 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800678:	55                   	push   %ebp
  800679:	89 e5                	mov    %esp,%ebp
  80067b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800681:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800688:	00 00 00 
	b.cnt = 0;
  80068b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800692:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800695:	ff 75 0c             	pushl  0xc(%ebp)
  800698:	ff 75 08             	pushl  0x8(%ebp)
  80069b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006a1:	50                   	push   %eax
  8006a2:	68 34 06 80 00       	push   $0x800634
  8006a7:	e8 1a 01 00 00       	call   8007c6 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8006ac:	83 c4 08             	add    $0x8,%esp
  8006af:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8006b5:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8006bb:	50                   	push   %eax
  8006bc:	e8 e2 09 00 00       	call   8010a3 <sys_cputs>

	return b.cnt;
}
  8006c1:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8006c7:	c9                   	leave  
  8006c8:	c3                   	ret    

008006c9 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8006c9:	55                   	push   %ebp
  8006ca:	89 e5                	mov    %esp,%ebp
  8006cc:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8006cf:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8006d2:	50                   	push   %eax
  8006d3:	ff 75 08             	pushl  0x8(%ebp)
  8006d6:	e8 9d ff ff ff       	call   800678 <vcprintf>
	va_end(ap);

	return cnt;
}
  8006db:	c9                   	leave  
  8006dc:	c3                   	ret    

008006dd <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8006dd:	55                   	push   %ebp
  8006de:	89 e5                	mov    %esp,%ebp
  8006e0:	57                   	push   %edi
  8006e1:	56                   	push   %esi
  8006e2:	53                   	push   %ebx
  8006e3:	83 ec 1c             	sub    $0x1c,%esp
  8006e6:	89 c7                	mov    %eax,%edi
  8006e8:	89 d6                	mov    %edx,%esi
  8006ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006f0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006f3:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8006f6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8006f9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006fe:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800701:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800704:	39 d3                	cmp    %edx,%ebx
  800706:	72 05                	jb     80070d <printnum+0x30>
  800708:	39 45 10             	cmp    %eax,0x10(%ebp)
  80070b:	77 7a                	ja     800787 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80070d:	83 ec 0c             	sub    $0xc,%esp
  800710:	ff 75 18             	pushl  0x18(%ebp)
  800713:	8b 45 14             	mov    0x14(%ebp),%eax
  800716:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800719:	53                   	push   %ebx
  80071a:	ff 75 10             	pushl  0x10(%ebp)
  80071d:	83 ec 08             	sub    $0x8,%esp
  800720:	ff 75 e4             	pushl  -0x1c(%ebp)
  800723:	ff 75 e0             	pushl  -0x20(%ebp)
  800726:	ff 75 dc             	pushl  -0x24(%ebp)
  800729:	ff 75 d8             	pushl  -0x28(%ebp)
  80072c:	e8 5f 21 00 00       	call   802890 <__udivdi3>
  800731:	83 c4 18             	add    $0x18,%esp
  800734:	52                   	push   %edx
  800735:	50                   	push   %eax
  800736:	89 f2                	mov    %esi,%edx
  800738:	89 f8                	mov    %edi,%eax
  80073a:	e8 9e ff ff ff       	call   8006dd <printnum>
  80073f:	83 c4 20             	add    $0x20,%esp
  800742:	eb 13                	jmp    800757 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800744:	83 ec 08             	sub    $0x8,%esp
  800747:	56                   	push   %esi
  800748:	ff 75 18             	pushl  0x18(%ebp)
  80074b:	ff d7                	call   *%edi
  80074d:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800750:	83 eb 01             	sub    $0x1,%ebx
  800753:	85 db                	test   %ebx,%ebx
  800755:	7f ed                	jg     800744 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800757:	83 ec 08             	sub    $0x8,%esp
  80075a:	56                   	push   %esi
  80075b:	83 ec 04             	sub    $0x4,%esp
  80075e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800761:	ff 75 e0             	pushl  -0x20(%ebp)
  800764:	ff 75 dc             	pushl  -0x24(%ebp)
  800767:	ff 75 d8             	pushl  -0x28(%ebp)
  80076a:	e8 41 22 00 00       	call   8029b0 <__umoddi3>
  80076f:	83 c4 14             	add    $0x14,%esp
  800772:	0f be 80 b3 2c 80 00 	movsbl 0x802cb3(%eax),%eax
  800779:	50                   	push   %eax
  80077a:	ff d7                	call   *%edi
}
  80077c:	83 c4 10             	add    $0x10,%esp
  80077f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800782:	5b                   	pop    %ebx
  800783:	5e                   	pop    %esi
  800784:	5f                   	pop    %edi
  800785:	5d                   	pop    %ebp
  800786:	c3                   	ret    
  800787:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80078a:	eb c4                	jmp    800750 <printnum+0x73>

0080078c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80078c:	55                   	push   %ebp
  80078d:	89 e5                	mov    %esp,%ebp
  80078f:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800792:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800796:	8b 10                	mov    (%eax),%edx
  800798:	3b 50 04             	cmp    0x4(%eax),%edx
  80079b:	73 0a                	jae    8007a7 <sprintputch+0x1b>
		*b->buf++ = ch;
  80079d:	8d 4a 01             	lea    0x1(%edx),%ecx
  8007a0:	89 08                	mov    %ecx,(%eax)
  8007a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a5:	88 02                	mov    %al,(%edx)
}
  8007a7:	5d                   	pop    %ebp
  8007a8:	c3                   	ret    

008007a9 <printfmt>:
{
  8007a9:	55                   	push   %ebp
  8007aa:	89 e5                	mov    %esp,%ebp
  8007ac:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8007af:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8007b2:	50                   	push   %eax
  8007b3:	ff 75 10             	pushl  0x10(%ebp)
  8007b6:	ff 75 0c             	pushl  0xc(%ebp)
  8007b9:	ff 75 08             	pushl  0x8(%ebp)
  8007bc:	e8 05 00 00 00       	call   8007c6 <vprintfmt>
}
  8007c1:	83 c4 10             	add    $0x10,%esp
  8007c4:	c9                   	leave  
  8007c5:	c3                   	ret    

008007c6 <vprintfmt>:
{
  8007c6:	55                   	push   %ebp
  8007c7:	89 e5                	mov    %esp,%ebp
  8007c9:	57                   	push   %edi
  8007ca:	56                   	push   %esi
  8007cb:	53                   	push   %ebx
  8007cc:	83 ec 2c             	sub    $0x2c,%esp
  8007cf:	8b 75 08             	mov    0x8(%ebp),%esi
  8007d2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8007d5:	8b 7d 10             	mov    0x10(%ebp),%edi
  8007d8:	e9 21 04 00 00       	jmp    800bfe <vprintfmt+0x438>
		padc = ' ';
  8007dd:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8007e1:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8007e8:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  8007ef:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8007f6:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8007fb:	8d 47 01             	lea    0x1(%edi),%eax
  8007fe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800801:	0f b6 17             	movzbl (%edi),%edx
  800804:	8d 42 dd             	lea    -0x23(%edx),%eax
  800807:	3c 55                	cmp    $0x55,%al
  800809:	0f 87 90 04 00 00    	ja     800c9f <vprintfmt+0x4d9>
  80080f:	0f b6 c0             	movzbl %al,%eax
  800812:	ff 24 85 00 2e 80 00 	jmp    *0x802e00(,%eax,4)
  800819:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80081c:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800820:	eb d9                	jmp    8007fb <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800822:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800825:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800829:	eb d0                	jmp    8007fb <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80082b:	0f b6 d2             	movzbl %dl,%edx
  80082e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800831:	b8 00 00 00 00       	mov    $0x0,%eax
  800836:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800839:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80083c:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800840:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800843:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800846:	83 f9 09             	cmp    $0x9,%ecx
  800849:	77 55                	ja     8008a0 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  80084b:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80084e:	eb e9                	jmp    800839 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  800850:	8b 45 14             	mov    0x14(%ebp),%eax
  800853:	8b 00                	mov    (%eax),%eax
  800855:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800858:	8b 45 14             	mov    0x14(%ebp),%eax
  80085b:	8d 40 04             	lea    0x4(%eax),%eax
  80085e:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800861:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800864:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800868:	79 91                	jns    8007fb <vprintfmt+0x35>
				width = precision, precision = -1;
  80086a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80086d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800870:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800877:	eb 82                	jmp    8007fb <vprintfmt+0x35>
  800879:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80087c:	85 c0                	test   %eax,%eax
  80087e:	ba 00 00 00 00       	mov    $0x0,%edx
  800883:	0f 49 d0             	cmovns %eax,%edx
  800886:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800889:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80088c:	e9 6a ff ff ff       	jmp    8007fb <vprintfmt+0x35>
  800891:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800894:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  80089b:	e9 5b ff ff ff       	jmp    8007fb <vprintfmt+0x35>
  8008a0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8008a3:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8008a6:	eb bc                	jmp    800864 <vprintfmt+0x9e>
			lflag++;
  8008a8:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8008ab:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8008ae:	e9 48 ff ff ff       	jmp    8007fb <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8008b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b6:	8d 78 04             	lea    0x4(%eax),%edi
  8008b9:	83 ec 08             	sub    $0x8,%esp
  8008bc:	53                   	push   %ebx
  8008bd:	ff 30                	pushl  (%eax)
  8008bf:	ff d6                	call   *%esi
			break;
  8008c1:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8008c4:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8008c7:	e9 2f 03 00 00       	jmp    800bfb <vprintfmt+0x435>
			err = va_arg(ap, int);
  8008cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8008cf:	8d 78 04             	lea    0x4(%eax),%edi
  8008d2:	8b 00                	mov    (%eax),%eax
  8008d4:	99                   	cltd   
  8008d5:	31 d0                	xor    %edx,%eax
  8008d7:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8008d9:	83 f8 0f             	cmp    $0xf,%eax
  8008dc:	7f 23                	jg     800901 <vprintfmt+0x13b>
  8008de:	8b 14 85 60 2f 80 00 	mov    0x802f60(,%eax,4),%edx
  8008e5:	85 d2                	test   %edx,%edx
  8008e7:	74 18                	je     800901 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  8008e9:	52                   	push   %edx
  8008ea:	68 bb 30 80 00       	push   $0x8030bb
  8008ef:	53                   	push   %ebx
  8008f0:	56                   	push   %esi
  8008f1:	e8 b3 fe ff ff       	call   8007a9 <printfmt>
  8008f6:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8008f9:	89 7d 14             	mov    %edi,0x14(%ebp)
  8008fc:	e9 fa 02 00 00       	jmp    800bfb <vprintfmt+0x435>
				printfmt(putch, putdat, "error %d", err);
  800901:	50                   	push   %eax
  800902:	68 cb 2c 80 00       	push   $0x802ccb
  800907:	53                   	push   %ebx
  800908:	56                   	push   %esi
  800909:	e8 9b fe ff ff       	call   8007a9 <printfmt>
  80090e:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800911:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800914:	e9 e2 02 00 00       	jmp    800bfb <vprintfmt+0x435>
			if ((p = va_arg(ap, char *)) == NULL)
  800919:	8b 45 14             	mov    0x14(%ebp),%eax
  80091c:	83 c0 04             	add    $0x4,%eax
  80091f:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800922:	8b 45 14             	mov    0x14(%ebp),%eax
  800925:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800927:	85 ff                	test   %edi,%edi
  800929:	b8 c4 2c 80 00       	mov    $0x802cc4,%eax
  80092e:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800931:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800935:	0f 8e bd 00 00 00    	jle    8009f8 <vprintfmt+0x232>
  80093b:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80093f:	75 0e                	jne    80094f <vprintfmt+0x189>
  800941:	89 75 08             	mov    %esi,0x8(%ebp)
  800944:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800947:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80094a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80094d:	eb 6d                	jmp    8009bc <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  80094f:	83 ec 08             	sub    $0x8,%esp
  800952:	ff 75 d0             	pushl  -0x30(%ebp)
  800955:	57                   	push   %edi
  800956:	e8 ec 03 00 00       	call   800d47 <strnlen>
  80095b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80095e:	29 c1                	sub    %eax,%ecx
  800960:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800963:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800966:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  80096a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80096d:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800970:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800972:	eb 0f                	jmp    800983 <vprintfmt+0x1bd>
					putch(padc, putdat);
  800974:	83 ec 08             	sub    $0x8,%esp
  800977:	53                   	push   %ebx
  800978:	ff 75 e0             	pushl  -0x20(%ebp)
  80097b:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80097d:	83 ef 01             	sub    $0x1,%edi
  800980:	83 c4 10             	add    $0x10,%esp
  800983:	85 ff                	test   %edi,%edi
  800985:	7f ed                	jg     800974 <vprintfmt+0x1ae>
  800987:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  80098a:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  80098d:	85 c9                	test   %ecx,%ecx
  80098f:	b8 00 00 00 00       	mov    $0x0,%eax
  800994:	0f 49 c1             	cmovns %ecx,%eax
  800997:	29 c1                	sub    %eax,%ecx
  800999:	89 75 08             	mov    %esi,0x8(%ebp)
  80099c:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80099f:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8009a2:	89 cb                	mov    %ecx,%ebx
  8009a4:	eb 16                	jmp    8009bc <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8009a6:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8009aa:	75 31                	jne    8009dd <vprintfmt+0x217>
					putch(ch, putdat);
  8009ac:	83 ec 08             	sub    $0x8,%esp
  8009af:	ff 75 0c             	pushl  0xc(%ebp)
  8009b2:	50                   	push   %eax
  8009b3:	ff 55 08             	call   *0x8(%ebp)
  8009b6:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009b9:	83 eb 01             	sub    $0x1,%ebx
  8009bc:	83 c7 01             	add    $0x1,%edi
  8009bf:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8009c3:	0f be c2             	movsbl %dl,%eax
  8009c6:	85 c0                	test   %eax,%eax
  8009c8:	74 59                	je     800a23 <vprintfmt+0x25d>
  8009ca:	85 f6                	test   %esi,%esi
  8009cc:	78 d8                	js     8009a6 <vprintfmt+0x1e0>
  8009ce:	83 ee 01             	sub    $0x1,%esi
  8009d1:	79 d3                	jns    8009a6 <vprintfmt+0x1e0>
  8009d3:	89 df                	mov    %ebx,%edi
  8009d5:	8b 75 08             	mov    0x8(%ebp),%esi
  8009d8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8009db:	eb 37                	jmp    800a14 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  8009dd:	0f be d2             	movsbl %dl,%edx
  8009e0:	83 ea 20             	sub    $0x20,%edx
  8009e3:	83 fa 5e             	cmp    $0x5e,%edx
  8009e6:	76 c4                	jbe    8009ac <vprintfmt+0x1e6>
					putch('?', putdat);
  8009e8:	83 ec 08             	sub    $0x8,%esp
  8009eb:	ff 75 0c             	pushl  0xc(%ebp)
  8009ee:	6a 3f                	push   $0x3f
  8009f0:	ff 55 08             	call   *0x8(%ebp)
  8009f3:	83 c4 10             	add    $0x10,%esp
  8009f6:	eb c1                	jmp    8009b9 <vprintfmt+0x1f3>
  8009f8:	89 75 08             	mov    %esi,0x8(%ebp)
  8009fb:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8009fe:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800a01:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800a04:	eb b6                	jmp    8009bc <vprintfmt+0x1f6>
				putch(' ', putdat);
  800a06:	83 ec 08             	sub    $0x8,%esp
  800a09:	53                   	push   %ebx
  800a0a:	6a 20                	push   $0x20
  800a0c:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800a0e:	83 ef 01             	sub    $0x1,%edi
  800a11:	83 c4 10             	add    $0x10,%esp
  800a14:	85 ff                	test   %edi,%edi
  800a16:	7f ee                	jg     800a06 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  800a18:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800a1b:	89 45 14             	mov    %eax,0x14(%ebp)
  800a1e:	e9 d8 01 00 00       	jmp    800bfb <vprintfmt+0x435>
  800a23:	89 df                	mov    %ebx,%edi
  800a25:	8b 75 08             	mov    0x8(%ebp),%esi
  800a28:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800a2b:	eb e7                	jmp    800a14 <vprintfmt+0x24e>
	if (lflag >= 2)
  800a2d:	83 f9 01             	cmp    $0x1,%ecx
  800a30:	7e 45                	jle    800a77 <vprintfmt+0x2b1>
		return va_arg(*ap, long long);
  800a32:	8b 45 14             	mov    0x14(%ebp),%eax
  800a35:	8b 50 04             	mov    0x4(%eax),%edx
  800a38:	8b 00                	mov    (%eax),%eax
  800a3a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a3d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a40:	8b 45 14             	mov    0x14(%ebp),%eax
  800a43:	8d 40 08             	lea    0x8(%eax),%eax
  800a46:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800a49:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a4d:	79 62                	jns    800ab1 <vprintfmt+0x2eb>
				putch('-', putdat);
  800a4f:	83 ec 08             	sub    $0x8,%esp
  800a52:	53                   	push   %ebx
  800a53:	6a 2d                	push   $0x2d
  800a55:	ff d6                	call   *%esi
				num = -(long long) num;
  800a57:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a5a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800a5d:	f7 d8                	neg    %eax
  800a5f:	83 d2 00             	adc    $0x0,%edx
  800a62:	f7 da                	neg    %edx
  800a64:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a67:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a6a:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800a6d:	ba 0a 00 00 00       	mov    $0xa,%edx
  800a72:	e9 66 01 00 00       	jmp    800bdd <vprintfmt+0x417>
	else if (lflag)
  800a77:	85 c9                	test   %ecx,%ecx
  800a79:	75 1b                	jne    800a96 <vprintfmt+0x2d0>
		return va_arg(*ap, int);
  800a7b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a7e:	8b 00                	mov    (%eax),%eax
  800a80:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a83:	89 c1                	mov    %eax,%ecx
  800a85:	c1 f9 1f             	sar    $0x1f,%ecx
  800a88:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800a8b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a8e:	8d 40 04             	lea    0x4(%eax),%eax
  800a91:	89 45 14             	mov    %eax,0x14(%ebp)
  800a94:	eb b3                	jmp    800a49 <vprintfmt+0x283>
		return va_arg(*ap, long);
  800a96:	8b 45 14             	mov    0x14(%ebp),%eax
  800a99:	8b 00                	mov    (%eax),%eax
  800a9b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a9e:	89 c1                	mov    %eax,%ecx
  800aa0:	c1 f9 1f             	sar    $0x1f,%ecx
  800aa3:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800aa6:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa9:	8d 40 04             	lea    0x4(%eax),%eax
  800aac:	89 45 14             	mov    %eax,0x14(%ebp)
  800aaf:	eb 98                	jmp    800a49 <vprintfmt+0x283>
			base = 10;
  800ab1:	ba 0a 00 00 00       	mov    $0xa,%edx
  800ab6:	e9 22 01 00 00       	jmp    800bdd <vprintfmt+0x417>
	if (lflag >= 2)
  800abb:	83 f9 01             	cmp    $0x1,%ecx
  800abe:	7e 21                	jle    800ae1 <vprintfmt+0x31b>
		return va_arg(*ap, unsigned long long);
  800ac0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac3:	8b 50 04             	mov    0x4(%eax),%edx
  800ac6:	8b 00                	mov    (%eax),%eax
  800ac8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800acb:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800ace:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad1:	8d 40 08             	lea    0x8(%eax),%eax
  800ad4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800ad7:	ba 0a 00 00 00       	mov    $0xa,%edx
  800adc:	e9 fc 00 00 00       	jmp    800bdd <vprintfmt+0x417>
	else if (lflag)
  800ae1:	85 c9                	test   %ecx,%ecx
  800ae3:	75 23                	jne    800b08 <vprintfmt+0x342>
		return va_arg(*ap, unsigned int);
  800ae5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae8:	8b 00                	mov    (%eax),%eax
  800aea:	ba 00 00 00 00       	mov    $0x0,%edx
  800aef:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800af2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800af5:	8b 45 14             	mov    0x14(%ebp),%eax
  800af8:	8d 40 04             	lea    0x4(%eax),%eax
  800afb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800afe:	ba 0a 00 00 00       	mov    $0xa,%edx
  800b03:	e9 d5 00 00 00       	jmp    800bdd <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  800b08:	8b 45 14             	mov    0x14(%ebp),%eax
  800b0b:	8b 00                	mov    (%eax),%eax
  800b0d:	ba 00 00 00 00       	mov    $0x0,%edx
  800b12:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b15:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b18:	8b 45 14             	mov    0x14(%ebp),%eax
  800b1b:	8d 40 04             	lea    0x4(%eax),%eax
  800b1e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800b21:	ba 0a 00 00 00       	mov    $0xa,%edx
  800b26:	e9 b2 00 00 00       	jmp    800bdd <vprintfmt+0x417>
	if (lflag >= 2)
  800b2b:	83 f9 01             	cmp    $0x1,%ecx
  800b2e:	7e 42                	jle    800b72 <vprintfmt+0x3ac>
		return va_arg(*ap, unsigned long long);
  800b30:	8b 45 14             	mov    0x14(%ebp),%eax
  800b33:	8b 50 04             	mov    0x4(%eax),%edx
  800b36:	8b 00                	mov    (%eax),%eax
  800b38:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b3b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b3e:	8b 45 14             	mov    0x14(%ebp),%eax
  800b41:	8d 40 08             	lea    0x8(%eax),%eax
  800b44:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800b47:	ba 08 00 00 00       	mov    $0x8,%edx
			if ((long long) num < 0) {
  800b4c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b50:	0f 89 87 00 00 00    	jns    800bdd <vprintfmt+0x417>
				putch('-', putdat);
  800b56:	83 ec 08             	sub    $0x8,%esp
  800b59:	53                   	push   %ebx
  800b5a:	6a 2d                	push   $0x2d
  800b5c:	ff d6                	call   *%esi
				num = -(long long) num;
  800b5e:	f7 5d d8             	negl   -0x28(%ebp)
  800b61:	83 55 dc 00          	adcl   $0x0,-0x24(%ebp)
  800b65:	f7 5d dc             	negl   -0x24(%ebp)
  800b68:	83 c4 10             	add    $0x10,%esp
			base = 8;
  800b6b:	ba 08 00 00 00       	mov    $0x8,%edx
  800b70:	eb 6b                	jmp    800bdd <vprintfmt+0x417>
	else if (lflag)
  800b72:	85 c9                	test   %ecx,%ecx
  800b74:	75 1b                	jne    800b91 <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  800b76:	8b 45 14             	mov    0x14(%ebp),%eax
  800b79:	8b 00                	mov    (%eax),%eax
  800b7b:	ba 00 00 00 00       	mov    $0x0,%edx
  800b80:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b83:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b86:	8b 45 14             	mov    0x14(%ebp),%eax
  800b89:	8d 40 04             	lea    0x4(%eax),%eax
  800b8c:	89 45 14             	mov    %eax,0x14(%ebp)
  800b8f:	eb b6                	jmp    800b47 <vprintfmt+0x381>
		return va_arg(*ap, unsigned long);
  800b91:	8b 45 14             	mov    0x14(%ebp),%eax
  800b94:	8b 00                	mov    (%eax),%eax
  800b96:	ba 00 00 00 00       	mov    $0x0,%edx
  800b9b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b9e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800ba1:	8b 45 14             	mov    0x14(%ebp),%eax
  800ba4:	8d 40 04             	lea    0x4(%eax),%eax
  800ba7:	89 45 14             	mov    %eax,0x14(%ebp)
  800baa:	eb 9b                	jmp    800b47 <vprintfmt+0x381>
			putch('0', putdat);
  800bac:	83 ec 08             	sub    $0x8,%esp
  800baf:	53                   	push   %ebx
  800bb0:	6a 30                	push   $0x30
  800bb2:	ff d6                	call   *%esi
			putch('x', putdat);
  800bb4:	83 c4 08             	add    $0x8,%esp
  800bb7:	53                   	push   %ebx
  800bb8:	6a 78                	push   $0x78
  800bba:	ff d6                	call   *%esi
			num = (unsigned long long)
  800bbc:	8b 45 14             	mov    0x14(%ebp),%eax
  800bbf:	8b 00                	mov    (%eax),%eax
  800bc1:	ba 00 00 00 00       	mov    $0x0,%edx
  800bc6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800bc9:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800bcc:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800bcf:	8b 45 14             	mov    0x14(%ebp),%eax
  800bd2:	8d 40 04             	lea    0x4(%eax),%eax
  800bd5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800bd8:	ba 10 00 00 00       	mov    $0x10,%edx
			printnum(putch, putdat, num, base, width, padc);
  800bdd:	83 ec 0c             	sub    $0xc,%esp
  800be0:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800be4:	50                   	push   %eax
  800be5:	ff 75 e0             	pushl  -0x20(%ebp)
  800be8:	52                   	push   %edx
  800be9:	ff 75 dc             	pushl  -0x24(%ebp)
  800bec:	ff 75 d8             	pushl  -0x28(%ebp)
  800bef:	89 da                	mov    %ebx,%edx
  800bf1:	89 f0                	mov    %esi,%eax
  800bf3:	e8 e5 fa ff ff       	call   8006dd <printnum>
			break;
  800bf8:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800bfb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bfe:	83 c7 01             	add    $0x1,%edi
  800c01:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800c05:	83 f8 25             	cmp    $0x25,%eax
  800c08:	0f 84 cf fb ff ff    	je     8007dd <vprintfmt+0x17>
			if (ch == '\0')
  800c0e:	85 c0                	test   %eax,%eax
  800c10:	0f 84 a9 00 00 00    	je     800cbf <vprintfmt+0x4f9>
			putch(ch, putdat);
  800c16:	83 ec 08             	sub    $0x8,%esp
  800c19:	53                   	push   %ebx
  800c1a:	50                   	push   %eax
  800c1b:	ff d6                	call   *%esi
  800c1d:	83 c4 10             	add    $0x10,%esp
  800c20:	eb dc                	jmp    800bfe <vprintfmt+0x438>
	if (lflag >= 2)
  800c22:	83 f9 01             	cmp    $0x1,%ecx
  800c25:	7e 1e                	jle    800c45 <vprintfmt+0x47f>
		return va_arg(*ap, unsigned long long);
  800c27:	8b 45 14             	mov    0x14(%ebp),%eax
  800c2a:	8b 50 04             	mov    0x4(%eax),%edx
  800c2d:	8b 00                	mov    (%eax),%eax
  800c2f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c32:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800c35:	8b 45 14             	mov    0x14(%ebp),%eax
  800c38:	8d 40 08             	lea    0x8(%eax),%eax
  800c3b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800c3e:	ba 10 00 00 00       	mov    $0x10,%edx
  800c43:	eb 98                	jmp    800bdd <vprintfmt+0x417>
	else if (lflag)
  800c45:	85 c9                	test   %ecx,%ecx
  800c47:	75 23                	jne    800c6c <vprintfmt+0x4a6>
		return va_arg(*ap, unsigned int);
  800c49:	8b 45 14             	mov    0x14(%ebp),%eax
  800c4c:	8b 00                	mov    (%eax),%eax
  800c4e:	ba 00 00 00 00       	mov    $0x0,%edx
  800c53:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c56:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800c59:	8b 45 14             	mov    0x14(%ebp),%eax
  800c5c:	8d 40 04             	lea    0x4(%eax),%eax
  800c5f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800c62:	ba 10 00 00 00       	mov    $0x10,%edx
  800c67:	e9 71 ff ff ff       	jmp    800bdd <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  800c6c:	8b 45 14             	mov    0x14(%ebp),%eax
  800c6f:	8b 00                	mov    (%eax),%eax
  800c71:	ba 00 00 00 00       	mov    $0x0,%edx
  800c76:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c79:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800c7c:	8b 45 14             	mov    0x14(%ebp),%eax
  800c7f:	8d 40 04             	lea    0x4(%eax),%eax
  800c82:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800c85:	ba 10 00 00 00       	mov    $0x10,%edx
  800c8a:	e9 4e ff ff ff       	jmp    800bdd <vprintfmt+0x417>
			putch(ch, putdat);
  800c8f:	83 ec 08             	sub    $0x8,%esp
  800c92:	53                   	push   %ebx
  800c93:	6a 25                	push   $0x25
  800c95:	ff d6                	call   *%esi
			break;
  800c97:	83 c4 10             	add    $0x10,%esp
  800c9a:	e9 5c ff ff ff       	jmp    800bfb <vprintfmt+0x435>
			putch('%', putdat);
  800c9f:	83 ec 08             	sub    $0x8,%esp
  800ca2:	53                   	push   %ebx
  800ca3:	6a 25                	push   $0x25
  800ca5:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ca7:	83 c4 10             	add    $0x10,%esp
  800caa:	89 f8                	mov    %edi,%eax
  800cac:	eb 03                	jmp    800cb1 <vprintfmt+0x4eb>
  800cae:	83 e8 01             	sub    $0x1,%eax
  800cb1:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800cb5:	75 f7                	jne    800cae <vprintfmt+0x4e8>
  800cb7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800cba:	e9 3c ff ff ff       	jmp    800bfb <vprintfmt+0x435>
}
  800cbf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cc2:	5b                   	pop    %ebx
  800cc3:	5e                   	pop    %esi
  800cc4:	5f                   	pop    %edi
  800cc5:	5d                   	pop    %ebp
  800cc6:	c3                   	ret    

00800cc7 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800cc7:	55                   	push   %ebp
  800cc8:	89 e5                	mov    %esp,%ebp
  800cca:	83 ec 18             	sub    $0x18,%esp
  800ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd0:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800cd3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800cd6:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800cda:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800cdd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ce4:	85 c0                	test   %eax,%eax
  800ce6:	74 26                	je     800d0e <vsnprintf+0x47>
  800ce8:	85 d2                	test   %edx,%edx
  800cea:	7e 22                	jle    800d0e <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800cec:	ff 75 14             	pushl  0x14(%ebp)
  800cef:	ff 75 10             	pushl  0x10(%ebp)
  800cf2:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800cf5:	50                   	push   %eax
  800cf6:	68 8c 07 80 00       	push   $0x80078c
  800cfb:	e8 c6 fa ff ff       	call   8007c6 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800d00:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d03:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d09:	83 c4 10             	add    $0x10,%esp
}
  800d0c:	c9                   	leave  
  800d0d:	c3                   	ret    
		return -E_INVAL;
  800d0e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d13:	eb f7                	jmp    800d0c <vsnprintf+0x45>

00800d15 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d15:	55                   	push   %ebp
  800d16:	89 e5                	mov    %esp,%ebp
  800d18:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d1b:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800d1e:	50                   	push   %eax
  800d1f:	ff 75 10             	pushl  0x10(%ebp)
  800d22:	ff 75 0c             	pushl  0xc(%ebp)
  800d25:	ff 75 08             	pushl  0x8(%ebp)
  800d28:	e8 9a ff ff ff       	call   800cc7 <vsnprintf>
	va_end(ap);

	return rc;
}
  800d2d:	c9                   	leave  
  800d2e:	c3                   	ret    

00800d2f <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800d2f:	55                   	push   %ebp
  800d30:	89 e5                	mov    %esp,%ebp
  800d32:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800d35:	b8 00 00 00 00       	mov    $0x0,%eax
  800d3a:	eb 03                	jmp    800d3f <strlen+0x10>
		n++;
  800d3c:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800d3f:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800d43:	75 f7                	jne    800d3c <strlen+0xd>
	return n;
}
  800d45:	5d                   	pop    %ebp
  800d46:	c3                   	ret    

00800d47 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800d47:	55                   	push   %ebp
  800d48:	89 e5                	mov    %esp,%ebp
  800d4a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d4d:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d50:	b8 00 00 00 00       	mov    $0x0,%eax
  800d55:	eb 03                	jmp    800d5a <strnlen+0x13>
		n++;
  800d57:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d5a:	39 d0                	cmp    %edx,%eax
  800d5c:	74 06                	je     800d64 <strnlen+0x1d>
  800d5e:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800d62:	75 f3                	jne    800d57 <strnlen+0x10>
	return n;
}
  800d64:	5d                   	pop    %ebp
  800d65:	c3                   	ret    

00800d66 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d66:	55                   	push   %ebp
  800d67:	89 e5                	mov    %esp,%ebp
  800d69:	53                   	push   %ebx
  800d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800d70:	89 c2                	mov    %eax,%edx
  800d72:	83 c1 01             	add    $0x1,%ecx
  800d75:	83 c2 01             	add    $0x1,%edx
  800d78:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800d7c:	88 5a ff             	mov    %bl,-0x1(%edx)
  800d7f:	84 db                	test   %bl,%bl
  800d81:	75 ef                	jne    800d72 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800d83:	5b                   	pop    %ebx
  800d84:	5d                   	pop    %ebp
  800d85:	c3                   	ret    

00800d86 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800d86:	55                   	push   %ebp
  800d87:	89 e5                	mov    %esp,%ebp
  800d89:	53                   	push   %ebx
  800d8a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800d8d:	53                   	push   %ebx
  800d8e:	e8 9c ff ff ff       	call   800d2f <strlen>
  800d93:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800d96:	ff 75 0c             	pushl  0xc(%ebp)
  800d99:	01 d8                	add    %ebx,%eax
  800d9b:	50                   	push   %eax
  800d9c:	e8 c5 ff ff ff       	call   800d66 <strcpy>
	return dst;
}
  800da1:	89 d8                	mov    %ebx,%eax
  800da3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800da6:	c9                   	leave  
  800da7:	c3                   	ret    

00800da8 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800da8:	55                   	push   %ebp
  800da9:	89 e5                	mov    %esp,%ebp
  800dab:	56                   	push   %esi
  800dac:	53                   	push   %ebx
  800dad:	8b 75 08             	mov    0x8(%ebp),%esi
  800db0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800db3:	89 f3                	mov    %esi,%ebx
  800db5:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800db8:	89 f2                	mov    %esi,%edx
  800dba:	eb 0f                	jmp    800dcb <strncpy+0x23>
		*dst++ = *src;
  800dbc:	83 c2 01             	add    $0x1,%edx
  800dbf:	0f b6 01             	movzbl (%ecx),%eax
  800dc2:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800dc5:	80 39 01             	cmpb   $0x1,(%ecx)
  800dc8:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800dcb:	39 da                	cmp    %ebx,%edx
  800dcd:	75 ed                	jne    800dbc <strncpy+0x14>
	}
	return ret;
}
  800dcf:	89 f0                	mov    %esi,%eax
  800dd1:	5b                   	pop    %ebx
  800dd2:	5e                   	pop    %esi
  800dd3:	5d                   	pop    %ebp
  800dd4:	c3                   	ret    

00800dd5 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800dd5:	55                   	push   %ebp
  800dd6:	89 e5                	mov    %esp,%ebp
  800dd8:	56                   	push   %esi
  800dd9:	53                   	push   %ebx
  800dda:	8b 75 08             	mov    0x8(%ebp),%esi
  800ddd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800de0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800de3:	89 f0                	mov    %esi,%eax
  800de5:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800de9:	85 c9                	test   %ecx,%ecx
  800deb:	75 0b                	jne    800df8 <strlcpy+0x23>
  800ded:	eb 17                	jmp    800e06 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800def:	83 c2 01             	add    $0x1,%edx
  800df2:	83 c0 01             	add    $0x1,%eax
  800df5:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800df8:	39 d8                	cmp    %ebx,%eax
  800dfa:	74 07                	je     800e03 <strlcpy+0x2e>
  800dfc:	0f b6 0a             	movzbl (%edx),%ecx
  800dff:	84 c9                	test   %cl,%cl
  800e01:	75 ec                	jne    800def <strlcpy+0x1a>
		*dst = '\0';
  800e03:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e06:	29 f0                	sub    %esi,%eax
}
  800e08:	5b                   	pop    %ebx
  800e09:	5e                   	pop    %esi
  800e0a:	5d                   	pop    %ebp
  800e0b:	c3                   	ret    

00800e0c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e0c:	55                   	push   %ebp
  800e0d:	89 e5                	mov    %esp,%ebp
  800e0f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e12:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800e15:	eb 06                	jmp    800e1d <strcmp+0x11>
		p++, q++;
  800e17:	83 c1 01             	add    $0x1,%ecx
  800e1a:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800e1d:	0f b6 01             	movzbl (%ecx),%eax
  800e20:	84 c0                	test   %al,%al
  800e22:	74 04                	je     800e28 <strcmp+0x1c>
  800e24:	3a 02                	cmp    (%edx),%al
  800e26:	74 ef                	je     800e17 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e28:	0f b6 c0             	movzbl %al,%eax
  800e2b:	0f b6 12             	movzbl (%edx),%edx
  800e2e:	29 d0                	sub    %edx,%eax
}
  800e30:	5d                   	pop    %ebp
  800e31:	c3                   	ret    

00800e32 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800e32:	55                   	push   %ebp
  800e33:	89 e5                	mov    %esp,%ebp
  800e35:	53                   	push   %ebx
  800e36:	8b 45 08             	mov    0x8(%ebp),%eax
  800e39:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e3c:	89 c3                	mov    %eax,%ebx
  800e3e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800e41:	eb 06                	jmp    800e49 <strncmp+0x17>
		n--, p++, q++;
  800e43:	83 c0 01             	add    $0x1,%eax
  800e46:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800e49:	39 d8                	cmp    %ebx,%eax
  800e4b:	74 16                	je     800e63 <strncmp+0x31>
  800e4d:	0f b6 08             	movzbl (%eax),%ecx
  800e50:	84 c9                	test   %cl,%cl
  800e52:	74 04                	je     800e58 <strncmp+0x26>
  800e54:	3a 0a                	cmp    (%edx),%cl
  800e56:	74 eb                	je     800e43 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e58:	0f b6 00             	movzbl (%eax),%eax
  800e5b:	0f b6 12             	movzbl (%edx),%edx
  800e5e:	29 d0                	sub    %edx,%eax
}
  800e60:	5b                   	pop    %ebx
  800e61:	5d                   	pop    %ebp
  800e62:	c3                   	ret    
		return 0;
  800e63:	b8 00 00 00 00       	mov    $0x0,%eax
  800e68:	eb f6                	jmp    800e60 <strncmp+0x2e>

00800e6a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e6a:	55                   	push   %ebp
  800e6b:	89 e5                	mov    %esp,%ebp
  800e6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e70:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800e74:	0f b6 10             	movzbl (%eax),%edx
  800e77:	84 d2                	test   %dl,%dl
  800e79:	74 09                	je     800e84 <strchr+0x1a>
		if (*s == c)
  800e7b:	38 ca                	cmp    %cl,%dl
  800e7d:	74 0a                	je     800e89 <strchr+0x1f>
	for (; *s; s++)
  800e7f:	83 c0 01             	add    $0x1,%eax
  800e82:	eb f0                	jmp    800e74 <strchr+0xa>
			return (char *) s;
	return 0;
  800e84:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e89:	5d                   	pop    %ebp
  800e8a:	c3                   	ret    

00800e8b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e8b:	55                   	push   %ebp
  800e8c:	89 e5                	mov    %esp,%ebp
  800e8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e91:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800e95:	eb 03                	jmp    800e9a <strfind+0xf>
  800e97:	83 c0 01             	add    $0x1,%eax
  800e9a:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800e9d:	38 ca                	cmp    %cl,%dl
  800e9f:	74 04                	je     800ea5 <strfind+0x1a>
  800ea1:	84 d2                	test   %dl,%dl
  800ea3:	75 f2                	jne    800e97 <strfind+0xc>
			break;
	return (char *) s;
}
  800ea5:	5d                   	pop    %ebp
  800ea6:	c3                   	ret    

00800ea7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800ea7:	55                   	push   %ebp
  800ea8:	89 e5                	mov    %esp,%ebp
  800eaa:	57                   	push   %edi
  800eab:	56                   	push   %esi
  800eac:	53                   	push   %ebx
  800ead:	8b 7d 08             	mov    0x8(%ebp),%edi
  800eb0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800eb3:	85 c9                	test   %ecx,%ecx
  800eb5:	74 13                	je     800eca <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800eb7:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800ebd:	75 05                	jne    800ec4 <memset+0x1d>
  800ebf:	f6 c1 03             	test   $0x3,%cl
  800ec2:	74 0d                	je     800ed1 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800ec4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec7:	fc                   	cld    
  800ec8:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800eca:	89 f8                	mov    %edi,%eax
  800ecc:	5b                   	pop    %ebx
  800ecd:	5e                   	pop    %esi
  800ece:	5f                   	pop    %edi
  800ecf:	5d                   	pop    %ebp
  800ed0:	c3                   	ret    
		c &= 0xFF;
  800ed1:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ed5:	89 d3                	mov    %edx,%ebx
  800ed7:	c1 e3 08             	shl    $0x8,%ebx
  800eda:	89 d0                	mov    %edx,%eax
  800edc:	c1 e0 18             	shl    $0x18,%eax
  800edf:	89 d6                	mov    %edx,%esi
  800ee1:	c1 e6 10             	shl    $0x10,%esi
  800ee4:	09 f0                	or     %esi,%eax
  800ee6:	09 c2                	or     %eax,%edx
  800ee8:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800eea:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800eed:	89 d0                	mov    %edx,%eax
  800eef:	fc                   	cld    
  800ef0:	f3 ab                	rep stos %eax,%es:(%edi)
  800ef2:	eb d6                	jmp    800eca <memset+0x23>

00800ef4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800ef4:	55                   	push   %ebp
  800ef5:	89 e5                	mov    %esp,%ebp
  800ef7:	57                   	push   %edi
  800ef8:	56                   	push   %esi
  800ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  800efc:	8b 75 0c             	mov    0xc(%ebp),%esi
  800eff:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f02:	39 c6                	cmp    %eax,%esi
  800f04:	73 35                	jae    800f3b <memmove+0x47>
  800f06:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800f09:	39 c2                	cmp    %eax,%edx
  800f0b:	76 2e                	jbe    800f3b <memmove+0x47>
		s += n;
		d += n;
  800f0d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800f10:	89 d6                	mov    %edx,%esi
  800f12:	09 fe                	or     %edi,%esi
  800f14:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800f1a:	74 0c                	je     800f28 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800f1c:	83 ef 01             	sub    $0x1,%edi
  800f1f:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800f22:	fd                   	std    
  800f23:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800f25:	fc                   	cld    
  800f26:	eb 21                	jmp    800f49 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800f28:	f6 c1 03             	test   $0x3,%cl
  800f2b:	75 ef                	jne    800f1c <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800f2d:	83 ef 04             	sub    $0x4,%edi
  800f30:	8d 72 fc             	lea    -0x4(%edx),%esi
  800f33:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800f36:	fd                   	std    
  800f37:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800f39:	eb ea                	jmp    800f25 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800f3b:	89 f2                	mov    %esi,%edx
  800f3d:	09 c2                	or     %eax,%edx
  800f3f:	f6 c2 03             	test   $0x3,%dl
  800f42:	74 09                	je     800f4d <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800f44:	89 c7                	mov    %eax,%edi
  800f46:	fc                   	cld    
  800f47:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800f49:	5e                   	pop    %esi
  800f4a:	5f                   	pop    %edi
  800f4b:	5d                   	pop    %ebp
  800f4c:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800f4d:	f6 c1 03             	test   $0x3,%cl
  800f50:	75 f2                	jne    800f44 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800f52:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800f55:	89 c7                	mov    %eax,%edi
  800f57:	fc                   	cld    
  800f58:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800f5a:	eb ed                	jmp    800f49 <memmove+0x55>

00800f5c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800f5c:	55                   	push   %ebp
  800f5d:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800f5f:	ff 75 10             	pushl  0x10(%ebp)
  800f62:	ff 75 0c             	pushl  0xc(%ebp)
  800f65:	ff 75 08             	pushl  0x8(%ebp)
  800f68:	e8 87 ff ff ff       	call   800ef4 <memmove>
}
  800f6d:	c9                   	leave  
  800f6e:	c3                   	ret    

00800f6f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800f6f:	55                   	push   %ebp
  800f70:	89 e5                	mov    %esp,%ebp
  800f72:	56                   	push   %esi
  800f73:	53                   	push   %ebx
  800f74:	8b 45 08             	mov    0x8(%ebp),%eax
  800f77:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f7a:	89 c6                	mov    %eax,%esi
  800f7c:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800f7f:	39 f0                	cmp    %esi,%eax
  800f81:	74 1c                	je     800f9f <memcmp+0x30>
		if (*s1 != *s2)
  800f83:	0f b6 08             	movzbl (%eax),%ecx
  800f86:	0f b6 1a             	movzbl (%edx),%ebx
  800f89:	38 d9                	cmp    %bl,%cl
  800f8b:	75 08                	jne    800f95 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800f8d:	83 c0 01             	add    $0x1,%eax
  800f90:	83 c2 01             	add    $0x1,%edx
  800f93:	eb ea                	jmp    800f7f <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800f95:	0f b6 c1             	movzbl %cl,%eax
  800f98:	0f b6 db             	movzbl %bl,%ebx
  800f9b:	29 d8                	sub    %ebx,%eax
  800f9d:	eb 05                	jmp    800fa4 <memcmp+0x35>
	}

	return 0;
  800f9f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fa4:	5b                   	pop    %ebx
  800fa5:	5e                   	pop    %esi
  800fa6:	5d                   	pop    %ebp
  800fa7:	c3                   	ret    

00800fa8 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800fa8:	55                   	push   %ebp
  800fa9:	89 e5                	mov    %esp,%ebp
  800fab:	8b 45 08             	mov    0x8(%ebp),%eax
  800fae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800fb1:	89 c2                	mov    %eax,%edx
  800fb3:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800fb6:	39 d0                	cmp    %edx,%eax
  800fb8:	73 09                	jae    800fc3 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800fba:	38 08                	cmp    %cl,(%eax)
  800fbc:	74 05                	je     800fc3 <memfind+0x1b>
	for (; s < ends; s++)
  800fbe:	83 c0 01             	add    $0x1,%eax
  800fc1:	eb f3                	jmp    800fb6 <memfind+0xe>
			break;
	return (void *) s;
}
  800fc3:	5d                   	pop    %ebp
  800fc4:	c3                   	ret    

00800fc5 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800fc5:	55                   	push   %ebp
  800fc6:	89 e5                	mov    %esp,%ebp
  800fc8:	57                   	push   %edi
  800fc9:	56                   	push   %esi
  800fca:	53                   	push   %ebx
  800fcb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fce:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fd1:	eb 03                	jmp    800fd6 <strtol+0x11>
		s++;
  800fd3:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800fd6:	0f b6 01             	movzbl (%ecx),%eax
  800fd9:	3c 20                	cmp    $0x20,%al
  800fdb:	74 f6                	je     800fd3 <strtol+0xe>
  800fdd:	3c 09                	cmp    $0x9,%al
  800fdf:	74 f2                	je     800fd3 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800fe1:	3c 2b                	cmp    $0x2b,%al
  800fe3:	74 2e                	je     801013 <strtol+0x4e>
	int neg = 0;
  800fe5:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800fea:	3c 2d                	cmp    $0x2d,%al
  800fec:	74 2f                	je     80101d <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800fee:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800ff4:	75 05                	jne    800ffb <strtol+0x36>
  800ff6:	80 39 30             	cmpb   $0x30,(%ecx)
  800ff9:	74 2c                	je     801027 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800ffb:	85 db                	test   %ebx,%ebx
  800ffd:	75 0a                	jne    801009 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800fff:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  801004:	80 39 30             	cmpb   $0x30,(%ecx)
  801007:	74 28                	je     801031 <strtol+0x6c>
		base = 10;
  801009:	b8 00 00 00 00       	mov    $0x0,%eax
  80100e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801011:	eb 50                	jmp    801063 <strtol+0x9e>
		s++;
  801013:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  801016:	bf 00 00 00 00       	mov    $0x0,%edi
  80101b:	eb d1                	jmp    800fee <strtol+0x29>
		s++, neg = 1;
  80101d:	83 c1 01             	add    $0x1,%ecx
  801020:	bf 01 00 00 00       	mov    $0x1,%edi
  801025:	eb c7                	jmp    800fee <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801027:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  80102b:	74 0e                	je     80103b <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  80102d:	85 db                	test   %ebx,%ebx
  80102f:	75 d8                	jne    801009 <strtol+0x44>
		s++, base = 8;
  801031:	83 c1 01             	add    $0x1,%ecx
  801034:	bb 08 00 00 00       	mov    $0x8,%ebx
  801039:	eb ce                	jmp    801009 <strtol+0x44>
		s += 2, base = 16;
  80103b:	83 c1 02             	add    $0x2,%ecx
  80103e:	bb 10 00 00 00       	mov    $0x10,%ebx
  801043:	eb c4                	jmp    801009 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  801045:	8d 72 9f             	lea    -0x61(%edx),%esi
  801048:	89 f3                	mov    %esi,%ebx
  80104a:	80 fb 19             	cmp    $0x19,%bl
  80104d:	77 29                	ja     801078 <strtol+0xb3>
			dig = *s - 'a' + 10;
  80104f:	0f be d2             	movsbl %dl,%edx
  801052:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801055:	3b 55 10             	cmp    0x10(%ebp),%edx
  801058:	7d 30                	jge    80108a <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  80105a:	83 c1 01             	add    $0x1,%ecx
  80105d:	0f af 45 10          	imul   0x10(%ebp),%eax
  801061:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801063:	0f b6 11             	movzbl (%ecx),%edx
  801066:	8d 72 d0             	lea    -0x30(%edx),%esi
  801069:	89 f3                	mov    %esi,%ebx
  80106b:	80 fb 09             	cmp    $0x9,%bl
  80106e:	77 d5                	ja     801045 <strtol+0x80>
			dig = *s - '0';
  801070:	0f be d2             	movsbl %dl,%edx
  801073:	83 ea 30             	sub    $0x30,%edx
  801076:	eb dd                	jmp    801055 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  801078:	8d 72 bf             	lea    -0x41(%edx),%esi
  80107b:	89 f3                	mov    %esi,%ebx
  80107d:	80 fb 19             	cmp    $0x19,%bl
  801080:	77 08                	ja     80108a <strtol+0xc5>
			dig = *s - 'A' + 10;
  801082:	0f be d2             	movsbl %dl,%edx
  801085:	83 ea 37             	sub    $0x37,%edx
  801088:	eb cb                	jmp    801055 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  80108a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80108e:	74 05                	je     801095 <strtol+0xd0>
		*endptr = (char *) s;
  801090:	8b 75 0c             	mov    0xc(%ebp),%esi
  801093:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801095:	89 c2                	mov    %eax,%edx
  801097:	f7 da                	neg    %edx
  801099:	85 ff                	test   %edi,%edi
  80109b:	0f 45 c2             	cmovne %edx,%eax
}
  80109e:	5b                   	pop    %ebx
  80109f:	5e                   	pop    %esi
  8010a0:	5f                   	pop    %edi
  8010a1:	5d                   	pop    %ebp
  8010a2:	c3                   	ret    

008010a3 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8010a3:	55                   	push   %ebp
  8010a4:	89 e5                	mov    %esp,%ebp
  8010a6:	57                   	push   %edi
  8010a7:	56                   	push   %esi
  8010a8:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8010ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8010b1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010b4:	89 c3                	mov    %eax,%ebx
  8010b6:	89 c7                	mov    %eax,%edi
  8010b8:	89 c6                	mov    %eax,%esi
  8010ba:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8010bc:	5b                   	pop    %ebx
  8010bd:	5e                   	pop    %esi
  8010be:	5f                   	pop    %edi
  8010bf:	5d                   	pop    %ebp
  8010c0:	c3                   	ret    

008010c1 <sys_cgetc>:

int
sys_cgetc(void)
{
  8010c1:	55                   	push   %ebp
  8010c2:	89 e5                	mov    %esp,%ebp
  8010c4:	57                   	push   %edi
  8010c5:	56                   	push   %esi
  8010c6:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8010cc:	b8 01 00 00 00       	mov    $0x1,%eax
  8010d1:	89 d1                	mov    %edx,%ecx
  8010d3:	89 d3                	mov    %edx,%ebx
  8010d5:	89 d7                	mov    %edx,%edi
  8010d7:	89 d6                	mov    %edx,%esi
  8010d9:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8010db:	5b                   	pop    %ebx
  8010dc:	5e                   	pop    %esi
  8010dd:	5f                   	pop    %edi
  8010de:	5d                   	pop    %ebp
  8010df:	c3                   	ret    

008010e0 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8010e0:	55                   	push   %ebp
  8010e1:	89 e5                	mov    %esp,%ebp
  8010e3:	57                   	push   %edi
  8010e4:	56                   	push   %esi
  8010e5:	53                   	push   %ebx
  8010e6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010e9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8010f1:	b8 03 00 00 00       	mov    $0x3,%eax
  8010f6:	89 cb                	mov    %ecx,%ebx
  8010f8:	89 cf                	mov    %ecx,%edi
  8010fa:	89 ce                	mov    %ecx,%esi
  8010fc:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010fe:	85 c0                	test   %eax,%eax
  801100:	7f 08                	jg     80110a <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801102:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801105:	5b                   	pop    %ebx
  801106:	5e                   	pop    %esi
  801107:	5f                   	pop    %edi
  801108:	5d                   	pop    %ebp
  801109:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80110a:	83 ec 0c             	sub    $0xc,%esp
  80110d:	50                   	push   %eax
  80110e:	6a 03                	push   $0x3
  801110:	68 bf 2f 80 00       	push   $0x802fbf
  801115:	6a 23                	push   $0x23
  801117:	68 dc 2f 80 00       	push   $0x802fdc
  80111c:	e8 cd f4 ff ff       	call   8005ee <_panic>

00801121 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801121:	55                   	push   %ebp
  801122:	89 e5                	mov    %esp,%ebp
  801124:	57                   	push   %edi
  801125:	56                   	push   %esi
  801126:	53                   	push   %ebx
	asm volatile("int %1\n"
  801127:	ba 00 00 00 00       	mov    $0x0,%edx
  80112c:	b8 02 00 00 00       	mov    $0x2,%eax
  801131:	89 d1                	mov    %edx,%ecx
  801133:	89 d3                	mov    %edx,%ebx
  801135:	89 d7                	mov    %edx,%edi
  801137:	89 d6                	mov    %edx,%esi
  801139:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80113b:	5b                   	pop    %ebx
  80113c:	5e                   	pop    %esi
  80113d:	5f                   	pop    %edi
  80113e:	5d                   	pop    %ebp
  80113f:	c3                   	ret    

00801140 <sys_yield>:

void
sys_yield(void)
{
  801140:	55                   	push   %ebp
  801141:	89 e5                	mov    %esp,%ebp
  801143:	57                   	push   %edi
  801144:	56                   	push   %esi
  801145:	53                   	push   %ebx
	asm volatile("int %1\n"
  801146:	ba 00 00 00 00       	mov    $0x0,%edx
  80114b:	b8 0b 00 00 00       	mov    $0xb,%eax
  801150:	89 d1                	mov    %edx,%ecx
  801152:	89 d3                	mov    %edx,%ebx
  801154:	89 d7                	mov    %edx,%edi
  801156:	89 d6                	mov    %edx,%esi
  801158:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80115a:	5b                   	pop    %ebx
  80115b:	5e                   	pop    %esi
  80115c:	5f                   	pop    %edi
  80115d:	5d                   	pop    %ebp
  80115e:	c3                   	ret    

0080115f <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80115f:	55                   	push   %ebp
  801160:	89 e5                	mov    %esp,%ebp
  801162:	57                   	push   %edi
  801163:	56                   	push   %esi
  801164:	53                   	push   %ebx
  801165:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801168:	be 00 00 00 00       	mov    $0x0,%esi
  80116d:	8b 55 08             	mov    0x8(%ebp),%edx
  801170:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801173:	b8 04 00 00 00       	mov    $0x4,%eax
  801178:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80117b:	89 f7                	mov    %esi,%edi
  80117d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80117f:	85 c0                	test   %eax,%eax
  801181:	7f 08                	jg     80118b <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801183:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801186:	5b                   	pop    %ebx
  801187:	5e                   	pop    %esi
  801188:	5f                   	pop    %edi
  801189:	5d                   	pop    %ebp
  80118a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80118b:	83 ec 0c             	sub    $0xc,%esp
  80118e:	50                   	push   %eax
  80118f:	6a 04                	push   $0x4
  801191:	68 bf 2f 80 00       	push   $0x802fbf
  801196:	6a 23                	push   $0x23
  801198:	68 dc 2f 80 00       	push   $0x802fdc
  80119d:	e8 4c f4 ff ff       	call   8005ee <_panic>

008011a2 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8011a2:	55                   	push   %ebp
  8011a3:	89 e5                	mov    %esp,%ebp
  8011a5:	57                   	push   %edi
  8011a6:	56                   	push   %esi
  8011a7:	53                   	push   %ebx
  8011a8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011ab:	8b 55 08             	mov    0x8(%ebp),%edx
  8011ae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011b1:	b8 05 00 00 00       	mov    $0x5,%eax
  8011b6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8011b9:	8b 7d 14             	mov    0x14(%ebp),%edi
  8011bc:	8b 75 18             	mov    0x18(%ebp),%esi
  8011bf:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011c1:	85 c0                	test   %eax,%eax
  8011c3:	7f 08                	jg     8011cd <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8011c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011c8:	5b                   	pop    %ebx
  8011c9:	5e                   	pop    %esi
  8011ca:	5f                   	pop    %edi
  8011cb:	5d                   	pop    %ebp
  8011cc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011cd:	83 ec 0c             	sub    $0xc,%esp
  8011d0:	50                   	push   %eax
  8011d1:	6a 05                	push   $0x5
  8011d3:	68 bf 2f 80 00       	push   $0x802fbf
  8011d8:	6a 23                	push   $0x23
  8011da:	68 dc 2f 80 00       	push   $0x802fdc
  8011df:	e8 0a f4 ff ff       	call   8005ee <_panic>

008011e4 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8011e4:	55                   	push   %ebp
  8011e5:	89 e5                	mov    %esp,%ebp
  8011e7:	57                   	push   %edi
  8011e8:	56                   	push   %esi
  8011e9:	53                   	push   %ebx
  8011ea:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011ed:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8011f5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011f8:	b8 06 00 00 00       	mov    $0x6,%eax
  8011fd:	89 df                	mov    %ebx,%edi
  8011ff:	89 de                	mov    %ebx,%esi
  801201:	cd 30                	int    $0x30
	if(check && ret > 0)
  801203:	85 c0                	test   %eax,%eax
  801205:	7f 08                	jg     80120f <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801207:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80120a:	5b                   	pop    %ebx
  80120b:	5e                   	pop    %esi
  80120c:	5f                   	pop    %edi
  80120d:	5d                   	pop    %ebp
  80120e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80120f:	83 ec 0c             	sub    $0xc,%esp
  801212:	50                   	push   %eax
  801213:	6a 06                	push   $0x6
  801215:	68 bf 2f 80 00       	push   $0x802fbf
  80121a:	6a 23                	push   $0x23
  80121c:	68 dc 2f 80 00       	push   $0x802fdc
  801221:	e8 c8 f3 ff ff       	call   8005ee <_panic>

00801226 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801226:	55                   	push   %ebp
  801227:	89 e5                	mov    %esp,%ebp
  801229:	57                   	push   %edi
  80122a:	56                   	push   %esi
  80122b:	53                   	push   %ebx
  80122c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80122f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801234:	8b 55 08             	mov    0x8(%ebp),%edx
  801237:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80123a:	b8 08 00 00 00       	mov    $0x8,%eax
  80123f:	89 df                	mov    %ebx,%edi
  801241:	89 de                	mov    %ebx,%esi
  801243:	cd 30                	int    $0x30
	if(check && ret > 0)
  801245:	85 c0                	test   %eax,%eax
  801247:	7f 08                	jg     801251 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801249:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80124c:	5b                   	pop    %ebx
  80124d:	5e                   	pop    %esi
  80124e:	5f                   	pop    %edi
  80124f:	5d                   	pop    %ebp
  801250:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801251:	83 ec 0c             	sub    $0xc,%esp
  801254:	50                   	push   %eax
  801255:	6a 08                	push   $0x8
  801257:	68 bf 2f 80 00       	push   $0x802fbf
  80125c:	6a 23                	push   $0x23
  80125e:	68 dc 2f 80 00       	push   $0x802fdc
  801263:	e8 86 f3 ff ff       	call   8005ee <_panic>

00801268 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801268:	55                   	push   %ebp
  801269:	89 e5                	mov    %esp,%ebp
  80126b:	57                   	push   %edi
  80126c:	56                   	push   %esi
  80126d:	53                   	push   %ebx
  80126e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801271:	bb 00 00 00 00       	mov    $0x0,%ebx
  801276:	8b 55 08             	mov    0x8(%ebp),%edx
  801279:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80127c:	b8 09 00 00 00       	mov    $0x9,%eax
  801281:	89 df                	mov    %ebx,%edi
  801283:	89 de                	mov    %ebx,%esi
  801285:	cd 30                	int    $0x30
	if(check && ret > 0)
  801287:	85 c0                	test   %eax,%eax
  801289:	7f 08                	jg     801293 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80128b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80128e:	5b                   	pop    %ebx
  80128f:	5e                   	pop    %esi
  801290:	5f                   	pop    %edi
  801291:	5d                   	pop    %ebp
  801292:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801293:	83 ec 0c             	sub    $0xc,%esp
  801296:	50                   	push   %eax
  801297:	6a 09                	push   $0x9
  801299:	68 bf 2f 80 00       	push   $0x802fbf
  80129e:	6a 23                	push   $0x23
  8012a0:	68 dc 2f 80 00       	push   $0x802fdc
  8012a5:	e8 44 f3 ff ff       	call   8005ee <_panic>

008012aa <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8012aa:	55                   	push   %ebp
  8012ab:	89 e5                	mov    %esp,%ebp
  8012ad:	57                   	push   %edi
  8012ae:	56                   	push   %esi
  8012af:	53                   	push   %ebx
  8012b0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8012b3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8012bb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012be:	b8 0a 00 00 00       	mov    $0xa,%eax
  8012c3:	89 df                	mov    %ebx,%edi
  8012c5:	89 de                	mov    %ebx,%esi
  8012c7:	cd 30                	int    $0x30
	if(check && ret > 0)
  8012c9:	85 c0                	test   %eax,%eax
  8012cb:	7f 08                	jg     8012d5 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8012cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012d0:	5b                   	pop    %ebx
  8012d1:	5e                   	pop    %esi
  8012d2:	5f                   	pop    %edi
  8012d3:	5d                   	pop    %ebp
  8012d4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8012d5:	83 ec 0c             	sub    $0xc,%esp
  8012d8:	50                   	push   %eax
  8012d9:	6a 0a                	push   $0xa
  8012db:	68 bf 2f 80 00       	push   $0x802fbf
  8012e0:	6a 23                	push   $0x23
  8012e2:	68 dc 2f 80 00       	push   $0x802fdc
  8012e7:	e8 02 f3 ff ff       	call   8005ee <_panic>

008012ec <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8012ec:	55                   	push   %ebp
  8012ed:	89 e5                	mov    %esp,%ebp
  8012ef:	57                   	push   %edi
  8012f0:	56                   	push   %esi
  8012f1:	53                   	push   %ebx
	asm volatile("int %1\n"
  8012f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8012f5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012f8:	b8 0c 00 00 00       	mov    $0xc,%eax
  8012fd:	be 00 00 00 00       	mov    $0x0,%esi
  801302:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801305:	8b 7d 14             	mov    0x14(%ebp),%edi
  801308:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80130a:	5b                   	pop    %ebx
  80130b:	5e                   	pop    %esi
  80130c:	5f                   	pop    %edi
  80130d:	5d                   	pop    %ebp
  80130e:	c3                   	ret    

0080130f <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80130f:	55                   	push   %ebp
  801310:	89 e5                	mov    %esp,%ebp
  801312:	57                   	push   %edi
  801313:	56                   	push   %esi
  801314:	53                   	push   %ebx
  801315:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801318:	b9 00 00 00 00       	mov    $0x0,%ecx
  80131d:	8b 55 08             	mov    0x8(%ebp),%edx
  801320:	b8 0d 00 00 00       	mov    $0xd,%eax
  801325:	89 cb                	mov    %ecx,%ebx
  801327:	89 cf                	mov    %ecx,%edi
  801329:	89 ce                	mov    %ecx,%esi
  80132b:	cd 30                	int    $0x30
	if(check && ret > 0)
  80132d:	85 c0                	test   %eax,%eax
  80132f:	7f 08                	jg     801339 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801331:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801334:	5b                   	pop    %ebx
  801335:	5e                   	pop    %esi
  801336:	5f                   	pop    %edi
  801337:	5d                   	pop    %ebp
  801338:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801339:	83 ec 0c             	sub    $0xc,%esp
  80133c:	50                   	push   %eax
  80133d:	6a 0d                	push   $0xd
  80133f:	68 bf 2f 80 00       	push   $0x802fbf
  801344:	6a 23                	push   $0x23
  801346:	68 dc 2f 80 00       	push   $0x802fdc
  80134b:	e8 9e f2 ff ff       	call   8005ee <_panic>

00801350 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801350:	55                   	push   %ebp
  801351:	89 e5                	mov    %esp,%ebp
  801353:	57                   	push   %edi
  801354:	56                   	push   %esi
  801355:	53                   	push   %ebx
	asm volatile("int %1\n"
  801356:	ba 00 00 00 00       	mov    $0x0,%edx
  80135b:	b8 0e 00 00 00       	mov    $0xe,%eax
  801360:	89 d1                	mov    %edx,%ecx
  801362:	89 d3                	mov    %edx,%ebx
  801364:	89 d7                	mov    %edx,%edi
  801366:	89 d6                	mov    %edx,%esi
  801368:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  80136a:	5b                   	pop    %ebx
  80136b:	5e                   	pop    %esi
  80136c:	5f                   	pop    %edi
  80136d:	5d                   	pop    %ebp
  80136e:	c3                   	ret    

0080136f <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80136f:	55                   	push   %ebp
  801370:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801372:	8b 45 08             	mov    0x8(%ebp),%eax
  801375:	05 00 00 00 30       	add    $0x30000000,%eax
  80137a:	c1 e8 0c             	shr    $0xc,%eax
}
  80137d:	5d                   	pop    %ebp
  80137e:	c3                   	ret    

0080137f <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80137f:	55                   	push   %ebp
  801380:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801382:	8b 45 08             	mov    0x8(%ebp),%eax
  801385:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80138a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80138f:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801394:	5d                   	pop    %ebp
  801395:	c3                   	ret    

00801396 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801396:	55                   	push   %ebp
  801397:	89 e5                	mov    %esp,%ebp
  801399:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80139c:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8013a1:	89 c2                	mov    %eax,%edx
  8013a3:	c1 ea 16             	shr    $0x16,%edx
  8013a6:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8013ad:	f6 c2 01             	test   $0x1,%dl
  8013b0:	74 2a                	je     8013dc <fd_alloc+0x46>
  8013b2:	89 c2                	mov    %eax,%edx
  8013b4:	c1 ea 0c             	shr    $0xc,%edx
  8013b7:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013be:	f6 c2 01             	test   $0x1,%dl
  8013c1:	74 19                	je     8013dc <fd_alloc+0x46>
  8013c3:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8013c8:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8013cd:	75 d2                	jne    8013a1 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8013cf:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8013d5:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8013da:	eb 07                	jmp    8013e3 <fd_alloc+0x4d>
			*fd_store = fd;
  8013dc:	89 01                	mov    %eax,(%ecx)
			return 0;
  8013de:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013e3:	5d                   	pop    %ebp
  8013e4:	c3                   	ret    

008013e5 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8013e5:	55                   	push   %ebp
  8013e6:	89 e5                	mov    %esp,%ebp
  8013e8:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8013eb:	83 f8 1f             	cmp    $0x1f,%eax
  8013ee:	77 36                	ja     801426 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8013f0:	c1 e0 0c             	shl    $0xc,%eax
  8013f3:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8013f8:	89 c2                	mov    %eax,%edx
  8013fa:	c1 ea 16             	shr    $0x16,%edx
  8013fd:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801404:	f6 c2 01             	test   $0x1,%dl
  801407:	74 24                	je     80142d <fd_lookup+0x48>
  801409:	89 c2                	mov    %eax,%edx
  80140b:	c1 ea 0c             	shr    $0xc,%edx
  80140e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801415:	f6 c2 01             	test   $0x1,%dl
  801418:	74 1a                	je     801434 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80141a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80141d:	89 02                	mov    %eax,(%edx)
	return 0;
  80141f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801424:	5d                   	pop    %ebp
  801425:	c3                   	ret    
		return -E_INVAL;
  801426:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80142b:	eb f7                	jmp    801424 <fd_lookup+0x3f>
		return -E_INVAL;
  80142d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801432:	eb f0                	jmp    801424 <fd_lookup+0x3f>
  801434:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801439:	eb e9                	jmp    801424 <fd_lookup+0x3f>

0080143b <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80143b:	55                   	push   %ebp
  80143c:	89 e5                	mov    %esp,%ebp
  80143e:	83 ec 08             	sub    $0x8,%esp
  801441:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801444:	ba 68 30 80 00       	mov    $0x803068,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801449:	b8 24 40 80 00       	mov    $0x804024,%eax
		if (devtab[i]->dev_id == dev_id) {
  80144e:	39 08                	cmp    %ecx,(%eax)
  801450:	74 33                	je     801485 <dev_lookup+0x4a>
  801452:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801455:	8b 02                	mov    (%edx),%eax
  801457:	85 c0                	test   %eax,%eax
  801459:	75 f3                	jne    80144e <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80145b:	a1 1c 50 80 00       	mov    0x80501c,%eax
  801460:	8b 40 48             	mov    0x48(%eax),%eax
  801463:	83 ec 04             	sub    $0x4,%esp
  801466:	51                   	push   %ecx
  801467:	50                   	push   %eax
  801468:	68 ec 2f 80 00       	push   $0x802fec
  80146d:	e8 57 f2 ff ff       	call   8006c9 <cprintf>
	*dev = 0;
  801472:	8b 45 0c             	mov    0xc(%ebp),%eax
  801475:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80147b:	83 c4 10             	add    $0x10,%esp
  80147e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801483:	c9                   	leave  
  801484:	c3                   	ret    
			*dev = devtab[i];
  801485:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801488:	89 01                	mov    %eax,(%ecx)
			return 0;
  80148a:	b8 00 00 00 00       	mov    $0x0,%eax
  80148f:	eb f2                	jmp    801483 <dev_lookup+0x48>

00801491 <fd_close>:
{
  801491:	55                   	push   %ebp
  801492:	89 e5                	mov    %esp,%ebp
  801494:	57                   	push   %edi
  801495:	56                   	push   %esi
  801496:	53                   	push   %ebx
  801497:	83 ec 1c             	sub    $0x1c,%esp
  80149a:	8b 75 08             	mov    0x8(%ebp),%esi
  80149d:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8014a0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8014a3:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8014a4:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8014aa:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8014ad:	50                   	push   %eax
  8014ae:	e8 32 ff ff ff       	call   8013e5 <fd_lookup>
  8014b3:	89 c3                	mov    %eax,%ebx
  8014b5:	83 c4 08             	add    $0x8,%esp
  8014b8:	85 c0                	test   %eax,%eax
  8014ba:	78 05                	js     8014c1 <fd_close+0x30>
	    || fd != fd2)
  8014bc:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8014bf:	74 16                	je     8014d7 <fd_close+0x46>
		return (must_exist ? r : 0);
  8014c1:	89 f8                	mov    %edi,%eax
  8014c3:	84 c0                	test   %al,%al
  8014c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8014ca:	0f 44 d8             	cmove  %eax,%ebx
}
  8014cd:	89 d8                	mov    %ebx,%eax
  8014cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014d2:	5b                   	pop    %ebx
  8014d3:	5e                   	pop    %esi
  8014d4:	5f                   	pop    %edi
  8014d5:	5d                   	pop    %ebp
  8014d6:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8014d7:	83 ec 08             	sub    $0x8,%esp
  8014da:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8014dd:	50                   	push   %eax
  8014de:	ff 36                	pushl  (%esi)
  8014e0:	e8 56 ff ff ff       	call   80143b <dev_lookup>
  8014e5:	89 c3                	mov    %eax,%ebx
  8014e7:	83 c4 10             	add    $0x10,%esp
  8014ea:	85 c0                	test   %eax,%eax
  8014ec:	78 15                	js     801503 <fd_close+0x72>
		if (dev->dev_close)
  8014ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014f1:	8b 40 10             	mov    0x10(%eax),%eax
  8014f4:	85 c0                	test   %eax,%eax
  8014f6:	74 1b                	je     801513 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  8014f8:	83 ec 0c             	sub    $0xc,%esp
  8014fb:	56                   	push   %esi
  8014fc:	ff d0                	call   *%eax
  8014fe:	89 c3                	mov    %eax,%ebx
  801500:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801503:	83 ec 08             	sub    $0x8,%esp
  801506:	56                   	push   %esi
  801507:	6a 00                	push   $0x0
  801509:	e8 d6 fc ff ff       	call   8011e4 <sys_page_unmap>
	return r;
  80150e:	83 c4 10             	add    $0x10,%esp
  801511:	eb ba                	jmp    8014cd <fd_close+0x3c>
			r = 0;
  801513:	bb 00 00 00 00       	mov    $0x0,%ebx
  801518:	eb e9                	jmp    801503 <fd_close+0x72>

0080151a <close>:

int
close(int fdnum)
{
  80151a:	55                   	push   %ebp
  80151b:	89 e5                	mov    %esp,%ebp
  80151d:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801520:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801523:	50                   	push   %eax
  801524:	ff 75 08             	pushl  0x8(%ebp)
  801527:	e8 b9 fe ff ff       	call   8013e5 <fd_lookup>
  80152c:	83 c4 08             	add    $0x8,%esp
  80152f:	85 c0                	test   %eax,%eax
  801531:	78 10                	js     801543 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  801533:	83 ec 08             	sub    $0x8,%esp
  801536:	6a 01                	push   $0x1
  801538:	ff 75 f4             	pushl  -0xc(%ebp)
  80153b:	e8 51 ff ff ff       	call   801491 <fd_close>
  801540:	83 c4 10             	add    $0x10,%esp
}
  801543:	c9                   	leave  
  801544:	c3                   	ret    

00801545 <close_all>:

void
close_all(void)
{
  801545:	55                   	push   %ebp
  801546:	89 e5                	mov    %esp,%ebp
  801548:	53                   	push   %ebx
  801549:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80154c:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801551:	83 ec 0c             	sub    $0xc,%esp
  801554:	53                   	push   %ebx
  801555:	e8 c0 ff ff ff       	call   80151a <close>
	for (i = 0; i < MAXFD; i++)
  80155a:	83 c3 01             	add    $0x1,%ebx
  80155d:	83 c4 10             	add    $0x10,%esp
  801560:	83 fb 20             	cmp    $0x20,%ebx
  801563:	75 ec                	jne    801551 <close_all+0xc>
}
  801565:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801568:	c9                   	leave  
  801569:	c3                   	ret    

0080156a <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80156a:	55                   	push   %ebp
  80156b:	89 e5                	mov    %esp,%ebp
  80156d:	57                   	push   %edi
  80156e:	56                   	push   %esi
  80156f:	53                   	push   %ebx
  801570:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801573:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801576:	50                   	push   %eax
  801577:	ff 75 08             	pushl  0x8(%ebp)
  80157a:	e8 66 fe ff ff       	call   8013e5 <fd_lookup>
  80157f:	89 c3                	mov    %eax,%ebx
  801581:	83 c4 08             	add    $0x8,%esp
  801584:	85 c0                	test   %eax,%eax
  801586:	0f 88 81 00 00 00    	js     80160d <dup+0xa3>
		return r;
	close(newfdnum);
  80158c:	83 ec 0c             	sub    $0xc,%esp
  80158f:	ff 75 0c             	pushl  0xc(%ebp)
  801592:	e8 83 ff ff ff       	call   80151a <close>

	newfd = INDEX2FD(newfdnum);
  801597:	8b 75 0c             	mov    0xc(%ebp),%esi
  80159a:	c1 e6 0c             	shl    $0xc,%esi
  80159d:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8015a3:	83 c4 04             	add    $0x4,%esp
  8015a6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8015a9:	e8 d1 fd ff ff       	call   80137f <fd2data>
  8015ae:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8015b0:	89 34 24             	mov    %esi,(%esp)
  8015b3:	e8 c7 fd ff ff       	call   80137f <fd2data>
  8015b8:	83 c4 10             	add    $0x10,%esp
  8015bb:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8015bd:	89 d8                	mov    %ebx,%eax
  8015bf:	c1 e8 16             	shr    $0x16,%eax
  8015c2:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8015c9:	a8 01                	test   $0x1,%al
  8015cb:	74 11                	je     8015de <dup+0x74>
  8015cd:	89 d8                	mov    %ebx,%eax
  8015cf:	c1 e8 0c             	shr    $0xc,%eax
  8015d2:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8015d9:	f6 c2 01             	test   $0x1,%dl
  8015dc:	75 39                	jne    801617 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8015de:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8015e1:	89 d0                	mov    %edx,%eax
  8015e3:	c1 e8 0c             	shr    $0xc,%eax
  8015e6:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8015ed:	83 ec 0c             	sub    $0xc,%esp
  8015f0:	25 07 0e 00 00       	and    $0xe07,%eax
  8015f5:	50                   	push   %eax
  8015f6:	56                   	push   %esi
  8015f7:	6a 00                	push   $0x0
  8015f9:	52                   	push   %edx
  8015fa:	6a 00                	push   $0x0
  8015fc:	e8 a1 fb ff ff       	call   8011a2 <sys_page_map>
  801601:	89 c3                	mov    %eax,%ebx
  801603:	83 c4 20             	add    $0x20,%esp
  801606:	85 c0                	test   %eax,%eax
  801608:	78 31                	js     80163b <dup+0xd1>
		goto err;

	return newfdnum;
  80160a:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80160d:	89 d8                	mov    %ebx,%eax
  80160f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801612:	5b                   	pop    %ebx
  801613:	5e                   	pop    %esi
  801614:	5f                   	pop    %edi
  801615:	5d                   	pop    %ebp
  801616:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801617:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80161e:	83 ec 0c             	sub    $0xc,%esp
  801621:	25 07 0e 00 00       	and    $0xe07,%eax
  801626:	50                   	push   %eax
  801627:	57                   	push   %edi
  801628:	6a 00                	push   $0x0
  80162a:	53                   	push   %ebx
  80162b:	6a 00                	push   $0x0
  80162d:	e8 70 fb ff ff       	call   8011a2 <sys_page_map>
  801632:	89 c3                	mov    %eax,%ebx
  801634:	83 c4 20             	add    $0x20,%esp
  801637:	85 c0                	test   %eax,%eax
  801639:	79 a3                	jns    8015de <dup+0x74>
	sys_page_unmap(0, newfd);
  80163b:	83 ec 08             	sub    $0x8,%esp
  80163e:	56                   	push   %esi
  80163f:	6a 00                	push   $0x0
  801641:	e8 9e fb ff ff       	call   8011e4 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801646:	83 c4 08             	add    $0x8,%esp
  801649:	57                   	push   %edi
  80164a:	6a 00                	push   $0x0
  80164c:	e8 93 fb ff ff       	call   8011e4 <sys_page_unmap>
	return r;
  801651:	83 c4 10             	add    $0x10,%esp
  801654:	eb b7                	jmp    80160d <dup+0xa3>

00801656 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801656:	55                   	push   %ebp
  801657:	89 e5                	mov    %esp,%ebp
  801659:	53                   	push   %ebx
  80165a:	83 ec 14             	sub    $0x14,%esp
  80165d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801660:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801663:	50                   	push   %eax
  801664:	53                   	push   %ebx
  801665:	e8 7b fd ff ff       	call   8013e5 <fd_lookup>
  80166a:	83 c4 08             	add    $0x8,%esp
  80166d:	85 c0                	test   %eax,%eax
  80166f:	78 3f                	js     8016b0 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801671:	83 ec 08             	sub    $0x8,%esp
  801674:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801677:	50                   	push   %eax
  801678:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80167b:	ff 30                	pushl  (%eax)
  80167d:	e8 b9 fd ff ff       	call   80143b <dev_lookup>
  801682:	83 c4 10             	add    $0x10,%esp
  801685:	85 c0                	test   %eax,%eax
  801687:	78 27                	js     8016b0 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801689:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80168c:	8b 42 08             	mov    0x8(%edx),%eax
  80168f:	83 e0 03             	and    $0x3,%eax
  801692:	83 f8 01             	cmp    $0x1,%eax
  801695:	74 1e                	je     8016b5 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801697:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80169a:	8b 40 08             	mov    0x8(%eax),%eax
  80169d:	85 c0                	test   %eax,%eax
  80169f:	74 35                	je     8016d6 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8016a1:	83 ec 04             	sub    $0x4,%esp
  8016a4:	ff 75 10             	pushl  0x10(%ebp)
  8016a7:	ff 75 0c             	pushl  0xc(%ebp)
  8016aa:	52                   	push   %edx
  8016ab:	ff d0                	call   *%eax
  8016ad:	83 c4 10             	add    $0x10,%esp
}
  8016b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016b3:	c9                   	leave  
  8016b4:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8016b5:	a1 1c 50 80 00       	mov    0x80501c,%eax
  8016ba:	8b 40 48             	mov    0x48(%eax),%eax
  8016bd:	83 ec 04             	sub    $0x4,%esp
  8016c0:	53                   	push   %ebx
  8016c1:	50                   	push   %eax
  8016c2:	68 2d 30 80 00       	push   $0x80302d
  8016c7:	e8 fd ef ff ff       	call   8006c9 <cprintf>
		return -E_INVAL;
  8016cc:	83 c4 10             	add    $0x10,%esp
  8016cf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016d4:	eb da                	jmp    8016b0 <read+0x5a>
		return -E_NOT_SUPP;
  8016d6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016db:	eb d3                	jmp    8016b0 <read+0x5a>

008016dd <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8016dd:	55                   	push   %ebp
  8016de:	89 e5                	mov    %esp,%ebp
  8016e0:	57                   	push   %edi
  8016e1:	56                   	push   %esi
  8016e2:	53                   	push   %ebx
  8016e3:	83 ec 0c             	sub    $0xc,%esp
  8016e6:	8b 7d 08             	mov    0x8(%ebp),%edi
  8016e9:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8016ec:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016f1:	39 f3                	cmp    %esi,%ebx
  8016f3:	73 25                	jae    80171a <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8016f5:	83 ec 04             	sub    $0x4,%esp
  8016f8:	89 f0                	mov    %esi,%eax
  8016fa:	29 d8                	sub    %ebx,%eax
  8016fc:	50                   	push   %eax
  8016fd:	89 d8                	mov    %ebx,%eax
  8016ff:	03 45 0c             	add    0xc(%ebp),%eax
  801702:	50                   	push   %eax
  801703:	57                   	push   %edi
  801704:	e8 4d ff ff ff       	call   801656 <read>
		if (m < 0)
  801709:	83 c4 10             	add    $0x10,%esp
  80170c:	85 c0                	test   %eax,%eax
  80170e:	78 08                	js     801718 <readn+0x3b>
			return m;
		if (m == 0)
  801710:	85 c0                	test   %eax,%eax
  801712:	74 06                	je     80171a <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  801714:	01 c3                	add    %eax,%ebx
  801716:	eb d9                	jmp    8016f1 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801718:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80171a:	89 d8                	mov    %ebx,%eax
  80171c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80171f:	5b                   	pop    %ebx
  801720:	5e                   	pop    %esi
  801721:	5f                   	pop    %edi
  801722:	5d                   	pop    %ebp
  801723:	c3                   	ret    

00801724 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801724:	55                   	push   %ebp
  801725:	89 e5                	mov    %esp,%ebp
  801727:	53                   	push   %ebx
  801728:	83 ec 14             	sub    $0x14,%esp
  80172b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80172e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801731:	50                   	push   %eax
  801732:	53                   	push   %ebx
  801733:	e8 ad fc ff ff       	call   8013e5 <fd_lookup>
  801738:	83 c4 08             	add    $0x8,%esp
  80173b:	85 c0                	test   %eax,%eax
  80173d:	78 3a                	js     801779 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80173f:	83 ec 08             	sub    $0x8,%esp
  801742:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801745:	50                   	push   %eax
  801746:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801749:	ff 30                	pushl  (%eax)
  80174b:	e8 eb fc ff ff       	call   80143b <dev_lookup>
  801750:	83 c4 10             	add    $0x10,%esp
  801753:	85 c0                	test   %eax,%eax
  801755:	78 22                	js     801779 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801757:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80175a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80175e:	74 1e                	je     80177e <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801760:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801763:	8b 52 0c             	mov    0xc(%edx),%edx
  801766:	85 d2                	test   %edx,%edx
  801768:	74 35                	je     80179f <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80176a:	83 ec 04             	sub    $0x4,%esp
  80176d:	ff 75 10             	pushl  0x10(%ebp)
  801770:	ff 75 0c             	pushl  0xc(%ebp)
  801773:	50                   	push   %eax
  801774:	ff d2                	call   *%edx
  801776:	83 c4 10             	add    $0x10,%esp
}
  801779:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80177c:	c9                   	leave  
  80177d:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80177e:	a1 1c 50 80 00       	mov    0x80501c,%eax
  801783:	8b 40 48             	mov    0x48(%eax),%eax
  801786:	83 ec 04             	sub    $0x4,%esp
  801789:	53                   	push   %ebx
  80178a:	50                   	push   %eax
  80178b:	68 49 30 80 00       	push   $0x803049
  801790:	e8 34 ef ff ff       	call   8006c9 <cprintf>
		return -E_INVAL;
  801795:	83 c4 10             	add    $0x10,%esp
  801798:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80179d:	eb da                	jmp    801779 <write+0x55>
		return -E_NOT_SUPP;
  80179f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017a4:	eb d3                	jmp    801779 <write+0x55>

008017a6 <seek>:

int
seek(int fdnum, off_t offset)
{
  8017a6:	55                   	push   %ebp
  8017a7:	89 e5                	mov    %esp,%ebp
  8017a9:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8017ac:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8017af:	50                   	push   %eax
  8017b0:	ff 75 08             	pushl  0x8(%ebp)
  8017b3:	e8 2d fc ff ff       	call   8013e5 <fd_lookup>
  8017b8:	83 c4 08             	add    $0x8,%esp
  8017bb:	85 c0                	test   %eax,%eax
  8017bd:	78 0e                	js     8017cd <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8017bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017c5:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8017c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017cd:	c9                   	leave  
  8017ce:	c3                   	ret    

008017cf <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8017cf:	55                   	push   %ebp
  8017d0:	89 e5                	mov    %esp,%ebp
  8017d2:	53                   	push   %ebx
  8017d3:	83 ec 14             	sub    $0x14,%esp
  8017d6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017d9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017dc:	50                   	push   %eax
  8017dd:	53                   	push   %ebx
  8017de:	e8 02 fc ff ff       	call   8013e5 <fd_lookup>
  8017e3:	83 c4 08             	add    $0x8,%esp
  8017e6:	85 c0                	test   %eax,%eax
  8017e8:	78 37                	js     801821 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017ea:	83 ec 08             	sub    $0x8,%esp
  8017ed:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017f0:	50                   	push   %eax
  8017f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017f4:	ff 30                	pushl  (%eax)
  8017f6:	e8 40 fc ff ff       	call   80143b <dev_lookup>
  8017fb:	83 c4 10             	add    $0x10,%esp
  8017fe:	85 c0                	test   %eax,%eax
  801800:	78 1f                	js     801821 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801802:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801805:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801809:	74 1b                	je     801826 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80180b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80180e:	8b 52 18             	mov    0x18(%edx),%edx
  801811:	85 d2                	test   %edx,%edx
  801813:	74 32                	je     801847 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801815:	83 ec 08             	sub    $0x8,%esp
  801818:	ff 75 0c             	pushl  0xc(%ebp)
  80181b:	50                   	push   %eax
  80181c:	ff d2                	call   *%edx
  80181e:	83 c4 10             	add    $0x10,%esp
}
  801821:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801824:	c9                   	leave  
  801825:	c3                   	ret    
			thisenv->env_id, fdnum);
  801826:	a1 1c 50 80 00       	mov    0x80501c,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80182b:	8b 40 48             	mov    0x48(%eax),%eax
  80182e:	83 ec 04             	sub    $0x4,%esp
  801831:	53                   	push   %ebx
  801832:	50                   	push   %eax
  801833:	68 0c 30 80 00       	push   $0x80300c
  801838:	e8 8c ee ff ff       	call   8006c9 <cprintf>
		return -E_INVAL;
  80183d:	83 c4 10             	add    $0x10,%esp
  801840:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801845:	eb da                	jmp    801821 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801847:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80184c:	eb d3                	jmp    801821 <ftruncate+0x52>

0080184e <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80184e:	55                   	push   %ebp
  80184f:	89 e5                	mov    %esp,%ebp
  801851:	53                   	push   %ebx
  801852:	83 ec 14             	sub    $0x14,%esp
  801855:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801858:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80185b:	50                   	push   %eax
  80185c:	ff 75 08             	pushl  0x8(%ebp)
  80185f:	e8 81 fb ff ff       	call   8013e5 <fd_lookup>
  801864:	83 c4 08             	add    $0x8,%esp
  801867:	85 c0                	test   %eax,%eax
  801869:	78 4b                	js     8018b6 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80186b:	83 ec 08             	sub    $0x8,%esp
  80186e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801871:	50                   	push   %eax
  801872:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801875:	ff 30                	pushl  (%eax)
  801877:	e8 bf fb ff ff       	call   80143b <dev_lookup>
  80187c:	83 c4 10             	add    $0x10,%esp
  80187f:	85 c0                	test   %eax,%eax
  801881:	78 33                	js     8018b6 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801883:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801886:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80188a:	74 2f                	je     8018bb <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80188c:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80188f:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801896:	00 00 00 
	stat->st_isdir = 0;
  801899:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8018a0:	00 00 00 
	stat->st_dev = dev;
  8018a3:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8018a9:	83 ec 08             	sub    $0x8,%esp
  8018ac:	53                   	push   %ebx
  8018ad:	ff 75 f0             	pushl  -0x10(%ebp)
  8018b0:	ff 50 14             	call   *0x14(%eax)
  8018b3:	83 c4 10             	add    $0x10,%esp
}
  8018b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018b9:	c9                   	leave  
  8018ba:	c3                   	ret    
		return -E_NOT_SUPP;
  8018bb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018c0:	eb f4                	jmp    8018b6 <fstat+0x68>

008018c2 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8018c2:	55                   	push   %ebp
  8018c3:	89 e5                	mov    %esp,%ebp
  8018c5:	56                   	push   %esi
  8018c6:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8018c7:	83 ec 08             	sub    $0x8,%esp
  8018ca:	6a 00                	push   $0x0
  8018cc:	ff 75 08             	pushl  0x8(%ebp)
  8018cf:	e8 26 02 00 00       	call   801afa <open>
  8018d4:	89 c3                	mov    %eax,%ebx
  8018d6:	83 c4 10             	add    $0x10,%esp
  8018d9:	85 c0                	test   %eax,%eax
  8018db:	78 1b                	js     8018f8 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8018dd:	83 ec 08             	sub    $0x8,%esp
  8018e0:	ff 75 0c             	pushl  0xc(%ebp)
  8018e3:	50                   	push   %eax
  8018e4:	e8 65 ff ff ff       	call   80184e <fstat>
  8018e9:	89 c6                	mov    %eax,%esi
	close(fd);
  8018eb:	89 1c 24             	mov    %ebx,(%esp)
  8018ee:	e8 27 fc ff ff       	call   80151a <close>
	return r;
  8018f3:	83 c4 10             	add    $0x10,%esp
  8018f6:	89 f3                	mov    %esi,%ebx
}
  8018f8:	89 d8                	mov    %ebx,%eax
  8018fa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018fd:	5b                   	pop    %ebx
  8018fe:	5e                   	pop    %esi
  8018ff:	5d                   	pop    %ebp
  801900:	c3                   	ret    

00801901 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801901:	55                   	push   %ebp
  801902:	89 e5                	mov    %esp,%ebp
  801904:	56                   	push   %esi
  801905:	53                   	push   %ebx
  801906:	89 c6                	mov    %eax,%esi
  801908:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80190a:	83 3d 10 50 80 00 00 	cmpl   $0x0,0x805010
  801911:	74 27                	je     80193a <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801913:	6a 07                	push   $0x7
  801915:	68 00 60 80 00       	push   $0x806000
  80191a:	56                   	push   %esi
  80191b:	ff 35 10 50 80 00    	pushl  0x805010
  801921:	e8 97 0e 00 00       	call   8027bd <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801926:	83 c4 0c             	add    $0xc,%esp
  801929:	6a 00                	push   $0x0
  80192b:	53                   	push   %ebx
  80192c:	6a 00                	push   $0x0
  80192e:	e8 21 0e 00 00       	call   802754 <ipc_recv>
}
  801933:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801936:	5b                   	pop    %ebx
  801937:	5e                   	pop    %esi
  801938:	5d                   	pop    %ebp
  801939:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80193a:	83 ec 0c             	sub    $0xc,%esp
  80193d:	6a 01                	push   $0x1
  80193f:	e8 d2 0e 00 00       	call   802816 <ipc_find_env>
  801944:	a3 10 50 80 00       	mov    %eax,0x805010
  801949:	83 c4 10             	add    $0x10,%esp
  80194c:	eb c5                	jmp    801913 <fsipc+0x12>

0080194e <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80194e:	55                   	push   %ebp
  80194f:	89 e5                	mov    %esp,%ebp
  801951:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801954:	8b 45 08             	mov    0x8(%ebp),%eax
  801957:	8b 40 0c             	mov    0xc(%eax),%eax
  80195a:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  80195f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801962:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801967:	ba 00 00 00 00       	mov    $0x0,%edx
  80196c:	b8 02 00 00 00       	mov    $0x2,%eax
  801971:	e8 8b ff ff ff       	call   801901 <fsipc>
}
  801976:	c9                   	leave  
  801977:	c3                   	ret    

00801978 <devfile_flush>:
{
  801978:	55                   	push   %ebp
  801979:	89 e5                	mov    %esp,%ebp
  80197b:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80197e:	8b 45 08             	mov    0x8(%ebp),%eax
  801981:	8b 40 0c             	mov    0xc(%eax),%eax
  801984:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801989:	ba 00 00 00 00       	mov    $0x0,%edx
  80198e:	b8 06 00 00 00       	mov    $0x6,%eax
  801993:	e8 69 ff ff ff       	call   801901 <fsipc>
}
  801998:	c9                   	leave  
  801999:	c3                   	ret    

0080199a <devfile_stat>:
{
  80199a:	55                   	push   %ebp
  80199b:	89 e5                	mov    %esp,%ebp
  80199d:	53                   	push   %ebx
  80199e:	83 ec 04             	sub    $0x4,%esp
  8019a1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8019a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a7:	8b 40 0c             	mov    0xc(%eax),%eax
  8019aa:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8019af:	ba 00 00 00 00       	mov    $0x0,%edx
  8019b4:	b8 05 00 00 00       	mov    $0x5,%eax
  8019b9:	e8 43 ff ff ff       	call   801901 <fsipc>
  8019be:	85 c0                	test   %eax,%eax
  8019c0:	78 2c                	js     8019ee <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8019c2:	83 ec 08             	sub    $0x8,%esp
  8019c5:	68 00 60 80 00       	push   $0x806000
  8019ca:	53                   	push   %ebx
  8019cb:	e8 96 f3 ff ff       	call   800d66 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8019d0:	a1 80 60 80 00       	mov    0x806080,%eax
  8019d5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8019db:	a1 84 60 80 00       	mov    0x806084,%eax
  8019e0:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8019e6:	83 c4 10             	add    $0x10,%esp
  8019e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019f1:	c9                   	leave  
  8019f2:	c3                   	ret    

008019f3 <devfile_write>:
{
  8019f3:	55                   	push   %ebp
  8019f4:	89 e5                	mov    %esp,%ebp
  8019f6:	53                   	push   %ebx
  8019f7:	83 ec 04             	sub    $0x4,%esp
  8019fa:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8019fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801a00:	8b 40 0c             	mov    0xc(%eax),%eax
  801a03:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801a08:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  801a0e:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  801a14:	77 30                	ja     801a46 <devfile_write+0x53>
	memmove(fsipcbuf.write.req_buf, buf, n);
  801a16:	83 ec 04             	sub    $0x4,%esp
  801a19:	53                   	push   %ebx
  801a1a:	ff 75 0c             	pushl  0xc(%ebp)
  801a1d:	68 08 60 80 00       	push   $0x806008
  801a22:	e8 cd f4 ff ff       	call   800ef4 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801a27:	ba 00 00 00 00       	mov    $0x0,%edx
  801a2c:	b8 04 00 00 00       	mov    $0x4,%eax
  801a31:	e8 cb fe ff ff       	call   801901 <fsipc>
  801a36:	83 c4 10             	add    $0x10,%esp
  801a39:	85 c0                	test   %eax,%eax
  801a3b:	78 04                	js     801a41 <devfile_write+0x4e>
	assert(r <= n);
  801a3d:	39 d8                	cmp    %ebx,%eax
  801a3f:	77 1e                	ja     801a5f <devfile_write+0x6c>
}
  801a41:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a44:	c9                   	leave  
  801a45:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  801a46:	68 7c 30 80 00       	push   $0x80307c
  801a4b:	68 a9 30 80 00       	push   $0x8030a9
  801a50:	68 94 00 00 00       	push   $0x94
  801a55:	68 be 30 80 00       	push   $0x8030be
  801a5a:	e8 8f eb ff ff       	call   8005ee <_panic>
	assert(r <= n);
  801a5f:	68 c9 30 80 00       	push   $0x8030c9
  801a64:	68 a9 30 80 00       	push   $0x8030a9
  801a69:	68 98 00 00 00       	push   $0x98
  801a6e:	68 be 30 80 00       	push   $0x8030be
  801a73:	e8 76 eb ff ff       	call   8005ee <_panic>

00801a78 <devfile_read>:
{
  801a78:	55                   	push   %ebp
  801a79:	89 e5                	mov    %esp,%ebp
  801a7b:	56                   	push   %esi
  801a7c:	53                   	push   %ebx
  801a7d:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801a80:	8b 45 08             	mov    0x8(%ebp),%eax
  801a83:	8b 40 0c             	mov    0xc(%eax),%eax
  801a86:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801a8b:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801a91:	ba 00 00 00 00       	mov    $0x0,%edx
  801a96:	b8 03 00 00 00       	mov    $0x3,%eax
  801a9b:	e8 61 fe ff ff       	call   801901 <fsipc>
  801aa0:	89 c3                	mov    %eax,%ebx
  801aa2:	85 c0                	test   %eax,%eax
  801aa4:	78 1f                	js     801ac5 <devfile_read+0x4d>
	assert(r <= n);
  801aa6:	39 f0                	cmp    %esi,%eax
  801aa8:	77 24                	ja     801ace <devfile_read+0x56>
	assert(r <= PGSIZE);
  801aaa:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801aaf:	7f 33                	jg     801ae4 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801ab1:	83 ec 04             	sub    $0x4,%esp
  801ab4:	50                   	push   %eax
  801ab5:	68 00 60 80 00       	push   $0x806000
  801aba:	ff 75 0c             	pushl  0xc(%ebp)
  801abd:	e8 32 f4 ff ff       	call   800ef4 <memmove>
	return r;
  801ac2:	83 c4 10             	add    $0x10,%esp
}
  801ac5:	89 d8                	mov    %ebx,%eax
  801ac7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801aca:	5b                   	pop    %ebx
  801acb:	5e                   	pop    %esi
  801acc:	5d                   	pop    %ebp
  801acd:	c3                   	ret    
	assert(r <= n);
  801ace:	68 c9 30 80 00       	push   $0x8030c9
  801ad3:	68 a9 30 80 00       	push   $0x8030a9
  801ad8:	6a 7c                	push   $0x7c
  801ada:	68 be 30 80 00       	push   $0x8030be
  801adf:	e8 0a eb ff ff       	call   8005ee <_panic>
	assert(r <= PGSIZE);
  801ae4:	68 d0 30 80 00       	push   $0x8030d0
  801ae9:	68 a9 30 80 00       	push   $0x8030a9
  801aee:	6a 7d                	push   $0x7d
  801af0:	68 be 30 80 00       	push   $0x8030be
  801af5:	e8 f4 ea ff ff       	call   8005ee <_panic>

00801afa <open>:
{
  801afa:	55                   	push   %ebp
  801afb:	89 e5                	mov    %esp,%ebp
  801afd:	56                   	push   %esi
  801afe:	53                   	push   %ebx
  801aff:	83 ec 1c             	sub    $0x1c,%esp
  801b02:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801b05:	56                   	push   %esi
  801b06:	e8 24 f2 ff ff       	call   800d2f <strlen>
  801b0b:	83 c4 10             	add    $0x10,%esp
  801b0e:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801b13:	7f 6c                	jg     801b81 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801b15:	83 ec 0c             	sub    $0xc,%esp
  801b18:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b1b:	50                   	push   %eax
  801b1c:	e8 75 f8 ff ff       	call   801396 <fd_alloc>
  801b21:	89 c3                	mov    %eax,%ebx
  801b23:	83 c4 10             	add    $0x10,%esp
  801b26:	85 c0                	test   %eax,%eax
  801b28:	78 3c                	js     801b66 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801b2a:	83 ec 08             	sub    $0x8,%esp
  801b2d:	56                   	push   %esi
  801b2e:	68 00 60 80 00       	push   $0x806000
  801b33:	e8 2e f2 ff ff       	call   800d66 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801b38:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b3b:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801b40:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b43:	b8 01 00 00 00       	mov    $0x1,%eax
  801b48:	e8 b4 fd ff ff       	call   801901 <fsipc>
  801b4d:	89 c3                	mov    %eax,%ebx
  801b4f:	83 c4 10             	add    $0x10,%esp
  801b52:	85 c0                	test   %eax,%eax
  801b54:	78 19                	js     801b6f <open+0x75>
	return fd2num(fd);
  801b56:	83 ec 0c             	sub    $0xc,%esp
  801b59:	ff 75 f4             	pushl  -0xc(%ebp)
  801b5c:	e8 0e f8 ff ff       	call   80136f <fd2num>
  801b61:	89 c3                	mov    %eax,%ebx
  801b63:	83 c4 10             	add    $0x10,%esp
}
  801b66:	89 d8                	mov    %ebx,%eax
  801b68:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b6b:	5b                   	pop    %ebx
  801b6c:	5e                   	pop    %esi
  801b6d:	5d                   	pop    %ebp
  801b6e:	c3                   	ret    
		fd_close(fd, 0);
  801b6f:	83 ec 08             	sub    $0x8,%esp
  801b72:	6a 00                	push   $0x0
  801b74:	ff 75 f4             	pushl  -0xc(%ebp)
  801b77:	e8 15 f9 ff ff       	call   801491 <fd_close>
		return r;
  801b7c:	83 c4 10             	add    $0x10,%esp
  801b7f:	eb e5                	jmp    801b66 <open+0x6c>
		return -E_BAD_PATH;
  801b81:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801b86:	eb de                	jmp    801b66 <open+0x6c>

00801b88 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801b88:	55                   	push   %ebp
  801b89:	89 e5                	mov    %esp,%ebp
  801b8b:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801b8e:	ba 00 00 00 00       	mov    $0x0,%edx
  801b93:	b8 08 00 00 00       	mov    $0x8,%eax
  801b98:	e8 64 fd ff ff       	call   801901 <fsipc>
}
  801b9d:	c9                   	leave  
  801b9e:	c3                   	ret    

00801b9f <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801b9f:	55                   	push   %ebp
  801ba0:	89 e5                	mov    %esp,%ebp
  801ba2:	56                   	push   %esi
  801ba3:	53                   	push   %ebx
  801ba4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801ba7:	83 ec 0c             	sub    $0xc,%esp
  801baa:	ff 75 08             	pushl  0x8(%ebp)
  801bad:	e8 cd f7 ff ff       	call   80137f <fd2data>
  801bb2:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801bb4:	83 c4 08             	add    $0x8,%esp
  801bb7:	68 dc 30 80 00       	push   $0x8030dc
  801bbc:	53                   	push   %ebx
  801bbd:	e8 a4 f1 ff ff       	call   800d66 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801bc2:	8b 46 04             	mov    0x4(%esi),%eax
  801bc5:	2b 06                	sub    (%esi),%eax
  801bc7:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801bcd:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801bd4:	00 00 00 
	stat->st_dev = &devpipe;
  801bd7:	c7 83 88 00 00 00 40 	movl   $0x804040,0x88(%ebx)
  801bde:	40 80 00 
	return 0;
}
  801be1:	b8 00 00 00 00       	mov    $0x0,%eax
  801be6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801be9:	5b                   	pop    %ebx
  801bea:	5e                   	pop    %esi
  801beb:	5d                   	pop    %ebp
  801bec:	c3                   	ret    

00801bed <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801bed:	55                   	push   %ebp
  801bee:	89 e5                	mov    %esp,%ebp
  801bf0:	53                   	push   %ebx
  801bf1:	83 ec 0c             	sub    $0xc,%esp
  801bf4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801bf7:	53                   	push   %ebx
  801bf8:	6a 00                	push   $0x0
  801bfa:	e8 e5 f5 ff ff       	call   8011e4 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801bff:	89 1c 24             	mov    %ebx,(%esp)
  801c02:	e8 78 f7 ff ff       	call   80137f <fd2data>
  801c07:	83 c4 08             	add    $0x8,%esp
  801c0a:	50                   	push   %eax
  801c0b:	6a 00                	push   $0x0
  801c0d:	e8 d2 f5 ff ff       	call   8011e4 <sys_page_unmap>
}
  801c12:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c15:	c9                   	leave  
  801c16:	c3                   	ret    

00801c17 <_pipeisclosed>:
{
  801c17:	55                   	push   %ebp
  801c18:	89 e5                	mov    %esp,%ebp
  801c1a:	57                   	push   %edi
  801c1b:	56                   	push   %esi
  801c1c:	53                   	push   %ebx
  801c1d:	83 ec 1c             	sub    $0x1c,%esp
  801c20:	89 c7                	mov    %eax,%edi
  801c22:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801c24:	a1 1c 50 80 00       	mov    0x80501c,%eax
  801c29:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801c2c:	83 ec 0c             	sub    $0xc,%esp
  801c2f:	57                   	push   %edi
  801c30:	e8 1a 0c 00 00       	call   80284f <pageref>
  801c35:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801c38:	89 34 24             	mov    %esi,(%esp)
  801c3b:	e8 0f 0c 00 00       	call   80284f <pageref>
		nn = thisenv->env_runs;
  801c40:	8b 15 1c 50 80 00    	mov    0x80501c,%edx
  801c46:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801c49:	83 c4 10             	add    $0x10,%esp
  801c4c:	39 cb                	cmp    %ecx,%ebx
  801c4e:	74 1b                	je     801c6b <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801c50:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801c53:	75 cf                	jne    801c24 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801c55:	8b 42 58             	mov    0x58(%edx),%eax
  801c58:	6a 01                	push   $0x1
  801c5a:	50                   	push   %eax
  801c5b:	53                   	push   %ebx
  801c5c:	68 e3 30 80 00       	push   $0x8030e3
  801c61:	e8 63 ea ff ff       	call   8006c9 <cprintf>
  801c66:	83 c4 10             	add    $0x10,%esp
  801c69:	eb b9                	jmp    801c24 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801c6b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801c6e:	0f 94 c0             	sete   %al
  801c71:	0f b6 c0             	movzbl %al,%eax
}
  801c74:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c77:	5b                   	pop    %ebx
  801c78:	5e                   	pop    %esi
  801c79:	5f                   	pop    %edi
  801c7a:	5d                   	pop    %ebp
  801c7b:	c3                   	ret    

00801c7c <devpipe_write>:
{
  801c7c:	55                   	push   %ebp
  801c7d:	89 e5                	mov    %esp,%ebp
  801c7f:	57                   	push   %edi
  801c80:	56                   	push   %esi
  801c81:	53                   	push   %ebx
  801c82:	83 ec 28             	sub    $0x28,%esp
  801c85:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801c88:	56                   	push   %esi
  801c89:	e8 f1 f6 ff ff       	call   80137f <fd2data>
  801c8e:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801c90:	83 c4 10             	add    $0x10,%esp
  801c93:	bf 00 00 00 00       	mov    $0x0,%edi
  801c98:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801c9b:	74 4f                	je     801cec <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801c9d:	8b 43 04             	mov    0x4(%ebx),%eax
  801ca0:	8b 0b                	mov    (%ebx),%ecx
  801ca2:	8d 51 20             	lea    0x20(%ecx),%edx
  801ca5:	39 d0                	cmp    %edx,%eax
  801ca7:	72 14                	jb     801cbd <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801ca9:	89 da                	mov    %ebx,%edx
  801cab:	89 f0                	mov    %esi,%eax
  801cad:	e8 65 ff ff ff       	call   801c17 <_pipeisclosed>
  801cb2:	85 c0                	test   %eax,%eax
  801cb4:	75 3a                	jne    801cf0 <devpipe_write+0x74>
			sys_yield();
  801cb6:	e8 85 f4 ff ff       	call   801140 <sys_yield>
  801cbb:	eb e0                	jmp    801c9d <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801cbd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801cc0:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801cc4:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801cc7:	89 c2                	mov    %eax,%edx
  801cc9:	c1 fa 1f             	sar    $0x1f,%edx
  801ccc:	89 d1                	mov    %edx,%ecx
  801cce:	c1 e9 1b             	shr    $0x1b,%ecx
  801cd1:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801cd4:	83 e2 1f             	and    $0x1f,%edx
  801cd7:	29 ca                	sub    %ecx,%edx
  801cd9:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801cdd:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801ce1:	83 c0 01             	add    $0x1,%eax
  801ce4:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801ce7:	83 c7 01             	add    $0x1,%edi
  801cea:	eb ac                	jmp    801c98 <devpipe_write+0x1c>
	return i;
  801cec:	89 f8                	mov    %edi,%eax
  801cee:	eb 05                	jmp    801cf5 <devpipe_write+0x79>
				return 0;
  801cf0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cf5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801cf8:	5b                   	pop    %ebx
  801cf9:	5e                   	pop    %esi
  801cfa:	5f                   	pop    %edi
  801cfb:	5d                   	pop    %ebp
  801cfc:	c3                   	ret    

00801cfd <devpipe_read>:
{
  801cfd:	55                   	push   %ebp
  801cfe:	89 e5                	mov    %esp,%ebp
  801d00:	57                   	push   %edi
  801d01:	56                   	push   %esi
  801d02:	53                   	push   %ebx
  801d03:	83 ec 18             	sub    $0x18,%esp
  801d06:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801d09:	57                   	push   %edi
  801d0a:	e8 70 f6 ff ff       	call   80137f <fd2data>
  801d0f:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d11:	83 c4 10             	add    $0x10,%esp
  801d14:	be 00 00 00 00       	mov    $0x0,%esi
  801d19:	3b 75 10             	cmp    0x10(%ebp),%esi
  801d1c:	74 47                	je     801d65 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801d1e:	8b 03                	mov    (%ebx),%eax
  801d20:	3b 43 04             	cmp    0x4(%ebx),%eax
  801d23:	75 22                	jne    801d47 <devpipe_read+0x4a>
			if (i > 0)
  801d25:	85 f6                	test   %esi,%esi
  801d27:	75 14                	jne    801d3d <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801d29:	89 da                	mov    %ebx,%edx
  801d2b:	89 f8                	mov    %edi,%eax
  801d2d:	e8 e5 fe ff ff       	call   801c17 <_pipeisclosed>
  801d32:	85 c0                	test   %eax,%eax
  801d34:	75 33                	jne    801d69 <devpipe_read+0x6c>
			sys_yield();
  801d36:	e8 05 f4 ff ff       	call   801140 <sys_yield>
  801d3b:	eb e1                	jmp    801d1e <devpipe_read+0x21>
				return i;
  801d3d:	89 f0                	mov    %esi,%eax
}
  801d3f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d42:	5b                   	pop    %ebx
  801d43:	5e                   	pop    %esi
  801d44:	5f                   	pop    %edi
  801d45:	5d                   	pop    %ebp
  801d46:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801d47:	99                   	cltd   
  801d48:	c1 ea 1b             	shr    $0x1b,%edx
  801d4b:	01 d0                	add    %edx,%eax
  801d4d:	83 e0 1f             	and    $0x1f,%eax
  801d50:	29 d0                	sub    %edx,%eax
  801d52:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801d57:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d5a:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801d5d:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801d60:	83 c6 01             	add    $0x1,%esi
  801d63:	eb b4                	jmp    801d19 <devpipe_read+0x1c>
	return i;
  801d65:	89 f0                	mov    %esi,%eax
  801d67:	eb d6                	jmp    801d3f <devpipe_read+0x42>
				return 0;
  801d69:	b8 00 00 00 00       	mov    $0x0,%eax
  801d6e:	eb cf                	jmp    801d3f <devpipe_read+0x42>

00801d70 <pipe>:
{
  801d70:	55                   	push   %ebp
  801d71:	89 e5                	mov    %esp,%ebp
  801d73:	56                   	push   %esi
  801d74:	53                   	push   %ebx
  801d75:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801d78:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d7b:	50                   	push   %eax
  801d7c:	e8 15 f6 ff ff       	call   801396 <fd_alloc>
  801d81:	89 c3                	mov    %eax,%ebx
  801d83:	83 c4 10             	add    $0x10,%esp
  801d86:	85 c0                	test   %eax,%eax
  801d88:	78 5b                	js     801de5 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d8a:	83 ec 04             	sub    $0x4,%esp
  801d8d:	68 07 04 00 00       	push   $0x407
  801d92:	ff 75 f4             	pushl  -0xc(%ebp)
  801d95:	6a 00                	push   $0x0
  801d97:	e8 c3 f3 ff ff       	call   80115f <sys_page_alloc>
  801d9c:	89 c3                	mov    %eax,%ebx
  801d9e:	83 c4 10             	add    $0x10,%esp
  801da1:	85 c0                	test   %eax,%eax
  801da3:	78 40                	js     801de5 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  801da5:	83 ec 0c             	sub    $0xc,%esp
  801da8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801dab:	50                   	push   %eax
  801dac:	e8 e5 f5 ff ff       	call   801396 <fd_alloc>
  801db1:	89 c3                	mov    %eax,%ebx
  801db3:	83 c4 10             	add    $0x10,%esp
  801db6:	85 c0                	test   %eax,%eax
  801db8:	78 1b                	js     801dd5 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801dba:	83 ec 04             	sub    $0x4,%esp
  801dbd:	68 07 04 00 00       	push   $0x407
  801dc2:	ff 75 f0             	pushl  -0x10(%ebp)
  801dc5:	6a 00                	push   $0x0
  801dc7:	e8 93 f3 ff ff       	call   80115f <sys_page_alloc>
  801dcc:	89 c3                	mov    %eax,%ebx
  801dce:	83 c4 10             	add    $0x10,%esp
  801dd1:	85 c0                	test   %eax,%eax
  801dd3:	79 19                	jns    801dee <pipe+0x7e>
	sys_page_unmap(0, fd0);
  801dd5:	83 ec 08             	sub    $0x8,%esp
  801dd8:	ff 75 f4             	pushl  -0xc(%ebp)
  801ddb:	6a 00                	push   $0x0
  801ddd:	e8 02 f4 ff ff       	call   8011e4 <sys_page_unmap>
  801de2:	83 c4 10             	add    $0x10,%esp
}
  801de5:	89 d8                	mov    %ebx,%eax
  801de7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801dea:	5b                   	pop    %ebx
  801deb:	5e                   	pop    %esi
  801dec:	5d                   	pop    %ebp
  801ded:	c3                   	ret    
	va = fd2data(fd0);
  801dee:	83 ec 0c             	sub    $0xc,%esp
  801df1:	ff 75 f4             	pushl  -0xc(%ebp)
  801df4:	e8 86 f5 ff ff       	call   80137f <fd2data>
  801df9:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801dfb:	83 c4 0c             	add    $0xc,%esp
  801dfe:	68 07 04 00 00       	push   $0x407
  801e03:	50                   	push   %eax
  801e04:	6a 00                	push   $0x0
  801e06:	e8 54 f3 ff ff       	call   80115f <sys_page_alloc>
  801e0b:	89 c3                	mov    %eax,%ebx
  801e0d:	83 c4 10             	add    $0x10,%esp
  801e10:	85 c0                	test   %eax,%eax
  801e12:	0f 88 8c 00 00 00    	js     801ea4 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e18:	83 ec 0c             	sub    $0xc,%esp
  801e1b:	ff 75 f0             	pushl  -0x10(%ebp)
  801e1e:	e8 5c f5 ff ff       	call   80137f <fd2data>
  801e23:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801e2a:	50                   	push   %eax
  801e2b:	6a 00                	push   $0x0
  801e2d:	56                   	push   %esi
  801e2e:	6a 00                	push   $0x0
  801e30:	e8 6d f3 ff ff       	call   8011a2 <sys_page_map>
  801e35:	89 c3                	mov    %eax,%ebx
  801e37:	83 c4 20             	add    $0x20,%esp
  801e3a:	85 c0                	test   %eax,%eax
  801e3c:	78 58                	js     801e96 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801e3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e41:	8b 15 40 40 80 00    	mov    0x804040,%edx
  801e47:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801e49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e4c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801e53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e56:	8b 15 40 40 80 00    	mov    0x804040,%edx
  801e5c:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801e5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e61:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801e68:	83 ec 0c             	sub    $0xc,%esp
  801e6b:	ff 75 f4             	pushl  -0xc(%ebp)
  801e6e:	e8 fc f4 ff ff       	call   80136f <fd2num>
  801e73:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e76:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801e78:	83 c4 04             	add    $0x4,%esp
  801e7b:	ff 75 f0             	pushl  -0x10(%ebp)
  801e7e:	e8 ec f4 ff ff       	call   80136f <fd2num>
  801e83:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e86:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801e89:	83 c4 10             	add    $0x10,%esp
  801e8c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801e91:	e9 4f ff ff ff       	jmp    801de5 <pipe+0x75>
	sys_page_unmap(0, va);
  801e96:	83 ec 08             	sub    $0x8,%esp
  801e99:	56                   	push   %esi
  801e9a:	6a 00                	push   $0x0
  801e9c:	e8 43 f3 ff ff       	call   8011e4 <sys_page_unmap>
  801ea1:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801ea4:	83 ec 08             	sub    $0x8,%esp
  801ea7:	ff 75 f0             	pushl  -0x10(%ebp)
  801eaa:	6a 00                	push   $0x0
  801eac:	e8 33 f3 ff ff       	call   8011e4 <sys_page_unmap>
  801eb1:	83 c4 10             	add    $0x10,%esp
  801eb4:	e9 1c ff ff ff       	jmp    801dd5 <pipe+0x65>

00801eb9 <pipeisclosed>:
{
  801eb9:	55                   	push   %ebp
  801eba:	89 e5                	mov    %esp,%ebp
  801ebc:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ebf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ec2:	50                   	push   %eax
  801ec3:	ff 75 08             	pushl  0x8(%ebp)
  801ec6:	e8 1a f5 ff ff       	call   8013e5 <fd_lookup>
  801ecb:	83 c4 10             	add    $0x10,%esp
  801ece:	85 c0                	test   %eax,%eax
  801ed0:	78 18                	js     801eea <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801ed2:	83 ec 0c             	sub    $0xc,%esp
  801ed5:	ff 75 f4             	pushl  -0xc(%ebp)
  801ed8:	e8 a2 f4 ff ff       	call   80137f <fd2data>
	return _pipeisclosed(fd, p);
  801edd:	89 c2                	mov    %eax,%edx
  801edf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee2:	e8 30 fd ff ff       	call   801c17 <_pipeisclosed>
  801ee7:	83 c4 10             	add    $0x10,%esp
}
  801eea:	c9                   	leave  
  801eeb:	c3                   	ret    

00801eec <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801eec:	55                   	push   %ebp
  801eed:	89 e5                	mov    %esp,%ebp
  801eef:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801ef2:	68 fb 30 80 00       	push   $0x8030fb
  801ef7:	ff 75 0c             	pushl  0xc(%ebp)
  801efa:	e8 67 ee ff ff       	call   800d66 <strcpy>
	return 0;
}
  801eff:	b8 00 00 00 00       	mov    $0x0,%eax
  801f04:	c9                   	leave  
  801f05:	c3                   	ret    

00801f06 <devsock_close>:
{
  801f06:	55                   	push   %ebp
  801f07:	89 e5                	mov    %esp,%ebp
  801f09:	53                   	push   %ebx
  801f0a:	83 ec 10             	sub    $0x10,%esp
  801f0d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801f10:	53                   	push   %ebx
  801f11:	e8 39 09 00 00       	call   80284f <pageref>
  801f16:	83 c4 10             	add    $0x10,%esp
		return 0;
  801f19:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801f1e:	83 f8 01             	cmp    $0x1,%eax
  801f21:	74 07                	je     801f2a <devsock_close+0x24>
}
  801f23:	89 d0                	mov    %edx,%eax
  801f25:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f28:	c9                   	leave  
  801f29:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801f2a:	83 ec 0c             	sub    $0xc,%esp
  801f2d:	ff 73 0c             	pushl  0xc(%ebx)
  801f30:	e8 b7 02 00 00       	call   8021ec <nsipc_close>
  801f35:	89 c2                	mov    %eax,%edx
  801f37:	83 c4 10             	add    $0x10,%esp
  801f3a:	eb e7                	jmp    801f23 <devsock_close+0x1d>

00801f3c <devsock_write>:
{
  801f3c:	55                   	push   %ebp
  801f3d:	89 e5                	mov    %esp,%ebp
  801f3f:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801f42:	6a 00                	push   $0x0
  801f44:	ff 75 10             	pushl  0x10(%ebp)
  801f47:	ff 75 0c             	pushl  0xc(%ebp)
  801f4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4d:	ff 70 0c             	pushl  0xc(%eax)
  801f50:	e8 74 03 00 00       	call   8022c9 <nsipc_send>
}
  801f55:	c9                   	leave  
  801f56:	c3                   	ret    

00801f57 <devsock_read>:
{
  801f57:	55                   	push   %ebp
  801f58:	89 e5                	mov    %esp,%ebp
  801f5a:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801f5d:	6a 00                	push   $0x0
  801f5f:	ff 75 10             	pushl  0x10(%ebp)
  801f62:	ff 75 0c             	pushl  0xc(%ebp)
  801f65:	8b 45 08             	mov    0x8(%ebp),%eax
  801f68:	ff 70 0c             	pushl  0xc(%eax)
  801f6b:	e8 ed 02 00 00       	call   80225d <nsipc_recv>
}
  801f70:	c9                   	leave  
  801f71:	c3                   	ret    

00801f72 <fd2sockid>:
{
  801f72:	55                   	push   %ebp
  801f73:	89 e5                	mov    %esp,%ebp
  801f75:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801f78:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801f7b:	52                   	push   %edx
  801f7c:	50                   	push   %eax
  801f7d:	e8 63 f4 ff ff       	call   8013e5 <fd_lookup>
  801f82:	83 c4 10             	add    $0x10,%esp
  801f85:	85 c0                	test   %eax,%eax
  801f87:	78 10                	js     801f99 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801f89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f8c:	8b 0d 5c 40 80 00    	mov    0x80405c,%ecx
  801f92:	39 08                	cmp    %ecx,(%eax)
  801f94:	75 05                	jne    801f9b <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801f96:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801f99:	c9                   	leave  
  801f9a:	c3                   	ret    
		return -E_NOT_SUPP;
  801f9b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801fa0:	eb f7                	jmp    801f99 <fd2sockid+0x27>

00801fa2 <alloc_sockfd>:
{
  801fa2:	55                   	push   %ebp
  801fa3:	89 e5                	mov    %esp,%ebp
  801fa5:	56                   	push   %esi
  801fa6:	53                   	push   %ebx
  801fa7:	83 ec 1c             	sub    $0x1c,%esp
  801faa:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801fac:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801faf:	50                   	push   %eax
  801fb0:	e8 e1 f3 ff ff       	call   801396 <fd_alloc>
  801fb5:	89 c3                	mov    %eax,%ebx
  801fb7:	83 c4 10             	add    $0x10,%esp
  801fba:	85 c0                	test   %eax,%eax
  801fbc:	78 43                	js     802001 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801fbe:	83 ec 04             	sub    $0x4,%esp
  801fc1:	68 07 04 00 00       	push   $0x407
  801fc6:	ff 75 f4             	pushl  -0xc(%ebp)
  801fc9:	6a 00                	push   $0x0
  801fcb:	e8 8f f1 ff ff       	call   80115f <sys_page_alloc>
  801fd0:	89 c3                	mov    %eax,%ebx
  801fd2:	83 c4 10             	add    $0x10,%esp
  801fd5:	85 c0                	test   %eax,%eax
  801fd7:	78 28                	js     802001 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801fd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fdc:	8b 15 5c 40 80 00    	mov    0x80405c,%edx
  801fe2:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801fe4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe7:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801fee:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801ff1:	83 ec 0c             	sub    $0xc,%esp
  801ff4:	50                   	push   %eax
  801ff5:	e8 75 f3 ff ff       	call   80136f <fd2num>
  801ffa:	89 c3                	mov    %eax,%ebx
  801ffc:	83 c4 10             	add    $0x10,%esp
  801fff:	eb 0c                	jmp    80200d <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  802001:	83 ec 0c             	sub    $0xc,%esp
  802004:	56                   	push   %esi
  802005:	e8 e2 01 00 00       	call   8021ec <nsipc_close>
		return r;
  80200a:	83 c4 10             	add    $0x10,%esp
}
  80200d:	89 d8                	mov    %ebx,%eax
  80200f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802012:	5b                   	pop    %ebx
  802013:	5e                   	pop    %esi
  802014:	5d                   	pop    %ebp
  802015:	c3                   	ret    

00802016 <accept>:
{
  802016:	55                   	push   %ebp
  802017:	89 e5                	mov    %esp,%ebp
  802019:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80201c:	8b 45 08             	mov    0x8(%ebp),%eax
  80201f:	e8 4e ff ff ff       	call   801f72 <fd2sockid>
  802024:	85 c0                	test   %eax,%eax
  802026:	78 1b                	js     802043 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802028:	83 ec 04             	sub    $0x4,%esp
  80202b:	ff 75 10             	pushl  0x10(%ebp)
  80202e:	ff 75 0c             	pushl  0xc(%ebp)
  802031:	50                   	push   %eax
  802032:	e8 0e 01 00 00       	call   802145 <nsipc_accept>
  802037:	83 c4 10             	add    $0x10,%esp
  80203a:	85 c0                	test   %eax,%eax
  80203c:	78 05                	js     802043 <accept+0x2d>
	return alloc_sockfd(r);
  80203e:	e8 5f ff ff ff       	call   801fa2 <alloc_sockfd>
}
  802043:	c9                   	leave  
  802044:	c3                   	ret    

00802045 <bind>:
{
  802045:	55                   	push   %ebp
  802046:	89 e5                	mov    %esp,%ebp
  802048:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80204b:	8b 45 08             	mov    0x8(%ebp),%eax
  80204e:	e8 1f ff ff ff       	call   801f72 <fd2sockid>
  802053:	85 c0                	test   %eax,%eax
  802055:	78 12                	js     802069 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  802057:	83 ec 04             	sub    $0x4,%esp
  80205a:	ff 75 10             	pushl  0x10(%ebp)
  80205d:	ff 75 0c             	pushl  0xc(%ebp)
  802060:	50                   	push   %eax
  802061:	e8 2f 01 00 00       	call   802195 <nsipc_bind>
  802066:	83 c4 10             	add    $0x10,%esp
}
  802069:	c9                   	leave  
  80206a:	c3                   	ret    

0080206b <shutdown>:
{
  80206b:	55                   	push   %ebp
  80206c:	89 e5                	mov    %esp,%ebp
  80206e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802071:	8b 45 08             	mov    0x8(%ebp),%eax
  802074:	e8 f9 fe ff ff       	call   801f72 <fd2sockid>
  802079:	85 c0                	test   %eax,%eax
  80207b:	78 0f                	js     80208c <shutdown+0x21>
	return nsipc_shutdown(r, how);
  80207d:	83 ec 08             	sub    $0x8,%esp
  802080:	ff 75 0c             	pushl  0xc(%ebp)
  802083:	50                   	push   %eax
  802084:	e8 41 01 00 00       	call   8021ca <nsipc_shutdown>
  802089:	83 c4 10             	add    $0x10,%esp
}
  80208c:	c9                   	leave  
  80208d:	c3                   	ret    

0080208e <connect>:
{
  80208e:	55                   	push   %ebp
  80208f:	89 e5                	mov    %esp,%ebp
  802091:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802094:	8b 45 08             	mov    0x8(%ebp),%eax
  802097:	e8 d6 fe ff ff       	call   801f72 <fd2sockid>
  80209c:	85 c0                	test   %eax,%eax
  80209e:	78 12                	js     8020b2 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8020a0:	83 ec 04             	sub    $0x4,%esp
  8020a3:	ff 75 10             	pushl  0x10(%ebp)
  8020a6:	ff 75 0c             	pushl  0xc(%ebp)
  8020a9:	50                   	push   %eax
  8020aa:	e8 57 01 00 00       	call   802206 <nsipc_connect>
  8020af:	83 c4 10             	add    $0x10,%esp
}
  8020b2:	c9                   	leave  
  8020b3:	c3                   	ret    

008020b4 <listen>:
{
  8020b4:	55                   	push   %ebp
  8020b5:	89 e5                	mov    %esp,%ebp
  8020b7:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bd:	e8 b0 fe ff ff       	call   801f72 <fd2sockid>
  8020c2:	85 c0                	test   %eax,%eax
  8020c4:	78 0f                	js     8020d5 <listen+0x21>
	return nsipc_listen(r, backlog);
  8020c6:	83 ec 08             	sub    $0x8,%esp
  8020c9:	ff 75 0c             	pushl  0xc(%ebp)
  8020cc:	50                   	push   %eax
  8020cd:	e8 69 01 00 00       	call   80223b <nsipc_listen>
  8020d2:	83 c4 10             	add    $0x10,%esp
}
  8020d5:	c9                   	leave  
  8020d6:	c3                   	ret    

008020d7 <socket>:

int
socket(int domain, int type, int protocol)
{
  8020d7:	55                   	push   %ebp
  8020d8:	89 e5                	mov    %esp,%ebp
  8020da:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8020dd:	ff 75 10             	pushl  0x10(%ebp)
  8020e0:	ff 75 0c             	pushl  0xc(%ebp)
  8020e3:	ff 75 08             	pushl  0x8(%ebp)
  8020e6:	e8 3c 02 00 00       	call   802327 <nsipc_socket>
  8020eb:	83 c4 10             	add    $0x10,%esp
  8020ee:	85 c0                	test   %eax,%eax
  8020f0:	78 05                	js     8020f7 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8020f2:	e8 ab fe ff ff       	call   801fa2 <alloc_sockfd>
}
  8020f7:	c9                   	leave  
  8020f8:	c3                   	ret    

008020f9 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8020f9:	55                   	push   %ebp
  8020fa:	89 e5                	mov    %esp,%ebp
  8020fc:	53                   	push   %ebx
  8020fd:	83 ec 04             	sub    $0x4,%esp
  802100:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  802102:	83 3d 14 50 80 00 00 	cmpl   $0x0,0x805014
  802109:	74 26                	je     802131 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80210b:	6a 07                	push   $0x7
  80210d:	68 00 70 80 00       	push   $0x807000
  802112:	53                   	push   %ebx
  802113:	ff 35 14 50 80 00    	pushl  0x805014
  802119:	e8 9f 06 00 00       	call   8027bd <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  80211e:	83 c4 0c             	add    $0xc,%esp
  802121:	6a 00                	push   $0x0
  802123:	6a 00                	push   $0x0
  802125:	6a 00                	push   $0x0
  802127:	e8 28 06 00 00       	call   802754 <ipc_recv>
}
  80212c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80212f:	c9                   	leave  
  802130:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802131:	83 ec 0c             	sub    $0xc,%esp
  802134:	6a 02                	push   $0x2
  802136:	e8 db 06 00 00       	call   802816 <ipc_find_env>
  80213b:	a3 14 50 80 00       	mov    %eax,0x805014
  802140:	83 c4 10             	add    $0x10,%esp
  802143:	eb c6                	jmp    80210b <nsipc+0x12>

00802145 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802145:	55                   	push   %ebp
  802146:	89 e5                	mov    %esp,%ebp
  802148:	56                   	push   %esi
  802149:	53                   	push   %ebx
  80214a:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  80214d:	8b 45 08             	mov    0x8(%ebp),%eax
  802150:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802155:	8b 06                	mov    (%esi),%eax
  802157:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80215c:	b8 01 00 00 00       	mov    $0x1,%eax
  802161:	e8 93 ff ff ff       	call   8020f9 <nsipc>
  802166:	89 c3                	mov    %eax,%ebx
  802168:	85 c0                	test   %eax,%eax
  80216a:	78 20                	js     80218c <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80216c:	83 ec 04             	sub    $0x4,%esp
  80216f:	ff 35 10 70 80 00    	pushl  0x807010
  802175:	68 00 70 80 00       	push   $0x807000
  80217a:	ff 75 0c             	pushl  0xc(%ebp)
  80217d:	e8 72 ed ff ff       	call   800ef4 <memmove>
		*addrlen = ret->ret_addrlen;
  802182:	a1 10 70 80 00       	mov    0x807010,%eax
  802187:	89 06                	mov    %eax,(%esi)
  802189:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  80218c:	89 d8                	mov    %ebx,%eax
  80218e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802191:	5b                   	pop    %ebx
  802192:	5e                   	pop    %esi
  802193:	5d                   	pop    %ebp
  802194:	c3                   	ret    

00802195 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802195:	55                   	push   %ebp
  802196:	89 e5                	mov    %esp,%ebp
  802198:	53                   	push   %ebx
  802199:	83 ec 08             	sub    $0x8,%esp
  80219c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  80219f:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a2:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8021a7:	53                   	push   %ebx
  8021a8:	ff 75 0c             	pushl  0xc(%ebp)
  8021ab:	68 04 70 80 00       	push   $0x807004
  8021b0:	e8 3f ed ff ff       	call   800ef4 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8021b5:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  8021bb:	b8 02 00 00 00       	mov    $0x2,%eax
  8021c0:	e8 34 ff ff ff       	call   8020f9 <nsipc>
}
  8021c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021c8:	c9                   	leave  
  8021c9:	c3                   	ret    

008021ca <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8021ca:	55                   	push   %ebp
  8021cb:	89 e5                	mov    %esp,%ebp
  8021cd:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8021d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d3:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  8021d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021db:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  8021e0:	b8 03 00 00 00       	mov    $0x3,%eax
  8021e5:	e8 0f ff ff ff       	call   8020f9 <nsipc>
}
  8021ea:	c9                   	leave  
  8021eb:	c3                   	ret    

008021ec <nsipc_close>:

int
nsipc_close(int s)
{
  8021ec:	55                   	push   %ebp
  8021ed:	89 e5                	mov    %esp,%ebp
  8021ef:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8021f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f5:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8021fa:	b8 04 00 00 00       	mov    $0x4,%eax
  8021ff:	e8 f5 fe ff ff       	call   8020f9 <nsipc>
}
  802204:	c9                   	leave  
  802205:	c3                   	ret    

00802206 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802206:	55                   	push   %ebp
  802207:	89 e5                	mov    %esp,%ebp
  802209:	53                   	push   %ebx
  80220a:	83 ec 08             	sub    $0x8,%esp
  80220d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802210:	8b 45 08             	mov    0x8(%ebp),%eax
  802213:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802218:	53                   	push   %ebx
  802219:	ff 75 0c             	pushl  0xc(%ebp)
  80221c:	68 04 70 80 00       	push   $0x807004
  802221:	e8 ce ec ff ff       	call   800ef4 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802226:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  80222c:	b8 05 00 00 00       	mov    $0x5,%eax
  802231:	e8 c3 fe ff ff       	call   8020f9 <nsipc>
}
  802236:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802239:	c9                   	leave  
  80223a:	c3                   	ret    

0080223b <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80223b:	55                   	push   %ebp
  80223c:	89 e5                	mov    %esp,%ebp
  80223e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802241:	8b 45 08             	mov    0x8(%ebp),%eax
  802244:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802249:	8b 45 0c             	mov    0xc(%ebp),%eax
  80224c:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  802251:	b8 06 00 00 00       	mov    $0x6,%eax
  802256:	e8 9e fe ff ff       	call   8020f9 <nsipc>
}
  80225b:	c9                   	leave  
  80225c:	c3                   	ret    

0080225d <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80225d:	55                   	push   %ebp
  80225e:	89 e5                	mov    %esp,%ebp
  802260:	56                   	push   %esi
  802261:	53                   	push   %ebx
  802262:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802265:	8b 45 08             	mov    0x8(%ebp),%eax
  802268:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  80226d:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802273:	8b 45 14             	mov    0x14(%ebp),%eax
  802276:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80227b:	b8 07 00 00 00       	mov    $0x7,%eax
  802280:	e8 74 fe ff ff       	call   8020f9 <nsipc>
  802285:	89 c3                	mov    %eax,%ebx
  802287:	85 c0                	test   %eax,%eax
  802289:	78 1f                	js     8022aa <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  80228b:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802290:	7f 21                	jg     8022b3 <nsipc_recv+0x56>
  802292:	39 c6                	cmp    %eax,%esi
  802294:	7c 1d                	jl     8022b3 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802296:	83 ec 04             	sub    $0x4,%esp
  802299:	50                   	push   %eax
  80229a:	68 00 70 80 00       	push   $0x807000
  80229f:	ff 75 0c             	pushl  0xc(%ebp)
  8022a2:	e8 4d ec ff ff       	call   800ef4 <memmove>
  8022a7:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8022aa:	89 d8                	mov    %ebx,%eax
  8022ac:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022af:	5b                   	pop    %ebx
  8022b0:	5e                   	pop    %esi
  8022b1:	5d                   	pop    %ebp
  8022b2:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8022b3:	68 07 31 80 00       	push   $0x803107
  8022b8:	68 a9 30 80 00       	push   $0x8030a9
  8022bd:	6a 62                	push   $0x62
  8022bf:	68 1c 31 80 00       	push   $0x80311c
  8022c4:	e8 25 e3 ff ff       	call   8005ee <_panic>

008022c9 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8022c9:	55                   	push   %ebp
  8022ca:	89 e5                	mov    %esp,%ebp
  8022cc:	53                   	push   %ebx
  8022cd:	83 ec 04             	sub    $0x4,%esp
  8022d0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8022d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d6:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8022db:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8022e1:	7f 2e                	jg     802311 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8022e3:	83 ec 04             	sub    $0x4,%esp
  8022e6:	53                   	push   %ebx
  8022e7:	ff 75 0c             	pushl  0xc(%ebp)
  8022ea:	68 0c 70 80 00       	push   $0x80700c
  8022ef:	e8 00 ec ff ff       	call   800ef4 <memmove>
	nsipcbuf.send.req_size = size;
  8022f4:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8022fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8022fd:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  802302:	b8 08 00 00 00       	mov    $0x8,%eax
  802307:	e8 ed fd ff ff       	call   8020f9 <nsipc>
}
  80230c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80230f:	c9                   	leave  
  802310:	c3                   	ret    
	assert(size < 1600);
  802311:	68 28 31 80 00       	push   $0x803128
  802316:	68 a9 30 80 00       	push   $0x8030a9
  80231b:	6a 6d                	push   $0x6d
  80231d:	68 1c 31 80 00       	push   $0x80311c
  802322:	e8 c7 e2 ff ff       	call   8005ee <_panic>

00802327 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802327:	55                   	push   %ebp
  802328:	89 e5                	mov    %esp,%ebp
  80232a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80232d:	8b 45 08             	mov    0x8(%ebp),%eax
  802330:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802335:	8b 45 0c             	mov    0xc(%ebp),%eax
  802338:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  80233d:	8b 45 10             	mov    0x10(%ebp),%eax
  802340:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802345:	b8 09 00 00 00       	mov    $0x9,%eax
  80234a:	e8 aa fd ff ff       	call   8020f9 <nsipc>
}
  80234f:	c9                   	leave  
  802350:	c3                   	ret    

00802351 <free>:
	return v;
}

void
free(void *v)
{
  802351:	55                   	push   %ebp
  802352:	89 e5                	mov    %esp,%ebp
  802354:	53                   	push   %ebx
  802355:	83 ec 04             	sub    $0x4,%esp
  802358:	8b 5d 08             	mov    0x8(%ebp),%ebx
	uint8_t *c;
	uint32_t *ref;

	if (v == 0)
  80235b:	85 db                	test   %ebx,%ebx
  80235d:	0f 84 87 00 00 00    	je     8023ea <free+0x99>
		return;
	assert(mbegin <= (uint8_t*) v && (uint8_t*) v < mend);
  802363:	8d 83 00 00 00 f8    	lea    -0x8000000(%ebx),%eax
  802369:	3d ff ff ff 07       	cmp    $0x7ffffff,%eax
  80236e:	77 51                	ja     8023c1 <free+0x70>

	c = ROUNDDOWN(v, PGSIZE);
  802370:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx

	while (uvpt[PGNUM(c)] & PTE_CONTINUED) {
  802376:	89 d8                	mov    %ebx,%eax
  802378:	c1 e8 0c             	shr    $0xc,%eax
  80237b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  802382:	f6 c4 02             	test   $0x2,%ah
  802385:	74 50                	je     8023d7 <free+0x86>
		sys_page_unmap(0, c);
  802387:	83 ec 08             	sub    $0x8,%esp
  80238a:	53                   	push   %ebx
  80238b:	6a 00                	push   $0x0
  80238d:	e8 52 ee ff ff       	call   8011e4 <sys_page_unmap>
		c += PGSIZE;
  802392:	81 c3 00 10 00 00    	add    $0x1000,%ebx
		assert(mbegin <= c && c < mend);
  802398:	8d 83 00 00 00 f8    	lea    -0x8000000(%ebx),%eax
  80239e:	83 c4 10             	add    $0x10,%esp
  8023a1:	3d ff ff ff 07       	cmp    $0x7ffffff,%eax
  8023a6:	76 ce                	jbe    802376 <free+0x25>
  8023a8:	68 71 31 80 00       	push   $0x803171
  8023ad:	68 a9 30 80 00       	push   $0x8030a9
  8023b2:	68 81 00 00 00       	push   $0x81
  8023b7:	68 64 31 80 00       	push   $0x803164
  8023bc:	e8 2d e2 ff ff       	call   8005ee <_panic>
	assert(mbegin <= (uint8_t*) v && (uint8_t*) v < mend);
  8023c1:	68 34 31 80 00       	push   $0x803134
  8023c6:	68 a9 30 80 00       	push   $0x8030a9
  8023cb:	6a 7a                	push   $0x7a
  8023cd:	68 64 31 80 00       	push   $0x803164
  8023d2:	e8 17 e2 ff ff       	call   8005ee <_panic>
	/*
	 * c is just a piece of this page, so dec the ref count
	 * and maybe free the page.
	 */
	ref = (uint32_t*) (c + PGSIZE - 4);
	if (--(*ref) == 0)
  8023d7:	8b 83 fc 0f 00 00    	mov    0xffc(%ebx),%eax
  8023dd:	83 e8 01             	sub    $0x1,%eax
  8023e0:	89 83 fc 0f 00 00    	mov    %eax,0xffc(%ebx)
  8023e6:	85 c0                	test   %eax,%eax
  8023e8:	74 05                	je     8023ef <free+0x9e>
		sys_page_unmap(0, c);
}
  8023ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023ed:	c9                   	leave  
  8023ee:	c3                   	ret    
		sys_page_unmap(0, c);
  8023ef:	83 ec 08             	sub    $0x8,%esp
  8023f2:	53                   	push   %ebx
  8023f3:	6a 00                	push   $0x0
  8023f5:	e8 ea ed ff ff       	call   8011e4 <sys_page_unmap>
  8023fa:	83 c4 10             	add    $0x10,%esp
  8023fd:	eb eb                	jmp    8023ea <free+0x99>

008023ff <malloc>:
{
  8023ff:	55                   	push   %ebp
  802400:	89 e5                	mov    %esp,%ebp
  802402:	57                   	push   %edi
  802403:	56                   	push   %esi
  802404:	53                   	push   %ebx
  802405:	83 ec 1c             	sub    $0x1c,%esp
	if (mptr == 0)
  802408:	a1 18 50 80 00       	mov    0x805018,%eax
  80240d:	85 c0                	test   %eax,%eax
  80240f:	74 55                	je     802466 <malloc+0x67>
	n = ROUNDUP(n, 4);
  802411:	8b 7d 08             	mov    0x8(%ebp),%edi
  802414:	8d 57 03             	lea    0x3(%edi),%edx
  802417:	83 e2 fc             	and    $0xfffffffc,%edx
  80241a:	89 d7                	mov    %edx,%edi
  80241c:	89 55 dc             	mov    %edx,-0x24(%ebp)
	if (n >= MAXMALLOC)
  80241f:	81 fa ff ff 0f 00    	cmp    $0xfffff,%edx
  802425:	0f 87 a5 01 00 00    	ja     8025d0 <malloc+0x1d1>
	if ((uintptr_t) mptr % PGSIZE){
  80242b:	89 c2                	mov    %eax,%edx
  80242d:	a9 ff 0f 00 00       	test   $0xfff,%eax
  802432:	74 53                	je     802487 <malloc+0x88>
		if ((uintptr_t) mptr / PGSIZE == (uintptr_t) (mptr + n - 1 + 4) / PGSIZE) {
  802434:	89 c3                	mov    %eax,%ebx
  802436:	c1 eb 0c             	shr    $0xc,%ebx
  802439:	8d 4c 38 03          	lea    0x3(%eax,%edi,1),%ecx
  80243d:	c1 e9 0c             	shr    $0xc,%ecx
  802440:	39 cb                	cmp    %ecx,%ebx
  802442:	74 61                	je     8024a5 <malloc+0xa6>
		free(mptr);	/* drop reference to this page */
  802444:	83 ec 0c             	sub    $0xc,%esp
  802447:	50                   	push   %eax
  802448:	e8 04 ff ff ff       	call   802351 <free>
		mptr = ROUNDDOWN(mptr + PGSIZE, PGSIZE);
  80244d:	a1 18 50 80 00       	mov    0x805018,%eax
  802452:	05 00 10 00 00       	add    $0x1000,%eax
  802457:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80245c:	a3 18 50 80 00       	mov    %eax,0x805018
  802461:	83 c4 10             	add    $0x10,%esp
  802464:	eb 21                	jmp    802487 <malloc+0x88>
		mptr = mbegin;
  802466:	c7 05 18 50 80 00 00 	movl   $0x8000000,0x805018
  80246d:	00 00 08 
	n = ROUNDUP(n, 4);
  802470:	8b 45 08             	mov    0x8(%ebp),%eax
  802473:	83 c0 03             	add    $0x3,%eax
  802476:	83 e0 fc             	and    $0xfffffffc,%eax
  802479:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (n >= MAXMALLOC)
  80247c:	3d ff ff 0f 00       	cmp    $0xfffff,%eax
  802481:	0f 87 42 01 00 00    	ja     8025c9 <malloc+0x1ca>
  802487:	8b 35 18 50 80 00    	mov    0x805018,%esi
{
  80248d:	c7 45 d8 02 00 00 00 	movl   $0x2,-0x28(%ebp)
  802494:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
		if (isfree(mptr, n + 4))
  802498:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80249b:	8d 58 04             	lea    0x4(%eax),%ebx
  80249e:	bf 01 00 00 00       	mov    $0x1,%edi
  8024a3:	eb 66                	jmp    80250b <malloc+0x10c>
		ref = (uint32_t*) (ROUNDUP(mptr, PGSIZE) - 4);
  8024a5:	81 c2 ff 0f 00 00    	add    $0xfff,%edx
  8024ab:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
			(*ref)++;
  8024b1:	83 42 fc 01          	addl   $0x1,-0x4(%edx)
			mptr += n;
  8024b5:	01 c7                	add    %eax,%edi
  8024b7:	89 3d 18 50 80 00    	mov    %edi,0x805018
			return v;
  8024bd:	e9 ff 00 00 00       	jmp    8025c1 <malloc+0x1c2>
	for (va = (uintptr_t) v; va < end_va; va += PGSIZE)
  8024c2:	05 00 10 00 00       	add    $0x1000,%eax
  8024c7:	39 c8                	cmp    %ecx,%eax
  8024c9:	0f 83 90 00 00 00    	jae    80255f <malloc+0x160>
		if (va >= (uintptr_t) mend
  8024cf:	3d ff ff ff 0f       	cmp    $0xfffffff,%eax
  8024d4:	77 22                	ja     8024f8 <malloc+0xf9>
		    || ((uvpd[PDX(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P)))
  8024d6:	89 c2                	mov    %eax,%edx
  8024d8:	c1 ea 16             	shr    $0x16,%edx
  8024db:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8024e2:	f6 c2 01             	test   $0x1,%dl
  8024e5:	74 db                	je     8024c2 <malloc+0xc3>
  8024e7:	89 c2                	mov    %eax,%edx
  8024e9:	c1 ea 0c             	shr    $0xc,%edx
  8024ec:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8024f3:	f6 c2 01             	test   $0x1,%dl
  8024f6:	74 ca                	je     8024c2 <malloc+0xc3>
  8024f8:	81 c6 00 10 00 00    	add    $0x1000,%esi
  8024fe:	89 f8                	mov    %edi,%eax
  802500:	88 45 e7             	mov    %al,-0x19(%ebp)
		if (mptr == mend) {
  802503:	81 fe 00 00 00 10    	cmp    $0x10000000,%esi
  802509:	74 0a                	je     802515 <malloc+0x116>
  80250b:	89 75 e0             	mov    %esi,-0x20(%ebp)
  80250e:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
	for (va = (uintptr_t) v; va < end_va; va += PGSIZE)
  802511:	89 f0                	mov    %esi,%eax
  802513:	eb b2                	jmp    8024c7 <malloc+0xc8>
			mptr = mbegin;
  802515:	be 00 00 00 08       	mov    $0x8000000,%esi
  80251a:	c6 45 e7 01          	movb   $0x1,-0x19(%ebp)
			if (++nwrap == 2)
  80251e:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  802522:	75 e7                	jne    80250b <malloc+0x10c>
  802524:	c7 05 18 50 80 00 00 	movl   $0x8000000,0x805018
  80252b:	00 00 08 
				return 0;	/* out of address space */
  80252e:	b8 00 00 00 00       	mov    $0x0,%eax
  802533:	e9 89 00 00 00       	jmp    8025c1 <malloc+0x1c2>
				sys_page_unmap(0, mptr + i);
  802538:	83 ec 08             	sub    $0x8,%esp
  80253b:	89 f0                	mov    %esi,%eax
  80253d:	03 05 18 50 80 00    	add    0x805018,%eax
  802543:	50                   	push   %eax
  802544:	6a 00                	push   $0x0
  802546:	e8 99 ec ff ff       	call   8011e4 <sys_page_unmap>
			for (; i >= 0; i -= PGSIZE)
  80254b:	81 ee 00 10 00 00    	sub    $0x1000,%esi
  802551:	83 c4 10             	add    $0x10,%esp
  802554:	85 f6                	test   %esi,%esi
  802556:	79 e0                	jns    802538 <malloc+0x139>
			return 0;	/* out of physical memory */
  802558:	b8 00 00 00 00       	mov    $0x0,%eax
  80255d:	eb 62                	jmp    8025c1 <malloc+0x1c2>
  80255f:	80 7d e7 00          	cmpb   $0x0,-0x19(%ebp)
  802563:	75 3a                	jne    80259f <malloc+0x1a0>
	for (i = 0; i < n + 4; i += PGSIZE){
  802565:	be 00 00 00 00       	mov    $0x0,%esi
  80256a:	89 f2                	mov    %esi,%edx
  80256c:	39 f3                	cmp    %esi,%ebx
  80256e:	76 39                	jbe    8025a9 <malloc+0x1aa>
		cont = (i + PGSIZE < n + 4) ? PTE_CONTINUED : 0;
  802570:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
  802576:	39 df                	cmp    %ebx,%edi
  802578:	19 c0                	sbb    %eax,%eax
  80257a:	25 00 02 00 00       	and    $0x200,%eax
		if (sys_page_alloc(0, mptr + i, PTE_P|PTE_U|PTE_W|cont) < 0){
  80257f:	83 ec 04             	sub    $0x4,%esp
  802582:	83 c8 07             	or     $0x7,%eax
  802585:	50                   	push   %eax
  802586:	03 15 18 50 80 00    	add    0x805018,%edx
  80258c:	52                   	push   %edx
  80258d:	6a 00                	push   $0x0
  80258f:	e8 cb eb ff ff       	call   80115f <sys_page_alloc>
  802594:	83 c4 10             	add    $0x10,%esp
  802597:	85 c0                	test   %eax,%eax
  802599:	78 b9                	js     802554 <malloc+0x155>
	for (i = 0; i < n + 4; i += PGSIZE){
  80259b:	89 fe                	mov    %edi,%esi
  80259d:	eb cb                	jmp    80256a <malloc+0x16b>
  80259f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025a2:	a3 18 50 80 00       	mov    %eax,0x805018
  8025a7:	eb bc                	jmp    802565 <malloc+0x166>
	ref = (uint32_t*) (mptr + i - 4);
  8025a9:	a1 18 50 80 00       	mov    0x805018,%eax
	*ref = 2;	/* reference for mptr, reference for returned block */
  8025ae:	c7 44 30 fc 02 00 00 	movl   $0x2,-0x4(%eax,%esi,1)
  8025b5:	00 
	mptr += n;
  8025b6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8025b9:	01 c2                	add    %eax,%edx
  8025bb:	89 15 18 50 80 00    	mov    %edx,0x805018
}
  8025c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8025c4:	5b                   	pop    %ebx
  8025c5:	5e                   	pop    %esi
  8025c6:	5f                   	pop    %edi
  8025c7:	5d                   	pop    %ebp
  8025c8:	c3                   	ret    
		return 0;
  8025c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8025ce:	eb f1                	jmp    8025c1 <malloc+0x1c2>
  8025d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8025d5:	eb ea                	jmp    8025c1 <malloc+0x1c2>

008025d7 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8025d7:	55                   	push   %ebp
  8025d8:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8025da:	b8 00 00 00 00       	mov    $0x0,%eax
  8025df:	5d                   	pop    %ebp
  8025e0:	c3                   	ret    

008025e1 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8025e1:	55                   	push   %ebp
  8025e2:	89 e5                	mov    %esp,%ebp
  8025e4:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8025e7:	68 89 31 80 00       	push   $0x803189
  8025ec:	ff 75 0c             	pushl  0xc(%ebp)
  8025ef:	e8 72 e7 ff ff       	call   800d66 <strcpy>
	return 0;
}
  8025f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8025f9:	c9                   	leave  
  8025fa:	c3                   	ret    

008025fb <devcons_write>:
{
  8025fb:	55                   	push   %ebp
  8025fc:	89 e5                	mov    %esp,%ebp
  8025fe:	57                   	push   %edi
  8025ff:	56                   	push   %esi
  802600:	53                   	push   %ebx
  802601:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802607:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80260c:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802612:	eb 2f                	jmp    802643 <devcons_write+0x48>
		m = n - tot;
  802614:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802617:	29 f3                	sub    %esi,%ebx
  802619:	83 fb 7f             	cmp    $0x7f,%ebx
  80261c:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802621:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802624:	83 ec 04             	sub    $0x4,%esp
  802627:	53                   	push   %ebx
  802628:	89 f0                	mov    %esi,%eax
  80262a:	03 45 0c             	add    0xc(%ebp),%eax
  80262d:	50                   	push   %eax
  80262e:	57                   	push   %edi
  80262f:	e8 c0 e8 ff ff       	call   800ef4 <memmove>
		sys_cputs(buf, m);
  802634:	83 c4 08             	add    $0x8,%esp
  802637:	53                   	push   %ebx
  802638:	57                   	push   %edi
  802639:	e8 65 ea ff ff       	call   8010a3 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80263e:	01 de                	add    %ebx,%esi
  802640:	83 c4 10             	add    $0x10,%esp
  802643:	3b 75 10             	cmp    0x10(%ebp),%esi
  802646:	72 cc                	jb     802614 <devcons_write+0x19>
}
  802648:	89 f0                	mov    %esi,%eax
  80264a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80264d:	5b                   	pop    %ebx
  80264e:	5e                   	pop    %esi
  80264f:	5f                   	pop    %edi
  802650:	5d                   	pop    %ebp
  802651:	c3                   	ret    

00802652 <devcons_read>:
{
  802652:	55                   	push   %ebp
  802653:	89 e5                	mov    %esp,%ebp
  802655:	83 ec 08             	sub    $0x8,%esp
  802658:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80265d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802661:	75 07                	jne    80266a <devcons_read+0x18>
}
  802663:	c9                   	leave  
  802664:	c3                   	ret    
		sys_yield();
  802665:	e8 d6 ea ff ff       	call   801140 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  80266a:	e8 52 ea ff ff       	call   8010c1 <sys_cgetc>
  80266f:	85 c0                	test   %eax,%eax
  802671:	74 f2                	je     802665 <devcons_read+0x13>
	if (c < 0)
  802673:	85 c0                	test   %eax,%eax
  802675:	78 ec                	js     802663 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  802677:	83 f8 04             	cmp    $0x4,%eax
  80267a:	74 0c                	je     802688 <devcons_read+0x36>
	*(char*)vbuf = c;
  80267c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80267f:	88 02                	mov    %al,(%edx)
	return 1;
  802681:	b8 01 00 00 00       	mov    $0x1,%eax
  802686:	eb db                	jmp    802663 <devcons_read+0x11>
		return 0;
  802688:	b8 00 00 00 00       	mov    $0x0,%eax
  80268d:	eb d4                	jmp    802663 <devcons_read+0x11>

0080268f <cputchar>:
{
  80268f:	55                   	push   %ebp
  802690:	89 e5                	mov    %esp,%ebp
  802692:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802695:	8b 45 08             	mov    0x8(%ebp),%eax
  802698:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80269b:	6a 01                	push   $0x1
  80269d:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8026a0:	50                   	push   %eax
  8026a1:	e8 fd e9 ff ff       	call   8010a3 <sys_cputs>
}
  8026a6:	83 c4 10             	add    $0x10,%esp
  8026a9:	c9                   	leave  
  8026aa:	c3                   	ret    

008026ab <getchar>:
{
  8026ab:	55                   	push   %ebp
  8026ac:	89 e5                	mov    %esp,%ebp
  8026ae:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8026b1:	6a 01                	push   $0x1
  8026b3:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8026b6:	50                   	push   %eax
  8026b7:	6a 00                	push   $0x0
  8026b9:	e8 98 ef ff ff       	call   801656 <read>
	if (r < 0)
  8026be:	83 c4 10             	add    $0x10,%esp
  8026c1:	85 c0                	test   %eax,%eax
  8026c3:	78 08                	js     8026cd <getchar+0x22>
	if (r < 1)
  8026c5:	85 c0                	test   %eax,%eax
  8026c7:	7e 06                	jle    8026cf <getchar+0x24>
	return c;
  8026c9:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8026cd:	c9                   	leave  
  8026ce:	c3                   	ret    
		return -E_EOF;
  8026cf:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8026d4:	eb f7                	jmp    8026cd <getchar+0x22>

008026d6 <iscons>:
{
  8026d6:	55                   	push   %ebp
  8026d7:	89 e5                	mov    %esp,%ebp
  8026d9:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8026dc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8026df:	50                   	push   %eax
  8026e0:	ff 75 08             	pushl  0x8(%ebp)
  8026e3:	e8 fd ec ff ff       	call   8013e5 <fd_lookup>
  8026e8:	83 c4 10             	add    $0x10,%esp
  8026eb:	85 c0                	test   %eax,%eax
  8026ed:	78 11                	js     802700 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8026ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f2:	8b 15 78 40 80 00    	mov    0x804078,%edx
  8026f8:	39 10                	cmp    %edx,(%eax)
  8026fa:	0f 94 c0             	sete   %al
  8026fd:	0f b6 c0             	movzbl %al,%eax
}
  802700:	c9                   	leave  
  802701:	c3                   	ret    

00802702 <opencons>:
{
  802702:	55                   	push   %ebp
  802703:	89 e5                	mov    %esp,%ebp
  802705:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802708:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80270b:	50                   	push   %eax
  80270c:	e8 85 ec ff ff       	call   801396 <fd_alloc>
  802711:	83 c4 10             	add    $0x10,%esp
  802714:	85 c0                	test   %eax,%eax
  802716:	78 3a                	js     802752 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802718:	83 ec 04             	sub    $0x4,%esp
  80271b:	68 07 04 00 00       	push   $0x407
  802720:	ff 75 f4             	pushl  -0xc(%ebp)
  802723:	6a 00                	push   $0x0
  802725:	e8 35 ea ff ff       	call   80115f <sys_page_alloc>
  80272a:	83 c4 10             	add    $0x10,%esp
  80272d:	85 c0                	test   %eax,%eax
  80272f:	78 21                	js     802752 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802731:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802734:	8b 15 78 40 80 00    	mov    0x804078,%edx
  80273a:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80273c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802746:	83 ec 0c             	sub    $0xc,%esp
  802749:	50                   	push   %eax
  80274a:	e8 20 ec ff ff       	call   80136f <fd2num>
  80274f:	83 c4 10             	add    $0x10,%esp
}
  802752:	c9                   	leave  
  802753:	c3                   	ret    

00802754 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802754:	55                   	push   %ebp
  802755:	89 e5                	mov    %esp,%ebp
  802757:	56                   	push   %esi
  802758:	53                   	push   %ebx
  802759:	8b 75 08             	mov    0x8(%ebp),%esi
  80275c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80275f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
  802762:	85 c0                	test   %eax,%eax
	    pg = (void *)UTOP;
  802764:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802769:	0f 44 c2             	cmove  %edx,%eax
	}
	if ((r = sys_ipc_recv(pg)) < 0) {
  80276c:	83 ec 0c             	sub    $0xc,%esp
  80276f:	50                   	push   %eax
  802770:	e8 9a eb ff ff       	call   80130f <sys_ipc_recv>
  802775:	83 c4 10             	add    $0x10,%esp
  802778:	85 c0                	test   %eax,%eax
  80277a:	78 2b                	js     8027a7 <ipc_recv+0x53>
	    if (perm_store != NULL) {
	        *perm_store = 0;
	    }
	    return r;
	}
	if (from_env_store != NULL) {
  80277c:	85 f6                	test   %esi,%esi
  80277e:	74 0a                	je     80278a <ipc_recv+0x36>
	    *from_env_store = thisenv->env_ipc_from;
  802780:	a1 1c 50 80 00       	mov    0x80501c,%eax
  802785:	8b 40 74             	mov    0x74(%eax),%eax
  802788:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store != NULL) {
  80278a:	85 db                	test   %ebx,%ebx
  80278c:	74 0a                	je     802798 <ipc_recv+0x44>
	    *perm_store = thisenv->env_ipc_perm;
  80278e:	a1 1c 50 80 00       	mov    0x80501c,%eax
  802793:	8b 40 78             	mov    0x78(%eax),%eax
  802796:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  802798:	a1 1c 50 80 00       	mov    0x80501c,%eax
  80279d:	8b 40 70             	mov    0x70(%eax),%eax
}
  8027a0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8027a3:	5b                   	pop    %ebx
  8027a4:	5e                   	pop    %esi
  8027a5:	5d                   	pop    %ebp
  8027a6:	c3                   	ret    
	    if (from_env_store != NULL) {
  8027a7:	85 f6                	test   %esi,%esi
  8027a9:	74 06                	je     8027b1 <ipc_recv+0x5d>
	        *from_env_store = 0;
  8027ab:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	    if (perm_store != NULL) {
  8027b1:	85 db                	test   %ebx,%ebx
  8027b3:	74 eb                	je     8027a0 <ipc_recv+0x4c>
	        *perm_store = 0;
  8027b5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8027bb:	eb e3                	jmp    8027a0 <ipc_recv+0x4c>

008027bd <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8027bd:	55                   	push   %ebp
  8027be:	89 e5                	mov    %esp,%ebp
  8027c0:	57                   	push   %edi
  8027c1:	56                   	push   %esi
  8027c2:	53                   	push   %ebx
  8027c3:	83 ec 0c             	sub    $0xc,%esp
  8027c6:	8b 7d 08             	mov    0x8(%ebp),%edi
  8027c9:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
	    pg = (void *)UTOP;
  8027cc:	85 f6                	test   %esi,%esi
  8027ce:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8027d3:	0f 44 f0             	cmove  %eax,%esi
  8027d6:	eb 09                	jmp    8027e1 <ipc_send+0x24>
	do {
	    r = sys_ipc_try_send(to_env, val, pg, perm);
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
	        panic("ipc_send: %e", r);
	    }
	    sys_yield();
  8027d8:	e8 63 e9 ff ff       	call   801140 <sys_yield>
	} while(r != 0);
  8027dd:	85 db                	test   %ebx,%ebx
  8027df:	74 2d                	je     80280e <ipc_send+0x51>
	    r = sys_ipc_try_send(to_env, val, pg, perm);
  8027e1:	ff 75 14             	pushl  0x14(%ebp)
  8027e4:	56                   	push   %esi
  8027e5:	ff 75 0c             	pushl  0xc(%ebp)
  8027e8:	57                   	push   %edi
  8027e9:	e8 fe ea ff ff       	call   8012ec <sys_ipc_try_send>
  8027ee:	89 c3                	mov    %eax,%ebx
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
  8027f0:	83 c4 10             	add    $0x10,%esp
  8027f3:	85 c0                	test   %eax,%eax
  8027f5:	79 e1                	jns    8027d8 <ipc_send+0x1b>
  8027f7:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8027fa:	74 dc                	je     8027d8 <ipc_send+0x1b>
	        panic("ipc_send: %e", r);
  8027fc:	50                   	push   %eax
  8027fd:	68 95 31 80 00       	push   $0x803195
  802802:	6a 45                	push   $0x45
  802804:	68 a2 31 80 00       	push   $0x8031a2
  802809:	e8 e0 dd ff ff       	call   8005ee <_panic>
}
  80280e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802811:	5b                   	pop    %ebx
  802812:	5e                   	pop    %esi
  802813:	5f                   	pop    %edi
  802814:	5d                   	pop    %ebp
  802815:	c3                   	ret    

00802816 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802816:	55                   	push   %ebp
  802817:	89 e5                	mov    %esp,%ebp
  802819:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80281c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802821:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802824:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80282a:	8b 52 50             	mov    0x50(%edx),%edx
  80282d:	39 ca                	cmp    %ecx,%edx
  80282f:	74 11                	je     802842 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  802831:	83 c0 01             	add    $0x1,%eax
  802834:	3d 00 04 00 00       	cmp    $0x400,%eax
  802839:	75 e6                	jne    802821 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80283b:	b8 00 00 00 00       	mov    $0x0,%eax
  802840:	eb 0b                	jmp    80284d <ipc_find_env+0x37>
			return envs[i].env_id;
  802842:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802845:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80284a:	8b 40 48             	mov    0x48(%eax),%eax
}
  80284d:	5d                   	pop    %ebp
  80284e:	c3                   	ret    

0080284f <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80284f:	55                   	push   %ebp
  802850:	89 e5                	mov    %esp,%ebp
  802852:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802855:	89 d0                	mov    %edx,%eax
  802857:	c1 e8 16             	shr    $0x16,%eax
  80285a:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802861:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802866:	f6 c1 01             	test   $0x1,%cl
  802869:	74 1d                	je     802888 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80286b:	c1 ea 0c             	shr    $0xc,%edx
  80286e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802875:	f6 c2 01             	test   $0x1,%dl
  802878:	74 0e                	je     802888 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80287a:	c1 ea 0c             	shr    $0xc,%edx
  80287d:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802884:	ef 
  802885:	0f b7 c0             	movzwl %ax,%eax
}
  802888:	5d                   	pop    %ebp
  802889:	c3                   	ret    
  80288a:	66 90                	xchg   %ax,%ax
  80288c:	66 90                	xchg   %ax,%ax
  80288e:	66 90                	xchg   %ax,%ax

00802890 <__udivdi3>:
  802890:	55                   	push   %ebp
  802891:	57                   	push   %edi
  802892:	56                   	push   %esi
  802893:	53                   	push   %ebx
  802894:	83 ec 1c             	sub    $0x1c,%esp
  802897:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80289b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80289f:	8b 74 24 34          	mov    0x34(%esp),%esi
  8028a3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8028a7:	85 d2                	test   %edx,%edx
  8028a9:	75 35                	jne    8028e0 <__udivdi3+0x50>
  8028ab:	39 f3                	cmp    %esi,%ebx
  8028ad:	0f 87 bd 00 00 00    	ja     802970 <__udivdi3+0xe0>
  8028b3:	85 db                	test   %ebx,%ebx
  8028b5:	89 d9                	mov    %ebx,%ecx
  8028b7:	75 0b                	jne    8028c4 <__udivdi3+0x34>
  8028b9:	b8 01 00 00 00       	mov    $0x1,%eax
  8028be:	31 d2                	xor    %edx,%edx
  8028c0:	f7 f3                	div    %ebx
  8028c2:	89 c1                	mov    %eax,%ecx
  8028c4:	31 d2                	xor    %edx,%edx
  8028c6:	89 f0                	mov    %esi,%eax
  8028c8:	f7 f1                	div    %ecx
  8028ca:	89 c6                	mov    %eax,%esi
  8028cc:	89 e8                	mov    %ebp,%eax
  8028ce:	89 f7                	mov    %esi,%edi
  8028d0:	f7 f1                	div    %ecx
  8028d2:	89 fa                	mov    %edi,%edx
  8028d4:	83 c4 1c             	add    $0x1c,%esp
  8028d7:	5b                   	pop    %ebx
  8028d8:	5e                   	pop    %esi
  8028d9:	5f                   	pop    %edi
  8028da:	5d                   	pop    %ebp
  8028db:	c3                   	ret    
  8028dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8028e0:	39 f2                	cmp    %esi,%edx
  8028e2:	77 7c                	ja     802960 <__udivdi3+0xd0>
  8028e4:	0f bd fa             	bsr    %edx,%edi
  8028e7:	83 f7 1f             	xor    $0x1f,%edi
  8028ea:	0f 84 98 00 00 00    	je     802988 <__udivdi3+0xf8>
  8028f0:	89 f9                	mov    %edi,%ecx
  8028f2:	b8 20 00 00 00       	mov    $0x20,%eax
  8028f7:	29 f8                	sub    %edi,%eax
  8028f9:	d3 e2                	shl    %cl,%edx
  8028fb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8028ff:	89 c1                	mov    %eax,%ecx
  802901:	89 da                	mov    %ebx,%edx
  802903:	d3 ea                	shr    %cl,%edx
  802905:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802909:	09 d1                	or     %edx,%ecx
  80290b:	89 f2                	mov    %esi,%edx
  80290d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802911:	89 f9                	mov    %edi,%ecx
  802913:	d3 e3                	shl    %cl,%ebx
  802915:	89 c1                	mov    %eax,%ecx
  802917:	d3 ea                	shr    %cl,%edx
  802919:	89 f9                	mov    %edi,%ecx
  80291b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80291f:	d3 e6                	shl    %cl,%esi
  802921:	89 eb                	mov    %ebp,%ebx
  802923:	89 c1                	mov    %eax,%ecx
  802925:	d3 eb                	shr    %cl,%ebx
  802927:	09 de                	or     %ebx,%esi
  802929:	89 f0                	mov    %esi,%eax
  80292b:	f7 74 24 08          	divl   0x8(%esp)
  80292f:	89 d6                	mov    %edx,%esi
  802931:	89 c3                	mov    %eax,%ebx
  802933:	f7 64 24 0c          	mull   0xc(%esp)
  802937:	39 d6                	cmp    %edx,%esi
  802939:	72 0c                	jb     802947 <__udivdi3+0xb7>
  80293b:	89 f9                	mov    %edi,%ecx
  80293d:	d3 e5                	shl    %cl,%ebp
  80293f:	39 c5                	cmp    %eax,%ebp
  802941:	73 5d                	jae    8029a0 <__udivdi3+0x110>
  802943:	39 d6                	cmp    %edx,%esi
  802945:	75 59                	jne    8029a0 <__udivdi3+0x110>
  802947:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80294a:	31 ff                	xor    %edi,%edi
  80294c:	89 fa                	mov    %edi,%edx
  80294e:	83 c4 1c             	add    $0x1c,%esp
  802951:	5b                   	pop    %ebx
  802952:	5e                   	pop    %esi
  802953:	5f                   	pop    %edi
  802954:	5d                   	pop    %ebp
  802955:	c3                   	ret    
  802956:	8d 76 00             	lea    0x0(%esi),%esi
  802959:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  802960:	31 ff                	xor    %edi,%edi
  802962:	31 c0                	xor    %eax,%eax
  802964:	89 fa                	mov    %edi,%edx
  802966:	83 c4 1c             	add    $0x1c,%esp
  802969:	5b                   	pop    %ebx
  80296a:	5e                   	pop    %esi
  80296b:	5f                   	pop    %edi
  80296c:	5d                   	pop    %ebp
  80296d:	c3                   	ret    
  80296e:	66 90                	xchg   %ax,%ax
  802970:	31 ff                	xor    %edi,%edi
  802972:	89 e8                	mov    %ebp,%eax
  802974:	89 f2                	mov    %esi,%edx
  802976:	f7 f3                	div    %ebx
  802978:	89 fa                	mov    %edi,%edx
  80297a:	83 c4 1c             	add    $0x1c,%esp
  80297d:	5b                   	pop    %ebx
  80297e:	5e                   	pop    %esi
  80297f:	5f                   	pop    %edi
  802980:	5d                   	pop    %ebp
  802981:	c3                   	ret    
  802982:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802988:	39 f2                	cmp    %esi,%edx
  80298a:	72 06                	jb     802992 <__udivdi3+0x102>
  80298c:	31 c0                	xor    %eax,%eax
  80298e:	39 eb                	cmp    %ebp,%ebx
  802990:	77 d2                	ja     802964 <__udivdi3+0xd4>
  802992:	b8 01 00 00 00       	mov    $0x1,%eax
  802997:	eb cb                	jmp    802964 <__udivdi3+0xd4>
  802999:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8029a0:	89 d8                	mov    %ebx,%eax
  8029a2:	31 ff                	xor    %edi,%edi
  8029a4:	eb be                	jmp    802964 <__udivdi3+0xd4>
  8029a6:	66 90                	xchg   %ax,%ax
  8029a8:	66 90                	xchg   %ax,%ax
  8029aa:	66 90                	xchg   %ax,%ax
  8029ac:	66 90                	xchg   %ax,%ax
  8029ae:	66 90                	xchg   %ax,%ax

008029b0 <__umoddi3>:
  8029b0:	55                   	push   %ebp
  8029b1:	57                   	push   %edi
  8029b2:	56                   	push   %esi
  8029b3:	53                   	push   %ebx
  8029b4:	83 ec 1c             	sub    $0x1c,%esp
  8029b7:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  8029bb:	8b 74 24 30          	mov    0x30(%esp),%esi
  8029bf:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8029c3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8029c7:	85 ed                	test   %ebp,%ebp
  8029c9:	89 f0                	mov    %esi,%eax
  8029cb:	89 da                	mov    %ebx,%edx
  8029cd:	75 19                	jne    8029e8 <__umoddi3+0x38>
  8029cf:	39 df                	cmp    %ebx,%edi
  8029d1:	0f 86 b1 00 00 00    	jbe    802a88 <__umoddi3+0xd8>
  8029d7:	f7 f7                	div    %edi
  8029d9:	89 d0                	mov    %edx,%eax
  8029db:	31 d2                	xor    %edx,%edx
  8029dd:	83 c4 1c             	add    $0x1c,%esp
  8029e0:	5b                   	pop    %ebx
  8029e1:	5e                   	pop    %esi
  8029e2:	5f                   	pop    %edi
  8029e3:	5d                   	pop    %ebp
  8029e4:	c3                   	ret    
  8029e5:	8d 76 00             	lea    0x0(%esi),%esi
  8029e8:	39 dd                	cmp    %ebx,%ebp
  8029ea:	77 f1                	ja     8029dd <__umoddi3+0x2d>
  8029ec:	0f bd cd             	bsr    %ebp,%ecx
  8029ef:	83 f1 1f             	xor    $0x1f,%ecx
  8029f2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8029f6:	0f 84 b4 00 00 00    	je     802ab0 <__umoddi3+0x100>
  8029fc:	b8 20 00 00 00       	mov    $0x20,%eax
  802a01:	89 c2                	mov    %eax,%edx
  802a03:	8b 44 24 04          	mov    0x4(%esp),%eax
  802a07:	29 c2                	sub    %eax,%edx
  802a09:	89 c1                	mov    %eax,%ecx
  802a0b:	89 f8                	mov    %edi,%eax
  802a0d:	d3 e5                	shl    %cl,%ebp
  802a0f:	89 d1                	mov    %edx,%ecx
  802a11:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802a15:	d3 e8                	shr    %cl,%eax
  802a17:	09 c5                	or     %eax,%ebp
  802a19:	8b 44 24 04          	mov    0x4(%esp),%eax
  802a1d:	89 c1                	mov    %eax,%ecx
  802a1f:	d3 e7                	shl    %cl,%edi
  802a21:	89 d1                	mov    %edx,%ecx
  802a23:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802a27:	89 df                	mov    %ebx,%edi
  802a29:	d3 ef                	shr    %cl,%edi
  802a2b:	89 c1                	mov    %eax,%ecx
  802a2d:	89 f0                	mov    %esi,%eax
  802a2f:	d3 e3                	shl    %cl,%ebx
  802a31:	89 d1                	mov    %edx,%ecx
  802a33:	89 fa                	mov    %edi,%edx
  802a35:	d3 e8                	shr    %cl,%eax
  802a37:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802a3c:	09 d8                	or     %ebx,%eax
  802a3e:	f7 f5                	div    %ebp
  802a40:	d3 e6                	shl    %cl,%esi
  802a42:	89 d1                	mov    %edx,%ecx
  802a44:	f7 64 24 08          	mull   0x8(%esp)
  802a48:	39 d1                	cmp    %edx,%ecx
  802a4a:	89 c3                	mov    %eax,%ebx
  802a4c:	89 d7                	mov    %edx,%edi
  802a4e:	72 06                	jb     802a56 <__umoddi3+0xa6>
  802a50:	75 0e                	jne    802a60 <__umoddi3+0xb0>
  802a52:	39 c6                	cmp    %eax,%esi
  802a54:	73 0a                	jae    802a60 <__umoddi3+0xb0>
  802a56:	2b 44 24 08          	sub    0x8(%esp),%eax
  802a5a:	19 ea                	sbb    %ebp,%edx
  802a5c:	89 d7                	mov    %edx,%edi
  802a5e:	89 c3                	mov    %eax,%ebx
  802a60:	89 ca                	mov    %ecx,%edx
  802a62:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  802a67:	29 de                	sub    %ebx,%esi
  802a69:	19 fa                	sbb    %edi,%edx
  802a6b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  802a6f:	89 d0                	mov    %edx,%eax
  802a71:	d3 e0                	shl    %cl,%eax
  802a73:	89 d9                	mov    %ebx,%ecx
  802a75:	d3 ee                	shr    %cl,%esi
  802a77:	d3 ea                	shr    %cl,%edx
  802a79:	09 f0                	or     %esi,%eax
  802a7b:	83 c4 1c             	add    $0x1c,%esp
  802a7e:	5b                   	pop    %ebx
  802a7f:	5e                   	pop    %esi
  802a80:	5f                   	pop    %edi
  802a81:	5d                   	pop    %ebp
  802a82:	c3                   	ret    
  802a83:	90                   	nop
  802a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802a88:	85 ff                	test   %edi,%edi
  802a8a:	89 f9                	mov    %edi,%ecx
  802a8c:	75 0b                	jne    802a99 <__umoddi3+0xe9>
  802a8e:	b8 01 00 00 00       	mov    $0x1,%eax
  802a93:	31 d2                	xor    %edx,%edx
  802a95:	f7 f7                	div    %edi
  802a97:	89 c1                	mov    %eax,%ecx
  802a99:	89 d8                	mov    %ebx,%eax
  802a9b:	31 d2                	xor    %edx,%edx
  802a9d:	f7 f1                	div    %ecx
  802a9f:	89 f0                	mov    %esi,%eax
  802aa1:	f7 f1                	div    %ecx
  802aa3:	e9 31 ff ff ff       	jmp    8029d9 <__umoddi3+0x29>
  802aa8:	90                   	nop
  802aa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802ab0:	39 dd                	cmp    %ebx,%ebp
  802ab2:	72 08                	jb     802abc <__umoddi3+0x10c>
  802ab4:	39 f7                	cmp    %esi,%edi
  802ab6:	0f 87 21 ff ff ff    	ja     8029dd <__umoddi3+0x2d>
  802abc:	89 da                	mov    %ebx,%edx
  802abe:	89 f0                	mov    %esi,%eax
  802ac0:	29 f8                	sub    %edi,%eax
  802ac2:	19 ea                	sbb    %ebp,%edx
  802ac4:	e9 14 ff ff ff       	jmp    8029dd <__umoddi3+0x2d>
