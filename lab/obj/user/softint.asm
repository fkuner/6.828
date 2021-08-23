
obj/user/softint.debug:     file format elf32-i386


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
  80002c:	e8 09 00 00 00       	call   80003a <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
	asm volatile("int $14");	// page fault
  800036:	cd 0e                	int    $0xe
}
  800038:	5d                   	pop    %ebp
  800039:	c3                   	ret    

0080003a <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80003a:	55                   	push   %ebp
  80003b:	89 e5                	mov    %esp,%ebp
  80003d:	56                   	push   %esi
  80003e:	53                   	push   %ebx
  80003f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800042:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
    thisenv = &envs[ENVX(sys_getenvid())];
  800045:	e8 ce 00 00 00       	call   800118 <sys_getenvid>
  80004a:	25 ff 03 00 00       	and    $0x3ff,%eax
  80004f:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800052:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800057:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80005c:	85 db                	test   %ebx,%ebx
  80005e:	7e 07                	jle    800067 <libmain+0x2d>
		binaryname = argv[0];
  800060:	8b 06                	mov    (%esi),%eax
  800062:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800067:	83 ec 08             	sub    $0x8,%esp
  80006a:	56                   	push   %esi
  80006b:	53                   	push   %ebx
  80006c:	e8 c2 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800071:	e8 0a 00 00 00       	call   800080 <exit>
}
  800076:	83 c4 10             	add    $0x10,%esp
  800079:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80007c:	5b                   	pop    %ebx
  80007d:	5e                   	pop    %esi
  80007e:	5d                   	pop    %ebp
  80007f:	c3                   	ret    

00800080 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800080:	55                   	push   %ebp
  800081:	89 e5                	mov    %esp,%ebp
  800083:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800086:	e8 b1 04 00 00       	call   80053c <close_all>
	sys_env_destroy(0);
  80008b:	83 ec 0c             	sub    $0xc,%esp
  80008e:	6a 00                	push   $0x0
  800090:	e8 42 00 00 00       	call   8000d7 <sys_env_destroy>
}
  800095:	83 c4 10             	add    $0x10,%esp
  800098:	c9                   	leave  
  800099:	c3                   	ret    

0080009a <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  80009a:	55                   	push   %ebp
  80009b:	89 e5                	mov    %esp,%ebp
  80009d:	57                   	push   %edi
  80009e:	56                   	push   %esi
  80009f:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8000a8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000ab:	89 c3                	mov    %eax,%ebx
  8000ad:	89 c7                	mov    %eax,%edi
  8000af:	89 c6                	mov    %eax,%esi
  8000b1:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000b3:	5b                   	pop    %ebx
  8000b4:	5e                   	pop    %esi
  8000b5:	5f                   	pop    %edi
  8000b6:	5d                   	pop    %ebp
  8000b7:	c3                   	ret    

008000b8 <sys_cgetc>:

int
sys_cgetc(void)
{
  8000b8:	55                   	push   %ebp
  8000b9:	89 e5                	mov    %esp,%ebp
  8000bb:	57                   	push   %edi
  8000bc:	56                   	push   %esi
  8000bd:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000be:	ba 00 00 00 00       	mov    $0x0,%edx
  8000c3:	b8 01 00 00 00       	mov    $0x1,%eax
  8000c8:	89 d1                	mov    %edx,%ecx
  8000ca:	89 d3                	mov    %edx,%ebx
  8000cc:	89 d7                	mov    %edx,%edi
  8000ce:	89 d6                	mov    %edx,%esi
  8000d0:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000d2:	5b                   	pop    %ebx
  8000d3:	5e                   	pop    %esi
  8000d4:	5f                   	pop    %edi
  8000d5:	5d                   	pop    %ebp
  8000d6:	c3                   	ret    

008000d7 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000d7:	55                   	push   %ebp
  8000d8:	89 e5                	mov    %esp,%ebp
  8000da:	57                   	push   %edi
  8000db:	56                   	push   %esi
  8000dc:	53                   	push   %ebx
  8000dd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8000e0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8000e8:	b8 03 00 00 00       	mov    $0x3,%eax
  8000ed:	89 cb                	mov    %ecx,%ebx
  8000ef:	89 cf                	mov    %ecx,%edi
  8000f1:	89 ce                	mov    %ecx,%esi
  8000f3:	cd 30                	int    $0x30
	if(check && ret > 0)
  8000f5:	85 c0                	test   %eax,%eax
  8000f7:	7f 08                	jg     800101 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8000f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000fc:	5b                   	pop    %ebx
  8000fd:	5e                   	pop    %esi
  8000fe:	5f                   	pop    %edi
  8000ff:	5d                   	pop    %ebp
  800100:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800101:	83 ec 0c             	sub    $0xc,%esp
  800104:	50                   	push   %eax
  800105:	6a 03                	push   $0x3
  800107:	68 0a 23 80 00       	push   $0x80230a
  80010c:	6a 23                	push   $0x23
  80010e:	68 27 23 80 00       	push   $0x802327
  800113:	e8 ad 13 00 00       	call   8014c5 <_panic>

00800118 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800118:	55                   	push   %ebp
  800119:	89 e5                	mov    %esp,%ebp
  80011b:	57                   	push   %edi
  80011c:	56                   	push   %esi
  80011d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80011e:	ba 00 00 00 00       	mov    $0x0,%edx
  800123:	b8 02 00 00 00       	mov    $0x2,%eax
  800128:	89 d1                	mov    %edx,%ecx
  80012a:	89 d3                	mov    %edx,%ebx
  80012c:	89 d7                	mov    %edx,%edi
  80012e:	89 d6                	mov    %edx,%esi
  800130:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800132:	5b                   	pop    %ebx
  800133:	5e                   	pop    %esi
  800134:	5f                   	pop    %edi
  800135:	5d                   	pop    %ebp
  800136:	c3                   	ret    

00800137 <sys_yield>:

void
sys_yield(void)
{
  800137:	55                   	push   %ebp
  800138:	89 e5                	mov    %esp,%ebp
  80013a:	57                   	push   %edi
  80013b:	56                   	push   %esi
  80013c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80013d:	ba 00 00 00 00       	mov    $0x0,%edx
  800142:	b8 0b 00 00 00       	mov    $0xb,%eax
  800147:	89 d1                	mov    %edx,%ecx
  800149:	89 d3                	mov    %edx,%ebx
  80014b:	89 d7                	mov    %edx,%edi
  80014d:	89 d6                	mov    %edx,%esi
  80014f:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800151:	5b                   	pop    %ebx
  800152:	5e                   	pop    %esi
  800153:	5f                   	pop    %edi
  800154:	5d                   	pop    %ebp
  800155:	c3                   	ret    

00800156 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800156:	55                   	push   %ebp
  800157:	89 e5                	mov    %esp,%ebp
  800159:	57                   	push   %edi
  80015a:	56                   	push   %esi
  80015b:	53                   	push   %ebx
  80015c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80015f:	be 00 00 00 00       	mov    $0x0,%esi
  800164:	8b 55 08             	mov    0x8(%ebp),%edx
  800167:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80016a:	b8 04 00 00 00       	mov    $0x4,%eax
  80016f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800172:	89 f7                	mov    %esi,%edi
  800174:	cd 30                	int    $0x30
	if(check && ret > 0)
  800176:	85 c0                	test   %eax,%eax
  800178:	7f 08                	jg     800182 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80017d:	5b                   	pop    %ebx
  80017e:	5e                   	pop    %esi
  80017f:	5f                   	pop    %edi
  800180:	5d                   	pop    %ebp
  800181:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800182:	83 ec 0c             	sub    $0xc,%esp
  800185:	50                   	push   %eax
  800186:	6a 04                	push   $0x4
  800188:	68 0a 23 80 00       	push   $0x80230a
  80018d:	6a 23                	push   $0x23
  80018f:	68 27 23 80 00       	push   $0x802327
  800194:	e8 2c 13 00 00       	call   8014c5 <_panic>

00800199 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800199:	55                   	push   %ebp
  80019a:	89 e5                	mov    %esp,%ebp
  80019c:	57                   	push   %edi
  80019d:	56                   	push   %esi
  80019e:	53                   	push   %ebx
  80019f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8001a5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001a8:	b8 05 00 00 00       	mov    $0x5,%eax
  8001ad:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001b0:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001b3:	8b 75 18             	mov    0x18(%ebp),%esi
  8001b6:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001b8:	85 c0                	test   %eax,%eax
  8001ba:	7f 08                	jg     8001c4 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001bf:	5b                   	pop    %ebx
  8001c0:	5e                   	pop    %esi
  8001c1:	5f                   	pop    %edi
  8001c2:	5d                   	pop    %ebp
  8001c3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001c4:	83 ec 0c             	sub    $0xc,%esp
  8001c7:	50                   	push   %eax
  8001c8:	6a 05                	push   $0x5
  8001ca:	68 0a 23 80 00       	push   $0x80230a
  8001cf:	6a 23                	push   $0x23
  8001d1:	68 27 23 80 00       	push   $0x802327
  8001d6:	e8 ea 12 00 00       	call   8014c5 <_panic>

008001db <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001db:	55                   	push   %ebp
  8001dc:	89 e5                	mov    %esp,%ebp
  8001de:	57                   	push   %edi
  8001df:	56                   	push   %esi
  8001e0:	53                   	push   %ebx
  8001e1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001e4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8001ec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001ef:	b8 06 00 00 00       	mov    $0x6,%eax
  8001f4:	89 df                	mov    %ebx,%edi
  8001f6:	89 de                	mov    %ebx,%esi
  8001f8:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001fa:	85 c0                	test   %eax,%eax
  8001fc:	7f 08                	jg     800206 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8001fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800201:	5b                   	pop    %ebx
  800202:	5e                   	pop    %esi
  800203:	5f                   	pop    %edi
  800204:	5d                   	pop    %ebp
  800205:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800206:	83 ec 0c             	sub    $0xc,%esp
  800209:	50                   	push   %eax
  80020a:	6a 06                	push   $0x6
  80020c:	68 0a 23 80 00       	push   $0x80230a
  800211:	6a 23                	push   $0x23
  800213:	68 27 23 80 00       	push   $0x802327
  800218:	e8 a8 12 00 00       	call   8014c5 <_panic>

0080021d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80021d:	55                   	push   %ebp
  80021e:	89 e5                	mov    %esp,%ebp
  800220:	57                   	push   %edi
  800221:	56                   	push   %esi
  800222:	53                   	push   %ebx
  800223:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800226:	bb 00 00 00 00       	mov    $0x0,%ebx
  80022b:	8b 55 08             	mov    0x8(%ebp),%edx
  80022e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800231:	b8 08 00 00 00       	mov    $0x8,%eax
  800236:	89 df                	mov    %ebx,%edi
  800238:	89 de                	mov    %ebx,%esi
  80023a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80023c:	85 c0                	test   %eax,%eax
  80023e:	7f 08                	jg     800248 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800240:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800243:	5b                   	pop    %ebx
  800244:	5e                   	pop    %esi
  800245:	5f                   	pop    %edi
  800246:	5d                   	pop    %ebp
  800247:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800248:	83 ec 0c             	sub    $0xc,%esp
  80024b:	50                   	push   %eax
  80024c:	6a 08                	push   $0x8
  80024e:	68 0a 23 80 00       	push   $0x80230a
  800253:	6a 23                	push   $0x23
  800255:	68 27 23 80 00       	push   $0x802327
  80025a:	e8 66 12 00 00       	call   8014c5 <_panic>

0080025f <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80025f:	55                   	push   %ebp
  800260:	89 e5                	mov    %esp,%ebp
  800262:	57                   	push   %edi
  800263:	56                   	push   %esi
  800264:	53                   	push   %ebx
  800265:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800268:	bb 00 00 00 00       	mov    $0x0,%ebx
  80026d:	8b 55 08             	mov    0x8(%ebp),%edx
  800270:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800273:	b8 09 00 00 00       	mov    $0x9,%eax
  800278:	89 df                	mov    %ebx,%edi
  80027a:	89 de                	mov    %ebx,%esi
  80027c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80027e:	85 c0                	test   %eax,%eax
  800280:	7f 08                	jg     80028a <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800282:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800285:	5b                   	pop    %ebx
  800286:	5e                   	pop    %esi
  800287:	5f                   	pop    %edi
  800288:	5d                   	pop    %ebp
  800289:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80028a:	83 ec 0c             	sub    $0xc,%esp
  80028d:	50                   	push   %eax
  80028e:	6a 09                	push   $0x9
  800290:	68 0a 23 80 00       	push   $0x80230a
  800295:	6a 23                	push   $0x23
  800297:	68 27 23 80 00       	push   $0x802327
  80029c:	e8 24 12 00 00       	call   8014c5 <_panic>

008002a1 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002a1:	55                   	push   %ebp
  8002a2:	89 e5                	mov    %esp,%ebp
  8002a4:	57                   	push   %edi
  8002a5:	56                   	push   %esi
  8002a6:	53                   	push   %ebx
  8002a7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002aa:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002af:	8b 55 08             	mov    0x8(%ebp),%edx
  8002b2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002b5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002ba:	89 df                	mov    %ebx,%edi
  8002bc:	89 de                	mov    %ebx,%esi
  8002be:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002c0:	85 c0                	test   %eax,%eax
  8002c2:	7f 08                	jg     8002cc <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8002c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002c7:	5b                   	pop    %ebx
  8002c8:	5e                   	pop    %esi
  8002c9:	5f                   	pop    %edi
  8002ca:	5d                   	pop    %ebp
  8002cb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002cc:	83 ec 0c             	sub    $0xc,%esp
  8002cf:	50                   	push   %eax
  8002d0:	6a 0a                	push   $0xa
  8002d2:	68 0a 23 80 00       	push   $0x80230a
  8002d7:	6a 23                	push   $0x23
  8002d9:	68 27 23 80 00       	push   $0x802327
  8002de:	e8 e2 11 00 00       	call   8014c5 <_panic>

008002e3 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8002e3:	55                   	push   %ebp
  8002e4:	89 e5                	mov    %esp,%ebp
  8002e6:	57                   	push   %edi
  8002e7:	56                   	push   %esi
  8002e8:	53                   	push   %ebx
	asm volatile("int %1\n"
  8002e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8002ec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002ef:	b8 0c 00 00 00       	mov    $0xc,%eax
  8002f4:	be 00 00 00 00       	mov    $0x0,%esi
  8002f9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8002fc:	8b 7d 14             	mov    0x14(%ebp),%edi
  8002ff:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800301:	5b                   	pop    %ebx
  800302:	5e                   	pop    %esi
  800303:	5f                   	pop    %edi
  800304:	5d                   	pop    %ebp
  800305:	c3                   	ret    

00800306 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800306:	55                   	push   %ebp
  800307:	89 e5                	mov    %esp,%ebp
  800309:	57                   	push   %edi
  80030a:	56                   	push   %esi
  80030b:	53                   	push   %ebx
  80030c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80030f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800314:	8b 55 08             	mov    0x8(%ebp),%edx
  800317:	b8 0d 00 00 00       	mov    $0xd,%eax
  80031c:	89 cb                	mov    %ecx,%ebx
  80031e:	89 cf                	mov    %ecx,%edi
  800320:	89 ce                	mov    %ecx,%esi
  800322:	cd 30                	int    $0x30
	if(check && ret > 0)
  800324:	85 c0                	test   %eax,%eax
  800326:	7f 08                	jg     800330 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800328:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80032b:	5b                   	pop    %ebx
  80032c:	5e                   	pop    %esi
  80032d:	5f                   	pop    %edi
  80032e:	5d                   	pop    %ebp
  80032f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800330:	83 ec 0c             	sub    $0xc,%esp
  800333:	50                   	push   %eax
  800334:	6a 0d                	push   $0xd
  800336:	68 0a 23 80 00       	push   $0x80230a
  80033b:	6a 23                	push   $0x23
  80033d:	68 27 23 80 00       	push   $0x802327
  800342:	e8 7e 11 00 00       	call   8014c5 <_panic>

00800347 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800347:	55                   	push   %ebp
  800348:	89 e5                	mov    %esp,%ebp
  80034a:	57                   	push   %edi
  80034b:	56                   	push   %esi
  80034c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80034d:	ba 00 00 00 00       	mov    $0x0,%edx
  800352:	b8 0e 00 00 00       	mov    $0xe,%eax
  800357:	89 d1                	mov    %edx,%ecx
  800359:	89 d3                	mov    %edx,%ebx
  80035b:	89 d7                	mov    %edx,%edi
  80035d:	89 d6                	mov    %edx,%esi
  80035f:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800361:	5b                   	pop    %ebx
  800362:	5e                   	pop    %esi
  800363:	5f                   	pop    %edi
  800364:	5d                   	pop    %ebp
  800365:	c3                   	ret    

00800366 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800366:	55                   	push   %ebp
  800367:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800369:	8b 45 08             	mov    0x8(%ebp),%eax
  80036c:	05 00 00 00 30       	add    $0x30000000,%eax
  800371:	c1 e8 0c             	shr    $0xc,%eax
}
  800374:	5d                   	pop    %ebp
  800375:	c3                   	ret    

00800376 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800376:	55                   	push   %ebp
  800377:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800379:	8b 45 08             	mov    0x8(%ebp),%eax
  80037c:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800381:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800386:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80038b:	5d                   	pop    %ebp
  80038c:	c3                   	ret    

0080038d <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80038d:	55                   	push   %ebp
  80038e:	89 e5                	mov    %esp,%ebp
  800390:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800393:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800398:	89 c2                	mov    %eax,%edx
  80039a:	c1 ea 16             	shr    $0x16,%edx
  80039d:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8003a4:	f6 c2 01             	test   $0x1,%dl
  8003a7:	74 2a                	je     8003d3 <fd_alloc+0x46>
  8003a9:	89 c2                	mov    %eax,%edx
  8003ab:	c1 ea 0c             	shr    $0xc,%edx
  8003ae:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8003b5:	f6 c2 01             	test   $0x1,%dl
  8003b8:	74 19                	je     8003d3 <fd_alloc+0x46>
  8003ba:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8003bf:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8003c4:	75 d2                	jne    800398 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8003c6:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8003cc:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8003d1:	eb 07                	jmp    8003da <fd_alloc+0x4d>
			*fd_store = fd;
  8003d3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8003d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8003da:	5d                   	pop    %ebp
  8003db:	c3                   	ret    

008003dc <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8003dc:	55                   	push   %ebp
  8003dd:	89 e5                	mov    %esp,%ebp
  8003df:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8003e2:	83 f8 1f             	cmp    $0x1f,%eax
  8003e5:	77 36                	ja     80041d <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8003e7:	c1 e0 0c             	shl    $0xc,%eax
  8003ea:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8003ef:	89 c2                	mov    %eax,%edx
  8003f1:	c1 ea 16             	shr    $0x16,%edx
  8003f4:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8003fb:	f6 c2 01             	test   $0x1,%dl
  8003fe:	74 24                	je     800424 <fd_lookup+0x48>
  800400:	89 c2                	mov    %eax,%edx
  800402:	c1 ea 0c             	shr    $0xc,%edx
  800405:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80040c:	f6 c2 01             	test   $0x1,%dl
  80040f:	74 1a                	je     80042b <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800411:	8b 55 0c             	mov    0xc(%ebp),%edx
  800414:	89 02                	mov    %eax,(%edx)
	return 0;
  800416:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80041b:	5d                   	pop    %ebp
  80041c:	c3                   	ret    
		return -E_INVAL;
  80041d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800422:	eb f7                	jmp    80041b <fd_lookup+0x3f>
		return -E_INVAL;
  800424:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800429:	eb f0                	jmp    80041b <fd_lookup+0x3f>
  80042b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800430:	eb e9                	jmp    80041b <fd_lookup+0x3f>

00800432 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800432:	55                   	push   %ebp
  800433:	89 e5                	mov    %esp,%ebp
  800435:	83 ec 08             	sub    $0x8,%esp
  800438:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80043b:	ba b4 23 80 00       	mov    $0x8023b4,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800440:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800445:	39 08                	cmp    %ecx,(%eax)
  800447:	74 33                	je     80047c <dev_lookup+0x4a>
  800449:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  80044c:	8b 02                	mov    (%edx),%eax
  80044e:	85 c0                	test   %eax,%eax
  800450:	75 f3                	jne    800445 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800452:	a1 08 40 80 00       	mov    0x804008,%eax
  800457:	8b 40 48             	mov    0x48(%eax),%eax
  80045a:	83 ec 04             	sub    $0x4,%esp
  80045d:	51                   	push   %ecx
  80045e:	50                   	push   %eax
  80045f:	68 38 23 80 00       	push   $0x802338
  800464:	e8 37 11 00 00       	call   8015a0 <cprintf>
	*dev = 0;
  800469:	8b 45 0c             	mov    0xc(%ebp),%eax
  80046c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800472:	83 c4 10             	add    $0x10,%esp
  800475:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80047a:	c9                   	leave  
  80047b:	c3                   	ret    
			*dev = devtab[i];
  80047c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80047f:	89 01                	mov    %eax,(%ecx)
			return 0;
  800481:	b8 00 00 00 00       	mov    $0x0,%eax
  800486:	eb f2                	jmp    80047a <dev_lookup+0x48>

00800488 <fd_close>:
{
  800488:	55                   	push   %ebp
  800489:	89 e5                	mov    %esp,%ebp
  80048b:	57                   	push   %edi
  80048c:	56                   	push   %esi
  80048d:	53                   	push   %ebx
  80048e:	83 ec 1c             	sub    $0x1c,%esp
  800491:	8b 75 08             	mov    0x8(%ebp),%esi
  800494:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800497:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80049a:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80049b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8004a1:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8004a4:	50                   	push   %eax
  8004a5:	e8 32 ff ff ff       	call   8003dc <fd_lookup>
  8004aa:	89 c3                	mov    %eax,%ebx
  8004ac:	83 c4 08             	add    $0x8,%esp
  8004af:	85 c0                	test   %eax,%eax
  8004b1:	78 05                	js     8004b8 <fd_close+0x30>
	    || fd != fd2)
  8004b3:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8004b6:	74 16                	je     8004ce <fd_close+0x46>
		return (must_exist ? r : 0);
  8004b8:	89 f8                	mov    %edi,%eax
  8004ba:	84 c0                	test   %al,%al
  8004bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8004c1:	0f 44 d8             	cmove  %eax,%ebx
}
  8004c4:	89 d8                	mov    %ebx,%eax
  8004c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004c9:	5b                   	pop    %ebx
  8004ca:	5e                   	pop    %esi
  8004cb:	5f                   	pop    %edi
  8004cc:	5d                   	pop    %ebp
  8004cd:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8004ce:	83 ec 08             	sub    $0x8,%esp
  8004d1:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8004d4:	50                   	push   %eax
  8004d5:	ff 36                	pushl  (%esi)
  8004d7:	e8 56 ff ff ff       	call   800432 <dev_lookup>
  8004dc:	89 c3                	mov    %eax,%ebx
  8004de:	83 c4 10             	add    $0x10,%esp
  8004e1:	85 c0                	test   %eax,%eax
  8004e3:	78 15                	js     8004fa <fd_close+0x72>
		if (dev->dev_close)
  8004e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004e8:	8b 40 10             	mov    0x10(%eax),%eax
  8004eb:	85 c0                	test   %eax,%eax
  8004ed:	74 1b                	je     80050a <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  8004ef:	83 ec 0c             	sub    $0xc,%esp
  8004f2:	56                   	push   %esi
  8004f3:	ff d0                	call   *%eax
  8004f5:	89 c3                	mov    %eax,%ebx
  8004f7:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8004fa:	83 ec 08             	sub    $0x8,%esp
  8004fd:	56                   	push   %esi
  8004fe:	6a 00                	push   $0x0
  800500:	e8 d6 fc ff ff       	call   8001db <sys_page_unmap>
	return r;
  800505:	83 c4 10             	add    $0x10,%esp
  800508:	eb ba                	jmp    8004c4 <fd_close+0x3c>
			r = 0;
  80050a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80050f:	eb e9                	jmp    8004fa <fd_close+0x72>

00800511 <close>:

int
close(int fdnum)
{
  800511:	55                   	push   %ebp
  800512:	89 e5                	mov    %esp,%ebp
  800514:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800517:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80051a:	50                   	push   %eax
  80051b:	ff 75 08             	pushl  0x8(%ebp)
  80051e:	e8 b9 fe ff ff       	call   8003dc <fd_lookup>
  800523:	83 c4 08             	add    $0x8,%esp
  800526:	85 c0                	test   %eax,%eax
  800528:	78 10                	js     80053a <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  80052a:	83 ec 08             	sub    $0x8,%esp
  80052d:	6a 01                	push   $0x1
  80052f:	ff 75 f4             	pushl  -0xc(%ebp)
  800532:	e8 51 ff ff ff       	call   800488 <fd_close>
  800537:	83 c4 10             	add    $0x10,%esp
}
  80053a:	c9                   	leave  
  80053b:	c3                   	ret    

0080053c <close_all>:

void
close_all(void)
{
  80053c:	55                   	push   %ebp
  80053d:	89 e5                	mov    %esp,%ebp
  80053f:	53                   	push   %ebx
  800540:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800543:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800548:	83 ec 0c             	sub    $0xc,%esp
  80054b:	53                   	push   %ebx
  80054c:	e8 c0 ff ff ff       	call   800511 <close>
	for (i = 0; i < MAXFD; i++)
  800551:	83 c3 01             	add    $0x1,%ebx
  800554:	83 c4 10             	add    $0x10,%esp
  800557:	83 fb 20             	cmp    $0x20,%ebx
  80055a:	75 ec                	jne    800548 <close_all+0xc>
}
  80055c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80055f:	c9                   	leave  
  800560:	c3                   	ret    

00800561 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800561:	55                   	push   %ebp
  800562:	89 e5                	mov    %esp,%ebp
  800564:	57                   	push   %edi
  800565:	56                   	push   %esi
  800566:	53                   	push   %ebx
  800567:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80056a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80056d:	50                   	push   %eax
  80056e:	ff 75 08             	pushl  0x8(%ebp)
  800571:	e8 66 fe ff ff       	call   8003dc <fd_lookup>
  800576:	89 c3                	mov    %eax,%ebx
  800578:	83 c4 08             	add    $0x8,%esp
  80057b:	85 c0                	test   %eax,%eax
  80057d:	0f 88 81 00 00 00    	js     800604 <dup+0xa3>
		return r;
	close(newfdnum);
  800583:	83 ec 0c             	sub    $0xc,%esp
  800586:	ff 75 0c             	pushl  0xc(%ebp)
  800589:	e8 83 ff ff ff       	call   800511 <close>

	newfd = INDEX2FD(newfdnum);
  80058e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800591:	c1 e6 0c             	shl    $0xc,%esi
  800594:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80059a:	83 c4 04             	add    $0x4,%esp
  80059d:	ff 75 e4             	pushl  -0x1c(%ebp)
  8005a0:	e8 d1 fd ff ff       	call   800376 <fd2data>
  8005a5:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8005a7:	89 34 24             	mov    %esi,(%esp)
  8005aa:	e8 c7 fd ff ff       	call   800376 <fd2data>
  8005af:	83 c4 10             	add    $0x10,%esp
  8005b2:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8005b4:	89 d8                	mov    %ebx,%eax
  8005b6:	c1 e8 16             	shr    $0x16,%eax
  8005b9:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8005c0:	a8 01                	test   $0x1,%al
  8005c2:	74 11                	je     8005d5 <dup+0x74>
  8005c4:	89 d8                	mov    %ebx,%eax
  8005c6:	c1 e8 0c             	shr    $0xc,%eax
  8005c9:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8005d0:	f6 c2 01             	test   $0x1,%dl
  8005d3:	75 39                	jne    80060e <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8005d5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8005d8:	89 d0                	mov    %edx,%eax
  8005da:	c1 e8 0c             	shr    $0xc,%eax
  8005dd:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8005e4:	83 ec 0c             	sub    $0xc,%esp
  8005e7:	25 07 0e 00 00       	and    $0xe07,%eax
  8005ec:	50                   	push   %eax
  8005ed:	56                   	push   %esi
  8005ee:	6a 00                	push   $0x0
  8005f0:	52                   	push   %edx
  8005f1:	6a 00                	push   $0x0
  8005f3:	e8 a1 fb ff ff       	call   800199 <sys_page_map>
  8005f8:	89 c3                	mov    %eax,%ebx
  8005fa:	83 c4 20             	add    $0x20,%esp
  8005fd:	85 c0                	test   %eax,%eax
  8005ff:	78 31                	js     800632 <dup+0xd1>
		goto err;

	return newfdnum;
  800601:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  800604:	89 d8                	mov    %ebx,%eax
  800606:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800609:	5b                   	pop    %ebx
  80060a:	5e                   	pop    %esi
  80060b:	5f                   	pop    %edi
  80060c:	5d                   	pop    %ebp
  80060d:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80060e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800615:	83 ec 0c             	sub    $0xc,%esp
  800618:	25 07 0e 00 00       	and    $0xe07,%eax
  80061d:	50                   	push   %eax
  80061e:	57                   	push   %edi
  80061f:	6a 00                	push   $0x0
  800621:	53                   	push   %ebx
  800622:	6a 00                	push   $0x0
  800624:	e8 70 fb ff ff       	call   800199 <sys_page_map>
  800629:	89 c3                	mov    %eax,%ebx
  80062b:	83 c4 20             	add    $0x20,%esp
  80062e:	85 c0                	test   %eax,%eax
  800630:	79 a3                	jns    8005d5 <dup+0x74>
	sys_page_unmap(0, newfd);
  800632:	83 ec 08             	sub    $0x8,%esp
  800635:	56                   	push   %esi
  800636:	6a 00                	push   $0x0
  800638:	e8 9e fb ff ff       	call   8001db <sys_page_unmap>
	sys_page_unmap(0, nva);
  80063d:	83 c4 08             	add    $0x8,%esp
  800640:	57                   	push   %edi
  800641:	6a 00                	push   $0x0
  800643:	e8 93 fb ff ff       	call   8001db <sys_page_unmap>
	return r;
  800648:	83 c4 10             	add    $0x10,%esp
  80064b:	eb b7                	jmp    800604 <dup+0xa3>

0080064d <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80064d:	55                   	push   %ebp
  80064e:	89 e5                	mov    %esp,%ebp
  800650:	53                   	push   %ebx
  800651:	83 ec 14             	sub    $0x14,%esp
  800654:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800657:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80065a:	50                   	push   %eax
  80065b:	53                   	push   %ebx
  80065c:	e8 7b fd ff ff       	call   8003dc <fd_lookup>
  800661:	83 c4 08             	add    $0x8,%esp
  800664:	85 c0                	test   %eax,%eax
  800666:	78 3f                	js     8006a7 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800668:	83 ec 08             	sub    $0x8,%esp
  80066b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80066e:	50                   	push   %eax
  80066f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800672:	ff 30                	pushl  (%eax)
  800674:	e8 b9 fd ff ff       	call   800432 <dev_lookup>
  800679:	83 c4 10             	add    $0x10,%esp
  80067c:	85 c0                	test   %eax,%eax
  80067e:	78 27                	js     8006a7 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800680:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800683:	8b 42 08             	mov    0x8(%edx),%eax
  800686:	83 e0 03             	and    $0x3,%eax
  800689:	83 f8 01             	cmp    $0x1,%eax
  80068c:	74 1e                	je     8006ac <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80068e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800691:	8b 40 08             	mov    0x8(%eax),%eax
  800694:	85 c0                	test   %eax,%eax
  800696:	74 35                	je     8006cd <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  800698:	83 ec 04             	sub    $0x4,%esp
  80069b:	ff 75 10             	pushl  0x10(%ebp)
  80069e:	ff 75 0c             	pushl  0xc(%ebp)
  8006a1:	52                   	push   %edx
  8006a2:	ff d0                	call   *%eax
  8006a4:	83 c4 10             	add    $0x10,%esp
}
  8006a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006aa:	c9                   	leave  
  8006ab:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8006ac:	a1 08 40 80 00       	mov    0x804008,%eax
  8006b1:	8b 40 48             	mov    0x48(%eax),%eax
  8006b4:	83 ec 04             	sub    $0x4,%esp
  8006b7:	53                   	push   %ebx
  8006b8:	50                   	push   %eax
  8006b9:	68 79 23 80 00       	push   $0x802379
  8006be:	e8 dd 0e 00 00       	call   8015a0 <cprintf>
		return -E_INVAL;
  8006c3:	83 c4 10             	add    $0x10,%esp
  8006c6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8006cb:	eb da                	jmp    8006a7 <read+0x5a>
		return -E_NOT_SUPP;
  8006cd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8006d2:	eb d3                	jmp    8006a7 <read+0x5a>

