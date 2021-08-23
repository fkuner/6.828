
obj/user/buggyhello.debug:     file format elf32-i386


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
  80002c:	e8 16 00 00 00       	call   800047 <libmain>
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
	sys_cputs((char*)1, 1);
  800039:	6a 01                	push   $0x1
  80003b:	6a 01                	push   $0x1
  80003d:	e8 65 00 00 00       	call   8000a7 <sys_cputs>
}
  800042:	83 c4 10             	add    $0x10,%esp
  800045:	c9                   	leave  
  800046:	c3                   	ret    

00800047 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800047:	55                   	push   %ebp
  800048:	89 e5                	mov    %esp,%ebp
  80004a:	56                   	push   %esi
  80004b:	53                   	push   %ebx
  80004c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80004f:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
    thisenv = &envs[ENVX(sys_getenvid())];
  800052:	e8 ce 00 00 00       	call   800125 <sys_getenvid>
  800057:	25 ff 03 00 00       	and    $0x3ff,%eax
  80005c:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80005f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800064:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800069:	85 db                	test   %ebx,%ebx
  80006b:	7e 07                	jle    800074 <libmain+0x2d>
		binaryname = argv[0];
  80006d:	8b 06                	mov    (%esi),%eax
  80006f:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800074:	83 ec 08             	sub    $0x8,%esp
  800077:	56                   	push   %esi
  800078:	53                   	push   %ebx
  800079:	e8 b5 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80007e:	e8 0a 00 00 00       	call   80008d <exit>
}
  800083:	83 c4 10             	add    $0x10,%esp
  800086:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800089:	5b                   	pop    %ebx
  80008a:	5e                   	pop    %esi
  80008b:	5d                   	pop    %ebp
  80008c:	c3                   	ret    

0080008d <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80008d:	55                   	push   %ebp
  80008e:	89 e5                	mov    %esp,%ebp
  800090:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800093:	e8 b1 04 00 00       	call   800549 <close_all>
	sys_env_destroy(0);
  800098:	83 ec 0c             	sub    $0xc,%esp
  80009b:	6a 00                	push   $0x0
  80009d:	e8 42 00 00 00       	call   8000e4 <sys_env_destroy>
}
  8000a2:	83 c4 10             	add    $0x10,%esp
  8000a5:	c9                   	leave  
  8000a6:	c3                   	ret    

008000a7 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000a7:	55                   	push   %ebp
  8000a8:	89 e5                	mov    %esp,%ebp
  8000aa:	57                   	push   %edi
  8000ab:	56                   	push   %esi
  8000ac:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8000b5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000b8:	89 c3                	mov    %eax,%ebx
  8000ba:	89 c7                	mov    %eax,%edi
  8000bc:	89 c6                	mov    %eax,%esi
  8000be:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000c0:	5b                   	pop    %ebx
  8000c1:	5e                   	pop    %esi
  8000c2:	5f                   	pop    %edi
  8000c3:	5d                   	pop    %ebp
  8000c4:	c3                   	ret    

008000c5 <sys_cgetc>:

