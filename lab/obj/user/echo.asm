
obj/user/echo.debug:     file format elf32-i386


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
  80002c:	e8 b3 00 00 00       	call   8000e4 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 1c             	sub    $0x1c,%esp
  80003c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80003f:	8b 75 0c             	mov    0xc(%ebp),%esi
	int i, nflag;

	nflag = 0;
  800042:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
  800049:	83 ff 01             	cmp    $0x1,%edi
  80004c:	7f 07                	jg     800055 <umain+0x22>
		nflag = 1;
		argc--;
		argv++;
	}
	for (i = 1; i < argc; i++) {
  80004e:	bb 01 00 00 00       	mov    $0x1,%ebx
  800053:	eb 4c                	jmp    8000a1 <umain+0x6e>
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
  800055:	83 ec 08             	sub    $0x8,%esp
  800058:	68 a0 23 80 00       	push   $0x8023a0
  80005d:	ff 76 04             	pushl  0x4(%esi)
  800060:	e8 bc 01 00 00       	call   800221 <strcmp>
  800065:	83 c4 10             	add    $0x10,%esp
	nflag = 0;
  800068:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
  80006f:	85 c0                	test   %eax,%eax
  800071:	75 db                	jne    80004e <umain+0x1b>
		argc--;
  800073:	83 ef 01             	sub    $0x1,%edi
		argv++;
  800076:	83 c6 04             	add    $0x4,%esi
		nflag = 1;
  800079:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  800080:	eb cc                	jmp    80004e <umain+0x1b>
		if (i > 1)
			write(1, " ", 1);
		write(1, argv[i], strlen(argv[i]));
  800082:	83 ec 0c             	sub    $0xc,%esp
  800085:	ff 34 9e             	pushl  (%esi,%ebx,4)
  800088:	e8 b7 00 00 00       	call   800144 <strlen>
  80008d:	83 c4 0c             	add    $0xc,%esp
  800090:	50                   	push   %eax
  800091:	ff 34 9e             	pushl  (%esi,%ebx,4)
  800094:	6a 01                	push   $0x1
  800096:	e8 9e 0a 00 00       	call   800b39 <write>
	for (i = 1; i < argc; i++) {
  80009b:	83 c3 01             	add    $0x1,%ebx
  80009e:	83 c4 10             	add    $0x10,%esp
  8000a1:	39 df                	cmp    %ebx,%edi
  8000a3:	7e 1b                	jle    8000c0 <umain+0x8d>
		if (i > 1)
  8000a5:	83 fb 01             	cmp    $0x1,%ebx
  8000a8:	7e d8                	jle    800082 <umain+0x4f>
			write(1, " ", 1);
  8000aa:	83 ec 04             	sub    $0x4,%esp
  8000ad:	6a 01                	push   $0x1
  8000af:	68 a3 23 80 00       	push   $0x8023a3
  8000b4:	6a 01                	push   $0x1
  8000b6:	e8 7e 0a 00 00       	call   800b39 <write>
  8000bb:	83 c4 10             	add    $0x10,%esp
  8000be:	eb c2                	jmp    800082 <umain+0x4f>
	}
	if (!nflag)
  8000c0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8000c4:	74 08                	je     8000ce <umain+0x9b>
		write(1, "\n", 1);
}
  8000c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000c9:	5b                   	pop    %ebx
  8000ca:	5e                   	pop    %esi
  8000cb:	5f                   	pop    %edi
  8000cc:	5d                   	pop    %ebp
  8000cd:	c3                   	ret    
		write(1, "\n", 1);
  8000ce:	83 ec 04             	sub    $0x4,%esp
  8000d1:	6a 01                	push   $0x1
  8000d3:	68 e4 24 80 00       	push   $0x8024e4
  8000d8:	6a 01                	push   $0x1
  8000da:	e8 5a 0a 00 00       	call   800b39 <write>
  8000df:	83 c4 10             	add    $0x10,%esp
}
  8000e2:	eb e2                	jmp    8000c6 <umain+0x93>

008000e4 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000e4:	55                   	push   %ebp
  8000e5:	89 e5                	mov    %esp,%ebp
  8000e7:	56                   	push   %esi
  8000e8:	53                   	push   %ebx
  8000e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000ec:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
    thisenv = &envs[ENVX(sys_getenvid())];
  8000ef:	e8 42 04 00 00       	call   800536 <sys_getenvid>
  8000f4:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000f9:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000fc:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800101:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800106:	85 db                	test   %ebx,%ebx
  800108:	7e 07                	jle    800111 <libmain+0x2d>
		binaryname = argv[0];
  80010a:	8b 06                	mov    (%esi),%eax
  80010c:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800111:	83 ec 08             	sub    $0x8,%esp
  800114:	56                   	push   %esi
  800115:	53                   	push   %ebx
  800116:	e8 18 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80011b:	e8 0a 00 00 00       	call   80012a <exit>
}
  800120:	83 c4 10             	add    $0x10,%esp
  800123:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800126:	5b                   	pop    %ebx
  800127:	5e                   	pop    %esi
  800128:	5d                   	pop    %ebp
  800129:	c3                   	ret    

0080012a <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80012a:	55                   	push   %ebp
  80012b:	89 e5                	mov    %esp,%ebp
  80012d:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800130:	e8 25 08 00 00       	call   80095a <close_all>
	sys_env_destroy(0);
  800135:	83 ec 0c             	sub    $0xc,%esp
  800138:	6a 00                	push   $0x0
  80013a:	e8 b6 03 00 00       	call   8004f5 <sys_env_destroy>
}
  80013f:	83 c4 10             	add    $0x10,%esp
  800142:	c9                   	leave  
  800143:	c3                   	ret    

00800144 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800144:	55                   	push   %ebp
  800145:	89 e5                	mov    %esp,%ebp
  800147:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80014a:	b8 00 00 00 00       	mov    $0x0,%eax
  80014f:	eb 03                	jmp    800154 <strlen+0x10>
		n++;
  800151:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800154:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800158:	75 f7                	jne    800151 <strlen+0xd>
	return n;
}
  80015a:	5d                   	pop    %ebp
  80015b:	c3                   	ret    

0080015c <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80015c:	55                   	push   %ebp
  80015d:	89 e5                	mov    %esp,%ebp
  80015f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800162:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800165:	b8 00 00 00 00       	mov    $0x0,%eax
  80016a:	eb 03                	jmp    80016f <strnlen+0x13>
		n++;
  80016c:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80016f:	39 d0                	cmp    %edx,%eax
  800171:	74 06                	je     800179 <strnlen+0x1d>
  800173:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800177:	75 f3                	jne    80016c <strnlen+0x10>
	return n;
}
  800179:	5d                   	pop    %ebp
  80017a:	c3                   	ret    

0080017b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80017b:	55                   	push   %ebp
  80017c:	89 e5                	mov    %esp,%ebp
  80017e:	53                   	push   %ebx
  80017f:	8b 45 08             	mov    0x8(%ebp),%eax
  800182:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800185:	89 c2                	mov    %eax,%edx
  800187:	83 c1 01             	add    $0x1,%ecx
  80018a:	83 c2 01             	add    $0x1,%edx
  80018d:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800191:	88 5a ff             	mov    %bl,-0x1(%edx)
  800194:	84 db                	test   %bl,%bl
  800196:	75 ef                	jne    800187 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800198:	5b                   	pop    %ebx
  800199:	5d                   	pop    %ebp
  80019a:	c3                   	ret    

0080019b <strcat>:

char *
strcat(char *dst, const char *src)
{
  80019b:	55                   	push   %ebp
  80019c:	89 e5                	mov    %esp,%ebp
  80019e:	53                   	push   %ebx
  80019f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8001a2:	53                   	push   %ebx
  8001a3:	e8 9c ff ff ff       	call   800144 <strlen>
  8001a8:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  8001ab:	ff 75 0c             	pushl  0xc(%ebp)
  8001ae:	01 d8                	add    %ebx,%eax
  8001b0:	50                   	push   %eax
  8001b1:	e8 c5 ff ff ff       	call   80017b <strcpy>
	return dst;
}
  8001b6:	89 d8                	mov    %ebx,%eax
  8001b8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001bb:	c9                   	leave  
  8001bc:	c3                   	ret    

008001bd <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8001bd:	55                   	push   %ebp
  8001be:	89 e5                	mov    %esp,%ebp
  8001c0:	56                   	push   %esi
  8001c1:	53                   	push   %ebx
  8001c2:	8b 75 08             	mov    0x8(%ebp),%esi
  8001c5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001c8:	89 f3                	mov    %esi,%ebx
  8001ca:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8001cd:	89 f2                	mov    %esi,%edx
  8001cf:	eb 0f                	jmp    8001e0 <strncpy+0x23>
		*dst++ = *src;
  8001d1:	83 c2 01             	add    $0x1,%edx
  8001d4:	0f b6 01             	movzbl (%ecx),%eax
  8001d7:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8001da:	80 39 01             	cmpb   $0x1,(%ecx)
  8001dd:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  8001e0:	39 da                	cmp    %ebx,%edx
  8001e2:	75 ed                	jne    8001d1 <strncpy+0x14>
	}
	return ret;
}
  8001e4:	89 f0                	mov    %esi,%eax
  8001e6:	5b                   	pop    %ebx
  8001e7:	5e                   	pop    %esi
  8001e8:	5d                   	pop    %ebp
  8001e9:	c3                   	ret    

008001ea <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8001ea:	55                   	push   %ebp
  8001eb:	89 e5                	mov    %esp,%ebp
  8001ed:	56                   	push   %esi
  8001ee:	53                   	push   %ebx
  8001ef:	8b 75 08             	mov    0x8(%ebp),%esi
  8001f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001f5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8001f8:	89 f0                	mov    %esi,%eax
  8001fa:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8001fe:	85 c9                	test   %ecx,%ecx
  800200:	75 0b                	jne    80020d <strlcpy+0x23>
  800202:	eb 17                	jmp    80021b <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800204:	83 c2 01             	add    $0x1,%edx
  800207:	83 c0 01             	add    $0x1,%eax
  80020a:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  80020d:	39 d8                	cmp    %ebx,%eax
  80020f:	74 07                	je     800218 <strlcpy+0x2e>
  800211:	0f b6 0a             	movzbl (%edx),%ecx
  800214:	84 c9                	test   %cl,%cl
  800216:	75 ec                	jne    800204 <strlcpy+0x1a>
		*dst = '\0';
  800218:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80021b:	29 f0                	sub    %esi,%eax
}
  80021d:	5b                   	pop    %ebx
  80021e:	5e                   	pop    %esi
  80021f:	5d                   	pop    %ebp
  800220:	c3                   	ret    

00800221 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800221:	55                   	push   %ebp
  800222:	89 e5                	mov    %esp,%ebp
  800224:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800227:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80022a:	eb 06                	jmp    800232 <strcmp+0x11>
		p++, q++;
  80022c:	83 c1 01             	add    $0x1,%ecx
  80022f:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800232:	0f b6 01             	movzbl (%ecx),%eax
  800235:	84 c0                	test   %al,%al
  800237:	74 04                	je     80023d <strcmp+0x1c>
  800239:	3a 02                	cmp    (%edx),%al
  80023b:	74 ef                	je     80022c <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80023d:	0f b6 c0             	movzbl %al,%eax
  800240:	0f b6 12             	movzbl (%edx),%edx
  800243:	29 d0                	sub    %edx,%eax
}
  800245:	5d                   	pop    %ebp
  800246:	c3                   	ret    

00800247 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800247:	55                   	push   %ebp
  800248:	89 e5                	mov    %esp,%ebp
  80024a:	53                   	push   %ebx
  80024b:	8b 45 08             	mov    0x8(%ebp),%eax
  80024e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800251:	89 c3                	mov    %eax,%ebx
  800253:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800256:	eb 06                	jmp    80025e <strncmp+0x17>
		n--, p++, q++;
  800258:	83 c0 01             	add    $0x1,%eax
  80025b:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  80025e:	39 d8                	cmp    %ebx,%eax
  800260:	74 16                	je     800278 <strncmp+0x31>
  800262:	0f b6 08             	movzbl (%eax),%ecx
  800265:	84 c9                	test   %cl,%cl
  800267:	74 04                	je     80026d <strncmp+0x26>
  800269:	3a 0a                	cmp    (%edx),%cl
  80026b:	74 eb                	je     800258 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80026d:	0f b6 00             	movzbl (%eax),%eax
  800270:	0f b6 12             	movzbl (%edx),%edx
  800273:	29 d0                	sub    %edx,%eax
}
  800275:	5b                   	pop    %ebx
  800276:	5d                   	pop    %ebp
  800277:	c3                   	ret    
		return 0;
  800278:	b8 00 00 00 00       	mov    $0x0,%eax
  80027d:	eb f6                	jmp    800275 <strncmp+0x2e>

0080027f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80027f:	55                   	push   %ebp
  800280:	89 e5                	mov    %esp,%ebp
  800282:	8b 45 08             	mov    0x8(%ebp),%eax
  800285:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800289:	0f b6 10             	movzbl (%eax),%edx
  80028c:	84 d2                	test   %dl,%dl
  80028e:	74 09                	je     800299 <strchr+0x1a>
		if (*s == c)
  800290:	38 ca                	cmp    %cl,%dl
  800292:	74 0a                	je     80029e <strchr+0x1f>
	for (; *s; s++)
  800294:	83 c0 01             	add    $0x1,%eax
  800297:	eb f0                	jmp    800289 <strchr+0xa>
			return (char *) s;
	return 0;
  800299:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80029e:	5d                   	pop    %ebp
  80029f:	c3                   	ret    

008002a0 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8002a0:	55                   	push   %ebp
  8002a1:	89 e5                	mov    %esp,%ebp
  8002a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8002a6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8002aa:	eb 03                	jmp    8002af <strfind+0xf>
  8002ac:	83 c0 01             	add    $0x1,%eax
  8002af:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8002b2:	38 ca                	cmp    %cl,%dl
  8002b4:	74 04                	je     8002ba <strfind+0x1a>
  8002b6:	84 d2                	test   %dl,%dl
  8002b8:	75 f2                	jne    8002ac <strfind+0xc>
			break;
	return (char *) s;
}
  8002ba:	5d                   	pop    %ebp
  8002bb:	c3                   	ret    

008002bc <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8002bc:	55                   	push   %ebp
  8002bd:	89 e5                	mov    %esp,%ebp
  8002bf:	57                   	push   %edi
  8002c0:	56                   	push   %esi
  8002c1:	53                   	push   %ebx
  8002c2:	8b 7d 08             	mov    0x8(%ebp),%edi
  8002c5:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8002c8:	85 c9                	test   %ecx,%ecx
  8002ca:	74 13                	je     8002df <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8002cc:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8002d2:	75 05                	jne    8002d9 <memset+0x1d>
  8002d4:	f6 c1 03             	test   $0x3,%cl
  8002d7:	74 0d                	je     8002e6 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8002d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002dc:	fc                   	cld    
  8002dd:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8002df:	89 f8                	mov    %edi,%eax
  8002e1:	5b                   	pop    %ebx
  8002e2:	5e                   	pop    %esi
  8002e3:	5f                   	pop    %edi
  8002e4:	5d                   	pop    %ebp
  8002e5:	c3                   	ret    
		c &= 0xFF;
  8002e6:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8002ea:	89 d3                	mov    %edx,%ebx
  8002ec:	c1 e3 08             	shl    $0x8,%ebx
  8002ef:	89 d0                	mov    %edx,%eax
  8002f1:	c1 e0 18             	shl    $0x18,%eax
  8002f4:	89 d6                	mov    %edx,%esi
  8002f6:	c1 e6 10             	shl    $0x10,%esi
  8002f9:	09 f0                	or     %esi,%eax
  8002fb:	09 c2                	or     %eax,%edx
  8002fd:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  8002ff:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800302:	89 d0                	mov    %edx,%eax
  800304:	fc                   	cld    
  800305:	f3 ab                	rep stos %eax,%es:(%edi)
  800307:	eb d6                	jmp    8002df <memset+0x23>

00800309 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800309:	55                   	push   %ebp
  80030a:	89 e5                	mov    %esp,%ebp
  80030c:	57                   	push   %edi
  80030d:	56                   	push   %esi
  80030e:	8b 45 08             	mov    0x8(%ebp),%eax
  800311:	8b 75 0c             	mov    0xc(%ebp),%esi
  800314:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800317:	39 c6                	cmp    %eax,%esi
  800319:	73 35                	jae    800350 <memmove+0x47>
  80031b:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  80031e:	39 c2                	cmp    %eax,%edx
  800320:	76 2e                	jbe    800350 <memmove+0x47>
		s += n;
		d += n;
  800322:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800325:	89 d6                	mov    %edx,%esi
  800327:	09 fe                	or     %edi,%esi
  800329:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80032f:	74 0c                	je     80033d <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800331:	83 ef 01             	sub    $0x1,%edi
  800334:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800337:	fd                   	std    
  800338:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80033a:	fc                   	cld    
  80033b:	eb 21                	jmp    80035e <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80033d:	f6 c1 03             	test   $0x3,%cl
  800340:	75 ef                	jne    800331 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800342:	83 ef 04             	sub    $0x4,%edi
  800345:	8d 72 fc             	lea    -0x4(%edx),%esi
  800348:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  80034b:	fd                   	std    
  80034c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80034e:	eb ea                	jmp    80033a <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800350:	89 f2                	mov    %esi,%edx
  800352:	09 c2                	or     %eax,%edx
  800354:	f6 c2 03             	test   $0x3,%dl
  800357:	74 09                	je     800362 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800359:	89 c7                	mov    %eax,%edi
  80035b:	fc                   	cld    
  80035c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  80035e:	5e                   	pop    %esi
  80035f:	5f                   	pop    %edi
  800360:	5d                   	pop    %ebp
  800361:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800362:	f6 c1 03             	test   $0x3,%cl
  800365:	75 f2                	jne    800359 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800367:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  80036a:	89 c7                	mov    %eax,%edi
  80036c:	fc                   	cld    
  80036d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80036f:	eb ed                	jmp    80035e <memmove+0x55>

00800371 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800371:	55                   	push   %ebp
  800372:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800374:	ff 75 10             	pushl  0x10(%ebp)
  800377:	ff 75 0c             	pushl  0xc(%ebp)
  80037a:	ff 75 08             	pushl  0x8(%ebp)
  80037d:	e8 87 ff ff ff       	call   800309 <memmove>
}
  800382:	c9                   	leave  
  800383:	c3                   	ret    

00800384 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800384:	55                   	push   %ebp
  800385:	89 e5                	mov    %esp,%ebp
  800387:	56                   	push   %esi
  800388:	53                   	push   %ebx
  800389:	8b 45 08             	mov    0x8(%ebp),%eax
  80038c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80038f:	89 c6                	mov    %eax,%esi
  800391:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800394:	39 f0                	cmp    %esi,%eax
  800396:	74 1c                	je     8003b4 <memcmp+0x30>
		if (*s1 != *s2)
  800398:	0f b6 08             	movzbl (%eax),%ecx
  80039b:	0f b6 1a             	movzbl (%edx),%ebx
  80039e:	38 d9                	cmp    %bl,%cl
  8003a0:	75 08                	jne    8003aa <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8003a2:	83 c0 01             	add    $0x1,%eax
  8003a5:	83 c2 01             	add    $0x1,%edx
  8003a8:	eb ea                	jmp    800394 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  8003aa:	0f b6 c1             	movzbl %cl,%eax
  8003ad:	0f b6 db             	movzbl %bl,%ebx
  8003b0:	29 d8                	sub    %ebx,%eax
  8003b2:	eb 05                	jmp    8003b9 <memcmp+0x35>
	}

	return 0;
  8003b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8003b9:	5b                   	pop    %ebx
  8003ba:	5e                   	pop    %esi
  8003bb:	5d                   	pop    %ebp
  8003bc:	c3                   	ret    

008003bd <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8003bd:	55                   	push   %ebp
  8003be:	89 e5                	mov    %esp,%ebp
  8003c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8003c6:	89 c2                	mov    %eax,%edx
  8003c8:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8003cb:	39 d0                	cmp    %edx,%eax
  8003cd:	73 09                	jae    8003d8 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  8003cf:	38 08                	cmp    %cl,(%eax)
  8003d1:	74 05                	je     8003d8 <memfind+0x1b>
	for (; s < ends; s++)
  8003d3:	83 c0 01             	add    $0x1,%eax
  8003d6:	eb f3                	jmp    8003cb <memfind+0xe>
			break;
	return (void *) s;
}
  8003d8:	5d                   	pop    %ebp
  8003d9:	c3                   	ret    

