
obj/user/badsegment.debug:     file format elf32-i386


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
  80002c:	e8 0d 00 00 00       	call   80003e <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
	// Try to load the kernel's TSS selector into the DS register.
	asm volatile("movw $0x28,%ax; movw %ax,%ds");
  800036:	66 b8 28 00          	mov    $0x28,%ax
  80003a:	8e d8                	mov    %eax,%ds
}
  80003c:	5d                   	pop    %ebp
  80003d:	c3                   	ret    

0080003e <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80003e:	55                   	push   %ebp
  80003f:	89 e5                	mov    %esp,%ebp
  800041:	56                   	push   %esi
  800042:	53                   	push   %ebx
  800043:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800046:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
    thisenv = &envs[ENVX(sys_getenvid())];
  800049:	e8 ce 00 00 00       	call   80011c <sys_getenvid>
  80004e:	25 ff 03 00 00       	and    $0x3ff,%eax
  800053:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800056:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80005b:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800060:	85 db                	test   %ebx,%ebx
  800062:	7e 07                	jle    80006b <libmain+0x2d>
		binaryname = argv[0];
  800064:	8b 06                	mov    (%esi),%eax
  800066:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80006b:	83 ec 08             	sub    $0x8,%esp
  80006e:	56                   	push   %esi
  80006f:	53                   	push   %ebx
  800070:	e8 be ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800075:	e8 0a 00 00 00       	call   800084 <exit>
}
  80007a:	83 c4 10             	add    $0x10,%esp
  80007d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800080:	5b                   	pop    %ebx
  800081:	5e                   	pop    %esi
  800082:	5d                   	pop    %ebp
  800083:	c3                   	ret    

00800084 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800084:	55                   	push   %ebp
  800085:	89 e5                	mov    %esp,%ebp
  800087:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80008a:	e8 b1 04 00 00       	call   800540 <close_all>
	sys_env_destroy(0);
  80008f:	83 ec 0c             	sub    $0xc,%esp
  800092:	6a 00                	push   $0x0
  800094:	e8 42 00 00 00       	call   8000db <sys_env_destroy>
}
  800099:	83 c4 10             	add    $0x10,%esp
  80009c:	c9                   	leave  
  80009d:	c3                   	ret    

0080009e <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  80009e:	55                   	push   %ebp
  80009f:	89 e5                	mov    %esp,%ebp
  8000a1:	57                   	push   %edi
  8000a2:	56                   	push   %esi
  8000a3:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8000ac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000af:	89 c3                	mov    %eax,%ebx
  8000b1:	89 c7                	mov    %eax,%edi
  8000b3:	89 c6                	mov    %eax,%esi
  8000b5:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000b7:	5b                   	pop    %ebx
  8000b8:	5e                   	pop    %esi
  8000b9:	5f                   	pop    %edi
  8000ba:	5d                   	pop    %ebp
  8000bb:	c3                   	ret    

008000bc <sys_cgetc>:

