
obj/user/faultregs.debug:     file format elf32-i386


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
  80002c:	e8 ae 05 00 00       	call   8005df <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <check_regs>:
static struct regs before, during, after;

static void
check_regs(struct regs* a, const char *an, struct regs* b, const char *bn,
	   const char *testname)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 0c             	sub    $0xc,%esp
  80003c:	89 c6                	mov    %eax,%esi
  80003e:	89 cb                	mov    %ecx,%ebx
	int mismatch = 0;

	cprintf("%-6s %-8s %-8s\n", "", an, bn);
  800040:	ff 75 08             	pushl  0x8(%ebp)
  800043:	52                   	push   %edx
  800044:	68 71 29 80 00       	push   $0x802971
  800049:	68 40 29 80 00       	push   $0x802940
  80004e:	e8 c7 06 00 00       	call   80071a <cprintf>
			cprintf("MISMATCH\n");				\
			mismatch = 1;					\
		}							\
	} while (0)

	CHECK(edi, regs.reg_edi);
  800053:	ff 33                	pushl  (%ebx)
  800055:	ff 36                	pushl  (%esi)
  800057:	68 50 29 80 00       	push   $0x802950
  80005c:	68 54 29 80 00       	push   $0x802954
  800061:	e8 b4 06 00 00       	call   80071a <cprintf>
  800066:	83 c4 20             	add    $0x20,%esp
  800069:	8b 03                	mov    (%ebx),%eax
  80006b:	39 06                	cmp    %eax,(%esi)
  80006d:	0f 84 31 02 00 00    	je     8002a4 <check_regs+0x271>
  800073:	83 ec 0c             	sub    $0xc,%esp
  800076:	68 68 29 80 00       	push   $0x802968
  80007b:	e8 9a 06 00 00       	call   80071a <cprintf>
  800080:	83 c4 10             	add    $0x10,%esp
  800083:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(esi, regs.reg_esi);
  800088:	ff 73 04             	pushl  0x4(%ebx)
  80008b:	ff 76 04             	pushl  0x4(%esi)
  80008e:	68 72 29 80 00       	push   $0x802972
  800093:	68 54 29 80 00       	push   $0x802954
  800098:	e8 7d 06 00 00       	call   80071a <cprintf>
  80009d:	83 c4 10             	add    $0x10,%esp
  8000a0:	8b 43 04             	mov    0x4(%ebx),%eax
  8000a3:	39 46 04             	cmp    %eax,0x4(%esi)
  8000a6:	0f 84 12 02 00 00    	je     8002be <check_regs+0x28b>
  8000ac:	83 ec 0c             	sub    $0xc,%esp
  8000af:	68 68 29 80 00       	push   $0x802968
  8000b4:	e8 61 06 00 00       	call   80071a <cprintf>
  8000b9:	83 c4 10             	add    $0x10,%esp
  8000bc:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ebp, regs.reg_ebp);
  8000c1:	ff 73 08             	pushl  0x8(%ebx)
  8000c4:	ff 76 08             	pushl  0x8(%esi)
  8000c7:	68 76 29 80 00       	push   $0x802976
  8000cc:	68 54 29 80 00       	push   $0x802954
  8000d1:	e8 44 06 00 00       	call   80071a <cprintf>
  8000d6:	83 c4 10             	add    $0x10,%esp
  8000d9:	8b 43 08             	mov    0x8(%ebx),%eax
  8000dc:	39 46 08             	cmp    %eax,0x8(%esi)
  8000df:	0f 84 ee 01 00 00    	je     8002d3 <check_regs+0x2a0>
  8000e5:	83 ec 0c             	sub    $0xc,%esp
  8000e8:	68 68 29 80 00       	push   $0x802968
  8000ed:	e8 28 06 00 00       	call   80071a <cprintf>
  8000f2:	83 c4 10             	add    $0x10,%esp
  8000f5:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ebx, regs.reg_ebx);
  8000fa:	ff 73 10             	pushl  0x10(%ebx)
  8000fd:	ff 76 10             	pushl  0x10(%esi)
  800100:	68 7a 29 80 00       	push   $0x80297a
  800105:	68 54 29 80 00       	push   $0x802954
  80010a:	e8 0b 06 00 00       	call   80071a <cprintf>
  80010f:	83 c4 10             	add    $0x10,%esp
  800112:	8b 43 10             	mov    0x10(%ebx),%eax
  800115:	39 46 10             	cmp    %eax,0x10(%esi)
  800118:	0f 84 ca 01 00 00    	je     8002e8 <check_regs+0x2b5>
  80011e:	83 ec 0c             	sub    $0xc,%esp
  800121:	68 68 29 80 00       	push   $0x802968
  800126:	e8 ef 05 00 00       	call   80071a <cprintf>
  80012b:	83 c4 10             	add    $0x10,%esp
  80012e:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(edx, regs.reg_edx);
  800133:	ff 73 14             	pushl  0x14(%ebx)
  800136:	ff 76 14             	pushl  0x14(%esi)
  800139:	68 7e 29 80 00       	push   $0x80297e
  80013e:	68 54 29 80 00       	push   $0x802954
  800143:	e8 d2 05 00 00       	call   80071a <cprintf>
  800148:	83 c4 10             	add    $0x10,%esp
  80014b:	8b 43 14             	mov    0x14(%ebx),%eax
  80014e:	39 46 14             	cmp    %eax,0x14(%esi)
  800151:	0f 84 a6 01 00 00    	je     8002fd <check_regs+0x2ca>
  800157:	83 ec 0c             	sub    $0xc,%esp
  80015a:	68 68 29 80 00       	push   $0x802968
  80015f:	e8 b6 05 00 00       	call   80071a <cprintf>
  800164:	83 c4 10             	add    $0x10,%esp
  800167:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ecx, regs.reg_ecx);
  80016c:	ff 73 18             	pushl  0x18(%ebx)
  80016f:	ff 76 18             	pushl  0x18(%esi)
  800172:	68 82 29 80 00       	push   $0x802982
  800177:	68 54 29 80 00       	push   $0x802954
  80017c:	e8 99 05 00 00       	call   80071a <cprintf>
  800181:	83 c4 10             	add    $0x10,%esp
  800184:	8b 43 18             	mov    0x18(%ebx),%eax
  800187:	39 46 18             	cmp    %eax,0x18(%esi)
  80018a:	0f 84 82 01 00 00    	je     800312 <check_regs+0x2df>
  800190:	83 ec 0c             	sub    $0xc,%esp
  800193:	68 68 29 80 00       	push   $0x802968
  800198:	e8 7d 05 00 00       	call   80071a <cprintf>
  80019d:	83 c4 10             	add    $0x10,%esp
  8001a0:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eax, regs.reg_eax);
  8001a5:	ff 73 1c             	pushl  0x1c(%ebx)
  8001a8:	ff 76 1c             	pushl  0x1c(%esi)
  8001ab:	68 86 29 80 00       	push   $0x802986
  8001b0:	68 54 29 80 00       	push   $0x802954
  8001b5:	e8 60 05 00 00       	call   80071a <cprintf>
  8001ba:	83 c4 10             	add    $0x10,%esp
  8001bd:	8b 43 1c             	mov    0x1c(%ebx),%eax
  8001c0:	39 46 1c             	cmp    %eax,0x1c(%esi)
  8001c3:	0f 84 5e 01 00 00    	je     800327 <check_regs+0x2f4>
  8001c9:	83 ec 0c             	sub    $0xc,%esp
  8001cc:	68 68 29 80 00       	push   $0x802968
  8001d1:	e8 44 05 00 00       	call   80071a <cprintf>
  8001d6:	83 c4 10             	add    $0x10,%esp
  8001d9:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eip, eip);
  8001de:	ff 73 20             	pushl  0x20(%ebx)
  8001e1:	ff 76 20             	pushl  0x20(%esi)
  8001e4:	68 8a 29 80 00       	push   $0x80298a
  8001e9:	68 54 29 80 00       	push   $0x802954
  8001ee:	e8 27 05 00 00       	call   80071a <cprintf>
  8001f3:	83 c4 10             	add    $0x10,%esp
  8001f6:	8b 43 20             	mov    0x20(%ebx),%eax
  8001f9:	39 46 20             	cmp    %eax,0x20(%esi)
  8001fc:	0f 84 3a 01 00 00    	je     80033c <check_regs+0x309>
  800202:	83 ec 0c             	sub    $0xc,%esp
  800205:	68 68 29 80 00       	push   $0x802968
  80020a:	e8 0b 05 00 00       	call   80071a <cprintf>
  80020f:	83 c4 10             	add    $0x10,%esp
  800212:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eflags, eflags);
  800217:	ff 73 24             	pushl  0x24(%ebx)
  80021a:	ff 76 24             	pushl  0x24(%esi)
  80021d:	68 8e 29 80 00       	push   $0x80298e
  800222:	68 54 29 80 00       	push   $0x802954
  800227:	e8 ee 04 00 00       	call   80071a <cprintf>
  80022c:	83 c4 10             	add    $0x10,%esp
  80022f:	8b 43 24             	mov    0x24(%ebx),%eax
  800232:	39 46 24             	cmp    %eax,0x24(%esi)
  800235:	0f 84 16 01 00 00    	je     800351 <check_regs+0x31e>
  80023b:	83 ec 0c             	sub    $0xc,%esp
  80023e:	68 68 29 80 00       	push   $0x802968
  800243:	e8 d2 04 00 00       	call   80071a <cprintf>
	CHECK(esp, esp);
  800248:	ff 73 28             	pushl  0x28(%ebx)
  80024b:	ff 76 28             	pushl  0x28(%esi)
  80024e:	68 95 29 80 00       	push   $0x802995
  800253:	68 54 29 80 00       	push   $0x802954
  800258:	e8 bd 04 00 00       	call   80071a <cprintf>
  80025d:	83 c4 20             	add    $0x20,%esp
  800260:	8b 43 28             	mov    0x28(%ebx),%eax
  800263:	39 46 28             	cmp    %eax,0x28(%esi)
  800266:	0f 84 53 01 00 00    	je     8003bf <check_regs+0x38c>
  80026c:	83 ec 0c             	sub    $0xc,%esp
  80026f:	68 68 29 80 00       	push   $0x802968
  800274:	e8 a1 04 00 00       	call   80071a <cprintf>

#undef CHECK

	cprintf("Registers %s ", testname);
  800279:	83 c4 08             	add    $0x8,%esp
  80027c:	ff 75 0c             	pushl  0xc(%ebp)
  80027f:	68 99 29 80 00       	push   $0x802999
  800284:	e8 91 04 00 00       	call   80071a <cprintf>
  800289:	83 c4 10             	add    $0x10,%esp
	if (!mismatch)
		cprintf("OK\n");
	else
		cprintf("MISMATCH\n");
  80028c:	83 ec 0c             	sub    $0xc,%esp
  80028f:	68 68 29 80 00       	push   $0x802968
  800294:	e8 81 04 00 00       	call   80071a <cprintf>
  800299:	83 c4 10             	add    $0x10,%esp
}
  80029c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80029f:	5b                   	pop    %ebx
  8002a0:	5e                   	pop    %esi
  8002a1:	5f                   	pop    %edi
  8002a2:	5d                   	pop    %ebp
  8002a3:	c3                   	ret    
	CHECK(edi, regs.reg_edi);
  8002a4:	83 ec 0c             	sub    $0xc,%esp
  8002a7:	68 64 29 80 00       	push   $0x802964
  8002ac:	e8 69 04 00 00       	call   80071a <cprintf>
  8002b1:	83 c4 10             	add    $0x10,%esp
	int mismatch = 0;
  8002b4:	bf 00 00 00 00       	mov    $0x0,%edi
  8002b9:	e9 ca fd ff ff       	jmp    800088 <check_regs+0x55>
	CHECK(esi, regs.reg_esi);
  8002be:	83 ec 0c             	sub    $0xc,%esp
  8002c1:	68 64 29 80 00       	push   $0x802964
  8002c6:	e8 4f 04 00 00       	call   80071a <cprintf>
  8002cb:	83 c4 10             	add    $0x10,%esp
  8002ce:	e9 ee fd ff ff       	jmp    8000c1 <check_regs+0x8e>
	CHECK(ebp, regs.reg_ebp);
  8002d3:	83 ec 0c             	sub    $0xc,%esp
  8002d6:	68 64 29 80 00       	push   $0x802964
  8002db:	e8 3a 04 00 00       	call   80071a <cprintf>
  8002e0:	83 c4 10             	add    $0x10,%esp
  8002e3:	e9 12 fe ff ff       	jmp    8000fa <check_regs+0xc7>
	CHECK(ebx, regs.reg_ebx);
  8002e8:	83 ec 0c             	sub    $0xc,%esp
  8002eb:	68 64 29 80 00       	push   $0x802964
  8002f0:	e8 25 04 00 00       	call   80071a <cprintf>
  8002f5:	83 c4 10             	add    $0x10,%esp
  8002f8:	e9 36 fe ff ff       	jmp    800133 <check_regs+0x100>
	CHECK(edx, regs.reg_edx);
  8002fd:	83 ec 0c             	sub    $0xc,%esp
  800300:	68 64 29 80 00       	push   $0x802964
  800305:	e8 10 04 00 00       	call   80071a <cprintf>
  80030a:	83 c4 10             	add    $0x10,%esp
  80030d:	e9 5a fe ff ff       	jmp    80016c <check_regs+0x139>
	CHECK(ecx, regs.reg_ecx);
  800312:	83 ec 0c             	sub    $0xc,%esp
  800315:	68 64 29 80 00       	push   $0x802964
  80031a:	e8 fb 03 00 00       	call   80071a <cprintf>
  80031f:	83 c4 10             	add    $0x10,%esp
  800322:	e9 7e fe ff ff       	jmp    8001a5 <check_regs+0x172>
	CHECK(eax, regs.reg_eax);
  800327:	83 ec 0c             	sub    $0xc,%esp
  80032a:	68 64 29 80 00       	push   $0x802964
  80032f:	e8 e6 03 00 00       	call   80071a <cprintf>
  800334:	83 c4 10             	add    $0x10,%esp
  800337:	e9 a2 fe ff ff       	jmp    8001de <check_regs+0x1ab>
	CHECK(eip, eip);
  80033c:	83 ec 0c             	sub    $0xc,%esp
  80033f:	68 64 29 80 00       	push   $0x802964
  800344:	e8 d1 03 00 00       	call   80071a <cprintf>
  800349:	83 c4 10             	add    $0x10,%esp
  80034c:	e9 c6 fe ff ff       	jmp    800217 <check_regs+0x1e4>
	CHECK(eflags, eflags);
  800351:	83 ec 0c             	sub    $0xc,%esp
  800354:	68 64 29 80 00       	push   $0x802964
  800359:	e8 bc 03 00 00       	call   80071a <cprintf>
	CHECK(esp, esp);
  80035e:	ff 73 28             	pushl  0x28(%ebx)
  800361:	ff 76 28             	pushl  0x28(%esi)
  800364:	68 95 29 80 00       	push   $0x802995
  800369:	68 54 29 80 00       	push   $0x802954
  80036e:	e8 a7 03 00 00       	call   80071a <cprintf>
  800373:	83 c4 20             	add    $0x20,%esp
  800376:	8b 43 28             	mov    0x28(%ebx),%eax
  800379:	39 46 28             	cmp    %eax,0x28(%esi)
  80037c:	0f 85 ea fe ff ff    	jne    80026c <check_regs+0x239>
  800382:	83 ec 0c             	sub    $0xc,%esp
  800385:	68 64 29 80 00       	push   $0x802964
  80038a:	e8 8b 03 00 00       	call   80071a <cprintf>
	cprintf("Registers %s ", testname);
  80038f:	83 c4 08             	add    $0x8,%esp
  800392:	ff 75 0c             	pushl  0xc(%ebp)
  800395:	68 99 29 80 00       	push   $0x802999
  80039a:	e8 7b 03 00 00       	call   80071a <cprintf>
	if (!mismatch)
  80039f:	83 c4 10             	add    $0x10,%esp
  8003a2:	85 ff                	test   %edi,%edi
  8003a4:	0f 85 e2 fe ff ff    	jne    80028c <check_regs+0x259>
		cprintf("OK\n");
  8003aa:	83 ec 0c             	sub    $0xc,%esp
  8003ad:	68 64 29 80 00       	push   $0x802964
  8003b2:	e8 63 03 00 00       	call   80071a <cprintf>
  8003b7:	83 c4 10             	add    $0x10,%esp
  8003ba:	e9 dd fe ff ff       	jmp    80029c <check_regs+0x269>
	CHECK(esp, esp);
  8003bf:	83 ec 0c             	sub    $0xc,%esp
  8003c2:	68 64 29 80 00       	push   $0x802964
  8003c7:	e8 4e 03 00 00       	call   80071a <cprintf>
	cprintf("Registers %s ", testname);
  8003cc:	83 c4 08             	add    $0x8,%esp
  8003cf:	ff 75 0c             	pushl  0xc(%ebp)
  8003d2:	68 99 29 80 00       	push   $0x802999
  8003d7:	e8 3e 03 00 00       	call   80071a <cprintf>
  8003dc:	83 c4 10             	add    $0x10,%esp
  8003df:	e9 a8 fe ff ff       	jmp    80028c <check_regs+0x259>

008003e4 <pgfault>:

static void
pgfault(struct UTrapframe *utf)
{
  8003e4:	55                   	push   %ebp
  8003e5:	89 e5                	mov    %esp,%ebp
  8003e7:	83 ec 08             	sub    $0x8,%esp
  8003ea:	8b 45 08             	mov    0x8(%ebp),%eax
	int r;

	if (utf->utf_fault_va != (uint32_t)UTEMP)
  8003ed:	8b 10                	mov    (%eax),%edx
  8003ef:	81 fa 00 00 40 00    	cmp    $0x400000,%edx
  8003f5:	0f 85 a3 00 00 00    	jne    80049e <pgfault+0xba>
		panic("pgfault expected at UTEMP, got 0x%08x (eip %08x)",
		      utf->utf_fault_va, utf->utf_eip);

	// Check registers in UTrapframe
	during.regs = utf->utf_regs;
  8003fb:	8b 50 08             	mov    0x8(%eax),%edx
  8003fe:	89 15 40 40 80 00    	mov    %edx,0x804040
  800404:	8b 50 0c             	mov    0xc(%eax),%edx
  800407:	89 15 44 40 80 00    	mov    %edx,0x804044
  80040d:	8b 50 10             	mov    0x10(%eax),%edx
  800410:	89 15 48 40 80 00    	mov    %edx,0x804048
  800416:	8b 50 14             	mov    0x14(%eax),%edx
  800419:	89 15 4c 40 80 00    	mov    %edx,0x80404c
  80041f:	8b 50 18             	mov    0x18(%eax),%edx
  800422:	89 15 50 40 80 00    	mov    %edx,0x804050
  800428:	8b 50 1c             	mov    0x1c(%eax),%edx
  80042b:	89 15 54 40 80 00    	mov    %edx,0x804054
  800431:	8b 50 20             	mov    0x20(%eax),%edx
  800434:	89 15 58 40 80 00    	mov    %edx,0x804058
  80043a:	8b 50 24             	mov    0x24(%eax),%edx
  80043d:	89 15 5c 40 80 00    	mov    %edx,0x80405c
	during.eip = utf->utf_eip;
  800443:	8b 50 28             	mov    0x28(%eax),%edx
  800446:	89 15 60 40 80 00    	mov    %edx,0x804060
	during.eflags = utf->utf_eflags & ~FL_RF;
  80044c:	8b 50 2c             	mov    0x2c(%eax),%edx
  80044f:	81 e2 ff ff fe ff    	and    $0xfffeffff,%edx
  800455:	89 15 64 40 80 00    	mov    %edx,0x804064
	during.esp = utf->utf_esp;
  80045b:	8b 40 30             	mov    0x30(%eax),%eax
  80045e:	a3 68 40 80 00       	mov    %eax,0x804068
	check_regs(&before, "before", &during, "during", "in UTrapframe");
  800463:	83 ec 08             	sub    $0x8,%esp
  800466:	68 bf 29 80 00       	push   $0x8029bf
  80046b:	68 cd 29 80 00       	push   $0x8029cd
  800470:	b9 40 40 80 00       	mov    $0x804040,%ecx
  800475:	ba b8 29 80 00       	mov    $0x8029b8,%edx
  80047a:	b8 80 40 80 00       	mov    $0x804080,%eax
  80047f:	e8 af fb ff ff       	call   800033 <check_regs>

	// Map UTEMP so the write succeeds
	if ((r = sys_page_alloc(0, UTEMP, PTE_U|PTE_P|PTE_W)) < 0)
  800484:	83 c4 0c             	add    $0xc,%esp
  800487:	6a 07                	push   $0x7
  800489:	68 00 00 40 00       	push   $0x400000
  80048e:	6a 00                	push   $0x0
  800490:	e8 1b 0d 00 00       	call   8011b0 <sys_page_alloc>
  800495:	83 c4 10             	add    $0x10,%esp
  800498:	85 c0                	test   %eax,%eax
  80049a:	78 1a                	js     8004b6 <pgfault+0xd2>
		panic("sys_page_alloc: %e", r);
}
  80049c:	c9                   	leave  
  80049d:	c3                   	ret    
		panic("pgfault expected at UTEMP, got 0x%08x (eip %08x)",
  80049e:	83 ec 0c             	sub    $0xc,%esp
  8004a1:	ff 70 28             	pushl  0x28(%eax)
  8004a4:	52                   	push   %edx
  8004a5:	68 00 2a 80 00       	push   $0x802a00
  8004aa:	6a 51                	push   $0x51
  8004ac:	68 a7 29 80 00       	push   $0x8029a7
  8004b1:	e8 89 01 00 00       	call   80063f <_panic>
		panic("sys_page_alloc: %e", r);
  8004b6:	50                   	push   %eax
  8004b7:	68 d4 29 80 00       	push   $0x8029d4
  8004bc:	6a 5c                	push   $0x5c
  8004be:	68 a7 29 80 00       	push   $0x8029a7
  8004c3:	e8 77 01 00 00       	call   80063f <_panic>

008004c8 <umain>:

void
umain(int argc, char **argv)
{
  8004c8:	55                   	push   %ebp
  8004c9:	89 e5                	mov    %esp,%ebp
  8004cb:	83 ec 14             	sub    $0x14,%esp
	set_pgfault_handler(pgfault);
  8004ce:	68 e4 03 80 00       	push   $0x8003e4
  8004d3:	e8 e8 0e 00 00       	call   8013c0 <set_pgfault_handler>

	asm volatile(
  8004d8:	50                   	push   %eax
  8004d9:	9c                   	pushf  
  8004da:	58                   	pop    %eax
  8004db:	0d d5 08 00 00       	or     $0x8d5,%eax
  8004e0:	50                   	push   %eax
  8004e1:	9d                   	popf   
  8004e2:	a3 a4 40 80 00       	mov    %eax,0x8040a4
  8004e7:	8d 05 22 05 80 00    	lea    0x800522,%eax
  8004ed:	a3 a0 40 80 00       	mov    %eax,0x8040a0
  8004f2:	58                   	pop    %eax
  8004f3:	89 3d 80 40 80 00    	mov    %edi,0x804080
  8004f9:	89 35 84 40 80 00    	mov    %esi,0x804084
  8004ff:	89 2d 88 40 80 00    	mov    %ebp,0x804088
  800505:	89 1d 90 40 80 00    	mov    %ebx,0x804090
  80050b:	89 15 94 40 80 00    	mov    %edx,0x804094
  800511:	89 0d 98 40 80 00    	mov    %ecx,0x804098
  800517:	a3 9c 40 80 00       	mov    %eax,0x80409c
  80051c:	89 25 a8 40 80 00    	mov    %esp,0x8040a8
  800522:	c7 05 00 00 40 00 2a 	movl   $0x2a,0x400000
  800529:	00 00 00 
  80052c:	89 3d 00 40 80 00    	mov    %edi,0x804000
  800532:	89 35 04 40 80 00    	mov    %esi,0x804004
  800538:	89 2d 08 40 80 00    	mov    %ebp,0x804008
  80053e:	89 1d 10 40 80 00    	mov    %ebx,0x804010
  800544:	89 15 14 40 80 00    	mov    %edx,0x804014
  80054a:	89 0d 18 40 80 00    	mov    %ecx,0x804018
  800550:	a3 1c 40 80 00       	mov    %eax,0x80401c
  800555:	89 25 28 40 80 00    	mov    %esp,0x804028
  80055b:	8b 3d 80 40 80 00    	mov    0x804080,%edi
  800561:	8b 35 84 40 80 00    	mov    0x804084,%esi
  800567:	8b 2d 88 40 80 00    	mov    0x804088,%ebp
  80056d:	8b 1d 90 40 80 00    	mov    0x804090,%ebx
  800573:	8b 15 94 40 80 00    	mov    0x804094,%edx
  800579:	8b 0d 98 40 80 00    	mov    0x804098,%ecx
  80057f:	a1 9c 40 80 00       	mov    0x80409c,%eax
  800584:	8b 25 a8 40 80 00    	mov    0x8040a8,%esp
  80058a:	50                   	push   %eax
  80058b:	9c                   	pushf  
  80058c:	58                   	pop    %eax
  80058d:	a3 24 40 80 00       	mov    %eax,0x804024
  800592:	58                   	pop    %eax
		: : "m" (before), "m" (after) : "memory", "cc");

	// Check UTEMP to roughly determine that EIP was restored
	// correctly (of course, we probably wouldn't get this far if
	// it weren't)
	if (*(int*)UTEMP != 42)
  800593:	83 c4 10             	add    $0x10,%esp
  800596:	83 3d 00 00 40 00 2a 	cmpl   $0x2a,0x400000
  80059d:	74 10                	je     8005af <umain+0xe7>
		cprintf("EIP after page-fault MISMATCH\n");
  80059f:	83 ec 0c             	sub    $0xc,%esp
  8005a2:	68 34 2a 80 00       	push   $0x802a34
  8005a7:	e8 6e 01 00 00       	call   80071a <cprintf>
  8005ac:	83 c4 10             	add    $0x10,%esp
	after.eip = before.eip;
  8005af:	a1 a0 40 80 00       	mov    0x8040a0,%eax
  8005b4:	a3 20 40 80 00       	mov    %eax,0x804020

	check_regs(&before, "before", &after, "after", "after page-fault");
  8005b9:	83 ec 08             	sub    $0x8,%esp
  8005bc:	68 e7 29 80 00       	push   $0x8029e7
  8005c1:	68 f8 29 80 00       	push   $0x8029f8
  8005c6:	b9 00 40 80 00       	mov    $0x804000,%ecx
  8005cb:	ba b8 29 80 00       	mov    $0x8029b8,%edx
  8005d0:	b8 80 40 80 00       	mov    $0x804080,%eax
  8005d5:	e8 59 fa ff ff       	call   800033 <check_regs>
}
  8005da:	83 c4 10             	add    $0x10,%esp
  8005dd:	c9                   	leave  
  8005de:	c3                   	ret    

008005df <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8005df:	55                   	push   %ebp
  8005e0:	89 e5                	mov    %esp,%ebp
  8005e2:	56                   	push   %esi
  8005e3:	53                   	push   %ebx
  8005e4:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8005e7:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
    thisenv = &envs[ENVX(sys_getenvid())];
  8005ea:	e8 83 0b 00 00       	call   801172 <sys_getenvid>
  8005ef:	25 ff 03 00 00       	and    $0x3ff,%eax
  8005f4:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8005f7:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8005fc:	a3 b4 40 80 00       	mov    %eax,0x8040b4

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800601:	85 db                	test   %ebx,%ebx
  800603:	7e 07                	jle    80060c <libmain+0x2d>
		binaryname = argv[0];
  800605:	8b 06                	mov    (%esi),%eax
  800607:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80060c:	83 ec 08             	sub    $0x8,%esp
  80060f:	56                   	push   %esi
  800610:	53                   	push   %ebx
  800611:	e8 b2 fe ff ff       	call   8004c8 <umain>

	// exit gracefully
	exit();
  800616:	e8 0a 00 00 00       	call   800625 <exit>
}
  80061b:	83 c4 10             	add    $0x10,%esp
  80061e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800621:	5b                   	pop    %ebx
  800622:	5e                   	pop    %esi
  800623:	5d                   	pop    %ebp
  800624:	c3                   	ret    

