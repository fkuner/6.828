
obj/user/faultbadhandler.debug:     file format elf32-i386


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
  80002c:	e8 34 00 00 00       	call   800065 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 0c             	sub    $0xc,%esp
	sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W);
  800039:	6a 07                	push   $0x7
  80003b:	68 00 f0 bf ee       	push   $0xeebff000
  800040:	6a 00                	push   $0x0
  800042:	e8 3a 01 00 00       	call   800181 <sys_page_alloc>
	sys_env_set_pgfault_upcall(0, (void*) 0xDeadBeef);
  800047:	83 c4 08             	add    $0x8,%esp
  80004a:	68 ef be ad de       	push   $0xdeadbeef
  80004f:	6a 00                	push   $0x0
  800051:	e8 76 02 00 00       	call   8002cc <sys_env_set_pgfault_upcall>
	*(int*)0 = 0;
  800056:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  80005d:	00 00 00 
}
  800060:	83 c4 10             	add    $0x10,%esp
  800063:	c9                   	leave  
  800064:	c3                   	ret    

00800065 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800065:	55                   	push   %ebp
  800066:	89 e5                	mov    %esp,%ebp
  800068:	56                   	push   %esi
  800069:	53                   	push   %ebx
  80006a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80006d:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
    thisenv = &envs[ENVX(sys_getenvid())];
  800070:	e8 ce 00 00 00       	call   800143 <sys_getenvid>
  800075:	25 ff 03 00 00       	and    $0x3ff,%eax
  80007a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80007d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800082:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800087:	85 db                	test   %ebx,%ebx
  800089:	7e 07                	jle    800092 <libmain+0x2d>
		binaryname = argv[0];
  80008b:	8b 06                	mov    (%esi),%eax
  80008d:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800092:	83 ec 08             	sub    $0x8,%esp
  800095:	56                   	push   %esi
  800096:	53                   	push   %ebx
  800097:	e8 97 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80009c:	e8 0a 00 00 00       	call   8000ab <exit>
}
  8000a1:	83 c4 10             	add    $0x10,%esp
  8000a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000a7:	5b                   	pop    %ebx
  8000a8:	5e                   	pop    %esi
  8000a9:	5d                   	pop    %ebp
  8000aa:	c3                   	ret    

008000ab <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000ab:	55                   	push   %ebp
  8000ac:	89 e5                	mov    %esp,%ebp
  8000ae:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000b1:	e8 b1 04 00 00       	call   800567 <close_all>
	sys_env_destroy(0);
  8000b6:	83 ec 0c             	sub    $0xc,%esp
  8000b9:	6a 00                	push   $0x0
  8000bb:	e8 42 00 00 00       	call   800102 <sys_env_destroy>
}
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	c9                   	leave  
  8000c4:	c3                   	ret    

008000c5 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000c5:	55                   	push   %ebp
  8000c6:	89 e5                	mov    %esp,%ebp
  8000c8:	57                   	push   %edi
  8000c9:	56                   	push   %esi
  8000ca:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8000d3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000d6:	89 c3                	mov    %eax,%ebx
  8000d8:	89 c7                	mov    %eax,%edi
  8000da:	89 c6                	mov    %eax,%esi
  8000dc:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000de:	5b                   	pop    %ebx
  8000df:	5e                   	pop    %esi
  8000e0:	5f                   	pop    %edi
  8000e1:	5d                   	pop    %ebp
  8000e2:	c3                   	ret    

008000e3 <sys_cgetc>:

int
sys_cgetc(void)
{
  8000e3:	55                   	push   %ebp
  8000e4:	89 e5                	mov    %esp,%ebp
  8000e6:	57                   	push   %edi
  8000e7:	56                   	push   %esi
  8000e8:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8000ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8000f3:	89 d1                	mov    %edx,%ecx
  8000f5:	89 d3                	mov    %edx,%ebx
  8000f7:	89 d7                	mov    %edx,%edi
  8000f9:	89 d6                	mov    %edx,%esi
  8000fb:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000fd:	5b                   	pop    %ebx
  8000fe:	5e                   	pop    %esi
  8000ff:	5f                   	pop    %edi
  800100:	5d                   	pop    %ebp
  800101:	c3                   	ret    

00800102 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800102:	55                   	push   %ebp
  800103:	89 e5                	mov    %esp,%ebp
  800105:	57                   	push   %edi
  800106:	56                   	push   %esi
  800107:	53                   	push   %ebx
  800108:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80010b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800110:	8b 55 08             	mov    0x8(%ebp),%edx
  800113:	b8 03 00 00 00       	mov    $0x3,%eax
  800118:	89 cb                	mov    %ecx,%ebx
  80011a:	89 cf                	mov    %ecx,%edi
  80011c:	89 ce                	mov    %ecx,%esi
  80011e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800120:	85 c0                	test   %eax,%eax
  800122:	7f 08                	jg     80012c <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800124:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800127:	5b                   	pop    %ebx
  800128:	5e                   	pop    %esi
  800129:	5f                   	pop    %edi
  80012a:	5d                   	pop    %ebp
  80012b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80012c:	83 ec 0c             	sub    $0xc,%esp
  80012f:	50                   	push   %eax
  800130:	6a 03                	push   $0x3
  800132:	68 2a 23 80 00       	push   $0x80232a
  800137:	6a 23                	push   $0x23
  800139:	68 47 23 80 00       	push   $0x802347
  80013e:	e8 ad 13 00 00       	call   8014f0 <_panic>

00800143 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800143:	55                   	push   %ebp
  800144:	89 e5                	mov    %esp,%ebp
  800146:	57                   	push   %edi
  800147:	56                   	push   %esi
  800148:	53                   	push   %ebx
	asm volatile("int %1\n"
  800149:	ba 00 00 00 00       	mov    $0x0,%edx
  80014e:	b8 02 00 00 00       	mov    $0x2,%eax
  800153:	89 d1                	mov    %edx,%ecx
  800155:	89 d3                	mov    %edx,%ebx
  800157:	89 d7                	mov    %edx,%edi
  800159:	89 d6                	mov    %edx,%esi
  80015b:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80015d:	5b                   	pop    %ebx
  80015e:	5e                   	pop    %esi
  80015f:	5f                   	pop    %edi
  800160:	5d                   	pop    %ebp
  800161:	c3                   	ret    

00800162 <sys_yield>:

void
sys_yield(void)
{
  800162:	55                   	push   %ebp
  800163:	89 e5                	mov    %esp,%ebp
  800165:	57                   	push   %edi
  800166:	56                   	push   %esi
  800167:	53                   	push   %ebx
	asm volatile("int %1\n"
  800168:	ba 00 00 00 00       	mov    $0x0,%edx
  80016d:	b8 0b 00 00 00       	mov    $0xb,%eax
  800172:	89 d1                	mov    %edx,%ecx
  800174:	89 d3                	mov    %edx,%ebx
  800176:	89 d7                	mov    %edx,%edi
  800178:	89 d6                	mov    %edx,%esi
  80017a:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80017c:	5b                   	pop    %ebx
  80017d:	5e                   	pop    %esi
  80017e:	5f                   	pop    %edi
  80017f:	5d                   	pop    %ebp
  800180:	c3                   	ret    

00800181 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800181:	55                   	push   %ebp
  800182:	89 e5                	mov    %esp,%ebp
  800184:	57                   	push   %edi
  800185:	56                   	push   %esi
  800186:	53                   	push   %ebx
  800187:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80018a:	be 00 00 00 00       	mov    $0x0,%esi
  80018f:	8b 55 08             	mov    0x8(%ebp),%edx
  800192:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800195:	b8 04 00 00 00       	mov    $0x4,%eax
  80019a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80019d:	89 f7                	mov    %esi,%edi
  80019f:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001a1:	85 c0                	test   %eax,%eax
  8001a3:	7f 08                	jg     8001ad <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8001a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001a8:	5b                   	pop    %ebx
  8001a9:	5e                   	pop    %esi
  8001aa:	5f                   	pop    %edi
  8001ab:	5d                   	pop    %ebp
  8001ac:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001ad:	83 ec 0c             	sub    $0xc,%esp
  8001b0:	50                   	push   %eax
  8001b1:	6a 04                	push   $0x4
  8001b3:	68 2a 23 80 00       	push   $0x80232a
  8001b8:	6a 23                	push   $0x23
  8001ba:	68 47 23 80 00       	push   $0x802347
  8001bf:	e8 2c 13 00 00       	call   8014f0 <_panic>

008001c4 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001c4:	55                   	push   %ebp
  8001c5:	89 e5                	mov    %esp,%ebp
  8001c7:	57                   	push   %edi
  8001c8:	56                   	push   %esi
  8001c9:	53                   	push   %ebx
  8001ca:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8001d0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001d3:	b8 05 00 00 00       	mov    $0x5,%eax
  8001d8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001db:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001de:	8b 75 18             	mov    0x18(%ebp),%esi
  8001e1:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001e3:	85 c0                	test   %eax,%eax
  8001e5:	7f 08                	jg     8001ef <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001ea:	5b                   	pop    %ebx
  8001eb:	5e                   	pop    %esi
  8001ec:	5f                   	pop    %edi
  8001ed:	5d                   	pop    %ebp
  8001ee:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001ef:	83 ec 0c             	sub    $0xc,%esp
  8001f2:	50                   	push   %eax
  8001f3:	6a 05                	push   $0x5
  8001f5:	68 2a 23 80 00       	push   $0x80232a
  8001fa:	6a 23                	push   $0x23
  8001fc:	68 47 23 80 00       	push   $0x802347
  800201:	e8 ea 12 00 00       	call   8014f0 <_panic>

00800206 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800206:	55                   	push   %ebp
  800207:	89 e5                	mov    %esp,%ebp
  800209:	57                   	push   %edi
  80020a:	56                   	push   %esi
  80020b:	53                   	push   %ebx
  80020c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80020f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800214:	8b 55 08             	mov    0x8(%ebp),%edx
  800217:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80021a:	b8 06 00 00 00       	mov    $0x6,%eax
  80021f:	89 df                	mov    %ebx,%edi
  800221:	89 de                	mov    %ebx,%esi
  800223:	cd 30                	int    $0x30
	if(check && ret > 0)
  800225:	85 c0                	test   %eax,%eax
  800227:	7f 08                	jg     800231 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800229:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80022c:	5b                   	pop    %ebx
  80022d:	5e                   	pop    %esi
  80022e:	5f                   	pop    %edi
  80022f:	5d                   	pop    %ebp
  800230:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800231:	83 ec 0c             	sub    $0xc,%esp
  800234:	50                   	push   %eax
  800235:	6a 06                	push   $0x6
  800237:	68 2a 23 80 00       	push   $0x80232a
  80023c:	6a 23                	push   $0x23
  80023e:	68 47 23 80 00       	push   $0x802347
  800243:	e8 a8 12 00 00       	call   8014f0 <_panic>

00800248 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800248:	55                   	push   %ebp
  800249:	89 e5                	mov    %esp,%ebp
  80024b:	57                   	push   %edi
  80024c:	56                   	push   %esi
  80024d:	53                   	push   %ebx
  80024e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800251:	bb 00 00 00 00       	mov    $0x0,%ebx
  800256:	8b 55 08             	mov    0x8(%ebp),%edx
  800259:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80025c:	b8 08 00 00 00       	mov    $0x8,%eax
  800261:	89 df                	mov    %ebx,%edi
  800263:	89 de                	mov    %ebx,%esi
  800265:	cd 30                	int    $0x30
	if(check && ret > 0)
  800267:	85 c0                	test   %eax,%eax
  800269:	7f 08                	jg     800273 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80026b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80026e:	5b                   	pop    %ebx
  80026f:	5e                   	pop    %esi
  800270:	5f                   	pop    %edi
  800271:	5d                   	pop    %ebp
  800272:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800273:	83 ec 0c             	sub    $0xc,%esp
  800276:	50                   	push   %eax
  800277:	6a 08                	push   $0x8
  800279:	68 2a 23 80 00       	push   $0x80232a
  80027e:	6a 23                	push   $0x23
  800280:	68 47 23 80 00       	push   $0x802347
  800285:	e8 66 12 00 00       	call   8014f0 <_panic>

0080028a <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80028a:	55                   	push   %ebp
  80028b:	89 e5                	mov    %esp,%ebp
  80028d:	57                   	push   %edi
  80028e:	56                   	push   %esi
  80028f:	53                   	push   %ebx
  800290:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800293:	bb 00 00 00 00       	mov    $0x0,%ebx
  800298:	8b 55 08             	mov    0x8(%ebp),%edx
  80029b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80029e:	b8 09 00 00 00       	mov    $0x9,%eax
  8002a3:	89 df                	mov    %ebx,%edi
  8002a5:	89 de                	mov    %ebx,%esi
  8002a7:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002a9:	85 c0                	test   %eax,%eax
  8002ab:	7f 08                	jg     8002b5 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8002ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002b0:	5b                   	pop    %ebx
  8002b1:	5e                   	pop    %esi
  8002b2:	5f                   	pop    %edi
  8002b3:	5d                   	pop    %ebp
  8002b4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002b5:	83 ec 0c             	sub    $0xc,%esp
  8002b8:	50                   	push   %eax
  8002b9:	6a 09                	push   $0x9
  8002bb:	68 2a 23 80 00       	push   $0x80232a
  8002c0:	6a 23                	push   $0x23
  8002c2:	68 47 23 80 00       	push   $0x802347
  8002c7:	e8 24 12 00 00       	call   8014f0 <_panic>

008002cc <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002cc:	55                   	push   %ebp
  8002cd:	89 e5                	mov    %esp,%ebp
  8002cf:	57                   	push   %edi
  8002d0:	56                   	push   %esi
  8002d1:	53                   	push   %ebx
  8002d2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002d5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002da:	8b 55 08             	mov    0x8(%ebp),%edx
  8002dd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002e0:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002e5:	89 df                	mov    %ebx,%edi
  8002e7:	89 de                	mov    %ebx,%esi
  8002e9:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002eb:	85 c0                	test   %eax,%eax
  8002ed:	7f 08                	jg     8002f7 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8002ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002f2:	5b                   	pop    %ebx
  8002f3:	5e                   	pop    %esi
  8002f4:	5f                   	pop    %edi
  8002f5:	5d                   	pop    %ebp
  8002f6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002f7:	83 ec 0c             	sub    $0xc,%esp
  8002fa:	50                   	push   %eax
  8002fb:	6a 0a                	push   $0xa
  8002fd:	68 2a 23 80 00       	push   $0x80232a
  800302:	6a 23                	push   $0x23
  800304:	68 47 23 80 00       	push   $0x802347
  800309:	e8 e2 11 00 00       	call   8014f0 <_panic>

0080030e <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80030e:	55                   	push   %ebp
  80030f:	89 e5                	mov    %esp,%ebp
  800311:	57                   	push   %edi
  800312:	56                   	push   %esi
  800313:	53                   	push   %ebx
	asm volatile("int %1\n"
  800314:	8b 55 08             	mov    0x8(%ebp),%edx
  800317:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80031a:	b8 0c 00 00 00       	mov    $0xc,%eax
  80031f:	be 00 00 00 00       	mov    $0x0,%esi
  800324:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800327:	8b 7d 14             	mov    0x14(%ebp),%edi
  80032a:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80032c:	5b                   	pop    %ebx
  80032d:	5e                   	pop    %esi
  80032e:	5f                   	pop    %edi
  80032f:	5d                   	pop    %ebp
  800330:	c3                   	ret    

00800331 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800331:	55                   	push   %ebp
  800332:	89 e5                	mov    %esp,%ebp
  800334:	57                   	push   %edi
  800335:	56                   	push   %esi
  800336:	53                   	push   %ebx
  800337:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80033a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80033f:	8b 55 08             	mov    0x8(%ebp),%edx
  800342:	b8 0d 00 00 00       	mov    $0xd,%eax
  800347:	89 cb                	mov    %ecx,%ebx
  800349:	89 cf                	mov    %ecx,%edi
  80034b:	89 ce                	mov    %ecx,%esi
  80034d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80034f:	85 c0                	test   %eax,%eax
  800351:	7f 08                	jg     80035b <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800353:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800356:	5b                   	pop    %ebx
  800357:	5e                   	pop    %esi
  800358:	5f                   	pop    %edi
  800359:	5d                   	pop    %ebp
  80035a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80035b:	83 ec 0c             	sub    $0xc,%esp
  80035e:	50                   	push   %eax
  80035f:	6a 0d                	push   $0xd
  800361:	68 2a 23 80 00       	push   $0x80232a
  800366:	6a 23                	push   $0x23
  800368:	68 47 23 80 00       	push   $0x802347
  80036d:	e8 7e 11 00 00       	call   8014f0 <_panic>

00800372 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800372:	55                   	push   %ebp
  800373:	89 e5                	mov    %esp,%ebp
  800375:	57                   	push   %edi
  800376:	56                   	push   %esi
  800377:	53                   	push   %ebx
	asm volatile("int %1\n"
  800378:	ba 00 00 00 00       	mov    $0x0,%edx
  80037d:	b8 0e 00 00 00       	mov    $0xe,%eax
  800382:	89 d1                	mov    %edx,%ecx
  800384:	89 d3                	mov    %edx,%ebx
  800386:	89 d7                	mov    %edx,%edi
  800388:	89 d6                	mov    %edx,%esi
  80038a:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  80038c:	5b                   	pop    %ebx
  80038d:	5e                   	pop    %esi
  80038e:	5f                   	pop    %edi
  80038f:	5d                   	pop    %ebp
  800390:	c3                   	ret    

00800391 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800391:	55                   	push   %ebp
  800392:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800394:	8b 45 08             	mov    0x8(%ebp),%eax
  800397:	05 00 00 00 30       	add    $0x30000000,%eax
  80039c:	c1 e8 0c             	shr    $0xc,%eax
}
  80039f:	5d                   	pop    %ebp
  8003a0:	c3                   	ret    

008003a1 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8003a1:	55                   	push   %ebp
  8003a2:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8003a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a7:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8003ac:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003b1:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8003b6:	5d                   	pop    %ebp
  8003b7:	c3                   	ret    

008003b8 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8003b8:	55                   	push   %ebp
  8003b9:	89 e5                	mov    %esp,%ebp
  8003bb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003be:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8003c3:	89 c2                	mov    %eax,%edx
  8003c5:	c1 ea 16             	shr    $0x16,%edx
  8003c8:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8003cf:	f6 c2 01             	test   $0x1,%dl
  8003d2:	74 2a                	je     8003fe <fd_alloc+0x46>
  8003d4:	89 c2                	mov    %eax,%edx
  8003d6:	c1 ea 0c             	shr    $0xc,%edx
  8003d9:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8003e0:	f6 c2 01             	test   $0x1,%dl
  8003e3:	74 19                	je     8003fe <fd_alloc+0x46>
  8003e5:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8003ea:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8003ef:	75 d2                	jne    8003c3 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8003f1:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8003f7:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8003fc:	eb 07                	jmp    800405 <fd_alloc+0x4d>
			*fd_store = fd;
  8003fe:	89 01                	mov    %eax,(%ecx)
			return 0;
  800400:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800405:	5d                   	pop    %ebp
  800406:	c3                   	ret    

00800407 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800407:	55                   	push   %ebp
  800408:	89 e5                	mov    %esp,%ebp
  80040a:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80040d:	83 f8 1f             	cmp    $0x1f,%eax
  800410:	77 36                	ja     800448 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800412:	c1 e0 0c             	shl    $0xc,%eax
  800415:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80041a:	89 c2                	mov    %eax,%edx
  80041c:	c1 ea 16             	shr    $0x16,%edx
  80041f:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800426:	f6 c2 01             	test   $0x1,%dl
  800429:	74 24                	je     80044f <fd_lookup+0x48>
  80042b:	89 c2                	mov    %eax,%edx
  80042d:	c1 ea 0c             	shr    $0xc,%edx
  800430:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800437:	f6 c2 01             	test   $0x1,%dl
  80043a:	74 1a                	je     800456 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80043c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80043f:	89 02                	mov    %eax,(%edx)
	return 0;
  800441:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800446:	5d                   	pop    %ebp
  800447:	c3                   	ret    
		return -E_INVAL;
  800448:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80044d:	eb f7                	jmp    800446 <fd_lookup+0x3f>
		return -E_INVAL;
  80044f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800454:	eb f0                	jmp    800446 <fd_lookup+0x3f>
  800456:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80045b:	eb e9                	jmp    800446 <fd_lookup+0x3f>

0080045d <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80045d:	55                   	push   %ebp
  80045e:	89 e5                	mov    %esp,%ebp
  800460:	83 ec 08             	sub    $0x8,%esp
  800463:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800466:	ba d4 23 80 00       	mov    $0x8023d4,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  80046b:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800470:	39 08                	cmp    %ecx,(%eax)
  800472:	74 33                	je     8004a7 <dev_lookup+0x4a>
  800474:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800477:	8b 02                	mov    (%edx),%eax
  800479:	85 c0                	test   %eax,%eax
  80047b:	75 f3                	jne    800470 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80047d:	a1 08 40 80 00       	mov    0x804008,%eax
  800482:	8b 40 48             	mov    0x48(%eax),%eax
  800485:	83 ec 04             	sub    $0x4,%esp
  800488:	51                   	push   %ecx
  800489:	50                   	push   %eax
  80048a:	68 58 23 80 00       	push   $0x802358
  80048f:	e8 37 11 00 00       	call   8015cb <cprintf>
	*dev = 0;
  800494:	8b 45 0c             	mov    0xc(%ebp),%eax
  800497:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80049d:	83 c4 10             	add    $0x10,%esp
  8004a0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8004a5:	c9                   	leave  
  8004a6:	c3                   	ret    
			*dev = devtab[i];
  8004a7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004aa:	89 01                	mov    %eax,(%ecx)
			return 0;
  8004ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8004b1:	eb f2                	jmp    8004a5 <dev_lookup+0x48>

008004b3 <fd_close>:
{
  8004b3:	55                   	push   %ebp
  8004b4:	89 e5                	mov    %esp,%ebp
  8004b6:	57                   	push   %edi
  8004b7:	56                   	push   %esi
  8004b8:	53                   	push   %ebx
  8004b9:	83 ec 1c             	sub    $0x1c,%esp
  8004bc:	8b 75 08             	mov    0x8(%ebp),%esi
  8004bf:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8004c2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8004c5:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8004c6:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8004cc:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8004cf:	50                   	push   %eax
  8004d0:	e8 32 ff ff ff       	call   800407 <fd_lookup>
  8004d5:	89 c3                	mov    %eax,%ebx
  8004d7:	83 c4 08             	add    $0x8,%esp
  8004da:	85 c0                	test   %eax,%eax
  8004dc:	78 05                	js     8004e3 <fd_close+0x30>
	    || fd != fd2)
  8004de:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8004e1:	74 16                	je     8004f9 <fd_close+0x46>
		return (must_exist ? r : 0);
  8004e3:	89 f8                	mov    %edi,%eax
  8004e5:	84 c0                	test   %al,%al
  8004e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8004ec:	0f 44 d8             	cmove  %eax,%ebx
}
  8004ef:	89 d8                	mov    %ebx,%eax
  8004f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004f4:	5b                   	pop    %ebx
  8004f5:	5e                   	pop    %esi
  8004f6:	5f                   	pop    %edi
  8004f7:	5d                   	pop    %ebp
  8004f8:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8004f9:	83 ec 08             	sub    $0x8,%esp
  8004fc:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8004ff:	50                   	push   %eax
  800500:	ff 36                	pushl  (%esi)
  800502:	e8 56 ff ff ff       	call   80045d <dev_lookup>
  800507:	89 c3                	mov    %eax,%ebx
  800509:	83 c4 10             	add    $0x10,%esp
  80050c:	85 c0                	test   %eax,%eax
  80050e:	78 15                	js     800525 <fd_close+0x72>
		if (dev->dev_close)
  800510:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800513:	8b 40 10             	mov    0x10(%eax),%eax
  800516:	85 c0                	test   %eax,%eax
  800518:	74 1b                	je     800535 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  80051a:	83 ec 0c             	sub    $0xc,%esp
  80051d:	56                   	push   %esi
  80051e:	ff d0                	call   *%eax
  800520:	89 c3                	mov    %eax,%ebx
  800522:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800525:	83 ec 08             	sub    $0x8,%esp
  800528:	56                   	push   %esi
  800529:	6a 00                	push   $0x0
  80052b:	e8 d6 fc ff ff       	call   800206 <sys_page_unmap>
	return r;
  800530:	83 c4 10             	add    $0x10,%esp
  800533:	eb ba                	jmp    8004ef <fd_close+0x3c>
			r = 0;
  800535:	bb 00 00 00 00       	mov    $0x0,%ebx
  80053a:	eb e9                	jmp    800525 <fd_close+0x72>

0080053c <close>:

int
close(int fdnum)
{
  80053c:	55                   	push   %ebp
  80053d:	89 e5                	mov    %esp,%ebp
  80053f:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800542:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800545:	50                   	push   %eax
  800546:	ff 75 08             	pushl  0x8(%ebp)
  800549:	e8 b9 fe ff ff       	call   800407 <fd_lookup>
  80054e:	83 c4 08             	add    $0x8,%esp
  800551:	85 c0                	test   %eax,%eax
  800553:	78 10                	js     800565 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  800555:	83 ec 08             	sub    $0x8,%esp
  800558:	6a 01                	push   $0x1
  80055a:	ff 75 f4             	pushl  -0xc(%ebp)
  80055d:	e8 51 ff ff ff       	call   8004b3 <fd_close>
  800562:	83 c4 10             	add    $0x10,%esp
}
  800565:	c9                   	leave  
  800566:	c3                   	ret    

00800567 <close_all>:

void
close_all(void)
{
  800567:	55                   	push   %ebp
  800568:	89 e5                	mov    %esp,%ebp
  80056a:	53                   	push   %ebx
  80056b:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80056e:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800573:	83 ec 0c             	sub    $0xc,%esp
  800576:	53                   	push   %ebx
  800577:	e8 c0 ff ff ff       	call   80053c <close>
	for (i = 0; i < MAXFD; i++)
  80057c:	83 c3 01             	add    $0x1,%ebx
  80057f:	83 c4 10             	add    $0x10,%esp
  800582:	83 fb 20             	cmp    $0x20,%ebx
  800585:	75 ec                	jne    800573 <close_all+0xc>
}
  800587:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80058a:	c9                   	leave  
  80058b:	c3                   	ret    

0080058c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80058c:	55                   	push   %ebp
  80058d:	89 e5                	mov    %esp,%ebp
  80058f:	57                   	push   %edi
  800590:	56                   	push   %esi
  800591:	53                   	push   %ebx
  800592:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800595:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800598:	50                   	push   %eax
  800599:	ff 75 08             	pushl  0x8(%ebp)
  80059c:	e8 66 fe ff ff       	call   800407 <fd_lookup>
  8005a1:	89 c3                	mov    %eax,%ebx
  8005a3:	83 c4 08             	add    $0x8,%esp
  8005a6:	85 c0                	test   %eax,%eax
  8005a8:	0f 88 81 00 00 00    	js     80062f <dup+0xa3>
		return r;
	close(newfdnum);
  8005ae:	83 ec 0c             	sub    $0xc,%esp
  8005b1:	ff 75 0c             	pushl  0xc(%ebp)
  8005b4:	e8 83 ff ff ff       	call   80053c <close>

	newfd = INDEX2FD(newfdnum);
  8005b9:	8b 75 0c             	mov    0xc(%ebp),%esi
  8005bc:	c1 e6 0c             	shl    $0xc,%esi
  8005bf:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8005c5:	83 c4 04             	add    $0x4,%esp
  8005c8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8005cb:	e8 d1 fd ff ff       	call   8003a1 <fd2data>
  8005d0:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8005d2:	89 34 24             	mov    %esi,(%esp)
  8005d5:	e8 c7 fd ff ff       	call   8003a1 <fd2data>
  8005da:	83 c4 10             	add    $0x10,%esp
  8005dd:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8005df:	89 d8                	mov    %ebx,%eax
  8005e1:	c1 e8 16             	shr    $0x16,%eax
  8005e4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8005eb:	a8 01                	test   $0x1,%al
  8005ed:	74 11                	je     800600 <dup+0x74>
  8005ef:	89 d8                	mov    %ebx,%eax
  8005f1:	c1 e8 0c             	shr    $0xc,%eax
  8005f4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8005fb:	f6 c2 01             	test   $0x1,%dl
  8005fe:	75 39                	jne    800639 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800600:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800603:	89 d0                	mov    %edx,%eax
  800605:	c1 e8 0c             	shr    $0xc,%eax
  800608:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80060f:	83 ec 0c             	sub    $0xc,%esp
  800612:	25 07 0e 00 00       	and    $0xe07,%eax
  800617:	50                   	push   %eax
  800618:	56                   	push   %esi
  800619:	6a 00                	push   $0x0
  80061b:	52                   	push   %edx
  80061c:	6a 00                	push   $0x0
  80061e:	e8 a1 fb ff ff       	call   8001c4 <sys_page_map>
  800623:	89 c3                	mov    %eax,%ebx
  800625:	83 c4 20             	add    $0x20,%esp
  800628:	85 c0                	test   %eax,%eax
  80062a:	78 31                	js     80065d <dup+0xd1>
		goto err;

	return newfdnum;
  80062c:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80062f:	89 d8                	mov    %ebx,%eax
  800631:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800634:	5b                   	pop    %ebx
  800635:	5e                   	pop    %esi
  800636:	5f                   	pop    %edi
  800637:	5d                   	pop    %ebp
  800638:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800639:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800640:	83 ec 0c             	sub    $0xc,%esp
  800643:	25 07 0e 00 00       	and    $0xe07,%eax
  800648:	50                   	push   %eax
  800649:	57                   	push   %edi
  80064a:	6a 00                	push   $0x0
  80064c:	53                   	push   %ebx
  80064d:	6a 00                	push   $0x0
  80064f:	e8 70 fb ff ff       	call   8001c4 <sys_page_map>
  800654:	89 c3                	mov    %eax,%ebx
  800656:	83 c4 20             	add    $0x20,%esp
  800659:	85 c0                	test   %eax,%eax
  80065b:	79 a3                	jns    800600 <dup+0x74>
	sys_page_unmap(0, newfd);
  80065d:	83 ec 08             	sub    $0x8,%esp
  800660:	56                   	push   %esi
  800661:	6a 00                	push   $0x0
  800663:	e8 9e fb ff ff       	call   800206 <sys_page_unmap>
	sys_page_unmap(0, nva);
  800668:	83 c4 08             	add    $0x8,%esp
  80066b:	57                   	push   %edi
  80066c:	6a 00                	push   $0x0
  80066e:	e8 93 fb ff ff       	call   800206 <sys_page_unmap>
	return r;
  800673:	83 c4 10             	add    $0x10,%esp
  800676:	eb b7                	jmp    80062f <dup+0xa3>

00800678 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800678:	55                   	push   %ebp
  800679:	89 e5                	mov    %esp,%ebp
  80067b:	53                   	push   %ebx
  80067c:	83 ec 14             	sub    $0x14,%esp
  80067f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800682:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800685:	50                   	push   %eax
  800686:	53                   	push   %ebx
  800687:	e8 7b fd ff ff       	call   800407 <fd_lookup>
  80068c:	83 c4 08             	add    $0x8,%esp
  80068f:	85 c0                	test   %eax,%eax
  800691:	78 3f                	js     8006d2 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800693:	83 ec 08             	sub    $0x8,%esp
  800696:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800699:	50                   	push   %eax
  80069a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80069d:	ff 30                	pushl  (%eax)
  80069f:	e8 b9 fd ff ff       	call   80045d <dev_lookup>
  8006a4:	83 c4 10             	add    $0x10,%esp
  8006a7:	85 c0                	test   %eax,%eax
  8006a9:	78 27                	js     8006d2 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8006ab:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8006ae:	8b 42 08             	mov    0x8(%edx),%eax
  8006b1:	83 e0 03             	and    $0x3,%eax
  8006b4:	83 f8 01             	cmp    $0x1,%eax
  8006b7:	74 1e                	je     8006d7 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8006b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006bc:	8b 40 08             	mov    0x8(%eax),%eax
  8006bf:	85 c0                	test   %eax,%eax
  8006c1:	74 35                	je     8006f8 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8006c3:	83 ec 04             	sub    $0x4,%esp
  8006c6:	ff 75 10             	pushl  0x10(%ebp)
  8006c9:	ff 75 0c             	pushl  0xc(%ebp)
  8006cc:	52                   	push   %edx
  8006cd:	ff d0                	call   *%eax
  8006cf:	83 c4 10             	add    $0x10,%esp
}
  8006d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006d5:	c9                   	leave  
  8006d6:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8006d7:	a1 08 40 80 00       	mov    0x804008,%eax
  8006dc:	8b 40 48             	mov    0x48(%eax),%eax
  8006df:	83 ec 04             	sub    $0x4,%esp
  8006e2:	53                   	push   %ebx
  8006e3:	50                   	push   %eax
  8006e4:	68 99 23 80 00       	push   $0x802399
  8006e9:	e8 dd 0e 00 00       	call   8015cb <cprintf>
		return -E_INVAL;
  8006ee:	83 c4 10             	add    $0x10,%esp
  8006f1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8006f6:	eb da                	jmp    8006d2 <read+0x5a>
		return -E_NOT_SUPP;
  8006f8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8006fd:	eb d3                	jmp    8006d2 <read+0x5a>

008006ff <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8006ff:	55                   	push   %ebp
  800700:	89 e5                	mov    %esp,%ebp
  800702:	57                   	push   %edi
  800703:	56                   	push   %esi
  800704:	53                   	push   %ebx
  800705:	83 ec 0c             	sub    $0xc,%esp
  800708:	8b 7d 08             	mov    0x8(%ebp),%edi
  80070b:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80070e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800713:	39 f3                	cmp    %esi,%ebx
  800715:	73 25                	jae    80073c <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800717:	83 ec 04             	sub    $0x4,%esp
  80071a:	89 f0                	mov    %esi,%eax
  80071c:	29 d8                	sub    %ebx,%eax
  80071e:	50                   	push   %eax
  80071f:	89 d8                	mov    %ebx,%eax
  800721:	03 45 0c             	add    0xc(%ebp),%eax
  800724:	50                   	push   %eax
  800725:	57                   	push   %edi
  800726:	e8 4d ff ff ff       	call   800678 <read>
		if (m < 0)
  80072b:	83 c4 10             	add    $0x10,%esp
  80072e:	85 c0                	test   %eax,%eax
  800730:	78 08                	js     80073a <readn+0x3b>
			return m;
		if (m == 0)
  800732:	85 c0                	test   %eax,%eax
  800734:	74 06                	je     80073c <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  800736:	01 c3                	add    %eax,%ebx
  800738:	eb d9                	jmp    800713 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80073a:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80073c:	89 d8                	mov    %ebx,%eax
  80073e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800741:	5b                   	pop    %ebx
  800742:	5e                   	pop    %esi
  800743:	5f                   	pop    %edi
  800744:	5d                   	pop    %ebp
  800745:	c3                   	ret    

00800746 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800746:	55                   	push   %ebp
  800747:	89 e5                	mov    %esp,%ebp
  800749:	53                   	push   %ebx
  80074a:	83 ec 14             	sub    $0x14,%esp
  80074d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800750:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800753:	50                   	push   %eax
  800754:	53                   	push   %ebx
  800755:	e8 ad fc ff ff       	call   800407 <fd_lookup>
  80075a:	83 c4 08             	add    $0x8,%esp
  80075d:	85 c0                	test   %eax,%eax
  80075f:	78 3a                	js     80079b <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800761:	83 ec 08             	sub    $0x8,%esp
  800764:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800767:	50                   	push   %eax
  800768:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80076b:	ff 30                	pushl  (%eax)
  80076d:	e8 eb fc ff ff       	call   80045d <dev_lookup>
  800772:	83 c4 10             	add    $0x10,%esp
  800775:	85 c0                	test   %eax,%eax
  800777:	78 22                	js     80079b <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800779:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80077c:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800780:	74 1e                	je     8007a0 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800782:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800785:	8b 52 0c             	mov    0xc(%edx),%edx
  800788:	85 d2                	test   %edx,%edx
  80078a:	74 35                	je     8007c1 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80078c:	83 ec 04             	sub    $0x4,%esp
  80078f:	ff 75 10             	pushl  0x10(%ebp)
  800792:	ff 75 0c             	pushl  0xc(%ebp)
  800795:	50                   	push   %eax
  800796:	ff d2                	call   *%edx
  800798:	83 c4 10             	add    $0x10,%esp
}
  80079b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80079e:	c9                   	leave  
  80079f:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8007a0:	a1 08 40 80 00       	mov    0x804008,%eax
  8007a5:	8b 40 48             	mov    0x48(%eax),%eax
  8007a8:	83 ec 04             	sub    $0x4,%esp
  8007ab:	53                   	push   %ebx
  8007ac:	50                   	push   %eax
  8007ad:	68 b5 23 80 00       	push   $0x8023b5
  8007b2:	e8 14 0e 00 00       	call   8015cb <cprintf>
		return -E_INVAL;
  8007b7:	83 c4 10             	add    $0x10,%esp
  8007ba:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007bf:	eb da                	jmp    80079b <write+0x55>
		return -E_NOT_SUPP;
  8007c1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8007c6:	eb d3                	jmp    80079b <write+0x55>

008007c8 <seek>:

int
seek(int fdnum, off_t offset)
{
  8007c8:	55                   	push   %ebp
  8007c9:	89 e5                	mov    %esp,%ebp
  8007cb:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8007ce:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8007d1:	50                   	push   %eax
  8007d2:	ff 75 08             	pushl  0x8(%ebp)
  8007d5:	e8 2d fc ff ff       	call   800407 <fd_lookup>
  8007da:	83 c4 08             	add    $0x8,%esp
  8007dd:	85 c0                	test   %eax,%eax
  8007df:	78 0e                	js     8007ef <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8007e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8007e7:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8007ea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8007ef:	c9                   	leave  
  8007f0:	c3                   	ret    

008007f1 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8007f1:	55                   	push   %ebp
  8007f2:	89 e5                	mov    %esp,%ebp
  8007f4:	53                   	push   %ebx
  8007f5:	83 ec 14             	sub    $0x14,%esp
  8007f8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8007fb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8007fe:	50                   	push   %eax
  8007ff:	53                   	push   %ebx
  800800:	e8 02 fc ff ff       	call   800407 <fd_lookup>
  800805:	83 c4 08             	add    $0x8,%esp
  800808:	85 c0                	test   %eax,%eax
  80080a:	78 37                	js     800843 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80080c:	83 ec 08             	sub    $0x8,%esp
  80080f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800812:	50                   	push   %eax
  800813:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800816:	ff 30                	pushl  (%eax)
  800818:	e8 40 fc ff ff       	call   80045d <dev_lookup>
  80081d:	83 c4 10             	add    $0x10,%esp
  800820:	85 c0                	test   %eax,%eax
  800822:	78 1f                	js     800843 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800824:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800827:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80082b:	74 1b                	je     800848 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80082d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800830:	8b 52 18             	mov    0x18(%edx),%edx
  800833:	85 d2                	test   %edx,%edx
  800835:	74 32                	je     800869 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  800837:	83 ec 08             	sub    $0x8,%esp
  80083a:	ff 75 0c             	pushl  0xc(%ebp)
  80083d:	50                   	push   %eax
  80083e:	ff d2                	call   *%edx
  800840:	83 c4 10             	add    $0x10,%esp
}
  800843:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800846:	c9                   	leave  
  800847:	c3                   	ret    
			thisenv->env_id, fdnum);
  800848:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80084d:	8b 40 48             	mov    0x48(%eax),%eax
  800850:	83 ec 04             	sub    $0x4,%esp
  800853:	53                   	push   %ebx
  800854:	50                   	push   %eax
  800855:	68 78 23 80 00       	push   $0x802378
  80085a:	e8 6c 0d 00 00       	call   8015cb <cprintf>
		return -E_INVAL;
  80085f:	83 c4 10             	add    $0x10,%esp
  800862:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800867:	eb da                	jmp    800843 <ftruncate+0x52>
		return -E_NOT_SUPP;
  800869:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80086e:	eb d3                	jmp    800843 <ftruncate+0x52>

00800870 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800870:	55                   	push   %ebp
  800871:	89 e5                	mov    %esp,%ebp
  800873:	53                   	push   %ebx
  800874:	83 ec 14             	sub    $0x14,%esp
  800877:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80087a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80087d:	50                   	push   %eax
  80087e:	ff 75 08             	pushl  0x8(%ebp)
  800881:	e8 81 fb ff ff       	call   800407 <fd_lookup>
  800886:	83 c4 08             	add    $0x8,%esp
  800889:	85 c0                	test   %eax,%eax
  80088b:	78 4b                	js     8008d8 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80088d:	83 ec 08             	sub    $0x8,%esp
  800890:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800893:	50                   	push   %eax
  800894:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800897:	ff 30                	pushl  (%eax)
  800899:	e8 bf fb ff ff       	call   80045d <dev_lookup>
  80089e:	83 c4 10             	add    $0x10,%esp
  8008a1:	85 c0                	test   %eax,%eax
  8008a3:	78 33                	js     8008d8 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8008a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008a8:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8008ac:	74 2f                	je     8008dd <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8008ae:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8008b1:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8008b8:	00 00 00 
	stat->st_isdir = 0;
  8008bb:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8008c2:	00 00 00 
	stat->st_dev = dev;
  8008c5:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8008cb:	83 ec 08             	sub    $0x8,%esp
  8008ce:	53                   	push   %ebx
  8008cf:	ff 75 f0             	pushl  -0x10(%ebp)
  8008d2:	ff 50 14             	call   *0x14(%eax)
  8008d5:	83 c4 10             	add    $0x10,%esp
}
  8008d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008db:	c9                   	leave  
  8008dc:	c3                   	ret    
		return -E_NOT_SUPP;
  8008dd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8008e2:	eb f4                	jmp    8008d8 <fstat+0x68>

008008e4 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8008e4:	55                   	push   %ebp
  8008e5:	89 e5                	mov    %esp,%ebp
  8008e7:	56                   	push   %esi
  8008e8:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8008e9:	83 ec 08             	sub    $0x8,%esp
  8008ec:	6a 00                	push   $0x0
  8008ee:	ff 75 08             	pushl  0x8(%ebp)
  8008f1:	e8 26 02 00 00       	call   800b1c <open>
  8008f6:	89 c3                	mov    %eax,%ebx
  8008f8:	83 c4 10             	add    $0x10,%esp
  8008fb:	85 c0                	test   %eax,%eax
  8008fd:	78 1b                	js     80091a <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8008ff:	83 ec 08             	sub    $0x8,%esp
  800902:	ff 75 0c             	pushl  0xc(%ebp)
  800905:	50                   	push   %eax
  800906:	e8 65 ff ff ff       	call   800870 <fstat>
  80090b:	89 c6                	mov    %eax,%esi
	close(fd);
  80090d:	89 1c 24             	mov    %ebx,(%esp)
  800910:	e8 27 fc ff ff       	call   80053c <close>
	return r;
  800915:	83 c4 10             	add    $0x10,%esp
  800918:	89 f3                	mov    %esi,%ebx
}
  80091a:	89 d8                	mov    %ebx,%eax
  80091c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80091f:	5b                   	pop    %ebx
  800920:	5e                   	pop    %esi
  800921:	5d                   	pop    %ebp
  800922:	c3                   	ret    

