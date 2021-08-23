
obj/net/testinput:     file format elf32-i386


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
  80002c:	e8 0e 07 00 00       	call   80073f <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
	}
}

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 7c             	sub    $0x7c,%esp
	envid_t ns_envid = sys_getenvid();
  80003c:	e8 91 12 00 00       	call   8012d2 <sys_getenvid>
  800041:	89 c3                	mov    %eax,%ebx
	int i, r, first = 1;

	binaryname = "testinput";
  800043:	c7 05 00 40 80 00 c0 	movl   $0x802dc0,0x804000
  80004a:	2d 80 00 

	output_envid = fork();
  80004d:	e8 b8 15 00 00       	call   80160a <fork>
  800052:	a3 04 50 80 00       	mov    %eax,0x805004
	if (output_envid < 0)
  800057:	85 c0                	test   %eax,%eax
  800059:	78 18                	js     800073 <umain+0x40>
		panic("error forking");
	else if (output_envid == 0) {
  80005b:	85 c0                	test   %eax,%eax
  80005d:	75 28                	jne    800087 <umain+0x54>
		output(ns_envid);
  80005f:	83 ec 0c             	sub    $0xc,%esp
  800062:	53                   	push   %ebx
  800063:	e8 ea 03 00 00       	call   800452 <output>
		return;
  800068:	83 c4 10             	add    $0x10,%esp
		// we've received the ARP reply
		if (first)
			cprintf("Waiting for packets...\n");
		first = 0;
	}
}
  80006b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80006e:	5b                   	pop    %ebx
  80006f:	5e                   	pop    %esi
  800070:	5f                   	pop    %edi
  800071:	5d                   	pop    %ebp
  800072:	c3                   	ret    
		panic("error forking");
  800073:	83 ec 04             	sub    $0x4,%esp
  800076:	68 ca 2d 80 00       	push   $0x802dca
  80007b:	6a 4d                	push   $0x4d
  80007d:	68 d8 2d 80 00       	push   $0x802dd8
  800082:	e8 18 07 00 00       	call   80079f <_panic>
	input_envid = fork();
  800087:	e8 7e 15 00 00       	call   80160a <fork>
  80008c:	a3 00 50 80 00       	mov    %eax,0x805000
	if (input_envid < 0)
  800091:	85 c0                	test   %eax,%eax
  800093:	0f 88 6e 01 00 00    	js     800207 <umain+0x1d4>
	else if (input_envid == 0) {
  800099:	85 c0                	test   %eax,%eax
  80009b:	0f 84 7a 01 00 00    	je     80021b <umain+0x1e8>
	cprintf("Sending ARP announcement...\n");
  8000a1:	83 ec 0c             	sub    $0xc,%esp
  8000a4:	68 e8 2d 80 00       	push   $0x802de8
  8000a9:	e8 cc 07 00 00       	call   80087a <cprintf>
	uint8_t mac[6] = {0x52, 0x54, 0x00, 0x12, 0x34, 0x56};
  8000ae:	c6 45 98 52          	movb   $0x52,-0x68(%ebp)
  8000b2:	c6 45 99 54          	movb   $0x54,-0x67(%ebp)
  8000b6:	c6 45 9a 00          	movb   $0x0,-0x66(%ebp)
  8000ba:	c6 45 9b 12          	movb   $0x12,-0x65(%ebp)
  8000be:	c6 45 9c 34          	movb   $0x34,-0x64(%ebp)
  8000c2:	c6 45 9d 56          	movb   $0x56,-0x63(%ebp)
	uint32_t myip = inet_addr(IP);
  8000c6:	c7 04 24 05 2e 80 00 	movl   $0x802e05,(%esp)
  8000cd:	e8 3b 06 00 00       	call   80070d <inet_addr>
  8000d2:	89 45 90             	mov    %eax,-0x70(%ebp)
	uint32_t gwip = inet_addr(DEFAULT);
  8000d5:	c7 04 24 0f 2e 80 00 	movl   $0x802e0f,(%esp)
  8000dc:	e8 2c 06 00 00       	call   80070d <inet_addr>
  8000e1:	89 45 94             	mov    %eax,-0x6c(%ebp)
	if ((r = sys_page_alloc(0, pkt, PTE_P|PTE_U|PTE_W)) < 0)
  8000e4:	83 c4 0c             	add    $0xc,%esp
  8000e7:	6a 07                	push   $0x7
  8000e9:	68 00 b0 fe 0f       	push   $0xffeb000
  8000ee:	6a 00                	push   $0x0
  8000f0:	e8 1b 12 00 00       	call   801310 <sys_page_alloc>
  8000f5:	83 c4 10             	add    $0x10,%esp
  8000f8:	85 c0                	test   %eax,%eax
  8000fa:	0f 88 2c 01 00 00    	js     80022c <umain+0x1f9>
	pkt->jp_len = sizeof(*arp);
  800100:	c7 05 00 b0 fe 0f 2a 	movl   $0x2a,0xffeb000
  800107:	00 00 00 
	memset(arp->ethhdr.dest.addr, 0xff, ETHARP_HWADDR_LEN);
  80010a:	83 ec 04             	sub    $0x4,%esp
  80010d:	6a 06                	push   $0x6
  80010f:	68 ff 00 00 00       	push   $0xff
  800114:	68 04 b0 fe 0f       	push   $0xffeb004
  800119:	e8 3a 0f 00 00       	call   801058 <memset>
	memcpy(arp->ethhdr.src.addr,  mac,  ETHARP_HWADDR_LEN);
  80011e:	83 c4 0c             	add    $0xc,%esp
  800121:	6a 06                	push   $0x6
  800123:	8d 5d 98             	lea    -0x68(%ebp),%ebx
  800126:	53                   	push   %ebx
  800127:	68 0a b0 fe 0f       	push   $0xffeb00a
  80012c:	e8 dc 0f 00 00       	call   80110d <memcpy>
	arp->ethhdr.type = htons(ETHTYPE_ARP);
  800131:	c7 04 24 06 08 00 00 	movl   $0x806,(%esp)
  800138:	e8 ba 03 00 00       	call   8004f7 <htons>
  80013d:	66 a3 10 b0 fe 0f    	mov    %ax,0xffeb010
	arp->hwtype = htons(1); // Ethernet
  800143:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80014a:	e8 a8 03 00 00       	call   8004f7 <htons>
  80014f:	66 a3 12 b0 fe 0f    	mov    %ax,0xffeb012
	arp->proto = htons(ETHTYPE_IP);
  800155:	c7 04 24 00 08 00 00 	movl   $0x800,(%esp)
  80015c:	e8 96 03 00 00       	call   8004f7 <htons>
  800161:	66 a3 14 b0 fe 0f    	mov    %ax,0xffeb014
	arp->_hwlen_protolen = htons((ETHARP_HWADDR_LEN << 8) | 4);
  800167:	c7 04 24 04 06 00 00 	movl   $0x604,(%esp)
  80016e:	e8 84 03 00 00       	call   8004f7 <htons>
  800173:	66 a3 16 b0 fe 0f    	mov    %ax,0xffeb016
	arp->opcode = htons(ARP_REQUEST);
  800179:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800180:	e8 72 03 00 00       	call   8004f7 <htons>
  800185:	66 a3 18 b0 fe 0f    	mov    %ax,0xffeb018
	memcpy(arp->shwaddr.addr,  mac,   ETHARP_HWADDR_LEN);
  80018b:	83 c4 0c             	add    $0xc,%esp
  80018e:	6a 06                	push   $0x6
  800190:	53                   	push   %ebx
  800191:	68 1a b0 fe 0f       	push   $0xffeb01a
  800196:	e8 72 0f 00 00       	call   80110d <memcpy>
	memcpy(arp->sipaddr.addrw, &myip, 4);
  80019b:	83 c4 0c             	add    $0xc,%esp
  80019e:	6a 04                	push   $0x4
  8001a0:	8d 45 90             	lea    -0x70(%ebp),%eax
  8001a3:	50                   	push   %eax
  8001a4:	68 20 b0 fe 0f       	push   $0xffeb020
  8001a9:	e8 5f 0f 00 00       	call   80110d <memcpy>
	memset(arp->dhwaddr.addr,  0x00,  ETHARP_HWADDR_LEN);
  8001ae:	83 c4 0c             	add    $0xc,%esp
  8001b1:	6a 06                	push   $0x6
  8001b3:	6a 00                	push   $0x0
  8001b5:	68 24 b0 fe 0f       	push   $0xffeb024
  8001ba:	e8 99 0e 00 00       	call   801058 <memset>
	memcpy(arp->dipaddr.addrw, &gwip, 4);
  8001bf:	83 c4 0c             	add    $0xc,%esp
  8001c2:	6a 04                	push   $0x4
  8001c4:	8d 45 94             	lea    -0x6c(%ebp),%eax
  8001c7:	50                   	push   %eax
  8001c8:	68 2a b0 fe 0f       	push   $0xffeb02a
  8001cd:	e8 3b 0f 00 00       	call   80110d <memcpy>
	ipc_send(output_envid, NSREQ_OUTPUT, pkt, PTE_P|PTE_W|PTE_U);
  8001d2:	6a 07                	push   $0x7
  8001d4:	68 00 b0 fe 0f       	push   $0xffeb000
  8001d9:	6a 0b                	push   $0xb
  8001db:	ff 35 04 50 80 00    	pushl  0x805004
  8001e1:	e8 cf 16 00 00       	call   8018b5 <ipc_send>
	sys_page_unmap(0, pkt);
  8001e6:	83 c4 18             	add    $0x18,%esp
  8001e9:	68 00 b0 fe 0f       	push   $0xffeb000
  8001ee:	6a 00                	push   $0x0
  8001f0:	e8 a0 11 00 00       	call   801395 <sys_page_unmap>
  8001f5:	83 c4 10             	add    $0x10,%esp
	int i, r, first = 1;
  8001f8:	c7 85 7c ff ff ff 01 	movl   $0x1,-0x84(%ebp)
  8001ff:	00 00 00 
  800202:	e9 42 01 00 00       	jmp    800349 <umain+0x316>
		panic("error forking");
  800207:	83 ec 04             	sub    $0x4,%esp
  80020a:	68 ca 2d 80 00       	push   $0x802dca
  80020f:	6a 55                	push   $0x55
  800211:	68 d8 2d 80 00       	push   $0x802dd8
  800216:	e8 84 05 00 00       	call   80079f <_panic>
		input(ns_envid);
  80021b:	83 ec 0c             	sub    $0xc,%esp
  80021e:	53                   	push   %ebx
  80021f:	e8 1f 02 00 00       	call   800443 <input>
		return;
  800224:	83 c4 10             	add    $0x10,%esp
  800227:	e9 3f fe ff ff       	jmp    80006b <umain+0x38>
		panic("sys_page_map: %e", r);
  80022c:	50                   	push   %eax
  80022d:	68 18 2e 80 00       	push   $0x802e18
  800232:	6a 19                	push   $0x19
  800234:	68 d8 2d 80 00       	push   $0x802dd8
  800239:	e8 61 05 00 00       	call   80079f <_panic>
			panic("ipc_recv: %e", req);
  80023e:	50                   	push   %eax
  80023f:	68 29 2e 80 00       	push   $0x802e29
  800244:	6a 64                	push   $0x64
  800246:	68 d8 2d 80 00       	push   $0x802dd8
  80024b:	e8 4f 05 00 00       	call   80079f <_panic>
			panic("IPC from unexpected environment %08x", whom);
  800250:	52                   	push   %edx
  800251:	68 80 2e 80 00       	push   $0x802e80
  800256:	6a 66                	push   $0x66
  800258:	68 d8 2d 80 00       	push   $0x802dd8
  80025d:	e8 3d 05 00 00       	call   80079f <_panic>
			panic("Unexpected IPC %d", req);
  800262:	50                   	push   %eax
  800263:	68 36 2e 80 00       	push   $0x802e36
  800268:	6a 68                	push   $0x68
  80026a:	68 d8 2d 80 00       	push   $0x802dd8
  80026f:	e8 2b 05 00 00       	call   80079f <_panic>
			out = buf + snprintf(buf, end - buf,
  800274:	83 ec 0c             	sub    $0xc,%esp
  800277:	53                   	push   %ebx
  800278:	68 48 2e 80 00       	push   $0x802e48
  80027d:	68 50 2e 80 00       	push   $0x802e50
  800282:	6a 50                	push   $0x50
  800284:	8d 45 98             	lea    -0x68(%ebp),%eax
  800287:	50                   	push   %eax
  800288:	e8 39 0c 00 00       	call   800ec6 <snprintf>
  80028d:	8d 4d 98             	lea    -0x68(%ebp),%ecx
  800290:	8d 34 01             	lea    (%ecx,%eax,1),%esi
  800293:	83 c4 20             	add    $0x20,%esp
  800296:	eb 42                	jmp    8002da <umain+0x2a7>
			cprintf("%.*s\n", out - buf, buf);
  800298:	83 ec 04             	sub    $0x4,%esp
  80029b:	8d 45 98             	lea    -0x68(%ebp),%eax
  80029e:	50                   	push   %eax
  80029f:	89 f0                	mov    %esi,%eax
  8002a1:	8d 4d 98             	lea    -0x68(%ebp),%ecx
  8002a4:	29 c8                	sub    %ecx,%eax
  8002a6:	50                   	push   %eax
  8002a7:	68 5f 2e 80 00       	push   $0x802e5f
  8002ac:	e8 c9 05 00 00       	call   80087a <cprintf>
  8002b1:	83 c4 10             	add    $0x10,%esp
		if (i % 2 == 1)
  8002b4:	89 da                	mov    %ebx,%edx
  8002b6:	c1 ea 1f             	shr    $0x1f,%edx
  8002b9:	8d 04 13             	lea    (%ebx,%edx,1),%eax
  8002bc:	83 e0 01             	and    $0x1,%eax
  8002bf:	29 d0                	sub    %edx,%eax
  8002c1:	83 f8 01             	cmp    $0x1,%eax
  8002c4:	74 50                	je     800316 <umain+0x2e3>
		if (i % 16 == 7)
  8002c6:	83 ff 07             	cmp    $0x7,%edi
  8002c9:	74 53                	je     80031e <umain+0x2eb>
	for (i = 0; i < len; i++) {
  8002cb:	83 c3 01             	add    $0x1,%ebx
  8002ce:	39 5d 84             	cmp    %ebx,-0x7c(%ebp)
  8002d1:	7e 53                	jle    800326 <umain+0x2f3>
		if (i % 16 == 0)
  8002d3:	89 df                	mov    %ebx,%edi
  8002d5:	f6 c3 0f             	test   $0xf,%bl
  8002d8:	74 9a                	je     800274 <umain+0x241>
		out += snprintf(out, end - out, "%02x", ((uint8_t*)data)[i]);
  8002da:	b8 04 b0 fe 0f       	mov    $0xffeb004,%eax
  8002df:	0f b6 04 38          	movzbl (%eax,%edi,1),%eax
  8002e3:	50                   	push   %eax
  8002e4:	68 5a 2e 80 00       	push   $0x802e5a
  8002e9:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8002ec:	29 f0                	sub    %esi,%eax
  8002ee:	50                   	push   %eax
  8002ef:	56                   	push   %esi
  8002f0:	e8 d1 0b 00 00       	call   800ec6 <snprintf>
  8002f5:	01 c6                	add    %eax,%esi
		if (i % 16 == 15 || i == len - 1)
  8002f7:	89 d8                	mov    %ebx,%eax
  8002f9:	c1 f8 1f             	sar    $0x1f,%eax
  8002fc:	c1 e8 1c             	shr    $0x1c,%eax
  8002ff:	8d 3c 03             	lea    (%ebx,%eax,1),%edi
  800302:	83 e7 0f             	and    $0xf,%edi
  800305:	29 c7                	sub    %eax,%edi
  800307:	83 c4 10             	add    $0x10,%esp
  80030a:	83 ff 0f             	cmp    $0xf,%edi
  80030d:	74 89                	je     800298 <umain+0x265>
  80030f:	3b 5d 80             	cmp    -0x80(%ebp),%ebx
  800312:	75 a0                	jne    8002b4 <umain+0x281>
  800314:	eb 82                	jmp    800298 <umain+0x265>
			*(out++) = ' ';
  800316:	c6 06 20             	movb   $0x20,(%esi)
  800319:	8d 76 01             	lea    0x1(%esi),%esi
  80031c:	eb a8                	jmp    8002c6 <umain+0x293>
			*(out++) = ' ';
  80031e:	c6 06 20             	movb   $0x20,(%esi)
  800321:	8d 76 01             	lea    0x1(%esi),%esi
  800324:	eb a5                	jmp    8002cb <umain+0x298>
		cprintf("\n");
  800326:	83 ec 0c             	sub    $0xc,%esp
  800329:	68 7b 2e 80 00       	push   $0x802e7b
  80032e:	e8 47 05 00 00       	call   80087a <cprintf>
		if (first)
  800333:	83 c4 10             	add    $0x10,%esp
  800336:	83 bd 7c ff ff ff 00 	cmpl   $0x0,-0x84(%ebp)
  80033d:	75 5f                	jne    80039e <umain+0x36b>
		first = 0;
  80033f:	c7 85 7c ff ff ff 00 	movl   $0x0,-0x84(%ebp)
  800346:	00 00 00 
		int32_t req = ipc_recv((int32_t *)&whom, pkt, &perm);
  800349:	83 ec 04             	sub    $0x4,%esp
  80034c:	8d 45 94             	lea    -0x6c(%ebp),%eax
  80034f:	50                   	push   %eax
  800350:	68 00 b0 fe 0f       	push   $0xffeb000
  800355:	8d 45 90             	lea    -0x70(%ebp),%eax
  800358:	50                   	push   %eax
  800359:	e8 ee 14 00 00       	call   80184c <ipc_recv>
		if (req < 0)
  80035e:	83 c4 10             	add    $0x10,%esp
  800361:	85 c0                	test   %eax,%eax
  800363:	0f 88 d5 fe ff ff    	js     80023e <umain+0x20b>
		if (whom != input_envid)
  800369:	8b 55 90             	mov    -0x70(%ebp),%edx
  80036c:	3b 15 00 50 80 00    	cmp    0x805000,%edx
  800372:	0f 85 d8 fe ff ff    	jne    800250 <umain+0x21d>
		if (req != NSREQ_INPUT)
  800378:	83 f8 0a             	cmp    $0xa,%eax
  80037b:	0f 85 e1 fe ff ff    	jne    800262 <umain+0x22f>
		hexdump("input: ", pkt->jp_data, pkt->jp_len);
  800381:	a1 00 b0 fe 0f       	mov    0xffeb000,%eax
  800386:	89 45 84             	mov    %eax,-0x7c(%ebp)
	char *out = NULL;
  800389:	be 00 00 00 00       	mov    $0x0,%esi
	for (i = 0; i < len; i++) {
  80038e:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (i % 16 == 15 || i == len - 1)
  800393:	83 e8 01             	sub    $0x1,%eax
  800396:	89 45 80             	mov    %eax,-0x80(%ebp)
  800399:	e9 30 ff ff ff       	jmp    8002ce <umain+0x29b>
			cprintf("Waiting for packets...\n");
  80039e:	83 ec 0c             	sub    $0xc,%esp
  8003a1:	68 65 2e 80 00       	push   $0x802e65
  8003a6:	e8 cf 04 00 00       	call   80087a <cprintf>
  8003ab:	83 c4 10             	add    $0x10,%esp
  8003ae:	eb 8f                	jmp    80033f <umain+0x30c>

008003b0 <timer>:
#include "ns.h"

void
timer(envid_t ns_envid, uint32_t initial_to) {
  8003b0:	55                   	push   %ebp
  8003b1:	89 e5                	mov    %esp,%ebp
  8003b3:	57                   	push   %edi
  8003b4:	56                   	push   %esi
  8003b5:	53                   	push   %ebx
  8003b6:	83 ec 1c             	sub    $0x1c,%esp
  8003b9:	8b 75 08             	mov    0x8(%ebp),%esi
	int r;
	uint32_t stop = sys_time_msec() + initial_to;
  8003bc:	e8 40 11 00 00       	call   801501 <sys_time_msec>
  8003c1:	03 45 0c             	add    0xc(%ebp),%eax
  8003c4:	89 c3                	mov    %eax,%ebx

	binaryname = "ns_timer";
  8003c6:	c7 05 00 40 80 00 a5 	movl   $0x802ea5,0x804000
  8003cd:	2e 80 00 

		ipc_send(ns_envid, NSREQ_TIMER, 0, 0);

		while (1) {
			uint32_t to, whom;
			to = ipc_recv((int32_t *) &whom, 0, 0);
  8003d0:	8d 7d e4             	lea    -0x1c(%ebp),%edi
  8003d3:	eb 33                	jmp    800408 <timer+0x58>
		if (r < 0)
  8003d5:	85 c0                	test   %eax,%eax
  8003d7:	78 45                	js     80041e <timer+0x6e>
		ipc_send(ns_envid, NSREQ_TIMER, 0, 0);
  8003d9:	6a 00                	push   $0x0
  8003db:	6a 00                	push   $0x0
  8003dd:	6a 0c                	push   $0xc
  8003df:	56                   	push   %esi
  8003e0:	e8 d0 14 00 00       	call   8018b5 <ipc_send>
  8003e5:	83 c4 10             	add    $0x10,%esp
			to = ipc_recv((int32_t *) &whom, 0, 0);
  8003e8:	83 ec 04             	sub    $0x4,%esp
  8003eb:	6a 00                	push   $0x0
  8003ed:	6a 00                	push   $0x0
  8003ef:	57                   	push   %edi
  8003f0:	e8 57 14 00 00       	call   80184c <ipc_recv>
  8003f5:	89 c3                	mov    %eax,%ebx

			if (whom != ns_envid) {
  8003f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003fa:	83 c4 10             	add    $0x10,%esp
  8003fd:	39 f0                	cmp    %esi,%eax
  8003ff:	75 2f                	jne    800430 <timer+0x80>
				cprintf("NS TIMER: timer thread got IPC message from env %x not NS\n", whom);
				continue;
			}

			stop = sys_time_msec() + to;
  800401:	e8 fb 10 00 00       	call   801501 <sys_time_msec>
  800406:	01 c3                	add    %eax,%ebx
		while((r = sys_time_msec()) < stop && r >= 0) {
  800408:	e8 f4 10 00 00       	call   801501 <sys_time_msec>
  80040d:	89 c2                	mov    %eax,%edx
  80040f:	85 c0                	test   %eax,%eax
  800411:	78 c2                	js     8003d5 <timer+0x25>
  800413:	39 d8                	cmp    %ebx,%eax
  800415:	73 be                	jae    8003d5 <timer+0x25>
			sys_yield();
  800417:	e8 d5 0e 00 00       	call   8012f1 <sys_yield>
  80041c:	eb ea                	jmp    800408 <timer+0x58>
			panic("sys_time_msec: %e", r);
  80041e:	52                   	push   %edx
  80041f:	68 ae 2e 80 00       	push   $0x802eae
  800424:	6a 0f                	push   $0xf
  800426:	68 c0 2e 80 00       	push   $0x802ec0
  80042b:	e8 6f 03 00 00       	call   80079f <_panic>
				cprintf("NS TIMER: timer thread got IPC message from env %x not NS\n", whom);
  800430:	83 ec 08             	sub    $0x8,%esp
  800433:	50                   	push   %eax
  800434:	68 cc 2e 80 00       	push   $0x802ecc
  800439:	e8 3c 04 00 00       	call   80087a <cprintf>
				continue;
  80043e:	83 c4 10             	add    $0x10,%esp
  800441:	eb a5                	jmp    8003e8 <timer+0x38>

00800443 <input>:

extern union Nsipc nsipcbuf;

void
input(envid_t ns_envid)
{
  800443:	55                   	push   %ebp
  800444:	89 e5                	mov    %esp,%ebp
	binaryname = "ns_input";
  800446:	c7 05 00 40 80 00 07 	movl   $0x802f07,0x804000
  80044d:	2f 80 00 
	// 	- read a packet from the device driver
	//	- send it to the network server
	// Hint: When you IPC a page to the network server, it will be
	// reading from it for a while, so don't immediately receive
	// another packet in to the same physical page.
}
  800450:	5d                   	pop    %ebp
  800451:	c3                   	ret    

00800452 <output>:

extern union Nsipc nsipcbuf;

void
output(envid_t ns_envid)
{
  800452:	55                   	push   %ebp
  800453:	89 e5                	mov    %esp,%ebp
	binaryname = "ns_output";
  800455:	c7 05 00 40 80 00 10 	movl   $0x802f10,0x804000
  80045c:	2f 80 00 

	// LAB 6: Your code here:
	// 	- read a packet from the network server
	//	- send the packet to the device driver
}
  80045f:	5d                   	pop    %ebp
  800460:	c3                   	ret    

00800461 <inet_ntoa>:
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
{
  800461:	55                   	push   %ebp
  800462:	89 e5                	mov    %esp,%ebp
  800464:	57                   	push   %edi
  800465:	56                   	push   %esi
  800466:	53                   	push   %ebx
  800467:	83 ec 14             	sub    $0x14,%esp
  static char str[16];
  u32_t s_addr = addr.s_addr;
  80046a:	8b 45 08             	mov    0x8(%ebp),%eax
  80046d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  800470:	8d 7d f0             	lea    -0x10(%ebp),%edi
  rp = str;
  800473:	c7 45 e0 08 50 80 00 	movl   $0x805008,-0x20(%ebp)
  80047a:	eb 30                	jmp    8004ac <inet_ntoa+0x4b>
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
      *rp++ = inv[i];
  80047c:	0f b6 c2             	movzbl %dl,%eax
  80047f:	0f b6 44 05 ed       	movzbl -0x13(%ebp,%eax,1),%eax
  800484:	88 01                	mov    %al,(%ecx)
  800486:	83 c1 01             	add    $0x1,%ecx
    while(i--)
  800489:	83 ea 01             	sub    $0x1,%edx
  80048c:	80 fa ff             	cmp    $0xff,%dl
  80048f:	75 eb                	jne    80047c <inet_ntoa+0x1b>
  800491:	89 f0                	mov    %esi,%eax
  800493:	0f b6 f0             	movzbl %al,%esi
  800496:	03 75 e0             	add    -0x20(%ebp),%esi
    *rp++ = '.';
  800499:	8d 46 01             	lea    0x1(%esi),%eax
  80049c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80049f:	c6 06 2e             	movb   $0x2e,(%esi)
  8004a2:	83 c7 01             	add    $0x1,%edi
  for(n = 0; n < 4; n++) {
  8004a5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8004a8:	39 c7                	cmp    %eax,%edi
  8004aa:	74 3b                	je     8004e7 <inet_ntoa+0x86>
  rp = str;
  8004ac:	b9 00 00 00 00       	mov    $0x0,%ecx
      rem = *ap % (u8_t)10;
  8004b1:	0f b6 17             	movzbl (%edi),%edx
      *ap /= (u8_t)10;
  8004b4:	0f b6 da             	movzbl %dl,%ebx
  8004b7:	8d 04 9b             	lea    (%ebx,%ebx,4),%eax
  8004ba:	8d 04 c3             	lea    (%ebx,%eax,8),%eax
  8004bd:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8004c0:	66 c1 e8 0b          	shr    $0xb,%ax
  8004c4:	88 07                	mov    %al,(%edi)
      inv[i++] = '0' + rem;
  8004c6:	8d 71 01             	lea    0x1(%ecx),%esi
  8004c9:	0f b6 c9             	movzbl %cl,%ecx
      rem = *ap % (u8_t)10;
  8004cc:	8d 1c 80             	lea    (%eax,%eax,4),%ebx
  8004cf:	01 db                	add    %ebx,%ebx
  8004d1:	29 da                	sub    %ebx,%edx
      inv[i++] = '0' + rem;
  8004d3:	83 c2 30             	add    $0x30,%edx
  8004d6:	88 54 0d ed          	mov    %dl,-0x13(%ebp,%ecx,1)
  8004da:	89 f1                	mov    %esi,%ecx
    } while(*ap);
  8004dc:	84 c0                	test   %al,%al
  8004de:	75 d1                	jne    8004b1 <inet_ntoa+0x50>
  8004e0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      inv[i++] = '0' + rem;
  8004e3:	89 f2                	mov    %esi,%edx
  8004e5:	eb a2                	jmp    800489 <inet_ntoa+0x28>
    ap++;
  }
  *--rp = 0;
  8004e7:	c6 06 00             	movb   $0x0,(%esi)
  return str;
}
  8004ea:	b8 08 50 80 00       	mov    $0x805008,%eax
  8004ef:	83 c4 14             	add    $0x14,%esp
  8004f2:	5b                   	pop    %ebx
  8004f3:	5e                   	pop    %esi
  8004f4:	5f                   	pop    %edi
  8004f5:	5d                   	pop    %ebp
  8004f6:	c3                   	ret    

008004f7 <htons>:
 * @param n u16_t in host byte order
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  8004f7:	55                   	push   %ebp
  8004f8:	89 e5                	mov    %esp,%ebp
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  8004fa:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  8004fe:	66 c1 c0 08          	rol    $0x8,%ax
}
  800502:	5d                   	pop    %ebp
  800503:	c3                   	ret    

00800504 <ntohs>:
 * @param n u16_t in network byte order
 * @return n in host byte order
 */
u16_t
ntohs(u16_t n)
{
  800504:	55                   	push   %ebp
  800505:	89 e5                	mov    %esp,%ebp
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  800507:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  80050b:	66 c1 c0 08          	rol    $0x8,%ax
  return htons(n);
}
  80050f:	5d                   	pop    %ebp
  800510:	c3                   	ret    

00800511 <htonl>:
 * @param n u32_t in host byte order
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  800511:	55                   	push   %ebp
  800512:	89 e5                	mov    %esp,%ebp
  800514:	8b 55 08             	mov    0x8(%ebp),%edx
  return ((n & 0xff) << 24) |
  800517:	89 d0                	mov    %edx,%eax
  800519:	c1 e0 18             	shl    $0x18,%eax
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
  80051c:	89 d1                	mov    %edx,%ecx
  80051e:	c1 e9 18             	shr    $0x18,%ecx
    ((n & 0xff0000UL) >> 8) |
  800521:	09 c8                	or     %ecx,%eax
    ((n & 0xff00) << 8) |
  800523:	89 d1                	mov    %edx,%ecx
  800525:	c1 e1 08             	shl    $0x8,%ecx
  800528:	81 e1 00 00 ff 00    	and    $0xff0000,%ecx
    ((n & 0xff0000UL) >> 8) |
  80052e:	09 c8                	or     %ecx,%eax
  800530:	c1 ea 08             	shr    $0x8,%edx
  800533:	81 e2 00 ff 00 00    	and    $0xff00,%edx
  800539:	09 d0                	or     %edx,%eax
}
  80053b:	5d                   	pop    %ebp
  80053c:	c3                   	ret    

0080053d <inet_aton>:
{
  80053d:	55                   	push   %ebp
  80053e:	89 e5                	mov    %esp,%ebp
  800540:	57                   	push   %edi
  800541:	56                   	push   %esi
  800542:	53                   	push   %ebx
  800543:	83 ec 1c             	sub    $0x1c,%esp
  800546:	8b 45 08             	mov    0x8(%ebp),%eax
  c = *cp;
  800549:	0f be 10             	movsbl (%eax),%edx
  u32_t *pp = parts;
  80054c:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  80054f:	89 75 d8             	mov    %esi,-0x28(%ebp)
  800552:	e9 a9 00 00 00       	jmp    800600 <inet_aton+0xc3>
      c = *++cp;
  800557:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      if (c == 'x' || c == 'X') {
  80055b:	89 d1                	mov    %edx,%ecx
  80055d:	83 e1 df             	and    $0xffffffdf,%ecx
  800560:	80 f9 58             	cmp    $0x58,%cl
  800563:	74 12                	je     800577 <inet_aton+0x3a>
      c = *++cp;
  800565:	83 c0 01             	add    $0x1,%eax
  800568:	0f be d2             	movsbl %dl,%edx
        base = 8;
  80056b:	c7 45 dc 08 00 00 00 	movl   $0x8,-0x24(%ebp)
  800572:	e9 a5 00 00 00       	jmp    80061c <inet_aton+0xdf>
        c = *++cp;
  800577:	0f be 50 02          	movsbl 0x2(%eax),%edx
  80057b:	8d 40 02             	lea    0x2(%eax),%eax
        base = 16;
  80057e:	c7 45 dc 10 00 00 00 	movl   $0x10,-0x24(%ebp)
  800585:	e9 92 00 00 00       	jmp    80061c <inet_aton+0xdf>
      } else if (base == 16 && isxdigit(c)) {
  80058a:	83 7d dc 10          	cmpl   $0x10,-0x24(%ebp)
  80058e:	75 4a                	jne    8005da <inet_aton+0x9d>
  800590:	8d 5e 9f             	lea    -0x61(%esi),%ebx
  800593:	89 d1                	mov    %edx,%ecx
  800595:	83 e1 df             	and    $0xffffffdf,%ecx
  800598:	83 e9 41             	sub    $0x41,%ecx
  80059b:	80 f9 05             	cmp    $0x5,%cl
  80059e:	77 3a                	ja     8005da <inet_aton+0x9d>
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
  8005a0:	c1 e7 04             	shl    $0x4,%edi
  8005a3:	83 c2 0a             	add    $0xa,%edx
  8005a6:	80 fb 1a             	cmp    $0x1a,%bl
  8005a9:	19 c9                	sbb    %ecx,%ecx
  8005ab:	83 e1 20             	and    $0x20,%ecx
  8005ae:	83 c1 41             	add    $0x41,%ecx
  8005b1:	29 ca                	sub    %ecx,%edx
  8005b3:	09 d7                	or     %edx,%edi
        c = *++cp;
  8005b5:	8b 75 e0             	mov    -0x20(%ebp),%esi
  8005b8:	0f be 56 01          	movsbl 0x1(%esi),%edx
  8005bc:	83 c0 01             	add    $0x1,%eax
  8005bf:	89 45 e0             	mov    %eax,-0x20(%ebp)
      if (isdigit(c)) {
  8005c2:	89 d6                	mov    %edx,%esi
  8005c4:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8005c7:	80 f9 09             	cmp    $0x9,%cl
  8005ca:	77 be                	ja     80058a <inet_aton+0x4d>
        val = (val * base) + (int)(c - '0');
  8005cc:	0f af 7d dc          	imul   -0x24(%ebp),%edi
  8005d0:	8d 7c 3a d0          	lea    -0x30(%edx,%edi,1),%edi
        c = *++cp;
  8005d4:	0f be 50 01          	movsbl 0x1(%eax),%edx
  8005d8:	eb e2                	jmp    8005bc <inet_aton+0x7f>
    if (c == '.') {
  8005da:	83 fa 2e             	cmp    $0x2e,%edx
  8005dd:	75 44                	jne    800623 <inet_aton+0xe6>
      if (pp >= parts + 3)
  8005df:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8005e2:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  8005e5:	39 c3                	cmp    %eax,%ebx
  8005e7:	0f 84 13 01 00 00    	je     800700 <inet_aton+0x1c3>
      *pp++ = val;
  8005ed:	83 c3 04             	add    $0x4,%ebx
  8005f0:	89 5d d8             	mov    %ebx,-0x28(%ebp)
  8005f3:	89 7b fc             	mov    %edi,-0x4(%ebx)
      c = *++cp;
  8005f6:	8b 75 e0             	mov    -0x20(%ebp),%esi
  8005f9:	8d 46 01             	lea    0x1(%esi),%eax
  8005fc:	0f be 56 01          	movsbl 0x1(%esi),%edx
    if (!isdigit(c))
  800600:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800603:	80 f9 09             	cmp    $0x9,%cl
  800606:	0f 87 ed 00 00 00    	ja     8006f9 <inet_aton+0x1bc>
    base = 10;
  80060c:	c7 45 dc 0a 00 00 00 	movl   $0xa,-0x24(%ebp)
    if (c == '0') {
  800613:	83 fa 30             	cmp    $0x30,%edx
  800616:	0f 84 3b ff ff ff    	je     800557 <inet_aton+0x1a>
        base = 8;
  80061c:	bf 00 00 00 00       	mov    $0x0,%edi
  800621:	eb 9c                	jmp    8005bf <inet_aton+0x82>
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  800623:	85 d2                	test   %edx,%edx
  800625:	74 29                	je     800650 <inet_aton+0x113>
    return (0);
  800627:	b8 00 00 00 00       	mov    $0x0,%eax
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  80062c:	89 f3                	mov    %esi,%ebx
  80062e:	80 fb 1f             	cmp    $0x1f,%bl
  800631:	0f 86 ce 00 00 00    	jbe    800705 <inet_aton+0x1c8>
  800637:	84 d2                	test   %dl,%dl
  800639:	0f 88 c6 00 00 00    	js     800705 <inet_aton+0x1c8>
  80063f:	83 fa 20             	cmp    $0x20,%edx
  800642:	74 0c                	je     800650 <inet_aton+0x113>
  800644:	83 ea 09             	sub    $0x9,%edx
  800647:	83 fa 04             	cmp    $0x4,%edx
  80064a:	0f 87 b5 00 00 00    	ja     800705 <inet_aton+0x1c8>
  n = pp - parts + 1;
  800650:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800653:	8b 75 d8             	mov    -0x28(%ebp),%esi
  800656:	29 c6                	sub    %eax,%esi
  800658:	89 f0                	mov    %esi,%eax
  80065a:	c1 f8 02             	sar    $0x2,%eax
  80065d:	83 c0 01             	add    $0x1,%eax
  switch (n) {
  800660:	83 f8 02             	cmp    $0x2,%eax
  800663:	74 5e                	je     8006c3 <inet_aton+0x186>
  800665:	83 f8 02             	cmp    $0x2,%eax
  800668:	7e 35                	jle    80069f <inet_aton+0x162>
  80066a:	83 f8 03             	cmp    $0x3,%eax
  80066d:	74 6b                	je     8006da <inet_aton+0x19d>
  80066f:	83 f8 04             	cmp    $0x4,%eax
  800672:	75 2f                	jne    8006a3 <inet_aton+0x166>
      return (0);
  800674:	b8 00 00 00 00       	mov    $0x0,%eax
    if (val > 0xff)
  800679:	81 ff ff 00 00 00    	cmp    $0xff,%edi
  80067f:	0f 87 80 00 00 00    	ja     800705 <inet_aton+0x1c8>
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
  800685:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800688:	c1 e0 18             	shl    $0x18,%eax
  80068b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80068e:	c1 e2 10             	shl    $0x10,%edx
  800691:	09 d0                	or     %edx,%eax
  800693:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800696:	c1 e2 08             	shl    $0x8,%edx
  800699:	09 d0                	or     %edx,%eax
  80069b:	09 c7                	or     %eax,%edi
    break;
  80069d:	eb 04                	jmp    8006a3 <inet_aton+0x166>
  switch (n) {
  80069f:	85 c0                	test   %eax,%eax
  8006a1:	74 62                	je     800705 <inet_aton+0x1c8>
  return (1);
  8006a3:	b8 01 00 00 00       	mov    $0x1,%eax
  if (addr)
  8006a8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006ac:	74 57                	je     800705 <inet_aton+0x1c8>
    addr->s_addr = htonl(val);
  8006ae:	57                   	push   %edi
  8006af:	e8 5d fe ff ff       	call   800511 <htonl>
  8006b4:	83 c4 04             	add    $0x4,%esp
  8006b7:	8b 75 0c             	mov    0xc(%ebp),%esi
  8006ba:	89 06                	mov    %eax,(%esi)
  return (1);
  8006bc:	b8 01 00 00 00       	mov    $0x1,%eax
  8006c1:	eb 42                	jmp    800705 <inet_aton+0x1c8>
      return (0);
  8006c3:	b8 00 00 00 00       	mov    $0x0,%eax
    if (val > 0xffffffUL)
  8006c8:	81 ff ff ff ff 00    	cmp    $0xffffff,%edi
  8006ce:	77 35                	ja     800705 <inet_aton+0x1c8>
    val |= parts[0] << 24;
  8006d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006d3:	c1 e0 18             	shl    $0x18,%eax
  8006d6:	09 c7                	or     %eax,%edi
    break;
  8006d8:	eb c9                	jmp    8006a3 <inet_aton+0x166>
      return (0);
  8006da:	b8 00 00 00 00       	mov    $0x0,%eax
    if (val > 0xffff)
  8006df:	81 ff ff ff 00 00    	cmp    $0xffff,%edi
  8006e5:	77 1e                	ja     800705 <inet_aton+0x1c8>
    val |= (parts[0] << 24) | (parts[1] << 16);
  8006e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006ea:	c1 e0 18             	shl    $0x18,%eax
  8006ed:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8006f0:	c1 e2 10             	shl    $0x10,%edx
  8006f3:	09 d0                	or     %edx,%eax
  8006f5:	09 c7                	or     %eax,%edi
    break;
  8006f7:	eb aa                	jmp    8006a3 <inet_aton+0x166>
      return (0);
  8006f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8006fe:	eb 05                	jmp    800705 <inet_aton+0x1c8>
        return (0);
  800700:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800705:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800708:	5b                   	pop    %ebx
  800709:	5e                   	pop    %esi
  80070a:	5f                   	pop    %edi
  80070b:	5d                   	pop    %ebp
  80070c:	c3                   	ret    

0080070d <inet_addr>:
{
  80070d:	55                   	push   %ebp
  80070e:	89 e5                	mov    %esp,%ebp
  800710:	83 ec 10             	sub    $0x10,%esp
  if (inet_aton(cp, &val)) {
  800713:	8d 45 fc             	lea    -0x4(%ebp),%eax
  800716:	50                   	push   %eax
  800717:	ff 75 08             	pushl  0x8(%ebp)
  80071a:	e8 1e fe ff ff       	call   80053d <inet_aton>
  80071f:	83 c4 08             	add    $0x8,%esp
    return (val.s_addr);
  800722:	85 c0                	test   %eax,%eax
  800724:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800729:	0f 45 45 fc          	cmovne -0x4(%ebp),%eax
}
  80072d:	c9                   	leave  
  80072e:	c3                   	ret    

0080072f <ntohl>:
 * @param n u32_t in network byte order
 * @return n in host byte order
 */
u32_t
ntohl(u32_t n)
{
  80072f:	55                   	push   %ebp
  800730:	89 e5                	mov    %esp,%ebp
  return htonl(n);
  800732:	ff 75 08             	pushl  0x8(%ebp)
  800735:	e8 d7 fd ff ff       	call   800511 <htonl>
  80073a:	83 c4 04             	add    $0x4,%esp
}
  80073d:	c9                   	leave  
  80073e:	c3                   	ret    

0080073f <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80073f:	55                   	push   %ebp
  800740:	89 e5                	mov    %esp,%ebp
  800742:	56                   	push   %esi
  800743:	53                   	push   %ebx
  800744:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800747:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
    thisenv = &envs[ENVX(sys_getenvid())];
  80074a:	e8 83 0b 00 00       	call   8012d2 <sys_getenvid>
  80074f:	25 ff 03 00 00       	and    $0x3ff,%eax
  800754:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800757:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80075c:	a3 20 50 80 00       	mov    %eax,0x805020

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800761:	85 db                	test   %ebx,%ebx
  800763:	7e 07                	jle    80076c <libmain+0x2d>
		binaryname = argv[0];
  800765:	8b 06                	mov    (%esi),%eax
  800767:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  80076c:	83 ec 08             	sub    $0x8,%esp
  80076f:	56                   	push   %esi
  800770:	53                   	push   %ebx
  800771:	e8 bd f8 ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800776:	e8 0a 00 00 00       	call   800785 <exit>
}
  80077b:	83 c4 10             	add    $0x10,%esp
  80077e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800781:	5b                   	pop    %ebx
  800782:	5e                   	pop    %esi
  800783:	5d                   	pop    %ebp
  800784:	c3                   	ret    

00800785 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800785:	55                   	push   %ebp
  800786:	89 e5                	mov    %esp,%ebp
  800788:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80078b:	e8 8d 13 00 00       	call   801b1d <close_all>
	sys_env_destroy(0);
  800790:	83 ec 0c             	sub    $0xc,%esp
  800793:	6a 00                	push   $0x0
  800795:	e8 f7 0a 00 00       	call   801291 <sys_env_destroy>
}
  80079a:	83 c4 10             	add    $0x10,%esp
  80079d:	c9                   	leave  
  80079e:	c3                   	ret    

0080079f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80079f:	55                   	push   %ebp
  8007a0:	89 e5                	mov    %esp,%ebp
  8007a2:	56                   	push   %esi
  8007a3:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8007a4:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8007a7:	8b 35 00 40 80 00    	mov    0x804000,%esi
  8007ad:	e8 20 0b 00 00       	call   8012d2 <sys_getenvid>
  8007b2:	83 ec 0c             	sub    $0xc,%esp
  8007b5:	ff 75 0c             	pushl  0xc(%ebp)
  8007b8:	ff 75 08             	pushl  0x8(%ebp)
  8007bb:	56                   	push   %esi
  8007bc:	50                   	push   %eax
  8007bd:	68 24 2f 80 00       	push   $0x802f24
  8007c2:	e8 b3 00 00 00       	call   80087a <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8007c7:	83 c4 18             	add    $0x18,%esp
  8007ca:	53                   	push   %ebx
  8007cb:	ff 75 10             	pushl  0x10(%ebp)
  8007ce:	e8 56 00 00 00       	call   800829 <vcprintf>
	cprintf("\n");
  8007d3:	c7 04 24 7b 2e 80 00 	movl   $0x802e7b,(%esp)
  8007da:	e8 9b 00 00 00       	call   80087a <cprintf>
  8007df:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8007e2:	cc                   	int3   
  8007e3:	eb fd                	jmp    8007e2 <_panic+0x43>

008007e5 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8007e5:	55                   	push   %ebp
  8007e6:	89 e5                	mov    %esp,%ebp
  8007e8:	53                   	push   %ebx
  8007e9:	83 ec 04             	sub    $0x4,%esp
  8007ec:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8007ef:	8b 13                	mov    (%ebx),%edx
  8007f1:	8d 42 01             	lea    0x1(%edx),%eax
  8007f4:	89 03                	mov    %eax,(%ebx)
  8007f6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007f9:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8007fd:	3d ff 00 00 00       	cmp    $0xff,%eax
  800802:	74 09                	je     80080d <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800804:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800808:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80080b:	c9                   	leave  
  80080c:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80080d:	83 ec 08             	sub    $0x8,%esp
  800810:	68 ff 00 00 00       	push   $0xff
  800815:	8d 43 08             	lea    0x8(%ebx),%eax
  800818:	50                   	push   %eax
  800819:	e8 36 0a 00 00       	call   801254 <sys_cputs>
		b->idx = 0;
  80081e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800824:	83 c4 10             	add    $0x10,%esp
  800827:	eb db                	jmp    800804 <putch+0x1f>

00800829 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800829:	55                   	push   %ebp
  80082a:	89 e5                	mov    %esp,%ebp
  80082c:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800832:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800839:	00 00 00 
	b.cnt = 0;
  80083c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800843:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800846:	ff 75 0c             	pushl  0xc(%ebp)
  800849:	ff 75 08             	pushl  0x8(%ebp)
  80084c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800852:	50                   	push   %eax
  800853:	68 e5 07 80 00       	push   $0x8007e5
  800858:	e8 1a 01 00 00       	call   800977 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80085d:	83 c4 08             	add    $0x8,%esp
  800860:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800866:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80086c:	50                   	push   %eax
  80086d:	e8 e2 09 00 00       	call   801254 <sys_cputs>

	return b.cnt;
}
  800872:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800878:	c9                   	leave  
  800879:	c3                   	ret    

0080087a <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80087a:	55                   	push   %ebp
  80087b:	89 e5                	mov    %esp,%ebp
  80087d:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800880:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800883:	50                   	push   %eax
  800884:	ff 75 08             	pushl  0x8(%ebp)
  800887:	e8 9d ff ff ff       	call   800829 <vcprintf>
	va_end(ap);

	return cnt;
}
  80088c:	c9                   	leave  
  80088d:	c3                   	ret    

0080088e <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80088e:	55                   	push   %ebp
  80088f:	89 e5                	mov    %esp,%ebp
  800891:	57                   	push   %edi
  800892:	56                   	push   %esi
  800893:	53                   	push   %ebx
  800894:	83 ec 1c             	sub    $0x1c,%esp
  800897:	89 c7                	mov    %eax,%edi
  800899:	89 d6                	mov    %edx,%esi
  80089b:	8b 45 08             	mov    0x8(%ebp),%eax
  80089e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008a1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008a4:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8008a7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8008aa:	bb 00 00 00 00       	mov    $0x0,%ebx
  8008af:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8008b2:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8008b5:	39 d3                	cmp    %edx,%ebx
  8008b7:	72 05                	jb     8008be <printnum+0x30>
  8008b9:	39 45 10             	cmp    %eax,0x10(%ebp)
  8008bc:	77 7a                	ja     800938 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8008be:	83 ec 0c             	sub    $0xc,%esp
  8008c1:	ff 75 18             	pushl  0x18(%ebp)
  8008c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c7:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8008ca:	53                   	push   %ebx
  8008cb:	ff 75 10             	pushl  0x10(%ebp)
  8008ce:	83 ec 08             	sub    $0x8,%esp
  8008d1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8008d4:	ff 75 e0             	pushl  -0x20(%ebp)
  8008d7:	ff 75 dc             	pushl  -0x24(%ebp)
  8008da:	ff 75 d8             	pushl  -0x28(%ebp)
  8008dd:	e8 9e 22 00 00       	call   802b80 <__udivdi3>
  8008e2:	83 c4 18             	add    $0x18,%esp
  8008e5:	52                   	push   %edx
  8008e6:	50                   	push   %eax
  8008e7:	89 f2                	mov    %esi,%edx
  8008e9:	89 f8                	mov    %edi,%eax
  8008eb:	e8 9e ff ff ff       	call   80088e <printnum>
  8008f0:	83 c4 20             	add    $0x20,%esp
  8008f3:	eb 13                	jmp    800908 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8008f5:	83 ec 08             	sub    $0x8,%esp
  8008f8:	56                   	push   %esi
  8008f9:	ff 75 18             	pushl  0x18(%ebp)
  8008fc:	ff d7                	call   *%edi
  8008fe:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800901:	83 eb 01             	sub    $0x1,%ebx
  800904:	85 db                	test   %ebx,%ebx
  800906:	7f ed                	jg     8008f5 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800908:	83 ec 08             	sub    $0x8,%esp
  80090b:	56                   	push   %esi
  80090c:	83 ec 04             	sub    $0x4,%esp
  80090f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800912:	ff 75 e0             	pushl  -0x20(%ebp)
  800915:	ff 75 dc             	pushl  -0x24(%ebp)
  800918:	ff 75 d8             	pushl  -0x28(%ebp)
  80091b:	e8 80 23 00 00       	call   802ca0 <__umoddi3>
  800920:	83 c4 14             	add    $0x14,%esp
  800923:	0f be 80 47 2f 80 00 	movsbl 0x802f47(%eax),%eax
  80092a:	50                   	push   %eax
  80092b:	ff d7                	call   *%edi
}
  80092d:	83 c4 10             	add    $0x10,%esp
  800930:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800933:	5b                   	pop    %ebx
  800934:	5e                   	pop    %esi
  800935:	5f                   	pop    %edi
  800936:	5d                   	pop    %ebp
  800937:	c3                   	ret    
  800938:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80093b:	eb c4                	jmp    800901 <printnum+0x73>

0080093d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80093d:	55                   	push   %ebp
  80093e:	89 e5                	mov    %esp,%ebp
  800940:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800943:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800947:	8b 10                	mov    (%eax),%edx
  800949:	3b 50 04             	cmp    0x4(%eax),%edx
  80094c:	73 0a                	jae    800958 <sprintputch+0x1b>
		*b->buf++ = ch;
  80094e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800951:	89 08                	mov    %ecx,(%eax)
  800953:	8b 45 08             	mov    0x8(%ebp),%eax
  800956:	88 02                	mov    %al,(%edx)
}
  800958:	5d                   	pop    %ebp
  800959:	c3                   	ret    

0080095a <printfmt>:
{
  80095a:	55                   	push   %ebp
  80095b:	89 e5                	mov    %esp,%ebp
  80095d:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800960:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800963:	50                   	push   %eax
  800964:	ff 75 10             	pushl  0x10(%ebp)
  800967:	ff 75 0c             	pushl  0xc(%ebp)
  80096a:	ff 75 08             	pushl  0x8(%ebp)
  80096d:	e8 05 00 00 00       	call   800977 <vprintfmt>
}
  800972:	83 c4 10             	add    $0x10,%esp
  800975:	c9                   	leave  
  800976:	c3                   	ret    

00800977 <vprintfmt>:
{
  800977:	55                   	push   %ebp
  800978:	89 e5                	mov    %esp,%ebp
  80097a:	57                   	push   %edi
  80097b:	56                   	push   %esi
  80097c:	53                   	push   %ebx
  80097d:	83 ec 2c             	sub    $0x2c,%esp
  800980:	8b 75 08             	mov    0x8(%ebp),%esi
  800983:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800986:	8b 7d 10             	mov    0x10(%ebp),%edi
  800989:	e9 21 04 00 00       	jmp    800daf <vprintfmt+0x438>
		padc = ' ';
  80098e:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  800992:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800999:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  8009a0:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009a7:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8009ac:	8d 47 01             	lea    0x1(%edi),%eax
  8009af:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8009b2:	0f b6 17             	movzbl (%edi),%edx
  8009b5:	8d 42 dd             	lea    -0x23(%edx),%eax
  8009b8:	3c 55                	cmp    $0x55,%al
  8009ba:	0f 87 90 04 00 00    	ja     800e50 <vprintfmt+0x4d9>
  8009c0:	0f b6 c0             	movzbl %al,%eax
  8009c3:	ff 24 85 80 30 80 00 	jmp    *0x803080(,%eax,4)
  8009ca:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8009cd:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8009d1:	eb d9                	jmp    8009ac <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8009d3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8009d6:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8009da:	eb d0                	jmp    8009ac <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8009dc:	0f b6 d2             	movzbl %dl,%edx
  8009df:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8009e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8009e7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8009ea:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8009ed:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8009f1:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8009f4:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8009f7:	83 f9 09             	cmp    $0x9,%ecx
  8009fa:	77 55                	ja     800a51 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  8009fc:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8009ff:	eb e9                	jmp    8009ea <vprintfmt+0x73>
			precision = va_arg(ap, int);
  800a01:	8b 45 14             	mov    0x14(%ebp),%eax
  800a04:	8b 00                	mov    (%eax),%eax
  800a06:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800a09:	8b 45 14             	mov    0x14(%ebp),%eax
  800a0c:	8d 40 04             	lea    0x4(%eax),%eax
  800a0f:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800a12:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800a15:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a19:	79 91                	jns    8009ac <vprintfmt+0x35>
				width = precision, precision = -1;
  800a1b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800a1e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800a21:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800a28:	eb 82                	jmp    8009ac <vprintfmt+0x35>
  800a2a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a2d:	85 c0                	test   %eax,%eax
  800a2f:	ba 00 00 00 00       	mov    $0x0,%edx
  800a34:	0f 49 d0             	cmovns %eax,%edx
  800a37:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800a3a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800a3d:	e9 6a ff ff ff       	jmp    8009ac <vprintfmt+0x35>
  800a42:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800a45:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800a4c:	e9 5b ff ff ff       	jmp    8009ac <vprintfmt+0x35>
  800a51:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800a54:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800a57:	eb bc                	jmp    800a15 <vprintfmt+0x9e>
			lflag++;
  800a59:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800a5c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800a5f:	e9 48 ff ff ff       	jmp    8009ac <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800a64:	8b 45 14             	mov    0x14(%ebp),%eax
  800a67:	8d 78 04             	lea    0x4(%eax),%edi
  800a6a:	83 ec 08             	sub    $0x8,%esp
  800a6d:	53                   	push   %ebx
  800a6e:	ff 30                	pushl  (%eax)
  800a70:	ff d6                	call   *%esi
			break;
  800a72:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800a75:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800a78:	e9 2f 03 00 00       	jmp    800dac <vprintfmt+0x435>
			err = va_arg(ap, int);
  800a7d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a80:	8d 78 04             	lea    0x4(%eax),%edi
  800a83:	8b 00                	mov    (%eax),%eax
  800a85:	99                   	cltd   
  800a86:	31 d0                	xor    %edx,%eax
  800a88:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800a8a:	83 f8 0f             	cmp    $0xf,%eax
  800a8d:	7f 23                	jg     800ab2 <vprintfmt+0x13b>
  800a8f:	8b 14 85 e0 31 80 00 	mov    0x8031e0(,%eax,4),%edx
  800a96:	85 d2                	test   %edx,%edx
  800a98:	74 18                	je     800ab2 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  800a9a:	52                   	push   %edx
  800a9b:	68 ba 33 80 00       	push   $0x8033ba
  800aa0:	53                   	push   %ebx
  800aa1:	56                   	push   %esi
  800aa2:	e8 b3 fe ff ff       	call   80095a <printfmt>
  800aa7:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800aaa:	89 7d 14             	mov    %edi,0x14(%ebp)
  800aad:	e9 fa 02 00 00       	jmp    800dac <vprintfmt+0x435>
				printfmt(putch, putdat, "error %d", err);
  800ab2:	50                   	push   %eax
  800ab3:	68 5f 2f 80 00       	push   $0x802f5f
  800ab8:	53                   	push   %ebx
  800ab9:	56                   	push   %esi
  800aba:	e8 9b fe ff ff       	call   80095a <printfmt>
  800abf:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800ac2:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800ac5:	e9 e2 02 00 00       	jmp    800dac <vprintfmt+0x435>
			if ((p = va_arg(ap, char *)) == NULL)
  800aca:	8b 45 14             	mov    0x14(%ebp),%eax
  800acd:	83 c0 04             	add    $0x4,%eax
  800ad0:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800ad3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad6:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800ad8:	85 ff                	test   %edi,%edi
  800ada:	b8 58 2f 80 00       	mov    $0x802f58,%eax
  800adf:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800ae2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ae6:	0f 8e bd 00 00 00    	jle    800ba9 <vprintfmt+0x232>
  800aec:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800af0:	75 0e                	jne    800b00 <vprintfmt+0x189>
  800af2:	89 75 08             	mov    %esi,0x8(%ebp)
  800af5:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800af8:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800afb:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800afe:	eb 6d                	jmp    800b6d <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b00:	83 ec 08             	sub    $0x8,%esp
  800b03:	ff 75 d0             	pushl  -0x30(%ebp)
  800b06:	57                   	push   %edi
  800b07:	e8 ec 03 00 00       	call   800ef8 <strnlen>
  800b0c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800b0f:	29 c1                	sub    %eax,%ecx
  800b11:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800b14:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800b17:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800b1b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800b1e:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800b21:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800b23:	eb 0f                	jmp    800b34 <vprintfmt+0x1bd>
					putch(padc, putdat);
  800b25:	83 ec 08             	sub    $0x8,%esp
  800b28:	53                   	push   %ebx
  800b29:	ff 75 e0             	pushl  -0x20(%ebp)
  800b2c:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800b2e:	83 ef 01             	sub    $0x1,%edi
  800b31:	83 c4 10             	add    $0x10,%esp
  800b34:	85 ff                	test   %edi,%edi
  800b36:	7f ed                	jg     800b25 <vprintfmt+0x1ae>
  800b38:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800b3b:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800b3e:	85 c9                	test   %ecx,%ecx
  800b40:	b8 00 00 00 00       	mov    $0x0,%eax
  800b45:	0f 49 c1             	cmovns %ecx,%eax
  800b48:	29 c1                	sub    %eax,%ecx
  800b4a:	89 75 08             	mov    %esi,0x8(%ebp)
  800b4d:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800b50:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800b53:	89 cb                	mov    %ecx,%ebx
  800b55:	eb 16                	jmp    800b6d <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  800b57:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800b5b:	75 31                	jne    800b8e <vprintfmt+0x217>
					putch(ch, putdat);
  800b5d:	83 ec 08             	sub    $0x8,%esp
  800b60:	ff 75 0c             	pushl  0xc(%ebp)
  800b63:	50                   	push   %eax
  800b64:	ff 55 08             	call   *0x8(%ebp)
  800b67:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b6a:	83 eb 01             	sub    $0x1,%ebx
  800b6d:	83 c7 01             	add    $0x1,%edi
  800b70:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800b74:	0f be c2             	movsbl %dl,%eax
  800b77:	85 c0                	test   %eax,%eax
  800b79:	74 59                	je     800bd4 <vprintfmt+0x25d>
  800b7b:	85 f6                	test   %esi,%esi
  800b7d:	78 d8                	js     800b57 <vprintfmt+0x1e0>
  800b7f:	83 ee 01             	sub    $0x1,%esi
  800b82:	79 d3                	jns    800b57 <vprintfmt+0x1e0>
  800b84:	89 df                	mov    %ebx,%edi
  800b86:	8b 75 08             	mov    0x8(%ebp),%esi
  800b89:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800b8c:	eb 37                	jmp    800bc5 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  800b8e:	0f be d2             	movsbl %dl,%edx
  800b91:	83 ea 20             	sub    $0x20,%edx
  800b94:	83 fa 5e             	cmp    $0x5e,%edx
  800b97:	76 c4                	jbe    800b5d <vprintfmt+0x1e6>
					putch('?', putdat);
  800b99:	83 ec 08             	sub    $0x8,%esp
  800b9c:	ff 75 0c             	pushl  0xc(%ebp)
  800b9f:	6a 3f                	push   $0x3f
  800ba1:	ff 55 08             	call   *0x8(%ebp)
  800ba4:	83 c4 10             	add    $0x10,%esp
  800ba7:	eb c1                	jmp    800b6a <vprintfmt+0x1f3>
  800ba9:	89 75 08             	mov    %esi,0x8(%ebp)
  800bac:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800baf:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800bb2:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800bb5:	eb b6                	jmp    800b6d <vprintfmt+0x1f6>
				putch(' ', putdat);
  800bb7:	83 ec 08             	sub    $0x8,%esp
  800bba:	53                   	push   %ebx
  800bbb:	6a 20                	push   $0x20
  800bbd:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800bbf:	83 ef 01             	sub    $0x1,%edi
  800bc2:	83 c4 10             	add    $0x10,%esp
  800bc5:	85 ff                	test   %edi,%edi
  800bc7:	7f ee                	jg     800bb7 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  800bc9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800bcc:	89 45 14             	mov    %eax,0x14(%ebp)
  800bcf:	e9 d8 01 00 00       	jmp    800dac <vprintfmt+0x435>
  800bd4:	89 df                	mov    %ebx,%edi
  800bd6:	8b 75 08             	mov    0x8(%ebp),%esi
  800bd9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800bdc:	eb e7                	jmp    800bc5 <vprintfmt+0x24e>
	if (lflag >= 2)
  800bde:	83 f9 01             	cmp    $0x1,%ecx
  800be1:	7e 45                	jle    800c28 <vprintfmt+0x2b1>
		return va_arg(*ap, long long);
  800be3:	8b 45 14             	mov    0x14(%ebp),%eax
  800be6:	8b 50 04             	mov    0x4(%eax),%edx
  800be9:	8b 00                	mov    (%eax),%eax
  800beb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800bee:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800bf1:	8b 45 14             	mov    0x14(%ebp),%eax
  800bf4:	8d 40 08             	lea    0x8(%eax),%eax
  800bf7:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800bfa:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800bfe:	79 62                	jns    800c62 <vprintfmt+0x2eb>
				putch('-', putdat);
  800c00:	83 ec 08             	sub    $0x8,%esp
  800c03:	53                   	push   %ebx
  800c04:	6a 2d                	push   $0x2d
  800c06:	ff d6                	call   *%esi
				num = -(long long) num;
  800c08:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800c0b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800c0e:	f7 d8                	neg    %eax
  800c10:	83 d2 00             	adc    $0x0,%edx
  800c13:	f7 da                	neg    %edx
  800c15:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c18:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800c1b:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800c1e:	ba 0a 00 00 00       	mov    $0xa,%edx
  800c23:	e9 66 01 00 00       	jmp    800d8e <vprintfmt+0x417>
	else if (lflag)
  800c28:	85 c9                	test   %ecx,%ecx
  800c2a:	75 1b                	jne    800c47 <vprintfmt+0x2d0>
		return va_arg(*ap, int);
  800c2c:	8b 45 14             	mov    0x14(%ebp),%eax
  800c2f:	8b 00                	mov    (%eax),%eax
  800c31:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c34:	89 c1                	mov    %eax,%ecx
  800c36:	c1 f9 1f             	sar    $0x1f,%ecx
  800c39:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800c3c:	8b 45 14             	mov    0x14(%ebp),%eax
  800c3f:	8d 40 04             	lea    0x4(%eax),%eax
  800c42:	89 45 14             	mov    %eax,0x14(%ebp)
  800c45:	eb b3                	jmp    800bfa <vprintfmt+0x283>
		return va_arg(*ap, long);
  800c47:	8b 45 14             	mov    0x14(%ebp),%eax
  800c4a:	8b 00                	mov    (%eax),%eax
  800c4c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c4f:	89 c1                	mov    %eax,%ecx
  800c51:	c1 f9 1f             	sar    $0x1f,%ecx
  800c54:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800c57:	8b 45 14             	mov    0x14(%ebp),%eax
  800c5a:	8d 40 04             	lea    0x4(%eax),%eax
  800c5d:	89 45 14             	mov    %eax,0x14(%ebp)
  800c60:	eb 98                	jmp    800bfa <vprintfmt+0x283>
			base = 10;
  800c62:	ba 0a 00 00 00       	mov    $0xa,%edx
  800c67:	e9 22 01 00 00       	jmp    800d8e <vprintfmt+0x417>
	if (lflag >= 2)
  800c6c:	83 f9 01             	cmp    $0x1,%ecx
  800c6f:	7e 21                	jle    800c92 <vprintfmt+0x31b>
		return va_arg(*ap, unsigned long long);
  800c71:	8b 45 14             	mov    0x14(%ebp),%eax
  800c74:	8b 50 04             	mov    0x4(%eax),%edx
  800c77:	8b 00                	mov    (%eax),%eax
  800c79:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c7c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800c7f:	8b 45 14             	mov    0x14(%ebp),%eax
  800c82:	8d 40 08             	lea    0x8(%eax),%eax
  800c85:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800c88:	ba 0a 00 00 00       	mov    $0xa,%edx
  800c8d:	e9 fc 00 00 00       	jmp    800d8e <vprintfmt+0x417>
	else if (lflag)
  800c92:	85 c9                	test   %ecx,%ecx
  800c94:	75 23                	jne    800cb9 <vprintfmt+0x342>
		return va_arg(*ap, unsigned int);
  800c96:	8b 45 14             	mov    0x14(%ebp),%eax
  800c99:	8b 00                	mov    (%eax),%eax
  800c9b:	ba 00 00 00 00       	mov    $0x0,%edx
  800ca0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ca3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800ca6:	8b 45 14             	mov    0x14(%ebp),%eax
  800ca9:	8d 40 04             	lea    0x4(%eax),%eax
  800cac:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800caf:	ba 0a 00 00 00       	mov    $0xa,%edx
  800cb4:	e9 d5 00 00 00       	jmp    800d8e <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  800cb9:	8b 45 14             	mov    0x14(%ebp),%eax
  800cbc:	8b 00                	mov    (%eax),%eax
  800cbe:	ba 00 00 00 00       	mov    $0x0,%edx
  800cc3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800cc6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800cc9:	8b 45 14             	mov    0x14(%ebp),%eax
  800ccc:	8d 40 04             	lea    0x4(%eax),%eax
  800ccf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800cd2:	ba 0a 00 00 00       	mov    $0xa,%edx
  800cd7:	e9 b2 00 00 00       	jmp    800d8e <vprintfmt+0x417>
	if (lflag >= 2)
  800cdc:	83 f9 01             	cmp    $0x1,%ecx
  800cdf:	7e 42                	jle    800d23 <vprintfmt+0x3ac>
		return va_arg(*ap, unsigned long long);
  800ce1:	8b 45 14             	mov    0x14(%ebp),%eax
  800ce4:	8b 50 04             	mov    0x4(%eax),%edx
  800ce7:	8b 00                	mov    (%eax),%eax
  800ce9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800cec:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800cef:	8b 45 14             	mov    0x14(%ebp),%eax
  800cf2:	8d 40 08             	lea    0x8(%eax),%eax
  800cf5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800cf8:	ba 08 00 00 00       	mov    $0x8,%edx
			if ((long long) num < 0) {
  800cfd:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800d01:	0f 89 87 00 00 00    	jns    800d8e <vprintfmt+0x417>
				putch('-', putdat);
  800d07:	83 ec 08             	sub    $0x8,%esp
  800d0a:	53                   	push   %ebx
  800d0b:	6a 2d                	push   $0x2d
  800d0d:	ff d6                	call   *%esi
				num = -(long long) num;
  800d0f:	f7 5d d8             	negl   -0x28(%ebp)
  800d12:	83 55 dc 00          	adcl   $0x0,-0x24(%ebp)
  800d16:	f7 5d dc             	negl   -0x24(%ebp)
  800d19:	83 c4 10             	add    $0x10,%esp
			base = 8;
  800d1c:	ba 08 00 00 00       	mov    $0x8,%edx
  800d21:	eb 6b                	jmp    800d8e <vprintfmt+0x417>
	else if (lflag)
  800d23:	85 c9                	test   %ecx,%ecx
  800d25:	75 1b                	jne    800d42 <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  800d27:	8b 45 14             	mov    0x14(%ebp),%eax
  800d2a:	8b 00                	mov    (%eax),%eax
  800d2c:	ba 00 00 00 00       	mov    $0x0,%edx
  800d31:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800d34:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800d37:	8b 45 14             	mov    0x14(%ebp),%eax
  800d3a:	8d 40 04             	lea    0x4(%eax),%eax
  800d3d:	89 45 14             	mov    %eax,0x14(%ebp)
  800d40:	eb b6                	jmp    800cf8 <vprintfmt+0x381>
		return va_arg(*ap, unsigned long);
  800d42:	8b 45 14             	mov    0x14(%ebp),%eax
  800d45:	8b 00                	mov    (%eax),%eax
  800d47:	ba 00 00 00 00       	mov    $0x0,%edx
  800d4c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800d4f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800d52:	8b 45 14             	mov    0x14(%ebp),%eax
  800d55:	8d 40 04             	lea    0x4(%eax),%eax
  800d58:	89 45 14             	mov    %eax,0x14(%ebp)
  800d5b:	eb 9b                	jmp    800cf8 <vprintfmt+0x381>
			putch('0', putdat);
  800d5d:	83 ec 08             	sub    $0x8,%esp
  800d60:	53                   	push   %ebx
  800d61:	6a 30                	push   $0x30
  800d63:	ff d6                	call   *%esi
			putch('x', putdat);
  800d65:	83 c4 08             	add    $0x8,%esp
  800d68:	53                   	push   %ebx
  800d69:	6a 78                	push   $0x78
  800d6b:	ff d6                	call   *%esi
			num = (unsigned long long)
  800d6d:	8b 45 14             	mov    0x14(%ebp),%eax
  800d70:	8b 00                	mov    (%eax),%eax
  800d72:	ba 00 00 00 00       	mov    $0x0,%edx
  800d77:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800d7a:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800d7d:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800d80:	8b 45 14             	mov    0x14(%ebp),%eax
  800d83:	8d 40 04             	lea    0x4(%eax),%eax
  800d86:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800d89:	ba 10 00 00 00       	mov    $0x10,%edx
			printnum(putch, putdat, num, base, width, padc);
  800d8e:	83 ec 0c             	sub    $0xc,%esp
  800d91:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800d95:	50                   	push   %eax
  800d96:	ff 75 e0             	pushl  -0x20(%ebp)
  800d99:	52                   	push   %edx
  800d9a:	ff 75 dc             	pushl  -0x24(%ebp)
  800d9d:	ff 75 d8             	pushl  -0x28(%ebp)
  800da0:	89 da                	mov    %ebx,%edx
  800da2:	89 f0                	mov    %esi,%eax
  800da4:	e8 e5 fa ff ff       	call   80088e <printnum>
			break;
  800da9:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800dac:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800daf:	83 c7 01             	add    $0x1,%edi
  800db2:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800db6:	83 f8 25             	cmp    $0x25,%eax
  800db9:	0f 84 cf fb ff ff    	je     80098e <vprintfmt+0x17>
			if (ch == '\0')
  800dbf:	85 c0                	test   %eax,%eax
  800dc1:	0f 84 a9 00 00 00    	je     800e70 <vprintfmt+0x4f9>
			putch(ch, putdat);
  800dc7:	83 ec 08             	sub    $0x8,%esp
  800dca:	53                   	push   %ebx
  800dcb:	50                   	push   %eax
  800dcc:	ff d6                	call   *%esi
  800dce:	83 c4 10             	add    $0x10,%esp
  800dd1:	eb dc                	jmp    800daf <vprintfmt+0x438>
	if (lflag >= 2)
  800dd3:	83 f9 01             	cmp    $0x1,%ecx
  800dd6:	7e 1e                	jle    800df6 <vprintfmt+0x47f>
		return va_arg(*ap, unsigned long long);
  800dd8:	8b 45 14             	mov    0x14(%ebp),%eax
  800ddb:	8b 50 04             	mov    0x4(%eax),%edx
  800dde:	8b 00                	mov    (%eax),%eax
  800de0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800de3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800de6:	8b 45 14             	mov    0x14(%ebp),%eax
  800de9:	8d 40 08             	lea    0x8(%eax),%eax
  800dec:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800def:	ba 10 00 00 00       	mov    $0x10,%edx
  800df4:	eb 98                	jmp    800d8e <vprintfmt+0x417>
	else if (lflag)
  800df6:	85 c9                	test   %ecx,%ecx
  800df8:	75 23                	jne    800e1d <vprintfmt+0x4a6>
		return va_arg(*ap, unsigned int);
  800dfa:	8b 45 14             	mov    0x14(%ebp),%eax
  800dfd:	8b 00                	mov    (%eax),%eax
  800dff:	ba 00 00 00 00       	mov    $0x0,%edx
  800e04:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800e07:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800e0a:	8b 45 14             	mov    0x14(%ebp),%eax
  800e0d:	8d 40 04             	lea    0x4(%eax),%eax
  800e10:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800e13:	ba 10 00 00 00       	mov    $0x10,%edx
  800e18:	e9 71 ff ff ff       	jmp    800d8e <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  800e1d:	8b 45 14             	mov    0x14(%ebp),%eax
  800e20:	8b 00                	mov    (%eax),%eax
  800e22:	ba 00 00 00 00       	mov    $0x0,%edx
  800e27:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800e2a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800e2d:	8b 45 14             	mov    0x14(%ebp),%eax
  800e30:	8d 40 04             	lea    0x4(%eax),%eax
  800e33:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800e36:	ba 10 00 00 00       	mov    $0x10,%edx
  800e3b:	e9 4e ff ff ff       	jmp    800d8e <vprintfmt+0x417>
			putch(ch, putdat);
  800e40:	83 ec 08             	sub    $0x8,%esp
  800e43:	53                   	push   %ebx
  800e44:	6a 25                	push   $0x25
  800e46:	ff d6                	call   *%esi
			break;
  800e48:	83 c4 10             	add    $0x10,%esp
  800e4b:	e9 5c ff ff ff       	jmp    800dac <vprintfmt+0x435>
			putch('%', putdat);
  800e50:	83 ec 08             	sub    $0x8,%esp
  800e53:	53                   	push   %ebx
  800e54:	6a 25                	push   $0x25
  800e56:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800e58:	83 c4 10             	add    $0x10,%esp
  800e5b:	89 f8                	mov    %edi,%eax
  800e5d:	eb 03                	jmp    800e62 <vprintfmt+0x4eb>
  800e5f:	83 e8 01             	sub    $0x1,%eax
  800e62:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800e66:	75 f7                	jne    800e5f <vprintfmt+0x4e8>
  800e68:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800e6b:	e9 3c ff ff ff       	jmp    800dac <vprintfmt+0x435>
}
  800e70:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e73:	5b                   	pop    %ebx
  800e74:	5e                   	pop    %esi
  800e75:	5f                   	pop    %edi
  800e76:	5d                   	pop    %ebp
  800e77:	c3                   	ret    

00800e78 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e78:	55                   	push   %ebp
  800e79:	89 e5                	mov    %esp,%ebp
  800e7b:	83 ec 18             	sub    $0x18,%esp
  800e7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e81:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e84:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800e87:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800e8b:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800e8e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800e95:	85 c0                	test   %eax,%eax
  800e97:	74 26                	je     800ebf <vsnprintf+0x47>
  800e99:	85 d2                	test   %edx,%edx
  800e9b:	7e 22                	jle    800ebf <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800e9d:	ff 75 14             	pushl  0x14(%ebp)
  800ea0:	ff 75 10             	pushl  0x10(%ebp)
  800ea3:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ea6:	50                   	push   %eax
  800ea7:	68 3d 09 80 00       	push   $0x80093d
  800eac:	e8 c6 fa ff ff       	call   800977 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800eb1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800eb4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800eb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800eba:	83 c4 10             	add    $0x10,%esp
}
  800ebd:	c9                   	leave  
  800ebe:	c3                   	ret    
		return -E_INVAL;
  800ebf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ec4:	eb f7                	jmp    800ebd <vsnprintf+0x45>

00800ec6 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ec6:	55                   	push   %ebp
  800ec7:	89 e5                	mov    %esp,%ebp
  800ec9:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ecc:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800ecf:	50                   	push   %eax
  800ed0:	ff 75 10             	pushl  0x10(%ebp)
  800ed3:	ff 75 0c             	pushl  0xc(%ebp)
  800ed6:	ff 75 08             	pushl  0x8(%ebp)
  800ed9:	e8 9a ff ff ff       	call   800e78 <vsnprintf>
	va_end(ap);

	return rc;
}
  800ede:	c9                   	leave  
  800edf:	c3                   	ret    

00800ee0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800ee0:	55                   	push   %ebp
  800ee1:	89 e5                	mov    %esp,%ebp
  800ee3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800ee6:	b8 00 00 00 00       	mov    $0x0,%eax
  800eeb:	eb 03                	jmp    800ef0 <strlen+0x10>
		n++;
  800eed:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800ef0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800ef4:	75 f7                	jne    800eed <strlen+0xd>
	return n;
}
  800ef6:	5d                   	pop    %ebp
  800ef7:	c3                   	ret    

00800ef8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800ef8:	55                   	push   %ebp
  800ef9:	89 e5                	mov    %esp,%ebp
  800efb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800efe:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f01:	b8 00 00 00 00       	mov    $0x0,%eax
  800f06:	eb 03                	jmp    800f0b <strnlen+0x13>
		n++;
  800f08:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f0b:	39 d0                	cmp    %edx,%eax
  800f0d:	74 06                	je     800f15 <strnlen+0x1d>
  800f0f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800f13:	75 f3                	jne    800f08 <strnlen+0x10>
	return n;
}
  800f15:	5d                   	pop    %ebp
  800f16:	c3                   	ret    

00800f17 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800f17:	55                   	push   %ebp
  800f18:	89 e5                	mov    %esp,%ebp
  800f1a:	53                   	push   %ebx
  800f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800f21:	89 c2                	mov    %eax,%edx
  800f23:	83 c1 01             	add    $0x1,%ecx
  800f26:	83 c2 01             	add    $0x1,%edx
  800f29:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800f2d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800f30:	84 db                	test   %bl,%bl
  800f32:	75 ef                	jne    800f23 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800f34:	5b                   	pop    %ebx
  800f35:	5d                   	pop    %ebp
  800f36:	c3                   	ret    

00800f37 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800f37:	55                   	push   %ebp
  800f38:	89 e5                	mov    %esp,%ebp
  800f3a:	53                   	push   %ebx
  800f3b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800f3e:	53                   	push   %ebx
  800f3f:	e8 9c ff ff ff       	call   800ee0 <strlen>
  800f44:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800f47:	ff 75 0c             	pushl  0xc(%ebp)
  800f4a:	01 d8                	add    %ebx,%eax
  800f4c:	50                   	push   %eax
  800f4d:	e8 c5 ff ff ff       	call   800f17 <strcpy>
	return dst;
}
  800f52:	89 d8                	mov    %ebx,%eax
  800f54:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f57:	c9                   	leave  
  800f58:	c3                   	ret    

00800f59 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800f59:	55                   	push   %ebp
  800f5a:	89 e5                	mov    %esp,%ebp
  800f5c:	56                   	push   %esi
  800f5d:	53                   	push   %ebx
  800f5e:	8b 75 08             	mov    0x8(%ebp),%esi
  800f61:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f64:	89 f3                	mov    %esi,%ebx
  800f66:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f69:	89 f2                	mov    %esi,%edx
  800f6b:	eb 0f                	jmp    800f7c <strncpy+0x23>
		*dst++ = *src;
  800f6d:	83 c2 01             	add    $0x1,%edx
  800f70:	0f b6 01             	movzbl (%ecx),%eax
  800f73:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800f76:	80 39 01             	cmpb   $0x1,(%ecx)
  800f79:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800f7c:	39 da                	cmp    %ebx,%edx
  800f7e:	75 ed                	jne    800f6d <strncpy+0x14>
	}
	return ret;
}
  800f80:	89 f0                	mov    %esi,%eax
  800f82:	5b                   	pop    %ebx
  800f83:	5e                   	pop    %esi
  800f84:	5d                   	pop    %ebp
  800f85:	c3                   	ret    