int
sys_cgetc(void)
{
  8000bc:	55                   	push   %ebp
  8000bd:	89 e5                	mov    %esp,%ebp
  8000bf:	57                   	push   %edi
  8000c0:	56                   	push   %esi
  8000c1:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8000c7:	b8 01 00 00 00       	mov    $0x1,%eax
  8000cc:	89 d1                	mov    %edx,%ecx
  8000ce:	89 d3                	mov    %edx,%ebx
  8000d0:	89 d7                	mov    %edx,%edi
  8000d2:	89 d6                	mov    %edx,%esi
  8000d4:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000d6:	5b                   	pop    %ebx
  8000d7:	5e                   	pop    %esi
  8000d8:	5f                   	pop    %edi
  8000d9:	5d                   	pop    %ebp
  8000da:	c3                   	ret    

008000db <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000db:	55                   	push   %ebp
  8000dc:	89 e5                	mov    %esp,%ebp
  8000de:	57                   	push   %edi
  8000df:	56                   	push   %esi
  8000e0:	53                   	push   %ebx
  8000e1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8000e4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8000ec:	b8 03 00 00 00       	mov    $0x3,%eax
  8000f1:	89 cb                	mov    %ecx,%ebx
  8000f3:	89 cf                	mov    %ecx,%edi
  8000f5:	89 ce                	mov    %ecx,%esi
  8000f7:	cd 30                	int    $0x30
	if(check && ret > 0)
  8000f9:	85 c0                	test   %eax,%eax
  8000fb:	7f 08                	jg     800105 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8000fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800100:	5b                   	pop    %ebx
  800101:	5e                   	pop    %esi
  800102:	5f                   	pop    %edi
  800103:	5d                   	pop    %ebp
  800104:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800105:	83 ec 0c             	sub    $0xc,%esp
  800108:	50                   	push   %eax
  800109:	6a 03                	push   $0x3
  80010b:	68 0a 23 80 00       	push   $0x80230a
  800110:	6a 23                	push   $0x23
  800112:	68 27 23 80 00       	push   $0x802327
  800117:	e8 ad 13 00 00       	call   8014c9 <_panic>

0080011c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80011c:	55                   	push   %ebp
  80011d:	89 e5                	mov    %esp,%ebp
  80011f:	57                   	push   %edi
  800120:	56                   	push   %esi
  800121:	53                   	push   %ebx
	asm volatile("int %1\n"
  800122:	ba 00 00 00 00       	mov    $0x0,%edx
  800127:	b8 02 00 00 00       	mov    $0x2,%eax
  80012c:	89 d1                	mov    %edx,%ecx
  80012e:	89 d3                	mov    %edx,%ebx
  800130:	89 d7                	mov    %edx,%edi
  800132:	89 d6                	mov    %edx,%esi
  800134:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800136:	5b                   	pop    %ebx
  800137:	5e                   	pop    %esi
  800138:	5f                   	pop    %edi
  800139:	5d                   	pop    %ebp
  80013a:	c3                   	ret    

0080013b <sys_yield>:

void
sys_yield(void)
{
  80013b:	55                   	push   %ebp
  80013c:	89 e5                	mov    %esp,%ebp
  80013e:	57                   	push   %edi
  80013f:	56                   	push   %esi
  800140:	53                   	push   %ebx
	asm volatile("int %1\n"
  800141:	ba 00 00 00 00       	mov    $0x0,%edx
  800146:	b8 0b 00 00 00       	mov    $0xb,%eax
  80014b:	89 d1                	mov    %edx,%ecx
  80014d:	89 d3                	mov    %edx,%ebx
  80014f:	89 d7                	mov    %edx,%edi
  800151:	89 d6                	mov    %edx,%esi
  800153:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800155:	5b                   	pop    %ebx
  800156:	5e                   	pop    %esi
  800157:	5f                   	pop    %edi
  800158:	5d                   	pop    %ebp
  800159:	c3                   	ret    

0080015a <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80015a:	55                   	push   %ebp
  80015b:	89 e5                	mov    %esp,%ebp
  80015d:	57                   	push   %edi
  80015e:	56                   	push   %esi
  80015f:	53                   	push   %ebx
  800160:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800163:	be 00 00 00 00       	mov    $0x0,%esi
  800168:	8b 55 08             	mov    0x8(%ebp),%edx
  80016b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80016e:	b8 04 00 00 00       	mov    $0x4,%eax
  800173:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800176:	89 f7                	mov    %esi,%edi
  800178:	cd 30                	int    $0x30
	if(check && ret > 0)
  80017a:	85 c0                	test   %eax,%eax
  80017c:	7f 08                	jg     800186 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80017e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800181:	5b                   	pop    %ebx
  800182:	5e                   	pop    %esi
  800183:	5f                   	pop    %edi
  800184:	5d                   	pop    %ebp
  800185:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800186:	83 ec 0c             	sub    $0xc,%esp
  800189:	50                   	push   %eax
  80018a:	6a 04                	push   $0x4
  80018c:	68 0a 23 80 00       	push   $0x80230a
  800191:	6a 23                	push   $0x23
  800193:	68 27 23 80 00       	push   $0x802327
  800198:	e8 2c 13 00 00       	call   8014c9 <_panic>

0080019d <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80019d:	55                   	push   %ebp
  80019e:	89 e5                	mov    %esp,%ebp
  8001a0:	57                   	push   %edi
  8001a1:	56                   	push   %esi
  8001a2:	53                   	push   %ebx
  8001a3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8001a9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001ac:	b8 05 00 00 00       	mov    $0x5,%eax
  8001b1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001b4:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001b7:	8b 75 18             	mov    0x18(%ebp),%esi
  8001ba:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001bc:	85 c0                	test   %eax,%eax
  8001be:	7f 08                	jg     8001c8 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001c3:	5b                   	pop    %ebx
  8001c4:	5e                   	pop    %esi
  8001c5:	5f                   	pop    %edi
  8001c6:	5d                   	pop    %ebp
  8001c7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001c8:	83 ec 0c             	sub    $0xc,%esp
  8001cb:	50                   	push   %eax
  8001cc:	6a 05                	push   $0x5
  8001ce:	68 0a 23 80 00       	push   $0x80230a
  8001d3:	6a 23                	push   $0x23
  8001d5:	68 27 23 80 00       	push   $0x802327
  8001da:	e8 ea 12 00 00       	call   8014c9 <_panic>

008001df <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001df:	55                   	push   %ebp
  8001e0:	89 e5                	mov    %esp,%ebp
  8001e2:	57                   	push   %edi
  8001e3:	56                   	push   %esi
  8001e4:	53                   	push   %ebx
  8001e5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001e8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8001f0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001f3:	b8 06 00 00 00       	mov    $0x6,%eax
  8001f8:	89 df                	mov    %ebx,%edi
  8001fa:	89 de                	mov    %ebx,%esi
  8001fc:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001fe:	85 c0                	test   %eax,%eax
  800200:	7f 08                	jg     80020a <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800202:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800205:	5b                   	pop    %ebx
  800206:	5e                   	pop    %esi
  800207:	5f                   	pop    %edi
  800208:	5d                   	pop    %ebp
  800209:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80020a:	83 ec 0c             	sub    $0xc,%esp
  80020d:	50                   	push   %eax
  80020e:	6a 06                	push   $0x6
  800210:	68 0a 23 80 00       	push   $0x80230a
  800215:	6a 23                	push   $0x23
  800217:	68 27 23 80 00       	push   $0x802327
  80021c:	e8 a8 12 00 00       	call   8014c9 <_panic>

00800221 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800221:	55                   	push   %ebp
  800222:	89 e5                	mov    %esp,%ebp
  800224:	57                   	push   %edi
  800225:	56                   	push   %esi
  800226:	53                   	push   %ebx
  800227:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80022a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80022f:	8b 55 08             	mov    0x8(%ebp),%edx
  800232:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800235:	b8 08 00 00 00       	mov    $0x8,%eax
  80023a:	89 df                	mov    %ebx,%edi
  80023c:	89 de                	mov    %ebx,%esi
  80023e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800240:	85 c0                	test   %eax,%eax
  800242:	7f 08                	jg     80024c <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800244:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800247:	5b                   	pop    %ebx
  800248:	5e                   	pop    %esi
  800249:	5f                   	pop    %edi
  80024a:	5d                   	pop    %ebp
  80024b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80024c:	83 ec 0c             	sub    $0xc,%esp
  80024f:	50                   	push   %eax
  800250:	6a 08                	push   $0x8
  800252:	68 0a 23 80 00       	push   $0x80230a
  800257:	6a 23                	push   $0x23
  800259:	68 27 23 80 00       	push   $0x802327
  80025e:	e8 66 12 00 00       	call   8014c9 <_panic>

00800263 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800263:	55                   	push   %ebp
  800264:	89 e5                	mov    %esp,%ebp
  800266:	57                   	push   %edi
  800267:	56                   	push   %esi
  800268:	53                   	push   %ebx
  800269:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80026c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800271:	8b 55 08             	mov    0x8(%ebp),%edx
  800274:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800277:	b8 09 00 00 00       	mov    $0x9,%eax
  80027c:	89 df                	mov    %ebx,%edi
  80027e:	89 de                	mov    %ebx,%esi
  800280:	cd 30                	int    $0x30
	if(check && ret > 0)
  800282:	85 c0                	test   %eax,%eax
  800284:	7f 08                	jg     80028e <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800286:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800289:	5b                   	pop    %ebx
  80028a:	5e                   	pop    %esi
  80028b:	5f                   	pop    %edi
  80028c:	5d                   	pop    %ebp
  80028d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80028e:	83 ec 0c             	sub    $0xc,%esp
  800291:	50                   	push   %eax
  800292:	6a 09                	push   $0x9
  800294:	68 0a 23 80 00       	push   $0x80230a
  800299:	6a 23                	push   $0x23
  80029b:	68 27 23 80 00       	push   $0x802327
  8002a0:	e8 24 12 00 00       	call   8014c9 <_panic>

008002a5 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002a5:	55                   	push   %ebp
  8002a6:	89 e5                	mov    %esp,%ebp
  8002a8:	57                   	push   %edi
  8002a9:	56                   	push   %esi
  8002aa:	53                   	push   %ebx
  8002ab:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002ae:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8002b6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002b9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002be:	89 df                	mov    %ebx,%edi
  8002c0:	89 de                	mov    %ebx,%esi
  8002c2:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002c4:	85 c0                	test   %eax,%eax
  8002c6:	7f 08                	jg     8002d0 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8002c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002cb:	5b                   	pop    %ebx
  8002cc:	5e                   	pop    %esi
  8002cd:	5f                   	pop    %edi
  8002ce:	5d                   	pop    %ebp
  8002cf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002d0:	83 ec 0c             	sub    $0xc,%esp
  8002d3:	50                   	push   %eax
  8002d4:	6a 0a                	push   $0xa
  8002d6:	68 0a 23 80 00       	push   $0x80230a
  8002db:	6a 23                	push   $0x23
  8002dd:	68 27 23 80 00       	push   $0x802327
  8002e2:	e8 e2 11 00 00       	call   8014c9 <_panic>

008002e7 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8002e7:	55                   	push   %ebp
  8002e8:	89 e5                	mov    %esp,%ebp
  8002ea:	57                   	push   %edi
  8002eb:	56                   	push   %esi
  8002ec:	53                   	push   %ebx
	asm volatile("int %1\n"
  8002ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8002f0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002f3:	b8 0c 00 00 00       	mov    $0xc,%eax
  8002f8:	be 00 00 00 00       	mov    $0x0,%esi
  8002fd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800300:	8b 7d 14             	mov    0x14(%ebp),%edi
  800303:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800305:	5b                   	pop    %ebx
  800306:	5e                   	pop    %esi
  800307:	5f                   	pop    %edi
  800308:	5d                   	pop    %ebp
  800309:	c3                   	ret    

0080030a <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80030a:	55                   	push   %ebp
  80030b:	89 e5                	mov    %esp,%ebp
  80030d:	57                   	push   %edi
  80030e:	56                   	push   %esi
  80030f:	53                   	push   %ebx
  800310:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800313:	b9 00 00 00 00       	mov    $0x0,%ecx
  800318:	8b 55 08             	mov    0x8(%ebp),%edx
  80031b:	b8 0d 00 00 00       	mov    $0xd,%eax
  800320:	89 cb                	mov    %ecx,%ebx
  800322:	89 cf                	mov    %ecx,%edi
  800324:	89 ce                	mov    %ecx,%esi
  800326:	cd 30                	int    $0x30
	if(check && ret > 0)
  800328:	85 c0                	test   %eax,%eax
  80032a:	7f 08                	jg     800334 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80032c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80032f:	5b                   	pop    %ebx
  800330:	5e                   	pop    %esi
  800331:	5f                   	pop    %edi
  800332:	5d                   	pop    %ebp
  800333:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800334:	83 ec 0c             	sub    $0xc,%esp
  800337:	50                   	push   %eax
  800338:	6a 0d                	push   $0xd
  80033a:	68 0a 23 80 00       	push   $0x80230a
  80033f:	6a 23                	push   $0x23
  800341:	68 27 23 80 00       	push   $0x802327
  800346:	e8 7e 11 00 00       	call   8014c9 <_panic>

0080034b <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80034b:	55                   	push   %ebp
  80034c:	89 e5                	mov    %esp,%ebp
  80034e:	57                   	push   %edi
  80034f:	56                   	push   %esi
  800350:	53                   	push   %ebx
	asm volatile("int %1\n"
  800351:	ba 00 00 00 00       	mov    $0x0,%edx
  800356:	b8 0e 00 00 00       	mov    $0xe,%eax
  80035b:	89 d1                	mov    %edx,%ecx
  80035d:	89 d3                	mov    %edx,%ebx
  80035f:	89 d7                	mov    %edx,%edi
  800361:	89 d6                	mov    %edx,%esi
  800363:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800365:	5b                   	pop    %ebx
  800366:	5e                   	pop    %esi
  800367:	5f                   	pop    %edi
  800368:	5d                   	pop    %ebp
  800369:	c3                   	ret    

0080036a <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80036a:	55                   	push   %ebp
  80036b:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80036d:	8b 45 08             	mov    0x8(%ebp),%eax
  800370:	05 00 00 00 30       	add    $0x30000000,%eax
  800375:	c1 e8 0c             	shr    $0xc,%eax
}
  800378:	5d                   	pop    %ebp
  800379:	c3                   	ret    

0080037a <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80037a:	55                   	push   %ebp
  80037b:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80037d:	8b 45 08             	mov    0x8(%ebp),%eax
  800380:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800385:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80038a:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80038f:	5d                   	pop    %ebp
  800390:	c3                   	ret    

00800391 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800391:	55                   	push   %ebp
  800392:	89 e5                	mov    %esp,%ebp
  800394:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800397:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80039c:	89 c2                	mov    %eax,%edx
  80039e:	c1 ea 16             	shr    $0x16,%edx
  8003a1:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8003a8:	f6 c2 01             	test   $0x1,%dl
  8003ab:	74 2a                	je     8003d7 <fd_alloc+0x46>
  8003ad:	89 c2                	mov    %eax,%edx
  8003af:	c1 ea 0c             	shr    $0xc,%edx
  8003b2:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8003b9:	f6 c2 01             	test   $0x1,%dl
  8003bc:	74 19                	je     8003d7 <fd_alloc+0x46>
  8003be:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8003c3:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8003c8:	75 d2                	jne    80039c <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8003ca:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8003d0:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8003d5:	eb 07                	jmp    8003de <fd_alloc+0x4d>
			*fd_store = fd;
  8003d7:	89 01                	mov    %eax,(%ecx)
			return 0;
  8003d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8003de:	5d                   	pop    %ebp
  8003df:	c3                   	ret    

008003e0 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8003e0:	55                   	push   %ebp
  8003e1:	89 e5                	mov    %esp,%ebp
  8003e3:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8003e6:	83 f8 1f             	cmp    $0x1f,%eax
  8003e9:	77 36                	ja     800421 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8003eb:	c1 e0 0c             	shl    $0xc,%eax
  8003ee:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8003f3:	89 c2                	mov    %eax,%edx
  8003f5:	c1 ea 16             	shr    $0x16,%edx
  8003f8:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8003ff:	f6 c2 01             	test   $0x1,%dl
  800402:	74 24                	je     800428 <fd_lookup+0x48>
  800404:	89 c2                	mov    %eax,%edx
  800406:	c1 ea 0c             	shr    $0xc,%edx
  800409:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800410:	f6 c2 01             	test   $0x1,%dl
  800413:	74 1a                	je     80042f <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800415:	8b 55 0c             	mov    0xc(%ebp),%edx
  800418:	89 02                	mov    %eax,(%edx)
	return 0;
  80041a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80041f:	5d                   	pop    %ebp
  800420:	c3                   	ret    
		return -E_INVAL;
  800421:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800426:	eb f7                	jmp    80041f <fd_lookup+0x3f>
		return -E_INVAL;
  800428:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80042d:	eb f0                	jmp    80041f <fd_lookup+0x3f>
  80042f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800434:	eb e9                	jmp    80041f <fd_lookup+0x3f>

00800436 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800436:	55                   	push   %ebp
  800437:	89 e5                	mov    %esp,%ebp
  800439:	83 ec 08             	sub    $0x8,%esp
  80043c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80043f:	ba b4 23 80 00       	mov    $0x8023b4,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800444:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800449:	39 08                	cmp    %ecx,(%eax)
  80044b:	74 33                	je     800480 <dev_lookup+0x4a>
  80044d:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800450:	8b 02                	mov    (%edx),%eax
  800452:	85 c0                	test   %eax,%eax
  800454:	75 f3                	jne    800449 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800456:	a1 08 40 80 00       	mov    0x804008,%eax
  80045b:	8b 40 48             	mov    0x48(%eax),%eax
  80045e:	83 ec 04             	sub    $0x4,%esp
  800461:	51                   	push   %ecx
  800462:	50                   	push   %eax
  800463:	68 38 23 80 00       	push   $0x802338
  800468:	e8 37 11 00 00       	call   8015a4 <cprintf>
	*dev = 0;
  80046d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800470:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800476:	83 c4 10             	add    $0x10,%esp
  800479:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80047e:	c9                   	leave  
  80047f:	c3                   	ret    
			*dev = devtab[i];
  800480:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800483:	89 01                	mov    %eax,(%ecx)
			return 0;
  800485:	b8 00 00 00 00       	mov    $0x0,%eax
  80048a:	eb f2                	jmp    80047e <dev_lookup+0x48>

0080048c <fd_close>:
{
  80048c:	55                   	push   %ebp
  80048d:	89 e5                	mov    %esp,%ebp
  80048f:	57                   	push   %edi
  800490:	56                   	push   %esi
  800491:	53                   	push   %ebx
  800492:	83 ec 1c             	sub    $0x1c,%esp
  800495:	8b 75 08             	mov    0x8(%ebp),%esi
  800498:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80049b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80049e:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80049f:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8004a5:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8004a8:	50                   	push   %eax
  8004a9:	e8 32 ff ff ff       	call   8003e0 <fd_lookup>
  8004ae:	89 c3                	mov    %eax,%ebx
  8004b0:	83 c4 08             	add    $0x8,%esp
  8004b3:	85 c0                	test   %eax,%eax
  8004b5:	78 05                	js     8004bc <fd_close+0x30>
	    || fd != fd2)
  8004b7:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8004ba:	74 16                	je     8004d2 <fd_close+0x46>
		return (must_exist ? r : 0);
  8004bc:	89 f8                	mov    %edi,%eax
  8004be:	84 c0                	test   %al,%al
  8004c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8004c5:	0f 44 d8             	cmove  %eax,%ebx
}
  8004c8:	89 d8                	mov    %ebx,%eax
  8004ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004cd:	5b                   	pop    %ebx
  8004ce:	5e                   	pop    %esi
  8004cf:	5f                   	pop    %edi
  8004d0:	5d                   	pop    %ebp
  8004d1:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8004d2:	83 ec 08             	sub    $0x8,%esp
  8004d5:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8004d8:	50                   	push   %eax
  8004d9:	ff 36                	pushl  (%esi)
  8004db:	e8 56 ff ff ff       	call   800436 <dev_lookup>
  8004e0:	89 c3                	mov    %eax,%ebx
  8004e2:	83 c4 10             	add    $0x10,%esp
  8004e5:	85 c0                	test   %eax,%eax
  8004e7:	78 15                	js     8004fe <fd_close+0x72>
		if (dev->dev_close)
  8004e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004ec:	8b 40 10             	mov    0x10(%eax),%eax
  8004ef:	85 c0                	test   %eax,%eax
  8004f1:	74 1b                	je     80050e <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  8004f3:	83 ec 0c             	sub    $0xc,%esp
  8004f6:	56                   	push   %esi
  8004f7:	ff d0                	call   *%eax
  8004f9:	89 c3                	mov    %eax,%ebx
  8004fb:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8004fe:	83 ec 08             	sub    $0x8,%esp
  800501:	56                   	push   %esi
  800502:	6a 00                	push   $0x0
  800504:	e8 d6 fc ff ff       	call   8001df <sys_page_unmap>
	return r;
  800509:	83 c4 10             	add    $0x10,%esp
  80050c:	eb ba                	jmp    8004c8 <fd_close+0x3c>
			r = 0;
  80050e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800513:	eb e9                	jmp    8004fe <fd_close+0x72>

00800515 <close>:

int
close(int fdnum)
{
  800515:	55                   	push   %ebp
  800516:	89 e5                	mov    %esp,%ebp
  800518:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80051b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80051e:	50                   	push   %eax
  80051f:	ff 75 08             	pushl  0x8(%ebp)
  800522:	e8 b9 fe ff ff       	call   8003e0 <fd_lookup>
  800527:	83 c4 08             	add    $0x8,%esp
  80052a:	85 c0                	test   %eax,%eax
  80052c:	78 10                	js     80053e <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  80052e:	83 ec 08             	sub    $0x8,%esp
  800531:	6a 01                	push   $0x1
  800533:	ff 75 f4             	pushl  -0xc(%ebp)
  800536:	e8 51 ff ff ff       	call   80048c <fd_close>
  80053b:	83 c4 10             	add    $0x10,%esp
}
  80053e:	c9                   	leave  
  80053f:	c3                   	ret    

00800540 <close_all>:

void
close_all(void)
{
  800540:	55                   	push   %ebp
  800541:	89 e5                	mov    %esp,%ebp
  800543:	53                   	push   %ebx
  800544:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800547:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80054c:	83 ec 0c             	sub    $0xc,%esp
  80054f:	53                   	push   %ebx
  800550:	e8 c0 ff ff ff       	call   800515 <close>
	for (i = 0; i < MAXFD; i++)
  800555:	83 c3 01             	add    $0x1,%ebx
  800558:	83 c4 10             	add    $0x10,%esp
  80055b:	83 fb 20             	cmp    $0x20,%ebx
  80055e:	75 ec                	jne    80054c <close_all+0xc>
}
  800560:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800563:	c9                   	leave  
  800564:	c3                   	ret    

00800565 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800565:	55                   	push   %ebp
  800566:	89 e5                	mov    %esp,%ebp
  800568:	57                   	push   %edi
  800569:	56                   	push   %esi
  80056a:	53                   	push   %ebx
  80056b:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80056e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800571:	50                   	push   %eax
  800572:	ff 75 08             	pushl  0x8(%ebp)
  800575:	e8 66 fe ff ff       	call   8003e0 <fd_lookup>
  80057a:	89 c3                	mov    %eax,%ebx
  80057c:	83 c4 08             	add    $0x8,%esp
  80057f:	85 c0                	test   %eax,%eax
  800581:	0f 88 81 00 00 00    	js     800608 <dup+0xa3>
		return r;
	close(newfdnum);
  800587:	83 ec 0c             	sub    $0xc,%esp
  80058a:	ff 75 0c             	pushl  0xc(%ebp)
  80058d:	e8 83 ff ff ff       	call   800515 <close>

	newfd = INDEX2FD(newfdnum);
  800592:	8b 75 0c             	mov    0xc(%ebp),%esi
  800595:	c1 e6 0c             	shl    $0xc,%esi
  800598:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80059e:	83 c4 04             	add    $0x4,%esp
  8005a1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8005a4:	e8 d1 fd ff ff       	call   80037a <fd2data>
  8005a9:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8005ab:	89 34 24             	mov    %esi,(%esp)
  8005ae:	e8 c7 fd ff ff       	call   80037a <fd2data>
  8005b3:	83 c4 10             	add    $0x10,%esp
  8005b6:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8005b8:	89 d8                	mov    %ebx,%eax
  8005ba:	c1 e8 16             	shr    $0x16,%eax
  8005bd:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8005c4:	a8 01                	test   $0x1,%al
  8005c6:	74 11                	je     8005d9 <dup+0x74>
  8005c8:	89 d8                	mov    %ebx,%eax
  8005ca:	c1 e8 0c             	shr    $0xc,%eax
  8005cd:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8005d4:	f6 c2 01             	test   $0x1,%dl
  8005d7:	75 39                	jne    800612 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8005d9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8005dc:	89 d0                	mov    %edx,%eax
  8005de:	c1 e8 0c             	shr    $0xc,%eax
  8005e1:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8005e8:	83 ec 0c             	sub    $0xc,%esp
  8005eb:	25 07 0e 00 00       	and    $0xe07,%eax
  8005f0:	50                   	push   %eax
  8005f1:	56                   	push   %esi
  8005f2:	6a 00                	push   $0x0
  8005f4:	52                   	push   %edx
  8005f5:	6a 00                	push   $0x0
  8005f7:	e8 a1 fb ff ff       	call   80019d <sys_page_map>
  8005fc:	89 c3                	mov    %eax,%ebx
  8005fe:	83 c4 20             	add    $0x20,%esp
  800601:	85 c0                	test   %eax,%eax
  800603:	78 31                	js     800636 <dup+0xd1>
		goto err;

	return newfdnum;
  800605:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  800608:	89 d8                	mov    %ebx,%eax
  80060a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80060d:	5b                   	pop    %ebx
  80060e:	5e                   	pop    %esi
  80060f:	5f                   	pop    %edi
  800610:	5d                   	pop    %ebp
  800611:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800612:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800619:	83 ec 0c             	sub    $0xc,%esp
  80061c:	25 07 0e 00 00       	and    $0xe07,%eax
  800621:	50                   	push   %eax
  800622:	57                   	push   %edi
  800623:	6a 00                	push   $0x0
  800625:	53                   	push   %ebx
  800626:	6a 00                	push   $0x0
  800628:	e8 70 fb ff ff       	call   80019d <sys_page_map>
  80062d:	89 c3                	mov    %eax,%ebx
  80062f:	83 c4 20             	add    $0x20,%esp
  800632:	85 c0                	test   %eax,%eax
  800634:	79 a3                	jns    8005d9 <dup+0x74>
	sys_page_unmap(0, newfd);
  800636:	83 ec 08             	sub    $0x8,%esp
  800639:	56                   	push   %esi
  80063a:	6a 00                	push   $0x0
  80063c:	e8 9e fb ff ff       	call   8001df <sys_page_unmap>
	sys_page_unmap(0, nva);
  800641:	83 c4 08             	add    $0x8,%esp
  800644:	57                   	push   %edi
  800645:	6a 00                	push   $0x0
  800647:	e8 93 fb ff ff       	call   8001df <sys_page_unmap>
	return r;
  80064c:	83 c4 10             	add    $0x10,%esp
  80064f:	eb b7                	jmp    800608 <dup+0xa3>

00800651 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800651:	55                   	push   %ebp
  800652:	89 e5                	mov    %esp,%ebp
  800654:	53                   	push   %ebx
  800655:	83 ec 14             	sub    $0x14,%esp
  800658:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80065b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80065e:	50                   	push   %eax
  80065f:	53                   	push   %ebx
  800660:	e8 7b fd ff ff       	call   8003e0 <fd_lookup>
  800665:	83 c4 08             	add    $0x8,%esp
  800668:	85 c0                	test   %eax,%eax
  80066a:	78 3f                	js     8006ab <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80066c:	83 ec 08             	sub    $0x8,%esp
  80066f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800672:	50                   	push   %eax
  800673:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800676:	ff 30                	pushl  (%eax)
  800678:	e8 b9 fd ff ff       	call   800436 <dev_lookup>
  80067d:	83 c4 10             	add    $0x10,%esp
  800680:	85 c0                	test   %eax,%eax
  800682:	78 27                	js     8006ab <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800684:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800687:	8b 42 08             	mov    0x8(%edx),%eax
  80068a:	83 e0 03             	and    $0x3,%eax
  80068d:	83 f8 01             	cmp    $0x1,%eax
  800690:	74 1e                	je     8006b0 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  800692:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800695:	8b 40 08             	mov    0x8(%eax),%eax
  800698:	85 c0                	test   %eax,%eax
  80069a:	74 35                	je     8006d1 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80069c:	83 ec 04             	sub    $0x4,%esp
  80069f:	ff 75 10             	pushl  0x10(%ebp)
  8006a2:	ff 75 0c             	pushl  0xc(%ebp)
  8006a5:	52                   	push   %edx
  8006a6:	ff d0                	call   *%eax
  8006a8:	83 c4 10             	add    $0x10,%esp
}
  8006ab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006ae:	c9                   	leave  
  8006af:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8006b0:	a1 08 40 80 00       	mov    0x804008,%eax
  8006b5:	8b 40 48             	mov    0x48(%eax),%eax
  8006b8:	83 ec 04             	sub    $0x4,%esp
  8006bb:	53                   	push   %ebx
  8006bc:	50                   	push   %eax
  8006bd:	68 79 23 80 00       	push   $0x802379
  8006c2:	e8 dd 0e 00 00       	call   8015a4 <cprintf>
		return -E_INVAL;
  8006c7:	83 c4 10             	add    $0x10,%esp
  8006ca:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8006cf:	eb da                	jmp    8006ab <read+0x5a>
		return -E_NOT_SUPP;
  8006d1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8006d6:	eb d3                	jmp    8006ab <read+0x5a>

008006d8 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8006d8:	55                   	push   %ebp
  8006d9:	89 e5                	mov    %esp,%ebp
  8006db:	57                   	push   %edi
  8006dc:	56                   	push   %esi
  8006dd:	53                   	push   %ebx
  8006de:	83 ec 0c             	sub    $0xc,%esp
  8006e1:	8b 7d 08             	mov    0x8(%ebp),%edi
  8006e4:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8006e7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006ec:	39 f3                	cmp    %esi,%ebx
  8006ee:	73 25                	jae    800715 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8006f0:	83 ec 04             	sub    $0x4,%esp
  8006f3:	89 f0                	mov    %esi,%eax
  8006f5:	29 d8                	sub    %ebx,%eax
  8006f7:	50                   	push   %eax
  8006f8:	89 d8                	mov    %ebx,%eax
  8006fa:	03 45 0c             	add    0xc(%ebp),%eax
  8006fd:	50                   	push   %eax
  8006fe:	57                   	push   %edi
  8006ff:	e8 4d ff ff ff       	call   800651 <read>
		if (m < 0)
  800704:	83 c4 10             	add    $0x10,%esp
  800707:	85 c0                	test   %eax,%eax
  800709:	78 08                	js     800713 <readn+0x3b>
			return m;
		if (m == 0)
  80070b:	85 c0                	test   %eax,%eax
  80070d:	74 06                	je     800715 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  80070f:	01 c3                	add    %eax,%ebx
  800711:	eb d9                	jmp    8006ec <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800713:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  800715:	89 d8                	mov    %ebx,%eax
  800717:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80071a:	5b                   	pop    %ebx
  80071b:	5e                   	pop    %esi
  80071c:	5f                   	pop    %edi
  80071d:	5d                   	pop    %ebp
  80071e:	c3                   	ret    

0080071f <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80071f:	55                   	push   %ebp
  800720:	89 e5                	mov    %esp,%ebp
  800722:	53                   	push   %ebx
  800723:	83 ec 14             	sub    $0x14,%esp
  800726:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800729:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80072c:	50                   	push   %eax
  80072d:	53                   	push   %ebx
  80072e:	e8 ad fc ff ff       	call   8003e0 <fd_lookup>
  800733:	83 c4 08             	add    $0x8,%esp
  800736:	85 c0                	test   %eax,%eax
  800738:	78 3a                	js     800774 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80073a:	83 ec 08             	sub    $0x8,%esp
  80073d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800740:	50                   	push   %eax
  800741:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800744:	ff 30                	pushl  (%eax)
  800746:	e8 eb fc ff ff       	call   800436 <dev_lookup>
  80074b:	83 c4 10             	add    $0x10,%esp
  80074e:	85 c0                	test   %eax,%eax
  800750:	78 22                	js     800774 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800752:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800755:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800759:	74 1e                	je     800779 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80075b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80075e:	8b 52 0c             	mov    0xc(%edx),%edx
  800761:	85 d2                	test   %edx,%edx
  800763:	74 35                	je     80079a <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  800765:	83 ec 04             	sub    $0x4,%esp
  800768:	ff 75 10             	pushl  0x10(%ebp)
  80076b:	ff 75 0c             	pushl  0xc(%ebp)
  80076e:	50                   	push   %eax
  80076f:	ff d2                	call   *%edx
  800771:	83 c4 10             	add    $0x10,%esp
}
  800774:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800777:	c9                   	leave  
  800778:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800779:	a1 08 40 80 00       	mov    0x804008,%eax
  80077e:	8b 40 48             	mov    0x48(%eax),%eax
  800781:	83 ec 04             	sub    $0x4,%esp
  800784:	53                   	push   %ebx
  800785:	50                   	push   %eax
  800786:	68 95 23 80 00       	push   $0x802395
  80078b:	e8 14 0e 00 00       	call   8015a4 <cprintf>
		return -E_INVAL;
  800790:	83 c4 10             	add    $0x10,%esp
  800793:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800798:	eb da                	jmp    800774 <write+0x55>
		return -E_NOT_SUPP;
  80079a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80079f:	eb d3                	jmp    800774 <write+0x55>

008007a1 <seek>:

int
seek(int fdnum, off_t offset)
{
  8007a1:	55                   	push   %ebp
  8007a2:	89 e5                	mov    %esp,%ebp
  8007a4:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8007a7:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8007aa:	50                   	push   %eax
  8007ab:	ff 75 08             	pushl  0x8(%ebp)
  8007ae:	e8 2d fc ff ff       	call   8003e0 <fd_lookup>
  8007b3:	83 c4 08             	add    $0x8,%esp
  8007b6:	85 c0                	test   %eax,%eax
  8007b8:	78 0e                	js     8007c8 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8007ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8007c0:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8007c3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8007c8:	c9                   	leave  
  8007c9:	c3                   	ret    

008007ca <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8007ca:	55                   	push   %ebp
  8007cb:	89 e5                	mov    %esp,%ebp
  8007cd:	53                   	push   %ebx
  8007ce:	83 ec 14             	sub    $0x14,%esp
  8007d1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8007d4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8007d7:	50                   	push   %eax
  8007d8:	53                   	push   %ebx
  8007d9:	e8 02 fc ff ff       	call   8003e0 <fd_lookup>
  8007de:	83 c4 08             	add    $0x8,%esp
  8007e1:	85 c0                	test   %eax,%eax
  8007e3:	78 37                	js     80081c <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8007e5:	83 ec 08             	sub    $0x8,%esp
  8007e8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8007eb:	50                   	push   %eax
  8007ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007ef:	ff 30                	pushl  (%eax)
  8007f1:	e8 40 fc ff ff       	call   800436 <dev_lookup>
  8007f6:	83 c4 10             	add    $0x10,%esp
  8007f9:	85 c0                	test   %eax,%eax
  8007fb:	78 1f                	js     80081c <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8007fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800800:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800804:	74 1b                	je     800821 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  800806:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800809:	8b 52 18             	mov    0x18(%edx),%edx
  80080c:	85 d2                	test   %edx,%edx
  80080e:	74 32                	je     800842 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  800810:	83 ec 08             	sub    $0x8,%esp
  800813:	ff 75 0c             	pushl  0xc(%ebp)
  800816:	50                   	push   %eax
  800817:	ff d2                	call   *%edx
  800819:	83 c4 10             	add    $0x10,%esp
}
  80081c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80081f:	c9                   	leave  
  800820:	c3                   	ret    
			thisenv->env_id, fdnum);
  800821:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800826:	8b 40 48             	mov    0x48(%eax),%eax
  800829:	83 ec 04             	sub    $0x4,%esp
  80082c:	53                   	push   %ebx
  80082d:	50                   	push   %eax
  80082e:	68 58 23 80 00       	push   $0x802358
  800833:	e8 6c 0d 00 00       	call   8015a4 <cprintf>
		return -E_INVAL;
  800838:	83 c4 10             	add    $0x10,%esp
  80083b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800840:	eb da                	jmp    80081c <ftruncate+0x52>
		return -E_NOT_SUPP;
  800842:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800847:	eb d3                	jmp    80081c <ftruncate+0x52>

00800849 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800849:	55                   	push   %ebp
  80084a:	89 e5                	mov    %esp,%ebp
  80084c:	53                   	push   %ebx
  80084d:	83 ec 14             	sub    $0x14,%esp
  800850:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800853:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800856:	50                   	push   %eax
  800857:	ff 75 08             	pushl  0x8(%ebp)
  80085a:	e8 81 fb ff ff       	call   8003e0 <fd_lookup>
  80085f:	83 c4 08             	add    $0x8,%esp
  800862:	85 c0                	test   %eax,%eax
  800864:	78 4b                	js     8008b1 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800866:	83 ec 08             	sub    $0x8,%esp
  800869:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80086c:	50                   	push   %eax
  80086d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800870:	ff 30                	pushl  (%eax)
  800872:	e8 bf fb ff ff       	call   800436 <dev_lookup>
  800877:	83 c4 10             	add    $0x10,%esp
  80087a:	85 c0                	test   %eax,%eax
  80087c:	78 33                	js     8008b1 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80087e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800881:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  800885:	74 2f                	je     8008b6 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800887:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80088a:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  800891:	00 00 00 
	stat->st_isdir = 0;
  800894:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80089b:	00 00 00 
	stat->st_dev = dev;
  80089e:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8008a4:	83 ec 08             	sub    $0x8,%esp
  8008a7:	53                   	push   %ebx
  8008a8:	ff 75 f0             	pushl  -0x10(%ebp)
  8008ab:	ff 50 14             	call   *0x14(%eax)
  8008ae:	83 c4 10             	add    $0x10,%esp
}
  8008b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008b4:	c9                   	leave  
  8008b5:	c3                   	ret    
		return -E_NOT_SUPP;
  8008b6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8008bb:	eb f4                	jmp    8008b1 <fstat+0x68>

