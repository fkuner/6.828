
obj/user/evilhello.debug:     file format elf32-i386


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
  80002c:	e8 19 00 00 00       	call   80004a <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	// try to print the kernel entry point as a string!  mua ha ha!
	sys_cputs((char*)0xf010000c, 100);
  800039:	6a 64                	push   $0x64
  80003b:	68 0c 00 10 f0       	push   $0xf010000c
  800040:	e8 65 00 00 00       	call   8000aa <sys_cputs>
}
  800045:	83 c4 10             	add    $0x10,%esp
  800048:	c9                   	leave  
  800049:	c3                   	ret    

0080004a <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80004a:	55                   	push   %ebp
  80004b:	89 e5                	mov    %esp,%ebp
  80004d:	56                   	push   %esi
  80004e:	53                   	push   %ebx
  80004f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800052:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
    thisenv = &envs[ENVX(sys_getenvid())];
  800055:	e8 ce 00 00 00       	call   800128 <sys_getenvid>
  80005a:	25 ff 03 00 00       	and    $0x3ff,%eax
  80005f:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800062:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800067:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80006c:	85 db                	test   %ebx,%ebx
  80006e:	7e 07                	jle    800077 <libmain+0x2d>
		binaryname = argv[0];
  800070:	8b 06                	mov    (%esi),%eax
  800072:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800077:	83 ec 08             	sub    $0x8,%esp
  80007a:	56                   	push   %esi
  80007b:	53                   	push   %ebx
  80007c:	e8 b2 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800081:	e8 0a 00 00 00       	call   800090 <exit>
}
  800086:	83 c4 10             	add    $0x10,%esp
  800089:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80008c:	5b                   	pop    %ebx
  80008d:	5e                   	pop    %esi
  80008e:	5d                   	pop    %ebp
  80008f:	c3                   	ret    

00800090 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800090:	55                   	push   %ebp
  800091:	89 e5                	mov    %esp,%ebp
  800093:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800096:	e8 b1 04 00 00       	call   80054c <close_all>
	sys_env_destroy(0);
  80009b:	83 ec 0c             	sub    $0xc,%esp
  80009e:	6a 00                	push   $0x0
  8000a0:	e8 42 00 00 00       	call   8000e7 <sys_env_destroy>
}
  8000a5:	83 c4 10             	add    $0x10,%esp
  8000a8:	c9                   	leave  
  8000a9:	c3                   	ret    

008000aa <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000aa:	55                   	push   %ebp
  8000ab:	89 e5                	mov    %esp,%ebp
  8000ad:	57                   	push   %edi
  8000ae:	56                   	push   %esi
  8000af:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b5:	8b 55 08             	mov    0x8(%ebp),%edx
  8000b8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000bb:	89 c3                	mov    %eax,%ebx
  8000bd:	89 c7                	mov    %eax,%edi
  8000bf:	89 c6                	mov    %eax,%esi
  8000c1:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000c3:	5b                   	pop    %ebx
  8000c4:	5e                   	pop    %esi
  8000c5:	5f                   	pop    %edi
  8000c6:	5d                   	pop    %ebp
  8000c7:	c3                   	ret    

008000c8 <sys_cgetc>:

int
sys_cgetc(void)
{
  8000c8:	55                   	push   %ebp
  8000c9:	89 e5                	mov    %esp,%ebp
  8000cb:	57                   	push   %edi
  8000cc:	56                   	push   %esi
  8000cd:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8000d3:	b8 01 00 00 00       	mov    $0x1,%eax
  8000d8:	89 d1                	mov    %edx,%ecx
  8000da:	89 d3                	mov    %edx,%ebx
  8000dc:	89 d7                	mov    %edx,%edi
  8000de:	89 d6                	mov    %edx,%esi
  8000e0:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000e2:	5b                   	pop    %ebx
  8000e3:	5e                   	pop    %esi
  8000e4:	5f                   	pop    %edi
  8000e5:	5d                   	pop    %ebp
  8000e6:	c3                   	ret    

008000e7 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000e7:	55                   	push   %ebp
  8000e8:	89 e5                	mov    %esp,%ebp
  8000ea:	57                   	push   %edi
  8000eb:	56                   	push   %esi
  8000ec:	53                   	push   %ebx
  8000ed:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8000f0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000f5:	8b 55 08             	mov    0x8(%ebp),%edx
  8000f8:	b8 03 00 00 00       	mov    $0x3,%eax
  8000fd:	89 cb                	mov    %ecx,%ebx
  8000ff:	89 cf                	mov    %ecx,%edi
  800101:	89 ce                	mov    %ecx,%esi
  800103:	cd 30                	int    $0x30
	if(check && ret > 0)
  800105:	85 c0                	test   %eax,%eax
  800107:	7f 08                	jg     800111 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800109:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80010c:	5b                   	pop    %ebx
  80010d:	5e                   	pop    %esi
  80010e:	5f                   	pop    %edi
  80010f:	5d                   	pop    %ebp
  800110:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800111:	83 ec 0c             	sub    $0xc,%esp
  800114:	50                   	push   %eax
  800115:	6a 03                	push   $0x3
  800117:	68 0a 23 80 00       	push   $0x80230a
  80011c:	6a 23                	push   $0x23
  80011e:	68 27 23 80 00       	push   $0x802327
  800123:	e8 ad 13 00 00       	call   8014d5 <_panic>

00800128 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800128:	55                   	push   %ebp
  800129:	89 e5                	mov    %esp,%ebp
  80012b:	57                   	push   %edi
  80012c:	56                   	push   %esi
  80012d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80012e:	ba 00 00 00 00       	mov    $0x0,%edx
  800133:	b8 02 00 00 00       	mov    $0x2,%eax
  800138:	89 d1                	mov    %edx,%ecx
  80013a:	89 d3                	mov    %edx,%ebx
  80013c:	89 d7                	mov    %edx,%edi
  80013e:	89 d6                	mov    %edx,%esi
  800140:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800142:	5b                   	pop    %ebx
  800143:	5e                   	pop    %esi
  800144:	5f                   	pop    %edi
  800145:	5d                   	pop    %ebp
  800146:	c3                   	ret    

00800147 <sys_yield>:

void
sys_yield(void)
{
  800147:	55                   	push   %ebp
  800148:	89 e5                	mov    %esp,%ebp
  80014a:	57                   	push   %edi
  80014b:	56                   	push   %esi
  80014c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80014d:	ba 00 00 00 00       	mov    $0x0,%edx
  800152:	b8 0b 00 00 00       	mov    $0xb,%eax
  800157:	89 d1                	mov    %edx,%ecx
  800159:	89 d3                	mov    %edx,%ebx
  80015b:	89 d7                	mov    %edx,%edi
  80015d:	89 d6                	mov    %edx,%esi
  80015f:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800161:	5b                   	pop    %ebx
  800162:	5e                   	pop    %esi
  800163:	5f                   	pop    %edi
  800164:	5d                   	pop    %ebp
  800165:	c3                   	ret    

00800166 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800166:	55                   	push   %ebp
  800167:	89 e5                	mov    %esp,%ebp
  800169:	57                   	push   %edi
  80016a:	56                   	push   %esi
  80016b:	53                   	push   %ebx
  80016c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80016f:	be 00 00 00 00       	mov    $0x0,%esi
  800174:	8b 55 08             	mov    0x8(%ebp),%edx
  800177:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80017a:	b8 04 00 00 00       	mov    $0x4,%eax
  80017f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800182:	89 f7                	mov    %esi,%edi
  800184:	cd 30                	int    $0x30
	if(check && ret > 0)
  800186:	85 c0                	test   %eax,%eax
  800188:	7f 08                	jg     800192 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80018a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80018d:	5b                   	pop    %ebx
  80018e:	5e                   	pop    %esi
  80018f:	5f                   	pop    %edi
  800190:	5d                   	pop    %ebp
  800191:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800192:	83 ec 0c             	sub    $0xc,%esp
  800195:	50                   	push   %eax
  800196:	6a 04                	push   $0x4
  800198:	68 0a 23 80 00       	push   $0x80230a
  80019d:	6a 23                	push   $0x23
  80019f:	68 27 23 80 00       	push   $0x802327
  8001a4:	e8 2c 13 00 00       	call   8014d5 <_panic>

008001a9 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001a9:	55                   	push   %ebp
  8001aa:	89 e5                	mov    %esp,%ebp
  8001ac:	57                   	push   %edi
  8001ad:	56                   	push   %esi
  8001ae:	53                   	push   %ebx
  8001af:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8001b5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001b8:	b8 05 00 00 00       	mov    $0x5,%eax
  8001bd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001c0:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001c3:	8b 75 18             	mov    0x18(%ebp),%esi
  8001c6:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001c8:	85 c0                	test   %eax,%eax
  8001ca:	7f 08                	jg     8001d4 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001cf:	5b                   	pop    %ebx
  8001d0:	5e                   	pop    %esi
  8001d1:	5f                   	pop    %edi
  8001d2:	5d                   	pop    %ebp
  8001d3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001d4:	83 ec 0c             	sub    $0xc,%esp
  8001d7:	50                   	push   %eax
  8001d8:	6a 05                	push   $0x5
  8001da:	68 0a 23 80 00       	push   $0x80230a
  8001df:	6a 23                	push   $0x23
  8001e1:	68 27 23 80 00       	push   $0x802327
  8001e6:	e8 ea 12 00 00       	call   8014d5 <_panic>

008001eb <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001eb:	55                   	push   %ebp
  8001ec:	89 e5                	mov    %esp,%ebp
  8001ee:	57                   	push   %edi
  8001ef:	56                   	push   %esi
  8001f0:	53                   	push   %ebx
  8001f1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001f4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8001fc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001ff:	b8 06 00 00 00       	mov    $0x6,%eax
  800204:	89 df                	mov    %ebx,%edi
  800206:	89 de                	mov    %ebx,%esi
  800208:	cd 30                	int    $0x30
	if(check && ret > 0)
  80020a:	85 c0                	test   %eax,%eax
  80020c:	7f 08                	jg     800216 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80020e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800211:	5b                   	pop    %ebx
  800212:	5e                   	pop    %esi
  800213:	5f                   	pop    %edi
  800214:	5d                   	pop    %ebp
  800215:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800216:	83 ec 0c             	sub    $0xc,%esp
  800219:	50                   	push   %eax
  80021a:	6a 06                	push   $0x6
  80021c:	68 0a 23 80 00       	push   $0x80230a
  800221:	6a 23                	push   $0x23
  800223:	68 27 23 80 00       	push   $0x802327
  800228:	e8 a8 12 00 00       	call   8014d5 <_panic>

0080022d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80022d:	55                   	push   %ebp
  80022e:	89 e5                	mov    %esp,%ebp
  800230:	57                   	push   %edi
  800231:	56                   	push   %esi
  800232:	53                   	push   %ebx
  800233:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800236:	bb 00 00 00 00       	mov    $0x0,%ebx
  80023b:	8b 55 08             	mov    0x8(%ebp),%edx
  80023e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800241:	b8 08 00 00 00       	mov    $0x8,%eax
  800246:	89 df                	mov    %ebx,%edi
  800248:	89 de                	mov    %ebx,%esi
  80024a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80024c:	85 c0                	test   %eax,%eax
  80024e:	7f 08                	jg     800258 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800250:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800253:	5b                   	pop    %ebx
  800254:	5e                   	pop    %esi
  800255:	5f                   	pop    %edi
  800256:	5d                   	pop    %ebp
  800257:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800258:	83 ec 0c             	sub    $0xc,%esp
  80025b:	50                   	push   %eax
  80025c:	6a 08                	push   $0x8
  80025e:	68 0a 23 80 00       	push   $0x80230a
  800263:	6a 23                	push   $0x23
  800265:	68 27 23 80 00       	push   $0x802327
  80026a:	e8 66 12 00 00       	call   8014d5 <_panic>

0080026f <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80026f:	55                   	push   %ebp
  800270:	89 e5                	mov    %esp,%ebp
  800272:	57                   	push   %edi
  800273:	56                   	push   %esi
  800274:	53                   	push   %ebx
  800275:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800278:	bb 00 00 00 00       	mov    $0x0,%ebx
  80027d:	8b 55 08             	mov    0x8(%ebp),%edx
  800280:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800283:	b8 09 00 00 00       	mov    $0x9,%eax
  800288:	89 df                	mov    %ebx,%edi
  80028a:	89 de                	mov    %ebx,%esi
  80028c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80028e:	85 c0                	test   %eax,%eax
  800290:	7f 08                	jg     80029a <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800292:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800295:	5b                   	pop    %ebx
  800296:	5e                   	pop    %esi
  800297:	5f                   	pop    %edi
  800298:	5d                   	pop    %ebp
  800299:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80029a:	83 ec 0c             	sub    $0xc,%esp
  80029d:	50                   	push   %eax
  80029e:	6a 09                	push   $0x9
  8002a0:	68 0a 23 80 00       	push   $0x80230a
  8002a5:	6a 23                	push   $0x23
  8002a7:	68 27 23 80 00       	push   $0x802327
  8002ac:	e8 24 12 00 00       	call   8014d5 <_panic>

008002b1 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002b1:	55                   	push   %ebp
  8002b2:	89 e5                	mov    %esp,%ebp
  8002b4:	57                   	push   %edi
  8002b5:	56                   	push   %esi
  8002b6:	53                   	push   %ebx
  8002b7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002ba:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8002c2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002c5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002ca:	89 df                	mov    %ebx,%edi
  8002cc:	89 de                	mov    %ebx,%esi
  8002ce:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002d0:	85 c0                	test   %eax,%eax
  8002d2:	7f 08                	jg     8002dc <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8002d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002d7:	5b                   	pop    %ebx
  8002d8:	5e                   	pop    %esi
  8002d9:	5f                   	pop    %edi
  8002da:	5d                   	pop    %ebp
  8002db:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002dc:	83 ec 0c             	sub    $0xc,%esp
  8002df:	50                   	push   %eax
  8002e0:	6a 0a                	push   $0xa
  8002e2:	68 0a 23 80 00       	push   $0x80230a
  8002e7:	6a 23                	push   $0x23
  8002e9:	68 27 23 80 00       	push   $0x802327
  8002ee:	e8 e2 11 00 00       	call   8014d5 <_panic>

008002f3 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8002f3:	55                   	push   %ebp
  8002f4:	89 e5                	mov    %esp,%ebp
  8002f6:	57                   	push   %edi
  8002f7:	56                   	push   %esi
  8002f8:	53                   	push   %ebx
	asm volatile("int %1\n"
  8002f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8002fc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002ff:	b8 0c 00 00 00       	mov    $0xc,%eax
  800304:	be 00 00 00 00       	mov    $0x0,%esi
  800309:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80030c:	8b 7d 14             	mov    0x14(%ebp),%edi
  80030f:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800311:	5b                   	pop    %ebx
  800312:	5e                   	pop    %esi
  800313:	5f                   	pop    %edi
  800314:	5d                   	pop    %ebp
  800315:	c3                   	ret    

00800316 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800316:	55                   	push   %ebp
  800317:	89 e5                	mov    %esp,%ebp
  800319:	57                   	push   %edi
  80031a:	56                   	push   %esi
  80031b:	53                   	push   %ebx
  80031c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80031f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800324:	8b 55 08             	mov    0x8(%ebp),%edx
  800327:	b8 0d 00 00 00       	mov    $0xd,%eax
  80032c:	89 cb                	mov    %ecx,%ebx
  80032e:	89 cf                	mov    %ecx,%edi
  800330:	89 ce                	mov    %ecx,%esi
  800332:	cd 30                	int    $0x30
	if(check && ret > 0)
  800334:	85 c0                	test   %eax,%eax
  800336:	7f 08                	jg     800340 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800338:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80033b:	5b                   	pop    %ebx
  80033c:	5e                   	pop    %esi
  80033d:	5f                   	pop    %edi
  80033e:	5d                   	pop    %ebp
  80033f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800340:	83 ec 0c             	sub    $0xc,%esp
  800343:	50                   	push   %eax
  800344:	6a 0d                	push   $0xd
  800346:	68 0a 23 80 00       	push   $0x80230a
  80034b:	6a 23                	push   $0x23
  80034d:	68 27 23 80 00       	push   $0x802327
  800352:	e8 7e 11 00 00       	call   8014d5 <_panic>

00800357 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800357:	55                   	push   %ebp
  800358:	89 e5                	mov    %esp,%ebp
  80035a:	57                   	push   %edi
  80035b:	56                   	push   %esi
  80035c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80035d:	ba 00 00 00 00       	mov    $0x0,%edx
  800362:	b8 0e 00 00 00       	mov    $0xe,%eax
  800367:	89 d1                	mov    %edx,%ecx
  800369:	89 d3                	mov    %edx,%ebx
  80036b:	89 d7                	mov    %edx,%edi
  80036d:	89 d6                	mov    %edx,%esi
  80036f:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800371:	5b                   	pop    %ebx
  800372:	5e                   	pop    %esi
  800373:	5f                   	pop    %edi
  800374:	5d                   	pop    %ebp
  800375:	c3                   	ret    

00800376 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800376:	55                   	push   %ebp
  800377:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800379:	8b 45 08             	mov    0x8(%ebp),%eax
  80037c:	05 00 00 00 30       	add    $0x30000000,%eax
  800381:	c1 e8 0c             	shr    $0xc,%eax
}
  800384:	5d                   	pop    %ebp
  800385:	c3                   	ret    

00800386 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800386:	55                   	push   %ebp
  800387:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800389:	8b 45 08             	mov    0x8(%ebp),%eax
  80038c:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800391:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800396:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80039b:	5d                   	pop    %ebp
  80039c:	c3                   	ret    

0080039d <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80039d:	55                   	push   %ebp
  80039e:	89 e5                	mov    %esp,%ebp
  8003a0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003a3:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8003a8:	89 c2                	mov    %eax,%edx
  8003aa:	c1 ea 16             	shr    $0x16,%edx
  8003ad:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8003b4:	f6 c2 01             	test   $0x1,%dl
  8003b7:	74 2a                	je     8003e3 <fd_alloc+0x46>
  8003b9:	89 c2                	mov    %eax,%edx
  8003bb:	c1 ea 0c             	shr    $0xc,%edx
  8003be:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8003c5:	f6 c2 01             	test   $0x1,%dl
  8003c8:	74 19                	je     8003e3 <fd_alloc+0x46>
  8003ca:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8003cf:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8003d4:	75 d2                	jne    8003a8 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8003d6:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8003dc:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8003e1:	eb 07                	jmp    8003ea <fd_alloc+0x4d>
			*fd_store = fd;
  8003e3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8003e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8003ea:	5d                   	pop    %ebp
  8003eb:	c3                   	ret    

008003ec <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8003ec:	55                   	push   %ebp
  8003ed:	89 e5                	mov    %esp,%ebp
  8003ef:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8003f2:	83 f8 1f             	cmp    $0x1f,%eax
  8003f5:	77 36                	ja     80042d <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8003f7:	c1 e0 0c             	shl    $0xc,%eax
  8003fa:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8003ff:	89 c2                	mov    %eax,%edx
  800401:	c1 ea 16             	shr    $0x16,%edx
  800404:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80040b:	f6 c2 01             	test   $0x1,%dl
  80040e:	74 24                	je     800434 <fd_lookup+0x48>
  800410:	89 c2                	mov    %eax,%edx
  800412:	c1 ea 0c             	shr    $0xc,%edx
  800415:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80041c:	f6 c2 01             	test   $0x1,%dl
  80041f:	74 1a                	je     80043b <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800421:	8b 55 0c             	mov    0xc(%ebp),%edx
  800424:	89 02                	mov    %eax,(%edx)
	return 0;
  800426:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80042b:	5d                   	pop    %ebp
  80042c:	c3                   	ret    
		return -E_INVAL;
  80042d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800432:	eb f7                	jmp    80042b <fd_lookup+0x3f>
		return -E_INVAL;
  800434:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800439:	eb f0                	jmp    80042b <fd_lookup+0x3f>
  80043b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800440:	eb e9                	jmp    80042b <fd_lookup+0x3f>

00800442 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800442:	55                   	push   %ebp
  800443:	89 e5                	mov    %esp,%ebp
  800445:	83 ec 08             	sub    $0x8,%esp
  800448:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80044b:	ba b4 23 80 00       	mov    $0x8023b4,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800450:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800455:	39 08                	cmp    %ecx,(%eax)
  800457:	74 33                	je     80048c <dev_lookup+0x4a>
  800459:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  80045c:	8b 02                	mov    (%edx),%eax
  80045e:	85 c0                	test   %eax,%eax
  800460:	75 f3                	jne    800455 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800462:	a1 08 40 80 00       	mov    0x804008,%eax
  800467:	8b 40 48             	mov    0x48(%eax),%eax
  80046a:	83 ec 04             	sub    $0x4,%esp
  80046d:	51                   	push   %ecx
  80046e:	50                   	push   %eax
  80046f:	68 38 23 80 00       	push   $0x802338
  800474:	e8 37 11 00 00       	call   8015b0 <cprintf>
	*dev = 0;
  800479:	8b 45 0c             	mov    0xc(%ebp),%eax
  80047c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800482:	83 c4 10             	add    $0x10,%esp
  800485:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80048a:	c9                   	leave  
  80048b:	c3                   	ret    
			*dev = devtab[i];
  80048c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80048f:	89 01                	mov    %eax,(%ecx)
			return 0;
  800491:	b8 00 00 00 00       	mov    $0x0,%eax
  800496:	eb f2                	jmp    80048a <dev_lookup+0x48>

00800498 <fd_close>:
{
  800498:	55                   	push   %ebp
  800499:	89 e5                	mov    %esp,%ebp
  80049b:	57                   	push   %edi
  80049c:	56                   	push   %esi
  80049d:	53                   	push   %ebx
  80049e:	83 ec 1c             	sub    $0x1c,%esp
  8004a1:	8b 75 08             	mov    0x8(%ebp),%esi
  8004a4:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8004a7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8004aa:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8004ab:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8004b1:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8004b4:	50                   	push   %eax
  8004b5:	e8 32 ff ff ff       	call   8003ec <fd_lookup>
  8004ba:	89 c3                	mov    %eax,%ebx
  8004bc:	83 c4 08             	add    $0x8,%esp
  8004bf:	85 c0                	test   %eax,%eax
  8004c1:	78 05                	js     8004c8 <fd_close+0x30>
	    || fd != fd2)
  8004c3:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8004c6:	74 16                	je     8004de <fd_close+0x46>
		return (must_exist ? r : 0);
  8004c8:	89 f8                	mov    %edi,%eax
  8004ca:	84 c0                	test   %al,%al
  8004cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8004d1:	0f 44 d8             	cmove  %eax,%ebx
}
  8004d4:	89 d8                	mov    %ebx,%eax
  8004d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004d9:	5b                   	pop    %ebx
  8004da:	5e                   	pop    %esi
  8004db:	5f                   	pop    %edi
  8004dc:	5d                   	pop    %ebp
  8004dd:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8004de:	83 ec 08             	sub    $0x8,%esp
  8004e1:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8004e4:	50                   	push   %eax
  8004e5:	ff 36                	pushl  (%esi)
  8004e7:	e8 56 ff ff ff       	call   800442 <dev_lookup>
  8004ec:	89 c3                	mov    %eax,%ebx
  8004ee:	83 c4 10             	add    $0x10,%esp
  8004f1:	85 c0                	test   %eax,%eax
  8004f3:	78 15                	js     80050a <fd_close+0x72>
		if (dev->dev_close)
  8004f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004f8:	8b 40 10             	mov    0x10(%eax),%eax
  8004fb:	85 c0                	test   %eax,%eax
  8004fd:	74 1b                	je     80051a <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  8004ff:	83 ec 0c             	sub    $0xc,%esp
  800502:	56                   	push   %esi
  800503:	ff d0                	call   *%eax
  800505:	89 c3                	mov    %eax,%ebx
  800507:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80050a:	83 ec 08             	sub    $0x8,%esp
  80050d:	56                   	push   %esi
  80050e:	6a 00                	push   $0x0
  800510:	e8 d6 fc ff ff       	call   8001eb <sys_page_unmap>
	return r;
  800515:	83 c4 10             	add    $0x10,%esp
  800518:	eb ba                	jmp    8004d4 <fd_close+0x3c>
			r = 0;
  80051a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80051f:	eb e9                	jmp    80050a <fd_close+0x72>

00800521 <close>:

int
close(int fdnum)
{
  800521:	55                   	push   %ebp
  800522:	89 e5                	mov    %esp,%ebp
  800524:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800527:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80052a:	50                   	push   %eax
  80052b:	ff 75 08             	pushl  0x8(%ebp)
  80052e:	e8 b9 fe ff ff       	call   8003ec <fd_lookup>
  800533:	83 c4 08             	add    $0x8,%esp
  800536:	85 c0                	test   %eax,%eax
  800538:	78 10                	js     80054a <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  80053a:	83 ec 08             	sub    $0x8,%esp
  80053d:	6a 01                	push   $0x1
  80053f:	ff 75 f4             	pushl  -0xc(%ebp)
  800542:	e8 51 ff ff ff       	call   800498 <fd_close>
  800547:	83 c4 10             	add    $0x10,%esp
}
  80054a:	c9                   	leave  
  80054b:	c3                   	ret    

0080054c <close_all>:

void
close_all(void)
{
  80054c:	55                   	push   %ebp
  80054d:	89 e5                	mov    %esp,%ebp
  80054f:	53                   	push   %ebx
  800550:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800553:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800558:	83 ec 0c             	sub    $0xc,%esp
  80055b:	53                   	push   %ebx
  80055c:	e8 c0 ff ff ff       	call   800521 <close>
	for (i = 0; i < MAXFD; i++)
  800561:	83 c3 01             	add    $0x1,%ebx
  800564:	83 c4 10             	add    $0x10,%esp
  800567:	83 fb 20             	cmp    $0x20,%ebx
  80056a:	75 ec                	jne    800558 <close_all+0xc>
}
  80056c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80056f:	c9                   	leave  
  800570:	c3                   	ret    

00800571 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800571:	55                   	push   %ebp
  800572:	89 e5                	mov    %esp,%ebp
  800574:	57                   	push   %edi
  800575:	56                   	push   %esi
  800576:	53                   	push   %ebx
  800577:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80057a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80057d:	50                   	push   %eax
  80057e:	ff 75 08             	pushl  0x8(%ebp)
  800581:	e8 66 fe ff ff       	call   8003ec <fd_lookup>
  800586:	89 c3                	mov    %eax,%ebx
  800588:	83 c4 08             	add    $0x8,%esp
  80058b:	85 c0                	test   %eax,%eax
  80058d:	0f 88 81 00 00 00    	js     800614 <dup+0xa3>
		return r;
	close(newfdnum);
  800593:	83 ec 0c             	sub    $0xc,%esp
  800596:	ff 75 0c             	pushl  0xc(%ebp)
  800599:	e8 83 ff ff ff       	call   800521 <close>

	newfd = INDEX2FD(newfdnum);
  80059e:	8b 75 0c             	mov    0xc(%ebp),%esi
  8005a1:	c1 e6 0c             	shl    $0xc,%esi
  8005a4:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8005aa:	83 c4 04             	add    $0x4,%esp
  8005ad:	ff 75 e4             	pushl  -0x1c(%ebp)
  8005b0:	e8 d1 fd ff ff       	call   800386 <fd2data>
  8005b5:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8005b7:	89 34 24             	mov    %esi,(%esp)
  8005ba:	e8 c7 fd ff ff       	call   800386 <fd2data>
  8005bf:	83 c4 10             	add    $0x10,%esp
  8005c2:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8005c4:	89 d8                	mov    %ebx,%eax
  8005c6:	c1 e8 16             	shr    $0x16,%eax
  8005c9:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8005d0:	a8 01                	test   $0x1,%al
  8005d2:	74 11                	je     8005e5 <dup+0x74>
  8005d4:	89 d8                	mov    %ebx,%eax
  8005d6:	c1 e8 0c             	shr    $0xc,%eax
  8005d9:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8005e0:	f6 c2 01             	test   $0x1,%dl
  8005e3:	75 39                	jne    80061e <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8005e5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8005e8:	89 d0                	mov    %edx,%eax
  8005ea:	c1 e8 0c             	shr    $0xc,%eax
  8005ed:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8005f4:	83 ec 0c             	sub    $0xc,%esp
  8005f7:	25 07 0e 00 00       	and    $0xe07,%eax
  8005fc:	50                   	push   %eax
  8005fd:	56                   	push   %esi
  8005fe:	6a 00                	push   $0x0
  800600:	52                   	push   %edx
  800601:	6a 00                	push   $0x0
  800603:	e8 a1 fb ff ff       	call   8001a9 <sys_page_map>
  800608:	89 c3                	mov    %eax,%ebx
  80060a:	83 c4 20             	add    $0x20,%esp
  80060d:	85 c0                	test   %eax,%eax
  80060f:	78 31                	js     800642 <dup+0xd1>
		goto err;

	return newfdnum;
  800611:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  800614:	89 d8                	mov    %ebx,%eax
  800616:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800619:	5b                   	pop    %ebx
  80061a:	5e                   	pop    %esi
  80061b:	5f                   	pop    %edi
  80061c:	5d                   	pop    %ebp
  80061d:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80061e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800625:	83 ec 0c             	sub    $0xc,%esp
  800628:	25 07 0e 00 00       	and    $0xe07,%eax
  80062d:	50                   	push   %eax
  80062e:	57                   	push   %edi
  80062f:	6a 00                	push   $0x0
  800631:	53                   	push   %ebx
  800632:	6a 00                	push   $0x0
  800634:	e8 70 fb ff ff       	call   8001a9 <sys_page_map>
  800639:	89 c3                	mov    %eax,%ebx
  80063b:	83 c4 20             	add    $0x20,%esp
  80063e:	85 c0                	test   %eax,%eax
  800640:	79 a3                	jns    8005e5 <dup+0x74>
	sys_page_unmap(0, newfd);
  800642:	83 ec 08             	sub    $0x8,%esp
  800645:	56                   	push   %esi
  800646:	6a 00                	push   $0x0
  800648:	e8 9e fb ff ff       	call   8001eb <sys_page_unmap>
	sys_page_unmap(0, nva);
  80064d:	83 c4 08             	add    $0x8,%esp
  800650:	57                   	push   %edi
  800651:	6a 00                	push   $0x0
  800653:	e8 93 fb ff ff       	call   8001eb <sys_page_unmap>
	return r;
  800658:	83 c4 10             	add    $0x10,%esp
  80065b:	eb b7                	jmp    800614 <dup+0xa3>

0080065d <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80065d:	55                   	push   %ebp
  80065e:	89 e5                	mov    %esp,%ebp
  800660:	53                   	push   %ebx
  800661:	83 ec 14             	sub    $0x14,%esp
  800664:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800667:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80066a:	50                   	push   %eax
  80066b:	53                   	push   %ebx
  80066c:	e8 7b fd ff ff       	call   8003ec <fd_lookup>
  800671:	83 c4 08             	add    $0x8,%esp
  800674:	85 c0                	test   %eax,%eax
  800676:	78 3f                	js     8006b7 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800678:	83 ec 08             	sub    $0x8,%esp
  80067b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80067e:	50                   	push   %eax
  80067f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800682:	ff 30                	pushl  (%eax)
  800684:	e8 b9 fd ff ff       	call   800442 <dev_lookup>
  800689:	83 c4 10             	add    $0x10,%esp
  80068c:	85 c0                	test   %eax,%eax
  80068e:	78 27                	js     8006b7 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800690:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800693:	8b 42 08             	mov    0x8(%edx),%eax
  800696:	83 e0 03             	and    $0x3,%eax
  800699:	83 f8 01             	cmp    $0x1,%eax
  80069c:	74 1e                	je     8006bc <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80069e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006a1:	8b 40 08             	mov    0x8(%eax),%eax
  8006a4:	85 c0                	test   %eax,%eax
  8006a6:	74 35                	je     8006dd <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8006a8:	83 ec 04             	sub    $0x4,%esp
  8006ab:	ff 75 10             	pushl  0x10(%ebp)
  8006ae:	ff 75 0c             	pushl  0xc(%ebp)
  8006b1:	52                   	push   %edx
  8006b2:	ff d0                	call   *%eax
  8006b4:	83 c4 10             	add    $0x10,%esp
}
  8006b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006ba:	c9                   	leave  
  8006bb:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8006bc:	a1 08 40 80 00       	mov    0x804008,%eax
  8006c1:	8b 40 48             	mov    0x48(%eax),%eax
  8006c4:	83 ec 04             	sub    $0x4,%esp
  8006c7:	53                   	push   %ebx
  8006c8:	50                   	push   %eax
  8006c9:	68 79 23 80 00       	push   $0x802379
  8006ce:	e8 dd 0e 00 00       	call   8015b0 <cprintf>
		return -E_INVAL;
  8006d3:	83 c4 10             	add    $0x10,%esp
  8006d6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8006db:	eb da                	jmp    8006b7 <read+0x5a>
		return -E_NOT_SUPP;
  8006dd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8006e2:	eb d3                	jmp    8006b7 <read+0x5a>

