
_test:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
    while (wait() != -1)
    {
    }
}
int main(int argc, char *argv[])
{
   0:	f3 0f 1e fb          	endbr32 
   4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   8:	83 e4 f0             	and    $0xfffffff0,%esp
   b:	ff 71 fc             	pushl  -0x4(%ecx)
    if(argc<3)
   e:	83 39 02             	cmpl   $0x2,(%ecx)
{
  11:	55                   	push   %ebp
  12:	89 e5                	mov    %esp,%ebp
  14:	53                   	push   %ebx
  15:	51                   	push   %ecx
  16:	8b 59 04             	mov    0x4(%ecx),%ebx
    if(argc<3)
  19:	7f 13                	jg     2e <main+0x2e>
    {
        printf(1,"invalid arguments");
  1b:	50                   	push   %eax
  1c:	50                   	push   %eax
  1d:	68 2e 0d 00 00       	push   $0xd2e
  22:	6a 01                	push   $0x1
  24:	e8 67 09 00 00       	call   990 <printf>
        exit();
  29:	e8 f5 07 00 00       	call   823 <exit>
    }
    switch (atoi(argv[1]))
  2e:	83 ec 0c             	sub    $0xc,%esp
  31:	ff 73 04             	pushl  0x4(%ebx)
  34:	e8 77 07 00 00       	call   7b0 <atoi>
  39:	83 c4 10             	add    $0x10,%esp
  3c:	83 e8 01             	sub    $0x1,%eax
  3f:	83 f8 05             	cmp    $0x5,%eax
  42:	77 1e                	ja     62 <main+0x62>
  44:	3e ff 24 85 40 0d 00 	notrack jmp *0xd40(,%eax,4)
  4b:	00 
        break;
    case 5:
        randomcpuandio(atoi(argv[2]));
        break;
    case 6:
        latefcfs(atoi(argv[2]));
  4c:	83 ec 0c             	sub    $0xc,%esp
  4f:	ff 73 08             	pushl  0x8(%ebx)
  52:	e8 59 07 00 00       	call   7b0 <atoi>
  57:	89 04 24             	mov    %eax,(%esp)
  5a:	e8 61 04 00 00       	call   4c0 <latefcfs>
        break;
  5f:	83 c4 10             	add    $0x10,%esp
    // }
    // for (j = 0; j < number_of_processes + 5; j++)
    // {
    //     wait();
    // }
    exit();
  62:	e8 bc 07 00 00       	call   823 <exit>
        randomcpuandio(atoi(argv[2]));
  67:	83 ec 0c             	sub    $0xc,%esp
  6a:	ff 73 08             	pushl  0x8(%ebx)
  6d:	e8 3e 07 00 00       	call   7b0 <atoi>
  72:	89 04 24             	mov    %eax,(%esp)
  75:	e8 86 03 00 00       	call   400 <randomcpuandio>
        break;
  7a:	83 c4 10             	add    $0x10,%esp
  7d:	eb e3                	jmp    62 <main+0x62>
        benchmark(atoi(argv[2]));
  7f:	83 ec 0c             	sub    $0xc,%esp
  82:	ff 73 08             	pushl  0x8(%ebx)
  85:	e8 26 07 00 00       	call   7b0 <atoi>
  8a:	89 04 24             	mov    %eax,(%esp)
  8d:	e8 6e 00 00 00       	call   100 <benchmark>
        cpubound(atoi(argv[2]));
  92:	83 ec 0c             	sub    $0xc,%esp
  95:	ff 73 08             	pushl  0x8(%ebx)
  98:	e8 13 07 00 00       	call   7b0 <atoi>
  9d:	89 04 24             	mov    %eax,(%esp)
  a0:	e8 7b 01 00 00       	call   220 <cpubound>
        break;
  a5:	83 c4 10             	add    $0x10,%esp
  a8:	eb b8                	jmp    62 <main+0x62>
        iobound(atoi(argv[2]));
  aa:	83 ec 0c             	sub    $0xc,%esp
  ad:	ff 73 08             	pushl  0x8(%ebx)
  b0:	e8 fb 06 00 00       	call   7b0 <atoi>
  b5:	89 04 24             	mov    %eax,(%esp)
  b8:	e8 e3 01 00 00       	call   2a0 <iobound>
        break;
  bd:	83 c4 10             	add    $0x10,%esp
  c0:	eb a0                	jmp    62 <main+0x62>
        cpuandio(atoi(argv[2]));
  c2:	83 ec 0c             	sub    $0xc,%esp
  c5:	ff 73 08             	pushl  0x8(%ebx)
  c8:	e8 e3 06 00 00       	call   7b0 <atoi>
  cd:	89 04 24             	mov    %eax,(%esp)
  d0:	e8 6b 02 00 00       	call   340 <cpuandio>
        break;
  d5:	83 c4 10             	add    $0x10,%esp
  d8:	eb 88                	jmp    62 <main+0x62>
  da:	66 90                	xchg   %ax,%ax
  dc:	66 90                	xchg   %ax,%ax
  de:	66 90                	xchg   %ax,%ax

000000e0 <cpubound.part.0>:
void cpubound(int n)
  e0:	55                   	push   %ebp
  e1:	89 e5                	mov    %esp,%ebp
  e3:	83 ec 08             	sub    $0x8,%esp
  e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ed:	8d 76 00             	lea    0x0(%esi),%esi
    while (wait()!=-1)
  f0:	e8 36 07 00 00       	call   82b <wait>
  f5:	83 f8 ff             	cmp    $0xffffffff,%eax
  f8:	75 f6                	jne    f0 <cpubound.part.0+0x10>
}
  fa:	c9                   	leave  
  fb:	c3                   	ret    
  fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000100 <benchmark>:
{
 100:	f3 0f 1e fb          	endbr32 
 104:	55                   	push   %ebp
 105:	89 e5                	mov    %esp,%ebp
 107:	57                   	push   %edi
 108:	56                   	push   %esi
 109:	53                   	push   %ebx
 10a:	83 ec 1c             	sub    $0x1c,%esp
 10d:	8b 75 08             	mov    0x8(%ebp),%esi
    for (j = 0; j < number_of_processes; j++)
 110:	85 f6                	test   %esi,%esi
 112:	0f 8e f3 00 00 00    	jle    20b <benchmark+0x10b>
 118:	31 db                	xor    %ebx,%ebx
            set_priority(100 - (20 + j), pid); // will only matter for PBS, comment it out if not implemented yet (better priorty for more IO intensive jobs)
 11a:	bf 50 00 00 00       	mov    $0x50,%edi
 11f:	eb 23                	jmp    144 <benchmark+0x44>
 121:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        if (pid == 0)
 128:	74 57                	je     181 <benchmark+0x81>
            set_priority(100 - (20 + j), pid); // will only matter for PBS, comment it out if not implemented yet (better priorty for more IO intensive jobs)
 12a:	83 ec 08             	sub    $0x8,%esp
 12d:	50                   	push   %eax
 12e:	89 f8                	mov    %edi,%eax
 130:	29 d8                	sub    %ebx,%eax
 132:	50                   	push   %eax
 133:	e8 93 07 00 00       	call   8cb <set_priority>
    for (j = 0; j < number_of_processes; j++)
 138:	8d 43 01             	lea    0x1(%ebx),%eax
            set_priority(100 - (20 + j), pid); // will only matter for PBS, comment it out if not implemented yet (better priorty for more IO intensive jobs)
 13b:	83 c4 10             	add    $0x10,%esp
    for (j = 0; j < number_of_processes; j++)
 13e:	39 c6                	cmp    %eax,%esi
 140:	74 24                	je     166 <benchmark+0x66>
 142:	89 c3                	mov    %eax,%ebx
        int pid = fork();
 144:	e8 d2 06 00 00       	call   81b <fork>
        if (pid < 0)
 149:	85 c0                	test   %eax,%eax
 14b:	79 db                	jns    128 <benchmark+0x28>
            printf(1, "Fork failed\n");
 14d:	83 ec 08             	sub    $0x8,%esp
 150:	68 f8 0c 00 00       	push   $0xcf8
 155:	6a 01                	push   $0x1
 157:	e8 34 08 00 00       	call   990 <printf>
    for (j = 0; j < number_of_processes; j++)
 15c:	8d 43 01             	lea    0x1(%ebx),%eax
            continue;
 15f:	83 c4 10             	add    $0x10,%esp
    for (j = 0; j < number_of_processes; j++)
 162:	39 c6                	cmp    %eax,%esi
 164:	75 dc                	jne    142 <benchmark+0x42>
    for (j = 0; j < number_of_processes + 5; j++)
 166:	83 c3 05             	add    $0x5,%ebx
 169:	31 f6                	xor    %esi,%esi
 16b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 16f:	90                   	nop
        wait();
 170:	e8 b6 06 00 00       	call   82b <wait>
    for (j = 0; j < number_of_processes + 5; j++)
 175:	83 c6 01             	add    $0x1,%esi
 178:	39 f3                	cmp    %esi,%ebx
 17a:	7d f4                	jge    170 <benchmark+0x70>
    exit();
 17c:	e8 a2 06 00 00       	call   823 <exit>
            for (volatile int k = 0; k < number_of_processes; k++)
 181:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
 188:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 18b:	39 c6                	cmp    %eax,%esi
 18d:	7f 29                	jg     1b8 <benchmark+0xb8>
 18f:	eb 62                	jmp    1f3 <benchmark+0xf3>
 191:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
                    sleep(200); //io time
 198:	83 ec 0c             	sub    $0xc,%esp
 19b:	68 c8 00 00 00       	push   $0xc8
 1a0:	e8 0e 07 00 00       	call   8b3 <sleep>
 1a5:	83 c4 10             	add    $0x10,%esp
            for (volatile int k = 0; k < number_of_processes; k++)
 1a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 1ab:	83 c0 01             	add    $0x1,%eax
 1ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 1b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 1b4:	39 f0                	cmp    %esi,%eax
 1b6:	7d 3b                	jge    1f3 <benchmark+0xf3>
                if (k <= j)
 1b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 1bb:	39 d8                	cmp    %ebx,%eax
 1bd:	7e d9                	jle    198 <benchmark+0x98>
                    for (i = 0; i < 100000000; i++)
 1bf:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
 1c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
 1c9:	3d ff e0 f5 05       	cmp    $0x5f5e0ff,%eax
 1ce:	7f d8                	jg     1a8 <benchmark+0xa8>
 1d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
 1d3:	83 c0 01             	add    $0x1,%eax
 1d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
 1d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
 1dc:	3d ff e0 f5 05       	cmp    $0x5f5e0ff,%eax
 1e1:	7e ed                	jle    1d0 <benchmark+0xd0>
            for (volatile int k = 0; k < number_of_processes; k++)
 1e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 1e6:	83 c0 01             	add    $0x1,%eax
 1e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 1ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 1ef:	39 f0                	cmp    %esi,%eax
 1f1:	7c c5                	jl     1b8 <benchmark+0xb8>
            printf(1, "Process: %d Finished %d pid\n", j,getpid());
 1f3:	e8 ab 06 00 00       	call   8a3 <getpid>
 1f8:	50                   	push   %eax
 1f9:	53                   	push   %ebx
 1fa:	68 05 0d 00 00       	push   $0xd05
 1ff:	6a 01                	push   $0x1
 201:	e8 8a 07 00 00       	call   990 <printf>
            exit();
 206:	e8 18 06 00 00       	call   823 <exit>
    for (j = 0; j < number_of_processes + 5; j++)
 20b:	83 c6 04             	add    $0x4,%esi
 20e:	89 f3                	mov    %esi,%ebx
 210:	0f 88 66 ff ff ff    	js     17c <benchmark+0x7c>
 216:	e9 4e ff ff ff       	jmp    169 <benchmark+0x69>
 21b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 21f:	90                   	nop

00000220 <cpubound>:
{
 220:	f3 0f 1e fb          	endbr32 
 224:	55                   	push   %ebp
 225:	89 e5                	mov    %esp,%ebp
 227:	56                   	push   %esi
 228:	8b 75 08             	mov    0x8(%ebp),%esi
 22b:	53                   	push   %ebx
    for(int i=0;i<n;i++)
 22c:	85 f6                	test   %esi,%esi
 22e:	7e 33                	jle    263 <cpubound+0x43>
 230:	31 db                	xor    %ebx,%ebx
 232:	eb 0d                	jmp    241 <cpubound+0x21>
 234:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if(pid==0)
 238:	74 34                	je     26e <cpubound+0x4e>
    for(int i=0;i<n;i++)
 23a:	83 c3 01             	add    $0x1,%ebx
 23d:	39 de                	cmp    %ebx,%esi
 23f:	74 22                	je     263 <cpubound+0x43>
        if((pid=fork()) <0)
 241:	e8 d5 05 00 00       	call   81b <fork>
 246:	85 c0                	test   %eax,%eax
 248:	79 ee                	jns    238 <cpubound+0x18>
            printf(1,"fork failed");
 24a:	83 ec 08             	sub    $0x8,%esp
    for(int i=0;i<n;i++)
 24d:	83 c3 01             	add    $0x1,%ebx
            printf(1,"fork failed");
 250:	68 22 0d 00 00       	push   $0xd22
 255:	6a 01                	push   $0x1
 257:	e8 34 07 00 00       	call   990 <printf>
 25c:	83 c4 10             	add    $0x10,%esp
    for(int i=0;i<n;i++)
 25f:	39 de                	cmp    %ebx,%esi
 261:	75 de                	jne    241 <cpubound+0x21>
}
 263:	8d 65 f8             	lea    -0x8(%ebp),%esp
 266:	5b                   	pop    %ebx
 267:	5e                   	pop    %esi
 268:	5d                   	pop    %ebp
 269:	e9 72 fe ff ff       	jmp    e0 <cpubound.part.0>
            for(double x=0;x<500000.0;x+=0.02)
 26e:	d9 ee                	fldz   
 270:	dd 05 58 0d 00 00    	fldl   0xd58
 276:	dc c1                	fadd   %st,%st(1)
 278:	d9 05 60 0d 00 00    	flds   0xd60
 27e:	df f2                	fcomip %st(2),%st
 280:	77 f4                	ja     276 <cpubound+0x56>
 282:	dd d8                	fstp   %st(0)
 284:	dd d8                	fstp   %st(0)
            printf(1, "Process: %d Finished %d pid\n", i, getpid());
 286:	e8 18 06 00 00       	call   8a3 <getpid>
 28b:	50                   	push   %eax
 28c:	53                   	push   %ebx
 28d:	68 05 0d 00 00       	push   $0xd05
 292:	6a 01                	push   $0x1
 294:	e8 f7 06 00 00       	call   990 <printf>
            exit();
 299:	e8 85 05 00 00       	call   823 <exit>
 29e:	66 90                	xchg   %ax,%ax

000002a0 <iobound>:
{
 2a0:	f3 0f 1e fb          	endbr32 
 2a4:	55                   	push   %ebp
 2a5:	89 e5                	mov    %esp,%ebp
 2a7:	57                   	push   %edi
 2a8:	56                   	push   %esi
 2a9:	53                   	push   %ebx
 2aa:	83 ec 0c             	sub    $0xc,%esp
 2ad:	8b 75 08             	mov    0x8(%ebp),%esi
    for (int i = 0; i < n; i++)
 2b0:	85 f6                	test   %esi,%esi
 2b2:	7e 39                	jle    2ed <iobound+0x4d>
 2b4:	31 ff                	xor    %edi,%edi
 2b6:	eb 11                	jmp    2c9 <iobound+0x29>
 2b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2bf:	90                   	nop
        if (pid == 0)
 2c0:	74 37                	je     2f9 <iobound+0x59>
    for (int i = 0; i < n; i++)
 2c2:	83 c7 01             	add    $0x1,%edi
 2c5:	39 fe                	cmp    %edi,%esi
 2c7:	74 24                	je     2ed <iobound+0x4d>
        if ((pid = fork()) < 0)
 2c9:	e8 4d 05 00 00       	call   81b <fork>
 2ce:	89 c3                	mov    %eax,%ebx
 2d0:	85 c0                	test   %eax,%eax
 2d2:	79 ec                	jns    2c0 <iobound+0x20>
            printf(1, "fork failed");
 2d4:	83 ec 08             	sub    $0x8,%esp
    for (int i = 0; i < n; i++)
 2d7:	83 c7 01             	add    $0x1,%edi
            printf(1, "fork failed");
 2da:	68 22 0d 00 00       	push   $0xd22
 2df:	6a 01                	push   $0x1
 2e1:	e8 aa 06 00 00       	call   990 <printf>
 2e6:	83 c4 10             	add    $0x10,%esp
    for (int i = 0; i < n; i++)
 2e9:	39 fe                	cmp    %edi,%esi
 2eb:	75 dc                	jne    2c9 <iobound+0x29>
}
 2ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2f0:	5b                   	pop    %ebx
 2f1:	5e                   	pop    %esi
 2f2:	5f                   	pop    %edi
 2f3:	5d                   	pop    %ebp
 2f4:	e9 e7 fd ff ff       	jmp    e0 <cpubound.part.0>
            for(int j=0;j<i;j++)
 2f9:	85 ff                	test   %edi,%edi
 2fb:	74 1c                	je     319 <iobound+0x79>
                sleep(10*(n-i)+1);
 2fd:	29 fe                	sub    %edi,%esi
 2ff:	8d 04 b6             	lea    (%esi,%esi,4),%eax
 302:	8d 74 00 01          	lea    0x1(%eax,%eax,1),%esi
 306:	83 ec 0c             	sub    $0xc,%esp
            for(int j=0;j<i;j++)
 309:	83 c3 01             	add    $0x1,%ebx
                sleep(10*(n-i)+1);
 30c:	56                   	push   %esi
 30d:	e8 a1 05 00 00       	call   8b3 <sleep>
            for(int j=0;j<i;j++)
 312:	83 c4 10             	add    $0x10,%esp
 315:	39 fb                	cmp    %edi,%ebx
 317:	75 ed                	jne    306 <iobound+0x66>
            printf(1, "Process: %d Finished %d pid\n", i, getpid());
 319:	e8 85 05 00 00       	call   8a3 <getpid>
 31e:	50                   	push   %eax
 31f:	57                   	push   %edi
 320:	68 05 0d 00 00       	push   $0xd05
 325:	6a 01                	push   $0x1
 327:	e8 64 06 00 00       	call   990 <printf>
            exit();
 32c:	e8 f2 04 00 00       	call   823 <exit>
 331:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 338:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 33f:	90                   	nop

00000340 <cpuandio>:
{
 340:	f3 0f 1e fb          	endbr32 
 344:	55                   	push   %ebp
 345:	89 e5                	mov    %esp,%ebp
 347:	57                   	push   %edi
 348:	56                   	push   %esi
 349:	53                   	push   %ebx
 34a:	83 ec 0c             	sub    $0xc,%esp
 34d:	8b 75 08             	mov    0x8(%ebp),%esi
    for (int i = 0; i < n; i++)
 350:	85 f6                	test   %esi,%esi
 352:	7e 3c                	jle    390 <cpuandio+0x50>
 354:	31 ff                	xor    %edi,%edi
 356:	eb 11                	jmp    369 <cpuandio+0x29>
 358:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 35f:	90                   	nop
        if (pid == 0)
 360:	74 40                	je     3a2 <cpuandio+0x62>
    for (int i = 0; i < n; i++)
 362:	83 c7 01             	add    $0x1,%edi
 365:	39 fe                	cmp    %edi,%esi
 367:	74 27                	je     390 <cpuandio+0x50>
        if ((pid = fork()) < 0)
 369:	e8 ad 04 00 00       	call   81b <fork>
 36e:	89 c3                	mov    %eax,%ebx
 370:	85 c0                	test   %eax,%eax
 372:	79 ec                	jns    360 <cpuandio+0x20>
            printf(1, "fork failed");
 374:	83 ec 08             	sub    $0x8,%esp
    for (int i = 0; i < n; i++)
 377:	83 c7 01             	add    $0x1,%edi
            printf(1, "fork failed");
 37a:	68 22 0d 00 00       	push   $0xd22
 37f:	6a 01                	push   $0x1
 381:	e8 0a 06 00 00       	call   990 <printf>
 386:	83 c4 10             	add    $0x10,%esp
    for (int i = 0; i < n; i++)
 389:	39 fe                	cmp    %edi,%esi
 38b:	75 dc                	jne    369 <cpuandio+0x29>
 38d:	8d 76 00             	lea    0x0(%esi),%esi
    while (wait() != -1)
 390:	e8 96 04 00 00       	call   82b <wait>
 395:	83 f8 ff             	cmp    $0xffffffff,%eax
 398:	75 f6                	jne    390 <cpuandio+0x50>
}
 39a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 39d:	5b                   	pop    %ebx
 39e:	5e                   	pop    %esi
 39f:	5f                   	pop    %edi
 3a0:	5d                   	pop    %ebp
 3a1:	c3                   	ret    
            if(getpid()%2==0)
 3a2:	e8 fc 04 00 00       	call   8a3 <getpid>
 3a7:	a8 01                	test   $0x1,%al
 3a9:	75 38                	jne    3e3 <cpuandio+0xa3>
            for (int j = 0; j < i; j++)
 3ab:	85 ff                	test   %edi,%edi
 3ad:	74 1c                	je     3cb <cpuandio+0x8b>
                sleep(8 * (n - i+1) + 1);
 3af:	29 fe                	sub    %edi,%esi
 3b1:	8d 34 f5 09 00 00 00 	lea    0x9(,%esi,8),%esi
 3b8:	83 ec 0c             	sub    $0xc,%esp
            for (int j = 0; j < i; j++)
 3bb:	83 c3 01             	add    $0x1,%ebx
                sleep(8 * (n - i+1) + 1);
 3be:	56                   	push   %esi
 3bf:	e8 ef 04 00 00       	call   8b3 <sleep>
            for (int j = 0; j < i; j++)
 3c4:	83 c4 10             	add    $0x10,%esp
 3c7:	39 fb                	cmp    %edi,%ebx
 3c9:	75 ed                	jne    3b8 <cpuandio+0x78>
            printf(1, "Process: %d Finished %d pid\n", i, getpid());
 3cb:	e8 d3 04 00 00       	call   8a3 <getpid>
 3d0:	50                   	push   %eax
 3d1:	57                   	push   %edi
 3d2:	68 05 0d 00 00       	push   $0xd05
 3d7:	6a 01                	push   $0x1
 3d9:	e8 b2 05 00 00       	call   990 <printf>
            exit();
 3de:	e8 40 04 00 00       	call   823 <exit>
                for (double x = 0; x < 500000.0; x += 0.02)
 3e3:	d9 ee                	fldz   
 3e5:	dc 05 58 0d 00 00    	faddl  0xd58
 3eb:	d9 05 60 0d 00 00    	flds   0xd60
 3f1:	df f1                	fcomip %st(1),%st
 3f3:	77 f0                	ja     3e5 <cpuandio+0xa5>
 3f5:	dd d8                	fstp   %st(0)
 3f7:	eb d2                	jmp    3cb <cpuandio+0x8b>
 3f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000400 <randomcpuandio>:
{
 400:	f3 0f 1e fb          	endbr32 
 404:	55                   	push   %ebp
 405:	89 e5                	mov    %esp,%ebp
 407:	57                   	push   %edi
 408:	56                   	push   %esi
 409:	53                   	push   %ebx
 40a:	83 ec 1c             	sub    $0x1c,%esp
 40d:	8b 75 08             	mov    0x8(%ebp),%esi
    for (int i = 0; i < n; i++)
 410:	85 f6                	test   %esi,%esi
 412:	7e 39                	jle    44d <randomcpuandio+0x4d>
 414:	31 ff                	xor    %edi,%edi
 416:	eb 11                	jmp    429 <randomcpuandio+0x29>
 418:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 41f:	90                   	nop
        if (pid == 0)
 420:	74 37                	je     459 <randomcpuandio+0x59>
    for (int i = 0; i < n; i++)
 422:	83 c7 01             	add    $0x1,%edi
 425:	39 fe                	cmp    %edi,%esi
 427:	74 24                	je     44d <randomcpuandio+0x4d>
        if ((pid = fork()) < 0)
 429:	e8 ed 03 00 00       	call   81b <fork>
 42e:	89 c3                	mov    %eax,%ebx
 430:	85 c0                	test   %eax,%eax
 432:	79 ec                	jns    420 <randomcpuandio+0x20>
            printf(1, "fork failed");
 434:	83 ec 08             	sub    $0x8,%esp
    for (int i = 0; i < n; i++)
 437:	83 c7 01             	add    $0x1,%edi
            printf(1, "fork failed");
 43a:	68 22 0d 00 00       	push   $0xd22
 43f:	6a 01                	push   $0x1
 441:	e8 4a 05 00 00       	call   990 <printf>
 446:	83 c4 10             	add    $0x10,%esp
    for (int i = 0; i < n; i++)
 449:	39 fe                	cmp    %edi,%esi
 44b:	75 dc                	jne    429 <randomcpuandio+0x29>
}
 44d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 450:	5b                   	pop    %ebx
 451:	5e                   	pop    %esi
 452:	5f                   	pop    %edi
 453:	5d                   	pop    %ebp
 454:	e9 87 fc ff ff       	jmp    e0 <cpubound.part.0>
            for (double x = 0; x < 500000.0; x += 0.02,l++)
 459:	d9 ee                	fldz   
                    if(l%100000==0)
 45b:	be c5 5a 7c 0a       	mov    $0xa7c5ac5,%esi
 460:	eb 13                	jmp    475 <randomcpuandio+0x75>
            for (double x = 0; x < 500000.0; x += 0.02,l++)
 462:	dc 05 58 0d 00 00    	faddl  0xd58
 468:	83 c3 01             	add    $0x1,%ebx
 46b:	d9 05 60 0d 00 00    	flds   0xd60
 471:	df f1                	fcomip %st(1),%st
 473:	76 31                	jbe    4a6 <randomcpuandio+0xa6>
                    if(l%100000==0)
 475:	89 da                	mov    %ebx,%edx
 477:	89 d9                	mov    %ebx,%ecx
 479:	c1 ea 05             	shr    $0x5,%edx
 47c:	89 d0                	mov    %edx,%eax
 47e:	f7 e6                	mul    %esi
 480:	c1 ea 07             	shr    $0x7,%edx
 483:	69 c2 a0 86 01 00    	imul   $0x186a0,%edx,%eax
 489:	29 c1                	sub    %eax,%ecx
 48b:	89 c8                	mov    %ecx,%eax
 48d:	09 f8                	or     %edi,%eax
 48f:	75 d1                	jne    462 <randomcpuandio+0x62>
                        sleep(1);
 491:	83 ec 0c             	sub    $0xc,%esp
 494:	dd 5d e0             	fstpl  -0x20(%ebp)
 497:	6a 01                	push   $0x1
 499:	e8 15 04 00 00       	call   8b3 <sleep>
 49e:	83 c4 10             	add    $0x10,%esp
 4a1:	dd 45 e0             	fldl   -0x20(%ebp)
 4a4:	eb bc                	jmp    462 <randomcpuandio+0x62>
 4a6:	dd d8                	fstp   %st(0)
            printf(1, "Process: %d Finished %d pid\n", i, getpid());
 4a8:	e8 f6 03 00 00       	call   8a3 <getpid>
 4ad:	50                   	push   %eax
 4ae:	57                   	push   %edi
 4af:	68 05 0d 00 00       	push   $0xd05
 4b4:	6a 01                	push   $0x1
 4b6:	e8 d5 04 00 00       	call   990 <printf>
            exit();
 4bb:	e8 63 03 00 00       	call   823 <exit>

000004c0 <latefcfs>:
{
 4c0:	f3 0f 1e fb          	endbr32 
 4c4:	55                   	push   %ebp
 4c5:	89 e5                	mov    %esp,%ebp
 4c7:	57                   	push   %edi
 4c8:	56                   	push   %esi
 4c9:	53                   	push   %ebx
 4ca:	83 ec 1c             	sub    $0x1c,%esp
 4cd:	8b 75 08             	mov    0x8(%ebp),%esi
            if(i<n/2)
 4d0:	89 f7                	mov    %esi,%edi
 4d2:	d1 ff                	sar    %edi
    for (int i = 0; i < n; i++)
 4d4:	85 f6                	test   %esi,%esi
 4d6:	7e 58                	jle    530 <latefcfs+0x70>
 4d8:	31 db                	xor    %ebx,%ebx
 4da:	eb 0b                	jmp    4e7 <latefcfs+0x27>
 4dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 4e0:	83 c3 01             	add    $0x1,%ebx
 4e3:	39 de                	cmp    %ebx,%esi
 4e5:	74 49                	je     530 <latefcfs+0x70>
        if ((pid = fork()) < 0)
 4e7:	e8 2f 03 00 00       	call   81b <fork>
 4ec:	85 c0                	test   %eax,%eax
 4ee:	78 58                	js     548 <latefcfs+0x88>
        if (pid == 0)
 4f0:	74 70                	je     562 <latefcfs+0xa2>
            if(i<n/2)
 4f2:	39 df                	cmp    %ebx,%edi
 4f4:	7e ea                	jle    4e0 <latefcfs+0x20>
                set_priority( ( 60-(20*i)%50 ),pid);
 4f6:	83 ec 08             	sub    $0x8,%esp
 4f9:	8d 0c 9b             	lea    (%ebx,%ebx,4),%ecx
    for (int i = 0; i < n; i++)
 4fc:	83 c3 01             	add    $0x1,%ebx
                set_priority( ( 60-(20*i)%50 ),pid);
 4ff:	50                   	push   %eax
 500:	c1 e1 02             	shl    $0x2,%ecx
 503:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
 508:	f7 e1                	mul    %ecx
 50a:	b8 3c 00 00 00       	mov    $0x3c,%eax
 50f:	c1 ea 04             	shr    $0x4,%edx
 512:	6b d2 32             	imul   $0x32,%edx,%edx
 515:	29 d1                	sub    %edx,%ecx
 517:	29 c8                	sub    %ecx,%eax
 519:	50                   	push   %eax
 51a:	e8 ac 03 00 00       	call   8cb <set_priority>
 51f:	83 c4 10             	add    $0x10,%esp
    for (int i = 0; i < n; i++)
 522:	39 de                	cmp    %ebx,%esi
 524:	75 c1                	jne    4e7 <latefcfs+0x27>
 526:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 52d:	8d 76 00             	lea    0x0(%esi),%esi
    while (wait() != -1)
 530:	e8 f6 02 00 00       	call   82b <wait>
 535:	83 f8 ff             	cmp    $0xffffffff,%eax
 538:	75 f6                	jne    530 <latefcfs+0x70>
}
 53a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 53d:	5b                   	pop    %ebx
 53e:	5e                   	pop    %esi
 53f:	5f                   	pop    %edi
 540:	5d                   	pop    %ebp
 541:	c3                   	ret    
 542:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            printf(1, "fork failed");
 548:	83 ec 08             	sub    $0x8,%esp
 54b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 54e:	68 22 0d 00 00       	push   $0xd22
 553:	6a 01                	push   $0x1
 555:	e8 36 04 00 00       	call   990 <printf>
        if (pid == 0)
 55a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
            printf(1, "fork failed");
 55d:	83 c4 10             	add    $0x10,%esp
 560:	eb 90                	jmp    4f2 <latefcfs+0x32>
            if ( i>n/2)
 562:	39 df                	cmp    %ebx,%edi
 564:	7d 36                	jge    59c <latefcfs+0xdc>
                    sleep(8 * (n - i+1) + 1);
 566:	29 de                	sub    %ebx,%esi
 568:	89 c7                	mov    %eax,%edi
 56a:	8d 34 f5 09 00 00 00 	lea    0x9(,%esi,8),%esi
 571:	83 ec 0c             	sub    $0xc,%esp
                for (int j = 0; j < i; j++)
 574:	83 c7 01             	add    $0x1,%edi
                    sleep(8 * (n - i+1) + 1);
 577:	56                   	push   %esi
 578:	e8 36 03 00 00       	call   8b3 <sleep>
                for (int j = 0; j < i; j++)
 57d:	83 c4 10             	add    $0x10,%esp
 580:	39 df                	cmp    %ebx,%edi
 582:	7c ed                	jl     571 <latefcfs+0xb1>
            printf(1, "Process: %d Finished %d pid\n", i, getpid());
 584:	e8 1a 03 00 00       	call   8a3 <getpid>
 589:	50                   	push   %eax
 58a:	53                   	push   %ebx
 58b:	68 05 0d 00 00       	push   $0xd05
 590:	6a 01                	push   $0x1
 592:	e8 f9 03 00 00       	call   990 <printf>
            exit();
 597:	e8 87 02 00 00       	call   823 <exit>
                for (double x = 0; x < 500000.0; x += 0.02)
 59c:	d9 ee                	fldz   
 59e:	dc 05 58 0d 00 00    	faddl  0xd58
 5a4:	d9 05 60 0d 00 00    	flds   0xd60
 5aa:	df f1                	fcomip %st(1),%st
 5ac:	77 f0                	ja     59e <latefcfs+0xde>
 5ae:	dd d8                	fstp   %st(0)
 5b0:	eb d2                	jmp    584 <latefcfs+0xc4>
 5b2:	66 90                	xchg   %ax,%ax
 5b4:	66 90                	xchg   %ax,%ax
 5b6:	66 90                	xchg   %ax,%ax
 5b8:	66 90                	xchg   %ax,%ax
 5ba:	66 90                	xchg   %ax,%ax
 5bc:	66 90                	xchg   %ax,%ax
 5be:	66 90                	xchg   %ax,%ax

000005c0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 5c0:	f3 0f 1e fb          	endbr32 
 5c4:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 5c5:	31 c0                	xor    %eax,%eax
{
 5c7:	89 e5                	mov    %esp,%ebp
 5c9:	53                   	push   %ebx
 5ca:	8b 4d 08             	mov    0x8(%ebp),%ecx
 5cd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while((*s++ = *t++) != 0)
 5d0:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 5d4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 5d7:	83 c0 01             	add    $0x1,%eax
 5da:	84 d2                	test   %dl,%dl
 5dc:	75 f2                	jne    5d0 <strcpy+0x10>
    ;
  return os;
}
 5de:	89 c8                	mov    %ecx,%eax
 5e0:	5b                   	pop    %ebx
 5e1:	5d                   	pop    %ebp
 5e2:	c3                   	ret    
 5e3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000005f0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 5f0:	f3 0f 1e fb          	endbr32 
 5f4:	55                   	push   %ebp
 5f5:	89 e5                	mov    %esp,%ebp
 5f7:	53                   	push   %ebx
 5f8:	8b 4d 08             	mov    0x8(%ebp),%ecx
 5fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 5fe:	0f b6 01             	movzbl (%ecx),%eax
 601:	0f b6 1a             	movzbl (%edx),%ebx
 604:	84 c0                	test   %al,%al
 606:	75 19                	jne    621 <strcmp+0x31>
 608:	eb 26                	jmp    630 <strcmp+0x40>
 60a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 610:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
 614:	83 c1 01             	add    $0x1,%ecx
 617:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 61a:	0f b6 1a             	movzbl (%edx),%ebx
 61d:	84 c0                	test   %al,%al
 61f:	74 0f                	je     630 <strcmp+0x40>
 621:	38 d8                	cmp    %bl,%al
 623:	74 eb                	je     610 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 625:	29 d8                	sub    %ebx,%eax
}
 627:	5b                   	pop    %ebx
 628:	5d                   	pop    %ebp
 629:	c3                   	ret    
 62a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 630:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 632:	29 d8                	sub    %ebx,%eax
}
 634:	5b                   	pop    %ebx
 635:	5d                   	pop    %ebp
 636:	c3                   	ret    
 637:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 63e:	66 90                	xchg   %ax,%ax

