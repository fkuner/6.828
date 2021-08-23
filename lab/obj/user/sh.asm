
obj/user/sh.debug:     file format elf32-i386


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
  80002c:	e8 ea 09 00 00       	call   800a1b <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <_gettoken>:
#define WHITESPACE " \t\r\n"
#define SYMBOLS "<|>&;()"

int
_gettoken(char *s, char **p1, char **p2)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int t;

	if (s == 0) {
  80003b:	85 db                	test   %ebx,%ebx
  80003d:	74 1d                	je     80005c <_gettoken+0x29>
		if (debug > 1)
			cprintf("GETTOKEN NULL\n");
		return 0;
	}

	if (debug > 1)
  80003f:	83 3d 00 60 80 00 01 	cmpl   $0x1,0x806000
  800046:	7f 34                	jg     80007c <_gettoken+0x49>
		cprintf("GETTOKEN: %s\n", s);

	*p1 = 0;
  800048:	8b 45 0c             	mov    0xc(%ebp),%eax
  80004b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*p2 = 0;
  800051:	8b 45 10             	mov    0x10(%ebp),%eax
  800054:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	while (strchr(WHITESPACE, *s))
  80005a:	eb 3a                	jmp    800096 <_gettoken+0x63>
		return 0;
  80005c:	be 00 00 00 00       	mov    $0x0,%esi
		if (debug > 1)
  800061:	83 3d 00 60 80 00 01 	cmpl   $0x1,0x806000
  800068:	7e 59                	jle    8000c3 <_gettoken+0x90>
			cprintf("GETTOKEN NULL\n");
  80006a:	83 ec 0c             	sub    $0xc,%esp
  80006d:	68 c0 38 80 00       	push   $0x8038c0
  800072:	e8 df 0a 00 00       	call   800b56 <cprintf>
  800077:	83 c4 10             	add    $0x10,%esp
  80007a:	eb 47                	jmp    8000c3 <_gettoken+0x90>
		cprintf("GETTOKEN: %s\n", s);
  80007c:	83 ec 08             	sub    $0x8,%esp
  80007f:	53                   	push   %ebx
  800080:	68 cf 38 80 00       	push   $0x8038cf
  800085:	e8 cc 0a 00 00       	call   800b56 <cprintf>
  80008a:	83 c4 10             	add    $0x10,%esp
  80008d:	eb b9                	jmp    800048 <_gettoken+0x15>
		*s++ = 0;
  80008f:	83 c3 01             	add    $0x1,%ebx
  800092:	c6 43 ff 00          	movb   $0x0,-0x1(%ebx)
	while (strchr(WHITESPACE, *s))
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	0f be 03             	movsbl (%ebx),%eax
  80009c:	50                   	push   %eax
  80009d:	68 dd 38 80 00       	push   $0x8038dd
  8000a2:	e8 40 13 00 00       	call   8013e7 <strchr>
  8000a7:	83 c4 10             	add    $0x10,%esp
  8000aa:	85 c0                	test   %eax,%eax
  8000ac:	75 e1                	jne    80008f <_gettoken+0x5c>
	if (*s == 0) {
  8000ae:	0f b6 03             	movzbl (%ebx),%eax
  8000b1:	84 c0                	test   %al,%al
  8000b3:	75 29                	jne    8000de <_gettoken+0xab>
		if (debug > 1)
			cprintf("EOL\n");
		return 0;
  8000b5:	be 00 00 00 00       	mov    $0x0,%esi
		if (debug > 1)
  8000ba:	83 3d 00 60 80 00 01 	cmpl   $0x1,0x806000
  8000c1:	7f 09                	jg     8000cc <_gettoken+0x99>
		**p2 = 0;
		cprintf("WORD: %s\n", *p1);
		**p2 = t;
	}
	return 'w';
}
  8000c3:	89 f0                	mov    %esi,%eax
  8000c5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000c8:	5b                   	pop    %ebx
  8000c9:	5e                   	pop    %esi
  8000ca:	5d                   	pop    %ebp
  8000cb:	c3                   	ret    
			cprintf("EOL\n");
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	68 e2 38 80 00       	push   $0x8038e2
  8000d4:	e8 7d 0a 00 00       	call   800b56 <cprintf>
  8000d9:	83 c4 10             	add    $0x10,%esp
  8000dc:	eb e5                	jmp    8000c3 <_gettoken+0x90>
	if (strchr(SYMBOLS, *s)) {
  8000de:	83 ec 08             	sub    $0x8,%esp
  8000e1:	0f be c0             	movsbl %al,%eax
  8000e4:	50                   	push   %eax
  8000e5:	68 f3 38 80 00       	push   $0x8038f3
  8000ea:	e8 f8 12 00 00       	call   8013e7 <strchr>
  8000ef:	83 c4 10             	add    $0x10,%esp
  8000f2:	85 c0                	test   %eax,%eax
  8000f4:	74 2f                	je     800125 <_gettoken+0xf2>
		t = *s;
  8000f6:	0f be 33             	movsbl (%ebx),%esi
		*p1 = s;
  8000f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000fc:	89 18                	mov    %ebx,(%eax)
		*s++ = 0;
  8000fe:	c6 03 00             	movb   $0x0,(%ebx)
  800101:	83 c3 01             	add    $0x1,%ebx
  800104:	8b 45 10             	mov    0x10(%ebp),%eax
  800107:	89 18                	mov    %ebx,(%eax)
		if (debug > 1)
  800109:	83 3d 00 60 80 00 01 	cmpl   $0x1,0x806000
  800110:	7e b1                	jle    8000c3 <_gettoken+0x90>
			cprintf("TOK %c\n", t);
  800112:	83 ec 08             	sub    $0x8,%esp
  800115:	56                   	push   %esi
  800116:	68 e7 38 80 00       	push   $0x8038e7
  80011b:	e8 36 0a 00 00       	call   800b56 <cprintf>
  800120:	83 c4 10             	add    $0x10,%esp
  800123:	eb 9e                	jmp    8000c3 <_gettoken+0x90>
	*p1 = s;
  800125:	8b 45 0c             	mov    0xc(%ebp),%eax
  800128:	89 18                	mov    %ebx,(%eax)
	while (*s && !strchr(WHITESPACE SYMBOLS, *s))
  80012a:	eb 03                	jmp    80012f <_gettoken+0xfc>
		s++;
  80012c:	83 c3 01             	add    $0x1,%ebx
	while (*s && !strchr(WHITESPACE SYMBOLS, *s))
  80012f:	0f b6 03             	movzbl (%ebx),%eax
  800132:	84 c0                	test   %al,%al
  800134:	74 18                	je     80014e <_gettoken+0x11b>
  800136:	83 ec 08             	sub    $0x8,%esp
  800139:	0f be c0             	movsbl %al,%eax
  80013c:	50                   	push   %eax
  80013d:	68 ef 38 80 00       	push   $0x8038ef
  800142:	e8 a0 12 00 00       	call   8013e7 <strchr>
  800147:	83 c4 10             	add    $0x10,%esp
  80014a:	85 c0                	test   %eax,%eax
  80014c:	74 de                	je     80012c <_gettoken+0xf9>
	*p2 = s;
  80014e:	8b 45 10             	mov    0x10(%ebp),%eax
  800151:	89 18                	mov    %ebx,(%eax)
	return 'w';
  800153:	be 77 00 00 00       	mov    $0x77,%esi
	if (debug > 1) {
  800158:	83 3d 00 60 80 00 01 	cmpl   $0x1,0x806000
  80015f:	0f 8e 5e ff ff ff    	jle    8000c3 <_gettoken+0x90>
		t = **p2;
  800165:	0f b6 33             	movzbl (%ebx),%esi
		**p2 = 0;
  800168:	c6 03 00             	movb   $0x0,(%ebx)
		cprintf("WORD: %s\n", *p1);
  80016b:	83 ec 08             	sub    $0x8,%esp
  80016e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800171:	ff 30                	pushl  (%eax)
  800173:	68 fb 38 80 00       	push   $0x8038fb
  800178:	e8 d9 09 00 00       	call   800b56 <cprintf>
		**p2 = t;
  80017d:	8b 45 10             	mov    0x10(%ebp),%eax
  800180:	8b 00                	mov    (%eax),%eax
  800182:	89 f2                	mov    %esi,%edx
  800184:	88 10                	mov    %dl,(%eax)
  800186:	83 c4 10             	add    $0x10,%esp
	return 'w';
  800189:	be 77 00 00 00       	mov    $0x77,%esi
  80018e:	e9 30 ff ff ff       	jmp    8000c3 <_gettoken+0x90>

00800193 <gettoken>:

int
gettoken(char *s, char **p1)
{
  800193:	55                   	push   %ebp
  800194:	89 e5                	mov    %esp,%ebp
  800196:	83 ec 08             	sub    $0x8,%esp
  800199:	8b 45 08             	mov    0x8(%ebp),%eax
	static int c, nc;
	static char* np1, *np2;

	if (s) {
  80019c:	85 c0                	test   %eax,%eax
  80019e:	74 22                	je     8001c2 <gettoken+0x2f>
		nc = _gettoken(s, &np1, &np2);
  8001a0:	83 ec 04             	sub    $0x4,%esp
  8001a3:	68 0c 60 80 00       	push   $0x80600c
  8001a8:	68 10 60 80 00       	push   $0x806010
  8001ad:	50                   	push   %eax
  8001ae:	e8 80 fe ff ff       	call   800033 <_gettoken>
  8001b3:	a3 08 60 80 00       	mov    %eax,0x806008
		return 0;
  8001b8:	83 c4 10             	add    $0x10,%esp
  8001bb:	b8 00 00 00 00       	mov    $0x0,%eax
	}
	c = nc;
	*p1 = np1;
	nc = _gettoken(np2, &np1, &np2);
	return c;
}
  8001c0:	c9                   	leave  
  8001c1:	c3                   	ret    
	c = nc;
  8001c2:	a1 08 60 80 00       	mov    0x806008,%eax
  8001c7:	a3 04 60 80 00       	mov    %eax,0x806004
	*p1 = np1;
  8001cc:	8b 15 10 60 80 00    	mov    0x806010,%edx
  8001d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001d5:	89 10                	mov    %edx,(%eax)
	nc = _gettoken(np2, &np1, &np2);
  8001d7:	83 ec 04             	sub    $0x4,%esp
  8001da:	68 0c 60 80 00       	push   $0x80600c
  8001df:	68 10 60 80 00       	push   $0x806010
  8001e4:	ff 35 0c 60 80 00    	pushl  0x80600c
  8001ea:	e8 44 fe ff ff       	call   800033 <_gettoken>
  8001ef:	a3 08 60 80 00       	mov    %eax,0x806008
	return c;
  8001f4:	a1 04 60 80 00       	mov    0x806004,%eax
  8001f9:	83 c4 10             	add    $0x10,%esp
  8001fc:	eb c2                	jmp    8001c0 <gettoken+0x2d>

008001fe <runcmd>:
{
  8001fe:	55                   	push   %ebp
  8001ff:	89 e5                	mov    %esp,%ebp
  800201:	57                   	push   %edi
  800202:	56                   	push   %esi
  800203:	53                   	push   %ebx
  800204:	81 ec 64 04 00 00    	sub    $0x464,%esp
	gettoken(s, 0);
  80020a:	6a 00                	push   $0x0
  80020c:	ff 75 08             	pushl  0x8(%ebp)
  80020f:	e8 7f ff ff ff       	call   800193 <gettoken>
  800214:	83 c4 10             	add    $0x10,%esp
		switch ((c = gettoken(0, &t))) {
  800217:	8d 75 a4             	lea    -0x5c(%ebp),%esi
	argc = 0;
  80021a:	bf 00 00 00 00       	mov    $0x0,%edi
		switch ((c = gettoken(0, &t))) {
  80021f:	83 ec 08             	sub    $0x8,%esp
  800222:	56                   	push   %esi
  800223:	6a 00                	push   $0x0
  800225:	e8 69 ff ff ff       	call   800193 <gettoken>
  80022a:	89 c3                	mov    %eax,%ebx
  80022c:	83 c4 10             	add    $0x10,%esp
  80022f:	83 f8 3e             	cmp    $0x3e,%eax
  800232:	0f 84 39 01 00 00    	je     800371 <runcmd+0x173>
  800238:	83 f8 3e             	cmp    $0x3e,%eax
  80023b:	7f 4b                	jg     800288 <runcmd+0x8a>
  80023d:	85 c0                	test   %eax,%eax
  80023f:	0f 84 1c 02 00 00    	je     800461 <runcmd+0x263>
  800245:	83 f8 3c             	cmp    $0x3c,%eax
  800248:	0f 85 78 02 00 00    	jne    8004c6 <runcmd+0x2c8>
			if (gettoken(0, &t) != 'w') {
  80024e:	83 ec 08             	sub    $0x8,%esp
  800251:	56                   	push   %esi
  800252:	6a 00                	push   $0x0
  800254:	e8 3a ff ff ff       	call   800193 <gettoken>
  800259:	83 c4 10             	add    $0x10,%esp
  80025c:	83 f8 77             	cmp    $0x77,%eax
  80025f:	0f 85 be 00 00 00    	jne    800323 <runcmd+0x125>
			if ((fd = open(t, O_RDONLY)) < 0) {
  800265:	83 ec 08             	sub    $0x8,%esp
  800268:	6a 00                	push   $0x0
  80026a:	ff 75 a4             	pushl  -0x5c(%ebp)
  80026d:	e8 85 22 00 00       	call   8024f7 <open>
  800272:	89 c3                	mov    %eax,%ebx
  800274:	83 c4 10             	add    $0x10,%esp
  800277:	85 c0                	test   %eax,%eax
  800279:	0f 88 be 00 00 00    	js     80033d <runcmd+0x13f>
            if (fd != 0) {
  80027f:	85 c0                	test   %eax,%eax
  800281:	74 9c                	je     80021f <runcmd+0x21>
  800283:	e9 ce 00 00 00       	jmp    800356 <runcmd+0x158>
		switch ((c = gettoken(0, &t))) {
  800288:	83 f8 77             	cmp    $0x77,%eax
  80028b:	74 6b                	je     8002f8 <runcmd+0xfa>
  80028d:	83 f8 7c             	cmp    $0x7c,%eax
  800290:	0f 85 30 02 00 00    	jne    8004c6 <runcmd+0x2c8>
			if ((r = pipe(p)) < 0) {
  800296:	83 ec 0c             	sub    $0xc,%esp
  800299:	8d 85 9c fb ff ff    	lea    -0x464(%ebp),%eax
  80029f:	50                   	push   %eax
  8002a0:	e8 d2 2b 00 00       	call   802e77 <pipe>
  8002a5:	83 c4 10             	add    $0x10,%esp
  8002a8:	85 c0                	test   %eax,%eax
  8002aa:	0f 88 43 01 00 00    	js     8003f3 <runcmd+0x1f5>
			if (debug)
  8002b0:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8002b7:	0f 85 51 01 00 00    	jne    80040e <runcmd+0x210>
			if ((r = fork()) < 0) {
  8002bd:	e8 14 17 00 00       	call   8019d6 <fork>
  8002c2:	89 c3                	mov    %eax,%ebx
  8002c4:	85 c0                	test   %eax,%eax
  8002c6:	0f 88 63 01 00 00    	js     80042f <runcmd+0x231>
			if (r == 0) {
  8002cc:	85 c0                	test   %eax,%eax
  8002ce:	0f 85 71 01 00 00    	jne    800445 <runcmd+0x247>
				if (p[0] != 0) {
  8002d4:	8b 85 9c fb ff ff    	mov    -0x464(%ebp),%eax
  8002da:	85 c0                	test   %eax,%eax
  8002dc:	0f 85 a5 01 00 00    	jne    800487 <runcmd+0x289>
				close(p[1]);
  8002e2:	83 ec 0c             	sub    $0xc,%esp
  8002e5:	ff b5 a0 fb ff ff    	pushl  -0x460(%ebp)
  8002eb:	e8 27 1c 00 00       	call   801f17 <close>
				goto again;
  8002f0:	83 c4 10             	add    $0x10,%esp
  8002f3:	e9 22 ff ff ff       	jmp    80021a <runcmd+0x1c>
			if (argc == MAXARGS) {
  8002f8:	83 ff 10             	cmp    $0x10,%edi
  8002fb:	74 0f                	je     80030c <runcmd+0x10e>
			argv[argc++] = t;
  8002fd:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800300:	89 44 bd a8          	mov    %eax,-0x58(%ebp,%edi,4)
  800304:	8d 7f 01             	lea    0x1(%edi),%edi
			break;
  800307:	e9 13 ff ff ff       	jmp    80021f <runcmd+0x21>
				cprintf("too many arguments\n");
  80030c:	83 ec 0c             	sub    $0xc,%esp
  80030f:	68 05 39 80 00       	push   $0x803905
  800314:	e8 3d 08 00 00       	call   800b56 <cprintf>
				exit();
  800319:	e8 43 07 00 00       	call   800a61 <exit>
  80031e:	83 c4 10             	add    $0x10,%esp
  800321:	eb da                	jmp    8002fd <runcmd+0xff>
				cprintf("syntax error: < not followed by word\n");
  800323:	83 ec 0c             	sub    $0xc,%esp
  800326:	68 50 3a 80 00       	push   $0x803a50
  80032b:	e8 26 08 00 00       	call   800b56 <cprintf>
				exit();
  800330:	e8 2c 07 00 00       	call   800a61 <exit>
  800335:	83 c4 10             	add    $0x10,%esp
  800338:	e9 28 ff ff ff       	jmp    800265 <runcmd+0x67>
                cprintf("open %s for read: %e", t, fd);
  80033d:	83 ec 04             	sub    $0x4,%esp
  800340:	50                   	push   %eax
  800341:	ff 75 a4             	pushl  -0x5c(%ebp)
  800344:	68 19 39 80 00       	push   $0x803919
  800349:	e8 08 08 00 00       	call   800b56 <cprintf>
                exit();
  80034e:	e8 0e 07 00 00       	call   800a61 <exit>
  800353:	83 c4 10             	add    $0x10,%esp
                dup(fd, 0);
  800356:	83 ec 08             	sub    $0x8,%esp
  800359:	6a 00                	push   $0x0
  80035b:	53                   	push   %ebx
  80035c:	e8 06 1c 00 00       	call   801f67 <dup>
                close(fd);
  800361:	89 1c 24             	mov    %ebx,(%esp)
  800364:	e8 ae 1b 00 00       	call   801f17 <close>
  800369:	83 c4 10             	add    $0x10,%esp
  80036c:	e9 ae fe ff ff       	jmp    80021f <runcmd+0x21>
			if (gettoken(0, &t) != 'w') {
  800371:	83 ec 08             	sub    $0x8,%esp
  800374:	56                   	push   %esi
  800375:	6a 00                	push   $0x0
  800377:	e8 17 fe ff ff       	call   800193 <gettoken>
  80037c:	83 c4 10             	add    $0x10,%esp
  80037f:	83 f8 77             	cmp    $0x77,%eax
  800382:	75 3d                	jne    8003c1 <runcmd+0x1c3>
			if ((fd = open(t, O_WRONLY|O_CREAT|O_TRUNC)) < 0) {
  800384:	83 ec 08             	sub    $0x8,%esp
  800387:	68 01 03 00 00       	push   $0x301
  80038c:	ff 75 a4             	pushl  -0x5c(%ebp)
  80038f:	e8 63 21 00 00       	call   8024f7 <open>
  800394:	89 c3                	mov    %eax,%ebx
  800396:	83 c4 10             	add    $0x10,%esp
  800399:	85 c0                	test   %eax,%eax
  80039b:	78 3b                	js     8003d8 <runcmd+0x1da>
			if (fd != 1) {
  80039d:	83 fb 01             	cmp    $0x1,%ebx
  8003a0:	0f 84 79 fe ff ff    	je     80021f <runcmd+0x21>
				dup(fd, 1);
  8003a6:	83 ec 08             	sub    $0x8,%esp
  8003a9:	6a 01                	push   $0x1
  8003ab:	53                   	push   %ebx
  8003ac:	e8 b6 1b 00 00       	call   801f67 <dup>
				close(fd);
  8003b1:	89 1c 24             	mov    %ebx,(%esp)
  8003b4:	e8 5e 1b 00 00       	call   801f17 <close>
  8003b9:	83 c4 10             	add    $0x10,%esp
  8003bc:	e9 5e fe ff ff       	jmp    80021f <runcmd+0x21>
				cprintf("syntax error: > not followed by word\n");
  8003c1:	83 ec 0c             	sub    $0xc,%esp
  8003c4:	68 78 3a 80 00       	push   $0x803a78
  8003c9:	e8 88 07 00 00       	call   800b56 <cprintf>
				exit();
  8003ce:	e8 8e 06 00 00       	call   800a61 <exit>
  8003d3:	83 c4 10             	add    $0x10,%esp
  8003d6:	eb ac                	jmp    800384 <runcmd+0x186>
				cprintf("open %s for write: %e", t, fd);
  8003d8:	83 ec 04             	sub    $0x4,%esp
  8003db:	50                   	push   %eax
  8003dc:	ff 75 a4             	pushl  -0x5c(%ebp)
  8003df:	68 2e 39 80 00       	push   $0x80392e
  8003e4:	e8 6d 07 00 00       	call   800b56 <cprintf>
				exit();
  8003e9:	e8 73 06 00 00       	call   800a61 <exit>
  8003ee:	83 c4 10             	add    $0x10,%esp
  8003f1:	eb aa                	jmp    80039d <runcmd+0x19f>
				cprintf("pipe: %e", r);
  8003f3:	83 ec 08             	sub    $0x8,%esp
  8003f6:	50                   	push   %eax
  8003f7:	68 44 39 80 00       	push   $0x803944
  8003fc:	e8 55 07 00 00       	call   800b56 <cprintf>
				exit();
  800401:	e8 5b 06 00 00       	call   800a61 <exit>
  800406:	83 c4 10             	add    $0x10,%esp
  800409:	e9 a2 fe ff ff       	jmp    8002b0 <runcmd+0xb2>
				cprintf("PIPE: %d %d\n", p[0], p[1]);
  80040e:	83 ec 04             	sub    $0x4,%esp
  800411:	ff b5 a0 fb ff ff    	pushl  -0x460(%ebp)
  800417:	ff b5 9c fb ff ff    	pushl  -0x464(%ebp)
  80041d:	68 4d 39 80 00       	push   $0x80394d
  800422:	e8 2f 07 00 00       	call   800b56 <cprintf>
  800427:	83 c4 10             	add    $0x10,%esp
  80042a:	e9 8e fe ff ff       	jmp    8002bd <runcmd+0xbf>
				cprintf("fork: %e", r);
  80042f:	83 ec 08             	sub    $0x8,%esp
  800432:	50                   	push   %eax
  800433:	68 76 3e 80 00       	push   $0x803e76
  800438:	e8 19 07 00 00       	call   800b56 <cprintf>
				exit();
  80043d:	e8 1f 06 00 00       	call   800a61 <exit>
  800442:	83 c4 10             	add    $0x10,%esp
				if (p[1] != 1) {
  800445:	8b 85 a0 fb ff ff    	mov    -0x460(%ebp),%eax
  80044b:	83 f8 01             	cmp    $0x1,%eax
  80044e:	75 58                	jne    8004a8 <runcmd+0x2aa>
				close(p[0]);
  800450:	83 ec 0c             	sub    $0xc,%esp
  800453:	ff b5 9c fb ff ff    	pushl  -0x464(%ebp)
  800459:	e8 b9 1a 00 00       	call   801f17 <close>
				goto runit;
  80045e:	83 c4 10             	add    $0x10,%esp
	if(argc == 0) {
  800461:	85 ff                	test   %edi,%edi
  800463:	75 73                	jne    8004d8 <runcmd+0x2da>
		if (debug)
  800465:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  80046c:	0f 84 f0 00 00 00    	je     800562 <runcmd+0x364>
			cprintf("EMPTY COMMAND\n");
  800472:	83 ec 0c             	sub    $0xc,%esp
  800475:	68 80 39 80 00       	push   $0x803980
  80047a:	e8 d7 06 00 00       	call   800b56 <cprintf>
  80047f:	83 c4 10             	add    $0x10,%esp
  800482:	e9 db 00 00 00       	jmp    800562 <runcmd+0x364>
					dup(p[0], 0);
  800487:	83 ec 08             	sub    $0x8,%esp
  80048a:	6a 00                	push   $0x0
  80048c:	50                   	push   %eax
  80048d:	e8 d5 1a 00 00       	call   801f67 <dup>
					close(p[0]);
  800492:	83 c4 04             	add    $0x4,%esp
  800495:	ff b5 9c fb ff ff    	pushl  -0x464(%ebp)
  80049b:	e8 77 1a 00 00       	call   801f17 <close>
  8004a0:	83 c4 10             	add    $0x10,%esp
  8004a3:	e9 3a fe ff ff       	jmp    8002e2 <runcmd+0xe4>
					dup(p[1], 1);
  8004a8:	83 ec 08             	sub    $0x8,%esp
  8004ab:	6a 01                	push   $0x1
  8004ad:	50                   	push   %eax
  8004ae:	e8 b4 1a 00 00       	call   801f67 <dup>
					close(p[1]);
  8004b3:	83 c4 04             	add    $0x4,%esp
  8004b6:	ff b5 a0 fb ff ff    	pushl  -0x460(%ebp)
  8004bc:	e8 56 1a 00 00       	call   801f17 <close>
  8004c1:	83 c4 10             	add    $0x10,%esp
  8004c4:	eb 8a                	jmp    800450 <runcmd+0x252>
			panic("bad return %d from gettoken", c);
  8004c6:	53                   	push   %ebx
  8004c7:	68 5a 39 80 00       	push   $0x80395a
  8004cc:	6a 77                	push   $0x77
  8004ce:	68 76 39 80 00       	push   $0x803976
  8004d3:	e8 a3 05 00 00       	call   800a7b <_panic>
	if (argv[0][0] != '/') {
  8004d8:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8004db:	80 38 2f             	cmpb   $0x2f,(%eax)
  8004de:	0f 85 86 00 00 00    	jne    80056a <runcmd+0x36c>
	argv[argc] = 0;
  8004e4:	c7 44 bd a8 00 00 00 	movl   $0x0,-0x58(%ebp,%edi,4)
  8004eb:	00 
	if (debug) {
  8004ec:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8004f3:	0f 85 99 00 00 00    	jne    800592 <runcmd+0x394>
	if ((r = spawn(argv[0], (const char**) argv)) < 0)
  8004f9:	83 ec 08             	sub    $0x8,%esp
  8004fc:	8d 45 a8             	lea    -0x58(%ebp),%eax
  8004ff:	50                   	push   %eax
  800500:	ff 75 a8             	pushl  -0x58(%ebp)
  800503:	e8 a9 21 00 00       	call   8026b1 <spawn>
  800508:	89 c6                	mov    %eax,%esi
  80050a:	83 c4 10             	add    $0x10,%esp
  80050d:	85 c0                	test   %eax,%eax
  80050f:	0f 88 cb 00 00 00    	js     8005e0 <runcmd+0x3e2>
	close_all();
  800515:	e8 28 1a 00 00       	call   801f42 <close_all>
		if (debug)
  80051a:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  800521:	0f 85 06 01 00 00    	jne    80062d <runcmd+0x42f>
		wait(r);
  800527:	83 ec 0c             	sub    $0xc,%esp
  80052a:	56                   	push   %esi
  80052b:	e8 c3 2a 00 00       	call   802ff3 <wait>
		if (debug)
  800530:	83 c4 10             	add    $0x10,%esp
  800533:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  80053a:	0f 85 0c 01 00 00    	jne    80064c <runcmd+0x44e>
	if (pipe_child) {
  800540:	85 db                	test   %ebx,%ebx
  800542:	74 19                	je     80055d <runcmd+0x35f>
		wait(pipe_child);
  800544:	83 ec 0c             	sub    $0xc,%esp
  800547:	53                   	push   %ebx
  800548:	e8 a6 2a 00 00       	call   802ff3 <wait>
		if (debug)
  80054d:	83 c4 10             	add    $0x10,%esp
  800550:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  800557:	0f 85 0a 01 00 00    	jne    800667 <runcmd+0x469>
	exit();
  80055d:	e8 ff 04 00 00       	call   800a61 <exit>
}
  800562:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800565:	5b                   	pop    %ebx
  800566:	5e                   	pop    %esi
  800567:	5f                   	pop    %edi
  800568:	5d                   	pop    %ebp
  800569:	c3                   	ret    
		argv0buf[0] = '/';
  80056a:	c6 85 a4 fb ff ff 2f 	movb   $0x2f,-0x45c(%ebp)
		strcpy(argv0buf + 1, argv[0]);
  800571:	83 ec 08             	sub    $0x8,%esp
  800574:	50                   	push   %eax
  800575:	8d b5 a4 fb ff ff    	lea    -0x45c(%ebp),%esi
  80057b:	8d 85 a5 fb ff ff    	lea    -0x45b(%ebp),%eax
  800581:	50                   	push   %eax
  800582:	e8 5c 0d 00 00       	call   8012e3 <strcpy>
		argv[0] = argv0buf;
  800587:	89 75 a8             	mov    %esi,-0x58(%ebp)
  80058a:	83 c4 10             	add    $0x10,%esp
  80058d:	e9 52 ff ff ff       	jmp    8004e4 <runcmd+0x2e6>
		cprintf("[%08x] SPAWN:", thisenv->env_id);
  800592:	a1 28 64 80 00       	mov    0x806428,%eax
  800597:	8b 40 48             	mov    0x48(%eax),%eax
  80059a:	83 ec 08             	sub    $0x8,%esp
  80059d:	50                   	push   %eax
  80059e:	68 8f 39 80 00       	push   $0x80398f
  8005a3:	e8 ae 05 00 00       	call   800b56 <cprintf>
  8005a8:	8d 75 a8             	lea    -0x58(%ebp),%esi
		for (i = 0; argv[i]; i++)
  8005ab:	83 c4 10             	add    $0x10,%esp
  8005ae:	83 c6 04             	add    $0x4,%esi
  8005b1:	8b 46 fc             	mov    -0x4(%esi),%eax
  8005b4:	85 c0                	test   %eax,%eax
  8005b6:	74 13                	je     8005cb <runcmd+0x3cd>
			cprintf(" %s", argv[i]);
  8005b8:	83 ec 08             	sub    $0x8,%esp
  8005bb:	50                   	push   %eax
  8005bc:	68 17 3a 80 00       	push   $0x803a17
  8005c1:	e8 90 05 00 00       	call   800b56 <cprintf>
  8005c6:	83 c4 10             	add    $0x10,%esp
  8005c9:	eb e3                	jmp    8005ae <runcmd+0x3b0>
		cprintf("\n");
  8005cb:	83 ec 0c             	sub    $0xc,%esp
  8005ce:	68 e0 38 80 00       	push   $0x8038e0
  8005d3:	e8 7e 05 00 00       	call   800b56 <cprintf>
  8005d8:	83 c4 10             	add    $0x10,%esp
  8005db:	e9 19 ff ff ff       	jmp    8004f9 <runcmd+0x2fb>
		cprintf("spawn %s: %e\n", argv[0], r);
  8005e0:	83 ec 04             	sub    $0x4,%esp
  8005e3:	50                   	push   %eax
  8005e4:	ff 75 a8             	pushl  -0x58(%ebp)
  8005e7:	68 9d 39 80 00       	push   $0x80399d
  8005ec:	e8 65 05 00 00       	call   800b56 <cprintf>
	close_all();
  8005f1:	e8 4c 19 00 00       	call   801f42 <close_all>
  8005f6:	83 c4 10             	add    $0x10,%esp
	if (pipe_child) {
  8005f9:	85 db                	test   %ebx,%ebx
  8005fb:	0f 84 5c ff ff ff    	je     80055d <runcmd+0x35f>
		if (debug)
  800601:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  800608:	0f 84 36 ff ff ff    	je     800544 <runcmd+0x346>
			cprintf("[%08x] WAIT pipe_child %08x\n", thisenv->env_id, pipe_child);
  80060e:	a1 28 64 80 00       	mov    0x806428,%eax
  800613:	8b 40 48             	mov    0x48(%eax),%eax
  800616:	83 ec 04             	sub    $0x4,%esp
  800619:	53                   	push   %ebx
  80061a:	50                   	push   %eax
  80061b:	68 d6 39 80 00       	push   $0x8039d6
  800620:	e8 31 05 00 00       	call   800b56 <cprintf>
  800625:	83 c4 10             	add    $0x10,%esp
  800628:	e9 17 ff ff ff       	jmp    800544 <runcmd+0x346>
			cprintf("[%08x] WAIT %s %08x\n", thisenv->env_id, argv[0], r);
  80062d:	a1 28 64 80 00       	mov    0x806428,%eax
  800632:	8b 40 48             	mov    0x48(%eax),%eax
  800635:	56                   	push   %esi
  800636:	ff 75 a8             	pushl  -0x58(%ebp)
  800639:	50                   	push   %eax
  80063a:	68 ab 39 80 00       	push   $0x8039ab
  80063f:	e8 12 05 00 00       	call   800b56 <cprintf>
  800644:	83 c4 10             	add    $0x10,%esp
  800647:	e9 db fe ff ff       	jmp    800527 <runcmd+0x329>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
  80064c:	a1 28 64 80 00       	mov    0x806428,%eax
  800651:	8b 40 48             	mov    0x48(%eax),%eax
  800654:	83 ec 08             	sub    $0x8,%esp
  800657:	50                   	push   %eax
  800658:	68 c0 39 80 00       	push   $0x8039c0
  80065d:	e8 f4 04 00 00       	call   800b56 <cprintf>
  800662:	83 c4 10             	add    $0x10,%esp
  800665:	eb 92                	jmp    8005f9 <runcmd+0x3fb>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
  800667:	a1 28 64 80 00       	mov    0x806428,%eax
  80066c:	8b 40 48             	mov    0x48(%eax),%eax
  80066f:	83 ec 08             	sub    $0x8,%esp
  800672:	50                   	push   %eax
  800673:	68 c0 39 80 00       	push   $0x8039c0
  800678:	e8 d9 04 00 00       	call   800b56 <cprintf>
  80067d:	83 c4 10             	add    $0x10,%esp
  800680:	e9 d8 fe ff ff       	jmp    80055d <runcmd+0x35f>

00800685 <usage>:


void
usage(void)
{
  800685:	55                   	push   %ebp
  800686:	89 e5                	mov    %esp,%ebp
  800688:	83 ec 14             	sub    $0x14,%esp
	cprintf("usage: sh [-dix] [command-file]\n");
  80068b:	68 a0 3a 80 00       	push   $0x803aa0
  800690:	e8 c1 04 00 00       	call   800b56 <cprintf>
	exit();
  800695:	e8 c7 03 00 00       	call   800a61 <exit>
}
  80069a:	83 c4 10             	add    $0x10,%esp
  80069d:	c9                   	leave  
  80069e:	c3                   	ret    

0080069f <umain>:

void
umain(int argc, char **argv)
{
  80069f:	55                   	push   %ebp
  8006a0:	89 e5                	mov    %esp,%ebp
  8006a2:	57                   	push   %edi
  8006a3:	56                   	push   %esi
  8006a4:	53                   	push   %ebx
  8006a5:	83 ec 30             	sub    $0x30,%esp
	int r, interactive, echocmds;
	struct Argstate args;

	interactive = '?';
	echocmds = 0;
	argstart(&argc, argv, &args);
  8006a8:	8d 45 d8             	lea    -0x28(%ebp),%eax
  8006ab:	50                   	push   %eax
  8006ac:	ff 75 0c             	pushl  0xc(%ebp)
  8006af:	8d 45 08             	lea    0x8(%ebp),%eax
  8006b2:	50                   	push   %eax
  8006b3:	e8 60 15 00 00       	call   801c18 <argstart>
	while ((r = argnext(&args)) >= 0)
  8006b8:	83 c4 10             	add    $0x10,%esp
	echocmds = 0;
  8006bb:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
	interactive = '?';
  8006c2:	bf 3f 00 00 00       	mov    $0x3f,%edi
	while ((r = argnext(&args)) >= 0)
  8006c7:	8d 5d d8             	lea    -0x28(%ebp),%ebx
		switch (r) {
		case 'd':
			debug++;
			break;
		case 'i':
			interactive = 1;
  8006ca:	be 01 00 00 00       	mov    $0x1,%esi
	while ((r = argnext(&args)) >= 0)
  8006cf:	eb 03                	jmp    8006d4 <umain+0x35>
			break;
		case 'x':
			echocmds = 1;
  8006d1:	89 75 d4             	mov    %esi,-0x2c(%ebp)
	while ((r = argnext(&args)) >= 0)
  8006d4:	83 ec 0c             	sub    $0xc,%esp
  8006d7:	53                   	push   %ebx
  8006d8:	e8 6b 15 00 00       	call   801c48 <argnext>
  8006dd:	83 c4 10             	add    $0x10,%esp
  8006e0:	85 c0                	test   %eax,%eax
  8006e2:	78 23                	js     800707 <umain+0x68>
		switch (r) {
  8006e4:	83 f8 69             	cmp    $0x69,%eax
  8006e7:	74 1a                	je     800703 <umain+0x64>
  8006e9:	83 f8 78             	cmp    $0x78,%eax
  8006ec:	74 e3                	je     8006d1 <umain+0x32>
  8006ee:	83 f8 64             	cmp    $0x64,%eax
  8006f1:	74 07                	je     8006fa <umain+0x5b>
			break;
		default:
			usage();
  8006f3:	e8 8d ff ff ff       	call   800685 <usage>
  8006f8:	eb da                	jmp    8006d4 <umain+0x35>
			debug++;
  8006fa:	83 05 00 60 80 00 01 	addl   $0x1,0x806000
			break;
  800701:	eb d1                	jmp    8006d4 <umain+0x35>
			interactive = 1;
  800703:	89 f7                	mov    %esi,%edi
  800705:	eb cd                	jmp    8006d4 <umain+0x35>
		}

	if (argc > 2)
  800707:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
  80070b:	7f 1f                	jg     80072c <umain+0x8d>
		usage();
	if (argc == 2) {
  80070d:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
  800711:	74 20                	je     800733 <umain+0x94>
		close(0);
		if ((r = open(argv[1], O_RDONLY)) < 0)
			panic("open %s: %e", argv[1], r);
		assert(r == 0);
	}
	if (interactive == '?')
  800713:	83 ff 3f             	cmp    $0x3f,%edi
  800716:	74 77                	je     80078f <umain+0xf0>
  800718:	85 ff                	test   %edi,%edi
  80071a:	bf 1b 3a 80 00       	mov    $0x803a1b,%edi
  80071f:	b8 00 00 00 00       	mov    $0x0,%eax
  800724:	0f 44 f8             	cmove  %eax,%edi
  800727:	e9 08 01 00 00       	jmp    800834 <umain+0x195>
		usage();
  80072c:	e8 54 ff ff ff       	call   800685 <usage>
  800731:	eb da                	jmp    80070d <umain+0x6e>
		close(0);
  800733:	83 ec 0c             	sub    $0xc,%esp
  800736:	6a 00                	push   $0x0
  800738:	e8 da 17 00 00       	call   801f17 <close>
		if ((r = open(argv[1], O_RDONLY)) < 0)
  80073d:	83 c4 08             	add    $0x8,%esp
  800740:	6a 00                	push   $0x0
  800742:	8b 45 0c             	mov    0xc(%ebp),%eax
  800745:	ff 70 04             	pushl  0x4(%eax)
  800748:	e8 aa 1d 00 00       	call   8024f7 <open>
  80074d:	83 c4 10             	add    $0x10,%esp
  800750:	85 c0                	test   %eax,%eax
  800752:	78 1d                	js     800771 <umain+0xd2>
		assert(r == 0);
  800754:	85 c0                	test   %eax,%eax
  800756:	74 bb                	je     800713 <umain+0x74>
  800758:	68 ff 39 80 00       	push   $0x8039ff
  80075d:	68 06 3a 80 00       	push   $0x803a06
  800762:	68 28 01 00 00       	push   $0x128
  800767:	68 76 39 80 00       	push   $0x803976
  80076c:	e8 0a 03 00 00       	call   800a7b <_panic>
			panic("open %s: %e", argv[1], r);
  800771:	83 ec 0c             	sub    $0xc,%esp
  800774:	50                   	push   %eax
  800775:	8b 45 0c             	mov    0xc(%ebp),%eax
  800778:	ff 70 04             	pushl  0x4(%eax)
  80077b:	68 f3 39 80 00       	push   $0x8039f3
  800780:	68 27 01 00 00       	push   $0x127
  800785:	68 76 39 80 00       	push   $0x803976
  80078a:	e8 ec 02 00 00       	call   800a7b <_panic>
		interactive = iscons(0);
  80078f:	83 ec 0c             	sub    $0xc,%esp
  800792:	6a 00                	push   $0x0
  800794:	e8 04 02 00 00       	call   80099d <iscons>
  800799:	89 c7                	mov    %eax,%edi
  80079b:	83 c4 10             	add    $0x10,%esp
  80079e:	e9 75 ff ff ff       	jmp    800718 <umain+0x79>
	while (1) {
		char *buf;

		buf = readline(interactive ? "$ " : NULL);
		if (buf == NULL) {
			if (debug)
  8007a3:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8007aa:	75 0a                	jne    8007b6 <umain+0x117>
				cprintf("EXITING\n");
			exit();	// end of file
  8007ac:	e8 b0 02 00 00       	call   800a61 <exit>
  8007b1:	e9 94 00 00 00       	jmp    80084a <umain+0x1ab>
				cprintf("EXITING\n");
  8007b6:	83 ec 0c             	sub    $0xc,%esp
  8007b9:	68 1e 3a 80 00       	push   $0x803a1e
  8007be:	e8 93 03 00 00       	call   800b56 <cprintf>
  8007c3:	83 c4 10             	add    $0x10,%esp
  8007c6:	eb e4                	jmp    8007ac <umain+0x10d>
		}
		if (debug)
			cprintf("LINE: %s\n", buf);
  8007c8:	83 ec 08             	sub    $0x8,%esp
  8007cb:	53                   	push   %ebx
  8007cc:	68 27 3a 80 00       	push   $0x803a27
  8007d1:	e8 80 03 00 00       	call   800b56 <cprintf>
  8007d6:	83 c4 10             	add    $0x10,%esp
  8007d9:	eb 7c                	jmp    800857 <umain+0x1b8>
		if (buf[0] == '#')
			continue;
		if (echocmds)
			printf("# %s\n", buf);
  8007db:	83 ec 08             	sub    $0x8,%esp
  8007de:	53                   	push   %ebx
  8007df:	68 31 3a 80 00       	push   $0x803a31
  8007e4:	e8 b2 1e 00 00       	call   80269b <printf>
  8007e9:	83 c4 10             	add    $0x10,%esp
  8007ec:	eb 78                	jmp    800866 <umain+0x1c7>
		if (debug)
			cprintf("BEFORE FORK\n");
  8007ee:	83 ec 0c             	sub    $0xc,%esp
  8007f1:	68 37 3a 80 00       	push   $0x803a37
  8007f6:	e8 5b 03 00 00       	call   800b56 <cprintf>
  8007fb:	83 c4 10             	add    $0x10,%esp
  8007fe:	eb 73                	jmp    800873 <umain+0x1d4>
		if ((r = fork()) < 0)
			panic("fork: %e", r);
  800800:	50                   	push   %eax
  800801:	68 76 3e 80 00       	push   $0x803e76
  800806:	68 3f 01 00 00       	push   $0x13f
  80080b:	68 76 39 80 00       	push   $0x803976
  800810:	e8 66 02 00 00       	call   800a7b <_panic>
		if (debug)
			cprintf("FORK: %d\n", r);
  800815:	83 ec 08             	sub    $0x8,%esp
  800818:	50                   	push   %eax
  800819:	68 44 3a 80 00       	push   $0x803a44
  80081e:	e8 33 03 00 00       	call   800b56 <cprintf>
  800823:	83 c4 10             	add    $0x10,%esp
  800826:	eb 5f                	jmp    800887 <umain+0x1e8>
		if (r == 0) {
			runcmd(buf);
			exit();
		} else
			wait(r);
  800828:	83 ec 0c             	sub    $0xc,%esp
  80082b:	56                   	push   %esi
  80082c:	e8 c2 27 00 00       	call   802ff3 <wait>
  800831:	83 c4 10             	add    $0x10,%esp
		buf = readline(interactive ? "$ " : NULL);
  800834:	83 ec 0c             	sub    $0xc,%esp
  800837:	57                   	push   %edi
  800838:	e8 7f 09 00 00       	call   8011bc <readline>
  80083d:	89 c3                	mov    %eax,%ebx
		if (buf == NULL) {
  80083f:	83 c4 10             	add    $0x10,%esp
  800842:	85 c0                	test   %eax,%eax
  800844:	0f 84 59 ff ff ff    	je     8007a3 <umain+0x104>
		if (debug)
  80084a:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  800851:	0f 85 71 ff ff ff    	jne    8007c8 <umain+0x129>
		if (buf[0] == '#')
  800857:	80 3b 23             	cmpb   $0x23,(%ebx)
  80085a:	74 d8                	je     800834 <umain+0x195>
		if (echocmds)
  80085c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800860:	0f 85 75 ff ff ff    	jne    8007db <umain+0x13c>
		if (debug)
  800866:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  80086d:	0f 85 7b ff ff ff    	jne    8007ee <umain+0x14f>
		if ((r = fork()) < 0)
  800873:	e8 5e 11 00 00       	call   8019d6 <fork>
  800878:	89 c6                	mov    %eax,%esi
  80087a:	85 c0                	test   %eax,%eax
  80087c:	78 82                	js     800800 <umain+0x161>
		if (debug)
  80087e:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  800885:	75 8e                	jne    800815 <umain+0x176>
		if (r == 0) {
  800887:	85 f6                	test   %esi,%esi
  800889:	75 9d                	jne    800828 <umain+0x189>
			runcmd(buf);
  80088b:	83 ec 0c             	sub    $0xc,%esp
  80088e:	53                   	push   %ebx
  80088f:	e8 6a f9 ff ff       	call   8001fe <runcmd>
			exit();
  800894:	e8 c8 01 00 00       	call   800a61 <exit>
  800899:	83 c4 10             	add    $0x10,%esp
  80089c:	eb 96                	jmp    800834 <umain+0x195>

0080089e <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  80089e:	55                   	push   %ebp
  80089f:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8008a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8008a6:	5d                   	pop    %ebp
  8008a7:	c3                   	ret    

008008a8 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8008a8:	55                   	push   %ebp
  8008a9:	89 e5                	mov    %esp,%ebp
  8008ab:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8008ae:	68 c1 3a 80 00       	push   $0x803ac1
  8008b3:	ff 75 0c             	pushl  0xc(%ebp)
  8008b6:	e8 28 0a 00 00       	call   8012e3 <strcpy>
	return 0;
}
  8008bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8008c0:	c9                   	leave  
  8008c1:	c3                   	ret    

008008c2 <devcons_write>:
{
  8008c2:	55                   	push   %ebp
  8008c3:	89 e5                	mov    %esp,%ebp
  8008c5:	57                   	push   %edi
  8008c6:	56                   	push   %esi
  8008c7:	53                   	push   %ebx
  8008c8:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8008ce:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8008d3:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8008d9:	eb 2f                	jmp    80090a <devcons_write+0x48>
		m = n - tot;
  8008db:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8008de:	29 f3                	sub    %esi,%ebx
  8008e0:	83 fb 7f             	cmp    $0x7f,%ebx
  8008e3:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8008e8:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8008eb:	83 ec 04             	sub    $0x4,%esp
  8008ee:	53                   	push   %ebx
  8008ef:	89 f0                	mov    %esi,%eax
  8008f1:	03 45 0c             	add    0xc(%ebp),%eax
  8008f4:	50                   	push   %eax
  8008f5:	57                   	push   %edi
  8008f6:	e8 76 0b 00 00       	call   801471 <memmove>
		sys_cputs(buf, m);
  8008fb:	83 c4 08             	add    $0x8,%esp
  8008fe:	53                   	push   %ebx
  8008ff:	57                   	push   %edi
  800900:	e8 1b 0d 00 00       	call   801620 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  800905:	01 de                	add    %ebx,%esi
  800907:	83 c4 10             	add    $0x10,%esp
  80090a:	3b 75 10             	cmp    0x10(%ebp),%esi
  80090d:	72 cc                	jb     8008db <devcons_write+0x19>
}
  80090f:	89 f0                	mov    %esi,%eax
  800911:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800914:	5b                   	pop    %ebx
  800915:	5e                   	pop    %esi
  800916:	5f                   	pop    %edi
  800917:	5d                   	pop    %ebp
  800918:	c3                   	ret    

00800919 <devcons_read>:
{
  800919:	55                   	push   %ebp
  80091a:	89 e5                	mov    %esp,%ebp
  80091c:	83 ec 08             	sub    $0x8,%esp
  80091f:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  800924:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800928:	75 07                	jne    800931 <devcons_read+0x18>
}
  80092a:	c9                   	leave  
  80092b:	c3                   	ret    
		sys_yield();
  80092c:	e8 8c 0d 00 00       	call   8016bd <sys_yield>
	while ((c = sys_cgetc()) == 0)
  800931:	e8 08 0d 00 00       	call   80163e <sys_cgetc>
  800936:	85 c0                	test   %eax,%eax
  800938:	74 f2                	je     80092c <devcons_read+0x13>
	if (c < 0)
  80093a:	85 c0                	test   %eax,%eax
  80093c:	78 ec                	js     80092a <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  80093e:	83 f8 04             	cmp    $0x4,%eax
  800941:	74 0c                	je     80094f <devcons_read+0x36>
	*(char*)vbuf = c;
  800943:	8b 55 0c             	mov    0xc(%ebp),%edx
  800946:	88 02                	mov    %al,(%edx)
	return 1;
  800948:	b8 01 00 00 00       	mov    $0x1,%eax
  80094d:	eb db                	jmp    80092a <devcons_read+0x11>
		return 0;
  80094f:	b8 00 00 00 00       	mov    $0x0,%eax
  800954:	eb d4                	jmp    80092a <devcons_read+0x11>

00800956 <cputchar>:
{
  800956:	55                   	push   %ebp
  800957:	89 e5                	mov    %esp,%ebp
  800959:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80095c:	8b 45 08             	mov    0x8(%ebp),%eax
  80095f:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  800962:	6a 01                	push   $0x1
  800964:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800967:	50                   	push   %eax
  800968:	e8 b3 0c 00 00       	call   801620 <sys_cputs>
}
  80096d:	83 c4 10             	add    $0x10,%esp
  800970:	c9                   	leave  
  800971:	c3                   	ret    

00800972 <getchar>:
{
  800972:	55                   	push   %ebp
  800973:	89 e5                	mov    %esp,%ebp
  800975:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  800978:	6a 01                	push   $0x1
  80097a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80097d:	50                   	push   %eax
  80097e:	6a 00                	push   $0x0
  800980:	e8 ce 16 00 00       	call   802053 <read>
	if (r < 0)
  800985:	83 c4 10             	add    $0x10,%esp
  800988:	85 c0                	test   %eax,%eax
  80098a:	78 08                	js     800994 <getchar+0x22>
	if (r < 1)
  80098c:	85 c0                	test   %eax,%eax
  80098e:	7e 06                	jle    800996 <getchar+0x24>
	return c;
  800990:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  800994:	c9                   	leave  
  800995:	c3                   	ret    
		return -E_EOF;
  800996:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80099b:	eb f7                	jmp    800994 <getchar+0x22>

0080099d <iscons>:
{
  80099d:	55                   	push   %ebp
  80099e:	89 e5                	mov    %esp,%ebp
  8009a0:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8009a3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8009a6:	50                   	push   %eax
  8009a7:	ff 75 08             	pushl  0x8(%ebp)
  8009aa:	e8 33 14 00 00       	call   801de2 <fd_lookup>
  8009af:	83 c4 10             	add    $0x10,%esp
  8009b2:	85 c0                	test   %eax,%eax
  8009b4:	78 11                	js     8009c7 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8009b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009b9:	8b 15 00 50 80 00    	mov    0x805000,%edx
  8009bf:	39 10                	cmp    %edx,(%eax)
  8009c1:	0f 94 c0             	sete   %al
  8009c4:	0f b6 c0             	movzbl %al,%eax
}
  8009c7:	c9                   	leave  
  8009c8:	c3                   	ret    

008009c9 <opencons>:
{
  8009c9:	55                   	push   %ebp
  8009ca:	89 e5                	mov    %esp,%ebp
  8009cc:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8009cf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8009d2:	50                   	push   %eax
  8009d3:	e8 bb 13 00 00       	call   801d93 <fd_alloc>
  8009d8:	83 c4 10             	add    $0x10,%esp
  8009db:	85 c0                	test   %eax,%eax
  8009dd:	78 3a                	js     800a19 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8009df:	83 ec 04             	sub    $0x4,%esp
  8009e2:	68 07 04 00 00       	push   $0x407
  8009e7:	ff 75 f4             	pushl  -0xc(%ebp)
  8009ea:	6a 00                	push   $0x0
  8009ec:	e8 eb 0c 00 00       	call   8016dc <sys_page_alloc>
  8009f1:	83 c4 10             	add    $0x10,%esp
  8009f4:	85 c0                	test   %eax,%eax
  8009f6:	78 21                	js     800a19 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8009f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009fb:	8b 15 00 50 80 00    	mov    0x805000,%edx
  800a01:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  800a03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a06:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  800a0d:	83 ec 0c             	sub    $0xc,%esp
  800a10:	50                   	push   %eax
  800a11:	e8 56 13 00 00       	call   801d6c <fd2num>
  800a16:	83 c4 10             	add    $0x10,%esp
}
  800a19:	c9                   	leave  
  800a1a:	c3                   	ret    

00800a1b <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800a1b:	55                   	push   %ebp
  800a1c:	89 e5                	mov    %esp,%ebp
  800a1e:	56                   	push   %esi
  800a1f:	53                   	push   %ebx
  800a20:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800a23:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
    thisenv = &envs[ENVX(sys_getenvid())];
  800a26:	e8 73 0c 00 00       	call   80169e <sys_getenvid>
  800a2b:	25 ff 03 00 00       	and    $0x3ff,%eax
  800a30:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800a33:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800a38:	a3 28 64 80 00       	mov    %eax,0x806428

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800a3d:	85 db                	test   %ebx,%ebx
  800a3f:	7e 07                	jle    800a48 <libmain+0x2d>
		binaryname = argv[0];
  800a41:	8b 06                	mov    (%esi),%eax
  800a43:	a3 1c 50 80 00       	mov    %eax,0x80501c

	// call user main routine
	umain(argc, argv);
  800a48:	83 ec 08             	sub    $0x8,%esp
  800a4b:	56                   	push   %esi
  800a4c:	53                   	push   %ebx
  800a4d:	e8 4d fc ff ff       	call   80069f <umain>

	// exit gracefully
	exit();
  800a52:	e8 0a 00 00 00       	call   800a61 <exit>
}
  800a57:	83 c4 10             	add    $0x10,%esp
  800a5a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a5d:	5b                   	pop    %ebx
  800a5e:	5e                   	pop    %esi
  800a5f:	5d                   	pop    %ebp
  800a60:	c3                   	ret    

00800a61 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800a61:	55                   	push   %ebp
  800a62:	89 e5                	mov    %esp,%ebp
  800a64:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800a67:	e8 d6 14 00 00       	call   801f42 <close_all>
	sys_env_destroy(0);
  800a6c:	83 ec 0c             	sub    $0xc,%esp
  800a6f:	6a 00                	push   $0x0
  800a71:	e8 e7 0b 00 00       	call   80165d <sys_env_destroy>
}
  800a76:	83 c4 10             	add    $0x10,%esp
  800a79:	c9                   	leave  
  800a7a:	c3                   	ret    

00800a7b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800a7b:	55                   	push   %ebp
  800a7c:	89 e5                	mov    %esp,%ebp
  800a7e:	56                   	push   %esi
  800a7f:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800a80:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800a83:	8b 35 1c 50 80 00    	mov    0x80501c,%esi
  800a89:	e8 10 0c 00 00       	call   80169e <sys_getenvid>
  800a8e:	83 ec 0c             	sub    $0xc,%esp
  800a91:	ff 75 0c             	pushl  0xc(%ebp)
  800a94:	ff 75 08             	pushl  0x8(%ebp)
  800a97:	56                   	push   %esi
  800a98:	50                   	push   %eax
  800a99:	68 d8 3a 80 00       	push   $0x803ad8
  800a9e:	e8 b3 00 00 00       	call   800b56 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800aa3:	83 c4 18             	add    $0x18,%esp
  800aa6:	53                   	push   %ebx
  800aa7:	ff 75 10             	pushl  0x10(%ebp)
  800aaa:	e8 56 00 00 00       	call   800b05 <vcprintf>
	cprintf("\n");
  800aaf:	c7 04 24 e0 38 80 00 	movl   $0x8038e0,(%esp)
  800ab6:	e8 9b 00 00 00       	call   800b56 <cprintf>
  800abb:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800abe:	cc                   	int3   
  800abf:	eb fd                	jmp    800abe <_panic+0x43>

00800ac1 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800ac1:	55                   	push   %ebp
  800ac2:	89 e5                	mov    %esp,%ebp
  800ac4:	53                   	push   %ebx
  800ac5:	83 ec 04             	sub    $0x4,%esp
  800ac8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800acb:	8b 13                	mov    (%ebx),%edx
  800acd:	8d 42 01             	lea    0x1(%edx),%eax
  800ad0:	89 03                	mov    %eax,(%ebx)
  800ad2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ad5:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800ad9:	3d ff 00 00 00       	cmp    $0xff,%eax
  800ade:	74 09                	je     800ae9 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800ae0:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800ae4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ae7:	c9                   	leave  
  800ae8:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800ae9:	83 ec 08             	sub    $0x8,%esp
  800aec:	68 ff 00 00 00       	push   $0xff
  800af1:	8d 43 08             	lea    0x8(%ebx),%eax
  800af4:	50                   	push   %eax
  800af5:	e8 26 0b 00 00       	call   801620 <sys_cputs>
		b->idx = 0;
  800afa:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800b00:	83 c4 10             	add    $0x10,%esp
  800b03:	eb db                	jmp    800ae0 <putch+0x1f>

00800b05 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800b05:	55                   	push   %ebp
  800b06:	89 e5                	mov    %esp,%ebp
  800b08:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800b0e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800b15:	00 00 00 
	b.cnt = 0;
  800b18:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b1f:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800b22:	ff 75 0c             	pushl  0xc(%ebp)
  800b25:	ff 75 08             	pushl  0x8(%ebp)
  800b28:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b2e:	50                   	push   %eax
  800b2f:	68 c1 0a 80 00       	push   $0x800ac1
  800b34:	e8 1a 01 00 00       	call   800c53 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800b39:	83 c4 08             	add    $0x8,%esp
  800b3c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800b42:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800b48:	50                   	push   %eax
  800b49:	e8 d2 0a 00 00       	call   801620 <sys_cputs>

	return b.cnt;
}
  800b4e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800b54:	c9                   	leave  
  800b55:	c3                   	ret    

00800b56 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800b56:	55                   	push   %ebp
  800b57:	89 e5                	mov    %esp,%ebp
  800b59:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800b5c:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800b5f:	50                   	push   %eax
  800b60:	ff 75 08             	pushl  0x8(%ebp)
  800b63:	e8 9d ff ff ff       	call   800b05 <vcprintf>
	va_end(ap);

	return cnt;
}
  800b68:	c9                   	leave  
  800b69:	c3                   	ret    

00800b6a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800b6a:	55                   	push   %ebp
  800b6b:	89 e5                	mov    %esp,%ebp
  800b6d:	57                   	push   %edi
  800b6e:	56                   	push   %esi
  800b6f:	53                   	push   %ebx
  800b70:	83 ec 1c             	sub    $0x1c,%esp
  800b73:	89 c7                	mov    %eax,%edi
  800b75:	89 d6                	mov    %edx,%esi
  800b77:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b7d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b80:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800b83:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800b86:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b8b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800b8e:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800b91:	39 d3                	cmp    %edx,%ebx
  800b93:	72 05                	jb     800b9a <printnum+0x30>
  800b95:	39 45 10             	cmp    %eax,0x10(%ebp)
  800b98:	77 7a                	ja     800c14 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800b9a:	83 ec 0c             	sub    $0xc,%esp
  800b9d:	ff 75 18             	pushl  0x18(%ebp)
  800ba0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ba3:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800ba6:	53                   	push   %ebx
  800ba7:	ff 75 10             	pushl  0x10(%ebp)
  800baa:	83 ec 08             	sub    $0x8,%esp
  800bad:	ff 75 e4             	pushl  -0x1c(%ebp)
  800bb0:	ff 75 e0             	pushl  -0x20(%ebp)
  800bb3:	ff 75 dc             	pushl  -0x24(%ebp)
  800bb6:	ff 75 d8             	pushl  -0x28(%ebp)
  800bb9:	e8 c2 2a 00 00       	call   803680 <__udivdi3>
  800bbe:	83 c4 18             	add    $0x18,%esp
  800bc1:	52                   	push   %edx
  800bc2:	50                   	push   %eax
  800bc3:	89 f2                	mov    %esi,%edx
  800bc5:	89 f8                	mov    %edi,%eax
  800bc7:	e8 9e ff ff ff       	call   800b6a <printnum>
  800bcc:	83 c4 20             	add    $0x20,%esp
  800bcf:	eb 13                	jmp    800be4 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800bd1:	83 ec 08             	sub    $0x8,%esp
  800bd4:	56                   	push   %esi
  800bd5:	ff 75 18             	pushl  0x18(%ebp)
  800bd8:	ff d7                	call   *%edi
  800bda:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800bdd:	83 eb 01             	sub    $0x1,%ebx
  800be0:	85 db                	test   %ebx,%ebx
  800be2:	7f ed                	jg     800bd1 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800be4:	83 ec 08             	sub    $0x8,%esp
  800be7:	56                   	push   %esi
  800be8:	83 ec 04             	sub    $0x4,%esp
  800beb:	ff 75 e4             	pushl  -0x1c(%ebp)
  800bee:	ff 75 e0             	pushl  -0x20(%ebp)
  800bf1:	ff 75 dc             	pushl  -0x24(%ebp)
  800bf4:	ff 75 d8             	pushl  -0x28(%ebp)
  800bf7:	e8 a4 2b 00 00       	call   8037a0 <__umoddi3>
  800bfc:	83 c4 14             	add    $0x14,%esp
  800bff:	0f be 80 fb 3a 80 00 	movsbl 0x803afb(%eax),%eax
  800c06:	50                   	push   %eax
  800c07:	ff d7                	call   *%edi
}
  800c09:	83 c4 10             	add    $0x10,%esp
  800c0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c0f:	5b                   	pop    %ebx
  800c10:	5e                   	pop    %esi
  800c11:	5f                   	pop    %edi
  800c12:	5d                   	pop    %ebp
  800c13:	c3                   	ret    
  800c14:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800c17:	eb c4                	jmp    800bdd <printnum+0x73>

00800c19 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c19:	55                   	push   %ebp
  800c1a:	89 e5                	mov    %esp,%ebp
  800c1c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800c1f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800c23:	8b 10                	mov    (%eax),%edx
  800c25:	3b 50 04             	cmp    0x4(%eax),%edx
  800c28:	73 0a                	jae    800c34 <sprintputch+0x1b>
		*b->buf++ = ch;
  800c2a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c2d:	89 08                	mov    %ecx,(%eax)
  800c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c32:	88 02                	mov    %al,(%edx)
}
  800c34:	5d                   	pop    %ebp
  800c35:	c3                   	ret    

00800c36 <printfmt>:
{
  800c36:	55                   	push   %ebp
  800c37:	89 e5                	mov    %esp,%ebp
  800c39:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800c3c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800c3f:	50                   	push   %eax
  800c40:	ff 75 10             	pushl  0x10(%ebp)
  800c43:	ff 75 0c             	pushl  0xc(%ebp)
  800c46:	ff 75 08             	pushl  0x8(%ebp)
  800c49:	e8 05 00 00 00       	call   800c53 <vprintfmt>
}
  800c4e:	83 c4 10             	add    $0x10,%esp
  800c51:	c9                   	leave  
  800c52:	c3                   	ret    

00800c53 <vprintfmt>:
{
  800c53:	55                   	push   %ebp
  800c54:	89 e5                	mov    %esp,%ebp
  800c56:	57                   	push   %edi
  800c57:	56                   	push   %esi
  800c58:	53                   	push   %ebx
  800c59:	83 ec 2c             	sub    $0x2c,%esp
  800c5c:	8b 75 08             	mov    0x8(%ebp),%esi
  800c5f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800c62:	8b 7d 10             	mov    0x10(%ebp),%edi
  800c65:	e9 21 04 00 00       	jmp    80108b <vprintfmt+0x438>
		padc = ' ';
  800c6a:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  800c6e:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800c75:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800c7c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800c83:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800c88:	8d 47 01             	lea    0x1(%edi),%eax
  800c8b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c8e:	0f b6 17             	movzbl (%edi),%edx
  800c91:	8d 42 dd             	lea    -0x23(%edx),%eax
  800c94:	3c 55                	cmp    $0x55,%al
  800c96:	0f 87 90 04 00 00    	ja     80112c <vprintfmt+0x4d9>
  800c9c:	0f b6 c0             	movzbl %al,%eax
  800c9f:	ff 24 85 40 3c 80 00 	jmp    *0x803c40(,%eax,4)
  800ca6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800ca9:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800cad:	eb d9                	jmp    800c88 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800caf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800cb2:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800cb6:	eb d0                	jmp    800c88 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800cb8:	0f b6 d2             	movzbl %dl,%edx
  800cbb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800cbe:	b8 00 00 00 00       	mov    $0x0,%eax
  800cc3:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800cc6:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800cc9:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800ccd:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800cd0:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800cd3:	83 f9 09             	cmp    $0x9,%ecx
  800cd6:	77 55                	ja     800d2d <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  800cd8:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800cdb:	eb e9                	jmp    800cc6 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  800cdd:	8b 45 14             	mov    0x14(%ebp),%eax
  800ce0:	8b 00                	mov    (%eax),%eax
  800ce2:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800ce5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ce8:	8d 40 04             	lea    0x4(%eax),%eax
  800ceb:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800cee:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800cf1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800cf5:	79 91                	jns    800c88 <vprintfmt+0x35>
				width = precision, precision = -1;
  800cf7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800cfa:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800cfd:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800d04:	eb 82                	jmp    800c88 <vprintfmt+0x35>
  800d06:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d09:	85 c0                	test   %eax,%eax
  800d0b:	ba 00 00 00 00       	mov    $0x0,%edx
  800d10:	0f 49 d0             	cmovns %eax,%edx
  800d13:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800d16:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800d19:	e9 6a ff ff ff       	jmp    800c88 <vprintfmt+0x35>
  800d1e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800d21:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800d28:	e9 5b ff ff ff       	jmp    800c88 <vprintfmt+0x35>
  800d2d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800d30:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800d33:	eb bc                	jmp    800cf1 <vprintfmt+0x9e>
			lflag++;
  800d35:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800d38:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800d3b:	e9 48 ff ff ff       	jmp    800c88 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800d40:	8b 45 14             	mov    0x14(%ebp),%eax
  800d43:	8d 78 04             	lea    0x4(%eax),%edi
  800d46:	83 ec 08             	sub    $0x8,%esp
  800d49:	53                   	push   %ebx
  800d4a:	ff 30                	pushl  (%eax)
  800d4c:	ff d6                	call   *%esi
			break;
  800d4e:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800d51:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800d54:	e9 2f 03 00 00       	jmp    801088 <vprintfmt+0x435>
			err = va_arg(ap, int);
  800d59:	8b 45 14             	mov    0x14(%ebp),%eax
  800d5c:	8d 78 04             	lea    0x4(%eax),%edi
  800d5f:	8b 00                	mov    (%eax),%eax
  800d61:	99                   	cltd   
  800d62:	31 d0                	xor    %edx,%eax
  800d64:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800d66:	83 f8 0f             	cmp    $0xf,%eax
  800d69:	7f 23                	jg     800d8e <vprintfmt+0x13b>
  800d6b:	8b 14 85 a0 3d 80 00 	mov    0x803da0(,%eax,4),%edx
  800d72:	85 d2                	test   %edx,%edx
  800d74:	74 18                	je     800d8e <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  800d76:	52                   	push   %edx
  800d77:	68 18 3a 80 00       	push   $0x803a18
  800d7c:	53                   	push   %ebx
  800d7d:	56                   	push   %esi
  800d7e:	e8 b3 fe ff ff       	call   800c36 <printfmt>
  800d83:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800d86:	89 7d 14             	mov    %edi,0x14(%ebp)
  800d89:	e9 fa 02 00 00       	jmp    801088 <vprintfmt+0x435>
				printfmt(putch, putdat, "error %d", err);
  800d8e:	50                   	push   %eax
  800d8f:	68 13 3b 80 00       	push   $0x803b13
  800d94:	53                   	push   %ebx
  800d95:	56                   	push   %esi
  800d96:	e8 9b fe ff ff       	call   800c36 <printfmt>
  800d9b:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800d9e:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800da1:	e9 e2 02 00 00       	jmp    801088 <vprintfmt+0x435>
			if ((p = va_arg(ap, char *)) == NULL)
  800da6:	8b 45 14             	mov    0x14(%ebp),%eax
  800da9:	83 c0 04             	add    $0x4,%eax
  800dac:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800daf:	8b 45 14             	mov    0x14(%ebp),%eax
  800db2:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800db4:	85 ff                	test   %edi,%edi
  800db6:	b8 0c 3b 80 00       	mov    $0x803b0c,%eax
  800dbb:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800dbe:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800dc2:	0f 8e bd 00 00 00    	jle    800e85 <vprintfmt+0x232>
  800dc8:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800dcc:	75 0e                	jne    800ddc <vprintfmt+0x189>
  800dce:	89 75 08             	mov    %esi,0x8(%ebp)
  800dd1:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800dd4:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800dd7:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800dda:	eb 6d                	jmp    800e49 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ddc:	83 ec 08             	sub    $0x8,%esp
  800ddf:	ff 75 d0             	pushl  -0x30(%ebp)
  800de2:	57                   	push   %edi
  800de3:	e8 dc 04 00 00       	call   8012c4 <strnlen>
  800de8:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800deb:	29 c1                	sub    %eax,%ecx
  800ded:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800df0:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800df3:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800df7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800dfa:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800dfd:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800dff:	eb 0f                	jmp    800e10 <vprintfmt+0x1bd>
					putch(padc, putdat);
  800e01:	83 ec 08             	sub    $0x8,%esp
  800e04:	53                   	push   %ebx
  800e05:	ff 75 e0             	pushl  -0x20(%ebp)
  800e08:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800e0a:	83 ef 01             	sub    $0x1,%edi
  800e0d:	83 c4 10             	add    $0x10,%esp
  800e10:	85 ff                	test   %edi,%edi
  800e12:	7f ed                	jg     800e01 <vprintfmt+0x1ae>
  800e14:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800e17:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800e1a:	85 c9                	test   %ecx,%ecx
  800e1c:	b8 00 00 00 00       	mov    $0x0,%eax
  800e21:	0f 49 c1             	cmovns %ecx,%eax
  800e24:	29 c1                	sub    %eax,%ecx
  800e26:	89 75 08             	mov    %esi,0x8(%ebp)
  800e29:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800e2c:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800e2f:	89 cb                	mov    %ecx,%ebx
  800e31:	eb 16                	jmp    800e49 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  800e33:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800e37:	75 31                	jne    800e6a <vprintfmt+0x217>
					putch(ch, putdat);
  800e39:	83 ec 08             	sub    $0x8,%esp
  800e3c:	ff 75 0c             	pushl  0xc(%ebp)
  800e3f:	50                   	push   %eax
  800e40:	ff 55 08             	call   *0x8(%ebp)
  800e43:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e46:	83 eb 01             	sub    $0x1,%ebx
  800e49:	83 c7 01             	add    $0x1,%edi
  800e4c:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800e50:	0f be c2             	movsbl %dl,%eax
  800e53:	85 c0                	test   %eax,%eax
  800e55:	74 59                	je     800eb0 <vprintfmt+0x25d>
  800e57:	85 f6                	test   %esi,%esi
  800e59:	78 d8                	js     800e33 <vprintfmt+0x1e0>
  800e5b:	83 ee 01             	sub    $0x1,%esi
  800e5e:	79 d3                	jns    800e33 <vprintfmt+0x1e0>
  800e60:	89 df                	mov    %ebx,%edi
  800e62:	8b 75 08             	mov    0x8(%ebp),%esi
  800e65:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800e68:	eb 37                	jmp    800ea1 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  800e6a:	0f be d2             	movsbl %dl,%edx
  800e6d:	83 ea 20             	sub    $0x20,%edx
  800e70:	83 fa 5e             	cmp    $0x5e,%edx
  800e73:	76 c4                	jbe    800e39 <vprintfmt+0x1e6>
					putch('?', putdat);
  800e75:	83 ec 08             	sub    $0x8,%esp
  800e78:	ff 75 0c             	pushl  0xc(%ebp)
  800e7b:	6a 3f                	push   $0x3f
  800e7d:	ff 55 08             	call   *0x8(%ebp)
  800e80:	83 c4 10             	add    $0x10,%esp
  800e83:	eb c1                	jmp    800e46 <vprintfmt+0x1f3>
  800e85:	89 75 08             	mov    %esi,0x8(%ebp)
  800e88:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800e8b:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800e8e:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800e91:	eb b6                	jmp    800e49 <vprintfmt+0x1f6>
				putch(' ', putdat);
  800e93:	83 ec 08             	sub    $0x8,%esp
  800e96:	53                   	push   %ebx
  800e97:	6a 20                	push   $0x20
  800e99:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800e9b:	83 ef 01             	sub    $0x1,%edi
  800e9e:	83 c4 10             	add    $0x10,%esp
  800ea1:	85 ff                	test   %edi,%edi
  800ea3:	7f ee                	jg     800e93 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  800ea5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800ea8:	89 45 14             	mov    %eax,0x14(%ebp)
  800eab:	e9 d8 01 00 00       	jmp    801088 <vprintfmt+0x435>
  800eb0:	89 df                	mov    %ebx,%edi
  800eb2:	8b 75 08             	mov    0x8(%ebp),%esi
  800eb5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800eb8:	eb e7                	jmp    800ea1 <vprintfmt+0x24e>
	if (lflag >= 2)
  800eba:	83 f9 01             	cmp    $0x1,%ecx
  800ebd:	7e 45                	jle    800f04 <vprintfmt+0x2b1>
		return va_arg(*ap, long long);
  800ebf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ec2:	8b 50 04             	mov    0x4(%eax),%edx
  800ec5:	8b 00                	mov    (%eax),%eax
  800ec7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800eca:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800ecd:	8b 45 14             	mov    0x14(%ebp),%eax
  800ed0:	8d 40 08             	lea    0x8(%eax),%eax
  800ed3:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800ed6:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800eda:	79 62                	jns    800f3e <vprintfmt+0x2eb>
				putch('-', putdat);
  800edc:	83 ec 08             	sub    $0x8,%esp
  800edf:	53                   	push   %ebx
  800ee0:	6a 2d                	push   $0x2d
  800ee2:	ff d6                	call   *%esi
				num = -(long long) num;
  800ee4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800ee7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800eea:	f7 d8                	neg    %eax
  800eec:	83 d2 00             	adc    $0x0,%edx
  800eef:	f7 da                	neg    %edx
  800ef1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ef4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800ef7:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800efa:	ba 0a 00 00 00       	mov    $0xa,%edx
  800eff:	e9 66 01 00 00       	jmp    80106a <vprintfmt+0x417>
	else if (lflag)
  800f04:	85 c9                	test   %ecx,%ecx
  800f06:	75 1b                	jne    800f23 <vprintfmt+0x2d0>
		return va_arg(*ap, int);
  800f08:	8b 45 14             	mov    0x14(%ebp),%eax
  800f0b:	8b 00                	mov    (%eax),%eax
  800f0d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800f10:	89 c1                	mov    %eax,%ecx
  800f12:	c1 f9 1f             	sar    $0x1f,%ecx
  800f15:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800f18:	8b 45 14             	mov    0x14(%ebp),%eax
  800f1b:	8d 40 04             	lea    0x4(%eax),%eax
  800f1e:	89 45 14             	mov    %eax,0x14(%ebp)
  800f21:	eb b3                	jmp    800ed6 <vprintfmt+0x283>
		return va_arg(*ap, long);
  800f23:	8b 45 14             	mov    0x14(%ebp),%eax
  800f26:	8b 00                	mov    (%eax),%eax
  800f28:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800f2b:	89 c1                	mov    %eax,%ecx
  800f2d:	c1 f9 1f             	sar    $0x1f,%ecx
  800f30:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800f33:	8b 45 14             	mov    0x14(%ebp),%eax
  800f36:	8d 40 04             	lea    0x4(%eax),%eax
  800f39:	89 45 14             	mov    %eax,0x14(%ebp)
  800f3c:	eb 98                	jmp    800ed6 <vprintfmt+0x283>
			base = 10;
  800f3e:	ba 0a 00 00 00       	mov    $0xa,%edx
  800f43:	e9 22 01 00 00       	jmp    80106a <vprintfmt+0x417>
	if (lflag >= 2)
  800f48:	83 f9 01             	cmp    $0x1,%ecx
  800f4b:	7e 21                	jle    800f6e <vprintfmt+0x31b>
		return va_arg(*ap, unsigned long long);
  800f4d:	8b 45 14             	mov    0x14(%ebp),%eax
  800f50:	8b 50 04             	mov    0x4(%eax),%edx
  800f53:	8b 00                	mov    (%eax),%eax
  800f55:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800f58:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800f5b:	8b 45 14             	mov    0x14(%ebp),%eax
  800f5e:	8d 40 08             	lea    0x8(%eax),%eax
  800f61:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800f64:	ba 0a 00 00 00       	mov    $0xa,%edx
  800f69:	e9 fc 00 00 00       	jmp    80106a <vprintfmt+0x417>
	else if (lflag)
  800f6e:	85 c9                	test   %ecx,%ecx
  800f70:	75 23                	jne    800f95 <vprintfmt+0x342>
		return va_arg(*ap, unsigned int);
  800f72:	8b 45 14             	mov    0x14(%ebp),%eax
  800f75:	8b 00                	mov    (%eax),%eax
  800f77:	ba 00 00 00 00       	mov    $0x0,%edx
  800f7c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800f7f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800f82:	8b 45 14             	mov    0x14(%ebp),%eax
  800f85:	8d 40 04             	lea    0x4(%eax),%eax
  800f88:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800f8b:	ba 0a 00 00 00       	mov    $0xa,%edx
  800f90:	e9 d5 00 00 00       	jmp    80106a <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  800f95:	8b 45 14             	mov    0x14(%ebp),%eax
  800f98:	8b 00                	mov    (%eax),%eax
  800f9a:	ba 00 00 00 00       	mov    $0x0,%edx
  800f9f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800fa2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800fa5:	8b 45 14             	mov    0x14(%ebp),%eax
  800fa8:	8d 40 04             	lea    0x4(%eax),%eax
  800fab:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800fae:	ba 0a 00 00 00       	mov    $0xa,%edx
  800fb3:	e9 b2 00 00 00       	jmp    80106a <vprintfmt+0x417>
	if (lflag >= 2)
  800fb8:	83 f9 01             	cmp    $0x1,%ecx
  800fbb:	7e 42                	jle    800fff <vprintfmt+0x3ac>
		return va_arg(*ap, unsigned long long);
  800fbd:	8b 45 14             	mov    0x14(%ebp),%eax
  800fc0:	8b 50 04             	mov    0x4(%eax),%edx
  800fc3:	8b 00                	mov    (%eax),%eax
  800fc5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800fc8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800fcb:	8b 45 14             	mov    0x14(%ebp),%eax
  800fce:	8d 40 08             	lea    0x8(%eax),%eax
  800fd1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800fd4:	ba 08 00 00 00       	mov    $0x8,%edx
			if ((long long) num < 0) {
  800fd9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800fdd:	0f 89 87 00 00 00    	jns    80106a <vprintfmt+0x417>
				putch('-', putdat);
  800fe3:	83 ec 08             	sub    $0x8,%esp
  800fe6:	53                   	push   %ebx
  800fe7:	6a 2d                	push   $0x2d
  800fe9:	ff d6                	call   *%esi
				num = -(long long) num;
  800feb:	f7 5d d8             	negl   -0x28(%ebp)
  800fee:	83 55 dc 00          	adcl   $0x0,-0x24(%ebp)
  800ff2:	f7 5d dc             	negl   -0x24(%ebp)
  800ff5:	83 c4 10             	add    $0x10,%esp
			base = 8;
  800ff8:	ba 08 00 00 00       	mov    $0x8,%edx
  800ffd:	eb 6b                	jmp    80106a <vprintfmt+0x417>
	else if (lflag)
  800fff:	85 c9                	test   %ecx,%ecx
  801001:	75 1b                	jne    80101e <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  801003:	8b 45 14             	mov    0x14(%ebp),%eax
  801006:	8b 00                	mov    (%eax),%eax
  801008:	ba 00 00 00 00       	mov    $0x0,%edx
  80100d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801010:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801013:	8b 45 14             	mov    0x14(%ebp),%eax
  801016:	8d 40 04             	lea    0x4(%eax),%eax
  801019:	89 45 14             	mov    %eax,0x14(%ebp)
  80101c:	eb b6                	jmp    800fd4 <vprintfmt+0x381>
		return va_arg(*ap, unsigned long);
  80101e:	8b 45 14             	mov    0x14(%ebp),%eax
  801021:	8b 00                	mov    (%eax),%eax
  801023:	ba 00 00 00 00       	mov    $0x0,%edx
  801028:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80102b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80102e:	8b 45 14             	mov    0x14(%ebp),%eax
  801031:	8d 40 04             	lea    0x4(%eax),%eax
  801034:	89 45 14             	mov    %eax,0x14(%ebp)
  801037:	eb 9b                	jmp    800fd4 <vprintfmt+0x381>
			putch('0', putdat);
  801039:	83 ec 08             	sub    $0x8,%esp
  80103c:	53                   	push   %ebx
  80103d:	6a 30                	push   $0x30
  80103f:	ff d6                	call   *%esi
			putch('x', putdat);
  801041:	83 c4 08             	add    $0x8,%esp
  801044:	53                   	push   %ebx
  801045:	6a 78                	push   $0x78
  801047:	ff d6                	call   *%esi
			num = (unsigned long long)
  801049:	8b 45 14             	mov    0x14(%ebp),%eax
  80104c:	8b 00                	mov    (%eax),%eax
  80104e:	ba 00 00 00 00       	mov    $0x0,%edx
  801053:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801056:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  801059:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80105c:	8b 45 14             	mov    0x14(%ebp),%eax
  80105f:	8d 40 04             	lea    0x4(%eax),%eax
  801062:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801065:	ba 10 00 00 00       	mov    $0x10,%edx
			printnum(putch, putdat, num, base, width, padc);
  80106a:	83 ec 0c             	sub    $0xc,%esp
  80106d:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  801071:	50                   	push   %eax
  801072:	ff 75 e0             	pushl  -0x20(%ebp)
  801075:	52                   	push   %edx
  801076:	ff 75 dc             	pushl  -0x24(%ebp)
  801079:	ff 75 d8             	pushl  -0x28(%ebp)
  80107c:	89 da                	mov    %ebx,%edx
  80107e:	89 f0                	mov    %esi,%eax
  801080:	e8 e5 fa ff ff       	call   800b6a <printnum>
			break;
  801085:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  801088:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80108b:	83 c7 01             	add    $0x1,%edi
  80108e:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801092:	83 f8 25             	cmp    $0x25,%eax
  801095:	0f 84 cf fb ff ff    	je     800c6a <vprintfmt+0x17>
			if (ch == '\0')
  80109b:	85 c0                	test   %eax,%eax
  80109d:	0f 84 a9 00 00 00    	je     80114c <vprintfmt+0x4f9>
			putch(ch, putdat);
  8010a3:	83 ec 08             	sub    $0x8,%esp
  8010a6:	53                   	push   %ebx
  8010a7:	50                   	push   %eax
  8010a8:	ff d6                	call   *%esi
  8010aa:	83 c4 10             	add    $0x10,%esp
  8010ad:	eb dc                	jmp    80108b <vprintfmt+0x438>
	if (lflag >= 2)
  8010af:	83 f9 01             	cmp    $0x1,%ecx
  8010b2:	7e 1e                	jle    8010d2 <vprintfmt+0x47f>
		return va_arg(*ap, unsigned long long);
  8010b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8010b7:	8b 50 04             	mov    0x4(%eax),%edx
  8010ba:	8b 00                	mov    (%eax),%eax
  8010bc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8010bf:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8010c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8010c5:	8d 40 08             	lea    0x8(%eax),%eax
  8010c8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8010cb:	ba 10 00 00 00       	mov    $0x10,%edx
  8010d0:	eb 98                	jmp    80106a <vprintfmt+0x417>
	else if (lflag)
  8010d2:	85 c9                	test   %ecx,%ecx
  8010d4:	75 23                	jne    8010f9 <vprintfmt+0x4a6>
		return va_arg(*ap, unsigned int);
  8010d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8010d9:	8b 00                	mov    (%eax),%eax
  8010db:	ba 00 00 00 00       	mov    $0x0,%edx
  8010e0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8010e3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8010e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8010e9:	8d 40 04             	lea    0x4(%eax),%eax
  8010ec:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8010ef:	ba 10 00 00 00       	mov    $0x10,%edx
  8010f4:	e9 71 ff ff ff       	jmp    80106a <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  8010f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8010fc:	8b 00                	mov    (%eax),%eax
  8010fe:	ba 00 00 00 00       	mov    $0x0,%edx
  801103:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801106:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801109:	8b 45 14             	mov    0x14(%ebp),%eax
  80110c:	8d 40 04             	lea    0x4(%eax),%eax
  80110f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801112:	ba 10 00 00 00       	mov    $0x10,%edx
  801117:	e9 4e ff ff ff       	jmp    80106a <vprintfmt+0x417>
			putch(ch, putdat);
  80111c:	83 ec 08             	sub    $0x8,%esp
  80111f:	53                   	push   %ebx
  801120:	6a 25                	push   $0x25
  801122:	ff d6                	call   *%esi
			break;
  801124:	83 c4 10             	add    $0x10,%esp
  801127:	e9 5c ff ff ff       	jmp    801088 <vprintfmt+0x435>
			putch('%', putdat);
  80112c:	83 ec 08             	sub    $0x8,%esp
  80112f:	53                   	push   %ebx
  801130:	6a 25                	push   $0x25
  801132:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  801134:	83 c4 10             	add    $0x10,%esp
  801137:	89 f8                	mov    %edi,%eax
  801139:	eb 03                	jmp    80113e <vprintfmt+0x4eb>
  80113b:	83 e8 01             	sub    $0x1,%eax
  80113e:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  801142:	75 f7                	jne    80113b <vprintfmt+0x4e8>
  801144:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801147:	e9 3c ff ff ff       	jmp    801088 <vprintfmt+0x435>
}
  80114c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80114f:	5b                   	pop    %ebx
  801150:	5e                   	pop    %esi
  801151:	5f                   	pop    %edi
  801152:	5d                   	pop    %ebp
  801153:	c3                   	ret    

00801154 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801154:	55                   	push   %ebp
  801155:	89 e5                	mov    %esp,%ebp
  801157:	83 ec 18             	sub    $0x18,%esp
  80115a:	8b 45 08             	mov    0x8(%ebp),%eax
  80115d:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801160:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801163:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801167:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80116a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801171:	85 c0                	test   %eax,%eax
  801173:	74 26                	je     80119b <vsnprintf+0x47>
  801175:	85 d2                	test   %edx,%edx
  801177:	7e 22                	jle    80119b <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801179:	ff 75 14             	pushl  0x14(%ebp)
  80117c:	ff 75 10             	pushl  0x10(%ebp)
  80117f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801182:	50                   	push   %eax
  801183:	68 19 0c 80 00       	push   $0x800c19
  801188:	e8 c6 fa ff ff       	call   800c53 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80118d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801190:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801193:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801196:	83 c4 10             	add    $0x10,%esp
}
  801199:	c9                   	leave  
  80119a:	c3                   	ret    
		return -E_INVAL;
  80119b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011a0:	eb f7                	jmp    801199 <vsnprintf+0x45>

008011a2 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8011a2:	55                   	push   %ebp
  8011a3:	89 e5                	mov    %esp,%ebp
  8011a5:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8011a8:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8011ab:	50                   	push   %eax
  8011ac:	ff 75 10             	pushl  0x10(%ebp)
  8011af:	ff 75 0c             	pushl  0xc(%ebp)
  8011b2:	ff 75 08             	pushl  0x8(%ebp)
  8011b5:	e8 9a ff ff ff       	call   801154 <vsnprintf>
	va_end(ap);

	return rc;
}
  8011ba:	c9                   	leave  
  8011bb:	c3                   	ret    

008011bc <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
  8011bc:	55                   	push   %ebp
  8011bd:	89 e5                	mov    %esp,%ebp
  8011bf:	57                   	push   %edi
  8011c0:	56                   	push   %esi
  8011c1:	53                   	push   %ebx
  8011c2:	83 ec 0c             	sub    $0xc,%esp
  8011c5:	8b 45 08             	mov    0x8(%ebp),%eax

#if JOS_KERNEL
	if (prompt != NULL)
		cprintf("%s", prompt);
#else
	if (prompt != NULL)
  8011c8:	85 c0                	test   %eax,%eax
  8011ca:	74 13                	je     8011df <readline+0x23>
		fprintf(1, "%s", prompt);
  8011cc:	83 ec 04             	sub    $0x4,%esp
  8011cf:	50                   	push   %eax
  8011d0:	68 18 3a 80 00       	push   $0x803a18
  8011d5:	6a 01                	push   $0x1
  8011d7:	e8 a8 14 00 00       	call   802684 <fprintf>
  8011dc:	83 c4 10             	add    $0x10,%esp
#endif

	i = 0;
	echoing = iscons(0);
  8011df:	83 ec 0c             	sub    $0xc,%esp
  8011e2:	6a 00                	push   $0x0
  8011e4:	e8 b4 f7 ff ff       	call   80099d <iscons>
  8011e9:	89 c7                	mov    %eax,%edi
  8011eb:	83 c4 10             	add    $0x10,%esp
	i = 0;
  8011ee:	be 00 00 00 00       	mov    $0x0,%esi
  8011f3:	eb 4b                	jmp    801240 <readline+0x84>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return NULL;
  8011f5:	b8 00 00 00 00       	mov    $0x0,%eax
			if (c != -E_EOF)
  8011fa:	83 fb f8             	cmp    $0xfffffff8,%ebx
  8011fd:	75 08                	jne    801207 <readline+0x4b>
				cputchar('\n');
			buf[i] = 0;
			return buf;
		}
	}
}
  8011ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801202:	5b                   	pop    %ebx
  801203:	5e                   	pop    %esi
  801204:	5f                   	pop    %edi
  801205:	5d                   	pop    %ebp
  801206:	c3                   	ret    
				cprintf("read error: %e\n", c);
  801207:	83 ec 08             	sub    $0x8,%esp
  80120a:	53                   	push   %ebx
  80120b:	68 ff 3d 80 00       	push   $0x803dff
  801210:	e8 41 f9 ff ff       	call   800b56 <cprintf>
  801215:	83 c4 10             	add    $0x10,%esp
			return NULL;
  801218:	b8 00 00 00 00       	mov    $0x0,%eax
  80121d:	eb e0                	jmp    8011ff <readline+0x43>
			if (echoing)
  80121f:	85 ff                	test   %edi,%edi
  801221:	75 05                	jne    801228 <readline+0x6c>
			i--;
  801223:	83 ee 01             	sub    $0x1,%esi
  801226:	eb 18                	jmp    801240 <readline+0x84>
				cputchar('\b');
  801228:	83 ec 0c             	sub    $0xc,%esp
  80122b:	6a 08                	push   $0x8
  80122d:	e8 24 f7 ff ff       	call   800956 <cputchar>
  801232:	83 c4 10             	add    $0x10,%esp
  801235:	eb ec                	jmp    801223 <readline+0x67>
			buf[i++] = c;
  801237:	88 9e 20 60 80 00    	mov    %bl,0x806020(%esi)
  80123d:	8d 76 01             	lea    0x1(%esi),%esi
		c = getchar();
  801240:	e8 2d f7 ff ff       	call   800972 <getchar>
  801245:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
  801247:	85 c0                	test   %eax,%eax
  801249:	78 aa                	js     8011f5 <readline+0x39>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  80124b:	83 f8 08             	cmp    $0x8,%eax
  80124e:	0f 94 c2             	sete   %dl
  801251:	83 f8 7f             	cmp    $0x7f,%eax
  801254:	0f 94 c0             	sete   %al
  801257:	08 c2                	or     %al,%dl
  801259:	74 04                	je     80125f <readline+0xa3>
  80125b:	85 f6                	test   %esi,%esi
  80125d:	7f c0                	jg     80121f <readline+0x63>
		} else if (c >= ' ' && i < BUFLEN-1) {
  80125f:	83 fb 1f             	cmp    $0x1f,%ebx
  801262:	7e 1a                	jle    80127e <readline+0xc2>
  801264:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
  80126a:	7f 12                	jg     80127e <readline+0xc2>
			if (echoing)
  80126c:	85 ff                	test   %edi,%edi
  80126e:	74 c7                	je     801237 <readline+0x7b>
				cputchar(c);
  801270:	83 ec 0c             	sub    $0xc,%esp
  801273:	53                   	push   %ebx
  801274:	e8 dd f6 ff ff       	call   800956 <cputchar>
  801279:	83 c4 10             	add    $0x10,%esp
  80127c:	eb b9                	jmp    801237 <readline+0x7b>
		} else if (c == '\n' || c == '\r') {
  80127e:	83 fb 0a             	cmp    $0xa,%ebx
  801281:	74 05                	je     801288 <readline+0xcc>
  801283:	83 fb 0d             	cmp    $0xd,%ebx
  801286:	75 b8                	jne    801240 <readline+0x84>
			if (echoing)
  801288:	85 ff                	test   %edi,%edi
  80128a:	75 11                	jne    80129d <readline+0xe1>
			buf[i] = 0;
  80128c:	c6 86 20 60 80 00 00 	movb   $0x0,0x806020(%esi)
			return buf;
  801293:	b8 20 60 80 00       	mov    $0x806020,%eax
  801298:	e9 62 ff ff ff       	jmp    8011ff <readline+0x43>
				cputchar('\n');
  80129d:	83 ec 0c             	sub    $0xc,%esp
  8012a0:	6a 0a                	push   $0xa
  8012a2:	e8 af f6 ff ff       	call   800956 <cputchar>
  8012a7:	83 c4 10             	add    $0x10,%esp
  8012aa:	eb e0                	jmp    80128c <readline+0xd0>

008012ac <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8012ac:	55                   	push   %ebp
  8012ad:	89 e5                	mov    %esp,%ebp
  8012af:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8012b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8012b7:	eb 03                	jmp    8012bc <strlen+0x10>
		n++;
  8012b9:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8012bc:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8012c0:	75 f7                	jne    8012b9 <strlen+0xd>
	return n;
}
  8012c2:	5d                   	pop    %ebp
  8012c3:	c3                   	ret    

008012c4 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8012c4:	55                   	push   %ebp
  8012c5:	89 e5                	mov    %esp,%ebp
  8012c7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012ca:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8012d2:	eb 03                	jmp    8012d7 <strnlen+0x13>
		n++;
  8012d4:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012d7:	39 d0                	cmp    %edx,%eax
  8012d9:	74 06                	je     8012e1 <strnlen+0x1d>
  8012db:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8012df:	75 f3                	jne    8012d4 <strnlen+0x10>
	return n;
}
  8012e1:	5d                   	pop    %ebp
  8012e2:	c3                   	ret    

008012e3 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8012e3:	55                   	push   %ebp
  8012e4:	89 e5                	mov    %esp,%ebp
  8012e6:	53                   	push   %ebx
  8012e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8012ed:	89 c2                	mov    %eax,%edx
  8012ef:	83 c1 01             	add    $0x1,%ecx
  8012f2:	83 c2 01             	add    $0x1,%edx
  8012f5:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8012f9:	88 5a ff             	mov    %bl,-0x1(%edx)
  8012fc:	84 db                	test   %bl,%bl
  8012fe:	75 ef                	jne    8012ef <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  801300:	5b                   	pop    %ebx
  801301:	5d                   	pop    %ebp
  801302:	c3                   	ret    

00801303 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801303:	55                   	push   %ebp
  801304:	89 e5                	mov    %esp,%ebp
  801306:	53                   	push   %ebx
  801307:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80130a:	53                   	push   %ebx
  80130b:	e8 9c ff ff ff       	call   8012ac <strlen>
  801310:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  801313:	ff 75 0c             	pushl  0xc(%ebp)
  801316:	01 d8                	add    %ebx,%eax
  801318:	50                   	push   %eax
  801319:	e8 c5 ff ff ff       	call   8012e3 <strcpy>
	return dst;
}
  80131e:	89 d8                	mov    %ebx,%eax
  801320:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801323:	c9                   	leave  
  801324:	c3                   	ret    

00801325 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801325:	55                   	push   %ebp
  801326:	89 e5                	mov    %esp,%ebp
  801328:	56                   	push   %esi
  801329:	53                   	push   %ebx
  80132a:	8b 75 08             	mov    0x8(%ebp),%esi
  80132d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801330:	89 f3                	mov    %esi,%ebx
  801332:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801335:	89 f2                	mov    %esi,%edx
  801337:	eb 0f                	jmp    801348 <strncpy+0x23>
		*dst++ = *src;
  801339:	83 c2 01             	add    $0x1,%edx
  80133c:	0f b6 01             	movzbl (%ecx),%eax
  80133f:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801342:	80 39 01             	cmpb   $0x1,(%ecx)
  801345:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  801348:	39 da                	cmp    %ebx,%edx
  80134a:	75 ed                	jne    801339 <strncpy+0x14>
	}
	return ret;
}
  80134c:	89 f0                	mov    %esi,%eax
  80134e:	5b                   	pop    %ebx
  80134f:	5e                   	pop    %esi
  801350:	5d                   	pop    %ebp
  801351:	c3                   	ret    

00801352 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801352:	55                   	push   %ebp
  801353:	89 e5                	mov    %esp,%ebp
  801355:	56                   	push   %esi
  801356:	53                   	push   %ebx
  801357:	8b 75 08             	mov    0x8(%ebp),%esi
  80135a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80135d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801360:	89 f0                	mov    %esi,%eax
  801362:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801366:	85 c9                	test   %ecx,%ecx
  801368:	75 0b                	jne    801375 <strlcpy+0x23>
  80136a:	eb 17                	jmp    801383 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  80136c:	83 c2 01             	add    $0x1,%edx
  80136f:	83 c0 01             	add    $0x1,%eax
  801372:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  801375:	39 d8                	cmp    %ebx,%eax
  801377:	74 07                	je     801380 <strlcpy+0x2e>
  801379:	0f b6 0a             	movzbl (%edx),%ecx
  80137c:	84 c9                	test   %cl,%cl
  80137e:	75 ec                	jne    80136c <strlcpy+0x1a>
		*dst = '\0';
  801380:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801383:	29 f0                	sub    %esi,%eax
}
  801385:	5b                   	pop    %ebx
  801386:	5e                   	pop    %esi
  801387:	5d                   	pop    %ebp
  801388:	c3                   	ret    

00801389 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801389:	55                   	push   %ebp
  80138a:	89 e5                	mov    %esp,%ebp
  80138c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80138f:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801392:	eb 06                	jmp    80139a <strcmp+0x11>
		p++, q++;
  801394:	83 c1 01             	add    $0x1,%ecx
  801397:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  80139a:	0f b6 01             	movzbl (%ecx),%eax
  80139d:	84 c0                	test   %al,%al
  80139f:	74 04                	je     8013a5 <strcmp+0x1c>
  8013a1:	3a 02                	cmp    (%edx),%al
  8013a3:	74 ef                	je     801394 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8013a5:	0f b6 c0             	movzbl %al,%eax
  8013a8:	0f b6 12             	movzbl (%edx),%edx
  8013ab:	29 d0                	sub    %edx,%eax
}
  8013ad:	5d                   	pop    %ebp
  8013ae:	c3                   	ret    

008013af <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8013af:	55                   	push   %ebp
  8013b0:	89 e5                	mov    %esp,%ebp
  8013b2:	53                   	push   %ebx
  8013b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013b9:	89 c3                	mov    %eax,%ebx
  8013bb:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8013be:	eb 06                	jmp    8013c6 <strncmp+0x17>
		n--, p++, q++;
  8013c0:	83 c0 01             	add    $0x1,%eax
  8013c3:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8013c6:	39 d8                	cmp    %ebx,%eax
  8013c8:	74 16                	je     8013e0 <strncmp+0x31>
  8013ca:	0f b6 08             	movzbl (%eax),%ecx
  8013cd:	84 c9                	test   %cl,%cl
  8013cf:	74 04                	je     8013d5 <strncmp+0x26>
  8013d1:	3a 0a                	cmp    (%edx),%cl
  8013d3:	74 eb                	je     8013c0 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8013d5:	0f b6 00             	movzbl (%eax),%eax
  8013d8:	0f b6 12             	movzbl (%edx),%edx
  8013db:	29 d0                	sub    %edx,%eax
}
  8013dd:	5b                   	pop    %ebx
  8013de:	5d                   	pop    %ebp
  8013df:	c3                   	ret    
		return 0;
  8013e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8013e5:	eb f6                	jmp    8013dd <strncmp+0x2e>

008013e7 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8013e7:	55                   	push   %ebp
  8013e8:	89 e5                	mov    %esp,%ebp
  8013ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ed:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8013f1:	0f b6 10             	movzbl (%eax),%edx
  8013f4:	84 d2                	test   %dl,%dl
  8013f6:	74 09                	je     801401 <strchr+0x1a>
		if (*s == c)
  8013f8:	38 ca                	cmp    %cl,%dl
  8013fa:	74 0a                	je     801406 <strchr+0x1f>
	for (; *s; s++)
  8013fc:	83 c0 01             	add    $0x1,%eax
  8013ff:	eb f0                	jmp    8013f1 <strchr+0xa>
			return (char *) s;
	return 0;
  801401:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801406:	5d                   	pop    %ebp
  801407:	c3                   	ret    

00801408 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801408:	55                   	push   %ebp
  801409:	89 e5                	mov    %esp,%ebp
  80140b:	8b 45 08             	mov    0x8(%ebp),%eax
  80140e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801412:	eb 03                	jmp    801417 <strfind+0xf>
  801414:	83 c0 01             	add    $0x1,%eax
  801417:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  80141a:	38 ca                	cmp    %cl,%dl
  80141c:	74 04                	je     801422 <strfind+0x1a>
  80141e:	84 d2                	test   %dl,%dl
  801420:	75 f2                	jne    801414 <strfind+0xc>
			break;
	return (char *) s;
}
  801422:	5d                   	pop    %ebp
  801423:	c3                   	ret    

00801424 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801424:	55                   	push   %ebp
  801425:	89 e5                	mov    %esp,%ebp
  801427:	57                   	push   %edi
  801428:	56                   	push   %esi
  801429:	53                   	push   %ebx
  80142a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80142d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801430:	85 c9                	test   %ecx,%ecx
  801432:	74 13                	je     801447 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801434:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80143a:	75 05                	jne    801441 <memset+0x1d>
  80143c:	f6 c1 03             	test   $0x3,%cl
  80143f:	74 0d                	je     80144e <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801441:	8b 45 0c             	mov    0xc(%ebp),%eax
  801444:	fc                   	cld    
  801445:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801447:	89 f8                	mov    %edi,%eax
  801449:	5b                   	pop    %ebx
  80144a:	5e                   	pop    %esi
  80144b:	5f                   	pop    %edi
  80144c:	5d                   	pop    %ebp
  80144d:	c3                   	ret    
		c &= 0xFF;
  80144e:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801452:	89 d3                	mov    %edx,%ebx
  801454:	c1 e3 08             	shl    $0x8,%ebx
  801457:	89 d0                	mov    %edx,%eax
  801459:	c1 e0 18             	shl    $0x18,%eax
  80145c:	89 d6                	mov    %edx,%esi
  80145e:	c1 e6 10             	shl    $0x10,%esi
  801461:	09 f0                	or     %esi,%eax
  801463:	09 c2                	or     %eax,%edx
  801465:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  801467:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  80146a:	89 d0                	mov    %edx,%eax
  80146c:	fc                   	cld    
  80146d:	f3 ab                	rep stos %eax,%es:(%edi)
  80146f:	eb d6                	jmp    801447 <memset+0x23>

00801471 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801471:	55                   	push   %ebp
  801472:	89 e5                	mov    %esp,%ebp
  801474:	57                   	push   %edi
  801475:	56                   	push   %esi
  801476:	8b 45 08             	mov    0x8(%ebp),%eax
  801479:	8b 75 0c             	mov    0xc(%ebp),%esi
  80147c:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80147f:	39 c6                	cmp    %eax,%esi
  801481:	73 35                	jae    8014b8 <memmove+0x47>
  801483:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801486:	39 c2                	cmp    %eax,%edx
  801488:	76 2e                	jbe    8014b8 <memmove+0x47>
		s += n;
		d += n;
  80148a:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80148d:	89 d6                	mov    %edx,%esi
  80148f:	09 fe                	or     %edi,%esi
  801491:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801497:	74 0c                	je     8014a5 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801499:	83 ef 01             	sub    $0x1,%edi
  80149c:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  80149f:	fd                   	std    
  8014a0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8014a2:	fc                   	cld    
  8014a3:	eb 21                	jmp    8014c6 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8014a5:	f6 c1 03             	test   $0x3,%cl
  8014a8:	75 ef                	jne    801499 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8014aa:	83 ef 04             	sub    $0x4,%edi
  8014ad:	8d 72 fc             	lea    -0x4(%edx),%esi
  8014b0:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8014b3:	fd                   	std    
  8014b4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8014b6:	eb ea                	jmp    8014a2 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8014b8:	89 f2                	mov    %esi,%edx
  8014ba:	09 c2                	or     %eax,%edx
  8014bc:	f6 c2 03             	test   $0x3,%dl
  8014bf:	74 09                	je     8014ca <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8014c1:	89 c7                	mov    %eax,%edi
  8014c3:	fc                   	cld    
  8014c4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8014c6:	5e                   	pop    %esi
  8014c7:	5f                   	pop    %edi
  8014c8:	5d                   	pop    %ebp
  8014c9:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8014ca:	f6 c1 03             	test   $0x3,%cl
  8014cd:	75 f2                	jne    8014c1 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8014cf:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8014d2:	89 c7                	mov    %eax,%edi
  8014d4:	fc                   	cld    
  8014d5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8014d7:	eb ed                	jmp    8014c6 <memmove+0x55>

008014d9 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8014d9:	55                   	push   %ebp
  8014da:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  8014dc:	ff 75 10             	pushl  0x10(%ebp)
  8014df:	ff 75 0c             	pushl  0xc(%ebp)
  8014e2:	ff 75 08             	pushl  0x8(%ebp)
  8014e5:	e8 87 ff ff ff       	call   801471 <memmove>
}
  8014ea:	c9                   	leave  
  8014eb:	c3                   	ret    

008014ec <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8014ec:	55                   	push   %ebp
  8014ed:	89 e5                	mov    %esp,%ebp
  8014ef:	56                   	push   %esi
  8014f0:	53                   	push   %ebx
  8014f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014f7:	89 c6                	mov    %eax,%esi
  8014f9:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8014fc:	39 f0                	cmp    %esi,%eax
  8014fe:	74 1c                	je     80151c <memcmp+0x30>
		if (*s1 != *s2)
  801500:	0f b6 08             	movzbl (%eax),%ecx
  801503:	0f b6 1a             	movzbl (%edx),%ebx
  801506:	38 d9                	cmp    %bl,%cl
  801508:	75 08                	jne    801512 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  80150a:	83 c0 01             	add    $0x1,%eax
  80150d:	83 c2 01             	add    $0x1,%edx
  801510:	eb ea                	jmp    8014fc <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  801512:	0f b6 c1             	movzbl %cl,%eax
  801515:	0f b6 db             	movzbl %bl,%ebx
  801518:	29 d8                	sub    %ebx,%eax
  80151a:	eb 05                	jmp    801521 <memcmp+0x35>
	}

	return 0;
  80151c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801521:	5b                   	pop    %ebx
  801522:	5e                   	pop    %esi
  801523:	5d                   	pop    %ebp
  801524:	c3                   	ret    

00801525 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801525:	55                   	push   %ebp
  801526:	89 e5                	mov    %esp,%ebp
  801528:	8b 45 08             	mov    0x8(%ebp),%eax
  80152b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  80152e:	89 c2                	mov    %eax,%edx
  801530:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801533:	39 d0                	cmp    %edx,%eax
  801535:	73 09                	jae    801540 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  801537:	38 08                	cmp    %cl,(%eax)
  801539:	74 05                	je     801540 <memfind+0x1b>
	for (; s < ends; s++)
  80153b:	83 c0 01             	add    $0x1,%eax
  80153e:	eb f3                	jmp    801533 <memfind+0xe>
			break;
	return (void *) s;
}
  801540:	5d                   	pop    %ebp
  801541:	c3                   	ret    

00801542 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801542:	55                   	push   %ebp
  801543:	89 e5                	mov    %esp,%ebp
  801545:	57                   	push   %edi
  801546:	56                   	push   %esi
  801547:	53                   	push   %ebx
  801548:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80154b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80154e:	eb 03                	jmp    801553 <strtol+0x11>
		s++;
  801550:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  801553:	0f b6 01             	movzbl (%ecx),%eax
  801556:	3c 20                	cmp    $0x20,%al
  801558:	74 f6                	je     801550 <strtol+0xe>
  80155a:	3c 09                	cmp    $0x9,%al
  80155c:	74 f2                	je     801550 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  80155e:	3c 2b                	cmp    $0x2b,%al
  801560:	74 2e                	je     801590 <strtol+0x4e>
	int neg = 0;
  801562:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801567:	3c 2d                	cmp    $0x2d,%al
  801569:	74 2f                	je     80159a <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80156b:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  801571:	75 05                	jne    801578 <strtol+0x36>
  801573:	80 39 30             	cmpb   $0x30,(%ecx)
  801576:	74 2c                	je     8015a4 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  801578:	85 db                	test   %ebx,%ebx
  80157a:	75 0a                	jne    801586 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  80157c:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  801581:	80 39 30             	cmpb   $0x30,(%ecx)
  801584:	74 28                	je     8015ae <strtol+0x6c>
		base = 10;
  801586:	b8 00 00 00 00       	mov    $0x0,%eax
  80158b:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80158e:	eb 50                	jmp    8015e0 <strtol+0x9e>
		s++;
  801590:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  801593:	bf 00 00 00 00       	mov    $0x0,%edi
  801598:	eb d1                	jmp    80156b <strtol+0x29>
		s++, neg = 1;
  80159a:	83 c1 01             	add    $0x1,%ecx
  80159d:	bf 01 00 00 00       	mov    $0x1,%edi
  8015a2:	eb c7                	jmp    80156b <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8015a4:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  8015a8:	74 0e                	je     8015b8 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  8015aa:	85 db                	test   %ebx,%ebx
  8015ac:	75 d8                	jne    801586 <strtol+0x44>
		s++, base = 8;
  8015ae:	83 c1 01             	add    $0x1,%ecx
  8015b1:	bb 08 00 00 00       	mov    $0x8,%ebx
  8015b6:	eb ce                	jmp    801586 <strtol+0x44>
		s += 2, base = 16;
  8015b8:	83 c1 02             	add    $0x2,%ecx
  8015bb:	bb 10 00 00 00       	mov    $0x10,%ebx
  8015c0:	eb c4                	jmp    801586 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  8015c2:	8d 72 9f             	lea    -0x61(%edx),%esi
  8015c5:	89 f3                	mov    %esi,%ebx
  8015c7:	80 fb 19             	cmp    $0x19,%bl
  8015ca:	77 29                	ja     8015f5 <strtol+0xb3>
			dig = *s - 'a' + 10;
  8015cc:	0f be d2             	movsbl %dl,%edx
  8015cf:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  8015d2:	3b 55 10             	cmp    0x10(%ebp),%edx
  8015d5:	7d 30                	jge    801607 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  8015d7:	83 c1 01             	add    $0x1,%ecx
  8015da:	0f af 45 10          	imul   0x10(%ebp),%eax
  8015de:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  8015e0:	0f b6 11             	movzbl (%ecx),%edx
  8015e3:	8d 72 d0             	lea    -0x30(%edx),%esi
  8015e6:	89 f3                	mov    %esi,%ebx
  8015e8:	80 fb 09             	cmp    $0x9,%bl
  8015eb:	77 d5                	ja     8015c2 <strtol+0x80>
			dig = *s - '0';
  8015ed:	0f be d2             	movsbl %dl,%edx
  8015f0:	83 ea 30             	sub    $0x30,%edx
  8015f3:	eb dd                	jmp    8015d2 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  8015f5:	8d 72 bf             	lea    -0x41(%edx),%esi
  8015f8:	89 f3                	mov    %esi,%ebx
  8015fa:	80 fb 19             	cmp    $0x19,%bl
  8015fd:	77 08                	ja     801607 <strtol+0xc5>
			dig = *s - 'A' + 10;
  8015ff:	0f be d2             	movsbl %dl,%edx
  801602:	83 ea 37             	sub    $0x37,%edx
  801605:	eb cb                	jmp    8015d2 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  801607:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80160b:	74 05                	je     801612 <strtol+0xd0>
		*endptr = (char *) s;
  80160d:	8b 75 0c             	mov    0xc(%ebp),%esi
  801610:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801612:	89 c2                	mov    %eax,%edx
  801614:	f7 da                	neg    %edx
  801616:	85 ff                	test   %edi,%edi
  801618:	0f 45 c2             	cmovne %edx,%eax
}
  80161b:	5b                   	pop    %ebx
  80161c:	5e                   	pop    %esi
  80161d:	5f                   	pop    %edi
  80161e:	5d                   	pop    %ebp
  80161f:	c3                   	ret    

00801620 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  801620:	55                   	push   %ebp
  801621:	89 e5                	mov    %esp,%ebp
  801623:	57                   	push   %edi
  801624:	56                   	push   %esi
  801625:	53                   	push   %ebx
	asm volatile("int %1\n"
  801626:	b8 00 00 00 00       	mov    $0x0,%eax
  80162b:	8b 55 08             	mov    0x8(%ebp),%edx
  80162e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801631:	89 c3                	mov    %eax,%ebx
  801633:	89 c7                	mov    %eax,%edi
  801635:	89 c6                	mov    %eax,%esi
  801637:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  801639:	5b                   	pop    %ebx
  80163a:	5e                   	pop    %esi
  80163b:	5f                   	pop    %edi
  80163c:	5d                   	pop    %ebp
  80163d:	c3                   	ret    

0080163e <sys_cgetc>:

int
sys_cgetc(void)
{
  80163e:	55                   	push   %ebp
  80163f:	89 e5                	mov    %esp,%ebp
  801641:	57                   	push   %edi
  801642:	56                   	push   %esi
  801643:	53                   	push   %ebx
	asm volatile("int %1\n"
  801644:	ba 00 00 00 00       	mov    $0x0,%edx
  801649:	b8 01 00 00 00       	mov    $0x1,%eax
  80164e:	89 d1                	mov    %edx,%ecx
  801650:	89 d3                	mov    %edx,%ebx
  801652:	89 d7                	mov    %edx,%edi
  801654:	89 d6                	mov    %edx,%esi
  801656:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  801658:	5b                   	pop    %ebx
  801659:	5e                   	pop    %esi
  80165a:	5f                   	pop    %edi
  80165b:	5d                   	pop    %ebp
  80165c:	c3                   	ret    

0080165d <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80165d:	55                   	push   %ebp
  80165e:	89 e5                	mov    %esp,%ebp
  801660:	57                   	push   %edi
  801661:	56                   	push   %esi
  801662:	53                   	push   %ebx
  801663:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801666:	b9 00 00 00 00       	mov    $0x0,%ecx
  80166b:	8b 55 08             	mov    0x8(%ebp),%edx
  80166e:	b8 03 00 00 00       	mov    $0x3,%eax
  801673:	89 cb                	mov    %ecx,%ebx
  801675:	89 cf                	mov    %ecx,%edi
  801677:	89 ce                	mov    %ecx,%esi
  801679:	cd 30                	int    $0x30
	if(check && ret > 0)
  80167b:	85 c0                	test   %eax,%eax
  80167d:	7f 08                	jg     801687 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80167f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801682:	5b                   	pop    %ebx
  801683:	5e                   	pop    %esi
  801684:	5f                   	pop    %edi
  801685:	5d                   	pop    %ebp
  801686:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801687:	83 ec 0c             	sub    $0xc,%esp
  80168a:	50                   	push   %eax
  80168b:	6a 03                	push   $0x3
  80168d:	68 0f 3e 80 00       	push   $0x803e0f
  801692:	6a 23                	push   $0x23
  801694:	68 2c 3e 80 00       	push   $0x803e2c
  801699:	e8 dd f3 ff ff       	call   800a7b <_panic>

0080169e <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80169e:	55                   	push   %ebp
  80169f:	89 e5                	mov    %esp,%ebp
  8016a1:	57                   	push   %edi
  8016a2:	56                   	push   %esi
  8016a3:	53                   	push   %ebx
	asm volatile("int %1\n"
  8016a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8016a9:	b8 02 00 00 00       	mov    $0x2,%eax
  8016ae:	89 d1                	mov    %edx,%ecx
  8016b0:	89 d3                	mov    %edx,%ebx
  8016b2:	89 d7                	mov    %edx,%edi
  8016b4:	89 d6                	mov    %edx,%esi
  8016b6:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8016b8:	5b                   	pop    %ebx
  8016b9:	5e                   	pop    %esi
  8016ba:	5f                   	pop    %edi
  8016bb:	5d                   	pop    %ebp
  8016bc:	c3                   	ret    

008016bd <sys_yield>:

void
sys_yield(void)
{
  8016bd:	55                   	push   %ebp
  8016be:	89 e5                	mov    %esp,%ebp
  8016c0:	57                   	push   %edi
  8016c1:	56                   	push   %esi
  8016c2:	53                   	push   %ebx
	asm volatile("int %1\n"
  8016c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8016c8:	b8 0b 00 00 00       	mov    $0xb,%eax
  8016cd:	89 d1                	mov    %edx,%ecx
  8016cf:	89 d3                	mov    %edx,%ebx
  8016d1:	89 d7                	mov    %edx,%edi
  8016d3:	89 d6                	mov    %edx,%esi
  8016d5:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8016d7:	5b                   	pop    %ebx
  8016d8:	5e                   	pop    %esi
  8016d9:	5f                   	pop    %edi
  8016da:	5d                   	pop    %ebp
  8016db:	c3                   	ret    

008016dc <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8016dc:	55                   	push   %ebp
  8016dd:	89 e5                	mov    %esp,%ebp
  8016df:	57                   	push   %edi
  8016e0:	56                   	push   %esi
  8016e1:	53                   	push   %ebx
  8016e2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8016e5:	be 00 00 00 00       	mov    $0x0,%esi
  8016ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8016ed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016f0:	b8 04 00 00 00       	mov    $0x4,%eax
  8016f5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8016f8:	89 f7                	mov    %esi,%edi
  8016fa:	cd 30                	int    $0x30
	if(check && ret > 0)
  8016fc:	85 c0                	test   %eax,%eax
  8016fe:	7f 08                	jg     801708 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801700:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801703:	5b                   	pop    %ebx
  801704:	5e                   	pop    %esi
  801705:	5f                   	pop    %edi
  801706:	5d                   	pop    %ebp
  801707:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801708:	83 ec 0c             	sub    $0xc,%esp
  80170b:	50                   	push   %eax
  80170c:	6a 04                	push   $0x4
  80170e:	68 0f 3e 80 00       	push   $0x803e0f
  801713:	6a 23                	push   $0x23
  801715:	68 2c 3e 80 00       	push   $0x803e2c
  80171a:	e8 5c f3 ff ff       	call   800a7b <_panic>

0080171f <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80171f:	55                   	push   %ebp
  801720:	89 e5                	mov    %esp,%ebp
  801722:	57                   	push   %edi
  801723:	56                   	push   %esi
  801724:	53                   	push   %ebx
  801725:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801728:	8b 55 08             	mov    0x8(%ebp),%edx
  80172b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80172e:	b8 05 00 00 00       	mov    $0x5,%eax
  801733:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801736:	8b 7d 14             	mov    0x14(%ebp),%edi
  801739:	8b 75 18             	mov    0x18(%ebp),%esi
  80173c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80173e:	85 c0                	test   %eax,%eax
  801740:	7f 08                	jg     80174a <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801742:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801745:	5b                   	pop    %ebx
  801746:	5e                   	pop    %esi
  801747:	5f                   	pop    %edi
  801748:	5d                   	pop    %ebp
  801749:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80174a:	83 ec 0c             	sub    $0xc,%esp
  80174d:	50                   	push   %eax
  80174e:	6a 05                	push   $0x5
  801750:	68 0f 3e 80 00       	push   $0x803e0f
  801755:	6a 23                	push   $0x23
  801757:	68 2c 3e 80 00       	push   $0x803e2c
  80175c:	e8 1a f3 ff ff       	call   800a7b <_panic>

00801761 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801761:	55                   	push   %ebp
  801762:	89 e5                	mov    %esp,%ebp
  801764:	57                   	push   %edi
  801765:	56                   	push   %esi
  801766:	53                   	push   %ebx
  801767:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80176a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80176f:	8b 55 08             	mov    0x8(%ebp),%edx
  801772:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801775:	b8 06 00 00 00       	mov    $0x6,%eax
  80177a:	89 df                	mov    %ebx,%edi
  80177c:	89 de                	mov    %ebx,%esi
  80177e:	cd 30                	int    $0x30
	if(check && ret > 0)
  801780:	85 c0                	test   %eax,%eax
  801782:	7f 08                	jg     80178c <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801784:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801787:	5b                   	pop    %ebx
  801788:	5e                   	pop    %esi
  801789:	5f                   	pop    %edi
  80178a:	5d                   	pop    %ebp
  80178b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80178c:	83 ec 0c             	sub    $0xc,%esp
  80178f:	50                   	push   %eax
  801790:	6a 06                	push   $0x6
  801792:	68 0f 3e 80 00       	push   $0x803e0f
  801797:	6a 23                	push   $0x23
  801799:	68 2c 3e 80 00       	push   $0x803e2c
  80179e:	e8 d8 f2 ff ff       	call   800a7b <_panic>

008017a3 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8017a3:	55                   	push   %ebp
  8017a4:	89 e5                	mov    %esp,%ebp
  8017a6:	57                   	push   %edi
  8017a7:	56                   	push   %esi
  8017a8:	53                   	push   %ebx
  8017a9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8017ac:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8017b4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017b7:	b8 08 00 00 00       	mov    $0x8,%eax
  8017bc:	89 df                	mov    %ebx,%edi
  8017be:	89 de                	mov    %ebx,%esi
  8017c0:	cd 30                	int    $0x30
	if(check && ret > 0)
  8017c2:	85 c0                	test   %eax,%eax
  8017c4:	7f 08                	jg     8017ce <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8017c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017c9:	5b                   	pop    %ebx
  8017ca:	5e                   	pop    %esi
  8017cb:	5f                   	pop    %edi
  8017cc:	5d                   	pop    %ebp
  8017cd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8017ce:	83 ec 0c             	sub    $0xc,%esp
  8017d1:	50                   	push   %eax
  8017d2:	6a 08                	push   $0x8
  8017d4:	68 0f 3e 80 00       	push   $0x803e0f
  8017d9:	6a 23                	push   $0x23
  8017db:	68 2c 3e 80 00       	push   $0x803e2c
  8017e0:	e8 96 f2 ff ff       	call   800a7b <_panic>

008017e5 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8017e5:	55                   	push   %ebp
  8017e6:	89 e5                	mov    %esp,%ebp
  8017e8:	57                   	push   %edi
  8017e9:	56                   	push   %esi
  8017ea:	53                   	push   %ebx
  8017eb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8017ee:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8017f6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017f9:	b8 09 00 00 00       	mov    $0x9,%eax
  8017fe:	89 df                	mov    %ebx,%edi
  801800:	89 de                	mov    %ebx,%esi
  801802:	cd 30                	int    $0x30
	if(check && ret > 0)
  801804:	85 c0                	test   %eax,%eax
  801806:	7f 08                	jg     801810 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801808:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80180b:	5b                   	pop    %ebx
  80180c:	5e                   	pop    %esi
  80180d:	5f                   	pop    %edi
  80180e:	5d                   	pop    %ebp
  80180f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801810:	83 ec 0c             	sub    $0xc,%esp
  801813:	50                   	push   %eax
  801814:	6a 09                	push   $0x9
  801816:	68 0f 3e 80 00       	push   $0x803e0f
  80181b:	6a 23                	push   $0x23
  80181d:	68 2c 3e 80 00       	push   $0x803e2c
  801822:	e8 54 f2 ff ff       	call   800a7b <_panic>

00801827 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801827:	55                   	push   %ebp
  801828:	89 e5                	mov    %esp,%ebp
  80182a:	57                   	push   %edi
  80182b:	56                   	push   %esi
  80182c:	53                   	push   %ebx
  80182d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801830:	bb 00 00 00 00       	mov    $0x0,%ebx
  801835:	8b 55 08             	mov    0x8(%ebp),%edx
  801838:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80183b:	b8 0a 00 00 00       	mov    $0xa,%eax
  801840:	89 df                	mov    %ebx,%edi
  801842:	89 de                	mov    %ebx,%esi
  801844:	cd 30                	int    $0x30
	if(check && ret > 0)
  801846:	85 c0                	test   %eax,%eax
  801848:	7f 08                	jg     801852 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80184a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80184d:	5b                   	pop    %ebx
  80184e:	5e                   	pop    %esi
  80184f:	5f                   	pop    %edi
  801850:	5d                   	pop    %ebp
  801851:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801852:	83 ec 0c             	sub    $0xc,%esp
  801855:	50                   	push   %eax
  801856:	6a 0a                	push   $0xa
  801858:	68 0f 3e 80 00       	push   $0x803e0f
  80185d:	6a 23                	push   $0x23
  80185f:	68 2c 3e 80 00       	push   $0x803e2c
  801864:	e8 12 f2 ff ff       	call   800a7b <_panic>

00801869 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801869:	55                   	push   %ebp
  80186a:	89 e5                	mov    %esp,%ebp
  80186c:	57                   	push   %edi
  80186d:	56                   	push   %esi
  80186e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80186f:	8b 55 08             	mov    0x8(%ebp),%edx
  801872:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801875:	b8 0c 00 00 00       	mov    $0xc,%eax
  80187a:	be 00 00 00 00       	mov    $0x0,%esi
  80187f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801882:	8b 7d 14             	mov    0x14(%ebp),%edi
  801885:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801887:	5b                   	pop    %ebx
  801888:	5e                   	pop    %esi
  801889:	5f                   	pop    %edi
  80188a:	5d                   	pop    %ebp
  80188b:	c3                   	ret    

0080188c <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80188c:	55                   	push   %ebp
  80188d:	89 e5                	mov    %esp,%ebp
  80188f:	57                   	push   %edi
  801890:	56                   	push   %esi
  801891:	53                   	push   %ebx
  801892:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801895:	b9 00 00 00 00       	mov    $0x0,%ecx
  80189a:	8b 55 08             	mov    0x8(%ebp),%edx
  80189d:	b8 0d 00 00 00       	mov    $0xd,%eax
  8018a2:	89 cb                	mov    %ecx,%ebx
  8018a4:	89 cf                	mov    %ecx,%edi
  8018a6:	89 ce                	mov    %ecx,%esi
  8018a8:	cd 30                	int    $0x30
	if(check && ret > 0)
  8018aa:	85 c0                	test   %eax,%eax
  8018ac:	7f 08                	jg     8018b6 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8018ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018b1:	5b                   	pop    %ebx
  8018b2:	5e                   	pop    %esi
  8018b3:	5f                   	pop    %edi
  8018b4:	5d                   	pop    %ebp
  8018b5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8018b6:	83 ec 0c             	sub    $0xc,%esp
  8018b9:	50                   	push   %eax
  8018ba:	6a 0d                	push   $0xd
  8018bc:	68 0f 3e 80 00       	push   $0x803e0f
  8018c1:	6a 23                	push   $0x23
  8018c3:	68 2c 3e 80 00       	push   $0x803e2c
  8018c8:	e8 ae f1 ff ff       	call   800a7b <_panic>

008018cd <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8018cd:	55                   	push   %ebp
  8018ce:	89 e5                	mov    %esp,%ebp
  8018d0:	57                   	push   %edi
  8018d1:	56                   	push   %esi
  8018d2:	53                   	push   %ebx
	asm volatile("int %1\n"
  8018d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8018d8:	b8 0e 00 00 00       	mov    $0xe,%eax
  8018dd:	89 d1                	mov    %edx,%ecx
  8018df:	89 d3                	mov    %edx,%ebx
  8018e1:	89 d7                	mov    %edx,%edi
  8018e3:	89 d6                	mov    %edx,%esi
  8018e5:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8018e7:	5b                   	pop    %ebx
  8018e8:	5e                   	pop    %esi
  8018e9:	5f                   	pop    %edi
  8018ea:	5d                   	pop    %ebp
  8018eb:	c3                   	ret    

008018ec <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  8018ec:	55                   	push   %ebp
  8018ed:	89 e5                	mov    %esp,%ebp
  8018ef:	57                   	push   %edi
  8018f0:	56                   	push   %esi
  8018f1:	53                   	push   %ebx
  8018f2:	83 ec 1c             	sub    $0x1c,%esp
  8018f5:	8b 45 08             	mov    0x8(%ebp),%eax
    void *addr = (void *) utf->utf_fault_va;
  8018f8:	8b 18                	mov    (%eax),%ebx
    uint32_t err = utf->utf_err;
  8018fa:	8b 78 04             	mov    0x4(%eax),%edi
    pte_t pte = uvpt[PGNUM(addr)];
  8018fd:	89 d8                	mov    %ebx,%eax
  8018ff:	c1 e8 0c             	shr    $0xc,%eax
  801902:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801909:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    envid_t envid = sys_getenvid();
  80190c:	e8 8d fd ff ff       	call   80169e <sys_getenvid>
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if ((err & FEC_WR) == 0 || (pte & PTE_COW) == 0) {
  801911:	f7 c7 02 00 00 00    	test   $0x2,%edi
  801917:	74 73                	je     80198c <pgfault+0xa0>
  801919:	89 c6                	mov    %eax,%esi
  80191b:	f7 45 e4 00 08 00 00 	testl  $0x800,-0x1c(%ebp)
  801922:	74 68                	je     80198c <pgfault+0xa0>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	if ((r = sys_page_alloc(envid, PFTEMP, PTE_W | PTE_U | PTE_P)) != 0) {
  801924:	83 ec 04             	sub    $0x4,%esp
  801927:	6a 07                	push   $0x7
  801929:	68 00 f0 7f 00       	push   $0x7ff000
  80192e:	50                   	push   %eax
  80192f:	e8 a8 fd ff ff       	call   8016dc <sys_page_alloc>
  801934:	83 c4 10             	add    $0x10,%esp
  801937:	85 c0                	test   %eax,%eax
  801939:	75 65                	jne    8019a0 <pgfault+0xb4>
	    panic("pgfault: %e", r);
	}
	memcpy(PFTEMP, ROUNDDOWN(addr, PGSIZE), PGSIZE);
  80193b:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  801941:	83 ec 04             	sub    $0x4,%esp
  801944:	68 00 10 00 00       	push   $0x1000
  801949:	53                   	push   %ebx
  80194a:	68 00 f0 7f 00       	push   $0x7ff000
  80194f:	e8 85 fb ff ff       	call   8014d9 <memcpy>
	if ((r = sys_page_map(envid, PFTEMP, envid, ROUNDDOWN(addr, PGSIZE), PTE_W | PTE_U | PTE_P)) != 0) {
  801954:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  80195b:	53                   	push   %ebx
  80195c:	56                   	push   %esi
  80195d:	68 00 f0 7f 00       	push   $0x7ff000
  801962:	56                   	push   %esi
  801963:	e8 b7 fd ff ff       	call   80171f <sys_page_map>
  801968:	83 c4 20             	add    $0x20,%esp
  80196b:	85 c0                	test   %eax,%eax
  80196d:	75 43                	jne    8019b2 <pgfault+0xc6>
	    panic("pgfault: %e", r);
	}
	if ((r = sys_page_unmap(envid, PFTEMP)) != 0) {
  80196f:	83 ec 08             	sub    $0x8,%esp
  801972:	68 00 f0 7f 00       	push   $0x7ff000
  801977:	56                   	push   %esi
  801978:	e8 e4 fd ff ff       	call   801761 <sys_page_unmap>
  80197d:	83 c4 10             	add    $0x10,%esp
  801980:	85 c0                	test   %eax,%eax
  801982:	75 40                	jne    8019c4 <pgfault+0xd8>
	    panic("pgfault: %e", r);
	}
}
  801984:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801987:	5b                   	pop    %ebx
  801988:	5e                   	pop    %esi
  801989:	5f                   	pop    %edi
  80198a:	5d                   	pop    %ebp
  80198b:	c3                   	ret    
	    panic("pgfault: bad faulting access\n");
  80198c:	83 ec 04             	sub    $0x4,%esp
  80198f:	68 3a 3e 80 00       	push   $0x803e3a
  801994:	6a 1f                	push   $0x1f
  801996:	68 58 3e 80 00       	push   $0x803e58
  80199b:	e8 db f0 ff ff       	call   800a7b <_panic>
	    panic("pgfault: %e", r);
  8019a0:	50                   	push   %eax
  8019a1:	68 63 3e 80 00       	push   $0x803e63
  8019a6:	6a 2a                	push   $0x2a
  8019a8:	68 58 3e 80 00       	push   $0x803e58
  8019ad:	e8 c9 f0 ff ff       	call   800a7b <_panic>
	    panic("pgfault: %e", r);
  8019b2:	50                   	push   %eax
  8019b3:	68 63 3e 80 00       	push   $0x803e63
  8019b8:	6a 2e                	push   $0x2e
  8019ba:	68 58 3e 80 00       	push   $0x803e58
  8019bf:	e8 b7 f0 ff ff       	call   800a7b <_panic>
	    panic("pgfault: %e", r);
  8019c4:	50                   	push   %eax
  8019c5:	68 63 3e 80 00       	push   $0x803e63
  8019ca:	6a 31                	push   $0x31
  8019cc:	68 58 3e 80 00       	push   $0x803e58
  8019d1:	e8 a5 f0 ff ff       	call   800a7b <_panic>

008019d6 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8019d6:	55                   	push   %ebp
  8019d7:	89 e5                	mov    %esp,%ebp
  8019d9:	57                   	push   %edi
  8019da:	56                   	push   %esi
  8019db:	53                   	push   %ebx
  8019dc:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	envid_t envid;
	uint32_t addr;
	int r;

	set_pgfault_handler(pgfault);
  8019df:	68 ec 18 80 00       	push   $0x8018ec
  8019e4:	e8 be 1a 00 00       	call   8034a7 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8019e9:	b8 07 00 00 00       	mov    $0x7,%eax
  8019ee:	cd 30                	int    $0x30
  8019f0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8019f3:	89 45 e0             	mov    %eax,-0x20(%ebp)
	envid = sys_exofork();
	if (envid < 0) {
  8019f6:	83 c4 10             	add    $0x10,%esp
  8019f9:	85 c0                	test   %eax,%eax
  8019fb:	78 2b                	js     801a28 <fork+0x52>
	    thisenv = &envs[ENVX(sys_getenvid())];
	    return 0;
	}

	// copy the address space mappings to child
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  8019fd:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {
  801a02:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801a06:	0f 85 b5 00 00 00    	jne    801ac1 <fork+0xeb>
	    thisenv = &envs[ENVX(sys_getenvid())];
  801a0c:	e8 8d fc ff ff       	call   80169e <sys_getenvid>
  801a11:	25 ff 03 00 00       	and    $0x3ff,%eax
  801a16:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801a19:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801a1e:	a3 28 64 80 00       	mov    %eax,0x806428
	    return 0;
  801a23:	e9 8c 01 00 00       	jmp    801bb4 <fork+0x1de>
	    panic("sys_exofork: %e", envid);
  801a28:	50                   	push   %eax
  801a29:	68 6f 3e 80 00       	push   $0x803e6f
  801a2e:	6a 77                	push   $0x77
  801a30:	68 58 3e 80 00       	push   $0x803e58
  801a35:	e8 41 f0 ff ff       	call   800a7b <_panic>
        if ((r = sys_page_map(parent_envid, va, envid, va, uvpt[pn] & PTE_SYSCALL)) != 0) {
  801a3a:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801a41:	83 ec 0c             	sub    $0xc,%esp
  801a44:	25 07 0e 00 00       	and    $0xe07,%eax
  801a49:	50                   	push   %eax
  801a4a:	57                   	push   %edi
  801a4b:	ff 75 e0             	pushl  -0x20(%ebp)
  801a4e:	57                   	push   %edi
  801a4f:	ff 75 e4             	pushl  -0x1c(%ebp)
  801a52:	e8 c8 fc ff ff       	call   80171f <sys_page_map>
  801a57:	83 c4 20             	add    $0x20,%esp
  801a5a:	85 c0                	test   %eax,%eax
  801a5c:	74 51                	je     801aaf <fork+0xd9>
           panic("duppage: %e", r);
  801a5e:	50                   	push   %eax
  801a5f:	68 7f 3e 80 00       	push   $0x803e7f
  801a64:	6a 4a                	push   $0x4a
  801a66:	68 58 3e 80 00       	push   $0x803e58
  801a6b:	e8 0b f0 ff ff       	call   800a7b <_panic>
	    if ((r = sys_page_map(parent_envid, va, envid, va, PTE_COW | PTE_U | PTE_P)) != 0) {
  801a70:	83 ec 0c             	sub    $0xc,%esp
  801a73:	68 05 08 00 00       	push   $0x805
  801a78:	57                   	push   %edi
  801a79:	ff 75 e0             	pushl  -0x20(%ebp)
  801a7c:	57                   	push   %edi
  801a7d:	ff 75 e4             	pushl  -0x1c(%ebp)
  801a80:	e8 9a fc ff ff       	call   80171f <sys_page_map>
  801a85:	83 c4 20             	add    $0x20,%esp
  801a88:	85 c0                	test   %eax,%eax
  801a8a:	0f 85 bc 00 00 00    	jne    801b4c <fork+0x176>
	    if ((r = sys_page_map(parent_envid, va, parent_envid, va, PTE_COW | PTE_U | PTE_P)) != 0) {
  801a90:	83 ec 0c             	sub    $0xc,%esp
  801a93:	68 05 08 00 00       	push   $0x805
  801a98:	57                   	push   %edi
  801a99:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a9c:	50                   	push   %eax
  801a9d:	57                   	push   %edi
  801a9e:	50                   	push   %eax
  801a9f:	e8 7b fc ff ff       	call   80171f <sys_page_map>
  801aa4:	83 c4 20             	add    $0x20,%esp
  801aa7:	85 c0                	test   %eax,%eax
  801aa9:	0f 85 af 00 00 00    	jne    801b5e <fork+0x188>
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  801aaf:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801ab5:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801abb:	0f 84 af 00 00 00    	je     801b70 <fork+0x19a>
	    if ((uvpd[PDX(addr)] & PTE_P) == PTE_P && (uvpt[PGNUM(addr)] & PTE_P) == PTE_P) {
  801ac1:	89 d8                	mov    %ebx,%eax
  801ac3:	c1 e8 16             	shr    $0x16,%eax
  801ac6:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801acd:	a8 01                	test   $0x1,%al
  801acf:	74 de                	je     801aaf <fork+0xd9>
  801ad1:	89 de                	mov    %ebx,%esi
  801ad3:	c1 ee 0c             	shr    $0xc,%esi
  801ad6:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801add:	a8 01                	test   $0x1,%al
  801adf:	74 ce                	je     801aaf <fork+0xd9>
	envid_t parent_envid = sys_getenvid();
  801ae1:	e8 b8 fb ff ff       	call   80169e <sys_getenvid>
  801ae6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	void *va = (void *)(pn * PGSIZE);
  801ae9:	89 f7                	mov    %esi,%edi
  801aeb:	c1 e7 0c             	shl    $0xc,%edi
	if ((uvpt[pn] & PTE_SHARE) == PTE_SHARE) {
  801aee:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801af5:	f6 c4 04             	test   $0x4,%ah
  801af8:	0f 85 3c ff ff ff    	jne    801a3a <fork+0x64>
    } else if ((uvpt[pn] & PTE_W) == PTE_W || (uvpt[pn] & PTE_COW) == PTE_COW) {
  801afe:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801b05:	a8 02                	test   $0x2,%al
  801b07:	0f 85 63 ff ff ff    	jne    801a70 <fork+0x9a>
  801b0d:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801b14:	f6 c4 08             	test   $0x8,%ah
  801b17:	0f 85 53 ff ff ff    	jne    801a70 <fork+0x9a>
	    if ((r = sys_page_map(parent_envid, va, envid, va, PTE_U | PTE_P)) != 0) {
  801b1d:	83 ec 0c             	sub    $0xc,%esp
  801b20:	6a 05                	push   $0x5
  801b22:	57                   	push   %edi
  801b23:	ff 75 e0             	pushl  -0x20(%ebp)
  801b26:	57                   	push   %edi
  801b27:	ff 75 e4             	pushl  -0x1c(%ebp)
  801b2a:	e8 f0 fb ff ff       	call   80171f <sys_page_map>
  801b2f:	83 c4 20             	add    $0x20,%esp
  801b32:	85 c0                	test   %eax,%eax
  801b34:	0f 84 75 ff ff ff    	je     801aaf <fork+0xd9>
	        panic("duppage: %e", r);
  801b3a:	50                   	push   %eax
  801b3b:	68 7f 3e 80 00       	push   $0x803e7f
  801b40:	6a 55                	push   $0x55
  801b42:	68 58 3e 80 00       	push   $0x803e58
  801b47:	e8 2f ef ff ff       	call   800a7b <_panic>
	        panic("duppage: %e", r);
  801b4c:	50                   	push   %eax
  801b4d:	68 7f 3e 80 00       	push   $0x803e7f
  801b52:	6a 4e                	push   $0x4e
  801b54:	68 58 3e 80 00       	push   $0x803e58
  801b59:	e8 1d ef ff ff       	call   800a7b <_panic>
	        panic("duppage: %e", r);
  801b5e:	50                   	push   %eax
  801b5f:	68 7f 3e 80 00       	push   $0x803e7f
  801b64:	6a 51                	push   $0x51
  801b66:	68 58 3e 80 00       	push   $0x803e58
  801b6b:	e8 0b ef ff ff       	call   800a7b <_panic>
	}

	// allocate new page for child's user exception stack
	void _pgfault_upcall();

	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P)) != 0) {
  801b70:	83 ec 04             	sub    $0x4,%esp
  801b73:	6a 07                	push   $0x7
  801b75:	68 00 f0 bf ee       	push   $0xeebff000
  801b7a:	ff 75 dc             	pushl  -0x24(%ebp)
  801b7d:	e8 5a fb ff ff       	call   8016dc <sys_page_alloc>
  801b82:	83 c4 10             	add    $0x10,%esp
  801b85:	85 c0                	test   %eax,%eax
  801b87:	75 36                	jne    801bbf <fork+0x1e9>
	    panic("fork: %e", r);
	}
	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) != 0) {
  801b89:	83 ec 08             	sub    $0x8,%esp
  801b8c:	68 20 35 80 00       	push   $0x803520
  801b91:	ff 75 dc             	pushl  -0x24(%ebp)
  801b94:	e8 8e fc ff ff       	call   801827 <sys_env_set_pgfault_upcall>
  801b99:	83 c4 10             	add    $0x10,%esp
  801b9c:	85 c0                	test   %eax,%eax
  801b9e:	75 34                	jne    801bd4 <fork+0x1fe>
	    panic("fork: %e", r);
	}

	// mark the child as runnable
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) != 0)
  801ba0:	83 ec 08             	sub    $0x8,%esp
  801ba3:	6a 02                	push   $0x2
  801ba5:	ff 75 dc             	pushl  -0x24(%ebp)
  801ba8:	e8 f6 fb ff ff       	call   8017a3 <sys_env_set_status>
  801bad:	83 c4 10             	add    $0x10,%esp
  801bb0:	85 c0                	test   %eax,%eax
  801bb2:	75 35                	jne    801be9 <fork+0x213>
	    panic("fork: %e", r);

	return envid;
}
  801bb4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801bb7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801bba:	5b                   	pop    %ebx
  801bbb:	5e                   	pop    %esi
  801bbc:	5f                   	pop    %edi
  801bbd:	5d                   	pop    %ebp
  801bbe:	c3                   	ret    
	    panic("fork: %e", r);
  801bbf:	50                   	push   %eax
  801bc0:	68 76 3e 80 00       	push   $0x803e76
  801bc5:	68 8a 00 00 00       	push   $0x8a
  801bca:	68 58 3e 80 00       	push   $0x803e58
  801bcf:	e8 a7 ee ff ff       	call   800a7b <_panic>
	    panic("fork: %e", r);
  801bd4:	50                   	push   %eax
  801bd5:	68 76 3e 80 00       	push   $0x803e76
  801bda:	68 8d 00 00 00       	push   $0x8d
  801bdf:	68 58 3e 80 00       	push   $0x803e58
  801be4:	e8 92 ee ff ff       	call   800a7b <_panic>
	    panic("fork: %e", r);
  801be9:	50                   	push   %eax
  801bea:	68 76 3e 80 00       	push   $0x803e76
  801bef:	68 92 00 00 00       	push   $0x92
  801bf4:	68 58 3e 80 00       	push   $0x803e58
  801bf9:	e8 7d ee ff ff       	call   800a7b <_panic>

00801bfe <sfork>:

// Challenge!
int
sfork(void)
{
  801bfe:	55                   	push   %ebp
  801bff:	89 e5                	mov    %esp,%ebp
  801c01:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801c04:	68 8b 3e 80 00       	push   $0x803e8b
  801c09:	68 9b 00 00 00       	push   $0x9b
  801c0e:	68 58 3e 80 00       	push   $0x803e58
  801c13:	e8 63 ee ff ff       	call   800a7b <_panic>

00801c18 <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  801c18:	55                   	push   %ebp
  801c19:	89 e5                	mov    %esp,%ebp
  801c1b:	8b 55 08             	mov    0x8(%ebp),%edx
  801c1e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c21:	8b 45 10             	mov    0x10(%ebp),%eax
	args->argc = argc;
  801c24:	89 10                	mov    %edx,(%eax)
	args->argv = (const char **) argv;
  801c26:	89 48 04             	mov    %ecx,0x4(%eax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  801c29:	83 3a 01             	cmpl   $0x1,(%edx)
  801c2c:	7e 09                	jle    801c37 <argstart+0x1f>
  801c2e:	ba e1 38 80 00       	mov    $0x8038e1,%edx
  801c33:	85 c9                	test   %ecx,%ecx
  801c35:	75 05                	jne    801c3c <argstart+0x24>
  801c37:	ba 00 00 00 00       	mov    $0x0,%edx
  801c3c:	89 50 08             	mov    %edx,0x8(%eax)
	args->argvalue = 0;
  801c3f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  801c46:	5d                   	pop    %ebp
  801c47:	c3                   	ret    

00801c48 <argnext>:

int
argnext(struct Argstate *args)
{
  801c48:	55                   	push   %ebp
  801c49:	89 e5                	mov    %esp,%ebp
  801c4b:	53                   	push   %ebx
  801c4c:	83 ec 04             	sub    $0x4,%esp
  801c4f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int arg;

	args->argvalue = 0;
  801c52:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  801c59:	8b 43 08             	mov    0x8(%ebx),%eax
  801c5c:	85 c0                	test   %eax,%eax
  801c5e:	74 72                	je     801cd2 <argnext+0x8a>
		return -1;

	if (!*args->curarg) {
  801c60:	80 38 00             	cmpb   $0x0,(%eax)
  801c63:	75 48                	jne    801cad <argnext+0x65>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  801c65:	8b 0b                	mov    (%ebx),%ecx
  801c67:	83 39 01             	cmpl   $0x1,(%ecx)
  801c6a:	74 58                	je     801cc4 <argnext+0x7c>
		    || args->argv[1][0] != '-'
  801c6c:	8b 53 04             	mov    0x4(%ebx),%edx
  801c6f:	8b 42 04             	mov    0x4(%edx),%eax
  801c72:	80 38 2d             	cmpb   $0x2d,(%eax)
  801c75:	75 4d                	jne    801cc4 <argnext+0x7c>
		    || args->argv[1][1] == '\0')
  801c77:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  801c7b:	74 47                	je     801cc4 <argnext+0x7c>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  801c7d:	83 c0 01             	add    $0x1,%eax
  801c80:	89 43 08             	mov    %eax,0x8(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801c83:	83 ec 04             	sub    $0x4,%esp
  801c86:	8b 01                	mov    (%ecx),%eax
  801c88:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  801c8f:	50                   	push   %eax
  801c90:	8d 42 08             	lea    0x8(%edx),%eax
  801c93:	50                   	push   %eax
  801c94:	83 c2 04             	add    $0x4,%edx
  801c97:	52                   	push   %edx
  801c98:	e8 d4 f7 ff ff       	call   801471 <memmove>
		(*args->argc)--;
  801c9d:	8b 03                	mov    (%ebx),%eax
  801c9f:	83 28 01             	subl   $0x1,(%eax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  801ca2:	8b 43 08             	mov    0x8(%ebx),%eax
  801ca5:	83 c4 10             	add    $0x10,%esp
  801ca8:	80 38 2d             	cmpb   $0x2d,(%eax)
  801cab:	74 11                	je     801cbe <argnext+0x76>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  801cad:	8b 53 08             	mov    0x8(%ebx),%edx
  801cb0:	0f b6 02             	movzbl (%edx),%eax
	args->curarg++;
  801cb3:	83 c2 01             	add    $0x1,%edx
  801cb6:	89 53 08             	mov    %edx,0x8(%ebx)
	return arg;

    endofargs:
	args->curarg = 0;
	return -1;
}
  801cb9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cbc:	c9                   	leave  
  801cbd:	c3                   	ret    
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  801cbe:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  801cc2:	75 e9                	jne    801cad <argnext+0x65>
	args->curarg = 0;
  801cc4:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	return -1;
  801ccb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801cd0:	eb e7                	jmp    801cb9 <argnext+0x71>
		return -1;
  801cd2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801cd7:	eb e0                	jmp    801cb9 <argnext+0x71>

00801cd9 <argnextvalue>:
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args)
{
  801cd9:	55                   	push   %ebp
  801cda:	89 e5                	mov    %esp,%ebp
  801cdc:	53                   	push   %ebx
  801cdd:	83 ec 04             	sub    $0x4,%esp
  801ce0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!args->curarg)
  801ce3:	8b 43 08             	mov    0x8(%ebx),%eax
  801ce6:	85 c0                	test   %eax,%eax
  801ce8:	74 5b                	je     801d45 <argnextvalue+0x6c>
		return 0;
	if (*args->curarg) {
  801cea:	80 38 00             	cmpb   $0x0,(%eax)
  801ced:	74 12                	je     801d01 <argnextvalue+0x28>
		args->argvalue = args->curarg;
  801cef:	89 43 0c             	mov    %eax,0xc(%ebx)
		args->curarg = "";
  801cf2:	c7 43 08 e1 38 80 00 	movl   $0x8038e1,0x8(%ebx)
		(*args->argc)--;
	} else {
		args->argvalue = 0;
		args->curarg = 0;
	}
	return (char*) args->argvalue;
  801cf9:	8b 43 0c             	mov    0xc(%ebx),%eax
}
  801cfc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cff:	c9                   	leave  
  801d00:	c3                   	ret    
	} else if (*args->argc > 1) {
  801d01:	8b 13                	mov    (%ebx),%edx
  801d03:	83 3a 01             	cmpl   $0x1,(%edx)
  801d06:	7f 10                	jg     801d18 <argnextvalue+0x3f>
		args->argvalue = 0;
  801d08:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		args->curarg = 0;
  801d0f:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  801d16:	eb e1                	jmp    801cf9 <argnextvalue+0x20>
		args->argvalue = args->argv[1];
  801d18:	8b 43 04             	mov    0x4(%ebx),%eax
  801d1b:	8b 48 04             	mov    0x4(%eax),%ecx
  801d1e:	89 4b 0c             	mov    %ecx,0xc(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801d21:	83 ec 04             	sub    $0x4,%esp
  801d24:	8b 12                	mov    (%edx),%edx
  801d26:	8d 14 95 fc ff ff ff 	lea    -0x4(,%edx,4),%edx
  801d2d:	52                   	push   %edx
  801d2e:	8d 50 08             	lea    0x8(%eax),%edx
  801d31:	52                   	push   %edx
  801d32:	83 c0 04             	add    $0x4,%eax
  801d35:	50                   	push   %eax
  801d36:	e8 36 f7 ff ff       	call   801471 <memmove>
		(*args->argc)--;
  801d3b:	8b 03                	mov    (%ebx),%eax
  801d3d:	83 28 01             	subl   $0x1,(%eax)
  801d40:	83 c4 10             	add    $0x10,%esp
  801d43:	eb b4                	jmp    801cf9 <argnextvalue+0x20>
		return 0;
  801d45:	b8 00 00 00 00       	mov    $0x0,%eax
  801d4a:	eb b0                	jmp    801cfc <argnextvalue+0x23>

00801d4c <argvalue>:
{
  801d4c:	55                   	push   %ebp
  801d4d:	89 e5                	mov    %esp,%ebp
  801d4f:	83 ec 08             	sub    $0x8,%esp
  801d52:	8b 55 08             	mov    0x8(%ebp),%edx
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  801d55:	8b 42 0c             	mov    0xc(%edx),%eax
  801d58:	85 c0                	test   %eax,%eax
  801d5a:	74 02                	je     801d5e <argvalue+0x12>
}
  801d5c:	c9                   	leave  
  801d5d:	c3                   	ret    
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  801d5e:	83 ec 0c             	sub    $0xc,%esp
  801d61:	52                   	push   %edx
  801d62:	e8 72 ff ff ff       	call   801cd9 <argnextvalue>
  801d67:	83 c4 10             	add    $0x10,%esp
  801d6a:	eb f0                	jmp    801d5c <argvalue+0x10>

00801d6c <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801d6c:	55                   	push   %ebp
  801d6d:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801d6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d72:	05 00 00 00 30       	add    $0x30000000,%eax
  801d77:	c1 e8 0c             	shr    $0xc,%eax
}
  801d7a:	5d                   	pop    %ebp
  801d7b:	c3                   	ret    

00801d7c <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801d7c:	55                   	push   %ebp
  801d7d:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801d7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d82:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801d87:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801d8c:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801d91:	5d                   	pop    %ebp
  801d92:	c3                   	ret    

00801d93 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801d93:	55                   	push   %ebp
  801d94:	89 e5                	mov    %esp,%ebp
  801d96:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d99:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801d9e:	89 c2                	mov    %eax,%edx
  801da0:	c1 ea 16             	shr    $0x16,%edx
  801da3:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801daa:	f6 c2 01             	test   $0x1,%dl
  801dad:	74 2a                	je     801dd9 <fd_alloc+0x46>
  801daf:	89 c2                	mov    %eax,%edx
  801db1:	c1 ea 0c             	shr    $0xc,%edx
  801db4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801dbb:	f6 c2 01             	test   $0x1,%dl
  801dbe:	74 19                	je     801dd9 <fd_alloc+0x46>
  801dc0:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801dc5:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801dca:	75 d2                	jne    801d9e <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801dcc:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  801dd2:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801dd7:	eb 07                	jmp    801de0 <fd_alloc+0x4d>
			*fd_store = fd;
  801dd9:	89 01                	mov    %eax,(%ecx)
			return 0;
  801ddb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801de0:	5d                   	pop    %ebp
  801de1:	c3                   	ret    

00801de2 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801de2:	55                   	push   %ebp
  801de3:	89 e5                	mov    %esp,%ebp
  801de5:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801de8:	83 f8 1f             	cmp    $0x1f,%eax
  801deb:	77 36                	ja     801e23 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801ded:	c1 e0 0c             	shl    $0xc,%eax
  801df0:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801df5:	89 c2                	mov    %eax,%edx
  801df7:	c1 ea 16             	shr    $0x16,%edx
  801dfa:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801e01:	f6 c2 01             	test   $0x1,%dl
  801e04:	74 24                	je     801e2a <fd_lookup+0x48>
  801e06:	89 c2                	mov    %eax,%edx
  801e08:	c1 ea 0c             	shr    $0xc,%edx
  801e0b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801e12:	f6 c2 01             	test   $0x1,%dl
  801e15:	74 1a                	je     801e31 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801e17:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e1a:	89 02                	mov    %eax,(%edx)
	return 0;
  801e1c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e21:	5d                   	pop    %ebp
  801e22:	c3                   	ret    
		return -E_INVAL;
  801e23:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e28:	eb f7                	jmp    801e21 <fd_lookup+0x3f>
		return -E_INVAL;
  801e2a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e2f:	eb f0                	jmp    801e21 <fd_lookup+0x3f>
  801e31:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e36:	eb e9                	jmp    801e21 <fd_lookup+0x3f>

00801e38 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801e38:	55                   	push   %ebp
  801e39:	89 e5                	mov    %esp,%ebp
  801e3b:	83 ec 08             	sub    $0x8,%esp
  801e3e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e41:	ba 20 3f 80 00       	mov    $0x803f20,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801e46:	b8 20 50 80 00       	mov    $0x805020,%eax
		if (devtab[i]->dev_id == dev_id) {
  801e4b:	39 08                	cmp    %ecx,(%eax)
  801e4d:	74 33                	je     801e82 <dev_lookup+0x4a>
  801e4f:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801e52:	8b 02                	mov    (%edx),%eax
  801e54:	85 c0                	test   %eax,%eax
  801e56:	75 f3                	jne    801e4b <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801e58:	a1 28 64 80 00       	mov    0x806428,%eax
  801e5d:	8b 40 48             	mov    0x48(%eax),%eax
  801e60:	83 ec 04             	sub    $0x4,%esp
  801e63:	51                   	push   %ecx
  801e64:	50                   	push   %eax
  801e65:	68 a4 3e 80 00       	push   $0x803ea4
  801e6a:	e8 e7 ec ff ff       	call   800b56 <cprintf>
	*dev = 0;
  801e6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e72:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801e78:	83 c4 10             	add    $0x10,%esp
  801e7b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801e80:	c9                   	leave  
  801e81:	c3                   	ret    
			*dev = devtab[i];
  801e82:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e85:	89 01                	mov    %eax,(%ecx)
			return 0;
  801e87:	b8 00 00 00 00       	mov    $0x0,%eax
  801e8c:	eb f2                	jmp    801e80 <dev_lookup+0x48>

00801e8e <fd_close>:
{
  801e8e:	55                   	push   %ebp
  801e8f:	89 e5                	mov    %esp,%ebp
  801e91:	57                   	push   %edi
  801e92:	56                   	push   %esi
  801e93:	53                   	push   %ebx
  801e94:	83 ec 1c             	sub    $0x1c,%esp
  801e97:	8b 75 08             	mov    0x8(%ebp),%esi
  801e9a:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801e9d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801ea0:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801ea1:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801ea7:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801eaa:	50                   	push   %eax
  801eab:	e8 32 ff ff ff       	call   801de2 <fd_lookup>
  801eb0:	89 c3                	mov    %eax,%ebx
  801eb2:	83 c4 08             	add    $0x8,%esp
  801eb5:	85 c0                	test   %eax,%eax
  801eb7:	78 05                	js     801ebe <fd_close+0x30>
	    || fd != fd2)
  801eb9:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801ebc:	74 16                	je     801ed4 <fd_close+0x46>
		return (must_exist ? r : 0);
  801ebe:	89 f8                	mov    %edi,%eax
  801ec0:	84 c0                	test   %al,%al
  801ec2:	b8 00 00 00 00       	mov    $0x0,%eax
  801ec7:	0f 44 d8             	cmove  %eax,%ebx
}
  801eca:	89 d8                	mov    %ebx,%eax
  801ecc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ecf:	5b                   	pop    %ebx
  801ed0:	5e                   	pop    %esi
  801ed1:	5f                   	pop    %edi
  801ed2:	5d                   	pop    %ebp
  801ed3:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801ed4:	83 ec 08             	sub    $0x8,%esp
  801ed7:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801eda:	50                   	push   %eax
  801edb:	ff 36                	pushl  (%esi)
  801edd:	e8 56 ff ff ff       	call   801e38 <dev_lookup>
  801ee2:	89 c3                	mov    %eax,%ebx
  801ee4:	83 c4 10             	add    $0x10,%esp
  801ee7:	85 c0                	test   %eax,%eax
  801ee9:	78 15                	js     801f00 <fd_close+0x72>
		if (dev->dev_close)
  801eeb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801eee:	8b 40 10             	mov    0x10(%eax),%eax
  801ef1:	85 c0                	test   %eax,%eax
  801ef3:	74 1b                	je     801f10 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  801ef5:	83 ec 0c             	sub    $0xc,%esp
  801ef8:	56                   	push   %esi
  801ef9:	ff d0                	call   *%eax
  801efb:	89 c3                	mov    %eax,%ebx
  801efd:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801f00:	83 ec 08             	sub    $0x8,%esp
  801f03:	56                   	push   %esi
  801f04:	6a 00                	push   $0x0
  801f06:	e8 56 f8 ff ff       	call   801761 <sys_page_unmap>
	return r;
  801f0b:	83 c4 10             	add    $0x10,%esp
  801f0e:	eb ba                	jmp    801eca <fd_close+0x3c>
			r = 0;
  801f10:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f15:	eb e9                	jmp    801f00 <fd_close+0x72>

00801f17 <close>:

int
close(int fdnum)
{
  801f17:	55                   	push   %ebp
  801f18:	89 e5                	mov    %esp,%ebp
  801f1a:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f1d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f20:	50                   	push   %eax
  801f21:	ff 75 08             	pushl  0x8(%ebp)
  801f24:	e8 b9 fe ff ff       	call   801de2 <fd_lookup>
  801f29:	83 c4 08             	add    $0x8,%esp
  801f2c:	85 c0                	test   %eax,%eax
  801f2e:	78 10                	js     801f40 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  801f30:	83 ec 08             	sub    $0x8,%esp
  801f33:	6a 01                	push   $0x1
  801f35:	ff 75 f4             	pushl  -0xc(%ebp)
  801f38:	e8 51 ff ff ff       	call   801e8e <fd_close>
  801f3d:	83 c4 10             	add    $0x10,%esp
}
  801f40:	c9                   	leave  
  801f41:	c3                   	ret    

00801f42 <close_all>:

void
close_all(void)
{
  801f42:	55                   	push   %ebp
  801f43:	89 e5                	mov    %esp,%ebp
  801f45:	53                   	push   %ebx
  801f46:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801f49:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801f4e:	83 ec 0c             	sub    $0xc,%esp
  801f51:	53                   	push   %ebx
  801f52:	e8 c0 ff ff ff       	call   801f17 <close>
	for (i = 0; i < MAXFD; i++)
  801f57:	83 c3 01             	add    $0x1,%ebx
  801f5a:	83 c4 10             	add    $0x10,%esp
  801f5d:	83 fb 20             	cmp    $0x20,%ebx
  801f60:	75 ec                	jne    801f4e <close_all+0xc>
}
  801f62:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f65:	c9                   	leave  
  801f66:	c3                   	ret    

00801f67 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801f67:	55                   	push   %ebp
  801f68:	89 e5                	mov    %esp,%ebp
  801f6a:	57                   	push   %edi
  801f6b:	56                   	push   %esi
  801f6c:	53                   	push   %ebx
  801f6d:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801f70:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801f73:	50                   	push   %eax
  801f74:	ff 75 08             	pushl  0x8(%ebp)
  801f77:	e8 66 fe ff ff       	call   801de2 <fd_lookup>
  801f7c:	89 c3                	mov    %eax,%ebx
  801f7e:	83 c4 08             	add    $0x8,%esp
  801f81:	85 c0                	test   %eax,%eax
  801f83:	0f 88 81 00 00 00    	js     80200a <dup+0xa3>
		return r;
	close(newfdnum);
  801f89:	83 ec 0c             	sub    $0xc,%esp
  801f8c:	ff 75 0c             	pushl  0xc(%ebp)
  801f8f:	e8 83 ff ff ff       	call   801f17 <close>

	newfd = INDEX2FD(newfdnum);
  801f94:	8b 75 0c             	mov    0xc(%ebp),%esi
  801f97:	c1 e6 0c             	shl    $0xc,%esi
  801f9a:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801fa0:	83 c4 04             	add    $0x4,%esp
  801fa3:	ff 75 e4             	pushl  -0x1c(%ebp)
  801fa6:	e8 d1 fd ff ff       	call   801d7c <fd2data>
  801fab:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801fad:	89 34 24             	mov    %esi,(%esp)
  801fb0:	e8 c7 fd ff ff       	call   801d7c <fd2data>
  801fb5:	83 c4 10             	add    $0x10,%esp
  801fb8:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801fba:	89 d8                	mov    %ebx,%eax
  801fbc:	c1 e8 16             	shr    $0x16,%eax
  801fbf:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801fc6:	a8 01                	test   $0x1,%al
  801fc8:	74 11                	je     801fdb <dup+0x74>
  801fca:	89 d8                	mov    %ebx,%eax
  801fcc:	c1 e8 0c             	shr    $0xc,%eax
  801fcf:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801fd6:	f6 c2 01             	test   $0x1,%dl
  801fd9:	75 39                	jne    802014 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801fdb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801fde:	89 d0                	mov    %edx,%eax
  801fe0:	c1 e8 0c             	shr    $0xc,%eax
  801fe3:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801fea:	83 ec 0c             	sub    $0xc,%esp
  801fed:	25 07 0e 00 00       	and    $0xe07,%eax
  801ff2:	50                   	push   %eax
  801ff3:	56                   	push   %esi
  801ff4:	6a 00                	push   $0x0
  801ff6:	52                   	push   %edx
  801ff7:	6a 00                	push   $0x0
  801ff9:	e8 21 f7 ff ff       	call   80171f <sys_page_map>
  801ffe:	89 c3                	mov    %eax,%ebx
  802000:	83 c4 20             	add    $0x20,%esp
  802003:	85 c0                	test   %eax,%eax
  802005:	78 31                	js     802038 <dup+0xd1>
		goto err;

	return newfdnum;
  802007:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80200a:	89 d8                	mov    %ebx,%eax
  80200c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80200f:	5b                   	pop    %ebx
  802010:	5e                   	pop    %esi
  802011:	5f                   	pop    %edi
  802012:	5d                   	pop    %ebp
  802013:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802014:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80201b:	83 ec 0c             	sub    $0xc,%esp
  80201e:	25 07 0e 00 00       	and    $0xe07,%eax
  802023:	50                   	push   %eax
  802024:	57                   	push   %edi
  802025:	6a 00                	push   $0x0
  802027:	53                   	push   %ebx
  802028:	6a 00                	push   $0x0
  80202a:	e8 f0 f6 ff ff       	call   80171f <sys_page_map>
  80202f:	89 c3                	mov    %eax,%ebx
  802031:	83 c4 20             	add    $0x20,%esp
  802034:	85 c0                	test   %eax,%eax
  802036:	79 a3                	jns    801fdb <dup+0x74>
	sys_page_unmap(0, newfd);
  802038:	83 ec 08             	sub    $0x8,%esp
  80203b:	56                   	push   %esi
  80203c:	6a 00                	push   $0x0
  80203e:	e8 1e f7 ff ff       	call   801761 <sys_page_unmap>
	sys_page_unmap(0, nva);
  802043:	83 c4 08             	add    $0x8,%esp
  802046:	57                   	push   %edi
  802047:	6a 00                	push   $0x0
  802049:	e8 13 f7 ff ff       	call   801761 <sys_page_unmap>
	return r;
  80204e:	83 c4 10             	add    $0x10,%esp
  802051:	eb b7                	jmp    80200a <dup+0xa3>

00802053 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802053:	55                   	push   %ebp
  802054:	89 e5                	mov    %esp,%ebp
  802056:	53                   	push   %ebx
  802057:	83 ec 14             	sub    $0x14,%esp
  80205a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80205d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802060:	50                   	push   %eax
  802061:	53                   	push   %ebx
  802062:	e8 7b fd ff ff       	call   801de2 <fd_lookup>
  802067:	83 c4 08             	add    $0x8,%esp
  80206a:	85 c0                	test   %eax,%eax
  80206c:	78 3f                	js     8020ad <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80206e:	83 ec 08             	sub    $0x8,%esp
  802071:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802074:	50                   	push   %eax
  802075:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802078:	ff 30                	pushl  (%eax)
  80207a:	e8 b9 fd ff ff       	call   801e38 <dev_lookup>
  80207f:	83 c4 10             	add    $0x10,%esp
  802082:	85 c0                	test   %eax,%eax
  802084:	78 27                	js     8020ad <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802086:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802089:	8b 42 08             	mov    0x8(%edx),%eax
  80208c:	83 e0 03             	and    $0x3,%eax
  80208f:	83 f8 01             	cmp    $0x1,%eax
  802092:	74 1e                	je     8020b2 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  802094:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802097:	8b 40 08             	mov    0x8(%eax),%eax
  80209a:	85 c0                	test   %eax,%eax
  80209c:	74 35                	je     8020d3 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80209e:	83 ec 04             	sub    $0x4,%esp
  8020a1:	ff 75 10             	pushl  0x10(%ebp)
  8020a4:	ff 75 0c             	pushl  0xc(%ebp)
  8020a7:	52                   	push   %edx
  8020a8:	ff d0                	call   *%eax
  8020aa:	83 c4 10             	add    $0x10,%esp
}
  8020ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020b0:	c9                   	leave  
  8020b1:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8020b2:	a1 28 64 80 00       	mov    0x806428,%eax
  8020b7:	8b 40 48             	mov    0x48(%eax),%eax
  8020ba:	83 ec 04             	sub    $0x4,%esp
  8020bd:	53                   	push   %ebx
  8020be:	50                   	push   %eax
  8020bf:	68 e5 3e 80 00       	push   $0x803ee5
  8020c4:	e8 8d ea ff ff       	call   800b56 <cprintf>
		return -E_INVAL;
  8020c9:	83 c4 10             	add    $0x10,%esp
  8020cc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8020d1:	eb da                	jmp    8020ad <read+0x5a>
		return -E_NOT_SUPP;
  8020d3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8020d8:	eb d3                	jmp    8020ad <read+0x5a>

008020da <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8020da:	55                   	push   %ebp
  8020db:	89 e5                	mov    %esp,%ebp
  8020dd:	57                   	push   %edi
  8020de:	56                   	push   %esi
  8020df:	53                   	push   %ebx
  8020e0:	83 ec 0c             	sub    $0xc,%esp
  8020e3:	8b 7d 08             	mov    0x8(%ebp),%edi
  8020e6:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8020e9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8020ee:	39 f3                	cmp    %esi,%ebx
  8020f0:	73 25                	jae    802117 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8020f2:	83 ec 04             	sub    $0x4,%esp
  8020f5:	89 f0                	mov    %esi,%eax
  8020f7:	29 d8                	sub    %ebx,%eax
  8020f9:	50                   	push   %eax
  8020fa:	89 d8                	mov    %ebx,%eax
  8020fc:	03 45 0c             	add    0xc(%ebp),%eax
  8020ff:	50                   	push   %eax
  802100:	57                   	push   %edi
  802101:	e8 4d ff ff ff       	call   802053 <read>
		if (m < 0)
  802106:	83 c4 10             	add    $0x10,%esp
  802109:	85 c0                	test   %eax,%eax
  80210b:	78 08                	js     802115 <readn+0x3b>
			return m;
		if (m == 0)
  80210d:	85 c0                	test   %eax,%eax
  80210f:	74 06                	je     802117 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  802111:	01 c3                	add    %eax,%ebx
  802113:	eb d9                	jmp    8020ee <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802115:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  802117:	89 d8                	mov    %ebx,%eax
  802119:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80211c:	5b                   	pop    %ebx
  80211d:	5e                   	pop    %esi
  80211e:	5f                   	pop    %edi
  80211f:	5d                   	pop    %ebp
  802120:	c3                   	ret    

00802121 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802121:	55                   	push   %ebp
  802122:	89 e5                	mov    %esp,%ebp
  802124:	53                   	push   %ebx
  802125:	83 ec 14             	sub    $0x14,%esp
  802128:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80212b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80212e:	50                   	push   %eax
  80212f:	53                   	push   %ebx
  802130:	e8 ad fc ff ff       	call   801de2 <fd_lookup>
  802135:	83 c4 08             	add    $0x8,%esp
  802138:	85 c0                	test   %eax,%eax
  80213a:	78 3a                	js     802176 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80213c:	83 ec 08             	sub    $0x8,%esp
  80213f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802142:	50                   	push   %eax
  802143:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802146:	ff 30                	pushl  (%eax)
  802148:	e8 eb fc ff ff       	call   801e38 <dev_lookup>
  80214d:	83 c4 10             	add    $0x10,%esp
  802150:	85 c0                	test   %eax,%eax
  802152:	78 22                	js     802176 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802154:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802157:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80215b:	74 1e                	je     80217b <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80215d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802160:	8b 52 0c             	mov    0xc(%edx),%edx
  802163:	85 d2                	test   %edx,%edx
  802165:	74 35                	je     80219c <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  802167:	83 ec 04             	sub    $0x4,%esp
  80216a:	ff 75 10             	pushl  0x10(%ebp)
  80216d:	ff 75 0c             	pushl  0xc(%ebp)
  802170:	50                   	push   %eax
  802171:	ff d2                	call   *%edx
  802173:	83 c4 10             	add    $0x10,%esp
}
  802176:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802179:	c9                   	leave  
  80217a:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80217b:	a1 28 64 80 00       	mov    0x806428,%eax
  802180:	8b 40 48             	mov    0x48(%eax),%eax
  802183:	83 ec 04             	sub    $0x4,%esp
  802186:	53                   	push   %ebx
  802187:	50                   	push   %eax
  802188:	68 01 3f 80 00       	push   $0x803f01
  80218d:	e8 c4 e9 ff ff       	call   800b56 <cprintf>
		return -E_INVAL;
  802192:	83 c4 10             	add    $0x10,%esp
  802195:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80219a:	eb da                	jmp    802176 <write+0x55>
		return -E_NOT_SUPP;
  80219c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8021a1:	eb d3                	jmp    802176 <write+0x55>

008021a3 <seek>:

int
seek(int fdnum, off_t offset)
{
  8021a3:	55                   	push   %ebp
  8021a4:	89 e5                	mov    %esp,%ebp
  8021a6:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8021a9:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8021ac:	50                   	push   %eax
  8021ad:	ff 75 08             	pushl  0x8(%ebp)
  8021b0:	e8 2d fc ff ff       	call   801de2 <fd_lookup>
  8021b5:	83 c4 08             	add    $0x8,%esp
  8021b8:	85 c0                	test   %eax,%eax
  8021ba:	78 0e                	js     8021ca <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8021bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021c2:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8021c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021ca:	c9                   	leave  
  8021cb:	c3                   	ret    

008021cc <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8021cc:	55                   	push   %ebp
  8021cd:	89 e5                	mov    %esp,%ebp
  8021cf:	53                   	push   %ebx
  8021d0:	83 ec 14             	sub    $0x14,%esp
  8021d3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8021d6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8021d9:	50                   	push   %eax
  8021da:	53                   	push   %ebx
  8021db:	e8 02 fc ff ff       	call   801de2 <fd_lookup>
  8021e0:	83 c4 08             	add    $0x8,%esp
  8021e3:	85 c0                	test   %eax,%eax
  8021e5:	78 37                	js     80221e <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8021e7:	83 ec 08             	sub    $0x8,%esp
  8021ea:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021ed:	50                   	push   %eax
  8021ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021f1:	ff 30                	pushl  (%eax)
  8021f3:	e8 40 fc ff ff       	call   801e38 <dev_lookup>
  8021f8:	83 c4 10             	add    $0x10,%esp
  8021fb:	85 c0                	test   %eax,%eax
  8021fd:	78 1f                	js     80221e <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8021ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802202:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  802206:	74 1b                	je     802223 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  802208:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80220b:	8b 52 18             	mov    0x18(%edx),%edx
  80220e:	85 d2                	test   %edx,%edx
  802210:	74 32                	je     802244 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  802212:	83 ec 08             	sub    $0x8,%esp
  802215:	ff 75 0c             	pushl  0xc(%ebp)
  802218:	50                   	push   %eax
  802219:	ff d2                	call   *%edx
  80221b:	83 c4 10             	add    $0x10,%esp
}
  80221e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802221:	c9                   	leave  
  802222:	c3                   	ret    
			thisenv->env_id, fdnum);
  802223:	a1 28 64 80 00       	mov    0x806428,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802228:	8b 40 48             	mov    0x48(%eax),%eax
  80222b:	83 ec 04             	sub    $0x4,%esp
  80222e:	53                   	push   %ebx
  80222f:	50                   	push   %eax
  802230:	68 c4 3e 80 00       	push   $0x803ec4
  802235:	e8 1c e9 ff ff       	call   800b56 <cprintf>
		return -E_INVAL;
  80223a:	83 c4 10             	add    $0x10,%esp
  80223d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802242:	eb da                	jmp    80221e <ftruncate+0x52>
		return -E_NOT_SUPP;
  802244:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802249:	eb d3                	jmp    80221e <ftruncate+0x52>

0080224b <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80224b:	55                   	push   %ebp
  80224c:	89 e5                	mov    %esp,%ebp
  80224e:	53                   	push   %ebx
  80224f:	83 ec 14             	sub    $0x14,%esp
  802252:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802255:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802258:	50                   	push   %eax
  802259:	ff 75 08             	pushl  0x8(%ebp)
  80225c:	e8 81 fb ff ff       	call   801de2 <fd_lookup>
  802261:	83 c4 08             	add    $0x8,%esp
  802264:	85 c0                	test   %eax,%eax
  802266:	78 4b                	js     8022b3 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802268:	83 ec 08             	sub    $0x8,%esp
  80226b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80226e:	50                   	push   %eax
  80226f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802272:	ff 30                	pushl  (%eax)
  802274:	e8 bf fb ff ff       	call   801e38 <dev_lookup>
  802279:	83 c4 10             	add    $0x10,%esp
  80227c:	85 c0                	test   %eax,%eax
  80227e:	78 33                	js     8022b3 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  802280:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802283:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  802287:	74 2f                	je     8022b8 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  802289:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80228c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  802293:	00 00 00 
	stat->st_isdir = 0;
  802296:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80229d:	00 00 00 
	stat->st_dev = dev;
  8022a0:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8022a6:	83 ec 08             	sub    $0x8,%esp
  8022a9:	53                   	push   %ebx
  8022aa:	ff 75 f0             	pushl  -0x10(%ebp)
  8022ad:	ff 50 14             	call   *0x14(%eax)
  8022b0:	83 c4 10             	add    $0x10,%esp
}
  8022b3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022b6:	c9                   	leave  
  8022b7:	c3                   	ret    
		return -E_NOT_SUPP;
  8022b8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8022bd:	eb f4                	jmp    8022b3 <fstat+0x68>

008022bf <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8022bf:	55                   	push   %ebp
  8022c0:	89 e5                	mov    %esp,%ebp
  8022c2:	56                   	push   %esi
  8022c3:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8022c4:	83 ec 08             	sub    $0x8,%esp
  8022c7:	6a 00                	push   $0x0
  8022c9:	ff 75 08             	pushl  0x8(%ebp)
  8022cc:	e8 26 02 00 00       	call   8024f7 <open>
  8022d1:	89 c3                	mov    %eax,%ebx
  8022d3:	83 c4 10             	add    $0x10,%esp
  8022d6:	85 c0                	test   %eax,%eax
  8022d8:	78 1b                	js     8022f5 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8022da:	83 ec 08             	sub    $0x8,%esp
  8022dd:	ff 75 0c             	pushl  0xc(%ebp)
  8022e0:	50                   	push   %eax
  8022e1:	e8 65 ff ff ff       	call   80224b <fstat>
  8022e6:	89 c6                	mov    %eax,%esi
	close(fd);
  8022e8:	89 1c 24             	mov    %ebx,(%esp)
  8022eb:	e8 27 fc ff ff       	call   801f17 <close>
	return r;
  8022f0:	83 c4 10             	add    $0x10,%esp
  8022f3:	89 f3                	mov    %esi,%ebx
}
  8022f5:	89 d8                	mov    %ebx,%eax
  8022f7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022fa:	5b                   	pop    %ebx
  8022fb:	5e                   	pop    %esi
  8022fc:	5d                   	pop    %ebp
  8022fd:	c3                   	ret    

008022fe <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8022fe:	55                   	push   %ebp
  8022ff:	89 e5                	mov    %esp,%ebp
  802301:	56                   	push   %esi
  802302:	53                   	push   %ebx
  802303:	89 c6                	mov    %eax,%esi
  802305:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  802307:	83 3d 20 64 80 00 00 	cmpl   $0x0,0x806420
  80230e:	74 27                	je     802337 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802310:	6a 07                	push   $0x7
  802312:	68 00 70 80 00       	push   $0x807000
  802317:	56                   	push   %esi
  802318:	ff 35 20 64 80 00    	pushl  0x806420
  80231e:	e8 8c 12 00 00       	call   8035af <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  802323:	83 c4 0c             	add    $0xc,%esp
  802326:	6a 00                	push   $0x0
  802328:	53                   	push   %ebx
  802329:	6a 00                	push   $0x0
  80232b:	e8 16 12 00 00       	call   803546 <ipc_recv>
}
  802330:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802333:	5b                   	pop    %ebx
  802334:	5e                   	pop    %esi
  802335:	5d                   	pop    %ebp
  802336:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802337:	83 ec 0c             	sub    $0xc,%esp
  80233a:	6a 01                	push   $0x1
  80233c:	e8 c7 12 00 00       	call   803608 <ipc_find_env>
  802341:	a3 20 64 80 00       	mov    %eax,0x806420
  802346:	83 c4 10             	add    $0x10,%esp
  802349:	eb c5                	jmp    802310 <fsipc+0x12>

0080234b <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80234b:	55                   	push   %ebp
  80234c:	89 e5                	mov    %esp,%ebp
  80234e:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802351:	8b 45 08             	mov    0x8(%ebp),%eax
  802354:	8b 40 0c             	mov    0xc(%eax),%eax
  802357:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.set_size.req_size = newsize;
  80235c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80235f:	a3 04 70 80 00       	mov    %eax,0x807004
	return fsipc(FSREQ_SET_SIZE, NULL);
  802364:	ba 00 00 00 00       	mov    $0x0,%edx
  802369:	b8 02 00 00 00       	mov    $0x2,%eax
  80236e:	e8 8b ff ff ff       	call   8022fe <fsipc>
}
  802373:	c9                   	leave  
  802374:	c3                   	ret    

00802375 <devfile_flush>:
{
  802375:	55                   	push   %ebp
  802376:	89 e5                	mov    %esp,%ebp
  802378:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80237b:	8b 45 08             	mov    0x8(%ebp),%eax
  80237e:	8b 40 0c             	mov    0xc(%eax),%eax
  802381:	a3 00 70 80 00       	mov    %eax,0x807000
	return fsipc(FSREQ_FLUSH, NULL);
  802386:	ba 00 00 00 00       	mov    $0x0,%edx
  80238b:	b8 06 00 00 00       	mov    $0x6,%eax
  802390:	e8 69 ff ff ff       	call   8022fe <fsipc>
}
  802395:	c9                   	leave  
  802396:	c3                   	ret    

00802397 <devfile_stat>:
{
  802397:	55                   	push   %ebp
  802398:	89 e5                	mov    %esp,%ebp
  80239a:	53                   	push   %ebx
  80239b:	83 ec 04             	sub    $0x4,%esp
  80239e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8023a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a4:	8b 40 0c             	mov    0xc(%eax),%eax
  8023a7:	a3 00 70 80 00       	mov    %eax,0x807000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8023ac:	ba 00 00 00 00       	mov    $0x0,%edx
  8023b1:	b8 05 00 00 00       	mov    $0x5,%eax
  8023b6:	e8 43 ff ff ff       	call   8022fe <fsipc>
  8023bb:	85 c0                	test   %eax,%eax
  8023bd:	78 2c                	js     8023eb <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8023bf:	83 ec 08             	sub    $0x8,%esp
  8023c2:	68 00 70 80 00       	push   $0x807000
  8023c7:	53                   	push   %ebx
  8023c8:	e8 16 ef ff ff       	call   8012e3 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8023cd:	a1 80 70 80 00       	mov    0x807080,%eax
  8023d2:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8023d8:	a1 84 70 80 00       	mov    0x807084,%eax
  8023dd:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8023e3:	83 c4 10             	add    $0x10,%esp
  8023e6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023eb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023ee:	c9                   	leave  
  8023ef:	c3                   	ret    

008023f0 <devfile_write>:
{
  8023f0:	55                   	push   %ebp
  8023f1:	89 e5                	mov    %esp,%ebp
  8023f3:	53                   	push   %ebx
  8023f4:	83 ec 04             	sub    $0x4,%esp
  8023f7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8023fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fd:	8b 40 0c             	mov    0xc(%eax),%eax
  802400:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.write.req_n = n;
  802405:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  80240b:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  802411:	77 30                	ja     802443 <devfile_write+0x53>
	memmove(fsipcbuf.write.req_buf, buf, n);
  802413:	83 ec 04             	sub    $0x4,%esp
  802416:	53                   	push   %ebx
  802417:	ff 75 0c             	pushl  0xc(%ebp)
  80241a:	68 08 70 80 00       	push   $0x807008
  80241f:	e8 4d f0 ff ff       	call   801471 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  802424:	ba 00 00 00 00       	mov    $0x0,%edx
  802429:	b8 04 00 00 00       	mov    $0x4,%eax
  80242e:	e8 cb fe ff ff       	call   8022fe <fsipc>
  802433:	83 c4 10             	add    $0x10,%esp
  802436:	85 c0                	test   %eax,%eax
  802438:	78 04                	js     80243e <devfile_write+0x4e>
	assert(r <= n);
  80243a:	39 d8                	cmp    %ebx,%eax
  80243c:	77 1e                	ja     80245c <devfile_write+0x6c>
}
  80243e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802441:	c9                   	leave  
  802442:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  802443:	68 34 3f 80 00       	push   $0x803f34
  802448:	68 06 3a 80 00       	push   $0x803a06
  80244d:	68 94 00 00 00       	push   $0x94
  802452:	68 61 3f 80 00       	push   $0x803f61
  802457:	e8 1f e6 ff ff       	call   800a7b <_panic>
	assert(r <= n);
  80245c:	68 6c 3f 80 00       	push   $0x803f6c
  802461:	68 06 3a 80 00       	push   $0x803a06
  802466:	68 98 00 00 00       	push   $0x98
  80246b:	68 61 3f 80 00       	push   $0x803f61
  802470:	e8 06 e6 ff ff       	call   800a7b <_panic>

00802475 <devfile_read>:
{
  802475:	55                   	push   %ebp
  802476:	89 e5                	mov    %esp,%ebp
  802478:	56                   	push   %esi
  802479:	53                   	push   %ebx
  80247a:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80247d:	8b 45 08             	mov    0x8(%ebp),%eax
  802480:	8b 40 0c             	mov    0xc(%eax),%eax
  802483:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.read.req_n = n;
  802488:	89 35 04 70 80 00    	mov    %esi,0x807004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80248e:	ba 00 00 00 00       	mov    $0x0,%edx
  802493:	b8 03 00 00 00       	mov    $0x3,%eax
  802498:	e8 61 fe ff ff       	call   8022fe <fsipc>
  80249d:	89 c3                	mov    %eax,%ebx
  80249f:	85 c0                	test   %eax,%eax
  8024a1:	78 1f                	js     8024c2 <devfile_read+0x4d>
	assert(r <= n);
  8024a3:	39 f0                	cmp    %esi,%eax
  8024a5:	77 24                	ja     8024cb <devfile_read+0x56>
	assert(r <= PGSIZE);
  8024a7:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8024ac:	7f 33                	jg     8024e1 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8024ae:	83 ec 04             	sub    $0x4,%esp
  8024b1:	50                   	push   %eax
  8024b2:	68 00 70 80 00       	push   $0x807000
  8024b7:	ff 75 0c             	pushl  0xc(%ebp)
  8024ba:	e8 b2 ef ff ff       	call   801471 <memmove>
	return r;
  8024bf:	83 c4 10             	add    $0x10,%esp
}
  8024c2:	89 d8                	mov    %ebx,%eax
  8024c4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8024c7:	5b                   	pop    %ebx
  8024c8:	5e                   	pop    %esi
  8024c9:	5d                   	pop    %ebp
  8024ca:	c3                   	ret    
	assert(r <= n);
  8024cb:	68 6c 3f 80 00       	push   $0x803f6c
  8024d0:	68 06 3a 80 00       	push   $0x803a06
  8024d5:	6a 7c                	push   $0x7c
  8024d7:	68 61 3f 80 00       	push   $0x803f61
  8024dc:	e8 9a e5 ff ff       	call   800a7b <_panic>
	assert(r <= PGSIZE);
  8024e1:	68 73 3f 80 00       	push   $0x803f73
  8024e6:	68 06 3a 80 00       	push   $0x803a06
  8024eb:	6a 7d                	push   $0x7d
  8024ed:	68 61 3f 80 00       	push   $0x803f61
  8024f2:	e8 84 e5 ff ff       	call   800a7b <_panic>

008024f7 <open>:
{
  8024f7:	55                   	push   %ebp
  8024f8:	89 e5                	mov    %esp,%ebp
  8024fa:	56                   	push   %esi
  8024fb:	53                   	push   %ebx
  8024fc:	83 ec 1c             	sub    $0x1c,%esp
  8024ff:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  802502:	56                   	push   %esi
  802503:	e8 a4 ed ff ff       	call   8012ac <strlen>
  802508:	83 c4 10             	add    $0x10,%esp
  80250b:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802510:	7f 6c                	jg     80257e <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  802512:	83 ec 0c             	sub    $0xc,%esp
  802515:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802518:	50                   	push   %eax
  802519:	e8 75 f8 ff ff       	call   801d93 <fd_alloc>
  80251e:	89 c3                	mov    %eax,%ebx
  802520:	83 c4 10             	add    $0x10,%esp
  802523:	85 c0                	test   %eax,%eax
  802525:	78 3c                	js     802563 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  802527:	83 ec 08             	sub    $0x8,%esp
  80252a:	56                   	push   %esi
  80252b:	68 00 70 80 00       	push   $0x807000
  802530:	e8 ae ed ff ff       	call   8012e3 <strcpy>
	fsipcbuf.open.req_omode = mode;
  802535:	8b 45 0c             	mov    0xc(%ebp),%eax
  802538:	a3 00 74 80 00       	mov    %eax,0x807400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80253d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802540:	b8 01 00 00 00       	mov    $0x1,%eax
  802545:	e8 b4 fd ff ff       	call   8022fe <fsipc>
  80254a:	89 c3                	mov    %eax,%ebx
  80254c:	83 c4 10             	add    $0x10,%esp
  80254f:	85 c0                	test   %eax,%eax
  802551:	78 19                	js     80256c <open+0x75>
	return fd2num(fd);
  802553:	83 ec 0c             	sub    $0xc,%esp
  802556:	ff 75 f4             	pushl  -0xc(%ebp)
  802559:	e8 0e f8 ff ff       	call   801d6c <fd2num>
  80255e:	89 c3                	mov    %eax,%ebx
  802560:	83 c4 10             	add    $0x10,%esp
}
  802563:	89 d8                	mov    %ebx,%eax
  802565:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802568:	5b                   	pop    %ebx
  802569:	5e                   	pop    %esi
  80256a:	5d                   	pop    %ebp
  80256b:	c3                   	ret    
		fd_close(fd, 0);
  80256c:	83 ec 08             	sub    $0x8,%esp
  80256f:	6a 00                	push   $0x0
  802571:	ff 75 f4             	pushl  -0xc(%ebp)
  802574:	e8 15 f9 ff ff       	call   801e8e <fd_close>
		return r;
  802579:	83 c4 10             	add    $0x10,%esp
  80257c:	eb e5                	jmp    802563 <open+0x6c>
		return -E_BAD_PATH;
  80257e:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  802583:	eb de                	jmp    802563 <open+0x6c>

00802585 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  802585:	55                   	push   %ebp
  802586:	89 e5                	mov    %esp,%ebp
  802588:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80258b:	ba 00 00 00 00       	mov    $0x0,%edx
  802590:	b8 08 00 00 00       	mov    $0x8,%eax
  802595:	e8 64 fd ff ff       	call   8022fe <fsipc>
}
  80259a:	c9                   	leave  
  80259b:	c3                   	ret    

0080259c <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  80259c:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  8025a0:	7e 38                	jle    8025da <writebuf+0x3e>
{
  8025a2:	55                   	push   %ebp
  8025a3:	89 e5                	mov    %esp,%ebp
  8025a5:	53                   	push   %ebx
  8025a6:	83 ec 08             	sub    $0x8,%esp
  8025a9:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  8025ab:	ff 70 04             	pushl  0x4(%eax)
  8025ae:	8d 40 10             	lea    0x10(%eax),%eax
  8025b1:	50                   	push   %eax
  8025b2:	ff 33                	pushl  (%ebx)
  8025b4:	e8 68 fb ff ff       	call   802121 <write>
		if (result > 0)
  8025b9:	83 c4 10             	add    $0x10,%esp
  8025bc:	85 c0                	test   %eax,%eax
  8025be:	7e 03                	jle    8025c3 <writebuf+0x27>
			b->result += result;
  8025c0:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  8025c3:	39 43 04             	cmp    %eax,0x4(%ebx)
  8025c6:	74 0d                	je     8025d5 <writebuf+0x39>
			b->error = (result < 0 ? result : 0);
  8025c8:	85 c0                	test   %eax,%eax
  8025ca:	ba 00 00 00 00       	mov    $0x0,%edx
  8025cf:	0f 4f c2             	cmovg  %edx,%eax
  8025d2:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  8025d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8025d8:	c9                   	leave  
  8025d9:	c3                   	ret    
  8025da:	f3 c3                	repz ret 

008025dc <putch>:

static void
putch(int ch, void *thunk)
{
  8025dc:	55                   	push   %ebp
  8025dd:	89 e5                	mov    %esp,%ebp
  8025df:	53                   	push   %ebx
  8025e0:	83 ec 04             	sub    $0x4,%esp
  8025e3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  8025e6:	8b 53 04             	mov    0x4(%ebx),%edx
  8025e9:	8d 42 01             	lea    0x1(%edx),%eax
  8025ec:	89 43 04             	mov    %eax,0x4(%ebx)
  8025ef:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8025f2:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  8025f6:	3d 00 01 00 00       	cmp    $0x100,%eax
  8025fb:	74 06                	je     802603 <putch+0x27>
		writebuf(b);
		b->idx = 0;
	}
}
  8025fd:	83 c4 04             	add    $0x4,%esp
  802600:	5b                   	pop    %ebx
  802601:	5d                   	pop    %ebp
  802602:	c3                   	ret    
		writebuf(b);
  802603:	89 d8                	mov    %ebx,%eax
  802605:	e8 92 ff ff ff       	call   80259c <writebuf>
		b->idx = 0;
  80260a:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  802611:	eb ea                	jmp    8025fd <putch+0x21>

00802613 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  802613:	55                   	push   %ebp
  802614:	89 e5                	mov    %esp,%ebp
  802616:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  80261c:	8b 45 08             	mov    0x8(%ebp),%eax
  80261f:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  802625:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  80262c:	00 00 00 
	b.result = 0;
  80262f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  802636:	00 00 00 
	b.error = 1;
  802639:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  802640:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  802643:	ff 75 10             	pushl  0x10(%ebp)
  802646:	ff 75 0c             	pushl  0xc(%ebp)
  802649:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80264f:	50                   	push   %eax
  802650:	68 dc 25 80 00       	push   $0x8025dc
  802655:	e8 f9 e5 ff ff       	call   800c53 <vprintfmt>
	if (b.idx > 0)
  80265a:	83 c4 10             	add    $0x10,%esp
  80265d:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  802664:	7f 11                	jg     802677 <vfprintf+0x64>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  802666:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80266c:	85 c0                	test   %eax,%eax
  80266e:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  802675:	c9                   	leave  
  802676:	c3                   	ret    
		writebuf(&b);
  802677:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80267d:	e8 1a ff ff ff       	call   80259c <writebuf>
  802682:	eb e2                	jmp    802666 <vfprintf+0x53>

00802684 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  802684:	55                   	push   %ebp
  802685:	89 e5                	mov    %esp,%ebp
  802687:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80268a:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  80268d:	50                   	push   %eax
  80268e:	ff 75 0c             	pushl  0xc(%ebp)
  802691:	ff 75 08             	pushl  0x8(%ebp)
  802694:	e8 7a ff ff ff       	call   802613 <vfprintf>
	va_end(ap);

	return cnt;
}
  802699:	c9                   	leave  
  80269a:	c3                   	ret    

0080269b <printf>:

int
printf(const char *fmt, ...)
{
  80269b:	55                   	push   %ebp
  80269c:	89 e5                	mov    %esp,%ebp
  80269e:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8026a1:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  8026a4:	50                   	push   %eax
  8026a5:	ff 75 08             	pushl  0x8(%ebp)
  8026a8:	6a 01                	push   $0x1
  8026aa:	e8 64 ff ff ff       	call   802613 <vfprintf>
	va_end(ap);

	return cnt;
}
  8026af:	c9                   	leave  
  8026b0:	c3                   	ret    

008026b1 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  8026b1:	55                   	push   %ebp
  8026b2:	89 e5                	mov    %esp,%ebp
  8026b4:	57                   	push   %edi
  8026b5:	56                   	push   %esi
  8026b6:	53                   	push   %ebx
  8026b7:	81 ec 94 02 00 00    	sub    $0x294,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  8026bd:	6a 00                	push   $0x0
  8026bf:	ff 75 08             	pushl  0x8(%ebp)
  8026c2:	e8 30 fe ff ff       	call   8024f7 <open>
  8026c7:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  8026cd:	83 c4 10             	add    $0x10,%esp
  8026d0:	85 c0                	test   %eax,%eax
  8026d2:	0f 88 40 03 00 00    	js     802a18 <spawn+0x367>
  8026d8:	89 c2                	mov    %eax,%edx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  8026da:	83 ec 04             	sub    $0x4,%esp
  8026dd:	68 00 02 00 00       	push   $0x200
  8026e2:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  8026e8:	50                   	push   %eax
  8026e9:	52                   	push   %edx
  8026ea:	e8 eb f9 ff ff       	call   8020da <readn>
  8026ef:	83 c4 10             	add    $0x10,%esp
  8026f2:	3d 00 02 00 00       	cmp    $0x200,%eax
  8026f7:	75 5d                	jne    802756 <spawn+0xa5>
	    || elf->e_magic != ELF_MAGIC) {
  8026f9:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  802700:	45 4c 46 
  802703:	75 51                	jne    802756 <spawn+0xa5>
  802705:	b8 07 00 00 00       	mov    $0x7,%eax
  80270a:	cd 30                	int    $0x30
  80270c:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  802712:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  802718:	85 c0                	test   %eax,%eax
  80271a:	0f 88 b6 04 00 00    	js     802bd6 <spawn+0x525>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  802720:	25 ff 03 00 00       	and    $0x3ff,%eax
  802725:	6b f0 7c             	imul   $0x7c,%eax,%esi
  802728:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  80272e:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  802734:	b9 11 00 00 00       	mov    $0x11,%ecx
  802739:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  80273b:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  802741:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  802747:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  80274c:	be 00 00 00 00       	mov    $0x0,%esi
  802751:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802754:	eb 4b                	jmp    8027a1 <spawn+0xf0>
		close(fd);
  802756:	83 ec 0c             	sub    $0xc,%esp
  802759:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  80275f:	e8 b3 f7 ff ff       	call   801f17 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  802764:	83 c4 0c             	add    $0xc,%esp
  802767:	68 7f 45 4c 46       	push   $0x464c457f
  80276c:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  802772:	68 7f 3f 80 00       	push   $0x803f7f
  802777:	e8 da e3 ff ff       	call   800b56 <cprintf>
		return -E_NOT_EXEC;
  80277c:	83 c4 10             	add    $0x10,%esp
  80277f:	c7 85 90 fd ff ff f2 	movl   $0xfffffff2,-0x270(%ebp)
  802786:	ff ff ff 
  802789:	e9 8a 02 00 00       	jmp    802a18 <spawn+0x367>
		string_size += strlen(argv[argc]) + 1;
  80278e:	83 ec 0c             	sub    $0xc,%esp
  802791:	50                   	push   %eax
  802792:	e8 15 eb ff ff       	call   8012ac <strlen>
  802797:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  80279b:	83 c3 01             	add    $0x1,%ebx
  80279e:	83 c4 10             	add    $0x10,%esp
  8027a1:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  8027a8:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  8027ab:	85 c0                	test   %eax,%eax
  8027ad:	75 df                	jne    80278e <spawn+0xdd>
  8027af:	89 9d 88 fd ff ff    	mov    %ebx,-0x278(%ebp)
  8027b5:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  8027bb:	bf 00 10 40 00       	mov    $0x401000,%edi
  8027c0:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  8027c2:	89 fa                	mov    %edi,%edx
  8027c4:	83 e2 fc             	and    $0xfffffffc,%edx
  8027c7:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  8027ce:	29 c2                	sub    %eax,%edx
  8027d0:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  8027d6:	8d 42 f8             	lea    -0x8(%edx),%eax
  8027d9:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  8027de:	0f 86 03 04 00 00    	jbe    802be7 <spawn+0x536>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8027e4:	83 ec 04             	sub    $0x4,%esp
  8027e7:	6a 07                	push   $0x7
  8027e9:	68 00 00 40 00       	push   $0x400000
  8027ee:	6a 00                	push   $0x0
  8027f0:	e8 e7 ee ff ff       	call   8016dc <sys_page_alloc>
  8027f5:	83 c4 10             	add    $0x10,%esp
  8027f8:	85 c0                	test   %eax,%eax
  8027fa:	0f 88 ec 03 00 00    	js     802bec <spawn+0x53b>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  802800:	be 00 00 00 00       	mov    $0x0,%esi
  802805:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  80280b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80280e:	eb 30                	jmp    802840 <spawn+0x18f>
		argv_store[i] = UTEMP2USTACK(string_store);
  802810:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  802816:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  80281c:	89 04 b2             	mov    %eax,(%edx,%esi,4)
		strcpy(string_store, argv[i]);
  80281f:	83 ec 08             	sub    $0x8,%esp
  802822:	ff 34 b3             	pushl  (%ebx,%esi,4)
  802825:	57                   	push   %edi
  802826:	e8 b8 ea ff ff       	call   8012e3 <strcpy>
		string_store += strlen(argv[i]) + 1;
  80282b:	83 c4 04             	add    $0x4,%esp
  80282e:	ff 34 b3             	pushl  (%ebx,%esi,4)
  802831:	e8 76 ea ff ff       	call   8012ac <strlen>
  802836:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  80283a:	83 c6 01             	add    $0x1,%esi
  80283d:	83 c4 10             	add    $0x10,%esp
  802840:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  802846:	7f c8                	jg     802810 <spawn+0x15f>
	}
	argv_store[argc] = 0;
  802848:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  80284e:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  802854:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  80285b:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  802861:	0f 85 8c 00 00 00    	jne    8028f3 <spawn+0x242>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  802867:	8b bd 94 fd ff ff    	mov    -0x26c(%ebp),%edi
  80286d:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  802873:	89 47 fc             	mov    %eax,-0x4(%edi)
	argv_store[-2] = argc;
  802876:	89 f8                	mov    %edi,%eax
  802878:	8b bd 88 fd ff ff    	mov    -0x278(%ebp),%edi
  80287e:	89 78 f8             	mov    %edi,-0x8(%eax)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  802881:	2d 08 30 80 11       	sub    $0x11803008,%eax
  802886:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  80288c:	83 ec 0c             	sub    $0xc,%esp
  80288f:	6a 07                	push   $0x7
  802891:	68 00 d0 bf ee       	push   $0xeebfd000
  802896:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  80289c:	68 00 00 40 00       	push   $0x400000
  8028a1:	6a 00                	push   $0x0
  8028a3:	e8 77 ee ff ff       	call   80171f <sys_page_map>
  8028a8:	89 c3                	mov    %eax,%ebx
  8028aa:	83 c4 20             	add    $0x20,%esp
  8028ad:	85 c0                	test   %eax,%eax
  8028af:	0f 88 57 03 00 00    	js     802c0c <spawn+0x55b>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  8028b5:	83 ec 08             	sub    $0x8,%esp
  8028b8:	68 00 00 40 00       	push   $0x400000
  8028bd:	6a 00                	push   $0x0
  8028bf:	e8 9d ee ff ff       	call   801761 <sys_page_unmap>
  8028c4:	89 c3                	mov    %eax,%ebx
  8028c6:	83 c4 10             	add    $0x10,%esp
  8028c9:	85 c0                	test   %eax,%eax
  8028cb:	0f 88 3b 03 00 00    	js     802c0c <spawn+0x55b>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  8028d1:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  8028d7:	8d 84 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%eax
  8028de:	89 85 78 fd ff ff    	mov    %eax,-0x288(%ebp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8028e4:	c7 85 7c fd ff ff 00 	movl   $0x0,-0x284(%ebp)
  8028eb:	00 00 00 
  8028ee:	e9 56 01 00 00       	jmp    802a49 <spawn+0x398>
	assert(string_store == (char*)UTEMP + PGSIZE);
  8028f3:	68 0c 40 80 00       	push   $0x80400c
  8028f8:	68 06 3a 80 00       	push   $0x803a06
  8028fd:	68 f2 00 00 00       	push   $0xf2
  802902:	68 99 3f 80 00       	push   $0x803f99
  802907:	e8 6f e1 ff ff       	call   800a7b <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  80290c:	83 ec 04             	sub    $0x4,%esp
  80290f:	6a 07                	push   $0x7
  802911:	68 00 00 40 00       	push   $0x400000
  802916:	6a 00                	push   $0x0
  802918:	e8 bf ed ff ff       	call   8016dc <sys_page_alloc>
  80291d:	83 c4 10             	add    $0x10,%esp
  802920:	85 c0                	test   %eax,%eax
  802922:	0f 88 cf 02 00 00    	js     802bf7 <spawn+0x546>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  802928:	83 ec 08             	sub    $0x8,%esp
  80292b:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  802931:	01 f0                	add    %esi,%eax
  802933:	50                   	push   %eax
  802934:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  80293a:	e8 64 f8 ff ff       	call   8021a3 <seek>
  80293f:	83 c4 10             	add    $0x10,%esp
  802942:	85 c0                	test   %eax,%eax
  802944:	0f 88 b4 02 00 00    	js     802bfe <spawn+0x54d>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  80294a:	83 ec 04             	sub    $0x4,%esp
  80294d:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  802953:	29 f0                	sub    %esi,%eax
  802955:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80295a:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80295f:	0f 47 c1             	cmova  %ecx,%eax
  802962:	50                   	push   %eax
  802963:	68 00 00 40 00       	push   $0x400000
  802968:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  80296e:	e8 67 f7 ff ff       	call   8020da <readn>
  802973:	83 c4 10             	add    $0x10,%esp
  802976:	85 c0                	test   %eax,%eax
  802978:	0f 88 87 02 00 00    	js     802c05 <spawn+0x554>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  80297e:	83 ec 0c             	sub    $0xc,%esp
  802981:	57                   	push   %edi
  802982:	03 b5 88 fd ff ff    	add    -0x278(%ebp),%esi
  802988:	56                   	push   %esi
  802989:	ff b5 84 fd ff ff    	pushl  -0x27c(%ebp)
  80298f:	68 00 00 40 00       	push   $0x400000
  802994:	6a 00                	push   $0x0
  802996:	e8 84 ed ff ff       	call   80171f <sys_page_map>
  80299b:	83 c4 20             	add    $0x20,%esp
  80299e:	85 c0                	test   %eax,%eax
  8029a0:	0f 88 80 00 00 00    	js     802a26 <spawn+0x375>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  8029a6:	83 ec 08             	sub    $0x8,%esp
  8029a9:	68 00 00 40 00       	push   $0x400000
  8029ae:	6a 00                	push   $0x0
  8029b0:	e8 ac ed ff ff       	call   801761 <sys_page_unmap>
  8029b5:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  8029b8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8029be:	89 de                	mov    %ebx,%esi
  8029c0:	39 9d 8c fd ff ff    	cmp    %ebx,-0x274(%ebp)
  8029c6:	76 73                	jbe    802a3b <spawn+0x38a>
		if (i >= filesz) {
  8029c8:	39 9d 94 fd ff ff    	cmp    %ebx,-0x26c(%ebp)
  8029ce:	0f 87 38 ff ff ff    	ja     80290c <spawn+0x25b>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  8029d4:	83 ec 04             	sub    $0x4,%esp
  8029d7:	57                   	push   %edi
  8029d8:	03 b5 88 fd ff ff    	add    -0x278(%ebp),%esi
  8029de:	56                   	push   %esi
  8029df:	ff b5 84 fd ff ff    	pushl  -0x27c(%ebp)
  8029e5:	e8 f2 ec ff ff       	call   8016dc <sys_page_alloc>
  8029ea:	83 c4 10             	add    $0x10,%esp
  8029ed:	85 c0                	test   %eax,%eax
  8029ef:	79 c7                	jns    8029b8 <spawn+0x307>
  8029f1:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  8029f3:	83 ec 0c             	sub    $0xc,%esp
  8029f6:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  8029fc:	e8 5c ec ff ff       	call   80165d <sys_env_destroy>
	close(fd);
  802a01:	83 c4 04             	add    $0x4,%esp
  802a04:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  802a0a:	e8 08 f5 ff ff       	call   801f17 <close>
	return r;
  802a0f:	83 c4 10             	add    $0x10,%esp
  802a12:	89 bd 90 fd ff ff    	mov    %edi,-0x270(%ebp)
}
  802a18:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  802a1e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802a21:	5b                   	pop    %ebx
  802a22:	5e                   	pop    %esi
  802a23:	5f                   	pop    %edi
  802a24:	5d                   	pop    %ebp
  802a25:	c3                   	ret    
				panic("spawn: sys_page_map data: %e", r);
  802a26:	50                   	push   %eax
  802a27:	68 a5 3f 80 00       	push   $0x803fa5
  802a2c:	68 25 01 00 00       	push   $0x125
  802a31:	68 99 3f 80 00       	push   $0x803f99
  802a36:	e8 40 e0 ff ff       	call   800a7b <_panic>
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802a3b:	83 85 7c fd ff ff 01 	addl   $0x1,-0x284(%ebp)
  802a42:	83 85 78 fd ff ff 20 	addl   $0x20,-0x288(%ebp)
  802a49:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  802a50:	3b 85 7c fd ff ff    	cmp    -0x284(%ebp),%eax
  802a56:	7e 71                	jle    802ac9 <spawn+0x418>
		if (ph->p_type != ELF_PROG_LOAD)
  802a58:	8b 8d 78 fd ff ff    	mov    -0x288(%ebp),%ecx
  802a5e:	83 39 01             	cmpl   $0x1,(%ecx)
  802a61:	75 d8                	jne    802a3b <spawn+0x38a>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  802a63:	8b 41 18             	mov    0x18(%ecx),%eax
  802a66:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  802a69:	83 f8 01             	cmp    $0x1,%eax
  802a6c:	19 ff                	sbb    %edi,%edi
  802a6e:	83 e7 fe             	and    $0xfffffffe,%edi
  802a71:	83 c7 07             	add    $0x7,%edi
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  802a74:	8b 71 04             	mov    0x4(%ecx),%esi
  802a77:	89 b5 80 fd ff ff    	mov    %esi,-0x280(%ebp)
  802a7d:	8b 59 10             	mov    0x10(%ecx),%ebx
  802a80:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  802a86:	8b 41 14             	mov    0x14(%ecx),%eax
  802a89:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
  802a8f:	8b 51 08             	mov    0x8(%ecx),%edx
  802a92:	89 95 88 fd ff ff    	mov    %edx,-0x278(%ebp)
	if ((i = PGOFF(va))) {
  802a98:	89 d0                	mov    %edx,%eax
  802a9a:	25 ff 0f 00 00       	and    $0xfff,%eax
  802a9f:	74 1e                	je     802abf <spawn+0x40e>
		va -= i;
  802aa1:	29 c2                	sub    %eax,%edx
  802aa3:	89 95 88 fd ff ff    	mov    %edx,-0x278(%ebp)
		memsz += i;
  802aa9:	01 85 8c fd ff ff    	add    %eax,-0x274(%ebp)
		filesz += i;
  802aaf:	01 c3                	add    %eax,%ebx
  802ab1:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
		fileoffset -= i;
  802ab7:	29 c6                	sub    %eax,%esi
  802ab9:	89 b5 80 fd ff ff    	mov    %esi,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  802abf:	bb 00 00 00 00       	mov    $0x0,%ebx
  802ac4:	e9 f5 fe ff ff       	jmp    8029be <spawn+0x30d>
	close(fd);
  802ac9:	83 ec 0c             	sub    $0xc,%esp
  802acc:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  802ad2:	e8 40 f4 ff ff       	call   801f17 <close>
// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	envid_t parent_envid = sys_getenvid();
  802ad7:	e8 c2 eb ff ff       	call   80169e <sys_getenvid>
  802adc:	89 c6                	mov    %eax,%esi
  802ade:	83 c4 10             	add    $0x10,%esp
	uint32_t addr;
	int r;

	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  802ae1:	bb 00 00 00 00       	mov    $0x0,%ebx
  802ae6:	8b bd 84 fd ff ff    	mov    -0x27c(%ebp),%edi
  802aec:	eb 0e                	jmp    802afc <spawn+0x44b>
  802aee:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802af4:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  802afa:	74 62                	je     802b5e <spawn+0x4ad>
	    if ((uvpd[PDX(addr)] & PTE_P) == PTE_P && (uvpt[PGNUM(addr)] & PTE_P) == PTE_P && (uvpt[PGNUM(addr)] & PTE_SHARE) == PTE_SHARE) {
  802afc:	89 d8                	mov    %ebx,%eax
  802afe:	c1 e8 16             	shr    $0x16,%eax
  802b01:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  802b08:	a8 01                	test   $0x1,%al
  802b0a:	74 e2                	je     802aee <spawn+0x43d>
  802b0c:	89 d8                	mov    %ebx,%eax
  802b0e:	c1 e8 0c             	shr    $0xc,%eax
  802b11:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  802b18:	f6 c2 01             	test   $0x1,%dl
  802b1b:	74 d1                	je     802aee <spawn+0x43d>
  802b1d:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  802b24:	f6 c6 04             	test   $0x4,%dh
  802b27:	74 c5                	je     802aee <spawn+0x43d>
	        if ((r = sys_page_map(parent_envid, (void *)addr, child, (void *)addr, uvpt[PGNUM(addr)] & PTE_SYSCALL)) != 0) {
  802b29:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  802b30:	83 ec 0c             	sub    $0xc,%esp
  802b33:	25 07 0e 00 00       	and    $0xe07,%eax
  802b38:	50                   	push   %eax
  802b39:	53                   	push   %ebx
  802b3a:	57                   	push   %edi
  802b3b:	53                   	push   %ebx
  802b3c:	56                   	push   %esi
  802b3d:	e8 dd eb ff ff       	call   80171f <sys_page_map>
  802b42:	83 c4 20             	add    $0x20,%esp
  802b45:	85 c0                	test   %eax,%eax
  802b47:	74 a5                	je     802aee <spawn+0x43d>
	            panic("copy_shared_pages: %e", r);
  802b49:	50                   	push   %eax
  802b4a:	68 c2 3f 80 00       	push   $0x803fc2
  802b4f:	68 38 01 00 00       	push   $0x138
  802b54:	68 99 3f 80 00       	push   $0x803f99
  802b59:	e8 1d df ff ff       	call   800a7b <_panic>
	child_tf.tf_eflags |= FL_IOPL_3;   // devious: see user/faultio.c
  802b5e:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  802b65:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  802b68:	83 ec 08             	sub    $0x8,%esp
  802b6b:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  802b71:	50                   	push   %eax
  802b72:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802b78:	e8 68 ec ff ff       	call   8017e5 <sys_env_set_trapframe>
  802b7d:	83 c4 10             	add    $0x10,%esp
  802b80:	85 c0                	test   %eax,%eax
  802b82:	78 28                	js     802bac <spawn+0x4fb>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  802b84:	83 ec 08             	sub    $0x8,%esp
  802b87:	6a 02                	push   $0x2
  802b89:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802b8f:	e8 0f ec ff ff       	call   8017a3 <sys_env_set_status>
  802b94:	83 c4 10             	add    $0x10,%esp
  802b97:	85 c0                	test   %eax,%eax
  802b99:	78 26                	js     802bc1 <spawn+0x510>
	return child;
  802b9b:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802ba1:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  802ba7:	e9 6c fe ff ff       	jmp    802a18 <spawn+0x367>
		panic("sys_env_set_trapframe: %e", r);
  802bac:	50                   	push   %eax
  802bad:	68 d8 3f 80 00       	push   $0x803fd8
  802bb2:	68 86 00 00 00       	push   $0x86
  802bb7:	68 99 3f 80 00       	push   $0x803f99
  802bbc:	e8 ba de ff ff       	call   800a7b <_panic>
		panic("sys_env_set_status: %e", r);
  802bc1:	50                   	push   %eax
  802bc2:	68 f2 3f 80 00       	push   $0x803ff2
  802bc7:	68 89 00 00 00       	push   $0x89
  802bcc:	68 99 3f 80 00       	push   $0x803f99
  802bd1:	e8 a5 de ff ff       	call   800a7b <_panic>
		return r;
  802bd6:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802bdc:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  802be2:	e9 31 fe ff ff       	jmp    802a18 <spawn+0x367>
		return -E_NO_MEM;
  802be7:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	return r;
  802bec:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  802bf2:	e9 21 fe ff ff       	jmp    802a18 <spawn+0x367>
  802bf7:	89 c7                	mov    %eax,%edi
  802bf9:	e9 f5 fd ff ff       	jmp    8029f3 <spawn+0x342>
  802bfe:	89 c7                	mov    %eax,%edi
  802c00:	e9 ee fd ff ff       	jmp    8029f3 <spawn+0x342>
  802c05:	89 c7                	mov    %eax,%edi
  802c07:	e9 e7 fd ff ff       	jmp    8029f3 <spawn+0x342>
	sys_page_unmap(0, UTEMP);
  802c0c:	83 ec 08             	sub    $0x8,%esp
  802c0f:	68 00 00 40 00       	push   $0x400000
  802c14:	6a 00                	push   $0x0
  802c16:	e8 46 eb ff ff       	call   801761 <sys_page_unmap>
  802c1b:	83 c4 10             	add    $0x10,%esp
  802c1e:	89 9d 90 fd ff ff    	mov    %ebx,-0x270(%ebp)
  802c24:	e9 ef fd ff ff       	jmp    802a18 <spawn+0x367>

00802c29 <spawnl>:
{
  802c29:	55                   	push   %ebp
  802c2a:	89 e5                	mov    %esp,%ebp
  802c2c:	57                   	push   %edi
  802c2d:	56                   	push   %esi
  802c2e:	53                   	push   %ebx
  802c2f:	83 ec 0c             	sub    $0xc,%esp
	va_start(vl, arg0);
  802c32:	8d 55 10             	lea    0x10(%ebp),%edx
	int argc=0;
  802c35:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  802c3a:	eb 05                	jmp    802c41 <spawnl+0x18>
		argc++;
  802c3c:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  802c3f:	89 ca                	mov    %ecx,%edx
  802c41:	8d 4a 04             	lea    0x4(%edx),%ecx
  802c44:	83 3a 00             	cmpl   $0x0,(%edx)
  802c47:	75 f3                	jne    802c3c <spawnl+0x13>
	const char *argv[argc+2];
  802c49:	8d 14 85 1a 00 00 00 	lea    0x1a(,%eax,4),%edx
  802c50:	83 e2 f0             	and    $0xfffffff0,%edx
  802c53:	29 d4                	sub    %edx,%esp
  802c55:	8d 54 24 03          	lea    0x3(%esp),%edx
  802c59:	c1 ea 02             	shr    $0x2,%edx
  802c5c:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  802c63:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  802c65:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802c68:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  802c6f:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  802c76:	00 
	va_start(vl, arg0);
  802c77:	8d 4d 10             	lea    0x10(%ebp),%ecx
  802c7a:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  802c7c:	b8 00 00 00 00       	mov    $0x0,%eax
  802c81:	eb 0b                	jmp    802c8e <spawnl+0x65>
		argv[i+1] = va_arg(vl, const char *);
  802c83:	83 c0 01             	add    $0x1,%eax
  802c86:	8b 39                	mov    (%ecx),%edi
  802c88:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  802c8b:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  802c8e:	39 d0                	cmp    %edx,%eax
  802c90:	75 f1                	jne    802c83 <spawnl+0x5a>
	return spawn(prog, argv);
  802c92:	83 ec 08             	sub    $0x8,%esp
  802c95:	56                   	push   %esi
  802c96:	ff 75 08             	pushl  0x8(%ebp)
  802c99:	e8 13 fa ff ff       	call   8026b1 <spawn>
}
  802c9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802ca1:	5b                   	pop    %ebx
  802ca2:	5e                   	pop    %esi
  802ca3:	5f                   	pop    %edi
  802ca4:	5d                   	pop    %ebp
  802ca5:	c3                   	ret    

00802ca6 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802ca6:	55                   	push   %ebp
  802ca7:	89 e5                	mov    %esp,%ebp
  802ca9:	56                   	push   %esi
  802caa:	53                   	push   %ebx
  802cab:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802cae:	83 ec 0c             	sub    $0xc,%esp
  802cb1:	ff 75 08             	pushl  0x8(%ebp)
  802cb4:	e8 c3 f0 ff ff       	call   801d7c <fd2data>
  802cb9:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802cbb:	83 c4 08             	add    $0x8,%esp
  802cbe:	68 34 40 80 00       	push   $0x804034
  802cc3:	53                   	push   %ebx
  802cc4:	e8 1a e6 ff ff       	call   8012e3 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802cc9:	8b 46 04             	mov    0x4(%esi),%eax
  802ccc:	2b 06                	sub    (%esi),%eax
  802cce:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802cd4:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802cdb:	00 00 00 
	stat->st_dev = &devpipe;
  802cde:	c7 83 88 00 00 00 3c 	movl   $0x80503c,0x88(%ebx)
  802ce5:	50 80 00 
	return 0;
}
  802ce8:	b8 00 00 00 00       	mov    $0x0,%eax
  802ced:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802cf0:	5b                   	pop    %ebx
  802cf1:	5e                   	pop    %esi
  802cf2:	5d                   	pop    %ebp
  802cf3:	c3                   	ret    

00802cf4 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802cf4:	55                   	push   %ebp
  802cf5:	89 e5                	mov    %esp,%ebp
  802cf7:	53                   	push   %ebx
  802cf8:	83 ec 0c             	sub    $0xc,%esp
  802cfb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802cfe:	53                   	push   %ebx
  802cff:	6a 00                	push   $0x0
  802d01:	e8 5b ea ff ff       	call   801761 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802d06:	89 1c 24             	mov    %ebx,(%esp)
  802d09:	e8 6e f0 ff ff       	call   801d7c <fd2data>
  802d0e:	83 c4 08             	add    $0x8,%esp
  802d11:	50                   	push   %eax
  802d12:	6a 00                	push   $0x0
  802d14:	e8 48 ea ff ff       	call   801761 <sys_page_unmap>
}
  802d19:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802d1c:	c9                   	leave  
  802d1d:	c3                   	ret    

00802d1e <_pipeisclosed>:
{
  802d1e:	55                   	push   %ebp
  802d1f:	89 e5                	mov    %esp,%ebp
  802d21:	57                   	push   %edi
  802d22:	56                   	push   %esi
  802d23:	53                   	push   %ebx
  802d24:	83 ec 1c             	sub    $0x1c,%esp
  802d27:	89 c7                	mov    %eax,%edi
  802d29:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802d2b:	a1 28 64 80 00       	mov    0x806428,%eax
  802d30:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802d33:	83 ec 0c             	sub    $0xc,%esp
  802d36:	57                   	push   %edi
  802d37:	e8 05 09 00 00       	call   803641 <pageref>
  802d3c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802d3f:	89 34 24             	mov    %esi,(%esp)
  802d42:	e8 fa 08 00 00       	call   803641 <pageref>
		nn = thisenv->env_runs;
  802d47:	8b 15 28 64 80 00    	mov    0x806428,%edx
  802d4d:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802d50:	83 c4 10             	add    $0x10,%esp
  802d53:	39 cb                	cmp    %ecx,%ebx
  802d55:	74 1b                	je     802d72 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802d57:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802d5a:	75 cf                	jne    802d2b <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802d5c:	8b 42 58             	mov    0x58(%edx),%eax
  802d5f:	6a 01                	push   $0x1
  802d61:	50                   	push   %eax
  802d62:	53                   	push   %ebx
  802d63:	68 3b 40 80 00       	push   $0x80403b
  802d68:	e8 e9 dd ff ff       	call   800b56 <cprintf>
  802d6d:	83 c4 10             	add    $0x10,%esp
  802d70:	eb b9                	jmp    802d2b <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802d72:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802d75:	0f 94 c0             	sete   %al
  802d78:	0f b6 c0             	movzbl %al,%eax
}
  802d7b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802d7e:	5b                   	pop    %ebx
  802d7f:	5e                   	pop    %esi
  802d80:	5f                   	pop    %edi
  802d81:	5d                   	pop    %ebp
  802d82:	c3                   	ret    

00802d83 <devpipe_write>:
{
  802d83:	55                   	push   %ebp
  802d84:	89 e5                	mov    %esp,%ebp
  802d86:	57                   	push   %edi
  802d87:	56                   	push   %esi
  802d88:	53                   	push   %ebx
  802d89:	83 ec 28             	sub    $0x28,%esp
  802d8c:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802d8f:	56                   	push   %esi
  802d90:	e8 e7 ef ff ff       	call   801d7c <fd2data>
  802d95:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802d97:	83 c4 10             	add    $0x10,%esp
  802d9a:	bf 00 00 00 00       	mov    $0x0,%edi
  802d9f:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802da2:	74 4f                	je     802df3 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802da4:	8b 43 04             	mov    0x4(%ebx),%eax
  802da7:	8b 0b                	mov    (%ebx),%ecx
  802da9:	8d 51 20             	lea    0x20(%ecx),%edx
  802dac:	39 d0                	cmp    %edx,%eax
  802dae:	72 14                	jb     802dc4 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802db0:	89 da                	mov    %ebx,%edx
  802db2:	89 f0                	mov    %esi,%eax
  802db4:	e8 65 ff ff ff       	call   802d1e <_pipeisclosed>
  802db9:	85 c0                	test   %eax,%eax
  802dbb:	75 3a                	jne    802df7 <devpipe_write+0x74>
			sys_yield();
  802dbd:	e8 fb e8 ff ff       	call   8016bd <sys_yield>
  802dc2:	eb e0                	jmp    802da4 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802dc4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802dc7:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802dcb:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802dce:	89 c2                	mov    %eax,%edx
  802dd0:	c1 fa 1f             	sar    $0x1f,%edx
  802dd3:	89 d1                	mov    %edx,%ecx
  802dd5:	c1 e9 1b             	shr    $0x1b,%ecx
  802dd8:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802ddb:	83 e2 1f             	and    $0x1f,%edx
  802dde:	29 ca                	sub    %ecx,%edx
  802de0:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802de4:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802de8:	83 c0 01             	add    $0x1,%eax
  802deb:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802dee:	83 c7 01             	add    $0x1,%edi
  802df1:	eb ac                	jmp    802d9f <devpipe_write+0x1c>
	return i;
  802df3:	89 f8                	mov    %edi,%eax
  802df5:	eb 05                	jmp    802dfc <devpipe_write+0x79>
				return 0;
  802df7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802dfc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802dff:	5b                   	pop    %ebx
  802e00:	5e                   	pop    %esi
  802e01:	5f                   	pop    %edi
  802e02:	5d                   	pop    %ebp
  802e03:	c3                   	ret    

00802e04 <devpipe_read>:
{
  802e04:	55                   	push   %ebp
  802e05:	89 e5                	mov    %esp,%ebp
  802e07:	57                   	push   %edi
  802e08:	56                   	push   %esi
  802e09:	53                   	push   %ebx
  802e0a:	83 ec 18             	sub    $0x18,%esp
  802e0d:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802e10:	57                   	push   %edi
  802e11:	e8 66 ef ff ff       	call   801d7c <fd2data>
  802e16:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802e18:	83 c4 10             	add    $0x10,%esp
  802e1b:	be 00 00 00 00       	mov    $0x0,%esi
  802e20:	3b 75 10             	cmp    0x10(%ebp),%esi
  802e23:	74 47                	je     802e6c <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  802e25:	8b 03                	mov    (%ebx),%eax
  802e27:	3b 43 04             	cmp    0x4(%ebx),%eax
  802e2a:	75 22                	jne    802e4e <devpipe_read+0x4a>
			if (i > 0)
  802e2c:	85 f6                	test   %esi,%esi
  802e2e:	75 14                	jne    802e44 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  802e30:	89 da                	mov    %ebx,%edx
  802e32:	89 f8                	mov    %edi,%eax
  802e34:	e8 e5 fe ff ff       	call   802d1e <_pipeisclosed>
  802e39:	85 c0                	test   %eax,%eax
  802e3b:	75 33                	jne    802e70 <devpipe_read+0x6c>
			sys_yield();
  802e3d:	e8 7b e8 ff ff       	call   8016bd <sys_yield>
  802e42:	eb e1                	jmp    802e25 <devpipe_read+0x21>
				return i;
  802e44:	89 f0                	mov    %esi,%eax
}
  802e46:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802e49:	5b                   	pop    %ebx
  802e4a:	5e                   	pop    %esi
  802e4b:	5f                   	pop    %edi
  802e4c:	5d                   	pop    %ebp
  802e4d:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802e4e:	99                   	cltd   
  802e4f:	c1 ea 1b             	shr    $0x1b,%edx
  802e52:	01 d0                	add    %edx,%eax
  802e54:	83 e0 1f             	and    $0x1f,%eax
  802e57:	29 d0                	sub    %edx,%eax
  802e59:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802e5e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802e61:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802e64:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802e67:	83 c6 01             	add    $0x1,%esi
  802e6a:	eb b4                	jmp    802e20 <devpipe_read+0x1c>
	return i;
  802e6c:	89 f0                	mov    %esi,%eax
  802e6e:	eb d6                	jmp    802e46 <devpipe_read+0x42>
				return 0;
  802e70:	b8 00 00 00 00       	mov    $0x0,%eax
  802e75:	eb cf                	jmp    802e46 <devpipe_read+0x42>

00802e77 <pipe>:
{
  802e77:	55                   	push   %ebp
  802e78:	89 e5                	mov    %esp,%ebp
  802e7a:	56                   	push   %esi
  802e7b:	53                   	push   %ebx
  802e7c:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802e7f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802e82:	50                   	push   %eax
  802e83:	e8 0b ef ff ff       	call   801d93 <fd_alloc>
  802e88:	89 c3                	mov    %eax,%ebx
  802e8a:	83 c4 10             	add    $0x10,%esp
  802e8d:	85 c0                	test   %eax,%eax
  802e8f:	78 5b                	js     802eec <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802e91:	83 ec 04             	sub    $0x4,%esp
  802e94:	68 07 04 00 00       	push   $0x407
  802e99:	ff 75 f4             	pushl  -0xc(%ebp)
  802e9c:	6a 00                	push   $0x0
  802e9e:	e8 39 e8 ff ff       	call   8016dc <sys_page_alloc>
  802ea3:	89 c3                	mov    %eax,%ebx
  802ea5:	83 c4 10             	add    $0x10,%esp
  802ea8:	85 c0                	test   %eax,%eax
  802eaa:	78 40                	js     802eec <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  802eac:	83 ec 0c             	sub    $0xc,%esp
  802eaf:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802eb2:	50                   	push   %eax
  802eb3:	e8 db ee ff ff       	call   801d93 <fd_alloc>
  802eb8:	89 c3                	mov    %eax,%ebx
  802eba:	83 c4 10             	add    $0x10,%esp
  802ebd:	85 c0                	test   %eax,%eax
  802ebf:	78 1b                	js     802edc <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802ec1:	83 ec 04             	sub    $0x4,%esp
  802ec4:	68 07 04 00 00       	push   $0x407
  802ec9:	ff 75 f0             	pushl  -0x10(%ebp)
  802ecc:	6a 00                	push   $0x0
  802ece:	e8 09 e8 ff ff       	call   8016dc <sys_page_alloc>
  802ed3:	89 c3                	mov    %eax,%ebx
  802ed5:	83 c4 10             	add    $0x10,%esp
  802ed8:	85 c0                	test   %eax,%eax
  802eda:	79 19                	jns    802ef5 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  802edc:	83 ec 08             	sub    $0x8,%esp
  802edf:	ff 75 f4             	pushl  -0xc(%ebp)
  802ee2:	6a 00                	push   $0x0
  802ee4:	e8 78 e8 ff ff       	call   801761 <sys_page_unmap>
  802ee9:	83 c4 10             	add    $0x10,%esp
}
  802eec:	89 d8                	mov    %ebx,%eax
  802eee:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802ef1:	5b                   	pop    %ebx
  802ef2:	5e                   	pop    %esi
  802ef3:	5d                   	pop    %ebp
  802ef4:	c3                   	ret    
	va = fd2data(fd0);
  802ef5:	83 ec 0c             	sub    $0xc,%esp
  802ef8:	ff 75 f4             	pushl  -0xc(%ebp)
  802efb:	e8 7c ee ff ff       	call   801d7c <fd2data>
  802f00:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802f02:	83 c4 0c             	add    $0xc,%esp
  802f05:	68 07 04 00 00       	push   $0x407
  802f0a:	50                   	push   %eax
  802f0b:	6a 00                	push   $0x0
  802f0d:	e8 ca e7 ff ff       	call   8016dc <sys_page_alloc>
  802f12:	89 c3                	mov    %eax,%ebx
  802f14:	83 c4 10             	add    $0x10,%esp
  802f17:	85 c0                	test   %eax,%eax
  802f19:	0f 88 8c 00 00 00    	js     802fab <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802f1f:	83 ec 0c             	sub    $0xc,%esp
  802f22:	ff 75 f0             	pushl  -0x10(%ebp)
  802f25:	e8 52 ee ff ff       	call   801d7c <fd2data>
  802f2a:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802f31:	50                   	push   %eax
  802f32:	6a 00                	push   $0x0
  802f34:	56                   	push   %esi
  802f35:	6a 00                	push   $0x0
  802f37:	e8 e3 e7 ff ff       	call   80171f <sys_page_map>
  802f3c:	89 c3                	mov    %eax,%ebx
  802f3e:	83 c4 20             	add    $0x20,%esp
  802f41:	85 c0                	test   %eax,%eax
  802f43:	78 58                	js     802f9d <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  802f45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f48:	8b 15 3c 50 80 00    	mov    0x80503c,%edx
  802f4e:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  802f50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f53:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  802f5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f5d:	8b 15 3c 50 80 00    	mov    0x80503c,%edx
  802f63:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802f65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f68:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802f6f:	83 ec 0c             	sub    $0xc,%esp
  802f72:	ff 75 f4             	pushl  -0xc(%ebp)
  802f75:	e8 f2 ed ff ff       	call   801d6c <fd2num>
  802f7a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802f7d:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802f7f:	83 c4 04             	add    $0x4,%esp
  802f82:	ff 75 f0             	pushl  -0x10(%ebp)
  802f85:	e8 e2 ed ff ff       	call   801d6c <fd2num>
  802f8a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802f8d:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802f90:	83 c4 10             	add    $0x10,%esp
  802f93:	bb 00 00 00 00       	mov    $0x0,%ebx
  802f98:	e9 4f ff ff ff       	jmp    802eec <pipe+0x75>
	sys_page_unmap(0, va);
  802f9d:	83 ec 08             	sub    $0x8,%esp
  802fa0:	56                   	push   %esi
  802fa1:	6a 00                	push   $0x0
  802fa3:	e8 b9 e7 ff ff       	call   801761 <sys_page_unmap>
  802fa8:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802fab:	83 ec 08             	sub    $0x8,%esp
  802fae:	ff 75 f0             	pushl  -0x10(%ebp)
  802fb1:	6a 00                	push   $0x0
  802fb3:	e8 a9 e7 ff ff       	call   801761 <sys_page_unmap>
  802fb8:	83 c4 10             	add    $0x10,%esp
  802fbb:	e9 1c ff ff ff       	jmp    802edc <pipe+0x65>

00802fc0 <pipeisclosed>:
{
  802fc0:	55                   	push   %ebp
  802fc1:	89 e5                	mov    %esp,%ebp
  802fc3:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802fc6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802fc9:	50                   	push   %eax
  802fca:	ff 75 08             	pushl  0x8(%ebp)
  802fcd:	e8 10 ee ff ff       	call   801de2 <fd_lookup>
  802fd2:	83 c4 10             	add    $0x10,%esp
  802fd5:	85 c0                	test   %eax,%eax
  802fd7:	78 18                	js     802ff1 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802fd9:	83 ec 0c             	sub    $0xc,%esp
  802fdc:	ff 75 f4             	pushl  -0xc(%ebp)
  802fdf:	e8 98 ed ff ff       	call   801d7c <fd2data>
	return _pipeisclosed(fd, p);
  802fe4:	89 c2                	mov    %eax,%edx
  802fe6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe9:	e8 30 fd ff ff       	call   802d1e <_pipeisclosed>
  802fee:	83 c4 10             	add    $0x10,%esp
}
  802ff1:	c9                   	leave  
  802ff2:	c3                   	ret    

00802ff3 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  802ff3:	55                   	push   %ebp
  802ff4:	89 e5                	mov    %esp,%ebp
  802ff6:	56                   	push   %esi
  802ff7:	53                   	push   %ebx
  802ff8:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  802ffb:	85 f6                	test   %esi,%esi
  802ffd:	74 13                	je     803012 <wait+0x1f>
	e = &envs[ENVX(envid)];
  802fff:	89 f3                	mov    %esi,%ebx
  803001:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  803007:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  80300a:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  803010:	eb 1b                	jmp    80302d <wait+0x3a>
	assert(envid != 0);
  803012:	68 53 40 80 00       	push   $0x804053
  803017:	68 06 3a 80 00       	push   $0x803a06
  80301c:	6a 09                	push   $0x9
  80301e:	68 5e 40 80 00       	push   $0x80405e
  803023:	e8 53 da ff ff       	call   800a7b <_panic>
		sys_yield();
  803028:	e8 90 e6 ff ff       	call   8016bd <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  80302d:	8b 43 48             	mov    0x48(%ebx),%eax
  803030:	39 f0                	cmp    %esi,%eax
  803032:	75 07                	jne    80303b <wait+0x48>
  803034:	8b 43 54             	mov    0x54(%ebx),%eax
  803037:	85 c0                	test   %eax,%eax
  803039:	75 ed                	jne    803028 <wait+0x35>
}
  80303b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80303e:	5b                   	pop    %ebx
  80303f:	5e                   	pop    %esi
  803040:	5d                   	pop    %ebp
  803041:	c3                   	ret    

00803042 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803042:	55                   	push   %ebp
  803043:	89 e5                	mov    %esp,%ebp
  803045:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  803048:	68 69 40 80 00       	push   $0x804069
  80304d:	ff 75 0c             	pushl  0xc(%ebp)
  803050:	e8 8e e2 ff ff       	call   8012e3 <strcpy>
	return 0;
}
  803055:	b8 00 00 00 00       	mov    $0x0,%eax
  80305a:	c9                   	leave  
  80305b:	c3                   	ret    

0080305c <devsock_close>:
{
  80305c:	55                   	push   %ebp
  80305d:	89 e5                	mov    %esp,%ebp
  80305f:	53                   	push   %ebx
  803060:	83 ec 10             	sub    $0x10,%esp
  803063:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  803066:	53                   	push   %ebx
  803067:	e8 d5 05 00 00       	call   803641 <pageref>
  80306c:	83 c4 10             	add    $0x10,%esp
		return 0;
  80306f:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  803074:	83 f8 01             	cmp    $0x1,%eax
  803077:	74 07                	je     803080 <devsock_close+0x24>
}
  803079:	89 d0                	mov    %edx,%eax
  80307b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80307e:	c9                   	leave  
  80307f:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  803080:	83 ec 0c             	sub    $0xc,%esp
  803083:	ff 73 0c             	pushl  0xc(%ebx)
  803086:	e8 b7 02 00 00       	call   803342 <nsipc_close>
  80308b:	89 c2                	mov    %eax,%edx
  80308d:	83 c4 10             	add    $0x10,%esp
  803090:	eb e7                	jmp    803079 <devsock_close+0x1d>

00803092 <devsock_write>:
{
  803092:	55                   	push   %ebp
  803093:	89 e5                	mov    %esp,%ebp
  803095:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803098:	6a 00                	push   $0x0
  80309a:	ff 75 10             	pushl  0x10(%ebp)
  80309d:	ff 75 0c             	pushl  0xc(%ebp)
  8030a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a3:	ff 70 0c             	pushl  0xc(%eax)
  8030a6:	e8 74 03 00 00       	call   80341f <nsipc_send>
}
  8030ab:	c9                   	leave  
  8030ac:	c3                   	ret    

008030ad <devsock_read>:
{
  8030ad:	55                   	push   %ebp
  8030ae:	89 e5                	mov    %esp,%ebp
  8030b0:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8030b3:	6a 00                	push   $0x0
  8030b5:	ff 75 10             	pushl  0x10(%ebp)
  8030b8:	ff 75 0c             	pushl  0xc(%ebp)
  8030bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8030be:	ff 70 0c             	pushl  0xc(%eax)
  8030c1:	e8 ed 02 00 00       	call   8033b3 <nsipc_recv>
}
  8030c6:	c9                   	leave  
  8030c7:	c3                   	ret    

008030c8 <fd2sockid>:
{
  8030c8:	55                   	push   %ebp
  8030c9:	89 e5                	mov    %esp,%ebp
  8030cb:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8030ce:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8030d1:	52                   	push   %edx
  8030d2:	50                   	push   %eax
  8030d3:	e8 0a ed ff ff       	call   801de2 <fd_lookup>
  8030d8:	83 c4 10             	add    $0x10,%esp
  8030db:	85 c0                	test   %eax,%eax
  8030dd:	78 10                	js     8030ef <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8030df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e2:	8b 0d 58 50 80 00    	mov    0x805058,%ecx
  8030e8:	39 08                	cmp    %ecx,(%eax)
  8030ea:	75 05                	jne    8030f1 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8030ec:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8030ef:	c9                   	leave  
  8030f0:	c3                   	ret    
		return -E_NOT_SUPP;
  8030f1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8030f6:	eb f7                	jmp    8030ef <fd2sockid+0x27>

008030f8 <alloc_sockfd>:
{
  8030f8:	55                   	push   %ebp
  8030f9:	89 e5                	mov    %esp,%ebp
  8030fb:	56                   	push   %esi
  8030fc:	53                   	push   %ebx
  8030fd:	83 ec 1c             	sub    $0x1c,%esp
  803100:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  803102:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803105:	50                   	push   %eax
  803106:	e8 88 ec ff ff       	call   801d93 <fd_alloc>
  80310b:	89 c3                	mov    %eax,%ebx
  80310d:	83 c4 10             	add    $0x10,%esp
  803110:	85 c0                	test   %eax,%eax
  803112:	78 43                	js     803157 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  803114:	83 ec 04             	sub    $0x4,%esp
  803117:	68 07 04 00 00       	push   $0x407
  80311c:	ff 75 f4             	pushl  -0xc(%ebp)
  80311f:	6a 00                	push   $0x0
  803121:	e8 b6 e5 ff ff       	call   8016dc <sys_page_alloc>
  803126:	89 c3                	mov    %eax,%ebx
  803128:	83 c4 10             	add    $0x10,%esp
  80312b:	85 c0                	test   %eax,%eax
  80312d:	78 28                	js     803157 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  80312f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803132:	8b 15 58 50 80 00    	mov    0x805058,%edx
  803138:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80313a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80313d:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  803144:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  803147:	83 ec 0c             	sub    $0xc,%esp
  80314a:	50                   	push   %eax
  80314b:	e8 1c ec ff ff       	call   801d6c <fd2num>
  803150:	89 c3                	mov    %eax,%ebx
  803152:	83 c4 10             	add    $0x10,%esp
  803155:	eb 0c                	jmp    803163 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  803157:	83 ec 0c             	sub    $0xc,%esp
  80315a:	56                   	push   %esi
  80315b:	e8 e2 01 00 00       	call   803342 <nsipc_close>
		return r;
  803160:	83 c4 10             	add    $0x10,%esp
}
  803163:	89 d8                	mov    %ebx,%eax
  803165:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803168:	5b                   	pop    %ebx
  803169:	5e                   	pop    %esi
  80316a:	5d                   	pop    %ebp
  80316b:	c3                   	ret    

0080316c <accept>:
{
  80316c:	55                   	push   %ebp
  80316d:	89 e5                	mov    %esp,%ebp
  80316f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  803172:	8b 45 08             	mov    0x8(%ebp),%eax
  803175:	e8 4e ff ff ff       	call   8030c8 <fd2sockid>
  80317a:	85 c0                	test   %eax,%eax
  80317c:	78 1b                	js     803199 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80317e:	83 ec 04             	sub    $0x4,%esp
  803181:	ff 75 10             	pushl  0x10(%ebp)
  803184:	ff 75 0c             	pushl  0xc(%ebp)
  803187:	50                   	push   %eax
  803188:	e8 0e 01 00 00       	call   80329b <nsipc_accept>
  80318d:	83 c4 10             	add    $0x10,%esp
  803190:	85 c0                	test   %eax,%eax
  803192:	78 05                	js     803199 <accept+0x2d>
	return alloc_sockfd(r);
  803194:	e8 5f ff ff ff       	call   8030f8 <alloc_sockfd>
}
  803199:	c9                   	leave  
  80319a:	c3                   	ret    

0080319b <bind>:
{
  80319b:	55                   	push   %ebp
  80319c:	89 e5                	mov    %esp,%ebp
  80319e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8031a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a4:	e8 1f ff ff ff       	call   8030c8 <fd2sockid>
  8031a9:	85 c0                	test   %eax,%eax
  8031ab:	78 12                	js     8031bf <bind+0x24>
	return nsipc_bind(r, name, namelen);
  8031ad:	83 ec 04             	sub    $0x4,%esp
  8031b0:	ff 75 10             	pushl  0x10(%ebp)
  8031b3:	ff 75 0c             	pushl  0xc(%ebp)
  8031b6:	50                   	push   %eax
  8031b7:	e8 2f 01 00 00       	call   8032eb <nsipc_bind>
  8031bc:	83 c4 10             	add    $0x10,%esp
}
  8031bf:	c9                   	leave  
  8031c0:	c3                   	ret    

008031c1 <shutdown>:
{
  8031c1:	55                   	push   %ebp
  8031c2:	89 e5                	mov    %esp,%ebp
  8031c4:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8031c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ca:	e8 f9 fe ff ff       	call   8030c8 <fd2sockid>
  8031cf:	85 c0                	test   %eax,%eax
  8031d1:	78 0f                	js     8031e2 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  8031d3:	83 ec 08             	sub    $0x8,%esp
  8031d6:	ff 75 0c             	pushl  0xc(%ebp)
  8031d9:	50                   	push   %eax
  8031da:	e8 41 01 00 00       	call   803320 <nsipc_shutdown>
  8031df:	83 c4 10             	add    $0x10,%esp
}
  8031e2:	c9                   	leave  
  8031e3:	c3                   	ret    

008031e4 <connect>:
{
  8031e4:	55                   	push   %ebp
  8031e5:	89 e5                	mov    %esp,%ebp
  8031e7:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8031ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ed:	e8 d6 fe ff ff       	call   8030c8 <fd2sockid>
  8031f2:	85 c0                	test   %eax,%eax
  8031f4:	78 12                	js     803208 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8031f6:	83 ec 04             	sub    $0x4,%esp
  8031f9:	ff 75 10             	pushl  0x10(%ebp)
  8031fc:	ff 75 0c             	pushl  0xc(%ebp)
  8031ff:	50                   	push   %eax
  803200:	e8 57 01 00 00       	call   80335c <nsipc_connect>
  803205:	83 c4 10             	add    $0x10,%esp
}
  803208:	c9                   	leave  
  803209:	c3                   	ret    

0080320a <listen>:
{
  80320a:	55                   	push   %ebp
  80320b:	89 e5                	mov    %esp,%ebp
  80320d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  803210:	8b 45 08             	mov    0x8(%ebp),%eax
  803213:	e8 b0 fe ff ff       	call   8030c8 <fd2sockid>
  803218:	85 c0                	test   %eax,%eax
  80321a:	78 0f                	js     80322b <listen+0x21>
	return nsipc_listen(r, backlog);
  80321c:	83 ec 08             	sub    $0x8,%esp
  80321f:	ff 75 0c             	pushl  0xc(%ebp)
  803222:	50                   	push   %eax
  803223:	e8 69 01 00 00       	call   803391 <nsipc_listen>
  803228:	83 c4 10             	add    $0x10,%esp
}
  80322b:	c9                   	leave  
  80322c:	c3                   	ret    

0080322d <socket>:

int
socket(int domain, int type, int protocol)
{
  80322d:	55                   	push   %ebp
  80322e:	89 e5                	mov    %esp,%ebp
  803230:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803233:	ff 75 10             	pushl  0x10(%ebp)
  803236:	ff 75 0c             	pushl  0xc(%ebp)
  803239:	ff 75 08             	pushl  0x8(%ebp)
  80323c:	e8 3c 02 00 00       	call   80347d <nsipc_socket>
  803241:	83 c4 10             	add    $0x10,%esp
  803244:	85 c0                	test   %eax,%eax
  803246:	78 05                	js     80324d <socket+0x20>
		return r;
	return alloc_sockfd(r);
  803248:	e8 ab fe ff ff       	call   8030f8 <alloc_sockfd>
}
  80324d:	c9                   	leave  
  80324e:	c3                   	ret    

0080324f <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80324f:	55                   	push   %ebp
  803250:	89 e5                	mov    %esp,%ebp
  803252:	53                   	push   %ebx
  803253:	83 ec 04             	sub    $0x4,%esp
  803256:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  803258:	83 3d 24 64 80 00 00 	cmpl   $0x0,0x806424
  80325f:	74 26                	je     803287 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803261:	6a 07                	push   $0x7
  803263:	68 00 80 80 00       	push   $0x808000
  803268:	53                   	push   %ebx
  803269:	ff 35 24 64 80 00    	pushl  0x806424
  80326f:	e8 3b 03 00 00       	call   8035af <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  803274:	83 c4 0c             	add    $0xc,%esp
  803277:	6a 00                	push   $0x0
  803279:	6a 00                	push   $0x0
  80327b:	6a 00                	push   $0x0
  80327d:	e8 c4 02 00 00       	call   803546 <ipc_recv>
}
  803282:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803285:	c9                   	leave  
  803286:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803287:	83 ec 0c             	sub    $0xc,%esp
  80328a:	6a 02                	push   $0x2
  80328c:	e8 77 03 00 00       	call   803608 <ipc_find_env>
  803291:	a3 24 64 80 00       	mov    %eax,0x806424
  803296:	83 c4 10             	add    $0x10,%esp
  803299:	eb c6                	jmp    803261 <nsipc+0x12>

0080329b <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80329b:	55                   	push   %ebp
  80329c:	89 e5                	mov    %esp,%ebp
  80329e:	56                   	push   %esi
  80329f:	53                   	push   %ebx
  8032a0:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8032a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a6:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8032ab:	8b 06                	mov    (%esi),%eax
  8032ad:	a3 04 80 80 00       	mov    %eax,0x808004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8032b2:	b8 01 00 00 00       	mov    $0x1,%eax
  8032b7:	e8 93 ff ff ff       	call   80324f <nsipc>
  8032bc:	89 c3                	mov    %eax,%ebx
  8032be:	85 c0                	test   %eax,%eax
  8032c0:	78 20                	js     8032e2 <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8032c2:	83 ec 04             	sub    $0x4,%esp
  8032c5:	ff 35 10 80 80 00    	pushl  0x808010
  8032cb:	68 00 80 80 00       	push   $0x808000
  8032d0:	ff 75 0c             	pushl  0xc(%ebp)
  8032d3:	e8 99 e1 ff ff       	call   801471 <memmove>
		*addrlen = ret->ret_addrlen;
  8032d8:	a1 10 80 80 00       	mov    0x808010,%eax
  8032dd:	89 06                	mov    %eax,(%esi)
  8032df:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  8032e2:	89 d8                	mov    %ebx,%eax
  8032e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8032e7:	5b                   	pop    %ebx
  8032e8:	5e                   	pop    %esi
  8032e9:	5d                   	pop    %ebp
  8032ea:	c3                   	ret    

008032eb <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8032eb:	55                   	push   %ebp
  8032ec:	89 e5                	mov    %esp,%ebp
  8032ee:	53                   	push   %ebx
  8032ef:	83 ec 08             	sub    $0x8,%esp
  8032f2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8032f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f8:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8032fd:	53                   	push   %ebx
  8032fe:	ff 75 0c             	pushl  0xc(%ebp)
  803301:	68 04 80 80 00       	push   $0x808004
  803306:	e8 66 e1 ff ff       	call   801471 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  80330b:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_BIND);
  803311:	b8 02 00 00 00       	mov    $0x2,%eax
  803316:	e8 34 ff ff ff       	call   80324f <nsipc>
}
  80331b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80331e:	c9                   	leave  
  80331f:	c3                   	ret    

00803320 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803320:	55                   	push   %ebp
  803321:	89 e5                	mov    %esp,%ebp
  803323:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  803326:	8b 45 08             	mov    0x8(%ebp),%eax
  803329:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.shutdown.req_how = how;
  80332e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803331:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_SHUTDOWN);
  803336:	b8 03 00 00 00       	mov    $0x3,%eax
  80333b:	e8 0f ff ff ff       	call   80324f <nsipc>
}
  803340:	c9                   	leave  
  803341:	c3                   	ret    