int
sys_cgetc(void)
{
  8000c5:	55                   	push   %ebp
  8000c6:	89 e5                	mov    %esp,%ebp
  8000c8:	57                   	push   %edi
  8000c9:	56                   	push   %esi
  8000ca:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8000d0:	b8 01 00 00 00       	mov    $0x1,%eax
  8000d5:	89 d1                	mov    %edx,%ecx
  8000d7:	89 d3                	mov    %edx,%ebx
  8000d9:	89 d7                	mov    %edx,%edi
  8000db:	89 d6                	mov    %edx,%esi
  8000dd:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000df:	5b                   	pop    %ebx
  8000e0:	5e                   	pop    %esi
  8000e1:	5f                   	pop    %edi
  8000e2:	5d                   	pop    %ebp
  8000e3:	c3                   	ret    

008000e4 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000e4:	55                   	push   %ebp
  8000e5:	89 e5                	mov    %esp,%ebp
  8000e7:	57                   	push   %edi
  8000e8:	56                   	push   %esi
  8000e9:	53                   	push   %ebx
  8000ea:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8000ed:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8000f5:	b8 03 00 00 00       	mov    $0x3,%eax
  8000fa:	89 cb                	mov    %ecx,%ebx
  8000fc:	89 cf                	mov    %ecx,%edi
  8000fe:	89 ce                	mov    %ecx,%esi
  800100:	cd 30                	int    $0x30
	if(check && ret > 0)
  800102:	85 c0                	test   %eax,%eax
  800104:	7f 08                	jg     80010e <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800106:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800109:	5b                   	pop    %ebx
  80010a:	5e                   	pop    %esi
  80010b:	5f                   	pop    %edi
  80010c:	5d                   	pop    %ebp
  80010d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80010e:	83 ec 0c             	sub    $0xc,%esp
  800111:	50                   	push   %eax
  800112:	6a 03                	push   $0x3
  800114:	68 0a 23 80 00       	push   $0x80230a
  800119:	6a 23                	push   $0x23
  80011b:	68 27 23 80 00       	push   $0x802327
  800120:	e8 ad 13 00 00       	call   8014d2 <_panic>

00800125 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800125:	55                   	push   %ebp
  800126:	89 e5                	mov    %esp,%ebp
  800128:	57                   	push   %edi
  800129:	56                   	push   %esi
  80012a:	53                   	push   %ebx
	asm volatile("int %1\n"
  80012b:	ba 00 00 00 00       	mov    $0x0,%edx
  800130:	b8 02 00 00 00       	mov    $0x2,%eax
  800135:	89 d1                	mov    %edx,%ecx
  800137:	89 d3                	mov    %edx,%ebx
  800139:	89 d7                	mov    %edx,%edi
  80013b:	89 d6                	mov    %edx,%esi
  80013d:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80013f:	5b                   	pop    %ebx
  800140:	5e                   	pop    %esi
  800141:	5f                   	pop    %edi
  800142:	5d                   	pop    %ebp
  800143:	c3                   	ret    

00800144 <sys_yield>:

void
sys_yield(void)
{
  800144:	55                   	push   %ebp
  800145:	89 e5                	mov    %esp,%ebp
  800147:	57                   	push   %edi
  800148:	56                   	push   %esi
  800149:	53                   	push   %ebx
	asm volatile("int %1\n"
  80014a:	ba 00 00 00 00       	mov    $0x0,%edx
  80014f:	b8 0b 00 00 00       	mov    $0xb,%eax
  800154:	89 d1                	mov    %edx,%ecx
  800156:	89 d3                	mov    %edx,%ebx
  800158:	89 d7                	mov    %edx,%edi
  80015a:	89 d6                	mov    %edx,%esi
  80015c:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80015e:	5b                   	pop    %ebx
  80015f:	5e                   	pop    %esi
  800160:	5f                   	pop    %edi
  800161:	5d                   	pop    %ebp
  800162:	c3                   	ret    

00800163 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800163:	55                   	push   %ebp
  800164:	89 e5                	mov    %esp,%ebp
  800166:	57                   	push   %edi
  800167:	56                   	push   %esi
  800168:	53                   	push   %ebx
  800169:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80016c:	be 00 00 00 00       	mov    $0x0,%esi
  800171:	8b 55 08             	mov    0x8(%ebp),%edx
  800174:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800177:	b8 04 00 00 00       	mov    $0x4,%eax
  80017c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80017f:	89 f7                	mov    %esi,%edi
  800181:	cd 30                	int    $0x30
	if(check && ret > 0)
  800183:	85 c0                	test   %eax,%eax
  800185:	7f 08                	jg     80018f <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800187:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80018a:	5b                   	pop    %ebx
  80018b:	5e                   	pop    %esi
  80018c:	5f                   	pop    %edi
  80018d:	5d                   	pop    %ebp
  80018e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80018f:	83 ec 0c             	sub    $0xc,%esp
  800192:	50                   	push   %eax
  800193:	6a 04                	push   $0x4
  800195:	68 0a 23 80 00       	push   $0x80230a
  80019a:	6a 23                	push   $0x23
  80019c:	68 27 23 80 00       	push   $0x802327
  8001a1:	e8 2c 13 00 00       	call   8014d2 <_panic>

008001a6 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001a6:	55                   	push   %ebp
  8001a7:	89 e5                	mov    %esp,%ebp
  8001a9:	57                   	push   %edi
  8001aa:	56                   	push   %esi
  8001ab:	53                   	push   %ebx
  8001ac:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001af:	8b 55 08             	mov    0x8(%ebp),%edx
  8001b2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001b5:	b8 05 00 00 00       	mov    $0x5,%eax
  8001ba:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001bd:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001c0:	8b 75 18             	mov    0x18(%ebp),%esi
  8001c3:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001c5:	85 c0                	test   %eax,%eax
  8001c7:	7f 08                	jg     8001d1 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001cc:	5b                   	pop    %ebx
  8001cd:	5e                   	pop    %esi
  8001ce:	5f                   	pop    %edi
  8001cf:	5d                   	pop    %ebp
  8001d0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001d1:	83 ec 0c             	sub    $0xc,%esp
  8001d4:	50                   	push   %eax
  8001d5:	6a 05                	push   $0x5
  8001d7:	68 0a 23 80 00       	push   $0x80230a
  8001dc:	6a 23                	push   $0x23
  8001de:	68 27 23 80 00       	push   $0x802327
  8001e3:	e8 ea 12 00 00       	call   8014d2 <_panic>

008001e8 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001e8:	55                   	push   %ebp
  8001e9:	89 e5                	mov    %esp,%ebp
  8001eb:	57                   	push   %edi
  8001ec:	56                   	push   %esi
  8001ed:	53                   	push   %ebx
  8001ee:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001f1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8001f9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001fc:	b8 06 00 00 00       	mov    $0x6,%eax
  800201:	89 df                	mov    %ebx,%edi
  800203:	89 de                	mov    %ebx,%esi
  800205:	cd 30                	int    $0x30
	if(check && ret > 0)
  800207:	85 c0                	test   %eax,%eax
  800209:	7f 08                	jg     800213 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80020b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80020e:	5b                   	pop    %ebx
  80020f:	5e                   	pop    %esi
  800210:	5f                   	pop    %edi
  800211:	5d                   	pop    %ebp
  800212:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800213:	83 ec 0c             	sub    $0xc,%esp
  800216:	50                   	push   %eax
  800217:	6a 06                	push   $0x6
  800219:	68 0a 23 80 00       	push   $0x80230a
  80021e:	6a 23                	push   $0x23
  800220:	68 27 23 80 00       	push   $0x802327
  800225:	e8 a8 12 00 00       	call   8014d2 <_panic>

0080022a <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80022a:	55                   	push   %ebp
  80022b:	89 e5                	mov    %esp,%ebp
  80022d:	57                   	push   %edi
  80022e:	56                   	push   %esi
  80022f:	53                   	push   %ebx
  800230:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800233:	bb 00 00 00 00       	mov    $0x0,%ebx
  800238:	8b 55 08             	mov    0x8(%ebp),%edx
  80023b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80023e:	b8 08 00 00 00       	mov    $0x8,%eax
  800243:	89 df                	mov    %ebx,%edi
  800245:	89 de                	mov    %ebx,%esi
  800247:	cd 30                	int    $0x30
	if(check && ret > 0)
  800249:	85 c0                	test   %eax,%eax
  80024b:	7f 08                	jg     800255 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80024d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800250:	5b                   	pop    %ebx
  800251:	5e                   	pop    %esi
  800252:	5f                   	pop    %edi
  800253:	5d                   	pop    %ebp
  800254:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800255:	83 ec 0c             	sub    $0xc,%esp
  800258:	50                   	push   %eax
  800259:	6a 08                	push   $0x8
  80025b:	68 0a 23 80 00       	push   $0x80230a
  800260:	6a 23                	push   $0x23
  800262:	68 27 23 80 00       	push   $0x802327
  800267:	e8 66 12 00 00       	call   8014d2 <_panic>

0080026c <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80026c:	55                   	push   %ebp
  80026d:	89 e5                	mov    %esp,%ebp
  80026f:	57                   	push   %edi
  800270:	56                   	push   %esi
  800271:	53                   	push   %ebx
  800272:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800275:	bb 00 00 00 00       	mov    $0x0,%ebx
  80027a:	8b 55 08             	mov    0x8(%ebp),%edx
  80027d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800280:	b8 09 00 00 00       	mov    $0x9,%eax
  800285:	89 df                	mov    %ebx,%edi
  800287:	89 de                	mov    %ebx,%esi
  800289:	cd 30                	int    $0x30
	if(check && ret > 0)
  80028b:	85 c0                	test   %eax,%eax
  80028d:	7f 08                	jg     800297 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80028f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800292:	5b                   	pop    %ebx
  800293:	5e                   	pop    %esi
  800294:	5f                   	pop    %edi
  800295:	5d                   	pop    %ebp
  800296:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800297:	83 ec 0c             	sub    $0xc,%esp
  80029a:	50                   	push   %eax
  80029b:	6a 09                	push   $0x9
  80029d:	68 0a 23 80 00       	push   $0x80230a
  8002a2:	6a 23                	push   $0x23
  8002a4:	68 27 23 80 00       	push   $0x802327
  8002a9:	e8 24 12 00 00       	call   8014d2 <_panic>

008002ae <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002ae:	55                   	push   %ebp
  8002af:	89 e5                	mov    %esp,%ebp
  8002b1:	57                   	push   %edi
  8002b2:	56                   	push   %esi
  8002b3:	53                   	push   %ebx
  8002b4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002b7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8002bf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002c2:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002c7:	89 df                	mov    %ebx,%edi
  8002c9:	89 de                	mov    %ebx,%esi
  8002cb:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002cd:	85 c0                	test   %eax,%eax
  8002cf:	7f 08                	jg     8002d9 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8002d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002d4:	5b                   	pop    %ebx
  8002d5:	5e                   	pop    %esi
  8002d6:	5f                   	pop    %edi
  8002d7:	5d                   	pop    %ebp
  8002d8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002d9:	83 ec 0c             	sub    $0xc,%esp
  8002dc:	50                   	push   %eax
  8002dd:	6a 0a                	push   $0xa
  8002df:	68 0a 23 80 00       	push   $0x80230a
  8002e4:	6a 23                	push   $0x23
  8002e6:	68 27 23 80 00       	push   $0x802327
  8002eb:	e8 e2 11 00 00       	call   8014d2 <_panic>

008002f0 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8002f0:	55                   	push   %ebp
  8002f1:	89 e5                	mov    %esp,%ebp
  8002f3:	57                   	push   %edi
  8002f4:	56                   	push   %esi
  8002f5:	53                   	push   %ebx
	asm volatile("int %1\n"
  8002f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8002f9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002fc:	b8 0c 00 00 00       	mov    $0xc,%eax
  800301:	be 00 00 00 00       	mov    $0x0,%esi
  800306:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800309:	8b 7d 14             	mov    0x14(%ebp),%edi
  80030c:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80030e:	5b                   	pop    %ebx
  80030f:	5e                   	pop    %esi
  800310:	5f                   	pop    %edi
  800311:	5d                   	pop    %ebp
  800312:	c3                   	ret    

00800313 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800313:	55                   	push   %ebp
  800314:	89 e5                	mov    %esp,%ebp
  800316:	57                   	push   %edi
  800317:	56                   	push   %esi
  800318:	53                   	push   %ebx
  800319:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80031c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800321:	8b 55 08             	mov    0x8(%ebp),%edx
  800324:	b8 0d 00 00 00       	mov    $0xd,%eax
  800329:	89 cb                	mov    %ecx,%ebx
  80032b:	89 cf                	mov    %ecx,%edi
  80032d:	89 ce                	mov    %ecx,%esi
  80032f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800331:	85 c0                	test   %eax,%eax
  800333:	7f 08                	jg     80033d <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800335:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800338:	5b                   	pop    %ebx
  800339:	5e                   	pop    %esi
  80033a:	5f                   	pop    %edi
  80033b:	5d                   	pop    %ebp
  80033c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80033d:	83 ec 0c             	sub    $0xc,%esp
  800340:	50                   	push   %eax
  800341:	6a 0d                	push   $0xd
  800343:	68 0a 23 80 00       	push   $0x80230a
  800348:	6a 23                	push   $0x23
  80034a:	68 27 23 80 00       	push   $0x802327
  80034f:	e8 7e 11 00 00       	call   8014d2 <_panic>

00800354 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800354:	55                   	push   %ebp
  800355:	89 e5                	mov    %esp,%ebp
  800357:	57                   	push   %edi
  800358:	56                   	push   %esi
  800359:	53                   	push   %ebx
	asm volatile("int %1\n"
  80035a:	ba 00 00 00 00       	mov    $0x0,%edx
  80035f:	b8 0e 00 00 00       	mov    $0xe,%eax
  800364:	89 d1                	mov    %edx,%ecx
  800366:	89 d3                	mov    %edx,%ebx
  800368:	89 d7                	mov    %edx,%edi
  80036a:	89 d6                	mov    %edx,%esi
  80036c:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  80036e:	5b                   	pop    %ebx
  80036f:	5e                   	pop    %esi
  800370:	5f                   	pop    %edi
  800371:	5d                   	pop    %ebp
  800372:	c3                   	ret    

00800373 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800373:	55                   	push   %ebp
  800374:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800376:	8b 45 08             	mov    0x8(%ebp),%eax
  800379:	05 00 00 00 30       	add    $0x30000000,%eax
  80037e:	c1 e8 0c             	shr    $0xc,%eax
}
  800381:	5d                   	pop    %ebp
  800382:	c3                   	ret    

00800383 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800383:	55                   	push   %ebp
  800384:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800386:	8b 45 08             	mov    0x8(%ebp),%eax
  800389:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80038e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800393:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800398:	5d                   	pop    %ebp
  800399:	c3                   	ret    

0080039a <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80039a:	55                   	push   %ebp
  80039b:	89 e5                	mov    %esp,%ebp
  80039d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003a0:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8003a5:	89 c2                	mov    %eax,%edx
  8003a7:	c1 ea 16             	shr    $0x16,%edx
  8003aa:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8003b1:	f6 c2 01             	test   $0x1,%dl
  8003b4:	74 2a                	je     8003e0 <fd_alloc+0x46>
  8003b6:	89 c2                	mov    %eax,%edx
  8003b8:	c1 ea 0c             	shr    $0xc,%edx
  8003bb:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8003c2:	f6 c2 01             	test   $0x1,%dl
  8003c5:	74 19                	je     8003e0 <fd_alloc+0x46>
  8003c7:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8003cc:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8003d1:	75 d2                	jne    8003a5 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8003d3:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8003d9:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8003de:	eb 07                	jmp    8003e7 <fd_alloc+0x4d>
			*fd_store = fd;
  8003e0:	89 01                	mov    %eax,(%ecx)
			return 0;
  8003e2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8003e7:	5d                   	pop    %ebp
  8003e8:	c3                   	ret    

008003e9 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8003e9:	55                   	push   %ebp
  8003ea:	89 e5                	mov    %esp,%ebp
  8003ec:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8003ef:	83 f8 1f             	cmp    $0x1f,%eax
  8003f2:	77 36                	ja     80042a <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8003f4:	c1 e0 0c             	shl    $0xc,%eax
  8003f7:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8003fc:	89 c2                	mov    %eax,%edx
  8003fe:	c1 ea 16             	shr    $0x16,%edx
  800401:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800408:	f6 c2 01             	test   $0x1,%dl
  80040b:	74 24                	je     800431 <fd_lookup+0x48>
  80040d:	89 c2                	mov    %eax,%edx
  80040f:	c1 ea 0c             	shr    $0xc,%edx
  800412:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800419:	f6 c2 01             	test   $0x1,%dl
  80041c:	74 1a                	je     800438 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80041e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800421:	89 02                	mov    %eax,(%edx)
	return 0;
  800423:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800428:	5d                   	pop    %ebp
  800429:	c3                   	ret    
		return -E_INVAL;
  80042a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80042f:	eb f7                	jmp    800428 <fd_lookup+0x3f>
		return -E_INVAL;
  800431:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800436:	eb f0                	jmp    800428 <fd_lookup+0x3f>
  800438:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80043d:	eb e9                	jmp    800428 <fd_lookup+0x3f>

0080043f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80043f:	55                   	push   %ebp
  800440:	89 e5                	mov    %esp,%ebp
  800442:	83 ec 08             	sub    $0x8,%esp
  800445:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800448:	ba b4 23 80 00       	mov    $0x8023b4,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  80044d:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800452:	39 08                	cmp    %ecx,(%eax)
  800454:	74 33                	je     800489 <dev_lookup+0x4a>
  800456:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800459:	8b 02                	mov    (%edx),%eax
  80045b:	85 c0                	test   %eax,%eax
  80045d:	75 f3                	jne    800452 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80045f:	a1 08 40 80 00       	mov    0x804008,%eax
  800464:	8b 40 48             	mov    0x48(%eax),%eax
  800467:	83 ec 04             	sub    $0x4,%esp
  80046a:	51                   	push   %ecx
  80046b:	50                   	push   %eax
  80046c:	68 38 23 80 00       	push   $0x802338
  800471:	e8 37 11 00 00       	call   8015ad <cprintf>
	*dev = 0;
  800476:	8b 45 0c             	mov    0xc(%ebp),%eax
  800479:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80047f:	83 c4 10             	add    $0x10,%esp
  800482:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800487:	c9                   	leave  
  800488:	c3                   	ret    
			*dev = devtab[i];
  800489:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80048c:	89 01                	mov    %eax,(%ecx)
			return 0;
  80048e:	b8 00 00 00 00       	mov    $0x0,%eax
  800493:	eb f2                	jmp    800487 <dev_lookup+0x48>

00800495 <fd_close>:
{
  800495:	55                   	push   %ebp
  800496:	89 e5                	mov    %esp,%ebp
  800498:	57                   	push   %edi
  800499:	56                   	push   %esi
  80049a:	53                   	push   %ebx
  80049b:	83 ec 1c             	sub    $0x1c,%esp
  80049e:	8b 75 08             	mov    0x8(%ebp),%esi
  8004a1:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8004a4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8004a7:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8004a8:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8004ae:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8004b1:	50                   	push   %eax
  8004b2:	e8 32 ff ff ff       	call   8003e9 <fd_lookup>
  8004b7:	89 c3                	mov    %eax,%ebx
  8004b9:	83 c4 08             	add    $0x8,%esp
  8004bc:	85 c0                	test   %eax,%eax
  8004be:	78 05                	js     8004c5 <fd_close+0x30>
	    || fd != fd2)
  8004c0:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8004c3:	74 16                	je     8004db <fd_close+0x46>
		return (must_exist ? r : 0);
  8004c5:	89 f8                	mov    %edi,%eax
  8004c7:	84 c0                	test   %al,%al
  8004c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8004ce:	0f 44 d8             	cmove  %eax,%ebx
}
  8004d1:	89 d8                	mov    %ebx,%eax
  8004d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004d6:	5b                   	pop    %ebx
  8004d7:	5e                   	pop    %esi
  8004d8:	5f                   	pop    %edi
  8004d9:	5d                   	pop    %ebp
  8004da:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8004db:	83 ec 08             	sub    $0x8,%esp
  8004de:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8004e1:	50                   	push   %eax
  8004e2:	ff 36                	pushl  (%esi)
  8004e4:	e8 56 ff ff ff       	call   80043f <dev_lookup>
  8004e9:	89 c3                	mov    %eax,%ebx
  8004eb:	83 c4 10             	add    $0x10,%esp
  8004ee:	85 c0                	test   %eax,%eax
  8004f0:	78 15                	js     800507 <fd_close+0x72>
		if (dev->dev_close)
  8004f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004f5:	8b 40 10             	mov    0x10(%eax),%eax
  8004f8:	85 c0                	test   %eax,%eax
  8004fa:	74 1b                	je     800517 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  8004fc:	83 ec 0c             	sub    $0xc,%esp
  8004ff:	56                   	push   %esi
  800500:	ff d0                	call   *%eax
  800502:	89 c3                	mov    %eax,%ebx
  800504:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800507:	83 ec 08             	sub    $0x8,%esp
  80050a:	56                   	push   %esi
  80050b:	6a 00                	push   $0x0
  80050d:	e8 d6 fc ff ff       	call   8001e8 <sys_page_unmap>
	return r;
  800512:	83 c4 10             	add    $0x10,%esp
  800515:	eb ba                	jmp    8004d1 <fd_close+0x3c>
			r = 0;
  800517:	bb 00 00 00 00       	mov    $0x0,%ebx
  80051c:	eb e9                	jmp    800507 <fd_close+0x72>

0080051e <close>:

int
close(int fdnum)
{
  80051e:	55                   	push   %ebp
  80051f:	89 e5                	mov    %esp,%ebp
  800521:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800524:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800527:	50                   	push   %eax
  800528:	ff 75 08             	pushl  0x8(%ebp)
  80052b:	e8 b9 fe ff ff       	call   8003e9 <fd_lookup>
  800530:	83 c4 08             	add    $0x8,%esp
  800533:	85 c0                	test   %eax,%eax
  800535:	78 10                	js     800547 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  800537:	83 ec 08             	sub    $0x8,%esp
  80053a:	6a 01                	push   $0x1
  80053c:	ff 75 f4             	pushl  -0xc(%ebp)
  80053f:	e8 51 ff ff ff       	call   800495 <fd_close>
  800544:	83 c4 10             	add    $0x10,%esp
}
  800547:	c9                   	leave  
  800548:	c3                   	ret    

00800549 <close_all>:

void
close_all(void)
{
  800549:	55                   	push   %ebp
  80054a:	89 e5                	mov    %esp,%ebp
  80054c:	53                   	push   %ebx
  80054d:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800550:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800555:	83 ec 0c             	sub    $0xc,%esp
  800558:	53                   	push   %ebx
  800559:	e8 c0 ff ff ff       	call   80051e <close>
	for (i = 0; i < MAXFD; i++)
  80055e:	83 c3 01             	add    $0x1,%ebx
  800561:	83 c4 10             	add    $0x10,%esp
  800564:	83 fb 20             	cmp    $0x20,%ebx
  800567:	75 ec                	jne    800555 <close_all+0xc>
}
  800569:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80056c:	c9                   	leave  
  80056d:	c3                   	ret    

0080056e <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80056e:	55                   	push   %ebp
  80056f:	89 e5                	mov    %esp,%ebp
  800571:	57                   	push   %edi
  800572:	56                   	push   %esi
  800573:	53                   	push   %ebx
  800574:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800577:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80057a:	50                   	push   %eax
  80057b:	ff 75 08             	pushl  0x8(%ebp)
  80057e:	e8 66 fe ff ff       	call   8003e9 <fd_lookup>
  800583:	89 c3                	mov    %eax,%ebx
  800585:	83 c4 08             	add    $0x8,%esp
  800588:	85 c0                	test   %eax,%eax
  80058a:	0f 88 81 00 00 00    	js     800611 <dup+0xa3>
		return r;
	close(newfdnum);
  800590:	83 ec 0c             	sub    $0xc,%esp
  800593:	ff 75 0c             	pushl  0xc(%ebp)
  800596:	e8 83 ff ff ff       	call   80051e <close>

	newfd = INDEX2FD(newfdnum);
  80059b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80059e:	c1 e6 0c             	shl    $0xc,%esi
  8005a1:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8005a7:	83 c4 04             	add    $0x4,%esp
  8005aa:	ff 75 e4             	pushl  -0x1c(%ebp)
  8005ad:	e8 d1 fd ff ff       	call   800383 <fd2data>
  8005b2:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8005b4:	89 34 24             	mov    %esi,(%esp)
  8005b7:	e8 c7 fd ff ff       	call   800383 <fd2data>
  8005bc:	83 c4 10             	add    $0x10,%esp
  8005bf:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8005c1:	89 d8                	mov    %ebx,%eax
  8005c3:	c1 e8 16             	shr    $0x16,%eax
  8005c6:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8005cd:	a8 01                	test   $0x1,%al
  8005cf:	74 11                	je     8005e2 <dup+0x74>
  8005d1:	89 d8                	mov    %ebx,%eax
  8005d3:	c1 e8 0c             	shr    $0xc,%eax
  8005d6:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8005dd:	f6 c2 01             	test   $0x1,%dl
  8005e0:	75 39                	jne    80061b <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8005e2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8005e5:	89 d0                	mov    %edx,%eax
  8005e7:	c1 e8 0c             	shr    $0xc,%eax
  8005ea:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8005f1:	83 ec 0c             	sub    $0xc,%esp
  8005f4:	25 07 0e 00 00       	and    $0xe07,%eax
  8005f9:	50                   	push   %eax
  8005fa:	56                   	push   %esi
  8005fb:	6a 00                	push   $0x0
  8005fd:	52                   	push   %edx
  8005fe:	6a 00                	push   $0x0
  800600:	e8 a1 fb ff ff       	call   8001a6 <sys_page_map>
  800605:	89 c3                	mov    %eax,%ebx
  800607:	83 c4 20             	add    $0x20,%esp
  80060a:	85 c0                	test   %eax,%eax
  80060c:	78 31                	js     80063f <dup+0xd1>
		goto err;

	return newfdnum;
  80060e:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  800611:	89 d8                	mov    %ebx,%eax
  800613:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800616:	5b                   	pop    %ebx
  800617:	5e                   	pop    %esi
  800618:	5f                   	pop    %edi
  800619:	5d                   	pop    %ebp
  80061a:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80061b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800622:	83 ec 0c             	sub    $0xc,%esp
  800625:	25 07 0e 00 00       	and    $0xe07,%eax
  80062a:	50                   	push   %eax
  80062b:	57                   	push   %edi
  80062c:	6a 00                	push   $0x0
  80062e:	53                   	push   %ebx
  80062f:	6a 00                	push   $0x0
  800631:	e8 70 fb ff ff       	call   8001a6 <sys_page_map>
  800636:	89 c3                	mov    %eax,%ebx
  800638:	83 c4 20             	add    $0x20,%esp
  80063b:	85 c0                	test   %eax,%eax
  80063d:	79 a3                	jns    8005e2 <dup+0x74>
	sys_page_unmap(0, newfd);
  80063f:	83 ec 08             	sub    $0x8,%esp
  800642:	56                   	push   %esi
  800643:	6a 00                	push   $0x0
  800645:	e8 9e fb ff ff       	call   8001e8 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80064a:	83 c4 08             	add    $0x8,%esp
  80064d:	57                   	push   %edi
  80064e:	6a 00                	push   $0x0
  800650:	e8 93 fb ff ff       	call   8001e8 <sys_page_unmap>
	return r;
  800655:	83 c4 10             	add    $0x10,%esp
  800658:	eb b7                	jmp    800611 <dup+0xa3>

0080065a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80065a:	55                   	push   %ebp
  80065b:	89 e5                	mov    %esp,%ebp
  80065d:	53                   	push   %ebx
  80065e:	83 ec 14             	sub    $0x14,%esp
  800661:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800664:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800667:	50                   	push   %eax
  800668:	53                   	push   %ebx
  800669:	e8 7b fd ff ff       	call   8003e9 <fd_lookup>
  80066e:	83 c4 08             	add    $0x8,%esp
  800671:	85 c0                	test   %eax,%eax
  800673:	78 3f                	js     8006b4 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800675:	83 ec 08             	sub    $0x8,%esp
  800678:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80067b:	50                   	push   %eax
  80067c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80067f:	ff 30                	pushl  (%eax)
  800681:	e8 b9 fd ff ff       	call   80043f <dev_lookup>
  800686:	83 c4 10             	add    $0x10,%esp
  800689:	85 c0                	test   %eax,%eax
  80068b:	78 27                	js     8006b4 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80068d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800690:	8b 42 08             	mov    0x8(%edx),%eax
  800693:	83 e0 03             	and    $0x3,%eax
  800696:	83 f8 01             	cmp    $0x1,%eax
  800699:	74 1e                	je     8006b9 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80069b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80069e:	8b 40 08             	mov    0x8(%eax),%eax
  8006a1:	85 c0                	test   %eax,%eax
  8006a3:	74 35                	je     8006da <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8006a5:	83 ec 04             	sub    $0x4,%esp
  8006a8:	ff 75 10             	pushl  0x10(%ebp)
  8006ab:	ff 75 0c             	pushl  0xc(%ebp)
  8006ae:	52                   	push   %edx
  8006af:	ff d0                	call   *%eax
  8006b1:	83 c4 10             	add    $0x10,%esp
}
  8006b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006b7:	c9                   	leave  
  8006b8:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8006b9:	a1 08 40 80 00       	mov    0x804008,%eax
  8006be:	8b 40 48             	mov    0x48(%eax),%eax
  8006c1:	83 ec 04             	sub    $0x4,%esp
  8006c4:	53                   	push   %ebx
  8006c5:	50                   	push   %eax
  8006c6:	68 79 23 80 00       	push   $0x802379
  8006cb:	e8 dd 0e 00 00       	call   8015ad <cprintf>
		return -E_INVAL;
  8006d0:	83 c4 10             	add    $0x10,%esp
  8006d3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8006d8:	eb da                	jmp    8006b4 <read+0x5a>
		return -E_NOT_SUPP;
  8006da:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8006df:	eb d3                	jmp    8006b4 <read+0x5a>

008006e1 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8006e1:	55                   	push   %ebp
  8006e2:	89 e5                	mov    %esp,%ebp
  8006e4:	57                   	push   %edi
  8006e5:	56                   	push   %esi
  8006e6:	53                   	push   %ebx
  8006e7:	83 ec 0c             	sub    $0xc,%esp
  8006ea:	8b 7d 08             	mov    0x8(%ebp),%edi
  8006ed:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8006f0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006f5:	39 f3                	cmp    %esi,%ebx
  8006f7:	73 25                	jae    80071e <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8006f9:	83 ec 04             	sub    $0x4,%esp
  8006fc:	89 f0                	mov    %esi,%eax
  8006fe:	29 d8                	sub    %ebx,%eax
  800700:	50                   	push   %eax
  800701:	89 d8                	mov    %ebx,%eax
  800703:	03 45 0c             	add    0xc(%ebp),%eax
  800706:	50                   	push   %eax
  800707:	57                   	push   %edi
  800708:	e8 4d ff ff ff       	call   80065a <read>
		if (m < 0)
  80070d:	83 c4 10             	add    $0x10,%esp
  800710:	85 c0                	test   %eax,%eax
  800712:	78 08                	js     80071c <readn+0x3b>
			return m;
		if (m == 0)
  800714:	85 c0                	test   %eax,%eax
  800716:	74 06                	je     80071e <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  800718:	01 c3                	add    %eax,%ebx
  80071a:	eb d9                	jmp    8006f5 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80071c:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80071e:	89 d8                	mov    %ebx,%eax
  800720:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800723:	5b                   	pop    %ebx
  800724:	5e                   	pop    %esi
  800725:	5f                   	pop    %edi
  800726:	5d                   	pop    %ebp
  800727:	c3                   	ret    

00800728 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800728:	55                   	push   %ebp
  800729:	89 e5                	mov    %esp,%ebp
  80072b:	53                   	push   %ebx
  80072c:	83 ec 14             	sub    $0x14,%esp
  80072f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800732:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800735:	50                   	push   %eax
  800736:	53                   	push   %ebx
  800737:	e8 ad fc ff ff       	call   8003e9 <fd_lookup>
  80073c:	83 c4 08             	add    $0x8,%esp
  80073f:	85 c0                	test   %eax,%eax
  800741:	78 3a                	js     80077d <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800743:	83 ec 08             	sub    $0x8,%esp
  800746:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800749:	50                   	push   %eax
  80074a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80074d:	ff 30                	pushl  (%eax)
  80074f:	e8 eb fc ff ff       	call   80043f <dev_lookup>
  800754:	83 c4 10             	add    $0x10,%esp
  800757:	85 c0                	test   %eax,%eax
  800759:	78 22                	js     80077d <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80075b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80075e:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800762:	74 1e                	je     800782 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800764:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800767:	8b 52 0c             	mov    0xc(%edx),%edx
  80076a:	85 d2                	test   %edx,%edx
  80076c:	74 35                	je     8007a3 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80076e:	83 ec 04             	sub    $0x4,%esp
  800771:	ff 75 10             	pushl  0x10(%ebp)
  800774:	ff 75 0c             	pushl  0xc(%ebp)
  800777:	50                   	push   %eax
  800778:	ff d2                	call   *%edx
  80077a:	83 c4 10             	add    $0x10,%esp
}
  80077d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800780:	c9                   	leave  
  800781:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800782:	a1 08 40 80 00       	mov    0x804008,%eax
  800787:	8b 40 48             	mov    0x48(%eax),%eax
  80078a:	83 ec 04             	sub    $0x4,%esp
  80078d:	53                   	push   %ebx
  80078e:	50                   	push   %eax
  80078f:	68 95 23 80 00       	push   $0x802395
  800794:	e8 14 0e 00 00       	call   8015ad <cprintf>
		return -E_INVAL;
  800799:	83 c4 10             	add    $0x10,%esp
  80079c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007a1:	eb da                	jmp    80077d <write+0x55>
		return -E_NOT_SUPP;
  8007a3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8007a8:	eb d3                	jmp    80077d <write+0x55>

008007aa <seek>:

int
seek(int fdnum, off_t offset)
{
  8007aa:	55                   	push   %ebp
  8007ab:	89 e5                	mov    %esp,%ebp
  8007ad:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8007b0:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8007b3:	50                   	push   %eax
  8007b4:	ff 75 08             	pushl  0x8(%ebp)
  8007b7:	e8 2d fc ff ff       	call   8003e9 <fd_lookup>
  8007bc:	83 c4 08             	add    $0x8,%esp
  8007bf:	85 c0                	test   %eax,%eax
  8007c1:	78 0e                	js     8007d1 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8007c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8007c9:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8007cc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8007d1:	c9                   	leave  
  8007d2:	c3                   	ret    

008007d3 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8007d3:	55                   	push   %ebp
  8007d4:	89 e5                	mov    %esp,%ebp
  8007d6:	53                   	push   %ebx
  8007d7:	83 ec 14             	sub    $0x14,%esp
  8007da:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8007dd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8007e0:	50                   	push   %eax
  8007e1:	53                   	push   %ebx
  8007e2:	e8 02 fc ff ff       	call   8003e9 <fd_lookup>
  8007e7:	83 c4 08             	add    $0x8,%esp
  8007ea:	85 c0                	test   %eax,%eax
  8007ec:	78 37                	js     800825 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8007ee:	83 ec 08             	sub    $0x8,%esp
  8007f1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8007f4:	50                   	push   %eax
  8007f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007f8:	ff 30                	pushl  (%eax)
  8007fa:	e8 40 fc ff ff       	call   80043f <dev_lookup>
  8007ff:	83 c4 10             	add    $0x10,%esp
  800802:	85 c0                	test   %eax,%eax
  800804:	78 1f                	js     800825 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800806:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800809:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80080d:	74 1b                	je     80082a <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80080f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800812:	8b 52 18             	mov    0x18(%edx),%edx
  800815:	85 d2                	test   %edx,%edx
  800817:	74 32                	je     80084b <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  800819:	83 ec 08             	sub    $0x8,%esp
  80081c:	ff 75 0c             	pushl  0xc(%ebp)
  80081f:	50                   	push   %eax
  800820:	ff d2                	call   *%edx
  800822:	83 c4 10             	add    $0x10,%esp
}
  800825:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800828:	c9                   	leave  
  800829:	c3                   	ret    
			thisenv->env_id, fdnum);
  80082a:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80082f:	8b 40 48             	mov    0x48(%eax),%eax
  800832:	83 ec 04             	sub    $0x4,%esp
  800835:	53                   	push   %ebx
  800836:	50                   	push   %eax
  800837:	68 58 23 80 00       	push   $0x802358
  80083c:	e8 6c 0d 00 00       	call   8015ad <cprintf>
		return -E_INVAL;
  800841:	83 c4 10             	add    $0x10,%esp
  800844:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800849:	eb da                	jmp    800825 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80084b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800850:	eb d3                	jmp    800825 <ftruncate+0x52>

00800852 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800852:	55                   	push   %ebp
  800853:	89 e5                	mov    %esp,%ebp
  800855:	53                   	push   %ebx
  800856:	83 ec 14             	sub    $0x14,%esp
  800859:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80085c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80085f:	50                   	push   %eax
  800860:	ff 75 08             	pushl  0x8(%ebp)
  800863:	e8 81 fb ff ff       	call   8003e9 <fd_lookup>
  800868:	83 c4 08             	add    $0x8,%esp
  80086b:	85 c0                	test   %eax,%eax
  80086d:	78 4b                	js     8008ba <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80086f:	83 ec 08             	sub    $0x8,%esp
  800872:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800875:	50                   	push   %eax
  800876:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800879:	ff 30                	pushl  (%eax)
  80087b:	e8 bf fb ff ff       	call   80043f <dev_lookup>
  800880:	83 c4 10             	add    $0x10,%esp
  800883:	85 c0                	test   %eax,%eax
  800885:	78 33                	js     8008ba <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  800887:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80088a:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80088e:	74 2f                	je     8008bf <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800890:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  800893:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80089a:	00 00 00 
	stat->st_isdir = 0;
  80089d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8008a4:	00 00 00 
	stat->st_dev = dev;
  8008a7:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8008ad:	83 ec 08             	sub    $0x8,%esp
  8008b0:	53                   	push   %ebx
  8008b1:	ff 75 f0             	pushl  -0x10(%ebp)
  8008b4:	ff 50 14             	call   *0x14(%eax)
  8008b7:	83 c4 10             	add    $0x10,%esp
}
  8008ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008bd:	c9                   	leave  
  8008be:	c3                   	ret    
		return -E_NOT_SUPP;
  8008bf:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8008c4:	eb f4                	jmp    8008ba <fstat+0x68>