008008bd <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8008bd:	55                   	push   %ebp
  8008be:	89 e5                	mov    %esp,%ebp
  8008c0:	56                   	push   %esi
  8008c1:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8008c2:	83 ec 08             	sub    $0x8,%esp
  8008c5:	6a 00                	push   $0x0
  8008c7:	ff 75 08             	pushl  0x8(%ebp)
  8008ca:	e8 26 02 00 00       	call   800af5 <open>
  8008cf:	89 c3                	mov    %eax,%ebx
  8008d1:	83 c4 10             	add    $0x10,%esp
  8008d4:	85 c0                	test   %eax,%eax
  8008d6:	78 1b                	js     8008f3 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8008d8:	83 ec 08             	sub    $0x8,%esp
  8008db:	ff 75 0c             	pushl  0xc(%ebp)
  8008de:	50                   	push   %eax
  8008df:	e8 65 ff ff ff       	call   800849 <fstat>
  8008e4:	89 c6                	mov    %eax,%esi
	close(fd);
  8008e6:	89 1c 24             	mov    %ebx,(%esp)
  8008e9:	e8 27 fc ff ff       	call   800515 <close>
	return r;
  8008ee:	83 c4 10             	add    $0x10,%esp
  8008f1:	89 f3                	mov    %esi,%ebx
}
  8008f3:	89 d8                	mov    %ebx,%eax
  8008f5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008f8:	5b                   	pop    %ebx
  8008f9:	5e                   	pop    %esi
  8008fa:	5d                   	pop    %ebp
  8008fb:	c3                   	ret    

008008fc <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8008fc:	55                   	push   %ebp
  8008fd:	89 e5                	mov    %esp,%ebp
  8008ff:	56                   	push   %esi
  800900:	53                   	push   %ebx
  800901:	89 c6                	mov    %eax,%esi
  800903:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  800905:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80090c:	74 27                	je     800935 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80090e:	6a 07                	push   $0x7
  800910:	68 00 50 80 00       	push   $0x805000
  800915:	56                   	push   %esi
  800916:	ff 35 00 40 80 00    	pushl  0x804000
  80091c:	e8 c6 16 00 00       	call   801fe7 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  800921:	83 c4 0c             	add    $0xc,%esp
  800924:	6a 00                	push   $0x0
  800926:	53                   	push   %ebx
  800927:	6a 00                	push   $0x0
  800929:	e8 50 16 00 00       	call   801f7e <ipc_recv>
}
  80092e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800931:	5b                   	pop    %ebx
  800932:	5e                   	pop    %esi
  800933:	5d                   	pop    %ebp
  800934:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800935:	83 ec 0c             	sub    $0xc,%esp
  800938:	6a 01                	push   $0x1
  80093a:	e8 01 17 00 00       	call   802040 <ipc_find_env>
  80093f:	a3 00 40 80 00       	mov    %eax,0x804000
  800944:	83 c4 10             	add    $0x10,%esp
  800947:	eb c5                	jmp    80090e <fsipc+0x12>

00800949 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  800949:	55                   	push   %ebp
  80094a:	89 e5                	mov    %esp,%ebp
  80094c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80094f:	8b 45 08             	mov    0x8(%ebp),%eax
  800952:	8b 40 0c             	mov    0xc(%eax),%eax
  800955:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80095a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80095d:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  800962:	ba 00 00 00 00       	mov    $0x0,%edx
  800967:	b8 02 00 00 00       	mov    $0x2,%eax
  80096c:	e8 8b ff ff ff       	call   8008fc <fsipc>
}
  800971:	c9                   	leave  
  800972:	c3                   	ret    

00800973 <devfile_flush>:
{
  800973:	55                   	push   %ebp
  800974:	89 e5                	mov    %esp,%ebp
  800976:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800979:	8b 45 08             	mov    0x8(%ebp),%eax
  80097c:	8b 40 0c             	mov    0xc(%eax),%eax
  80097f:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800984:	ba 00 00 00 00       	mov    $0x0,%edx
  800989:	b8 06 00 00 00       	mov    $0x6,%eax
  80098e:	e8 69 ff ff ff       	call   8008fc <fsipc>
}
  800993:	c9                   	leave  
  800994:	c3                   	ret    

00800995 <devfile_stat>:
{
  800995:	55                   	push   %ebp
  800996:	89 e5                	mov    %esp,%ebp
  800998:	53                   	push   %ebx
  800999:	83 ec 04             	sub    $0x4,%esp
  80099c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80099f:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a2:	8b 40 0c             	mov    0xc(%eax),%eax
  8009a5:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8009aa:	ba 00 00 00 00       	mov    $0x0,%edx
  8009af:	b8 05 00 00 00       	mov    $0x5,%eax
  8009b4:	e8 43 ff ff ff       	call   8008fc <fsipc>
  8009b9:	85 c0                	test   %eax,%eax
  8009bb:	78 2c                	js     8009e9 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8009bd:	83 ec 08             	sub    $0x8,%esp
  8009c0:	68 00 50 80 00       	push   $0x805000
  8009c5:	53                   	push   %ebx
  8009c6:	e8 76 12 00 00       	call   801c41 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8009cb:	a1 80 50 80 00       	mov    0x805080,%eax
  8009d0:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8009d6:	a1 84 50 80 00       	mov    0x805084,%eax
  8009db:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8009e1:	83 c4 10             	add    $0x10,%esp
  8009e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009e9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009ec:	c9                   	leave  
  8009ed:	c3                   	ret    

008009ee <devfile_write>:
{
  8009ee:	55                   	push   %ebp
  8009ef:	89 e5                	mov    %esp,%ebp
  8009f1:	53                   	push   %ebx
  8009f2:	83 ec 04             	sub    $0x4,%esp
  8009f5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8009f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fb:	8b 40 0c             	mov    0xc(%eax),%eax
  8009fe:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  800a03:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  800a09:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  800a0f:	77 30                	ja     800a41 <devfile_write+0x53>
	memmove(fsipcbuf.write.req_buf, buf, n);
  800a11:	83 ec 04             	sub    $0x4,%esp
  800a14:	53                   	push   %ebx
  800a15:	ff 75 0c             	pushl  0xc(%ebp)
  800a18:	68 08 50 80 00       	push   $0x805008
  800a1d:	e8 ad 13 00 00       	call   801dcf <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  800a22:	ba 00 00 00 00       	mov    $0x0,%edx
  800a27:	b8 04 00 00 00       	mov    $0x4,%eax
  800a2c:	e8 cb fe ff ff       	call   8008fc <fsipc>
  800a31:	83 c4 10             	add    $0x10,%esp
  800a34:	85 c0                	test   %eax,%eax
  800a36:	78 04                	js     800a3c <devfile_write+0x4e>
	assert(r <= n);
  800a38:	39 d8                	cmp    %ebx,%eax
  800a3a:	77 1e                	ja     800a5a <devfile_write+0x6c>
}
  800a3c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a3f:	c9                   	leave  
  800a40:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  800a41:	68 c8 23 80 00       	push   $0x8023c8
  800a46:	68 f5 23 80 00       	push   $0x8023f5
  800a4b:	68 94 00 00 00       	push   $0x94
  800a50:	68 0a 24 80 00       	push   $0x80240a
  800a55:	e8 6f 0a 00 00       	call   8014c9 <_panic>
	assert(r <= n);
  800a5a:	68 15 24 80 00       	push   $0x802415
  800a5f:	68 f5 23 80 00       	push   $0x8023f5
  800a64:	68 98 00 00 00       	push   $0x98
  800a69:	68 0a 24 80 00       	push   $0x80240a
  800a6e:	e8 56 0a 00 00       	call   8014c9 <_panic>

00800a73 <devfile_read>:
{
  800a73:	55                   	push   %ebp
  800a74:	89 e5                	mov    %esp,%ebp
  800a76:	56                   	push   %esi
  800a77:	53                   	push   %ebx
  800a78:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7e:	8b 40 0c             	mov    0xc(%eax),%eax
  800a81:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800a86:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800a8c:	ba 00 00 00 00       	mov    $0x0,%edx
  800a91:	b8 03 00 00 00       	mov    $0x3,%eax
  800a96:	e8 61 fe ff ff       	call   8008fc <fsipc>
  800a9b:	89 c3                	mov    %eax,%ebx
  800a9d:	85 c0                	test   %eax,%eax
  800a9f:	78 1f                	js     800ac0 <devfile_read+0x4d>
	assert(r <= n);
  800aa1:	39 f0                	cmp    %esi,%eax
  800aa3:	77 24                	ja     800ac9 <devfile_read+0x56>
	assert(r <= PGSIZE);
  800aa5:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800aaa:	7f 33                	jg     800adf <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800aac:	83 ec 04             	sub    $0x4,%esp
  800aaf:	50                   	push   %eax
  800ab0:	68 00 50 80 00       	push   $0x805000
  800ab5:	ff 75 0c             	pushl  0xc(%ebp)
  800ab8:	e8 12 13 00 00       	call   801dcf <memmove>
	return r;
  800abd:	83 c4 10             	add    $0x10,%esp
}
  800ac0:	89 d8                	mov    %ebx,%eax
  800ac2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ac5:	5b                   	pop    %ebx
  800ac6:	5e                   	pop    %esi
  800ac7:	5d                   	pop    %ebp
  800ac8:	c3                   	ret    
	assert(r <= n);
  800ac9:	68 15 24 80 00       	push   $0x802415
  800ace:	68 f5 23 80 00       	push   $0x8023f5
  800ad3:	6a 7c                	push   $0x7c
  800ad5:	68 0a 24 80 00       	push   $0x80240a
  800ada:	e8 ea 09 00 00       	call   8014c9 <_panic>
	assert(r <= PGSIZE);
  800adf:	68 1c 24 80 00       	push   $0x80241c
  800ae4:	68 f5 23 80 00       	push   $0x8023f5
  800ae9:	6a 7d                	push   $0x7d
  800aeb:	68 0a 24 80 00       	push   $0x80240a
  800af0:	e8 d4 09 00 00       	call   8014c9 <_panic>

00800af5 <open>:
{
  800af5:	55                   	push   %ebp
  800af6:	89 e5                	mov    %esp,%ebp
  800af8:	56                   	push   %esi
  800af9:	53                   	push   %ebx
  800afa:	83 ec 1c             	sub    $0x1c,%esp
  800afd:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800b00:	56                   	push   %esi
  800b01:	e8 04 11 00 00       	call   801c0a <strlen>
  800b06:	83 c4 10             	add    $0x10,%esp
  800b09:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800b0e:	7f 6c                	jg     800b7c <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  800b10:	83 ec 0c             	sub    $0xc,%esp
  800b13:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800b16:	50                   	push   %eax
  800b17:	e8 75 f8 ff ff       	call   800391 <fd_alloc>
  800b1c:	89 c3                	mov    %eax,%ebx
  800b1e:	83 c4 10             	add    $0x10,%esp
  800b21:	85 c0                	test   %eax,%eax
  800b23:	78 3c                	js     800b61 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  800b25:	83 ec 08             	sub    $0x8,%esp
  800b28:	56                   	push   %esi
  800b29:	68 00 50 80 00       	push   $0x805000
  800b2e:	e8 0e 11 00 00       	call   801c41 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800b33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b36:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800b3b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b3e:	b8 01 00 00 00       	mov    $0x1,%eax
  800b43:	e8 b4 fd ff ff       	call   8008fc <fsipc>
  800b48:	89 c3                	mov    %eax,%ebx
  800b4a:	83 c4 10             	add    $0x10,%esp
  800b4d:	85 c0                	test   %eax,%eax
  800b4f:	78 19                	js     800b6a <open+0x75>
	return fd2num(fd);
  800b51:	83 ec 0c             	sub    $0xc,%esp
  800b54:	ff 75 f4             	pushl  -0xc(%ebp)
  800b57:	e8 0e f8 ff ff       	call   80036a <fd2num>
  800b5c:	89 c3                	mov    %eax,%ebx
  800b5e:	83 c4 10             	add    $0x10,%esp
}
  800b61:	89 d8                	mov    %ebx,%eax
  800b63:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b66:	5b                   	pop    %ebx
  800b67:	5e                   	pop    %esi
  800b68:	5d                   	pop    %ebp
  800b69:	c3                   	ret    
		fd_close(fd, 0);
  800b6a:	83 ec 08             	sub    $0x8,%esp
  800b6d:	6a 00                	push   $0x0
  800b6f:	ff 75 f4             	pushl  -0xc(%ebp)
  800b72:	e8 15 f9 ff ff       	call   80048c <fd_close>
		return r;
  800b77:	83 c4 10             	add    $0x10,%esp
  800b7a:	eb e5                	jmp    800b61 <open+0x6c>
		return -E_BAD_PATH;
  800b7c:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800b81:	eb de                	jmp    800b61 <open+0x6c>

00800b83 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800b83:	55                   	push   %ebp
  800b84:	89 e5                	mov    %esp,%ebp
  800b86:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800b89:	ba 00 00 00 00       	mov    $0x0,%edx
  800b8e:	b8 08 00 00 00       	mov    $0x8,%eax
  800b93:	e8 64 fd ff ff       	call   8008fc <fsipc>
}
  800b98:	c9                   	leave  
  800b99:	c3                   	ret    

00800b9a <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800b9a:	55                   	push   %ebp
  800b9b:	89 e5                	mov    %esp,%ebp
  800b9d:	56                   	push   %esi
  800b9e:	53                   	push   %ebx
  800b9f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800ba2:	83 ec 0c             	sub    $0xc,%esp
  800ba5:	ff 75 08             	pushl  0x8(%ebp)
  800ba8:	e8 cd f7 ff ff       	call   80037a <fd2data>
  800bad:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  800baf:	83 c4 08             	add    $0x8,%esp
  800bb2:	68 28 24 80 00       	push   $0x802428
  800bb7:	53                   	push   %ebx
  800bb8:	e8 84 10 00 00       	call   801c41 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  800bbd:	8b 46 04             	mov    0x4(%esi),%eax
  800bc0:	2b 06                	sub    (%esi),%eax
  800bc2:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  800bc8:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800bcf:	00 00 00 
	stat->st_dev = &devpipe;
  800bd2:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  800bd9:	30 80 00 
	return 0;
}
  800bdc:	b8 00 00 00 00       	mov    $0x0,%eax
  800be1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800be4:	5b                   	pop    %ebx
  800be5:	5e                   	pop    %esi
  800be6:	5d                   	pop    %ebp
  800be7:	c3                   	ret    

00800be8 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  800be8:	55                   	push   %ebp
  800be9:	89 e5                	mov    %esp,%ebp
  800beb:	53                   	push   %ebx
  800bec:	83 ec 0c             	sub    $0xc,%esp
  800bef:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  800bf2:	53                   	push   %ebx
  800bf3:	6a 00                	push   $0x0
  800bf5:	e8 e5 f5 ff ff       	call   8001df <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  800bfa:	89 1c 24             	mov    %ebx,(%esp)
  800bfd:	e8 78 f7 ff ff       	call   80037a <fd2data>
  800c02:	83 c4 08             	add    $0x8,%esp
  800c05:	50                   	push   %eax
  800c06:	6a 00                	push   $0x0
  800c08:	e8 d2 f5 ff ff       	call   8001df <sys_page_unmap>
}
  800c0d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c10:	c9                   	leave  
  800c11:	c3                   	ret    

00800c12 <_pipeisclosed>:
{
  800c12:	55                   	push   %ebp
  800c13:	89 e5                	mov    %esp,%ebp
  800c15:	57                   	push   %edi
  800c16:	56                   	push   %esi
  800c17:	53                   	push   %ebx
  800c18:	83 ec 1c             	sub    $0x1c,%esp
  800c1b:	89 c7                	mov    %eax,%edi
  800c1d:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  800c1f:	a1 08 40 80 00       	mov    0x804008,%eax
  800c24:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  800c27:	83 ec 0c             	sub    $0xc,%esp
  800c2a:	57                   	push   %edi
  800c2b:	e8 49 14 00 00       	call   802079 <pageref>
  800c30:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c33:	89 34 24             	mov    %esi,(%esp)
  800c36:	e8 3e 14 00 00       	call   802079 <pageref>
		nn = thisenv->env_runs;
  800c3b:	8b 15 08 40 80 00    	mov    0x804008,%edx
  800c41:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  800c44:	83 c4 10             	add    $0x10,%esp
  800c47:	39 cb                	cmp    %ecx,%ebx
  800c49:	74 1b                	je     800c66 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  800c4b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800c4e:	75 cf                	jne    800c1f <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  800c50:	8b 42 58             	mov    0x58(%edx),%eax
  800c53:	6a 01                	push   $0x1
  800c55:	50                   	push   %eax
  800c56:	53                   	push   %ebx
  800c57:	68 2f 24 80 00       	push   $0x80242f
  800c5c:	e8 43 09 00 00       	call   8015a4 <cprintf>
  800c61:	83 c4 10             	add    $0x10,%esp
  800c64:	eb b9                	jmp    800c1f <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  800c66:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800c69:	0f 94 c0             	sete   %al
  800c6c:	0f b6 c0             	movzbl %al,%eax
}
  800c6f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c72:	5b                   	pop    %ebx
  800c73:	5e                   	pop    %esi
  800c74:	5f                   	pop    %edi
  800c75:	5d                   	pop    %ebp
  800c76:	c3                   	ret    