00803342 <nsipc_close>:

int
nsipc_close(int s)
{
  803342:	55                   	push   %ebp
  803343:	89 e5                	mov    %esp,%ebp
  803345:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  803348:	8b 45 08             	mov    0x8(%ebp),%eax
  80334b:	a3 00 80 80 00       	mov    %eax,0x808000
	return nsipc(NSREQ_CLOSE);
  803350:	b8 04 00 00 00       	mov    $0x4,%eax
  803355:	e8 f5 fe ff ff       	call   80324f <nsipc>
}
  80335a:	c9                   	leave  
  80335b:	c3                   	ret    

0080335c <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80335c:	55                   	push   %ebp
  80335d:	89 e5                	mov    %esp,%ebp
  80335f:	53                   	push   %ebx
  803360:	83 ec 08             	sub    $0x8,%esp
  803363:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  803366:	8b 45 08             	mov    0x8(%ebp),%eax
  803369:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80336e:	53                   	push   %ebx
  80336f:	ff 75 0c             	pushl  0xc(%ebp)
  803372:	68 04 80 80 00       	push   $0x808004
  803377:	e8 f5 e0 ff ff       	call   801471 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80337c:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_CONNECT);
  803382:	b8 05 00 00 00       	mov    $0x5,%eax
  803387:	e8 c3 fe ff ff       	call   80324f <nsipc>
}
  80338c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80338f:	c9                   	leave  
  803390:	c3                   	ret    