008008c6 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8008c6:	55                   	push   %ebp
  8008c7:	89 e5                	mov    %esp,%ebp
  8008c9:	56                   	push   %esi
  8008ca:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8008cb:	83 ec 08             	sub    $0x8,%esp
  8008ce:	6a 00                	push   $0x0
  8008d0:	ff 75 08             	pushl  0x8(%ebp)
  8008d3:	e8 26 02 00 00       	call   800afe <open>
  8008d8:	89 c3                	mov    %eax,%ebx
  8008da:	83 c4 10             	add    $0x10,%esp
  8008dd:	85 c0                	test   %eax,%eax
  8008df:	78 1b                	js     8008fc <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8008e1:	83 ec 08             	sub    $0x8,%esp
  8008e4:	ff 75 0c             	pushl  0xc(%ebp)
  8008e7:	50                   	push   %eax
  8008e8:	e8 65 ff ff ff       	call   800852 <fstat>
  8008ed:	89 c6                	mov    %eax,%esi
	close(fd);
  8008ef:	89 1c 24             	mov    %ebx,(%esp)
  8008f2:	e8 27 fc ff ff       	call   80051e <close>
	return r;
  8008f7:	83 c4 10             	add    $0x10,%esp
  8008fa:	89 f3                	mov    %esi,%ebx
}
  8008fc:	89 d8                	mov    %ebx,%eax
  8008fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800901:	5b                   	pop    %ebx
  800902:	5e                   	pop    %esi
  800903:	5d                   	pop    %ebp
  800904:	c3                   	ret    

00800905 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800905:	55                   	push   %ebp
  800906:	89 e5                	mov    %esp,%ebp
  800908:	56                   	push   %esi
  800909:	53                   	push   %ebx
  80090a:	89 c6                	mov    %eax,%esi
  80090c:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80090e:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  800915:	74 27                	je     80093e <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800917:	6a 07                	push   $0x7
  800919:	68 00 50 80 00       	push   $0x805000
  80091e:	56                   	push   %esi
  80091f:	ff 35 00 40 80 00    	pushl  0x804000
  800925:	e8 c6 16 00 00       	call   801ff0 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80092a:	83 c4 0c             	add    $0xc,%esp
  80092d:	6a 00                	push   $0x0
  80092f:	53                   	push   %ebx
  800930:	6a 00                	push   $0x0
  800932:	e8 50 16 00 00       	call   801f87 <ipc_recv>
}
  800937:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80093a:	5b                   	pop    %ebx
  80093b:	5e                   	pop    %esi
  80093c:	5d                   	pop    %ebp
  80093d:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80093e:	83 ec 0c             	sub    $0xc,%esp
  800941:	6a 01                	push   $0x1
  800943:	e8 01 17 00 00       	call   802049 <ipc_find_env>
  800948:	a3 00 40 80 00       	mov    %eax,0x804000
  80094d:	83 c4 10             	add    $0x10,%esp
  800950:	eb c5                	jmp    800917 <fsipc+0x12>

00800952 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  800952:	55                   	push   %ebp
  800953:	89 e5                	mov    %esp,%ebp
  800955:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800958:	8b 45 08             	mov    0x8(%ebp),%eax
  80095b:	8b 40 0c             	mov    0xc(%eax),%eax
  80095e:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  800963:	8b 45 0c             	mov    0xc(%ebp),%eax
  800966:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80096b:	ba 00 00 00 00       	mov    $0x0,%edx
  800970:	b8 02 00 00 00       	mov    $0x2,%eax
  800975:	e8 8b ff ff ff       	call   800905 <fsipc>
}
  80097a:	c9                   	leave  
  80097b:	c3                   	ret    

0080097c <devfile_flush>:
{
  80097c:	55                   	push   %ebp
  80097d:	89 e5                	mov    %esp,%ebp
  80097f:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800982:	8b 45 08             	mov    0x8(%ebp),%eax
  800985:	8b 40 0c             	mov    0xc(%eax),%eax
  800988:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80098d:	ba 00 00 00 00       	mov    $0x0,%edx
  800992:	b8 06 00 00 00       	mov    $0x6,%eax
  800997:	e8 69 ff ff ff       	call   800905 <fsipc>
}
  80099c:	c9                   	leave  
  80099d:	c3                   	ret    

0080099e <devfile_stat>:
{
  80099e:	55                   	push   %ebp
  80099f:	89 e5                	mov    %esp,%ebp
  8009a1:	53                   	push   %ebx
  8009a2:	83 ec 04             	sub    $0x4,%esp
  8009a5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8009a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ab:	8b 40 0c             	mov    0xc(%eax),%eax
  8009ae:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8009b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8009b8:	b8 05 00 00 00       	mov    $0x5,%eax
  8009bd:	e8 43 ff ff ff       	call   800905 <fsipc>
  8009c2:	85 c0                	test   %eax,%eax
  8009c4:	78 2c                	js     8009f2 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8009c6:	83 ec 08             	sub    $0x8,%esp
  8009c9:	68 00 50 80 00       	push   $0x805000
  8009ce:	53                   	push   %ebx
  8009cf:	e8 76 12 00 00       	call   801c4a <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8009d4:	a1 80 50 80 00       	mov    0x805080,%eax
  8009d9:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8009df:	a1 84 50 80 00       	mov    0x805084,%eax
  8009e4:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8009ea:	83 c4 10             	add    $0x10,%esp
  8009ed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009f5:	c9                   	leave  
  8009f6:	c3                   	ret    

008009f7 <devfile_write>:
{
  8009f7:	55                   	push   %ebp
  8009f8:	89 e5                	mov    %esp,%ebp
  8009fa:	53                   	push   %ebx
  8009fb:	83 ec 04             	sub    $0x4,%esp
  8009fe:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  800a01:	8b 45 08             	mov    0x8(%ebp),%eax
  800a04:	8b 40 0c             	mov    0xc(%eax),%eax
  800a07:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  800a0c:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  800a12:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  800a18:	77 30                	ja     800a4a <devfile_write+0x53>
	memmove(fsipcbuf.write.req_buf, buf, n);
  800a1a:	83 ec 04             	sub    $0x4,%esp
  800a1d:	53                   	push   %ebx
  800a1e:	ff 75 0c             	pushl  0xc(%ebp)
  800a21:	68 08 50 80 00       	push   $0x805008
  800a26:	e8 ad 13 00 00       	call   801dd8 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  800a2b:	ba 00 00 00 00       	mov    $0x0,%edx
  800a30:	b8 04 00 00 00       	mov    $0x4,%eax
  800a35:	e8 cb fe ff ff       	call   800905 <fsipc>
  800a3a:	83 c4 10             	add    $0x10,%esp
  800a3d:	85 c0                	test   %eax,%eax
  800a3f:	78 04                	js     800a45 <devfile_write+0x4e>
	assert(r <= n);
  800a41:	39 d8                	cmp    %ebx,%eax
  800a43:	77 1e                	ja     800a63 <devfile_write+0x6c>
}
  800a45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a48:	c9                   	leave  
  800a49:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  800a4a:	68 c8 23 80 00       	push   $0x8023c8
  800a4f:	68 f5 23 80 00       	push   $0x8023f5
  800a54:	68 94 00 00 00       	push   $0x94
  800a59:	68 0a 24 80 00       	push   $0x80240a
  800a5e:	e8 6f 0a 00 00       	call   8014d2 <_panic>
	assert(r <= n);
  800a63:	68 15 24 80 00       	push   $0x802415
  800a68:	68 f5 23 80 00       	push   $0x8023f5
  800a6d:	68 98 00 00 00       	push   $0x98
  800a72:	68 0a 24 80 00       	push   $0x80240a
  800a77:	e8 56 0a 00 00       	call   8014d2 <_panic>

00800a7c <devfile_read>:
{
  800a7c:	55                   	push   %ebp
  800a7d:	89 e5                	mov    %esp,%ebp
  800a7f:	56                   	push   %esi
  800a80:	53                   	push   %ebx
  800a81:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800a84:	8b 45 08             	mov    0x8(%ebp),%eax
  800a87:	8b 40 0c             	mov    0xc(%eax),%eax
  800a8a:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800a8f:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800a95:	ba 00 00 00 00       	mov    $0x0,%edx
  800a9a:	b8 03 00 00 00       	mov    $0x3,%eax
  800a9f:	e8 61 fe ff ff       	call   800905 <fsipc>
  800aa4:	89 c3                	mov    %eax,%ebx
  800aa6:	85 c0                	test   %eax,%eax
  800aa8:	78 1f                	js     800ac9 <devfile_read+0x4d>
	assert(r <= n);
  800aaa:	39 f0                	cmp    %esi,%eax
  800aac:	77 24                	ja     800ad2 <devfile_read+0x56>
	assert(r <= PGSIZE);
  800aae:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800ab3:	7f 33                	jg     800ae8 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800ab5:	83 ec 04             	sub    $0x4,%esp
  800ab8:	50                   	push   %eax
  800ab9:	68 00 50 80 00       	push   $0x805000
  800abe:	ff 75 0c             	pushl  0xc(%ebp)
  800ac1:	e8 12 13 00 00       	call   801dd8 <memmove>
	return r;
  800ac6:	83 c4 10             	add    $0x10,%esp
}
  800ac9:	89 d8                	mov    %ebx,%eax
  800acb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ace:	5b                   	pop    %ebx
  800acf:	5e                   	pop    %esi
  800ad0:	5d                   	pop    %ebp
  800ad1:	c3                   	ret    
	assert(r <= n);
  800ad2:	68 15 24 80 00       	push   $0x802415
  800ad7:	68 f5 23 80 00       	push   $0x8023f5
  800adc:	6a 7c                	push   $0x7c
  800ade:	68 0a 24 80 00       	push   $0x80240a
  800ae3:	e8 ea 09 00 00       	call   8014d2 <_panic>
	assert(r <= PGSIZE);
  800ae8:	68 1c 24 80 00       	push   $0x80241c
  800aed:	68 f5 23 80 00       	push   $0x8023f5
  800af2:	6a 7d                	push   $0x7d
  800af4:	68 0a 24 80 00       	push   $0x80240a
  800af9:	e8 d4 09 00 00       	call   8014d2 <_panic>

00800afe <open>:
{
  800afe:	55                   	push   %ebp
  800aff:	89 e5                	mov    %esp,%ebp
  800b01:	56                   	push   %esi
  800b02:	53                   	push   %ebx
  800b03:	83 ec 1c             	sub    $0x1c,%esp
  800b06:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800b09:	56                   	push   %esi
  800b0a:	e8 04 11 00 00       	call   801c13 <strlen>
  800b0f:	83 c4 10             	add    $0x10,%esp
  800b12:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800b17:	7f 6c                	jg     800b85 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  800b19:	83 ec 0c             	sub    $0xc,%esp
  800b1c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800b1f:	50                   	push   %eax
  800b20:	e8 75 f8 ff ff       	call   80039a <fd_alloc>
  800b25:	89 c3                	mov    %eax,%ebx
  800b27:	83 c4 10             	add    $0x10,%esp
  800b2a:	85 c0                	test   %eax,%eax
  800b2c:	78 3c                	js     800b6a <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  800b2e:	83 ec 08             	sub    $0x8,%esp
  800b31:	56                   	push   %esi
  800b32:	68 00 50 80 00       	push   $0x805000
  800b37:	e8 0e 11 00 00       	call   801c4a <strcpy>
	fsipcbuf.open.req_omode = mode;
  800b3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3f:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800b44:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b47:	b8 01 00 00 00       	mov    $0x1,%eax
  800b4c:	e8 b4 fd ff ff       	call   800905 <fsipc>
  800b51:	89 c3                	mov    %eax,%ebx
  800b53:	83 c4 10             	add    $0x10,%esp
  800b56:	85 c0                	test   %eax,%eax
  800b58:	78 19                	js     800b73 <open+0x75>
	return fd2num(fd);
  800b5a:	83 ec 0c             	sub    $0xc,%esp
  800b5d:	ff 75 f4             	pushl  -0xc(%ebp)
  800b60:	e8 0e f8 ff ff       	call   800373 <fd2num>
  800b65:	89 c3                	mov    %eax,%ebx
  800b67:	83 c4 10             	add    $0x10,%esp
}
  800b6a:	89 d8                	mov    %ebx,%eax
  800b6c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b6f:	5b                   	pop    %ebx
  800b70:	5e                   	pop    %esi
  800b71:	5d                   	pop    %ebp
  800b72:	c3                   	ret    
		fd_close(fd, 0);
  800b73:	83 ec 08             	sub    $0x8,%esp
  800b76:	6a 00                	push   $0x0
  800b78:	ff 75 f4             	pushl  -0xc(%ebp)
  800b7b:	e8 15 f9 ff ff       	call   800495 <fd_close>
		return r;
  800b80:	83 c4 10             	add    $0x10,%esp
  800b83:	eb e5                	jmp    800b6a <open+0x6c>
		return -E_BAD_PATH;
  800b85:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800b8a:	eb de                	jmp    800b6a <open+0x6c>

00800b8c <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800b8c:	55                   	push   %ebp
  800b8d:	89 e5                	mov    %esp,%ebp
  800b8f:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800b92:	ba 00 00 00 00       	mov    $0x0,%edx
  800b97:	b8 08 00 00 00       	mov    $0x8,%eax
  800b9c:	e8 64 fd ff ff       	call   800905 <fsipc>
}
  800ba1:	c9                   	leave  
  800ba2:	c3                   	ret    

00800ba3 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800ba3:	55                   	push   %ebp
  800ba4:	89 e5                	mov    %esp,%ebp
  800ba6:	56                   	push   %esi
  800ba7:	53                   	push   %ebx
  800ba8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800bab:	83 ec 0c             	sub    $0xc,%esp
  800bae:	ff 75 08             	pushl  0x8(%ebp)
  800bb1:	e8 cd f7 ff ff       	call   800383 <fd2data>
  800bb6:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  800bb8:	83 c4 08             	add    $0x8,%esp
  800bbb:	68 28 24 80 00       	push   $0x802428
  800bc0:	53                   	push   %ebx
  800bc1:	e8 84 10 00 00       	call   801c4a <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  800bc6:	8b 46 04             	mov    0x4(%esi),%eax
  800bc9:	2b 06                	sub    (%esi),%eax
  800bcb:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  800bd1:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800bd8:	00 00 00 
	stat->st_dev = &devpipe;
  800bdb:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  800be2:	30 80 00 
	return 0;
}
  800be5:	b8 00 00 00 00       	mov    $0x0,%eax
  800bea:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bed:	5b                   	pop    %ebx
  800bee:	5e                   	pop    %esi
  800bef:	5d                   	pop    %ebp
  800bf0:	c3                   	ret    

00800bf1 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  800bf1:	55                   	push   %ebp
  800bf2:	89 e5                	mov    %esp,%ebp
  800bf4:	53                   	push   %ebx
  800bf5:	83 ec 0c             	sub    $0xc,%esp
  800bf8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  800bfb:	53                   	push   %ebx
  800bfc:	6a 00                	push   $0x0
  800bfe:	e8 e5 f5 ff ff       	call   8001e8 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  800c03:	89 1c 24             	mov    %ebx,(%esp)
  800c06:	e8 78 f7 ff ff       	call   800383 <fd2data>
  800c0b:	83 c4 08             	add    $0x8,%esp
  800c0e:	50                   	push   %eax
  800c0f:	6a 00                	push   $0x0
  800c11:	e8 d2 f5 ff ff       	call   8001e8 <sys_page_unmap>
}
  800c16:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c19:	c9                   	leave  
  800c1a:	c3                   	ret    

00800c1b <_pipeisclosed>:
{
  800c1b:	55                   	push   %ebp
  800c1c:	89 e5                	mov    %esp,%ebp
  800c1e:	57                   	push   %edi
  800c1f:	56                   	push   %esi
  800c20:	53                   	push   %ebx
  800c21:	83 ec 1c             	sub    $0x1c,%esp
  800c24:	89 c7                	mov    %eax,%edi
  800c26:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  800c28:	a1 08 40 80 00       	mov    0x804008,%eax
  800c2d:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  800c30:	83 ec 0c             	sub    $0xc,%esp
  800c33:	57                   	push   %edi
  800c34:	e8 49 14 00 00       	call   802082 <pageref>
  800c39:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c3c:	89 34 24             	mov    %esi,(%esp)
  800c3f:	e8 3e 14 00 00       	call   802082 <pageref>
		nn = thisenv->env_runs;
  800c44:	8b 15 08 40 80 00    	mov    0x804008,%edx
  800c4a:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  800c4d:	83 c4 10             	add    $0x10,%esp
  800c50:	39 cb                	cmp    %ecx,%ebx
  800c52:	74 1b                	je     800c6f <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  800c54:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800c57:	75 cf                	jne    800c28 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  800c59:	8b 42 58             	mov    0x58(%edx),%eax
  800c5c:	6a 01                	push   $0x1
  800c5e:	50                   	push   %eax
  800c5f:	53                   	push   %ebx
  800c60:	68 2f 24 80 00       	push   $0x80242f
  800c65:	e8 43 09 00 00       	call   8015ad <cprintf>
  800c6a:	83 c4 10             	add    $0x10,%esp
  800c6d:	eb b9                	jmp    800c28 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  800c6f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800c72:	0f 94 c0             	sete   %al
  800c75:	0f b6 c0             	movzbl %al,%eax
}
  800c78:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c7b:	5b                   	pop    %ebx
  800c7c:	5e                   	pop    %esi
  800c7d:	5f                   	pop    %edi
  800c7e:	5d                   	pop    %ebp
  800c7f:	c3                   	ret    

