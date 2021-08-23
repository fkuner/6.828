
obj/user/faultnostack.debug:     file format elf32-i386


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
  80002c:	e8 23 00 00 00       	call   800054 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

void _pgfault_upcall();

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	sys_env_set_pgfault_upcall(0, (void*) _pgfault_upcall);
  800039:	68 80 03 80 00       	push   $0x800380
  80003e:	6a 00                	push   $0x0
  800040:	e8 76 02 00 00       	call   8002bb <sys_env_set_pgfault_upcall>
	*(int*)0 = 0;
  800045:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  80004c:	00 00 00 
}
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	c9                   	leave  
  800053:	c3                   	ret    

00800054 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800054:	55                   	push   %ebp
  800055:	89 e5                	mov    %esp,%ebp
  800057:	56                   	push   %esi
  800058:	53                   	push   %ebx
  800059:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80005c:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
    thisenv = &envs[ENVX(sys_getenvid())];
  80005f:	e8 ce 00 00 00       	call   800132 <sys_getenvid>
  800064:	25 ff 03 00 00       	and    $0x3ff,%eax
  800069:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80006c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800071:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800076:	85 db                	test   %ebx,%ebx
  800078:	7e 07                	jle    800081 <libmain+0x2d>
		binaryname = argv[0];
  80007a:	8b 06                	mov    (%esi),%eax
  80007c:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800081:	83 ec 08             	sub    $0x8,%esp
  800084:	56                   	push   %esi
  800085:	53                   	push   %ebx
  800086:	e8 a8 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80008b:	e8 0a 00 00 00       	call   80009a <exit>
}
  800090:	83 c4 10             	add    $0x10,%esp
  800093:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800096:	5b                   	pop    %ebx
  800097:	5e                   	pop    %esi
  800098:	5d                   	pop    %ebp
  800099:	c3                   	ret    

0080009a <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80009a:	55                   	push   %ebp
  80009b:	89 e5                	mov    %esp,%ebp
  80009d:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000a0:	e8 d7 04 00 00       	call   80057c <close_all>
	sys_env_destroy(0);
  8000a5:	83 ec 0c             	sub    $0xc,%esp
  8000a8:	6a 00                	push   $0x0
  8000aa:	e8 42 00 00 00       	call   8000f1 <sys_env_destroy>
}
  8000af:	83 c4 10             	add    $0x10,%esp
  8000b2:	c9                   	leave  
  8000b3:	c3                   	ret    

008000b4 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000b4:	55                   	push   %ebp
  8000b5:	89 e5                	mov    %esp,%ebp
  8000b7:	57                   	push   %edi
  8000b8:	56                   	push   %esi
  8000b9:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8000bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8000c2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000c5:	89 c3                	mov    %eax,%ebx
  8000c7:	89 c7                	mov    %eax,%edi
  8000c9:	89 c6                	mov    %eax,%esi
  8000cb:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000cd:	5b                   	pop    %ebx
  8000ce:	5e                   	pop    %esi
  8000cf:	5f                   	pop    %edi
  8000d0:	5d                   	pop    %ebp
  8000d1:	c3                   	ret    

008000d2 <sys_cgetc>:

int
sys_cgetc(void)
{
  8000d2:	55                   	push   %ebp
  8000d3:	89 e5                	mov    %esp,%ebp
  8000d5:	57                   	push   %edi
  8000d6:	56                   	push   %esi
  8000d7:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8000dd:	b8 01 00 00 00       	mov    $0x1,%eax
  8000e2:	89 d1                	mov    %edx,%ecx
  8000e4:	89 d3                	mov    %edx,%ebx
  8000e6:	89 d7                	mov    %edx,%edi
  8000e8:	89 d6                	mov    %edx,%esi
  8000ea:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000ec:	5b                   	pop    %ebx
  8000ed:	5e                   	pop    %esi
  8000ee:	5f                   	pop    %edi
  8000ef:	5d                   	pop    %ebp
  8000f0:	c3                   	ret    

008000f1 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000f1:	55                   	push   %ebp
  8000f2:	89 e5                	mov    %esp,%ebp
  8000f4:	57                   	push   %edi
  8000f5:	56                   	push   %esi
  8000f6:	53                   	push   %ebx
  8000f7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8000fa:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000ff:	8b 55 08             	mov    0x8(%ebp),%edx
  800102:	b8 03 00 00 00       	mov    $0x3,%eax
  800107:	89 cb                	mov    %ecx,%ebx
  800109:	89 cf                	mov    %ecx,%edi
  80010b:	89 ce                	mov    %ecx,%esi
  80010d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80010f:	85 c0                	test   %eax,%eax
  800111:	7f 08                	jg     80011b <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800113:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800116:	5b                   	pop    %ebx
  800117:	5e                   	pop    %esi
  800118:	5f                   	pop    %edi
  800119:	5d                   	pop    %ebp
  80011a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	50                   	push   %eax
  80011f:	6a 03                	push   $0x3
  800121:	68 ca 23 80 00       	push   $0x8023ca
  800126:	6a 23                	push   $0x23
  800128:	68 e7 23 80 00       	push   $0x8023e7
  80012d:	e8 d3 13 00 00       	call   801505 <_panic>

00800132 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800132:	55                   	push   %ebp
  800133:	89 e5                	mov    %esp,%ebp
  800135:	57                   	push   %edi
  800136:	56                   	push   %esi
  800137:	53                   	push   %ebx
	asm volatile("int %1\n"
  800138:	ba 00 00 00 00       	mov    $0x0,%edx
  80013d:	b8 02 00 00 00       	mov    $0x2,%eax
  800142:	89 d1                	mov    %edx,%ecx
  800144:	89 d3                	mov    %edx,%ebx
  800146:	89 d7                	mov    %edx,%edi
  800148:	89 d6                	mov    %edx,%esi
  80014a:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80014c:	5b                   	pop    %ebx
  80014d:	5e                   	pop    %esi
  80014e:	5f                   	pop    %edi
  80014f:	5d                   	pop    %ebp
  800150:	c3                   	ret    

00800151 <sys_yield>:

void
sys_yield(void)
{
  800151:	55                   	push   %ebp
  800152:	89 e5                	mov    %esp,%ebp
  800154:	57                   	push   %edi
  800155:	56                   	push   %esi
  800156:	53                   	push   %ebx
	asm volatile("int %1\n"
  800157:	ba 00 00 00 00       	mov    $0x0,%edx
  80015c:	b8 0b 00 00 00       	mov    $0xb,%eax
  800161:	89 d1                	mov    %edx,%ecx
  800163:	89 d3                	mov    %edx,%ebx
  800165:	89 d7                	mov    %edx,%edi
  800167:	89 d6                	mov    %edx,%esi
  800169:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80016b:	5b                   	pop    %ebx
  80016c:	5e                   	pop    %esi
  80016d:	5f                   	pop    %edi
  80016e:	5d                   	pop    %ebp
  80016f:	c3                   	ret    

00800170 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800170:	55                   	push   %ebp
  800171:	89 e5                	mov    %esp,%ebp
  800173:	57                   	push   %edi
  800174:	56                   	push   %esi
  800175:	53                   	push   %ebx
  800176:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800179:	be 00 00 00 00       	mov    $0x0,%esi
  80017e:	8b 55 08             	mov    0x8(%ebp),%edx
  800181:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800184:	b8 04 00 00 00       	mov    $0x4,%eax
  800189:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80018c:	89 f7                	mov    %esi,%edi
  80018e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800190:	85 c0                	test   %eax,%eax
  800192:	7f 08                	jg     80019c <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800194:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800197:	5b                   	pop    %ebx
  800198:	5e                   	pop    %esi
  800199:	5f                   	pop    %edi
  80019a:	5d                   	pop    %ebp
  80019b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80019c:	83 ec 0c             	sub    $0xc,%esp
  80019f:	50                   	push   %eax
  8001a0:	6a 04                	push   $0x4
  8001a2:	68 ca 23 80 00       	push   $0x8023ca
  8001a7:	6a 23                	push   $0x23
  8001a9:	68 e7 23 80 00       	push   $0x8023e7
  8001ae:	e8 52 13 00 00       	call   801505 <_panic>

008001b3 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001b3:	55                   	push   %ebp
  8001b4:	89 e5                	mov    %esp,%ebp
  8001b6:	57                   	push   %edi
  8001b7:	56                   	push   %esi
  8001b8:	53                   	push   %ebx
  8001b9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8001bf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001c2:	b8 05 00 00 00       	mov    $0x5,%eax
  8001c7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001ca:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001cd:	8b 75 18             	mov    0x18(%ebp),%esi
  8001d0:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001d2:	85 c0                	test   %eax,%eax
  8001d4:	7f 08                	jg     8001de <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001d9:	5b                   	pop    %ebx
  8001da:	5e                   	pop    %esi
  8001db:	5f                   	pop    %edi
  8001dc:	5d                   	pop    %ebp
  8001dd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001de:	83 ec 0c             	sub    $0xc,%esp
  8001e1:	50                   	push   %eax
  8001e2:	6a 05                	push   $0x5
  8001e4:	68 ca 23 80 00       	push   $0x8023ca
  8001e9:	6a 23                	push   $0x23
  8001eb:	68 e7 23 80 00       	push   $0x8023e7
  8001f0:	e8 10 13 00 00       	call   801505 <_panic>

008001f5 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001f5:	55                   	push   %ebp
  8001f6:	89 e5                	mov    %esp,%ebp
  8001f8:	57                   	push   %edi
  8001f9:	56                   	push   %esi
  8001fa:	53                   	push   %ebx
  8001fb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001fe:	bb 00 00 00 00       	mov    $0x0,%ebx
  800203:	8b 55 08             	mov    0x8(%ebp),%edx
  800206:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800209:	b8 06 00 00 00       	mov    $0x6,%eax
  80020e:	89 df                	mov    %ebx,%edi
  800210:	89 de                	mov    %ebx,%esi
  800212:	cd 30                	int    $0x30
	if(check && ret > 0)
  800214:	85 c0                	test   %eax,%eax
  800216:	7f 08                	jg     800220 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800218:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80021b:	5b                   	pop    %ebx
  80021c:	5e                   	pop    %esi
  80021d:	5f                   	pop    %edi
  80021e:	5d                   	pop    %ebp
  80021f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800220:	83 ec 0c             	sub    $0xc,%esp
  800223:	50                   	push   %eax
  800224:	6a 06                	push   $0x6
  800226:	68 ca 23 80 00       	push   $0x8023ca
  80022b:	6a 23                	push   $0x23
  80022d:	68 e7 23 80 00       	push   $0x8023e7
  800232:	e8 ce 12 00 00       	call   801505 <_panic>

00800237 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800237:	55                   	push   %ebp
  800238:	89 e5                	mov    %esp,%ebp
  80023a:	57                   	push   %edi
  80023b:	56                   	push   %esi
  80023c:	53                   	push   %ebx
  80023d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800240:	bb 00 00 00 00       	mov    $0x0,%ebx
  800245:	8b 55 08             	mov    0x8(%ebp),%edx
  800248:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80024b:	b8 08 00 00 00       	mov    $0x8,%eax
  800250:	89 df                	mov    %ebx,%edi
  800252:	89 de                	mov    %ebx,%esi
  800254:	cd 30                	int    $0x30
	if(check && ret > 0)
  800256:	85 c0                	test   %eax,%eax
  800258:	7f 08                	jg     800262 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80025a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80025d:	5b                   	pop    %ebx
  80025e:	5e                   	pop    %esi
  80025f:	5f                   	pop    %edi
  800260:	5d                   	pop    %ebp
  800261:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800262:	83 ec 0c             	sub    $0xc,%esp
  800265:	50                   	push   %eax
  800266:	6a 08                	push   $0x8
  800268:	68 ca 23 80 00       	push   $0x8023ca
  80026d:	6a 23                	push   $0x23
  80026f:	68 e7 23 80 00       	push   $0x8023e7
  800274:	e8 8c 12 00 00       	call   801505 <_panic>

00800279 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800279:	55                   	push   %ebp
  80027a:	89 e5                	mov    %esp,%ebp
  80027c:	57                   	push   %edi
  80027d:	56                   	push   %esi
  80027e:	53                   	push   %ebx
  80027f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800282:	bb 00 00 00 00       	mov    $0x0,%ebx
  800287:	8b 55 08             	mov    0x8(%ebp),%edx
  80028a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80028d:	b8 09 00 00 00       	mov    $0x9,%eax
  800292:	89 df                	mov    %ebx,%edi
  800294:	89 de                	mov    %ebx,%esi
  800296:	cd 30                	int    $0x30
	if(check && ret > 0)
  800298:	85 c0                	test   %eax,%eax
  80029a:	7f 08                	jg     8002a4 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80029c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80029f:	5b                   	pop    %ebx
  8002a0:	5e                   	pop    %esi
  8002a1:	5f                   	pop    %edi
  8002a2:	5d                   	pop    %ebp
  8002a3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002a4:	83 ec 0c             	sub    $0xc,%esp
  8002a7:	50                   	push   %eax
  8002a8:	6a 09                	push   $0x9
  8002aa:	68 ca 23 80 00       	push   $0x8023ca
  8002af:	6a 23                	push   $0x23
  8002b1:	68 e7 23 80 00       	push   $0x8023e7
  8002b6:	e8 4a 12 00 00       	call   801505 <_panic>

008002bb <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002bb:	55                   	push   %ebp
  8002bc:	89 e5                	mov    %esp,%ebp
  8002be:	57                   	push   %edi
  8002bf:	56                   	push   %esi
  8002c0:	53                   	push   %ebx
  8002c1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002c4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002c9:	8b 55 08             	mov    0x8(%ebp),%edx
  8002cc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002cf:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002d4:	89 df                	mov    %ebx,%edi
  8002d6:	89 de                	mov    %ebx,%esi
  8002d8:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002da:	85 c0                	test   %eax,%eax
  8002dc:	7f 08                	jg     8002e6 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8002de:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002e1:	5b                   	pop    %ebx
  8002e2:	5e                   	pop    %esi
  8002e3:	5f                   	pop    %edi
  8002e4:	5d                   	pop    %ebp
  8002e5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002e6:	83 ec 0c             	sub    $0xc,%esp
  8002e9:	50                   	push   %eax
  8002ea:	6a 0a                	push   $0xa
  8002ec:	68 ca 23 80 00       	push   $0x8023ca
  8002f1:	6a 23                	push   $0x23
  8002f3:	68 e7 23 80 00       	push   $0x8023e7
  8002f8:	e8 08 12 00 00       	call   801505 <_panic>

008002fd <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8002fd:	55                   	push   %ebp
  8002fe:	89 e5                	mov    %esp,%ebp
  800300:	57                   	push   %edi
  800301:	56                   	push   %esi
  800302:	53                   	push   %ebx
	asm volatile("int %1\n"
  800303:	8b 55 08             	mov    0x8(%ebp),%edx
  800306:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800309:	b8 0c 00 00 00       	mov    $0xc,%eax
  80030e:	be 00 00 00 00       	mov    $0x0,%esi
  800313:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800316:	8b 7d 14             	mov    0x14(%ebp),%edi
  800319:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80031b:	5b                   	pop    %ebx
  80031c:	5e                   	pop    %esi
  80031d:	5f                   	pop    %edi
  80031e:	5d                   	pop    %ebp
  80031f:	c3                   	ret    

00800320 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800320:	55                   	push   %ebp
  800321:	89 e5                	mov    %esp,%ebp
  800323:	57                   	push   %edi
  800324:	56                   	push   %esi
  800325:	53                   	push   %ebx
  800326:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800329:	b9 00 00 00 00       	mov    $0x0,%ecx
  80032e:	8b 55 08             	mov    0x8(%ebp),%edx
  800331:	b8 0d 00 00 00       	mov    $0xd,%eax
  800336:	89 cb                	mov    %ecx,%ebx
  800338:	89 cf                	mov    %ecx,%edi
  80033a:	89 ce                	mov    %ecx,%esi
  80033c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80033e:	85 c0                	test   %eax,%eax
  800340:	7f 08                	jg     80034a <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800342:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800345:	5b                   	pop    %ebx
  800346:	5e                   	pop    %esi
  800347:	5f                   	pop    %edi
  800348:	5d                   	pop    %ebp
  800349:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80034a:	83 ec 0c             	sub    $0xc,%esp
  80034d:	50                   	push   %eax
  80034e:	6a 0d                	push   $0xd
  800350:	68 ca 23 80 00       	push   $0x8023ca
  800355:	6a 23                	push   $0x23
  800357:	68 e7 23 80 00       	push   $0x8023e7
  80035c:	e8 a4 11 00 00       	call   801505 <_panic>

00800361 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800361:	55                   	push   %ebp
  800362:	89 e5                	mov    %esp,%ebp
  800364:	57                   	push   %edi
  800365:	56                   	push   %esi
  800366:	53                   	push   %ebx
	asm volatile("int %1\n"
  800367:	ba 00 00 00 00       	mov    $0x0,%edx
  80036c:	b8 0e 00 00 00       	mov    $0xe,%eax
  800371:	89 d1                	mov    %edx,%ecx
  800373:	89 d3                	mov    %edx,%ebx
  800375:	89 d7                	mov    %edx,%edi
  800377:	89 d6                	mov    %edx,%esi
  800379:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  80037b:	5b                   	pop    %ebx
  80037c:	5e                   	pop    %esi
  80037d:	5f                   	pop    %edi
  80037e:	5d                   	pop    %ebp
  80037f:	c3                   	ret    

00800380 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  800380:	54                   	push   %esp
	movl _pgfault_handler, %eax
  800381:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  800386:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  800388:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x30(%esp), %ecx    // save trap-time esp in ecx
  80038b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
	subl $4, %ecx            // enlarge the previous stack for 4 bytes
  80038f:	83 e9 04             	sub    $0x4,%ecx
	movl %ecx, 0x30(%esp)    // write the modified esp back
  800392:	89 4c 24 30          	mov    %ecx,0x30(%esp)
	movl 0x28(%esp), %edx    // save trap-time eip in edx
  800396:	8b 54 24 28          	mov    0x28(%esp),%edx
	movl %edx, (%ecx)        // save eip at new esp for return
  80039a:	89 11                	mov    %edx,(%ecx)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp            // skip fault_va and tf_err
  80039c:	83 c4 08             	add    $0x8,%esp
	popal                    // pop PushRegs
  80039f:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4, %esp            // skip eip
  8003a0:	83 c4 04             	add    $0x4,%esp
	popfl                    // pop eflags
  8003a3:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	pop %esp
  8003a4:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8003a5:	c3                   	ret    

008003a6 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8003a6:	55                   	push   %ebp
  8003a7:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8003a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ac:	05 00 00 00 30       	add    $0x30000000,%eax
  8003b1:	c1 e8 0c             	shr    $0xc,%eax
}
  8003b4:	5d                   	pop    %ebp
  8003b5:	c3                   	ret    

008003b6 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8003b6:	55                   	push   %ebp
  8003b7:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8003b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8003bc:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8003c1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003c6:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8003cb:	5d                   	pop    %ebp
  8003cc:	c3                   	ret    

008003cd <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8003cd:	55                   	push   %ebp
  8003ce:	89 e5                	mov    %esp,%ebp
  8003d0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003d3:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8003d8:	89 c2                	mov    %eax,%edx
  8003da:	c1 ea 16             	shr    $0x16,%edx
  8003dd:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8003e4:	f6 c2 01             	test   $0x1,%dl
  8003e7:	74 2a                	je     800413 <fd_alloc+0x46>
  8003e9:	89 c2                	mov    %eax,%edx
  8003eb:	c1 ea 0c             	shr    $0xc,%edx
  8003ee:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8003f5:	f6 c2 01             	test   $0x1,%dl
  8003f8:	74 19                	je     800413 <fd_alloc+0x46>
  8003fa:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8003ff:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800404:	75 d2                	jne    8003d8 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800406:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80040c:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800411:	eb 07                	jmp    80041a <fd_alloc+0x4d>
			*fd_store = fd;
  800413:	89 01                	mov    %eax,(%ecx)
			return 0;
  800415:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80041a:	5d                   	pop    %ebp
  80041b:	c3                   	ret    

0080041c <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80041c:	55                   	push   %ebp
  80041d:	89 e5                	mov    %esp,%ebp
  80041f:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800422:	83 f8 1f             	cmp    $0x1f,%eax
  800425:	77 36                	ja     80045d <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800427:	c1 e0 0c             	shl    $0xc,%eax
  80042a:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80042f:	89 c2                	mov    %eax,%edx
  800431:	c1 ea 16             	shr    $0x16,%edx
  800434:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80043b:	f6 c2 01             	test   $0x1,%dl
  80043e:	74 24                	je     800464 <fd_lookup+0x48>
  800440:	89 c2                	mov    %eax,%edx
  800442:	c1 ea 0c             	shr    $0xc,%edx
  800445:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80044c:	f6 c2 01             	test   $0x1,%dl
  80044f:	74 1a                	je     80046b <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800451:	8b 55 0c             	mov    0xc(%ebp),%edx
  800454:	89 02                	mov    %eax,(%edx)
	return 0;
  800456:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80045b:	5d                   	pop    %ebp
  80045c:	c3                   	ret    
		return -E_INVAL;
  80045d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800462:	eb f7                	jmp    80045b <fd_lookup+0x3f>
		return -E_INVAL;
  800464:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800469:	eb f0                	jmp    80045b <fd_lookup+0x3f>
  80046b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800470:	eb e9                	jmp    80045b <fd_lookup+0x3f>

00800472 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800472:	55                   	push   %ebp
  800473:	89 e5                	mov    %esp,%ebp
  800475:	83 ec 08             	sub    $0x8,%esp
  800478:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80047b:	ba 74 24 80 00       	mov    $0x802474,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800480:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800485:	39 08                	cmp    %ecx,(%eax)
  800487:	74 33                	je     8004bc <dev_lookup+0x4a>
  800489:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  80048c:	8b 02                	mov    (%edx),%eax
  80048e:	85 c0                	test   %eax,%eax
  800490:	75 f3                	jne    800485 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800492:	a1 08 40 80 00       	mov    0x804008,%eax
  800497:	8b 40 48             	mov    0x48(%eax),%eax
  80049a:	83 ec 04             	sub    $0x4,%esp
  80049d:	51                   	push   %ecx
  80049e:	50                   	push   %eax
  80049f:	68 f8 23 80 00       	push   $0x8023f8
  8004a4:	e8 37 11 00 00       	call   8015e0 <cprintf>
	*dev = 0;
  8004a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8004b2:	83 c4 10             	add    $0x10,%esp
  8004b5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8004ba:	c9                   	leave  
  8004bb:	c3                   	ret    
			*dev = devtab[i];
  8004bc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004bf:	89 01                	mov    %eax,(%ecx)
			return 0;
  8004c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8004c6:	eb f2                	jmp    8004ba <dev_lookup+0x48>

008004c8 <fd_close>:
{
  8004c8:	55                   	push   %ebp
  8004c9:	89 e5                	mov    %esp,%ebp
  8004cb:	57                   	push   %edi
  8004cc:	56                   	push   %esi
  8004cd:	53                   	push   %ebx
  8004ce:	83 ec 1c             	sub    $0x1c,%esp
  8004d1:	8b 75 08             	mov    0x8(%ebp),%esi
  8004d4:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8004d7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8004da:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8004db:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8004e1:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8004e4:	50                   	push   %eax
  8004e5:	e8 32 ff ff ff       	call   80041c <fd_lookup>
  8004ea:	89 c3                	mov    %eax,%ebx
  8004ec:	83 c4 08             	add    $0x8,%esp
  8004ef:	85 c0                	test   %eax,%eax
  8004f1:	78 05                	js     8004f8 <fd_close+0x30>
	    || fd != fd2)
  8004f3:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8004f6:	74 16                	je     80050e <fd_close+0x46>
		return (must_exist ? r : 0);
  8004f8:	89 f8                	mov    %edi,%eax
  8004fa:	84 c0                	test   %al,%al
  8004fc:	b8 00 00 00 00       	mov    $0x0,%eax
  800501:	0f 44 d8             	cmove  %eax,%ebx
}
  800504:	89 d8                	mov    %ebx,%eax
  800506:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800509:	5b                   	pop    %ebx
  80050a:	5e                   	pop    %esi
  80050b:	5f                   	pop    %edi
  80050c:	5d                   	pop    %ebp
  80050d:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80050e:	83 ec 08             	sub    $0x8,%esp
  800511:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800514:	50                   	push   %eax
  800515:	ff 36                	pushl  (%esi)
  800517:	e8 56 ff ff ff       	call   800472 <dev_lookup>
  80051c:	89 c3                	mov    %eax,%ebx
  80051e:	83 c4 10             	add    $0x10,%esp
  800521:	85 c0                	test   %eax,%eax
  800523:	78 15                	js     80053a <fd_close+0x72>
		if (dev->dev_close)
  800525:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800528:	8b 40 10             	mov    0x10(%eax),%eax
  80052b:	85 c0                	test   %eax,%eax
  80052d:	74 1b                	je     80054a <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  80052f:	83 ec 0c             	sub    $0xc,%esp
  800532:	56                   	push   %esi
  800533:	ff d0                	call   *%eax
  800535:	89 c3                	mov    %eax,%ebx
  800537:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80053a:	83 ec 08             	sub    $0x8,%esp
  80053d:	56                   	push   %esi
  80053e:	6a 00                	push   $0x0
  800540:	e8 b0 fc ff ff       	call   8001f5 <sys_page_unmap>
	return r;
  800545:	83 c4 10             	add    $0x10,%esp
  800548:	eb ba                	jmp    800504 <fd_close+0x3c>
			r = 0;
  80054a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80054f:	eb e9                	jmp    80053a <fd_close+0x72>

00800551 <close>:

int
close(int fdnum)
{
  800551:	55                   	push   %ebp
  800552:	89 e5                	mov    %esp,%ebp
  800554:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800557:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80055a:	50                   	push   %eax
  80055b:	ff 75 08             	pushl  0x8(%ebp)
  80055e:	e8 b9 fe ff ff       	call   80041c <fd_lookup>
  800563:	83 c4 08             	add    $0x8,%esp
  800566:	85 c0                	test   %eax,%eax
  800568:	78 10                	js     80057a <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  80056a:	83 ec 08             	sub    $0x8,%esp
  80056d:	6a 01                	push   $0x1
  80056f:	ff 75 f4             	pushl  -0xc(%ebp)
  800572:	e8 51 ff ff ff       	call   8004c8 <fd_close>
  800577:	83 c4 10             	add    $0x10,%esp
}
  80057a:	c9                   	leave  
  80057b:	c3                   	ret    

0080057c <close_all>:

void
close_all(void)
{
  80057c:	55                   	push   %ebp
  80057d:	89 e5                	mov    %esp,%ebp
  80057f:	53                   	push   %ebx
  800580:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800583:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800588:	83 ec 0c             	sub    $0xc,%esp
  80058b:	53                   	push   %ebx
  80058c:	e8 c0 ff ff ff       	call   800551 <close>
	for (i = 0; i < MAXFD; i++)
  800591:	83 c3 01             	add    $0x1,%ebx
  800594:	83 c4 10             	add    $0x10,%esp
  800597:	83 fb 20             	cmp    $0x20,%ebx
  80059a:	75 ec                	jne    800588 <close_all+0xc>
}
  80059c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80059f:	c9                   	leave  
  8005a0:	c3                   	ret    

008005a1 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8005a1:	55                   	push   %ebp
  8005a2:	89 e5                	mov    %esp,%ebp
  8005a4:	57                   	push   %edi
  8005a5:	56                   	push   %esi
  8005a6:	53                   	push   %ebx
  8005a7:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8005aa:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8005ad:	50                   	push   %eax
  8005ae:	ff 75 08             	pushl  0x8(%ebp)
  8005b1:	e8 66 fe ff ff       	call   80041c <fd_lookup>
  8005b6:	89 c3                	mov    %eax,%ebx
  8005b8:	83 c4 08             	add    $0x8,%esp
  8005bb:	85 c0                	test   %eax,%eax
  8005bd:	0f 88 81 00 00 00    	js     800644 <dup+0xa3>
		return r;
	close(newfdnum);
  8005c3:	83 ec 0c             	sub    $0xc,%esp
  8005c6:	ff 75 0c             	pushl  0xc(%ebp)
  8005c9:	e8 83 ff ff ff       	call   800551 <close>

	newfd = INDEX2FD(newfdnum);
  8005ce:	8b 75 0c             	mov    0xc(%ebp),%esi
  8005d1:	c1 e6 0c             	shl    $0xc,%esi
  8005d4:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8005da:	83 c4 04             	add    $0x4,%esp
  8005dd:	ff 75 e4             	pushl  -0x1c(%ebp)
  8005e0:	e8 d1 fd ff ff       	call   8003b6 <fd2data>
  8005e5:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8005e7:	89 34 24             	mov    %esi,(%esp)
  8005ea:	e8 c7 fd ff ff       	call   8003b6 <fd2data>
  8005ef:	83 c4 10             	add    $0x10,%esp
  8005f2:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8005f4:	89 d8                	mov    %ebx,%eax
  8005f6:	c1 e8 16             	shr    $0x16,%eax
  8005f9:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800600:	a8 01                	test   $0x1,%al
  800602:	74 11                	je     800615 <dup+0x74>
  800604:	89 d8                	mov    %ebx,%eax
  800606:	c1 e8 0c             	shr    $0xc,%eax
  800609:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800610:	f6 c2 01             	test   $0x1,%dl
  800613:	75 39                	jne    80064e <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800615:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800618:	89 d0                	mov    %edx,%eax
  80061a:	c1 e8 0c             	shr    $0xc,%eax
  80061d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800624:	83 ec 0c             	sub    $0xc,%esp
  800627:	25 07 0e 00 00       	and    $0xe07,%eax
  80062c:	50                   	push   %eax
  80062d:	56                   	push   %esi
  80062e:	6a 00                	push   $0x0
  800630:	52                   	push   %edx
  800631:	6a 00                	push   $0x0
  800633:	e8 7b fb ff ff       	call   8001b3 <sys_page_map>
  800638:	89 c3                	mov    %eax,%ebx
  80063a:	83 c4 20             	add    $0x20,%esp
  80063d:	85 c0                	test   %eax,%eax
  80063f:	78 31                	js     800672 <dup+0xd1>
		goto err;

	return newfdnum;
  800641:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  800644:	89 d8                	mov    %ebx,%eax
  800646:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800649:	5b                   	pop    %ebx
  80064a:	5e                   	pop    %esi
  80064b:	5f                   	pop    %edi
  80064c:	5d                   	pop    %ebp
  80064d:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80064e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800655:	83 ec 0c             	sub    $0xc,%esp
  800658:	25 07 0e 00 00       	and    $0xe07,%eax
  80065d:	50                   	push   %eax
  80065e:	57                   	push   %edi
  80065f:	6a 00                	push   $0x0
  800661:	53                   	push   %ebx
  800662:	6a 00                	push   $0x0
  800664:	e8 4a fb ff ff       	call   8001b3 <sys_page_map>
  800669:	89 c3                	mov    %eax,%ebx
  80066b:	83 c4 20             	add    $0x20,%esp
  80066e:	85 c0                	test   %eax,%eax
  800670:	79 a3                	jns    800615 <dup+0x74>
	sys_page_unmap(0, newfd);
  800672:	83 ec 08             	sub    $0x8,%esp
  800675:	56                   	push   %esi
  800676:	6a 00                	push   $0x0
  800678:	e8 78 fb ff ff       	call   8001f5 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80067d:	83 c4 08             	add    $0x8,%esp
  800680:	57                   	push   %edi
  800681:	6a 00                	push   $0x0
  800683:	e8 6d fb ff ff       	call   8001f5 <sys_page_unmap>
	return r;
  800688:	83 c4 10             	add    $0x10,%esp
  80068b:	eb b7                	jmp    800644 <dup+0xa3>

0080068d <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80068d:	55                   	push   %ebp
  80068e:	89 e5                	mov    %esp,%ebp
  800690:	53                   	push   %ebx
  800691:	83 ec 14             	sub    $0x14,%esp
  800694:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800697:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80069a:	50                   	push   %eax
  80069b:	53                   	push   %ebx
  80069c:	e8 7b fd ff ff       	call   80041c <fd_lookup>
  8006a1:	83 c4 08             	add    $0x8,%esp
  8006a4:	85 c0                	test   %eax,%eax
  8006a6:	78 3f                	js     8006e7 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8006a8:	83 ec 08             	sub    $0x8,%esp
  8006ab:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8006ae:	50                   	push   %eax
  8006af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006b2:	ff 30                	pushl  (%eax)
  8006b4:	e8 b9 fd ff ff       	call   800472 <dev_lookup>
  8006b9:	83 c4 10             	add    $0x10,%esp
  8006bc:	85 c0                	test   %eax,%eax
  8006be:	78 27                	js     8006e7 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8006c0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8006c3:	8b 42 08             	mov    0x8(%edx),%eax
  8006c6:	83 e0 03             	and    $0x3,%eax
  8006c9:	83 f8 01             	cmp    $0x1,%eax
  8006cc:	74 1e                	je     8006ec <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8006ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006d1:	8b 40 08             	mov    0x8(%eax),%eax
  8006d4:	85 c0                	test   %eax,%eax
  8006d6:	74 35                	je     80070d <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8006d8:	83 ec 04             	sub    $0x4,%esp
  8006db:	ff 75 10             	pushl  0x10(%ebp)
  8006de:	ff 75 0c             	pushl  0xc(%ebp)
  8006e1:	52                   	push   %edx
  8006e2:	ff d0                	call   *%eax
  8006e4:	83 c4 10             	add    $0x10,%esp
}
  8006e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006ea:	c9                   	leave  
  8006eb:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8006ec:	a1 08 40 80 00       	mov    0x804008,%eax
  8006f1:	8b 40 48             	mov    0x48(%eax),%eax
  8006f4:	83 ec 04             	sub    $0x4,%esp
  8006f7:	53                   	push   %ebx
  8006f8:	50                   	push   %eax
  8006f9:	68 39 24 80 00       	push   $0x802439
  8006fe:	e8 dd 0e 00 00       	call   8015e0 <cprintf>
		return -E_INVAL;
  800703:	83 c4 10             	add    $0x10,%esp
  800706:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80070b:	eb da                	jmp    8006e7 <read+0x5a>
		return -E_NOT_SUPP;
  80070d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800712:	eb d3                	jmp    8006e7 <read+0x5a>

00800714 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800714:	55                   	push   %ebp
  800715:	89 e5                	mov    %esp,%ebp
  800717:	57                   	push   %edi
  800718:	56                   	push   %esi
  800719:	53                   	push   %ebx
  80071a:	83 ec 0c             	sub    $0xc,%esp
  80071d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800720:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800723:	bb 00 00 00 00       	mov    $0x0,%ebx
  800728:	39 f3                	cmp    %esi,%ebx
  80072a:	73 25                	jae    800751 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80072c:	83 ec 04             	sub    $0x4,%esp
  80072f:	89 f0                	mov    %esi,%eax
  800731:	29 d8                	sub    %ebx,%eax
  800733:	50                   	push   %eax
  800734:	89 d8                	mov    %ebx,%eax
  800736:	03 45 0c             	add    0xc(%ebp),%eax
  800739:	50                   	push   %eax
  80073a:	57                   	push   %edi
  80073b:	e8 4d ff ff ff       	call   80068d <read>
		if (m < 0)
  800740:	83 c4 10             	add    $0x10,%esp
  800743:	85 c0                	test   %eax,%eax
  800745:	78 08                	js     80074f <readn+0x3b>
			return m;
		if (m == 0)
  800747:	85 c0                	test   %eax,%eax
  800749:	74 06                	je     800751 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  80074b:	01 c3                	add    %eax,%ebx
  80074d:	eb d9                	jmp    800728 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80074f:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  800751:	89 d8                	mov    %ebx,%eax
  800753:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800756:	5b                   	pop    %ebx
  800757:	5e                   	pop    %esi
  800758:	5f                   	pop    %edi
  800759:	5d                   	pop    %ebp
  80075a:	c3                   	ret    

0080075b <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80075b:	55                   	push   %ebp
  80075c:	89 e5                	mov    %esp,%ebp
  80075e:	53                   	push   %ebx
  80075f:	83 ec 14             	sub    $0x14,%esp
  800762:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800765:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800768:	50                   	push   %eax
  800769:	53                   	push   %ebx
  80076a:	e8 ad fc ff ff       	call   80041c <fd_lookup>
  80076f:	83 c4 08             	add    $0x8,%esp
  800772:	85 c0                	test   %eax,%eax
  800774:	78 3a                	js     8007b0 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800776:	83 ec 08             	sub    $0x8,%esp
  800779:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80077c:	50                   	push   %eax
  80077d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800780:	ff 30                	pushl  (%eax)
  800782:	e8 eb fc ff ff       	call   800472 <dev_lookup>
  800787:	83 c4 10             	add    $0x10,%esp
  80078a:	85 c0                	test   %eax,%eax
  80078c:	78 22                	js     8007b0 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80078e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800791:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800795:	74 1e                	je     8007b5 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800797:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80079a:	8b 52 0c             	mov    0xc(%edx),%edx
  80079d:	85 d2                	test   %edx,%edx
  80079f:	74 35                	je     8007d6 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8007a1:	83 ec 04             	sub    $0x4,%esp
  8007a4:	ff 75 10             	pushl  0x10(%ebp)
  8007a7:	ff 75 0c             	pushl  0xc(%ebp)
  8007aa:	50                   	push   %eax
  8007ab:	ff d2                	call   *%edx
  8007ad:	83 c4 10             	add    $0x10,%esp
}
  8007b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007b3:	c9                   	leave  
  8007b4:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8007b5:	a1 08 40 80 00       	mov    0x804008,%eax
  8007ba:	8b 40 48             	mov    0x48(%eax),%eax
  8007bd:	83 ec 04             	sub    $0x4,%esp
  8007c0:	53                   	push   %ebx
  8007c1:	50                   	push   %eax
  8007c2:	68 55 24 80 00       	push   $0x802455
  8007c7:	e8 14 0e 00 00       	call   8015e0 <cprintf>
		return -E_INVAL;
  8007cc:	83 c4 10             	add    $0x10,%esp
  8007cf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007d4:	eb da                	jmp    8007b0 <write+0x55>
		return -E_NOT_SUPP;
  8007d6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8007db:	eb d3                	jmp    8007b0 <write+0x55>

008007dd <seek>:

int
seek(int fdnum, off_t offset)
{
  8007dd:	55                   	push   %ebp
  8007de:	89 e5                	mov    %esp,%ebp
  8007e0:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8007e3:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8007e6:	50                   	push   %eax
  8007e7:	ff 75 08             	pushl  0x8(%ebp)
  8007ea:	e8 2d fc ff ff       	call   80041c <fd_lookup>
  8007ef:	83 c4 08             	add    $0x8,%esp
  8007f2:	85 c0                	test   %eax,%eax
  8007f4:	78 0e                	js     800804 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8007f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8007fc:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8007ff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800804:	c9                   	leave  
  800805:	c3                   	ret    

00800806 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800806:	55                   	push   %ebp
  800807:	89 e5                	mov    %esp,%ebp
  800809:	53                   	push   %ebx
  80080a:	83 ec 14             	sub    $0x14,%esp
  80080d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800810:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800813:	50                   	push   %eax
  800814:	53                   	push   %ebx
  800815:	e8 02 fc ff ff       	call   80041c <fd_lookup>
  80081a:	83 c4 08             	add    $0x8,%esp
  80081d:	85 c0                	test   %eax,%eax
  80081f:	78 37                	js     800858 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800821:	83 ec 08             	sub    $0x8,%esp
  800824:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800827:	50                   	push   %eax
  800828:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80082b:	ff 30                	pushl  (%eax)
  80082d:	e8 40 fc ff ff       	call   800472 <dev_lookup>
  800832:	83 c4 10             	add    $0x10,%esp
  800835:	85 c0                	test   %eax,%eax
  800837:	78 1f                	js     800858 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800839:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80083c:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800840:	74 1b                	je     80085d <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  800842:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800845:	8b 52 18             	mov    0x18(%edx),%edx
  800848:	85 d2                	test   %edx,%edx
  80084a:	74 32                	je     80087e <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80084c:	83 ec 08             	sub    $0x8,%esp
  80084f:	ff 75 0c             	pushl  0xc(%ebp)
  800852:	50                   	push   %eax
  800853:	ff d2                	call   *%edx
  800855:	83 c4 10             	add    $0x10,%esp
}
  800858:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80085b:	c9                   	leave  
  80085c:	c3                   	ret    
			thisenv->env_id, fdnum);
  80085d:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800862:	8b 40 48             	mov    0x48(%eax),%eax
  800865:	83 ec 04             	sub    $0x4,%esp
  800868:	53                   	push   %ebx
  800869:	50                   	push   %eax
  80086a:	68 18 24 80 00       	push   $0x802418
  80086f:	e8 6c 0d 00 00       	call   8015e0 <cprintf>
		return -E_INVAL;
  800874:	83 c4 10             	add    $0x10,%esp
  800877:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80087c:	eb da                	jmp    800858 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80087e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800883:	eb d3                	jmp    800858 <ftruncate+0x52>

00800885 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800885:	55                   	push   %ebp
  800886:	89 e5                	mov    %esp,%ebp
  800888:	53                   	push   %ebx
  800889:	83 ec 14             	sub    $0x14,%esp
  80088c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80088f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800892:	50                   	push   %eax
  800893:	ff 75 08             	pushl  0x8(%ebp)
  800896:	e8 81 fb ff ff       	call   80041c <fd_lookup>
  80089b:	83 c4 08             	add    $0x8,%esp
  80089e:	85 c0                	test   %eax,%eax
  8008a0:	78 4b                	js     8008ed <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8008a2:	83 ec 08             	sub    $0x8,%esp
  8008a5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8008a8:	50                   	push   %eax
  8008a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008ac:	ff 30                	pushl  (%eax)
  8008ae:	e8 bf fb ff ff       	call   800472 <dev_lookup>
  8008b3:	83 c4 10             	add    $0x10,%esp
  8008b6:	85 c0                	test   %eax,%eax
  8008b8:	78 33                	js     8008ed <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8008ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008bd:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8008c1:	74 2f                	je     8008f2 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8008c3:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8008c6:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8008cd:	00 00 00 
	stat->st_isdir = 0;
  8008d0:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8008d7:	00 00 00 
	stat->st_dev = dev;
  8008da:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8008e0:	83 ec 08             	sub    $0x8,%esp
  8008e3:	53                   	push   %ebx
  8008e4:	ff 75 f0             	pushl  -0x10(%ebp)
  8008e7:	ff 50 14             	call   *0x14(%eax)
  8008ea:	83 c4 10             	add    $0x10,%esp
}
  8008ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008f0:	c9                   	leave  
  8008f1:	c3                   	ret    
		return -E_NOT_SUPP;
  8008f2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8008f7:	eb f4                	jmp    8008ed <fstat+0x68>

008008f9 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8008f9:	55                   	push   %ebp
  8008fa:	89 e5                	mov    %esp,%ebp
  8008fc:	56                   	push   %esi
  8008fd:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8008fe:	83 ec 08             	sub    $0x8,%esp
  800901:	6a 00                	push   $0x0
  800903:	ff 75 08             	pushl  0x8(%ebp)
  800906:	e8 26 02 00 00       	call   800b31 <open>
  80090b:	89 c3                	mov    %eax,%ebx
  80090d:	83 c4 10             	add    $0x10,%esp
  800910:	85 c0                	test   %eax,%eax
  800912:	78 1b                	js     80092f <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  800914:	83 ec 08             	sub    $0x8,%esp
  800917:	ff 75 0c             	pushl  0xc(%ebp)
  80091a:	50                   	push   %eax
  80091b:	e8 65 ff ff ff       	call   800885 <fstat>
  800920:	89 c6                	mov    %eax,%esi
	close(fd);
  800922:	89 1c 24             	mov    %ebx,(%esp)
  800925:	e8 27 fc ff ff       	call   800551 <close>
	return r;
  80092a:	83 c4 10             	add    $0x10,%esp
  80092d:	89 f3                	mov    %esi,%ebx
}
  80092f:	89 d8                	mov    %ebx,%eax
  800931:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800934:	5b                   	pop    %ebx
  800935:	5e                   	pop    %esi
  800936:	5d                   	pop    %ebp
  800937:	c3                   	ret    