008003da <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8003da:	55                   	push   %ebp
  8003db:	89 e5                	mov    %esp,%ebp
  8003dd:	57                   	push   %edi
  8003de:	56                   	push   %esi
  8003df:	53                   	push   %ebx
  8003e0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003e3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8003e6:	eb 03                	jmp    8003eb <strtol+0x11>
		s++;
  8003e8:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  8003eb:	0f b6 01             	movzbl (%ecx),%eax
  8003ee:	3c 20                	cmp    $0x20,%al
  8003f0:	74 f6                	je     8003e8 <strtol+0xe>
  8003f2:	3c 09                	cmp    $0x9,%al
  8003f4:	74 f2                	je     8003e8 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  8003f6:	3c 2b                	cmp    $0x2b,%al
  8003f8:	74 2e                	je     800428 <strtol+0x4e>
	int neg = 0;
  8003fa:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  8003ff:	3c 2d                	cmp    $0x2d,%al
  800401:	74 2f                	je     800432 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800403:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800409:	75 05                	jne    800410 <strtol+0x36>
  80040b:	80 39 30             	cmpb   $0x30,(%ecx)
  80040e:	74 2c                	je     80043c <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800410:	85 db                	test   %ebx,%ebx
  800412:	75 0a                	jne    80041e <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800414:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800419:	80 39 30             	cmpb   $0x30,(%ecx)
  80041c:	74 28                	je     800446 <strtol+0x6c>
		base = 10;
  80041e:	b8 00 00 00 00       	mov    $0x0,%eax
  800423:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800426:	eb 50                	jmp    800478 <strtol+0x9e>
		s++;
  800428:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  80042b:	bf 00 00 00 00       	mov    $0x0,%edi
  800430:	eb d1                	jmp    800403 <strtol+0x29>
		s++, neg = 1;
  800432:	83 c1 01             	add    $0x1,%ecx
  800435:	bf 01 00 00 00       	mov    $0x1,%edi
  80043a:	eb c7                	jmp    800403 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80043c:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800440:	74 0e                	je     800450 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800442:	85 db                	test   %ebx,%ebx
  800444:	75 d8                	jne    80041e <strtol+0x44>
		s++, base = 8;
  800446:	83 c1 01             	add    $0x1,%ecx
  800449:	bb 08 00 00 00       	mov    $0x8,%ebx
  80044e:	eb ce                	jmp    80041e <strtol+0x44>
		s += 2, base = 16;
  800450:	83 c1 02             	add    $0x2,%ecx
  800453:	bb 10 00 00 00       	mov    $0x10,%ebx
  800458:	eb c4                	jmp    80041e <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  80045a:	8d 72 9f             	lea    -0x61(%edx),%esi
  80045d:	89 f3                	mov    %esi,%ebx
  80045f:	80 fb 19             	cmp    $0x19,%bl
  800462:	77 29                	ja     80048d <strtol+0xb3>
			dig = *s - 'a' + 10;
  800464:	0f be d2             	movsbl %dl,%edx
  800467:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  80046a:	3b 55 10             	cmp    0x10(%ebp),%edx
  80046d:	7d 30                	jge    80049f <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  80046f:	83 c1 01             	add    $0x1,%ecx
  800472:	0f af 45 10          	imul   0x10(%ebp),%eax
  800476:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800478:	0f b6 11             	movzbl (%ecx),%edx
  80047b:	8d 72 d0             	lea    -0x30(%edx),%esi
  80047e:	89 f3                	mov    %esi,%ebx
  800480:	80 fb 09             	cmp    $0x9,%bl
  800483:	77 d5                	ja     80045a <strtol+0x80>
			dig = *s - '0';
  800485:	0f be d2             	movsbl %dl,%edx
  800488:	83 ea 30             	sub    $0x30,%edx
  80048b:	eb dd                	jmp    80046a <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  80048d:	8d 72 bf             	lea    -0x41(%edx),%esi
  800490:	89 f3                	mov    %esi,%ebx
  800492:	80 fb 19             	cmp    $0x19,%bl
  800495:	77 08                	ja     80049f <strtol+0xc5>
			dig = *s - 'A' + 10;
  800497:	0f be d2             	movsbl %dl,%edx
  80049a:	83 ea 37             	sub    $0x37,%edx
  80049d:	eb cb                	jmp    80046a <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  80049f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004a3:	74 05                	je     8004aa <strtol+0xd0>
		*endptr = (char *) s;
  8004a5:	8b 75 0c             	mov    0xc(%ebp),%esi
  8004a8:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  8004aa:	89 c2                	mov    %eax,%edx
  8004ac:	f7 da                	neg    %edx
  8004ae:	85 ff                	test   %edi,%edi
  8004b0:	0f 45 c2             	cmovne %edx,%eax
}
  8004b3:	5b                   	pop    %ebx
  8004b4:	5e                   	pop    %esi
  8004b5:	5f                   	pop    %edi
  8004b6:	5d                   	pop    %ebp
  8004b7:	c3                   	ret    