00800625 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800625:	55                   	push   %ebp
  800626:	89 e5                	mov    %esp,%ebp
  800628:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80062b:	e8 05 10 00 00       	call   801635 <close_all>
	sys_env_destroy(0);
  800630:	83 ec 0c             	sub    $0xc,%esp
  800633:	6a 00                	push   $0x0
  800635:	e8 f7 0a 00 00       	call   801131 <sys_env_destroy>
}
  80063a:	83 c4 10             	add    $0x10,%esp
  80063d:	c9                   	leave  
  80063e:	c3                   	ret    

0080063f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80063f:	55                   	push   %ebp
  800640:	89 e5                	mov    %esp,%ebp
  800642:	56                   	push   %esi
  800643:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800644:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800647:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80064d:	e8 20 0b 00 00       	call   801172 <sys_getenvid>
  800652:	83 ec 0c             	sub    $0xc,%esp
  800655:	ff 75 0c             	pushl  0xc(%ebp)
  800658:	ff 75 08             	pushl  0x8(%ebp)
  80065b:	56                   	push   %esi
  80065c:	50                   	push   %eax
  80065d:	68 60 2a 80 00       	push   $0x802a60
  800662:	e8 b3 00 00 00       	call   80071a <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800667:	83 c4 18             	add    $0x18,%esp
  80066a:	53                   	push   %ebx
  80066b:	ff 75 10             	pushl  0x10(%ebp)
  80066e:	e8 56 00 00 00       	call   8006c9 <vcprintf>
	cprintf("\n");
  800673:	c7 04 24 70 29 80 00 	movl   $0x802970,(%esp)
  80067a:	e8 9b 00 00 00       	call   80071a <cprintf>
  80067f:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800682:	cc                   	int3   
  800683:	eb fd                	jmp    800682 <_panic+0x43>

00800685 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800685:	55                   	push   %ebp
  800686:	89 e5                	mov    %esp,%ebp
  800688:	53                   	push   %ebx
  800689:	83 ec 04             	sub    $0x4,%esp
  80068c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80068f:	8b 13                	mov    (%ebx),%edx
  800691:	8d 42 01             	lea    0x1(%edx),%eax
  800694:	89 03                	mov    %eax,(%ebx)
  800696:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800699:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80069d:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006a2:	74 09                	je     8006ad <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8006a4:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8006a8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006ab:	c9                   	leave  
  8006ac:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8006ad:	83 ec 08             	sub    $0x8,%esp
  8006b0:	68 ff 00 00 00       	push   $0xff
  8006b5:	8d 43 08             	lea    0x8(%ebx),%eax
  8006b8:	50                   	push   %eax
  8006b9:	e8 36 0a 00 00       	call   8010f4 <sys_cputs>
		b->idx = 0;
  8006be:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8006c4:	83 c4 10             	add    $0x10,%esp
  8006c7:	eb db                	jmp    8006a4 <putch+0x1f>

008006c9 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8006c9:	55                   	push   %ebp
  8006ca:	89 e5                	mov    %esp,%ebp
  8006cc:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006d2:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006d9:	00 00 00 
	b.cnt = 0;
  8006dc:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8006e3:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8006e6:	ff 75 0c             	pushl  0xc(%ebp)
  8006e9:	ff 75 08             	pushl  0x8(%ebp)
  8006ec:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006f2:	50                   	push   %eax
  8006f3:	68 85 06 80 00       	push   $0x800685
  8006f8:	e8 1a 01 00 00       	call   800817 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8006fd:	83 c4 08             	add    $0x8,%esp
  800700:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800706:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80070c:	50                   	push   %eax
  80070d:	e8 e2 09 00 00       	call   8010f4 <sys_cputs>

	return b.cnt;
}
  800712:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800718:	c9                   	leave  
  800719:	c3                   	ret    

0080071a <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80071a:	55                   	push   %ebp
  80071b:	89 e5                	mov    %esp,%ebp
  80071d:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800720:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800723:	50                   	push   %eax
  800724:	ff 75 08             	pushl  0x8(%ebp)
  800727:	e8 9d ff ff ff       	call   8006c9 <vcprintf>
	va_end(ap);

	return cnt;
}
  80072c:	c9                   	leave  
  80072d:	c3                   	ret    

0080072e <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80072e:	55                   	push   %ebp
  80072f:	89 e5                	mov    %esp,%ebp
  800731:	57                   	push   %edi
  800732:	56                   	push   %esi
  800733:	53                   	push   %ebx
  800734:	83 ec 1c             	sub    $0x1c,%esp
  800737:	89 c7                	mov    %eax,%edi
  800739:	89 d6                	mov    %edx,%esi
  80073b:	8b 45 08             	mov    0x8(%ebp),%eax
  80073e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800741:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800744:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800747:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80074a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80074f:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800752:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800755:	39 d3                	cmp    %edx,%ebx
  800757:	72 05                	jb     80075e <printnum+0x30>
  800759:	39 45 10             	cmp    %eax,0x10(%ebp)
  80075c:	77 7a                	ja     8007d8 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80075e:	83 ec 0c             	sub    $0xc,%esp
  800761:	ff 75 18             	pushl  0x18(%ebp)
  800764:	8b 45 14             	mov    0x14(%ebp),%eax
  800767:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80076a:	53                   	push   %ebx
  80076b:	ff 75 10             	pushl  0x10(%ebp)
  80076e:	83 ec 08             	sub    $0x8,%esp
  800771:	ff 75 e4             	pushl  -0x1c(%ebp)
  800774:	ff 75 e0             	pushl  -0x20(%ebp)
  800777:	ff 75 dc             	pushl  -0x24(%ebp)
  80077a:	ff 75 d8             	pushl  -0x28(%ebp)
  80077d:	e8 7e 1f 00 00       	call   802700 <__udivdi3>
  800782:	83 c4 18             	add    $0x18,%esp
  800785:	52                   	push   %edx
  800786:	50                   	push   %eax
  800787:	89 f2                	mov    %esi,%edx
  800789:	89 f8                	mov    %edi,%eax
  80078b:	e8 9e ff ff ff       	call   80072e <printnum>
  800790:	83 c4 20             	add    $0x20,%esp
  800793:	eb 13                	jmp    8007a8 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800795:	83 ec 08             	sub    $0x8,%esp
  800798:	56                   	push   %esi
  800799:	ff 75 18             	pushl  0x18(%ebp)
  80079c:	ff d7                	call   *%edi
  80079e:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8007a1:	83 eb 01             	sub    $0x1,%ebx
  8007a4:	85 db                	test   %ebx,%ebx
  8007a6:	7f ed                	jg     800795 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8007a8:	83 ec 08             	sub    $0x8,%esp
  8007ab:	56                   	push   %esi
  8007ac:	83 ec 04             	sub    $0x4,%esp
  8007af:	ff 75 e4             	pushl  -0x1c(%ebp)
  8007b2:	ff 75 e0             	pushl  -0x20(%ebp)
  8007b5:	ff 75 dc             	pushl  -0x24(%ebp)
  8007b8:	ff 75 d8             	pushl  -0x28(%ebp)
  8007bb:	e8 60 20 00 00       	call   802820 <__umoddi3>
  8007c0:	83 c4 14             	add    $0x14,%esp
  8007c3:	0f be 80 83 2a 80 00 	movsbl 0x802a83(%eax),%eax
  8007ca:	50                   	push   %eax
  8007cb:	ff d7                	call   *%edi
}
  8007cd:	83 c4 10             	add    $0x10,%esp
  8007d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007d3:	5b                   	pop    %ebx
  8007d4:	5e                   	pop    %esi
  8007d5:	5f                   	pop    %edi
  8007d6:	5d                   	pop    %ebp
  8007d7:	c3                   	ret    
  8007d8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8007db:	eb c4                	jmp    8007a1 <printnum+0x73>

008007dd <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8007dd:	55                   	push   %ebp
  8007de:	89 e5                	mov    %esp,%ebp
  8007e0:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8007e3:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8007e7:	8b 10                	mov    (%eax),%edx
  8007e9:	3b 50 04             	cmp    0x4(%eax),%edx
  8007ec:	73 0a                	jae    8007f8 <sprintputch+0x1b>
		*b->buf++ = ch;
  8007ee:	8d 4a 01             	lea    0x1(%edx),%ecx
  8007f1:	89 08                	mov    %ecx,(%eax)
  8007f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f6:	88 02                	mov    %al,(%edx)
}
  8007f8:	5d                   	pop    %ebp
  8007f9:	c3                   	ret    

008007fa <printfmt>:
{
  8007fa:	55                   	push   %ebp
  8007fb:	89 e5                	mov    %esp,%ebp
  8007fd:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800800:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800803:	50                   	push   %eax
  800804:	ff 75 10             	pushl  0x10(%ebp)
  800807:	ff 75 0c             	pushl  0xc(%ebp)
  80080a:	ff 75 08             	pushl  0x8(%ebp)
  80080d:	e8 05 00 00 00       	call   800817 <vprintfmt>
}
  800812:	83 c4 10             	add    $0x10,%esp
  800815:	c9                   	leave  
  800816:	c3                   	ret    