00800f86 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800f86:	55                   	push   %ebp
  800f87:	89 e5                	mov    %esp,%ebp
  800f89:	56                   	push   %esi
  800f8a:	53                   	push   %ebx
  800f8b:	8b 75 08             	mov    0x8(%ebp),%esi
  800f8e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f91:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800f94:	89 f0                	mov    %esi,%eax
  800f96:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800f9a:	85 c9                	test   %ecx,%ecx
  800f9c:	75 0b                	jne    800fa9 <strlcpy+0x23>
  800f9e:	eb 17                	jmp    800fb7 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800fa0:	83 c2 01             	add    $0x1,%edx
  800fa3:	83 c0 01             	add    $0x1,%eax
  800fa6:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800fa9:	39 d8                	cmp    %ebx,%eax
  800fab:	74 07                	je     800fb4 <strlcpy+0x2e>
  800fad:	0f b6 0a             	movzbl (%edx),%ecx
  800fb0:	84 c9                	test   %cl,%cl
  800fb2:	75 ec                	jne    800fa0 <strlcpy+0x1a>
		*dst = '\0';
  800fb4:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800fb7:	29 f0                	sub    %esi,%eax
}
  800fb9:	5b                   	pop    %ebx
  800fba:	5e                   	pop    %esi
  800fbb:	5d                   	pop    %ebp
  800fbc:	c3                   	ret    