008006d4 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8006d4:	55                   	push   %ebp
  8006d5:	89 e5                	mov    %esp,%ebp
  8006d7:	57                   	push   %edi
  8006d8:	56                   	push   %esi
  8006d9:	53                   	push   %ebx
  8006da:	83 ec 0c             	sub    $0xc,%esp
  8006dd:	8b 7d 08             	mov    0x8(%ebp),%edi
  8006e0:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8006e3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006e8:	39 f3                	cmp    %esi,%ebx
  8006ea:	73 25                	jae    800711 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8006ec:	83 ec 04             	sub    $0x4,%esp
  8006ef:	89 f0                	mov    %esi,%eax
  8006f1:	29 d8                	sub    %ebx,%eax
  8006f3:	50                   	push   %eax
  8006f4:	89 d8                	mov    %ebx,%eax
  8006f6:	03 45 0c             	add    0xc(%ebp),%eax
  8006f9:	50                   	push   %eax
  8006fa:	57                   	push   %edi
  8006fb:	e8 4d ff ff ff       	call   80064d <read>
		if (m < 0)
  800700:	83 c4 10             	add    $0x10,%esp
  800703:	85 c0                	test   %eax,%eax
  800705:	78 08                	js     80070f <readn+0x3b>
			return m;
		if (m == 0)
  800707:	85 c0                	test   %eax,%eax
  800709:	74 06                	je     800711 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  80070b:	01 c3                	add    %eax,%ebx
  80070d:	eb d9                	jmp    8006e8 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80070f:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  800711:	89 d8                	mov    %ebx,%eax
  800713:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800716:	5b                   	pop    %ebx
  800717:	5e                   	pop    %esi
  800718:	5f                   	pop    %edi
  800719:	5d                   	pop    %ebp
  80071a:	c3                   	ret    

0080071b <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80071b:	55                   	push   %ebp
  80071c:	89 e5                	mov    %esp,%ebp
  80071e:	53                   	push   %ebx
  80071f:	83 ec 14             	sub    $0x14,%esp
  800722:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800725:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800728:	50                   	push   %eax
  800729:	53                   	push   %ebx
  80072a:	e8 ad fc ff ff       	call   8003dc <fd_lookup>
  80072f:	83 c4 08             	add    $0x8,%esp
  800732:	85 c0                	test   %eax,%eax
  800734:	78 3a                	js     800770 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800736:	83 ec 08             	sub    $0x8,%esp
  800739:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80073c:	50                   	push   %eax
  80073d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800740:	ff 30                	pushl  (%eax)
  800742:	e8 eb fc ff ff       	call   800432 <dev_lookup>
  800747:	83 c4 10             	add    $0x10,%esp
  80074a:	85 c0                	test   %eax,%eax
  80074c:	78 22                	js     800770 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80074e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800751:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800755:	74 1e                	je     800775 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800757:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80075a:	8b 52 0c             	mov    0xc(%edx),%edx
  80075d:	85 d2                	test   %edx,%edx
  80075f:	74 35                	je     800796 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  800761:	83 ec 04             	sub    $0x4,%esp
  800764:	ff 75 10             	pushl  0x10(%ebp)
  800767:	ff 75 0c             	pushl  0xc(%ebp)
  80076a:	50                   	push   %eax
  80076b:	ff d2                	call   *%edx
  80076d:	83 c4 10             	add    $0x10,%esp
}
  800770:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800773:	c9                   	leave  
  800774:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800775:	a1 08 40 80 00       	mov    0x804008,%eax
  80077a:	8b 40 48             	mov    0x48(%eax),%eax
  80077d:	83 ec 04             	sub    $0x4,%esp
  800780:	53                   	push   %ebx
  800781:	50                   	push   %eax
  800782:	68 95 23 80 00       	push   $0x802395
  800787:	e8 14 0e 00 00       	call   8015a0 <cprintf>
		return -E_INVAL;
  80078c:	83 c4 10             	add    $0x10,%esp
  80078f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800794:	eb da                	jmp    800770 <write+0x55>
		return -E_NOT_SUPP;
  800796:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80079b:	eb d3                	jmp    800770 <write+0x55>

0080079d <seek>:

int
seek(int fdnum, off_t offset)
{
  80079d:	55                   	push   %ebp
  80079e:	89 e5                	mov    %esp,%ebp
  8007a0:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8007a3:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8007a6:	50                   	push   %eax
  8007a7:	ff 75 08             	pushl  0x8(%ebp)
  8007aa:	e8 2d fc ff ff       	call   8003dc <fd_lookup>
  8007af:	83 c4 08             	add    $0x8,%esp
  8007b2:	85 c0                	test   %eax,%eax
  8007b4:	78 0e                	js     8007c4 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8007b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8007bc:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8007bf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8007c4:	c9                   	leave  
  8007c5:	c3                   	ret    

008007c6 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8007c6:	55                   	push   %ebp
  8007c7:	89 e5                	mov    %esp,%ebp
  8007c9:	53                   	push   %ebx
  8007ca:	83 ec 14             	sub    $0x14,%esp
  8007cd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8007d0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8007d3:	50                   	push   %eax
  8007d4:	53                   	push   %ebx
  8007d5:	e8 02 fc ff ff       	call   8003dc <fd_lookup>
  8007da:	83 c4 08             	add    $0x8,%esp
  8007dd:	85 c0                	test   %eax,%eax
  8007df:	78 37                	js     800818 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8007e1:	83 ec 08             	sub    $0x8,%esp
  8007e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8007e7:	50                   	push   %eax
  8007e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007eb:	ff 30                	pushl  (%eax)
  8007ed:	e8 40 fc ff ff       	call   800432 <dev_lookup>
  8007f2:	83 c4 10             	add    $0x10,%esp
  8007f5:	85 c0                	test   %eax,%eax
  8007f7:	78 1f                	js     800818 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8007f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007fc:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800800:	74 1b                	je     80081d <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  800802:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800805:	8b 52 18             	mov    0x18(%edx),%edx
  800808:	85 d2                	test   %edx,%edx
  80080a:	74 32                	je     80083e <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80080c:	83 ec 08             	sub    $0x8,%esp
  80080f:	ff 75 0c             	pushl  0xc(%ebp)
  800812:	50                   	push   %eax
  800813:	ff d2                	call   *%edx
  800815:	83 c4 10             	add    $0x10,%esp
}
  800818:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80081b:	c9                   	leave  
  80081c:	c3                   	ret    
			thisenv->env_id, fdnum);
  80081d:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800822:	8b 40 48             	mov    0x48(%eax),%eax
  800825:	83 ec 04             	sub    $0x4,%esp
  800828:	53                   	push   %ebx
  800829:	50                   	push   %eax
  80082a:	68 58 23 80 00       	push   $0x802358
  80082f:	e8 6c 0d 00 00       	call   8015a0 <cprintf>
		return -E_INVAL;
  800834:	83 c4 10             	add    $0x10,%esp
  800837:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80083c:	eb da                	jmp    800818 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80083e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800843:	eb d3                	jmp    800818 <ftruncate+0x52>