00800817 <vprintfmt>:
{
  800817:	55                   	push   %ebp
  800818:	89 e5                	mov    %esp,%ebp
  80081a:	57                   	push   %edi
  80081b:	56                   	push   %esi
  80081c:	53                   	push   %ebx
  80081d:	83 ec 2c             	sub    $0x2c,%esp
  800820:	8b 75 08             	mov    0x8(%ebp),%esi
  800823:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800826:	8b 7d 10             	mov    0x10(%ebp),%edi
  800829:	e9 21 04 00 00       	jmp    800c4f <vprintfmt+0x438>
		padc = ' ';
  80082e:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  800832:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800839:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800840:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800847:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80084c:	8d 47 01             	lea    0x1(%edi),%eax
  80084f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800852:	0f b6 17             	movzbl (%edi),%edx
  800855:	8d 42 dd             	lea    -0x23(%edx),%eax
  800858:	3c 55                	cmp    $0x55,%al
  80085a:	0f 87 90 04 00 00    	ja     800cf0 <vprintfmt+0x4d9>
  800860:	0f b6 c0             	movzbl %al,%eax
  800863:	ff 24 85 c0 2b 80 00 	jmp    *0x802bc0(,%eax,4)
  80086a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80086d:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800871:	eb d9                	jmp    80084c <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800873:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800876:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  80087a:	eb d0                	jmp    80084c <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80087c:	0f b6 d2             	movzbl %dl,%edx
  80087f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800882:	b8 00 00 00 00       	mov    $0x0,%eax
  800887:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80088a:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80088d:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800891:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800894:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800897:	83 f9 09             	cmp    $0x9,%ecx
  80089a:	77 55                	ja     8008f1 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  80089c:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80089f:	eb e9                	jmp    80088a <vprintfmt+0x73>
			precision = va_arg(ap, int);
  8008a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a4:	8b 00                	mov    (%eax),%eax
  8008a6:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8008a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ac:	8d 40 04             	lea    0x4(%eax),%eax
  8008af:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8008b2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8008b5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8008b9:	79 91                	jns    80084c <vprintfmt+0x35>
				width = precision, precision = -1;
  8008bb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8008be:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8008c1:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8008c8:	eb 82                	jmp    80084c <vprintfmt+0x35>
  8008ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008cd:	85 c0                	test   %eax,%eax
  8008cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8008d4:	0f 49 d0             	cmovns %eax,%edx
  8008d7:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8008da:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8008dd:	e9 6a ff ff ff       	jmp    80084c <vprintfmt+0x35>
  8008e2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8008e5:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8008ec:	e9 5b ff ff ff       	jmp    80084c <vprintfmt+0x35>
  8008f1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8008f4:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8008f7:	eb bc                	jmp    8008b5 <vprintfmt+0x9e>
			lflag++;
  8008f9:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8008fc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8008ff:	e9 48 ff ff ff       	jmp    80084c <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800904:	8b 45 14             	mov    0x14(%ebp),%eax
  800907:	8d 78 04             	lea    0x4(%eax),%edi
  80090a:	83 ec 08             	sub    $0x8,%esp
  80090d:	53                   	push   %ebx
  80090e:	ff 30                	pushl  (%eax)
  800910:	ff d6                	call   *%esi
			break;
  800912:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800915:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800918:	e9 2f 03 00 00       	jmp    800c4c <vprintfmt+0x435>
			err = va_arg(ap, int);
  80091d:	8b 45 14             	mov    0x14(%ebp),%eax
  800920:	8d 78 04             	lea    0x4(%eax),%edi
  800923:	8b 00                	mov    (%eax),%eax
  800925:	99                   	cltd   
  800926:	31 d0                	xor    %edx,%eax
  800928:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80092a:	83 f8 0f             	cmp    $0xf,%eax
  80092d:	7f 23                	jg     800952 <vprintfmt+0x13b>
  80092f:	8b 14 85 20 2d 80 00 	mov    0x802d20(,%eax,4),%edx
  800936:	85 d2                	test   %edx,%edx
  800938:	74 18                	je     800952 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  80093a:	52                   	push   %edx
  80093b:	68 a2 2e 80 00       	push   $0x802ea2
  800940:	53                   	push   %ebx
  800941:	56                   	push   %esi
  800942:	e8 b3 fe ff ff       	call   8007fa <printfmt>
  800947:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80094a:	89 7d 14             	mov    %edi,0x14(%ebp)
  80094d:	e9 fa 02 00 00       	jmp    800c4c <vprintfmt+0x435>
				printfmt(putch, putdat, "error %d", err);
  800952:	50                   	push   %eax
  800953:	68 9b 2a 80 00       	push   $0x802a9b
  800958:	53                   	push   %ebx
  800959:	56                   	push   %esi
  80095a:	e8 9b fe ff ff       	call   8007fa <printfmt>
  80095f:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800962:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800965:	e9 e2 02 00 00       	jmp    800c4c <vprintfmt+0x435>
			if ((p = va_arg(ap, char *)) == NULL)
  80096a:	8b 45 14             	mov    0x14(%ebp),%eax
  80096d:	83 c0 04             	add    $0x4,%eax
  800970:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800973:	8b 45 14             	mov    0x14(%ebp),%eax
  800976:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800978:	85 ff                	test   %edi,%edi
  80097a:	b8 94 2a 80 00       	mov    $0x802a94,%eax
  80097f:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800982:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800986:	0f 8e bd 00 00 00    	jle    800a49 <vprintfmt+0x232>
  80098c:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800990:	75 0e                	jne    8009a0 <vprintfmt+0x189>
  800992:	89 75 08             	mov    %esi,0x8(%ebp)
  800995:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800998:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80099b:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80099e:	eb 6d                	jmp    800a0d <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009a0:	83 ec 08             	sub    $0x8,%esp
  8009a3:	ff 75 d0             	pushl  -0x30(%ebp)
  8009a6:	57                   	push   %edi
  8009a7:	e8 ec 03 00 00       	call   800d98 <strnlen>
  8009ac:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8009af:	29 c1                	sub    %eax,%ecx
  8009b1:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8009b4:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8009b7:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8009bb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8009be:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8009c1:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8009c3:	eb 0f                	jmp    8009d4 <vprintfmt+0x1bd>
					putch(padc, putdat);
  8009c5:	83 ec 08             	sub    $0x8,%esp
  8009c8:	53                   	push   %ebx
  8009c9:	ff 75 e0             	pushl  -0x20(%ebp)
  8009cc:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8009ce:	83 ef 01             	sub    $0x1,%edi
  8009d1:	83 c4 10             	add    $0x10,%esp
  8009d4:	85 ff                	test   %edi,%edi
  8009d6:	7f ed                	jg     8009c5 <vprintfmt+0x1ae>
  8009d8:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8009db:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8009de:	85 c9                	test   %ecx,%ecx
  8009e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8009e5:	0f 49 c1             	cmovns %ecx,%eax
  8009e8:	29 c1                	sub    %eax,%ecx
  8009ea:	89 75 08             	mov    %esi,0x8(%ebp)
  8009ed:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8009f0:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8009f3:	89 cb                	mov    %ecx,%ebx
  8009f5:	eb 16                	jmp    800a0d <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8009f7:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8009fb:	75 31                	jne    800a2e <vprintfmt+0x217>
					putch(ch, putdat);
  8009fd:	83 ec 08             	sub    $0x8,%esp
  800a00:	ff 75 0c             	pushl  0xc(%ebp)
  800a03:	50                   	push   %eax
  800a04:	ff 55 08             	call   *0x8(%ebp)
  800a07:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a0a:	83 eb 01             	sub    $0x1,%ebx
  800a0d:	83 c7 01             	add    $0x1,%edi
  800a10:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800a14:	0f be c2             	movsbl %dl,%eax
  800a17:	85 c0                	test   %eax,%eax
  800a19:	74 59                	je     800a74 <vprintfmt+0x25d>
  800a1b:	85 f6                	test   %esi,%esi
  800a1d:	78 d8                	js     8009f7 <vprintfmt+0x1e0>
  800a1f:	83 ee 01             	sub    $0x1,%esi
  800a22:	79 d3                	jns    8009f7 <vprintfmt+0x1e0>
  800a24:	89 df                	mov    %ebx,%edi
  800a26:	8b 75 08             	mov    0x8(%ebp),%esi
  800a29:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800a2c:	eb 37                	jmp    800a65 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  800a2e:	0f be d2             	movsbl %dl,%edx
  800a31:	83 ea 20             	sub    $0x20,%edx
  800a34:	83 fa 5e             	cmp    $0x5e,%edx
  800a37:	76 c4                	jbe    8009fd <vprintfmt+0x1e6>
					putch('?', putdat);
  800a39:	83 ec 08             	sub    $0x8,%esp
  800a3c:	ff 75 0c             	pushl  0xc(%ebp)
  800a3f:	6a 3f                	push   $0x3f
  800a41:	ff 55 08             	call   *0x8(%ebp)
  800a44:	83 c4 10             	add    $0x10,%esp
  800a47:	eb c1                	jmp    800a0a <vprintfmt+0x1f3>
  800a49:	89 75 08             	mov    %esi,0x8(%ebp)
  800a4c:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800a4f:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800a52:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800a55:	eb b6                	jmp    800a0d <vprintfmt+0x1f6>
				putch(' ', putdat);
  800a57:	83 ec 08             	sub    $0x8,%esp
  800a5a:	53                   	push   %ebx
  800a5b:	6a 20                	push   $0x20
  800a5d:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800a5f:	83 ef 01             	sub    $0x1,%edi
  800a62:	83 c4 10             	add    $0x10,%esp
  800a65:	85 ff                	test   %edi,%edi
  800a67:	7f ee                	jg     800a57 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  800a69:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800a6c:	89 45 14             	mov    %eax,0x14(%ebp)
  800a6f:	e9 d8 01 00 00       	jmp    800c4c <vprintfmt+0x435>
  800a74:	89 df                	mov    %ebx,%edi
  800a76:	8b 75 08             	mov    0x8(%ebp),%esi
  800a79:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800a7c:	eb e7                	jmp    800a65 <vprintfmt+0x24e>
	if (lflag >= 2)
  800a7e:	83 f9 01             	cmp    $0x1,%ecx
  800a81:	7e 45                	jle    800ac8 <vprintfmt+0x2b1>
		return va_arg(*ap, long long);
  800a83:	8b 45 14             	mov    0x14(%ebp),%eax
  800a86:	8b 50 04             	mov    0x4(%eax),%edx
  800a89:	8b 00                	mov    (%eax),%eax
  800a8b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a8e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a91:	8b 45 14             	mov    0x14(%ebp),%eax
  800a94:	8d 40 08             	lea    0x8(%eax),%eax
  800a97:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800a9a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a9e:	79 62                	jns    800b02 <vprintfmt+0x2eb>
				putch('-', putdat);
  800aa0:	83 ec 08             	sub    $0x8,%esp
  800aa3:	53                   	push   %ebx
  800aa4:	6a 2d                	push   $0x2d
  800aa6:	ff d6                	call   *%esi
				num = -(long long) num;
  800aa8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800aab:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800aae:	f7 d8                	neg    %eax
  800ab0:	83 d2 00             	adc    $0x0,%edx
  800ab3:	f7 da                	neg    %edx
  800ab5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ab8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800abb:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800abe:	ba 0a 00 00 00       	mov    $0xa,%edx
  800ac3:	e9 66 01 00 00       	jmp    800c2e <vprintfmt+0x417>
	else if (lflag)
  800ac8:	85 c9                	test   %ecx,%ecx
  800aca:	75 1b                	jne    800ae7 <vprintfmt+0x2d0>
		return va_arg(*ap, int);
  800acc:	8b 45 14             	mov    0x14(%ebp),%eax
  800acf:	8b 00                	mov    (%eax),%eax
  800ad1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ad4:	89 c1                	mov    %eax,%ecx
  800ad6:	c1 f9 1f             	sar    $0x1f,%ecx
  800ad9:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800adc:	8b 45 14             	mov    0x14(%ebp),%eax
  800adf:	8d 40 04             	lea    0x4(%eax),%eax
  800ae2:	89 45 14             	mov    %eax,0x14(%ebp)
  800ae5:	eb b3                	jmp    800a9a <vprintfmt+0x283>
		return va_arg(*ap, long);
  800ae7:	8b 45 14             	mov    0x14(%ebp),%eax
  800aea:	8b 00                	mov    (%eax),%eax
  800aec:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800aef:	89 c1                	mov    %eax,%ecx
  800af1:	c1 f9 1f             	sar    $0x1f,%ecx
  800af4:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800af7:	8b 45 14             	mov    0x14(%ebp),%eax
  800afa:	8d 40 04             	lea    0x4(%eax),%eax
  800afd:	89 45 14             	mov    %eax,0x14(%ebp)
  800b00:	eb 98                	jmp    800a9a <vprintfmt+0x283>
			base = 10;
  800b02:	ba 0a 00 00 00       	mov    $0xa,%edx
  800b07:	e9 22 01 00 00       	jmp    800c2e <vprintfmt+0x417>
	if (lflag >= 2)
  800b0c:	83 f9 01             	cmp    $0x1,%ecx
  800b0f:	7e 21                	jle    800b32 <vprintfmt+0x31b>
		return va_arg(*ap, unsigned long long);
  800b11:	8b 45 14             	mov    0x14(%ebp),%eax
  800b14:	8b 50 04             	mov    0x4(%eax),%edx
  800b17:	8b 00                	mov    (%eax),%eax
  800b19:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b1c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b1f:	8b 45 14             	mov    0x14(%ebp),%eax
  800b22:	8d 40 08             	lea    0x8(%eax),%eax
  800b25:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800b28:	ba 0a 00 00 00       	mov    $0xa,%edx
  800b2d:	e9 fc 00 00 00       	jmp    800c2e <vprintfmt+0x417>
	else if (lflag)
  800b32:	85 c9                	test   %ecx,%ecx
  800b34:	75 23                	jne    800b59 <vprintfmt+0x342>
		return va_arg(*ap, unsigned int);
  800b36:	8b 45 14             	mov    0x14(%ebp),%eax
  800b39:	8b 00                	mov    (%eax),%eax
  800b3b:	ba 00 00 00 00       	mov    $0x0,%edx
  800b40:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b43:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b46:	8b 45 14             	mov    0x14(%ebp),%eax
  800b49:	8d 40 04             	lea    0x4(%eax),%eax
  800b4c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800b4f:	ba 0a 00 00 00       	mov    $0xa,%edx
  800b54:	e9 d5 00 00 00       	jmp    800c2e <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  800b59:	8b 45 14             	mov    0x14(%ebp),%eax
  800b5c:	8b 00                	mov    (%eax),%eax
  800b5e:	ba 00 00 00 00       	mov    $0x0,%edx
  800b63:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b66:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b69:	8b 45 14             	mov    0x14(%ebp),%eax
  800b6c:	8d 40 04             	lea    0x4(%eax),%eax
  800b6f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800b72:	ba 0a 00 00 00       	mov    $0xa,%edx
  800b77:	e9 b2 00 00 00       	jmp    800c2e <vprintfmt+0x417>
	if (lflag >= 2)
  800b7c:	83 f9 01             	cmp    $0x1,%ecx
  800b7f:	7e 42                	jle    800bc3 <vprintfmt+0x3ac>
		return va_arg(*ap, unsigned long long);
  800b81:	8b 45 14             	mov    0x14(%ebp),%eax
  800b84:	8b 50 04             	mov    0x4(%eax),%edx
  800b87:	8b 00                	mov    (%eax),%eax
  800b89:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b8c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b8f:	8b 45 14             	mov    0x14(%ebp),%eax
  800b92:	8d 40 08             	lea    0x8(%eax),%eax
  800b95:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800b98:	ba 08 00 00 00       	mov    $0x8,%edx
			if ((long long) num < 0) {
  800b9d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800ba1:	0f 89 87 00 00 00    	jns    800c2e <vprintfmt+0x417>
				putch('-', putdat);
  800ba7:	83 ec 08             	sub    $0x8,%esp
  800baa:	53                   	push   %ebx
  800bab:	6a 2d                	push   $0x2d
  800bad:	ff d6                	call   *%esi
				num = -(long long) num;
  800baf:	f7 5d d8             	negl   -0x28(%ebp)
  800bb2:	83 55 dc 00          	adcl   $0x0,-0x24(%ebp)
  800bb6:	f7 5d dc             	negl   -0x24(%ebp)
  800bb9:	83 c4 10             	add    $0x10,%esp
			base = 8;
  800bbc:	ba 08 00 00 00       	mov    $0x8,%edx
  800bc1:	eb 6b                	jmp    800c2e <vprintfmt+0x417>
	else if (lflag)
  800bc3:	85 c9                	test   %ecx,%ecx
  800bc5:	75 1b                	jne    800be2 <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  800bc7:	8b 45 14             	mov    0x14(%ebp),%eax
  800bca:	8b 00                	mov    (%eax),%eax
  800bcc:	ba 00 00 00 00       	mov    $0x0,%edx
  800bd1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800bd4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800bd7:	8b 45 14             	mov    0x14(%ebp),%eax
  800bda:	8d 40 04             	lea    0x4(%eax),%eax
  800bdd:	89 45 14             	mov    %eax,0x14(%ebp)
  800be0:	eb b6                	jmp    800b98 <vprintfmt+0x381>
		return va_arg(*ap, unsigned long);
  800be2:	8b 45 14             	mov    0x14(%ebp),%eax
  800be5:	8b 00                	mov    (%eax),%eax
  800be7:	ba 00 00 00 00       	mov    $0x0,%edx
  800bec:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800bef:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800bf2:	8b 45 14             	mov    0x14(%ebp),%eax
  800bf5:	8d 40 04             	lea    0x4(%eax),%eax
  800bf8:	89 45 14             	mov    %eax,0x14(%ebp)
  800bfb:	eb 9b                	jmp    800b98 <vprintfmt+0x381>
			putch('0', putdat);
  800bfd:	83 ec 08             	sub    $0x8,%esp
  800c00:	53                   	push   %ebx
  800c01:	6a 30                	push   $0x30
  800c03:	ff d6                	call   *%esi
			putch('x', putdat);
  800c05:	83 c4 08             	add    $0x8,%esp
  800c08:	53                   	push   %ebx
  800c09:	6a 78                	push   $0x78
  800c0b:	ff d6                	call   *%esi
			num = (unsigned long long)
  800c0d:	8b 45 14             	mov    0x14(%ebp),%eax
  800c10:	8b 00                	mov    (%eax),%eax
  800c12:	ba 00 00 00 00       	mov    $0x0,%edx
  800c17:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c1a:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800c1d:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800c20:	8b 45 14             	mov    0x14(%ebp),%eax
  800c23:	8d 40 04             	lea    0x4(%eax),%eax
  800c26:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800c29:	ba 10 00 00 00       	mov    $0x10,%edx
			printnum(putch, putdat, num, base, width, padc);
  800c2e:	83 ec 0c             	sub    $0xc,%esp
  800c31:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800c35:	50                   	push   %eax
  800c36:	ff 75 e0             	pushl  -0x20(%ebp)
  800c39:	52                   	push   %edx
  800c3a:	ff 75 dc             	pushl  -0x24(%ebp)
  800c3d:	ff 75 d8             	pushl  -0x28(%ebp)
  800c40:	89 da                	mov    %ebx,%edx
  800c42:	89 f0                	mov    %esi,%eax
  800c44:	e8 e5 fa ff ff       	call   80072e <printnum>
			break;
  800c49:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800c4c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c4f:	83 c7 01             	add    $0x1,%edi
  800c52:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800c56:	83 f8 25             	cmp    $0x25,%eax
  800c59:	0f 84 cf fb ff ff    	je     80082e <vprintfmt+0x17>
			if (ch == '\0')
  800c5f:	85 c0                	test   %eax,%eax
  800c61:	0f 84 a9 00 00 00    	je     800d10 <vprintfmt+0x4f9>
			putch(ch, putdat);
  800c67:	83 ec 08             	sub    $0x8,%esp
  800c6a:	53                   	push   %ebx
  800c6b:	50                   	push   %eax
  800c6c:	ff d6                	call   *%esi
  800c6e:	83 c4 10             	add    $0x10,%esp
  800c71:	eb dc                	jmp    800c4f <vprintfmt+0x438>
	if (lflag >= 2)
  800c73:	83 f9 01             	cmp    $0x1,%ecx
  800c76:	7e 1e                	jle    800c96 <vprintfmt+0x47f>
		return va_arg(*ap, unsigned long long);
  800c78:	8b 45 14             	mov    0x14(%ebp),%eax
  800c7b:	8b 50 04             	mov    0x4(%eax),%edx
  800c7e:	8b 00                	mov    (%eax),%eax
  800c80:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c83:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800c86:	8b 45 14             	mov    0x14(%ebp),%eax
  800c89:	8d 40 08             	lea    0x8(%eax),%eax
  800c8c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800c8f:	ba 10 00 00 00       	mov    $0x10,%edx
  800c94:	eb 98                	jmp    800c2e <vprintfmt+0x417>
	else if (lflag)
  800c96:	85 c9                	test   %ecx,%ecx
  800c98:	75 23                	jne    800cbd <vprintfmt+0x4a6>
		return va_arg(*ap, unsigned int);
  800c9a:	8b 45 14             	mov    0x14(%ebp),%eax
  800c9d:	8b 00                	mov    (%eax),%eax
  800c9f:	ba 00 00 00 00       	mov    $0x0,%edx
  800ca4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ca7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800caa:	8b 45 14             	mov    0x14(%ebp),%eax
  800cad:	8d 40 04             	lea    0x4(%eax),%eax
  800cb0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800cb3:	ba 10 00 00 00       	mov    $0x10,%edx
  800cb8:	e9 71 ff ff ff       	jmp    800c2e <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  800cbd:	8b 45 14             	mov    0x14(%ebp),%eax
  800cc0:	8b 00                	mov    (%eax),%eax
  800cc2:	ba 00 00 00 00       	mov    $0x0,%edx
  800cc7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800cca:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800ccd:	8b 45 14             	mov    0x14(%ebp),%eax
  800cd0:	8d 40 04             	lea    0x4(%eax),%eax
  800cd3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800cd6:	ba 10 00 00 00       	mov    $0x10,%edx
  800cdb:	e9 4e ff ff ff       	jmp    800c2e <vprintfmt+0x417>
			putch(ch, putdat);
  800ce0:	83 ec 08             	sub    $0x8,%esp
  800ce3:	53                   	push   %ebx
  800ce4:	6a 25                	push   $0x25
  800ce6:	ff d6                	call   *%esi
			break;
  800ce8:	83 c4 10             	add    $0x10,%esp
  800ceb:	e9 5c ff ff ff       	jmp    800c4c <vprintfmt+0x435>
			putch('%', putdat);
  800cf0:	83 ec 08             	sub    $0x8,%esp
  800cf3:	53                   	push   %ebx
  800cf4:	6a 25                	push   $0x25
  800cf6:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800cf8:	83 c4 10             	add    $0x10,%esp
  800cfb:	89 f8                	mov    %edi,%eax
  800cfd:	eb 03                	jmp    800d02 <vprintfmt+0x4eb>
  800cff:	83 e8 01             	sub    $0x1,%eax
  800d02:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800d06:	75 f7                	jne    800cff <vprintfmt+0x4e8>
  800d08:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d0b:	e9 3c ff ff ff       	jmp    800c4c <vprintfmt+0x435>
}
  800d10:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d13:	5b                   	pop    %ebx
  800d14:	5e                   	pop    %esi
  800d15:	5f                   	pop    %edi
  800d16:	5d                   	pop    %ebp
  800d17:	c3                   	ret    

00800d18 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d18:	55                   	push   %ebp
  800d19:	89 e5                	mov    %esp,%ebp
  800d1b:	83 ec 18             	sub    $0x18,%esp
  800d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d21:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d24:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d27:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800d2b:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800d2e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d35:	85 c0                	test   %eax,%eax
  800d37:	74 26                	je     800d5f <vsnprintf+0x47>
  800d39:	85 d2                	test   %edx,%edx
  800d3b:	7e 22                	jle    800d5f <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d3d:	ff 75 14             	pushl  0x14(%ebp)
  800d40:	ff 75 10             	pushl  0x10(%ebp)
  800d43:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d46:	50                   	push   %eax
  800d47:	68 dd 07 80 00       	push   $0x8007dd
  800d4c:	e8 c6 fa ff ff       	call   800817 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800d51:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d54:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d5a:	83 c4 10             	add    $0x10,%esp
}
  800d5d:	c9                   	leave  
  800d5e:	c3                   	ret    
		return -E_INVAL;
  800d5f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d64:	eb f7                	jmp    800d5d <vsnprintf+0x45>

00800d66 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d66:	55                   	push   %ebp
  800d67:	89 e5                	mov    %esp,%ebp
  800d69:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d6c:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800d6f:	50                   	push   %eax
  800d70:	ff 75 10             	pushl  0x10(%ebp)
  800d73:	ff 75 0c             	pushl  0xc(%ebp)
  800d76:	ff 75 08             	pushl  0x8(%ebp)
  800d79:	e8 9a ff ff ff       	call   800d18 <vsnprintf>
	va_end(ap);

	return rc;
}
  800d7e:	c9                   	leave  
  800d7f:	c3                   	ret    

00800d80 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800d80:	55                   	push   %ebp
  800d81:	89 e5                	mov    %esp,%ebp
  800d83:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800d86:	b8 00 00 00 00       	mov    $0x0,%eax
  800d8b:	eb 03                	jmp    800d90 <strlen+0x10>
		n++;
  800d8d:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800d90:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800d94:	75 f7                	jne    800d8d <strlen+0xd>
	return n;
}
  800d96:	5d                   	pop    %ebp
  800d97:	c3                   	ret    

00800d98 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800d98:	55                   	push   %ebp
  800d99:	89 e5                	mov    %esp,%ebp
  800d9b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d9e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800da1:	b8 00 00 00 00       	mov    $0x0,%eax
  800da6:	eb 03                	jmp    800dab <strnlen+0x13>
		n++;
  800da8:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800dab:	39 d0                	cmp    %edx,%eax
  800dad:	74 06                	je     800db5 <strnlen+0x1d>
  800daf:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800db3:	75 f3                	jne    800da8 <strnlen+0x10>
	return n;
}
  800db5:	5d                   	pop    %ebp
  800db6:	c3                   	ret    

00800db7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800db7:	55                   	push   %ebp
  800db8:	89 e5                	mov    %esp,%ebp
  800dba:	53                   	push   %ebx
  800dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800dc1:	89 c2                	mov    %eax,%edx
  800dc3:	83 c1 01             	add    $0x1,%ecx
  800dc6:	83 c2 01             	add    $0x1,%edx
  800dc9:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800dcd:	88 5a ff             	mov    %bl,-0x1(%edx)
  800dd0:	84 db                	test   %bl,%bl
  800dd2:	75 ef                	jne    800dc3 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800dd4:	5b                   	pop    %ebx
  800dd5:	5d                   	pop    %ebp
  800dd6:	c3                   	ret    

00800dd7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800dd7:	55                   	push   %ebp
  800dd8:	89 e5                	mov    %esp,%ebp
  800dda:	53                   	push   %ebx
  800ddb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800dde:	53                   	push   %ebx
  800ddf:	e8 9c ff ff ff       	call   800d80 <strlen>
  800de4:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800de7:	ff 75 0c             	pushl  0xc(%ebp)
  800dea:	01 d8                	add    %ebx,%eax
  800dec:	50                   	push   %eax
  800ded:	e8 c5 ff ff ff       	call   800db7 <strcpy>
	return dst;
}
  800df2:	89 d8                	mov    %ebx,%eax
  800df4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800df7:	c9                   	leave  
  800df8:	c3                   	ret    

00800df9 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800df9:	55                   	push   %ebp
  800dfa:	89 e5                	mov    %esp,%ebp
  800dfc:	56                   	push   %esi
  800dfd:	53                   	push   %ebx
  800dfe:	8b 75 08             	mov    0x8(%ebp),%esi
  800e01:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e04:	89 f3                	mov    %esi,%ebx
  800e06:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e09:	89 f2                	mov    %esi,%edx
  800e0b:	eb 0f                	jmp    800e1c <strncpy+0x23>
		*dst++ = *src;
  800e0d:	83 c2 01             	add    $0x1,%edx
  800e10:	0f b6 01             	movzbl (%ecx),%eax
  800e13:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800e16:	80 39 01             	cmpb   $0x1,(%ecx)
  800e19:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800e1c:	39 da                	cmp    %ebx,%edx
  800e1e:	75 ed                	jne    800e0d <strncpy+0x14>
	}
	return ret;
}
  800e20:	89 f0                	mov    %esi,%eax
  800e22:	5b                   	pop    %ebx
  800e23:	5e                   	pop    %esi
  800e24:	5d                   	pop    %ebp
  800e25:	c3                   	ret    

00800e26 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800e26:	55                   	push   %ebp
  800e27:	89 e5                	mov    %esp,%ebp
  800e29:	56                   	push   %esi
  800e2a:	53                   	push   %ebx
  800e2b:	8b 75 08             	mov    0x8(%ebp),%esi
  800e2e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e31:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800e34:	89 f0                	mov    %esi,%eax
  800e36:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800e3a:	85 c9                	test   %ecx,%ecx
  800e3c:	75 0b                	jne    800e49 <strlcpy+0x23>
  800e3e:	eb 17                	jmp    800e57 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800e40:	83 c2 01             	add    $0x1,%edx
  800e43:	83 c0 01             	add    $0x1,%eax
  800e46:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800e49:	39 d8                	cmp    %ebx,%eax
  800e4b:	74 07                	je     800e54 <strlcpy+0x2e>
  800e4d:	0f b6 0a             	movzbl (%edx),%ecx
  800e50:	84 c9                	test   %cl,%cl
  800e52:	75 ec                	jne    800e40 <strlcpy+0x1a>
		*dst = '\0';
  800e54:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e57:	29 f0                	sub    %esi,%eax
}
  800e59:	5b                   	pop    %ebx
  800e5a:	5e                   	pop    %esi
  800e5b:	5d                   	pop    %ebp
  800e5c:	c3                   	ret    

00800e5d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e5d:	55                   	push   %ebp
  800e5e:	89 e5                	mov    %esp,%ebp
  800e60:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e63:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800e66:	eb 06                	jmp    800e6e <strcmp+0x11>
		p++, q++;
  800e68:	83 c1 01             	add    $0x1,%ecx
  800e6b:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800e6e:	0f b6 01             	movzbl (%ecx),%eax
  800e71:	84 c0                	test   %al,%al
  800e73:	74 04                	je     800e79 <strcmp+0x1c>
  800e75:	3a 02                	cmp    (%edx),%al
  800e77:	74 ef                	je     800e68 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e79:	0f b6 c0             	movzbl %al,%eax
  800e7c:	0f b6 12             	movzbl (%edx),%edx
  800e7f:	29 d0                	sub    %edx,%eax
}
  800e81:	5d                   	pop    %ebp
  800e82:	c3                   	ret    

00800e83 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800e83:	55                   	push   %ebp
  800e84:	89 e5                	mov    %esp,%ebp
  800e86:	53                   	push   %ebx
  800e87:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e8d:	89 c3                	mov    %eax,%ebx
  800e8f:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800e92:	eb 06                	jmp    800e9a <strncmp+0x17>
		n--, p++, q++;
  800e94:	83 c0 01             	add    $0x1,%eax
  800e97:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800e9a:	39 d8                	cmp    %ebx,%eax
  800e9c:	74 16                	je     800eb4 <strncmp+0x31>
  800e9e:	0f b6 08             	movzbl (%eax),%ecx
  800ea1:	84 c9                	test   %cl,%cl
  800ea3:	74 04                	je     800ea9 <strncmp+0x26>
  800ea5:	3a 0a                	cmp    (%edx),%cl
  800ea7:	74 eb                	je     800e94 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ea9:	0f b6 00             	movzbl (%eax),%eax
  800eac:	0f b6 12             	movzbl (%edx),%edx
  800eaf:	29 d0                	sub    %edx,%eax
}
  800eb1:	5b                   	pop    %ebx
  800eb2:	5d                   	pop    %ebp
  800eb3:	c3                   	ret    
		return 0;
  800eb4:	b8 00 00 00 00       	mov    $0x0,%eax
  800eb9:	eb f6                	jmp    800eb1 <strncmp+0x2e>

00800ebb <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ebb:	55                   	push   %ebp
  800ebc:	89 e5                	mov    %esp,%ebp
  800ebe:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ec5:	0f b6 10             	movzbl (%eax),%edx
  800ec8:	84 d2                	test   %dl,%dl
  800eca:	74 09                	je     800ed5 <strchr+0x1a>
		if (*s == c)
  800ecc:	38 ca                	cmp    %cl,%dl
  800ece:	74 0a                	je     800eda <strchr+0x1f>
	for (; *s; s++)
  800ed0:	83 c0 01             	add    $0x1,%eax
  800ed3:	eb f0                	jmp    800ec5 <strchr+0xa>
			return (char *) s;
	return 0;
  800ed5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800eda:	5d                   	pop    %ebp
  800edb:	c3                   	ret    

00800edc <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800edc:	55                   	push   %ebp
  800edd:	89 e5                	mov    %esp,%ebp
  800edf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee2:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ee6:	eb 03                	jmp    800eeb <strfind+0xf>
  800ee8:	83 c0 01             	add    $0x1,%eax
  800eeb:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800eee:	38 ca                	cmp    %cl,%dl
  800ef0:	74 04                	je     800ef6 <strfind+0x1a>
  800ef2:	84 d2                	test   %dl,%dl
  800ef4:	75 f2                	jne    800ee8 <strfind+0xc>
			break;
	return (char *) s;
}
  800ef6:	5d                   	pop    %ebp
  800ef7:	c3                   	ret    