008004b8 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8004b8:	55                   	push   %ebp
  8004b9:	89 e5                	mov    %esp,%ebp
  8004bb:	57                   	push   %edi
  8004bc:	56                   	push   %esi
  8004bd:	53                   	push   %ebx
	asm volatile("int %1\n"
  8004be:	b8 00 00 00 00       	mov    $0x0,%eax
  8004c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8004c6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004c9:	89 c3                	mov    %eax,%ebx
  8004cb:	89 c7                	mov    %eax,%edi
  8004cd:	89 c6                	mov    %eax,%esi
  8004cf:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8004d1:	5b                   	pop    %ebx
  8004d2:	5e                   	pop    %esi
  8004d3:	5f                   	pop    %edi
  8004d4:	5d                   	pop    %ebp
  8004d5:	c3                   	ret    

008004d6 <sys_cgetc>:

int
sys_cgetc(void)
{
  8004d6:	55                   	push   %ebp
  8004d7:	89 e5                	mov    %esp,%ebp
  8004d9:	57                   	push   %edi
  8004da:	56                   	push   %esi
  8004db:	53                   	push   %ebx
	asm volatile("int %1\n"
  8004dc:	ba 00 00 00 00       	mov    $0x0,%edx
  8004e1:	b8 01 00 00 00       	mov    $0x1,%eax
  8004e6:	89 d1                	mov    %edx,%ecx
  8004e8:	89 d3                	mov    %edx,%ebx
  8004ea:	89 d7                	mov    %edx,%edi
  8004ec:	89 d6                	mov    %edx,%esi
  8004ee:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8004f0:	5b                   	pop    %ebx
  8004f1:	5e                   	pop    %esi
  8004f2:	5f                   	pop    %edi
  8004f3:	5d                   	pop    %ebp
  8004f4:	c3                   	ret    

008004f5 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8004f5:	55                   	push   %ebp
  8004f6:	89 e5                	mov    %esp,%ebp
  8004f8:	57                   	push   %edi
  8004f9:	56                   	push   %esi
  8004fa:	53                   	push   %ebx
  8004fb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8004fe:	b9 00 00 00 00       	mov    $0x0,%ecx
  800503:	8b 55 08             	mov    0x8(%ebp),%edx
  800506:	b8 03 00 00 00       	mov    $0x3,%eax
  80050b:	89 cb                	mov    %ecx,%ebx
  80050d:	89 cf                	mov    %ecx,%edi
  80050f:	89 ce                	mov    %ecx,%esi
  800511:	cd 30                	int    $0x30
	if(check && ret > 0)
  800513:	85 c0                	test   %eax,%eax
  800515:	7f 08                	jg     80051f <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800517:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80051a:	5b                   	pop    %ebx
  80051b:	5e                   	pop    %esi
  80051c:	5f                   	pop    %edi
  80051d:	5d                   	pop    %ebp
  80051e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80051f:	83 ec 0c             	sub    $0xc,%esp
  800522:	50                   	push   %eax
  800523:	6a 03                	push   $0x3
  800525:	68 af 23 80 00       	push   $0x8023af
  80052a:	6a 23                	push   $0x23
  80052c:	68 cc 23 80 00       	push   $0x8023cc
  800531:	e8 ad 13 00 00       	call   8018e3 <_panic>

00800536 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800536:	55                   	push   %ebp
  800537:	89 e5                	mov    %esp,%ebp
  800539:	57                   	push   %edi
  80053a:	56                   	push   %esi
  80053b:	53                   	push   %ebx
	asm volatile("int %1\n"
  80053c:	ba 00 00 00 00       	mov    $0x0,%edx
  800541:	b8 02 00 00 00       	mov    $0x2,%eax
  800546:	89 d1                	mov    %edx,%ecx
  800548:	89 d3                	mov    %edx,%ebx
  80054a:	89 d7                	mov    %edx,%edi
  80054c:	89 d6                	mov    %edx,%esi
  80054e:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800550:	5b                   	pop    %ebx
  800551:	5e                   	pop    %esi
  800552:	5f                   	pop    %edi
  800553:	5d                   	pop    %ebp
  800554:	c3                   	ret    

00800555 <sys_yield>:

void
sys_yield(void)
{
  800555:	55                   	push   %ebp
  800556:	89 e5                	mov    %esp,%ebp
  800558:	57                   	push   %edi
  800559:	56                   	push   %esi
  80055a:	53                   	push   %ebx
	asm volatile("int %1\n"
  80055b:	ba 00 00 00 00       	mov    $0x0,%edx
  800560:	b8 0b 00 00 00       	mov    $0xb,%eax
  800565:	89 d1                	mov    %edx,%ecx
  800567:	89 d3                	mov    %edx,%ebx
  800569:	89 d7                	mov    %edx,%edi
  80056b:	89 d6                	mov    %edx,%esi
  80056d:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80056f:	5b                   	pop    %ebx
  800570:	5e                   	pop    %esi
  800571:	5f                   	pop    %edi
  800572:	5d                   	pop    %ebp
  800573:	c3                   	ret    

00800574 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800574:	55                   	push   %ebp
  800575:	89 e5                	mov    %esp,%ebp
  800577:	57                   	push   %edi
  800578:	56                   	push   %esi
  800579:	53                   	push   %ebx
  80057a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80057d:	be 00 00 00 00       	mov    $0x0,%esi
  800582:	8b 55 08             	mov    0x8(%ebp),%edx
  800585:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800588:	b8 04 00 00 00       	mov    $0x4,%eax
  80058d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800590:	89 f7                	mov    %esi,%edi
  800592:	cd 30                	int    $0x30
	if(check && ret > 0)
  800594:	85 c0                	test   %eax,%eax
  800596:	7f 08                	jg     8005a0 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800598:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80059b:	5b                   	pop    %ebx
  80059c:	5e                   	pop    %esi
  80059d:	5f                   	pop    %edi
  80059e:	5d                   	pop    %ebp
  80059f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8005a0:	83 ec 0c             	sub    $0xc,%esp
  8005a3:	50                   	push   %eax
  8005a4:	6a 04                	push   $0x4
  8005a6:	68 af 23 80 00       	push   $0x8023af
  8005ab:	6a 23                	push   $0x23
  8005ad:	68 cc 23 80 00       	push   $0x8023cc
  8005b2:	e8 2c 13 00 00       	call   8018e3 <_panic>

008005b7 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8005b7:	55                   	push   %ebp
  8005b8:	89 e5                	mov    %esp,%ebp
  8005ba:	57                   	push   %edi
  8005bb:	56                   	push   %esi
  8005bc:	53                   	push   %ebx
  8005bd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8005c0:	8b 55 08             	mov    0x8(%ebp),%edx
  8005c3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005c6:	b8 05 00 00 00       	mov    $0x5,%eax
  8005cb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8005ce:	8b 7d 14             	mov    0x14(%ebp),%edi
  8005d1:	8b 75 18             	mov    0x18(%ebp),%esi
  8005d4:	cd 30                	int    $0x30
	if(check && ret > 0)
  8005d6:	85 c0                	test   %eax,%eax
  8005d8:	7f 08                	jg     8005e2 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8005da:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8005dd:	5b                   	pop    %ebx
  8005de:	5e                   	pop    %esi
  8005df:	5f                   	pop    %edi
  8005e0:	5d                   	pop    %ebp
  8005e1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8005e2:	83 ec 0c             	sub    $0xc,%esp
  8005e5:	50                   	push   %eax
  8005e6:	6a 05                	push   $0x5
  8005e8:	68 af 23 80 00       	push   $0x8023af
  8005ed:	6a 23                	push   $0x23
  8005ef:	68 cc 23 80 00       	push   $0x8023cc
  8005f4:	e8 ea 12 00 00       	call   8018e3 <_panic>

008005f9 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8005f9:	55                   	push   %ebp
  8005fa:	89 e5                	mov    %esp,%ebp
  8005fc:	57                   	push   %edi
  8005fd:	56                   	push   %esi
  8005fe:	53                   	push   %ebx
  8005ff:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800602:	bb 00 00 00 00       	mov    $0x0,%ebx
  800607:	8b 55 08             	mov    0x8(%ebp),%edx
  80060a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80060d:	b8 06 00 00 00       	mov    $0x6,%eax
  800612:	89 df                	mov    %ebx,%edi
  800614:	89 de                	mov    %ebx,%esi
  800616:	cd 30                	int    $0x30
	if(check && ret > 0)
  800618:	85 c0                	test   %eax,%eax
  80061a:	7f 08                	jg     800624 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80061c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80061f:	5b                   	pop    %ebx
  800620:	5e                   	pop    %esi
  800621:	5f                   	pop    %edi
  800622:	5d                   	pop    %ebp
  800623:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800624:	83 ec 0c             	sub    $0xc,%esp
  800627:	50                   	push   %eax
  800628:	6a 06                	push   $0x6
  80062a:	68 af 23 80 00       	push   $0x8023af
  80062f:	6a 23                	push   $0x23
  800631:	68 cc 23 80 00       	push   $0x8023cc
  800636:	e8 a8 12 00 00       	call   8018e3 <_panic>

0080063b <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80063b:	55                   	push   %ebp
  80063c:	89 e5                	mov    %esp,%ebp
  80063e:	57                   	push   %edi
  80063f:	56                   	push   %esi
  800640:	53                   	push   %ebx
  800641:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800644:	bb 00 00 00 00       	mov    $0x0,%ebx
  800649:	8b 55 08             	mov    0x8(%ebp),%edx
  80064c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80064f:	b8 08 00 00 00       	mov    $0x8,%eax
  800654:	89 df                	mov    %ebx,%edi
  800656:	89 de                	mov    %ebx,%esi
  800658:	cd 30                	int    $0x30
	if(check && ret > 0)
  80065a:	85 c0                	test   %eax,%eax
  80065c:	7f 08                	jg     800666 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80065e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800661:	5b                   	pop    %ebx
  800662:	5e                   	pop    %esi
  800663:	5f                   	pop    %edi
  800664:	5d                   	pop    %ebp
  800665:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800666:	83 ec 0c             	sub    $0xc,%esp
  800669:	50                   	push   %eax
  80066a:	6a 08                	push   $0x8
  80066c:	68 af 23 80 00       	push   $0x8023af
  800671:	6a 23                	push   $0x23
  800673:	68 cc 23 80 00       	push   $0x8023cc
  800678:	e8 66 12 00 00       	call   8018e3 <_panic>

0080067d <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80067d:	55                   	push   %ebp
  80067e:	89 e5                	mov    %esp,%ebp
  800680:	57                   	push   %edi
  800681:	56                   	push   %esi
  800682:	53                   	push   %ebx
  800683:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800686:	bb 00 00 00 00       	mov    $0x0,%ebx
  80068b:	8b 55 08             	mov    0x8(%ebp),%edx
  80068e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800691:	b8 09 00 00 00       	mov    $0x9,%eax
  800696:	89 df                	mov    %ebx,%edi
  800698:	89 de                	mov    %ebx,%esi
  80069a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80069c:	85 c0                	test   %eax,%eax
  80069e:	7f 08                	jg     8006a8 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8006a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006a3:	5b                   	pop    %ebx
  8006a4:	5e                   	pop    %esi
  8006a5:	5f                   	pop    %edi
  8006a6:	5d                   	pop    %ebp
  8006a7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8006a8:	83 ec 0c             	sub    $0xc,%esp
  8006ab:	50                   	push   %eax
  8006ac:	6a 09                	push   $0x9
  8006ae:	68 af 23 80 00       	push   $0x8023af
  8006b3:	6a 23                	push   $0x23
  8006b5:	68 cc 23 80 00       	push   $0x8023cc
  8006ba:	e8 24 12 00 00       	call   8018e3 <_panic>

008006bf <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8006bf:	55                   	push   %ebp
  8006c0:	89 e5                	mov    %esp,%ebp
  8006c2:	57                   	push   %edi
  8006c3:	56                   	push   %esi
  8006c4:	53                   	push   %ebx
  8006c5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8006c8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8006d0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006d3:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006d8:	89 df                	mov    %ebx,%edi
  8006da:	89 de                	mov    %ebx,%esi
  8006dc:	cd 30                	int    $0x30
	if(check && ret > 0)
  8006de:	85 c0                	test   %eax,%eax
  8006e0:	7f 08                	jg     8006ea <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8006e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006e5:	5b                   	pop    %ebx
  8006e6:	5e                   	pop    %esi
  8006e7:	5f                   	pop    %edi
  8006e8:	5d                   	pop    %ebp
  8006e9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8006ea:	83 ec 0c             	sub    $0xc,%esp
  8006ed:	50                   	push   %eax
  8006ee:	6a 0a                	push   $0xa
  8006f0:	68 af 23 80 00       	push   $0x8023af
  8006f5:	6a 23                	push   $0x23
  8006f7:	68 cc 23 80 00       	push   $0x8023cc
  8006fc:	e8 e2 11 00 00       	call   8018e3 <_panic>

00800701 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800701:	55                   	push   %ebp
  800702:	89 e5                	mov    %esp,%ebp
  800704:	57                   	push   %edi
  800705:	56                   	push   %esi
  800706:	53                   	push   %ebx
	asm volatile("int %1\n"
  800707:	8b 55 08             	mov    0x8(%ebp),%edx
  80070a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80070d:	b8 0c 00 00 00       	mov    $0xc,%eax
  800712:	be 00 00 00 00       	mov    $0x0,%esi
  800717:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80071a:	8b 7d 14             	mov    0x14(%ebp),%edi
  80071d:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80071f:	5b                   	pop    %ebx
  800720:	5e                   	pop    %esi
  800721:	5f                   	pop    %edi
  800722:	5d                   	pop    %ebp
  800723:	c3                   	ret    

00800724 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800724:	55                   	push   %ebp
  800725:	89 e5                	mov    %esp,%ebp
  800727:	57                   	push   %edi
  800728:	56                   	push   %esi
  800729:	53                   	push   %ebx
  80072a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80072d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800732:	8b 55 08             	mov    0x8(%ebp),%edx
  800735:	b8 0d 00 00 00       	mov    $0xd,%eax
  80073a:	89 cb                	mov    %ecx,%ebx
  80073c:	89 cf                	mov    %ecx,%edi
  80073e:	89 ce                	mov    %ecx,%esi
  800740:	cd 30                	int    $0x30
	if(check && ret > 0)
  800742:	85 c0                	test   %eax,%eax
  800744:	7f 08                	jg     80074e <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800746:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800749:	5b                   	pop    %ebx
  80074a:	5e                   	pop    %esi
  80074b:	5f                   	pop    %edi
  80074c:	5d                   	pop    %ebp
  80074d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80074e:	83 ec 0c             	sub    $0xc,%esp
  800751:	50                   	push   %eax
  800752:	6a 0d                	push   $0xd
  800754:	68 af 23 80 00       	push   $0x8023af
  800759:	6a 23                	push   $0x23
  80075b:	68 cc 23 80 00       	push   $0x8023cc
  800760:	e8 7e 11 00 00       	call   8018e3 <_panic>

00800765 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800765:	55                   	push   %ebp
  800766:	89 e5                	mov    %esp,%ebp
  800768:	57                   	push   %edi
  800769:	56                   	push   %esi
  80076a:	53                   	push   %ebx
	asm volatile("int %1\n"
  80076b:	ba 00 00 00 00       	mov    $0x0,%edx
  800770:	b8 0e 00 00 00       	mov    $0xe,%eax
  800775:	89 d1                	mov    %edx,%ecx
  800777:	89 d3                	mov    %edx,%ebx
  800779:	89 d7                	mov    %edx,%edi
  80077b:	89 d6                	mov    %edx,%esi
  80077d:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  80077f:	5b                   	pop    %ebx
  800780:	5e                   	pop    %esi
  800781:	5f                   	pop    %edi
  800782:	5d                   	pop    %ebp
  800783:	c3                   	ret    

00800784 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800784:	55                   	push   %ebp
  800785:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800787:	8b 45 08             	mov    0x8(%ebp),%eax
  80078a:	05 00 00 00 30       	add    $0x30000000,%eax
  80078f:	c1 e8 0c             	shr    $0xc,%eax
}
  800792:	5d                   	pop    %ebp
  800793:	c3                   	ret    

00800794 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800794:	55                   	push   %ebp
  800795:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800797:	8b 45 08             	mov    0x8(%ebp),%eax
  80079a:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80079f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8007a4:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8007a9:	5d                   	pop    %ebp
  8007aa:	c3                   	ret    

008007ab <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8007ab:	55                   	push   %ebp
  8007ac:	89 e5                	mov    %esp,%ebp
  8007ae:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007b1:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8007b6:	89 c2                	mov    %eax,%edx
  8007b8:	c1 ea 16             	shr    $0x16,%edx
  8007bb:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8007c2:	f6 c2 01             	test   $0x1,%dl
  8007c5:	74 2a                	je     8007f1 <fd_alloc+0x46>
  8007c7:	89 c2                	mov    %eax,%edx
  8007c9:	c1 ea 0c             	shr    $0xc,%edx
  8007cc:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8007d3:	f6 c2 01             	test   $0x1,%dl
  8007d6:	74 19                	je     8007f1 <fd_alloc+0x46>
  8007d8:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8007dd:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8007e2:	75 d2                	jne    8007b6 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8007e4:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8007ea:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8007ef:	eb 07                	jmp    8007f8 <fd_alloc+0x4d>
			*fd_store = fd;
  8007f1:	89 01                	mov    %eax,(%ecx)
			return 0;
  8007f3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8007f8:	5d                   	pop    %ebp
  8007f9:	c3                   	ret    

008007fa <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8007fa:	55                   	push   %ebp
  8007fb:	89 e5                	mov    %esp,%ebp
  8007fd:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800800:	83 f8 1f             	cmp    $0x1f,%eax
  800803:	77 36                	ja     80083b <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800805:	c1 e0 0c             	shl    $0xc,%eax
  800808:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80080d:	89 c2                	mov    %eax,%edx
  80080f:	c1 ea 16             	shr    $0x16,%edx
  800812:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800819:	f6 c2 01             	test   $0x1,%dl
  80081c:	74 24                	je     800842 <fd_lookup+0x48>
  80081e:	89 c2                	mov    %eax,%edx
  800820:	c1 ea 0c             	shr    $0xc,%edx
  800823:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80082a:	f6 c2 01             	test   $0x1,%dl
  80082d:	74 1a                	je     800849 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80082f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800832:	89 02                	mov    %eax,(%edx)
	return 0;
  800834:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800839:	5d                   	pop    %ebp
  80083a:	c3                   	ret    
		return -E_INVAL;
  80083b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800840:	eb f7                	jmp    800839 <fd_lookup+0x3f>
		return -E_INVAL;
  800842:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800847:	eb f0                	jmp    800839 <fd_lookup+0x3f>
  800849:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80084e:	eb e9                	jmp    800839 <fd_lookup+0x3f>

00800850 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800850:	55                   	push   %ebp
  800851:	89 e5                	mov    %esp,%ebp
  800853:	83 ec 08             	sub    $0x8,%esp
  800856:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800859:	ba 58 24 80 00       	mov    $0x802458,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  80085e:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800863:	39 08                	cmp    %ecx,(%eax)
  800865:	74 33                	je     80089a <dev_lookup+0x4a>
  800867:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  80086a:	8b 02                	mov    (%edx),%eax
  80086c:	85 c0                	test   %eax,%eax
  80086e:	75 f3                	jne    800863 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800870:	a1 08 40 80 00       	mov    0x804008,%eax
  800875:	8b 40 48             	mov    0x48(%eax),%eax
  800878:	83 ec 04             	sub    $0x4,%esp
  80087b:	51                   	push   %ecx
  80087c:	50                   	push   %eax
  80087d:	68 dc 23 80 00       	push   $0x8023dc
  800882:	e8 37 11 00 00       	call   8019be <cprintf>
	*dev = 0;
  800887:	8b 45 0c             	mov    0xc(%ebp),%eax
  80088a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800890:	83 c4 10             	add    $0x10,%esp
  800893:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800898:	c9                   	leave  
  800899:	c3                   	ret    
			*dev = devtab[i];
  80089a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80089d:	89 01                	mov    %eax,(%ecx)
			return 0;
  80089f:	b8 00 00 00 00       	mov    $0x0,%eax
  8008a4:	eb f2                	jmp    800898 <dev_lookup+0x48>

008008a6 <fd_close>:
{
  8008a6:	55                   	push   %ebp
  8008a7:	89 e5                	mov    %esp,%ebp
  8008a9:	57                   	push   %edi
  8008aa:	56                   	push   %esi
  8008ab:	53                   	push   %ebx
  8008ac:	83 ec 1c             	sub    $0x1c,%esp
  8008af:	8b 75 08             	mov    0x8(%ebp),%esi
  8008b2:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8008b5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8008b8:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8008b9:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8008bf:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8008c2:	50                   	push   %eax
  8008c3:	e8 32 ff ff ff       	call   8007fa <fd_lookup>
  8008c8:	89 c3                	mov    %eax,%ebx
  8008ca:	83 c4 08             	add    $0x8,%esp
  8008cd:	85 c0                	test   %eax,%eax
  8008cf:	78 05                	js     8008d6 <fd_close+0x30>
	    || fd != fd2)
  8008d1:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8008d4:	74 16                	je     8008ec <fd_close+0x46>
		return (must_exist ? r : 0);
  8008d6:	89 f8                	mov    %edi,%eax
  8008d8:	84 c0                	test   %al,%al
  8008da:	b8 00 00 00 00       	mov    $0x0,%eax
  8008df:	0f 44 d8             	cmove  %eax,%ebx
}
  8008e2:	89 d8                	mov    %ebx,%eax
  8008e4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008e7:	5b                   	pop    %ebx
  8008e8:	5e                   	pop    %esi
  8008e9:	5f                   	pop    %edi
  8008ea:	5d                   	pop    %ebp
  8008eb:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8008ec:	83 ec 08             	sub    $0x8,%esp
  8008ef:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8008f2:	50                   	push   %eax
  8008f3:	ff 36                	pushl  (%esi)
  8008f5:	e8 56 ff ff ff       	call   800850 <dev_lookup>
  8008fa:	89 c3                	mov    %eax,%ebx
  8008fc:	83 c4 10             	add    $0x10,%esp
  8008ff:	85 c0                	test   %eax,%eax
  800901:	78 15                	js     800918 <fd_close+0x72>
		if (dev->dev_close)
  800903:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800906:	8b 40 10             	mov    0x10(%eax),%eax
  800909:	85 c0                	test   %eax,%eax
  80090b:	74 1b                	je     800928 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  80090d:	83 ec 0c             	sub    $0xc,%esp
  800910:	56                   	push   %esi
  800911:	ff d0                	call   *%eax
  800913:	89 c3                	mov    %eax,%ebx
  800915:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800918:	83 ec 08             	sub    $0x8,%esp
  80091b:	56                   	push   %esi
  80091c:	6a 00                	push   $0x0
  80091e:	e8 d6 fc ff ff       	call   8005f9 <sys_page_unmap>
	return r;
  800923:	83 c4 10             	add    $0x10,%esp
  800926:	eb ba                	jmp    8008e2 <fd_close+0x3c>
			r = 0;
  800928:	bb 00 00 00 00       	mov    $0x0,%ebx
  80092d:	eb e9                	jmp    800918 <fd_close+0x72>

0080092f <close>:

int
close(int fdnum)
{
  80092f:	55                   	push   %ebp
  800930:	89 e5                	mov    %esp,%ebp
  800932:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800935:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800938:	50                   	push   %eax
  800939:	ff 75 08             	pushl  0x8(%ebp)
  80093c:	e8 b9 fe ff ff       	call   8007fa <fd_lookup>
  800941:	83 c4 08             	add    $0x8,%esp
  800944:	85 c0                	test   %eax,%eax
  800946:	78 10                	js     800958 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  800948:	83 ec 08             	sub    $0x8,%esp
  80094b:	6a 01                	push   $0x1
  80094d:	ff 75 f4             	pushl  -0xc(%ebp)
  800950:	e8 51 ff ff ff       	call   8008a6 <fd_close>
  800955:	83 c4 10             	add    $0x10,%esp
}
  800958:	c9                   	leave  
  800959:	c3                   	ret    

0080095a <close_all>:

void
close_all(void)
{
  80095a:	55                   	push   %ebp
  80095b:	89 e5                	mov    %esp,%ebp
  80095d:	53                   	push   %ebx
  80095e:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800961:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800966:	83 ec 0c             	sub    $0xc,%esp
  800969:	53                   	push   %ebx
  80096a:	e8 c0 ff ff ff       	call   80092f <close>
	for (i = 0; i < MAXFD; i++)
  80096f:	83 c3 01             	add    $0x1,%ebx
  800972:	83 c4 10             	add    $0x10,%esp
  800975:	83 fb 20             	cmp    $0x20,%ebx
  800978:	75 ec                	jne    800966 <close_all+0xc>
}
  80097a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80097d:	c9                   	leave  
  80097e:	c3                   	ret    

0080097f <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80097f:	55                   	push   %ebp
  800980:	89 e5                	mov    %esp,%ebp
  800982:	57                   	push   %edi
  800983:	56                   	push   %esi
  800984:	53                   	push   %ebx
  800985:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800988:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80098b:	50                   	push   %eax
  80098c:	ff 75 08             	pushl  0x8(%ebp)
  80098f:	e8 66 fe ff ff       	call   8007fa <fd_lookup>
  800994:	89 c3                	mov    %eax,%ebx
  800996:	83 c4 08             	add    $0x8,%esp
  800999:	85 c0                	test   %eax,%eax
  80099b:	0f 88 81 00 00 00    	js     800a22 <dup+0xa3>
		return r;
	close(newfdnum);
  8009a1:	83 ec 0c             	sub    $0xc,%esp
  8009a4:	ff 75 0c             	pushl  0xc(%ebp)
  8009a7:	e8 83 ff ff ff       	call   80092f <close>

	newfd = INDEX2FD(newfdnum);
  8009ac:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009af:	c1 e6 0c             	shl    $0xc,%esi
  8009b2:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8009b8:	83 c4 04             	add    $0x4,%esp
  8009bb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8009be:	e8 d1 fd ff ff       	call   800794 <fd2data>
  8009c3:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8009c5:	89 34 24             	mov    %esi,(%esp)
  8009c8:	e8 c7 fd ff ff       	call   800794 <fd2data>
  8009cd:	83 c4 10             	add    $0x10,%esp
  8009d0:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8009d2:	89 d8                	mov    %ebx,%eax
  8009d4:	c1 e8 16             	shr    $0x16,%eax
  8009d7:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8009de:	a8 01                	test   $0x1,%al
  8009e0:	74 11                	je     8009f3 <dup+0x74>
  8009e2:	89 d8                	mov    %ebx,%eax
  8009e4:	c1 e8 0c             	shr    $0xc,%eax
  8009e7:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8009ee:	f6 c2 01             	test   $0x1,%dl
  8009f1:	75 39                	jne    800a2c <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8009f3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8009f6:	89 d0                	mov    %edx,%eax
  8009f8:	c1 e8 0c             	shr    $0xc,%eax
  8009fb:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800a02:	83 ec 0c             	sub    $0xc,%esp
  800a05:	25 07 0e 00 00       	and    $0xe07,%eax
  800a0a:	50                   	push   %eax
  800a0b:	56                   	push   %esi
  800a0c:	6a 00                	push   $0x0
  800a0e:	52                   	push   %edx
  800a0f:	6a 00                	push   $0x0
  800a11:	e8 a1 fb ff ff       	call   8005b7 <sys_page_map>
  800a16:	89 c3                	mov    %eax,%ebx
  800a18:	83 c4 20             	add    $0x20,%esp
  800a1b:	85 c0                	test   %eax,%eax
  800a1d:	78 31                	js     800a50 <dup+0xd1>
		goto err;

	return newfdnum;
  800a1f:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  800a22:	89 d8                	mov    %ebx,%eax
  800a24:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800a27:	5b                   	pop    %ebx
  800a28:	5e                   	pop    %esi
  800a29:	5f                   	pop    %edi
  800a2a:	5d                   	pop    %ebp
  800a2b:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800a2c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800a33:	83 ec 0c             	sub    $0xc,%esp
  800a36:	25 07 0e 00 00       	and    $0xe07,%eax
  800a3b:	50                   	push   %eax
  800a3c:	57                   	push   %edi
  800a3d:	6a 00                	push   $0x0
  800a3f:	53                   	push   %ebx
  800a40:	6a 00                	push   $0x0
  800a42:	e8 70 fb ff ff       	call   8005b7 <sys_page_map>
  800a47:	89 c3                	mov    %eax,%ebx
  800a49:	83 c4 20             	add    $0x20,%esp
  800a4c:	85 c0                	test   %eax,%eax
  800a4e:	79 a3                	jns    8009f3 <dup+0x74>
	sys_page_unmap(0, newfd);
  800a50:	83 ec 08             	sub    $0x8,%esp
  800a53:	56                   	push   %esi
  800a54:	6a 00                	push   $0x0
  800a56:	e8 9e fb ff ff       	call   8005f9 <sys_page_unmap>
	sys_page_unmap(0, nva);
  800a5b:	83 c4 08             	add    $0x8,%esp
  800a5e:	57                   	push   %edi
  800a5f:	6a 00                	push   $0x0
  800a61:	e8 93 fb ff ff       	call   8005f9 <sys_page_unmap>
	return r;
  800a66:	83 c4 10             	add    $0x10,%esp
  800a69:	eb b7                	jmp    800a22 <dup+0xa3>

00800a6b <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800a6b:	55                   	push   %ebp
  800a6c:	89 e5                	mov    %esp,%ebp
  800a6e:	53                   	push   %ebx
  800a6f:	83 ec 14             	sub    $0x14,%esp
  800a72:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800a75:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800a78:	50                   	push   %eax
  800a79:	53                   	push   %ebx
  800a7a:	e8 7b fd ff ff       	call   8007fa <fd_lookup>
  800a7f:	83 c4 08             	add    $0x8,%esp
  800a82:	85 c0                	test   %eax,%eax
  800a84:	78 3f                	js     800ac5 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800a86:	83 ec 08             	sub    $0x8,%esp
  800a89:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800a8c:	50                   	push   %eax
  800a8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a90:	ff 30                	pushl  (%eax)
  800a92:	e8 b9 fd ff ff       	call   800850 <dev_lookup>
  800a97:	83 c4 10             	add    $0x10,%esp
  800a9a:	85 c0                	test   %eax,%eax
  800a9c:	78 27                	js     800ac5 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800a9e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800aa1:	8b 42 08             	mov    0x8(%edx),%eax
  800aa4:	83 e0 03             	and    $0x3,%eax
  800aa7:	83 f8 01             	cmp    $0x1,%eax
  800aaa:	74 1e                	je     800aca <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  800aac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800aaf:	8b 40 08             	mov    0x8(%eax),%eax
  800ab2:	85 c0                	test   %eax,%eax
  800ab4:	74 35                	je     800aeb <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  800ab6:	83 ec 04             	sub    $0x4,%esp
  800ab9:	ff 75 10             	pushl  0x10(%ebp)
  800abc:	ff 75 0c             	pushl  0xc(%ebp)
  800abf:	52                   	push   %edx
  800ac0:	ff d0                	call   *%eax
  800ac2:	83 c4 10             	add    $0x10,%esp
}
  800ac5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ac8:	c9                   	leave  
  800ac9:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800aca:	a1 08 40 80 00       	mov    0x804008,%eax
  800acf:	8b 40 48             	mov    0x48(%eax),%eax
  800ad2:	83 ec 04             	sub    $0x4,%esp
  800ad5:	53                   	push   %ebx
  800ad6:	50                   	push   %eax
  800ad7:	68 1d 24 80 00       	push   $0x80241d
  800adc:	e8 dd 0e 00 00       	call   8019be <cprintf>
		return -E_INVAL;
  800ae1:	83 c4 10             	add    $0x10,%esp
  800ae4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ae9:	eb da                	jmp    800ac5 <read+0x5a>
		return -E_NOT_SUPP;
  800aeb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800af0:	eb d3                	jmp    800ac5 <read+0x5a>

00800af2 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800af2:	55                   	push   %ebp
  800af3:	89 e5                	mov    %esp,%ebp
  800af5:	57                   	push   %edi
  800af6:	56                   	push   %esi
  800af7:	53                   	push   %ebx
  800af8:	83 ec 0c             	sub    $0xc,%esp
  800afb:	8b 7d 08             	mov    0x8(%ebp),%edi
  800afe:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800b01:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b06:	39 f3                	cmp    %esi,%ebx
  800b08:	73 25                	jae    800b2f <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800b0a:	83 ec 04             	sub    $0x4,%esp
  800b0d:	89 f0                	mov    %esi,%eax
  800b0f:	29 d8                	sub    %ebx,%eax
  800b11:	50                   	push   %eax
  800b12:	89 d8                	mov    %ebx,%eax
  800b14:	03 45 0c             	add    0xc(%ebp),%eax
  800b17:	50                   	push   %eax
  800b18:	57                   	push   %edi
  800b19:	e8 4d ff ff ff       	call   800a6b <read>
		if (m < 0)
  800b1e:	83 c4 10             	add    $0x10,%esp
  800b21:	85 c0                	test   %eax,%eax
  800b23:	78 08                	js     800b2d <readn+0x3b>
			return m;
		if (m == 0)
  800b25:	85 c0                	test   %eax,%eax
  800b27:	74 06                	je     800b2f <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  800b29:	01 c3                	add    %eax,%ebx
  800b2b:	eb d9                	jmp    800b06 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800b2d:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  800b2f:	89 d8                	mov    %ebx,%eax
  800b31:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b34:	5b                   	pop    %ebx
  800b35:	5e                   	pop    %esi
  800b36:	5f                   	pop    %edi
  800b37:	5d                   	pop    %ebp
  800b38:	c3                   	ret    

00800b39 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800b39:	55                   	push   %ebp
  800b3a:	89 e5                	mov    %esp,%ebp
  800b3c:	53                   	push   %ebx
  800b3d:	83 ec 14             	sub    $0x14,%esp
  800b40:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800b43:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800b46:	50                   	push   %eax
  800b47:	53                   	push   %ebx
  800b48:	e8 ad fc ff ff       	call   8007fa <fd_lookup>
  800b4d:	83 c4 08             	add    $0x8,%esp
  800b50:	85 c0                	test   %eax,%eax
  800b52:	78 3a                	js     800b8e <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800b54:	83 ec 08             	sub    $0x8,%esp
  800b57:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800b5a:	50                   	push   %eax
  800b5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b5e:	ff 30                	pushl  (%eax)
  800b60:	e8 eb fc ff ff       	call   800850 <dev_lookup>
  800b65:	83 c4 10             	add    $0x10,%esp
  800b68:	85 c0                	test   %eax,%eax
  800b6a:	78 22                	js     800b8e <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800b6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b6f:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800b73:	74 1e                	je     800b93 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800b75:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b78:	8b 52 0c             	mov    0xc(%edx),%edx
  800b7b:	85 d2                	test   %edx,%edx
  800b7d:	74 35                	je     800bb4 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  800b7f:	83 ec 04             	sub    $0x4,%esp
  800b82:	ff 75 10             	pushl  0x10(%ebp)
  800b85:	ff 75 0c             	pushl  0xc(%ebp)
  800b88:	50                   	push   %eax
  800b89:	ff d2                	call   *%edx
  800b8b:	83 c4 10             	add    $0x10,%esp
}
  800b8e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b91:	c9                   	leave  
  800b92:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800b93:	a1 08 40 80 00       	mov    0x804008,%eax
  800b98:	8b 40 48             	mov    0x48(%eax),%eax
  800b9b:	83 ec 04             	sub    $0x4,%esp
  800b9e:	53                   	push   %ebx
  800b9f:	50                   	push   %eax
  800ba0:	68 39 24 80 00       	push   $0x802439
  800ba5:	e8 14 0e 00 00       	call   8019be <cprintf>
		return -E_INVAL;
  800baa:	83 c4 10             	add    $0x10,%esp
  800bad:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800bb2:	eb da                	jmp    800b8e <write+0x55>
		return -E_NOT_SUPP;
  800bb4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800bb9:	eb d3                	jmp    800b8e <write+0x55>

00800bbb <seek>:

int
seek(int fdnum, off_t offset)
{
  800bbb:	55                   	push   %ebp
  800bbc:	89 e5                	mov    %esp,%ebp
  800bbe:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800bc1:	8d 45 fc             	lea    -0x4(%ebp),%eax
  800bc4:	50                   	push   %eax
  800bc5:	ff 75 08             	pushl  0x8(%ebp)
  800bc8:	e8 2d fc ff ff       	call   8007fa <fd_lookup>
  800bcd:	83 c4 08             	add    $0x8,%esp
  800bd0:	85 c0                	test   %eax,%eax
  800bd2:	78 0e                	js     800be2 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  800bd4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bd7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bda:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  800bdd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800be2:	c9                   	leave  
  800be3:	c3                   	ret    

00800be4 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800be4:	55                   	push   %ebp
  800be5:	89 e5                	mov    %esp,%ebp
  800be7:	53                   	push   %ebx
  800be8:	83 ec 14             	sub    $0x14,%esp
  800beb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800bee:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800bf1:	50                   	push   %eax
  800bf2:	53                   	push   %ebx
  800bf3:	e8 02 fc ff ff       	call   8007fa <fd_lookup>
  800bf8:	83 c4 08             	add    $0x8,%esp
  800bfb:	85 c0                	test   %eax,%eax
  800bfd:	78 37                	js     800c36 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800bff:	83 ec 08             	sub    $0x8,%esp
  800c02:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800c05:	50                   	push   %eax
  800c06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c09:	ff 30                	pushl  (%eax)
  800c0b:	e8 40 fc ff ff       	call   800850 <dev_lookup>
  800c10:	83 c4 10             	add    $0x10,%esp
  800c13:	85 c0                	test   %eax,%eax
  800c15:	78 1f                	js     800c36 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800c17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c1a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800c1e:	74 1b                	je     800c3b <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  800c20:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c23:	8b 52 18             	mov    0x18(%edx),%edx
  800c26:	85 d2                	test   %edx,%edx
  800c28:	74 32                	je     800c5c <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  800c2a:	83 ec 08             	sub    $0x8,%esp
  800c2d:	ff 75 0c             	pushl  0xc(%ebp)
  800c30:	50                   	push   %eax
  800c31:	ff d2                	call   *%edx
  800c33:	83 c4 10             	add    $0x10,%esp
}
  800c36:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c39:	c9                   	leave  
  800c3a:	c3                   	ret    
			thisenv->env_id, fdnum);
  800c3b:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800c40:	8b 40 48             	mov    0x48(%eax),%eax
  800c43:	83 ec 04             	sub    $0x4,%esp
  800c46:	53                   	push   %ebx
  800c47:	50                   	push   %eax
  800c48:	68 fc 23 80 00       	push   $0x8023fc
  800c4d:	e8 6c 0d 00 00       	call   8019be <cprintf>
		return -E_INVAL;
  800c52:	83 c4 10             	add    $0x10,%esp
  800c55:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c5a:	eb da                	jmp    800c36 <ftruncate+0x52>
		return -E_NOT_SUPP;
  800c5c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800c61:	eb d3                	jmp    800c36 <ftruncate+0x52>

00800c63 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800c63:	55                   	push   %ebp
  800c64:	89 e5                	mov    %esp,%ebp
  800c66:	53                   	push   %ebx
  800c67:	83 ec 14             	sub    $0x14,%esp
  800c6a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800c6d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800c70:	50                   	push   %eax
  800c71:	ff 75 08             	pushl  0x8(%ebp)
  800c74:	e8 81 fb ff ff       	call   8007fa <fd_lookup>
  800c79:	83 c4 08             	add    $0x8,%esp
  800c7c:	85 c0                	test   %eax,%eax
  800c7e:	78 4b                	js     800ccb <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800c80:	83 ec 08             	sub    $0x8,%esp
  800c83:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800c86:	50                   	push   %eax
  800c87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c8a:	ff 30                	pushl  (%eax)
  800c8c:	e8 bf fb ff ff       	call   800850 <dev_lookup>
  800c91:	83 c4 10             	add    $0x10,%esp
  800c94:	85 c0                	test   %eax,%eax
  800c96:	78 33                	js     800ccb <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  800c98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c9b:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  800c9f:	74 2f                	je     800cd0 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800ca1:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  800ca4:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  800cab:	00 00 00 
	stat->st_isdir = 0;
  800cae:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800cb5:	00 00 00 
	stat->st_dev = dev;
  800cb8:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  800cbe:	83 ec 08             	sub    $0x8,%esp
  800cc1:	53                   	push   %ebx
  800cc2:	ff 75 f0             	pushl  -0x10(%ebp)
  800cc5:	ff 50 14             	call   *0x14(%eax)
  800cc8:	83 c4 10             	add    $0x10,%esp
}
  800ccb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800cce:	c9                   	leave  
  800ccf:	c3                   	ret    
		return -E_NOT_SUPP;
  800cd0:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800cd5:	eb f4                	jmp    800ccb <fstat+0x68>

00800cd7 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800cd7:	55                   	push   %ebp
  800cd8:	89 e5                	mov    %esp,%ebp
  800cda:	56                   	push   %esi
  800cdb:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800cdc:	83 ec 08             	sub    $0x8,%esp
  800cdf:	6a 00                	push   $0x0
  800ce1:	ff 75 08             	pushl  0x8(%ebp)
  800ce4:	e8 26 02 00 00       	call   800f0f <open>
  800ce9:	89 c3                	mov    %eax,%ebx
  800ceb:	83 c4 10             	add    $0x10,%esp
  800cee:	85 c0                	test   %eax,%eax
  800cf0:	78 1b                	js     800d0d <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  800cf2:	83 ec 08             	sub    $0x8,%esp
  800cf5:	ff 75 0c             	pushl  0xc(%ebp)
  800cf8:	50                   	push   %eax
  800cf9:	e8 65 ff ff ff       	call   800c63 <fstat>
  800cfe:	89 c6                	mov    %eax,%esi
	close(fd);
  800d00:	89 1c 24             	mov    %ebx,(%esp)
  800d03:	e8 27 fc ff ff       	call   80092f <close>
	return r;
  800d08:	83 c4 10             	add    $0x10,%esp
  800d0b:	89 f3                	mov    %esi,%ebx
}
  800d0d:	89 d8                	mov    %ebx,%eax
  800d0f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d12:	5b                   	pop    %ebx
  800d13:	5e                   	pop    %esi
  800d14:	5d                   	pop    %ebp
  800d15:	c3                   	ret    

00800d16 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800d16:	55                   	push   %ebp
  800d17:	89 e5                	mov    %esp,%ebp
  800d19:	56                   	push   %esi
  800d1a:	53                   	push   %ebx
  800d1b:	89 c6                	mov    %eax,%esi
  800d1d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  800d1f:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  800d26:	74 27                	je     800d4f <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800d28:	6a 07                	push   $0x7
  800d2a:	68 00 50 80 00       	push   $0x805000
  800d2f:	56                   	push   %esi
  800d30:	ff 35 00 40 80 00    	pushl  0x804000
  800d36:	e8 52 13 00 00       	call   80208d <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  800d3b:	83 c4 0c             	add    $0xc,%esp
  800d3e:	6a 00                	push   $0x0
  800d40:	53                   	push   %ebx
  800d41:	6a 00                	push   $0x0
  800d43:	e8 dc 12 00 00       	call   802024 <ipc_recv>
}
  800d48:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d4b:	5b                   	pop    %ebx
  800d4c:	5e                   	pop    %esi
  800d4d:	5d                   	pop    %ebp
  800d4e:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800d4f:	83 ec 0c             	sub    $0xc,%esp
  800d52:	6a 01                	push   $0x1
  800d54:	e8 8d 13 00 00       	call   8020e6 <ipc_find_env>
  800d59:	a3 00 40 80 00       	mov    %eax,0x804000
  800d5e:	83 c4 10             	add    $0x10,%esp
  800d61:	eb c5                	jmp    800d28 <fsipc+0x12>