00800c77 <devpipe_write>:
{
  800c77:	55                   	push   %ebp
  800c78:	89 e5                	mov    %esp,%ebp
  800c7a:	57                   	push   %edi
  800c7b:	56                   	push   %esi
  800c7c:	53                   	push   %ebx
  800c7d:	83 ec 28             	sub    $0x28,%esp
  800c80:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  800c83:	56                   	push   %esi
  800c84:	e8 f1 f6 ff ff       	call   80037a <fd2data>
  800c89:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800c8b:	83 c4 10             	add    $0x10,%esp
  800c8e:	bf 00 00 00 00       	mov    $0x0,%edi
  800c93:	3b 7d 10             	cmp    0x10(%ebp),%edi
  800c96:	74 4f                	je     800ce7 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  800c98:	8b 43 04             	mov    0x4(%ebx),%eax
  800c9b:	8b 0b                	mov    (%ebx),%ecx
  800c9d:	8d 51 20             	lea    0x20(%ecx),%edx
  800ca0:	39 d0                	cmp    %edx,%eax
  800ca2:	72 14                	jb     800cb8 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  800ca4:	89 da                	mov    %ebx,%edx
  800ca6:	89 f0                	mov    %esi,%eax
  800ca8:	e8 65 ff ff ff       	call   800c12 <_pipeisclosed>
  800cad:	85 c0                	test   %eax,%eax
  800caf:	75 3a                	jne    800ceb <devpipe_write+0x74>
			sys_yield();
  800cb1:	e8 85 f4 ff ff       	call   80013b <sys_yield>
  800cb6:	eb e0                	jmp    800c98 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  800cb8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cbb:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  800cbf:	88 4d e7             	mov    %cl,-0x19(%ebp)
  800cc2:	89 c2                	mov    %eax,%edx
  800cc4:	c1 fa 1f             	sar    $0x1f,%edx
  800cc7:	89 d1                	mov    %edx,%ecx
  800cc9:	c1 e9 1b             	shr    $0x1b,%ecx
  800ccc:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  800ccf:	83 e2 1f             	and    $0x1f,%edx
  800cd2:	29 ca                	sub    %ecx,%edx
  800cd4:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  800cd8:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  800cdc:	83 c0 01             	add    $0x1,%eax
  800cdf:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  800ce2:	83 c7 01             	add    $0x1,%edi
  800ce5:	eb ac                	jmp    800c93 <devpipe_write+0x1c>
	return i;
  800ce7:	89 f8                	mov    %edi,%eax
  800ce9:	eb 05                	jmp    800cf0 <devpipe_write+0x79>
				return 0;
  800ceb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cf0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cf3:	5b                   	pop    %ebx
  800cf4:	5e                   	pop    %esi
  800cf5:	5f                   	pop    %edi
  800cf6:	5d                   	pop    %ebp
  800cf7:	c3                   	ret    

00800cf8 <devpipe_read>:
{
  800cf8:	55                   	push   %ebp
  800cf9:	89 e5                	mov    %esp,%ebp
  800cfb:	57                   	push   %edi
  800cfc:	56                   	push   %esi
  800cfd:	53                   	push   %ebx
  800cfe:	83 ec 18             	sub    $0x18,%esp
  800d01:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  800d04:	57                   	push   %edi
  800d05:	e8 70 f6 ff ff       	call   80037a <fd2data>
  800d0a:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800d0c:	83 c4 10             	add    $0x10,%esp
  800d0f:	be 00 00 00 00       	mov    $0x0,%esi
  800d14:	3b 75 10             	cmp    0x10(%ebp),%esi
  800d17:	74 47                	je     800d60 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  800d19:	8b 03                	mov    (%ebx),%eax
  800d1b:	3b 43 04             	cmp    0x4(%ebx),%eax
  800d1e:	75 22                	jne    800d42 <devpipe_read+0x4a>
			if (i > 0)
  800d20:	85 f6                	test   %esi,%esi
  800d22:	75 14                	jne    800d38 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  800d24:	89 da                	mov    %ebx,%edx
  800d26:	89 f8                	mov    %edi,%eax
  800d28:	e8 e5 fe ff ff       	call   800c12 <_pipeisclosed>
  800d2d:	85 c0                	test   %eax,%eax
  800d2f:	75 33                	jne    800d64 <devpipe_read+0x6c>
			sys_yield();
  800d31:	e8 05 f4 ff ff       	call   80013b <sys_yield>
  800d36:	eb e1                	jmp    800d19 <devpipe_read+0x21>
				return i;
  800d38:	89 f0                	mov    %esi,%eax
}
  800d3a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d3d:	5b                   	pop    %ebx
  800d3e:	5e                   	pop    %esi
  800d3f:	5f                   	pop    %edi
  800d40:	5d                   	pop    %ebp
  800d41:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  800d42:	99                   	cltd   
  800d43:	c1 ea 1b             	shr    $0x1b,%edx
  800d46:	01 d0                	add    %edx,%eax
  800d48:	83 e0 1f             	and    $0x1f,%eax
  800d4b:	29 d0                	sub    %edx,%eax
  800d4d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  800d52:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d55:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  800d58:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  800d5b:	83 c6 01             	add    $0x1,%esi
  800d5e:	eb b4                	jmp    800d14 <devpipe_read+0x1c>
	return i;
  800d60:	89 f0                	mov    %esi,%eax
  800d62:	eb d6                	jmp    800d3a <devpipe_read+0x42>
				return 0;
  800d64:	b8 00 00 00 00       	mov    $0x0,%eax
  800d69:	eb cf                	jmp    800d3a <devpipe_read+0x42>

00800d6b <pipe>:
{
  800d6b:	55                   	push   %ebp
  800d6c:	89 e5                	mov    %esp,%ebp
  800d6e:	56                   	push   %esi
  800d6f:	53                   	push   %ebx
  800d70:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  800d73:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800d76:	50                   	push   %eax
  800d77:	e8 15 f6 ff ff       	call   800391 <fd_alloc>
  800d7c:	89 c3                	mov    %eax,%ebx
  800d7e:	83 c4 10             	add    $0x10,%esp
  800d81:	85 c0                	test   %eax,%eax
  800d83:	78 5b                	js     800de0 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800d85:	83 ec 04             	sub    $0x4,%esp
  800d88:	68 07 04 00 00       	push   $0x407
  800d8d:	ff 75 f4             	pushl  -0xc(%ebp)
  800d90:	6a 00                	push   $0x0
  800d92:	e8 c3 f3 ff ff       	call   80015a <sys_page_alloc>
  800d97:	89 c3                	mov    %eax,%ebx
  800d99:	83 c4 10             	add    $0x10,%esp
  800d9c:	85 c0                	test   %eax,%eax
  800d9e:	78 40                	js     800de0 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  800da0:	83 ec 0c             	sub    $0xc,%esp
  800da3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800da6:	50                   	push   %eax
  800da7:	e8 e5 f5 ff ff       	call   800391 <fd_alloc>
  800dac:	89 c3                	mov    %eax,%ebx
  800dae:	83 c4 10             	add    $0x10,%esp
  800db1:	85 c0                	test   %eax,%eax
  800db3:	78 1b                	js     800dd0 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800db5:	83 ec 04             	sub    $0x4,%esp
  800db8:	68 07 04 00 00       	push   $0x407
  800dbd:	ff 75 f0             	pushl  -0x10(%ebp)
  800dc0:	6a 00                	push   $0x0
  800dc2:	e8 93 f3 ff ff       	call   80015a <sys_page_alloc>
  800dc7:	89 c3                	mov    %eax,%ebx
  800dc9:	83 c4 10             	add    $0x10,%esp
  800dcc:	85 c0                	test   %eax,%eax
  800dce:	79 19                	jns    800de9 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  800dd0:	83 ec 08             	sub    $0x8,%esp
  800dd3:	ff 75 f4             	pushl  -0xc(%ebp)
  800dd6:	6a 00                	push   $0x0
  800dd8:	e8 02 f4 ff ff       	call   8001df <sys_page_unmap>
  800ddd:	83 c4 10             	add    $0x10,%esp
}
  800de0:	89 d8                	mov    %ebx,%eax
  800de2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800de5:	5b                   	pop    %ebx
  800de6:	5e                   	pop    %esi
  800de7:	5d                   	pop    %ebp
  800de8:	c3                   	ret    
	va = fd2data(fd0);
  800de9:	83 ec 0c             	sub    $0xc,%esp
  800dec:	ff 75 f4             	pushl  -0xc(%ebp)
  800def:	e8 86 f5 ff ff       	call   80037a <fd2data>
  800df4:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800df6:	83 c4 0c             	add    $0xc,%esp
  800df9:	68 07 04 00 00       	push   $0x407
  800dfe:	50                   	push   %eax
  800dff:	6a 00                	push   $0x0
  800e01:	e8 54 f3 ff ff       	call   80015a <sys_page_alloc>
  800e06:	89 c3                	mov    %eax,%ebx
  800e08:	83 c4 10             	add    $0x10,%esp
  800e0b:	85 c0                	test   %eax,%eax
  800e0d:	0f 88 8c 00 00 00    	js     800e9f <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e13:	83 ec 0c             	sub    $0xc,%esp
  800e16:	ff 75 f0             	pushl  -0x10(%ebp)
  800e19:	e8 5c f5 ff ff       	call   80037a <fd2data>
  800e1e:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  800e25:	50                   	push   %eax
  800e26:	6a 00                	push   $0x0
  800e28:	56                   	push   %esi
  800e29:	6a 00                	push   $0x0
  800e2b:	e8 6d f3 ff ff       	call   80019d <sys_page_map>
  800e30:	89 c3                	mov    %eax,%ebx
  800e32:	83 c4 20             	add    $0x20,%esp
  800e35:	85 c0                	test   %eax,%eax
  800e37:	78 58                	js     800e91 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  800e39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e3c:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800e42:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  800e44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e47:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  800e4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e51:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800e57:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  800e59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e5c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  800e63:	83 ec 0c             	sub    $0xc,%esp
  800e66:	ff 75 f4             	pushl  -0xc(%ebp)
  800e69:	e8 fc f4 ff ff       	call   80036a <fd2num>
  800e6e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e71:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  800e73:	83 c4 04             	add    $0x4,%esp
  800e76:	ff 75 f0             	pushl  -0x10(%ebp)
  800e79:	e8 ec f4 ff ff       	call   80036a <fd2num>
  800e7e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e81:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  800e84:	83 c4 10             	add    $0x10,%esp
  800e87:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e8c:	e9 4f ff ff ff       	jmp    800de0 <pipe+0x75>
	sys_page_unmap(0, va);
  800e91:	83 ec 08             	sub    $0x8,%esp
  800e94:	56                   	push   %esi
  800e95:	6a 00                	push   $0x0
  800e97:	e8 43 f3 ff ff       	call   8001df <sys_page_unmap>
  800e9c:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  800e9f:	83 ec 08             	sub    $0x8,%esp
  800ea2:	ff 75 f0             	pushl  -0x10(%ebp)
  800ea5:	6a 00                	push   $0x0
  800ea7:	e8 33 f3 ff ff       	call   8001df <sys_page_unmap>
  800eac:	83 c4 10             	add    $0x10,%esp
  800eaf:	e9 1c ff ff ff       	jmp    800dd0 <pipe+0x65>

00800eb4 <pipeisclosed>:
{
  800eb4:	55                   	push   %ebp
  800eb5:	89 e5                	mov    %esp,%ebp
  800eb7:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800eba:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800ebd:	50                   	push   %eax
  800ebe:	ff 75 08             	pushl  0x8(%ebp)
  800ec1:	e8 1a f5 ff ff       	call   8003e0 <fd_lookup>
  800ec6:	83 c4 10             	add    $0x10,%esp
  800ec9:	85 c0                	test   %eax,%eax
  800ecb:	78 18                	js     800ee5 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  800ecd:	83 ec 0c             	sub    $0xc,%esp
  800ed0:	ff 75 f4             	pushl  -0xc(%ebp)
  800ed3:	e8 a2 f4 ff ff       	call   80037a <fd2data>
	return _pipeisclosed(fd, p);
  800ed8:	89 c2                	mov    %eax,%edx
  800eda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800edd:	e8 30 fd ff ff       	call   800c12 <_pipeisclosed>
  800ee2:	83 c4 10             	add    $0x10,%esp
}
  800ee5:	c9                   	leave  
  800ee6:	c3                   	ret    

00800ee7 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  800ee7:	55                   	push   %ebp
  800ee8:	89 e5                	mov    %esp,%ebp
  800eea:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  800eed:	68 47 24 80 00       	push   $0x802447
  800ef2:	ff 75 0c             	pushl  0xc(%ebp)
  800ef5:	e8 47 0d 00 00       	call   801c41 <strcpy>
	return 0;
}
  800efa:	b8 00 00 00 00       	mov    $0x0,%eax
  800eff:	c9                   	leave  
  800f00:	c3                   	ret    

00800f01 <devsock_close>:
{
  800f01:	55                   	push   %ebp
  800f02:	89 e5                	mov    %esp,%ebp
  800f04:	53                   	push   %ebx
  800f05:	83 ec 10             	sub    $0x10,%esp
  800f08:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  800f0b:	53                   	push   %ebx
  800f0c:	e8 68 11 00 00       	call   802079 <pageref>
  800f11:	83 c4 10             	add    $0x10,%esp
		return 0;
  800f14:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  800f19:	83 f8 01             	cmp    $0x1,%eax
  800f1c:	74 07                	je     800f25 <devsock_close+0x24>
}
  800f1e:	89 d0                	mov    %edx,%eax
  800f20:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f23:	c9                   	leave  
  800f24:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  800f25:	83 ec 0c             	sub    $0xc,%esp
  800f28:	ff 73 0c             	pushl  0xc(%ebx)
  800f2b:	e8 b7 02 00 00       	call   8011e7 <nsipc_close>
  800f30:	89 c2                	mov    %eax,%edx
  800f32:	83 c4 10             	add    $0x10,%esp
  800f35:	eb e7                	jmp    800f1e <devsock_close+0x1d>

00800f37 <devsock_write>:
{
  800f37:	55                   	push   %ebp
  800f38:	89 e5                	mov    %esp,%ebp
  800f3a:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  800f3d:	6a 00                	push   $0x0
  800f3f:	ff 75 10             	pushl  0x10(%ebp)
  800f42:	ff 75 0c             	pushl  0xc(%ebp)
  800f45:	8b 45 08             	mov    0x8(%ebp),%eax
  800f48:	ff 70 0c             	pushl  0xc(%eax)
  800f4b:	e8 74 03 00 00       	call   8012c4 <nsipc_send>
}
  800f50:	c9                   	leave  
  800f51:	c3                   	ret    

00800f52 <devsock_read>:
{
  800f52:	55                   	push   %ebp
  800f53:	89 e5                	mov    %esp,%ebp
  800f55:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  800f58:	6a 00                	push   $0x0
  800f5a:	ff 75 10             	pushl  0x10(%ebp)
  800f5d:	ff 75 0c             	pushl  0xc(%ebp)
  800f60:	8b 45 08             	mov    0x8(%ebp),%eax
  800f63:	ff 70 0c             	pushl  0xc(%eax)
  800f66:	e8 ed 02 00 00       	call   801258 <nsipc_recv>
}
  800f6b:	c9                   	leave  
  800f6c:	c3                   	ret    

00800f6d <fd2sockid>:
{
  800f6d:	55                   	push   %ebp
  800f6e:	89 e5                	mov    %esp,%ebp
  800f70:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  800f73:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800f76:	52                   	push   %edx
  800f77:	50                   	push   %eax
  800f78:	e8 63 f4 ff ff       	call   8003e0 <fd_lookup>
  800f7d:	83 c4 10             	add    $0x10,%esp
  800f80:	85 c0                	test   %eax,%eax
  800f82:	78 10                	js     800f94 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  800f84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f87:	8b 0d 3c 30 80 00    	mov    0x80303c,%ecx
  800f8d:	39 08                	cmp    %ecx,(%eax)
  800f8f:	75 05                	jne    800f96 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  800f91:	8b 40 0c             	mov    0xc(%eax),%eax
}
  800f94:	c9                   	leave  
  800f95:	c3                   	ret    
		return -E_NOT_SUPP;
  800f96:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800f9b:	eb f7                	jmp    800f94 <fd2sockid+0x27>

00800f9d <alloc_sockfd>:
{
  800f9d:	55                   	push   %ebp
  800f9e:	89 e5                	mov    %esp,%ebp
  800fa0:	56                   	push   %esi
  800fa1:	53                   	push   %ebx
  800fa2:	83 ec 1c             	sub    $0x1c,%esp
  800fa5:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  800fa7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800faa:	50                   	push   %eax
  800fab:	e8 e1 f3 ff ff       	call   800391 <fd_alloc>
  800fb0:	89 c3                	mov    %eax,%ebx
  800fb2:	83 c4 10             	add    $0x10,%esp
  800fb5:	85 c0                	test   %eax,%eax
  800fb7:	78 43                	js     800ffc <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  800fb9:	83 ec 04             	sub    $0x4,%esp
  800fbc:	68 07 04 00 00       	push   $0x407
  800fc1:	ff 75 f4             	pushl  -0xc(%ebp)
  800fc4:	6a 00                	push   $0x0
  800fc6:	e8 8f f1 ff ff       	call   80015a <sys_page_alloc>
  800fcb:	89 c3                	mov    %eax,%ebx
  800fcd:	83 c4 10             	add    $0x10,%esp
  800fd0:	85 c0                	test   %eax,%eax
  800fd2:	78 28                	js     800ffc <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  800fd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fd7:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  800fdd:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  800fdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fe2:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  800fe9:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  800fec:	83 ec 0c             	sub    $0xc,%esp
  800fef:	50                   	push   %eax
  800ff0:	e8 75 f3 ff ff       	call   80036a <fd2num>
  800ff5:	89 c3                	mov    %eax,%ebx
  800ff7:	83 c4 10             	add    $0x10,%esp
  800ffa:	eb 0c                	jmp    801008 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  800ffc:	83 ec 0c             	sub    $0xc,%esp
  800fff:	56                   	push   %esi
  801000:	e8 e2 01 00 00       	call   8011e7 <nsipc_close>
		return r;
  801005:	83 c4 10             	add    $0x10,%esp
}
  801008:	89 d8                	mov    %ebx,%eax
  80100a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80100d:	5b                   	pop    %ebx
  80100e:	5e                   	pop    %esi
  80100f:	5d                   	pop    %ebp
  801010:	c3                   	ret    

00801011 <accept>:
{
  801011:	55                   	push   %ebp
  801012:	89 e5                	mov    %esp,%ebp
  801014:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801017:	8b 45 08             	mov    0x8(%ebp),%eax
  80101a:	e8 4e ff ff ff       	call   800f6d <fd2sockid>
  80101f:	85 c0                	test   %eax,%eax
  801021:	78 1b                	js     80103e <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801023:	83 ec 04             	sub    $0x4,%esp
  801026:	ff 75 10             	pushl  0x10(%ebp)
  801029:	ff 75 0c             	pushl  0xc(%ebp)
  80102c:	50                   	push   %eax
  80102d:	e8 0e 01 00 00       	call   801140 <nsipc_accept>
  801032:	83 c4 10             	add    $0x10,%esp
  801035:	85 c0                	test   %eax,%eax
  801037:	78 05                	js     80103e <accept+0x2d>
	return alloc_sockfd(r);
  801039:	e8 5f ff ff ff       	call   800f9d <alloc_sockfd>
}
  80103e:	c9                   	leave  
  80103f:	c3                   	ret    

00801040 <bind>:
{
  801040:	55                   	push   %ebp
  801041:	89 e5                	mov    %esp,%ebp
  801043:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801046:	8b 45 08             	mov    0x8(%ebp),%eax
  801049:	e8 1f ff ff ff       	call   800f6d <fd2sockid>
  80104e:	85 c0                	test   %eax,%eax
  801050:	78 12                	js     801064 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801052:	83 ec 04             	sub    $0x4,%esp
  801055:	ff 75 10             	pushl  0x10(%ebp)
  801058:	ff 75 0c             	pushl  0xc(%ebp)
  80105b:	50                   	push   %eax
  80105c:	e8 2f 01 00 00       	call   801190 <nsipc_bind>
  801061:	83 c4 10             	add    $0x10,%esp
}
  801064:	c9                   	leave  
  801065:	c3                   	ret    

00801066 <shutdown>:
{
  801066:	55                   	push   %ebp
  801067:	89 e5                	mov    %esp,%ebp
  801069:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80106c:	8b 45 08             	mov    0x8(%ebp),%eax
  80106f:	e8 f9 fe ff ff       	call   800f6d <fd2sockid>
  801074:	85 c0                	test   %eax,%eax
  801076:	78 0f                	js     801087 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801078:	83 ec 08             	sub    $0x8,%esp
  80107b:	ff 75 0c             	pushl  0xc(%ebp)
  80107e:	50                   	push   %eax
  80107f:	e8 41 01 00 00       	call   8011c5 <nsipc_shutdown>
  801084:	83 c4 10             	add    $0x10,%esp
}
  801087:	c9                   	leave  
  801088:	c3                   	ret    