00800845 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800845:	55                   	push   %ebp
  800846:	89 e5                	mov    %esp,%ebp
  800848:	53                   	push   %ebx
  800849:	83 ec 14             	sub    $0x14,%esp
  80084c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80084f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800852:	50                   	push   %eax
  800853:	ff 75 08             	pushl  0x8(%ebp)
  800856:	e8 81 fb ff ff       	call   8003dc <fd_lookup>
  80085b:	83 c4 08             	add    $0x8,%esp
  80085e:	85 c0                	test   %eax,%eax
  800860:	78 4b                	js     8008ad <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800862:	83 ec 08             	sub    $0x8,%esp
  800865:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800868:	50                   	push   %eax
  800869:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80086c:	ff 30                	pushl  (%eax)
  80086e:	e8 bf fb ff ff       	call   800432 <dev_lookup>
  800873:	83 c4 10             	add    $0x10,%esp
  800876:	85 c0                	test   %eax,%eax
  800878:	78 33                	js     8008ad <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80087a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80087d:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  800881:	74 2f                	je     8008b2 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800883:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  800886:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80088d:	00 00 00 
	stat->st_isdir = 0;
  800890:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800897:	00 00 00 
	stat->st_dev = dev;
  80089a:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8008a0:	83 ec 08             	sub    $0x8,%esp
  8008a3:	53                   	push   %ebx
  8008a4:	ff 75 f0             	pushl  -0x10(%ebp)
  8008a7:	ff 50 14             	call   *0x14(%eax)
  8008aa:	83 c4 10             	add    $0x10,%esp
}
  8008ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008b0:	c9                   	leave  
  8008b1:	c3                   	ret    
		return -E_NOT_SUPP;
  8008b2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8008b7:	eb f4                	jmp    8008ad <fstat+0x68>

008008b9 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8008b9:	55                   	push   %ebp
  8008ba:	89 e5                	mov    %esp,%ebp
  8008bc:	56                   	push   %esi
  8008bd:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8008be:	83 ec 08             	sub    $0x8,%esp
  8008c1:	6a 00                	push   $0x0
  8008c3:	ff 75 08             	pushl  0x8(%ebp)
  8008c6:	e8 26 02 00 00       	call   800af1 <open>
  8008cb:	89 c3                	mov    %eax,%ebx
  8008cd:	83 c4 10             	add    $0x10,%esp
  8008d0:	85 c0                	test   %eax,%eax
  8008d2:	78 1b                	js     8008ef <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8008d4:	83 ec 08             	sub    $0x8,%esp
  8008d7:	ff 75 0c             	pushl  0xc(%ebp)
  8008da:	50                   	push   %eax
  8008db:	e8 65 ff ff ff       	call   800845 <fstat>
  8008e0:	89 c6                	mov    %eax,%esi
	close(fd);
  8008e2:	89 1c 24             	mov    %ebx,(%esp)
  8008e5:	e8 27 fc ff ff       	call   800511 <close>
	return r;
  8008ea:	83 c4 10             	add    $0x10,%esp
  8008ed:	89 f3                	mov    %esi,%ebx
}
  8008ef:	89 d8                	mov    %ebx,%eax
  8008f1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008f4:	5b                   	pop    %ebx
  8008f5:	5e                   	pop    %esi
  8008f6:	5d                   	pop    %ebp
  8008f7:	c3                   	ret    

008008f8 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8008f8:	55                   	push   %ebp
  8008f9:	89 e5                	mov    %esp,%ebp
  8008fb:	56                   	push   %esi
  8008fc:	53                   	push   %ebx
  8008fd:	89 c6                	mov    %eax,%esi
  8008ff:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  800901:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  800908:	74 27                	je     800931 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80090a:	6a 07                	push   $0x7
  80090c:	68 00 50 80 00       	push   $0x805000
  800911:	56                   	push   %esi
  800912:	ff 35 00 40 80 00    	pushl  0x804000
  800918:	e8 c6 16 00 00       	call   801fe3 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80091d:	83 c4 0c             	add    $0xc,%esp
  800920:	6a 00                	push   $0x0
  800922:	53                   	push   %ebx
  800923:	6a 00                	push   $0x0
  800925:	e8 50 16 00 00       	call   801f7a <ipc_recv>
}
  80092a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80092d:	5b                   	pop    %ebx
  80092e:	5e                   	pop    %esi
  80092f:	5d                   	pop    %ebp
  800930:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800931:	83 ec 0c             	sub    $0xc,%esp
  800934:	6a 01                	push   $0x1
  800936:	e8 01 17 00 00       	call   80203c <ipc_find_env>
  80093b:	a3 00 40 80 00       	mov    %eax,0x804000
  800940:	83 c4 10             	add    $0x10,%esp
  800943:	eb c5                	jmp    80090a <fsipc+0x12>

00800945 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  800945:	55                   	push   %ebp
  800946:	89 e5                	mov    %esp,%ebp
  800948:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80094b:	8b 45 08             	mov    0x8(%ebp),%eax
  80094e:	8b 40 0c             	mov    0xc(%eax),%eax
  800951:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  800956:	8b 45 0c             	mov    0xc(%ebp),%eax
  800959:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80095e:	ba 00 00 00 00       	mov    $0x0,%edx
  800963:	b8 02 00 00 00       	mov    $0x2,%eax
  800968:	e8 8b ff ff ff       	call   8008f8 <fsipc>
}
  80096d:	c9                   	leave  
  80096e:	c3                   	ret    

0080096f <devfile_flush>:
{
  80096f:	55                   	push   %ebp
  800970:	89 e5                	mov    %esp,%ebp
  800972:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800975:	8b 45 08             	mov    0x8(%ebp),%eax
  800978:	8b 40 0c             	mov    0xc(%eax),%eax
  80097b:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800980:	ba 00 00 00 00       	mov    $0x0,%edx
  800985:	b8 06 00 00 00       	mov    $0x6,%eax
  80098a:	e8 69 ff ff ff       	call   8008f8 <fsipc>
}
  80098f:	c9                   	leave  
  800990:	c3                   	ret    

00800991 <devfile_stat>:
{
  800991:	55                   	push   %ebp
  800992:	89 e5                	mov    %esp,%ebp
  800994:	53                   	push   %ebx
  800995:	83 ec 04             	sub    $0x4,%esp
  800998:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80099b:	8b 45 08             	mov    0x8(%ebp),%eax
  80099e:	8b 40 0c             	mov    0xc(%eax),%eax
  8009a1:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8009a6:	ba 00 00 00 00       	mov    $0x0,%edx
  8009ab:	b8 05 00 00 00       	mov    $0x5,%eax
  8009b0:	e8 43 ff ff ff       	call   8008f8 <fsipc>
  8009b5:	85 c0                	test   %eax,%eax
  8009b7:	78 2c                	js     8009e5 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8009b9:	83 ec 08             	sub    $0x8,%esp
  8009bc:	68 00 50 80 00       	push   $0x805000
  8009c1:	53                   	push   %ebx
  8009c2:	e8 76 12 00 00       	call   801c3d <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8009c7:	a1 80 50 80 00       	mov    0x805080,%eax
  8009cc:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8009d2:	a1 84 50 80 00       	mov    0x805084,%eax
  8009d7:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8009dd:	83 c4 10             	add    $0x10,%esp
  8009e0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009e8:	c9                   	leave  
  8009e9:	c3                   	ret    

008009ea <devfile_write>:
{
  8009ea:	55                   	push   %ebp
  8009eb:	89 e5                	mov    %esp,%ebp
  8009ed:	53                   	push   %ebx
  8009ee:	83 ec 04             	sub    $0x4,%esp
  8009f1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8009f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f7:	8b 40 0c             	mov    0xc(%eax),%eax
  8009fa:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  8009ff:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  800a05:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  800a0b:	77 30                	ja     800a3d <devfile_write+0x53>
	memmove(fsipcbuf.write.req_buf, buf, n);
  800a0d:	83 ec 04             	sub    $0x4,%esp
  800a10:	53                   	push   %ebx
  800a11:	ff 75 0c             	pushl  0xc(%ebp)
  800a14:	68 08 50 80 00       	push   $0x805008
  800a19:	e8 ad 13 00 00       	call   801dcb <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  800a1e:	ba 00 00 00 00       	mov    $0x0,%edx
  800a23:	b8 04 00 00 00       	mov    $0x4,%eax
  800a28:	e8 cb fe ff ff       	call   8008f8 <fsipc>
  800a2d:	83 c4 10             	add    $0x10,%esp
  800a30:	85 c0                	test   %eax,%eax
  800a32:	78 04                	js     800a38 <devfile_write+0x4e>
	assert(r <= n);
  800a34:	39 d8                	cmp    %ebx,%eax
  800a36:	77 1e                	ja     800a56 <devfile_write+0x6c>
}
  800a38:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a3b:	c9                   	leave  
  800a3c:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  800a3d:	68 c8 23 80 00       	push   $0x8023c8
  800a42:	68 f5 23 80 00       	push   $0x8023f5
  800a47:	68 94 00 00 00       	push   $0x94
  800a4c:	68 0a 24 80 00       	push   $0x80240a
  800a51:	e8 6f 0a 00 00       	call   8014c5 <_panic>
	assert(r <= n);
  800a56:	68 15 24 80 00       	push   $0x802415
  800a5b:	68 f5 23 80 00       	push   $0x8023f5
  800a60:	68 98 00 00 00       	push   $0x98
  800a65:	68 0a 24 80 00       	push   $0x80240a
  800a6a:	e8 56 0a 00 00       	call   8014c5 <_panic>

00800a6f <devfile_read>:
{
  800a6f:	55                   	push   %ebp
  800a70:	89 e5                	mov    %esp,%ebp
  800a72:	56                   	push   %esi
  800a73:	53                   	push   %ebx
  800a74:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800a77:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7a:	8b 40 0c             	mov    0xc(%eax),%eax
  800a7d:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800a82:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800a88:	ba 00 00 00 00       	mov    $0x0,%edx
  800a8d:	b8 03 00 00 00       	mov    $0x3,%eax
  800a92:	e8 61 fe ff ff       	call   8008f8 <fsipc>
  800a97:	89 c3                	mov    %eax,%ebx
  800a99:	85 c0                	test   %eax,%eax
  800a9b:	78 1f                	js     800abc <devfile_read+0x4d>
	assert(r <= n);
  800a9d:	39 f0                	cmp    %esi,%eax
  800a9f:	77 24                	ja     800ac5 <devfile_read+0x56>
	assert(r <= PGSIZE);
  800aa1:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800aa6:	7f 33                	jg     800adb <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800aa8:	83 ec 04             	sub    $0x4,%esp
  800aab:	50                   	push   %eax
  800aac:	68 00 50 80 00       	push   $0x805000
  800ab1:	ff 75 0c             	pushl  0xc(%ebp)
  800ab4:	e8 12 13 00 00       	call   801dcb <memmove>
	return r;
  800ab9:	83 c4 10             	add    $0x10,%esp
}
  800abc:	89 d8                	mov    %ebx,%eax
  800abe:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ac1:	5b                   	pop    %ebx
  800ac2:	5e                   	pop    %esi
  800ac3:	5d                   	pop    %ebp
  800ac4:	c3                   	ret    
	assert(r <= n);
  800ac5:	68 15 24 80 00       	push   $0x802415
  800aca:	68 f5 23 80 00       	push   $0x8023f5
  800acf:	6a 7c                	push   $0x7c
  800ad1:	68 0a 24 80 00       	push   $0x80240a
  800ad6:	e8 ea 09 00 00       	call   8014c5 <_panic>
	assert(r <= PGSIZE);
  800adb:	68 1c 24 80 00       	push   $0x80241c
  800ae0:	68 f5 23 80 00       	push   $0x8023f5
  800ae5:	6a 7d                	push   $0x7d
  800ae7:	68 0a 24 80 00       	push   $0x80240a
  800aec:	e8 d4 09 00 00       	call   8014c5 <_panic>

00800af1 <open>:
{
  800af1:	55                   	push   %ebp
  800af2:	89 e5                	mov    %esp,%ebp
  800af4:	56                   	push   %esi
  800af5:	53                   	push   %ebx
  800af6:	83 ec 1c             	sub    $0x1c,%esp
  800af9:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800afc:	56                   	push   %esi
  800afd:	e8 04 11 00 00       	call   801c06 <strlen>
  800b02:	83 c4 10             	add    $0x10,%esp
  800b05:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800b0a:	7f 6c                	jg     800b78 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  800b0c:	83 ec 0c             	sub    $0xc,%esp
  800b0f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800b12:	50                   	push   %eax
  800b13:	e8 75 f8 ff ff       	call   80038d <fd_alloc>
  800b18:	89 c3                	mov    %eax,%ebx
  800b1a:	83 c4 10             	add    $0x10,%esp
  800b1d:	85 c0                	test   %eax,%eax
  800b1f:	78 3c                	js     800b5d <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  800b21:	83 ec 08             	sub    $0x8,%esp
  800b24:	56                   	push   %esi
  800b25:	68 00 50 80 00       	push   $0x805000
  800b2a:	e8 0e 11 00 00       	call   801c3d <strcpy>
	fsipcbuf.open.req_omode = mode;
  800b2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b32:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800b37:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b3a:	b8 01 00 00 00       	mov    $0x1,%eax
  800b3f:	e8 b4 fd ff ff       	call   8008f8 <fsipc>
  800b44:	89 c3                	mov    %eax,%ebx
  800b46:	83 c4 10             	add    $0x10,%esp
  800b49:	85 c0                	test   %eax,%eax
  800b4b:	78 19                	js     800b66 <open+0x75>
	return fd2num(fd);
  800b4d:	83 ec 0c             	sub    $0xc,%esp
  800b50:	ff 75 f4             	pushl  -0xc(%ebp)
  800b53:	e8 0e f8 ff ff       	call   800366 <fd2num>
  800b58:	89 c3                	mov    %eax,%ebx
  800b5a:	83 c4 10             	add    $0x10,%esp
}
  800b5d:	89 d8                	mov    %ebx,%eax
  800b5f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b62:	5b                   	pop    %ebx
  800b63:	5e                   	pop    %esi
  800b64:	5d                   	pop    %ebp
  800b65:	c3                   	ret    
		fd_close(fd, 0);
  800b66:	83 ec 08             	sub    $0x8,%esp
  800b69:	6a 00                	push   $0x0
  800b6b:	ff 75 f4             	pushl  -0xc(%ebp)
  800b6e:	e8 15 f9 ff ff       	call   800488 <fd_close>
		return r;
  800b73:	83 c4 10             	add    $0x10,%esp
  800b76:	eb e5                	jmp    800b5d <open+0x6c>
		return -E_BAD_PATH;
  800b78:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800b7d:	eb de                	jmp    800b5d <open+0x6c>

00800b7f <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800b7f:	55                   	push   %ebp
  800b80:	89 e5                	mov    %esp,%ebp
  800b82:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800b85:	ba 00 00 00 00       	mov    $0x0,%edx
  800b8a:	b8 08 00 00 00       	mov    $0x8,%eax
  800b8f:	e8 64 fd ff ff       	call   8008f8 <fsipc>
}
  800b94:	c9                   	leave  
  800b95:	c3                   	ret    

00800b96 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800b96:	55                   	push   %ebp
  800b97:	89 e5                	mov    %esp,%ebp
  800b99:	56                   	push   %esi
  800b9a:	53                   	push   %ebx
  800b9b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800b9e:	83 ec 0c             	sub    $0xc,%esp
  800ba1:	ff 75 08             	pushl  0x8(%ebp)
  800ba4:	e8 cd f7 ff ff       	call   800376 <fd2data>
  800ba9:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  800bab:	83 c4 08             	add    $0x8,%esp
  800bae:	68 28 24 80 00       	push   $0x802428
  800bb3:	53                   	push   %ebx
  800bb4:	e8 84 10 00 00       	call   801c3d <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  800bb9:	8b 46 04             	mov    0x4(%esi),%eax
  800bbc:	2b 06                	sub    (%esi),%eax
  800bbe:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  800bc4:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800bcb:	00 00 00 
	stat->st_dev = &devpipe;
  800bce:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  800bd5:	30 80 00 
	return 0;
}
  800bd8:	b8 00 00 00 00       	mov    $0x0,%eax
  800bdd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800be0:	5b                   	pop    %ebx
  800be1:	5e                   	pop    %esi
  800be2:	5d                   	pop    %ebp
  800be3:	c3                   	ret    

00800be4 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  800be4:	55                   	push   %ebp
  800be5:	89 e5                	mov    %esp,%ebp
  800be7:	53                   	push   %ebx
  800be8:	83 ec 0c             	sub    $0xc,%esp
  800beb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  800bee:	53                   	push   %ebx
  800bef:	6a 00                	push   $0x0
  800bf1:	e8 e5 f5 ff ff       	call   8001db <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  800bf6:	89 1c 24             	mov    %ebx,(%esp)
  800bf9:	e8 78 f7 ff ff       	call   800376 <fd2data>
  800bfe:	83 c4 08             	add    $0x8,%esp
  800c01:	50                   	push   %eax
  800c02:	6a 00                	push   $0x0
  800c04:	e8 d2 f5 ff ff       	call   8001db <sys_page_unmap>
}
  800c09:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c0c:	c9                   	leave  
  800c0d:	c3                   	ret    

00800c0e <_pipeisclosed>:
{
  800c0e:	55                   	push   %ebp
  800c0f:	89 e5                	mov    %esp,%ebp
  800c11:	57                   	push   %edi
  800c12:	56                   	push   %esi
  800c13:	53                   	push   %ebx
  800c14:	83 ec 1c             	sub    $0x1c,%esp
  800c17:	89 c7                	mov    %eax,%edi
  800c19:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  800c1b:	a1 08 40 80 00       	mov    0x804008,%eax
  800c20:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  800c23:	83 ec 0c             	sub    $0xc,%esp
  800c26:	57                   	push   %edi
  800c27:	e8 49 14 00 00       	call   802075 <pageref>
  800c2c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c2f:	89 34 24             	mov    %esi,(%esp)
  800c32:	e8 3e 14 00 00       	call   802075 <pageref>
		nn = thisenv->env_runs;
  800c37:	8b 15 08 40 80 00    	mov    0x804008,%edx
  800c3d:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  800c40:	83 c4 10             	add    $0x10,%esp
  800c43:	39 cb                	cmp    %ecx,%ebx
  800c45:	74 1b                	je     800c62 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  800c47:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800c4a:	75 cf                	jne    800c1b <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  800c4c:	8b 42 58             	mov    0x58(%edx),%eax
  800c4f:	6a 01                	push   $0x1
  800c51:	50                   	push   %eax
  800c52:	53                   	push   %ebx
  800c53:	68 2f 24 80 00       	push   $0x80242f
  800c58:	e8 43 09 00 00       	call   8015a0 <cprintf>
  800c5d:	83 c4 10             	add    $0x10,%esp
  800c60:	eb b9                	jmp    800c1b <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  800c62:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800c65:	0f 94 c0             	sete   %al
  800c68:	0f b6 c0             	movzbl %al,%eax
}
  800c6b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c6e:	5b                   	pop    %ebx
  800c6f:	5e                   	pop    %esi
  800c70:	5f                   	pop    %edi
  800c71:	5d                   	pop    %ebp
  800c72:	c3                   	ret    