00800938 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800938:	55                   	push   %ebp
  800939:	89 e5                	mov    %esp,%ebp
  80093b:	56                   	push   %esi
  80093c:	53                   	push   %ebx
  80093d:	89 c6                	mov    %eax,%esi
  80093f:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  800941:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  800948:	74 27                	je     800971 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80094a:	6a 07                	push   $0x7
  80094c:	68 00 50 80 00       	push   $0x805000
  800951:	56                   	push   %esi
  800952:	ff 35 00 40 80 00    	pushl  0x804000
  800958:	e8 3f 17 00 00       	call   80209c <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80095d:	83 c4 0c             	add    $0xc,%esp
  800960:	6a 00                	push   $0x0
  800962:	53                   	push   %ebx
  800963:	6a 00                	push   $0x0
  800965:	e8 c9 16 00 00       	call   802033 <ipc_recv>
}
  80096a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80096d:	5b                   	pop    %ebx
  80096e:	5e                   	pop    %esi
  80096f:	5d                   	pop    %ebp
  800970:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800971:	83 ec 0c             	sub    $0xc,%esp
  800974:	6a 01                	push   $0x1
  800976:	e8 7a 17 00 00       	call   8020f5 <ipc_find_env>
  80097b:	a3 00 40 80 00       	mov    %eax,0x804000
  800980:	83 c4 10             	add    $0x10,%esp
  800983:	eb c5                	jmp    80094a <fsipc+0x12>

00800985 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  800985:	55                   	push   %ebp
  800986:	89 e5                	mov    %esp,%ebp
  800988:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80098b:	8b 45 08             	mov    0x8(%ebp),%eax
  80098e:	8b 40 0c             	mov    0xc(%eax),%eax
  800991:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  800996:	8b 45 0c             	mov    0xc(%ebp),%eax
  800999:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80099e:	ba 00 00 00 00       	mov    $0x0,%edx
  8009a3:	b8 02 00 00 00       	mov    $0x2,%eax
  8009a8:	e8 8b ff ff ff       	call   800938 <fsipc>
}
  8009ad:	c9                   	leave  
  8009ae:	c3                   	ret    

008009af <devfile_flush>:
{
  8009af:	55                   	push   %ebp
  8009b0:	89 e5                	mov    %esp,%ebp
  8009b2:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8009b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b8:	8b 40 0c             	mov    0xc(%eax),%eax
  8009bb:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8009c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8009c5:	b8 06 00 00 00       	mov    $0x6,%eax
  8009ca:	e8 69 ff ff ff       	call   800938 <fsipc>
}
  8009cf:	c9                   	leave  
  8009d0:	c3                   	ret    

008009d1 <devfile_stat>:
{
  8009d1:	55                   	push   %ebp
  8009d2:	89 e5                	mov    %esp,%ebp
  8009d4:	53                   	push   %ebx
  8009d5:	83 ec 04             	sub    $0x4,%esp
  8009d8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8009db:	8b 45 08             	mov    0x8(%ebp),%eax
  8009de:	8b 40 0c             	mov    0xc(%eax),%eax
  8009e1:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8009e6:	ba 00 00 00 00       	mov    $0x0,%edx
  8009eb:	b8 05 00 00 00       	mov    $0x5,%eax
  8009f0:	e8 43 ff ff ff       	call   800938 <fsipc>
  8009f5:	85 c0                	test   %eax,%eax
  8009f7:	78 2c                	js     800a25 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8009f9:	83 ec 08             	sub    $0x8,%esp
  8009fc:	68 00 50 80 00       	push   $0x805000
  800a01:	53                   	push   %ebx
  800a02:	e8 76 12 00 00       	call   801c7d <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800a07:	a1 80 50 80 00       	mov    0x805080,%eax
  800a0c:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800a12:	a1 84 50 80 00       	mov    0x805084,%eax
  800a17:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800a1d:	83 c4 10             	add    $0x10,%esp
  800a20:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a25:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a28:	c9                   	leave  
  800a29:	c3                   	ret    

00800a2a <devfile_write>:
{
  800a2a:	55                   	push   %ebp
  800a2b:	89 e5                	mov    %esp,%ebp
  800a2d:	53                   	push   %ebx
  800a2e:	83 ec 04             	sub    $0x4,%esp
  800a31:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  800a34:	8b 45 08             	mov    0x8(%ebp),%eax
  800a37:	8b 40 0c             	mov    0xc(%eax),%eax
  800a3a:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  800a3f:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  800a45:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  800a4b:	77 30                	ja     800a7d <devfile_write+0x53>
	memmove(fsipcbuf.write.req_buf, buf, n);
  800a4d:	83 ec 04             	sub    $0x4,%esp
  800a50:	53                   	push   %ebx
  800a51:	ff 75 0c             	pushl  0xc(%ebp)
  800a54:	68 08 50 80 00       	push   $0x805008
  800a59:	e8 ad 13 00 00       	call   801e0b <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  800a5e:	ba 00 00 00 00       	mov    $0x0,%edx
  800a63:	b8 04 00 00 00       	mov    $0x4,%eax
  800a68:	e8 cb fe ff ff       	call   800938 <fsipc>
  800a6d:	83 c4 10             	add    $0x10,%esp
  800a70:	85 c0                	test   %eax,%eax
  800a72:	78 04                	js     800a78 <devfile_write+0x4e>
	assert(r <= n);
  800a74:	39 d8                	cmp    %ebx,%eax
  800a76:	77 1e                	ja     800a96 <devfile_write+0x6c>
}
  800a78:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a7b:	c9                   	leave  
  800a7c:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  800a7d:	68 88 24 80 00       	push   $0x802488
  800a82:	68 b5 24 80 00       	push   $0x8024b5
  800a87:	68 94 00 00 00       	push   $0x94
  800a8c:	68 ca 24 80 00       	push   $0x8024ca
  800a91:	e8 6f 0a 00 00       	call   801505 <_panic>
	assert(r <= n);
  800a96:	68 d5 24 80 00       	push   $0x8024d5
  800a9b:	68 b5 24 80 00       	push   $0x8024b5
  800aa0:	68 98 00 00 00       	push   $0x98
  800aa5:	68 ca 24 80 00       	push   $0x8024ca
  800aaa:	e8 56 0a 00 00       	call   801505 <_panic>

00800aaf <devfile_read>:
{
  800aaf:	55                   	push   %ebp
  800ab0:	89 e5                	mov    %esp,%ebp
  800ab2:	56                   	push   %esi
  800ab3:	53                   	push   %ebx
  800ab4:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800ab7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aba:	8b 40 0c             	mov    0xc(%eax),%eax
  800abd:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800ac2:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800ac8:	ba 00 00 00 00       	mov    $0x0,%edx
  800acd:	b8 03 00 00 00       	mov    $0x3,%eax
  800ad2:	e8 61 fe ff ff       	call   800938 <fsipc>
  800ad7:	89 c3                	mov    %eax,%ebx
  800ad9:	85 c0                	test   %eax,%eax
  800adb:	78 1f                	js     800afc <devfile_read+0x4d>
	assert(r <= n);
  800add:	39 f0                	cmp    %esi,%eax
  800adf:	77 24                	ja     800b05 <devfile_read+0x56>
	assert(r <= PGSIZE);
  800ae1:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800ae6:	7f 33                	jg     800b1b <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800ae8:	83 ec 04             	sub    $0x4,%esp
  800aeb:	50                   	push   %eax
  800aec:	68 00 50 80 00       	push   $0x805000
  800af1:	ff 75 0c             	pushl  0xc(%ebp)
  800af4:	e8 12 13 00 00       	call   801e0b <memmove>
	return r;
  800af9:	83 c4 10             	add    $0x10,%esp
}
  800afc:	89 d8                	mov    %ebx,%eax
  800afe:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b01:	5b                   	pop    %ebx
  800b02:	5e                   	pop    %esi
  800b03:	5d                   	pop    %ebp
  800b04:	c3                   	ret    
	assert(r <= n);
  800b05:	68 d5 24 80 00       	push   $0x8024d5
  800b0a:	68 b5 24 80 00       	push   $0x8024b5
  800b0f:	6a 7c                	push   $0x7c
  800b11:	68 ca 24 80 00       	push   $0x8024ca
  800b16:	e8 ea 09 00 00       	call   801505 <_panic>
	assert(r <= PGSIZE);
  800b1b:	68 dc 24 80 00       	push   $0x8024dc
  800b20:	68 b5 24 80 00       	push   $0x8024b5
  800b25:	6a 7d                	push   $0x7d
  800b27:	68 ca 24 80 00       	push   $0x8024ca
  800b2c:	e8 d4 09 00 00       	call   801505 <_panic>

00800b31 <open>:
{
  800b31:	55                   	push   %ebp
  800b32:	89 e5                	mov    %esp,%ebp
  800b34:	56                   	push   %esi
  800b35:	53                   	push   %ebx
  800b36:	83 ec 1c             	sub    $0x1c,%esp
  800b39:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800b3c:	56                   	push   %esi
  800b3d:	e8 04 11 00 00       	call   801c46 <strlen>
  800b42:	83 c4 10             	add    $0x10,%esp
  800b45:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800b4a:	7f 6c                	jg     800bb8 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  800b4c:	83 ec 0c             	sub    $0xc,%esp
  800b4f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800b52:	50                   	push   %eax
  800b53:	e8 75 f8 ff ff       	call   8003cd <fd_alloc>
  800b58:	89 c3                	mov    %eax,%ebx
  800b5a:	83 c4 10             	add    $0x10,%esp
  800b5d:	85 c0                	test   %eax,%eax
  800b5f:	78 3c                	js     800b9d <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  800b61:	83 ec 08             	sub    $0x8,%esp
  800b64:	56                   	push   %esi
  800b65:	68 00 50 80 00       	push   $0x805000
  800b6a:	e8 0e 11 00 00       	call   801c7d <strcpy>
	fsipcbuf.open.req_omode = mode;
  800b6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b72:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800b77:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b7a:	b8 01 00 00 00       	mov    $0x1,%eax
  800b7f:	e8 b4 fd ff ff       	call   800938 <fsipc>
  800b84:	89 c3                	mov    %eax,%ebx
  800b86:	83 c4 10             	add    $0x10,%esp
  800b89:	85 c0                	test   %eax,%eax
  800b8b:	78 19                	js     800ba6 <open+0x75>
	return fd2num(fd);
  800b8d:	83 ec 0c             	sub    $0xc,%esp
  800b90:	ff 75 f4             	pushl  -0xc(%ebp)
  800b93:	e8 0e f8 ff ff       	call   8003a6 <fd2num>
  800b98:	89 c3                	mov    %eax,%ebx
  800b9a:	83 c4 10             	add    $0x10,%esp
}
  800b9d:	89 d8                	mov    %ebx,%eax
  800b9f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ba2:	5b                   	pop    %ebx
  800ba3:	5e                   	pop    %esi
  800ba4:	5d                   	pop    %ebp
  800ba5:	c3                   	ret    
		fd_close(fd, 0);
  800ba6:	83 ec 08             	sub    $0x8,%esp
  800ba9:	6a 00                	push   $0x0
  800bab:	ff 75 f4             	pushl  -0xc(%ebp)
  800bae:	e8 15 f9 ff ff       	call   8004c8 <fd_close>
		return r;
  800bb3:	83 c4 10             	add    $0x10,%esp
  800bb6:	eb e5                	jmp    800b9d <open+0x6c>
		return -E_BAD_PATH;
  800bb8:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800bbd:	eb de                	jmp    800b9d <open+0x6c>

00800bbf <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800bbf:	55                   	push   %ebp
  800bc0:	89 e5                	mov    %esp,%ebp
  800bc2:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800bc5:	ba 00 00 00 00       	mov    $0x0,%edx
  800bca:	b8 08 00 00 00       	mov    $0x8,%eax
  800bcf:	e8 64 fd ff ff       	call   800938 <fsipc>
}
  800bd4:	c9                   	leave  
  800bd5:	c3                   	ret    

00800bd6 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800bd6:	55                   	push   %ebp
  800bd7:	89 e5                	mov    %esp,%ebp
  800bd9:	56                   	push   %esi
  800bda:	53                   	push   %ebx
  800bdb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800bde:	83 ec 0c             	sub    $0xc,%esp
  800be1:	ff 75 08             	pushl  0x8(%ebp)
  800be4:	e8 cd f7 ff ff       	call   8003b6 <fd2data>
  800be9:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  800beb:	83 c4 08             	add    $0x8,%esp
  800bee:	68 e8 24 80 00       	push   $0x8024e8
  800bf3:	53                   	push   %ebx
  800bf4:	e8 84 10 00 00       	call   801c7d <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  800bf9:	8b 46 04             	mov    0x4(%esi),%eax
  800bfc:	2b 06                	sub    (%esi),%eax
  800bfe:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  800c04:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800c0b:	00 00 00 
	stat->st_dev = &devpipe;
  800c0e:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  800c15:	30 80 00 
	return 0;
}
  800c18:	b8 00 00 00 00       	mov    $0x0,%eax
  800c1d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c20:	5b                   	pop    %ebx
  800c21:	5e                   	pop    %esi
  800c22:	5d                   	pop    %ebp
  800c23:	c3                   	ret    

00800c24 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  800c24:	55                   	push   %ebp
  800c25:	89 e5                	mov    %esp,%ebp
  800c27:	53                   	push   %ebx
  800c28:	83 ec 0c             	sub    $0xc,%esp
  800c2b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  800c2e:	53                   	push   %ebx
  800c2f:	6a 00                	push   $0x0
  800c31:	e8 bf f5 ff ff       	call   8001f5 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  800c36:	89 1c 24             	mov    %ebx,(%esp)
  800c39:	e8 78 f7 ff ff       	call   8003b6 <fd2data>
  800c3e:	83 c4 08             	add    $0x8,%esp
  800c41:	50                   	push   %eax
  800c42:	6a 00                	push   $0x0
  800c44:	e8 ac f5 ff ff       	call   8001f5 <sys_page_unmap>
}
  800c49:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c4c:	c9                   	leave  
  800c4d:	c3                   	ret    

00800c4e <_pipeisclosed>:
{
  800c4e:	55                   	push   %ebp
  800c4f:	89 e5                	mov    %esp,%ebp
  800c51:	57                   	push   %edi
  800c52:	56                   	push   %esi
  800c53:	53                   	push   %ebx
  800c54:	83 ec 1c             	sub    $0x1c,%esp
  800c57:	89 c7                	mov    %eax,%edi
  800c59:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  800c5b:	a1 08 40 80 00       	mov    0x804008,%eax
  800c60:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  800c63:	83 ec 0c             	sub    $0xc,%esp
  800c66:	57                   	push   %edi
  800c67:	e8 c2 14 00 00       	call   80212e <pageref>
  800c6c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c6f:	89 34 24             	mov    %esi,(%esp)
  800c72:	e8 b7 14 00 00       	call   80212e <pageref>
		nn = thisenv->env_runs;
  800c77:	8b 15 08 40 80 00    	mov    0x804008,%edx
  800c7d:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  800c80:	83 c4 10             	add    $0x10,%esp
  800c83:	39 cb                	cmp    %ecx,%ebx
  800c85:	74 1b                	je     800ca2 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  800c87:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800c8a:	75 cf                	jne    800c5b <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  800c8c:	8b 42 58             	mov    0x58(%edx),%eax
  800c8f:	6a 01                	push   $0x1
  800c91:	50                   	push   %eax
  800c92:	53                   	push   %ebx
  800c93:	68 ef 24 80 00       	push   $0x8024ef
  800c98:	e8 43 09 00 00       	call   8015e0 <cprintf>
  800c9d:	83 c4 10             	add    $0x10,%esp
  800ca0:	eb b9                	jmp    800c5b <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  800ca2:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800ca5:	0f 94 c0             	sete   %al
  800ca8:	0f b6 c0             	movzbl %al,%eax
}
  800cab:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cae:	5b                   	pop    %ebx
  800caf:	5e                   	pop    %esi
  800cb0:	5f                   	pop    %edi
  800cb1:	5d                   	pop    %ebp
  800cb2:	c3                   	ret    

