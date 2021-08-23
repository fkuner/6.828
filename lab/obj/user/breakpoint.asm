
obj/user/breakpoint.debug:     file format elf32-i386


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
  80002c:	e8 08 00 00 00       	call   800039 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
	asm volatile("int $3");
  800036:	cc                   	int3   
}
  800037:	5d                   	pop    %ebp
  800038:	c3                   	ret    

00800039 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800039:	55                   	push   %ebp
  80003a:	89 e5                	mov    %esp,%ebp
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800041:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
    thisenv = &envs[ENVX(sys_getenvid())];
  800044:	e8 ce 00 00 00       	call   800117 <sys_getenvid>
  800049:	25 ff 03 00 00       	and    $0x3ff,%eax
  80004e:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800051:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800056:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80005b:	85 db                	test   %ebx,%ebx
  80005d:	7e 07                	jle    800066 <libmain+0x2d>
		binaryname = argv[0];
  80005f:	8b 06                	mov    (%esi),%eax
  800061:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800066:	83 ec 08             	sub    $0x8,%esp
  800069:	56                   	push   %esi
  80006a:	53                   	push   %ebx
  80006b:	e8 c3 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800070:	e8 0a 00 00 00       	call   80007f <exit>
}
  800075:	83 c4 10             	add    $0x10,%esp
  800078:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80007b:	5b                   	pop    %ebx
  80007c:	5e                   	pop    %esi
  80007d:	5d                   	pop    %ebp
  80007e:	c3                   	ret    

0080007f <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80007f:	55                   	push   %ebp
  800080:	89 e5                	mov    %esp,%ebp
  800082:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800085:	e8 b1 04 00 00       	call   80053b <close_all>
	sys_env_destroy(0);
  80008a:	83 ec 0c             	sub    $0xc,%esp
  80008d:	6a 00                	push   $0x0
  80008f:	e8 42 00 00 00       	call   8000d6 <sys_env_destroy>
}
  800094:	83 c4 10             	add    $0x10,%esp
  800097:	c9                   	leave  
  800098:	c3                   	ret    

00800099 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800099:	55                   	push   %ebp
  80009a:	89 e5                	mov    %esp,%ebp
  80009c:	57                   	push   %edi
  80009d:	56                   	push   %esi
  80009e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80009f:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a4:	8b 55 08             	mov    0x8(%ebp),%edx
  8000a7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000aa:	89 c3                	mov    %eax,%ebx
  8000ac:	89 c7                	mov    %eax,%edi
  8000ae:	89 c6                	mov    %eax,%esi
  8000b0:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000b2:	5b                   	pop    %ebx
  8000b3:	5e                   	pop    %esi
  8000b4:	5f                   	pop    %edi
  8000b5:	5d                   	pop    %ebp
  8000b6:	c3                   	ret    

008000b7 <sys_cgetc>:

int
sys_cgetc(void)
{
  8000b7:	55                   	push   %ebp
  8000b8:	89 e5                	mov    %esp,%ebp
  8000ba:	57                   	push   %edi
  8000bb:	56                   	push   %esi
  8000bc:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000bd:	ba 00 00 00 00       	mov    $0x0,%edx
  8000c2:	b8 01 00 00 00       	mov    $0x1,%eax
  8000c7:	89 d1                	mov    %edx,%ecx
  8000c9:	89 d3                	mov    %edx,%ebx
  8000cb:	89 d7                	mov    %edx,%edi
  8000cd:	89 d6                	mov    %edx,%esi
  8000cf:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000d1:	5b                   	pop    %ebx
  8000d2:	5e                   	pop    %esi
  8000d3:	5f                   	pop    %edi
  8000d4:	5d                   	pop    %ebp
  8000d5:	c3                   	ret    

008000d6 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000d6:	55                   	push   %ebp
  8000d7:	89 e5                	mov    %esp,%ebp
  8000d9:	57                   	push   %edi
  8000da:	56                   	push   %esi
  8000db:	53                   	push   %ebx
  8000dc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8000df:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8000e7:	b8 03 00 00 00       	mov    $0x3,%eax
  8000ec:	89 cb                	mov    %ecx,%ebx
  8000ee:	89 cf                	mov    %ecx,%edi
  8000f0:	89 ce                	mov    %ecx,%esi
  8000f2:	cd 30                	int    $0x30
	if(check && ret > 0)
  8000f4:	85 c0                	test   %eax,%eax
  8000f6:	7f 08                	jg     800100 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8000f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000fb:	5b                   	pop    %ebx
  8000fc:	5e                   	pop    %esi
  8000fd:	5f                   	pop    %edi
  8000fe:	5d                   	pop    %ebp
  8000ff:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800100:	83 ec 0c             	sub    $0xc,%esp
  800103:	50                   	push   %eax
  800104:	6a 03                	push   $0x3
  800106:	68 0a 23 80 00       	push   $0x80230a
  80010b:	6a 23                	push   $0x23
  80010d:	68 27 23 80 00       	push   $0x802327
  800112:	e8 ad 13 00 00       	call   8014c4 <_panic>

00800117 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800117:	55                   	push   %ebp
  800118:	89 e5                	mov    %esp,%ebp
  80011a:	57                   	push   %edi
  80011b:	56                   	push   %esi
  80011c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80011d:	ba 00 00 00 00       	mov    $0x0,%edx
  800122:	b8 02 00 00 00       	mov    $0x2,%eax
  800127:	89 d1                	mov    %edx,%ecx
  800129:	89 d3                	mov    %edx,%ebx
  80012b:	89 d7                	mov    %edx,%edi
  80012d:	89 d6                	mov    %edx,%esi
  80012f:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800131:	5b                   	pop    %ebx
  800132:	5e                   	pop    %esi
  800133:	5f                   	pop    %edi
  800134:	5d                   	pop    %ebp
  800135:	c3                   	ret    

00800136 <sys_yield>:

void
sys_yield(void)
{
  800136:	55                   	push   %ebp
  800137:	89 e5                	mov    %esp,%ebp
  800139:	57                   	push   %edi
  80013a:	56                   	push   %esi
  80013b:	53                   	push   %ebx
	asm volatile("int %1\n"
  80013c:	ba 00 00 00 00       	mov    $0x0,%edx
  800141:	b8 0b 00 00 00       	mov    $0xb,%eax
  800146:	89 d1                	mov    %edx,%ecx
  800148:	89 d3                	mov    %edx,%ebx
  80014a:	89 d7                	mov    %edx,%edi
  80014c:	89 d6                	mov    %edx,%esi
  80014e:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800150:	5b                   	pop    %ebx
  800151:	5e                   	pop    %esi
  800152:	5f                   	pop    %edi
  800153:	5d                   	pop    %ebp
  800154:	c3                   	ret    

00800155 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800155:	55                   	push   %ebp
  800156:	89 e5                	mov    %esp,%ebp
  800158:	57                   	push   %edi
  800159:	56                   	push   %esi
  80015a:	53                   	push   %ebx
  80015b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80015e:	be 00 00 00 00       	mov    $0x0,%esi
  800163:	8b 55 08             	mov    0x8(%ebp),%edx
  800166:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800169:	b8 04 00 00 00       	mov    $0x4,%eax
  80016e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800171:	89 f7                	mov    %esi,%edi
  800173:	cd 30                	int    $0x30
	if(check && ret > 0)
  800175:	85 c0                	test   %eax,%eax
  800177:	7f 08                	jg     800181 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800179:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80017c:	5b                   	pop    %ebx
  80017d:	5e                   	pop    %esi
  80017e:	5f                   	pop    %edi
  80017f:	5d                   	pop    %ebp
  800180:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800181:	83 ec 0c             	sub    $0xc,%esp
  800184:	50                   	push   %eax
  800185:	6a 04                	push   $0x4
  800187:	68 0a 23 80 00       	push   $0x80230a
  80018c:	6a 23                	push   $0x23
  80018e:	68 27 23 80 00       	push   $0x802327
  800193:	e8 2c 13 00 00       	call   8014c4 <_panic>

00800198 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800198:	55                   	push   %ebp
  800199:	89 e5                	mov    %esp,%ebp
  80019b:	57                   	push   %edi
  80019c:	56                   	push   %esi
  80019d:	53                   	push   %ebx
  80019e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8001a4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001a7:	b8 05 00 00 00       	mov    $0x5,%eax
  8001ac:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001af:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001b2:	8b 75 18             	mov    0x18(%ebp),%esi
  8001b5:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001b7:	85 c0                	test   %eax,%eax
  8001b9:	7f 08                	jg     8001c3 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001be:	5b                   	pop    %ebx
  8001bf:	5e                   	pop    %esi
  8001c0:	5f                   	pop    %edi
  8001c1:	5d                   	pop    %ebp
  8001c2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001c3:	83 ec 0c             	sub    $0xc,%esp
  8001c6:	50                   	push   %eax
  8001c7:	6a 05                	push   $0x5
  8001c9:	68 0a 23 80 00       	push   $0x80230a
  8001ce:	6a 23                	push   $0x23
  8001d0:	68 27 23 80 00       	push   $0x802327
  8001d5:	e8 ea 12 00 00       	call   8014c4 <_panic>

008001da <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001da:	55                   	push   %ebp
  8001db:	89 e5                	mov    %esp,%ebp
  8001dd:	57                   	push   %edi
  8001de:	56                   	push   %esi
  8001df:	53                   	push   %ebx
  8001e0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001e3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8001eb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001ee:	b8 06 00 00 00       	mov    $0x6,%eax
  8001f3:	89 df                	mov    %ebx,%edi
  8001f5:	89 de                	mov    %ebx,%esi
  8001f7:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001f9:	85 c0                	test   %eax,%eax
  8001fb:	7f 08                	jg     800205 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8001fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800200:	5b                   	pop    %ebx
  800201:	5e                   	pop    %esi
  800202:	5f                   	pop    %edi
  800203:	5d                   	pop    %ebp
  800204:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800205:	83 ec 0c             	sub    $0xc,%esp
  800208:	50                   	push   %eax
  800209:	6a 06                	push   $0x6
  80020b:	68 0a 23 80 00       	push   $0x80230a
  800210:	6a 23                	push   $0x23
  800212:	68 27 23 80 00       	push   $0x802327
  800217:	e8 a8 12 00 00       	call   8014c4 <_panic>

0080021c <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80021c:	55                   	push   %ebp
  80021d:	89 e5                	mov    %esp,%ebp
  80021f:	57                   	push   %edi
  800220:	56                   	push   %esi
  800221:	53                   	push   %ebx
  800222:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800225:	bb 00 00 00 00       	mov    $0x0,%ebx
  80022a:	8b 55 08             	mov    0x8(%ebp),%edx
  80022d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800230:	b8 08 00 00 00       	mov    $0x8,%eax
  800235:	89 df                	mov    %ebx,%edi
  800237:	89 de                	mov    %ebx,%esi
  800239:	cd 30                	int    $0x30
	if(check && ret > 0)
  80023b:	85 c0                	test   %eax,%eax
  80023d:	7f 08                	jg     800247 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80023f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800242:	5b                   	pop    %ebx
  800243:	5e                   	pop    %esi
  800244:	5f                   	pop    %edi
  800245:	5d                   	pop    %ebp
  800246:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800247:	83 ec 0c             	sub    $0xc,%esp
  80024a:	50                   	push   %eax
  80024b:	6a 08                	push   $0x8
  80024d:	68 0a 23 80 00       	push   $0x80230a
  800252:	6a 23                	push   $0x23
  800254:	68 27 23 80 00       	push   $0x802327
  800259:	e8 66 12 00 00       	call   8014c4 <_panic>

0080025e <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80025e:	55                   	push   %ebp
  80025f:	89 e5                	mov    %esp,%ebp
  800261:	57                   	push   %edi
  800262:	56                   	push   %esi
  800263:	53                   	push   %ebx
  800264:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800267:	bb 00 00 00 00       	mov    $0x0,%ebx
  80026c:	8b 55 08             	mov    0x8(%ebp),%edx
  80026f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800272:	b8 09 00 00 00       	mov    $0x9,%eax
  800277:	89 df                	mov    %ebx,%edi
  800279:	89 de                	mov    %ebx,%esi
  80027b:	cd 30                	int    $0x30
	if(check && ret > 0)
  80027d:	85 c0                	test   %eax,%eax
  80027f:	7f 08                	jg     800289 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800281:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800284:	5b                   	pop    %ebx
  800285:	5e                   	pop    %esi
  800286:	5f                   	pop    %edi
  800287:	5d                   	pop    %ebp
  800288:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800289:	83 ec 0c             	sub    $0xc,%esp
  80028c:	50                   	push   %eax
  80028d:	6a 09                	push   $0x9
  80028f:	68 0a 23 80 00       	push   $0x80230a
  800294:	6a 23                	push   $0x23
  800296:	68 27 23 80 00       	push   $0x802327
  80029b:	e8 24 12 00 00       	call   8014c4 <_panic>

008002a0 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002a0:	55                   	push   %ebp
  8002a1:	89 e5                	mov    %esp,%ebp
  8002a3:	57                   	push   %edi
  8002a4:	56                   	push   %esi
  8002a5:	53                   	push   %ebx
  8002a6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002a9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8002b1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002b4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002b9:	89 df                	mov    %ebx,%edi
  8002bb:	89 de                	mov    %ebx,%esi
  8002bd:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002bf:	85 c0                	test   %eax,%eax
  8002c1:	7f 08                	jg     8002cb <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8002c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002c6:	5b                   	pop    %ebx
  8002c7:	5e                   	pop    %esi
  8002c8:	5f                   	pop    %edi
  8002c9:	5d                   	pop    %ebp
  8002ca:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002cb:	83 ec 0c             	sub    $0xc,%esp
  8002ce:	50                   	push   %eax
  8002cf:	6a 0a                	push   $0xa
  8002d1:	68 0a 23 80 00       	push   $0x80230a
  8002d6:	6a 23                	push   $0x23
  8002d8:	68 27 23 80 00       	push   $0x802327
  8002dd:	e8 e2 11 00 00       	call   8014c4 <_panic>

008002e2 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8002e2:	55                   	push   %ebp
  8002e3:	89 e5                	mov    %esp,%ebp
  8002e5:	57                   	push   %edi
  8002e6:	56                   	push   %esi
  8002e7:	53                   	push   %ebx
	asm volatile("int %1\n"
  8002e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8002eb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002ee:	b8 0c 00 00 00       	mov    $0xc,%eax
  8002f3:	be 00 00 00 00       	mov    $0x0,%esi
  8002f8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8002fb:	8b 7d 14             	mov    0x14(%ebp),%edi
  8002fe:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800300:	5b                   	pop    %ebx
  800301:	5e                   	pop    %esi
  800302:	5f                   	pop    %edi
  800303:	5d                   	pop    %ebp
  800304:	c3                   	ret    

00800305 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800305:	55                   	push   %ebp
  800306:	89 e5                	mov    %esp,%ebp
  800308:	57                   	push   %edi
  800309:	56                   	push   %esi
  80030a:	53                   	push   %ebx
  80030b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80030e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800313:	8b 55 08             	mov    0x8(%ebp),%edx
  800316:	b8 0d 00 00 00       	mov    $0xd,%eax
  80031b:	89 cb                	mov    %ecx,%ebx
  80031d:	89 cf                	mov    %ecx,%edi
  80031f:	89 ce                	mov    %ecx,%esi
  800321:	cd 30                	int    $0x30
	if(check && ret > 0)
  800323:	85 c0                	test   %eax,%eax
  800325:	7f 08                	jg     80032f <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800327:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80032a:	5b                   	pop    %ebx
  80032b:	5e                   	pop    %esi
  80032c:	5f                   	pop    %edi
  80032d:	5d                   	pop    %ebp
  80032e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80032f:	83 ec 0c             	sub    $0xc,%esp
  800332:	50                   	push   %eax
  800333:	6a 0d                	push   $0xd
  800335:	68 0a 23 80 00       	push   $0x80230a
  80033a:	6a 23                	push   $0x23
  80033c:	68 27 23 80 00       	push   $0x802327
  800341:	e8 7e 11 00 00       	call   8014c4 <_panic>

00800346 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800346:	55                   	push   %ebp
  800347:	89 e5                	mov    %esp,%ebp
  800349:	57                   	push   %edi
  80034a:	56                   	push   %esi
  80034b:	53                   	push   %ebx
	asm volatile("int %1\n"
  80034c:	ba 00 00 00 00       	mov    $0x0,%edx
  800351:	b8 0e 00 00 00       	mov    $0xe,%eax
  800356:	89 d1                	mov    %edx,%ecx
  800358:	89 d3                	mov    %edx,%ebx
  80035a:	89 d7                	mov    %edx,%edi
  80035c:	89 d6                	mov    %edx,%esi
  80035e:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800360:	5b                   	pop    %ebx
  800361:	5e                   	pop    %esi
  800362:	5f                   	pop    %edi
  800363:	5d                   	pop    %ebp
  800364:	c3                   	ret    

00800365 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800365:	55                   	push   %ebp
  800366:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800368:	8b 45 08             	mov    0x8(%ebp),%eax
  80036b:	05 00 00 00 30       	add    $0x30000000,%eax
  800370:	c1 e8 0c             	shr    $0xc,%eax
}
  800373:	5d                   	pop    %ebp
  800374:	c3                   	ret    

00800375 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800375:	55                   	push   %ebp
  800376:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800378:	8b 45 08             	mov    0x8(%ebp),%eax
  80037b:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800380:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800385:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80038a:	5d                   	pop    %ebp
  80038b:	c3                   	ret    

0080038c <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80038c:	55                   	push   %ebp
  80038d:	89 e5                	mov    %esp,%ebp
  80038f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800392:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800397:	89 c2                	mov    %eax,%edx
  800399:	c1 ea 16             	shr    $0x16,%edx
  80039c:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8003a3:	f6 c2 01             	test   $0x1,%dl
  8003a6:	74 2a                	je     8003d2 <fd_alloc+0x46>
  8003a8:	89 c2                	mov    %eax,%edx
  8003aa:	c1 ea 0c             	shr    $0xc,%edx
  8003ad:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8003b4:	f6 c2 01             	test   $0x1,%dl
  8003b7:	74 19                	je     8003d2 <fd_alloc+0x46>
  8003b9:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8003be:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8003c3:	75 d2                	jne    800397 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8003c5:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8003cb:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8003d0:	eb 07                	jmp    8003d9 <fd_alloc+0x4d>
			*fd_store = fd;
  8003d2:	89 01                	mov    %eax,(%ecx)
			return 0;
  8003d4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8003d9:	5d                   	pop    %ebp
  8003da:	c3                   	ret    

008003db <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8003db:	55                   	push   %ebp
  8003dc:	89 e5                	mov    %esp,%ebp
  8003de:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8003e1:	83 f8 1f             	cmp    $0x1f,%eax
  8003e4:	77 36                	ja     80041c <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8003e6:	c1 e0 0c             	shl    $0xc,%eax
  8003e9:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8003ee:	89 c2                	mov    %eax,%edx
  8003f0:	c1 ea 16             	shr    $0x16,%edx
  8003f3:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8003fa:	f6 c2 01             	test   $0x1,%dl
  8003fd:	74 24                	je     800423 <fd_lookup+0x48>
  8003ff:	89 c2                	mov    %eax,%edx
  800401:	c1 ea 0c             	shr    $0xc,%edx
  800404:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80040b:	f6 c2 01             	test   $0x1,%dl
  80040e:	74 1a                	je     80042a <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800410:	8b 55 0c             	mov    0xc(%ebp),%edx
  800413:	89 02                	mov    %eax,(%edx)
	return 0;
  800415:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80041a:	5d                   	pop    %ebp
  80041b:	c3                   	ret    
		return -E_INVAL;
  80041c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800421:	eb f7                	jmp    80041a <fd_lookup+0x3f>
		return -E_INVAL;
  800423:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800428:	eb f0                	jmp    80041a <fd_lookup+0x3f>
  80042a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80042f:	eb e9                	jmp    80041a <fd_lookup+0x3f>

00800431 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800431:	55                   	push   %ebp
  800432:	89 e5                	mov    %esp,%ebp
  800434:	83 ec 08             	sub    $0x8,%esp
  800437:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80043a:	ba b4 23 80 00       	mov    $0x8023b4,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  80043f:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800444:	39 08                	cmp    %ecx,(%eax)
  800446:	74 33                	je     80047b <dev_lookup+0x4a>
  800448:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  80044b:	8b 02                	mov    (%edx),%eax
  80044d:	85 c0                	test   %eax,%eax
  80044f:	75 f3                	jne    800444 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800451:	a1 08 40 80 00       	mov    0x804008,%eax
  800456:	8b 40 48             	mov    0x48(%eax),%eax
  800459:	83 ec 04             	sub    $0x4,%esp
  80045c:	51                   	push   %ecx
  80045d:	50                   	push   %eax
  80045e:	68 38 23 80 00       	push   $0x802338
  800463:	e8 37 11 00 00       	call   80159f <cprintf>
	*dev = 0;
  800468:	8b 45 0c             	mov    0xc(%ebp),%eax
  80046b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800471:	83 c4 10             	add    $0x10,%esp
  800474:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800479:	c9                   	leave  
  80047a:	c3                   	ret    
			*dev = devtab[i];
  80047b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80047e:	89 01                	mov    %eax,(%ecx)
			return 0;
  800480:	b8 00 00 00 00       	mov    $0x0,%eax
  800485:	eb f2                	jmp    800479 <dev_lookup+0x48>

00800487 <fd_close>:
{
  800487:	55                   	push   %ebp
  800488:	89 e5                	mov    %esp,%ebp
  80048a:	57                   	push   %edi
  80048b:	56                   	push   %esi
  80048c:	53                   	push   %ebx
  80048d:	83 ec 1c             	sub    $0x1c,%esp
  800490:	8b 75 08             	mov    0x8(%ebp),%esi
  800493:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800496:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800499:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80049a:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8004a0:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8004a3:	50                   	push   %eax
  8004a4:	e8 32 ff ff ff       	call   8003db <fd_lookup>
  8004a9:	89 c3                	mov    %eax,%ebx
  8004ab:	83 c4 08             	add    $0x8,%esp
  8004ae:	85 c0                	test   %eax,%eax
  8004b0:	78 05                	js     8004b7 <fd_close+0x30>
	    || fd != fd2)
  8004b2:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8004b5:	74 16                	je     8004cd <fd_close+0x46>
		return (must_exist ? r : 0);
  8004b7:	89 f8                	mov    %edi,%eax
  8004b9:	84 c0                	test   %al,%al
  8004bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8004c0:	0f 44 d8             	cmove  %eax,%ebx
}
  8004c3:	89 d8                	mov    %ebx,%eax
  8004c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004c8:	5b                   	pop    %ebx
  8004c9:	5e                   	pop    %esi
  8004ca:	5f                   	pop    %edi
  8004cb:	5d                   	pop    %ebp
  8004cc:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8004cd:	83 ec 08             	sub    $0x8,%esp
  8004d0:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8004d3:	50                   	push   %eax
  8004d4:	ff 36                	pushl  (%esi)
  8004d6:	e8 56 ff ff ff       	call   800431 <dev_lookup>
  8004db:	89 c3                	mov    %eax,%ebx
  8004dd:	83 c4 10             	add    $0x10,%esp
  8004e0:	85 c0                	test   %eax,%eax
  8004e2:	78 15                	js     8004f9 <fd_close+0x72>
		if (dev->dev_close)
  8004e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004e7:	8b 40 10             	mov    0x10(%eax),%eax
  8004ea:	85 c0                	test   %eax,%eax
  8004ec:	74 1b                	je     800509 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  8004ee:	83 ec 0c             	sub    $0xc,%esp
  8004f1:	56                   	push   %esi
  8004f2:	ff d0                	call   *%eax
  8004f4:	89 c3                	mov    %eax,%ebx
  8004f6:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8004f9:	83 ec 08             	sub    $0x8,%esp
  8004fc:	56                   	push   %esi
  8004fd:	6a 00                	push   $0x0
  8004ff:	e8 d6 fc ff ff       	call   8001da <sys_page_unmap>
	return r;
  800504:	83 c4 10             	add    $0x10,%esp
  800507:	eb ba                	jmp    8004c3 <fd_close+0x3c>
			r = 0;
  800509:	bb 00 00 00 00       	mov    $0x0,%ebx
  80050e:	eb e9                	jmp    8004f9 <fd_close+0x72>

00800510 <close>:

int
close(int fdnum)
{
  800510:	55                   	push   %ebp
  800511:	89 e5                	mov    %esp,%ebp
  800513:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800516:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800519:	50                   	push   %eax
  80051a:	ff 75 08             	pushl  0x8(%ebp)
  80051d:	e8 b9 fe ff ff       	call   8003db <fd_lookup>
  800522:	83 c4 08             	add    $0x8,%esp
  800525:	85 c0                	test   %eax,%eax
  800527:	78 10                	js     800539 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  800529:	83 ec 08             	sub    $0x8,%esp
  80052c:	6a 01                	push   $0x1
  80052e:	ff 75 f4             	pushl  -0xc(%ebp)
  800531:	e8 51 ff ff ff       	call   800487 <fd_close>
  800536:	83 c4 10             	add    $0x10,%esp
}
  800539:	c9                   	leave  
  80053a:	c3                   	ret    

0080053b <close_all>:

void
close_all(void)
{
  80053b:	55                   	push   %ebp
  80053c:	89 e5                	mov    %esp,%ebp
  80053e:	53                   	push   %ebx
  80053f:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800542:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800547:	83 ec 0c             	sub    $0xc,%esp
  80054a:	53                   	push   %ebx
  80054b:	e8 c0 ff ff ff       	call   800510 <close>
	for (i = 0; i < MAXFD; i++)
  800550:	83 c3 01             	add    $0x1,%ebx
  800553:	83 c4 10             	add    $0x10,%esp
  800556:	83 fb 20             	cmp    $0x20,%ebx
  800559:	75 ec                	jne    800547 <close_all+0xc>
}
  80055b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80055e:	c9                   	leave  
  80055f:	c3                   	ret    

00800560 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800560:	55                   	push   %ebp
  800561:	89 e5                	mov    %esp,%ebp
  800563:	57                   	push   %edi
  800564:	56                   	push   %esi
  800565:	53                   	push   %ebx
  800566:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800569:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80056c:	50                   	push   %eax
  80056d:	ff 75 08             	pushl  0x8(%ebp)
  800570:	e8 66 fe ff ff       	call   8003db <fd_lookup>
  800575:	89 c3                	mov    %eax,%ebx
  800577:	83 c4 08             	add    $0x8,%esp
  80057a:	85 c0                	test   %eax,%eax
  80057c:	0f 88 81 00 00 00    	js     800603 <dup+0xa3>
		return r;
	close(newfdnum);
  800582:	83 ec 0c             	sub    $0xc,%esp
  800585:	ff 75 0c             	pushl  0xc(%ebp)
  800588:	e8 83 ff ff ff       	call   800510 <close>

	newfd = INDEX2FD(newfdnum);
  80058d:	8b 75 0c             	mov    0xc(%ebp),%esi
  800590:	c1 e6 0c             	shl    $0xc,%esi
  800593:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  800599:	83 c4 04             	add    $0x4,%esp
  80059c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80059f:	e8 d1 fd ff ff       	call   800375 <fd2data>
  8005a4:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8005a6:	89 34 24             	mov    %esi,(%esp)
  8005a9:	e8 c7 fd ff ff       	call   800375 <fd2data>
  8005ae:	83 c4 10             	add    $0x10,%esp
  8005b1:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8005b3:	89 d8                	mov    %ebx,%eax
  8005b5:	c1 e8 16             	shr    $0x16,%eax
  8005b8:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8005bf:	a8 01                	test   $0x1,%al
  8005c1:	74 11                	je     8005d4 <dup+0x74>
  8005c3:	89 d8                	mov    %ebx,%eax
  8005c5:	c1 e8 0c             	shr    $0xc,%eax
  8005c8:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8005cf:	f6 c2 01             	test   $0x1,%dl
  8005d2:	75 39                	jne    80060d <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8005d4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8005d7:	89 d0                	mov    %edx,%eax
  8005d9:	c1 e8 0c             	shr    $0xc,%eax
  8005dc:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8005e3:	83 ec 0c             	sub    $0xc,%esp
  8005e6:	25 07 0e 00 00       	and    $0xe07,%eax
  8005eb:	50                   	push   %eax
  8005ec:	56                   	push   %esi
  8005ed:	6a 00                	push   $0x0
  8005ef:	52                   	push   %edx
  8005f0:	6a 00                	push   $0x0
  8005f2:	e8 a1 fb ff ff       	call   800198 <sys_page_map>
  8005f7:	89 c3                	mov    %eax,%ebx
  8005f9:	83 c4 20             	add    $0x20,%esp
  8005fc:	85 c0                	test   %eax,%eax
  8005fe:	78 31                	js     800631 <dup+0xd1>
		goto err;

	return newfdnum;
  800600:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  800603:	89 d8                	mov    %ebx,%eax
  800605:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800608:	5b                   	pop    %ebx
  800609:	5e                   	pop    %esi
  80060a:	5f                   	pop    %edi
  80060b:	5d                   	pop    %ebp
  80060c:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80060d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800614:	83 ec 0c             	sub    $0xc,%esp
  800617:	25 07 0e 00 00       	and    $0xe07,%eax
  80061c:	50                   	push   %eax
  80061d:	57                   	push   %edi
  80061e:	6a 00                	push   $0x0
  800620:	53                   	push   %ebx
  800621:	6a 00                	push   $0x0
  800623:	e8 70 fb ff ff       	call   800198 <sys_page_map>
  800628:	89 c3                	mov    %eax,%ebx
  80062a:	83 c4 20             	add    $0x20,%esp
  80062d:	85 c0                	test   %eax,%eax
  80062f:	79 a3                	jns    8005d4 <dup+0x74>
	sys_page_unmap(0, newfd);
  800631:	83 ec 08             	sub    $0x8,%esp
  800634:	56                   	push   %esi
  800635:	6a 00                	push   $0x0
  800637:	e8 9e fb ff ff       	call   8001da <sys_page_unmap>
	sys_page_unmap(0, nva);
  80063c:	83 c4 08             	add    $0x8,%esp
  80063f:	57                   	push   %edi
  800640:	6a 00                	push   $0x0
  800642:	e8 93 fb ff ff       	call   8001da <sys_page_unmap>
	return r;
  800647:	83 c4 10             	add    $0x10,%esp
  80064a:	eb b7                	jmp    800603 <dup+0xa3>

0080064c <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80064c:	55                   	push   %ebp
  80064d:	89 e5                	mov    %esp,%ebp
  80064f:	53                   	push   %ebx
  800650:	83 ec 14             	sub    $0x14,%esp
  800653:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800656:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800659:	50                   	push   %eax
  80065a:	53                   	push   %ebx
  80065b:	e8 7b fd ff ff       	call   8003db <fd_lookup>
  800660:	83 c4 08             	add    $0x8,%esp
  800663:	85 c0                	test   %eax,%eax
  800665:	78 3f                	js     8006a6 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800667:	83 ec 08             	sub    $0x8,%esp
  80066a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80066d:	50                   	push   %eax
  80066e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800671:	ff 30                	pushl  (%eax)
  800673:	e8 b9 fd ff ff       	call   800431 <dev_lookup>
  800678:	83 c4 10             	add    $0x10,%esp
  80067b:	85 c0                	test   %eax,%eax
  80067d:	78 27                	js     8006a6 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80067f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800682:	8b 42 08             	mov    0x8(%edx),%eax
  800685:	83 e0 03             	and    $0x3,%eax
  800688:	83 f8 01             	cmp    $0x1,%eax
  80068b:	74 1e                	je     8006ab <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80068d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800690:	8b 40 08             	mov    0x8(%eax),%eax
  800693:	85 c0                	test   %eax,%eax
  800695:	74 35                	je     8006cc <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  800697:	83 ec 04             	sub    $0x4,%esp
  80069a:	ff 75 10             	pushl  0x10(%ebp)
  80069d:	ff 75 0c             	pushl  0xc(%ebp)
  8006a0:	52                   	push   %edx
  8006a1:	ff d0                	call   *%eax
  8006a3:	83 c4 10             	add    $0x10,%esp
}
  8006a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006a9:	c9                   	leave  
  8006aa:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8006ab:	a1 08 40 80 00       	mov    0x804008,%eax
  8006b0:	8b 40 48             	mov    0x48(%eax),%eax
  8006b3:	83 ec 04             	sub    $0x4,%esp
  8006b6:	53                   	push   %ebx
  8006b7:	50                   	push   %eax
  8006b8:	68 79 23 80 00       	push   $0x802379
  8006bd:	e8 dd 0e 00 00       	call   80159f <cprintf>
		return -E_INVAL;
  8006c2:	83 c4 10             	add    $0x10,%esp
  8006c5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8006ca:	eb da                	jmp    8006a6 <read+0x5a>
		return -E_NOT_SUPP;
  8006cc:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8006d1:	eb d3                	jmp    8006a6 <read+0x5a>

008006d3 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8006d3:	55                   	push   %ebp
  8006d4:	89 e5                	mov    %esp,%ebp
  8006d6:	57                   	push   %edi
  8006d7:	56                   	push   %esi
  8006d8:	53                   	push   %ebx
  8006d9:	83 ec 0c             	sub    $0xc,%esp
  8006dc:	8b 7d 08             	mov    0x8(%ebp),%edi
  8006df:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8006e2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006e7:	39 f3                	cmp    %esi,%ebx
  8006e9:	73 25                	jae    800710 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8006eb:	83 ec 04             	sub    $0x4,%esp
  8006ee:	89 f0                	mov    %esi,%eax
  8006f0:	29 d8                	sub    %ebx,%eax
  8006f2:	50                   	push   %eax
  8006f3:	89 d8                	mov    %ebx,%eax
  8006f5:	03 45 0c             	add    0xc(%ebp),%eax
  8006f8:	50                   	push   %eax
  8006f9:	57                   	push   %edi
  8006fa:	e8 4d ff ff ff       	call   80064c <read>
		if (m < 0)
  8006ff:	83 c4 10             	add    $0x10,%esp
  800702:	85 c0                	test   %eax,%eax
  800704:	78 08                	js     80070e <readn+0x3b>
			return m;
		if (m == 0)
  800706:	85 c0                	test   %eax,%eax
  800708:	74 06                	je     800710 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  80070a:	01 c3                	add    %eax,%ebx
  80070c:	eb d9                	jmp    8006e7 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80070e:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  800710:	89 d8                	mov    %ebx,%eax
  800712:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800715:	5b                   	pop    %ebx
  800716:	5e                   	pop    %esi
  800717:	5f                   	pop    %edi
  800718:	5d                   	pop    %ebp
  800719:	c3                   	ret    

0080071a <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80071a:	55                   	push   %ebp
  80071b:	89 e5                	mov    %esp,%ebp
  80071d:	53                   	push   %ebx
  80071e:	83 ec 14             	sub    $0x14,%esp
  800721:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800724:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800727:	50                   	push   %eax
  800728:	53                   	push   %ebx
  800729:	e8 ad fc ff ff       	call   8003db <fd_lookup>
  80072e:	83 c4 08             	add    $0x8,%esp
  800731:	85 c0                	test   %eax,%eax
  800733:	78 3a                	js     80076f <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800735:	83 ec 08             	sub    $0x8,%esp
  800738:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80073b:	50                   	push   %eax
  80073c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80073f:	ff 30                	pushl  (%eax)
  800741:	e8 eb fc ff ff       	call   800431 <dev_lookup>
  800746:	83 c4 10             	add    $0x10,%esp
  800749:	85 c0                	test   %eax,%eax
  80074b:	78 22                	js     80076f <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80074d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800750:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800754:	74 1e                	je     800774 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800756:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800759:	8b 52 0c             	mov    0xc(%edx),%edx
  80075c:	85 d2                	test   %edx,%edx
  80075e:	74 35                	je     800795 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  800760:	83 ec 04             	sub    $0x4,%esp
  800763:	ff 75 10             	pushl  0x10(%ebp)
  800766:	ff 75 0c             	pushl  0xc(%ebp)
  800769:	50                   	push   %eax
  80076a:	ff d2                	call   *%edx
  80076c:	83 c4 10             	add    $0x10,%esp
}
  80076f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800772:	c9                   	leave  
  800773:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800774:	a1 08 40 80 00       	mov    0x804008,%eax
  800779:	8b 40 48             	mov    0x48(%eax),%eax
  80077c:	83 ec 04             	sub    $0x4,%esp
  80077f:	53                   	push   %ebx
  800780:	50                   	push   %eax
  800781:	68 95 23 80 00       	push   $0x802395
  800786:	e8 14 0e 00 00       	call   80159f <cprintf>
		return -E_INVAL;
  80078b:	83 c4 10             	add    $0x10,%esp
  80078e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800793:	eb da                	jmp    80076f <write+0x55>
		return -E_NOT_SUPP;
  800795:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80079a:	eb d3                	jmp    80076f <write+0x55>

0080079c <seek>:

int
seek(int fdnum, off_t offset)
{
  80079c:	55                   	push   %ebp
  80079d:	89 e5                	mov    %esp,%ebp
  80079f:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8007a2:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8007a5:	50                   	push   %eax
  8007a6:	ff 75 08             	pushl  0x8(%ebp)
  8007a9:	e8 2d fc ff ff       	call   8003db <fd_lookup>
  8007ae:	83 c4 08             	add    $0x8,%esp
  8007b1:	85 c0                	test   %eax,%eax
  8007b3:	78 0e                	js     8007c3 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8007b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8007bb:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8007be:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8007c3:	c9                   	leave  
  8007c4:	c3                   	ret    

008007c5 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8007c5:	55                   	push   %ebp
  8007c6:	89 e5                	mov    %esp,%ebp
  8007c8:	53                   	push   %ebx
  8007c9:	83 ec 14             	sub    $0x14,%esp
  8007cc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8007cf:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8007d2:	50                   	push   %eax
  8007d3:	53                   	push   %ebx
  8007d4:	e8 02 fc ff ff       	call   8003db <fd_lookup>
  8007d9:	83 c4 08             	add    $0x8,%esp
  8007dc:	85 c0                	test   %eax,%eax
  8007de:	78 37                	js     800817 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8007e0:	83 ec 08             	sub    $0x8,%esp
  8007e3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8007e6:	50                   	push   %eax
  8007e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007ea:	ff 30                	pushl  (%eax)
  8007ec:	e8 40 fc ff ff       	call   800431 <dev_lookup>
  8007f1:	83 c4 10             	add    $0x10,%esp
  8007f4:	85 c0                	test   %eax,%eax
  8007f6:	78 1f                	js     800817 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8007f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007fb:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8007ff:	74 1b                	je     80081c <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  800801:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800804:	8b 52 18             	mov    0x18(%edx),%edx
  800807:	85 d2                	test   %edx,%edx
  800809:	74 32                	je     80083d <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80080b:	83 ec 08             	sub    $0x8,%esp
  80080e:	ff 75 0c             	pushl  0xc(%ebp)
  800811:	50                   	push   %eax
  800812:	ff d2                	call   *%edx
  800814:	83 c4 10             	add    $0x10,%esp
}
  800817:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80081a:	c9                   	leave  
  80081b:	c3                   	ret    
			thisenv->env_id, fdnum);
  80081c:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800821:	8b 40 48             	mov    0x48(%eax),%eax
  800824:	83 ec 04             	sub    $0x4,%esp
  800827:	53                   	push   %ebx
  800828:	50                   	push   %eax
  800829:	68 58 23 80 00       	push   $0x802358
  80082e:	e8 6c 0d 00 00       	call   80159f <cprintf>
		return -E_INVAL;
  800833:	83 c4 10             	add    $0x10,%esp
  800836:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80083b:	eb da                	jmp    800817 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80083d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800842:	eb d3                	jmp    800817 <ftruncate+0x52>

