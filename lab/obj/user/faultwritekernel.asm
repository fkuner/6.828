
obj/user/faultwritekernel.debug:     file format elf32-i386


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
  80002c:	e8 11 00 00 00       	call   800042 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
	*(unsigned*)0xf0100000 = 0;
  800036:	c7 05 00 00 10 f0 00 	movl   $0x0,0xf0100000
  80003d:	00 00 00 
}
  800040:	5d                   	pop    %ebp
  800041:	c3                   	ret    

00800042 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800042:	55                   	push   %ebp
  800043:	89 e5                	mov    %esp,%ebp
  800045:	56                   	push   %esi
  800046:	53                   	push   %ebx
  800047:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80004a:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
    thisenv = &envs[ENVX(sys_getenvid())];
  80004d:	e8 ce 00 00 00       	call   800120 <sys_getenvid>
  800052:	25 ff 03 00 00       	and    $0x3ff,%eax
  800057:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80005a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80005f:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800064:	85 db                	test   %ebx,%ebx
  800066:	7e 07                	jle    80006f <libmain+0x2d>
		binaryname = argv[0];
  800068:	8b 06                	mov    (%esi),%eax
  80006a:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80006f:	83 ec 08             	sub    $0x8,%esp
  800072:	56                   	push   %esi
  800073:	53                   	push   %ebx
  800074:	e8 ba ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800079:	e8 0a 00 00 00       	call   800088 <exit>
}
  80007e:	83 c4 10             	add    $0x10,%esp
  800081:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800084:	5b                   	pop    %ebx
  800085:	5e                   	pop    %esi
  800086:	5d                   	pop    %ebp
  800087:	c3                   	ret    

00800088 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800088:	55                   	push   %ebp
  800089:	89 e5                	mov    %esp,%ebp
  80008b:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80008e:	e8 b1 04 00 00       	call   800544 <close_all>
	sys_env_destroy(0);
  800093:	83 ec 0c             	sub    $0xc,%esp
  800096:	6a 00                	push   $0x0
  800098:	e8 42 00 00 00       	call   8000df <sys_env_destroy>
}
  80009d:	83 c4 10             	add    $0x10,%esp
  8000a0:	c9                   	leave  
  8000a1:	c3                   	ret    

008000a2 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000a2:	55                   	push   %ebp
  8000a3:	89 e5                	mov    %esp,%ebp
  8000a5:	57                   	push   %edi
  8000a6:	56                   	push   %esi
  8000a7:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8000b0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000b3:	89 c3                	mov    %eax,%ebx
  8000b5:	89 c7                	mov    %eax,%edi
  8000b7:	89 c6                	mov    %eax,%esi
  8000b9:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000bb:	5b                   	pop    %ebx
  8000bc:	5e                   	pop    %esi
  8000bd:	5f                   	pop    %edi
  8000be:	5d                   	pop    %ebp
  8000bf:	c3                   	ret    

008000c0 <sys_cgetc>:

int
sys_cgetc(void)
{
  8000c0:	55                   	push   %ebp
  8000c1:	89 e5                	mov    %esp,%ebp
  8000c3:	57                   	push   %edi
  8000c4:	56                   	push   %esi
  8000c5:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8000cb:	b8 01 00 00 00       	mov    $0x1,%eax
  8000d0:	89 d1                	mov    %edx,%ecx
  8000d2:	89 d3                	mov    %edx,%ebx
  8000d4:	89 d7                	mov    %edx,%edi
  8000d6:	89 d6                	mov    %edx,%esi
  8000d8:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000da:	5b                   	pop    %ebx
  8000db:	5e                   	pop    %esi
  8000dc:	5f                   	pop    %edi
  8000dd:	5d                   	pop    %ebp
  8000de:	c3                   	ret    

008000df <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000df:	55                   	push   %ebp
  8000e0:	89 e5                	mov    %esp,%ebp
  8000e2:	57                   	push   %edi
  8000e3:	56                   	push   %esi
  8000e4:	53                   	push   %ebx
  8000e5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8000e8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8000f0:	b8 03 00 00 00       	mov    $0x3,%eax
  8000f5:	89 cb                	mov    %ecx,%ebx
  8000f7:	89 cf                	mov    %ecx,%edi
  8000f9:	89 ce                	mov    %ecx,%esi
  8000fb:	cd 30                	int    $0x30
	if(check && ret > 0)
  8000fd:	85 c0                	test   %eax,%eax
  8000ff:	7f 08                	jg     800109 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800101:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800104:	5b                   	pop    %ebx
  800105:	5e                   	pop    %esi
  800106:	5f                   	pop    %edi
  800107:	5d                   	pop    %ebp
  800108:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800109:	83 ec 0c             	sub    $0xc,%esp
  80010c:	50                   	push   %eax
  80010d:	6a 03                	push   $0x3
  80010f:	68 0a 23 80 00       	push   $0x80230a
  800114:	6a 23                	push   $0x23
  800116:	68 27 23 80 00       	push   $0x802327
  80011b:	e8 ad 13 00 00       	call   8014cd <_panic>

00800120 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800120:	55                   	push   %ebp
  800121:	89 e5                	mov    %esp,%ebp
  800123:	57                   	push   %edi
  800124:	56                   	push   %esi
  800125:	53                   	push   %ebx
	asm volatile("int %1\n"
  800126:	ba 00 00 00 00       	mov    $0x0,%edx
  80012b:	b8 02 00 00 00       	mov    $0x2,%eax
  800130:	89 d1                	mov    %edx,%ecx
  800132:	89 d3                	mov    %edx,%ebx
  800134:	89 d7                	mov    %edx,%edi
  800136:	89 d6                	mov    %edx,%esi
  800138:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80013a:	5b                   	pop    %ebx
  80013b:	5e                   	pop    %esi
  80013c:	5f                   	pop    %edi
  80013d:	5d                   	pop    %ebp
  80013e:	c3                   	ret    

0080013f <sys_yield>:

void
sys_yield(void)
{
  80013f:	55                   	push   %ebp
  800140:	89 e5                	mov    %esp,%ebp
  800142:	57                   	push   %edi
  800143:	56                   	push   %esi
  800144:	53                   	push   %ebx
	asm volatile("int %1\n"
  800145:	ba 00 00 00 00       	mov    $0x0,%edx
  80014a:	b8 0b 00 00 00       	mov    $0xb,%eax
  80014f:	89 d1                	mov    %edx,%ecx
  800151:	89 d3                	mov    %edx,%ebx
  800153:	89 d7                	mov    %edx,%edi
  800155:	89 d6                	mov    %edx,%esi
  800157:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800159:	5b                   	pop    %ebx
  80015a:	5e                   	pop    %esi
  80015b:	5f                   	pop    %edi
  80015c:	5d                   	pop    %ebp
  80015d:	c3                   	ret    

0080015e <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80015e:	55                   	push   %ebp
  80015f:	89 e5                	mov    %esp,%ebp
  800161:	57                   	push   %edi
  800162:	56                   	push   %esi
  800163:	53                   	push   %ebx
  800164:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800167:	be 00 00 00 00       	mov    $0x0,%esi
  80016c:	8b 55 08             	mov    0x8(%ebp),%edx
  80016f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800172:	b8 04 00 00 00       	mov    $0x4,%eax
  800177:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80017a:	89 f7                	mov    %esi,%edi
  80017c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80017e:	85 c0                	test   %eax,%eax
  800180:	7f 08                	jg     80018a <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800182:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800185:	5b                   	pop    %ebx
  800186:	5e                   	pop    %esi
  800187:	5f                   	pop    %edi
  800188:	5d                   	pop    %ebp
  800189:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80018a:	83 ec 0c             	sub    $0xc,%esp
  80018d:	50                   	push   %eax
  80018e:	6a 04                	push   $0x4
  800190:	68 0a 23 80 00       	push   $0x80230a
  800195:	6a 23                	push   $0x23
  800197:	68 27 23 80 00       	push   $0x802327
  80019c:	e8 2c 13 00 00       	call   8014cd <_panic>

008001a1 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001a1:	55                   	push   %ebp
  8001a2:	89 e5                	mov    %esp,%ebp
  8001a4:	57                   	push   %edi
  8001a5:	56                   	push   %esi
  8001a6:	53                   	push   %ebx
  8001a7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8001ad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001b0:	b8 05 00 00 00       	mov    $0x5,%eax
  8001b5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001b8:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001bb:	8b 75 18             	mov    0x18(%ebp),%esi
  8001be:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001c0:	85 c0                	test   %eax,%eax
  8001c2:	7f 08                	jg     8001cc <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001c7:	5b                   	pop    %ebx
  8001c8:	5e                   	pop    %esi
  8001c9:	5f                   	pop    %edi
  8001ca:	5d                   	pop    %ebp
  8001cb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001cc:	83 ec 0c             	sub    $0xc,%esp
  8001cf:	50                   	push   %eax
  8001d0:	6a 05                	push   $0x5
  8001d2:	68 0a 23 80 00       	push   $0x80230a
  8001d7:	6a 23                	push   $0x23
  8001d9:	68 27 23 80 00       	push   $0x802327
  8001de:	e8 ea 12 00 00       	call   8014cd <_panic>

008001e3 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001e3:	55                   	push   %ebp
  8001e4:	89 e5                	mov    %esp,%ebp
  8001e6:	57                   	push   %edi
  8001e7:	56                   	push   %esi
  8001e8:	53                   	push   %ebx
  8001e9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001ec:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8001f4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001f7:	b8 06 00 00 00       	mov    $0x6,%eax
  8001fc:	89 df                	mov    %ebx,%edi
  8001fe:	89 de                	mov    %ebx,%esi
  800200:	cd 30                	int    $0x30
	if(check && ret > 0)
  800202:	85 c0                	test   %eax,%eax
  800204:	7f 08                	jg     80020e <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800206:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800209:	5b                   	pop    %ebx
  80020a:	5e                   	pop    %esi
  80020b:	5f                   	pop    %edi
  80020c:	5d                   	pop    %ebp
  80020d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80020e:	83 ec 0c             	sub    $0xc,%esp
  800211:	50                   	push   %eax
  800212:	6a 06                	push   $0x6
  800214:	68 0a 23 80 00       	push   $0x80230a
  800219:	6a 23                	push   $0x23
  80021b:	68 27 23 80 00       	push   $0x802327
  800220:	e8 a8 12 00 00       	call   8014cd <_panic>

00800225 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800225:	55                   	push   %ebp
  800226:	89 e5                	mov    %esp,%ebp
  800228:	57                   	push   %edi
  800229:	56                   	push   %esi
  80022a:	53                   	push   %ebx
  80022b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80022e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800233:	8b 55 08             	mov    0x8(%ebp),%edx
  800236:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800239:	b8 08 00 00 00       	mov    $0x8,%eax
  80023e:	89 df                	mov    %ebx,%edi
  800240:	89 de                	mov    %ebx,%esi
  800242:	cd 30                	int    $0x30
	if(check && ret > 0)
  800244:	85 c0                	test   %eax,%eax
  800246:	7f 08                	jg     800250 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800248:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80024b:	5b                   	pop    %ebx
  80024c:	5e                   	pop    %esi
  80024d:	5f                   	pop    %edi
  80024e:	5d                   	pop    %ebp
  80024f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800250:	83 ec 0c             	sub    $0xc,%esp
  800253:	50                   	push   %eax
  800254:	6a 08                	push   $0x8
  800256:	68 0a 23 80 00       	push   $0x80230a
  80025b:	6a 23                	push   $0x23
  80025d:	68 27 23 80 00       	push   $0x802327
  800262:	e8 66 12 00 00       	call   8014cd <_panic>

00800267 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800267:	55                   	push   %ebp
  800268:	89 e5                	mov    %esp,%ebp
  80026a:	57                   	push   %edi
  80026b:	56                   	push   %esi
  80026c:	53                   	push   %ebx
  80026d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800270:	bb 00 00 00 00       	mov    $0x0,%ebx
  800275:	8b 55 08             	mov    0x8(%ebp),%edx
  800278:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80027b:	b8 09 00 00 00       	mov    $0x9,%eax
  800280:	89 df                	mov    %ebx,%edi
  800282:	89 de                	mov    %ebx,%esi
  800284:	cd 30                	int    $0x30
	if(check && ret > 0)
  800286:	85 c0                	test   %eax,%eax
  800288:	7f 08                	jg     800292 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80028a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80028d:	5b                   	pop    %ebx
  80028e:	5e                   	pop    %esi
  80028f:	5f                   	pop    %edi
  800290:	5d                   	pop    %ebp
  800291:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800292:	83 ec 0c             	sub    $0xc,%esp
  800295:	50                   	push   %eax
  800296:	6a 09                	push   $0x9
  800298:	68 0a 23 80 00       	push   $0x80230a
  80029d:	6a 23                	push   $0x23
  80029f:	68 27 23 80 00       	push   $0x802327
  8002a4:	e8 24 12 00 00       	call   8014cd <_panic>

008002a9 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002a9:	55                   	push   %ebp
  8002aa:	89 e5                	mov    %esp,%ebp
  8002ac:	57                   	push   %edi
  8002ad:	56                   	push   %esi
  8002ae:	53                   	push   %ebx
  8002af:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002b2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8002ba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002bd:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002c2:	89 df                	mov    %ebx,%edi
  8002c4:	89 de                	mov    %ebx,%esi
  8002c6:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002c8:	85 c0                	test   %eax,%eax
  8002ca:	7f 08                	jg     8002d4 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8002cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002cf:	5b                   	pop    %ebx
  8002d0:	5e                   	pop    %esi
  8002d1:	5f                   	pop    %edi
  8002d2:	5d                   	pop    %ebp
  8002d3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002d4:	83 ec 0c             	sub    $0xc,%esp
  8002d7:	50                   	push   %eax
  8002d8:	6a 0a                	push   $0xa
  8002da:	68 0a 23 80 00       	push   $0x80230a
  8002df:	6a 23                	push   $0x23
  8002e1:	68 27 23 80 00       	push   $0x802327
  8002e6:	e8 e2 11 00 00       	call   8014cd <_panic>

008002eb <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8002eb:	55                   	push   %ebp
  8002ec:	89 e5                	mov    %esp,%ebp
  8002ee:	57                   	push   %edi
  8002ef:	56                   	push   %esi
  8002f0:	53                   	push   %ebx
	asm volatile("int %1\n"
  8002f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8002f4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002f7:	b8 0c 00 00 00       	mov    $0xc,%eax
  8002fc:	be 00 00 00 00       	mov    $0x0,%esi
  800301:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800304:	8b 7d 14             	mov    0x14(%ebp),%edi
  800307:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800309:	5b                   	pop    %ebx
  80030a:	5e                   	pop    %esi
  80030b:	5f                   	pop    %edi
  80030c:	5d                   	pop    %ebp
  80030d:	c3                   	ret    

0080030e <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80030e:	55                   	push   %ebp
  80030f:	89 e5                	mov    %esp,%ebp
  800311:	57                   	push   %edi
  800312:	56                   	push   %esi
  800313:	53                   	push   %ebx
  800314:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800317:	b9 00 00 00 00       	mov    $0x0,%ecx
  80031c:	8b 55 08             	mov    0x8(%ebp),%edx
  80031f:	b8 0d 00 00 00       	mov    $0xd,%eax
  800324:	89 cb                	mov    %ecx,%ebx
  800326:	89 cf                	mov    %ecx,%edi
  800328:	89 ce                	mov    %ecx,%esi
  80032a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80032c:	85 c0                	test   %eax,%eax
  80032e:	7f 08                	jg     800338 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800330:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800333:	5b                   	pop    %ebx
  800334:	5e                   	pop    %esi
  800335:	5f                   	pop    %edi
  800336:	5d                   	pop    %ebp
  800337:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800338:	83 ec 0c             	sub    $0xc,%esp
  80033b:	50                   	push   %eax
  80033c:	6a 0d                	push   $0xd
  80033e:	68 0a 23 80 00       	push   $0x80230a
  800343:	6a 23                	push   $0x23
  800345:	68 27 23 80 00       	push   $0x802327
  80034a:	e8 7e 11 00 00       	call   8014cd <_panic>

0080034f <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80034f:	55                   	push   %ebp
  800350:	89 e5                	mov    %esp,%ebp
  800352:	57                   	push   %edi
  800353:	56                   	push   %esi
  800354:	53                   	push   %ebx
	asm volatile("int %1\n"
  800355:	ba 00 00 00 00       	mov    $0x0,%edx
  80035a:	b8 0e 00 00 00       	mov    $0xe,%eax
  80035f:	89 d1                	mov    %edx,%ecx
  800361:	89 d3                	mov    %edx,%ebx
  800363:	89 d7                	mov    %edx,%edi
  800365:	89 d6                	mov    %edx,%esi
  800367:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800369:	5b                   	pop    %ebx
  80036a:	5e                   	pop    %esi
  80036b:	5f                   	pop    %edi
  80036c:	5d                   	pop    %ebp
  80036d:	c3                   	ret    

0080036e <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80036e:	55                   	push   %ebp
  80036f:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800371:	8b 45 08             	mov    0x8(%ebp),%eax
  800374:	05 00 00 00 30       	add    $0x30000000,%eax
  800379:	c1 e8 0c             	shr    $0xc,%eax
}
  80037c:	5d                   	pop    %ebp
  80037d:	c3                   	ret    

0080037e <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80037e:	55                   	push   %ebp
  80037f:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800381:	8b 45 08             	mov    0x8(%ebp),%eax
  800384:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800389:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80038e:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800393:	5d                   	pop    %ebp
  800394:	c3                   	ret    

00800395 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800395:	55                   	push   %ebp
  800396:	89 e5                	mov    %esp,%ebp
  800398:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80039b:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8003a0:	89 c2                	mov    %eax,%edx
  8003a2:	c1 ea 16             	shr    $0x16,%edx
  8003a5:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8003ac:	f6 c2 01             	test   $0x1,%dl
  8003af:	74 2a                	je     8003db <fd_alloc+0x46>
  8003b1:	89 c2                	mov    %eax,%edx
  8003b3:	c1 ea 0c             	shr    $0xc,%edx
  8003b6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8003bd:	f6 c2 01             	test   $0x1,%dl
  8003c0:	74 19                	je     8003db <fd_alloc+0x46>
  8003c2:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8003c7:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8003cc:	75 d2                	jne    8003a0 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8003ce:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8003d4:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8003d9:	eb 07                	jmp    8003e2 <fd_alloc+0x4d>
			*fd_store = fd;
  8003db:	89 01                	mov    %eax,(%ecx)
			return 0;
  8003dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8003e2:	5d                   	pop    %ebp
  8003e3:	c3                   	ret    

008003e4 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8003e4:	55                   	push   %ebp
  8003e5:	89 e5                	mov    %esp,%ebp
  8003e7:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8003ea:	83 f8 1f             	cmp    $0x1f,%eax
  8003ed:	77 36                	ja     800425 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8003ef:	c1 e0 0c             	shl    $0xc,%eax
  8003f2:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8003f7:	89 c2                	mov    %eax,%edx
  8003f9:	c1 ea 16             	shr    $0x16,%edx
  8003fc:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800403:	f6 c2 01             	test   $0x1,%dl
  800406:	74 24                	je     80042c <fd_lookup+0x48>
  800408:	89 c2                	mov    %eax,%edx
  80040a:	c1 ea 0c             	shr    $0xc,%edx
  80040d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800414:	f6 c2 01             	test   $0x1,%dl
  800417:	74 1a                	je     800433 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800419:	8b 55 0c             	mov    0xc(%ebp),%edx
  80041c:	89 02                	mov    %eax,(%edx)
	return 0;
  80041e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800423:	5d                   	pop    %ebp
  800424:	c3                   	ret    
		return -E_INVAL;
  800425:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80042a:	eb f7                	jmp    800423 <fd_lookup+0x3f>
		return -E_INVAL;
  80042c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800431:	eb f0                	jmp    800423 <fd_lookup+0x3f>
  800433:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800438:	eb e9                	jmp    800423 <fd_lookup+0x3f>

0080043a <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80043a:	55                   	push   %ebp
  80043b:	89 e5                	mov    %esp,%ebp
  80043d:	83 ec 08             	sub    $0x8,%esp
  800440:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800443:	ba b4 23 80 00       	mov    $0x8023b4,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800448:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80044d:	39 08                	cmp    %ecx,(%eax)
  80044f:	74 33                	je     800484 <dev_lookup+0x4a>
  800451:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800454:	8b 02                	mov    (%edx),%eax
  800456:	85 c0                	test   %eax,%eax
  800458:	75 f3                	jne    80044d <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80045a:	a1 08 40 80 00       	mov    0x804008,%eax
  80045f:	8b 40 48             	mov    0x48(%eax),%eax
  800462:	83 ec 04             	sub    $0x4,%esp
  800465:	51                   	push   %ecx
  800466:	50                   	push   %eax
  800467:	68 38 23 80 00       	push   $0x802338
  80046c:	e8 37 11 00 00       	call   8015a8 <cprintf>
	*dev = 0;
  800471:	8b 45 0c             	mov    0xc(%ebp),%eax
  800474:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80047a:	83 c4 10             	add    $0x10,%esp
  80047d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800482:	c9                   	leave  
  800483:	c3                   	ret    
			*dev = devtab[i];
  800484:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800487:	89 01                	mov    %eax,(%ecx)
			return 0;
  800489:	b8 00 00 00 00       	mov    $0x0,%eax
  80048e:	eb f2                	jmp    800482 <dev_lookup+0x48>

00800490 <fd_close>:
{
  800490:	55                   	push   %ebp
  800491:	89 e5                	mov    %esp,%ebp
  800493:	57                   	push   %edi
  800494:	56                   	push   %esi
  800495:	53                   	push   %ebx
  800496:	83 ec 1c             	sub    $0x1c,%esp
  800499:	8b 75 08             	mov    0x8(%ebp),%esi
  80049c:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80049f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8004a2:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8004a3:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8004a9:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8004ac:	50                   	push   %eax
  8004ad:	e8 32 ff ff ff       	call   8003e4 <fd_lookup>
  8004b2:	89 c3                	mov    %eax,%ebx
  8004b4:	83 c4 08             	add    $0x8,%esp
  8004b7:	85 c0                	test   %eax,%eax
  8004b9:	78 05                	js     8004c0 <fd_close+0x30>
	    || fd != fd2)
  8004bb:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8004be:	74 16                	je     8004d6 <fd_close+0x46>
		return (must_exist ? r : 0);
  8004c0:	89 f8                	mov    %edi,%eax
  8004c2:	84 c0                	test   %al,%al
  8004c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8004c9:	0f 44 d8             	cmove  %eax,%ebx
}
  8004cc:	89 d8                	mov    %ebx,%eax
  8004ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004d1:	5b                   	pop    %ebx
  8004d2:	5e                   	pop    %esi
  8004d3:	5f                   	pop    %edi
  8004d4:	5d                   	pop    %ebp
  8004d5:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8004d6:	83 ec 08             	sub    $0x8,%esp
  8004d9:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8004dc:	50                   	push   %eax
  8004dd:	ff 36                	pushl  (%esi)
  8004df:	e8 56 ff ff ff       	call   80043a <dev_lookup>
  8004e4:	89 c3                	mov    %eax,%ebx
  8004e6:	83 c4 10             	add    $0x10,%esp
  8004e9:	85 c0                	test   %eax,%eax
  8004eb:	78 15                	js     800502 <fd_close+0x72>
		if (dev->dev_close)
  8004ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004f0:	8b 40 10             	mov    0x10(%eax),%eax
  8004f3:	85 c0                	test   %eax,%eax
  8004f5:	74 1b                	je     800512 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  8004f7:	83 ec 0c             	sub    $0xc,%esp
  8004fa:	56                   	push   %esi
  8004fb:	ff d0                	call   *%eax
  8004fd:	89 c3                	mov    %eax,%ebx
  8004ff:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800502:	83 ec 08             	sub    $0x8,%esp
  800505:	56                   	push   %esi
  800506:	6a 00                	push   $0x0
  800508:	e8 d6 fc ff ff       	call   8001e3 <sys_page_unmap>
	return r;
  80050d:	83 c4 10             	add    $0x10,%esp
  800510:	eb ba                	jmp    8004cc <fd_close+0x3c>
			r = 0;
  800512:	bb 00 00 00 00       	mov    $0x0,%ebx
  800517:	eb e9                	jmp    800502 <fd_close+0x72>

00800519 <close>:

int
close(int fdnum)
{
  800519:	55                   	push   %ebp
  80051a:	89 e5                	mov    %esp,%ebp
  80051c:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80051f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800522:	50                   	push   %eax
  800523:	ff 75 08             	pushl  0x8(%ebp)
  800526:	e8 b9 fe ff ff       	call   8003e4 <fd_lookup>
  80052b:	83 c4 08             	add    $0x8,%esp
  80052e:	85 c0                	test   %eax,%eax
  800530:	78 10                	js     800542 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  800532:	83 ec 08             	sub    $0x8,%esp
  800535:	6a 01                	push   $0x1
  800537:	ff 75 f4             	pushl  -0xc(%ebp)
  80053a:	e8 51 ff ff ff       	call   800490 <fd_close>
  80053f:	83 c4 10             	add    $0x10,%esp
}
  800542:	c9                   	leave  
  800543:	c3                   	ret    

00800544 <close_all>:

void
close_all(void)
{
  800544:	55                   	push   %ebp
  800545:	89 e5                	mov    %esp,%ebp
  800547:	53                   	push   %ebx
  800548:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80054b:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800550:	83 ec 0c             	sub    $0xc,%esp
  800553:	53                   	push   %ebx
  800554:	e8 c0 ff ff ff       	call   800519 <close>
	for (i = 0; i < MAXFD; i++)
  800559:	83 c3 01             	add    $0x1,%ebx
  80055c:	83 c4 10             	add    $0x10,%esp
  80055f:	83 fb 20             	cmp    $0x20,%ebx
  800562:	75 ec                	jne    800550 <close_all+0xc>
}
  800564:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800567:	c9                   	leave  
  800568:	c3                   	ret    

00800569 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800569:	55                   	push   %ebp
  80056a:	89 e5                	mov    %esp,%ebp
  80056c:	57                   	push   %edi
  80056d:	56                   	push   %esi
  80056e:	53                   	push   %ebx
  80056f:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800572:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800575:	50                   	push   %eax
  800576:	ff 75 08             	pushl  0x8(%ebp)
  800579:	e8 66 fe ff ff       	call   8003e4 <fd_lookup>
  80057e:	89 c3                	mov    %eax,%ebx
  800580:	83 c4 08             	add    $0x8,%esp
  800583:	85 c0                	test   %eax,%eax
  800585:	0f 88 81 00 00 00    	js     80060c <dup+0xa3>
		return r;
	close(newfdnum);
  80058b:	83 ec 0c             	sub    $0xc,%esp
  80058e:	ff 75 0c             	pushl  0xc(%ebp)
  800591:	e8 83 ff ff ff       	call   800519 <close>

	newfd = INDEX2FD(newfdnum);
  800596:	8b 75 0c             	mov    0xc(%ebp),%esi
  800599:	c1 e6 0c             	shl    $0xc,%esi
  80059c:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8005a2:	83 c4 04             	add    $0x4,%esp
  8005a5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8005a8:	e8 d1 fd ff ff       	call   80037e <fd2data>
  8005ad:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8005af:	89 34 24             	mov    %esi,(%esp)
  8005b2:	e8 c7 fd ff ff       	call   80037e <fd2data>
  8005b7:	83 c4 10             	add    $0x10,%esp
  8005ba:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8005bc:	89 d8                	mov    %ebx,%eax
  8005be:	c1 e8 16             	shr    $0x16,%eax
  8005c1:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8005c8:	a8 01                	test   $0x1,%al
  8005ca:	74 11                	je     8005dd <dup+0x74>
  8005cc:	89 d8                	mov    %ebx,%eax
  8005ce:	c1 e8 0c             	shr    $0xc,%eax
  8005d1:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8005d8:	f6 c2 01             	test   $0x1,%dl
  8005db:	75 39                	jne    800616 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8005dd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8005e0:	89 d0                	mov    %edx,%eax
  8005e2:	c1 e8 0c             	shr    $0xc,%eax
  8005e5:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8005ec:	83 ec 0c             	sub    $0xc,%esp
  8005ef:	25 07 0e 00 00       	and    $0xe07,%eax
  8005f4:	50                   	push   %eax
  8005f5:	56                   	push   %esi
  8005f6:	6a 00                	push   $0x0
  8005f8:	52                   	push   %edx
  8005f9:	6a 00                	push   $0x0
  8005fb:	e8 a1 fb ff ff       	call   8001a1 <sys_page_map>
  800600:	89 c3                	mov    %eax,%ebx
  800602:	83 c4 20             	add    $0x20,%esp
  800605:	85 c0                	test   %eax,%eax
  800607:	78 31                	js     80063a <dup+0xd1>
		goto err;

	return newfdnum;
  800609:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80060c:	89 d8                	mov    %ebx,%eax
  80060e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800611:	5b                   	pop    %ebx
  800612:	5e                   	pop    %esi
  800613:	5f                   	pop    %edi
  800614:	5d                   	pop    %ebp
  800615:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800616:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80061d:	83 ec 0c             	sub    $0xc,%esp
  800620:	25 07 0e 00 00       	and    $0xe07,%eax
  800625:	50                   	push   %eax
  800626:	57                   	push   %edi
  800627:	6a 00                	push   $0x0
  800629:	53                   	push   %ebx
  80062a:	6a 00                	push   $0x0
  80062c:	e8 70 fb ff ff       	call   8001a1 <sys_page_map>
  800631:	89 c3                	mov    %eax,%ebx
  800633:	83 c4 20             	add    $0x20,%esp
  800636:	85 c0                	test   %eax,%eax
  800638:	79 a3                	jns    8005dd <dup+0x74>
	sys_page_unmap(0, newfd);
  80063a:	83 ec 08             	sub    $0x8,%esp
  80063d:	56                   	push   %esi
  80063e:	6a 00                	push   $0x0
  800640:	e8 9e fb ff ff       	call   8001e3 <sys_page_unmap>
	sys_page_unmap(0, nva);
  800645:	83 c4 08             	add    $0x8,%esp
  800648:	57                   	push   %edi
  800649:	6a 00                	push   $0x0
  80064b:	e8 93 fb ff ff       	call   8001e3 <sys_page_unmap>
	return r;
  800650:	83 c4 10             	add    $0x10,%esp
  800653:	eb b7                	jmp    80060c <dup+0xa3>

00800655 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800655:	55                   	push   %ebp
  800656:	89 e5                	mov    %esp,%ebp
  800658:	53                   	push   %ebx
  800659:	83 ec 14             	sub    $0x14,%esp
  80065c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80065f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800662:	50                   	push   %eax
  800663:	53                   	push   %ebx
  800664:	e8 7b fd ff ff       	call   8003e4 <fd_lookup>
  800669:	83 c4 08             	add    $0x8,%esp
  80066c:	85 c0                	test   %eax,%eax
  80066e:	78 3f                	js     8006af <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800670:	83 ec 08             	sub    $0x8,%esp
  800673:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800676:	50                   	push   %eax
  800677:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80067a:	ff 30                	pushl  (%eax)
  80067c:	e8 b9 fd ff ff       	call   80043a <dev_lookup>
  800681:	83 c4 10             	add    $0x10,%esp
  800684:	85 c0                	test   %eax,%eax
  800686:	78 27                	js     8006af <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800688:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80068b:	8b 42 08             	mov    0x8(%edx),%eax
  80068e:	83 e0 03             	and    $0x3,%eax
  800691:	83 f8 01             	cmp    $0x1,%eax
  800694:	74 1e                	je     8006b4 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  800696:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800699:	8b 40 08             	mov    0x8(%eax),%eax
  80069c:	85 c0                	test   %eax,%eax
  80069e:	74 35                	je     8006d5 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8006a0:	83 ec 04             	sub    $0x4,%esp
  8006a3:	ff 75 10             	pushl  0x10(%ebp)
  8006a6:	ff 75 0c             	pushl  0xc(%ebp)
  8006a9:	52                   	push   %edx
  8006aa:	ff d0                	call   *%eax
  8006ac:	83 c4 10             	add    $0x10,%esp
}
  8006af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006b2:	c9                   	leave  
  8006b3:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8006b4:	a1 08 40 80 00       	mov    0x804008,%eax
  8006b9:	8b 40 48             	mov    0x48(%eax),%eax
  8006bc:	83 ec 04             	sub    $0x4,%esp
  8006bf:	53                   	push   %ebx
  8006c0:	50                   	push   %eax
  8006c1:	68 79 23 80 00       	push   $0x802379
  8006c6:	e8 dd 0e 00 00       	call   8015a8 <cprintf>
		return -E_INVAL;
  8006cb:	83 c4 10             	add    $0x10,%esp
  8006ce:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8006d3:	eb da                	jmp    8006af <read+0x5a>
		return -E_NOT_SUPP;
  8006d5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8006da:	eb d3                	jmp    8006af <read+0x5a>

008006dc <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8006dc:	55                   	push   %ebp
  8006dd:	89 e5                	mov    %esp,%ebp
  8006df:	57                   	push   %edi
  8006e0:	56                   	push   %esi
  8006e1:	53                   	push   %ebx
  8006e2:	83 ec 0c             	sub    $0xc,%esp
  8006e5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8006e8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8006eb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006f0:	39 f3                	cmp    %esi,%ebx
  8006f2:	73 25                	jae    800719 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8006f4:	83 ec 04             	sub    $0x4,%esp
  8006f7:	89 f0                	mov    %esi,%eax
  8006f9:	29 d8                	sub    %ebx,%eax
  8006fb:	50                   	push   %eax
  8006fc:	89 d8                	mov    %ebx,%eax
  8006fe:	03 45 0c             	add    0xc(%ebp),%eax
  800701:	50                   	push   %eax
  800702:	57                   	push   %edi
  800703:	e8 4d ff ff ff       	call   800655 <read>
		if (m < 0)
  800708:	83 c4 10             	add    $0x10,%esp
  80070b:	85 c0                	test   %eax,%eax
  80070d:	78 08                	js     800717 <readn+0x3b>
			return m;
		if (m == 0)
  80070f:	85 c0                	test   %eax,%eax
  800711:	74 06                	je     800719 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  800713:	01 c3                	add    %eax,%ebx
  800715:	eb d9                	jmp    8006f0 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800717:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  800719:	89 d8                	mov    %ebx,%eax
  80071b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80071e:	5b                   	pop    %ebx
  80071f:	5e                   	pop    %esi
  800720:	5f                   	pop    %edi
  800721:	5d                   	pop    %ebp
  800722:	c3                   	ret    

00800723 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800723:	55                   	push   %ebp
  800724:	89 e5                	mov    %esp,%ebp
  800726:	53                   	push   %ebx
  800727:	83 ec 14             	sub    $0x14,%esp
  80072a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80072d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800730:	50                   	push   %eax
  800731:	53                   	push   %ebx
  800732:	e8 ad fc ff ff       	call   8003e4 <fd_lookup>
  800737:	83 c4 08             	add    $0x8,%esp
  80073a:	85 c0                	test   %eax,%eax
  80073c:	78 3a                	js     800778 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80073e:	83 ec 08             	sub    $0x8,%esp
  800741:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800744:	50                   	push   %eax
  800745:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800748:	ff 30                	pushl  (%eax)
  80074a:	e8 eb fc ff ff       	call   80043a <dev_lookup>
  80074f:	83 c4 10             	add    $0x10,%esp
  800752:	85 c0                	test   %eax,%eax
  800754:	78 22                	js     800778 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800756:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800759:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80075d:	74 1e                	je     80077d <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80075f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800762:	8b 52 0c             	mov    0xc(%edx),%edx
  800765:	85 d2                	test   %edx,%edx
  800767:	74 35                	je     80079e <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  800769:	83 ec 04             	sub    $0x4,%esp
  80076c:	ff 75 10             	pushl  0x10(%ebp)
  80076f:	ff 75 0c             	pushl  0xc(%ebp)
  800772:	50                   	push   %eax
  800773:	ff d2                	call   *%edx
  800775:	83 c4 10             	add    $0x10,%esp
}
  800778:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80077b:	c9                   	leave  
  80077c:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80077d:	a1 08 40 80 00       	mov    0x804008,%eax
  800782:	8b 40 48             	mov    0x48(%eax),%eax
  800785:	83 ec 04             	sub    $0x4,%esp
  800788:	53                   	push   %ebx
  800789:	50                   	push   %eax
  80078a:	68 95 23 80 00       	push   $0x802395
  80078f:	e8 14 0e 00 00       	call   8015a8 <cprintf>
		return -E_INVAL;
  800794:	83 c4 10             	add    $0x10,%esp
  800797:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80079c:	eb da                	jmp    800778 <write+0x55>
		return -E_NOT_SUPP;
  80079e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8007a3:	eb d3                	jmp    800778 <write+0x55>

008007a5 <seek>:

int
seek(int fdnum, off_t offset)
{
  8007a5:	55                   	push   %ebp
  8007a6:	89 e5                	mov    %esp,%ebp
  8007a8:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8007ab:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8007ae:	50                   	push   %eax
  8007af:	ff 75 08             	pushl  0x8(%ebp)
  8007b2:	e8 2d fc ff ff       	call   8003e4 <fd_lookup>
  8007b7:	83 c4 08             	add    $0x8,%esp
  8007ba:	85 c0                	test   %eax,%eax
  8007bc:	78 0e                	js     8007cc <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8007be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8007c4:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8007c7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8007cc:	c9                   	leave  
  8007cd:	c3                   	ret    

008007ce <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8007ce:	55                   	push   %ebp
  8007cf:	89 e5                	mov    %esp,%ebp
  8007d1:	53                   	push   %ebx
  8007d2:	83 ec 14             	sub    $0x14,%esp
  8007d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8007d8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8007db:	50                   	push   %eax
  8007dc:	53                   	push   %ebx
  8007dd:	e8 02 fc ff ff       	call   8003e4 <fd_lookup>
  8007e2:	83 c4 08             	add    $0x8,%esp
  8007e5:	85 c0                	test   %eax,%eax
  8007e7:	78 37                	js     800820 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8007e9:	83 ec 08             	sub    $0x8,%esp
  8007ec:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8007ef:	50                   	push   %eax
  8007f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007f3:	ff 30                	pushl  (%eax)
  8007f5:	e8 40 fc ff ff       	call   80043a <dev_lookup>
  8007fa:	83 c4 10             	add    $0x10,%esp
  8007fd:	85 c0                	test   %eax,%eax
  8007ff:	78 1f                	js     800820 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800801:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800804:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800808:	74 1b                	je     800825 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80080a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80080d:	8b 52 18             	mov    0x18(%edx),%edx
  800810:	85 d2                	test   %edx,%edx
  800812:	74 32                	je     800846 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  800814:	83 ec 08             	sub    $0x8,%esp
  800817:	ff 75 0c             	pushl  0xc(%ebp)
  80081a:	50                   	push   %eax
  80081b:	ff d2                	call   *%edx
  80081d:	83 c4 10             	add    $0x10,%esp
}
  800820:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800823:	c9                   	leave  
  800824:	c3                   	ret    
			thisenv->env_id, fdnum);
  800825:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80082a:	8b 40 48             	mov    0x48(%eax),%eax
  80082d:	83 ec 04             	sub    $0x4,%esp
  800830:	53                   	push   %ebx
  800831:	50                   	push   %eax
  800832:	68 58 23 80 00       	push   $0x802358
  800837:	e8 6c 0d 00 00       	call   8015a8 <cprintf>
		return -E_INVAL;
  80083c:	83 c4 10             	add    $0x10,%esp
  80083f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800844:	eb da                	jmp    800820 <ftruncate+0x52>
		return -E_NOT_SUPP;
  800846:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80084b:	eb d3                	jmp    800820 <ftruncate+0x52>

0080084d <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80084d:	55                   	push   %ebp
  80084e:	89 e5                	mov    %esp,%ebp
  800850:	53                   	push   %ebx
  800851:	83 ec 14             	sub    $0x14,%esp
  800854:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800857:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80085a:	50                   	push   %eax
  80085b:	ff 75 08             	pushl  0x8(%ebp)
  80085e:	e8 81 fb ff ff       	call   8003e4 <fd_lookup>
  800863:	83 c4 08             	add    $0x8,%esp
  800866:	85 c0                	test   %eax,%eax
  800868:	78 4b                	js     8008b5 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80086a:	83 ec 08             	sub    $0x8,%esp
  80086d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800870:	50                   	push   %eax
  800871:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800874:	ff 30                	pushl  (%eax)
  800876:	e8 bf fb ff ff       	call   80043a <dev_lookup>
  80087b:	83 c4 10             	add    $0x10,%esp
  80087e:	85 c0                	test   %eax,%eax
  800880:	78 33                	js     8008b5 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  800882:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800885:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  800889:	74 2f                	je     8008ba <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80088b:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80088e:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  800895:	00 00 00 
	stat->st_isdir = 0;
  800898:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80089f:	00 00 00 
	stat->st_dev = dev;
  8008a2:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8008a8:	83 ec 08             	sub    $0x8,%esp
  8008ab:	53                   	push   %ebx
  8008ac:	ff 75 f0             	pushl  -0x10(%ebp)
  8008af:	ff 50 14             	call   *0x14(%eax)
  8008b2:	83 c4 10             	add    $0x10,%esp
}
  8008b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008b8:	c9                   	leave  
  8008b9:	c3                   	ret    
		return -E_NOT_SUPP;
  8008ba:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8008bf:	eb f4                	jmp    8008b5 <fstat+0x68>