00800d63 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  800d63:	55                   	push   %ebp
  800d64:	89 e5                	mov    %esp,%ebp
  800d66:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800d69:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6c:	8b 40 0c             	mov    0xc(%eax),%eax
  800d6f:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  800d74:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d77:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  800d7c:	ba 00 00 00 00       	mov    $0x0,%edx
  800d81:	b8 02 00 00 00       	mov    $0x2,%eax
  800d86:	e8 8b ff ff ff       	call   800d16 <fsipc>
}
  800d8b:	c9                   	leave  
  800d8c:	c3                   	ret    

00800d8d <devfile_flush>:
{
  800d8d:	55                   	push   %ebp
  800d8e:	89 e5                	mov    %esp,%ebp
  800d90:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800d93:	8b 45 08             	mov    0x8(%ebp),%eax
  800d96:	8b 40 0c             	mov    0xc(%eax),%eax
  800d99:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800d9e:	ba 00 00 00 00       	mov    $0x0,%edx
  800da3:	b8 06 00 00 00       	mov    $0x6,%eax
  800da8:	e8 69 ff ff ff       	call   800d16 <fsipc>
}
  800dad:	c9                   	leave  
  800dae:	c3                   	ret    

00800daf <devfile_stat>:
{
  800daf:	55                   	push   %ebp
  800db0:	89 e5                	mov    %esp,%ebp
  800db2:	53                   	push   %ebx
  800db3:	83 ec 04             	sub    $0x4,%esp
  800db6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800db9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbc:	8b 40 0c             	mov    0xc(%eax),%eax
  800dbf:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800dc4:	ba 00 00 00 00       	mov    $0x0,%edx
  800dc9:	b8 05 00 00 00       	mov    $0x5,%eax
  800dce:	e8 43 ff ff ff       	call   800d16 <fsipc>
  800dd3:	85 c0                	test   %eax,%eax
  800dd5:	78 2c                	js     800e03 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800dd7:	83 ec 08             	sub    $0x8,%esp
  800dda:	68 00 50 80 00       	push   $0x805000
  800ddf:	53                   	push   %ebx
  800de0:	e8 96 f3 ff ff       	call   80017b <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800de5:	a1 80 50 80 00       	mov    0x805080,%eax
  800dea:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800df0:	a1 84 50 80 00       	mov    0x805084,%eax
  800df5:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800dfb:	83 c4 10             	add    $0x10,%esp
  800dfe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e03:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800e06:	c9                   	leave  
  800e07:	c3                   	ret    

00800e08 <devfile_write>:
{
  800e08:	55                   	push   %ebp
  800e09:	89 e5                	mov    %esp,%ebp
  800e0b:	53                   	push   %ebx
  800e0c:	83 ec 04             	sub    $0x4,%esp
  800e0f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  800e12:	8b 45 08             	mov    0x8(%ebp),%eax
  800e15:	8b 40 0c             	mov    0xc(%eax),%eax
  800e18:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  800e1d:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  800e23:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  800e29:	77 30                	ja     800e5b <devfile_write+0x53>
	memmove(fsipcbuf.write.req_buf, buf, n);
  800e2b:	83 ec 04             	sub    $0x4,%esp
  800e2e:	53                   	push   %ebx
  800e2f:	ff 75 0c             	pushl  0xc(%ebp)
  800e32:	68 08 50 80 00       	push   $0x805008
  800e37:	e8 cd f4 ff ff       	call   800309 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  800e3c:	ba 00 00 00 00       	mov    $0x0,%edx
  800e41:	b8 04 00 00 00       	mov    $0x4,%eax
  800e46:	e8 cb fe ff ff       	call   800d16 <fsipc>
  800e4b:	83 c4 10             	add    $0x10,%esp
  800e4e:	85 c0                	test   %eax,%eax
  800e50:	78 04                	js     800e56 <devfile_write+0x4e>
	assert(r <= n);
  800e52:	39 d8                	cmp    %ebx,%eax
  800e54:	77 1e                	ja     800e74 <devfile_write+0x6c>
}
  800e56:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800e59:	c9                   	leave  
  800e5a:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  800e5b:	68 6c 24 80 00       	push   $0x80246c
  800e60:	68 99 24 80 00       	push   $0x802499
  800e65:	68 94 00 00 00       	push   $0x94
  800e6a:	68 ae 24 80 00       	push   $0x8024ae
  800e6f:	e8 6f 0a 00 00       	call   8018e3 <_panic>
	assert(r <= n);
  800e74:	68 b9 24 80 00       	push   $0x8024b9
  800e79:	68 99 24 80 00       	push   $0x802499
  800e7e:	68 98 00 00 00       	push   $0x98
  800e83:	68 ae 24 80 00       	push   $0x8024ae
  800e88:	e8 56 0a 00 00       	call   8018e3 <_panic>

00800e8d <devfile_read>:
{
  800e8d:	55                   	push   %ebp
  800e8e:	89 e5                	mov    %esp,%ebp
  800e90:	56                   	push   %esi
  800e91:	53                   	push   %ebx
  800e92:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800e95:	8b 45 08             	mov    0x8(%ebp),%eax
  800e98:	8b 40 0c             	mov    0xc(%eax),%eax
  800e9b:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800ea0:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800ea6:	ba 00 00 00 00       	mov    $0x0,%edx
  800eab:	b8 03 00 00 00       	mov    $0x3,%eax
  800eb0:	e8 61 fe ff ff       	call   800d16 <fsipc>
  800eb5:	89 c3                	mov    %eax,%ebx
  800eb7:	85 c0                	test   %eax,%eax
  800eb9:	78 1f                	js     800eda <devfile_read+0x4d>
	assert(r <= n);
  800ebb:	39 f0                	cmp    %esi,%eax
  800ebd:	77 24                	ja     800ee3 <devfile_read+0x56>
	assert(r <= PGSIZE);
  800ebf:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800ec4:	7f 33                	jg     800ef9 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800ec6:	83 ec 04             	sub    $0x4,%esp
  800ec9:	50                   	push   %eax
  800eca:	68 00 50 80 00       	push   $0x805000
  800ecf:	ff 75 0c             	pushl  0xc(%ebp)
  800ed2:	e8 32 f4 ff ff       	call   800309 <memmove>
	return r;
  800ed7:	83 c4 10             	add    $0x10,%esp
}
  800eda:	89 d8                	mov    %ebx,%eax
  800edc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800edf:	5b                   	pop    %ebx
  800ee0:	5e                   	pop    %esi
  800ee1:	5d                   	pop    %ebp
  800ee2:	c3                   	ret    
	assert(r <= n);
  800ee3:	68 b9 24 80 00       	push   $0x8024b9
  800ee8:	68 99 24 80 00       	push   $0x802499
  800eed:	6a 7c                	push   $0x7c
  800eef:	68 ae 24 80 00       	push   $0x8024ae
  800ef4:	e8 ea 09 00 00       	call   8018e3 <_panic>
	assert(r <= PGSIZE);
  800ef9:	68 c0 24 80 00       	push   $0x8024c0
  800efe:	68 99 24 80 00       	push   $0x802499
  800f03:	6a 7d                	push   $0x7d
  800f05:	68 ae 24 80 00       	push   $0x8024ae
  800f0a:	e8 d4 09 00 00       	call   8018e3 <_panic>

00800f0f <open>:
{
  800f0f:	55                   	push   %ebp
  800f10:	89 e5                	mov    %esp,%ebp
  800f12:	56                   	push   %esi
  800f13:	53                   	push   %ebx
  800f14:	83 ec 1c             	sub    $0x1c,%esp
  800f17:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800f1a:	56                   	push   %esi
  800f1b:	e8 24 f2 ff ff       	call   800144 <strlen>
  800f20:	83 c4 10             	add    $0x10,%esp
  800f23:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800f28:	7f 6c                	jg     800f96 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  800f2a:	83 ec 0c             	sub    $0xc,%esp
  800f2d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f30:	50                   	push   %eax
  800f31:	e8 75 f8 ff ff       	call   8007ab <fd_alloc>
  800f36:	89 c3                	mov    %eax,%ebx
  800f38:	83 c4 10             	add    $0x10,%esp
  800f3b:	85 c0                	test   %eax,%eax
  800f3d:	78 3c                	js     800f7b <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  800f3f:	83 ec 08             	sub    $0x8,%esp
  800f42:	56                   	push   %esi
  800f43:	68 00 50 80 00       	push   $0x805000
  800f48:	e8 2e f2 ff ff       	call   80017b <strcpy>
	fsipcbuf.open.req_omode = mode;
  800f4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f50:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800f55:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f58:	b8 01 00 00 00       	mov    $0x1,%eax
  800f5d:	e8 b4 fd ff ff       	call   800d16 <fsipc>
  800f62:	89 c3                	mov    %eax,%ebx
  800f64:	83 c4 10             	add    $0x10,%esp
  800f67:	85 c0                	test   %eax,%eax
  800f69:	78 19                	js     800f84 <open+0x75>
	return fd2num(fd);
  800f6b:	83 ec 0c             	sub    $0xc,%esp
  800f6e:	ff 75 f4             	pushl  -0xc(%ebp)
  800f71:	e8 0e f8 ff ff       	call   800784 <fd2num>
  800f76:	89 c3                	mov    %eax,%ebx
  800f78:	83 c4 10             	add    $0x10,%esp
}
  800f7b:	89 d8                	mov    %ebx,%eax
  800f7d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f80:	5b                   	pop    %ebx
  800f81:	5e                   	pop    %esi
  800f82:	5d                   	pop    %ebp
  800f83:	c3                   	ret    
		fd_close(fd, 0);
  800f84:	83 ec 08             	sub    $0x8,%esp
  800f87:	6a 00                	push   $0x0
  800f89:	ff 75 f4             	pushl  -0xc(%ebp)
  800f8c:	e8 15 f9 ff ff       	call   8008a6 <fd_close>
		return r;
  800f91:	83 c4 10             	add    $0x10,%esp
  800f94:	eb e5                	jmp    800f7b <open+0x6c>
		return -E_BAD_PATH;
  800f96:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800f9b:	eb de                	jmp    800f7b <open+0x6c>

00800f9d <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800f9d:	55                   	push   %ebp
  800f9e:	89 e5                	mov    %esp,%ebp
  800fa0:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800fa3:	ba 00 00 00 00       	mov    $0x0,%edx
  800fa8:	b8 08 00 00 00       	mov    $0x8,%eax
  800fad:	e8 64 fd ff ff       	call   800d16 <fsipc>
}
  800fb2:	c9                   	leave  
  800fb3:	c3                   	ret    

00800fb4 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800fb4:	55                   	push   %ebp
  800fb5:	89 e5                	mov    %esp,%ebp
  800fb7:	56                   	push   %esi
  800fb8:	53                   	push   %ebx
  800fb9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800fbc:	83 ec 0c             	sub    $0xc,%esp
  800fbf:	ff 75 08             	pushl  0x8(%ebp)
  800fc2:	e8 cd f7 ff ff       	call   800794 <fd2data>
  800fc7:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  800fc9:	83 c4 08             	add    $0x8,%esp
  800fcc:	68 cc 24 80 00       	push   $0x8024cc
  800fd1:	53                   	push   %ebx
  800fd2:	e8 a4 f1 ff ff       	call   80017b <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  800fd7:	8b 46 04             	mov    0x4(%esi),%eax
  800fda:	2b 06                	sub    (%esi),%eax
  800fdc:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  800fe2:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800fe9:	00 00 00 
	stat->st_dev = &devpipe;
  800fec:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  800ff3:	30 80 00 
	return 0;
}
  800ff6:	b8 00 00 00 00       	mov    $0x0,%eax
  800ffb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ffe:	5b                   	pop    %ebx
  800fff:	5e                   	pop    %esi
  801000:	5d                   	pop    %ebp
  801001:	c3                   	ret    

00801002 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801002:	55                   	push   %ebp
  801003:	89 e5                	mov    %esp,%ebp
  801005:	53                   	push   %ebx
  801006:	83 ec 0c             	sub    $0xc,%esp
  801009:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80100c:	53                   	push   %ebx
  80100d:	6a 00                	push   $0x0
  80100f:	e8 e5 f5 ff ff       	call   8005f9 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801014:	89 1c 24             	mov    %ebx,(%esp)
  801017:	e8 78 f7 ff ff       	call   800794 <fd2data>
  80101c:	83 c4 08             	add    $0x8,%esp
  80101f:	50                   	push   %eax
  801020:	6a 00                	push   $0x0
  801022:	e8 d2 f5 ff ff       	call   8005f9 <sys_page_unmap>
}
  801027:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80102a:	c9                   	leave  
  80102b:	c3                   	ret    

0080102c <_pipeisclosed>:
{
  80102c:	55                   	push   %ebp
  80102d:	89 e5                	mov    %esp,%ebp
  80102f:	57                   	push   %edi
  801030:	56                   	push   %esi
  801031:	53                   	push   %ebx
  801032:	83 ec 1c             	sub    $0x1c,%esp
  801035:	89 c7                	mov    %eax,%edi
  801037:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801039:	a1 08 40 80 00       	mov    0x804008,%eax
  80103e:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801041:	83 ec 0c             	sub    $0xc,%esp
  801044:	57                   	push   %edi
  801045:	e8 d5 10 00 00       	call   80211f <pageref>
  80104a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80104d:	89 34 24             	mov    %esi,(%esp)
  801050:	e8 ca 10 00 00       	call   80211f <pageref>
		nn = thisenv->env_runs;
  801055:	8b 15 08 40 80 00    	mov    0x804008,%edx
  80105b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80105e:	83 c4 10             	add    $0x10,%esp
  801061:	39 cb                	cmp    %ecx,%ebx
  801063:	74 1b                	je     801080 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801065:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801068:	75 cf                	jne    801039 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80106a:	8b 42 58             	mov    0x58(%edx),%eax
  80106d:	6a 01                	push   $0x1
  80106f:	50                   	push   %eax
  801070:	53                   	push   %ebx
  801071:	68 d3 24 80 00       	push   $0x8024d3
  801076:	e8 43 09 00 00       	call   8019be <cprintf>
  80107b:	83 c4 10             	add    $0x10,%esp
  80107e:	eb b9                	jmp    801039 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801080:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801083:	0f 94 c0             	sete   %al
  801086:	0f b6 c0             	movzbl %al,%eax
}
  801089:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80108c:	5b                   	pop    %ebx
  80108d:	5e                   	pop    %esi
  80108e:	5f                   	pop    %edi
  80108f:	5d                   	pop    %ebp
  801090:	c3                   	ret    