00800c73 <devpipe_write>:
{
  800c73:	55                   	push   %ebp
  800c74:	89 e5                	mov    %esp,%ebp
  800c76:	57                   	push   %edi
  800c77:	56                   	push   %esi
  800c78:	53                   	push   %ebx
  800c79:	83 ec 28             	sub    $0x28,%esp
  800c7c:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  800c7f:	56                   	push   %esi
  800c80:	e8 f1 f6 ff ff       	call   800376 <fd2data>
  800c85:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800c87:	83 c4 10             	add    $0x10,%esp
  800c8a:	bf 00 00 00 00       	mov    $0x0,%edi
  800c8f:	3b 7d 10             	cmp    0x10(%ebp),%edi
  800c92:	74 4f                	je     800ce3 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  800c94:	8b 43 04             	mov    0x4(%ebx),%eax
  800c97:	8b 0b                	mov    (%ebx),%ecx
  800c99:	8d 51 20             	lea    0x20(%ecx),%edx
  800c9c:	39 d0                	cmp    %edx,%eax
  800c9e:	72 14                	jb     800cb4 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  800ca0:	89 da                	mov    %ebx,%edx
  800ca2:	89 f0                	mov    %esi,%eax
  800ca4:	e8 65 ff ff ff       	call   800c0e <_pipeisclosed>
  800ca9:	85 c0                	test   %eax,%eax
  800cab:	75 3a                	jne    800ce7 <devpipe_write+0x74>
			sys_yield();
  800cad:	e8 85 f4 ff ff       	call   800137 <sys_yield>
  800cb2:	eb e0                	jmp    800c94 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  800cb4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cb7:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  800cbb:	88 4d e7             	mov    %cl,-0x19(%ebp)
  800cbe:	89 c2                	mov    %eax,%edx
  800cc0:	c1 fa 1f             	sar    $0x1f,%edx
  800cc3:	89 d1                	mov    %edx,%ecx
  800cc5:	c1 e9 1b             	shr    $0x1b,%ecx
  800cc8:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  800ccb:	83 e2 1f             	and    $0x1f,%edx
  800cce:	29 ca                	sub    %ecx,%edx
  800cd0:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  800cd4:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  800cd8:	83 c0 01             	add    $0x1,%eax
  800cdb:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  800cde:	83 c7 01             	add    $0x1,%edi
  800ce1:	eb ac                	jmp    800c8f <devpipe_write+0x1c>
	return i;
  800ce3:	89 f8                	mov    %edi,%eax
  800ce5:	eb 05                	jmp    800cec <devpipe_write+0x79>
				return 0;
  800ce7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cef:	5b                   	pop    %ebx
  800cf0:	5e                   	pop    %esi
  800cf1:	5f                   	pop    %edi
  800cf2:	5d                   	pop    %ebp
  800cf3:	c3                   	ret    

00800cf4 <devpipe_read>:
{
  800cf4:	55                   	push   %ebp
  800cf5:	89 e5                	mov    %esp,%ebp
  800cf7:	57                   	push   %edi
  800cf8:	56                   	push   %esi
  800cf9:	53                   	push   %ebx
  800cfa:	83 ec 18             	sub    $0x18,%esp
  800cfd:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  800d00:	57                   	push   %edi
  800d01:	e8 70 f6 ff ff       	call   800376 <fd2data>
  800d06:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800d08:	83 c4 10             	add    $0x10,%esp
  800d0b:	be 00 00 00 00       	mov    $0x0,%esi
  800d10:	3b 75 10             	cmp    0x10(%ebp),%esi
  800d13:	74 47                	je     800d5c <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  800d15:	8b 03                	mov    (%ebx),%eax
  800d17:	3b 43 04             	cmp    0x4(%ebx),%eax
  800d1a:	75 22                	jne    800d3e <devpipe_read+0x4a>
			if (i > 0)
  800d1c:	85 f6                	test   %esi,%esi
  800d1e:	75 14                	jne    800d34 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  800d20:	89 da                	mov    %ebx,%edx
  800d22:	89 f8                	mov    %edi,%eax
  800d24:	e8 e5 fe ff ff       	call   800c0e <_pipeisclosed>
  800d29:	85 c0                	test   %eax,%eax
  800d2b:	75 33                	jne    800d60 <devpipe_read+0x6c>
			sys_yield();
  800d2d:	e8 05 f4 ff ff       	call   800137 <sys_yield>
  800d32:	eb e1                	jmp    800d15 <devpipe_read+0x21>
				return i;
  800d34:	89 f0                	mov    %esi,%eax
}
  800d36:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d39:	5b                   	pop    %ebx
  800d3a:	5e                   	pop    %esi
  800d3b:	5f                   	pop    %edi
  800d3c:	5d                   	pop    %ebp
  800d3d:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  800d3e:	99                   	cltd   
  800d3f:	c1 ea 1b             	shr    $0x1b,%edx
  800d42:	01 d0                	add    %edx,%eax
  800d44:	83 e0 1f             	and    $0x1f,%eax
  800d47:	29 d0                	sub    %edx,%eax
  800d49:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  800d4e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d51:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  800d54:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  800d57:	83 c6 01             	add    $0x1,%esi
  800d5a:	eb b4                	jmp    800d10 <devpipe_read+0x1c>
	return i;
  800d5c:	89 f0                	mov    %esi,%eax
  800d5e:	eb d6                	jmp    800d36 <devpipe_read+0x42>
				return 0;
  800d60:	b8 00 00 00 00       	mov    $0x0,%eax
  800d65:	eb cf                	jmp    800d36 <devpipe_read+0x42>

00800d67 <pipe>:
{
  800d67:	55                   	push   %ebp
  800d68:	89 e5                	mov    %esp,%ebp
  800d6a:	56                   	push   %esi
  800d6b:	53                   	push   %ebx
  800d6c:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  800d6f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800d72:	50                   	push   %eax
  800d73:	e8 15 f6 ff ff       	call   80038d <fd_alloc>
  800d78:	89 c3                	mov    %eax,%ebx
  800d7a:	83 c4 10             	add    $0x10,%esp
  800d7d:	85 c0                	test   %eax,%eax
  800d7f:	78 5b                	js     800ddc <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800d81:	83 ec 04             	sub    $0x4,%esp
  800d84:	68 07 04 00 00       	push   $0x407
  800d89:	ff 75 f4             	pushl  -0xc(%ebp)
  800d8c:	6a 00                	push   $0x0
  800d8e:	e8 c3 f3 ff ff       	call   800156 <sys_page_alloc>
  800d93:	89 c3                	mov    %eax,%ebx
  800d95:	83 c4 10             	add    $0x10,%esp
  800d98:	85 c0                	test   %eax,%eax
  800d9a:	78 40                	js     800ddc <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  800d9c:	83 ec 0c             	sub    $0xc,%esp
  800d9f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800da2:	50                   	push   %eax
  800da3:	e8 e5 f5 ff ff       	call   80038d <fd_alloc>
  800da8:	89 c3                	mov    %eax,%ebx
  800daa:	83 c4 10             	add    $0x10,%esp
  800dad:	85 c0                	test   %eax,%eax
  800daf:	78 1b                	js     800dcc <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800db1:	83 ec 04             	sub    $0x4,%esp
  800db4:	68 07 04 00 00       	push   $0x407
  800db9:	ff 75 f0             	pushl  -0x10(%ebp)
  800dbc:	6a 00                	push   $0x0
  800dbe:	e8 93 f3 ff ff       	call   800156 <sys_page_alloc>
  800dc3:	89 c3                	mov    %eax,%ebx
  800dc5:	83 c4 10             	add    $0x10,%esp
  800dc8:	85 c0                	test   %eax,%eax
  800dca:	79 19                	jns    800de5 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  800dcc:	83 ec 08             	sub    $0x8,%esp
  800dcf:	ff 75 f4             	pushl  -0xc(%ebp)
  800dd2:	6a 00                	push   $0x0
  800dd4:	e8 02 f4 ff ff       	call   8001db <sys_page_unmap>
  800dd9:	83 c4 10             	add    $0x10,%esp
}
  800ddc:	89 d8                	mov    %ebx,%eax
  800dde:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800de1:	5b                   	pop    %ebx
  800de2:	5e                   	pop    %esi
  800de3:	5d                   	pop    %ebp
  800de4:	c3                   	ret    
	va = fd2data(fd0);
  800de5:	83 ec 0c             	sub    $0xc,%esp
  800de8:	ff 75 f4             	pushl  -0xc(%ebp)
  800deb:	e8 86 f5 ff ff       	call   800376 <fd2data>
  800df0:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800df2:	83 c4 0c             	add    $0xc,%esp
  800df5:	68 07 04 00 00       	push   $0x407
  800dfa:	50                   	push   %eax
  800dfb:	6a 00                	push   $0x0
  800dfd:	e8 54 f3 ff ff       	call   800156 <sys_page_alloc>
  800e02:	89 c3                	mov    %eax,%ebx
  800e04:	83 c4 10             	add    $0x10,%esp
  800e07:	85 c0                	test   %eax,%eax
  800e09:	0f 88 8c 00 00 00    	js     800e9b <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e0f:	83 ec 0c             	sub    $0xc,%esp
  800e12:	ff 75 f0             	pushl  -0x10(%ebp)
  800e15:	e8 5c f5 ff ff       	call   800376 <fd2data>
  800e1a:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  800e21:	50                   	push   %eax
  800e22:	6a 00                	push   $0x0
  800e24:	56                   	push   %esi
  800e25:	6a 00                	push   $0x0
  800e27:	e8 6d f3 ff ff       	call   800199 <sys_page_map>
  800e2c:	89 c3                	mov    %eax,%ebx
  800e2e:	83 c4 20             	add    $0x20,%esp
  800e31:	85 c0                	test   %eax,%eax
  800e33:	78 58                	js     800e8d <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  800e35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e38:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800e3e:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  800e40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e43:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  800e4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e4d:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800e53:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  800e55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e58:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  800e5f:	83 ec 0c             	sub    $0xc,%esp
  800e62:	ff 75 f4             	pushl  -0xc(%ebp)
  800e65:	e8 fc f4 ff ff       	call   800366 <fd2num>
  800e6a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e6d:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  800e6f:	83 c4 04             	add    $0x4,%esp
  800e72:	ff 75 f0             	pushl  -0x10(%ebp)
  800e75:	e8 ec f4 ff ff       	call   800366 <fd2num>
  800e7a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e7d:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  800e80:	83 c4 10             	add    $0x10,%esp
  800e83:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e88:	e9 4f ff ff ff       	jmp    800ddc <pipe+0x75>
	sys_page_unmap(0, va);
  800e8d:	83 ec 08             	sub    $0x8,%esp
  800e90:	56                   	push   %esi
  800e91:	6a 00                	push   $0x0
  800e93:	e8 43 f3 ff ff       	call   8001db <sys_page_unmap>
  800e98:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  800e9b:	83 ec 08             	sub    $0x8,%esp
  800e9e:	ff 75 f0             	pushl  -0x10(%ebp)
  800ea1:	6a 00                	push   $0x0
  800ea3:	e8 33 f3 ff ff       	call   8001db <sys_page_unmap>
  800ea8:	83 c4 10             	add    $0x10,%esp
  800eab:	e9 1c ff ff ff       	jmp    800dcc <pipe+0x65>

00800eb0 <pipeisclosed>:
{
  800eb0:	55                   	push   %ebp
  800eb1:	89 e5                	mov    %esp,%ebp
  800eb3:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800eb6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800eb9:	50                   	push   %eax
  800eba:	ff 75 08             	pushl  0x8(%ebp)
  800ebd:	e8 1a f5 ff ff       	call   8003dc <fd_lookup>
  800ec2:	83 c4 10             	add    $0x10,%esp
  800ec5:	85 c0                	test   %eax,%eax
  800ec7:	78 18                	js     800ee1 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  800ec9:	83 ec 0c             	sub    $0xc,%esp
  800ecc:	ff 75 f4             	pushl  -0xc(%ebp)
  800ecf:	e8 a2 f4 ff ff       	call   800376 <fd2data>
	return _pipeisclosed(fd, p);
  800ed4:	89 c2                	mov    %eax,%edx
  800ed6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ed9:	e8 30 fd ff ff       	call   800c0e <_pipeisclosed>
  800ede:	83 c4 10             	add    $0x10,%esp
}
  800ee1:	c9                   	leave  
  800ee2:	c3                   	ret    

00800ee3 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  800ee3:	55                   	push   %ebp
  800ee4:	89 e5                	mov    %esp,%ebp
  800ee6:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  800ee9:	68 47 24 80 00       	push   $0x802447
  800eee:	ff 75 0c             	pushl  0xc(%ebp)
  800ef1:	e8 47 0d 00 00       	call   801c3d <strcpy>
	return 0;
}
  800ef6:	b8 00 00 00 00       	mov    $0x0,%eax
  800efb:	c9                   	leave  
  800efc:	c3                   	ret    

00800efd <devsock_close>:
{
  800efd:	55                   	push   %ebp
  800efe:	89 e5                	mov    %esp,%ebp
  800f00:	53                   	push   %ebx
  800f01:	83 ec 10             	sub    $0x10,%esp
  800f04:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  800f07:	53                   	push   %ebx
  800f08:	e8 68 11 00 00       	call   802075 <pageref>
  800f0d:	83 c4 10             	add    $0x10,%esp
		return 0;
  800f10:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  800f15:	83 f8 01             	cmp    $0x1,%eax
  800f18:	74 07                	je     800f21 <devsock_close+0x24>
}
  800f1a:	89 d0                	mov    %edx,%eax
  800f1c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f1f:	c9                   	leave  
  800f20:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  800f21:	83 ec 0c             	sub    $0xc,%esp
  800f24:	ff 73 0c             	pushl  0xc(%ebx)
  800f27:	e8 b7 02 00 00       	call   8011e3 <nsipc_close>
  800f2c:	89 c2                	mov    %eax,%edx
  800f2e:	83 c4 10             	add    $0x10,%esp
  800f31:	eb e7                	jmp    800f1a <devsock_close+0x1d>

00800f33 <devsock_write>:
{
  800f33:	55                   	push   %ebp
  800f34:	89 e5                	mov    %esp,%ebp
  800f36:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  800f39:	6a 00                	push   $0x0
  800f3b:	ff 75 10             	pushl  0x10(%ebp)
  800f3e:	ff 75 0c             	pushl  0xc(%ebp)
  800f41:	8b 45 08             	mov    0x8(%ebp),%eax
  800f44:	ff 70 0c             	pushl  0xc(%eax)
  800f47:	e8 74 03 00 00       	call   8012c0 <nsipc_send>
}
  800f4c:	c9                   	leave  
  800f4d:	c3                   	ret    

00800f4e <devsock_read>:
{
  800f4e:	55                   	push   %ebp
  800f4f:	89 e5                	mov    %esp,%ebp
  800f51:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  800f54:	6a 00                	push   $0x0
  800f56:	ff 75 10             	pushl  0x10(%ebp)
  800f59:	ff 75 0c             	pushl  0xc(%ebp)
  800f5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5f:	ff 70 0c             	pushl  0xc(%eax)
  800f62:	e8 ed 02 00 00       	call   801254 <nsipc_recv>
}
  800f67:	c9                   	leave  
  800f68:	c3                   	ret    

00800f69 <fd2sockid>:
{
  800f69:	55                   	push   %ebp
  800f6a:	89 e5                	mov    %esp,%ebp
  800f6c:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  800f6f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800f72:	52                   	push   %edx
  800f73:	50                   	push   %eax
  800f74:	e8 63 f4 ff ff       	call   8003dc <fd_lookup>
  800f79:	83 c4 10             	add    $0x10,%esp
  800f7c:	85 c0                	test   %eax,%eax
  800f7e:	78 10                	js     800f90 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  800f80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f83:	8b 0d 3c 30 80 00    	mov    0x80303c,%ecx
  800f89:	39 08                	cmp    %ecx,(%eax)
  800f8b:	75 05                	jne    800f92 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  800f8d:	8b 40 0c             	mov    0xc(%eax),%eax
}
  800f90:	c9                   	leave  
  800f91:	c3                   	ret    
		return -E_NOT_SUPP;
  800f92:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800f97:	eb f7                	jmp    800f90 <fd2sockid+0x27>

00800f99 <alloc_sockfd>:
{
  800f99:	55                   	push   %ebp
  800f9a:	89 e5                	mov    %esp,%ebp
  800f9c:	56                   	push   %esi
  800f9d:	53                   	push   %ebx
  800f9e:	83 ec 1c             	sub    $0x1c,%esp
  800fa1:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  800fa3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800fa6:	50                   	push   %eax
  800fa7:	e8 e1 f3 ff ff       	call   80038d <fd_alloc>
  800fac:	89 c3                	mov    %eax,%ebx
  800fae:	83 c4 10             	add    $0x10,%esp
  800fb1:	85 c0                	test   %eax,%eax
  800fb3:	78 43                	js     800ff8 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  800fb5:	83 ec 04             	sub    $0x4,%esp
  800fb8:	68 07 04 00 00       	push   $0x407
  800fbd:	ff 75 f4             	pushl  -0xc(%ebp)
  800fc0:	6a 00                	push   $0x0
  800fc2:	e8 8f f1 ff ff       	call   800156 <sys_page_alloc>
  800fc7:	89 c3                	mov    %eax,%ebx
  800fc9:	83 c4 10             	add    $0x10,%esp
  800fcc:	85 c0                	test   %eax,%eax
  800fce:	78 28                	js     800ff8 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  800fd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fd3:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  800fd9:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  800fdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fde:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  800fe5:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  800fe8:	83 ec 0c             	sub    $0xc,%esp
  800feb:	50                   	push   %eax
  800fec:	e8 75 f3 ff ff       	call   800366 <fd2num>
  800ff1:	89 c3                	mov    %eax,%ebx
  800ff3:	83 c4 10             	add    $0x10,%esp
  800ff6:	eb 0c                	jmp    801004 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  800ff8:	83 ec 0c             	sub    $0xc,%esp
  800ffb:	56                   	push   %esi
  800ffc:	e8 e2 01 00 00       	call   8011e3 <nsipc_close>
		return r;
  801001:	83 c4 10             	add    $0x10,%esp
}
  801004:	89 d8                	mov    %ebx,%eax
  801006:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801009:	5b                   	pop    %ebx
  80100a:	5e                   	pop    %esi
  80100b:	5d                   	pop    %ebp
  80100c:	c3                   	ret    

0080100d <accept>:
{
  80100d:	55                   	push   %ebp
  80100e:	89 e5                	mov    %esp,%ebp
  801010:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801013:	8b 45 08             	mov    0x8(%ebp),%eax
  801016:	e8 4e ff ff ff       	call   800f69 <fd2sockid>
  80101b:	85 c0                	test   %eax,%eax
  80101d:	78 1b                	js     80103a <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80101f:	83 ec 04             	sub    $0x4,%esp
  801022:	ff 75 10             	pushl  0x10(%ebp)
  801025:	ff 75 0c             	pushl  0xc(%ebp)
  801028:	50                   	push   %eax
  801029:	e8 0e 01 00 00       	call   80113c <nsipc_accept>
  80102e:	83 c4 10             	add    $0x10,%esp
  801031:	85 c0                	test   %eax,%eax
  801033:	78 05                	js     80103a <accept+0x2d>
	return alloc_sockfd(r);
  801035:	e8 5f ff ff ff       	call   800f99 <alloc_sockfd>
}
  80103a:	c9                   	leave  
  80103b:	c3                   	ret    

0080103c <bind>:
{
  80103c:	55                   	push   %ebp
  80103d:	89 e5                	mov    %esp,%ebp
  80103f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801042:	8b 45 08             	mov    0x8(%ebp),%eax
  801045:	e8 1f ff ff ff       	call   800f69 <fd2sockid>
  80104a:	85 c0                	test   %eax,%eax
  80104c:	78 12                	js     801060 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  80104e:	83 ec 04             	sub    $0x4,%esp
  801051:	ff 75 10             	pushl  0x10(%ebp)
  801054:	ff 75 0c             	pushl  0xc(%ebp)
  801057:	50                   	push   %eax
  801058:	e8 2f 01 00 00       	call   80118c <nsipc_bind>
  80105d:	83 c4 10             	add    $0x10,%esp
}
  801060:	c9                   	leave  
  801061:	c3                   	ret    

00801062 <shutdown>:
{
  801062:	55                   	push   %ebp
  801063:	89 e5                	mov    %esp,%ebp
  801065:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801068:	8b 45 08             	mov    0x8(%ebp),%eax
  80106b:	e8 f9 fe ff ff       	call   800f69 <fd2sockid>
  801070:	85 c0                	test   %eax,%eax
  801072:	78 0f                	js     801083 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801074:	83 ec 08             	sub    $0x8,%esp
  801077:	ff 75 0c             	pushl  0xc(%ebp)
  80107a:	50                   	push   %eax
  80107b:	e8 41 01 00 00       	call   8011c1 <nsipc_shutdown>
  801080:	83 c4 10             	add    $0x10,%esp
}
  801083:	c9                   	leave  
  801084:	c3                   	ret    

