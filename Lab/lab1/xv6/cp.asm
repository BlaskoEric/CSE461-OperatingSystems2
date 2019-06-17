
_cp:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

char buf[512];

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
  11:	83 ec 18             	sub    $0x18,%esp
  14:	8b 19                	mov    (%ecx),%ebx
  16:	8b 51 04             	mov    0x4(%ecx),%edx
  int fd0, fd1, fd2, i;

  if(argc <= 2){
  19:	83 fb 02             	cmp    $0x2,%ebx
  1c:	7f 13                	jg     31 <main+0x31>
    printf(1, "Need 2 Arguments!\n");
  1e:	50                   	push   %eax
  1f:	50                   	push   %eax
  20:	68 88 08 00 00       	push   $0x888
  25:	6a 01                	push   $0x1
  27:	e8 f4 04 00 00       	call   520 <printf>
    exit();
  2c:	e8 80 03 00 00       	call   3b1 <exit>
  }

    if((fd0 = open(argv[1], O_RDONLY)) < 0)
  31:	50                   	push   %eax
  32:	50                   	push   %eax
  33:	6a 00                	push   $0x0
  35:	ff 72 04             	pushl  0x4(%edx)
  38:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  3b:	e8 b1 03 00 00       	call   3f1 <open>
  40:	83 c4 10             	add    $0x10,%esp
  43:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  46:	85 c0                	test   %eax,%eax
  48:	89 c6                	mov    %eax,%esi
  4a:	0f 88 b4 00 00 00    	js     104 <main+0x104>
    {
        printf(1, "cp: cannot open %s\n", argv[1]);
        exit();
    }
    if((fd1 = open(argv[2], O_CREATE|O_RDWR)) < 0)
  50:	50                   	push   %eax
  51:	50                   	push   %eax
  52:	68 02 02 00 00       	push   $0x202
  57:	ff 72 08             	pushl  0x8(%edx)
  5a:	89 55 e0             	mov    %edx,-0x20(%ebp)
  5d:	e8 8f 03 00 00       	call   3f1 <open>
  62:	83 c4 10             	add    $0x10,%esp
  65:	8b 55 e0             	mov    -0x20(%ebp),%edx
  68:	85 c0                	test   %eax,%eax
  6a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  6d:	0f 88 ca 00 00 00    	js     13d <main+0x13d>
    {
        printf(1, "cp: cannot open %s\n", argv[2]);
        exit();
    }

    if(argc > 3)
  73:	83 fb 03             	cmp    $0x3,%ebx
  76:	74 51                	je     c9 <main+0xc9>
    {
        if((fd2 = open(argv[3], O_CREATE|O_RDWR)) < 0)
  78:	57                   	push   %edi
  79:	57                   	push   %edi
  7a:	68 02 02 00 00       	push   $0x202
  7f:	ff 72 0c             	pushl  0xc(%edx)
  82:	89 55 e0             	mov    %edx,-0x20(%ebp)
  85:	e8 67 03 00 00       	call   3f1 <open>
  8a:	83 c4 10             	add    $0x10,%esp
  8d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  90:	85 c0                	test   %eax,%eax
  92:	89 45 dc             	mov    %eax,-0x24(%ebp)
  95:	79 32                	jns    c9 <main+0xc9>
        {
            printf(1, "cp: cannot open %s\n", argv[3]);
  97:	51                   	push   %ecx
  98:	ff 72 0c             	pushl  0xc(%edx)
  9b:	68 9b 08 00 00       	push   $0x89b
  a0:	6a 01                	push   $0x1
  a2:	e8 79 04 00 00       	call   520 <printf>
            exit();
  a7:	e8 05 03 00 00       	call   3b1 <exit>
  ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        }
    }
    
    while (( i = read ( fd0, buf, sizeof(buf))) > 0 ) 
    { 
        write(fd1, buf, i);
  b0:	83 ec 04             	sub    $0x4,%esp
  b3:	57                   	push   %edi
  b4:	68 a0 0b 00 00       	push   $0xba0
  b9:	ff 75 e4             	pushl  -0x1c(%ebp)
  bc:	e8 10 03 00 00       	call   3d1 <write>
        if(argc > 3)
  c1:	83 c4 10             	add    $0x10,%esp
  c4:	83 fb 03             	cmp    $0x3,%ebx
  c7:	75 60                	jne    129 <main+0x129>
    while (( i = read ( fd0, buf, sizeof(buf))) > 0 ) 
  c9:	83 ec 04             	sub    $0x4,%esp
  cc:	68 00 02 00 00       	push   $0x200
  d1:	68 a0 0b 00 00       	push   $0xba0
  d6:	56                   	push   %esi
  d7:	e8 ed 02 00 00       	call   3c9 <read>
  dc:	83 c4 10             	add    $0x10,%esp
  df:	89 c7                	mov    %eax,%edi
  e1:	85 c0                	test   %eax,%eax
  e3:	7f cb                	jg     b0 <main+0xb0>
            write(fd2,buf,i);
    }
    
    close(fd0);
  e5:	83 ec 0c             	sub    $0xc,%esp
  e8:	56                   	push   %esi
  e9:	e8 eb 02 00 00       	call   3d9 <close>
    close(fd1);
  ee:	58                   	pop    %eax
  ef:	ff 75 e4             	pushl  -0x1c(%ebp)
  f2:	e8 e2 02 00 00       	call   3d9 <close>
    if(argc > 3)
  f7:	83 c4 10             	add    $0x10,%esp
  fa:	83 fb 03             	cmp    $0x3,%ebx
  fd:	75 1a                	jne    119 <main+0x119>
        close(fd2);
  
  exit();
  ff:	e8 ad 02 00 00       	call   3b1 <exit>
        printf(1, "cp: cannot open %s\n", argv[1]);
 104:	50                   	push   %eax
 105:	ff 72 04             	pushl  0x4(%edx)
 108:	68 9b 08 00 00       	push   $0x89b
 10d:	6a 01                	push   $0x1
 10f:	e8 0c 04 00 00       	call   520 <printf>
        exit();
 114:	e8 98 02 00 00       	call   3b1 <exit>
        close(fd2);
 119:	83 ec 0c             	sub    $0xc,%esp
 11c:	ff 75 dc             	pushl  -0x24(%ebp)
 11f:	e8 b5 02 00 00       	call   3d9 <close>
 124:	83 c4 10             	add    $0x10,%esp
 127:	eb d6                	jmp    ff <main+0xff>
            write(fd2,buf,i);
 129:	52                   	push   %edx
 12a:	57                   	push   %edi
 12b:	68 a0 0b 00 00       	push   $0xba0
 130:	ff 75 dc             	pushl  -0x24(%ebp)
 133:	e8 99 02 00 00       	call   3d1 <write>
 138:	83 c4 10             	add    $0x10,%esp
 13b:	eb 8c                	jmp    c9 <main+0xc9>
        printf(1, "cp: cannot open %s\n", argv[2]);
 13d:	50                   	push   %eax
 13e:	ff 72 08             	pushl  0x8(%edx)
 141:	68 9b 08 00 00       	push   $0x89b
 146:	6a 01                	push   $0x1
 148:	e8 d3 03 00 00       	call   520 <printf>
        exit();
 14d:	e8 5f 02 00 00       	call   3b1 <exit>
 152:	66 90                	xchg   %ax,%ax
 154:	66 90                	xchg   %ax,%ax
 156:	66 90                	xchg   %ax,%ax
 158:	66 90                	xchg   %ax,%ax
 15a:	66 90                	xchg   %ax,%ax
 15c:	66 90                	xchg   %ax,%ax
 15e:	66 90                	xchg   %ax,%ax