00800ef8 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800ef8:	55                   	push   %ebp
  800ef9:	89 e5                	mov    %esp,%ebp
  800efb:	57                   	push   %edi
  800efc:	56                   	push   %esi
  800efd:	53                   	push   %ebx
  800efe:	8b 7d 08             	mov    0x8(%ebp),%edi
  800f01:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800f04:	85 c9                	test   %ecx,%ecx
  800f06:	74 13                	je     800f1b <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800f08:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800f0e:	75 05                	jne    800f15 <memset+0x1d>
  800f10:	f6 c1 03             	test   $0x3,%cl
  800f13:	74 0d                	je     800f22 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800f15:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f18:	fc                   	cld    
  800f19:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800f1b:	89 f8                	mov    %edi,%eax
  800f1d:	5b                   	pop    %ebx
  800f1e:	5e                   	pop    %esi
  800f1f:	5f                   	pop    %edi
  800f20:	5d                   	pop    %ebp
  800f21:	c3                   	ret    
		c &= 0xFF;
  800f22:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800f26:	89 d3                	mov    %edx,%ebx
  800f28:	c1 e3 08             	shl    $0x8,%ebx
  800f2b:	89 d0                	mov    %edx,%eax
  800f2d:	c1 e0 18             	shl    $0x18,%eax
  800f30:	89 d6                	mov    %edx,%esi
  800f32:	c1 e6 10             	shl    $0x10,%esi
  800f35:	09 f0                	or     %esi,%eax
  800f37:	09 c2                	or     %eax,%edx
  800f39:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800f3b:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800f3e:	89 d0                	mov    %edx,%eax
  800f40:	fc                   	cld    
  800f41:	f3 ab                	rep stos %eax,%es:(%edi)
  800f43:	eb d6                	jmp    800f1b <memset+0x23>

00800f45 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800f45:	55                   	push   %ebp
  800f46:	89 e5                	mov    %esp,%ebp
  800f48:	57                   	push   %edi
  800f49:	56                   	push   %esi
  800f4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4d:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f50:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f53:	39 c6                	cmp    %eax,%esi
  800f55:	73 35                	jae    800f8c <memmove+0x47>
  800f57:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800f5a:	39 c2                	cmp    %eax,%edx
  800f5c:	76 2e                	jbe    800f8c <memmove+0x47>
		s += n;
		d += n;
  800f5e:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800f61:	89 d6                	mov    %edx,%esi
  800f63:	09 fe                	or     %edi,%esi
  800f65:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800f6b:	74 0c                	je     800f79 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800f6d:	83 ef 01             	sub    $0x1,%edi
  800f70:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800f73:	fd                   	std    
  800f74:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800f76:	fc                   	cld    
  800f77:	eb 21                	jmp    800f9a <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800f79:	f6 c1 03             	test   $0x3,%cl
  800f7c:	75 ef                	jne    800f6d <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800f7e:	83 ef 04             	sub    $0x4,%edi
  800f81:	8d 72 fc             	lea    -0x4(%edx),%esi
  800f84:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800f87:	fd                   	std    
  800f88:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800f8a:	eb ea                	jmp    800f76 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800f8c:	89 f2                	mov    %esi,%edx
  800f8e:	09 c2                	or     %eax,%edx
  800f90:	f6 c2 03             	test   $0x3,%dl
  800f93:	74 09                	je     800f9e <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800f95:	89 c7                	mov    %eax,%edi
  800f97:	fc                   	cld    
  800f98:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800f9a:	5e                   	pop    %esi
  800f9b:	5f                   	pop    %edi
  800f9c:	5d                   	pop    %ebp
  800f9d:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800f9e:	f6 c1 03             	test   $0x3,%cl
  800fa1:	75 f2                	jne    800f95 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800fa3:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800fa6:	89 c7                	mov    %eax,%edi
  800fa8:	fc                   	cld    
  800fa9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800fab:	eb ed                	jmp    800f9a <memmove+0x55>

00800fad <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800fad:	55                   	push   %ebp
  800fae:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800fb0:	ff 75 10             	pushl  0x10(%ebp)
  800fb3:	ff 75 0c             	pushl  0xc(%ebp)
  800fb6:	ff 75 08             	pushl  0x8(%ebp)
  800fb9:	e8 87 ff ff ff       	call   800f45 <memmove>
}
  800fbe:	c9                   	leave  
  800fbf:	c3                   	ret    

00800fc0 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800fc0:	55                   	push   %ebp
  800fc1:	89 e5                	mov    %esp,%ebp
  800fc3:	56                   	push   %esi
  800fc4:	53                   	push   %ebx
  800fc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fcb:	89 c6                	mov    %eax,%esi
  800fcd:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800fd0:	39 f0                	cmp    %esi,%eax
  800fd2:	74 1c                	je     800ff0 <memcmp+0x30>
		if (*s1 != *s2)
  800fd4:	0f b6 08             	movzbl (%eax),%ecx
  800fd7:	0f b6 1a             	movzbl (%edx),%ebx
  800fda:	38 d9                	cmp    %bl,%cl
  800fdc:	75 08                	jne    800fe6 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800fde:	83 c0 01             	add    $0x1,%eax
  800fe1:	83 c2 01             	add    $0x1,%edx
  800fe4:	eb ea                	jmp    800fd0 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800fe6:	0f b6 c1             	movzbl %cl,%eax
  800fe9:	0f b6 db             	movzbl %bl,%ebx
  800fec:	29 d8                	sub    %ebx,%eax
  800fee:	eb 05                	jmp    800ff5 <memcmp+0x35>
	}

	return 0;
  800ff0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ff5:	5b                   	pop    %ebx
  800ff6:	5e                   	pop    %esi
  800ff7:	5d                   	pop    %ebp
  800ff8:	c3                   	ret    

00800ff9 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ff9:	55                   	push   %ebp
  800ffa:	89 e5                	mov    %esp,%ebp
  800ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fff:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801002:	89 c2                	mov    %eax,%edx
  801004:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801007:	39 d0                	cmp    %edx,%eax
  801009:	73 09                	jae    801014 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  80100b:	38 08                	cmp    %cl,(%eax)
  80100d:	74 05                	je     801014 <memfind+0x1b>
	for (; s < ends; s++)
  80100f:	83 c0 01             	add    $0x1,%eax
  801012:	eb f3                	jmp    801007 <memfind+0xe>
			break;
	return (void *) s;
}
  801014:	5d                   	pop    %ebp
  801015:	c3                   	ret    

00801016 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801016:	55                   	push   %ebp
  801017:	89 e5                	mov    %esp,%ebp
  801019:	57                   	push   %edi
  80101a:	56                   	push   %esi
  80101b:	53                   	push   %ebx
  80101c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80101f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801022:	eb 03                	jmp    801027 <strtol+0x11>
		s++;
  801024:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  801027:	0f b6 01             	movzbl (%ecx),%eax
  80102a:	3c 20                	cmp    $0x20,%al
  80102c:	74 f6                	je     801024 <strtol+0xe>
  80102e:	3c 09                	cmp    $0x9,%al
  801030:	74 f2                	je     801024 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  801032:	3c 2b                	cmp    $0x2b,%al
  801034:	74 2e                	je     801064 <strtol+0x4e>
	int neg = 0;
  801036:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  80103b:	3c 2d                	cmp    $0x2d,%al
  80103d:	74 2f                	je     80106e <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80103f:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  801045:	75 05                	jne    80104c <strtol+0x36>
  801047:	80 39 30             	cmpb   $0x30,(%ecx)
  80104a:	74 2c                	je     801078 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  80104c:	85 db                	test   %ebx,%ebx
  80104e:	75 0a                	jne    80105a <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801050:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  801055:	80 39 30             	cmpb   $0x30,(%ecx)
  801058:	74 28                	je     801082 <strtol+0x6c>
		base = 10;
  80105a:	b8 00 00 00 00       	mov    $0x0,%eax
  80105f:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801062:	eb 50                	jmp    8010b4 <strtol+0x9e>
		s++;
  801064:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  801067:	bf 00 00 00 00       	mov    $0x0,%edi
  80106c:	eb d1                	jmp    80103f <strtol+0x29>
		s++, neg = 1;
  80106e:	83 c1 01             	add    $0x1,%ecx
  801071:	bf 01 00 00 00       	mov    $0x1,%edi
  801076:	eb c7                	jmp    80103f <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801078:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  80107c:	74 0e                	je     80108c <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  80107e:	85 db                	test   %ebx,%ebx
  801080:	75 d8                	jne    80105a <strtol+0x44>
		s++, base = 8;
  801082:	83 c1 01             	add    $0x1,%ecx
  801085:	bb 08 00 00 00       	mov    $0x8,%ebx
  80108a:	eb ce                	jmp    80105a <strtol+0x44>
		s += 2, base = 16;
  80108c:	83 c1 02             	add    $0x2,%ecx
  80108f:	bb 10 00 00 00       	mov    $0x10,%ebx
  801094:	eb c4                	jmp    80105a <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  801096:	8d 72 9f             	lea    -0x61(%edx),%esi
  801099:	89 f3                	mov    %esi,%ebx
  80109b:	80 fb 19             	cmp    $0x19,%bl
  80109e:	77 29                	ja     8010c9 <strtol+0xb3>
			dig = *s - 'a' + 10;
  8010a0:	0f be d2             	movsbl %dl,%edx
  8010a3:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  8010a6:	3b 55 10             	cmp    0x10(%ebp),%edx
  8010a9:	7d 30                	jge    8010db <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  8010ab:	83 c1 01             	add    $0x1,%ecx
  8010ae:	0f af 45 10          	imul   0x10(%ebp),%eax
  8010b2:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  8010b4:	0f b6 11             	movzbl (%ecx),%edx
  8010b7:	8d 72 d0             	lea    -0x30(%edx),%esi
  8010ba:	89 f3                	mov    %esi,%ebx
  8010bc:	80 fb 09             	cmp    $0x9,%bl
  8010bf:	77 d5                	ja     801096 <strtol+0x80>
			dig = *s - '0';
  8010c1:	0f be d2             	movsbl %dl,%edx
  8010c4:	83 ea 30             	sub    $0x30,%edx
  8010c7:	eb dd                	jmp    8010a6 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  8010c9:	8d 72 bf             	lea    -0x41(%edx),%esi
  8010cc:	89 f3                	mov    %esi,%ebx
  8010ce:	80 fb 19             	cmp    $0x19,%bl
  8010d1:	77 08                	ja     8010db <strtol+0xc5>
			dig = *s - 'A' + 10;
  8010d3:	0f be d2             	movsbl %dl,%edx
  8010d6:	83 ea 37             	sub    $0x37,%edx
  8010d9:	eb cb                	jmp    8010a6 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  8010db:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010df:	74 05                	je     8010e6 <strtol+0xd0>
		*endptr = (char *) s;
  8010e1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8010e4:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  8010e6:	89 c2                	mov    %eax,%edx
  8010e8:	f7 da                	neg    %edx
  8010ea:	85 ff                	test   %edi,%edi
  8010ec:	0f 45 c2             	cmovne %edx,%eax
}
  8010ef:	5b                   	pop    %ebx
  8010f0:	5e                   	pop    %esi
  8010f1:	5f                   	pop    %edi
  8010f2:	5d                   	pop    %ebp
  8010f3:	c3                   	ret    

008010f4 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8010f4:	55                   	push   %ebp
  8010f5:	89 e5                	mov    %esp,%ebp
  8010f7:	57                   	push   %edi
  8010f8:	56                   	push   %esi
  8010f9:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8010ff:	8b 55 08             	mov    0x8(%ebp),%edx
  801102:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801105:	89 c3                	mov    %eax,%ebx
  801107:	89 c7                	mov    %eax,%edi
  801109:	89 c6                	mov    %eax,%esi
  80110b:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  80110d:	5b                   	pop    %ebx
  80110e:	5e                   	pop    %esi
  80110f:	5f                   	pop    %edi
  801110:	5d                   	pop    %ebp
  801111:	c3                   	ret    

00801112 <sys_cgetc>:

int
sys_cgetc(void)
{
  801112:	55                   	push   %ebp
  801113:	89 e5                	mov    %esp,%ebp
  801115:	57                   	push   %edi
  801116:	56                   	push   %esi
  801117:	53                   	push   %ebx
	asm volatile("int %1\n"
  801118:	ba 00 00 00 00       	mov    $0x0,%edx
  80111d:	b8 01 00 00 00       	mov    $0x1,%eax
  801122:	89 d1                	mov    %edx,%ecx
  801124:	89 d3                	mov    %edx,%ebx
  801126:	89 d7                	mov    %edx,%edi
  801128:	89 d6                	mov    %edx,%esi
  80112a:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  80112c:	5b                   	pop    %ebx
  80112d:	5e                   	pop    %esi
  80112e:	5f                   	pop    %edi
  80112f:	5d                   	pop    %ebp
  801130:	c3                   	ret    

00801131 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801131:	55                   	push   %ebp
  801132:	89 e5                	mov    %esp,%ebp
  801134:	57                   	push   %edi
  801135:	56                   	push   %esi
  801136:	53                   	push   %ebx
  801137:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80113a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80113f:	8b 55 08             	mov    0x8(%ebp),%edx
  801142:	b8 03 00 00 00       	mov    $0x3,%eax
  801147:	89 cb                	mov    %ecx,%ebx
  801149:	89 cf                	mov    %ecx,%edi
  80114b:	89 ce                	mov    %ecx,%esi
  80114d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80114f:	85 c0                	test   %eax,%eax
  801151:	7f 08                	jg     80115b <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801153:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801156:	5b                   	pop    %ebx
  801157:	5e                   	pop    %esi
  801158:	5f                   	pop    %edi
  801159:	5d                   	pop    %ebp
  80115a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80115b:	83 ec 0c             	sub    $0xc,%esp
  80115e:	50                   	push   %eax
  80115f:	6a 03                	push   $0x3
  801161:	68 7f 2d 80 00       	push   $0x802d7f
  801166:	6a 23                	push   $0x23
  801168:	68 9c 2d 80 00       	push   $0x802d9c
  80116d:	e8 cd f4 ff ff       	call   80063f <_panic>

00801172 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801172:	55                   	push   %ebp
  801173:	89 e5                	mov    %esp,%ebp
  801175:	57                   	push   %edi
  801176:	56                   	push   %esi
  801177:	53                   	push   %ebx
	asm volatile("int %1\n"
  801178:	ba 00 00 00 00       	mov    $0x0,%edx
  80117d:	b8 02 00 00 00       	mov    $0x2,%eax
  801182:	89 d1                	mov    %edx,%ecx
  801184:	89 d3                	mov    %edx,%ebx
  801186:	89 d7                	mov    %edx,%edi
  801188:	89 d6                	mov    %edx,%esi
  80118a:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80118c:	5b                   	pop    %ebx
  80118d:	5e                   	pop    %esi
  80118e:	5f                   	pop    %edi
  80118f:	5d                   	pop    %ebp
  801190:	c3                   	ret    

00801191 <sys_yield>:

void
sys_yield(void)
{
  801191:	55                   	push   %ebp
  801192:	89 e5                	mov    %esp,%ebp
  801194:	57                   	push   %edi
  801195:	56                   	push   %esi
  801196:	53                   	push   %ebx
	asm volatile("int %1\n"
  801197:	ba 00 00 00 00       	mov    $0x0,%edx
  80119c:	b8 0b 00 00 00       	mov    $0xb,%eax
  8011a1:	89 d1                	mov    %edx,%ecx
  8011a3:	89 d3                	mov    %edx,%ebx
  8011a5:	89 d7                	mov    %edx,%edi
  8011a7:	89 d6                	mov    %edx,%esi
  8011a9:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8011ab:	5b                   	pop    %ebx
  8011ac:	5e                   	pop    %esi
  8011ad:	5f                   	pop    %edi
  8011ae:	5d                   	pop    %ebp
  8011af:	c3                   	ret    

008011b0 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8011b0:	55                   	push   %ebp
  8011b1:	89 e5                	mov    %esp,%ebp
  8011b3:	57                   	push   %edi
  8011b4:	56                   	push   %esi
  8011b5:	53                   	push   %ebx
  8011b6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011b9:	be 00 00 00 00       	mov    $0x0,%esi
  8011be:	8b 55 08             	mov    0x8(%ebp),%edx
  8011c1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011c4:	b8 04 00 00 00       	mov    $0x4,%eax
  8011c9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8011cc:	89 f7                	mov    %esi,%edi
  8011ce:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011d0:	85 c0                	test   %eax,%eax
  8011d2:	7f 08                	jg     8011dc <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8011d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011d7:	5b                   	pop    %ebx
  8011d8:	5e                   	pop    %esi
  8011d9:	5f                   	pop    %edi
  8011da:	5d                   	pop    %ebp
  8011db:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011dc:	83 ec 0c             	sub    $0xc,%esp
  8011df:	50                   	push   %eax
  8011e0:	6a 04                	push   $0x4
  8011e2:	68 7f 2d 80 00       	push   $0x802d7f
  8011e7:	6a 23                	push   $0x23
  8011e9:	68 9c 2d 80 00       	push   $0x802d9c
  8011ee:	e8 4c f4 ff ff       	call   80063f <_panic>

008011f3 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8011f3:	55                   	push   %ebp
  8011f4:	89 e5                	mov    %esp,%ebp
  8011f6:	57                   	push   %edi
  8011f7:	56                   	push   %esi
  8011f8:	53                   	push   %ebx
  8011f9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011fc:	8b 55 08             	mov    0x8(%ebp),%edx
  8011ff:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801202:	b8 05 00 00 00       	mov    $0x5,%eax
  801207:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80120a:	8b 7d 14             	mov    0x14(%ebp),%edi
  80120d:	8b 75 18             	mov    0x18(%ebp),%esi
  801210:	cd 30                	int    $0x30
	if(check && ret > 0)
  801212:	85 c0                	test   %eax,%eax
  801214:	7f 08                	jg     80121e <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801216:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801219:	5b                   	pop    %ebx
  80121a:	5e                   	pop    %esi
  80121b:	5f                   	pop    %edi
  80121c:	5d                   	pop    %ebp
  80121d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80121e:	83 ec 0c             	sub    $0xc,%esp
  801221:	50                   	push   %eax
  801222:	6a 05                	push   $0x5
  801224:	68 7f 2d 80 00       	push   $0x802d7f
  801229:	6a 23                	push   $0x23
  80122b:	68 9c 2d 80 00       	push   $0x802d9c
  801230:	e8 0a f4 ff ff       	call   80063f <_panic>

00801235 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801235:	55                   	push   %ebp
  801236:	89 e5                	mov    %esp,%ebp
  801238:	57                   	push   %edi
  801239:	56                   	push   %esi
  80123a:	53                   	push   %ebx
  80123b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80123e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801243:	8b 55 08             	mov    0x8(%ebp),%edx
  801246:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801249:	b8 06 00 00 00       	mov    $0x6,%eax
  80124e:	89 df                	mov    %ebx,%edi
  801250:	89 de                	mov    %ebx,%esi
  801252:	cd 30                	int    $0x30
	if(check && ret > 0)
  801254:	85 c0                	test   %eax,%eax
  801256:	7f 08                	jg     801260 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801258:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80125b:	5b                   	pop    %ebx
  80125c:	5e                   	pop    %esi
  80125d:	5f                   	pop    %edi
  80125e:	5d                   	pop    %ebp
  80125f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801260:	83 ec 0c             	sub    $0xc,%esp
  801263:	50                   	push   %eax
  801264:	6a 06                	push   $0x6
  801266:	68 7f 2d 80 00       	push   $0x802d7f
  80126b:	6a 23                	push   $0x23
  80126d:	68 9c 2d 80 00       	push   $0x802d9c
  801272:	e8 c8 f3 ff ff       	call   80063f <_panic>

00801277 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801277:	55                   	push   %ebp
  801278:	89 e5                	mov    %esp,%ebp
  80127a:	57                   	push   %edi
  80127b:	56                   	push   %esi
  80127c:	53                   	push   %ebx
  80127d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801280:	bb 00 00 00 00       	mov    $0x0,%ebx
  801285:	8b 55 08             	mov    0x8(%ebp),%edx
  801288:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80128b:	b8 08 00 00 00       	mov    $0x8,%eax
  801290:	89 df                	mov    %ebx,%edi
  801292:	89 de                	mov    %ebx,%esi
  801294:	cd 30                	int    $0x30
	if(check && ret > 0)
  801296:	85 c0                	test   %eax,%eax
  801298:	7f 08                	jg     8012a2 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80129a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80129d:	5b                   	pop    %ebx
  80129e:	5e                   	pop    %esi
  80129f:	5f                   	pop    %edi
  8012a0:	5d                   	pop    %ebp
  8012a1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8012a2:	83 ec 0c             	sub    $0xc,%esp
  8012a5:	50                   	push   %eax
  8012a6:	6a 08                	push   $0x8
  8012a8:	68 7f 2d 80 00       	push   $0x802d7f
  8012ad:	6a 23                	push   $0x23
  8012af:	68 9c 2d 80 00       	push   $0x802d9c
  8012b4:	e8 86 f3 ff ff       	call   80063f <_panic>

008012b9 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8012b9:	55                   	push   %ebp
  8012ba:	89 e5                	mov    %esp,%ebp
  8012bc:	57                   	push   %edi
  8012bd:	56                   	push   %esi
  8012be:	53                   	push   %ebx
  8012bf:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8012c2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012c7:	8b 55 08             	mov    0x8(%ebp),%edx
  8012ca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012cd:	b8 09 00 00 00       	mov    $0x9,%eax
  8012d2:	89 df                	mov    %ebx,%edi
  8012d4:	89 de                	mov    %ebx,%esi
  8012d6:	cd 30                	int    $0x30
	if(check && ret > 0)
  8012d8:	85 c0                	test   %eax,%eax
  8012da:	7f 08                	jg     8012e4 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8012dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012df:	5b                   	pop    %ebx
  8012e0:	5e                   	pop    %esi
  8012e1:	5f                   	pop    %edi
  8012e2:	5d                   	pop    %ebp
  8012e3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8012e4:	83 ec 0c             	sub    $0xc,%esp
  8012e7:	50                   	push   %eax
  8012e8:	6a 09                	push   $0x9
  8012ea:	68 7f 2d 80 00       	push   $0x802d7f
  8012ef:	6a 23                	push   $0x23
  8012f1:	68 9c 2d 80 00       	push   $0x802d9c
  8012f6:	e8 44 f3 ff ff       	call   80063f <_panic>

008012fb <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8012fb:	55                   	push   %ebp
  8012fc:	89 e5                	mov    %esp,%ebp
  8012fe:	57                   	push   %edi
  8012ff:	56                   	push   %esi
  801300:	53                   	push   %ebx
  801301:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801304:	bb 00 00 00 00       	mov    $0x0,%ebx
  801309:	8b 55 08             	mov    0x8(%ebp),%edx
  80130c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80130f:	b8 0a 00 00 00       	mov    $0xa,%eax
  801314:	89 df                	mov    %ebx,%edi
  801316:	89 de                	mov    %ebx,%esi
  801318:	cd 30                	int    $0x30
	if(check && ret > 0)
  80131a:	85 c0                	test   %eax,%eax
  80131c:	7f 08                	jg     801326 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80131e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801321:	5b                   	pop    %ebx
  801322:	5e                   	pop    %esi
  801323:	5f                   	pop    %edi
  801324:	5d                   	pop    %ebp
  801325:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801326:	83 ec 0c             	sub    $0xc,%esp
  801329:	50                   	push   %eax
  80132a:	6a 0a                	push   $0xa
  80132c:	68 7f 2d 80 00       	push   $0x802d7f
  801331:	6a 23                	push   $0x23
  801333:	68 9c 2d 80 00       	push   $0x802d9c
  801338:	e8 02 f3 ff ff       	call   80063f <_panic>

0080133d <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80133d:	55                   	push   %ebp
  80133e:	89 e5                	mov    %esp,%ebp
  801340:	57                   	push   %edi
  801341:	56                   	push   %esi
  801342:	53                   	push   %ebx
	asm volatile("int %1\n"
  801343:	8b 55 08             	mov    0x8(%ebp),%edx
  801346:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801349:	b8 0c 00 00 00       	mov    $0xc,%eax
  80134e:	be 00 00 00 00       	mov    $0x0,%esi
  801353:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801356:	8b 7d 14             	mov    0x14(%ebp),%edi
  801359:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80135b:	5b                   	pop    %ebx
  80135c:	5e                   	pop    %esi
  80135d:	5f                   	pop    %edi
  80135e:	5d                   	pop    %ebp
  80135f:	c3                   	ret    

00801360 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801360:	55                   	push   %ebp
  801361:	89 e5                	mov    %esp,%ebp
  801363:	57                   	push   %edi
  801364:	56                   	push   %esi
  801365:	53                   	push   %ebx
  801366:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801369:	b9 00 00 00 00       	mov    $0x0,%ecx
  80136e:	8b 55 08             	mov    0x8(%ebp),%edx
  801371:	b8 0d 00 00 00       	mov    $0xd,%eax
  801376:	89 cb                	mov    %ecx,%ebx
  801378:	89 cf                	mov    %ecx,%edi
  80137a:	89 ce                	mov    %ecx,%esi
  80137c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80137e:	85 c0                	test   %eax,%eax
  801380:	7f 08                	jg     80138a <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
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
  80138e:	6a 0d                	push   $0xd
  801390:	68 7f 2d 80 00       	push   $0x802d7f
  801395:	6a 23                	push   $0x23
  801397:	68 9c 2d 80 00       	push   $0x802d9c
  80139c:	e8 9e f2 ff ff       	call   80063f <_panic>

008013a1 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8013a1:	55                   	push   %ebp
  8013a2:	89 e5                	mov    %esp,%ebp
  8013a4:	57                   	push   %edi
  8013a5:	56                   	push   %esi
  8013a6:	53                   	push   %ebx
	asm volatile("int %1\n"
  8013a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8013ac:	b8 0e 00 00 00       	mov    $0xe,%eax
  8013b1:	89 d1                	mov    %edx,%ecx
  8013b3:	89 d3                	mov    %edx,%ebx
  8013b5:	89 d7                	mov    %edx,%edi
  8013b7:	89 d6                	mov    %edx,%esi
  8013b9:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8013bb:	5b                   	pop    %ebx
  8013bc:	5e                   	pop    %esi
  8013bd:	5f                   	pop    %edi
  8013be:	5d                   	pop    %ebp
  8013bf:	c3                   	ret    

008013c0 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8013c0:	55                   	push   %ebp
  8013c1:	89 e5                	mov    %esp,%ebp
  8013c3:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8013c6:	83 3d b8 40 80 00 00 	cmpl   $0x0,0x8040b8
  8013cd:	74 0a                	je     8013d9 <set_pgfault_handler+0x19>
		    panic("set_pgfault_handler: %e", r);
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8013cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d2:	a3 b8 40 80 00       	mov    %eax,0x8040b8
}
  8013d7:	c9                   	leave  
  8013d8:	c3                   	ret    
		if ((r = sys_page_alloc(thisenv->env_id, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P)) != 0) {
  8013d9:	a1 b4 40 80 00       	mov    0x8040b4,%eax
  8013de:	8b 40 48             	mov    0x48(%eax),%eax
  8013e1:	83 ec 04             	sub    $0x4,%esp
  8013e4:	6a 07                	push   $0x7
  8013e6:	68 00 f0 bf ee       	push   $0xeebff000
  8013eb:	50                   	push   %eax
  8013ec:	e8 bf fd ff ff       	call   8011b0 <sys_page_alloc>
  8013f1:	83 c4 10             	add    $0x10,%esp
  8013f4:	85 c0                	test   %eax,%eax
  8013f6:	75 2f                	jne    801427 <set_pgfault_handler+0x67>
		if ((r = sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall)) != 0) {
  8013f8:	a1 b4 40 80 00       	mov    0x8040b4,%eax
  8013fd:	8b 40 48             	mov    0x48(%eax),%eax
  801400:	83 ec 08             	sub    $0x8,%esp
  801403:	68 39 14 80 00       	push   $0x801439
  801408:	50                   	push   %eax
  801409:	e8 ed fe ff ff       	call   8012fb <sys_env_set_pgfault_upcall>
  80140e:	83 c4 10             	add    $0x10,%esp
  801411:	85 c0                	test   %eax,%eax
  801413:	74 ba                	je     8013cf <set_pgfault_handler+0xf>
		    panic("set_pgfault_handler: %e", r);
  801415:	50                   	push   %eax
  801416:	68 aa 2d 80 00       	push   $0x802daa
  80141b:	6a 24                	push   $0x24
  80141d:	68 c2 2d 80 00       	push   $0x802dc2
  801422:	e8 18 f2 ff ff       	call   80063f <_panic>
		    panic("set_pgfault_handler: %e", r);
  801427:	50                   	push   %eax
  801428:	68 aa 2d 80 00       	push   $0x802daa
  80142d:	6a 21                	push   $0x21
  80142f:	68 c2 2d 80 00       	push   $0x802dc2
  801434:	e8 06 f2 ff ff       	call   80063f <_panic>

00801439 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801439:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80143a:	a1 b8 40 80 00       	mov    0x8040b8,%eax
	call *%eax
  80143f:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801441:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x30(%esp), %ecx    // save trap-time esp in ecx
  801444:	8b 4c 24 30          	mov    0x30(%esp),%ecx
	subl $4, %ecx            // enlarge the previous stack for 4 bytes
  801448:	83 e9 04             	sub    $0x4,%ecx
	movl %ecx, 0x30(%esp)    // write the modified esp back
  80144b:	89 4c 24 30          	mov    %ecx,0x30(%esp)
	movl 0x28(%esp), %edx    // save trap-time eip in edx
  80144f:	8b 54 24 28          	mov    0x28(%esp),%edx
	movl %edx, (%ecx)        // save eip at new esp for return
  801453:	89 11                	mov    %edx,(%ecx)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp            // skip fault_va and tf_err
  801455:	83 c4 08             	add    $0x8,%esp
	popal                    // pop PushRegs
  801458:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4, %esp            // skip eip
  801459:	83 c4 04             	add    $0x4,%esp
	popfl                    // pop eflags
  80145c:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	pop %esp
  80145d:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  80145e:	c3                   	ret    

0080145f <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80145f:	55                   	push   %ebp
  801460:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801462:	8b 45 08             	mov    0x8(%ebp),%eax
  801465:	05 00 00 00 30       	add    $0x30000000,%eax
  80146a:	c1 e8 0c             	shr    $0xc,%eax
}
  80146d:	5d                   	pop    %ebp
  80146e:	c3                   	ret    

0080146f <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80146f:	55                   	push   %ebp
  801470:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801472:	8b 45 08             	mov    0x8(%ebp),%eax
  801475:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80147a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80147f:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801484:	5d                   	pop    %ebp
  801485:	c3                   	ret    

00801486 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801486:	55                   	push   %ebp
  801487:	89 e5                	mov    %esp,%ebp
  801489:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80148c:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801491:	89 c2                	mov    %eax,%edx
  801493:	c1 ea 16             	shr    $0x16,%edx
  801496:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80149d:	f6 c2 01             	test   $0x1,%dl
  8014a0:	74 2a                	je     8014cc <fd_alloc+0x46>
  8014a2:	89 c2                	mov    %eax,%edx
  8014a4:	c1 ea 0c             	shr    $0xc,%edx
  8014a7:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8014ae:	f6 c2 01             	test   $0x1,%dl
  8014b1:	74 19                	je     8014cc <fd_alloc+0x46>
  8014b3:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8014b8:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8014bd:	75 d2                	jne    801491 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8014bf:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8014c5:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8014ca:	eb 07                	jmp    8014d3 <fd_alloc+0x4d>
			*fd_store = fd;
  8014cc:	89 01                	mov    %eax,(%ecx)
			return 0;
  8014ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014d3:	5d                   	pop    %ebp
  8014d4:	c3                   	ret    

008014d5 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8014d5:	55                   	push   %ebp
  8014d6:	89 e5                	mov    %esp,%ebp
  8014d8:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8014db:	83 f8 1f             	cmp    $0x1f,%eax
  8014de:	77 36                	ja     801516 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8014e0:	c1 e0 0c             	shl    $0xc,%eax
  8014e3:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8014e8:	89 c2                	mov    %eax,%edx
  8014ea:	c1 ea 16             	shr    $0x16,%edx
  8014ed:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8014f4:	f6 c2 01             	test   $0x1,%dl
  8014f7:	74 24                	je     80151d <fd_lookup+0x48>
  8014f9:	89 c2                	mov    %eax,%edx
  8014fb:	c1 ea 0c             	shr    $0xc,%edx
  8014fe:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801505:	f6 c2 01             	test   $0x1,%dl
  801508:	74 1a                	je     801524 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80150a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80150d:	89 02                	mov    %eax,(%edx)
	return 0;
  80150f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801514:	5d                   	pop    %ebp
  801515:	c3                   	ret    
		return -E_INVAL;
  801516:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80151b:	eb f7                	jmp    801514 <fd_lookup+0x3f>
		return -E_INVAL;
  80151d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801522:	eb f0                	jmp    801514 <fd_lookup+0x3f>
  801524:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801529:	eb e9                	jmp    801514 <fd_lookup+0x3f>

0080152b <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80152b:	55                   	push   %ebp
  80152c:	89 e5                	mov    %esp,%ebp
  80152e:	83 ec 08             	sub    $0x8,%esp
  801531:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801534:	ba 4c 2e 80 00       	mov    $0x802e4c,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801539:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80153e:	39 08                	cmp    %ecx,(%eax)
  801540:	74 33                	je     801575 <dev_lookup+0x4a>
  801542:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801545:	8b 02                	mov    (%edx),%eax
  801547:	85 c0                	test   %eax,%eax
  801549:	75 f3                	jne    80153e <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80154b:	a1 b4 40 80 00       	mov    0x8040b4,%eax
  801550:	8b 40 48             	mov    0x48(%eax),%eax
  801553:	83 ec 04             	sub    $0x4,%esp
  801556:	51                   	push   %ecx
  801557:	50                   	push   %eax
  801558:	68 d0 2d 80 00       	push   $0x802dd0
  80155d:	e8 b8 f1 ff ff       	call   80071a <cprintf>
	*dev = 0;
  801562:	8b 45 0c             	mov    0xc(%ebp),%eax
  801565:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80156b:	83 c4 10             	add    $0x10,%esp
  80156e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801573:	c9                   	leave  
  801574:	c3                   	ret    
			*dev = devtab[i];
  801575:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801578:	89 01                	mov    %eax,(%ecx)
			return 0;
  80157a:	b8 00 00 00 00       	mov    $0x0,%eax
  80157f:	eb f2                	jmp    801573 <dev_lookup+0x48>

00801581 <fd_close>:
{
  801581:	55                   	push   %ebp
  801582:	89 e5                	mov    %esp,%ebp
  801584:	57                   	push   %edi
  801585:	56                   	push   %esi
  801586:	53                   	push   %ebx
  801587:	83 ec 1c             	sub    $0x1c,%esp
  80158a:	8b 75 08             	mov    0x8(%ebp),%esi
  80158d:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801590:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801593:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801594:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80159a:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80159d:	50                   	push   %eax
  80159e:	e8 32 ff ff ff       	call   8014d5 <fd_lookup>
  8015a3:	89 c3                	mov    %eax,%ebx
  8015a5:	83 c4 08             	add    $0x8,%esp
  8015a8:	85 c0                	test   %eax,%eax
  8015aa:	78 05                	js     8015b1 <fd_close+0x30>
	    || fd != fd2)
  8015ac:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8015af:	74 16                	je     8015c7 <fd_close+0x46>
		return (must_exist ? r : 0);
  8015b1:	89 f8                	mov    %edi,%eax
  8015b3:	84 c0                	test   %al,%al
  8015b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8015ba:	0f 44 d8             	cmove  %eax,%ebx
}
  8015bd:	89 d8                	mov    %ebx,%eax
  8015bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015c2:	5b                   	pop    %ebx
  8015c3:	5e                   	pop    %esi
  8015c4:	5f                   	pop    %edi
  8015c5:	5d                   	pop    %ebp
  8015c6:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8015c7:	83 ec 08             	sub    $0x8,%esp
  8015ca:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8015cd:	50                   	push   %eax
  8015ce:	ff 36                	pushl  (%esi)
  8015d0:	e8 56 ff ff ff       	call   80152b <dev_lookup>
  8015d5:	89 c3                	mov    %eax,%ebx
  8015d7:	83 c4 10             	add    $0x10,%esp
  8015da:	85 c0                	test   %eax,%eax
  8015dc:	78 15                	js     8015f3 <fd_close+0x72>
		if (dev->dev_close)
  8015de:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015e1:	8b 40 10             	mov    0x10(%eax),%eax
  8015e4:	85 c0                	test   %eax,%eax
  8015e6:	74 1b                	je     801603 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  8015e8:	83 ec 0c             	sub    $0xc,%esp
  8015eb:	56                   	push   %esi
  8015ec:	ff d0                	call   *%eax
  8015ee:	89 c3                	mov    %eax,%ebx
  8015f0:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8015f3:	83 ec 08             	sub    $0x8,%esp
  8015f6:	56                   	push   %esi
  8015f7:	6a 00                	push   $0x0
  8015f9:	e8 37 fc ff ff       	call   801235 <sys_page_unmap>
	return r;
  8015fe:	83 c4 10             	add    $0x10,%esp
  801601:	eb ba                	jmp    8015bd <fd_close+0x3c>
			r = 0;
  801603:	bb 00 00 00 00       	mov    $0x0,%ebx
  801608:	eb e9                	jmp    8015f3 <fd_close+0x72>

0080160a <close>:

int
close(int fdnum)
{
  80160a:	55                   	push   %ebp
  80160b:	89 e5                	mov    %esp,%ebp
  80160d:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801610:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801613:	50                   	push   %eax
  801614:	ff 75 08             	pushl  0x8(%ebp)
  801617:	e8 b9 fe ff ff       	call   8014d5 <fd_lookup>
  80161c:	83 c4 08             	add    $0x8,%esp
  80161f:	85 c0                	test   %eax,%eax
  801621:	78 10                	js     801633 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  801623:	83 ec 08             	sub    $0x8,%esp
  801626:	6a 01                	push   $0x1
  801628:	ff 75 f4             	pushl  -0xc(%ebp)
  80162b:	e8 51 ff ff ff       	call   801581 <fd_close>
  801630:	83 c4 10             	add    $0x10,%esp
}
  801633:	c9                   	leave  
  801634:	c3                   	ret    

00801635 <close_all>:

void
close_all(void)
{
  801635:	55                   	push   %ebp
  801636:	89 e5                	mov    %esp,%ebp
  801638:	53                   	push   %ebx
  801639:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80163c:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801641:	83 ec 0c             	sub    $0xc,%esp
  801644:	53                   	push   %ebx
  801645:	e8 c0 ff ff ff       	call   80160a <close>
	for (i = 0; i < MAXFD; i++)
  80164a:	83 c3 01             	add    $0x1,%ebx
  80164d:	83 c4 10             	add    $0x10,%esp
  801650:	83 fb 20             	cmp    $0x20,%ebx
  801653:	75 ec                	jne    801641 <close_all+0xc>
}
  801655:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801658:	c9                   	leave  
  801659:	c3                   	ret    

0080165a <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80165a:	55                   	push   %ebp
  80165b:	89 e5                	mov    %esp,%ebp
  80165d:	57                   	push   %edi
  80165e:	56                   	push   %esi
  80165f:	53                   	push   %ebx
  801660:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801663:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801666:	50                   	push   %eax
  801667:	ff 75 08             	pushl  0x8(%ebp)
  80166a:	e8 66 fe ff ff       	call   8014d5 <fd_lookup>
  80166f:	89 c3                	mov    %eax,%ebx
  801671:	83 c4 08             	add    $0x8,%esp
  801674:	85 c0                	test   %eax,%eax
  801676:	0f 88 81 00 00 00    	js     8016fd <dup+0xa3>
		return r;
	close(newfdnum);
  80167c:	83 ec 0c             	sub    $0xc,%esp
  80167f:	ff 75 0c             	pushl  0xc(%ebp)
  801682:	e8 83 ff ff ff       	call   80160a <close>

	newfd = INDEX2FD(newfdnum);
  801687:	8b 75 0c             	mov    0xc(%ebp),%esi
  80168a:	c1 e6 0c             	shl    $0xc,%esi
  80168d:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801693:	83 c4 04             	add    $0x4,%esp
  801696:	ff 75 e4             	pushl  -0x1c(%ebp)
  801699:	e8 d1 fd ff ff       	call   80146f <fd2data>
  80169e:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8016a0:	89 34 24             	mov    %esi,(%esp)
  8016a3:	e8 c7 fd ff ff       	call   80146f <fd2data>
  8016a8:	83 c4 10             	add    $0x10,%esp
  8016ab:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8016ad:	89 d8                	mov    %ebx,%eax
  8016af:	c1 e8 16             	shr    $0x16,%eax
  8016b2:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8016b9:	a8 01                	test   $0x1,%al
  8016bb:	74 11                	je     8016ce <dup+0x74>
  8016bd:	89 d8                	mov    %ebx,%eax
  8016bf:	c1 e8 0c             	shr    $0xc,%eax
  8016c2:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8016c9:	f6 c2 01             	test   $0x1,%dl
  8016cc:	75 39                	jne    801707 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8016ce:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8016d1:	89 d0                	mov    %edx,%eax
  8016d3:	c1 e8 0c             	shr    $0xc,%eax
  8016d6:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8016dd:	83 ec 0c             	sub    $0xc,%esp
  8016e0:	25 07 0e 00 00       	and    $0xe07,%eax
  8016e5:	50                   	push   %eax
  8016e6:	56                   	push   %esi
  8016e7:	6a 00                	push   $0x0
  8016e9:	52                   	push   %edx
  8016ea:	6a 00                	push   $0x0
  8016ec:	e8 02 fb ff ff       	call   8011f3 <sys_page_map>
  8016f1:	89 c3                	mov    %eax,%ebx
  8016f3:	83 c4 20             	add    $0x20,%esp
  8016f6:	85 c0                	test   %eax,%eax
  8016f8:	78 31                	js     80172b <dup+0xd1>
		goto err;

	return newfdnum;
  8016fa:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8016fd:	89 d8                	mov    %ebx,%eax
  8016ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801702:	5b                   	pop    %ebx
  801703:	5e                   	pop    %esi
  801704:	5f                   	pop    %edi
  801705:	5d                   	pop    %ebp
  801706:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801707:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80170e:	83 ec 0c             	sub    $0xc,%esp
  801711:	25 07 0e 00 00       	and    $0xe07,%eax
  801716:	50                   	push   %eax
  801717:	57                   	push   %edi
  801718:	6a 00                	push   $0x0
  80171a:	53                   	push   %ebx
  80171b:	6a 00                	push   $0x0
  80171d:	e8 d1 fa ff ff       	call   8011f3 <sys_page_map>
  801722:	89 c3                	mov    %eax,%ebx
  801724:	83 c4 20             	add    $0x20,%esp
  801727:	85 c0                	test   %eax,%eax
  801729:	79 a3                	jns    8016ce <dup+0x74>
	sys_page_unmap(0, newfd);
  80172b:	83 ec 08             	sub    $0x8,%esp
  80172e:	56                   	push   %esi
  80172f:	6a 00                	push   $0x0
  801731:	e8 ff fa ff ff       	call   801235 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801736:	83 c4 08             	add    $0x8,%esp
  801739:	57                   	push   %edi
  80173a:	6a 00                	push   $0x0
  80173c:	e8 f4 fa ff ff       	call   801235 <sys_page_unmap>
	return r;
  801741:	83 c4 10             	add    $0x10,%esp
  801744:	eb b7                	jmp    8016fd <dup+0xa3>

00801746 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801746:	55                   	push   %ebp
  801747:	89 e5                	mov    %esp,%ebp
  801749:	53                   	push   %ebx
  80174a:	83 ec 14             	sub    $0x14,%esp
  80174d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801750:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801753:	50                   	push   %eax
  801754:	53                   	push   %ebx
  801755:	e8 7b fd ff ff       	call   8014d5 <fd_lookup>
  80175a:	83 c4 08             	add    $0x8,%esp
  80175d:	85 c0                	test   %eax,%eax
  80175f:	78 3f                	js     8017a0 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801761:	83 ec 08             	sub    $0x8,%esp
  801764:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801767:	50                   	push   %eax
  801768:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80176b:	ff 30                	pushl  (%eax)
  80176d:	e8 b9 fd ff ff       	call   80152b <dev_lookup>
  801772:	83 c4 10             	add    $0x10,%esp
  801775:	85 c0                	test   %eax,%eax
  801777:	78 27                	js     8017a0 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801779:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80177c:	8b 42 08             	mov    0x8(%edx),%eax
  80177f:	83 e0 03             	and    $0x3,%eax
  801782:	83 f8 01             	cmp    $0x1,%eax
  801785:	74 1e                	je     8017a5 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801787:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80178a:	8b 40 08             	mov    0x8(%eax),%eax
  80178d:	85 c0                	test   %eax,%eax
  80178f:	74 35                	je     8017c6 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801791:	83 ec 04             	sub    $0x4,%esp
  801794:	ff 75 10             	pushl  0x10(%ebp)
  801797:	ff 75 0c             	pushl  0xc(%ebp)
  80179a:	52                   	push   %edx
  80179b:	ff d0                	call   *%eax
  80179d:	83 c4 10             	add    $0x10,%esp
}
  8017a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017a3:	c9                   	leave  
  8017a4:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8017a5:	a1 b4 40 80 00       	mov    0x8040b4,%eax
  8017aa:	8b 40 48             	mov    0x48(%eax),%eax
  8017ad:	83 ec 04             	sub    $0x4,%esp
  8017b0:	53                   	push   %ebx
  8017b1:	50                   	push   %eax
  8017b2:	68 11 2e 80 00       	push   $0x802e11
  8017b7:	e8 5e ef ff ff       	call   80071a <cprintf>
		return -E_INVAL;
  8017bc:	83 c4 10             	add    $0x10,%esp
  8017bf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017c4:	eb da                	jmp    8017a0 <read+0x5a>
		return -E_NOT_SUPP;
  8017c6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017cb:	eb d3                	jmp    8017a0 <read+0x5a>

008017cd <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8017cd:	55                   	push   %ebp
  8017ce:	89 e5                	mov    %esp,%ebp
  8017d0:	57                   	push   %edi
  8017d1:	56                   	push   %esi
  8017d2:	53                   	push   %ebx
  8017d3:	83 ec 0c             	sub    $0xc,%esp
  8017d6:	8b 7d 08             	mov    0x8(%ebp),%edi
  8017d9:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8017dc:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017e1:	39 f3                	cmp    %esi,%ebx
  8017e3:	73 25                	jae    80180a <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8017e5:	83 ec 04             	sub    $0x4,%esp
  8017e8:	89 f0                	mov    %esi,%eax
  8017ea:	29 d8                	sub    %ebx,%eax
  8017ec:	50                   	push   %eax
  8017ed:	89 d8                	mov    %ebx,%eax
  8017ef:	03 45 0c             	add    0xc(%ebp),%eax
  8017f2:	50                   	push   %eax
  8017f3:	57                   	push   %edi
  8017f4:	e8 4d ff ff ff       	call   801746 <read>
		if (m < 0)
  8017f9:	83 c4 10             	add    $0x10,%esp
  8017fc:	85 c0                	test   %eax,%eax
  8017fe:	78 08                	js     801808 <readn+0x3b>
			return m;
		if (m == 0)
  801800:	85 c0                	test   %eax,%eax
  801802:	74 06                	je     80180a <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  801804:	01 c3                	add    %eax,%ebx
  801806:	eb d9                	jmp    8017e1 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801808:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80180a:	89 d8                	mov    %ebx,%eax
  80180c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80180f:	5b                   	pop    %ebx
  801810:	5e                   	pop    %esi
  801811:	5f                   	pop    %edi
  801812:	5d                   	pop    %ebp
  801813:	c3                   	ret    

00801814 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801814:	55                   	push   %ebp
  801815:	89 e5                	mov    %esp,%ebp
  801817:	53                   	push   %ebx
  801818:	83 ec 14             	sub    $0x14,%esp
  80181b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80181e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801821:	50                   	push   %eax
  801822:	53                   	push   %ebx
  801823:	e8 ad fc ff ff       	call   8014d5 <fd_lookup>
  801828:	83 c4 08             	add    $0x8,%esp
  80182b:	85 c0                	test   %eax,%eax
  80182d:	78 3a                	js     801869 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80182f:	83 ec 08             	sub    $0x8,%esp
  801832:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801835:	50                   	push   %eax
  801836:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801839:	ff 30                	pushl  (%eax)
  80183b:	e8 eb fc ff ff       	call   80152b <dev_lookup>
  801840:	83 c4 10             	add    $0x10,%esp
  801843:	85 c0                	test   %eax,%eax
  801845:	78 22                	js     801869 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801847:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80184a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80184e:	74 1e                	je     80186e <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801850:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801853:	8b 52 0c             	mov    0xc(%edx),%edx
  801856:	85 d2                	test   %edx,%edx
  801858:	74 35                	je     80188f <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80185a:	83 ec 04             	sub    $0x4,%esp
  80185d:	ff 75 10             	pushl  0x10(%ebp)
  801860:	ff 75 0c             	pushl  0xc(%ebp)
  801863:	50                   	push   %eax
  801864:	ff d2                	call   *%edx
  801866:	83 c4 10             	add    $0x10,%esp
}
  801869:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80186c:	c9                   	leave  
  80186d:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80186e:	a1 b4 40 80 00       	mov    0x8040b4,%eax
  801873:	8b 40 48             	mov    0x48(%eax),%eax
  801876:	83 ec 04             	sub    $0x4,%esp
  801879:	53                   	push   %ebx
  80187a:	50                   	push   %eax
  80187b:	68 2d 2e 80 00       	push   $0x802e2d
  801880:	e8 95 ee ff ff       	call   80071a <cprintf>
		return -E_INVAL;
  801885:	83 c4 10             	add    $0x10,%esp
  801888:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80188d:	eb da                	jmp    801869 <write+0x55>
		return -E_NOT_SUPP;
  80188f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801894:	eb d3                	jmp    801869 <write+0x55>

00801896 <seek>:

int
seek(int fdnum, off_t offset)
{
  801896:	55                   	push   %ebp
  801897:	89 e5                	mov    %esp,%ebp
  801899:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80189c:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80189f:	50                   	push   %eax
  8018a0:	ff 75 08             	pushl  0x8(%ebp)
  8018a3:	e8 2d fc ff ff       	call   8014d5 <fd_lookup>
  8018a8:	83 c4 08             	add    $0x8,%esp
  8018ab:	85 c0                	test   %eax,%eax
  8018ad:	78 0e                	js     8018bd <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8018af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018b5:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8018b8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018bd:	c9                   	leave  
  8018be:	c3                   	ret    

008018bf <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8018bf:	55                   	push   %ebp
  8018c0:	89 e5                	mov    %esp,%ebp
  8018c2:	53                   	push   %ebx
  8018c3:	83 ec 14             	sub    $0x14,%esp
  8018c6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018c9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018cc:	50                   	push   %eax
  8018cd:	53                   	push   %ebx
  8018ce:	e8 02 fc ff ff       	call   8014d5 <fd_lookup>
  8018d3:	83 c4 08             	add    $0x8,%esp
  8018d6:	85 c0                	test   %eax,%eax
  8018d8:	78 37                	js     801911 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018da:	83 ec 08             	sub    $0x8,%esp
  8018dd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018e0:	50                   	push   %eax
  8018e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018e4:	ff 30                	pushl  (%eax)
  8018e6:	e8 40 fc ff ff       	call   80152b <dev_lookup>
  8018eb:	83 c4 10             	add    $0x10,%esp
  8018ee:	85 c0                	test   %eax,%eax
  8018f0:	78 1f                	js     801911 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8018f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018f5:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8018f9:	74 1b                	je     801916 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8018fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018fe:	8b 52 18             	mov    0x18(%edx),%edx
  801901:	85 d2                	test   %edx,%edx
  801903:	74 32                	je     801937 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801905:	83 ec 08             	sub    $0x8,%esp
  801908:	ff 75 0c             	pushl  0xc(%ebp)
  80190b:	50                   	push   %eax
  80190c:	ff d2                	call   *%edx
  80190e:	83 c4 10             	add    $0x10,%esp
}
  801911:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801914:	c9                   	leave  
  801915:	c3                   	ret    
			thisenv->env_id, fdnum);
  801916:	a1 b4 40 80 00       	mov    0x8040b4,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80191b:	8b 40 48             	mov    0x48(%eax),%eax
  80191e:	83 ec 04             	sub    $0x4,%esp
  801921:	53                   	push   %ebx
  801922:	50                   	push   %eax
  801923:	68 f0 2d 80 00       	push   $0x802df0
  801928:	e8 ed ed ff ff       	call   80071a <cprintf>
		return -E_INVAL;
  80192d:	83 c4 10             	add    $0x10,%esp
  801930:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801935:	eb da                	jmp    801911 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801937:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80193c:	eb d3                	jmp    801911 <ftruncate+0x52>

0080193e <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80193e:	55                   	push   %ebp
  80193f:	89 e5                	mov    %esp,%ebp
  801941:	53                   	push   %ebx
  801942:	83 ec 14             	sub    $0x14,%esp
  801945:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801948:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80194b:	50                   	push   %eax
  80194c:	ff 75 08             	pushl  0x8(%ebp)
  80194f:	e8 81 fb ff ff       	call   8014d5 <fd_lookup>
  801954:	83 c4 08             	add    $0x8,%esp
  801957:	85 c0                	test   %eax,%eax
  801959:	78 4b                	js     8019a6 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80195b:	83 ec 08             	sub    $0x8,%esp
  80195e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801961:	50                   	push   %eax
  801962:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801965:	ff 30                	pushl  (%eax)
  801967:	e8 bf fb ff ff       	call   80152b <dev_lookup>
  80196c:	83 c4 10             	add    $0x10,%esp
  80196f:	85 c0                	test   %eax,%eax
  801971:	78 33                	js     8019a6 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801973:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801976:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80197a:	74 2f                	je     8019ab <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80197c:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80197f:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801986:	00 00 00 
	stat->st_isdir = 0;
  801989:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801990:	00 00 00 
	stat->st_dev = dev;
  801993:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801999:	83 ec 08             	sub    $0x8,%esp
  80199c:	53                   	push   %ebx
  80199d:	ff 75 f0             	pushl  -0x10(%ebp)
  8019a0:	ff 50 14             	call   *0x14(%eax)
  8019a3:	83 c4 10             	add    $0x10,%esp
}
  8019a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019a9:	c9                   	leave  
  8019aa:	c3                   	ret    
		return -E_NOT_SUPP;
  8019ab:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8019b0:	eb f4                	jmp    8019a6 <fstat+0x68>

008019b2 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8019b2:	55                   	push   %ebp
  8019b3:	89 e5                	mov    %esp,%ebp
  8019b5:	56                   	push   %esi
  8019b6:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8019b7:	83 ec 08             	sub    $0x8,%esp
  8019ba:	6a 00                	push   $0x0
  8019bc:	ff 75 08             	pushl  0x8(%ebp)
  8019bf:	e8 26 02 00 00       	call   801bea <open>
  8019c4:	89 c3                	mov    %eax,%ebx
  8019c6:	83 c4 10             	add    $0x10,%esp
  8019c9:	85 c0                	test   %eax,%eax
  8019cb:	78 1b                	js     8019e8 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8019cd:	83 ec 08             	sub    $0x8,%esp
  8019d0:	ff 75 0c             	pushl  0xc(%ebp)
  8019d3:	50                   	push   %eax
  8019d4:	e8 65 ff ff ff       	call   80193e <fstat>
  8019d9:	89 c6                	mov    %eax,%esi
	close(fd);
  8019db:	89 1c 24             	mov    %ebx,(%esp)
  8019de:	e8 27 fc ff ff       	call   80160a <close>
	return r;
  8019e3:	83 c4 10             	add    $0x10,%esp
  8019e6:	89 f3                	mov    %esi,%ebx
}
  8019e8:	89 d8                	mov    %ebx,%eax
  8019ea:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019ed:	5b                   	pop    %ebx
  8019ee:	5e                   	pop    %esi
  8019ef:	5d                   	pop    %ebp
  8019f0:	c3                   	ret    

