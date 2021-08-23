
obj/user/buggyhello2.debug:     file format elf32-i386


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
  80002c:	e8 1d 00 00 00       	call   80004e <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

const char *hello = "hello, world\n";

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	sys_cputs(hello, 1024*1024);
  800039:	68 00 00 10 00       	push   $0x100000
  80003e:	ff 35 00 30 80 00    	pushl  0x803000
  800044:	e8 65 00 00 00       	call   8000ae <sys_cputs>
}
  800049:	83 c4 10             	add    $0x10,%esp
  80004c:	c9                   	leave  
  80004d:	c3                   	ret    

0080004e <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80004e:	55                   	push   %ebp
  80004f:	89 e5                	mov    %esp,%ebp
  800051:	56                   	push   %esi
  800052:	53                   	push   %ebx
  800053:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800056:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
    thisenv = &envs[ENVX(sys_getenvid())];
  800059:	e8 ce 00 00 00       	call   80012c <sys_getenvid>
  80005e:	25 ff 03 00 00       	and    $0x3ff,%eax
  800063:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800066:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80006b:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800070:	85 db                	test   %ebx,%ebx
  800072:	7e 07                	jle    80007b <libmain+0x2d>
		binaryname = argv[0];
  800074:	8b 06                	mov    (%esi),%eax
  800076:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	umain(argc, argv);
  80007b:	83 ec 08             	sub    $0x8,%esp
  80007e:	56                   	push   %esi
  80007f:	53                   	push   %ebx
  800080:	e8 ae ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800085:	e8 0a 00 00 00       	call   800094 <exit>
}
  80008a:	83 c4 10             	add    $0x10,%esp
  80008d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800090:	5b                   	pop    %ebx
  800091:	5e                   	pop    %esi
  800092:	5d                   	pop    %ebp
  800093:	c3                   	ret    

00800094 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800094:	55                   	push   %ebp
  800095:	89 e5                	mov    %esp,%ebp
  800097:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80009a:	e8 b1 04 00 00       	call   800550 <close_all>
	sys_env_destroy(0);
  80009f:	83 ec 0c             	sub    $0xc,%esp
  8000a2:	6a 00                	push   $0x0
  8000a4:	e8 42 00 00 00       	call   8000eb <sys_env_destroy>
}
  8000a9:	83 c4 10             	add    $0x10,%esp
  8000ac:	c9                   	leave  
  8000ad:	c3                   	ret    

008000ae <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000ae:	55                   	push   %ebp
  8000af:	89 e5                	mov    %esp,%ebp
  8000b1:	57                   	push   %edi
  8000b2:	56                   	push   %esi
  8000b3:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8000bc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000bf:	89 c3                	mov    %eax,%ebx
  8000c1:	89 c7                	mov    %eax,%edi
  8000c3:	89 c6                	mov    %eax,%esi
  8000c5:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000c7:	5b                   	pop    %ebx
  8000c8:	5e                   	pop    %esi
  8000c9:	5f                   	pop    %edi
  8000ca:	5d                   	pop    %ebp
  8000cb:	c3                   	ret    

008000cc <sys_cgetc>:

int
sys_cgetc(void)
{
  8000cc:	55                   	push   %ebp
  8000cd:	89 e5                	mov    %esp,%ebp
  8000cf:	57                   	push   %edi
  8000d0:	56                   	push   %esi
  8000d1:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8000d7:	b8 01 00 00 00       	mov    $0x1,%eax
  8000dc:	89 d1                	mov    %edx,%ecx
  8000de:	89 d3                	mov    %edx,%ebx
  8000e0:	89 d7                	mov    %edx,%edi
  8000e2:	89 d6                	mov    %edx,%esi
  8000e4:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000e6:	5b                   	pop    %ebx
  8000e7:	5e                   	pop    %esi
  8000e8:	5f                   	pop    %edi
  8000e9:	5d                   	pop    %ebp
  8000ea:	c3                   	ret    

008000eb <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000eb:	55                   	push   %ebp
  8000ec:	89 e5                	mov    %esp,%ebp
  8000ee:	57                   	push   %edi
  8000ef:	56                   	push   %esi
  8000f0:	53                   	push   %ebx
  8000f1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8000f4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8000fc:	b8 03 00 00 00       	mov    $0x3,%eax
  800101:	89 cb                	mov    %ecx,%ebx
  800103:	89 cf                	mov    %ecx,%edi
  800105:	89 ce                	mov    %ecx,%esi
  800107:	cd 30                	int    $0x30
	if(check && ret > 0)
  800109:	85 c0                	test   %eax,%eax
  80010b:	7f 08                	jg     800115 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80010d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800110:	5b                   	pop    %ebx
  800111:	5e                   	pop    %esi
  800112:	5f                   	pop    %edi
  800113:	5d                   	pop    %ebp
  800114:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800115:	83 ec 0c             	sub    $0xc,%esp
  800118:	50                   	push   %eax
  800119:	6a 03                	push   $0x3
  80011b:	68 38 23 80 00       	push   $0x802338
  800120:	6a 23                	push   $0x23
  800122:	68 55 23 80 00       	push   $0x802355
  800127:	e8 ad 13 00 00       	call   8014d9 <_panic>

0080012c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80012c:	55                   	push   %ebp
  80012d:	89 e5                	mov    %esp,%ebp
  80012f:	57                   	push   %edi
  800130:	56                   	push   %esi
  800131:	53                   	push   %ebx
	asm volatile("int %1\n"
  800132:	ba 00 00 00 00       	mov    $0x0,%edx
  800137:	b8 02 00 00 00       	mov    $0x2,%eax
  80013c:	89 d1                	mov    %edx,%ecx
  80013e:	89 d3                	mov    %edx,%ebx
  800140:	89 d7                	mov    %edx,%edi
  800142:	89 d6                	mov    %edx,%esi
  800144:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800146:	5b                   	pop    %ebx
  800147:	5e                   	pop    %esi
  800148:	5f                   	pop    %edi
  800149:	5d                   	pop    %ebp
  80014a:	c3                   	ret    

0080014b <sys_yield>:

void
sys_yield(void)
{
  80014b:	55                   	push   %ebp
  80014c:	89 e5                	mov    %esp,%ebp
  80014e:	57                   	push   %edi
  80014f:	56                   	push   %esi
  800150:	53                   	push   %ebx
	asm volatile("int %1\n"
  800151:	ba 00 00 00 00       	mov    $0x0,%edx
  800156:	b8 0b 00 00 00       	mov    $0xb,%eax
  80015b:	89 d1                	mov    %edx,%ecx
  80015d:	89 d3                	mov    %edx,%ebx
  80015f:	89 d7                	mov    %edx,%edi
  800161:	89 d6                	mov    %edx,%esi
  800163:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800165:	5b                   	pop    %ebx
  800166:	5e                   	pop    %esi
  800167:	5f                   	pop    %edi
  800168:	5d                   	pop    %ebp
  800169:	c3                   	ret    

0080016a <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80016a:	55                   	push   %ebp
  80016b:	89 e5                	mov    %esp,%ebp
  80016d:	57                   	push   %edi
  80016e:	56                   	push   %esi
  80016f:	53                   	push   %ebx
  800170:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800173:	be 00 00 00 00       	mov    $0x0,%esi
  800178:	8b 55 08             	mov    0x8(%ebp),%edx
  80017b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80017e:	b8 04 00 00 00       	mov    $0x4,%eax
  800183:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800186:	89 f7                	mov    %esi,%edi
  800188:	cd 30                	int    $0x30
	if(check && ret > 0)
  80018a:	85 c0                	test   %eax,%eax
  80018c:	7f 08                	jg     800196 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80018e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800191:	5b                   	pop    %ebx
  800192:	5e                   	pop    %esi
  800193:	5f                   	pop    %edi
  800194:	5d                   	pop    %ebp
  800195:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800196:	83 ec 0c             	sub    $0xc,%esp
  800199:	50                   	push   %eax
  80019a:	6a 04                	push   $0x4
  80019c:	68 38 23 80 00       	push   $0x802338
  8001a1:	6a 23                	push   $0x23
  8001a3:	68 55 23 80 00       	push   $0x802355
  8001a8:	e8 2c 13 00 00       	call   8014d9 <_panic>

008001ad <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001ad:	55                   	push   %ebp
  8001ae:	89 e5                	mov    %esp,%ebp
  8001b0:	57                   	push   %edi
  8001b1:	56                   	push   %esi
  8001b2:	53                   	push   %ebx
  8001b3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8001b9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001bc:	b8 05 00 00 00       	mov    $0x5,%eax
  8001c1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001c4:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001c7:	8b 75 18             	mov    0x18(%ebp),%esi
  8001ca:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001cc:	85 c0                	test   %eax,%eax
  8001ce:	7f 08                	jg     8001d8 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001d3:	5b                   	pop    %ebx
  8001d4:	5e                   	pop    %esi
  8001d5:	5f                   	pop    %edi
  8001d6:	5d                   	pop    %ebp
  8001d7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001d8:	83 ec 0c             	sub    $0xc,%esp
  8001db:	50                   	push   %eax
  8001dc:	6a 05                	push   $0x5
  8001de:	68 38 23 80 00       	push   $0x802338
  8001e3:	6a 23                	push   $0x23
  8001e5:	68 55 23 80 00       	push   $0x802355
  8001ea:	e8 ea 12 00 00       	call   8014d9 <_panic>

008001ef <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001ef:	55                   	push   %ebp
  8001f0:	89 e5                	mov    %esp,%ebp
  8001f2:	57                   	push   %edi
  8001f3:	56                   	push   %esi
  8001f4:	53                   	push   %ebx
  8001f5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001f8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001fd:	8b 55 08             	mov    0x8(%ebp),%edx
  800200:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800203:	b8 06 00 00 00       	mov    $0x6,%eax
  800208:	89 df                	mov    %ebx,%edi
  80020a:	89 de                	mov    %ebx,%esi
  80020c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80020e:	85 c0                	test   %eax,%eax
  800210:	7f 08                	jg     80021a <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800212:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800215:	5b                   	pop    %ebx
  800216:	5e                   	pop    %esi
  800217:	5f                   	pop    %edi
  800218:	5d                   	pop    %ebp
  800219:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80021a:	83 ec 0c             	sub    $0xc,%esp
  80021d:	50                   	push   %eax
  80021e:	6a 06                	push   $0x6
  800220:	68 38 23 80 00       	push   $0x802338
  800225:	6a 23                	push   $0x23
  800227:	68 55 23 80 00       	push   $0x802355
  80022c:	e8 a8 12 00 00       	call   8014d9 <_panic>

00800231 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800231:	55                   	push   %ebp
  800232:	89 e5                	mov    %esp,%ebp
  800234:	57                   	push   %edi
  800235:	56                   	push   %esi
  800236:	53                   	push   %ebx
  800237:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80023a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80023f:	8b 55 08             	mov    0x8(%ebp),%edx
  800242:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800245:	b8 08 00 00 00       	mov    $0x8,%eax
  80024a:	89 df                	mov    %ebx,%edi
  80024c:	89 de                	mov    %ebx,%esi
  80024e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800250:	85 c0                	test   %eax,%eax
  800252:	7f 08                	jg     80025c <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800254:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800257:	5b                   	pop    %ebx
  800258:	5e                   	pop    %esi
  800259:	5f                   	pop    %edi
  80025a:	5d                   	pop    %ebp
  80025b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80025c:	83 ec 0c             	sub    $0xc,%esp
  80025f:	50                   	push   %eax
  800260:	6a 08                	push   $0x8
  800262:	68 38 23 80 00       	push   $0x802338
  800267:	6a 23                	push   $0x23
  800269:	68 55 23 80 00       	push   $0x802355
  80026e:	e8 66 12 00 00       	call   8014d9 <_panic>

00800273 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800273:	55                   	push   %ebp
  800274:	89 e5                	mov    %esp,%ebp
  800276:	57                   	push   %edi
  800277:	56                   	push   %esi
  800278:	53                   	push   %ebx
  800279:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80027c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800281:	8b 55 08             	mov    0x8(%ebp),%edx
  800284:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800287:	b8 09 00 00 00       	mov    $0x9,%eax
  80028c:	89 df                	mov    %ebx,%edi
  80028e:	89 de                	mov    %ebx,%esi
  800290:	cd 30                	int    $0x30
	if(check && ret > 0)
  800292:	85 c0                	test   %eax,%eax
  800294:	7f 08                	jg     80029e <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800296:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800299:	5b                   	pop    %ebx
  80029a:	5e                   	pop    %esi
  80029b:	5f                   	pop    %edi
  80029c:	5d                   	pop    %ebp
  80029d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80029e:	83 ec 0c             	sub    $0xc,%esp
  8002a1:	50                   	push   %eax
  8002a2:	6a 09                	push   $0x9
  8002a4:	68 38 23 80 00       	push   $0x802338
  8002a9:	6a 23                	push   $0x23
  8002ab:	68 55 23 80 00       	push   $0x802355
  8002b0:	e8 24 12 00 00       	call   8014d9 <_panic>

008002b5 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002b5:	55                   	push   %ebp
  8002b6:	89 e5                	mov    %esp,%ebp
  8002b8:	57                   	push   %edi
  8002b9:	56                   	push   %esi
  8002ba:	53                   	push   %ebx
  8002bb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002be:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8002c6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002c9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002ce:	89 df                	mov    %ebx,%edi
  8002d0:	89 de                	mov    %ebx,%esi
  8002d2:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002d4:	85 c0                	test   %eax,%eax
  8002d6:	7f 08                	jg     8002e0 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8002d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002db:	5b                   	pop    %ebx
  8002dc:	5e                   	pop    %esi
  8002dd:	5f                   	pop    %edi
  8002de:	5d                   	pop    %ebp
  8002df:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002e0:	83 ec 0c             	sub    $0xc,%esp
  8002e3:	50                   	push   %eax
  8002e4:	6a 0a                	push   $0xa
  8002e6:	68 38 23 80 00       	push   $0x802338
  8002eb:	6a 23                	push   $0x23
  8002ed:	68 55 23 80 00       	push   $0x802355
  8002f2:	e8 e2 11 00 00       	call   8014d9 <_panic>

008002f7 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8002f7:	55                   	push   %ebp
  8002f8:	89 e5                	mov    %esp,%ebp
  8002fa:	57                   	push   %edi
  8002fb:	56                   	push   %esi
  8002fc:	53                   	push   %ebx
	asm volatile("int %1\n"
  8002fd:	8b 55 08             	mov    0x8(%ebp),%edx
  800300:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800303:	b8 0c 00 00 00       	mov    $0xc,%eax
  800308:	be 00 00 00 00       	mov    $0x0,%esi
  80030d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800310:	8b 7d 14             	mov    0x14(%ebp),%edi
  800313:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800315:	5b                   	pop    %ebx
  800316:	5e                   	pop    %esi
  800317:	5f                   	pop    %edi
  800318:	5d                   	pop    %ebp
  800319:	c3                   	ret    

0080031a <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80031a:	55                   	push   %ebp
  80031b:	89 e5                	mov    %esp,%ebp
  80031d:	57                   	push   %edi
  80031e:	56                   	push   %esi
  80031f:	53                   	push   %ebx
  800320:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800323:	b9 00 00 00 00       	mov    $0x0,%ecx
  800328:	8b 55 08             	mov    0x8(%ebp),%edx
  80032b:	b8 0d 00 00 00       	mov    $0xd,%eax
  800330:	89 cb                	mov    %ecx,%ebx
  800332:	89 cf                	mov    %ecx,%edi
  800334:	89 ce                	mov    %ecx,%esi
  800336:	cd 30                	int    $0x30
	if(check && ret > 0)
  800338:	85 c0                	test   %eax,%eax
  80033a:	7f 08                	jg     800344 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80033c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80033f:	5b                   	pop    %ebx
  800340:	5e                   	pop    %esi
  800341:	5f                   	pop    %edi
  800342:	5d                   	pop    %ebp
  800343:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800344:	83 ec 0c             	sub    $0xc,%esp
  800347:	50                   	push   %eax
  800348:	6a 0d                	push   $0xd
  80034a:	68 38 23 80 00       	push   $0x802338
  80034f:	6a 23                	push   $0x23
  800351:	68 55 23 80 00       	push   $0x802355
  800356:	e8 7e 11 00 00       	call   8014d9 <_panic>

0080035b <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80035b:	55                   	push   %ebp
  80035c:	89 e5                	mov    %esp,%ebp
  80035e:	57                   	push   %edi
  80035f:	56                   	push   %esi
  800360:	53                   	push   %ebx
	asm volatile("int %1\n"
  800361:	ba 00 00 00 00       	mov    $0x0,%edx
  800366:	b8 0e 00 00 00       	mov    $0xe,%eax
  80036b:	89 d1                	mov    %edx,%ecx
  80036d:	89 d3                	mov    %edx,%ebx
  80036f:	89 d7                	mov    %edx,%edi
  800371:	89 d6                	mov    %edx,%esi
  800373:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800375:	5b                   	pop    %ebx
  800376:	5e                   	pop    %esi
  800377:	5f                   	pop    %edi
  800378:	5d                   	pop    %ebp
  800379:	c3                   	ret    

0080037a <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80037a:	55                   	push   %ebp
  80037b:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80037d:	8b 45 08             	mov    0x8(%ebp),%eax
  800380:	05 00 00 00 30       	add    $0x30000000,%eax
  800385:	c1 e8 0c             	shr    $0xc,%eax
}
  800388:	5d                   	pop    %ebp
  800389:	c3                   	ret    

0080038a <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80038a:	55                   	push   %ebp
  80038b:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80038d:	8b 45 08             	mov    0x8(%ebp),%eax
  800390:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800395:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80039a:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80039f:	5d                   	pop    %ebp
  8003a0:	c3                   	ret    

008003a1 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8003a1:	55                   	push   %ebp
  8003a2:	89 e5                	mov    %esp,%ebp
  8003a4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003a7:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8003ac:	89 c2                	mov    %eax,%edx
  8003ae:	c1 ea 16             	shr    $0x16,%edx
  8003b1:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8003b8:	f6 c2 01             	test   $0x1,%dl
  8003bb:	74 2a                	je     8003e7 <fd_alloc+0x46>
  8003bd:	89 c2                	mov    %eax,%edx
  8003bf:	c1 ea 0c             	shr    $0xc,%edx
  8003c2:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8003c9:	f6 c2 01             	test   $0x1,%dl
  8003cc:	74 19                	je     8003e7 <fd_alloc+0x46>
  8003ce:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8003d3:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8003d8:	75 d2                	jne    8003ac <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8003da:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8003e0:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8003e5:	eb 07                	jmp    8003ee <fd_alloc+0x4d>
			*fd_store = fd;
  8003e7:	89 01                	mov    %eax,(%ecx)
			return 0;
  8003e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8003ee:	5d                   	pop    %ebp
  8003ef:	c3                   	ret    

008003f0 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8003f0:	55                   	push   %ebp
  8003f1:	89 e5                	mov    %esp,%ebp
  8003f3:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8003f6:	83 f8 1f             	cmp    $0x1f,%eax
  8003f9:	77 36                	ja     800431 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8003fb:	c1 e0 0c             	shl    $0xc,%eax
  8003fe:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800403:	89 c2                	mov    %eax,%edx
  800405:	c1 ea 16             	shr    $0x16,%edx
  800408:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80040f:	f6 c2 01             	test   $0x1,%dl
  800412:	74 24                	je     800438 <fd_lookup+0x48>
  800414:	89 c2                	mov    %eax,%edx
  800416:	c1 ea 0c             	shr    $0xc,%edx
  800419:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800420:	f6 c2 01             	test   $0x1,%dl
  800423:	74 1a                	je     80043f <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800425:	8b 55 0c             	mov    0xc(%ebp),%edx
  800428:	89 02                	mov    %eax,(%edx)
	return 0;
  80042a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80042f:	5d                   	pop    %ebp
  800430:	c3                   	ret    
		return -E_INVAL;
  800431:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800436:	eb f7                	jmp    80042f <fd_lookup+0x3f>
		return -E_INVAL;
  800438:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80043d:	eb f0                	jmp    80042f <fd_lookup+0x3f>
  80043f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800444:	eb e9                	jmp    80042f <fd_lookup+0x3f>

00800446 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800446:	55                   	push   %ebp
  800447:	89 e5                	mov    %esp,%ebp
  800449:	83 ec 08             	sub    $0x8,%esp
  80044c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80044f:	ba e0 23 80 00       	mov    $0x8023e0,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800454:	b8 08 30 80 00       	mov    $0x803008,%eax
		if (devtab[i]->dev_id == dev_id) {
  800459:	39 08                	cmp    %ecx,(%eax)
  80045b:	74 33                	je     800490 <dev_lookup+0x4a>
  80045d:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800460:	8b 02                	mov    (%edx),%eax
  800462:	85 c0                	test   %eax,%eax
  800464:	75 f3                	jne    800459 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800466:	a1 08 40 80 00       	mov    0x804008,%eax
  80046b:	8b 40 48             	mov    0x48(%eax),%eax
  80046e:	83 ec 04             	sub    $0x4,%esp
  800471:	51                   	push   %ecx
  800472:	50                   	push   %eax
  800473:	68 64 23 80 00       	push   $0x802364
  800478:	e8 37 11 00 00       	call   8015b4 <cprintf>
	*dev = 0;
  80047d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800480:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800486:	83 c4 10             	add    $0x10,%esp
  800489:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80048e:	c9                   	leave  
  80048f:	c3                   	ret    
			*dev = devtab[i];
  800490:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800493:	89 01                	mov    %eax,(%ecx)
			return 0;
  800495:	b8 00 00 00 00       	mov    $0x0,%eax
  80049a:	eb f2                	jmp    80048e <dev_lookup+0x48>

0080049c <fd_close>:
{
  80049c:	55                   	push   %ebp
  80049d:	89 e5                	mov    %esp,%ebp
  80049f:	57                   	push   %edi
  8004a0:	56                   	push   %esi
  8004a1:	53                   	push   %ebx
  8004a2:	83 ec 1c             	sub    $0x1c,%esp
  8004a5:	8b 75 08             	mov    0x8(%ebp),%esi
  8004a8:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8004ab:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8004ae:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8004af:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8004b5:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8004b8:	50                   	push   %eax
  8004b9:	e8 32 ff ff ff       	call   8003f0 <fd_lookup>
  8004be:	89 c3                	mov    %eax,%ebx
  8004c0:	83 c4 08             	add    $0x8,%esp
  8004c3:	85 c0                	test   %eax,%eax
  8004c5:	78 05                	js     8004cc <fd_close+0x30>
	    || fd != fd2)
  8004c7:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8004ca:	74 16                	je     8004e2 <fd_close+0x46>
		return (must_exist ? r : 0);
  8004cc:	89 f8                	mov    %edi,%eax
  8004ce:	84 c0                	test   %al,%al
  8004d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8004d5:	0f 44 d8             	cmove  %eax,%ebx
}
  8004d8:	89 d8                	mov    %ebx,%eax
  8004da:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004dd:	5b                   	pop    %ebx
  8004de:	5e                   	pop    %esi
  8004df:	5f                   	pop    %edi
  8004e0:	5d                   	pop    %ebp
  8004e1:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8004e2:	83 ec 08             	sub    $0x8,%esp
  8004e5:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8004e8:	50                   	push   %eax
  8004e9:	ff 36                	pushl  (%esi)
  8004eb:	e8 56 ff ff ff       	call   800446 <dev_lookup>
  8004f0:	89 c3                	mov    %eax,%ebx
  8004f2:	83 c4 10             	add    $0x10,%esp
  8004f5:	85 c0                	test   %eax,%eax
  8004f7:	78 15                	js     80050e <fd_close+0x72>
		if (dev->dev_close)
  8004f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004fc:	8b 40 10             	mov    0x10(%eax),%eax
  8004ff:	85 c0                	test   %eax,%eax
  800501:	74 1b                	je     80051e <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  800503:	83 ec 0c             	sub    $0xc,%esp
  800506:	56                   	push   %esi
  800507:	ff d0                	call   *%eax
  800509:	89 c3                	mov    %eax,%ebx
  80050b:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80050e:	83 ec 08             	sub    $0x8,%esp
  800511:	56                   	push   %esi
  800512:	6a 00                	push   $0x0
  800514:	e8 d6 fc ff ff       	call   8001ef <sys_page_unmap>
	return r;
  800519:	83 c4 10             	add    $0x10,%esp
  80051c:	eb ba                	jmp    8004d8 <fd_close+0x3c>
			r = 0;
  80051e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800523:	eb e9                	jmp    80050e <fd_close+0x72>

00800525 <close>:

int
close(int fdnum)
{
  800525:	55                   	push   %ebp
  800526:	89 e5                	mov    %esp,%ebp
  800528:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80052b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80052e:	50                   	push   %eax
  80052f:	ff 75 08             	pushl  0x8(%ebp)
  800532:	e8 b9 fe ff ff       	call   8003f0 <fd_lookup>
  800537:	83 c4 08             	add    $0x8,%esp
  80053a:	85 c0                	test   %eax,%eax
  80053c:	78 10                	js     80054e <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  80053e:	83 ec 08             	sub    $0x8,%esp
  800541:	6a 01                	push   $0x1
  800543:	ff 75 f4             	pushl  -0xc(%ebp)
  800546:	e8 51 ff ff ff       	call   80049c <fd_close>
  80054b:	83 c4 10             	add    $0x10,%esp
}
  80054e:	c9                   	leave  
  80054f:	c3                   	ret    

00800550 <close_all>:

void
close_all(void)
{
  800550:	55                   	push   %ebp
  800551:	89 e5                	mov    %esp,%ebp
  800553:	53                   	push   %ebx
  800554:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800557:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80055c:	83 ec 0c             	sub    $0xc,%esp
  80055f:	53                   	push   %ebx
  800560:	e8 c0 ff ff ff       	call   800525 <close>
	for (i = 0; i < MAXFD; i++)
  800565:	83 c3 01             	add    $0x1,%ebx
  800568:	83 c4 10             	add    $0x10,%esp
  80056b:	83 fb 20             	cmp    $0x20,%ebx
  80056e:	75 ec                	jne    80055c <close_all+0xc>
}
  800570:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800573:	c9                   	leave  
  800574:	c3                   	ret    

00800575 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800575:	55                   	push   %ebp
  800576:	89 e5                	mov    %esp,%ebp
  800578:	57                   	push   %edi
  800579:	56                   	push   %esi
  80057a:	53                   	push   %ebx
  80057b:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80057e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800581:	50                   	push   %eax
  800582:	ff 75 08             	pushl  0x8(%ebp)
  800585:	e8 66 fe ff ff       	call   8003f0 <fd_lookup>
  80058a:	89 c3                	mov    %eax,%ebx
  80058c:	83 c4 08             	add    $0x8,%esp
  80058f:	85 c0                	test   %eax,%eax
  800591:	0f 88 81 00 00 00    	js     800618 <dup+0xa3>
		return r;
	close(newfdnum);
  800597:	83 ec 0c             	sub    $0xc,%esp
  80059a:	ff 75 0c             	pushl  0xc(%ebp)
  80059d:	e8 83 ff ff ff       	call   800525 <close>

	newfd = INDEX2FD(newfdnum);
  8005a2:	8b 75 0c             	mov    0xc(%ebp),%esi
  8005a5:	c1 e6 0c             	shl    $0xc,%esi
  8005a8:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8005ae:	83 c4 04             	add    $0x4,%esp
  8005b1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8005b4:	e8 d1 fd ff ff       	call   80038a <fd2data>
  8005b9:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8005bb:	89 34 24             	mov    %esi,(%esp)
  8005be:	e8 c7 fd ff ff       	call   80038a <fd2data>
  8005c3:	83 c4 10             	add    $0x10,%esp
  8005c6:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8005c8:	89 d8                	mov    %ebx,%eax
  8005ca:	c1 e8 16             	shr    $0x16,%eax
  8005cd:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8005d4:	a8 01                	test   $0x1,%al
  8005d6:	74 11                	je     8005e9 <dup+0x74>
  8005d8:	89 d8                	mov    %ebx,%eax
  8005da:	c1 e8 0c             	shr    $0xc,%eax
  8005dd:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8005e4:	f6 c2 01             	test   $0x1,%dl
  8005e7:	75 39                	jne    800622 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8005e9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8005ec:	89 d0                	mov    %edx,%eax
  8005ee:	c1 e8 0c             	shr    $0xc,%eax
  8005f1:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8005f8:	83 ec 0c             	sub    $0xc,%esp
  8005fb:	25 07 0e 00 00       	and    $0xe07,%eax
  800600:	50                   	push   %eax
  800601:	56                   	push   %esi
  800602:	6a 00                	push   $0x0
  800604:	52                   	push   %edx
  800605:	6a 00                	push   $0x0
  800607:	e8 a1 fb ff ff       	call   8001ad <sys_page_map>
  80060c:	89 c3                	mov    %eax,%ebx
  80060e:	83 c4 20             	add    $0x20,%esp
  800611:	85 c0                	test   %eax,%eax
  800613:	78 31                	js     800646 <dup+0xd1>
		goto err;

	return newfdnum;
  800615:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  800618:	89 d8                	mov    %ebx,%eax
  80061a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80061d:	5b                   	pop    %ebx
  80061e:	5e                   	pop    %esi
  80061f:	5f                   	pop    %edi
  800620:	5d                   	pop    %ebp
  800621:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800622:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800629:	83 ec 0c             	sub    $0xc,%esp
  80062c:	25 07 0e 00 00       	and    $0xe07,%eax
  800631:	50                   	push   %eax
  800632:	57                   	push   %edi
  800633:	6a 00                	push   $0x0
  800635:	53                   	push   %ebx
  800636:	6a 00                	push   $0x0
  800638:	e8 70 fb ff ff       	call   8001ad <sys_page_map>
  80063d:	89 c3                	mov    %eax,%ebx
  80063f:	83 c4 20             	add    $0x20,%esp
  800642:	85 c0                	test   %eax,%eax
  800644:	79 a3                	jns    8005e9 <dup+0x74>
	sys_page_unmap(0, newfd);
  800646:	83 ec 08             	sub    $0x8,%esp
  800649:	56                   	push   %esi
  80064a:	6a 00                	push   $0x0
  80064c:	e8 9e fb ff ff       	call   8001ef <sys_page_unmap>
	sys_page_unmap(0, nva);
  800651:	83 c4 08             	add    $0x8,%esp
  800654:	57                   	push   %edi
  800655:	6a 00                	push   $0x0
  800657:	e8 93 fb ff ff       	call   8001ef <sys_page_unmap>
	return r;
  80065c:	83 c4 10             	add    $0x10,%esp
  80065f:	eb b7                	jmp    800618 <dup+0xa3>

00800661 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800661:	55                   	push   %ebp
  800662:	89 e5                	mov    %esp,%ebp
  800664:	53                   	push   %ebx
  800665:	83 ec 14             	sub    $0x14,%esp
  800668:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80066b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80066e:	50                   	push   %eax
  80066f:	53                   	push   %ebx
  800670:	e8 7b fd ff ff       	call   8003f0 <fd_lookup>
  800675:	83 c4 08             	add    $0x8,%esp
  800678:	85 c0                	test   %eax,%eax
  80067a:	78 3f                	js     8006bb <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80067c:	83 ec 08             	sub    $0x8,%esp
  80067f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800682:	50                   	push   %eax
  800683:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800686:	ff 30                	pushl  (%eax)
  800688:	e8 b9 fd ff ff       	call   800446 <dev_lookup>
  80068d:	83 c4 10             	add    $0x10,%esp
  800690:	85 c0                	test   %eax,%eax
  800692:	78 27                	js     8006bb <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800694:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800697:	8b 42 08             	mov    0x8(%edx),%eax
  80069a:	83 e0 03             	and    $0x3,%eax
  80069d:	83 f8 01             	cmp    $0x1,%eax
  8006a0:	74 1e                	je     8006c0 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8006a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006a5:	8b 40 08             	mov    0x8(%eax),%eax
  8006a8:	85 c0                	test   %eax,%eax
  8006aa:	74 35                	je     8006e1 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8006ac:	83 ec 04             	sub    $0x4,%esp
  8006af:	ff 75 10             	pushl  0x10(%ebp)
  8006b2:	ff 75 0c             	pushl  0xc(%ebp)
  8006b5:	52                   	push   %edx
  8006b6:	ff d0                	call   *%eax
  8006b8:	83 c4 10             	add    $0x10,%esp
}
  8006bb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006be:	c9                   	leave  
  8006bf:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8006c0:	a1 08 40 80 00       	mov    0x804008,%eax
  8006c5:	8b 40 48             	mov    0x48(%eax),%eax
  8006c8:	83 ec 04             	sub    $0x4,%esp
  8006cb:	53                   	push   %ebx
  8006cc:	50                   	push   %eax
  8006cd:	68 a5 23 80 00       	push   $0x8023a5
  8006d2:	e8 dd 0e 00 00       	call   8015b4 <cprintf>
		return -E_INVAL;
  8006d7:	83 c4 10             	add    $0x10,%esp
  8006da:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8006df:	eb da                	jmp    8006bb <read+0x5a>
		return -E_NOT_SUPP;
  8006e1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8006e6:	eb d3                	jmp    8006bb <read+0x5a>

008006e8 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8006e8:	55                   	push   %ebp
  8006e9:	89 e5                	mov    %esp,%ebp
  8006eb:	57                   	push   %edi
  8006ec:	56                   	push   %esi
  8006ed:	53                   	push   %ebx
  8006ee:	83 ec 0c             	sub    $0xc,%esp
  8006f1:	8b 7d 08             	mov    0x8(%ebp),%edi
  8006f4:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8006f7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006fc:	39 f3                	cmp    %esi,%ebx
  8006fe:	73 25                	jae    800725 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800700:	83 ec 04             	sub    $0x4,%esp
  800703:	89 f0                	mov    %esi,%eax
  800705:	29 d8                	sub    %ebx,%eax
  800707:	50                   	push   %eax
  800708:	89 d8                	mov    %ebx,%eax
  80070a:	03 45 0c             	add    0xc(%ebp),%eax
  80070d:	50                   	push   %eax
  80070e:	57                   	push   %edi
  80070f:	e8 4d ff ff ff       	call   800661 <read>
		if (m < 0)
  800714:	83 c4 10             	add    $0x10,%esp
  800717:	85 c0                	test   %eax,%eax
  800719:	78 08                	js     800723 <readn+0x3b>
			return m;
		if (m == 0)
  80071b:	85 c0                	test   %eax,%eax
  80071d:	74 06                	je     800725 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  80071f:	01 c3                	add    %eax,%ebx
  800721:	eb d9                	jmp    8006fc <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800723:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  800725:	89 d8                	mov    %ebx,%eax
  800727:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80072a:	5b                   	pop    %ebx
  80072b:	5e                   	pop    %esi
  80072c:	5f                   	pop    %edi
  80072d:	5d                   	pop    %ebp
  80072e:	c3                   	ret    

0080072f <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80072f:	55                   	push   %ebp
  800730:	89 e5                	mov    %esp,%ebp
  800732:	53                   	push   %ebx
  800733:	83 ec 14             	sub    $0x14,%esp
  800736:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800739:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80073c:	50                   	push   %eax
  80073d:	53                   	push   %ebx
  80073e:	e8 ad fc ff ff       	call   8003f0 <fd_lookup>
  800743:	83 c4 08             	add    $0x8,%esp
  800746:	85 c0                	test   %eax,%eax
  800748:	78 3a                	js     800784 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80074a:	83 ec 08             	sub    $0x8,%esp
  80074d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800750:	50                   	push   %eax
  800751:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800754:	ff 30                	pushl  (%eax)
  800756:	e8 eb fc ff ff       	call   800446 <dev_lookup>
  80075b:	83 c4 10             	add    $0x10,%esp
  80075e:	85 c0                	test   %eax,%eax
  800760:	78 22                	js     800784 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800762:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800765:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800769:	74 1e                	je     800789 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80076b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80076e:	8b 52 0c             	mov    0xc(%edx),%edx
  800771:	85 d2                	test   %edx,%edx
  800773:	74 35                	je     8007aa <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  800775:	83 ec 04             	sub    $0x4,%esp
  800778:	ff 75 10             	pushl  0x10(%ebp)
  80077b:	ff 75 0c             	pushl  0xc(%ebp)
  80077e:	50                   	push   %eax
  80077f:	ff d2                	call   *%edx
  800781:	83 c4 10             	add    $0x10,%esp
}
  800784:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800787:	c9                   	leave  
  800788:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800789:	a1 08 40 80 00       	mov    0x804008,%eax
  80078e:	8b 40 48             	mov    0x48(%eax),%eax
  800791:	83 ec 04             	sub    $0x4,%esp
  800794:	53                   	push   %ebx
  800795:	50                   	push   %eax
  800796:	68 c1 23 80 00       	push   $0x8023c1
  80079b:	e8 14 0e 00 00       	call   8015b4 <cprintf>
		return -E_INVAL;
  8007a0:	83 c4 10             	add    $0x10,%esp
  8007a3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007a8:	eb da                	jmp    800784 <write+0x55>
		return -E_NOT_SUPP;
  8007aa:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8007af:	eb d3                	jmp    800784 <write+0x55>

008007b1 <seek>:

int
seek(int fdnum, off_t offset)
{
  8007b1:	55                   	push   %ebp
  8007b2:	89 e5                	mov    %esp,%ebp
  8007b4:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8007b7:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8007ba:	50                   	push   %eax
  8007bb:	ff 75 08             	pushl  0x8(%ebp)
  8007be:	e8 2d fc ff ff       	call   8003f0 <fd_lookup>
  8007c3:	83 c4 08             	add    $0x8,%esp
  8007c6:	85 c0                	test   %eax,%eax
  8007c8:	78 0e                	js     8007d8 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8007ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8007d0:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8007d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8007d8:	c9                   	leave  
  8007d9:	c3                   	ret    

008007da <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8007da:	55                   	push   %ebp
  8007db:	89 e5                	mov    %esp,%ebp
  8007dd:	53                   	push   %ebx
  8007de:	83 ec 14             	sub    $0x14,%esp
  8007e1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8007e4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8007e7:	50                   	push   %eax
  8007e8:	53                   	push   %ebx
  8007e9:	e8 02 fc ff ff       	call   8003f0 <fd_lookup>
  8007ee:	83 c4 08             	add    $0x8,%esp
  8007f1:	85 c0                	test   %eax,%eax
  8007f3:	78 37                	js     80082c <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8007f5:	83 ec 08             	sub    $0x8,%esp
  8007f8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8007fb:	50                   	push   %eax
  8007fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007ff:	ff 30                	pushl  (%eax)
  800801:	e8 40 fc ff ff       	call   800446 <dev_lookup>
  800806:	83 c4 10             	add    $0x10,%esp
  800809:	85 c0                	test   %eax,%eax
  80080b:	78 1f                	js     80082c <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80080d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800810:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800814:	74 1b                	je     800831 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  800816:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800819:	8b 52 18             	mov    0x18(%edx),%edx
  80081c:	85 d2                	test   %edx,%edx
  80081e:	74 32                	je     800852 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  800820:	83 ec 08             	sub    $0x8,%esp
  800823:	ff 75 0c             	pushl  0xc(%ebp)
  800826:	50                   	push   %eax
  800827:	ff d2                	call   *%edx
  800829:	83 c4 10             	add    $0x10,%esp
}
  80082c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80082f:	c9                   	leave  
  800830:	c3                   	ret    
			thisenv->env_id, fdnum);
  800831:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800836:	8b 40 48             	mov    0x48(%eax),%eax
  800839:	83 ec 04             	sub    $0x4,%esp
  80083c:	53                   	push   %ebx
  80083d:	50                   	push   %eax
  80083e:	68 84 23 80 00       	push   $0x802384
  800843:	e8 6c 0d 00 00       	call   8015b4 <cprintf>
		return -E_INVAL;
  800848:	83 c4 10             	add    $0x10,%esp
  80084b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800850:	eb da                	jmp    80082c <ftruncate+0x52>
		return -E_NOT_SUPP;
  800852:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800857:	eb d3                	jmp    80082c <ftruncate+0x52>

00800859 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800859:	55                   	push   %ebp
  80085a:	89 e5                	mov    %esp,%ebp
  80085c:	53                   	push   %ebx
  80085d:	83 ec 14             	sub    $0x14,%esp
  800860:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800863:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800866:	50                   	push   %eax
  800867:	ff 75 08             	pushl  0x8(%ebp)
  80086a:	e8 81 fb ff ff       	call   8003f0 <fd_lookup>
  80086f:	83 c4 08             	add    $0x8,%esp
  800872:	85 c0                	test   %eax,%eax
  800874:	78 4b                	js     8008c1 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800876:	83 ec 08             	sub    $0x8,%esp
  800879:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80087c:	50                   	push   %eax
  80087d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800880:	ff 30                	pushl  (%eax)
  800882:	e8 bf fb ff ff       	call   800446 <dev_lookup>
  800887:	83 c4 10             	add    $0x10,%esp
  80088a:	85 c0                	test   %eax,%eax
  80088c:	78 33                	js     8008c1 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80088e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800891:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  800895:	74 2f                	je     8008c6 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800897:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80089a:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8008a1:	00 00 00 
	stat->st_isdir = 0;
  8008a4:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8008ab:	00 00 00 
	stat->st_dev = dev;
  8008ae:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8008b4:	83 ec 08             	sub    $0x8,%esp
  8008b7:	53                   	push   %ebx
  8008b8:	ff 75 f0             	pushl  -0x10(%ebp)
  8008bb:	ff 50 14             	call   *0x14(%eax)
  8008be:	83 c4 10             	add    $0x10,%esp
}
  8008c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008c4:	c9                   	leave  
  8008c5:	c3                   	ret    
		return -E_NOT_SUPP;
  8008c6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8008cb:	eb f4                	jmp    8008c1 <fstat+0x68>

008008cd <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8008cd:	55                   	push   %ebp
  8008ce:	89 e5                	mov    %esp,%ebp
  8008d0:	56                   	push   %esi
  8008d1:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8008d2:	83 ec 08             	sub    $0x8,%esp
  8008d5:	6a 00                	push   $0x0
  8008d7:	ff 75 08             	pushl  0x8(%ebp)
  8008da:	e8 26 02 00 00       	call   800b05 <open>
  8008df:	89 c3                	mov    %eax,%ebx
  8008e1:	83 c4 10             	add    $0x10,%esp
  8008e4:	85 c0                	test   %eax,%eax
  8008e6:	78 1b                	js     800903 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8008e8:	83 ec 08             	sub    $0x8,%esp
  8008eb:	ff 75 0c             	pushl  0xc(%ebp)
  8008ee:	50                   	push   %eax
  8008ef:	e8 65 ff ff ff       	call   800859 <fstat>
  8008f4:	89 c6                	mov    %eax,%esi
	close(fd);
  8008f6:	89 1c 24             	mov    %ebx,(%esp)
  8008f9:	e8 27 fc ff ff       	call   800525 <close>
	return r;
  8008fe:	83 c4 10             	add    $0x10,%esp
  800901:	89 f3                	mov    %esi,%ebx
}
  800903:	89 d8                	mov    %ebx,%eax
  800905:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800908:	5b                   	pop    %ebx
  800909:	5e                   	pop    %esi
  80090a:	5d                   	pop    %ebp
  80090b:	c3                   	ret    