00800844 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800844:	55                   	push   %ebp
  800845:	89 e5                	mov    %esp,%ebp
  800847:	53                   	push   %ebx
  800848:	83 ec 14             	sub    $0x14,%esp
  80084b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80084e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800851:	50                   	push   %eax
  800852:	ff 75 08             	pushl  0x8(%ebp)
  800855:	e8 81 fb ff ff       	call   8003db <fd_lookup>
  80085a:	83 c4 08             	add    $0x8,%esp
  80085d:	85 c0                	test   %eax,%eax
  80085f:	78 4b                	js     8008ac <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800861:	83 ec 08             	sub    $0x8,%esp
  800864:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800867:	50                   	push   %eax
  800868:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80086b:	ff 30                	pushl  (%eax)
  80086d:	e8 bf fb ff ff       	call   800431 <dev_lookup>
  800872:	83 c4 10             	add    $0x10,%esp
  800875:	85 c0                	test   %eax,%eax
  800877:	78 33                	js     8008ac <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  800879:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80087c:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  800880:	74 2f                	je     8008b1 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800882:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  800885:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80088c:	00 00 00 
	stat->st_isdir = 0;
  80088f:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800896:	00 00 00 
	stat->st_dev = dev;
  800899:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80089f:	83 ec 08             	sub    $0x8,%esp
  8008a2:	53                   	push   %ebx
  8008a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8008a6:	ff 50 14             	call   *0x14(%eax)
  8008a9:	83 c4 10             	add    $0x10,%esp
}
  8008ac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008af:	c9                   	leave  
  8008b0:	c3                   	ret    
		return -E_NOT_SUPP;
  8008b1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8008b6:	eb f4                	jmp    8008ac <fstat+0x68>

008008b8 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8008b8:	55                   	push   %ebp
  8008b9:	89 e5                	mov    %esp,%ebp
  8008bb:	56                   	push   %esi
  8008bc:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8008bd:	83 ec 08             	sub    $0x8,%esp
  8008c0:	6a 00                	push   $0x0
  8008c2:	ff 75 08             	pushl  0x8(%ebp)
  8008c5:	e8 26 02 00 00       	call   800af0 <open>
  8008ca:	89 c3                	mov    %eax,%ebx
  8008cc:	83 c4 10             	add    $0x10,%esp
  8008cf:	85 c0                	test   %eax,%eax
  8008d1:	78 1b                	js     8008ee <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8008d3:	83 ec 08             	sub    $0x8,%esp
  8008d6:	ff 75 0c             	pushl  0xc(%ebp)
  8008d9:	50                   	push   %eax
  8008da:	e8 65 ff ff ff       	call   800844 <fstat>
  8008df:	89 c6                	mov    %eax,%esi
	close(fd);
  8008e1:	89 1c 24             	mov    %ebx,(%esp)
  8008e4:	e8 27 fc ff ff       	call   800510 <close>
	return r;
  8008e9:	83 c4 10             	add    $0x10,%esp
  8008ec:	89 f3                	mov    %esi,%ebx
}
  8008ee:	89 d8                	mov    %ebx,%eax
  8008f0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008f3:	5b                   	pop    %ebx
  8008f4:	5e                   	pop    %esi
  8008f5:	5d                   	pop    %ebp
  8008f6:	c3                   	ret    