00801089 <connect>:
{
  801089:	55                   	push   %ebp
  80108a:	89 e5                	mov    %esp,%ebp
  80108c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80108f:	8b 45 08             	mov    0x8(%ebp),%eax
  801092:	e8 d6 fe ff ff       	call   800f6d <fd2sockid>
  801097:	85 c0                	test   %eax,%eax
  801099:	78 12                	js     8010ad <connect+0x24>
	return nsipc_connect(r, name, namelen);
  80109b:	83 ec 04             	sub    $0x4,%esp
  80109e:	ff 75 10             	pushl  0x10(%ebp)
  8010a1:	ff 75 0c             	pushl  0xc(%ebp)
  8010a4:	50                   	push   %eax
  8010a5:	e8 57 01 00 00       	call   801201 <nsipc_connect>
  8010aa:	83 c4 10             	add    $0x10,%esp
}
  8010ad:	c9                   	leave  
  8010ae:	c3                   	ret    

008010af <listen>:
{
  8010af:	55                   	push   %ebp
  8010b0:	89 e5                	mov    %esp,%ebp
  8010b2:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8010b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b8:	e8 b0 fe ff ff       	call   800f6d <fd2sockid>
  8010bd:	85 c0                	test   %eax,%eax
  8010bf:	78 0f                	js     8010d0 <listen+0x21>
	return nsipc_listen(r, backlog);
  8010c1:	83 ec 08             	sub    $0x8,%esp
  8010c4:	ff 75 0c             	pushl  0xc(%ebp)
  8010c7:	50                   	push   %eax
  8010c8:	e8 69 01 00 00       	call   801236 <nsipc_listen>
  8010cd:	83 c4 10             	add    $0x10,%esp
}
  8010d0:	c9                   	leave  
  8010d1:	c3                   	ret    

008010d2 <socket>:

int
socket(int domain, int type, int protocol)
{
  8010d2:	55                   	push   %ebp
  8010d3:	89 e5                	mov    %esp,%ebp
  8010d5:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8010d8:	ff 75 10             	pushl  0x10(%ebp)
  8010db:	ff 75 0c             	pushl  0xc(%ebp)
  8010de:	ff 75 08             	pushl  0x8(%ebp)
  8010e1:	e8 3c 02 00 00       	call   801322 <nsipc_socket>
  8010e6:	83 c4 10             	add    $0x10,%esp
  8010e9:	85 c0                	test   %eax,%eax
  8010eb:	78 05                	js     8010f2 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8010ed:	e8 ab fe ff ff       	call   800f9d <alloc_sockfd>
}
  8010f2:	c9                   	leave  
  8010f3:	c3                   	ret    

008010f4 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8010f4:	55                   	push   %ebp
  8010f5:	89 e5                	mov    %esp,%ebp
  8010f7:	53                   	push   %ebx
  8010f8:	83 ec 04             	sub    $0x4,%esp
  8010fb:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8010fd:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801104:	74 26                	je     80112c <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801106:	6a 07                	push   $0x7
  801108:	68 00 60 80 00       	push   $0x806000
  80110d:	53                   	push   %ebx
  80110e:	ff 35 04 40 80 00    	pushl  0x804004
  801114:	e8 ce 0e 00 00       	call   801fe7 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801119:	83 c4 0c             	add    $0xc,%esp
  80111c:	6a 00                	push   $0x0
  80111e:	6a 00                	push   $0x0
  801120:	6a 00                	push   $0x0
  801122:	e8 57 0e 00 00       	call   801f7e <ipc_recv>
}
  801127:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80112a:	c9                   	leave  
  80112b:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80112c:	83 ec 0c             	sub    $0xc,%esp
  80112f:	6a 02                	push   $0x2
  801131:	e8 0a 0f 00 00       	call   802040 <ipc_find_env>
  801136:	a3 04 40 80 00       	mov    %eax,0x804004
  80113b:	83 c4 10             	add    $0x10,%esp
  80113e:	eb c6                	jmp    801106 <nsipc+0x12>

00801140 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801140:	55                   	push   %ebp
  801141:	89 e5                	mov    %esp,%ebp
  801143:	56                   	push   %esi
  801144:	53                   	push   %ebx
  801145:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801148:	8b 45 08             	mov    0x8(%ebp),%eax
  80114b:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801150:	8b 06                	mov    (%esi),%eax
  801152:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801157:	b8 01 00 00 00       	mov    $0x1,%eax
  80115c:	e8 93 ff ff ff       	call   8010f4 <nsipc>
  801161:	89 c3                	mov    %eax,%ebx
  801163:	85 c0                	test   %eax,%eax
  801165:	78 20                	js     801187 <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801167:	83 ec 04             	sub    $0x4,%esp
  80116a:	ff 35 10 60 80 00    	pushl  0x806010
  801170:	68 00 60 80 00       	push   $0x806000
  801175:	ff 75 0c             	pushl  0xc(%ebp)
  801178:	e8 52 0c 00 00       	call   801dcf <memmove>
		*addrlen = ret->ret_addrlen;
  80117d:	a1 10 60 80 00       	mov    0x806010,%eax
  801182:	89 06                	mov    %eax,(%esi)
  801184:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  801187:	89 d8                	mov    %ebx,%eax
  801189:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80118c:	5b                   	pop    %ebx
  80118d:	5e                   	pop    %esi
  80118e:	5d                   	pop    %ebp
  80118f:	c3                   	ret    

00801190 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801190:	55                   	push   %ebp
  801191:	89 e5                	mov    %esp,%ebp
  801193:	53                   	push   %ebx
  801194:	83 ec 08             	sub    $0x8,%esp
  801197:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  80119a:	8b 45 08             	mov    0x8(%ebp),%eax
  80119d:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8011a2:	53                   	push   %ebx
  8011a3:	ff 75 0c             	pushl  0xc(%ebp)
  8011a6:	68 04 60 80 00       	push   $0x806004
  8011ab:	e8 1f 0c 00 00       	call   801dcf <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8011b0:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  8011b6:	b8 02 00 00 00       	mov    $0x2,%eax
  8011bb:	e8 34 ff ff ff       	call   8010f4 <nsipc>
}
  8011c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011c3:	c9                   	leave  
  8011c4:	c3                   	ret    

008011c5 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8011c5:	55                   	push   %ebp
  8011c6:	89 e5                	mov    %esp,%ebp
  8011c8:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8011cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ce:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  8011d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d6:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  8011db:	b8 03 00 00 00       	mov    $0x3,%eax
  8011e0:	e8 0f ff ff ff       	call   8010f4 <nsipc>
}
  8011e5:	c9                   	leave  
  8011e6:	c3                   	ret    

008011e7 <nsipc_close>:

int
nsipc_close(int s)
{
  8011e7:	55                   	push   %ebp
  8011e8:	89 e5                	mov    %esp,%ebp
  8011ea:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8011ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f0:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  8011f5:	b8 04 00 00 00       	mov    $0x4,%eax
  8011fa:	e8 f5 fe ff ff       	call   8010f4 <nsipc>
}
  8011ff:	c9                   	leave  
  801200:	c3                   	ret    

00801201 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801201:	55                   	push   %ebp
  801202:	89 e5                	mov    %esp,%ebp
  801204:	53                   	push   %ebx
  801205:	83 ec 08             	sub    $0x8,%esp
  801208:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80120b:	8b 45 08             	mov    0x8(%ebp),%eax
  80120e:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801213:	53                   	push   %ebx
  801214:	ff 75 0c             	pushl  0xc(%ebp)
  801217:	68 04 60 80 00       	push   $0x806004
  80121c:	e8 ae 0b 00 00       	call   801dcf <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801221:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801227:	b8 05 00 00 00       	mov    $0x5,%eax
  80122c:	e8 c3 fe ff ff       	call   8010f4 <nsipc>
}
  801231:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801234:	c9                   	leave  
  801235:	c3                   	ret    

00801236 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801236:	55                   	push   %ebp
  801237:	89 e5                	mov    %esp,%ebp
  801239:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80123c:	8b 45 08             	mov    0x8(%ebp),%eax
  80123f:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801244:	8b 45 0c             	mov    0xc(%ebp),%eax
  801247:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  80124c:	b8 06 00 00 00       	mov    $0x6,%eax
  801251:	e8 9e fe ff ff       	call   8010f4 <nsipc>
}
  801256:	c9                   	leave  
  801257:	c3                   	ret    

00801258 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801258:	55                   	push   %ebp
  801259:	89 e5                	mov    %esp,%ebp
  80125b:	56                   	push   %esi
  80125c:	53                   	push   %ebx
  80125d:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801260:	8b 45 08             	mov    0x8(%ebp),%eax
  801263:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801268:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  80126e:	8b 45 14             	mov    0x14(%ebp),%eax
  801271:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801276:	b8 07 00 00 00       	mov    $0x7,%eax
  80127b:	e8 74 fe ff ff       	call   8010f4 <nsipc>
  801280:	89 c3                	mov    %eax,%ebx
  801282:	85 c0                	test   %eax,%eax
  801284:	78 1f                	js     8012a5 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801286:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  80128b:	7f 21                	jg     8012ae <nsipc_recv+0x56>
  80128d:	39 c6                	cmp    %eax,%esi
  80128f:	7c 1d                	jl     8012ae <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801291:	83 ec 04             	sub    $0x4,%esp
  801294:	50                   	push   %eax
  801295:	68 00 60 80 00       	push   $0x806000
  80129a:	ff 75 0c             	pushl  0xc(%ebp)
  80129d:	e8 2d 0b 00 00       	call   801dcf <memmove>
  8012a2:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8012a5:	89 d8                	mov    %ebx,%eax
  8012a7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012aa:	5b                   	pop    %ebx
  8012ab:	5e                   	pop    %esi
  8012ac:	5d                   	pop    %ebp
  8012ad:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8012ae:	68 53 24 80 00       	push   $0x802453
  8012b3:	68 f5 23 80 00       	push   $0x8023f5
  8012b8:	6a 62                	push   $0x62
  8012ba:	68 68 24 80 00       	push   $0x802468
  8012bf:	e8 05 02 00 00       	call   8014c9 <_panic>

008012c4 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8012c4:	55                   	push   %ebp
  8012c5:	89 e5                	mov    %esp,%ebp
  8012c7:	53                   	push   %ebx
  8012c8:	83 ec 04             	sub    $0x4,%esp
  8012cb:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8012ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d1:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  8012d6:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8012dc:	7f 2e                	jg     80130c <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8012de:	83 ec 04             	sub    $0x4,%esp
  8012e1:	53                   	push   %ebx
  8012e2:	ff 75 0c             	pushl  0xc(%ebp)
  8012e5:	68 0c 60 80 00       	push   $0x80600c
  8012ea:	e8 e0 0a 00 00       	call   801dcf <memmove>
	nsipcbuf.send.req_size = size;
  8012ef:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  8012f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8012f8:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  8012fd:	b8 08 00 00 00       	mov    $0x8,%eax
  801302:	e8 ed fd ff ff       	call   8010f4 <nsipc>
}
  801307:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80130a:	c9                   	leave  
  80130b:	c3                   	ret    
	assert(size < 1600);
  80130c:	68 74 24 80 00       	push   $0x802474
  801311:	68 f5 23 80 00       	push   $0x8023f5
  801316:	6a 6d                	push   $0x6d
  801318:	68 68 24 80 00       	push   $0x802468
  80131d:	e8 a7 01 00 00       	call   8014c9 <_panic>

00801322 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801322:	55                   	push   %ebp
  801323:	89 e5                	mov    %esp,%ebp
  801325:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801328:	8b 45 08             	mov    0x8(%ebp),%eax
  80132b:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801330:	8b 45 0c             	mov    0xc(%ebp),%eax
  801333:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801338:	8b 45 10             	mov    0x10(%ebp),%eax
  80133b:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801340:	b8 09 00 00 00       	mov    $0x9,%eax
  801345:	e8 aa fd ff ff       	call   8010f4 <nsipc>
}
  80134a:	c9                   	leave  
  80134b:	c3                   	ret    

0080134c <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  80134c:	55                   	push   %ebp
  80134d:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  80134f:	b8 00 00 00 00       	mov    $0x0,%eax
  801354:	5d                   	pop    %ebp
  801355:	c3                   	ret    

00801356 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801356:	55                   	push   %ebp
  801357:	89 e5                	mov    %esp,%ebp
  801359:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80135c:	68 80 24 80 00       	push   $0x802480
  801361:	ff 75 0c             	pushl  0xc(%ebp)
  801364:	e8 d8 08 00 00       	call   801c41 <strcpy>
	return 0;
}
  801369:	b8 00 00 00 00       	mov    $0x0,%eax
  80136e:	c9                   	leave  
  80136f:	c3                   	ret    

00801370 <devcons_write>:
{
  801370:	55                   	push   %ebp
  801371:	89 e5                	mov    %esp,%ebp
  801373:	57                   	push   %edi
  801374:	56                   	push   %esi
  801375:	53                   	push   %ebx
  801376:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80137c:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801381:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801387:	eb 2f                	jmp    8013b8 <devcons_write+0x48>
		m = n - tot;
  801389:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80138c:	29 f3                	sub    %esi,%ebx
  80138e:	83 fb 7f             	cmp    $0x7f,%ebx
  801391:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801396:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801399:	83 ec 04             	sub    $0x4,%esp
  80139c:	53                   	push   %ebx
  80139d:	89 f0                	mov    %esi,%eax
  80139f:	03 45 0c             	add    0xc(%ebp),%eax
  8013a2:	50                   	push   %eax
  8013a3:	57                   	push   %edi
  8013a4:	e8 26 0a 00 00       	call   801dcf <memmove>
		sys_cputs(buf, m);
  8013a9:	83 c4 08             	add    $0x8,%esp
  8013ac:	53                   	push   %ebx
  8013ad:	57                   	push   %edi
  8013ae:	e8 eb ec ff ff       	call   80009e <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8013b3:	01 de                	add    %ebx,%esi
  8013b5:	83 c4 10             	add    $0x10,%esp
  8013b8:	3b 75 10             	cmp    0x10(%ebp),%esi
  8013bb:	72 cc                	jb     801389 <devcons_write+0x19>
}
  8013bd:	89 f0                	mov    %esi,%eax
  8013bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013c2:	5b                   	pop    %ebx
  8013c3:	5e                   	pop    %esi
  8013c4:	5f                   	pop    %edi
  8013c5:	5d                   	pop    %ebp
  8013c6:	c3                   	ret    

008013c7 <devcons_read>:
{
  8013c7:	55                   	push   %ebp
  8013c8:	89 e5                	mov    %esp,%ebp
  8013ca:	83 ec 08             	sub    $0x8,%esp
  8013cd:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8013d2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013d6:	75 07                	jne    8013df <devcons_read+0x18>
}
  8013d8:	c9                   	leave  
  8013d9:	c3                   	ret    
		sys_yield();
  8013da:	e8 5c ed ff ff       	call   80013b <sys_yield>
	while ((c = sys_cgetc()) == 0)
  8013df:	e8 d8 ec ff ff       	call   8000bc <sys_cgetc>
  8013e4:	85 c0                	test   %eax,%eax
  8013e6:	74 f2                	je     8013da <devcons_read+0x13>
	if (c < 0)
  8013e8:	85 c0                	test   %eax,%eax
  8013ea:	78 ec                	js     8013d8 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  8013ec:	83 f8 04             	cmp    $0x4,%eax
  8013ef:	74 0c                	je     8013fd <devcons_read+0x36>
	*(char*)vbuf = c;
  8013f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013f4:	88 02                	mov    %al,(%edx)
	return 1;
  8013f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8013fb:	eb db                	jmp    8013d8 <devcons_read+0x11>
		return 0;
  8013fd:	b8 00 00 00 00       	mov    $0x0,%eax
  801402:	eb d4                	jmp    8013d8 <devcons_read+0x11>

00801404 <cputchar>:
{
  801404:	55                   	push   %ebp
  801405:	89 e5                	mov    %esp,%ebp
  801407:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80140a:	8b 45 08             	mov    0x8(%ebp),%eax
  80140d:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801410:	6a 01                	push   $0x1
  801412:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801415:	50                   	push   %eax
  801416:	e8 83 ec ff ff       	call   80009e <sys_cputs>
}
  80141b:	83 c4 10             	add    $0x10,%esp
  80141e:	c9                   	leave  
  80141f:	c3                   	ret    

00801420 <getchar>:
{
  801420:	55                   	push   %ebp
  801421:	89 e5                	mov    %esp,%ebp
  801423:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801426:	6a 01                	push   $0x1
  801428:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80142b:	50                   	push   %eax
  80142c:	6a 00                	push   $0x0
  80142e:	e8 1e f2 ff ff       	call   800651 <read>
	if (r < 0)
  801433:	83 c4 10             	add    $0x10,%esp
  801436:	85 c0                	test   %eax,%eax
  801438:	78 08                	js     801442 <getchar+0x22>
	if (r < 1)
  80143a:	85 c0                	test   %eax,%eax
  80143c:	7e 06                	jle    801444 <getchar+0x24>
	return c;
  80143e:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801442:	c9                   	leave  
  801443:	c3                   	ret    
		return -E_EOF;
  801444:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801449:	eb f7                	jmp    801442 <getchar+0x22>

0080144b <iscons>:
{
  80144b:	55                   	push   %ebp
  80144c:	89 e5                	mov    %esp,%ebp
  80144e:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801451:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801454:	50                   	push   %eax
  801455:	ff 75 08             	pushl  0x8(%ebp)
  801458:	e8 83 ef ff ff       	call   8003e0 <fd_lookup>
  80145d:	83 c4 10             	add    $0x10,%esp
  801460:	85 c0                	test   %eax,%eax
  801462:	78 11                	js     801475 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801464:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801467:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80146d:	39 10                	cmp    %edx,(%eax)
  80146f:	0f 94 c0             	sete   %al
  801472:	0f b6 c0             	movzbl %al,%eax
}
  801475:	c9                   	leave  
  801476:	c3                   	ret    

00801477 <opencons>:
{
  801477:	55                   	push   %ebp
  801478:	89 e5                	mov    %esp,%ebp
  80147a:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80147d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801480:	50                   	push   %eax
  801481:	e8 0b ef ff ff       	call   800391 <fd_alloc>
  801486:	83 c4 10             	add    $0x10,%esp
  801489:	85 c0                	test   %eax,%eax
  80148b:	78 3a                	js     8014c7 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80148d:	83 ec 04             	sub    $0x4,%esp
  801490:	68 07 04 00 00       	push   $0x407
  801495:	ff 75 f4             	pushl  -0xc(%ebp)
  801498:	6a 00                	push   $0x0
  80149a:	e8 bb ec ff ff       	call   80015a <sys_page_alloc>
  80149f:	83 c4 10             	add    $0x10,%esp
  8014a2:	85 c0                	test   %eax,%eax
  8014a4:	78 21                	js     8014c7 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8014a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014a9:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8014af:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8014b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014b4:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8014bb:	83 ec 0c             	sub    $0xc,%esp
  8014be:	50                   	push   %eax
  8014bf:	e8 a6 ee ff ff       	call   80036a <fd2num>
  8014c4:	83 c4 10             	add    $0x10,%esp
}
  8014c7:	c9                   	leave  
  8014c8:	c3                   	ret    

008014c9 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8014c9:	55                   	push   %ebp
  8014ca:	89 e5                	mov    %esp,%ebp
  8014cc:	56                   	push   %esi
  8014cd:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8014ce:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8014d1:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8014d7:	e8 40 ec ff ff       	call   80011c <sys_getenvid>
  8014dc:	83 ec 0c             	sub    $0xc,%esp
  8014df:	ff 75 0c             	pushl  0xc(%ebp)
  8014e2:	ff 75 08             	pushl  0x8(%ebp)
  8014e5:	56                   	push   %esi
  8014e6:	50                   	push   %eax
  8014e7:	68 8c 24 80 00       	push   $0x80248c
  8014ec:	e8 b3 00 00 00       	call   8015a4 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8014f1:	83 c4 18             	add    $0x18,%esp
  8014f4:	53                   	push   %ebx
  8014f5:	ff 75 10             	pushl  0x10(%ebp)
  8014f8:	e8 56 00 00 00       	call   801553 <vcprintf>
	cprintf("\n");
  8014fd:	c7 04 24 40 24 80 00 	movl   $0x802440,(%esp)
  801504:	e8 9b 00 00 00       	call   8015a4 <cprintf>
  801509:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80150c:	cc                   	int3   
  80150d:	eb fd                	jmp    80150c <_panic+0x43>

0080150f <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80150f:	55                   	push   %ebp
  801510:	89 e5                	mov    %esp,%ebp
  801512:	53                   	push   %ebx
  801513:	83 ec 04             	sub    $0x4,%esp
  801516:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801519:	8b 13                	mov    (%ebx),%edx
  80151b:	8d 42 01             	lea    0x1(%edx),%eax
  80151e:	89 03                	mov    %eax,(%ebx)
  801520:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801523:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801527:	3d ff 00 00 00       	cmp    $0xff,%eax
  80152c:	74 09                	je     801537 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80152e:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  801532:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801535:	c9                   	leave  
  801536:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  801537:	83 ec 08             	sub    $0x8,%esp
  80153a:	68 ff 00 00 00       	push   $0xff
  80153f:	8d 43 08             	lea    0x8(%ebx),%eax
  801542:	50                   	push   %eax
  801543:	e8 56 eb ff ff       	call   80009e <sys_cputs>
		b->idx = 0;
  801548:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80154e:	83 c4 10             	add    $0x10,%esp
  801551:	eb db                	jmp    80152e <putch+0x1f>

00801553 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  801553:	55                   	push   %ebp
  801554:	89 e5                	mov    %esp,%ebp
  801556:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80155c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801563:	00 00 00 
	b.cnt = 0;
  801566:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80156d:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  801570:	ff 75 0c             	pushl  0xc(%ebp)
  801573:	ff 75 08             	pushl  0x8(%ebp)
  801576:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80157c:	50                   	push   %eax
  80157d:	68 0f 15 80 00       	push   $0x80150f
  801582:	e8 1a 01 00 00       	call   8016a1 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801587:	83 c4 08             	add    $0x8,%esp
  80158a:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  801590:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  801596:	50                   	push   %eax
  801597:	e8 02 eb ff ff       	call   80009e <sys_cputs>

	return b.cnt;
}
  80159c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8015a2:	c9                   	leave  
  8015a3:	c3                   	ret    