00800923 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800923:	55                   	push   %ebp
  800924:	89 e5                	mov    %esp,%ebp
  800926:	56                   	push   %esi
  800927:	53                   	push   %ebx
  800928:	89 c6                	mov    %eax,%esi
  80092a:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80092c:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  800933:	74 27                	je     80095c <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800935:	6a 07                	push   $0x7
  800937:	68 00 50 80 00       	push   $0x805000
  80093c:	56                   	push   %esi
  80093d:	ff 35 00 40 80 00    	pushl  0x804000
  800943:	e8 c6 16 00 00       	call   80200e <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  800948:	83 c4 0c             	add    $0xc,%esp
  80094b:	6a 00                	push   $0x0
  80094d:	53                   	push   %ebx
  80094e:	6a 00                	push   $0x0
  800950:	e8 50 16 00 00       	call   801fa5 <ipc_recv>
}
  800955:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800958:	5b                   	pop    %ebx
  800959:	5e                   	pop    %esi
  80095a:	5d                   	pop    %ebp
  80095b:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80095c:	83 ec 0c             	sub    $0xc,%esp
  80095f:	6a 01                	push   $0x1
  800961:	e8 01 17 00 00       	call   802067 <ipc_find_env>
  800966:	a3 00 40 80 00       	mov    %eax,0x804000
  80096b:	83 c4 10             	add    $0x10,%esp
  80096e:	eb c5                	jmp    800935 <fsipc+0x12>

00800970 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  800970:	55                   	push   %ebp
  800971:	89 e5                	mov    %esp,%ebp
  800973:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800976:	8b 45 08             	mov    0x8(%ebp),%eax
  800979:	8b 40 0c             	mov    0xc(%eax),%eax
  80097c:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  800981:	8b 45 0c             	mov    0xc(%ebp),%eax
  800984:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  800989:	ba 00 00 00 00       	mov    $0x0,%edx
  80098e:	b8 02 00 00 00       	mov    $0x2,%eax
  800993:	e8 8b ff ff ff       	call   800923 <fsipc>
}
  800998:	c9                   	leave  
  800999:	c3                   	ret    

0080099a <devfile_flush>:
{
  80099a:	55                   	push   %ebp
  80099b:	89 e5                	mov    %esp,%ebp
  80099d:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8009a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a3:	8b 40 0c             	mov    0xc(%eax),%eax
  8009a6:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8009ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8009b0:	b8 06 00 00 00       	mov    $0x6,%eax
  8009b5:	e8 69 ff ff ff       	call   800923 <fsipc>
}
  8009ba:	c9                   	leave  
  8009bb:	c3                   	ret    

008009bc <devfile_stat>:
{
  8009bc:	55                   	push   %ebp
  8009bd:	89 e5                	mov    %esp,%ebp
  8009bf:	53                   	push   %ebx
  8009c0:	83 ec 04             	sub    $0x4,%esp
  8009c3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8009c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c9:	8b 40 0c             	mov    0xc(%eax),%eax
  8009cc:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8009d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8009d6:	b8 05 00 00 00       	mov    $0x5,%eax
  8009db:	e8 43 ff ff ff       	call   800923 <fsipc>
  8009e0:	85 c0                	test   %eax,%eax
  8009e2:	78 2c                	js     800a10 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8009e4:	83 ec 08             	sub    $0x8,%esp
  8009e7:	68 00 50 80 00       	push   $0x805000
  8009ec:	53                   	push   %ebx
  8009ed:	e8 76 12 00 00       	call   801c68 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8009f2:	a1 80 50 80 00       	mov    0x805080,%eax
  8009f7:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8009fd:	a1 84 50 80 00       	mov    0x805084,%eax
  800a02:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800a08:	83 c4 10             	add    $0x10,%esp
  800a0b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a10:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a13:	c9                   	leave  
  800a14:	c3                   	ret    

00800a15 <devfile_write>:
{
  800a15:	55                   	push   %ebp
  800a16:	89 e5                	mov    %esp,%ebp
  800a18:	53                   	push   %ebx
  800a19:	83 ec 04             	sub    $0x4,%esp
  800a1c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  800a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a22:	8b 40 0c             	mov    0xc(%eax),%eax
  800a25:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  800a2a:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  800a30:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  800a36:	77 30                	ja     800a68 <devfile_write+0x53>
	memmove(fsipcbuf.write.req_buf, buf, n);
  800a38:	83 ec 04             	sub    $0x4,%esp
  800a3b:	53                   	push   %ebx
  800a3c:	ff 75 0c             	pushl  0xc(%ebp)
  800a3f:	68 08 50 80 00       	push   $0x805008
  800a44:	e8 ad 13 00 00       	call   801df6 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  800a49:	ba 00 00 00 00       	mov    $0x0,%edx
  800a4e:	b8 04 00 00 00       	mov    $0x4,%eax
  800a53:	e8 cb fe ff ff       	call   800923 <fsipc>
  800a58:	83 c4 10             	add    $0x10,%esp
  800a5b:	85 c0                	test   %eax,%eax
  800a5d:	78 04                	js     800a63 <devfile_write+0x4e>
	assert(r <= n);
  800a5f:	39 d8                	cmp    %ebx,%eax
  800a61:	77 1e                	ja     800a81 <devfile_write+0x6c>
}
  800a63:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a66:	c9                   	leave  
  800a67:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  800a68:	68 e8 23 80 00       	push   $0x8023e8
  800a6d:	68 15 24 80 00       	push   $0x802415
  800a72:	68 94 00 00 00       	push   $0x94
  800a77:	68 2a 24 80 00       	push   $0x80242a
  800a7c:	e8 6f 0a 00 00       	call   8014f0 <_panic>
	assert(r <= n);
  800a81:	68 35 24 80 00       	push   $0x802435
  800a86:	68 15 24 80 00       	push   $0x802415
  800a8b:	68 98 00 00 00       	push   $0x98
  800a90:	68 2a 24 80 00       	push   $0x80242a
  800a95:	e8 56 0a 00 00       	call   8014f0 <_panic>

00800a9a <devfile_read>:
{
  800a9a:	55                   	push   %ebp
  800a9b:	89 e5                	mov    %esp,%ebp
  800a9d:	56                   	push   %esi
  800a9e:	53                   	push   %ebx
  800a9f:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa5:	8b 40 0c             	mov    0xc(%eax),%eax
  800aa8:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800aad:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800ab3:	ba 00 00 00 00       	mov    $0x0,%edx
  800ab8:	b8 03 00 00 00       	mov    $0x3,%eax
  800abd:	e8 61 fe ff ff       	call   800923 <fsipc>
  800ac2:	89 c3                	mov    %eax,%ebx
  800ac4:	85 c0                	test   %eax,%eax
  800ac6:	78 1f                	js     800ae7 <devfile_read+0x4d>
	assert(r <= n);
  800ac8:	39 f0                	cmp    %esi,%eax
  800aca:	77 24                	ja     800af0 <devfile_read+0x56>
	assert(r <= PGSIZE);
  800acc:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800ad1:	7f 33                	jg     800b06 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800ad3:	83 ec 04             	sub    $0x4,%esp
  800ad6:	50                   	push   %eax
  800ad7:	68 00 50 80 00       	push   $0x805000
  800adc:	ff 75 0c             	pushl  0xc(%ebp)
  800adf:	e8 12 13 00 00       	call   801df6 <memmove>
	return r;
  800ae4:	83 c4 10             	add    $0x10,%esp
}
  800ae7:	89 d8                	mov    %ebx,%eax
  800ae9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800aec:	5b                   	pop    %ebx
  800aed:	5e                   	pop    %esi
  800aee:	5d                   	pop    %ebp
  800aef:	c3                   	ret    
	assert(r <= n);
  800af0:	68 35 24 80 00       	push   $0x802435
  800af5:	68 15 24 80 00       	push   $0x802415
  800afa:	6a 7c                	push   $0x7c
  800afc:	68 2a 24 80 00       	push   $0x80242a
  800b01:	e8 ea 09 00 00       	call   8014f0 <_panic>
	assert(r <= PGSIZE);
  800b06:	68 3c 24 80 00       	push   $0x80243c
  800b0b:	68 15 24 80 00       	push   $0x802415
  800b10:	6a 7d                	push   $0x7d
  800b12:	68 2a 24 80 00       	push   $0x80242a
  800b17:	e8 d4 09 00 00       	call   8014f0 <_panic>

00800b1c <open>:
{
  800b1c:	55                   	push   %ebp
  800b1d:	89 e5                	mov    %esp,%ebp
  800b1f:	56                   	push   %esi
  800b20:	53                   	push   %ebx
  800b21:	83 ec 1c             	sub    $0x1c,%esp
  800b24:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800b27:	56                   	push   %esi
  800b28:	e8 04 11 00 00       	call   801c31 <strlen>
  800b2d:	83 c4 10             	add    $0x10,%esp
  800b30:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800b35:	7f 6c                	jg     800ba3 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  800b37:	83 ec 0c             	sub    $0xc,%esp
  800b3a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800b3d:	50                   	push   %eax
  800b3e:	e8 75 f8 ff ff       	call   8003b8 <fd_alloc>
  800b43:	89 c3                	mov    %eax,%ebx
  800b45:	83 c4 10             	add    $0x10,%esp
  800b48:	85 c0                	test   %eax,%eax
  800b4a:	78 3c                	js     800b88 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  800b4c:	83 ec 08             	sub    $0x8,%esp
  800b4f:	56                   	push   %esi
  800b50:	68 00 50 80 00       	push   $0x805000
  800b55:	e8 0e 11 00 00       	call   801c68 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800b5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5d:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800b62:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b65:	b8 01 00 00 00       	mov    $0x1,%eax
  800b6a:	e8 b4 fd ff ff       	call   800923 <fsipc>
  800b6f:	89 c3                	mov    %eax,%ebx
  800b71:	83 c4 10             	add    $0x10,%esp
  800b74:	85 c0                	test   %eax,%eax
  800b76:	78 19                	js     800b91 <open+0x75>
	return fd2num(fd);
  800b78:	83 ec 0c             	sub    $0xc,%esp
  800b7b:	ff 75 f4             	pushl  -0xc(%ebp)
  800b7e:	e8 0e f8 ff ff       	call   800391 <fd2num>
  800b83:	89 c3                	mov    %eax,%ebx
  800b85:	83 c4 10             	add    $0x10,%esp
}
  800b88:	89 d8                	mov    %ebx,%eax
  800b8a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b8d:	5b                   	pop    %ebx
  800b8e:	5e                   	pop    %esi
  800b8f:	5d                   	pop    %ebp
  800b90:	c3                   	ret    
		fd_close(fd, 0);
  800b91:	83 ec 08             	sub    $0x8,%esp
  800b94:	6a 00                	push   $0x0
  800b96:	ff 75 f4             	pushl  -0xc(%ebp)
  800b99:	e8 15 f9 ff ff       	call   8004b3 <fd_close>
		return r;
  800b9e:	83 c4 10             	add    $0x10,%esp
  800ba1:	eb e5                	jmp    800b88 <open+0x6c>
		return -E_BAD_PATH;
  800ba3:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800ba8:	eb de                	jmp    800b88 <open+0x6c>

00800baa <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800baa:	55                   	push   %ebp
  800bab:	89 e5                	mov    %esp,%ebp
  800bad:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800bb0:	ba 00 00 00 00       	mov    $0x0,%edx
  800bb5:	b8 08 00 00 00       	mov    $0x8,%eax
  800bba:	e8 64 fd ff ff       	call   800923 <fsipc>
}
  800bbf:	c9                   	leave  
  800bc0:	c3                   	ret    

00800bc1 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800bc1:	55                   	push   %ebp
  800bc2:	89 e5                	mov    %esp,%ebp
  800bc4:	56                   	push   %esi
  800bc5:	53                   	push   %ebx
  800bc6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800bc9:	83 ec 0c             	sub    $0xc,%esp
  800bcc:	ff 75 08             	pushl  0x8(%ebp)
  800bcf:	e8 cd f7 ff ff       	call   8003a1 <fd2data>
  800bd4:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  800bd6:	83 c4 08             	add    $0x8,%esp
  800bd9:	68 48 24 80 00       	push   $0x802448
  800bde:	53                   	push   %ebx
  800bdf:	e8 84 10 00 00       	call   801c68 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  800be4:	8b 46 04             	mov    0x4(%esi),%eax
  800be7:	2b 06                	sub    (%esi),%eax
  800be9:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  800bef:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800bf6:	00 00 00 
	stat->st_dev = &devpipe;
  800bf9:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  800c00:	30 80 00 
	return 0;
}
  800c03:	b8 00 00 00 00       	mov    $0x0,%eax
  800c08:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c0b:	5b                   	pop    %ebx
  800c0c:	5e                   	pop    %esi
  800c0d:	5d                   	pop    %ebp
  800c0e:	c3                   	ret    

00800c0f <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  800c0f:	55                   	push   %ebp
  800c10:	89 e5                	mov    %esp,%ebp
  800c12:	53                   	push   %ebx
  800c13:	83 ec 0c             	sub    $0xc,%esp
  800c16:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  800c19:	53                   	push   %ebx
  800c1a:	6a 00                	push   $0x0
  800c1c:	e8 e5 f5 ff ff       	call   800206 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  800c21:	89 1c 24             	mov    %ebx,(%esp)
  800c24:	e8 78 f7 ff ff       	call   8003a1 <fd2data>
  800c29:	83 c4 08             	add    $0x8,%esp
  800c2c:	50                   	push   %eax
  800c2d:	6a 00                	push   $0x0
  800c2f:	e8 d2 f5 ff ff       	call   800206 <sys_page_unmap>
}
  800c34:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c37:	c9                   	leave  
  800c38:	c3                   	ret    

00800c39 <_pipeisclosed>:
{
  800c39:	55                   	push   %ebp
  800c3a:	89 e5                	mov    %esp,%ebp
  800c3c:	57                   	push   %edi
  800c3d:	56                   	push   %esi
  800c3e:	53                   	push   %ebx
  800c3f:	83 ec 1c             	sub    $0x1c,%esp
  800c42:	89 c7                	mov    %eax,%edi
  800c44:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  800c46:	a1 08 40 80 00       	mov    0x804008,%eax
  800c4b:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  800c4e:	83 ec 0c             	sub    $0xc,%esp
  800c51:	57                   	push   %edi
  800c52:	e8 49 14 00 00       	call   8020a0 <pageref>
  800c57:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c5a:	89 34 24             	mov    %esi,(%esp)
  800c5d:	e8 3e 14 00 00       	call   8020a0 <pageref>
		nn = thisenv->env_runs;
  800c62:	8b 15 08 40 80 00    	mov    0x804008,%edx
  800c68:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  800c6b:	83 c4 10             	add    $0x10,%esp
  800c6e:	39 cb                	cmp    %ecx,%ebx
  800c70:	74 1b                	je     800c8d <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  800c72:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800c75:	75 cf                	jne    800c46 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  800c77:	8b 42 58             	mov    0x58(%edx),%eax
  800c7a:	6a 01                	push   $0x1
  800c7c:	50                   	push   %eax
  800c7d:	53                   	push   %ebx
  800c7e:	68 4f 24 80 00       	push   $0x80244f
  800c83:	e8 43 09 00 00       	call   8015cb <cprintf>
  800c88:	83 c4 10             	add    $0x10,%esp
  800c8b:	eb b9                	jmp    800c46 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  800c8d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800c90:	0f 94 c0             	sete   %al
  800c93:	0f b6 c0             	movzbl %al,%eax
}
  800c96:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c99:	5b                   	pop    %ebx
  800c9a:	5e                   	pop    %esi
  800c9b:	5f                   	pop    %edi
  800c9c:	5d                   	pop    %ebp
  800c9d:	c3                   	ret    