0080090c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80090c:	55                   	push   %ebp
  80090d:	89 e5                	mov    %esp,%ebp
  80090f:	56                   	push   %esi
  800910:	53                   	push   %ebx
  800911:	89 c6                	mov    %eax,%esi
  800913:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  800915:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80091c:	74 27                	je     800945 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80091e:	6a 07                	push   $0x7
  800920:	68 00 50 80 00       	push   $0x805000
  800925:	56                   	push   %esi
  800926:	ff 35 00 40 80 00    	pushl  0x804000
  80092c:	e8 c6 16 00 00       	call   801ff7 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  800931:	83 c4 0c             	add    $0xc,%esp
  800934:	6a 00                	push   $0x0
  800936:	53                   	push   %ebx
  800937:	6a 00                	push   $0x0
  800939:	e8 50 16 00 00       	call   801f8e <ipc_recv>
}
  80093e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800941:	5b                   	pop    %ebx
  800942:	5e                   	pop    %esi
  800943:	5d                   	pop    %ebp
  800944:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800945:	83 ec 0c             	sub    $0xc,%esp
  800948:	6a 01                	push   $0x1
  80094a:	e8 01 17 00 00       	call   802050 <ipc_find_env>
  80094f:	a3 00 40 80 00       	mov    %eax,0x804000
  800954:	83 c4 10             	add    $0x10,%esp
  800957:	eb c5                	jmp    80091e <fsipc+0x12>

00800959 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  800959:	55                   	push   %ebp
  80095a:	89 e5                	mov    %esp,%ebp
  80095c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80095f:	8b 45 08             	mov    0x8(%ebp),%eax
  800962:	8b 40 0c             	mov    0xc(%eax),%eax
  800965:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80096a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80096d:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  800972:	ba 00 00 00 00       	mov    $0x0,%edx
  800977:	b8 02 00 00 00       	mov    $0x2,%eax
  80097c:	e8 8b ff ff ff       	call   80090c <fsipc>
}
  800981:	c9                   	leave  
  800982:	c3                   	ret    

00800983 <devfile_flush>:
{
  800983:	55                   	push   %ebp
  800984:	89 e5                	mov    %esp,%ebp
  800986:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800989:	8b 45 08             	mov    0x8(%ebp),%eax
  80098c:	8b 40 0c             	mov    0xc(%eax),%eax
  80098f:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800994:	ba 00 00 00 00       	mov    $0x0,%edx
  800999:	b8 06 00 00 00       	mov    $0x6,%eax
  80099e:	e8 69 ff ff ff       	call   80090c <fsipc>
}
  8009a3:	c9                   	leave  
  8009a4:	c3                   	ret    

008009a5 <devfile_stat>:
{
  8009a5:	55                   	push   %ebp
  8009a6:	89 e5                	mov    %esp,%ebp
  8009a8:	53                   	push   %ebx
  8009a9:	83 ec 04             	sub    $0x4,%esp
  8009ac:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8009af:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b2:	8b 40 0c             	mov    0xc(%eax),%eax
  8009b5:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8009ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8009bf:	b8 05 00 00 00       	mov    $0x5,%eax
  8009c4:	e8 43 ff ff ff       	call   80090c <fsipc>
  8009c9:	85 c0                	test   %eax,%eax
  8009cb:	78 2c                	js     8009f9 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8009cd:	83 ec 08             	sub    $0x8,%esp
  8009d0:	68 00 50 80 00       	push   $0x805000
  8009d5:	53                   	push   %ebx
  8009d6:	e8 76 12 00 00       	call   801c51 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8009db:	a1 80 50 80 00       	mov    0x805080,%eax
  8009e0:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8009e6:	a1 84 50 80 00       	mov    0x805084,%eax
  8009eb:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8009f1:	83 c4 10             	add    $0x10,%esp
  8009f4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009f9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009fc:	c9                   	leave  
  8009fd:	c3                   	ret    

008009fe <devfile_write>:
{
  8009fe:	55                   	push   %ebp
  8009ff:	89 e5                	mov    %esp,%ebp
  800a01:	53                   	push   %ebx
  800a02:	83 ec 04             	sub    $0x4,%esp
  800a05:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  800a08:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0b:	8b 40 0c             	mov    0xc(%eax),%eax
  800a0e:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  800a13:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  800a19:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  800a1f:	77 30                	ja     800a51 <devfile_write+0x53>
	memmove(fsipcbuf.write.req_buf, buf, n);
  800a21:	83 ec 04             	sub    $0x4,%esp
  800a24:	53                   	push   %ebx
  800a25:	ff 75 0c             	pushl  0xc(%ebp)
  800a28:	68 08 50 80 00       	push   $0x805008
  800a2d:	e8 ad 13 00 00       	call   801ddf <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  800a32:	ba 00 00 00 00       	mov    $0x0,%edx
  800a37:	b8 04 00 00 00       	mov    $0x4,%eax
  800a3c:	e8 cb fe ff ff       	call   80090c <fsipc>
  800a41:	83 c4 10             	add    $0x10,%esp
  800a44:	85 c0                	test   %eax,%eax
  800a46:	78 04                	js     800a4c <devfile_write+0x4e>
	assert(r <= n);
  800a48:	39 d8                	cmp    %ebx,%eax
  800a4a:	77 1e                	ja     800a6a <devfile_write+0x6c>
}
  800a4c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a4f:	c9                   	leave  
  800a50:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  800a51:	68 f4 23 80 00       	push   $0x8023f4
  800a56:	68 21 24 80 00       	push   $0x802421
  800a5b:	68 94 00 00 00       	push   $0x94
  800a60:	68 36 24 80 00       	push   $0x802436
  800a65:	e8 6f 0a 00 00       	call   8014d9 <_panic>
	assert(r <= n);
  800a6a:	68 41 24 80 00       	push   $0x802441
  800a6f:	68 21 24 80 00       	push   $0x802421
  800a74:	68 98 00 00 00       	push   $0x98
  800a79:	68 36 24 80 00       	push   $0x802436
  800a7e:	e8 56 0a 00 00       	call   8014d9 <_panic>

00800a83 <devfile_read>:
{
  800a83:	55                   	push   %ebp
  800a84:	89 e5                	mov    %esp,%ebp
  800a86:	56                   	push   %esi
  800a87:	53                   	push   %ebx
  800a88:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800a8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8e:	8b 40 0c             	mov    0xc(%eax),%eax
  800a91:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800a96:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800a9c:	ba 00 00 00 00       	mov    $0x0,%edx
  800aa1:	b8 03 00 00 00       	mov    $0x3,%eax
  800aa6:	e8 61 fe ff ff       	call   80090c <fsipc>
  800aab:	89 c3                	mov    %eax,%ebx
  800aad:	85 c0                	test   %eax,%eax
  800aaf:	78 1f                	js     800ad0 <devfile_read+0x4d>
	assert(r <= n);
  800ab1:	39 f0                	cmp    %esi,%eax
  800ab3:	77 24                	ja     800ad9 <devfile_read+0x56>
	assert(r <= PGSIZE);
  800ab5:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800aba:	7f 33                	jg     800aef <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800abc:	83 ec 04             	sub    $0x4,%esp
  800abf:	50                   	push   %eax
  800ac0:	68 00 50 80 00       	push   $0x805000
  800ac5:	ff 75 0c             	pushl  0xc(%ebp)
  800ac8:	e8 12 13 00 00       	call   801ddf <memmove>
	return r;
  800acd:	83 c4 10             	add    $0x10,%esp
}
  800ad0:	89 d8                	mov    %ebx,%eax
  800ad2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ad5:	5b                   	pop    %ebx
  800ad6:	5e                   	pop    %esi
  800ad7:	5d                   	pop    %ebp
  800ad8:	c3                   	ret    
	assert(r <= n);
  800ad9:	68 41 24 80 00       	push   $0x802441
  800ade:	68 21 24 80 00       	push   $0x802421
  800ae3:	6a 7c                	push   $0x7c
  800ae5:	68 36 24 80 00       	push   $0x802436
  800aea:	e8 ea 09 00 00       	call   8014d9 <_panic>
	assert(r <= PGSIZE);
  800aef:	68 48 24 80 00       	push   $0x802448
  800af4:	68 21 24 80 00       	push   $0x802421
  800af9:	6a 7d                	push   $0x7d
  800afb:	68 36 24 80 00       	push   $0x802436
  800b00:	e8 d4 09 00 00       	call   8014d9 <_panic>

00800b05 <open>:
{
  800b05:	55                   	push   %ebp
  800b06:	89 e5                	mov    %esp,%ebp
  800b08:	56                   	push   %esi
  800b09:	53                   	push   %ebx
  800b0a:	83 ec 1c             	sub    $0x1c,%esp
  800b0d:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800b10:	56                   	push   %esi
  800b11:	e8 04 11 00 00       	call   801c1a <strlen>
  800b16:	83 c4 10             	add    $0x10,%esp
  800b19:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800b1e:	7f 6c                	jg     800b8c <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  800b20:	83 ec 0c             	sub    $0xc,%esp
  800b23:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800b26:	50                   	push   %eax
  800b27:	e8 75 f8 ff ff       	call   8003a1 <fd_alloc>
  800b2c:	89 c3                	mov    %eax,%ebx
  800b2e:	83 c4 10             	add    $0x10,%esp
  800b31:	85 c0                	test   %eax,%eax
  800b33:	78 3c                	js     800b71 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  800b35:	83 ec 08             	sub    $0x8,%esp
  800b38:	56                   	push   %esi
  800b39:	68 00 50 80 00       	push   $0x805000
  800b3e:	e8 0e 11 00 00       	call   801c51 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800b43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b46:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800b4b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b4e:	b8 01 00 00 00       	mov    $0x1,%eax
  800b53:	e8 b4 fd ff ff       	call   80090c <fsipc>
  800b58:	89 c3                	mov    %eax,%ebx
  800b5a:	83 c4 10             	add    $0x10,%esp
  800b5d:	85 c0                	test   %eax,%eax
  800b5f:	78 19                	js     800b7a <open+0x75>
	return fd2num(fd);
  800b61:	83 ec 0c             	sub    $0xc,%esp
  800b64:	ff 75 f4             	pushl  -0xc(%ebp)
  800b67:	e8 0e f8 ff ff       	call   80037a <fd2num>
  800b6c:	89 c3                	mov    %eax,%ebx
  800b6e:	83 c4 10             	add    $0x10,%esp
}
  800b71:	89 d8                	mov    %ebx,%eax
  800b73:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b76:	5b                   	pop    %ebx
  800b77:	5e                   	pop    %esi
  800b78:	5d                   	pop    %ebp
  800b79:	c3                   	ret    
		fd_close(fd, 0);
  800b7a:	83 ec 08             	sub    $0x8,%esp
  800b7d:	6a 00                	push   $0x0
  800b7f:	ff 75 f4             	pushl  -0xc(%ebp)
  800b82:	e8 15 f9 ff ff       	call   80049c <fd_close>
		return r;
  800b87:	83 c4 10             	add    $0x10,%esp
  800b8a:	eb e5                	jmp    800b71 <open+0x6c>
		return -E_BAD_PATH;
  800b8c:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800b91:	eb de                	jmp    800b71 <open+0x6c>

00800b93 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800b93:	55                   	push   %ebp
  800b94:	89 e5                	mov    %esp,%ebp
  800b96:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800b99:	ba 00 00 00 00       	mov    $0x0,%edx
  800b9e:	b8 08 00 00 00       	mov    $0x8,%eax
  800ba3:	e8 64 fd ff ff       	call   80090c <fsipc>
}
  800ba8:	c9                   	leave  
  800ba9:	c3                   	ret    

00800baa <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800baa:	55                   	push   %ebp
  800bab:	89 e5                	mov    %esp,%ebp
  800bad:	56                   	push   %esi
  800bae:	53                   	push   %ebx
  800baf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800bb2:	83 ec 0c             	sub    $0xc,%esp
  800bb5:	ff 75 08             	pushl  0x8(%ebp)
  800bb8:	e8 cd f7 ff ff       	call   80038a <fd2data>
  800bbd:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  800bbf:	83 c4 08             	add    $0x8,%esp
  800bc2:	68 54 24 80 00       	push   $0x802454
  800bc7:	53                   	push   %ebx
  800bc8:	e8 84 10 00 00       	call   801c51 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  800bcd:	8b 46 04             	mov    0x4(%esi),%eax
  800bd0:	2b 06                	sub    (%esi),%eax
  800bd2:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  800bd8:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800bdf:	00 00 00 
	stat->st_dev = &devpipe;
  800be2:	c7 83 88 00 00 00 24 	movl   $0x803024,0x88(%ebx)
  800be9:	30 80 00 
	return 0;
}
  800bec:	b8 00 00 00 00       	mov    $0x0,%eax
  800bf1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bf4:	5b                   	pop    %ebx
  800bf5:	5e                   	pop    %esi
  800bf6:	5d                   	pop    %ebp
  800bf7:	c3                   	ret    

00800bf8 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  800bf8:	55                   	push   %ebp
  800bf9:	89 e5                	mov    %esp,%ebp
  800bfb:	53                   	push   %ebx
  800bfc:	83 ec 0c             	sub    $0xc,%esp
  800bff:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  800c02:	53                   	push   %ebx
  800c03:	6a 00                	push   $0x0
  800c05:	e8 e5 f5 ff ff       	call   8001ef <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  800c0a:	89 1c 24             	mov    %ebx,(%esp)
  800c0d:	e8 78 f7 ff ff       	call   80038a <fd2data>
  800c12:	83 c4 08             	add    $0x8,%esp
  800c15:	50                   	push   %eax
  800c16:	6a 00                	push   $0x0
  800c18:	e8 d2 f5 ff ff       	call   8001ef <sys_page_unmap>
}
  800c1d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c20:	c9                   	leave  
  800c21:	c3                   	ret    

00800c22 <_pipeisclosed>:
{
  800c22:	55                   	push   %ebp
  800c23:	89 e5                	mov    %esp,%ebp
  800c25:	57                   	push   %edi
  800c26:	56                   	push   %esi
  800c27:	53                   	push   %ebx
  800c28:	83 ec 1c             	sub    $0x1c,%esp
  800c2b:	89 c7                	mov    %eax,%edi
  800c2d:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  800c2f:	a1 08 40 80 00       	mov    0x804008,%eax
  800c34:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  800c37:	83 ec 0c             	sub    $0xc,%esp
  800c3a:	57                   	push   %edi
  800c3b:	e8 49 14 00 00       	call   802089 <pageref>
  800c40:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c43:	89 34 24             	mov    %esi,(%esp)
  800c46:	e8 3e 14 00 00       	call   802089 <pageref>
		nn = thisenv->env_runs;
  800c4b:	8b 15 08 40 80 00    	mov    0x804008,%edx
  800c51:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  800c54:	83 c4 10             	add    $0x10,%esp
  800c57:	39 cb                	cmp    %ecx,%ebx
  800c59:	74 1b                	je     800c76 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  800c5b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800c5e:	75 cf                	jne    800c2f <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  800c60:	8b 42 58             	mov    0x58(%edx),%eax
  800c63:	6a 01                	push   $0x1
  800c65:	50                   	push   %eax
  800c66:	53                   	push   %ebx
  800c67:	68 5b 24 80 00       	push   $0x80245b
  800c6c:	e8 43 09 00 00       	call   8015b4 <cprintf>
  800c71:	83 c4 10             	add    $0x10,%esp
  800c74:	eb b9                	jmp    800c2f <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  800c76:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800c79:	0f 94 c0             	sete   %al
  800c7c:	0f b6 c0             	movzbl %al,%eax
}
  800c7f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c82:	5b                   	pop    %ebx
  800c83:	5e                   	pop    %esi
  800c84:	5f                   	pop    %edi
  800c85:	5d                   	pop    %ebp
  800c86:	c3                   	ret    