008019f1 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8019f1:	55                   	push   %ebp
  8019f2:	89 e5                	mov    %esp,%ebp
  8019f4:	56                   	push   %esi
  8019f5:	53                   	push   %ebx
  8019f6:	89 c6                	mov    %eax,%esi
  8019f8:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8019fa:	83 3d ac 40 80 00 00 	cmpl   $0x0,0x8040ac
  801a01:	74 27                	je     801a2a <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801a03:	6a 07                	push   $0x7
  801a05:	68 00 50 80 00       	push   $0x805000
  801a0a:	56                   	push   %esi
  801a0b:	ff 35 ac 40 80 00    	pushl  0x8040ac
  801a11:	e8 11 0c 00 00       	call   802627 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801a16:	83 c4 0c             	add    $0xc,%esp
  801a19:	6a 00                	push   $0x0
  801a1b:	53                   	push   %ebx
  801a1c:	6a 00                	push   $0x0
  801a1e:	e8 9b 0b 00 00       	call   8025be <ipc_recv>
}
  801a23:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a26:	5b                   	pop    %ebx
  801a27:	5e                   	pop    %esi
  801a28:	5d                   	pop    %ebp
  801a29:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801a2a:	83 ec 0c             	sub    $0xc,%esp
  801a2d:	6a 01                	push   $0x1
  801a2f:	e8 4c 0c 00 00       	call   802680 <ipc_find_env>
  801a34:	a3 ac 40 80 00       	mov    %eax,0x8040ac
  801a39:	83 c4 10             	add    $0x10,%esp
  801a3c:	eb c5                	jmp    801a03 <fsipc+0x12>

00801a3e <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801a3e:	55                   	push   %ebp
  801a3f:	89 e5                	mov    %esp,%ebp
  801a41:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801a44:	8b 45 08             	mov    0x8(%ebp),%eax
  801a47:	8b 40 0c             	mov    0xc(%eax),%eax
  801a4a:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801a4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a52:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801a57:	ba 00 00 00 00       	mov    $0x0,%edx
  801a5c:	b8 02 00 00 00       	mov    $0x2,%eax
  801a61:	e8 8b ff ff ff       	call   8019f1 <fsipc>
}
  801a66:	c9                   	leave  
  801a67:	c3                   	ret    

00801a68 <devfile_flush>:
{
  801a68:	55                   	push   %ebp
  801a69:	89 e5                	mov    %esp,%ebp
  801a6b:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801a6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a71:	8b 40 0c             	mov    0xc(%eax),%eax
  801a74:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801a79:	ba 00 00 00 00       	mov    $0x0,%edx
  801a7e:	b8 06 00 00 00       	mov    $0x6,%eax
  801a83:	e8 69 ff ff ff       	call   8019f1 <fsipc>
}
  801a88:	c9                   	leave  
  801a89:	c3                   	ret    

00801a8a <devfile_stat>:
{
  801a8a:	55                   	push   %ebp
  801a8b:	89 e5                	mov    %esp,%ebp
  801a8d:	53                   	push   %ebx
  801a8e:	83 ec 04             	sub    $0x4,%esp
  801a91:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801a94:	8b 45 08             	mov    0x8(%ebp),%eax
  801a97:	8b 40 0c             	mov    0xc(%eax),%eax
  801a9a:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801a9f:	ba 00 00 00 00       	mov    $0x0,%edx
  801aa4:	b8 05 00 00 00       	mov    $0x5,%eax
  801aa9:	e8 43 ff ff ff       	call   8019f1 <fsipc>
  801aae:	85 c0                	test   %eax,%eax
  801ab0:	78 2c                	js     801ade <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801ab2:	83 ec 08             	sub    $0x8,%esp
  801ab5:	68 00 50 80 00       	push   $0x805000
  801aba:	53                   	push   %ebx
  801abb:	e8 f7 f2 ff ff       	call   800db7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801ac0:	a1 80 50 80 00       	mov    0x805080,%eax
  801ac5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801acb:	a1 84 50 80 00       	mov    0x805084,%eax
  801ad0:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801ad6:	83 c4 10             	add    $0x10,%esp
  801ad9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ade:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ae1:	c9                   	leave  
  801ae2:	c3                   	ret    

00801ae3 <devfile_write>:
{
  801ae3:	55                   	push   %ebp
  801ae4:	89 e5                	mov    %esp,%ebp
  801ae6:	53                   	push   %ebx
  801ae7:	83 ec 04             	sub    $0x4,%esp
  801aea:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801aed:	8b 45 08             	mov    0x8(%ebp),%eax
  801af0:	8b 40 0c             	mov    0xc(%eax),%eax
  801af3:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  801af8:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  801afe:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  801b04:	77 30                	ja     801b36 <devfile_write+0x53>
	memmove(fsipcbuf.write.req_buf, buf, n);
  801b06:	83 ec 04             	sub    $0x4,%esp
  801b09:	53                   	push   %ebx
  801b0a:	ff 75 0c             	pushl  0xc(%ebp)
  801b0d:	68 08 50 80 00       	push   $0x805008
  801b12:	e8 2e f4 ff ff       	call   800f45 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801b17:	ba 00 00 00 00       	mov    $0x0,%edx
  801b1c:	b8 04 00 00 00       	mov    $0x4,%eax
  801b21:	e8 cb fe ff ff       	call   8019f1 <fsipc>
  801b26:	83 c4 10             	add    $0x10,%esp
  801b29:	85 c0                	test   %eax,%eax
  801b2b:	78 04                	js     801b31 <devfile_write+0x4e>
	assert(r <= n);
  801b2d:	39 d8                	cmp    %ebx,%eax
  801b2f:	77 1e                	ja     801b4f <devfile_write+0x6c>
}
  801b31:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b34:	c9                   	leave  
  801b35:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  801b36:	68 60 2e 80 00       	push   $0x802e60
  801b3b:	68 90 2e 80 00       	push   $0x802e90
  801b40:	68 94 00 00 00       	push   $0x94
  801b45:	68 a5 2e 80 00       	push   $0x802ea5
  801b4a:	e8 f0 ea ff ff       	call   80063f <_panic>
	assert(r <= n);
  801b4f:	68 b0 2e 80 00       	push   $0x802eb0
  801b54:	68 90 2e 80 00       	push   $0x802e90
  801b59:	68 98 00 00 00       	push   $0x98
  801b5e:	68 a5 2e 80 00       	push   $0x802ea5
  801b63:	e8 d7 ea ff ff       	call   80063f <_panic>

00801b68 <devfile_read>:
{
  801b68:	55                   	push   %ebp
  801b69:	89 e5                	mov    %esp,%ebp
  801b6b:	56                   	push   %esi
  801b6c:	53                   	push   %ebx
  801b6d:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801b70:	8b 45 08             	mov    0x8(%ebp),%eax
  801b73:	8b 40 0c             	mov    0xc(%eax),%eax
  801b76:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801b7b:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801b81:	ba 00 00 00 00       	mov    $0x0,%edx
  801b86:	b8 03 00 00 00       	mov    $0x3,%eax
  801b8b:	e8 61 fe ff ff       	call   8019f1 <fsipc>
  801b90:	89 c3                	mov    %eax,%ebx
  801b92:	85 c0                	test   %eax,%eax
  801b94:	78 1f                	js     801bb5 <devfile_read+0x4d>
	assert(r <= n);
  801b96:	39 f0                	cmp    %esi,%eax
  801b98:	77 24                	ja     801bbe <devfile_read+0x56>
	assert(r <= PGSIZE);
  801b9a:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801b9f:	7f 33                	jg     801bd4 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801ba1:	83 ec 04             	sub    $0x4,%esp
  801ba4:	50                   	push   %eax
  801ba5:	68 00 50 80 00       	push   $0x805000
  801baa:	ff 75 0c             	pushl  0xc(%ebp)
  801bad:	e8 93 f3 ff ff       	call   800f45 <memmove>
	return r;
  801bb2:	83 c4 10             	add    $0x10,%esp
}
  801bb5:	89 d8                	mov    %ebx,%eax
  801bb7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bba:	5b                   	pop    %ebx
  801bbb:	5e                   	pop    %esi
  801bbc:	5d                   	pop    %ebp
  801bbd:	c3                   	ret    
	assert(r <= n);
  801bbe:	68 b0 2e 80 00       	push   $0x802eb0
  801bc3:	68 90 2e 80 00       	push   $0x802e90
  801bc8:	6a 7c                	push   $0x7c
  801bca:	68 a5 2e 80 00       	push   $0x802ea5
  801bcf:	e8 6b ea ff ff       	call   80063f <_panic>
	assert(r <= PGSIZE);
  801bd4:	68 b7 2e 80 00       	push   $0x802eb7
  801bd9:	68 90 2e 80 00       	push   $0x802e90
  801bde:	6a 7d                	push   $0x7d
  801be0:	68 a5 2e 80 00       	push   $0x802ea5
  801be5:	e8 55 ea ff ff       	call   80063f <_panic>

00801bea <open>:
{
  801bea:	55                   	push   %ebp
  801beb:	89 e5                	mov    %esp,%ebp
  801bed:	56                   	push   %esi
  801bee:	53                   	push   %ebx
  801bef:	83 ec 1c             	sub    $0x1c,%esp
  801bf2:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801bf5:	56                   	push   %esi
  801bf6:	e8 85 f1 ff ff       	call   800d80 <strlen>
  801bfb:	83 c4 10             	add    $0x10,%esp
  801bfe:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801c03:	7f 6c                	jg     801c71 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801c05:	83 ec 0c             	sub    $0xc,%esp
  801c08:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c0b:	50                   	push   %eax
  801c0c:	e8 75 f8 ff ff       	call   801486 <fd_alloc>
  801c11:	89 c3                	mov    %eax,%ebx
  801c13:	83 c4 10             	add    $0x10,%esp
  801c16:	85 c0                	test   %eax,%eax
  801c18:	78 3c                	js     801c56 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801c1a:	83 ec 08             	sub    $0x8,%esp
  801c1d:	56                   	push   %esi
  801c1e:	68 00 50 80 00       	push   $0x805000
  801c23:	e8 8f f1 ff ff       	call   800db7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801c28:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c2b:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801c30:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c33:	b8 01 00 00 00       	mov    $0x1,%eax
  801c38:	e8 b4 fd ff ff       	call   8019f1 <fsipc>
  801c3d:	89 c3                	mov    %eax,%ebx
  801c3f:	83 c4 10             	add    $0x10,%esp
  801c42:	85 c0                	test   %eax,%eax
  801c44:	78 19                	js     801c5f <open+0x75>
	return fd2num(fd);
  801c46:	83 ec 0c             	sub    $0xc,%esp
  801c49:	ff 75 f4             	pushl  -0xc(%ebp)
  801c4c:	e8 0e f8 ff ff       	call   80145f <fd2num>
  801c51:	89 c3                	mov    %eax,%ebx
  801c53:	83 c4 10             	add    $0x10,%esp
}
  801c56:	89 d8                	mov    %ebx,%eax
  801c58:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c5b:	5b                   	pop    %ebx
  801c5c:	5e                   	pop    %esi
  801c5d:	5d                   	pop    %ebp
  801c5e:	c3                   	ret    
		fd_close(fd, 0);
  801c5f:	83 ec 08             	sub    $0x8,%esp
  801c62:	6a 00                	push   $0x0
  801c64:	ff 75 f4             	pushl  -0xc(%ebp)
  801c67:	e8 15 f9 ff ff       	call   801581 <fd_close>
		return r;
  801c6c:	83 c4 10             	add    $0x10,%esp
  801c6f:	eb e5                	jmp    801c56 <open+0x6c>
		return -E_BAD_PATH;
  801c71:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801c76:	eb de                	jmp    801c56 <open+0x6c>

00801c78 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801c78:	55                   	push   %ebp
  801c79:	89 e5                	mov    %esp,%ebp
  801c7b:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801c7e:	ba 00 00 00 00       	mov    $0x0,%edx
  801c83:	b8 08 00 00 00       	mov    $0x8,%eax
  801c88:	e8 64 fd ff ff       	call   8019f1 <fsipc>
}
  801c8d:	c9                   	leave  
  801c8e:	c3                   	ret    

00801c8f <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801c8f:	55                   	push   %ebp
  801c90:	89 e5                	mov    %esp,%ebp
  801c92:	56                   	push   %esi
  801c93:	53                   	push   %ebx
  801c94:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801c97:	83 ec 0c             	sub    $0xc,%esp
  801c9a:	ff 75 08             	pushl  0x8(%ebp)
  801c9d:	e8 cd f7 ff ff       	call   80146f <fd2data>
  801ca2:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801ca4:	83 c4 08             	add    $0x8,%esp
  801ca7:	68 c3 2e 80 00       	push   $0x802ec3
  801cac:	53                   	push   %ebx
  801cad:	e8 05 f1 ff ff       	call   800db7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801cb2:	8b 46 04             	mov    0x4(%esi),%eax
  801cb5:	2b 06                	sub    (%esi),%eax
  801cb7:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801cbd:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801cc4:	00 00 00 
	stat->st_dev = &devpipe;
  801cc7:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801cce:	30 80 00 
	return 0;
}
  801cd1:	b8 00 00 00 00       	mov    $0x0,%eax
  801cd6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cd9:	5b                   	pop    %ebx
  801cda:	5e                   	pop    %esi
  801cdb:	5d                   	pop    %ebp
  801cdc:	c3                   	ret    

00801cdd <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801cdd:	55                   	push   %ebp
  801cde:	89 e5                	mov    %esp,%ebp
  801ce0:	53                   	push   %ebx
  801ce1:	83 ec 0c             	sub    $0xc,%esp
  801ce4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801ce7:	53                   	push   %ebx
  801ce8:	6a 00                	push   $0x0
  801cea:	e8 46 f5 ff ff       	call   801235 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801cef:	89 1c 24             	mov    %ebx,(%esp)
  801cf2:	e8 78 f7 ff ff       	call   80146f <fd2data>
  801cf7:	83 c4 08             	add    $0x8,%esp
  801cfa:	50                   	push   %eax
  801cfb:	6a 00                	push   $0x0
  801cfd:	e8 33 f5 ff ff       	call   801235 <sys_page_unmap>
}
  801d02:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d05:	c9                   	leave  
  801d06:	c3                   	ret    

00801d07 <_pipeisclosed>:
{
  801d07:	55                   	push   %ebp
  801d08:	89 e5                	mov    %esp,%ebp
  801d0a:	57                   	push   %edi
  801d0b:	56                   	push   %esi
  801d0c:	53                   	push   %ebx
  801d0d:	83 ec 1c             	sub    $0x1c,%esp
  801d10:	89 c7                	mov    %eax,%edi
  801d12:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801d14:	a1 b4 40 80 00       	mov    0x8040b4,%eax
  801d19:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801d1c:	83 ec 0c             	sub    $0xc,%esp
  801d1f:	57                   	push   %edi
  801d20:	e8 94 09 00 00       	call   8026b9 <pageref>
  801d25:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d28:	89 34 24             	mov    %esi,(%esp)
  801d2b:	e8 89 09 00 00       	call   8026b9 <pageref>
		nn = thisenv->env_runs;
  801d30:	8b 15 b4 40 80 00    	mov    0x8040b4,%edx
  801d36:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801d39:	83 c4 10             	add    $0x10,%esp
  801d3c:	39 cb                	cmp    %ecx,%ebx
  801d3e:	74 1b                	je     801d5b <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801d40:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d43:	75 cf                	jne    801d14 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801d45:	8b 42 58             	mov    0x58(%edx),%eax
  801d48:	6a 01                	push   $0x1
  801d4a:	50                   	push   %eax
  801d4b:	53                   	push   %ebx
  801d4c:	68 ca 2e 80 00       	push   $0x802eca
  801d51:	e8 c4 e9 ff ff       	call   80071a <cprintf>
  801d56:	83 c4 10             	add    $0x10,%esp
  801d59:	eb b9                	jmp    801d14 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801d5b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d5e:	0f 94 c0             	sete   %al
  801d61:	0f b6 c0             	movzbl %al,%eax
}
  801d64:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d67:	5b                   	pop    %ebx
  801d68:	5e                   	pop    %esi
  801d69:	5f                   	pop    %edi
  801d6a:	5d                   	pop    %ebp
  801d6b:	c3                   	ret    