00000640 <strlen>:

uint
strlen(const char *s)
{
 640:	f3 0f 1e fb          	endbr32 
 644:	55                   	push   %ebp
 645:	89 e5                	mov    %esp,%ebp
 647:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 64a:	80 3a 00             	cmpb   $0x0,(%edx)
 64d:	74 21                	je     670 <strlen+0x30>
 64f:	31 c0                	xor    %eax,%eax
 651:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 658:	83 c0 01             	add    $0x1,%eax
 65b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 65f:	89 c1                	mov    %eax,%ecx
 661:	75 f5                	jne    658 <strlen+0x18>
    ;
  return n;
}
 663:	89 c8                	mov    %ecx,%eax
 665:	5d                   	pop    %ebp
 666:	c3                   	ret    
 667:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 66e:	66 90                	xchg   %ax,%ax
  for(n = 0; s[n]; n++)
 670:	31 c9                	xor    %ecx,%ecx
}
 672:	5d                   	pop    %ebp
 673:	89 c8                	mov    %ecx,%eax
 675:	c3                   	ret    
 676:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 67d:	8d 76 00             	lea    0x0(%esi),%esi

00000680 <memset>:

void*
memset(void *dst, int c, uint n)
{
 680:	f3 0f 1e fb          	endbr32 
 684:	55                   	push   %ebp
 685:	89 e5                	mov    %esp,%ebp
 687:	57                   	push   %edi
 688:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 68b:	8b 4d 10             	mov    0x10(%ebp),%ecx
 68e:	8b 45 0c             	mov    0xc(%ebp),%eax
 691:	89 d7                	mov    %edx,%edi
 693:	fc                   	cld    
 694:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 696:	89 d0                	mov    %edx,%eax
 698:	5f                   	pop    %edi
 699:	5d                   	pop    %ebp
 69a:	c3                   	ret    
 69b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 69f:	90                   	nop

000006a0 <strchr>:

char*
strchr(const char *s, char c)
{
 6a0:	f3 0f 1e fb          	endbr32 
 6a4:	55                   	push   %ebp
 6a5:	89 e5                	mov    %esp,%ebp
 6a7:	8b 45 08             	mov    0x8(%ebp),%eax
 6aa:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 6ae:	0f b6 10             	movzbl (%eax),%edx
 6b1:	84 d2                	test   %dl,%dl
 6b3:	75 16                	jne    6cb <strchr+0x2b>
 6b5:	eb 21                	jmp    6d8 <strchr+0x38>
 6b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6be:	66 90                	xchg   %ax,%ax
 6c0:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 6c4:	83 c0 01             	add    $0x1,%eax
 6c7:	84 d2                	test   %dl,%dl
 6c9:	74 0d                	je     6d8 <strchr+0x38>
    if(*s == c)
 6cb:	38 d1                	cmp    %dl,%cl
 6cd:	75 f1                	jne    6c0 <strchr+0x20>
      return (char*)s;
  return 0;
}
 6cf:	5d                   	pop    %ebp
 6d0:	c3                   	ret    
 6d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 6d8:	31 c0                	xor    %eax,%eax
}
 6da:	5d                   	pop    %ebp
 6db:	c3                   	ret    
 6dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000006e0 <gets>:

char*
gets(char *buf, int max)
{
 6e0:	f3 0f 1e fb          	endbr32 
 6e4:	55                   	push   %ebp
 6e5:	89 e5                	mov    %esp,%ebp
 6e7:	57                   	push   %edi
 6e8:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 6e9:	31 f6                	xor    %esi,%esi
{
 6eb:	53                   	push   %ebx
 6ec:	89 f3                	mov    %esi,%ebx
 6ee:	83 ec 1c             	sub    $0x1c,%esp
 6f1:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 6f4:	eb 33                	jmp    729 <gets+0x49>
 6f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6fd:	8d 76 00             	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 700:	83 ec 04             	sub    $0x4,%esp
 703:	8d 45 e7             	lea    -0x19(%ebp),%eax
 706:	6a 01                	push   $0x1
 708:	50                   	push   %eax
 709:	6a 00                	push   $0x0
 70b:	e8 2b 01 00 00       	call   83b <read>
    if(cc < 1)
 710:	83 c4 10             	add    $0x10,%esp
 713:	85 c0                	test   %eax,%eax
 715:	7e 1c                	jle    733 <gets+0x53>
      break;
    buf[i++] = c;
 717:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 71b:	83 c7 01             	add    $0x1,%edi
 71e:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 721:	3c 0a                	cmp    $0xa,%al
 723:	74 23                	je     748 <gets+0x68>
 725:	3c 0d                	cmp    $0xd,%al
 727:	74 1f                	je     748 <gets+0x68>
  for(i=0; i+1 < max; ){
 729:	83 c3 01             	add    $0x1,%ebx
 72c:	89 fe                	mov    %edi,%esi
 72e:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 731:	7c cd                	jl     700 <gets+0x20>
 733:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 735:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 738:	c6 03 00             	movb   $0x0,(%ebx)
}
 73b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 73e:	5b                   	pop    %ebx
 73f:	5e                   	pop    %esi
 740:	5f                   	pop    %edi
 741:	5d                   	pop    %ebp
 742:	c3                   	ret    
 743:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 747:	90                   	nop
 748:	8b 75 08             	mov    0x8(%ebp),%esi
 74b:	8b 45 08             	mov    0x8(%ebp),%eax
 74e:	01 de                	add    %ebx,%esi
 750:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 752:	c6 03 00             	movb   $0x0,(%ebx)
}
 755:	8d 65 f4             	lea    -0xc(%ebp),%esp
 758:	5b                   	pop    %ebx
 759:	5e                   	pop    %esi
 75a:	5f                   	pop    %edi
 75b:	5d                   	pop    %ebp
 75c:	c3                   	ret    
 75d:	8d 76 00             	lea    0x0(%esi),%esi

00000760 <stat>:

int
stat(const char *n, struct stat *st)
{
 760:	f3 0f 1e fb          	endbr32 
 764:	55                   	push   %ebp
 765:	89 e5                	mov    %esp,%ebp
 767:	56                   	push   %esi
 768:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 769:	83 ec 08             	sub    $0x8,%esp
 76c:	6a 00                	push   $0x0
 76e:	ff 75 08             	pushl  0x8(%ebp)
 771:	e8 ed 00 00 00       	call   863 <open>
  if(fd < 0)
 776:	83 c4 10             	add    $0x10,%esp
 779:	85 c0                	test   %eax,%eax
 77b:	78 2b                	js     7a8 <stat+0x48>
    return -1;
  r = fstat(fd, st);
 77d:	83 ec 08             	sub    $0x8,%esp
 780:	ff 75 0c             	pushl  0xc(%ebp)
 783:	89 c3                	mov    %eax,%ebx
 785:	50                   	push   %eax
 786:	e8 f0 00 00 00       	call   87b <fstat>
  close(fd);
 78b:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 78e:	89 c6                	mov    %eax,%esi
  close(fd);
 790:	e8 b6 00 00 00       	call   84b <close>
  return r;
 795:	83 c4 10             	add    $0x10,%esp
}
 798:	8d 65 f8             	lea    -0x8(%ebp),%esp
 79b:	89 f0                	mov    %esi,%eax
 79d:	5b                   	pop    %ebx
 79e:	5e                   	pop    %esi
 79f:	5d                   	pop    %ebp
 7a0:	c3                   	ret    
 7a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
 7a8:	be ff ff ff ff       	mov    $0xffffffff,%esi
 7ad:	eb e9                	jmp    798 <stat+0x38>
 7af:	90                   	nop

000007b0 <atoi>:

int
atoi(const char *s)
{
 7b0:	f3 0f 1e fb          	endbr32 
 7b4:	55                   	push   %ebp
 7b5:	89 e5                	mov    %esp,%ebp
 7b7:	53                   	push   %ebx
 7b8:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 7bb:	0f be 02             	movsbl (%edx),%eax
 7be:	8d 48 d0             	lea    -0x30(%eax),%ecx
 7c1:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 7c4:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 7c9:	77 1a                	ja     7e5 <atoi+0x35>
 7cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 7cf:	90                   	nop
    n = n*10 + *s++ - '0';
 7d0:	83 c2 01             	add    $0x1,%edx
 7d3:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 7d6:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 7da:	0f be 02             	movsbl (%edx),%eax
 7dd:	8d 58 d0             	lea    -0x30(%eax),%ebx
 7e0:	80 fb 09             	cmp    $0x9,%bl
 7e3:	76 eb                	jbe    7d0 <atoi+0x20>
  return n;
}
 7e5:	89 c8                	mov    %ecx,%eax
 7e7:	5b                   	pop    %ebx
 7e8:	5d                   	pop    %ebp
 7e9:	c3                   	ret    
 7ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000007f0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 7f0:	f3 0f 1e fb          	endbr32 
 7f4:	55                   	push   %ebp
 7f5:	89 e5                	mov    %esp,%ebp
 7f7:	57                   	push   %edi
 7f8:	8b 45 10             	mov    0x10(%ebp),%eax
 7fb:	8b 55 08             	mov    0x8(%ebp),%edx
 7fe:	56                   	push   %esi
 7ff:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 802:	85 c0                	test   %eax,%eax
 804:	7e 0f                	jle    815 <memmove+0x25>
 806:	01 d0                	add    %edx,%eax
  dst = vdst;
 808:	89 d7                	mov    %edx,%edi
 80a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *dst++ = *src++;
 810:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 811:	39 f8                	cmp    %edi,%eax
 813:	75 fb                	jne    810 <memmove+0x20>
  return vdst;
}
 815:	5e                   	pop    %esi
 816:	89 d0                	mov    %edx,%eax
 818:	5f                   	pop    %edi
 819:	5d                   	pop    %ebp
 81a:	c3                   	ret    