008008c1 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8008c1:	55                   	push   %ebp
  8008c2:	89 e5                	mov    %esp,%ebp
  8008c4:	56                   	push   %esi
  8008c5:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8008c6:	83 ec 08             	sub    $0x8,%esp
  8008c9:	6a 00                	push   $0x0
  8008cb:	ff 75 08             	pushl  0x8(%ebp)
  8008ce:	e8 26 02 00 00       	call   800af9 <open>
  8008d3:	89 c3                	mov    %eax,%ebx
  8008d5:	83 c4 10             	add    $0x10,%esp
  8008d8:	85 c0                	test   %eax,%eax
  8008da:	78 1b                	js     8008f7 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8008dc:	83 ec 08             	sub    $0x8,%esp
  8008df:	ff 75 0c             	pushl  0xc(%ebp)
  8008e2:	50                   	push   %eax
  8008e3:	e8 65 ff ff ff       	call   80084d <fstat>
  8008e8:	89 c6                	mov    %eax,%esi
	close(fd);
  8008ea:	89 1c 24             	mov    %ebx,(%esp)
  8008ed:	e8 27 fc ff ff       	call   800519 <close>
	return r;
  8008f2:	83 c4 10             	add    $0x10,%esp
  8008f5:	89 f3                	mov    %esi,%ebx
}
  8008f7:	89 d8                	mov    %ebx,%eax
  8008f9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008fc:	5b                   	pop    %ebx
  8008fd:	5e                   	pop    %esi
  8008fe:	5d                   	pop    %ebp
  8008ff:	c3                   	ret    

00800900 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800900:	55                   	push   %ebp
  800901:	89 e5                	mov    %esp,%ebp
  800903:	56                   	push   %esi
  800904:	53                   	push   %ebx
  800905:	89 c6                	mov    %eax,%esi
  800907:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  800909:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  800910:	74 27                	je     800939 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800912:	6a 07                	push   $0x7
  800914:	68 00 50 80 00       	push   $0x805000
  800919:	56                   	push   %esi
  80091a:	ff 35 00 40 80 00    	pushl  0x804000
  800920:	e8 c6 16 00 00       	call   801feb <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  800925:	83 c4 0c             	add    $0xc,%esp
  800928:	6a 00                	push   $0x0
  80092a:	53                   	push   %ebx
  80092b:	6a 00                	push   $0x0
  80092d:	e8 50 16 00 00       	call   801f82 <ipc_recv>
}
  800932:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800935:	5b                   	pop    %ebx
  800936:	5e                   	pop    %esi
  800937:	5d                   	pop    %ebp
  800938:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800939:	83 ec 0c             	sub    $0xc,%esp
  80093c:	6a 01                	push   $0x1
  80093e:	e8 01 17 00 00       	call   802044 <ipc_find_env>
  800943:	a3 00 40 80 00       	mov    %eax,0x804000
  800948:	83 c4 10             	add    $0x10,%esp
  80094b:	eb c5                	jmp    800912 <fsipc+0x12>

0080094d <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80094d:	55                   	push   %ebp
  80094e:	89 e5                	mov    %esp,%ebp
  800950:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800953:	8b 45 08             	mov    0x8(%ebp),%eax
  800956:	8b 40 0c             	mov    0xc(%eax),%eax
  800959:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80095e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800961:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  800966:	ba 00 00 00 00       	mov    $0x0,%edx
  80096b:	b8 02 00 00 00       	mov    $0x2,%eax
  800970:	e8 8b ff ff ff       	call   800900 <fsipc>
}
  800975:	c9                   	leave  
  800976:	c3                   	ret    

00800977 <devfile_flush>:
{
  800977:	55                   	push   %ebp
  800978:	89 e5                	mov    %esp,%ebp
  80097a:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80097d:	8b 45 08             	mov    0x8(%ebp),%eax
  800980:	8b 40 0c             	mov    0xc(%eax),%eax
  800983:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800988:	ba 00 00 00 00       	mov    $0x0,%edx
  80098d:	b8 06 00 00 00       	mov    $0x6,%eax
  800992:	e8 69 ff ff ff       	call   800900 <fsipc>
}
  800997:	c9                   	leave  
  800998:	c3                   	ret    

00800999 <devfile_stat>:
{
  800999:	55                   	push   %ebp
  80099a:	89 e5                	mov    %esp,%ebp
  80099c:	53                   	push   %ebx
  80099d:	83 ec 04             	sub    $0x4,%esp
  8009a0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8009a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a6:	8b 40 0c             	mov    0xc(%eax),%eax
  8009a9:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8009ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8009b3:	b8 05 00 00 00       	mov    $0x5,%eax
  8009b8:	e8 43 ff ff ff       	call   800900 <fsipc>
  8009bd:	85 c0                	test   %eax,%eax
  8009bf:	78 2c                	js     8009ed <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8009c1:	83 ec 08             	sub    $0x8,%esp
  8009c4:	68 00 50 80 00       	push   $0x805000
  8009c9:	53                   	push   %ebx
  8009ca:	e8 76 12 00 00       	call   801c45 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8009cf:	a1 80 50 80 00       	mov    0x805080,%eax
  8009d4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8009da:	a1 84 50 80 00       	mov    0x805084,%eax
  8009df:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8009e5:	83 c4 10             	add    $0x10,%esp
  8009e8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009f0:	c9                   	leave  
  8009f1:	c3                   	ret    

008009f2 <devfile_write>:
{
  8009f2:	55                   	push   %ebp
  8009f3:	89 e5                	mov    %esp,%ebp
  8009f5:	53                   	push   %ebx
  8009f6:	83 ec 04             	sub    $0x4,%esp
  8009f9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8009fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ff:	8b 40 0c             	mov    0xc(%eax),%eax
  800a02:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  800a07:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  800a0d:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  800a13:	77 30                	ja     800a45 <devfile_write+0x53>
	memmove(fsipcbuf.write.req_buf, buf, n);
  800a15:	83 ec 04             	sub    $0x4,%esp
  800a18:	53                   	push   %ebx
  800a19:	ff 75 0c             	pushl  0xc(%ebp)
  800a1c:	68 08 50 80 00       	push   $0x805008
  800a21:	e8 ad 13 00 00       	call   801dd3 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  800a26:	ba 00 00 00 00       	mov    $0x0,%edx
  800a2b:	b8 04 00 00 00       	mov    $0x4,%eax
  800a30:	e8 cb fe ff ff       	call   800900 <fsipc>
  800a35:	83 c4 10             	add    $0x10,%esp
  800a38:	85 c0                	test   %eax,%eax
  800a3a:	78 04                	js     800a40 <devfile_write+0x4e>
	assert(r <= n);
  800a3c:	39 d8                	cmp    %ebx,%eax
  800a3e:	77 1e                	ja     800a5e <devfile_write+0x6c>
}
  800a40:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a43:	c9                   	leave  
  800a44:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  800a45:	68 c8 23 80 00       	push   $0x8023c8
  800a4a:	68 f5 23 80 00       	push   $0x8023f5
  800a4f:	68 94 00 00 00       	push   $0x94
  800a54:	68 0a 24 80 00       	push   $0x80240a
  800a59:	e8 6f 0a 00 00       	call   8014cd <_panic>
	assert(r <= n);
  800a5e:	68 15 24 80 00       	push   $0x802415
  800a63:	68 f5 23 80 00       	push   $0x8023f5
  800a68:	68 98 00 00 00       	push   $0x98
  800a6d:	68 0a 24 80 00       	push   $0x80240a
  800a72:	e8 56 0a 00 00       	call   8014cd <_panic>

00800a77 <devfile_read>:
{
  800a77:	55                   	push   %ebp
  800a78:	89 e5                	mov    %esp,%ebp
  800a7a:	56                   	push   %esi
  800a7b:	53                   	push   %ebx
  800a7c:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a82:	8b 40 0c             	mov    0xc(%eax),%eax
  800a85:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800a8a:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800a90:	ba 00 00 00 00       	mov    $0x0,%edx
  800a95:	b8 03 00 00 00       	mov    $0x3,%eax
  800a9a:	e8 61 fe ff ff       	call   800900 <fsipc>
  800a9f:	89 c3                	mov    %eax,%ebx
  800aa1:	85 c0                	test   %eax,%eax
  800aa3:	78 1f                	js     800ac4 <devfile_read+0x4d>
	assert(r <= n);
  800aa5:	39 f0                	cmp    %esi,%eax
  800aa7:	77 24                	ja     800acd <devfile_read+0x56>
	assert(r <= PGSIZE);
  800aa9:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800aae:	7f 33                	jg     800ae3 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800ab0:	83 ec 04             	sub    $0x4,%esp
  800ab3:	50                   	push   %eax
  800ab4:	68 00 50 80 00       	push   $0x805000
  800ab9:	ff 75 0c             	pushl  0xc(%ebp)
  800abc:	e8 12 13 00 00       	call   801dd3 <memmove>
	return r;
  800ac1:	83 c4 10             	add    $0x10,%esp
}
  800ac4:	89 d8                	mov    %ebx,%eax
  800ac6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ac9:	5b                   	pop    %ebx
  800aca:	5e                   	pop    %esi
  800acb:	5d                   	pop    %ebp
  800acc:	c3                   	ret    
	assert(r <= n);
  800acd:	68 15 24 80 00       	push   $0x802415
  800ad2:	68 f5 23 80 00       	push   $0x8023f5
  800ad7:	6a 7c                	push   $0x7c
  800ad9:	68 0a 24 80 00       	push   $0x80240a
  800ade:	e8 ea 09 00 00       	call   8014cd <_panic>
	assert(r <= PGSIZE);
  800ae3:	68 1c 24 80 00       	push   $0x80241c
  800ae8:	68 f5 23 80 00       	push   $0x8023f5
  800aed:	6a 7d                	push   $0x7d
  800aef:	68 0a 24 80 00       	push   $0x80240a
  800af4:	e8 d4 09 00 00       	call   8014cd <_panic>

00800af9 <open>:
{
  800af9:	55                   	push   %ebp
  800afa:	89 e5                	mov    %esp,%ebp
  800afc:	56                   	push   %esi
  800afd:	53                   	push   %ebx
  800afe:	83 ec 1c             	sub    $0x1c,%esp
  800b01:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800b04:	56                   	push   %esi
  800b05:	e8 04 11 00 00       	call   801c0e <strlen>
  800b0a:	83 c4 10             	add    $0x10,%esp
  800b0d:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800b12:	7f 6c                	jg     800b80 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  800b14:	83 ec 0c             	sub    $0xc,%esp
  800b17:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800b1a:	50                   	push   %eax
  800b1b:	e8 75 f8 ff ff       	call   800395 <fd_alloc>
  800b20:	89 c3                	mov    %eax,%ebx
  800b22:	83 c4 10             	add    $0x10,%esp
  800b25:	85 c0                	test   %eax,%eax
  800b27:	78 3c                	js     800b65 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  800b29:	83 ec 08             	sub    $0x8,%esp
  800b2c:	56                   	push   %esi
  800b2d:	68 00 50 80 00       	push   $0x805000
  800b32:	e8 0e 11 00 00       	call   801c45 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800b37:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3a:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800b3f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b42:	b8 01 00 00 00       	mov    $0x1,%eax
  800b47:	e8 b4 fd ff ff       	call   800900 <fsipc>
  800b4c:	89 c3                	mov    %eax,%ebx
  800b4e:	83 c4 10             	add    $0x10,%esp
  800b51:	85 c0                	test   %eax,%eax
  800b53:	78 19                	js     800b6e <open+0x75>
	return fd2num(fd);
  800b55:	83 ec 0c             	sub    $0xc,%esp
  800b58:	ff 75 f4             	pushl  -0xc(%ebp)
  800b5b:	e8 0e f8 ff ff       	call   80036e <fd2num>
  800b60:	89 c3                	mov    %eax,%ebx
  800b62:	83 c4 10             	add    $0x10,%esp
}
  800b65:	89 d8                	mov    %ebx,%eax
  800b67:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b6a:	5b                   	pop    %ebx
  800b6b:	5e                   	pop    %esi
  800b6c:	5d                   	pop    %ebp
  800b6d:	c3                   	ret    
		fd_close(fd, 0);
  800b6e:	83 ec 08             	sub    $0x8,%esp
  800b71:	6a 00                	push   $0x0
  800b73:	ff 75 f4             	pushl  -0xc(%ebp)
  800b76:	e8 15 f9 ff ff       	call   800490 <fd_close>
		return r;
  800b7b:	83 c4 10             	add    $0x10,%esp
  800b7e:	eb e5                	jmp    800b65 <open+0x6c>
		return -E_BAD_PATH;
  800b80:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800b85:	eb de                	jmp    800b65 <open+0x6c>

00800b87 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800b87:	55                   	push   %ebp
  800b88:	89 e5                	mov    %esp,%ebp
  800b8a:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800b8d:	ba 00 00 00 00       	mov    $0x0,%edx
  800b92:	b8 08 00 00 00       	mov    $0x8,%eax
  800b97:	e8 64 fd ff ff       	call   800900 <fsipc>
}
  800b9c:	c9                   	leave  
  800b9d:	c3                   	ret    

00800b9e <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800b9e:	55                   	push   %ebp
  800b9f:	89 e5                	mov    %esp,%ebp
  800ba1:	56                   	push   %esi
  800ba2:	53                   	push   %ebx
  800ba3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800ba6:	83 ec 0c             	sub    $0xc,%esp
  800ba9:	ff 75 08             	pushl  0x8(%ebp)
  800bac:	e8 cd f7 ff ff       	call   80037e <fd2data>
  800bb1:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  800bb3:	83 c4 08             	add    $0x8,%esp
  800bb6:	68 28 24 80 00       	push   $0x802428
  800bbb:	53                   	push   %ebx
  800bbc:	e8 84 10 00 00       	call   801c45 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  800bc1:	8b 46 04             	mov    0x4(%esi),%eax
  800bc4:	2b 06                	sub    (%esi),%eax
  800bc6:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  800bcc:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800bd3:	00 00 00 
	stat->st_dev = &devpipe;
  800bd6:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  800bdd:	30 80 00 
	return 0;
}
  800be0:	b8 00 00 00 00       	mov    $0x0,%eax
  800be5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800be8:	5b                   	pop    %ebx
  800be9:	5e                   	pop    %esi
  800bea:	5d                   	pop    %ebp
  800beb:	c3                   	ret    

00800bec <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  800bec:	55                   	push   %ebp
  800bed:	89 e5                	mov    %esp,%ebp
  800bef:	53                   	push   %ebx
  800bf0:	83 ec 0c             	sub    $0xc,%esp
  800bf3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  800bf6:	53                   	push   %ebx
  800bf7:	6a 00                	push   $0x0
  800bf9:	e8 e5 f5 ff ff       	call   8001e3 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  800bfe:	89 1c 24             	mov    %ebx,(%esp)
  800c01:	e8 78 f7 ff ff       	call   80037e <fd2data>
  800c06:	83 c4 08             	add    $0x8,%esp
  800c09:	50                   	push   %eax
  800c0a:	6a 00                	push   $0x0
  800c0c:	e8 d2 f5 ff ff       	call   8001e3 <sys_page_unmap>
}
  800c11:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c14:	c9                   	leave  
  800c15:	c3                   	ret    

00800c16 <_pipeisclosed>:
{
  800c16:	55                   	push   %ebp
  800c17:	89 e5                	mov    %esp,%ebp
  800c19:	57                   	push   %edi
  800c1a:	56                   	push   %esi
  800c1b:	53                   	push   %ebx
  800c1c:	83 ec 1c             	sub    $0x1c,%esp
  800c1f:	89 c7                	mov    %eax,%edi
  800c21:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  800c23:	a1 08 40 80 00       	mov    0x804008,%eax
  800c28:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  800c2b:	83 ec 0c             	sub    $0xc,%esp
  800c2e:	57                   	push   %edi
  800c2f:	e8 49 14 00 00       	call   80207d <pageref>
  800c34:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c37:	89 34 24             	mov    %esi,(%esp)
  800c3a:	e8 3e 14 00 00       	call   80207d <pageref>
		nn = thisenv->env_runs;
  800c3f:	8b 15 08 40 80 00    	mov    0x804008,%edx
  800c45:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  800c48:	83 c4 10             	add    $0x10,%esp
  800c4b:	39 cb                	cmp    %ecx,%ebx
  800c4d:	74 1b                	je     800c6a <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  800c4f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800c52:	75 cf                	jne    800c23 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  800c54:	8b 42 58             	mov    0x58(%edx),%eax
  800c57:	6a 01                	push   $0x1
  800c59:	50                   	push   %eax
  800c5a:	53                   	push   %ebx
  800c5b:	68 2f 24 80 00       	push   $0x80242f
  800c60:	e8 43 09 00 00       	call   8015a8 <cprintf>
  800c65:	83 c4 10             	add    $0x10,%esp
  800c68:	eb b9                	jmp    800c23 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  800c6a:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800c6d:	0f 94 c0             	sete   %al
  800c70:	0f b6 c0             	movzbl %al,%eax
}
  800c73:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c76:	5b                   	pop    %ebx
  800c77:	5e                   	pop    %esi
  800c78:	5f                   	pop    %edi
  800c79:	5d                   	pop    %ebp
  800c7a:	c3                   	ret    