00803391 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803391:	55                   	push   %ebp
  803392:	89 e5                	mov    %esp,%ebp
  803394:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  803397:	8b 45 08             	mov    0x8(%ebp),%eax
  80339a:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.listen.req_backlog = backlog;
  80339f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033a2:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_LISTEN);
  8033a7:	b8 06 00 00 00       	mov    $0x6,%eax
  8033ac:	e8 9e fe ff ff       	call   80324f <nsipc>
}
  8033b1:	c9                   	leave  
  8033b2:	c3                   	ret    

008033b3 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8033b3:	55                   	push   %ebp
  8033b4:	89 e5                	mov    %esp,%ebp
  8033b6:	56                   	push   %esi
  8033b7:	53                   	push   %ebx
  8033b8:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8033bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8033be:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.recv.req_len = len;
  8033c3:	89 35 04 80 80 00    	mov    %esi,0x808004
	nsipcbuf.recv.req_flags = flags;
  8033c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8033cc:	a3 08 80 80 00       	mov    %eax,0x808008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8033d1:	b8 07 00 00 00       	mov    $0x7,%eax
  8033d6:	e8 74 fe ff ff       	call   80324f <nsipc>
  8033db:	89 c3                	mov    %eax,%ebx
  8033dd:	85 c0                	test   %eax,%eax
  8033df:	78 1f                	js     803400 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  8033e1:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8033e6:	7f 21                	jg     803409 <nsipc_recv+0x56>
  8033e8:	39 c6                	cmp    %eax,%esi
  8033ea:	7c 1d                	jl     803409 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8033ec:	83 ec 04             	sub    $0x4,%esp
  8033ef:	50                   	push   %eax
  8033f0:	68 00 80 80 00       	push   $0x808000
  8033f5:	ff 75 0c             	pushl  0xc(%ebp)
  8033f8:	e8 74 e0 ff ff       	call   801471 <memmove>
  8033fd:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  803400:	89 d8                	mov    %ebx,%eax
  803402:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803405:	5b                   	pop    %ebx
  803406:	5e                   	pop    %esi
  803407:	5d                   	pop    %ebp
  803408:	c3                   	ret    
		assert(r < 1600 && r <= len);
  803409:	68 75 40 80 00       	push   $0x804075
  80340e:	68 06 3a 80 00       	push   $0x803a06
  803413:	6a 62                	push   $0x62
  803415:	68 8a 40 80 00       	push   $0x80408a
  80341a:	e8 5c d6 ff ff       	call   800a7b <_panic>