00800c87 <devpipe_write>:
{
  800c87:	55                   	push   %ebp
  800c88:	89 e5                	mov    %esp,%ebp
  800c8a:	57                   	push   %edi
  800c8b:	56                   	push   %esi
  800c8c:	53                   	push   %ebx
  800c8d:	83 ec 28             	sub    $0x28,%esp
  800c90:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  800c93:	56                   	push   %esi
  800c94:	e8 f1 f6 ff ff       	call   80038a <fd2data>
  800c99:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800c9b:	83 c4 10             	add    $0x10,%esp
  800c9e:	bf 00 00 00 00       	mov    $0x0,%edi
  800ca3:	3b 7d 10             	cmp    0x10(%ebp),%edi
  800ca6:	74 4f                	je     800cf7 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  800ca8:	8b 43 04             	mov    0x4(%ebx),%eax
  800cab:	8b 0b                	mov    (%ebx),%ecx
  800cad:	8d 51 20             	lea    0x20(%ecx),%edx
  800cb0:	39 d0                	cmp    %edx,%eax
  800cb2:	72 14                	jb     800cc8 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  800cb4:	89 da                	mov    %ebx,%edx
  800cb6:	89 f0                	mov    %esi,%eax
  800cb8:	e8 65 ff ff ff       	call   800c22 <_pipeisclosed>
  800cbd:	85 c0                	test   %eax,%eax
  800cbf:	75 3a                	jne    800cfb <devpipe_write+0x74>
			sys_yield();
  800cc1:	e8 85 f4 ff ff       	call   80014b <sys_yield>
  800cc6:	eb e0                	jmp    800ca8 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  800cc8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ccb:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  800ccf:	88 4d e7             	mov    %cl,-0x19(%ebp)
  800cd2:	89 c2                	mov    %eax,%edx
  800cd4:	c1 fa 1f             	sar    $0x1f,%edx
  800cd7:	89 d1                	mov    %edx,%ecx
  800cd9:	c1 e9 1b             	shr    $0x1b,%ecx
  800cdc:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  800cdf:	83 e2 1f             	and    $0x1f,%edx
  800ce2:	29 ca                	sub    %ecx,%edx
  800ce4:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  800ce8:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  800cec:	83 c0 01             	add    $0x1,%eax
  800cef:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  800cf2:	83 c7 01             	add    $0x1,%edi
  800cf5:	eb ac                	jmp    800ca3 <devpipe_write+0x1c>
	return i;
  800cf7:	89 f8                	mov    %edi,%eax
  800cf9:	eb 05                	jmp    800d00 <devpipe_write+0x79>
				return 0;
  800cfb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d00:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d03:	5b                   	pop    %ebx
  800d04:	5e                   	pop    %esi
  800d05:	5f                   	pop    %edi
  800d06:	5d                   	pop    %ebp
  800d07:	c3                   	ret    

00800d08 <devpipe_read>:
{
  800d08:	55                   	push   %ebp
  800d09:	89 e5                	mov    %esp,%ebp
  800d0b:	57                   	push   %edi
  800d0c:	56                   	push   %esi
  800d0d:	53                   	push   %ebx
  800d0e:	83 ec 18             	sub    $0x18,%esp
  800d11:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  800d14:	57                   	push   %edi
  800d15:	e8 70 f6 ff ff       	call   80038a <fd2data>
  800d1a:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800d1c:	83 c4 10             	add    $0x10,%esp
  800d1f:	be 00 00 00 00       	mov    $0x0,%esi
  800d24:	3b 75 10             	cmp    0x10(%ebp),%esi
  800d27:	74 47                	je     800d70 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  800d29:	8b 03                	mov    (%ebx),%eax
  800d2b:	3b 43 04             	cmp    0x4(%ebx),%eax
  800d2e:	75 22                	jne    800d52 <devpipe_read+0x4a>
			if (i > 0)
  800d30:	85 f6                	test   %esi,%esi
  800d32:	75 14                	jne    800d48 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  800d34:	89 da                	mov    %ebx,%edx
  800d36:	89 f8                	mov    %edi,%eax
  800d38:	e8 e5 fe ff ff       	call   800c22 <_pipeisclosed>
  800d3d:	85 c0                	test   %eax,%eax
  800d3f:	75 33                	jne    800d74 <devpipe_read+0x6c>
			sys_yield();
  800d41:	e8 05 f4 ff ff       	call   80014b <sys_yield>
  800d46:	eb e1                	jmp    800d29 <devpipe_read+0x21>
				return i;
  800d48:	89 f0                	mov    %esi,%eax
}
  800d4a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d4d:	5b                   	pop    %ebx
  800d4e:	5e                   	pop    %esi
  800d4f:	5f                   	pop    %edi
  800d50:	5d                   	pop    %ebp
  800d51:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  800d52:	99                   	cltd   
  800d53:	c1 ea 1b             	shr    $0x1b,%edx
  800d56:	01 d0                	add    %edx,%eax
  800d58:	83 e0 1f             	and    $0x1f,%eax
  800d5b:	29 d0                	sub    %edx,%eax
  800d5d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  800d62:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d65:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  800d68:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  800d6b:	83 c6 01             	add    $0x1,%esi
  800d6e:	eb b4                	jmp    800d24 <devpipe_read+0x1c>
	return i;
  800d70:	89 f0                	mov    %esi,%eax
  800d72:	eb d6                	jmp    800d4a <devpipe_read+0x42>
				return 0;
  800d74:	b8 00 00 00 00       	mov    $0x0,%eax
  800d79:	eb cf                	jmp    800d4a <devpipe_read+0x42>

00800d7b <pipe>:
{
  800d7b:	55                   	push   %ebp
  800d7c:	89 e5                	mov    %esp,%ebp
  800d7e:	56                   	push   %esi
  800d7f:	53                   	push   %ebx
  800d80:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  800d83:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800d86:	50                   	push   %eax
  800d87:	e8 15 f6 ff ff       	call   8003a1 <fd_alloc>
  800d8c:	89 c3                	mov    %eax,%ebx
  800d8e:	83 c4 10             	add    $0x10,%esp
  800d91:	85 c0                	test   %eax,%eax
  800d93:	78 5b                	js     800df0 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800d95:	83 ec 04             	sub    $0x4,%esp
  800d98:	68 07 04 00 00       	push   $0x407
  800d9d:	ff 75 f4             	pushl  -0xc(%ebp)
  800da0:	6a 00                	push   $0x0
  800da2:	e8 c3 f3 ff ff       	call   80016a <sys_page_alloc>
  800da7:	89 c3                	mov    %eax,%ebx
  800da9:	83 c4 10             	add    $0x10,%esp
  800dac:	85 c0                	test   %eax,%eax
  800dae:	78 40                	js     800df0 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  800db0:	83 ec 0c             	sub    $0xc,%esp
  800db3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800db6:	50                   	push   %eax
  800db7:	e8 e5 f5 ff ff       	call   8003a1 <fd_alloc>
  800dbc:	89 c3                	mov    %eax,%ebx
  800dbe:	83 c4 10             	add    $0x10,%esp
  800dc1:	85 c0                	test   %eax,%eax
  800dc3:	78 1b                	js     800de0 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800dc5:	83 ec 04             	sub    $0x4,%esp
  800dc8:	68 07 04 00 00       	push   $0x407
  800dcd:	ff 75 f0             	pushl  -0x10(%ebp)
  800dd0:	6a 00                	push   $0x0
  800dd2:	e8 93 f3 ff ff       	call   80016a <sys_page_alloc>
  800dd7:	89 c3                	mov    %eax,%ebx
  800dd9:	83 c4 10             	add    $0x10,%esp
  800ddc:	85 c0                	test   %eax,%eax
  800dde:	79 19                	jns    800df9 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  800de0:	83 ec 08             	sub    $0x8,%esp
  800de3:	ff 75 f4             	pushl  -0xc(%ebp)
  800de6:	6a 00                	push   $0x0
  800de8:	e8 02 f4 ff ff       	call   8001ef <sys_page_unmap>
  800ded:	83 c4 10             	add    $0x10,%esp
}
  800df0:	89 d8                	mov    %ebx,%eax
  800df2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800df5:	5b                   	pop    %ebx
  800df6:	5e                   	pop    %esi
  800df7:	5d                   	pop    %ebp
  800df8:	c3                   	ret    
	va = fd2data(fd0);
  800df9:	83 ec 0c             	sub    $0xc,%esp
  800dfc:	ff 75 f4             	pushl  -0xc(%ebp)
  800dff:	e8 86 f5 ff ff       	call   80038a <fd2data>
  800e04:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e06:	83 c4 0c             	add    $0xc,%esp
  800e09:	68 07 04 00 00       	push   $0x407
  800e0e:	50                   	push   %eax
  800e0f:	6a 00                	push   $0x0
  800e11:	e8 54 f3 ff ff       	call   80016a <sys_page_alloc>
  800e16:	89 c3                	mov    %eax,%ebx
  800e18:	83 c4 10             	add    $0x10,%esp
  800e1b:	85 c0                	test   %eax,%eax
  800e1d:	0f 88 8c 00 00 00    	js     800eaf <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e23:	83 ec 0c             	sub    $0xc,%esp
  800e26:	ff 75 f0             	pushl  -0x10(%ebp)
  800e29:	e8 5c f5 ff ff       	call   80038a <fd2data>
  800e2e:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  800e35:	50                   	push   %eax
  800e36:	6a 00                	push   $0x0
  800e38:	56                   	push   %esi
  800e39:	6a 00                	push   $0x0
  800e3b:	e8 6d f3 ff ff       	call   8001ad <sys_page_map>
  800e40:	89 c3                	mov    %eax,%ebx
  800e42:	83 c4 20             	add    $0x20,%esp
  800e45:	85 c0                	test   %eax,%eax
  800e47:	78 58                	js     800ea1 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  800e49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e4c:	8b 15 24 30 80 00    	mov    0x803024,%edx
  800e52:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  800e54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e57:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  800e5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e61:	8b 15 24 30 80 00    	mov    0x803024,%edx
  800e67:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  800e69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e6c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  800e73:	83 ec 0c             	sub    $0xc,%esp
  800e76:	ff 75 f4             	pushl  -0xc(%ebp)
  800e79:	e8 fc f4 ff ff       	call   80037a <fd2num>
  800e7e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e81:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  800e83:	83 c4 04             	add    $0x4,%esp
  800e86:	ff 75 f0             	pushl  -0x10(%ebp)
  800e89:	e8 ec f4 ff ff       	call   80037a <fd2num>
  800e8e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e91:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  800e94:	83 c4 10             	add    $0x10,%esp
  800e97:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e9c:	e9 4f ff ff ff       	jmp    800df0 <pipe+0x75>
	sys_page_unmap(0, va);
  800ea1:	83 ec 08             	sub    $0x8,%esp
  800ea4:	56                   	push   %esi
  800ea5:	6a 00                	push   $0x0
  800ea7:	e8 43 f3 ff ff       	call   8001ef <sys_page_unmap>
  800eac:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  800eaf:	83 ec 08             	sub    $0x8,%esp
  800eb2:	ff 75 f0             	pushl  -0x10(%ebp)
  800eb5:	6a 00                	push   $0x0
  800eb7:	e8 33 f3 ff ff       	call   8001ef <sys_page_unmap>
  800ebc:	83 c4 10             	add    $0x10,%esp
  800ebf:	e9 1c ff ff ff       	jmp    800de0 <pipe+0x65>

00800ec4 <pipeisclosed>:
{
  800ec4:	55                   	push   %ebp
  800ec5:	89 e5                	mov    %esp,%ebp
  800ec7:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800eca:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800ecd:	50                   	push   %eax
  800ece:	ff 75 08             	pushl  0x8(%ebp)
  800ed1:	e8 1a f5 ff ff       	call   8003f0 <fd_lookup>
  800ed6:	83 c4 10             	add    $0x10,%esp
  800ed9:	85 c0                	test   %eax,%eax
  800edb:	78 18                	js     800ef5 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  800edd:	83 ec 0c             	sub    $0xc,%esp
  800ee0:	ff 75 f4             	pushl  -0xc(%ebp)
  800ee3:	e8 a2 f4 ff ff       	call   80038a <fd2data>
	return _pipeisclosed(fd, p);
  800ee8:	89 c2                	mov    %eax,%edx
  800eea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800eed:	e8 30 fd ff ff       	call   800c22 <_pipeisclosed>
  800ef2:	83 c4 10             	add    $0x10,%esp
}
  800ef5:	c9                   	leave  
  800ef6:	c3                   	ret    

00800ef7 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  800ef7:	55                   	push   %ebp
  800ef8:	89 e5                	mov    %esp,%ebp
  800efa:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  800efd:	68 73 24 80 00       	push   $0x802473
  800f02:	ff 75 0c             	pushl  0xc(%ebp)
  800f05:	e8 47 0d 00 00       	call   801c51 <strcpy>
	return 0;
}
  800f0a:	b8 00 00 00 00       	mov    $0x0,%eax
  800f0f:	c9                   	leave  
  800f10:	c3                   	ret    

00800f11 <devsock_close>:
{
  800f11:	55                   	push   %ebp
  800f12:	89 e5                	mov    %esp,%ebp
  800f14:	53                   	push   %ebx
  800f15:	83 ec 10             	sub    $0x10,%esp
  800f18:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  800f1b:	53                   	push   %ebx
  800f1c:	e8 68 11 00 00       	call   802089 <pageref>
  800f21:	83 c4 10             	add    $0x10,%esp
		return 0;
  800f24:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  800f29:	83 f8 01             	cmp    $0x1,%eax
  800f2c:	74 07                	je     800f35 <devsock_close+0x24>
}
  800f2e:	89 d0                	mov    %edx,%eax
  800f30:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f33:	c9                   	leave  
  800f34:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  800f35:	83 ec 0c             	sub    $0xc,%esp
  800f38:	ff 73 0c             	pushl  0xc(%ebx)
  800f3b:	e8 b7 02 00 00       	call   8011f7 <nsipc_close>
  800f40:	89 c2                	mov    %eax,%edx
  800f42:	83 c4 10             	add    $0x10,%esp
  800f45:	eb e7                	jmp    800f2e <devsock_close+0x1d>

00800f47 <devsock_write>:
{
  800f47:	55                   	push   %ebp
  800f48:	89 e5                	mov    %esp,%ebp
  800f4a:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  800f4d:	6a 00                	push   $0x0
  800f4f:	ff 75 10             	pushl  0x10(%ebp)
  800f52:	ff 75 0c             	pushl  0xc(%ebp)
  800f55:	8b 45 08             	mov    0x8(%ebp),%eax
  800f58:	ff 70 0c             	pushl  0xc(%eax)
  800f5b:	e8 74 03 00 00       	call   8012d4 <nsipc_send>
}
  800f60:	c9                   	leave  
  800f61:	c3                   	ret    

00800f62 <devsock_read>:
{
  800f62:	55                   	push   %ebp
  800f63:	89 e5                	mov    %esp,%ebp
  800f65:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  800f68:	6a 00                	push   $0x0
  800f6a:	ff 75 10             	pushl  0x10(%ebp)
  800f6d:	ff 75 0c             	pushl  0xc(%ebp)
  800f70:	8b 45 08             	mov    0x8(%ebp),%eax
  800f73:	ff 70 0c             	pushl  0xc(%eax)
  800f76:	e8 ed 02 00 00       	call   801268 <nsipc_recv>
}
  800f7b:	c9                   	leave  
  800f7c:	c3                   	ret    

00800f7d <fd2sockid>:
{
  800f7d:	55                   	push   %ebp
  800f7e:	89 e5                	mov    %esp,%ebp
  800f80:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  800f83:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800f86:	52                   	push   %edx
  800f87:	50                   	push   %eax
  800f88:	e8 63 f4 ff ff       	call   8003f0 <fd_lookup>
  800f8d:	83 c4 10             	add    $0x10,%esp
  800f90:	85 c0                	test   %eax,%eax
  800f92:	78 10                	js     800fa4 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  800f94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f97:	8b 0d 40 30 80 00    	mov    0x803040,%ecx
  800f9d:	39 08                	cmp    %ecx,(%eax)
  800f9f:	75 05                	jne    800fa6 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  800fa1:	8b 40 0c             	mov    0xc(%eax),%eax
}
  800fa4:	c9                   	leave  
  800fa5:	c3                   	ret    
		return -E_NOT_SUPP;
  800fa6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800fab:	eb f7                	jmp    800fa4 <fd2sockid+0x27>

00800fad <alloc_sockfd>:
{
  800fad:	55                   	push   %ebp
  800fae:	89 e5                	mov    %esp,%ebp
  800fb0:	56                   	push   %esi
  800fb1:	53                   	push   %ebx
  800fb2:	83 ec 1c             	sub    $0x1c,%esp
  800fb5:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  800fb7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800fba:	50                   	push   %eax
  800fbb:	e8 e1 f3 ff ff       	call   8003a1 <fd_alloc>
  800fc0:	89 c3                	mov    %eax,%ebx
  800fc2:	83 c4 10             	add    $0x10,%esp
  800fc5:	85 c0                	test   %eax,%eax
  800fc7:	78 43                	js     80100c <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  800fc9:	83 ec 04             	sub    $0x4,%esp
  800fcc:	68 07 04 00 00       	push   $0x407
  800fd1:	ff 75 f4             	pushl  -0xc(%ebp)
  800fd4:	6a 00                	push   $0x0
  800fd6:	e8 8f f1 ff ff       	call   80016a <sys_page_alloc>
  800fdb:	89 c3                	mov    %eax,%ebx
  800fdd:	83 c4 10             	add    $0x10,%esp
  800fe0:	85 c0                	test   %eax,%eax
  800fe2:	78 28                	js     80100c <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  800fe4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fe7:	8b 15 40 30 80 00    	mov    0x803040,%edx
  800fed:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  800fef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ff2:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  800ff9:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  800ffc:	83 ec 0c             	sub    $0xc,%esp
  800fff:	50                   	push   %eax
  801000:	e8 75 f3 ff ff       	call   80037a <fd2num>
  801005:	89 c3                	mov    %eax,%ebx
  801007:	83 c4 10             	add    $0x10,%esp
  80100a:	eb 0c                	jmp    801018 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  80100c:	83 ec 0c             	sub    $0xc,%esp
  80100f:	56                   	push   %esi
  801010:	e8 e2 01 00 00       	call   8011f7 <nsipc_close>
		return r;
  801015:	83 c4 10             	add    $0x10,%esp
}
  801018:	89 d8                	mov    %ebx,%eax
  80101a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80101d:	5b                   	pop    %ebx
  80101e:	5e                   	pop    %esi
  80101f:	5d                   	pop    %ebp
  801020:	c3                   	ret    

00801021 <accept>:
{
  801021:	55                   	push   %ebp
  801022:	89 e5                	mov    %esp,%ebp
  801024:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801027:	8b 45 08             	mov    0x8(%ebp),%eax
  80102a:	e8 4e ff ff ff       	call   800f7d <fd2sockid>
  80102f:	85 c0                	test   %eax,%eax
  801031:	78 1b                	js     80104e <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801033:	83 ec 04             	sub    $0x4,%esp
  801036:	ff 75 10             	pushl  0x10(%ebp)
  801039:	ff 75 0c             	pushl  0xc(%ebp)
  80103c:	50                   	push   %eax
  80103d:	e8 0e 01 00 00       	call   801150 <nsipc_accept>
  801042:	83 c4 10             	add    $0x10,%esp
  801045:	85 c0                	test   %eax,%eax
  801047:	78 05                	js     80104e <accept+0x2d>
	return alloc_sockfd(r);
  801049:	e8 5f ff ff ff       	call   800fad <alloc_sockfd>
}
  80104e:	c9                   	leave  
  80104f:	c3                   	ret    

00801050 <bind>:
{
  801050:	55                   	push   %ebp
  801051:	89 e5                	mov    %esp,%ebp
  801053:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801056:	8b 45 08             	mov    0x8(%ebp),%eax
  801059:	e8 1f ff ff ff       	call   800f7d <fd2sockid>
  80105e:	85 c0                	test   %eax,%eax
  801060:	78 12                	js     801074 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801062:	83 ec 04             	sub    $0x4,%esp
  801065:	ff 75 10             	pushl  0x10(%ebp)
  801068:	ff 75 0c             	pushl  0xc(%ebp)
  80106b:	50                   	push   %eax
  80106c:	e8 2f 01 00 00       	call   8011a0 <nsipc_bind>
  801071:	83 c4 10             	add    $0x10,%esp
}
  801074:	c9                   	leave  
  801075:	c3                   	ret    

00801076 <shutdown>:
{
  801076:	55                   	push   %ebp
  801077:	89 e5                	mov    %esp,%ebp
  801079:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80107c:	8b 45 08             	mov    0x8(%ebp),%eax
  80107f:	e8 f9 fe ff ff       	call   800f7d <fd2sockid>
  801084:	85 c0                	test   %eax,%eax
  801086:	78 0f                	js     801097 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801088:	83 ec 08             	sub    $0x8,%esp
  80108b:	ff 75 0c             	pushl  0xc(%ebp)
  80108e:	50                   	push   %eax
  80108f:	e8 41 01 00 00       	call   8011d5 <nsipc_shutdown>
  801094:	83 c4 10             	add    $0x10,%esp
}
  801097:	c9                   	leave  
  801098:	c3                   	ret    

00801099 <connect>:
{
  801099:	55                   	push   %ebp
  80109a:	89 e5                	mov    %esp,%ebp
  80109c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80109f:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a2:	e8 d6 fe ff ff       	call   800f7d <fd2sockid>
  8010a7:	85 c0                	test   %eax,%eax
  8010a9:	78 12                	js     8010bd <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8010ab:	83 ec 04             	sub    $0x4,%esp
  8010ae:	ff 75 10             	pushl  0x10(%ebp)
  8010b1:	ff 75 0c             	pushl  0xc(%ebp)
  8010b4:	50                   	push   %eax
  8010b5:	e8 57 01 00 00       	call   801211 <nsipc_connect>
  8010ba:	83 c4 10             	add    $0x10,%esp
}
  8010bd:	c9                   	leave  
  8010be:	c3                   	ret    

008010bf <listen>:
{
  8010bf:	55                   	push   %ebp
  8010c0:	89 e5                	mov    %esp,%ebp
  8010c2:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8010c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c8:	e8 b0 fe ff ff       	call   800f7d <fd2sockid>
  8010cd:	85 c0                	test   %eax,%eax
  8010cf:	78 0f                	js     8010e0 <listen+0x21>
	return nsipc_listen(r, backlog);
  8010d1:	83 ec 08             	sub    $0x8,%esp
  8010d4:	ff 75 0c             	pushl  0xc(%ebp)
  8010d7:	50                   	push   %eax
  8010d8:	e8 69 01 00 00       	call   801246 <nsipc_listen>
  8010dd:	83 c4 10             	add    $0x10,%esp
}
  8010e0:	c9                   	leave  
  8010e1:	c3                   	ret    

008010e2 <socket>:

int
socket(int domain, int type, int protocol)
{
  8010e2:	55                   	push   %ebp
  8010e3:	89 e5                	mov    %esp,%ebp
  8010e5:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8010e8:	ff 75 10             	pushl  0x10(%ebp)
  8010eb:	ff 75 0c             	pushl  0xc(%ebp)
  8010ee:	ff 75 08             	pushl  0x8(%ebp)
  8010f1:	e8 3c 02 00 00       	call   801332 <nsipc_socket>
  8010f6:	83 c4 10             	add    $0x10,%esp
  8010f9:	85 c0                	test   %eax,%eax
  8010fb:	78 05                	js     801102 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8010fd:	e8 ab fe ff ff       	call   800fad <alloc_sockfd>
}
  801102:	c9                   	leave  
  801103:	c3                   	ret    

00801104 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801104:	55                   	push   %ebp
  801105:	89 e5                	mov    %esp,%ebp
  801107:	53                   	push   %ebx
  801108:	83 ec 04             	sub    $0x4,%esp
  80110b:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80110d:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801114:	74 26                	je     80113c <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801116:	6a 07                	push   $0x7
  801118:	68 00 60 80 00       	push   $0x806000
  80111d:	53                   	push   %ebx
  80111e:	ff 35 04 40 80 00    	pushl  0x804004
  801124:	e8 ce 0e 00 00       	call   801ff7 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801129:	83 c4 0c             	add    $0xc,%esp
  80112c:	6a 00                	push   $0x0
  80112e:	6a 00                	push   $0x0
  801130:	6a 00                	push   $0x0
  801132:	e8 57 0e 00 00       	call   801f8e <ipc_recv>
}
  801137:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80113a:	c9                   	leave  
  80113b:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80113c:	83 ec 0c             	sub    $0xc,%esp
  80113f:	6a 02                	push   $0x2
  801141:	e8 0a 0f 00 00       	call   802050 <ipc_find_env>
  801146:	a3 04 40 80 00       	mov    %eax,0x804004
  80114b:	83 c4 10             	add    $0x10,%esp
  80114e:	eb c6                	jmp    801116 <nsipc+0x12>

00801150 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801150:	55                   	push   %ebp
  801151:	89 e5                	mov    %esp,%ebp
  801153:	56                   	push   %esi
  801154:	53                   	push   %ebx
  801155:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801158:	8b 45 08             	mov    0x8(%ebp),%eax
  80115b:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801160:	8b 06                	mov    (%esi),%eax
  801162:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801167:	b8 01 00 00 00       	mov    $0x1,%eax
  80116c:	e8 93 ff ff ff       	call   801104 <nsipc>
  801171:	89 c3                	mov    %eax,%ebx
  801173:	85 c0                	test   %eax,%eax
  801175:	78 20                	js     801197 <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801177:	83 ec 04             	sub    $0x4,%esp
  80117a:	ff 35 10 60 80 00    	pushl  0x806010
  801180:	68 00 60 80 00       	push   $0x806000
  801185:	ff 75 0c             	pushl  0xc(%ebp)
  801188:	e8 52 0c 00 00       	call   801ddf <memmove>
		*addrlen = ret->ret_addrlen;
  80118d:	a1 10 60 80 00       	mov    0x806010,%eax
  801192:	89 06                	mov    %eax,(%esi)
  801194:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  801197:	89 d8                	mov    %ebx,%eax
  801199:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80119c:	5b                   	pop    %ebx
  80119d:	5e                   	pop    %esi
  80119e:	5d                   	pop    %ebp
  80119f:	c3                   	ret    

008011a0 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8011a0:	55                   	push   %ebp
  8011a1:	89 e5                	mov    %esp,%ebp
  8011a3:	53                   	push   %ebx
  8011a4:	83 ec 08             	sub    $0x8,%esp
  8011a7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8011aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ad:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8011b2:	53                   	push   %ebx
  8011b3:	ff 75 0c             	pushl  0xc(%ebp)
  8011b6:	68 04 60 80 00       	push   $0x806004
  8011bb:	e8 1f 0c 00 00       	call   801ddf <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8011c0:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  8011c6:	b8 02 00 00 00       	mov    $0x2,%eax
  8011cb:	e8 34 ff ff ff       	call   801104 <nsipc>
}
  8011d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011d3:	c9                   	leave  
  8011d4:	c3                   	ret    

008011d5 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8011d5:	55                   	push   %ebp
  8011d6:	89 e5                	mov    %esp,%ebp
  8011d8:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8011db:	8b 45 08             	mov    0x8(%ebp),%eax
  8011de:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  8011e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e6:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  8011eb:	b8 03 00 00 00       	mov    $0x3,%eax
  8011f0:	e8 0f ff ff ff       	call   801104 <nsipc>
}
  8011f5:	c9                   	leave  
  8011f6:	c3                   	ret    

008011f7 <nsipc_close>:

int
nsipc_close(int s)
{
  8011f7:	55                   	push   %ebp
  8011f8:	89 e5                	mov    %esp,%ebp
  8011fa:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8011fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801200:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801205:	b8 04 00 00 00       	mov    $0x4,%eax
  80120a:	e8 f5 fe ff ff       	call   801104 <nsipc>
}
  80120f:	c9                   	leave  
  801210:	c3                   	ret    