0000081b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 81b:	b8 01 00 00 00       	mov    $0x1,%eax
 820:	cd 40                	int    $0x40
 822:	c3                   	ret    

00000823 <exit>:
SYSCALL(exit)
 823:	b8 02 00 00 00       	mov    $0x2,%eax
 828:	cd 40                	int    $0x40
 82a:	c3                   	ret    

0000082b <wait>:
SYSCALL(wait)
 82b:	b8 03 00 00 00       	mov    $0x3,%eax
 830:	cd 40                	int    $0x40
 832:	c3                   	ret    

00000833 <pipe>:
SYSCALL(pipe)
 833:	b8 04 00 00 00       	mov    $0x4,%eax
 838:	cd 40                	int    $0x40
 83a:	c3                   	ret    

0000083b <read>:
SYSCALL(read)
 83b:	b8 05 00 00 00       	mov    $0x5,%eax
 840:	cd 40                	int    $0x40
 842:	c3                   	ret    

00000843 <write>:
SYSCALL(write)
 843:	b8 10 00 00 00       	mov    $0x10,%eax
 848:	cd 40                	int    $0x40
 84a:	c3                   	ret    

0000084b <close>:
SYSCALL(close)
 84b:	b8 15 00 00 00       	mov    $0x15,%eax
 850:	cd 40                	int    $0x40
 852:	c3                   	ret    