00000160 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 160:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 161:	31 d2                	xor    %edx,%edx
{
 163:	89 e5                	mov    %esp,%ebp
 165:	53                   	push   %ebx
 166:	8b 45 08             	mov    0x8(%ebp),%eax
 169:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 16c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 170:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
 174:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 177:	83 c2 01             	add    $0x1,%edx
 17a:	84 c9                	test   %cl,%cl
 17c:	75 f2                	jne    170 <strcpy+0x10>
    ;
  return os;
}
 17e:	5b                   	pop    %ebx
 17f:	5d                   	pop    %ebp
 180:	c3                   	ret    
 181:	eb 0d                	jmp    190 <strcmp>
 183:	90                   	nop
 184:	90                   	nop
 185:	90                   	nop
 186:	90                   	nop
 187:	90                   	nop
 188:	90                   	nop
 189:	90                   	nop
 18a:	90                   	nop
 18b:	90                   	nop
 18c:	90                   	nop
 18d:	90                   	nop
 18e:	90                   	nop
 18f:	90                   	nop

00000190 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 190:	55                   	push   %ebp
 191:	89 e5                	mov    %esp,%ebp
 193:	56                   	push   %esi
 194:	53                   	push   %ebx
 195:	8b 5d 08             	mov    0x8(%ebp),%ebx
 198:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(*p && *p == *q)
 19b:	0f b6 13             	movzbl (%ebx),%edx
 19e:	0f b6 0e             	movzbl (%esi),%ecx
 1a1:	84 d2                	test   %dl,%dl
 1a3:	74 1e                	je     1c3 <strcmp+0x33>
 1a5:	b8 01 00 00 00       	mov    $0x1,%eax
 1aa:	38 ca                	cmp    %cl,%dl
 1ac:	74 09                	je     1b7 <strcmp+0x27>
 1ae:	eb 20                	jmp    1d0 <strcmp+0x40>
 1b0:	83 c0 01             	add    $0x1,%eax
 1b3:	38 ca                	cmp    %cl,%dl
 1b5:	75 19                	jne    1d0 <strcmp+0x40>
 1b7:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 1bb:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
 1bf:	84 d2                	test   %dl,%dl
 1c1:	75 ed                	jne    1b0 <strcmp+0x20>
 1c3:	31 c0                	xor    %eax,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 1c5:	5b                   	pop    %ebx
 1c6:	5e                   	pop    %esi
  return (uchar)*p - (uchar)*q;
 1c7:	29 c8                	sub    %ecx,%eax
}
 1c9:	5d                   	pop    %ebp
 1ca:	c3                   	ret    
 1cb:	90                   	nop
 1cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1d0:	0f b6 c2             	movzbl %dl,%eax
 1d3:	5b                   	pop    %ebx
 1d4:	5e                   	pop    %esi
  return (uchar)*p - (uchar)*q;
 1d5:	29 c8                	sub    %ecx,%eax
}
 1d7:	5d                   	pop    %ebp
 1d8:	c3                   	ret    
 1d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000001e0 <strlen>:

uint
strlen(char *s)
{
 1e0:	55                   	push   %ebp
 1e1:	89 e5                	mov    %esp,%ebp
 1e3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 1e6:	80 39 00             	cmpb   $0x0,(%ecx)
 1e9:	74 15                	je     200 <strlen+0x20>
 1eb:	31 d2                	xor    %edx,%edx
 1ed:	8d 76 00             	lea    0x0(%esi),%esi
 1f0:	83 c2 01             	add    $0x1,%edx
 1f3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 1f7:	89 d0                	mov    %edx,%eax
 1f9:	75 f5                	jne    1f0 <strlen+0x10>
    ;
  return n;
}
 1fb:	5d                   	pop    %ebp
 1fc:	c3                   	ret    
 1fd:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 200:	31 c0                	xor    %eax,%eax
}
 202:	5d                   	pop    %ebp
 203:	c3                   	ret    
 204:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 20a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000210 <memset>:

void*
memset(void *dst, int c, uint n)
{
 210:	55                   	push   %ebp
 211:	89 e5                	mov    %esp,%ebp
 213:	57                   	push   %edi
 214:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 217:	8b 4d 10             	mov    0x10(%ebp),%ecx
 21a:	8b 45 0c             	mov    0xc(%ebp),%eax
 21d:	89 d7                	mov    %edx,%edi
 21f:	fc                   	cld    
 220:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 222:	89 d0                	mov    %edx,%eax
 224:	5f                   	pop    %edi
 225:	5d                   	pop    %ebp
 226:	c3                   	ret    
 227:	89 f6                	mov    %esi,%esi
 229:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000230 <strchr>:

char*
strchr(const char *s, char c)
{
 230:	55                   	push   %ebp
 231:	89 e5                	mov    %esp,%ebp
 233:	53                   	push   %ebx
 234:	8b 45 08             	mov    0x8(%ebp),%eax
 237:	8b 55 0c             	mov    0xc(%ebp),%edx
  for(; *s; s++)
 23a:	0f b6 18             	movzbl (%eax),%ebx
 23d:	84 db                	test   %bl,%bl
 23f:	74 1d                	je     25e <strchr+0x2e>
 241:	89 d1                	mov    %edx,%ecx
    if(*s == c)
 243:	38 d3                	cmp    %dl,%bl
 245:	75 0d                	jne    254 <strchr+0x24>
 247:	eb 17                	jmp    260 <strchr+0x30>
 249:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 250:	38 ca                	cmp    %cl,%dl
 252:	74 0c                	je     260 <strchr+0x30>
  for(; *s; s++)
 254:	83 c0 01             	add    $0x1,%eax
 257:	0f b6 10             	movzbl (%eax),%edx
 25a:	84 d2                	test   %dl,%dl
 25c:	75 f2                	jne    250 <strchr+0x20>
      return (char*)s;
  return 0;
 25e:	31 c0                	xor    %eax,%eax
}
 260:	5b                   	pop    %ebx
 261:	5d                   	pop    %ebp
 262:	c3                   	ret    
 263:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 269:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000270 <gets>:

char*
gets(char *buf, int max)
{
 270:	55                   	push   %ebp
 271:	89 e5                	mov    %esp,%ebp
 273:	57                   	push   %edi
 274:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 275:	31 f6                	xor    %esi,%esi
{
 277:	53                   	push   %ebx
 278:	89 f3                	mov    %esi,%ebx
 27a:	83 ec 1c             	sub    $0x1c,%esp
 27d:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 280:	eb 2f                	jmp    2b1 <gets+0x41>
 282:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 288:	83 ec 04             	sub    $0x4,%esp
 28b:	8d 45 e7             	lea    -0x19(%ebp),%eax
 28e:	6a 01                	push   $0x1
 290:	50                   	push   %eax
 291:	6a 00                	push   $0x0
 293:	e8 31 01 00 00       	call   3c9 <read>
    if(cc < 1)
 298:	83 c4 10             	add    $0x10,%esp
 29b:	85 c0                	test   %eax,%eax
 29d:	7e 1c                	jle    2bb <gets+0x4b>
      break;
    buf[i++] = c;
 29f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 2a3:	83 c7 01             	add    $0x1,%edi
 2a6:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 2a9:	3c 0a                	cmp    $0xa,%al
 2ab:	74 23                	je     2d0 <gets+0x60>
 2ad:	3c 0d                	cmp    $0xd,%al
 2af:	74 1f                	je     2d0 <gets+0x60>
  for(i=0; i+1 < max; ){
 2b1:	83 c3 01             	add    $0x1,%ebx
 2b4:	89 fe                	mov    %edi,%esi
 2b6:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 2b9:	7c cd                	jl     288 <gets+0x18>
 2bb:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 2bd:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 2c0:	c6 03 00             	movb   $0x0,(%ebx)
}
 2c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2c6:	5b                   	pop    %ebx
 2c7:	5e                   	pop    %esi
 2c8:	5f                   	pop    %edi
 2c9:	5d                   	pop    %ebp
 2ca:	c3                   	ret    
 2cb:	90                   	nop
 2cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2d0:	8b 75 08             	mov    0x8(%ebp),%esi
 2d3:	8b 45 08             	mov    0x8(%ebp),%eax
 2d6:	01 de                	add    %ebx,%esi
 2d8:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 2da:	c6 03 00             	movb   $0x0,(%ebx)
}
 2dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2e0:	5b                   	pop    %ebx
 2e1:	5e                   	pop    %esi
 2e2:	5f                   	pop    %edi
 2e3:	5d                   	pop    %ebp
 2e4:	c3                   	ret    
 2e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000002f0 <stat>:

int
stat(char *n, struct stat *st)
{
 2f0:	55                   	push   %ebp
 2f1:	89 e5                	mov    %esp,%ebp
 2f3:	56                   	push   %esi
 2f4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2f5:	83 ec 08             	sub    $0x8,%esp
 2f8:	6a 00                	push   $0x0
 2fa:	ff 75 08             	pushl  0x8(%ebp)
 2fd:	e8 ef 00 00 00       	call   3f1 <open>
  if(fd < 0)
 302:	83 c4 10             	add    $0x10,%esp
 305:	85 c0                	test   %eax,%eax
 307:	78 27                	js     330 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 309:	83 ec 08             	sub    $0x8,%esp
 30c:	ff 75 0c             	pushl  0xc(%ebp)
 30f:	89 c3                	mov    %eax,%ebx
 311:	50                   	push   %eax
 312:	e8 f2 00 00 00       	call   409 <fstat>
  close(fd);
 317:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 31a:	89 c6                	mov    %eax,%esi
  close(fd);
 31c:	e8 b8 00 00 00       	call   3d9 <close>
  return r;
 321:	83 c4 10             	add    $0x10,%esp
}
 324:	8d 65 f8             	lea    -0x8(%ebp),%esp
 327:	89 f0                	mov    %esi,%eax
 329:	5b                   	pop    %ebx
 32a:	5e                   	pop    %esi
 32b:	5d                   	pop    %ebp
 32c:	c3                   	ret    
 32d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 330:	be ff ff ff ff       	mov    $0xffffffff,%esi
 335:	eb ed                	jmp    324 <stat+0x34>
 337:	89 f6                	mov    %esi,%esi
 339:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000340 <atoi>:

int
atoi(const char *s)
{
 340:	55                   	push   %ebp
 341:	89 e5                	mov    %esp,%ebp
 343:	53                   	push   %ebx
 344:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 347:	0f be 11             	movsbl (%ecx),%edx
 34a:	8d 42 d0             	lea    -0x30(%edx),%eax
 34d:	3c 09                	cmp    $0x9,%al
  n = 0;
 34f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 354:	77 1f                	ja     375 <atoi+0x35>
 356:	8d 76 00             	lea    0x0(%esi),%esi
 359:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 360:	83 c1 01             	add    $0x1,%ecx
 363:	8d 04 80             	lea    (%eax,%eax,4),%eax
 366:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 36a:	0f be 11             	movsbl (%ecx),%edx
 36d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 370:	80 fb 09             	cmp    $0x9,%bl
 373:	76 eb                	jbe    360 <atoi+0x20>
  return n;
}
 375:	5b                   	pop    %ebx
 376:	5d                   	pop    %ebp
 377:	c3                   	ret    
 378:	90                   	nop
 379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000380 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 380:	55                   	push   %ebp
 381:	89 e5                	mov    %esp,%ebp
 383:	57                   	push   %edi
 384:	8b 55 10             	mov    0x10(%ebp),%edx
 387:	8b 45 08             	mov    0x8(%ebp),%eax
 38a:	56                   	push   %esi
 38b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 38e:	85 d2                	test   %edx,%edx
 390:	7e 13                	jle    3a5 <memmove+0x25>
 392:	01 c2                	add    %eax,%edx
  dst = vdst;
 394:	89 c7                	mov    %eax,%edi
 396:	8d 76 00             	lea    0x0(%esi),%esi
 399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    *dst++ = *src++;
 3a0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 3a1:	39 fa                	cmp    %edi,%edx
 3a3:	75 fb                	jne    3a0 <memmove+0x20>
  return vdst;
}
 3a5:	5e                   	pop    %esi
 3a6:	5f                   	pop    %edi
 3a7:	5d                   	pop    %ebp
 3a8:	c3                   	ret    

000003a9 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3a9:	b8 01 00 00 00       	mov    $0x1,%eax
 3ae:	cd 40                	int    $0x40
 3b0:	c3                   	ret    

000003b1 <exit>:
SYSCALL(exit)
 3b1:	b8 02 00 00 00       	mov    $0x2,%eax
 3b6:	cd 40                	int    $0x40
 3b8:	c3                   	ret    

000003b9 <wait>:
SYSCALL(wait)
 3b9:	b8 03 00 00 00       	mov    $0x3,%eax
 3be:	cd 40                	int    $0x40
 3c0:	c3                   	ret    

000003c1 <pipe>:
SYSCALL(pipe)
 3c1:	b8 04 00 00 00       	mov    $0x4,%eax
 3c6:	cd 40                	int    $0x40
 3c8:	c3                   	ret    

000003c9 <read>:
SYSCALL(read)
 3c9:	b8 05 00 00 00       	mov    $0x5,%eax
 3ce:	cd 40                	int    $0x40
 3d0:	c3                   	ret    

000003d1 <write>:
SYSCALL(write)
 3d1:	b8 10 00 00 00       	mov    $0x10,%eax
 3d6:	cd 40                	int    $0x40
 3d8:	c3                   	ret    

000003d9 <close>:
SYSCALL(close)
 3d9:	b8 15 00 00 00       	mov    $0x15,%eax
 3de:	cd 40                	int    $0x40
 3e0:	c3                   	ret    

000003e1 <kill>:
SYSCALL(kill)
 3e1:	b8 06 00 00 00       	mov    $0x6,%eax
 3e6:	cd 40                	int    $0x40
 3e8:	c3                   	ret    

000003e9 <exec>:
SYSCALL(exec)
 3e9:	b8 07 00 00 00       	mov    $0x7,%eax
 3ee:	cd 40                	int    $0x40
 3f0:	c3                   	ret    

000003f1 <open>:
SYSCALL(open)
 3f1:	b8 0f 00 00 00       	mov    $0xf,%eax
 3f6:	cd 40                	int    $0x40
 3f8:	c3                   	ret    

000003f9 <mknod>:
SYSCALL(mknod)
 3f9:	b8 11 00 00 00       	mov    $0x11,%eax
 3fe:	cd 40                	int    $0x40
 400:	c3                   	ret    

00000401 <unlink>:
SYSCALL(unlink)
 401:	b8 12 00 00 00       	mov    $0x12,%eax
 406:	cd 40                	int    $0x40
 408:	c3                   	ret    

00000409 <fstat>:
SYSCALL(fstat)
 409:	b8 08 00 00 00       	mov    $0x8,%eax
 40e:	cd 40                	int    $0x40
 410:	c3                   	ret    

00000411 <link>:
SYSCALL(link)
 411:	b8 13 00 00 00       	mov    $0x13,%eax
 416:	cd 40                	int    $0x40
 418:	c3                   	ret    

00000419 <mkdir>:
SYSCALL(mkdir)
 419:	b8 14 00 00 00       	mov    $0x14,%eax
 41e:	cd 40                	int    $0x40
 420:	c3                   	ret    

00000421 <chdir>:
SYSCALL(chdir)
 421:	b8 09 00 00 00       	mov    $0x9,%eax
 426:	cd 40                	int    $0x40
 428:	c3                   	ret    

00000429 <dup>:
SYSCALL(dup)
 429:	b8 0a 00 00 00       	mov    $0xa,%eax
 42e:	cd 40                	int    $0x40
 430:	c3                   	ret    

00000431 <getpid>:
SYSCALL(getpid)
 431:	b8 0b 00 00 00       	mov    $0xb,%eax
 436:	cd 40                	int    $0x40
 438:	c3                   	ret    

00000439 <sbrk>:
SYSCALL(sbrk)
 439:	b8 0c 00 00 00       	mov    $0xc,%eax
 43e:	cd 40                	int    $0x40
 440:	c3                   	ret    

00000441 <sleep>:
SYSCALL(sleep)
 441:	b8 0d 00 00 00       	mov    $0xd,%eax
 446:	cd 40                	int    $0x40
 448:	c3                   	ret    

00000449 <uptime>:
SYSCALL(uptime)
 449:	b8 0e 00 00 00       	mov    $0xe,%eax
 44e:	cd 40                	int    $0x40
 450:	c3                   	ret    

00000451 <cps>:
SYSCALL(cps)
 451:	b8 16 00 00 00       	mov    $0x16,%eax
 456:	cd 40                	int    $0x40
 458:	c3                   	ret    
 459:	66 90                	xchg   %ax,%ax
 45b:	66 90                	xchg   %ax,%ax
 45d:	66 90                	xchg   %ax,%ax
 45f:	90                   	nop

00000460 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 460:	55                   	push   %ebp
 461:	89 e5                	mov    %esp,%ebp
 463:	57                   	push   %edi
 464:	56                   	push   %esi
 465:	53                   	push   %ebx
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 466:	89 d3                	mov    %edx,%ebx
{
 468:	83 ec 3c             	sub    $0x3c,%esp
 46b:	89 45 bc             	mov    %eax,-0x44(%ebp)
  if(sgn && xx < 0){
 46e:	85 d2                	test   %edx,%edx
 470:	0f 89 92 00 00 00    	jns    508 <printint+0xa8>
 476:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 47a:	0f 84 88 00 00 00    	je     508 <printint+0xa8>
    neg = 1;
 480:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
    x = -xx;
 487:	f7 db                	neg    %ebx
  } else {
    x = xx;
  }

  i = 0;
 489:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 490:	8d 75 d7             	lea    -0x29(%ebp),%esi
 493:	eb 08                	jmp    49d <printint+0x3d>
 495:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 498:	89 7d c4             	mov    %edi,-0x3c(%ebp)
  }while((x /= base) != 0);
 49b:	89 c3                	mov    %eax,%ebx
    buf[i++] = digits[x % base];
 49d:	89 d8                	mov    %ebx,%eax
 49f:	31 d2                	xor    %edx,%edx
 4a1:	8b 7d c4             	mov    -0x3c(%ebp),%edi
 4a4:	f7 f1                	div    %ecx
 4a6:	83 c7 01             	add    $0x1,%edi
 4a9:	0f b6 92 b8 08 00 00 	movzbl 0x8b8(%edx),%edx
 4b0:	88 14 3e             	mov    %dl,(%esi,%edi,1)
  }while((x /= base) != 0);
 4b3:	39 d9                	cmp    %ebx,%ecx
 4b5:	76 e1                	jbe    498 <printint+0x38>
  if(neg)
 4b7:	8b 45 c0             	mov    -0x40(%ebp),%eax
 4ba:	85 c0                	test   %eax,%eax
 4bc:	74 0d                	je     4cb <printint+0x6b>
    buf[i++] = '-';
 4be:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 4c3:	ba 2d 00 00 00       	mov    $0x2d,%edx
    buf[i++] = digits[x % base];
 4c8:	89 7d c4             	mov    %edi,-0x3c(%ebp)
 4cb:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 4ce:	8b 7d bc             	mov    -0x44(%ebp),%edi
 4d1:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 4d5:	eb 0f                	jmp    4e6 <printint+0x86>
 4d7:	89 f6                	mov    %esi,%esi
 4d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 4e0:	0f b6 13             	movzbl (%ebx),%edx
 4e3:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 4e6:	83 ec 04             	sub    $0x4,%esp
 4e9:	88 55 d7             	mov    %dl,-0x29(%ebp)
 4ec:	6a 01                	push   $0x1
 4ee:	56                   	push   %esi
 4ef:	57                   	push   %edi
 4f0:	e8 dc fe ff ff       	call   3d1 <write>

  while(--i >= 0)
 4f5:	83 c4 10             	add    $0x10,%esp
 4f8:	39 de                	cmp    %ebx,%esi
 4fa:	75 e4                	jne    4e0 <printint+0x80>
    putc(fd, buf[i]);
}
 4fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4ff:	5b                   	pop    %ebx
 500:	5e                   	pop    %esi
 501:	5f                   	pop    %edi
 502:	5d                   	pop    %ebp
 503:	c3                   	ret    
 504:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 508:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
 50f:	e9 75 ff ff ff       	jmp    489 <printint+0x29>
 514:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 51a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000520 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 520:	55                   	push   %ebp
 521:	89 e5                	mov    %esp,%ebp
 523:	57                   	push   %edi
 524:	56                   	push   %esi
 525:	53                   	push   %ebx
 526:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 529:	8b 75 0c             	mov    0xc(%ebp),%esi
 52c:	0f b6 1e             	movzbl (%esi),%ebx
 52f:	84 db                	test   %bl,%bl
 531:	0f 84 b9 00 00 00    	je     5f0 <printf+0xd0>
  ap = (uint*)(void*)&fmt + 1;
 537:	8d 45 10             	lea    0x10(%ebp),%eax
 53a:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 53d:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 540:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
 542:	89 45 d0             	mov    %eax,-0x30(%ebp)
 545:	eb 38                	jmp    57f <printf+0x5f>
 547:	89 f6                	mov    %esi,%esi
 549:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 550:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 553:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 558:	83 f8 25             	cmp    $0x25,%eax
 55b:	74 17                	je     574 <printf+0x54>
  write(fd, &c, 1);
 55d:	83 ec 04             	sub    $0x4,%esp
 560:	88 5d e7             	mov    %bl,-0x19(%ebp)
 563:	6a 01                	push   $0x1
 565:	57                   	push   %edi
 566:	ff 75 08             	pushl  0x8(%ebp)
 569:	e8 63 fe ff ff       	call   3d1 <write>
 56e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 571:	83 c4 10             	add    $0x10,%esp
 574:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 577:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 57b:	84 db                	test   %bl,%bl
 57d:	74 71                	je     5f0 <printf+0xd0>
    c = fmt[i] & 0xff;
 57f:	0f be cb             	movsbl %bl,%ecx
 582:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 585:	85 d2                	test   %edx,%edx
 587:	74 c7                	je     550 <printf+0x30>
      }
    } else if(state == '%'){
 589:	83 fa 25             	cmp    $0x25,%edx
 58c:	75 e6                	jne    574 <printf+0x54>
      if(c == 'd'){
 58e:	83 f8 64             	cmp    $0x64,%eax
 591:	0f 84 99 00 00 00    	je     630 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 597:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 59d:	83 f9 70             	cmp    $0x70,%ecx
 5a0:	74 5e                	je     600 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 5a2:	83 f8 73             	cmp    $0x73,%eax
 5a5:	0f 84 d5 00 00 00    	je     680 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5ab:	83 f8 63             	cmp    $0x63,%eax
 5ae:	0f 84 8c 00 00 00    	je     640 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 5b4:	83 f8 25             	cmp    $0x25,%eax
 5b7:	0f 84 b3 00 00 00    	je     670 <printf+0x150>
  write(fd, &c, 1);
 5bd:	83 ec 04             	sub    $0x4,%esp
 5c0:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 5c4:	6a 01                	push   $0x1
 5c6:	57                   	push   %edi
 5c7:	ff 75 08             	pushl  0x8(%ebp)
 5ca:	e8 02 fe ff ff       	call   3d1 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 5cf:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 5d2:	83 c4 0c             	add    $0xc,%esp
 5d5:	6a 01                	push   $0x1
 5d7:	83 c6 01             	add    $0x1,%esi
 5da:	57                   	push   %edi
 5db:	ff 75 08             	pushl  0x8(%ebp)
 5de:	e8 ee fd ff ff       	call   3d1 <write>
  for(i = 0; fmt[i]; i++){
 5e3:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
 5e7:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 5ea:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 5ec:	84 db                	test   %bl,%bl
 5ee:	75 8f                	jne    57f <printf+0x5f>
    }
  }
}
 5f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5f3:	5b                   	pop    %ebx
 5f4:	5e                   	pop    %esi
 5f5:	5f                   	pop    %edi
 5f6:	5d                   	pop    %ebp
 5f7:	c3                   	ret    
 5f8:	90                   	nop
 5f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 16, 0);
 600:	83 ec 0c             	sub    $0xc,%esp
 603:	b9 10 00 00 00       	mov    $0x10,%ecx
 608:	6a 00                	push   $0x0
 60a:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 60d:	8b 45 08             	mov    0x8(%ebp),%eax
 610:	8b 13                	mov    (%ebx),%edx
 612:	e8 49 fe ff ff       	call   460 <printint>
        ap++;
 617:	89 d8                	mov    %ebx,%eax
 619:	83 c4 10             	add    $0x10,%esp
      state = 0;
 61c:	31 d2                	xor    %edx,%edx
        ap++;
 61e:	83 c0 04             	add    $0x4,%eax
 621:	89 45 d0             	mov    %eax,-0x30(%ebp)
 624:	e9 4b ff ff ff       	jmp    574 <printf+0x54>
 629:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
 630:	83 ec 0c             	sub    $0xc,%esp
 633:	b9 0a 00 00 00       	mov    $0xa,%ecx
 638:	6a 01                	push   $0x1
 63a:	eb ce                	jmp    60a <printf+0xea>
 63c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
 640:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 643:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 646:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
 648:	6a 01                	push   $0x1
        ap++;
 64a:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
 64d:	57                   	push   %edi
 64e:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
 651:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 654:	e8 78 fd ff ff       	call   3d1 <write>
        ap++;
 659:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 65c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 65f:	31 d2                	xor    %edx,%edx
 661:	e9 0e ff ff ff       	jmp    574 <printf+0x54>
 666:	8d 76 00             	lea    0x0(%esi),%esi
 669:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        putc(fd, c);
 670:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 673:	83 ec 04             	sub    $0x4,%esp
 676:	e9 5a ff ff ff       	jmp    5d5 <printf+0xb5>
 67b:	90                   	nop
 67c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 680:	8b 45 d0             	mov    -0x30(%ebp),%eax
 683:	8b 18                	mov    (%eax),%ebx
        ap++;
 685:	83 c0 04             	add    $0x4,%eax
 688:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 68b:	85 db                	test   %ebx,%ebx
 68d:	74 17                	je     6a6 <printf+0x186>
        while(*s != 0){
 68f:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 692:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 694:	84 c0                	test   %al,%al
 696:	0f 84 d8 fe ff ff    	je     574 <printf+0x54>
 69c:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 69f:	89 de                	mov    %ebx,%esi
 6a1:	8b 5d 08             	mov    0x8(%ebp),%ebx
 6a4:	eb 1a                	jmp    6c0 <printf+0x1a0>
          s = "(null)";
 6a6:	bb af 08 00 00       	mov    $0x8af,%ebx
        while(*s != 0){
 6ab:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 6ae:	b8 28 00 00 00       	mov    $0x28,%eax
 6b3:	89 de                	mov    %ebx,%esi
 6b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
 6b8:	90                   	nop
 6b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  write(fd, &c, 1);
 6c0:	83 ec 04             	sub    $0x4,%esp
          s++;
 6c3:	83 c6 01             	add    $0x1,%esi
 6c6:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 6c9:	6a 01                	push   $0x1
 6cb:	57                   	push   %edi
 6cc:	53                   	push   %ebx
 6cd:	e8 ff fc ff ff       	call   3d1 <write>
        while(*s != 0){
 6d2:	0f b6 06             	movzbl (%esi),%eax
 6d5:	83 c4 10             	add    $0x10,%esp
 6d8:	84 c0                	test   %al,%al
 6da:	75 e4                	jne    6c0 <printf+0x1a0>
 6dc:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 6df:	31 d2                	xor    %edx,%edx
 6e1:	e9 8e fe ff ff       	jmp    574 <printf+0x54>
 6e6:	66 90                	xchg   %ax,%ax
 6e8:	66 90                	xchg   %ax,%ax
 6ea:	66 90                	xchg   %ax,%ax
 6ec:	66 90                	xchg   %ax,%ax
 6ee:	66 90                	xchg   %ax,%ax

000006f0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6f0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6f1:	a1 80 0b 00 00       	mov    0xb80,%eax
{
 6f6:	89 e5                	mov    %esp,%ebp
 6f8:	57                   	push   %edi
 6f9:	56                   	push   %esi
 6fa:	53                   	push   %ebx
 6fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
 6fe:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
 700:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 703:	39 c8                	cmp    %ecx,%eax
 705:	73 19                	jae    720 <free+0x30>
 707:	89 f6                	mov    %esi,%esi
 709:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 710:	39 d1                	cmp    %edx,%ecx
 712:	72 14                	jb     728 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 714:	39 d0                	cmp    %edx,%eax
 716:	73 10                	jae    728 <free+0x38>
{
 718:	89 d0                	mov    %edx,%eax
 71a:	8b 10                	mov    (%eax),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 71c:	39 c8                	cmp    %ecx,%eax
 71e:	72 f0                	jb     710 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 720:	39 d0                	cmp    %edx,%eax
 722:	72 f4                	jb     718 <free+0x28>
 724:	39 d1                	cmp    %edx,%ecx
 726:	73 f0                	jae    718 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
 728:	8b 73 fc             	mov    -0x4(%ebx),%esi
 72b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 72e:	39 fa                	cmp    %edi,%edx
 730:	74 1e                	je     750 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 732:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 735:	8b 50 04             	mov    0x4(%eax),%edx
 738:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 73b:	39 f1                	cmp    %esi,%ecx
 73d:	74 28                	je     767 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 73f:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
 741:	5b                   	pop    %ebx
  freep = p;
 742:	a3 80 0b 00 00       	mov    %eax,0xb80
}
 747:	5e                   	pop    %esi
 748:	5f                   	pop    %edi
 749:	5d                   	pop    %ebp
 74a:	c3                   	ret    
 74b:	90                   	nop
 74c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 750:	03 72 04             	add    0x4(%edx),%esi
 753:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 756:	8b 10                	mov    (%eax),%edx
 758:	8b 12                	mov    (%edx),%edx
 75a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 75d:	8b 50 04             	mov    0x4(%eax),%edx
 760:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 763:	39 f1                	cmp    %esi,%ecx
 765:	75 d8                	jne    73f <free+0x4f>
    p->s.size += bp->s.size;
 767:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 76a:	a3 80 0b 00 00       	mov    %eax,0xb80
    p->s.size += bp->s.size;
 76f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 772:	8b 53 f8             	mov    -0x8(%ebx),%edx
 775:	89 10                	mov    %edx,(%eax)
}
 777:	5b                   	pop    %ebx
 778:	5e                   	pop    %esi
 779:	5f                   	pop    %edi
 77a:	5d                   	pop    %ebp
 77b:	c3                   	ret    
 77c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000780 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 780:	55                   	push   %ebp
 781:	89 e5                	mov    %esp,%ebp
 783:	57                   	push   %edi
 784:	56                   	push   %esi
 785:	53                   	push   %ebx
 786:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 789:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 78c:	8b 3d 80 0b 00 00    	mov    0xb80,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 792:	8d 70 07             	lea    0x7(%eax),%esi
 795:	c1 ee 03             	shr    $0x3,%esi
 798:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 79b:	85 ff                	test   %edi,%edi
 79d:	0f 84 ad 00 00 00    	je     850 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7a3:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
 7a5:	8b 4a 04             	mov    0x4(%edx),%ecx
 7a8:	39 ce                	cmp    %ecx,%esi
 7aa:	76 72                	jbe    81e <malloc+0x9e>
 7ac:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 7b2:	bb 00 10 00 00       	mov    $0x1000,%ebx
 7b7:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 7ba:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 7c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 7c4:	eb 1b                	jmp    7e1 <malloc+0x61>
 7c6:	8d 76 00             	lea    0x0(%esi),%esi
 7c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7d0:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 7d2:	8b 48 04             	mov    0x4(%eax),%ecx
 7d5:	39 f1                	cmp    %esi,%ecx
 7d7:	73 4f                	jae    828 <malloc+0xa8>
 7d9:	8b 3d 80 0b 00 00    	mov    0xb80,%edi
 7df:	89 c2                	mov    %eax,%edx
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7e1:	39 d7                	cmp    %edx,%edi
 7e3:	75 eb                	jne    7d0 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
 7e5:	83 ec 0c             	sub    $0xc,%esp
 7e8:	ff 75 e4             	pushl  -0x1c(%ebp)
 7eb:	e8 49 fc ff ff       	call   439 <sbrk>
  if(p == (char*)-1)
 7f0:	83 c4 10             	add    $0x10,%esp
 7f3:	83 f8 ff             	cmp    $0xffffffff,%eax
 7f6:	74 1c                	je     814 <malloc+0x94>
  hp->s.size = nu;
 7f8:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 7fb:	83 ec 0c             	sub    $0xc,%esp
 7fe:	83 c0 08             	add    $0x8,%eax
 801:	50                   	push   %eax
 802:	e8 e9 fe ff ff       	call   6f0 <free>
  return freep;
 807:	8b 15 80 0b 00 00    	mov    0xb80,%edx
      if((p = morecore(nunits)) == 0)
 80d:	83 c4 10             	add    $0x10,%esp
 810:	85 d2                	test   %edx,%edx
 812:	75 bc                	jne    7d0 <malloc+0x50>
        return 0;
  }
}
 814:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 817:	31 c0                	xor    %eax,%eax
}
 819:	5b                   	pop    %ebx
 81a:	5e                   	pop    %esi
 81b:	5f                   	pop    %edi
 81c:	5d                   	pop    %ebp
 81d:	c3                   	ret    
    if(p->s.size >= nunits){
 81e:	89 d0                	mov    %edx,%eax
 820:	89 fa                	mov    %edi,%edx
 822:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 828:	39 ce                	cmp    %ecx,%esi
 82a:	74 54                	je     880 <malloc+0x100>
        p->s.size -= nunits;
 82c:	29 f1                	sub    %esi,%ecx
 82e:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 831:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 834:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 837:	89 15 80 0b 00 00    	mov    %edx,0xb80
}
 83d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 840:	83 c0 08             	add    $0x8,%eax
}
 843:	5b                   	pop    %ebx
 844:	5e                   	pop    %esi
 845:	5f                   	pop    %edi
 846:	5d                   	pop    %ebp
 847:	c3                   	ret    
 848:	90                   	nop
 849:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
 850:	c7 05 80 0b 00 00 84 	movl   $0xb84,0xb80
 857:	0b 00 00 
    base.s.size = 0;
 85a:	bf 84 0b 00 00       	mov    $0xb84,%edi
    base.s.ptr = freep = prevp = &base;
 85f:	c7 05 84 0b 00 00 84 	movl   $0xb84,0xb84
 866:	0b 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 869:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
 86b:	c7 05 88 0b 00 00 00 	movl   $0x0,0xb88
 872:	00 00 00 
    if(p->s.size >= nunits){
 875:	e9 32 ff ff ff       	jmp    7ac <malloc+0x2c>
 87a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 880:	8b 08                	mov    (%eax),%ecx
 882:	89 0a                	mov    %ecx,(%edx)
 884:	eb b1                	jmp    837 <malloc+0xb7>