00801085 <connect>:
{
  801085:	55                   	push   %ebp
  801086:	89 e5                	mov    %esp,%ebp
  801088:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80108b:	8b 45 08             	mov    0x8(%ebp),%eax
  80108e:	e8 d6 fe ff ff       	call   800f69 <fd2sockid>
  801093:	85 c0                	test   %eax,%eax
  801095:	78 12                	js     8010a9 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801097:	83 ec 04             	sub    $0x4,%esp
  80109a:	ff 75 10             	pushl  0x10(%ebp)
  80109d:	ff 75 0c             	pushl  0xc(%ebp)
  8010a0:	50                   	push   %eax
  8010a1:	e8 57 01 00 00       	call   8011fd <nsipc_connect>
  8010a6:	83 c4 10             	add    $0x10,%esp
}
  8010a9:	c9                   	leave  
  8010aa:	c3                   	ret    

008010ab <listen>:
{
  8010ab:	55                   	push   %ebp
  8010ac:	89 e5                	mov    %esp,%ebp
  8010ae:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8010b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b4:	e8 b0 fe ff ff       	call   800f69 <fd2sockid>
  8010b9:	85 c0                	test   %eax,%eax
  8010bb:	78 0f                	js     8010cc <listen+0x21>
	return nsipc_listen(r, backlog);
  8010bd:	83 ec 08             	sub    $0x8,%esp
  8010c0:	ff 75 0c             	pushl  0xc(%ebp)
  8010c3:	50                   	push   %eax
  8010c4:	e8 69 01 00 00       	call   801232 <nsipc_listen>
  8010c9:	83 c4 10             	add    $0x10,%esp
}
  8010cc:	c9                   	leave  
  8010cd:	c3                   	ret    

008010ce <socket>:

int
socket(int domain, int type, int protocol)
{
  8010ce:	55                   	push   %ebp
  8010cf:	89 e5                	mov    %esp,%ebp
  8010d1:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8010d4:	ff 75 10             	pushl  0x10(%ebp)
  8010d7:	ff 75 0c             	pushl  0xc(%ebp)
  8010da:	ff 75 08             	pushl  0x8(%ebp)
  8010dd:	e8 3c 02 00 00       	call   80131e <nsipc_socket>
  8010e2:	83 c4 10             	add    $0x10,%esp
  8010e5:	85 c0                	test   %eax,%eax
  8010e7:	78 05                	js     8010ee <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8010e9:	e8 ab fe ff ff       	call   800f99 <alloc_sockfd>
}
  8010ee:	c9                   	leave  
  8010ef:	c3                   	ret    

008010f0 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8010f0:	55                   	push   %ebp
  8010f1:	89 e5                	mov    %esp,%ebp
  8010f3:	53                   	push   %ebx
  8010f4:	83 ec 04             	sub    $0x4,%esp
  8010f7:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8010f9:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801100:	74 26                	je     801128 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801102:	6a 07                	push   $0x7
  801104:	68 00 60 80 00       	push   $0x806000
  801109:	53                   	push   %ebx
  80110a:	ff 35 04 40 80 00    	pushl  0x804004
  801110:	e8 ce 0e 00 00       	call   801fe3 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801115:	83 c4 0c             	add    $0xc,%esp
  801118:	6a 00                	push   $0x0
  80111a:	6a 00                	push   $0x0
  80111c:	6a 00                	push   $0x0
  80111e:	e8 57 0e 00 00       	call   801f7a <ipc_recv>
}
  801123:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801126:	c9                   	leave  
  801127:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801128:	83 ec 0c             	sub    $0xc,%esp
  80112b:	6a 02                	push   $0x2
  80112d:	e8 0a 0f 00 00       	call   80203c <ipc_find_env>
  801132:	a3 04 40 80 00       	mov    %eax,0x804004
  801137:	83 c4 10             	add    $0x10,%esp
  80113a:	eb c6                	jmp    801102 <nsipc+0x12>

0080113c <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80113c:	55                   	push   %ebp
  80113d:	89 e5                	mov    %esp,%ebp
  80113f:	56                   	push   %esi
  801140:	53                   	push   %ebx
  801141:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801144:	8b 45 08             	mov    0x8(%ebp),%eax
  801147:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80114c:	8b 06                	mov    (%esi),%eax
  80114e:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801153:	b8 01 00 00 00       	mov    $0x1,%eax
  801158:	e8 93 ff ff ff       	call   8010f0 <nsipc>
  80115d:	89 c3                	mov    %eax,%ebx
  80115f:	85 c0                	test   %eax,%eax
  801161:	78 20                	js     801183 <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801163:	83 ec 04             	sub    $0x4,%esp
  801166:	ff 35 10 60 80 00    	pushl  0x806010
  80116c:	68 00 60 80 00       	push   $0x806000
  801171:	ff 75 0c             	pushl  0xc(%ebp)
  801174:	e8 52 0c 00 00       	call   801dcb <memmove>
		*addrlen = ret->ret_addrlen;
  801179:	a1 10 60 80 00       	mov    0x806010,%eax
  80117e:	89 06                	mov    %eax,(%esi)
  801180:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  801183:	89 d8                	mov    %ebx,%eax
  801185:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801188:	5b                   	pop    %ebx
  801189:	5e                   	pop    %esi
  80118a:	5d                   	pop    %ebp
  80118b:	c3                   	ret    

0080118c <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80118c:	55                   	push   %ebp
  80118d:	89 e5                	mov    %esp,%ebp
  80118f:	53                   	push   %ebx
  801190:	83 ec 08             	sub    $0x8,%esp
  801193:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801196:	8b 45 08             	mov    0x8(%ebp),%eax
  801199:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80119e:	53                   	push   %ebx
  80119f:	ff 75 0c             	pushl  0xc(%ebp)
  8011a2:	68 04 60 80 00       	push   $0x806004
  8011a7:	e8 1f 0c 00 00       	call   801dcb <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8011ac:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  8011b2:	b8 02 00 00 00       	mov    $0x2,%eax
  8011b7:	e8 34 ff ff ff       	call   8010f0 <nsipc>
}
  8011bc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011bf:	c9                   	leave  
  8011c0:	c3                   	ret    

008011c1 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8011c1:	55                   	push   %ebp
  8011c2:	89 e5                	mov    %esp,%ebp
  8011c4:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8011c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ca:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  8011cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d2:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  8011d7:	b8 03 00 00 00       	mov    $0x3,%eax
  8011dc:	e8 0f ff ff ff       	call   8010f0 <nsipc>
}
  8011e1:	c9                   	leave  
  8011e2:	c3                   	ret    

008011e3 <nsipc_close>:

int
nsipc_close(int s)
{
  8011e3:	55                   	push   %ebp
  8011e4:	89 e5                	mov    %esp,%ebp
  8011e6:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8011e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ec:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  8011f1:	b8 04 00 00 00       	mov    $0x4,%eax
  8011f6:	e8 f5 fe ff ff       	call   8010f0 <nsipc>
}
  8011fb:	c9                   	leave  
  8011fc:	c3                   	ret    

008011fd <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8011fd:	55                   	push   %ebp
  8011fe:	89 e5                	mov    %esp,%ebp
  801200:	53                   	push   %ebx
  801201:	83 ec 08             	sub    $0x8,%esp
  801204:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801207:	8b 45 08             	mov    0x8(%ebp),%eax
  80120a:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80120f:	53                   	push   %ebx
  801210:	ff 75 0c             	pushl  0xc(%ebp)
  801213:	68 04 60 80 00       	push   $0x806004
  801218:	e8 ae 0b 00 00       	call   801dcb <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80121d:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801223:	b8 05 00 00 00       	mov    $0x5,%eax
  801228:	e8 c3 fe ff ff       	call   8010f0 <nsipc>
}
  80122d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801230:	c9                   	leave  
  801231:	c3                   	ret    

00801232 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801232:	55                   	push   %ebp
  801233:	89 e5                	mov    %esp,%ebp
  801235:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801238:	8b 45 08             	mov    0x8(%ebp),%eax
  80123b:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801240:	8b 45 0c             	mov    0xc(%ebp),%eax
  801243:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801248:	b8 06 00 00 00       	mov    $0x6,%eax
  80124d:	e8 9e fe ff ff       	call   8010f0 <nsipc>
}
  801252:	c9                   	leave  
  801253:	c3                   	ret    

00801254 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801254:	55                   	push   %ebp
  801255:	89 e5                	mov    %esp,%ebp
  801257:	56                   	push   %esi
  801258:	53                   	push   %ebx
  801259:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  80125c:	8b 45 08             	mov    0x8(%ebp),%eax
  80125f:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801264:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  80126a:	8b 45 14             	mov    0x14(%ebp),%eax
  80126d:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801272:	b8 07 00 00 00       	mov    $0x7,%eax
  801277:	e8 74 fe ff ff       	call   8010f0 <nsipc>
  80127c:	89 c3                	mov    %eax,%ebx
  80127e:	85 c0                	test   %eax,%eax
  801280:	78 1f                	js     8012a1 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801282:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801287:	7f 21                	jg     8012aa <nsipc_recv+0x56>
  801289:	39 c6                	cmp    %eax,%esi
  80128b:	7c 1d                	jl     8012aa <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80128d:	83 ec 04             	sub    $0x4,%esp
  801290:	50                   	push   %eax
  801291:	68 00 60 80 00       	push   $0x806000
  801296:	ff 75 0c             	pushl  0xc(%ebp)
  801299:	e8 2d 0b 00 00       	call   801dcb <memmove>
  80129e:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8012a1:	89 d8                	mov    %ebx,%eax
  8012a3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012a6:	5b                   	pop    %ebx
  8012a7:	5e                   	pop    %esi
  8012a8:	5d                   	pop    %ebp
  8012a9:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8012aa:	68 53 24 80 00       	push   $0x802453
  8012af:	68 f5 23 80 00       	push   $0x8023f5
  8012b4:	6a 62                	push   $0x62
  8012b6:	68 68 24 80 00       	push   $0x802468
  8012bb:	e8 05 02 00 00       	call   8014c5 <_panic>

008012c0 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8012c0:	55                   	push   %ebp
  8012c1:	89 e5                	mov    %esp,%ebp
  8012c3:	53                   	push   %ebx
  8012c4:	83 ec 04             	sub    $0x4,%esp
  8012c7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8012ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cd:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  8012d2:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8012d8:	7f 2e                	jg     801308 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8012da:	83 ec 04             	sub    $0x4,%esp
  8012dd:	53                   	push   %ebx
  8012de:	ff 75 0c             	pushl  0xc(%ebp)
  8012e1:	68 0c 60 80 00       	push   $0x80600c
  8012e6:	e8 e0 0a 00 00       	call   801dcb <memmove>
	nsipcbuf.send.req_size = size;
  8012eb:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  8012f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8012f4:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  8012f9:	b8 08 00 00 00       	mov    $0x8,%eax
  8012fe:	e8 ed fd ff ff       	call   8010f0 <nsipc>
}
  801303:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801306:	c9                   	leave  
  801307:	c3                   	ret    
	assert(size < 1600);
  801308:	68 74 24 80 00       	push   $0x802474
  80130d:	68 f5 23 80 00       	push   $0x8023f5
  801312:	6a 6d                	push   $0x6d
  801314:	68 68 24 80 00       	push   $0x802468
  801319:	e8 a7 01 00 00       	call   8014c5 <_panic>

0080131e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80131e:	55                   	push   %ebp
  80131f:	89 e5                	mov    %esp,%ebp
  801321:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801324:	8b 45 08             	mov    0x8(%ebp),%eax
  801327:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  80132c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80132f:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801334:	8b 45 10             	mov    0x10(%ebp),%eax
  801337:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  80133c:	b8 09 00 00 00       	mov    $0x9,%eax
  801341:	e8 aa fd ff ff       	call   8010f0 <nsipc>
}
  801346:	c9                   	leave  
  801347:	c3                   	ret    

00801348 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801348:	55                   	push   %ebp
  801349:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  80134b:	b8 00 00 00 00       	mov    $0x0,%eax
  801350:	5d                   	pop    %ebp
  801351:	c3                   	ret    

00801352 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801352:	55                   	push   %ebp
  801353:	89 e5                	mov    %esp,%ebp
  801355:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801358:	68 80 24 80 00       	push   $0x802480
  80135d:	ff 75 0c             	pushl  0xc(%ebp)
  801360:	e8 d8 08 00 00       	call   801c3d <strcpy>
	return 0;
}
  801365:	b8 00 00 00 00       	mov    $0x0,%eax
  80136a:	c9                   	leave  
  80136b:	c3                   	ret    

0080136c <devcons_write>:
{
  80136c:	55                   	push   %ebp
  80136d:	89 e5                	mov    %esp,%ebp
  80136f:	57                   	push   %edi
  801370:	56                   	push   %esi
  801371:	53                   	push   %ebx
  801372:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801378:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80137d:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801383:	eb 2f                	jmp    8013b4 <devcons_write+0x48>
		m = n - tot;
  801385:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801388:	29 f3                	sub    %esi,%ebx
  80138a:	83 fb 7f             	cmp    $0x7f,%ebx
  80138d:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801392:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801395:	83 ec 04             	sub    $0x4,%esp
  801398:	53                   	push   %ebx
  801399:	89 f0                	mov    %esi,%eax
  80139b:	03 45 0c             	add    0xc(%ebp),%eax
  80139e:	50                   	push   %eax
  80139f:	57                   	push   %edi
  8013a0:	e8 26 0a 00 00       	call   801dcb <memmove>
		sys_cputs(buf, m);
  8013a5:	83 c4 08             	add    $0x8,%esp
  8013a8:	53                   	push   %ebx
  8013a9:	57                   	push   %edi
  8013aa:	e8 eb ec ff ff       	call   80009a <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8013af:	01 de                	add    %ebx,%esi
  8013b1:	83 c4 10             	add    $0x10,%esp
  8013b4:	3b 75 10             	cmp    0x10(%ebp),%esi
  8013b7:	72 cc                	jb     801385 <devcons_write+0x19>
}
  8013b9:	89 f0                	mov    %esi,%eax
  8013bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013be:	5b                   	pop    %ebx
  8013bf:	5e                   	pop    %esi
  8013c0:	5f                   	pop    %edi
  8013c1:	5d                   	pop    %ebp
  8013c2:	c3                   	ret    

008013c3 <devcons_read>:
{
  8013c3:	55                   	push   %ebp
  8013c4:	89 e5                	mov    %esp,%ebp
  8013c6:	83 ec 08             	sub    $0x8,%esp
  8013c9:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8013ce:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013d2:	75 07                	jne    8013db <devcons_read+0x18>
}
  8013d4:	c9                   	leave  
  8013d5:	c3                   	ret    
		sys_yield();
  8013d6:	e8 5c ed ff ff       	call   800137 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  8013db:	e8 d8 ec ff ff       	call   8000b8 <sys_cgetc>
  8013e0:	85 c0                	test   %eax,%eax
  8013e2:	74 f2                	je     8013d6 <devcons_read+0x13>
	if (c < 0)
  8013e4:	85 c0                	test   %eax,%eax
  8013e6:	78 ec                	js     8013d4 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  8013e8:	83 f8 04             	cmp    $0x4,%eax
  8013eb:	74 0c                	je     8013f9 <devcons_read+0x36>
	*(char*)vbuf = c;
  8013ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013f0:	88 02                	mov    %al,(%edx)
	return 1;
  8013f2:	b8 01 00 00 00       	mov    $0x1,%eax
  8013f7:	eb db                	jmp    8013d4 <devcons_read+0x11>
		return 0;
  8013f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8013fe:	eb d4                	jmp    8013d4 <devcons_read+0x11>

00801400 <cputchar>:
{
  801400:	55                   	push   %ebp
  801401:	89 e5                	mov    %esp,%ebp
  801403:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801406:	8b 45 08             	mov    0x8(%ebp),%eax
  801409:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80140c:	6a 01                	push   $0x1
  80140e:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801411:	50                   	push   %eax
  801412:	e8 83 ec ff ff       	call   80009a <sys_cputs>
}
  801417:	83 c4 10             	add    $0x10,%esp
  80141a:	c9                   	leave  
  80141b:	c3                   	ret    

0080141c <getchar>:
{
  80141c:	55                   	push   %ebp
  80141d:	89 e5                	mov    %esp,%ebp
  80141f:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801422:	6a 01                	push   $0x1
  801424:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801427:	50                   	push   %eax
  801428:	6a 00                	push   $0x0
  80142a:	e8 1e f2 ff ff       	call   80064d <read>
	if (r < 0)
  80142f:	83 c4 10             	add    $0x10,%esp
  801432:	85 c0                	test   %eax,%eax
  801434:	78 08                	js     80143e <getchar+0x22>
	if (r < 1)
  801436:	85 c0                	test   %eax,%eax
  801438:	7e 06                	jle    801440 <getchar+0x24>
	return c;
  80143a:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80143e:	c9                   	leave  
  80143f:	c3                   	ret    
		return -E_EOF;
  801440:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801445:	eb f7                	jmp    80143e <getchar+0x22>

00801447 <iscons>:
{
  801447:	55                   	push   %ebp
  801448:	89 e5                	mov    %esp,%ebp
  80144a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80144d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801450:	50                   	push   %eax
  801451:	ff 75 08             	pushl  0x8(%ebp)
  801454:	e8 83 ef ff ff       	call   8003dc <fd_lookup>
  801459:	83 c4 10             	add    $0x10,%esp
  80145c:	85 c0                	test   %eax,%eax
  80145e:	78 11                	js     801471 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801460:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801463:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801469:	39 10                	cmp    %edx,(%eax)
  80146b:	0f 94 c0             	sete   %al
  80146e:	0f b6 c0             	movzbl %al,%eax
}
  801471:	c9                   	leave  
  801472:	c3                   	ret    

00801473 <opencons>:
{
  801473:	55                   	push   %ebp
  801474:	89 e5                	mov    %esp,%ebp
  801476:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801479:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80147c:	50                   	push   %eax
  80147d:	e8 0b ef ff ff       	call   80038d <fd_alloc>
  801482:	83 c4 10             	add    $0x10,%esp
  801485:	85 c0                	test   %eax,%eax
  801487:	78 3a                	js     8014c3 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801489:	83 ec 04             	sub    $0x4,%esp
  80148c:	68 07 04 00 00       	push   $0x407
  801491:	ff 75 f4             	pushl  -0xc(%ebp)
  801494:	6a 00                	push   $0x0
  801496:	e8 bb ec ff ff       	call   800156 <sys_page_alloc>
  80149b:	83 c4 10             	add    $0x10,%esp
  80149e:	85 c0                	test   %eax,%eax
  8014a0:	78 21                	js     8014c3 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8014a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014a5:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8014ab:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8014ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014b0:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8014b7:	83 ec 0c             	sub    $0xc,%esp
  8014ba:	50                   	push   %eax
  8014bb:	e8 a6 ee ff ff       	call   800366 <fd2num>
  8014c0:	83 c4 10             	add    $0x10,%esp
}
  8014c3:	c9                   	leave  
  8014c4:	c3                   	ret    

008014c5 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8014c5:	55                   	push   %ebp
  8014c6:	89 e5                	mov    %esp,%ebp
  8014c8:	56                   	push   %esi
  8014c9:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8014ca:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8014cd:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8014d3:	e8 40 ec ff ff       	call   800118 <sys_getenvid>
  8014d8:	83 ec 0c             	sub    $0xc,%esp
  8014db:	ff 75 0c             	pushl  0xc(%ebp)
  8014de:	ff 75 08             	pushl  0x8(%ebp)
  8014e1:	56                   	push   %esi
  8014e2:	50                   	push   %eax
  8014e3:	68 8c 24 80 00       	push   $0x80248c
  8014e8:	e8 b3 00 00 00       	call   8015a0 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8014ed:	83 c4 18             	add    $0x18,%esp
  8014f0:	53                   	push   %ebx
  8014f1:	ff 75 10             	pushl  0x10(%ebp)
  8014f4:	e8 56 00 00 00       	call   80154f <vcprintf>
	cprintf("\n");
  8014f9:	c7 04 24 40 24 80 00 	movl   $0x802440,(%esp)
  801500:	e8 9b 00 00 00       	call   8015a0 <cprintf>
  801505:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801508:	cc                   	int3   
  801509:	eb fd                	jmp    801508 <_panic+0x43>

0080150b <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80150b:	55                   	push   %ebp
  80150c:	89 e5                	mov    %esp,%ebp
  80150e:	53                   	push   %ebx
  80150f:	83 ec 04             	sub    $0x4,%esp
  801512:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801515:	8b 13                	mov    (%ebx),%edx
  801517:	8d 42 01             	lea    0x1(%edx),%eax
  80151a:	89 03                	mov    %eax,(%ebx)
  80151c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80151f:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801523:	3d ff 00 00 00       	cmp    $0xff,%eax
  801528:	74 09                	je     801533 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80152a:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80152e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801531:	c9                   	leave  
  801532:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  801533:	83 ec 08             	sub    $0x8,%esp
  801536:	68 ff 00 00 00       	push   $0xff
  80153b:	8d 43 08             	lea    0x8(%ebx),%eax
  80153e:	50                   	push   %eax
  80153f:	e8 56 eb ff ff       	call   80009a <sys_cputs>
		b->idx = 0;
  801544:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80154a:	83 c4 10             	add    $0x10,%esp
  80154d:	eb db                	jmp    80152a <putch+0x1f>

0080154f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80154f:	55                   	push   %ebp
  801550:	89 e5                	mov    %esp,%ebp
  801552:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801558:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80155f:	00 00 00 
	b.cnt = 0;
  801562:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801569:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80156c:	ff 75 0c             	pushl  0xc(%ebp)
  80156f:	ff 75 08             	pushl  0x8(%ebp)
  801572:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801578:	50                   	push   %eax
  801579:	68 0b 15 80 00       	push   $0x80150b
  80157e:	e8 1a 01 00 00       	call   80169d <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801583:	83 c4 08             	add    $0x8,%esp
  801586:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80158c:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  801592:	50                   	push   %eax
  801593:	e8 02 eb ff ff       	call   80009a <sys_cputs>

	return b.cnt;
}
  801598:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80159e:	c9                   	leave  
  80159f:	c3                   	ret    