00801091 <devpipe_write>:
{
  801091:	55                   	push   %ebp
  801092:	89 e5                	mov    %esp,%ebp
  801094:	57                   	push   %edi
  801095:	56                   	push   %esi
  801096:	53                   	push   %ebx
  801097:	83 ec 28             	sub    $0x28,%esp
  80109a:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80109d:	56                   	push   %esi
  80109e:	e8 f1 f6 ff ff       	call   800794 <fd2data>
  8010a3:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8010a5:	83 c4 10             	add    $0x10,%esp
  8010a8:	bf 00 00 00 00       	mov    $0x0,%edi
  8010ad:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8010b0:	74 4f                	je     801101 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8010b2:	8b 43 04             	mov    0x4(%ebx),%eax
  8010b5:	8b 0b                	mov    (%ebx),%ecx
  8010b7:	8d 51 20             	lea    0x20(%ecx),%edx
  8010ba:	39 d0                	cmp    %edx,%eax
  8010bc:	72 14                	jb     8010d2 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8010be:	89 da                	mov    %ebx,%edx
  8010c0:	89 f0                	mov    %esi,%eax
  8010c2:	e8 65 ff ff ff       	call   80102c <_pipeisclosed>
  8010c7:	85 c0                	test   %eax,%eax
  8010c9:	75 3a                	jne    801105 <devpipe_write+0x74>
			sys_yield();
  8010cb:	e8 85 f4 ff ff       	call   800555 <sys_yield>
  8010d0:	eb e0                	jmp    8010b2 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8010d2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010d5:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8010d9:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8010dc:	89 c2                	mov    %eax,%edx
  8010de:	c1 fa 1f             	sar    $0x1f,%edx
  8010e1:	89 d1                	mov    %edx,%ecx
  8010e3:	c1 e9 1b             	shr    $0x1b,%ecx
  8010e6:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8010e9:	83 e2 1f             	and    $0x1f,%edx
  8010ec:	29 ca                	sub    %ecx,%edx
  8010ee:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8010f2:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8010f6:	83 c0 01             	add    $0x1,%eax
  8010f9:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8010fc:	83 c7 01             	add    $0x1,%edi
  8010ff:	eb ac                	jmp    8010ad <devpipe_write+0x1c>
	return i;
  801101:	89 f8                	mov    %edi,%eax
  801103:	eb 05                	jmp    80110a <devpipe_write+0x79>
				return 0;
  801105:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80110a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80110d:	5b                   	pop    %ebx
  80110e:	5e                   	pop    %esi
  80110f:	5f                   	pop    %edi
  801110:	5d                   	pop    %ebp
  801111:	c3                   	ret    

00801112 <devpipe_read>:
{
  801112:	55                   	push   %ebp
  801113:	89 e5                	mov    %esp,%ebp
  801115:	57                   	push   %edi
  801116:	56                   	push   %esi
  801117:	53                   	push   %ebx
  801118:	83 ec 18             	sub    $0x18,%esp
  80111b:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80111e:	57                   	push   %edi
  80111f:	e8 70 f6 ff ff       	call   800794 <fd2data>
  801124:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801126:	83 c4 10             	add    $0x10,%esp
  801129:	be 00 00 00 00       	mov    $0x0,%esi
  80112e:	3b 75 10             	cmp    0x10(%ebp),%esi
  801131:	74 47                	je     80117a <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801133:	8b 03                	mov    (%ebx),%eax
  801135:	3b 43 04             	cmp    0x4(%ebx),%eax
  801138:	75 22                	jne    80115c <devpipe_read+0x4a>
			if (i > 0)
  80113a:	85 f6                	test   %esi,%esi
  80113c:	75 14                	jne    801152 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  80113e:	89 da                	mov    %ebx,%edx
  801140:	89 f8                	mov    %edi,%eax
  801142:	e8 e5 fe ff ff       	call   80102c <_pipeisclosed>
  801147:	85 c0                	test   %eax,%eax
  801149:	75 33                	jne    80117e <devpipe_read+0x6c>
			sys_yield();
  80114b:	e8 05 f4 ff ff       	call   800555 <sys_yield>
  801150:	eb e1                	jmp    801133 <devpipe_read+0x21>
				return i;
  801152:	89 f0                	mov    %esi,%eax
}
  801154:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801157:	5b                   	pop    %ebx
  801158:	5e                   	pop    %esi
  801159:	5f                   	pop    %edi
  80115a:	5d                   	pop    %ebp
  80115b:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80115c:	99                   	cltd   
  80115d:	c1 ea 1b             	shr    $0x1b,%edx
  801160:	01 d0                	add    %edx,%eax
  801162:	83 e0 1f             	and    $0x1f,%eax
  801165:	29 d0                	sub    %edx,%eax
  801167:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80116c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80116f:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801172:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801175:	83 c6 01             	add    $0x1,%esi
  801178:	eb b4                	jmp    80112e <devpipe_read+0x1c>
	return i;
  80117a:	89 f0                	mov    %esi,%eax
  80117c:	eb d6                	jmp    801154 <devpipe_read+0x42>
				return 0;
  80117e:	b8 00 00 00 00       	mov    $0x0,%eax
  801183:	eb cf                	jmp    801154 <devpipe_read+0x42>

00801185 <pipe>:
{
  801185:	55                   	push   %ebp
  801186:	89 e5                	mov    %esp,%ebp
  801188:	56                   	push   %esi
  801189:	53                   	push   %ebx
  80118a:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80118d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801190:	50                   	push   %eax
  801191:	e8 15 f6 ff ff       	call   8007ab <fd_alloc>
  801196:	89 c3                	mov    %eax,%ebx
  801198:	83 c4 10             	add    $0x10,%esp
  80119b:	85 c0                	test   %eax,%eax
  80119d:	78 5b                	js     8011fa <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80119f:	83 ec 04             	sub    $0x4,%esp
  8011a2:	68 07 04 00 00       	push   $0x407
  8011a7:	ff 75 f4             	pushl  -0xc(%ebp)
  8011aa:	6a 00                	push   $0x0
  8011ac:	e8 c3 f3 ff ff       	call   800574 <sys_page_alloc>
  8011b1:	89 c3                	mov    %eax,%ebx
  8011b3:	83 c4 10             	add    $0x10,%esp
  8011b6:	85 c0                	test   %eax,%eax
  8011b8:	78 40                	js     8011fa <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  8011ba:	83 ec 0c             	sub    $0xc,%esp
  8011bd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011c0:	50                   	push   %eax
  8011c1:	e8 e5 f5 ff ff       	call   8007ab <fd_alloc>
  8011c6:	89 c3                	mov    %eax,%ebx
  8011c8:	83 c4 10             	add    $0x10,%esp
  8011cb:	85 c0                	test   %eax,%eax
  8011cd:	78 1b                	js     8011ea <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8011cf:	83 ec 04             	sub    $0x4,%esp
  8011d2:	68 07 04 00 00       	push   $0x407
  8011d7:	ff 75 f0             	pushl  -0x10(%ebp)
  8011da:	6a 00                	push   $0x0
  8011dc:	e8 93 f3 ff ff       	call   800574 <sys_page_alloc>
  8011e1:	89 c3                	mov    %eax,%ebx
  8011e3:	83 c4 10             	add    $0x10,%esp
  8011e6:	85 c0                	test   %eax,%eax
  8011e8:	79 19                	jns    801203 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  8011ea:	83 ec 08             	sub    $0x8,%esp
  8011ed:	ff 75 f4             	pushl  -0xc(%ebp)
  8011f0:	6a 00                	push   $0x0
  8011f2:	e8 02 f4 ff ff       	call   8005f9 <sys_page_unmap>
  8011f7:	83 c4 10             	add    $0x10,%esp
}
  8011fa:	89 d8                	mov    %ebx,%eax
  8011fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8011ff:	5b                   	pop    %ebx
  801200:	5e                   	pop    %esi
  801201:	5d                   	pop    %ebp
  801202:	c3                   	ret    
	va = fd2data(fd0);
  801203:	83 ec 0c             	sub    $0xc,%esp
  801206:	ff 75 f4             	pushl  -0xc(%ebp)
  801209:	e8 86 f5 ff ff       	call   800794 <fd2data>
  80120e:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801210:	83 c4 0c             	add    $0xc,%esp
  801213:	68 07 04 00 00       	push   $0x407
  801218:	50                   	push   %eax
  801219:	6a 00                	push   $0x0
  80121b:	e8 54 f3 ff ff       	call   800574 <sys_page_alloc>
  801220:	89 c3                	mov    %eax,%ebx
  801222:	83 c4 10             	add    $0x10,%esp
  801225:	85 c0                	test   %eax,%eax
  801227:	0f 88 8c 00 00 00    	js     8012b9 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80122d:	83 ec 0c             	sub    $0xc,%esp
  801230:	ff 75 f0             	pushl  -0x10(%ebp)
  801233:	e8 5c f5 ff ff       	call   800794 <fd2data>
  801238:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80123f:	50                   	push   %eax
  801240:	6a 00                	push   $0x0
  801242:	56                   	push   %esi
  801243:	6a 00                	push   $0x0
  801245:	e8 6d f3 ff ff       	call   8005b7 <sys_page_map>
  80124a:	89 c3                	mov    %eax,%ebx
  80124c:	83 c4 20             	add    $0x20,%esp
  80124f:	85 c0                	test   %eax,%eax
  801251:	78 58                	js     8012ab <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801253:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801256:	8b 15 20 30 80 00    	mov    0x803020,%edx
  80125c:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80125e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801261:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801268:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80126b:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801271:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801273:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801276:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80127d:	83 ec 0c             	sub    $0xc,%esp
  801280:	ff 75 f4             	pushl  -0xc(%ebp)
  801283:	e8 fc f4 ff ff       	call   800784 <fd2num>
  801288:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80128b:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80128d:	83 c4 04             	add    $0x4,%esp
  801290:	ff 75 f0             	pushl  -0x10(%ebp)
  801293:	e8 ec f4 ff ff       	call   800784 <fd2num>
  801298:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80129b:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80129e:	83 c4 10             	add    $0x10,%esp
  8012a1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012a6:	e9 4f ff ff ff       	jmp    8011fa <pipe+0x75>
	sys_page_unmap(0, va);
  8012ab:	83 ec 08             	sub    $0x8,%esp
  8012ae:	56                   	push   %esi
  8012af:	6a 00                	push   $0x0
  8012b1:	e8 43 f3 ff ff       	call   8005f9 <sys_page_unmap>
  8012b6:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8012b9:	83 ec 08             	sub    $0x8,%esp
  8012bc:	ff 75 f0             	pushl  -0x10(%ebp)
  8012bf:	6a 00                	push   $0x0
  8012c1:	e8 33 f3 ff ff       	call   8005f9 <sys_page_unmap>
  8012c6:	83 c4 10             	add    $0x10,%esp
  8012c9:	e9 1c ff ff ff       	jmp    8011ea <pipe+0x65>

008012ce <pipeisclosed>:
{
  8012ce:	55                   	push   %ebp
  8012cf:	89 e5                	mov    %esp,%ebp
  8012d1:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012d7:	50                   	push   %eax
  8012d8:	ff 75 08             	pushl  0x8(%ebp)
  8012db:	e8 1a f5 ff ff       	call   8007fa <fd_lookup>
  8012e0:	83 c4 10             	add    $0x10,%esp
  8012e3:	85 c0                	test   %eax,%eax
  8012e5:	78 18                	js     8012ff <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8012e7:	83 ec 0c             	sub    $0xc,%esp
  8012ea:	ff 75 f4             	pushl  -0xc(%ebp)
  8012ed:	e8 a2 f4 ff ff       	call   800794 <fd2data>
	return _pipeisclosed(fd, p);
  8012f2:	89 c2                	mov    %eax,%edx
  8012f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012f7:	e8 30 fd ff ff       	call   80102c <_pipeisclosed>
  8012fc:	83 c4 10             	add    $0x10,%esp
}
  8012ff:	c9                   	leave  
  801300:	c3                   	ret    

00801301 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801301:	55                   	push   %ebp
  801302:	89 e5                	mov    %esp,%ebp
  801304:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801307:	68 eb 24 80 00       	push   $0x8024eb
  80130c:	ff 75 0c             	pushl  0xc(%ebp)
  80130f:	e8 67 ee ff ff       	call   80017b <strcpy>
	return 0;
}
  801314:	b8 00 00 00 00       	mov    $0x0,%eax
  801319:	c9                   	leave  
  80131a:	c3                   	ret    

0080131b <devsock_close>:
{
  80131b:	55                   	push   %ebp
  80131c:	89 e5                	mov    %esp,%ebp
  80131e:	53                   	push   %ebx
  80131f:	83 ec 10             	sub    $0x10,%esp
  801322:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801325:	53                   	push   %ebx
  801326:	e8 f4 0d 00 00       	call   80211f <pageref>
  80132b:	83 c4 10             	add    $0x10,%esp
		return 0;
  80132e:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801333:	83 f8 01             	cmp    $0x1,%eax
  801336:	74 07                	je     80133f <devsock_close+0x24>
}
  801338:	89 d0                	mov    %edx,%eax
  80133a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80133d:	c9                   	leave  
  80133e:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  80133f:	83 ec 0c             	sub    $0xc,%esp
  801342:	ff 73 0c             	pushl  0xc(%ebx)
  801345:	e8 b7 02 00 00       	call   801601 <nsipc_close>
  80134a:	89 c2                	mov    %eax,%edx
  80134c:	83 c4 10             	add    $0x10,%esp
  80134f:	eb e7                	jmp    801338 <devsock_close+0x1d>

00801351 <devsock_write>:
{
  801351:	55                   	push   %ebp
  801352:	89 e5                	mov    %esp,%ebp
  801354:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801357:	6a 00                	push   $0x0
  801359:	ff 75 10             	pushl  0x10(%ebp)
  80135c:	ff 75 0c             	pushl  0xc(%ebp)
  80135f:	8b 45 08             	mov    0x8(%ebp),%eax
  801362:	ff 70 0c             	pushl  0xc(%eax)
  801365:	e8 74 03 00 00       	call   8016de <nsipc_send>
}
  80136a:	c9                   	leave  
  80136b:	c3                   	ret    

0080136c <devsock_read>:
{
  80136c:	55                   	push   %ebp
  80136d:	89 e5                	mov    %esp,%ebp
  80136f:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801372:	6a 00                	push   $0x0
  801374:	ff 75 10             	pushl  0x10(%ebp)
  801377:	ff 75 0c             	pushl  0xc(%ebp)
  80137a:	8b 45 08             	mov    0x8(%ebp),%eax
  80137d:	ff 70 0c             	pushl  0xc(%eax)
  801380:	e8 ed 02 00 00       	call   801672 <nsipc_recv>
}
  801385:	c9                   	leave  
  801386:	c3                   	ret    

00801387 <fd2sockid>:
{
  801387:	55                   	push   %ebp
  801388:	89 e5                	mov    %esp,%ebp
  80138a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  80138d:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801390:	52                   	push   %edx
  801391:	50                   	push   %eax
  801392:	e8 63 f4 ff ff       	call   8007fa <fd_lookup>
  801397:	83 c4 10             	add    $0x10,%esp
  80139a:	85 c0                	test   %eax,%eax
  80139c:	78 10                	js     8013ae <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  80139e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013a1:	8b 0d 3c 30 80 00    	mov    0x80303c,%ecx
  8013a7:	39 08                	cmp    %ecx,(%eax)
  8013a9:	75 05                	jne    8013b0 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8013ab:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8013ae:	c9                   	leave  
  8013af:	c3                   	ret    
		return -E_NOT_SUPP;
  8013b0:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013b5:	eb f7                	jmp    8013ae <fd2sockid+0x27>

008013b7 <alloc_sockfd>:
{
  8013b7:	55                   	push   %ebp
  8013b8:	89 e5                	mov    %esp,%ebp
  8013ba:	56                   	push   %esi
  8013bb:	53                   	push   %ebx
  8013bc:	83 ec 1c             	sub    $0x1c,%esp
  8013bf:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  8013c1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013c4:	50                   	push   %eax
  8013c5:	e8 e1 f3 ff ff       	call   8007ab <fd_alloc>
  8013ca:	89 c3                	mov    %eax,%ebx
  8013cc:	83 c4 10             	add    $0x10,%esp
  8013cf:	85 c0                	test   %eax,%eax
  8013d1:	78 43                	js     801416 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8013d3:	83 ec 04             	sub    $0x4,%esp
  8013d6:	68 07 04 00 00       	push   $0x407
  8013db:	ff 75 f4             	pushl  -0xc(%ebp)
  8013de:	6a 00                	push   $0x0
  8013e0:	e8 8f f1 ff ff       	call   800574 <sys_page_alloc>
  8013e5:	89 c3                	mov    %eax,%ebx
  8013e7:	83 c4 10             	add    $0x10,%esp
  8013ea:	85 c0                	test   %eax,%eax
  8013ec:	78 28                	js     801416 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  8013ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013f1:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8013f7:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8013f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013fc:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801403:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801406:	83 ec 0c             	sub    $0xc,%esp
  801409:	50                   	push   %eax
  80140a:	e8 75 f3 ff ff       	call   800784 <fd2num>
  80140f:	89 c3                	mov    %eax,%ebx
  801411:	83 c4 10             	add    $0x10,%esp
  801414:	eb 0c                	jmp    801422 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801416:	83 ec 0c             	sub    $0xc,%esp
  801419:	56                   	push   %esi
  80141a:	e8 e2 01 00 00       	call   801601 <nsipc_close>
		return r;
  80141f:	83 c4 10             	add    $0x10,%esp
}
  801422:	89 d8                	mov    %ebx,%eax
  801424:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801427:	5b                   	pop    %ebx
  801428:	5e                   	pop    %esi
  801429:	5d                   	pop    %ebp
  80142a:	c3                   	ret    

0080142b <accept>:
{
  80142b:	55                   	push   %ebp
  80142c:	89 e5                	mov    %esp,%ebp
  80142e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801431:	8b 45 08             	mov    0x8(%ebp),%eax
  801434:	e8 4e ff ff ff       	call   801387 <fd2sockid>
  801439:	85 c0                	test   %eax,%eax
  80143b:	78 1b                	js     801458 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80143d:	83 ec 04             	sub    $0x4,%esp
  801440:	ff 75 10             	pushl  0x10(%ebp)
  801443:	ff 75 0c             	pushl  0xc(%ebp)
  801446:	50                   	push   %eax
  801447:	e8 0e 01 00 00       	call   80155a <nsipc_accept>
  80144c:	83 c4 10             	add    $0x10,%esp
  80144f:	85 c0                	test   %eax,%eax
  801451:	78 05                	js     801458 <accept+0x2d>
	return alloc_sockfd(r);
  801453:	e8 5f ff ff ff       	call   8013b7 <alloc_sockfd>
}
  801458:	c9                   	leave  
  801459:	c3                   	ret    

0080145a <bind>:
{
  80145a:	55                   	push   %ebp
  80145b:	89 e5                	mov    %esp,%ebp
  80145d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801460:	8b 45 08             	mov    0x8(%ebp),%eax
  801463:	e8 1f ff ff ff       	call   801387 <fd2sockid>
  801468:	85 c0                	test   %eax,%eax
  80146a:	78 12                	js     80147e <bind+0x24>
	return nsipc_bind(r, name, namelen);
  80146c:	83 ec 04             	sub    $0x4,%esp
  80146f:	ff 75 10             	pushl  0x10(%ebp)
  801472:	ff 75 0c             	pushl  0xc(%ebp)
  801475:	50                   	push   %eax
  801476:	e8 2f 01 00 00       	call   8015aa <nsipc_bind>
  80147b:	83 c4 10             	add    $0x10,%esp
}
  80147e:	c9                   	leave  
  80147f:	c3                   	ret    

00801480 <shutdown>:
{
  801480:	55                   	push   %ebp
  801481:	89 e5                	mov    %esp,%ebp
  801483:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801486:	8b 45 08             	mov    0x8(%ebp),%eax
  801489:	e8 f9 fe ff ff       	call   801387 <fd2sockid>
  80148e:	85 c0                	test   %eax,%eax
  801490:	78 0f                	js     8014a1 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801492:	83 ec 08             	sub    $0x8,%esp
  801495:	ff 75 0c             	pushl  0xc(%ebp)
  801498:	50                   	push   %eax
  801499:	e8 41 01 00 00       	call   8015df <nsipc_shutdown>
  80149e:	83 c4 10             	add    $0x10,%esp
}
  8014a1:	c9                   	leave  
  8014a2:	c3                   	ret    

008014a3 <connect>:
{
  8014a3:	55                   	push   %ebp
  8014a4:	89 e5                	mov    %esp,%ebp
  8014a6:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8014a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ac:	e8 d6 fe ff ff       	call   801387 <fd2sockid>
  8014b1:	85 c0                	test   %eax,%eax
  8014b3:	78 12                	js     8014c7 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8014b5:	83 ec 04             	sub    $0x4,%esp
  8014b8:	ff 75 10             	pushl  0x10(%ebp)
  8014bb:	ff 75 0c             	pushl  0xc(%ebp)
  8014be:	50                   	push   %eax
  8014bf:	e8 57 01 00 00       	call   80161b <nsipc_connect>
  8014c4:	83 c4 10             	add    $0x10,%esp
}
  8014c7:	c9                   	leave  
  8014c8:	c3                   	ret    

008014c9 <listen>:
{
  8014c9:	55                   	push   %ebp
  8014ca:	89 e5                	mov    %esp,%ebp
  8014cc:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8014cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d2:	e8 b0 fe ff ff       	call   801387 <fd2sockid>
  8014d7:	85 c0                	test   %eax,%eax
  8014d9:	78 0f                	js     8014ea <listen+0x21>
	return nsipc_listen(r, backlog);
  8014db:	83 ec 08             	sub    $0x8,%esp
  8014de:	ff 75 0c             	pushl  0xc(%ebp)
  8014e1:	50                   	push   %eax
  8014e2:	e8 69 01 00 00       	call   801650 <nsipc_listen>
  8014e7:	83 c4 10             	add    $0x10,%esp
}
  8014ea:	c9                   	leave  
  8014eb:	c3                   	ret    

008014ec <socket>:

int
socket(int domain, int type, int protocol)
{
  8014ec:	55                   	push   %ebp
  8014ed:	89 e5                	mov    %esp,%ebp
  8014ef:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8014f2:	ff 75 10             	pushl  0x10(%ebp)
  8014f5:	ff 75 0c             	pushl  0xc(%ebp)
  8014f8:	ff 75 08             	pushl  0x8(%ebp)
  8014fb:	e8 3c 02 00 00       	call   80173c <nsipc_socket>
  801500:	83 c4 10             	add    $0x10,%esp
  801503:	85 c0                	test   %eax,%eax
  801505:	78 05                	js     80150c <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801507:	e8 ab fe ff ff       	call   8013b7 <alloc_sockfd>
}
  80150c:	c9                   	leave  
  80150d:	c3                   	ret    

0080150e <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80150e:	55                   	push   %ebp
  80150f:	89 e5                	mov    %esp,%ebp
  801511:	53                   	push   %ebx
  801512:	83 ec 04             	sub    $0x4,%esp
  801515:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801517:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  80151e:	74 26                	je     801546 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801520:	6a 07                	push   $0x7
  801522:	68 00 60 80 00       	push   $0x806000
  801527:	53                   	push   %ebx
  801528:	ff 35 04 40 80 00    	pushl  0x804004
  80152e:	e8 5a 0b 00 00       	call   80208d <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801533:	83 c4 0c             	add    $0xc,%esp
  801536:	6a 00                	push   $0x0
  801538:	6a 00                	push   $0x0
  80153a:	6a 00                	push   $0x0
  80153c:	e8 e3 0a 00 00       	call   802024 <ipc_recv>
}
  801541:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801544:	c9                   	leave  
  801545:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801546:	83 ec 0c             	sub    $0xc,%esp
  801549:	6a 02                	push   $0x2
  80154b:	e8 96 0b 00 00       	call   8020e6 <ipc_find_env>
  801550:	a3 04 40 80 00       	mov    %eax,0x804004
  801555:	83 c4 10             	add    $0x10,%esp
  801558:	eb c6                	jmp    801520 <nsipc+0x12>

0080155a <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80155a:	55                   	push   %ebp
  80155b:	89 e5                	mov    %esp,%ebp
  80155d:	56                   	push   %esi
  80155e:	53                   	push   %ebx
  80155f:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801562:	8b 45 08             	mov    0x8(%ebp),%eax
  801565:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80156a:	8b 06                	mov    (%esi),%eax
  80156c:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801571:	b8 01 00 00 00       	mov    $0x1,%eax
  801576:	e8 93 ff ff ff       	call   80150e <nsipc>
  80157b:	89 c3                	mov    %eax,%ebx
  80157d:	85 c0                	test   %eax,%eax
  80157f:	78 20                	js     8015a1 <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801581:	83 ec 04             	sub    $0x4,%esp
  801584:	ff 35 10 60 80 00    	pushl  0x806010
  80158a:	68 00 60 80 00       	push   $0x806000
  80158f:	ff 75 0c             	pushl  0xc(%ebp)
  801592:	e8 72 ed ff ff       	call   800309 <memmove>
		*addrlen = ret->ret_addrlen;
  801597:	a1 10 60 80 00       	mov    0x806010,%eax
  80159c:	89 06                	mov    %eax,(%esi)
  80159e:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  8015a1:	89 d8                	mov    %ebx,%eax
  8015a3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015a6:	5b                   	pop    %ebx
  8015a7:	5e                   	pop    %esi
  8015a8:	5d                   	pop    %ebp
  8015a9:	c3                   	ret    

008015aa <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8015aa:	55                   	push   %ebp
  8015ab:	89 e5                	mov    %esp,%ebp
  8015ad:	53                   	push   %ebx
  8015ae:	83 ec 08             	sub    $0x8,%esp
  8015b1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8015b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b7:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8015bc:	53                   	push   %ebx
  8015bd:	ff 75 0c             	pushl  0xc(%ebp)
  8015c0:	68 04 60 80 00       	push   $0x806004
  8015c5:	e8 3f ed ff ff       	call   800309 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8015ca:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  8015d0:	b8 02 00 00 00       	mov    $0x2,%eax
  8015d5:	e8 34 ff ff ff       	call   80150e <nsipc>
}
  8015da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015dd:	c9                   	leave  
  8015de:	c3                   	ret    

008015df <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8015df:	55                   	push   %ebp
  8015e0:	89 e5                	mov    %esp,%ebp
  8015e2:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8015e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e8:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  8015ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f0:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  8015f5:	b8 03 00 00 00       	mov    $0x3,%eax
  8015fa:	e8 0f ff ff ff       	call   80150e <nsipc>
}
  8015ff:	c9                   	leave  
  801600:	c3                   	ret    

00801601 <nsipc_close>:

int
nsipc_close(int s)
{
  801601:	55                   	push   %ebp
  801602:	89 e5                	mov    %esp,%ebp
  801604:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801607:	8b 45 08             	mov    0x8(%ebp),%eax
  80160a:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  80160f:	b8 04 00 00 00       	mov    $0x4,%eax
  801614:	e8 f5 fe ff ff       	call   80150e <nsipc>
}
  801619:	c9                   	leave  
  80161a:	c3                   	ret    