00801211 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801211:	55                   	push   %ebp
  801212:	89 e5                	mov    %esp,%ebp
  801214:	53                   	push   %ebx
  801215:	83 ec 08             	sub    $0x8,%esp
  801218:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80121b:	8b 45 08             	mov    0x8(%ebp),%eax
  80121e:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801223:	53                   	push   %ebx
  801224:	ff 75 0c             	pushl  0xc(%ebp)
  801227:	68 04 60 80 00       	push   $0x806004
  80122c:	e8 ae 0b 00 00       	call   801ddf <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801231:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801237:	b8 05 00 00 00       	mov    $0x5,%eax
  80123c:	e8 c3 fe ff ff       	call   801104 <nsipc>
}
  801241:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801244:	c9                   	leave  
  801245:	c3                   	ret    

00801246 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801246:	55                   	push   %ebp
  801247:	89 e5                	mov    %esp,%ebp
  801249:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80124c:	8b 45 08             	mov    0x8(%ebp),%eax
  80124f:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801254:	8b 45 0c             	mov    0xc(%ebp),%eax
  801257:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  80125c:	b8 06 00 00 00       	mov    $0x6,%eax
  801261:	e8 9e fe ff ff       	call   801104 <nsipc>
}
  801266:	c9                   	leave  
  801267:	c3                   	ret    

00801268 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801268:	55                   	push   %ebp
  801269:	89 e5                	mov    %esp,%ebp
  80126b:	56                   	push   %esi
  80126c:	53                   	push   %ebx
  80126d:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801270:	8b 45 08             	mov    0x8(%ebp),%eax
  801273:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801278:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  80127e:	8b 45 14             	mov    0x14(%ebp),%eax
  801281:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801286:	b8 07 00 00 00       	mov    $0x7,%eax
  80128b:	e8 74 fe ff ff       	call   801104 <nsipc>
  801290:	89 c3                	mov    %eax,%ebx
  801292:	85 c0                	test   %eax,%eax
  801294:	78 1f                	js     8012b5 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801296:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  80129b:	7f 21                	jg     8012be <nsipc_recv+0x56>
  80129d:	39 c6                	cmp    %eax,%esi
  80129f:	7c 1d                	jl     8012be <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8012a1:	83 ec 04             	sub    $0x4,%esp
  8012a4:	50                   	push   %eax
  8012a5:	68 00 60 80 00       	push   $0x806000
  8012aa:	ff 75 0c             	pushl  0xc(%ebp)
  8012ad:	e8 2d 0b 00 00       	call   801ddf <memmove>
  8012b2:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8012b5:	89 d8                	mov    %ebx,%eax
  8012b7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012ba:	5b                   	pop    %ebx
  8012bb:	5e                   	pop    %esi
  8012bc:	5d                   	pop    %ebp
  8012bd:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8012be:	68 7f 24 80 00       	push   $0x80247f
  8012c3:	68 21 24 80 00       	push   $0x802421
  8012c8:	6a 62                	push   $0x62
  8012ca:	68 94 24 80 00       	push   $0x802494
  8012cf:	e8 05 02 00 00       	call   8014d9 <_panic>

008012d4 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8012d4:	55                   	push   %ebp
  8012d5:	89 e5                	mov    %esp,%ebp
  8012d7:	53                   	push   %ebx
  8012d8:	83 ec 04             	sub    $0x4,%esp
  8012db:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8012de:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e1:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  8012e6:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8012ec:	7f 2e                	jg     80131c <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8012ee:	83 ec 04             	sub    $0x4,%esp
  8012f1:	53                   	push   %ebx
  8012f2:	ff 75 0c             	pushl  0xc(%ebp)
  8012f5:	68 0c 60 80 00       	push   $0x80600c
  8012fa:	e8 e0 0a 00 00       	call   801ddf <memmove>
	nsipcbuf.send.req_size = size;
  8012ff:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801305:	8b 45 14             	mov    0x14(%ebp),%eax
  801308:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  80130d:	b8 08 00 00 00       	mov    $0x8,%eax
  801312:	e8 ed fd ff ff       	call   801104 <nsipc>
}
  801317:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80131a:	c9                   	leave  
  80131b:	c3                   	ret    
	assert(size < 1600);
  80131c:	68 a0 24 80 00       	push   $0x8024a0
  801321:	68 21 24 80 00       	push   $0x802421
  801326:	6a 6d                	push   $0x6d
  801328:	68 94 24 80 00       	push   $0x802494
  80132d:	e8 a7 01 00 00       	call   8014d9 <_panic>

00801332 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801332:	55                   	push   %ebp
  801333:	89 e5                	mov    %esp,%ebp
  801335:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801338:	8b 45 08             	mov    0x8(%ebp),%eax
  80133b:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801340:	8b 45 0c             	mov    0xc(%ebp),%eax
  801343:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801348:	8b 45 10             	mov    0x10(%ebp),%eax
  80134b:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801350:	b8 09 00 00 00       	mov    $0x9,%eax
  801355:	e8 aa fd ff ff       	call   801104 <nsipc>
}
  80135a:	c9                   	leave  
  80135b:	c3                   	ret    

0080135c <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  80135c:	55                   	push   %ebp
  80135d:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  80135f:	b8 00 00 00 00       	mov    $0x0,%eax
  801364:	5d                   	pop    %ebp
  801365:	c3                   	ret    

00801366 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801366:	55                   	push   %ebp
  801367:	89 e5                	mov    %esp,%ebp
  801369:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80136c:	68 ac 24 80 00       	push   $0x8024ac
  801371:	ff 75 0c             	pushl  0xc(%ebp)
  801374:	e8 d8 08 00 00       	call   801c51 <strcpy>
	return 0;
}
  801379:	b8 00 00 00 00       	mov    $0x0,%eax
  80137e:	c9                   	leave  
  80137f:	c3                   	ret    

00801380 <devcons_write>:
{
  801380:	55                   	push   %ebp
  801381:	89 e5                	mov    %esp,%ebp
  801383:	57                   	push   %edi
  801384:	56                   	push   %esi
  801385:	53                   	push   %ebx
  801386:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80138c:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801391:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801397:	eb 2f                	jmp    8013c8 <devcons_write+0x48>
		m = n - tot;
  801399:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80139c:	29 f3                	sub    %esi,%ebx
  80139e:	83 fb 7f             	cmp    $0x7f,%ebx
  8013a1:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8013a6:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8013a9:	83 ec 04             	sub    $0x4,%esp
  8013ac:	53                   	push   %ebx
  8013ad:	89 f0                	mov    %esi,%eax
  8013af:	03 45 0c             	add    0xc(%ebp),%eax
  8013b2:	50                   	push   %eax
  8013b3:	57                   	push   %edi
  8013b4:	e8 26 0a 00 00       	call   801ddf <memmove>
		sys_cputs(buf, m);
  8013b9:	83 c4 08             	add    $0x8,%esp
  8013bc:	53                   	push   %ebx
  8013bd:	57                   	push   %edi
  8013be:	e8 eb ec ff ff       	call   8000ae <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8013c3:	01 de                	add    %ebx,%esi
  8013c5:	83 c4 10             	add    $0x10,%esp
  8013c8:	3b 75 10             	cmp    0x10(%ebp),%esi
  8013cb:	72 cc                	jb     801399 <devcons_write+0x19>
}
  8013cd:	89 f0                	mov    %esi,%eax
  8013cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013d2:	5b                   	pop    %ebx
  8013d3:	5e                   	pop    %esi
  8013d4:	5f                   	pop    %edi
  8013d5:	5d                   	pop    %ebp
  8013d6:	c3                   	ret    

008013d7 <devcons_read>:
{
  8013d7:	55                   	push   %ebp
  8013d8:	89 e5                	mov    %esp,%ebp
  8013da:	83 ec 08             	sub    $0x8,%esp
  8013dd:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8013e2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013e6:	75 07                	jne    8013ef <devcons_read+0x18>
}
  8013e8:	c9                   	leave  
  8013e9:	c3                   	ret    
		sys_yield();
  8013ea:	e8 5c ed ff ff       	call   80014b <sys_yield>
	while ((c = sys_cgetc()) == 0)
  8013ef:	e8 d8 ec ff ff       	call   8000cc <sys_cgetc>
  8013f4:	85 c0                	test   %eax,%eax
  8013f6:	74 f2                	je     8013ea <devcons_read+0x13>
	if (c < 0)
  8013f8:	85 c0                	test   %eax,%eax
  8013fa:	78 ec                	js     8013e8 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  8013fc:	83 f8 04             	cmp    $0x4,%eax
  8013ff:	74 0c                	je     80140d <devcons_read+0x36>
	*(char*)vbuf = c;
  801401:	8b 55 0c             	mov    0xc(%ebp),%edx
  801404:	88 02                	mov    %al,(%edx)
	return 1;
  801406:	b8 01 00 00 00       	mov    $0x1,%eax
  80140b:	eb db                	jmp    8013e8 <devcons_read+0x11>
		return 0;
  80140d:	b8 00 00 00 00       	mov    $0x0,%eax
  801412:	eb d4                	jmp    8013e8 <devcons_read+0x11>

00801414 <cputchar>:
{
  801414:	55                   	push   %ebp
  801415:	89 e5                	mov    %esp,%ebp
  801417:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80141a:	8b 45 08             	mov    0x8(%ebp),%eax
  80141d:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801420:	6a 01                	push   $0x1
  801422:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801425:	50                   	push   %eax
  801426:	e8 83 ec ff ff       	call   8000ae <sys_cputs>
}
  80142b:	83 c4 10             	add    $0x10,%esp
  80142e:	c9                   	leave  
  80142f:	c3                   	ret    

00801430 <getchar>:
{
  801430:	55                   	push   %ebp
  801431:	89 e5                	mov    %esp,%ebp
  801433:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801436:	6a 01                	push   $0x1
  801438:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80143b:	50                   	push   %eax
  80143c:	6a 00                	push   $0x0
  80143e:	e8 1e f2 ff ff       	call   800661 <read>
	if (r < 0)
  801443:	83 c4 10             	add    $0x10,%esp
  801446:	85 c0                	test   %eax,%eax
  801448:	78 08                	js     801452 <getchar+0x22>
	if (r < 1)
  80144a:	85 c0                	test   %eax,%eax
  80144c:	7e 06                	jle    801454 <getchar+0x24>
	return c;
  80144e:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801452:	c9                   	leave  
  801453:	c3                   	ret    
		return -E_EOF;
  801454:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801459:	eb f7                	jmp    801452 <getchar+0x22>

0080145b <iscons>:
{
  80145b:	55                   	push   %ebp
  80145c:	89 e5                	mov    %esp,%ebp
  80145e:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801461:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801464:	50                   	push   %eax
  801465:	ff 75 08             	pushl  0x8(%ebp)
  801468:	e8 83 ef ff ff       	call   8003f0 <fd_lookup>
  80146d:	83 c4 10             	add    $0x10,%esp
  801470:	85 c0                	test   %eax,%eax
  801472:	78 11                	js     801485 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801474:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801477:	8b 15 5c 30 80 00    	mov    0x80305c,%edx
  80147d:	39 10                	cmp    %edx,(%eax)
  80147f:	0f 94 c0             	sete   %al
  801482:	0f b6 c0             	movzbl %al,%eax
}
  801485:	c9                   	leave  
  801486:	c3                   	ret    

00801487 <opencons>:
{
  801487:	55                   	push   %ebp
  801488:	89 e5                	mov    %esp,%ebp
  80148a:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80148d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801490:	50                   	push   %eax
  801491:	e8 0b ef ff ff       	call   8003a1 <fd_alloc>
  801496:	83 c4 10             	add    $0x10,%esp
  801499:	85 c0                	test   %eax,%eax
  80149b:	78 3a                	js     8014d7 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80149d:	83 ec 04             	sub    $0x4,%esp
  8014a0:	68 07 04 00 00       	push   $0x407
  8014a5:	ff 75 f4             	pushl  -0xc(%ebp)
  8014a8:	6a 00                	push   $0x0
  8014aa:	e8 bb ec ff ff       	call   80016a <sys_page_alloc>
  8014af:	83 c4 10             	add    $0x10,%esp
  8014b2:	85 c0                	test   %eax,%eax
  8014b4:	78 21                	js     8014d7 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8014b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014b9:	8b 15 5c 30 80 00    	mov    0x80305c,%edx
  8014bf:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8014c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014c4:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8014cb:	83 ec 0c             	sub    $0xc,%esp
  8014ce:	50                   	push   %eax
  8014cf:	e8 a6 ee ff ff       	call   80037a <fd2num>
  8014d4:	83 c4 10             	add    $0x10,%esp
}
  8014d7:	c9                   	leave  
  8014d8:	c3                   	ret    

008014d9 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8014d9:	55                   	push   %ebp
  8014da:	89 e5                	mov    %esp,%ebp
  8014dc:	56                   	push   %esi
  8014dd:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8014de:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8014e1:	8b 35 04 30 80 00    	mov    0x803004,%esi
  8014e7:	e8 40 ec ff ff       	call   80012c <sys_getenvid>
  8014ec:	83 ec 0c             	sub    $0xc,%esp
  8014ef:	ff 75 0c             	pushl  0xc(%ebp)
  8014f2:	ff 75 08             	pushl  0x8(%ebp)
  8014f5:	56                   	push   %esi
  8014f6:	50                   	push   %eax
  8014f7:	68 b8 24 80 00       	push   $0x8024b8
  8014fc:	e8 b3 00 00 00       	call   8015b4 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801501:	83 c4 18             	add    $0x18,%esp
  801504:	53                   	push   %ebx
  801505:	ff 75 10             	pushl  0x10(%ebp)
  801508:	e8 56 00 00 00       	call   801563 <vcprintf>
	cprintf("\n");
  80150d:	c7 04 24 6c 24 80 00 	movl   $0x80246c,(%esp)
  801514:	e8 9b 00 00 00       	call   8015b4 <cprintf>
  801519:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80151c:	cc                   	int3   
  80151d:	eb fd                	jmp    80151c <_panic+0x43>

0080151f <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80151f:	55                   	push   %ebp
  801520:	89 e5                	mov    %esp,%ebp
  801522:	53                   	push   %ebx
  801523:	83 ec 04             	sub    $0x4,%esp
  801526:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801529:	8b 13                	mov    (%ebx),%edx
  80152b:	8d 42 01             	lea    0x1(%edx),%eax
  80152e:	89 03                	mov    %eax,(%ebx)
  801530:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801533:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801537:	3d ff 00 00 00       	cmp    $0xff,%eax
  80153c:	74 09                	je     801547 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80153e:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  801542:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801545:	c9                   	leave  
  801546:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  801547:	83 ec 08             	sub    $0x8,%esp
  80154a:	68 ff 00 00 00       	push   $0xff
  80154f:	8d 43 08             	lea    0x8(%ebx),%eax
  801552:	50                   	push   %eax
  801553:	e8 56 eb ff ff       	call   8000ae <sys_cputs>
		b->idx = 0;
  801558:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80155e:	83 c4 10             	add    $0x10,%esp
  801561:	eb db                	jmp    80153e <putch+0x1f>

00801563 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  801563:	55                   	push   %ebp
  801564:	89 e5                	mov    %esp,%ebp
  801566:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80156c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801573:	00 00 00 
	b.cnt = 0;
  801576:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80157d:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  801580:	ff 75 0c             	pushl  0xc(%ebp)
  801583:	ff 75 08             	pushl  0x8(%ebp)
  801586:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80158c:	50                   	push   %eax
  80158d:	68 1f 15 80 00       	push   $0x80151f
  801592:	e8 1a 01 00 00       	call   8016b1 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801597:	83 c4 08             	add    $0x8,%esp
  80159a:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8015a0:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8015a6:	50                   	push   %eax
  8015a7:	e8 02 eb ff ff       	call   8000ae <sys_cputs>

	return b.cnt;
}
  8015ac:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8015b2:	c9                   	leave  
  8015b3:	c3                   	ret    

008015b4 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8015b4:	55                   	push   %ebp
  8015b5:	89 e5                	mov    %esp,%ebp
  8015b7:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8015ba:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8015bd:	50                   	push   %eax
  8015be:	ff 75 08             	pushl  0x8(%ebp)
  8015c1:	e8 9d ff ff ff       	call   801563 <vcprintf>
	va_end(ap);

	return cnt;
}
  8015c6:	c9                   	leave  
  8015c7:	c3                   	ret    

008015c8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8015c8:	55                   	push   %ebp
  8015c9:	89 e5                	mov    %esp,%ebp
  8015cb:	57                   	push   %edi
  8015cc:	56                   	push   %esi
  8015cd:	53                   	push   %ebx
  8015ce:	83 ec 1c             	sub    $0x1c,%esp
  8015d1:	89 c7                	mov    %eax,%edi
  8015d3:	89 d6                	mov    %edx,%esi
  8015d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015db:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8015de:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8015e1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015e4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015e9:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8015ec:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8015ef:	39 d3                	cmp    %edx,%ebx
  8015f1:	72 05                	jb     8015f8 <printnum+0x30>
  8015f3:	39 45 10             	cmp    %eax,0x10(%ebp)
  8015f6:	77 7a                	ja     801672 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8015f8:	83 ec 0c             	sub    $0xc,%esp
  8015fb:	ff 75 18             	pushl  0x18(%ebp)
  8015fe:	8b 45 14             	mov    0x14(%ebp),%eax
  801601:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801604:	53                   	push   %ebx
  801605:	ff 75 10             	pushl  0x10(%ebp)
  801608:	83 ec 08             	sub    $0x8,%esp
  80160b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80160e:	ff 75 e0             	pushl  -0x20(%ebp)
  801611:	ff 75 dc             	pushl  -0x24(%ebp)
  801614:	ff 75 d8             	pushl  -0x28(%ebp)
  801617:	e8 b4 0a 00 00       	call   8020d0 <__udivdi3>
  80161c:	83 c4 18             	add    $0x18,%esp
  80161f:	52                   	push   %edx
  801620:	50                   	push   %eax
  801621:	89 f2                	mov    %esi,%edx
  801623:	89 f8                	mov    %edi,%eax
  801625:	e8 9e ff ff ff       	call   8015c8 <printnum>
  80162a:	83 c4 20             	add    $0x20,%esp
  80162d:	eb 13                	jmp    801642 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80162f:	83 ec 08             	sub    $0x8,%esp
  801632:	56                   	push   %esi
  801633:	ff 75 18             	pushl  0x18(%ebp)
  801636:	ff d7                	call   *%edi
  801638:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80163b:	83 eb 01             	sub    $0x1,%ebx
  80163e:	85 db                	test   %ebx,%ebx
  801640:	7f ed                	jg     80162f <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801642:	83 ec 08             	sub    $0x8,%esp
  801645:	56                   	push   %esi
  801646:	83 ec 04             	sub    $0x4,%esp
  801649:	ff 75 e4             	pushl  -0x1c(%ebp)
  80164c:	ff 75 e0             	pushl  -0x20(%ebp)
  80164f:	ff 75 dc             	pushl  -0x24(%ebp)
  801652:	ff 75 d8             	pushl  -0x28(%ebp)
  801655:	e8 96 0b 00 00       	call   8021f0 <__umoddi3>
  80165a:	83 c4 14             	add    $0x14,%esp
  80165d:	0f be 80 db 24 80 00 	movsbl 0x8024db(%eax),%eax
  801664:	50                   	push   %eax
  801665:	ff d7                	call   *%edi
}
  801667:	83 c4 10             	add    $0x10,%esp
  80166a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80166d:	5b                   	pop    %ebx
  80166e:	5e                   	pop    %esi
  80166f:	5f                   	pop    %edi
  801670:	5d                   	pop    %ebp
  801671:	c3                   	ret    
  801672:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801675:	eb c4                	jmp    80163b <printnum+0x73>

00801677 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801677:	55                   	push   %ebp
  801678:	89 e5                	mov    %esp,%ebp
  80167a:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80167d:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  801681:	8b 10                	mov    (%eax),%edx
  801683:	3b 50 04             	cmp    0x4(%eax),%edx
  801686:	73 0a                	jae    801692 <sprintputch+0x1b>
		*b->buf++ = ch;
  801688:	8d 4a 01             	lea    0x1(%edx),%ecx
  80168b:	89 08                	mov    %ecx,(%eax)
  80168d:	8b 45 08             	mov    0x8(%ebp),%eax
  801690:	88 02                	mov    %al,(%edx)
}
  801692:	5d                   	pop    %ebp
  801693:	c3                   	ret    

00801694 <printfmt>:
{
  801694:	55                   	push   %ebp
  801695:	89 e5                	mov    %esp,%ebp
  801697:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80169a:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80169d:	50                   	push   %eax
  80169e:	ff 75 10             	pushl  0x10(%ebp)
  8016a1:	ff 75 0c             	pushl  0xc(%ebp)
  8016a4:	ff 75 08             	pushl  0x8(%ebp)
  8016a7:	e8 05 00 00 00       	call   8016b1 <vprintfmt>
}
  8016ac:	83 c4 10             	add    $0x10,%esp
  8016af:	c9                   	leave  
  8016b0:	c3                   	ret    