00800c9e <devpipe_write>:
{
  800c9e:	55                   	push   %ebp
  800c9f:	89 e5                	mov    %esp,%ebp
  800ca1:	57                   	push   %edi
  800ca2:	56                   	push   %esi
  800ca3:	53                   	push   %ebx
  800ca4:	83 ec 28             	sub    $0x28,%esp
  800ca7:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  800caa:	56                   	push   %esi
  800cab:	e8 f1 f6 ff ff       	call   8003a1 <fd2data>
  800cb0:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800cb2:	83 c4 10             	add    $0x10,%esp
  800cb5:	bf 00 00 00 00       	mov    $0x0,%edi
  800cba:	3b 7d 10             	cmp    0x10(%ebp),%edi
  800cbd:	74 4f                	je     800d0e <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  800cbf:	8b 43 04             	mov    0x4(%ebx),%eax
  800cc2:	8b 0b                	mov    (%ebx),%ecx
  800cc4:	8d 51 20             	lea    0x20(%ecx),%edx
  800cc7:	39 d0                	cmp    %edx,%eax
  800cc9:	72 14                	jb     800cdf <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  800ccb:	89 da                	mov    %ebx,%edx
  800ccd:	89 f0                	mov    %esi,%eax
  800ccf:	e8 65 ff ff ff       	call   800c39 <_pipeisclosed>
  800cd4:	85 c0                	test   %eax,%eax
  800cd6:	75 3a                	jne    800d12 <devpipe_write+0x74>
			sys_yield();
  800cd8:	e8 85 f4 ff ff       	call   800162 <sys_yield>
  800cdd:	eb e0                	jmp    800cbf <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  800cdf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ce2:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  800ce6:	88 4d e7             	mov    %cl,-0x19(%ebp)
  800ce9:	89 c2                	mov    %eax,%edx
  800ceb:	c1 fa 1f             	sar    $0x1f,%edx
  800cee:	89 d1                	mov    %edx,%ecx
  800cf0:	c1 e9 1b             	shr    $0x1b,%ecx
  800cf3:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  800cf6:	83 e2 1f             	and    $0x1f,%edx
  800cf9:	29 ca                	sub    %ecx,%edx
  800cfb:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  800cff:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  800d03:	83 c0 01             	add    $0x1,%eax
  800d06:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  800d09:	83 c7 01             	add    $0x1,%edi
  800d0c:	eb ac                	jmp    800cba <devpipe_write+0x1c>
	return i;
  800d0e:	89 f8                	mov    %edi,%eax
  800d10:	eb 05                	jmp    800d17 <devpipe_write+0x79>
				return 0;
  800d12:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d17:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d1a:	5b                   	pop    %ebx
  800d1b:	5e                   	pop    %esi
  800d1c:	5f                   	pop    %edi
  800d1d:	5d                   	pop    %ebp
  800d1e:	c3                   	ret    

00800d1f <devpipe_read>:
{
  800d1f:	55                   	push   %ebp
  800d20:	89 e5                	mov    %esp,%ebp
  800d22:	57                   	push   %edi
  800d23:	56                   	push   %esi
  800d24:	53                   	push   %ebx
  800d25:	83 ec 18             	sub    $0x18,%esp
  800d28:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  800d2b:	57                   	push   %edi
  800d2c:	e8 70 f6 ff ff       	call   8003a1 <fd2data>
  800d31:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800d33:	83 c4 10             	add    $0x10,%esp
  800d36:	be 00 00 00 00       	mov    $0x0,%esi
  800d3b:	3b 75 10             	cmp    0x10(%ebp),%esi
  800d3e:	74 47                	je     800d87 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  800d40:	8b 03                	mov    (%ebx),%eax
  800d42:	3b 43 04             	cmp    0x4(%ebx),%eax
  800d45:	75 22                	jne    800d69 <devpipe_read+0x4a>
			if (i > 0)
  800d47:	85 f6                	test   %esi,%esi
  800d49:	75 14                	jne    800d5f <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  800d4b:	89 da                	mov    %ebx,%edx
  800d4d:	89 f8                	mov    %edi,%eax
  800d4f:	e8 e5 fe ff ff       	call   800c39 <_pipeisclosed>
  800d54:	85 c0                	test   %eax,%eax
  800d56:	75 33                	jne    800d8b <devpipe_read+0x6c>
			sys_yield();
  800d58:	e8 05 f4 ff ff       	call   800162 <sys_yield>
  800d5d:	eb e1                	jmp    800d40 <devpipe_read+0x21>
				return i;
  800d5f:	89 f0                	mov    %esi,%eax
}
  800d61:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d64:	5b                   	pop    %ebx
  800d65:	5e                   	pop    %esi
  800d66:	5f                   	pop    %edi
  800d67:	5d                   	pop    %ebp
  800d68:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  800d69:	99                   	cltd   
  800d6a:	c1 ea 1b             	shr    $0x1b,%edx
  800d6d:	01 d0                	add    %edx,%eax
  800d6f:	83 e0 1f             	and    $0x1f,%eax
  800d72:	29 d0                	sub    %edx,%eax
  800d74:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  800d79:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d7c:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  800d7f:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  800d82:	83 c6 01             	add    $0x1,%esi
  800d85:	eb b4                	jmp    800d3b <devpipe_read+0x1c>
	return i;
  800d87:	89 f0                	mov    %esi,%eax
  800d89:	eb d6                	jmp    800d61 <devpipe_read+0x42>
				return 0;
  800d8b:	b8 00 00 00 00       	mov    $0x0,%eax
  800d90:	eb cf                	jmp    800d61 <devpipe_read+0x42>

00800d92 <pipe>:
{
  800d92:	55                   	push   %ebp
  800d93:	89 e5                	mov    %esp,%ebp
  800d95:	56                   	push   %esi
  800d96:	53                   	push   %ebx
  800d97:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  800d9a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800d9d:	50                   	push   %eax
  800d9e:	e8 15 f6 ff ff       	call   8003b8 <fd_alloc>
  800da3:	89 c3                	mov    %eax,%ebx
  800da5:	83 c4 10             	add    $0x10,%esp
  800da8:	85 c0                	test   %eax,%eax
  800daa:	78 5b                	js     800e07 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800dac:	83 ec 04             	sub    $0x4,%esp
  800daf:	68 07 04 00 00       	push   $0x407
  800db4:	ff 75 f4             	pushl  -0xc(%ebp)
  800db7:	6a 00                	push   $0x0
  800db9:	e8 c3 f3 ff ff       	call   800181 <sys_page_alloc>
  800dbe:	89 c3                	mov    %eax,%ebx
  800dc0:	83 c4 10             	add    $0x10,%esp
  800dc3:	85 c0                	test   %eax,%eax
  800dc5:	78 40                	js     800e07 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  800dc7:	83 ec 0c             	sub    $0xc,%esp
  800dca:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800dcd:	50                   	push   %eax
  800dce:	e8 e5 f5 ff ff       	call   8003b8 <fd_alloc>
  800dd3:	89 c3                	mov    %eax,%ebx
  800dd5:	83 c4 10             	add    $0x10,%esp
  800dd8:	85 c0                	test   %eax,%eax
  800dda:	78 1b                	js     800df7 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800ddc:	83 ec 04             	sub    $0x4,%esp
  800ddf:	68 07 04 00 00       	push   $0x407
  800de4:	ff 75 f0             	pushl  -0x10(%ebp)
  800de7:	6a 00                	push   $0x0
  800de9:	e8 93 f3 ff ff       	call   800181 <sys_page_alloc>
  800dee:	89 c3                	mov    %eax,%ebx
  800df0:	83 c4 10             	add    $0x10,%esp
  800df3:	85 c0                	test   %eax,%eax
  800df5:	79 19                	jns    800e10 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  800df7:	83 ec 08             	sub    $0x8,%esp
  800dfa:	ff 75 f4             	pushl  -0xc(%ebp)
  800dfd:	6a 00                	push   $0x0
  800dff:	e8 02 f4 ff ff       	call   800206 <sys_page_unmap>
  800e04:	83 c4 10             	add    $0x10,%esp
}
  800e07:	89 d8                	mov    %ebx,%eax
  800e09:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800e0c:	5b                   	pop    %ebx
  800e0d:	5e                   	pop    %esi
  800e0e:	5d                   	pop    %ebp
  800e0f:	c3                   	ret    
	va = fd2data(fd0);
  800e10:	83 ec 0c             	sub    $0xc,%esp
  800e13:	ff 75 f4             	pushl  -0xc(%ebp)
  800e16:	e8 86 f5 ff ff       	call   8003a1 <fd2data>
  800e1b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e1d:	83 c4 0c             	add    $0xc,%esp
  800e20:	68 07 04 00 00       	push   $0x407
  800e25:	50                   	push   %eax
  800e26:	6a 00                	push   $0x0
  800e28:	e8 54 f3 ff ff       	call   800181 <sys_page_alloc>
  800e2d:	89 c3                	mov    %eax,%ebx
  800e2f:	83 c4 10             	add    $0x10,%esp
  800e32:	85 c0                	test   %eax,%eax
  800e34:	0f 88 8c 00 00 00    	js     800ec6 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e3a:	83 ec 0c             	sub    $0xc,%esp
  800e3d:	ff 75 f0             	pushl  -0x10(%ebp)
  800e40:	e8 5c f5 ff ff       	call   8003a1 <fd2data>
  800e45:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  800e4c:	50                   	push   %eax
  800e4d:	6a 00                	push   $0x0
  800e4f:	56                   	push   %esi
  800e50:	6a 00                	push   $0x0
  800e52:	e8 6d f3 ff ff       	call   8001c4 <sys_page_map>
  800e57:	89 c3                	mov    %eax,%ebx
  800e59:	83 c4 20             	add    $0x20,%esp
  800e5c:	85 c0                	test   %eax,%eax
  800e5e:	78 58                	js     800eb8 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  800e60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e63:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800e69:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  800e6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e6e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  800e75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e78:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800e7e:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  800e80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e83:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  800e8a:	83 ec 0c             	sub    $0xc,%esp
  800e8d:	ff 75 f4             	pushl  -0xc(%ebp)
  800e90:	e8 fc f4 ff ff       	call   800391 <fd2num>
  800e95:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e98:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  800e9a:	83 c4 04             	add    $0x4,%esp
  800e9d:	ff 75 f0             	pushl  -0x10(%ebp)
  800ea0:	e8 ec f4 ff ff       	call   800391 <fd2num>
  800ea5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ea8:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  800eab:	83 c4 10             	add    $0x10,%esp
  800eae:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eb3:	e9 4f ff ff ff       	jmp    800e07 <pipe+0x75>
	sys_page_unmap(0, va);
  800eb8:	83 ec 08             	sub    $0x8,%esp
  800ebb:	56                   	push   %esi
  800ebc:	6a 00                	push   $0x0
  800ebe:	e8 43 f3 ff ff       	call   800206 <sys_page_unmap>
  800ec3:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  800ec6:	83 ec 08             	sub    $0x8,%esp
  800ec9:	ff 75 f0             	pushl  -0x10(%ebp)
  800ecc:	6a 00                	push   $0x0
  800ece:	e8 33 f3 ff ff       	call   800206 <sys_page_unmap>
  800ed3:	83 c4 10             	add    $0x10,%esp
  800ed6:	e9 1c ff ff ff       	jmp    800df7 <pipe+0x65>

00800edb <pipeisclosed>:
{
  800edb:	55                   	push   %ebp
  800edc:	89 e5                	mov    %esp,%ebp
  800ede:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800ee1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800ee4:	50                   	push   %eax
  800ee5:	ff 75 08             	pushl  0x8(%ebp)
  800ee8:	e8 1a f5 ff ff       	call   800407 <fd_lookup>
  800eed:	83 c4 10             	add    $0x10,%esp
  800ef0:	85 c0                	test   %eax,%eax
  800ef2:	78 18                	js     800f0c <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  800ef4:	83 ec 0c             	sub    $0xc,%esp
  800ef7:	ff 75 f4             	pushl  -0xc(%ebp)
  800efa:	e8 a2 f4 ff ff       	call   8003a1 <fd2data>
	return _pipeisclosed(fd, p);
  800eff:	89 c2                	mov    %eax,%edx
  800f01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f04:	e8 30 fd ff ff       	call   800c39 <_pipeisclosed>
  800f09:	83 c4 10             	add    $0x10,%esp
}
  800f0c:	c9                   	leave  
  800f0d:	c3                   	ret    

00800f0e <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  800f0e:	55                   	push   %ebp
  800f0f:	89 e5                	mov    %esp,%ebp
  800f11:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  800f14:	68 67 24 80 00       	push   $0x802467
  800f19:	ff 75 0c             	pushl  0xc(%ebp)
  800f1c:	e8 47 0d 00 00       	call   801c68 <strcpy>
	return 0;
}
  800f21:	b8 00 00 00 00       	mov    $0x0,%eax
  800f26:	c9                   	leave  
  800f27:	c3                   	ret    

00800f28 <devsock_close>:
{
  800f28:	55                   	push   %ebp
  800f29:	89 e5                	mov    %esp,%ebp
  800f2b:	53                   	push   %ebx
  800f2c:	83 ec 10             	sub    $0x10,%esp
  800f2f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  800f32:	53                   	push   %ebx
  800f33:	e8 68 11 00 00       	call   8020a0 <pageref>
  800f38:	83 c4 10             	add    $0x10,%esp
		return 0;
  800f3b:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  800f40:	83 f8 01             	cmp    $0x1,%eax
  800f43:	74 07                	je     800f4c <devsock_close+0x24>
}
  800f45:	89 d0                	mov    %edx,%eax
  800f47:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f4a:	c9                   	leave  
  800f4b:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  800f4c:	83 ec 0c             	sub    $0xc,%esp
  800f4f:	ff 73 0c             	pushl  0xc(%ebx)
  800f52:	e8 b7 02 00 00       	call   80120e <nsipc_close>
  800f57:	89 c2                	mov    %eax,%edx
  800f59:	83 c4 10             	add    $0x10,%esp
  800f5c:	eb e7                	jmp    800f45 <devsock_close+0x1d>

00800f5e <devsock_write>:
{
  800f5e:	55                   	push   %ebp
  800f5f:	89 e5                	mov    %esp,%ebp
  800f61:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  800f64:	6a 00                	push   $0x0
  800f66:	ff 75 10             	pushl  0x10(%ebp)
  800f69:	ff 75 0c             	pushl  0xc(%ebp)
  800f6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6f:	ff 70 0c             	pushl  0xc(%eax)
  800f72:	e8 74 03 00 00       	call   8012eb <nsipc_send>
}
  800f77:	c9                   	leave  
  800f78:	c3                   	ret    

00800f79 <devsock_read>:
{
  800f79:	55                   	push   %ebp
  800f7a:	89 e5                	mov    %esp,%ebp
  800f7c:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  800f7f:	6a 00                	push   $0x0
  800f81:	ff 75 10             	pushl  0x10(%ebp)
  800f84:	ff 75 0c             	pushl  0xc(%ebp)
  800f87:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8a:	ff 70 0c             	pushl  0xc(%eax)
  800f8d:	e8 ed 02 00 00       	call   80127f <nsipc_recv>
}
  800f92:	c9                   	leave  
  800f93:	c3                   	ret    

00800f94 <fd2sockid>:
{
  800f94:	55                   	push   %ebp
  800f95:	89 e5                	mov    %esp,%ebp
  800f97:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  800f9a:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800f9d:	52                   	push   %edx
  800f9e:	50                   	push   %eax
  800f9f:	e8 63 f4 ff ff       	call   800407 <fd_lookup>
  800fa4:	83 c4 10             	add    $0x10,%esp
  800fa7:	85 c0                	test   %eax,%eax
  800fa9:	78 10                	js     800fbb <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  800fab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fae:	8b 0d 3c 30 80 00    	mov    0x80303c,%ecx
  800fb4:	39 08                	cmp    %ecx,(%eax)
  800fb6:	75 05                	jne    800fbd <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  800fb8:	8b 40 0c             	mov    0xc(%eax),%eax
}
  800fbb:	c9                   	leave  
  800fbc:	c3                   	ret    
		return -E_NOT_SUPP;
  800fbd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800fc2:	eb f7                	jmp    800fbb <fd2sockid+0x27>

00800fc4 <alloc_sockfd>:
{
  800fc4:	55                   	push   %ebp
  800fc5:	89 e5                	mov    %esp,%ebp
  800fc7:	56                   	push   %esi
  800fc8:	53                   	push   %ebx
  800fc9:	83 ec 1c             	sub    $0x1c,%esp
  800fcc:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  800fce:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800fd1:	50                   	push   %eax
  800fd2:	e8 e1 f3 ff ff       	call   8003b8 <fd_alloc>
  800fd7:	89 c3                	mov    %eax,%ebx
  800fd9:	83 c4 10             	add    $0x10,%esp
  800fdc:	85 c0                	test   %eax,%eax
  800fde:	78 43                	js     801023 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  800fe0:	83 ec 04             	sub    $0x4,%esp
  800fe3:	68 07 04 00 00       	push   $0x407
  800fe8:	ff 75 f4             	pushl  -0xc(%ebp)
  800feb:	6a 00                	push   $0x0
  800fed:	e8 8f f1 ff ff       	call   800181 <sys_page_alloc>
  800ff2:	89 c3                	mov    %eax,%ebx
  800ff4:	83 c4 10             	add    $0x10,%esp
  800ff7:	85 c0                	test   %eax,%eax
  800ff9:	78 28                	js     801023 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  800ffb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ffe:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801004:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801006:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801009:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801010:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801013:	83 ec 0c             	sub    $0xc,%esp
  801016:	50                   	push   %eax
  801017:	e8 75 f3 ff ff       	call   800391 <fd2num>
  80101c:	89 c3                	mov    %eax,%ebx
  80101e:	83 c4 10             	add    $0x10,%esp
  801021:	eb 0c                	jmp    80102f <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801023:	83 ec 0c             	sub    $0xc,%esp
  801026:	56                   	push   %esi
  801027:	e8 e2 01 00 00       	call   80120e <nsipc_close>
		return r;
  80102c:	83 c4 10             	add    $0x10,%esp
}
  80102f:	89 d8                	mov    %ebx,%eax
  801031:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801034:	5b                   	pop    %ebx
  801035:	5e                   	pop    %esi
  801036:	5d                   	pop    %ebp
  801037:	c3                   	ret    

00801038 <accept>:
{
  801038:	55                   	push   %ebp
  801039:	89 e5                	mov    %esp,%ebp
  80103b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80103e:	8b 45 08             	mov    0x8(%ebp),%eax
  801041:	e8 4e ff ff ff       	call   800f94 <fd2sockid>
  801046:	85 c0                	test   %eax,%eax
  801048:	78 1b                	js     801065 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80104a:	83 ec 04             	sub    $0x4,%esp
  80104d:	ff 75 10             	pushl  0x10(%ebp)
  801050:	ff 75 0c             	pushl  0xc(%ebp)
  801053:	50                   	push   %eax
  801054:	e8 0e 01 00 00       	call   801167 <nsipc_accept>
  801059:	83 c4 10             	add    $0x10,%esp
  80105c:	85 c0                	test   %eax,%eax
  80105e:	78 05                	js     801065 <accept+0x2d>
	return alloc_sockfd(r);
  801060:	e8 5f ff ff ff       	call   800fc4 <alloc_sockfd>
}
  801065:	c9                   	leave  
  801066:	c3                   	ret    

00801067 <bind>:
{
  801067:	55                   	push   %ebp
  801068:	89 e5                	mov    %esp,%ebp
  80106a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80106d:	8b 45 08             	mov    0x8(%ebp),%eax
  801070:	e8 1f ff ff ff       	call   800f94 <fd2sockid>
  801075:	85 c0                	test   %eax,%eax
  801077:	78 12                	js     80108b <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801079:	83 ec 04             	sub    $0x4,%esp
  80107c:	ff 75 10             	pushl  0x10(%ebp)
  80107f:	ff 75 0c             	pushl  0xc(%ebp)
  801082:	50                   	push   %eax
  801083:	e8 2f 01 00 00       	call   8011b7 <nsipc_bind>
  801088:	83 c4 10             	add    $0x10,%esp
}
  80108b:	c9                   	leave  
  80108c:	c3                   	ret    

0080108d <shutdown>:
{
  80108d:	55                   	push   %ebp
  80108e:	89 e5                	mov    %esp,%ebp
  801090:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801093:	8b 45 08             	mov    0x8(%ebp),%eax
  801096:	e8 f9 fe ff ff       	call   800f94 <fd2sockid>
  80109b:	85 c0                	test   %eax,%eax
  80109d:	78 0f                	js     8010ae <shutdown+0x21>
	return nsipc_shutdown(r, how);
  80109f:	83 ec 08             	sub    $0x8,%esp
  8010a2:	ff 75 0c             	pushl  0xc(%ebp)
  8010a5:	50                   	push   %eax
  8010a6:	e8 41 01 00 00       	call   8011ec <nsipc_shutdown>
  8010ab:	83 c4 10             	add    $0x10,%esp
}
  8010ae:	c9                   	leave  
  8010af:	c3                   	ret    

008010b0 <connect>:
{
  8010b0:	55                   	push   %ebp
  8010b1:	89 e5                	mov    %esp,%ebp
  8010b3:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8010b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b9:	e8 d6 fe ff ff       	call   800f94 <fd2sockid>
  8010be:	85 c0                	test   %eax,%eax
  8010c0:	78 12                	js     8010d4 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8010c2:	83 ec 04             	sub    $0x4,%esp
  8010c5:	ff 75 10             	pushl  0x10(%ebp)
  8010c8:	ff 75 0c             	pushl  0xc(%ebp)
  8010cb:	50                   	push   %eax
  8010cc:	e8 57 01 00 00       	call   801228 <nsipc_connect>
  8010d1:	83 c4 10             	add    $0x10,%esp
}
  8010d4:	c9                   	leave  
  8010d5:	c3                   	ret    

008010d6 <listen>:
{
  8010d6:	55                   	push   %ebp
  8010d7:	89 e5                	mov    %esp,%ebp
  8010d9:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8010dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010df:	e8 b0 fe ff ff       	call   800f94 <fd2sockid>
  8010e4:	85 c0                	test   %eax,%eax
  8010e6:	78 0f                	js     8010f7 <listen+0x21>
	return nsipc_listen(r, backlog);
  8010e8:	83 ec 08             	sub    $0x8,%esp
  8010eb:	ff 75 0c             	pushl  0xc(%ebp)
  8010ee:	50                   	push   %eax
  8010ef:	e8 69 01 00 00       	call   80125d <nsipc_listen>
  8010f4:	83 c4 10             	add    $0x10,%esp
}
  8010f7:	c9                   	leave  
  8010f8:	c3                   	ret    

008010f9 <socket>:

int
socket(int domain, int type, int protocol)
{
  8010f9:	55                   	push   %ebp
  8010fa:	89 e5                	mov    %esp,%ebp
  8010fc:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8010ff:	ff 75 10             	pushl  0x10(%ebp)
  801102:	ff 75 0c             	pushl  0xc(%ebp)
  801105:	ff 75 08             	pushl  0x8(%ebp)
  801108:	e8 3c 02 00 00       	call   801349 <nsipc_socket>
  80110d:	83 c4 10             	add    $0x10,%esp
  801110:	85 c0                	test   %eax,%eax
  801112:	78 05                	js     801119 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801114:	e8 ab fe ff ff       	call   800fc4 <alloc_sockfd>
}
  801119:	c9                   	leave  
  80111a:	c3                   	ret    

0080111b <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80111b:	55                   	push   %ebp
  80111c:	89 e5                	mov    %esp,%ebp
  80111e:	53                   	push   %ebx
  80111f:	83 ec 04             	sub    $0x4,%esp
  801122:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801124:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  80112b:	74 26                	je     801153 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80112d:	6a 07                	push   $0x7
  80112f:	68 00 60 80 00       	push   $0x806000
  801134:	53                   	push   %ebx
  801135:	ff 35 04 40 80 00    	pushl  0x804004
  80113b:	e8 ce 0e 00 00       	call   80200e <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801140:	83 c4 0c             	add    $0xc,%esp
  801143:	6a 00                	push   $0x0
  801145:	6a 00                	push   $0x0
  801147:	6a 00                	push   $0x0
  801149:	e8 57 0e 00 00       	call   801fa5 <ipc_recv>
}
  80114e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801151:	c9                   	leave  
  801152:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801153:	83 ec 0c             	sub    $0xc,%esp
  801156:	6a 02                	push   $0x2
  801158:	e8 0a 0f 00 00       	call   802067 <ipc_find_env>
  80115d:	a3 04 40 80 00       	mov    %eax,0x804004
  801162:	83 c4 10             	add    $0x10,%esp
  801165:	eb c6                	jmp    80112d <nsipc+0x12>

00801167 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801167:	55                   	push   %ebp
  801168:	89 e5                	mov    %esp,%ebp
  80116a:	56                   	push   %esi
  80116b:	53                   	push   %ebx
  80116c:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  80116f:	8b 45 08             	mov    0x8(%ebp),%eax
  801172:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801177:	8b 06                	mov    (%esi),%eax
  801179:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80117e:	b8 01 00 00 00       	mov    $0x1,%eax
  801183:	e8 93 ff ff ff       	call   80111b <nsipc>
  801188:	89 c3                	mov    %eax,%ebx
  80118a:	85 c0                	test   %eax,%eax
  80118c:	78 20                	js     8011ae <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80118e:	83 ec 04             	sub    $0x4,%esp
  801191:	ff 35 10 60 80 00    	pushl  0x806010
  801197:	68 00 60 80 00       	push   $0x806000
  80119c:	ff 75 0c             	pushl  0xc(%ebp)
  80119f:	e8 52 0c 00 00       	call   801df6 <memmove>
		*addrlen = ret->ret_addrlen;
  8011a4:	a1 10 60 80 00       	mov    0x806010,%eax
  8011a9:	89 06                	mov    %eax,(%esi)
  8011ab:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  8011ae:	89 d8                	mov    %ebx,%eax
  8011b0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8011b3:	5b                   	pop    %ebx
  8011b4:	5e                   	pop    %esi
  8011b5:	5d                   	pop    %ebp
  8011b6:	c3                   	ret    

008011b7 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8011b7:	55                   	push   %ebp
  8011b8:	89 e5                	mov    %esp,%ebp
  8011ba:	53                   	push   %ebx
  8011bb:	83 ec 08             	sub    $0x8,%esp
  8011be:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8011c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c4:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8011c9:	53                   	push   %ebx
  8011ca:	ff 75 0c             	pushl  0xc(%ebp)
  8011cd:	68 04 60 80 00       	push   $0x806004
  8011d2:	e8 1f 0c 00 00       	call   801df6 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8011d7:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  8011dd:	b8 02 00 00 00       	mov    $0x2,%eax
  8011e2:	e8 34 ff ff ff       	call   80111b <nsipc>
}
  8011e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011ea:	c9                   	leave  
  8011eb:	c3                   	ret    