008006e4 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8006e4:	55                   	push   %ebp
  8006e5:	89 e5                	mov    %esp,%ebp
  8006e7:	57                   	push   %edi
  8006e8:	56                   	push   %esi
  8006e9:	53                   	push   %ebx
  8006ea:	83 ec 0c             	sub    $0xc,%esp
  8006ed:	8b 7d 08             	mov    0x8(%ebp),%edi
  8006f0:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8006f3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006f8:	39 f3                	cmp    %esi,%ebx
  8006fa:	73 25                	jae    800721 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8006fc:	83 ec 04             	sub    $0x4,%esp
  8006ff:	89 f0                	mov    %esi,%eax
  800701:	29 d8                	sub    %ebx,%eax
  800703:	50                   	push   %eax
  800704:	89 d8                	mov    %ebx,%eax
  800706:	03 45 0c             	add    0xc(%ebp),%eax
  800709:	50                   	push   %eax
  80070a:	57                   	push   %edi
  80070b:	e8 4d ff ff ff       	call   80065d <read>
		if (m < 0)
  800710:	83 c4 10             	add    $0x10,%esp
  800713:	85 c0                	test   %eax,%eax
  800715:	78 08                	js     80071f <readn+0x3b>
			return m;
		if (m == 0)
  800717:	85 c0                	test   %eax,%eax
  800719:	74 06                	je     800721 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  80071b:	01 c3                	add    %eax,%ebx
  80071d:	eb d9                	jmp    8006f8 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80071f:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  800721:	89 d8                	mov    %ebx,%eax
  800723:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800726:	5b                   	pop    %ebx
  800727:	5e                   	pop    %esi
  800728:	5f                   	pop    %edi
  800729:	5d                   	pop    %ebp
  80072a:	c3                   	ret    

0080072b <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80072b:	55                   	push   %ebp
  80072c:	89 e5                	mov    %esp,%ebp
  80072e:	53                   	push   %ebx
  80072f:	83 ec 14             	sub    $0x14,%esp
  800732:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800735:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800738:	50                   	push   %eax
  800739:	53                   	push   %ebx
  80073a:	e8 ad fc ff ff       	call   8003ec <fd_lookup>
  80073f:	83 c4 08             	add    $0x8,%esp
  800742:	85 c0                	test   %eax,%eax
  800744:	78 3a                	js     800780 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800746:	83 ec 08             	sub    $0x8,%esp
  800749:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80074c:	50                   	push   %eax
  80074d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800750:	ff 30                	pushl  (%eax)
  800752:	e8 eb fc ff ff       	call   800442 <dev_lookup>
  800757:	83 c4 10             	add    $0x10,%esp
  80075a:	85 c0                	test   %eax,%eax
  80075c:	78 22                	js     800780 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80075e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800761:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800765:	74 1e                	je     800785 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800767:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80076a:	8b 52 0c             	mov    0xc(%edx),%edx
  80076d:	85 d2                	test   %edx,%edx
  80076f:	74 35                	je     8007a6 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  800771:	83 ec 04             	sub    $0x4,%esp
  800774:	ff 75 10             	pushl  0x10(%ebp)
  800777:	ff 75 0c             	pushl  0xc(%ebp)
  80077a:	50                   	push   %eax
  80077b:	ff d2                	call   *%edx
  80077d:	83 c4 10             	add    $0x10,%esp
}
  800780:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800783:	c9                   	leave  
  800784:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800785:	a1 08 40 80 00       	mov    0x804008,%eax
  80078a:	8b 40 48             	mov    0x48(%eax),%eax
  80078d:	83 ec 04             	sub    $0x4,%esp
  800790:	53                   	push   %ebx
  800791:	50                   	push   %eax
  800792:	68 95 23 80 00       	push   $0x802395
  800797:	e8 14 0e 00 00       	call   8015b0 <cprintf>
		return -E_INVAL;
  80079c:	83 c4 10             	add    $0x10,%esp
  80079f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007a4:	eb da                	jmp    800780 <write+0x55>
		return -E_NOT_SUPP;
  8007a6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8007ab:	eb d3                	jmp    800780 <write+0x55>

008007ad <seek>:

int
seek(int fdnum, off_t offset)
{
  8007ad:	55                   	push   %ebp
  8007ae:	89 e5                	mov    %esp,%ebp
  8007b0:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8007b3:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8007b6:	50                   	push   %eax
  8007b7:	ff 75 08             	pushl  0x8(%ebp)
  8007ba:	e8 2d fc ff ff       	call   8003ec <fd_lookup>
  8007bf:	83 c4 08             	add    $0x8,%esp
  8007c2:	85 c0                	test   %eax,%eax
  8007c4:	78 0e                	js     8007d4 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8007c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8007cc:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8007cf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8007d4:	c9                   	leave  
  8007d5:	c3                   	ret    

008007d6 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8007d6:	55                   	push   %ebp
  8007d7:	89 e5                	mov    %esp,%ebp
  8007d9:	53                   	push   %ebx
  8007da:	83 ec 14             	sub    $0x14,%esp
  8007dd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8007e0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8007e3:	50                   	push   %eax
  8007e4:	53                   	push   %ebx
  8007e5:	e8 02 fc ff ff       	call   8003ec <fd_lookup>
  8007ea:	83 c4 08             	add    $0x8,%esp
  8007ed:	85 c0                	test   %eax,%eax
  8007ef:	78 37                	js     800828 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8007f1:	83 ec 08             	sub    $0x8,%esp
  8007f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8007f7:	50                   	push   %eax
  8007f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007fb:	ff 30                	pushl  (%eax)
  8007fd:	e8 40 fc ff ff       	call   800442 <dev_lookup>
  800802:	83 c4 10             	add    $0x10,%esp
  800805:	85 c0                	test   %eax,%eax
  800807:	78 1f                	js     800828 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800809:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80080c:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800810:	74 1b                	je     80082d <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  800812:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800815:	8b 52 18             	mov    0x18(%edx),%edx
  800818:	85 d2                	test   %edx,%edx
  80081a:	74 32                	je     80084e <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80081c:	83 ec 08             	sub    $0x8,%esp
  80081f:	ff 75 0c             	pushl  0xc(%ebp)
  800822:	50                   	push   %eax
  800823:	ff d2                	call   *%edx
  800825:	83 c4 10             	add    $0x10,%esp
}
  800828:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80082b:	c9                   	leave  
  80082c:	c3                   	ret    
			thisenv->env_id, fdnum);
  80082d:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800832:	8b 40 48             	mov    0x48(%eax),%eax
  800835:	83 ec 04             	sub    $0x4,%esp
  800838:	53                   	push   %ebx
  800839:	50                   	push   %eax
  80083a:	68 58 23 80 00       	push   $0x802358
  80083f:	e8 6c 0d 00 00       	call   8015b0 <cprintf>
		return -E_INVAL;
  800844:	83 c4 10             	add    $0x10,%esp
  800847:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80084c:	eb da                	jmp    800828 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80084e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800853:	eb d3                	jmp    800828 <ftruncate+0x52>

00800855 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800855:	55                   	push   %ebp
  800856:	89 e5                	mov    %esp,%ebp
  800858:	53                   	push   %ebx
  800859:	83 ec 14             	sub    $0x14,%esp
  80085c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80085f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800862:	50                   	push   %eax
  800863:	ff 75 08             	pushl  0x8(%ebp)
  800866:	e8 81 fb ff ff       	call   8003ec <fd_lookup>
  80086b:	83 c4 08             	add    $0x8,%esp
  80086e:	85 c0                	test   %eax,%eax
  800870:	78 4b                	js     8008bd <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800872:	83 ec 08             	sub    $0x8,%esp
  800875:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800878:	50                   	push   %eax
  800879:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80087c:	ff 30                	pushl  (%eax)
  80087e:	e8 bf fb ff ff       	call   800442 <dev_lookup>
  800883:	83 c4 10             	add    $0x10,%esp
  800886:	85 c0                	test   %eax,%eax
  800888:	78 33                	js     8008bd <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80088a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80088d:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  800891:	74 2f                	je     8008c2 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800893:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  800896:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80089d:	00 00 00 
	stat->st_isdir = 0;
  8008a0:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8008a7:	00 00 00 
	stat->st_dev = dev;
  8008aa:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8008b0:	83 ec 08             	sub    $0x8,%esp
  8008b3:	53                   	push   %ebx
  8008b4:	ff 75 f0             	pushl  -0x10(%ebp)
  8008b7:	ff 50 14             	call   *0x14(%eax)
  8008ba:	83 c4 10             	add    $0x10,%esp
}
  8008bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008c0:	c9                   	leave  
  8008c1:	c3                   	ret    
		return -E_NOT_SUPP;
  8008c2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8008c7:	eb f4                	jmp    8008bd <fstat+0x68>

008008c9 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8008c9:	55                   	push   %ebp
  8008ca:	89 e5                	mov    %esp,%ebp
  8008cc:	56                   	push   %esi
  8008cd:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8008ce:	83 ec 08             	sub    $0x8,%esp
  8008d1:	6a 00                	push   $0x0
  8008d3:	ff 75 08             	pushl  0x8(%ebp)
  8008d6:	e8 26 02 00 00       	call   800b01 <open>
  8008db:	89 c3                	mov    %eax,%ebx
  8008dd:	83 c4 10             	add    $0x10,%esp
  8008e0:	85 c0                	test   %eax,%eax
  8008e2:	78 1b                	js     8008ff <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8008e4:	83 ec 08             	sub    $0x8,%esp
  8008e7:	ff 75 0c             	pushl  0xc(%ebp)
  8008ea:	50                   	push   %eax
  8008eb:	e8 65 ff ff ff       	call   800855 <fstat>
  8008f0:	89 c6                	mov    %eax,%esi
	close(fd);
  8008f2:	89 1c 24             	mov    %ebx,(%esp)
  8008f5:	e8 27 fc ff ff       	call   800521 <close>
	return r;
  8008fa:	83 c4 10             	add    $0x10,%esp
  8008fd:	89 f3                	mov    %esi,%ebx
}
  8008ff:	89 d8                	mov    %ebx,%eax
  800901:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800904:	5b                   	pop    %ebx
  800905:	5e                   	pop    %esi
  800906:	5d                   	pop    %ebp
  800907:	c3                   	ret    