00800c80 <devpipe_write>:
{
  800c80:	55                   	push   %ebp
  800c81:	89 e5                	mov    %esp,%ebp
  800c83:	57                   	push   %edi
  800c84:	56                   	push   %esi
  800c85:	53                   	push   %ebx
  800c86:	83 ec 28             	sub    $0x28,%esp
  800c89:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  800c8c:	56                   	push   %esi
  800c8d:	e8 f1 f6 ff ff       	call   800383 <fd2data>
  800c92:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800c94:	83 c4 10             	add    $0x10,%esp
  800c97:	bf 00 00 00 00       	mov    $0x0,%edi
  800c9c:	3b 7d 10             	cmp    0x10(%ebp),%edi
  800c9f:	74 4f                	je     800cf0 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  800ca1:	8b 43 04             	mov    0x4(%ebx),%eax
  800ca4:	8b 0b                	mov    (%ebx),%ecx
  800ca6:	8d 51 20             	lea    0x20(%ecx),%edx
  800ca9:	39 d0                	cmp    %edx,%eax
  800cab:	72 14                	jb     800cc1 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  800cad:	89 da                	mov    %ebx,%edx
  800caf:	89 f0                	mov    %esi,%eax
  800cb1:	e8 65 ff ff ff       	call   800c1b <_pipeisclosed>
  800cb6:	85 c0                	test   %eax,%eax
  800cb8:	75 3a                	jne    800cf4 <devpipe_write+0x74>
			sys_yield();
  800cba:	e8 85 f4 ff ff       	call   800144 <sys_yield>
  800cbf:	eb e0                	jmp    800ca1 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  800cc1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cc4:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  800cc8:	88 4d e7             	mov    %cl,-0x19(%ebp)
  800ccb:	89 c2                	mov    %eax,%edx
  800ccd:	c1 fa 1f             	sar    $0x1f,%edx
  800cd0:	89 d1                	mov    %edx,%ecx
  800cd2:	c1 e9 1b             	shr    $0x1b,%ecx
  800cd5:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  800cd8:	83 e2 1f             	and    $0x1f,%edx
  800cdb:	29 ca                	sub    %ecx,%edx
  800cdd:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  800ce1:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  800ce5:	83 c0 01             	add    $0x1,%eax
  800ce8:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  800ceb:	83 c7 01             	add    $0x1,%edi
  800cee:	eb ac                	jmp    800c9c <devpipe_write+0x1c>
	return i;
  800cf0:	89 f8                	mov    %edi,%eax
  800cf2:	eb 05                	jmp    800cf9 <devpipe_write+0x79>
				return 0;
  800cf4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cf9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cfc:	5b                   	pop    %ebx
  800cfd:	5e                   	pop    %esi
  800cfe:	5f                   	pop    %edi
  800cff:	5d                   	pop    %ebp
  800d00:	c3                   	ret    

00800d01 <devpipe_read>:
{
  800d01:	55                   	push   %ebp
  800d02:	89 e5                	mov    %esp,%ebp
  800d04:	57                   	push   %edi
  800d05:	56                   	push   %esi
  800d06:	53                   	push   %ebx
  800d07:	83 ec 18             	sub    $0x18,%esp
  800d0a:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  800d0d:	57                   	push   %edi
  800d0e:	e8 70 f6 ff ff       	call   800383 <fd2data>
  800d13:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800d15:	83 c4 10             	add    $0x10,%esp
  800d18:	be 00 00 00 00       	mov    $0x0,%esi
  800d1d:	3b 75 10             	cmp    0x10(%ebp),%esi
  800d20:	74 47                	je     800d69 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  800d22:	8b 03                	mov    (%ebx),%eax
  800d24:	3b 43 04             	cmp    0x4(%ebx),%eax
  800d27:	75 22                	jne    800d4b <devpipe_read+0x4a>
			if (i > 0)
  800d29:	85 f6                	test   %esi,%esi
  800d2b:	75 14                	jne    800d41 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  800d2d:	89 da                	mov    %ebx,%edx
  800d2f:	89 f8                	mov    %edi,%eax
  800d31:	e8 e5 fe ff ff       	call   800c1b <_pipeisclosed>
  800d36:	85 c0                	test   %eax,%eax
  800d38:	75 33                	jne    800d6d <devpipe_read+0x6c>
			sys_yield();
  800d3a:	e8 05 f4 ff ff       	call   800144 <sys_yield>
  800d3f:	eb e1                	jmp    800d22 <devpipe_read+0x21>
				return i;
  800d41:	89 f0                	mov    %esi,%eax
}
  800d43:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d46:	5b                   	pop    %ebx
  800d47:	5e                   	pop    %esi
  800d48:	5f                   	pop    %edi
  800d49:	5d                   	pop    %ebp
  800d4a:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  800d4b:	99                   	cltd   
  800d4c:	c1 ea 1b             	shr    $0x1b,%edx
  800d4f:	01 d0                	add    %edx,%eax
  800d51:	83 e0 1f             	and    $0x1f,%eax
  800d54:	29 d0                	sub    %edx,%eax
  800d56:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  800d5b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d5e:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  800d61:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  800d64:	83 c6 01             	add    $0x1,%esi
  800d67:	eb b4                	jmp    800d1d <devpipe_read+0x1c>
	return i;
  800d69:	89 f0                	mov    %esi,%eax
  800d6b:	eb d6                	jmp    800d43 <devpipe_read+0x42>
				return 0;
  800d6d:	b8 00 00 00 00       	mov    $0x0,%eax
  800d72:	eb cf                	jmp    800d43 <devpipe_read+0x42>

00800d74 <pipe>:
{
  800d74:	55                   	push   %ebp
  800d75:	89 e5                	mov    %esp,%ebp
  800d77:	56                   	push   %esi
  800d78:	53                   	push   %ebx
  800d79:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  800d7c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800d7f:	50                   	push   %eax
  800d80:	e8 15 f6 ff ff       	call   80039a <fd_alloc>
  800d85:	89 c3                	mov    %eax,%ebx
  800d87:	83 c4 10             	add    $0x10,%esp
  800d8a:	85 c0                	test   %eax,%eax
  800d8c:	78 5b                	js     800de9 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800d8e:	83 ec 04             	sub    $0x4,%esp
  800d91:	68 07 04 00 00       	push   $0x407
  800d96:	ff 75 f4             	pushl  -0xc(%ebp)
  800d99:	6a 00                	push   $0x0
  800d9b:	e8 c3 f3 ff ff       	call   800163 <sys_page_alloc>
  800da0:	89 c3                	mov    %eax,%ebx
  800da2:	83 c4 10             	add    $0x10,%esp
  800da5:	85 c0                	test   %eax,%eax
  800da7:	78 40                	js     800de9 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  800da9:	83 ec 0c             	sub    $0xc,%esp
  800dac:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800daf:	50                   	push   %eax
  800db0:	e8 e5 f5 ff ff       	call   80039a <fd_alloc>
  800db5:	89 c3                	mov    %eax,%ebx
  800db7:	83 c4 10             	add    $0x10,%esp
  800dba:	85 c0                	test   %eax,%eax
  800dbc:	78 1b                	js     800dd9 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800dbe:	83 ec 04             	sub    $0x4,%esp
  800dc1:	68 07 04 00 00       	push   $0x407
  800dc6:	ff 75 f0             	pushl  -0x10(%ebp)
  800dc9:	6a 00                	push   $0x0
  800dcb:	e8 93 f3 ff ff       	call   800163 <sys_page_alloc>
  800dd0:	89 c3                	mov    %eax,%ebx
  800dd2:	83 c4 10             	add    $0x10,%esp
  800dd5:	85 c0                	test   %eax,%eax
  800dd7:	79 19                	jns    800df2 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  800dd9:	83 ec 08             	sub    $0x8,%esp
  800ddc:	ff 75 f4             	pushl  -0xc(%ebp)
  800ddf:	6a 00                	push   $0x0
  800de1:	e8 02 f4 ff ff       	call   8001e8 <sys_page_unmap>
  800de6:	83 c4 10             	add    $0x10,%esp
}
  800de9:	89 d8                	mov    %ebx,%eax
  800deb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800dee:	5b                   	pop    %ebx
  800def:	5e                   	pop    %esi
  800df0:	5d                   	pop    %ebp
  800df1:	c3                   	ret    
	va = fd2data(fd0);
  800df2:	83 ec 0c             	sub    $0xc,%esp
  800df5:	ff 75 f4             	pushl  -0xc(%ebp)
  800df8:	e8 86 f5 ff ff       	call   800383 <fd2data>
  800dfd:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800dff:	83 c4 0c             	add    $0xc,%esp
  800e02:	68 07 04 00 00       	push   $0x407
  800e07:	50                   	push   %eax
  800e08:	6a 00                	push   $0x0
  800e0a:	e8 54 f3 ff ff       	call   800163 <sys_page_alloc>
  800e0f:	89 c3                	mov    %eax,%ebx
  800e11:	83 c4 10             	add    $0x10,%esp
  800e14:	85 c0                	test   %eax,%eax
  800e16:	0f 88 8c 00 00 00    	js     800ea8 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e1c:	83 ec 0c             	sub    $0xc,%esp
  800e1f:	ff 75 f0             	pushl  -0x10(%ebp)
  800e22:	e8 5c f5 ff ff       	call   800383 <fd2data>
  800e27:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  800e2e:	50                   	push   %eax
  800e2f:	6a 00                	push   $0x0
  800e31:	56                   	push   %esi
  800e32:	6a 00                	push   $0x0
  800e34:	e8 6d f3 ff ff       	call   8001a6 <sys_page_map>
  800e39:	89 c3                	mov    %eax,%ebx
  800e3b:	83 c4 20             	add    $0x20,%esp
  800e3e:	85 c0                	test   %eax,%eax
  800e40:	78 58                	js     800e9a <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  800e42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e45:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800e4b:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  800e4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e50:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  800e57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e5a:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800e60:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  800e62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e65:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  800e6c:	83 ec 0c             	sub    $0xc,%esp
  800e6f:	ff 75 f4             	pushl  -0xc(%ebp)
  800e72:	e8 fc f4 ff ff       	call   800373 <fd2num>
  800e77:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e7a:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  800e7c:	83 c4 04             	add    $0x4,%esp
  800e7f:	ff 75 f0             	pushl  -0x10(%ebp)
  800e82:	e8 ec f4 ff ff       	call   800373 <fd2num>
  800e87:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e8a:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  800e8d:	83 c4 10             	add    $0x10,%esp
  800e90:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e95:	e9 4f ff ff ff       	jmp    800de9 <pipe+0x75>
	sys_page_unmap(0, va);
  800e9a:	83 ec 08             	sub    $0x8,%esp
  800e9d:	56                   	push   %esi
  800e9e:	6a 00                	push   $0x0
  800ea0:	e8 43 f3 ff ff       	call   8001e8 <sys_page_unmap>
  800ea5:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  800ea8:	83 ec 08             	sub    $0x8,%esp
  800eab:	ff 75 f0             	pushl  -0x10(%ebp)
  800eae:	6a 00                	push   $0x0
  800eb0:	e8 33 f3 ff ff       	call   8001e8 <sys_page_unmap>
  800eb5:	83 c4 10             	add    $0x10,%esp
  800eb8:	e9 1c ff ff ff       	jmp    800dd9 <pipe+0x65>

00800ebd <pipeisclosed>:
{
  800ebd:	55                   	push   %ebp
  800ebe:	89 e5                	mov    %esp,%ebp
  800ec0:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800ec3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800ec6:	50                   	push   %eax
  800ec7:	ff 75 08             	pushl  0x8(%ebp)
  800eca:	e8 1a f5 ff ff       	call   8003e9 <fd_lookup>
  800ecf:	83 c4 10             	add    $0x10,%esp
  800ed2:	85 c0                	test   %eax,%eax
  800ed4:	78 18                	js     800eee <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  800ed6:	83 ec 0c             	sub    $0xc,%esp
  800ed9:	ff 75 f4             	pushl  -0xc(%ebp)
  800edc:	e8 a2 f4 ff ff       	call   800383 <fd2data>
	return _pipeisclosed(fd, p);
  800ee1:	89 c2                	mov    %eax,%edx
  800ee3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ee6:	e8 30 fd ff ff       	call   800c1b <_pipeisclosed>
  800eeb:	83 c4 10             	add    $0x10,%esp
}
  800eee:	c9                   	leave  
  800eef:	c3                   	ret    

00800ef0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  800ef0:	55                   	push   %ebp
  800ef1:	89 e5                	mov    %esp,%ebp
  800ef3:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  800ef6:	68 47 24 80 00       	push   $0x802447
  800efb:	ff 75 0c             	pushl  0xc(%ebp)
  800efe:	e8 47 0d 00 00       	call   801c4a <strcpy>
	return 0;
}
  800f03:	b8 00 00 00 00       	mov    $0x0,%eax
  800f08:	c9                   	leave  
  800f09:	c3                   	ret    

00800f0a <devsock_close>:
{
  800f0a:	55                   	push   %ebp
  800f0b:	89 e5                	mov    %esp,%ebp
  800f0d:	53                   	push   %ebx
  800f0e:	83 ec 10             	sub    $0x10,%esp
  800f11:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  800f14:	53                   	push   %ebx
  800f15:	e8 68 11 00 00       	call   802082 <pageref>
  800f1a:	83 c4 10             	add    $0x10,%esp
		return 0;
  800f1d:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  800f22:	83 f8 01             	cmp    $0x1,%eax
  800f25:	74 07                	je     800f2e <devsock_close+0x24>
}
  800f27:	89 d0                	mov    %edx,%eax
  800f29:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f2c:	c9                   	leave  
  800f2d:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  800f2e:	83 ec 0c             	sub    $0xc,%esp
  800f31:	ff 73 0c             	pushl  0xc(%ebx)
  800f34:	e8 b7 02 00 00       	call   8011f0 <nsipc_close>
  800f39:	89 c2                	mov    %eax,%edx
  800f3b:	83 c4 10             	add    $0x10,%esp
  800f3e:	eb e7                	jmp    800f27 <devsock_close+0x1d>

00800f40 <devsock_write>:
{
  800f40:	55                   	push   %ebp
  800f41:	89 e5                	mov    %esp,%ebp
  800f43:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  800f46:	6a 00                	push   $0x0
  800f48:	ff 75 10             	pushl  0x10(%ebp)
  800f4b:	ff 75 0c             	pushl  0xc(%ebp)
  800f4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f51:	ff 70 0c             	pushl  0xc(%eax)
  800f54:	e8 74 03 00 00       	call   8012cd <nsipc_send>
}
  800f59:	c9                   	leave  
  800f5a:	c3                   	ret    

00800f5b <devsock_read>:
{
  800f5b:	55                   	push   %ebp
  800f5c:	89 e5                	mov    %esp,%ebp
  800f5e:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  800f61:	6a 00                	push   $0x0
  800f63:	ff 75 10             	pushl  0x10(%ebp)
  800f66:	ff 75 0c             	pushl  0xc(%ebp)
  800f69:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6c:	ff 70 0c             	pushl  0xc(%eax)
  800f6f:	e8 ed 02 00 00       	call   801261 <nsipc_recv>
}
  800f74:	c9                   	leave  
  800f75:	c3                   	ret    

00800f76 <fd2sockid>:
{
  800f76:	55                   	push   %ebp
  800f77:	89 e5                	mov    %esp,%ebp
  800f79:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  800f7c:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800f7f:	52                   	push   %edx
  800f80:	50                   	push   %eax
  800f81:	e8 63 f4 ff ff       	call   8003e9 <fd_lookup>
  800f86:	83 c4 10             	add    $0x10,%esp
  800f89:	85 c0                	test   %eax,%eax
  800f8b:	78 10                	js     800f9d <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  800f8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f90:	8b 0d 3c 30 80 00    	mov    0x80303c,%ecx
  800f96:	39 08                	cmp    %ecx,(%eax)
  800f98:	75 05                	jne    800f9f <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  800f9a:	8b 40 0c             	mov    0xc(%eax),%eax
}
  800f9d:	c9                   	leave  
  800f9e:	c3                   	ret    
		return -E_NOT_SUPP;
  800f9f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800fa4:	eb f7                	jmp    800f9d <fd2sockid+0x27>

00800fa6 <alloc_sockfd>:
{
  800fa6:	55                   	push   %ebp
  800fa7:	89 e5                	mov    %esp,%ebp
  800fa9:	56                   	push   %esi
  800faa:	53                   	push   %ebx
  800fab:	83 ec 1c             	sub    $0x1c,%esp
  800fae:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  800fb0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800fb3:	50                   	push   %eax
  800fb4:	e8 e1 f3 ff ff       	call   80039a <fd_alloc>
  800fb9:	89 c3                	mov    %eax,%ebx
  800fbb:	83 c4 10             	add    $0x10,%esp
  800fbe:	85 c0                	test   %eax,%eax
  800fc0:	78 43                	js     801005 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  800fc2:	83 ec 04             	sub    $0x4,%esp
  800fc5:	68 07 04 00 00       	push   $0x407
  800fca:	ff 75 f4             	pushl  -0xc(%ebp)
  800fcd:	6a 00                	push   $0x0
  800fcf:	e8 8f f1 ff ff       	call   800163 <sys_page_alloc>
  800fd4:	89 c3                	mov    %eax,%ebx
  800fd6:	83 c4 10             	add    $0x10,%esp
  800fd9:	85 c0                	test   %eax,%eax
  800fdb:	78 28                	js     801005 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  800fdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fe0:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  800fe6:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  800fe8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800feb:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  800ff2:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  800ff5:	83 ec 0c             	sub    $0xc,%esp
  800ff8:	50                   	push   %eax
  800ff9:	e8 75 f3 ff ff       	call   800373 <fd2num>
  800ffe:	89 c3                	mov    %eax,%ebx
  801000:	83 c4 10             	add    $0x10,%esp
  801003:	eb 0c                	jmp    801011 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801005:	83 ec 0c             	sub    $0xc,%esp
  801008:	56                   	push   %esi
  801009:	e8 e2 01 00 00       	call   8011f0 <nsipc_close>
		return r;
  80100e:	83 c4 10             	add    $0x10,%esp
}
  801011:	89 d8                	mov    %ebx,%eax
  801013:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801016:	5b                   	pop    %ebx
  801017:	5e                   	pop    %esi
  801018:	5d                   	pop    %ebp
  801019:	c3                   	ret    

0080101a <accept>:
{
  80101a:	55                   	push   %ebp
  80101b:	89 e5                	mov    %esp,%ebp
  80101d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801020:	8b 45 08             	mov    0x8(%ebp),%eax
  801023:	e8 4e ff ff ff       	call   800f76 <fd2sockid>
  801028:	85 c0                	test   %eax,%eax
  80102a:	78 1b                	js     801047 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80102c:	83 ec 04             	sub    $0x4,%esp
  80102f:	ff 75 10             	pushl  0x10(%ebp)
  801032:	ff 75 0c             	pushl  0xc(%ebp)
  801035:	50                   	push   %eax
  801036:	e8 0e 01 00 00       	call   801149 <nsipc_accept>
  80103b:	83 c4 10             	add    $0x10,%esp
  80103e:	85 c0                	test   %eax,%eax
  801040:	78 05                	js     801047 <accept+0x2d>
	return alloc_sockfd(r);
  801042:	e8 5f ff ff ff       	call   800fa6 <alloc_sockfd>
}
  801047:	c9                   	leave  
  801048:	c3                   	ret    

00801049 <bind>:
{
  801049:	55                   	push   %ebp
  80104a:	89 e5                	mov    %esp,%ebp
  80104c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80104f:	8b 45 08             	mov    0x8(%ebp),%eax
  801052:	e8 1f ff ff ff       	call   800f76 <fd2sockid>
  801057:	85 c0                	test   %eax,%eax
  801059:	78 12                	js     80106d <bind+0x24>
	return nsipc_bind(r, name, namelen);
  80105b:	83 ec 04             	sub    $0x4,%esp
  80105e:	ff 75 10             	pushl  0x10(%ebp)
  801061:	ff 75 0c             	pushl  0xc(%ebp)
  801064:	50                   	push   %eax
  801065:	e8 2f 01 00 00       	call   801199 <nsipc_bind>
  80106a:	83 c4 10             	add    $0x10,%esp
}
  80106d:	c9                   	leave  
  80106e:	c3                   	ret    

0080106f <shutdown>:
{
  80106f:	55                   	push   %ebp
  801070:	89 e5                	mov    %esp,%ebp
  801072:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801075:	8b 45 08             	mov    0x8(%ebp),%eax
  801078:	e8 f9 fe ff ff       	call   800f76 <fd2sockid>
  80107d:	85 c0                	test   %eax,%eax
  80107f:	78 0f                	js     801090 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801081:	83 ec 08             	sub    $0x8,%esp
  801084:	ff 75 0c             	pushl  0xc(%ebp)
  801087:	50                   	push   %eax
  801088:	e8 41 01 00 00       	call   8011ce <nsipc_shutdown>
  80108d:	83 c4 10             	add    $0x10,%esp
}
  801090:	c9                   	leave  
  801091:	c3                   	ret    