00000853 <kill>:
SYSCALL(kill)
 853:	b8 06 00 00 00       	mov    $0x6,%eax
 858:	cd 40                	int    $0x40
 85a:	c3                   	ret    

0000085b <exec>:
SYSCALL(exec)
 85b:	b8 07 00 00 00       	mov    $0x7,%eax
 860:	cd 40                	int    $0x40
 862:	c3                   	ret    

00000863 <open>:
SYSCALL(open)
 863:	b8 0f 00 00 00       	mov    $0xf,%eax
 868:	cd 40                	int    $0x40
 86a:	c3                   	ret    

0000086b <mknod>:
SYSCALL(mknod)
 86b:	b8 11 00 00 00       	mov    $0x11,%eax
 870:	cd 40                	int    $0x40
 872:	c3                   	ret    

00000873 <unlink>:
SYSCALL(unlink)
 873:	b8 12 00 00 00       	mov    $0x12,%eax
 878:	cd 40                	int    $0x40
 87a:	c3                   	ret    

0000087b <fstat>:
SYSCALL(fstat)
 87b:	b8 08 00 00 00       	mov    $0x8,%eax
 880:	cd 40                	int    $0x40
 882:	c3                   	ret    

00000883 <link>:
SYSCALL(link)
 883:	b8 13 00 00 00       	mov    $0x13,%eax
 888:	cd 40                	int    $0x40
 88a:	c3                   	ret    