00800cb3 <devpipe_write>:
{
  800cb3:	55                   	push   %ebp
  800cb4:	89 e5                	mov    %esp,%ebp
  800cb6:	57                   	push   %edi
  800cb7:	56                   	push   %esi
  800cb8:	53                   	push   %ebx
  800cb9:	83 ec 28             	sub    $0x28,%esp
  800cbc:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  800cbf:	56                   	push   %esi
  800cc0:	e8 f1 f6 ff ff       	call   8003b6 <fd2data>
  800cc5:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800cc7:	83 c4 10             	add    $0x10,%esp
  800cca:	bf 00 00 00 00       	mov    $0x0,%edi
  800ccf:	3b 7d 10             	cmp    0x10(%ebp),%edi
  800cd2:	74 4f                	je     800d23 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  800cd4:	8b 43 04             	mov    0x4(%ebx),%eax
  800cd7:	8b 0b                	mov    (%ebx),%ecx
  800cd9:	8d 51 20             	lea    0x20(%ecx),%edx
  800cdc:	39 d0                	cmp    %edx,%eax
  800cde:	72 14                	jb     800cf4 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  800ce0:	89 da                	mov    %ebx,%edx
  800ce2:	89 f0                	mov    %esi,%eax
  800ce4:	e8 65 ff ff ff       	call   800c4e <_pipeisclosed>
  800ce9:	85 c0                	test   %eax,%eax
  800ceb:	75 3a                	jne    800d27 <devpipe_write+0x74>
			sys_yield();
  800ced:	e8 5f f4 ff ff       	call   800151 <sys_yield>
  800cf2:	eb e0                	jmp    800cd4 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  800cf4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cf7:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  800cfb:	88 4d e7             	mov    %cl,-0x19(%ebp)
  800cfe:	89 c2                	mov    %eax,%edx
  800d00:	c1 fa 1f             	sar    $0x1f,%edx
  800d03:	89 d1                	mov    %edx,%ecx
  800d05:	c1 e9 1b             	shr    $0x1b,%ecx
  800d08:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  800d0b:	83 e2 1f             	and    $0x1f,%edx
  800d0e:	29 ca                	sub    %ecx,%edx
  800d10:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  800d14:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  800d18:	83 c0 01             	add    $0x1,%eax
  800d1b:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  800d1e:	83 c7 01             	add    $0x1,%edi
  800d21:	eb ac                	jmp    800ccf <devpipe_write+0x1c>
	return i;
  800d23:	89 f8                	mov    %edi,%eax
  800d25:	eb 05                	jmp    800d2c <devpipe_write+0x79>
				return 0;
  800d27:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d2f:	5b                   	pop    %ebx
  800d30:	5e                   	pop    %esi
  800d31:	5f                   	pop    %edi
  800d32:	5d                   	pop    %ebp
  800d33:	c3                   	ret    

00800d34 <devpipe_read>:
{
  800d34:	55                   	push   %ebp
  800d35:	89 e5                	mov    %esp,%ebp
  800d37:	57                   	push   %edi
  800d38:	56                   	push   %esi
  800d39:	53                   	push   %ebx
  800d3a:	83 ec 18             	sub    $0x18,%esp
  800d3d:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  800d40:	57                   	push   %edi
  800d41:	e8 70 f6 ff ff       	call   8003b6 <fd2data>
  800d46:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800d48:	83 c4 10             	add    $0x10,%esp
  800d4b:	be 00 00 00 00       	mov    $0x0,%esi
  800d50:	3b 75 10             	cmp    0x10(%ebp),%esi
  800d53:	74 47                	je     800d9c <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  800d55:	8b 03                	mov    (%ebx),%eax
  800d57:	3b 43 04             	cmp    0x4(%ebx),%eax
  800d5a:	75 22                	jne    800d7e <devpipe_read+0x4a>
			if (i > 0)
  800d5c:	85 f6                	test   %esi,%esi
  800d5e:	75 14                	jne    800d74 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  800d60:	89 da                	mov    %ebx,%edx
  800d62:	89 f8                	mov    %edi,%eax
  800d64:	e8 e5 fe ff ff       	call   800c4e <_pipeisclosed>
  800d69:	85 c0                	test   %eax,%eax
  800d6b:	75 33                	jne    800da0 <devpipe_read+0x6c>
			sys_yield();
  800d6d:	e8 df f3 ff ff       	call   800151 <sys_yield>
  800d72:	eb e1                	jmp    800d55 <devpipe_read+0x21>
				return i;
  800d74:	89 f0                	mov    %esi,%eax
}
  800d76:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d79:	5b                   	pop    %ebx
  800d7a:	5e                   	pop    %esi
  800d7b:	5f                   	pop    %edi
  800d7c:	5d                   	pop    %ebp
  800d7d:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  800d7e:	99                   	cltd   
  800d7f:	c1 ea 1b             	shr    $0x1b,%edx
  800d82:	01 d0                	add    %edx,%eax
  800d84:	83 e0 1f             	and    $0x1f,%eax
  800d87:	29 d0                	sub    %edx,%eax
  800d89:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  800d8e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d91:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  800d94:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  800d97:	83 c6 01             	add    $0x1,%esi
  800d9a:	eb b4                	jmp    800d50 <devpipe_read+0x1c>
	return i;
  800d9c:	89 f0                	mov    %esi,%eax
  800d9e:	eb d6                	jmp    800d76 <devpipe_read+0x42>
				return 0;
  800da0:	b8 00 00 00 00       	mov    $0x0,%eax
  800da5:	eb cf                	jmp    800d76 <devpipe_read+0x42>

00800da7 <pipe>:
{
  800da7:	55                   	push   %ebp
  800da8:	89 e5                	mov    %esp,%ebp
  800daa:	56                   	push   %esi
  800dab:	53                   	push   %ebx
  800dac:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  800daf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800db2:	50                   	push   %eax
  800db3:	e8 15 f6 ff ff       	call   8003cd <fd_alloc>
  800db8:	89 c3                	mov    %eax,%ebx
  800dba:	83 c4 10             	add    $0x10,%esp
  800dbd:	85 c0                	test   %eax,%eax
  800dbf:	78 5b                	js     800e1c <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800dc1:	83 ec 04             	sub    $0x4,%esp
  800dc4:	68 07 04 00 00       	push   $0x407
  800dc9:	ff 75 f4             	pushl  -0xc(%ebp)
  800dcc:	6a 00                	push   $0x0
  800dce:	e8 9d f3 ff ff       	call   800170 <sys_page_alloc>
  800dd3:	89 c3                	mov    %eax,%ebx
  800dd5:	83 c4 10             	add    $0x10,%esp
  800dd8:	85 c0                	test   %eax,%eax
  800dda:	78 40                	js     800e1c <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  800ddc:	83 ec 0c             	sub    $0xc,%esp
  800ddf:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800de2:	50                   	push   %eax
  800de3:	e8 e5 f5 ff ff       	call   8003cd <fd_alloc>
  800de8:	89 c3                	mov    %eax,%ebx
  800dea:	83 c4 10             	add    $0x10,%esp
  800ded:	85 c0                	test   %eax,%eax
  800def:	78 1b                	js     800e0c <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800df1:	83 ec 04             	sub    $0x4,%esp
  800df4:	68 07 04 00 00       	push   $0x407
  800df9:	ff 75 f0             	pushl  -0x10(%ebp)
  800dfc:	6a 00                	push   $0x0
  800dfe:	e8 6d f3 ff ff       	call   800170 <sys_page_alloc>
  800e03:	89 c3                	mov    %eax,%ebx
  800e05:	83 c4 10             	add    $0x10,%esp
  800e08:	85 c0                	test   %eax,%eax
  800e0a:	79 19                	jns    800e25 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  800e0c:	83 ec 08             	sub    $0x8,%esp
  800e0f:	ff 75 f4             	pushl  -0xc(%ebp)
  800e12:	6a 00                	push   $0x0
  800e14:	e8 dc f3 ff ff       	call   8001f5 <sys_page_unmap>
  800e19:	83 c4 10             	add    $0x10,%esp
}
  800e1c:	89 d8                	mov    %ebx,%eax
  800e1e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800e21:	5b                   	pop    %ebx
  800e22:	5e                   	pop    %esi
  800e23:	5d                   	pop    %ebp
  800e24:	c3                   	ret    
	va = fd2data(fd0);
  800e25:	83 ec 0c             	sub    $0xc,%esp
  800e28:	ff 75 f4             	pushl  -0xc(%ebp)
  800e2b:	e8 86 f5 ff ff       	call   8003b6 <fd2data>
  800e30:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e32:	83 c4 0c             	add    $0xc,%esp
  800e35:	68 07 04 00 00       	push   $0x407
  800e3a:	50                   	push   %eax
  800e3b:	6a 00                	push   $0x0
  800e3d:	e8 2e f3 ff ff       	call   800170 <sys_page_alloc>
  800e42:	89 c3                	mov    %eax,%ebx
  800e44:	83 c4 10             	add    $0x10,%esp
  800e47:	85 c0                	test   %eax,%eax
  800e49:	0f 88 8c 00 00 00    	js     800edb <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e4f:	83 ec 0c             	sub    $0xc,%esp
  800e52:	ff 75 f0             	pushl  -0x10(%ebp)
  800e55:	e8 5c f5 ff ff       	call   8003b6 <fd2data>
  800e5a:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  800e61:	50                   	push   %eax
  800e62:	6a 00                	push   $0x0
  800e64:	56                   	push   %esi
  800e65:	6a 00                	push   $0x0
  800e67:	e8 47 f3 ff ff       	call   8001b3 <sys_page_map>
  800e6c:	89 c3                	mov    %eax,%ebx
  800e6e:	83 c4 20             	add    $0x20,%esp
  800e71:	85 c0                	test   %eax,%eax
  800e73:	78 58                	js     800ecd <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  800e75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e78:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800e7e:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  800e80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e83:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  800e8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e8d:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800e93:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  800e95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e98:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  800e9f:	83 ec 0c             	sub    $0xc,%esp
  800ea2:	ff 75 f4             	pushl  -0xc(%ebp)
  800ea5:	e8 fc f4 ff ff       	call   8003a6 <fd2num>
  800eaa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ead:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  800eaf:	83 c4 04             	add    $0x4,%esp
  800eb2:	ff 75 f0             	pushl  -0x10(%ebp)
  800eb5:	e8 ec f4 ff ff       	call   8003a6 <fd2num>
  800eba:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ebd:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  800ec0:	83 c4 10             	add    $0x10,%esp
  800ec3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ec8:	e9 4f ff ff ff       	jmp    800e1c <pipe+0x75>
	sys_page_unmap(0, va);
  800ecd:	83 ec 08             	sub    $0x8,%esp
  800ed0:	56                   	push   %esi
  800ed1:	6a 00                	push   $0x0
  800ed3:	e8 1d f3 ff ff       	call   8001f5 <sys_page_unmap>
  800ed8:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  800edb:	83 ec 08             	sub    $0x8,%esp
  800ede:	ff 75 f0             	pushl  -0x10(%ebp)
  800ee1:	6a 00                	push   $0x0
  800ee3:	e8 0d f3 ff ff       	call   8001f5 <sys_page_unmap>
  800ee8:	83 c4 10             	add    $0x10,%esp
  800eeb:	e9 1c ff ff ff       	jmp    800e0c <pipe+0x65>

00800ef0 <pipeisclosed>:
{
  800ef0:	55                   	push   %ebp
  800ef1:	89 e5                	mov    %esp,%ebp
  800ef3:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800ef6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800ef9:	50                   	push   %eax
  800efa:	ff 75 08             	pushl  0x8(%ebp)
  800efd:	e8 1a f5 ff ff       	call   80041c <fd_lookup>
  800f02:	83 c4 10             	add    $0x10,%esp
  800f05:	85 c0                	test   %eax,%eax
  800f07:	78 18                	js     800f21 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  800f09:	83 ec 0c             	sub    $0xc,%esp
  800f0c:	ff 75 f4             	pushl  -0xc(%ebp)
  800f0f:	e8 a2 f4 ff ff       	call   8003b6 <fd2data>
	return _pipeisclosed(fd, p);
  800f14:	89 c2                	mov    %eax,%edx
  800f16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f19:	e8 30 fd ff ff       	call   800c4e <_pipeisclosed>
  800f1e:	83 c4 10             	add    $0x10,%esp
}
  800f21:	c9                   	leave  
  800f22:	c3                   	ret    

00800f23 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  800f23:	55                   	push   %ebp
  800f24:	89 e5                	mov    %esp,%ebp
  800f26:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  800f29:	68 07 25 80 00       	push   $0x802507
  800f2e:	ff 75 0c             	pushl  0xc(%ebp)
  800f31:	e8 47 0d 00 00       	call   801c7d <strcpy>
	return 0;
}
  800f36:	b8 00 00 00 00       	mov    $0x0,%eax
  800f3b:	c9                   	leave  
  800f3c:	c3                   	ret    

00800f3d <devsock_close>:
{
  800f3d:	55                   	push   %ebp
  800f3e:	89 e5                	mov    %esp,%ebp
  800f40:	53                   	push   %ebx
  800f41:	83 ec 10             	sub    $0x10,%esp
  800f44:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  800f47:	53                   	push   %ebx
  800f48:	e8 e1 11 00 00       	call   80212e <pageref>
  800f4d:	83 c4 10             	add    $0x10,%esp
		return 0;
  800f50:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  800f55:	83 f8 01             	cmp    $0x1,%eax
  800f58:	74 07                	je     800f61 <devsock_close+0x24>
}
  800f5a:	89 d0                	mov    %edx,%eax
  800f5c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f5f:	c9                   	leave  
  800f60:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  800f61:	83 ec 0c             	sub    $0xc,%esp
  800f64:	ff 73 0c             	pushl  0xc(%ebx)
  800f67:	e8 b7 02 00 00       	call   801223 <nsipc_close>
  800f6c:	89 c2                	mov    %eax,%edx
  800f6e:	83 c4 10             	add    $0x10,%esp
  800f71:	eb e7                	jmp    800f5a <devsock_close+0x1d>

00800f73 <devsock_write>:
{
  800f73:	55                   	push   %ebp
  800f74:	89 e5                	mov    %esp,%ebp
  800f76:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  800f79:	6a 00                	push   $0x0
  800f7b:	ff 75 10             	pushl  0x10(%ebp)
  800f7e:	ff 75 0c             	pushl  0xc(%ebp)
  800f81:	8b 45 08             	mov    0x8(%ebp),%eax
  800f84:	ff 70 0c             	pushl  0xc(%eax)
  800f87:	e8 74 03 00 00       	call   801300 <nsipc_send>
}
  800f8c:	c9                   	leave  
  800f8d:	c3                   	ret    

00800f8e <devsock_read>:
{
  800f8e:	55                   	push   %ebp
  800f8f:	89 e5                	mov    %esp,%ebp
  800f91:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  800f94:	6a 00                	push   $0x0
  800f96:	ff 75 10             	pushl  0x10(%ebp)
  800f99:	ff 75 0c             	pushl  0xc(%ebp)
  800f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9f:	ff 70 0c             	pushl  0xc(%eax)
  800fa2:	e8 ed 02 00 00       	call   801294 <nsipc_recv>
}
  800fa7:	c9                   	leave  
  800fa8:	c3                   	ret    

00800fa9 <fd2sockid>:
{
  800fa9:	55                   	push   %ebp
  800faa:	89 e5                	mov    %esp,%ebp
  800fac:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  800faf:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800fb2:	52                   	push   %edx
  800fb3:	50                   	push   %eax
  800fb4:	e8 63 f4 ff ff       	call   80041c <fd_lookup>
  800fb9:	83 c4 10             	add    $0x10,%esp
  800fbc:	85 c0                	test   %eax,%eax
  800fbe:	78 10                	js     800fd0 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  800fc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fc3:	8b 0d 3c 30 80 00    	mov    0x80303c,%ecx
  800fc9:	39 08                	cmp    %ecx,(%eax)
  800fcb:	75 05                	jne    800fd2 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  800fcd:	8b 40 0c             	mov    0xc(%eax),%eax
}
  800fd0:	c9                   	leave  
  800fd1:	c3                   	ret    
		return -E_NOT_SUPP;
  800fd2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800fd7:	eb f7                	jmp    800fd0 <fd2sockid+0x27>

00800fd9 <alloc_sockfd>:
{
  800fd9:	55                   	push   %ebp
  800fda:	89 e5                	mov    %esp,%ebp
  800fdc:	56                   	push   %esi
  800fdd:	53                   	push   %ebx
  800fde:	83 ec 1c             	sub    $0x1c,%esp
  800fe1:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  800fe3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800fe6:	50                   	push   %eax
  800fe7:	e8 e1 f3 ff ff       	call   8003cd <fd_alloc>
  800fec:	89 c3                	mov    %eax,%ebx
  800fee:	83 c4 10             	add    $0x10,%esp
  800ff1:	85 c0                	test   %eax,%eax
  800ff3:	78 43                	js     801038 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  800ff5:	83 ec 04             	sub    $0x4,%esp
  800ff8:	68 07 04 00 00       	push   $0x407
  800ffd:	ff 75 f4             	pushl  -0xc(%ebp)
  801000:	6a 00                	push   $0x0
  801002:	e8 69 f1 ff ff       	call   800170 <sys_page_alloc>
  801007:	89 c3                	mov    %eax,%ebx
  801009:	83 c4 10             	add    $0x10,%esp
  80100c:	85 c0                	test   %eax,%eax
  80100e:	78 28                	js     801038 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801010:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801013:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801019:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80101b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80101e:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801025:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801028:	83 ec 0c             	sub    $0xc,%esp
  80102b:	50                   	push   %eax
  80102c:	e8 75 f3 ff ff       	call   8003a6 <fd2num>
  801031:	89 c3                	mov    %eax,%ebx
  801033:	83 c4 10             	add    $0x10,%esp
  801036:	eb 0c                	jmp    801044 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801038:	83 ec 0c             	sub    $0xc,%esp
  80103b:	56                   	push   %esi
  80103c:	e8 e2 01 00 00       	call   801223 <nsipc_close>
		return r;
  801041:	83 c4 10             	add    $0x10,%esp
}
  801044:	89 d8                	mov    %ebx,%eax
  801046:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801049:	5b                   	pop    %ebx
  80104a:	5e                   	pop    %esi
  80104b:	5d                   	pop    %ebp
  80104c:	c3                   	ret    

0080104d <accept>:
{
  80104d:	55                   	push   %ebp
  80104e:	89 e5                	mov    %esp,%ebp
  801050:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801053:	8b 45 08             	mov    0x8(%ebp),%eax
  801056:	e8 4e ff ff ff       	call   800fa9 <fd2sockid>
  80105b:	85 c0                	test   %eax,%eax
  80105d:	78 1b                	js     80107a <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80105f:	83 ec 04             	sub    $0x4,%esp
  801062:	ff 75 10             	pushl  0x10(%ebp)
  801065:	ff 75 0c             	pushl  0xc(%ebp)
  801068:	50                   	push   %eax
  801069:	e8 0e 01 00 00       	call   80117c <nsipc_accept>
  80106e:	83 c4 10             	add    $0x10,%esp
  801071:	85 c0                	test   %eax,%eax
  801073:	78 05                	js     80107a <accept+0x2d>
	return alloc_sockfd(r);
  801075:	e8 5f ff ff ff       	call   800fd9 <alloc_sockfd>
}
  80107a:	c9                   	leave  
  80107b:	c3                   	ret    

0080107c <bind>:
{
  80107c:	55                   	push   %ebp
  80107d:	89 e5                	mov    %esp,%ebp
  80107f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801082:	8b 45 08             	mov    0x8(%ebp),%eax
  801085:	e8 1f ff ff ff       	call   800fa9 <fd2sockid>
  80108a:	85 c0                	test   %eax,%eax
  80108c:	78 12                	js     8010a0 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  80108e:	83 ec 04             	sub    $0x4,%esp
  801091:	ff 75 10             	pushl  0x10(%ebp)
  801094:	ff 75 0c             	pushl  0xc(%ebp)
  801097:	50                   	push   %eax
  801098:	e8 2f 01 00 00       	call   8011cc <nsipc_bind>
  80109d:	83 c4 10             	add    $0x10,%esp
}
  8010a0:	c9                   	leave  
  8010a1:	c3                   	ret    

008010a2 <shutdown>:
{
  8010a2:	55                   	push   %ebp
  8010a3:	89 e5                	mov    %esp,%ebp
  8010a5:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8010a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ab:	e8 f9 fe ff ff       	call   800fa9 <fd2sockid>
  8010b0:	85 c0                	test   %eax,%eax
  8010b2:	78 0f                	js     8010c3 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  8010b4:	83 ec 08             	sub    $0x8,%esp
  8010b7:	ff 75 0c             	pushl  0xc(%ebp)
  8010ba:	50                   	push   %eax
  8010bb:	e8 41 01 00 00       	call   801201 <nsipc_shutdown>
  8010c0:	83 c4 10             	add    $0x10,%esp
}
  8010c3:	c9                   	leave  
  8010c4:	c3                   	ret    

008010c5 <connect>:
{
  8010c5:	55                   	push   %ebp
  8010c6:	89 e5                	mov    %esp,%ebp
  8010c8:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8010cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ce:	e8 d6 fe ff ff       	call   800fa9 <fd2sockid>
  8010d3:	85 c0                	test   %eax,%eax
  8010d5:	78 12                	js     8010e9 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8010d7:	83 ec 04             	sub    $0x4,%esp
  8010da:	ff 75 10             	pushl  0x10(%ebp)
  8010dd:	ff 75 0c             	pushl  0xc(%ebp)
  8010e0:	50                   	push   %eax
  8010e1:	e8 57 01 00 00       	call   80123d <nsipc_connect>
  8010e6:	83 c4 10             	add    $0x10,%esp
}
  8010e9:	c9                   	leave  
  8010ea:	c3                   	ret    

008010eb <listen>:
{
  8010eb:	55                   	push   %ebp
  8010ec:	89 e5                	mov    %esp,%ebp
  8010ee:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8010f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f4:	e8 b0 fe ff ff       	call   800fa9 <fd2sockid>
  8010f9:	85 c0                	test   %eax,%eax
  8010fb:	78 0f                	js     80110c <listen+0x21>
	return nsipc_listen(r, backlog);
  8010fd:	83 ec 08             	sub    $0x8,%esp
  801100:	ff 75 0c             	pushl  0xc(%ebp)
  801103:	50                   	push   %eax
  801104:	e8 69 01 00 00       	call   801272 <nsipc_listen>
  801109:	83 c4 10             	add    $0x10,%esp
}
  80110c:	c9                   	leave  
  80110d:	c3                   	ret    

0080110e <socket>:

int
socket(int domain, int type, int protocol)
{
  80110e:	55                   	push   %ebp
  80110f:	89 e5                	mov    %esp,%ebp
  801111:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801114:	ff 75 10             	pushl  0x10(%ebp)
  801117:	ff 75 0c             	pushl  0xc(%ebp)
  80111a:	ff 75 08             	pushl  0x8(%ebp)
  80111d:	e8 3c 02 00 00       	call   80135e <nsipc_socket>
  801122:	83 c4 10             	add    $0x10,%esp
  801125:	85 c0                	test   %eax,%eax
  801127:	78 05                	js     80112e <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801129:	e8 ab fe ff ff       	call   800fd9 <alloc_sockfd>
}
  80112e:	c9                   	leave  
  80112f:	c3                   	ret    

00801130 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801130:	55                   	push   %ebp
  801131:	89 e5                	mov    %esp,%ebp
  801133:	53                   	push   %ebx
  801134:	83 ec 04             	sub    $0x4,%esp
  801137:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801139:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801140:	74 26                	je     801168 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801142:	6a 07                	push   $0x7
  801144:	68 00 60 80 00       	push   $0x806000
  801149:	53                   	push   %ebx
  80114a:	ff 35 04 40 80 00    	pushl  0x804004
  801150:	e8 47 0f 00 00       	call   80209c <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801155:	83 c4 0c             	add    $0xc,%esp
  801158:	6a 00                	push   $0x0
  80115a:	6a 00                	push   $0x0
  80115c:	6a 00                	push   $0x0
  80115e:	e8 d0 0e 00 00       	call   802033 <ipc_recv>
}
  801163:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801166:	c9                   	leave  
  801167:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801168:	83 ec 0c             	sub    $0xc,%esp
  80116b:	6a 02                	push   $0x2
  80116d:	e8 83 0f 00 00       	call   8020f5 <ipc_find_env>
  801172:	a3 04 40 80 00       	mov    %eax,0x804004
  801177:	83 c4 10             	add    $0x10,%esp
  80117a:	eb c6                	jmp    801142 <nsipc+0x12>

0080117c <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80117c:	55                   	push   %ebp
  80117d:	89 e5                	mov    %esp,%ebp
  80117f:	56                   	push   %esi
  801180:	53                   	push   %ebx
  801181:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801184:	8b 45 08             	mov    0x8(%ebp),%eax
  801187:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80118c:	8b 06                	mov    (%esi),%eax
  80118e:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801193:	b8 01 00 00 00       	mov    $0x1,%eax
  801198:	e8 93 ff ff ff       	call   801130 <nsipc>
  80119d:	89 c3                	mov    %eax,%ebx
  80119f:	85 c0                	test   %eax,%eax
  8011a1:	78 20                	js     8011c3 <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8011a3:	83 ec 04             	sub    $0x4,%esp
  8011a6:	ff 35 10 60 80 00    	pushl  0x806010
  8011ac:	68 00 60 80 00       	push   $0x806000
  8011b1:	ff 75 0c             	pushl  0xc(%ebp)
  8011b4:	e8 52 0c 00 00       	call   801e0b <memmove>
		*addrlen = ret->ret_addrlen;
  8011b9:	a1 10 60 80 00       	mov    0x806010,%eax
  8011be:	89 06                	mov    %eax,(%esi)
  8011c0:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  8011c3:	89 d8                	mov    %ebx,%eax
  8011c5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8011c8:	5b                   	pop    %ebx
  8011c9:	5e                   	pop    %esi
  8011ca:	5d                   	pop    %ebp
  8011cb:	c3                   	ret    

008011cc <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8011cc:	55                   	push   %ebp
  8011cd:	89 e5                	mov    %esp,%ebp
  8011cf:	53                   	push   %ebx
  8011d0:	83 ec 08             	sub    $0x8,%esp
  8011d3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8011d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d9:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8011de:	53                   	push   %ebx
  8011df:	ff 75 0c             	pushl  0xc(%ebp)
  8011e2:	68 04 60 80 00       	push   $0x806004
  8011e7:	e8 1f 0c 00 00       	call   801e0b <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8011ec:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  8011f2:	b8 02 00 00 00       	mov    $0x2,%eax
  8011f7:	e8 34 ff ff ff       	call   801130 <nsipc>
}
  8011fc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011ff:	c9                   	leave  
  801200:	c3                   	ret    

00801201 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801201:	55                   	push   %ebp
  801202:	89 e5                	mov    %esp,%ebp
  801204:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801207:	8b 45 08             	mov    0x8(%ebp),%eax
  80120a:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  80120f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801212:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801217:	b8 03 00 00 00       	mov    $0x3,%eax
  80121c:	e8 0f ff ff ff       	call   801130 <nsipc>
}
  801221:	c9                   	leave  
  801222:	c3                   	ret    

00801223 <nsipc_close>:

int
nsipc_close(int s)
{
  801223:	55                   	push   %ebp
  801224:	89 e5                	mov    %esp,%ebp
  801226:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801229:	8b 45 08             	mov    0x8(%ebp),%eax
  80122c:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801231:	b8 04 00 00 00       	mov    $0x4,%eax
  801236:	e8 f5 fe ff ff       	call   801130 <nsipc>
}
  80123b:	c9                   	leave  
  80123c:	c3                   	ret    