00801092 <connect>:
{
  801092:	55                   	push   %ebp
  801093:	89 e5                	mov    %esp,%ebp
  801095:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801098:	8b 45 08             	mov    0x8(%ebp),%eax
  80109b:	e8 d6 fe ff ff       	call   800f76 <fd2sockid>
  8010a0:	85 c0                	test   %eax,%eax
  8010a2:	78 12                	js     8010b6 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8010a4:	83 ec 04             	sub    $0x4,%esp
  8010a7:	ff 75 10             	pushl  0x10(%ebp)
  8010aa:	ff 75 0c             	pushl  0xc(%ebp)
  8010ad:	50                   	push   %eax
  8010ae:	e8 57 01 00 00       	call   80120a <nsipc_connect>
  8010b3:	83 c4 10             	add    $0x10,%esp
}
  8010b6:	c9                   	leave  
  8010b7:	c3                   	ret    

008010b8 <listen>:
{
  8010b8:	55                   	push   %ebp
  8010b9:	89 e5                	mov    %esp,%ebp
  8010bb:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8010be:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c1:	e8 b0 fe ff ff       	call   800f76 <fd2sockid>
  8010c6:	85 c0                	test   %eax,%eax
  8010c8:	78 0f                	js     8010d9 <listen+0x21>
	return nsipc_listen(r, backlog);
  8010ca:	83 ec 08             	sub    $0x8,%esp
  8010cd:	ff 75 0c             	pushl  0xc(%ebp)
  8010d0:	50                   	push   %eax
  8010d1:	e8 69 01 00 00       	call   80123f <nsipc_listen>
  8010d6:	83 c4 10             	add    $0x10,%esp
}
  8010d9:	c9                   	leave  
  8010da:	c3                   	ret    

008010db <socket>:

int
socket(int domain, int type, int protocol)
{
  8010db:	55                   	push   %ebp
  8010dc:	89 e5                	mov    %esp,%ebp
  8010de:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8010e1:	ff 75 10             	pushl  0x10(%ebp)
  8010e4:	ff 75 0c             	pushl  0xc(%ebp)
  8010e7:	ff 75 08             	pushl  0x8(%ebp)
  8010ea:	e8 3c 02 00 00       	call   80132b <nsipc_socket>
  8010ef:	83 c4 10             	add    $0x10,%esp
  8010f2:	85 c0                	test   %eax,%eax
  8010f4:	78 05                	js     8010fb <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8010f6:	e8 ab fe ff ff       	call   800fa6 <alloc_sockfd>
}
  8010fb:	c9                   	leave  
  8010fc:	c3                   	ret    

008010fd <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8010fd:	55                   	push   %ebp
  8010fe:	89 e5                	mov    %esp,%ebp
  801100:	53                   	push   %ebx
  801101:	83 ec 04             	sub    $0x4,%esp
  801104:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801106:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  80110d:	74 26                	je     801135 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80110f:	6a 07                	push   $0x7
  801111:	68 00 60 80 00       	push   $0x806000
  801116:	53                   	push   %ebx
  801117:	ff 35 04 40 80 00    	pushl  0x804004
  80111d:	e8 ce 0e 00 00       	call   801ff0 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801122:	83 c4 0c             	add    $0xc,%esp
  801125:	6a 00                	push   $0x0
  801127:	6a 00                	push   $0x0
  801129:	6a 00                	push   $0x0
  80112b:	e8 57 0e 00 00       	call   801f87 <ipc_recv>
}
  801130:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801133:	c9                   	leave  
  801134:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801135:	83 ec 0c             	sub    $0xc,%esp
  801138:	6a 02                	push   $0x2
  80113a:	e8 0a 0f 00 00       	call   802049 <ipc_find_env>
  80113f:	a3 04 40 80 00       	mov    %eax,0x804004
  801144:	83 c4 10             	add    $0x10,%esp
  801147:	eb c6                	jmp    80110f <nsipc+0x12>

00801149 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801149:	55                   	push   %ebp
  80114a:	89 e5                	mov    %esp,%ebp
  80114c:	56                   	push   %esi
  80114d:	53                   	push   %ebx
  80114e:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801151:	8b 45 08             	mov    0x8(%ebp),%eax
  801154:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801159:	8b 06                	mov    (%esi),%eax
  80115b:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801160:	b8 01 00 00 00       	mov    $0x1,%eax
  801165:	e8 93 ff ff ff       	call   8010fd <nsipc>
  80116a:	89 c3                	mov    %eax,%ebx
  80116c:	85 c0                	test   %eax,%eax
  80116e:	78 20                	js     801190 <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801170:	83 ec 04             	sub    $0x4,%esp
  801173:	ff 35 10 60 80 00    	pushl  0x806010
  801179:	68 00 60 80 00       	push   $0x806000
  80117e:	ff 75 0c             	pushl  0xc(%ebp)
  801181:	e8 52 0c 00 00       	call   801dd8 <memmove>
		*addrlen = ret->ret_addrlen;
  801186:	a1 10 60 80 00       	mov    0x806010,%eax
  80118b:	89 06                	mov    %eax,(%esi)
  80118d:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  801190:	89 d8                	mov    %ebx,%eax
  801192:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801195:	5b                   	pop    %ebx
  801196:	5e                   	pop    %esi
  801197:	5d                   	pop    %ebp
  801198:	c3                   	ret    

00801199 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801199:	55                   	push   %ebp
  80119a:	89 e5                	mov    %esp,%ebp
  80119c:	53                   	push   %ebx
  80119d:	83 ec 08             	sub    $0x8,%esp
  8011a0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8011a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a6:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8011ab:	53                   	push   %ebx
  8011ac:	ff 75 0c             	pushl  0xc(%ebp)
  8011af:	68 04 60 80 00       	push   $0x806004
  8011b4:	e8 1f 0c 00 00       	call   801dd8 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8011b9:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  8011bf:	b8 02 00 00 00       	mov    $0x2,%eax
  8011c4:	e8 34 ff ff ff       	call   8010fd <nsipc>
}
  8011c9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011cc:	c9                   	leave  
  8011cd:	c3                   	ret    

008011ce <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8011ce:	55                   	push   %ebp
  8011cf:	89 e5                	mov    %esp,%ebp
  8011d1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8011d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  8011dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011df:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  8011e4:	b8 03 00 00 00       	mov    $0x3,%eax
  8011e9:	e8 0f ff ff ff       	call   8010fd <nsipc>
}
  8011ee:	c9                   	leave  
  8011ef:	c3                   	ret    

008011f0 <nsipc_close>:

int
nsipc_close(int s)
{
  8011f0:	55                   	push   %ebp
  8011f1:	89 e5                	mov    %esp,%ebp
  8011f3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8011f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f9:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  8011fe:	b8 04 00 00 00       	mov    $0x4,%eax
  801203:	e8 f5 fe ff ff       	call   8010fd <nsipc>
}
  801208:	c9                   	leave  
  801209:	c3                   	ret    

0080120a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80120a:	55                   	push   %ebp
  80120b:	89 e5                	mov    %esp,%ebp
  80120d:	53                   	push   %ebx
  80120e:	83 ec 08             	sub    $0x8,%esp
  801211:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801214:	8b 45 08             	mov    0x8(%ebp),%eax
  801217:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80121c:	53                   	push   %ebx
  80121d:	ff 75 0c             	pushl  0xc(%ebp)
  801220:	68 04 60 80 00       	push   $0x806004
  801225:	e8 ae 0b 00 00       	call   801dd8 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80122a:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801230:	b8 05 00 00 00       	mov    $0x5,%eax
  801235:	e8 c3 fe ff ff       	call   8010fd <nsipc>
}
  80123a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80123d:	c9                   	leave  
  80123e:	c3                   	ret    

0080123f <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80123f:	55                   	push   %ebp
  801240:	89 e5                	mov    %esp,%ebp
  801242:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801245:	8b 45 08             	mov    0x8(%ebp),%eax
  801248:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  80124d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801250:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801255:	b8 06 00 00 00       	mov    $0x6,%eax
  80125a:	e8 9e fe ff ff       	call   8010fd <nsipc>
}
  80125f:	c9                   	leave  
  801260:	c3                   	ret    

00801261 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801261:	55                   	push   %ebp
  801262:	89 e5                	mov    %esp,%ebp
  801264:	56                   	push   %esi
  801265:	53                   	push   %ebx
  801266:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801269:	8b 45 08             	mov    0x8(%ebp),%eax
  80126c:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801271:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801277:	8b 45 14             	mov    0x14(%ebp),%eax
  80127a:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80127f:	b8 07 00 00 00       	mov    $0x7,%eax
  801284:	e8 74 fe ff ff       	call   8010fd <nsipc>
  801289:	89 c3                	mov    %eax,%ebx
  80128b:	85 c0                	test   %eax,%eax
  80128d:	78 1f                	js     8012ae <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  80128f:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801294:	7f 21                	jg     8012b7 <nsipc_recv+0x56>
  801296:	39 c6                	cmp    %eax,%esi
  801298:	7c 1d                	jl     8012b7 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80129a:	83 ec 04             	sub    $0x4,%esp
  80129d:	50                   	push   %eax
  80129e:	68 00 60 80 00       	push   $0x806000
  8012a3:	ff 75 0c             	pushl  0xc(%ebp)
  8012a6:	e8 2d 0b 00 00       	call   801dd8 <memmove>
  8012ab:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8012ae:	89 d8                	mov    %ebx,%eax
  8012b0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012b3:	5b                   	pop    %ebx
  8012b4:	5e                   	pop    %esi
  8012b5:	5d                   	pop    %ebp
  8012b6:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8012b7:	68 53 24 80 00       	push   $0x802453
  8012bc:	68 f5 23 80 00       	push   $0x8023f5
  8012c1:	6a 62                	push   $0x62
  8012c3:	68 68 24 80 00       	push   $0x802468
  8012c8:	e8 05 02 00 00       	call   8014d2 <_panic>

008012cd <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8012cd:	55                   	push   %ebp
  8012ce:	89 e5                	mov    %esp,%ebp
  8012d0:	53                   	push   %ebx
  8012d1:	83 ec 04             	sub    $0x4,%esp
  8012d4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8012d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012da:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  8012df:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8012e5:	7f 2e                	jg     801315 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8012e7:	83 ec 04             	sub    $0x4,%esp
  8012ea:	53                   	push   %ebx
  8012eb:	ff 75 0c             	pushl  0xc(%ebp)
  8012ee:	68 0c 60 80 00       	push   $0x80600c
  8012f3:	e8 e0 0a 00 00       	call   801dd8 <memmove>
	nsipcbuf.send.req_size = size;
  8012f8:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  8012fe:	8b 45 14             	mov    0x14(%ebp),%eax
  801301:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801306:	b8 08 00 00 00       	mov    $0x8,%eax
  80130b:	e8 ed fd ff ff       	call   8010fd <nsipc>
}
  801310:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801313:	c9                   	leave  
  801314:	c3                   	ret    
	assert(size < 1600);
  801315:	68 74 24 80 00       	push   $0x802474
  80131a:	68 f5 23 80 00       	push   $0x8023f5
  80131f:	6a 6d                	push   $0x6d
  801321:	68 68 24 80 00       	push   $0x802468
  801326:	e8 a7 01 00 00       	call   8014d2 <_panic>

0080132b <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80132b:	55                   	push   %ebp
  80132c:	89 e5                	mov    %esp,%ebp
  80132e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801331:	8b 45 08             	mov    0x8(%ebp),%eax
  801334:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801339:	8b 45 0c             	mov    0xc(%ebp),%eax
  80133c:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801341:	8b 45 10             	mov    0x10(%ebp),%eax
  801344:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801349:	b8 09 00 00 00       	mov    $0x9,%eax
  80134e:	e8 aa fd ff ff       	call   8010fd <nsipc>
}
  801353:	c9                   	leave  
  801354:	c3                   	ret    

00801355 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801355:	55                   	push   %ebp
  801356:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801358:	b8 00 00 00 00       	mov    $0x0,%eax
  80135d:	5d                   	pop    %ebp
  80135e:	c3                   	ret    

0080135f <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80135f:	55                   	push   %ebp
  801360:	89 e5                	mov    %esp,%ebp
  801362:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801365:	68 80 24 80 00       	push   $0x802480
  80136a:	ff 75 0c             	pushl  0xc(%ebp)
  80136d:	e8 d8 08 00 00       	call   801c4a <strcpy>
	return 0;
}
  801372:	b8 00 00 00 00       	mov    $0x0,%eax
  801377:	c9                   	leave  
  801378:	c3                   	ret    

00801379 <devcons_write>:
{
  801379:	55                   	push   %ebp
  80137a:	89 e5                	mov    %esp,%ebp
  80137c:	57                   	push   %edi
  80137d:	56                   	push   %esi
  80137e:	53                   	push   %ebx
  80137f:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801385:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80138a:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801390:	eb 2f                	jmp    8013c1 <devcons_write+0x48>
		m = n - tot;
  801392:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801395:	29 f3                	sub    %esi,%ebx
  801397:	83 fb 7f             	cmp    $0x7f,%ebx
  80139a:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80139f:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8013a2:	83 ec 04             	sub    $0x4,%esp
  8013a5:	53                   	push   %ebx
  8013a6:	89 f0                	mov    %esi,%eax
  8013a8:	03 45 0c             	add    0xc(%ebp),%eax
  8013ab:	50                   	push   %eax
  8013ac:	57                   	push   %edi
  8013ad:	e8 26 0a 00 00       	call   801dd8 <memmove>
		sys_cputs(buf, m);
  8013b2:	83 c4 08             	add    $0x8,%esp
  8013b5:	53                   	push   %ebx
  8013b6:	57                   	push   %edi
  8013b7:	e8 eb ec ff ff       	call   8000a7 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8013bc:	01 de                	add    %ebx,%esi
  8013be:	83 c4 10             	add    $0x10,%esp
  8013c1:	3b 75 10             	cmp    0x10(%ebp),%esi
  8013c4:	72 cc                	jb     801392 <devcons_write+0x19>
}
  8013c6:	89 f0                	mov    %esi,%eax
  8013c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013cb:	5b                   	pop    %ebx
  8013cc:	5e                   	pop    %esi
  8013cd:	5f                   	pop    %edi
  8013ce:	5d                   	pop    %ebp
  8013cf:	c3                   	ret    

008013d0 <devcons_read>:
{
  8013d0:	55                   	push   %ebp
  8013d1:	89 e5                	mov    %esp,%ebp
  8013d3:	83 ec 08             	sub    $0x8,%esp
  8013d6:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8013db:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013df:	75 07                	jne    8013e8 <devcons_read+0x18>
}
  8013e1:	c9                   	leave  
  8013e2:	c3                   	ret    
		sys_yield();
  8013e3:	e8 5c ed ff ff       	call   800144 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  8013e8:	e8 d8 ec ff ff       	call   8000c5 <sys_cgetc>
  8013ed:	85 c0                	test   %eax,%eax
  8013ef:	74 f2                	je     8013e3 <devcons_read+0x13>
	if (c < 0)
  8013f1:	85 c0                	test   %eax,%eax
  8013f3:	78 ec                	js     8013e1 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  8013f5:	83 f8 04             	cmp    $0x4,%eax
  8013f8:	74 0c                	je     801406 <devcons_read+0x36>
	*(char*)vbuf = c;
  8013fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013fd:	88 02                	mov    %al,(%edx)
	return 1;
  8013ff:	b8 01 00 00 00       	mov    $0x1,%eax
  801404:	eb db                	jmp    8013e1 <devcons_read+0x11>
		return 0;
  801406:	b8 00 00 00 00       	mov    $0x0,%eax
  80140b:	eb d4                	jmp    8013e1 <devcons_read+0x11>

0080140d <cputchar>:
{
  80140d:	55                   	push   %ebp
  80140e:	89 e5                	mov    %esp,%ebp
  801410:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801413:	8b 45 08             	mov    0x8(%ebp),%eax
  801416:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801419:	6a 01                	push   $0x1
  80141b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80141e:	50                   	push   %eax
  80141f:	e8 83 ec ff ff       	call   8000a7 <sys_cputs>
}
  801424:	83 c4 10             	add    $0x10,%esp
  801427:	c9                   	leave  
  801428:	c3                   	ret    

00801429 <getchar>:
{
  801429:	55                   	push   %ebp
  80142a:	89 e5                	mov    %esp,%ebp
  80142c:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80142f:	6a 01                	push   $0x1
  801431:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801434:	50                   	push   %eax
  801435:	6a 00                	push   $0x0
  801437:	e8 1e f2 ff ff       	call   80065a <read>
	if (r < 0)
  80143c:	83 c4 10             	add    $0x10,%esp
  80143f:	85 c0                	test   %eax,%eax
  801441:	78 08                	js     80144b <getchar+0x22>
	if (r < 1)
  801443:	85 c0                	test   %eax,%eax
  801445:	7e 06                	jle    80144d <getchar+0x24>
	return c;
  801447:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80144b:	c9                   	leave  
  80144c:	c3                   	ret    
		return -E_EOF;
  80144d:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801452:	eb f7                	jmp    80144b <getchar+0x22>

00801454 <iscons>:
{
  801454:	55                   	push   %ebp
  801455:	89 e5                	mov    %esp,%ebp
  801457:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80145a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80145d:	50                   	push   %eax
  80145e:	ff 75 08             	pushl  0x8(%ebp)
  801461:	e8 83 ef ff ff       	call   8003e9 <fd_lookup>
  801466:	83 c4 10             	add    $0x10,%esp
  801469:	85 c0                	test   %eax,%eax
  80146b:	78 11                	js     80147e <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80146d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801470:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801476:	39 10                	cmp    %edx,(%eax)
  801478:	0f 94 c0             	sete   %al
  80147b:	0f b6 c0             	movzbl %al,%eax
}
  80147e:	c9                   	leave  
  80147f:	c3                   	ret    

00801480 <opencons>:
{
  801480:	55                   	push   %ebp
  801481:	89 e5                	mov    %esp,%ebp
  801483:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801486:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801489:	50                   	push   %eax
  80148a:	e8 0b ef ff ff       	call   80039a <fd_alloc>
  80148f:	83 c4 10             	add    $0x10,%esp
  801492:	85 c0                	test   %eax,%eax
  801494:	78 3a                	js     8014d0 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801496:	83 ec 04             	sub    $0x4,%esp
  801499:	68 07 04 00 00       	push   $0x407
  80149e:	ff 75 f4             	pushl  -0xc(%ebp)
  8014a1:	6a 00                	push   $0x0
  8014a3:	e8 bb ec ff ff       	call   800163 <sys_page_alloc>
  8014a8:	83 c4 10             	add    $0x10,%esp
  8014ab:	85 c0                	test   %eax,%eax
  8014ad:	78 21                	js     8014d0 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8014af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014b2:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8014b8:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8014ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014bd:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8014c4:	83 ec 0c             	sub    $0xc,%esp
  8014c7:	50                   	push   %eax
  8014c8:	e8 a6 ee ff ff       	call   800373 <fd2num>
  8014cd:	83 c4 10             	add    $0x10,%esp
}
  8014d0:	c9                   	leave  
  8014d1:	c3                   	ret    

008014d2 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8014d2:	55                   	push   %ebp
  8014d3:	89 e5                	mov    %esp,%ebp
  8014d5:	56                   	push   %esi
  8014d6:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8014d7:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8014da:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8014e0:	e8 40 ec ff ff       	call   800125 <sys_getenvid>
  8014e5:	83 ec 0c             	sub    $0xc,%esp
  8014e8:	ff 75 0c             	pushl  0xc(%ebp)
  8014eb:	ff 75 08             	pushl  0x8(%ebp)
  8014ee:	56                   	push   %esi
  8014ef:	50                   	push   %eax
  8014f0:	68 8c 24 80 00       	push   $0x80248c
  8014f5:	e8 b3 00 00 00       	call   8015ad <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8014fa:	83 c4 18             	add    $0x18,%esp
  8014fd:	53                   	push   %ebx
  8014fe:	ff 75 10             	pushl  0x10(%ebp)
  801501:	e8 56 00 00 00       	call   80155c <vcprintf>
	cprintf("\n");
  801506:	c7 04 24 40 24 80 00 	movl   $0x802440,(%esp)
  80150d:	e8 9b 00 00 00       	call   8015ad <cprintf>
  801512:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801515:	cc                   	int3   
  801516:	eb fd                	jmp    801515 <_panic+0x43>

00801518 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  801518:	55                   	push   %ebp
  801519:	89 e5                	mov    %esp,%ebp
  80151b:	53                   	push   %ebx
  80151c:	83 ec 04             	sub    $0x4,%esp
  80151f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801522:	8b 13                	mov    (%ebx),%edx
  801524:	8d 42 01             	lea    0x1(%edx),%eax
  801527:	89 03                	mov    %eax,(%ebx)
  801529:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80152c:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801530:	3d ff 00 00 00       	cmp    $0xff,%eax
  801535:	74 09                	je     801540 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  801537:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80153b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80153e:	c9                   	leave  
  80153f:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  801540:	83 ec 08             	sub    $0x8,%esp
  801543:	68 ff 00 00 00       	push   $0xff
  801548:	8d 43 08             	lea    0x8(%ebx),%eax
  80154b:	50                   	push   %eax
  80154c:	e8 56 eb ff ff       	call   8000a7 <sys_cputs>
		b->idx = 0;
  801551:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801557:	83 c4 10             	add    $0x10,%esp
  80155a:	eb db                	jmp    801537 <putch+0x1f>

0080155c <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80155c:	55                   	push   %ebp
  80155d:	89 e5                	mov    %esp,%ebp
  80155f:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801565:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80156c:	00 00 00 
	b.cnt = 0;
  80156f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801576:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  801579:	ff 75 0c             	pushl  0xc(%ebp)
  80157c:	ff 75 08             	pushl  0x8(%ebp)
  80157f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801585:	50                   	push   %eax
  801586:	68 18 15 80 00       	push   $0x801518
  80158b:	e8 1a 01 00 00       	call   8016aa <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801590:	83 c4 08             	add    $0x8,%esp
  801593:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  801599:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80159f:	50                   	push   %eax
  8015a0:	e8 02 eb ff ff       	call   8000a7 <sys_cputs>

	return b.cnt;
}
  8015a5:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8015ab:	c9                   	leave  
  8015ac:	c3                   	ret    