00800c7b <devpipe_write>:
{
  800c7b:	55                   	push   %ebp
  800c7c:	89 e5                	mov    %esp,%ebp
  800c7e:	57                   	push   %edi
  800c7f:	56                   	push   %esi
  800c80:	53                   	push   %ebx
  800c81:	83 ec 28             	sub    $0x28,%esp
  800c84:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  800c87:	56                   	push   %esi
  800c88:	e8 f1 f6 ff ff       	call   80037e <fd2data>
  800c8d:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800c8f:	83 c4 10             	add    $0x10,%esp
  800c92:	bf 00 00 00 00       	mov    $0x0,%edi
  800c97:	3b 7d 10             	cmp    0x10(%ebp),%edi
  800c9a:	74 4f                	je     800ceb <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  800c9c:	8b 43 04             	mov    0x4(%ebx),%eax
  800c9f:	8b 0b                	mov    (%ebx),%ecx
  800ca1:	8d 51 20             	lea    0x20(%ecx),%edx
  800ca4:	39 d0                	cmp    %edx,%eax
  800ca6:	72 14                	jb     800cbc <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  800ca8:	89 da                	mov    %ebx,%edx
  800caa:	89 f0                	mov    %esi,%eax
  800cac:	e8 65 ff ff ff       	call   800c16 <_pipeisclosed>
  800cb1:	85 c0                	test   %eax,%eax
  800cb3:	75 3a                	jne    800cef <devpipe_write+0x74>
			sys_yield();
  800cb5:	e8 85 f4 ff ff       	call   80013f <sys_yield>
  800cba:	eb e0                	jmp    800c9c <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  800cbc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cbf:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  800cc3:	88 4d e7             	mov    %cl,-0x19(%ebp)
  800cc6:	89 c2                	mov    %eax,%edx
  800cc8:	c1 fa 1f             	sar    $0x1f,%edx
  800ccb:	89 d1                	mov    %edx,%ecx
  800ccd:	c1 e9 1b             	shr    $0x1b,%ecx
  800cd0:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  800cd3:	83 e2 1f             	and    $0x1f,%edx
  800cd6:	29 ca                	sub    %ecx,%edx
  800cd8:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  800cdc:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  800ce0:	83 c0 01             	add    $0x1,%eax
  800ce3:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  800ce6:	83 c7 01             	add    $0x1,%edi
  800ce9:	eb ac                	jmp    800c97 <devpipe_write+0x1c>
	return i;
  800ceb:	89 f8                	mov    %edi,%eax
  800ced:	eb 05                	jmp    800cf4 <devpipe_write+0x79>
				return 0;
  800cef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cf4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cf7:	5b                   	pop    %ebx
  800cf8:	5e                   	pop    %esi
  800cf9:	5f                   	pop    %edi
  800cfa:	5d                   	pop    %ebp
  800cfb:	c3                   	ret    

00800cfc <devpipe_read>:
{
  800cfc:	55                   	push   %ebp
  800cfd:	89 e5                	mov    %esp,%ebp
  800cff:	57                   	push   %edi
  800d00:	56                   	push   %esi
  800d01:	53                   	push   %ebx
  800d02:	83 ec 18             	sub    $0x18,%esp
  800d05:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  800d08:	57                   	push   %edi
  800d09:	e8 70 f6 ff ff       	call   80037e <fd2data>
  800d0e:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800d10:	83 c4 10             	add    $0x10,%esp
  800d13:	be 00 00 00 00       	mov    $0x0,%esi
  800d18:	3b 75 10             	cmp    0x10(%ebp),%esi
  800d1b:	74 47                	je     800d64 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  800d1d:	8b 03                	mov    (%ebx),%eax
  800d1f:	3b 43 04             	cmp    0x4(%ebx),%eax
  800d22:	75 22                	jne    800d46 <devpipe_read+0x4a>
			if (i > 0)
  800d24:	85 f6                	test   %esi,%esi
  800d26:	75 14                	jne    800d3c <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  800d28:	89 da                	mov    %ebx,%edx
  800d2a:	89 f8                	mov    %edi,%eax
  800d2c:	e8 e5 fe ff ff       	call   800c16 <_pipeisclosed>
  800d31:	85 c0                	test   %eax,%eax
  800d33:	75 33                	jne    800d68 <devpipe_read+0x6c>
			sys_yield();
  800d35:	e8 05 f4 ff ff       	call   80013f <sys_yield>
  800d3a:	eb e1                	jmp    800d1d <devpipe_read+0x21>
				return i;
  800d3c:	89 f0                	mov    %esi,%eax
}
  800d3e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d41:	5b                   	pop    %ebx
  800d42:	5e                   	pop    %esi
  800d43:	5f                   	pop    %edi
  800d44:	5d                   	pop    %ebp
  800d45:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  800d46:	99                   	cltd   
  800d47:	c1 ea 1b             	shr    $0x1b,%edx
  800d4a:	01 d0                	add    %edx,%eax
  800d4c:	83 e0 1f             	and    $0x1f,%eax
  800d4f:	29 d0                	sub    %edx,%eax
  800d51:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  800d56:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d59:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  800d5c:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  800d5f:	83 c6 01             	add    $0x1,%esi
  800d62:	eb b4                	jmp    800d18 <devpipe_read+0x1c>
	return i;
  800d64:	89 f0                	mov    %esi,%eax
  800d66:	eb d6                	jmp    800d3e <devpipe_read+0x42>
				return 0;
  800d68:	b8 00 00 00 00       	mov    $0x0,%eax
  800d6d:	eb cf                	jmp    800d3e <devpipe_read+0x42>

00800d6f <pipe>:
{
  800d6f:	55                   	push   %ebp
  800d70:	89 e5                	mov    %esp,%ebp
  800d72:	56                   	push   %esi
  800d73:	53                   	push   %ebx
  800d74:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  800d77:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800d7a:	50                   	push   %eax
  800d7b:	e8 15 f6 ff ff       	call   800395 <fd_alloc>
  800d80:	89 c3                	mov    %eax,%ebx
  800d82:	83 c4 10             	add    $0x10,%esp
  800d85:	85 c0                	test   %eax,%eax
  800d87:	78 5b                	js     800de4 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800d89:	83 ec 04             	sub    $0x4,%esp
  800d8c:	68 07 04 00 00       	push   $0x407
  800d91:	ff 75 f4             	pushl  -0xc(%ebp)
  800d94:	6a 00                	push   $0x0
  800d96:	e8 c3 f3 ff ff       	call   80015e <sys_page_alloc>
  800d9b:	89 c3                	mov    %eax,%ebx
  800d9d:	83 c4 10             	add    $0x10,%esp
  800da0:	85 c0                	test   %eax,%eax
  800da2:	78 40                	js     800de4 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  800da4:	83 ec 0c             	sub    $0xc,%esp
  800da7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800daa:	50                   	push   %eax
  800dab:	e8 e5 f5 ff ff       	call   800395 <fd_alloc>
  800db0:	89 c3                	mov    %eax,%ebx
  800db2:	83 c4 10             	add    $0x10,%esp
  800db5:	85 c0                	test   %eax,%eax
  800db7:	78 1b                	js     800dd4 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800db9:	83 ec 04             	sub    $0x4,%esp
  800dbc:	68 07 04 00 00       	push   $0x407
  800dc1:	ff 75 f0             	pushl  -0x10(%ebp)
  800dc4:	6a 00                	push   $0x0
  800dc6:	e8 93 f3 ff ff       	call   80015e <sys_page_alloc>
  800dcb:	89 c3                	mov    %eax,%ebx
  800dcd:	83 c4 10             	add    $0x10,%esp
  800dd0:	85 c0                	test   %eax,%eax
  800dd2:	79 19                	jns    800ded <pipe+0x7e>
	sys_page_unmap(0, fd0);
  800dd4:	83 ec 08             	sub    $0x8,%esp
  800dd7:	ff 75 f4             	pushl  -0xc(%ebp)
  800dda:	6a 00                	push   $0x0
  800ddc:	e8 02 f4 ff ff       	call   8001e3 <sys_page_unmap>
  800de1:	83 c4 10             	add    $0x10,%esp
}
  800de4:	89 d8                	mov    %ebx,%eax
  800de6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800de9:	5b                   	pop    %ebx
  800dea:	5e                   	pop    %esi
  800deb:	5d                   	pop    %ebp
  800dec:	c3                   	ret    
	va = fd2data(fd0);
  800ded:	83 ec 0c             	sub    $0xc,%esp
  800df0:	ff 75 f4             	pushl  -0xc(%ebp)
  800df3:	e8 86 f5 ff ff       	call   80037e <fd2data>
  800df8:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800dfa:	83 c4 0c             	add    $0xc,%esp
  800dfd:	68 07 04 00 00       	push   $0x407
  800e02:	50                   	push   %eax
  800e03:	6a 00                	push   $0x0
  800e05:	e8 54 f3 ff ff       	call   80015e <sys_page_alloc>
  800e0a:	89 c3                	mov    %eax,%ebx
  800e0c:	83 c4 10             	add    $0x10,%esp
  800e0f:	85 c0                	test   %eax,%eax
  800e11:	0f 88 8c 00 00 00    	js     800ea3 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e17:	83 ec 0c             	sub    $0xc,%esp
  800e1a:	ff 75 f0             	pushl  -0x10(%ebp)
  800e1d:	e8 5c f5 ff ff       	call   80037e <fd2data>
  800e22:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  800e29:	50                   	push   %eax
  800e2a:	6a 00                	push   $0x0
  800e2c:	56                   	push   %esi
  800e2d:	6a 00                	push   $0x0
  800e2f:	e8 6d f3 ff ff       	call   8001a1 <sys_page_map>
  800e34:	89 c3                	mov    %eax,%ebx
  800e36:	83 c4 20             	add    $0x20,%esp
  800e39:	85 c0                	test   %eax,%eax
  800e3b:	78 58                	js     800e95 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  800e3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e40:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800e46:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  800e48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e4b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  800e52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e55:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800e5b:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  800e5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e60:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  800e67:	83 ec 0c             	sub    $0xc,%esp
  800e6a:	ff 75 f4             	pushl  -0xc(%ebp)
  800e6d:	e8 fc f4 ff ff       	call   80036e <fd2num>
  800e72:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e75:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  800e77:	83 c4 04             	add    $0x4,%esp
  800e7a:	ff 75 f0             	pushl  -0x10(%ebp)
  800e7d:	e8 ec f4 ff ff       	call   80036e <fd2num>
  800e82:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e85:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  800e88:	83 c4 10             	add    $0x10,%esp
  800e8b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e90:	e9 4f ff ff ff       	jmp    800de4 <pipe+0x75>
	sys_page_unmap(0, va);
  800e95:	83 ec 08             	sub    $0x8,%esp
  800e98:	56                   	push   %esi
  800e99:	6a 00                	push   $0x0
  800e9b:	e8 43 f3 ff ff       	call   8001e3 <sys_page_unmap>
  800ea0:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  800ea3:	83 ec 08             	sub    $0x8,%esp
  800ea6:	ff 75 f0             	pushl  -0x10(%ebp)
  800ea9:	6a 00                	push   $0x0
  800eab:	e8 33 f3 ff ff       	call   8001e3 <sys_page_unmap>
  800eb0:	83 c4 10             	add    $0x10,%esp
  800eb3:	e9 1c ff ff ff       	jmp    800dd4 <pipe+0x65>

00800eb8 <pipeisclosed>:
{
  800eb8:	55                   	push   %ebp
  800eb9:	89 e5                	mov    %esp,%ebp
  800ebb:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800ebe:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800ec1:	50                   	push   %eax
  800ec2:	ff 75 08             	pushl  0x8(%ebp)
  800ec5:	e8 1a f5 ff ff       	call   8003e4 <fd_lookup>
  800eca:	83 c4 10             	add    $0x10,%esp
  800ecd:	85 c0                	test   %eax,%eax
  800ecf:	78 18                	js     800ee9 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  800ed1:	83 ec 0c             	sub    $0xc,%esp
  800ed4:	ff 75 f4             	pushl  -0xc(%ebp)
  800ed7:	e8 a2 f4 ff ff       	call   80037e <fd2data>
	return _pipeisclosed(fd, p);
  800edc:	89 c2                	mov    %eax,%edx
  800ede:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ee1:	e8 30 fd ff ff       	call   800c16 <_pipeisclosed>
  800ee6:	83 c4 10             	add    $0x10,%esp
}
  800ee9:	c9                   	leave  
  800eea:	c3                   	ret    

00800eeb <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  800eeb:	55                   	push   %ebp
  800eec:	89 e5                	mov    %esp,%ebp
  800eee:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  800ef1:	68 47 24 80 00       	push   $0x802447
  800ef6:	ff 75 0c             	pushl  0xc(%ebp)
  800ef9:	e8 47 0d 00 00       	call   801c45 <strcpy>
	return 0;
}
  800efe:	b8 00 00 00 00       	mov    $0x0,%eax
  800f03:	c9                   	leave  
  800f04:	c3                   	ret    

00800f05 <devsock_close>:
{
  800f05:	55                   	push   %ebp
  800f06:	89 e5                	mov    %esp,%ebp
  800f08:	53                   	push   %ebx
  800f09:	83 ec 10             	sub    $0x10,%esp
  800f0c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  800f0f:	53                   	push   %ebx
  800f10:	e8 68 11 00 00       	call   80207d <pageref>
  800f15:	83 c4 10             	add    $0x10,%esp
		return 0;
  800f18:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  800f1d:	83 f8 01             	cmp    $0x1,%eax
  800f20:	74 07                	je     800f29 <devsock_close+0x24>
}
  800f22:	89 d0                	mov    %edx,%eax
  800f24:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f27:	c9                   	leave  
  800f28:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  800f29:	83 ec 0c             	sub    $0xc,%esp
  800f2c:	ff 73 0c             	pushl  0xc(%ebx)
  800f2f:	e8 b7 02 00 00       	call   8011eb <nsipc_close>
  800f34:	89 c2                	mov    %eax,%edx
  800f36:	83 c4 10             	add    $0x10,%esp
  800f39:	eb e7                	jmp    800f22 <devsock_close+0x1d>

00800f3b <devsock_write>:
{
  800f3b:	55                   	push   %ebp
  800f3c:	89 e5                	mov    %esp,%ebp
  800f3e:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  800f41:	6a 00                	push   $0x0
  800f43:	ff 75 10             	pushl  0x10(%ebp)
  800f46:	ff 75 0c             	pushl  0xc(%ebp)
  800f49:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4c:	ff 70 0c             	pushl  0xc(%eax)
  800f4f:	e8 74 03 00 00       	call   8012c8 <nsipc_send>
}
  800f54:	c9                   	leave  
  800f55:	c3                   	ret    

00800f56 <devsock_read>:
{
  800f56:	55                   	push   %ebp
  800f57:	89 e5                	mov    %esp,%ebp
  800f59:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  800f5c:	6a 00                	push   $0x0
  800f5e:	ff 75 10             	pushl  0x10(%ebp)
  800f61:	ff 75 0c             	pushl  0xc(%ebp)
  800f64:	8b 45 08             	mov    0x8(%ebp),%eax
  800f67:	ff 70 0c             	pushl  0xc(%eax)
  800f6a:	e8 ed 02 00 00       	call   80125c <nsipc_recv>
}
  800f6f:	c9                   	leave  
  800f70:	c3                   	ret    

00800f71 <fd2sockid>:
{
  800f71:	55                   	push   %ebp
  800f72:	89 e5                	mov    %esp,%ebp
  800f74:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  800f77:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800f7a:	52                   	push   %edx
  800f7b:	50                   	push   %eax
  800f7c:	e8 63 f4 ff ff       	call   8003e4 <fd_lookup>
  800f81:	83 c4 10             	add    $0x10,%esp
  800f84:	85 c0                	test   %eax,%eax
  800f86:	78 10                	js     800f98 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  800f88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f8b:	8b 0d 3c 30 80 00    	mov    0x80303c,%ecx
  800f91:	39 08                	cmp    %ecx,(%eax)
  800f93:	75 05                	jne    800f9a <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  800f95:	8b 40 0c             	mov    0xc(%eax),%eax
}
  800f98:	c9                   	leave  
  800f99:	c3                   	ret    
		return -E_NOT_SUPP;
  800f9a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800f9f:	eb f7                	jmp    800f98 <fd2sockid+0x27>

00800fa1 <alloc_sockfd>:
{
  800fa1:	55                   	push   %ebp
  800fa2:	89 e5                	mov    %esp,%ebp
  800fa4:	56                   	push   %esi
  800fa5:	53                   	push   %ebx
  800fa6:	83 ec 1c             	sub    $0x1c,%esp
  800fa9:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  800fab:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800fae:	50                   	push   %eax
  800faf:	e8 e1 f3 ff ff       	call   800395 <fd_alloc>
  800fb4:	89 c3                	mov    %eax,%ebx
  800fb6:	83 c4 10             	add    $0x10,%esp
  800fb9:	85 c0                	test   %eax,%eax
  800fbb:	78 43                	js     801000 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  800fbd:	83 ec 04             	sub    $0x4,%esp
  800fc0:	68 07 04 00 00       	push   $0x407
  800fc5:	ff 75 f4             	pushl  -0xc(%ebp)
  800fc8:	6a 00                	push   $0x0
  800fca:	e8 8f f1 ff ff       	call   80015e <sys_page_alloc>
  800fcf:	89 c3                	mov    %eax,%ebx
  800fd1:	83 c4 10             	add    $0x10,%esp
  800fd4:	85 c0                	test   %eax,%eax
  800fd6:	78 28                	js     801000 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  800fd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fdb:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  800fe1:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  800fe3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fe6:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  800fed:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  800ff0:	83 ec 0c             	sub    $0xc,%esp
  800ff3:	50                   	push   %eax
  800ff4:	e8 75 f3 ff ff       	call   80036e <fd2num>
  800ff9:	89 c3                	mov    %eax,%ebx
  800ffb:	83 c4 10             	add    $0x10,%esp
  800ffe:	eb 0c                	jmp    80100c <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801000:	83 ec 0c             	sub    $0xc,%esp
  801003:	56                   	push   %esi
  801004:	e8 e2 01 00 00       	call   8011eb <nsipc_close>
		return r;
  801009:	83 c4 10             	add    $0x10,%esp
}
  80100c:	89 d8                	mov    %ebx,%eax
  80100e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801011:	5b                   	pop    %ebx
  801012:	5e                   	pop    %esi
  801013:	5d                   	pop    %ebp
  801014:	c3                   	ret    

00801015 <accept>:
{
  801015:	55                   	push   %ebp
  801016:	89 e5                	mov    %esp,%ebp
  801018:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80101b:	8b 45 08             	mov    0x8(%ebp),%eax
  80101e:	e8 4e ff ff ff       	call   800f71 <fd2sockid>
  801023:	85 c0                	test   %eax,%eax
  801025:	78 1b                	js     801042 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801027:	83 ec 04             	sub    $0x4,%esp
  80102a:	ff 75 10             	pushl  0x10(%ebp)
  80102d:	ff 75 0c             	pushl  0xc(%ebp)
  801030:	50                   	push   %eax
  801031:	e8 0e 01 00 00       	call   801144 <nsipc_accept>
  801036:	83 c4 10             	add    $0x10,%esp
  801039:	85 c0                	test   %eax,%eax
  80103b:	78 05                	js     801042 <accept+0x2d>
	return alloc_sockfd(r);
  80103d:	e8 5f ff ff ff       	call   800fa1 <alloc_sockfd>
}
  801042:	c9                   	leave  
  801043:	c3                   	ret    

00801044 <bind>:
{
  801044:	55                   	push   %ebp
  801045:	89 e5                	mov    %esp,%ebp
  801047:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80104a:	8b 45 08             	mov    0x8(%ebp),%eax
  80104d:	e8 1f ff ff ff       	call   800f71 <fd2sockid>
  801052:	85 c0                	test   %eax,%eax
  801054:	78 12                	js     801068 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801056:	83 ec 04             	sub    $0x4,%esp
  801059:	ff 75 10             	pushl  0x10(%ebp)
  80105c:	ff 75 0c             	pushl  0xc(%ebp)
  80105f:	50                   	push   %eax
  801060:	e8 2f 01 00 00       	call   801194 <nsipc_bind>
  801065:	83 c4 10             	add    $0x10,%esp
}
  801068:	c9                   	leave  
  801069:	c3                   	ret    

0080106a <shutdown>:
{
  80106a:	55                   	push   %ebp
  80106b:	89 e5                	mov    %esp,%ebp
  80106d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801070:	8b 45 08             	mov    0x8(%ebp),%eax
  801073:	e8 f9 fe ff ff       	call   800f71 <fd2sockid>
  801078:	85 c0                	test   %eax,%eax
  80107a:	78 0f                	js     80108b <shutdown+0x21>
	return nsipc_shutdown(r, how);
  80107c:	83 ec 08             	sub    $0x8,%esp
  80107f:	ff 75 0c             	pushl  0xc(%ebp)
  801082:	50                   	push   %eax
  801083:	e8 41 01 00 00       	call   8011c9 <nsipc_shutdown>
  801088:	83 c4 10             	add    $0x10,%esp
}
  80108b:	c9                   	leave  
  80108c:	c3                   	ret    