0000088b <mkdir>:
SYSCALL(mkdir)
 88b:	b8 14 00 00 00       	mov    $0x14,%eax
 890:	cd 40                	int    $0x40
 892:	c3                   	ret    

00000893 <chdir>:
SYSCALL(chdir)
 893:	b8 09 00 00 00       	mov    $0x9,%eax
 898:	cd 40                	int    $0x40
 89a:	c3                   	ret    

0000089b <dup>:
SYSCALL(dup)
 89b:	b8 0a 00 00 00       	mov    $0xa,%eax
 8a0:	cd 40                	int    $0x40
 8a2:	c3                   	ret    

000008a3 <getpid>:
SYSCALL(getpid)
 8a3:	b8 0b 00 00 00       	mov    $0xb,%eax
 8a8:	cd 40                	int    $0x40
 8aa:	c3                   	ret    

000008ab <sbrk>:
SYSCALL(sbrk)
 8ab:	b8 0c 00 00 00       	mov    $0xc,%eax
 8b0:	cd 40                	int    $0x40
 8b2:	c3                   	ret    

000008b3 <sleep>:
SYSCALL(sleep)
 8b3:	b8 0d 00 00 00       	mov    $0xd,%eax
 8b8:	cd 40                	int    $0x40
 8ba:	c3                   	ret    

000008bb <uptime>:
SYSCALL(uptime)
 8bb:	b8 0e 00 00 00       	mov    $0xe,%eax
 8c0:	cd 40                	int    $0x40
 8c2:	c3                   	ret    

000008c3 <waitx>:
SYSCALL(waitx)
 8c3:	b8 16 00 00 00       	mov    $0x16,%eax
 8c8:	cd 40                	int    $0x40
 8ca:	c3                   	ret    

000008cb <set_priority>:
SYSCALL(set_priority)
 8cb:	b8 17 00 00 00       	mov    $0x17,%eax
 8d0:	cd 40                	int    $0x40
 8d2:	c3                   	ret    

000008d3 <ps>:
 8d3:	b8 18 00 00 00       	mov    $0x18,%eax
 8d8:	cd 40                	int    $0x40
 8da:	c3                   	ret    
 8db:	66 90                	xchg   %ax,%ax
 8dd:	66 90                	xchg   %ax,%ax
 8df:	90                   	nop