008008f7 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8008f7:	55                   	push   %ebp
  8008f8:	89 e5                	mov    %esp,%ebp
  8008fa:	56                   	push   %esi
  8008fb:	53                   	push   %ebx
  8008fc:	89 c6                	mov    %eax,%esi
  8008fe:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  800900:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  800907:	74 27                	je     800930 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800909:	6a 07                	push   $0x7
  80090b:	68 00 50 80 00       	push   $0x805000
  800910:	56                   	push   %esi
  800911:	ff 35 00 40 80 00    	pushl  0x804000
  800917:	e8 c6 16 00 00       	call   801fe2 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80091c:	83 c4 0c             	add    $0xc,%esp
  80091f:	6a 00                	push   $0x0
  800921:	53                   	push   %ebx
  800922:	6a 00                	push   $0x0
  800924:	e8 50 16 00 00       	call   801f79 <ipc_recv>
}
  800929:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80092c:	5b                   	pop    %ebx
  80092d:	5e                   	pop    %esi
  80092e:	5d                   	pop    %ebp
  80092f:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800930:	83 ec 0c             	sub    $0xc,%esp
  800933:	6a 01                	push   $0x1
  800935:	e8 01 17 00 00       	call   80203b <ipc_find_env>
  80093a:	a3 00 40 80 00       	mov    %eax,0x804000
  80093f:	83 c4 10             	add    $0x10,%esp
  800942:	eb c5                	jmp    800909 <fsipc+0x12>

00800944 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  800944:	55                   	push   %ebp
  800945:	89 e5                	mov    %esp,%ebp
  800947:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80094a:	8b 45 08             	mov    0x8(%ebp),%eax
  80094d:	8b 40 0c             	mov    0xc(%eax),%eax
  800950:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  800955:	8b 45 0c             	mov    0xc(%ebp),%eax
  800958:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80095d:	ba 00 00 00 00       	mov    $0x0,%edx
  800962:	b8 02 00 00 00       	mov    $0x2,%eax
  800967:	e8 8b ff ff ff       	call   8008f7 <fsipc>
}
  80096c:	c9                   	leave  
  80096d:	c3                   	ret    

0080096e <devfile_flush>:
{
  80096e:	55                   	push   %ebp
  80096f:	89 e5                	mov    %esp,%ebp
  800971:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800974:	8b 45 08             	mov    0x8(%ebp),%eax
  800977:	8b 40 0c             	mov    0xc(%eax),%eax
  80097a:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80097f:	ba 00 00 00 00       	mov    $0x0,%edx
  800984:	b8 06 00 00 00       	mov    $0x6,%eax
  800989:	e8 69 ff ff ff       	call   8008f7 <fsipc>
}
  80098e:	c9                   	leave  
  80098f:	c3                   	ret    

00800990 <devfile_stat>:
{
  800990:	55                   	push   %ebp
  800991:	89 e5                	mov    %esp,%ebp
  800993:	53                   	push   %ebx
  800994:	83 ec 04             	sub    $0x4,%esp
  800997:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80099a:	8b 45 08             	mov    0x8(%ebp),%eax
  80099d:	8b 40 0c             	mov    0xc(%eax),%eax
  8009a0:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8009a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8009aa:	b8 05 00 00 00       	mov    $0x5,%eax
  8009af:	e8 43 ff ff ff       	call   8008f7 <fsipc>
  8009b4:	85 c0                	test   %eax,%eax
  8009b6:	78 2c                	js     8009e4 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8009b8:	83 ec 08             	sub    $0x8,%esp
  8009bb:	68 00 50 80 00       	push   $0x805000
  8009c0:	53                   	push   %ebx
  8009c1:	e8 76 12 00 00       	call   801c3c <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8009c6:	a1 80 50 80 00       	mov    0x805080,%eax
  8009cb:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8009d1:	a1 84 50 80 00       	mov    0x805084,%eax
  8009d6:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8009dc:	83 c4 10             	add    $0x10,%esp
  8009df:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009e7:	c9                   	leave  
  8009e8:	c3                   	ret    

008009e9 <devfile_write>:
{
  8009e9:	55                   	push   %ebp
  8009ea:	89 e5                	mov    %esp,%ebp
  8009ec:	53                   	push   %ebx
  8009ed:	83 ec 04             	sub    $0x4,%esp
  8009f0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8009f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f6:	8b 40 0c             	mov    0xc(%eax),%eax
  8009f9:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  8009fe:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  800a04:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  800a0a:	77 30                	ja     800a3c <devfile_write+0x53>
	memmove(fsipcbuf.write.req_buf, buf, n);
  800a0c:	83 ec 04             	sub    $0x4,%esp
  800a0f:	53                   	push   %ebx
  800a10:	ff 75 0c             	pushl  0xc(%ebp)
  800a13:	68 08 50 80 00       	push   $0x805008
  800a18:	e8 ad 13 00 00       	call   801dca <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  800a1d:	ba 00 00 00 00       	mov    $0x0,%edx
  800a22:	b8 04 00 00 00       	mov    $0x4,%eax
  800a27:	e8 cb fe ff ff       	call   8008f7 <fsipc>
  800a2c:	83 c4 10             	add    $0x10,%esp
  800a2f:	85 c0                	test   %eax,%eax
  800a31:	78 04                	js     800a37 <devfile_write+0x4e>
	assert(r <= n);
  800a33:	39 d8                	cmp    %ebx,%eax
  800a35:	77 1e                	ja     800a55 <devfile_write+0x6c>
}
  800a37:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a3a:	c9                   	leave  
  800a3b:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  800a3c:	68 c8 23 80 00       	push   $0x8023c8
  800a41:	68 f5 23 80 00       	push   $0x8023f5
  800a46:	68 94 00 00 00       	push   $0x94
  800a4b:	68 0a 24 80 00       	push   $0x80240a
  800a50:	e8 6f 0a 00 00       	call   8014c4 <_panic>
	assert(r <= n);
  800a55:	68 15 24 80 00       	push   $0x802415
  800a5a:	68 f5 23 80 00       	push   $0x8023f5
  800a5f:	68 98 00 00 00       	push   $0x98
  800a64:	68 0a 24 80 00       	push   $0x80240a
  800a69:	e8 56 0a 00 00       	call   8014c4 <_panic>

00800a6e <devfile_read>:
{
  800a6e:	55                   	push   %ebp
  800a6f:	89 e5                	mov    %esp,%ebp
  800a71:	56                   	push   %esi
  800a72:	53                   	push   %ebx
  800a73:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800a76:	8b 45 08             	mov    0x8(%ebp),%eax
  800a79:	8b 40 0c             	mov    0xc(%eax),%eax
  800a7c:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800a81:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800a87:	ba 00 00 00 00       	mov    $0x0,%edx
  800a8c:	b8 03 00 00 00       	mov    $0x3,%eax
  800a91:	e8 61 fe ff ff       	call   8008f7 <fsipc>
  800a96:	89 c3                	mov    %eax,%ebx
  800a98:	85 c0                	test   %eax,%eax
  800a9a:	78 1f                	js     800abb <devfile_read+0x4d>
	assert(r <= n);
  800a9c:	39 f0                	cmp    %esi,%eax
  800a9e:	77 24                	ja     800ac4 <devfile_read+0x56>
	assert(r <= PGSIZE);
  800aa0:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800aa5:	7f 33                	jg     800ada <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800aa7:	83 ec 04             	sub    $0x4,%esp
  800aaa:	50                   	push   %eax
  800aab:	68 00 50 80 00       	push   $0x805000
  800ab0:	ff 75 0c             	pushl  0xc(%ebp)
  800ab3:	e8 12 13 00 00       	call   801dca <memmove>
	return r;
  800ab8:	83 c4 10             	add    $0x10,%esp
}
  800abb:	89 d8                	mov    %ebx,%eax
  800abd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ac0:	5b                   	pop    %ebx
  800ac1:	5e                   	pop    %esi
  800ac2:	5d                   	pop    %ebp
  800ac3:	c3                   	ret    
	assert(r <= n);
  800ac4:	68 15 24 80 00       	push   $0x802415
  800ac9:	68 f5 23 80 00       	push   $0x8023f5
  800ace:	6a 7c                	push   $0x7c
  800ad0:	68 0a 24 80 00       	push   $0x80240a
  800ad5:	e8 ea 09 00 00       	call   8014c4 <_panic>
	assert(r <= PGSIZE);
  800ada:	68 1c 24 80 00       	push   $0x80241c
  800adf:	68 f5 23 80 00       	push   $0x8023f5
  800ae4:	6a 7d                	push   $0x7d
  800ae6:	68 0a 24 80 00       	push   $0x80240a
  800aeb:	e8 d4 09 00 00       	call   8014c4 <_panic>

00800af0 <open>:
{
  800af0:	55                   	push   %ebp
  800af1:	89 e5                	mov    %esp,%ebp
  800af3:	56                   	push   %esi
  800af4:	53                   	push   %ebx
  800af5:	83 ec 1c             	sub    $0x1c,%esp
  800af8:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800afb:	56                   	push   %esi
  800afc:	e8 04 11 00 00       	call   801c05 <strlen>
  800b01:	83 c4 10             	add    $0x10,%esp
  800b04:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800b09:	7f 6c                	jg     800b77 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  800b0b:	83 ec 0c             	sub    $0xc,%esp
  800b0e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800b11:	50                   	push   %eax
  800b12:	e8 75 f8 ff ff       	call   80038c <fd_alloc>
  800b17:	89 c3                	mov    %eax,%ebx
  800b19:	83 c4 10             	add    $0x10,%esp
  800b1c:	85 c0                	test   %eax,%eax
  800b1e:	78 3c                	js     800b5c <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  800b20:	83 ec 08             	sub    $0x8,%esp
  800b23:	56                   	push   %esi
  800b24:	68 00 50 80 00       	push   $0x805000
  800b29:	e8 0e 11 00 00       	call   801c3c <strcpy>
	fsipcbuf.open.req_omode = mode;
  800b2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b31:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800b36:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b39:	b8 01 00 00 00       	mov    $0x1,%eax
  800b3e:	e8 b4 fd ff ff       	call   8008f7 <fsipc>
  800b43:	89 c3                	mov    %eax,%ebx
  800b45:	83 c4 10             	add    $0x10,%esp
  800b48:	85 c0                	test   %eax,%eax
  800b4a:	78 19                	js     800b65 <open+0x75>
	return fd2num(fd);
  800b4c:	83 ec 0c             	sub    $0xc,%esp
  800b4f:	ff 75 f4             	pushl  -0xc(%ebp)
  800b52:	e8 0e f8 ff ff       	call   800365 <fd2num>
  800b57:	89 c3                	mov    %eax,%ebx
  800b59:	83 c4 10             	add    $0x10,%esp
}
  800b5c:	89 d8                	mov    %ebx,%eax
  800b5e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b61:	5b                   	pop    %ebx
  800b62:	5e                   	pop    %esi
  800b63:	5d                   	pop    %ebp
  800b64:	c3                   	ret    
		fd_close(fd, 0);
  800b65:	83 ec 08             	sub    $0x8,%esp
  800b68:	6a 00                	push   $0x0
  800b6a:	ff 75 f4             	pushl  -0xc(%ebp)
  800b6d:	e8 15 f9 ff ff       	call   800487 <fd_close>
		return r;
  800b72:	83 c4 10             	add    $0x10,%esp
  800b75:	eb e5                	jmp    800b5c <open+0x6c>
		return -E_BAD_PATH;
  800b77:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800b7c:	eb de                	jmp    800b5c <open+0x6c>

00800b7e <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800b7e:	55                   	push   %ebp
  800b7f:	89 e5                	mov    %esp,%ebp
  800b81:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800b84:	ba 00 00 00 00       	mov    $0x0,%edx
  800b89:	b8 08 00 00 00       	mov    $0x8,%eax
  800b8e:	e8 64 fd ff ff       	call   8008f7 <fsipc>
}
  800b93:	c9                   	leave  
  800b94:	c3                   	ret    

00800b95 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800b95:	55                   	push   %ebp
  800b96:	89 e5                	mov    %esp,%ebp
  800b98:	56                   	push   %esi
  800b99:	53                   	push   %ebx
  800b9a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800b9d:	83 ec 0c             	sub    $0xc,%esp
  800ba0:	ff 75 08             	pushl  0x8(%ebp)
  800ba3:	e8 cd f7 ff ff       	call   800375 <fd2data>
  800ba8:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  800baa:	83 c4 08             	add    $0x8,%esp
  800bad:	68 28 24 80 00       	push   $0x802428
  800bb2:	53                   	push   %ebx
  800bb3:	e8 84 10 00 00       	call   801c3c <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  800bb8:	8b 46 04             	mov    0x4(%esi),%eax
  800bbb:	2b 06                	sub    (%esi),%eax
  800bbd:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  800bc3:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800bca:	00 00 00 
	stat->st_dev = &devpipe;
  800bcd:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  800bd4:	30 80 00 
	return 0;
}
  800bd7:	b8 00 00 00 00       	mov    $0x0,%eax
  800bdc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bdf:	5b                   	pop    %ebx
  800be0:	5e                   	pop    %esi
  800be1:	5d                   	pop    %ebp
  800be2:	c3                   	ret    

00800be3 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  800be3:	55                   	push   %ebp
  800be4:	89 e5                	mov    %esp,%ebp
  800be6:	53                   	push   %ebx
  800be7:	83 ec 0c             	sub    $0xc,%esp
  800bea:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  800bed:	53                   	push   %ebx
  800bee:	6a 00                	push   $0x0
  800bf0:	e8 e5 f5 ff ff       	call   8001da <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  800bf5:	89 1c 24             	mov    %ebx,(%esp)
  800bf8:	e8 78 f7 ff ff       	call   800375 <fd2data>
  800bfd:	83 c4 08             	add    $0x8,%esp
  800c00:	50                   	push   %eax
  800c01:	6a 00                	push   $0x0
  800c03:	e8 d2 f5 ff ff       	call   8001da <sys_page_unmap>
}
  800c08:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c0b:	c9                   	leave  
  800c0c:	c3                   	ret    

00800c0d <_pipeisclosed>:
{
  800c0d:	55                   	push   %ebp
  800c0e:	89 e5                	mov    %esp,%ebp
  800c10:	57                   	push   %edi
  800c11:	56                   	push   %esi
  800c12:	53                   	push   %ebx
  800c13:	83 ec 1c             	sub    $0x1c,%esp
  800c16:	89 c7                	mov    %eax,%edi
  800c18:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  800c1a:	a1 08 40 80 00       	mov    0x804008,%eax
  800c1f:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  800c22:	83 ec 0c             	sub    $0xc,%esp
  800c25:	57                   	push   %edi
  800c26:	e8 49 14 00 00       	call   802074 <pageref>
  800c2b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c2e:	89 34 24             	mov    %esi,(%esp)
  800c31:	e8 3e 14 00 00       	call   802074 <pageref>
		nn = thisenv->env_runs;
  800c36:	8b 15 08 40 80 00    	mov    0x804008,%edx
  800c3c:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  800c3f:	83 c4 10             	add    $0x10,%esp
  800c42:	39 cb                	cmp    %ecx,%ebx
  800c44:	74 1b                	je     800c61 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  800c46:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800c49:	75 cf                	jne    800c1a <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  800c4b:	8b 42 58             	mov    0x58(%edx),%eax
  800c4e:	6a 01                	push   $0x1
  800c50:	50                   	push   %eax
  800c51:	53                   	push   %ebx
  800c52:	68 2f 24 80 00       	push   $0x80242f
  800c57:	e8 43 09 00 00       	call   80159f <cprintf>
  800c5c:	83 c4 10             	add    $0x10,%esp
  800c5f:	eb b9                	jmp    800c1a <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  800c61:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800c64:	0f 94 c0             	sete   %al
  800c67:	0f b6 c0             	movzbl %al,%eax
}
  800c6a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c6d:	5b                   	pop    %ebx
  800c6e:	5e                   	pop    %esi
  800c6f:	5f                   	pop    %edi
  800c70:	5d                   	pop    %ebp
  800c71:	c3                   	ret    