0080341f <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80341f:	55                   	push   %ebp
  803420:	89 e5                	mov    %esp,%ebp
  803422:	53                   	push   %ebx
  803423:	83 ec 04             	sub    $0x4,%esp
  803426:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  803429:	8b 45 08             	mov    0x8(%ebp),%eax
  80342c:	a3 00 80 80 00       	mov    %eax,0x808000
	assert(size < 1600);
  803431:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  803437:	7f 2e                	jg     803467 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803439:	83 ec 04             	sub    $0x4,%esp
  80343c:	53                   	push   %ebx
  80343d:	ff 75 0c             	pushl  0xc(%ebp)
  803440:	68 0c 80 80 00       	push   $0x80800c
  803445:	e8 27 e0 ff ff       	call   801471 <memmove>
	nsipcbuf.send.req_size = size;
  80344a:	89 1d 04 80 80 00    	mov    %ebx,0x808004
	nsipcbuf.send.req_flags = flags;
  803450:	8b 45 14             	mov    0x14(%ebp),%eax
  803453:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SEND);
  803458:	b8 08 00 00 00       	mov    $0x8,%eax
  80345d:	e8 ed fd ff ff       	call   80324f <nsipc>
}
  803462:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803465:	c9                   	leave  
  803466:	c3                   	ret    
	assert(size < 1600);
  803467:	68 96 40 80 00       	push   $0x804096
  80346c:	68 06 3a 80 00       	push   $0x803a06
  803471:	6a 6d                	push   $0x6d
  803473:	68 8a 40 80 00       	push   $0x80408a
  803478:	e8 fe d5 ff ff       	call   800a7b <_panic>