0080123d <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80123d:	55                   	push   %ebp
  80123e:	89 e5                	mov    %esp,%ebp
  801240:	53                   	push   %ebx
  801241:	83 ec 08             	sub    $0x8,%esp
  801244:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801247:	8b 45 08             	mov    0x8(%ebp),%eax
  80124a:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80124f:	53                   	push   %ebx
  801250:	ff 75 0c             	pushl  0xc(%ebp)
  801253:	68 04 60 80 00       	push   $0x806004
  801258:	e8 ae 0b 00 00       	call   801e0b <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80125d:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801263:	b8 05 00 00 00       	mov    $0x5,%eax
  801268:	e8 c3 fe ff ff       	call   801130 <nsipc>
}
  80126d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801270:	c9                   	leave  
  801271:	c3                   	ret    

00801272 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801272:	55                   	push   %ebp
  801273:	89 e5                	mov    %esp,%ebp
  801275:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801278:	8b 45 08             	mov    0x8(%ebp),%eax
  80127b:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801280:	8b 45 0c             	mov    0xc(%ebp),%eax
  801283:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801288:	b8 06 00 00 00       	mov    $0x6,%eax
  80128d:	e8 9e fe ff ff       	call   801130 <nsipc>
}
  801292:	c9                   	leave  
  801293:	c3                   	ret    

00801294 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801294:	55                   	push   %ebp
  801295:	89 e5                	mov    %esp,%ebp
  801297:	56                   	push   %esi
  801298:	53                   	push   %ebx
  801299:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  80129c:	8b 45 08             	mov    0x8(%ebp),%eax
  80129f:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  8012a4:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  8012aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8012ad:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8012b2:	b8 07 00 00 00       	mov    $0x7,%eax
  8012b7:	e8 74 fe ff ff       	call   801130 <nsipc>
  8012bc:	89 c3                	mov    %eax,%ebx
  8012be:	85 c0                	test   %eax,%eax
  8012c0:	78 1f                	js     8012e1 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  8012c2:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8012c7:	7f 21                	jg     8012ea <nsipc_recv+0x56>
  8012c9:	39 c6                	cmp    %eax,%esi
  8012cb:	7c 1d                	jl     8012ea <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8012cd:	83 ec 04             	sub    $0x4,%esp
  8012d0:	50                   	push   %eax
  8012d1:	68 00 60 80 00       	push   $0x806000
  8012d6:	ff 75 0c             	pushl  0xc(%ebp)
  8012d9:	e8 2d 0b 00 00       	call   801e0b <memmove>
  8012de:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8012e1:	89 d8                	mov    %ebx,%eax
  8012e3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012e6:	5b                   	pop    %ebx
  8012e7:	5e                   	pop    %esi
  8012e8:	5d                   	pop    %ebp
  8012e9:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8012ea:	68 13 25 80 00       	push   $0x802513
  8012ef:	68 b5 24 80 00       	push   $0x8024b5
  8012f4:	6a 62                	push   $0x62
  8012f6:	68 28 25 80 00       	push   $0x802528
  8012fb:	e8 05 02 00 00       	call   801505 <_panic>

00801300 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801300:	55                   	push   %ebp
  801301:	89 e5                	mov    %esp,%ebp
  801303:	53                   	push   %ebx
  801304:	83 ec 04             	sub    $0x4,%esp
  801307:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  80130a:	8b 45 08             	mov    0x8(%ebp),%eax
  80130d:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801312:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801318:	7f 2e                	jg     801348 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80131a:	83 ec 04             	sub    $0x4,%esp
  80131d:	53                   	push   %ebx
  80131e:	ff 75 0c             	pushl  0xc(%ebp)
  801321:	68 0c 60 80 00       	push   $0x80600c
  801326:	e8 e0 0a 00 00       	call   801e0b <memmove>
	nsipcbuf.send.req_size = size;
  80132b:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801331:	8b 45 14             	mov    0x14(%ebp),%eax
  801334:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801339:	b8 08 00 00 00       	mov    $0x8,%eax
  80133e:	e8 ed fd ff ff       	call   801130 <nsipc>
}
  801343:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801346:	c9                   	leave  
  801347:	c3                   	ret    
	assert(size < 1600);
  801348:	68 34 25 80 00       	push   $0x802534
  80134d:	68 b5 24 80 00       	push   $0x8024b5
  801352:	6a 6d                	push   $0x6d
  801354:	68 28 25 80 00       	push   $0x802528
  801359:	e8 a7 01 00 00       	call   801505 <_panic>

0080135e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80135e:	55                   	push   %ebp
  80135f:	89 e5                	mov    %esp,%ebp
  801361:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801364:	8b 45 08             	mov    0x8(%ebp),%eax
  801367:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  80136c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136f:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801374:	8b 45 10             	mov    0x10(%ebp),%eax
  801377:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  80137c:	b8 09 00 00 00       	mov    $0x9,%eax
  801381:	e8 aa fd ff ff       	call   801130 <nsipc>
}
  801386:	c9                   	leave  
  801387:	c3                   	ret    

00801388 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801388:	55                   	push   %ebp
  801389:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  80138b:	b8 00 00 00 00       	mov    $0x0,%eax
  801390:	5d                   	pop    %ebp
  801391:	c3                   	ret    

00801392 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801392:	55                   	push   %ebp
  801393:	89 e5                	mov    %esp,%ebp
  801395:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801398:	68 40 25 80 00       	push   $0x802540
  80139d:	ff 75 0c             	pushl  0xc(%ebp)
  8013a0:	e8 d8 08 00 00       	call   801c7d <strcpy>
	return 0;
}
  8013a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8013aa:	c9                   	leave  
  8013ab:	c3                   	ret    

008013ac <devcons_write>:
{
  8013ac:	55                   	push   %ebp
  8013ad:	89 e5                	mov    %esp,%ebp
  8013af:	57                   	push   %edi
  8013b0:	56                   	push   %esi
  8013b1:	53                   	push   %ebx
  8013b2:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8013b8:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8013bd:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8013c3:	eb 2f                	jmp    8013f4 <devcons_write+0x48>
		m = n - tot;
  8013c5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8013c8:	29 f3                	sub    %esi,%ebx
  8013ca:	83 fb 7f             	cmp    $0x7f,%ebx
  8013cd:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8013d2:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8013d5:	83 ec 04             	sub    $0x4,%esp
  8013d8:	53                   	push   %ebx
  8013d9:	89 f0                	mov    %esi,%eax
  8013db:	03 45 0c             	add    0xc(%ebp),%eax
  8013de:	50                   	push   %eax
  8013df:	57                   	push   %edi
  8013e0:	e8 26 0a 00 00       	call   801e0b <memmove>
		sys_cputs(buf, m);
  8013e5:	83 c4 08             	add    $0x8,%esp
  8013e8:	53                   	push   %ebx
  8013e9:	57                   	push   %edi
  8013ea:	e8 c5 ec ff ff       	call   8000b4 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8013ef:	01 de                	add    %ebx,%esi
  8013f1:	83 c4 10             	add    $0x10,%esp
  8013f4:	3b 75 10             	cmp    0x10(%ebp),%esi
  8013f7:	72 cc                	jb     8013c5 <devcons_write+0x19>
}
  8013f9:	89 f0                	mov    %esi,%eax
  8013fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013fe:	5b                   	pop    %ebx
  8013ff:	5e                   	pop    %esi
  801400:	5f                   	pop    %edi
  801401:	5d                   	pop    %ebp
  801402:	c3                   	ret    

00801403 <devcons_read>:
{
  801403:	55                   	push   %ebp
  801404:	89 e5                	mov    %esp,%ebp
  801406:	83 ec 08             	sub    $0x8,%esp
  801409:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80140e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801412:	75 07                	jne    80141b <devcons_read+0x18>
}
  801414:	c9                   	leave  
  801415:	c3                   	ret    
		sys_yield();
  801416:	e8 36 ed ff ff       	call   800151 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  80141b:	e8 b2 ec ff ff       	call   8000d2 <sys_cgetc>
  801420:	85 c0                	test   %eax,%eax
  801422:	74 f2                	je     801416 <devcons_read+0x13>
	if (c < 0)
  801424:	85 c0                	test   %eax,%eax
  801426:	78 ec                	js     801414 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  801428:	83 f8 04             	cmp    $0x4,%eax
  80142b:	74 0c                	je     801439 <devcons_read+0x36>
	*(char*)vbuf = c;
  80142d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801430:	88 02                	mov    %al,(%edx)
	return 1;
  801432:	b8 01 00 00 00       	mov    $0x1,%eax
  801437:	eb db                	jmp    801414 <devcons_read+0x11>
		return 0;
  801439:	b8 00 00 00 00       	mov    $0x0,%eax
  80143e:	eb d4                	jmp    801414 <devcons_read+0x11>

00801440 <cputchar>:
{
  801440:	55                   	push   %ebp
  801441:	89 e5                	mov    %esp,%ebp
  801443:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801446:	8b 45 08             	mov    0x8(%ebp),%eax
  801449:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80144c:	6a 01                	push   $0x1
  80144e:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801451:	50                   	push   %eax
  801452:	e8 5d ec ff ff       	call   8000b4 <sys_cputs>
}
  801457:	83 c4 10             	add    $0x10,%esp
  80145a:	c9                   	leave  
  80145b:	c3                   	ret    

0080145c <getchar>:
{
  80145c:	55                   	push   %ebp
  80145d:	89 e5                	mov    %esp,%ebp
  80145f:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801462:	6a 01                	push   $0x1
  801464:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801467:	50                   	push   %eax
  801468:	6a 00                	push   $0x0
  80146a:	e8 1e f2 ff ff       	call   80068d <read>
	if (r < 0)
  80146f:	83 c4 10             	add    $0x10,%esp
  801472:	85 c0                	test   %eax,%eax
  801474:	78 08                	js     80147e <getchar+0x22>
	if (r < 1)
  801476:	85 c0                	test   %eax,%eax
  801478:	7e 06                	jle    801480 <getchar+0x24>
	return c;
  80147a:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80147e:	c9                   	leave  
  80147f:	c3                   	ret    
		return -E_EOF;
  801480:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801485:	eb f7                	jmp    80147e <getchar+0x22>

00801487 <iscons>:
{
  801487:	55                   	push   %ebp
  801488:	89 e5                	mov    %esp,%ebp
  80148a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80148d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801490:	50                   	push   %eax
  801491:	ff 75 08             	pushl  0x8(%ebp)
  801494:	e8 83 ef ff ff       	call   80041c <fd_lookup>
  801499:	83 c4 10             	add    $0x10,%esp
  80149c:	85 c0                	test   %eax,%eax
  80149e:	78 11                	js     8014b1 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8014a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014a3:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8014a9:	39 10                	cmp    %edx,(%eax)
  8014ab:	0f 94 c0             	sete   %al
  8014ae:	0f b6 c0             	movzbl %al,%eax
}
  8014b1:	c9                   	leave  
  8014b2:	c3                   	ret    

008014b3 <opencons>:
{
  8014b3:	55                   	push   %ebp
  8014b4:	89 e5                	mov    %esp,%ebp
  8014b6:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8014b9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014bc:	50                   	push   %eax
  8014bd:	e8 0b ef ff ff       	call   8003cd <fd_alloc>
  8014c2:	83 c4 10             	add    $0x10,%esp
  8014c5:	85 c0                	test   %eax,%eax
  8014c7:	78 3a                	js     801503 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8014c9:	83 ec 04             	sub    $0x4,%esp
  8014cc:	68 07 04 00 00       	push   $0x407
  8014d1:	ff 75 f4             	pushl  -0xc(%ebp)
  8014d4:	6a 00                	push   $0x0
  8014d6:	e8 95 ec ff ff       	call   800170 <sys_page_alloc>
  8014db:	83 c4 10             	add    $0x10,%esp
  8014de:	85 c0                	test   %eax,%eax
  8014e0:	78 21                	js     801503 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8014e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014e5:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8014eb:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8014ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014f0:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8014f7:	83 ec 0c             	sub    $0xc,%esp
  8014fa:	50                   	push   %eax
  8014fb:	e8 a6 ee ff ff       	call   8003a6 <fd2num>
  801500:	83 c4 10             	add    $0x10,%esp
}
  801503:	c9                   	leave  
  801504:	c3                   	ret    

00801505 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801505:	55                   	push   %ebp
  801506:	89 e5                	mov    %esp,%ebp
  801508:	56                   	push   %esi
  801509:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80150a:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80150d:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801513:	e8 1a ec ff ff       	call   800132 <sys_getenvid>
  801518:	83 ec 0c             	sub    $0xc,%esp
  80151b:	ff 75 0c             	pushl  0xc(%ebp)
  80151e:	ff 75 08             	pushl  0x8(%ebp)
  801521:	56                   	push   %esi
  801522:	50                   	push   %eax
  801523:	68 4c 25 80 00       	push   $0x80254c
  801528:	e8 b3 00 00 00       	call   8015e0 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80152d:	83 c4 18             	add    $0x18,%esp
  801530:	53                   	push   %ebx
  801531:	ff 75 10             	pushl  0x10(%ebp)
  801534:	e8 56 00 00 00       	call   80158f <vcprintf>
	cprintf("\n");
  801539:	c7 04 24 00 25 80 00 	movl   $0x802500,(%esp)
  801540:	e8 9b 00 00 00       	call   8015e0 <cprintf>
  801545:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801548:	cc                   	int3   
  801549:	eb fd                	jmp    801548 <_panic+0x43>

0080154b <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80154b:	55                   	push   %ebp
  80154c:	89 e5                	mov    %esp,%ebp
  80154e:	53                   	push   %ebx
  80154f:	83 ec 04             	sub    $0x4,%esp
  801552:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801555:	8b 13                	mov    (%ebx),%edx
  801557:	8d 42 01             	lea    0x1(%edx),%eax
  80155a:	89 03                	mov    %eax,(%ebx)
  80155c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80155f:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801563:	3d ff 00 00 00       	cmp    $0xff,%eax
  801568:	74 09                	je     801573 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80156a:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80156e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801571:	c9                   	leave  
  801572:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  801573:	83 ec 08             	sub    $0x8,%esp
  801576:	68 ff 00 00 00       	push   $0xff
  80157b:	8d 43 08             	lea    0x8(%ebx),%eax
  80157e:	50                   	push   %eax
  80157f:	e8 30 eb ff ff       	call   8000b4 <sys_cputs>
		b->idx = 0;
  801584:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80158a:	83 c4 10             	add    $0x10,%esp
  80158d:	eb db                	jmp    80156a <putch+0x1f>

0080158f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80158f:	55                   	push   %ebp
  801590:	89 e5                	mov    %esp,%ebp
  801592:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801598:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80159f:	00 00 00 
	b.cnt = 0;
  8015a2:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8015a9:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8015ac:	ff 75 0c             	pushl  0xc(%ebp)
  8015af:	ff 75 08             	pushl  0x8(%ebp)
  8015b2:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8015b8:	50                   	push   %eax
  8015b9:	68 4b 15 80 00       	push   $0x80154b
  8015be:	e8 1a 01 00 00       	call   8016dd <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8015c3:	83 c4 08             	add    $0x8,%esp
  8015c6:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8015cc:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8015d2:	50                   	push   %eax
  8015d3:	e8 dc ea ff ff       	call   8000b4 <sys_cputs>

	return b.cnt;
}
  8015d8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8015de:	c9                   	leave  
  8015df:	c3                   	ret    

008015e0 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8015e0:	55                   	push   %ebp
  8015e1:	89 e5                	mov    %esp,%ebp
  8015e3:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8015e6:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8015e9:	50                   	push   %eax
  8015ea:	ff 75 08             	pushl  0x8(%ebp)
  8015ed:	e8 9d ff ff ff       	call   80158f <vcprintf>
	va_end(ap);

	return cnt;
}
  8015f2:	c9                   	leave  
  8015f3:	c3                   	ret    

008015f4 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8015f4:	55                   	push   %ebp
  8015f5:	89 e5                	mov    %esp,%ebp
  8015f7:	57                   	push   %edi
  8015f8:	56                   	push   %esi
  8015f9:	53                   	push   %ebx
  8015fa:	83 ec 1c             	sub    $0x1c,%esp
  8015fd:	89 c7                	mov    %eax,%edi
  8015ff:	89 d6                	mov    %edx,%esi
  801601:	8b 45 08             	mov    0x8(%ebp),%eax
  801604:	8b 55 0c             	mov    0xc(%ebp),%edx
  801607:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80160a:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80160d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801610:	bb 00 00 00 00       	mov    $0x0,%ebx
  801615:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  801618:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80161b:	39 d3                	cmp    %edx,%ebx
  80161d:	72 05                	jb     801624 <printnum+0x30>
  80161f:	39 45 10             	cmp    %eax,0x10(%ebp)
  801622:	77 7a                	ja     80169e <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801624:	83 ec 0c             	sub    $0xc,%esp
  801627:	ff 75 18             	pushl  0x18(%ebp)
  80162a:	8b 45 14             	mov    0x14(%ebp),%eax
  80162d:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801630:	53                   	push   %ebx
  801631:	ff 75 10             	pushl  0x10(%ebp)
  801634:	83 ec 08             	sub    $0x8,%esp
  801637:	ff 75 e4             	pushl  -0x1c(%ebp)
  80163a:	ff 75 e0             	pushl  -0x20(%ebp)
  80163d:	ff 75 dc             	pushl  -0x24(%ebp)
  801640:	ff 75 d8             	pushl  -0x28(%ebp)
  801643:	e8 28 0b 00 00       	call   802170 <__udivdi3>
  801648:	83 c4 18             	add    $0x18,%esp
  80164b:	52                   	push   %edx
  80164c:	50                   	push   %eax
  80164d:	89 f2                	mov    %esi,%edx
  80164f:	89 f8                	mov    %edi,%eax
  801651:	e8 9e ff ff ff       	call   8015f4 <printnum>
  801656:	83 c4 20             	add    $0x20,%esp
  801659:	eb 13                	jmp    80166e <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80165b:	83 ec 08             	sub    $0x8,%esp
  80165e:	56                   	push   %esi
  80165f:	ff 75 18             	pushl  0x18(%ebp)
  801662:	ff d7                	call   *%edi
  801664:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  801667:	83 eb 01             	sub    $0x1,%ebx
  80166a:	85 db                	test   %ebx,%ebx
  80166c:	7f ed                	jg     80165b <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80166e:	83 ec 08             	sub    $0x8,%esp
  801671:	56                   	push   %esi
  801672:	83 ec 04             	sub    $0x4,%esp
  801675:	ff 75 e4             	pushl  -0x1c(%ebp)
  801678:	ff 75 e0             	pushl  -0x20(%ebp)
  80167b:	ff 75 dc             	pushl  -0x24(%ebp)
  80167e:	ff 75 d8             	pushl  -0x28(%ebp)
  801681:	e8 0a 0c 00 00       	call   802290 <__umoddi3>
  801686:	83 c4 14             	add    $0x14,%esp
  801689:	0f be 80 6f 25 80 00 	movsbl 0x80256f(%eax),%eax
  801690:	50                   	push   %eax
  801691:	ff d7                	call   *%edi
}
  801693:	83 c4 10             	add    $0x10,%esp
  801696:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801699:	5b                   	pop    %ebx
  80169a:	5e                   	pop    %esi
  80169b:	5f                   	pop    %edi
  80169c:	5d                   	pop    %ebp
  80169d:	c3                   	ret    
  80169e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016a1:	eb c4                	jmp    801667 <printnum+0x73>

008016a3 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8016a3:	55                   	push   %ebp
  8016a4:	89 e5                	mov    %esp,%ebp
  8016a6:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8016a9:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8016ad:	8b 10                	mov    (%eax),%edx
  8016af:	3b 50 04             	cmp    0x4(%eax),%edx
  8016b2:	73 0a                	jae    8016be <sprintputch+0x1b>
		*b->buf++ = ch;
  8016b4:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016b7:	89 08                	mov    %ecx,(%eax)
  8016b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bc:	88 02                	mov    %al,(%edx)
}
  8016be:	5d                   	pop    %ebp
  8016bf:	c3                   	ret    

008016c0 <printfmt>:
{
  8016c0:	55                   	push   %ebp
  8016c1:	89 e5                	mov    %esp,%ebp
  8016c3:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8016c6:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8016c9:	50                   	push   %eax
  8016ca:	ff 75 10             	pushl  0x10(%ebp)
  8016cd:	ff 75 0c             	pushl  0xc(%ebp)
  8016d0:	ff 75 08             	pushl  0x8(%ebp)
  8016d3:	e8 05 00 00 00       	call   8016dd <vprintfmt>
}
  8016d8:	83 c4 10             	add    $0x10,%esp
  8016db:	c9                   	leave  
  8016dc:	c3                   	ret    