00800908 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800908:	55                   	push   %ebp
  800909:	89 e5                	mov    %esp,%ebp
  80090b:	56                   	push   %esi
  80090c:	53                   	push   %ebx
  80090d:	89 c6                	mov    %eax,%esi
  80090f:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  800911:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  800918:	74 27                	je     800941 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80091a:	6a 07                	push   $0x7
  80091c:	68 00 50 80 00       	push   $0x805000
  800921:	56                   	push   %esi
  800922:	ff 35 00 40 80 00    	pushl  0x804000
  800928:	e8 c6 16 00 00       	call   801ff3 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80092d:	83 c4 0c             	add    $0xc,%esp
  800930:	6a 00                	push   $0x0
  800932:	53                   	push   %ebx
  800933:	6a 00                	push   $0x0
  800935:	e8 50 16 00 00       	call   801f8a <ipc_recv>
}
  80093a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80093d:	5b                   	pop    %ebx
  80093e:	5e                   	pop    %esi
  80093f:	5d                   	pop    %ebp
  800940:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800941:	83 ec 0c             	sub    $0xc,%esp
  800944:	6a 01                	push   $0x1
  800946:	e8 01 17 00 00       	call   80204c <ipc_find_env>
  80094b:	a3 00 40 80 00       	mov    %eax,0x804000
  800950:	83 c4 10             	add    $0x10,%esp
  800953:	eb c5                	jmp    80091a <fsipc+0x12>

00800955 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  800955:	55                   	push   %ebp
  800956:	89 e5                	mov    %esp,%ebp
  800958:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80095b:	8b 45 08             	mov    0x8(%ebp),%eax
  80095e:	8b 40 0c             	mov    0xc(%eax),%eax
  800961:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  800966:	8b 45 0c             	mov    0xc(%ebp),%eax
  800969:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80096e:	ba 00 00 00 00       	mov    $0x0,%edx
  800973:	b8 02 00 00 00       	mov    $0x2,%eax
  800978:	e8 8b ff ff ff       	call   800908 <fsipc>
}
  80097d:	c9                   	leave  
  80097e:	c3                   	ret    

0080097f <devfile_flush>:
{
  80097f:	55                   	push   %ebp
  800980:	89 e5                	mov    %esp,%ebp
  800982:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800985:	8b 45 08             	mov    0x8(%ebp),%eax
  800988:	8b 40 0c             	mov    0xc(%eax),%eax
  80098b:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800990:	ba 00 00 00 00       	mov    $0x0,%edx
  800995:	b8 06 00 00 00       	mov    $0x6,%eax
  80099a:	e8 69 ff ff ff       	call   800908 <fsipc>
}
  80099f:	c9                   	leave  
  8009a0:	c3                   	ret    

008009a1 <devfile_stat>:
{
  8009a1:	55                   	push   %ebp
  8009a2:	89 e5                	mov    %esp,%ebp
  8009a4:	53                   	push   %ebx
  8009a5:	83 ec 04             	sub    $0x4,%esp
  8009a8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8009ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ae:	8b 40 0c             	mov    0xc(%eax),%eax
  8009b1:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8009b6:	ba 00 00 00 00       	mov    $0x0,%edx
  8009bb:	b8 05 00 00 00       	mov    $0x5,%eax
  8009c0:	e8 43 ff ff ff       	call   800908 <fsipc>
  8009c5:	85 c0                	test   %eax,%eax
  8009c7:	78 2c                	js     8009f5 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8009c9:	83 ec 08             	sub    $0x8,%esp
  8009cc:	68 00 50 80 00       	push   $0x805000
  8009d1:	53                   	push   %ebx
  8009d2:	e8 76 12 00 00       	call   801c4d <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8009d7:	a1 80 50 80 00       	mov    0x805080,%eax
  8009dc:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8009e2:	a1 84 50 80 00       	mov    0x805084,%eax
  8009e7:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8009ed:	83 c4 10             	add    $0x10,%esp
  8009f0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009f8:	c9                   	leave  
  8009f9:	c3                   	ret    

008009fa <devfile_write>:
{
  8009fa:	55                   	push   %ebp
  8009fb:	89 e5                	mov    %esp,%ebp
  8009fd:	53                   	push   %ebx
  8009fe:	83 ec 04             	sub    $0x4,%esp
  800a01:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  800a04:	8b 45 08             	mov    0x8(%ebp),%eax
  800a07:	8b 40 0c             	mov    0xc(%eax),%eax
  800a0a:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  800a0f:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  800a15:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  800a1b:	77 30                	ja     800a4d <devfile_write+0x53>
	memmove(fsipcbuf.write.req_buf, buf, n);
  800a1d:	83 ec 04             	sub    $0x4,%esp
  800a20:	53                   	push   %ebx
  800a21:	ff 75 0c             	pushl  0xc(%ebp)
  800a24:	68 08 50 80 00       	push   $0x805008
  800a29:	e8 ad 13 00 00       	call   801ddb <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  800a2e:	ba 00 00 00 00       	mov    $0x0,%edx
  800a33:	b8 04 00 00 00       	mov    $0x4,%eax
  800a38:	e8 cb fe ff ff       	call   800908 <fsipc>
  800a3d:	83 c4 10             	add    $0x10,%esp
  800a40:	85 c0                	test   %eax,%eax
  800a42:	78 04                	js     800a48 <devfile_write+0x4e>
	assert(r <= n);
  800a44:	39 d8                	cmp    %ebx,%eax
  800a46:	77 1e                	ja     800a66 <devfile_write+0x6c>
}
  800a48:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a4b:	c9                   	leave  
  800a4c:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  800a4d:	68 c8 23 80 00       	push   $0x8023c8
  800a52:	68 f5 23 80 00       	push   $0x8023f5
  800a57:	68 94 00 00 00       	push   $0x94
  800a5c:	68 0a 24 80 00       	push   $0x80240a
  800a61:	e8 6f 0a 00 00       	call   8014d5 <_panic>
	assert(r <= n);
  800a66:	68 15 24 80 00       	push   $0x802415
  800a6b:	68 f5 23 80 00       	push   $0x8023f5
  800a70:	68 98 00 00 00       	push   $0x98
  800a75:	68 0a 24 80 00       	push   $0x80240a
  800a7a:	e8 56 0a 00 00       	call   8014d5 <_panic>

00800a7f <devfile_read>:
{
  800a7f:	55                   	push   %ebp
  800a80:	89 e5                	mov    %esp,%ebp
  800a82:	56                   	push   %esi
  800a83:	53                   	push   %ebx
  800a84:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800a87:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8a:	8b 40 0c             	mov    0xc(%eax),%eax
  800a8d:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800a92:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800a98:	ba 00 00 00 00       	mov    $0x0,%edx
  800a9d:	b8 03 00 00 00       	mov    $0x3,%eax
  800aa2:	e8 61 fe ff ff       	call   800908 <fsipc>
  800aa7:	89 c3                	mov    %eax,%ebx
  800aa9:	85 c0                	test   %eax,%eax
  800aab:	78 1f                	js     800acc <devfile_read+0x4d>
	assert(r <= n);
  800aad:	39 f0                	cmp    %esi,%eax
  800aaf:	77 24                	ja     800ad5 <devfile_read+0x56>
	assert(r <= PGSIZE);
  800ab1:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800ab6:	7f 33                	jg     800aeb <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800ab8:	83 ec 04             	sub    $0x4,%esp
  800abb:	50                   	push   %eax
  800abc:	68 00 50 80 00       	push   $0x805000
  800ac1:	ff 75 0c             	pushl  0xc(%ebp)
  800ac4:	e8 12 13 00 00       	call   801ddb <memmove>
	return r;
  800ac9:	83 c4 10             	add    $0x10,%esp
}
  800acc:	89 d8                	mov    %ebx,%eax
  800ace:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ad1:	5b                   	pop    %ebx
  800ad2:	5e                   	pop    %esi
  800ad3:	5d                   	pop    %ebp
  800ad4:	c3                   	ret    
	assert(r <= n);
  800ad5:	68 15 24 80 00       	push   $0x802415
  800ada:	68 f5 23 80 00       	push   $0x8023f5
  800adf:	6a 7c                	push   $0x7c
  800ae1:	68 0a 24 80 00       	push   $0x80240a
  800ae6:	e8 ea 09 00 00       	call   8014d5 <_panic>
	assert(r <= PGSIZE);
  800aeb:	68 1c 24 80 00       	push   $0x80241c
  800af0:	68 f5 23 80 00       	push   $0x8023f5
  800af5:	6a 7d                	push   $0x7d
  800af7:	68 0a 24 80 00       	push   $0x80240a
  800afc:	e8 d4 09 00 00       	call   8014d5 <_panic>

00800b01 <open>:
{
  800b01:	55                   	push   %ebp
  800b02:	89 e5                	mov    %esp,%ebp
  800b04:	56                   	push   %esi
  800b05:	53                   	push   %ebx
  800b06:	83 ec 1c             	sub    $0x1c,%esp
  800b09:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800b0c:	56                   	push   %esi
  800b0d:	e8 04 11 00 00       	call   801c16 <strlen>
  800b12:	83 c4 10             	add    $0x10,%esp
  800b15:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800b1a:	7f 6c                	jg     800b88 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  800b1c:	83 ec 0c             	sub    $0xc,%esp
  800b1f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800b22:	50                   	push   %eax
  800b23:	e8 75 f8 ff ff       	call   80039d <fd_alloc>
  800b28:	89 c3                	mov    %eax,%ebx
  800b2a:	83 c4 10             	add    $0x10,%esp
  800b2d:	85 c0                	test   %eax,%eax
  800b2f:	78 3c                	js     800b6d <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  800b31:	83 ec 08             	sub    $0x8,%esp
  800b34:	56                   	push   %esi
  800b35:	68 00 50 80 00       	push   $0x805000
  800b3a:	e8 0e 11 00 00       	call   801c4d <strcpy>
	fsipcbuf.open.req_omode = mode;
  800b3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b42:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800b47:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b4a:	b8 01 00 00 00       	mov    $0x1,%eax
  800b4f:	e8 b4 fd ff ff       	call   800908 <fsipc>
  800b54:	89 c3                	mov    %eax,%ebx
  800b56:	83 c4 10             	add    $0x10,%esp
  800b59:	85 c0                	test   %eax,%eax
  800b5b:	78 19                	js     800b76 <open+0x75>
	return fd2num(fd);
  800b5d:	83 ec 0c             	sub    $0xc,%esp
  800b60:	ff 75 f4             	pushl  -0xc(%ebp)
  800b63:	e8 0e f8 ff ff       	call   800376 <fd2num>
  800b68:	89 c3                	mov    %eax,%ebx
  800b6a:	83 c4 10             	add    $0x10,%esp
}
  800b6d:	89 d8                	mov    %ebx,%eax
  800b6f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b72:	5b                   	pop    %ebx
  800b73:	5e                   	pop    %esi
  800b74:	5d                   	pop    %ebp
  800b75:	c3                   	ret    
		fd_close(fd, 0);
  800b76:	83 ec 08             	sub    $0x8,%esp
  800b79:	6a 00                	push   $0x0
  800b7b:	ff 75 f4             	pushl  -0xc(%ebp)
  800b7e:	e8 15 f9 ff ff       	call   800498 <fd_close>
		return r;
  800b83:	83 c4 10             	add    $0x10,%esp
  800b86:	eb e5                	jmp    800b6d <open+0x6c>
		return -E_BAD_PATH;
  800b88:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800b8d:	eb de                	jmp    800b6d <open+0x6c>

00800b8f <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800b8f:	55                   	push   %ebp
  800b90:	89 e5                	mov    %esp,%ebp
  800b92:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800b95:	ba 00 00 00 00       	mov    $0x0,%edx
  800b9a:	b8 08 00 00 00       	mov    $0x8,%eax
  800b9f:	e8 64 fd ff ff       	call   800908 <fsipc>
}
  800ba4:	c9                   	leave  
  800ba5:	c3                   	ret    

00800ba6 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800ba6:	55                   	push   %ebp
  800ba7:	89 e5                	mov    %esp,%ebp
  800ba9:	56                   	push   %esi
  800baa:	53                   	push   %ebx
  800bab:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800bae:	83 ec 0c             	sub    $0xc,%esp
  800bb1:	ff 75 08             	pushl  0x8(%ebp)
  800bb4:	e8 cd f7 ff ff       	call   800386 <fd2data>
  800bb9:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  800bbb:	83 c4 08             	add    $0x8,%esp
  800bbe:	68 28 24 80 00       	push   $0x802428
  800bc3:	53                   	push   %ebx
  800bc4:	e8 84 10 00 00       	call   801c4d <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  800bc9:	8b 46 04             	mov    0x4(%esi),%eax
  800bcc:	2b 06                	sub    (%esi),%eax
  800bce:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  800bd4:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800bdb:	00 00 00 
	stat->st_dev = &devpipe;
  800bde:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  800be5:	30 80 00 
	return 0;
}
  800be8:	b8 00 00 00 00       	mov    $0x0,%eax
  800bed:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bf0:	5b                   	pop    %ebx
  800bf1:	5e                   	pop    %esi
  800bf2:	5d                   	pop    %ebp
  800bf3:	c3                   	ret    

00800bf4 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  800bf4:	55                   	push   %ebp
  800bf5:	89 e5                	mov    %esp,%ebp
  800bf7:	53                   	push   %ebx
  800bf8:	83 ec 0c             	sub    $0xc,%esp
  800bfb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  800bfe:	53                   	push   %ebx
  800bff:	6a 00                	push   $0x0
  800c01:	e8 e5 f5 ff ff       	call   8001eb <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  800c06:	89 1c 24             	mov    %ebx,(%esp)
  800c09:	e8 78 f7 ff ff       	call   800386 <fd2data>
  800c0e:	83 c4 08             	add    $0x8,%esp
  800c11:	50                   	push   %eax
  800c12:	6a 00                	push   $0x0
  800c14:	e8 d2 f5 ff ff       	call   8001eb <sys_page_unmap>
}
  800c19:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c1c:	c9                   	leave  
  800c1d:	c3                   	ret    

00800c1e <_pipeisclosed>:
{
  800c1e:	55                   	push   %ebp
  800c1f:	89 e5                	mov    %esp,%ebp
  800c21:	57                   	push   %edi
  800c22:	56                   	push   %esi
  800c23:	53                   	push   %ebx
  800c24:	83 ec 1c             	sub    $0x1c,%esp
  800c27:	89 c7                	mov    %eax,%edi
  800c29:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  800c2b:	a1 08 40 80 00       	mov    0x804008,%eax
  800c30:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  800c33:	83 ec 0c             	sub    $0xc,%esp
  800c36:	57                   	push   %edi
  800c37:	e8 49 14 00 00       	call   802085 <pageref>
  800c3c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c3f:	89 34 24             	mov    %esi,(%esp)
  800c42:	e8 3e 14 00 00       	call   802085 <pageref>
		nn = thisenv->env_runs;
  800c47:	8b 15 08 40 80 00    	mov    0x804008,%edx
  800c4d:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  800c50:	83 c4 10             	add    $0x10,%esp
  800c53:	39 cb                	cmp    %ecx,%ebx
  800c55:	74 1b                	je     800c72 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  800c57:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800c5a:	75 cf                	jne    800c2b <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  800c5c:	8b 42 58             	mov    0x58(%edx),%eax
  800c5f:	6a 01                	push   $0x1
  800c61:	50                   	push   %eax
  800c62:	53                   	push   %ebx
  800c63:	68 2f 24 80 00       	push   $0x80242f
  800c68:	e8 43 09 00 00       	call   8015b0 <cprintf>
  800c6d:	83 c4 10             	add    $0x10,%esp
  800c70:	eb b9                	jmp    800c2b <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  800c72:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800c75:	0f 94 c0             	sete   %al
  800c78:	0f b6 c0             	movzbl %al,%eax
}
  800c7b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c7e:	5b                   	pop    %ebx
  800c7f:	5e                   	pop    %esi
  800c80:	5f                   	pop    %edi
  800c81:	5d                   	pop    %ebp
  800c82:	c3                   	ret    