0080347d <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80347d:	55                   	push   %ebp
  80347e:	89 e5                	mov    %esp,%ebp
  803480:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  803483:	8b 45 08             	mov    0x8(%ebp),%eax
  803486:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.socket.req_type = type;
  80348b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80348e:	a3 04 80 80 00       	mov    %eax,0x808004
	nsipcbuf.socket.req_protocol = protocol;
  803493:	8b 45 10             	mov    0x10(%ebp),%eax
  803496:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SOCKET);
  80349b:	b8 09 00 00 00       	mov    $0x9,%eax
  8034a0:	e8 aa fd ff ff       	call   80324f <nsipc>
}
  8034a5:	c9                   	leave  
  8034a6:	c3                   	ret    

008034a7 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8034a7:	55                   	push   %ebp
  8034a8:	89 e5                	mov    %esp,%ebp
  8034aa:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8034ad:	83 3d 00 90 80 00 00 	cmpl   $0x0,0x809000
  8034b4:	74 0a                	je     8034c0 <set_pgfault_handler+0x19>
		    panic("set_pgfault_handler: %e", r);
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8034b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b9:	a3 00 90 80 00       	mov    %eax,0x809000
}
  8034be:	c9                   	leave  
  8034bf:	c3                   	ret    
		if ((r = sys_page_alloc(thisenv->env_id, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P)) != 0) {
  8034c0:	a1 28 64 80 00       	mov    0x806428,%eax
  8034c5:	8b 40 48             	mov    0x48(%eax),%eax
  8034c8:	83 ec 04             	sub    $0x4,%esp
  8034cb:	6a 07                	push   $0x7
  8034cd:	68 00 f0 bf ee       	push   $0xeebff000
  8034d2:	50                   	push   %eax
  8034d3:	e8 04 e2 ff ff       	call   8016dc <sys_page_alloc>
  8034d8:	83 c4 10             	add    $0x10,%esp
  8034db:	85 c0                	test   %eax,%eax
  8034dd:	75 2f                	jne    80350e <set_pgfault_handler+0x67>
		if ((r = sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall)) != 0) {
  8034df:	a1 28 64 80 00       	mov    0x806428,%eax
  8034e4:	8b 40 48             	mov    0x48(%eax),%eax
  8034e7:	83 ec 08             	sub    $0x8,%esp
  8034ea:	68 20 35 80 00       	push   $0x803520
  8034ef:	50                   	push   %eax
  8034f0:	e8 32 e3 ff ff       	call   801827 <sys_env_set_pgfault_upcall>
  8034f5:	83 c4 10             	add    $0x10,%esp
  8034f8:	85 c0                	test   %eax,%eax
  8034fa:	74 ba                	je     8034b6 <set_pgfault_handler+0xf>
		    panic("set_pgfault_handler: %e", r);
  8034fc:	50                   	push   %eax
  8034fd:	68 a2 40 80 00       	push   $0x8040a2
  803502:	6a 24                	push   $0x24
  803504:	68 ba 40 80 00       	push   $0x8040ba
  803509:	e8 6d d5 ff ff       	call   800a7b <_panic>
		    panic("set_pgfault_handler: %e", r);
  80350e:	50                   	push   %eax
  80350f:	68 a2 40 80 00       	push   $0x8040a2
  803514:	6a 21                	push   $0x21
  803516:	68 ba 40 80 00       	push   $0x8040ba
  80351b:	e8 5b d5 ff ff       	call   800a7b <_panic>

00803520 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  803520:	54                   	push   %esp
	movl _pgfault_handler, %eax
  803521:	a1 00 90 80 00       	mov    0x809000,%eax
	call *%eax
  803526:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  803528:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x30(%esp), %ecx    // save trap-time esp in ecx
  80352b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
	subl $4, %ecx            // enlarge the previous stack for 4 bytes
  80352f:	83 e9 04             	sub    $0x4,%ecx
	movl %ecx, 0x30(%esp)    // write the modified esp back
  803532:	89 4c 24 30          	mov    %ecx,0x30(%esp)
	movl 0x28(%esp), %edx    // save trap-time eip in edx
  803536:	8b 54 24 28          	mov    0x28(%esp),%edx
	movl %edx, (%ecx)        // save eip at new esp for return
  80353a:	89 11                	mov    %edx,(%ecx)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp            // skip fault_va and tf_err
  80353c:	83 c4 08             	add    $0x8,%esp
	popal                    // pop PushRegs
  80353f:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4, %esp            // skip eip
  803540:	83 c4 04             	add    $0x4,%esp
	popfl                    // pop eflags
  803543:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	pop %esp
  803544:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  803545:	c3                   	ret    

00803546 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803546:	55                   	push   %ebp
  803547:	89 e5                	mov    %esp,%ebp
  803549:	56                   	push   %esi
  80354a:	53                   	push   %ebx
  80354b:	8b 75 08             	mov    0x8(%ebp),%esi
  80354e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803551:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
  803554:	85 c0                	test   %eax,%eax
	    pg = (void *)UTOP;
  803556:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80355b:	0f 44 c2             	cmove  %edx,%eax
	}
	if ((r = sys_ipc_recv(pg)) < 0) {
  80355e:	83 ec 0c             	sub    $0xc,%esp
  803561:	50                   	push   %eax
  803562:	e8 25 e3 ff ff       	call   80188c <sys_ipc_recv>
  803567:	83 c4 10             	add    $0x10,%esp
  80356a:	85 c0                	test   %eax,%eax
  80356c:	78 2b                	js     803599 <ipc_recv+0x53>
	    if (perm_store != NULL) {
	        *perm_store = 0;
	    }
	    return r;
	}
	if (from_env_store != NULL) {
  80356e:	85 f6                	test   %esi,%esi
  803570:	74 0a                	je     80357c <ipc_recv+0x36>
	    *from_env_store = thisenv->env_ipc_from;
  803572:	a1 28 64 80 00       	mov    0x806428,%eax
  803577:	8b 40 74             	mov    0x74(%eax),%eax
  80357a:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store != NULL) {
  80357c:	85 db                	test   %ebx,%ebx
  80357e:	74 0a                	je     80358a <ipc_recv+0x44>
	    *perm_store = thisenv->env_ipc_perm;
  803580:	a1 28 64 80 00       	mov    0x806428,%eax
  803585:	8b 40 78             	mov    0x78(%eax),%eax
  803588:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  80358a:	a1 28 64 80 00       	mov    0x806428,%eax
  80358f:	8b 40 70             	mov    0x70(%eax),%eax
}
  803592:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803595:	5b                   	pop    %ebx
  803596:	5e                   	pop    %esi
  803597:	5d                   	pop    %ebp
  803598:	c3                   	ret    
	    if (from_env_store != NULL) {
  803599:	85 f6                	test   %esi,%esi
  80359b:	74 06                	je     8035a3 <ipc_recv+0x5d>
	        *from_env_store = 0;
  80359d:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	    if (perm_store != NULL) {
  8035a3:	85 db                	test   %ebx,%ebx
  8035a5:	74 eb                	je     803592 <ipc_recv+0x4c>
	        *perm_store = 0;
  8035a7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8035ad:	eb e3                	jmp    803592 <ipc_recv+0x4c>

008035af <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8035af:	55                   	push   %ebp
  8035b0:	89 e5                	mov    %esp,%ebp
  8035b2:	57                   	push   %edi
  8035b3:	56                   	push   %esi
  8035b4:	53                   	push   %ebx
  8035b5:	83 ec 0c             	sub    $0xc,%esp
  8035b8:	8b 7d 08             	mov    0x8(%ebp),%edi
  8035bb:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
	    pg = (void *)UTOP;
  8035be:	85 f6                	test   %esi,%esi
  8035c0:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8035c5:	0f 44 f0             	cmove  %eax,%esi
  8035c8:	eb 09                	jmp    8035d3 <ipc_send+0x24>
	do {
	    r = sys_ipc_try_send(to_env, val, pg, perm);
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
	        panic("ipc_send: %e", r);
	    }
	    sys_yield();
  8035ca:	e8 ee e0 ff ff       	call   8016bd <sys_yield>
	} while(r != 0);
  8035cf:	85 db                	test   %ebx,%ebx
  8035d1:	74 2d                	je     803600 <ipc_send+0x51>
	    r = sys_ipc_try_send(to_env, val, pg, perm);
  8035d3:	ff 75 14             	pushl  0x14(%ebp)
  8035d6:	56                   	push   %esi
  8035d7:	ff 75 0c             	pushl  0xc(%ebp)
  8035da:	57                   	push   %edi
  8035db:	e8 89 e2 ff ff       	call   801869 <sys_ipc_try_send>
  8035e0:	89 c3                	mov    %eax,%ebx
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
  8035e2:	83 c4 10             	add    $0x10,%esp
  8035e5:	85 c0                	test   %eax,%eax
  8035e7:	79 e1                	jns    8035ca <ipc_send+0x1b>
  8035e9:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8035ec:	74 dc                	je     8035ca <ipc_send+0x1b>
	        panic("ipc_send: %e", r);
  8035ee:	50                   	push   %eax
  8035ef:	68 c8 40 80 00       	push   $0x8040c8
  8035f4:	6a 45                	push   $0x45
  8035f6:	68 d5 40 80 00       	push   $0x8040d5
  8035fb:	e8 7b d4 ff ff       	call   800a7b <_panic>
}
  803600:	8d 65 f4             	lea    -0xc(%ebp),%esp
  803603:	5b                   	pop    %ebx
  803604:	5e                   	pop    %esi
  803605:	5f                   	pop    %edi
  803606:	5d                   	pop    %ebp
  803607:	c3                   	ret    