008016dd <vprintfmt>:
{
  8016dd:	55                   	push   %ebp
  8016de:	89 e5                	mov    %esp,%ebp
  8016e0:	57                   	push   %edi
  8016e1:	56                   	push   %esi
  8016e2:	53                   	push   %ebx
  8016e3:	83 ec 2c             	sub    $0x2c,%esp
  8016e6:	8b 75 08             	mov    0x8(%ebp),%esi
  8016e9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8016ec:	8b 7d 10             	mov    0x10(%ebp),%edi
  8016ef:	e9 21 04 00 00       	jmp    801b15 <vprintfmt+0x438>
		padc = ' ';
  8016f4:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8016f8:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8016ff:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  801706:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80170d:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801712:	8d 47 01             	lea    0x1(%edi),%eax
  801715:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801718:	0f b6 17             	movzbl (%edi),%edx
  80171b:	8d 42 dd             	lea    -0x23(%edx),%eax
  80171e:	3c 55                	cmp    $0x55,%al
  801720:	0f 87 90 04 00 00    	ja     801bb6 <vprintfmt+0x4d9>
  801726:	0f b6 c0             	movzbl %al,%eax
  801729:	ff 24 85 c0 26 80 00 	jmp    *0x8026c0(,%eax,4)
  801730:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  801733:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  801737:	eb d9                	jmp    801712 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  801739:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80173c:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  801740:	eb d0                	jmp    801712 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  801742:	0f b6 d2             	movzbl %dl,%edx
  801745:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  801748:	b8 00 00 00 00       	mov    $0x0,%eax
  80174d:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  801750:	8d 04 80             	lea    (%eax,%eax,4),%eax
  801753:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  801757:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80175a:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80175d:	83 f9 09             	cmp    $0x9,%ecx
  801760:	77 55                	ja     8017b7 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  801762:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  801765:	eb e9                	jmp    801750 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  801767:	8b 45 14             	mov    0x14(%ebp),%eax
  80176a:	8b 00                	mov    (%eax),%eax
  80176c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80176f:	8b 45 14             	mov    0x14(%ebp),%eax
  801772:	8d 40 04             	lea    0x4(%eax),%eax
  801775:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801778:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80177b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80177f:	79 91                	jns    801712 <vprintfmt+0x35>
				width = precision, precision = -1;
  801781:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801784:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801787:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80178e:	eb 82                	jmp    801712 <vprintfmt+0x35>
  801790:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801793:	85 c0                	test   %eax,%eax
  801795:	ba 00 00 00 00       	mov    $0x0,%edx
  80179a:	0f 49 d0             	cmovns %eax,%edx
  80179d:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8017a0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8017a3:	e9 6a ff ff ff       	jmp    801712 <vprintfmt+0x35>
  8017a8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8017ab:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8017b2:	e9 5b ff ff ff       	jmp    801712 <vprintfmt+0x35>
  8017b7:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8017ba:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8017bd:	eb bc                	jmp    80177b <vprintfmt+0x9e>
			lflag++;
  8017bf:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8017c2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8017c5:	e9 48 ff ff ff       	jmp    801712 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8017ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8017cd:	8d 78 04             	lea    0x4(%eax),%edi
  8017d0:	83 ec 08             	sub    $0x8,%esp
  8017d3:	53                   	push   %ebx
  8017d4:	ff 30                	pushl  (%eax)
  8017d6:	ff d6                	call   *%esi
			break;
  8017d8:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8017db:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8017de:	e9 2f 03 00 00       	jmp    801b12 <vprintfmt+0x435>
			err = va_arg(ap, int);
  8017e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8017e6:	8d 78 04             	lea    0x4(%eax),%edi
  8017e9:	8b 00                	mov    (%eax),%eax
  8017eb:	99                   	cltd   
  8017ec:	31 d0                	xor    %edx,%eax
  8017ee:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8017f0:	83 f8 0f             	cmp    $0xf,%eax
  8017f3:	7f 23                	jg     801818 <vprintfmt+0x13b>
  8017f5:	8b 14 85 20 28 80 00 	mov    0x802820(,%eax,4),%edx
  8017fc:	85 d2                	test   %edx,%edx
  8017fe:	74 18                	je     801818 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  801800:	52                   	push   %edx
  801801:	68 c7 24 80 00       	push   $0x8024c7
  801806:	53                   	push   %ebx
  801807:	56                   	push   %esi
  801808:	e8 b3 fe ff ff       	call   8016c0 <printfmt>
  80180d:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801810:	89 7d 14             	mov    %edi,0x14(%ebp)
  801813:	e9 fa 02 00 00       	jmp    801b12 <vprintfmt+0x435>
				printfmt(putch, putdat, "error %d", err);
  801818:	50                   	push   %eax
  801819:	68 87 25 80 00       	push   $0x802587
  80181e:	53                   	push   %ebx
  80181f:	56                   	push   %esi
  801820:	e8 9b fe ff ff       	call   8016c0 <printfmt>
  801825:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801828:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80182b:	e9 e2 02 00 00       	jmp    801b12 <vprintfmt+0x435>
			if ((p = va_arg(ap, char *)) == NULL)
  801830:	8b 45 14             	mov    0x14(%ebp),%eax
  801833:	83 c0 04             	add    $0x4,%eax
  801836:	89 45 cc             	mov    %eax,-0x34(%ebp)
  801839:	8b 45 14             	mov    0x14(%ebp),%eax
  80183c:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80183e:	85 ff                	test   %edi,%edi
  801840:	b8 80 25 80 00       	mov    $0x802580,%eax
  801845:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  801848:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80184c:	0f 8e bd 00 00 00    	jle    80190f <vprintfmt+0x232>
  801852:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  801856:	75 0e                	jne    801866 <vprintfmt+0x189>
  801858:	89 75 08             	mov    %esi,0x8(%ebp)
  80185b:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80185e:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  801861:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  801864:	eb 6d                	jmp    8018d3 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  801866:	83 ec 08             	sub    $0x8,%esp
  801869:	ff 75 d0             	pushl  -0x30(%ebp)
  80186c:	57                   	push   %edi
  80186d:	e8 ec 03 00 00       	call   801c5e <strnlen>
  801872:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  801875:	29 c1                	sub    %eax,%ecx
  801877:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  80187a:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  80187d:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  801881:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801884:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  801887:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  801889:	eb 0f                	jmp    80189a <vprintfmt+0x1bd>
					putch(padc, putdat);
  80188b:	83 ec 08             	sub    $0x8,%esp
  80188e:	53                   	push   %ebx
  80188f:	ff 75 e0             	pushl  -0x20(%ebp)
  801892:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  801894:	83 ef 01             	sub    $0x1,%edi
  801897:	83 c4 10             	add    $0x10,%esp
  80189a:	85 ff                	test   %edi,%edi
  80189c:	7f ed                	jg     80188b <vprintfmt+0x1ae>
  80189e:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8018a1:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8018a4:	85 c9                	test   %ecx,%ecx
  8018a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8018ab:	0f 49 c1             	cmovns %ecx,%eax
  8018ae:	29 c1                	sub    %eax,%ecx
  8018b0:	89 75 08             	mov    %esi,0x8(%ebp)
  8018b3:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8018b6:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8018b9:	89 cb                	mov    %ecx,%ebx
  8018bb:	eb 16                	jmp    8018d3 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8018bd:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8018c1:	75 31                	jne    8018f4 <vprintfmt+0x217>
					putch(ch, putdat);
  8018c3:	83 ec 08             	sub    $0x8,%esp
  8018c6:	ff 75 0c             	pushl  0xc(%ebp)
  8018c9:	50                   	push   %eax
  8018ca:	ff 55 08             	call   *0x8(%ebp)
  8018cd:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8018d0:	83 eb 01             	sub    $0x1,%ebx
  8018d3:	83 c7 01             	add    $0x1,%edi
  8018d6:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8018da:	0f be c2             	movsbl %dl,%eax
  8018dd:	85 c0                	test   %eax,%eax
  8018df:	74 59                	je     80193a <vprintfmt+0x25d>
  8018e1:	85 f6                	test   %esi,%esi
  8018e3:	78 d8                	js     8018bd <vprintfmt+0x1e0>
  8018e5:	83 ee 01             	sub    $0x1,%esi
  8018e8:	79 d3                	jns    8018bd <vprintfmt+0x1e0>
  8018ea:	89 df                	mov    %ebx,%edi
  8018ec:	8b 75 08             	mov    0x8(%ebp),%esi
  8018ef:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8018f2:	eb 37                	jmp    80192b <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  8018f4:	0f be d2             	movsbl %dl,%edx
  8018f7:	83 ea 20             	sub    $0x20,%edx
  8018fa:	83 fa 5e             	cmp    $0x5e,%edx
  8018fd:	76 c4                	jbe    8018c3 <vprintfmt+0x1e6>
					putch('?', putdat);
  8018ff:	83 ec 08             	sub    $0x8,%esp
  801902:	ff 75 0c             	pushl  0xc(%ebp)
  801905:	6a 3f                	push   $0x3f
  801907:	ff 55 08             	call   *0x8(%ebp)
  80190a:	83 c4 10             	add    $0x10,%esp
  80190d:	eb c1                	jmp    8018d0 <vprintfmt+0x1f3>
  80190f:	89 75 08             	mov    %esi,0x8(%ebp)
  801912:	8b 75 d0             	mov    -0x30(%ebp),%esi
  801915:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  801918:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80191b:	eb b6                	jmp    8018d3 <vprintfmt+0x1f6>
				putch(' ', putdat);
  80191d:	83 ec 08             	sub    $0x8,%esp
  801920:	53                   	push   %ebx
  801921:	6a 20                	push   $0x20
  801923:	ff d6                	call   *%esi
			for (; width > 0; width--)
  801925:	83 ef 01             	sub    $0x1,%edi
  801928:	83 c4 10             	add    $0x10,%esp
  80192b:	85 ff                	test   %edi,%edi
  80192d:	7f ee                	jg     80191d <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  80192f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801932:	89 45 14             	mov    %eax,0x14(%ebp)
  801935:	e9 d8 01 00 00       	jmp    801b12 <vprintfmt+0x435>
  80193a:	89 df                	mov    %ebx,%edi
  80193c:	8b 75 08             	mov    0x8(%ebp),%esi
  80193f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801942:	eb e7                	jmp    80192b <vprintfmt+0x24e>
	if (lflag >= 2)
  801944:	83 f9 01             	cmp    $0x1,%ecx
  801947:	7e 45                	jle    80198e <vprintfmt+0x2b1>
		return va_arg(*ap, long long);
  801949:	8b 45 14             	mov    0x14(%ebp),%eax
  80194c:	8b 50 04             	mov    0x4(%eax),%edx
  80194f:	8b 00                	mov    (%eax),%eax
  801951:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801954:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801957:	8b 45 14             	mov    0x14(%ebp),%eax
  80195a:	8d 40 08             	lea    0x8(%eax),%eax
  80195d:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  801960:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801964:	79 62                	jns    8019c8 <vprintfmt+0x2eb>
				putch('-', putdat);
  801966:	83 ec 08             	sub    $0x8,%esp
  801969:	53                   	push   %ebx
  80196a:	6a 2d                	push   $0x2d
  80196c:	ff d6                	call   *%esi
				num = -(long long) num;
  80196e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801971:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801974:	f7 d8                	neg    %eax
  801976:	83 d2 00             	adc    $0x0,%edx
  801979:	f7 da                	neg    %edx
  80197b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80197e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801981:	83 c4 10             	add    $0x10,%esp
			base = 10;
  801984:	ba 0a 00 00 00       	mov    $0xa,%edx
  801989:	e9 66 01 00 00       	jmp    801af4 <vprintfmt+0x417>
	else if (lflag)
  80198e:	85 c9                	test   %ecx,%ecx
  801990:	75 1b                	jne    8019ad <vprintfmt+0x2d0>
		return va_arg(*ap, int);
  801992:	8b 45 14             	mov    0x14(%ebp),%eax
  801995:	8b 00                	mov    (%eax),%eax
  801997:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80199a:	89 c1                	mov    %eax,%ecx
  80199c:	c1 f9 1f             	sar    $0x1f,%ecx
  80199f:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8019a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8019a5:	8d 40 04             	lea    0x4(%eax),%eax
  8019a8:	89 45 14             	mov    %eax,0x14(%ebp)
  8019ab:	eb b3                	jmp    801960 <vprintfmt+0x283>
		return va_arg(*ap, long);
  8019ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8019b0:	8b 00                	mov    (%eax),%eax
  8019b2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8019b5:	89 c1                	mov    %eax,%ecx
  8019b7:	c1 f9 1f             	sar    $0x1f,%ecx
  8019ba:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8019bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8019c0:	8d 40 04             	lea    0x4(%eax),%eax
  8019c3:	89 45 14             	mov    %eax,0x14(%ebp)
  8019c6:	eb 98                	jmp    801960 <vprintfmt+0x283>
			base = 10;
  8019c8:	ba 0a 00 00 00       	mov    $0xa,%edx
  8019cd:	e9 22 01 00 00       	jmp    801af4 <vprintfmt+0x417>
	if (lflag >= 2)
  8019d2:	83 f9 01             	cmp    $0x1,%ecx
  8019d5:	7e 21                	jle    8019f8 <vprintfmt+0x31b>
		return va_arg(*ap, unsigned long long);
  8019d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8019da:	8b 50 04             	mov    0x4(%eax),%edx
  8019dd:	8b 00                	mov    (%eax),%eax
  8019df:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8019e2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8019e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8019e8:	8d 40 08             	lea    0x8(%eax),%eax
  8019eb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8019ee:	ba 0a 00 00 00       	mov    $0xa,%edx
  8019f3:	e9 fc 00 00 00       	jmp    801af4 <vprintfmt+0x417>
	else if (lflag)
  8019f8:	85 c9                	test   %ecx,%ecx
  8019fa:	75 23                	jne    801a1f <vprintfmt+0x342>
		return va_arg(*ap, unsigned int);
  8019fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8019ff:	8b 00                	mov    (%eax),%eax
  801a01:	ba 00 00 00 00       	mov    $0x0,%edx
  801a06:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801a09:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801a0c:	8b 45 14             	mov    0x14(%ebp),%eax
  801a0f:	8d 40 04             	lea    0x4(%eax),%eax
  801a12:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801a15:	ba 0a 00 00 00       	mov    $0xa,%edx
  801a1a:	e9 d5 00 00 00       	jmp    801af4 <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  801a1f:	8b 45 14             	mov    0x14(%ebp),%eax
  801a22:	8b 00                	mov    (%eax),%eax
  801a24:	ba 00 00 00 00       	mov    $0x0,%edx
  801a29:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801a2c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801a2f:	8b 45 14             	mov    0x14(%ebp),%eax
  801a32:	8d 40 04             	lea    0x4(%eax),%eax
  801a35:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801a38:	ba 0a 00 00 00       	mov    $0xa,%edx
  801a3d:	e9 b2 00 00 00       	jmp    801af4 <vprintfmt+0x417>
	if (lflag >= 2)
  801a42:	83 f9 01             	cmp    $0x1,%ecx
  801a45:	7e 42                	jle    801a89 <vprintfmt+0x3ac>
		return va_arg(*ap, unsigned long long);
  801a47:	8b 45 14             	mov    0x14(%ebp),%eax
  801a4a:	8b 50 04             	mov    0x4(%eax),%edx
  801a4d:	8b 00                	mov    (%eax),%eax
  801a4f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801a52:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801a55:	8b 45 14             	mov    0x14(%ebp),%eax
  801a58:	8d 40 08             	lea    0x8(%eax),%eax
  801a5b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801a5e:	ba 08 00 00 00       	mov    $0x8,%edx
			if ((long long) num < 0) {
  801a63:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801a67:	0f 89 87 00 00 00    	jns    801af4 <vprintfmt+0x417>
				putch('-', putdat);
  801a6d:	83 ec 08             	sub    $0x8,%esp
  801a70:	53                   	push   %ebx
  801a71:	6a 2d                	push   $0x2d
  801a73:	ff d6                	call   *%esi
				num = -(long long) num;
  801a75:	f7 5d d8             	negl   -0x28(%ebp)
  801a78:	83 55 dc 00          	adcl   $0x0,-0x24(%ebp)
  801a7c:	f7 5d dc             	negl   -0x24(%ebp)
  801a7f:	83 c4 10             	add    $0x10,%esp
			base = 8;
  801a82:	ba 08 00 00 00       	mov    $0x8,%edx
  801a87:	eb 6b                	jmp    801af4 <vprintfmt+0x417>
	else if (lflag)
  801a89:	85 c9                	test   %ecx,%ecx
  801a8b:	75 1b                	jne    801aa8 <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  801a8d:	8b 45 14             	mov    0x14(%ebp),%eax
  801a90:	8b 00                	mov    (%eax),%eax
  801a92:	ba 00 00 00 00       	mov    $0x0,%edx
  801a97:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801a9a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801a9d:	8b 45 14             	mov    0x14(%ebp),%eax
  801aa0:	8d 40 04             	lea    0x4(%eax),%eax
  801aa3:	89 45 14             	mov    %eax,0x14(%ebp)
  801aa6:	eb b6                	jmp    801a5e <vprintfmt+0x381>
		return va_arg(*ap, unsigned long);
  801aa8:	8b 45 14             	mov    0x14(%ebp),%eax
  801aab:	8b 00                	mov    (%eax),%eax
  801aad:	ba 00 00 00 00       	mov    $0x0,%edx
  801ab2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801ab5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801ab8:	8b 45 14             	mov    0x14(%ebp),%eax
  801abb:	8d 40 04             	lea    0x4(%eax),%eax
  801abe:	89 45 14             	mov    %eax,0x14(%ebp)
  801ac1:	eb 9b                	jmp    801a5e <vprintfmt+0x381>
			putch('0', putdat);
  801ac3:	83 ec 08             	sub    $0x8,%esp
  801ac6:	53                   	push   %ebx
  801ac7:	6a 30                	push   $0x30
  801ac9:	ff d6                	call   *%esi
			putch('x', putdat);
  801acb:	83 c4 08             	add    $0x8,%esp
  801ace:	53                   	push   %ebx
  801acf:	6a 78                	push   $0x78
  801ad1:	ff d6                	call   *%esi
			num = (unsigned long long)
  801ad3:	8b 45 14             	mov    0x14(%ebp),%eax
  801ad6:	8b 00                	mov    (%eax),%eax
  801ad8:	ba 00 00 00 00       	mov    $0x0,%edx
  801add:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801ae0:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  801ae3:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  801ae6:	8b 45 14             	mov    0x14(%ebp),%eax
  801ae9:	8d 40 04             	lea    0x4(%eax),%eax
  801aec:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801aef:	ba 10 00 00 00       	mov    $0x10,%edx
			printnum(putch, putdat, num, base, width, padc);
  801af4:	83 ec 0c             	sub    $0xc,%esp
  801af7:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  801afb:	50                   	push   %eax
  801afc:	ff 75 e0             	pushl  -0x20(%ebp)
  801aff:	52                   	push   %edx
  801b00:	ff 75 dc             	pushl  -0x24(%ebp)
  801b03:	ff 75 d8             	pushl  -0x28(%ebp)
  801b06:	89 da                	mov    %ebx,%edx
  801b08:	89 f0                	mov    %esi,%eax
  801b0a:	e8 e5 fa ff ff       	call   8015f4 <printnum>
			break;
  801b0f:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  801b12:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801b15:	83 c7 01             	add    $0x1,%edi
  801b18:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801b1c:	83 f8 25             	cmp    $0x25,%eax
  801b1f:	0f 84 cf fb ff ff    	je     8016f4 <vprintfmt+0x17>
			if (ch == '\0')
  801b25:	85 c0                	test   %eax,%eax
  801b27:	0f 84 a9 00 00 00    	je     801bd6 <vprintfmt+0x4f9>
			putch(ch, putdat);
  801b2d:	83 ec 08             	sub    $0x8,%esp
  801b30:	53                   	push   %ebx
  801b31:	50                   	push   %eax
  801b32:	ff d6                	call   *%esi
  801b34:	83 c4 10             	add    $0x10,%esp
  801b37:	eb dc                	jmp    801b15 <vprintfmt+0x438>
	if (lflag >= 2)
  801b39:	83 f9 01             	cmp    $0x1,%ecx
  801b3c:	7e 1e                	jle    801b5c <vprintfmt+0x47f>
		return va_arg(*ap, unsigned long long);
  801b3e:	8b 45 14             	mov    0x14(%ebp),%eax
  801b41:	8b 50 04             	mov    0x4(%eax),%edx
  801b44:	8b 00                	mov    (%eax),%eax
  801b46:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801b49:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801b4c:	8b 45 14             	mov    0x14(%ebp),%eax
  801b4f:	8d 40 08             	lea    0x8(%eax),%eax
  801b52:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801b55:	ba 10 00 00 00       	mov    $0x10,%edx
  801b5a:	eb 98                	jmp    801af4 <vprintfmt+0x417>
	else if (lflag)
  801b5c:	85 c9                	test   %ecx,%ecx
  801b5e:	75 23                	jne    801b83 <vprintfmt+0x4a6>
		return va_arg(*ap, unsigned int);
  801b60:	8b 45 14             	mov    0x14(%ebp),%eax
  801b63:	8b 00                	mov    (%eax),%eax
  801b65:	ba 00 00 00 00       	mov    $0x0,%edx
  801b6a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801b6d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801b70:	8b 45 14             	mov    0x14(%ebp),%eax
  801b73:	8d 40 04             	lea    0x4(%eax),%eax
  801b76:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801b79:	ba 10 00 00 00       	mov    $0x10,%edx
  801b7e:	e9 71 ff ff ff       	jmp    801af4 <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  801b83:	8b 45 14             	mov    0x14(%ebp),%eax
  801b86:	8b 00                	mov    (%eax),%eax
  801b88:	ba 00 00 00 00       	mov    $0x0,%edx
  801b8d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801b90:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801b93:	8b 45 14             	mov    0x14(%ebp),%eax
  801b96:	8d 40 04             	lea    0x4(%eax),%eax
  801b99:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801b9c:	ba 10 00 00 00       	mov    $0x10,%edx
  801ba1:	e9 4e ff ff ff       	jmp    801af4 <vprintfmt+0x417>
			putch(ch, putdat);
  801ba6:	83 ec 08             	sub    $0x8,%esp
  801ba9:	53                   	push   %ebx
  801baa:	6a 25                	push   $0x25
  801bac:	ff d6                	call   *%esi
			break;
  801bae:	83 c4 10             	add    $0x10,%esp
  801bb1:	e9 5c ff ff ff       	jmp    801b12 <vprintfmt+0x435>
			putch('%', putdat);
  801bb6:	83 ec 08             	sub    $0x8,%esp
  801bb9:	53                   	push   %ebx
  801bba:	6a 25                	push   $0x25
  801bbc:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  801bbe:	83 c4 10             	add    $0x10,%esp
  801bc1:	89 f8                	mov    %edi,%eax
  801bc3:	eb 03                	jmp    801bc8 <vprintfmt+0x4eb>
  801bc5:	83 e8 01             	sub    $0x1,%eax
  801bc8:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  801bcc:	75 f7                	jne    801bc5 <vprintfmt+0x4e8>
  801bce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801bd1:	e9 3c ff ff ff       	jmp    801b12 <vprintfmt+0x435>
}
  801bd6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801bd9:	5b                   	pop    %ebx
  801bda:	5e                   	pop    %esi
  801bdb:	5f                   	pop    %edi
  801bdc:	5d                   	pop    %ebp
  801bdd:	c3                   	ret    

00801bde <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801bde:	55                   	push   %ebp
  801bdf:	89 e5                	mov    %esp,%ebp
  801be1:	83 ec 18             	sub    $0x18,%esp
  801be4:	8b 45 08             	mov    0x8(%ebp),%eax
  801be7:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801bea:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801bed:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801bf1:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801bf4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801bfb:	85 c0                	test   %eax,%eax
  801bfd:	74 26                	je     801c25 <vsnprintf+0x47>
  801bff:	85 d2                	test   %edx,%edx
  801c01:	7e 22                	jle    801c25 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801c03:	ff 75 14             	pushl  0x14(%ebp)
  801c06:	ff 75 10             	pushl  0x10(%ebp)
  801c09:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801c0c:	50                   	push   %eax
  801c0d:	68 a3 16 80 00       	push   $0x8016a3
  801c12:	e8 c6 fa ff ff       	call   8016dd <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801c17:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c1a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801c1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c20:	83 c4 10             	add    $0x10,%esp
}
  801c23:	c9                   	leave  
  801c24:	c3                   	ret    
		return -E_INVAL;
  801c25:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c2a:	eb f7                	jmp    801c23 <vsnprintf+0x45>