00800fbd <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800fbd:	55                   	push   %ebp
  800fbe:	89 e5                	mov    %esp,%ebp
  800fc0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fc3:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800fc6:	eb 06                	jmp    800fce <strcmp+0x11>
		p++, q++;
  800fc8:	83 c1 01             	add    $0x1,%ecx
  800fcb:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800fce:	0f b6 01             	movzbl (%ecx),%eax
  800fd1:	84 c0                	test   %al,%al
  800fd3:	74 04                	je     800fd9 <strcmp+0x1c>
  800fd5:	3a 02                	cmp    (%edx),%al
  800fd7:	74 ef                	je     800fc8 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800fd9:	0f b6 c0             	movzbl %al,%eax
  800fdc:	0f b6 12             	movzbl (%edx),%edx
  800fdf:	29 d0                	sub    %edx,%eax
}
  800fe1:	5d                   	pop    %ebp
  800fe2:	c3                   	ret    

00800fe3 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800fe3:	55                   	push   %ebp
  800fe4:	89 e5                	mov    %esp,%ebp
  800fe6:	53                   	push   %ebx
  800fe7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fea:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fed:	89 c3                	mov    %eax,%ebx
  800fef:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800ff2:	eb 06                	jmp    800ffa <strncmp+0x17>
		n--, p++, q++;
  800ff4:	83 c0 01             	add    $0x1,%eax
  800ff7:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800ffa:	39 d8                	cmp    %ebx,%eax
  800ffc:	74 16                	je     801014 <strncmp+0x31>
  800ffe:	0f b6 08             	movzbl (%eax),%ecx
  801001:	84 c9                	test   %cl,%cl
  801003:	74 04                	je     801009 <strncmp+0x26>
  801005:	3a 0a                	cmp    (%edx),%cl
  801007:	74 eb                	je     800ff4 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801009:	0f b6 00             	movzbl (%eax),%eax
  80100c:	0f b6 12             	movzbl (%edx),%edx
  80100f:	29 d0                	sub    %edx,%eax
}
  801011:	5b                   	pop    %ebx
  801012:	5d                   	pop    %ebp
  801013:	c3                   	ret    
		return 0;
  801014:	b8 00 00 00 00       	mov    $0x0,%eax
  801019:	eb f6                	jmp    801011 <strncmp+0x2e>

0080101b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80101b:	55                   	push   %ebp
  80101c:	89 e5                	mov    %esp,%ebp
  80101e:	8b 45 08             	mov    0x8(%ebp),%eax
  801021:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801025:	0f b6 10             	movzbl (%eax),%edx
  801028:	84 d2                	test   %dl,%dl
  80102a:	74 09                	je     801035 <strchr+0x1a>
		if (*s == c)
  80102c:	38 ca                	cmp    %cl,%dl
  80102e:	74 0a                	je     80103a <strchr+0x1f>
	for (; *s; s++)
  801030:	83 c0 01             	add    $0x1,%eax
  801033:	eb f0                	jmp    801025 <strchr+0xa>
			return (char *) s;
	return 0;
  801035:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80103a:	5d                   	pop    %ebp
  80103b:	c3                   	ret    

0080103c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80103c:	55                   	push   %ebp
  80103d:	89 e5                	mov    %esp,%ebp
  80103f:	8b 45 08             	mov    0x8(%ebp),%eax
  801042:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801046:	eb 03                	jmp    80104b <strfind+0xf>
  801048:	83 c0 01             	add    $0x1,%eax
  80104b:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  80104e:	38 ca                	cmp    %cl,%dl
  801050:	74 04                	je     801056 <strfind+0x1a>
  801052:	84 d2                	test   %dl,%dl
  801054:	75 f2                	jne    801048 <strfind+0xc>
			break;
	return (char *) s;
}
  801056:	5d                   	pop    %ebp
  801057:	c3                   	ret    

00801058 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801058:	55                   	push   %ebp
  801059:	89 e5                	mov    %esp,%ebp
  80105b:	57                   	push   %edi
  80105c:	56                   	push   %esi
  80105d:	53                   	push   %ebx
  80105e:	8b 7d 08             	mov    0x8(%ebp),%edi
  801061:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801064:	85 c9                	test   %ecx,%ecx
  801066:	74 13                	je     80107b <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801068:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80106e:	75 05                	jne    801075 <memset+0x1d>
  801070:	f6 c1 03             	test   $0x3,%cl
  801073:	74 0d                	je     801082 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801075:	8b 45 0c             	mov    0xc(%ebp),%eax
  801078:	fc                   	cld    
  801079:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80107b:	89 f8                	mov    %edi,%eax
  80107d:	5b                   	pop    %ebx
  80107e:	5e                   	pop    %esi
  80107f:	5f                   	pop    %edi
  801080:	5d                   	pop    %ebp
  801081:	c3                   	ret    
		c &= 0xFF;
  801082:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801086:	89 d3                	mov    %edx,%ebx
  801088:	c1 e3 08             	shl    $0x8,%ebx
  80108b:	89 d0                	mov    %edx,%eax
  80108d:	c1 e0 18             	shl    $0x18,%eax
  801090:	89 d6                	mov    %edx,%esi
  801092:	c1 e6 10             	shl    $0x10,%esi
  801095:	09 f0                	or     %esi,%eax
  801097:	09 c2                	or     %eax,%edx
  801099:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  80109b:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  80109e:	89 d0                	mov    %edx,%eax
  8010a0:	fc                   	cld    
  8010a1:	f3 ab                	rep stos %eax,%es:(%edi)
  8010a3:	eb d6                	jmp    80107b <memset+0x23>