00800c83 <devpipe_write>:
{
  800c83:	55                   	push   %ebp
  800c84:	89 e5                	mov    %esp,%ebp
  800c86:	57                   	push   %edi
  800c87:	56                   	push   %esi
  800c88:	53                   	push   %ebx
  800c89:	83 ec 28             	sub    $0x28,%esp
  800c8c:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  800c8f:	56                   	push   %esi
  800c90:	e8 f1 f6 ff ff       	call   800386 <fd2data>
  800c95:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800c97:	83 c4 10             	add    $0x10,%esp
  800c9a:	bf 00 00 00 00       	mov    $0x0,%edi
  800c9f:	3b 7d 10             	cmp    0x10(%ebp),%edi
  800ca2:	74 4f                	je     800cf3 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  800ca4:	8b 43 04             	mov    0x4(%ebx),%eax
  800ca7:	8b 0b                	mov    (%ebx),%ecx
  800ca9:	8d 51 20             	lea    0x20(%ecx),%edx
  800cac:	39 d0                	cmp    %edx,%eax
  800cae:	72 14                	jb     800cc4 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  800cb0:	89 da                	mov    %ebx,%edx
  800cb2:	89 f0                	mov    %esi,%eax
  800cb4:	e8 65 ff ff ff       	call   800c1e <_pipeisclosed>
  800cb9:	85 c0                	test   %eax,%eax
  800cbb:	75 3a                	jne    800cf7 <devpipe_write+0x74>
			sys_yield();
  800cbd:	e8 85 f4 ff ff       	call   800147 <sys_yield>
  800cc2:	eb e0                	jmp    800ca4 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  800cc4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cc7:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  800ccb:	88 4d e7             	mov    %cl,-0x19(%ebp)
  800cce:	89 c2                	mov    %eax,%edx
  800cd0:	c1 fa 1f             	sar    $0x1f,%edx
  800cd3:	89 d1                	mov    %edx,%ecx
  800cd5:	c1 e9 1b             	shr    $0x1b,%ecx
  800cd8:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  800cdb:	83 e2 1f             	and    $0x1f,%edx
  800cde:	29 ca                	sub    %ecx,%edx
  800ce0:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  800ce4:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  800ce8:	83 c0 01             	add    $0x1,%eax
  800ceb:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  800cee:	83 c7 01             	add    $0x1,%edi
  800cf1:	eb ac                	jmp    800c9f <devpipe_write+0x1c>
	return i;
  800cf3:	89 f8                	mov    %edi,%eax
  800cf5:	eb 05                	jmp    800cfc <devpipe_write+0x79>
				return 0;
  800cf7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cfc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cff:	5b                   	pop    %ebx
  800d00:	5e                   	pop    %esi
  800d01:	5f                   	pop    %edi
  800d02:	5d                   	pop    %ebp
  800d03:	c3                   	ret    

00800d04 <devpipe_read>:
{
  800d04:	55                   	push   %ebp
  800d05:	89 e5                	mov    %esp,%ebp
  800d07:	57                   	push   %edi
  800d08:	56                   	push   %esi
  800d09:	53                   	push   %ebx
  800d0a:	83 ec 18             	sub    $0x18,%esp
  800d0d:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  800d10:	57                   	push   %edi
  800d11:	e8 70 f6 ff ff       	call   800386 <fd2data>
  800d16:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800d18:	83 c4 10             	add    $0x10,%esp
  800d1b:	be 00 00 00 00       	mov    $0x0,%esi
  800d20:	3b 75 10             	cmp    0x10(%ebp),%esi
  800d23:	74 47                	je     800d6c <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  800d25:	8b 03                	mov    (%ebx),%eax
  800d27:	3b 43 04             	cmp    0x4(%ebx),%eax
  800d2a:	75 22                	jne    800d4e <devpipe_read+0x4a>
			if (i > 0)
  800d2c:	85 f6                	test   %esi,%esi
  800d2e:	75 14                	jne    800d44 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  800d30:	89 da                	mov    %ebx,%edx
  800d32:	89 f8                	mov    %edi,%eax
  800d34:	e8 e5 fe ff ff       	call   800c1e <_pipeisclosed>
  800d39:	85 c0                	test   %eax,%eax
  800d3b:	75 33                	jne    800d70 <devpipe_read+0x6c>
			sys_yield();
  800d3d:	e8 05 f4 ff ff       	call   800147 <sys_yield>
  800d42:	eb e1                	jmp    800d25 <devpipe_read+0x21>
				return i;
  800d44:	89 f0                	mov    %esi,%eax
}
  800d46:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d49:	5b                   	pop    %ebx
  800d4a:	5e                   	pop    %esi
  800d4b:	5f                   	pop    %edi
  800d4c:	5d                   	pop    %ebp
  800d4d:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  800d4e:	99                   	cltd   
  800d4f:	c1 ea 1b             	shr    $0x1b,%edx
  800d52:	01 d0                	add    %edx,%eax
  800d54:	83 e0 1f             	and    $0x1f,%eax
  800d57:	29 d0                	sub    %edx,%eax
  800d59:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  800d5e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d61:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  800d64:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  800d67:	83 c6 01             	add    $0x1,%esi
  800d6a:	eb b4                	jmp    800d20 <devpipe_read+0x1c>
	return i;
  800d6c:	89 f0                	mov    %esi,%eax
  800d6e:	eb d6                	jmp    800d46 <devpipe_read+0x42>
				return 0;
  800d70:	b8 00 00 00 00       	mov    $0x0,%eax
  800d75:	eb cf                	jmp    800d46 <devpipe_read+0x42>

00800d77 <pipe>:
{
  800d77:	55                   	push   %ebp
  800d78:	89 e5                	mov    %esp,%ebp
  800d7a:	56                   	push   %esi
  800d7b:	53                   	push   %ebx
  800d7c:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  800d7f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800d82:	50                   	push   %eax
  800d83:	e8 15 f6 ff ff       	call   80039d <fd_alloc>
  800d88:	89 c3                	mov    %eax,%ebx
  800d8a:	83 c4 10             	add    $0x10,%esp
  800d8d:	85 c0                	test   %eax,%eax
  800d8f:	78 5b                	js     800dec <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800d91:	83 ec 04             	sub    $0x4,%esp
  800d94:	68 07 04 00 00       	push   $0x407
  800d99:	ff 75 f4             	pushl  -0xc(%ebp)
  800d9c:	6a 00                	push   $0x0
  800d9e:	e8 c3 f3 ff ff       	call   800166 <sys_page_alloc>
  800da3:	89 c3                	mov    %eax,%ebx
  800da5:	83 c4 10             	add    $0x10,%esp
  800da8:	85 c0                	test   %eax,%eax
  800daa:	78 40                	js     800dec <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  800dac:	83 ec 0c             	sub    $0xc,%esp
  800daf:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800db2:	50                   	push   %eax
  800db3:	e8 e5 f5 ff ff       	call   80039d <fd_alloc>
  800db8:	89 c3                	mov    %eax,%ebx
  800dba:	83 c4 10             	add    $0x10,%esp
  800dbd:	85 c0                	test   %eax,%eax
  800dbf:	78 1b                	js     800ddc <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800dc1:	83 ec 04             	sub    $0x4,%esp
  800dc4:	68 07 04 00 00       	push   $0x407
  800dc9:	ff 75 f0             	pushl  -0x10(%ebp)
  800dcc:	6a 00                	push   $0x0
  800dce:	e8 93 f3 ff ff       	call   800166 <sys_page_alloc>
  800dd3:	89 c3                	mov    %eax,%ebx
  800dd5:	83 c4 10             	add    $0x10,%esp
  800dd8:	85 c0                	test   %eax,%eax
  800dda:	79 19                	jns    800df5 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  800ddc:	83 ec 08             	sub    $0x8,%esp
  800ddf:	ff 75 f4             	pushl  -0xc(%ebp)
  800de2:	6a 00                	push   $0x0
  800de4:	e8 02 f4 ff ff       	call   8001eb <sys_page_unmap>
  800de9:	83 c4 10             	add    $0x10,%esp
}
  800dec:	89 d8                	mov    %ebx,%eax
  800dee:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800df1:	5b                   	pop    %ebx
  800df2:	5e                   	pop    %esi
  800df3:	5d                   	pop    %ebp
  800df4:	c3                   	ret    
	va = fd2data(fd0);
  800df5:	83 ec 0c             	sub    $0xc,%esp
  800df8:	ff 75 f4             	pushl  -0xc(%ebp)
  800dfb:	e8 86 f5 ff ff       	call   800386 <fd2data>
  800e00:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e02:	83 c4 0c             	add    $0xc,%esp
  800e05:	68 07 04 00 00       	push   $0x407
  800e0a:	50                   	push   %eax
  800e0b:	6a 00                	push   $0x0
  800e0d:	e8 54 f3 ff ff       	call   800166 <sys_page_alloc>
  800e12:	89 c3                	mov    %eax,%ebx
  800e14:	83 c4 10             	add    $0x10,%esp
  800e17:	85 c0                	test   %eax,%eax
  800e19:	0f 88 8c 00 00 00    	js     800eab <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e1f:	83 ec 0c             	sub    $0xc,%esp
  800e22:	ff 75 f0             	pushl  -0x10(%ebp)
  800e25:	e8 5c f5 ff ff       	call   800386 <fd2data>
  800e2a:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  800e31:	50                   	push   %eax
  800e32:	6a 00                	push   $0x0
  800e34:	56                   	push   %esi
  800e35:	6a 00                	push   $0x0
  800e37:	e8 6d f3 ff ff       	call   8001a9 <sys_page_map>
  800e3c:	89 c3                	mov    %eax,%ebx
  800e3e:	83 c4 20             	add    $0x20,%esp
  800e41:	85 c0                	test   %eax,%eax
  800e43:	78 58                	js     800e9d <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  800e45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e48:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800e4e:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  800e50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e53:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  800e5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e5d:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800e63:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  800e65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e68:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  800e6f:	83 ec 0c             	sub    $0xc,%esp
  800e72:	ff 75 f4             	pushl  -0xc(%ebp)
  800e75:	e8 fc f4 ff ff       	call   800376 <fd2num>
  800e7a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e7d:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  800e7f:	83 c4 04             	add    $0x4,%esp
  800e82:	ff 75 f0             	pushl  -0x10(%ebp)
  800e85:	e8 ec f4 ff ff       	call   800376 <fd2num>
  800e8a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e8d:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  800e90:	83 c4 10             	add    $0x10,%esp
  800e93:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e98:	e9 4f ff ff ff       	jmp    800dec <pipe+0x75>
	sys_page_unmap(0, va);
  800e9d:	83 ec 08             	sub    $0x8,%esp
  800ea0:	56                   	push   %esi
  800ea1:	6a 00                	push   $0x0
  800ea3:	e8 43 f3 ff ff       	call   8001eb <sys_page_unmap>
  800ea8:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  800eab:	83 ec 08             	sub    $0x8,%esp
  800eae:	ff 75 f0             	pushl  -0x10(%ebp)
  800eb1:	6a 00                	push   $0x0
  800eb3:	e8 33 f3 ff ff       	call   8001eb <sys_page_unmap>
  800eb8:	83 c4 10             	add    $0x10,%esp
  800ebb:	e9 1c ff ff ff       	jmp    800ddc <pipe+0x65>

00800ec0 <pipeisclosed>:
{
  800ec0:	55                   	push   %ebp
  800ec1:	89 e5                	mov    %esp,%ebp
  800ec3:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800ec6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800ec9:	50                   	push   %eax
  800eca:	ff 75 08             	pushl  0x8(%ebp)
  800ecd:	e8 1a f5 ff ff       	call   8003ec <fd_lookup>
  800ed2:	83 c4 10             	add    $0x10,%esp
  800ed5:	85 c0                	test   %eax,%eax
  800ed7:	78 18                	js     800ef1 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  800ed9:	83 ec 0c             	sub    $0xc,%esp
  800edc:	ff 75 f4             	pushl  -0xc(%ebp)
  800edf:	e8 a2 f4 ff ff       	call   800386 <fd2data>
	return _pipeisclosed(fd, p);
  800ee4:	89 c2                	mov    %eax,%edx
  800ee6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ee9:	e8 30 fd ff ff       	call   800c1e <_pipeisclosed>
  800eee:	83 c4 10             	add    $0x10,%esp
}
  800ef1:	c9                   	leave  
  800ef2:	c3                   	ret    

00800ef3 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  800ef3:	55                   	push   %ebp
  800ef4:	89 e5                	mov    %esp,%ebp
  800ef6:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  800ef9:	68 47 24 80 00       	push   $0x802447
  800efe:	ff 75 0c             	pushl  0xc(%ebp)
  800f01:	e8 47 0d 00 00       	call   801c4d <strcpy>
	return 0;
}
  800f06:	b8 00 00 00 00       	mov    $0x0,%eax
  800f0b:	c9                   	leave  
  800f0c:	c3                   	ret    

00800f0d <devsock_close>:
{
  800f0d:	55                   	push   %ebp
  800f0e:	89 e5                	mov    %esp,%ebp
  800f10:	53                   	push   %ebx
  800f11:	83 ec 10             	sub    $0x10,%esp
  800f14:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  800f17:	53                   	push   %ebx
  800f18:	e8 68 11 00 00       	call   802085 <pageref>
  800f1d:	83 c4 10             	add    $0x10,%esp
		return 0;
  800f20:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  800f25:	83 f8 01             	cmp    $0x1,%eax
  800f28:	74 07                	je     800f31 <devsock_close+0x24>
}
  800f2a:	89 d0                	mov    %edx,%eax
  800f2c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f2f:	c9                   	leave  
  800f30:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  800f31:	83 ec 0c             	sub    $0xc,%esp
  800f34:	ff 73 0c             	pushl  0xc(%ebx)
  800f37:	e8 b7 02 00 00       	call   8011f3 <nsipc_close>
  800f3c:	89 c2                	mov    %eax,%edx
  800f3e:	83 c4 10             	add    $0x10,%esp
  800f41:	eb e7                	jmp    800f2a <devsock_close+0x1d>

00800f43 <devsock_write>:
{
  800f43:	55                   	push   %ebp
  800f44:	89 e5                	mov    %esp,%ebp
  800f46:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  800f49:	6a 00                	push   $0x0
  800f4b:	ff 75 10             	pushl  0x10(%ebp)
  800f4e:	ff 75 0c             	pushl  0xc(%ebp)
  800f51:	8b 45 08             	mov    0x8(%ebp),%eax
  800f54:	ff 70 0c             	pushl  0xc(%eax)
  800f57:	e8 74 03 00 00       	call   8012d0 <nsipc_send>
}
  800f5c:	c9                   	leave  
  800f5d:	c3                   	ret    

00800f5e <devsock_read>:
{
  800f5e:	55                   	push   %ebp
  800f5f:	89 e5                	mov    %esp,%ebp
  800f61:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  800f64:	6a 00                	push   $0x0
  800f66:	ff 75 10             	pushl  0x10(%ebp)
  800f69:	ff 75 0c             	pushl  0xc(%ebp)
  800f6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6f:	ff 70 0c             	pushl  0xc(%eax)
  800f72:	e8 ed 02 00 00       	call   801264 <nsipc_recv>
}
  800f77:	c9                   	leave  
  800f78:	c3                   	ret    

00800f79 <fd2sockid>:
{
  800f79:	55                   	push   %ebp
  800f7a:	89 e5                	mov    %esp,%ebp
  800f7c:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  800f7f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800f82:	52                   	push   %edx
  800f83:	50                   	push   %eax
  800f84:	e8 63 f4 ff ff       	call   8003ec <fd_lookup>
  800f89:	83 c4 10             	add    $0x10,%esp
  800f8c:	85 c0                	test   %eax,%eax
  800f8e:	78 10                	js     800fa0 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  800f90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f93:	8b 0d 3c 30 80 00    	mov    0x80303c,%ecx
  800f99:	39 08                	cmp    %ecx,(%eax)
  800f9b:	75 05                	jne    800fa2 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  800f9d:	8b 40 0c             	mov    0xc(%eax),%eax
}
  800fa0:	c9                   	leave  
  800fa1:	c3                   	ret    
		return -E_NOT_SUPP;
  800fa2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800fa7:	eb f7                	jmp    800fa0 <fd2sockid+0x27>

00800fa9 <alloc_sockfd>:
{
  800fa9:	55                   	push   %ebp
  800faa:	89 e5                	mov    %esp,%ebp
  800fac:	56                   	push   %esi
  800fad:	53                   	push   %ebx
  800fae:	83 ec 1c             	sub    $0x1c,%esp
  800fb1:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  800fb3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800fb6:	50                   	push   %eax
  800fb7:	e8 e1 f3 ff ff       	call   80039d <fd_alloc>
  800fbc:	89 c3                	mov    %eax,%ebx
  800fbe:	83 c4 10             	add    $0x10,%esp
  800fc1:	85 c0                	test   %eax,%eax
  800fc3:	78 43                	js     801008 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  800fc5:	83 ec 04             	sub    $0x4,%esp
  800fc8:	68 07 04 00 00       	push   $0x407
  800fcd:	ff 75 f4             	pushl  -0xc(%ebp)
  800fd0:	6a 00                	push   $0x0
  800fd2:	e8 8f f1 ff ff       	call   800166 <sys_page_alloc>
  800fd7:	89 c3                	mov    %eax,%ebx
  800fd9:	83 c4 10             	add    $0x10,%esp
  800fdc:	85 c0                	test   %eax,%eax
  800fde:	78 28                	js     801008 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  800fe0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fe3:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  800fe9:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  800feb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fee:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  800ff5:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  800ff8:	83 ec 0c             	sub    $0xc,%esp
  800ffb:	50                   	push   %eax
  800ffc:	e8 75 f3 ff ff       	call   800376 <fd2num>
  801001:	89 c3                	mov    %eax,%ebx
  801003:	83 c4 10             	add    $0x10,%esp
  801006:	eb 0c                	jmp    801014 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801008:	83 ec 0c             	sub    $0xc,%esp
  80100b:	56                   	push   %esi
  80100c:	e8 e2 01 00 00       	call   8011f3 <nsipc_close>
		return r;
  801011:	83 c4 10             	add    $0x10,%esp
}
  801014:	89 d8                	mov    %ebx,%eax
  801016:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801019:	5b                   	pop    %ebx
  80101a:	5e                   	pop    %esi
  80101b:	5d                   	pop    %ebp
  80101c:	c3                   	ret    

0080101d <accept>:
{
  80101d:	55                   	push   %ebp
  80101e:	89 e5                	mov    %esp,%ebp
  801020:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801023:	8b 45 08             	mov    0x8(%ebp),%eax
  801026:	e8 4e ff ff ff       	call   800f79 <fd2sockid>
  80102b:	85 c0                	test   %eax,%eax
  80102d:	78 1b                	js     80104a <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80102f:	83 ec 04             	sub    $0x4,%esp
  801032:	ff 75 10             	pushl  0x10(%ebp)
  801035:	ff 75 0c             	pushl  0xc(%ebp)
  801038:	50                   	push   %eax
  801039:	e8 0e 01 00 00       	call   80114c <nsipc_accept>
  80103e:	83 c4 10             	add    $0x10,%esp
  801041:	85 c0                	test   %eax,%eax
  801043:	78 05                	js     80104a <accept+0x2d>
	return alloc_sockfd(r);
  801045:	e8 5f ff ff ff       	call   800fa9 <alloc_sockfd>
}
  80104a:	c9                   	leave  
  80104b:	c3                   	ret    

0080104c <bind>:
{
  80104c:	55                   	push   %ebp
  80104d:	89 e5                	mov    %esp,%ebp
  80104f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801052:	8b 45 08             	mov    0x8(%ebp),%eax
  801055:	e8 1f ff ff ff       	call   800f79 <fd2sockid>
  80105a:	85 c0                	test   %eax,%eax
  80105c:	78 12                	js     801070 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  80105e:	83 ec 04             	sub    $0x4,%esp
  801061:	ff 75 10             	pushl  0x10(%ebp)
  801064:	ff 75 0c             	pushl  0xc(%ebp)
  801067:	50                   	push   %eax
  801068:	e8 2f 01 00 00       	call   80119c <nsipc_bind>
  80106d:	83 c4 10             	add    $0x10,%esp
}
  801070:	c9                   	leave  
  801071:	c3                   	ret    

00801072 <shutdown>:
{
  801072:	55                   	push   %ebp
  801073:	89 e5                	mov    %esp,%ebp
  801075:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801078:	8b 45 08             	mov    0x8(%ebp),%eax
  80107b:	e8 f9 fe ff ff       	call   800f79 <fd2sockid>
  801080:	85 c0                	test   %eax,%eax
  801082:	78 0f                	js     801093 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801084:	83 ec 08             	sub    $0x8,%esp
  801087:	ff 75 0c             	pushl  0xc(%ebp)
  80108a:	50                   	push   %eax
  80108b:	e8 41 01 00 00       	call   8011d1 <nsipc_shutdown>
  801090:	83 c4 10             	add    $0x10,%esp
}
  801093:	c9                   	leave  
  801094:	c3                   	ret    

00801095 <connect>:
{
  801095:	55                   	push   %ebp
  801096:	89 e5                	mov    %esp,%ebp
  801098:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80109b:	8b 45 08             	mov    0x8(%ebp),%eax
  80109e:	e8 d6 fe ff ff       	call   800f79 <fd2sockid>
  8010a3:	85 c0                	test   %eax,%eax
  8010a5:	78 12                	js     8010b9 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8010a7:	83 ec 04             	sub    $0x4,%esp
  8010aa:	ff 75 10             	pushl  0x10(%ebp)
  8010ad:	ff 75 0c             	pushl  0xc(%ebp)
  8010b0:	50                   	push   %eax
  8010b1:	e8 57 01 00 00       	call   80120d <nsipc_connect>
  8010b6:	83 c4 10             	add    $0x10,%esp
}
  8010b9:	c9                   	leave  
  8010ba:	c3                   	ret    

008010bb <listen>:
{
  8010bb:	55                   	push   %ebp
  8010bc:	89 e5                	mov    %esp,%ebp
  8010be:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8010c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c4:	e8 b0 fe ff ff       	call   800f79 <fd2sockid>
  8010c9:	85 c0                	test   %eax,%eax
  8010cb:	78 0f                	js     8010dc <listen+0x21>
	return nsipc_listen(r, backlog);
  8010cd:	83 ec 08             	sub    $0x8,%esp
  8010d0:	ff 75 0c             	pushl  0xc(%ebp)
  8010d3:	50                   	push   %eax
  8010d4:	e8 69 01 00 00       	call   801242 <nsipc_listen>
  8010d9:	83 c4 10             	add    $0x10,%esp
}
  8010dc:	c9                   	leave  
  8010dd:	c3                   	ret    

008010de <socket>:

int
socket(int domain, int type, int protocol)
{
  8010de:	55                   	push   %ebp
  8010df:	89 e5                	mov    %esp,%ebp
  8010e1:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8010e4:	ff 75 10             	pushl  0x10(%ebp)
  8010e7:	ff 75 0c             	pushl  0xc(%ebp)
  8010ea:	ff 75 08             	pushl  0x8(%ebp)
  8010ed:	e8 3c 02 00 00       	call   80132e <nsipc_socket>
  8010f2:	83 c4 10             	add    $0x10,%esp
  8010f5:	85 c0                	test   %eax,%eax
  8010f7:	78 05                	js     8010fe <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8010f9:	e8 ab fe ff ff       	call   800fa9 <alloc_sockfd>
}
  8010fe:	c9                   	leave  
  8010ff:	c3                   	ret    

00801100 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801100:	55                   	push   %ebp
  801101:	89 e5                	mov    %esp,%ebp
  801103:	53                   	push   %ebx
  801104:	83 ec 04             	sub    $0x4,%esp
  801107:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801109:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801110:	74 26                	je     801138 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801112:	6a 07                	push   $0x7
  801114:	68 00 60 80 00       	push   $0x806000
  801119:	53                   	push   %ebx
  80111a:	ff 35 04 40 80 00    	pushl  0x804004
  801120:	e8 ce 0e 00 00       	call   801ff3 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801125:	83 c4 0c             	add    $0xc,%esp
  801128:	6a 00                	push   $0x0
  80112a:	6a 00                	push   $0x0
  80112c:	6a 00                	push   $0x0
  80112e:	e8 57 0e 00 00       	call   801f8a <ipc_recv>
}
  801133:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801136:	c9                   	leave  
  801137:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801138:	83 ec 0c             	sub    $0xc,%esp
  80113b:	6a 02                	push   $0x2
  80113d:	e8 0a 0f 00 00       	call   80204c <ipc_find_env>
  801142:	a3 04 40 80 00       	mov    %eax,0x804004
  801147:	83 c4 10             	add    $0x10,%esp
  80114a:	eb c6                	jmp    801112 <nsipc+0x12>

0080114c <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80114c:	55                   	push   %ebp
  80114d:	89 e5                	mov    %esp,%ebp
  80114f:	56                   	push   %esi
  801150:	53                   	push   %ebx
  801151:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801154:	8b 45 08             	mov    0x8(%ebp),%eax
  801157:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80115c:	8b 06                	mov    (%esi),%eax
  80115e:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801163:	b8 01 00 00 00       	mov    $0x1,%eax
  801168:	e8 93 ff ff ff       	call   801100 <nsipc>
  80116d:	89 c3                	mov    %eax,%ebx
  80116f:	85 c0                	test   %eax,%eax
  801171:	78 20                	js     801193 <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801173:	83 ec 04             	sub    $0x4,%esp
  801176:	ff 35 10 60 80 00    	pushl  0x806010
  80117c:	68 00 60 80 00       	push   $0x806000
  801181:	ff 75 0c             	pushl  0xc(%ebp)
  801184:	e8 52 0c 00 00       	call   801ddb <memmove>
		*addrlen = ret->ret_addrlen;
  801189:	a1 10 60 80 00       	mov    0x806010,%eax
  80118e:	89 06                	mov    %eax,(%esi)
  801190:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  801193:	89 d8                	mov    %ebx,%eax
  801195:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801198:	5b                   	pop    %ebx
  801199:	5e                   	pop    %esi
  80119a:	5d                   	pop    %ebp
  80119b:	c3                   	ret    

0080119c <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80119c:	55                   	push   %ebp
  80119d:	89 e5                	mov    %esp,%ebp
  80119f:	53                   	push   %ebx
  8011a0:	83 ec 08             	sub    $0x8,%esp
  8011a3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8011a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a9:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8011ae:	53                   	push   %ebx
  8011af:	ff 75 0c             	pushl  0xc(%ebp)
  8011b2:	68 04 60 80 00       	push   $0x806004
  8011b7:	e8 1f 0c 00 00       	call   801ddb <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8011bc:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  8011c2:	b8 02 00 00 00       	mov    $0x2,%eax
  8011c7:	e8 34 ff ff ff       	call   801100 <nsipc>
}
  8011cc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011cf:	c9                   	leave  
  8011d0:	c3                   	ret    

008011d1 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8011d1:	55                   	push   %ebp
  8011d2:	89 e5                	mov    %esp,%ebp
  8011d4:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8011d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011da:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  8011df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e2:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  8011e7:	b8 03 00 00 00       	mov    $0x3,%eax
  8011ec:	e8 0f ff ff ff       	call   801100 <nsipc>
}
  8011f1:	c9                   	leave  
  8011f2:	c3                   	ret    

008011f3 <nsipc_close>:

int
nsipc_close(int s)
{
  8011f3:	55                   	push   %ebp
  8011f4:	89 e5                	mov    %esp,%ebp
  8011f6:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8011f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fc:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801201:	b8 04 00 00 00       	mov    $0x4,%eax
  801206:	e8 f5 fe ff ff       	call   801100 <nsipc>
}
  80120b:	c9                   	leave  
  80120c:	c3                   	ret    

0080120d <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80120d:	55                   	push   %ebp
  80120e:	89 e5                	mov    %esp,%ebp
  801210:	53                   	push   %ebx
  801211:	83 ec 08             	sub    $0x8,%esp
  801214:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801217:	8b 45 08             	mov    0x8(%ebp),%eax
  80121a:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80121f:	53                   	push   %ebx
  801220:	ff 75 0c             	pushl  0xc(%ebp)
  801223:	68 04 60 80 00       	push   $0x806004
  801228:	e8 ae 0b 00 00       	call   801ddb <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80122d:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801233:	b8 05 00 00 00       	mov    $0x5,%eax
  801238:	e8 c3 fe ff ff       	call   801100 <nsipc>
}
  80123d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801240:	c9                   	leave  
  801241:	c3                   	ret    

00801242 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801242:	55                   	push   %ebp
  801243:	89 e5                	mov    %esp,%ebp
  801245:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801248:	8b 45 08             	mov    0x8(%ebp),%eax
  80124b:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801250:	8b 45 0c             	mov    0xc(%ebp),%eax
  801253:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801258:	b8 06 00 00 00       	mov    $0x6,%eax
  80125d:	e8 9e fe ff ff       	call   801100 <nsipc>
}
  801262:	c9                   	leave  
  801263:	c3                   	ret    

00801264 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801264:	55                   	push   %ebp
  801265:	89 e5                	mov    %esp,%ebp
  801267:	56                   	push   %esi
  801268:	53                   	push   %ebx
  801269:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  80126c:	8b 45 08             	mov    0x8(%ebp),%eax
  80126f:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801274:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  80127a:	8b 45 14             	mov    0x14(%ebp),%eax
  80127d:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801282:	b8 07 00 00 00       	mov    $0x7,%eax
  801287:	e8 74 fe ff ff       	call   801100 <nsipc>
  80128c:	89 c3                	mov    %eax,%ebx
  80128e:	85 c0                	test   %eax,%eax
  801290:	78 1f                	js     8012b1 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801292:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801297:	7f 21                	jg     8012ba <nsipc_recv+0x56>
  801299:	39 c6                	cmp    %eax,%esi
  80129b:	7c 1d                	jl     8012ba <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80129d:	83 ec 04             	sub    $0x4,%esp
  8012a0:	50                   	push   %eax
  8012a1:	68 00 60 80 00       	push   $0x806000
  8012a6:	ff 75 0c             	pushl  0xc(%ebp)
  8012a9:	e8 2d 0b 00 00       	call   801ddb <memmove>
  8012ae:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8012b1:	89 d8                	mov    %ebx,%eax
  8012b3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012b6:	5b                   	pop    %ebx
  8012b7:	5e                   	pop    %esi
  8012b8:	5d                   	pop    %ebp
  8012b9:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8012ba:	68 53 24 80 00       	push   $0x802453
  8012bf:	68 f5 23 80 00       	push   $0x8023f5
  8012c4:	6a 62                	push   $0x62
  8012c6:	68 68 24 80 00       	push   $0x802468
  8012cb:	e8 05 02 00 00       	call   8014d5 <_panic>

008012d0 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8012d0:	55                   	push   %ebp
  8012d1:	89 e5                	mov    %esp,%ebp
  8012d3:	53                   	push   %ebx
  8012d4:	83 ec 04             	sub    $0x4,%esp
  8012d7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8012da:	8b 45 08             	mov    0x8(%ebp),%eax
  8012dd:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  8012e2:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8012e8:	7f 2e                	jg     801318 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8012ea:	83 ec 04             	sub    $0x4,%esp
  8012ed:	53                   	push   %ebx
  8012ee:	ff 75 0c             	pushl  0xc(%ebp)
  8012f1:	68 0c 60 80 00       	push   $0x80600c
  8012f6:	e8 e0 0a 00 00       	call   801ddb <memmove>
	nsipcbuf.send.req_size = size;
  8012fb:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801301:	8b 45 14             	mov    0x14(%ebp),%eax
  801304:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801309:	b8 08 00 00 00       	mov    $0x8,%eax
  80130e:	e8 ed fd ff ff       	call   801100 <nsipc>
}
  801313:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801316:	c9                   	leave  
  801317:	c3                   	ret    
	assert(size < 1600);
  801318:	68 74 24 80 00       	push   $0x802474
  80131d:	68 f5 23 80 00       	push   $0x8023f5
  801322:	6a 6d                	push   $0x6d
  801324:	68 68 24 80 00       	push   $0x802468
  801329:	e8 a7 01 00 00       	call   8014d5 <_panic>

0080132e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80132e:	55                   	push   %ebp
  80132f:	89 e5                	mov    %esp,%ebp
  801331:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801334:	8b 45 08             	mov    0x8(%ebp),%eax
  801337:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  80133c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80133f:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801344:	8b 45 10             	mov    0x10(%ebp),%eax
  801347:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  80134c:	b8 09 00 00 00       	mov    $0x9,%eax
  801351:	e8 aa fd ff ff       	call   801100 <nsipc>
}
  801356:	c9                   	leave  
  801357:	c3                   	ret    

00801358 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801358:	55                   	push   %ebp
  801359:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  80135b:	b8 00 00 00 00       	mov    $0x0,%eax
  801360:	5d                   	pop    %ebp
  801361:	c3                   	ret    

00801362 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801362:	55                   	push   %ebp
  801363:	89 e5                	mov    %esp,%ebp
  801365:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801368:	68 80 24 80 00       	push   $0x802480
  80136d:	ff 75 0c             	pushl  0xc(%ebp)
  801370:	e8 d8 08 00 00       	call   801c4d <strcpy>
	return 0;
}
  801375:	b8 00 00 00 00       	mov    $0x0,%eax
  80137a:	c9                   	leave  
  80137b:	c3                   	ret    

0080137c <devcons_write>:
{
  80137c:	55                   	push   %ebp
  80137d:	89 e5                	mov    %esp,%ebp
  80137f:	57                   	push   %edi
  801380:	56                   	push   %esi
  801381:	53                   	push   %ebx
  801382:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801388:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80138d:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801393:	eb 2f                	jmp    8013c4 <devcons_write+0x48>
		m = n - tot;
  801395:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801398:	29 f3                	sub    %esi,%ebx
  80139a:	83 fb 7f             	cmp    $0x7f,%ebx
  80139d:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8013a2:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8013a5:	83 ec 04             	sub    $0x4,%esp
  8013a8:	53                   	push   %ebx
  8013a9:	89 f0                	mov    %esi,%eax
  8013ab:	03 45 0c             	add    0xc(%ebp),%eax
  8013ae:	50                   	push   %eax
  8013af:	57                   	push   %edi
  8013b0:	e8 26 0a 00 00       	call   801ddb <memmove>
		sys_cputs(buf, m);
  8013b5:	83 c4 08             	add    $0x8,%esp
  8013b8:	53                   	push   %ebx
  8013b9:	57                   	push   %edi
  8013ba:	e8 eb ec ff ff       	call   8000aa <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8013bf:	01 de                	add    %ebx,%esi
  8013c1:	83 c4 10             	add    $0x10,%esp
  8013c4:	3b 75 10             	cmp    0x10(%ebp),%esi
  8013c7:	72 cc                	jb     801395 <devcons_write+0x19>
}
  8013c9:	89 f0                	mov    %esi,%eax
  8013cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013ce:	5b                   	pop    %ebx
  8013cf:	5e                   	pop    %esi
  8013d0:	5f                   	pop    %edi
  8013d1:	5d                   	pop    %ebp
  8013d2:	c3                   	ret    

008013d3 <devcons_read>:
{
  8013d3:	55                   	push   %ebp
  8013d4:	89 e5                	mov    %esp,%ebp
  8013d6:	83 ec 08             	sub    $0x8,%esp
  8013d9:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8013de:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013e2:	75 07                	jne    8013eb <devcons_read+0x18>
}
  8013e4:	c9                   	leave  
  8013e5:	c3                   	ret    
		sys_yield();
  8013e6:	e8 5c ed ff ff       	call   800147 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  8013eb:	e8 d8 ec ff ff       	call   8000c8 <sys_cgetc>
  8013f0:	85 c0                	test   %eax,%eax
  8013f2:	74 f2                	je     8013e6 <devcons_read+0x13>
	if (c < 0)
  8013f4:	85 c0                	test   %eax,%eax
  8013f6:	78 ec                	js     8013e4 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  8013f8:	83 f8 04             	cmp    $0x4,%eax
  8013fb:	74 0c                	je     801409 <devcons_read+0x36>
	*(char*)vbuf = c;
  8013fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801400:	88 02                	mov    %al,(%edx)
	return 1;
  801402:	b8 01 00 00 00       	mov    $0x1,%eax
  801407:	eb db                	jmp    8013e4 <devcons_read+0x11>
		return 0;
  801409:	b8 00 00 00 00       	mov    $0x0,%eax
  80140e:	eb d4                	jmp    8013e4 <devcons_read+0x11>

00801410 <cputchar>:
{
  801410:	55                   	push   %ebp
  801411:	89 e5                	mov    %esp,%ebp
  801413:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801416:	8b 45 08             	mov    0x8(%ebp),%eax
  801419:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80141c:	6a 01                	push   $0x1
  80141e:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801421:	50                   	push   %eax
  801422:	e8 83 ec ff ff       	call   8000aa <sys_cputs>
}
  801427:	83 c4 10             	add    $0x10,%esp
  80142a:	c9                   	leave  
  80142b:	c3                   	ret    

0080142c <getchar>:
{
  80142c:	55                   	push   %ebp
  80142d:	89 e5                	mov    %esp,%ebp
  80142f:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801432:	6a 01                	push   $0x1
  801434:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801437:	50                   	push   %eax
  801438:	6a 00                	push   $0x0
  80143a:	e8 1e f2 ff ff       	call   80065d <read>
	if (r < 0)
  80143f:	83 c4 10             	add    $0x10,%esp
  801442:	85 c0                	test   %eax,%eax
  801444:	78 08                	js     80144e <getchar+0x22>
	if (r < 1)
  801446:	85 c0                	test   %eax,%eax
  801448:	7e 06                	jle    801450 <getchar+0x24>
	return c;
  80144a:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80144e:	c9                   	leave  
  80144f:	c3                   	ret    
		return -E_EOF;
  801450:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801455:	eb f7                	jmp    80144e <getchar+0x22>

00801457 <iscons>:
{
  801457:	55                   	push   %ebp
  801458:	89 e5                	mov    %esp,%ebp
  80145a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80145d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801460:	50                   	push   %eax
  801461:	ff 75 08             	pushl  0x8(%ebp)
  801464:	e8 83 ef ff ff       	call   8003ec <fd_lookup>
  801469:	83 c4 10             	add    $0x10,%esp
  80146c:	85 c0                	test   %eax,%eax
  80146e:	78 11                	js     801481 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801470:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801473:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801479:	39 10                	cmp    %edx,(%eax)
  80147b:	0f 94 c0             	sete   %al
  80147e:	0f b6 c0             	movzbl %al,%eax
}
  801481:	c9                   	leave  
  801482:	c3                   	ret    

00801483 <opencons>:
{
  801483:	55                   	push   %ebp
  801484:	89 e5                	mov    %esp,%ebp
  801486:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801489:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80148c:	50                   	push   %eax
  80148d:	e8 0b ef ff ff       	call   80039d <fd_alloc>
  801492:	83 c4 10             	add    $0x10,%esp
  801495:	85 c0                	test   %eax,%eax
  801497:	78 3a                	js     8014d3 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801499:	83 ec 04             	sub    $0x4,%esp
  80149c:	68 07 04 00 00       	push   $0x407
  8014a1:	ff 75 f4             	pushl  -0xc(%ebp)
  8014a4:	6a 00                	push   $0x0
  8014a6:	e8 bb ec ff ff       	call   800166 <sys_page_alloc>
  8014ab:	83 c4 10             	add    $0x10,%esp
  8014ae:	85 c0                	test   %eax,%eax
  8014b0:	78 21                	js     8014d3 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8014b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014b5:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8014bb:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8014bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014c0:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8014c7:	83 ec 0c             	sub    $0xc,%esp
  8014ca:	50                   	push   %eax
  8014cb:	e8 a6 ee ff ff       	call   800376 <fd2num>
  8014d0:	83 c4 10             	add    $0x10,%esp
}
  8014d3:	c9                   	leave  
  8014d4:	c3                   	ret    

008014d5 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8014d5:	55                   	push   %ebp
  8014d6:	89 e5                	mov    %esp,%ebp
  8014d8:	56                   	push   %esi
  8014d9:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8014da:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8014dd:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8014e3:	e8 40 ec ff ff       	call   800128 <sys_getenvid>
  8014e8:	83 ec 0c             	sub    $0xc,%esp
  8014eb:	ff 75 0c             	pushl  0xc(%ebp)
  8014ee:	ff 75 08             	pushl  0x8(%ebp)
  8014f1:	56                   	push   %esi
  8014f2:	50                   	push   %eax
  8014f3:	68 8c 24 80 00       	push   $0x80248c
  8014f8:	e8 b3 00 00 00       	call   8015b0 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8014fd:	83 c4 18             	add    $0x18,%esp
  801500:	53                   	push   %ebx
  801501:	ff 75 10             	pushl  0x10(%ebp)
  801504:	e8 56 00 00 00       	call   80155f <vcprintf>
	cprintf("\n");
  801509:	c7 04 24 40 24 80 00 	movl   $0x802440,(%esp)
  801510:	e8 9b 00 00 00       	call   8015b0 <cprintf>
  801515:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801518:	cc                   	int3   
  801519:	eb fd                	jmp    801518 <_panic+0x43>

0080151b <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80151b:	55                   	push   %ebp
  80151c:	89 e5                	mov    %esp,%ebp
  80151e:	53                   	push   %ebx
  80151f:	83 ec 04             	sub    $0x4,%esp
  801522:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801525:	8b 13                	mov    (%ebx),%edx
  801527:	8d 42 01             	lea    0x1(%edx),%eax
  80152a:	89 03                	mov    %eax,(%ebx)
  80152c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80152f:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801533:	3d ff 00 00 00       	cmp    $0xff,%eax
  801538:	74 09                	je     801543 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80153a:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80153e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801541:	c9                   	leave  
  801542:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  801543:	83 ec 08             	sub    $0x8,%esp
  801546:	68 ff 00 00 00       	push   $0xff
  80154b:	8d 43 08             	lea    0x8(%ebx),%eax
  80154e:	50                   	push   %eax
  80154f:	e8 56 eb ff ff       	call   8000aa <sys_cputs>
		b->idx = 0;
  801554:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80155a:	83 c4 10             	add    $0x10,%esp
  80155d:	eb db                	jmp    80153a <putch+0x1f>

0080155f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80155f:	55                   	push   %ebp
  801560:	89 e5                	mov    %esp,%ebp
  801562:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801568:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80156f:	00 00 00 
	b.cnt = 0;
  801572:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801579:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80157c:	ff 75 0c             	pushl  0xc(%ebp)
  80157f:	ff 75 08             	pushl  0x8(%ebp)
  801582:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801588:	50                   	push   %eax
  801589:	68 1b 15 80 00       	push   $0x80151b
  80158e:	e8 1a 01 00 00       	call   8016ad <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801593:	83 c4 08             	add    $0x8,%esp
  801596:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80159c:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8015a2:	50                   	push   %eax
  8015a3:	e8 02 eb ff ff       	call   8000aa <sys_cputs>

	return b.cnt;
}
  8015a8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8015ae:	c9                   	leave  
  8015af:	c3                   	ret    

008015b0 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8015b0:	55                   	push   %ebp
  8015b1:	89 e5                	mov    %esp,%ebp
  8015b3:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8015b6:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8015b9:	50                   	push   %eax
  8015ba:	ff 75 08             	pushl  0x8(%ebp)
  8015bd:	e8 9d ff ff ff       	call   80155f <vcprintf>
	va_end(ap);

	return cnt;
}
  8015c2:	c9                   	leave  
  8015c3:	c3                   	ret    

008015c4 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8015c4:	55                   	push   %ebp
  8015c5:	89 e5                	mov    %esp,%ebp
  8015c7:	57                   	push   %edi
  8015c8:	56                   	push   %esi
  8015c9:	53                   	push   %ebx
  8015ca:	83 ec 1c             	sub    $0x1c,%esp
  8015cd:	89 c7                	mov    %eax,%edi
  8015cf:	89 d6                	mov    %edx,%esi
  8015d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015d7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8015da:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8015dd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015e0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015e5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8015e8:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8015eb:	39 d3                	cmp    %edx,%ebx
  8015ed:	72 05                	jb     8015f4 <printnum+0x30>
  8015ef:	39 45 10             	cmp    %eax,0x10(%ebp)
  8015f2:	77 7a                	ja     80166e <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8015f4:	83 ec 0c             	sub    $0xc,%esp
  8015f7:	ff 75 18             	pushl  0x18(%ebp)
  8015fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8015fd:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801600:	53                   	push   %ebx
  801601:	ff 75 10             	pushl  0x10(%ebp)
  801604:	83 ec 08             	sub    $0x8,%esp
  801607:	ff 75 e4             	pushl  -0x1c(%ebp)
  80160a:	ff 75 e0             	pushl  -0x20(%ebp)
  80160d:	ff 75 dc             	pushl  -0x24(%ebp)
  801610:	ff 75 d8             	pushl  -0x28(%ebp)
  801613:	e8 a8 0a 00 00       	call   8020c0 <__udivdi3>
  801618:	83 c4 18             	add    $0x18,%esp
  80161b:	52                   	push   %edx
  80161c:	50                   	push   %eax
  80161d:	89 f2                	mov    %esi,%edx
  80161f:	89 f8                	mov    %edi,%eax
  801621:	e8 9e ff ff ff       	call   8015c4 <printnum>
  801626:	83 c4 20             	add    $0x20,%esp
  801629:	eb 13                	jmp    80163e <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80162b:	83 ec 08             	sub    $0x8,%esp
  80162e:	56                   	push   %esi
  80162f:	ff 75 18             	pushl  0x18(%ebp)
  801632:	ff d7                	call   *%edi
  801634:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  801637:	83 eb 01             	sub    $0x1,%ebx
  80163a:	85 db                	test   %ebx,%ebx
  80163c:	7f ed                	jg     80162b <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80163e:	83 ec 08             	sub    $0x8,%esp
  801641:	56                   	push   %esi
  801642:	83 ec 04             	sub    $0x4,%esp
  801645:	ff 75 e4             	pushl  -0x1c(%ebp)
  801648:	ff 75 e0             	pushl  -0x20(%ebp)
  80164b:	ff 75 dc             	pushl  -0x24(%ebp)
  80164e:	ff 75 d8             	pushl  -0x28(%ebp)
  801651:	e8 8a 0b 00 00       	call   8021e0 <__umoddi3>
  801656:	83 c4 14             	add    $0x14,%esp
  801659:	0f be 80 af 24 80 00 	movsbl 0x8024af(%eax),%eax
  801660:	50                   	push   %eax
  801661:	ff d7                	call   *%edi
}
  801663:	83 c4 10             	add    $0x10,%esp
  801666:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801669:	5b                   	pop    %ebx
  80166a:	5e                   	pop    %esi
  80166b:	5f                   	pop    %edi
  80166c:	5d                   	pop    %ebp
  80166d:	c3                   	ret    
  80166e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801671:	eb c4                	jmp    801637 <printnum+0x73>

00801673 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801673:	55                   	push   %ebp
  801674:	89 e5                	mov    %esp,%ebp
  801676:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801679:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80167d:	8b 10                	mov    (%eax),%edx
  80167f:	3b 50 04             	cmp    0x4(%eax),%edx
  801682:	73 0a                	jae    80168e <sprintputch+0x1b>
		*b->buf++ = ch;
  801684:	8d 4a 01             	lea    0x1(%edx),%ecx
  801687:	89 08                	mov    %ecx,(%eax)
  801689:	8b 45 08             	mov    0x8(%ebp),%eax
  80168c:	88 02                	mov    %al,(%edx)
}
  80168e:	5d                   	pop    %ebp
  80168f:	c3                   	ret    

00801690 <printfmt>:
{
  801690:	55                   	push   %ebp
  801691:	89 e5                	mov    %esp,%ebp
  801693:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  801696:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  801699:	50                   	push   %eax
  80169a:	ff 75 10             	pushl  0x10(%ebp)
  80169d:	ff 75 0c             	pushl  0xc(%ebp)
  8016a0:	ff 75 08             	pushl  0x8(%ebp)
  8016a3:	e8 05 00 00 00       	call   8016ad <vprintfmt>
}
  8016a8:	83 c4 10             	add    $0x10,%esp
  8016ab:	c9                   	leave  
  8016ac:	c3                   	ret    