00801c2c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801c2c:	55                   	push   %ebp
  801c2d:	89 e5                	mov    %esp,%ebp
  801c2f:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801c32:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801c35:	50                   	push   %eax
  801c36:	ff 75 10             	pushl  0x10(%ebp)
  801c39:	ff 75 0c             	pushl  0xc(%ebp)
  801c3c:	ff 75 08             	pushl  0x8(%ebp)
  801c3f:	e8 9a ff ff ff       	call   801bde <vsnprintf>
	va_end(ap);

	return rc;
}
  801c44:	c9                   	leave  
  801c45:	c3                   	ret    

00801c46 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801c46:	55                   	push   %ebp
  801c47:	89 e5                	mov    %esp,%ebp
  801c49:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801c4c:	b8 00 00 00 00       	mov    $0x0,%eax
  801c51:	eb 03                	jmp    801c56 <strlen+0x10>
		n++;
  801c53:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  801c56:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801c5a:	75 f7                	jne    801c53 <strlen+0xd>
	return n;
}
  801c5c:	5d                   	pop    %ebp
  801c5d:	c3                   	ret    

00801c5e <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801c5e:	55                   	push   %ebp
  801c5f:	89 e5                	mov    %esp,%ebp
  801c61:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c64:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801c67:	b8 00 00 00 00       	mov    $0x0,%eax
  801c6c:	eb 03                	jmp    801c71 <strnlen+0x13>
		n++;
  801c6e:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801c71:	39 d0                	cmp    %edx,%eax
  801c73:	74 06                	je     801c7b <strnlen+0x1d>
  801c75:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  801c79:	75 f3                	jne    801c6e <strnlen+0x10>
	return n;
}
  801c7b:	5d                   	pop    %ebp
  801c7c:	c3                   	ret    

00801c7d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801c7d:	55                   	push   %ebp
  801c7e:	89 e5                	mov    %esp,%ebp
  801c80:	53                   	push   %ebx
  801c81:	8b 45 08             	mov    0x8(%ebp),%eax
  801c84:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801c87:	89 c2                	mov    %eax,%edx
  801c89:	83 c1 01             	add    $0x1,%ecx
  801c8c:	83 c2 01             	add    $0x1,%edx
  801c8f:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  801c93:	88 5a ff             	mov    %bl,-0x1(%edx)
  801c96:	84 db                	test   %bl,%bl
  801c98:	75 ef                	jne    801c89 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  801c9a:	5b                   	pop    %ebx
  801c9b:	5d                   	pop    %ebp
  801c9c:	c3                   	ret    

00801c9d <strcat>:

char *
strcat(char *dst, const char *src)
{
  801c9d:	55                   	push   %ebp
  801c9e:	89 e5                	mov    %esp,%ebp
  801ca0:	53                   	push   %ebx
  801ca1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801ca4:	53                   	push   %ebx
  801ca5:	e8 9c ff ff ff       	call   801c46 <strlen>
  801caa:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  801cad:	ff 75 0c             	pushl  0xc(%ebp)
  801cb0:	01 d8                	add    %ebx,%eax
  801cb2:	50                   	push   %eax
  801cb3:	e8 c5 ff ff ff       	call   801c7d <strcpy>
	return dst;
}
  801cb8:	89 d8                	mov    %ebx,%eax
  801cba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cbd:	c9                   	leave  
  801cbe:	c3                   	ret    

00801cbf <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801cbf:	55                   	push   %ebp
  801cc0:	89 e5                	mov    %esp,%ebp
  801cc2:	56                   	push   %esi
  801cc3:	53                   	push   %ebx
  801cc4:	8b 75 08             	mov    0x8(%ebp),%esi
  801cc7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801cca:	89 f3                	mov    %esi,%ebx
  801ccc:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801ccf:	89 f2                	mov    %esi,%edx
  801cd1:	eb 0f                	jmp    801ce2 <strncpy+0x23>
		*dst++ = *src;
  801cd3:	83 c2 01             	add    $0x1,%edx
  801cd6:	0f b6 01             	movzbl (%ecx),%eax
  801cd9:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801cdc:	80 39 01             	cmpb   $0x1,(%ecx)
  801cdf:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  801ce2:	39 da                	cmp    %ebx,%edx
  801ce4:	75 ed                	jne    801cd3 <strncpy+0x14>
	}
	return ret;
}
  801ce6:	89 f0                	mov    %esi,%eax
  801ce8:	5b                   	pop    %ebx
  801ce9:	5e                   	pop    %esi
  801cea:	5d                   	pop    %ebp
  801ceb:	c3                   	ret    

00801cec <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801cec:	55                   	push   %ebp
  801ced:	89 e5                	mov    %esp,%ebp
  801cef:	56                   	push   %esi
  801cf0:	53                   	push   %ebx
  801cf1:	8b 75 08             	mov    0x8(%ebp),%esi
  801cf4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cf7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cfa:	89 f0                	mov    %esi,%eax
  801cfc:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801d00:	85 c9                	test   %ecx,%ecx
  801d02:	75 0b                	jne    801d0f <strlcpy+0x23>
  801d04:	eb 17                	jmp    801d1d <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  801d06:	83 c2 01             	add    $0x1,%edx
  801d09:	83 c0 01             	add    $0x1,%eax
  801d0c:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  801d0f:	39 d8                	cmp    %ebx,%eax
  801d11:	74 07                	je     801d1a <strlcpy+0x2e>
  801d13:	0f b6 0a             	movzbl (%edx),%ecx
  801d16:	84 c9                	test   %cl,%cl
  801d18:	75 ec                	jne    801d06 <strlcpy+0x1a>
		*dst = '\0';
  801d1a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801d1d:	29 f0                	sub    %esi,%eax
}
  801d1f:	5b                   	pop    %ebx
  801d20:	5e                   	pop    %esi
  801d21:	5d                   	pop    %ebp
  801d22:	c3                   	ret    

00801d23 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801d23:	55                   	push   %ebp
  801d24:	89 e5                	mov    %esp,%ebp
  801d26:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d29:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801d2c:	eb 06                	jmp    801d34 <strcmp+0x11>
		p++, q++;
  801d2e:	83 c1 01             	add    $0x1,%ecx
  801d31:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  801d34:	0f b6 01             	movzbl (%ecx),%eax
  801d37:	84 c0                	test   %al,%al
  801d39:	74 04                	je     801d3f <strcmp+0x1c>
  801d3b:	3a 02                	cmp    (%edx),%al
  801d3d:	74 ef                	je     801d2e <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801d3f:	0f b6 c0             	movzbl %al,%eax
  801d42:	0f b6 12             	movzbl (%edx),%edx
  801d45:	29 d0                	sub    %edx,%eax
}
  801d47:	5d                   	pop    %ebp
  801d48:	c3                   	ret    

00801d49 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801d49:	55                   	push   %ebp
  801d4a:	89 e5                	mov    %esp,%ebp
  801d4c:	53                   	push   %ebx
  801d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d50:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d53:	89 c3                	mov    %eax,%ebx
  801d55:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  801d58:	eb 06                	jmp    801d60 <strncmp+0x17>
		n--, p++, q++;
  801d5a:	83 c0 01             	add    $0x1,%eax
  801d5d:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  801d60:	39 d8                	cmp    %ebx,%eax
  801d62:	74 16                	je     801d7a <strncmp+0x31>
  801d64:	0f b6 08             	movzbl (%eax),%ecx
  801d67:	84 c9                	test   %cl,%cl
  801d69:	74 04                	je     801d6f <strncmp+0x26>
  801d6b:	3a 0a                	cmp    (%edx),%cl
  801d6d:	74 eb                	je     801d5a <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801d6f:	0f b6 00             	movzbl (%eax),%eax
  801d72:	0f b6 12             	movzbl (%edx),%edx
  801d75:	29 d0                	sub    %edx,%eax
}
  801d77:	5b                   	pop    %ebx
  801d78:	5d                   	pop    %ebp
  801d79:	c3                   	ret    
		return 0;
  801d7a:	b8 00 00 00 00       	mov    $0x0,%eax
  801d7f:	eb f6                	jmp    801d77 <strncmp+0x2e>

00801d81 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801d81:	55                   	push   %ebp
  801d82:	89 e5                	mov    %esp,%ebp
  801d84:	8b 45 08             	mov    0x8(%ebp),%eax
  801d87:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801d8b:	0f b6 10             	movzbl (%eax),%edx
  801d8e:	84 d2                	test   %dl,%dl
  801d90:	74 09                	je     801d9b <strchr+0x1a>
		if (*s == c)
  801d92:	38 ca                	cmp    %cl,%dl
  801d94:	74 0a                	je     801da0 <strchr+0x1f>
	for (; *s; s++)
  801d96:	83 c0 01             	add    $0x1,%eax
  801d99:	eb f0                	jmp    801d8b <strchr+0xa>
			return (char *) s;
	return 0;
  801d9b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801da0:	5d                   	pop    %ebp
  801da1:	c3                   	ret    

00801da2 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801da2:	55                   	push   %ebp
  801da3:	89 e5                	mov    %esp,%ebp
  801da5:	8b 45 08             	mov    0x8(%ebp),%eax
  801da8:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801dac:	eb 03                	jmp    801db1 <strfind+0xf>
  801dae:	83 c0 01             	add    $0x1,%eax
  801db1:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  801db4:	38 ca                	cmp    %cl,%dl
  801db6:	74 04                	je     801dbc <strfind+0x1a>
  801db8:	84 d2                	test   %dl,%dl
  801dba:	75 f2                	jne    801dae <strfind+0xc>
			break;
	return (char *) s;
}
  801dbc:	5d                   	pop    %ebp
  801dbd:	c3                   	ret    

00801dbe <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801dbe:	55                   	push   %ebp
  801dbf:	89 e5                	mov    %esp,%ebp
  801dc1:	57                   	push   %edi
  801dc2:	56                   	push   %esi
  801dc3:	53                   	push   %ebx
  801dc4:	8b 7d 08             	mov    0x8(%ebp),%edi
  801dc7:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801dca:	85 c9                	test   %ecx,%ecx
  801dcc:	74 13                	je     801de1 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801dce:	f7 c7 03 00 00 00    	test   $0x3,%edi
  801dd4:	75 05                	jne    801ddb <memset+0x1d>
  801dd6:	f6 c1 03             	test   $0x3,%cl
  801dd9:	74 0d                	je     801de8 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801ddb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dde:	fc                   	cld    
  801ddf:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801de1:	89 f8                	mov    %edi,%eax
  801de3:	5b                   	pop    %ebx
  801de4:	5e                   	pop    %esi
  801de5:	5f                   	pop    %edi
  801de6:	5d                   	pop    %ebp
  801de7:	c3                   	ret    
		c &= 0xFF;
  801de8:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801dec:	89 d3                	mov    %edx,%ebx
  801dee:	c1 e3 08             	shl    $0x8,%ebx
  801df1:	89 d0                	mov    %edx,%eax
  801df3:	c1 e0 18             	shl    $0x18,%eax
  801df6:	89 d6                	mov    %edx,%esi
  801df8:	c1 e6 10             	shl    $0x10,%esi
  801dfb:	09 f0                	or     %esi,%eax
  801dfd:	09 c2                	or     %eax,%edx
  801dff:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  801e01:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  801e04:	89 d0                	mov    %edx,%eax
  801e06:	fc                   	cld    
  801e07:	f3 ab                	rep stos %eax,%es:(%edi)
  801e09:	eb d6                	jmp    801de1 <memset+0x23>

00801e0b <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801e0b:	55                   	push   %ebp
  801e0c:	89 e5                	mov    %esp,%ebp
  801e0e:	57                   	push   %edi
  801e0f:	56                   	push   %esi
  801e10:	8b 45 08             	mov    0x8(%ebp),%eax
  801e13:	8b 75 0c             	mov    0xc(%ebp),%esi
  801e16:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801e19:	39 c6                	cmp    %eax,%esi
  801e1b:	73 35                	jae    801e52 <memmove+0x47>
  801e1d:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801e20:	39 c2                	cmp    %eax,%edx
  801e22:	76 2e                	jbe    801e52 <memmove+0x47>
		s += n;
		d += n;
  801e24:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801e27:	89 d6                	mov    %edx,%esi
  801e29:	09 fe                	or     %edi,%esi
  801e2b:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801e31:	74 0c                	je     801e3f <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801e33:	83 ef 01             	sub    $0x1,%edi
  801e36:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  801e39:	fd                   	std    
  801e3a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801e3c:	fc                   	cld    
  801e3d:	eb 21                	jmp    801e60 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801e3f:	f6 c1 03             	test   $0x3,%cl
  801e42:	75 ef                	jne    801e33 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801e44:	83 ef 04             	sub    $0x4,%edi
  801e47:	8d 72 fc             	lea    -0x4(%edx),%esi
  801e4a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  801e4d:	fd                   	std    
  801e4e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801e50:	eb ea                	jmp    801e3c <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801e52:	89 f2                	mov    %esi,%edx
  801e54:	09 c2                	or     %eax,%edx
  801e56:	f6 c2 03             	test   $0x3,%dl
  801e59:	74 09                	je     801e64 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801e5b:	89 c7                	mov    %eax,%edi
  801e5d:	fc                   	cld    
  801e5e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801e60:	5e                   	pop    %esi
  801e61:	5f                   	pop    %edi
  801e62:	5d                   	pop    %ebp
  801e63:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801e64:	f6 c1 03             	test   $0x3,%cl
  801e67:	75 f2                	jne    801e5b <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801e69:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  801e6c:	89 c7                	mov    %eax,%edi
  801e6e:	fc                   	cld    
  801e6f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801e71:	eb ed                	jmp    801e60 <memmove+0x55>

00801e73 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801e73:	55                   	push   %ebp
  801e74:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  801e76:	ff 75 10             	pushl  0x10(%ebp)
  801e79:	ff 75 0c             	pushl  0xc(%ebp)
  801e7c:	ff 75 08             	pushl  0x8(%ebp)
  801e7f:	e8 87 ff ff ff       	call   801e0b <memmove>
}
  801e84:	c9                   	leave  
  801e85:	c3                   	ret    

00801e86 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801e86:	55                   	push   %ebp
  801e87:	89 e5                	mov    %esp,%ebp
  801e89:	56                   	push   %esi
  801e8a:	53                   	push   %ebx
  801e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e91:	89 c6                	mov    %eax,%esi
  801e93:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801e96:	39 f0                	cmp    %esi,%eax
  801e98:	74 1c                	je     801eb6 <memcmp+0x30>
		if (*s1 != *s2)
  801e9a:	0f b6 08             	movzbl (%eax),%ecx
  801e9d:	0f b6 1a             	movzbl (%edx),%ebx
  801ea0:	38 d9                	cmp    %bl,%cl
  801ea2:	75 08                	jne    801eac <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801ea4:	83 c0 01             	add    $0x1,%eax
  801ea7:	83 c2 01             	add    $0x1,%edx
  801eaa:	eb ea                	jmp    801e96 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  801eac:	0f b6 c1             	movzbl %cl,%eax
  801eaf:	0f b6 db             	movzbl %bl,%ebx
  801eb2:	29 d8                	sub    %ebx,%eax
  801eb4:	eb 05                	jmp    801ebb <memcmp+0x35>
	}

	return 0;
  801eb6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ebb:	5b                   	pop    %ebx
  801ebc:	5e                   	pop    %esi
  801ebd:	5d                   	pop    %ebp
  801ebe:	c3                   	ret    

00801ebf <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801ebf:	55                   	push   %ebp
  801ec0:	89 e5                	mov    %esp,%ebp
  801ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801ec8:	89 c2                	mov    %eax,%edx
  801eca:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801ecd:	39 d0                	cmp    %edx,%eax
  801ecf:	73 09                	jae    801eda <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  801ed1:	38 08                	cmp    %cl,(%eax)
  801ed3:	74 05                	je     801eda <memfind+0x1b>
	for (; s < ends; s++)
  801ed5:	83 c0 01             	add    $0x1,%eax
  801ed8:	eb f3                	jmp    801ecd <memfind+0xe>
			break;
	return (void *) s;
}
  801eda:	5d                   	pop    %ebp
  801edb:	c3                   	ret    

00801edc <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801edc:	55                   	push   %ebp
  801edd:	89 e5                	mov    %esp,%ebp
  801edf:	57                   	push   %edi
  801ee0:	56                   	push   %esi
  801ee1:	53                   	push   %ebx
  801ee2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ee5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801ee8:	eb 03                	jmp    801eed <strtol+0x11>
		s++;
  801eea:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  801eed:	0f b6 01             	movzbl (%ecx),%eax
  801ef0:	3c 20                	cmp    $0x20,%al
  801ef2:	74 f6                	je     801eea <strtol+0xe>
  801ef4:	3c 09                	cmp    $0x9,%al
  801ef6:	74 f2                	je     801eea <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  801ef8:	3c 2b                	cmp    $0x2b,%al
  801efa:	74 2e                	je     801f2a <strtol+0x4e>
	int neg = 0;
  801efc:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801f01:	3c 2d                	cmp    $0x2d,%al
  801f03:	74 2f                	je     801f34 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801f05:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  801f0b:	75 05                	jne    801f12 <strtol+0x36>
  801f0d:	80 39 30             	cmpb   $0x30,(%ecx)
  801f10:	74 2c                	je     801f3e <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  801f12:	85 db                	test   %ebx,%ebx
  801f14:	75 0a                	jne    801f20 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801f16:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  801f1b:	80 39 30             	cmpb   $0x30,(%ecx)
  801f1e:	74 28                	je     801f48 <strtol+0x6c>
		base = 10;
  801f20:	b8 00 00 00 00       	mov    $0x0,%eax
  801f25:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801f28:	eb 50                	jmp    801f7a <strtol+0x9e>
		s++;
  801f2a:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  801f2d:	bf 00 00 00 00       	mov    $0x0,%edi
  801f32:	eb d1                	jmp    801f05 <strtol+0x29>
		s++, neg = 1;
  801f34:	83 c1 01             	add    $0x1,%ecx
  801f37:	bf 01 00 00 00       	mov    $0x1,%edi
  801f3c:	eb c7                	jmp    801f05 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801f3e:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801f42:	74 0e                	je     801f52 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  801f44:	85 db                	test   %ebx,%ebx
  801f46:	75 d8                	jne    801f20 <strtol+0x44>
		s++, base = 8;
  801f48:	83 c1 01             	add    $0x1,%ecx
  801f4b:	bb 08 00 00 00       	mov    $0x8,%ebx
  801f50:	eb ce                	jmp    801f20 <strtol+0x44>
		s += 2, base = 16;
  801f52:	83 c1 02             	add    $0x2,%ecx
  801f55:	bb 10 00 00 00       	mov    $0x10,%ebx
  801f5a:	eb c4                	jmp    801f20 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  801f5c:	8d 72 9f             	lea    -0x61(%edx),%esi
  801f5f:	89 f3                	mov    %esi,%ebx
  801f61:	80 fb 19             	cmp    $0x19,%bl
  801f64:	77 29                	ja     801f8f <strtol+0xb3>
			dig = *s - 'a' + 10;
  801f66:	0f be d2             	movsbl %dl,%edx
  801f69:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801f6c:	3b 55 10             	cmp    0x10(%ebp),%edx
  801f6f:	7d 30                	jge    801fa1 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  801f71:	83 c1 01             	add    $0x1,%ecx
  801f74:	0f af 45 10          	imul   0x10(%ebp),%eax
  801f78:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801f7a:	0f b6 11             	movzbl (%ecx),%edx
  801f7d:	8d 72 d0             	lea    -0x30(%edx),%esi
  801f80:	89 f3                	mov    %esi,%ebx
  801f82:	80 fb 09             	cmp    $0x9,%bl
  801f85:	77 d5                	ja     801f5c <strtol+0x80>
			dig = *s - '0';
  801f87:	0f be d2             	movsbl %dl,%edx
  801f8a:	83 ea 30             	sub    $0x30,%edx
  801f8d:	eb dd                	jmp    801f6c <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  801f8f:	8d 72 bf             	lea    -0x41(%edx),%esi
  801f92:	89 f3                	mov    %esi,%ebx
  801f94:	80 fb 19             	cmp    $0x19,%bl
  801f97:	77 08                	ja     801fa1 <strtol+0xc5>
			dig = *s - 'A' + 10;
  801f99:	0f be d2             	movsbl %dl,%edx
  801f9c:	83 ea 37             	sub    $0x37,%edx
  801f9f:	eb cb                	jmp    801f6c <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  801fa1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801fa5:	74 05                	je     801fac <strtol+0xd0>
		*endptr = (char *) s;
  801fa7:	8b 75 0c             	mov    0xc(%ebp),%esi
  801faa:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801fac:	89 c2                	mov    %eax,%edx
  801fae:	f7 da                	neg    %edx
  801fb0:	85 ff                	test   %edi,%edi
  801fb2:	0f 45 c2             	cmovne %edx,%eax
}
  801fb5:	5b                   	pop    %ebx
  801fb6:	5e                   	pop    %esi
  801fb7:	5f                   	pop    %edi
  801fb8:	5d                   	pop    %ebp
  801fb9:	c3                   	ret    