0080161b <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80161b:	55                   	push   %ebp
  80161c:	89 e5                	mov    %esp,%ebp
  80161e:	53                   	push   %ebx
  80161f:	83 ec 08             	sub    $0x8,%esp
  801622:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801625:	8b 45 08             	mov    0x8(%ebp),%eax
  801628:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80162d:	53                   	push   %ebx
  80162e:	ff 75 0c             	pushl  0xc(%ebp)
  801631:	68 04 60 80 00       	push   $0x806004
  801636:	e8 ce ec ff ff       	call   800309 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80163b:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801641:	b8 05 00 00 00       	mov    $0x5,%eax
  801646:	e8 c3 fe ff ff       	call   80150e <nsipc>
}
  80164b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80164e:	c9                   	leave  
  80164f:	c3                   	ret    

00801650 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801650:	55                   	push   %ebp
  801651:	89 e5                	mov    %esp,%ebp
  801653:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801656:	8b 45 08             	mov    0x8(%ebp),%eax
  801659:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  80165e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801661:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801666:	b8 06 00 00 00       	mov    $0x6,%eax
  80166b:	e8 9e fe ff ff       	call   80150e <nsipc>
}
  801670:	c9                   	leave  
  801671:	c3                   	ret    

00801672 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801672:	55                   	push   %ebp
  801673:	89 e5                	mov    %esp,%ebp
  801675:	56                   	push   %esi
  801676:	53                   	push   %ebx
  801677:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  80167a:	8b 45 08             	mov    0x8(%ebp),%eax
  80167d:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801682:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801688:	8b 45 14             	mov    0x14(%ebp),%eax
  80168b:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801690:	b8 07 00 00 00       	mov    $0x7,%eax
  801695:	e8 74 fe ff ff       	call   80150e <nsipc>
  80169a:	89 c3                	mov    %eax,%ebx
  80169c:	85 c0                	test   %eax,%eax
  80169e:	78 1f                	js     8016bf <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  8016a0:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8016a5:	7f 21                	jg     8016c8 <nsipc_recv+0x56>
  8016a7:	39 c6                	cmp    %eax,%esi
  8016a9:	7c 1d                	jl     8016c8 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8016ab:	83 ec 04             	sub    $0x4,%esp
  8016ae:	50                   	push   %eax
  8016af:	68 00 60 80 00       	push   $0x806000
  8016b4:	ff 75 0c             	pushl  0xc(%ebp)
  8016b7:	e8 4d ec ff ff       	call   800309 <memmove>
  8016bc:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8016bf:	89 d8                	mov    %ebx,%eax
  8016c1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016c4:	5b                   	pop    %ebx
  8016c5:	5e                   	pop    %esi
  8016c6:	5d                   	pop    %ebp
  8016c7:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8016c8:	68 f7 24 80 00       	push   $0x8024f7
  8016cd:	68 99 24 80 00       	push   $0x802499
  8016d2:	6a 62                	push   $0x62
  8016d4:	68 0c 25 80 00       	push   $0x80250c
  8016d9:	e8 05 02 00 00       	call   8018e3 <_panic>

008016de <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8016de:	55                   	push   %ebp
  8016df:	89 e5                	mov    %esp,%ebp
  8016e1:	53                   	push   %ebx
  8016e2:	83 ec 04             	sub    $0x4,%esp
  8016e5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8016e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016eb:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  8016f0:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8016f6:	7f 2e                	jg     801726 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8016f8:	83 ec 04             	sub    $0x4,%esp
  8016fb:	53                   	push   %ebx
  8016fc:	ff 75 0c             	pushl  0xc(%ebp)
  8016ff:	68 0c 60 80 00       	push   $0x80600c
  801704:	e8 00 ec ff ff       	call   800309 <memmove>
	nsipcbuf.send.req_size = size;
  801709:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  80170f:	8b 45 14             	mov    0x14(%ebp),%eax
  801712:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801717:	b8 08 00 00 00       	mov    $0x8,%eax
  80171c:	e8 ed fd ff ff       	call   80150e <nsipc>
}
  801721:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801724:	c9                   	leave  
  801725:	c3                   	ret    
	assert(size < 1600);
  801726:	68 18 25 80 00       	push   $0x802518
  80172b:	68 99 24 80 00       	push   $0x802499
  801730:	6a 6d                	push   $0x6d
  801732:	68 0c 25 80 00       	push   $0x80250c
  801737:	e8 a7 01 00 00       	call   8018e3 <_panic>

0080173c <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80173c:	55                   	push   %ebp
  80173d:	89 e5                	mov    %esp,%ebp
  80173f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801742:	8b 45 08             	mov    0x8(%ebp),%eax
  801745:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  80174a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80174d:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801752:	8b 45 10             	mov    0x10(%ebp),%eax
  801755:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  80175a:	b8 09 00 00 00       	mov    $0x9,%eax
  80175f:	e8 aa fd ff ff       	call   80150e <nsipc>
}
  801764:	c9                   	leave  
  801765:	c3                   	ret    

00801766 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801766:	55                   	push   %ebp
  801767:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801769:	b8 00 00 00 00       	mov    $0x0,%eax
  80176e:	5d                   	pop    %ebp
  80176f:	c3                   	ret    

00801770 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801770:	55                   	push   %ebp
  801771:	89 e5                	mov    %esp,%ebp
  801773:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801776:	68 24 25 80 00       	push   $0x802524
  80177b:	ff 75 0c             	pushl  0xc(%ebp)
  80177e:	e8 f8 e9 ff ff       	call   80017b <strcpy>
	return 0;
}
  801783:	b8 00 00 00 00       	mov    $0x0,%eax
  801788:	c9                   	leave  
  801789:	c3                   	ret    

0080178a <devcons_write>:
{
  80178a:	55                   	push   %ebp
  80178b:	89 e5                	mov    %esp,%ebp
  80178d:	57                   	push   %edi
  80178e:	56                   	push   %esi
  80178f:	53                   	push   %ebx
  801790:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801796:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80179b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8017a1:	eb 2f                	jmp    8017d2 <devcons_write+0x48>
		m = n - tot;
  8017a3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8017a6:	29 f3                	sub    %esi,%ebx
  8017a8:	83 fb 7f             	cmp    $0x7f,%ebx
  8017ab:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8017b0:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8017b3:	83 ec 04             	sub    $0x4,%esp
  8017b6:	53                   	push   %ebx
  8017b7:	89 f0                	mov    %esi,%eax
  8017b9:	03 45 0c             	add    0xc(%ebp),%eax
  8017bc:	50                   	push   %eax
  8017bd:	57                   	push   %edi
  8017be:	e8 46 eb ff ff       	call   800309 <memmove>
		sys_cputs(buf, m);
  8017c3:	83 c4 08             	add    $0x8,%esp
  8017c6:	53                   	push   %ebx
  8017c7:	57                   	push   %edi
  8017c8:	e8 eb ec ff ff       	call   8004b8 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8017cd:	01 de                	add    %ebx,%esi
  8017cf:	83 c4 10             	add    $0x10,%esp
  8017d2:	3b 75 10             	cmp    0x10(%ebp),%esi
  8017d5:	72 cc                	jb     8017a3 <devcons_write+0x19>
}
  8017d7:	89 f0                	mov    %esi,%eax
  8017d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017dc:	5b                   	pop    %ebx
  8017dd:	5e                   	pop    %esi
  8017de:	5f                   	pop    %edi
  8017df:	5d                   	pop    %ebp
  8017e0:	c3                   	ret    

008017e1 <devcons_read>:
{
  8017e1:	55                   	push   %ebp
  8017e2:	89 e5                	mov    %esp,%ebp
  8017e4:	83 ec 08             	sub    $0x8,%esp
  8017e7:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8017ec:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017f0:	75 07                	jne    8017f9 <devcons_read+0x18>
}
  8017f2:	c9                   	leave  
  8017f3:	c3                   	ret    
		sys_yield();
  8017f4:	e8 5c ed ff ff       	call   800555 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  8017f9:	e8 d8 ec ff ff       	call   8004d6 <sys_cgetc>
  8017fe:	85 c0                	test   %eax,%eax
  801800:	74 f2                	je     8017f4 <devcons_read+0x13>
	if (c < 0)
  801802:	85 c0                	test   %eax,%eax
  801804:	78 ec                	js     8017f2 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  801806:	83 f8 04             	cmp    $0x4,%eax
  801809:	74 0c                	je     801817 <devcons_read+0x36>
	*(char*)vbuf = c;
  80180b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80180e:	88 02                	mov    %al,(%edx)
	return 1;
  801810:	b8 01 00 00 00       	mov    $0x1,%eax
  801815:	eb db                	jmp    8017f2 <devcons_read+0x11>
		return 0;
  801817:	b8 00 00 00 00       	mov    $0x0,%eax
  80181c:	eb d4                	jmp    8017f2 <devcons_read+0x11>

0080181e <cputchar>:
{
  80181e:	55                   	push   %ebp
  80181f:	89 e5                	mov    %esp,%ebp
  801821:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801824:	8b 45 08             	mov    0x8(%ebp),%eax
  801827:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80182a:	6a 01                	push   $0x1
  80182c:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80182f:	50                   	push   %eax
  801830:	e8 83 ec ff ff       	call   8004b8 <sys_cputs>
}
  801835:	83 c4 10             	add    $0x10,%esp
  801838:	c9                   	leave  
  801839:	c3                   	ret    

0080183a <getchar>:
{
  80183a:	55                   	push   %ebp
  80183b:	89 e5                	mov    %esp,%ebp
  80183d:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801840:	6a 01                	push   $0x1
  801842:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801845:	50                   	push   %eax
  801846:	6a 00                	push   $0x0
  801848:	e8 1e f2 ff ff       	call   800a6b <read>
	if (r < 0)
  80184d:	83 c4 10             	add    $0x10,%esp
  801850:	85 c0                	test   %eax,%eax
  801852:	78 08                	js     80185c <getchar+0x22>
	if (r < 1)
  801854:	85 c0                	test   %eax,%eax
  801856:	7e 06                	jle    80185e <getchar+0x24>
	return c;
  801858:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80185c:	c9                   	leave  
  80185d:	c3                   	ret    
		return -E_EOF;
  80185e:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801863:	eb f7                	jmp    80185c <getchar+0x22>

00801865 <iscons>:
{
  801865:	55                   	push   %ebp
  801866:	89 e5                	mov    %esp,%ebp
  801868:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80186b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80186e:	50                   	push   %eax
  80186f:	ff 75 08             	pushl  0x8(%ebp)
  801872:	e8 83 ef ff ff       	call   8007fa <fd_lookup>
  801877:	83 c4 10             	add    $0x10,%esp
  80187a:	85 c0                	test   %eax,%eax
  80187c:	78 11                	js     80188f <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80187e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801881:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801887:	39 10                	cmp    %edx,(%eax)
  801889:	0f 94 c0             	sete   %al
  80188c:	0f b6 c0             	movzbl %al,%eax
}
  80188f:	c9                   	leave  
  801890:	c3                   	ret    

00801891 <opencons>:
{
  801891:	55                   	push   %ebp
  801892:	89 e5                	mov    %esp,%ebp
  801894:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801897:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80189a:	50                   	push   %eax
  80189b:	e8 0b ef ff ff       	call   8007ab <fd_alloc>
  8018a0:	83 c4 10             	add    $0x10,%esp
  8018a3:	85 c0                	test   %eax,%eax
  8018a5:	78 3a                	js     8018e1 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8018a7:	83 ec 04             	sub    $0x4,%esp
  8018aa:	68 07 04 00 00       	push   $0x407
  8018af:	ff 75 f4             	pushl  -0xc(%ebp)
  8018b2:	6a 00                	push   $0x0
  8018b4:	e8 bb ec ff ff       	call   800574 <sys_page_alloc>
  8018b9:	83 c4 10             	add    $0x10,%esp
  8018bc:	85 c0                	test   %eax,%eax
  8018be:	78 21                	js     8018e1 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8018c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018c3:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8018c9:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8018cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018ce:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8018d5:	83 ec 0c             	sub    $0xc,%esp
  8018d8:	50                   	push   %eax
  8018d9:	e8 a6 ee ff ff       	call   800784 <fd2num>
  8018de:	83 c4 10             	add    $0x10,%esp
}
  8018e1:	c9                   	leave  
  8018e2:	c3                   	ret    

008018e3 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8018e3:	55                   	push   %ebp
  8018e4:	89 e5                	mov    %esp,%ebp
  8018e6:	56                   	push   %esi
  8018e7:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8018e8:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8018eb:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8018f1:	e8 40 ec ff ff       	call   800536 <sys_getenvid>
  8018f6:	83 ec 0c             	sub    $0xc,%esp
  8018f9:	ff 75 0c             	pushl  0xc(%ebp)
  8018fc:	ff 75 08             	pushl  0x8(%ebp)
  8018ff:	56                   	push   %esi
  801900:	50                   	push   %eax
  801901:	68 30 25 80 00       	push   $0x802530
  801906:	e8 b3 00 00 00       	call   8019be <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80190b:	83 c4 18             	add    $0x18,%esp
  80190e:	53                   	push   %ebx
  80190f:	ff 75 10             	pushl  0x10(%ebp)
  801912:	e8 56 00 00 00       	call   80196d <vcprintf>
	cprintf("\n");
  801917:	c7 04 24 e4 24 80 00 	movl   $0x8024e4,(%esp)
  80191e:	e8 9b 00 00 00       	call   8019be <cprintf>
  801923:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801926:	cc                   	int3   
  801927:	eb fd                	jmp    801926 <_panic+0x43>

00801929 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  801929:	55                   	push   %ebp
  80192a:	89 e5                	mov    %esp,%ebp
  80192c:	53                   	push   %ebx
  80192d:	83 ec 04             	sub    $0x4,%esp
  801930:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801933:	8b 13                	mov    (%ebx),%edx
  801935:	8d 42 01             	lea    0x1(%edx),%eax
  801938:	89 03                	mov    %eax,(%ebx)
  80193a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80193d:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801941:	3d ff 00 00 00       	cmp    $0xff,%eax
  801946:	74 09                	je     801951 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  801948:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80194c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80194f:	c9                   	leave  
  801950:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  801951:	83 ec 08             	sub    $0x8,%esp
  801954:	68 ff 00 00 00       	push   $0xff
  801959:	8d 43 08             	lea    0x8(%ebx),%eax
  80195c:	50                   	push   %eax
  80195d:	e8 56 eb ff ff       	call   8004b8 <sys_cputs>
		b->idx = 0;
  801962:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801968:	83 c4 10             	add    $0x10,%esp
  80196b:	eb db                	jmp    801948 <putch+0x1f>

0080196d <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80196d:	55                   	push   %ebp
  80196e:	89 e5                	mov    %esp,%ebp
  801970:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801976:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80197d:	00 00 00 
	b.cnt = 0;
  801980:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801987:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80198a:	ff 75 0c             	pushl  0xc(%ebp)
  80198d:	ff 75 08             	pushl  0x8(%ebp)
  801990:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801996:	50                   	push   %eax
  801997:	68 29 19 80 00       	push   $0x801929
  80199c:	e8 1a 01 00 00       	call   801abb <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8019a1:	83 c4 08             	add    $0x8,%esp
  8019a4:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8019aa:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8019b0:	50                   	push   %eax
  8019b1:	e8 02 eb ff ff       	call   8004b8 <sys_cputs>

	return b.cnt;
}
  8019b6:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8019bc:	c9                   	leave  
  8019bd:	c3                   	ret    

008019be <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8019be:	55                   	push   %ebp
  8019bf:	89 e5                	mov    %esp,%ebp
  8019c1:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8019c4:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8019c7:	50                   	push   %eax
  8019c8:	ff 75 08             	pushl  0x8(%ebp)
  8019cb:	e8 9d ff ff ff       	call   80196d <vcprintf>
	va_end(ap);

	return cnt;
}
  8019d0:	c9                   	leave  
  8019d1:	c3                   	ret    

008019d2 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8019d2:	55                   	push   %ebp
  8019d3:	89 e5                	mov    %esp,%ebp
  8019d5:	57                   	push   %edi
  8019d6:	56                   	push   %esi
  8019d7:	53                   	push   %ebx
  8019d8:	83 ec 1c             	sub    $0x1c,%esp
  8019db:	89 c7                	mov    %eax,%edi
  8019dd:	89 d6                	mov    %edx,%esi
  8019df:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019e5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8019e8:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8019eb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019ee:	bb 00 00 00 00       	mov    $0x0,%ebx
  8019f3:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8019f6:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8019f9:	39 d3                	cmp    %edx,%ebx
  8019fb:	72 05                	jb     801a02 <printnum+0x30>
  8019fd:	39 45 10             	cmp    %eax,0x10(%ebp)
  801a00:	77 7a                	ja     801a7c <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801a02:	83 ec 0c             	sub    $0xc,%esp
  801a05:	ff 75 18             	pushl  0x18(%ebp)
  801a08:	8b 45 14             	mov    0x14(%ebp),%eax
  801a0b:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801a0e:	53                   	push   %ebx
  801a0f:	ff 75 10             	pushl  0x10(%ebp)
  801a12:	83 ec 08             	sub    $0x8,%esp
  801a15:	ff 75 e4             	pushl  -0x1c(%ebp)
  801a18:	ff 75 e0             	pushl  -0x20(%ebp)
  801a1b:	ff 75 dc             	pushl  -0x24(%ebp)
  801a1e:	ff 75 d8             	pushl  -0x28(%ebp)
  801a21:	e8 3a 07 00 00       	call   802160 <__udivdi3>
  801a26:	83 c4 18             	add    $0x18,%esp
  801a29:	52                   	push   %edx
  801a2a:	50                   	push   %eax
  801a2b:	89 f2                	mov    %esi,%edx
  801a2d:	89 f8                	mov    %edi,%eax
  801a2f:	e8 9e ff ff ff       	call   8019d2 <printnum>
  801a34:	83 c4 20             	add    $0x20,%esp
  801a37:	eb 13                	jmp    801a4c <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801a39:	83 ec 08             	sub    $0x8,%esp
  801a3c:	56                   	push   %esi
  801a3d:	ff 75 18             	pushl  0x18(%ebp)
  801a40:	ff d7                	call   *%edi
  801a42:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  801a45:	83 eb 01             	sub    $0x1,%ebx
  801a48:	85 db                	test   %ebx,%ebx
  801a4a:	7f ed                	jg     801a39 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801a4c:	83 ec 08             	sub    $0x8,%esp
  801a4f:	56                   	push   %esi
  801a50:	83 ec 04             	sub    $0x4,%esp
  801a53:	ff 75 e4             	pushl  -0x1c(%ebp)
  801a56:	ff 75 e0             	pushl  -0x20(%ebp)
  801a59:	ff 75 dc             	pushl  -0x24(%ebp)
  801a5c:	ff 75 d8             	pushl  -0x28(%ebp)
  801a5f:	e8 1c 08 00 00       	call   802280 <__umoddi3>
  801a64:	83 c4 14             	add    $0x14,%esp
  801a67:	0f be 80 53 25 80 00 	movsbl 0x802553(%eax),%eax
  801a6e:	50                   	push   %eax
  801a6f:	ff d7                	call   *%edi
}
  801a71:	83 c4 10             	add    $0x10,%esp
  801a74:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a77:	5b                   	pop    %ebx
  801a78:	5e                   	pop    %esi
  801a79:	5f                   	pop    %edi
  801a7a:	5d                   	pop    %ebp
  801a7b:	c3                   	ret    
  801a7c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a7f:	eb c4                	jmp    801a45 <printnum+0x73>

00801a81 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801a81:	55                   	push   %ebp
  801a82:	89 e5                	mov    %esp,%ebp
  801a84:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801a87:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  801a8b:	8b 10                	mov    (%eax),%edx
  801a8d:	3b 50 04             	cmp    0x4(%eax),%edx
  801a90:	73 0a                	jae    801a9c <sprintputch+0x1b>
		*b->buf++ = ch;
  801a92:	8d 4a 01             	lea    0x1(%edx),%ecx
  801a95:	89 08                	mov    %ecx,(%eax)
  801a97:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9a:	88 02                	mov    %al,(%edx)
}
  801a9c:	5d                   	pop    %ebp
  801a9d:	c3                   	ret    

00801a9e <printfmt>:
{
  801a9e:	55                   	push   %ebp
  801a9f:	89 e5                	mov    %esp,%ebp
  801aa1:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  801aa4:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  801aa7:	50                   	push   %eax
  801aa8:	ff 75 10             	pushl  0x10(%ebp)
  801aab:	ff 75 0c             	pushl  0xc(%ebp)
  801aae:	ff 75 08             	pushl  0x8(%ebp)
  801ab1:	e8 05 00 00 00       	call   801abb <vprintfmt>
}
  801ab6:	83 c4 10             	add    $0x10,%esp
  801ab9:	c9                   	leave  
  801aba:	c3                   	ret    