0080108d <connect>:
{
  80108d:	55                   	push   %ebp
  80108e:	89 e5                	mov    %esp,%ebp
  801090:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801093:	8b 45 08             	mov    0x8(%ebp),%eax
  801096:	e8 d6 fe ff ff       	call   800f71 <fd2sockid>
  80109b:	85 c0                	test   %eax,%eax
  80109d:	78 12                	js     8010b1 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  80109f:	83 ec 04             	sub    $0x4,%esp
  8010a2:	ff 75 10             	pushl  0x10(%ebp)
  8010a5:	ff 75 0c             	pushl  0xc(%ebp)
  8010a8:	50                   	push   %eax
  8010a9:	e8 57 01 00 00       	call   801205 <nsipc_connect>
  8010ae:	83 c4 10             	add    $0x10,%esp
}
  8010b1:	c9                   	leave  
  8010b2:	c3                   	ret    

008010b3 <listen>:
{
  8010b3:	55                   	push   %ebp
  8010b4:	89 e5                	mov    %esp,%ebp
  8010b6:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8010b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bc:	e8 b0 fe ff ff       	call   800f71 <fd2sockid>
  8010c1:	85 c0                	test   %eax,%eax
  8010c3:	78 0f                	js     8010d4 <listen+0x21>
	return nsipc_listen(r, backlog);
  8010c5:	83 ec 08             	sub    $0x8,%esp
  8010c8:	ff 75 0c             	pushl  0xc(%ebp)
  8010cb:	50                   	push   %eax
  8010cc:	e8 69 01 00 00       	call   80123a <nsipc_listen>
  8010d1:	83 c4 10             	add    $0x10,%esp
}
  8010d4:	c9                   	leave  
  8010d5:	c3                   	ret    

008010d6 <socket>:

int
socket(int domain, int type, int protocol)
{
  8010d6:	55                   	push   %ebp
  8010d7:	89 e5                	mov    %esp,%ebp
  8010d9:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8010dc:	ff 75 10             	pushl  0x10(%ebp)
  8010df:	ff 75 0c             	pushl  0xc(%ebp)
  8010e2:	ff 75 08             	pushl  0x8(%ebp)
  8010e5:	e8 3c 02 00 00       	call   801326 <nsipc_socket>
  8010ea:	83 c4 10             	add    $0x10,%esp
  8010ed:	85 c0                	test   %eax,%eax
  8010ef:	78 05                	js     8010f6 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8010f1:	e8 ab fe ff ff       	call   800fa1 <alloc_sockfd>
}
  8010f6:	c9                   	leave  
  8010f7:	c3                   	ret    

008010f8 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8010f8:	55                   	push   %ebp
  8010f9:	89 e5                	mov    %esp,%ebp
  8010fb:	53                   	push   %ebx
  8010fc:	83 ec 04             	sub    $0x4,%esp
  8010ff:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801101:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801108:	74 26                	je     801130 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80110a:	6a 07                	push   $0x7
  80110c:	68 00 60 80 00       	push   $0x806000
  801111:	53                   	push   %ebx
  801112:	ff 35 04 40 80 00    	pushl  0x804004
  801118:	e8 ce 0e 00 00       	call   801feb <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  80111d:	83 c4 0c             	add    $0xc,%esp
  801120:	6a 00                	push   $0x0
  801122:	6a 00                	push   $0x0
  801124:	6a 00                	push   $0x0
  801126:	e8 57 0e 00 00       	call   801f82 <ipc_recv>
}
  80112b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80112e:	c9                   	leave  
  80112f:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801130:	83 ec 0c             	sub    $0xc,%esp
  801133:	6a 02                	push   $0x2
  801135:	e8 0a 0f 00 00       	call   802044 <ipc_find_env>
  80113a:	a3 04 40 80 00       	mov    %eax,0x804004
  80113f:	83 c4 10             	add    $0x10,%esp
  801142:	eb c6                	jmp    80110a <nsipc+0x12>

00801144 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801144:	55                   	push   %ebp
  801145:	89 e5                	mov    %esp,%ebp
  801147:	56                   	push   %esi
  801148:	53                   	push   %ebx
  801149:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  80114c:	8b 45 08             	mov    0x8(%ebp),%eax
  80114f:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801154:	8b 06                	mov    (%esi),%eax
  801156:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80115b:	b8 01 00 00 00       	mov    $0x1,%eax
  801160:	e8 93 ff ff ff       	call   8010f8 <nsipc>
  801165:	89 c3                	mov    %eax,%ebx
  801167:	85 c0                	test   %eax,%eax
  801169:	78 20                	js     80118b <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80116b:	83 ec 04             	sub    $0x4,%esp
  80116e:	ff 35 10 60 80 00    	pushl  0x806010
  801174:	68 00 60 80 00       	push   $0x806000
  801179:	ff 75 0c             	pushl  0xc(%ebp)
  80117c:	e8 52 0c 00 00       	call   801dd3 <memmove>
		*addrlen = ret->ret_addrlen;
  801181:	a1 10 60 80 00       	mov    0x806010,%eax
  801186:	89 06                	mov    %eax,(%esi)
  801188:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  80118b:	89 d8                	mov    %ebx,%eax
  80118d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801190:	5b                   	pop    %ebx
  801191:	5e                   	pop    %esi
  801192:	5d                   	pop    %ebp
  801193:	c3                   	ret    

00801194 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801194:	55                   	push   %ebp
  801195:	89 e5                	mov    %esp,%ebp
  801197:	53                   	push   %ebx
  801198:	83 ec 08             	sub    $0x8,%esp
  80119b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  80119e:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a1:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8011a6:	53                   	push   %ebx
  8011a7:	ff 75 0c             	pushl  0xc(%ebp)
  8011aa:	68 04 60 80 00       	push   $0x806004
  8011af:	e8 1f 0c 00 00       	call   801dd3 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8011b4:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  8011ba:	b8 02 00 00 00       	mov    $0x2,%eax
  8011bf:	e8 34 ff ff ff       	call   8010f8 <nsipc>
}
  8011c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011c7:	c9                   	leave  
  8011c8:	c3                   	ret    

008011c9 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8011c9:	55                   	push   %ebp
  8011ca:	89 e5                	mov    %esp,%ebp
  8011cc:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8011cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d2:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  8011d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011da:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  8011df:	b8 03 00 00 00       	mov    $0x3,%eax
  8011e4:	e8 0f ff ff ff       	call   8010f8 <nsipc>
}
  8011e9:	c9                   	leave  
  8011ea:	c3                   	ret    

008011eb <nsipc_close>:

int
nsipc_close(int s)
{
  8011eb:	55                   	push   %ebp
  8011ec:	89 e5                	mov    %esp,%ebp
  8011ee:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8011f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f4:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  8011f9:	b8 04 00 00 00       	mov    $0x4,%eax
  8011fe:	e8 f5 fe ff ff       	call   8010f8 <nsipc>
}
  801203:	c9                   	leave  
  801204:	c3                   	ret    

00801205 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801205:	55                   	push   %ebp
  801206:	89 e5                	mov    %esp,%ebp
  801208:	53                   	push   %ebx
  801209:	83 ec 08             	sub    $0x8,%esp
  80120c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80120f:	8b 45 08             	mov    0x8(%ebp),%eax
  801212:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801217:	53                   	push   %ebx
  801218:	ff 75 0c             	pushl  0xc(%ebp)
  80121b:	68 04 60 80 00       	push   $0x806004
  801220:	e8 ae 0b 00 00       	call   801dd3 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801225:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  80122b:	b8 05 00 00 00       	mov    $0x5,%eax
  801230:	e8 c3 fe ff ff       	call   8010f8 <nsipc>
}
  801235:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801238:	c9                   	leave  
  801239:	c3                   	ret    

0080123a <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80123a:	55                   	push   %ebp
  80123b:	89 e5                	mov    %esp,%ebp
  80123d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801240:	8b 45 08             	mov    0x8(%ebp),%eax
  801243:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801248:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124b:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801250:	b8 06 00 00 00       	mov    $0x6,%eax
  801255:	e8 9e fe ff ff       	call   8010f8 <nsipc>
}
  80125a:	c9                   	leave  
  80125b:	c3                   	ret    

0080125c <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80125c:	55                   	push   %ebp
  80125d:	89 e5                	mov    %esp,%ebp
  80125f:	56                   	push   %esi
  801260:	53                   	push   %ebx
  801261:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801264:	8b 45 08             	mov    0x8(%ebp),%eax
  801267:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  80126c:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801272:	8b 45 14             	mov    0x14(%ebp),%eax
  801275:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80127a:	b8 07 00 00 00       	mov    $0x7,%eax
  80127f:	e8 74 fe ff ff       	call   8010f8 <nsipc>
  801284:	89 c3                	mov    %eax,%ebx
  801286:	85 c0                	test   %eax,%eax
  801288:	78 1f                	js     8012a9 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  80128a:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  80128f:	7f 21                	jg     8012b2 <nsipc_recv+0x56>
  801291:	39 c6                	cmp    %eax,%esi
  801293:	7c 1d                	jl     8012b2 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801295:	83 ec 04             	sub    $0x4,%esp
  801298:	50                   	push   %eax
  801299:	68 00 60 80 00       	push   $0x806000
  80129e:	ff 75 0c             	pushl  0xc(%ebp)
  8012a1:	e8 2d 0b 00 00       	call   801dd3 <memmove>
  8012a6:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8012a9:	89 d8                	mov    %ebx,%eax
  8012ab:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012ae:	5b                   	pop    %ebx
  8012af:	5e                   	pop    %esi
  8012b0:	5d                   	pop    %ebp
  8012b1:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8012b2:	68 53 24 80 00       	push   $0x802453
  8012b7:	68 f5 23 80 00       	push   $0x8023f5
  8012bc:	6a 62                	push   $0x62
  8012be:	68 68 24 80 00       	push   $0x802468
  8012c3:	e8 05 02 00 00       	call   8014cd <_panic>

008012c8 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8012c8:	55                   	push   %ebp
  8012c9:	89 e5                	mov    %esp,%ebp
  8012cb:	53                   	push   %ebx
  8012cc:	83 ec 04             	sub    $0x4,%esp
  8012cf:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8012d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d5:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  8012da:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8012e0:	7f 2e                	jg     801310 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8012e2:	83 ec 04             	sub    $0x4,%esp
  8012e5:	53                   	push   %ebx
  8012e6:	ff 75 0c             	pushl  0xc(%ebp)
  8012e9:	68 0c 60 80 00       	push   $0x80600c
  8012ee:	e8 e0 0a 00 00       	call   801dd3 <memmove>
	nsipcbuf.send.req_size = size;
  8012f3:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  8012f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8012fc:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801301:	b8 08 00 00 00       	mov    $0x8,%eax
  801306:	e8 ed fd ff ff       	call   8010f8 <nsipc>
}
  80130b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80130e:	c9                   	leave  
  80130f:	c3                   	ret    
	assert(size < 1600);
  801310:	68 74 24 80 00       	push   $0x802474
  801315:	68 f5 23 80 00       	push   $0x8023f5
  80131a:	6a 6d                	push   $0x6d
  80131c:	68 68 24 80 00       	push   $0x802468
  801321:	e8 a7 01 00 00       	call   8014cd <_panic>

00801326 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801326:	55                   	push   %ebp
  801327:	89 e5                	mov    %esp,%ebp
  801329:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80132c:	8b 45 08             	mov    0x8(%ebp),%eax
  80132f:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801334:	8b 45 0c             	mov    0xc(%ebp),%eax
  801337:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  80133c:	8b 45 10             	mov    0x10(%ebp),%eax
  80133f:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801344:	b8 09 00 00 00       	mov    $0x9,%eax
  801349:	e8 aa fd ff ff       	call   8010f8 <nsipc>
}
  80134e:	c9                   	leave  
  80134f:	c3                   	ret    

00801350 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801350:	55                   	push   %ebp
  801351:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801353:	b8 00 00 00 00       	mov    $0x0,%eax
  801358:	5d                   	pop    %ebp
  801359:	c3                   	ret    

0080135a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80135a:	55                   	push   %ebp
  80135b:	89 e5                	mov    %esp,%ebp
  80135d:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801360:	68 80 24 80 00       	push   $0x802480
  801365:	ff 75 0c             	pushl  0xc(%ebp)
  801368:	e8 d8 08 00 00       	call   801c45 <strcpy>
	return 0;
}
  80136d:	b8 00 00 00 00       	mov    $0x0,%eax
  801372:	c9                   	leave  
  801373:	c3                   	ret    

00801374 <devcons_write>:
{
  801374:	55                   	push   %ebp
  801375:	89 e5                	mov    %esp,%ebp
  801377:	57                   	push   %edi
  801378:	56                   	push   %esi
  801379:	53                   	push   %ebx
  80137a:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801380:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801385:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80138b:	eb 2f                	jmp    8013bc <devcons_write+0x48>
		m = n - tot;
  80138d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801390:	29 f3                	sub    %esi,%ebx
  801392:	83 fb 7f             	cmp    $0x7f,%ebx
  801395:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80139a:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80139d:	83 ec 04             	sub    $0x4,%esp
  8013a0:	53                   	push   %ebx
  8013a1:	89 f0                	mov    %esi,%eax
  8013a3:	03 45 0c             	add    0xc(%ebp),%eax
  8013a6:	50                   	push   %eax
  8013a7:	57                   	push   %edi
  8013a8:	e8 26 0a 00 00       	call   801dd3 <memmove>
		sys_cputs(buf, m);
  8013ad:	83 c4 08             	add    $0x8,%esp
  8013b0:	53                   	push   %ebx
  8013b1:	57                   	push   %edi
  8013b2:	e8 eb ec ff ff       	call   8000a2 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8013b7:	01 de                	add    %ebx,%esi
  8013b9:	83 c4 10             	add    $0x10,%esp
  8013bc:	3b 75 10             	cmp    0x10(%ebp),%esi
  8013bf:	72 cc                	jb     80138d <devcons_write+0x19>
}
  8013c1:	89 f0                	mov    %esi,%eax
  8013c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013c6:	5b                   	pop    %ebx
  8013c7:	5e                   	pop    %esi
  8013c8:	5f                   	pop    %edi
  8013c9:	5d                   	pop    %ebp
  8013ca:	c3                   	ret    

008013cb <devcons_read>:
{
  8013cb:	55                   	push   %ebp
  8013cc:	89 e5                	mov    %esp,%ebp
  8013ce:	83 ec 08             	sub    $0x8,%esp
  8013d1:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8013d6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013da:	75 07                	jne    8013e3 <devcons_read+0x18>
}
  8013dc:	c9                   	leave  
  8013dd:	c3                   	ret    
		sys_yield();
  8013de:	e8 5c ed ff ff       	call   80013f <sys_yield>
	while ((c = sys_cgetc()) == 0)
  8013e3:	e8 d8 ec ff ff       	call   8000c0 <sys_cgetc>
  8013e8:	85 c0                	test   %eax,%eax
  8013ea:	74 f2                	je     8013de <devcons_read+0x13>
	if (c < 0)
  8013ec:	85 c0                	test   %eax,%eax
  8013ee:	78 ec                	js     8013dc <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  8013f0:	83 f8 04             	cmp    $0x4,%eax
  8013f3:	74 0c                	je     801401 <devcons_read+0x36>
	*(char*)vbuf = c;
  8013f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013f8:	88 02                	mov    %al,(%edx)
	return 1;
  8013fa:	b8 01 00 00 00       	mov    $0x1,%eax
  8013ff:	eb db                	jmp    8013dc <devcons_read+0x11>
		return 0;
  801401:	b8 00 00 00 00       	mov    $0x0,%eax
  801406:	eb d4                	jmp    8013dc <devcons_read+0x11>

00801408 <cputchar>:
{
  801408:	55                   	push   %ebp
  801409:	89 e5                	mov    %esp,%ebp
  80140b:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80140e:	8b 45 08             	mov    0x8(%ebp),%eax
  801411:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801414:	6a 01                	push   $0x1
  801416:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801419:	50                   	push   %eax
  80141a:	e8 83 ec ff ff       	call   8000a2 <sys_cputs>
}
  80141f:	83 c4 10             	add    $0x10,%esp
  801422:	c9                   	leave  
  801423:	c3                   	ret    

00801424 <getchar>:
{
  801424:	55                   	push   %ebp
  801425:	89 e5                	mov    %esp,%ebp
  801427:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80142a:	6a 01                	push   $0x1
  80142c:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80142f:	50                   	push   %eax
  801430:	6a 00                	push   $0x0
  801432:	e8 1e f2 ff ff       	call   800655 <read>
	if (r < 0)
  801437:	83 c4 10             	add    $0x10,%esp
  80143a:	85 c0                	test   %eax,%eax
  80143c:	78 08                	js     801446 <getchar+0x22>
	if (r < 1)
  80143e:	85 c0                	test   %eax,%eax
  801440:	7e 06                	jle    801448 <getchar+0x24>
	return c;
  801442:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801446:	c9                   	leave  
  801447:	c3                   	ret    
		return -E_EOF;
  801448:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80144d:	eb f7                	jmp    801446 <getchar+0x22>

0080144f <iscons>:
{
  80144f:	55                   	push   %ebp
  801450:	89 e5                	mov    %esp,%ebp
  801452:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801455:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801458:	50                   	push   %eax
  801459:	ff 75 08             	pushl  0x8(%ebp)
  80145c:	e8 83 ef ff ff       	call   8003e4 <fd_lookup>
  801461:	83 c4 10             	add    $0x10,%esp
  801464:	85 c0                	test   %eax,%eax
  801466:	78 11                	js     801479 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801468:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80146b:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801471:	39 10                	cmp    %edx,(%eax)
  801473:	0f 94 c0             	sete   %al
  801476:	0f b6 c0             	movzbl %al,%eax
}
  801479:	c9                   	leave  
  80147a:	c3                   	ret    

0080147b <opencons>:
{
  80147b:	55                   	push   %ebp
  80147c:	89 e5                	mov    %esp,%ebp
  80147e:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801481:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801484:	50                   	push   %eax
  801485:	e8 0b ef ff ff       	call   800395 <fd_alloc>
  80148a:	83 c4 10             	add    $0x10,%esp
  80148d:	85 c0                	test   %eax,%eax
  80148f:	78 3a                	js     8014cb <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801491:	83 ec 04             	sub    $0x4,%esp
  801494:	68 07 04 00 00       	push   $0x407
  801499:	ff 75 f4             	pushl  -0xc(%ebp)
  80149c:	6a 00                	push   $0x0
  80149e:	e8 bb ec ff ff       	call   80015e <sys_page_alloc>
  8014a3:	83 c4 10             	add    $0x10,%esp
  8014a6:	85 c0                	test   %eax,%eax
  8014a8:	78 21                	js     8014cb <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8014aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014ad:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8014b3:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8014b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014b8:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8014bf:	83 ec 0c             	sub    $0xc,%esp
  8014c2:	50                   	push   %eax
  8014c3:	e8 a6 ee ff ff       	call   80036e <fd2num>
  8014c8:	83 c4 10             	add    $0x10,%esp
}
  8014cb:	c9                   	leave  
  8014cc:	c3                   	ret    

008014cd <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8014cd:	55                   	push   %ebp
  8014ce:	89 e5                	mov    %esp,%ebp
  8014d0:	56                   	push   %esi
  8014d1:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8014d2:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8014d5:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8014db:	e8 40 ec ff ff       	call   800120 <sys_getenvid>
  8014e0:	83 ec 0c             	sub    $0xc,%esp
  8014e3:	ff 75 0c             	pushl  0xc(%ebp)
  8014e6:	ff 75 08             	pushl  0x8(%ebp)
  8014e9:	56                   	push   %esi
  8014ea:	50                   	push   %eax
  8014eb:	68 8c 24 80 00       	push   $0x80248c
  8014f0:	e8 b3 00 00 00       	call   8015a8 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8014f5:	83 c4 18             	add    $0x18,%esp
  8014f8:	53                   	push   %ebx
  8014f9:	ff 75 10             	pushl  0x10(%ebp)
  8014fc:	e8 56 00 00 00       	call   801557 <vcprintf>
	cprintf("\n");
  801501:	c7 04 24 40 24 80 00 	movl   $0x802440,(%esp)
  801508:	e8 9b 00 00 00       	call   8015a8 <cprintf>
  80150d:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801510:	cc                   	int3   
  801511:	eb fd                	jmp    801510 <_panic+0x43>

00801513 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  801513:	55                   	push   %ebp
  801514:	89 e5                	mov    %esp,%ebp
  801516:	53                   	push   %ebx
  801517:	83 ec 04             	sub    $0x4,%esp
  80151a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80151d:	8b 13                	mov    (%ebx),%edx
  80151f:	8d 42 01             	lea    0x1(%edx),%eax
  801522:	89 03                	mov    %eax,(%ebx)
  801524:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801527:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80152b:	3d ff 00 00 00       	cmp    $0xff,%eax
  801530:	74 09                	je     80153b <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  801532:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  801536:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801539:	c9                   	leave  
  80153a:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80153b:	83 ec 08             	sub    $0x8,%esp
  80153e:	68 ff 00 00 00       	push   $0xff
  801543:	8d 43 08             	lea    0x8(%ebx),%eax
  801546:	50                   	push   %eax
  801547:	e8 56 eb ff ff       	call   8000a2 <sys_cputs>
		b->idx = 0;
  80154c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801552:	83 c4 10             	add    $0x10,%esp
  801555:	eb db                	jmp    801532 <putch+0x1f>

00801557 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  801557:	55                   	push   %ebp
  801558:	89 e5                	mov    %esp,%ebp
  80155a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801560:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801567:	00 00 00 
	b.cnt = 0;
  80156a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801571:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  801574:	ff 75 0c             	pushl  0xc(%ebp)
  801577:	ff 75 08             	pushl  0x8(%ebp)
  80157a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801580:	50                   	push   %eax
  801581:	68 13 15 80 00       	push   $0x801513
  801586:	e8 1a 01 00 00       	call   8016a5 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80158b:	83 c4 08             	add    $0x8,%esp
  80158e:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  801594:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80159a:	50                   	push   %eax
  80159b:	e8 02 eb ff ff       	call   8000a2 <sys_cputs>

	return b.cnt;
}
  8015a0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8015a6:	c9                   	leave  
  8015a7:	c3                   	ret    