00801fba <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801fba:	55                   	push   %ebp
  801fbb:	89 e5                	mov    %esp,%ebp
  801fbd:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  801fc0:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  801fc7:	74 0a                	je     801fd3 <set_pgfault_handler+0x19>
		    panic("set_pgfault_handler: %e", r);
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801fc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fcc:	a3 00 70 80 00       	mov    %eax,0x807000
}
  801fd1:	c9                   	leave  
  801fd2:	c3                   	ret    
		if ((r = sys_page_alloc(thisenv->env_id, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P)) != 0) {
  801fd3:	a1 08 40 80 00       	mov    0x804008,%eax
  801fd8:	8b 40 48             	mov    0x48(%eax),%eax
  801fdb:	83 ec 04             	sub    $0x4,%esp
  801fde:	6a 07                	push   $0x7
  801fe0:	68 00 f0 bf ee       	push   $0xeebff000
  801fe5:	50                   	push   %eax
  801fe6:	e8 85 e1 ff ff       	call   800170 <sys_page_alloc>
  801feb:	83 c4 10             	add    $0x10,%esp
  801fee:	85 c0                	test   %eax,%eax
  801ff0:	75 2f                	jne    802021 <set_pgfault_handler+0x67>
		if ((r = sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall)) != 0) {
  801ff2:	a1 08 40 80 00       	mov    0x804008,%eax
  801ff7:	8b 40 48             	mov    0x48(%eax),%eax
  801ffa:	83 ec 08             	sub    $0x8,%esp
  801ffd:	68 80 03 80 00       	push   $0x800380
  802002:	50                   	push   %eax
  802003:	e8 b3 e2 ff ff       	call   8002bb <sys_env_set_pgfault_upcall>
  802008:	83 c4 10             	add    $0x10,%esp
  80200b:	85 c0                	test   %eax,%eax
  80200d:	74 ba                	je     801fc9 <set_pgfault_handler+0xf>
		    panic("set_pgfault_handler: %e", r);
  80200f:	50                   	push   %eax
  802010:	68 80 28 80 00       	push   $0x802880
  802015:	6a 24                	push   $0x24
  802017:	68 98 28 80 00       	push   $0x802898
  80201c:	e8 e4 f4 ff ff       	call   801505 <_panic>
		    panic("set_pgfault_handler: %e", r);
  802021:	50                   	push   %eax
  802022:	68 80 28 80 00       	push   $0x802880
  802027:	6a 21                	push   $0x21
  802029:	68 98 28 80 00       	push   $0x802898
  80202e:	e8 d2 f4 ff ff       	call   801505 <_panic>

00802033 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802033:	55                   	push   %ebp
  802034:	89 e5                	mov    %esp,%ebp
  802036:	56                   	push   %esi
  802037:	53                   	push   %ebx
  802038:	8b 75 08             	mov    0x8(%ebp),%esi
  80203b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80203e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
  802041:	85 c0                	test   %eax,%eax
	    pg = (void *)UTOP;
  802043:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802048:	0f 44 c2             	cmove  %edx,%eax
	}
	if ((r = sys_ipc_recv(pg)) < 0) {
  80204b:	83 ec 0c             	sub    $0xc,%esp
  80204e:	50                   	push   %eax
  80204f:	e8 cc e2 ff ff       	call   800320 <sys_ipc_recv>
  802054:	83 c4 10             	add    $0x10,%esp
  802057:	85 c0                	test   %eax,%eax
  802059:	78 2b                	js     802086 <ipc_recv+0x53>
	    if (perm_store != NULL) {
	        *perm_store = 0;
	    }
	    return r;
	}
	if (from_env_store != NULL) {
  80205b:	85 f6                	test   %esi,%esi
  80205d:	74 0a                	je     802069 <ipc_recv+0x36>
	    *from_env_store = thisenv->env_ipc_from;
  80205f:	a1 08 40 80 00       	mov    0x804008,%eax
  802064:	8b 40 74             	mov    0x74(%eax),%eax
  802067:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store != NULL) {
  802069:	85 db                	test   %ebx,%ebx
  80206b:	74 0a                	je     802077 <ipc_recv+0x44>
	    *perm_store = thisenv->env_ipc_perm;
  80206d:	a1 08 40 80 00       	mov    0x804008,%eax
  802072:	8b 40 78             	mov    0x78(%eax),%eax
  802075:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  802077:	a1 08 40 80 00       	mov    0x804008,%eax
  80207c:	8b 40 70             	mov    0x70(%eax),%eax
}
  80207f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802082:	5b                   	pop    %ebx
  802083:	5e                   	pop    %esi
  802084:	5d                   	pop    %ebp
  802085:	c3                   	ret    
	    if (from_env_store != NULL) {
  802086:	85 f6                	test   %esi,%esi
  802088:	74 06                	je     802090 <ipc_recv+0x5d>
	        *from_env_store = 0;
  80208a:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	    if (perm_store != NULL) {
  802090:	85 db                	test   %ebx,%ebx
  802092:	74 eb                	je     80207f <ipc_recv+0x4c>
	        *perm_store = 0;
  802094:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80209a:	eb e3                	jmp    80207f <ipc_recv+0x4c>

0080209c <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80209c:	55                   	push   %ebp
  80209d:	89 e5                	mov    %esp,%ebp
  80209f:	57                   	push   %edi
  8020a0:	56                   	push   %esi
  8020a1:	53                   	push   %ebx
  8020a2:	83 ec 0c             	sub    $0xc,%esp
  8020a5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8020a8:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
	    pg = (void *)UTOP;
  8020ab:	85 f6                	test   %esi,%esi
  8020ad:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8020b2:	0f 44 f0             	cmove  %eax,%esi
  8020b5:	eb 09                	jmp    8020c0 <ipc_send+0x24>
	do {
	    r = sys_ipc_try_send(to_env, val, pg, perm);
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
	        panic("ipc_send: %e", r);
	    }
	    sys_yield();
  8020b7:	e8 95 e0 ff ff       	call   800151 <sys_yield>
	} while(r != 0);
  8020bc:	85 db                	test   %ebx,%ebx
  8020be:	74 2d                	je     8020ed <ipc_send+0x51>
	    r = sys_ipc_try_send(to_env, val, pg, perm);
  8020c0:	ff 75 14             	pushl  0x14(%ebp)
  8020c3:	56                   	push   %esi
  8020c4:	ff 75 0c             	pushl  0xc(%ebp)
  8020c7:	57                   	push   %edi
  8020c8:	e8 30 e2 ff ff       	call   8002fd <sys_ipc_try_send>
  8020cd:	89 c3                	mov    %eax,%ebx
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
  8020cf:	83 c4 10             	add    $0x10,%esp
  8020d2:	85 c0                	test   %eax,%eax
  8020d4:	79 e1                	jns    8020b7 <ipc_send+0x1b>
  8020d6:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8020d9:	74 dc                	je     8020b7 <ipc_send+0x1b>
	        panic("ipc_send: %e", r);
  8020db:	50                   	push   %eax
  8020dc:	68 a6 28 80 00       	push   $0x8028a6
  8020e1:	6a 45                	push   $0x45
  8020e3:	68 b3 28 80 00       	push   $0x8028b3
  8020e8:	e8 18 f4 ff ff       	call   801505 <_panic>
}
  8020ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020f0:	5b                   	pop    %ebx
  8020f1:	5e                   	pop    %esi
  8020f2:	5f                   	pop    %edi
  8020f3:	5d                   	pop    %ebp
  8020f4:	c3                   	ret    

008020f5 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8020f5:	55                   	push   %ebp
  8020f6:	89 e5                	mov    %esp,%ebp
  8020f8:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8020fb:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802100:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802103:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802109:	8b 52 50             	mov    0x50(%edx),%edx
  80210c:	39 ca                	cmp    %ecx,%edx
  80210e:	74 11                	je     802121 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  802110:	83 c0 01             	add    $0x1,%eax
  802113:	3d 00 04 00 00       	cmp    $0x400,%eax
  802118:	75 e6                	jne    802100 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80211a:	b8 00 00 00 00       	mov    $0x0,%eax
  80211f:	eb 0b                	jmp    80212c <ipc_find_env+0x37>
			return envs[i].env_id;
  802121:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802124:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802129:	8b 40 48             	mov    0x48(%eax),%eax
}
  80212c:	5d                   	pop    %ebp
  80212d:	c3                   	ret    

0080212e <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80212e:	55                   	push   %ebp
  80212f:	89 e5                	mov    %esp,%ebp
  802131:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802134:	89 d0                	mov    %edx,%eax
  802136:	c1 e8 16             	shr    $0x16,%eax
  802139:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802140:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802145:	f6 c1 01             	test   $0x1,%cl
  802148:	74 1d                	je     802167 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80214a:	c1 ea 0c             	shr    $0xc,%edx
  80214d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802154:	f6 c2 01             	test   $0x1,%dl
  802157:	74 0e                	je     802167 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802159:	c1 ea 0c             	shr    $0xc,%edx
  80215c:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802163:	ef 
  802164:	0f b7 c0             	movzwl %ax,%eax
}
  802167:	5d                   	pop    %ebp
  802168:	c3                   	ret    
  802169:	66 90                	xchg   %ax,%ax
  80216b:	66 90                	xchg   %ax,%ax
  80216d:	66 90                	xchg   %ax,%ax
  80216f:	90                   	nop

00802170 <__udivdi3>:
  802170:	55                   	push   %ebp
  802171:	57                   	push   %edi
  802172:	56                   	push   %esi
  802173:	53                   	push   %ebx
  802174:	83 ec 1c             	sub    $0x1c,%esp
  802177:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80217b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80217f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802183:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802187:	85 d2                	test   %edx,%edx
  802189:	75 35                	jne    8021c0 <__udivdi3+0x50>
  80218b:	39 f3                	cmp    %esi,%ebx
  80218d:	0f 87 bd 00 00 00    	ja     802250 <__udivdi3+0xe0>
  802193:	85 db                	test   %ebx,%ebx
  802195:	89 d9                	mov    %ebx,%ecx
  802197:	75 0b                	jne    8021a4 <__udivdi3+0x34>
  802199:	b8 01 00 00 00       	mov    $0x1,%eax
  80219e:	31 d2                	xor    %edx,%edx
  8021a0:	f7 f3                	div    %ebx
  8021a2:	89 c1                	mov    %eax,%ecx
  8021a4:	31 d2                	xor    %edx,%edx
  8021a6:	89 f0                	mov    %esi,%eax
  8021a8:	f7 f1                	div    %ecx
  8021aa:	89 c6                	mov    %eax,%esi
  8021ac:	89 e8                	mov    %ebp,%eax
  8021ae:	89 f7                	mov    %esi,%edi
  8021b0:	f7 f1                	div    %ecx
  8021b2:	89 fa                	mov    %edi,%edx
  8021b4:	83 c4 1c             	add    $0x1c,%esp
  8021b7:	5b                   	pop    %ebx
  8021b8:	5e                   	pop    %esi
  8021b9:	5f                   	pop    %edi
  8021ba:	5d                   	pop    %ebp
  8021bb:	c3                   	ret    
  8021bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8021c0:	39 f2                	cmp    %esi,%edx
  8021c2:	77 7c                	ja     802240 <__udivdi3+0xd0>
  8021c4:	0f bd fa             	bsr    %edx,%edi
  8021c7:	83 f7 1f             	xor    $0x1f,%edi
  8021ca:	0f 84 98 00 00 00    	je     802268 <__udivdi3+0xf8>
  8021d0:	89 f9                	mov    %edi,%ecx
  8021d2:	b8 20 00 00 00       	mov    $0x20,%eax
  8021d7:	29 f8                	sub    %edi,%eax
  8021d9:	d3 e2                	shl    %cl,%edx
  8021db:	89 54 24 08          	mov    %edx,0x8(%esp)
  8021df:	89 c1                	mov    %eax,%ecx
  8021e1:	89 da                	mov    %ebx,%edx
  8021e3:	d3 ea                	shr    %cl,%edx
  8021e5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8021e9:	09 d1                	or     %edx,%ecx
  8021eb:	89 f2                	mov    %esi,%edx
  8021ed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8021f1:	89 f9                	mov    %edi,%ecx
  8021f3:	d3 e3                	shl    %cl,%ebx
  8021f5:	89 c1                	mov    %eax,%ecx
  8021f7:	d3 ea                	shr    %cl,%edx
  8021f9:	89 f9                	mov    %edi,%ecx
  8021fb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8021ff:	d3 e6                	shl    %cl,%esi
  802201:	89 eb                	mov    %ebp,%ebx
  802203:	89 c1                	mov    %eax,%ecx
  802205:	d3 eb                	shr    %cl,%ebx
  802207:	09 de                	or     %ebx,%esi
  802209:	89 f0                	mov    %esi,%eax
  80220b:	f7 74 24 08          	divl   0x8(%esp)
  80220f:	89 d6                	mov    %edx,%esi
  802211:	89 c3                	mov    %eax,%ebx
  802213:	f7 64 24 0c          	mull   0xc(%esp)
  802217:	39 d6                	cmp    %edx,%esi
  802219:	72 0c                	jb     802227 <__udivdi3+0xb7>
  80221b:	89 f9                	mov    %edi,%ecx
  80221d:	d3 e5                	shl    %cl,%ebp
  80221f:	39 c5                	cmp    %eax,%ebp
  802221:	73 5d                	jae    802280 <__udivdi3+0x110>
  802223:	39 d6                	cmp    %edx,%esi
  802225:	75 59                	jne    802280 <__udivdi3+0x110>
  802227:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80222a:	31 ff                	xor    %edi,%edi
  80222c:	89 fa                	mov    %edi,%edx
  80222e:	83 c4 1c             	add    $0x1c,%esp
  802231:	5b                   	pop    %ebx
  802232:	5e                   	pop    %esi
  802233:	5f                   	pop    %edi
  802234:	5d                   	pop    %ebp
  802235:	c3                   	ret    
  802236:	8d 76 00             	lea    0x0(%esi),%esi
  802239:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  802240:	31 ff                	xor    %edi,%edi
  802242:	31 c0                	xor    %eax,%eax
  802244:	89 fa                	mov    %edi,%edx
  802246:	83 c4 1c             	add    $0x1c,%esp
  802249:	5b                   	pop    %ebx
  80224a:	5e                   	pop    %esi
  80224b:	5f                   	pop    %edi
  80224c:	5d                   	pop    %ebp
  80224d:	c3                   	ret    
  80224e:	66 90                	xchg   %ax,%ax
  802250:	31 ff                	xor    %edi,%edi
  802252:	89 e8                	mov    %ebp,%eax
  802254:	89 f2                	mov    %esi,%edx
  802256:	f7 f3                	div    %ebx
  802258:	89 fa                	mov    %edi,%edx
  80225a:	83 c4 1c             	add    $0x1c,%esp
  80225d:	5b                   	pop    %ebx
  80225e:	5e                   	pop    %esi
  80225f:	5f                   	pop    %edi
  802260:	5d                   	pop    %ebp
  802261:	c3                   	ret    
  802262:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802268:	39 f2                	cmp    %esi,%edx
  80226a:	72 06                	jb     802272 <__udivdi3+0x102>
  80226c:	31 c0                	xor    %eax,%eax
  80226e:	39 eb                	cmp    %ebp,%ebx
  802270:	77 d2                	ja     802244 <__udivdi3+0xd4>
  802272:	b8 01 00 00 00       	mov    $0x1,%eax
  802277:	eb cb                	jmp    802244 <__udivdi3+0xd4>
  802279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802280:	89 d8                	mov    %ebx,%eax
  802282:	31 ff                	xor    %edi,%edi
  802284:	eb be                	jmp    802244 <__udivdi3+0xd4>
  802286:	66 90                	xchg   %ax,%ax
  802288:	66 90                	xchg   %ax,%ax
  80228a:	66 90                	xchg   %ax,%ax
  80228c:	66 90                	xchg   %ax,%ax
  80228e:	66 90                	xchg   %ax,%ax

00802290 <__umoddi3>:
  802290:	55                   	push   %ebp
  802291:	57                   	push   %edi
  802292:	56                   	push   %esi
  802293:	53                   	push   %ebx
  802294:	83 ec 1c             	sub    $0x1c,%esp
  802297:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  80229b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80229f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8022a3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8022a7:	85 ed                	test   %ebp,%ebp
  8022a9:	89 f0                	mov    %esi,%eax
  8022ab:	89 da                	mov    %ebx,%edx
  8022ad:	75 19                	jne    8022c8 <__umoddi3+0x38>
  8022af:	39 df                	cmp    %ebx,%edi
  8022b1:	0f 86 b1 00 00 00    	jbe    802368 <__umoddi3+0xd8>
  8022b7:	f7 f7                	div    %edi
  8022b9:	89 d0                	mov    %edx,%eax
  8022bb:	31 d2                	xor    %edx,%edx
  8022bd:	83 c4 1c             	add    $0x1c,%esp
  8022c0:	5b                   	pop    %ebx
  8022c1:	5e                   	pop    %esi
  8022c2:	5f                   	pop    %edi
  8022c3:	5d                   	pop    %ebp
  8022c4:	c3                   	ret    
  8022c5:	8d 76 00             	lea    0x0(%esi),%esi
  8022c8:	39 dd                	cmp    %ebx,%ebp
  8022ca:	77 f1                	ja     8022bd <__umoddi3+0x2d>
  8022cc:	0f bd cd             	bsr    %ebp,%ecx
  8022cf:	83 f1 1f             	xor    $0x1f,%ecx
  8022d2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8022d6:	0f 84 b4 00 00 00    	je     802390 <__umoddi3+0x100>
  8022dc:	b8 20 00 00 00       	mov    $0x20,%eax
  8022e1:	89 c2                	mov    %eax,%edx
  8022e3:	8b 44 24 04          	mov    0x4(%esp),%eax
  8022e7:	29 c2                	sub    %eax,%edx
  8022e9:	89 c1                	mov    %eax,%ecx
  8022eb:	89 f8                	mov    %edi,%eax
  8022ed:	d3 e5                	shl    %cl,%ebp
  8022ef:	89 d1                	mov    %edx,%ecx
  8022f1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8022f5:	d3 e8                	shr    %cl,%eax
  8022f7:	09 c5                	or     %eax,%ebp
  8022f9:	8b 44 24 04          	mov    0x4(%esp),%eax
  8022fd:	89 c1                	mov    %eax,%ecx
  8022ff:	d3 e7                	shl    %cl,%edi
  802301:	89 d1                	mov    %edx,%ecx
  802303:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802307:	89 df                	mov    %ebx,%edi
  802309:	d3 ef                	shr    %cl,%edi
  80230b:	89 c1                	mov    %eax,%ecx
  80230d:	89 f0                	mov    %esi,%eax
  80230f:	d3 e3                	shl    %cl,%ebx
  802311:	89 d1                	mov    %edx,%ecx
  802313:	89 fa                	mov    %edi,%edx
  802315:	d3 e8                	shr    %cl,%eax
  802317:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80231c:	09 d8                	or     %ebx,%eax
  80231e:	f7 f5                	div    %ebp
  802320:	d3 e6                	shl    %cl,%esi
  802322:	89 d1                	mov    %edx,%ecx
  802324:	f7 64 24 08          	mull   0x8(%esp)
  802328:	39 d1                	cmp    %edx,%ecx
  80232a:	89 c3                	mov    %eax,%ebx
  80232c:	89 d7                	mov    %edx,%edi
  80232e:	72 06                	jb     802336 <__umoddi3+0xa6>
  802330:	75 0e                	jne    802340 <__umoddi3+0xb0>
  802332:	39 c6                	cmp    %eax,%esi
  802334:	73 0a                	jae    802340 <__umoddi3+0xb0>
  802336:	2b 44 24 08          	sub    0x8(%esp),%eax
  80233a:	19 ea                	sbb    %ebp,%edx
  80233c:	89 d7                	mov    %edx,%edi
  80233e:	89 c3                	mov    %eax,%ebx
  802340:	89 ca                	mov    %ecx,%edx
  802342:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  802347:	29 de                	sub    %ebx,%esi
  802349:	19 fa                	sbb    %edi,%edx
  80234b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  80234f:	89 d0                	mov    %edx,%eax
  802351:	d3 e0                	shl    %cl,%eax
  802353:	89 d9                	mov    %ebx,%ecx
  802355:	d3 ee                	shr    %cl,%esi
  802357:	d3 ea                	shr    %cl,%edx
  802359:	09 f0                	or     %esi,%eax
  80235b:	83 c4 1c             	add    $0x1c,%esp
  80235e:	5b                   	pop    %ebx
  80235f:	5e                   	pop    %esi
  802360:	5f                   	pop    %edi
  802361:	5d                   	pop    %ebp
  802362:	c3                   	ret    
  802363:	90                   	nop
  802364:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802368:	85 ff                	test   %edi,%edi
  80236a:	89 f9                	mov    %edi,%ecx
  80236c:	75 0b                	jne    802379 <__umoddi3+0xe9>
  80236e:	b8 01 00 00 00       	mov    $0x1,%eax
  802373:	31 d2                	xor    %edx,%edx
  802375:	f7 f7                	div    %edi
  802377:	89 c1                	mov    %eax,%ecx
  802379:	89 d8                	mov    %ebx,%eax
  80237b:	31 d2                	xor    %edx,%edx
  80237d:	f7 f1                	div    %ecx
  80237f:	89 f0                	mov    %esi,%eax
  802381:	f7 f1                	div    %ecx
  802383:	e9 31 ff ff ff       	jmp    8022b9 <__umoddi3+0x29>
  802388:	90                   	nop
  802389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802390:	39 dd                	cmp    %ebx,%ebp
  802392:	72 08                	jb     80239c <__umoddi3+0x10c>
  802394:	39 f7                	cmp    %esi,%edi
  802396:	0f 87 21 ff ff ff    	ja     8022bd <__umoddi3+0x2d>
  80239c:	89 da                	mov    %ebx,%edx
  80239e:	89 f0                	mov    %esi,%eax
  8023a0:	29 f8                	sub    %edi,%eax
  8023a2:	19 ea                	sbb    %ebp,%edx
  8023a4:	e9 14 ff ff ff       	jmp    8022bd <__umoddi3+0x2d>