00801abb <vprintfmt>:
{
  801abb:	55                   	push   %ebp
  801abc:	89 e5                	mov    %esp,%ebp
  801abe:	57                   	push   %edi
  801abf:	56                   	push   %esi
  801ac0:	53                   	push   %ebx
  801ac1:	83 ec 2c             	sub    $0x2c,%esp
  801ac4:	8b 75 08             	mov    0x8(%ebp),%esi
  801ac7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801aca:	8b 7d 10             	mov    0x10(%ebp),%edi
  801acd:	e9 21 04 00 00       	jmp    801ef3 <vprintfmt+0x438>
		padc = ' ';
  801ad2:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  801ad6:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  801add:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  801ae4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801aeb:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801af0:	8d 47 01             	lea    0x1(%edi),%eax
  801af3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801af6:	0f b6 17             	movzbl (%edi),%edx
  801af9:	8d 42 dd             	lea    -0x23(%edx),%eax
  801afc:	3c 55                	cmp    $0x55,%al
  801afe:	0f 87 90 04 00 00    	ja     801f94 <vprintfmt+0x4d9>
  801b04:	0f b6 c0             	movzbl %al,%eax
  801b07:	ff 24 85 a0 26 80 00 	jmp    *0x8026a0(,%eax,4)
  801b0e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  801b11:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  801b15:	eb d9                	jmp    801af0 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  801b17:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  801b1a:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  801b1e:	eb d0                	jmp    801af0 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  801b20:	0f b6 d2             	movzbl %dl,%edx
  801b23:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  801b26:	b8 00 00 00 00       	mov    $0x0,%eax
  801b2b:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  801b2e:	8d 04 80             	lea    (%eax,%eax,4),%eax
  801b31:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  801b35:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  801b38:	8d 4a d0             	lea    -0x30(%edx),%ecx
  801b3b:	83 f9 09             	cmp    $0x9,%ecx
  801b3e:	77 55                	ja     801b95 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  801b40:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  801b43:	eb e9                	jmp    801b2e <vprintfmt+0x73>
			precision = va_arg(ap, int);
  801b45:	8b 45 14             	mov    0x14(%ebp),%eax
  801b48:	8b 00                	mov    (%eax),%eax
  801b4a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801b4d:	8b 45 14             	mov    0x14(%ebp),%eax
  801b50:	8d 40 04             	lea    0x4(%eax),%eax
  801b53:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801b56:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  801b59:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801b5d:	79 91                	jns    801af0 <vprintfmt+0x35>
				width = precision, precision = -1;
  801b5f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801b62:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801b65:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  801b6c:	eb 82                	jmp    801af0 <vprintfmt+0x35>
  801b6e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b71:	85 c0                	test   %eax,%eax
  801b73:	ba 00 00 00 00       	mov    $0x0,%edx
  801b78:	0f 49 d0             	cmovns %eax,%edx
  801b7b:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801b7e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801b81:	e9 6a ff ff ff       	jmp    801af0 <vprintfmt+0x35>
  801b86:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  801b89:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  801b90:	e9 5b ff ff ff       	jmp    801af0 <vprintfmt+0x35>
  801b95:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  801b98:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801b9b:	eb bc                	jmp    801b59 <vprintfmt+0x9e>
			lflag++;
  801b9d:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801ba0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  801ba3:	e9 48 ff ff ff       	jmp    801af0 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  801ba8:	8b 45 14             	mov    0x14(%ebp),%eax
  801bab:	8d 78 04             	lea    0x4(%eax),%edi
  801bae:	83 ec 08             	sub    $0x8,%esp
  801bb1:	53                   	push   %ebx
  801bb2:	ff 30                	pushl  (%eax)
  801bb4:	ff d6                	call   *%esi
			break;
  801bb6:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  801bb9:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  801bbc:	e9 2f 03 00 00       	jmp    801ef0 <vprintfmt+0x435>
			err = va_arg(ap, int);
  801bc1:	8b 45 14             	mov    0x14(%ebp),%eax
  801bc4:	8d 78 04             	lea    0x4(%eax),%edi
  801bc7:	8b 00                	mov    (%eax),%eax
  801bc9:	99                   	cltd   
  801bca:	31 d0                	xor    %edx,%eax
  801bcc:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  801bce:	83 f8 0f             	cmp    $0xf,%eax
  801bd1:	7f 23                	jg     801bf6 <vprintfmt+0x13b>
  801bd3:	8b 14 85 00 28 80 00 	mov    0x802800(,%eax,4),%edx
  801bda:	85 d2                	test   %edx,%edx
  801bdc:	74 18                	je     801bf6 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  801bde:	52                   	push   %edx
  801bdf:	68 ab 24 80 00       	push   $0x8024ab
  801be4:	53                   	push   %ebx
  801be5:	56                   	push   %esi
  801be6:	e8 b3 fe ff ff       	call   801a9e <printfmt>
  801beb:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801bee:	89 7d 14             	mov    %edi,0x14(%ebp)
  801bf1:	e9 fa 02 00 00       	jmp    801ef0 <vprintfmt+0x435>
				printfmt(putch, putdat, "error %d", err);
  801bf6:	50                   	push   %eax
  801bf7:	68 6b 25 80 00       	push   $0x80256b
  801bfc:	53                   	push   %ebx
  801bfd:	56                   	push   %esi
  801bfe:	e8 9b fe ff ff       	call   801a9e <printfmt>
  801c03:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801c06:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  801c09:	e9 e2 02 00 00       	jmp    801ef0 <vprintfmt+0x435>
			if ((p = va_arg(ap, char *)) == NULL)
  801c0e:	8b 45 14             	mov    0x14(%ebp),%eax
  801c11:	83 c0 04             	add    $0x4,%eax
  801c14:	89 45 cc             	mov    %eax,-0x34(%ebp)
  801c17:	8b 45 14             	mov    0x14(%ebp),%eax
  801c1a:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  801c1c:	85 ff                	test   %edi,%edi
  801c1e:	b8 64 25 80 00       	mov    $0x802564,%eax
  801c23:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  801c26:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801c2a:	0f 8e bd 00 00 00    	jle    801ced <vprintfmt+0x232>
  801c30:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  801c34:	75 0e                	jne    801c44 <vprintfmt+0x189>
  801c36:	89 75 08             	mov    %esi,0x8(%ebp)
  801c39:	8b 75 d0             	mov    -0x30(%ebp),%esi
  801c3c:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  801c3f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  801c42:	eb 6d                	jmp    801cb1 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  801c44:	83 ec 08             	sub    $0x8,%esp
  801c47:	ff 75 d0             	pushl  -0x30(%ebp)
  801c4a:	57                   	push   %edi
  801c4b:	e8 0c e5 ff ff       	call   80015c <strnlen>
  801c50:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  801c53:	29 c1                	sub    %eax,%ecx
  801c55:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  801c58:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  801c5b:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  801c5f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801c62:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  801c65:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  801c67:	eb 0f                	jmp    801c78 <vprintfmt+0x1bd>
					putch(padc, putdat);
  801c69:	83 ec 08             	sub    $0x8,%esp
  801c6c:	53                   	push   %ebx
  801c6d:	ff 75 e0             	pushl  -0x20(%ebp)
  801c70:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  801c72:	83 ef 01             	sub    $0x1,%edi
  801c75:	83 c4 10             	add    $0x10,%esp
  801c78:	85 ff                	test   %edi,%edi
  801c7a:	7f ed                	jg     801c69 <vprintfmt+0x1ae>
  801c7c:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  801c7f:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  801c82:	85 c9                	test   %ecx,%ecx
  801c84:	b8 00 00 00 00       	mov    $0x0,%eax
  801c89:	0f 49 c1             	cmovns %ecx,%eax
  801c8c:	29 c1                	sub    %eax,%ecx
  801c8e:	89 75 08             	mov    %esi,0x8(%ebp)
  801c91:	8b 75 d0             	mov    -0x30(%ebp),%esi
  801c94:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  801c97:	89 cb                	mov    %ecx,%ebx
  801c99:	eb 16                	jmp    801cb1 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  801c9b:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801c9f:	75 31                	jne    801cd2 <vprintfmt+0x217>
					putch(ch, putdat);
  801ca1:	83 ec 08             	sub    $0x8,%esp
  801ca4:	ff 75 0c             	pushl  0xc(%ebp)
  801ca7:	50                   	push   %eax
  801ca8:	ff 55 08             	call   *0x8(%ebp)
  801cab:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801cae:	83 eb 01             	sub    $0x1,%ebx
  801cb1:	83 c7 01             	add    $0x1,%edi
  801cb4:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  801cb8:	0f be c2             	movsbl %dl,%eax
  801cbb:	85 c0                	test   %eax,%eax
  801cbd:	74 59                	je     801d18 <vprintfmt+0x25d>
  801cbf:	85 f6                	test   %esi,%esi
  801cc1:	78 d8                	js     801c9b <vprintfmt+0x1e0>
  801cc3:	83 ee 01             	sub    $0x1,%esi
  801cc6:	79 d3                	jns    801c9b <vprintfmt+0x1e0>
  801cc8:	89 df                	mov    %ebx,%edi
  801cca:	8b 75 08             	mov    0x8(%ebp),%esi
  801ccd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801cd0:	eb 37                	jmp    801d09 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  801cd2:	0f be d2             	movsbl %dl,%edx
  801cd5:	83 ea 20             	sub    $0x20,%edx
  801cd8:	83 fa 5e             	cmp    $0x5e,%edx
  801cdb:	76 c4                	jbe    801ca1 <vprintfmt+0x1e6>
					putch('?', putdat);
  801cdd:	83 ec 08             	sub    $0x8,%esp
  801ce0:	ff 75 0c             	pushl  0xc(%ebp)
  801ce3:	6a 3f                	push   $0x3f
  801ce5:	ff 55 08             	call   *0x8(%ebp)
  801ce8:	83 c4 10             	add    $0x10,%esp
  801ceb:	eb c1                	jmp    801cae <vprintfmt+0x1f3>
  801ced:	89 75 08             	mov    %esi,0x8(%ebp)
  801cf0:	8b 75 d0             	mov    -0x30(%ebp),%esi
  801cf3:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  801cf6:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  801cf9:	eb b6                	jmp    801cb1 <vprintfmt+0x1f6>
				putch(' ', putdat);
  801cfb:	83 ec 08             	sub    $0x8,%esp
  801cfe:	53                   	push   %ebx
  801cff:	6a 20                	push   $0x20
  801d01:	ff d6                	call   *%esi
			for (; width > 0; width--)
  801d03:	83 ef 01             	sub    $0x1,%edi
  801d06:	83 c4 10             	add    $0x10,%esp
  801d09:	85 ff                	test   %edi,%edi
  801d0b:	7f ee                	jg     801cfb <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  801d0d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801d10:	89 45 14             	mov    %eax,0x14(%ebp)
  801d13:	e9 d8 01 00 00       	jmp    801ef0 <vprintfmt+0x435>
  801d18:	89 df                	mov    %ebx,%edi
  801d1a:	8b 75 08             	mov    0x8(%ebp),%esi
  801d1d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801d20:	eb e7                	jmp    801d09 <vprintfmt+0x24e>
	if (lflag >= 2)
  801d22:	83 f9 01             	cmp    $0x1,%ecx
  801d25:	7e 45                	jle    801d6c <vprintfmt+0x2b1>
		return va_arg(*ap, long long);
  801d27:	8b 45 14             	mov    0x14(%ebp),%eax
  801d2a:	8b 50 04             	mov    0x4(%eax),%edx
  801d2d:	8b 00                	mov    (%eax),%eax
  801d2f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801d32:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801d35:	8b 45 14             	mov    0x14(%ebp),%eax
  801d38:	8d 40 08             	lea    0x8(%eax),%eax
  801d3b:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  801d3e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801d42:	79 62                	jns    801da6 <vprintfmt+0x2eb>
				putch('-', putdat);
  801d44:	83 ec 08             	sub    $0x8,%esp
  801d47:	53                   	push   %ebx
  801d48:	6a 2d                	push   $0x2d
  801d4a:	ff d6                	call   *%esi
				num = -(long long) num;
  801d4c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801d4f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801d52:	f7 d8                	neg    %eax
  801d54:	83 d2 00             	adc    $0x0,%edx
  801d57:	f7 da                	neg    %edx
  801d59:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801d5c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801d5f:	83 c4 10             	add    $0x10,%esp
			base = 10;
  801d62:	ba 0a 00 00 00       	mov    $0xa,%edx
  801d67:	e9 66 01 00 00       	jmp    801ed2 <vprintfmt+0x417>
	else if (lflag)
  801d6c:	85 c9                	test   %ecx,%ecx
  801d6e:	75 1b                	jne    801d8b <vprintfmt+0x2d0>
		return va_arg(*ap, int);
  801d70:	8b 45 14             	mov    0x14(%ebp),%eax
  801d73:	8b 00                	mov    (%eax),%eax
  801d75:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801d78:	89 c1                	mov    %eax,%ecx
  801d7a:	c1 f9 1f             	sar    $0x1f,%ecx
  801d7d:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  801d80:	8b 45 14             	mov    0x14(%ebp),%eax
  801d83:	8d 40 04             	lea    0x4(%eax),%eax
  801d86:	89 45 14             	mov    %eax,0x14(%ebp)
  801d89:	eb b3                	jmp    801d3e <vprintfmt+0x283>
		return va_arg(*ap, long);
  801d8b:	8b 45 14             	mov    0x14(%ebp),%eax
  801d8e:	8b 00                	mov    (%eax),%eax
  801d90:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801d93:	89 c1                	mov    %eax,%ecx
  801d95:	c1 f9 1f             	sar    $0x1f,%ecx
  801d98:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  801d9b:	8b 45 14             	mov    0x14(%ebp),%eax
  801d9e:	8d 40 04             	lea    0x4(%eax),%eax
  801da1:	89 45 14             	mov    %eax,0x14(%ebp)
  801da4:	eb 98                	jmp    801d3e <vprintfmt+0x283>
			base = 10;
  801da6:	ba 0a 00 00 00       	mov    $0xa,%edx
  801dab:	e9 22 01 00 00       	jmp    801ed2 <vprintfmt+0x417>
	if (lflag >= 2)
  801db0:	83 f9 01             	cmp    $0x1,%ecx
  801db3:	7e 21                	jle    801dd6 <vprintfmt+0x31b>
		return va_arg(*ap, unsigned long long);
  801db5:	8b 45 14             	mov    0x14(%ebp),%eax
  801db8:	8b 50 04             	mov    0x4(%eax),%edx
  801dbb:	8b 00                	mov    (%eax),%eax
  801dbd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801dc0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801dc3:	8b 45 14             	mov    0x14(%ebp),%eax
  801dc6:	8d 40 08             	lea    0x8(%eax),%eax
  801dc9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801dcc:	ba 0a 00 00 00       	mov    $0xa,%edx
  801dd1:	e9 fc 00 00 00       	jmp    801ed2 <vprintfmt+0x417>
	else if (lflag)
  801dd6:	85 c9                	test   %ecx,%ecx
  801dd8:	75 23                	jne    801dfd <vprintfmt+0x342>
		return va_arg(*ap, unsigned int);
  801dda:	8b 45 14             	mov    0x14(%ebp),%eax
  801ddd:	8b 00                	mov    (%eax),%eax
  801ddf:	ba 00 00 00 00       	mov    $0x0,%edx
  801de4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801de7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801dea:	8b 45 14             	mov    0x14(%ebp),%eax
  801ded:	8d 40 04             	lea    0x4(%eax),%eax
  801df0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801df3:	ba 0a 00 00 00       	mov    $0xa,%edx
  801df8:	e9 d5 00 00 00       	jmp    801ed2 <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  801dfd:	8b 45 14             	mov    0x14(%ebp),%eax
  801e00:	8b 00                	mov    (%eax),%eax
  801e02:	ba 00 00 00 00       	mov    $0x0,%edx
  801e07:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801e0a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801e0d:	8b 45 14             	mov    0x14(%ebp),%eax
  801e10:	8d 40 04             	lea    0x4(%eax),%eax
  801e13:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801e16:	ba 0a 00 00 00       	mov    $0xa,%edx
  801e1b:	e9 b2 00 00 00       	jmp    801ed2 <vprintfmt+0x417>
	if (lflag >= 2)
  801e20:	83 f9 01             	cmp    $0x1,%ecx
  801e23:	7e 42                	jle    801e67 <vprintfmt+0x3ac>
		return va_arg(*ap, unsigned long long);
  801e25:	8b 45 14             	mov    0x14(%ebp),%eax
  801e28:	8b 50 04             	mov    0x4(%eax),%edx
  801e2b:	8b 00                	mov    (%eax),%eax
  801e2d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801e30:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801e33:	8b 45 14             	mov    0x14(%ebp),%eax
  801e36:	8d 40 08             	lea    0x8(%eax),%eax
  801e39:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801e3c:	ba 08 00 00 00       	mov    $0x8,%edx
			if ((long long) num < 0) {
  801e41:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801e45:	0f 89 87 00 00 00    	jns    801ed2 <vprintfmt+0x417>
				putch('-', putdat);
  801e4b:	83 ec 08             	sub    $0x8,%esp
  801e4e:	53                   	push   %ebx
  801e4f:	6a 2d                	push   $0x2d
  801e51:	ff d6                	call   *%esi
				num = -(long long) num;
  801e53:	f7 5d d8             	negl   -0x28(%ebp)
  801e56:	83 55 dc 00          	adcl   $0x0,-0x24(%ebp)
  801e5a:	f7 5d dc             	negl   -0x24(%ebp)
  801e5d:	83 c4 10             	add    $0x10,%esp
			base = 8;
  801e60:	ba 08 00 00 00       	mov    $0x8,%edx
  801e65:	eb 6b                	jmp    801ed2 <vprintfmt+0x417>
	else if (lflag)
  801e67:	85 c9                	test   %ecx,%ecx
  801e69:	75 1b                	jne    801e86 <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  801e6b:	8b 45 14             	mov    0x14(%ebp),%eax
  801e6e:	8b 00                	mov    (%eax),%eax
  801e70:	ba 00 00 00 00       	mov    $0x0,%edx
  801e75:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801e78:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801e7b:	8b 45 14             	mov    0x14(%ebp),%eax
  801e7e:	8d 40 04             	lea    0x4(%eax),%eax
  801e81:	89 45 14             	mov    %eax,0x14(%ebp)
  801e84:	eb b6                	jmp    801e3c <vprintfmt+0x381>
		return va_arg(*ap, unsigned long);
  801e86:	8b 45 14             	mov    0x14(%ebp),%eax
  801e89:	8b 00                	mov    (%eax),%eax
  801e8b:	ba 00 00 00 00       	mov    $0x0,%edx
  801e90:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801e93:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801e96:	8b 45 14             	mov    0x14(%ebp),%eax
  801e99:	8d 40 04             	lea    0x4(%eax),%eax
  801e9c:	89 45 14             	mov    %eax,0x14(%ebp)
  801e9f:	eb 9b                	jmp    801e3c <vprintfmt+0x381>
			putch('0', putdat);
  801ea1:	83 ec 08             	sub    $0x8,%esp
  801ea4:	53                   	push   %ebx
  801ea5:	6a 30                	push   $0x30
  801ea7:	ff d6                	call   *%esi
			putch('x', putdat);
  801ea9:	83 c4 08             	add    $0x8,%esp
  801eac:	53                   	push   %ebx
  801ead:	6a 78                	push   $0x78
  801eaf:	ff d6                	call   *%esi
			num = (unsigned long long)
  801eb1:	8b 45 14             	mov    0x14(%ebp),%eax
  801eb4:	8b 00                	mov    (%eax),%eax
  801eb6:	ba 00 00 00 00       	mov    $0x0,%edx
  801ebb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801ebe:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  801ec1:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  801ec4:	8b 45 14             	mov    0x14(%ebp),%eax
  801ec7:	8d 40 04             	lea    0x4(%eax),%eax
  801eca:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801ecd:	ba 10 00 00 00       	mov    $0x10,%edx
			printnum(putch, putdat, num, base, width, padc);
  801ed2:	83 ec 0c             	sub    $0xc,%esp
  801ed5:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  801ed9:	50                   	push   %eax
  801eda:	ff 75 e0             	pushl  -0x20(%ebp)
  801edd:	52                   	push   %edx
  801ede:	ff 75 dc             	pushl  -0x24(%ebp)
  801ee1:	ff 75 d8             	pushl  -0x28(%ebp)
  801ee4:	89 da                	mov    %ebx,%edx
  801ee6:	89 f0                	mov    %esi,%eax
  801ee8:	e8 e5 fa ff ff       	call   8019d2 <printnum>
			break;
  801eed:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  801ef0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801ef3:	83 c7 01             	add    $0x1,%edi
  801ef6:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801efa:	83 f8 25             	cmp    $0x25,%eax
  801efd:	0f 84 cf fb ff ff    	je     801ad2 <vprintfmt+0x17>
			if (ch == '\0')
  801f03:	85 c0                	test   %eax,%eax
  801f05:	0f 84 a9 00 00 00    	je     801fb4 <vprintfmt+0x4f9>
			putch(ch, putdat);
  801f0b:	83 ec 08             	sub    $0x8,%esp
  801f0e:	53                   	push   %ebx
  801f0f:	50                   	push   %eax
  801f10:	ff d6                	call   *%esi
  801f12:	83 c4 10             	add    $0x10,%esp
  801f15:	eb dc                	jmp    801ef3 <vprintfmt+0x438>
	if (lflag >= 2)
  801f17:	83 f9 01             	cmp    $0x1,%ecx
  801f1a:	7e 1e                	jle    801f3a <vprintfmt+0x47f>
		return va_arg(*ap, unsigned long long);
  801f1c:	8b 45 14             	mov    0x14(%ebp),%eax
  801f1f:	8b 50 04             	mov    0x4(%eax),%edx
  801f22:	8b 00                	mov    (%eax),%eax
  801f24:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801f27:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801f2a:	8b 45 14             	mov    0x14(%ebp),%eax
  801f2d:	8d 40 08             	lea    0x8(%eax),%eax
  801f30:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801f33:	ba 10 00 00 00       	mov    $0x10,%edx
  801f38:	eb 98                	jmp    801ed2 <vprintfmt+0x417>
	else if (lflag)
  801f3a:	85 c9                	test   %ecx,%ecx
  801f3c:	75 23                	jne    801f61 <vprintfmt+0x4a6>
		return va_arg(*ap, unsigned int);
  801f3e:	8b 45 14             	mov    0x14(%ebp),%eax
  801f41:	8b 00                	mov    (%eax),%eax
  801f43:	ba 00 00 00 00       	mov    $0x0,%edx
  801f48:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801f4b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801f4e:	8b 45 14             	mov    0x14(%ebp),%eax
  801f51:	8d 40 04             	lea    0x4(%eax),%eax
  801f54:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801f57:	ba 10 00 00 00       	mov    $0x10,%edx
  801f5c:	e9 71 ff ff ff       	jmp    801ed2 <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  801f61:	8b 45 14             	mov    0x14(%ebp),%eax
  801f64:	8b 00                	mov    (%eax),%eax
  801f66:	ba 00 00 00 00       	mov    $0x0,%edx
  801f6b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801f6e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801f71:	8b 45 14             	mov    0x14(%ebp),%eax
  801f74:	8d 40 04             	lea    0x4(%eax),%eax
  801f77:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801f7a:	ba 10 00 00 00       	mov    $0x10,%edx
  801f7f:	e9 4e ff ff ff       	jmp    801ed2 <vprintfmt+0x417>
			putch(ch, putdat);
  801f84:	83 ec 08             	sub    $0x8,%esp
  801f87:	53                   	push   %ebx
  801f88:	6a 25                	push   $0x25
  801f8a:	ff d6                	call   *%esi
			break;
  801f8c:	83 c4 10             	add    $0x10,%esp
  801f8f:	e9 5c ff ff ff       	jmp    801ef0 <vprintfmt+0x435>
			putch('%', putdat);
  801f94:	83 ec 08             	sub    $0x8,%esp
  801f97:	53                   	push   %ebx
  801f98:	6a 25                	push   $0x25
  801f9a:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  801f9c:	83 c4 10             	add    $0x10,%esp
  801f9f:	89 f8                	mov    %edi,%eax
  801fa1:	eb 03                	jmp    801fa6 <vprintfmt+0x4eb>
  801fa3:	83 e8 01             	sub    $0x1,%eax
  801fa6:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  801faa:	75 f7                	jne    801fa3 <vprintfmt+0x4e8>
  801fac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801faf:	e9 3c ff ff ff       	jmp    801ef0 <vprintfmt+0x435>
}
  801fb4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801fb7:	5b                   	pop    %ebx
  801fb8:	5e                   	pop    %esi
  801fb9:	5f                   	pop    %edi
  801fba:	5d                   	pop    %ebp
  801fbb:	c3                   	ret    

00801fbc <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801fbc:	55                   	push   %ebp
  801fbd:	89 e5                	mov    %esp,%ebp
  801fbf:	83 ec 18             	sub    $0x18,%esp
  801fc2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc5:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801fc8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801fcb:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801fcf:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801fd2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801fd9:	85 c0                	test   %eax,%eax
  801fdb:	74 26                	je     802003 <vsnprintf+0x47>
  801fdd:	85 d2                	test   %edx,%edx
  801fdf:	7e 22                	jle    802003 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801fe1:	ff 75 14             	pushl  0x14(%ebp)
  801fe4:	ff 75 10             	pushl  0x10(%ebp)
  801fe7:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801fea:	50                   	push   %eax
  801feb:	68 81 1a 80 00       	push   $0x801a81
  801ff0:	e8 c6 fa ff ff       	call   801abb <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801ff5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ff8:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801ffb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ffe:	83 c4 10             	add    $0x10,%esp
}
  802001:	c9                   	leave  
  802002:	c3                   	ret    
		return -E_INVAL;
  802003:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802008:	eb f7                	jmp    802001 <vsnprintf+0x45>