008016ad <vprintfmt>:
{
  8016ad:	55                   	push   %ebp
  8016ae:	89 e5                	mov    %esp,%ebp
  8016b0:	57                   	push   %edi
  8016b1:	56                   	push   %esi
  8016b2:	53                   	push   %ebx
  8016b3:	83 ec 2c             	sub    $0x2c,%esp
  8016b6:	8b 75 08             	mov    0x8(%ebp),%esi
  8016b9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8016bc:	8b 7d 10             	mov    0x10(%ebp),%edi
  8016bf:	e9 21 04 00 00       	jmp    801ae5 <vprintfmt+0x438>
		padc = ' ';
  8016c4:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8016c8:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8016cf:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  8016d6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8016dd:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8016e2:	8d 47 01             	lea    0x1(%edi),%eax
  8016e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8016e8:	0f b6 17             	movzbl (%edi),%edx
  8016eb:	8d 42 dd             	lea    -0x23(%edx),%eax
  8016ee:	3c 55                	cmp    $0x55,%al
  8016f0:	0f 87 90 04 00 00    	ja     801b86 <vprintfmt+0x4d9>
  8016f6:	0f b6 c0             	movzbl %al,%eax
  8016f9:	ff 24 85 00 26 80 00 	jmp    *0x802600(,%eax,4)
  801700:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  801703:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  801707:	eb d9                	jmp    8016e2 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  801709:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80170c:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  801710:	eb d0                	jmp    8016e2 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  801712:	0f b6 d2             	movzbl %dl,%edx
  801715:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  801718:	b8 00 00 00 00       	mov    $0x0,%eax
  80171d:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  801720:	8d 04 80             	lea    (%eax,%eax,4),%eax
  801723:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  801727:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80172a:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80172d:	83 f9 09             	cmp    $0x9,%ecx
  801730:	77 55                	ja     801787 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  801732:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  801735:	eb e9                	jmp    801720 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  801737:	8b 45 14             	mov    0x14(%ebp),%eax
  80173a:	8b 00                	mov    (%eax),%eax
  80173c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80173f:	8b 45 14             	mov    0x14(%ebp),%eax
  801742:	8d 40 04             	lea    0x4(%eax),%eax
  801745:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801748:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80174b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80174f:	79 91                	jns    8016e2 <vprintfmt+0x35>
				width = precision, precision = -1;
  801751:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801754:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801757:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80175e:	eb 82                	jmp    8016e2 <vprintfmt+0x35>
  801760:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801763:	85 c0                	test   %eax,%eax
  801765:	ba 00 00 00 00       	mov    $0x0,%edx
  80176a:	0f 49 d0             	cmovns %eax,%edx
  80176d:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801770:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801773:	e9 6a ff ff ff       	jmp    8016e2 <vprintfmt+0x35>
  801778:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80177b:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  801782:	e9 5b ff ff ff       	jmp    8016e2 <vprintfmt+0x35>
  801787:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80178a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80178d:	eb bc                	jmp    80174b <vprintfmt+0x9e>
			lflag++;
  80178f:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801792:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  801795:	e9 48 ff ff ff       	jmp    8016e2 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  80179a:	8b 45 14             	mov    0x14(%ebp),%eax
  80179d:	8d 78 04             	lea    0x4(%eax),%edi
  8017a0:	83 ec 08             	sub    $0x8,%esp
  8017a3:	53                   	push   %ebx
  8017a4:	ff 30                	pushl  (%eax)
  8017a6:	ff d6                	call   *%esi
			break;
  8017a8:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8017ab:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8017ae:	e9 2f 03 00 00       	jmp    801ae2 <vprintfmt+0x435>
			err = va_arg(ap, int);
  8017b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8017b6:	8d 78 04             	lea    0x4(%eax),%edi
  8017b9:	8b 00                	mov    (%eax),%eax
  8017bb:	99                   	cltd   
  8017bc:	31 d0                	xor    %edx,%eax
  8017be:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8017c0:	83 f8 0f             	cmp    $0xf,%eax
  8017c3:	7f 23                	jg     8017e8 <vprintfmt+0x13b>
  8017c5:	8b 14 85 60 27 80 00 	mov    0x802760(,%eax,4),%edx
  8017cc:	85 d2                	test   %edx,%edx
  8017ce:	74 18                	je     8017e8 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  8017d0:	52                   	push   %edx
  8017d1:	68 07 24 80 00       	push   $0x802407
  8017d6:	53                   	push   %ebx
  8017d7:	56                   	push   %esi
  8017d8:	e8 b3 fe ff ff       	call   801690 <printfmt>
  8017dd:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8017e0:	89 7d 14             	mov    %edi,0x14(%ebp)
  8017e3:	e9 fa 02 00 00       	jmp    801ae2 <vprintfmt+0x435>
				printfmt(putch, putdat, "error %d", err);
  8017e8:	50                   	push   %eax
  8017e9:	68 c7 24 80 00       	push   $0x8024c7
  8017ee:	53                   	push   %ebx
  8017ef:	56                   	push   %esi
  8017f0:	e8 9b fe ff ff       	call   801690 <printfmt>
  8017f5:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8017f8:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8017fb:	e9 e2 02 00 00       	jmp    801ae2 <vprintfmt+0x435>
			if ((p = va_arg(ap, char *)) == NULL)
  801800:	8b 45 14             	mov    0x14(%ebp),%eax
  801803:	83 c0 04             	add    $0x4,%eax
  801806:	89 45 cc             	mov    %eax,-0x34(%ebp)
  801809:	8b 45 14             	mov    0x14(%ebp),%eax
  80180c:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80180e:	85 ff                	test   %edi,%edi
  801810:	b8 c0 24 80 00       	mov    $0x8024c0,%eax
  801815:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  801818:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80181c:	0f 8e bd 00 00 00    	jle    8018df <vprintfmt+0x232>
  801822:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  801826:	75 0e                	jne    801836 <vprintfmt+0x189>
  801828:	89 75 08             	mov    %esi,0x8(%ebp)
  80182b:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80182e:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  801831:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  801834:	eb 6d                	jmp    8018a3 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  801836:	83 ec 08             	sub    $0x8,%esp
  801839:	ff 75 d0             	pushl  -0x30(%ebp)
  80183c:	57                   	push   %edi
  80183d:	e8 ec 03 00 00       	call   801c2e <strnlen>
  801842:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  801845:	29 c1                	sub    %eax,%ecx
  801847:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  80184a:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  80184d:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  801851:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801854:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  801857:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  801859:	eb 0f                	jmp    80186a <vprintfmt+0x1bd>
					putch(padc, putdat);
  80185b:	83 ec 08             	sub    $0x8,%esp
  80185e:	53                   	push   %ebx
  80185f:	ff 75 e0             	pushl  -0x20(%ebp)
  801862:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  801864:	83 ef 01             	sub    $0x1,%edi
  801867:	83 c4 10             	add    $0x10,%esp
  80186a:	85 ff                	test   %edi,%edi
  80186c:	7f ed                	jg     80185b <vprintfmt+0x1ae>
  80186e:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  801871:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  801874:	85 c9                	test   %ecx,%ecx
  801876:	b8 00 00 00 00       	mov    $0x0,%eax
  80187b:	0f 49 c1             	cmovns %ecx,%eax
  80187e:	29 c1                	sub    %eax,%ecx
  801880:	89 75 08             	mov    %esi,0x8(%ebp)
  801883:	8b 75 d0             	mov    -0x30(%ebp),%esi
  801886:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  801889:	89 cb                	mov    %ecx,%ebx
  80188b:	eb 16                	jmp    8018a3 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  80188d:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801891:	75 31                	jne    8018c4 <vprintfmt+0x217>
					putch(ch, putdat);
  801893:	83 ec 08             	sub    $0x8,%esp
  801896:	ff 75 0c             	pushl  0xc(%ebp)
  801899:	50                   	push   %eax
  80189a:	ff 55 08             	call   *0x8(%ebp)
  80189d:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8018a0:	83 eb 01             	sub    $0x1,%ebx
  8018a3:	83 c7 01             	add    $0x1,%edi
  8018a6:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8018aa:	0f be c2             	movsbl %dl,%eax
  8018ad:	85 c0                	test   %eax,%eax
  8018af:	74 59                	je     80190a <vprintfmt+0x25d>
  8018b1:	85 f6                	test   %esi,%esi
  8018b3:	78 d8                	js     80188d <vprintfmt+0x1e0>
  8018b5:	83 ee 01             	sub    $0x1,%esi
  8018b8:	79 d3                	jns    80188d <vprintfmt+0x1e0>
  8018ba:	89 df                	mov    %ebx,%edi
  8018bc:	8b 75 08             	mov    0x8(%ebp),%esi
  8018bf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8018c2:	eb 37                	jmp    8018fb <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  8018c4:	0f be d2             	movsbl %dl,%edx
  8018c7:	83 ea 20             	sub    $0x20,%edx
  8018ca:	83 fa 5e             	cmp    $0x5e,%edx
  8018cd:	76 c4                	jbe    801893 <vprintfmt+0x1e6>
					putch('?', putdat);
  8018cf:	83 ec 08             	sub    $0x8,%esp
  8018d2:	ff 75 0c             	pushl  0xc(%ebp)
  8018d5:	6a 3f                	push   $0x3f
  8018d7:	ff 55 08             	call   *0x8(%ebp)
  8018da:	83 c4 10             	add    $0x10,%esp
  8018dd:	eb c1                	jmp    8018a0 <vprintfmt+0x1f3>
  8018df:	89 75 08             	mov    %esi,0x8(%ebp)
  8018e2:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8018e5:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8018e8:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8018eb:	eb b6                	jmp    8018a3 <vprintfmt+0x1f6>
				putch(' ', putdat);
  8018ed:	83 ec 08             	sub    $0x8,%esp
  8018f0:	53                   	push   %ebx
  8018f1:	6a 20                	push   $0x20
  8018f3:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8018f5:	83 ef 01             	sub    $0x1,%edi
  8018f8:	83 c4 10             	add    $0x10,%esp
  8018fb:	85 ff                	test   %edi,%edi
  8018fd:	7f ee                	jg     8018ed <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  8018ff:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801902:	89 45 14             	mov    %eax,0x14(%ebp)
  801905:	e9 d8 01 00 00       	jmp    801ae2 <vprintfmt+0x435>
  80190a:	89 df                	mov    %ebx,%edi
  80190c:	8b 75 08             	mov    0x8(%ebp),%esi
  80190f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801912:	eb e7                	jmp    8018fb <vprintfmt+0x24e>
	if (lflag >= 2)
  801914:	83 f9 01             	cmp    $0x1,%ecx
  801917:	7e 45                	jle    80195e <vprintfmt+0x2b1>
		return va_arg(*ap, long long);
  801919:	8b 45 14             	mov    0x14(%ebp),%eax
  80191c:	8b 50 04             	mov    0x4(%eax),%edx
  80191f:	8b 00                	mov    (%eax),%eax
  801921:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801924:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801927:	8b 45 14             	mov    0x14(%ebp),%eax
  80192a:	8d 40 08             	lea    0x8(%eax),%eax
  80192d:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  801930:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801934:	79 62                	jns    801998 <vprintfmt+0x2eb>
				putch('-', putdat);
  801936:	83 ec 08             	sub    $0x8,%esp
  801939:	53                   	push   %ebx
  80193a:	6a 2d                	push   $0x2d
  80193c:	ff d6                	call   *%esi
				num = -(long long) num;
  80193e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801941:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801944:	f7 d8                	neg    %eax
  801946:	83 d2 00             	adc    $0x0,%edx
  801949:	f7 da                	neg    %edx
  80194b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80194e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801951:	83 c4 10             	add    $0x10,%esp
			base = 10;
  801954:	ba 0a 00 00 00       	mov    $0xa,%edx
  801959:	e9 66 01 00 00       	jmp    801ac4 <vprintfmt+0x417>
	else if (lflag)
  80195e:	85 c9                	test   %ecx,%ecx
  801960:	75 1b                	jne    80197d <vprintfmt+0x2d0>
		return va_arg(*ap, int);
  801962:	8b 45 14             	mov    0x14(%ebp),%eax
  801965:	8b 00                	mov    (%eax),%eax
  801967:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80196a:	89 c1                	mov    %eax,%ecx
  80196c:	c1 f9 1f             	sar    $0x1f,%ecx
  80196f:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  801972:	8b 45 14             	mov    0x14(%ebp),%eax
  801975:	8d 40 04             	lea    0x4(%eax),%eax
  801978:	89 45 14             	mov    %eax,0x14(%ebp)
  80197b:	eb b3                	jmp    801930 <vprintfmt+0x283>
		return va_arg(*ap, long);
  80197d:	8b 45 14             	mov    0x14(%ebp),%eax
  801980:	8b 00                	mov    (%eax),%eax
  801982:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801985:	89 c1                	mov    %eax,%ecx
  801987:	c1 f9 1f             	sar    $0x1f,%ecx
  80198a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80198d:	8b 45 14             	mov    0x14(%ebp),%eax
  801990:	8d 40 04             	lea    0x4(%eax),%eax
  801993:	89 45 14             	mov    %eax,0x14(%ebp)
  801996:	eb 98                	jmp    801930 <vprintfmt+0x283>
			base = 10;
  801998:	ba 0a 00 00 00       	mov    $0xa,%edx
  80199d:	e9 22 01 00 00       	jmp    801ac4 <vprintfmt+0x417>
	if (lflag >= 2)
  8019a2:	83 f9 01             	cmp    $0x1,%ecx
  8019a5:	7e 21                	jle    8019c8 <vprintfmt+0x31b>
		return va_arg(*ap, unsigned long long);
  8019a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8019aa:	8b 50 04             	mov    0x4(%eax),%edx
  8019ad:	8b 00                	mov    (%eax),%eax
  8019af:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8019b2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8019b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8019b8:	8d 40 08             	lea    0x8(%eax),%eax
  8019bb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8019be:	ba 0a 00 00 00       	mov    $0xa,%edx
  8019c3:	e9 fc 00 00 00       	jmp    801ac4 <vprintfmt+0x417>
	else if (lflag)
  8019c8:	85 c9                	test   %ecx,%ecx
  8019ca:	75 23                	jne    8019ef <vprintfmt+0x342>
		return va_arg(*ap, unsigned int);
  8019cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8019cf:	8b 00                	mov    (%eax),%eax
  8019d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8019d6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8019d9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8019dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8019df:	8d 40 04             	lea    0x4(%eax),%eax
  8019e2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8019e5:	ba 0a 00 00 00       	mov    $0xa,%edx
  8019ea:	e9 d5 00 00 00       	jmp    801ac4 <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  8019ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8019f2:	8b 00                	mov    (%eax),%eax
  8019f4:	ba 00 00 00 00       	mov    $0x0,%edx
  8019f9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8019fc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8019ff:	8b 45 14             	mov    0x14(%ebp),%eax
  801a02:	8d 40 04             	lea    0x4(%eax),%eax
  801a05:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801a08:	ba 0a 00 00 00       	mov    $0xa,%edx
  801a0d:	e9 b2 00 00 00       	jmp    801ac4 <vprintfmt+0x417>
	if (lflag >= 2)
  801a12:	83 f9 01             	cmp    $0x1,%ecx
  801a15:	7e 42                	jle    801a59 <vprintfmt+0x3ac>
		return va_arg(*ap, unsigned long long);
  801a17:	8b 45 14             	mov    0x14(%ebp),%eax
  801a1a:	8b 50 04             	mov    0x4(%eax),%edx
  801a1d:	8b 00                	mov    (%eax),%eax
  801a1f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801a22:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801a25:	8b 45 14             	mov    0x14(%ebp),%eax
  801a28:	8d 40 08             	lea    0x8(%eax),%eax
  801a2b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801a2e:	ba 08 00 00 00       	mov    $0x8,%edx
			if ((long long) num < 0) {
  801a33:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801a37:	0f 89 87 00 00 00    	jns    801ac4 <vprintfmt+0x417>
				putch('-', putdat);
  801a3d:	83 ec 08             	sub    $0x8,%esp
  801a40:	53                   	push   %ebx
  801a41:	6a 2d                	push   $0x2d
  801a43:	ff d6                	call   *%esi
				num = -(long long) num;
  801a45:	f7 5d d8             	negl   -0x28(%ebp)
  801a48:	83 55 dc 00          	adcl   $0x0,-0x24(%ebp)
  801a4c:	f7 5d dc             	negl   -0x24(%ebp)
  801a4f:	83 c4 10             	add    $0x10,%esp
			base = 8;
  801a52:	ba 08 00 00 00       	mov    $0x8,%edx
  801a57:	eb 6b                	jmp    801ac4 <vprintfmt+0x417>
	else if (lflag)
  801a59:	85 c9                	test   %ecx,%ecx
  801a5b:	75 1b                	jne    801a78 <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  801a5d:	8b 45 14             	mov    0x14(%ebp),%eax
  801a60:	8b 00                	mov    (%eax),%eax
  801a62:	ba 00 00 00 00       	mov    $0x0,%edx
  801a67:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801a6a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801a6d:	8b 45 14             	mov    0x14(%ebp),%eax
  801a70:	8d 40 04             	lea    0x4(%eax),%eax
  801a73:	89 45 14             	mov    %eax,0x14(%ebp)
  801a76:	eb b6                	jmp    801a2e <vprintfmt+0x381>
		return va_arg(*ap, unsigned long);
  801a78:	8b 45 14             	mov    0x14(%ebp),%eax
  801a7b:	8b 00                	mov    (%eax),%eax
  801a7d:	ba 00 00 00 00       	mov    $0x0,%edx
  801a82:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801a85:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801a88:	8b 45 14             	mov    0x14(%ebp),%eax
  801a8b:	8d 40 04             	lea    0x4(%eax),%eax
  801a8e:	89 45 14             	mov    %eax,0x14(%ebp)
  801a91:	eb 9b                	jmp    801a2e <vprintfmt+0x381>
			putch('0', putdat);
  801a93:	83 ec 08             	sub    $0x8,%esp
  801a96:	53                   	push   %ebx
  801a97:	6a 30                	push   $0x30
  801a99:	ff d6                	call   *%esi
			putch('x', putdat);
  801a9b:	83 c4 08             	add    $0x8,%esp
  801a9e:	53                   	push   %ebx
  801a9f:	6a 78                	push   $0x78
  801aa1:	ff d6                	call   *%esi
			num = (unsigned long long)
  801aa3:	8b 45 14             	mov    0x14(%ebp),%eax
  801aa6:	8b 00                	mov    (%eax),%eax
  801aa8:	ba 00 00 00 00       	mov    $0x0,%edx
  801aad:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801ab0:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  801ab3:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  801ab6:	8b 45 14             	mov    0x14(%ebp),%eax
  801ab9:	8d 40 04             	lea    0x4(%eax),%eax
  801abc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801abf:	ba 10 00 00 00       	mov    $0x10,%edx
			printnum(putch, putdat, num, base, width, padc);
  801ac4:	83 ec 0c             	sub    $0xc,%esp
  801ac7:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  801acb:	50                   	push   %eax
  801acc:	ff 75 e0             	pushl  -0x20(%ebp)
  801acf:	52                   	push   %edx
  801ad0:	ff 75 dc             	pushl  -0x24(%ebp)
  801ad3:	ff 75 d8             	pushl  -0x28(%ebp)
  801ad6:	89 da                	mov    %ebx,%edx
  801ad8:	89 f0                	mov    %esi,%eax
  801ada:	e8 e5 fa ff ff       	call   8015c4 <printnum>
			break;
  801adf:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  801ae2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801ae5:	83 c7 01             	add    $0x1,%edi
  801ae8:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801aec:	83 f8 25             	cmp    $0x25,%eax
  801aef:	0f 84 cf fb ff ff    	je     8016c4 <vprintfmt+0x17>
			if (ch == '\0')
  801af5:	85 c0                	test   %eax,%eax
  801af7:	0f 84 a9 00 00 00    	je     801ba6 <vprintfmt+0x4f9>
			putch(ch, putdat);
  801afd:	83 ec 08             	sub    $0x8,%esp
  801b00:	53                   	push   %ebx
  801b01:	50                   	push   %eax
  801b02:	ff d6                	call   *%esi
  801b04:	83 c4 10             	add    $0x10,%esp
  801b07:	eb dc                	jmp    801ae5 <vprintfmt+0x438>
	if (lflag >= 2)
  801b09:	83 f9 01             	cmp    $0x1,%ecx
  801b0c:	7e 1e                	jle    801b2c <vprintfmt+0x47f>
		return va_arg(*ap, unsigned long long);
  801b0e:	8b 45 14             	mov    0x14(%ebp),%eax
  801b11:	8b 50 04             	mov    0x4(%eax),%edx
  801b14:	8b 00                	mov    (%eax),%eax
  801b16:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801b19:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801b1c:	8b 45 14             	mov    0x14(%ebp),%eax
  801b1f:	8d 40 08             	lea    0x8(%eax),%eax
  801b22:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801b25:	ba 10 00 00 00       	mov    $0x10,%edx
  801b2a:	eb 98                	jmp    801ac4 <vprintfmt+0x417>
	else if (lflag)
  801b2c:	85 c9                	test   %ecx,%ecx
  801b2e:	75 23                	jne    801b53 <vprintfmt+0x4a6>
		return va_arg(*ap, unsigned int);
  801b30:	8b 45 14             	mov    0x14(%ebp),%eax
  801b33:	8b 00                	mov    (%eax),%eax
  801b35:	ba 00 00 00 00       	mov    $0x0,%edx
  801b3a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801b3d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801b40:	8b 45 14             	mov    0x14(%ebp),%eax
  801b43:	8d 40 04             	lea    0x4(%eax),%eax
  801b46:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801b49:	ba 10 00 00 00       	mov    $0x10,%edx
  801b4e:	e9 71 ff ff ff       	jmp    801ac4 <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  801b53:	8b 45 14             	mov    0x14(%ebp),%eax
  801b56:	8b 00                	mov    (%eax),%eax
  801b58:	ba 00 00 00 00       	mov    $0x0,%edx
  801b5d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801b60:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801b63:	8b 45 14             	mov    0x14(%ebp),%eax
  801b66:	8d 40 04             	lea    0x4(%eax),%eax
  801b69:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801b6c:	ba 10 00 00 00       	mov    $0x10,%edx
  801b71:	e9 4e ff ff ff       	jmp    801ac4 <vprintfmt+0x417>
			putch(ch, putdat);
  801b76:	83 ec 08             	sub    $0x8,%esp
  801b79:	53                   	push   %ebx
  801b7a:	6a 25                	push   $0x25
  801b7c:	ff d6                	call   *%esi
			break;
  801b7e:	83 c4 10             	add    $0x10,%esp
  801b81:	e9 5c ff ff ff       	jmp    801ae2 <vprintfmt+0x435>
			putch('%', putdat);
  801b86:	83 ec 08             	sub    $0x8,%esp
  801b89:	53                   	push   %ebx
  801b8a:	6a 25                	push   $0x25
  801b8c:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  801b8e:	83 c4 10             	add    $0x10,%esp
  801b91:	89 f8                	mov    %edi,%eax
  801b93:	eb 03                	jmp    801b98 <vprintfmt+0x4eb>
  801b95:	83 e8 01             	sub    $0x1,%eax
  801b98:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  801b9c:	75 f7                	jne    801b95 <vprintfmt+0x4e8>
  801b9e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801ba1:	e9 3c ff ff ff       	jmp    801ae2 <vprintfmt+0x435>
}
  801ba6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ba9:	5b                   	pop    %ebx
  801baa:	5e                   	pop    %esi
  801bab:	5f                   	pop    %edi
  801bac:	5d                   	pop    %ebp
  801bad:	c3                   	ret    

00801bae <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801bae:	55                   	push   %ebp
  801baf:	89 e5                	mov    %esp,%ebp
  801bb1:	83 ec 18             	sub    $0x18,%esp
  801bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb7:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801bba:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801bbd:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801bc1:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801bc4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801bcb:	85 c0                	test   %eax,%eax
  801bcd:	74 26                	je     801bf5 <vsnprintf+0x47>
  801bcf:	85 d2                	test   %edx,%edx
  801bd1:	7e 22                	jle    801bf5 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801bd3:	ff 75 14             	pushl  0x14(%ebp)
  801bd6:	ff 75 10             	pushl  0x10(%ebp)
  801bd9:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801bdc:	50                   	push   %eax
  801bdd:	68 73 16 80 00       	push   $0x801673
  801be2:	e8 c6 fa ff ff       	call   8016ad <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801be7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bea:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801bed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bf0:	83 c4 10             	add    $0x10,%esp
}
  801bf3:	c9                   	leave  
  801bf4:	c3                   	ret    
		return -E_INVAL;
  801bf5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801bfa:	eb f7                	jmp    801bf3 <vsnprintf+0x45>