00800c72 <devpipe_write>:
{
  800c72:	55                   	push   %ebp
  800c73:	89 e5                	mov    %esp,%ebp
  800c75:	57                   	push   %edi
  800c76:	56                   	push   %esi
  800c77:	53                   	push   %ebx
  800c78:	83 ec 28             	sub    $0x28,%esp
  800c7b:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  800c7e:	56                   	push   %esi
  800c7f:	e8 f1 f6 ff ff       	call   800375 <fd2data>
  800c84:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800c86:	83 c4 10             	add    $0x10,%esp
  800c89:	bf 00 00 00 00       	mov    $0x0,%edi
  800c8e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  800c91:	74 4f                	je     800ce2 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  800c93:	8b 43 04             	mov    0x4(%ebx),%eax
  800c96:	8b 0b                	mov    (%ebx),%ecx
  800c98:	8d 51 20             	lea    0x20(%ecx),%edx
  800c9b:	39 d0                	cmp    %edx,%eax
  800c9d:	72 14                	jb     800cb3 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  800c9f:	89 da                	mov    %ebx,%edx
  800ca1:	89 f0                	mov    %esi,%eax
  800ca3:	e8 65 ff ff ff       	call   800c0d <_pipeisclosed>
  800ca8:	85 c0                	test   %eax,%eax
  800caa:	75 3a                	jne    800ce6 <devpipe_write+0x74>
			sys_yield();
  800cac:	e8 85 f4 ff ff       	call   800136 <sys_yield>
  800cb1:	eb e0                	jmp    800c93 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  800cb3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cb6:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  800cba:	88 4d e7             	mov    %cl,-0x19(%ebp)
  800cbd:	89 c2                	mov    %eax,%edx
  800cbf:	c1 fa 1f             	sar    $0x1f,%edx
  800cc2:	89 d1                	mov    %edx,%ecx
  800cc4:	c1 e9 1b             	shr    $0x1b,%ecx
  800cc7:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  800cca:	83 e2 1f             	and    $0x1f,%edx
  800ccd:	29 ca                	sub    %ecx,%edx
  800ccf:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  800cd3:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  800cd7:	83 c0 01             	add    $0x1,%eax
  800cda:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  800cdd:	83 c7 01             	add    $0x1,%edi
  800ce0:	eb ac                	jmp    800c8e <devpipe_write+0x1c>
	return i;
  800ce2:	89 f8                	mov    %edi,%eax
  800ce4:	eb 05                	jmp    800ceb <devpipe_write+0x79>
				return 0;
  800ce6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ceb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cee:	5b                   	pop    %ebx
  800cef:	5e                   	pop    %esi
  800cf0:	5f                   	pop    %edi
  800cf1:	5d                   	pop    %ebp
  800cf2:	c3                   	ret    

00800cf3 <devpipe_read>:
{
  800cf3:	55                   	push   %ebp
  800cf4:	89 e5                	mov    %esp,%ebp
  800cf6:	57                   	push   %edi
  800cf7:	56                   	push   %esi
  800cf8:	53                   	push   %ebx
  800cf9:	83 ec 18             	sub    $0x18,%esp
  800cfc:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  800cff:	57                   	push   %edi
  800d00:	e8 70 f6 ff ff       	call   800375 <fd2data>
  800d05:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800d07:	83 c4 10             	add    $0x10,%esp
  800d0a:	be 00 00 00 00       	mov    $0x0,%esi
  800d0f:	3b 75 10             	cmp    0x10(%ebp),%esi
  800d12:	74 47                	je     800d5b <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  800d14:	8b 03                	mov    (%ebx),%eax
  800d16:	3b 43 04             	cmp    0x4(%ebx),%eax
  800d19:	75 22                	jne    800d3d <devpipe_read+0x4a>
			if (i > 0)
  800d1b:	85 f6                	test   %esi,%esi
  800d1d:	75 14                	jne    800d33 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  800d1f:	89 da                	mov    %ebx,%edx
  800d21:	89 f8                	mov    %edi,%eax
  800d23:	e8 e5 fe ff ff       	call   800c0d <_pipeisclosed>
  800d28:	85 c0                	test   %eax,%eax
  800d2a:	75 33                	jne    800d5f <devpipe_read+0x6c>
			sys_yield();
  800d2c:	e8 05 f4 ff ff       	call   800136 <sys_yield>
  800d31:	eb e1                	jmp    800d14 <devpipe_read+0x21>
				return i;
  800d33:	89 f0                	mov    %esi,%eax
}
  800d35:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d38:	5b                   	pop    %ebx
  800d39:	5e                   	pop    %esi
  800d3a:	5f                   	pop    %edi
  800d3b:	5d                   	pop    %ebp
  800d3c:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  800d3d:	99                   	cltd   
  800d3e:	c1 ea 1b             	shr    $0x1b,%edx
  800d41:	01 d0                	add    %edx,%eax
  800d43:	83 e0 1f             	and    $0x1f,%eax
  800d46:	29 d0                	sub    %edx,%eax
  800d48:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  800d4d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d50:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  800d53:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  800d56:	83 c6 01             	add    $0x1,%esi
  800d59:	eb b4                	jmp    800d0f <devpipe_read+0x1c>
	return i;
  800d5b:	89 f0                	mov    %esi,%eax
  800d5d:	eb d6                	jmp    800d35 <devpipe_read+0x42>
				return 0;
  800d5f:	b8 00 00 00 00       	mov    $0x0,%eax
  800d64:	eb cf                	jmp    800d35 <devpipe_read+0x42>

00800d66 <pipe>:
{
  800d66:	55                   	push   %ebp
  800d67:	89 e5                	mov    %esp,%ebp
  800d69:	56                   	push   %esi
  800d6a:	53                   	push   %ebx
  800d6b:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  800d6e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800d71:	50                   	push   %eax
  800d72:	e8 15 f6 ff ff       	call   80038c <fd_alloc>
  800d77:	89 c3                	mov    %eax,%ebx
  800d79:	83 c4 10             	add    $0x10,%esp
  800d7c:	85 c0                	test   %eax,%eax
  800d7e:	78 5b                	js     800ddb <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800d80:	83 ec 04             	sub    $0x4,%esp
  800d83:	68 07 04 00 00       	push   $0x407
  800d88:	ff 75 f4             	pushl  -0xc(%ebp)
  800d8b:	6a 00                	push   $0x0
  800d8d:	e8 c3 f3 ff ff       	call   800155 <sys_page_alloc>
  800d92:	89 c3                	mov    %eax,%ebx
  800d94:	83 c4 10             	add    $0x10,%esp
  800d97:	85 c0                	test   %eax,%eax
  800d99:	78 40                	js     800ddb <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  800d9b:	83 ec 0c             	sub    $0xc,%esp
  800d9e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800da1:	50                   	push   %eax
  800da2:	e8 e5 f5 ff ff       	call   80038c <fd_alloc>
  800da7:	89 c3                	mov    %eax,%ebx
  800da9:	83 c4 10             	add    $0x10,%esp
  800dac:	85 c0                	test   %eax,%eax
  800dae:	78 1b                	js     800dcb <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800db0:	83 ec 04             	sub    $0x4,%esp
  800db3:	68 07 04 00 00       	push   $0x407
  800db8:	ff 75 f0             	pushl  -0x10(%ebp)
  800dbb:	6a 00                	push   $0x0
  800dbd:	e8 93 f3 ff ff       	call   800155 <sys_page_alloc>
  800dc2:	89 c3                	mov    %eax,%ebx
  800dc4:	83 c4 10             	add    $0x10,%esp
  800dc7:	85 c0                	test   %eax,%eax
  800dc9:	79 19                	jns    800de4 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  800dcb:	83 ec 08             	sub    $0x8,%esp
  800dce:	ff 75 f4             	pushl  -0xc(%ebp)
  800dd1:	6a 00                	push   $0x0
  800dd3:	e8 02 f4 ff ff       	call   8001da <sys_page_unmap>
  800dd8:	83 c4 10             	add    $0x10,%esp
}
  800ddb:	89 d8                	mov    %ebx,%eax
  800ddd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800de0:	5b                   	pop    %ebx
  800de1:	5e                   	pop    %esi
  800de2:	5d                   	pop    %ebp
  800de3:	c3                   	ret    
	va = fd2data(fd0);
  800de4:	83 ec 0c             	sub    $0xc,%esp
  800de7:	ff 75 f4             	pushl  -0xc(%ebp)
  800dea:	e8 86 f5 ff ff       	call   800375 <fd2data>
  800def:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800df1:	83 c4 0c             	add    $0xc,%esp
  800df4:	68 07 04 00 00       	push   $0x407
  800df9:	50                   	push   %eax
  800dfa:	6a 00                	push   $0x0
  800dfc:	e8 54 f3 ff ff       	call   800155 <sys_page_alloc>
  800e01:	89 c3                	mov    %eax,%ebx
  800e03:	83 c4 10             	add    $0x10,%esp
  800e06:	85 c0                	test   %eax,%eax
  800e08:	0f 88 8c 00 00 00    	js     800e9a <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e0e:	83 ec 0c             	sub    $0xc,%esp
  800e11:	ff 75 f0             	pushl  -0x10(%ebp)
  800e14:	e8 5c f5 ff ff       	call   800375 <fd2data>
  800e19:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  800e20:	50                   	push   %eax
  800e21:	6a 00                	push   $0x0
  800e23:	56                   	push   %esi
  800e24:	6a 00                	push   $0x0
  800e26:	e8 6d f3 ff ff       	call   800198 <sys_page_map>
  800e2b:	89 c3                	mov    %eax,%ebx
  800e2d:	83 c4 20             	add    $0x20,%esp
  800e30:	85 c0                	test   %eax,%eax
  800e32:	78 58                	js     800e8c <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  800e34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e37:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800e3d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  800e3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e42:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  800e49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e4c:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800e52:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  800e54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e57:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  800e5e:	83 ec 0c             	sub    $0xc,%esp
  800e61:	ff 75 f4             	pushl  -0xc(%ebp)
  800e64:	e8 fc f4 ff ff       	call   800365 <fd2num>
  800e69:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e6c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  800e6e:	83 c4 04             	add    $0x4,%esp
  800e71:	ff 75 f0             	pushl  -0x10(%ebp)
  800e74:	e8 ec f4 ff ff       	call   800365 <fd2num>
  800e79:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e7c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  800e7f:	83 c4 10             	add    $0x10,%esp
  800e82:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e87:	e9 4f ff ff ff       	jmp    800ddb <pipe+0x75>
	sys_page_unmap(0, va);
  800e8c:	83 ec 08             	sub    $0x8,%esp
  800e8f:	56                   	push   %esi
  800e90:	6a 00                	push   $0x0
  800e92:	e8 43 f3 ff ff       	call   8001da <sys_page_unmap>
  800e97:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  800e9a:	83 ec 08             	sub    $0x8,%esp
  800e9d:	ff 75 f0             	pushl  -0x10(%ebp)
  800ea0:	6a 00                	push   $0x0
  800ea2:	e8 33 f3 ff ff       	call   8001da <sys_page_unmap>
  800ea7:	83 c4 10             	add    $0x10,%esp
  800eaa:	e9 1c ff ff ff       	jmp    800dcb <pipe+0x65>

00800eaf <pipeisclosed>:
{
  800eaf:	55                   	push   %ebp
  800eb0:	89 e5                	mov    %esp,%ebp
  800eb2:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800eb5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800eb8:	50                   	push   %eax
  800eb9:	ff 75 08             	pushl  0x8(%ebp)
  800ebc:	e8 1a f5 ff ff       	call   8003db <fd_lookup>
  800ec1:	83 c4 10             	add    $0x10,%esp
  800ec4:	85 c0                	test   %eax,%eax
  800ec6:	78 18                	js     800ee0 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  800ec8:	83 ec 0c             	sub    $0xc,%esp
  800ecb:	ff 75 f4             	pushl  -0xc(%ebp)
  800ece:	e8 a2 f4 ff ff       	call   800375 <fd2data>
	return _pipeisclosed(fd, p);
  800ed3:	89 c2                	mov    %eax,%edx
  800ed5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ed8:	e8 30 fd ff ff       	call   800c0d <_pipeisclosed>
  800edd:	83 c4 10             	add    $0x10,%esp
}
  800ee0:	c9                   	leave  
  800ee1:	c3                   	ret    

00800ee2 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  800ee2:	55                   	push   %ebp
  800ee3:	89 e5                	mov    %esp,%ebp
  800ee5:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  800ee8:	68 47 24 80 00       	push   $0x802447
  800eed:	ff 75 0c             	pushl  0xc(%ebp)
  800ef0:	e8 47 0d 00 00       	call   801c3c <strcpy>
	return 0;
}
  800ef5:	b8 00 00 00 00       	mov    $0x0,%eax
  800efa:	c9                   	leave  
  800efb:	c3                   	ret    

00800efc <devsock_close>:
{
  800efc:	55                   	push   %ebp
  800efd:	89 e5                	mov    %esp,%ebp
  800eff:	53                   	push   %ebx
  800f00:	83 ec 10             	sub    $0x10,%esp
  800f03:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  800f06:	53                   	push   %ebx
  800f07:	e8 68 11 00 00       	call   802074 <pageref>
  800f0c:	83 c4 10             	add    $0x10,%esp
		return 0;
  800f0f:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  800f14:	83 f8 01             	cmp    $0x1,%eax
  800f17:	74 07                	je     800f20 <devsock_close+0x24>
}
  800f19:	89 d0                	mov    %edx,%eax
  800f1b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f1e:	c9                   	leave  
  800f1f:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  800f20:	83 ec 0c             	sub    $0xc,%esp
  800f23:	ff 73 0c             	pushl  0xc(%ebx)
  800f26:	e8 b7 02 00 00       	call   8011e2 <nsipc_close>
  800f2b:	89 c2                	mov    %eax,%edx
  800f2d:	83 c4 10             	add    $0x10,%esp
  800f30:	eb e7                	jmp    800f19 <devsock_close+0x1d>

00800f32 <devsock_write>:
{
  800f32:	55                   	push   %ebp
  800f33:	89 e5                	mov    %esp,%ebp
  800f35:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  800f38:	6a 00                	push   $0x0
  800f3a:	ff 75 10             	pushl  0x10(%ebp)
  800f3d:	ff 75 0c             	pushl  0xc(%ebp)
  800f40:	8b 45 08             	mov    0x8(%ebp),%eax
  800f43:	ff 70 0c             	pushl  0xc(%eax)
  800f46:	e8 74 03 00 00       	call   8012bf <nsipc_send>
}
  800f4b:	c9                   	leave  
  800f4c:	c3                   	ret    

00800f4d <devsock_read>:
{
  800f4d:	55                   	push   %ebp
  800f4e:	89 e5                	mov    %esp,%ebp
  800f50:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  800f53:	6a 00                	push   $0x0
  800f55:	ff 75 10             	pushl  0x10(%ebp)
  800f58:	ff 75 0c             	pushl  0xc(%ebp)
  800f5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5e:	ff 70 0c             	pushl  0xc(%eax)
  800f61:	e8 ed 02 00 00       	call   801253 <nsipc_recv>
}
  800f66:	c9                   	leave  
  800f67:	c3                   	ret    

00800f68 <fd2sockid>:
{
  800f68:	55                   	push   %ebp
  800f69:	89 e5                	mov    %esp,%ebp
  800f6b:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  800f6e:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800f71:	52                   	push   %edx
  800f72:	50                   	push   %eax
  800f73:	e8 63 f4 ff ff       	call   8003db <fd_lookup>
  800f78:	83 c4 10             	add    $0x10,%esp
  800f7b:	85 c0                	test   %eax,%eax
  800f7d:	78 10                	js     800f8f <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  800f7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f82:	8b 0d 3c 30 80 00    	mov    0x80303c,%ecx
  800f88:	39 08                	cmp    %ecx,(%eax)
  800f8a:	75 05                	jne    800f91 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  800f8c:	8b 40 0c             	mov    0xc(%eax),%eax
}
  800f8f:	c9                   	leave  
  800f90:	c3                   	ret    
		return -E_NOT_SUPP;
  800f91:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800f96:	eb f7                	jmp    800f8f <fd2sockid+0x27>

00800f98 <alloc_sockfd>:
{
  800f98:	55                   	push   %ebp
  800f99:	89 e5                	mov    %esp,%ebp
  800f9b:	56                   	push   %esi
  800f9c:	53                   	push   %ebx
  800f9d:	83 ec 1c             	sub    $0x1c,%esp
  800fa0:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  800fa2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800fa5:	50                   	push   %eax
  800fa6:	e8 e1 f3 ff ff       	call   80038c <fd_alloc>
  800fab:	89 c3                	mov    %eax,%ebx
  800fad:	83 c4 10             	add    $0x10,%esp
  800fb0:	85 c0                	test   %eax,%eax
  800fb2:	78 43                	js     800ff7 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  800fb4:	83 ec 04             	sub    $0x4,%esp
  800fb7:	68 07 04 00 00       	push   $0x407
  800fbc:	ff 75 f4             	pushl  -0xc(%ebp)
  800fbf:	6a 00                	push   $0x0
  800fc1:	e8 8f f1 ff ff       	call   800155 <sys_page_alloc>
  800fc6:	89 c3                	mov    %eax,%ebx
  800fc8:	83 c4 10             	add    $0x10,%esp
  800fcb:	85 c0                	test   %eax,%eax
  800fcd:	78 28                	js     800ff7 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  800fcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fd2:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  800fd8:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  800fda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fdd:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  800fe4:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  800fe7:	83 ec 0c             	sub    $0xc,%esp
  800fea:	50                   	push   %eax
  800feb:	e8 75 f3 ff ff       	call   800365 <fd2num>
  800ff0:	89 c3                	mov    %eax,%ebx
  800ff2:	83 c4 10             	add    $0x10,%esp
  800ff5:	eb 0c                	jmp    801003 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  800ff7:	83 ec 0c             	sub    $0xc,%esp
  800ffa:	56                   	push   %esi
  800ffb:	e8 e2 01 00 00       	call   8011e2 <nsipc_close>
		return r;
  801000:	83 c4 10             	add    $0x10,%esp
}
  801003:	89 d8                	mov    %ebx,%eax
  801005:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801008:	5b                   	pop    %ebx
  801009:	5e                   	pop    %esi
  80100a:	5d                   	pop    %ebp
  80100b:	c3                   	ret    

0080100c <accept>:
{
  80100c:	55                   	push   %ebp
  80100d:	89 e5                	mov    %esp,%ebp
  80100f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801012:	8b 45 08             	mov    0x8(%ebp),%eax
  801015:	e8 4e ff ff ff       	call   800f68 <fd2sockid>
  80101a:	85 c0                	test   %eax,%eax
  80101c:	78 1b                	js     801039 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80101e:	83 ec 04             	sub    $0x4,%esp
  801021:	ff 75 10             	pushl  0x10(%ebp)
  801024:	ff 75 0c             	pushl  0xc(%ebp)
  801027:	50                   	push   %eax
  801028:	e8 0e 01 00 00       	call   80113b <nsipc_accept>
  80102d:	83 c4 10             	add    $0x10,%esp
  801030:	85 c0                	test   %eax,%eax
  801032:	78 05                	js     801039 <accept+0x2d>
	return alloc_sockfd(r);
  801034:	e8 5f ff ff ff       	call   800f98 <alloc_sockfd>
}
  801039:	c9                   	leave  
  80103a:	c3                   	ret    

0080103b <bind>:
{
  80103b:	55                   	push   %ebp
  80103c:	89 e5                	mov    %esp,%ebp
  80103e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801041:	8b 45 08             	mov    0x8(%ebp),%eax
  801044:	e8 1f ff ff ff       	call   800f68 <fd2sockid>
  801049:	85 c0                	test   %eax,%eax
  80104b:	78 12                	js     80105f <bind+0x24>
	return nsipc_bind(r, name, namelen);
  80104d:	83 ec 04             	sub    $0x4,%esp
  801050:	ff 75 10             	pushl  0x10(%ebp)
  801053:	ff 75 0c             	pushl  0xc(%ebp)
  801056:	50                   	push   %eax
  801057:	e8 2f 01 00 00       	call   80118b <nsipc_bind>
  80105c:	83 c4 10             	add    $0x10,%esp
}
  80105f:	c9                   	leave  
  801060:	c3                   	ret    

00801061 <shutdown>:
{
  801061:	55                   	push   %ebp
  801062:	89 e5                	mov    %esp,%ebp
  801064:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801067:	8b 45 08             	mov    0x8(%ebp),%eax
  80106a:	e8 f9 fe ff ff       	call   800f68 <fd2sockid>
  80106f:	85 c0                	test   %eax,%eax
  801071:	78 0f                	js     801082 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801073:	83 ec 08             	sub    $0x8,%esp
  801076:	ff 75 0c             	pushl  0xc(%ebp)
  801079:	50                   	push   %eax
  80107a:	e8 41 01 00 00       	call   8011c0 <nsipc_shutdown>
  80107f:	83 c4 10             	add    $0x10,%esp
}
  801082:	c9                   	leave  
  801083:	c3                   	ret    

00801084 <connect>:
{
  801084:	55                   	push   %ebp
  801085:	89 e5                	mov    %esp,%ebp
  801087:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80108a:	8b 45 08             	mov    0x8(%ebp),%eax
  80108d:	e8 d6 fe ff ff       	call   800f68 <fd2sockid>
  801092:	85 c0                	test   %eax,%eax
  801094:	78 12                	js     8010a8 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801096:	83 ec 04             	sub    $0x4,%esp
  801099:	ff 75 10             	pushl  0x10(%ebp)
  80109c:	ff 75 0c             	pushl  0xc(%ebp)
  80109f:	50                   	push   %eax
  8010a0:	e8 57 01 00 00       	call   8011fc <nsipc_connect>
  8010a5:	83 c4 10             	add    $0x10,%esp
}
  8010a8:	c9                   	leave  
  8010a9:	c3                   	ret    

008010aa <listen>:
{
  8010aa:	55                   	push   %ebp
  8010ab:	89 e5                	mov    %esp,%ebp
  8010ad:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8010b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b3:	e8 b0 fe ff ff       	call   800f68 <fd2sockid>
  8010b8:	85 c0                	test   %eax,%eax
  8010ba:	78 0f                	js     8010cb <listen+0x21>
	return nsipc_listen(r, backlog);
  8010bc:	83 ec 08             	sub    $0x8,%esp
  8010bf:	ff 75 0c             	pushl  0xc(%ebp)
  8010c2:	50                   	push   %eax
  8010c3:	e8 69 01 00 00       	call   801231 <nsipc_listen>
  8010c8:	83 c4 10             	add    $0x10,%esp
}
  8010cb:	c9                   	leave  
  8010cc:	c3                   	ret    

008010cd <socket>:

int
socket(int domain, int type, int protocol)
{
  8010cd:	55                   	push   %ebp
  8010ce:	89 e5                	mov    %esp,%ebp
  8010d0:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8010d3:	ff 75 10             	pushl  0x10(%ebp)
  8010d6:	ff 75 0c             	pushl  0xc(%ebp)
  8010d9:	ff 75 08             	pushl  0x8(%ebp)
  8010dc:	e8 3c 02 00 00       	call   80131d <nsipc_socket>
  8010e1:	83 c4 10             	add    $0x10,%esp
  8010e4:	85 c0                	test   %eax,%eax
  8010e6:	78 05                	js     8010ed <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8010e8:	e8 ab fe ff ff       	call   800f98 <alloc_sockfd>
}
  8010ed:	c9                   	leave  
  8010ee:	c3                   	ret    

008010ef <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8010ef:	55                   	push   %ebp
  8010f0:	89 e5                	mov    %esp,%ebp
  8010f2:	53                   	push   %ebx
  8010f3:	83 ec 04             	sub    $0x4,%esp
  8010f6:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8010f8:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  8010ff:	74 26                	je     801127 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801101:	6a 07                	push   $0x7
  801103:	68 00 60 80 00       	push   $0x806000
  801108:	53                   	push   %ebx
  801109:	ff 35 04 40 80 00    	pushl  0x804004
  80110f:	e8 ce 0e 00 00       	call   801fe2 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801114:	83 c4 0c             	add    $0xc,%esp
  801117:	6a 00                	push   $0x0
  801119:	6a 00                	push   $0x0
  80111b:	6a 00                	push   $0x0
  80111d:	e8 57 0e 00 00       	call   801f79 <ipc_recv>
}
  801122:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801125:	c9                   	leave  
  801126:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801127:	83 ec 0c             	sub    $0xc,%esp
  80112a:	6a 02                	push   $0x2
  80112c:	e8 0a 0f 00 00       	call   80203b <ipc_find_env>
  801131:	a3 04 40 80 00       	mov    %eax,0x804004
  801136:	83 c4 10             	add    $0x10,%esp
  801139:	eb c6                	jmp    801101 <nsipc+0x12>

0080113b <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80113b:	55                   	push   %ebp
  80113c:	89 e5                	mov    %esp,%ebp
  80113e:	56                   	push   %esi
  80113f:	53                   	push   %ebx
  801140:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801143:	8b 45 08             	mov    0x8(%ebp),%eax
  801146:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80114b:	8b 06                	mov    (%esi),%eax
  80114d:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801152:	b8 01 00 00 00       	mov    $0x1,%eax
  801157:	e8 93 ff ff ff       	call   8010ef <nsipc>
  80115c:	89 c3                	mov    %eax,%ebx
  80115e:	85 c0                	test   %eax,%eax
  801160:	78 20                	js     801182 <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801162:	83 ec 04             	sub    $0x4,%esp
  801165:	ff 35 10 60 80 00    	pushl  0x806010
  80116b:	68 00 60 80 00       	push   $0x806000
  801170:	ff 75 0c             	pushl  0xc(%ebp)
  801173:	e8 52 0c 00 00       	call   801dca <memmove>
		*addrlen = ret->ret_addrlen;
  801178:	a1 10 60 80 00       	mov    0x806010,%eax
  80117d:	89 06                	mov    %eax,(%esi)
  80117f:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  801182:	89 d8                	mov    %ebx,%eax
  801184:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801187:	5b                   	pop    %ebx
  801188:	5e                   	pop    %esi
  801189:	5d                   	pop    %ebp
  80118a:	c3                   	ret    

0080118b <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80118b:	55                   	push   %ebp
  80118c:	89 e5                	mov    %esp,%ebp
  80118e:	53                   	push   %ebx
  80118f:	83 ec 08             	sub    $0x8,%esp
  801192:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801195:	8b 45 08             	mov    0x8(%ebp),%eax
  801198:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80119d:	53                   	push   %ebx
  80119e:	ff 75 0c             	pushl  0xc(%ebp)
  8011a1:	68 04 60 80 00       	push   $0x806004
  8011a6:	e8 1f 0c 00 00       	call   801dca <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8011ab:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  8011b1:	b8 02 00 00 00       	mov    $0x2,%eax
  8011b6:	e8 34 ff ff ff       	call   8010ef <nsipc>
}
  8011bb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011be:	c9                   	leave  
  8011bf:	c3                   	ret    

008011c0 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8011c0:	55                   	push   %ebp
  8011c1:	89 e5                	mov    %esp,%ebp
  8011c3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8011c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c9:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  8011ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d1:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  8011d6:	b8 03 00 00 00       	mov    $0x3,%eax
  8011db:	e8 0f ff ff ff       	call   8010ef <nsipc>
}
  8011e0:	c9                   	leave  
  8011e1:	c3                   	ret    