008011ec <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8011ec:	55                   	push   %ebp
  8011ed:	89 e5                	mov    %esp,%ebp
  8011ef:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8011f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f5:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  8011fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fd:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801202:	b8 03 00 00 00       	mov    $0x3,%eax
  801207:	e8 0f ff ff ff       	call   80111b <nsipc>
}
  80120c:	c9                   	leave  
  80120d:	c3                   	ret    

0080120e <nsipc_close>:

int
nsipc_close(int s)
{
  80120e:	55                   	push   %ebp
  80120f:	89 e5                	mov    %esp,%ebp
  801211:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801214:	8b 45 08             	mov    0x8(%ebp),%eax
  801217:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  80121c:	b8 04 00 00 00       	mov    $0x4,%eax
  801221:	e8 f5 fe ff ff       	call   80111b <nsipc>
}
  801226:	c9                   	leave  
  801227:	c3                   	ret    

00801228 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801228:	55                   	push   %ebp
  801229:	89 e5                	mov    %esp,%ebp
  80122b:	53                   	push   %ebx
  80122c:	83 ec 08             	sub    $0x8,%esp
  80122f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801232:	8b 45 08             	mov    0x8(%ebp),%eax
  801235:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80123a:	53                   	push   %ebx
  80123b:	ff 75 0c             	pushl  0xc(%ebp)
  80123e:	68 04 60 80 00       	push   $0x806004
  801243:	e8 ae 0b 00 00       	call   801df6 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801248:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  80124e:	b8 05 00 00 00       	mov    $0x5,%eax
  801253:	e8 c3 fe ff ff       	call   80111b <nsipc>
}
  801258:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80125b:	c9                   	leave  
  80125c:	c3                   	ret    

0080125d <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80125d:	55                   	push   %ebp
  80125e:	89 e5                	mov    %esp,%ebp
  801260:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801263:	8b 45 08             	mov    0x8(%ebp),%eax
  801266:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  80126b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80126e:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801273:	b8 06 00 00 00       	mov    $0x6,%eax
  801278:	e8 9e fe ff ff       	call   80111b <nsipc>
}
  80127d:	c9                   	leave  
  80127e:	c3                   	ret    

0080127f <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80127f:	55                   	push   %ebp
  801280:	89 e5                	mov    %esp,%ebp
  801282:	56                   	push   %esi
  801283:	53                   	push   %ebx
  801284:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801287:	8b 45 08             	mov    0x8(%ebp),%eax
  80128a:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  80128f:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801295:	8b 45 14             	mov    0x14(%ebp),%eax
  801298:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80129d:	b8 07 00 00 00       	mov    $0x7,%eax
  8012a2:	e8 74 fe ff ff       	call   80111b <nsipc>
  8012a7:	89 c3                	mov    %eax,%ebx
  8012a9:	85 c0                	test   %eax,%eax
  8012ab:	78 1f                	js     8012cc <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  8012ad:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8012b2:	7f 21                	jg     8012d5 <nsipc_recv+0x56>
  8012b4:	39 c6                	cmp    %eax,%esi
  8012b6:	7c 1d                	jl     8012d5 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8012b8:	83 ec 04             	sub    $0x4,%esp
  8012bb:	50                   	push   %eax
  8012bc:	68 00 60 80 00       	push   $0x806000
  8012c1:	ff 75 0c             	pushl  0xc(%ebp)
  8012c4:	e8 2d 0b 00 00       	call   801df6 <memmove>
  8012c9:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8012cc:	89 d8                	mov    %ebx,%eax
  8012ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012d1:	5b                   	pop    %ebx
  8012d2:	5e                   	pop    %esi
  8012d3:	5d                   	pop    %ebp
  8012d4:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8012d5:	68 73 24 80 00       	push   $0x802473
  8012da:	68 15 24 80 00       	push   $0x802415
  8012df:	6a 62                	push   $0x62
  8012e1:	68 88 24 80 00       	push   $0x802488
  8012e6:	e8 05 02 00 00       	call   8014f0 <_panic>

008012eb <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8012eb:	55                   	push   %ebp
  8012ec:	89 e5                	mov    %esp,%ebp
  8012ee:	53                   	push   %ebx
  8012ef:	83 ec 04             	sub    $0x4,%esp
  8012f2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8012f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f8:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  8012fd:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801303:	7f 2e                	jg     801333 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801305:	83 ec 04             	sub    $0x4,%esp
  801308:	53                   	push   %ebx
  801309:	ff 75 0c             	pushl  0xc(%ebp)
  80130c:	68 0c 60 80 00       	push   $0x80600c
  801311:	e8 e0 0a 00 00       	call   801df6 <memmove>
	nsipcbuf.send.req_size = size;
  801316:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  80131c:	8b 45 14             	mov    0x14(%ebp),%eax
  80131f:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801324:	b8 08 00 00 00       	mov    $0x8,%eax
  801329:	e8 ed fd ff ff       	call   80111b <nsipc>
}
  80132e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801331:	c9                   	leave  
  801332:	c3                   	ret    
	assert(size < 1600);
  801333:	68 94 24 80 00       	push   $0x802494
  801338:	68 15 24 80 00       	push   $0x802415
  80133d:	6a 6d                	push   $0x6d
  80133f:	68 88 24 80 00       	push   $0x802488
  801344:	e8 a7 01 00 00       	call   8014f0 <_panic>

00801349 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801349:	55                   	push   %ebp
  80134a:	89 e5                	mov    %esp,%ebp
  80134c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80134f:	8b 45 08             	mov    0x8(%ebp),%eax
  801352:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801357:	8b 45 0c             	mov    0xc(%ebp),%eax
  80135a:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  80135f:	8b 45 10             	mov    0x10(%ebp),%eax
  801362:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801367:	b8 09 00 00 00       	mov    $0x9,%eax
  80136c:	e8 aa fd ff ff       	call   80111b <nsipc>
}
  801371:	c9                   	leave  
  801372:	c3                   	ret    

00801373 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801373:	55                   	push   %ebp
  801374:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801376:	b8 00 00 00 00       	mov    $0x0,%eax
  80137b:	5d                   	pop    %ebp
  80137c:	c3                   	ret    

0080137d <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80137d:	55                   	push   %ebp
  80137e:	89 e5                	mov    %esp,%ebp
  801380:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801383:	68 a0 24 80 00       	push   $0x8024a0
  801388:	ff 75 0c             	pushl  0xc(%ebp)
  80138b:	e8 d8 08 00 00       	call   801c68 <strcpy>
	return 0;
}
  801390:	b8 00 00 00 00       	mov    $0x0,%eax
  801395:	c9                   	leave  
  801396:	c3                   	ret    

00801397 <devcons_write>:
{
  801397:	55                   	push   %ebp
  801398:	89 e5                	mov    %esp,%ebp
  80139a:	57                   	push   %edi
  80139b:	56                   	push   %esi
  80139c:	53                   	push   %ebx
  80139d:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8013a3:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8013a8:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8013ae:	eb 2f                	jmp    8013df <devcons_write+0x48>
		m = n - tot;
  8013b0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8013b3:	29 f3                	sub    %esi,%ebx
  8013b5:	83 fb 7f             	cmp    $0x7f,%ebx
  8013b8:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8013bd:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8013c0:	83 ec 04             	sub    $0x4,%esp
  8013c3:	53                   	push   %ebx
  8013c4:	89 f0                	mov    %esi,%eax
  8013c6:	03 45 0c             	add    0xc(%ebp),%eax
  8013c9:	50                   	push   %eax
  8013ca:	57                   	push   %edi
  8013cb:	e8 26 0a 00 00       	call   801df6 <memmove>
		sys_cputs(buf, m);
  8013d0:	83 c4 08             	add    $0x8,%esp
  8013d3:	53                   	push   %ebx
  8013d4:	57                   	push   %edi
  8013d5:	e8 eb ec ff ff       	call   8000c5 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8013da:	01 de                	add    %ebx,%esi
  8013dc:	83 c4 10             	add    $0x10,%esp
  8013df:	3b 75 10             	cmp    0x10(%ebp),%esi
  8013e2:	72 cc                	jb     8013b0 <devcons_write+0x19>
}
  8013e4:	89 f0                	mov    %esi,%eax
  8013e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013e9:	5b                   	pop    %ebx
  8013ea:	5e                   	pop    %esi
  8013eb:	5f                   	pop    %edi
  8013ec:	5d                   	pop    %ebp
  8013ed:	c3                   	ret    

008013ee <devcons_read>:
{
  8013ee:	55                   	push   %ebp
  8013ef:	89 e5                	mov    %esp,%ebp
  8013f1:	83 ec 08             	sub    $0x8,%esp
  8013f4:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8013f9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013fd:	75 07                	jne    801406 <devcons_read+0x18>
}
  8013ff:	c9                   	leave  
  801400:	c3                   	ret    
		sys_yield();
  801401:	e8 5c ed ff ff       	call   800162 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801406:	e8 d8 ec ff ff       	call   8000e3 <sys_cgetc>
  80140b:	85 c0                	test   %eax,%eax
  80140d:	74 f2                	je     801401 <devcons_read+0x13>
	if (c < 0)
  80140f:	85 c0                	test   %eax,%eax
  801411:	78 ec                	js     8013ff <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  801413:	83 f8 04             	cmp    $0x4,%eax
  801416:	74 0c                	je     801424 <devcons_read+0x36>
	*(char*)vbuf = c;
  801418:	8b 55 0c             	mov    0xc(%ebp),%edx
  80141b:	88 02                	mov    %al,(%edx)
	return 1;
  80141d:	b8 01 00 00 00       	mov    $0x1,%eax
  801422:	eb db                	jmp    8013ff <devcons_read+0x11>
		return 0;
  801424:	b8 00 00 00 00       	mov    $0x0,%eax
  801429:	eb d4                	jmp    8013ff <devcons_read+0x11>

0080142b <cputchar>:
{
  80142b:	55                   	push   %ebp
  80142c:	89 e5                	mov    %esp,%ebp
  80142e:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801431:	8b 45 08             	mov    0x8(%ebp),%eax
  801434:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801437:	6a 01                	push   $0x1
  801439:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80143c:	50                   	push   %eax
  80143d:	e8 83 ec ff ff       	call   8000c5 <sys_cputs>
}
  801442:	83 c4 10             	add    $0x10,%esp
  801445:	c9                   	leave  
  801446:	c3                   	ret    

00801447 <getchar>:
{
  801447:	55                   	push   %ebp
  801448:	89 e5                	mov    %esp,%ebp
  80144a:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80144d:	6a 01                	push   $0x1
  80144f:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801452:	50                   	push   %eax
  801453:	6a 00                	push   $0x0
  801455:	e8 1e f2 ff ff       	call   800678 <read>
	if (r < 0)
  80145a:	83 c4 10             	add    $0x10,%esp
  80145d:	85 c0                	test   %eax,%eax
  80145f:	78 08                	js     801469 <getchar+0x22>
	if (r < 1)
  801461:	85 c0                	test   %eax,%eax
  801463:	7e 06                	jle    80146b <getchar+0x24>
	return c;
  801465:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801469:	c9                   	leave  
  80146a:	c3                   	ret    
		return -E_EOF;
  80146b:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801470:	eb f7                	jmp    801469 <getchar+0x22>

00801472 <iscons>:
{
  801472:	55                   	push   %ebp
  801473:	89 e5                	mov    %esp,%ebp
  801475:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801478:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80147b:	50                   	push   %eax
  80147c:	ff 75 08             	pushl  0x8(%ebp)
  80147f:	e8 83 ef ff ff       	call   800407 <fd_lookup>
  801484:	83 c4 10             	add    $0x10,%esp
  801487:	85 c0                	test   %eax,%eax
  801489:	78 11                	js     80149c <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80148b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80148e:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801494:	39 10                	cmp    %edx,(%eax)
  801496:	0f 94 c0             	sete   %al
  801499:	0f b6 c0             	movzbl %al,%eax
}
  80149c:	c9                   	leave  
  80149d:	c3                   	ret    

0080149e <opencons>:
{
  80149e:	55                   	push   %ebp
  80149f:	89 e5                	mov    %esp,%ebp
  8014a1:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8014a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014a7:	50                   	push   %eax
  8014a8:	e8 0b ef ff ff       	call   8003b8 <fd_alloc>
  8014ad:	83 c4 10             	add    $0x10,%esp
  8014b0:	85 c0                	test   %eax,%eax
  8014b2:	78 3a                	js     8014ee <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8014b4:	83 ec 04             	sub    $0x4,%esp
  8014b7:	68 07 04 00 00       	push   $0x407
  8014bc:	ff 75 f4             	pushl  -0xc(%ebp)
  8014bf:	6a 00                	push   $0x0
  8014c1:	e8 bb ec ff ff       	call   800181 <sys_page_alloc>
  8014c6:	83 c4 10             	add    $0x10,%esp
  8014c9:	85 c0                	test   %eax,%eax
  8014cb:	78 21                	js     8014ee <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8014cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014d0:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8014d6:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8014d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014db:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8014e2:	83 ec 0c             	sub    $0xc,%esp
  8014e5:	50                   	push   %eax
  8014e6:	e8 a6 ee ff ff       	call   800391 <fd2num>
  8014eb:	83 c4 10             	add    $0x10,%esp
}
  8014ee:	c9                   	leave  
  8014ef:	c3                   	ret    

008014f0 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8014f0:	55                   	push   %ebp
  8014f1:	89 e5                	mov    %esp,%ebp
  8014f3:	56                   	push   %esi
  8014f4:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8014f5:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8014f8:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8014fe:	e8 40 ec ff ff       	call   800143 <sys_getenvid>
  801503:	83 ec 0c             	sub    $0xc,%esp
  801506:	ff 75 0c             	pushl  0xc(%ebp)
  801509:	ff 75 08             	pushl  0x8(%ebp)
  80150c:	56                   	push   %esi
  80150d:	50                   	push   %eax
  80150e:	68 ac 24 80 00       	push   $0x8024ac
  801513:	e8 b3 00 00 00       	call   8015cb <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801518:	83 c4 18             	add    $0x18,%esp
  80151b:	53                   	push   %ebx
  80151c:	ff 75 10             	pushl  0x10(%ebp)
  80151f:	e8 56 00 00 00       	call   80157a <vcprintf>
	cprintf("\n");
  801524:	c7 04 24 60 24 80 00 	movl   $0x802460,(%esp)
  80152b:	e8 9b 00 00 00       	call   8015cb <cprintf>
  801530:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801533:	cc                   	int3   
  801534:	eb fd                	jmp    801533 <_panic+0x43>

00801536 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  801536:	55                   	push   %ebp
  801537:	89 e5                	mov    %esp,%ebp
  801539:	53                   	push   %ebx
  80153a:	83 ec 04             	sub    $0x4,%esp
  80153d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801540:	8b 13                	mov    (%ebx),%edx
  801542:	8d 42 01             	lea    0x1(%edx),%eax
  801545:	89 03                	mov    %eax,(%ebx)
  801547:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80154a:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80154e:	3d ff 00 00 00       	cmp    $0xff,%eax
  801553:	74 09                	je     80155e <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  801555:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  801559:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80155c:	c9                   	leave  
  80155d:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80155e:	83 ec 08             	sub    $0x8,%esp
  801561:	68 ff 00 00 00       	push   $0xff
  801566:	8d 43 08             	lea    0x8(%ebx),%eax
  801569:	50                   	push   %eax
  80156a:	e8 56 eb ff ff       	call   8000c5 <sys_cputs>
		b->idx = 0;
  80156f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801575:	83 c4 10             	add    $0x10,%esp
  801578:	eb db                	jmp    801555 <putch+0x1f>

0080157a <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80157a:	55                   	push   %ebp
  80157b:	89 e5                	mov    %esp,%ebp
  80157d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801583:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80158a:	00 00 00 
	b.cnt = 0;
  80158d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801594:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  801597:	ff 75 0c             	pushl  0xc(%ebp)
  80159a:	ff 75 08             	pushl  0x8(%ebp)
  80159d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8015a3:	50                   	push   %eax
  8015a4:	68 36 15 80 00       	push   $0x801536
  8015a9:	e8 1a 01 00 00       	call   8016c8 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8015ae:	83 c4 08             	add    $0x8,%esp
  8015b1:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8015b7:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8015bd:	50                   	push   %eax
  8015be:	e8 02 eb ff ff       	call   8000c5 <sys_cputs>

	return b.cnt;
}
  8015c3:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8015c9:	c9                   	leave  
  8015ca:	c3                   	ret    

008015cb <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8015cb:	55                   	push   %ebp
  8015cc:	89 e5                	mov    %esp,%ebp
  8015ce:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8015d1:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8015d4:	50                   	push   %eax
  8015d5:	ff 75 08             	pushl  0x8(%ebp)
  8015d8:	e8 9d ff ff ff       	call   80157a <vcprintf>
	va_end(ap);

	return cnt;
}
  8015dd:	c9                   	leave  
  8015de:	c3                   	ret    

008015df <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8015df:	55                   	push   %ebp
  8015e0:	89 e5                	mov    %esp,%ebp
  8015e2:	57                   	push   %edi
  8015e3:	56                   	push   %esi
  8015e4:	53                   	push   %ebx
  8015e5:	83 ec 1c             	sub    $0x1c,%esp
  8015e8:	89 c7                	mov    %eax,%edi
  8015ea:	89 d6                	mov    %edx,%esi
  8015ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015f2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8015f5:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8015f8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015fb:	bb 00 00 00 00       	mov    $0x0,%ebx
  801600:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  801603:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  801606:	39 d3                	cmp    %edx,%ebx
  801608:	72 05                	jb     80160f <printnum+0x30>
  80160a:	39 45 10             	cmp    %eax,0x10(%ebp)
  80160d:	77 7a                	ja     801689 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80160f:	83 ec 0c             	sub    $0xc,%esp
  801612:	ff 75 18             	pushl  0x18(%ebp)
  801615:	8b 45 14             	mov    0x14(%ebp),%eax
  801618:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80161b:	53                   	push   %ebx
  80161c:	ff 75 10             	pushl  0x10(%ebp)
  80161f:	83 ec 08             	sub    $0x8,%esp
  801622:	ff 75 e4             	pushl  -0x1c(%ebp)
  801625:	ff 75 e0             	pushl  -0x20(%ebp)
  801628:	ff 75 dc             	pushl  -0x24(%ebp)
  80162b:	ff 75 d8             	pushl  -0x28(%ebp)
  80162e:	e8 ad 0a 00 00       	call   8020e0 <__udivdi3>
  801633:	83 c4 18             	add    $0x18,%esp
  801636:	52                   	push   %edx
  801637:	50                   	push   %eax
  801638:	89 f2                	mov    %esi,%edx
  80163a:	89 f8                	mov    %edi,%eax
  80163c:	e8 9e ff ff ff       	call   8015df <printnum>
  801641:	83 c4 20             	add    $0x20,%esp
  801644:	eb 13                	jmp    801659 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801646:	83 ec 08             	sub    $0x8,%esp
  801649:	56                   	push   %esi
  80164a:	ff 75 18             	pushl  0x18(%ebp)
  80164d:	ff d7                	call   *%edi
  80164f:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  801652:	83 eb 01             	sub    $0x1,%ebx
  801655:	85 db                	test   %ebx,%ebx
  801657:	7f ed                	jg     801646 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801659:	83 ec 08             	sub    $0x8,%esp
  80165c:	56                   	push   %esi
  80165d:	83 ec 04             	sub    $0x4,%esp
  801660:	ff 75 e4             	pushl  -0x1c(%ebp)
  801663:	ff 75 e0             	pushl  -0x20(%ebp)
  801666:	ff 75 dc             	pushl  -0x24(%ebp)
  801669:	ff 75 d8             	pushl  -0x28(%ebp)
  80166c:	e8 8f 0b 00 00       	call   802200 <__umoddi3>
  801671:	83 c4 14             	add    $0x14,%esp
  801674:	0f be 80 cf 24 80 00 	movsbl 0x8024cf(%eax),%eax
  80167b:	50                   	push   %eax
  80167c:	ff d7                	call   *%edi
}
  80167e:	83 c4 10             	add    $0x10,%esp
  801681:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801684:	5b                   	pop    %ebx
  801685:	5e                   	pop    %esi
  801686:	5f                   	pop    %edi
  801687:	5d                   	pop    %ebp
  801688:	c3                   	ret    
  801689:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80168c:	eb c4                	jmp    801652 <printnum+0x73>

0080168e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80168e:	55                   	push   %ebp
  80168f:	89 e5                	mov    %esp,%ebp
  801691:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801694:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  801698:	8b 10                	mov    (%eax),%edx
  80169a:	3b 50 04             	cmp    0x4(%eax),%edx
  80169d:	73 0a                	jae    8016a9 <sprintputch+0x1b>
		*b->buf++ = ch;
  80169f:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016a2:	89 08                	mov    %ecx,(%eax)
  8016a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a7:	88 02                	mov    %al,(%edx)
}
  8016a9:	5d                   	pop    %ebp
  8016aa:	c3                   	ret    

008016ab <printfmt>:
{
  8016ab:	55                   	push   %ebp
  8016ac:	89 e5                	mov    %esp,%ebp
  8016ae:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8016b1:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8016b4:	50                   	push   %eax
  8016b5:	ff 75 10             	pushl  0x10(%ebp)
  8016b8:	ff 75 0c             	pushl  0xc(%ebp)
  8016bb:	ff 75 08             	pushl  0x8(%ebp)
  8016be:	e8 05 00 00 00       	call   8016c8 <vprintfmt>
}
  8016c3:	83 c4 10             	add    $0x10,%esp
  8016c6:	c9                   	leave  
  8016c7:	c3                   	ret    