008010a5 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8010a5:	55                   	push   %ebp
  8010a6:	89 e5                	mov    %esp,%ebp
  8010a8:	57                   	push   %edi
  8010a9:	56                   	push   %esi
  8010aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ad:	8b 75 0c             	mov    0xc(%ebp),%esi
  8010b0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8010b3:	39 c6                	cmp    %eax,%esi
  8010b5:	73 35                	jae    8010ec <memmove+0x47>
  8010b7:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8010ba:	39 c2                	cmp    %eax,%edx
  8010bc:	76 2e                	jbe    8010ec <memmove+0x47>
		s += n;
		d += n;
  8010be:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8010c1:	89 d6                	mov    %edx,%esi
  8010c3:	09 fe                	or     %edi,%esi
  8010c5:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8010cb:	74 0c                	je     8010d9 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8010cd:	83 ef 01             	sub    $0x1,%edi
  8010d0:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8010d3:	fd                   	std    
  8010d4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8010d6:	fc                   	cld    
  8010d7:	eb 21                	jmp    8010fa <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8010d9:	f6 c1 03             	test   $0x3,%cl
  8010dc:	75 ef                	jne    8010cd <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8010de:	83 ef 04             	sub    $0x4,%edi
  8010e1:	8d 72 fc             	lea    -0x4(%edx),%esi
  8010e4:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8010e7:	fd                   	std    
  8010e8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8010ea:	eb ea                	jmp    8010d6 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8010ec:	89 f2                	mov    %esi,%edx
  8010ee:	09 c2                	or     %eax,%edx
  8010f0:	f6 c2 03             	test   $0x3,%dl
  8010f3:	74 09                	je     8010fe <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8010f5:	89 c7                	mov    %eax,%edi
  8010f7:	fc                   	cld    
  8010f8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8010fa:	5e                   	pop    %esi
  8010fb:	5f                   	pop    %edi
  8010fc:	5d                   	pop    %ebp
  8010fd:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8010fe:	f6 c1 03             	test   $0x3,%cl
  801101:	75 f2                	jne    8010f5 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801103:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  801106:	89 c7                	mov    %eax,%edi
  801108:	fc                   	cld    
  801109:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80110b:	eb ed                	jmp    8010fa <memmove+0x55>

0080110d <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80110d:	55                   	push   %ebp
  80110e:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  801110:	ff 75 10             	pushl  0x10(%ebp)
  801113:	ff 75 0c             	pushl  0xc(%ebp)
  801116:	ff 75 08             	pushl  0x8(%ebp)
  801119:	e8 87 ff ff ff       	call   8010a5 <memmove>
}
  80111e:	c9                   	leave  
  80111f:	c3                   	ret    

00801120 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801120:	55                   	push   %ebp
  801121:	89 e5                	mov    %esp,%ebp
  801123:	56                   	push   %esi
  801124:	53                   	push   %ebx
  801125:	8b 45 08             	mov    0x8(%ebp),%eax
  801128:	8b 55 0c             	mov    0xc(%ebp),%edx
  80112b:	89 c6                	mov    %eax,%esi
  80112d:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801130:	39 f0                	cmp    %esi,%eax
  801132:	74 1c                	je     801150 <memcmp+0x30>
		if (*s1 != *s2)
  801134:	0f b6 08             	movzbl (%eax),%ecx
  801137:	0f b6 1a             	movzbl (%edx),%ebx
  80113a:	38 d9                	cmp    %bl,%cl
  80113c:	75 08                	jne    801146 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  80113e:	83 c0 01             	add    $0x1,%eax
  801141:	83 c2 01             	add    $0x1,%edx
  801144:	eb ea                	jmp    801130 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  801146:	0f b6 c1             	movzbl %cl,%eax
  801149:	0f b6 db             	movzbl %bl,%ebx
  80114c:	29 d8                	sub    %ebx,%eax
  80114e:	eb 05                	jmp    801155 <memcmp+0x35>
	}

	return 0;
  801150:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801155:	5b                   	pop    %ebx
  801156:	5e                   	pop    %esi
  801157:	5d                   	pop    %ebp
  801158:	c3                   	ret    

00801159 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801159:	55                   	push   %ebp
  80115a:	89 e5                	mov    %esp,%ebp
  80115c:	8b 45 08             	mov    0x8(%ebp),%eax
  80115f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801162:	89 c2                	mov    %eax,%edx
  801164:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801167:	39 d0                	cmp    %edx,%eax
  801169:	73 09                	jae    801174 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  80116b:	38 08                	cmp    %cl,(%eax)
  80116d:	74 05                	je     801174 <memfind+0x1b>
	for (; s < ends; s++)
  80116f:	83 c0 01             	add    $0x1,%eax
  801172:	eb f3                	jmp    801167 <memfind+0xe>
			break;
	return (void *) s;
}
  801174:	5d                   	pop    %ebp
  801175:	c3                   	ret    

00801176 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801176:	55                   	push   %ebp
  801177:	89 e5                	mov    %esp,%ebp
  801179:	57                   	push   %edi
  80117a:	56                   	push   %esi
  80117b:	53                   	push   %ebx
  80117c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80117f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801182:	eb 03                	jmp    801187 <strtol+0x11>
		s++;
  801184:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  801187:	0f b6 01             	movzbl (%ecx),%eax
  80118a:	3c 20                	cmp    $0x20,%al
  80118c:	74 f6                	je     801184 <strtol+0xe>
  80118e:	3c 09                	cmp    $0x9,%al
  801190:	74 f2                	je     801184 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  801192:	3c 2b                	cmp    $0x2b,%al
  801194:	74 2e                	je     8011c4 <strtol+0x4e>
	int neg = 0;
  801196:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  80119b:	3c 2d                	cmp    $0x2d,%al
  80119d:	74 2f                	je     8011ce <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80119f:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  8011a5:	75 05                	jne    8011ac <strtol+0x36>
  8011a7:	80 39 30             	cmpb   $0x30,(%ecx)
  8011aa:	74 2c                	je     8011d8 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  8011ac:	85 db                	test   %ebx,%ebx
  8011ae:	75 0a                	jne    8011ba <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8011b0:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  8011b5:	80 39 30             	cmpb   $0x30,(%ecx)
  8011b8:	74 28                	je     8011e2 <strtol+0x6c>
		base = 10;
  8011ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8011bf:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8011c2:	eb 50                	jmp    801214 <strtol+0x9e>
		s++;
  8011c4:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  8011c7:	bf 00 00 00 00       	mov    $0x0,%edi
  8011cc:	eb d1                	jmp    80119f <strtol+0x29>
		s++, neg = 1;
  8011ce:	83 c1 01             	add    $0x1,%ecx
  8011d1:	bf 01 00 00 00       	mov    $0x1,%edi
  8011d6:	eb c7                	jmp    80119f <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8011d8:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  8011dc:	74 0e                	je     8011ec <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  8011de:	85 db                	test   %ebx,%ebx
  8011e0:	75 d8                	jne    8011ba <strtol+0x44>
		s++, base = 8;
  8011e2:	83 c1 01             	add    $0x1,%ecx
  8011e5:	bb 08 00 00 00       	mov    $0x8,%ebx
  8011ea:	eb ce                	jmp    8011ba <strtol+0x44>
		s += 2, base = 16;
  8011ec:	83 c1 02             	add    $0x2,%ecx
  8011ef:	bb 10 00 00 00       	mov    $0x10,%ebx
  8011f4:	eb c4                	jmp    8011ba <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  8011f6:	8d 72 9f             	lea    -0x61(%edx),%esi
  8011f9:	89 f3                	mov    %esi,%ebx
  8011fb:	80 fb 19             	cmp    $0x19,%bl
  8011fe:	77 29                	ja     801229 <strtol+0xb3>
			dig = *s - 'a' + 10;
  801200:	0f be d2             	movsbl %dl,%edx
  801203:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801206:	3b 55 10             	cmp    0x10(%ebp),%edx
  801209:	7d 30                	jge    80123b <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  80120b:	83 c1 01             	add    $0x1,%ecx
  80120e:	0f af 45 10          	imul   0x10(%ebp),%eax
  801212:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801214:	0f b6 11             	movzbl (%ecx),%edx
  801217:	8d 72 d0             	lea    -0x30(%edx),%esi
  80121a:	89 f3                	mov    %esi,%ebx
  80121c:	80 fb 09             	cmp    $0x9,%bl
  80121f:	77 d5                	ja     8011f6 <strtol+0x80>
			dig = *s - '0';
  801221:	0f be d2             	movsbl %dl,%edx
  801224:	83 ea 30             	sub    $0x30,%edx
  801227:	eb dd                	jmp    801206 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  801229:	8d 72 bf             	lea    -0x41(%edx),%esi
  80122c:	89 f3                	mov    %esi,%ebx
  80122e:	80 fb 19             	cmp    $0x19,%bl
  801231:	77 08                	ja     80123b <strtol+0xc5>
			dig = *s - 'A' + 10;
  801233:	0f be d2             	movsbl %dl,%edx
  801236:	83 ea 37             	sub    $0x37,%edx
  801239:	eb cb                	jmp    801206 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  80123b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80123f:	74 05                	je     801246 <strtol+0xd0>
		*endptr = (char *) s;
  801241:	8b 75 0c             	mov    0xc(%ebp),%esi
  801244:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801246:	89 c2                	mov    %eax,%edx
  801248:	f7 da                	neg    %edx
  80124a:	85 ff                	test   %edi,%edi
  80124c:	0f 45 c2             	cmovne %edx,%eax
}
  80124f:	5b                   	pop    %ebx
  801250:	5e                   	pop    %esi
  801251:	5f                   	pop    %edi
  801252:	5d                   	pop    %ebp
  801253:	c3                   	ret    