008011e2 <nsipc_close>:

int
nsipc_close(int s)
{
  8011e2:	55                   	push   %ebp
  8011e3:	89 e5                	mov    %esp,%ebp
  8011e5:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8011e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011eb:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  8011f0:	b8 04 00 00 00       	mov    $0x4,%eax
  8011f5:	e8 f5 fe ff ff       	call   8010ef <nsipc>
}
  8011fa:	c9                   	leave  
  8011fb:	c3                   	ret    

008011fc <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8011fc:	55                   	push   %ebp
  8011fd:	89 e5                	mov    %esp,%ebp
  8011ff:	53                   	push   %ebx
  801200:	83 ec 08             	sub    $0x8,%esp
  801203:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801206:	8b 45 08             	mov    0x8(%ebp),%eax
  801209:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80120e:	53                   	push   %ebx
  80120f:	ff 75 0c             	pushl  0xc(%ebp)
  801212:	68 04 60 80 00       	push   $0x806004
  801217:	e8 ae 0b 00 00       	call   801dca <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80121c:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801222:	b8 05 00 00 00       	mov    $0x5,%eax
  801227:	e8 c3 fe ff ff       	call   8010ef <nsipc>
}
  80122c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80122f:	c9                   	leave  
  801230:	c3                   	ret    

00801231 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801231:	55                   	push   %ebp
  801232:	89 e5                	mov    %esp,%ebp
  801234:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801237:	8b 45 08             	mov    0x8(%ebp),%eax
  80123a:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  80123f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801242:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801247:	b8 06 00 00 00       	mov    $0x6,%eax
  80124c:	e8 9e fe ff ff       	call   8010ef <nsipc>
}
  801251:	c9                   	leave  
  801252:	c3                   	ret    

00801253 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801253:	55                   	push   %ebp
  801254:	89 e5                	mov    %esp,%ebp
  801256:	56                   	push   %esi
  801257:	53                   	push   %ebx
  801258:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  80125b:	8b 45 08             	mov    0x8(%ebp),%eax
  80125e:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801263:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801269:	8b 45 14             	mov    0x14(%ebp),%eax
  80126c:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801271:	b8 07 00 00 00       	mov    $0x7,%eax
  801276:	e8 74 fe ff ff       	call   8010ef <nsipc>
  80127b:	89 c3                	mov    %eax,%ebx
  80127d:	85 c0                	test   %eax,%eax
  80127f:	78 1f                	js     8012a0 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801281:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801286:	7f 21                	jg     8012a9 <nsipc_recv+0x56>
  801288:	39 c6                	cmp    %eax,%esi
  80128a:	7c 1d                	jl     8012a9 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80128c:	83 ec 04             	sub    $0x4,%esp
  80128f:	50                   	push   %eax
  801290:	68 00 60 80 00       	push   $0x806000
  801295:	ff 75 0c             	pushl  0xc(%ebp)
  801298:	e8 2d 0b 00 00       	call   801dca <memmove>
  80129d:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8012a0:	89 d8                	mov    %ebx,%eax
  8012a2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012a5:	5b                   	pop    %ebx
  8012a6:	5e                   	pop    %esi
  8012a7:	5d                   	pop    %ebp
  8012a8:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8012a9:	68 53 24 80 00       	push   $0x802453
  8012ae:	68 f5 23 80 00       	push   $0x8023f5
  8012b3:	6a 62                	push   $0x62
  8012b5:	68 68 24 80 00       	push   $0x802468
  8012ba:	e8 05 02 00 00       	call   8014c4 <_panic>

008012bf <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8012bf:	55                   	push   %ebp
  8012c0:	89 e5                	mov    %esp,%ebp
  8012c2:	53                   	push   %ebx
  8012c3:	83 ec 04             	sub    $0x4,%esp
  8012c6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8012c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cc:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  8012d1:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8012d7:	7f 2e                	jg     801307 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8012d9:	83 ec 04             	sub    $0x4,%esp
  8012dc:	53                   	push   %ebx
  8012dd:	ff 75 0c             	pushl  0xc(%ebp)
  8012e0:	68 0c 60 80 00       	push   $0x80600c
  8012e5:	e8 e0 0a 00 00       	call   801dca <memmove>
	nsipcbuf.send.req_size = size;
  8012ea:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  8012f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8012f3:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  8012f8:	b8 08 00 00 00       	mov    $0x8,%eax
  8012fd:	e8 ed fd ff ff       	call   8010ef <nsipc>
}
  801302:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801305:	c9                   	leave  
  801306:	c3                   	ret    
	assert(size < 1600);
  801307:	68 74 24 80 00       	push   $0x802474
  80130c:	68 f5 23 80 00       	push   $0x8023f5
  801311:	6a 6d                	push   $0x6d
  801313:	68 68 24 80 00       	push   $0x802468
  801318:	e8 a7 01 00 00       	call   8014c4 <_panic>

0080131d <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80131d:	55                   	push   %ebp
  80131e:	89 e5                	mov    %esp,%ebp
  801320:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801323:	8b 45 08             	mov    0x8(%ebp),%eax
  801326:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  80132b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80132e:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801333:	8b 45 10             	mov    0x10(%ebp),%eax
  801336:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  80133b:	b8 09 00 00 00       	mov    $0x9,%eax
  801340:	e8 aa fd ff ff       	call   8010ef <nsipc>
}
  801345:	c9                   	leave  
  801346:	c3                   	ret    

00801347 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801347:	55                   	push   %ebp
  801348:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  80134a:	b8 00 00 00 00       	mov    $0x0,%eax
  80134f:	5d                   	pop    %ebp
  801350:	c3                   	ret    

00801351 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801351:	55                   	push   %ebp
  801352:	89 e5                	mov    %esp,%ebp
  801354:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801357:	68 80 24 80 00       	push   $0x802480
  80135c:	ff 75 0c             	pushl  0xc(%ebp)
  80135f:	e8 d8 08 00 00       	call   801c3c <strcpy>
	return 0;
}
  801364:	b8 00 00 00 00       	mov    $0x0,%eax
  801369:	c9                   	leave  
  80136a:	c3                   	ret    

0080136b <devcons_write>:
{
  80136b:	55                   	push   %ebp
  80136c:	89 e5                	mov    %esp,%ebp
  80136e:	57                   	push   %edi
  80136f:	56                   	push   %esi
  801370:	53                   	push   %ebx
  801371:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801377:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80137c:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801382:	eb 2f                	jmp    8013b3 <devcons_write+0x48>
		m = n - tot;
  801384:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801387:	29 f3                	sub    %esi,%ebx
  801389:	83 fb 7f             	cmp    $0x7f,%ebx
  80138c:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801391:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801394:	83 ec 04             	sub    $0x4,%esp
  801397:	53                   	push   %ebx
  801398:	89 f0                	mov    %esi,%eax
  80139a:	03 45 0c             	add    0xc(%ebp),%eax
  80139d:	50                   	push   %eax
  80139e:	57                   	push   %edi
  80139f:	e8 26 0a 00 00       	call   801dca <memmove>
		sys_cputs(buf, m);
  8013a4:	83 c4 08             	add    $0x8,%esp
  8013a7:	53                   	push   %ebx
  8013a8:	57                   	push   %edi
  8013a9:	e8 eb ec ff ff       	call   800099 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8013ae:	01 de                	add    %ebx,%esi
  8013b0:	83 c4 10             	add    $0x10,%esp
  8013b3:	3b 75 10             	cmp    0x10(%ebp),%esi
  8013b6:	72 cc                	jb     801384 <devcons_write+0x19>
}
  8013b8:	89 f0                	mov    %esi,%eax
  8013ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013bd:	5b                   	pop    %ebx
  8013be:	5e                   	pop    %esi
  8013bf:	5f                   	pop    %edi
  8013c0:	5d                   	pop    %ebp
  8013c1:	c3                   	ret    

008013c2 <devcons_read>:
{
  8013c2:	55                   	push   %ebp
  8013c3:	89 e5                	mov    %esp,%ebp
  8013c5:	83 ec 08             	sub    $0x8,%esp
  8013c8:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8013cd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013d1:	75 07                	jne    8013da <devcons_read+0x18>
}
  8013d3:	c9                   	leave  
  8013d4:	c3                   	ret    
		sys_yield();
  8013d5:	e8 5c ed ff ff       	call   800136 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  8013da:	e8 d8 ec ff ff       	call   8000b7 <sys_cgetc>
  8013df:	85 c0                	test   %eax,%eax
  8013e1:	74 f2                	je     8013d5 <devcons_read+0x13>
	if (c < 0)
  8013e3:	85 c0                	test   %eax,%eax
  8013e5:	78 ec                	js     8013d3 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  8013e7:	83 f8 04             	cmp    $0x4,%eax
  8013ea:	74 0c                	je     8013f8 <devcons_read+0x36>
	*(char*)vbuf = c;
  8013ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013ef:	88 02                	mov    %al,(%edx)
	return 1;
  8013f1:	b8 01 00 00 00       	mov    $0x1,%eax
  8013f6:	eb db                	jmp    8013d3 <devcons_read+0x11>
		return 0;
  8013f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8013fd:	eb d4                	jmp    8013d3 <devcons_read+0x11>

008013ff <cputchar>:
{
  8013ff:	55                   	push   %ebp
  801400:	89 e5                	mov    %esp,%ebp
  801402:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801405:	8b 45 08             	mov    0x8(%ebp),%eax
  801408:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80140b:	6a 01                	push   $0x1
  80140d:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801410:	50                   	push   %eax
  801411:	e8 83 ec ff ff       	call   800099 <sys_cputs>
}
  801416:	83 c4 10             	add    $0x10,%esp
  801419:	c9                   	leave  
  80141a:	c3                   	ret    

0080141b <getchar>:
{
  80141b:	55                   	push   %ebp
  80141c:	89 e5                	mov    %esp,%ebp
  80141e:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801421:	6a 01                	push   $0x1
  801423:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801426:	50                   	push   %eax
  801427:	6a 00                	push   $0x0
  801429:	e8 1e f2 ff ff       	call   80064c <read>
	if (r < 0)
  80142e:	83 c4 10             	add    $0x10,%esp
  801431:	85 c0                	test   %eax,%eax
  801433:	78 08                	js     80143d <getchar+0x22>
	if (r < 1)
  801435:	85 c0                	test   %eax,%eax
  801437:	7e 06                	jle    80143f <getchar+0x24>
	return c;
  801439:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80143d:	c9                   	leave  
  80143e:	c3                   	ret    
		return -E_EOF;
  80143f:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801444:	eb f7                	jmp    80143d <getchar+0x22>

00801446 <iscons>:
{
  801446:	55                   	push   %ebp
  801447:	89 e5                	mov    %esp,%ebp
  801449:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80144c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80144f:	50                   	push   %eax
  801450:	ff 75 08             	pushl  0x8(%ebp)
  801453:	e8 83 ef ff ff       	call   8003db <fd_lookup>
  801458:	83 c4 10             	add    $0x10,%esp
  80145b:	85 c0                	test   %eax,%eax
  80145d:	78 11                	js     801470 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80145f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801462:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801468:	39 10                	cmp    %edx,(%eax)
  80146a:	0f 94 c0             	sete   %al
  80146d:	0f b6 c0             	movzbl %al,%eax
}
  801470:	c9                   	leave  
  801471:	c3                   	ret    

00801472 <opencons>:
{
  801472:	55                   	push   %ebp
  801473:	89 e5                	mov    %esp,%ebp
  801475:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801478:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80147b:	50                   	push   %eax
  80147c:	e8 0b ef ff ff       	call   80038c <fd_alloc>
  801481:	83 c4 10             	add    $0x10,%esp
  801484:	85 c0                	test   %eax,%eax
  801486:	78 3a                	js     8014c2 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801488:	83 ec 04             	sub    $0x4,%esp
  80148b:	68 07 04 00 00       	push   $0x407
  801490:	ff 75 f4             	pushl  -0xc(%ebp)
  801493:	6a 00                	push   $0x0
  801495:	e8 bb ec ff ff       	call   800155 <sys_page_alloc>
  80149a:	83 c4 10             	add    $0x10,%esp
  80149d:	85 c0                	test   %eax,%eax
  80149f:	78 21                	js     8014c2 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8014a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014a4:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8014aa:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8014ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014af:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8014b6:	83 ec 0c             	sub    $0xc,%esp
  8014b9:	50                   	push   %eax
  8014ba:	e8 a6 ee ff ff       	call   800365 <fd2num>
  8014bf:	83 c4 10             	add    $0x10,%esp
}
  8014c2:	c9                   	leave  
  8014c3:	c3                   	ret    

008014c4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8014c4:	55                   	push   %ebp
  8014c5:	89 e5                	mov    %esp,%ebp
  8014c7:	56                   	push   %esi
  8014c8:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8014c9:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8014cc:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8014d2:	e8 40 ec ff ff       	call   800117 <sys_getenvid>
  8014d7:	83 ec 0c             	sub    $0xc,%esp
  8014da:	ff 75 0c             	pushl  0xc(%ebp)
  8014dd:	ff 75 08             	pushl  0x8(%ebp)
  8014e0:	56                   	push   %esi
  8014e1:	50                   	push   %eax
  8014e2:	68 8c 24 80 00       	push   $0x80248c
  8014e7:	e8 b3 00 00 00       	call   80159f <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8014ec:	83 c4 18             	add    $0x18,%esp
  8014ef:	53                   	push   %ebx
  8014f0:	ff 75 10             	pushl  0x10(%ebp)
  8014f3:	e8 56 00 00 00       	call   80154e <vcprintf>
	cprintf("\n");
  8014f8:	c7 04 24 40 24 80 00 	movl   $0x802440,(%esp)
  8014ff:	e8 9b 00 00 00       	call   80159f <cprintf>
  801504:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801507:	cc                   	int3   
  801508:	eb fd                	jmp    801507 <_panic+0x43>

0080150a <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80150a:	55                   	push   %ebp
  80150b:	89 e5                	mov    %esp,%ebp
  80150d:	53                   	push   %ebx
  80150e:	83 ec 04             	sub    $0x4,%esp
  801511:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801514:	8b 13                	mov    (%ebx),%edx
  801516:	8d 42 01             	lea    0x1(%edx),%eax
  801519:	89 03                	mov    %eax,(%ebx)
  80151b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80151e:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801522:	3d ff 00 00 00       	cmp    $0xff,%eax
  801527:	74 09                	je     801532 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  801529:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80152d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801530:	c9                   	leave  
  801531:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  801532:	83 ec 08             	sub    $0x8,%esp
  801535:	68 ff 00 00 00       	push   $0xff
  80153a:	8d 43 08             	lea    0x8(%ebx),%eax
  80153d:	50                   	push   %eax
  80153e:	e8 56 eb ff ff       	call   800099 <sys_cputs>
		b->idx = 0;
  801543:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801549:	83 c4 10             	add    $0x10,%esp
  80154c:	eb db                	jmp    801529 <putch+0x1f>

0080154e <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80154e:	55                   	push   %ebp
  80154f:	89 e5                	mov    %esp,%ebp
  801551:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801557:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80155e:	00 00 00 
	b.cnt = 0;
  801561:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801568:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80156b:	ff 75 0c             	pushl  0xc(%ebp)
  80156e:	ff 75 08             	pushl  0x8(%ebp)
  801571:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801577:	50                   	push   %eax
  801578:	68 0a 15 80 00       	push   $0x80150a
  80157d:	e8 1a 01 00 00       	call   80169c <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801582:	83 c4 08             	add    $0x8,%esp
  801585:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80158b:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  801591:	50                   	push   %eax
  801592:	e8 02 eb ff ff       	call   800099 <sys_cputs>

	return b.cnt;
}
  801597:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80159d:	c9                   	leave  
  80159e:	c3                   	ret    

0080159f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80159f:	55                   	push   %ebp
  8015a0:	89 e5                	mov    %esp,%ebp
  8015a2:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8015a5:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8015a8:	50                   	push   %eax
  8015a9:	ff 75 08             	pushl  0x8(%ebp)
  8015ac:	e8 9d ff ff ff       	call   80154e <vcprintf>
	va_end(ap);

	return cnt;
}
  8015b1:	c9                   	leave  
  8015b2:	c3                   	ret    

008015b3 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8015b3:	55                   	push   %ebp
  8015b4:	89 e5                	mov    %esp,%ebp
  8015b6:	57                   	push   %edi
  8015b7:	56                   	push   %esi
  8015b8:	53                   	push   %ebx
  8015b9:	83 ec 1c             	sub    $0x1c,%esp
  8015bc:	89 c7                	mov    %eax,%edi
  8015be:	89 d6                	mov    %edx,%esi
  8015c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015c6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8015c9:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8015cc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015cf:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015d4:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8015d7:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8015da:	39 d3                	cmp    %edx,%ebx
  8015dc:	72 05                	jb     8015e3 <printnum+0x30>
  8015de:	39 45 10             	cmp    %eax,0x10(%ebp)
  8015e1:	77 7a                	ja     80165d <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8015e3:	83 ec 0c             	sub    $0xc,%esp
  8015e6:	ff 75 18             	pushl  0x18(%ebp)
  8015e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8015ec:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8015ef:	53                   	push   %ebx
  8015f0:	ff 75 10             	pushl  0x10(%ebp)
  8015f3:	83 ec 08             	sub    $0x8,%esp
  8015f6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8015f9:	ff 75 e0             	pushl  -0x20(%ebp)
  8015fc:	ff 75 dc             	pushl  -0x24(%ebp)
  8015ff:	ff 75 d8             	pushl  -0x28(%ebp)
  801602:	e8 a9 0a 00 00       	call   8020b0 <__udivdi3>
  801607:	83 c4 18             	add    $0x18,%esp
  80160a:	52                   	push   %edx
  80160b:	50                   	push   %eax
  80160c:	89 f2                	mov    %esi,%edx
  80160e:	89 f8                	mov    %edi,%eax
  801610:	e8 9e ff ff ff       	call   8015b3 <printnum>
  801615:	83 c4 20             	add    $0x20,%esp
  801618:	eb 13                	jmp    80162d <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80161a:	83 ec 08             	sub    $0x8,%esp
  80161d:	56                   	push   %esi
  80161e:	ff 75 18             	pushl  0x18(%ebp)
  801621:	ff d7                	call   *%edi
  801623:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  801626:	83 eb 01             	sub    $0x1,%ebx
  801629:	85 db                	test   %ebx,%ebx
  80162b:	7f ed                	jg     80161a <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80162d:	83 ec 08             	sub    $0x8,%esp
  801630:	56                   	push   %esi
  801631:	83 ec 04             	sub    $0x4,%esp
  801634:	ff 75 e4             	pushl  -0x1c(%ebp)
  801637:	ff 75 e0             	pushl  -0x20(%ebp)
  80163a:	ff 75 dc             	pushl  -0x24(%ebp)
  80163d:	ff 75 d8             	pushl  -0x28(%ebp)
  801640:	e8 8b 0b 00 00       	call   8021d0 <__umoddi3>
  801645:	83 c4 14             	add    $0x14,%esp
  801648:	0f be 80 af 24 80 00 	movsbl 0x8024af(%eax),%eax
  80164f:	50                   	push   %eax
  801650:	ff d7                	call   *%edi
}
  801652:	83 c4 10             	add    $0x10,%esp
  801655:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801658:	5b                   	pop    %ebx
  801659:	5e                   	pop    %esi
  80165a:	5f                   	pop    %edi
  80165b:	5d                   	pop    %ebp
  80165c:	c3                   	ret    
  80165d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801660:	eb c4                	jmp    801626 <printnum+0x73>

00801662 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801662:	55                   	push   %ebp
  801663:	89 e5                	mov    %esp,%ebp
  801665:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801668:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80166c:	8b 10                	mov    (%eax),%edx
  80166e:	3b 50 04             	cmp    0x4(%eax),%edx
  801671:	73 0a                	jae    80167d <sprintputch+0x1b>
		*b->buf++ = ch;
  801673:	8d 4a 01             	lea    0x1(%edx),%ecx
  801676:	89 08                	mov    %ecx,(%eax)
  801678:	8b 45 08             	mov    0x8(%ebp),%eax
  80167b:	88 02                	mov    %al,(%edx)
}
  80167d:	5d                   	pop    %ebp
  80167e:	c3                   	ret    

0080167f <printfmt>:
{
  80167f:	55                   	push   %ebp
  801680:	89 e5                	mov    %esp,%ebp
  801682:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  801685:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  801688:	50                   	push   %eax
  801689:	ff 75 10             	pushl  0x10(%ebp)
  80168c:	ff 75 0c             	pushl  0xc(%ebp)
  80168f:	ff 75 08             	pushl  0x8(%ebp)
  801692:	e8 05 00 00 00       	call   80169c <vprintfmt>
}
  801697:	83 c4 10             	add    $0x10,%esp
  80169a:	c9                   	leave  
  80169b:	c3                   	ret    