00801bfc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801bfc:	55                   	push   %ebp
  801bfd:	89 e5                	mov    %esp,%ebp
  801bff:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801c02:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801c05:	50                   	push   %eax
  801c06:	ff 75 10             	pushl  0x10(%ebp)
  801c09:	ff 75 0c             	pushl  0xc(%ebp)
  801c0c:	ff 75 08             	pushl  0x8(%ebp)
  801c0f:	e8 9a ff ff ff       	call   801bae <vsnprintf>
	va_end(ap);

	return rc;
}
  801c14:	c9                   	leave  
  801c15:	c3                   	ret    

00801c16 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801c16:	55                   	push   %ebp
  801c17:	89 e5                	mov    %esp,%ebp
  801c19:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801c1c:	b8 00 00 00 00       	mov    $0x0,%eax
  801c21:	eb 03                	jmp    801c26 <strlen+0x10>
		n++;
  801c23:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  801c26:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801c2a:	75 f7                	jne    801c23 <strlen+0xd>
	return n;
}
  801c2c:	5d                   	pop    %ebp
  801c2d:	c3                   	ret    

00801c2e <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801c2e:	55                   	push   %ebp
  801c2f:	89 e5                	mov    %esp,%ebp
  801c31:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c34:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801c37:	b8 00 00 00 00       	mov    $0x0,%eax
  801c3c:	eb 03                	jmp    801c41 <strnlen+0x13>
		n++;
  801c3e:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801c41:	39 d0                	cmp    %edx,%eax
  801c43:	74 06                	je     801c4b <strnlen+0x1d>
  801c45:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  801c49:	75 f3                	jne    801c3e <strnlen+0x10>
	return n;
}
  801c4b:	5d                   	pop    %ebp
  801c4c:	c3                   	ret    

00801c4d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801c4d:	55                   	push   %ebp
  801c4e:	89 e5                	mov    %esp,%ebp
  801c50:	53                   	push   %ebx
  801c51:	8b 45 08             	mov    0x8(%ebp),%eax
  801c54:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801c57:	89 c2                	mov    %eax,%edx
  801c59:	83 c1 01             	add    $0x1,%ecx
  801c5c:	83 c2 01             	add    $0x1,%edx
  801c5f:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  801c63:	88 5a ff             	mov    %bl,-0x1(%edx)
  801c66:	84 db                	test   %bl,%bl
  801c68:	75 ef                	jne    801c59 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  801c6a:	5b                   	pop    %ebx
  801c6b:	5d                   	pop    %ebp
  801c6c:	c3                   	ret    

00801c6d <strcat>:

char *
strcat(char *dst, const char *src)
{
  801c6d:	55                   	push   %ebp
  801c6e:	89 e5                	mov    %esp,%ebp
  801c70:	53                   	push   %ebx
  801c71:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801c74:	53                   	push   %ebx
  801c75:	e8 9c ff ff ff       	call   801c16 <strlen>
  801c7a:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  801c7d:	ff 75 0c             	pushl  0xc(%ebp)
  801c80:	01 d8                	add    %ebx,%eax
  801c82:	50                   	push   %eax
  801c83:	e8 c5 ff ff ff       	call   801c4d <strcpy>
	return dst;
}
  801c88:	89 d8                	mov    %ebx,%eax
  801c8a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c8d:	c9                   	leave  
  801c8e:	c3                   	ret    

00801c8f <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801c8f:	55                   	push   %ebp
  801c90:	89 e5                	mov    %esp,%ebp
  801c92:	56                   	push   %esi
  801c93:	53                   	push   %ebx
  801c94:	8b 75 08             	mov    0x8(%ebp),%esi
  801c97:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c9a:	89 f3                	mov    %esi,%ebx
  801c9c:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801c9f:	89 f2                	mov    %esi,%edx
  801ca1:	eb 0f                	jmp    801cb2 <strncpy+0x23>
		*dst++ = *src;
  801ca3:	83 c2 01             	add    $0x1,%edx
  801ca6:	0f b6 01             	movzbl (%ecx),%eax
  801ca9:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801cac:	80 39 01             	cmpb   $0x1,(%ecx)
  801caf:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  801cb2:	39 da                	cmp    %ebx,%edx
  801cb4:	75 ed                	jne    801ca3 <strncpy+0x14>
	}
	return ret;
}
  801cb6:	89 f0                	mov    %esi,%eax
  801cb8:	5b                   	pop    %ebx
  801cb9:	5e                   	pop    %esi
  801cba:	5d                   	pop    %ebp
  801cbb:	c3                   	ret    

00801cbc <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801cbc:	55                   	push   %ebp
  801cbd:	89 e5                	mov    %esp,%ebp
  801cbf:	56                   	push   %esi
  801cc0:	53                   	push   %ebx
  801cc1:	8b 75 08             	mov    0x8(%ebp),%esi
  801cc4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cc7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cca:	89 f0                	mov    %esi,%eax
  801ccc:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801cd0:	85 c9                	test   %ecx,%ecx
  801cd2:	75 0b                	jne    801cdf <strlcpy+0x23>
  801cd4:	eb 17                	jmp    801ced <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  801cd6:	83 c2 01             	add    $0x1,%edx
  801cd9:	83 c0 01             	add    $0x1,%eax
  801cdc:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  801cdf:	39 d8                	cmp    %ebx,%eax
  801ce1:	74 07                	je     801cea <strlcpy+0x2e>
  801ce3:	0f b6 0a             	movzbl (%edx),%ecx
  801ce6:	84 c9                	test   %cl,%cl
  801ce8:	75 ec                	jne    801cd6 <strlcpy+0x1a>
		*dst = '\0';
  801cea:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801ced:	29 f0                	sub    %esi,%eax
}
  801cef:	5b                   	pop    %ebx
  801cf0:	5e                   	pop    %esi
  801cf1:	5d                   	pop    %ebp
  801cf2:	c3                   	ret    

00801cf3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801cf3:	55                   	push   %ebp
  801cf4:	89 e5                	mov    %esp,%ebp
  801cf6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cf9:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801cfc:	eb 06                	jmp    801d04 <strcmp+0x11>
		p++, q++;
  801cfe:	83 c1 01             	add    $0x1,%ecx
  801d01:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  801d04:	0f b6 01             	movzbl (%ecx),%eax
  801d07:	84 c0                	test   %al,%al
  801d09:	74 04                	je     801d0f <strcmp+0x1c>
  801d0b:	3a 02                	cmp    (%edx),%al
  801d0d:	74 ef                	je     801cfe <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801d0f:	0f b6 c0             	movzbl %al,%eax
  801d12:	0f b6 12             	movzbl (%edx),%edx
  801d15:	29 d0                	sub    %edx,%eax
}
  801d17:	5d                   	pop    %ebp
  801d18:	c3                   	ret    

00801d19 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801d19:	55                   	push   %ebp
  801d1a:	89 e5                	mov    %esp,%ebp
  801d1c:	53                   	push   %ebx
  801d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d20:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d23:	89 c3                	mov    %eax,%ebx
  801d25:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  801d28:	eb 06                	jmp    801d30 <strncmp+0x17>
		n--, p++, q++;
  801d2a:	83 c0 01             	add    $0x1,%eax
  801d2d:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  801d30:	39 d8                	cmp    %ebx,%eax
  801d32:	74 16                	je     801d4a <strncmp+0x31>
  801d34:	0f b6 08             	movzbl (%eax),%ecx
  801d37:	84 c9                	test   %cl,%cl
  801d39:	74 04                	je     801d3f <strncmp+0x26>
  801d3b:	3a 0a                	cmp    (%edx),%cl
  801d3d:	74 eb                	je     801d2a <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801d3f:	0f b6 00             	movzbl (%eax),%eax
  801d42:	0f b6 12             	movzbl (%edx),%edx
  801d45:	29 d0                	sub    %edx,%eax
}
  801d47:	5b                   	pop    %ebx
  801d48:	5d                   	pop    %ebp
  801d49:	c3                   	ret    
		return 0;
  801d4a:	b8 00 00 00 00       	mov    $0x0,%eax
  801d4f:	eb f6                	jmp    801d47 <strncmp+0x2e>

00801d51 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801d51:	55                   	push   %ebp
  801d52:	89 e5                	mov    %esp,%ebp
  801d54:	8b 45 08             	mov    0x8(%ebp),%eax
  801d57:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801d5b:	0f b6 10             	movzbl (%eax),%edx
  801d5e:	84 d2                	test   %dl,%dl
  801d60:	74 09                	je     801d6b <strchr+0x1a>
		if (*s == c)
  801d62:	38 ca                	cmp    %cl,%dl
  801d64:	74 0a                	je     801d70 <strchr+0x1f>
	for (; *s; s++)
  801d66:	83 c0 01             	add    $0x1,%eax
  801d69:	eb f0                	jmp    801d5b <strchr+0xa>
			return (char *) s;
	return 0;
  801d6b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d70:	5d                   	pop    %ebp
  801d71:	c3                   	ret    

00801d72 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801d72:	55                   	push   %ebp
  801d73:	89 e5                	mov    %esp,%ebp
  801d75:	8b 45 08             	mov    0x8(%ebp),%eax
  801d78:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801d7c:	eb 03                	jmp    801d81 <strfind+0xf>
  801d7e:	83 c0 01             	add    $0x1,%eax
  801d81:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  801d84:	38 ca                	cmp    %cl,%dl
  801d86:	74 04                	je     801d8c <strfind+0x1a>
  801d88:	84 d2                	test   %dl,%dl
  801d8a:	75 f2                	jne    801d7e <strfind+0xc>
			break;
	return (char *) s;
}
  801d8c:	5d                   	pop    %ebp
  801d8d:	c3                   	ret    

00801d8e <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801d8e:	55                   	push   %ebp
  801d8f:	89 e5                	mov    %esp,%ebp
  801d91:	57                   	push   %edi
  801d92:	56                   	push   %esi
  801d93:	53                   	push   %ebx
  801d94:	8b 7d 08             	mov    0x8(%ebp),%edi
  801d97:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801d9a:	85 c9                	test   %ecx,%ecx
  801d9c:	74 13                	je     801db1 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801d9e:	f7 c7 03 00 00 00    	test   $0x3,%edi
  801da4:	75 05                	jne    801dab <memset+0x1d>
  801da6:	f6 c1 03             	test   $0x3,%cl
  801da9:	74 0d                	je     801db8 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801dab:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dae:	fc                   	cld    
  801daf:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801db1:	89 f8                	mov    %edi,%eax
  801db3:	5b                   	pop    %ebx
  801db4:	5e                   	pop    %esi
  801db5:	5f                   	pop    %edi
  801db6:	5d                   	pop    %ebp
  801db7:	c3                   	ret    
		c &= 0xFF;
  801db8:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801dbc:	89 d3                	mov    %edx,%ebx
  801dbe:	c1 e3 08             	shl    $0x8,%ebx
  801dc1:	89 d0                	mov    %edx,%eax
  801dc3:	c1 e0 18             	shl    $0x18,%eax
  801dc6:	89 d6                	mov    %edx,%esi
  801dc8:	c1 e6 10             	shl    $0x10,%esi
  801dcb:	09 f0                	or     %esi,%eax
  801dcd:	09 c2                	or     %eax,%edx
  801dcf:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  801dd1:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  801dd4:	89 d0                	mov    %edx,%eax
  801dd6:	fc                   	cld    
  801dd7:	f3 ab                	rep stos %eax,%es:(%edi)
  801dd9:	eb d6                	jmp    801db1 <memset+0x23>

00801ddb <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801ddb:	55                   	push   %ebp
  801ddc:	89 e5                	mov    %esp,%ebp
  801dde:	57                   	push   %edi
  801ddf:	56                   	push   %esi
  801de0:	8b 45 08             	mov    0x8(%ebp),%eax
  801de3:	8b 75 0c             	mov    0xc(%ebp),%esi
  801de6:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801de9:	39 c6                	cmp    %eax,%esi
  801deb:	73 35                	jae    801e22 <memmove+0x47>
  801ded:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801df0:	39 c2                	cmp    %eax,%edx
  801df2:	76 2e                	jbe    801e22 <memmove+0x47>
		s += n;
		d += n;
  801df4:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801df7:	89 d6                	mov    %edx,%esi
  801df9:	09 fe                	or     %edi,%esi
  801dfb:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801e01:	74 0c                	je     801e0f <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801e03:	83 ef 01             	sub    $0x1,%edi
  801e06:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  801e09:	fd                   	std    
  801e0a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801e0c:	fc                   	cld    
  801e0d:	eb 21                	jmp    801e30 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801e0f:	f6 c1 03             	test   $0x3,%cl
  801e12:	75 ef                	jne    801e03 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801e14:	83 ef 04             	sub    $0x4,%edi
  801e17:	8d 72 fc             	lea    -0x4(%edx),%esi
  801e1a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  801e1d:	fd                   	std    
  801e1e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801e20:	eb ea                	jmp    801e0c <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801e22:	89 f2                	mov    %esi,%edx
  801e24:	09 c2                	or     %eax,%edx
  801e26:	f6 c2 03             	test   $0x3,%dl
  801e29:	74 09                	je     801e34 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801e2b:	89 c7                	mov    %eax,%edi
  801e2d:	fc                   	cld    
  801e2e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801e30:	5e                   	pop    %esi
  801e31:	5f                   	pop    %edi
  801e32:	5d                   	pop    %ebp
  801e33:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801e34:	f6 c1 03             	test   $0x3,%cl
  801e37:	75 f2                	jne    801e2b <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801e39:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  801e3c:	89 c7                	mov    %eax,%edi
  801e3e:	fc                   	cld    
  801e3f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801e41:	eb ed                	jmp    801e30 <memmove+0x55>

00801e43 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801e43:	55                   	push   %ebp
  801e44:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  801e46:	ff 75 10             	pushl  0x10(%ebp)
  801e49:	ff 75 0c             	pushl  0xc(%ebp)
  801e4c:	ff 75 08             	pushl  0x8(%ebp)
  801e4f:	e8 87 ff ff ff       	call   801ddb <memmove>
}
  801e54:	c9                   	leave  
  801e55:	c3                   	ret    

00801e56 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801e56:	55                   	push   %ebp
  801e57:	89 e5                	mov    %esp,%ebp
  801e59:	56                   	push   %esi
  801e5a:	53                   	push   %ebx
  801e5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e61:	89 c6                	mov    %eax,%esi
  801e63:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801e66:	39 f0                	cmp    %esi,%eax
  801e68:	74 1c                	je     801e86 <memcmp+0x30>
		if (*s1 != *s2)
  801e6a:	0f b6 08             	movzbl (%eax),%ecx
  801e6d:	0f b6 1a             	movzbl (%edx),%ebx
  801e70:	38 d9                	cmp    %bl,%cl
  801e72:	75 08                	jne    801e7c <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801e74:	83 c0 01             	add    $0x1,%eax
  801e77:	83 c2 01             	add    $0x1,%edx
  801e7a:	eb ea                	jmp    801e66 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  801e7c:	0f b6 c1             	movzbl %cl,%eax
  801e7f:	0f b6 db             	movzbl %bl,%ebx
  801e82:	29 d8                	sub    %ebx,%eax
  801e84:	eb 05                	jmp    801e8b <memcmp+0x35>
	}

	return 0;
  801e86:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e8b:	5b                   	pop    %ebx
  801e8c:	5e                   	pop    %esi
  801e8d:	5d                   	pop    %ebp
  801e8e:	c3                   	ret    

00801e8f <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801e8f:	55                   	push   %ebp
  801e90:	89 e5                	mov    %esp,%ebp
  801e92:	8b 45 08             	mov    0x8(%ebp),%eax
  801e95:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801e98:	89 c2                	mov    %eax,%edx
  801e9a:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801e9d:	39 d0                	cmp    %edx,%eax
  801e9f:	73 09                	jae    801eaa <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  801ea1:	38 08                	cmp    %cl,(%eax)
  801ea3:	74 05                	je     801eaa <memfind+0x1b>
	for (; s < ends; s++)
  801ea5:	83 c0 01             	add    $0x1,%eax
  801ea8:	eb f3                	jmp    801e9d <memfind+0xe>
			break;
	return (void *) s;
}
  801eaa:	5d                   	pop    %ebp
  801eab:	c3                   	ret    

00801eac <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801eac:	55                   	push   %ebp
  801ead:	89 e5                	mov    %esp,%ebp
  801eaf:	57                   	push   %edi
  801eb0:	56                   	push   %esi
  801eb1:	53                   	push   %ebx
  801eb2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801eb5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801eb8:	eb 03                	jmp    801ebd <strtol+0x11>
		s++;
  801eba:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  801ebd:	0f b6 01             	movzbl (%ecx),%eax
  801ec0:	3c 20                	cmp    $0x20,%al
  801ec2:	74 f6                	je     801eba <strtol+0xe>
  801ec4:	3c 09                	cmp    $0x9,%al
  801ec6:	74 f2                	je     801eba <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  801ec8:	3c 2b                	cmp    $0x2b,%al
  801eca:	74 2e                	je     801efa <strtol+0x4e>
	int neg = 0;
  801ecc:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801ed1:	3c 2d                	cmp    $0x2d,%al
  801ed3:	74 2f                	je     801f04 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801ed5:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  801edb:	75 05                	jne    801ee2 <strtol+0x36>
  801edd:	80 39 30             	cmpb   $0x30,(%ecx)
  801ee0:	74 2c                	je     801f0e <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  801ee2:	85 db                	test   %ebx,%ebx
  801ee4:	75 0a                	jne    801ef0 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801ee6:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  801eeb:	80 39 30             	cmpb   $0x30,(%ecx)
  801eee:	74 28                	je     801f18 <strtol+0x6c>
		base = 10;
  801ef0:	b8 00 00 00 00       	mov    $0x0,%eax
  801ef5:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801ef8:	eb 50                	jmp    801f4a <strtol+0x9e>
		s++;
  801efa:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  801efd:	bf 00 00 00 00       	mov    $0x0,%edi
  801f02:	eb d1                	jmp    801ed5 <strtol+0x29>
		s++, neg = 1;
  801f04:	83 c1 01             	add    $0x1,%ecx
  801f07:	bf 01 00 00 00       	mov    $0x1,%edi
  801f0c:	eb c7                	jmp    801ed5 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801f0e:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801f12:	74 0e                	je     801f22 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  801f14:	85 db                	test   %ebx,%ebx
  801f16:	75 d8                	jne    801ef0 <strtol+0x44>
		s++, base = 8;
  801f18:	83 c1 01             	add    $0x1,%ecx
  801f1b:	bb 08 00 00 00       	mov    $0x8,%ebx
  801f20:	eb ce                	jmp    801ef0 <strtol+0x44>
		s += 2, base = 16;
  801f22:	83 c1 02             	add    $0x2,%ecx
  801f25:	bb 10 00 00 00       	mov    $0x10,%ebx
  801f2a:	eb c4                	jmp    801ef0 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  801f2c:	8d 72 9f             	lea    -0x61(%edx),%esi
  801f2f:	89 f3                	mov    %esi,%ebx
  801f31:	80 fb 19             	cmp    $0x19,%bl
  801f34:	77 29                	ja     801f5f <strtol+0xb3>
			dig = *s - 'a' + 10;
  801f36:	0f be d2             	movsbl %dl,%edx
  801f39:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801f3c:	3b 55 10             	cmp    0x10(%ebp),%edx
  801f3f:	7d 30                	jge    801f71 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  801f41:	83 c1 01             	add    $0x1,%ecx
  801f44:	0f af 45 10          	imul   0x10(%ebp),%eax
  801f48:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801f4a:	0f b6 11             	movzbl (%ecx),%edx
  801f4d:	8d 72 d0             	lea    -0x30(%edx),%esi
  801f50:	89 f3                	mov    %esi,%ebx
  801f52:	80 fb 09             	cmp    $0x9,%bl
  801f55:	77 d5                	ja     801f2c <strtol+0x80>
			dig = *s - '0';
  801f57:	0f be d2             	movsbl %dl,%edx
  801f5a:	83 ea 30             	sub    $0x30,%edx
  801f5d:	eb dd                	jmp    801f3c <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  801f5f:	8d 72 bf             	lea    -0x41(%edx),%esi
  801f62:	89 f3                	mov    %esi,%ebx
  801f64:	80 fb 19             	cmp    $0x19,%bl
  801f67:	77 08                	ja     801f71 <strtol+0xc5>
			dig = *s - 'A' + 10;
  801f69:	0f be d2             	movsbl %dl,%edx
  801f6c:	83 ea 37             	sub    $0x37,%edx
  801f6f:	eb cb                	jmp    801f3c <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  801f71:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801f75:	74 05                	je     801f7c <strtol+0xd0>
		*endptr = (char *) s;
  801f77:	8b 75 0c             	mov    0xc(%ebp),%esi
  801f7a:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801f7c:	89 c2                	mov    %eax,%edx
  801f7e:	f7 da                	neg    %edx
  801f80:	85 ff                	test   %edi,%edi
  801f82:	0f 45 c2             	cmovne %edx,%eax
}
  801f85:	5b                   	pop    %ebx
  801f86:	5e                   	pop    %esi
  801f87:	5f                   	pop    %edi
  801f88:	5d                   	pop    %ebp
  801f89:	c3                   	ret    