000008e0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 8e0:	55                   	push   %ebp
 8e1:	89 e5                	mov    %esp,%ebp
 8e3:	57                   	push   %edi
 8e4:	56                   	push   %esi
 8e5:	53                   	push   %ebx
 8e6:	83 ec 3c             	sub    $0x3c,%esp
 8e9:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 8ec:	89 d1                	mov    %edx,%ecx
{
 8ee:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 8f1:	85 d2                	test   %edx,%edx
 8f3:	0f 89 7f 00 00 00    	jns    978 <printint+0x98>
 8f9:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 8fd:	74 79                	je     978 <printint+0x98>
    neg = 1;
 8ff:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 906:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 908:	31 db                	xor    %ebx,%ebx
 90a:	8d 75 d7             	lea    -0x29(%ebp),%esi
 90d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 910:	89 c8                	mov    %ecx,%eax
 912:	31 d2                	xor    %edx,%edx
 914:	89 cf                	mov    %ecx,%edi
 916:	f7 75 c4             	divl   -0x3c(%ebp)
 919:	0f b6 92 6c 0d 00 00 	movzbl 0xd6c(%edx),%edx
 920:	89 45 c0             	mov    %eax,-0x40(%ebp)
 923:	89 d8                	mov    %ebx,%eax
 925:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 928:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 92b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 92e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 931:	76 dd                	jbe    910 <printint+0x30>
  if(neg)
 933:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 936:	85 c9                	test   %ecx,%ecx
 938:	74 0c                	je     946 <printint+0x66>
    buf[i++] = '-';
 93a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 93f:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 941:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 946:	8b 7d b8             	mov    -0x48(%ebp),%edi
 949:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 94d:	eb 07                	jmp    956 <printint+0x76>
 94f:	90                   	nop
 950:	0f b6 13             	movzbl (%ebx),%edx
 953:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 956:	83 ec 04             	sub    $0x4,%esp
 959:	88 55 d7             	mov    %dl,-0x29(%ebp)
 95c:	6a 01                	push   $0x1
 95e:	56                   	push   %esi
 95f:	57                   	push   %edi
 960:	e8 de fe ff ff       	call   843 <write>
  while(--i >= 0)
 965:	83 c4 10             	add    $0x10,%esp
 968:	39 de                	cmp    %ebx,%esi
 96a:	75 e4                	jne    950 <printint+0x70>
    putc(fd, buf[i]);
}
 96c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 96f:	5b                   	pop    %ebx
 970:	5e                   	pop    %esi
 971:	5f                   	pop    %edi
 972:	5d                   	pop    %ebp
 973:	c3                   	ret    
 974:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 978:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 97f:	eb 87                	jmp    908 <printint+0x28>
 981:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 988:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 98f:	90                   	nop

