
_ps:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "user.h"
#include "fcntl.h"

int 
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
    cps();
   6:	e8 f6 02 00 00       	call   301 <cps>

    exit();
   b:	e8 51 02 00 00       	call   261 <exit>

00000010 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  10:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  11:	31 d2                	xor    %edx,%edx
{
  13:	89 e5                	mov    %esp,%ebp
  15:	53                   	push   %ebx
  16:	8b 45 08             	mov    0x8(%ebp),%eax
  19:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
  20:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  24:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  27:	83 c2 01             	add    $0x1,%edx
  2a:	84 c9                	test   %cl,%cl
  2c:	75 f2                	jne    20 <strcpy+0x10>
    ;
  return os;
}
  2e:	5b                   	pop    %ebx
  2f:	5d                   	pop    %ebp
  30:	c3                   	ret    
  31:	eb 0d                	jmp    40 <strcmp>
  33:	90                   	nop
  34:	90                   	nop
  35:	90                   	nop
  36:	90                   	nop
  37:	90                   	nop
  38:	90                   	nop
  39:	90                   	nop
  3a:	90                   	nop
  3b:	90                   	nop
  3c:	90                   	nop
  3d:	90                   	nop
  3e:	90                   	nop
  3f:	90                   	nop

00000040 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  40:	55                   	push   %ebp
  41:	89 e5                	mov    %esp,%ebp
  43:	56                   	push   %esi
  44:	53                   	push   %ebx
  45:	8b 5d 08             	mov    0x8(%ebp),%ebx
  48:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(*p && *p == *q)
  4b:	0f b6 13             	movzbl (%ebx),%edx
  4e:	0f b6 0e             	movzbl (%esi),%ecx
  51:	84 d2                	test   %dl,%dl
  53:	74 1e                	je     73 <strcmp+0x33>
  55:	b8 01 00 00 00       	mov    $0x1,%eax
  5a:	38 ca                	cmp    %cl,%dl
  5c:	74 09                	je     67 <strcmp+0x27>
  5e:	eb 20                	jmp    80 <strcmp+0x40>
  60:	83 c0 01             	add    $0x1,%eax
  63:	38 ca                	cmp    %cl,%dl
  65:	75 19                	jne    80 <strcmp+0x40>
  67:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  6b:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
  6f:	84 d2                	test   %dl,%dl
  71:	75 ed                	jne    60 <strcmp+0x20>
  73:	31 c0                	xor    %eax,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
  75:	5b                   	pop    %ebx
  76:	5e                   	pop    %esi
  return (uchar)*p - (uchar)*q;
  77:	29 c8                	sub    %ecx,%eax
}
  79:	5d                   	pop    %ebp
  7a:	c3                   	ret    
  7b:	90                   	nop
  7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  80:	0f b6 c2             	movzbl %dl,%eax
  83:	5b                   	pop    %ebx
  84:	5e                   	pop    %esi
  return (uchar)*p - (uchar)*q;
  85:	29 c8                	sub    %ecx,%eax
}
  87:	5d                   	pop    %ebp
  88:	c3                   	ret    
  89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000090 <strlen>:

uint
strlen(char *s)
{
  90:	55                   	push   %ebp
  91:	89 e5                	mov    %esp,%ebp
  93:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  96:	80 39 00             	cmpb   $0x0,(%ecx)
  99:	74 15                	je     b0 <strlen+0x20>
  9b:	31 d2                	xor    %edx,%edx
  9d:	8d 76 00             	lea    0x0(%esi),%esi
  a0:	83 c2 01             	add    $0x1,%edx
  a3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  a7:	89 d0                	mov    %edx,%eax
  a9:	75 f5                	jne    a0 <strlen+0x10>
    ;
  return n;
}
  ab:	5d                   	pop    %ebp
  ac:	c3                   	ret    
  ad:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
  b0:	31 c0                	xor    %eax,%eax
}
  b2:	5d                   	pop    %ebp
  b3:	c3                   	ret    
  b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000000c0 <memset>:

void*
memset(void *dst, int c, uint n)
{
  c0:	55                   	push   %ebp
  c1:	89 e5                	mov    %esp,%ebp
  c3:	57                   	push   %edi
  c4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  c7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  cd:	89 d7                	mov    %edx,%edi
  cf:	fc                   	cld    
  d0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  d2:	89 d0                	mov    %edx,%eax
  d4:	5f                   	pop    %edi
  d5:	5d                   	pop    %ebp
  d6:	c3                   	ret    
  d7:	89 f6                	mov    %esi,%esi
  d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000000e0 <strchr>:

char*
strchr(const char *s, char c)
{
  e0:	55                   	push   %ebp
  e1:	89 e5                	mov    %esp,%ebp
  e3:	53                   	push   %ebx
  e4:	8b 45 08             	mov    0x8(%ebp),%eax
  e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  for(; *s; s++)
  ea:	0f b6 18             	movzbl (%eax),%ebx
  ed:	84 db                	test   %bl,%bl
  ef:	74 1d                	je     10e <strchr+0x2e>
  f1:	89 d1                	mov    %edx,%ecx
    if(*s == c)
  f3:	38 d3                	cmp    %dl,%bl
  f5:	75 0d                	jne    104 <strchr+0x24>
  f7:	eb 17                	jmp    110 <strchr+0x30>
  f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 100:	38 ca                	cmp    %cl,%dl
 102:	74 0c                	je     110 <strchr+0x30>
  for(; *s; s++)
 104:	83 c0 01             	add    $0x1,%eax
 107:	0f b6 10             	movzbl (%eax),%edx
 10a:	84 d2                	test   %dl,%dl
 10c:	75 f2                	jne    100 <strchr+0x20>
      return (char*)s;
  return 0;
 10e:	31 c0                	xor    %eax,%eax
}
 110:	5b                   	pop    %ebx
 111:	5d                   	pop    %ebp
 112:	c3                   	ret    
 113:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 119:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000120 <gets>:

char*
gets(char *buf, int max)
{
 120:	55                   	push   %ebp
 121:	89 e5                	mov    %esp,%ebp
 123:	57                   	push   %edi
 124:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 125:	31 f6                	xor    %esi,%esi
{
 127:	53                   	push   %ebx
 128:	89 f3                	mov    %esi,%ebx
 12a:	83 ec 1c             	sub    $0x1c,%esp
 12d:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 130:	eb 2f                	jmp    161 <gets+0x41>
 132:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 138:	83 ec 04             	sub    $0x4,%esp
 13b:	8d 45 e7             	lea    -0x19(%ebp),%eax
 13e:	6a 01                	push   $0x1
 140:	50                   	push   %eax
 141:	6a 00                	push   $0x0
 143:	e8 31 01 00 00       	call   279 <read>
    if(cc < 1)
 148:	83 c4 10             	add    $0x10,%esp
 14b:	85 c0                	test   %eax,%eax
 14d:	7e 1c                	jle    16b <gets+0x4b>
      break;
    buf[i++] = c;
 14f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 153:	83 c7 01             	add    $0x1,%edi
 156:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 159:	3c 0a                	cmp    $0xa,%al
 15b:	74 23                	je     180 <gets+0x60>
 15d:	3c 0d                	cmp    $0xd,%al
 15f:	74 1f                	je     180 <gets+0x60>
  for(i=0; i+1 < max; ){
 161:	83 c3 01             	add    $0x1,%ebx
 164:	89 fe                	mov    %edi,%esi
 166:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 169:	7c cd                	jl     138 <gets+0x18>
 16b:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 16d:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 170:	c6 03 00             	movb   $0x0,(%ebx)
}
 173:	8d 65 f4             	lea    -0xc(%ebp),%esp
 176:	5b                   	pop    %ebx
 177:	5e                   	pop    %esi
 178:	5f                   	pop    %edi
 179:	5d                   	pop    %ebp
 17a:	c3                   	ret    
 17b:	90                   	nop
 17c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 180:	8b 75 08             	mov    0x8(%ebp),%esi
 183:	8b 45 08             	mov    0x8(%ebp),%eax
 186:	01 de                	add    %ebx,%esi
 188:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 18a:	c6 03 00             	movb   $0x0,(%ebx)
}
 18d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 190:	5b                   	pop    %ebx
 191:	5e                   	pop    %esi
 192:	5f                   	pop    %edi
 193:	5d                   	pop    %ebp
 194:	c3                   	ret    
 195:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 199:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000001a0 <stat>:

int
stat(char *n, struct stat *st)
{
 1a0:	55                   	push   %ebp
 1a1:	89 e5                	mov    %esp,%ebp
 1a3:	56                   	push   %esi
 1a4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1a5:	83 ec 08             	sub    $0x8,%esp
 1a8:	6a 00                	push   $0x0
 1aa:	ff 75 08             	pushl  0x8(%ebp)
 1ad:	e8 ef 00 00 00       	call   2a1 <open>
  if(fd < 0)
 1b2:	83 c4 10             	add    $0x10,%esp
 1b5:	85 c0                	test   %eax,%eax
 1b7:	78 27                	js     1e0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 1b9:	83 ec 08             	sub    $0x8,%esp
 1bc:	ff 75 0c             	pushl  0xc(%ebp)
 1bf:	89 c3                	mov    %eax,%ebx
 1c1:	50                   	push   %eax
 1c2:	e8 f2 00 00 00       	call   2b9 <fstat>
  close(fd);
 1c7:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 1ca:	89 c6                	mov    %eax,%esi
  close(fd);
 1cc:	e8 b8 00 00 00       	call   289 <close>
  return r;
 1d1:	83 c4 10             	add    $0x10,%esp
}
 1d4:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1d7:	89 f0                	mov    %esi,%eax
 1d9:	5b                   	pop    %ebx
 1da:	5e                   	pop    %esi
 1db:	5d                   	pop    %ebp
 1dc:	c3                   	ret    
 1dd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 1e0:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1e5:	eb ed                	jmp    1d4 <stat+0x34>
 1e7:	89 f6                	mov    %esi,%esi
 1e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000001f0 <atoi>:

int
atoi(const char *s)
{
 1f0:	55                   	push   %ebp
 1f1:	89 e5                	mov    %esp,%ebp
 1f3:	53                   	push   %ebx
 1f4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1f7:	0f be 11             	movsbl (%ecx),%edx
 1fa:	8d 42 d0             	lea    -0x30(%edx),%eax
 1fd:	3c 09                	cmp    $0x9,%al
  n = 0;
 1ff:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 204:	77 1f                	ja     225 <atoi+0x35>
 206:	8d 76 00             	lea    0x0(%esi),%esi
 209:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 210:	83 c1 01             	add    $0x1,%ecx
 213:	8d 04 80             	lea    (%eax,%eax,4),%eax
 216:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 21a:	0f be 11             	movsbl (%ecx),%edx
 21d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 220:	80 fb 09             	cmp    $0x9,%bl
 223:	76 eb                	jbe    210 <atoi+0x20>
  return n;
}
 225:	5b                   	pop    %ebx
 226:	5d                   	pop    %ebp
 227:	c3                   	ret    
 228:	90                   	nop
 229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000230 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 230:	55                   	push   %ebp
 231:	89 e5                	mov    %esp,%ebp
 233:	57                   	push   %edi
 234:	8b 55 10             	mov    0x10(%ebp),%edx
 237:	8b 45 08             	mov    0x8(%ebp),%eax
 23a:	56                   	push   %esi
 23b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 23e:	85 d2                	test   %edx,%edx
 240:	7e 13                	jle    255 <memmove+0x25>
 242:	01 c2                	add    %eax,%edx
  dst = vdst;
 244:	89 c7                	mov    %eax,%edi
 246:	8d 76 00             	lea    0x0(%esi),%esi
 249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    *dst++ = *src++;
 250:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 251:	39 fa                	cmp    %edi,%edx
 253:	75 fb                	jne    250 <memmove+0x20>
  return vdst;
}
 255:	5e                   	pop    %esi
 256:	5f                   	pop    %edi
 257:	5d                   	pop    %ebp
 258:	c3                   	ret    

00000259 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 259:	b8 01 00 00 00       	mov    $0x1,%eax
 25e:	cd 40                	int    $0x40
 260:	c3                   	ret    

00000261 <exit>:
SYSCALL(exit)
 261:	b8 02 00 00 00       	mov    $0x2,%eax
 266:	cd 40                	int    $0x40
 268:	c3                   	ret    

00000269 <wait>:
SYSCALL(wait)
 269:	b8 03 00 00 00       	mov    $0x3,%eax
 26e:	cd 40                	int    $0x40
 270:	c3                   	ret    

00000271 <pipe>:
SYSCALL(pipe)
 271:	b8 04 00 00 00       	mov    $0x4,%eax
 276:	cd 40                	int    $0x40
 278:	c3                   	ret    

00000279 <read>:
SYSCALL(read)
 279:	b8 05 00 00 00       	mov    $0x5,%eax
 27e:	cd 40                	int    $0x40
 280:	c3                   	ret    

00000281 <write>:
SYSCALL(write)
 281:	b8 10 00 00 00       	mov    $0x10,%eax
 286:	cd 40                	int    $0x40
 288:	c3                   	ret    

00000289 <close>:
SYSCALL(close)
 289:	b8 15 00 00 00       	mov    $0x15,%eax
 28e:	cd 40                	int    $0x40
 290:	c3                   	ret    

00000291 <kill>:
SYSCALL(kill)
 291:	b8 06 00 00 00       	mov    $0x6,%eax
 296:	cd 40                	int    $0x40
 298:	c3                   	ret    

00000299 <exec>:
SYSCALL(exec)
 299:	b8 07 00 00 00       	mov    $0x7,%eax
 29e:	cd 40                	int    $0x40
 2a0:	c3                   	ret    

000002a1 <open>:
SYSCALL(open)
 2a1:	b8 0f 00 00 00       	mov    $0xf,%eax
 2a6:	cd 40                	int    $0x40
 2a8:	c3                   	ret    

000002a9 <mknod>:
SYSCALL(mknod)
 2a9:	b8 11 00 00 00       	mov    $0x11,%eax
 2ae:	cd 40                	int    $0x40
 2b0:	c3                   	ret    

000002b1 <unlink>:
SYSCALL(unlink)
 2b1:	b8 12 00 00 00       	mov    $0x12,%eax
 2b6:	cd 40                	int    $0x40
 2b8:	c3                   	ret    

000002b9 <fstat>:
SYSCALL(fstat)
 2b9:	b8 08 00 00 00       	mov    $0x8,%eax
 2be:	cd 40                	int    $0x40
 2c0:	c3                   	ret    

000002c1 <link>:
SYSCALL(link)
 2c1:	b8 13 00 00 00       	mov    $0x13,%eax
 2c6:	cd 40                	int    $0x40
 2c8:	c3                   	ret    

000002c9 <mkdir>:
SYSCALL(mkdir)
 2c9:	b8 14 00 00 00       	mov    $0x14,%eax
 2ce:	cd 40                	int    $0x40
 2d0:	c3                   	ret    

000002d1 <chdir>:
SYSCALL(chdir)
 2d1:	b8 09 00 00 00       	mov    $0x9,%eax
 2d6:	cd 40                	int    $0x40
 2d8:	c3                   	ret    

000002d9 <dup>:
SYSCALL(dup)
 2d9:	b8 0a 00 00 00       	mov    $0xa,%eax
 2de:	cd 40                	int    $0x40
 2e0:	c3                   	ret    

000002e1 <getpid>:
SYSCALL(getpid)
 2e1:	b8 0b 00 00 00       	mov    $0xb,%eax
 2e6:	cd 40                	int    $0x40
 2e8:	c3                   	ret    

000002e9 <sbrk>:
SYSCALL(sbrk)
 2e9:	b8 0c 00 00 00       	mov    $0xc,%eax
 2ee:	cd 40                	int    $0x40
 2f0:	c3                   	ret    

000002f1 <sleep>:
SYSCALL(sleep)
 2f1:	b8 0d 00 00 00       	mov    $0xd,%eax
 2f6:	cd 40                	int    $0x40
 2f8:	c3                   	ret    

000002f9 <uptime>:
SYSCALL(uptime)
 2f9:	b8 0e 00 00 00       	mov    $0xe,%eax
 2fe:	cd 40                	int    $0x40
 300:	c3                   	ret    

00000301 <cps>:
SYSCALL(cps)
 301:	b8 16 00 00 00       	mov    $0x16,%eax
 306:	cd 40                	int    $0x40
 308:	c3                   	ret    
 309:	66 90                	xchg   %ax,%ax
 30b:	66 90                	xchg   %ax,%ax
 30d:	66 90                	xchg   %ax,%ax
 30f:	90                   	nop

00000310 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 310:	55                   	push   %ebp
 311:	89 e5                	mov    %esp,%ebp
 313:	57                   	push   %edi
 314:	56                   	push   %esi
 315:	53                   	push   %ebx
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 316:	89 d3                	mov    %edx,%ebx
{
 318:	83 ec 3c             	sub    $0x3c,%esp
 31b:	89 45 bc             	mov    %eax,-0x44(%ebp)
  if(sgn && xx < 0){
 31e:	85 d2                	test   %edx,%edx
 320:	0f 89 92 00 00 00    	jns    3b8 <printint+0xa8>
 326:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 32a:	0f 84 88 00 00 00    	je     3b8 <printint+0xa8>
    neg = 1;
 330:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
    x = -xx;
 337:	f7 db                	neg    %ebx
  } else {
    x = xx;
  }

  i = 0;
 339:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 340:	8d 75 d7             	lea    -0x29(%ebp),%esi
 343:	eb 08                	jmp    34d <printint+0x3d>
 345:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 348:	89 7d c4             	mov    %edi,-0x3c(%ebp)
  }while((x /= base) != 0);
 34b:	89 c3                	mov    %eax,%ebx
    buf[i++] = digits[x % base];
 34d:	89 d8                	mov    %ebx,%eax
 34f:	31 d2                	xor    %edx,%edx
 351:	8b 7d c4             	mov    -0x3c(%ebp),%edi
 354:	f7 f1                	div    %ecx
 356:	83 c7 01             	add    $0x1,%edi
 359:	0f b6 92 40 07 00 00 	movzbl 0x740(%edx),%edx
 360:	88 14 3e             	mov    %dl,(%esi,%edi,1)
  }while((x /= base) != 0);
 363:	39 d9                	cmp    %ebx,%ecx
 365:	76 e1                	jbe    348 <printint+0x38>
  if(neg)
 367:	8b 45 c0             	mov    -0x40(%ebp),%eax
 36a:	85 c0                	test   %eax,%eax
 36c:	74 0d                	je     37b <printint+0x6b>
    buf[i++] = '-';
 36e:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 373:	ba 2d 00 00 00       	mov    $0x2d,%edx
    buf[i++] = digits[x % base];
 378:	89 7d c4             	mov    %edi,-0x3c(%ebp)
 37b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 37e:	8b 7d bc             	mov    -0x44(%ebp),%edi
 381:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 385:	eb 0f                	jmp    396 <printint+0x86>
 387:	89 f6                	mov    %esi,%esi
 389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 390:	0f b6 13             	movzbl (%ebx),%edx
 393:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 396:	83 ec 04             	sub    $0x4,%esp
 399:	88 55 d7             	mov    %dl,-0x29(%ebp)
 39c:	6a 01                	push   $0x1
 39e:	56                   	push   %esi
 39f:	57                   	push   %edi
 3a0:	e8 dc fe ff ff       	call   281 <write>

  while(--i >= 0)
 3a5:	83 c4 10             	add    $0x10,%esp
 3a8:	39 de                	cmp    %ebx,%esi
 3aa:	75 e4                	jne    390 <printint+0x80>
    putc(fd, buf[i]);
}
 3ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3af:	5b                   	pop    %ebx
 3b0:	5e                   	pop    %esi
 3b1:	5f                   	pop    %edi
 3b2:	5d                   	pop    %ebp
 3b3:	c3                   	ret    
 3b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 3b8:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
 3bf:	e9 75 ff ff ff       	jmp    339 <printint+0x29>
 3c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 3ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000003d0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 3d0:	55                   	push   %ebp
 3d1:	89 e5                	mov    %esp,%ebp
 3d3:	57                   	push   %edi
 3d4:	56                   	push   %esi
 3d5:	53                   	push   %ebx
 3d6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 3d9:	8b 75 0c             	mov    0xc(%ebp),%esi
 3dc:	0f b6 1e             	movzbl (%esi),%ebx
 3df:	84 db                	test   %bl,%bl
 3e1:	0f 84 b9 00 00 00    	je     4a0 <printf+0xd0>
  ap = (uint*)(void*)&fmt + 1;
 3e7:	8d 45 10             	lea    0x10(%ebp),%eax
 3ea:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 3ed:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 3f0:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
 3f2:	89 45 d0             	mov    %eax,-0x30(%ebp)
 3f5:	eb 38                	jmp    42f <printf+0x5f>
 3f7:	89 f6                	mov    %esi,%esi
 3f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 400:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 403:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 408:	83 f8 25             	cmp    $0x25,%eax
 40b:	74 17                	je     424 <printf+0x54>
  write(fd, &c, 1);
 40d:	83 ec 04             	sub    $0x4,%esp
 410:	88 5d e7             	mov    %bl,-0x19(%ebp)
 413:	6a 01                	push   $0x1
 415:	57                   	push   %edi
 416:	ff 75 08             	pushl  0x8(%ebp)
 419:	e8 63 fe ff ff       	call   281 <write>
 41e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 421:	83 c4 10             	add    $0x10,%esp
 424:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 427:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 42b:	84 db                	test   %bl,%bl
 42d:	74 71                	je     4a0 <printf+0xd0>
    c = fmt[i] & 0xff;
 42f:	0f be cb             	movsbl %bl,%ecx
 432:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 435:	85 d2                	test   %edx,%edx
 437:	74 c7                	je     400 <printf+0x30>
      }
    } else if(state == '%'){
 439:	83 fa 25             	cmp    $0x25,%edx
 43c:	75 e6                	jne    424 <printf+0x54>
      if(c == 'd'){
 43e:	83 f8 64             	cmp    $0x64,%eax
 441:	0f 84 99 00 00 00    	je     4e0 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 447:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 44d:	83 f9 70             	cmp    $0x70,%ecx
 450:	74 5e                	je     4b0 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 452:	83 f8 73             	cmp    $0x73,%eax
 455:	0f 84 d5 00 00 00    	je     530 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 45b:	83 f8 63             	cmp    $0x63,%eax
 45e:	0f 84 8c 00 00 00    	je     4f0 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 464:	83 f8 25             	cmp    $0x25,%eax
 467:	0f 84 b3 00 00 00    	je     520 <printf+0x150>
  write(fd, &c, 1);
 46d:	83 ec 04             	sub    $0x4,%esp
 470:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 474:	6a 01                	push   $0x1
 476:	57                   	push   %edi
 477:	ff 75 08             	pushl  0x8(%ebp)
 47a:	e8 02 fe ff ff       	call   281 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 47f:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 482:	83 c4 0c             	add    $0xc,%esp
 485:	6a 01                	push   $0x1
 487:	83 c6 01             	add    $0x1,%esi
 48a:	57                   	push   %edi
 48b:	ff 75 08             	pushl  0x8(%ebp)
 48e:	e8 ee fd ff ff       	call   281 <write>
  for(i = 0; fmt[i]; i++){
 493:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
 497:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 49a:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 49c:	84 db                	test   %bl,%bl
 49e:	75 8f                	jne    42f <printf+0x5f>
    }
  }
}
 4a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4a3:	5b                   	pop    %ebx
 4a4:	5e                   	pop    %esi
 4a5:	5f                   	pop    %edi
 4a6:	5d                   	pop    %ebp
 4a7:	c3                   	ret    
 4a8:	90                   	nop
 4a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 16, 0);
 4b0:	83 ec 0c             	sub    $0xc,%esp
 4b3:	b9 10 00 00 00       	mov    $0x10,%ecx
 4b8:	6a 00                	push   $0x0
 4ba:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 4bd:	8b 45 08             	mov    0x8(%ebp),%eax
 4c0:	8b 13                	mov    (%ebx),%edx
 4c2:	e8 49 fe ff ff       	call   310 <printint>
        ap++;
 4c7:	89 d8                	mov    %ebx,%eax
 4c9:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4cc:	31 d2                	xor    %edx,%edx
        ap++;
 4ce:	83 c0 04             	add    $0x4,%eax
 4d1:	89 45 d0             	mov    %eax,-0x30(%ebp)
 4d4:	e9 4b ff ff ff       	jmp    424 <printf+0x54>
 4d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
 4e0:	83 ec 0c             	sub    $0xc,%esp
 4e3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 4e8:	6a 01                	push   $0x1
 4ea:	eb ce                	jmp    4ba <printf+0xea>
 4ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
 4f0:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 4f3:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 4f6:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
 4f8:	6a 01                	push   $0x1
        ap++;
 4fa:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
 4fd:	57                   	push   %edi
 4fe:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
 501:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 504:	e8 78 fd ff ff       	call   281 <write>
        ap++;
 509:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 50c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 50f:	31 d2                	xor    %edx,%edx
 511:	e9 0e ff ff ff       	jmp    424 <printf+0x54>
 516:	8d 76 00             	lea    0x0(%esi),%esi
 519:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        putc(fd, c);
 520:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 523:	83 ec 04             	sub    $0x4,%esp
 526:	e9 5a ff ff ff       	jmp    485 <printf+0xb5>
 52b:	90                   	nop
 52c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 530:	8b 45 d0             	mov    -0x30(%ebp),%eax
 533:	8b 18                	mov    (%eax),%ebx
        ap++;
 535:	83 c0 04             	add    $0x4,%eax
 538:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 53b:	85 db                	test   %ebx,%ebx
 53d:	74 17                	je     556 <printf+0x186>
        while(*s != 0){
 53f:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 542:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 544:	84 c0                	test   %al,%al
 546:	0f 84 d8 fe ff ff    	je     424 <printf+0x54>
 54c:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 54f:	89 de                	mov    %ebx,%esi
 551:	8b 5d 08             	mov    0x8(%ebp),%ebx
 554:	eb 1a                	jmp    570 <printf+0x1a0>
          s = "(null)";
 556:	bb 38 07 00 00       	mov    $0x738,%ebx
        while(*s != 0){
 55b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 55e:	b8 28 00 00 00       	mov    $0x28,%eax
 563:	89 de                	mov    %ebx,%esi
 565:	8b 5d 08             	mov    0x8(%ebp),%ebx
 568:	90                   	nop
 569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  write(fd, &c, 1);
 570:	83 ec 04             	sub    $0x4,%esp
          s++;
 573:	83 c6 01             	add    $0x1,%esi
 576:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 579:	6a 01                	push   $0x1
 57b:	57                   	push   %edi
 57c:	53                   	push   %ebx
 57d:	e8 ff fc ff ff       	call   281 <write>
        while(*s != 0){
 582:	0f b6 06             	movzbl (%esi),%eax
 585:	83 c4 10             	add    $0x10,%esp
 588:	84 c0                	test   %al,%al
 58a:	75 e4                	jne    570 <printf+0x1a0>
 58c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 58f:	31 d2                	xor    %edx,%edx
 591:	e9 8e fe ff ff       	jmp    424 <printf+0x54>
 596:	66 90                	xchg   %ax,%ax
 598:	66 90                	xchg   %ax,%ax
 59a:	66 90                	xchg   %ax,%ax
 59c:	66 90                	xchg   %ax,%ax
 59e:	66 90                	xchg   %ax,%ax

000005a0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5a0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5a1:	a1 e0 09 00 00       	mov    0x9e0,%eax
{
 5a6:	89 e5                	mov    %esp,%ebp
 5a8:	57                   	push   %edi
 5a9:	56                   	push   %esi
 5aa:	53                   	push   %ebx
 5ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
 5ae:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
 5b0:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5b3:	39 c8                	cmp    %ecx,%eax
 5b5:	73 19                	jae    5d0 <free+0x30>
 5b7:	89 f6                	mov    %esi,%esi
 5b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 5c0:	39 d1                	cmp    %edx,%ecx
 5c2:	72 14                	jb     5d8 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5c4:	39 d0                	cmp    %edx,%eax
 5c6:	73 10                	jae    5d8 <free+0x38>
{
 5c8:	89 d0                	mov    %edx,%eax
 5ca:	8b 10                	mov    (%eax),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5cc:	39 c8                	cmp    %ecx,%eax
 5ce:	72 f0                	jb     5c0 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5d0:	39 d0                	cmp    %edx,%eax
 5d2:	72 f4                	jb     5c8 <free+0x28>
 5d4:	39 d1                	cmp    %edx,%ecx
 5d6:	73 f0                	jae    5c8 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
 5d8:	8b 73 fc             	mov    -0x4(%ebx),%esi
 5db:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 5de:	39 fa                	cmp    %edi,%edx
 5e0:	74 1e                	je     600 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 5e2:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 5e5:	8b 50 04             	mov    0x4(%eax),%edx
 5e8:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 5eb:	39 f1                	cmp    %esi,%ecx
 5ed:	74 28                	je     617 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 5ef:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
 5f1:	5b                   	pop    %ebx
  freep = p;
 5f2:	a3 e0 09 00 00       	mov    %eax,0x9e0
}
 5f7:	5e                   	pop    %esi
 5f8:	5f                   	pop    %edi
 5f9:	5d                   	pop    %ebp
 5fa:	c3                   	ret    
 5fb:	90                   	nop
 5fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 600:	03 72 04             	add    0x4(%edx),%esi
 603:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 606:	8b 10                	mov    (%eax),%edx
 608:	8b 12                	mov    (%edx),%edx
 60a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 60d:	8b 50 04             	mov    0x4(%eax),%edx
 610:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 613:	39 f1                	cmp    %esi,%ecx
 615:	75 d8                	jne    5ef <free+0x4f>
    p->s.size += bp->s.size;
 617:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 61a:	a3 e0 09 00 00       	mov    %eax,0x9e0
    p->s.size += bp->s.size;
 61f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 622:	8b 53 f8             	mov    -0x8(%ebx),%edx
 625:	89 10                	mov    %edx,(%eax)
}
 627:	5b                   	pop    %ebx
 628:	5e                   	pop    %esi
 629:	5f                   	pop    %edi
 62a:	5d                   	pop    %ebp
 62b:	c3                   	ret    
 62c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000630 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 630:	55                   	push   %ebp
 631:	89 e5                	mov    %esp,%ebp
 633:	57                   	push   %edi
 634:	56                   	push   %esi
 635:	53                   	push   %ebx
 636:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 639:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 63c:	8b 3d e0 09 00 00    	mov    0x9e0,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 642:	8d 70 07             	lea    0x7(%eax),%esi
 645:	c1 ee 03             	shr    $0x3,%esi
 648:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 64b:	85 ff                	test   %edi,%edi
 64d:	0f 84 ad 00 00 00    	je     700 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 653:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
 655:	8b 4a 04             	mov    0x4(%edx),%ecx
 658:	39 ce                	cmp    %ecx,%esi
 65a:	76 72                	jbe    6ce <malloc+0x9e>
 65c:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 662:	bb 00 10 00 00       	mov    $0x1000,%ebx
 667:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 66a:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 671:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 674:	eb 1b                	jmp    691 <malloc+0x61>
 676:	8d 76 00             	lea    0x0(%esi),%esi
 679:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 680:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 682:	8b 48 04             	mov    0x4(%eax),%ecx
 685:	39 f1                	cmp    %esi,%ecx
 687:	73 4f                	jae    6d8 <malloc+0xa8>
 689:	8b 3d e0 09 00 00    	mov    0x9e0,%edi
 68f:	89 c2                	mov    %eax,%edx
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 691:	39 d7                	cmp    %edx,%edi
 693:	75 eb                	jne    680 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
 695:	83 ec 0c             	sub    $0xc,%esp
 698:	ff 75 e4             	pushl  -0x1c(%ebp)
 69b:	e8 49 fc ff ff       	call   2e9 <sbrk>
  if(p == (char*)-1)
 6a0:	83 c4 10             	add    $0x10,%esp
 6a3:	83 f8 ff             	cmp    $0xffffffff,%eax
 6a6:	74 1c                	je     6c4 <malloc+0x94>
  hp->s.size = nu;
 6a8:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 6ab:	83 ec 0c             	sub    $0xc,%esp
 6ae:	83 c0 08             	add    $0x8,%eax
 6b1:	50                   	push   %eax
 6b2:	e8 e9 fe ff ff       	call   5a0 <free>
  return freep;
 6b7:	8b 15 e0 09 00 00    	mov    0x9e0,%edx
      if((p = morecore(nunits)) == 0)
 6bd:	83 c4 10             	add    $0x10,%esp
 6c0:	85 d2                	test   %edx,%edx
 6c2:	75 bc                	jne    680 <malloc+0x50>
        return 0;
  }
}
 6c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 6c7:	31 c0                	xor    %eax,%eax
}
 6c9:	5b                   	pop    %ebx
 6ca:	5e                   	pop    %esi
 6cb:	5f                   	pop    %edi
 6cc:	5d                   	pop    %ebp
 6cd:	c3                   	ret    
    if(p->s.size >= nunits){
 6ce:	89 d0                	mov    %edx,%eax
 6d0:	89 fa                	mov    %edi,%edx
 6d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 6d8:	39 ce                	cmp    %ecx,%esi
 6da:	74 54                	je     730 <malloc+0x100>
        p->s.size -= nunits;
 6dc:	29 f1                	sub    %esi,%ecx
 6de:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 6e1:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 6e4:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 6e7:	89 15 e0 09 00 00    	mov    %edx,0x9e0
}
 6ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 6f0:	83 c0 08             	add    $0x8,%eax
}
 6f3:	5b                   	pop    %ebx
 6f4:	5e                   	pop    %esi
 6f5:	5f                   	pop    %edi
 6f6:	5d                   	pop    %ebp
 6f7:	c3                   	ret    
 6f8:	90                   	nop
 6f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
 700:	c7 05 e0 09 00 00 e4 	movl   $0x9e4,0x9e0
 707:	09 00 00 
    base.s.size = 0;
 70a:	bf e4 09 00 00       	mov    $0x9e4,%edi
    base.s.ptr = freep = prevp = &base;
 70f:	c7 05 e4 09 00 00 e4 	movl   $0x9e4,0x9e4
 716:	09 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 719:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
 71b:	c7 05 e8 09 00 00 00 	movl   $0x0,0x9e8
 722:	00 00 00 
    if(p->s.size >= nunits){
 725:	e9 32 ff ff ff       	jmp    65c <malloc+0x2c>
 72a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 730:	8b 08                	mov    (%eax),%ecx
 732:	89 0a                	mov    %ecx,(%edx)
 734:	eb b1                	jmp    6e7 <malloc+0xb7>