00801254 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  801254:	55                   	push   %ebp
  801255:	89 e5                	mov    %esp,%ebp
  801257:	57                   	push   %edi
  801258:	56                   	push   %esi
  801259:	53                   	push   %ebx
	asm volatile("int %1\n"
  80125a:	b8 00 00 00 00       	mov    $0x0,%eax
  80125f:	8b 55 08             	mov    0x8(%ebp),%edx
  801262:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801265:	89 c3                	mov    %eax,%ebx
  801267:	89 c7                	mov    %eax,%edi
  801269:	89 c6                	mov    %eax,%esi
  80126b:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  80126d:	5b                   	pop    %ebx
  80126e:	5e                   	pop    %esi
  80126f:	5f                   	pop    %edi
  801270:	5d                   	pop    %ebp
  801271:	c3                   	ret    

00801272 <sys_cgetc>:

int
sys_cgetc(void)
{
  801272:	55                   	push   %ebp
  801273:	89 e5                	mov    %esp,%ebp
  801275:	57                   	push   %edi
  801276:	56                   	push   %esi
  801277:	53                   	push   %ebx
	asm volatile("int %1\n"
  801278:	ba 00 00 00 00       	mov    $0x0,%edx
  80127d:	b8 01 00 00 00       	mov    $0x1,%eax
  801282:	89 d1                	mov    %edx,%ecx
  801284:	89 d3                	mov    %edx,%ebx
  801286:	89 d7                	mov    %edx,%edi
  801288:	89 d6                	mov    %edx,%esi
  80128a:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  80128c:	5b                   	pop    %ebx
  80128d:	5e                   	pop    %esi
  80128e:	5f                   	pop    %edi
  80128f:	5d                   	pop    %ebp
  801290:	c3                   	ret    

00801291 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801291:	55                   	push   %ebp
  801292:	89 e5                	mov    %esp,%ebp
  801294:	57                   	push   %edi
  801295:	56                   	push   %esi
  801296:	53                   	push   %ebx
  801297:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80129a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80129f:	8b 55 08             	mov    0x8(%ebp),%edx
  8012a2:	b8 03 00 00 00       	mov    $0x3,%eax
  8012a7:	89 cb                	mov    %ecx,%ebx
  8012a9:	89 cf                	mov    %ecx,%edi
  8012ab:	89 ce                	mov    %ecx,%esi
  8012ad:	cd 30                	int    $0x30
	if(check && ret > 0)
  8012af:	85 c0                	test   %eax,%eax
  8012b1:	7f 08                	jg     8012bb <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8012b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012b6:	5b                   	pop    %ebx
  8012b7:	5e                   	pop    %esi
  8012b8:	5f                   	pop    %edi
  8012b9:	5d                   	pop    %ebp
  8012ba:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8012bb:	83 ec 0c             	sub    $0xc,%esp
  8012be:	50                   	push   %eax
  8012bf:	6a 03                	push   $0x3
  8012c1:	68 3f 32 80 00       	push   $0x80323f
  8012c6:	6a 23                	push   $0x23
  8012c8:	68 5c 32 80 00       	push   $0x80325c
  8012cd:	e8 cd f4 ff ff       	call   80079f <_panic>

008012d2 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8012d2:	55                   	push   %ebp
  8012d3:	89 e5                	mov    %esp,%ebp
  8012d5:	57                   	push   %edi
  8012d6:	56                   	push   %esi
  8012d7:	53                   	push   %ebx
	asm volatile("int %1\n"
  8012d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8012dd:	b8 02 00 00 00       	mov    $0x2,%eax
  8012e2:	89 d1                	mov    %edx,%ecx
  8012e4:	89 d3                	mov    %edx,%ebx
  8012e6:	89 d7                	mov    %edx,%edi
  8012e8:	89 d6                	mov    %edx,%esi
  8012ea:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8012ec:	5b                   	pop    %ebx
  8012ed:	5e                   	pop    %esi
  8012ee:	5f                   	pop    %edi
  8012ef:	5d                   	pop    %ebp
  8012f0:	c3                   	ret    

008012f1 <sys_yield>:

void
sys_yield(void)
{
  8012f1:	55                   	push   %ebp
  8012f2:	89 e5                	mov    %esp,%ebp
  8012f4:	57                   	push   %edi
  8012f5:	56                   	push   %esi
  8012f6:	53                   	push   %ebx
	asm volatile("int %1\n"
  8012f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8012fc:	b8 0b 00 00 00       	mov    $0xb,%eax
  801301:	89 d1                	mov    %edx,%ecx
  801303:	89 d3                	mov    %edx,%ebx
  801305:	89 d7                	mov    %edx,%edi
  801307:	89 d6                	mov    %edx,%esi
  801309:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80130b:	5b                   	pop    %ebx
  80130c:	5e                   	pop    %esi
  80130d:	5f                   	pop    %edi
  80130e:	5d                   	pop    %ebp
  80130f:	c3                   	ret    

00801310 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801310:	55                   	push   %ebp
  801311:	89 e5                	mov    %esp,%ebp
  801313:	57                   	push   %edi
  801314:	56                   	push   %esi
  801315:	53                   	push   %ebx
  801316:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801319:	be 00 00 00 00       	mov    $0x0,%esi
  80131e:	8b 55 08             	mov    0x8(%ebp),%edx
  801321:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801324:	b8 04 00 00 00       	mov    $0x4,%eax
  801329:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80132c:	89 f7                	mov    %esi,%edi
  80132e:	cd 30                	int    $0x30
	if(check && ret > 0)
  801330:	85 c0                	test   %eax,%eax
  801332:	7f 08                	jg     80133c <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801334:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801337:	5b                   	pop    %ebx
  801338:	5e                   	pop    %esi
  801339:	5f                   	pop    %edi
  80133a:	5d                   	pop    %ebp
  80133b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80133c:	83 ec 0c             	sub    $0xc,%esp
  80133f:	50                   	push   %eax
  801340:	6a 04                	push   $0x4
  801342:	68 3f 32 80 00       	push   $0x80323f
  801347:	6a 23                	push   $0x23
  801349:	68 5c 32 80 00       	push   $0x80325c
  80134e:	e8 4c f4 ff ff       	call   80079f <_panic>

00801353 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801353:	55                   	push   %ebp
  801354:	89 e5                	mov    %esp,%ebp
  801356:	57                   	push   %edi
  801357:	56                   	push   %esi
  801358:	53                   	push   %ebx
  801359:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80135c:	8b 55 08             	mov    0x8(%ebp),%edx
  80135f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801362:	b8 05 00 00 00       	mov    $0x5,%eax
  801367:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80136a:	8b 7d 14             	mov    0x14(%ebp),%edi
  80136d:	8b 75 18             	mov    0x18(%ebp),%esi
  801370:	cd 30                	int    $0x30
	if(check && ret > 0)
  801372:	85 c0                	test   %eax,%eax
  801374:	7f 08                	jg     80137e <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801376:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801379:	5b                   	pop    %ebx
  80137a:	5e                   	pop    %esi
  80137b:	5f                   	pop    %edi
  80137c:	5d                   	pop    %ebp
  80137d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80137e:	83 ec 0c             	sub    $0xc,%esp
  801381:	50                   	push   %eax
  801382:	6a 05                	push   $0x5
  801384:	68 3f 32 80 00       	push   $0x80323f
  801389:	6a 23                	push   $0x23
  80138b:	68 5c 32 80 00       	push   $0x80325c
  801390:	e8 0a f4 ff ff       	call   80079f <_panic>

00801395 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801395:	55                   	push   %ebp
  801396:	89 e5                	mov    %esp,%ebp
  801398:	57                   	push   %edi
  801399:	56                   	push   %esi
  80139a:	53                   	push   %ebx
  80139b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80139e:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013a3:	8b 55 08             	mov    0x8(%ebp),%edx
  8013a6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013a9:	b8 06 00 00 00       	mov    $0x6,%eax
  8013ae:	89 df                	mov    %ebx,%edi
  8013b0:	89 de                	mov    %ebx,%esi
  8013b2:	cd 30                	int    $0x30
	if(check && ret > 0)
  8013b4:	85 c0                	test   %eax,%eax
  8013b6:	7f 08                	jg     8013c0 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8013b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013bb:	5b                   	pop    %ebx
  8013bc:	5e                   	pop    %esi
  8013bd:	5f                   	pop    %edi
  8013be:	5d                   	pop    %ebp
  8013bf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8013c0:	83 ec 0c             	sub    $0xc,%esp
  8013c3:	50                   	push   %eax
  8013c4:	6a 06                	push   $0x6
  8013c6:	68 3f 32 80 00       	push   $0x80323f
  8013cb:	6a 23                	push   $0x23
  8013cd:	68 5c 32 80 00       	push   $0x80325c
  8013d2:	e8 c8 f3 ff ff       	call   80079f <_panic>

008013d7 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8013d7:	55                   	push   %ebp
  8013d8:	89 e5                	mov    %esp,%ebp
  8013da:	57                   	push   %edi
  8013db:	56                   	push   %esi
  8013dc:	53                   	push   %ebx
  8013dd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8013e0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8013e8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013eb:	b8 08 00 00 00       	mov    $0x8,%eax
  8013f0:	89 df                	mov    %ebx,%edi
  8013f2:	89 de                	mov    %ebx,%esi
  8013f4:	cd 30                	int    $0x30
	if(check && ret > 0)
  8013f6:	85 c0                	test   %eax,%eax
  8013f8:	7f 08                	jg     801402 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8013fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013fd:	5b                   	pop    %ebx
  8013fe:	5e                   	pop    %esi
  8013ff:	5f                   	pop    %edi
  801400:	5d                   	pop    %ebp
  801401:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801402:	83 ec 0c             	sub    $0xc,%esp
  801405:	50                   	push   %eax
  801406:	6a 08                	push   $0x8
  801408:	68 3f 32 80 00       	push   $0x80323f
  80140d:	6a 23                	push   $0x23
  80140f:	68 5c 32 80 00       	push   $0x80325c
  801414:	e8 86 f3 ff ff       	call   80079f <_panic>

00801419 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801419:	55                   	push   %ebp
  80141a:	89 e5                	mov    %esp,%ebp
  80141c:	57                   	push   %edi
  80141d:	56                   	push   %esi
  80141e:	53                   	push   %ebx
  80141f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801422:	bb 00 00 00 00       	mov    $0x0,%ebx
  801427:	8b 55 08             	mov    0x8(%ebp),%edx
  80142a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80142d:	b8 09 00 00 00       	mov    $0x9,%eax
  801432:	89 df                	mov    %ebx,%edi
  801434:	89 de                	mov    %ebx,%esi
  801436:	cd 30                	int    $0x30
	if(check && ret > 0)
  801438:	85 c0                	test   %eax,%eax
  80143a:	7f 08                	jg     801444 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80143c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80143f:	5b                   	pop    %ebx
  801440:	5e                   	pop    %esi
  801441:	5f                   	pop    %edi
  801442:	5d                   	pop    %ebp
  801443:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801444:	83 ec 0c             	sub    $0xc,%esp
  801447:	50                   	push   %eax
  801448:	6a 09                	push   $0x9
  80144a:	68 3f 32 80 00       	push   $0x80323f
  80144f:	6a 23                	push   $0x23
  801451:	68 5c 32 80 00       	push   $0x80325c
  801456:	e8 44 f3 ff ff       	call   80079f <_panic>

0080145b <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80145b:	55                   	push   %ebp
  80145c:	89 e5                	mov    %esp,%ebp
  80145e:	57                   	push   %edi
  80145f:	56                   	push   %esi
  801460:	53                   	push   %ebx
  801461:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801464:	bb 00 00 00 00       	mov    $0x0,%ebx
  801469:	8b 55 08             	mov    0x8(%ebp),%edx
  80146c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80146f:	b8 0a 00 00 00       	mov    $0xa,%eax
  801474:	89 df                	mov    %ebx,%edi
  801476:	89 de                	mov    %ebx,%esi
  801478:	cd 30                	int    $0x30
	if(check && ret > 0)
  80147a:	85 c0                	test   %eax,%eax
  80147c:	7f 08                	jg     801486 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80147e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801481:	5b                   	pop    %ebx
  801482:	5e                   	pop    %esi
  801483:	5f                   	pop    %edi
  801484:	5d                   	pop    %ebp
  801485:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801486:	83 ec 0c             	sub    $0xc,%esp
  801489:	50                   	push   %eax
  80148a:	6a 0a                	push   $0xa
  80148c:	68 3f 32 80 00       	push   $0x80323f
  801491:	6a 23                	push   $0x23
  801493:	68 5c 32 80 00       	push   $0x80325c
  801498:	e8 02 f3 ff ff       	call   80079f <_panic>

0080149d <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80149d:	55                   	push   %ebp
  80149e:	89 e5                	mov    %esp,%ebp
  8014a0:	57                   	push   %edi
  8014a1:	56                   	push   %esi
  8014a2:	53                   	push   %ebx
	asm volatile("int %1\n"
  8014a3:	8b 55 08             	mov    0x8(%ebp),%edx
  8014a6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014a9:	b8 0c 00 00 00       	mov    $0xc,%eax
  8014ae:	be 00 00 00 00       	mov    $0x0,%esi
  8014b3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8014b6:	8b 7d 14             	mov    0x14(%ebp),%edi
  8014b9:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8014bb:	5b                   	pop    %ebx
  8014bc:	5e                   	pop    %esi
  8014bd:	5f                   	pop    %edi
  8014be:	5d                   	pop    %ebp
  8014bf:	c3                   	ret    

008014c0 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8014c0:	55                   	push   %ebp
  8014c1:	89 e5                	mov    %esp,%ebp
  8014c3:	57                   	push   %edi
  8014c4:	56                   	push   %esi
  8014c5:	53                   	push   %ebx
  8014c6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8014c9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8014ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8014d1:	b8 0d 00 00 00       	mov    $0xd,%eax
  8014d6:	89 cb                	mov    %ecx,%ebx
  8014d8:	89 cf                	mov    %ecx,%edi
  8014da:	89 ce                	mov    %ecx,%esi
  8014dc:	cd 30                	int    $0x30
	if(check && ret > 0)
  8014de:	85 c0                	test   %eax,%eax
  8014e0:	7f 08                	jg     8014ea <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8014e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014e5:	5b                   	pop    %ebx
  8014e6:	5e                   	pop    %esi
  8014e7:	5f                   	pop    %edi
  8014e8:	5d                   	pop    %ebp
  8014e9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8014ea:	83 ec 0c             	sub    $0xc,%esp
  8014ed:	50                   	push   %eax
  8014ee:	6a 0d                	push   $0xd
  8014f0:	68 3f 32 80 00       	push   $0x80323f
  8014f5:	6a 23                	push   $0x23
  8014f7:	68 5c 32 80 00       	push   $0x80325c
  8014fc:	e8 9e f2 ff ff       	call   80079f <_panic>

00801501 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801501:	55                   	push   %ebp
  801502:	89 e5                	mov    %esp,%ebp
  801504:	57                   	push   %edi
  801505:	56                   	push   %esi
  801506:	53                   	push   %ebx
	asm volatile("int %1\n"
  801507:	ba 00 00 00 00       	mov    $0x0,%edx
  80150c:	b8 0e 00 00 00       	mov    $0xe,%eax
  801511:	89 d1                	mov    %edx,%ecx
  801513:	89 d3                	mov    %edx,%ebx
  801515:	89 d7                	mov    %edx,%edi
  801517:	89 d6                	mov    %edx,%esi
  801519:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  80151b:	5b                   	pop    %ebx
  80151c:	5e                   	pop    %esi
  80151d:	5f                   	pop    %edi
  80151e:	5d                   	pop    %ebp
  80151f:	c3                   	ret    

00801520 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801520:	55                   	push   %ebp
  801521:	89 e5                	mov    %esp,%ebp
  801523:	57                   	push   %edi
  801524:	56                   	push   %esi
  801525:	53                   	push   %ebx
  801526:	83 ec 1c             	sub    $0x1c,%esp
  801529:	8b 45 08             	mov    0x8(%ebp),%eax
    void *addr = (void *) utf->utf_fault_va;
  80152c:	8b 18                	mov    (%eax),%ebx
    uint32_t err = utf->utf_err;
  80152e:	8b 78 04             	mov    0x4(%eax),%edi
    pte_t pte = uvpt[PGNUM(addr)];
  801531:	89 d8                	mov    %ebx,%eax
  801533:	c1 e8 0c             	shr    $0xc,%eax
  801536:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80153d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    envid_t envid = sys_getenvid();
  801540:	e8 8d fd ff ff       	call   8012d2 <sys_getenvid>
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if ((err & FEC_WR) == 0 || (pte & PTE_COW) == 0) {
  801545:	f7 c7 02 00 00 00    	test   $0x2,%edi
  80154b:	74 73                	je     8015c0 <pgfault+0xa0>
  80154d:	89 c6                	mov    %eax,%esi
  80154f:	f7 45 e4 00 08 00 00 	testl  $0x800,-0x1c(%ebp)
  801556:	74 68                	je     8015c0 <pgfault+0xa0>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	if ((r = sys_page_alloc(envid, PFTEMP, PTE_W | PTE_U | PTE_P)) != 0) {
  801558:	83 ec 04             	sub    $0x4,%esp
  80155b:	6a 07                	push   $0x7
  80155d:	68 00 f0 7f 00       	push   $0x7ff000
  801562:	50                   	push   %eax
  801563:	e8 a8 fd ff ff       	call   801310 <sys_page_alloc>
  801568:	83 c4 10             	add    $0x10,%esp
  80156b:	85 c0                	test   %eax,%eax
  80156d:	75 65                	jne    8015d4 <pgfault+0xb4>
	    panic("pgfault: %e", r);
	}
	memcpy(PFTEMP, ROUNDDOWN(addr, PGSIZE), PGSIZE);
  80156f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  801575:	83 ec 04             	sub    $0x4,%esp
  801578:	68 00 10 00 00       	push   $0x1000
  80157d:	53                   	push   %ebx
  80157e:	68 00 f0 7f 00       	push   $0x7ff000
  801583:	e8 85 fb ff ff       	call   80110d <memcpy>
	if ((r = sys_page_map(envid, PFTEMP, envid, ROUNDDOWN(addr, PGSIZE), PTE_W | PTE_U | PTE_P)) != 0) {
  801588:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  80158f:	53                   	push   %ebx
  801590:	56                   	push   %esi
  801591:	68 00 f0 7f 00       	push   $0x7ff000
  801596:	56                   	push   %esi
  801597:	e8 b7 fd ff ff       	call   801353 <sys_page_map>
  80159c:	83 c4 20             	add    $0x20,%esp
  80159f:	85 c0                	test   %eax,%eax
  8015a1:	75 43                	jne    8015e6 <pgfault+0xc6>
	    panic("pgfault: %e", r);
	}
	if ((r = sys_page_unmap(envid, PFTEMP)) != 0) {
  8015a3:	83 ec 08             	sub    $0x8,%esp
  8015a6:	68 00 f0 7f 00       	push   $0x7ff000
  8015ab:	56                   	push   %esi
  8015ac:	e8 e4 fd ff ff       	call   801395 <sys_page_unmap>
  8015b1:	83 c4 10             	add    $0x10,%esp
  8015b4:	85 c0                	test   %eax,%eax
  8015b6:	75 40                	jne    8015f8 <pgfault+0xd8>
	    panic("pgfault: %e", r);
	}
}
  8015b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015bb:	5b                   	pop    %ebx
  8015bc:	5e                   	pop    %esi
  8015bd:	5f                   	pop    %edi
  8015be:	5d                   	pop    %ebp
  8015bf:	c3                   	ret    
	    panic("pgfault: bad faulting access\n");
  8015c0:	83 ec 04             	sub    $0x4,%esp
  8015c3:	68 6a 32 80 00       	push   $0x80326a
  8015c8:	6a 1f                	push   $0x1f
  8015ca:	68 88 32 80 00       	push   $0x803288
  8015cf:	e8 cb f1 ff ff       	call   80079f <_panic>
	    panic("pgfault: %e", r);
  8015d4:	50                   	push   %eax
  8015d5:	68 93 32 80 00       	push   $0x803293
  8015da:	6a 2a                	push   $0x2a
  8015dc:	68 88 32 80 00       	push   $0x803288
  8015e1:	e8 b9 f1 ff ff       	call   80079f <_panic>
	    panic("pgfault: %e", r);
  8015e6:	50                   	push   %eax
  8015e7:	68 93 32 80 00       	push   $0x803293
  8015ec:	6a 2e                	push   $0x2e
  8015ee:	68 88 32 80 00       	push   $0x803288
  8015f3:	e8 a7 f1 ff ff       	call   80079f <_panic>
	    panic("pgfault: %e", r);
  8015f8:	50                   	push   %eax
  8015f9:	68 93 32 80 00       	push   $0x803293
  8015fe:	6a 31                	push   $0x31
  801600:	68 88 32 80 00       	push   $0x803288
  801605:	e8 95 f1 ff ff       	call   80079f <_panic>

0080160a <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80160a:	55                   	push   %ebp
  80160b:	89 e5                	mov    %esp,%ebp
  80160d:	57                   	push   %edi
  80160e:	56                   	push   %esi
  80160f:	53                   	push   %ebx
  801610:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	envid_t envid;
	uint32_t addr;
	int r;

	set_pgfault_handler(pgfault);
  801613:	68 20 15 80 00       	push   $0x801520
  801618:	e8 89 14 00 00       	call   802aa6 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  80161d:	b8 07 00 00 00       	mov    $0x7,%eax
  801622:	cd 30                	int    $0x30
  801624:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801627:	89 45 e0             	mov    %eax,-0x20(%ebp)
	envid = sys_exofork();
	if (envid < 0) {
  80162a:	83 c4 10             	add    $0x10,%esp
  80162d:	85 c0                	test   %eax,%eax
  80162f:	78 2b                	js     80165c <fork+0x52>
	    thisenv = &envs[ENVX(sys_getenvid())];
	    return 0;
	}

	// copy the address space mappings to child
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  801631:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {
  801636:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80163a:	0f 85 b5 00 00 00    	jne    8016f5 <fork+0xeb>
	    thisenv = &envs[ENVX(sys_getenvid())];
  801640:	e8 8d fc ff ff       	call   8012d2 <sys_getenvid>
  801645:	25 ff 03 00 00       	and    $0x3ff,%eax
  80164a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80164d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801652:	a3 20 50 80 00       	mov    %eax,0x805020
	    return 0;
  801657:	e9 8c 01 00 00       	jmp    8017e8 <fork+0x1de>
	    panic("sys_exofork: %e", envid);
  80165c:	50                   	push   %eax
  80165d:	68 9f 32 80 00       	push   $0x80329f
  801662:	6a 77                	push   $0x77
  801664:	68 88 32 80 00       	push   $0x803288
  801669:	e8 31 f1 ff ff       	call   80079f <_panic>
        if ((r = sys_page_map(parent_envid, va, envid, va, uvpt[pn] & PTE_SYSCALL)) != 0) {
  80166e:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801675:	83 ec 0c             	sub    $0xc,%esp
  801678:	25 07 0e 00 00       	and    $0xe07,%eax
  80167d:	50                   	push   %eax
  80167e:	57                   	push   %edi
  80167f:	ff 75 e0             	pushl  -0x20(%ebp)
  801682:	57                   	push   %edi
  801683:	ff 75 e4             	pushl  -0x1c(%ebp)
  801686:	e8 c8 fc ff ff       	call   801353 <sys_page_map>
  80168b:	83 c4 20             	add    $0x20,%esp
  80168e:	85 c0                	test   %eax,%eax
  801690:	74 51                	je     8016e3 <fork+0xd9>
           panic("duppage: %e", r);
  801692:	50                   	push   %eax
  801693:	68 af 32 80 00       	push   $0x8032af
  801698:	6a 4a                	push   $0x4a
  80169a:	68 88 32 80 00       	push   $0x803288
  80169f:	e8 fb f0 ff ff       	call   80079f <_panic>
	    if ((r = sys_page_map(parent_envid, va, envid, va, PTE_COW | PTE_U | PTE_P)) != 0) {
  8016a4:	83 ec 0c             	sub    $0xc,%esp
  8016a7:	68 05 08 00 00       	push   $0x805
  8016ac:	57                   	push   %edi
  8016ad:	ff 75 e0             	pushl  -0x20(%ebp)
  8016b0:	57                   	push   %edi
  8016b1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8016b4:	e8 9a fc ff ff       	call   801353 <sys_page_map>
  8016b9:	83 c4 20             	add    $0x20,%esp
  8016bc:	85 c0                	test   %eax,%eax
  8016be:	0f 85 bc 00 00 00    	jne    801780 <fork+0x176>
	    if ((r = sys_page_map(parent_envid, va, parent_envid, va, PTE_COW | PTE_U | PTE_P)) != 0) {
  8016c4:	83 ec 0c             	sub    $0xc,%esp
  8016c7:	68 05 08 00 00       	push   $0x805
  8016cc:	57                   	push   %edi
  8016cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016d0:	50                   	push   %eax
  8016d1:	57                   	push   %edi
  8016d2:	50                   	push   %eax
  8016d3:	e8 7b fc ff ff       	call   801353 <sys_page_map>
  8016d8:	83 c4 20             	add    $0x20,%esp
  8016db:	85 c0                	test   %eax,%eax
  8016dd:	0f 85 af 00 00 00    	jne    801792 <fork+0x188>
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  8016e3:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8016e9:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8016ef:	0f 84 af 00 00 00    	je     8017a4 <fork+0x19a>
	    if ((uvpd[PDX(addr)] & PTE_P) == PTE_P && (uvpt[PGNUM(addr)] & PTE_P) == PTE_P) {
  8016f5:	89 d8                	mov    %ebx,%eax
  8016f7:	c1 e8 16             	shr    $0x16,%eax
  8016fa:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801701:	a8 01                	test   $0x1,%al
  801703:	74 de                	je     8016e3 <fork+0xd9>
  801705:	89 de                	mov    %ebx,%esi
  801707:	c1 ee 0c             	shr    $0xc,%esi
  80170a:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801711:	a8 01                	test   $0x1,%al
  801713:	74 ce                	je     8016e3 <fork+0xd9>
	envid_t parent_envid = sys_getenvid();
  801715:	e8 b8 fb ff ff       	call   8012d2 <sys_getenvid>
  80171a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	void *va = (void *)(pn * PGSIZE);
  80171d:	89 f7                	mov    %esi,%edi
  80171f:	c1 e7 0c             	shl    $0xc,%edi
	if ((uvpt[pn] & PTE_SHARE) == PTE_SHARE) {
  801722:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801729:	f6 c4 04             	test   $0x4,%ah
  80172c:	0f 85 3c ff ff ff    	jne    80166e <fork+0x64>
    } else if ((uvpt[pn] & PTE_W) == PTE_W || (uvpt[pn] & PTE_COW) == PTE_COW) {
  801732:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801739:	a8 02                	test   $0x2,%al
  80173b:	0f 85 63 ff ff ff    	jne    8016a4 <fork+0x9a>
  801741:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801748:	f6 c4 08             	test   $0x8,%ah
  80174b:	0f 85 53 ff ff ff    	jne    8016a4 <fork+0x9a>
	    if ((r = sys_page_map(parent_envid, va, envid, va, PTE_U | PTE_P)) != 0) {
  801751:	83 ec 0c             	sub    $0xc,%esp
  801754:	6a 05                	push   $0x5
  801756:	57                   	push   %edi
  801757:	ff 75 e0             	pushl  -0x20(%ebp)
  80175a:	57                   	push   %edi
  80175b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80175e:	e8 f0 fb ff ff       	call   801353 <sys_page_map>
  801763:	83 c4 20             	add    $0x20,%esp
  801766:	85 c0                	test   %eax,%eax
  801768:	0f 84 75 ff ff ff    	je     8016e3 <fork+0xd9>
	        panic("duppage: %e", r);
  80176e:	50                   	push   %eax
  80176f:	68 af 32 80 00       	push   $0x8032af
  801774:	6a 55                	push   $0x55
  801776:	68 88 32 80 00       	push   $0x803288
  80177b:	e8 1f f0 ff ff       	call   80079f <_panic>
	        panic("duppage: %e", r);
  801780:	50                   	push   %eax
  801781:	68 af 32 80 00       	push   $0x8032af
  801786:	6a 4e                	push   $0x4e
  801788:	68 88 32 80 00       	push   $0x803288
  80178d:	e8 0d f0 ff ff       	call   80079f <_panic>
	        panic("duppage: %e", r);
  801792:	50                   	push   %eax
  801793:	68 af 32 80 00       	push   $0x8032af
  801798:	6a 51                	push   $0x51
  80179a:	68 88 32 80 00       	push   $0x803288
  80179f:	e8 fb ef ff ff       	call   80079f <_panic>
	}

	// allocate new page for child's user exception stack
	void _pgfault_upcall();

	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P)) != 0) {
  8017a4:	83 ec 04             	sub    $0x4,%esp
  8017a7:	6a 07                	push   $0x7
  8017a9:	68 00 f0 bf ee       	push   $0xeebff000
  8017ae:	ff 75 dc             	pushl  -0x24(%ebp)
  8017b1:	e8 5a fb ff ff       	call   801310 <sys_page_alloc>
  8017b6:	83 c4 10             	add    $0x10,%esp
  8017b9:	85 c0                	test   %eax,%eax
  8017bb:	75 36                	jne    8017f3 <fork+0x1e9>
	    panic("fork: %e", r);
	}
	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) != 0) {
  8017bd:	83 ec 08             	sub    $0x8,%esp
  8017c0:	68 1f 2b 80 00       	push   $0x802b1f
  8017c5:	ff 75 dc             	pushl  -0x24(%ebp)
  8017c8:	e8 8e fc ff ff       	call   80145b <sys_env_set_pgfault_upcall>
  8017cd:	83 c4 10             	add    $0x10,%esp
  8017d0:	85 c0                	test   %eax,%eax
  8017d2:	75 34                	jne    801808 <fork+0x1fe>
	    panic("fork: %e", r);
	}

	// mark the child as runnable
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) != 0)
  8017d4:	83 ec 08             	sub    $0x8,%esp
  8017d7:	6a 02                	push   $0x2
  8017d9:	ff 75 dc             	pushl  -0x24(%ebp)
  8017dc:	e8 f6 fb ff ff       	call   8013d7 <sys_env_set_status>
  8017e1:	83 c4 10             	add    $0x10,%esp
  8017e4:	85 c0                	test   %eax,%eax
  8017e6:	75 35                	jne    80181d <fork+0x213>
	    panic("fork: %e", r);

	return envid;
}
  8017e8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8017eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017ee:	5b                   	pop    %ebx
  8017ef:	5e                   	pop    %esi
  8017f0:	5f                   	pop    %edi
  8017f1:	5d                   	pop    %ebp
  8017f2:	c3                   	ret    
	    panic("fork: %e", r);
  8017f3:	50                   	push   %eax
  8017f4:	68 a6 32 80 00       	push   $0x8032a6
  8017f9:	68 8a 00 00 00       	push   $0x8a
  8017fe:	68 88 32 80 00       	push   $0x803288
  801803:	e8 97 ef ff ff       	call   80079f <_panic>
	    panic("fork: %e", r);
  801808:	50                   	push   %eax
  801809:	68 a6 32 80 00       	push   $0x8032a6
  80180e:	68 8d 00 00 00       	push   $0x8d
  801813:	68 88 32 80 00       	push   $0x803288
  801818:	e8 82 ef ff ff       	call   80079f <_panic>
	    panic("fork: %e", r);
  80181d:	50                   	push   %eax
  80181e:	68 a6 32 80 00       	push   $0x8032a6
  801823:	68 92 00 00 00       	push   $0x92
  801828:	68 88 32 80 00       	push   $0x803288
  80182d:	e8 6d ef ff ff       	call   80079f <_panic>

00801832 <sfork>:

// Challenge!
int
sfork(void)
{
  801832:	55                   	push   %ebp
  801833:	89 e5                	mov    %esp,%ebp
  801835:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801838:	68 bb 32 80 00       	push   $0x8032bb
  80183d:	68 9b 00 00 00       	push   $0x9b
  801842:	68 88 32 80 00       	push   $0x803288
  801847:	e8 53 ef ff ff       	call   80079f <_panic>

0080184c <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80184c:	55                   	push   %ebp
  80184d:	89 e5                	mov    %esp,%ebp
  80184f:	56                   	push   %esi
  801850:	53                   	push   %ebx
  801851:	8b 75 08             	mov    0x8(%ebp),%esi
  801854:	8b 45 0c             	mov    0xc(%ebp),%eax
  801857:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
  80185a:	85 c0                	test   %eax,%eax
	    pg = (void *)UTOP;
  80185c:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801861:	0f 44 c2             	cmove  %edx,%eax
	}
	if ((r = sys_ipc_recv(pg)) < 0) {
  801864:	83 ec 0c             	sub    $0xc,%esp
  801867:	50                   	push   %eax
  801868:	e8 53 fc ff ff       	call   8014c0 <sys_ipc_recv>
  80186d:	83 c4 10             	add    $0x10,%esp
  801870:	85 c0                	test   %eax,%eax
  801872:	78 2b                	js     80189f <ipc_recv+0x53>
	    if (perm_store != NULL) {
	        *perm_store = 0;
	    }
	    return r;
	}
	if (from_env_store != NULL) {
  801874:	85 f6                	test   %esi,%esi
  801876:	74 0a                	je     801882 <ipc_recv+0x36>
	    *from_env_store = thisenv->env_ipc_from;
  801878:	a1 20 50 80 00       	mov    0x805020,%eax
  80187d:	8b 40 74             	mov    0x74(%eax),%eax
  801880:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store != NULL) {
  801882:	85 db                	test   %ebx,%ebx
  801884:	74 0a                	je     801890 <ipc_recv+0x44>
	    *perm_store = thisenv->env_ipc_perm;
  801886:	a1 20 50 80 00       	mov    0x805020,%eax
  80188b:	8b 40 78             	mov    0x78(%eax),%eax
  80188e:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  801890:	a1 20 50 80 00       	mov    0x805020,%eax
  801895:	8b 40 70             	mov    0x70(%eax),%eax
}
  801898:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80189b:	5b                   	pop    %ebx
  80189c:	5e                   	pop    %esi
  80189d:	5d                   	pop    %ebp
  80189e:	c3                   	ret    
	    if (from_env_store != NULL) {
  80189f:	85 f6                	test   %esi,%esi
  8018a1:	74 06                	je     8018a9 <ipc_recv+0x5d>
	        *from_env_store = 0;
  8018a3:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	    if (perm_store != NULL) {
  8018a9:	85 db                	test   %ebx,%ebx
  8018ab:	74 eb                	je     801898 <ipc_recv+0x4c>
	        *perm_store = 0;
  8018ad:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8018b3:	eb e3                	jmp    801898 <ipc_recv+0x4c>

008018b5 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8018b5:	55                   	push   %ebp
  8018b6:	89 e5                	mov    %esp,%ebp
  8018b8:	57                   	push   %edi
  8018b9:	56                   	push   %esi
  8018ba:	53                   	push   %ebx
  8018bb:	83 ec 0c             	sub    $0xc,%esp
  8018be:	8b 7d 08             	mov    0x8(%ebp),%edi
  8018c1:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
	    pg = (void *)UTOP;
  8018c4:	85 f6                	test   %esi,%esi
  8018c6:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8018cb:	0f 44 f0             	cmove  %eax,%esi
  8018ce:	eb 09                	jmp    8018d9 <ipc_send+0x24>
	do {
	    r = sys_ipc_try_send(to_env, val, pg, perm);
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
	        panic("ipc_send: %e", r);
	    }
	    sys_yield();
  8018d0:	e8 1c fa ff ff       	call   8012f1 <sys_yield>
	} while(r != 0);
  8018d5:	85 db                	test   %ebx,%ebx
  8018d7:	74 2d                	je     801906 <ipc_send+0x51>
	    r = sys_ipc_try_send(to_env, val, pg, perm);
  8018d9:	ff 75 14             	pushl  0x14(%ebp)
  8018dc:	56                   	push   %esi
  8018dd:	ff 75 0c             	pushl  0xc(%ebp)
  8018e0:	57                   	push   %edi
  8018e1:	e8 b7 fb ff ff       	call   80149d <sys_ipc_try_send>
  8018e6:	89 c3                	mov    %eax,%ebx
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
  8018e8:	83 c4 10             	add    $0x10,%esp
  8018eb:	85 c0                	test   %eax,%eax
  8018ed:	79 e1                	jns    8018d0 <ipc_send+0x1b>
  8018ef:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8018f2:	74 dc                	je     8018d0 <ipc_send+0x1b>
	        panic("ipc_send: %e", r);
  8018f4:	50                   	push   %eax
  8018f5:	68 d1 32 80 00       	push   $0x8032d1
  8018fa:	6a 45                	push   $0x45
  8018fc:	68 de 32 80 00       	push   $0x8032de
  801901:	e8 99 ee ff ff       	call   80079f <_panic>
}
  801906:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801909:	5b                   	pop    %ebx
  80190a:	5e                   	pop    %esi
  80190b:	5f                   	pop    %edi
  80190c:	5d                   	pop    %ebp
  80190d:	c3                   	ret    

0080190e <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80190e:	55                   	push   %ebp
  80190f:	89 e5                	mov    %esp,%ebp
  801911:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801914:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801919:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80191c:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801922:	8b 52 50             	mov    0x50(%edx),%edx
  801925:	39 ca                	cmp    %ecx,%edx
  801927:	74 11                	je     80193a <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  801929:	83 c0 01             	add    $0x1,%eax
  80192c:	3d 00 04 00 00       	cmp    $0x400,%eax
  801931:	75 e6                	jne    801919 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801933:	b8 00 00 00 00       	mov    $0x0,%eax
  801938:	eb 0b                	jmp    801945 <ipc_find_env+0x37>
			return envs[i].env_id;
  80193a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80193d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801942:	8b 40 48             	mov    0x48(%eax),%eax
}
  801945:	5d                   	pop    %ebp
  801946:	c3                   	ret    

00801947 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801947:	55                   	push   %ebp
  801948:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80194a:	8b 45 08             	mov    0x8(%ebp),%eax
  80194d:	05 00 00 00 30       	add    $0x30000000,%eax
  801952:	c1 e8 0c             	shr    $0xc,%eax
}
  801955:	5d                   	pop    %ebp
  801956:	c3                   	ret    

00801957 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801957:	55                   	push   %ebp
  801958:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80195a:	8b 45 08             	mov    0x8(%ebp),%eax
  80195d:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801962:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801967:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80196c:	5d                   	pop    %ebp
  80196d:	c3                   	ret    

0080196e <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80196e:	55                   	push   %ebp
  80196f:	89 e5                	mov    %esp,%ebp
  801971:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801974:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801979:	89 c2                	mov    %eax,%edx
  80197b:	c1 ea 16             	shr    $0x16,%edx
  80197e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801985:	f6 c2 01             	test   $0x1,%dl
  801988:	74 2a                	je     8019b4 <fd_alloc+0x46>
  80198a:	89 c2                	mov    %eax,%edx
  80198c:	c1 ea 0c             	shr    $0xc,%edx
  80198f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801996:	f6 c2 01             	test   $0x1,%dl
  801999:	74 19                	je     8019b4 <fd_alloc+0x46>
  80199b:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8019a0:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8019a5:	75 d2                	jne    801979 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8019a7:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8019ad:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8019b2:	eb 07                	jmp    8019bb <fd_alloc+0x4d>
			*fd_store = fd;
  8019b4:	89 01                	mov    %eax,(%ecx)
			return 0;
  8019b6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019bb:	5d                   	pop    %ebp
  8019bc:	c3                   	ret    

008019bd <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8019bd:	55                   	push   %ebp
  8019be:	89 e5                	mov    %esp,%ebp
  8019c0:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8019c3:	83 f8 1f             	cmp    $0x1f,%eax
  8019c6:	77 36                	ja     8019fe <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8019c8:	c1 e0 0c             	shl    $0xc,%eax
  8019cb:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8019d0:	89 c2                	mov    %eax,%edx
  8019d2:	c1 ea 16             	shr    $0x16,%edx
  8019d5:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8019dc:	f6 c2 01             	test   $0x1,%dl
  8019df:	74 24                	je     801a05 <fd_lookup+0x48>
  8019e1:	89 c2                	mov    %eax,%edx
  8019e3:	c1 ea 0c             	shr    $0xc,%edx
  8019e6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8019ed:	f6 c2 01             	test   $0x1,%dl
  8019f0:	74 1a                	je     801a0c <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8019f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019f5:	89 02                	mov    %eax,(%edx)
	return 0;
  8019f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019fc:	5d                   	pop    %ebp
  8019fd:	c3                   	ret    
		return -E_INVAL;
  8019fe:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a03:	eb f7                	jmp    8019fc <fd_lookup+0x3f>
		return -E_INVAL;
  801a05:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a0a:	eb f0                	jmp    8019fc <fd_lookup+0x3f>
  801a0c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a11:	eb e9                	jmp    8019fc <fd_lookup+0x3f>

00801a13 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801a13:	55                   	push   %ebp
  801a14:	89 e5                	mov    %esp,%ebp
  801a16:	83 ec 08             	sub    $0x8,%esp
  801a19:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a1c:	ba 64 33 80 00       	mov    $0x803364,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801a21:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801a26:	39 08                	cmp    %ecx,(%eax)
  801a28:	74 33                	je     801a5d <dev_lookup+0x4a>
  801a2a:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801a2d:	8b 02                	mov    (%edx),%eax
  801a2f:	85 c0                	test   %eax,%eax
  801a31:	75 f3                	jne    801a26 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801a33:	a1 20 50 80 00       	mov    0x805020,%eax
  801a38:	8b 40 48             	mov    0x48(%eax),%eax
  801a3b:	83 ec 04             	sub    $0x4,%esp
  801a3e:	51                   	push   %ecx
  801a3f:	50                   	push   %eax
  801a40:	68 e8 32 80 00       	push   $0x8032e8
  801a45:	e8 30 ee ff ff       	call   80087a <cprintf>
	*dev = 0;
  801a4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a4d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801a53:	83 c4 10             	add    $0x10,%esp
  801a56:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801a5b:	c9                   	leave  
  801a5c:	c3                   	ret    
			*dev = devtab[i];
  801a5d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a60:	89 01                	mov    %eax,(%ecx)
			return 0;
  801a62:	b8 00 00 00 00       	mov    $0x0,%eax
  801a67:	eb f2                	jmp    801a5b <dev_lookup+0x48>

00801a69 <fd_close>:
{
  801a69:	55                   	push   %ebp
  801a6a:	89 e5                	mov    %esp,%ebp
  801a6c:	57                   	push   %edi
  801a6d:	56                   	push   %esi
  801a6e:	53                   	push   %ebx
  801a6f:	83 ec 1c             	sub    $0x1c,%esp
  801a72:	8b 75 08             	mov    0x8(%ebp),%esi
  801a75:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801a78:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801a7b:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801a7c:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801a82:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801a85:	50                   	push   %eax
  801a86:	e8 32 ff ff ff       	call   8019bd <fd_lookup>
  801a8b:	89 c3                	mov    %eax,%ebx
  801a8d:	83 c4 08             	add    $0x8,%esp
  801a90:	85 c0                	test   %eax,%eax
  801a92:	78 05                	js     801a99 <fd_close+0x30>
	    || fd != fd2)
  801a94:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801a97:	74 16                	je     801aaf <fd_close+0x46>
		return (must_exist ? r : 0);
  801a99:	89 f8                	mov    %edi,%eax
  801a9b:	84 c0                	test   %al,%al
  801a9d:	b8 00 00 00 00       	mov    $0x0,%eax
  801aa2:	0f 44 d8             	cmove  %eax,%ebx
}
  801aa5:	89 d8                	mov    %ebx,%eax
  801aa7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801aaa:	5b                   	pop    %ebx
  801aab:	5e                   	pop    %esi
  801aac:	5f                   	pop    %edi
  801aad:	5d                   	pop    %ebp
  801aae:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801aaf:	83 ec 08             	sub    $0x8,%esp
  801ab2:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801ab5:	50                   	push   %eax
  801ab6:	ff 36                	pushl  (%esi)
  801ab8:	e8 56 ff ff ff       	call   801a13 <dev_lookup>
  801abd:	89 c3                	mov    %eax,%ebx
  801abf:	83 c4 10             	add    $0x10,%esp
  801ac2:	85 c0                	test   %eax,%eax
  801ac4:	78 15                	js     801adb <fd_close+0x72>
		if (dev->dev_close)
  801ac6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ac9:	8b 40 10             	mov    0x10(%eax),%eax
  801acc:	85 c0                	test   %eax,%eax
  801ace:	74 1b                	je     801aeb <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  801ad0:	83 ec 0c             	sub    $0xc,%esp
  801ad3:	56                   	push   %esi
  801ad4:	ff d0                	call   *%eax
  801ad6:	89 c3                	mov    %eax,%ebx
  801ad8:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801adb:	83 ec 08             	sub    $0x8,%esp
  801ade:	56                   	push   %esi
  801adf:	6a 00                	push   $0x0
  801ae1:	e8 af f8 ff ff       	call   801395 <sys_page_unmap>
	return r;
  801ae6:	83 c4 10             	add    $0x10,%esp
  801ae9:	eb ba                	jmp    801aa5 <fd_close+0x3c>
			r = 0;
  801aeb:	bb 00 00 00 00       	mov    $0x0,%ebx
  801af0:	eb e9                	jmp    801adb <fd_close+0x72>

00801af2 <close>:

int
close(int fdnum)
{
  801af2:	55                   	push   %ebp
  801af3:	89 e5                	mov    %esp,%ebp
  801af5:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801af8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801afb:	50                   	push   %eax
  801afc:	ff 75 08             	pushl  0x8(%ebp)
  801aff:	e8 b9 fe ff ff       	call   8019bd <fd_lookup>
  801b04:	83 c4 08             	add    $0x8,%esp
  801b07:	85 c0                	test   %eax,%eax
  801b09:	78 10                	js     801b1b <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  801b0b:	83 ec 08             	sub    $0x8,%esp
  801b0e:	6a 01                	push   $0x1
  801b10:	ff 75 f4             	pushl  -0xc(%ebp)
  801b13:	e8 51 ff ff ff       	call   801a69 <fd_close>
  801b18:	83 c4 10             	add    $0x10,%esp
}
  801b1b:	c9                   	leave  
  801b1c:	c3                   	ret    

00801b1d <close_all>:

void
close_all(void)
{
  801b1d:	55                   	push   %ebp
  801b1e:	89 e5                	mov    %esp,%ebp
  801b20:	53                   	push   %ebx
  801b21:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801b24:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801b29:	83 ec 0c             	sub    $0xc,%esp
  801b2c:	53                   	push   %ebx
  801b2d:	e8 c0 ff ff ff       	call   801af2 <close>
	for (i = 0; i < MAXFD; i++)
  801b32:	83 c3 01             	add    $0x1,%ebx
  801b35:	83 c4 10             	add    $0x10,%esp
  801b38:	83 fb 20             	cmp    $0x20,%ebx
  801b3b:	75 ec                	jne    801b29 <close_all+0xc>
}
  801b3d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b40:	c9                   	leave  
  801b41:	c3                   	ret    

00801b42 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801b42:	55                   	push   %ebp
  801b43:	89 e5                	mov    %esp,%ebp
  801b45:	57                   	push   %edi
  801b46:	56                   	push   %esi
  801b47:	53                   	push   %ebx
  801b48:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801b4b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801b4e:	50                   	push   %eax
  801b4f:	ff 75 08             	pushl  0x8(%ebp)
  801b52:	e8 66 fe ff ff       	call   8019bd <fd_lookup>
  801b57:	89 c3                	mov    %eax,%ebx
  801b59:	83 c4 08             	add    $0x8,%esp
  801b5c:	85 c0                	test   %eax,%eax
  801b5e:	0f 88 81 00 00 00    	js     801be5 <dup+0xa3>
		return r;
	close(newfdnum);
  801b64:	83 ec 0c             	sub    $0xc,%esp
  801b67:	ff 75 0c             	pushl  0xc(%ebp)
  801b6a:	e8 83 ff ff ff       	call   801af2 <close>

	newfd = INDEX2FD(newfdnum);
  801b6f:	8b 75 0c             	mov    0xc(%ebp),%esi
  801b72:	c1 e6 0c             	shl    $0xc,%esi
  801b75:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801b7b:	83 c4 04             	add    $0x4,%esp
  801b7e:	ff 75 e4             	pushl  -0x1c(%ebp)
  801b81:	e8 d1 fd ff ff       	call   801957 <fd2data>
  801b86:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801b88:	89 34 24             	mov    %esi,(%esp)
  801b8b:	e8 c7 fd ff ff       	call   801957 <fd2data>
  801b90:	83 c4 10             	add    $0x10,%esp
  801b93:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801b95:	89 d8                	mov    %ebx,%eax
  801b97:	c1 e8 16             	shr    $0x16,%eax
  801b9a:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801ba1:	a8 01                	test   $0x1,%al
  801ba3:	74 11                	je     801bb6 <dup+0x74>
  801ba5:	89 d8                	mov    %ebx,%eax
  801ba7:	c1 e8 0c             	shr    $0xc,%eax
  801baa:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801bb1:	f6 c2 01             	test   $0x1,%dl
  801bb4:	75 39                	jne    801bef <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801bb6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801bb9:	89 d0                	mov    %edx,%eax
  801bbb:	c1 e8 0c             	shr    $0xc,%eax
  801bbe:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801bc5:	83 ec 0c             	sub    $0xc,%esp
  801bc8:	25 07 0e 00 00       	and    $0xe07,%eax
  801bcd:	50                   	push   %eax
  801bce:	56                   	push   %esi
  801bcf:	6a 00                	push   $0x0
  801bd1:	52                   	push   %edx
  801bd2:	6a 00                	push   $0x0
  801bd4:	e8 7a f7 ff ff       	call   801353 <sys_page_map>
  801bd9:	89 c3                	mov    %eax,%ebx
  801bdb:	83 c4 20             	add    $0x20,%esp
  801bde:	85 c0                	test   %eax,%eax
  801be0:	78 31                	js     801c13 <dup+0xd1>
		goto err;

	return newfdnum;
  801be2:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801be5:	89 d8                	mov    %ebx,%eax
  801be7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801bea:	5b                   	pop    %ebx
  801beb:	5e                   	pop    %esi
  801bec:	5f                   	pop    %edi
  801bed:	5d                   	pop    %ebp
  801bee:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801bef:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801bf6:	83 ec 0c             	sub    $0xc,%esp
  801bf9:	25 07 0e 00 00       	and    $0xe07,%eax
  801bfe:	50                   	push   %eax
  801bff:	57                   	push   %edi
  801c00:	6a 00                	push   $0x0
  801c02:	53                   	push   %ebx
  801c03:	6a 00                	push   $0x0
  801c05:	e8 49 f7 ff ff       	call   801353 <sys_page_map>
  801c0a:	89 c3                	mov    %eax,%ebx
  801c0c:	83 c4 20             	add    $0x20,%esp
  801c0f:	85 c0                	test   %eax,%eax
  801c11:	79 a3                	jns    801bb6 <dup+0x74>
	sys_page_unmap(0, newfd);
  801c13:	83 ec 08             	sub    $0x8,%esp
  801c16:	56                   	push   %esi
  801c17:	6a 00                	push   $0x0
  801c19:	e8 77 f7 ff ff       	call   801395 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801c1e:	83 c4 08             	add    $0x8,%esp
  801c21:	57                   	push   %edi
  801c22:	6a 00                	push   $0x0
  801c24:	e8 6c f7 ff ff       	call   801395 <sys_page_unmap>
	return r;
  801c29:	83 c4 10             	add    $0x10,%esp
  801c2c:	eb b7                	jmp    801be5 <dup+0xa3>

00801c2e <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801c2e:	55                   	push   %ebp
  801c2f:	89 e5                	mov    %esp,%ebp
  801c31:	53                   	push   %ebx
  801c32:	83 ec 14             	sub    $0x14,%esp
  801c35:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c38:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c3b:	50                   	push   %eax
  801c3c:	53                   	push   %ebx
  801c3d:	e8 7b fd ff ff       	call   8019bd <fd_lookup>
  801c42:	83 c4 08             	add    $0x8,%esp
  801c45:	85 c0                	test   %eax,%eax
  801c47:	78 3f                	js     801c88 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c49:	83 ec 08             	sub    $0x8,%esp
  801c4c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c4f:	50                   	push   %eax
  801c50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c53:	ff 30                	pushl  (%eax)
  801c55:	e8 b9 fd ff ff       	call   801a13 <dev_lookup>
  801c5a:	83 c4 10             	add    $0x10,%esp
  801c5d:	85 c0                	test   %eax,%eax
  801c5f:	78 27                	js     801c88 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801c61:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801c64:	8b 42 08             	mov    0x8(%edx),%eax
  801c67:	83 e0 03             	and    $0x3,%eax
  801c6a:	83 f8 01             	cmp    $0x1,%eax
  801c6d:	74 1e                	je     801c8d <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801c6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c72:	8b 40 08             	mov    0x8(%eax),%eax
  801c75:	85 c0                	test   %eax,%eax
  801c77:	74 35                	je     801cae <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801c79:	83 ec 04             	sub    $0x4,%esp
  801c7c:	ff 75 10             	pushl  0x10(%ebp)
  801c7f:	ff 75 0c             	pushl  0xc(%ebp)
  801c82:	52                   	push   %edx
  801c83:	ff d0                	call   *%eax
  801c85:	83 c4 10             	add    $0x10,%esp
}
  801c88:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c8b:	c9                   	leave  
  801c8c:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801c8d:	a1 20 50 80 00       	mov    0x805020,%eax
  801c92:	8b 40 48             	mov    0x48(%eax),%eax
  801c95:	83 ec 04             	sub    $0x4,%esp
  801c98:	53                   	push   %ebx
  801c99:	50                   	push   %eax
  801c9a:	68 29 33 80 00       	push   $0x803329
  801c9f:	e8 d6 eb ff ff       	call   80087a <cprintf>
		return -E_INVAL;
  801ca4:	83 c4 10             	add    $0x10,%esp
  801ca7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801cac:	eb da                	jmp    801c88 <read+0x5a>
		return -E_NOT_SUPP;
  801cae:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801cb3:	eb d3                	jmp    801c88 <read+0x5a>

00801cb5 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801cb5:	55                   	push   %ebp
  801cb6:	89 e5                	mov    %esp,%ebp
  801cb8:	57                   	push   %edi
  801cb9:	56                   	push   %esi
  801cba:	53                   	push   %ebx
  801cbb:	83 ec 0c             	sub    $0xc,%esp
  801cbe:	8b 7d 08             	mov    0x8(%ebp),%edi
  801cc1:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801cc4:	bb 00 00 00 00       	mov    $0x0,%ebx
  801cc9:	39 f3                	cmp    %esi,%ebx
  801ccb:	73 25                	jae    801cf2 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801ccd:	83 ec 04             	sub    $0x4,%esp
  801cd0:	89 f0                	mov    %esi,%eax
  801cd2:	29 d8                	sub    %ebx,%eax
  801cd4:	50                   	push   %eax
  801cd5:	89 d8                	mov    %ebx,%eax
  801cd7:	03 45 0c             	add    0xc(%ebp),%eax
  801cda:	50                   	push   %eax
  801cdb:	57                   	push   %edi
  801cdc:	e8 4d ff ff ff       	call   801c2e <read>
		if (m < 0)
  801ce1:	83 c4 10             	add    $0x10,%esp
  801ce4:	85 c0                	test   %eax,%eax
  801ce6:	78 08                	js     801cf0 <readn+0x3b>
			return m;
		if (m == 0)
  801ce8:	85 c0                	test   %eax,%eax
  801cea:	74 06                	je     801cf2 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  801cec:	01 c3                	add    %eax,%ebx
  801cee:	eb d9                	jmp    801cc9 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801cf0:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801cf2:	89 d8                	mov    %ebx,%eax
  801cf4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801cf7:	5b                   	pop    %ebx
  801cf8:	5e                   	pop    %esi
  801cf9:	5f                   	pop    %edi
  801cfa:	5d                   	pop    %ebp
  801cfb:	c3                   	ret    

00801cfc <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801cfc:	55                   	push   %ebp
  801cfd:	89 e5                	mov    %esp,%ebp
  801cff:	53                   	push   %ebx
  801d00:	83 ec 14             	sub    $0x14,%esp
  801d03:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801d06:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d09:	50                   	push   %eax
  801d0a:	53                   	push   %ebx
  801d0b:	e8 ad fc ff ff       	call   8019bd <fd_lookup>
  801d10:	83 c4 08             	add    $0x8,%esp
  801d13:	85 c0                	test   %eax,%eax
  801d15:	78 3a                	js     801d51 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801d17:	83 ec 08             	sub    $0x8,%esp
  801d1a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d1d:	50                   	push   %eax
  801d1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d21:	ff 30                	pushl  (%eax)
  801d23:	e8 eb fc ff ff       	call   801a13 <dev_lookup>
  801d28:	83 c4 10             	add    $0x10,%esp
  801d2b:	85 c0                	test   %eax,%eax
  801d2d:	78 22                	js     801d51 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801d2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d32:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801d36:	74 1e                	je     801d56 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801d38:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d3b:	8b 52 0c             	mov    0xc(%edx),%edx
  801d3e:	85 d2                	test   %edx,%edx
  801d40:	74 35                	je     801d77 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801d42:	83 ec 04             	sub    $0x4,%esp
  801d45:	ff 75 10             	pushl  0x10(%ebp)
  801d48:	ff 75 0c             	pushl  0xc(%ebp)
  801d4b:	50                   	push   %eax
  801d4c:	ff d2                	call   *%edx
  801d4e:	83 c4 10             	add    $0x10,%esp
}
  801d51:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d54:	c9                   	leave  
  801d55:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801d56:	a1 20 50 80 00       	mov    0x805020,%eax
  801d5b:	8b 40 48             	mov    0x48(%eax),%eax
  801d5e:	83 ec 04             	sub    $0x4,%esp
  801d61:	53                   	push   %ebx
  801d62:	50                   	push   %eax
  801d63:	68 45 33 80 00       	push   $0x803345
  801d68:	e8 0d eb ff ff       	call   80087a <cprintf>
		return -E_INVAL;
  801d6d:	83 c4 10             	add    $0x10,%esp
  801d70:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d75:	eb da                	jmp    801d51 <write+0x55>
		return -E_NOT_SUPP;
  801d77:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801d7c:	eb d3                	jmp    801d51 <write+0x55>

00801d7e <seek>:

int
seek(int fdnum, off_t offset)
{
  801d7e:	55                   	push   %ebp
  801d7f:	89 e5                	mov    %esp,%ebp
  801d81:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801d84:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801d87:	50                   	push   %eax
  801d88:	ff 75 08             	pushl  0x8(%ebp)
  801d8b:	e8 2d fc ff ff       	call   8019bd <fd_lookup>
  801d90:	83 c4 08             	add    $0x8,%esp
  801d93:	85 c0                	test   %eax,%eax
  801d95:	78 0e                	js     801da5 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801d97:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d9a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d9d:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801da0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801da5:	c9                   	leave  
  801da6:	c3                   	ret    

00801da7 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801da7:	55                   	push   %ebp
  801da8:	89 e5                	mov    %esp,%ebp
  801daa:	53                   	push   %ebx
  801dab:	83 ec 14             	sub    $0x14,%esp
  801dae:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801db1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801db4:	50                   	push   %eax
  801db5:	53                   	push   %ebx
  801db6:	e8 02 fc ff ff       	call   8019bd <fd_lookup>
  801dbb:	83 c4 08             	add    $0x8,%esp
  801dbe:	85 c0                	test   %eax,%eax
  801dc0:	78 37                	js     801df9 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801dc2:	83 ec 08             	sub    $0x8,%esp
  801dc5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801dc8:	50                   	push   %eax
  801dc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dcc:	ff 30                	pushl  (%eax)
  801dce:	e8 40 fc ff ff       	call   801a13 <dev_lookup>
  801dd3:	83 c4 10             	add    $0x10,%esp
  801dd6:	85 c0                	test   %eax,%eax
  801dd8:	78 1f                	js     801df9 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801dda:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ddd:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801de1:	74 1b                	je     801dfe <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801de3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801de6:	8b 52 18             	mov    0x18(%edx),%edx
  801de9:	85 d2                	test   %edx,%edx
  801deb:	74 32                	je     801e1f <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801ded:	83 ec 08             	sub    $0x8,%esp
  801df0:	ff 75 0c             	pushl  0xc(%ebp)
  801df3:	50                   	push   %eax
  801df4:	ff d2                	call   *%edx
  801df6:	83 c4 10             	add    $0x10,%esp
}
  801df9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dfc:	c9                   	leave  
  801dfd:	c3                   	ret    
			thisenv->env_id, fdnum);
  801dfe:	a1 20 50 80 00       	mov    0x805020,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801e03:	8b 40 48             	mov    0x48(%eax),%eax
  801e06:	83 ec 04             	sub    $0x4,%esp
  801e09:	53                   	push   %ebx
  801e0a:	50                   	push   %eax
  801e0b:	68 08 33 80 00       	push   $0x803308
  801e10:	e8 65 ea ff ff       	call   80087a <cprintf>
		return -E_INVAL;
  801e15:	83 c4 10             	add    $0x10,%esp
  801e18:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e1d:	eb da                	jmp    801df9 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801e1f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801e24:	eb d3                	jmp    801df9 <ftruncate+0x52>