00803608 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803608:	55                   	push   %ebp
  803609:	89 e5                	mov    %esp,%ebp
  80360b:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80360e:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  803613:	6b d0 7c             	imul   $0x7c,%eax,%edx
  803616:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80361c:	8b 52 50             	mov    0x50(%edx),%edx
  80361f:	39 ca                	cmp    %ecx,%edx
  803621:	74 11                	je     803634 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  803623:	83 c0 01             	add    $0x1,%eax
  803626:	3d 00 04 00 00       	cmp    $0x400,%eax
  80362b:	75 e6                	jne    803613 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80362d:	b8 00 00 00 00       	mov    $0x0,%eax
  803632:	eb 0b                	jmp    80363f <ipc_find_env+0x37>
			return envs[i].env_id;
  803634:	6b c0 7c             	imul   $0x7c,%eax,%eax
  803637:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80363c:	8b 40 48             	mov    0x48(%eax),%eax
}
  80363f:	5d                   	pop    %ebp
  803640:	c3                   	ret    

00803641 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803641:	55                   	push   %ebp
  803642:	89 e5                	mov    %esp,%ebp
  803644:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  803647:	89 d0                	mov    %edx,%eax
  803649:	c1 e8 16             	shr    $0x16,%eax
  80364c:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  803653:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  803658:	f6 c1 01             	test   $0x1,%cl
  80365b:	74 1d                	je     80367a <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80365d:	c1 ea 0c             	shr    $0xc,%edx
  803660:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  803667:	f6 c2 01             	test   $0x1,%dl
  80366a:	74 0e                	je     80367a <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80366c:	c1 ea 0c             	shr    $0xc,%edx
  80366f:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  803676:	ef 
  803677:	0f b7 c0             	movzwl %ax,%eax
}
  80367a:	5d                   	pop    %ebp
  80367b:	c3                   	ret    
  80367c:	66 90                	xchg   %ax,%ax
  80367e:	66 90                	xchg   %ax,%ax