0080200a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80200a:	55                   	push   %ebp
  80200b:	89 e5                	mov    %esp,%ebp
  80200d:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  802010:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  802013:	50                   	push   %eax
  802014:	ff 75 10             	pushl  0x10(%ebp)
  802017:	ff 75 0c             	pushl  0xc(%ebp)
  80201a:	ff 75 08             	pushl  0x8(%ebp)
  80201d:	e8 9a ff ff ff       	call   801fbc <vsnprintf>
	va_end(ap);

	return rc;
}
  802022:	c9                   	leave  
  802023:	c3                   	ret    

00802024 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802024:	55                   	push   %ebp
  802025:	89 e5                	mov    %esp,%ebp
  802027:	56                   	push   %esi
  802028:	53                   	push   %ebx
  802029:	8b 75 08             	mov    0x8(%ebp),%esi
  80202c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80202f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
  802032:	85 c0                	test   %eax,%eax
	    pg = (void *)UTOP;
  802034:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802039:	0f 44 c2             	cmove  %edx,%eax
	}
	if ((r = sys_ipc_recv(pg)) < 0) {
  80203c:	83 ec 0c             	sub    $0xc,%esp
  80203f:	50                   	push   %eax
  802040:	e8 df e6 ff ff       	call   800724 <sys_ipc_recv>
  802045:	83 c4 10             	add    $0x10,%esp
  802048:	85 c0                	test   %eax,%eax
  80204a:	78 2b                	js     802077 <ipc_recv+0x53>
	    if (perm_store != NULL) {
	        *perm_store = 0;
	    }
	    return r;
	}
	if (from_env_store != NULL) {
  80204c:	85 f6                	test   %esi,%esi
  80204e:	74 0a                	je     80205a <ipc_recv+0x36>
	    *from_env_store = thisenv->env_ipc_from;
  802050:	a1 08 40 80 00       	mov    0x804008,%eax
  802055:	8b 40 74             	mov    0x74(%eax),%eax
  802058:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store != NULL) {
  80205a:	85 db                	test   %ebx,%ebx
  80205c:	74 0a                	je     802068 <ipc_recv+0x44>
	    *perm_store = thisenv->env_ipc_perm;
  80205e:	a1 08 40 80 00       	mov    0x804008,%eax
  802063:	8b 40 78             	mov    0x78(%eax),%eax
  802066:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  802068:	a1 08 40 80 00       	mov    0x804008,%eax
  80206d:	8b 40 70             	mov    0x70(%eax),%eax
}
  802070:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802073:	5b                   	pop    %ebx
  802074:	5e                   	pop    %esi
  802075:	5d                   	pop    %ebp
  802076:	c3                   	ret    
	    if (from_env_store != NULL) {
  802077:	85 f6                	test   %esi,%esi
  802079:	74 06                	je     802081 <ipc_recv+0x5d>
	        *from_env_store = 0;
  80207b:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	    if (perm_store != NULL) {
  802081:	85 db                	test   %ebx,%ebx
  802083:	74 eb                	je     802070 <ipc_recv+0x4c>
	        *perm_store = 0;
  802085:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80208b:	eb e3                	jmp    802070 <ipc_recv+0x4c>

0080208d <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80208d:	55                   	push   %ebp
  80208e:	89 e5                	mov    %esp,%ebp
  802090:	57                   	push   %edi
  802091:	56                   	push   %esi
  802092:	53                   	push   %ebx
  802093:	83 ec 0c             	sub    $0xc,%esp
  802096:	8b 7d 08             	mov    0x8(%ebp),%edi
  802099:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
	    pg = (void *)UTOP;
  80209c:	85 f6                	test   %esi,%esi
  80209e:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8020a3:	0f 44 f0             	cmove  %eax,%esi
  8020a6:	eb 09                	jmp    8020b1 <ipc_send+0x24>
	do {
	    r = sys_ipc_try_send(to_env, val, pg, perm);
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
	        panic("ipc_send: %e", r);
	    }
	    sys_yield();
  8020a8:	e8 a8 e4 ff ff       	call   800555 <sys_yield>
	} while(r != 0);
  8020ad:	85 db                	test   %ebx,%ebx
  8020af:	74 2d                	je     8020de <ipc_send+0x51>
	    r = sys_ipc_try_send(to_env, val, pg, perm);
  8020b1:	ff 75 14             	pushl  0x14(%ebp)
  8020b4:	56                   	push   %esi
  8020b5:	ff 75 0c             	pushl  0xc(%ebp)
  8020b8:	57                   	push   %edi
  8020b9:	e8 43 e6 ff ff       	call   800701 <sys_ipc_try_send>
  8020be:	89 c3                	mov    %eax,%ebx
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
  8020c0:	83 c4 10             	add    $0x10,%esp
  8020c3:	85 c0                	test   %eax,%eax
  8020c5:	79 e1                	jns    8020a8 <ipc_send+0x1b>
  8020c7:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8020ca:	74 dc                	je     8020a8 <ipc_send+0x1b>
	        panic("ipc_send: %e", r);
  8020cc:	50                   	push   %eax
  8020cd:	68 60 28 80 00       	push   $0x802860
  8020d2:	6a 45                	push   $0x45
  8020d4:	68 6d 28 80 00       	push   $0x80286d
  8020d9:	e8 05 f8 ff ff       	call   8018e3 <_panic>
}
  8020de:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020e1:	5b                   	pop    %ebx
  8020e2:	5e                   	pop    %esi
  8020e3:	5f                   	pop    %edi
  8020e4:	5d                   	pop    %ebp
  8020e5:	c3                   	ret    

008020e6 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8020e6:	55                   	push   %ebp
  8020e7:	89 e5                	mov    %esp,%ebp
  8020e9:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8020ec:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8020f1:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8020f4:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8020fa:	8b 52 50             	mov    0x50(%edx),%edx
  8020fd:	39 ca                	cmp    %ecx,%edx
  8020ff:	74 11                	je     802112 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  802101:	83 c0 01             	add    $0x1,%eax
  802104:	3d 00 04 00 00       	cmp    $0x400,%eax
  802109:	75 e6                	jne    8020f1 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80210b:	b8 00 00 00 00       	mov    $0x0,%eax
  802110:	eb 0b                	jmp    80211d <ipc_find_env+0x37>
			return envs[i].env_id;
  802112:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802115:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80211a:	8b 40 48             	mov    0x48(%eax),%eax
}
  80211d:	5d                   	pop    %ebp
  80211e:	c3                   	ret    

0080211f <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80211f:	55                   	push   %ebp
  802120:	89 e5                	mov    %esp,%ebp
  802122:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802125:	89 d0                	mov    %edx,%eax
  802127:	c1 e8 16             	shr    $0x16,%eax
  80212a:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802131:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802136:	f6 c1 01             	test   $0x1,%cl
  802139:	74 1d                	je     802158 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80213b:	c1 ea 0c             	shr    $0xc,%edx
  80213e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802145:	f6 c2 01             	test   $0x1,%dl
  802148:	74 0e                	je     802158 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80214a:	c1 ea 0c             	shr    $0xc,%edx
  80214d:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802154:	ef 
  802155:	0f b7 c0             	movzwl %ax,%eax
}
  802158:	5d                   	pop    %ebp
  802159:	c3                   	ret    
  80215a:	66 90                	xchg   %ax,%ax
  80215c:	66 90                	xchg   %ax,%ax
  80215e:	66 90                	xchg   %ax,%ax

00802160 <__udivdi3>:
  802160:	55                   	push   %ebp
  802161:	57                   	push   %edi
  802162:	56                   	push   %esi
  802163:	53                   	push   %ebx
  802164:	83 ec 1c             	sub    $0x1c,%esp
  802167:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80216b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80216f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802173:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802177:	85 d2                	test   %edx,%edx
  802179:	75 35                	jne    8021b0 <__udivdi3+0x50>
  80217b:	39 f3                	cmp    %esi,%ebx
  80217d:	0f 87 bd 00 00 00    	ja     802240 <__udivdi3+0xe0>
  802183:	85 db                	test   %ebx,%ebx
  802185:	89 d9                	mov    %ebx,%ecx
  802187:	75 0b                	jne    802194 <__udivdi3+0x34>
  802189:	b8 01 00 00 00       	mov    $0x1,%eax
  80218e:	31 d2                	xor    %edx,%edx
  802190:	f7 f3                	div    %ebx
  802192:	89 c1                	mov    %eax,%ecx
  802194:	31 d2                	xor    %edx,%edx
  802196:	89 f0                	mov    %esi,%eax
  802198:	f7 f1                	div    %ecx
  80219a:	89 c6                	mov    %eax,%esi
  80219c:	89 e8                	mov    %ebp,%eax
  80219e:	89 f7                	mov    %esi,%edi
  8021a0:	f7 f1                	div    %ecx
  8021a2:	89 fa                	mov    %edi,%edx
  8021a4:	83 c4 1c             	add    $0x1c,%esp
  8021a7:	5b                   	pop    %ebx
  8021a8:	5e                   	pop    %esi
  8021a9:	5f                   	pop    %edi
  8021aa:	5d                   	pop    %ebp
  8021ab:	c3                   	ret    
  8021ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8021b0:	39 f2                	cmp    %esi,%edx
  8021b2:	77 7c                	ja     802230 <__udivdi3+0xd0>
  8021b4:	0f bd fa             	bsr    %edx,%edi
  8021b7:	83 f7 1f             	xor    $0x1f,%edi
  8021ba:	0f 84 98 00 00 00    	je     802258 <__udivdi3+0xf8>
  8021c0:	89 f9                	mov    %edi,%ecx
  8021c2:	b8 20 00 00 00       	mov    $0x20,%eax
  8021c7:	29 f8                	sub    %edi,%eax
  8021c9:	d3 e2                	shl    %cl,%edx
  8021cb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8021cf:	89 c1                	mov    %eax,%ecx
  8021d1:	89 da                	mov    %ebx,%edx
  8021d3:	d3 ea                	shr    %cl,%edx
  8021d5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8021d9:	09 d1                	or     %edx,%ecx
  8021db:	89 f2                	mov    %esi,%edx
  8021dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8021e1:	89 f9                	mov    %edi,%ecx
  8021e3:	d3 e3                	shl    %cl,%ebx
  8021e5:	89 c1                	mov    %eax,%ecx
  8021e7:	d3 ea                	shr    %cl,%edx
  8021e9:	89 f9                	mov    %edi,%ecx
  8021eb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8021ef:	d3 e6                	shl    %cl,%esi
  8021f1:	89 eb                	mov    %ebp,%ebx
  8021f3:	89 c1                	mov    %eax,%ecx
  8021f5:	d3 eb                	shr    %cl,%ebx
  8021f7:	09 de                	or     %ebx,%esi
  8021f9:	89 f0                	mov    %esi,%eax
  8021fb:	f7 74 24 08          	divl   0x8(%esp)
  8021ff:	89 d6                	mov    %edx,%esi
  802201:	89 c3                	mov    %eax,%ebx
  802203:	f7 64 24 0c          	mull   0xc(%esp)
  802207:	39 d6                	cmp    %edx,%esi
  802209:	72 0c                	jb     802217 <__udivdi3+0xb7>
  80220b:	89 f9                	mov    %edi,%ecx
  80220d:	d3 e5                	shl    %cl,%ebp
  80220f:	39 c5                	cmp    %eax,%ebp
  802211:	73 5d                	jae    802270 <__udivdi3+0x110>
  802213:	39 d6                	cmp    %edx,%esi
  802215:	75 59                	jne    802270 <__udivdi3+0x110>
  802217:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80221a:	31 ff                	xor    %edi,%edi
  80221c:	89 fa                	mov    %edi,%edx
  80221e:	83 c4 1c             	add    $0x1c,%esp
  802221:	5b                   	pop    %ebx
  802222:	5e                   	pop    %esi
  802223:	5f                   	pop    %edi
  802224:	5d                   	pop    %ebp
  802225:	c3                   	ret    
  802226:	8d 76 00             	lea    0x0(%esi),%esi
  802229:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  802230:	31 ff                	xor    %edi,%edi
  802232:	31 c0                	xor    %eax,%eax
  802234:	89 fa                	mov    %edi,%edx
  802236:	83 c4 1c             	add    $0x1c,%esp
  802239:	5b                   	pop    %ebx
  80223a:	5e                   	pop    %esi
  80223b:	5f                   	pop    %edi
  80223c:	5d                   	pop    %ebp
  80223d:	c3                   	ret    
  80223e:	66 90                	xchg   %ax,%ax
  802240:	31 ff                	xor    %edi,%edi
  802242:	89 e8                	mov    %ebp,%eax
  802244:	89 f2                	mov    %esi,%edx
  802246:	f7 f3                	div    %ebx
  802248:	89 fa                	mov    %edi,%edx
  80224a:	83 c4 1c             	add    $0x1c,%esp
  80224d:	5b                   	pop    %ebx
  80224e:	5e                   	pop    %esi
  80224f:	5f                   	pop    %edi
  802250:	5d                   	pop    %ebp
  802251:	c3                   	ret    
  802252:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802258:	39 f2                	cmp    %esi,%edx
  80225a:	72 06                	jb     802262 <__udivdi3+0x102>
  80225c:	31 c0                	xor    %eax,%eax
  80225e:	39 eb                	cmp    %ebp,%ebx
  802260:	77 d2                	ja     802234 <__udivdi3+0xd4>
  802262:	b8 01 00 00 00       	mov    $0x1,%eax
  802267:	eb cb                	jmp    802234 <__udivdi3+0xd4>
  802269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802270:	89 d8                	mov    %ebx,%eax
  802272:	31 ff                	xor    %edi,%edi
  802274:	eb be                	jmp    802234 <__udivdi3+0xd4>
  802276:	66 90                	xchg   %ax,%ax
  802278:	66 90                	xchg   %ax,%ax
  80227a:	66 90                	xchg   %ax,%ax
  80227c:	66 90                	xchg   %ax,%ax
  80227e:	66 90                	xchg   %ax,%ax

00802280 <__umoddi3>:
  802280:	55                   	push   %ebp
  802281:	57                   	push   %edi
  802282:	56                   	push   %esi
  802283:	53                   	push   %ebx
  802284:	83 ec 1c             	sub    $0x1c,%esp
  802287:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  80228b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80228f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802293:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802297:	85 ed                	test   %ebp,%ebp
  802299:	89 f0                	mov    %esi,%eax
  80229b:	89 da                	mov    %ebx,%edx
  80229d:	75 19                	jne    8022b8 <__umoddi3+0x38>
  80229f:	39 df                	cmp    %ebx,%edi
  8022a1:	0f 86 b1 00 00 00    	jbe    802358 <__umoddi3+0xd8>
  8022a7:	f7 f7                	div    %edi
  8022a9:	89 d0                	mov    %edx,%eax
  8022ab:	31 d2                	xor    %edx,%edx
  8022ad:	83 c4 1c             	add    $0x1c,%esp
  8022b0:	5b                   	pop    %ebx
  8022b1:	5e                   	pop    %esi
  8022b2:	5f                   	pop    %edi
  8022b3:	5d                   	pop    %ebp
  8022b4:	c3                   	ret    
  8022b5:	8d 76 00             	lea    0x0(%esi),%esi
  8022b8:	39 dd                	cmp    %ebx,%ebp
  8022ba:	77 f1                	ja     8022ad <__umoddi3+0x2d>
  8022bc:	0f bd cd             	bsr    %ebp,%ecx
  8022bf:	83 f1 1f             	xor    $0x1f,%ecx
  8022c2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8022c6:	0f 84 b4 00 00 00    	je     802380 <__umoddi3+0x100>
  8022cc:	b8 20 00 00 00       	mov    $0x20,%eax
  8022d1:	89 c2                	mov    %eax,%edx
  8022d3:	8b 44 24 04          	mov    0x4(%esp),%eax
  8022d7:	29 c2                	sub    %eax,%edx
  8022d9:	89 c1                	mov    %eax,%ecx
  8022db:	89 f8                	mov    %edi,%eax
  8022dd:	d3 e5                	shl    %cl,%ebp
  8022df:	89 d1                	mov    %edx,%ecx
  8022e1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8022e5:	d3 e8                	shr    %cl,%eax
  8022e7:	09 c5                	or     %eax,%ebp
  8022e9:	8b 44 24 04          	mov    0x4(%esp),%eax
  8022ed:	89 c1                	mov    %eax,%ecx
  8022ef:	d3 e7                	shl    %cl,%edi
  8022f1:	89 d1                	mov    %edx,%ecx
  8022f3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8022f7:	89 df                	mov    %ebx,%edi
  8022f9:	d3 ef                	shr    %cl,%edi
  8022fb:	89 c1                	mov    %eax,%ecx
  8022fd:	89 f0                	mov    %esi,%eax
  8022ff:	d3 e3                	shl    %cl,%ebx
  802301:	89 d1                	mov    %edx,%ecx
  802303:	89 fa                	mov    %edi,%edx
  802305:	d3 e8                	shr    %cl,%eax
  802307:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80230c:	09 d8                	or     %ebx,%eax
  80230e:	f7 f5                	div    %ebp
  802310:	d3 e6                	shl    %cl,%esi
  802312:	89 d1                	mov    %edx,%ecx
  802314:	f7 64 24 08          	mull   0x8(%esp)
  802318:	39 d1                	cmp    %edx,%ecx
  80231a:	89 c3                	mov    %eax,%ebx
  80231c:	89 d7                	mov    %edx,%edi
  80231e:	72 06                	jb     802326 <__umoddi3+0xa6>
  802320:	75 0e                	jne    802330 <__umoddi3+0xb0>
  802322:	39 c6                	cmp    %eax,%esi
  802324:	73 0a                	jae    802330 <__umoddi3+0xb0>
  802326:	2b 44 24 08          	sub    0x8(%esp),%eax
  80232a:	19 ea                	sbb    %ebp,%edx
  80232c:	89 d7                	mov    %edx,%edi
  80232e:	89 c3                	mov    %eax,%ebx
  802330:	89 ca                	mov    %ecx,%edx
  802332:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  802337:	29 de                	sub    %ebx,%esi
  802339:	19 fa                	sbb    %edi,%edx
  80233b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  80233f:	89 d0                	mov    %edx,%eax
  802341:	d3 e0                	shl    %cl,%eax
  802343:	89 d9                	mov    %ebx,%ecx
  802345:	d3 ee                	shr    %cl,%esi
  802347:	d3 ea                	shr    %cl,%edx
  802349:	09 f0                	or     %esi,%eax
  80234b:	83 c4 1c             	add    $0x1c,%esp
  80234e:	5b                   	pop    %ebx
  80234f:	5e                   	pop    %esi
  802350:	5f                   	pop    %edi
  802351:	5d                   	pop    %ebp
  802352:	c3                   	ret    
  802353:	90                   	nop
  802354:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802358:	85 ff                	test   %edi,%edi
  80235a:	89 f9                	mov    %edi,%ecx
  80235c:	75 0b                	jne    802369 <__umoddi3+0xe9>
  80235e:	b8 01 00 00 00       	mov    $0x1,%eax
  802363:	31 d2                	xor    %edx,%edx
  802365:	f7 f7                	div    %edi
  802367:	89 c1                	mov    %eax,%ecx
  802369:	89 d8                	mov    %ebx,%eax
  80236b:	31 d2                	xor    %edx,%edx
  80236d:	f7 f1                	div    %ecx
  80236f:	89 f0                	mov    %esi,%eax
  802371:	f7 f1                	div    %ecx
  802373:	e9 31 ff ff ff       	jmp    8022a9 <__umoddi3+0x29>
  802378:	90                   	nop
  802379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802380:	39 dd                	cmp    %ebx,%ebp
  802382:	72 08                	jb     80238c <__umoddi3+0x10c>
  802384:	39 f7                	cmp    %esi,%edi
  802386:	0f 87 21 ff ff ff    	ja     8022ad <__umoddi3+0x2d>
  80238c:	89 da                	mov    %ebx,%edx
  80238e:	89 f0                	mov    %esi,%eax
  802390:	29 f8                	sub    %edi,%eax
  802392:	19 ea                	sbb    %ebp,%edx
  802394:	e9 14 ff ff ff       	jmp    8022ad <__umoddi3+0x2d>