008015ad <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8015ad:	55                   	push   %ebp
  8015ae:	89 e5                	mov    %esp,%ebp
  8015b0:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8015b3:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8015b6:	50                   	push   %eax
  8015b7:	ff 75 08             	pushl  0x8(%ebp)
  8015ba:	e8 9d ff ff ff       	call   80155c <vcprintf>
	va_end(ap);

	return cnt;
}
  8015bf:	c9                   	leave  
  8015c0:	c3                   	ret    

008015c1 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8015c1:	55                   	push   %ebp
  8015c2:	89 e5                	mov    %esp,%ebp
  8015c4:	57                   	push   %edi
  8015c5:	56                   	push   %esi
  8015c6:	53                   	push   %ebx
  8015c7:	83 ec 1c             	sub    $0x1c,%esp
  8015ca:	89 c7                	mov    %eax,%edi
  8015cc:	89 d6                	mov    %edx,%esi
  8015ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015d4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8015d7:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8015da:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015dd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015e2:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8015e5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8015e8:	39 d3                	cmp    %edx,%ebx
  8015ea:	72 05                	jb     8015f1 <printnum+0x30>
  8015ec:	39 45 10             	cmp    %eax,0x10(%ebp)
  8015ef:	77 7a                	ja     80166b <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8015f1:	83 ec 0c             	sub    $0xc,%esp
  8015f4:	ff 75 18             	pushl  0x18(%ebp)
  8015f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8015fa:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8015fd:	53                   	push   %ebx
  8015fe:	ff 75 10             	pushl  0x10(%ebp)
  801601:	83 ec 08             	sub    $0x8,%esp
  801604:	ff 75 e4             	pushl  -0x1c(%ebp)
  801607:	ff 75 e0             	pushl  -0x20(%ebp)
  80160a:	ff 75 dc             	pushl  -0x24(%ebp)
  80160d:	ff 75 d8             	pushl  -0x28(%ebp)
  801610:	e8 ab 0a 00 00       	call   8020c0 <__udivdi3>
  801615:	83 c4 18             	add    $0x18,%esp
  801618:	52                   	push   %edx
  801619:	50                   	push   %eax
  80161a:	89 f2                	mov    %esi,%edx
  80161c:	89 f8                	mov    %edi,%eax
  80161e:	e8 9e ff ff ff       	call   8015c1 <printnum>
  801623:	83 c4 20             	add    $0x20,%esp
  801626:	eb 13                	jmp    80163b <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801628:	83 ec 08             	sub    $0x8,%esp
  80162b:	56                   	push   %esi
  80162c:	ff 75 18             	pushl  0x18(%ebp)
  80162f:	ff d7                	call   *%edi
  801631:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  801634:	83 eb 01             	sub    $0x1,%ebx
  801637:	85 db                	test   %ebx,%ebx
  801639:	7f ed                	jg     801628 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80163b:	83 ec 08             	sub    $0x8,%esp
  80163e:	56                   	push   %esi
  80163f:	83 ec 04             	sub    $0x4,%esp
  801642:	ff 75 e4             	pushl  -0x1c(%ebp)
  801645:	ff 75 e0             	pushl  -0x20(%ebp)
  801648:	ff 75 dc             	pushl  -0x24(%ebp)
  80164b:	ff 75 d8             	pushl  -0x28(%ebp)
  80164e:	e8 8d 0b 00 00       	call   8021e0 <__umoddi3>
  801653:	83 c4 14             	add    $0x14,%esp
  801656:	0f be 80 af 24 80 00 	movsbl 0x8024af(%eax),%eax
  80165d:	50                   	push   %eax
  80165e:	ff d7                	call   *%edi
}
  801660:	83 c4 10             	add    $0x10,%esp
  801663:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801666:	5b                   	pop    %ebx
  801667:	5e                   	pop    %esi
  801668:	5f                   	pop    %edi
  801669:	5d                   	pop    %ebp
  80166a:	c3                   	ret    
  80166b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80166e:	eb c4                	jmp    801634 <printnum+0x73>

00801670 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801670:	55                   	push   %ebp
  801671:	89 e5                	mov    %esp,%ebp
  801673:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801676:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80167a:	8b 10                	mov    (%eax),%edx
  80167c:	3b 50 04             	cmp    0x4(%eax),%edx
  80167f:	73 0a                	jae    80168b <sprintputch+0x1b>
		*b->buf++ = ch;
  801681:	8d 4a 01             	lea    0x1(%edx),%ecx
  801684:	89 08                	mov    %ecx,(%eax)
  801686:	8b 45 08             	mov    0x8(%ebp),%eax
  801689:	88 02                	mov    %al,(%edx)
}
  80168b:	5d                   	pop    %ebp
  80168c:	c3                   	ret    

0080168d <printfmt>:
{
  80168d:	55                   	push   %ebp
  80168e:	89 e5                	mov    %esp,%ebp
  801690:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  801693:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  801696:	50                   	push   %eax
  801697:	ff 75 10             	pushl  0x10(%ebp)
  80169a:	ff 75 0c             	pushl  0xc(%ebp)
  80169d:	ff 75 08             	pushl  0x8(%ebp)
  8016a0:	e8 05 00 00 00       	call   8016aa <vprintfmt>
}
  8016a5:	83 c4 10             	add    $0x10,%esp
  8016a8:	c9                   	leave  
  8016a9:	c3                   	ret    