00803680 <__udivdi3>:
  803680:	55                   	push   %ebp
  803681:	57                   	push   %edi
  803682:	56                   	push   %esi
  803683:	53                   	push   %ebx
  803684:	83 ec 1c             	sub    $0x1c,%esp
  803687:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80368b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80368f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803693:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  803697:	85 d2                	test   %edx,%edx
  803699:	75 35                	jne    8036d0 <__udivdi3+0x50>
  80369b:	39 f3                	cmp    %esi,%ebx
  80369d:	0f 87 bd 00 00 00    	ja     803760 <__udivdi3+0xe0>
  8036a3:	85 db                	test   %ebx,%ebx
  8036a5:	89 d9                	mov    %ebx,%ecx
  8036a7:	75 0b                	jne    8036b4 <__udivdi3+0x34>
  8036a9:	b8 01 00 00 00       	mov    $0x1,%eax
  8036ae:	31 d2                	xor    %edx,%edx
  8036b0:	f7 f3                	div    %ebx
  8036b2:	89 c1                	mov    %eax,%ecx
  8036b4:	31 d2                	xor    %edx,%edx
  8036b6:	89 f0                	mov    %esi,%eax
  8036b8:	f7 f1                	div    %ecx
  8036ba:	89 c6                	mov    %eax,%esi
  8036bc:	89 e8                	mov    %ebp,%eax
  8036be:	89 f7                	mov    %esi,%edi
  8036c0:	f7 f1                	div    %ecx
  8036c2:	89 fa                	mov    %edi,%edx
  8036c4:	83 c4 1c             	add    $0x1c,%esp
  8036c7:	5b                   	pop    %ebx
  8036c8:	5e                   	pop    %esi
  8036c9:	5f                   	pop    %edi
  8036ca:	5d                   	pop    %ebp
  8036cb:	c3                   	ret    
  8036cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8036d0:	39 f2                	cmp    %esi,%edx
  8036d2:	77 7c                	ja     803750 <__udivdi3+0xd0>
  8036d4:	0f bd fa             	bsr    %edx,%edi
  8036d7:	83 f7 1f             	xor    $0x1f,%edi
  8036da:	0f 84 98 00 00 00    	je     803778 <__udivdi3+0xf8>
  8036e0:	89 f9                	mov    %edi,%ecx
  8036e2:	b8 20 00 00 00       	mov    $0x20,%eax
  8036e7:	29 f8                	sub    %edi,%eax
  8036e9:	d3 e2                	shl    %cl,%edx
  8036eb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8036ef:	89 c1                	mov    %eax,%ecx
  8036f1:	89 da                	mov    %ebx,%edx
  8036f3:	d3 ea                	shr    %cl,%edx
  8036f5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8036f9:	09 d1                	or     %edx,%ecx
  8036fb:	89 f2                	mov    %esi,%edx
  8036fd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803701:	89 f9                	mov    %edi,%ecx
  803703:	d3 e3                	shl    %cl,%ebx
  803705:	89 c1                	mov    %eax,%ecx
  803707:	d3 ea                	shr    %cl,%edx
  803709:	89 f9                	mov    %edi,%ecx
  80370b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80370f:	d3 e6                	shl    %cl,%esi
  803711:	89 eb                	mov    %ebp,%ebx
  803713:	89 c1                	mov    %eax,%ecx
  803715:	d3 eb                	shr    %cl,%ebx
  803717:	09 de                	or     %ebx,%esi
  803719:	89 f0                	mov    %esi,%eax
  80371b:	f7 74 24 08          	divl   0x8(%esp)
  80371f:	89 d6                	mov    %edx,%esi
  803721:	89 c3                	mov    %eax,%ebx
  803723:	f7 64 24 0c          	mull   0xc(%esp)
  803727:	39 d6                	cmp    %edx,%esi
  803729:	72 0c                	jb     803737 <__udivdi3+0xb7>
  80372b:	89 f9                	mov    %edi,%ecx
  80372d:	d3 e5                	shl    %cl,%ebp
  80372f:	39 c5                	cmp    %eax,%ebp
  803731:	73 5d                	jae    803790 <__udivdi3+0x110>
  803733:	39 d6                	cmp    %edx,%esi
  803735:	75 59                	jne    803790 <__udivdi3+0x110>
  803737:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80373a:	31 ff                	xor    %edi,%edi
  80373c:	89 fa                	mov    %edi,%edx
  80373e:	83 c4 1c             	add    $0x1c,%esp
  803741:	5b                   	pop    %ebx
  803742:	5e                   	pop    %esi
  803743:	5f                   	pop    %edi
  803744:	5d                   	pop    %ebp
  803745:	c3                   	ret    
  803746:	8d 76 00             	lea    0x0(%esi),%esi
  803749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  803750:	31 ff                	xor    %edi,%edi
  803752:	31 c0                	xor    %eax,%eax
  803754:	89 fa                	mov    %edi,%edx
  803756:	83 c4 1c             	add    $0x1c,%esp
  803759:	5b                   	pop    %ebx
  80375a:	5e                   	pop    %esi
  80375b:	5f                   	pop    %edi
  80375c:	5d                   	pop    %ebp
  80375d:	c3                   	ret    
  80375e:	66 90                	xchg   %ax,%ax
  803760:	31 ff                	xor    %edi,%edi
  803762:	89 e8                	mov    %ebp,%eax
  803764:	89 f2                	mov    %esi,%edx
  803766:	f7 f3                	div    %ebx
  803768:	89 fa                	mov    %edi,%edx
  80376a:	83 c4 1c             	add    $0x1c,%esp
  80376d:	5b                   	pop    %ebx
  80376e:	5e                   	pop    %esi
  80376f:	5f                   	pop    %edi
  803770:	5d                   	pop    %ebp
  803771:	c3                   	ret    
  803772:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  803778:	39 f2                	cmp    %esi,%edx
  80377a:	72 06                	jb     803782 <__udivdi3+0x102>
  80377c:	31 c0                	xor    %eax,%eax
  80377e:	39 eb                	cmp    %ebp,%ebx
  803780:	77 d2                	ja     803754 <__udivdi3+0xd4>
  803782:	b8 01 00 00 00       	mov    $0x1,%eax
  803787:	eb cb                	jmp    803754 <__udivdi3+0xd4>
  803789:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803790:	89 d8                	mov    %ebx,%eax
  803792:	31 ff                	xor    %edi,%edi
  803794:	eb be                	jmp    803754 <__udivdi3+0xd4>
  803796:	66 90                	xchg   %ax,%ax
  803798:	66 90                	xchg   %ax,%ax
  80379a:	66 90                	xchg   %ax,%ax
  80379c:	66 90                	xchg   %ax,%ax
  80379e:	66 90                	xchg   %ax,%ax