008016c8 <vprintfmt>:
{
  8016c8:	55                   	push   %ebp
  8016c9:	89 e5                	mov    %esp,%ebp
  8016cb:	57                   	push   %edi
  8016cc:	56                   	push   %esi
  8016cd:	53                   	push   %ebx
  8016ce:	83 ec 2c             	sub    $0x2c,%esp
  8016d1:	8b 75 08             	mov    0x8(%ebp),%esi
  8016d4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8016d7:	8b 7d 10             	mov    0x10(%ebp),%edi
  8016da:	e9 21 04 00 00       	jmp    801b00 <vprintfmt+0x438>
		padc = ' ';
  8016df:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8016e3:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8016ea:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  8016f1:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8016f8:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8016fd:	8d 47 01             	lea    0x1(%edi),%eax
  801700:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801703:	0f b6 17             	movzbl (%edi),%edx
  801706:	8d 42 dd             	lea    -0x23(%edx),%eax
  801709:	3c 55                	cmp    $0x55,%al
  80170b:	0f 87 90 04 00 00    	ja     801ba1 <vprintfmt+0x4d9>
  801711:	0f b6 c0             	movzbl %al,%eax
  801714:	ff 24 85 20 26 80 00 	jmp    *0x802620(,%eax,4)
  80171b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80171e:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  801722:	eb d9                	jmp    8016fd <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  801724:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  801727:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  80172b:	eb d0                	jmp    8016fd <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80172d:	0f b6 d2             	movzbl %dl,%edx
  801730:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  801733:	b8 00 00 00 00       	mov    $0x0,%eax
  801738:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80173b:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80173e:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  801742:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  801745:	8d 4a d0             	lea    -0x30(%edx),%ecx
  801748:	83 f9 09             	cmp    $0x9,%ecx
  80174b:	77 55                	ja     8017a2 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  80174d:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  801750:	eb e9                	jmp    80173b <vprintfmt+0x73>
			precision = va_arg(ap, int);
  801752:	8b 45 14             	mov    0x14(%ebp),%eax
  801755:	8b 00                	mov    (%eax),%eax
  801757:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80175a:	8b 45 14             	mov    0x14(%ebp),%eax
  80175d:	8d 40 04             	lea    0x4(%eax),%eax
  801760:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801763:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  801766:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80176a:	79 91                	jns    8016fd <vprintfmt+0x35>
				width = precision, precision = -1;
  80176c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80176f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801772:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  801779:	eb 82                	jmp    8016fd <vprintfmt+0x35>
  80177b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80177e:	85 c0                	test   %eax,%eax
  801780:	ba 00 00 00 00       	mov    $0x0,%edx
  801785:	0f 49 d0             	cmovns %eax,%edx
  801788:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80178b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80178e:	e9 6a ff ff ff       	jmp    8016fd <vprintfmt+0x35>
  801793:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  801796:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  80179d:	e9 5b ff ff ff       	jmp    8016fd <vprintfmt+0x35>
  8017a2:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8017a5:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8017a8:	eb bc                	jmp    801766 <vprintfmt+0x9e>
			lflag++;
  8017aa:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8017ad:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8017b0:	e9 48 ff ff ff       	jmp    8016fd <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8017b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8017b8:	8d 78 04             	lea    0x4(%eax),%edi
  8017bb:	83 ec 08             	sub    $0x8,%esp
  8017be:	53                   	push   %ebx
  8017bf:	ff 30                	pushl  (%eax)
  8017c1:	ff d6                	call   *%esi
			break;
  8017c3:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8017c6:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8017c9:	e9 2f 03 00 00       	jmp    801afd <vprintfmt+0x435>
			err = va_arg(ap, int);
  8017ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8017d1:	8d 78 04             	lea    0x4(%eax),%edi
  8017d4:	8b 00                	mov    (%eax),%eax
  8017d6:	99                   	cltd   
  8017d7:	31 d0                	xor    %edx,%eax
  8017d9:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8017db:	83 f8 0f             	cmp    $0xf,%eax
  8017de:	7f 23                	jg     801803 <vprintfmt+0x13b>
  8017e0:	8b 14 85 80 27 80 00 	mov    0x802780(,%eax,4),%edx
  8017e7:	85 d2                	test   %edx,%edx
  8017e9:	74 18                	je     801803 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  8017eb:	52                   	push   %edx
  8017ec:	68 27 24 80 00       	push   $0x802427
  8017f1:	53                   	push   %ebx
  8017f2:	56                   	push   %esi
  8017f3:	e8 b3 fe ff ff       	call   8016ab <printfmt>
  8017f8:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8017fb:	89 7d 14             	mov    %edi,0x14(%ebp)
  8017fe:	e9 fa 02 00 00       	jmp    801afd <vprintfmt+0x435>
				printfmt(putch, putdat, "error %d", err);
  801803:	50                   	push   %eax
  801804:	68 e7 24 80 00       	push   $0x8024e7
  801809:	53                   	push   %ebx
  80180a:	56                   	push   %esi
  80180b:	e8 9b fe ff ff       	call   8016ab <printfmt>
  801810:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801813:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  801816:	e9 e2 02 00 00       	jmp    801afd <vprintfmt+0x435>
			if ((p = va_arg(ap, char *)) == NULL)
  80181b:	8b 45 14             	mov    0x14(%ebp),%eax
  80181e:	83 c0 04             	add    $0x4,%eax
  801821:	89 45 cc             	mov    %eax,-0x34(%ebp)
  801824:	8b 45 14             	mov    0x14(%ebp),%eax
  801827:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  801829:	85 ff                	test   %edi,%edi
  80182b:	b8 e0 24 80 00       	mov    $0x8024e0,%eax
  801830:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  801833:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801837:	0f 8e bd 00 00 00    	jle    8018fa <vprintfmt+0x232>
  80183d:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  801841:	75 0e                	jne    801851 <vprintfmt+0x189>
  801843:	89 75 08             	mov    %esi,0x8(%ebp)
  801846:	8b 75 d0             	mov    -0x30(%ebp),%esi
  801849:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80184c:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80184f:	eb 6d                	jmp    8018be <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  801851:	83 ec 08             	sub    $0x8,%esp
  801854:	ff 75 d0             	pushl  -0x30(%ebp)
  801857:	57                   	push   %edi
  801858:	e8 ec 03 00 00       	call   801c49 <strnlen>
  80185d:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  801860:	29 c1                	sub    %eax,%ecx
  801862:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  801865:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  801868:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  80186c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80186f:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  801872:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  801874:	eb 0f                	jmp    801885 <vprintfmt+0x1bd>
					putch(padc, putdat);
  801876:	83 ec 08             	sub    $0x8,%esp
  801879:	53                   	push   %ebx
  80187a:	ff 75 e0             	pushl  -0x20(%ebp)
  80187d:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80187f:	83 ef 01             	sub    $0x1,%edi
  801882:	83 c4 10             	add    $0x10,%esp
  801885:	85 ff                	test   %edi,%edi
  801887:	7f ed                	jg     801876 <vprintfmt+0x1ae>
  801889:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  80188c:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  80188f:	85 c9                	test   %ecx,%ecx
  801891:	b8 00 00 00 00       	mov    $0x0,%eax
  801896:	0f 49 c1             	cmovns %ecx,%eax
  801899:	29 c1                	sub    %eax,%ecx
  80189b:	89 75 08             	mov    %esi,0x8(%ebp)
  80189e:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8018a1:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8018a4:	89 cb                	mov    %ecx,%ebx
  8018a6:	eb 16                	jmp    8018be <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8018a8:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8018ac:	75 31                	jne    8018df <vprintfmt+0x217>
					putch(ch, putdat);
  8018ae:	83 ec 08             	sub    $0x8,%esp
  8018b1:	ff 75 0c             	pushl  0xc(%ebp)
  8018b4:	50                   	push   %eax
  8018b5:	ff 55 08             	call   *0x8(%ebp)
  8018b8:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8018bb:	83 eb 01             	sub    $0x1,%ebx
  8018be:	83 c7 01             	add    $0x1,%edi
  8018c1:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8018c5:	0f be c2             	movsbl %dl,%eax
  8018c8:	85 c0                	test   %eax,%eax
  8018ca:	74 59                	je     801925 <vprintfmt+0x25d>
  8018cc:	85 f6                	test   %esi,%esi
  8018ce:	78 d8                	js     8018a8 <vprintfmt+0x1e0>
  8018d0:	83 ee 01             	sub    $0x1,%esi
  8018d3:	79 d3                	jns    8018a8 <vprintfmt+0x1e0>
  8018d5:	89 df                	mov    %ebx,%edi
  8018d7:	8b 75 08             	mov    0x8(%ebp),%esi
  8018da:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8018dd:	eb 37                	jmp    801916 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  8018df:	0f be d2             	movsbl %dl,%edx
  8018e2:	83 ea 20             	sub    $0x20,%edx
  8018e5:	83 fa 5e             	cmp    $0x5e,%edx
  8018e8:	76 c4                	jbe    8018ae <vprintfmt+0x1e6>
					putch('?', putdat);
  8018ea:	83 ec 08             	sub    $0x8,%esp
  8018ed:	ff 75 0c             	pushl  0xc(%ebp)
  8018f0:	6a 3f                	push   $0x3f
  8018f2:	ff 55 08             	call   *0x8(%ebp)
  8018f5:	83 c4 10             	add    $0x10,%esp
  8018f8:	eb c1                	jmp    8018bb <vprintfmt+0x1f3>
  8018fa:	89 75 08             	mov    %esi,0x8(%ebp)
  8018fd:	8b 75 d0             	mov    -0x30(%ebp),%esi
  801900:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  801903:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  801906:	eb b6                	jmp    8018be <vprintfmt+0x1f6>
				putch(' ', putdat);
  801908:	83 ec 08             	sub    $0x8,%esp
  80190b:	53                   	push   %ebx
  80190c:	6a 20                	push   $0x20
  80190e:	ff d6                	call   *%esi
			for (; width > 0; width--)
  801910:	83 ef 01             	sub    $0x1,%edi
  801913:	83 c4 10             	add    $0x10,%esp
  801916:	85 ff                	test   %edi,%edi
  801918:	7f ee                	jg     801908 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  80191a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80191d:	89 45 14             	mov    %eax,0x14(%ebp)
  801920:	e9 d8 01 00 00       	jmp    801afd <vprintfmt+0x435>
  801925:	89 df                	mov    %ebx,%edi
  801927:	8b 75 08             	mov    0x8(%ebp),%esi
  80192a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80192d:	eb e7                	jmp    801916 <vprintfmt+0x24e>
	if (lflag >= 2)
  80192f:	83 f9 01             	cmp    $0x1,%ecx
  801932:	7e 45                	jle    801979 <vprintfmt+0x2b1>
		return va_arg(*ap, long long);
  801934:	8b 45 14             	mov    0x14(%ebp),%eax
  801937:	8b 50 04             	mov    0x4(%eax),%edx
  80193a:	8b 00                	mov    (%eax),%eax
  80193c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80193f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801942:	8b 45 14             	mov    0x14(%ebp),%eax
  801945:	8d 40 08             	lea    0x8(%eax),%eax
  801948:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80194b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80194f:	79 62                	jns    8019b3 <vprintfmt+0x2eb>
				putch('-', putdat);
  801951:	83 ec 08             	sub    $0x8,%esp
  801954:	53                   	push   %ebx
  801955:	6a 2d                	push   $0x2d
  801957:	ff d6                	call   *%esi
				num = -(long long) num;
  801959:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80195c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80195f:	f7 d8                	neg    %eax
  801961:	83 d2 00             	adc    $0x0,%edx
  801964:	f7 da                	neg    %edx
  801966:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801969:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80196c:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80196f:	ba 0a 00 00 00       	mov    $0xa,%edx
  801974:	e9 66 01 00 00       	jmp    801adf <vprintfmt+0x417>
	else if (lflag)
  801979:	85 c9                	test   %ecx,%ecx
  80197b:	75 1b                	jne    801998 <vprintfmt+0x2d0>
		return va_arg(*ap, int);
  80197d:	8b 45 14             	mov    0x14(%ebp),%eax
  801980:	8b 00                	mov    (%eax),%eax
  801982:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801985:	89 c1                	mov    %eax,%ecx
  801987:	c1 f9 1f             	sar    $0x1f,%ecx
  80198a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80198d:	8b 45 14             	mov    0x14(%ebp),%eax
  801990:	8d 40 04             	lea    0x4(%eax),%eax
  801993:	89 45 14             	mov    %eax,0x14(%ebp)
  801996:	eb b3                	jmp    80194b <vprintfmt+0x283>
		return va_arg(*ap, long);
  801998:	8b 45 14             	mov    0x14(%ebp),%eax
  80199b:	8b 00                	mov    (%eax),%eax
  80199d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8019a0:	89 c1                	mov    %eax,%ecx
  8019a2:	c1 f9 1f             	sar    $0x1f,%ecx
  8019a5:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8019a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8019ab:	8d 40 04             	lea    0x4(%eax),%eax
  8019ae:	89 45 14             	mov    %eax,0x14(%ebp)
  8019b1:	eb 98                	jmp    80194b <vprintfmt+0x283>
			base = 10;
  8019b3:	ba 0a 00 00 00       	mov    $0xa,%edx
  8019b8:	e9 22 01 00 00       	jmp    801adf <vprintfmt+0x417>
	if (lflag >= 2)
  8019bd:	83 f9 01             	cmp    $0x1,%ecx
  8019c0:	7e 21                	jle    8019e3 <vprintfmt+0x31b>
		return va_arg(*ap, unsigned long long);
  8019c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8019c5:	8b 50 04             	mov    0x4(%eax),%edx
  8019c8:	8b 00                	mov    (%eax),%eax
  8019ca:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8019cd:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8019d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8019d3:	8d 40 08             	lea    0x8(%eax),%eax
  8019d6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8019d9:	ba 0a 00 00 00       	mov    $0xa,%edx
  8019de:	e9 fc 00 00 00       	jmp    801adf <vprintfmt+0x417>
	else if (lflag)
  8019e3:	85 c9                	test   %ecx,%ecx
  8019e5:	75 23                	jne    801a0a <vprintfmt+0x342>
		return va_arg(*ap, unsigned int);
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
  801a05:	e9 d5 00 00 00       	jmp    801adf <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  801a0a:	8b 45 14             	mov    0x14(%ebp),%eax
  801a0d:	8b 00                	mov    (%eax),%eax
  801a0f:	ba 00 00 00 00       	mov    $0x0,%edx
  801a14:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801a17:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801a1a:	8b 45 14             	mov    0x14(%ebp),%eax
  801a1d:	8d 40 04             	lea    0x4(%eax),%eax
  801a20:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801a23:	ba 0a 00 00 00       	mov    $0xa,%edx
  801a28:	e9 b2 00 00 00       	jmp    801adf <vprintfmt+0x417>
	if (lflag >= 2)
  801a2d:	83 f9 01             	cmp    $0x1,%ecx
  801a30:	7e 42                	jle    801a74 <vprintfmt+0x3ac>
		return va_arg(*ap, unsigned long long);
  801a32:	8b 45 14             	mov    0x14(%ebp),%eax
  801a35:	8b 50 04             	mov    0x4(%eax),%edx
  801a38:	8b 00                	mov    (%eax),%eax
  801a3a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801a3d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801a40:	8b 45 14             	mov    0x14(%ebp),%eax
  801a43:	8d 40 08             	lea    0x8(%eax),%eax
  801a46:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801a49:	ba 08 00 00 00       	mov    $0x8,%edx
			if ((long long) num < 0) {
  801a4e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801a52:	0f 89 87 00 00 00    	jns    801adf <vprintfmt+0x417>
				putch('-', putdat);
  801a58:	83 ec 08             	sub    $0x8,%esp
  801a5b:	53                   	push   %ebx
  801a5c:	6a 2d                	push   $0x2d
  801a5e:	ff d6                	call   *%esi
				num = -(long long) num;
  801a60:	f7 5d d8             	negl   -0x28(%ebp)
  801a63:	83 55 dc 00          	adcl   $0x0,-0x24(%ebp)
  801a67:	f7 5d dc             	negl   -0x24(%ebp)
  801a6a:	83 c4 10             	add    $0x10,%esp
			base = 8;
  801a6d:	ba 08 00 00 00       	mov    $0x8,%edx
  801a72:	eb 6b                	jmp    801adf <vprintfmt+0x417>
	else if (lflag)
  801a74:	85 c9                	test   %ecx,%ecx
  801a76:	75 1b                	jne    801a93 <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  801a78:	8b 45 14             	mov    0x14(%ebp),%eax
  801a7b:	8b 00                	mov    (%eax),%eax
  801a7d:	ba 00 00 00 00       	mov    $0x0,%edx
  801a82:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801a85:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801a88:	8b 45 14             	mov    0x14(%ebp),%eax
  801a8b:	8d 40 04             	lea    0x4(%eax),%eax
  801a8e:	89 45 14             	mov    %eax,0x14(%ebp)
  801a91:	eb b6                	jmp    801a49 <vprintfmt+0x381>
		return va_arg(*ap, unsigned long);
  801a93:	8b 45 14             	mov    0x14(%ebp),%eax
  801a96:	8b 00                	mov    (%eax),%eax
  801a98:	ba 00 00 00 00       	mov    $0x0,%edx
  801a9d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801aa0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801aa3:	8b 45 14             	mov    0x14(%ebp),%eax
  801aa6:	8d 40 04             	lea    0x4(%eax),%eax
  801aa9:	89 45 14             	mov    %eax,0x14(%ebp)
  801aac:	eb 9b                	jmp    801a49 <vprintfmt+0x381>
			putch('0', putdat);
  801aae:	83 ec 08             	sub    $0x8,%esp
  801ab1:	53                   	push   %ebx
  801ab2:	6a 30                	push   $0x30
  801ab4:	ff d6                	call   *%esi
			putch('x', putdat);
  801ab6:	83 c4 08             	add    $0x8,%esp
  801ab9:	53                   	push   %ebx
  801aba:	6a 78                	push   $0x78
  801abc:	ff d6                	call   *%esi
			num = (unsigned long long)
  801abe:	8b 45 14             	mov    0x14(%ebp),%eax
  801ac1:	8b 00                	mov    (%eax),%eax
  801ac3:	ba 00 00 00 00       	mov    $0x0,%edx
  801ac8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801acb:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  801ace:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  801ad1:	8b 45 14             	mov    0x14(%ebp),%eax
  801ad4:	8d 40 04             	lea    0x4(%eax),%eax
  801ad7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801ada:	ba 10 00 00 00       	mov    $0x10,%edx
			printnum(putch, putdat, num, base, width, padc);
  801adf:	83 ec 0c             	sub    $0xc,%esp
  801ae2:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  801ae6:	50                   	push   %eax
  801ae7:	ff 75 e0             	pushl  -0x20(%ebp)
  801aea:	52                   	push   %edx
  801aeb:	ff 75 dc             	pushl  -0x24(%ebp)
  801aee:	ff 75 d8             	pushl  -0x28(%ebp)
  801af1:	89 da                	mov    %ebx,%edx
  801af3:	89 f0                	mov    %esi,%eax
  801af5:	e8 e5 fa ff ff       	call   8015df <printnum>
			break;
  801afa:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  801afd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801b00:	83 c7 01             	add    $0x1,%edi
  801b03:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801b07:	83 f8 25             	cmp    $0x25,%eax
  801b0a:	0f 84 cf fb ff ff    	je     8016df <vprintfmt+0x17>
			if (ch == '\0')
  801b10:	85 c0                	test   %eax,%eax
  801b12:	0f 84 a9 00 00 00    	je     801bc1 <vprintfmt+0x4f9>
			putch(ch, putdat);
  801b18:	83 ec 08             	sub    $0x8,%esp
  801b1b:	53                   	push   %ebx
  801b1c:	50                   	push   %eax
  801b1d:	ff d6                	call   *%esi
  801b1f:	83 c4 10             	add    $0x10,%esp
  801b22:	eb dc                	jmp    801b00 <vprintfmt+0x438>
	if (lflag >= 2)
  801b24:	83 f9 01             	cmp    $0x1,%ecx
  801b27:	7e 1e                	jle    801b47 <vprintfmt+0x47f>
		return va_arg(*ap, unsigned long long);
  801b29:	8b 45 14             	mov    0x14(%ebp),%eax
  801b2c:	8b 50 04             	mov    0x4(%eax),%edx
  801b2f:	8b 00                	mov    (%eax),%eax
  801b31:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801b34:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801b37:	8b 45 14             	mov    0x14(%ebp),%eax
  801b3a:	8d 40 08             	lea    0x8(%eax),%eax
  801b3d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801b40:	ba 10 00 00 00       	mov    $0x10,%edx
  801b45:	eb 98                	jmp    801adf <vprintfmt+0x417>
	else if (lflag)
  801b47:	85 c9                	test   %ecx,%ecx
  801b49:	75 23                	jne    801b6e <vprintfmt+0x4a6>
		return va_arg(*ap, unsigned int);
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
  801b69:	e9 71 ff ff ff       	jmp    801adf <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  801b6e:	8b 45 14             	mov    0x14(%ebp),%eax
  801b71:	8b 00                	mov    (%eax),%eax
  801b73:	ba 00 00 00 00       	mov    $0x0,%edx
  801b78:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801b7b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801b7e:	8b 45 14             	mov    0x14(%ebp),%eax
  801b81:	8d 40 04             	lea    0x4(%eax),%eax
  801b84:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801b87:	ba 10 00 00 00       	mov    $0x10,%edx
  801b8c:	e9 4e ff ff ff       	jmp    801adf <vprintfmt+0x417>
			putch(ch, putdat);
  801b91:	83 ec 08             	sub    $0x8,%esp
  801b94:	53                   	push   %ebx
  801b95:	6a 25                	push   $0x25
  801b97:	ff d6                	call   *%esi
			break;
  801b99:	83 c4 10             	add    $0x10,%esp
  801b9c:	e9 5c ff ff ff       	jmp    801afd <vprintfmt+0x435>
			putch('%', putdat);
  801ba1:	83 ec 08             	sub    $0x8,%esp
  801ba4:	53                   	push   %ebx
  801ba5:	6a 25                	push   $0x25
  801ba7:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  801ba9:	83 c4 10             	add    $0x10,%esp
  801bac:	89 f8                	mov    %edi,%eax
  801bae:	eb 03                	jmp    801bb3 <vprintfmt+0x4eb>
  801bb0:	83 e8 01             	sub    $0x1,%eax
  801bb3:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  801bb7:	75 f7                	jne    801bb0 <vprintfmt+0x4e8>
  801bb9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801bbc:	e9 3c ff ff ff       	jmp    801afd <vprintfmt+0x435>
}
  801bc1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801bc4:	5b                   	pop    %ebx
  801bc5:	5e                   	pop    %esi
  801bc6:	5f                   	pop    %edi
  801bc7:	5d                   	pop    %ebp
  801bc8:	c3                   	ret    

00801bc9 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801bc9:	55                   	push   %ebp
  801bca:	89 e5                	mov    %esp,%ebp
  801bcc:	83 ec 18             	sub    $0x18,%esp
  801bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd2:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801bd5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801bd8:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801bdc:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801bdf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801be6:	85 c0                	test   %eax,%eax
  801be8:	74 26                	je     801c10 <vsnprintf+0x47>
  801bea:	85 d2                	test   %edx,%edx
  801bec:	7e 22                	jle    801c10 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801bee:	ff 75 14             	pushl  0x14(%ebp)
  801bf1:	ff 75 10             	pushl  0x10(%ebp)
  801bf4:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801bf7:	50                   	push   %eax
  801bf8:	68 8e 16 80 00       	push   $0x80168e
  801bfd:	e8 c6 fa ff ff       	call   8016c8 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801c02:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c05:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801c08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c0b:	83 c4 10             	add    $0x10,%esp
}
  801c0e:	c9                   	leave  
  801c0f:	c3                   	ret    
		return -E_INVAL;
  801c10:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c15:	eb f7                	jmp    801c0e <vsnprintf+0x45>