00801d6c <devpipe_write>:
{
  801d6c:	55                   	push   %ebp
  801d6d:	89 e5                	mov    %esp,%ebp
  801d6f:	57                   	push   %edi
  801d70:	56                   	push   %esi
  801d71:	53                   	push   %ebx
  801d72:	83 ec 28             	sub    $0x28,%esp
  801d75:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801d78:	56                   	push   %esi
  801d79:	e8 f1 f6 ff ff       	call   80146f <fd2data>
  801d7e:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d80:	83 c4 10             	add    $0x10,%esp
  801d83:	bf 00 00 00 00       	mov    $0x0,%edi
  801d88:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801d8b:	74 4f                	je     801ddc <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801d8d:	8b 43 04             	mov    0x4(%ebx),%eax
  801d90:	8b 0b                	mov    (%ebx),%ecx
  801d92:	8d 51 20             	lea    0x20(%ecx),%edx
  801d95:	39 d0                	cmp    %edx,%eax
  801d97:	72 14                	jb     801dad <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801d99:	89 da                	mov    %ebx,%edx
  801d9b:	89 f0                	mov    %esi,%eax
  801d9d:	e8 65 ff ff ff       	call   801d07 <_pipeisclosed>
  801da2:	85 c0                	test   %eax,%eax
  801da4:	75 3a                	jne    801de0 <devpipe_write+0x74>
			sys_yield();
  801da6:	e8 e6 f3 ff ff       	call   801191 <sys_yield>
  801dab:	eb e0                	jmp    801d8d <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801dad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801db0:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801db4:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801db7:	89 c2                	mov    %eax,%edx
  801db9:	c1 fa 1f             	sar    $0x1f,%edx
  801dbc:	89 d1                	mov    %edx,%ecx
  801dbe:	c1 e9 1b             	shr    $0x1b,%ecx
  801dc1:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801dc4:	83 e2 1f             	and    $0x1f,%edx
  801dc7:	29 ca                	sub    %ecx,%edx
  801dc9:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801dcd:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801dd1:	83 c0 01             	add    $0x1,%eax
  801dd4:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801dd7:	83 c7 01             	add    $0x1,%edi
  801dda:	eb ac                	jmp    801d88 <devpipe_write+0x1c>
	return i;
  801ddc:	89 f8                	mov    %edi,%eax
  801dde:	eb 05                	jmp    801de5 <devpipe_write+0x79>
				return 0;
  801de0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801de5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801de8:	5b                   	pop    %ebx
  801de9:	5e                   	pop    %esi
  801dea:	5f                   	pop    %edi
  801deb:	5d                   	pop    %ebp
  801dec:	c3                   	ret    

00801ded <devpipe_read>:
{
  801ded:	55                   	push   %ebp
  801dee:	89 e5                	mov    %esp,%ebp
  801df0:	57                   	push   %edi
  801df1:	56                   	push   %esi
  801df2:	53                   	push   %ebx
  801df3:	83 ec 18             	sub    $0x18,%esp
  801df6:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801df9:	57                   	push   %edi
  801dfa:	e8 70 f6 ff ff       	call   80146f <fd2data>
  801dff:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e01:	83 c4 10             	add    $0x10,%esp
  801e04:	be 00 00 00 00       	mov    $0x0,%esi
  801e09:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e0c:	74 47                	je     801e55 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801e0e:	8b 03                	mov    (%ebx),%eax
  801e10:	3b 43 04             	cmp    0x4(%ebx),%eax
  801e13:	75 22                	jne    801e37 <devpipe_read+0x4a>
			if (i > 0)
  801e15:	85 f6                	test   %esi,%esi
  801e17:	75 14                	jne    801e2d <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801e19:	89 da                	mov    %ebx,%edx
  801e1b:	89 f8                	mov    %edi,%eax
  801e1d:	e8 e5 fe ff ff       	call   801d07 <_pipeisclosed>
  801e22:	85 c0                	test   %eax,%eax
  801e24:	75 33                	jne    801e59 <devpipe_read+0x6c>
			sys_yield();
  801e26:	e8 66 f3 ff ff       	call   801191 <sys_yield>
  801e2b:	eb e1                	jmp    801e0e <devpipe_read+0x21>
				return i;
  801e2d:	89 f0                	mov    %esi,%eax
}
  801e2f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e32:	5b                   	pop    %ebx
  801e33:	5e                   	pop    %esi
  801e34:	5f                   	pop    %edi
  801e35:	5d                   	pop    %ebp
  801e36:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801e37:	99                   	cltd   
  801e38:	c1 ea 1b             	shr    $0x1b,%edx
  801e3b:	01 d0                	add    %edx,%eax
  801e3d:	83 e0 1f             	and    $0x1f,%eax
  801e40:	29 d0                	sub    %edx,%eax
  801e42:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801e47:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e4a:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801e4d:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801e50:	83 c6 01             	add    $0x1,%esi
  801e53:	eb b4                	jmp    801e09 <devpipe_read+0x1c>
	return i;
  801e55:	89 f0                	mov    %esi,%eax
  801e57:	eb d6                	jmp    801e2f <devpipe_read+0x42>
				return 0;
  801e59:	b8 00 00 00 00       	mov    $0x0,%eax
  801e5e:	eb cf                	jmp    801e2f <devpipe_read+0x42>

00801e60 <pipe>:
{
  801e60:	55                   	push   %ebp
  801e61:	89 e5                	mov    %esp,%ebp
  801e63:	56                   	push   %esi
  801e64:	53                   	push   %ebx
  801e65:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801e68:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e6b:	50                   	push   %eax
  801e6c:	e8 15 f6 ff ff       	call   801486 <fd_alloc>
  801e71:	89 c3                	mov    %eax,%ebx
  801e73:	83 c4 10             	add    $0x10,%esp
  801e76:	85 c0                	test   %eax,%eax
  801e78:	78 5b                	js     801ed5 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e7a:	83 ec 04             	sub    $0x4,%esp
  801e7d:	68 07 04 00 00       	push   $0x407
  801e82:	ff 75 f4             	pushl  -0xc(%ebp)
  801e85:	6a 00                	push   $0x0
  801e87:	e8 24 f3 ff ff       	call   8011b0 <sys_page_alloc>
  801e8c:	89 c3                	mov    %eax,%ebx
  801e8e:	83 c4 10             	add    $0x10,%esp
  801e91:	85 c0                	test   %eax,%eax
  801e93:	78 40                	js     801ed5 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  801e95:	83 ec 0c             	sub    $0xc,%esp
  801e98:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801e9b:	50                   	push   %eax
  801e9c:	e8 e5 f5 ff ff       	call   801486 <fd_alloc>
  801ea1:	89 c3                	mov    %eax,%ebx
  801ea3:	83 c4 10             	add    $0x10,%esp
  801ea6:	85 c0                	test   %eax,%eax
  801ea8:	78 1b                	js     801ec5 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801eaa:	83 ec 04             	sub    $0x4,%esp
  801ead:	68 07 04 00 00       	push   $0x407
  801eb2:	ff 75 f0             	pushl  -0x10(%ebp)
  801eb5:	6a 00                	push   $0x0
  801eb7:	e8 f4 f2 ff ff       	call   8011b0 <sys_page_alloc>
  801ebc:	89 c3                	mov    %eax,%ebx
  801ebe:	83 c4 10             	add    $0x10,%esp
  801ec1:	85 c0                	test   %eax,%eax
  801ec3:	79 19                	jns    801ede <pipe+0x7e>
	sys_page_unmap(0, fd0);
  801ec5:	83 ec 08             	sub    $0x8,%esp
  801ec8:	ff 75 f4             	pushl  -0xc(%ebp)
  801ecb:	6a 00                	push   $0x0
  801ecd:	e8 63 f3 ff ff       	call   801235 <sys_page_unmap>
  801ed2:	83 c4 10             	add    $0x10,%esp
}
  801ed5:	89 d8                	mov    %ebx,%eax
  801ed7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801eda:	5b                   	pop    %ebx
  801edb:	5e                   	pop    %esi
  801edc:	5d                   	pop    %ebp
  801edd:	c3                   	ret    
	va = fd2data(fd0);
  801ede:	83 ec 0c             	sub    $0xc,%esp
  801ee1:	ff 75 f4             	pushl  -0xc(%ebp)
  801ee4:	e8 86 f5 ff ff       	call   80146f <fd2data>
  801ee9:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801eeb:	83 c4 0c             	add    $0xc,%esp
  801eee:	68 07 04 00 00       	push   $0x407
  801ef3:	50                   	push   %eax
  801ef4:	6a 00                	push   $0x0
  801ef6:	e8 b5 f2 ff ff       	call   8011b0 <sys_page_alloc>
  801efb:	89 c3                	mov    %eax,%ebx
  801efd:	83 c4 10             	add    $0x10,%esp
  801f00:	85 c0                	test   %eax,%eax
  801f02:	0f 88 8c 00 00 00    	js     801f94 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f08:	83 ec 0c             	sub    $0xc,%esp
  801f0b:	ff 75 f0             	pushl  -0x10(%ebp)
  801f0e:	e8 5c f5 ff ff       	call   80146f <fd2data>
  801f13:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801f1a:	50                   	push   %eax
  801f1b:	6a 00                	push   $0x0
  801f1d:	56                   	push   %esi
  801f1e:	6a 00                	push   $0x0
  801f20:	e8 ce f2 ff ff       	call   8011f3 <sys_page_map>
  801f25:	89 c3                	mov    %eax,%ebx
  801f27:	83 c4 20             	add    $0x20,%esp
  801f2a:	85 c0                	test   %eax,%eax
  801f2c:	78 58                	js     801f86 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801f2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f31:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801f37:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801f39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f3c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801f43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f46:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801f4c:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801f4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f51:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801f58:	83 ec 0c             	sub    $0xc,%esp
  801f5b:	ff 75 f4             	pushl  -0xc(%ebp)
  801f5e:	e8 fc f4 ff ff       	call   80145f <fd2num>
  801f63:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f66:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801f68:	83 c4 04             	add    $0x4,%esp
  801f6b:	ff 75 f0             	pushl  -0x10(%ebp)
  801f6e:	e8 ec f4 ff ff       	call   80145f <fd2num>
  801f73:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f76:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801f79:	83 c4 10             	add    $0x10,%esp
  801f7c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f81:	e9 4f ff ff ff       	jmp    801ed5 <pipe+0x75>
	sys_page_unmap(0, va);
  801f86:	83 ec 08             	sub    $0x8,%esp
  801f89:	56                   	push   %esi
  801f8a:	6a 00                	push   $0x0
  801f8c:	e8 a4 f2 ff ff       	call   801235 <sys_page_unmap>
  801f91:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801f94:	83 ec 08             	sub    $0x8,%esp
  801f97:	ff 75 f0             	pushl  -0x10(%ebp)
  801f9a:	6a 00                	push   $0x0
  801f9c:	e8 94 f2 ff ff       	call   801235 <sys_page_unmap>
  801fa1:	83 c4 10             	add    $0x10,%esp
  801fa4:	e9 1c ff ff ff       	jmp    801ec5 <pipe+0x65>

00801fa9 <pipeisclosed>:
{
  801fa9:	55                   	push   %ebp
  801faa:	89 e5                	mov    %esp,%ebp
  801fac:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801faf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fb2:	50                   	push   %eax
  801fb3:	ff 75 08             	pushl  0x8(%ebp)
  801fb6:	e8 1a f5 ff ff       	call   8014d5 <fd_lookup>
  801fbb:	83 c4 10             	add    $0x10,%esp
  801fbe:	85 c0                	test   %eax,%eax
  801fc0:	78 18                	js     801fda <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801fc2:	83 ec 0c             	sub    $0xc,%esp
  801fc5:	ff 75 f4             	pushl  -0xc(%ebp)
  801fc8:	e8 a2 f4 ff ff       	call   80146f <fd2data>
	return _pipeisclosed(fd, p);
  801fcd:	89 c2                	mov    %eax,%edx
  801fcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd2:	e8 30 fd ff ff       	call   801d07 <_pipeisclosed>
  801fd7:	83 c4 10             	add    $0x10,%esp
}
  801fda:	c9                   	leave  
  801fdb:	c3                   	ret    

00801fdc <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801fdc:	55                   	push   %ebp
  801fdd:	89 e5                	mov    %esp,%ebp
  801fdf:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801fe2:	68 e2 2e 80 00       	push   $0x802ee2
  801fe7:	ff 75 0c             	pushl  0xc(%ebp)
  801fea:	e8 c8 ed ff ff       	call   800db7 <strcpy>
	return 0;
}
  801fef:	b8 00 00 00 00       	mov    $0x0,%eax
  801ff4:	c9                   	leave  
  801ff5:	c3                   	ret    

00801ff6 <devsock_close>:
{
  801ff6:	55                   	push   %ebp
  801ff7:	89 e5                	mov    %esp,%ebp
  801ff9:	53                   	push   %ebx
  801ffa:	83 ec 10             	sub    $0x10,%esp
  801ffd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  802000:	53                   	push   %ebx
  802001:	e8 b3 06 00 00       	call   8026b9 <pageref>
  802006:	83 c4 10             	add    $0x10,%esp
		return 0;
  802009:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  80200e:	83 f8 01             	cmp    $0x1,%eax
  802011:	74 07                	je     80201a <devsock_close+0x24>
}
  802013:	89 d0                	mov    %edx,%eax
  802015:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802018:	c9                   	leave  
  802019:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  80201a:	83 ec 0c             	sub    $0xc,%esp
  80201d:	ff 73 0c             	pushl  0xc(%ebx)
  802020:	e8 b7 02 00 00       	call   8022dc <nsipc_close>
  802025:	89 c2                	mov    %eax,%edx
  802027:	83 c4 10             	add    $0x10,%esp
  80202a:	eb e7                	jmp    802013 <devsock_close+0x1d>

0080202c <devsock_write>:
{
  80202c:	55                   	push   %ebp
  80202d:	89 e5                	mov    %esp,%ebp
  80202f:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802032:	6a 00                	push   $0x0
  802034:	ff 75 10             	pushl  0x10(%ebp)
  802037:	ff 75 0c             	pushl  0xc(%ebp)
  80203a:	8b 45 08             	mov    0x8(%ebp),%eax
  80203d:	ff 70 0c             	pushl  0xc(%eax)
  802040:	e8 74 03 00 00       	call   8023b9 <nsipc_send>
}
  802045:	c9                   	leave  
  802046:	c3                   	ret    

00802047 <devsock_read>:
{
  802047:	55                   	push   %ebp
  802048:	89 e5                	mov    %esp,%ebp
  80204a:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80204d:	6a 00                	push   $0x0
  80204f:	ff 75 10             	pushl  0x10(%ebp)
  802052:	ff 75 0c             	pushl  0xc(%ebp)
  802055:	8b 45 08             	mov    0x8(%ebp),%eax
  802058:	ff 70 0c             	pushl  0xc(%eax)
  80205b:	e8 ed 02 00 00       	call   80234d <nsipc_recv>
}
  802060:	c9                   	leave  
  802061:	c3                   	ret    

00802062 <fd2sockid>:
{
  802062:	55                   	push   %ebp
  802063:	89 e5                	mov    %esp,%ebp
  802065:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  802068:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80206b:	52                   	push   %edx
  80206c:	50                   	push   %eax
  80206d:	e8 63 f4 ff ff       	call   8014d5 <fd_lookup>
  802072:	83 c4 10             	add    $0x10,%esp
  802075:	85 c0                	test   %eax,%eax
  802077:	78 10                	js     802089 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  802079:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80207c:	8b 0d 3c 30 80 00    	mov    0x80303c,%ecx
  802082:	39 08                	cmp    %ecx,(%eax)
  802084:	75 05                	jne    80208b <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  802086:	8b 40 0c             	mov    0xc(%eax),%eax
}
  802089:	c9                   	leave  
  80208a:	c3                   	ret    
		return -E_NOT_SUPP;
  80208b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802090:	eb f7                	jmp    802089 <fd2sockid+0x27>

00802092 <alloc_sockfd>:
{
  802092:	55                   	push   %ebp
  802093:	89 e5                	mov    %esp,%ebp
  802095:	56                   	push   %esi
  802096:	53                   	push   %ebx
  802097:	83 ec 1c             	sub    $0x1c,%esp
  80209a:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  80209c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80209f:	50                   	push   %eax
  8020a0:	e8 e1 f3 ff ff       	call   801486 <fd_alloc>
  8020a5:	89 c3                	mov    %eax,%ebx
  8020a7:	83 c4 10             	add    $0x10,%esp
  8020aa:	85 c0                	test   %eax,%eax
  8020ac:	78 43                	js     8020f1 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8020ae:	83 ec 04             	sub    $0x4,%esp
  8020b1:	68 07 04 00 00       	push   $0x407
  8020b6:	ff 75 f4             	pushl  -0xc(%ebp)
  8020b9:	6a 00                	push   $0x0
  8020bb:	e8 f0 f0 ff ff       	call   8011b0 <sys_page_alloc>
  8020c0:	89 c3                	mov    %eax,%ebx
  8020c2:	83 c4 10             	add    $0x10,%esp
  8020c5:	85 c0                	test   %eax,%eax
  8020c7:	78 28                	js     8020f1 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  8020c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020cc:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8020d2:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8020d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d7:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8020de:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8020e1:	83 ec 0c             	sub    $0xc,%esp
  8020e4:	50                   	push   %eax
  8020e5:	e8 75 f3 ff ff       	call   80145f <fd2num>
  8020ea:	89 c3                	mov    %eax,%ebx
  8020ec:	83 c4 10             	add    $0x10,%esp
  8020ef:	eb 0c                	jmp    8020fd <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8020f1:	83 ec 0c             	sub    $0xc,%esp
  8020f4:	56                   	push   %esi
  8020f5:	e8 e2 01 00 00       	call   8022dc <nsipc_close>
		return r;
  8020fa:	83 c4 10             	add    $0x10,%esp
}
  8020fd:	89 d8                	mov    %ebx,%eax
  8020ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802102:	5b                   	pop    %ebx
  802103:	5e                   	pop    %esi
  802104:	5d                   	pop    %ebp
  802105:	c3                   	ret    

00802106 <accept>:
{
  802106:	55                   	push   %ebp
  802107:	89 e5                	mov    %esp,%ebp
  802109:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80210c:	8b 45 08             	mov    0x8(%ebp),%eax
  80210f:	e8 4e ff ff ff       	call   802062 <fd2sockid>
  802114:	85 c0                	test   %eax,%eax
  802116:	78 1b                	js     802133 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802118:	83 ec 04             	sub    $0x4,%esp
  80211b:	ff 75 10             	pushl  0x10(%ebp)
  80211e:	ff 75 0c             	pushl  0xc(%ebp)
  802121:	50                   	push   %eax
  802122:	e8 0e 01 00 00       	call   802235 <nsipc_accept>
  802127:	83 c4 10             	add    $0x10,%esp
  80212a:	85 c0                	test   %eax,%eax
  80212c:	78 05                	js     802133 <accept+0x2d>
	return alloc_sockfd(r);
  80212e:	e8 5f ff ff ff       	call   802092 <alloc_sockfd>
}
  802133:	c9                   	leave  
  802134:	c3                   	ret    

00802135 <bind>:
{
  802135:	55                   	push   %ebp
  802136:	89 e5                	mov    %esp,%ebp
  802138:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80213b:	8b 45 08             	mov    0x8(%ebp),%eax
  80213e:	e8 1f ff ff ff       	call   802062 <fd2sockid>
  802143:	85 c0                	test   %eax,%eax
  802145:	78 12                	js     802159 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  802147:	83 ec 04             	sub    $0x4,%esp
  80214a:	ff 75 10             	pushl  0x10(%ebp)
  80214d:	ff 75 0c             	pushl  0xc(%ebp)
  802150:	50                   	push   %eax
  802151:	e8 2f 01 00 00       	call   802285 <nsipc_bind>
  802156:	83 c4 10             	add    $0x10,%esp
}
  802159:	c9                   	leave  
  80215a:	c3                   	ret    

0080215b <shutdown>:
{
  80215b:	55                   	push   %ebp
  80215c:	89 e5                	mov    %esp,%ebp
  80215e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802161:	8b 45 08             	mov    0x8(%ebp),%eax
  802164:	e8 f9 fe ff ff       	call   802062 <fd2sockid>
  802169:	85 c0                	test   %eax,%eax
  80216b:	78 0f                	js     80217c <shutdown+0x21>
	return nsipc_shutdown(r, how);
  80216d:	83 ec 08             	sub    $0x8,%esp
  802170:	ff 75 0c             	pushl  0xc(%ebp)
  802173:	50                   	push   %eax
  802174:	e8 41 01 00 00       	call   8022ba <nsipc_shutdown>
  802179:	83 c4 10             	add    $0x10,%esp
}
  80217c:	c9                   	leave  
  80217d:	c3                   	ret    

0080217e <connect>:
{
  80217e:	55                   	push   %ebp
  80217f:	89 e5                	mov    %esp,%ebp
  802181:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802184:	8b 45 08             	mov    0x8(%ebp),%eax
  802187:	e8 d6 fe ff ff       	call   802062 <fd2sockid>
  80218c:	85 c0                	test   %eax,%eax
  80218e:	78 12                	js     8021a2 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  802190:	83 ec 04             	sub    $0x4,%esp
  802193:	ff 75 10             	pushl  0x10(%ebp)
  802196:	ff 75 0c             	pushl  0xc(%ebp)
  802199:	50                   	push   %eax
  80219a:	e8 57 01 00 00       	call   8022f6 <nsipc_connect>
  80219f:	83 c4 10             	add    $0x10,%esp
}
  8021a2:	c9                   	leave  
  8021a3:	c3                   	ret    

008021a4 <listen>:
{
  8021a4:	55                   	push   %ebp
  8021a5:	89 e5                	mov    %esp,%ebp
  8021a7:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8021aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ad:	e8 b0 fe ff ff       	call   802062 <fd2sockid>
  8021b2:	85 c0                	test   %eax,%eax
  8021b4:	78 0f                	js     8021c5 <listen+0x21>
	return nsipc_listen(r, backlog);
  8021b6:	83 ec 08             	sub    $0x8,%esp
  8021b9:	ff 75 0c             	pushl  0xc(%ebp)
  8021bc:	50                   	push   %eax
  8021bd:	e8 69 01 00 00       	call   80232b <nsipc_listen>
  8021c2:	83 c4 10             	add    $0x10,%esp
}
  8021c5:	c9                   	leave  
  8021c6:	c3                   	ret    

008021c7 <socket>:

int
socket(int domain, int type, int protocol)
{
  8021c7:	55                   	push   %ebp
  8021c8:	89 e5                	mov    %esp,%ebp
  8021ca:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8021cd:	ff 75 10             	pushl  0x10(%ebp)
  8021d0:	ff 75 0c             	pushl  0xc(%ebp)
  8021d3:	ff 75 08             	pushl  0x8(%ebp)
  8021d6:	e8 3c 02 00 00       	call   802417 <nsipc_socket>
  8021db:	83 c4 10             	add    $0x10,%esp
  8021de:	85 c0                	test   %eax,%eax
  8021e0:	78 05                	js     8021e7 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8021e2:	e8 ab fe ff ff       	call   802092 <alloc_sockfd>
}
  8021e7:	c9                   	leave  
  8021e8:	c3                   	ret    