0080169c <vprintfmt>:
{
  80169c:	55                   	push   %ebp
  80169d:	89 e5                	mov    %esp,%ebp
  80169f:	57                   	push   %edi
  8016a0:	56                   	push   %esi
  8016a1:	53                   	push   %ebx
  8016a2:	83 ec 2c             	sub    $0x2c,%esp
  8016a5:	8b 75 08             	mov    0x8(%ebp),%esi
  8016a8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8016ab:	8b 7d 10             	mov    0x10(%ebp),%edi
  8016ae:	e9 21 04 00 00       	jmp    801ad4 <vprintfmt+0x438>
		padc = ' ';
  8016b3:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8016b7:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8016be:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  8016c5:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8016cc:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8016d1:	8d 47 01             	lea    0x1(%edi),%eax
  8016d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8016d7:	0f b6 17             	movzbl (%edi),%edx
  8016da:	8d 42 dd             	lea    -0x23(%edx),%eax
  8016dd:	3c 55                	cmp    $0x55,%al
  8016df:	0f 87 90 04 00 00    	ja     801b75 <vprintfmt+0x4d9>
  8016e5:	0f b6 c0             	movzbl %al,%eax
  8016e8:	ff 24 85 00 26 80 00 	jmp    *0x802600(,%eax,4)
  8016ef:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8016f2:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8016f6:	eb d9                	jmp    8016d1 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8016f8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8016fb:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8016ff:	eb d0                	jmp    8016d1 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  801701:	0f b6 d2             	movzbl %dl,%edx
  801704:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  801707:	b8 00 00 00 00       	mov    $0x0,%eax
  80170c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80170f:	8d 04 80             	lea    (%eax,%eax,4),%eax
  801712:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  801716:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  801719:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80171c:	83 f9 09             	cmp    $0x9,%ecx
  80171f:	77 55                	ja     801776 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  801721:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  801724:	eb e9                	jmp    80170f <vprintfmt+0x73>
			precision = va_arg(ap, int);
  801726:	8b 45 14             	mov    0x14(%ebp),%eax
  801729:	8b 00                	mov    (%eax),%eax
  80172b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80172e:	8b 45 14             	mov    0x14(%ebp),%eax
  801731:	8d 40 04             	lea    0x4(%eax),%eax
  801734:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801737:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80173a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80173e:	79 91                	jns    8016d1 <vprintfmt+0x35>
				width = precision, precision = -1;
  801740:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801743:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801746:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80174d:	eb 82                	jmp    8016d1 <vprintfmt+0x35>
  80174f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801752:	85 c0                	test   %eax,%eax
  801754:	ba 00 00 00 00       	mov    $0x0,%edx
  801759:	0f 49 d0             	cmovns %eax,%edx
  80175c:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80175f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801762:	e9 6a ff ff ff       	jmp    8016d1 <vprintfmt+0x35>
  801767:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80176a:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  801771:	e9 5b ff ff ff       	jmp    8016d1 <vprintfmt+0x35>
  801776:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  801779:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80177c:	eb bc                	jmp    80173a <vprintfmt+0x9e>
			lflag++;
  80177e:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801781:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  801784:	e9 48 ff ff ff       	jmp    8016d1 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  801789:	8b 45 14             	mov    0x14(%ebp),%eax
  80178c:	8d 78 04             	lea    0x4(%eax),%edi
  80178f:	83 ec 08             	sub    $0x8,%esp
  801792:	53                   	push   %ebx
  801793:	ff 30                	pushl  (%eax)
  801795:	ff d6                	call   *%esi
			break;
  801797:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80179a:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80179d:	e9 2f 03 00 00       	jmp    801ad1 <vprintfmt+0x435>
			err = va_arg(ap, int);
  8017a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8017a5:	8d 78 04             	lea    0x4(%eax),%edi
  8017a8:	8b 00                	mov    (%eax),%eax
  8017aa:	99                   	cltd   
  8017ab:	31 d0                	xor    %edx,%eax
  8017ad:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8017af:	83 f8 0f             	cmp    $0xf,%eax
  8017b2:	7f 23                	jg     8017d7 <vprintfmt+0x13b>
  8017b4:	8b 14 85 60 27 80 00 	mov    0x802760(,%eax,4),%edx
  8017bb:	85 d2                	test   %edx,%edx
  8017bd:	74 18                	je     8017d7 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  8017bf:	52                   	push   %edx
  8017c0:	68 07 24 80 00       	push   $0x802407
  8017c5:	53                   	push   %ebx
  8017c6:	56                   	push   %esi
  8017c7:	e8 b3 fe ff ff       	call   80167f <printfmt>
  8017cc:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8017cf:	89 7d 14             	mov    %edi,0x14(%ebp)
  8017d2:	e9 fa 02 00 00       	jmp    801ad1 <vprintfmt+0x435>
				printfmt(putch, putdat, "error %d", err);
  8017d7:	50                   	push   %eax
  8017d8:	68 c7 24 80 00       	push   $0x8024c7
  8017dd:	53                   	push   %ebx
  8017de:	56                   	push   %esi
  8017df:	e8 9b fe ff ff       	call   80167f <printfmt>
  8017e4:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8017e7:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8017ea:	e9 e2 02 00 00       	jmp    801ad1 <vprintfmt+0x435>
			if ((p = va_arg(ap, char *)) == NULL)
  8017ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8017f2:	83 c0 04             	add    $0x4,%eax
  8017f5:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8017f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8017fb:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8017fd:	85 ff                	test   %edi,%edi
  8017ff:	b8 c0 24 80 00       	mov    $0x8024c0,%eax
  801804:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  801807:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80180b:	0f 8e bd 00 00 00    	jle    8018ce <vprintfmt+0x232>
  801811:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  801815:	75 0e                	jne    801825 <vprintfmt+0x189>
  801817:	89 75 08             	mov    %esi,0x8(%ebp)
  80181a:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80181d:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  801820:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  801823:	eb 6d                	jmp    801892 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  801825:	83 ec 08             	sub    $0x8,%esp
  801828:	ff 75 d0             	pushl  -0x30(%ebp)
  80182b:	57                   	push   %edi
  80182c:	e8 ec 03 00 00       	call   801c1d <strnlen>
  801831:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  801834:	29 c1                	sub    %eax,%ecx
  801836:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  801839:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  80183c:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  801840:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801843:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  801846:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  801848:	eb 0f                	jmp    801859 <vprintfmt+0x1bd>
					putch(padc, putdat);
  80184a:	83 ec 08             	sub    $0x8,%esp
  80184d:	53                   	push   %ebx
  80184e:	ff 75 e0             	pushl  -0x20(%ebp)
  801851:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  801853:	83 ef 01             	sub    $0x1,%edi
  801856:	83 c4 10             	add    $0x10,%esp
  801859:	85 ff                	test   %edi,%edi
  80185b:	7f ed                	jg     80184a <vprintfmt+0x1ae>
  80185d:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  801860:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  801863:	85 c9                	test   %ecx,%ecx
  801865:	b8 00 00 00 00       	mov    $0x0,%eax
  80186a:	0f 49 c1             	cmovns %ecx,%eax
  80186d:	29 c1                	sub    %eax,%ecx
  80186f:	89 75 08             	mov    %esi,0x8(%ebp)
  801872:	8b 75 d0             	mov    -0x30(%ebp),%esi
  801875:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  801878:	89 cb                	mov    %ecx,%ebx
  80187a:	eb 16                	jmp    801892 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  80187c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801880:	75 31                	jne    8018b3 <vprintfmt+0x217>
					putch(ch, putdat);
  801882:	83 ec 08             	sub    $0x8,%esp
  801885:	ff 75 0c             	pushl  0xc(%ebp)
  801888:	50                   	push   %eax
  801889:	ff 55 08             	call   *0x8(%ebp)
  80188c:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80188f:	83 eb 01             	sub    $0x1,%ebx
  801892:	83 c7 01             	add    $0x1,%edi
  801895:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  801899:	0f be c2             	movsbl %dl,%eax
  80189c:	85 c0                	test   %eax,%eax
  80189e:	74 59                	je     8018f9 <vprintfmt+0x25d>
  8018a0:	85 f6                	test   %esi,%esi
  8018a2:	78 d8                	js     80187c <vprintfmt+0x1e0>
  8018a4:	83 ee 01             	sub    $0x1,%esi
  8018a7:	79 d3                	jns    80187c <vprintfmt+0x1e0>
  8018a9:	89 df                	mov    %ebx,%edi
  8018ab:	8b 75 08             	mov    0x8(%ebp),%esi
  8018ae:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8018b1:	eb 37                	jmp    8018ea <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  8018b3:	0f be d2             	movsbl %dl,%edx
  8018b6:	83 ea 20             	sub    $0x20,%edx
  8018b9:	83 fa 5e             	cmp    $0x5e,%edx
  8018bc:	76 c4                	jbe    801882 <vprintfmt+0x1e6>
					putch('?', putdat);
  8018be:	83 ec 08             	sub    $0x8,%esp
  8018c1:	ff 75 0c             	pushl  0xc(%ebp)
  8018c4:	6a 3f                	push   $0x3f
  8018c6:	ff 55 08             	call   *0x8(%ebp)
  8018c9:	83 c4 10             	add    $0x10,%esp
  8018cc:	eb c1                	jmp    80188f <vprintfmt+0x1f3>
  8018ce:	89 75 08             	mov    %esi,0x8(%ebp)
  8018d1:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8018d4:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8018d7:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8018da:	eb b6                	jmp    801892 <vprintfmt+0x1f6>
				putch(' ', putdat);
  8018dc:	83 ec 08             	sub    $0x8,%esp
  8018df:	53                   	push   %ebx
  8018e0:	6a 20                	push   $0x20
  8018e2:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8018e4:	83 ef 01             	sub    $0x1,%edi
  8018e7:	83 c4 10             	add    $0x10,%esp
  8018ea:	85 ff                	test   %edi,%edi
  8018ec:	7f ee                	jg     8018dc <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  8018ee:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8018f1:	89 45 14             	mov    %eax,0x14(%ebp)
  8018f4:	e9 d8 01 00 00       	jmp    801ad1 <vprintfmt+0x435>
  8018f9:	89 df                	mov    %ebx,%edi
  8018fb:	8b 75 08             	mov    0x8(%ebp),%esi
  8018fe:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801901:	eb e7                	jmp    8018ea <vprintfmt+0x24e>
	if (lflag >= 2)
  801903:	83 f9 01             	cmp    $0x1,%ecx
  801906:	7e 45                	jle    80194d <vprintfmt+0x2b1>
		return va_arg(*ap, long long);
  801908:	8b 45 14             	mov    0x14(%ebp),%eax
  80190b:	8b 50 04             	mov    0x4(%eax),%edx
  80190e:	8b 00                	mov    (%eax),%eax
  801910:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801913:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801916:	8b 45 14             	mov    0x14(%ebp),%eax
  801919:	8d 40 08             	lea    0x8(%eax),%eax
  80191c:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80191f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801923:	79 62                	jns    801987 <vprintfmt+0x2eb>
				putch('-', putdat);
  801925:	83 ec 08             	sub    $0x8,%esp
  801928:	53                   	push   %ebx
  801929:	6a 2d                	push   $0x2d
  80192b:	ff d6                	call   *%esi
				num = -(long long) num;
  80192d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801930:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801933:	f7 d8                	neg    %eax
  801935:	83 d2 00             	adc    $0x0,%edx
  801938:	f7 da                	neg    %edx
  80193a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80193d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801940:	83 c4 10             	add    $0x10,%esp
			base = 10;
  801943:	ba 0a 00 00 00       	mov    $0xa,%edx
  801948:	e9 66 01 00 00       	jmp    801ab3 <vprintfmt+0x417>
	else if (lflag)
  80194d:	85 c9                	test   %ecx,%ecx
  80194f:	75 1b                	jne    80196c <vprintfmt+0x2d0>
		return va_arg(*ap, int);
  801951:	8b 45 14             	mov    0x14(%ebp),%eax
  801954:	8b 00                	mov    (%eax),%eax
  801956:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801959:	89 c1                	mov    %eax,%ecx
  80195b:	c1 f9 1f             	sar    $0x1f,%ecx
  80195e:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  801961:	8b 45 14             	mov    0x14(%ebp),%eax
  801964:	8d 40 04             	lea    0x4(%eax),%eax
  801967:	89 45 14             	mov    %eax,0x14(%ebp)
  80196a:	eb b3                	jmp    80191f <vprintfmt+0x283>
		return va_arg(*ap, long);
  80196c:	8b 45 14             	mov    0x14(%ebp),%eax
  80196f:	8b 00                	mov    (%eax),%eax
  801971:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801974:	89 c1                	mov    %eax,%ecx
  801976:	c1 f9 1f             	sar    $0x1f,%ecx
  801979:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80197c:	8b 45 14             	mov    0x14(%ebp),%eax
  80197f:	8d 40 04             	lea    0x4(%eax),%eax
  801982:	89 45 14             	mov    %eax,0x14(%ebp)
  801985:	eb 98                	jmp    80191f <vprintfmt+0x283>
			base = 10;
  801987:	ba 0a 00 00 00       	mov    $0xa,%edx
  80198c:	e9 22 01 00 00       	jmp    801ab3 <vprintfmt+0x417>
	if (lflag >= 2)
  801991:	83 f9 01             	cmp    $0x1,%ecx
  801994:	7e 21                	jle    8019b7 <vprintfmt+0x31b>
		return va_arg(*ap, unsigned long long);
  801996:	8b 45 14             	mov    0x14(%ebp),%eax
  801999:	8b 50 04             	mov    0x4(%eax),%edx
  80199c:	8b 00                	mov    (%eax),%eax
  80199e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8019a1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8019a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8019a7:	8d 40 08             	lea    0x8(%eax),%eax
  8019aa:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8019ad:	ba 0a 00 00 00       	mov    $0xa,%edx
  8019b2:	e9 fc 00 00 00       	jmp    801ab3 <vprintfmt+0x417>
	else if (lflag)
  8019b7:	85 c9                	test   %ecx,%ecx
  8019b9:	75 23                	jne    8019de <vprintfmt+0x342>
		return va_arg(*ap, unsigned int);
  8019bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8019be:	8b 00                	mov    (%eax),%eax
  8019c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8019c5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8019c8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8019cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8019ce:	8d 40 04             	lea    0x4(%eax),%eax
  8019d1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8019d4:	ba 0a 00 00 00       	mov    $0xa,%edx
  8019d9:	e9 d5 00 00 00       	jmp    801ab3 <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  8019de:	8b 45 14             	mov    0x14(%ebp),%eax
  8019e1:	8b 00                	mov    (%eax),%eax
  8019e3:	ba 00 00 00 00       	mov    $0x0,%edx
  8019e8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8019eb:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8019ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8019f1:	8d 40 04             	lea    0x4(%eax),%eax
  8019f4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8019f7:	ba 0a 00 00 00       	mov    $0xa,%edx
  8019fc:	e9 b2 00 00 00       	jmp    801ab3 <vprintfmt+0x417>
	if (lflag >= 2)
  801a01:	83 f9 01             	cmp    $0x1,%ecx
  801a04:	7e 42                	jle    801a48 <vprintfmt+0x3ac>
		return va_arg(*ap, unsigned long long);
  801a06:	8b 45 14             	mov    0x14(%ebp),%eax
  801a09:	8b 50 04             	mov    0x4(%eax),%edx
  801a0c:	8b 00                	mov    (%eax),%eax
  801a0e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801a11:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801a14:	8b 45 14             	mov    0x14(%ebp),%eax
  801a17:	8d 40 08             	lea    0x8(%eax),%eax
  801a1a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801a1d:	ba 08 00 00 00       	mov    $0x8,%edx
			if ((long long) num < 0) {
  801a22:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801a26:	0f 89 87 00 00 00    	jns    801ab3 <vprintfmt+0x417>
				putch('-', putdat);
  801a2c:	83 ec 08             	sub    $0x8,%esp
  801a2f:	53                   	push   %ebx
  801a30:	6a 2d                	push   $0x2d
  801a32:	ff d6                	call   *%esi
				num = -(long long) num;
  801a34:	f7 5d d8             	negl   -0x28(%ebp)
  801a37:	83 55 dc 00          	adcl   $0x0,-0x24(%ebp)
  801a3b:	f7 5d dc             	negl   -0x24(%ebp)
  801a3e:	83 c4 10             	add    $0x10,%esp
			base = 8;
  801a41:	ba 08 00 00 00       	mov    $0x8,%edx
  801a46:	eb 6b                	jmp    801ab3 <vprintfmt+0x417>
	else if (lflag)
  801a48:	85 c9                	test   %ecx,%ecx
  801a4a:	75 1b                	jne    801a67 <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  801a4c:	8b 45 14             	mov    0x14(%ebp),%eax
  801a4f:	8b 00                	mov    (%eax),%eax
  801a51:	ba 00 00 00 00       	mov    $0x0,%edx
  801a56:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801a59:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801a5c:	8b 45 14             	mov    0x14(%ebp),%eax
  801a5f:	8d 40 04             	lea    0x4(%eax),%eax
  801a62:	89 45 14             	mov    %eax,0x14(%ebp)
  801a65:	eb b6                	jmp    801a1d <vprintfmt+0x381>
		return va_arg(*ap, unsigned long);
  801a67:	8b 45 14             	mov    0x14(%ebp),%eax
  801a6a:	8b 00                	mov    (%eax),%eax
  801a6c:	ba 00 00 00 00       	mov    $0x0,%edx
  801a71:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801a74:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801a77:	8b 45 14             	mov    0x14(%ebp),%eax
  801a7a:	8d 40 04             	lea    0x4(%eax),%eax
  801a7d:	89 45 14             	mov    %eax,0x14(%ebp)
  801a80:	eb 9b                	jmp    801a1d <vprintfmt+0x381>
			putch('0', putdat);
  801a82:	83 ec 08             	sub    $0x8,%esp
  801a85:	53                   	push   %ebx
  801a86:	6a 30                	push   $0x30
  801a88:	ff d6                	call   *%esi
			putch('x', putdat);
  801a8a:	83 c4 08             	add    $0x8,%esp
  801a8d:	53                   	push   %ebx
  801a8e:	6a 78                	push   $0x78
  801a90:	ff d6                	call   *%esi
			num = (unsigned long long)
  801a92:	8b 45 14             	mov    0x14(%ebp),%eax
  801a95:	8b 00                	mov    (%eax),%eax
  801a97:	ba 00 00 00 00       	mov    $0x0,%edx
  801a9c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801a9f:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  801aa2:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  801aa5:	8b 45 14             	mov    0x14(%ebp),%eax
  801aa8:	8d 40 04             	lea    0x4(%eax),%eax
  801aab:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801aae:	ba 10 00 00 00       	mov    $0x10,%edx
			printnum(putch, putdat, num, base, width, padc);
  801ab3:	83 ec 0c             	sub    $0xc,%esp
  801ab6:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  801aba:	50                   	push   %eax
  801abb:	ff 75 e0             	pushl  -0x20(%ebp)
  801abe:	52                   	push   %edx
  801abf:	ff 75 dc             	pushl  -0x24(%ebp)
  801ac2:	ff 75 d8             	pushl  -0x28(%ebp)
  801ac5:	89 da                	mov    %ebx,%edx
  801ac7:	89 f0                	mov    %esi,%eax
  801ac9:	e8 e5 fa ff ff       	call   8015b3 <printnum>
			break;
  801ace:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  801ad1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801ad4:	83 c7 01             	add    $0x1,%edi
  801ad7:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801adb:	83 f8 25             	cmp    $0x25,%eax
  801ade:	0f 84 cf fb ff ff    	je     8016b3 <vprintfmt+0x17>
			if (ch == '\0')
  801ae4:	85 c0                	test   %eax,%eax
  801ae6:	0f 84 a9 00 00 00    	je     801b95 <vprintfmt+0x4f9>
			putch(ch, putdat);
  801aec:	83 ec 08             	sub    $0x8,%esp
  801aef:	53                   	push   %ebx
  801af0:	50                   	push   %eax
  801af1:	ff d6                	call   *%esi
  801af3:	83 c4 10             	add    $0x10,%esp
  801af6:	eb dc                	jmp    801ad4 <vprintfmt+0x438>
	if (lflag >= 2)
  801af8:	83 f9 01             	cmp    $0x1,%ecx
  801afb:	7e 1e                	jle    801b1b <vprintfmt+0x47f>
		return va_arg(*ap, unsigned long long);
  801afd:	8b 45 14             	mov    0x14(%ebp),%eax
  801b00:	8b 50 04             	mov    0x4(%eax),%edx
  801b03:	8b 00                	mov    (%eax),%eax
  801b05:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801b08:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801b0b:	8b 45 14             	mov    0x14(%ebp),%eax
  801b0e:	8d 40 08             	lea    0x8(%eax),%eax
  801b11:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801b14:	ba 10 00 00 00       	mov    $0x10,%edx
  801b19:	eb 98                	jmp    801ab3 <vprintfmt+0x417>
	else if (lflag)
  801b1b:	85 c9                	test   %ecx,%ecx
  801b1d:	75 23                	jne    801b42 <vprintfmt+0x4a6>
		return va_arg(*ap, unsigned int);
  801b1f:	8b 45 14             	mov    0x14(%ebp),%eax
  801b22:	8b 00                	mov    (%eax),%eax
  801b24:	ba 00 00 00 00       	mov    $0x0,%edx
  801b29:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801b2c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801b2f:	8b 45 14             	mov    0x14(%ebp),%eax
  801b32:	8d 40 04             	lea    0x4(%eax),%eax
  801b35:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801b38:	ba 10 00 00 00       	mov    $0x10,%edx
  801b3d:	e9 71 ff ff ff       	jmp    801ab3 <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  801b42:	8b 45 14             	mov    0x14(%ebp),%eax
  801b45:	8b 00                	mov    (%eax),%eax
  801b47:	ba 00 00 00 00       	mov    $0x0,%edx
  801b4c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801b4f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801b52:	8b 45 14             	mov    0x14(%ebp),%eax
  801b55:	8d 40 04             	lea    0x4(%eax),%eax
  801b58:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801b5b:	ba 10 00 00 00       	mov    $0x10,%edx
  801b60:	e9 4e ff ff ff       	jmp    801ab3 <vprintfmt+0x417>
			putch(ch, putdat);
  801b65:	83 ec 08             	sub    $0x8,%esp
  801b68:	53                   	push   %ebx
  801b69:	6a 25                	push   $0x25
  801b6b:	ff d6                	call   *%esi
			break;
  801b6d:	83 c4 10             	add    $0x10,%esp
  801b70:	e9 5c ff ff ff       	jmp    801ad1 <vprintfmt+0x435>
			putch('%', putdat);
  801b75:	83 ec 08             	sub    $0x8,%esp
  801b78:	53                   	push   %ebx
  801b79:	6a 25                	push   $0x25
  801b7b:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  801b7d:	83 c4 10             	add    $0x10,%esp
  801b80:	89 f8                	mov    %edi,%eax
  801b82:	eb 03                	jmp    801b87 <vprintfmt+0x4eb>
  801b84:	83 e8 01             	sub    $0x1,%eax
  801b87:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  801b8b:	75 f7                	jne    801b84 <vprintfmt+0x4e8>
  801b8d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801b90:	e9 3c ff ff ff       	jmp    801ad1 <vprintfmt+0x435>
}
  801b95:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b98:	5b                   	pop    %ebx
  801b99:	5e                   	pop    %esi
  801b9a:	5f                   	pop    %edi
  801b9b:	5d                   	pop    %ebp
  801b9c:	c3                   	ret    

00801b9d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801b9d:	55                   	push   %ebp
  801b9e:	89 e5                	mov    %esp,%ebp
  801ba0:	83 ec 18             	sub    $0x18,%esp
  801ba3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba6:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801ba9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801bac:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801bb0:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801bb3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801bba:	85 c0                	test   %eax,%eax
  801bbc:	74 26                	je     801be4 <vsnprintf+0x47>
  801bbe:	85 d2                	test   %edx,%edx
  801bc0:	7e 22                	jle    801be4 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801bc2:	ff 75 14             	pushl  0x14(%ebp)
  801bc5:	ff 75 10             	pushl  0x10(%ebp)
  801bc8:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801bcb:	50                   	push   %eax
  801bcc:	68 62 16 80 00       	push   $0x801662
  801bd1:	e8 c6 fa ff ff       	call   80169c <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801bd6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bd9:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801bdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bdf:	83 c4 10             	add    $0x10,%esp
}
  801be2:	c9                   	leave  
  801be3:	c3                   	ret    
		return -E_INVAL;
  801be4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801be9:	eb f7                	jmp    801be2 <vsnprintf+0x45>