008015a8 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8015a8:	55                   	push   %ebp
  8015a9:	89 e5                	mov    %esp,%ebp
  8015ab:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8015ae:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8015b1:	50                   	push   %eax
  8015b2:	ff 75 08             	pushl  0x8(%ebp)
  8015b5:	e8 9d ff ff ff       	call   801557 <vcprintf>
	va_end(ap);

	return cnt;
}
  8015ba:	c9                   	leave  
  8015bb:	c3                   	ret    

008015bc <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8015bc:	55                   	push   %ebp
  8015bd:	89 e5                	mov    %esp,%ebp
  8015bf:	57                   	push   %edi
  8015c0:	56                   	push   %esi
  8015c1:	53                   	push   %ebx
  8015c2:	83 ec 1c             	sub    $0x1c,%esp
  8015c5:	89 c7                	mov    %eax,%edi
  8015c7:	89 d6                	mov    %edx,%esi
  8015c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015cf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8015d2:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8015d5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015d8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015dd:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8015e0:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8015e3:	39 d3                	cmp    %edx,%ebx
  8015e5:	72 05                	jb     8015ec <printnum+0x30>
  8015e7:	39 45 10             	cmp    %eax,0x10(%ebp)
  8015ea:	77 7a                	ja     801666 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8015ec:	83 ec 0c             	sub    $0xc,%esp
  8015ef:	ff 75 18             	pushl  0x18(%ebp)
  8015f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8015f5:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8015f8:	53                   	push   %ebx
  8015f9:	ff 75 10             	pushl  0x10(%ebp)
  8015fc:	83 ec 08             	sub    $0x8,%esp
  8015ff:	ff 75 e4             	pushl  -0x1c(%ebp)
  801602:	ff 75 e0             	pushl  -0x20(%ebp)
  801605:	ff 75 dc             	pushl  -0x24(%ebp)
  801608:	ff 75 d8             	pushl  -0x28(%ebp)
  80160b:	e8 b0 0a 00 00       	call   8020c0 <__udivdi3>
  801610:	83 c4 18             	add    $0x18,%esp
  801613:	52                   	push   %edx
  801614:	50                   	push   %eax
  801615:	89 f2                	mov    %esi,%edx
  801617:	89 f8                	mov    %edi,%eax
  801619:	e8 9e ff ff ff       	call   8015bc <printnum>
  80161e:	83 c4 20             	add    $0x20,%esp
  801621:	eb 13                	jmp    801636 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801623:	83 ec 08             	sub    $0x8,%esp
  801626:	56                   	push   %esi
  801627:	ff 75 18             	pushl  0x18(%ebp)
  80162a:	ff d7                	call   *%edi
  80162c:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80162f:	83 eb 01             	sub    $0x1,%ebx
  801632:	85 db                	test   %ebx,%ebx
  801634:	7f ed                	jg     801623 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801636:	83 ec 08             	sub    $0x8,%esp
  801639:	56                   	push   %esi
  80163a:	83 ec 04             	sub    $0x4,%esp
  80163d:	ff 75 e4             	pushl  -0x1c(%ebp)
  801640:	ff 75 e0             	pushl  -0x20(%ebp)
  801643:	ff 75 dc             	pushl  -0x24(%ebp)
  801646:	ff 75 d8             	pushl  -0x28(%ebp)
  801649:	e8 92 0b 00 00       	call   8021e0 <__umoddi3>
  80164e:	83 c4 14             	add    $0x14,%esp
  801651:	0f be 80 af 24 80 00 	movsbl 0x8024af(%eax),%eax
  801658:	50                   	push   %eax
  801659:	ff d7                	call   *%edi
}
  80165b:	83 c4 10             	add    $0x10,%esp
  80165e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801661:	5b                   	pop    %ebx
  801662:	5e                   	pop    %esi
  801663:	5f                   	pop    %edi
  801664:	5d                   	pop    %ebp
  801665:	c3                   	ret    
  801666:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801669:	eb c4                	jmp    80162f <printnum+0x73>

0080166b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80166b:	55                   	push   %ebp
  80166c:	89 e5                	mov    %esp,%ebp
  80166e:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801671:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  801675:	8b 10                	mov    (%eax),%edx
  801677:	3b 50 04             	cmp    0x4(%eax),%edx
  80167a:	73 0a                	jae    801686 <sprintputch+0x1b>
		*b->buf++ = ch;
  80167c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80167f:	89 08                	mov    %ecx,(%eax)
  801681:	8b 45 08             	mov    0x8(%ebp),%eax
  801684:	88 02                	mov    %al,(%edx)
}
  801686:	5d                   	pop    %ebp
  801687:	c3                   	ret    

00801688 <printfmt>:
{
  801688:	55                   	push   %ebp
  801689:	89 e5                	mov    %esp,%ebp
  80168b:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80168e:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  801691:	50                   	push   %eax
  801692:	ff 75 10             	pushl  0x10(%ebp)
  801695:	ff 75 0c             	pushl  0xc(%ebp)
  801698:	ff 75 08             	pushl  0x8(%ebp)
  80169b:	e8 05 00 00 00       	call   8016a5 <vprintfmt>
}
  8016a0:	83 c4 10             	add    $0x10,%esp
  8016a3:	c9                   	leave  
  8016a4:	c3                   	ret    

008016a5 <vprintfmt>:
{
  8016a5:	55                   	push   %ebp
  8016a6:	89 e5                	mov    %esp,%ebp
  8016a8:	57                   	push   %edi
  8016a9:	56                   	push   %esi
  8016aa:	53                   	push   %ebx
  8016ab:	83 ec 2c             	sub    $0x2c,%esp
  8016ae:	8b 75 08             	mov    0x8(%ebp),%esi
  8016b1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8016b4:	8b 7d 10             	mov    0x10(%ebp),%edi
  8016b7:	e9 21 04 00 00       	jmp    801add <vprintfmt+0x438>
		padc = ' ';
  8016bc:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8016c0:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8016c7:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  8016ce:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8016d5:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8016da:	8d 47 01             	lea    0x1(%edi),%eax
  8016dd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8016e0:	0f b6 17             	movzbl (%edi),%edx
  8016e3:	8d 42 dd             	lea    -0x23(%edx),%eax
  8016e6:	3c 55                	cmp    $0x55,%al
  8016e8:	0f 87 90 04 00 00    	ja     801b7e <vprintfmt+0x4d9>
  8016ee:	0f b6 c0             	movzbl %al,%eax
  8016f1:	ff 24 85 00 26 80 00 	jmp    *0x802600(,%eax,4)
  8016f8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8016fb:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8016ff:	eb d9                	jmp    8016da <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  801701:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  801704:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  801708:	eb d0                	jmp    8016da <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80170a:	0f b6 d2             	movzbl %dl,%edx
  80170d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  801710:	b8 00 00 00 00       	mov    $0x0,%eax
  801715:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  801718:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80171b:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80171f:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  801722:	8d 4a d0             	lea    -0x30(%edx),%ecx
  801725:	83 f9 09             	cmp    $0x9,%ecx
  801728:	77 55                	ja     80177f <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  80172a:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80172d:	eb e9                	jmp    801718 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  80172f:	8b 45 14             	mov    0x14(%ebp),%eax
  801732:	8b 00                	mov    (%eax),%eax
  801734:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801737:	8b 45 14             	mov    0x14(%ebp),%eax
  80173a:	8d 40 04             	lea    0x4(%eax),%eax
  80173d:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801740:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  801743:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801747:	79 91                	jns    8016da <vprintfmt+0x35>
				width = precision, precision = -1;
  801749:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80174c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80174f:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  801756:	eb 82                	jmp    8016da <vprintfmt+0x35>
  801758:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80175b:	85 c0                	test   %eax,%eax
  80175d:	ba 00 00 00 00       	mov    $0x0,%edx
  801762:	0f 49 d0             	cmovns %eax,%edx
  801765:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801768:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80176b:	e9 6a ff ff ff       	jmp    8016da <vprintfmt+0x35>
  801770:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  801773:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  80177a:	e9 5b ff ff ff       	jmp    8016da <vprintfmt+0x35>
  80177f:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  801782:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801785:	eb bc                	jmp    801743 <vprintfmt+0x9e>
			lflag++;
  801787:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80178a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80178d:	e9 48 ff ff ff       	jmp    8016da <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  801792:	8b 45 14             	mov    0x14(%ebp),%eax
  801795:	8d 78 04             	lea    0x4(%eax),%edi
  801798:	83 ec 08             	sub    $0x8,%esp
  80179b:	53                   	push   %ebx
  80179c:	ff 30                	pushl  (%eax)
  80179e:	ff d6                	call   *%esi
			break;
  8017a0:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8017a3:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8017a6:	e9 2f 03 00 00       	jmp    801ada <vprintfmt+0x435>
			err = va_arg(ap, int);
  8017ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8017ae:	8d 78 04             	lea    0x4(%eax),%edi
  8017b1:	8b 00                	mov    (%eax),%eax
  8017b3:	99                   	cltd   
  8017b4:	31 d0                	xor    %edx,%eax
  8017b6:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8017b8:	83 f8 0f             	cmp    $0xf,%eax
  8017bb:	7f 23                	jg     8017e0 <vprintfmt+0x13b>
  8017bd:	8b 14 85 60 27 80 00 	mov    0x802760(,%eax,4),%edx
  8017c4:	85 d2                	test   %edx,%edx
  8017c6:	74 18                	je     8017e0 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  8017c8:	52                   	push   %edx
  8017c9:	68 07 24 80 00       	push   $0x802407
  8017ce:	53                   	push   %ebx
  8017cf:	56                   	push   %esi
  8017d0:	e8 b3 fe ff ff       	call   801688 <printfmt>
  8017d5:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8017d8:	89 7d 14             	mov    %edi,0x14(%ebp)
  8017db:	e9 fa 02 00 00       	jmp    801ada <vprintfmt+0x435>
				printfmt(putch, putdat, "error %d", err);
  8017e0:	50                   	push   %eax
  8017e1:	68 c7 24 80 00       	push   $0x8024c7
  8017e6:	53                   	push   %ebx
  8017e7:	56                   	push   %esi
  8017e8:	e8 9b fe ff ff       	call   801688 <printfmt>
  8017ed:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8017f0:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8017f3:	e9 e2 02 00 00       	jmp    801ada <vprintfmt+0x435>
			if ((p = va_arg(ap, char *)) == NULL)
  8017f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8017fb:	83 c0 04             	add    $0x4,%eax
  8017fe:	89 45 cc             	mov    %eax,-0x34(%ebp)
  801801:	8b 45 14             	mov    0x14(%ebp),%eax
  801804:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  801806:	85 ff                	test   %edi,%edi
  801808:	b8 c0 24 80 00       	mov    $0x8024c0,%eax
  80180d:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  801810:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801814:	0f 8e bd 00 00 00    	jle    8018d7 <vprintfmt+0x232>
  80181a:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80181e:	75 0e                	jne    80182e <vprintfmt+0x189>
  801820:	89 75 08             	mov    %esi,0x8(%ebp)
  801823:	8b 75 d0             	mov    -0x30(%ebp),%esi
  801826:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  801829:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80182c:	eb 6d                	jmp    80189b <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  80182e:	83 ec 08             	sub    $0x8,%esp
  801831:	ff 75 d0             	pushl  -0x30(%ebp)
  801834:	57                   	push   %edi
  801835:	e8 ec 03 00 00       	call   801c26 <strnlen>
  80183a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80183d:	29 c1                	sub    %eax,%ecx
  80183f:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  801842:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  801845:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  801849:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80184c:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  80184f:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  801851:	eb 0f                	jmp    801862 <vprintfmt+0x1bd>
					putch(padc, putdat);
  801853:	83 ec 08             	sub    $0x8,%esp
  801856:	53                   	push   %ebx
  801857:	ff 75 e0             	pushl  -0x20(%ebp)
  80185a:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80185c:	83 ef 01             	sub    $0x1,%edi
  80185f:	83 c4 10             	add    $0x10,%esp
  801862:	85 ff                	test   %edi,%edi
  801864:	7f ed                	jg     801853 <vprintfmt+0x1ae>
  801866:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  801869:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  80186c:	85 c9                	test   %ecx,%ecx
  80186e:	b8 00 00 00 00       	mov    $0x0,%eax
  801873:	0f 49 c1             	cmovns %ecx,%eax
  801876:	29 c1                	sub    %eax,%ecx
  801878:	89 75 08             	mov    %esi,0x8(%ebp)
  80187b:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80187e:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  801881:	89 cb                	mov    %ecx,%ebx
  801883:	eb 16                	jmp    80189b <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  801885:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801889:	75 31                	jne    8018bc <vprintfmt+0x217>
					putch(ch, putdat);
  80188b:	83 ec 08             	sub    $0x8,%esp
  80188e:	ff 75 0c             	pushl  0xc(%ebp)
  801891:	50                   	push   %eax
  801892:	ff 55 08             	call   *0x8(%ebp)
  801895:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801898:	83 eb 01             	sub    $0x1,%ebx
  80189b:	83 c7 01             	add    $0x1,%edi
  80189e:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8018a2:	0f be c2             	movsbl %dl,%eax
  8018a5:	85 c0                	test   %eax,%eax
  8018a7:	74 59                	je     801902 <vprintfmt+0x25d>
  8018a9:	85 f6                	test   %esi,%esi
  8018ab:	78 d8                	js     801885 <vprintfmt+0x1e0>
  8018ad:	83 ee 01             	sub    $0x1,%esi
  8018b0:	79 d3                	jns    801885 <vprintfmt+0x1e0>
  8018b2:	89 df                	mov    %ebx,%edi
  8018b4:	8b 75 08             	mov    0x8(%ebp),%esi
  8018b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8018ba:	eb 37                	jmp    8018f3 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  8018bc:	0f be d2             	movsbl %dl,%edx
  8018bf:	83 ea 20             	sub    $0x20,%edx
  8018c2:	83 fa 5e             	cmp    $0x5e,%edx
  8018c5:	76 c4                	jbe    80188b <vprintfmt+0x1e6>
					putch('?', putdat);
  8018c7:	83 ec 08             	sub    $0x8,%esp
  8018ca:	ff 75 0c             	pushl  0xc(%ebp)
  8018cd:	6a 3f                	push   $0x3f
  8018cf:	ff 55 08             	call   *0x8(%ebp)
  8018d2:	83 c4 10             	add    $0x10,%esp
  8018d5:	eb c1                	jmp    801898 <vprintfmt+0x1f3>
  8018d7:	89 75 08             	mov    %esi,0x8(%ebp)
  8018da:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8018dd:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8018e0:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8018e3:	eb b6                	jmp    80189b <vprintfmt+0x1f6>
				putch(' ', putdat);
  8018e5:	83 ec 08             	sub    $0x8,%esp
  8018e8:	53                   	push   %ebx
  8018e9:	6a 20                	push   $0x20
  8018eb:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8018ed:	83 ef 01             	sub    $0x1,%edi
  8018f0:	83 c4 10             	add    $0x10,%esp
  8018f3:	85 ff                	test   %edi,%edi
  8018f5:	7f ee                	jg     8018e5 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  8018f7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8018fa:	89 45 14             	mov    %eax,0x14(%ebp)
  8018fd:	e9 d8 01 00 00       	jmp    801ada <vprintfmt+0x435>
  801902:	89 df                	mov    %ebx,%edi
  801904:	8b 75 08             	mov    0x8(%ebp),%esi
  801907:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80190a:	eb e7                	jmp    8018f3 <vprintfmt+0x24e>
	if (lflag >= 2)
  80190c:	83 f9 01             	cmp    $0x1,%ecx
  80190f:	7e 45                	jle    801956 <vprintfmt+0x2b1>
		return va_arg(*ap, long long);
  801911:	8b 45 14             	mov    0x14(%ebp),%eax
  801914:	8b 50 04             	mov    0x4(%eax),%edx
  801917:	8b 00                	mov    (%eax),%eax
  801919:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80191c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80191f:	8b 45 14             	mov    0x14(%ebp),%eax
  801922:	8d 40 08             	lea    0x8(%eax),%eax
  801925:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  801928:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80192c:	79 62                	jns    801990 <vprintfmt+0x2eb>
				putch('-', putdat);
  80192e:	83 ec 08             	sub    $0x8,%esp
  801931:	53                   	push   %ebx
  801932:	6a 2d                	push   $0x2d
  801934:	ff d6                	call   *%esi
				num = -(long long) num;
  801936:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801939:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80193c:	f7 d8                	neg    %eax
  80193e:	83 d2 00             	adc    $0x0,%edx
  801941:	f7 da                	neg    %edx
  801943:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801946:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801949:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80194c:	ba 0a 00 00 00       	mov    $0xa,%edx
  801951:	e9 66 01 00 00       	jmp    801abc <vprintfmt+0x417>
	else if (lflag)
  801956:	85 c9                	test   %ecx,%ecx
  801958:	75 1b                	jne    801975 <vprintfmt+0x2d0>
		return va_arg(*ap, int);
  80195a:	8b 45 14             	mov    0x14(%ebp),%eax
  80195d:	8b 00                	mov    (%eax),%eax
  80195f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801962:	89 c1                	mov    %eax,%ecx
  801964:	c1 f9 1f             	sar    $0x1f,%ecx
  801967:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80196a:	8b 45 14             	mov    0x14(%ebp),%eax
  80196d:	8d 40 04             	lea    0x4(%eax),%eax
  801970:	89 45 14             	mov    %eax,0x14(%ebp)
  801973:	eb b3                	jmp    801928 <vprintfmt+0x283>
		return va_arg(*ap, long);
  801975:	8b 45 14             	mov    0x14(%ebp),%eax
  801978:	8b 00                	mov    (%eax),%eax
  80197a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80197d:	89 c1                	mov    %eax,%ecx
  80197f:	c1 f9 1f             	sar    $0x1f,%ecx
  801982:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  801985:	8b 45 14             	mov    0x14(%ebp),%eax
  801988:	8d 40 04             	lea    0x4(%eax),%eax
  80198b:	89 45 14             	mov    %eax,0x14(%ebp)
  80198e:	eb 98                	jmp    801928 <vprintfmt+0x283>
			base = 10;
  801990:	ba 0a 00 00 00       	mov    $0xa,%edx
  801995:	e9 22 01 00 00       	jmp    801abc <vprintfmt+0x417>
	if (lflag >= 2)
  80199a:	83 f9 01             	cmp    $0x1,%ecx
  80199d:	7e 21                	jle    8019c0 <vprintfmt+0x31b>
		return va_arg(*ap, unsigned long long);
  80199f:	8b 45 14             	mov    0x14(%ebp),%eax
  8019a2:	8b 50 04             	mov    0x4(%eax),%edx
  8019a5:	8b 00                	mov    (%eax),%eax
  8019a7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8019aa:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8019ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8019b0:	8d 40 08             	lea    0x8(%eax),%eax
  8019b3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8019b6:	ba 0a 00 00 00       	mov    $0xa,%edx
  8019bb:	e9 fc 00 00 00       	jmp    801abc <vprintfmt+0x417>
	else if (lflag)
  8019c0:	85 c9                	test   %ecx,%ecx
  8019c2:	75 23                	jne    8019e7 <vprintfmt+0x342>
		return va_arg(*ap, unsigned int);
  8019c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8019c7:	8b 00                	mov    (%eax),%eax
  8019c9:	ba 00 00 00 00       	mov    $0x0,%edx
  8019ce:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8019d1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8019d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8019d7:	8d 40 04             	lea    0x4(%eax),%eax
  8019da:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8019dd:	ba 0a 00 00 00       	mov    $0xa,%edx
  8019e2:	e9 d5 00 00 00       	jmp    801abc <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  8019e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8019ea:	8b 00                	mov    (%eax),%eax
  8019ec:	ba 00 00 00 00       	mov    $0x0,%edx
  8019f1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8019f4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8019f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8019fa:	8d 40 04             	lea    0x4(%eax),%eax
  8019fd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801a00:	ba 0a 00 00 00       	mov    $0xa,%edx
  801a05:	e9 b2 00 00 00       	jmp    801abc <vprintfmt+0x417>
	if (lflag >= 2)
  801a0a:	83 f9 01             	cmp    $0x1,%ecx
  801a0d:	7e 42                	jle    801a51 <vprintfmt+0x3ac>
		return va_arg(*ap, unsigned long long);
  801a0f:	8b 45 14             	mov    0x14(%ebp),%eax
  801a12:	8b 50 04             	mov    0x4(%eax),%edx
  801a15:	8b 00                	mov    (%eax),%eax
  801a17:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801a1a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801a1d:	8b 45 14             	mov    0x14(%ebp),%eax
  801a20:	8d 40 08             	lea    0x8(%eax),%eax
  801a23:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801a26:	ba 08 00 00 00       	mov    $0x8,%edx
			if ((long long) num < 0) {
  801a2b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801a2f:	0f 89 87 00 00 00    	jns    801abc <vprintfmt+0x417>
				putch('-', putdat);
  801a35:	83 ec 08             	sub    $0x8,%esp
  801a38:	53                   	push   %ebx
  801a39:	6a 2d                	push   $0x2d
  801a3b:	ff d6                	call   *%esi
				num = -(long long) num;
  801a3d:	f7 5d d8             	negl   -0x28(%ebp)
  801a40:	83 55 dc 00          	adcl   $0x0,-0x24(%ebp)
  801a44:	f7 5d dc             	negl   -0x24(%ebp)
  801a47:	83 c4 10             	add    $0x10,%esp
			base = 8;
  801a4a:	ba 08 00 00 00       	mov    $0x8,%edx
  801a4f:	eb 6b                	jmp    801abc <vprintfmt+0x417>
	else if (lflag)
  801a51:	85 c9                	test   %ecx,%ecx
  801a53:	75 1b                	jne    801a70 <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  801a55:	8b 45 14             	mov    0x14(%ebp),%eax
  801a58:	8b 00                	mov    (%eax),%eax
  801a5a:	ba 00 00 00 00       	mov    $0x0,%edx
  801a5f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801a62:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801a65:	8b 45 14             	mov    0x14(%ebp),%eax
  801a68:	8d 40 04             	lea    0x4(%eax),%eax
  801a6b:	89 45 14             	mov    %eax,0x14(%ebp)
  801a6e:	eb b6                	jmp    801a26 <vprintfmt+0x381>
		return va_arg(*ap, unsigned long);
  801a70:	8b 45 14             	mov    0x14(%ebp),%eax
  801a73:	8b 00                	mov    (%eax),%eax
  801a75:	ba 00 00 00 00       	mov    $0x0,%edx
  801a7a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801a7d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801a80:	8b 45 14             	mov    0x14(%ebp),%eax
  801a83:	8d 40 04             	lea    0x4(%eax),%eax
  801a86:	89 45 14             	mov    %eax,0x14(%ebp)
  801a89:	eb 9b                	jmp    801a26 <vprintfmt+0x381>
			putch('0', putdat);
  801a8b:	83 ec 08             	sub    $0x8,%esp
  801a8e:	53                   	push   %ebx
  801a8f:	6a 30                	push   $0x30
  801a91:	ff d6                	call   *%esi
			putch('x', putdat);
  801a93:	83 c4 08             	add    $0x8,%esp
  801a96:	53                   	push   %ebx
  801a97:	6a 78                	push   $0x78
  801a99:	ff d6                	call   *%esi
			num = (unsigned long long)
  801a9b:	8b 45 14             	mov    0x14(%ebp),%eax
  801a9e:	8b 00                	mov    (%eax),%eax
  801aa0:	ba 00 00 00 00       	mov    $0x0,%edx
  801aa5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801aa8:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  801aab:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  801aae:	8b 45 14             	mov    0x14(%ebp),%eax
  801ab1:	8d 40 04             	lea    0x4(%eax),%eax
  801ab4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801ab7:	ba 10 00 00 00       	mov    $0x10,%edx
			printnum(putch, putdat, num, base, width, padc);
  801abc:	83 ec 0c             	sub    $0xc,%esp
  801abf:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  801ac3:	50                   	push   %eax
  801ac4:	ff 75 e0             	pushl  -0x20(%ebp)
  801ac7:	52                   	push   %edx
  801ac8:	ff 75 dc             	pushl  -0x24(%ebp)
  801acb:	ff 75 d8             	pushl  -0x28(%ebp)
  801ace:	89 da                	mov    %ebx,%edx
  801ad0:	89 f0                	mov    %esi,%eax
  801ad2:	e8 e5 fa ff ff       	call   8015bc <printnum>
			break;
  801ad7:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  801ada:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801add:	83 c7 01             	add    $0x1,%edi
  801ae0:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801ae4:	83 f8 25             	cmp    $0x25,%eax
  801ae7:	0f 84 cf fb ff ff    	je     8016bc <vprintfmt+0x17>
			if (ch == '\0')
  801aed:	85 c0                	test   %eax,%eax
  801aef:	0f 84 a9 00 00 00    	je     801b9e <vprintfmt+0x4f9>
			putch(ch, putdat);
  801af5:	83 ec 08             	sub    $0x8,%esp
  801af8:	53                   	push   %ebx
  801af9:	50                   	push   %eax
  801afa:	ff d6                	call   *%esi
  801afc:	83 c4 10             	add    $0x10,%esp
  801aff:	eb dc                	jmp    801add <vprintfmt+0x438>
	if (lflag >= 2)
  801b01:	83 f9 01             	cmp    $0x1,%ecx
  801b04:	7e 1e                	jle    801b24 <vprintfmt+0x47f>
		return va_arg(*ap, unsigned long long);
  801b06:	8b 45 14             	mov    0x14(%ebp),%eax
  801b09:	8b 50 04             	mov    0x4(%eax),%edx
  801b0c:	8b 00                	mov    (%eax),%eax
  801b0e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801b11:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801b14:	8b 45 14             	mov    0x14(%ebp),%eax
  801b17:	8d 40 08             	lea    0x8(%eax),%eax
  801b1a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801b1d:	ba 10 00 00 00       	mov    $0x10,%edx
  801b22:	eb 98                	jmp    801abc <vprintfmt+0x417>
	else if (lflag)
  801b24:	85 c9                	test   %ecx,%ecx
  801b26:	75 23                	jne    801b4b <vprintfmt+0x4a6>
		return va_arg(*ap, unsigned int);
  801b28:	8b 45 14             	mov    0x14(%ebp),%eax
  801b2b:	8b 00                	mov    (%eax),%eax
  801b2d:	ba 00 00 00 00       	mov    $0x0,%edx
  801b32:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801b35:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801b38:	8b 45 14             	mov    0x14(%ebp),%eax
  801b3b:	8d 40 04             	lea    0x4(%eax),%eax
  801b3e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801b41:	ba 10 00 00 00       	mov    $0x10,%edx
  801b46:	e9 71 ff ff ff       	jmp    801abc <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  801b4b:	8b 45 14             	mov    0x14(%ebp),%eax
  801b4e:	8b 00                	mov    (%eax),%eax
  801b50:	ba 00 00 00 00       	mov    $0x0,%edx
  801b55:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801b58:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801b5b:	8b 45 14             	mov    0x14(%ebp),%eax
  801b5e:	8d 40 04             	lea    0x4(%eax),%eax
  801b61:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801b64:	ba 10 00 00 00       	mov    $0x10,%edx
  801b69:	e9 4e ff ff ff       	jmp    801abc <vprintfmt+0x417>
			putch(ch, putdat);
  801b6e:	83 ec 08             	sub    $0x8,%esp
  801b71:	53                   	push   %ebx
  801b72:	6a 25                	push   $0x25
  801b74:	ff d6                	call   *%esi
			break;
  801b76:	83 c4 10             	add    $0x10,%esp
  801b79:	e9 5c ff ff ff       	jmp    801ada <vprintfmt+0x435>
			putch('%', putdat);
  801b7e:	83 ec 08             	sub    $0x8,%esp
  801b81:	53                   	push   %ebx
  801b82:	6a 25                	push   $0x25
  801b84:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  801b86:	83 c4 10             	add    $0x10,%esp
  801b89:	89 f8                	mov    %edi,%eax
  801b8b:	eb 03                	jmp    801b90 <vprintfmt+0x4eb>
  801b8d:	83 e8 01             	sub    $0x1,%eax
  801b90:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  801b94:	75 f7                	jne    801b8d <vprintfmt+0x4e8>
  801b96:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801b99:	e9 3c ff ff ff       	jmp    801ada <vprintfmt+0x435>
}
  801b9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ba1:	5b                   	pop    %ebx
  801ba2:	5e                   	pop    %esi
  801ba3:	5f                   	pop    %edi
  801ba4:	5d                   	pop    %ebp
  801ba5:	c3                   	ret    

00801ba6 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801ba6:	55                   	push   %ebp
  801ba7:	89 e5                	mov    %esp,%ebp
  801ba9:	83 ec 18             	sub    $0x18,%esp
  801bac:	8b 45 08             	mov    0x8(%ebp),%eax
  801baf:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801bb2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801bb5:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801bb9:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801bbc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801bc3:	85 c0                	test   %eax,%eax
  801bc5:	74 26                	je     801bed <vsnprintf+0x47>
  801bc7:	85 d2                	test   %edx,%edx
  801bc9:	7e 22                	jle    801bed <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801bcb:	ff 75 14             	pushl  0x14(%ebp)
  801bce:	ff 75 10             	pushl  0x10(%ebp)
  801bd1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801bd4:	50                   	push   %eax
  801bd5:	68 6b 16 80 00       	push   $0x80166b
  801bda:	e8 c6 fa ff ff       	call   8016a5 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801bdf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801be2:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801be5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801be8:	83 c4 10             	add    $0x10,%esp
}
  801beb:	c9                   	leave  
  801bec:	c3                   	ret    
		return -E_INVAL;
  801bed:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801bf2:	eb f7                	jmp    801beb <vsnprintf+0x45>