008037a0 <__umoddi3>:
  8037a0:	55                   	push   %ebp
  8037a1:	57                   	push   %edi
  8037a2:	56                   	push   %esi
  8037a3:	53                   	push   %ebx
  8037a4:	83 ec 1c             	sub    $0x1c,%esp
  8037a7:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  8037ab:	8b 74 24 30          	mov    0x30(%esp),%esi
  8037af:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8037b3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8037b7:	85 ed                	test   %ebp,%ebp
  8037b9:	89 f0                	mov    %esi,%eax
  8037bb:	89 da                	mov    %ebx,%edx
  8037bd:	75 19                	jne    8037d8 <__umoddi3+0x38>
  8037bf:	39 df                	cmp    %ebx,%edi
  8037c1:	0f 86 b1 00 00 00    	jbe    803878 <__umoddi3+0xd8>
  8037c7:	f7 f7                	div    %edi
  8037c9:	89 d0                	mov    %edx,%eax
  8037cb:	31 d2                	xor    %edx,%edx
  8037cd:	83 c4 1c             	add    $0x1c,%esp
  8037d0:	5b                   	pop    %ebx
  8037d1:	5e                   	pop    %esi
  8037d2:	5f                   	pop    %edi
  8037d3:	5d                   	pop    %ebp
  8037d4:	c3                   	ret    
  8037d5:	8d 76 00             	lea    0x0(%esi),%esi
  8037d8:	39 dd                	cmp    %ebx,%ebp
  8037da:	77 f1                	ja     8037cd <__umoddi3+0x2d>
  8037dc:	0f bd cd             	bsr    %ebp,%ecx
  8037df:	83 f1 1f             	xor    $0x1f,%ecx
  8037e2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8037e6:	0f 84 b4 00 00 00    	je     8038a0 <__umoddi3+0x100>
  8037ec:	b8 20 00 00 00       	mov    $0x20,%eax
  8037f1:	89 c2                	mov    %eax,%edx
  8037f3:	8b 44 24 04          	mov    0x4(%esp),%eax
  8037f7:	29 c2                	sub    %eax,%edx
  8037f9:	89 c1                	mov    %eax,%ecx
  8037fb:	89 f8                	mov    %edi,%eax
  8037fd:	d3 e5                	shl    %cl,%ebp
  8037ff:	89 d1                	mov    %edx,%ecx
  803801:	89 54 24 0c          	mov    %edx,0xc(%esp)
  803805:	d3 e8                	shr    %cl,%eax
  803807:	09 c5                	or     %eax,%ebp
  803809:	8b 44 24 04          	mov    0x4(%esp),%eax
  80380d:	89 c1                	mov    %eax,%ecx
  80380f:	d3 e7                	shl    %cl,%edi
  803811:	89 d1                	mov    %edx,%ecx
  803813:	89 7c 24 08          	mov    %edi,0x8(%esp)
  803817:	89 df                	mov    %ebx,%edi
  803819:	d3 ef                	shr    %cl,%edi
  80381b:	89 c1                	mov    %eax,%ecx
  80381d:	89 f0                	mov    %esi,%eax
  80381f:	d3 e3                	shl    %cl,%ebx
  803821:	89 d1                	mov    %edx,%ecx
  803823:	89 fa                	mov    %edi,%edx
  803825:	d3 e8                	shr    %cl,%eax
  803827:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80382c:	09 d8                	or     %ebx,%eax
  80382e:	f7 f5                	div    %ebp
  803830:	d3 e6                	shl    %cl,%esi
  803832:	89 d1                	mov    %edx,%ecx
  803834:	f7 64 24 08          	mull   0x8(%esp)
  803838:	39 d1                	cmp    %edx,%ecx
  80383a:	89 c3                	mov    %eax,%ebx
  80383c:	89 d7                	mov    %edx,%edi
  80383e:	72 06                	jb     803846 <__umoddi3+0xa6>
  803840:	75 0e                	jne    803850 <__umoddi3+0xb0>
  803842:	39 c6                	cmp    %eax,%esi
  803844:	73 0a                	jae    803850 <__umoddi3+0xb0>
  803846:	2b 44 24 08          	sub    0x8(%esp),%eax
  80384a:	19 ea                	sbb    %ebp,%edx
  80384c:	89 d7                	mov    %edx,%edi
  80384e:	89 c3                	mov    %eax,%ebx
  803850:	89 ca                	mov    %ecx,%edx
  803852:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  803857:	29 de                	sub    %ebx,%esi
  803859:	19 fa                	sbb    %edi,%edx
  80385b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  80385f:	89 d0                	mov    %edx,%eax
  803861:	d3 e0                	shl    %cl,%eax
  803863:	89 d9                	mov    %ebx,%ecx
  803865:	d3 ee                	shr    %cl,%esi
  803867:	d3 ea                	shr    %cl,%edx
  803869:	09 f0                	or     %esi,%eax
  80386b:	83 c4 1c             	add    $0x1c,%esp
  80386e:	5b                   	pop    %ebx
  80386f:	5e                   	pop    %esi
  803870:	5f                   	pop    %edi
  803871:	5d                   	pop    %ebp
  803872:	c3                   	ret    
  803873:	90                   	nop
  803874:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803878:	85 ff                	test   %edi,%edi
  80387a:	89 f9                	mov    %edi,%ecx
  80387c:	75 0b                	jne    803889 <__umoddi3+0xe9>
  80387e:	b8 01 00 00 00       	mov    $0x1,%eax
  803883:	31 d2                	xor    %edx,%edx
  803885:	f7 f7                	div    %edi
  803887:	89 c1                	mov    %eax,%ecx
  803889:	89 d8                	mov    %ebx,%eax
  80388b:	31 d2                	xor    %edx,%edx
  80388d:	f7 f1                	div    %ecx
  80388f:	89 f0                	mov    %esi,%eax
  803891:	f7 f1                	div    %ecx
  803893:	e9 31 ff ff ff       	jmp    8037c9 <__umoddi3+0x29>
  803898:	90                   	nop
  803899:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8038a0:	39 dd                	cmp    %ebx,%ebp
  8038a2:	72 08                	jb     8038ac <__umoddi3+0x10c>
  8038a4:	39 f7                	cmp    %esi,%edi
  8038a6:	0f 87 21 ff ff ff    	ja     8037cd <__umoddi3+0x2d>
  8038ac:	89 da                	mov    %ebx,%edx
  8038ae:	89 f0                	mov    %esi,%eax
  8038b0:	29 f8                	sub    %edi,%eax
  8038b2:	19 ea                	sbb    %ebp,%edx
  8038b4:	e9 14 ff ff ff       	jmp    8037cd <__umoddi3+0x2d>