008015a0 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8015a0:	55                   	push   %ebp
  8015a1:	89 e5                	mov    %esp,%ebp
  8015a3:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8015a6:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8015a9:	50                   	push   %eax
  8015aa:	ff 75 08             	pushl  0x8(%ebp)
  8015ad:	e8 9d ff ff ff       	call   80154f <vcprintf>
	va_end(ap);

	return cnt;
}
  8015b2:	c9                   	leave  
  8015b3:	c3                   	ret    

008015b4 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8015b4:	55                   	push   %ebp
  8015b5:	89 e5                	mov    %esp,%ebp
  8015b7:	57                   	push   %edi
  8015b8:	56                   	push   %esi
  8015b9:	53                   	push   %ebx
  8015ba:	83 ec 1c             	sub    $0x1c,%esp
  8015bd:	89 c7                	mov    %eax,%edi
  8015bf:	89 d6                	mov    %edx,%esi
  8015c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015c7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8015ca:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8015cd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015d0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015d5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8015d8:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8015db:	39 d3                	cmp    %edx,%ebx
  8015dd:	72 05                	jb     8015e4 <printnum+0x30>
  8015df:	39 45 10             	cmp    %eax,0x10(%ebp)
  8015e2:	77 7a                	ja     80165e <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8015e4:	83 ec 0c             	sub    $0xc,%esp
  8015e7:	ff 75 18             	pushl  0x18(%ebp)
  8015ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8015ed:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8015f0:	53                   	push   %ebx
  8015f1:	ff 75 10             	pushl  0x10(%ebp)
  8015f4:	83 ec 08             	sub    $0x8,%esp
  8015f7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8015fa:	ff 75 e0             	pushl  -0x20(%ebp)
  8015fd:	ff 75 dc             	pushl  -0x24(%ebp)
  801600:	ff 75 d8             	pushl  -0x28(%ebp)
  801603:	e8 a8 0a 00 00       	call   8020b0 <__udivdi3>
  801608:	83 c4 18             	add    $0x18,%esp
  80160b:	52                   	push   %edx
  80160c:	50                   	push   %eax
  80160d:	89 f2                	mov    %esi,%edx
  80160f:	89 f8                	mov    %edi,%eax
  801611:	e8 9e ff ff ff       	call   8015b4 <printnum>
  801616:	83 c4 20             	add    $0x20,%esp
  801619:	eb 13                	jmp    80162e <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80161b:	83 ec 08             	sub    $0x8,%esp
  80161e:	56                   	push   %esi
  80161f:	ff 75 18             	pushl  0x18(%ebp)
  801622:	ff d7                	call   *%edi
  801624:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  801627:	83 eb 01             	sub    $0x1,%ebx
  80162a:	85 db                	test   %ebx,%ebx
  80162c:	7f ed                	jg     80161b <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80162e:	83 ec 08             	sub    $0x8,%esp
  801631:	56                   	push   %esi
  801632:	83 ec 04             	sub    $0x4,%esp
  801635:	ff 75 e4             	pushl  -0x1c(%ebp)
  801638:	ff 75 e0             	pushl  -0x20(%ebp)
  80163b:	ff 75 dc             	pushl  -0x24(%ebp)
  80163e:	ff 75 d8             	pushl  -0x28(%ebp)
  801641:	e8 8a 0b 00 00       	call   8021d0 <__umoddi3>
  801646:	83 c4 14             	add    $0x14,%esp
  801649:	0f be 80 af 24 80 00 	movsbl 0x8024af(%eax),%eax
  801650:	50                   	push   %eax
  801651:	ff d7                	call   *%edi
}
  801653:	83 c4 10             	add    $0x10,%esp
  801656:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801659:	5b                   	pop    %ebx
  80165a:	5e                   	pop    %esi
  80165b:	5f                   	pop    %edi
  80165c:	5d                   	pop    %ebp
  80165d:	c3                   	ret    
  80165e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801661:	eb c4                	jmp    801627 <printnum+0x73>

00801663 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801663:	55                   	push   %ebp
  801664:	89 e5                	mov    %esp,%ebp
  801666:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801669:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80166d:	8b 10                	mov    (%eax),%edx
  80166f:	3b 50 04             	cmp    0x4(%eax),%edx
  801672:	73 0a                	jae    80167e <sprintputch+0x1b>
		*b->buf++ = ch;
  801674:	8d 4a 01             	lea    0x1(%edx),%ecx
  801677:	89 08                	mov    %ecx,(%eax)
  801679:	8b 45 08             	mov    0x8(%ebp),%eax
  80167c:	88 02                	mov    %al,(%edx)
}
  80167e:	5d                   	pop    %ebp
  80167f:	c3                   	ret    

00801680 <printfmt>:
{
  801680:	55                   	push   %ebp
  801681:	89 e5                	mov    %esp,%ebp
  801683:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  801686:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  801689:	50                   	push   %eax
  80168a:	ff 75 10             	pushl  0x10(%ebp)
  80168d:	ff 75 0c             	pushl  0xc(%ebp)
  801690:	ff 75 08             	pushl  0x8(%ebp)
  801693:	e8 05 00 00 00       	call   80169d <vprintfmt>
}
  801698:	83 c4 10             	add    $0x10,%esp
  80169b:	c9                   	leave  
  80169c:	c3                   	ret    

0080169d <vprintfmt>:
{
  80169d:	55                   	push   %ebp
  80169e:	89 e5                	mov    %esp,%ebp
  8016a0:	57                   	push   %edi
  8016a1:	56                   	push   %esi
  8016a2:	53                   	push   %ebx
  8016a3:	83 ec 2c             	sub    $0x2c,%esp
  8016a6:	8b 75 08             	mov    0x8(%ebp),%esi
  8016a9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8016ac:	8b 7d 10             	mov    0x10(%ebp),%edi
  8016af:	e9 21 04 00 00       	jmp    801ad5 <vprintfmt+0x438>
		padc = ' ';
  8016b4:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8016b8:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8016bf:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  8016c6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8016cd:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8016d2:	8d 47 01             	lea    0x1(%edi),%eax
  8016d5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8016d8:	0f b6 17             	movzbl (%edi),%edx
  8016db:	8d 42 dd             	lea    -0x23(%edx),%eax
  8016de:	3c 55                	cmp    $0x55,%al
  8016e0:	0f 87 90 04 00 00    	ja     801b76 <vprintfmt+0x4d9>
  8016e6:	0f b6 c0             	movzbl %al,%eax
  8016e9:	ff 24 85 00 26 80 00 	jmp    *0x802600(,%eax,4)
  8016f0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8016f3:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8016f7:	eb d9                	jmp    8016d2 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8016f9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8016fc:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  801700:	eb d0                	jmp    8016d2 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  801702:	0f b6 d2             	movzbl %dl,%edx
  801705:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  801708:	b8 00 00 00 00       	mov    $0x0,%eax
  80170d:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  801710:	8d 04 80             	lea    (%eax,%eax,4),%eax
  801713:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  801717:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80171a:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80171d:	83 f9 09             	cmp    $0x9,%ecx
  801720:	77 55                	ja     801777 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  801722:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  801725:	eb e9                	jmp    801710 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  801727:	8b 45 14             	mov    0x14(%ebp),%eax
  80172a:	8b 00                	mov    (%eax),%eax
  80172c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80172f:	8b 45 14             	mov    0x14(%ebp),%eax
  801732:	8d 40 04             	lea    0x4(%eax),%eax
  801735:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801738:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80173b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80173f:	79 91                	jns    8016d2 <vprintfmt+0x35>
				width = precision, precision = -1;
  801741:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801744:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801747:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80174e:	eb 82                	jmp    8016d2 <vprintfmt+0x35>
  801750:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801753:	85 c0                	test   %eax,%eax
  801755:	ba 00 00 00 00       	mov    $0x0,%edx
  80175a:	0f 49 d0             	cmovns %eax,%edx
  80175d:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801760:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801763:	e9 6a ff ff ff       	jmp    8016d2 <vprintfmt+0x35>
  801768:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80176b:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  801772:	e9 5b ff ff ff       	jmp    8016d2 <vprintfmt+0x35>
  801777:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80177a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80177d:	eb bc                	jmp    80173b <vprintfmt+0x9e>
			lflag++;
  80177f:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801782:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  801785:	e9 48 ff ff ff       	jmp    8016d2 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  80178a:	8b 45 14             	mov    0x14(%ebp),%eax
  80178d:	8d 78 04             	lea    0x4(%eax),%edi
  801790:	83 ec 08             	sub    $0x8,%esp
  801793:	53                   	push   %ebx
  801794:	ff 30                	pushl  (%eax)
  801796:	ff d6                	call   *%esi
			break;
  801798:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80179b:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80179e:	e9 2f 03 00 00       	jmp    801ad2 <vprintfmt+0x435>
			err = va_arg(ap, int);
  8017a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8017a6:	8d 78 04             	lea    0x4(%eax),%edi
  8017a9:	8b 00                	mov    (%eax),%eax
  8017ab:	99                   	cltd   
  8017ac:	31 d0                	xor    %edx,%eax
  8017ae:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8017b0:	83 f8 0f             	cmp    $0xf,%eax
  8017b3:	7f 23                	jg     8017d8 <vprintfmt+0x13b>
  8017b5:	8b 14 85 60 27 80 00 	mov    0x802760(,%eax,4),%edx
  8017bc:	85 d2                	test   %edx,%edx
  8017be:	74 18                	je     8017d8 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  8017c0:	52                   	push   %edx
  8017c1:	68 07 24 80 00       	push   $0x802407
  8017c6:	53                   	push   %ebx
  8017c7:	56                   	push   %esi
  8017c8:	e8 b3 fe ff ff       	call   801680 <printfmt>
  8017cd:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8017d0:	89 7d 14             	mov    %edi,0x14(%ebp)
  8017d3:	e9 fa 02 00 00       	jmp    801ad2 <vprintfmt+0x435>
				printfmt(putch, putdat, "error %d", err);
  8017d8:	50                   	push   %eax
  8017d9:	68 c7 24 80 00       	push   $0x8024c7
  8017de:	53                   	push   %ebx
  8017df:	56                   	push   %esi
  8017e0:	e8 9b fe ff ff       	call   801680 <printfmt>
  8017e5:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8017e8:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8017eb:	e9 e2 02 00 00       	jmp    801ad2 <vprintfmt+0x435>
			if ((p = va_arg(ap, char *)) == NULL)
  8017f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8017f3:	83 c0 04             	add    $0x4,%eax
  8017f6:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8017f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8017fc:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8017fe:	85 ff                	test   %edi,%edi
  801800:	b8 c0 24 80 00       	mov    $0x8024c0,%eax
  801805:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  801808:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80180c:	0f 8e bd 00 00 00    	jle    8018cf <vprintfmt+0x232>
  801812:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  801816:	75 0e                	jne    801826 <vprintfmt+0x189>
  801818:	89 75 08             	mov    %esi,0x8(%ebp)
  80181b:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80181e:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  801821:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  801824:	eb 6d                	jmp    801893 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  801826:	83 ec 08             	sub    $0x8,%esp
  801829:	ff 75 d0             	pushl  -0x30(%ebp)
  80182c:	57                   	push   %edi
  80182d:	e8 ec 03 00 00       	call   801c1e <strnlen>
  801832:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  801835:	29 c1                	sub    %eax,%ecx
  801837:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  80183a:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  80183d:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  801841:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801844:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  801847:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  801849:	eb 0f                	jmp    80185a <vprintfmt+0x1bd>
					putch(padc, putdat);
  80184b:	83 ec 08             	sub    $0x8,%esp
  80184e:	53                   	push   %ebx
  80184f:	ff 75 e0             	pushl  -0x20(%ebp)
  801852:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  801854:	83 ef 01             	sub    $0x1,%edi
  801857:	83 c4 10             	add    $0x10,%esp
  80185a:	85 ff                	test   %edi,%edi
  80185c:	7f ed                	jg     80184b <vprintfmt+0x1ae>
  80185e:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  801861:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  801864:	85 c9                	test   %ecx,%ecx
  801866:	b8 00 00 00 00       	mov    $0x0,%eax
  80186b:	0f 49 c1             	cmovns %ecx,%eax
  80186e:	29 c1                	sub    %eax,%ecx
  801870:	89 75 08             	mov    %esi,0x8(%ebp)
  801873:	8b 75 d0             	mov    -0x30(%ebp),%esi
  801876:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  801879:	89 cb                	mov    %ecx,%ebx
  80187b:	eb 16                	jmp    801893 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  80187d:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801881:	75 31                	jne    8018b4 <vprintfmt+0x217>
					putch(ch, putdat);
  801883:	83 ec 08             	sub    $0x8,%esp
  801886:	ff 75 0c             	pushl  0xc(%ebp)
  801889:	50                   	push   %eax
  80188a:	ff 55 08             	call   *0x8(%ebp)
  80188d:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801890:	83 eb 01             	sub    $0x1,%ebx
  801893:	83 c7 01             	add    $0x1,%edi
  801896:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  80189a:	0f be c2             	movsbl %dl,%eax
  80189d:	85 c0                	test   %eax,%eax
  80189f:	74 59                	je     8018fa <vprintfmt+0x25d>
  8018a1:	85 f6                	test   %esi,%esi
  8018a3:	78 d8                	js     80187d <vprintfmt+0x1e0>
  8018a5:	83 ee 01             	sub    $0x1,%esi
  8018a8:	79 d3                	jns    80187d <vprintfmt+0x1e0>
  8018aa:	89 df                	mov    %ebx,%edi
  8018ac:	8b 75 08             	mov    0x8(%ebp),%esi
  8018af:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8018b2:	eb 37                	jmp    8018eb <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  8018b4:	0f be d2             	movsbl %dl,%edx
  8018b7:	83 ea 20             	sub    $0x20,%edx
  8018ba:	83 fa 5e             	cmp    $0x5e,%edx
  8018bd:	76 c4                	jbe    801883 <vprintfmt+0x1e6>
					putch('?', putdat);
  8018bf:	83 ec 08             	sub    $0x8,%esp
  8018c2:	ff 75 0c             	pushl  0xc(%ebp)
  8018c5:	6a 3f                	push   $0x3f
  8018c7:	ff 55 08             	call   *0x8(%ebp)
  8018ca:	83 c4 10             	add    $0x10,%esp
  8018cd:	eb c1                	jmp    801890 <vprintfmt+0x1f3>
  8018cf:	89 75 08             	mov    %esi,0x8(%ebp)
  8018d2:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8018d5:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8018d8:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8018db:	eb b6                	jmp    801893 <vprintfmt+0x1f6>
				putch(' ', putdat);
  8018dd:	83 ec 08             	sub    $0x8,%esp
  8018e0:	53                   	push   %ebx
  8018e1:	6a 20                	push   $0x20
  8018e3:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8018e5:	83 ef 01             	sub    $0x1,%edi
  8018e8:	83 c4 10             	add    $0x10,%esp
  8018eb:	85 ff                	test   %edi,%edi
  8018ed:	7f ee                	jg     8018dd <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  8018ef:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8018f2:	89 45 14             	mov    %eax,0x14(%ebp)
  8018f5:	e9 d8 01 00 00       	jmp    801ad2 <vprintfmt+0x435>
  8018fa:	89 df                	mov    %ebx,%edi
  8018fc:	8b 75 08             	mov    0x8(%ebp),%esi
  8018ff:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801902:	eb e7                	jmp    8018eb <vprintfmt+0x24e>
	if (lflag >= 2)
  801904:	83 f9 01             	cmp    $0x1,%ecx
  801907:	7e 45                	jle    80194e <vprintfmt+0x2b1>
		return va_arg(*ap, long long);
  801909:	8b 45 14             	mov    0x14(%ebp),%eax
  80190c:	8b 50 04             	mov    0x4(%eax),%edx
  80190f:	8b 00                	mov    (%eax),%eax
  801911:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801914:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801917:	8b 45 14             	mov    0x14(%ebp),%eax
  80191a:	8d 40 08             	lea    0x8(%eax),%eax
  80191d:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  801920:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801924:	79 62                	jns    801988 <vprintfmt+0x2eb>
				putch('-', putdat);
  801926:	83 ec 08             	sub    $0x8,%esp
  801929:	53                   	push   %ebx
  80192a:	6a 2d                	push   $0x2d
  80192c:	ff d6                	call   *%esi
				num = -(long long) num;
  80192e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801931:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801934:	f7 d8                	neg    %eax
  801936:	83 d2 00             	adc    $0x0,%edx
  801939:	f7 da                	neg    %edx
  80193b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80193e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801941:	83 c4 10             	add    $0x10,%esp
			base = 10;
  801944:	ba 0a 00 00 00       	mov    $0xa,%edx
  801949:	e9 66 01 00 00       	jmp    801ab4 <vprintfmt+0x417>
	else if (lflag)
  80194e:	85 c9                	test   %ecx,%ecx
  801950:	75 1b                	jne    80196d <vprintfmt+0x2d0>
		return va_arg(*ap, int);
  801952:	8b 45 14             	mov    0x14(%ebp),%eax
  801955:	8b 00                	mov    (%eax),%eax
  801957:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80195a:	89 c1                	mov    %eax,%ecx
  80195c:	c1 f9 1f             	sar    $0x1f,%ecx
  80195f:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  801962:	8b 45 14             	mov    0x14(%ebp),%eax
  801965:	8d 40 04             	lea    0x4(%eax),%eax
  801968:	89 45 14             	mov    %eax,0x14(%ebp)
  80196b:	eb b3                	jmp    801920 <vprintfmt+0x283>
		return va_arg(*ap, long);
  80196d:	8b 45 14             	mov    0x14(%ebp),%eax
  801970:	8b 00                	mov    (%eax),%eax
  801972:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801975:	89 c1                	mov    %eax,%ecx
  801977:	c1 f9 1f             	sar    $0x1f,%ecx
  80197a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80197d:	8b 45 14             	mov    0x14(%ebp),%eax
  801980:	8d 40 04             	lea    0x4(%eax),%eax
  801983:	89 45 14             	mov    %eax,0x14(%ebp)
  801986:	eb 98                	jmp    801920 <vprintfmt+0x283>
			base = 10;
  801988:	ba 0a 00 00 00       	mov    $0xa,%edx
  80198d:	e9 22 01 00 00       	jmp    801ab4 <vprintfmt+0x417>
	if (lflag >= 2)
  801992:	83 f9 01             	cmp    $0x1,%ecx
  801995:	7e 21                	jle    8019b8 <vprintfmt+0x31b>
		return va_arg(*ap, unsigned long long);
  801997:	8b 45 14             	mov    0x14(%ebp),%eax
  80199a:	8b 50 04             	mov    0x4(%eax),%edx
  80199d:	8b 00                	mov    (%eax),%eax
  80199f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8019a2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8019a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8019a8:	8d 40 08             	lea    0x8(%eax),%eax
  8019ab:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8019ae:	ba 0a 00 00 00       	mov    $0xa,%edx
  8019b3:	e9 fc 00 00 00       	jmp    801ab4 <vprintfmt+0x417>
	else if (lflag)
  8019b8:	85 c9                	test   %ecx,%ecx
  8019ba:	75 23                	jne    8019df <vprintfmt+0x342>
		return va_arg(*ap, unsigned int);
  8019bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8019bf:	8b 00                	mov    (%eax),%eax
  8019c1:	ba 00 00 00 00       	mov    $0x0,%edx
  8019c6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8019c9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8019cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8019cf:	8d 40 04             	lea    0x4(%eax),%eax
  8019d2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8019d5:	ba 0a 00 00 00       	mov    $0xa,%edx
  8019da:	e9 d5 00 00 00       	jmp    801ab4 <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  8019df:	8b 45 14             	mov    0x14(%ebp),%eax
  8019e2:	8b 00                	mov    (%eax),%eax
  8019e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8019e9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8019ec:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8019ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8019f2:	8d 40 04             	lea    0x4(%eax),%eax
  8019f5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8019f8:	ba 0a 00 00 00       	mov    $0xa,%edx
  8019fd:	e9 b2 00 00 00       	jmp    801ab4 <vprintfmt+0x417>
	if (lflag >= 2)
  801a02:	83 f9 01             	cmp    $0x1,%ecx
  801a05:	7e 42                	jle    801a49 <vprintfmt+0x3ac>
		return va_arg(*ap, unsigned long long);
  801a07:	8b 45 14             	mov    0x14(%ebp),%eax
  801a0a:	8b 50 04             	mov    0x4(%eax),%edx
  801a0d:	8b 00                	mov    (%eax),%eax
  801a0f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801a12:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801a15:	8b 45 14             	mov    0x14(%ebp),%eax
  801a18:	8d 40 08             	lea    0x8(%eax),%eax
  801a1b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801a1e:	ba 08 00 00 00       	mov    $0x8,%edx
			if ((long long) num < 0) {
  801a23:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801a27:	0f 89 87 00 00 00    	jns    801ab4 <vprintfmt+0x417>
				putch('-', putdat);
  801a2d:	83 ec 08             	sub    $0x8,%esp
  801a30:	53                   	push   %ebx
  801a31:	6a 2d                	push   $0x2d
  801a33:	ff d6                	call   *%esi
				num = -(long long) num;
  801a35:	f7 5d d8             	negl   -0x28(%ebp)
  801a38:	83 55 dc 00          	adcl   $0x0,-0x24(%ebp)
  801a3c:	f7 5d dc             	negl   -0x24(%ebp)
  801a3f:	83 c4 10             	add    $0x10,%esp
			base = 8;
  801a42:	ba 08 00 00 00       	mov    $0x8,%edx
  801a47:	eb 6b                	jmp    801ab4 <vprintfmt+0x417>
	else if (lflag)
  801a49:	85 c9                	test   %ecx,%ecx
  801a4b:	75 1b                	jne    801a68 <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  801a4d:	8b 45 14             	mov    0x14(%ebp),%eax
  801a50:	8b 00                	mov    (%eax),%eax
  801a52:	ba 00 00 00 00       	mov    $0x0,%edx
  801a57:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801a5a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801a5d:	8b 45 14             	mov    0x14(%ebp),%eax
  801a60:	8d 40 04             	lea    0x4(%eax),%eax
  801a63:	89 45 14             	mov    %eax,0x14(%ebp)
  801a66:	eb b6                	jmp    801a1e <vprintfmt+0x381>
		return va_arg(*ap, unsigned long);
  801a68:	8b 45 14             	mov    0x14(%ebp),%eax
  801a6b:	8b 00                	mov    (%eax),%eax
  801a6d:	ba 00 00 00 00       	mov    $0x0,%edx
  801a72:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801a75:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801a78:	8b 45 14             	mov    0x14(%ebp),%eax
  801a7b:	8d 40 04             	lea    0x4(%eax),%eax
  801a7e:	89 45 14             	mov    %eax,0x14(%ebp)
  801a81:	eb 9b                	jmp    801a1e <vprintfmt+0x381>
			putch('0', putdat);
  801a83:	83 ec 08             	sub    $0x8,%esp
  801a86:	53                   	push   %ebx
  801a87:	6a 30                	push   $0x30
  801a89:	ff d6                	call   *%esi
			putch('x', putdat);
  801a8b:	83 c4 08             	add    $0x8,%esp
  801a8e:	53                   	push   %ebx
  801a8f:	6a 78                	push   $0x78
  801a91:	ff d6                	call   *%esi
			num = (unsigned long long)
  801a93:	8b 45 14             	mov    0x14(%ebp),%eax
  801a96:	8b 00                	mov    (%eax),%eax
  801a98:	ba 00 00 00 00       	mov    $0x0,%edx
  801a9d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801aa0:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  801aa3:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  801aa6:	8b 45 14             	mov    0x14(%ebp),%eax
  801aa9:	8d 40 04             	lea    0x4(%eax),%eax
  801aac:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801aaf:	ba 10 00 00 00       	mov    $0x10,%edx
			printnum(putch, putdat, num, base, width, padc);
  801ab4:	83 ec 0c             	sub    $0xc,%esp
  801ab7:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  801abb:	50                   	push   %eax
  801abc:	ff 75 e0             	pushl  -0x20(%ebp)
  801abf:	52                   	push   %edx
  801ac0:	ff 75 dc             	pushl  -0x24(%ebp)
  801ac3:	ff 75 d8             	pushl  -0x28(%ebp)
  801ac6:	89 da                	mov    %ebx,%edx
  801ac8:	89 f0                	mov    %esi,%eax
  801aca:	e8 e5 fa ff ff       	call   8015b4 <printnum>
			break;
  801acf:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  801ad2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801ad5:	83 c7 01             	add    $0x1,%edi
  801ad8:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801adc:	83 f8 25             	cmp    $0x25,%eax
  801adf:	0f 84 cf fb ff ff    	je     8016b4 <vprintfmt+0x17>
			if (ch == '\0')
  801ae5:	85 c0                	test   %eax,%eax
  801ae7:	0f 84 a9 00 00 00    	je     801b96 <vprintfmt+0x4f9>
			putch(ch, putdat);
  801aed:	83 ec 08             	sub    $0x8,%esp
  801af0:	53                   	push   %ebx
  801af1:	50                   	push   %eax
  801af2:	ff d6                	call   *%esi
  801af4:	83 c4 10             	add    $0x10,%esp
  801af7:	eb dc                	jmp    801ad5 <vprintfmt+0x438>
	if (lflag >= 2)
  801af9:	83 f9 01             	cmp    $0x1,%ecx
  801afc:	7e 1e                	jle    801b1c <vprintfmt+0x47f>
		return va_arg(*ap, unsigned long long);
  801afe:	8b 45 14             	mov    0x14(%ebp),%eax
  801b01:	8b 50 04             	mov    0x4(%eax),%edx
  801b04:	8b 00                	mov    (%eax),%eax
  801b06:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801b09:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801b0c:	8b 45 14             	mov    0x14(%ebp),%eax
  801b0f:	8d 40 08             	lea    0x8(%eax),%eax
  801b12:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801b15:	ba 10 00 00 00       	mov    $0x10,%edx
  801b1a:	eb 98                	jmp    801ab4 <vprintfmt+0x417>
	else if (lflag)
  801b1c:	85 c9                	test   %ecx,%ecx
  801b1e:	75 23                	jne    801b43 <vprintfmt+0x4a6>
		return va_arg(*ap, unsigned int);
  801b20:	8b 45 14             	mov    0x14(%ebp),%eax
  801b23:	8b 00                	mov    (%eax),%eax
  801b25:	ba 00 00 00 00       	mov    $0x0,%edx
  801b2a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801b2d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801b30:	8b 45 14             	mov    0x14(%ebp),%eax
  801b33:	8d 40 04             	lea    0x4(%eax),%eax
  801b36:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801b39:	ba 10 00 00 00       	mov    $0x10,%edx
  801b3e:	e9 71 ff ff ff       	jmp    801ab4 <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  801b43:	8b 45 14             	mov    0x14(%ebp),%eax
  801b46:	8b 00                	mov    (%eax),%eax
  801b48:	ba 00 00 00 00       	mov    $0x0,%edx
  801b4d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801b50:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801b53:	8b 45 14             	mov    0x14(%ebp),%eax
  801b56:	8d 40 04             	lea    0x4(%eax),%eax
  801b59:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801b5c:	ba 10 00 00 00       	mov    $0x10,%edx
  801b61:	e9 4e ff ff ff       	jmp    801ab4 <vprintfmt+0x417>
			putch(ch, putdat);
  801b66:	83 ec 08             	sub    $0x8,%esp
  801b69:	53                   	push   %ebx
  801b6a:	6a 25                	push   $0x25
  801b6c:	ff d6                	call   *%esi
			break;
  801b6e:	83 c4 10             	add    $0x10,%esp
  801b71:	e9 5c ff ff ff       	jmp    801ad2 <vprintfmt+0x435>
			putch('%', putdat);
  801b76:	83 ec 08             	sub    $0x8,%esp
  801b79:	53                   	push   %ebx
  801b7a:	6a 25                	push   $0x25
  801b7c:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  801b7e:	83 c4 10             	add    $0x10,%esp
  801b81:	89 f8                	mov    %edi,%eax
  801b83:	eb 03                	jmp    801b88 <vprintfmt+0x4eb>
  801b85:	83 e8 01             	sub    $0x1,%eax
  801b88:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  801b8c:	75 f7                	jne    801b85 <vprintfmt+0x4e8>
  801b8e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801b91:	e9 3c ff ff ff       	jmp    801ad2 <vprintfmt+0x435>
}
  801b96:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b99:	5b                   	pop    %ebx
  801b9a:	5e                   	pop    %esi
  801b9b:	5f                   	pop    %edi
  801b9c:	5d                   	pop    %ebp
  801b9d:	c3                   	ret    

00801b9e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801b9e:	55                   	push   %ebp
  801b9f:	89 e5                	mov    %esp,%ebp
  801ba1:	83 ec 18             	sub    $0x18,%esp
  801ba4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba7:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801baa:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801bad:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801bb1:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801bb4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801bbb:	85 c0                	test   %eax,%eax
  801bbd:	74 26                	je     801be5 <vsnprintf+0x47>
  801bbf:	85 d2                	test   %edx,%edx
  801bc1:	7e 22                	jle    801be5 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801bc3:	ff 75 14             	pushl  0x14(%ebp)
  801bc6:	ff 75 10             	pushl  0x10(%ebp)
  801bc9:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801bcc:	50                   	push   %eax
  801bcd:	68 63 16 80 00       	push   $0x801663
  801bd2:	e8 c6 fa ff ff       	call   80169d <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801bd7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bda:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801bdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801be0:	83 c4 10             	add    $0x10,%esp
}
  801be3:	c9                   	leave  
  801be4:	c3                   	ret    
		return -E_INVAL;
  801be5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801bea:	eb f7                	jmp    801be3 <vsnprintf+0x45>