00801f8a <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801f8a:	55                   	push   %ebp
  801f8b:	89 e5                	mov    %esp,%ebp
  801f8d:	56                   	push   %esi
  801f8e:	53                   	push   %ebx
  801f8f:	8b 75 08             	mov    0x8(%ebp),%esi
  801f92:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f95:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
  801f98:	85 c0                	test   %eax,%eax
	    pg = (void *)UTOP;
  801f9a:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801f9f:	0f 44 c2             	cmove  %edx,%eax
	}
	if ((r = sys_ipc_recv(pg)) < 0) {
  801fa2:	83 ec 0c             	sub    $0xc,%esp
  801fa5:	50                   	push   %eax
  801fa6:	e8 6b e3 ff ff       	call   800316 <sys_ipc_recv>
  801fab:	83 c4 10             	add    $0x10,%esp
  801fae:	85 c0                	test   %eax,%eax
  801fb0:	78 2b                	js     801fdd <ipc_recv+0x53>
	    if (perm_store != NULL) {
	        *perm_store = 0;
	    }
	    return r;
	}
	if (from_env_store != NULL) {
  801fb2:	85 f6                	test   %esi,%esi
  801fb4:	74 0a                	je     801fc0 <ipc_recv+0x36>
	    *from_env_store = thisenv->env_ipc_from;
  801fb6:	a1 08 40 80 00       	mov    0x804008,%eax
  801fbb:	8b 40 74             	mov    0x74(%eax),%eax
  801fbe:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store != NULL) {
  801fc0:	85 db                	test   %ebx,%ebx
  801fc2:	74 0a                	je     801fce <ipc_recv+0x44>
	    *perm_store = thisenv->env_ipc_perm;
  801fc4:	a1 08 40 80 00       	mov    0x804008,%eax
  801fc9:	8b 40 78             	mov    0x78(%eax),%eax
  801fcc:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  801fce:	a1 08 40 80 00       	mov    0x804008,%eax
  801fd3:	8b 40 70             	mov    0x70(%eax),%eax
}
  801fd6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fd9:	5b                   	pop    %ebx
  801fda:	5e                   	pop    %esi
  801fdb:	5d                   	pop    %ebp
  801fdc:	c3                   	ret    
	    if (from_env_store != NULL) {
  801fdd:	85 f6                	test   %esi,%esi
  801fdf:	74 06                	je     801fe7 <ipc_recv+0x5d>
	        *from_env_store = 0;
  801fe1:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	    if (perm_store != NULL) {
  801fe7:	85 db                	test   %ebx,%ebx
  801fe9:	74 eb                	je     801fd6 <ipc_recv+0x4c>
	        *perm_store = 0;
  801feb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801ff1:	eb e3                	jmp    801fd6 <ipc_recv+0x4c>

00801ff3 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801ff3:	55                   	push   %ebp
  801ff4:	89 e5                	mov    %esp,%ebp
  801ff6:	57                   	push   %edi
  801ff7:	56                   	push   %esi
  801ff8:	53                   	push   %ebx
  801ff9:	83 ec 0c             	sub    $0xc,%esp
  801ffc:	8b 7d 08             	mov    0x8(%ebp),%edi
  801fff:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
	    pg = (void *)UTOP;
  802002:	85 f6                	test   %esi,%esi
  802004:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802009:	0f 44 f0             	cmove  %eax,%esi
  80200c:	eb 09                	jmp    802017 <ipc_send+0x24>
	do {
	    r = sys_ipc_try_send(to_env, val, pg, perm);
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
	        panic("ipc_send: %e", r);
	    }
	    sys_yield();
  80200e:	e8 34 e1 ff ff       	call   800147 <sys_yield>
	} while(r != 0);
  802013:	85 db                	test   %ebx,%ebx
  802015:	74 2d                	je     802044 <ipc_send+0x51>
	    r = sys_ipc_try_send(to_env, val, pg, perm);
  802017:	ff 75 14             	pushl  0x14(%ebp)
  80201a:	56                   	push   %esi
  80201b:	ff 75 0c             	pushl  0xc(%ebp)
  80201e:	57                   	push   %edi
  80201f:	e8 cf e2 ff ff       	call   8002f3 <sys_ipc_try_send>
  802024:	89 c3                	mov    %eax,%ebx
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
  802026:	83 c4 10             	add    $0x10,%esp
  802029:	85 c0                	test   %eax,%eax
  80202b:	79 e1                	jns    80200e <ipc_send+0x1b>
  80202d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802030:	74 dc                	je     80200e <ipc_send+0x1b>
	        panic("ipc_send: %e", r);
  802032:	50                   	push   %eax
  802033:	68 c0 27 80 00       	push   $0x8027c0
  802038:	6a 45                	push   $0x45
  80203a:	68 cd 27 80 00       	push   $0x8027cd
  80203f:	e8 91 f4 ff ff       	call   8014d5 <_panic>
}
  802044:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802047:	5b                   	pop    %ebx
  802048:	5e                   	pop    %esi
  802049:	5f                   	pop    %edi
  80204a:	5d                   	pop    %ebp
  80204b:	c3                   	ret    

0080204c <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80204c:	55                   	push   %ebp
  80204d:	89 e5                	mov    %esp,%ebp
  80204f:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802052:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802057:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80205a:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802060:	8b 52 50             	mov    0x50(%edx),%edx
  802063:	39 ca                	cmp    %ecx,%edx
  802065:	74 11                	je     802078 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  802067:	83 c0 01             	add    $0x1,%eax
  80206a:	3d 00 04 00 00       	cmp    $0x400,%eax
  80206f:	75 e6                	jne    802057 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802071:	b8 00 00 00 00       	mov    $0x0,%eax
  802076:	eb 0b                	jmp    802083 <ipc_find_env+0x37>
			return envs[i].env_id;
  802078:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80207b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802080:	8b 40 48             	mov    0x48(%eax),%eax
}
  802083:	5d                   	pop    %ebp
  802084:	c3                   	ret    

00802085 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802085:	55                   	push   %ebp
  802086:	89 e5                	mov    %esp,%ebp
  802088:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80208b:	89 d0                	mov    %edx,%eax
  80208d:	c1 e8 16             	shr    $0x16,%eax
  802090:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802097:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80209c:	f6 c1 01             	test   $0x1,%cl
  80209f:	74 1d                	je     8020be <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8020a1:	c1 ea 0c             	shr    $0xc,%edx
  8020a4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8020ab:	f6 c2 01             	test   $0x1,%dl
  8020ae:	74 0e                	je     8020be <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8020b0:	c1 ea 0c             	shr    $0xc,%edx
  8020b3:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8020ba:	ef 
  8020bb:	0f b7 c0             	movzwl %ax,%eax
}
  8020be:	5d                   	pop    %ebp
  8020bf:	c3                   	ret    

008020c0 <__udivdi3>:
  8020c0:	55                   	push   %ebp
  8020c1:	57                   	push   %edi
  8020c2:	56                   	push   %esi
  8020c3:	53                   	push   %ebx
  8020c4:	83 ec 1c             	sub    $0x1c,%esp
  8020c7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8020cb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8020cf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8020d3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8020d7:	85 d2                	test   %edx,%edx
  8020d9:	75 35                	jne    802110 <__udivdi3+0x50>
  8020db:	39 f3                	cmp    %esi,%ebx
  8020dd:	0f 87 bd 00 00 00    	ja     8021a0 <__udivdi3+0xe0>
  8020e3:	85 db                	test   %ebx,%ebx
  8020e5:	89 d9                	mov    %ebx,%ecx
  8020e7:	75 0b                	jne    8020f4 <__udivdi3+0x34>
  8020e9:	b8 01 00 00 00       	mov    $0x1,%eax
  8020ee:	31 d2                	xor    %edx,%edx
  8020f0:	f7 f3                	div    %ebx
  8020f2:	89 c1                	mov    %eax,%ecx
  8020f4:	31 d2                	xor    %edx,%edx
  8020f6:	89 f0                	mov    %esi,%eax
  8020f8:	f7 f1                	div    %ecx
  8020fa:	89 c6                	mov    %eax,%esi
  8020fc:	89 e8                	mov    %ebp,%eax
  8020fe:	89 f7                	mov    %esi,%edi
  802100:	f7 f1                	div    %ecx
  802102:	89 fa                	mov    %edi,%edx
  802104:	83 c4 1c             	add    $0x1c,%esp
  802107:	5b                   	pop    %ebx
  802108:	5e                   	pop    %esi
  802109:	5f                   	pop    %edi
  80210a:	5d                   	pop    %ebp
  80210b:	c3                   	ret    
  80210c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802110:	39 f2                	cmp    %esi,%edx
  802112:	77 7c                	ja     802190 <__udivdi3+0xd0>
  802114:	0f bd fa             	bsr    %edx,%edi
  802117:	83 f7 1f             	xor    $0x1f,%edi
  80211a:	0f 84 98 00 00 00    	je     8021b8 <__udivdi3+0xf8>
  802120:	89 f9                	mov    %edi,%ecx
  802122:	b8 20 00 00 00       	mov    $0x20,%eax
  802127:	29 f8                	sub    %edi,%eax
  802129:	d3 e2                	shl    %cl,%edx
  80212b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80212f:	89 c1                	mov    %eax,%ecx
  802131:	89 da                	mov    %ebx,%edx
  802133:	d3 ea                	shr    %cl,%edx
  802135:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802139:	09 d1                	or     %edx,%ecx
  80213b:	89 f2                	mov    %esi,%edx
  80213d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802141:	89 f9                	mov    %edi,%ecx
  802143:	d3 e3                	shl    %cl,%ebx
  802145:	89 c1                	mov    %eax,%ecx
  802147:	d3 ea                	shr    %cl,%edx
  802149:	89 f9                	mov    %edi,%ecx
  80214b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80214f:	d3 e6                	shl    %cl,%esi
  802151:	89 eb                	mov    %ebp,%ebx
  802153:	89 c1                	mov    %eax,%ecx
  802155:	d3 eb                	shr    %cl,%ebx
  802157:	09 de                	or     %ebx,%esi
  802159:	89 f0                	mov    %esi,%eax
  80215b:	f7 74 24 08          	divl   0x8(%esp)
  80215f:	89 d6                	mov    %edx,%esi
  802161:	89 c3                	mov    %eax,%ebx
  802163:	f7 64 24 0c          	mull   0xc(%esp)
  802167:	39 d6                	cmp    %edx,%esi
  802169:	72 0c                	jb     802177 <__udivdi3+0xb7>
  80216b:	89 f9                	mov    %edi,%ecx
  80216d:	d3 e5                	shl    %cl,%ebp
  80216f:	39 c5                	cmp    %eax,%ebp
  802171:	73 5d                	jae    8021d0 <__udivdi3+0x110>
  802173:	39 d6                	cmp    %edx,%esi
  802175:	75 59                	jne    8021d0 <__udivdi3+0x110>
  802177:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80217a:	31 ff                	xor    %edi,%edi
  80217c:	89 fa                	mov    %edi,%edx
  80217e:	83 c4 1c             	add    $0x1c,%esp
  802181:	5b                   	pop    %ebx
  802182:	5e                   	pop    %esi
  802183:	5f                   	pop    %edi
  802184:	5d                   	pop    %ebp
  802185:	c3                   	ret    
  802186:	8d 76 00             	lea    0x0(%esi),%esi
  802189:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  802190:	31 ff                	xor    %edi,%edi
  802192:	31 c0                	xor    %eax,%eax
  802194:	89 fa                	mov    %edi,%edx
  802196:	83 c4 1c             	add    $0x1c,%esp
  802199:	5b                   	pop    %ebx
  80219a:	5e                   	pop    %esi
  80219b:	5f                   	pop    %edi
  80219c:	5d                   	pop    %ebp
  80219d:	c3                   	ret    
  80219e:	66 90                	xchg   %ax,%ax
  8021a0:	31 ff                	xor    %edi,%edi
  8021a2:	89 e8                	mov    %ebp,%eax
  8021a4:	89 f2                	mov    %esi,%edx
  8021a6:	f7 f3                	div    %ebx
  8021a8:	89 fa                	mov    %edi,%edx
  8021aa:	83 c4 1c             	add    $0x1c,%esp
  8021ad:	5b                   	pop    %ebx
  8021ae:	5e                   	pop    %esi
  8021af:	5f                   	pop    %edi
  8021b0:	5d                   	pop    %ebp
  8021b1:	c3                   	ret    
  8021b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8021b8:	39 f2                	cmp    %esi,%edx
  8021ba:	72 06                	jb     8021c2 <__udivdi3+0x102>
  8021bc:	31 c0                	xor    %eax,%eax
  8021be:	39 eb                	cmp    %ebp,%ebx
  8021c0:	77 d2                	ja     802194 <__udivdi3+0xd4>
  8021c2:	b8 01 00 00 00       	mov    $0x1,%eax
  8021c7:	eb cb                	jmp    802194 <__udivdi3+0xd4>
  8021c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8021d0:	89 d8                	mov    %ebx,%eax
  8021d2:	31 ff                	xor    %edi,%edi
  8021d4:	eb be                	jmp    802194 <__udivdi3+0xd4>
  8021d6:	66 90                	xchg   %ax,%ax
  8021d8:	66 90                	xchg   %ax,%ax
  8021da:	66 90                	xchg   %ax,%ax
  8021dc:	66 90                	xchg   %ax,%ax
  8021de:	66 90                	xchg   %ax,%ax

008021e0 <__umoddi3>:
  8021e0:	55                   	push   %ebp
  8021e1:	57                   	push   %edi
  8021e2:	56                   	push   %esi
  8021e3:	53                   	push   %ebx
  8021e4:	83 ec 1c             	sub    $0x1c,%esp
  8021e7:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  8021eb:	8b 74 24 30          	mov    0x30(%esp),%esi
  8021ef:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8021f3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8021f7:	85 ed                	test   %ebp,%ebp
  8021f9:	89 f0                	mov    %esi,%eax
  8021fb:	89 da                	mov    %ebx,%edx
  8021fd:	75 19                	jne    802218 <__umoddi3+0x38>
  8021ff:	39 df                	cmp    %ebx,%edi
  802201:	0f 86 b1 00 00 00    	jbe    8022b8 <__umoddi3+0xd8>
  802207:	f7 f7                	div    %edi
  802209:	89 d0                	mov    %edx,%eax
  80220b:	31 d2                	xor    %edx,%edx
  80220d:	83 c4 1c             	add    $0x1c,%esp
  802210:	5b                   	pop    %ebx
  802211:	5e                   	pop    %esi
  802212:	5f                   	pop    %edi
  802213:	5d                   	pop    %ebp
  802214:	c3                   	ret    
  802215:	8d 76 00             	lea    0x0(%esi),%esi
  802218:	39 dd                	cmp    %ebx,%ebp
  80221a:	77 f1                	ja     80220d <__umoddi3+0x2d>
  80221c:	0f bd cd             	bsr    %ebp,%ecx
  80221f:	83 f1 1f             	xor    $0x1f,%ecx
  802222:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802226:	0f 84 b4 00 00 00    	je     8022e0 <__umoddi3+0x100>
  80222c:	b8 20 00 00 00       	mov    $0x20,%eax
  802231:	89 c2                	mov    %eax,%edx
  802233:	8b 44 24 04          	mov    0x4(%esp),%eax
  802237:	29 c2                	sub    %eax,%edx
  802239:	89 c1                	mov    %eax,%ecx
  80223b:	89 f8                	mov    %edi,%eax
  80223d:	d3 e5                	shl    %cl,%ebp
  80223f:	89 d1                	mov    %edx,%ecx
  802241:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802245:	d3 e8                	shr    %cl,%eax
  802247:	09 c5                	or     %eax,%ebp
  802249:	8b 44 24 04          	mov    0x4(%esp),%eax
  80224d:	89 c1                	mov    %eax,%ecx
  80224f:	d3 e7                	shl    %cl,%edi
  802251:	89 d1                	mov    %edx,%ecx
  802253:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802257:	89 df                	mov    %ebx,%edi
  802259:	d3 ef                	shr    %cl,%edi
  80225b:	89 c1                	mov    %eax,%ecx
  80225d:	89 f0                	mov    %esi,%eax
  80225f:	d3 e3                	shl    %cl,%ebx
  802261:	89 d1                	mov    %edx,%ecx
  802263:	89 fa                	mov    %edi,%edx
  802265:	d3 e8                	shr    %cl,%eax
  802267:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80226c:	09 d8                	or     %ebx,%eax
  80226e:	f7 f5                	div    %ebp
  802270:	d3 e6                	shl    %cl,%esi
  802272:	89 d1                	mov    %edx,%ecx
  802274:	f7 64 24 08          	mull   0x8(%esp)
  802278:	39 d1                	cmp    %edx,%ecx
  80227a:	89 c3                	mov    %eax,%ebx
  80227c:	89 d7                	mov    %edx,%edi
  80227e:	72 06                	jb     802286 <__umoddi3+0xa6>
  802280:	75 0e                	jne    802290 <__umoddi3+0xb0>
  802282:	39 c6                	cmp    %eax,%esi
  802284:	73 0a                	jae    802290 <__umoddi3+0xb0>
  802286:	2b 44 24 08          	sub    0x8(%esp),%eax
  80228a:	19 ea                	sbb    %ebp,%edx
  80228c:	89 d7                	mov    %edx,%edi
  80228e:	89 c3                	mov    %eax,%ebx
  802290:	89 ca                	mov    %ecx,%edx
  802292:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  802297:	29 de                	sub    %ebx,%esi
  802299:	19 fa                	sbb    %edi,%edx
  80229b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  80229f:	89 d0                	mov    %edx,%eax
  8022a1:	d3 e0                	shl    %cl,%eax
  8022a3:	89 d9                	mov    %ebx,%ecx
  8022a5:	d3 ee                	shr    %cl,%esi
  8022a7:	d3 ea                	shr    %cl,%edx
  8022a9:	09 f0                	or     %esi,%eax
  8022ab:	83 c4 1c             	add    $0x1c,%esp
  8022ae:	5b                   	pop    %ebx
  8022af:	5e                   	pop    %esi
  8022b0:	5f                   	pop    %edi
  8022b1:	5d                   	pop    %ebp
  8022b2:	c3                   	ret    
  8022b3:	90                   	nop
  8022b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8022b8:	85 ff                	test   %edi,%edi
  8022ba:	89 f9                	mov    %edi,%ecx
  8022bc:	75 0b                	jne    8022c9 <__umoddi3+0xe9>
  8022be:	b8 01 00 00 00       	mov    $0x1,%eax
  8022c3:	31 d2                	xor    %edx,%edx
  8022c5:	f7 f7                	div    %edi
  8022c7:	89 c1                	mov    %eax,%ecx
  8022c9:	89 d8                	mov    %ebx,%eax
  8022cb:	31 d2                	xor    %edx,%edx
  8022cd:	f7 f1                	div    %ecx
  8022cf:	89 f0                	mov    %esi,%eax
  8022d1:	f7 f1                	div    %ecx
  8022d3:	e9 31 ff ff ff       	jmp    802209 <__umoddi3+0x29>
  8022d8:	90                   	nop
  8022d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022e0:	39 dd                	cmp    %ebx,%ebp
  8022e2:	72 08                	jb     8022ec <__umoddi3+0x10c>
  8022e4:	39 f7                	cmp    %esi,%edi
  8022e6:	0f 87 21 ff ff ff    	ja     80220d <__umoddi3+0x2d>
  8022ec:	89 da                	mov    %ebx,%edx
  8022ee:	89 f0                	mov    %esi,%eax
  8022f0:	29 f8                	sub    %edi,%eax
  8022f2:	19 ea                	sbb    %ebp,%edx
  8022f4:	e9 14 ff ff ff       	jmp    80220d <__umoddi3+0x2d>