00000990 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 990:	f3 0f 1e fb          	endbr32 
 994:	55                   	push   %ebp
 995:	89 e5                	mov    %esp,%ebp
 997:	57                   	push   %edi
 998:	56                   	push   %esi
 999:	53                   	push   %ebx
 99a:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 99d:	8b 75 0c             	mov    0xc(%ebp),%esi
 9a0:	0f b6 1e             	movzbl (%esi),%ebx
 9a3:	84 db                	test   %bl,%bl
 9a5:	0f 84 b4 00 00 00    	je     a5f <printf+0xcf>
  ap = (uint*)(void*)&fmt + 1;
 9ab:	8d 45 10             	lea    0x10(%ebp),%eax
 9ae:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 9b1:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 9b4:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
 9b6:	89 45 d0             	mov    %eax,-0x30(%ebp)
 9b9:	eb 33                	jmp    9ee <printf+0x5e>
 9bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 9bf:	90                   	nop
 9c0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 9c3:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 9c8:	83 f8 25             	cmp    $0x25,%eax
 9cb:	74 17                	je     9e4 <printf+0x54>
  write(fd, &c, 1);
 9cd:	83 ec 04             	sub    $0x4,%esp
 9d0:	88 5d e7             	mov    %bl,-0x19(%ebp)
 9d3:	6a 01                	push   $0x1
 9d5:	57                   	push   %edi
 9d6:	ff 75 08             	pushl  0x8(%ebp)
 9d9:	e8 65 fe ff ff       	call   843 <write>
 9de:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 9e1:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 9e4:	0f b6 1e             	movzbl (%esi),%ebx
 9e7:	83 c6 01             	add    $0x1,%esi
 9ea:	84 db                	test   %bl,%bl
 9ec:	74 71                	je     a5f <printf+0xcf>
    c = fmt[i] & 0xff;
 9ee:	0f be cb             	movsbl %bl,%ecx
 9f1:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 9f4:	85 d2                	test   %edx,%edx
 9f6:	74 c8                	je     9c0 <printf+0x30>
      }
    } else if(state == '%'){
 9f8:	83 fa 25             	cmp    $0x25,%edx
 9fb:	75 e7                	jne    9e4 <printf+0x54>
      if(c == 'd'){
 9fd:	83 f8 64             	cmp    $0x64,%eax
 a00:	0f 84 9a 00 00 00    	je     aa0 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 a06:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 a0c:	83 f9 70             	cmp    $0x70,%ecx
 a0f:	74 5f                	je     a70 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 a11:	83 f8 73             	cmp    $0x73,%eax
 a14:	0f 84 d6 00 00 00    	je     af0 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 a1a:	83 f8 63             	cmp    $0x63,%eax
 a1d:	0f 84 8d 00 00 00    	je     ab0 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 a23:	83 f8 25             	cmp    $0x25,%eax
 a26:	0f 84 b4 00 00 00    	je     ae0 <printf+0x150>
  write(fd, &c, 1);
 a2c:	83 ec 04             	sub    $0x4,%esp
 a2f:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 a33:	6a 01                	push   $0x1
 a35:	57                   	push   %edi
 a36:	ff 75 08             	pushl  0x8(%ebp)
 a39:	e8 05 fe ff ff       	call   843 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 a3e:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 a41:	83 c4 0c             	add    $0xc,%esp
 a44:	6a 01                	push   $0x1
 a46:	83 c6 01             	add    $0x1,%esi
 a49:	57                   	push   %edi
 a4a:	ff 75 08             	pushl  0x8(%ebp)
 a4d:	e8 f1 fd ff ff       	call   843 <write>
  for(i = 0; fmt[i]; i++){
 a52:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
 a56:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 a59:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 a5b:	84 db                	test   %bl,%bl
 a5d:	75 8f                	jne    9ee <printf+0x5e>
    }
  }
}
 a5f:	8d 65 f4             	lea    -0xc(%ebp),%esp
 a62:	5b                   	pop    %ebx
 a63:	5e                   	pop    %esi
 a64:	5f                   	pop    %edi
 a65:	5d                   	pop    %ebp
 a66:	c3                   	ret    
 a67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 a6e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 a70:	83 ec 0c             	sub    $0xc,%esp
 a73:	b9 10 00 00 00       	mov    $0x10,%ecx
 a78:	6a 00                	push   $0x0
 a7a:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 a7d:	8b 45 08             	mov    0x8(%ebp),%eax
 a80:	8b 13                	mov    (%ebx),%edx
 a82:	e8 59 fe ff ff       	call   8e0 <printint>
        ap++;
 a87:	89 d8                	mov    %ebx,%eax
 a89:	83 c4 10             	add    $0x10,%esp
      state = 0;
 a8c:	31 d2                	xor    %edx,%edx
        ap++;
 a8e:	83 c0 04             	add    $0x4,%eax
 a91:	89 45 d0             	mov    %eax,-0x30(%ebp)
 a94:	e9 4b ff ff ff       	jmp    9e4 <printf+0x54>
 a99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
 aa0:	83 ec 0c             	sub    $0xc,%esp
 aa3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 aa8:	6a 01                	push   $0x1
 aaa:	eb ce                	jmp    a7a <printf+0xea>
 aac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
 ab0:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 ab3:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 ab6:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
 ab8:	6a 01                	push   $0x1
        ap++;
 aba:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
 abd:	57                   	push   %edi
 abe:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
 ac1:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 ac4:	e8 7a fd ff ff       	call   843 <write>
        ap++;
 ac9:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 acc:	83 c4 10             	add    $0x10,%esp
      state = 0;
 acf:	31 d2                	xor    %edx,%edx
 ad1:	e9 0e ff ff ff       	jmp    9e4 <printf+0x54>
 ad6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 add:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
 ae0:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 ae3:	83 ec 04             	sub    $0x4,%esp
 ae6:	e9 59 ff ff ff       	jmp    a44 <printf+0xb4>
 aeb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 aef:	90                   	nop
        s = (char*)*ap;
 af0:	8b 45 d0             	mov    -0x30(%ebp),%eax
 af3:	8b 18                	mov    (%eax),%ebx
        ap++;
 af5:	83 c0 04             	add    $0x4,%eax
 af8:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 afb:	85 db                	test   %ebx,%ebx
 afd:	74 17                	je     b16 <printf+0x186>
        while(*s != 0){
 aff:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 b02:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 b04:	84 c0                	test   %al,%al
 b06:	0f 84 d8 fe ff ff    	je     9e4 <printf+0x54>
 b0c:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 b0f:	89 de                	mov    %ebx,%esi
 b11:	8b 5d 08             	mov    0x8(%ebp),%ebx
 b14:	eb 1a                	jmp    b30 <printf+0x1a0>
          s = "(null)";
 b16:	bb 64 0d 00 00       	mov    $0xd64,%ebx
        while(*s != 0){
 b1b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 b1e:	b8 28 00 00 00       	mov    $0x28,%eax
 b23:	89 de                	mov    %ebx,%esi
 b25:	8b 5d 08             	mov    0x8(%ebp),%ebx
 b28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 b2f:	90                   	nop
  write(fd, &c, 1);
 b30:	83 ec 04             	sub    $0x4,%esp
          s++;
 b33:	83 c6 01             	add    $0x1,%esi
 b36:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 b39:	6a 01                	push   $0x1
 b3b:	57                   	push   %edi
 b3c:	53                   	push   %ebx
 b3d:	e8 01 fd ff ff       	call   843 <write>
        while(*s != 0){
 b42:	0f b6 06             	movzbl (%esi),%eax
 b45:	83 c4 10             	add    $0x10,%esp
 b48:	84 c0                	test   %al,%al
 b4a:	75 e4                	jne    b30 <printf+0x1a0>
 b4c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 b4f:	31 d2                	xor    %edx,%edx
 b51:	e9 8e fe ff ff       	jmp    9e4 <printf+0x54>
 b56:	66 90                	xchg   %ax,%ax
 b58:	66 90                	xchg   %ax,%ax
 b5a:	66 90                	xchg   %ax,%ax
 b5c:	66 90                	xchg   %ax,%ax
 b5e:	66 90                	xchg   %ax,%ax

00000b60 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 b60:	f3 0f 1e fb          	endbr32 
 b64:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b65:	a1 44 11 00 00       	mov    0x1144,%eax
{
 b6a:	89 e5                	mov    %esp,%ebp
 b6c:	57                   	push   %edi
 b6d:	56                   	push   %esi
 b6e:	53                   	push   %ebx
 b6f:	8b 5d 08             	mov    0x8(%ebp),%ebx
 b72:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
 b74:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b77:	39 c8                	cmp    %ecx,%eax
 b79:	73 15                	jae    b90 <free+0x30>
 b7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 b7f:	90                   	nop
 b80:	39 d1                	cmp    %edx,%ecx
 b82:	72 14                	jb     b98 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b84:	39 d0                	cmp    %edx,%eax
 b86:	73 10                	jae    b98 <free+0x38>
{
 b88:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b8a:	8b 10                	mov    (%eax),%edx
 b8c:	39 c8                	cmp    %ecx,%eax
 b8e:	72 f0                	jb     b80 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b90:	39 d0                	cmp    %edx,%eax
 b92:	72 f4                	jb     b88 <free+0x28>
 b94:	39 d1                	cmp    %edx,%ecx
 b96:	73 f0                	jae    b88 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
 b98:	8b 73 fc             	mov    -0x4(%ebx),%esi
 b9b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 b9e:	39 fa                	cmp    %edi,%edx
 ba0:	74 1e                	je     bc0 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 ba2:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 ba5:	8b 50 04             	mov    0x4(%eax),%edx
 ba8:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 bab:	39 f1                	cmp    %esi,%ecx
 bad:	74 28                	je     bd7 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 baf:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
 bb1:	5b                   	pop    %ebx
  freep = p;
 bb2:	a3 44 11 00 00       	mov    %eax,0x1144
}
 bb7:	5e                   	pop    %esi
 bb8:	5f                   	pop    %edi
 bb9:	5d                   	pop    %ebp
 bba:	c3                   	ret    
 bbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 bbf:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 bc0:	03 72 04             	add    0x4(%edx),%esi
 bc3:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 bc6:	8b 10                	mov    (%eax),%edx
 bc8:	8b 12                	mov    (%edx),%edx
 bca:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 bcd:	8b 50 04             	mov    0x4(%eax),%edx
 bd0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 bd3:	39 f1                	cmp    %esi,%ecx
 bd5:	75 d8                	jne    baf <free+0x4f>
    p->s.size += bp->s.size;
 bd7:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 bda:	a3 44 11 00 00       	mov    %eax,0x1144
    p->s.size += bp->s.size;
 bdf:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 be2:	8b 53 f8             	mov    -0x8(%ebx),%edx
 be5:	89 10                	mov    %edx,(%eax)
}
 be7:	5b                   	pop    %ebx
 be8:	5e                   	pop    %esi
 be9:	5f                   	pop    %edi
 bea:	5d                   	pop    %ebp
 beb:	c3                   	ret    
 bec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000bf0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 bf0:	f3 0f 1e fb          	endbr32 
 bf4:	55                   	push   %ebp
 bf5:	89 e5                	mov    %esp,%ebp
 bf7:	57                   	push   %edi
 bf8:	56                   	push   %esi
 bf9:	53                   	push   %ebx
 bfa:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 c00:	8b 3d 44 11 00 00    	mov    0x1144,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 c06:	8d 70 07             	lea    0x7(%eax),%esi
 c09:	c1 ee 03             	shr    $0x3,%esi
 c0c:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 c0f:	85 ff                	test   %edi,%edi
 c11:	0f 84 a9 00 00 00    	je     cc0 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c17:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
 c19:	8b 48 04             	mov    0x4(%eax),%ecx
 c1c:	39 f1                	cmp    %esi,%ecx
 c1e:	73 6d                	jae    c8d <malloc+0x9d>
 c20:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 c26:	bb 00 10 00 00       	mov    $0x1000,%ebx
 c2b:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 c2e:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
 c35:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 c38:	eb 17                	jmp    c51 <malloc+0x61>
 c3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c40:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
 c42:	8b 4a 04             	mov    0x4(%edx),%ecx
 c45:	39 f1                	cmp    %esi,%ecx
 c47:	73 4f                	jae    c98 <malloc+0xa8>
 c49:	8b 3d 44 11 00 00    	mov    0x1144,%edi
 c4f:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 c51:	39 c7                	cmp    %eax,%edi
 c53:	75 eb                	jne    c40 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
 c55:	83 ec 0c             	sub    $0xc,%esp
 c58:	ff 75 e4             	pushl  -0x1c(%ebp)
 c5b:	e8 4b fc ff ff       	call   8ab <sbrk>
  if(p == (char*)-1)
 c60:	83 c4 10             	add    $0x10,%esp
 c63:	83 f8 ff             	cmp    $0xffffffff,%eax
 c66:	74 1b                	je     c83 <malloc+0x93>
  hp->s.size = nu;
 c68:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 c6b:	83 ec 0c             	sub    $0xc,%esp
 c6e:	83 c0 08             	add    $0x8,%eax
 c71:	50                   	push   %eax
 c72:	e8 e9 fe ff ff       	call   b60 <free>
  return freep;
 c77:	a1 44 11 00 00       	mov    0x1144,%eax
      if((p = morecore(nunits)) == 0)
 c7c:	83 c4 10             	add    $0x10,%esp
 c7f:	85 c0                	test   %eax,%eax
 c81:	75 bd                	jne    c40 <malloc+0x50>
        return 0;
  }
}
 c83:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 c86:	31 c0                	xor    %eax,%eax
}
 c88:	5b                   	pop    %ebx
 c89:	5e                   	pop    %esi
 c8a:	5f                   	pop    %edi
 c8b:	5d                   	pop    %ebp
 c8c:	c3                   	ret    
    if(p->s.size >= nunits){
 c8d:	89 c2                	mov    %eax,%edx
 c8f:	89 f8                	mov    %edi,%eax
 c91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 c98:	39 ce                	cmp    %ecx,%esi
 c9a:	74 54                	je     cf0 <malloc+0x100>
        p->s.size -= nunits;
 c9c:	29 f1                	sub    %esi,%ecx
 c9e:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
 ca1:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
 ca4:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
 ca7:	a3 44 11 00 00       	mov    %eax,0x1144
}
 cac:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 caf:	8d 42 08             	lea    0x8(%edx),%eax
}
 cb2:	5b                   	pop    %ebx
 cb3:	5e                   	pop    %esi
 cb4:	5f                   	pop    %edi
 cb5:	5d                   	pop    %ebp
 cb6:	c3                   	ret    
 cb7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 cbe:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
 cc0:	c7 05 44 11 00 00 48 	movl   $0x1148,0x1144
 cc7:	11 00 00 
    base.s.size = 0;
 cca:	bf 48 11 00 00       	mov    $0x1148,%edi
    base.s.ptr = freep = prevp = &base;
 ccf:	c7 05 48 11 00 00 48 	movl   $0x1148,0x1148
 cd6:	11 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 cd9:	89 f8                	mov    %edi,%eax
    base.s.size = 0;
 cdb:	c7 05 4c 11 00 00 00 	movl   $0x0,0x114c
 ce2:	00 00 00 
    if(p->s.size >= nunits){
 ce5:	e9 36 ff ff ff       	jmp    c20 <malloc+0x30>
 cea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 cf0:	8b 0a                	mov    (%edx),%ecx
 cf2:	89 08                	mov    %ecx,(%eax)
 cf4:	eb b1                	jmp    ca7 <malloc+0xb7>