00801bec <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801bec:	55                   	push   %ebp
  801bed:	89 e5                	mov    %esp,%ebp
  801bef:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801bf2:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801bf5:	50                   	push   %eax
  801bf6:	ff 75 10             	pushl  0x10(%ebp)
  801bf9:	ff 75 0c             	pushl  0xc(%ebp)
  801bfc:	ff 75 08             	pushl  0x8(%ebp)
  801bff:	e8 9a ff ff ff       	call   801b9e <vsnprintf>
	va_end(ap);

	return rc;
}
  801c04:	c9                   	leave  
  801c05:	c3                   	ret    

00801c06 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801c06:	55                   	push   %ebp
  801c07:	89 e5                	mov    %esp,%ebp
  801c09:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801c0c:	b8 00 00 00 00       	mov    $0x0,%eax
  801c11:	eb 03                	jmp    801c16 <strlen+0x10>
		n++;
  801c13:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  801c16:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801c1a:	75 f7                	jne    801c13 <strlen+0xd>
	return n;
}
  801c1c:	5d                   	pop    %ebp
  801c1d:	c3                   	ret    

00801c1e <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801c1e:	55                   	push   %ebp
  801c1f:	89 e5                	mov    %esp,%ebp
  801c21:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c24:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801c27:	b8 00 00 00 00       	mov    $0x0,%eax
  801c2c:	eb 03                	jmp    801c31 <strnlen+0x13>
		n++;
  801c2e:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801c31:	39 d0                	cmp    %edx,%eax
  801c33:	74 06                	je     801c3b <strnlen+0x1d>
  801c35:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  801c39:	75 f3                	jne    801c2e <strnlen+0x10>
	return n;
}
  801c3b:	5d                   	pop    %ebp
  801c3c:	c3                   	ret    

00801c3d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801c3d:	55                   	push   %ebp
  801c3e:	89 e5                	mov    %esp,%ebp
  801c40:	53                   	push   %ebx
  801c41:	8b 45 08             	mov    0x8(%ebp),%eax
  801c44:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801c47:	89 c2                	mov    %eax,%edx
  801c49:	83 c1 01             	add    $0x1,%ecx
  801c4c:	83 c2 01             	add    $0x1,%edx
  801c4f:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  801c53:	88 5a ff             	mov    %bl,-0x1(%edx)
  801c56:	84 db                	test   %bl,%bl
  801c58:	75 ef                	jne    801c49 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  801c5a:	5b                   	pop    %ebx
  801c5b:	5d                   	pop    %ebp
  801c5c:	c3                   	ret    

00801c5d <strcat>:

char *
strcat(char *dst, const char *src)
{
  801c5d:	55                   	push   %ebp
  801c5e:	89 e5                	mov    %esp,%ebp
  801c60:	53                   	push   %ebx
  801c61:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801c64:	53                   	push   %ebx
  801c65:	e8 9c ff ff ff       	call   801c06 <strlen>
  801c6a:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  801c6d:	ff 75 0c             	pushl  0xc(%ebp)
  801c70:	01 d8                	add    %ebx,%eax
  801c72:	50                   	push   %eax
  801c73:	e8 c5 ff ff ff       	call   801c3d <strcpy>
	return dst;
}
  801c78:	89 d8                	mov    %ebx,%eax
  801c7a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c7d:	c9                   	leave  
  801c7e:	c3                   	ret    

00801c7f <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801c7f:	55                   	push   %ebp
  801c80:	89 e5                	mov    %esp,%ebp
  801c82:	56                   	push   %esi
  801c83:	53                   	push   %ebx
  801c84:	8b 75 08             	mov    0x8(%ebp),%esi
  801c87:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c8a:	89 f3                	mov    %esi,%ebx
  801c8c:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801c8f:	89 f2                	mov    %esi,%edx
  801c91:	eb 0f                	jmp    801ca2 <strncpy+0x23>
		*dst++ = *src;
  801c93:	83 c2 01             	add    $0x1,%edx
  801c96:	0f b6 01             	movzbl (%ecx),%eax
  801c99:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801c9c:	80 39 01             	cmpb   $0x1,(%ecx)
  801c9f:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  801ca2:	39 da                	cmp    %ebx,%edx
  801ca4:	75 ed                	jne    801c93 <strncpy+0x14>
	}
	return ret;
}
  801ca6:	89 f0                	mov    %esi,%eax
  801ca8:	5b                   	pop    %ebx
  801ca9:	5e                   	pop    %esi
  801caa:	5d                   	pop    %ebp
  801cab:	c3                   	ret    

00801cac <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801cac:	55                   	push   %ebp
  801cad:	89 e5                	mov    %esp,%ebp
  801caf:	56                   	push   %esi
  801cb0:	53                   	push   %ebx
  801cb1:	8b 75 08             	mov    0x8(%ebp),%esi
  801cb4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cb7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cba:	89 f0                	mov    %esi,%eax
  801cbc:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801cc0:	85 c9                	test   %ecx,%ecx
  801cc2:	75 0b                	jne    801ccf <strlcpy+0x23>
  801cc4:	eb 17                	jmp    801cdd <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  801cc6:	83 c2 01             	add    $0x1,%edx
  801cc9:	83 c0 01             	add    $0x1,%eax
  801ccc:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  801ccf:	39 d8                	cmp    %ebx,%eax
  801cd1:	74 07                	je     801cda <strlcpy+0x2e>
  801cd3:	0f b6 0a             	movzbl (%edx),%ecx
  801cd6:	84 c9                	test   %cl,%cl
  801cd8:	75 ec                	jne    801cc6 <strlcpy+0x1a>
		*dst = '\0';
  801cda:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801cdd:	29 f0                	sub    %esi,%eax
}
  801cdf:	5b                   	pop    %ebx
  801ce0:	5e                   	pop    %esi
  801ce1:	5d                   	pop    %ebp
  801ce2:	c3                   	ret    

00801ce3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801ce3:	55                   	push   %ebp
  801ce4:	89 e5                	mov    %esp,%ebp
  801ce6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ce9:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801cec:	eb 06                	jmp    801cf4 <strcmp+0x11>
		p++, q++;
  801cee:	83 c1 01             	add    $0x1,%ecx
  801cf1:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  801cf4:	0f b6 01             	movzbl (%ecx),%eax
  801cf7:	84 c0                	test   %al,%al
  801cf9:	74 04                	je     801cff <strcmp+0x1c>
  801cfb:	3a 02                	cmp    (%edx),%al
  801cfd:	74 ef                	je     801cee <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801cff:	0f b6 c0             	movzbl %al,%eax
  801d02:	0f b6 12             	movzbl (%edx),%edx
  801d05:	29 d0                	sub    %edx,%eax
}
  801d07:	5d                   	pop    %ebp
  801d08:	c3                   	ret    

00801d09 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801d09:	55                   	push   %ebp
  801d0a:	89 e5                	mov    %esp,%ebp
  801d0c:	53                   	push   %ebx
  801d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d10:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d13:	89 c3                	mov    %eax,%ebx
  801d15:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  801d18:	eb 06                	jmp    801d20 <strncmp+0x17>
		n--, p++, q++;
  801d1a:	83 c0 01             	add    $0x1,%eax
  801d1d:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  801d20:	39 d8                	cmp    %ebx,%eax
  801d22:	74 16                	je     801d3a <strncmp+0x31>
  801d24:	0f b6 08             	movzbl (%eax),%ecx
  801d27:	84 c9                	test   %cl,%cl
  801d29:	74 04                	je     801d2f <strncmp+0x26>
  801d2b:	3a 0a                	cmp    (%edx),%cl
  801d2d:	74 eb                	je     801d1a <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801d2f:	0f b6 00             	movzbl (%eax),%eax
  801d32:	0f b6 12             	movzbl (%edx),%edx
  801d35:	29 d0                	sub    %edx,%eax
}
  801d37:	5b                   	pop    %ebx
  801d38:	5d                   	pop    %ebp
  801d39:	c3                   	ret    
		return 0;
  801d3a:	b8 00 00 00 00       	mov    $0x0,%eax
  801d3f:	eb f6                	jmp    801d37 <strncmp+0x2e>