00801e26 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801e26:	55                   	push   %ebp
  801e27:	89 e5                	mov    %esp,%ebp
  801e29:	53                   	push   %ebx
  801e2a:	83 ec 14             	sub    $0x14,%esp
  801e2d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801e30:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801e33:	50                   	push   %eax
  801e34:	ff 75 08             	pushl  0x8(%ebp)
  801e37:	e8 81 fb ff ff       	call   8019bd <fd_lookup>
  801e3c:	83 c4 08             	add    $0x8,%esp
  801e3f:	85 c0                	test   %eax,%eax
  801e41:	78 4b                	js     801e8e <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801e43:	83 ec 08             	sub    $0x8,%esp
  801e46:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e49:	50                   	push   %eax
  801e4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e4d:	ff 30                	pushl  (%eax)
  801e4f:	e8 bf fb ff ff       	call   801a13 <dev_lookup>
  801e54:	83 c4 10             	add    $0x10,%esp
  801e57:	85 c0                	test   %eax,%eax
  801e59:	78 33                	js     801e8e <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801e5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e5e:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801e62:	74 2f                	je     801e93 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801e64:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801e67:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801e6e:	00 00 00 
	stat->st_isdir = 0;
  801e71:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801e78:	00 00 00 
	stat->st_dev = dev;
  801e7b:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801e81:	83 ec 08             	sub    $0x8,%esp
  801e84:	53                   	push   %ebx
  801e85:	ff 75 f0             	pushl  -0x10(%ebp)
  801e88:	ff 50 14             	call   *0x14(%eax)
  801e8b:	83 c4 10             	add    $0x10,%esp
}
  801e8e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e91:	c9                   	leave  
  801e92:	c3                   	ret    
		return -E_NOT_SUPP;
  801e93:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801e98:	eb f4                	jmp    801e8e <fstat+0x68>

00801e9a <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801e9a:	55                   	push   %ebp
  801e9b:	89 e5                	mov    %esp,%ebp
  801e9d:	56                   	push   %esi
  801e9e:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801e9f:	83 ec 08             	sub    $0x8,%esp
  801ea2:	6a 00                	push   $0x0
  801ea4:	ff 75 08             	pushl  0x8(%ebp)
  801ea7:	e8 26 02 00 00       	call   8020d2 <open>
  801eac:	89 c3                	mov    %eax,%ebx
  801eae:	83 c4 10             	add    $0x10,%esp
  801eb1:	85 c0                	test   %eax,%eax
  801eb3:	78 1b                	js     801ed0 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801eb5:	83 ec 08             	sub    $0x8,%esp
  801eb8:	ff 75 0c             	pushl  0xc(%ebp)
  801ebb:	50                   	push   %eax
  801ebc:	e8 65 ff ff ff       	call   801e26 <fstat>
  801ec1:	89 c6                	mov    %eax,%esi
	close(fd);
  801ec3:	89 1c 24             	mov    %ebx,(%esp)
  801ec6:	e8 27 fc ff ff       	call   801af2 <close>
	return r;
  801ecb:	83 c4 10             	add    $0x10,%esp
  801ece:	89 f3                	mov    %esi,%ebx
}
  801ed0:	89 d8                	mov    %ebx,%eax
  801ed2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ed5:	5b                   	pop    %ebx
  801ed6:	5e                   	pop    %esi
  801ed7:	5d                   	pop    %ebp
  801ed8:	c3                   	ret    

00801ed9 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801ed9:	55                   	push   %ebp
  801eda:	89 e5                	mov    %esp,%ebp
  801edc:	56                   	push   %esi
  801edd:	53                   	push   %ebx
  801ede:	89 c6                	mov    %eax,%esi
  801ee0:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801ee2:	83 3d 18 50 80 00 00 	cmpl   $0x0,0x805018
  801ee9:	74 27                	je     801f12 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801eeb:	6a 07                	push   $0x7
  801eed:	68 00 60 80 00       	push   $0x806000
  801ef2:	56                   	push   %esi
  801ef3:	ff 35 18 50 80 00    	pushl  0x805018
  801ef9:	e8 b7 f9 ff ff       	call   8018b5 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801efe:	83 c4 0c             	add    $0xc,%esp
  801f01:	6a 00                	push   $0x0
  801f03:	53                   	push   %ebx
  801f04:	6a 00                	push   $0x0
  801f06:	e8 41 f9 ff ff       	call   80184c <ipc_recv>
}
  801f0b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f0e:	5b                   	pop    %ebx
  801f0f:	5e                   	pop    %esi
  801f10:	5d                   	pop    %ebp
  801f11:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801f12:	83 ec 0c             	sub    $0xc,%esp
  801f15:	6a 01                	push   $0x1
  801f17:	e8 f2 f9 ff ff       	call   80190e <ipc_find_env>
  801f1c:	a3 18 50 80 00       	mov    %eax,0x805018
  801f21:	83 c4 10             	add    $0x10,%esp
  801f24:	eb c5                	jmp    801eeb <fsipc+0x12>

00801f26 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801f26:	55                   	push   %ebp
  801f27:	89 e5                	mov    %esp,%ebp
  801f29:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2f:	8b 40 0c             	mov    0xc(%eax),%eax
  801f32:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801f37:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f3a:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801f3f:	ba 00 00 00 00       	mov    $0x0,%edx
  801f44:	b8 02 00 00 00       	mov    $0x2,%eax
  801f49:	e8 8b ff ff ff       	call   801ed9 <fsipc>
}
  801f4e:	c9                   	leave  
  801f4f:	c3                   	ret    

00801f50 <devfile_flush>:
{
  801f50:	55                   	push   %ebp
  801f51:	89 e5                	mov    %esp,%ebp
  801f53:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801f56:	8b 45 08             	mov    0x8(%ebp),%eax
  801f59:	8b 40 0c             	mov    0xc(%eax),%eax
  801f5c:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801f61:	ba 00 00 00 00       	mov    $0x0,%edx
  801f66:	b8 06 00 00 00       	mov    $0x6,%eax
  801f6b:	e8 69 ff ff ff       	call   801ed9 <fsipc>
}
  801f70:	c9                   	leave  
  801f71:	c3                   	ret    

00801f72 <devfile_stat>:
{
  801f72:	55                   	push   %ebp
  801f73:	89 e5                	mov    %esp,%ebp
  801f75:	53                   	push   %ebx
  801f76:	83 ec 04             	sub    $0x4,%esp
  801f79:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801f7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7f:	8b 40 0c             	mov    0xc(%eax),%eax
  801f82:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801f87:	ba 00 00 00 00       	mov    $0x0,%edx
  801f8c:	b8 05 00 00 00       	mov    $0x5,%eax
  801f91:	e8 43 ff ff ff       	call   801ed9 <fsipc>
  801f96:	85 c0                	test   %eax,%eax
  801f98:	78 2c                	js     801fc6 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801f9a:	83 ec 08             	sub    $0x8,%esp
  801f9d:	68 00 60 80 00       	push   $0x806000
  801fa2:	53                   	push   %ebx
  801fa3:	e8 6f ef ff ff       	call   800f17 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801fa8:	a1 80 60 80 00       	mov    0x806080,%eax
  801fad:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801fb3:	a1 84 60 80 00       	mov    0x806084,%eax
  801fb8:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801fbe:	83 c4 10             	add    $0x10,%esp
  801fc1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fc6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fc9:	c9                   	leave  
  801fca:	c3                   	ret    

00801fcb <devfile_write>:
{
  801fcb:	55                   	push   %ebp
  801fcc:	89 e5                	mov    %esp,%ebp
  801fce:	53                   	push   %ebx
  801fcf:	83 ec 04             	sub    $0x4,%esp
  801fd2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801fd5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd8:	8b 40 0c             	mov    0xc(%eax),%eax
  801fdb:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801fe0:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  801fe6:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  801fec:	77 30                	ja     80201e <devfile_write+0x53>
	memmove(fsipcbuf.write.req_buf, buf, n);
  801fee:	83 ec 04             	sub    $0x4,%esp
  801ff1:	53                   	push   %ebx
  801ff2:	ff 75 0c             	pushl  0xc(%ebp)
  801ff5:	68 08 60 80 00       	push   $0x806008
  801ffa:	e8 a6 f0 ff ff       	call   8010a5 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801fff:	ba 00 00 00 00       	mov    $0x0,%edx
  802004:	b8 04 00 00 00       	mov    $0x4,%eax
  802009:	e8 cb fe ff ff       	call   801ed9 <fsipc>
  80200e:	83 c4 10             	add    $0x10,%esp
  802011:	85 c0                	test   %eax,%eax
  802013:	78 04                	js     802019 <devfile_write+0x4e>
	assert(r <= n);
  802015:	39 d8                	cmp    %ebx,%eax
  802017:	77 1e                	ja     802037 <devfile_write+0x6c>
}
  802019:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80201c:	c9                   	leave  
  80201d:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  80201e:	68 78 33 80 00       	push   $0x803378
  802023:	68 a8 33 80 00       	push   $0x8033a8
  802028:	68 94 00 00 00       	push   $0x94
  80202d:	68 bd 33 80 00       	push   $0x8033bd
  802032:	e8 68 e7 ff ff       	call   80079f <_panic>
	assert(r <= n);
  802037:	68 c8 33 80 00       	push   $0x8033c8
  80203c:	68 a8 33 80 00       	push   $0x8033a8
  802041:	68 98 00 00 00       	push   $0x98
  802046:	68 bd 33 80 00       	push   $0x8033bd
  80204b:	e8 4f e7 ff ff       	call   80079f <_panic>

00802050 <devfile_read>:
{
  802050:	55                   	push   %ebp
  802051:	89 e5                	mov    %esp,%ebp
  802053:	56                   	push   %esi
  802054:	53                   	push   %ebx
  802055:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802058:	8b 45 08             	mov    0x8(%ebp),%eax
  80205b:	8b 40 0c             	mov    0xc(%eax),%eax
  80205e:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  802063:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802069:	ba 00 00 00 00       	mov    $0x0,%edx
  80206e:	b8 03 00 00 00       	mov    $0x3,%eax
  802073:	e8 61 fe ff ff       	call   801ed9 <fsipc>
  802078:	89 c3                	mov    %eax,%ebx
  80207a:	85 c0                	test   %eax,%eax
  80207c:	78 1f                	js     80209d <devfile_read+0x4d>
	assert(r <= n);
  80207e:	39 f0                	cmp    %esi,%eax
  802080:	77 24                	ja     8020a6 <devfile_read+0x56>
	assert(r <= PGSIZE);
  802082:	3d 00 10 00 00       	cmp    $0x1000,%eax
  802087:	7f 33                	jg     8020bc <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  802089:	83 ec 04             	sub    $0x4,%esp
  80208c:	50                   	push   %eax
  80208d:	68 00 60 80 00       	push   $0x806000
  802092:	ff 75 0c             	pushl  0xc(%ebp)
  802095:	e8 0b f0 ff ff       	call   8010a5 <memmove>
	return r;
  80209a:	83 c4 10             	add    $0x10,%esp
}
  80209d:	89 d8                	mov    %ebx,%eax
  80209f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020a2:	5b                   	pop    %ebx
  8020a3:	5e                   	pop    %esi
  8020a4:	5d                   	pop    %ebp
  8020a5:	c3                   	ret    
	assert(r <= n);
  8020a6:	68 c8 33 80 00       	push   $0x8033c8
  8020ab:	68 a8 33 80 00       	push   $0x8033a8
  8020b0:	6a 7c                	push   $0x7c
  8020b2:	68 bd 33 80 00       	push   $0x8033bd
  8020b7:	e8 e3 e6 ff ff       	call   80079f <_panic>
	assert(r <= PGSIZE);
  8020bc:	68 cf 33 80 00       	push   $0x8033cf
  8020c1:	68 a8 33 80 00       	push   $0x8033a8
  8020c6:	6a 7d                	push   $0x7d
  8020c8:	68 bd 33 80 00       	push   $0x8033bd
  8020cd:	e8 cd e6 ff ff       	call   80079f <_panic>

008020d2 <open>:
{
  8020d2:	55                   	push   %ebp
  8020d3:	89 e5                	mov    %esp,%ebp
  8020d5:	56                   	push   %esi
  8020d6:	53                   	push   %ebx
  8020d7:	83 ec 1c             	sub    $0x1c,%esp
  8020da:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8020dd:	56                   	push   %esi
  8020de:	e8 fd ed ff ff       	call   800ee0 <strlen>
  8020e3:	83 c4 10             	add    $0x10,%esp
  8020e6:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8020eb:	7f 6c                	jg     802159 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8020ed:	83 ec 0c             	sub    $0xc,%esp
  8020f0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020f3:	50                   	push   %eax
  8020f4:	e8 75 f8 ff ff       	call   80196e <fd_alloc>
  8020f9:	89 c3                	mov    %eax,%ebx
  8020fb:	83 c4 10             	add    $0x10,%esp
  8020fe:	85 c0                	test   %eax,%eax
  802100:	78 3c                	js     80213e <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  802102:	83 ec 08             	sub    $0x8,%esp
  802105:	56                   	push   %esi
  802106:	68 00 60 80 00       	push   $0x806000
  80210b:	e8 07 ee ff ff       	call   800f17 <strcpy>
	fsipcbuf.open.req_omode = mode;
  802110:	8b 45 0c             	mov    0xc(%ebp),%eax
  802113:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802118:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80211b:	b8 01 00 00 00       	mov    $0x1,%eax
  802120:	e8 b4 fd ff ff       	call   801ed9 <fsipc>
  802125:	89 c3                	mov    %eax,%ebx
  802127:	83 c4 10             	add    $0x10,%esp
  80212a:	85 c0                	test   %eax,%eax
  80212c:	78 19                	js     802147 <open+0x75>
	return fd2num(fd);
  80212e:	83 ec 0c             	sub    $0xc,%esp
  802131:	ff 75 f4             	pushl  -0xc(%ebp)
  802134:	e8 0e f8 ff ff       	call   801947 <fd2num>
  802139:	89 c3                	mov    %eax,%ebx
  80213b:	83 c4 10             	add    $0x10,%esp
}
  80213e:	89 d8                	mov    %ebx,%eax
  802140:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802143:	5b                   	pop    %ebx
  802144:	5e                   	pop    %esi
  802145:	5d                   	pop    %ebp
  802146:	c3                   	ret    
		fd_close(fd, 0);
  802147:	83 ec 08             	sub    $0x8,%esp
  80214a:	6a 00                	push   $0x0
  80214c:	ff 75 f4             	pushl  -0xc(%ebp)
  80214f:	e8 15 f9 ff ff       	call   801a69 <fd_close>
		return r;
  802154:	83 c4 10             	add    $0x10,%esp
  802157:	eb e5                	jmp    80213e <open+0x6c>
		return -E_BAD_PATH;
  802159:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80215e:	eb de                	jmp    80213e <open+0x6c>

00802160 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  802160:	55                   	push   %ebp
  802161:	89 e5                	mov    %esp,%ebp
  802163:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802166:	ba 00 00 00 00       	mov    $0x0,%edx
  80216b:	b8 08 00 00 00       	mov    $0x8,%eax
  802170:	e8 64 fd ff ff       	call   801ed9 <fsipc>
}
  802175:	c9                   	leave  
  802176:	c3                   	ret    

00802177 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802177:	55                   	push   %ebp
  802178:	89 e5                	mov    %esp,%ebp
  80217a:	56                   	push   %esi
  80217b:	53                   	push   %ebx
  80217c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80217f:	83 ec 0c             	sub    $0xc,%esp
  802182:	ff 75 08             	pushl  0x8(%ebp)
  802185:	e8 cd f7 ff ff       	call   801957 <fd2data>
  80218a:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80218c:	83 c4 08             	add    $0x8,%esp
  80218f:	68 db 33 80 00       	push   $0x8033db
  802194:	53                   	push   %ebx
  802195:	e8 7d ed ff ff       	call   800f17 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80219a:	8b 46 04             	mov    0x4(%esi),%eax
  80219d:	2b 06                	sub    (%esi),%eax
  80219f:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8021a5:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8021ac:	00 00 00 
	stat->st_dev = &devpipe;
  8021af:	c7 83 88 00 00 00 20 	movl   $0x804020,0x88(%ebx)
  8021b6:	40 80 00 
	return 0;
}
  8021b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8021be:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021c1:	5b                   	pop    %ebx
  8021c2:	5e                   	pop    %esi
  8021c3:	5d                   	pop    %ebp
  8021c4:	c3                   	ret    

008021c5 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8021c5:	55                   	push   %ebp
  8021c6:	89 e5                	mov    %esp,%ebp
  8021c8:	53                   	push   %ebx
  8021c9:	83 ec 0c             	sub    $0xc,%esp
  8021cc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8021cf:	53                   	push   %ebx
  8021d0:	6a 00                	push   $0x0
  8021d2:	e8 be f1 ff ff       	call   801395 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8021d7:	89 1c 24             	mov    %ebx,(%esp)
  8021da:	e8 78 f7 ff ff       	call   801957 <fd2data>
  8021df:	83 c4 08             	add    $0x8,%esp
  8021e2:	50                   	push   %eax
  8021e3:	6a 00                	push   $0x0
  8021e5:	e8 ab f1 ff ff       	call   801395 <sys_page_unmap>
}
  8021ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021ed:	c9                   	leave  
  8021ee:	c3                   	ret    