008015a4 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8015a4:	55                   	push   %ebp
  8015a5:	89 e5                	mov    %esp,%ebp
  8015a7:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8015aa:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8015ad:	50                   	push   %eax
  8015ae:	ff 75 08             	pushl  0x8(%ebp)
  8015b1:	e8 9d ff ff ff       	call   801553 <vcprintf>
	va_end(ap);

	return cnt;
}
  8015b6:	c9                   	leave  
  8015b7:	c3                   	ret    

008015b8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8015b8:	55                   	push   %ebp
  8015b9:	89 e5                	mov    %esp,%ebp
  8015bb:	57                   	push   %edi
  8015bc:	56                   	push   %esi
  8015bd:	53                   	push   %ebx
  8015be:	83 ec 1c             	sub    $0x1c,%esp
  8015c1:	89 c7                	mov    %eax,%edi
  8015c3:	89 d6                	mov    %edx,%esi
  8015c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015cb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8015ce:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8015d1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015d4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015d9:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8015dc:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8015df:	39 d3                	cmp    %edx,%ebx
  8015e1:	72 05                	jb     8015e8 <printnum+0x30>
  8015e3:	39 45 10             	cmp    %eax,0x10(%ebp)
  8015e6:	77 7a                	ja     801662 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8015e8:	83 ec 0c             	sub    $0xc,%esp
  8015eb:	ff 75 18             	pushl  0x18(%ebp)
  8015ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8015f1:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8015f4:	53                   	push   %ebx
  8015f5:	ff 75 10             	pushl  0x10(%ebp)
  8015f8:	83 ec 08             	sub    $0x8,%esp
  8015fb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8015fe:	ff 75 e0             	pushl  -0x20(%ebp)
  801601:	ff 75 dc             	pushl  -0x24(%ebp)
  801604:	ff 75 d8             	pushl  -0x28(%ebp)
  801607:	e8 b4 0a 00 00       	call   8020c0 <__udivdi3>
  80160c:	83 c4 18             	add    $0x18,%esp
  80160f:	52                   	push   %edx
  801610:	50                   	push   %eax
  801611:	89 f2                	mov    %esi,%edx
  801613:	89 f8                	mov    %edi,%eax
  801615:	e8 9e ff ff ff       	call   8015b8 <printnum>
  80161a:	83 c4 20             	add    $0x20,%esp
  80161d:	eb 13                	jmp    801632 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80161f:	83 ec 08             	sub    $0x8,%esp
  801622:	56                   	push   %esi
  801623:	ff 75 18             	pushl  0x18(%ebp)
  801626:	ff d7                	call   *%edi
  801628:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80162b:	83 eb 01             	sub    $0x1,%ebx
  80162e:	85 db                	test   %ebx,%ebx
  801630:	7f ed                	jg     80161f <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801632:	83 ec 08             	sub    $0x8,%esp
  801635:	56                   	push   %esi
  801636:	83 ec 04             	sub    $0x4,%esp
  801639:	ff 75 e4             	pushl  -0x1c(%ebp)
  80163c:	ff 75 e0             	pushl  -0x20(%ebp)
  80163f:	ff 75 dc             	pushl  -0x24(%ebp)
  801642:	ff 75 d8             	pushl  -0x28(%ebp)
  801645:	e8 96 0b 00 00       	call   8021e0 <__umoddi3>
  80164a:	83 c4 14             	add    $0x14,%esp
  80164d:	0f be 80 af 24 80 00 	movsbl 0x8024af(%eax),%eax
  801654:	50                   	push   %eax
  801655:	ff d7                	call   *%edi
}
  801657:	83 c4 10             	add    $0x10,%esp
  80165a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80165d:	5b                   	pop    %ebx
  80165e:	5e                   	pop    %esi
  80165f:	5f                   	pop    %edi
  801660:	5d                   	pop    %ebp
  801661:	c3                   	ret    
  801662:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801665:	eb c4                	jmp    80162b <printnum+0x73>

00801667 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801667:	55                   	push   %ebp
  801668:	89 e5                	mov    %esp,%ebp
  80166a:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80166d:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  801671:	8b 10                	mov    (%eax),%edx
  801673:	3b 50 04             	cmp    0x4(%eax),%edx
  801676:	73 0a                	jae    801682 <sprintputch+0x1b>
		*b->buf++ = ch;
  801678:	8d 4a 01             	lea    0x1(%edx),%ecx
  80167b:	89 08                	mov    %ecx,(%eax)
  80167d:	8b 45 08             	mov    0x8(%ebp),%eax
  801680:	88 02                	mov    %al,(%edx)
}
  801682:	5d                   	pop    %ebp
  801683:	c3                   	ret    

00801684 <printfmt>:
{
  801684:	55                   	push   %ebp
  801685:	89 e5                	mov    %esp,%ebp
  801687:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80168a:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80168d:	50                   	push   %eax
  80168e:	ff 75 10             	pushl  0x10(%ebp)
  801691:	ff 75 0c             	pushl  0xc(%ebp)
  801694:	ff 75 08             	pushl  0x8(%ebp)
  801697:	e8 05 00 00 00       	call   8016a1 <vprintfmt>
}
  80169c:	83 c4 10             	add    $0x10,%esp
  80169f:	c9                   	leave  
  8016a0:	c3                   	ret    

008016a1 <vprintfmt>:
{
  8016a1:	55                   	push   %ebp
  8016a2:	89 e5                	mov    %esp,%ebp
  8016a4:	57                   	push   %edi
  8016a5:	56                   	push   %esi
  8016a6:	53                   	push   %ebx
  8016a7:	83 ec 2c             	sub    $0x2c,%esp
  8016aa:	8b 75 08             	mov    0x8(%ebp),%esi
  8016ad:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8016b0:	8b 7d 10             	mov    0x10(%ebp),%edi
  8016b3:	e9 21 04 00 00       	jmp    801ad9 <vprintfmt+0x438>
		padc = ' ';
  8016b8:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8016bc:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8016c3:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  8016ca:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8016d1:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8016d6:	8d 47 01             	lea    0x1(%edi),%eax
  8016d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8016dc:	0f b6 17             	movzbl (%edi),%edx
  8016df:	8d 42 dd             	lea    -0x23(%edx),%eax
  8016e2:	3c 55                	cmp    $0x55,%al
  8016e4:	0f 87 90 04 00 00    	ja     801b7a <vprintfmt+0x4d9>
  8016ea:	0f b6 c0             	movzbl %al,%eax
  8016ed:	ff 24 85 00 26 80 00 	jmp    *0x802600(,%eax,4)
  8016f4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8016f7:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8016fb:	eb d9                	jmp    8016d6 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8016fd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  801700:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  801704:	eb d0                	jmp    8016d6 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  801706:	0f b6 d2             	movzbl %dl,%edx
  801709:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80170c:	b8 00 00 00 00       	mov    $0x0,%eax
  801711:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  801714:	8d 04 80             	lea    (%eax,%eax,4),%eax
  801717:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80171b:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80171e:	8d 4a d0             	lea    -0x30(%edx),%ecx
  801721:	83 f9 09             	cmp    $0x9,%ecx
  801724:	77 55                	ja     80177b <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  801726:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  801729:	eb e9                	jmp    801714 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  80172b:	8b 45 14             	mov    0x14(%ebp),%eax
  80172e:	8b 00                	mov    (%eax),%eax
  801730:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801733:	8b 45 14             	mov    0x14(%ebp),%eax
  801736:	8d 40 04             	lea    0x4(%eax),%eax
  801739:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80173c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80173f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801743:	79 91                	jns    8016d6 <vprintfmt+0x35>
				width = precision, precision = -1;
  801745:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801748:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80174b:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  801752:	eb 82                	jmp    8016d6 <vprintfmt+0x35>
  801754:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801757:	85 c0                	test   %eax,%eax
  801759:	ba 00 00 00 00       	mov    $0x0,%edx
  80175e:	0f 49 d0             	cmovns %eax,%edx
  801761:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801764:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801767:	e9 6a ff ff ff       	jmp    8016d6 <vprintfmt+0x35>
  80176c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80176f:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  801776:	e9 5b ff ff ff       	jmp    8016d6 <vprintfmt+0x35>
  80177b:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80177e:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801781:	eb bc                	jmp    80173f <vprintfmt+0x9e>
			lflag++;
  801783:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801786:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  801789:	e9 48 ff ff ff       	jmp    8016d6 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  80178e:	8b 45 14             	mov    0x14(%ebp),%eax
  801791:	8d 78 04             	lea    0x4(%eax),%edi
  801794:	83 ec 08             	sub    $0x8,%esp
  801797:	53                   	push   %ebx
  801798:	ff 30                	pushl  (%eax)
  80179a:	ff d6                	call   *%esi
			break;
  80179c:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80179f:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8017a2:	e9 2f 03 00 00       	jmp    801ad6 <vprintfmt+0x435>
			err = va_arg(ap, int);
  8017a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8017aa:	8d 78 04             	lea    0x4(%eax),%edi
  8017ad:	8b 00                	mov    (%eax),%eax
  8017af:	99                   	cltd   
  8017b0:	31 d0                	xor    %edx,%eax
  8017b2:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8017b4:	83 f8 0f             	cmp    $0xf,%eax
  8017b7:	7f 23                	jg     8017dc <vprintfmt+0x13b>
  8017b9:	8b 14 85 60 27 80 00 	mov    0x802760(,%eax,4),%edx
  8017c0:	85 d2                	test   %edx,%edx
  8017c2:	74 18                	je     8017dc <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  8017c4:	52                   	push   %edx
  8017c5:	68 07 24 80 00       	push   $0x802407
  8017ca:	53                   	push   %ebx
  8017cb:	56                   	push   %esi
  8017cc:	e8 b3 fe ff ff       	call   801684 <printfmt>
  8017d1:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8017d4:	89 7d 14             	mov    %edi,0x14(%ebp)
  8017d7:	e9 fa 02 00 00       	jmp    801ad6 <vprintfmt+0x435>
				printfmt(putch, putdat, "error %d", err);
  8017dc:	50                   	push   %eax
  8017dd:	68 c7 24 80 00       	push   $0x8024c7
  8017e2:	53                   	push   %ebx
  8017e3:	56                   	push   %esi
  8017e4:	e8 9b fe ff ff       	call   801684 <printfmt>
  8017e9:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8017ec:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8017ef:	e9 e2 02 00 00       	jmp    801ad6 <vprintfmt+0x435>
			if ((p = va_arg(ap, char *)) == NULL)
  8017f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8017f7:	83 c0 04             	add    $0x4,%eax
  8017fa:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8017fd:	8b 45 14             	mov    0x14(%ebp),%eax
  801800:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  801802:	85 ff                	test   %edi,%edi
  801804:	b8 c0 24 80 00       	mov    $0x8024c0,%eax
  801809:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  80180c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801810:	0f 8e bd 00 00 00    	jle    8018d3 <vprintfmt+0x232>
  801816:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80181a:	75 0e                	jne    80182a <vprintfmt+0x189>
  80181c:	89 75 08             	mov    %esi,0x8(%ebp)
  80181f:	8b 75 d0             	mov    -0x30(%ebp),%esi
  801822:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  801825:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  801828:	eb 6d                	jmp    801897 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  80182a:	83 ec 08             	sub    $0x8,%esp
  80182d:	ff 75 d0             	pushl  -0x30(%ebp)
  801830:	57                   	push   %edi
  801831:	e8 ec 03 00 00       	call   801c22 <strnlen>
  801836:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  801839:	29 c1                	sub    %eax,%ecx
  80183b:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  80183e:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  801841:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  801845:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801848:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  80184b:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  80184d:	eb 0f                	jmp    80185e <vprintfmt+0x1bd>
					putch(padc, putdat);
  80184f:	83 ec 08             	sub    $0x8,%esp
  801852:	53                   	push   %ebx
  801853:	ff 75 e0             	pushl  -0x20(%ebp)
  801856:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  801858:	83 ef 01             	sub    $0x1,%edi
  80185b:	83 c4 10             	add    $0x10,%esp
  80185e:	85 ff                	test   %edi,%edi
  801860:	7f ed                	jg     80184f <vprintfmt+0x1ae>
  801862:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  801865:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  801868:	85 c9                	test   %ecx,%ecx
  80186a:	b8 00 00 00 00       	mov    $0x0,%eax
  80186f:	0f 49 c1             	cmovns %ecx,%eax
  801872:	29 c1                	sub    %eax,%ecx
  801874:	89 75 08             	mov    %esi,0x8(%ebp)
  801877:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80187a:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80187d:	89 cb                	mov    %ecx,%ebx
  80187f:	eb 16                	jmp    801897 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  801881:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801885:	75 31                	jne    8018b8 <vprintfmt+0x217>
					putch(ch, putdat);
  801887:	83 ec 08             	sub    $0x8,%esp
  80188a:	ff 75 0c             	pushl  0xc(%ebp)
  80188d:	50                   	push   %eax
  80188e:	ff 55 08             	call   *0x8(%ebp)
  801891:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801894:	83 eb 01             	sub    $0x1,%ebx
  801897:	83 c7 01             	add    $0x1,%edi
  80189a:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  80189e:	0f be c2             	movsbl %dl,%eax
  8018a1:	85 c0                	test   %eax,%eax
  8018a3:	74 59                	je     8018fe <vprintfmt+0x25d>
  8018a5:	85 f6                	test   %esi,%esi
  8018a7:	78 d8                	js     801881 <vprintfmt+0x1e0>
  8018a9:	83 ee 01             	sub    $0x1,%esi
  8018ac:	79 d3                	jns    801881 <vprintfmt+0x1e0>
  8018ae:	89 df                	mov    %ebx,%edi
  8018b0:	8b 75 08             	mov    0x8(%ebp),%esi
  8018b3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8018b6:	eb 37                	jmp    8018ef <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  8018b8:	0f be d2             	movsbl %dl,%edx
  8018bb:	83 ea 20             	sub    $0x20,%edx
  8018be:	83 fa 5e             	cmp    $0x5e,%edx
  8018c1:	76 c4                	jbe    801887 <vprintfmt+0x1e6>
					putch('?', putdat);
  8018c3:	83 ec 08             	sub    $0x8,%esp
  8018c6:	ff 75 0c             	pushl  0xc(%ebp)
  8018c9:	6a 3f                	push   $0x3f
  8018cb:	ff 55 08             	call   *0x8(%ebp)
  8018ce:	83 c4 10             	add    $0x10,%esp
  8018d1:	eb c1                	jmp    801894 <vprintfmt+0x1f3>
  8018d3:	89 75 08             	mov    %esi,0x8(%ebp)
  8018d6:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8018d9:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8018dc:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8018df:	eb b6                	jmp    801897 <vprintfmt+0x1f6>
				putch(' ', putdat);
  8018e1:	83 ec 08             	sub    $0x8,%esp
  8018e4:	53                   	push   %ebx
  8018e5:	6a 20                	push   $0x20
  8018e7:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8018e9:	83 ef 01             	sub    $0x1,%edi
  8018ec:	83 c4 10             	add    $0x10,%esp
  8018ef:	85 ff                	test   %edi,%edi
  8018f1:	7f ee                	jg     8018e1 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  8018f3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8018f6:	89 45 14             	mov    %eax,0x14(%ebp)
  8018f9:	e9 d8 01 00 00       	jmp    801ad6 <vprintfmt+0x435>
  8018fe:	89 df                	mov    %ebx,%edi
  801900:	8b 75 08             	mov    0x8(%ebp),%esi
  801903:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801906:	eb e7                	jmp    8018ef <vprintfmt+0x24e>
	if (lflag >= 2)
  801908:	83 f9 01             	cmp    $0x1,%ecx
  80190b:	7e 45                	jle    801952 <vprintfmt+0x2b1>
		return va_arg(*ap, long long);
  80190d:	8b 45 14             	mov    0x14(%ebp),%eax
  801910:	8b 50 04             	mov    0x4(%eax),%edx
  801913:	8b 00                	mov    (%eax),%eax
  801915:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801918:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80191b:	8b 45 14             	mov    0x14(%ebp),%eax
  80191e:	8d 40 08             	lea    0x8(%eax),%eax
  801921:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  801924:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801928:	79 62                	jns    80198c <vprintfmt+0x2eb>
				putch('-', putdat);
  80192a:	83 ec 08             	sub    $0x8,%esp
  80192d:	53                   	push   %ebx
  80192e:	6a 2d                	push   $0x2d
  801930:	ff d6                	call   *%esi
				num = -(long long) num;
  801932:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801935:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801938:	f7 d8                	neg    %eax
  80193a:	83 d2 00             	adc    $0x0,%edx
  80193d:	f7 da                	neg    %edx
  80193f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801942:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801945:	83 c4 10             	add    $0x10,%esp
			base = 10;
  801948:	ba 0a 00 00 00       	mov    $0xa,%edx
  80194d:	e9 66 01 00 00       	jmp    801ab8 <vprintfmt+0x417>
	else if (lflag)
  801952:	85 c9                	test   %ecx,%ecx
  801954:	75 1b                	jne    801971 <vprintfmt+0x2d0>
		return va_arg(*ap, int);
  801956:	8b 45 14             	mov    0x14(%ebp),%eax
  801959:	8b 00                	mov    (%eax),%eax
  80195b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80195e:	89 c1                	mov    %eax,%ecx
  801960:	c1 f9 1f             	sar    $0x1f,%ecx
  801963:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  801966:	8b 45 14             	mov    0x14(%ebp),%eax
  801969:	8d 40 04             	lea    0x4(%eax),%eax
  80196c:	89 45 14             	mov    %eax,0x14(%ebp)
  80196f:	eb b3                	jmp    801924 <vprintfmt+0x283>
		return va_arg(*ap, long);
  801971:	8b 45 14             	mov    0x14(%ebp),%eax
  801974:	8b 00                	mov    (%eax),%eax
  801976:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801979:	89 c1                	mov    %eax,%ecx
  80197b:	c1 f9 1f             	sar    $0x1f,%ecx
  80197e:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  801981:	8b 45 14             	mov    0x14(%ebp),%eax
  801984:	8d 40 04             	lea    0x4(%eax),%eax
  801987:	89 45 14             	mov    %eax,0x14(%ebp)
  80198a:	eb 98                	jmp    801924 <vprintfmt+0x283>
			base = 10;
  80198c:	ba 0a 00 00 00       	mov    $0xa,%edx
  801991:	e9 22 01 00 00       	jmp    801ab8 <vprintfmt+0x417>
	if (lflag >= 2)
  801996:	83 f9 01             	cmp    $0x1,%ecx
  801999:	7e 21                	jle    8019bc <vprintfmt+0x31b>
		return va_arg(*ap, unsigned long long);
  80199b:	8b 45 14             	mov    0x14(%ebp),%eax
  80199e:	8b 50 04             	mov    0x4(%eax),%edx
  8019a1:	8b 00                	mov    (%eax),%eax
  8019a3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8019a6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8019a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8019ac:	8d 40 08             	lea    0x8(%eax),%eax
  8019af:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8019b2:	ba 0a 00 00 00       	mov    $0xa,%edx
  8019b7:	e9 fc 00 00 00       	jmp    801ab8 <vprintfmt+0x417>
	else if (lflag)
  8019bc:	85 c9                	test   %ecx,%ecx
  8019be:	75 23                	jne    8019e3 <vprintfmt+0x342>
		return va_arg(*ap, unsigned int);
  8019c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8019c3:	8b 00                	mov    (%eax),%eax
  8019c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8019ca:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8019cd:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8019d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8019d3:	8d 40 04             	lea    0x4(%eax),%eax
  8019d6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8019d9:	ba 0a 00 00 00       	mov    $0xa,%edx
  8019de:	e9 d5 00 00 00       	jmp    801ab8 <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  8019e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8019e6:	8b 00                	mov    (%eax),%eax
  8019e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8019ed:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8019f0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8019f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8019f6:	8d 40 04             	lea    0x4(%eax),%eax
  8019f9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8019fc:	ba 0a 00 00 00       	mov    $0xa,%edx
  801a01:	e9 b2 00 00 00       	jmp    801ab8 <vprintfmt+0x417>
	if (lflag >= 2)
  801a06:	83 f9 01             	cmp    $0x1,%ecx
  801a09:	7e 42                	jle    801a4d <vprintfmt+0x3ac>
		return va_arg(*ap, unsigned long long);
  801a0b:	8b 45 14             	mov    0x14(%ebp),%eax
  801a0e:	8b 50 04             	mov    0x4(%eax),%edx
  801a11:	8b 00                	mov    (%eax),%eax
  801a13:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801a16:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801a19:	8b 45 14             	mov    0x14(%ebp),%eax
  801a1c:	8d 40 08             	lea    0x8(%eax),%eax
  801a1f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801a22:	ba 08 00 00 00       	mov    $0x8,%edx
			if ((long long) num < 0) {
  801a27:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801a2b:	0f 89 87 00 00 00    	jns    801ab8 <vprintfmt+0x417>
				putch('-', putdat);
  801a31:	83 ec 08             	sub    $0x8,%esp
  801a34:	53                   	push   %ebx
  801a35:	6a 2d                	push   $0x2d
  801a37:	ff d6                	call   *%esi
				num = -(long long) num;
  801a39:	f7 5d d8             	negl   -0x28(%ebp)
  801a3c:	83 55 dc 00          	adcl   $0x0,-0x24(%ebp)
  801a40:	f7 5d dc             	negl   -0x24(%ebp)
  801a43:	83 c4 10             	add    $0x10,%esp
			base = 8;
  801a46:	ba 08 00 00 00       	mov    $0x8,%edx
  801a4b:	eb 6b                	jmp    801ab8 <vprintfmt+0x417>
	else if (lflag)
  801a4d:	85 c9                	test   %ecx,%ecx
  801a4f:	75 1b                	jne    801a6c <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  801a51:	8b 45 14             	mov    0x14(%ebp),%eax
  801a54:	8b 00                	mov    (%eax),%eax
  801a56:	ba 00 00 00 00       	mov    $0x0,%edx
  801a5b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801a5e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801a61:	8b 45 14             	mov    0x14(%ebp),%eax
  801a64:	8d 40 04             	lea    0x4(%eax),%eax
  801a67:	89 45 14             	mov    %eax,0x14(%ebp)
  801a6a:	eb b6                	jmp    801a22 <vprintfmt+0x381>
		return va_arg(*ap, unsigned long);
  801a6c:	8b 45 14             	mov    0x14(%ebp),%eax
  801a6f:	8b 00                	mov    (%eax),%eax
  801a71:	ba 00 00 00 00       	mov    $0x0,%edx
  801a76:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801a79:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801a7c:	8b 45 14             	mov    0x14(%ebp),%eax
  801a7f:	8d 40 04             	lea    0x4(%eax),%eax
  801a82:	89 45 14             	mov    %eax,0x14(%ebp)
  801a85:	eb 9b                	jmp    801a22 <vprintfmt+0x381>
			putch('0', putdat);
  801a87:	83 ec 08             	sub    $0x8,%esp
  801a8a:	53                   	push   %ebx
  801a8b:	6a 30                	push   $0x30
  801a8d:	ff d6                	call   *%esi
			putch('x', putdat);
  801a8f:	83 c4 08             	add    $0x8,%esp
  801a92:	53                   	push   %ebx
  801a93:	6a 78                	push   $0x78
  801a95:	ff d6                	call   *%esi
			num = (unsigned long long)
  801a97:	8b 45 14             	mov    0x14(%ebp),%eax
  801a9a:	8b 00                	mov    (%eax),%eax
  801a9c:	ba 00 00 00 00       	mov    $0x0,%edx
  801aa1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801aa4:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  801aa7:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  801aaa:	8b 45 14             	mov    0x14(%ebp),%eax
  801aad:	8d 40 04             	lea    0x4(%eax),%eax
  801ab0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801ab3:	ba 10 00 00 00       	mov    $0x10,%edx
			printnum(putch, putdat, num, base, width, padc);
  801ab8:	83 ec 0c             	sub    $0xc,%esp
  801abb:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  801abf:	50                   	push   %eax
  801ac0:	ff 75 e0             	pushl  -0x20(%ebp)
  801ac3:	52                   	push   %edx
  801ac4:	ff 75 dc             	pushl  -0x24(%ebp)
  801ac7:	ff 75 d8             	pushl  -0x28(%ebp)
  801aca:	89 da                	mov    %ebx,%edx
  801acc:	89 f0                	mov    %esi,%eax
  801ace:	e8 e5 fa ff ff       	call   8015b8 <printnum>
			break;
  801ad3:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  801ad6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801ad9:	83 c7 01             	add    $0x1,%edi
  801adc:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801ae0:	83 f8 25             	cmp    $0x25,%eax
  801ae3:	0f 84 cf fb ff ff    	je     8016b8 <vprintfmt+0x17>
			if (ch == '\0')
  801ae9:	85 c0                	test   %eax,%eax
  801aeb:	0f 84 a9 00 00 00    	je     801b9a <vprintfmt+0x4f9>
			putch(ch, putdat);
  801af1:	83 ec 08             	sub    $0x8,%esp
  801af4:	53                   	push   %ebx
  801af5:	50                   	push   %eax
  801af6:	ff d6                	call   *%esi
  801af8:	83 c4 10             	add    $0x10,%esp
  801afb:	eb dc                	jmp    801ad9 <vprintfmt+0x438>
	if (lflag >= 2)
  801afd:	83 f9 01             	cmp    $0x1,%ecx
  801b00:	7e 1e                	jle    801b20 <vprintfmt+0x47f>
		return va_arg(*ap, unsigned long long);
  801b02:	8b 45 14             	mov    0x14(%ebp),%eax
  801b05:	8b 50 04             	mov    0x4(%eax),%edx
  801b08:	8b 00                	mov    (%eax),%eax
  801b0a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801b0d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801b10:	8b 45 14             	mov    0x14(%ebp),%eax
  801b13:	8d 40 08             	lea    0x8(%eax),%eax
  801b16:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801b19:	ba 10 00 00 00       	mov    $0x10,%edx
  801b1e:	eb 98                	jmp    801ab8 <vprintfmt+0x417>
	else if (lflag)
  801b20:	85 c9                	test   %ecx,%ecx
  801b22:	75 23                	jne    801b47 <vprintfmt+0x4a6>
		return va_arg(*ap, unsigned int);
  801b24:	8b 45 14             	mov    0x14(%ebp),%eax
  801b27:	8b 00                	mov    (%eax),%eax
  801b29:	ba 00 00 00 00       	mov    $0x0,%edx
  801b2e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801b31:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801b34:	8b 45 14             	mov    0x14(%ebp),%eax
  801b37:	8d 40 04             	lea    0x4(%eax),%eax
  801b3a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801b3d:	ba 10 00 00 00       	mov    $0x10,%edx
  801b42:	e9 71 ff ff ff       	jmp    801ab8 <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  801b47:	8b 45 14             	mov    0x14(%ebp),%eax
  801b4a:	8b 00                	mov    (%eax),%eax
  801b4c:	ba 00 00 00 00       	mov    $0x0,%edx
  801b51:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801b54:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801b57:	8b 45 14             	mov    0x14(%ebp),%eax
  801b5a:	8d 40 04             	lea    0x4(%eax),%eax
  801b5d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801b60:	ba 10 00 00 00       	mov    $0x10,%edx
  801b65:	e9 4e ff ff ff       	jmp    801ab8 <vprintfmt+0x417>
			putch(ch, putdat);
  801b6a:	83 ec 08             	sub    $0x8,%esp
  801b6d:	53                   	push   %ebx
  801b6e:	6a 25                	push   $0x25
  801b70:	ff d6                	call   *%esi
			break;
  801b72:	83 c4 10             	add    $0x10,%esp
  801b75:	e9 5c ff ff ff       	jmp    801ad6 <vprintfmt+0x435>
			putch('%', putdat);
  801b7a:	83 ec 08             	sub    $0x8,%esp
  801b7d:	53                   	push   %ebx
  801b7e:	6a 25                	push   $0x25
  801b80:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  801b82:	83 c4 10             	add    $0x10,%esp
  801b85:	89 f8                	mov    %edi,%eax
  801b87:	eb 03                	jmp    801b8c <vprintfmt+0x4eb>
  801b89:	83 e8 01             	sub    $0x1,%eax
  801b8c:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  801b90:	75 f7                	jne    801b89 <vprintfmt+0x4e8>
  801b92:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801b95:	e9 3c ff ff ff       	jmp    801ad6 <vprintfmt+0x435>
}
  801b9a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b9d:	5b                   	pop    %ebx
  801b9e:	5e                   	pop    %esi
  801b9f:	5f                   	pop    %edi
  801ba0:	5d                   	pop    %ebp
  801ba1:	c3                   	ret    

00801ba2 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801ba2:	55                   	push   %ebp
  801ba3:	89 e5                	mov    %esp,%ebp
  801ba5:	83 ec 18             	sub    $0x18,%esp
  801ba8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bab:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801bae:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801bb1:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801bb5:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801bb8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801bbf:	85 c0                	test   %eax,%eax
  801bc1:	74 26                	je     801be9 <vsnprintf+0x47>
  801bc3:	85 d2                	test   %edx,%edx
  801bc5:	7e 22                	jle    801be9 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801bc7:	ff 75 14             	pushl  0x14(%ebp)
  801bca:	ff 75 10             	pushl  0x10(%ebp)
  801bcd:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801bd0:	50                   	push   %eax
  801bd1:	68 67 16 80 00       	push   $0x801667
  801bd6:	e8 c6 fa ff ff       	call   8016a1 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801bdb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bde:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801be1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801be4:	83 c4 10             	add    $0x10,%esp
}
  801be7:	c9                   	leave  
  801be8:	c3                   	ret    
		return -E_INVAL;
  801be9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801bee:	eb f7                	jmp    801be7 <vsnprintf+0x45>