008016aa <vprintfmt>:
{
  8016aa:	55                   	push   %ebp
  8016ab:	89 e5                	mov    %esp,%ebp
  8016ad:	57                   	push   %edi
  8016ae:	56                   	push   %esi
  8016af:	53                   	push   %ebx
  8016b0:	83 ec 2c             	sub    $0x2c,%esp
  8016b3:	8b 75 08             	mov    0x8(%ebp),%esi
  8016b6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8016b9:	8b 7d 10             	mov    0x10(%ebp),%edi
  8016bc:	e9 21 04 00 00       	jmp    801ae2 <vprintfmt+0x438>
		padc = ' ';
  8016c1:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8016c5:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8016cc:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  8016d3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8016da:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8016df:	8d 47 01             	lea    0x1(%edi),%eax
  8016e2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8016e5:	0f b6 17             	movzbl (%edi),%edx
  8016e8:	8d 42 dd             	lea    -0x23(%edx),%eax
  8016eb:	3c 55                	cmp    $0x55,%al
  8016ed:	0f 87 90 04 00 00    	ja     801b83 <vprintfmt+0x4d9>
  8016f3:	0f b6 c0             	movzbl %al,%eax
  8016f6:	ff 24 85 00 26 80 00 	jmp    *0x802600(,%eax,4)
  8016fd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  801700:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  801704:	eb d9                	jmp    8016df <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  801706:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  801709:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  80170d:	eb d0                	jmp    8016df <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80170f:	0f b6 d2             	movzbl %dl,%edx
  801712:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  801715:	b8 00 00 00 00       	mov    $0x0,%eax
  80171a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80171d:	8d 04 80             	lea    (%eax,%eax,4),%eax
  801720:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  801724:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  801727:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80172a:	83 f9 09             	cmp    $0x9,%ecx
  80172d:	77 55                	ja     801784 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  80172f:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  801732:	eb e9                	jmp    80171d <vprintfmt+0x73>
			precision = va_arg(ap, int);
  801734:	8b 45 14             	mov    0x14(%ebp),%eax
  801737:	8b 00                	mov    (%eax),%eax
  801739:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80173c:	8b 45 14             	mov    0x14(%ebp),%eax
  80173f:	8d 40 04             	lea    0x4(%eax),%eax
  801742:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801745:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  801748:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80174c:	79 91                	jns    8016df <vprintfmt+0x35>
				width = precision, precision = -1;
  80174e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801751:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801754:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80175b:	eb 82                	jmp    8016df <vprintfmt+0x35>
  80175d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801760:	85 c0                	test   %eax,%eax
  801762:	ba 00 00 00 00       	mov    $0x0,%edx
  801767:	0f 49 d0             	cmovns %eax,%edx
  80176a:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80176d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801770:	e9 6a ff ff ff       	jmp    8016df <vprintfmt+0x35>
  801775:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  801778:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  80177f:	e9 5b ff ff ff       	jmp    8016df <vprintfmt+0x35>
  801784:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  801787:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80178a:	eb bc                	jmp    801748 <vprintfmt+0x9e>
			lflag++;
  80178c:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80178f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  801792:	e9 48 ff ff ff       	jmp    8016df <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  801797:	8b 45 14             	mov    0x14(%ebp),%eax
  80179a:	8d 78 04             	lea    0x4(%eax),%edi
  80179d:	83 ec 08             	sub    $0x8,%esp
  8017a0:	53                   	push   %ebx
  8017a1:	ff 30                	pushl  (%eax)
  8017a3:	ff d6                	call   *%esi
			break;
  8017a5:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8017a8:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8017ab:	e9 2f 03 00 00       	jmp    801adf <vprintfmt+0x435>
			err = va_arg(ap, int);
  8017b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8017b3:	8d 78 04             	lea    0x4(%eax),%edi
  8017b6:	8b 00                	mov    (%eax),%eax
  8017b8:	99                   	cltd   
  8017b9:	31 d0                	xor    %edx,%eax
  8017bb:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8017bd:	83 f8 0f             	cmp    $0xf,%eax
  8017c0:	7f 23                	jg     8017e5 <vprintfmt+0x13b>
  8017c2:	8b 14 85 60 27 80 00 	mov    0x802760(,%eax,4),%edx
  8017c9:	85 d2                	test   %edx,%edx
  8017cb:	74 18                	je     8017e5 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  8017cd:	52                   	push   %edx
  8017ce:	68 07 24 80 00       	push   $0x802407
  8017d3:	53                   	push   %ebx
  8017d4:	56                   	push   %esi
  8017d5:	e8 b3 fe ff ff       	call   80168d <printfmt>
  8017da:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8017dd:	89 7d 14             	mov    %edi,0x14(%ebp)
  8017e0:	e9 fa 02 00 00       	jmp    801adf <vprintfmt+0x435>
				printfmt(putch, putdat, "error %d", err);
  8017e5:	50                   	push   %eax
  8017e6:	68 c7 24 80 00       	push   $0x8024c7
  8017eb:	53                   	push   %ebx
  8017ec:	56                   	push   %esi
  8017ed:	e8 9b fe ff ff       	call   80168d <printfmt>
  8017f2:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8017f5:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8017f8:	e9 e2 02 00 00       	jmp    801adf <vprintfmt+0x435>
			if ((p = va_arg(ap, char *)) == NULL)
  8017fd:	8b 45 14             	mov    0x14(%ebp),%eax
  801800:	83 c0 04             	add    $0x4,%eax
  801803:	89 45 cc             	mov    %eax,-0x34(%ebp)
  801806:	8b 45 14             	mov    0x14(%ebp),%eax
  801809:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80180b:	85 ff                	test   %edi,%edi
  80180d:	b8 c0 24 80 00       	mov    $0x8024c0,%eax
  801812:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  801815:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801819:	0f 8e bd 00 00 00    	jle    8018dc <vprintfmt+0x232>
  80181f:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  801823:	75 0e                	jne    801833 <vprintfmt+0x189>
  801825:	89 75 08             	mov    %esi,0x8(%ebp)
  801828:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80182b:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80182e:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  801831:	eb 6d                	jmp    8018a0 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  801833:	83 ec 08             	sub    $0x8,%esp
  801836:	ff 75 d0             	pushl  -0x30(%ebp)
  801839:	57                   	push   %edi
  80183a:	e8 ec 03 00 00       	call   801c2b <strnlen>
  80183f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  801842:	29 c1                	sub    %eax,%ecx
  801844:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  801847:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  80184a:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  80184e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801851:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  801854:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  801856:	eb 0f                	jmp    801867 <vprintfmt+0x1bd>
					putch(padc, putdat);
  801858:	83 ec 08             	sub    $0x8,%esp
  80185b:	53                   	push   %ebx
  80185c:	ff 75 e0             	pushl  -0x20(%ebp)
  80185f:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  801861:	83 ef 01             	sub    $0x1,%edi
  801864:	83 c4 10             	add    $0x10,%esp
  801867:	85 ff                	test   %edi,%edi
  801869:	7f ed                	jg     801858 <vprintfmt+0x1ae>
  80186b:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  80186e:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  801871:	85 c9                	test   %ecx,%ecx
  801873:	b8 00 00 00 00       	mov    $0x0,%eax
  801878:	0f 49 c1             	cmovns %ecx,%eax
  80187b:	29 c1                	sub    %eax,%ecx
  80187d:	89 75 08             	mov    %esi,0x8(%ebp)
  801880:	8b 75 d0             	mov    -0x30(%ebp),%esi
  801883:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  801886:	89 cb                	mov    %ecx,%ebx
  801888:	eb 16                	jmp    8018a0 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  80188a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80188e:	75 31                	jne    8018c1 <vprintfmt+0x217>
					putch(ch, putdat);
  801890:	83 ec 08             	sub    $0x8,%esp
  801893:	ff 75 0c             	pushl  0xc(%ebp)
  801896:	50                   	push   %eax
  801897:	ff 55 08             	call   *0x8(%ebp)
  80189a:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80189d:	83 eb 01             	sub    $0x1,%ebx
  8018a0:	83 c7 01             	add    $0x1,%edi
  8018a3:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8018a7:	0f be c2             	movsbl %dl,%eax
  8018aa:	85 c0                	test   %eax,%eax
  8018ac:	74 59                	je     801907 <vprintfmt+0x25d>
  8018ae:	85 f6                	test   %esi,%esi
  8018b0:	78 d8                	js     80188a <vprintfmt+0x1e0>
  8018b2:	83 ee 01             	sub    $0x1,%esi
  8018b5:	79 d3                	jns    80188a <vprintfmt+0x1e0>
  8018b7:	89 df                	mov    %ebx,%edi
  8018b9:	8b 75 08             	mov    0x8(%ebp),%esi
  8018bc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8018bf:	eb 37                	jmp    8018f8 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  8018c1:	0f be d2             	movsbl %dl,%edx
  8018c4:	83 ea 20             	sub    $0x20,%edx
  8018c7:	83 fa 5e             	cmp    $0x5e,%edx
  8018ca:	76 c4                	jbe    801890 <vprintfmt+0x1e6>
					putch('?', putdat);
  8018cc:	83 ec 08             	sub    $0x8,%esp
  8018cf:	ff 75 0c             	pushl  0xc(%ebp)
  8018d2:	6a 3f                	push   $0x3f
  8018d4:	ff 55 08             	call   *0x8(%ebp)
  8018d7:	83 c4 10             	add    $0x10,%esp
  8018da:	eb c1                	jmp    80189d <vprintfmt+0x1f3>
  8018dc:	89 75 08             	mov    %esi,0x8(%ebp)
  8018df:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8018e2:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8018e5:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8018e8:	eb b6                	jmp    8018a0 <vprintfmt+0x1f6>
				putch(' ', putdat);
  8018ea:	83 ec 08             	sub    $0x8,%esp
  8018ed:	53                   	push   %ebx
  8018ee:	6a 20                	push   $0x20
  8018f0:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8018f2:	83 ef 01             	sub    $0x1,%edi
  8018f5:	83 c4 10             	add    $0x10,%esp
  8018f8:	85 ff                	test   %edi,%edi
  8018fa:	7f ee                	jg     8018ea <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  8018fc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8018ff:	89 45 14             	mov    %eax,0x14(%ebp)
  801902:	e9 d8 01 00 00       	jmp    801adf <vprintfmt+0x435>
  801907:	89 df                	mov    %ebx,%edi
  801909:	8b 75 08             	mov    0x8(%ebp),%esi
  80190c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80190f:	eb e7                	jmp    8018f8 <vprintfmt+0x24e>
	if (lflag >= 2)
  801911:	83 f9 01             	cmp    $0x1,%ecx
  801914:	7e 45                	jle    80195b <vprintfmt+0x2b1>
		return va_arg(*ap, long long);
  801916:	8b 45 14             	mov    0x14(%ebp),%eax
  801919:	8b 50 04             	mov    0x4(%eax),%edx
  80191c:	8b 00                	mov    (%eax),%eax
  80191e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801921:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801924:	8b 45 14             	mov    0x14(%ebp),%eax
  801927:	8d 40 08             	lea    0x8(%eax),%eax
  80192a:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80192d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801931:	79 62                	jns    801995 <vprintfmt+0x2eb>
				putch('-', putdat);
  801933:	83 ec 08             	sub    $0x8,%esp
  801936:	53                   	push   %ebx
  801937:	6a 2d                	push   $0x2d
  801939:	ff d6                	call   *%esi
				num = -(long long) num;
  80193b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80193e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801941:	f7 d8                	neg    %eax
  801943:	83 d2 00             	adc    $0x0,%edx
  801946:	f7 da                	neg    %edx
  801948:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80194b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80194e:	83 c4 10             	add    $0x10,%esp
			base = 10;
  801951:	ba 0a 00 00 00       	mov    $0xa,%edx
  801956:	e9 66 01 00 00       	jmp    801ac1 <vprintfmt+0x417>
	else if (lflag)
  80195b:	85 c9                	test   %ecx,%ecx
  80195d:	75 1b                	jne    80197a <vprintfmt+0x2d0>
		return va_arg(*ap, int);
  80195f:	8b 45 14             	mov    0x14(%ebp),%eax
  801962:	8b 00                	mov    (%eax),%eax
  801964:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801967:	89 c1                	mov    %eax,%ecx
  801969:	c1 f9 1f             	sar    $0x1f,%ecx
  80196c:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80196f:	8b 45 14             	mov    0x14(%ebp),%eax
  801972:	8d 40 04             	lea    0x4(%eax),%eax
  801975:	89 45 14             	mov    %eax,0x14(%ebp)
  801978:	eb b3                	jmp    80192d <vprintfmt+0x283>
		return va_arg(*ap, long);
  80197a:	8b 45 14             	mov    0x14(%ebp),%eax
  80197d:	8b 00                	mov    (%eax),%eax
  80197f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801982:	89 c1                	mov    %eax,%ecx
  801984:	c1 f9 1f             	sar    $0x1f,%ecx
  801987:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80198a:	8b 45 14             	mov    0x14(%ebp),%eax
  80198d:	8d 40 04             	lea    0x4(%eax),%eax
  801990:	89 45 14             	mov    %eax,0x14(%ebp)
  801993:	eb 98                	jmp    80192d <vprintfmt+0x283>
			base = 10;
  801995:	ba 0a 00 00 00       	mov    $0xa,%edx
  80199a:	e9 22 01 00 00       	jmp    801ac1 <vprintfmt+0x417>
	if (lflag >= 2)
  80199f:	83 f9 01             	cmp    $0x1,%ecx
  8019a2:	7e 21                	jle    8019c5 <vprintfmt+0x31b>
		return va_arg(*ap, unsigned long long);
  8019a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8019a7:	8b 50 04             	mov    0x4(%eax),%edx
  8019aa:	8b 00                	mov    (%eax),%eax
  8019ac:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8019af:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8019b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8019b5:	8d 40 08             	lea    0x8(%eax),%eax
  8019b8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8019bb:	ba 0a 00 00 00       	mov    $0xa,%edx
  8019c0:	e9 fc 00 00 00       	jmp    801ac1 <vprintfmt+0x417>
	else if (lflag)
  8019c5:	85 c9                	test   %ecx,%ecx
  8019c7:	75 23                	jne    8019ec <vprintfmt+0x342>
		return va_arg(*ap, unsigned int);
  8019c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8019cc:	8b 00                	mov    (%eax),%eax
  8019ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8019d3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8019d6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8019d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8019dc:	8d 40 04             	lea    0x4(%eax),%eax
  8019df:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8019e2:	ba 0a 00 00 00       	mov    $0xa,%edx
  8019e7:	e9 d5 00 00 00       	jmp    801ac1 <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  8019ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8019ef:	8b 00                	mov    (%eax),%eax
  8019f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8019f6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8019f9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8019fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8019ff:	8d 40 04             	lea    0x4(%eax),%eax
  801a02:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801a05:	ba 0a 00 00 00       	mov    $0xa,%edx
  801a0a:	e9 b2 00 00 00       	jmp    801ac1 <vprintfmt+0x417>
	if (lflag >= 2)
  801a0f:	83 f9 01             	cmp    $0x1,%ecx
  801a12:	7e 42                	jle    801a56 <vprintfmt+0x3ac>
		return va_arg(*ap, unsigned long long);
  801a14:	8b 45 14             	mov    0x14(%ebp),%eax
  801a17:	8b 50 04             	mov    0x4(%eax),%edx
  801a1a:	8b 00                	mov    (%eax),%eax
  801a1c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801a1f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801a22:	8b 45 14             	mov    0x14(%ebp),%eax
  801a25:	8d 40 08             	lea    0x8(%eax),%eax
  801a28:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801a2b:	ba 08 00 00 00       	mov    $0x8,%edx
			if ((long long) num < 0) {
  801a30:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801a34:	0f 89 87 00 00 00    	jns    801ac1 <vprintfmt+0x417>
				putch('-', putdat);
  801a3a:	83 ec 08             	sub    $0x8,%esp
  801a3d:	53                   	push   %ebx
  801a3e:	6a 2d                	push   $0x2d
  801a40:	ff d6                	call   *%esi
				num = -(long long) num;
  801a42:	f7 5d d8             	negl   -0x28(%ebp)
  801a45:	83 55 dc 00          	adcl   $0x0,-0x24(%ebp)
  801a49:	f7 5d dc             	negl   -0x24(%ebp)
  801a4c:	83 c4 10             	add    $0x10,%esp
			base = 8;
  801a4f:	ba 08 00 00 00       	mov    $0x8,%edx
  801a54:	eb 6b                	jmp    801ac1 <vprintfmt+0x417>
	else if (lflag)
  801a56:	85 c9                	test   %ecx,%ecx
  801a58:	75 1b                	jne    801a75 <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  801a5a:	8b 45 14             	mov    0x14(%ebp),%eax
  801a5d:	8b 00                	mov    (%eax),%eax
  801a5f:	ba 00 00 00 00       	mov    $0x0,%edx
  801a64:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801a67:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801a6a:	8b 45 14             	mov    0x14(%ebp),%eax
  801a6d:	8d 40 04             	lea    0x4(%eax),%eax
  801a70:	89 45 14             	mov    %eax,0x14(%ebp)
  801a73:	eb b6                	jmp    801a2b <vprintfmt+0x381>
		return va_arg(*ap, unsigned long);
  801a75:	8b 45 14             	mov    0x14(%ebp),%eax
  801a78:	8b 00                	mov    (%eax),%eax
  801a7a:	ba 00 00 00 00       	mov    $0x0,%edx
  801a7f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801a82:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801a85:	8b 45 14             	mov    0x14(%ebp),%eax
  801a88:	8d 40 04             	lea    0x4(%eax),%eax
  801a8b:	89 45 14             	mov    %eax,0x14(%ebp)
  801a8e:	eb 9b                	jmp    801a2b <vprintfmt+0x381>
			putch('0', putdat);
  801a90:	83 ec 08             	sub    $0x8,%esp
  801a93:	53                   	push   %ebx
  801a94:	6a 30                	push   $0x30
  801a96:	ff d6                	call   *%esi
			putch('x', putdat);
  801a98:	83 c4 08             	add    $0x8,%esp
  801a9b:	53                   	push   %ebx
  801a9c:	6a 78                	push   $0x78
  801a9e:	ff d6                	call   *%esi
			num = (unsigned long long)
  801aa0:	8b 45 14             	mov    0x14(%ebp),%eax
  801aa3:	8b 00                	mov    (%eax),%eax
  801aa5:	ba 00 00 00 00       	mov    $0x0,%edx
  801aaa:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801aad:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  801ab0:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  801ab3:	8b 45 14             	mov    0x14(%ebp),%eax
  801ab6:	8d 40 04             	lea    0x4(%eax),%eax
  801ab9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801abc:	ba 10 00 00 00       	mov    $0x10,%edx
			printnum(putch, putdat, num, base, width, padc);
  801ac1:	83 ec 0c             	sub    $0xc,%esp
  801ac4:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  801ac8:	50                   	push   %eax
  801ac9:	ff 75 e0             	pushl  -0x20(%ebp)
  801acc:	52                   	push   %edx
  801acd:	ff 75 dc             	pushl  -0x24(%ebp)
  801ad0:	ff 75 d8             	pushl  -0x28(%ebp)
  801ad3:	89 da                	mov    %ebx,%edx
  801ad5:	89 f0                	mov    %esi,%eax
  801ad7:	e8 e5 fa ff ff       	call   8015c1 <printnum>
			break;
  801adc:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  801adf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801ae2:	83 c7 01             	add    $0x1,%edi
  801ae5:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801ae9:	83 f8 25             	cmp    $0x25,%eax
  801aec:	0f 84 cf fb ff ff    	je     8016c1 <vprintfmt+0x17>
			if (ch == '\0')
  801af2:	85 c0                	test   %eax,%eax
  801af4:	0f 84 a9 00 00 00    	je     801ba3 <vprintfmt+0x4f9>
			putch(ch, putdat);
  801afa:	83 ec 08             	sub    $0x8,%esp
  801afd:	53                   	push   %ebx
  801afe:	50                   	push   %eax
  801aff:	ff d6                	call   *%esi
  801b01:	83 c4 10             	add    $0x10,%esp
  801b04:	eb dc                	jmp    801ae2 <vprintfmt+0x438>
	if (lflag >= 2)
  801b06:	83 f9 01             	cmp    $0x1,%ecx
  801b09:	7e 1e                	jle    801b29 <vprintfmt+0x47f>
		return va_arg(*ap, unsigned long long);
  801b0b:	8b 45 14             	mov    0x14(%ebp),%eax
  801b0e:	8b 50 04             	mov    0x4(%eax),%edx
  801b11:	8b 00                	mov    (%eax),%eax
  801b13:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801b16:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801b19:	8b 45 14             	mov    0x14(%ebp),%eax
  801b1c:	8d 40 08             	lea    0x8(%eax),%eax
  801b1f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801b22:	ba 10 00 00 00       	mov    $0x10,%edx
  801b27:	eb 98                	jmp    801ac1 <vprintfmt+0x417>
	else if (lflag)
  801b29:	85 c9                	test   %ecx,%ecx
  801b2b:	75 23                	jne    801b50 <vprintfmt+0x4a6>
		return va_arg(*ap, unsigned int);
  801b2d:	8b 45 14             	mov    0x14(%ebp),%eax
  801b30:	8b 00                	mov    (%eax),%eax
  801b32:	ba 00 00 00 00       	mov    $0x0,%edx
  801b37:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801b3a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801b3d:	8b 45 14             	mov    0x14(%ebp),%eax
  801b40:	8d 40 04             	lea    0x4(%eax),%eax
  801b43:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801b46:	ba 10 00 00 00       	mov    $0x10,%edx
  801b4b:	e9 71 ff ff ff       	jmp    801ac1 <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  801b50:	8b 45 14             	mov    0x14(%ebp),%eax
  801b53:	8b 00                	mov    (%eax),%eax
  801b55:	ba 00 00 00 00       	mov    $0x0,%edx
  801b5a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801b5d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801b60:	8b 45 14             	mov    0x14(%ebp),%eax
  801b63:	8d 40 04             	lea    0x4(%eax),%eax
  801b66:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801b69:	ba 10 00 00 00       	mov    $0x10,%edx
  801b6e:	e9 4e ff ff ff       	jmp    801ac1 <vprintfmt+0x417>
			putch(ch, putdat);
  801b73:	83 ec 08             	sub    $0x8,%esp
  801b76:	53                   	push   %ebx
  801b77:	6a 25                	push   $0x25
  801b79:	ff d6                	call   *%esi
			break;
  801b7b:	83 c4 10             	add    $0x10,%esp
  801b7e:	e9 5c ff ff ff       	jmp    801adf <vprintfmt+0x435>
			putch('%', putdat);
  801b83:	83 ec 08             	sub    $0x8,%esp
  801b86:	53                   	push   %ebx
  801b87:	6a 25                	push   $0x25
  801b89:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  801b8b:	83 c4 10             	add    $0x10,%esp
  801b8e:	89 f8                	mov    %edi,%eax
  801b90:	eb 03                	jmp    801b95 <vprintfmt+0x4eb>
  801b92:	83 e8 01             	sub    $0x1,%eax
  801b95:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  801b99:	75 f7                	jne    801b92 <vprintfmt+0x4e8>
  801b9b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801b9e:	e9 3c ff ff ff       	jmp    801adf <vprintfmt+0x435>
}
  801ba3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ba6:	5b                   	pop    %ebx
  801ba7:	5e                   	pop    %esi
  801ba8:	5f                   	pop    %edi
  801ba9:	5d                   	pop    %ebp
  801baa:	c3                   	ret    

00801bab <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801bab:	55                   	push   %ebp
  801bac:	89 e5                	mov    %esp,%ebp
  801bae:	83 ec 18             	sub    $0x18,%esp
  801bb1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb4:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801bb7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801bba:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801bbe:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801bc1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801bc8:	85 c0                	test   %eax,%eax
  801bca:	74 26                	je     801bf2 <vsnprintf+0x47>
  801bcc:	85 d2                	test   %edx,%edx
  801bce:	7e 22                	jle    801bf2 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801bd0:	ff 75 14             	pushl  0x14(%ebp)
  801bd3:	ff 75 10             	pushl  0x10(%ebp)
  801bd6:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801bd9:	50                   	push   %eax
  801bda:	68 70 16 80 00       	push   $0x801670
  801bdf:	e8 c6 fa ff ff       	call   8016aa <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801be4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801be7:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801bea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bed:	83 c4 10             	add    $0x10,%esp
}
  801bf0:	c9                   	leave  
  801bf1:	c3                   	ret    
		return -E_INVAL;
  801bf2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801bf7:	eb f7                	jmp    801bf0 <vsnprintf+0x45>

00801bf9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801bf9:	55                   	push   %ebp
  801bfa:	89 e5                	mov    %esp,%ebp
  801bfc:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801bff:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801c02:	50                   	push   %eax
  801c03:	ff 75 10             	pushl  0x10(%ebp)
  801c06:	ff 75 0c             	pushl  0xc(%ebp)
  801c09:	ff 75 08             	pushl  0x8(%ebp)
  801c0c:	e8 9a ff ff ff       	call   801bab <vsnprintf>
	va_end(ap);

	return rc;
}
  801c11:	c9                   	leave  
  801c12:	c3                   	ret    

00801c13 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801c13:	55                   	push   %ebp
  801c14:	89 e5                	mov    %esp,%ebp
  801c16:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801c19:	b8 00 00 00 00       	mov    $0x0,%eax
  801c1e:	eb 03                	jmp    801c23 <strlen+0x10>
		n++;
  801c20:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  801c23:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801c27:	75 f7                	jne    801c20 <strlen+0xd>
	return n;
}
  801c29:	5d                   	pop    %ebp
  801c2a:	c3                   	ret    

00801c2b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801c2b:	55                   	push   %ebp
  801c2c:	89 e5                	mov    %esp,%ebp
  801c2e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c31:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801c34:	b8 00 00 00 00       	mov    $0x0,%eax
  801c39:	eb 03                	jmp    801c3e <strnlen+0x13>
		n++;
  801c3b:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801c3e:	39 d0                	cmp    %edx,%eax
  801c40:	74 06                	je     801c48 <strnlen+0x1d>
  801c42:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  801c46:	75 f3                	jne    801c3b <strnlen+0x10>
	return n;
}
  801c48:	5d                   	pop    %ebp
  801c49:	c3                   	ret    

00801c4a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801c4a:	55                   	push   %ebp
  801c4b:	89 e5                	mov    %esp,%ebp
  801c4d:	53                   	push   %ebx
  801c4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c51:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801c54:	89 c2                	mov    %eax,%edx
  801c56:	83 c1 01             	add    $0x1,%ecx
  801c59:	83 c2 01             	add    $0x1,%edx
  801c5c:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  801c60:	88 5a ff             	mov    %bl,-0x1(%edx)
  801c63:	84 db                	test   %bl,%bl
  801c65:	75 ef                	jne    801c56 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  801c67:	5b                   	pop    %ebx
  801c68:	5d                   	pop    %ebp
  801c69:	c3                   	ret    

00801c6a <strcat>:

char *
strcat(char *dst, const char *src)
{
  801c6a:	55                   	push   %ebp
  801c6b:	89 e5                	mov    %esp,%ebp
  801c6d:	53                   	push   %ebx
  801c6e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801c71:	53                   	push   %ebx
  801c72:	e8 9c ff ff ff       	call   801c13 <strlen>
  801c77:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  801c7a:	ff 75 0c             	pushl  0xc(%ebp)
  801c7d:	01 d8                	add    %ebx,%eax
  801c7f:	50                   	push   %eax
  801c80:	e8 c5 ff ff ff       	call   801c4a <strcpy>
	return dst;
}
  801c85:	89 d8                	mov    %ebx,%eax
  801c87:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c8a:	c9                   	leave  
  801c8b:	c3                   	ret    

00801c8c <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801c8c:	55                   	push   %ebp
  801c8d:	89 e5                	mov    %esp,%ebp
  801c8f:	56                   	push   %esi
  801c90:	53                   	push   %ebx
  801c91:	8b 75 08             	mov    0x8(%ebp),%esi
  801c94:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c97:	89 f3                	mov    %esi,%ebx
  801c99:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801c9c:	89 f2                	mov    %esi,%edx
  801c9e:	eb 0f                	jmp    801caf <strncpy+0x23>
		*dst++ = *src;
  801ca0:	83 c2 01             	add    $0x1,%edx
  801ca3:	0f b6 01             	movzbl (%ecx),%eax
  801ca6:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801ca9:	80 39 01             	cmpb   $0x1,(%ecx)
  801cac:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  801caf:	39 da                	cmp    %ebx,%edx
  801cb1:	75 ed                	jne    801ca0 <strncpy+0x14>
	}
	return ret;
}
  801cb3:	89 f0                	mov    %esi,%eax
  801cb5:	5b                   	pop    %ebx
  801cb6:	5e                   	pop    %esi
  801cb7:	5d                   	pop    %ebp
  801cb8:	c3                   	ret    

00801cb9 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801cb9:	55                   	push   %ebp
  801cba:	89 e5                	mov    %esp,%ebp
  801cbc:	56                   	push   %esi
  801cbd:	53                   	push   %ebx
  801cbe:	8b 75 08             	mov    0x8(%ebp),%esi
  801cc1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cc4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cc7:	89 f0                	mov    %esi,%eax
  801cc9:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801ccd:	85 c9                	test   %ecx,%ecx
  801ccf:	75 0b                	jne    801cdc <strlcpy+0x23>
  801cd1:	eb 17                	jmp    801cea <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  801cd3:	83 c2 01             	add    $0x1,%edx
  801cd6:	83 c0 01             	add    $0x1,%eax
  801cd9:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  801cdc:	39 d8                	cmp    %ebx,%eax
  801cde:	74 07                	je     801ce7 <strlcpy+0x2e>
  801ce0:	0f b6 0a             	movzbl (%edx),%ecx
  801ce3:	84 c9                	test   %cl,%cl
  801ce5:	75 ec                	jne    801cd3 <strlcpy+0x1a>
		*dst = '\0';
  801ce7:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801cea:	29 f0                	sub    %esi,%eax
}
  801cec:	5b                   	pop    %ebx
  801ced:	5e                   	pop    %esi
  801cee:	5d                   	pop    %ebp
  801cef:	c3                   	ret    

00801cf0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801cf0:	55                   	push   %ebp
  801cf1:	89 e5                	mov    %esp,%ebp
  801cf3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cf6:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801cf9:	eb 06                	jmp    801d01 <strcmp+0x11>
		p++, q++;
  801cfb:	83 c1 01             	add    $0x1,%ecx
  801cfe:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  801d01:	0f b6 01             	movzbl (%ecx),%eax
  801d04:	84 c0                	test   %al,%al
  801d06:	74 04                	je     801d0c <strcmp+0x1c>
  801d08:	3a 02                	cmp    (%edx),%al
  801d0a:	74 ef                	je     801cfb <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801d0c:	0f b6 c0             	movzbl %al,%eax
  801d0f:	0f b6 12             	movzbl (%edx),%edx
  801d12:	29 d0                	sub    %edx,%eax
}
  801d14:	5d                   	pop    %ebp
  801d15:	c3                   	ret    

00801d16 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801d16:	55                   	push   %ebp
  801d17:	89 e5                	mov    %esp,%ebp
  801d19:	53                   	push   %ebx
  801d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d20:	89 c3                	mov    %eax,%ebx
  801d22:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  801d25:	eb 06                	jmp    801d2d <strncmp+0x17>
		n--, p++, q++;
  801d27:	83 c0 01             	add    $0x1,%eax
  801d2a:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  801d2d:	39 d8                	cmp    %ebx,%eax
  801d2f:	74 16                	je     801d47 <strncmp+0x31>
  801d31:	0f b6 08             	movzbl (%eax),%ecx
  801d34:	84 c9                	test   %cl,%cl
  801d36:	74 04                	je     801d3c <strncmp+0x26>
  801d38:	3a 0a                	cmp    (%edx),%cl
  801d3a:	74 eb                	je     801d27 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801d3c:	0f b6 00             	movzbl (%eax),%eax
  801d3f:	0f b6 12             	movzbl (%edx),%edx
  801d42:	29 d0                	sub    %edx,%eax
}
  801d44:	5b                   	pop    %ebx
  801d45:	5d                   	pop    %ebp
  801d46:	c3                   	ret    
		return 0;
  801d47:	b8 00 00 00 00       	mov    $0x0,%eax
  801d4c:	eb f6                	jmp    801d44 <strncmp+0x2e>