008021e9 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8021e9:	55                   	push   %ebp
  8021ea:	89 e5                	mov    %esp,%ebp
  8021ec:	53                   	push   %ebx
  8021ed:	83 ec 04             	sub    $0x4,%esp
  8021f0:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8021f2:	83 3d b0 40 80 00 00 	cmpl   $0x0,0x8040b0
  8021f9:	74 26                	je     802221 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8021fb:	6a 07                	push   $0x7
  8021fd:	68 00 60 80 00       	push   $0x806000
  802202:	53                   	push   %ebx
  802203:	ff 35 b0 40 80 00    	pushl  0x8040b0
  802209:	e8 19 04 00 00       	call   802627 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  80220e:	83 c4 0c             	add    $0xc,%esp
  802211:	6a 00                	push   $0x0
  802213:	6a 00                	push   $0x0
  802215:	6a 00                	push   $0x0
  802217:	e8 a2 03 00 00       	call   8025be <ipc_recv>
}
  80221c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80221f:	c9                   	leave  
  802220:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802221:	83 ec 0c             	sub    $0xc,%esp
  802224:	6a 02                	push   $0x2
  802226:	e8 55 04 00 00       	call   802680 <ipc_find_env>
  80222b:	a3 b0 40 80 00       	mov    %eax,0x8040b0
  802230:	83 c4 10             	add    $0x10,%esp
  802233:	eb c6                	jmp    8021fb <nsipc+0x12>

00802235 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802235:	55                   	push   %ebp
  802236:	89 e5                	mov    %esp,%ebp
  802238:	56                   	push   %esi
  802239:	53                   	push   %ebx
  80223a:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  80223d:	8b 45 08             	mov    0x8(%ebp),%eax
  802240:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802245:	8b 06                	mov    (%esi),%eax
  802247:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80224c:	b8 01 00 00 00       	mov    $0x1,%eax
  802251:	e8 93 ff ff ff       	call   8021e9 <nsipc>
  802256:	89 c3                	mov    %eax,%ebx
  802258:	85 c0                	test   %eax,%eax
  80225a:	78 20                	js     80227c <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80225c:	83 ec 04             	sub    $0x4,%esp
  80225f:	ff 35 10 60 80 00    	pushl  0x806010
  802265:	68 00 60 80 00       	push   $0x806000
  80226a:	ff 75 0c             	pushl  0xc(%ebp)
  80226d:	e8 d3 ec ff ff       	call   800f45 <memmove>
		*addrlen = ret->ret_addrlen;
  802272:	a1 10 60 80 00       	mov    0x806010,%eax
  802277:	89 06                	mov    %eax,(%esi)
  802279:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  80227c:	89 d8                	mov    %ebx,%eax
  80227e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802281:	5b                   	pop    %ebx
  802282:	5e                   	pop    %esi
  802283:	5d                   	pop    %ebp
  802284:	c3                   	ret    

00802285 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802285:	55                   	push   %ebp
  802286:	89 e5                	mov    %esp,%ebp
  802288:	53                   	push   %ebx
  802289:	83 ec 08             	sub    $0x8,%esp
  80228c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  80228f:	8b 45 08             	mov    0x8(%ebp),%eax
  802292:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802297:	53                   	push   %ebx
  802298:	ff 75 0c             	pushl  0xc(%ebp)
  80229b:	68 04 60 80 00       	push   $0x806004
  8022a0:	e8 a0 ec ff ff       	call   800f45 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8022a5:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  8022ab:	b8 02 00 00 00       	mov    $0x2,%eax
  8022b0:	e8 34 ff ff ff       	call   8021e9 <nsipc>
}
  8022b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022b8:	c9                   	leave  
  8022b9:	c3                   	ret    

008022ba <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8022ba:	55                   	push   %ebp
  8022bb:	89 e5                	mov    %esp,%ebp
  8022bd:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8022c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c3:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  8022c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022cb:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  8022d0:	b8 03 00 00 00       	mov    $0x3,%eax
  8022d5:	e8 0f ff ff ff       	call   8021e9 <nsipc>
}
  8022da:	c9                   	leave  
  8022db:	c3                   	ret    

008022dc <nsipc_close>:

int
nsipc_close(int s)
{
  8022dc:	55                   	push   %ebp
  8022dd:	89 e5                	mov    %esp,%ebp
  8022df:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8022e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e5:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  8022ea:	b8 04 00 00 00       	mov    $0x4,%eax
  8022ef:	e8 f5 fe ff ff       	call   8021e9 <nsipc>
}
  8022f4:	c9                   	leave  
  8022f5:	c3                   	ret    

008022f6 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8022f6:	55                   	push   %ebp
  8022f7:	89 e5                	mov    %esp,%ebp
  8022f9:	53                   	push   %ebx
  8022fa:	83 ec 08             	sub    $0x8,%esp
  8022fd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802300:	8b 45 08             	mov    0x8(%ebp),%eax
  802303:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802308:	53                   	push   %ebx
  802309:	ff 75 0c             	pushl  0xc(%ebp)
  80230c:	68 04 60 80 00       	push   $0x806004
  802311:	e8 2f ec ff ff       	call   800f45 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802316:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  80231c:	b8 05 00 00 00       	mov    $0x5,%eax
  802321:	e8 c3 fe ff ff       	call   8021e9 <nsipc>
}
  802326:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802329:	c9                   	leave  
  80232a:	c3                   	ret    

0080232b <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80232b:	55                   	push   %ebp
  80232c:	89 e5                	mov    %esp,%ebp
  80232e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802331:	8b 45 08             	mov    0x8(%ebp),%eax
  802334:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  802339:	8b 45 0c             	mov    0xc(%ebp),%eax
  80233c:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  802341:	b8 06 00 00 00       	mov    $0x6,%eax
  802346:	e8 9e fe ff ff       	call   8021e9 <nsipc>
}
  80234b:	c9                   	leave  
  80234c:	c3                   	ret    

0080234d <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80234d:	55                   	push   %ebp
  80234e:	89 e5                	mov    %esp,%ebp
  802350:	56                   	push   %esi
  802351:	53                   	push   %ebx
  802352:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802355:	8b 45 08             	mov    0x8(%ebp),%eax
  802358:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  80235d:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  802363:	8b 45 14             	mov    0x14(%ebp),%eax
  802366:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80236b:	b8 07 00 00 00       	mov    $0x7,%eax
  802370:	e8 74 fe ff ff       	call   8021e9 <nsipc>
  802375:	89 c3                	mov    %eax,%ebx
  802377:	85 c0                	test   %eax,%eax
  802379:	78 1f                	js     80239a <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  80237b:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802380:	7f 21                	jg     8023a3 <nsipc_recv+0x56>
  802382:	39 c6                	cmp    %eax,%esi
  802384:	7c 1d                	jl     8023a3 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802386:	83 ec 04             	sub    $0x4,%esp
  802389:	50                   	push   %eax
  80238a:	68 00 60 80 00       	push   $0x806000
  80238f:	ff 75 0c             	pushl  0xc(%ebp)
  802392:	e8 ae eb ff ff       	call   800f45 <memmove>
  802397:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  80239a:	89 d8                	mov    %ebx,%eax
  80239c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80239f:	5b                   	pop    %ebx
  8023a0:	5e                   	pop    %esi
  8023a1:	5d                   	pop    %ebp
  8023a2:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8023a3:	68 ee 2e 80 00       	push   $0x802eee
  8023a8:	68 90 2e 80 00       	push   $0x802e90
  8023ad:	6a 62                	push   $0x62
  8023af:	68 03 2f 80 00       	push   $0x802f03
  8023b4:	e8 86 e2 ff ff       	call   80063f <_panic>

008023b9 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8023b9:	55                   	push   %ebp
  8023ba:	89 e5                	mov    %esp,%ebp
  8023bc:	53                   	push   %ebx
  8023bd:	83 ec 04             	sub    $0x4,%esp
  8023c0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8023c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c6:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  8023cb:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8023d1:	7f 2e                	jg     802401 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8023d3:	83 ec 04             	sub    $0x4,%esp
  8023d6:	53                   	push   %ebx
  8023d7:	ff 75 0c             	pushl  0xc(%ebp)
  8023da:	68 0c 60 80 00       	push   $0x80600c
  8023df:	e8 61 eb ff ff       	call   800f45 <memmove>
	nsipcbuf.send.req_size = size;
  8023e4:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  8023ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8023ed:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  8023f2:	b8 08 00 00 00       	mov    $0x8,%eax
  8023f7:	e8 ed fd ff ff       	call   8021e9 <nsipc>
}
  8023fc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023ff:	c9                   	leave  
  802400:	c3                   	ret    
	assert(size < 1600);
  802401:	68 0f 2f 80 00       	push   $0x802f0f
  802406:	68 90 2e 80 00       	push   $0x802e90
  80240b:	6a 6d                	push   $0x6d
  80240d:	68 03 2f 80 00       	push   $0x802f03
  802412:	e8 28 e2 ff ff       	call   80063f <_panic>

00802417 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802417:	55                   	push   %ebp
  802418:	89 e5                	mov    %esp,%ebp
  80241a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80241d:	8b 45 08             	mov    0x8(%ebp),%eax
  802420:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  802425:	8b 45 0c             	mov    0xc(%ebp),%eax
  802428:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  80242d:	8b 45 10             	mov    0x10(%ebp),%eax
  802430:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  802435:	b8 09 00 00 00       	mov    $0x9,%eax
  80243a:	e8 aa fd ff ff       	call   8021e9 <nsipc>
}
  80243f:	c9                   	leave  
  802440:	c3                   	ret    

00802441 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802441:	55                   	push   %ebp
  802442:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802444:	b8 00 00 00 00       	mov    $0x0,%eax
  802449:	5d                   	pop    %ebp
  80244a:	c3                   	ret    

0080244b <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80244b:	55                   	push   %ebp
  80244c:	89 e5                	mov    %esp,%ebp
  80244e:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802451:	68 1b 2f 80 00       	push   $0x802f1b
  802456:	ff 75 0c             	pushl  0xc(%ebp)
  802459:	e8 59 e9 ff ff       	call   800db7 <strcpy>
	return 0;
}
  80245e:	b8 00 00 00 00       	mov    $0x0,%eax
  802463:	c9                   	leave  
  802464:	c3                   	ret    

00802465 <devcons_write>:
{
  802465:	55                   	push   %ebp
  802466:	89 e5                	mov    %esp,%ebp
  802468:	57                   	push   %edi
  802469:	56                   	push   %esi
  80246a:	53                   	push   %ebx
  80246b:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802471:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802476:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80247c:	eb 2f                	jmp    8024ad <devcons_write+0x48>
		m = n - tot;
  80247e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802481:	29 f3                	sub    %esi,%ebx
  802483:	83 fb 7f             	cmp    $0x7f,%ebx
  802486:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80248b:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80248e:	83 ec 04             	sub    $0x4,%esp
  802491:	53                   	push   %ebx
  802492:	89 f0                	mov    %esi,%eax
  802494:	03 45 0c             	add    0xc(%ebp),%eax
  802497:	50                   	push   %eax
  802498:	57                   	push   %edi
  802499:	e8 a7 ea ff ff       	call   800f45 <memmove>
		sys_cputs(buf, m);
  80249e:	83 c4 08             	add    $0x8,%esp
  8024a1:	53                   	push   %ebx
  8024a2:	57                   	push   %edi
  8024a3:	e8 4c ec ff ff       	call   8010f4 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8024a8:	01 de                	add    %ebx,%esi
  8024aa:	83 c4 10             	add    $0x10,%esp
  8024ad:	3b 75 10             	cmp    0x10(%ebp),%esi
  8024b0:	72 cc                	jb     80247e <devcons_write+0x19>
}
  8024b2:	89 f0                	mov    %esi,%eax
  8024b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024b7:	5b                   	pop    %ebx
  8024b8:	5e                   	pop    %esi
  8024b9:	5f                   	pop    %edi
  8024ba:	5d                   	pop    %ebp
  8024bb:	c3                   	ret    

008024bc <devcons_read>:
{
  8024bc:	55                   	push   %ebp
  8024bd:	89 e5                	mov    %esp,%ebp
  8024bf:	83 ec 08             	sub    $0x8,%esp
  8024c2:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8024c7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8024cb:	75 07                	jne    8024d4 <devcons_read+0x18>
}
  8024cd:	c9                   	leave  
  8024ce:	c3                   	ret    
		sys_yield();
  8024cf:	e8 bd ec ff ff       	call   801191 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  8024d4:	e8 39 ec ff ff       	call   801112 <sys_cgetc>
  8024d9:	85 c0                	test   %eax,%eax
  8024db:	74 f2                	je     8024cf <devcons_read+0x13>
	if (c < 0)
  8024dd:	85 c0                	test   %eax,%eax
  8024df:	78 ec                	js     8024cd <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  8024e1:	83 f8 04             	cmp    $0x4,%eax
  8024e4:	74 0c                	je     8024f2 <devcons_read+0x36>
	*(char*)vbuf = c;
  8024e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024e9:	88 02                	mov    %al,(%edx)
	return 1;
  8024eb:	b8 01 00 00 00       	mov    $0x1,%eax
  8024f0:	eb db                	jmp    8024cd <devcons_read+0x11>
		return 0;
  8024f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8024f7:	eb d4                	jmp    8024cd <devcons_read+0x11>

008024f9 <cputchar>:
{
  8024f9:	55                   	push   %ebp
  8024fa:	89 e5                	mov    %esp,%ebp
  8024fc:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8024ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802502:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802505:	6a 01                	push   $0x1
  802507:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80250a:	50                   	push   %eax
  80250b:	e8 e4 eb ff ff       	call   8010f4 <sys_cputs>
}
  802510:	83 c4 10             	add    $0x10,%esp
  802513:	c9                   	leave  
  802514:	c3                   	ret    

00802515 <getchar>:
{
  802515:	55                   	push   %ebp
  802516:	89 e5                	mov    %esp,%ebp
  802518:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80251b:	6a 01                	push   $0x1
  80251d:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802520:	50                   	push   %eax
  802521:	6a 00                	push   $0x0
  802523:	e8 1e f2 ff ff       	call   801746 <read>
	if (r < 0)
  802528:	83 c4 10             	add    $0x10,%esp
  80252b:	85 c0                	test   %eax,%eax
  80252d:	78 08                	js     802537 <getchar+0x22>
	if (r < 1)
  80252f:	85 c0                	test   %eax,%eax
  802531:	7e 06                	jle    802539 <getchar+0x24>
	return c;
  802533:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802537:	c9                   	leave  
  802538:	c3                   	ret    
		return -E_EOF;
  802539:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80253e:	eb f7                	jmp    802537 <getchar+0x22>

00802540 <iscons>:
{
  802540:	55                   	push   %ebp
  802541:	89 e5                	mov    %esp,%ebp
  802543:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802546:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802549:	50                   	push   %eax
  80254a:	ff 75 08             	pushl  0x8(%ebp)
  80254d:	e8 83 ef ff ff       	call   8014d5 <fd_lookup>
  802552:	83 c4 10             	add    $0x10,%esp
  802555:	85 c0                	test   %eax,%eax
  802557:	78 11                	js     80256a <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802559:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255c:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802562:	39 10                	cmp    %edx,(%eax)
  802564:	0f 94 c0             	sete   %al
  802567:	0f b6 c0             	movzbl %al,%eax
}
  80256a:	c9                   	leave  
  80256b:	c3                   	ret    

0080256c <opencons>:
{
  80256c:	55                   	push   %ebp
  80256d:	89 e5                	mov    %esp,%ebp
  80256f:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802572:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802575:	50                   	push   %eax
  802576:	e8 0b ef ff ff       	call   801486 <fd_alloc>
  80257b:	83 c4 10             	add    $0x10,%esp
  80257e:	85 c0                	test   %eax,%eax
  802580:	78 3a                	js     8025bc <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802582:	83 ec 04             	sub    $0x4,%esp
  802585:	68 07 04 00 00       	push   $0x407
  80258a:	ff 75 f4             	pushl  -0xc(%ebp)
  80258d:	6a 00                	push   $0x0
  80258f:	e8 1c ec ff ff       	call   8011b0 <sys_page_alloc>
  802594:	83 c4 10             	add    $0x10,%esp
  802597:	85 c0                	test   %eax,%eax
  802599:	78 21                	js     8025bc <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80259b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259e:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8025a4:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8025a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a9:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8025b0:	83 ec 0c             	sub    $0xc,%esp
  8025b3:	50                   	push   %eax
  8025b4:	e8 a6 ee ff ff       	call   80145f <fd2num>
  8025b9:	83 c4 10             	add    $0x10,%esp
}
  8025bc:	c9                   	leave  
  8025bd:	c3                   	ret    

008025be <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8025be:	55                   	push   %ebp
  8025bf:	89 e5                	mov    %esp,%ebp
  8025c1:	56                   	push   %esi
  8025c2:	53                   	push   %ebx
  8025c3:	8b 75 08             	mov    0x8(%ebp),%esi
  8025c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025c9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
  8025cc:	85 c0                	test   %eax,%eax
	    pg = (void *)UTOP;
  8025ce:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8025d3:	0f 44 c2             	cmove  %edx,%eax
	}
	if ((r = sys_ipc_recv(pg)) < 0) {
  8025d6:	83 ec 0c             	sub    $0xc,%esp
  8025d9:	50                   	push   %eax
  8025da:	e8 81 ed ff ff       	call   801360 <sys_ipc_recv>
  8025df:	83 c4 10             	add    $0x10,%esp
  8025e2:	85 c0                	test   %eax,%eax
  8025e4:	78 2b                	js     802611 <ipc_recv+0x53>
	    if (perm_store != NULL) {
	        *perm_store = 0;
	    }
	    return r;
	}
	if (from_env_store != NULL) {
  8025e6:	85 f6                	test   %esi,%esi
  8025e8:	74 0a                	je     8025f4 <ipc_recv+0x36>
	    *from_env_store = thisenv->env_ipc_from;
  8025ea:	a1 b4 40 80 00       	mov    0x8040b4,%eax
  8025ef:	8b 40 74             	mov    0x74(%eax),%eax
  8025f2:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store != NULL) {
  8025f4:	85 db                	test   %ebx,%ebx
  8025f6:	74 0a                	je     802602 <ipc_recv+0x44>
	    *perm_store = thisenv->env_ipc_perm;
  8025f8:	a1 b4 40 80 00       	mov    0x8040b4,%eax
  8025fd:	8b 40 78             	mov    0x78(%eax),%eax
  802600:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  802602:	a1 b4 40 80 00       	mov    0x8040b4,%eax
  802607:	8b 40 70             	mov    0x70(%eax),%eax
}
  80260a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80260d:	5b                   	pop    %ebx
  80260e:	5e                   	pop    %esi
  80260f:	5d                   	pop    %ebp
  802610:	c3                   	ret    
	    if (from_env_store != NULL) {
  802611:	85 f6                	test   %esi,%esi
  802613:	74 06                	je     80261b <ipc_recv+0x5d>
	        *from_env_store = 0;
  802615:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	    if (perm_store != NULL) {
  80261b:	85 db                	test   %ebx,%ebx
  80261d:	74 eb                	je     80260a <ipc_recv+0x4c>
	        *perm_store = 0;
  80261f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802625:	eb e3                	jmp    80260a <ipc_recv+0x4c>

00802627 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802627:	55                   	push   %ebp
  802628:	89 e5                	mov    %esp,%ebp
  80262a:	57                   	push   %edi
  80262b:	56                   	push   %esi
  80262c:	53                   	push   %ebx
  80262d:	83 ec 0c             	sub    $0xc,%esp
  802630:	8b 7d 08             	mov    0x8(%ebp),%edi
  802633:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
	    pg = (void *)UTOP;
  802636:	85 f6                	test   %esi,%esi
  802638:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80263d:	0f 44 f0             	cmove  %eax,%esi
  802640:	eb 09                	jmp    80264b <ipc_send+0x24>
	do {
	    r = sys_ipc_try_send(to_env, val, pg, perm);
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
	        panic("ipc_send: %e", r);
	    }
	    sys_yield();
  802642:	e8 4a eb ff ff       	call   801191 <sys_yield>
	} while(r != 0);
  802647:	85 db                	test   %ebx,%ebx
  802649:	74 2d                	je     802678 <ipc_send+0x51>
	    r = sys_ipc_try_send(to_env, val, pg, perm);
  80264b:	ff 75 14             	pushl  0x14(%ebp)
  80264e:	56                   	push   %esi
  80264f:	ff 75 0c             	pushl  0xc(%ebp)
  802652:	57                   	push   %edi
  802653:	e8 e5 ec ff ff       	call   80133d <sys_ipc_try_send>
  802658:	89 c3                	mov    %eax,%ebx
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
  80265a:	83 c4 10             	add    $0x10,%esp
  80265d:	85 c0                	test   %eax,%eax
  80265f:	79 e1                	jns    802642 <ipc_send+0x1b>
  802661:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802664:	74 dc                	je     802642 <ipc_send+0x1b>
	        panic("ipc_send: %e", r);
  802666:	50                   	push   %eax
  802667:	68 27 2f 80 00       	push   $0x802f27
  80266c:	6a 45                	push   $0x45
  80266e:	68 34 2f 80 00       	push   $0x802f34
  802673:	e8 c7 df ff ff       	call   80063f <_panic>
}
  802678:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80267b:	5b                   	pop    %ebx
  80267c:	5e                   	pop    %esi
  80267d:	5f                   	pop    %edi
  80267e:	5d                   	pop    %ebp
  80267f:	c3                   	ret    

00802680 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802680:	55                   	push   %ebp
  802681:	89 e5                	mov    %esp,%ebp
  802683:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802686:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80268b:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80268e:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802694:	8b 52 50             	mov    0x50(%edx),%edx
  802697:	39 ca                	cmp    %ecx,%edx
  802699:	74 11                	je     8026ac <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  80269b:	83 c0 01             	add    $0x1,%eax
  80269e:	3d 00 04 00 00       	cmp    $0x400,%eax
  8026a3:	75 e6                	jne    80268b <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8026a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8026aa:	eb 0b                	jmp    8026b7 <ipc_find_env+0x37>
			return envs[i].env_id;
  8026ac:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8026af:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8026b4:	8b 40 48             	mov    0x48(%eax),%eax
}
  8026b7:	5d                   	pop    %ebp
  8026b8:	c3                   	ret    

008026b9 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8026b9:	55                   	push   %ebp
  8026ba:	89 e5                	mov    %esp,%ebp
  8026bc:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8026bf:	89 d0                	mov    %edx,%eax
  8026c1:	c1 e8 16             	shr    $0x16,%eax
  8026c4:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8026cb:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8026d0:	f6 c1 01             	test   $0x1,%cl
  8026d3:	74 1d                	je     8026f2 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8026d5:	c1 ea 0c             	shr    $0xc,%edx
  8026d8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8026df:	f6 c2 01             	test   $0x1,%dl
  8026e2:	74 0e                	je     8026f2 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8026e4:	c1 ea 0c             	shr    $0xc,%edx
  8026e7:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8026ee:	ef 
  8026ef:	0f b7 c0             	movzwl %ax,%eax
}
  8026f2:	5d                   	pop    %ebp
  8026f3:	c3                   	ret    
  8026f4:	66 90                	xchg   %ax,%ax
  8026f6:	66 90                	xchg   %ax,%ax
  8026f8:	66 90                	xchg   %ax,%ax
  8026fa:	66 90                	xchg   %ax,%ax
  8026fc:	66 90                	xchg   %ax,%ax
  8026fe:	66 90                	xchg   %ax,%ax

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