00801bf0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801bf0:	55                   	push   %ebp
  801bf1:	89 e5                	mov    %esp,%ebp
  801bf3:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801bf6:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801bf9:	50                   	push   %eax
  801bfa:	ff 75 10             	pushl  0x10(%ebp)
  801bfd:	ff 75 0c             	pushl  0xc(%ebp)
  801c00:	ff 75 08             	pushl  0x8(%ebp)
  801c03:	e8 9a ff ff ff       	call   801ba2 <vsnprintf>
	va_end(ap);

	return rc;
}
  801c08:	c9                   	leave  
  801c09:	c3                   	ret    

00801c0a <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801c0a:	55                   	push   %ebp
  801c0b:	89 e5                	mov    %esp,%ebp
  801c0d:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801c10:	b8 00 00 00 00       	mov    $0x0,%eax
  801c15:	eb 03                	jmp    801c1a <strlen+0x10>
		n++;
  801c17:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  801c1a:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801c1e:	75 f7                	jne    801c17 <strlen+0xd>
	return n;
}
  801c20:	5d                   	pop    %ebp
  801c21:	c3                   	ret    

00801c22 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801c22:	55                   	push   %ebp
  801c23:	89 e5                	mov    %esp,%ebp
  801c25:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c28:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801c2b:	b8 00 00 00 00       	mov    $0x0,%eax
  801c30:	eb 03                	jmp    801c35 <strnlen+0x13>
		n++;
  801c32:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801c35:	39 d0                	cmp    %edx,%eax
  801c37:	74 06                	je     801c3f <strnlen+0x1d>
  801c39:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  801c3d:	75 f3                	jne    801c32 <strnlen+0x10>
	return n;
}
  801c3f:	5d                   	pop    %ebp
  801c40:	c3                   	ret    

00801c41 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801c41:	55                   	push   %ebp
  801c42:	89 e5                	mov    %esp,%ebp
  801c44:	53                   	push   %ebx
  801c45:	8b 45 08             	mov    0x8(%ebp),%eax
  801c48:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801c4b:	89 c2                	mov    %eax,%edx
  801c4d:	83 c1 01             	add    $0x1,%ecx
  801c50:	83 c2 01             	add    $0x1,%edx
  801c53:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  801c57:	88 5a ff             	mov    %bl,-0x1(%edx)
  801c5a:	84 db                	test   %bl,%bl
  801c5c:	75 ef                	jne    801c4d <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  801c5e:	5b                   	pop    %ebx
  801c5f:	5d                   	pop    %ebp
  801c60:	c3                   	ret    

00801c61 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801c61:	55                   	push   %ebp
  801c62:	89 e5                	mov    %esp,%ebp
  801c64:	53                   	push   %ebx
  801c65:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801c68:	53                   	push   %ebx
  801c69:	e8 9c ff ff ff       	call   801c0a <strlen>
  801c6e:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  801c71:	ff 75 0c             	pushl  0xc(%ebp)
  801c74:	01 d8                	add    %ebx,%eax
  801c76:	50                   	push   %eax
  801c77:	e8 c5 ff ff ff       	call   801c41 <strcpy>
	return dst;
}
  801c7c:	89 d8                	mov    %ebx,%eax
  801c7e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c81:	c9                   	leave  
  801c82:	c3                   	ret    

00801c83 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801c83:	55                   	push   %ebp
  801c84:	89 e5                	mov    %esp,%ebp
  801c86:	56                   	push   %esi
  801c87:	53                   	push   %ebx
  801c88:	8b 75 08             	mov    0x8(%ebp),%esi
  801c8b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c8e:	89 f3                	mov    %esi,%ebx
  801c90:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801c93:	89 f2                	mov    %esi,%edx
  801c95:	eb 0f                	jmp    801ca6 <strncpy+0x23>
		*dst++ = *src;
  801c97:	83 c2 01             	add    $0x1,%edx
  801c9a:	0f b6 01             	movzbl (%ecx),%eax
  801c9d:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801ca0:	80 39 01             	cmpb   $0x1,(%ecx)
  801ca3:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  801ca6:	39 da                	cmp    %ebx,%edx
  801ca8:	75 ed                	jne    801c97 <strncpy+0x14>
	}
	return ret;
}
  801caa:	89 f0                	mov    %esi,%eax
  801cac:	5b                   	pop    %ebx
  801cad:	5e                   	pop    %esi
  801cae:	5d                   	pop    %ebp
  801caf:	c3                   	ret    

00801cb0 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801cb0:	55                   	push   %ebp
  801cb1:	89 e5                	mov    %esp,%ebp
  801cb3:	56                   	push   %esi
  801cb4:	53                   	push   %ebx
  801cb5:	8b 75 08             	mov    0x8(%ebp),%esi
  801cb8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cbb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cbe:	89 f0                	mov    %esi,%eax
  801cc0:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801cc4:	85 c9                	test   %ecx,%ecx
  801cc6:	75 0b                	jne    801cd3 <strlcpy+0x23>
  801cc8:	eb 17                	jmp    801ce1 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  801cca:	83 c2 01             	add    $0x1,%edx
  801ccd:	83 c0 01             	add    $0x1,%eax
  801cd0:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  801cd3:	39 d8                	cmp    %ebx,%eax
  801cd5:	74 07                	je     801cde <strlcpy+0x2e>
  801cd7:	0f b6 0a             	movzbl (%edx),%ecx
  801cda:	84 c9                	test   %cl,%cl
  801cdc:	75 ec                	jne    801cca <strlcpy+0x1a>
		*dst = '\0';
  801cde:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801ce1:	29 f0                	sub    %esi,%eax
}
  801ce3:	5b                   	pop    %ebx
  801ce4:	5e                   	pop    %esi
  801ce5:	5d                   	pop    %ebp
  801ce6:	c3                   	ret    

00801ce7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801ce7:	55                   	push   %ebp
  801ce8:	89 e5                	mov    %esp,%ebp
  801cea:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ced:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801cf0:	eb 06                	jmp    801cf8 <strcmp+0x11>
		p++, q++;
  801cf2:	83 c1 01             	add    $0x1,%ecx
  801cf5:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  801cf8:	0f b6 01             	movzbl (%ecx),%eax
  801cfb:	84 c0                	test   %al,%al
  801cfd:	74 04                	je     801d03 <strcmp+0x1c>
  801cff:	3a 02                	cmp    (%edx),%al
  801d01:	74 ef                	je     801cf2 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801d03:	0f b6 c0             	movzbl %al,%eax
  801d06:	0f b6 12             	movzbl (%edx),%edx
  801d09:	29 d0                	sub    %edx,%eax
}
  801d0b:	5d                   	pop    %ebp
  801d0c:	c3                   	ret    

00801d0d <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801d0d:	55                   	push   %ebp
  801d0e:	89 e5                	mov    %esp,%ebp
  801d10:	53                   	push   %ebx
  801d11:	8b 45 08             	mov    0x8(%ebp),%eax
  801d14:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d17:	89 c3                	mov    %eax,%ebx
  801d19:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  801d1c:	eb 06                	jmp    801d24 <strncmp+0x17>
		n--, p++, q++;
  801d1e:	83 c0 01             	add    $0x1,%eax
  801d21:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  801d24:	39 d8                	cmp    %ebx,%eax
  801d26:	74 16                	je     801d3e <strncmp+0x31>
  801d28:	0f b6 08             	movzbl (%eax),%ecx
  801d2b:	84 c9                	test   %cl,%cl
  801d2d:	74 04                	je     801d33 <strncmp+0x26>
  801d2f:	3a 0a                	cmp    (%edx),%cl
  801d31:	74 eb                	je     801d1e <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801d33:	0f b6 00             	movzbl (%eax),%eax
  801d36:	0f b6 12             	movzbl (%edx),%edx
  801d39:	29 d0                	sub    %edx,%eax
}
  801d3b:	5b                   	pop    %ebx
  801d3c:	5d                   	pop    %ebp
  801d3d:	c3                   	ret    
		return 0;
  801d3e:	b8 00 00 00 00       	mov    $0x0,%eax
  801d43:	eb f6                	jmp    801d3b <strncmp+0x2e>