008016b1 <vprintfmt>:
{
  8016b1:	55                   	push   %ebp
  8016b2:	89 e5                	mov    %esp,%ebp
  8016b4:	57                   	push   %edi
  8016b5:	56                   	push   %esi
  8016b6:	53                   	push   %ebx
  8016b7:	83 ec 2c             	sub    $0x2c,%esp
  8016ba:	8b 75 08             	mov    0x8(%ebp),%esi
  8016bd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8016c0:	8b 7d 10             	mov    0x10(%ebp),%edi
  8016c3:	e9 21 04 00 00       	jmp    801ae9 <vprintfmt+0x438>
		padc = ' ';
  8016c8:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8016cc:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8016d3:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  8016da:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8016e1:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8016e6:	8d 47 01             	lea    0x1(%edi),%eax
  8016e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8016ec:	0f b6 17             	movzbl (%edi),%edx
  8016ef:	8d 42 dd             	lea    -0x23(%edx),%eax
  8016f2:	3c 55                	cmp    $0x55,%al
  8016f4:	0f 87 90 04 00 00    	ja     801b8a <vprintfmt+0x4d9>
  8016fa:	0f b6 c0             	movzbl %al,%eax
  8016fd:	ff 24 85 20 26 80 00 	jmp    *0x802620(,%eax,4)
  801704:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  801707:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  80170b:	eb d9                	jmp    8016e6 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80170d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  801710:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  801714:	eb d0                	jmp    8016e6 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  801716:	0f b6 d2             	movzbl %dl,%edx
  801719:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80171c:	b8 00 00 00 00       	mov    $0x0,%eax
  801721:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  801724:	8d 04 80             	lea    (%eax,%eax,4),%eax
  801727:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80172b:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80172e:	8d 4a d0             	lea    -0x30(%edx),%ecx
  801731:	83 f9 09             	cmp    $0x9,%ecx
  801734:	77 55                	ja     80178b <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  801736:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  801739:	eb e9                	jmp    801724 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  80173b:	8b 45 14             	mov    0x14(%ebp),%eax
  80173e:	8b 00                	mov    (%eax),%eax
  801740:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801743:	8b 45 14             	mov    0x14(%ebp),%eax
  801746:	8d 40 04             	lea    0x4(%eax),%eax
  801749:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80174c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80174f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801753:	79 91                	jns    8016e6 <vprintfmt+0x35>
				width = precision, precision = -1;
  801755:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801758:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80175b:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  801762:	eb 82                	jmp    8016e6 <vprintfmt+0x35>
  801764:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801767:	85 c0                	test   %eax,%eax
  801769:	ba 00 00 00 00       	mov    $0x0,%edx
  80176e:	0f 49 d0             	cmovns %eax,%edx
  801771:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801774:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801777:	e9 6a ff ff ff       	jmp    8016e6 <vprintfmt+0x35>
  80177c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80177f:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  801786:	e9 5b ff ff ff       	jmp    8016e6 <vprintfmt+0x35>
  80178b:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80178e:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801791:	eb bc                	jmp    80174f <vprintfmt+0x9e>
			lflag++;
  801793:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801796:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  801799:	e9 48 ff ff ff       	jmp    8016e6 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  80179e:	8b 45 14             	mov    0x14(%ebp),%eax
  8017a1:	8d 78 04             	lea    0x4(%eax),%edi
  8017a4:	83 ec 08             	sub    $0x8,%esp
  8017a7:	53                   	push   %ebx
  8017a8:	ff 30                	pushl  (%eax)
  8017aa:	ff d6                	call   *%esi
			break;
  8017ac:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8017af:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8017b2:	e9 2f 03 00 00       	jmp    801ae6 <vprintfmt+0x435>
			err = va_arg(ap, int);
  8017b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8017ba:	8d 78 04             	lea    0x4(%eax),%edi
  8017bd:	8b 00                	mov    (%eax),%eax
  8017bf:	99                   	cltd   
  8017c0:	31 d0                	xor    %edx,%eax
  8017c2:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8017c4:	83 f8 0f             	cmp    $0xf,%eax
  8017c7:	7f 23                	jg     8017ec <vprintfmt+0x13b>
  8017c9:	8b 14 85 80 27 80 00 	mov    0x802780(,%eax,4),%edx
  8017d0:	85 d2                	test   %edx,%edx
  8017d2:	74 18                	je     8017ec <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  8017d4:	52                   	push   %edx
  8017d5:	68 33 24 80 00       	push   $0x802433
  8017da:	53                   	push   %ebx
  8017db:	56                   	push   %esi
  8017dc:	e8 b3 fe ff ff       	call   801694 <printfmt>
  8017e1:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8017e4:	89 7d 14             	mov    %edi,0x14(%ebp)
  8017e7:	e9 fa 02 00 00       	jmp    801ae6 <vprintfmt+0x435>
				printfmt(putch, putdat, "error %d", err);
  8017ec:	50                   	push   %eax
  8017ed:	68 f3 24 80 00       	push   $0x8024f3
  8017f2:	53                   	push   %ebx
  8017f3:	56                   	push   %esi
  8017f4:	e8 9b fe ff ff       	call   801694 <printfmt>
  8017f9:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8017fc:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8017ff:	e9 e2 02 00 00       	jmp    801ae6 <vprintfmt+0x435>
			if ((p = va_arg(ap, char *)) == NULL)
  801804:	8b 45 14             	mov    0x14(%ebp),%eax
  801807:	83 c0 04             	add    $0x4,%eax
  80180a:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80180d:	8b 45 14             	mov    0x14(%ebp),%eax
  801810:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  801812:	85 ff                	test   %edi,%edi
  801814:	b8 ec 24 80 00       	mov    $0x8024ec,%eax
  801819:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  80181c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801820:	0f 8e bd 00 00 00    	jle    8018e3 <vprintfmt+0x232>
  801826:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80182a:	75 0e                	jne    80183a <vprintfmt+0x189>
  80182c:	89 75 08             	mov    %esi,0x8(%ebp)
  80182f:	8b 75 d0             	mov    -0x30(%ebp),%esi
  801832:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  801835:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  801838:	eb 6d                	jmp    8018a7 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  80183a:	83 ec 08             	sub    $0x8,%esp
  80183d:	ff 75 d0             	pushl  -0x30(%ebp)
  801840:	57                   	push   %edi
  801841:	e8 ec 03 00 00       	call   801c32 <strnlen>
  801846:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  801849:	29 c1                	sub    %eax,%ecx
  80184b:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  80184e:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  801851:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  801855:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801858:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  80185b:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  80185d:	eb 0f                	jmp    80186e <vprintfmt+0x1bd>
					putch(padc, putdat);
  80185f:	83 ec 08             	sub    $0x8,%esp
  801862:	53                   	push   %ebx
  801863:	ff 75 e0             	pushl  -0x20(%ebp)
  801866:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  801868:	83 ef 01             	sub    $0x1,%edi
  80186b:	83 c4 10             	add    $0x10,%esp
  80186e:	85 ff                	test   %edi,%edi
  801870:	7f ed                	jg     80185f <vprintfmt+0x1ae>
  801872:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  801875:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  801878:	85 c9                	test   %ecx,%ecx
  80187a:	b8 00 00 00 00       	mov    $0x0,%eax
  80187f:	0f 49 c1             	cmovns %ecx,%eax
  801882:	29 c1                	sub    %eax,%ecx
  801884:	89 75 08             	mov    %esi,0x8(%ebp)
  801887:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80188a:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80188d:	89 cb                	mov    %ecx,%ebx
  80188f:	eb 16                	jmp    8018a7 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  801891:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801895:	75 31                	jne    8018c8 <vprintfmt+0x217>
					putch(ch, putdat);
  801897:	83 ec 08             	sub    $0x8,%esp
  80189a:	ff 75 0c             	pushl  0xc(%ebp)
  80189d:	50                   	push   %eax
  80189e:	ff 55 08             	call   *0x8(%ebp)
  8018a1:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8018a4:	83 eb 01             	sub    $0x1,%ebx
  8018a7:	83 c7 01             	add    $0x1,%edi
  8018aa:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8018ae:	0f be c2             	movsbl %dl,%eax
  8018b1:	85 c0                	test   %eax,%eax
  8018b3:	74 59                	je     80190e <vprintfmt+0x25d>
  8018b5:	85 f6                	test   %esi,%esi
  8018b7:	78 d8                	js     801891 <vprintfmt+0x1e0>
  8018b9:	83 ee 01             	sub    $0x1,%esi
  8018bc:	79 d3                	jns    801891 <vprintfmt+0x1e0>
  8018be:	89 df                	mov    %ebx,%edi
  8018c0:	8b 75 08             	mov    0x8(%ebp),%esi
  8018c3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8018c6:	eb 37                	jmp    8018ff <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  8018c8:	0f be d2             	movsbl %dl,%edx
  8018cb:	83 ea 20             	sub    $0x20,%edx
  8018ce:	83 fa 5e             	cmp    $0x5e,%edx
  8018d1:	76 c4                	jbe    801897 <vprintfmt+0x1e6>
					putch('?', putdat);
  8018d3:	83 ec 08             	sub    $0x8,%esp
  8018d6:	ff 75 0c             	pushl  0xc(%ebp)
  8018d9:	6a 3f                	push   $0x3f
  8018db:	ff 55 08             	call   *0x8(%ebp)
  8018de:	83 c4 10             	add    $0x10,%esp
  8018e1:	eb c1                	jmp    8018a4 <vprintfmt+0x1f3>
  8018e3:	89 75 08             	mov    %esi,0x8(%ebp)
  8018e6:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8018e9:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8018ec:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8018ef:	eb b6                	jmp    8018a7 <vprintfmt+0x1f6>
				putch(' ', putdat);
  8018f1:	83 ec 08             	sub    $0x8,%esp
  8018f4:	53                   	push   %ebx
  8018f5:	6a 20                	push   $0x20
  8018f7:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8018f9:	83 ef 01             	sub    $0x1,%edi
  8018fc:	83 c4 10             	add    $0x10,%esp
  8018ff:	85 ff                	test   %edi,%edi
  801901:	7f ee                	jg     8018f1 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  801903:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801906:	89 45 14             	mov    %eax,0x14(%ebp)
  801909:	e9 d8 01 00 00       	jmp    801ae6 <vprintfmt+0x435>
  80190e:	89 df                	mov    %ebx,%edi
  801910:	8b 75 08             	mov    0x8(%ebp),%esi
  801913:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801916:	eb e7                	jmp    8018ff <vprintfmt+0x24e>
	if (lflag >= 2)
  801918:	83 f9 01             	cmp    $0x1,%ecx
  80191b:	7e 45                	jle    801962 <vprintfmt+0x2b1>
		return va_arg(*ap, long long);
  80191d:	8b 45 14             	mov    0x14(%ebp),%eax
  801920:	8b 50 04             	mov    0x4(%eax),%edx
  801923:	8b 00                	mov    (%eax),%eax
  801925:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801928:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80192b:	8b 45 14             	mov    0x14(%ebp),%eax
  80192e:	8d 40 08             	lea    0x8(%eax),%eax
  801931:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  801934:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801938:	79 62                	jns    80199c <vprintfmt+0x2eb>
				putch('-', putdat);
  80193a:	83 ec 08             	sub    $0x8,%esp
  80193d:	53                   	push   %ebx
  80193e:	6a 2d                	push   $0x2d
  801940:	ff d6                	call   *%esi
				num = -(long long) num;
  801942:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801945:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801948:	f7 d8                	neg    %eax
  80194a:	83 d2 00             	adc    $0x0,%edx
  80194d:	f7 da                	neg    %edx
  80194f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801952:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801955:	83 c4 10             	add    $0x10,%esp
			base = 10;
  801958:	ba 0a 00 00 00       	mov    $0xa,%edx
  80195d:	e9 66 01 00 00       	jmp    801ac8 <vprintfmt+0x417>
	else if (lflag)
  801962:	85 c9                	test   %ecx,%ecx
  801964:	75 1b                	jne    801981 <vprintfmt+0x2d0>
		return va_arg(*ap, int);
  801966:	8b 45 14             	mov    0x14(%ebp),%eax
  801969:	8b 00                	mov    (%eax),%eax
  80196b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80196e:	89 c1                	mov    %eax,%ecx
  801970:	c1 f9 1f             	sar    $0x1f,%ecx
  801973:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  801976:	8b 45 14             	mov    0x14(%ebp),%eax
  801979:	8d 40 04             	lea    0x4(%eax),%eax
  80197c:	89 45 14             	mov    %eax,0x14(%ebp)
  80197f:	eb b3                	jmp    801934 <vprintfmt+0x283>
		return va_arg(*ap, long);
  801981:	8b 45 14             	mov    0x14(%ebp),%eax
  801984:	8b 00                	mov    (%eax),%eax
  801986:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801989:	89 c1                	mov    %eax,%ecx
  80198b:	c1 f9 1f             	sar    $0x1f,%ecx
  80198e:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  801991:	8b 45 14             	mov    0x14(%ebp),%eax
  801994:	8d 40 04             	lea    0x4(%eax),%eax
  801997:	89 45 14             	mov    %eax,0x14(%ebp)
  80199a:	eb 98                	jmp    801934 <vprintfmt+0x283>
			base = 10;
  80199c:	ba 0a 00 00 00       	mov    $0xa,%edx
  8019a1:	e9 22 01 00 00       	jmp    801ac8 <vprintfmt+0x417>
	if (lflag >= 2)
  8019a6:	83 f9 01             	cmp    $0x1,%ecx
  8019a9:	7e 21                	jle    8019cc <vprintfmt+0x31b>
		return va_arg(*ap, unsigned long long);
  8019ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8019ae:	8b 50 04             	mov    0x4(%eax),%edx
  8019b1:	8b 00                	mov    (%eax),%eax
  8019b3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8019b6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8019b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8019bc:	8d 40 08             	lea    0x8(%eax),%eax
  8019bf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8019c2:	ba 0a 00 00 00       	mov    $0xa,%edx
  8019c7:	e9 fc 00 00 00       	jmp    801ac8 <vprintfmt+0x417>
	else if (lflag)
  8019cc:	85 c9                	test   %ecx,%ecx
  8019ce:	75 23                	jne    8019f3 <vprintfmt+0x342>
		return va_arg(*ap, unsigned int);
  8019d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8019d3:	8b 00                	mov    (%eax),%eax
  8019d5:	ba 00 00 00 00       	mov    $0x0,%edx
  8019da:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8019dd:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8019e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8019e3:	8d 40 04             	lea    0x4(%eax),%eax
  8019e6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8019e9:	ba 0a 00 00 00       	mov    $0xa,%edx
  8019ee:	e9 d5 00 00 00       	jmp    801ac8 <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  8019f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8019f6:	8b 00                	mov    (%eax),%eax
  8019f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8019fd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801a00:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801a03:	8b 45 14             	mov    0x14(%ebp),%eax
  801a06:	8d 40 04             	lea    0x4(%eax),%eax
  801a09:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801a0c:	ba 0a 00 00 00       	mov    $0xa,%edx
  801a11:	e9 b2 00 00 00       	jmp    801ac8 <vprintfmt+0x417>
	if (lflag >= 2)
  801a16:	83 f9 01             	cmp    $0x1,%ecx
  801a19:	7e 42                	jle    801a5d <vprintfmt+0x3ac>
		return va_arg(*ap, unsigned long long);
  801a1b:	8b 45 14             	mov    0x14(%ebp),%eax
  801a1e:	8b 50 04             	mov    0x4(%eax),%edx
  801a21:	8b 00                	mov    (%eax),%eax
  801a23:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801a26:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801a29:	8b 45 14             	mov    0x14(%ebp),%eax
  801a2c:	8d 40 08             	lea    0x8(%eax),%eax
  801a2f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801a32:	ba 08 00 00 00       	mov    $0x8,%edx
			if ((long long) num < 0) {
  801a37:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801a3b:	0f 89 87 00 00 00    	jns    801ac8 <vprintfmt+0x417>
				putch('-', putdat);
  801a41:	83 ec 08             	sub    $0x8,%esp
  801a44:	53                   	push   %ebx
  801a45:	6a 2d                	push   $0x2d
  801a47:	ff d6                	call   *%esi
				num = -(long long) num;
  801a49:	f7 5d d8             	negl   -0x28(%ebp)
  801a4c:	83 55 dc 00          	adcl   $0x0,-0x24(%ebp)
  801a50:	f7 5d dc             	negl   -0x24(%ebp)
  801a53:	83 c4 10             	add    $0x10,%esp
			base = 8;
  801a56:	ba 08 00 00 00       	mov    $0x8,%edx
  801a5b:	eb 6b                	jmp    801ac8 <vprintfmt+0x417>
	else if (lflag)
  801a5d:	85 c9                	test   %ecx,%ecx
  801a5f:	75 1b                	jne    801a7c <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  801a61:	8b 45 14             	mov    0x14(%ebp),%eax
  801a64:	8b 00                	mov    (%eax),%eax
  801a66:	ba 00 00 00 00       	mov    $0x0,%edx
  801a6b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801a6e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801a71:	8b 45 14             	mov    0x14(%ebp),%eax
  801a74:	8d 40 04             	lea    0x4(%eax),%eax
  801a77:	89 45 14             	mov    %eax,0x14(%ebp)
  801a7a:	eb b6                	jmp    801a32 <vprintfmt+0x381>
		return va_arg(*ap, unsigned long);
  801a7c:	8b 45 14             	mov    0x14(%ebp),%eax
  801a7f:	8b 00                	mov    (%eax),%eax
  801a81:	ba 00 00 00 00       	mov    $0x0,%edx
  801a86:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801a89:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801a8c:	8b 45 14             	mov    0x14(%ebp),%eax
  801a8f:	8d 40 04             	lea    0x4(%eax),%eax
  801a92:	89 45 14             	mov    %eax,0x14(%ebp)
  801a95:	eb 9b                	jmp    801a32 <vprintfmt+0x381>
			putch('0', putdat);
  801a97:	83 ec 08             	sub    $0x8,%esp
  801a9a:	53                   	push   %ebx
  801a9b:	6a 30                	push   $0x30
  801a9d:	ff d6                	call   *%esi
			putch('x', putdat);
  801a9f:	83 c4 08             	add    $0x8,%esp
  801aa2:	53                   	push   %ebx
  801aa3:	6a 78                	push   $0x78
  801aa5:	ff d6                	call   *%esi
			num = (unsigned long long)
  801aa7:	8b 45 14             	mov    0x14(%ebp),%eax
  801aaa:	8b 00                	mov    (%eax),%eax
  801aac:	ba 00 00 00 00       	mov    $0x0,%edx
  801ab1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801ab4:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  801ab7:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  801aba:	8b 45 14             	mov    0x14(%ebp),%eax
  801abd:	8d 40 04             	lea    0x4(%eax),%eax
  801ac0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801ac3:	ba 10 00 00 00       	mov    $0x10,%edx
			printnum(putch, putdat, num, base, width, padc);
  801ac8:	83 ec 0c             	sub    $0xc,%esp
  801acb:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  801acf:	50                   	push   %eax
  801ad0:	ff 75 e0             	pushl  -0x20(%ebp)
  801ad3:	52                   	push   %edx
  801ad4:	ff 75 dc             	pushl  -0x24(%ebp)
  801ad7:	ff 75 d8             	pushl  -0x28(%ebp)
  801ada:	89 da                	mov    %ebx,%edx
  801adc:	89 f0                	mov    %esi,%eax
  801ade:	e8 e5 fa ff ff       	call   8015c8 <printnum>
			break;
  801ae3:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  801ae6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801ae9:	83 c7 01             	add    $0x1,%edi
  801aec:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801af0:	83 f8 25             	cmp    $0x25,%eax
  801af3:	0f 84 cf fb ff ff    	je     8016c8 <vprintfmt+0x17>
			if (ch == '\0')
  801af9:	85 c0                	test   %eax,%eax
  801afb:	0f 84 a9 00 00 00    	je     801baa <vprintfmt+0x4f9>
			putch(ch, putdat);
  801b01:	83 ec 08             	sub    $0x8,%esp
  801b04:	53                   	push   %ebx
  801b05:	50                   	push   %eax
  801b06:	ff d6                	call   *%esi
  801b08:	83 c4 10             	add    $0x10,%esp
  801b0b:	eb dc                	jmp    801ae9 <vprintfmt+0x438>
	if (lflag >= 2)
  801b0d:	83 f9 01             	cmp    $0x1,%ecx
  801b10:	7e 1e                	jle    801b30 <vprintfmt+0x47f>
		return va_arg(*ap, unsigned long long);
  801b12:	8b 45 14             	mov    0x14(%ebp),%eax
  801b15:	8b 50 04             	mov    0x4(%eax),%edx
  801b18:	8b 00                	mov    (%eax),%eax
  801b1a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801b1d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801b20:	8b 45 14             	mov    0x14(%ebp),%eax
  801b23:	8d 40 08             	lea    0x8(%eax),%eax
  801b26:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801b29:	ba 10 00 00 00       	mov    $0x10,%edx
  801b2e:	eb 98                	jmp    801ac8 <vprintfmt+0x417>
	else if (lflag)
  801b30:	85 c9                	test   %ecx,%ecx
  801b32:	75 23                	jne    801b57 <vprintfmt+0x4a6>
		return va_arg(*ap, unsigned int);
  801b34:	8b 45 14             	mov    0x14(%ebp),%eax
  801b37:	8b 00                	mov    (%eax),%eax
  801b39:	ba 00 00 00 00       	mov    $0x0,%edx
  801b3e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801b41:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801b44:	8b 45 14             	mov    0x14(%ebp),%eax
  801b47:	8d 40 04             	lea    0x4(%eax),%eax
  801b4a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801b4d:	ba 10 00 00 00       	mov    $0x10,%edx
  801b52:	e9 71 ff ff ff       	jmp    801ac8 <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  801b57:	8b 45 14             	mov    0x14(%ebp),%eax
  801b5a:	8b 00                	mov    (%eax),%eax
  801b5c:	ba 00 00 00 00       	mov    $0x0,%edx
  801b61:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801b64:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801b67:	8b 45 14             	mov    0x14(%ebp),%eax
  801b6a:	8d 40 04             	lea    0x4(%eax),%eax
  801b6d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801b70:	ba 10 00 00 00       	mov    $0x10,%edx
  801b75:	e9 4e ff ff ff       	jmp    801ac8 <vprintfmt+0x417>
			putch(ch, putdat);
  801b7a:	83 ec 08             	sub    $0x8,%esp
  801b7d:	53                   	push   %ebx
  801b7e:	6a 25                	push   $0x25
  801b80:	ff d6                	call   *%esi
			break;
  801b82:	83 c4 10             	add    $0x10,%esp
  801b85:	e9 5c ff ff ff       	jmp    801ae6 <vprintfmt+0x435>
			putch('%', putdat);
  801b8a:	83 ec 08             	sub    $0x8,%esp
  801b8d:	53                   	push   %ebx
  801b8e:	6a 25                	push   $0x25
  801b90:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  801b92:	83 c4 10             	add    $0x10,%esp
  801b95:	89 f8                	mov    %edi,%eax
  801b97:	eb 03                	jmp    801b9c <vprintfmt+0x4eb>
  801b99:	83 e8 01             	sub    $0x1,%eax
  801b9c:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  801ba0:	75 f7                	jne    801b99 <vprintfmt+0x4e8>
  801ba2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801ba5:	e9 3c ff ff ff       	jmp    801ae6 <vprintfmt+0x435>
}
  801baa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801bad:	5b                   	pop    %ebx
  801bae:	5e                   	pop    %esi
  801baf:	5f                   	pop    %edi
  801bb0:	5d                   	pop    %ebp
  801bb1:	c3                   	ret    

00801bb2 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801bb2:	55                   	push   %ebp
  801bb3:	89 e5                	mov    %esp,%ebp
  801bb5:	83 ec 18             	sub    $0x18,%esp
  801bb8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbb:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801bbe:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801bc1:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801bc5:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801bc8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801bcf:	85 c0                	test   %eax,%eax
  801bd1:	74 26                	je     801bf9 <vsnprintf+0x47>
  801bd3:	85 d2                	test   %edx,%edx
  801bd5:	7e 22                	jle    801bf9 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801bd7:	ff 75 14             	pushl  0x14(%ebp)
  801bda:	ff 75 10             	pushl  0x10(%ebp)
  801bdd:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801be0:	50                   	push   %eax
  801be1:	68 77 16 80 00       	push   $0x801677
  801be6:	e8 c6 fa ff ff       	call   8016b1 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801beb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bee:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801bf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bf4:	83 c4 10             	add    $0x10,%esp
}
  801bf7:	c9                   	leave  
  801bf8:	c3                   	ret    
		return -E_INVAL;
  801bf9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801bfe:	eb f7                	jmp    801bf7 <vsnprintf+0x45>