00801d4e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801d4e:	55                   	push   %ebp
  801d4f:	89 e5                	mov    %esp,%ebp
  801d51:	8b 45 08             	mov    0x8(%ebp),%eax
  801d54:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801d58:	0f b6 10             	movzbl (%eax),%edx
  801d5b:	84 d2                	test   %dl,%dl
  801d5d:	74 09                	je     801d68 <strchr+0x1a>
		if (*s == c)
  801d5f:	38 ca                	cmp    %cl,%dl
  801d61:	74 0a                	je     801d6d <strchr+0x1f>
	for (; *s; s++)
  801d63:	83 c0 01             	add    $0x1,%eax
  801d66:	eb f0                	jmp    801d58 <strchr+0xa>
			return (char *) s;
	return 0;
  801d68:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d6d:	5d                   	pop    %ebp
  801d6e:	c3                   	ret    

00801d6f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801d6f:	55                   	push   %ebp
  801d70:	89 e5                	mov    %esp,%ebp
  801d72:	8b 45 08             	mov    0x8(%ebp),%eax
  801d75:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801d79:	eb 03                	jmp    801d7e <strfind+0xf>
  801d7b:	83 c0 01             	add    $0x1,%eax
  801d7e:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  801d81:	38 ca                	cmp    %cl,%dl
  801d83:	74 04                	je     801d89 <strfind+0x1a>
  801d85:	84 d2                	test   %dl,%dl
  801d87:	75 f2                	jne    801d7b <strfind+0xc>
			break;
	return (char *) s;
}
  801d89:	5d                   	pop    %ebp
  801d8a:	c3                   	ret    

00801d8b <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801d8b:	55                   	push   %ebp
  801d8c:	89 e5                	mov    %esp,%ebp
  801d8e:	57                   	push   %edi
  801d8f:	56                   	push   %esi
  801d90:	53                   	push   %ebx
  801d91:	8b 7d 08             	mov    0x8(%ebp),%edi
  801d94:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801d97:	85 c9                	test   %ecx,%ecx
  801d99:	74 13                	je     801dae <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801d9b:	f7 c7 03 00 00 00    	test   $0x3,%edi
  801da1:	75 05                	jne    801da8 <memset+0x1d>
  801da3:	f6 c1 03             	test   $0x3,%cl
  801da6:	74 0d                	je     801db5 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801da8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dab:	fc                   	cld    
  801dac:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801dae:	89 f8                	mov    %edi,%eax
  801db0:	5b                   	pop    %ebx
  801db1:	5e                   	pop    %esi
  801db2:	5f                   	pop    %edi
  801db3:	5d                   	pop    %ebp
  801db4:	c3                   	ret    
		c &= 0xFF;
  801db5:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801db9:	89 d3                	mov    %edx,%ebx
  801dbb:	c1 e3 08             	shl    $0x8,%ebx
  801dbe:	89 d0                	mov    %edx,%eax
  801dc0:	c1 e0 18             	shl    $0x18,%eax
  801dc3:	89 d6                	mov    %edx,%esi
  801dc5:	c1 e6 10             	shl    $0x10,%esi
  801dc8:	09 f0                	or     %esi,%eax
  801dca:	09 c2                	or     %eax,%edx
  801dcc:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  801dce:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  801dd1:	89 d0                	mov    %edx,%eax
  801dd3:	fc                   	cld    
  801dd4:	f3 ab                	rep stos %eax,%es:(%edi)
  801dd6:	eb d6                	jmp    801dae <memset+0x23>

00801dd8 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801dd8:	55                   	push   %ebp
  801dd9:	89 e5                	mov    %esp,%ebp
  801ddb:	57                   	push   %edi
  801ddc:	56                   	push   %esi
  801ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  801de0:	8b 75 0c             	mov    0xc(%ebp),%esi
  801de3:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801de6:	39 c6                	cmp    %eax,%esi
  801de8:	73 35                	jae    801e1f <memmove+0x47>
  801dea:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801ded:	39 c2                	cmp    %eax,%edx
  801def:	76 2e                	jbe    801e1f <memmove+0x47>
		s += n;
		d += n;
  801df1:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801df4:	89 d6                	mov    %edx,%esi
  801df6:	09 fe                	or     %edi,%esi
  801df8:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801dfe:	74 0c                	je     801e0c <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801e00:	83 ef 01             	sub    $0x1,%edi
  801e03:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  801e06:	fd                   	std    
  801e07:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801e09:	fc                   	cld    
  801e0a:	eb 21                	jmp    801e2d <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801e0c:	f6 c1 03             	test   $0x3,%cl
  801e0f:	75 ef                	jne    801e00 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801e11:	83 ef 04             	sub    $0x4,%edi
  801e14:	8d 72 fc             	lea    -0x4(%edx),%esi
  801e17:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  801e1a:	fd                   	std    
  801e1b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801e1d:	eb ea                	jmp    801e09 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801e1f:	89 f2                	mov    %esi,%edx
  801e21:	09 c2                	or     %eax,%edx
  801e23:	f6 c2 03             	test   $0x3,%dl
  801e26:	74 09                	je     801e31 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801e28:	89 c7                	mov    %eax,%edi
  801e2a:	fc                   	cld    
  801e2b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801e2d:	5e                   	pop    %esi
  801e2e:	5f                   	pop    %edi
  801e2f:	5d                   	pop    %ebp
  801e30:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801e31:	f6 c1 03             	test   $0x3,%cl
  801e34:	75 f2                	jne    801e28 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801e36:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  801e39:	89 c7                	mov    %eax,%edi
  801e3b:	fc                   	cld    
  801e3c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801e3e:	eb ed                	jmp    801e2d <memmove+0x55>

00801e40 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801e40:	55                   	push   %ebp
  801e41:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  801e43:	ff 75 10             	pushl  0x10(%ebp)
  801e46:	ff 75 0c             	pushl  0xc(%ebp)
  801e49:	ff 75 08             	pushl  0x8(%ebp)
  801e4c:	e8 87 ff ff ff       	call   801dd8 <memmove>
}
  801e51:	c9                   	leave  
  801e52:	c3                   	ret    

00801e53 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801e53:	55                   	push   %ebp
  801e54:	89 e5                	mov    %esp,%ebp
  801e56:	56                   	push   %esi
  801e57:	53                   	push   %ebx
  801e58:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e5e:	89 c6                	mov    %eax,%esi
  801e60:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801e63:	39 f0                	cmp    %esi,%eax
  801e65:	74 1c                	je     801e83 <memcmp+0x30>
		if (*s1 != *s2)
  801e67:	0f b6 08             	movzbl (%eax),%ecx
  801e6a:	0f b6 1a             	movzbl (%edx),%ebx
  801e6d:	38 d9                	cmp    %bl,%cl
  801e6f:	75 08                	jne    801e79 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801e71:	83 c0 01             	add    $0x1,%eax
  801e74:	83 c2 01             	add    $0x1,%edx
  801e77:	eb ea                	jmp    801e63 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  801e79:	0f b6 c1             	movzbl %cl,%eax
  801e7c:	0f b6 db             	movzbl %bl,%ebx
  801e7f:	29 d8                	sub    %ebx,%eax
  801e81:	eb 05                	jmp    801e88 <memcmp+0x35>
	}

	return 0;
  801e83:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e88:	5b                   	pop    %ebx
  801e89:	5e                   	pop    %esi
  801e8a:	5d                   	pop    %ebp
  801e8b:	c3                   	ret    

00801e8c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801e8c:	55                   	push   %ebp
  801e8d:	89 e5                	mov    %esp,%ebp
  801e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e92:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801e95:	89 c2                	mov    %eax,%edx
  801e97:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801e9a:	39 d0                	cmp    %edx,%eax
  801e9c:	73 09                	jae    801ea7 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  801e9e:	38 08                	cmp    %cl,(%eax)
  801ea0:	74 05                	je     801ea7 <memfind+0x1b>
	for (; s < ends; s++)
  801ea2:	83 c0 01             	add    $0x1,%eax
  801ea5:	eb f3                	jmp    801e9a <memfind+0xe>
			break;
	return (void *) s;
}
  801ea7:	5d                   	pop    %ebp
  801ea8:	c3                   	ret    

00801ea9 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801ea9:	55                   	push   %ebp
  801eaa:	89 e5                	mov    %esp,%ebp
  801eac:	57                   	push   %edi
  801ead:	56                   	push   %esi
  801eae:	53                   	push   %ebx
  801eaf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801eb2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801eb5:	eb 03                	jmp    801eba <strtol+0x11>
		s++;
  801eb7:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  801eba:	0f b6 01             	movzbl (%ecx),%eax
  801ebd:	3c 20                	cmp    $0x20,%al
  801ebf:	74 f6                	je     801eb7 <strtol+0xe>
  801ec1:	3c 09                	cmp    $0x9,%al
  801ec3:	74 f2                	je     801eb7 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  801ec5:	3c 2b                	cmp    $0x2b,%al
  801ec7:	74 2e                	je     801ef7 <strtol+0x4e>
	int neg = 0;
  801ec9:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801ece:	3c 2d                	cmp    $0x2d,%al
  801ed0:	74 2f                	je     801f01 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801ed2:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  801ed8:	75 05                	jne    801edf <strtol+0x36>
  801eda:	80 39 30             	cmpb   $0x30,(%ecx)
  801edd:	74 2c                	je     801f0b <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  801edf:	85 db                	test   %ebx,%ebx
  801ee1:	75 0a                	jne    801eed <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801ee3:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  801ee8:	80 39 30             	cmpb   $0x30,(%ecx)
  801eeb:	74 28                	je     801f15 <strtol+0x6c>
		base = 10;
  801eed:	b8 00 00 00 00       	mov    $0x0,%eax
  801ef2:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801ef5:	eb 50                	jmp    801f47 <strtol+0x9e>
		s++;
  801ef7:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  801efa:	bf 00 00 00 00       	mov    $0x0,%edi
  801eff:	eb d1                	jmp    801ed2 <strtol+0x29>
		s++, neg = 1;
  801f01:	83 c1 01             	add    $0x1,%ecx
  801f04:	bf 01 00 00 00       	mov    $0x1,%edi
  801f09:	eb c7                	jmp    801ed2 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801f0b:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801f0f:	74 0e                	je     801f1f <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  801f11:	85 db                	test   %ebx,%ebx
  801f13:	75 d8                	jne    801eed <strtol+0x44>
		s++, base = 8;
  801f15:	83 c1 01             	add    $0x1,%ecx
  801f18:	bb 08 00 00 00       	mov    $0x8,%ebx
  801f1d:	eb ce                	jmp    801eed <strtol+0x44>
		s += 2, base = 16;
  801f1f:	83 c1 02             	add    $0x2,%ecx
  801f22:	bb 10 00 00 00       	mov    $0x10,%ebx
  801f27:	eb c4                	jmp    801eed <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  801f29:	8d 72 9f             	lea    -0x61(%edx),%esi
  801f2c:	89 f3                	mov    %esi,%ebx
  801f2e:	80 fb 19             	cmp    $0x19,%bl
  801f31:	77 29                	ja     801f5c <strtol+0xb3>
			dig = *s - 'a' + 10;
  801f33:	0f be d2             	movsbl %dl,%edx
  801f36:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801f39:	3b 55 10             	cmp    0x10(%ebp),%edx
  801f3c:	7d 30                	jge    801f6e <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  801f3e:	83 c1 01             	add    $0x1,%ecx
  801f41:	0f af 45 10          	imul   0x10(%ebp),%eax
  801f45:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801f47:	0f b6 11             	movzbl (%ecx),%edx
  801f4a:	8d 72 d0             	lea    -0x30(%edx),%esi
  801f4d:	89 f3                	mov    %esi,%ebx
  801f4f:	80 fb 09             	cmp    $0x9,%bl
  801f52:	77 d5                	ja     801f29 <strtol+0x80>
			dig = *s - '0';
  801f54:	0f be d2             	movsbl %dl,%edx
  801f57:	83 ea 30             	sub    $0x30,%edx
  801f5a:	eb dd                	jmp    801f39 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  801f5c:	8d 72 bf             	lea    -0x41(%edx),%esi
  801f5f:	89 f3                	mov    %esi,%ebx
  801f61:	80 fb 19             	cmp    $0x19,%bl
  801f64:	77 08                	ja     801f6e <strtol+0xc5>
			dig = *s - 'A' + 10;
  801f66:	0f be d2             	movsbl %dl,%edx
  801f69:	83 ea 37             	sub    $0x37,%edx
  801f6c:	eb cb                	jmp    801f39 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  801f6e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801f72:	74 05                	je     801f79 <strtol+0xd0>
		*endptr = (char *) s;
  801f74:	8b 75 0c             	mov    0xc(%ebp),%esi
  801f77:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801f79:	89 c2                	mov    %eax,%edx
  801f7b:	f7 da                	neg    %edx
  801f7d:	85 ff                	test   %edi,%edi
  801f7f:	0f 45 c2             	cmovne %edx,%eax
}
  801f82:	5b                   	pop    %ebx
  801f83:	5e                   	pop    %esi
  801f84:	5f                   	pop    %edi
  801f85:	5d                   	pop    %ebp
  801f86:	c3                   	ret    

00801f87 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801f87:	55                   	push   %ebp
  801f88:	89 e5                	mov    %esp,%ebp
  801f8a:	56                   	push   %esi
  801f8b:	53                   	push   %ebx
  801f8c:	8b 75 08             	mov    0x8(%ebp),%esi
  801f8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f92:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
  801f95:	85 c0                	test   %eax,%eax
	    pg = (void *)UTOP;
  801f97:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801f9c:	0f 44 c2             	cmove  %edx,%eax
	}
	if ((r = sys_ipc_recv(pg)) < 0) {
  801f9f:	83 ec 0c             	sub    $0xc,%esp
  801fa2:	50                   	push   %eax
  801fa3:	e8 6b e3 ff ff       	call   800313 <sys_ipc_recv>
  801fa8:	83 c4 10             	add    $0x10,%esp
  801fab:	85 c0                	test   %eax,%eax
  801fad:	78 2b                	js     801fda <ipc_recv+0x53>
	    if (perm_store != NULL) {
	        *perm_store = 0;
	    }
	    return r;
	}
	if (from_env_store != NULL) {
  801faf:	85 f6                	test   %esi,%esi
  801fb1:	74 0a                	je     801fbd <ipc_recv+0x36>
	    *from_env_store = thisenv->env_ipc_from;
  801fb3:	a1 08 40 80 00       	mov    0x804008,%eax
  801fb8:	8b 40 74             	mov    0x74(%eax),%eax
  801fbb:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store != NULL) {
  801fbd:	85 db                	test   %ebx,%ebx
  801fbf:	74 0a                	je     801fcb <ipc_recv+0x44>
	    *perm_store = thisenv->env_ipc_perm;
  801fc1:	a1 08 40 80 00       	mov    0x804008,%eax
  801fc6:	8b 40 78             	mov    0x78(%eax),%eax
  801fc9:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  801fcb:	a1 08 40 80 00       	mov    0x804008,%eax
  801fd0:	8b 40 70             	mov    0x70(%eax),%eax
}
  801fd3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fd6:	5b                   	pop    %ebx
  801fd7:	5e                   	pop    %esi
  801fd8:	5d                   	pop    %ebp
  801fd9:	c3                   	ret    
	    if (from_env_store != NULL) {
  801fda:	85 f6                	test   %esi,%esi
  801fdc:	74 06                	je     801fe4 <ipc_recv+0x5d>
	        *from_env_store = 0;
  801fde:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	    if (perm_store != NULL) {
  801fe4:	85 db                	test   %ebx,%ebx
  801fe6:	74 eb                	je     801fd3 <ipc_recv+0x4c>
	        *perm_store = 0;
  801fe8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801fee:	eb e3                	jmp    801fd3 <ipc_recv+0x4c>

00801ff0 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801ff0:	55                   	push   %ebp
  801ff1:	89 e5                	mov    %esp,%ebp
  801ff3:	57                   	push   %edi
  801ff4:	56                   	push   %esi
  801ff5:	53                   	push   %ebx
  801ff6:	83 ec 0c             	sub    $0xc,%esp
  801ff9:	8b 7d 08             	mov    0x8(%ebp),%edi
  801ffc:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
	    pg = (void *)UTOP;
  801fff:	85 f6                	test   %esi,%esi
  802001:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802006:	0f 44 f0             	cmove  %eax,%esi
  802009:	eb 09                	jmp    802014 <ipc_send+0x24>
	do {
	    r = sys_ipc_try_send(to_env, val, pg, perm);
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
	        panic("ipc_send: %e", r);
	    }
	    sys_yield();
  80200b:	e8 34 e1 ff ff       	call   800144 <sys_yield>
	} while(r != 0);
  802010:	85 db                	test   %ebx,%ebx
  802012:	74 2d                	je     802041 <ipc_send+0x51>
	    r = sys_ipc_try_send(to_env, val, pg, perm);
  802014:	ff 75 14             	pushl  0x14(%ebp)
  802017:	56                   	push   %esi
  802018:	ff 75 0c             	pushl  0xc(%ebp)
  80201b:	57                   	push   %edi
  80201c:	e8 cf e2 ff ff       	call   8002f0 <sys_ipc_try_send>
  802021:	89 c3                	mov    %eax,%ebx
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
  802023:	83 c4 10             	add    $0x10,%esp
  802026:	85 c0                	test   %eax,%eax
  802028:	79 e1                	jns    80200b <ipc_send+0x1b>
  80202a:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80202d:	74 dc                	je     80200b <ipc_send+0x1b>
	        panic("ipc_send: %e", r);
  80202f:	50                   	push   %eax
  802030:	68 c0 27 80 00       	push   $0x8027c0
  802035:	6a 45                	push   $0x45
  802037:	68 cd 27 80 00       	push   $0x8027cd
  80203c:	e8 91 f4 ff ff       	call   8014d2 <_panic>
}
  802041:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802044:	5b                   	pop    %ebx
  802045:	5e                   	pop    %esi
  802046:	5f                   	pop    %edi
  802047:	5d                   	pop    %ebp
  802048:	c3                   	ret    

00802049 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802049:	55                   	push   %ebp
  80204a:	89 e5                	mov    %esp,%ebp
  80204c:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80204f:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802054:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802057:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80205d:	8b 52 50             	mov    0x50(%edx),%edx
  802060:	39 ca                	cmp    %ecx,%edx
  802062:	74 11                	je     802075 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  802064:	83 c0 01             	add    $0x1,%eax
  802067:	3d 00 04 00 00       	cmp    $0x400,%eax
  80206c:	75 e6                	jne    802054 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80206e:	b8 00 00 00 00       	mov    $0x0,%eax
  802073:	eb 0b                	jmp    802080 <ipc_find_env+0x37>
			return envs[i].env_id;
  802075:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802078:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80207d:	8b 40 48             	mov    0x48(%eax),%eax
}
  802080:	5d                   	pop    %ebp
  802081:	c3                   	ret    

00802082 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802082:	55                   	push   %ebp
  802083:	89 e5                	mov    %esp,%ebp
  802085:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802088:	89 d0                	mov    %edx,%eax
  80208a:	c1 e8 16             	shr    $0x16,%eax
  80208d:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802094:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802099:	f6 c1 01             	test   $0x1,%cl
  80209c:	74 1d                	je     8020bb <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80209e:	c1 ea 0c             	shr    $0xc,%edx
  8020a1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8020a8:	f6 c2 01             	test   $0x1,%dl
  8020ab:	74 0e                	je     8020bb <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8020ad:	c1 ea 0c             	shr    $0xc,%edx
  8020b0:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8020b7:	ef 
  8020b8:	0f b7 c0             	movzwl %ax,%eax
}
  8020bb:	5d                   	pop    %ebp
  8020bc:	c3                   	ret    
  8020bd:	66 90                	xchg   %ax,%ax
  8020bf:	90                   	nop

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