00801bf4 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801bf4:	55                   	push   %ebp
  801bf5:	89 e5                	mov    %esp,%ebp
  801bf7:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801bfa:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801bfd:	50                   	push   %eax
  801bfe:	ff 75 10             	pushl  0x10(%ebp)
  801c01:	ff 75 0c             	pushl  0xc(%ebp)
  801c04:	ff 75 08             	pushl  0x8(%ebp)
  801c07:	e8 9a ff ff ff       	call   801ba6 <vsnprintf>
	va_end(ap);

	return rc;
}
  801c0c:	c9                   	leave  
  801c0d:	c3                   	ret    

00801c0e <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801c0e:	55                   	push   %ebp
  801c0f:	89 e5                	mov    %esp,%ebp
  801c11:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801c14:	b8 00 00 00 00       	mov    $0x0,%eax
  801c19:	eb 03                	jmp    801c1e <strlen+0x10>
		n++;
  801c1b:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  801c1e:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801c22:	75 f7                	jne    801c1b <strlen+0xd>
	return n;
}
  801c24:	5d                   	pop    %ebp
  801c25:	c3                   	ret    

00801c26 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801c26:	55                   	push   %ebp
  801c27:	89 e5                	mov    %esp,%ebp
  801c29:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c2c:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801c2f:	b8 00 00 00 00       	mov    $0x0,%eax
  801c34:	eb 03                	jmp    801c39 <strnlen+0x13>
		n++;
  801c36:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801c39:	39 d0                	cmp    %edx,%eax
  801c3b:	74 06                	je     801c43 <strnlen+0x1d>
  801c3d:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  801c41:	75 f3                	jne    801c36 <strnlen+0x10>
	return n;
}
  801c43:	5d                   	pop    %ebp
  801c44:	c3                   	ret    

00801c45 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801c45:	55                   	push   %ebp
  801c46:	89 e5                	mov    %esp,%ebp
  801c48:	53                   	push   %ebx
  801c49:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801c4f:	89 c2                	mov    %eax,%edx
  801c51:	83 c1 01             	add    $0x1,%ecx
  801c54:	83 c2 01             	add    $0x1,%edx
  801c57:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  801c5b:	88 5a ff             	mov    %bl,-0x1(%edx)
  801c5e:	84 db                	test   %bl,%bl
  801c60:	75 ef                	jne    801c51 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  801c62:	5b                   	pop    %ebx
  801c63:	5d                   	pop    %ebp
  801c64:	c3                   	ret    

00801c65 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801c65:	55                   	push   %ebp
  801c66:	89 e5                	mov    %esp,%ebp
  801c68:	53                   	push   %ebx
  801c69:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801c6c:	53                   	push   %ebx
  801c6d:	e8 9c ff ff ff       	call   801c0e <strlen>
  801c72:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  801c75:	ff 75 0c             	pushl  0xc(%ebp)
  801c78:	01 d8                	add    %ebx,%eax
  801c7a:	50                   	push   %eax
  801c7b:	e8 c5 ff ff ff       	call   801c45 <strcpy>
	return dst;
}
  801c80:	89 d8                	mov    %ebx,%eax
  801c82:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c85:	c9                   	leave  
  801c86:	c3                   	ret    

00801c87 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801c87:	55                   	push   %ebp
  801c88:	89 e5                	mov    %esp,%ebp
  801c8a:	56                   	push   %esi
  801c8b:	53                   	push   %ebx
  801c8c:	8b 75 08             	mov    0x8(%ebp),%esi
  801c8f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c92:	89 f3                	mov    %esi,%ebx
  801c94:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801c97:	89 f2                	mov    %esi,%edx
  801c99:	eb 0f                	jmp    801caa <strncpy+0x23>
		*dst++ = *src;
  801c9b:	83 c2 01             	add    $0x1,%edx
  801c9e:	0f b6 01             	movzbl (%ecx),%eax
  801ca1:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801ca4:	80 39 01             	cmpb   $0x1,(%ecx)
  801ca7:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  801caa:	39 da                	cmp    %ebx,%edx
  801cac:	75 ed                	jne    801c9b <strncpy+0x14>
	}
	return ret;
}
  801cae:	89 f0                	mov    %esi,%eax
  801cb0:	5b                   	pop    %ebx
  801cb1:	5e                   	pop    %esi
  801cb2:	5d                   	pop    %ebp
  801cb3:	c3                   	ret    

00801cb4 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801cb4:	55                   	push   %ebp
  801cb5:	89 e5                	mov    %esp,%ebp
  801cb7:	56                   	push   %esi
  801cb8:	53                   	push   %ebx
  801cb9:	8b 75 08             	mov    0x8(%ebp),%esi
  801cbc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cbf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cc2:	89 f0                	mov    %esi,%eax
  801cc4:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801cc8:	85 c9                	test   %ecx,%ecx
  801cca:	75 0b                	jne    801cd7 <strlcpy+0x23>
  801ccc:	eb 17                	jmp    801ce5 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  801cce:	83 c2 01             	add    $0x1,%edx
  801cd1:	83 c0 01             	add    $0x1,%eax
  801cd4:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  801cd7:	39 d8                	cmp    %ebx,%eax
  801cd9:	74 07                	je     801ce2 <strlcpy+0x2e>
  801cdb:	0f b6 0a             	movzbl (%edx),%ecx
  801cde:	84 c9                	test   %cl,%cl
  801ce0:	75 ec                	jne    801cce <strlcpy+0x1a>
		*dst = '\0';
  801ce2:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801ce5:	29 f0                	sub    %esi,%eax
}
  801ce7:	5b                   	pop    %ebx
  801ce8:	5e                   	pop    %esi
  801ce9:	5d                   	pop    %ebp
  801cea:	c3                   	ret    

00801ceb <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801ceb:	55                   	push   %ebp
  801cec:	89 e5                	mov    %esp,%ebp
  801cee:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cf1:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801cf4:	eb 06                	jmp    801cfc <strcmp+0x11>
		p++, q++;
  801cf6:	83 c1 01             	add    $0x1,%ecx
  801cf9:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  801cfc:	0f b6 01             	movzbl (%ecx),%eax
  801cff:	84 c0                	test   %al,%al
  801d01:	74 04                	je     801d07 <strcmp+0x1c>
  801d03:	3a 02                	cmp    (%edx),%al
  801d05:	74 ef                	je     801cf6 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801d07:	0f b6 c0             	movzbl %al,%eax
  801d0a:	0f b6 12             	movzbl (%edx),%edx
  801d0d:	29 d0                	sub    %edx,%eax
}
  801d0f:	5d                   	pop    %ebp
  801d10:	c3                   	ret    

00801d11 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801d11:	55                   	push   %ebp
  801d12:	89 e5                	mov    %esp,%ebp
  801d14:	53                   	push   %ebx
  801d15:	8b 45 08             	mov    0x8(%ebp),%eax
  801d18:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d1b:	89 c3                	mov    %eax,%ebx
  801d1d:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  801d20:	eb 06                	jmp    801d28 <strncmp+0x17>
		n--, p++, q++;
  801d22:	83 c0 01             	add    $0x1,%eax
  801d25:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  801d28:	39 d8                	cmp    %ebx,%eax
  801d2a:	74 16                	je     801d42 <strncmp+0x31>
  801d2c:	0f b6 08             	movzbl (%eax),%ecx
  801d2f:	84 c9                	test   %cl,%cl
  801d31:	74 04                	je     801d37 <strncmp+0x26>
  801d33:	3a 0a                	cmp    (%edx),%cl
  801d35:	74 eb                	je     801d22 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801d37:	0f b6 00             	movzbl (%eax),%eax
  801d3a:	0f b6 12             	movzbl (%edx),%edx
  801d3d:	29 d0                	sub    %edx,%eax
}
  801d3f:	5b                   	pop    %ebx
  801d40:	5d                   	pop    %ebp
  801d41:	c3                   	ret    
		return 0;
  801d42:	b8 00 00 00 00       	mov    $0x0,%eax
  801d47:	eb f6                	jmp    801d3f <strncmp+0x2e>