00801c00 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801c00:	55                   	push   %ebp
  801c01:	89 e5                	mov    %esp,%ebp
  801c03:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801c06:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801c09:	50                   	push   %eax
  801c0a:	ff 75 10             	pushl  0x10(%ebp)
  801c0d:	ff 75 0c             	pushl  0xc(%ebp)
  801c10:	ff 75 08             	pushl  0x8(%ebp)
  801c13:	e8 9a ff ff ff       	call   801bb2 <vsnprintf>
	va_end(ap);

	return rc;
}
  801c18:	c9                   	leave  
  801c19:	c3                   	ret    

00801c1a <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801c1a:	55                   	push   %ebp
  801c1b:	89 e5                	mov    %esp,%ebp
  801c1d:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801c20:	b8 00 00 00 00       	mov    $0x0,%eax
  801c25:	eb 03                	jmp    801c2a <strlen+0x10>
		n++;
  801c27:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  801c2a:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801c2e:	75 f7                	jne    801c27 <strlen+0xd>
	return n;
}
  801c30:	5d                   	pop    %ebp
  801c31:	c3                   	ret    

00801c32 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801c32:	55                   	push   %ebp
  801c33:	89 e5                	mov    %esp,%ebp
  801c35:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c38:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801c3b:	b8 00 00 00 00       	mov    $0x0,%eax
  801c40:	eb 03                	jmp    801c45 <strnlen+0x13>
		n++;
  801c42:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801c45:	39 d0                	cmp    %edx,%eax
  801c47:	74 06                	je     801c4f <strnlen+0x1d>
  801c49:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  801c4d:	75 f3                	jne    801c42 <strnlen+0x10>
	return n;
}
  801c4f:	5d                   	pop    %ebp
  801c50:	c3                   	ret    

00801c51 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801c51:	55                   	push   %ebp
  801c52:	89 e5                	mov    %esp,%ebp
  801c54:	53                   	push   %ebx
  801c55:	8b 45 08             	mov    0x8(%ebp),%eax
  801c58:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801c5b:	89 c2                	mov    %eax,%edx
  801c5d:	83 c1 01             	add    $0x1,%ecx
  801c60:	83 c2 01             	add    $0x1,%edx
  801c63:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  801c67:	88 5a ff             	mov    %bl,-0x1(%edx)
  801c6a:	84 db                	test   %bl,%bl
  801c6c:	75 ef                	jne    801c5d <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  801c6e:	5b                   	pop    %ebx
  801c6f:	5d                   	pop    %ebp
  801c70:	c3                   	ret    

00801c71 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801c71:	55                   	push   %ebp
  801c72:	89 e5                	mov    %esp,%ebp
  801c74:	53                   	push   %ebx
  801c75:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801c78:	53                   	push   %ebx
  801c79:	e8 9c ff ff ff       	call   801c1a <strlen>
  801c7e:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  801c81:	ff 75 0c             	pushl  0xc(%ebp)
  801c84:	01 d8                	add    %ebx,%eax
  801c86:	50                   	push   %eax
  801c87:	e8 c5 ff ff ff       	call   801c51 <strcpy>
	return dst;
}
  801c8c:	89 d8                	mov    %ebx,%eax
  801c8e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c91:	c9                   	leave  
  801c92:	c3                   	ret    

00801c93 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801c93:	55                   	push   %ebp
  801c94:	89 e5                	mov    %esp,%ebp
  801c96:	56                   	push   %esi
  801c97:	53                   	push   %ebx
  801c98:	8b 75 08             	mov    0x8(%ebp),%esi
  801c9b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c9e:	89 f3                	mov    %esi,%ebx
  801ca0:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801ca3:	89 f2                	mov    %esi,%edx
  801ca5:	eb 0f                	jmp    801cb6 <strncpy+0x23>
		*dst++ = *src;
  801ca7:	83 c2 01             	add    $0x1,%edx
  801caa:	0f b6 01             	movzbl (%ecx),%eax
  801cad:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801cb0:	80 39 01             	cmpb   $0x1,(%ecx)
  801cb3:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  801cb6:	39 da                	cmp    %ebx,%edx
  801cb8:	75 ed                	jne    801ca7 <strncpy+0x14>
	}
	return ret;
}
  801cba:	89 f0                	mov    %esi,%eax
  801cbc:	5b                   	pop    %ebx
  801cbd:	5e                   	pop    %esi
  801cbe:	5d                   	pop    %ebp
  801cbf:	c3                   	ret    

00801cc0 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801cc0:	55                   	push   %ebp
  801cc1:	89 e5                	mov    %esp,%ebp
  801cc3:	56                   	push   %esi
  801cc4:	53                   	push   %ebx
  801cc5:	8b 75 08             	mov    0x8(%ebp),%esi
  801cc8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ccb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cce:	89 f0                	mov    %esi,%eax
  801cd0:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801cd4:	85 c9                	test   %ecx,%ecx
  801cd6:	75 0b                	jne    801ce3 <strlcpy+0x23>
  801cd8:	eb 17                	jmp    801cf1 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  801cda:	83 c2 01             	add    $0x1,%edx
  801cdd:	83 c0 01             	add    $0x1,%eax
  801ce0:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  801ce3:	39 d8                	cmp    %ebx,%eax
  801ce5:	74 07                	je     801cee <strlcpy+0x2e>
  801ce7:	0f b6 0a             	movzbl (%edx),%ecx
  801cea:	84 c9                	test   %cl,%cl
  801cec:	75 ec                	jne    801cda <strlcpy+0x1a>
		*dst = '\0';
  801cee:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801cf1:	29 f0                	sub    %esi,%eax
}
  801cf3:	5b                   	pop    %ebx
  801cf4:	5e                   	pop    %esi
  801cf5:	5d                   	pop    %ebp
  801cf6:	c3                   	ret    

00801cf7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801cf7:	55                   	push   %ebp
  801cf8:	89 e5                	mov    %esp,%ebp
  801cfa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cfd:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801d00:	eb 06                	jmp    801d08 <strcmp+0x11>
		p++, q++;
  801d02:	83 c1 01             	add    $0x1,%ecx
  801d05:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  801d08:	0f b6 01             	movzbl (%ecx),%eax
  801d0b:	84 c0                	test   %al,%al
  801d0d:	74 04                	je     801d13 <strcmp+0x1c>
  801d0f:	3a 02                	cmp    (%edx),%al
  801d11:	74 ef                	je     801d02 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801d13:	0f b6 c0             	movzbl %al,%eax
  801d16:	0f b6 12             	movzbl (%edx),%edx
  801d19:	29 d0                	sub    %edx,%eax
}
  801d1b:	5d                   	pop    %ebp
  801d1c:	c3                   	ret    

00801d1d <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801d1d:	55                   	push   %ebp
  801d1e:	89 e5                	mov    %esp,%ebp
  801d20:	53                   	push   %ebx
  801d21:	8b 45 08             	mov    0x8(%ebp),%eax
  801d24:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d27:	89 c3                	mov    %eax,%ebx
  801d29:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  801d2c:	eb 06                	jmp    801d34 <strncmp+0x17>
		n--, p++, q++;
  801d2e:	83 c0 01             	add    $0x1,%eax
  801d31:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  801d34:	39 d8                	cmp    %ebx,%eax
  801d36:	74 16                	je     801d4e <strncmp+0x31>
  801d38:	0f b6 08             	movzbl (%eax),%ecx
  801d3b:	84 c9                	test   %cl,%cl
  801d3d:	74 04                	je     801d43 <strncmp+0x26>
  801d3f:	3a 0a                	cmp    (%edx),%cl
  801d41:	74 eb                	je     801d2e <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801d43:	0f b6 00             	movzbl (%eax),%eax
  801d46:	0f b6 12             	movzbl (%edx),%edx
  801d49:	29 d0                	sub    %edx,%eax
}
  801d4b:	5b                   	pop    %ebx
  801d4c:	5d                   	pop    %ebp
  801d4d:	c3                   	ret    
		return 0;
  801d4e:	b8 00 00 00 00       	mov    $0x0,%eax
  801d53:	eb f6                	jmp    801d4b <strncmp+0x2e>

00801d55 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801d55:	55                   	push   %ebp
  801d56:	89 e5                	mov    %esp,%ebp
  801d58:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5b:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801d5f:	0f b6 10             	movzbl (%eax),%edx
  801d62:	84 d2                	test   %dl,%dl
  801d64:	74 09                	je     801d6f <strchr+0x1a>
		if (*s == c)
  801d66:	38 ca                	cmp    %cl,%dl
  801d68:	74 0a                	je     801d74 <strchr+0x1f>
	for (; *s; s++)
  801d6a:	83 c0 01             	add    $0x1,%eax
  801d6d:	eb f0                	jmp    801d5f <strchr+0xa>
			return (char *) s;
	return 0;
  801d6f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d74:	5d                   	pop    %ebp
  801d75:	c3                   	ret    

00801d76 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801d76:	55                   	push   %ebp
  801d77:	89 e5                	mov    %esp,%ebp
  801d79:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801d80:	eb 03                	jmp    801d85 <strfind+0xf>
  801d82:	83 c0 01             	add    $0x1,%eax
  801d85:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  801d88:	38 ca                	cmp    %cl,%dl
  801d8a:	74 04                	je     801d90 <strfind+0x1a>
  801d8c:	84 d2                	test   %dl,%dl
  801d8e:	75 f2                	jne    801d82 <strfind+0xc>
			break;
	return (char *) s;
}
  801d90:	5d                   	pop    %ebp
  801d91:	c3                   	ret    

00801d92 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801d92:	55                   	push   %ebp
  801d93:	89 e5                	mov    %esp,%ebp
  801d95:	57                   	push   %edi
  801d96:	56                   	push   %esi
  801d97:	53                   	push   %ebx
  801d98:	8b 7d 08             	mov    0x8(%ebp),%edi
  801d9b:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801d9e:	85 c9                	test   %ecx,%ecx
  801da0:	74 13                	je     801db5 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801da2:	f7 c7 03 00 00 00    	test   $0x3,%edi
  801da8:	75 05                	jne    801daf <memset+0x1d>
  801daa:	f6 c1 03             	test   $0x3,%cl
  801dad:	74 0d                	je     801dbc <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801daf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801db2:	fc                   	cld    
  801db3:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801db5:	89 f8                	mov    %edi,%eax
  801db7:	5b                   	pop    %ebx
  801db8:	5e                   	pop    %esi
  801db9:	5f                   	pop    %edi
  801dba:	5d                   	pop    %ebp
  801dbb:	c3                   	ret    
		c &= 0xFF;
  801dbc:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801dc0:	89 d3                	mov    %edx,%ebx
  801dc2:	c1 e3 08             	shl    $0x8,%ebx
  801dc5:	89 d0                	mov    %edx,%eax
  801dc7:	c1 e0 18             	shl    $0x18,%eax
  801dca:	89 d6                	mov    %edx,%esi
  801dcc:	c1 e6 10             	shl    $0x10,%esi
  801dcf:	09 f0                	or     %esi,%eax
  801dd1:	09 c2                	or     %eax,%edx
  801dd3:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  801dd5:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  801dd8:	89 d0                	mov    %edx,%eax
  801dda:	fc                   	cld    
  801ddb:	f3 ab                	rep stos %eax,%es:(%edi)
  801ddd:	eb d6                	jmp    801db5 <memset+0x23>

00801ddf <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801ddf:	55                   	push   %ebp
  801de0:	89 e5                	mov    %esp,%ebp
  801de2:	57                   	push   %edi
  801de3:	56                   	push   %esi
  801de4:	8b 45 08             	mov    0x8(%ebp),%eax
  801de7:	8b 75 0c             	mov    0xc(%ebp),%esi
  801dea:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801ded:	39 c6                	cmp    %eax,%esi
  801def:	73 35                	jae    801e26 <memmove+0x47>
  801df1:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801df4:	39 c2                	cmp    %eax,%edx
  801df6:	76 2e                	jbe    801e26 <memmove+0x47>
		s += n;
		d += n;
  801df8:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801dfb:	89 d6                	mov    %edx,%esi
  801dfd:	09 fe                	or     %edi,%esi
  801dff:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801e05:	74 0c                	je     801e13 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801e07:	83 ef 01             	sub    $0x1,%edi
  801e0a:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  801e0d:	fd                   	std    
  801e0e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801e10:	fc                   	cld    
  801e11:	eb 21                	jmp    801e34 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801e13:	f6 c1 03             	test   $0x3,%cl
  801e16:	75 ef                	jne    801e07 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801e18:	83 ef 04             	sub    $0x4,%edi
  801e1b:	8d 72 fc             	lea    -0x4(%edx),%esi
  801e1e:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  801e21:	fd                   	std    
  801e22:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801e24:	eb ea                	jmp    801e10 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801e26:	89 f2                	mov    %esi,%edx
  801e28:	09 c2                	or     %eax,%edx
  801e2a:	f6 c2 03             	test   $0x3,%dl
  801e2d:	74 09                	je     801e38 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801e2f:	89 c7                	mov    %eax,%edi
  801e31:	fc                   	cld    
  801e32:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801e34:	5e                   	pop    %esi
  801e35:	5f                   	pop    %edi
  801e36:	5d                   	pop    %ebp
  801e37:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801e38:	f6 c1 03             	test   $0x3,%cl
  801e3b:	75 f2                	jne    801e2f <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801e3d:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  801e40:	89 c7                	mov    %eax,%edi
  801e42:	fc                   	cld    
  801e43:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801e45:	eb ed                	jmp    801e34 <memmove+0x55>

00801e47 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801e47:	55                   	push   %ebp
  801e48:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  801e4a:	ff 75 10             	pushl  0x10(%ebp)
  801e4d:	ff 75 0c             	pushl  0xc(%ebp)
  801e50:	ff 75 08             	pushl  0x8(%ebp)
  801e53:	e8 87 ff ff ff       	call   801ddf <memmove>
}
  801e58:	c9                   	leave  
  801e59:	c3                   	ret    

00801e5a <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801e5a:	55                   	push   %ebp
  801e5b:	89 e5                	mov    %esp,%ebp
  801e5d:	56                   	push   %esi
  801e5e:	53                   	push   %ebx
  801e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e62:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e65:	89 c6                	mov    %eax,%esi
  801e67:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801e6a:	39 f0                	cmp    %esi,%eax
  801e6c:	74 1c                	je     801e8a <memcmp+0x30>
		if (*s1 != *s2)
  801e6e:	0f b6 08             	movzbl (%eax),%ecx
  801e71:	0f b6 1a             	movzbl (%edx),%ebx
  801e74:	38 d9                	cmp    %bl,%cl
  801e76:	75 08                	jne    801e80 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801e78:	83 c0 01             	add    $0x1,%eax
  801e7b:	83 c2 01             	add    $0x1,%edx
  801e7e:	eb ea                	jmp    801e6a <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  801e80:	0f b6 c1             	movzbl %cl,%eax
  801e83:	0f b6 db             	movzbl %bl,%ebx
  801e86:	29 d8                	sub    %ebx,%eax
  801e88:	eb 05                	jmp    801e8f <memcmp+0x35>
	}

	return 0;
  801e8a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e8f:	5b                   	pop    %ebx
  801e90:	5e                   	pop    %esi
  801e91:	5d                   	pop    %ebp
  801e92:	c3                   	ret    

00801e93 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801e93:	55                   	push   %ebp
  801e94:	89 e5                	mov    %esp,%ebp
  801e96:	8b 45 08             	mov    0x8(%ebp),%eax
  801e99:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801e9c:	89 c2                	mov    %eax,%edx
  801e9e:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801ea1:	39 d0                	cmp    %edx,%eax
  801ea3:	73 09                	jae    801eae <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  801ea5:	38 08                	cmp    %cl,(%eax)
  801ea7:	74 05                	je     801eae <memfind+0x1b>
	for (; s < ends; s++)
  801ea9:	83 c0 01             	add    $0x1,%eax
  801eac:	eb f3                	jmp    801ea1 <memfind+0xe>
			break;
	return (void *) s;
}
  801eae:	5d                   	pop    %ebp
  801eaf:	c3                   	ret    

00801eb0 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801eb0:	55                   	push   %ebp
  801eb1:	89 e5                	mov    %esp,%ebp
  801eb3:	57                   	push   %edi
  801eb4:	56                   	push   %esi
  801eb5:	53                   	push   %ebx
  801eb6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801eb9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801ebc:	eb 03                	jmp    801ec1 <strtol+0x11>
		s++;
  801ebe:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  801ec1:	0f b6 01             	movzbl (%ecx),%eax
  801ec4:	3c 20                	cmp    $0x20,%al
  801ec6:	74 f6                	je     801ebe <strtol+0xe>
  801ec8:	3c 09                	cmp    $0x9,%al
  801eca:	74 f2                	je     801ebe <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  801ecc:	3c 2b                	cmp    $0x2b,%al
  801ece:	74 2e                	je     801efe <strtol+0x4e>
	int neg = 0;
  801ed0:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801ed5:	3c 2d                	cmp    $0x2d,%al
  801ed7:	74 2f                	je     801f08 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801ed9:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  801edf:	75 05                	jne    801ee6 <strtol+0x36>
  801ee1:	80 39 30             	cmpb   $0x30,(%ecx)
  801ee4:	74 2c                	je     801f12 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  801ee6:	85 db                	test   %ebx,%ebx
  801ee8:	75 0a                	jne    801ef4 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801eea:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  801eef:	80 39 30             	cmpb   $0x30,(%ecx)
  801ef2:	74 28                	je     801f1c <strtol+0x6c>
		base = 10;
  801ef4:	b8 00 00 00 00       	mov    $0x0,%eax
  801ef9:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801efc:	eb 50                	jmp    801f4e <strtol+0x9e>
		s++;
  801efe:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  801f01:	bf 00 00 00 00       	mov    $0x0,%edi
  801f06:	eb d1                	jmp    801ed9 <strtol+0x29>
		s++, neg = 1;
  801f08:	83 c1 01             	add    $0x1,%ecx
  801f0b:	bf 01 00 00 00       	mov    $0x1,%edi
  801f10:	eb c7                	jmp    801ed9 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801f12:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801f16:	74 0e                	je     801f26 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  801f18:	85 db                	test   %ebx,%ebx
  801f1a:	75 d8                	jne    801ef4 <strtol+0x44>
		s++, base = 8;
  801f1c:	83 c1 01             	add    $0x1,%ecx
  801f1f:	bb 08 00 00 00       	mov    $0x8,%ebx
  801f24:	eb ce                	jmp    801ef4 <strtol+0x44>
		s += 2, base = 16;
  801f26:	83 c1 02             	add    $0x2,%ecx
  801f29:	bb 10 00 00 00       	mov    $0x10,%ebx
  801f2e:	eb c4                	jmp    801ef4 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  801f30:	8d 72 9f             	lea    -0x61(%edx),%esi
  801f33:	89 f3                	mov    %esi,%ebx
  801f35:	80 fb 19             	cmp    $0x19,%bl
  801f38:	77 29                	ja     801f63 <strtol+0xb3>
			dig = *s - 'a' + 10;
  801f3a:	0f be d2             	movsbl %dl,%edx
  801f3d:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801f40:	3b 55 10             	cmp    0x10(%ebp),%edx
  801f43:	7d 30                	jge    801f75 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  801f45:	83 c1 01             	add    $0x1,%ecx
  801f48:	0f af 45 10          	imul   0x10(%ebp),%eax
  801f4c:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801f4e:	0f b6 11             	movzbl (%ecx),%edx
  801f51:	8d 72 d0             	lea    -0x30(%edx),%esi
  801f54:	89 f3                	mov    %esi,%ebx
  801f56:	80 fb 09             	cmp    $0x9,%bl
  801f59:	77 d5                	ja     801f30 <strtol+0x80>
			dig = *s - '0';
  801f5b:	0f be d2             	movsbl %dl,%edx
  801f5e:	83 ea 30             	sub    $0x30,%edx
  801f61:	eb dd                	jmp    801f40 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  801f63:	8d 72 bf             	lea    -0x41(%edx),%esi
  801f66:	89 f3                	mov    %esi,%ebx
  801f68:	80 fb 19             	cmp    $0x19,%bl
  801f6b:	77 08                	ja     801f75 <strtol+0xc5>
			dig = *s - 'A' + 10;
  801f6d:	0f be d2             	movsbl %dl,%edx
  801f70:	83 ea 37             	sub    $0x37,%edx
  801f73:	eb cb                	jmp    801f40 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  801f75:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801f79:	74 05                	je     801f80 <strtol+0xd0>
		*endptr = (char *) s;
  801f7b:	8b 75 0c             	mov    0xc(%ebp),%esi
  801f7e:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801f80:	89 c2                	mov    %eax,%edx
  801f82:	f7 da                	neg    %edx
  801f84:	85 ff                	test   %edi,%edi
  801f86:	0f 45 c2             	cmovne %edx,%eax
}
  801f89:	5b                   	pop    %ebx
  801f8a:	5e                   	pop    %esi
  801f8b:	5f                   	pop    %edi
  801f8c:	5d                   	pop    %ebp
  801f8d:	c3                   	ret    