00801d45 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801d45:	55                   	push   %ebp
  801d46:	89 e5                	mov    %esp,%ebp
  801d48:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4b:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801d4f:	0f b6 10             	movzbl (%eax),%edx
  801d52:	84 d2                	test   %dl,%dl
  801d54:	74 09                	je     801d5f <strchr+0x1a>
		if (*s == c)
  801d56:	38 ca                	cmp    %cl,%dl
  801d58:	74 0a                	je     801d64 <strchr+0x1f>
	for (; *s; s++)
  801d5a:	83 c0 01             	add    $0x1,%eax
  801d5d:	eb f0                	jmp    801d4f <strchr+0xa>
			return (char *) s;
	return 0;
  801d5f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d64:	5d                   	pop    %ebp
  801d65:	c3                   	ret    

00801d66 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801d66:	55                   	push   %ebp
  801d67:	89 e5                	mov    %esp,%ebp
  801d69:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801d70:	eb 03                	jmp    801d75 <strfind+0xf>
  801d72:	83 c0 01             	add    $0x1,%eax
  801d75:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  801d78:	38 ca                	cmp    %cl,%dl
  801d7a:	74 04                	je     801d80 <strfind+0x1a>
  801d7c:	84 d2                	test   %dl,%dl
  801d7e:	75 f2                	jne    801d72 <strfind+0xc>
			break;
	return (char *) s;
}
  801d80:	5d                   	pop    %ebp
  801d81:	c3                   	ret    

00801d82 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801d82:	55                   	push   %ebp
  801d83:	89 e5                	mov    %esp,%ebp
  801d85:	57                   	push   %edi
  801d86:	56                   	push   %esi
  801d87:	53                   	push   %ebx
  801d88:	8b 7d 08             	mov    0x8(%ebp),%edi
  801d8b:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801d8e:	85 c9                	test   %ecx,%ecx
  801d90:	74 13                	je     801da5 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801d92:	f7 c7 03 00 00 00    	test   $0x3,%edi
  801d98:	75 05                	jne    801d9f <memset+0x1d>
  801d9a:	f6 c1 03             	test   $0x3,%cl
  801d9d:	74 0d                	je     801dac <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801d9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801da2:	fc                   	cld    
  801da3:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801da5:	89 f8                	mov    %edi,%eax
  801da7:	5b                   	pop    %ebx
  801da8:	5e                   	pop    %esi
  801da9:	5f                   	pop    %edi
  801daa:	5d                   	pop    %ebp
  801dab:	c3                   	ret    
		c &= 0xFF;
  801dac:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801db0:	89 d3                	mov    %edx,%ebx
  801db2:	c1 e3 08             	shl    $0x8,%ebx
  801db5:	89 d0                	mov    %edx,%eax
  801db7:	c1 e0 18             	shl    $0x18,%eax
  801dba:	89 d6                	mov    %edx,%esi
  801dbc:	c1 e6 10             	shl    $0x10,%esi
  801dbf:	09 f0                	or     %esi,%eax
  801dc1:	09 c2                	or     %eax,%edx
  801dc3:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  801dc5:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  801dc8:	89 d0                	mov    %edx,%eax
  801dca:	fc                   	cld    
  801dcb:	f3 ab                	rep stos %eax,%es:(%edi)
  801dcd:	eb d6                	jmp    801da5 <memset+0x23>

00801dcf <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801dcf:	55                   	push   %ebp
  801dd0:	89 e5                	mov    %esp,%ebp
  801dd2:	57                   	push   %edi
  801dd3:	56                   	push   %esi
  801dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd7:	8b 75 0c             	mov    0xc(%ebp),%esi
  801dda:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801ddd:	39 c6                	cmp    %eax,%esi
  801ddf:	73 35                	jae    801e16 <memmove+0x47>
  801de1:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801de4:	39 c2                	cmp    %eax,%edx
  801de6:	76 2e                	jbe    801e16 <memmove+0x47>
		s += n;
		d += n;
  801de8:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801deb:	89 d6                	mov    %edx,%esi
  801ded:	09 fe                	or     %edi,%esi
  801def:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801df5:	74 0c                	je     801e03 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801df7:	83 ef 01             	sub    $0x1,%edi
  801dfa:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  801dfd:	fd                   	std    
  801dfe:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801e00:	fc                   	cld    
  801e01:	eb 21                	jmp    801e24 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801e03:	f6 c1 03             	test   $0x3,%cl
  801e06:	75 ef                	jne    801df7 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801e08:	83 ef 04             	sub    $0x4,%edi
  801e0b:	8d 72 fc             	lea    -0x4(%edx),%esi
  801e0e:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  801e11:	fd                   	std    
  801e12:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801e14:	eb ea                	jmp    801e00 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801e16:	89 f2                	mov    %esi,%edx
  801e18:	09 c2                	or     %eax,%edx
  801e1a:	f6 c2 03             	test   $0x3,%dl
  801e1d:	74 09                	je     801e28 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801e1f:	89 c7                	mov    %eax,%edi
  801e21:	fc                   	cld    
  801e22:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801e24:	5e                   	pop    %esi
  801e25:	5f                   	pop    %edi
  801e26:	5d                   	pop    %ebp
  801e27:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801e28:	f6 c1 03             	test   $0x3,%cl
  801e2b:	75 f2                	jne    801e1f <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801e2d:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  801e30:	89 c7                	mov    %eax,%edi
  801e32:	fc                   	cld    
  801e33:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801e35:	eb ed                	jmp    801e24 <memmove+0x55>

00801e37 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801e37:	55                   	push   %ebp
  801e38:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  801e3a:	ff 75 10             	pushl  0x10(%ebp)
  801e3d:	ff 75 0c             	pushl  0xc(%ebp)
  801e40:	ff 75 08             	pushl  0x8(%ebp)
  801e43:	e8 87 ff ff ff       	call   801dcf <memmove>
}
  801e48:	c9                   	leave  
  801e49:	c3                   	ret    

00801e4a <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801e4a:	55                   	push   %ebp
  801e4b:	89 e5                	mov    %esp,%ebp
  801e4d:	56                   	push   %esi
  801e4e:	53                   	push   %ebx
  801e4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e52:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e55:	89 c6                	mov    %eax,%esi
  801e57:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801e5a:	39 f0                	cmp    %esi,%eax
  801e5c:	74 1c                	je     801e7a <memcmp+0x30>
		if (*s1 != *s2)
  801e5e:	0f b6 08             	movzbl (%eax),%ecx
  801e61:	0f b6 1a             	movzbl (%edx),%ebx
  801e64:	38 d9                	cmp    %bl,%cl
  801e66:	75 08                	jne    801e70 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801e68:	83 c0 01             	add    $0x1,%eax
  801e6b:	83 c2 01             	add    $0x1,%edx
  801e6e:	eb ea                	jmp    801e5a <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  801e70:	0f b6 c1             	movzbl %cl,%eax
  801e73:	0f b6 db             	movzbl %bl,%ebx
  801e76:	29 d8                	sub    %ebx,%eax
  801e78:	eb 05                	jmp    801e7f <memcmp+0x35>
	}

	return 0;
  801e7a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e7f:	5b                   	pop    %ebx
  801e80:	5e                   	pop    %esi
  801e81:	5d                   	pop    %ebp
  801e82:	c3                   	ret    

00801e83 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801e83:	55                   	push   %ebp
  801e84:	89 e5                	mov    %esp,%ebp
  801e86:	8b 45 08             	mov    0x8(%ebp),%eax
  801e89:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801e8c:	89 c2                	mov    %eax,%edx
  801e8e:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801e91:	39 d0                	cmp    %edx,%eax
  801e93:	73 09                	jae    801e9e <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  801e95:	38 08                	cmp    %cl,(%eax)
  801e97:	74 05                	je     801e9e <memfind+0x1b>
	for (; s < ends; s++)
  801e99:	83 c0 01             	add    $0x1,%eax
  801e9c:	eb f3                	jmp    801e91 <memfind+0xe>
			break;
	return (void *) s;
}
  801e9e:	5d                   	pop    %ebp
  801e9f:	c3                   	ret    

00801ea0 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801ea0:	55                   	push   %ebp
  801ea1:	89 e5                	mov    %esp,%ebp
  801ea3:	57                   	push   %edi
  801ea4:	56                   	push   %esi
  801ea5:	53                   	push   %ebx
  801ea6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ea9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801eac:	eb 03                	jmp    801eb1 <strtol+0x11>
		s++;
  801eae:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  801eb1:	0f b6 01             	movzbl (%ecx),%eax
  801eb4:	3c 20                	cmp    $0x20,%al
  801eb6:	74 f6                	je     801eae <strtol+0xe>
  801eb8:	3c 09                	cmp    $0x9,%al
  801eba:	74 f2                	je     801eae <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  801ebc:	3c 2b                	cmp    $0x2b,%al
  801ebe:	74 2e                	je     801eee <strtol+0x4e>
	int neg = 0;
  801ec0:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801ec5:	3c 2d                	cmp    $0x2d,%al
  801ec7:	74 2f                	je     801ef8 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801ec9:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  801ecf:	75 05                	jne    801ed6 <strtol+0x36>
  801ed1:	80 39 30             	cmpb   $0x30,(%ecx)
  801ed4:	74 2c                	je     801f02 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  801ed6:	85 db                	test   %ebx,%ebx
  801ed8:	75 0a                	jne    801ee4 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801eda:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  801edf:	80 39 30             	cmpb   $0x30,(%ecx)
  801ee2:	74 28                	je     801f0c <strtol+0x6c>
		base = 10;
  801ee4:	b8 00 00 00 00       	mov    $0x0,%eax
  801ee9:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801eec:	eb 50                	jmp    801f3e <strtol+0x9e>
		s++;
  801eee:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  801ef1:	bf 00 00 00 00       	mov    $0x0,%edi
  801ef6:	eb d1                	jmp    801ec9 <strtol+0x29>
		s++, neg = 1;
  801ef8:	83 c1 01             	add    $0x1,%ecx
  801efb:	bf 01 00 00 00       	mov    $0x1,%edi
  801f00:	eb c7                	jmp    801ec9 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801f02:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801f06:	74 0e                	je     801f16 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  801f08:	85 db                	test   %ebx,%ebx
  801f0a:	75 d8                	jne    801ee4 <strtol+0x44>
		s++, base = 8;
  801f0c:	83 c1 01             	add    $0x1,%ecx
  801f0f:	bb 08 00 00 00       	mov    $0x8,%ebx
  801f14:	eb ce                	jmp    801ee4 <strtol+0x44>
		s += 2, base = 16;
  801f16:	83 c1 02             	add    $0x2,%ecx
  801f19:	bb 10 00 00 00       	mov    $0x10,%ebx
  801f1e:	eb c4                	jmp    801ee4 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  801f20:	8d 72 9f             	lea    -0x61(%edx),%esi
  801f23:	89 f3                	mov    %esi,%ebx
  801f25:	80 fb 19             	cmp    $0x19,%bl
  801f28:	77 29                	ja     801f53 <strtol+0xb3>
			dig = *s - 'a' + 10;
  801f2a:	0f be d2             	movsbl %dl,%edx
  801f2d:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801f30:	3b 55 10             	cmp    0x10(%ebp),%edx
  801f33:	7d 30                	jge    801f65 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  801f35:	83 c1 01             	add    $0x1,%ecx
  801f38:	0f af 45 10          	imul   0x10(%ebp),%eax
  801f3c:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801f3e:	0f b6 11             	movzbl (%ecx),%edx
  801f41:	8d 72 d0             	lea    -0x30(%edx),%esi
  801f44:	89 f3                	mov    %esi,%ebx
  801f46:	80 fb 09             	cmp    $0x9,%bl
  801f49:	77 d5                	ja     801f20 <strtol+0x80>
			dig = *s - '0';
  801f4b:	0f be d2             	movsbl %dl,%edx
  801f4e:	83 ea 30             	sub    $0x30,%edx
  801f51:	eb dd                	jmp    801f30 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  801f53:	8d 72 bf             	lea    -0x41(%edx),%esi
  801f56:	89 f3                	mov    %esi,%ebx
  801f58:	80 fb 19             	cmp    $0x19,%bl
  801f5b:	77 08                	ja     801f65 <strtol+0xc5>
			dig = *s - 'A' + 10;
  801f5d:	0f be d2             	movsbl %dl,%edx
  801f60:	83 ea 37             	sub    $0x37,%edx
  801f63:	eb cb                	jmp    801f30 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  801f65:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801f69:	74 05                	je     801f70 <strtol+0xd0>
		*endptr = (char *) s;
  801f6b:	8b 75 0c             	mov    0xc(%ebp),%esi
  801f6e:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801f70:	89 c2                	mov    %eax,%edx
  801f72:	f7 da                	neg    %edx
  801f74:	85 ff                	test   %edi,%edi
  801f76:	0f 45 c2             	cmovne %edx,%eax
}
  801f79:	5b                   	pop    %ebx
  801f7a:	5e                   	pop    %esi
  801f7b:	5f                   	pop    %edi
  801f7c:	5d                   	pop    %ebp
  801f7d:	c3                   	ret    

00801f7e <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801f7e:	55                   	push   %ebp
  801f7f:	89 e5                	mov    %esp,%ebp
  801f81:	56                   	push   %esi
  801f82:	53                   	push   %ebx
  801f83:	8b 75 08             	mov    0x8(%ebp),%esi
  801f86:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f89:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
  801f8c:	85 c0                	test   %eax,%eax
	    pg = (void *)UTOP;
  801f8e:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801f93:	0f 44 c2             	cmove  %edx,%eax
	}
	if ((r = sys_ipc_recv(pg)) < 0) {
  801f96:	83 ec 0c             	sub    $0xc,%esp
  801f99:	50                   	push   %eax
  801f9a:	e8 6b e3 ff ff       	call   80030a <sys_ipc_recv>
  801f9f:	83 c4 10             	add    $0x10,%esp
  801fa2:	85 c0                	test   %eax,%eax
  801fa4:	78 2b                	js     801fd1 <ipc_recv+0x53>
	    if (perm_store != NULL) {
	        *perm_store = 0;
	    }
	    return r;
	}
	if (from_env_store != NULL) {
  801fa6:	85 f6                	test   %esi,%esi
  801fa8:	74 0a                	je     801fb4 <ipc_recv+0x36>
	    *from_env_store = thisenv->env_ipc_from;
  801faa:	a1 08 40 80 00       	mov    0x804008,%eax
  801faf:	8b 40 74             	mov    0x74(%eax),%eax
  801fb2:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store != NULL) {
  801fb4:	85 db                	test   %ebx,%ebx
  801fb6:	74 0a                	je     801fc2 <ipc_recv+0x44>
	    *perm_store = thisenv->env_ipc_perm;
  801fb8:	a1 08 40 80 00       	mov    0x804008,%eax
  801fbd:	8b 40 78             	mov    0x78(%eax),%eax
  801fc0:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  801fc2:	a1 08 40 80 00       	mov    0x804008,%eax
  801fc7:	8b 40 70             	mov    0x70(%eax),%eax
}
  801fca:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fcd:	5b                   	pop    %ebx
  801fce:	5e                   	pop    %esi
  801fcf:	5d                   	pop    %ebp
  801fd0:	c3                   	ret    
	    if (from_env_store != NULL) {
  801fd1:	85 f6                	test   %esi,%esi
  801fd3:	74 06                	je     801fdb <ipc_recv+0x5d>
	        *from_env_store = 0;
  801fd5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	    if (perm_store != NULL) {
  801fdb:	85 db                	test   %ebx,%ebx
  801fdd:	74 eb                	je     801fca <ipc_recv+0x4c>
	        *perm_store = 0;
  801fdf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801fe5:	eb e3                	jmp    801fca <ipc_recv+0x4c>

00801fe7 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801fe7:	55                   	push   %ebp
  801fe8:	89 e5                	mov    %esp,%ebp
  801fea:	57                   	push   %edi
  801feb:	56                   	push   %esi
  801fec:	53                   	push   %ebx
  801fed:	83 ec 0c             	sub    $0xc,%esp
  801ff0:	8b 7d 08             	mov    0x8(%ebp),%edi
  801ff3:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
	    pg = (void *)UTOP;
  801ff6:	85 f6                	test   %esi,%esi
  801ff8:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801ffd:	0f 44 f0             	cmove  %eax,%esi
  802000:	eb 09                	jmp    80200b <ipc_send+0x24>
	do {
	    r = sys_ipc_try_send(to_env, val, pg, perm);
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
	        panic("ipc_send: %e", r);
	    }
	    sys_yield();
  802002:	e8 34 e1 ff ff       	call   80013b <sys_yield>
	} while(r != 0);
  802007:	85 db                	test   %ebx,%ebx
  802009:	74 2d                	je     802038 <ipc_send+0x51>
	    r = sys_ipc_try_send(to_env, val, pg, perm);
  80200b:	ff 75 14             	pushl  0x14(%ebp)
  80200e:	56                   	push   %esi
  80200f:	ff 75 0c             	pushl  0xc(%ebp)
  802012:	57                   	push   %edi
  802013:	e8 cf e2 ff ff       	call   8002e7 <sys_ipc_try_send>
  802018:	89 c3                	mov    %eax,%ebx
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
  80201a:	83 c4 10             	add    $0x10,%esp
  80201d:	85 c0                	test   %eax,%eax
  80201f:	79 e1                	jns    802002 <ipc_send+0x1b>
  802021:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802024:	74 dc                	je     802002 <ipc_send+0x1b>
	        panic("ipc_send: %e", r);
  802026:	50                   	push   %eax
  802027:	68 c0 27 80 00       	push   $0x8027c0
  80202c:	6a 45                	push   $0x45
  80202e:	68 cd 27 80 00       	push   $0x8027cd
  802033:	e8 91 f4 ff ff       	call   8014c9 <_panic>
}
  802038:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80203b:	5b                   	pop    %ebx
  80203c:	5e                   	pop    %esi
  80203d:	5f                   	pop    %edi
  80203e:	5d                   	pop    %ebp
  80203f:	c3                   	ret    

00802040 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802040:	55                   	push   %ebp
  802041:	89 e5                	mov    %esp,%ebp
  802043:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802046:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80204b:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80204e:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802054:	8b 52 50             	mov    0x50(%edx),%edx
  802057:	39 ca                	cmp    %ecx,%edx
  802059:	74 11                	je     80206c <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  80205b:	83 c0 01             	add    $0x1,%eax
  80205e:	3d 00 04 00 00       	cmp    $0x400,%eax
  802063:	75 e6                	jne    80204b <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802065:	b8 00 00 00 00       	mov    $0x0,%eax
  80206a:	eb 0b                	jmp    802077 <ipc_find_env+0x37>
			return envs[i].env_id;
  80206c:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80206f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802074:	8b 40 48             	mov    0x48(%eax),%eax
}
  802077:	5d                   	pop    %ebp
  802078:	c3                   	ret    

00802079 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802079:	55                   	push   %ebp
  80207a:	89 e5                	mov    %esp,%ebp
  80207c:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80207f:	89 d0                	mov    %edx,%eax
  802081:	c1 e8 16             	shr    $0x16,%eax
  802084:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80208b:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802090:	f6 c1 01             	test   $0x1,%cl
  802093:	74 1d                	je     8020b2 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802095:	c1 ea 0c             	shr    $0xc,%edx
  802098:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80209f:	f6 c2 01             	test   $0x1,%dl
  8020a2:	74 0e                	je     8020b2 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8020a4:	c1 ea 0c             	shr    $0xc,%edx
  8020a7:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8020ae:	ef 
  8020af:	0f b7 c0             	movzwl %ax,%eax
}
  8020b2:	5d                   	pop    %ebp
  8020b3:	c3                   	ret    
  8020b4:	66 90                	xchg   %ax,%ax
  8020b6:	66 90                	xchg   %ax,%ax
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