00801c17 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801c17:	55                   	push   %ebp
  801c18:	89 e5                	mov    %esp,%ebp
  801c1a:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801c1d:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801c20:	50                   	push   %eax
  801c21:	ff 75 10             	pushl  0x10(%ebp)
  801c24:	ff 75 0c             	pushl  0xc(%ebp)
  801c27:	ff 75 08             	pushl  0x8(%ebp)
  801c2a:	e8 9a ff ff ff       	call   801bc9 <vsnprintf>
	va_end(ap);

	return rc;
}
  801c2f:	c9                   	leave  
  801c30:	c3                   	ret    

00801c31 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801c31:	55                   	push   %ebp
  801c32:	89 e5                	mov    %esp,%ebp
  801c34:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801c37:	b8 00 00 00 00       	mov    $0x0,%eax
  801c3c:	eb 03                	jmp    801c41 <strlen+0x10>
		n++;
  801c3e:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  801c41:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801c45:	75 f7                	jne    801c3e <strlen+0xd>
	return n;
}
  801c47:	5d                   	pop    %ebp
  801c48:	c3                   	ret    

00801c49 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801c49:	55                   	push   %ebp
  801c4a:	89 e5                	mov    %esp,%ebp
  801c4c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c4f:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801c52:	b8 00 00 00 00       	mov    $0x0,%eax
  801c57:	eb 03                	jmp    801c5c <strnlen+0x13>
		n++;
  801c59:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801c5c:	39 d0                	cmp    %edx,%eax
  801c5e:	74 06                	je     801c66 <strnlen+0x1d>
  801c60:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  801c64:	75 f3                	jne    801c59 <strnlen+0x10>
	return n;
}
  801c66:	5d                   	pop    %ebp
  801c67:	c3                   	ret    

00801c68 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801c68:	55                   	push   %ebp
  801c69:	89 e5                	mov    %esp,%ebp
  801c6b:	53                   	push   %ebx
  801c6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801c72:	89 c2                	mov    %eax,%edx
  801c74:	83 c1 01             	add    $0x1,%ecx
  801c77:	83 c2 01             	add    $0x1,%edx
  801c7a:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  801c7e:	88 5a ff             	mov    %bl,-0x1(%edx)
  801c81:	84 db                	test   %bl,%bl
  801c83:	75 ef                	jne    801c74 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  801c85:	5b                   	pop    %ebx
  801c86:	5d                   	pop    %ebp
  801c87:	c3                   	ret    

00801c88 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801c88:	55                   	push   %ebp
  801c89:	89 e5                	mov    %esp,%ebp
  801c8b:	53                   	push   %ebx
  801c8c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801c8f:	53                   	push   %ebx
  801c90:	e8 9c ff ff ff       	call   801c31 <strlen>
  801c95:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  801c98:	ff 75 0c             	pushl  0xc(%ebp)
  801c9b:	01 d8                	add    %ebx,%eax
  801c9d:	50                   	push   %eax
  801c9e:	e8 c5 ff ff ff       	call   801c68 <strcpy>
	return dst;
}
  801ca3:	89 d8                	mov    %ebx,%eax
  801ca5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ca8:	c9                   	leave  
  801ca9:	c3                   	ret    

00801caa <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801caa:	55                   	push   %ebp
  801cab:	89 e5                	mov    %esp,%ebp
  801cad:	56                   	push   %esi
  801cae:	53                   	push   %ebx
  801caf:	8b 75 08             	mov    0x8(%ebp),%esi
  801cb2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801cb5:	89 f3                	mov    %esi,%ebx
  801cb7:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801cba:	89 f2                	mov    %esi,%edx
  801cbc:	eb 0f                	jmp    801ccd <strncpy+0x23>
		*dst++ = *src;
  801cbe:	83 c2 01             	add    $0x1,%edx
  801cc1:	0f b6 01             	movzbl (%ecx),%eax
  801cc4:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801cc7:	80 39 01             	cmpb   $0x1,(%ecx)
  801cca:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  801ccd:	39 da                	cmp    %ebx,%edx
  801ccf:	75 ed                	jne    801cbe <strncpy+0x14>
	}
	return ret;
}
  801cd1:	89 f0                	mov    %esi,%eax
  801cd3:	5b                   	pop    %ebx
  801cd4:	5e                   	pop    %esi
  801cd5:	5d                   	pop    %ebp
  801cd6:	c3                   	ret    

00801cd7 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801cd7:	55                   	push   %ebp
  801cd8:	89 e5                	mov    %esp,%ebp
  801cda:	56                   	push   %esi
  801cdb:	53                   	push   %ebx
  801cdc:	8b 75 08             	mov    0x8(%ebp),%esi
  801cdf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ce2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ce5:	89 f0                	mov    %esi,%eax
  801ce7:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801ceb:	85 c9                	test   %ecx,%ecx
  801ced:	75 0b                	jne    801cfa <strlcpy+0x23>
  801cef:	eb 17                	jmp    801d08 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  801cf1:	83 c2 01             	add    $0x1,%edx
  801cf4:	83 c0 01             	add    $0x1,%eax
  801cf7:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  801cfa:	39 d8                	cmp    %ebx,%eax
  801cfc:	74 07                	je     801d05 <strlcpy+0x2e>
  801cfe:	0f b6 0a             	movzbl (%edx),%ecx
  801d01:	84 c9                	test   %cl,%cl
  801d03:	75 ec                	jne    801cf1 <strlcpy+0x1a>
		*dst = '\0';
  801d05:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801d08:	29 f0                	sub    %esi,%eax
}
  801d0a:	5b                   	pop    %ebx
  801d0b:	5e                   	pop    %esi
  801d0c:	5d                   	pop    %ebp
  801d0d:	c3                   	ret    

00801d0e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801d0e:	55                   	push   %ebp
  801d0f:	89 e5                	mov    %esp,%ebp
  801d11:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d14:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801d17:	eb 06                	jmp    801d1f <strcmp+0x11>
		p++, q++;
  801d19:	83 c1 01             	add    $0x1,%ecx
  801d1c:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  801d1f:	0f b6 01             	movzbl (%ecx),%eax
  801d22:	84 c0                	test   %al,%al
  801d24:	74 04                	je     801d2a <strcmp+0x1c>
  801d26:	3a 02                	cmp    (%edx),%al
  801d28:	74 ef                	je     801d19 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801d2a:	0f b6 c0             	movzbl %al,%eax
  801d2d:	0f b6 12             	movzbl (%edx),%edx
  801d30:	29 d0                	sub    %edx,%eax
}
  801d32:	5d                   	pop    %ebp
  801d33:	c3                   	ret    

00801d34 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801d34:	55                   	push   %ebp
  801d35:	89 e5                	mov    %esp,%ebp
  801d37:	53                   	push   %ebx
  801d38:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d3e:	89 c3                	mov    %eax,%ebx
  801d40:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  801d43:	eb 06                	jmp    801d4b <strncmp+0x17>
		n--, p++, q++;
  801d45:	83 c0 01             	add    $0x1,%eax
  801d48:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  801d4b:	39 d8                	cmp    %ebx,%eax
  801d4d:	74 16                	je     801d65 <strncmp+0x31>
  801d4f:	0f b6 08             	movzbl (%eax),%ecx
  801d52:	84 c9                	test   %cl,%cl
  801d54:	74 04                	je     801d5a <strncmp+0x26>
  801d56:	3a 0a                	cmp    (%edx),%cl
  801d58:	74 eb                	je     801d45 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801d5a:	0f b6 00             	movzbl (%eax),%eax
  801d5d:	0f b6 12             	movzbl (%edx),%edx
  801d60:	29 d0                	sub    %edx,%eax
}
  801d62:	5b                   	pop    %ebx
  801d63:	5d                   	pop    %ebp
  801d64:	c3                   	ret    
		return 0;
  801d65:	b8 00 00 00 00       	mov    $0x0,%eax
  801d6a:	eb f6                	jmp    801d62 <strncmp+0x2e>

00801d6c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801d6c:	55                   	push   %ebp
  801d6d:	89 e5                	mov    %esp,%ebp
  801d6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d72:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801d76:	0f b6 10             	movzbl (%eax),%edx
  801d79:	84 d2                	test   %dl,%dl
  801d7b:	74 09                	je     801d86 <strchr+0x1a>
		if (*s == c)
  801d7d:	38 ca                	cmp    %cl,%dl
  801d7f:	74 0a                	je     801d8b <strchr+0x1f>
	for (; *s; s++)
  801d81:	83 c0 01             	add    $0x1,%eax
  801d84:	eb f0                	jmp    801d76 <strchr+0xa>
			return (char *) s;
	return 0;
  801d86:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d8b:	5d                   	pop    %ebp
  801d8c:	c3                   	ret    

00801d8d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801d8d:	55                   	push   %ebp
  801d8e:	89 e5                	mov    %esp,%ebp
  801d90:	8b 45 08             	mov    0x8(%ebp),%eax
  801d93:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801d97:	eb 03                	jmp    801d9c <strfind+0xf>
  801d99:	83 c0 01             	add    $0x1,%eax
  801d9c:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  801d9f:	38 ca                	cmp    %cl,%dl
  801da1:	74 04                	je     801da7 <strfind+0x1a>
  801da3:	84 d2                	test   %dl,%dl
  801da5:	75 f2                	jne    801d99 <strfind+0xc>
			break;
	return (char *) s;
}
  801da7:	5d                   	pop    %ebp
  801da8:	c3                   	ret    

00801da9 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801da9:	55                   	push   %ebp
  801daa:	89 e5                	mov    %esp,%ebp
  801dac:	57                   	push   %edi
  801dad:	56                   	push   %esi
  801dae:	53                   	push   %ebx
  801daf:	8b 7d 08             	mov    0x8(%ebp),%edi
  801db2:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801db5:	85 c9                	test   %ecx,%ecx
  801db7:	74 13                	je     801dcc <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801db9:	f7 c7 03 00 00 00    	test   $0x3,%edi
  801dbf:	75 05                	jne    801dc6 <memset+0x1d>
  801dc1:	f6 c1 03             	test   $0x3,%cl
  801dc4:	74 0d                	je     801dd3 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801dc6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dc9:	fc                   	cld    
  801dca:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801dcc:	89 f8                	mov    %edi,%eax
  801dce:	5b                   	pop    %ebx
  801dcf:	5e                   	pop    %esi
  801dd0:	5f                   	pop    %edi
  801dd1:	5d                   	pop    %ebp
  801dd2:	c3                   	ret    
		c &= 0xFF;
  801dd3:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801dd7:	89 d3                	mov    %edx,%ebx
  801dd9:	c1 e3 08             	shl    $0x8,%ebx
  801ddc:	89 d0                	mov    %edx,%eax
  801dde:	c1 e0 18             	shl    $0x18,%eax
  801de1:	89 d6                	mov    %edx,%esi
  801de3:	c1 e6 10             	shl    $0x10,%esi
  801de6:	09 f0                	or     %esi,%eax
  801de8:	09 c2                	or     %eax,%edx
  801dea:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  801dec:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  801def:	89 d0                	mov    %edx,%eax
  801df1:	fc                   	cld    
  801df2:	f3 ab                	rep stos %eax,%es:(%edi)
  801df4:	eb d6                	jmp    801dcc <memset+0x23>

00801df6 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801df6:	55                   	push   %ebp
  801df7:	89 e5                	mov    %esp,%ebp
  801df9:	57                   	push   %edi
  801dfa:	56                   	push   %esi
  801dfb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dfe:	8b 75 0c             	mov    0xc(%ebp),%esi
  801e01:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801e04:	39 c6                	cmp    %eax,%esi
  801e06:	73 35                	jae    801e3d <memmove+0x47>
  801e08:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801e0b:	39 c2                	cmp    %eax,%edx
  801e0d:	76 2e                	jbe    801e3d <memmove+0x47>
		s += n;
		d += n;
  801e0f:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801e12:	89 d6                	mov    %edx,%esi
  801e14:	09 fe                	or     %edi,%esi
  801e16:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801e1c:	74 0c                	je     801e2a <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801e1e:	83 ef 01             	sub    $0x1,%edi
  801e21:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  801e24:	fd                   	std    
  801e25:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801e27:	fc                   	cld    
  801e28:	eb 21                	jmp    801e4b <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801e2a:	f6 c1 03             	test   $0x3,%cl
  801e2d:	75 ef                	jne    801e1e <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801e2f:	83 ef 04             	sub    $0x4,%edi
  801e32:	8d 72 fc             	lea    -0x4(%edx),%esi
  801e35:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  801e38:	fd                   	std    
  801e39:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801e3b:	eb ea                	jmp    801e27 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801e3d:	89 f2                	mov    %esi,%edx
  801e3f:	09 c2                	or     %eax,%edx
  801e41:	f6 c2 03             	test   $0x3,%dl
  801e44:	74 09                	je     801e4f <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801e46:	89 c7                	mov    %eax,%edi
  801e48:	fc                   	cld    
  801e49:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801e4b:	5e                   	pop    %esi
  801e4c:	5f                   	pop    %edi
  801e4d:	5d                   	pop    %ebp
  801e4e:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801e4f:	f6 c1 03             	test   $0x3,%cl
  801e52:	75 f2                	jne    801e46 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801e54:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  801e57:	89 c7                	mov    %eax,%edi
  801e59:	fc                   	cld    
  801e5a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801e5c:	eb ed                	jmp    801e4b <memmove+0x55>

00801e5e <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801e5e:	55                   	push   %ebp
  801e5f:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  801e61:	ff 75 10             	pushl  0x10(%ebp)
  801e64:	ff 75 0c             	pushl  0xc(%ebp)
  801e67:	ff 75 08             	pushl  0x8(%ebp)
  801e6a:	e8 87 ff ff ff       	call   801df6 <memmove>
}
  801e6f:	c9                   	leave  
  801e70:	c3                   	ret    

00801e71 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801e71:	55                   	push   %ebp
  801e72:	89 e5                	mov    %esp,%ebp
  801e74:	56                   	push   %esi
  801e75:	53                   	push   %ebx
  801e76:	8b 45 08             	mov    0x8(%ebp),%eax
  801e79:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e7c:	89 c6                	mov    %eax,%esi
  801e7e:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801e81:	39 f0                	cmp    %esi,%eax
  801e83:	74 1c                	je     801ea1 <memcmp+0x30>
		if (*s1 != *s2)
  801e85:	0f b6 08             	movzbl (%eax),%ecx
  801e88:	0f b6 1a             	movzbl (%edx),%ebx
  801e8b:	38 d9                	cmp    %bl,%cl
  801e8d:	75 08                	jne    801e97 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801e8f:	83 c0 01             	add    $0x1,%eax
  801e92:	83 c2 01             	add    $0x1,%edx
  801e95:	eb ea                	jmp    801e81 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  801e97:	0f b6 c1             	movzbl %cl,%eax
  801e9a:	0f b6 db             	movzbl %bl,%ebx
  801e9d:	29 d8                	sub    %ebx,%eax
  801e9f:	eb 05                	jmp    801ea6 <memcmp+0x35>
	}

	return 0;
  801ea1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ea6:	5b                   	pop    %ebx
  801ea7:	5e                   	pop    %esi
  801ea8:	5d                   	pop    %ebp
  801ea9:	c3                   	ret    

00801eaa <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801eaa:	55                   	push   %ebp
  801eab:	89 e5                	mov    %esp,%ebp
  801ead:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801eb3:	89 c2                	mov    %eax,%edx
  801eb5:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801eb8:	39 d0                	cmp    %edx,%eax
  801eba:	73 09                	jae    801ec5 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  801ebc:	38 08                	cmp    %cl,(%eax)
  801ebe:	74 05                	je     801ec5 <memfind+0x1b>
	for (; s < ends; s++)
  801ec0:	83 c0 01             	add    $0x1,%eax
  801ec3:	eb f3                	jmp    801eb8 <memfind+0xe>
			break;
	return (void *) s;
}
  801ec5:	5d                   	pop    %ebp
  801ec6:	c3                   	ret    

00801ec7 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801ec7:	55                   	push   %ebp
  801ec8:	89 e5                	mov    %esp,%ebp
  801eca:	57                   	push   %edi
  801ecb:	56                   	push   %esi
  801ecc:	53                   	push   %ebx
  801ecd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ed0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801ed3:	eb 03                	jmp    801ed8 <strtol+0x11>
		s++;
  801ed5:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  801ed8:	0f b6 01             	movzbl (%ecx),%eax
  801edb:	3c 20                	cmp    $0x20,%al
  801edd:	74 f6                	je     801ed5 <strtol+0xe>
  801edf:	3c 09                	cmp    $0x9,%al
  801ee1:	74 f2                	je     801ed5 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  801ee3:	3c 2b                	cmp    $0x2b,%al
  801ee5:	74 2e                	je     801f15 <strtol+0x4e>
	int neg = 0;
  801ee7:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801eec:	3c 2d                	cmp    $0x2d,%al
  801eee:	74 2f                	je     801f1f <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801ef0:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  801ef6:	75 05                	jne    801efd <strtol+0x36>
  801ef8:	80 39 30             	cmpb   $0x30,(%ecx)
  801efb:	74 2c                	je     801f29 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  801efd:	85 db                	test   %ebx,%ebx
  801eff:	75 0a                	jne    801f0b <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801f01:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  801f06:	80 39 30             	cmpb   $0x30,(%ecx)
  801f09:	74 28                	je     801f33 <strtol+0x6c>
		base = 10;
  801f0b:	b8 00 00 00 00       	mov    $0x0,%eax
  801f10:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801f13:	eb 50                	jmp    801f65 <strtol+0x9e>
		s++;
  801f15:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  801f18:	bf 00 00 00 00       	mov    $0x0,%edi
  801f1d:	eb d1                	jmp    801ef0 <strtol+0x29>
		s++, neg = 1;
  801f1f:	83 c1 01             	add    $0x1,%ecx
  801f22:	bf 01 00 00 00       	mov    $0x1,%edi
  801f27:	eb c7                	jmp    801ef0 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801f29:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801f2d:	74 0e                	je     801f3d <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  801f2f:	85 db                	test   %ebx,%ebx
  801f31:	75 d8                	jne    801f0b <strtol+0x44>
		s++, base = 8;
  801f33:	83 c1 01             	add    $0x1,%ecx
  801f36:	bb 08 00 00 00       	mov    $0x8,%ebx
  801f3b:	eb ce                	jmp    801f0b <strtol+0x44>
		s += 2, base = 16;
  801f3d:	83 c1 02             	add    $0x2,%ecx
  801f40:	bb 10 00 00 00       	mov    $0x10,%ebx
  801f45:	eb c4                	jmp    801f0b <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  801f47:	8d 72 9f             	lea    -0x61(%edx),%esi
  801f4a:	89 f3                	mov    %esi,%ebx
  801f4c:	80 fb 19             	cmp    $0x19,%bl
  801f4f:	77 29                	ja     801f7a <strtol+0xb3>
			dig = *s - 'a' + 10;
  801f51:	0f be d2             	movsbl %dl,%edx
  801f54:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801f57:	3b 55 10             	cmp    0x10(%ebp),%edx
  801f5a:	7d 30                	jge    801f8c <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  801f5c:	83 c1 01             	add    $0x1,%ecx
  801f5f:	0f af 45 10          	imul   0x10(%ebp),%eax
  801f63:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801f65:	0f b6 11             	movzbl (%ecx),%edx
  801f68:	8d 72 d0             	lea    -0x30(%edx),%esi
  801f6b:	89 f3                	mov    %esi,%ebx
  801f6d:	80 fb 09             	cmp    $0x9,%bl
  801f70:	77 d5                	ja     801f47 <strtol+0x80>
			dig = *s - '0';
  801f72:	0f be d2             	movsbl %dl,%edx
  801f75:	83 ea 30             	sub    $0x30,%edx
  801f78:	eb dd                	jmp    801f57 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  801f7a:	8d 72 bf             	lea    -0x41(%edx),%esi
  801f7d:	89 f3                	mov    %esi,%ebx
  801f7f:	80 fb 19             	cmp    $0x19,%bl
  801f82:	77 08                	ja     801f8c <strtol+0xc5>
			dig = *s - 'A' + 10;
  801f84:	0f be d2             	movsbl %dl,%edx
  801f87:	83 ea 37             	sub    $0x37,%edx
  801f8a:	eb cb                	jmp    801f57 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  801f8c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801f90:	74 05                	je     801f97 <strtol+0xd0>
		*endptr = (char *) s;
  801f92:	8b 75 0c             	mov    0xc(%ebp),%esi
  801f95:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801f97:	89 c2                	mov    %eax,%edx
  801f99:	f7 da                	neg    %edx
  801f9b:	85 ff                	test   %edi,%edi
  801f9d:	0f 45 c2             	cmovne %edx,%eax
}
  801fa0:	5b                   	pop    %ebx
  801fa1:	5e                   	pop    %esi
  801fa2:	5f                   	pop    %edi
  801fa3:	5d                   	pop    %ebp
  801fa4:	c3                   	ret    