00801d41 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801d41:	55                   	push   %ebp
  801d42:	89 e5                	mov    %esp,%ebp
  801d44:	8b 45 08             	mov    0x8(%ebp),%eax
  801d47:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801d4b:	0f b6 10             	movzbl (%eax),%edx
  801d4e:	84 d2                	test   %dl,%dl
  801d50:	74 09                	je     801d5b <strchr+0x1a>
		if (*s == c)
  801d52:	38 ca                	cmp    %cl,%dl
  801d54:	74 0a                	je     801d60 <strchr+0x1f>
	for (; *s; s++)
  801d56:	83 c0 01             	add    $0x1,%eax
  801d59:	eb f0                	jmp    801d4b <strchr+0xa>
			return (char *) s;
	return 0;
  801d5b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d60:	5d                   	pop    %ebp
  801d61:	c3                   	ret    

00801d62 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801d62:	55                   	push   %ebp
  801d63:	89 e5                	mov    %esp,%ebp
  801d65:	8b 45 08             	mov    0x8(%ebp),%eax
  801d68:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801d6c:	eb 03                	jmp    801d71 <strfind+0xf>
  801d6e:	83 c0 01             	add    $0x1,%eax
  801d71:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  801d74:	38 ca                	cmp    %cl,%dl
  801d76:	74 04                	je     801d7c <strfind+0x1a>
  801d78:	84 d2                	test   %dl,%dl
  801d7a:	75 f2                	jne    801d6e <strfind+0xc>
			break;
	return (char *) s;
}
  801d7c:	5d                   	pop    %ebp
  801d7d:	c3                   	ret    

00801d7e <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801d7e:	55                   	push   %ebp
  801d7f:	89 e5                	mov    %esp,%ebp
  801d81:	57                   	push   %edi
  801d82:	56                   	push   %esi
  801d83:	53                   	push   %ebx
  801d84:	8b 7d 08             	mov    0x8(%ebp),%edi
  801d87:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801d8a:	85 c9                	test   %ecx,%ecx
  801d8c:	74 13                	je     801da1 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801d8e:	f7 c7 03 00 00 00    	test   $0x3,%edi
  801d94:	75 05                	jne    801d9b <memset+0x1d>
  801d96:	f6 c1 03             	test   $0x3,%cl
  801d99:	74 0d                	je     801da8 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801d9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d9e:	fc                   	cld    
  801d9f:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801da1:	89 f8                	mov    %edi,%eax
  801da3:	5b                   	pop    %ebx
  801da4:	5e                   	pop    %esi
  801da5:	5f                   	pop    %edi
  801da6:	5d                   	pop    %ebp
  801da7:	c3                   	ret    
		c &= 0xFF;
  801da8:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801dac:	89 d3                	mov    %edx,%ebx
  801dae:	c1 e3 08             	shl    $0x8,%ebx
  801db1:	89 d0                	mov    %edx,%eax
  801db3:	c1 e0 18             	shl    $0x18,%eax
  801db6:	89 d6                	mov    %edx,%esi
  801db8:	c1 e6 10             	shl    $0x10,%esi
  801dbb:	09 f0                	or     %esi,%eax
  801dbd:	09 c2                	or     %eax,%edx
  801dbf:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  801dc1:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  801dc4:	89 d0                	mov    %edx,%eax
  801dc6:	fc                   	cld    
  801dc7:	f3 ab                	rep stos %eax,%es:(%edi)
  801dc9:	eb d6                	jmp    801da1 <memset+0x23>

00801dcb <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801dcb:	55                   	push   %ebp
  801dcc:	89 e5                	mov    %esp,%ebp
  801dce:	57                   	push   %edi
  801dcf:	56                   	push   %esi
  801dd0:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd3:	8b 75 0c             	mov    0xc(%ebp),%esi
  801dd6:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801dd9:	39 c6                	cmp    %eax,%esi
  801ddb:	73 35                	jae    801e12 <memmove+0x47>
  801ddd:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801de0:	39 c2                	cmp    %eax,%edx
  801de2:	76 2e                	jbe    801e12 <memmove+0x47>
		s += n;
		d += n;
  801de4:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801de7:	89 d6                	mov    %edx,%esi
  801de9:	09 fe                	or     %edi,%esi
  801deb:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801df1:	74 0c                	je     801dff <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801df3:	83 ef 01             	sub    $0x1,%edi
  801df6:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  801df9:	fd                   	std    
  801dfa:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801dfc:	fc                   	cld    
  801dfd:	eb 21                	jmp    801e20 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801dff:	f6 c1 03             	test   $0x3,%cl
  801e02:	75 ef                	jne    801df3 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801e04:	83 ef 04             	sub    $0x4,%edi
  801e07:	8d 72 fc             	lea    -0x4(%edx),%esi
  801e0a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  801e0d:	fd                   	std    
  801e0e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801e10:	eb ea                	jmp    801dfc <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801e12:	89 f2                	mov    %esi,%edx
  801e14:	09 c2                	or     %eax,%edx
  801e16:	f6 c2 03             	test   $0x3,%dl
  801e19:	74 09                	je     801e24 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801e1b:	89 c7                	mov    %eax,%edi
  801e1d:	fc                   	cld    
  801e1e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801e20:	5e                   	pop    %esi
  801e21:	5f                   	pop    %edi
  801e22:	5d                   	pop    %ebp
  801e23:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801e24:	f6 c1 03             	test   $0x3,%cl
  801e27:	75 f2                	jne    801e1b <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801e29:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  801e2c:	89 c7                	mov    %eax,%edi
  801e2e:	fc                   	cld    
  801e2f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801e31:	eb ed                	jmp    801e20 <memmove+0x55>

00801e33 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801e33:	55                   	push   %ebp
  801e34:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  801e36:	ff 75 10             	pushl  0x10(%ebp)
  801e39:	ff 75 0c             	pushl  0xc(%ebp)
  801e3c:	ff 75 08             	pushl  0x8(%ebp)
  801e3f:	e8 87 ff ff ff       	call   801dcb <memmove>
}
  801e44:	c9                   	leave  
  801e45:	c3                   	ret    

00801e46 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801e46:	55                   	push   %ebp
  801e47:	89 e5                	mov    %esp,%ebp
  801e49:	56                   	push   %esi
  801e4a:	53                   	push   %ebx
  801e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e51:	89 c6                	mov    %eax,%esi
  801e53:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801e56:	39 f0                	cmp    %esi,%eax
  801e58:	74 1c                	je     801e76 <memcmp+0x30>
		if (*s1 != *s2)
  801e5a:	0f b6 08             	movzbl (%eax),%ecx
  801e5d:	0f b6 1a             	movzbl (%edx),%ebx
  801e60:	38 d9                	cmp    %bl,%cl
  801e62:	75 08                	jne    801e6c <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801e64:	83 c0 01             	add    $0x1,%eax
  801e67:	83 c2 01             	add    $0x1,%edx
  801e6a:	eb ea                	jmp    801e56 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  801e6c:	0f b6 c1             	movzbl %cl,%eax
  801e6f:	0f b6 db             	movzbl %bl,%ebx
  801e72:	29 d8                	sub    %ebx,%eax
  801e74:	eb 05                	jmp    801e7b <memcmp+0x35>
	}

	return 0;
  801e76:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e7b:	5b                   	pop    %ebx
  801e7c:	5e                   	pop    %esi
  801e7d:	5d                   	pop    %ebp
  801e7e:	c3                   	ret    

00801e7f <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801e7f:	55                   	push   %ebp
  801e80:	89 e5                	mov    %esp,%ebp
  801e82:	8b 45 08             	mov    0x8(%ebp),%eax
  801e85:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801e88:	89 c2                	mov    %eax,%edx
  801e8a:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801e8d:	39 d0                	cmp    %edx,%eax
  801e8f:	73 09                	jae    801e9a <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  801e91:	38 08                	cmp    %cl,(%eax)
  801e93:	74 05                	je     801e9a <memfind+0x1b>
	for (; s < ends; s++)
  801e95:	83 c0 01             	add    $0x1,%eax
  801e98:	eb f3                	jmp    801e8d <memfind+0xe>
			break;
	return (void *) s;
}
  801e9a:	5d                   	pop    %ebp
  801e9b:	c3                   	ret    

00801e9c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801e9c:	55                   	push   %ebp
  801e9d:	89 e5                	mov    %esp,%ebp
  801e9f:	57                   	push   %edi
  801ea0:	56                   	push   %esi
  801ea1:	53                   	push   %ebx
  801ea2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ea5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801ea8:	eb 03                	jmp    801ead <strtol+0x11>
		s++;
  801eaa:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  801ead:	0f b6 01             	movzbl (%ecx),%eax
  801eb0:	3c 20                	cmp    $0x20,%al
  801eb2:	74 f6                	je     801eaa <strtol+0xe>
  801eb4:	3c 09                	cmp    $0x9,%al
  801eb6:	74 f2                	je     801eaa <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  801eb8:	3c 2b                	cmp    $0x2b,%al
  801eba:	74 2e                	je     801eea <strtol+0x4e>
	int neg = 0;
  801ebc:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801ec1:	3c 2d                	cmp    $0x2d,%al
  801ec3:	74 2f                	je     801ef4 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801ec5:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  801ecb:	75 05                	jne    801ed2 <strtol+0x36>
  801ecd:	80 39 30             	cmpb   $0x30,(%ecx)
  801ed0:	74 2c                	je     801efe <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  801ed2:	85 db                	test   %ebx,%ebx
  801ed4:	75 0a                	jne    801ee0 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801ed6:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  801edb:	80 39 30             	cmpb   $0x30,(%ecx)
  801ede:	74 28                	je     801f08 <strtol+0x6c>
		base = 10;
  801ee0:	b8 00 00 00 00       	mov    $0x0,%eax
  801ee5:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801ee8:	eb 50                	jmp    801f3a <strtol+0x9e>
		s++;
  801eea:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  801eed:	bf 00 00 00 00       	mov    $0x0,%edi
  801ef2:	eb d1                	jmp    801ec5 <strtol+0x29>
		s++, neg = 1;
  801ef4:	83 c1 01             	add    $0x1,%ecx
  801ef7:	bf 01 00 00 00       	mov    $0x1,%edi
  801efc:	eb c7                	jmp    801ec5 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801efe:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801f02:	74 0e                	je     801f12 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  801f04:	85 db                	test   %ebx,%ebx
  801f06:	75 d8                	jne    801ee0 <strtol+0x44>
		s++, base = 8;
  801f08:	83 c1 01             	add    $0x1,%ecx
  801f0b:	bb 08 00 00 00       	mov    $0x8,%ebx
  801f10:	eb ce                	jmp    801ee0 <strtol+0x44>
		s += 2, base = 16;
  801f12:	83 c1 02             	add    $0x2,%ecx
  801f15:	bb 10 00 00 00       	mov    $0x10,%ebx
  801f1a:	eb c4                	jmp    801ee0 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  801f1c:	8d 72 9f             	lea    -0x61(%edx),%esi
  801f1f:	89 f3                	mov    %esi,%ebx
  801f21:	80 fb 19             	cmp    $0x19,%bl
  801f24:	77 29                	ja     801f4f <strtol+0xb3>
			dig = *s - 'a' + 10;
  801f26:	0f be d2             	movsbl %dl,%edx
  801f29:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801f2c:	3b 55 10             	cmp    0x10(%ebp),%edx
  801f2f:	7d 30                	jge    801f61 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  801f31:	83 c1 01             	add    $0x1,%ecx
  801f34:	0f af 45 10          	imul   0x10(%ebp),%eax
  801f38:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801f3a:	0f b6 11             	movzbl (%ecx),%edx
  801f3d:	8d 72 d0             	lea    -0x30(%edx),%esi
  801f40:	89 f3                	mov    %esi,%ebx
  801f42:	80 fb 09             	cmp    $0x9,%bl
  801f45:	77 d5                	ja     801f1c <strtol+0x80>
			dig = *s - '0';
  801f47:	0f be d2             	movsbl %dl,%edx
  801f4a:	83 ea 30             	sub    $0x30,%edx
  801f4d:	eb dd                	jmp    801f2c <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  801f4f:	8d 72 bf             	lea    -0x41(%edx),%esi
  801f52:	89 f3                	mov    %esi,%ebx
  801f54:	80 fb 19             	cmp    $0x19,%bl
  801f57:	77 08                	ja     801f61 <strtol+0xc5>
			dig = *s - 'A' + 10;
  801f59:	0f be d2             	movsbl %dl,%edx
  801f5c:	83 ea 37             	sub    $0x37,%edx
  801f5f:	eb cb                	jmp    801f2c <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  801f61:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801f65:	74 05                	je     801f6c <strtol+0xd0>
		*endptr = (char *) s;
  801f67:	8b 75 0c             	mov    0xc(%ebp),%esi
  801f6a:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801f6c:	89 c2                	mov    %eax,%edx
  801f6e:	f7 da                	neg    %edx
  801f70:	85 ff                	test   %edi,%edi
  801f72:	0f 45 c2             	cmovne %edx,%eax
}
  801f75:	5b                   	pop    %ebx
  801f76:	5e                   	pop    %esi
  801f77:	5f                   	pop    %edi
  801f78:	5d                   	pop    %ebp
  801f79:	c3                   	ret    

00801f7a <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801f7a:	55                   	push   %ebp
  801f7b:	89 e5                	mov    %esp,%ebp
  801f7d:	56                   	push   %esi
  801f7e:	53                   	push   %ebx
  801f7f:	8b 75 08             	mov    0x8(%ebp),%esi
  801f82:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f85:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
  801f88:	85 c0                	test   %eax,%eax
	    pg = (void *)UTOP;
  801f8a:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801f8f:	0f 44 c2             	cmove  %edx,%eax
	}
	if ((r = sys_ipc_recv(pg)) < 0) {
  801f92:	83 ec 0c             	sub    $0xc,%esp
  801f95:	50                   	push   %eax
  801f96:	e8 6b e3 ff ff       	call   800306 <sys_ipc_recv>
  801f9b:	83 c4 10             	add    $0x10,%esp
  801f9e:	85 c0                	test   %eax,%eax
  801fa0:	78 2b                	js     801fcd <ipc_recv+0x53>
	    if (perm_store != NULL) {
	        *perm_store = 0;
	    }
	    return r;
	}
	if (from_env_store != NULL) {
  801fa2:	85 f6                	test   %esi,%esi
  801fa4:	74 0a                	je     801fb0 <ipc_recv+0x36>
	    *from_env_store = thisenv->env_ipc_from;
  801fa6:	a1 08 40 80 00       	mov    0x804008,%eax
  801fab:	8b 40 74             	mov    0x74(%eax),%eax
  801fae:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store != NULL) {
  801fb0:	85 db                	test   %ebx,%ebx
  801fb2:	74 0a                	je     801fbe <ipc_recv+0x44>
	    *perm_store = thisenv->env_ipc_perm;
  801fb4:	a1 08 40 80 00       	mov    0x804008,%eax
  801fb9:	8b 40 78             	mov    0x78(%eax),%eax
  801fbc:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  801fbe:	a1 08 40 80 00       	mov    0x804008,%eax
  801fc3:	8b 40 70             	mov    0x70(%eax),%eax
}
  801fc6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fc9:	5b                   	pop    %ebx
  801fca:	5e                   	pop    %esi
  801fcb:	5d                   	pop    %ebp
  801fcc:	c3                   	ret    
	    if (from_env_store != NULL) {
  801fcd:	85 f6                	test   %esi,%esi
  801fcf:	74 06                	je     801fd7 <ipc_recv+0x5d>
	        *from_env_store = 0;
  801fd1:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	    if (perm_store != NULL) {
  801fd7:	85 db                	test   %ebx,%ebx
  801fd9:	74 eb                	je     801fc6 <ipc_recv+0x4c>
	        *perm_store = 0;
  801fdb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801fe1:	eb e3                	jmp    801fc6 <ipc_recv+0x4c>

00801fe3 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801fe3:	55                   	push   %ebp
  801fe4:	89 e5                	mov    %esp,%ebp
  801fe6:	57                   	push   %edi
  801fe7:	56                   	push   %esi
  801fe8:	53                   	push   %ebx
  801fe9:	83 ec 0c             	sub    $0xc,%esp
  801fec:	8b 7d 08             	mov    0x8(%ebp),%edi
  801fef:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
	    pg = (void *)UTOP;
  801ff2:	85 f6                	test   %esi,%esi
  801ff4:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801ff9:	0f 44 f0             	cmove  %eax,%esi
  801ffc:	eb 09                	jmp    802007 <ipc_send+0x24>
	do {
	    r = sys_ipc_try_send(to_env, val, pg, perm);
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
	        panic("ipc_send: %e", r);
	    }
	    sys_yield();
  801ffe:	e8 34 e1 ff ff       	call   800137 <sys_yield>
	} while(r != 0);
  802003:	85 db                	test   %ebx,%ebx
  802005:	74 2d                	je     802034 <ipc_send+0x51>
	    r = sys_ipc_try_send(to_env, val, pg, perm);
  802007:	ff 75 14             	pushl  0x14(%ebp)
  80200a:	56                   	push   %esi
  80200b:	ff 75 0c             	pushl  0xc(%ebp)
  80200e:	57                   	push   %edi
  80200f:	e8 cf e2 ff ff       	call   8002e3 <sys_ipc_try_send>
  802014:	89 c3                	mov    %eax,%ebx
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
  802016:	83 c4 10             	add    $0x10,%esp
  802019:	85 c0                	test   %eax,%eax
  80201b:	79 e1                	jns    801ffe <ipc_send+0x1b>
  80201d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802020:	74 dc                	je     801ffe <ipc_send+0x1b>
	        panic("ipc_send: %e", r);
  802022:	50                   	push   %eax
  802023:	68 c0 27 80 00       	push   $0x8027c0
  802028:	6a 45                	push   $0x45
  80202a:	68 cd 27 80 00       	push   $0x8027cd
  80202f:	e8 91 f4 ff ff       	call   8014c5 <_panic>
}
  802034:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802037:	5b                   	pop    %ebx
  802038:	5e                   	pop    %esi
  802039:	5f                   	pop    %edi
  80203a:	5d                   	pop    %ebp
  80203b:	c3                   	ret    

0080203c <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80203c:	55                   	push   %ebp
  80203d:	89 e5                	mov    %esp,%ebp
  80203f:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802042:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802047:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80204a:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802050:	8b 52 50             	mov    0x50(%edx),%edx
  802053:	39 ca                	cmp    %ecx,%edx
  802055:	74 11                	je     802068 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  802057:	83 c0 01             	add    $0x1,%eax
  80205a:	3d 00 04 00 00       	cmp    $0x400,%eax
  80205f:	75 e6                	jne    802047 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802061:	b8 00 00 00 00       	mov    $0x0,%eax
  802066:	eb 0b                	jmp    802073 <ipc_find_env+0x37>
			return envs[i].env_id;
  802068:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80206b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802070:	8b 40 48             	mov    0x48(%eax),%eax
}
  802073:	5d                   	pop    %ebp
  802074:	c3                   	ret    

00802075 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802075:	55                   	push   %ebp
  802076:	89 e5                	mov    %esp,%ebp
  802078:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80207b:	89 d0                	mov    %edx,%eax
  80207d:	c1 e8 16             	shr    $0x16,%eax
  802080:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802087:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80208c:	f6 c1 01             	test   $0x1,%cl
  80208f:	74 1d                	je     8020ae <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802091:	c1 ea 0c             	shr    $0xc,%edx
  802094:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80209b:	f6 c2 01             	test   $0x1,%dl
  80209e:	74 0e                	je     8020ae <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8020a0:	c1 ea 0c             	shr    $0xc,%edx
  8020a3:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8020aa:	ef 
  8020ab:	0f b7 c0             	movzwl %ax,%eax
}
  8020ae:	5d                   	pop    %ebp
  8020af:	c3                   	ret    

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