00801beb <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801beb:	55                   	push   %ebp
  801bec:	89 e5                	mov    %esp,%ebp
  801bee:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801bf1:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801bf4:	50                   	push   %eax
  801bf5:	ff 75 10             	pushl  0x10(%ebp)
  801bf8:	ff 75 0c             	pushl  0xc(%ebp)
  801bfb:	ff 75 08             	pushl  0x8(%ebp)
  801bfe:	e8 9a ff ff ff       	call   801b9d <vsnprintf>
	va_end(ap);

	return rc;
}
  801c03:	c9                   	leave  
  801c04:	c3                   	ret    

00801c05 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801c05:	55                   	push   %ebp
  801c06:	89 e5                	mov    %esp,%ebp
  801c08:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801c0b:	b8 00 00 00 00       	mov    $0x0,%eax
  801c10:	eb 03                	jmp    801c15 <strlen+0x10>
		n++;
  801c12:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  801c15:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801c19:	75 f7                	jne    801c12 <strlen+0xd>
	return n;
}
  801c1b:	5d                   	pop    %ebp
  801c1c:	c3                   	ret    

00801c1d <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801c1d:	55                   	push   %ebp
  801c1e:	89 e5                	mov    %esp,%ebp
  801c20:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c23:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801c26:	b8 00 00 00 00       	mov    $0x0,%eax
  801c2b:	eb 03                	jmp    801c30 <strnlen+0x13>
		n++;
  801c2d:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801c30:	39 d0                	cmp    %edx,%eax
  801c32:	74 06                	je     801c3a <strnlen+0x1d>
  801c34:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  801c38:	75 f3                	jne    801c2d <strnlen+0x10>
	return n;
}
  801c3a:	5d                   	pop    %ebp
  801c3b:	c3                   	ret    

00801c3c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801c3c:	55                   	push   %ebp
  801c3d:	89 e5                	mov    %esp,%ebp
  801c3f:	53                   	push   %ebx
  801c40:	8b 45 08             	mov    0x8(%ebp),%eax
  801c43:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801c46:	89 c2                	mov    %eax,%edx
  801c48:	83 c1 01             	add    $0x1,%ecx
  801c4b:	83 c2 01             	add    $0x1,%edx
  801c4e:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  801c52:	88 5a ff             	mov    %bl,-0x1(%edx)
  801c55:	84 db                	test   %bl,%bl
  801c57:	75 ef                	jne    801c48 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  801c59:	5b                   	pop    %ebx
  801c5a:	5d                   	pop    %ebp
  801c5b:	c3                   	ret    

00801c5c <strcat>:

char *
strcat(char *dst, const char *src)
{
  801c5c:	55                   	push   %ebp
  801c5d:	89 e5                	mov    %esp,%ebp
  801c5f:	53                   	push   %ebx
  801c60:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801c63:	53                   	push   %ebx
  801c64:	e8 9c ff ff ff       	call   801c05 <strlen>
  801c69:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  801c6c:	ff 75 0c             	pushl  0xc(%ebp)
  801c6f:	01 d8                	add    %ebx,%eax
  801c71:	50                   	push   %eax
  801c72:	e8 c5 ff ff ff       	call   801c3c <strcpy>
	return dst;
}
  801c77:	89 d8                	mov    %ebx,%eax
  801c79:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c7c:	c9                   	leave  
  801c7d:	c3                   	ret    

00801c7e <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801c7e:	55                   	push   %ebp
  801c7f:	89 e5                	mov    %esp,%ebp
  801c81:	56                   	push   %esi
  801c82:	53                   	push   %ebx
  801c83:	8b 75 08             	mov    0x8(%ebp),%esi
  801c86:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c89:	89 f3                	mov    %esi,%ebx
  801c8b:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801c8e:	89 f2                	mov    %esi,%edx
  801c90:	eb 0f                	jmp    801ca1 <strncpy+0x23>
		*dst++ = *src;
  801c92:	83 c2 01             	add    $0x1,%edx
  801c95:	0f b6 01             	movzbl (%ecx),%eax
  801c98:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801c9b:	80 39 01             	cmpb   $0x1,(%ecx)
  801c9e:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  801ca1:	39 da                	cmp    %ebx,%edx
  801ca3:	75 ed                	jne    801c92 <strncpy+0x14>
	}
	return ret;
}
  801ca5:	89 f0                	mov    %esi,%eax
  801ca7:	5b                   	pop    %ebx
  801ca8:	5e                   	pop    %esi
  801ca9:	5d                   	pop    %ebp
  801caa:	c3                   	ret    

00801cab <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801cab:	55                   	push   %ebp
  801cac:	89 e5                	mov    %esp,%ebp
  801cae:	56                   	push   %esi
  801caf:	53                   	push   %ebx
  801cb0:	8b 75 08             	mov    0x8(%ebp),%esi
  801cb3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cb6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cb9:	89 f0                	mov    %esi,%eax
  801cbb:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801cbf:	85 c9                	test   %ecx,%ecx
  801cc1:	75 0b                	jne    801cce <strlcpy+0x23>
  801cc3:	eb 17                	jmp    801cdc <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  801cc5:	83 c2 01             	add    $0x1,%edx
  801cc8:	83 c0 01             	add    $0x1,%eax
  801ccb:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  801cce:	39 d8                	cmp    %ebx,%eax
  801cd0:	74 07                	je     801cd9 <strlcpy+0x2e>
  801cd2:	0f b6 0a             	movzbl (%edx),%ecx
  801cd5:	84 c9                	test   %cl,%cl
  801cd7:	75 ec                	jne    801cc5 <strlcpy+0x1a>
		*dst = '\0';
  801cd9:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801cdc:	29 f0                	sub    %esi,%eax
}
  801cde:	5b                   	pop    %ebx
  801cdf:	5e                   	pop    %esi
  801ce0:	5d                   	pop    %ebp
  801ce1:	c3                   	ret    

00801ce2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801ce2:	55                   	push   %ebp
  801ce3:	89 e5                	mov    %esp,%ebp
  801ce5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ce8:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801ceb:	eb 06                	jmp    801cf3 <strcmp+0x11>
		p++, q++;
  801ced:	83 c1 01             	add    $0x1,%ecx
  801cf0:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  801cf3:	0f b6 01             	movzbl (%ecx),%eax
  801cf6:	84 c0                	test   %al,%al
  801cf8:	74 04                	je     801cfe <strcmp+0x1c>
  801cfa:	3a 02                	cmp    (%edx),%al
  801cfc:	74 ef                	je     801ced <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801cfe:	0f b6 c0             	movzbl %al,%eax
  801d01:	0f b6 12             	movzbl (%edx),%edx
  801d04:	29 d0                	sub    %edx,%eax
}
  801d06:	5d                   	pop    %ebp
  801d07:	c3                   	ret    

00801d08 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801d08:	55                   	push   %ebp
  801d09:	89 e5                	mov    %esp,%ebp
  801d0b:	53                   	push   %ebx
  801d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d12:	89 c3                	mov    %eax,%ebx
  801d14:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  801d17:	eb 06                	jmp    801d1f <strncmp+0x17>
		n--, p++, q++;
  801d19:	83 c0 01             	add    $0x1,%eax
  801d1c:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  801d1f:	39 d8                	cmp    %ebx,%eax
  801d21:	74 16                	je     801d39 <strncmp+0x31>
  801d23:	0f b6 08             	movzbl (%eax),%ecx
  801d26:	84 c9                	test   %cl,%cl
  801d28:	74 04                	je     801d2e <strncmp+0x26>
  801d2a:	3a 0a                	cmp    (%edx),%cl
  801d2c:	74 eb                	je     801d19 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801d2e:	0f b6 00             	movzbl (%eax),%eax
  801d31:	0f b6 12             	movzbl (%edx),%edx
  801d34:	29 d0                	sub    %edx,%eax
}
  801d36:	5b                   	pop    %ebx
  801d37:	5d                   	pop    %ebp
  801d38:	c3                   	ret    
		return 0;
  801d39:	b8 00 00 00 00       	mov    $0x0,%eax
  801d3e:	eb f6                	jmp    801d36 <strncmp+0x2e>

00801d40 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801d40:	55                   	push   %ebp
  801d41:	89 e5                	mov    %esp,%ebp
  801d43:	8b 45 08             	mov    0x8(%ebp),%eax
  801d46:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801d4a:	0f b6 10             	movzbl (%eax),%edx
  801d4d:	84 d2                	test   %dl,%dl
  801d4f:	74 09                	je     801d5a <strchr+0x1a>
		if (*s == c)
  801d51:	38 ca                	cmp    %cl,%dl
  801d53:	74 0a                	je     801d5f <strchr+0x1f>
	for (; *s; s++)
  801d55:	83 c0 01             	add    $0x1,%eax
  801d58:	eb f0                	jmp    801d4a <strchr+0xa>
			return (char *) s;
	return 0;
  801d5a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d5f:	5d                   	pop    %ebp
  801d60:	c3                   	ret    

00801d61 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801d61:	55                   	push   %ebp
  801d62:	89 e5                	mov    %esp,%ebp
  801d64:	8b 45 08             	mov    0x8(%ebp),%eax
  801d67:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801d6b:	eb 03                	jmp    801d70 <strfind+0xf>
  801d6d:	83 c0 01             	add    $0x1,%eax
  801d70:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  801d73:	38 ca                	cmp    %cl,%dl
  801d75:	74 04                	je     801d7b <strfind+0x1a>
  801d77:	84 d2                	test   %dl,%dl
  801d79:	75 f2                	jne    801d6d <strfind+0xc>
			break;
	return (char *) s;
}
  801d7b:	5d                   	pop    %ebp
  801d7c:	c3                   	ret    

00801d7d <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801d7d:	55                   	push   %ebp
  801d7e:	89 e5                	mov    %esp,%ebp
  801d80:	57                   	push   %edi
  801d81:	56                   	push   %esi
  801d82:	53                   	push   %ebx
  801d83:	8b 7d 08             	mov    0x8(%ebp),%edi
  801d86:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801d89:	85 c9                	test   %ecx,%ecx
  801d8b:	74 13                	je     801da0 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801d8d:	f7 c7 03 00 00 00    	test   $0x3,%edi
  801d93:	75 05                	jne    801d9a <memset+0x1d>
  801d95:	f6 c1 03             	test   $0x3,%cl
  801d98:	74 0d                	je     801da7 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801d9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d9d:	fc                   	cld    
  801d9e:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801da0:	89 f8                	mov    %edi,%eax
  801da2:	5b                   	pop    %ebx
  801da3:	5e                   	pop    %esi
  801da4:	5f                   	pop    %edi
  801da5:	5d                   	pop    %ebp
  801da6:	c3                   	ret    
		c &= 0xFF;
  801da7:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801dab:	89 d3                	mov    %edx,%ebx
  801dad:	c1 e3 08             	shl    $0x8,%ebx
  801db0:	89 d0                	mov    %edx,%eax
  801db2:	c1 e0 18             	shl    $0x18,%eax
  801db5:	89 d6                	mov    %edx,%esi
  801db7:	c1 e6 10             	shl    $0x10,%esi
  801dba:	09 f0                	or     %esi,%eax
  801dbc:	09 c2                	or     %eax,%edx
  801dbe:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  801dc0:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  801dc3:	89 d0                	mov    %edx,%eax
  801dc5:	fc                   	cld    
  801dc6:	f3 ab                	rep stos %eax,%es:(%edi)
  801dc8:	eb d6                	jmp    801da0 <memset+0x23>

00801dca <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801dca:	55                   	push   %ebp
  801dcb:	89 e5                	mov    %esp,%ebp
  801dcd:	57                   	push   %edi
  801dce:	56                   	push   %esi
  801dcf:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd2:	8b 75 0c             	mov    0xc(%ebp),%esi
  801dd5:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801dd8:	39 c6                	cmp    %eax,%esi
  801dda:	73 35                	jae    801e11 <memmove+0x47>
  801ddc:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801ddf:	39 c2                	cmp    %eax,%edx
  801de1:	76 2e                	jbe    801e11 <memmove+0x47>
		s += n;
		d += n;
  801de3:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801de6:	89 d6                	mov    %edx,%esi
  801de8:	09 fe                	or     %edi,%esi
  801dea:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801df0:	74 0c                	je     801dfe <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801df2:	83 ef 01             	sub    $0x1,%edi
  801df5:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  801df8:	fd                   	std    
  801df9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801dfb:	fc                   	cld    
  801dfc:	eb 21                	jmp    801e1f <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801dfe:	f6 c1 03             	test   $0x3,%cl
  801e01:	75 ef                	jne    801df2 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801e03:	83 ef 04             	sub    $0x4,%edi
  801e06:	8d 72 fc             	lea    -0x4(%edx),%esi
  801e09:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  801e0c:	fd                   	std    
  801e0d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801e0f:	eb ea                	jmp    801dfb <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801e11:	89 f2                	mov    %esi,%edx
  801e13:	09 c2                	or     %eax,%edx
  801e15:	f6 c2 03             	test   $0x3,%dl
  801e18:	74 09                	je     801e23 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801e1a:	89 c7                	mov    %eax,%edi
  801e1c:	fc                   	cld    
  801e1d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801e1f:	5e                   	pop    %esi
  801e20:	5f                   	pop    %edi
  801e21:	5d                   	pop    %ebp
  801e22:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801e23:	f6 c1 03             	test   $0x3,%cl
  801e26:	75 f2                	jne    801e1a <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801e28:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  801e2b:	89 c7                	mov    %eax,%edi
  801e2d:	fc                   	cld    
  801e2e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801e30:	eb ed                	jmp    801e1f <memmove+0x55>

00801e32 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801e32:	55                   	push   %ebp
  801e33:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  801e35:	ff 75 10             	pushl  0x10(%ebp)
  801e38:	ff 75 0c             	pushl  0xc(%ebp)
  801e3b:	ff 75 08             	pushl  0x8(%ebp)
  801e3e:	e8 87 ff ff ff       	call   801dca <memmove>
}
  801e43:	c9                   	leave  
  801e44:	c3                   	ret    

00801e45 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801e45:	55                   	push   %ebp
  801e46:	89 e5                	mov    %esp,%ebp
  801e48:	56                   	push   %esi
  801e49:	53                   	push   %ebx
  801e4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e50:	89 c6                	mov    %eax,%esi
  801e52:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801e55:	39 f0                	cmp    %esi,%eax
  801e57:	74 1c                	je     801e75 <memcmp+0x30>
		if (*s1 != *s2)
  801e59:	0f b6 08             	movzbl (%eax),%ecx
  801e5c:	0f b6 1a             	movzbl (%edx),%ebx
  801e5f:	38 d9                	cmp    %bl,%cl
  801e61:	75 08                	jne    801e6b <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801e63:	83 c0 01             	add    $0x1,%eax
  801e66:	83 c2 01             	add    $0x1,%edx
  801e69:	eb ea                	jmp    801e55 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  801e6b:	0f b6 c1             	movzbl %cl,%eax
  801e6e:	0f b6 db             	movzbl %bl,%ebx
  801e71:	29 d8                	sub    %ebx,%eax
  801e73:	eb 05                	jmp    801e7a <memcmp+0x35>
	}

	return 0;
  801e75:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e7a:	5b                   	pop    %ebx
  801e7b:	5e                   	pop    %esi
  801e7c:	5d                   	pop    %ebp
  801e7d:	c3                   	ret    

00801e7e <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801e7e:	55                   	push   %ebp
  801e7f:	89 e5                	mov    %esp,%ebp
  801e81:	8b 45 08             	mov    0x8(%ebp),%eax
  801e84:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801e87:	89 c2                	mov    %eax,%edx
  801e89:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801e8c:	39 d0                	cmp    %edx,%eax
  801e8e:	73 09                	jae    801e99 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  801e90:	38 08                	cmp    %cl,(%eax)
  801e92:	74 05                	je     801e99 <memfind+0x1b>
	for (; s < ends; s++)
  801e94:	83 c0 01             	add    $0x1,%eax
  801e97:	eb f3                	jmp    801e8c <memfind+0xe>
			break;
	return (void *) s;
}
  801e99:	5d                   	pop    %ebp
  801e9a:	c3                   	ret    

00801e9b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801e9b:	55                   	push   %ebp
  801e9c:	89 e5                	mov    %esp,%ebp
  801e9e:	57                   	push   %edi
  801e9f:	56                   	push   %esi
  801ea0:	53                   	push   %ebx
  801ea1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ea4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801ea7:	eb 03                	jmp    801eac <strtol+0x11>
		s++;
  801ea9:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  801eac:	0f b6 01             	movzbl (%ecx),%eax
  801eaf:	3c 20                	cmp    $0x20,%al
  801eb1:	74 f6                	je     801ea9 <strtol+0xe>
  801eb3:	3c 09                	cmp    $0x9,%al
  801eb5:	74 f2                	je     801ea9 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  801eb7:	3c 2b                	cmp    $0x2b,%al
  801eb9:	74 2e                	je     801ee9 <strtol+0x4e>
	int neg = 0;
  801ebb:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801ec0:	3c 2d                	cmp    $0x2d,%al
  801ec2:	74 2f                	je     801ef3 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801ec4:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  801eca:	75 05                	jne    801ed1 <strtol+0x36>
  801ecc:	80 39 30             	cmpb   $0x30,(%ecx)
  801ecf:	74 2c                	je     801efd <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  801ed1:	85 db                	test   %ebx,%ebx
  801ed3:	75 0a                	jne    801edf <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801ed5:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  801eda:	80 39 30             	cmpb   $0x30,(%ecx)
  801edd:	74 28                	je     801f07 <strtol+0x6c>
		base = 10;
  801edf:	b8 00 00 00 00       	mov    $0x0,%eax
  801ee4:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801ee7:	eb 50                	jmp    801f39 <strtol+0x9e>
		s++;
  801ee9:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  801eec:	bf 00 00 00 00       	mov    $0x0,%edi
  801ef1:	eb d1                	jmp    801ec4 <strtol+0x29>
		s++, neg = 1;
  801ef3:	83 c1 01             	add    $0x1,%ecx
  801ef6:	bf 01 00 00 00       	mov    $0x1,%edi
  801efb:	eb c7                	jmp    801ec4 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801efd:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801f01:	74 0e                	je     801f11 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  801f03:	85 db                	test   %ebx,%ebx
  801f05:	75 d8                	jne    801edf <strtol+0x44>
		s++, base = 8;
  801f07:	83 c1 01             	add    $0x1,%ecx
  801f0a:	bb 08 00 00 00       	mov    $0x8,%ebx
  801f0f:	eb ce                	jmp    801edf <strtol+0x44>
		s += 2, base = 16;
  801f11:	83 c1 02             	add    $0x2,%ecx
  801f14:	bb 10 00 00 00       	mov    $0x10,%ebx
  801f19:	eb c4                	jmp    801edf <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  801f1b:	8d 72 9f             	lea    -0x61(%edx),%esi
  801f1e:	89 f3                	mov    %esi,%ebx
  801f20:	80 fb 19             	cmp    $0x19,%bl
  801f23:	77 29                	ja     801f4e <strtol+0xb3>
			dig = *s - 'a' + 10;
  801f25:	0f be d2             	movsbl %dl,%edx
  801f28:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801f2b:	3b 55 10             	cmp    0x10(%ebp),%edx
  801f2e:	7d 30                	jge    801f60 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  801f30:	83 c1 01             	add    $0x1,%ecx
  801f33:	0f af 45 10          	imul   0x10(%ebp),%eax
  801f37:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801f39:	0f b6 11             	movzbl (%ecx),%edx
  801f3c:	8d 72 d0             	lea    -0x30(%edx),%esi
  801f3f:	89 f3                	mov    %esi,%ebx
  801f41:	80 fb 09             	cmp    $0x9,%bl
  801f44:	77 d5                	ja     801f1b <strtol+0x80>
			dig = *s - '0';
  801f46:	0f be d2             	movsbl %dl,%edx
  801f49:	83 ea 30             	sub    $0x30,%edx
  801f4c:	eb dd                	jmp    801f2b <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  801f4e:	8d 72 bf             	lea    -0x41(%edx),%esi
  801f51:	89 f3                	mov    %esi,%ebx
  801f53:	80 fb 19             	cmp    $0x19,%bl
  801f56:	77 08                	ja     801f60 <strtol+0xc5>
			dig = *s - 'A' + 10;
  801f58:	0f be d2             	movsbl %dl,%edx
  801f5b:	83 ea 37             	sub    $0x37,%edx
  801f5e:	eb cb                	jmp    801f2b <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  801f60:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801f64:	74 05                	je     801f6b <strtol+0xd0>
		*endptr = (char *) s;
  801f66:	8b 75 0c             	mov    0xc(%ebp),%esi
  801f69:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801f6b:	89 c2                	mov    %eax,%edx
  801f6d:	f7 da                	neg    %edx
  801f6f:	85 ff                	test   %edi,%edi
  801f71:	0f 45 c2             	cmovne %edx,%eax
}
  801f74:	5b                   	pop    %ebx
  801f75:	5e                   	pop    %esi
  801f76:	5f                   	pop    %edi
  801f77:	5d                   	pop    %ebp
  801f78:	c3                   	ret    