008021ef <_pipeisclosed>:
{
  8021ef:	55                   	push   %ebp
  8021f0:	89 e5                	mov    %esp,%ebp
  8021f2:	57                   	push   %edi
  8021f3:	56                   	push   %esi
  8021f4:	53                   	push   %ebx
  8021f5:	83 ec 1c             	sub    $0x1c,%esp
  8021f8:	89 c7                	mov    %eax,%edi
  8021fa:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8021fc:	a1 20 50 80 00       	mov    0x805020,%eax
  802201:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802204:	83 ec 0c             	sub    $0xc,%esp
  802207:	57                   	push   %edi
  802208:	e8 38 09 00 00       	call   802b45 <pageref>
  80220d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802210:	89 34 24             	mov    %esi,(%esp)
  802213:	e8 2d 09 00 00       	call   802b45 <pageref>
		nn = thisenv->env_runs;
  802218:	8b 15 20 50 80 00    	mov    0x805020,%edx
  80221e:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802221:	83 c4 10             	add    $0x10,%esp
  802224:	39 cb                	cmp    %ecx,%ebx
  802226:	74 1b                	je     802243 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802228:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80222b:	75 cf                	jne    8021fc <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80222d:	8b 42 58             	mov    0x58(%edx),%eax
  802230:	6a 01                	push   $0x1
  802232:	50                   	push   %eax
  802233:	53                   	push   %ebx
  802234:	68 e2 33 80 00       	push   $0x8033e2
  802239:	e8 3c e6 ff ff       	call   80087a <cprintf>
  80223e:	83 c4 10             	add    $0x10,%esp
  802241:	eb b9                	jmp    8021fc <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802243:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802246:	0f 94 c0             	sete   %al
  802249:	0f b6 c0             	movzbl %al,%eax
}
  80224c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80224f:	5b                   	pop    %ebx
  802250:	5e                   	pop    %esi
  802251:	5f                   	pop    %edi
  802252:	5d                   	pop    %ebp
  802253:	c3                   	ret    

00802254 <devpipe_write>:
{
  802254:	55                   	push   %ebp
  802255:	89 e5                	mov    %esp,%ebp
  802257:	57                   	push   %edi
  802258:	56                   	push   %esi
  802259:	53                   	push   %ebx
  80225a:	83 ec 28             	sub    $0x28,%esp
  80225d:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802260:	56                   	push   %esi
  802261:	e8 f1 f6 ff ff       	call   801957 <fd2data>
  802266:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802268:	83 c4 10             	add    $0x10,%esp
  80226b:	bf 00 00 00 00       	mov    $0x0,%edi
  802270:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802273:	74 4f                	je     8022c4 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802275:	8b 43 04             	mov    0x4(%ebx),%eax
  802278:	8b 0b                	mov    (%ebx),%ecx
  80227a:	8d 51 20             	lea    0x20(%ecx),%edx
  80227d:	39 d0                	cmp    %edx,%eax
  80227f:	72 14                	jb     802295 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802281:	89 da                	mov    %ebx,%edx
  802283:	89 f0                	mov    %esi,%eax
  802285:	e8 65 ff ff ff       	call   8021ef <_pipeisclosed>
  80228a:	85 c0                	test   %eax,%eax
  80228c:	75 3a                	jne    8022c8 <devpipe_write+0x74>
			sys_yield();
  80228e:	e8 5e f0 ff ff       	call   8012f1 <sys_yield>
  802293:	eb e0                	jmp    802275 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802295:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802298:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80229c:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80229f:	89 c2                	mov    %eax,%edx
  8022a1:	c1 fa 1f             	sar    $0x1f,%edx
  8022a4:	89 d1                	mov    %edx,%ecx
  8022a6:	c1 e9 1b             	shr    $0x1b,%ecx
  8022a9:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8022ac:	83 e2 1f             	and    $0x1f,%edx
  8022af:	29 ca                	sub    %ecx,%edx
  8022b1:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8022b5:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8022b9:	83 c0 01             	add    $0x1,%eax
  8022bc:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8022bf:	83 c7 01             	add    $0x1,%edi
  8022c2:	eb ac                	jmp    802270 <devpipe_write+0x1c>
	return i;
  8022c4:	89 f8                	mov    %edi,%eax
  8022c6:	eb 05                	jmp    8022cd <devpipe_write+0x79>
				return 0;
  8022c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022d0:	5b                   	pop    %ebx
  8022d1:	5e                   	pop    %esi
  8022d2:	5f                   	pop    %edi
  8022d3:	5d                   	pop    %ebp
  8022d4:	c3                   	ret    

008022d5 <devpipe_read>:
{
  8022d5:	55                   	push   %ebp
  8022d6:	89 e5                	mov    %esp,%ebp
  8022d8:	57                   	push   %edi
  8022d9:	56                   	push   %esi
  8022da:	53                   	push   %ebx
  8022db:	83 ec 18             	sub    $0x18,%esp
  8022de:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8022e1:	57                   	push   %edi
  8022e2:	e8 70 f6 ff ff       	call   801957 <fd2data>
  8022e7:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8022e9:	83 c4 10             	add    $0x10,%esp
  8022ec:	be 00 00 00 00       	mov    $0x0,%esi
  8022f1:	3b 75 10             	cmp    0x10(%ebp),%esi
  8022f4:	74 47                	je     80233d <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  8022f6:	8b 03                	mov    (%ebx),%eax
  8022f8:	3b 43 04             	cmp    0x4(%ebx),%eax
  8022fb:	75 22                	jne    80231f <devpipe_read+0x4a>
			if (i > 0)
  8022fd:	85 f6                	test   %esi,%esi
  8022ff:	75 14                	jne    802315 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  802301:	89 da                	mov    %ebx,%edx
  802303:	89 f8                	mov    %edi,%eax
  802305:	e8 e5 fe ff ff       	call   8021ef <_pipeisclosed>
  80230a:	85 c0                	test   %eax,%eax
  80230c:	75 33                	jne    802341 <devpipe_read+0x6c>
			sys_yield();
  80230e:	e8 de ef ff ff       	call   8012f1 <sys_yield>
  802313:	eb e1                	jmp    8022f6 <devpipe_read+0x21>
				return i;
  802315:	89 f0                	mov    %esi,%eax
}
  802317:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80231a:	5b                   	pop    %ebx
  80231b:	5e                   	pop    %esi
  80231c:	5f                   	pop    %edi
  80231d:	5d                   	pop    %ebp
  80231e:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80231f:	99                   	cltd   
  802320:	c1 ea 1b             	shr    $0x1b,%edx
  802323:	01 d0                	add    %edx,%eax
  802325:	83 e0 1f             	and    $0x1f,%eax
  802328:	29 d0                	sub    %edx,%eax
  80232a:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80232f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802332:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802335:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802338:	83 c6 01             	add    $0x1,%esi
  80233b:	eb b4                	jmp    8022f1 <devpipe_read+0x1c>
	return i;
  80233d:	89 f0                	mov    %esi,%eax
  80233f:	eb d6                	jmp    802317 <devpipe_read+0x42>
				return 0;
  802341:	b8 00 00 00 00       	mov    $0x0,%eax
  802346:	eb cf                	jmp    802317 <devpipe_read+0x42>

00802348 <pipe>:
{
  802348:	55                   	push   %ebp
  802349:	89 e5                	mov    %esp,%ebp
  80234b:	56                   	push   %esi
  80234c:	53                   	push   %ebx
  80234d:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802350:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802353:	50                   	push   %eax
  802354:	e8 15 f6 ff ff       	call   80196e <fd_alloc>
  802359:	89 c3                	mov    %eax,%ebx
  80235b:	83 c4 10             	add    $0x10,%esp
  80235e:	85 c0                	test   %eax,%eax
  802360:	78 5b                	js     8023bd <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802362:	83 ec 04             	sub    $0x4,%esp
  802365:	68 07 04 00 00       	push   $0x407
  80236a:	ff 75 f4             	pushl  -0xc(%ebp)
  80236d:	6a 00                	push   $0x0
  80236f:	e8 9c ef ff ff       	call   801310 <sys_page_alloc>
  802374:	89 c3                	mov    %eax,%ebx
  802376:	83 c4 10             	add    $0x10,%esp
  802379:	85 c0                	test   %eax,%eax
  80237b:	78 40                	js     8023bd <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  80237d:	83 ec 0c             	sub    $0xc,%esp
  802380:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802383:	50                   	push   %eax
  802384:	e8 e5 f5 ff ff       	call   80196e <fd_alloc>
  802389:	89 c3                	mov    %eax,%ebx
  80238b:	83 c4 10             	add    $0x10,%esp
  80238e:	85 c0                	test   %eax,%eax
  802390:	78 1b                	js     8023ad <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802392:	83 ec 04             	sub    $0x4,%esp
  802395:	68 07 04 00 00       	push   $0x407
  80239a:	ff 75 f0             	pushl  -0x10(%ebp)
  80239d:	6a 00                	push   $0x0
  80239f:	e8 6c ef ff ff       	call   801310 <sys_page_alloc>
  8023a4:	89 c3                	mov    %eax,%ebx
  8023a6:	83 c4 10             	add    $0x10,%esp
  8023a9:	85 c0                	test   %eax,%eax
  8023ab:	79 19                	jns    8023c6 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  8023ad:	83 ec 08             	sub    $0x8,%esp
  8023b0:	ff 75 f4             	pushl  -0xc(%ebp)
  8023b3:	6a 00                	push   $0x0
  8023b5:	e8 db ef ff ff       	call   801395 <sys_page_unmap>
  8023ba:	83 c4 10             	add    $0x10,%esp
}
  8023bd:	89 d8                	mov    %ebx,%eax
  8023bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8023c2:	5b                   	pop    %ebx
  8023c3:	5e                   	pop    %esi
  8023c4:	5d                   	pop    %ebp
  8023c5:	c3                   	ret    
	va = fd2data(fd0);
  8023c6:	83 ec 0c             	sub    $0xc,%esp
  8023c9:	ff 75 f4             	pushl  -0xc(%ebp)
  8023cc:	e8 86 f5 ff ff       	call   801957 <fd2data>
  8023d1:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8023d3:	83 c4 0c             	add    $0xc,%esp
  8023d6:	68 07 04 00 00       	push   $0x407
  8023db:	50                   	push   %eax
  8023dc:	6a 00                	push   $0x0
  8023de:	e8 2d ef ff ff       	call   801310 <sys_page_alloc>
  8023e3:	89 c3                	mov    %eax,%ebx
  8023e5:	83 c4 10             	add    $0x10,%esp
  8023e8:	85 c0                	test   %eax,%eax
  8023ea:	0f 88 8c 00 00 00    	js     80247c <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8023f0:	83 ec 0c             	sub    $0xc,%esp
  8023f3:	ff 75 f0             	pushl  -0x10(%ebp)
  8023f6:	e8 5c f5 ff ff       	call   801957 <fd2data>
  8023fb:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802402:	50                   	push   %eax
  802403:	6a 00                	push   $0x0
  802405:	56                   	push   %esi
  802406:	6a 00                	push   $0x0
  802408:	e8 46 ef ff ff       	call   801353 <sys_page_map>
  80240d:	89 c3                	mov    %eax,%ebx
  80240f:	83 c4 20             	add    $0x20,%esp
  802412:	85 c0                	test   %eax,%eax
  802414:	78 58                	js     80246e <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  802416:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802419:	8b 15 20 40 80 00    	mov    0x804020,%edx
  80241f:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  802421:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802424:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  80242b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80242e:	8b 15 20 40 80 00    	mov    0x804020,%edx
  802434:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802436:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802439:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802440:	83 ec 0c             	sub    $0xc,%esp
  802443:	ff 75 f4             	pushl  -0xc(%ebp)
  802446:	e8 fc f4 ff ff       	call   801947 <fd2num>
  80244b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80244e:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802450:	83 c4 04             	add    $0x4,%esp
  802453:	ff 75 f0             	pushl  -0x10(%ebp)
  802456:	e8 ec f4 ff ff       	call   801947 <fd2num>
  80245b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80245e:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802461:	83 c4 10             	add    $0x10,%esp
  802464:	bb 00 00 00 00       	mov    $0x0,%ebx
  802469:	e9 4f ff ff ff       	jmp    8023bd <pipe+0x75>
	sys_page_unmap(0, va);
  80246e:	83 ec 08             	sub    $0x8,%esp
  802471:	56                   	push   %esi
  802472:	6a 00                	push   $0x0
  802474:	e8 1c ef ff ff       	call   801395 <sys_page_unmap>
  802479:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80247c:	83 ec 08             	sub    $0x8,%esp
  80247f:	ff 75 f0             	pushl  -0x10(%ebp)
  802482:	6a 00                	push   $0x0
  802484:	e8 0c ef ff ff       	call   801395 <sys_page_unmap>
  802489:	83 c4 10             	add    $0x10,%esp
  80248c:	e9 1c ff ff ff       	jmp    8023ad <pipe+0x65>

00802491 <pipeisclosed>:
{
  802491:	55                   	push   %ebp
  802492:	89 e5                	mov    %esp,%ebp
  802494:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802497:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80249a:	50                   	push   %eax
  80249b:	ff 75 08             	pushl  0x8(%ebp)
  80249e:	e8 1a f5 ff ff       	call   8019bd <fd_lookup>
  8024a3:	83 c4 10             	add    $0x10,%esp
  8024a6:	85 c0                	test   %eax,%eax
  8024a8:	78 18                	js     8024c2 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8024aa:	83 ec 0c             	sub    $0xc,%esp
  8024ad:	ff 75 f4             	pushl  -0xc(%ebp)
  8024b0:	e8 a2 f4 ff ff       	call   801957 <fd2data>
	return _pipeisclosed(fd, p);
  8024b5:	89 c2                	mov    %eax,%edx
  8024b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ba:	e8 30 fd ff ff       	call   8021ef <_pipeisclosed>
  8024bf:	83 c4 10             	add    $0x10,%esp
}
  8024c2:	c9                   	leave  
  8024c3:	c3                   	ret    

008024c4 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8024c4:	55                   	push   %ebp
  8024c5:	89 e5                	mov    %esp,%ebp
  8024c7:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  8024ca:	68 fa 33 80 00       	push   $0x8033fa
  8024cf:	ff 75 0c             	pushl  0xc(%ebp)
  8024d2:	e8 40 ea ff ff       	call   800f17 <strcpy>
	return 0;
}
  8024d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8024dc:	c9                   	leave  
  8024dd:	c3                   	ret    

008024de <devsock_close>:
{
  8024de:	55                   	push   %ebp
  8024df:	89 e5                	mov    %esp,%ebp
  8024e1:	53                   	push   %ebx
  8024e2:	83 ec 10             	sub    $0x10,%esp
  8024e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8024e8:	53                   	push   %ebx
  8024e9:	e8 57 06 00 00       	call   802b45 <pageref>
  8024ee:	83 c4 10             	add    $0x10,%esp
		return 0;
  8024f1:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  8024f6:	83 f8 01             	cmp    $0x1,%eax
  8024f9:	74 07                	je     802502 <devsock_close+0x24>
}
  8024fb:	89 d0                	mov    %edx,%eax
  8024fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802500:	c9                   	leave  
  802501:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  802502:	83 ec 0c             	sub    $0xc,%esp
  802505:	ff 73 0c             	pushl  0xc(%ebx)
  802508:	e8 b7 02 00 00       	call   8027c4 <nsipc_close>
  80250d:	89 c2                	mov    %eax,%edx
  80250f:	83 c4 10             	add    $0x10,%esp
  802512:	eb e7                	jmp    8024fb <devsock_close+0x1d>

00802514 <devsock_write>:
{
  802514:	55                   	push   %ebp
  802515:	89 e5                	mov    %esp,%ebp
  802517:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80251a:	6a 00                	push   $0x0
  80251c:	ff 75 10             	pushl  0x10(%ebp)
  80251f:	ff 75 0c             	pushl  0xc(%ebp)
  802522:	8b 45 08             	mov    0x8(%ebp),%eax
  802525:	ff 70 0c             	pushl  0xc(%eax)
  802528:	e8 74 03 00 00       	call   8028a1 <nsipc_send>
}
  80252d:	c9                   	leave  
  80252e:	c3                   	ret    

0080252f <devsock_read>:
{
  80252f:	55                   	push   %ebp
  802530:	89 e5                	mov    %esp,%ebp
  802532:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802535:	6a 00                	push   $0x0
  802537:	ff 75 10             	pushl  0x10(%ebp)
  80253a:	ff 75 0c             	pushl  0xc(%ebp)
  80253d:	8b 45 08             	mov    0x8(%ebp),%eax
  802540:	ff 70 0c             	pushl  0xc(%eax)
  802543:	e8 ed 02 00 00       	call   802835 <nsipc_recv>
}
  802548:	c9                   	leave  
  802549:	c3                   	ret    

0080254a <fd2sockid>:
{
  80254a:	55                   	push   %ebp
  80254b:	89 e5                	mov    %esp,%ebp
  80254d:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  802550:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802553:	52                   	push   %edx
  802554:	50                   	push   %eax
  802555:	e8 63 f4 ff ff       	call   8019bd <fd_lookup>
  80255a:	83 c4 10             	add    $0x10,%esp
  80255d:	85 c0                	test   %eax,%eax
  80255f:	78 10                	js     802571 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  802561:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802564:	8b 0d 3c 40 80 00    	mov    0x80403c,%ecx
  80256a:	39 08                	cmp    %ecx,(%eax)
  80256c:	75 05                	jne    802573 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  80256e:	8b 40 0c             	mov    0xc(%eax),%eax
}
  802571:	c9                   	leave  
  802572:	c3                   	ret    
		return -E_NOT_SUPP;
  802573:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802578:	eb f7                	jmp    802571 <fd2sockid+0x27>

0080257a <alloc_sockfd>:
{
  80257a:	55                   	push   %ebp
  80257b:	89 e5                	mov    %esp,%ebp
  80257d:	56                   	push   %esi
  80257e:	53                   	push   %ebx
  80257f:	83 ec 1c             	sub    $0x1c,%esp
  802582:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  802584:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802587:	50                   	push   %eax
  802588:	e8 e1 f3 ff ff       	call   80196e <fd_alloc>
  80258d:	89 c3                	mov    %eax,%ebx
  80258f:	83 c4 10             	add    $0x10,%esp
  802592:	85 c0                	test   %eax,%eax
  802594:	78 43                	js     8025d9 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802596:	83 ec 04             	sub    $0x4,%esp
  802599:	68 07 04 00 00       	push   $0x407
  80259e:	ff 75 f4             	pushl  -0xc(%ebp)
  8025a1:	6a 00                	push   $0x0
  8025a3:	e8 68 ed ff ff       	call   801310 <sys_page_alloc>
  8025a8:	89 c3                	mov    %eax,%ebx
  8025aa:	83 c4 10             	add    $0x10,%esp
  8025ad:	85 c0                	test   %eax,%eax
  8025af:	78 28                	js     8025d9 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  8025b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b4:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  8025ba:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8025bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bf:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8025c6:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8025c9:	83 ec 0c             	sub    $0xc,%esp
  8025cc:	50                   	push   %eax
  8025cd:	e8 75 f3 ff ff       	call   801947 <fd2num>
  8025d2:	89 c3                	mov    %eax,%ebx
  8025d4:	83 c4 10             	add    $0x10,%esp
  8025d7:	eb 0c                	jmp    8025e5 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8025d9:	83 ec 0c             	sub    $0xc,%esp
  8025dc:	56                   	push   %esi
  8025dd:	e8 e2 01 00 00       	call   8027c4 <nsipc_close>
		return r;
  8025e2:	83 c4 10             	add    $0x10,%esp
}
  8025e5:	89 d8                	mov    %ebx,%eax
  8025e7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8025ea:	5b                   	pop    %ebx
  8025eb:	5e                   	pop    %esi
  8025ec:	5d                   	pop    %ebp
  8025ed:	c3                   	ret    

008025ee <accept>:
{
  8025ee:	55                   	push   %ebp
  8025ef:	89 e5                	mov    %esp,%ebp
  8025f1:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8025f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f7:	e8 4e ff ff ff       	call   80254a <fd2sockid>
  8025fc:	85 c0                	test   %eax,%eax
  8025fe:	78 1b                	js     80261b <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802600:	83 ec 04             	sub    $0x4,%esp
  802603:	ff 75 10             	pushl  0x10(%ebp)
  802606:	ff 75 0c             	pushl  0xc(%ebp)
  802609:	50                   	push   %eax
  80260a:	e8 0e 01 00 00       	call   80271d <nsipc_accept>
  80260f:	83 c4 10             	add    $0x10,%esp
  802612:	85 c0                	test   %eax,%eax
  802614:	78 05                	js     80261b <accept+0x2d>
	return alloc_sockfd(r);
  802616:	e8 5f ff ff ff       	call   80257a <alloc_sockfd>
}
  80261b:	c9                   	leave  
  80261c:	c3                   	ret    

0080261d <bind>:
{
  80261d:	55                   	push   %ebp
  80261e:	89 e5                	mov    %esp,%ebp
  802620:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802623:	8b 45 08             	mov    0x8(%ebp),%eax
  802626:	e8 1f ff ff ff       	call   80254a <fd2sockid>
  80262b:	85 c0                	test   %eax,%eax
  80262d:	78 12                	js     802641 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  80262f:	83 ec 04             	sub    $0x4,%esp
  802632:	ff 75 10             	pushl  0x10(%ebp)
  802635:	ff 75 0c             	pushl  0xc(%ebp)
  802638:	50                   	push   %eax
  802639:	e8 2f 01 00 00       	call   80276d <nsipc_bind>
  80263e:	83 c4 10             	add    $0x10,%esp
}
  802641:	c9                   	leave  
  802642:	c3                   	ret    

00802643 <shutdown>:
{
  802643:	55                   	push   %ebp
  802644:	89 e5                	mov    %esp,%ebp
  802646:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802649:	8b 45 08             	mov    0x8(%ebp),%eax
  80264c:	e8 f9 fe ff ff       	call   80254a <fd2sockid>
  802651:	85 c0                	test   %eax,%eax
  802653:	78 0f                	js     802664 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  802655:	83 ec 08             	sub    $0x8,%esp
  802658:	ff 75 0c             	pushl  0xc(%ebp)
  80265b:	50                   	push   %eax
  80265c:	e8 41 01 00 00       	call   8027a2 <nsipc_shutdown>
  802661:	83 c4 10             	add    $0x10,%esp
}
  802664:	c9                   	leave  
  802665:	c3                   	ret    

00802666 <connect>:
{
  802666:	55                   	push   %ebp
  802667:	89 e5                	mov    %esp,%ebp
  802669:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80266c:	8b 45 08             	mov    0x8(%ebp),%eax
  80266f:	e8 d6 fe ff ff       	call   80254a <fd2sockid>
  802674:	85 c0                	test   %eax,%eax
  802676:	78 12                	js     80268a <connect+0x24>
	return nsipc_connect(r, name, namelen);
  802678:	83 ec 04             	sub    $0x4,%esp
  80267b:	ff 75 10             	pushl  0x10(%ebp)
  80267e:	ff 75 0c             	pushl  0xc(%ebp)
  802681:	50                   	push   %eax
  802682:	e8 57 01 00 00       	call   8027de <nsipc_connect>
  802687:	83 c4 10             	add    $0x10,%esp
}
  80268a:	c9                   	leave  
  80268b:	c3                   	ret    

0080268c <listen>:
{
  80268c:	55                   	push   %ebp
  80268d:	89 e5                	mov    %esp,%ebp
  80268f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802692:	8b 45 08             	mov    0x8(%ebp),%eax
  802695:	e8 b0 fe ff ff       	call   80254a <fd2sockid>
  80269a:	85 c0                	test   %eax,%eax
  80269c:	78 0f                	js     8026ad <listen+0x21>
	return nsipc_listen(r, backlog);
  80269e:	83 ec 08             	sub    $0x8,%esp
  8026a1:	ff 75 0c             	pushl  0xc(%ebp)
  8026a4:	50                   	push   %eax
  8026a5:	e8 69 01 00 00       	call   802813 <nsipc_listen>
  8026aa:	83 c4 10             	add    $0x10,%esp
}
  8026ad:	c9                   	leave  
  8026ae:	c3                   	ret    

008026af <socket>:

int
socket(int domain, int type, int protocol)
{
  8026af:	55                   	push   %ebp
  8026b0:	89 e5                	mov    %esp,%ebp
  8026b2:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8026b5:	ff 75 10             	pushl  0x10(%ebp)
  8026b8:	ff 75 0c             	pushl  0xc(%ebp)
  8026bb:	ff 75 08             	pushl  0x8(%ebp)
  8026be:	e8 3c 02 00 00       	call   8028ff <nsipc_socket>
  8026c3:	83 c4 10             	add    $0x10,%esp
  8026c6:	85 c0                	test   %eax,%eax
  8026c8:	78 05                	js     8026cf <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8026ca:	e8 ab fe ff ff       	call   80257a <alloc_sockfd>
}
  8026cf:	c9                   	leave  
  8026d0:	c3                   	ret    

008026d1 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8026d1:	55                   	push   %ebp
  8026d2:	89 e5                	mov    %esp,%ebp
  8026d4:	53                   	push   %ebx
  8026d5:	83 ec 04             	sub    $0x4,%esp
  8026d8:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8026da:	83 3d 1c 50 80 00 00 	cmpl   $0x0,0x80501c
  8026e1:	74 26                	je     802709 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8026e3:	6a 07                	push   $0x7
  8026e5:	68 00 70 80 00       	push   $0x807000
  8026ea:	53                   	push   %ebx
  8026eb:	ff 35 1c 50 80 00    	pushl  0x80501c
  8026f1:	e8 bf f1 ff ff       	call   8018b5 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8026f6:	83 c4 0c             	add    $0xc,%esp
  8026f9:	6a 00                	push   $0x0
  8026fb:	6a 00                	push   $0x0
  8026fd:	6a 00                	push   $0x0
  8026ff:	e8 48 f1 ff ff       	call   80184c <ipc_recv>
}
  802704:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802707:	c9                   	leave  
  802708:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802709:	83 ec 0c             	sub    $0xc,%esp
  80270c:	6a 02                	push   $0x2
  80270e:	e8 fb f1 ff ff       	call   80190e <ipc_find_env>
  802713:	a3 1c 50 80 00       	mov    %eax,0x80501c
  802718:	83 c4 10             	add    $0x10,%esp
  80271b:	eb c6                	jmp    8026e3 <nsipc+0x12>

0080271d <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80271d:	55                   	push   %ebp
  80271e:	89 e5                	mov    %esp,%ebp
  802720:	56                   	push   %esi
  802721:	53                   	push   %ebx
  802722:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802725:	8b 45 08             	mov    0x8(%ebp),%eax
  802728:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80272d:	8b 06                	mov    (%esi),%eax
  80272f:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802734:	b8 01 00 00 00       	mov    $0x1,%eax
  802739:	e8 93 ff ff ff       	call   8026d1 <nsipc>
  80273e:	89 c3                	mov    %eax,%ebx
  802740:	85 c0                	test   %eax,%eax
  802742:	78 20                	js     802764 <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802744:	83 ec 04             	sub    $0x4,%esp
  802747:	ff 35 10 70 80 00    	pushl  0x807010
  80274d:	68 00 70 80 00       	push   $0x807000
  802752:	ff 75 0c             	pushl  0xc(%ebp)
  802755:	e8 4b e9 ff ff       	call   8010a5 <memmove>
		*addrlen = ret->ret_addrlen;
  80275a:	a1 10 70 80 00       	mov    0x807010,%eax
  80275f:	89 06                	mov    %eax,(%esi)
  802761:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  802764:	89 d8                	mov    %ebx,%eax
  802766:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802769:	5b                   	pop    %ebx
  80276a:	5e                   	pop    %esi
  80276b:	5d                   	pop    %ebp
  80276c:	c3                   	ret    

0080276d <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80276d:	55                   	push   %ebp
  80276e:	89 e5                	mov    %esp,%ebp
  802770:	53                   	push   %ebx
  802771:	83 ec 08             	sub    $0x8,%esp
  802774:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802777:	8b 45 08             	mov    0x8(%ebp),%eax
  80277a:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80277f:	53                   	push   %ebx
  802780:	ff 75 0c             	pushl  0xc(%ebp)
  802783:	68 04 70 80 00       	push   $0x807004
  802788:	e8 18 e9 ff ff       	call   8010a5 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  80278d:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  802793:	b8 02 00 00 00       	mov    $0x2,%eax
  802798:	e8 34 ff ff ff       	call   8026d1 <nsipc>
}
  80279d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8027a0:	c9                   	leave  
  8027a1:	c3                   	ret    

008027a2 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8027a2:	55                   	push   %ebp
  8027a3:	89 e5                	mov    %esp,%ebp
  8027a5:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8027a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ab:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  8027b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027b3:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  8027b8:	b8 03 00 00 00       	mov    $0x3,%eax
  8027bd:	e8 0f ff ff ff       	call   8026d1 <nsipc>
}
  8027c2:	c9                   	leave  
  8027c3:	c3                   	ret    

008027c4 <nsipc_close>:

int
nsipc_close(int s)
{
  8027c4:	55                   	push   %ebp
  8027c5:	89 e5                	mov    %esp,%ebp
  8027c7:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8027ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8027cd:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8027d2:	b8 04 00 00 00       	mov    $0x4,%eax
  8027d7:	e8 f5 fe ff ff       	call   8026d1 <nsipc>
}
  8027dc:	c9                   	leave  
  8027dd:	c3                   	ret    

008027de <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8027de:	55                   	push   %ebp
  8027df:	89 e5                	mov    %esp,%ebp
  8027e1:	53                   	push   %ebx
  8027e2:	83 ec 08             	sub    $0x8,%esp
  8027e5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8027e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8027eb:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8027f0:	53                   	push   %ebx
  8027f1:	ff 75 0c             	pushl  0xc(%ebp)
  8027f4:	68 04 70 80 00       	push   $0x807004
  8027f9:	e8 a7 e8 ff ff       	call   8010a5 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8027fe:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802804:	b8 05 00 00 00       	mov    $0x5,%eax
  802809:	e8 c3 fe ff ff       	call   8026d1 <nsipc>
}
  80280e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802811:	c9                   	leave  
  802812:	c3                   	ret    