00801fa5 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801fa5:	55                   	push   %ebp
  801fa6:	89 e5                	mov    %esp,%ebp
  801fa8:	56                   	push   %esi
  801fa9:	53                   	push   %ebx
  801faa:	8b 75 08             	mov    0x8(%ebp),%esi
  801fad:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fb0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
  801fb3:	85 c0                	test   %eax,%eax
	    pg = (void *)UTOP;
  801fb5:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801fba:	0f 44 c2             	cmove  %edx,%eax
	}
	if ((r = sys_ipc_recv(pg)) < 0) {
  801fbd:	83 ec 0c             	sub    $0xc,%esp
  801fc0:	50                   	push   %eax
  801fc1:	e8 6b e3 ff ff       	call   800331 <sys_ipc_recv>
  801fc6:	83 c4 10             	add    $0x10,%esp
  801fc9:	85 c0                	test   %eax,%eax
  801fcb:	78 2b                	js     801ff8 <ipc_recv+0x53>
	    if (perm_store != NULL) {
	        *perm_store = 0;
	    }
	    return r;
	}
	if (from_env_store != NULL) {
  801fcd:	85 f6                	test   %esi,%esi
  801fcf:	74 0a                	je     801fdb <ipc_recv+0x36>
	    *from_env_store = thisenv->env_ipc_from;
  801fd1:	a1 08 40 80 00       	mov    0x804008,%eax
  801fd6:	8b 40 74             	mov    0x74(%eax),%eax
  801fd9:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store != NULL) {
  801fdb:	85 db                	test   %ebx,%ebx
  801fdd:	74 0a                	je     801fe9 <ipc_recv+0x44>
	    *perm_store = thisenv->env_ipc_perm;
  801fdf:	a1 08 40 80 00       	mov    0x804008,%eax
  801fe4:	8b 40 78             	mov    0x78(%eax),%eax
  801fe7:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  801fe9:	a1 08 40 80 00       	mov    0x804008,%eax
  801fee:	8b 40 70             	mov    0x70(%eax),%eax
}
  801ff1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ff4:	5b                   	pop    %ebx
  801ff5:	5e                   	pop    %esi
  801ff6:	5d                   	pop    %ebp
  801ff7:	c3                   	ret    
	    if (from_env_store != NULL) {
  801ff8:	85 f6                	test   %esi,%esi
  801ffa:	74 06                	je     802002 <ipc_recv+0x5d>
	        *from_env_store = 0;
  801ffc:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	    if (perm_store != NULL) {
  802002:	85 db                	test   %ebx,%ebx
  802004:	74 eb                	je     801ff1 <ipc_recv+0x4c>
	        *perm_store = 0;
  802006:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80200c:	eb e3                	jmp    801ff1 <ipc_recv+0x4c>

0080200e <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80200e:	55                   	push   %ebp
  80200f:	89 e5                	mov    %esp,%ebp
  802011:	57                   	push   %edi
  802012:	56                   	push   %esi
  802013:	53                   	push   %ebx
  802014:	83 ec 0c             	sub    $0xc,%esp
  802017:	8b 7d 08             	mov    0x8(%ebp),%edi
  80201a:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
	    pg = (void *)UTOP;
  80201d:	85 f6                	test   %esi,%esi
  80201f:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802024:	0f 44 f0             	cmove  %eax,%esi
  802027:	eb 09                	jmp    802032 <ipc_send+0x24>
	do {
	    r = sys_ipc_try_send(to_env, val, pg, perm);
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
	        panic("ipc_send: %e", r);
	    }
	    sys_yield();
  802029:	e8 34 e1 ff ff       	call   800162 <sys_yield>
	} while(r != 0);
  80202e:	85 db                	test   %ebx,%ebx
  802030:	74 2d                	je     80205f <ipc_send+0x51>
	    r = sys_ipc_try_send(to_env, val, pg, perm);
  802032:	ff 75 14             	pushl  0x14(%ebp)
  802035:	56                   	push   %esi
  802036:	ff 75 0c             	pushl  0xc(%ebp)
  802039:	57                   	push   %edi
  80203a:	e8 cf e2 ff ff       	call   80030e <sys_ipc_try_send>
  80203f:	89 c3                	mov    %eax,%ebx
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
  802041:	83 c4 10             	add    $0x10,%esp
  802044:	85 c0                	test   %eax,%eax
  802046:	79 e1                	jns    802029 <ipc_send+0x1b>
  802048:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80204b:	74 dc                	je     802029 <ipc_send+0x1b>
	        panic("ipc_send: %e", r);
  80204d:	50                   	push   %eax
  80204e:	68 e0 27 80 00       	push   $0x8027e0
  802053:	6a 45                	push   $0x45
  802055:	68 ed 27 80 00       	push   $0x8027ed
  80205a:	e8 91 f4 ff ff       	call   8014f0 <_panic>
}
  80205f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802062:	5b                   	pop    %ebx
  802063:	5e                   	pop    %esi
  802064:	5f                   	pop    %edi
  802065:	5d                   	pop    %ebp
  802066:	c3                   	ret    

00802067 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802067:	55                   	push   %ebp
  802068:	89 e5                	mov    %esp,%ebp
  80206a:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80206d:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802072:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802075:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80207b:	8b 52 50             	mov    0x50(%edx),%edx
  80207e:	39 ca                	cmp    %ecx,%edx
  802080:	74 11                	je     802093 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  802082:	83 c0 01             	add    $0x1,%eax
  802085:	3d 00 04 00 00       	cmp    $0x400,%eax
  80208a:	75 e6                	jne    802072 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80208c:	b8 00 00 00 00       	mov    $0x0,%eax
  802091:	eb 0b                	jmp    80209e <ipc_find_env+0x37>
			return envs[i].env_id;
  802093:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802096:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80209b:	8b 40 48             	mov    0x48(%eax),%eax
}
  80209e:	5d                   	pop    %ebp
  80209f:	c3                   	ret    

008020a0 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8020a0:	55                   	push   %ebp
  8020a1:	89 e5                	mov    %esp,%ebp
  8020a3:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8020a6:	89 d0                	mov    %edx,%eax
  8020a8:	c1 e8 16             	shr    $0x16,%eax
  8020ab:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8020b2:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8020b7:	f6 c1 01             	test   $0x1,%cl
  8020ba:	74 1d                	je     8020d9 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8020bc:	c1 ea 0c             	shr    $0xc,%edx
  8020bf:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8020c6:	f6 c2 01             	test   $0x1,%dl
  8020c9:	74 0e                	je     8020d9 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8020cb:	c1 ea 0c             	shr    $0xc,%edx
  8020ce:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8020d5:	ef 
  8020d6:	0f b7 c0             	movzwl %ax,%eax
}
  8020d9:	5d                   	pop    %ebp
  8020da:	c3                   	ret    
  8020db:	66 90                	xchg   %ax,%ax
  8020dd:	66 90                	xchg   %ax,%ax
  8020df:	90                   	nop

008020e0 <__udivdi3>:
  8020e0:	55                   	push   %ebp
  8020e1:	57                   	push   %edi
  8020e2:	56                   	push   %esi
  8020e3:	53                   	push   %ebx
  8020e4:	83 ec 1c             	sub    $0x1c,%esp
  8020e7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8020eb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8020ef:	8b 74 24 34          	mov    0x34(%esp),%esi
  8020f3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8020f7:	85 d2                	test   %edx,%edx
  8020f9:	75 35                	jne    802130 <__udivdi3+0x50>
  8020fb:	39 f3                	cmp    %esi,%ebx
  8020fd:	0f 87 bd 00 00 00    	ja     8021c0 <__udivdi3+0xe0>
  802103:	85 db                	test   %ebx,%ebx
  802105:	89 d9                	mov    %ebx,%ecx
  802107:	75 0b                	jne    802114 <__udivdi3+0x34>
  802109:	b8 01 00 00 00       	mov    $0x1,%eax
  80210e:	31 d2                	xor    %edx,%edx
  802110:	f7 f3                	div    %ebx
  802112:	89 c1                	mov    %eax,%ecx
  802114:	31 d2                	xor    %edx,%edx
  802116:	89 f0                	mov    %esi,%eax
  802118:	f7 f1                	div    %ecx
  80211a:	89 c6                	mov    %eax,%esi
  80211c:	89 e8                	mov    %ebp,%eax
  80211e:	89 f7                	mov    %esi,%edi
  802120:	f7 f1                	div    %ecx
  802122:	89 fa                	mov    %edi,%edx
  802124:	83 c4 1c             	add    $0x1c,%esp
  802127:	5b                   	pop    %ebx
  802128:	5e                   	pop    %esi
  802129:	5f                   	pop    %edi
  80212a:	5d                   	pop    %ebp
  80212b:	c3                   	ret    
  80212c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802130:	39 f2                	cmp    %esi,%edx
  802132:	77 7c                	ja     8021b0 <__udivdi3+0xd0>
  802134:	0f bd fa             	bsr    %edx,%edi
  802137:	83 f7 1f             	xor    $0x1f,%edi
  80213a:	0f 84 98 00 00 00    	je     8021d8 <__udivdi3+0xf8>
  802140:	89 f9                	mov    %edi,%ecx
  802142:	b8 20 00 00 00       	mov    $0x20,%eax
  802147:	29 f8                	sub    %edi,%eax
  802149:	d3 e2                	shl    %cl,%edx
  80214b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80214f:	89 c1                	mov    %eax,%ecx
  802151:	89 da                	mov    %ebx,%edx
  802153:	d3 ea                	shr    %cl,%edx
  802155:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802159:	09 d1                	or     %edx,%ecx
  80215b:	89 f2                	mov    %esi,%edx
  80215d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802161:	89 f9                	mov    %edi,%ecx
  802163:	d3 e3                	shl    %cl,%ebx
  802165:	89 c1                	mov    %eax,%ecx
  802167:	d3 ea                	shr    %cl,%edx
  802169:	89 f9                	mov    %edi,%ecx
  80216b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80216f:	d3 e6                	shl    %cl,%esi
  802171:	89 eb                	mov    %ebp,%ebx
  802173:	89 c1                	mov    %eax,%ecx
  802175:	d3 eb                	shr    %cl,%ebx
  802177:	09 de                	or     %ebx,%esi
  802179:	89 f0                	mov    %esi,%eax
  80217b:	f7 74 24 08          	divl   0x8(%esp)
  80217f:	89 d6                	mov    %edx,%esi
  802181:	89 c3                	mov    %eax,%ebx
  802183:	f7 64 24 0c          	mull   0xc(%esp)
  802187:	39 d6                	cmp    %edx,%esi
  802189:	72 0c                	jb     802197 <__udivdi3+0xb7>
  80218b:	89 f9                	mov    %edi,%ecx
  80218d:	d3 e5                	shl    %cl,%ebp
  80218f:	39 c5                	cmp    %eax,%ebp
  802191:	73 5d                	jae    8021f0 <__udivdi3+0x110>
  802193:	39 d6                	cmp    %edx,%esi
  802195:	75 59                	jne    8021f0 <__udivdi3+0x110>
  802197:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80219a:	31 ff                	xor    %edi,%edi
  80219c:	89 fa                	mov    %edi,%edx
  80219e:	83 c4 1c             	add    $0x1c,%esp
  8021a1:	5b                   	pop    %ebx
  8021a2:	5e                   	pop    %esi
  8021a3:	5f                   	pop    %edi
  8021a4:	5d                   	pop    %ebp
  8021a5:	c3                   	ret    
  8021a6:	8d 76 00             	lea    0x0(%esi),%esi
  8021a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  8021b0:	31 ff                	xor    %edi,%edi
  8021b2:	31 c0                	xor    %eax,%eax
  8021b4:	89 fa                	mov    %edi,%edx
  8021b6:	83 c4 1c             	add    $0x1c,%esp
  8021b9:	5b                   	pop    %ebx
  8021ba:	5e                   	pop    %esi
  8021bb:	5f                   	pop    %edi
  8021bc:	5d                   	pop    %ebp
  8021bd:	c3                   	ret    
  8021be:	66 90                	xchg   %ax,%ax
  8021c0:	31 ff                	xor    %edi,%edi
  8021c2:	89 e8                	mov    %ebp,%eax
  8021c4:	89 f2                	mov    %esi,%edx
  8021c6:	f7 f3                	div    %ebx
  8021c8:	89 fa                	mov    %edi,%edx
  8021ca:	83 c4 1c             	add    $0x1c,%esp
  8021cd:	5b                   	pop    %ebx
  8021ce:	5e                   	pop    %esi
  8021cf:	5f                   	pop    %edi
  8021d0:	5d                   	pop    %ebp
  8021d1:	c3                   	ret    
  8021d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8021d8:	39 f2                	cmp    %esi,%edx
  8021da:	72 06                	jb     8021e2 <__udivdi3+0x102>
  8021dc:	31 c0                	xor    %eax,%eax
  8021de:	39 eb                	cmp    %ebp,%ebx
  8021e0:	77 d2                	ja     8021b4 <__udivdi3+0xd4>
  8021e2:	b8 01 00 00 00       	mov    $0x1,%eax
  8021e7:	eb cb                	jmp    8021b4 <__udivdi3+0xd4>
  8021e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8021f0:	89 d8                	mov    %ebx,%eax
  8021f2:	31 ff                	xor    %edi,%edi
  8021f4:	eb be                	jmp    8021b4 <__udivdi3+0xd4>
  8021f6:	66 90                	xchg   %ax,%ax
  8021f8:	66 90                	xchg   %ax,%ax
  8021fa:	66 90                	xchg   %ax,%ax
  8021fc:	66 90                	xchg   %ax,%ax
  8021fe:	66 90                	xchg   %ax,%ax

00802200 <__umoddi3>:
  802200:	55                   	push   %ebp
  802201:	57                   	push   %edi
  802202:	56                   	push   %esi
  802203:	53                   	push   %ebx
  802204:	83 ec 1c             	sub    $0x1c,%esp
  802207:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  80220b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80220f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802213:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802217:	85 ed                	test   %ebp,%ebp
  802219:	89 f0                	mov    %esi,%eax
  80221b:	89 da                	mov    %ebx,%edx
  80221d:	75 19                	jne    802238 <__umoddi3+0x38>
  80221f:	39 df                	cmp    %ebx,%edi
  802221:	0f 86 b1 00 00 00    	jbe    8022d8 <__umoddi3+0xd8>
  802227:	f7 f7                	div    %edi
  802229:	89 d0                	mov    %edx,%eax
  80222b:	31 d2                	xor    %edx,%edx
  80222d:	83 c4 1c             	add    $0x1c,%esp
  802230:	5b                   	pop    %ebx
  802231:	5e                   	pop    %esi
  802232:	5f                   	pop    %edi
  802233:	5d                   	pop    %ebp
  802234:	c3                   	ret    
  802235:	8d 76 00             	lea    0x0(%esi),%esi
  802238:	39 dd                	cmp    %ebx,%ebp
  80223a:	77 f1                	ja     80222d <__umoddi3+0x2d>
  80223c:	0f bd cd             	bsr    %ebp,%ecx
  80223f:	83 f1 1f             	xor    $0x1f,%ecx
  802242:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802246:	0f 84 b4 00 00 00    	je     802300 <__umoddi3+0x100>
  80224c:	b8 20 00 00 00       	mov    $0x20,%eax
  802251:	89 c2                	mov    %eax,%edx
  802253:	8b 44 24 04          	mov    0x4(%esp),%eax
  802257:	29 c2                	sub    %eax,%edx
  802259:	89 c1                	mov    %eax,%ecx
  80225b:	89 f8                	mov    %edi,%eax
  80225d:	d3 e5                	shl    %cl,%ebp
  80225f:	89 d1                	mov    %edx,%ecx
  802261:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802265:	d3 e8                	shr    %cl,%eax
  802267:	09 c5                	or     %eax,%ebp
  802269:	8b 44 24 04          	mov    0x4(%esp),%eax
  80226d:	89 c1                	mov    %eax,%ecx
  80226f:	d3 e7                	shl    %cl,%edi
  802271:	89 d1                	mov    %edx,%ecx
  802273:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802277:	89 df                	mov    %ebx,%edi
  802279:	d3 ef                	shr    %cl,%edi
  80227b:	89 c1                	mov    %eax,%ecx
  80227d:	89 f0                	mov    %esi,%eax
  80227f:	d3 e3                	shl    %cl,%ebx
  802281:	89 d1                	mov    %edx,%ecx
  802283:	89 fa                	mov    %edi,%edx
  802285:	d3 e8                	shr    %cl,%eax
  802287:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80228c:	09 d8                	or     %ebx,%eax
  80228e:	f7 f5                	div    %ebp
  802290:	d3 e6                	shl    %cl,%esi
  802292:	89 d1                	mov    %edx,%ecx
  802294:	f7 64 24 08          	mull   0x8(%esp)
  802298:	39 d1                	cmp    %edx,%ecx
  80229a:	89 c3                	mov    %eax,%ebx
  80229c:	89 d7                	mov    %edx,%edi
  80229e:	72 06                	jb     8022a6 <__umoddi3+0xa6>
  8022a0:	75 0e                	jne    8022b0 <__umoddi3+0xb0>
  8022a2:	39 c6                	cmp    %eax,%esi
  8022a4:	73 0a                	jae    8022b0 <__umoddi3+0xb0>
  8022a6:	2b 44 24 08          	sub    0x8(%esp),%eax
  8022aa:	19 ea                	sbb    %ebp,%edx
  8022ac:	89 d7                	mov    %edx,%edi
  8022ae:	89 c3                	mov    %eax,%ebx
  8022b0:	89 ca                	mov    %ecx,%edx
  8022b2:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  8022b7:	29 de                	sub    %ebx,%esi
  8022b9:	19 fa                	sbb    %edi,%edx
  8022bb:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  8022bf:	89 d0                	mov    %edx,%eax
  8022c1:	d3 e0                	shl    %cl,%eax
  8022c3:	89 d9                	mov    %ebx,%ecx
  8022c5:	d3 ee                	shr    %cl,%esi
  8022c7:	d3 ea                	shr    %cl,%edx
  8022c9:	09 f0                	or     %esi,%eax
  8022cb:	83 c4 1c             	add    $0x1c,%esp
  8022ce:	5b                   	pop    %ebx
  8022cf:	5e                   	pop    %esi
  8022d0:	5f                   	pop    %edi
  8022d1:	5d                   	pop    %ebp
  8022d2:	c3                   	ret    
  8022d3:	90                   	nop
  8022d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8022d8:	85 ff                	test   %edi,%edi
  8022da:	89 f9                	mov    %edi,%ecx
  8022dc:	75 0b                	jne    8022e9 <__umoddi3+0xe9>
  8022de:	b8 01 00 00 00       	mov    $0x1,%eax
  8022e3:	31 d2                	xor    %edx,%edx
  8022e5:	f7 f7                	div    %edi
  8022e7:	89 c1                	mov    %eax,%ecx
  8022e9:	89 d8                	mov    %ebx,%eax
  8022eb:	31 d2                	xor    %edx,%edx
  8022ed:	f7 f1                	div    %ecx
  8022ef:	89 f0                	mov    %esi,%eax
  8022f1:	f7 f1                	div    %ecx
  8022f3:	e9 31 ff ff ff       	jmp    802229 <__umoddi3+0x29>
  8022f8:	90                   	nop
  8022f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802300:	39 dd                	cmp    %ebx,%ebp
  802302:	72 08                	jb     80230c <__umoddi3+0x10c>
  802304:	39 f7                	cmp    %esi,%edi
  802306:	0f 87 21 ff ff ff    	ja     80222d <__umoddi3+0x2d>
  80230c:	89 da                	mov    %ebx,%edx
  80230e:	89 f0                	mov    %esi,%eax
  802310:	29 f8                	sub    %edi,%eax
  802312:	19 ea                	sbb    %ebp,%edx
  802314:	e9 14 ff ff ff       	jmp    80222d <__umoddi3+0x2d>