00801d49 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801d49:	55                   	push   %ebp
  801d4a:	89 e5                	mov    %esp,%ebp
  801d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801d53:	0f b6 10             	movzbl (%eax),%edx
  801d56:	84 d2                	test   %dl,%dl
  801d58:	74 09                	je     801d63 <strchr+0x1a>
		if (*s == c)
  801d5a:	38 ca                	cmp    %cl,%dl
  801d5c:	74 0a                	je     801d68 <strchr+0x1f>
	for (; *s; s++)
  801d5e:	83 c0 01             	add    $0x1,%eax
  801d61:	eb f0                	jmp    801d53 <strchr+0xa>
			return (char *) s;
	return 0;
  801d63:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d68:	5d                   	pop    %ebp
  801d69:	c3                   	ret    

00801d6a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801d6a:	55                   	push   %ebp
  801d6b:	89 e5                	mov    %esp,%ebp
  801d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d70:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801d74:	eb 03                	jmp    801d79 <strfind+0xf>
  801d76:	83 c0 01             	add    $0x1,%eax
  801d79:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  801d7c:	38 ca                	cmp    %cl,%dl
  801d7e:	74 04                	je     801d84 <strfind+0x1a>
  801d80:	84 d2                	test   %dl,%dl
  801d82:	75 f2                	jne    801d76 <strfind+0xc>
			break;
	return (char *) s;
}
  801d84:	5d                   	pop    %ebp
  801d85:	c3                   	ret    

00801d86 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801d86:	55                   	push   %ebp
  801d87:	89 e5                	mov    %esp,%ebp
  801d89:	57                   	push   %edi
  801d8a:	56                   	push   %esi
  801d8b:	53                   	push   %ebx
  801d8c:	8b 7d 08             	mov    0x8(%ebp),%edi
  801d8f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801d92:	85 c9                	test   %ecx,%ecx
  801d94:	74 13                	je     801da9 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801d96:	f7 c7 03 00 00 00    	test   $0x3,%edi
  801d9c:	75 05                	jne    801da3 <memset+0x1d>
  801d9e:	f6 c1 03             	test   $0x3,%cl
  801da1:	74 0d                	je     801db0 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801da3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801da6:	fc                   	cld    
  801da7:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801da9:	89 f8                	mov    %edi,%eax
  801dab:	5b                   	pop    %ebx
  801dac:	5e                   	pop    %esi
  801dad:	5f                   	pop    %edi
  801dae:	5d                   	pop    %ebp
  801daf:	c3                   	ret    
		c &= 0xFF;
  801db0:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801db4:	89 d3                	mov    %edx,%ebx
  801db6:	c1 e3 08             	shl    $0x8,%ebx
  801db9:	89 d0                	mov    %edx,%eax
  801dbb:	c1 e0 18             	shl    $0x18,%eax
  801dbe:	89 d6                	mov    %edx,%esi
  801dc0:	c1 e6 10             	shl    $0x10,%esi
  801dc3:	09 f0                	or     %esi,%eax
  801dc5:	09 c2                	or     %eax,%edx
  801dc7:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  801dc9:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  801dcc:	89 d0                	mov    %edx,%eax
  801dce:	fc                   	cld    
  801dcf:	f3 ab                	rep stos %eax,%es:(%edi)
  801dd1:	eb d6                	jmp    801da9 <memset+0x23>

00801dd3 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801dd3:	55                   	push   %ebp
  801dd4:	89 e5                	mov    %esp,%ebp
  801dd6:	57                   	push   %edi
  801dd7:	56                   	push   %esi
  801dd8:	8b 45 08             	mov    0x8(%ebp),%eax
  801ddb:	8b 75 0c             	mov    0xc(%ebp),%esi
  801dde:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801de1:	39 c6                	cmp    %eax,%esi
  801de3:	73 35                	jae    801e1a <memmove+0x47>
  801de5:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801de8:	39 c2                	cmp    %eax,%edx
  801dea:	76 2e                	jbe    801e1a <memmove+0x47>
		s += n;
		d += n;
  801dec:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801def:	89 d6                	mov    %edx,%esi
  801df1:	09 fe                	or     %edi,%esi
  801df3:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801df9:	74 0c                	je     801e07 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801dfb:	83 ef 01             	sub    $0x1,%edi
  801dfe:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  801e01:	fd                   	std    
  801e02:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801e04:	fc                   	cld    
  801e05:	eb 21                	jmp    801e28 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801e07:	f6 c1 03             	test   $0x3,%cl
  801e0a:	75 ef                	jne    801dfb <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801e0c:	83 ef 04             	sub    $0x4,%edi
  801e0f:	8d 72 fc             	lea    -0x4(%edx),%esi
  801e12:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  801e15:	fd                   	std    
  801e16:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801e18:	eb ea                	jmp    801e04 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801e1a:	89 f2                	mov    %esi,%edx
  801e1c:	09 c2                	or     %eax,%edx
  801e1e:	f6 c2 03             	test   $0x3,%dl
  801e21:	74 09                	je     801e2c <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801e23:	89 c7                	mov    %eax,%edi
  801e25:	fc                   	cld    
  801e26:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801e28:	5e                   	pop    %esi
  801e29:	5f                   	pop    %edi
  801e2a:	5d                   	pop    %ebp
  801e2b:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801e2c:	f6 c1 03             	test   $0x3,%cl
  801e2f:	75 f2                	jne    801e23 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801e31:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  801e34:	89 c7                	mov    %eax,%edi
  801e36:	fc                   	cld    
  801e37:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801e39:	eb ed                	jmp    801e28 <memmove+0x55>

00801e3b <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801e3b:	55                   	push   %ebp
  801e3c:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  801e3e:	ff 75 10             	pushl  0x10(%ebp)
  801e41:	ff 75 0c             	pushl  0xc(%ebp)
  801e44:	ff 75 08             	pushl  0x8(%ebp)
  801e47:	e8 87 ff ff ff       	call   801dd3 <memmove>
}
  801e4c:	c9                   	leave  
  801e4d:	c3                   	ret    

00801e4e <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801e4e:	55                   	push   %ebp
  801e4f:	89 e5                	mov    %esp,%ebp
  801e51:	56                   	push   %esi
  801e52:	53                   	push   %ebx
  801e53:	8b 45 08             	mov    0x8(%ebp),%eax
  801e56:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e59:	89 c6                	mov    %eax,%esi
  801e5b:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801e5e:	39 f0                	cmp    %esi,%eax
  801e60:	74 1c                	je     801e7e <memcmp+0x30>
		if (*s1 != *s2)
  801e62:	0f b6 08             	movzbl (%eax),%ecx
  801e65:	0f b6 1a             	movzbl (%edx),%ebx
  801e68:	38 d9                	cmp    %bl,%cl
  801e6a:	75 08                	jne    801e74 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801e6c:	83 c0 01             	add    $0x1,%eax
  801e6f:	83 c2 01             	add    $0x1,%edx
  801e72:	eb ea                	jmp    801e5e <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  801e74:	0f b6 c1             	movzbl %cl,%eax
  801e77:	0f b6 db             	movzbl %bl,%ebx
  801e7a:	29 d8                	sub    %ebx,%eax
  801e7c:	eb 05                	jmp    801e83 <memcmp+0x35>
	}

	return 0;
  801e7e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e83:	5b                   	pop    %ebx
  801e84:	5e                   	pop    %esi
  801e85:	5d                   	pop    %ebp
  801e86:	c3                   	ret    

00801e87 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801e87:	55                   	push   %ebp
  801e88:	89 e5                	mov    %esp,%ebp
  801e8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801e90:	89 c2                	mov    %eax,%edx
  801e92:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801e95:	39 d0                	cmp    %edx,%eax
  801e97:	73 09                	jae    801ea2 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  801e99:	38 08                	cmp    %cl,(%eax)
  801e9b:	74 05                	je     801ea2 <memfind+0x1b>
	for (; s < ends; s++)
  801e9d:	83 c0 01             	add    $0x1,%eax
  801ea0:	eb f3                	jmp    801e95 <memfind+0xe>
			break;
	return (void *) s;
}
  801ea2:	5d                   	pop    %ebp
  801ea3:	c3                   	ret    

00801ea4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801ea4:	55                   	push   %ebp
  801ea5:	89 e5                	mov    %esp,%ebp
  801ea7:	57                   	push   %edi
  801ea8:	56                   	push   %esi
  801ea9:	53                   	push   %ebx
  801eaa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ead:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801eb0:	eb 03                	jmp    801eb5 <strtol+0x11>
		s++;
  801eb2:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  801eb5:	0f b6 01             	movzbl (%ecx),%eax
  801eb8:	3c 20                	cmp    $0x20,%al
  801eba:	74 f6                	je     801eb2 <strtol+0xe>
  801ebc:	3c 09                	cmp    $0x9,%al
  801ebe:	74 f2                	je     801eb2 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  801ec0:	3c 2b                	cmp    $0x2b,%al
  801ec2:	74 2e                	je     801ef2 <strtol+0x4e>
	int neg = 0;
  801ec4:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801ec9:	3c 2d                	cmp    $0x2d,%al
  801ecb:	74 2f                	je     801efc <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801ecd:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  801ed3:	75 05                	jne    801eda <strtol+0x36>
  801ed5:	80 39 30             	cmpb   $0x30,(%ecx)
  801ed8:	74 2c                	je     801f06 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  801eda:	85 db                	test   %ebx,%ebx
  801edc:	75 0a                	jne    801ee8 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801ede:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  801ee3:	80 39 30             	cmpb   $0x30,(%ecx)
  801ee6:	74 28                	je     801f10 <strtol+0x6c>
		base = 10;
  801ee8:	b8 00 00 00 00       	mov    $0x0,%eax
  801eed:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801ef0:	eb 50                	jmp    801f42 <strtol+0x9e>
		s++;
  801ef2:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  801ef5:	bf 00 00 00 00       	mov    $0x0,%edi
  801efa:	eb d1                	jmp    801ecd <strtol+0x29>
		s++, neg = 1;
  801efc:	83 c1 01             	add    $0x1,%ecx
  801eff:	bf 01 00 00 00       	mov    $0x1,%edi
  801f04:	eb c7                	jmp    801ecd <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801f06:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801f0a:	74 0e                	je     801f1a <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  801f0c:	85 db                	test   %ebx,%ebx
  801f0e:	75 d8                	jne    801ee8 <strtol+0x44>
		s++, base = 8;
  801f10:	83 c1 01             	add    $0x1,%ecx
  801f13:	bb 08 00 00 00       	mov    $0x8,%ebx
  801f18:	eb ce                	jmp    801ee8 <strtol+0x44>
		s += 2, base = 16;
  801f1a:	83 c1 02             	add    $0x2,%ecx
  801f1d:	bb 10 00 00 00       	mov    $0x10,%ebx
  801f22:	eb c4                	jmp    801ee8 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  801f24:	8d 72 9f             	lea    -0x61(%edx),%esi
  801f27:	89 f3                	mov    %esi,%ebx
  801f29:	80 fb 19             	cmp    $0x19,%bl
  801f2c:	77 29                	ja     801f57 <strtol+0xb3>
			dig = *s - 'a' + 10;
  801f2e:	0f be d2             	movsbl %dl,%edx
  801f31:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801f34:	3b 55 10             	cmp    0x10(%ebp),%edx
  801f37:	7d 30                	jge    801f69 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  801f39:	83 c1 01             	add    $0x1,%ecx
  801f3c:	0f af 45 10          	imul   0x10(%ebp),%eax
  801f40:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801f42:	0f b6 11             	movzbl (%ecx),%edx
  801f45:	8d 72 d0             	lea    -0x30(%edx),%esi
  801f48:	89 f3                	mov    %esi,%ebx
  801f4a:	80 fb 09             	cmp    $0x9,%bl
  801f4d:	77 d5                	ja     801f24 <strtol+0x80>
			dig = *s - '0';
  801f4f:	0f be d2             	movsbl %dl,%edx
  801f52:	83 ea 30             	sub    $0x30,%edx
  801f55:	eb dd                	jmp    801f34 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  801f57:	8d 72 bf             	lea    -0x41(%edx),%esi
  801f5a:	89 f3                	mov    %esi,%ebx
  801f5c:	80 fb 19             	cmp    $0x19,%bl
  801f5f:	77 08                	ja     801f69 <strtol+0xc5>
			dig = *s - 'A' + 10;
  801f61:	0f be d2             	movsbl %dl,%edx
  801f64:	83 ea 37             	sub    $0x37,%edx
  801f67:	eb cb                	jmp    801f34 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  801f69:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801f6d:	74 05                	je     801f74 <strtol+0xd0>
		*endptr = (char *) s;
  801f6f:	8b 75 0c             	mov    0xc(%ebp),%esi
  801f72:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801f74:	89 c2                	mov    %eax,%edx
  801f76:	f7 da                	neg    %edx
  801f78:	85 ff                	test   %edi,%edi
  801f7a:	0f 45 c2             	cmovne %edx,%eax
}
  801f7d:	5b                   	pop    %ebx
  801f7e:	5e                   	pop    %esi
  801f7f:	5f                   	pop    %edi
  801f80:	5d                   	pop    %ebp
  801f81:	c3                   	ret    

00801f82 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801f82:	55                   	push   %ebp
  801f83:	89 e5                	mov    %esp,%ebp
  801f85:	56                   	push   %esi
  801f86:	53                   	push   %ebx
  801f87:	8b 75 08             	mov    0x8(%ebp),%esi
  801f8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f8d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
  801f90:	85 c0                	test   %eax,%eax
	    pg = (void *)UTOP;
  801f92:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801f97:	0f 44 c2             	cmove  %edx,%eax
	}
	if ((r = sys_ipc_recv(pg)) < 0) {
  801f9a:	83 ec 0c             	sub    $0xc,%esp
  801f9d:	50                   	push   %eax
  801f9e:	e8 6b e3 ff ff       	call   80030e <sys_ipc_recv>
  801fa3:	83 c4 10             	add    $0x10,%esp
  801fa6:	85 c0                	test   %eax,%eax
  801fa8:	78 2b                	js     801fd5 <ipc_recv+0x53>
	    if (perm_store != NULL) {
	        *perm_store = 0;
	    }
	    return r;
	}
	if (from_env_store != NULL) {
  801faa:	85 f6                	test   %esi,%esi
  801fac:	74 0a                	je     801fb8 <ipc_recv+0x36>
	    *from_env_store = thisenv->env_ipc_from;
  801fae:	a1 08 40 80 00       	mov    0x804008,%eax
  801fb3:	8b 40 74             	mov    0x74(%eax),%eax
  801fb6:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store != NULL) {
  801fb8:	85 db                	test   %ebx,%ebx
  801fba:	74 0a                	je     801fc6 <ipc_recv+0x44>
	    *perm_store = thisenv->env_ipc_perm;
  801fbc:	a1 08 40 80 00       	mov    0x804008,%eax
  801fc1:	8b 40 78             	mov    0x78(%eax),%eax
  801fc4:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  801fc6:	a1 08 40 80 00       	mov    0x804008,%eax
  801fcb:	8b 40 70             	mov    0x70(%eax),%eax
}
  801fce:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fd1:	5b                   	pop    %ebx
  801fd2:	5e                   	pop    %esi
  801fd3:	5d                   	pop    %ebp
  801fd4:	c3                   	ret    
	    if (from_env_store != NULL) {
  801fd5:	85 f6                	test   %esi,%esi
  801fd7:	74 06                	je     801fdf <ipc_recv+0x5d>
	        *from_env_store = 0;
  801fd9:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	    if (perm_store != NULL) {
  801fdf:	85 db                	test   %ebx,%ebx
  801fe1:	74 eb                	je     801fce <ipc_recv+0x4c>
	        *perm_store = 0;
  801fe3:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801fe9:	eb e3                	jmp    801fce <ipc_recv+0x4c>

00801feb <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801feb:	55                   	push   %ebp
  801fec:	89 e5                	mov    %esp,%ebp
  801fee:	57                   	push   %edi
  801fef:	56                   	push   %esi
  801ff0:	53                   	push   %ebx
  801ff1:	83 ec 0c             	sub    $0xc,%esp
  801ff4:	8b 7d 08             	mov    0x8(%ebp),%edi
  801ff7:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
	    pg = (void *)UTOP;
  801ffa:	85 f6                	test   %esi,%esi
  801ffc:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802001:	0f 44 f0             	cmove  %eax,%esi
  802004:	eb 09                	jmp    80200f <ipc_send+0x24>
	do {
	    r = sys_ipc_try_send(to_env, val, pg, perm);
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
	        panic("ipc_send: %e", r);
	    }
	    sys_yield();
  802006:	e8 34 e1 ff ff       	call   80013f <sys_yield>
	} while(r != 0);
  80200b:	85 db                	test   %ebx,%ebx
  80200d:	74 2d                	je     80203c <ipc_send+0x51>
	    r = sys_ipc_try_send(to_env, val, pg, perm);
  80200f:	ff 75 14             	pushl  0x14(%ebp)
  802012:	56                   	push   %esi
  802013:	ff 75 0c             	pushl  0xc(%ebp)
  802016:	57                   	push   %edi
  802017:	e8 cf e2 ff ff       	call   8002eb <sys_ipc_try_send>
  80201c:	89 c3                	mov    %eax,%ebx
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
  80201e:	83 c4 10             	add    $0x10,%esp
  802021:	85 c0                	test   %eax,%eax
  802023:	79 e1                	jns    802006 <ipc_send+0x1b>
  802025:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802028:	74 dc                	je     802006 <ipc_send+0x1b>
	        panic("ipc_send: %e", r);
  80202a:	50                   	push   %eax
  80202b:	68 c0 27 80 00       	push   $0x8027c0
  802030:	6a 45                	push   $0x45
  802032:	68 cd 27 80 00       	push   $0x8027cd
  802037:	e8 91 f4 ff ff       	call   8014cd <_panic>
}
  80203c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80203f:	5b                   	pop    %ebx
  802040:	5e                   	pop    %esi
  802041:	5f                   	pop    %edi
  802042:	5d                   	pop    %ebp
  802043:	c3                   	ret    

00802044 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802044:	55                   	push   %ebp
  802045:	89 e5                	mov    %esp,%ebp
  802047:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80204a:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80204f:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802052:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802058:	8b 52 50             	mov    0x50(%edx),%edx
  80205b:	39 ca                	cmp    %ecx,%edx
  80205d:	74 11                	je     802070 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  80205f:	83 c0 01             	add    $0x1,%eax
  802062:	3d 00 04 00 00       	cmp    $0x400,%eax
  802067:	75 e6                	jne    80204f <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802069:	b8 00 00 00 00       	mov    $0x0,%eax
  80206e:	eb 0b                	jmp    80207b <ipc_find_env+0x37>
			return envs[i].env_id;
  802070:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802073:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802078:	8b 40 48             	mov    0x48(%eax),%eax
}
  80207b:	5d                   	pop    %ebp
  80207c:	c3                   	ret    

0080207d <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80207d:	55                   	push   %ebp
  80207e:	89 e5                	mov    %esp,%ebp
  802080:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802083:	89 d0                	mov    %edx,%eax
  802085:	c1 e8 16             	shr    $0x16,%eax
  802088:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80208f:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802094:	f6 c1 01             	test   $0x1,%cl
  802097:	74 1d                	je     8020b6 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802099:	c1 ea 0c             	shr    $0xc,%edx
  80209c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8020a3:	f6 c2 01             	test   $0x1,%dl
  8020a6:	74 0e                	je     8020b6 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8020a8:	c1 ea 0c             	shr    $0xc,%edx
  8020ab:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8020b2:	ef 
  8020b3:	0f b7 c0             	movzwl %ax,%eax
}
  8020b6:	5d                   	pop    %ebp
  8020b7:	c3                   	ret    
  8020b8:	66 90                	xchg   %ax,%ax
  8020ba:	66 90                	xchg   %ax,%ax
  8020bc:	66 90                	xchg   %ax,%ax
  8020be:	66 90                	xchg   %ax,%ax

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