00802813 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802813:	55                   	push   %ebp
  802814:	89 e5                	mov    %esp,%ebp
  802816:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802819:	8b 45 08             	mov    0x8(%ebp),%eax
  80281c:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802821:	8b 45 0c             	mov    0xc(%ebp),%eax
  802824:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  802829:	b8 06 00 00 00       	mov    $0x6,%eax
  80282e:	e8 9e fe ff ff       	call   8026d1 <nsipc>
}
  802833:	c9                   	leave  
  802834:	c3                   	ret    

00802835 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802835:	55                   	push   %ebp
  802836:	89 e5                	mov    %esp,%ebp
  802838:	56                   	push   %esi
  802839:	53                   	push   %ebx
  80283a:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  80283d:	8b 45 08             	mov    0x8(%ebp),%eax
  802840:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  802845:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  80284b:	8b 45 14             	mov    0x14(%ebp),%eax
  80284e:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802853:	b8 07 00 00 00       	mov    $0x7,%eax
  802858:	e8 74 fe ff ff       	call   8026d1 <nsipc>
  80285d:	89 c3                	mov    %eax,%ebx
  80285f:	85 c0                	test   %eax,%eax
  802861:	78 1f                	js     802882 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  802863:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802868:	7f 21                	jg     80288b <nsipc_recv+0x56>
  80286a:	39 c6                	cmp    %eax,%esi
  80286c:	7c 1d                	jl     80288b <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80286e:	83 ec 04             	sub    $0x4,%esp
  802871:	50                   	push   %eax
  802872:	68 00 70 80 00       	push   $0x807000
  802877:	ff 75 0c             	pushl  0xc(%ebp)
  80287a:	e8 26 e8 ff ff       	call   8010a5 <memmove>
  80287f:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802882:	89 d8                	mov    %ebx,%eax
  802884:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802887:	5b                   	pop    %ebx
  802888:	5e                   	pop    %esi
  802889:	5d                   	pop    %ebp
  80288a:	c3                   	ret    
		assert(r < 1600 && r <= len);
  80288b:	68 06 34 80 00       	push   $0x803406
  802890:	68 a8 33 80 00       	push   $0x8033a8
  802895:	6a 62                	push   $0x62
  802897:	68 1b 34 80 00       	push   $0x80341b
  80289c:	e8 fe de ff ff       	call   80079f <_panic>

008028a1 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8028a1:	55                   	push   %ebp
  8028a2:	89 e5                	mov    %esp,%ebp
  8028a4:	53                   	push   %ebx
  8028a5:	83 ec 04             	sub    $0x4,%esp
  8028a8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8028ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ae:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8028b3:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8028b9:	7f 2e                	jg     8028e9 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8028bb:	83 ec 04             	sub    $0x4,%esp
  8028be:	53                   	push   %ebx
  8028bf:	ff 75 0c             	pushl  0xc(%ebp)
  8028c2:	68 0c 70 80 00       	push   $0x80700c
  8028c7:	e8 d9 e7 ff ff       	call   8010a5 <memmove>
	nsipcbuf.send.req_size = size;
  8028cc:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8028d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8028d5:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8028da:	b8 08 00 00 00       	mov    $0x8,%eax
  8028df:	e8 ed fd ff ff       	call   8026d1 <nsipc>
}
  8028e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8028e7:	c9                   	leave  
  8028e8:	c3                   	ret    
	assert(size < 1600);
  8028e9:	68 27 34 80 00       	push   $0x803427
  8028ee:	68 a8 33 80 00       	push   $0x8033a8
  8028f3:	6a 6d                	push   $0x6d
  8028f5:	68 1b 34 80 00       	push   $0x80341b
  8028fa:	e8 a0 de ff ff       	call   80079f <_panic>

008028ff <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8028ff:	55                   	push   %ebp
  802900:	89 e5                	mov    %esp,%ebp
  802902:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802905:	8b 45 08             	mov    0x8(%ebp),%eax
  802908:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  80290d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802910:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802915:	8b 45 10             	mov    0x10(%ebp),%eax
  802918:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  80291d:	b8 09 00 00 00       	mov    $0x9,%eax
  802922:	e8 aa fd ff ff       	call   8026d1 <nsipc>
}
  802927:	c9                   	leave  
  802928:	c3                   	ret    

00802929 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802929:	55                   	push   %ebp
  80292a:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  80292c:	b8 00 00 00 00       	mov    $0x0,%eax
  802931:	5d                   	pop    %ebp
  802932:	c3                   	ret    

00802933 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802933:	55                   	push   %ebp
  802934:	89 e5                	mov    %esp,%ebp
  802936:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802939:	68 33 34 80 00       	push   $0x803433
  80293e:	ff 75 0c             	pushl  0xc(%ebp)
  802941:	e8 d1 e5 ff ff       	call   800f17 <strcpy>
	return 0;
}
  802946:	b8 00 00 00 00       	mov    $0x0,%eax
  80294b:	c9                   	leave  
  80294c:	c3                   	ret    

0080294d <devcons_write>:
{
  80294d:	55                   	push   %ebp
  80294e:	89 e5                	mov    %esp,%ebp
  802950:	57                   	push   %edi
  802951:	56                   	push   %esi
  802952:	53                   	push   %ebx
  802953:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802959:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80295e:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802964:	eb 2f                	jmp    802995 <devcons_write+0x48>
		m = n - tot;
  802966:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802969:	29 f3                	sub    %esi,%ebx
  80296b:	83 fb 7f             	cmp    $0x7f,%ebx
  80296e:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802973:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802976:	83 ec 04             	sub    $0x4,%esp
  802979:	53                   	push   %ebx
  80297a:	89 f0                	mov    %esi,%eax
  80297c:	03 45 0c             	add    0xc(%ebp),%eax
  80297f:	50                   	push   %eax
  802980:	57                   	push   %edi
  802981:	e8 1f e7 ff ff       	call   8010a5 <memmove>
		sys_cputs(buf, m);
  802986:	83 c4 08             	add    $0x8,%esp
  802989:	53                   	push   %ebx
  80298a:	57                   	push   %edi
  80298b:	e8 c4 e8 ff ff       	call   801254 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802990:	01 de                	add    %ebx,%esi
  802992:	83 c4 10             	add    $0x10,%esp
  802995:	3b 75 10             	cmp    0x10(%ebp),%esi
  802998:	72 cc                	jb     802966 <devcons_write+0x19>
}
  80299a:	89 f0                	mov    %esi,%eax
  80299c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80299f:	5b                   	pop    %ebx
  8029a0:	5e                   	pop    %esi
  8029a1:	5f                   	pop    %edi
  8029a2:	5d                   	pop    %ebp
  8029a3:	c3                   	ret    

008029a4 <devcons_read>:
{
  8029a4:	55                   	push   %ebp
  8029a5:	89 e5                	mov    %esp,%ebp
  8029a7:	83 ec 08             	sub    $0x8,%esp
  8029aa:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8029af:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8029b3:	75 07                	jne    8029bc <devcons_read+0x18>
}
  8029b5:	c9                   	leave  
  8029b6:	c3                   	ret    
		sys_yield();
  8029b7:	e8 35 e9 ff ff       	call   8012f1 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  8029bc:	e8 b1 e8 ff ff       	call   801272 <sys_cgetc>
  8029c1:	85 c0                	test   %eax,%eax
  8029c3:	74 f2                	je     8029b7 <devcons_read+0x13>
	if (c < 0)
  8029c5:	85 c0                	test   %eax,%eax
  8029c7:	78 ec                	js     8029b5 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  8029c9:	83 f8 04             	cmp    $0x4,%eax
  8029cc:	74 0c                	je     8029da <devcons_read+0x36>
	*(char*)vbuf = c;
  8029ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029d1:	88 02                	mov    %al,(%edx)
	return 1;
  8029d3:	b8 01 00 00 00       	mov    $0x1,%eax
  8029d8:	eb db                	jmp    8029b5 <devcons_read+0x11>
		return 0;
  8029da:	b8 00 00 00 00       	mov    $0x0,%eax
  8029df:	eb d4                	jmp    8029b5 <devcons_read+0x11>

008029e1 <cputchar>:
{
  8029e1:	55                   	push   %ebp
  8029e2:	89 e5                	mov    %esp,%ebp
  8029e4:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8029e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ea:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8029ed:	6a 01                	push   $0x1
  8029ef:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8029f2:	50                   	push   %eax
  8029f3:	e8 5c e8 ff ff       	call   801254 <sys_cputs>
}
  8029f8:	83 c4 10             	add    $0x10,%esp
  8029fb:	c9                   	leave  
  8029fc:	c3                   	ret    

008029fd <getchar>:
{
  8029fd:	55                   	push   %ebp
  8029fe:	89 e5                	mov    %esp,%ebp
  802a00:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802a03:	6a 01                	push   $0x1
  802a05:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802a08:	50                   	push   %eax
  802a09:	6a 00                	push   $0x0
  802a0b:	e8 1e f2 ff ff       	call   801c2e <read>
	if (r < 0)
  802a10:	83 c4 10             	add    $0x10,%esp
  802a13:	85 c0                	test   %eax,%eax
  802a15:	78 08                	js     802a1f <getchar+0x22>
	if (r < 1)
  802a17:	85 c0                	test   %eax,%eax
  802a19:	7e 06                	jle    802a21 <getchar+0x24>
	return c;
  802a1b:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802a1f:	c9                   	leave  
  802a20:	c3                   	ret    
		return -E_EOF;
  802a21:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802a26:	eb f7                	jmp    802a1f <getchar+0x22>

00802a28 <iscons>:
{
  802a28:	55                   	push   %ebp
  802a29:	89 e5                	mov    %esp,%ebp
  802a2b:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802a2e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802a31:	50                   	push   %eax
  802a32:	ff 75 08             	pushl  0x8(%ebp)
  802a35:	e8 83 ef ff ff       	call   8019bd <fd_lookup>
  802a3a:	83 c4 10             	add    $0x10,%esp
  802a3d:	85 c0                	test   %eax,%eax
  802a3f:	78 11                	js     802a52 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802a41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a44:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802a4a:	39 10                	cmp    %edx,(%eax)
  802a4c:	0f 94 c0             	sete   %al
  802a4f:	0f b6 c0             	movzbl %al,%eax
}
  802a52:	c9                   	leave  
  802a53:	c3                   	ret    

00802a54 <opencons>:
{
  802a54:	55                   	push   %ebp
  802a55:	89 e5                	mov    %esp,%ebp
  802a57:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802a5a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802a5d:	50                   	push   %eax
  802a5e:	e8 0b ef ff ff       	call   80196e <fd_alloc>
  802a63:	83 c4 10             	add    $0x10,%esp
  802a66:	85 c0                	test   %eax,%eax
  802a68:	78 3a                	js     802aa4 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802a6a:	83 ec 04             	sub    $0x4,%esp
  802a6d:	68 07 04 00 00       	push   $0x407
  802a72:	ff 75 f4             	pushl  -0xc(%ebp)
  802a75:	6a 00                	push   $0x0
  802a77:	e8 94 e8 ff ff       	call   801310 <sys_page_alloc>
  802a7c:	83 c4 10             	add    $0x10,%esp
  802a7f:	85 c0                	test   %eax,%eax
  802a81:	78 21                	js     802aa4 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802a83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a86:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802a8c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802a8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a91:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802a98:	83 ec 0c             	sub    $0xc,%esp
  802a9b:	50                   	push   %eax
  802a9c:	e8 a6 ee ff ff       	call   801947 <fd2num>
  802aa1:	83 c4 10             	add    $0x10,%esp
}
  802aa4:	c9                   	leave  
  802aa5:	c3                   	ret    

00802aa6 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802aa6:	55                   	push   %ebp
  802aa7:	89 e5                	mov    %esp,%ebp
  802aa9:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802aac:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802ab3:	74 0a                	je     802abf <set_pgfault_handler+0x19>
		    panic("set_pgfault_handler: %e", r);
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802ab5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab8:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802abd:	c9                   	leave  
  802abe:	c3                   	ret    
		if ((r = sys_page_alloc(thisenv->env_id, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P)) != 0) {
  802abf:	a1 20 50 80 00       	mov    0x805020,%eax
  802ac4:	8b 40 48             	mov    0x48(%eax),%eax
  802ac7:	83 ec 04             	sub    $0x4,%esp
  802aca:	6a 07                	push   $0x7
  802acc:	68 00 f0 bf ee       	push   $0xeebff000
  802ad1:	50                   	push   %eax
  802ad2:	e8 39 e8 ff ff       	call   801310 <sys_page_alloc>
  802ad7:	83 c4 10             	add    $0x10,%esp
  802ada:	85 c0                	test   %eax,%eax
  802adc:	75 2f                	jne    802b0d <set_pgfault_handler+0x67>
		if ((r = sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall)) != 0) {
  802ade:	a1 20 50 80 00       	mov    0x805020,%eax
  802ae3:	8b 40 48             	mov    0x48(%eax),%eax
  802ae6:	83 ec 08             	sub    $0x8,%esp
  802ae9:	68 1f 2b 80 00       	push   $0x802b1f
  802aee:	50                   	push   %eax
  802aef:	e8 67 e9 ff ff       	call   80145b <sys_env_set_pgfault_upcall>
  802af4:	83 c4 10             	add    $0x10,%esp
  802af7:	85 c0                	test   %eax,%eax
  802af9:	74 ba                	je     802ab5 <set_pgfault_handler+0xf>
		    panic("set_pgfault_handler: %e", r);
  802afb:	50                   	push   %eax
  802afc:	68 3f 34 80 00       	push   $0x80343f
  802b01:	6a 24                	push   $0x24
  802b03:	68 57 34 80 00       	push   $0x803457
  802b08:	e8 92 dc ff ff       	call   80079f <_panic>
		    panic("set_pgfault_handler: %e", r);
  802b0d:	50                   	push   %eax
  802b0e:	68 3f 34 80 00       	push   $0x80343f
  802b13:	6a 21                	push   $0x21
  802b15:	68 57 34 80 00       	push   $0x803457
  802b1a:	e8 80 dc ff ff       	call   80079f <_panic>

00802b1f <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802b1f:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802b20:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  802b25:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802b27:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x30(%esp), %ecx    // save trap-time esp in ecx
  802b2a:	8b 4c 24 30          	mov    0x30(%esp),%ecx
	subl $4, %ecx            // enlarge the previous stack for 4 bytes
  802b2e:	83 e9 04             	sub    $0x4,%ecx
	movl %ecx, 0x30(%esp)    // write the modified esp back
  802b31:	89 4c 24 30          	mov    %ecx,0x30(%esp)
	movl 0x28(%esp), %edx    // save trap-time eip in edx
  802b35:	8b 54 24 28          	mov    0x28(%esp),%edx
	movl %edx, (%ecx)        // save eip at new esp for return
  802b39:	89 11                	mov    %edx,(%ecx)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp            // skip fault_va and tf_err
  802b3b:	83 c4 08             	add    $0x8,%esp
	popal                    // pop PushRegs
  802b3e:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4, %esp            // skip eip
  802b3f:	83 c4 04             	add    $0x4,%esp
	popfl                    // pop eflags
  802b42:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	pop %esp
  802b43:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802b44:	c3                   	ret    

00802b45 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802b45:	55                   	push   %ebp
  802b46:	89 e5                	mov    %esp,%ebp
  802b48:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802b4b:	89 d0                	mov    %edx,%eax
  802b4d:	c1 e8 16             	shr    $0x16,%eax
  802b50:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802b57:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802b5c:	f6 c1 01             	test   $0x1,%cl
  802b5f:	74 1d                	je     802b7e <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802b61:	c1 ea 0c             	shr    $0xc,%edx
  802b64:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802b6b:	f6 c2 01             	test   $0x1,%dl
  802b6e:	74 0e                	je     802b7e <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802b70:	c1 ea 0c             	shr    $0xc,%edx
  802b73:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802b7a:	ef 
  802b7b:	0f b7 c0             	movzwl %ax,%eax
}
  802b7e:	5d                   	pop    %ebp
  802b7f:	c3                   	ret    

00802b80 <__udivdi3>:
  802b80:	55                   	push   %ebp
  802b81:	57                   	push   %edi
  802b82:	56                   	push   %esi
  802b83:	53                   	push   %ebx
  802b84:	83 ec 1c             	sub    $0x1c,%esp
  802b87:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  802b8b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802b8f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802b93:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802b97:	85 d2                	test   %edx,%edx
  802b99:	75 35                	jne    802bd0 <__udivdi3+0x50>
  802b9b:	39 f3                	cmp    %esi,%ebx
  802b9d:	0f 87 bd 00 00 00    	ja     802c60 <__udivdi3+0xe0>
  802ba3:	85 db                	test   %ebx,%ebx
  802ba5:	89 d9                	mov    %ebx,%ecx
  802ba7:	75 0b                	jne    802bb4 <__udivdi3+0x34>
  802ba9:	b8 01 00 00 00       	mov    $0x1,%eax
  802bae:	31 d2                	xor    %edx,%edx
  802bb0:	f7 f3                	div    %ebx
  802bb2:	89 c1                	mov    %eax,%ecx
  802bb4:	31 d2                	xor    %edx,%edx
  802bb6:	89 f0                	mov    %esi,%eax
  802bb8:	f7 f1                	div    %ecx
  802bba:	89 c6                	mov    %eax,%esi
  802bbc:	89 e8                	mov    %ebp,%eax
  802bbe:	89 f7                	mov    %esi,%edi
  802bc0:	f7 f1                	div    %ecx
  802bc2:	89 fa                	mov    %edi,%edx
  802bc4:	83 c4 1c             	add    $0x1c,%esp
  802bc7:	5b                   	pop    %ebx
  802bc8:	5e                   	pop    %esi
  802bc9:	5f                   	pop    %edi
  802bca:	5d                   	pop    %ebp
  802bcb:	c3                   	ret    
  802bcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802bd0:	39 f2                	cmp    %esi,%edx
  802bd2:	77 7c                	ja     802c50 <__udivdi3+0xd0>
  802bd4:	0f bd fa             	bsr    %edx,%edi
  802bd7:	83 f7 1f             	xor    $0x1f,%edi
  802bda:	0f 84 98 00 00 00    	je     802c78 <__udivdi3+0xf8>
  802be0:	89 f9                	mov    %edi,%ecx
  802be2:	b8 20 00 00 00       	mov    $0x20,%eax
  802be7:	29 f8                	sub    %edi,%eax
  802be9:	d3 e2                	shl    %cl,%edx
  802beb:	89 54 24 08          	mov    %edx,0x8(%esp)
  802bef:	89 c1                	mov    %eax,%ecx
  802bf1:	89 da                	mov    %ebx,%edx
  802bf3:	d3 ea                	shr    %cl,%edx
  802bf5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802bf9:	09 d1                	or     %edx,%ecx
  802bfb:	89 f2                	mov    %esi,%edx
  802bfd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802c01:	89 f9                	mov    %edi,%ecx
  802c03:	d3 e3                	shl    %cl,%ebx
  802c05:	89 c1                	mov    %eax,%ecx
  802c07:	d3 ea                	shr    %cl,%edx
  802c09:	89 f9                	mov    %edi,%ecx
  802c0b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802c0f:	d3 e6                	shl    %cl,%esi
  802c11:	89 eb                	mov    %ebp,%ebx
  802c13:	89 c1                	mov    %eax,%ecx
  802c15:	d3 eb                	shr    %cl,%ebx
  802c17:	09 de                	or     %ebx,%esi
  802c19:	89 f0                	mov    %esi,%eax
  802c1b:	f7 74 24 08          	divl   0x8(%esp)
  802c1f:	89 d6                	mov    %edx,%esi
  802c21:	89 c3                	mov    %eax,%ebx
  802c23:	f7 64 24 0c          	mull   0xc(%esp)
  802c27:	39 d6                	cmp    %edx,%esi
  802c29:	72 0c                	jb     802c37 <__udivdi3+0xb7>
  802c2b:	89 f9                	mov    %edi,%ecx
  802c2d:	d3 e5                	shl    %cl,%ebp
  802c2f:	39 c5                	cmp    %eax,%ebp
  802c31:	73 5d                	jae    802c90 <__udivdi3+0x110>
  802c33:	39 d6                	cmp    %edx,%esi
  802c35:	75 59                	jne    802c90 <__udivdi3+0x110>
  802c37:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802c3a:	31 ff                	xor    %edi,%edi
  802c3c:	89 fa                	mov    %edi,%edx
  802c3e:	83 c4 1c             	add    $0x1c,%esp
  802c41:	5b                   	pop    %ebx
  802c42:	5e                   	pop    %esi
  802c43:	5f                   	pop    %edi
  802c44:	5d                   	pop    %ebp
  802c45:	c3                   	ret    
  802c46:	8d 76 00             	lea    0x0(%esi),%esi
  802c49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  802c50:	31 ff                	xor    %edi,%edi
  802c52:	31 c0                	xor    %eax,%eax
  802c54:	89 fa                	mov    %edi,%edx
  802c56:	83 c4 1c             	add    $0x1c,%esp
  802c59:	5b                   	pop    %ebx
  802c5a:	5e                   	pop    %esi
  802c5b:	5f                   	pop    %edi
  802c5c:	5d                   	pop    %ebp
  802c5d:	c3                   	ret    
  802c5e:	66 90                	xchg   %ax,%ax
  802c60:	31 ff                	xor    %edi,%edi
  802c62:	89 e8                	mov    %ebp,%eax
  802c64:	89 f2                	mov    %esi,%edx
  802c66:	f7 f3                	div    %ebx
  802c68:	89 fa                	mov    %edi,%edx
  802c6a:	83 c4 1c             	add    $0x1c,%esp
  802c6d:	5b                   	pop    %ebx
  802c6e:	5e                   	pop    %esi
  802c6f:	5f                   	pop    %edi
  802c70:	5d                   	pop    %ebp
  802c71:	c3                   	ret    
  802c72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802c78:	39 f2                	cmp    %esi,%edx
  802c7a:	72 06                	jb     802c82 <__udivdi3+0x102>
  802c7c:	31 c0                	xor    %eax,%eax
  802c7e:	39 eb                	cmp    %ebp,%ebx
  802c80:	77 d2                	ja     802c54 <__udivdi3+0xd4>
  802c82:	b8 01 00 00 00       	mov    $0x1,%eax
  802c87:	eb cb                	jmp    802c54 <__udivdi3+0xd4>
  802c89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802c90:	89 d8                	mov    %ebx,%eax
  802c92:	31 ff                	xor    %edi,%edi
  802c94:	eb be                	jmp    802c54 <__udivdi3+0xd4>
  802c96:	66 90                	xchg   %ax,%ax
  802c98:	66 90                	xchg   %ax,%ax
  802c9a:	66 90                	xchg   %ax,%ax
  802c9c:	66 90                	xchg   %ax,%ax
  802c9e:	66 90                	xchg   %ax,%ax

00802ca0 <__umoddi3>:
  802ca0:	55                   	push   %ebp
  802ca1:	57                   	push   %edi
  802ca2:	56                   	push   %esi
  802ca3:	53                   	push   %ebx
  802ca4:	83 ec 1c             	sub    $0x1c,%esp
  802ca7:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  802cab:	8b 74 24 30          	mov    0x30(%esp),%esi
  802caf:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802cb3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802cb7:	85 ed                	test   %ebp,%ebp
  802cb9:	89 f0                	mov    %esi,%eax
  802cbb:	89 da                	mov    %ebx,%edx
  802cbd:	75 19                	jne    802cd8 <__umoddi3+0x38>
  802cbf:	39 df                	cmp    %ebx,%edi
  802cc1:	0f 86 b1 00 00 00    	jbe    802d78 <__umoddi3+0xd8>
  802cc7:	f7 f7                	div    %edi
  802cc9:	89 d0                	mov    %edx,%eax
  802ccb:	31 d2                	xor    %edx,%edx
  802ccd:	83 c4 1c             	add    $0x1c,%esp
  802cd0:	5b                   	pop    %ebx
  802cd1:	5e                   	pop    %esi
  802cd2:	5f                   	pop    %edi
  802cd3:	5d                   	pop    %ebp
  802cd4:	c3                   	ret    
  802cd5:	8d 76 00             	lea    0x0(%esi),%esi
  802cd8:	39 dd                	cmp    %ebx,%ebp
  802cda:	77 f1                	ja     802ccd <__umoddi3+0x2d>
  802cdc:	0f bd cd             	bsr    %ebp,%ecx
  802cdf:	83 f1 1f             	xor    $0x1f,%ecx
  802ce2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802ce6:	0f 84 b4 00 00 00    	je     802da0 <__umoddi3+0x100>
  802cec:	b8 20 00 00 00       	mov    $0x20,%eax
  802cf1:	89 c2                	mov    %eax,%edx
  802cf3:	8b 44 24 04          	mov    0x4(%esp),%eax
  802cf7:	29 c2                	sub    %eax,%edx
  802cf9:	89 c1                	mov    %eax,%ecx
  802cfb:	89 f8                	mov    %edi,%eax
  802cfd:	d3 e5                	shl    %cl,%ebp
  802cff:	89 d1                	mov    %edx,%ecx
  802d01:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802d05:	d3 e8                	shr    %cl,%eax
  802d07:	09 c5                	or     %eax,%ebp
  802d09:	8b 44 24 04          	mov    0x4(%esp),%eax
  802d0d:	89 c1                	mov    %eax,%ecx
  802d0f:	d3 e7                	shl    %cl,%edi
  802d11:	89 d1                	mov    %edx,%ecx
  802d13:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802d17:	89 df                	mov    %ebx,%edi
  802d19:	d3 ef                	shr    %cl,%edi
  802d1b:	89 c1                	mov    %eax,%ecx
  802d1d:	89 f0                	mov    %esi,%eax
  802d1f:	d3 e3                	shl    %cl,%ebx
  802d21:	89 d1                	mov    %edx,%ecx
  802d23:	89 fa                	mov    %edi,%edx
  802d25:	d3 e8                	shr    %cl,%eax
  802d27:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802d2c:	09 d8                	or     %ebx,%eax
  802d2e:	f7 f5                	div    %ebp
  802d30:	d3 e6                	shl    %cl,%esi
  802d32:	89 d1                	mov    %edx,%ecx
  802d34:	f7 64 24 08          	mull   0x8(%esp)
  802d38:	39 d1                	cmp    %edx,%ecx
  802d3a:	89 c3                	mov    %eax,%ebx
  802d3c:	89 d7                	mov    %edx,%edi
  802d3e:	72 06                	jb     802d46 <__umoddi3+0xa6>
  802d40:	75 0e                	jne    802d50 <__umoddi3+0xb0>
  802d42:	39 c6                	cmp    %eax,%esi
  802d44:	73 0a                	jae    802d50 <__umoddi3+0xb0>
  802d46:	2b 44 24 08          	sub    0x8(%esp),%eax
  802d4a:	19 ea                	sbb    %ebp,%edx
  802d4c:	89 d7                	mov    %edx,%edi
  802d4e:	89 c3                	mov    %eax,%ebx
  802d50:	89 ca                	mov    %ecx,%edx
  802d52:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  802d57:	29 de                	sub    %ebx,%esi
  802d59:	19 fa                	sbb    %edi,%edx
  802d5b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  802d5f:	89 d0                	mov    %edx,%eax
  802d61:	d3 e0                	shl    %cl,%eax
  802d63:	89 d9                	mov    %ebx,%ecx
  802d65:	d3 ee                	shr    %cl,%esi
  802d67:	d3 ea                	shr    %cl,%edx
  802d69:	09 f0                	or     %esi,%eax
  802d6b:	83 c4 1c             	add    $0x1c,%esp
  802d6e:	5b                   	pop    %ebx
  802d6f:	5e                   	pop    %esi
  802d70:	5f                   	pop    %edi
  802d71:	5d                   	pop    %ebp
  802d72:	c3                   	ret    
  802d73:	90                   	nop
  802d74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802d78:	85 ff                	test   %edi,%edi
  802d7a:	89 f9                	mov    %edi,%ecx
  802d7c:	75 0b                	jne    802d89 <__umoddi3+0xe9>
  802d7e:	b8 01 00 00 00       	mov    $0x1,%eax
  802d83:	31 d2                	xor    %edx,%edx
  802d85:	f7 f7                	div    %edi
  802d87:	89 c1                	mov    %eax,%ecx
  802d89:	89 d8                	mov    %ebx,%eax
  802d8b:	31 d2                	xor    %edx,%edx
  802d8d:	f7 f1                	div    %ecx
  802d8f:	89 f0                	mov    %esi,%eax
  802d91:	f7 f1                	div    %ecx
  802d93:	e9 31 ff ff ff       	jmp    802cc9 <__umoddi3+0x29>
  802d98:	90                   	nop
  802d99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802da0:	39 dd                	cmp    %ebx,%ebp
  802da2:	72 08                	jb     802dac <__umoddi3+0x10c>
  802da4:	39 f7                	cmp    %esi,%edi
  802da6:	0f 87 21 ff ff ff    	ja     802ccd <__umoddi3+0x2d>
  802dac:	89 da                	mov    %ebx,%edx
  802dae:	89 f0                	mov    %esi,%eax
  802db0:	29 f8                	sub    %edi,%eax
  802db2:	19 ea                	sbb    %ebp,%edx
  802db4:	e9 14 ff ff ff       	jmp    802ccd <__umoddi3+0x2d>