00801f8e <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801f8e:	55                   	push   %ebp
  801f8f:	89 e5                	mov    %esp,%ebp
  801f91:	56                   	push   %esi
  801f92:	53                   	push   %ebx
  801f93:	8b 75 08             	mov    0x8(%ebp),%esi
  801f96:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f99:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
  801f9c:	85 c0                	test   %eax,%eax
	    pg = (void *)UTOP;
  801f9e:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801fa3:	0f 44 c2             	cmove  %edx,%eax
	}
	if ((r = sys_ipc_recv(pg)) < 0) {
  801fa6:	83 ec 0c             	sub    $0xc,%esp
  801fa9:	50                   	push   %eax
  801faa:	e8 6b e3 ff ff       	call   80031a <sys_ipc_recv>
  801faf:	83 c4 10             	add    $0x10,%esp
  801fb2:	85 c0                	test   %eax,%eax
  801fb4:	78 2b                	js     801fe1 <ipc_recv+0x53>
	    if (perm_store != NULL) {
	        *perm_store = 0;
	    }
	    return r;
	}
	if (from_env_store != NULL) {
  801fb6:	85 f6                	test   %esi,%esi
  801fb8:	74 0a                	je     801fc4 <ipc_recv+0x36>
	    *from_env_store = thisenv->env_ipc_from;
  801fba:	a1 08 40 80 00       	mov    0x804008,%eax
  801fbf:	8b 40 74             	mov    0x74(%eax),%eax
  801fc2:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store != NULL) {
  801fc4:	85 db                	test   %ebx,%ebx
  801fc6:	74 0a                	je     801fd2 <ipc_recv+0x44>
	    *perm_store = thisenv->env_ipc_perm;
  801fc8:	a1 08 40 80 00       	mov    0x804008,%eax
  801fcd:	8b 40 78             	mov    0x78(%eax),%eax
  801fd0:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  801fd2:	a1 08 40 80 00       	mov    0x804008,%eax
  801fd7:	8b 40 70             	mov    0x70(%eax),%eax
}
  801fda:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fdd:	5b                   	pop    %ebx
  801fde:	5e                   	pop    %esi
  801fdf:	5d                   	pop    %ebp
  801fe0:	c3                   	ret    
	    if (from_env_store != NULL) {
  801fe1:	85 f6                	test   %esi,%esi
  801fe3:	74 06                	je     801feb <ipc_recv+0x5d>
	        *from_env_store = 0;
  801fe5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	    if (perm_store != NULL) {
  801feb:	85 db                	test   %ebx,%ebx
  801fed:	74 eb                	je     801fda <ipc_recv+0x4c>
	        *perm_store = 0;
  801fef:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801ff5:	eb e3                	jmp    801fda <ipc_recv+0x4c>

00801ff7 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801ff7:	55                   	push   %ebp
  801ff8:	89 e5                	mov    %esp,%ebp
  801ffa:	57                   	push   %edi
  801ffb:	56                   	push   %esi
  801ffc:	53                   	push   %ebx
  801ffd:	83 ec 0c             	sub    $0xc,%esp
  802000:	8b 7d 08             	mov    0x8(%ebp),%edi
  802003:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
	    pg = (void *)UTOP;
  802006:	85 f6                	test   %esi,%esi
  802008:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80200d:	0f 44 f0             	cmove  %eax,%esi
  802010:	eb 09                	jmp    80201b <ipc_send+0x24>
	do {
	    r = sys_ipc_try_send(to_env, val, pg, perm);
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
	        panic("ipc_send: %e", r);
	    }
	    sys_yield();
  802012:	e8 34 e1 ff ff       	call   80014b <sys_yield>
	} while(r != 0);
  802017:	85 db                	test   %ebx,%ebx
  802019:	74 2d                	je     802048 <ipc_send+0x51>
	    r = sys_ipc_try_send(to_env, val, pg, perm);
  80201b:	ff 75 14             	pushl  0x14(%ebp)
  80201e:	56                   	push   %esi
  80201f:	ff 75 0c             	pushl  0xc(%ebp)
  802022:	57                   	push   %edi
  802023:	e8 cf e2 ff ff       	call   8002f7 <sys_ipc_try_send>
  802028:	89 c3                	mov    %eax,%ebx
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
  80202a:	83 c4 10             	add    $0x10,%esp
  80202d:	85 c0                	test   %eax,%eax
  80202f:	79 e1                	jns    802012 <ipc_send+0x1b>
  802031:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802034:	74 dc                	je     802012 <ipc_send+0x1b>
	        panic("ipc_send: %e", r);
  802036:	50                   	push   %eax
  802037:	68 e0 27 80 00       	push   $0x8027e0
  80203c:	6a 45                	push   $0x45
  80203e:	68 ed 27 80 00       	push   $0x8027ed
  802043:	e8 91 f4 ff ff       	call   8014d9 <_panic>
}
  802048:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80204b:	5b                   	pop    %ebx
  80204c:	5e                   	pop    %esi
  80204d:	5f                   	pop    %edi
  80204e:	5d                   	pop    %ebp
  80204f:	c3                   	ret    

00802050 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802050:	55                   	push   %ebp
  802051:	89 e5                	mov    %esp,%ebp
  802053:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802056:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80205b:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80205e:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802064:	8b 52 50             	mov    0x50(%edx),%edx
  802067:	39 ca                	cmp    %ecx,%edx
  802069:	74 11                	je     80207c <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  80206b:	83 c0 01             	add    $0x1,%eax
  80206e:	3d 00 04 00 00       	cmp    $0x400,%eax
  802073:	75 e6                	jne    80205b <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802075:	b8 00 00 00 00       	mov    $0x0,%eax
  80207a:	eb 0b                	jmp    802087 <ipc_find_env+0x37>
			return envs[i].env_id;
  80207c:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80207f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802084:	8b 40 48             	mov    0x48(%eax),%eax
}
  802087:	5d                   	pop    %ebp
  802088:	c3                   	ret    

00802089 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802089:	55                   	push   %ebp
  80208a:	89 e5                	mov    %esp,%ebp
  80208c:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80208f:	89 d0                	mov    %edx,%eax
  802091:	c1 e8 16             	shr    $0x16,%eax
  802094:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80209b:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8020a0:	f6 c1 01             	test   $0x1,%cl
  8020a3:	74 1d                	je     8020c2 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8020a5:	c1 ea 0c             	shr    $0xc,%edx
  8020a8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8020af:	f6 c2 01             	test   $0x1,%dl
  8020b2:	74 0e                	je     8020c2 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8020b4:	c1 ea 0c             	shr    $0xc,%edx
  8020b7:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8020be:	ef 
  8020bf:	0f b7 c0             	movzwl %ax,%eax
}
  8020c2:	5d                   	pop    %ebp
  8020c3:	c3                   	ret    
  8020c4:	66 90                	xchg   %ax,%ax
  8020c6:	66 90                	xchg   %ax,%ax
  8020c8:	66 90                	xchg   %ax,%ax
  8020ca:	66 90                	xchg   %ax,%ax
  8020cc:	66 90                	xchg   %ax,%ax
  8020ce:	66 90                	xchg   %ax,%ax

008020d0 <__udivdi3>:
  8020d0:	55                   	push   %ebp
  8020d1:	57                   	push   %edi
  8020d2:	56                   	push   %esi
  8020d3:	53                   	push   %ebx
  8020d4:	83 ec 1c             	sub    $0x1c,%esp
  8020d7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8020db:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8020df:	8b 74 24 34          	mov    0x34(%esp),%esi
  8020e3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8020e7:	85 d2                	test   %edx,%edx
  8020e9:	75 35                	jne    802120 <__udivdi3+0x50>
  8020eb:	39 f3                	cmp    %esi,%ebx
  8020ed:	0f 87 bd 00 00 00    	ja     8021b0 <__udivdi3+0xe0>
  8020f3:	85 db                	test   %ebx,%ebx
  8020f5:	89 d9                	mov    %ebx,%ecx
  8020f7:	75 0b                	jne    802104 <__udivdi3+0x34>
  8020f9:	b8 01 00 00 00       	mov    $0x1,%eax
  8020fe:	31 d2                	xor    %edx,%edx
  802100:	f7 f3                	div    %ebx
  802102:	89 c1                	mov    %eax,%ecx
  802104:	31 d2                	xor    %edx,%edx
  802106:	89 f0                	mov    %esi,%eax
  802108:	f7 f1                	div    %ecx
  80210a:	89 c6                	mov    %eax,%esi
  80210c:	89 e8                	mov    %ebp,%eax
  80210e:	89 f7                	mov    %esi,%edi
  802110:	f7 f1                	div    %ecx
  802112:	89 fa                	mov    %edi,%edx
  802114:	83 c4 1c             	add    $0x1c,%esp
  802117:	5b                   	pop    %ebx
  802118:	5e                   	pop    %esi
  802119:	5f                   	pop    %edi
  80211a:	5d                   	pop    %ebp
  80211b:	c3                   	ret    
  80211c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802120:	39 f2                	cmp    %esi,%edx
  802122:	77 7c                	ja     8021a0 <__udivdi3+0xd0>
  802124:	0f bd fa             	bsr    %edx,%edi
  802127:	83 f7 1f             	xor    $0x1f,%edi
  80212a:	0f 84 98 00 00 00    	je     8021c8 <__udivdi3+0xf8>
  802130:	89 f9                	mov    %edi,%ecx
  802132:	b8 20 00 00 00       	mov    $0x20,%eax
  802137:	29 f8                	sub    %edi,%eax
  802139:	d3 e2                	shl    %cl,%edx
  80213b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80213f:	89 c1                	mov    %eax,%ecx
  802141:	89 da                	mov    %ebx,%edx
  802143:	d3 ea                	shr    %cl,%edx
  802145:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802149:	09 d1                	or     %edx,%ecx
  80214b:	89 f2                	mov    %esi,%edx
  80214d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802151:	89 f9                	mov    %edi,%ecx
  802153:	d3 e3                	shl    %cl,%ebx
  802155:	89 c1                	mov    %eax,%ecx
  802157:	d3 ea                	shr    %cl,%edx
  802159:	89 f9                	mov    %edi,%ecx
  80215b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80215f:	d3 e6                	shl    %cl,%esi
  802161:	89 eb                	mov    %ebp,%ebx
  802163:	89 c1                	mov    %eax,%ecx
  802165:	d3 eb                	shr    %cl,%ebx
  802167:	09 de                	or     %ebx,%esi
  802169:	89 f0                	mov    %esi,%eax
  80216b:	f7 74 24 08          	divl   0x8(%esp)
  80216f:	89 d6                	mov    %edx,%esi
  802171:	89 c3                	mov    %eax,%ebx
  802173:	f7 64 24 0c          	mull   0xc(%esp)
  802177:	39 d6                	cmp    %edx,%esi
  802179:	72 0c                	jb     802187 <__udivdi3+0xb7>
  80217b:	89 f9                	mov    %edi,%ecx
  80217d:	d3 e5                	shl    %cl,%ebp
  80217f:	39 c5                	cmp    %eax,%ebp
  802181:	73 5d                	jae    8021e0 <__udivdi3+0x110>
  802183:	39 d6                	cmp    %edx,%esi
  802185:	75 59                	jne    8021e0 <__udivdi3+0x110>
  802187:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80218a:	31 ff                	xor    %edi,%edi
  80218c:	89 fa                	mov    %edi,%edx
  80218e:	83 c4 1c             	add    $0x1c,%esp
  802191:	5b                   	pop    %ebx
  802192:	5e                   	pop    %esi
  802193:	5f                   	pop    %edi
  802194:	5d                   	pop    %ebp
  802195:	c3                   	ret    
  802196:	8d 76 00             	lea    0x0(%esi),%esi
  802199:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  8021a0:	31 ff                	xor    %edi,%edi
  8021a2:	31 c0                	xor    %eax,%eax
  8021a4:	89 fa                	mov    %edi,%edx
  8021a6:	83 c4 1c             	add    $0x1c,%esp
  8021a9:	5b                   	pop    %ebx
  8021aa:	5e                   	pop    %esi
  8021ab:	5f                   	pop    %edi
  8021ac:	5d                   	pop    %ebp
  8021ad:	c3                   	ret    
  8021ae:	66 90                	xchg   %ax,%ax
  8021b0:	31 ff                	xor    %edi,%edi
  8021b2:	89 e8                	mov    %ebp,%eax
  8021b4:	89 f2                	mov    %esi,%edx
  8021b6:	f7 f3                	div    %ebx
  8021b8:	89 fa                	mov    %edi,%edx
  8021ba:	83 c4 1c             	add    $0x1c,%esp
  8021bd:	5b                   	pop    %ebx
  8021be:	5e                   	pop    %esi
  8021bf:	5f                   	pop    %edi
  8021c0:	5d                   	pop    %ebp
  8021c1:	c3                   	ret    
  8021c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8021c8:	39 f2                	cmp    %esi,%edx
  8021ca:	72 06                	jb     8021d2 <__udivdi3+0x102>
  8021cc:	31 c0                	xor    %eax,%eax
  8021ce:	39 eb                	cmp    %ebp,%ebx
  8021d0:	77 d2                	ja     8021a4 <__udivdi3+0xd4>
  8021d2:	b8 01 00 00 00       	mov    $0x1,%eax
  8021d7:	eb cb                	jmp    8021a4 <__udivdi3+0xd4>
  8021d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8021e0:	89 d8                	mov    %ebx,%eax
  8021e2:	31 ff                	xor    %edi,%edi
  8021e4:	eb be                	jmp    8021a4 <__udivdi3+0xd4>
  8021e6:	66 90                	xchg   %ax,%ax
  8021e8:	66 90                	xchg   %ax,%ax
  8021ea:	66 90                	xchg   %ax,%ax
  8021ec:	66 90                	xchg   %ax,%ax
  8021ee:	66 90                	xchg   %ax,%ax

008021f0 <__umoddi3>:
  8021f0:	55                   	push   %ebp
  8021f1:	57                   	push   %edi
  8021f2:	56                   	push   %esi
  8021f3:	53                   	push   %ebx
  8021f4:	83 ec 1c             	sub    $0x1c,%esp
  8021f7:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  8021fb:	8b 74 24 30          	mov    0x30(%esp),%esi
  8021ff:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802203:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802207:	85 ed                	test   %ebp,%ebp
  802209:	89 f0                	mov    %esi,%eax
  80220b:	89 da                	mov    %ebx,%edx
  80220d:	75 19                	jne    802228 <__umoddi3+0x38>
  80220f:	39 df                	cmp    %ebx,%edi
  802211:	0f 86 b1 00 00 00    	jbe    8022c8 <__umoddi3+0xd8>
  802217:	f7 f7                	div    %edi
  802219:	89 d0                	mov    %edx,%eax
  80221b:	31 d2                	xor    %edx,%edx
  80221d:	83 c4 1c             	add    $0x1c,%esp
  802220:	5b                   	pop    %ebx
  802221:	5e                   	pop    %esi
  802222:	5f                   	pop    %edi
  802223:	5d                   	pop    %ebp
  802224:	c3                   	ret    
  802225:	8d 76 00             	lea    0x0(%esi),%esi
  802228:	39 dd                	cmp    %ebx,%ebp
  80222a:	77 f1                	ja     80221d <__umoddi3+0x2d>
  80222c:	0f bd cd             	bsr    %ebp,%ecx
  80222f:	83 f1 1f             	xor    $0x1f,%ecx
  802232:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802236:	0f 84 b4 00 00 00    	je     8022f0 <__umoddi3+0x100>
  80223c:	b8 20 00 00 00       	mov    $0x20,%eax
  802241:	89 c2                	mov    %eax,%edx
  802243:	8b 44 24 04          	mov    0x4(%esp),%eax
  802247:	29 c2                	sub    %eax,%edx
  802249:	89 c1                	mov    %eax,%ecx
  80224b:	89 f8                	mov    %edi,%eax
  80224d:	d3 e5                	shl    %cl,%ebp
  80224f:	89 d1                	mov    %edx,%ecx
  802251:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802255:	d3 e8                	shr    %cl,%eax
  802257:	09 c5                	or     %eax,%ebp
  802259:	8b 44 24 04          	mov    0x4(%esp),%eax
  80225d:	89 c1                	mov    %eax,%ecx
  80225f:	d3 e7                	shl    %cl,%edi
  802261:	89 d1                	mov    %edx,%ecx
  802263:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802267:	89 df                	mov    %ebx,%edi
  802269:	d3 ef                	shr    %cl,%edi
  80226b:	89 c1                	mov    %eax,%ecx
  80226d:	89 f0                	mov    %esi,%eax
  80226f:	d3 e3                	shl    %cl,%ebx
  802271:	89 d1                	mov    %edx,%ecx
  802273:	89 fa                	mov    %edi,%edx
  802275:	d3 e8                	shr    %cl,%eax
  802277:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80227c:	09 d8                	or     %ebx,%eax
  80227e:	f7 f5                	div    %ebp
  802280:	d3 e6                	shl    %cl,%esi
  802282:	89 d1                	mov    %edx,%ecx
  802284:	f7 64 24 08          	mull   0x8(%esp)
  802288:	39 d1                	cmp    %edx,%ecx
  80228a:	89 c3                	mov    %eax,%ebx
  80228c:	89 d7                	mov    %edx,%edi
  80228e:	72 06                	jb     802296 <__umoddi3+0xa6>
  802290:	75 0e                	jne    8022a0 <__umoddi3+0xb0>
  802292:	39 c6                	cmp    %eax,%esi
  802294:	73 0a                	jae    8022a0 <__umoddi3+0xb0>
  802296:	2b 44 24 08          	sub    0x8(%esp),%eax
  80229a:	19 ea                	sbb    %ebp,%edx
  80229c:	89 d7                	mov    %edx,%edi
  80229e:	89 c3                	mov    %eax,%ebx
  8022a0:	89 ca                	mov    %ecx,%edx
  8022a2:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  8022a7:	29 de                	sub    %ebx,%esi
  8022a9:	19 fa                	sbb    %edi,%edx
  8022ab:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  8022af:	89 d0                	mov    %edx,%eax
  8022b1:	d3 e0                	shl    %cl,%eax
  8022b3:	89 d9                	mov    %ebx,%ecx
  8022b5:	d3 ee                	shr    %cl,%esi
  8022b7:	d3 ea                	shr    %cl,%edx
  8022b9:	09 f0                	or     %esi,%eax
  8022bb:	83 c4 1c             	add    $0x1c,%esp
  8022be:	5b                   	pop    %ebx
  8022bf:	5e                   	pop    %esi
  8022c0:	5f                   	pop    %edi
  8022c1:	5d                   	pop    %ebp
  8022c2:	c3                   	ret    
  8022c3:	90                   	nop
  8022c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8022c8:	85 ff                	test   %edi,%edi
  8022ca:	89 f9                	mov    %edi,%ecx
  8022cc:	75 0b                	jne    8022d9 <__umoddi3+0xe9>
  8022ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8022d3:	31 d2                	xor    %edx,%edx
  8022d5:	f7 f7                	div    %edi
  8022d7:	89 c1                	mov    %eax,%ecx
  8022d9:	89 d8                	mov    %ebx,%eax
  8022db:	31 d2                	xor    %edx,%edx
  8022dd:	f7 f1                	div    %ecx
  8022df:	89 f0                	mov    %esi,%eax
  8022e1:	f7 f1                	div    %ecx
  8022e3:	e9 31 ff ff ff       	jmp    802219 <__umoddi3+0x29>
  8022e8:	90                   	nop
  8022e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022f0:	39 dd                	cmp    %ebx,%ebp
  8022f2:	72 08                	jb     8022fc <__umoddi3+0x10c>
  8022f4:	39 f7                	cmp    %esi,%edi
  8022f6:	0f 87 21 ff ff ff    	ja     80221d <__umoddi3+0x2d>
  8022fc:	89 da                	mov    %ebx,%edx
  8022fe:	89 f0                	mov    %esi,%eax
  802300:	29 f8                	sub    %edi,%eax
  802302:	19 ea                	sbb    %ebp,%edx
  802304:	e9 14 ff ff ff       	jmp    80221d <__umoddi3+0x2d>