00801f79 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801f79:	55                   	push   %ebp
  801f7a:	89 e5                	mov    %esp,%ebp
  801f7c:	56                   	push   %esi
  801f7d:	53                   	push   %ebx
  801f7e:	8b 75 08             	mov    0x8(%ebp),%esi
  801f81:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f84:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
  801f87:	85 c0                	test   %eax,%eax
	    pg = (void *)UTOP;
  801f89:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801f8e:	0f 44 c2             	cmove  %edx,%eax
	}
	if ((r = sys_ipc_recv(pg)) < 0) {
  801f91:	83 ec 0c             	sub    $0xc,%esp
  801f94:	50                   	push   %eax
  801f95:	e8 6b e3 ff ff       	call   800305 <sys_ipc_recv>
  801f9a:	83 c4 10             	add    $0x10,%esp
  801f9d:	85 c0                	test   %eax,%eax
  801f9f:	78 2b                	js     801fcc <ipc_recv+0x53>
	    if (perm_store != NULL) {
	        *perm_store = 0;
	    }
	    return r;
	}
	if (from_env_store != NULL) {
  801fa1:	85 f6                	test   %esi,%esi
  801fa3:	74 0a                	je     801faf <ipc_recv+0x36>
	    *from_env_store = thisenv->env_ipc_from;
  801fa5:	a1 08 40 80 00       	mov    0x804008,%eax
  801faa:	8b 40 74             	mov    0x74(%eax),%eax
  801fad:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store != NULL) {
  801faf:	85 db                	test   %ebx,%ebx
  801fb1:	74 0a                	je     801fbd <ipc_recv+0x44>
	    *perm_store = thisenv->env_ipc_perm;
  801fb3:	a1 08 40 80 00       	mov    0x804008,%eax
  801fb8:	8b 40 78             	mov    0x78(%eax),%eax
  801fbb:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  801fbd:	a1 08 40 80 00       	mov    0x804008,%eax
  801fc2:	8b 40 70             	mov    0x70(%eax),%eax
}
  801fc5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fc8:	5b                   	pop    %ebx
  801fc9:	5e                   	pop    %esi
  801fca:	5d                   	pop    %ebp
  801fcb:	c3                   	ret    
	    if (from_env_store != NULL) {
  801fcc:	85 f6                	test   %esi,%esi
  801fce:	74 06                	je     801fd6 <ipc_recv+0x5d>
	        *from_env_store = 0;
  801fd0:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	    if (perm_store != NULL) {
  801fd6:	85 db                	test   %ebx,%ebx
  801fd8:	74 eb                	je     801fc5 <ipc_recv+0x4c>
	        *perm_store = 0;
  801fda:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801fe0:	eb e3                	jmp    801fc5 <ipc_recv+0x4c>

00801fe2 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801fe2:	55                   	push   %ebp
  801fe3:	89 e5                	mov    %esp,%ebp
  801fe5:	57                   	push   %edi
  801fe6:	56                   	push   %esi
  801fe7:	53                   	push   %ebx
  801fe8:	83 ec 0c             	sub    $0xc,%esp
  801feb:	8b 7d 08             	mov    0x8(%ebp),%edi
  801fee:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
	    pg = (void *)UTOP;
  801ff1:	85 f6                	test   %esi,%esi
  801ff3:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801ff8:	0f 44 f0             	cmove  %eax,%esi
  801ffb:	eb 09                	jmp    802006 <ipc_send+0x24>
	do {
	    r = sys_ipc_try_send(to_env, val, pg, perm);
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
	        panic("ipc_send: %e", r);
	    }
	    sys_yield();
  801ffd:	e8 34 e1 ff ff       	call   800136 <sys_yield>
	} while(r != 0);
  802002:	85 db                	test   %ebx,%ebx
  802004:	74 2d                	je     802033 <ipc_send+0x51>
	    r = sys_ipc_try_send(to_env, val, pg, perm);
  802006:	ff 75 14             	pushl  0x14(%ebp)
  802009:	56                   	push   %esi
  80200a:	ff 75 0c             	pushl  0xc(%ebp)
  80200d:	57                   	push   %edi
  80200e:	e8 cf e2 ff ff       	call   8002e2 <sys_ipc_try_send>
  802013:	89 c3                	mov    %eax,%ebx
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
  802015:	83 c4 10             	add    $0x10,%esp
  802018:	85 c0                	test   %eax,%eax
  80201a:	79 e1                	jns    801ffd <ipc_send+0x1b>
  80201c:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80201f:	74 dc                	je     801ffd <ipc_send+0x1b>
	        panic("ipc_send: %e", r);
  802021:	50                   	push   %eax
  802022:	68 c0 27 80 00       	push   $0x8027c0
  802027:	6a 45                	push   $0x45
  802029:	68 cd 27 80 00       	push   $0x8027cd
  80202e:	e8 91 f4 ff ff       	call   8014c4 <_panic>
}
  802033:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802036:	5b                   	pop    %ebx
  802037:	5e                   	pop    %esi
  802038:	5f                   	pop    %edi
  802039:	5d                   	pop    %ebp
  80203a:	c3                   	ret    

0080203b <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80203b:	55                   	push   %ebp
  80203c:	89 e5                	mov    %esp,%ebp
  80203e:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802041:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802046:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802049:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80204f:	8b 52 50             	mov    0x50(%edx),%edx
  802052:	39 ca                	cmp    %ecx,%edx
  802054:	74 11                	je     802067 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  802056:	83 c0 01             	add    $0x1,%eax
  802059:	3d 00 04 00 00       	cmp    $0x400,%eax
  80205e:	75 e6                	jne    802046 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802060:	b8 00 00 00 00       	mov    $0x0,%eax
  802065:	eb 0b                	jmp    802072 <ipc_find_env+0x37>
			return envs[i].env_id;
  802067:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80206a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80206f:	8b 40 48             	mov    0x48(%eax),%eax
}
  802072:	5d                   	pop    %ebp
  802073:	c3                   	ret    

00802074 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802074:	55                   	push   %ebp
  802075:	89 e5                	mov    %esp,%ebp
  802077:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80207a:	89 d0                	mov    %edx,%eax
  80207c:	c1 e8 16             	shr    $0x16,%eax
  80207f:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802086:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80208b:	f6 c1 01             	test   $0x1,%cl
  80208e:	74 1d                	je     8020ad <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802090:	c1 ea 0c             	shr    $0xc,%edx
  802093:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80209a:	f6 c2 01             	test   $0x1,%dl
  80209d:	74 0e                	je     8020ad <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80209f:	c1 ea 0c             	shr    $0xc,%edx
  8020a2:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8020a9:	ef 
  8020aa:	0f b7 c0             	movzwl %ax,%eax
}
  8020ad:	5d                   	pop    %ebp
  8020ae:	c3                   	ret    
  8020af:	90                   	nop

008020b0 <__udivdi3>:
  8020b0:	55                   	push   %ebp
  8020b1:	57                   	push   %edi
  8020b2:	56                   	push   %esi
  8020b3:	53                   	push   %ebx
  8020b4:	83 ec 1c             	sub    $0x1c,%esp
  8020b7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8020bb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8020bf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8020c3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8020c7:	85 d2                	test   %edx,%edx
  8020c9:	75 35                	jne    802100 <__udivdi3+0x50>
  8020cb:	39 f3                	cmp    %esi,%ebx
  8020cd:	0f 87 bd 00 00 00    	ja     802190 <__udivdi3+0xe0>
  8020d3:	85 db                	test   %ebx,%ebx
  8020d5:	89 d9                	mov    %ebx,%ecx
  8020d7:	75 0b                	jne    8020e4 <__udivdi3+0x34>
  8020d9:	b8 01 00 00 00       	mov    $0x1,%eax
  8020de:	31 d2                	xor    %edx,%edx
  8020e0:	f7 f3                	div    %ebx
  8020e2:	89 c1                	mov    %eax,%ecx
  8020e4:	31 d2                	xor    %edx,%edx
  8020e6:	89 f0                	mov    %esi,%eax
  8020e8:	f7 f1                	div    %ecx
  8020ea:	89 c6                	mov    %eax,%esi
  8020ec:	89 e8                	mov    %ebp,%eax
  8020ee:	89 f7                	mov    %esi,%edi
  8020f0:	f7 f1                	div    %ecx
  8020f2:	89 fa                	mov    %edi,%edx
  8020f4:	83 c4 1c             	add    $0x1c,%esp
  8020f7:	5b                   	pop    %ebx
  8020f8:	5e                   	pop    %esi
  8020f9:	5f                   	pop    %edi
  8020fa:	5d                   	pop    %ebp
  8020fb:	c3                   	ret    
  8020fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802100:	39 f2                	cmp    %esi,%edx
  802102:	77 7c                	ja     802180 <__udivdi3+0xd0>
  802104:	0f bd fa             	bsr    %edx,%edi
  802107:	83 f7 1f             	xor    $0x1f,%edi
  80210a:	0f 84 98 00 00 00    	je     8021a8 <__udivdi3+0xf8>
  802110:	89 f9                	mov    %edi,%ecx
  802112:	b8 20 00 00 00       	mov    $0x20,%eax
  802117:	29 f8                	sub    %edi,%eax
  802119:	d3 e2                	shl    %cl,%edx
  80211b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80211f:	89 c1                	mov    %eax,%ecx
  802121:	89 da                	mov    %ebx,%edx
  802123:	d3 ea                	shr    %cl,%edx
  802125:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802129:	09 d1                	or     %edx,%ecx
  80212b:	89 f2                	mov    %esi,%edx
  80212d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802131:	89 f9                	mov    %edi,%ecx
  802133:	d3 e3                	shl    %cl,%ebx
  802135:	89 c1                	mov    %eax,%ecx
  802137:	d3 ea                	shr    %cl,%edx
  802139:	89 f9                	mov    %edi,%ecx
  80213b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80213f:	d3 e6                	shl    %cl,%esi
  802141:	89 eb                	mov    %ebp,%ebx
  802143:	89 c1                	mov    %eax,%ecx
  802145:	d3 eb                	shr    %cl,%ebx
  802147:	09 de                	or     %ebx,%esi
  802149:	89 f0                	mov    %esi,%eax
  80214b:	f7 74 24 08          	divl   0x8(%esp)
  80214f:	89 d6                	mov    %edx,%esi
  802151:	89 c3                	mov    %eax,%ebx
  802153:	f7 64 24 0c          	mull   0xc(%esp)
  802157:	39 d6                	cmp    %edx,%esi
  802159:	72 0c                	jb     802167 <__udivdi3+0xb7>
  80215b:	89 f9                	mov    %edi,%ecx
  80215d:	d3 e5                	shl    %cl,%ebp
  80215f:	39 c5                	cmp    %eax,%ebp
  802161:	73 5d                	jae    8021c0 <__udivdi3+0x110>
  802163:	39 d6                	cmp    %edx,%esi
  802165:	75 59                	jne    8021c0 <__udivdi3+0x110>
  802167:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80216a:	31 ff                	xor    %edi,%edi
  80216c:	89 fa                	mov    %edi,%edx
  80216e:	83 c4 1c             	add    $0x1c,%esp
  802171:	5b                   	pop    %ebx
  802172:	5e                   	pop    %esi
  802173:	5f                   	pop    %edi
  802174:	5d                   	pop    %ebp
  802175:	c3                   	ret    
  802176:	8d 76 00             	lea    0x0(%esi),%esi
  802179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  802180:	31 ff                	xor    %edi,%edi
  802182:	31 c0                	xor    %eax,%eax
  802184:	89 fa                	mov    %edi,%edx
  802186:	83 c4 1c             	add    $0x1c,%esp
  802189:	5b                   	pop    %ebx
  80218a:	5e                   	pop    %esi
  80218b:	5f                   	pop    %edi
  80218c:	5d                   	pop    %ebp
  80218d:	c3                   	ret    
  80218e:	66 90                	xchg   %ax,%ax
  802190:	31 ff                	xor    %edi,%edi
  802192:	89 e8                	mov    %ebp,%eax
  802194:	89 f2                	mov    %esi,%edx
  802196:	f7 f3                	div    %ebx
  802198:	89 fa                	mov    %edi,%edx
  80219a:	83 c4 1c             	add    $0x1c,%esp
  80219d:	5b                   	pop    %ebx
  80219e:	5e                   	pop    %esi
  80219f:	5f                   	pop    %edi
  8021a0:	5d                   	pop    %ebp
  8021a1:	c3                   	ret    
  8021a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8021a8:	39 f2                	cmp    %esi,%edx
  8021aa:	72 06                	jb     8021b2 <__udivdi3+0x102>
  8021ac:	31 c0                	xor    %eax,%eax
  8021ae:	39 eb                	cmp    %ebp,%ebx
  8021b0:	77 d2                	ja     802184 <__udivdi3+0xd4>
  8021b2:	b8 01 00 00 00       	mov    $0x1,%eax
  8021b7:	eb cb                	jmp    802184 <__udivdi3+0xd4>
  8021b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8021c0:	89 d8                	mov    %ebx,%eax
  8021c2:	31 ff                	xor    %edi,%edi
  8021c4:	eb be                	jmp    802184 <__udivdi3+0xd4>
  8021c6:	66 90                	xchg   %ax,%ax
  8021c8:	66 90                	xchg   %ax,%ax
  8021ca:	66 90                	xchg   %ax,%ax
  8021cc:	66 90                	xchg   %ax,%ax
  8021ce:	66 90                	xchg   %ax,%ax

008021d0 <__umoddi3>:
  8021d0:	55                   	push   %ebp
  8021d1:	57                   	push   %edi
  8021d2:	56                   	push   %esi
  8021d3:	53                   	push   %ebx
  8021d4:	83 ec 1c             	sub    $0x1c,%esp
  8021d7:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  8021db:	8b 74 24 30          	mov    0x30(%esp),%esi
  8021df:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8021e3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8021e7:	85 ed                	test   %ebp,%ebp
  8021e9:	89 f0                	mov    %esi,%eax
  8021eb:	89 da                	mov    %ebx,%edx
  8021ed:	75 19                	jne    802208 <__umoddi3+0x38>
  8021ef:	39 df                	cmp    %ebx,%edi
  8021f1:	0f 86 b1 00 00 00    	jbe    8022a8 <__umoddi3+0xd8>
  8021f7:	f7 f7                	div    %edi
  8021f9:	89 d0                	mov    %edx,%eax
  8021fb:	31 d2                	xor    %edx,%edx
  8021fd:	83 c4 1c             	add    $0x1c,%esp
  802200:	5b                   	pop    %ebx
  802201:	5e                   	pop    %esi
  802202:	5f                   	pop    %edi
  802203:	5d                   	pop    %ebp
  802204:	c3                   	ret    
  802205:	8d 76 00             	lea    0x0(%esi),%esi
  802208:	39 dd                	cmp    %ebx,%ebp
  80220a:	77 f1                	ja     8021fd <__umoddi3+0x2d>
  80220c:	0f bd cd             	bsr    %ebp,%ecx
  80220f:	83 f1 1f             	xor    $0x1f,%ecx
  802212:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802216:	0f 84 b4 00 00 00    	je     8022d0 <__umoddi3+0x100>
  80221c:	b8 20 00 00 00       	mov    $0x20,%eax
  802221:	89 c2                	mov    %eax,%edx
  802223:	8b 44 24 04          	mov    0x4(%esp),%eax
  802227:	29 c2                	sub    %eax,%edx
  802229:	89 c1                	mov    %eax,%ecx
  80222b:	89 f8                	mov    %edi,%eax
  80222d:	d3 e5                	shl    %cl,%ebp
  80222f:	89 d1                	mov    %edx,%ecx
  802231:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802235:	d3 e8                	shr    %cl,%eax
  802237:	09 c5                	or     %eax,%ebp
  802239:	8b 44 24 04          	mov    0x4(%esp),%eax
  80223d:	89 c1                	mov    %eax,%ecx
  80223f:	d3 e7                	shl    %cl,%edi
  802241:	89 d1                	mov    %edx,%ecx
  802243:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802247:	89 df                	mov    %ebx,%edi
  802249:	d3 ef                	shr    %cl,%edi
  80224b:	89 c1                	mov    %eax,%ecx
  80224d:	89 f0                	mov    %esi,%eax
  80224f:	d3 e3                	shl    %cl,%ebx
  802251:	89 d1                	mov    %edx,%ecx
  802253:	89 fa                	mov    %edi,%edx
  802255:	d3 e8                	shr    %cl,%eax
  802257:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80225c:	09 d8                	or     %ebx,%eax
  80225e:	f7 f5                	div    %ebp
  802260:	d3 e6                	shl    %cl,%esi
  802262:	89 d1                	mov    %edx,%ecx
  802264:	f7 64 24 08          	mull   0x8(%esp)
  802268:	39 d1                	cmp    %edx,%ecx
  80226a:	89 c3                	mov    %eax,%ebx
  80226c:	89 d7                	mov    %edx,%edi
  80226e:	72 06                	jb     802276 <__umoddi3+0xa6>
  802270:	75 0e                	jne    802280 <__umoddi3+0xb0>
  802272:	39 c6                	cmp    %eax,%esi
  802274:	73 0a                	jae    802280 <__umoddi3+0xb0>
  802276:	2b 44 24 08          	sub    0x8(%esp),%eax
  80227a:	19 ea                	sbb    %ebp,%edx
  80227c:	89 d7                	mov    %edx,%edi
  80227e:	89 c3                	mov    %eax,%ebx
  802280:	89 ca                	mov    %ecx,%edx
  802282:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  802287:	29 de                	sub    %ebx,%esi
  802289:	19 fa                	sbb    %edi,%edx
  80228b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  80228f:	89 d0                	mov    %edx,%eax
  802291:	d3 e0                	shl    %cl,%eax
  802293:	89 d9                	mov    %ebx,%ecx
  802295:	d3 ee                	shr    %cl,%esi
  802297:	d3 ea                	shr    %cl,%edx
  802299:	09 f0                	or     %esi,%eax
  80229b:	83 c4 1c             	add    $0x1c,%esp
  80229e:	5b                   	pop    %ebx
  80229f:	5e                   	pop    %esi
  8022a0:	5f                   	pop    %edi
  8022a1:	5d                   	pop    %ebp
  8022a2:	c3                   	ret    
  8022a3:	90                   	nop
  8022a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8022a8:	85 ff                	test   %edi,%edi
  8022aa:	89 f9                	mov    %edi,%ecx
  8022ac:	75 0b                	jne    8022b9 <__umoddi3+0xe9>
  8022ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8022b3:	31 d2                	xor    %edx,%edx
  8022b5:	f7 f7                	div    %edi
  8022b7:	89 c1                	mov    %eax,%ecx
  8022b9:	89 d8                	mov    %ebx,%eax
  8022bb:	31 d2                	xor    %edx,%edx
  8022bd:	f7 f1                	div    %ecx
  8022bf:	89 f0                	mov    %esi,%eax
  8022c1:	f7 f1                	div    %ecx
  8022c3:	e9 31 ff ff ff       	jmp    8021f9 <__umoddi3+0x29>
  8022c8:	90                   	nop
  8022c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022d0:	39 dd                	cmp    %ebx,%ebp
  8022d2:	72 08                	jb     8022dc <__umoddi3+0x10c>
  8022d4:	39 f7                	cmp    %esi,%edi
  8022d6:	0f 87 21 ff ff ff    	ja     8021fd <__umoddi3+0x2d>
  8022dc:	89 da                	mov    %ebx,%edx
  8022de:	89 f0                	mov    %esi,%eax
  8022e0:	29 f8                	sub    %edi,%eax
  8022e2:	19 ea                	sbb    %ebp,%edx
  8022e4:	e9 14 ff ff ff       	jmp    8021fd <__umoddi3+0x2d>
