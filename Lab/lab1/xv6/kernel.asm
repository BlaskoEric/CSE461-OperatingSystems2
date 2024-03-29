
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc c0 b5 10 80       	mov    $0x8010b5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 b0 2f 10 80       	mov    $0x80102fb0,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 20 70 10 80       	push   $0x80107020
80100051:	68 c0 b5 10 80       	push   $0x8010b5c0
80100056:	e8 55 43 00 00       	call   801043b0 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	ba bc fc 10 80       	mov    $0x8010fcbc,%edx
  bcache.head.prev = &bcache.head;
80100063:	c7 05 0c fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd0c
8010006a:	fc 10 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 10 fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd10
80100074:	fc 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	83 ec 08             	sub    $0x8,%esp
80100085:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 27 70 10 80       	push   $0x80107027
80100097:	50                   	push   %eax
80100098:	e8 03 42 00 00       	call   801042a0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
801000a2:	89 da                	mov    %ebx,%edx
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a4:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d bc fc 10 80       	cmp    $0x8010fcbc,%eax
801000bb:	75 c3                	jne    80100080 <binit+0x40>
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 7d 08             	mov    0x8(%ebp),%edi
801000dc:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&bcache.lock);
801000df:	68 c0 b5 10 80       	push   $0x8010b5c0
801000e4:	e8 c7 43 00 00       	call   801044b0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 10 fd 10 80    	mov    0x8010fd10,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 7b 04             	cmp    0x4(%ebx),%edi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 73 08             	cmp    0x8(%ebx),%esi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c fd 10 80    	mov    0x8010fd0c,%ebx
80100126:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 70                	jmp    801001a0 <bread+0xd0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100139:	74 65                	je     801001a0 <bread+0xd0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 7b 04             	mov    %edi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 73 08             	mov    %esi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 c0 b5 10 80       	push   $0x8010b5c0
80100162:	e8 69 44 00 00       	call   801045d0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 6e 41 00 00       	call   801042e0 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 6f 20 00 00       	call   80102200 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
8010019e:	66 90                	xchg   %ax,%ax
  panic("bget: no buffers");
801001a0:	83 ec 0c             	sub    $0xc,%esp
801001a3:	68 2e 70 10 80       	push   $0x8010702e
801001a8:	e8 e3 01 00 00       	call   80100390 <panic>
801001ad:	8d 76 00             	lea    0x0(%esi),%esi

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	55                   	push   %ebp
801001b1:	89 e5                	mov    %esp,%ebp
801001b3:	53                   	push   %ebx
801001b4:	83 ec 10             	sub    $0x10,%esp
801001b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801001bd:	50                   	push   %eax
801001be:	e8 bd 41 00 00       	call   80104380 <holdingsleep>
801001c3:	83 c4 10             	add    $0x10,%esp
801001c6:	85 c0                	test   %eax,%eax
801001c8:	74 0f                	je     801001d9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ca:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001cd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d3:	c9                   	leave  
  iderw(b);
801001d4:	e9 27 20 00 00       	jmp    80102200 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 3f 70 10 80       	push   $0x8010703f
801001e1:	e8 aa 01 00 00       	call   80100390 <panic>
801001e6:	8d 76 00             	lea    0x0(%esi),%esi
801001e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	56                   	push   %esi
801001f4:	53                   	push   %ebx
801001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001f8:	8d 73 0c             	lea    0xc(%ebx),%esi
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 7c 41 00 00       	call   80104380 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 2c 41 00 00       	call   80104340 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010021b:	e8 90 42 00 00       	call   801044b0 <acquire>
  b->refcnt--;
80100220:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100223:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100226:	83 e8 01             	sub    $0x1,%eax
80100229:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010022c:	85 c0                	test   %eax,%eax
8010022e:	75 2f                	jne    8010025f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100230:	8b 43 54             	mov    0x54(%ebx),%eax
80100233:	8b 53 50             	mov    0x50(%ebx),%edx
80100236:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100239:	8b 43 50             	mov    0x50(%ebx),%eax
8010023c:	8b 53 54             	mov    0x54(%ebx),%edx
8010023f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100242:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
    b->prev = &bcache.head;
80100247:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    b->next = bcache.head.next;
8010024e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100251:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
80100256:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100259:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  }
  
  release(&bcache.lock);
8010025f:	c7 45 08 c0 b5 10 80 	movl   $0x8010b5c0,0x8(%ebp)
}
80100266:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100269:	5b                   	pop    %ebx
8010026a:	5e                   	pop    %esi
8010026b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010026c:	e9 5f 43 00 00       	jmp    801045d0 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 46 70 10 80       	push   $0x80107046
80100279:	e8 12 01 00 00       	call   80100390 <panic>
8010027e:	66 90                	xchg   %ax,%ax

80100280 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100280:	55                   	push   %ebp
80100281:	89 e5                	mov    %esp,%ebp
80100283:	57                   	push   %edi
80100284:	56                   	push   %esi
80100285:	53                   	push   %ebx
80100286:	83 ec 28             	sub    $0x28,%esp
  uint target;
  int c;

  iunlock(ip);
80100289:	ff 75 08             	pushl  0x8(%ebp)
{
8010028c:	8b 75 10             	mov    0x10(%ebp),%esi
  iunlock(ip);
8010028f:	e8 6c 15 00 00       	call   80101800 <iunlock>
  target = n;
  acquire(&cons.lock);
80100294:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010029b:	e8 10 42 00 00       	call   801044b0 <acquire>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002a0:	8b 7d 0c             	mov    0xc(%ebp),%edi
  while(n > 0){
801002a3:	83 c4 10             	add    $0x10,%esp
801002a6:	31 c0                	xor    %eax,%eax
    *dst++ = c;
801002a8:	01 f7                	add    %esi,%edi
  while(n > 0){
801002aa:	85 f6                	test   %esi,%esi
801002ac:	0f 8e a0 00 00 00    	jle    80100352 <consoleread+0xd2>
801002b2:	89 f3                	mov    %esi,%ebx
    while(input.r == input.w){
801002b4:	8b 15 a0 ff 10 80    	mov    0x8010ffa0,%edx
801002ba:	39 15 a4 ff 10 80    	cmp    %edx,0x8010ffa4
801002c0:	74 29                	je     801002eb <consoleread+0x6b>
801002c2:	eb 5c                	jmp    80100320 <consoleread+0xa0>
801002c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      sleep(&input.r, &cons.lock);
801002c8:	83 ec 08             	sub    $0x8,%esp
801002cb:	68 20 a5 10 80       	push   $0x8010a520
801002d0:	68 a0 ff 10 80       	push   $0x8010ffa0
801002d5:	e8 a6 3b 00 00       	call   80103e80 <sleep>
    while(input.r == input.w){
801002da:	8b 15 a0 ff 10 80    	mov    0x8010ffa0,%edx
801002e0:	83 c4 10             	add    $0x10,%esp
801002e3:	3b 15 a4 ff 10 80    	cmp    0x8010ffa4,%edx
801002e9:	75 35                	jne    80100320 <consoleread+0xa0>
      if(myproc()->killed){
801002eb:	e8 f0 35 00 00       	call   801038e0 <myproc>
801002f0:	8b 48 24             	mov    0x24(%eax),%ecx
801002f3:	85 c9                	test   %ecx,%ecx
801002f5:	74 d1                	je     801002c8 <consoleread+0x48>
        release(&cons.lock);
801002f7:	83 ec 0c             	sub    $0xc,%esp
801002fa:	68 20 a5 10 80       	push   $0x8010a520
801002ff:	e8 cc 42 00 00       	call   801045d0 <release>
        ilock(ip);
80100304:	5a                   	pop    %edx
80100305:	ff 75 08             	pushl  0x8(%ebp)
80100308:	e8 13 14 00 00       	call   80101720 <ilock>
        return -1;
8010030d:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100310:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100313:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100318:	5b                   	pop    %ebx
80100319:	5e                   	pop    %esi
8010031a:	5f                   	pop    %edi
8010031b:	5d                   	pop    %ebp
8010031c:	c3                   	ret    
8010031d:	8d 76 00             	lea    0x0(%esi),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100320:	8d 42 01             	lea    0x1(%edx),%eax
80100323:	a3 a0 ff 10 80       	mov    %eax,0x8010ffa0
80100328:	89 d0                	mov    %edx,%eax
8010032a:	83 e0 7f             	and    $0x7f,%eax
8010032d:	0f be 80 20 ff 10 80 	movsbl -0x7fef00e0(%eax),%eax
    if(c == C('D')){  // EOF
80100334:	83 f8 04             	cmp    $0x4,%eax
80100337:	74 46                	je     8010037f <consoleread+0xff>
    *dst++ = c;
80100339:	89 da                	mov    %ebx,%edx
    --n;
8010033b:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
8010033e:	f7 da                	neg    %edx
80100340:	88 04 17             	mov    %al,(%edi,%edx,1)
    if(c == '\n')
80100343:	83 f8 0a             	cmp    $0xa,%eax
80100346:	74 31                	je     80100379 <consoleread+0xf9>
  while(n > 0){
80100348:	85 db                	test   %ebx,%ebx
8010034a:	0f 85 64 ff ff ff    	jne    801002b4 <consoleread+0x34>
80100350:	89 f0                	mov    %esi,%eax
  release(&cons.lock);
80100352:	83 ec 0c             	sub    $0xc,%esp
80100355:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100358:	68 20 a5 10 80       	push   $0x8010a520
8010035d:	e8 6e 42 00 00       	call   801045d0 <release>
  ilock(ip);
80100362:	58                   	pop    %eax
80100363:	ff 75 08             	pushl  0x8(%ebp)
80100366:	e8 b5 13 00 00       	call   80101720 <ilock>
  return target - n;
8010036b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010036e:	83 c4 10             	add    $0x10,%esp
}
80100371:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100374:	5b                   	pop    %ebx
80100375:	5e                   	pop    %esi
80100376:	5f                   	pop    %edi
80100377:	5d                   	pop    %ebp
80100378:	c3                   	ret    
80100379:	89 f0                	mov    %esi,%eax
8010037b:	29 d8                	sub    %ebx,%eax
8010037d:	eb d3                	jmp    80100352 <consoleread+0xd2>
      if(n < target){
8010037f:	89 f0                	mov    %esi,%eax
80100381:	29 d8                	sub    %ebx,%eax
80100383:	39 f3                	cmp    %esi,%ebx
80100385:	73 cb                	jae    80100352 <consoleread+0xd2>
        input.r--;
80100387:	89 15 a0 ff 10 80    	mov    %edx,0x8010ffa0
8010038d:	eb c3                	jmp    80100352 <consoleread+0xd2>
8010038f:	90                   	nop

80100390 <panic>:
{
80100390:	55                   	push   %ebp
80100391:	89 e5                	mov    %esp,%ebp
80100393:	56                   	push   %esi
80100394:	53                   	push   %ebx
80100395:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100398:	fa                   	cli    
  cons.locking = 0;
80100399:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
801003a0:	00 00 00 
  getcallerpcs(&s, pcs);
801003a3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003a6:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003a9:	e8 82 24 00 00       	call   80102830 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 4d 70 10 80       	push   $0x8010704d
801003b7:	e8 f4 02 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 eb 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 86 76 10 80 	movl   $0x80107686,(%esp)
801003cc:	e8 df 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	8d 45 08             	lea    0x8(%ebp),%eax
801003d4:	5a                   	pop    %edx
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 f3 3f 00 00       	call   801043d0 <getcallerpcs>
  for(i=0; i<10; i++)
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 61 70 10 80       	push   $0x80107061
801003ed:	e8 be 02 00 00       	call   801006b0 <cprintf>
  for(i=0; i<10; i++)
801003f2:	83 c4 10             	add    $0x10,%esp
801003f5:	39 f3                	cmp    %esi,%ebx
801003f7:	75 e7                	jne    801003e0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003f9:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
80100400:	00 00 00 
    ;
80100403:	eb fe                	jmp    80100403 <panic+0x73>
80100405:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100410 <consputc.part.0>:
consputc(int c)
80100410:	55                   	push   %ebp
80100411:	89 e5                	mov    %esp,%ebp
80100413:	57                   	push   %edi
80100414:	56                   	push   %esi
80100415:	53                   	push   %ebx
80100416:	89 c3                	mov    %eax,%ebx
80100418:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
8010041b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100420:	0f 84 ea 00 00 00    	je     80100510 <consputc.part.0+0x100>
    uartputc(c);
80100426:	83 ec 0c             	sub    $0xc,%esp
80100429:	50                   	push   %eax
8010042a:	e8 21 58 00 00       	call   80105c50 <uartputc>
8010042f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100432:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100437:	b8 0e 00 00 00       	mov    $0xe,%eax
8010043c:	89 fa                	mov    %edi,%edx
8010043e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010043f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100444:	89 ca                	mov    %ecx,%edx
80100446:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100447:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010044a:	89 fa                	mov    %edi,%edx
8010044c:	c1 e0 08             	shl    $0x8,%eax
8010044f:	89 c6                	mov    %eax,%esi
80100451:	b8 0f 00 00 00       	mov    $0xf,%eax
80100456:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100457:	89 ca                	mov    %ecx,%edx
80100459:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
8010045a:	0f b6 c0             	movzbl %al,%eax
8010045d:	09 f0                	or     %esi,%eax
  if(c == '\n')
8010045f:	83 fb 0a             	cmp    $0xa,%ebx
80100462:	0f 84 90 00 00 00    	je     801004f8 <consputc.part.0+0xe8>
  else if(c == BACKSPACE){
80100468:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010046e:	74 70                	je     801004e0 <consputc.part.0+0xd0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100470:	0f b6 db             	movzbl %bl,%ebx
80100473:	8d 70 01             	lea    0x1(%eax),%esi
80100476:	80 cf 07             	or     $0x7,%bh
80100479:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
80100480:	80 
  if(pos < 0 || pos > 25*80)
80100481:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
80100487:	0f 8f f9 00 00 00    	jg     80100586 <consputc.part.0+0x176>
  if((pos/80) >= 24){  // Scroll up.
8010048d:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100493:	0f 8f a7 00 00 00    	jg     80100540 <consputc.part.0+0x130>
80100499:	89 f0                	mov    %esi,%eax
8010049b:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
801004a2:	88 45 e7             	mov    %al,-0x19(%ebp)
801004a5:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004a8:	bb d4 03 00 00       	mov    $0x3d4,%ebx
801004ad:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b2:	89 da                	mov    %ebx,%edx
801004b4:	ee                   	out    %al,(%dx)
801004b5:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004ba:	89 f8                	mov    %edi,%eax
801004bc:	89 ca                	mov    %ecx,%edx
801004be:	ee                   	out    %al,(%dx)
801004bf:	b8 0f 00 00 00       	mov    $0xf,%eax
801004c4:	89 da                	mov    %ebx,%edx
801004c6:	ee                   	out    %al,(%dx)
801004c7:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004cb:	89 ca                	mov    %ecx,%edx
801004cd:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004ce:	b8 20 07 00 00       	mov    $0x720,%eax
801004d3:	66 89 06             	mov    %ax,(%esi)
}
801004d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004d9:	5b                   	pop    %ebx
801004da:	5e                   	pop    %esi
801004db:	5f                   	pop    %edi
801004dc:	5d                   	pop    %ebp
801004dd:	c3                   	ret    
801004de:	66 90                	xchg   %ax,%ax
    if(pos > 0) --pos;
801004e0:	8d 70 ff             	lea    -0x1(%eax),%esi
801004e3:	85 c0                	test   %eax,%eax
801004e5:	75 9a                	jne    80100481 <consputc.part.0+0x71>
801004e7:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801004ec:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
801004f0:	31 ff                	xor    %edi,%edi
801004f2:	eb b4                	jmp    801004a8 <consputc.part.0+0x98>
801004f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
801004f8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004fd:	f7 e2                	mul    %edx
801004ff:	c1 ea 06             	shr    $0x6,%edx
80100502:	8d 04 92             	lea    (%edx,%edx,4),%eax
80100505:	c1 e0 04             	shl    $0x4,%eax
80100508:	8d 70 50             	lea    0x50(%eax),%esi
8010050b:	e9 71 ff ff ff       	jmp    80100481 <consputc.part.0+0x71>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100510:	83 ec 0c             	sub    $0xc,%esp
80100513:	6a 08                	push   $0x8
80100515:	e8 36 57 00 00       	call   80105c50 <uartputc>
8010051a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100521:	e8 2a 57 00 00       	call   80105c50 <uartputc>
80100526:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010052d:	e8 1e 57 00 00       	call   80105c50 <uartputc>
80100532:	83 c4 10             	add    $0x10,%esp
80100535:	e9 f8 fe ff ff       	jmp    80100432 <consputc.part.0+0x22>
8010053a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100540:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100543:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100546:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010054b:	68 60 0e 00 00       	push   $0xe60
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100550:	8d b4 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100557:	68 a0 80 0b 80       	push   $0x800b80a0
8010055c:	68 00 80 0b 80       	push   $0x800b8000
80100561:	e8 5a 41 00 00       	call   801046c0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 a5 40 00 00       	call   80104620 <memset>
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 22 ff ff ff       	jmp    801004a8 <consputc.part.0+0x98>
    panic("pos under/overflow");
80100586:	83 ec 0c             	sub    $0xc,%esp
80100589:	68 65 70 10 80       	push   $0x80107065
8010058e:	e8 fd fd ff ff       	call   80100390 <panic>
80100593:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100599:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801005a0 <printint>:
{
801005a0:	55                   	push   %ebp
801005a1:	89 e5                	mov    %esp,%ebp
801005a3:	57                   	push   %edi
801005a4:	56                   	push   %esi
801005a5:	53                   	push   %ebx
801005a6:	83 ec 2c             	sub    $0x2c,%esp
801005a9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
801005ac:	85 c9                	test   %ecx,%ecx
801005ae:	74 04                	je     801005b4 <printint+0x14>
801005b0:	85 c0                	test   %eax,%eax
801005b2:	78 68                	js     8010061c <printint+0x7c>
    x = xx;
801005b4:	89 c1                	mov    %eax,%ecx
801005b6:	31 f6                	xor    %esi,%esi
  i = 0;
801005b8:	31 db                	xor    %ebx,%ebx
801005ba:	eb 04                	jmp    801005c0 <printint+0x20>
  }while((x /= base) != 0);
801005bc:	89 c1                	mov    %eax,%ecx
    buf[i++] = digits[x % base];
801005be:	89 fb                	mov    %edi,%ebx
801005c0:	89 c8                	mov    %ecx,%eax
801005c2:	31 d2                	xor    %edx,%edx
801005c4:	8d 7b 01             	lea    0x1(%ebx),%edi
801005c7:	f7 75 d4             	divl   -0x2c(%ebp)
801005ca:	0f b6 92 90 70 10 80 	movzbl -0x7fef8f70(%edx),%edx
801005d1:	88 54 3d d7          	mov    %dl,-0x29(%ebp,%edi,1)
  }while((x /= base) != 0);
801005d5:	39 4d d4             	cmp    %ecx,-0x2c(%ebp)
801005d8:	76 e2                	jbe    801005bc <printint+0x1c>
  if(sign)
801005da:	85 f6                	test   %esi,%esi
801005dc:	75 32                	jne    80100610 <printint+0x70>
801005de:	0f be c2             	movsbl %dl,%eax
801005e1:	89 df                	mov    %ebx,%edi
  if(panicked){
801005e3:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
801005e9:	85 c9                	test   %ecx,%ecx
801005eb:	75 20                	jne    8010060d <printint+0x6d>
801005ed:	8d 5c 3d d7          	lea    -0x29(%ebp,%edi,1),%ebx
801005f1:	e8 1a fe ff ff       	call   80100410 <consputc.part.0>
  while(--i >= 0)
801005f6:	8d 45 d7             	lea    -0x29(%ebp),%eax
801005f9:	39 d8                	cmp    %ebx,%eax
801005fb:	74 27                	je     80100624 <printint+0x84>
  if(panicked){
801005fd:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
    consputc(buf[i]);
80100603:	0f be 03             	movsbl (%ebx),%eax
  if(panicked){
80100606:	83 eb 01             	sub    $0x1,%ebx
80100609:	85 d2                	test   %edx,%edx
8010060b:	74 e4                	je     801005f1 <printint+0x51>
  asm volatile("cli");
8010060d:	fa                   	cli    
      ;
8010060e:	eb fe                	jmp    8010060e <printint+0x6e>
    buf[i++] = '-';
80100610:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
80100615:	b8 2d 00 00 00       	mov    $0x2d,%eax
8010061a:	eb c7                	jmp    801005e3 <printint+0x43>
    x = -xx;
8010061c:	f7 d8                	neg    %eax
8010061e:	89 ce                	mov    %ecx,%esi
80100620:	89 c1                	mov    %eax,%ecx
80100622:	eb 94                	jmp    801005b8 <printint+0x18>
}
80100624:	83 c4 2c             	add    $0x2c,%esp
80100627:	5b                   	pop    %ebx
80100628:	5e                   	pop    %esi
80100629:	5f                   	pop    %edi
8010062a:	5d                   	pop    %ebp
8010062b:	c3                   	ret    
8010062c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100630 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100630:	55                   	push   %ebp
80100631:	89 e5                	mov    %esp,%ebp
80100633:	57                   	push   %edi
80100634:	56                   	push   %esi
80100635:	53                   	push   %ebx
80100636:	83 ec 18             	sub    $0x18,%esp
80100639:	8b 7d 10             	mov    0x10(%ebp),%edi
8010063c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  int i;

  iunlock(ip);
8010063f:	ff 75 08             	pushl  0x8(%ebp)
80100642:	e8 b9 11 00 00       	call   80101800 <iunlock>
  acquire(&cons.lock);
80100647:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010064e:	e8 5d 3e 00 00       	call   801044b0 <acquire>
  for(i = 0; i < n; i++)
80100653:	83 c4 10             	add    $0x10,%esp
80100656:	85 ff                	test   %edi,%edi
80100658:	7e 36                	jle    80100690 <consolewrite+0x60>
  if(panicked){
8010065a:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
80100660:	85 c9                	test   %ecx,%ecx
80100662:	75 21                	jne    80100685 <consolewrite+0x55>
    consputc(buf[i] & 0xff);
80100664:	0f b6 03             	movzbl (%ebx),%eax
80100667:	8d 73 01             	lea    0x1(%ebx),%esi
8010066a:	01 fb                	add    %edi,%ebx
8010066c:	e8 9f fd ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; i < n; i++)
80100671:	39 de                	cmp    %ebx,%esi
80100673:	74 1b                	je     80100690 <consolewrite+0x60>
  if(panicked){
80100675:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
    consputc(buf[i] & 0xff);
8010067b:	0f b6 06             	movzbl (%esi),%eax
  if(panicked){
8010067e:	83 c6 01             	add    $0x1,%esi
80100681:	85 d2                	test   %edx,%edx
80100683:	74 e7                	je     8010066c <consolewrite+0x3c>
80100685:	fa                   	cli    
      ;
80100686:	eb fe                	jmp    80100686 <consolewrite+0x56>
80100688:	90                   	nop
80100689:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
80100690:	83 ec 0c             	sub    $0xc,%esp
80100693:	68 20 a5 10 80       	push   $0x8010a520
80100698:	e8 33 3f 00 00       	call   801045d0 <release>
  ilock(ip);
8010069d:	58                   	pop    %eax
8010069e:	ff 75 08             	pushl  0x8(%ebp)
801006a1:	e8 7a 10 00 00       	call   80101720 <ilock>

  return n;
}
801006a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801006a9:	89 f8                	mov    %edi,%eax
801006ab:	5b                   	pop    %ebx
801006ac:	5e                   	pop    %esi
801006ad:	5f                   	pop    %edi
801006ae:	5d                   	pop    %ebp
801006af:	c3                   	ret    

801006b0 <cprintf>:
{
801006b0:	55                   	push   %ebp
801006b1:	89 e5                	mov    %esp,%ebp
801006b3:	57                   	push   %edi
801006b4:	56                   	push   %esi
801006b5:	53                   	push   %ebx
801006b6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006b9:	a1 54 a5 10 80       	mov    0x8010a554,%eax
801006be:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
801006c1:	85 c0                	test   %eax,%eax
801006c3:	0f 85 df 00 00 00    	jne    801007a8 <cprintf+0xf8>
  if (fmt == 0)
801006c9:	8b 45 08             	mov    0x8(%ebp),%eax
801006cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006cf:	85 c0                	test   %eax,%eax
801006d1:	0f 84 5e 01 00 00    	je     80100835 <cprintf+0x185>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006d7:	0f b6 00             	movzbl (%eax),%eax
801006da:	85 c0                	test   %eax,%eax
801006dc:	74 32                	je     80100710 <cprintf+0x60>
  argp = (uint*)(void*)(&fmt + 1);
801006de:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006e1:	31 f6                	xor    %esi,%esi
    if(c != '%'){
801006e3:	83 f8 25             	cmp    $0x25,%eax
801006e6:	74 40                	je     80100728 <cprintf+0x78>
  if(panicked){
801006e8:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
801006ee:	85 c9                	test   %ecx,%ecx
801006f0:	74 0b                	je     801006fd <cprintf+0x4d>
801006f2:	fa                   	cli    
      ;
801006f3:	eb fe                	jmp    801006f3 <cprintf+0x43>
801006f5:	8d 76 00             	lea    0x0(%esi),%esi
801006f8:	b8 25 00 00 00       	mov    $0x25,%eax
801006fd:	e8 0e fd ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100702:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100705:	83 c6 01             	add    $0x1,%esi
80100708:	0f b6 04 30          	movzbl (%eax,%esi,1),%eax
8010070c:	85 c0                	test   %eax,%eax
8010070e:	75 d3                	jne    801006e3 <cprintf+0x33>
  if(locking)
80100710:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80100713:	85 db                	test   %ebx,%ebx
80100715:	0f 85 05 01 00 00    	jne    80100820 <cprintf+0x170>
}
8010071b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010071e:	5b                   	pop    %ebx
8010071f:	5e                   	pop    %esi
80100720:	5f                   	pop    %edi
80100721:	5d                   	pop    %ebp
80100722:	c3                   	ret    
80100723:	90                   	nop
80100724:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = fmt[++i] & 0xff;
80100728:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010072b:	83 c6 01             	add    $0x1,%esi
8010072e:	0f b6 3c 30          	movzbl (%eax,%esi,1),%edi
    if(c == 0)
80100732:	85 ff                	test   %edi,%edi
80100734:	74 da                	je     80100710 <cprintf+0x60>
    switch(c){
80100736:	83 ff 70             	cmp    $0x70,%edi
80100739:	0f 84 7e 00 00 00    	je     801007bd <cprintf+0x10d>
8010073f:	7f 26                	jg     80100767 <cprintf+0xb7>
80100741:	83 ff 25             	cmp    $0x25,%edi
80100744:	0f 84 be 00 00 00    	je     80100808 <cprintf+0x158>
8010074a:	83 ff 64             	cmp    $0x64,%edi
8010074d:	75 46                	jne    80100795 <cprintf+0xe5>
      printint(*argp++, 10, 1);
8010074f:	8b 03                	mov    (%ebx),%eax
80100751:	8d 7b 04             	lea    0x4(%ebx),%edi
80100754:	b9 01 00 00 00       	mov    $0x1,%ecx
80100759:	ba 0a 00 00 00       	mov    $0xa,%edx
8010075e:	89 fb                	mov    %edi,%ebx
80100760:	e8 3b fe ff ff       	call   801005a0 <printint>
      break;
80100765:	eb 9b                	jmp    80100702 <cprintf+0x52>
80100767:	83 ff 73             	cmp    $0x73,%edi
8010076a:	75 24                	jne    80100790 <cprintf+0xe0>
      if((s = (char*)*argp++) == 0)
8010076c:	8d 7b 04             	lea    0x4(%ebx),%edi
8010076f:	8b 1b                	mov    (%ebx),%ebx
80100771:	85 db                	test   %ebx,%ebx
80100773:	75 68                	jne    801007dd <cprintf+0x12d>
80100775:	b8 28 00 00 00       	mov    $0x28,%eax
        s = "(null)";
8010077a:	bb 78 70 10 80       	mov    $0x80107078,%ebx
  if(panicked){
8010077f:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
80100785:	85 d2                	test   %edx,%edx
80100787:	74 4c                	je     801007d5 <cprintf+0x125>
80100789:	fa                   	cli    
      ;
8010078a:	eb fe                	jmp    8010078a <cprintf+0xda>
8010078c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100790:	83 ff 78             	cmp    $0x78,%edi
80100793:	74 28                	je     801007bd <cprintf+0x10d>
  if(panicked){
80100795:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
8010079b:	85 d2                	test   %edx,%edx
8010079d:	74 4c                	je     801007eb <cprintf+0x13b>
8010079f:	fa                   	cli    
      ;
801007a0:	eb fe                	jmp    801007a0 <cprintf+0xf0>
801007a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    acquire(&cons.lock);
801007a8:	83 ec 0c             	sub    $0xc,%esp
801007ab:	68 20 a5 10 80       	push   $0x8010a520
801007b0:	e8 fb 3c 00 00       	call   801044b0 <acquire>
801007b5:	83 c4 10             	add    $0x10,%esp
801007b8:	e9 0c ff ff ff       	jmp    801006c9 <cprintf+0x19>
      printint(*argp++, 16, 0);
801007bd:	8b 03                	mov    (%ebx),%eax
801007bf:	8d 7b 04             	lea    0x4(%ebx),%edi
801007c2:	31 c9                	xor    %ecx,%ecx
801007c4:	ba 10 00 00 00       	mov    $0x10,%edx
801007c9:	89 fb                	mov    %edi,%ebx
801007cb:	e8 d0 fd ff ff       	call   801005a0 <printint>
      break;
801007d0:	e9 2d ff ff ff       	jmp    80100702 <cprintf+0x52>
801007d5:	e8 36 fc ff ff       	call   80100410 <consputc.part.0>
      for(; *s; s++)
801007da:	83 c3 01             	add    $0x1,%ebx
801007dd:	0f be 03             	movsbl (%ebx),%eax
801007e0:	84 c0                	test   %al,%al
801007e2:	75 9b                	jne    8010077f <cprintf+0xcf>
      if((s = (char*)*argp++) == 0)
801007e4:	89 fb                	mov    %edi,%ebx
801007e6:	e9 17 ff ff ff       	jmp    80100702 <cprintf+0x52>
801007eb:	b8 25 00 00 00       	mov    $0x25,%eax
801007f0:	e8 1b fc ff ff       	call   80100410 <consputc.part.0>
  if(panicked){
801007f5:	a1 58 a5 10 80       	mov    0x8010a558,%eax
801007fa:	85 c0                	test   %eax,%eax
801007fc:	74 4a                	je     80100848 <cprintf+0x198>
801007fe:	fa                   	cli    
      ;
801007ff:	eb fe                	jmp    801007ff <cprintf+0x14f>
80100801:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(panicked){
80100808:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
8010080e:	85 c9                	test   %ecx,%ecx
80100810:	0f 84 e2 fe ff ff    	je     801006f8 <cprintf+0x48>
80100816:	fa                   	cli    
      ;
80100817:	eb fe                	jmp    80100817 <cprintf+0x167>
80100819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&cons.lock);
80100820:	83 ec 0c             	sub    $0xc,%esp
80100823:	68 20 a5 10 80       	push   $0x8010a520
80100828:	e8 a3 3d 00 00       	call   801045d0 <release>
8010082d:	83 c4 10             	add    $0x10,%esp
}
80100830:	e9 e6 fe ff ff       	jmp    8010071b <cprintf+0x6b>
    panic("null fmt");
80100835:	83 ec 0c             	sub    $0xc,%esp
80100838:	68 7f 70 10 80       	push   $0x8010707f
8010083d:	e8 4e fb ff ff       	call   80100390 <panic>
80100842:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100848:	89 f8                	mov    %edi,%eax
8010084a:	e8 c1 fb ff ff       	call   80100410 <consputc.part.0>
8010084f:	e9 ae fe ff ff       	jmp    80100702 <cprintf+0x52>
80100854:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010085a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100860 <consoleintr>:
{
80100860:	55                   	push   %ebp
80100861:	89 e5                	mov    %esp,%ebp
80100863:	57                   	push   %edi
80100864:	56                   	push   %esi
  int c, doprocdump = 0;
80100865:	31 f6                	xor    %esi,%esi
{
80100867:	53                   	push   %ebx
80100868:	83 ec 18             	sub    $0x18,%esp
8010086b:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
8010086e:	68 20 a5 10 80       	push   $0x8010a520
80100873:	e8 38 3c 00 00       	call   801044b0 <acquire>
  while((c = getc()) >= 0){
80100878:	83 c4 10             	add    $0x10,%esp
8010087b:	ff d7                	call   *%edi
8010087d:	89 c3                	mov    %eax,%ebx
8010087f:	85 c0                	test   %eax,%eax
80100881:	0f 88 38 01 00 00    	js     801009bf <consoleintr+0x15f>
    switch(c){
80100887:	83 fb 10             	cmp    $0x10,%ebx
8010088a:	0f 84 f0 00 00 00    	je     80100980 <consoleintr+0x120>
80100890:	0f 8e ba 00 00 00    	jle    80100950 <consoleintr+0xf0>
80100896:	83 fb 15             	cmp    $0x15,%ebx
80100899:	75 35                	jne    801008d0 <consoleintr+0x70>
      while(input.e != input.w &&
8010089b:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008a0:	39 05 a4 ff 10 80    	cmp    %eax,0x8010ffa4
801008a6:	74 d3                	je     8010087b <consoleintr+0x1b>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801008a8:	83 e8 01             	sub    $0x1,%eax
801008ab:	89 c2                	mov    %eax,%edx
801008ad:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
801008b0:	80 ba 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%edx)
801008b7:	74 c2                	je     8010087b <consoleintr+0x1b>
  if(panicked){
801008b9:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
        input.e--;
801008bf:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
  if(panicked){
801008c4:	85 d2                	test   %edx,%edx
801008c6:	0f 84 be 00 00 00    	je     8010098a <consoleintr+0x12a>
801008cc:	fa                   	cli    
      ;
801008cd:	eb fe                	jmp    801008cd <consoleintr+0x6d>
801008cf:	90                   	nop
801008d0:	83 fb 7f             	cmp    $0x7f,%ebx
801008d3:	0f 84 7c 00 00 00    	je     80100955 <consoleintr+0xf5>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008d9:	85 db                	test   %ebx,%ebx
801008db:	74 9e                	je     8010087b <consoleintr+0x1b>
801008dd:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008e2:	89 c2                	mov    %eax,%edx
801008e4:	2b 15 a0 ff 10 80    	sub    0x8010ffa0,%edx
801008ea:	83 fa 7f             	cmp    $0x7f,%edx
801008ed:	77 8c                	ja     8010087b <consoleintr+0x1b>
        c = (c == '\r') ? '\n' : c;
801008ef:	8d 48 01             	lea    0x1(%eax),%ecx
801008f2:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
801008f8:	83 e0 7f             	and    $0x7f,%eax
        input.buf[input.e++ % INPUT_BUF] = c;
801008fb:	89 0d a8 ff 10 80    	mov    %ecx,0x8010ffa8
        c = (c == '\r') ? '\n' : c;
80100901:	83 fb 0d             	cmp    $0xd,%ebx
80100904:	0f 84 d1 00 00 00    	je     801009db <consoleintr+0x17b>
        input.buf[input.e++ % INPUT_BUF] = c;
8010090a:	88 98 20 ff 10 80    	mov    %bl,-0x7fef00e0(%eax)
  if(panicked){
80100910:	85 d2                	test   %edx,%edx
80100912:	0f 85 ce 00 00 00    	jne    801009e6 <consoleintr+0x186>
80100918:	89 d8                	mov    %ebx,%eax
8010091a:	e8 f1 fa ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
8010091f:	83 fb 0a             	cmp    $0xa,%ebx
80100922:	0f 84 d2 00 00 00    	je     801009fa <consoleintr+0x19a>
80100928:	83 fb 04             	cmp    $0x4,%ebx
8010092b:	0f 84 c9 00 00 00    	je     801009fa <consoleintr+0x19a>
80100931:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
80100936:	83 e8 80             	sub    $0xffffff80,%eax
80100939:	39 05 a8 ff 10 80    	cmp    %eax,0x8010ffa8
8010093f:	0f 85 36 ff ff ff    	jne    8010087b <consoleintr+0x1b>
80100945:	e9 b5 00 00 00       	jmp    801009ff <consoleintr+0x19f>
8010094a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100950:	83 fb 08             	cmp    $0x8,%ebx
80100953:	75 84                	jne    801008d9 <consoleintr+0x79>
      if(input.e != input.w){
80100955:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010095a:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
80100960:	0f 84 15 ff ff ff    	je     8010087b <consoleintr+0x1b>
        input.e--;
80100966:	83 e8 01             	sub    $0x1,%eax
80100969:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
  if(panicked){
8010096e:	a1 58 a5 10 80       	mov    0x8010a558,%eax
80100973:	85 c0                	test   %eax,%eax
80100975:	74 39                	je     801009b0 <consoleintr+0x150>
80100977:	fa                   	cli    
      ;
80100978:	eb fe                	jmp    80100978 <consoleintr+0x118>
8010097a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      doprocdump = 1;
80100980:	be 01 00 00 00       	mov    $0x1,%esi
80100985:	e9 f1 fe ff ff       	jmp    8010087b <consoleintr+0x1b>
8010098a:	b8 00 01 00 00       	mov    $0x100,%eax
8010098f:	e8 7c fa ff ff       	call   80100410 <consputc.part.0>
      while(input.e != input.w &&
80100994:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100999:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010099f:	0f 85 03 ff ff ff    	jne    801008a8 <consoleintr+0x48>
801009a5:	e9 d1 fe ff ff       	jmp    8010087b <consoleintr+0x1b>
801009aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801009b0:	b8 00 01 00 00       	mov    $0x100,%eax
801009b5:	e8 56 fa ff ff       	call   80100410 <consputc.part.0>
801009ba:	e9 bc fe ff ff       	jmp    8010087b <consoleintr+0x1b>
  release(&cons.lock);
801009bf:	83 ec 0c             	sub    $0xc,%esp
801009c2:	68 20 a5 10 80       	push   $0x8010a520
801009c7:	e8 04 3c 00 00       	call   801045d0 <release>
  if(doprocdump) {
801009cc:	83 c4 10             	add    $0x10,%esp
801009cf:	85 f6                	test   %esi,%esi
801009d1:	75 46                	jne    80100a19 <consoleintr+0x1b9>
}
801009d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009d6:	5b                   	pop    %ebx
801009d7:	5e                   	pop    %esi
801009d8:	5f                   	pop    %edi
801009d9:	5d                   	pop    %ebp
801009da:	c3                   	ret    
        input.buf[input.e++ % INPUT_BUF] = c;
801009db:	c6 80 20 ff 10 80 0a 	movb   $0xa,-0x7fef00e0(%eax)
  if(panicked){
801009e2:	85 d2                	test   %edx,%edx
801009e4:	74 0a                	je     801009f0 <consoleintr+0x190>
801009e6:	fa                   	cli    
      ;
801009e7:	eb fe                	jmp    801009e7 <consoleintr+0x187>
801009e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801009f0:	b8 0a 00 00 00       	mov    $0xa,%eax
801009f5:	e8 16 fa ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801009fa:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
          wakeup(&input.r);
801009ff:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a02:	a3 a4 ff 10 80       	mov    %eax,0x8010ffa4
          wakeup(&input.r);
80100a07:	68 a0 ff 10 80       	push   $0x8010ffa0
80100a0c:	e8 1f 36 00 00       	call   80104030 <wakeup>
80100a11:	83 c4 10             	add    $0x10,%esp
80100a14:	e9 62 fe ff ff       	jmp    8010087b <consoleintr+0x1b>
}
80100a19:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a1c:	5b                   	pop    %ebx
80100a1d:	5e                   	pop    %esi
80100a1e:	5f                   	pop    %edi
80100a1f:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100a20:	e9 eb 36 00 00       	jmp    80104110 <procdump>
80100a25:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100a29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100a30 <consoleinit>:

void
consoleinit(void)
{
80100a30:	55                   	push   %ebp
80100a31:	89 e5                	mov    %esp,%ebp
80100a33:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a36:	68 88 70 10 80       	push   $0x80107088
80100a3b:	68 20 a5 10 80       	push   $0x8010a520
80100a40:	e8 6b 39 00 00       	call   801043b0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a45:	58                   	pop    %eax
80100a46:	5a                   	pop    %edx
80100a47:	6a 00                	push   $0x0
80100a49:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a4b:	c7 05 6c 09 11 80 30 	movl   $0x80100630,0x8011096c
80100a52:	06 10 80 
  devsw[CONSOLE].read = consoleread;
80100a55:	c7 05 68 09 11 80 80 	movl   $0x80100280,0x80110968
80100a5c:	02 10 80 
  cons.locking = 1;
80100a5f:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
80100a66:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a69:	e8 42 19 00 00       	call   801023b0 <ioapicenable>
}
80100a6e:	83 c4 10             	add    $0x10,%esp
80100a71:	c9                   	leave  
80100a72:	c3                   	ret    
80100a73:	66 90                	xchg   %ax,%ax
80100a75:	66 90                	xchg   %ax,%ax
80100a77:	66 90                	xchg   %ax,%ax
80100a79:	66 90                	xchg   %ax,%ax
80100a7b:	66 90                	xchg   %ax,%ax
80100a7d:	66 90                	xchg   %ax,%ax
80100a7f:	90                   	nop

80100a80 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100a80:	55                   	push   %ebp
80100a81:	89 e5                	mov    %esp,%ebp
80100a83:	57                   	push   %edi
80100a84:	56                   	push   %esi
80100a85:	53                   	push   %ebx
80100a86:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100a8c:	e8 4f 2e 00 00       	call   801038e0 <myproc>
80100a91:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100a97:	e8 04 22 00 00       	call   80102ca0 <begin_op>

  if((ip = namei(path)) == 0){
80100a9c:	83 ec 0c             	sub    $0xc,%esp
80100a9f:	ff 75 08             	pushl  0x8(%ebp)
80100aa2:	e8 19 15 00 00       	call   80101fc0 <namei>
80100aa7:	83 c4 10             	add    $0x10,%esp
80100aaa:	85 c0                	test   %eax,%eax
80100aac:	0f 84 02 03 00 00    	je     80100db4 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ab2:	83 ec 0c             	sub    $0xc,%esp
80100ab5:	89 c3                	mov    %eax,%ebx
80100ab7:	50                   	push   %eax
80100ab8:	e8 63 0c 00 00       	call   80101720 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100abd:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100ac3:	6a 34                	push   $0x34
80100ac5:	6a 00                	push   $0x0
80100ac7:	50                   	push   %eax
80100ac8:	53                   	push   %ebx
80100ac9:	e8 32 0f 00 00       	call   80101a00 <readi>
80100ace:	83 c4 20             	add    $0x20,%esp
80100ad1:	83 f8 34             	cmp    $0x34,%eax
80100ad4:	74 22                	je     80100af8 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100ad6:	83 ec 0c             	sub    $0xc,%esp
80100ad9:	53                   	push   %ebx
80100ada:	e8 d1 0e 00 00       	call   801019b0 <iunlockput>
    end_op();
80100adf:	e8 2c 22 00 00       	call   80102d10 <end_op>
80100ae4:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100ae7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100aec:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100aef:	5b                   	pop    %ebx
80100af0:	5e                   	pop    %esi
80100af1:	5f                   	pop    %edi
80100af2:	5d                   	pop    %ebp
80100af3:	c3                   	ret    
80100af4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100af8:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100aff:	45 4c 46 
80100b02:	75 d2                	jne    80100ad6 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100b04:	e8 97 62 00 00       	call   80106da0 <setupkvm>
80100b09:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b0f:	85 c0                	test   %eax,%eax
80100b11:	74 c3                	je     80100ad6 <exec+0x56>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b13:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b1a:	00 
80100b1b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b21:	0f 84 ac 02 00 00    	je     80100dd3 <exec+0x353>
  sz = 0;
80100b27:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b2e:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b31:	31 ff                	xor    %edi,%edi
80100b33:	e9 8e 00 00 00       	jmp    80100bc6 <exec+0x146>
80100b38:	90                   	nop
80100b39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ph.type != ELF_PROG_LOAD)
80100b40:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b47:	75 6c                	jne    80100bb5 <exec+0x135>
    if(ph.memsz < ph.filesz)
80100b49:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b4f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b55:	0f 82 87 00 00 00    	jb     80100be2 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b5b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b61:	72 7f                	jb     80100be2 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b63:	83 ec 04             	sub    $0x4,%esp
80100b66:	50                   	push   %eax
80100b67:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b6d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b73:	e8 48 60 00 00       	call   80106bc0 <allocuvm>
80100b78:	83 c4 10             	add    $0x10,%esp
80100b7b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100b81:	85 c0                	test   %eax,%eax
80100b83:	74 5d                	je     80100be2 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80100b85:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b8b:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b90:	75 50                	jne    80100be2 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b92:	83 ec 0c             	sub    $0xc,%esp
80100b95:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b9b:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100ba1:	53                   	push   %ebx
80100ba2:	50                   	push   %eax
80100ba3:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ba9:	e8 52 5f 00 00       	call   80106b00 <loaduvm>
80100bae:	83 c4 20             	add    $0x20,%esp
80100bb1:	85 c0                	test   %eax,%eax
80100bb3:	78 2d                	js     80100be2 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bb5:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bbc:	83 c7 01             	add    $0x1,%edi
80100bbf:	83 c6 20             	add    $0x20,%esi
80100bc2:	39 f8                	cmp    %edi,%eax
80100bc4:	7e 3a                	jle    80100c00 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bc6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100bcc:	6a 20                	push   $0x20
80100bce:	56                   	push   %esi
80100bcf:	50                   	push   %eax
80100bd0:	53                   	push   %ebx
80100bd1:	e8 2a 0e 00 00       	call   80101a00 <readi>
80100bd6:	83 c4 10             	add    $0x10,%esp
80100bd9:	83 f8 20             	cmp    $0x20,%eax
80100bdc:	0f 84 5e ff ff ff    	je     80100b40 <exec+0xc0>
    freevm(pgdir);
80100be2:	83 ec 0c             	sub    $0xc,%esp
80100be5:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100beb:	e8 30 61 00 00       	call   80106d20 <freevm>
  if(ip){
80100bf0:	83 c4 10             	add    $0x10,%esp
80100bf3:	e9 de fe ff ff       	jmp    80100ad6 <exec+0x56>
80100bf8:	90                   	nop
80100bf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100c00:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100c06:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100c0c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100c12:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100c18:	83 ec 0c             	sub    $0xc,%esp
80100c1b:	53                   	push   %ebx
80100c1c:	e8 8f 0d 00 00       	call   801019b0 <iunlockput>
  end_op();
80100c21:	e8 ea 20 00 00       	call   80102d10 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c26:	83 c4 0c             	add    $0xc,%esp
80100c29:	56                   	push   %esi
80100c2a:	57                   	push   %edi
80100c2b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c31:	57                   	push   %edi
80100c32:	e8 89 5f 00 00       	call   80106bc0 <allocuvm>
80100c37:	83 c4 10             	add    $0x10,%esp
80100c3a:	89 c6                	mov    %eax,%esi
80100c3c:	85 c0                	test   %eax,%eax
80100c3e:	0f 84 94 00 00 00    	je     80100cd8 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c44:	83 ec 08             	sub    $0x8,%esp
80100c47:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100c4d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c4f:	50                   	push   %eax
80100c50:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100c51:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c53:	e8 e8 61 00 00       	call   80106e40 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c58:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c5b:	83 c4 10             	add    $0x10,%esp
80100c5e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c64:	8b 00                	mov    (%eax),%eax
80100c66:	85 c0                	test   %eax,%eax
80100c68:	0f 84 8b 00 00 00    	je     80100cf9 <exec+0x279>
80100c6e:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100c74:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100c7a:	eb 23                	jmp    80100c9f <exec+0x21f>
80100c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100c80:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100c83:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c8a:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100c8d:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100c93:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c96:	85 c0                	test   %eax,%eax
80100c98:	74 59                	je     80100cf3 <exec+0x273>
    if(argc >= MAXARG)
80100c9a:	83 ff 20             	cmp    $0x20,%edi
80100c9d:	74 39                	je     80100cd8 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c9f:	83 ec 0c             	sub    $0xc,%esp
80100ca2:	50                   	push   %eax
80100ca3:	e8 88 3b 00 00       	call   80104830 <strlen>
80100ca8:	f7 d0                	not    %eax
80100caa:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cac:	58                   	pop    %eax
80100cad:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cb0:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cb3:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cb6:	e8 75 3b 00 00       	call   80104830 <strlen>
80100cbb:	83 c0 01             	add    $0x1,%eax
80100cbe:	50                   	push   %eax
80100cbf:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cc2:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cc5:	53                   	push   %ebx
80100cc6:	56                   	push   %esi
80100cc7:	e8 c4 62 00 00       	call   80106f90 <copyout>
80100ccc:	83 c4 20             	add    $0x20,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	79 ad                	jns    80100c80 <exec+0x200>
80100cd3:	90                   	nop
80100cd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
80100cd8:	83 ec 0c             	sub    $0xc,%esp
80100cdb:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ce1:	e8 3a 60 00 00       	call   80106d20 <freevm>
80100ce6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100ce9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100cee:	e9 f9 fd ff ff       	jmp    80100aec <exec+0x6c>
80100cf3:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cf9:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100d00:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100d02:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100d09:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d0d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100d0f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100d12:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100d18:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d1a:	50                   	push   %eax
80100d1b:	52                   	push   %edx
80100d1c:	53                   	push   %ebx
80100d1d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100d23:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d2a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d2d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d33:	e8 58 62 00 00       	call   80106f90 <copyout>
80100d38:	83 c4 10             	add    $0x10,%esp
80100d3b:	85 c0                	test   %eax,%eax
80100d3d:	78 99                	js     80100cd8 <exec+0x258>
  for(last=s=path; *s; s++)
80100d3f:	8b 45 08             	mov    0x8(%ebp),%eax
80100d42:	8b 55 08             	mov    0x8(%ebp),%edx
80100d45:	0f b6 00             	movzbl (%eax),%eax
80100d48:	84 c0                	test   %al,%al
80100d4a:	74 13                	je     80100d5f <exec+0x2df>
80100d4c:	89 d1                	mov    %edx,%ecx
80100d4e:	66 90                	xchg   %ax,%ax
    if(*s == '/')
80100d50:	83 c1 01             	add    $0x1,%ecx
80100d53:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100d55:	0f b6 01             	movzbl (%ecx),%eax
    if(*s == '/')
80100d58:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100d5b:	84 c0                	test   %al,%al
80100d5d:	75 f1                	jne    80100d50 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d5f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100d65:	83 ec 04             	sub    $0x4,%esp
80100d68:	6a 10                	push   $0x10
80100d6a:	89 f8                	mov    %edi,%eax
80100d6c:	52                   	push   %edx
80100d6d:	83 c0 6c             	add    $0x6c,%eax
80100d70:	50                   	push   %eax
80100d71:	e8 7a 3a 00 00       	call   801047f0 <safestrcpy>
  curproc->pgdir = pgdir;
80100d76:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100d7c:	89 f8                	mov    %edi,%eax
80100d7e:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80100d81:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80100d83:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100d86:	89 c1                	mov    %eax,%ecx
80100d88:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d8e:	8b 40 18             	mov    0x18(%eax),%eax
80100d91:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d94:	8b 41 18             	mov    0x18(%ecx),%eax
80100d97:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d9a:	89 0c 24             	mov    %ecx,(%esp)
80100d9d:	e8 ce 5b 00 00       	call   80106970 <switchuvm>
  freevm(oldpgdir);
80100da2:	89 3c 24             	mov    %edi,(%esp)
80100da5:	e8 76 5f 00 00       	call   80106d20 <freevm>
  return 0;
80100daa:	83 c4 10             	add    $0x10,%esp
80100dad:	31 c0                	xor    %eax,%eax
80100daf:	e9 38 fd ff ff       	jmp    80100aec <exec+0x6c>
    end_op();
80100db4:	e8 57 1f 00 00       	call   80102d10 <end_op>
    cprintf("exec: fail\n");
80100db9:	83 ec 0c             	sub    $0xc,%esp
80100dbc:	68 a1 70 10 80       	push   $0x801070a1
80100dc1:	e8 ea f8 ff ff       	call   801006b0 <cprintf>
    return -1;
80100dc6:	83 c4 10             	add    $0x10,%esp
80100dc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100dce:	e9 19 fd ff ff       	jmp    80100aec <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100dd3:	31 ff                	xor    %edi,%edi
80100dd5:	be 00 20 00 00       	mov    $0x2000,%esi
80100dda:	e9 39 fe ff ff       	jmp    80100c18 <exec+0x198>
80100ddf:	90                   	nop

80100de0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100de0:	55                   	push   %ebp
80100de1:	89 e5                	mov    %esp,%ebp
80100de3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100de6:	68 ad 70 10 80       	push   $0x801070ad
80100deb:	68 c0 ff 10 80       	push   $0x8010ffc0
80100df0:	e8 bb 35 00 00       	call   801043b0 <initlock>
}
80100df5:	83 c4 10             	add    $0x10,%esp
80100df8:	c9                   	leave  
80100df9:	c3                   	ret    
80100dfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100e00 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e00:	55                   	push   %ebp
80100e01:	89 e5                	mov    %esp,%ebp
80100e03:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e04:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
{
80100e09:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e0c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e11:	e8 9a 36 00 00       	call   801044b0 <acquire>
80100e16:	83 c4 10             	add    $0x10,%esp
80100e19:	eb 10                	jmp    80100e2b <filealloc+0x2b>
80100e1b:	90                   	nop
80100e1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e20:	83 c3 18             	add    $0x18,%ebx
80100e23:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
80100e29:	74 25                	je     80100e50 <filealloc+0x50>
    if(f->ref == 0){
80100e2b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e2e:	85 c0                	test   %eax,%eax
80100e30:	75 ee                	jne    80100e20 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e32:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e35:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e3c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e41:	e8 8a 37 00 00       	call   801045d0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e46:	89 d8                	mov    %ebx,%eax
      return f;
80100e48:	83 c4 10             	add    $0x10,%esp
}
80100e4b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e4e:	c9                   	leave  
80100e4f:	c3                   	ret    
  release(&ftable.lock);
80100e50:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e53:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e55:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e5a:	e8 71 37 00 00       	call   801045d0 <release>
}
80100e5f:	89 d8                	mov    %ebx,%eax
  return 0;
80100e61:	83 c4 10             	add    $0x10,%esp
}
80100e64:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e67:	c9                   	leave  
80100e68:	c3                   	ret    
80100e69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100e70 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100e70:	55                   	push   %ebp
80100e71:	89 e5                	mov    %esp,%ebp
80100e73:	53                   	push   %ebx
80100e74:	83 ec 10             	sub    $0x10,%esp
80100e77:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100e7a:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e7f:	e8 2c 36 00 00       	call   801044b0 <acquire>
  if(f->ref < 1)
80100e84:	8b 43 04             	mov    0x4(%ebx),%eax
80100e87:	83 c4 10             	add    $0x10,%esp
80100e8a:	85 c0                	test   %eax,%eax
80100e8c:	7e 1a                	jle    80100ea8 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100e8e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e91:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100e94:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e97:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e9c:	e8 2f 37 00 00       	call   801045d0 <release>
  return f;
}
80100ea1:	89 d8                	mov    %ebx,%eax
80100ea3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ea6:	c9                   	leave  
80100ea7:	c3                   	ret    
    panic("filedup");
80100ea8:	83 ec 0c             	sub    $0xc,%esp
80100eab:	68 b4 70 10 80       	push   $0x801070b4
80100eb0:	e8 db f4 ff ff       	call   80100390 <panic>
80100eb5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100eb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100ec0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100ec0:	55                   	push   %ebp
80100ec1:	89 e5                	mov    %esp,%ebp
80100ec3:	57                   	push   %edi
80100ec4:	56                   	push   %esi
80100ec5:	53                   	push   %ebx
80100ec6:	83 ec 28             	sub    $0x28,%esp
80100ec9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100ecc:	68 c0 ff 10 80       	push   $0x8010ffc0
80100ed1:	e8 da 35 00 00       	call   801044b0 <acquire>
  if(f->ref < 1)
80100ed6:	8b 43 04             	mov    0x4(%ebx),%eax
80100ed9:	83 c4 10             	add    $0x10,%esp
80100edc:	85 c0                	test   %eax,%eax
80100ede:	0f 8e a3 00 00 00    	jle    80100f87 <fileclose+0xc7>
    panic("fileclose");
  if(--f->ref > 0){
80100ee4:	83 e8 01             	sub    $0x1,%eax
80100ee7:	89 43 04             	mov    %eax,0x4(%ebx)
80100eea:	75 44                	jne    80100f30 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100eec:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100ef0:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100ef3:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100ef5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100efb:	8b 73 0c             	mov    0xc(%ebx),%esi
80100efe:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f01:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f04:	68 c0 ff 10 80       	push   $0x8010ffc0
  ff = *f;
80100f09:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f0c:	e8 bf 36 00 00       	call   801045d0 <release>

  if(ff.type == FD_PIPE)
80100f11:	83 c4 10             	add    $0x10,%esp
80100f14:	83 ff 01             	cmp    $0x1,%edi
80100f17:	74 2f                	je     80100f48 <fileclose+0x88>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f19:	83 ff 02             	cmp    $0x2,%edi
80100f1c:	74 4a                	je     80100f68 <fileclose+0xa8>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f1e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f21:	5b                   	pop    %ebx
80100f22:	5e                   	pop    %esi
80100f23:	5f                   	pop    %edi
80100f24:	5d                   	pop    %ebp
80100f25:	c3                   	ret    
80100f26:	8d 76 00             	lea    0x0(%esi),%esi
80100f29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    release(&ftable.lock);
80100f30:	c7 45 08 c0 ff 10 80 	movl   $0x8010ffc0,0x8(%ebp)
}
80100f37:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f3a:	5b                   	pop    %ebx
80100f3b:	5e                   	pop    %esi
80100f3c:	5f                   	pop    %edi
80100f3d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f3e:	e9 8d 36 00 00       	jmp    801045d0 <release>
80100f43:	90                   	nop
80100f44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pipeclose(ff.pipe, ff.writable);
80100f48:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100f4c:	83 ec 08             	sub    $0x8,%esp
80100f4f:	53                   	push   %ebx
80100f50:	56                   	push   %esi
80100f51:	e8 fa 24 00 00       	call   80103450 <pipeclose>
80100f56:	83 c4 10             	add    $0x10,%esp
}
80100f59:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f5c:	5b                   	pop    %ebx
80100f5d:	5e                   	pop    %esi
80100f5e:	5f                   	pop    %edi
80100f5f:	5d                   	pop    %ebp
80100f60:	c3                   	ret    
80100f61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80100f68:	e8 33 1d 00 00       	call   80102ca0 <begin_op>
    iput(ff.ip);
80100f6d:	83 ec 0c             	sub    $0xc,%esp
80100f70:	ff 75 e0             	pushl  -0x20(%ebp)
80100f73:	e8 d8 08 00 00       	call   80101850 <iput>
    end_op();
80100f78:	83 c4 10             	add    $0x10,%esp
}
80100f7b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f7e:	5b                   	pop    %ebx
80100f7f:	5e                   	pop    %esi
80100f80:	5f                   	pop    %edi
80100f81:	5d                   	pop    %ebp
    end_op();
80100f82:	e9 89 1d 00 00       	jmp    80102d10 <end_op>
    panic("fileclose");
80100f87:	83 ec 0c             	sub    $0xc,%esp
80100f8a:	68 bc 70 10 80       	push   $0x801070bc
80100f8f:	e8 fc f3 ff ff       	call   80100390 <panic>
80100f94:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100f9a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100fa0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100fa0:	55                   	push   %ebp
80100fa1:	89 e5                	mov    %esp,%ebp
80100fa3:	53                   	push   %ebx
80100fa4:	83 ec 04             	sub    $0x4,%esp
80100fa7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100faa:	83 3b 02             	cmpl   $0x2,(%ebx)
80100fad:	75 31                	jne    80100fe0 <filestat+0x40>
    ilock(f->ip);
80100faf:	83 ec 0c             	sub    $0xc,%esp
80100fb2:	ff 73 10             	pushl  0x10(%ebx)
80100fb5:	e8 66 07 00 00       	call   80101720 <ilock>
    stati(f->ip, st);
80100fba:	58                   	pop    %eax
80100fbb:	5a                   	pop    %edx
80100fbc:	ff 75 0c             	pushl  0xc(%ebp)
80100fbf:	ff 73 10             	pushl  0x10(%ebx)
80100fc2:	e8 09 0a 00 00       	call   801019d0 <stati>
    iunlock(f->ip);
80100fc7:	59                   	pop    %ecx
80100fc8:	ff 73 10             	pushl  0x10(%ebx)
80100fcb:	e8 30 08 00 00       	call   80101800 <iunlock>
    return 0;
80100fd0:	83 c4 10             	add    $0x10,%esp
80100fd3:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100fd5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100fd8:	c9                   	leave  
80100fd9:	c3                   	ret    
80100fda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80100fe0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100fe5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100fe8:	c9                   	leave  
80100fe9:	c3                   	ret    
80100fea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100ff0 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100ff0:	55                   	push   %ebp
80100ff1:	89 e5                	mov    %esp,%ebp
80100ff3:	57                   	push   %edi
80100ff4:	56                   	push   %esi
80100ff5:	53                   	push   %ebx
80100ff6:	83 ec 0c             	sub    $0xc,%esp
80100ff9:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100ffc:	8b 75 0c             	mov    0xc(%ebp),%esi
80100fff:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101002:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101006:	74 60                	je     80101068 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101008:	8b 03                	mov    (%ebx),%eax
8010100a:	83 f8 01             	cmp    $0x1,%eax
8010100d:	74 41                	je     80101050 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010100f:	83 f8 02             	cmp    $0x2,%eax
80101012:	75 5b                	jne    8010106f <fileread+0x7f>
    ilock(f->ip);
80101014:	83 ec 0c             	sub    $0xc,%esp
80101017:	ff 73 10             	pushl  0x10(%ebx)
8010101a:	e8 01 07 00 00       	call   80101720 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010101f:	57                   	push   %edi
80101020:	ff 73 14             	pushl  0x14(%ebx)
80101023:	56                   	push   %esi
80101024:	ff 73 10             	pushl  0x10(%ebx)
80101027:	e8 d4 09 00 00       	call   80101a00 <readi>
8010102c:	83 c4 20             	add    $0x20,%esp
8010102f:	89 c6                	mov    %eax,%esi
80101031:	85 c0                	test   %eax,%eax
80101033:	7e 03                	jle    80101038 <fileread+0x48>
      f->off += r;
80101035:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101038:	83 ec 0c             	sub    $0xc,%esp
8010103b:	ff 73 10             	pushl  0x10(%ebx)
8010103e:	e8 bd 07 00 00       	call   80101800 <iunlock>
    return r;
80101043:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101046:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101049:	89 f0                	mov    %esi,%eax
8010104b:	5b                   	pop    %ebx
8010104c:	5e                   	pop    %esi
8010104d:	5f                   	pop    %edi
8010104e:	5d                   	pop    %ebp
8010104f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80101050:	8b 43 0c             	mov    0xc(%ebx),%eax
80101053:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101056:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101059:	5b                   	pop    %ebx
8010105a:	5e                   	pop    %esi
8010105b:	5f                   	pop    %edi
8010105c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010105d:	e9 9e 25 00 00       	jmp    80103600 <piperead>
80101062:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101068:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010106d:	eb d7                	jmp    80101046 <fileread+0x56>
  panic("fileread");
8010106f:	83 ec 0c             	sub    $0xc,%esp
80101072:	68 c6 70 10 80       	push   $0x801070c6
80101077:	e8 14 f3 ff ff       	call   80100390 <panic>
8010107c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101080 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101080:	55                   	push   %ebp
80101081:	89 e5                	mov    %esp,%ebp
80101083:	57                   	push   %edi
80101084:	56                   	push   %esi
80101085:	53                   	push   %ebx
80101086:	83 ec 1c             	sub    $0x1c,%esp
80101089:	8b 45 0c             	mov    0xc(%ebp),%eax
8010108c:	8b 75 08             	mov    0x8(%ebp),%esi
8010108f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101092:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80101095:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
80101099:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010109c:	0f 84 bb 00 00 00    	je     8010115d <filewrite+0xdd>
    return -1;
  if(f->type == FD_PIPE)
801010a2:	8b 06                	mov    (%esi),%eax
801010a4:	83 f8 01             	cmp    $0x1,%eax
801010a7:	0f 84 bf 00 00 00    	je     8010116c <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010ad:	83 f8 02             	cmp    $0x2,%eax
801010b0:	0f 85 c8 00 00 00    	jne    8010117e <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801010b9:	31 ff                	xor    %edi,%edi
    while(i < n){
801010bb:	85 c0                	test   %eax,%eax
801010bd:	7f 30                	jg     801010ef <filewrite+0x6f>
801010bf:	e9 94 00 00 00       	jmp    80101158 <filewrite+0xd8>
801010c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801010c8:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
801010cb:	83 ec 0c             	sub    $0xc,%esp
801010ce:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
801010d1:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801010d4:	e8 27 07 00 00       	call   80101800 <iunlock>
      end_op();
801010d9:	e8 32 1c 00 00       	call   80102d10 <end_op>

      if(r < 0)
        break;
      if(r != n1)
801010de:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010e1:	83 c4 10             	add    $0x10,%esp
801010e4:	39 c3                	cmp    %eax,%ebx
801010e6:	75 60                	jne    80101148 <filewrite+0xc8>
        panic("short filewrite");
      i += r;
801010e8:	01 df                	add    %ebx,%edi
    while(i < n){
801010ea:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801010ed:	7e 69                	jle    80101158 <filewrite+0xd8>
      int n1 = n - i;
801010ef:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801010f2:	b8 00 06 00 00       	mov    $0x600,%eax
801010f7:	29 fb                	sub    %edi,%ebx
      if(n1 > max)
801010f9:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
801010ff:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
80101102:	e8 99 1b 00 00       	call   80102ca0 <begin_op>
      ilock(f->ip);
80101107:	83 ec 0c             	sub    $0xc,%esp
8010110a:	ff 76 10             	pushl  0x10(%esi)
8010110d:	e8 0e 06 00 00       	call   80101720 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101112:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101115:	53                   	push   %ebx
80101116:	ff 76 14             	pushl  0x14(%esi)
80101119:	01 f8                	add    %edi,%eax
8010111b:	50                   	push   %eax
8010111c:	ff 76 10             	pushl  0x10(%esi)
8010111f:	e8 dc 09 00 00       	call   80101b00 <writei>
80101124:	83 c4 20             	add    $0x20,%esp
80101127:	85 c0                	test   %eax,%eax
80101129:	7f 9d                	jg     801010c8 <filewrite+0x48>
      iunlock(f->ip);
8010112b:	83 ec 0c             	sub    $0xc,%esp
8010112e:	ff 76 10             	pushl  0x10(%esi)
80101131:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101134:	e8 c7 06 00 00       	call   80101800 <iunlock>
      end_op();
80101139:	e8 d2 1b 00 00       	call   80102d10 <end_op>
      if(r < 0)
8010113e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101141:	83 c4 10             	add    $0x10,%esp
80101144:	85 c0                	test   %eax,%eax
80101146:	75 15                	jne    8010115d <filewrite+0xdd>
        panic("short filewrite");
80101148:	83 ec 0c             	sub    $0xc,%esp
8010114b:	68 cf 70 10 80       	push   $0x801070cf
80101150:	e8 3b f2 ff ff       	call   80100390 <panic>
80101155:	8d 76 00             	lea    0x0(%esi),%esi
    }
    return i == n ? n : -1;
80101158:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
8010115b:	74 05                	je     80101162 <filewrite+0xe2>
    return -1;
8010115d:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  }
  panic("filewrite");
}
80101162:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101165:	89 f8                	mov    %edi,%eax
80101167:	5b                   	pop    %ebx
80101168:	5e                   	pop    %esi
80101169:	5f                   	pop    %edi
8010116a:	5d                   	pop    %ebp
8010116b:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
8010116c:	8b 46 0c             	mov    0xc(%esi),%eax
8010116f:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101172:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101175:	5b                   	pop    %ebx
80101176:	5e                   	pop    %esi
80101177:	5f                   	pop    %edi
80101178:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
80101179:	e9 72 23 00 00       	jmp    801034f0 <pipewrite>
  panic("filewrite");
8010117e:	83 ec 0c             	sub    $0xc,%esp
80101181:	68 d5 70 10 80       	push   $0x801070d5
80101186:	e8 05 f2 ff ff       	call   80100390 <panic>
8010118b:	66 90                	xchg   %ax,%ax
8010118d:	66 90                	xchg   %ax,%ax
8010118f:	90                   	nop

80101190 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101190:	55                   	push   %ebp
80101191:	89 e5                	mov    %esp,%ebp
80101193:	57                   	push   %edi
80101194:	56                   	push   %esi
80101195:	53                   	push   %ebx
80101196:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101199:	8b 0d c0 09 11 80    	mov    0x801109c0,%ecx
{
8010119f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801011a2:	85 c9                	test   %ecx,%ecx
801011a4:	0f 84 87 00 00 00    	je     80101231 <balloc+0xa1>
801011aa:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801011b1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801011b4:	83 ec 08             	sub    $0x8,%esp
801011b7:	89 f0                	mov    %esi,%eax
801011b9:	c1 f8 0c             	sar    $0xc,%eax
801011bc:	03 05 d8 09 11 80    	add    0x801109d8,%eax
801011c2:	50                   	push   %eax
801011c3:	ff 75 d8             	pushl  -0x28(%ebp)
801011c6:	e8 05 ef ff ff       	call   801000d0 <bread>
801011cb:	83 c4 10             	add    $0x10,%esp
801011ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011d1:	a1 c0 09 11 80       	mov    0x801109c0,%eax
801011d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801011d9:	31 c0                	xor    %eax,%eax
801011db:	eb 2f                	jmp    8010120c <balloc+0x7c>
801011dd:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801011e0:	89 c1                	mov    %eax,%ecx
801011e2:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011e7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
801011ea:	83 e1 07             	and    $0x7,%ecx
801011ed:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011ef:	89 c1                	mov    %eax,%ecx
801011f1:	c1 f9 03             	sar    $0x3,%ecx
801011f4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801011f9:	89 fa                	mov    %edi,%edx
801011fb:	85 df                	test   %ebx,%edi
801011fd:	74 41                	je     80101240 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011ff:	83 c0 01             	add    $0x1,%eax
80101202:	83 c6 01             	add    $0x1,%esi
80101205:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010120a:	74 05                	je     80101211 <balloc+0x81>
8010120c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010120f:	77 cf                	ja     801011e0 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101211:	83 ec 0c             	sub    $0xc,%esp
80101214:	ff 75 e4             	pushl  -0x1c(%ebp)
80101217:	e8 d4 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010121c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101223:	83 c4 10             	add    $0x10,%esp
80101226:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101229:	39 05 c0 09 11 80    	cmp    %eax,0x801109c0
8010122f:	77 80                	ja     801011b1 <balloc+0x21>
  }
  panic("balloc: out of blocks");
80101231:	83 ec 0c             	sub    $0xc,%esp
80101234:	68 df 70 10 80       	push   $0x801070df
80101239:	e8 52 f1 ff ff       	call   80100390 <panic>
8010123e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101240:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101243:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101246:	09 da                	or     %ebx,%edx
80101248:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010124c:	57                   	push   %edi
8010124d:	e8 2e 1c 00 00       	call   80102e80 <log_write>
        brelse(bp);
80101252:	89 3c 24             	mov    %edi,(%esp)
80101255:	e8 96 ef ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010125a:	58                   	pop    %eax
8010125b:	5a                   	pop    %edx
8010125c:	56                   	push   %esi
8010125d:	ff 75 d8             	pushl  -0x28(%ebp)
80101260:	e8 6b ee ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101265:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101268:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010126a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010126d:	68 00 02 00 00       	push   $0x200
80101272:	6a 00                	push   $0x0
80101274:	50                   	push   %eax
80101275:	e8 a6 33 00 00       	call   80104620 <memset>
  log_write(bp);
8010127a:	89 1c 24             	mov    %ebx,(%esp)
8010127d:	e8 fe 1b 00 00       	call   80102e80 <log_write>
  brelse(bp);
80101282:	89 1c 24             	mov    %ebx,(%esp)
80101285:	e8 66 ef ff ff       	call   801001f0 <brelse>
}
8010128a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010128d:	89 f0                	mov    %esi,%eax
8010128f:	5b                   	pop    %ebx
80101290:	5e                   	pop    %esi
80101291:	5f                   	pop    %edi
80101292:	5d                   	pop    %ebp
80101293:	c3                   	ret    
80101294:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010129a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801012a0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801012a0:	55                   	push   %ebp
801012a1:	89 e5                	mov    %esp,%ebp
801012a3:	57                   	push   %edi
801012a4:	89 c7                	mov    %eax,%edi
801012a6:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801012a7:	31 f6                	xor    %esi,%esi
{
801012a9:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012aa:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
{
801012af:	83 ec 28             	sub    $0x28,%esp
801012b2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801012b5:	68 e0 09 11 80       	push   $0x801109e0
801012ba:	e8 f1 31 00 00       	call   801044b0 <acquire>
801012bf:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012c2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801012c5:	eb 1b                	jmp    801012e2 <iget+0x42>
801012c7:	89 f6                	mov    %esi,%esi
801012c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801012d0:	39 3b                	cmp    %edi,(%ebx)
801012d2:	74 6c                	je     80101340 <iget+0xa0>
801012d4:	81 c3 90 00 00 00    	add    $0x90,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012da:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
801012e0:	73 26                	jae    80101308 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801012e2:	8b 4b 08             	mov    0x8(%ebx),%ecx
801012e5:	85 c9                	test   %ecx,%ecx
801012e7:	7f e7                	jg     801012d0 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801012e9:	85 f6                	test   %esi,%esi
801012eb:	75 e7                	jne    801012d4 <iget+0x34>
801012ed:	8d 83 90 00 00 00    	lea    0x90(%ebx),%eax
801012f3:	85 c9                	test   %ecx,%ecx
801012f5:	75 70                	jne    80101367 <iget+0xc7>
801012f7:	89 de                	mov    %ebx,%esi
801012f9:	89 c3                	mov    %eax,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012fb:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
80101301:	72 df                	jb     801012e2 <iget+0x42>
80101303:	90                   	nop
80101304:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101308:	85 f6                	test   %esi,%esi
8010130a:	74 74                	je     80101380 <iget+0xe0>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
8010130c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
8010130f:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101311:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101314:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
8010131b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80101322:	68 e0 09 11 80       	push   $0x801109e0
80101327:	e8 a4 32 00 00       	call   801045d0 <release>

  return ip;
8010132c:	83 c4 10             	add    $0x10,%esp
}
8010132f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101332:	89 f0                	mov    %esi,%eax
80101334:	5b                   	pop    %ebx
80101335:	5e                   	pop    %esi
80101336:	5f                   	pop    %edi
80101337:	5d                   	pop    %ebp
80101338:	c3                   	ret    
80101339:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101340:	39 53 04             	cmp    %edx,0x4(%ebx)
80101343:	75 8f                	jne    801012d4 <iget+0x34>
      release(&icache.lock);
80101345:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101348:	83 c1 01             	add    $0x1,%ecx
      return ip;
8010134b:	89 de                	mov    %ebx,%esi
      ip->ref++;
8010134d:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101350:	68 e0 09 11 80       	push   $0x801109e0
80101355:	e8 76 32 00 00       	call   801045d0 <release>
      return ip;
8010135a:	83 c4 10             	add    $0x10,%esp
}
8010135d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101360:	89 f0                	mov    %esi,%eax
80101362:	5b                   	pop    %ebx
80101363:	5e                   	pop    %esi
80101364:	5f                   	pop    %edi
80101365:	5d                   	pop    %ebp
80101366:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101367:	3d 34 26 11 80       	cmp    $0x80112634,%eax
8010136c:	73 12                	jae    80101380 <iget+0xe0>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010136e:	8b 48 08             	mov    0x8(%eax),%ecx
80101371:	89 c3                	mov    %eax,%ebx
80101373:	85 c9                	test   %ecx,%ecx
80101375:	0f 8f 55 ff ff ff    	jg     801012d0 <iget+0x30>
8010137b:	e9 6d ff ff ff       	jmp    801012ed <iget+0x4d>
    panic("iget: no inodes");
80101380:	83 ec 0c             	sub    $0xc,%esp
80101383:	68 f5 70 10 80       	push   $0x801070f5
80101388:	e8 03 f0 ff ff       	call   80100390 <panic>
8010138d:	8d 76 00             	lea    0x0(%esi),%esi

80101390 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101390:	55                   	push   %ebp
80101391:	89 e5                	mov    %esp,%ebp
80101393:	57                   	push   %edi
80101394:	56                   	push   %esi
80101395:	89 c6                	mov    %eax,%esi
80101397:	53                   	push   %ebx
80101398:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010139b:	83 fa 0b             	cmp    $0xb,%edx
8010139e:	0f 86 84 00 00 00    	jbe    80101428 <bmap+0x98>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
801013a4:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
801013a7:	83 fb 7f             	cmp    $0x7f,%ebx
801013aa:	0f 87 98 00 00 00    	ja     80101448 <bmap+0xb8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
801013b0:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
801013b6:	8b 00                	mov    (%eax),%eax
801013b8:	85 d2                	test   %edx,%edx
801013ba:	74 54                	je     80101410 <bmap+0x80>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801013bc:	83 ec 08             	sub    $0x8,%esp
801013bf:	52                   	push   %edx
801013c0:	50                   	push   %eax
801013c1:	e8 0a ed ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801013c6:	83 c4 10             	add    $0x10,%esp
801013c9:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
    bp = bread(ip->dev, addr);
801013cd:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
801013cf:	8b 1a                	mov    (%edx),%ebx
801013d1:	85 db                	test   %ebx,%ebx
801013d3:	74 1b                	je     801013f0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
801013d5:	83 ec 0c             	sub    $0xc,%esp
801013d8:	57                   	push   %edi
801013d9:	e8 12 ee ff ff       	call   801001f0 <brelse>
    return addr;
801013de:	83 c4 10             	add    $0x10,%esp
  }

  panic("bmap: out of range");
}
801013e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013e4:	89 d8                	mov    %ebx,%eax
801013e6:	5b                   	pop    %ebx
801013e7:	5e                   	pop    %esi
801013e8:	5f                   	pop    %edi
801013e9:	5d                   	pop    %ebp
801013ea:	c3                   	ret    
801013eb:	90                   	nop
801013ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      a[bn] = addr = balloc(ip->dev);
801013f0:	8b 06                	mov    (%esi),%eax
801013f2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801013f5:	e8 96 fd ff ff       	call   80101190 <balloc>
801013fa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
801013fd:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101400:	89 c3                	mov    %eax,%ebx
80101402:	89 02                	mov    %eax,(%edx)
      log_write(bp);
80101404:	57                   	push   %edi
80101405:	e8 76 1a 00 00       	call   80102e80 <log_write>
8010140a:	83 c4 10             	add    $0x10,%esp
8010140d:	eb c6                	jmp    801013d5 <bmap+0x45>
8010140f:	90                   	nop
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101410:	e8 7b fd ff ff       	call   80101190 <balloc>
80101415:	89 c2                	mov    %eax,%edx
80101417:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
8010141d:	8b 06                	mov    (%esi),%eax
8010141f:	eb 9b                	jmp    801013bc <bmap+0x2c>
80101421:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((addr = ip->addrs[bn]) == 0)
80101428:	8d 3c 90             	lea    (%eax,%edx,4),%edi
8010142b:	8b 5f 5c             	mov    0x5c(%edi),%ebx
8010142e:	85 db                	test   %ebx,%ebx
80101430:	75 af                	jne    801013e1 <bmap+0x51>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101432:	8b 00                	mov    (%eax),%eax
80101434:	e8 57 fd ff ff       	call   80101190 <balloc>
80101439:	89 47 5c             	mov    %eax,0x5c(%edi)
8010143c:	89 c3                	mov    %eax,%ebx
}
8010143e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101441:	89 d8                	mov    %ebx,%eax
80101443:	5b                   	pop    %ebx
80101444:	5e                   	pop    %esi
80101445:	5f                   	pop    %edi
80101446:	5d                   	pop    %ebp
80101447:	c3                   	ret    
  panic("bmap: out of range");
80101448:	83 ec 0c             	sub    $0xc,%esp
8010144b:	68 05 71 10 80       	push   $0x80107105
80101450:	e8 3b ef ff ff       	call   80100390 <panic>
80101455:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101460 <readsb>:
{
80101460:	55                   	push   %ebp
80101461:	89 e5                	mov    %esp,%ebp
80101463:	56                   	push   %esi
80101464:	53                   	push   %ebx
80101465:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101468:	83 ec 08             	sub    $0x8,%esp
8010146b:	6a 01                	push   $0x1
8010146d:	ff 75 08             	pushl  0x8(%ebp)
80101470:	e8 5b ec ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101475:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101478:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010147a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010147d:	6a 1c                	push   $0x1c
8010147f:	50                   	push   %eax
80101480:	56                   	push   %esi
80101481:	e8 3a 32 00 00       	call   801046c0 <memmove>
  brelse(bp);
80101486:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101489:	83 c4 10             	add    $0x10,%esp
}
8010148c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010148f:	5b                   	pop    %ebx
80101490:	5e                   	pop    %esi
80101491:	5d                   	pop    %ebp
  brelse(bp);
80101492:	e9 59 ed ff ff       	jmp    801001f0 <brelse>
80101497:	89 f6                	mov    %esi,%esi
80101499:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801014a0 <bfree>:
{
801014a0:	55                   	push   %ebp
801014a1:	89 e5                	mov    %esp,%ebp
801014a3:	56                   	push   %esi
801014a4:	89 c6                	mov    %eax,%esi
801014a6:	53                   	push   %ebx
801014a7:	89 d3                	mov    %edx,%ebx
  readsb(dev, &sb);
801014a9:	83 ec 08             	sub    $0x8,%esp
801014ac:	68 c0 09 11 80       	push   $0x801109c0
801014b1:	50                   	push   %eax
801014b2:	e8 a9 ff ff ff       	call   80101460 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
801014b7:	58                   	pop    %eax
801014b8:	5a                   	pop    %edx
801014b9:	89 da                	mov    %ebx,%edx
801014bb:	c1 ea 0c             	shr    $0xc,%edx
801014be:	03 15 d8 09 11 80    	add    0x801109d8,%edx
801014c4:	52                   	push   %edx
801014c5:	56                   	push   %esi
801014c6:	e8 05 ec ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
801014cb:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801014cd:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
801014d0:	ba 01 00 00 00       	mov    $0x1,%edx
801014d5:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
801014d8:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
801014de:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
801014e1:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
801014e3:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
801014e8:	85 d1                	test   %edx,%ecx
801014ea:	74 25                	je     80101511 <bfree+0x71>
  bp->data[bi/8] &= ~m;
801014ec:	f7 d2                	not    %edx
801014ee:	89 c6                	mov    %eax,%esi
  log_write(bp);
801014f0:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
801014f3:	21 ca                	and    %ecx,%edx
801014f5:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
801014f9:	56                   	push   %esi
801014fa:	e8 81 19 00 00       	call   80102e80 <log_write>
  brelse(bp);
801014ff:	89 34 24             	mov    %esi,(%esp)
80101502:	e8 e9 ec ff ff       	call   801001f0 <brelse>
}
80101507:	83 c4 10             	add    $0x10,%esp
8010150a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010150d:	5b                   	pop    %ebx
8010150e:	5e                   	pop    %esi
8010150f:	5d                   	pop    %ebp
80101510:	c3                   	ret    
    panic("freeing free block");
80101511:	83 ec 0c             	sub    $0xc,%esp
80101514:	68 18 71 10 80       	push   $0x80107118
80101519:	e8 72 ee ff ff       	call   80100390 <panic>
8010151e:	66 90                	xchg   %ax,%ax

80101520 <iinit>:
{
80101520:	55                   	push   %ebp
80101521:	89 e5                	mov    %esp,%ebp
80101523:	53                   	push   %ebx
80101524:	bb 20 0a 11 80       	mov    $0x80110a20,%ebx
80101529:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010152c:	68 2b 71 10 80       	push   $0x8010712b
80101531:	68 e0 09 11 80       	push   $0x801109e0
80101536:	e8 75 2e 00 00       	call   801043b0 <initlock>
  for(i = 0; i < NINODE; i++) {
8010153b:	83 c4 10             	add    $0x10,%esp
8010153e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101540:	83 ec 08             	sub    $0x8,%esp
80101543:	68 32 71 10 80       	push   $0x80107132
80101548:	53                   	push   %ebx
80101549:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010154f:	e8 4c 2d 00 00       	call   801042a0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101554:	83 c4 10             	add    $0x10,%esp
80101557:	81 fb 40 26 11 80    	cmp    $0x80112640,%ebx
8010155d:	75 e1                	jne    80101540 <iinit+0x20>
  readsb(dev, &sb);
8010155f:	83 ec 08             	sub    $0x8,%esp
80101562:	68 c0 09 11 80       	push   $0x801109c0
80101567:	ff 75 08             	pushl  0x8(%ebp)
8010156a:	e8 f1 fe ff ff       	call   80101460 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
8010156f:	ff 35 d8 09 11 80    	pushl  0x801109d8
80101575:	ff 35 d4 09 11 80    	pushl  0x801109d4
8010157b:	ff 35 d0 09 11 80    	pushl  0x801109d0
80101581:	ff 35 cc 09 11 80    	pushl  0x801109cc
80101587:	ff 35 c8 09 11 80    	pushl  0x801109c8
8010158d:	ff 35 c4 09 11 80    	pushl  0x801109c4
80101593:	ff 35 c0 09 11 80    	pushl  0x801109c0
80101599:	68 98 71 10 80       	push   $0x80107198
8010159e:	e8 0d f1 ff ff       	call   801006b0 <cprintf>
}
801015a3:	83 c4 30             	add    $0x30,%esp
801015a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801015a9:	c9                   	leave  
801015aa:	c3                   	ret    
801015ab:	90                   	nop
801015ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801015b0 <ialloc>:
{
801015b0:	55                   	push   %ebp
801015b1:	89 e5                	mov    %esp,%ebp
801015b3:	57                   	push   %edi
801015b4:	56                   	push   %esi
801015b5:	53                   	push   %ebx
801015b6:	83 ec 1c             	sub    $0x1c,%esp
801015b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
801015bc:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
{
801015c3:	8b 75 08             	mov    0x8(%ebp),%esi
801015c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
801015c9:	0f 86 91 00 00 00    	jbe    80101660 <ialloc+0xb0>
801015cf:	bb 01 00 00 00       	mov    $0x1,%ebx
801015d4:	eb 21                	jmp    801015f7 <ialloc+0x47>
801015d6:	8d 76 00             	lea    0x0(%esi),%esi
801015d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
801015e0:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
801015e3:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
801015e6:	57                   	push   %edi
801015e7:	e8 04 ec ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
801015ec:	83 c4 10             	add    $0x10,%esp
801015ef:	3b 1d c8 09 11 80    	cmp    0x801109c8,%ebx
801015f5:	73 69                	jae    80101660 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
801015f7:	89 d8                	mov    %ebx,%eax
801015f9:	83 ec 08             	sub    $0x8,%esp
801015fc:	c1 e8 03             	shr    $0x3,%eax
801015ff:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101605:	50                   	push   %eax
80101606:	56                   	push   %esi
80101607:	e8 c4 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010160c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010160f:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
80101611:	89 d8                	mov    %ebx,%eax
80101613:	83 e0 07             	and    $0x7,%eax
80101616:	c1 e0 06             	shl    $0x6,%eax
80101619:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010161d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101621:	75 bd                	jne    801015e0 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101623:	83 ec 04             	sub    $0x4,%esp
80101626:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101629:	6a 40                	push   $0x40
8010162b:	6a 00                	push   $0x0
8010162d:	51                   	push   %ecx
8010162e:	e8 ed 2f 00 00       	call   80104620 <memset>
      dip->type = type;
80101633:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101637:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010163a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010163d:	89 3c 24             	mov    %edi,(%esp)
80101640:	e8 3b 18 00 00       	call   80102e80 <log_write>
      brelse(bp);
80101645:	89 3c 24             	mov    %edi,(%esp)
80101648:	e8 a3 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
8010164d:	83 c4 10             	add    $0x10,%esp
}
80101650:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101653:	89 da                	mov    %ebx,%edx
80101655:	89 f0                	mov    %esi,%eax
}
80101657:	5b                   	pop    %ebx
80101658:	5e                   	pop    %esi
80101659:	5f                   	pop    %edi
8010165a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010165b:	e9 40 fc ff ff       	jmp    801012a0 <iget>
  panic("ialloc: no inodes");
80101660:	83 ec 0c             	sub    $0xc,%esp
80101663:	68 38 71 10 80       	push   $0x80107138
80101668:	e8 23 ed ff ff       	call   80100390 <panic>
8010166d:	8d 76 00             	lea    0x0(%esi),%esi

80101670 <iupdate>:
{
80101670:	55                   	push   %ebp
80101671:	89 e5                	mov    %esp,%ebp
80101673:	56                   	push   %esi
80101674:	53                   	push   %ebx
80101675:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101678:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010167b:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010167e:	83 ec 08             	sub    $0x8,%esp
80101681:	c1 e8 03             	shr    $0x3,%eax
80101684:	03 05 d4 09 11 80    	add    0x801109d4,%eax
8010168a:	50                   	push   %eax
8010168b:	ff 73 a4             	pushl  -0x5c(%ebx)
8010168e:	e8 3d ea ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101693:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101697:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010169a:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010169c:	8b 43 a8             	mov    -0x58(%ebx),%eax
8010169f:	83 e0 07             	and    $0x7,%eax
801016a2:	c1 e0 06             	shl    $0x6,%eax
801016a5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801016a9:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801016ac:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016b0:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
801016b3:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
801016b7:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801016bb:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
801016bf:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
801016c3:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
801016c7:	8b 53 fc             	mov    -0x4(%ebx),%edx
801016ca:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016cd:	6a 34                	push   $0x34
801016cf:	53                   	push   %ebx
801016d0:	50                   	push   %eax
801016d1:	e8 ea 2f 00 00       	call   801046c0 <memmove>
  log_write(bp);
801016d6:	89 34 24             	mov    %esi,(%esp)
801016d9:	e8 a2 17 00 00       	call   80102e80 <log_write>
  brelse(bp);
801016de:	89 75 08             	mov    %esi,0x8(%ebp)
801016e1:	83 c4 10             	add    $0x10,%esp
}
801016e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016e7:	5b                   	pop    %ebx
801016e8:	5e                   	pop    %esi
801016e9:	5d                   	pop    %ebp
  brelse(bp);
801016ea:	e9 01 eb ff ff       	jmp    801001f0 <brelse>
801016ef:	90                   	nop

801016f0 <idup>:
{
801016f0:	55                   	push   %ebp
801016f1:	89 e5                	mov    %esp,%ebp
801016f3:	53                   	push   %ebx
801016f4:	83 ec 10             	sub    $0x10,%esp
801016f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801016fa:	68 e0 09 11 80       	push   $0x801109e0
801016ff:	e8 ac 2d 00 00       	call   801044b0 <acquire>
  ip->ref++;
80101704:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101708:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010170f:	e8 bc 2e 00 00       	call   801045d0 <release>
}
80101714:	89 d8                	mov    %ebx,%eax
80101716:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101719:	c9                   	leave  
8010171a:	c3                   	ret    
8010171b:	90                   	nop
8010171c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101720 <ilock>:
{
80101720:	55                   	push   %ebp
80101721:	89 e5                	mov    %esp,%ebp
80101723:	56                   	push   %esi
80101724:	53                   	push   %ebx
80101725:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101728:	85 db                	test   %ebx,%ebx
8010172a:	0f 84 b7 00 00 00    	je     801017e7 <ilock+0xc7>
80101730:	8b 53 08             	mov    0x8(%ebx),%edx
80101733:	85 d2                	test   %edx,%edx
80101735:	0f 8e ac 00 00 00    	jle    801017e7 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010173b:	83 ec 0c             	sub    $0xc,%esp
8010173e:	8d 43 0c             	lea    0xc(%ebx),%eax
80101741:	50                   	push   %eax
80101742:	e8 99 2b 00 00       	call   801042e0 <acquiresleep>
  if(ip->valid == 0){
80101747:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010174a:	83 c4 10             	add    $0x10,%esp
8010174d:	85 c0                	test   %eax,%eax
8010174f:	74 0f                	je     80101760 <ilock+0x40>
}
80101751:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101754:	5b                   	pop    %ebx
80101755:	5e                   	pop    %esi
80101756:	5d                   	pop    %ebp
80101757:	c3                   	ret    
80101758:	90                   	nop
80101759:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101760:	8b 43 04             	mov    0x4(%ebx),%eax
80101763:	83 ec 08             	sub    $0x8,%esp
80101766:	c1 e8 03             	shr    $0x3,%eax
80101769:	03 05 d4 09 11 80    	add    0x801109d4,%eax
8010176f:	50                   	push   %eax
80101770:	ff 33                	pushl  (%ebx)
80101772:	e8 59 e9 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101777:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010177a:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010177c:	8b 43 04             	mov    0x4(%ebx),%eax
8010177f:	83 e0 07             	and    $0x7,%eax
80101782:	c1 e0 06             	shl    $0x6,%eax
80101785:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101789:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010178c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010178f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101793:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101797:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010179b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010179f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801017a3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801017a7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801017ab:	8b 50 fc             	mov    -0x4(%eax),%edx
801017ae:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017b1:	6a 34                	push   $0x34
801017b3:	50                   	push   %eax
801017b4:	8d 43 5c             	lea    0x5c(%ebx),%eax
801017b7:	50                   	push   %eax
801017b8:	e8 03 2f 00 00       	call   801046c0 <memmove>
    brelse(bp);
801017bd:	89 34 24             	mov    %esi,(%esp)
801017c0:	e8 2b ea ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
801017c5:	83 c4 10             	add    $0x10,%esp
801017c8:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
801017cd:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
801017d4:	0f 85 77 ff ff ff    	jne    80101751 <ilock+0x31>
      panic("ilock: no type");
801017da:	83 ec 0c             	sub    $0xc,%esp
801017dd:	68 50 71 10 80       	push   $0x80107150
801017e2:	e8 a9 eb ff ff       	call   80100390 <panic>
    panic("ilock");
801017e7:	83 ec 0c             	sub    $0xc,%esp
801017ea:	68 4a 71 10 80       	push   $0x8010714a
801017ef:	e8 9c eb ff ff       	call   80100390 <panic>
801017f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801017fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101800 <iunlock>:
{
80101800:	55                   	push   %ebp
80101801:	89 e5                	mov    %esp,%ebp
80101803:	56                   	push   %esi
80101804:	53                   	push   %ebx
80101805:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101808:	85 db                	test   %ebx,%ebx
8010180a:	74 28                	je     80101834 <iunlock+0x34>
8010180c:	83 ec 0c             	sub    $0xc,%esp
8010180f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101812:	56                   	push   %esi
80101813:	e8 68 2b 00 00       	call   80104380 <holdingsleep>
80101818:	83 c4 10             	add    $0x10,%esp
8010181b:	85 c0                	test   %eax,%eax
8010181d:	74 15                	je     80101834 <iunlock+0x34>
8010181f:	8b 43 08             	mov    0x8(%ebx),%eax
80101822:	85 c0                	test   %eax,%eax
80101824:	7e 0e                	jle    80101834 <iunlock+0x34>
  releasesleep(&ip->lock);
80101826:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101829:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010182c:	5b                   	pop    %ebx
8010182d:	5e                   	pop    %esi
8010182e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010182f:	e9 0c 2b 00 00       	jmp    80104340 <releasesleep>
    panic("iunlock");
80101834:	83 ec 0c             	sub    $0xc,%esp
80101837:	68 5f 71 10 80       	push   $0x8010715f
8010183c:	e8 4f eb ff ff       	call   80100390 <panic>
80101841:	eb 0d                	jmp    80101850 <iput>
80101843:	90                   	nop
80101844:	90                   	nop
80101845:	90                   	nop
80101846:	90                   	nop
80101847:	90                   	nop
80101848:	90                   	nop
80101849:	90                   	nop
8010184a:	90                   	nop
8010184b:	90                   	nop
8010184c:	90                   	nop
8010184d:	90                   	nop
8010184e:	90                   	nop
8010184f:	90                   	nop

80101850 <iput>:
{
80101850:	55                   	push   %ebp
80101851:	89 e5                	mov    %esp,%ebp
80101853:	57                   	push   %edi
80101854:	56                   	push   %esi
80101855:	53                   	push   %ebx
80101856:	83 ec 28             	sub    $0x28,%esp
80101859:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
8010185c:	8d 7b 0c             	lea    0xc(%ebx),%edi
8010185f:	57                   	push   %edi
80101860:	e8 7b 2a 00 00       	call   801042e0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101865:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101868:	83 c4 10             	add    $0x10,%esp
8010186b:	85 d2                	test   %edx,%edx
8010186d:	74 07                	je     80101876 <iput+0x26>
8010186f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101874:	74 32                	je     801018a8 <iput+0x58>
  releasesleep(&ip->lock);
80101876:	83 ec 0c             	sub    $0xc,%esp
80101879:	57                   	push   %edi
8010187a:	e8 c1 2a 00 00       	call   80104340 <releasesleep>
  acquire(&icache.lock);
8010187f:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101886:	e8 25 2c 00 00       	call   801044b0 <acquire>
  ip->ref--;
8010188b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010188f:	83 c4 10             	add    $0x10,%esp
80101892:	c7 45 08 e0 09 11 80 	movl   $0x801109e0,0x8(%ebp)
}
80101899:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010189c:	5b                   	pop    %ebx
8010189d:	5e                   	pop    %esi
8010189e:	5f                   	pop    %edi
8010189f:	5d                   	pop    %ebp
  release(&icache.lock);
801018a0:	e9 2b 2d 00 00       	jmp    801045d0 <release>
801018a5:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
801018a8:	83 ec 0c             	sub    $0xc,%esp
801018ab:	68 e0 09 11 80       	push   $0x801109e0
801018b0:	e8 fb 2b 00 00       	call   801044b0 <acquire>
    int r = ip->ref;
801018b5:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
801018b8:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801018bf:	e8 0c 2d 00 00       	call   801045d0 <release>
    if(r == 1){
801018c4:	83 c4 10             	add    $0x10,%esp
801018c7:	83 fe 01             	cmp    $0x1,%esi
801018ca:	75 aa                	jne    80101876 <iput+0x26>
801018cc:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
801018d2:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801018d5:	8d 73 5c             	lea    0x5c(%ebx),%esi
801018d8:	89 cf                	mov    %ecx,%edi
801018da:	eb 0b                	jmp    801018e7 <iput+0x97>
801018dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801018e0:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
801018e3:	39 fe                	cmp    %edi,%esi
801018e5:	74 19                	je     80101900 <iput+0xb0>
    if(ip->addrs[i]){
801018e7:	8b 16                	mov    (%esi),%edx
801018e9:	85 d2                	test   %edx,%edx
801018eb:	74 f3                	je     801018e0 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
801018ed:	8b 03                	mov    (%ebx),%eax
801018ef:	e8 ac fb ff ff       	call   801014a0 <bfree>
      ip->addrs[i] = 0;
801018f4:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801018fa:	eb e4                	jmp    801018e0 <iput+0x90>
801018fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101900:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101906:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101909:	85 c0                	test   %eax,%eax
8010190b:	75 33                	jne    80101940 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010190d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101910:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101917:	53                   	push   %ebx
80101918:	e8 53 fd ff ff       	call   80101670 <iupdate>
      ip->type = 0;
8010191d:	31 c0                	xor    %eax,%eax
8010191f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101923:	89 1c 24             	mov    %ebx,(%esp)
80101926:	e8 45 fd ff ff       	call   80101670 <iupdate>
      ip->valid = 0;
8010192b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101932:	83 c4 10             	add    $0x10,%esp
80101935:	e9 3c ff ff ff       	jmp    80101876 <iput+0x26>
8010193a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101940:	83 ec 08             	sub    $0x8,%esp
80101943:	50                   	push   %eax
80101944:	ff 33                	pushl  (%ebx)
80101946:	e8 85 e7 ff ff       	call   801000d0 <bread>
8010194b:	89 7d e0             	mov    %edi,-0x20(%ebp)
8010194e:	83 c4 10             	add    $0x10,%esp
80101951:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101957:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
8010195a:	8d 70 5c             	lea    0x5c(%eax),%esi
8010195d:	89 cf                	mov    %ecx,%edi
8010195f:	eb 0e                	jmp    8010196f <iput+0x11f>
80101961:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101968:	83 c6 04             	add    $0x4,%esi
8010196b:	39 f7                	cmp    %esi,%edi
8010196d:	74 11                	je     80101980 <iput+0x130>
      if(a[j])
8010196f:	8b 16                	mov    (%esi),%edx
80101971:	85 d2                	test   %edx,%edx
80101973:	74 f3                	je     80101968 <iput+0x118>
        bfree(ip->dev, a[j]);
80101975:	8b 03                	mov    (%ebx),%eax
80101977:	e8 24 fb ff ff       	call   801014a0 <bfree>
8010197c:	eb ea                	jmp    80101968 <iput+0x118>
8010197e:	66 90                	xchg   %ax,%ax
    brelse(bp);
80101980:	83 ec 0c             	sub    $0xc,%esp
80101983:	ff 75 e4             	pushl  -0x1c(%ebp)
80101986:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101989:	e8 62 e8 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
8010198e:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101994:	8b 03                	mov    (%ebx),%eax
80101996:	e8 05 fb ff ff       	call   801014a0 <bfree>
    ip->addrs[NDIRECT] = 0;
8010199b:	83 c4 10             	add    $0x10,%esp
8010199e:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
801019a5:	00 00 00 
801019a8:	e9 60 ff ff ff       	jmp    8010190d <iput+0xbd>
801019ad:	8d 76 00             	lea    0x0(%esi),%esi

801019b0 <iunlockput>:
{
801019b0:	55                   	push   %ebp
801019b1:	89 e5                	mov    %esp,%ebp
801019b3:	53                   	push   %ebx
801019b4:	83 ec 10             	sub    $0x10,%esp
801019b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
801019ba:	53                   	push   %ebx
801019bb:	e8 40 fe ff ff       	call   80101800 <iunlock>
  iput(ip);
801019c0:	89 5d 08             	mov    %ebx,0x8(%ebp)
801019c3:	83 c4 10             	add    $0x10,%esp
}
801019c6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801019c9:	c9                   	leave  
  iput(ip);
801019ca:	e9 81 fe ff ff       	jmp    80101850 <iput>
801019cf:	90                   	nop

801019d0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
801019d0:	55                   	push   %ebp
801019d1:	89 e5                	mov    %esp,%ebp
801019d3:	8b 55 08             	mov    0x8(%ebp),%edx
801019d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
801019d9:	8b 0a                	mov    (%edx),%ecx
801019db:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
801019de:	8b 4a 04             	mov    0x4(%edx),%ecx
801019e1:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
801019e4:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
801019e8:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
801019eb:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
801019ef:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
801019f3:	8b 52 58             	mov    0x58(%edx),%edx
801019f6:	89 50 10             	mov    %edx,0x10(%eax)
}
801019f9:	5d                   	pop    %ebp
801019fa:	c3                   	ret    
801019fb:	90                   	nop
801019fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101a00 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101a00:	55                   	push   %ebp
80101a01:	89 e5                	mov    %esp,%ebp
80101a03:	57                   	push   %edi
80101a04:	56                   	push   %esi
80101a05:	53                   	push   %ebx
80101a06:	83 ec 1c             	sub    $0x1c,%esp
80101a09:	8b 45 08             	mov    0x8(%ebp),%eax
80101a0c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a0f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a12:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a17:	89 75 e0             	mov    %esi,-0x20(%ebp)
80101a1a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a1d:	8b 75 10             	mov    0x10(%ebp),%esi
80101a20:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101a23:	0f 84 a7 00 00 00    	je     80101ad0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101a29:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a2c:	8b 40 58             	mov    0x58(%eax),%eax
80101a2f:	39 c6                	cmp    %eax,%esi
80101a31:	0f 87 ba 00 00 00    	ja     80101af1 <readi+0xf1>
80101a37:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101a3a:	89 f9                	mov    %edi,%ecx
80101a3c:	01 f1                	add    %esi,%ecx
80101a3e:	0f 82 ad 00 00 00    	jb     80101af1 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101a44:	89 c2                	mov    %eax,%edx
80101a46:	29 f2                	sub    %esi,%edx
80101a48:	39 c8                	cmp    %ecx,%eax
80101a4a:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a4d:	31 ff                	xor    %edi,%edi
    n = ip->size - off;
80101a4f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a52:	85 d2                	test   %edx,%edx
80101a54:	74 6c                	je     80101ac2 <readi+0xc2>
80101a56:	8d 76 00             	lea    0x0(%esi),%esi
80101a59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a60:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101a63:	89 f2                	mov    %esi,%edx
80101a65:	c1 ea 09             	shr    $0x9,%edx
80101a68:	89 d8                	mov    %ebx,%eax
80101a6a:	e8 21 f9 ff ff       	call   80101390 <bmap>
80101a6f:	83 ec 08             	sub    $0x8,%esp
80101a72:	50                   	push   %eax
80101a73:	ff 33                	pushl  (%ebx)
80101a75:	e8 56 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101a7a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101a7d:	b9 00 02 00 00       	mov    $0x200,%ecx
80101a82:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a85:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101a87:	89 f0                	mov    %esi,%eax
80101a89:	25 ff 01 00 00       	and    $0x1ff,%eax
80101a8e:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a90:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101a93:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101a95:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101a99:	39 d9                	cmp    %ebx,%ecx
80101a9b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a9e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a9f:	01 df                	add    %ebx,%edi
80101aa1:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101aa3:	50                   	push   %eax
80101aa4:	ff 75 e0             	pushl  -0x20(%ebp)
80101aa7:	e8 14 2c 00 00       	call   801046c0 <memmove>
    brelse(bp);
80101aac:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101aaf:	89 14 24             	mov    %edx,(%esp)
80101ab2:	e8 39 e7 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ab7:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101aba:	83 c4 10             	add    $0x10,%esp
80101abd:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101ac0:	77 9e                	ja     80101a60 <readi+0x60>
  }
  return n;
80101ac2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101ac5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ac8:	5b                   	pop    %ebx
80101ac9:	5e                   	pop    %esi
80101aca:	5f                   	pop    %edi
80101acb:	5d                   	pop    %ebp
80101acc:	c3                   	ret    
80101acd:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101ad0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101ad4:	66 83 f8 09          	cmp    $0x9,%ax
80101ad8:	77 17                	ja     80101af1 <readi+0xf1>
80101ada:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
80101ae1:	85 c0                	test   %eax,%eax
80101ae3:	74 0c                	je     80101af1 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101ae5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101ae8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101aeb:	5b                   	pop    %ebx
80101aec:	5e                   	pop    %esi
80101aed:	5f                   	pop    %edi
80101aee:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101aef:	ff e0                	jmp    *%eax
      return -1;
80101af1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101af6:	eb cd                	jmp    80101ac5 <readi+0xc5>
80101af8:	90                   	nop
80101af9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101b00 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101b00:	55                   	push   %ebp
80101b01:	89 e5                	mov    %esp,%ebp
80101b03:	57                   	push   %edi
80101b04:	56                   	push   %esi
80101b05:	53                   	push   %ebx
80101b06:	83 ec 1c             	sub    $0x1c,%esp
80101b09:	8b 45 08             	mov    0x8(%ebp),%eax
80101b0c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101b0f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b12:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101b17:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101b1a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101b1d:	8b 75 10             	mov    0x10(%ebp),%esi
80101b20:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101b23:	0f 84 b7 00 00 00    	je     80101be0 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101b29:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b2c:	39 70 58             	cmp    %esi,0x58(%eax)
80101b2f:	0f 82 e7 00 00 00    	jb     80101c1c <writei+0x11c>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101b35:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101b38:	89 f8                	mov    %edi,%eax
80101b3a:	01 f0                	add    %esi,%eax
80101b3c:	0f 82 da 00 00 00    	jb     80101c1c <writei+0x11c>
80101b42:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101b47:	0f 87 cf 00 00 00    	ja     80101c1c <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b4d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101b54:	85 ff                	test   %edi,%edi
80101b56:	74 79                	je     80101bd1 <writei+0xd1>
80101b58:	90                   	nop
80101b59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b60:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101b63:	89 f2                	mov    %esi,%edx
80101b65:	c1 ea 09             	shr    $0x9,%edx
80101b68:	89 f8                	mov    %edi,%eax
80101b6a:	e8 21 f8 ff ff       	call   80101390 <bmap>
80101b6f:	83 ec 08             	sub    $0x8,%esp
80101b72:	50                   	push   %eax
80101b73:	ff 37                	pushl  (%edi)
80101b75:	e8 56 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b7a:	b9 00 02 00 00       	mov    $0x200,%ecx
80101b7f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101b82:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b85:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101b87:	89 f0                	mov    %esi,%eax
80101b89:	83 c4 0c             	add    $0xc,%esp
80101b8c:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b91:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101b93:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b97:	39 d9                	cmp    %ebx,%ecx
80101b99:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101b9c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b9d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101b9f:	ff 75 dc             	pushl  -0x24(%ebp)
80101ba2:	50                   	push   %eax
80101ba3:	e8 18 2b 00 00       	call   801046c0 <memmove>
    log_write(bp);
80101ba8:	89 3c 24             	mov    %edi,(%esp)
80101bab:	e8 d0 12 00 00       	call   80102e80 <log_write>
    brelse(bp);
80101bb0:	89 3c 24             	mov    %edi,(%esp)
80101bb3:	e8 38 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bb8:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101bbb:	83 c4 10             	add    $0x10,%esp
80101bbe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101bc1:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101bc4:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101bc7:	77 97                	ja     80101b60 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101bc9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bcc:	3b 70 58             	cmp    0x58(%eax),%esi
80101bcf:	77 37                	ja     80101c08 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101bd1:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101bd4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bd7:	5b                   	pop    %ebx
80101bd8:	5e                   	pop    %esi
80101bd9:	5f                   	pop    %edi
80101bda:	5d                   	pop    %ebp
80101bdb:	c3                   	ret    
80101bdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101be0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101be4:	66 83 f8 09          	cmp    $0x9,%ax
80101be8:	77 32                	ja     80101c1c <writei+0x11c>
80101bea:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
80101bf1:	85 c0                	test   %eax,%eax
80101bf3:	74 27                	je     80101c1c <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101bf5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101bf8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bfb:	5b                   	pop    %ebx
80101bfc:	5e                   	pop    %esi
80101bfd:	5f                   	pop    %edi
80101bfe:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101bff:	ff e0                	jmp    *%eax
80101c01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101c08:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101c0b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101c0e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101c11:	50                   	push   %eax
80101c12:	e8 59 fa ff ff       	call   80101670 <iupdate>
80101c17:	83 c4 10             	add    $0x10,%esp
80101c1a:	eb b5                	jmp    80101bd1 <writei+0xd1>
      return -1;
80101c1c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c21:	eb b1                	jmp    80101bd4 <writei+0xd4>
80101c23:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101c29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101c30 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101c30:	55                   	push   %ebp
80101c31:	89 e5                	mov    %esp,%ebp
80101c33:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101c36:	6a 0e                	push   $0xe
80101c38:	ff 75 0c             	pushl  0xc(%ebp)
80101c3b:	ff 75 08             	pushl  0x8(%ebp)
80101c3e:	e8 ed 2a 00 00       	call   80104730 <strncmp>
}
80101c43:	c9                   	leave  
80101c44:	c3                   	ret    
80101c45:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101c49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101c50 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101c50:	55                   	push   %ebp
80101c51:	89 e5                	mov    %esp,%ebp
80101c53:	57                   	push   %edi
80101c54:	56                   	push   %esi
80101c55:	53                   	push   %ebx
80101c56:	83 ec 1c             	sub    $0x1c,%esp
80101c59:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101c5c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101c61:	0f 85 85 00 00 00    	jne    80101cec <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101c67:	8b 53 58             	mov    0x58(%ebx),%edx
80101c6a:	31 ff                	xor    %edi,%edi
80101c6c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101c6f:	85 d2                	test   %edx,%edx
80101c71:	74 3e                	je     80101cb1 <dirlookup+0x61>
80101c73:	90                   	nop
80101c74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101c78:	6a 10                	push   $0x10
80101c7a:	57                   	push   %edi
80101c7b:	56                   	push   %esi
80101c7c:	53                   	push   %ebx
80101c7d:	e8 7e fd ff ff       	call   80101a00 <readi>
80101c82:	83 c4 10             	add    $0x10,%esp
80101c85:	83 f8 10             	cmp    $0x10,%eax
80101c88:	75 55                	jne    80101cdf <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101c8a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101c8f:	74 18                	je     80101ca9 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101c91:	83 ec 04             	sub    $0x4,%esp
80101c94:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c97:	6a 0e                	push   $0xe
80101c99:	50                   	push   %eax
80101c9a:	ff 75 0c             	pushl  0xc(%ebp)
80101c9d:	e8 8e 2a 00 00       	call   80104730 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101ca2:	83 c4 10             	add    $0x10,%esp
80101ca5:	85 c0                	test   %eax,%eax
80101ca7:	74 17                	je     80101cc0 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101ca9:	83 c7 10             	add    $0x10,%edi
80101cac:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101caf:	72 c7                	jb     80101c78 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101cb1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101cb4:	31 c0                	xor    %eax,%eax
}
80101cb6:	5b                   	pop    %ebx
80101cb7:	5e                   	pop    %esi
80101cb8:	5f                   	pop    %edi
80101cb9:	5d                   	pop    %ebp
80101cba:	c3                   	ret    
80101cbb:	90                   	nop
80101cbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80101cc0:	8b 45 10             	mov    0x10(%ebp),%eax
80101cc3:	85 c0                	test   %eax,%eax
80101cc5:	74 05                	je     80101ccc <dirlookup+0x7c>
        *poff = off;
80101cc7:	8b 45 10             	mov    0x10(%ebp),%eax
80101cca:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101ccc:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101cd0:	8b 03                	mov    (%ebx),%eax
80101cd2:	e8 c9 f5 ff ff       	call   801012a0 <iget>
}
80101cd7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101cda:	5b                   	pop    %ebx
80101cdb:	5e                   	pop    %esi
80101cdc:	5f                   	pop    %edi
80101cdd:	5d                   	pop    %ebp
80101cde:	c3                   	ret    
      panic("dirlookup read");
80101cdf:	83 ec 0c             	sub    $0xc,%esp
80101ce2:	68 79 71 10 80       	push   $0x80107179
80101ce7:	e8 a4 e6 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101cec:	83 ec 0c             	sub    $0xc,%esp
80101cef:	68 67 71 10 80       	push   $0x80107167
80101cf4:	e8 97 e6 ff ff       	call   80100390 <panic>
80101cf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101d00 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101d00:	55                   	push   %ebp
80101d01:	89 e5                	mov    %esp,%ebp
80101d03:	57                   	push   %edi
80101d04:	56                   	push   %esi
80101d05:	53                   	push   %ebx
80101d06:	89 c3                	mov    %eax,%ebx
80101d08:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101d0b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101d0e:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101d11:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101d14:	0f 84 86 01 00 00    	je     80101ea0 <namex+0x1a0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101d1a:	e8 c1 1b 00 00       	call   801038e0 <myproc>
  acquire(&icache.lock);
80101d1f:	83 ec 0c             	sub    $0xc,%esp
80101d22:	89 df                	mov    %ebx,%edi
    ip = idup(myproc()->cwd);
80101d24:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101d27:	68 e0 09 11 80       	push   $0x801109e0
80101d2c:	e8 7f 27 00 00       	call   801044b0 <acquire>
  ip->ref++;
80101d31:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101d35:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101d3c:	e8 8f 28 00 00       	call   801045d0 <release>
80101d41:	83 c4 10             	add    $0x10,%esp
80101d44:	eb 0d                	jmp    80101d53 <namex+0x53>
80101d46:	8d 76 00             	lea    0x0(%esi),%esi
80101d49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101d50:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101d53:	0f b6 07             	movzbl (%edi),%eax
80101d56:	3c 2f                	cmp    $0x2f,%al
80101d58:	74 f6                	je     80101d50 <namex+0x50>
  if(*path == 0)
80101d5a:	84 c0                	test   %al,%al
80101d5c:	0f 84 ee 00 00 00    	je     80101e50 <namex+0x150>
  while(*path != '/' && *path != 0)
80101d62:	0f b6 07             	movzbl (%edi),%eax
80101d65:	3c 2f                	cmp    $0x2f,%al
80101d67:	0f 84 fb 00 00 00    	je     80101e68 <namex+0x168>
80101d6d:	89 fb                	mov    %edi,%ebx
80101d6f:	84 c0                	test   %al,%al
80101d71:	0f 84 f1 00 00 00    	je     80101e68 <namex+0x168>
80101d77:	89 f6                	mov    %esi,%esi
80101d79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101d80:	83 c3 01             	add    $0x1,%ebx
  while(*path != '/' && *path != 0)
80101d83:	0f b6 03             	movzbl (%ebx),%eax
80101d86:	3c 2f                	cmp    $0x2f,%al
80101d88:	74 04                	je     80101d8e <namex+0x8e>
80101d8a:	84 c0                	test   %al,%al
80101d8c:	75 f2                	jne    80101d80 <namex+0x80>
  len = path - s;
80101d8e:	89 d8                	mov    %ebx,%eax
80101d90:	29 f8                	sub    %edi,%eax
  if(len >= DIRSIZ)
80101d92:	83 f8 0d             	cmp    $0xd,%eax
80101d95:	0f 8e 85 00 00 00    	jle    80101e20 <namex+0x120>
    memmove(name, s, DIRSIZ);
80101d9b:	83 ec 04             	sub    $0x4,%esp
80101d9e:	6a 0e                	push   $0xe
80101da0:	57                   	push   %edi
    path++;
80101da1:	89 df                	mov    %ebx,%edi
    memmove(name, s, DIRSIZ);
80101da3:	ff 75 e4             	pushl  -0x1c(%ebp)
80101da6:	e8 15 29 00 00       	call   801046c0 <memmove>
80101dab:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101dae:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101db1:	75 0d                	jne    80101dc0 <namex+0xc0>
80101db3:	90                   	nop
80101db4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101db8:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101dbb:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101dbe:	74 f8                	je     80101db8 <namex+0xb8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101dc0:	83 ec 0c             	sub    $0xc,%esp
80101dc3:	56                   	push   %esi
80101dc4:	e8 57 f9 ff ff       	call   80101720 <ilock>
    if(ip->type != T_DIR){
80101dc9:	83 c4 10             	add    $0x10,%esp
80101dcc:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101dd1:	0f 85 a1 00 00 00    	jne    80101e78 <namex+0x178>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101dd7:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101dda:	85 d2                	test   %edx,%edx
80101ddc:	74 09                	je     80101de7 <namex+0xe7>
80101dde:	80 3f 00             	cmpb   $0x0,(%edi)
80101de1:	0f 84 d9 00 00 00    	je     80101ec0 <namex+0x1c0>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101de7:	83 ec 04             	sub    $0x4,%esp
80101dea:	6a 00                	push   $0x0
80101dec:	ff 75 e4             	pushl  -0x1c(%ebp)
80101def:	56                   	push   %esi
80101df0:	e8 5b fe ff ff       	call   80101c50 <dirlookup>
80101df5:	83 c4 10             	add    $0x10,%esp
80101df8:	89 c3                	mov    %eax,%ebx
80101dfa:	85 c0                	test   %eax,%eax
80101dfc:	74 7a                	je     80101e78 <namex+0x178>
  iunlock(ip);
80101dfe:	83 ec 0c             	sub    $0xc,%esp
80101e01:	56                   	push   %esi
80101e02:	e8 f9 f9 ff ff       	call   80101800 <iunlock>
  iput(ip);
80101e07:	89 34 24             	mov    %esi,(%esp)
80101e0a:	89 de                	mov    %ebx,%esi
80101e0c:	e8 3f fa ff ff       	call   80101850 <iput>
  while(*path == '/')
80101e11:	83 c4 10             	add    $0x10,%esp
80101e14:	e9 3a ff ff ff       	jmp    80101d53 <namex+0x53>
80101e19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e20:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101e23:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80101e26:	89 4d dc             	mov    %ecx,-0x24(%ebp)
    memmove(name, s, len);
80101e29:	83 ec 04             	sub    $0x4,%esp
80101e2c:	50                   	push   %eax
80101e2d:	57                   	push   %edi
    name[len] = 0;
80101e2e:	89 df                	mov    %ebx,%edi
    memmove(name, s, len);
80101e30:	ff 75 e4             	pushl  -0x1c(%ebp)
80101e33:	e8 88 28 00 00       	call   801046c0 <memmove>
    name[len] = 0;
80101e38:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101e3b:	83 c4 10             	add    $0x10,%esp
80101e3e:	c6 00 00             	movb   $0x0,(%eax)
80101e41:	e9 68 ff ff ff       	jmp    80101dae <namex+0xae>
80101e46:	8d 76 00             	lea    0x0(%esi),%esi
80101e49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101e50:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101e53:	85 c0                	test   %eax,%eax
80101e55:	0f 85 85 00 00 00    	jne    80101ee0 <namex+0x1e0>
    iput(ip);
    return 0;
  }
  return ip;
}
80101e5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e5e:	89 f0                	mov    %esi,%eax
80101e60:	5b                   	pop    %ebx
80101e61:	5e                   	pop    %esi
80101e62:	5f                   	pop    %edi
80101e63:	5d                   	pop    %ebp
80101e64:	c3                   	ret    
80101e65:	8d 76 00             	lea    0x0(%esi),%esi
  while(*path != '/' && *path != 0)
80101e68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101e6b:	89 fb                	mov    %edi,%ebx
80101e6d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101e70:	31 c0                	xor    %eax,%eax
80101e72:	eb b5                	jmp    80101e29 <namex+0x129>
80101e74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101e78:	83 ec 0c             	sub    $0xc,%esp
80101e7b:	56                   	push   %esi
80101e7c:	e8 7f f9 ff ff       	call   80101800 <iunlock>
  iput(ip);
80101e81:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101e84:	31 f6                	xor    %esi,%esi
  iput(ip);
80101e86:	e8 c5 f9 ff ff       	call   80101850 <iput>
      return 0;
80101e8b:	83 c4 10             	add    $0x10,%esp
}
80101e8e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e91:	89 f0                	mov    %esi,%eax
80101e93:	5b                   	pop    %ebx
80101e94:	5e                   	pop    %esi
80101e95:	5f                   	pop    %edi
80101e96:	5d                   	pop    %ebp
80101e97:	c3                   	ret    
80101e98:	90                   	nop
80101e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip = iget(ROOTDEV, ROOTINO);
80101ea0:	ba 01 00 00 00       	mov    $0x1,%edx
80101ea5:	b8 01 00 00 00       	mov    $0x1,%eax
80101eaa:	89 df                	mov    %ebx,%edi
80101eac:	e8 ef f3 ff ff       	call   801012a0 <iget>
80101eb1:	89 c6                	mov    %eax,%esi
80101eb3:	e9 9b fe ff ff       	jmp    80101d53 <namex+0x53>
80101eb8:	90                   	nop
80101eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      iunlock(ip);
80101ec0:	83 ec 0c             	sub    $0xc,%esp
80101ec3:	56                   	push   %esi
80101ec4:	e8 37 f9 ff ff       	call   80101800 <iunlock>
      return ip;
80101ec9:	83 c4 10             	add    $0x10,%esp
}
80101ecc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ecf:	89 f0                	mov    %esi,%eax
80101ed1:	5b                   	pop    %ebx
80101ed2:	5e                   	pop    %esi
80101ed3:	5f                   	pop    %edi
80101ed4:	5d                   	pop    %ebp
80101ed5:	c3                   	ret    
80101ed6:	8d 76 00             	lea    0x0(%esi),%esi
80101ed9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iput(ip);
80101ee0:	83 ec 0c             	sub    $0xc,%esp
80101ee3:	56                   	push   %esi
    return 0;
80101ee4:	31 f6                	xor    %esi,%esi
    iput(ip);
80101ee6:	e8 65 f9 ff ff       	call   80101850 <iput>
    return 0;
80101eeb:	83 c4 10             	add    $0x10,%esp
80101eee:	e9 68 ff ff ff       	jmp    80101e5b <namex+0x15b>
80101ef3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f00 <dirlink>:
{
80101f00:	55                   	push   %ebp
80101f01:	89 e5                	mov    %esp,%ebp
80101f03:	57                   	push   %edi
80101f04:	56                   	push   %esi
80101f05:	53                   	push   %ebx
80101f06:	83 ec 20             	sub    $0x20,%esp
80101f09:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101f0c:	6a 00                	push   $0x0
80101f0e:	ff 75 0c             	pushl  0xc(%ebp)
80101f11:	53                   	push   %ebx
80101f12:	e8 39 fd ff ff       	call   80101c50 <dirlookup>
80101f17:	83 c4 10             	add    $0x10,%esp
80101f1a:	85 c0                	test   %eax,%eax
80101f1c:	75 67                	jne    80101f85 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101f1e:	8b 7b 58             	mov    0x58(%ebx),%edi
80101f21:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101f24:	85 ff                	test   %edi,%edi
80101f26:	74 29                	je     80101f51 <dirlink+0x51>
80101f28:	31 ff                	xor    %edi,%edi
80101f2a:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101f2d:	eb 09                	jmp    80101f38 <dirlink+0x38>
80101f2f:	90                   	nop
80101f30:	83 c7 10             	add    $0x10,%edi
80101f33:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101f36:	73 19                	jae    80101f51 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f38:	6a 10                	push   $0x10
80101f3a:	57                   	push   %edi
80101f3b:	56                   	push   %esi
80101f3c:	53                   	push   %ebx
80101f3d:	e8 be fa ff ff       	call   80101a00 <readi>
80101f42:	83 c4 10             	add    $0x10,%esp
80101f45:	83 f8 10             	cmp    $0x10,%eax
80101f48:	75 4e                	jne    80101f98 <dirlink+0x98>
    if(de.inum == 0)
80101f4a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101f4f:	75 df                	jne    80101f30 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80101f51:	83 ec 04             	sub    $0x4,%esp
80101f54:	8d 45 da             	lea    -0x26(%ebp),%eax
80101f57:	6a 0e                	push   $0xe
80101f59:	ff 75 0c             	pushl  0xc(%ebp)
80101f5c:	50                   	push   %eax
80101f5d:	e8 2e 28 00 00       	call   80104790 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f62:	6a 10                	push   $0x10
  de.inum = inum;
80101f64:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f67:	57                   	push   %edi
80101f68:	56                   	push   %esi
80101f69:	53                   	push   %ebx
  de.inum = inum;
80101f6a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f6e:	e8 8d fb ff ff       	call   80101b00 <writei>
80101f73:	83 c4 20             	add    $0x20,%esp
80101f76:	83 f8 10             	cmp    $0x10,%eax
80101f79:	75 2a                	jne    80101fa5 <dirlink+0xa5>
  return 0;
80101f7b:	31 c0                	xor    %eax,%eax
}
80101f7d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f80:	5b                   	pop    %ebx
80101f81:	5e                   	pop    %esi
80101f82:	5f                   	pop    %edi
80101f83:	5d                   	pop    %ebp
80101f84:	c3                   	ret    
    iput(ip);
80101f85:	83 ec 0c             	sub    $0xc,%esp
80101f88:	50                   	push   %eax
80101f89:	e8 c2 f8 ff ff       	call   80101850 <iput>
    return -1;
80101f8e:	83 c4 10             	add    $0x10,%esp
80101f91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f96:	eb e5                	jmp    80101f7d <dirlink+0x7d>
      panic("dirlink read");
80101f98:	83 ec 0c             	sub    $0xc,%esp
80101f9b:	68 88 71 10 80       	push   $0x80107188
80101fa0:	e8 eb e3 ff ff       	call   80100390 <panic>
    panic("dirlink");
80101fa5:	83 ec 0c             	sub    $0xc,%esp
80101fa8:	68 e2 77 10 80       	push   $0x801077e2
80101fad:	e8 de e3 ff ff       	call   80100390 <panic>
80101fb2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101fc0 <namei>:

struct inode*
namei(char *path)
{
80101fc0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101fc1:	31 d2                	xor    %edx,%edx
{
80101fc3:	89 e5                	mov    %esp,%ebp
80101fc5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80101fc8:	8b 45 08             	mov    0x8(%ebp),%eax
80101fcb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101fce:	e8 2d fd ff ff       	call   80101d00 <namex>
}
80101fd3:	c9                   	leave  
80101fd4:	c3                   	ret    
80101fd5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101fd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101fe0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101fe0:	55                   	push   %ebp
  return namex(path, 1, name);
80101fe1:	ba 01 00 00 00       	mov    $0x1,%edx
{
80101fe6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101fe8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101feb:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101fee:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101fef:	e9 0c fd ff ff       	jmp    80101d00 <namex>
80101ff4:	66 90                	xchg   %ax,%ax
80101ff6:	66 90                	xchg   %ax,%ax
80101ff8:	66 90                	xchg   %ax,%ax
80101ffa:	66 90                	xchg   %ax,%ax
80101ffc:	66 90                	xchg   %ax,%ax
80101ffe:	66 90                	xchg   %ax,%ax

80102000 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102000:	55                   	push   %ebp
80102001:	89 e5                	mov    %esp,%ebp
80102003:	57                   	push   %edi
80102004:	56                   	push   %esi
80102005:	53                   	push   %ebx
80102006:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102009:	85 c0                	test   %eax,%eax
8010200b:	0f 84 b4 00 00 00    	je     801020c5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102011:	8b 70 08             	mov    0x8(%eax),%esi
80102014:	89 c3                	mov    %eax,%ebx
80102016:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010201c:	0f 87 96 00 00 00    	ja     801020b8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102022:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102027:	89 f6                	mov    %esi,%esi
80102029:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102030:	89 ca                	mov    %ecx,%edx
80102032:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102033:	83 e0 c0             	and    $0xffffffc0,%eax
80102036:	3c 40                	cmp    $0x40,%al
80102038:	75 f6                	jne    80102030 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010203a:	31 ff                	xor    %edi,%edi
8010203c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102041:	89 f8                	mov    %edi,%eax
80102043:	ee                   	out    %al,(%dx)
80102044:	b8 01 00 00 00       	mov    $0x1,%eax
80102049:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010204e:	ee                   	out    %al,(%dx)
8010204f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102054:	89 f0                	mov    %esi,%eax
80102056:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102057:	89 f0                	mov    %esi,%eax
80102059:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010205e:	c1 f8 08             	sar    $0x8,%eax
80102061:	ee                   	out    %al,(%dx)
80102062:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102067:	89 f8                	mov    %edi,%eax
80102069:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010206a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010206e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102073:	c1 e0 04             	shl    $0x4,%eax
80102076:	83 e0 10             	and    $0x10,%eax
80102079:	83 c8 e0             	or     $0xffffffe0,%eax
8010207c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010207d:	f6 03 04             	testb  $0x4,(%ebx)
80102080:	75 16                	jne    80102098 <idestart+0x98>
80102082:	b8 20 00 00 00       	mov    $0x20,%eax
80102087:	89 ca                	mov    %ecx,%edx
80102089:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010208a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010208d:	5b                   	pop    %ebx
8010208e:	5e                   	pop    %esi
8010208f:	5f                   	pop    %edi
80102090:	5d                   	pop    %ebp
80102091:	c3                   	ret    
80102092:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102098:	b8 30 00 00 00       	mov    $0x30,%eax
8010209d:	89 ca                	mov    %ecx,%edx
8010209f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
801020a0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
801020a5:	8d 73 5c             	lea    0x5c(%ebx),%esi
801020a8:	ba f0 01 00 00       	mov    $0x1f0,%edx
801020ad:	fc                   	cld    
801020ae:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
801020b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020b3:	5b                   	pop    %ebx
801020b4:	5e                   	pop    %esi
801020b5:	5f                   	pop    %edi
801020b6:	5d                   	pop    %ebp
801020b7:	c3                   	ret    
    panic("incorrect blockno");
801020b8:	83 ec 0c             	sub    $0xc,%esp
801020bb:	68 f4 71 10 80       	push   $0x801071f4
801020c0:	e8 cb e2 ff ff       	call   80100390 <panic>
    panic("idestart");
801020c5:	83 ec 0c             	sub    $0xc,%esp
801020c8:	68 eb 71 10 80       	push   $0x801071eb
801020cd:	e8 be e2 ff ff       	call   80100390 <panic>
801020d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801020e0 <ideinit>:
{
801020e0:	55                   	push   %ebp
801020e1:	89 e5                	mov    %esp,%ebp
801020e3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801020e6:	68 06 72 10 80       	push   $0x80107206
801020eb:	68 80 a5 10 80       	push   $0x8010a580
801020f0:	e8 bb 22 00 00       	call   801043b0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801020f5:	58                   	pop    %eax
801020f6:	a1 00 2d 11 80       	mov    0x80112d00,%eax
801020fb:	5a                   	pop    %edx
801020fc:	83 e8 01             	sub    $0x1,%eax
801020ff:	50                   	push   %eax
80102100:	6a 0e                	push   $0xe
80102102:	e8 a9 02 00 00       	call   801023b0 <ioapicenable>
80102107:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010210a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010210f:	90                   	nop
80102110:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102111:	83 e0 c0             	and    $0xffffffc0,%eax
80102114:	3c 40                	cmp    $0x40,%al
80102116:	75 f8                	jne    80102110 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102118:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010211d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102122:	ee                   	out    %al,(%dx)
80102123:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102128:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010212d:	eb 06                	jmp    80102135 <ideinit+0x55>
8010212f:	90                   	nop
  for(i=0; i<1000; i++){
80102130:	83 e9 01             	sub    $0x1,%ecx
80102133:	74 0f                	je     80102144 <ideinit+0x64>
80102135:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102136:	84 c0                	test   %al,%al
80102138:	74 f6                	je     80102130 <ideinit+0x50>
      havedisk1 = 1;
8010213a:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80102141:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102144:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102149:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010214e:	ee                   	out    %al,(%dx)
}
8010214f:	c9                   	leave  
80102150:	c3                   	ret    
80102151:	eb 0d                	jmp    80102160 <ideintr>
80102153:	90                   	nop
80102154:	90                   	nop
80102155:	90                   	nop
80102156:	90                   	nop
80102157:	90                   	nop
80102158:	90                   	nop
80102159:	90                   	nop
8010215a:	90                   	nop
8010215b:	90                   	nop
8010215c:	90                   	nop
8010215d:	90                   	nop
8010215e:	90                   	nop
8010215f:	90                   	nop

80102160 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102160:	55                   	push   %ebp
80102161:	89 e5                	mov    %esp,%ebp
80102163:	57                   	push   %edi
80102164:	56                   	push   %esi
80102165:	53                   	push   %ebx
80102166:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102169:	68 80 a5 10 80       	push   $0x8010a580
8010216e:	e8 3d 23 00 00       	call   801044b0 <acquire>

  if((b = idequeue) == 0){
80102173:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
80102179:	83 c4 10             	add    $0x10,%esp
8010217c:	85 db                	test   %ebx,%ebx
8010217e:	74 63                	je     801021e3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102180:	8b 43 58             	mov    0x58(%ebx),%eax
80102183:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102188:	8b 33                	mov    (%ebx),%esi
8010218a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102190:	75 2f                	jne    801021c1 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102192:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102197:	89 f6                	mov    %esi,%esi
80102199:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801021a0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801021a1:	89 c1                	mov    %eax,%ecx
801021a3:	83 e1 c0             	and    $0xffffffc0,%ecx
801021a6:	80 f9 40             	cmp    $0x40,%cl
801021a9:	75 f5                	jne    801021a0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801021ab:	a8 21                	test   $0x21,%al
801021ad:	75 12                	jne    801021c1 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
801021af:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801021b2:	b9 80 00 00 00       	mov    $0x80,%ecx
801021b7:	ba f0 01 00 00       	mov    $0x1f0,%edx
801021bc:	fc                   	cld    
801021bd:	f3 6d                	rep insl (%dx),%es:(%edi)
801021bf:	8b 33                	mov    (%ebx),%esi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801021c1:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
801021c4:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801021c7:	83 ce 02             	or     $0x2,%esi
801021ca:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801021cc:	53                   	push   %ebx
801021cd:	e8 5e 1e 00 00       	call   80104030 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801021d2:	a1 64 a5 10 80       	mov    0x8010a564,%eax
801021d7:	83 c4 10             	add    $0x10,%esp
801021da:	85 c0                	test   %eax,%eax
801021dc:	74 05                	je     801021e3 <ideintr+0x83>
    idestart(idequeue);
801021de:	e8 1d fe ff ff       	call   80102000 <idestart>
    release(&idelock);
801021e3:	83 ec 0c             	sub    $0xc,%esp
801021e6:	68 80 a5 10 80       	push   $0x8010a580
801021eb:	e8 e0 23 00 00       	call   801045d0 <release>

  release(&idelock);
}
801021f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021f3:	5b                   	pop    %ebx
801021f4:	5e                   	pop    %esi
801021f5:	5f                   	pop    %edi
801021f6:	5d                   	pop    %ebp
801021f7:	c3                   	ret    
801021f8:	90                   	nop
801021f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102200 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102200:	55                   	push   %ebp
80102201:	89 e5                	mov    %esp,%ebp
80102203:	53                   	push   %ebx
80102204:	83 ec 10             	sub    $0x10,%esp
80102207:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010220a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010220d:	50                   	push   %eax
8010220e:	e8 6d 21 00 00       	call   80104380 <holdingsleep>
80102213:	83 c4 10             	add    $0x10,%esp
80102216:	85 c0                	test   %eax,%eax
80102218:	0f 84 d3 00 00 00    	je     801022f1 <iderw+0xf1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010221e:	8b 03                	mov    (%ebx),%eax
80102220:	83 e0 06             	and    $0x6,%eax
80102223:	83 f8 02             	cmp    $0x2,%eax
80102226:	0f 84 b8 00 00 00    	je     801022e4 <iderw+0xe4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010222c:	8b 53 04             	mov    0x4(%ebx),%edx
8010222f:	85 d2                	test   %edx,%edx
80102231:	74 0d                	je     80102240 <iderw+0x40>
80102233:	a1 60 a5 10 80       	mov    0x8010a560,%eax
80102238:	85 c0                	test   %eax,%eax
8010223a:	0f 84 97 00 00 00    	je     801022d7 <iderw+0xd7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102240:	83 ec 0c             	sub    $0xc,%esp
80102243:	68 80 a5 10 80       	push   $0x8010a580
80102248:	e8 63 22 00 00       	call   801044b0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010224d:	8b 15 64 a5 10 80    	mov    0x8010a564,%edx
  b->qnext = 0;
80102253:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010225a:	83 c4 10             	add    $0x10,%esp
8010225d:	85 d2                	test   %edx,%edx
8010225f:	75 09                	jne    8010226a <iderw+0x6a>
80102261:	eb 6d                	jmp    801022d0 <iderw+0xd0>
80102263:	90                   	nop
80102264:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102268:	89 c2                	mov    %eax,%edx
8010226a:	8b 42 58             	mov    0x58(%edx),%eax
8010226d:	85 c0                	test   %eax,%eax
8010226f:	75 f7                	jne    80102268 <iderw+0x68>
80102271:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102274:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102276:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
8010227c:	74 42                	je     801022c0 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010227e:	8b 03                	mov    (%ebx),%eax
80102280:	83 e0 06             	and    $0x6,%eax
80102283:	83 f8 02             	cmp    $0x2,%eax
80102286:	74 23                	je     801022ab <iderw+0xab>
80102288:	90                   	nop
80102289:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
80102290:	83 ec 08             	sub    $0x8,%esp
80102293:	68 80 a5 10 80       	push   $0x8010a580
80102298:	53                   	push   %ebx
80102299:	e8 e2 1b 00 00       	call   80103e80 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010229e:	8b 03                	mov    (%ebx),%eax
801022a0:	83 c4 10             	add    $0x10,%esp
801022a3:	83 e0 06             	and    $0x6,%eax
801022a6:	83 f8 02             	cmp    $0x2,%eax
801022a9:	75 e5                	jne    80102290 <iderw+0x90>
  }


  release(&idelock);
801022ab:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
801022b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801022b5:	c9                   	leave  
  release(&idelock);
801022b6:	e9 15 23 00 00       	jmp    801045d0 <release>
801022bb:	90                   	nop
801022bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
801022c0:	89 d8                	mov    %ebx,%eax
801022c2:	e8 39 fd ff ff       	call   80102000 <idestart>
801022c7:	eb b5                	jmp    8010227e <iderw+0x7e>
801022c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801022d0:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
801022d5:	eb 9d                	jmp    80102274 <iderw+0x74>
    panic("iderw: ide disk 1 not present");
801022d7:	83 ec 0c             	sub    $0xc,%esp
801022da:	68 35 72 10 80       	push   $0x80107235
801022df:	e8 ac e0 ff ff       	call   80100390 <panic>
    panic("iderw: nothing to do");
801022e4:	83 ec 0c             	sub    $0xc,%esp
801022e7:	68 20 72 10 80       	push   $0x80107220
801022ec:	e8 9f e0 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
801022f1:	83 ec 0c             	sub    $0xc,%esp
801022f4:	68 0a 72 10 80       	push   $0x8010720a
801022f9:	e8 92 e0 ff ff       	call   80100390 <panic>
801022fe:	66 90                	xchg   %ax,%ax

80102300 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102300:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102301:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
80102308:	00 c0 fe 
{
8010230b:	89 e5                	mov    %esp,%ebp
8010230d:	56                   	push   %esi
8010230e:	53                   	push   %ebx
  ioapic->reg = reg;
8010230f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102316:	00 00 00 
  return ioapic->data;
80102319:	8b 15 34 26 11 80    	mov    0x80112634,%edx
8010231f:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102322:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102328:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010232e:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102335:	c1 ee 10             	shr    $0x10,%esi
80102338:	89 f0                	mov    %esi,%eax
8010233a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010233d:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102340:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102343:	39 c2                	cmp    %eax,%edx
80102345:	74 16                	je     8010235d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102347:	83 ec 0c             	sub    $0xc,%esp
8010234a:	68 54 72 10 80       	push   $0x80107254
8010234f:	e8 5c e3 ff ff       	call   801006b0 <cprintf>
80102354:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
8010235a:	83 c4 10             	add    $0x10,%esp
8010235d:	83 c6 21             	add    $0x21,%esi
{
80102360:	ba 10 00 00 00       	mov    $0x10,%edx
80102365:	b8 20 00 00 00       	mov    $0x20,%eax
8010236a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ioapic->reg = reg;
80102370:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102372:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102374:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
8010237a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010237d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102383:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102386:	8d 5a 01             	lea    0x1(%edx),%ebx
80102389:	83 c2 02             	add    $0x2,%edx
8010238c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010238e:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80102394:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010239b:	39 f0                	cmp    %esi,%eax
8010239d:	75 d1                	jne    80102370 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010239f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801023a2:	5b                   	pop    %ebx
801023a3:	5e                   	pop    %esi
801023a4:	5d                   	pop    %ebp
801023a5:	c3                   	ret    
801023a6:	8d 76 00             	lea    0x0(%esi),%esi
801023a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801023b0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801023b0:	55                   	push   %ebp
  ioapic->reg = reg;
801023b1:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
{
801023b7:	89 e5                	mov    %esp,%ebp
801023b9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801023bc:	8d 50 20             	lea    0x20(%eax),%edx
801023bf:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801023c3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801023c5:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801023cb:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801023ce:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801023d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801023d4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801023d6:	a1 34 26 11 80       	mov    0x80112634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801023db:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801023de:	89 50 10             	mov    %edx,0x10(%eax)
}
801023e1:	5d                   	pop    %ebp
801023e2:	c3                   	ret    
801023e3:	66 90                	xchg   %ax,%ax
801023e5:	66 90                	xchg   %ax,%ax
801023e7:	66 90                	xchg   %ax,%ax
801023e9:	66 90                	xchg   %ax,%ax
801023eb:	66 90                	xchg   %ax,%ax
801023ed:	66 90                	xchg   %ax,%ax
801023ef:	90                   	nop

801023f0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801023f0:	55                   	push   %ebp
801023f1:	89 e5                	mov    %esp,%ebp
801023f3:	53                   	push   %ebx
801023f4:	83 ec 04             	sub    $0x4,%esp
801023f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801023fa:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102400:	75 76                	jne    80102478 <kfree+0x88>
80102402:	81 fb a8 54 11 80    	cmp    $0x801154a8,%ebx
80102408:	72 6e                	jb     80102478 <kfree+0x88>
8010240a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102410:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102415:	77 61                	ja     80102478 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102417:	83 ec 04             	sub    $0x4,%esp
8010241a:	68 00 10 00 00       	push   $0x1000
8010241f:	6a 01                	push   $0x1
80102421:	53                   	push   %ebx
80102422:	e8 f9 21 00 00       	call   80104620 <memset>

  if(kmem.use_lock)
80102427:	8b 15 74 26 11 80    	mov    0x80112674,%edx
8010242d:	83 c4 10             	add    $0x10,%esp
80102430:	85 d2                	test   %edx,%edx
80102432:	75 1c                	jne    80102450 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102434:	a1 78 26 11 80       	mov    0x80112678,%eax
80102439:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010243b:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freelist = r;
80102440:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
80102446:	85 c0                	test   %eax,%eax
80102448:	75 1e                	jne    80102468 <kfree+0x78>
    release(&kmem.lock);
}
8010244a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010244d:	c9                   	leave  
8010244e:	c3                   	ret    
8010244f:	90                   	nop
    acquire(&kmem.lock);
80102450:	83 ec 0c             	sub    $0xc,%esp
80102453:	68 40 26 11 80       	push   $0x80112640
80102458:	e8 53 20 00 00       	call   801044b0 <acquire>
8010245d:	83 c4 10             	add    $0x10,%esp
80102460:	eb d2                	jmp    80102434 <kfree+0x44>
80102462:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102468:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
8010246f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102472:	c9                   	leave  
    release(&kmem.lock);
80102473:	e9 58 21 00 00       	jmp    801045d0 <release>
    panic("kfree");
80102478:	83 ec 0c             	sub    $0xc,%esp
8010247b:	68 86 72 10 80       	push   $0x80107286
80102480:	e8 0b df ff ff       	call   80100390 <panic>
80102485:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102489:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102490 <freerange>:
{
80102490:	55                   	push   %ebp
80102491:	89 e5                	mov    %esp,%ebp
80102493:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102494:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102497:	8b 75 0c             	mov    0xc(%ebp),%esi
8010249a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010249b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801024a1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024a7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801024ad:	39 de                	cmp    %ebx,%esi
801024af:	72 23                	jb     801024d4 <freerange+0x44>
801024b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801024b8:	83 ec 0c             	sub    $0xc,%esp
801024bb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024c1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801024c7:	50                   	push   %eax
801024c8:	e8 23 ff ff ff       	call   801023f0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024cd:	83 c4 10             	add    $0x10,%esp
801024d0:	39 f3                	cmp    %esi,%ebx
801024d2:	76 e4                	jbe    801024b8 <freerange+0x28>
}
801024d4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801024d7:	5b                   	pop    %ebx
801024d8:	5e                   	pop    %esi
801024d9:	5d                   	pop    %ebp
801024da:	c3                   	ret    
801024db:	90                   	nop
801024dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801024e0 <kinit1>:
{
801024e0:	55                   	push   %ebp
801024e1:	89 e5                	mov    %esp,%ebp
801024e3:	56                   	push   %esi
801024e4:	53                   	push   %ebx
801024e5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801024e8:	83 ec 08             	sub    $0x8,%esp
801024eb:	68 8c 72 10 80       	push   $0x8010728c
801024f0:	68 40 26 11 80       	push   $0x80112640
801024f5:	e8 b6 1e 00 00       	call   801043b0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
801024fa:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024fd:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102500:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
80102507:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010250a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102510:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102516:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010251c:	39 de                	cmp    %ebx,%esi
8010251e:	72 1c                	jb     8010253c <kinit1+0x5c>
    kfree(p);
80102520:	83 ec 0c             	sub    $0xc,%esp
80102523:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102529:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010252f:	50                   	push   %eax
80102530:	e8 bb fe ff ff       	call   801023f0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102535:	83 c4 10             	add    $0x10,%esp
80102538:	39 de                	cmp    %ebx,%esi
8010253a:	73 e4                	jae    80102520 <kinit1+0x40>
}
8010253c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010253f:	5b                   	pop    %ebx
80102540:	5e                   	pop    %esi
80102541:	5d                   	pop    %ebp
80102542:	c3                   	ret    
80102543:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102549:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102550 <kinit2>:
{
80102550:	55                   	push   %ebp
80102551:	89 e5                	mov    %esp,%ebp
80102553:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102554:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102557:	8b 75 0c             	mov    0xc(%ebp),%esi
8010255a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010255b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102561:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102567:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010256d:	39 de                	cmp    %ebx,%esi
8010256f:	72 23                	jb     80102594 <kinit2+0x44>
80102571:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102578:	83 ec 0c             	sub    $0xc,%esp
8010257b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102581:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102587:	50                   	push   %eax
80102588:	e8 63 fe ff ff       	call   801023f0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010258d:	83 c4 10             	add    $0x10,%esp
80102590:	39 de                	cmp    %ebx,%esi
80102592:	73 e4                	jae    80102578 <kinit2+0x28>
  kmem.use_lock = 1;
80102594:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
8010259b:	00 00 00 
}
8010259e:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025a1:	5b                   	pop    %ebx
801025a2:	5e                   	pop    %esi
801025a3:	5d                   	pop    %ebp
801025a4:	c3                   	ret    
801025a5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801025b0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
801025b0:	55                   	push   %ebp
801025b1:	89 e5                	mov    %esp,%ebp
801025b3:	53                   	push   %ebx
801025b4:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
801025b7:	a1 74 26 11 80       	mov    0x80112674,%eax
801025bc:	85 c0                	test   %eax,%eax
801025be:	75 20                	jne    801025e0 <kalloc+0x30>
    acquire(&kmem.lock);
  r = kmem.freelist;
801025c0:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(r)
801025c6:	85 db                	test   %ebx,%ebx
801025c8:	74 07                	je     801025d1 <kalloc+0x21>
    kmem.freelist = r->next;
801025ca:	8b 03                	mov    (%ebx),%eax
801025cc:	a3 78 26 11 80       	mov    %eax,0x80112678
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
801025d1:	89 d8                	mov    %ebx,%eax
801025d3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801025d6:	c9                   	leave  
801025d7:	c3                   	ret    
801025d8:	90                   	nop
801025d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&kmem.lock);
801025e0:	83 ec 0c             	sub    $0xc,%esp
801025e3:	68 40 26 11 80       	push   $0x80112640
801025e8:	e8 c3 1e 00 00       	call   801044b0 <acquire>
  r = kmem.freelist;
801025ed:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(r)
801025f3:	83 c4 10             	add    $0x10,%esp
801025f6:	a1 74 26 11 80       	mov    0x80112674,%eax
801025fb:	85 db                	test   %ebx,%ebx
801025fd:	74 08                	je     80102607 <kalloc+0x57>
    kmem.freelist = r->next;
801025ff:	8b 13                	mov    (%ebx),%edx
80102601:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
80102607:	85 c0                	test   %eax,%eax
80102609:	74 c6                	je     801025d1 <kalloc+0x21>
    release(&kmem.lock);
8010260b:	83 ec 0c             	sub    $0xc,%esp
8010260e:	68 40 26 11 80       	push   $0x80112640
80102613:	e8 b8 1f 00 00       	call   801045d0 <release>
}
80102618:	89 d8                	mov    %ebx,%eax
    release(&kmem.lock);
8010261a:	83 c4 10             	add    $0x10,%esp
}
8010261d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102620:	c9                   	leave  
80102621:	c3                   	ret    
80102622:	66 90                	xchg   %ax,%ax
80102624:	66 90                	xchg   %ax,%ax
80102626:	66 90                	xchg   %ax,%ax
80102628:	66 90                	xchg   %ax,%ax
8010262a:	66 90                	xchg   %ax,%ax
8010262c:	66 90                	xchg   %ax,%ax
8010262e:	66 90                	xchg   %ax,%ax

80102630 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102630:	ba 64 00 00 00       	mov    $0x64,%edx
80102635:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102636:	a8 01                	test   $0x1,%al
80102638:	0f 84 c2 00 00 00    	je     80102700 <kbdgetc+0xd0>
{
8010263e:	55                   	push   %ebp
8010263f:	ba 60 00 00 00       	mov    $0x60,%edx
80102644:	89 e5                	mov    %esp,%ebp
80102646:	53                   	push   %ebx
80102647:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102648:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
8010264b:	8b 1d b4 a5 10 80    	mov    0x8010a5b4,%ebx
80102651:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102657:	74 57                	je     801026b0 <kbdgetc+0x80>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102659:	89 d9                	mov    %ebx,%ecx
8010265b:	83 e1 40             	and    $0x40,%ecx
8010265e:	84 c0                	test   %al,%al
80102660:	78 5e                	js     801026c0 <kbdgetc+0x90>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102662:	85 c9                	test   %ecx,%ecx
80102664:	74 09                	je     8010266f <kbdgetc+0x3f>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102666:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102669:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
8010266c:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
8010266f:	0f b6 8a c0 73 10 80 	movzbl -0x7fef8c40(%edx),%ecx
  shift ^= togglecode[data];
80102676:	0f b6 82 c0 72 10 80 	movzbl -0x7fef8d40(%edx),%eax
  shift |= shiftcode[data];
8010267d:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
8010267f:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102681:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102683:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102689:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
8010268c:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
8010268f:	8b 04 85 a0 72 10 80 	mov    -0x7fef8d60(,%eax,4),%eax
80102696:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
8010269a:	74 0b                	je     801026a7 <kbdgetc+0x77>
    if('a' <= c && c <= 'z')
8010269c:	8d 50 9f             	lea    -0x61(%eax),%edx
8010269f:	83 fa 19             	cmp    $0x19,%edx
801026a2:	77 44                	ja     801026e8 <kbdgetc+0xb8>
      c += 'A' - 'a';
801026a4:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801026a7:	5b                   	pop    %ebx
801026a8:	5d                   	pop    %ebp
801026a9:	c3                   	ret    
801026aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    shift |= E0ESC;
801026b0:	83 cb 40             	or     $0x40,%ebx
    return 0;
801026b3:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
801026b5:	89 1d b4 a5 10 80    	mov    %ebx,0x8010a5b4
}
801026bb:	5b                   	pop    %ebx
801026bc:	5d                   	pop    %ebp
801026bd:	c3                   	ret    
801026be:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
801026c0:	83 e0 7f             	and    $0x7f,%eax
801026c3:	85 c9                	test   %ecx,%ecx
801026c5:	0f 44 d0             	cmove  %eax,%edx
    return 0;
801026c8:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
801026ca:	0f b6 8a c0 73 10 80 	movzbl -0x7fef8c40(%edx),%ecx
801026d1:	83 c9 40             	or     $0x40,%ecx
801026d4:	0f b6 c9             	movzbl %cl,%ecx
801026d7:	f7 d1                	not    %ecx
801026d9:	21 d9                	and    %ebx,%ecx
}
801026db:	5b                   	pop    %ebx
801026dc:	5d                   	pop    %ebp
    shift &= ~(shiftcode[data] | E0ESC);
801026dd:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
}
801026e3:	c3                   	ret    
801026e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
801026e8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801026eb:	8d 50 20             	lea    0x20(%eax),%edx
}
801026ee:	5b                   	pop    %ebx
801026ef:	5d                   	pop    %ebp
      c += 'a' - 'A';
801026f0:	83 f9 1a             	cmp    $0x1a,%ecx
801026f3:	0f 42 c2             	cmovb  %edx,%eax
}
801026f6:	c3                   	ret    
801026f7:	89 f6                	mov    %esi,%esi
801026f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102700:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102705:	c3                   	ret    
80102706:	8d 76 00             	lea    0x0(%esi),%esi
80102709:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102710 <kbdintr>:

void
kbdintr(void)
{
80102710:	55                   	push   %ebp
80102711:	89 e5                	mov    %esp,%ebp
80102713:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102716:	68 30 26 10 80       	push   $0x80102630
8010271b:	e8 40 e1 ff ff       	call   80100860 <consoleintr>
}
80102720:	83 c4 10             	add    $0x10,%esp
80102723:	c9                   	leave  
80102724:	c3                   	ret    
80102725:	66 90                	xchg   %ax,%ax
80102727:	66 90                	xchg   %ax,%ax
80102729:	66 90                	xchg   %ax,%ax
8010272b:	66 90                	xchg   %ax,%ax
8010272d:	66 90                	xchg   %ax,%ax
8010272f:	90                   	nop

80102730 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102730:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102735:	85 c0                	test   %eax,%eax
80102737:	0f 84 cb 00 00 00    	je     80102808 <lapicinit+0xd8>
  lapic[index] = value;
8010273d:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102744:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102747:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010274a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102751:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102754:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102757:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
8010275e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102761:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102764:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010276b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
8010276e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102771:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102778:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010277b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010277e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102785:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102788:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010278b:	8b 50 30             	mov    0x30(%eax),%edx
8010278e:	c1 ea 10             	shr    $0x10,%edx
80102791:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102797:	75 77                	jne    80102810 <lapicinit+0xe0>
  lapic[index] = value;
80102799:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801027a0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027a3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027a6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801027ad:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027b0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027b3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801027ba:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027bd:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027c0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801027c7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027ca:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027cd:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801027d4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027d7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027da:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801027e1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801027e4:	8b 50 20             	mov    0x20(%eax),%edx
801027e7:	89 f6                	mov    %esi,%esi
801027e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801027f0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801027f6:	80 e6 10             	and    $0x10,%dh
801027f9:	75 f5                	jne    801027f0 <lapicinit+0xc0>
  lapic[index] = value;
801027fb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102802:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102805:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102808:	c3                   	ret    
80102809:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102810:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102817:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010281a:	8b 50 20             	mov    0x20(%eax),%edx
8010281d:	e9 77 ff ff ff       	jmp    80102799 <lapicinit+0x69>
80102822:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102829:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102830 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102830:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102835:	85 c0                	test   %eax,%eax
80102837:	74 07                	je     80102840 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102839:	8b 40 20             	mov    0x20(%eax),%eax
8010283c:	c1 e8 18             	shr    $0x18,%eax
8010283f:	c3                   	ret    
    return 0;
80102840:	31 c0                	xor    %eax,%eax
}
80102842:	c3                   	ret    
80102843:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102849:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102850 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102850:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102855:	85 c0                	test   %eax,%eax
80102857:	74 0d                	je     80102866 <lapiceoi+0x16>
  lapic[index] = value;
80102859:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102860:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102863:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102866:	c3                   	ret    
80102867:	89 f6                	mov    %esi,%esi
80102869:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102870 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102870:	c3                   	ret    
80102871:	eb 0d                	jmp    80102880 <lapicstartap>
80102873:	90                   	nop
80102874:	90                   	nop
80102875:	90                   	nop
80102876:	90                   	nop
80102877:	90                   	nop
80102878:	90                   	nop
80102879:	90                   	nop
8010287a:	90                   	nop
8010287b:	90                   	nop
8010287c:	90                   	nop
8010287d:	90                   	nop
8010287e:	90                   	nop
8010287f:	90                   	nop

80102880 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102880:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102881:	b8 0f 00 00 00       	mov    $0xf,%eax
80102886:	ba 70 00 00 00       	mov    $0x70,%edx
8010288b:	89 e5                	mov    %esp,%ebp
8010288d:	53                   	push   %ebx
8010288e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102891:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102894:	ee                   	out    %al,(%dx)
80102895:	b8 0a 00 00 00       	mov    $0xa,%eax
8010289a:	ba 71 00 00 00       	mov    $0x71,%edx
8010289f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801028a0:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801028a2:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
801028a5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801028ab:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801028ad:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
801028b0:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
801028b2:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
801028b5:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
801028b8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
801028be:	a1 7c 26 11 80       	mov    0x8011267c,%eax
801028c3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801028c9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801028cc:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801028d3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028d6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801028d9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801028e0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028e3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801028e6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801028ec:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801028ef:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801028f5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801028f8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801028fe:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102901:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
    microdelay(200);
  }
}
80102907:	5b                   	pop    %ebx
  lapic[ID];  // wait for write to finish, by reading
80102908:	8b 40 20             	mov    0x20(%eax),%eax
}
8010290b:	5d                   	pop    %ebp
8010290c:	c3                   	ret    
8010290d:	8d 76 00             	lea    0x0(%esi),%esi

80102910 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80102910:	55                   	push   %ebp
80102911:	b8 0b 00 00 00       	mov    $0xb,%eax
80102916:	ba 70 00 00 00       	mov    $0x70,%edx
8010291b:	89 e5                	mov    %esp,%ebp
8010291d:	57                   	push   %edi
8010291e:	56                   	push   %esi
8010291f:	53                   	push   %ebx
80102920:	83 ec 4c             	sub    $0x4c,%esp
80102923:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102924:	ba 71 00 00 00       	mov    $0x71,%edx
80102929:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
8010292a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010292d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102932:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102935:	8d 76 00             	lea    0x0(%esi),%esi
80102938:	31 c0                	xor    %eax,%eax
8010293a:	89 da                	mov    %ebx,%edx
8010293c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010293d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102942:	89 ca                	mov    %ecx,%edx
80102944:	ec                   	in     (%dx),%al
80102945:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102948:	89 da                	mov    %ebx,%edx
8010294a:	b8 02 00 00 00       	mov    $0x2,%eax
8010294f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102950:	89 ca                	mov    %ecx,%edx
80102952:	ec                   	in     (%dx),%al
80102953:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102956:	89 da                	mov    %ebx,%edx
80102958:	b8 04 00 00 00       	mov    $0x4,%eax
8010295d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010295e:	89 ca                	mov    %ecx,%edx
80102960:	ec                   	in     (%dx),%al
80102961:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102964:	89 da                	mov    %ebx,%edx
80102966:	b8 07 00 00 00       	mov    $0x7,%eax
8010296b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010296c:	89 ca                	mov    %ecx,%edx
8010296e:	ec                   	in     (%dx),%al
8010296f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102972:	89 da                	mov    %ebx,%edx
80102974:	b8 08 00 00 00       	mov    $0x8,%eax
80102979:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010297a:	89 ca                	mov    %ecx,%edx
8010297c:	ec                   	in     (%dx),%al
8010297d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010297f:	89 da                	mov    %ebx,%edx
80102981:	b8 09 00 00 00       	mov    $0x9,%eax
80102986:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102987:	89 ca                	mov    %ecx,%edx
80102989:	ec                   	in     (%dx),%al
8010298a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010298c:	89 da                	mov    %ebx,%edx
8010298e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102993:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102994:	89 ca                	mov    %ecx,%edx
80102996:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102997:	84 c0                	test   %al,%al
80102999:	78 9d                	js     80102938 <cmostime+0x28>
  return inb(CMOS_RETURN);
8010299b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
8010299f:	89 fa                	mov    %edi,%edx
801029a1:	0f b6 fa             	movzbl %dl,%edi
801029a4:	89 f2                	mov    %esi,%edx
801029a6:	89 45 b8             	mov    %eax,-0x48(%ebp)
801029a9:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
801029ad:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029b0:	89 da                	mov    %ebx,%edx
801029b2:	89 7d c8             	mov    %edi,-0x38(%ebp)
801029b5:	89 45 bc             	mov    %eax,-0x44(%ebp)
801029b8:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
801029bc:	89 75 cc             	mov    %esi,-0x34(%ebp)
801029bf:	89 45 c0             	mov    %eax,-0x40(%ebp)
801029c2:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
801029c6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
801029c9:	31 c0                	xor    %eax,%eax
801029cb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029cc:	89 ca                	mov    %ecx,%edx
801029ce:	ec                   	in     (%dx),%al
801029cf:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029d2:	89 da                	mov    %ebx,%edx
801029d4:	89 45 d0             	mov    %eax,-0x30(%ebp)
801029d7:	b8 02 00 00 00       	mov    $0x2,%eax
801029dc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029dd:	89 ca                	mov    %ecx,%edx
801029df:	ec                   	in     (%dx),%al
801029e0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029e3:	89 da                	mov    %ebx,%edx
801029e5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
801029e8:	b8 04 00 00 00       	mov    $0x4,%eax
801029ed:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029ee:	89 ca                	mov    %ecx,%edx
801029f0:	ec                   	in     (%dx),%al
801029f1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029f4:	89 da                	mov    %ebx,%edx
801029f6:	89 45 d8             	mov    %eax,-0x28(%ebp)
801029f9:	b8 07 00 00 00       	mov    $0x7,%eax
801029fe:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029ff:	89 ca                	mov    %ecx,%edx
80102a01:	ec                   	in     (%dx),%al
80102a02:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a05:	89 da                	mov    %ebx,%edx
80102a07:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102a0a:	b8 08 00 00 00       	mov    $0x8,%eax
80102a0f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a10:	89 ca                	mov    %ecx,%edx
80102a12:	ec                   	in     (%dx),%al
80102a13:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a16:	89 da                	mov    %ebx,%edx
80102a18:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102a1b:	b8 09 00 00 00       	mov    $0x9,%eax
80102a20:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a21:	89 ca                	mov    %ecx,%edx
80102a23:	ec                   	in     (%dx),%al
80102a24:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102a27:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102a2a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102a2d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102a30:	6a 18                	push   $0x18
80102a32:	50                   	push   %eax
80102a33:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102a36:	50                   	push   %eax
80102a37:	e8 34 1c 00 00       	call   80104670 <memcmp>
80102a3c:	83 c4 10             	add    $0x10,%esp
80102a3f:	85 c0                	test   %eax,%eax
80102a41:	0f 85 f1 fe ff ff    	jne    80102938 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102a47:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102a4b:	75 78                	jne    80102ac5 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102a4d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102a50:	89 c2                	mov    %eax,%edx
80102a52:	83 e0 0f             	and    $0xf,%eax
80102a55:	c1 ea 04             	shr    $0x4,%edx
80102a58:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a5b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a5e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102a61:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102a64:	89 c2                	mov    %eax,%edx
80102a66:	83 e0 0f             	and    $0xf,%eax
80102a69:	c1 ea 04             	shr    $0x4,%edx
80102a6c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a6f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a72:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102a75:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102a78:	89 c2                	mov    %eax,%edx
80102a7a:	83 e0 0f             	and    $0xf,%eax
80102a7d:	c1 ea 04             	shr    $0x4,%edx
80102a80:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a83:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a86:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102a89:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102a8c:	89 c2                	mov    %eax,%edx
80102a8e:	83 e0 0f             	and    $0xf,%eax
80102a91:	c1 ea 04             	shr    $0x4,%edx
80102a94:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a97:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a9a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102a9d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102aa0:	89 c2                	mov    %eax,%edx
80102aa2:	83 e0 0f             	and    $0xf,%eax
80102aa5:	c1 ea 04             	shr    $0x4,%edx
80102aa8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102aab:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102aae:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102ab1:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102ab4:	89 c2                	mov    %eax,%edx
80102ab6:	83 e0 0f             	and    $0xf,%eax
80102ab9:	c1 ea 04             	shr    $0x4,%edx
80102abc:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102abf:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ac2:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102ac5:	8b 75 08             	mov    0x8(%ebp),%esi
80102ac8:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102acb:	89 06                	mov    %eax,(%esi)
80102acd:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102ad0:	89 46 04             	mov    %eax,0x4(%esi)
80102ad3:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102ad6:	89 46 08             	mov    %eax,0x8(%esi)
80102ad9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102adc:	89 46 0c             	mov    %eax,0xc(%esi)
80102adf:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102ae2:	89 46 10             	mov    %eax,0x10(%esi)
80102ae5:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102ae8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102aeb:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102af2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102af5:	5b                   	pop    %ebx
80102af6:	5e                   	pop    %esi
80102af7:	5f                   	pop    %edi
80102af8:	5d                   	pop    %ebp
80102af9:	c3                   	ret    
80102afa:	66 90                	xchg   %ax,%ax
80102afc:	66 90                	xchg   %ax,%ax
80102afe:	66 90                	xchg   %ax,%ax

80102b00 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102b00:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102b06:	85 c9                	test   %ecx,%ecx
80102b08:	0f 8e 8a 00 00 00    	jle    80102b98 <install_trans+0x98>
{
80102b0e:	55                   	push   %ebp
80102b0f:	89 e5                	mov    %esp,%ebp
80102b11:	57                   	push   %edi
80102b12:	56                   	push   %esi
80102b13:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102b14:	31 db                	xor    %ebx,%ebx
{
80102b16:	83 ec 0c             	sub    $0xc,%esp
80102b19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102b20:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102b25:	83 ec 08             	sub    $0x8,%esp
80102b28:	01 d8                	add    %ebx,%eax
80102b2a:	83 c0 01             	add    $0x1,%eax
80102b2d:	50                   	push   %eax
80102b2e:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102b34:	e8 97 d5 ff ff       	call   801000d0 <bread>
80102b39:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102b3b:	58                   	pop    %eax
80102b3c:	5a                   	pop    %edx
80102b3d:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
80102b44:	ff 35 c4 26 11 80    	pushl  0x801126c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102b4a:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102b4d:	e8 7e d5 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102b52:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102b55:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102b57:	8d 47 5c             	lea    0x5c(%edi),%eax
80102b5a:	68 00 02 00 00       	push   $0x200
80102b5f:	50                   	push   %eax
80102b60:	8d 46 5c             	lea    0x5c(%esi),%eax
80102b63:	50                   	push   %eax
80102b64:	e8 57 1b 00 00       	call   801046c0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102b69:	89 34 24             	mov    %esi,(%esp)
80102b6c:	e8 3f d6 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102b71:	89 3c 24             	mov    %edi,(%esp)
80102b74:	e8 77 d6 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102b79:	89 34 24             	mov    %esi,(%esp)
80102b7c:	e8 6f d6 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102b81:	83 c4 10             	add    $0x10,%esp
80102b84:	39 1d c8 26 11 80    	cmp    %ebx,0x801126c8
80102b8a:	7f 94                	jg     80102b20 <install_trans+0x20>
  }
}
80102b8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102b8f:	5b                   	pop    %ebx
80102b90:	5e                   	pop    %esi
80102b91:	5f                   	pop    %edi
80102b92:	5d                   	pop    %ebp
80102b93:	c3                   	ret    
80102b94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102b98:	c3                   	ret    
80102b99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102ba0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102ba0:	55                   	push   %ebp
80102ba1:	89 e5                	mov    %esp,%ebp
80102ba3:	53                   	push   %ebx
80102ba4:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102ba7:	ff 35 b4 26 11 80    	pushl  0x801126b4
80102bad:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102bb3:	e8 18 d5 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102bb8:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102bbb:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102bbd:	a1 c8 26 11 80       	mov    0x801126c8,%eax
80102bc2:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102bc5:	85 c0                	test   %eax,%eax
80102bc7:	7e 19                	jle    80102be2 <write_head+0x42>
80102bc9:	31 d2                	xor    %edx,%edx
80102bcb:	90                   	nop
80102bcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102bd0:	8b 0c 95 cc 26 11 80 	mov    -0x7feed934(,%edx,4),%ecx
80102bd7:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102bdb:	83 c2 01             	add    $0x1,%edx
80102bde:	39 d0                	cmp    %edx,%eax
80102be0:	75 ee                	jne    80102bd0 <write_head+0x30>
  }
  bwrite(buf);
80102be2:	83 ec 0c             	sub    $0xc,%esp
80102be5:	53                   	push   %ebx
80102be6:	e8 c5 d5 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102beb:	89 1c 24             	mov    %ebx,(%esp)
80102bee:	e8 fd d5 ff ff       	call   801001f0 <brelse>
}
80102bf3:	83 c4 10             	add    $0x10,%esp
80102bf6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102bf9:	c9                   	leave  
80102bfa:	c3                   	ret    
80102bfb:	90                   	nop
80102bfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102c00 <initlog>:
{
80102c00:	55                   	push   %ebp
80102c01:	89 e5                	mov    %esp,%ebp
80102c03:	53                   	push   %ebx
80102c04:	83 ec 2c             	sub    $0x2c,%esp
80102c07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102c0a:	68 c0 74 10 80       	push   $0x801074c0
80102c0f:	68 80 26 11 80       	push   $0x80112680
80102c14:	e8 97 17 00 00       	call   801043b0 <initlock>
  readsb(dev, &sb);
80102c19:	58                   	pop    %eax
80102c1a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102c1d:	5a                   	pop    %edx
80102c1e:	50                   	push   %eax
80102c1f:	53                   	push   %ebx
80102c20:	e8 3b e8 ff ff       	call   80101460 <readsb>
  log.start = sb.logstart;
80102c25:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102c28:	59                   	pop    %ecx
  log.dev = dev;
80102c29:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4
  log.size = sb.nlog;
80102c2f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102c32:	a3 b4 26 11 80       	mov    %eax,0x801126b4
  log.size = sb.nlog;
80102c37:	89 15 b8 26 11 80    	mov    %edx,0x801126b8
  struct buf *buf = bread(log.dev, log.start);
80102c3d:	5a                   	pop    %edx
80102c3e:	50                   	push   %eax
80102c3f:	53                   	push   %ebx
80102c40:	e8 8b d4 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102c45:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102c48:	8b 48 5c             	mov    0x5c(%eax),%ecx
80102c4b:	89 0d c8 26 11 80    	mov    %ecx,0x801126c8
  for (i = 0; i < log.lh.n; i++) {
80102c51:	85 c9                	test   %ecx,%ecx
80102c53:	7e 1d                	jle    80102c72 <initlog+0x72>
80102c55:	31 d2                	xor    %edx,%edx
80102c57:	89 f6                	mov    %esi,%esi
80102c59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    log.lh.block[i] = lh->block[i];
80102c60:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
80102c64:	89 1c 95 cc 26 11 80 	mov    %ebx,-0x7feed934(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102c6b:	83 c2 01             	add    $0x1,%edx
80102c6e:	39 d1                	cmp    %edx,%ecx
80102c70:	75 ee                	jne    80102c60 <initlog+0x60>
  brelse(buf);
80102c72:	83 ec 0c             	sub    $0xc,%esp
80102c75:	50                   	push   %eax
80102c76:	e8 75 d5 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102c7b:	e8 80 fe ff ff       	call   80102b00 <install_trans>
  log.lh.n = 0;
80102c80:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102c87:	00 00 00 
  write_head(); // clear the log
80102c8a:	e8 11 ff ff ff       	call   80102ba0 <write_head>
}
80102c8f:	83 c4 10             	add    $0x10,%esp
80102c92:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c95:	c9                   	leave  
80102c96:	c3                   	ret    
80102c97:	89 f6                	mov    %esi,%esi
80102c99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ca0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102ca0:	55                   	push   %ebp
80102ca1:	89 e5                	mov    %esp,%ebp
80102ca3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102ca6:	68 80 26 11 80       	push   $0x80112680
80102cab:	e8 00 18 00 00       	call   801044b0 <acquire>
80102cb0:	83 c4 10             	add    $0x10,%esp
80102cb3:	eb 18                	jmp    80102ccd <begin_op+0x2d>
80102cb5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102cb8:	83 ec 08             	sub    $0x8,%esp
80102cbb:	68 80 26 11 80       	push   $0x80112680
80102cc0:	68 80 26 11 80       	push   $0x80112680
80102cc5:	e8 b6 11 00 00       	call   80103e80 <sleep>
80102cca:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102ccd:	a1 c0 26 11 80       	mov    0x801126c0,%eax
80102cd2:	85 c0                	test   %eax,%eax
80102cd4:	75 e2                	jne    80102cb8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102cd6:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102cdb:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102ce1:	83 c0 01             	add    $0x1,%eax
80102ce4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102ce7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102cea:	83 fa 1e             	cmp    $0x1e,%edx
80102ced:	7f c9                	jg     80102cb8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102cef:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102cf2:	a3 bc 26 11 80       	mov    %eax,0x801126bc
      release(&log.lock);
80102cf7:	68 80 26 11 80       	push   $0x80112680
80102cfc:	e8 cf 18 00 00       	call   801045d0 <release>
      break;
    }
  }
}
80102d01:	83 c4 10             	add    $0x10,%esp
80102d04:	c9                   	leave  
80102d05:	c3                   	ret    
80102d06:	8d 76 00             	lea    0x0(%esi),%esi
80102d09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102d10 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102d10:	55                   	push   %ebp
80102d11:	89 e5                	mov    %esp,%ebp
80102d13:	57                   	push   %edi
80102d14:	56                   	push   %esi
80102d15:	53                   	push   %ebx
80102d16:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102d19:	68 80 26 11 80       	push   $0x80112680
80102d1e:	e8 8d 17 00 00       	call   801044b0 <acquire>
  log.outstanding -= 1;
80102d23:	a1 bc 26 11 80       	mov    0x801126bc,%eax
  if(log.committing)
80102d28:	8b 35 c0 26 11 80    	mov    0x801126c0,%esi
80102d2e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102d31:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102d34:	89 1d bc 26 11 80    	mov    %ebx,0x801126bc
  if(log.committing)
80102d3a:	85 f6                	test   %esi,%esi
80102d3c:	0f 85 22 01 00 00    	jne    80102e64 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102d42:	85 db                	test   %ebx,%ebx
80102d44:	0f 85 f6 00 00 00    	jne    80102e40 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102d4a:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
80102d51:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102d54:	83 ec 0c             	sub    $0xc,%esp
80102d57:	68 80 26 11 80       	push   $0x80112680
80102d5c:	e8 6f 18 00 00       	call   801045d0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102d61:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102d67:	83 c4 10             	add    $0x10,%esp
80102d6a:	85 c9                	test   %ecx,%ecx
80102d6c:	7f 42                	jg     80102db0 <end_op+0xa0>
    acquire(&log.lock);
80102d6e:	83 ec 0c             	sub    $0xc,%esp
80102d71:	68 80 26 11 80       	push   $0x80112680
80102d76:	e8 35 17 00 00       	call   801044b0 <acquire>
    wakeup(&log);
80102d7b:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
    log.committing = 0;
80102d82:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
80102d89:	00 00 00 
    wakeup(&log);
80102d8c:	e8 9f 12 00 00       	call   80104030 <wakeup>
    release(&log.lock);
80102d91:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102d98:	e8 33 18 00 00       	call   801045d0 <release>
80102d9d:	83 c4 10             	add    $0x10,%esp
}
80102da0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102da3:	5b                   	pop    %ebx
80102da4:	5e                   	pop    %esi
80102da5:	5f                   	pop    %edi
80102da6:	5d                   	pop    %ebp
80102da7:	c3                   	ret    
80102da8:	90                   	nop
80102da9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102db0:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102db5:	83 ec 08             	sub    $0x8,%esp
80102db8:	01 d8                	add    %ebx,%eax
80102dba:	83 c0 01             	add    $0x1,%eax
80102dbd:	50                   	push   %eax
80102dbe:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102dc4:	e8 07 d3 ff ff       	call   801000d0 <bread>
80102dc9:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102dcb:	58                   	pop    %eax
80102dcc:	5a                   	pop    %edx
80102dcd:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
80102dd4:	ff 35 c4 26 11 80    	pushl  0x801126c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102dda:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ddd:	e8 ee d2 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102de2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102de5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102de7:	8d 40 5c             	lea    0x5c(%eax),%eax
80102dea:	68 00 02 00 00       	push   $0x200
80102def:	50                   	push   %eax
80102df0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102df3:	50                   	push   %eax
80102df4:	e8 c7 18 00 00       	call   801046c0 <memmove>
    bwrite(to);  // write the log
80102df9:	89 34 24             	mov    %esi,(%esp)
80102dfc:	e8 af d3 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102e01:	89 3c 24             	mov    %edi,(%esp)
80102e04:	e8 e7 d3 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102e09:	89 34 24             	mov    %esi,(%esp)
80102e0c:	e8 df d3 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102e11:	83 c4 10             	add    $0x10,%esp
80102e14:	3b 1d c8 26 11 80    	cmp    0x801126c8,%ebx
80102e1a:	7c 94                	jl     80102db0 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102e1c:	e8 7f fd ff ff       	call   80102ba0 <write_head>
    install_trans(); // Now install writes to home locations
80102e21:	e8 da fc ff ff       	call   80102b00 <install_trans>
    log.lh.n = 0;
80102e26:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102e2d:	00 00 00 
    write_head();    // Erase the transaction from the log
80102e30:	e8 6b fd ff ff       	call   80102ba0 <write_head>
80102e35:	e9 34 ff ff ff       	jmp    80102d6e <end_op+0x5e>
80102e3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102e40:	83 ec 0c             	sub    $0xc,%esp
80102e43:	68 80 26 11 80       	push   $0x80112680
80102e48:	e8 e3 11 00 00       	call   80104030 <wakeup>
  release(&log.lock);
80102e4d:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102e54:	e8 77 17 00 00       	call   801045d0 <release>
80102e59:	83 c4 10             	add    $0x10,%esp
}
80102e5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e5f:	5b                   	pop    %ebx
80102e60:	5e                   	pop    %esi
80102e61:	5f                   	pop    %edi
80102e62:	5d                   	pop    %ebp
80102e63:	c3                   	ret    
    panic("log.committing");
80102e64:	83 ec 0c             	sub    $0xc,%esp
80102e67:	68 c4 74 10 80       	push   $0x801074c4
80102e6c:	e8 1f d5 ff ff       	call   80100390 <panic>
80102e71:	eb 0d                	jmp    80102e80 <log_write>
80102e73:	90                   	nop
80102e74:	90                   	nop
80102e75:	90                   	nop
80102e76:	90                   	nop
80102e77:	90                   	nop
80102e78:	90                   	nop
80102e79:	90                   	nop
80102e7a:	90                   	nop
80102e7b:	90                   	nop
80102e7c:	90                   	nop
80102e7d:	90                   	nop
80102e7e:	90                   	nop
80102e7f:	90                   	nop

80102e80 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102e80:	55                   	push   %ebp
80102e81:	89 e5                	mov    %esp,%ebp
80102e83:	53                   	push   %ebx
80102e84:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102e87:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
{
80102e8d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102e90:	83 fa 1d             	cmp    $0x1d,%edx
80102e93:	0f 8f 94 00 00 00    	jg     80102f2d <log_write+0xad>
80102e99:	a1 b8 26 11 80       	mov    0x801126b8,%eax
80102e9e:	83 e8 01             	sub    $0x1,%eax
80102ea1:	39 c2                	cmp    %eax,%edx
80102ea3:	0f 8d 84 00 00 00    	jge    80102f2d <log_write+0xad>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102ea9:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102eae:	85 c0                	test   %eax,%eax
80102eb0:	0f 8e 84 00 00 00    	jle    80102f3a <log_write+0xba>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102eb6:	83 ec 0c             	sub    $0xc,%esp
80102eb9:	68 80 26 11 80       	push   $0x80112680
80102ebe:	e8 ed 15 00 00       	call   801044b0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102ec3:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102ec9:	83 c4 10             	add    $0x10,%esp
80102ecc:	85 d2                	test   %edx,%edx
80102ece:	7e 51                	jle    80102f21 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102ed0:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102ed3:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102ed5:	3b 0d cc 26 11 80    	cmp    0x801126cc,%ecx
80102edb:	75 0c                	jne    80102ee9 <log_write+0x69>
80102edd:	eb 39                	jmp    80102f18 <log_write+0x98>
80102edf:	90                   	nop
80102ee0:	39 0c 85 cc 26 11 80 	cmp    %ecx,-0x7feed934(,%eax,4)
80102ee7:	74 2f                	je     80102f18 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80102ee9:	83 c0 01             	add    $0x1,%eax
80102eec:	39 c2                	cmp    %eax,%edx
80102eee:	75 f0                	jne    80102ee0 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102ef0:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80102ef7:	83 c2 01             	add    $0x1,%edx
80102efa:	89 15 c8 26 11 80    	mov    %edx,0x801126c8
  b->flags |= B_DIRTY; // prevent eviction
80102f00:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80102f03:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80102f06:	c7 45 08 80 26 11 80 	movl   $0x80112680,0x8(%ebp)
}
80102f0d:	c9                   	leave  
  release(&log.lock);
80102f0e:	e9 bd 16 00 00       	jmp    801045d0 <release>
80102f13:	90                   	nop
80102f14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  log.lh.block[i] = b->blockno;
80102f18:	89 0c 85 cc 26 11 80 	mov    %ecx,-0x7feed934(,%eax,4)
  if (i == log.lh.n)
80102f1f:	eb df                	jmp    80102f00 <log_write+0x80>
  log.lh.block[i] = b->blockno;
80102f21:	8b 43 08             	mov    0x8(%ebx),%eax
80102f24:	a3 cc 26 11 80       	mov    %eax,0x801126cc
  if (i == log.lh.n)
80102f29:	75 d5                	jne    80102f00 <log_write+0x80>
80102f2b:	eb ca                	jmp    80102ef7 <log_write+0x77>
    panic("too big a transaction");
80102f2d:	83 ec 0c             	sub    $0xc,%esp
80102f30:	68 d3 74 10 80       	push   $0x801074d3
80102f35:	e8 56 d4 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80102f3a:	83 ec 0c             	sub    $0xc,%esp
80102f3d:	68 e9 74 10 80       	push   $0x801074e9
80102f42:	e8 49 d4 ff ff       	call   80100390 <panic>
80102f47:	66 90                	xchg   %ax,%ax
80102f49:	66 90                	xchg   %ax,%ax
80102f4b:	66 90                	xchg   %ax,%ax
80102f4d:	66 90                	xchg   %ax,%ax
80102f4f:	90                   	nop

80102f50 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102f50:	55                   	push   %ebp
80102f51:	89 e5                	mov    %esp,%ebp
80102f53:	53                   	push   %ebx
80102f54:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102f57:	e8 64 09 00 00       	call   801038c0 <cpuid>
80102f5c:	89 c3                	mov    %eax,%ebx
80102f5e:	e8 5d 09 00 00       	call   801038c0 <cpuid>
80102f63:	83 ec 04             	sub    $0x4,%esp
80102f66:	53                   	push   %ebx
80102f67:	50                   	push   %eax
80102f68:	68 04 75 10 80       	push   $0x80107504
80102f6d:	e8 3e d7 ff ff       	call   801006b0 <cprintf>
  idtinit();       // load idt register
80102f72:	e8 e9 28 00 00       	call   80105860 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102f77:	e8 c4 08 00 00       	call   80103840 <mycpu>
80102f7c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102f7e:	b8 01 00 00 00       	mov    $0x1,%eax
80102f83:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102f8a:	e8 11 0c 00 00       	call   80103ba0 <scheduler>
80102f8f:	90                   	nop

80102f90 <mpenter>:
{
80102f90:	55                   	push   %ebp
80102f91:	89 e5                	mov    %esp,%ebp
80102f93:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102f96:	e8 c5 39 00 00       	call   80106960 <switchkvm>
  seginit();
80102f9b:	e8 30 39 00 00       	call   801068d0 <seginit>
  lapicinit();
80102fa0:	e8 8b f7 ff ff       	call   80102730 <lapicinit>
  mpmain();
80102fa5:	e8 a6 ff ff ff       	call   80102f50 <mpmain>
80102faa:	66 90                	xchg   %ax,%ax
80102fac:	66 90                	xchg   %ax,%ax
80102fae:	66 90                	xchg   %ax,%ax

80102fb0 <main>:
{
80102fb0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102fb4:	83 e4 f0             	and    $0xfffffff0,%esp
80102fb7:	ff 71 fc             	pushl  -0x4(%ecx)
80102fba:	55                   	push   %ebp
80102fbb:	89 e5                	mov    %esp,%ebp
80102fbd:	53                   	push   %ebx
80102fbe:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102fbf:	83 ec 08             	sub    $0x8,%esp
80102fc2:	68 00 00 40 80       	push   $0x80400000
80102fc7:	68 a8 54 11 80       	push   $0x801154a8
80102fcc:	e8 0f f5 ff ff       	call   801024e0 <kinit1>
  kvmalloc();      // kernel page table
80102fd1:	e8 4a 3e 00 00       	call   80106e20 <kvmalloc>
  mpinit();        // detect other processors
80102fd6:	e8 85 01 00 00       	call   80103160 <mpinit>
  lapicinit();     // interrupt controller
80102fdb:	e8 50 f7 ff ff       	call   80102730 <lapicinit>
  seginit();       // segment descriptors
80102fe0:	e8 eb 38 00 00       	call   801068d0 <seginit>
  picinit();       // disable pic
80102fe5:	e8 46 03 00 00       	call   80103330 <picinit>
  ioapicinit();    // another interrupt controller
80102fea:	e8 11 f3 ff ff       	call   80102300 <ioapicinit>
  consoleinit();   // console hardware
80102fef:	e8 3c da ff ff       	call   80100a30 <consoleinit>
  uartinit();      // serial port
80102ff4:	e8 97 2b 00 00       	call   80105b90 <uartinit>
  pinit();         // process table
80102ff9:	e8 22 08 00 00       	call   80103820 <pinit>
  tvinit();        // trap vectors
80102ffe:	e8 dd 27 00 00       	call   801057e0 <tvinit>
  binit();         // buffer cache
80103003:	e8 38 d0 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103008:	e8 d3 dd ff ff       	call   80100de0 <fileinit>
  ideinit();       // disk 
8010300d:	e8 ce f0 ff ff       	call   801020e0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103012:	83 c4 0c             	add    $0xc,%esp
80103015:	68 8a 00 00 00       	push   $0x8a
8010301a:	68 8c a4 10 80       	push   $0x8010a48c
8010301f:	68 00 70 00 80       	push   $0x80007000
80103024:	e8 97 16 00 00       	call   801046c0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103029:	83 c4 10             	add    $0x10,%esp
8010302c:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80103033:	00 00 00 
80103036:	05 80 27 11 80       	add    $0x80112780,%eax
8010303b:	3d 80 27 11 80       	cmp    $0x80112780,%eax
80103040:	76 7e                	jbe    801030c0 <main+0x110>
80103042:	bb 80 27 11 80       	mov    $0x80112780,%ebx
80103047:	eb 20                	jmp    80103069 <main+0xb9>
80103049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103050:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80103057:	00 00 00 
8010305a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103060:	05 80 27 11 80       	add    $0x80112780,%eax
80103065:	39 c3                	cmp    %eax,%ebx
80103067:	73 57                	jae    801030c0 <main+0x110>
    if(c == mycpu())  // We've started already.
80103069:	e8 d2 07 00 00       	call   80103840 <mycpu>
8010306e:	39 d8                	cmp    %ebx,%eax
80103070:	74 de                	je     80103050 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103072:	e8 39 f5 ff ff       	call   801025b0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void**)(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103077:	83 ec 08             	sub    $0x8,%esp
    *(void**)(code-8) = mpenter;
8010307a:	c7 05 f8 6f 00 80 90 	movl   $0x80102f90,0x80006ff8
80103081:	2f 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103084:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
8010308b:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010308e:	05 00 10 00 00       	add    $0x1000,%eax
80103093:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103098:	0f b6 03             	movzbl (%ebx),%eax
8010309b:	68 00 70 00 00       	push   $0x7000
801030a0:	50                   	push   %eax
801030a1:	e8 da f7 ff ff       	call   80102880 <lapicstartap>
801030a6:	83 c4 10             	add    $0x10,%esp
801030a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801030b0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801030b6:	85 c0                	test   %eax,%eax
801030b8:	74 f6                	je     801030b0 <main+0x100>
801030ba:	eb 94                	jmp    80103050 <main+0xa0>
801030bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801030c0:	83 ec 08             	sub    $0x8,%esp
801030c3:	68 00 00 00 8e       	push   $0x8e000000
801030c8:	68 00 00 40 80       	push   $0x80400000
801030cd:	e8 7e f4 ff ff       	call   80102550 <kinit2>
  userinit();      // first user process
801030d2:	e8 39 08 00 00       	call   80103910 <userinit>
  mpmain();        // finish this processor's setup
801030d7:	e8 74 fe ff ff       	call   80102f50 <mpmain>
801030dc:	66 90                	xchg   %ax,%ax
801030de:	66 90                	xchg   %ax,%ax

801030e0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801030e0:	55                   	push   %ebp
801030e1:	89 e5                	mov    %esp,%ebp
801030e3:	57                   	push   %edi
801030e4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801030e5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801030eb:	53                   	push   %ebx
  e = addr+len;
801030ec:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801030ef:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801030f2:	39 de                	cmp    %ebx,%esi
801030f4:	72 10                	jb     80103106 <mpsearch1+0x26>
801030f6:	eb 50                	jmp    80103148 <mpsearch1+0x68>
801030f8:	90                   	nop
801030f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103100:	89 fe                	mov    %edi,%esi
80103102:	39 fb                	cmp    %edi,%ebx
80103104:	76 42                	jbe    80103148 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103106:	83 ec 04             	sub    $0x4,%esp
80103109:	8d 7e 10             	lea    0x10(%esi),%edi
8010310c:	6a 04                	push   $0x4
8010310e:	68 18 75 10 80       	push   $0x80107518
80103113:	56                   	push   %esi
80103114:	e8 57 15 00 00       	call   80104670 <memcmp>
80103119:	83 c4 10             	add    $0x10,%esp
8010311c:	85 c0                	test   %eax,%eax
8010311e:	75 e0                	jne    80103100 <mpsearch1+0x20>
80103120:	89 f1                	mov    %esi,%ecx
80103122:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103128:	0f b6 11             	movzbl (%ecx),%edx
8010312b:	83 c1 01             	add    $0x1,%ecx
8010312e:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
80103130:	39 f9                	cmp    %edi,%ecx
80103132:	75 f4                	jne    80103128 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103134:	84 c0                	test   %al,%al
80103136:	75 c8                	jne    80103100 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103138:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010313b:	89 f0                	mov    %esi,%eax
8010313d:	5b                   	pop    %ebx
8010313e:	5e                   	pop    %esi
8010313f:	5f                   	pop    %edi
80103140:	5d                   	pop    %ebp
80103141:	c3                   	ret    
80103142:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103148:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010314b:	31 f6                	xor    %esi,%esi
}
8010314d:	5b                   	pop    %ebx
8010314e:	89 f0                	mov    %esi,%eax
80103150:	5e                   	pop    %esi
80103151:	5f                   	pop    %edi
80103152:	5d                   	pop    %ebp
80103153:	c3                   	ret    
80103154:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010315a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103160 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103160:	55                   	push   %ebp
80103161:	89 e5                	mov    %esp,%ebp
80103163:	57                   	push   %edi
80103164:	56                   	push   %esi
80103165:	53                   	push   %ebx
80103166:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103169:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103170:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103177:	c1 e0 08             	shl    $0x8,%eax
8010317a:	09 d0                	or     %edx,%eax
8010317c:	c1 e0 04             	shl    $0x4,%eax
8010317f:	75 1b                	jne    8010319c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103181:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103188:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010318f:	c1 e0 08             	shl    $0x8,%eax
80103192:	09 d0                	or     %edx,%eax
80103194:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103197:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010319c:	ba 00 04 00 00       	mov    $0x400,%edx
801031a1:	e8 3a ff ff ff       	call   801030e0 <mpsearch1>
801031a6:	89 c7                	mov    %eax,%edi
801031a8:	85 c0                	test   %eax,%eax
801031aa:	0f 84 c0 00 00 00    	je     80103270 <mpinit+0x110>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801031b0:	8b 5f 04             	mov    0x4(%edi),%ebx
801031b3:	85 db                	test   %ebx,%ebx
801031b5:	0f 84 d5 00 00 00    	je     80103290 <mpinit+0x130>
  if(memcmp(conf, "PCMP", 4) != 0)
801031bb:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801031be:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
801031c4:	6a 04                	push   $0x4
801031c6:	68 35 75 10 80       	push   $0x80107535
801031cb:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801031cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
801031cf:	e8 9c 14 00 00       	call   80104670 <memcmp>
801031d4:	83 c4 10             	add    $0x10,%esp
801031d7:	85 c0                	test   %eax,%eax
801031d9:	0f 85 b1 00 00 00    	jne    80103290 <mpinit+0x130>
  if(conf->version != 1 && conf->version != 4)
801031df:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
801031e6:	3c 01                	cmp    $0x1,%al
801031e8:	0f 95 c2             	setne  %dl
801031eb:	3c 04                	cmp    $0x4,%al
801031ed:	0f 95 c0             	setne  %al
801031f0:	20 c2                	and    %al,%dl
801031f2:	0f 85 98 00 00 00    	jne    80103290 <mpinit+0x130>
  if(sum((uchar*)conf, conf->length) != 0)
801031f8:	0f b7 8b 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%ecx
  for(i=0; i<len; i++)
801031ff:	66 85 c9             	test   %cx,%cx
80103202:	74 21                	je     80103225 <mpinit+0xc5>
80103204:	89 d8                	mov    %ebx,%eax
80103206:	8d 34 19             	lea    (%ecx,%ebx,1),%esi
  sum = 0;
80103209:	31 d2                	xor    %edx,%edx
8010320b:	90                   	nop
8010320c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103210:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
80103217:	83 c0 01             	add    $0x1,%eax
8010321a:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
8010321c:	39 c6                	cmp    %eax,%esi
8010321e:	75 f0                	jne    80103210 <mpinit+0xb0>
80103220:	84 d2                	test   %dl,%dl
80103222:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103225:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103228:	85 c9                	test   %ecx,%ecx
8010322a:	74 64                	je     80103290 <mpinit+0x130>
8010322c:	84 d2                	test   %dl,%dl
8010322e:	75 60                	jne    80103290 <mpinit+0x130>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103230:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103236:	a3 7c 26 11 80       	mov    %eax,0x8011267c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010323b:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80103242:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
80103248:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010324d:	01 d1                	add    %edx,%ecx
8010324f:	89 ce                	mov    %ecx,%esi
80103251:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103258:	39 c6                	cmp    %eax,%esi
8010325a:	76 4b                	jbe    801032a7 <mpinit+0x147>
    switch(*p){
8010325c:	0f b6 10             	movzbl (%eax),%edx
8010325f:	80 fa 04             	cmp    $0x4,%dl
80103262:	0f 87 bf 00 00 00    	ja     80103327 <mpinit+0x1c7>
80103268:	ff 24 95 5c 75 10 80 	jmp    *-0x7fef8aa4(,%edx,4)
8010326f:	90                   	nop
  return mpsearch1(0xF0000, 0x10000);
80103270:	ba 00 00 01 00       	mov    $0x10000,%edx
80103275:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010327a:	e8 61 fe ff ff       	call   801030e0 <mpsearch1>
8010327f:	89 c7                	mov    %eax,%edi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103281:	85 c0                	test   %eax,%eax
80103283:	0f 85 27 ff ff ff    	jne    801031b0 <mpinit+0x50>
80103289:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103290:	83 ec 0c             	sub    $0xc,%esp
80103293:	68 1d 75 10 80       	push   $0x8010751d
80103298:	e8 f3 d0 ff ff       	call   80100390 <panic>
8010329d:	8d 76 00             	lea    0x0(%esi),%esi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801032a0:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032a3:	39 c6                	cmp    %eax,%esi
801032a5:	77 b5                	ja     8010325c <mpinit+0xfc>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801032a7:	85 db                	test   %ebx,%ebx
801032a9:	74 6f                	je     8010331a <mpinit+0x1ba>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801032ab:	80 7f 0c 00          	cmpb   $0x0,0xc(%edi)
801032af:	74 15                	je     801032c6 <mpinit+0x166>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032b1:	b8 70 00 00 00       	mov    $0x70,%eax
801032b6:	ba 22 00 00 00       	mov    $0x22,%edx
801032bb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801032bc:	ba 23 00 00 00       	mov    $0x23,%edx
801032c1:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801032c2:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032c5:	ee                   	out    %al,(%dx)
  }
}
801032c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801032c9:	5b                   	pop    %ebx
801032ca:	5e                   	pop    %esi
801032cb:	5f                   	pop    %edi
801032cc:	5d                   	pop    %ebp
801032cd:	c3                   	ret    
801032ce:	66 90                	xchg   %ax,%ax
      if(ncpu < NCPU) {
801032d0:	8b 15 00 2d 11 80    	mov    0x80112d00,%edx
801032d6:	83 fa 07             	cmp    $0x7,%edx
801032d9:	7f 1f                	jg     801032fa <mpinit+0x19a>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801032db:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
801032e1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801032e4:	0f b6 50 01          	movzbl 0x1(%eax),%edx
801032e8:	88 91 80 27 11 80    	mov    %dl,-0x7feed880(%ecx)
        ncpu++;
801032ee:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801032f1:	83 c2 01             	add    $0x1,%edx
801032f4:	89 15 00 2d 11 80    	mov    %edx,0x80112d00
      p += sizeof(struct mpproc);
801032fa:	83 c0 14             	add    $0x14,%eax
      continue;
801032fd:	e9 56 ff ff ff       	jmp    80103258 <mpinit+0xf8>
80103302:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ioapicid = ioapic->apicno;
80103308:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
8010330c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010330f:	88 15 60 27 11 80    	mov    %dl,0x80112760
      continue;
80103315:	e9 3e ff ff ff       	jmp    80103258 <mpinit+0xf8>
    panic("Didn't find a suitable machine");
8010331a:	83 ec 0c             	sub    $0xc,%esp
8010331d:	68 3c 75 10 80       	push   $0x8010753c
80103322:	e8 69 d0 ff ff       	call   80100390 <panic>
      ismp = 0;
80103327:	31 db                	xor    %ebx,%ebx
80103329:	e9 31 ff ff ff       	jmp    8010325f <mpinit+0xff>
8010332e:	66 90                	xchg   %ax,%ax

80103330 <picinit>:
80103330:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103335:	ba 21 00 00 00       	mov    $0x21,%edx
8010333a:	ee                   	out    %al,(%dx)
8010333b:	ba a1 00 00 00       	mov    $0xa1,%edx
80103340:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103341:	c3                   	ret    
80103342:	66 90                	xchg   %ax,%ax
80103344:	66 90                	xchg   %ax,%ax
80103346:	66 90                	xchg   %ax,%ax
80103348:	66 90                	xchg   %ax,%ax
8010334a:	66 90                	xchg   %ax,%ax
8010334c:	66 90                	xchg   %ax,%ax
8010334e:	66 90                	xchg   %ax,%ax

80103350 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103350:	55                   	push   %ebp
80103351:	89 e5                	mov    %esp,%ebp
80103353:	57                   	push   %edi
80103354:	56                   	push   %esi
80103355:	53                   	push   %ebx
80103356:	83 ec 0c             	sub    $0xc,%esp
80103359:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010335c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010335f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103365:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010336b:	e8 90 da ff ff       	call   80100e00 <filealloc>
80103370:	89 03                	mov    %eax,(%ebx)
80103372:	85 c0                	test   %eax,%eax
80103374:	0f 84 a8 00 00 00    	je     80103422 <pipealloc+0xd2>
8010337a:	e8 81 da ff ff       	call   80100e00 <filealloc>
8010337f:	89 06                	mov    %eax,(%esi)
80103381:	85 c0                	test   %eax,%eax
80103383:	0f 84 87 00 00 00    	je     80103410 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103389:	e8 22 f2 ff ff       	call   801025b0 <kalloc>
8010338e:	89 c7                	mov    %eax,%edi
80103390:	85 c0                	test   %eax,%eax
80103392:	0f 84 b0 00 00 00    	je     80103448 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
80103398:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010339f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
801033a2:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
801033a5:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801033ac:	00 00 00 
  p->nwrite = 0;
801033af:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801033b6:	00 00 00 
  p->nread = 0;
801033b9:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801033c0:	00 00 00 
  initlock(&p->lock, "pipe");
801033c3:	68 70 75 10 80       	push   $0x80107570
801033c8:	50                   	push   %eax
801033c9:	e8 e2 0f 00 00       	call   801043b0 <initlock>
  (*f0)->type = FD_PIPE;
801033ce:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801033d0:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801033d3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801033d9:	8b 03                	mov    (%ebx),%eax
801033db:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801033df:	8b 03                	mov    (%ebx),%eax
801033e1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801033e5:	8b 03                	mov    (%ebx),%eax
801033e7:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801033ea:	8b 06                	mov    (%esi),%eax
801033ec:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801033f2:	8b 06                	mov    (%esi),%eax
801033f4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801033f8:	8b 06                	mov    (%esi),%eax
801033fa:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801033fe:	8b 06                	mov    (%esi),%eax
80103400:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103403:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103406:	31 c0                	xor    %eax,%eax
}
80103408:	5b                   	pop    %ebx
80103409:	5e                   	pop    %esi
8010340a:	5f                   	pop    %edi
8010340b:	5d                   	pop    %ebp
8010340c:	c3                   	ret    
8010340d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
80103410:	8b 03                	mov    (%ebx),%eax
80103412:	85 c0                	test   %eax,%eax
80103414:	74 1e                	je     80103434 <pipealloc+0xe4>
    fileclose(*f0);
80103416:	83 ec 0c             	sub    $0xc,%esp
80103419:	50                   	push   %eax
8010341a:	e8 a1 da ff ff       	call   80100ec0 <fileclose>
8010341f:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103422:	8b 06                	mov    (%esi),%eax
80103424:	85 c0                	test   %eax,%eax
80103426:	74 0c                	je     80103434 <pipealloc+0xe4>
    fileclose(*f1);
80103428:	83 ec 0c             	sub    $0xc,%esp
8010342b:	50                   	push   %eax
8010342c:	e8 8f da ff ff       	call   80100ec0 <fileclose>
80103431:	83 c4 10             	add    $0x10,%esp
}
80103434:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103437:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010343c:	5b                   	pop    %ebx
8010343d:	5e                   	pop    %esi
8010343e:	5f                   	pop    %edi
8010343f:	5d                   	pop    %ebp
80103440:	c3                   	ret    
80103441:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103448:	8b 03                	mov    (%ebx),%eax
8010344a:	85 c0                	test   %eax,%eax
8010344c:	75 c8                	jne    80103416 <pipealloc+0xc6>
8010344e:	eb d2                	jmp    80103422 <pipealloc+0xd2>

80103450 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103450:	55                   	push   %ebp
80103451:	89 e5                	mov    %esp,%ebp
80103453:	56                   	push   %esi
80103454:	53                   	push   %ebx
80103455:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103458:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010345b:	83 ec 0c             	sub    $0xc,%esp
8010345e:	53                   	push   %ebx
8010345f:	e8 4c 10 00 00       	call   801044b0 <acquire>
  if(writable){
80103464:	83 c4 10             	add    $0x10,%esp
80103467:	85 f6                	test   %esi,%esi
80103469:	74 65                	je     801034d0 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010346b:	83 ec 0c             	sub    $0xc,%esp
8010346e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103474:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010347b:	00 00 00 
    wakeup(&p->nread);
8010347e:	50                   	push   %eax
8010347f:	e8 ac 0b 00 00       	call   80104030 <wakeup>
80103484:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103487:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010348d:	85 d2                	test   %edx,%edx
8010348f:	75 0a                	jne    8010349b <pipeclose+0x4b>
80103491:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103497:	85 c0                	test   %eax,%eax
80103499:	74 15                	je     801034b0 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010349b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010349e:	8d 65 f8             	lea    -0x8(%ebp),%esp
801034a1:	5b                   	pop    %ebx
801034a2:	5e                   	pop    %esi
801034a3:	5d                   	pop    %ebp
    release(&p->lock);
801034a4:	e9 27 11 00 00       	jmp    801045d0 <release>
801034a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
801034b0:	83 ec 0c             	sub    $0xc,%esp
801034b3:	53                   	push   %ebx
801034b4:	e8 17 11 00 00       	call   801045d0 <release>
    kfree((char*)p);
801034b9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801034bc:	83 c4 10             	add    $0x10,%esp
}
801034bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801034c2:	5b                   	pop    %ebx
801034c3:	5e                   	pop    %esi
801034c4:	5d                   	pop    %ebp
    kfree((char*)p);
801034c5:	e9 26 ef ff ff       	jmp    801023f0 <kfree>
801034ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
801034d0:	83 ec 0c             	sub    $0xc,%esp
801034d3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801034d9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801034e0:	00 00 00 
    wakeup(&p->nwrite);
801034e3:	50                   	push   %eax
801034e4:	e8 47 0b 00 00       	call   80104030 <wakeup>
801034e9:	83 c4 10             	add    $0x10,%esp
801034ec:	eb 99                	jmp    80103487 <pipeclose+0x37>
801034ee:	66 90                	xchg   %ax,%ax

801034f0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801034f0:	55                   	push   %ebp
801034f1:	89 e5                	mov    %esp,%ebp
801034f3:	57                   	push   %edi
801034f4:	56                   	push   %esi
801034f5:	53                   	push   %ebx
801034f6:	83 ec 28             	sub    $0x28,%esp
801034f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801034fc:	53                   	push   %ebx
801034fd:	e8 ae 0f 00 00       	call   801044b0 <acquire>
  for(i = 0; i < n; i++){
80103502:	8b 45 10             	mov    0x10(%ebp),%eax
80103505:	83 c4 10             	add    $0x10,%esp
80103508:	85 c0                	test   %eax,%eax
8010350a:	0f 8e c8 00 00 00    	jle    801035d8 <pipewrite+0xe8>
80103510:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103513:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103519:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010351f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103522:	03 4d 10             	add    0x10(%ebp),%ecx
80103525:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103528:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
8010352e:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
80103534:	39 d0                	cmp    %edx,%eax
80103536:	75 71                	jne    801035a9 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
80103538:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010353e:	85 c0                	test   %eax,%eax
80103540:	74 4e                	je     80103590 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103542:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103548:	eb 3a                	jmp    80103584 <pipewrite+0x94>
8010354a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
80103550:	83 ec 0c             	sub    $0xc,%esp
80103553:	57                   	push   %edi
80103554:	e8 d7 0a 00 00       	call   80104030 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103559:	5a                   	pop    %edx
8010355a:	59                   	pop    %ecx
8010355b:	53                   	push   %ebx
8010355c:	56                   	push   %esi
8010355d:	e8 1e 09 00 00       	call   80103e80 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103562:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103568:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010356e:	83 c4 10             	add    $0x10,%esp
80103571:	05 00 02 00 00       	add    $0x200,%eax
80103576:	39 c2                	cmp    %eax,%edx
80103578:	75 36                	jne    801035b0 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
8010357a:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103580:	85 c0                	test   %eax,%eax
80103582:	74 0c                	je     80103590 <pipewrite+0xa0>
80103584:	e8 57 03 00 00       	call   801038e0 <myproc>
80103589:	8b 40 24             	mov    0x24(%eax),%eax
8010358c:	85 c0                	test   %eax,%eax
8010358e:	74 c0                	je     80103550 <pipewrite+0x60>
        release(&p->lock);
80103590:	83 ec 0c             	sub    $0xc,%esp
80103593:	53                   	push   %ebx
80103594:	e8 37 10 00 00       	call   801045d0 <release>
        return -1;
80103599:	83 c4 10             	add    $0x10,%esp
8010359c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801035a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801035a4:	5b                   	pop    %ebx
801035a5:	5e                   	pop    %esi
801035a6:	5f                   	pop    %edi
801035a7:	5d                   	pop    %ebp
801035a8:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035a9:	89 c2                	mov    %eax,%edx
801035ab:	90                   	nop
801035ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801035b0:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801035b3:	8d 42 01             	lea    0x1(%edx),%eax
801035b6:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801035bc:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801035c2:	0f b6 0e             	movzbl (%esi),%ecx
801035c5:	83 c6 01             	add    $0x1,%esi
801035c8:	89 75 e4             	mov    %esi,-0x1c(%ebp)
801035cb:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801035cf:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801035d2:	0f 85 50 ff ff ff    	jne    80103528 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801035d8:	83 ec 0c             	sub    $0xc,%esp
801035db:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801035e1:	50                   	push   %eax
801035e2:	e8 49 0a 00 00       	call   80104030 <wakeup>
  release(&p->lock);
801035e7:	89 1c 24             	mov    %ebx,(%esp)
801035ea:	e8 e1 0f 00 00       	call   801045d0 <release>
  return n;
801035ef:	83 c4 10             	add    $0x10,%esp
801035f2:	8b 45 10             	mov    0x10(%ebp),%eax
801035f5:	eb aa                	jmp    801035a1 <pipewrite+0xb1>
801035f7:	89 f6                	mov    %esi,%esi
801035f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103600 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103600:	55                   	push   %ebp
80103601:	89 e5                	mov    %esp,%ebp
80103603:	57                   	push   %edi
80103604:	56                   	push   %esi
80103605:	53                   	push   %ebx
80103606:	83 ec 18             	sub    $0x18,%esp
80103609:	8b 75 08             	mov    0x8(%ebp),%esi
8010360c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010360f:	56                   	push   %esi
80103610:	e8 9b 0e 00 00       	call   801044b0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103615:	83 c4 10             	add    $0x10,%esp
80103618:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
8010361e:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103624:	75 6a                	jne    80103690 <piperead+0x90>
80103626:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010362c:	85 db                	test   %ebx,%ebx
8010362e:	0f 84 c4 00 00 00    	je     801036f8 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103634:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
8010363a:	eb 2d                	jmp    80103669 <piperead+0x69>
8010363c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103640:	83 ec 08             	sub    $0x8,%esp
80103643:	56                   	push   %esi
80103644:	53                   	push   %ebx
80103645:	e8 36 08 00 00       	call   80103e80 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010364a:	83 c4 10             	add    $0x10,%esp
8010364d:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103653:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103659:	75 35                	jne    80103690 <piperead+0x90>
8010365b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103661:	85 d2                	test   %edx,%edx
80103663:	0f 84 8f 00 00 00    	je     801036f8 <piperead+0xf8>
    if(myproc()->killed){
80103669:	e8 72 02 00 00       	call   801038e0 <myproc>
8010366e:	8b 48 24             	mov    0x24(%eax),%ecx
80103671:	85 c9                	test   %ecx,%ecx
80103673:	74 cb                	je     80103640 <piperead+0x40>
      release(&p->lock);
80103675:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103678:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
8010367d:	56                   	push   %esi
8010367e:	e8 4d 0f 00 00       	call   801045d0 <release>
      return -1;
80103683:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103686:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103689:	89 d8                	mov    %ebx,%eax
8010368b:	5b                   	pop    %ebx
8010368c:	5e                   	pop    %esi
8010368d:	5f                   	pop    %edi
8010368e:	5d                   	pop    %ebp
8010368f:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103690:	8b 45 10             	mov    0x10(%ebp),%eax
80103693:	85 c0                	test   %eax,%eax
80103695:	7e 61                	jle    801036f8 <piperead+0xf8>
    if(p->nread == p->nwrite)
80103697:	31 db                	xor    %ebx,%ebx
80103699:	eb 13                	jmp    801036ae <piperead+0xae>
8010369b:	90                   	nop
8010369c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801036a0:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801036a6:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801036ac:	74 1f                	je     801036cd <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
801036ae:	8d 41 01             	lea    0x1(%ecx),%eax
801036b1:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
801036b7:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
801036bd:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
801036c2:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801036c5:	83 c3 01             	add    $0x1,%ebx
801036c8:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801036cb:	75 d3                	jne    801036a0 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801036cd:	83 ec 0c             	sub    $0xc,%esp
801036d0:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801036d6:	50                   	push   %eax
801036d7:	e8 54 09 00 00       	call   80104030 <wakeup>
  release(&p->lock);
801036dc:	89 34 24             	mov    %esi,(%esp)
801036df:	e8 ec 0e 00 00       	call   801045d0 <release>
  return i;
801036e4:	83 c4 10             	add    $0x10,%esp
}
801036e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801036ea:	89 d8                	mov    %ebx,%eax
801036ec:	5b                   	pop    %ebx
801036ed:	5e                   	pop    %esi
801036ee:	5f                   	pop    %edi
801036ef:	5d                   	pop    %ebp
801036f0:	c3                   	ret    
801036f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p->nread == p->nwrite)
801036f8:	31 db                	xor    %ebx,%ebx
801036fa:	eb d1                	jmp    801036cd <piperead+0xcd>
801036fc:	66 90                	xchg   %ax,%ax
801036fe:	66 90                	xchg   %ax,%ax

80103700 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103700:	55                   	push   %ebp
80103701:	89 e5                	mov    %esp,%ebp
80103703:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103704:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
80103709:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010370c:	68 20 2d 11 80       	push   $0x80112d20
80103711:	e8 9a 0d 00 00       	call   801044b0 <acquire>
80103716:	83 c4 10             	add    $0x10,%esp
80103719:	eb 10                	jmp    8010372b <allocproc+0x2b>
8010371b:	90                   	nop
8010371c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103720:	83 c3 7c             	add    $0x7c,%ebx
80103723:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103729:	74 75                	je     801037a0 <allocproc+0xa0>
    if(p->state == UNUSED)
8010372b:	8b 43 0c             	mov    0xc(%ebx),%eax
8010372e:	85 c0                	test   %eax,%eax
80103730:	75 ee                	jne    80103720 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103732:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
80103737:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
8010373a:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103741:	89 43 10             	mov    %eax,0x10(%ebx)
80103744:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80103747:	68 20 2d 11 80       	push   $0x80112d20
  p->pid = nextpid++;
8010374c:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
80103752:	e8 79 0e 00 00       	call   801045d0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103757:	e8 54 ee ff ff       	call   801025b0 <kalloc>
8010375c:	83 c4 10             	add    $0x10,%esp
8010375f:	89 43 08             	mov    %eax,0x8(%ebx)
80103762:	85 c0                	test   %eax,%eax
80103764:	74 53                	je     801037b9 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103766:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010376c:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010376f:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103774:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103777:	c7 40 14 cd 57 10 80 	movl   $0x801057cd,0x14(%eax)
  p->context = (struct context*)sp;
8010377e:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103781:	6a 14                	push   $0x14
80103783:	6a 00                	push   $0x0
80103785:	50                   	push   %eax
80103786:	e8 95 0e 00 00       	call   80104620 <memset>
  p->context->eip = (uint)forkret;
8010378b:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
8010378e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103791:	c7 40 10 d0 37 10 80 	movl   $0x801037d0,0x10(%eax)
}
80103798:	89 d8                	mov    %ebx,%eax
8010379a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010379d:	c9                   	leave  
8010379e:	c3                   	ret    
8010379f:	90                   	nop
  release(&ptable.lock);
801037a0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
801037a3:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
801037a5:	68 20 2d 11 80       	push   $0x80112d20
801037aa:	e8 21 0e 00 00       	call   801045d0 <release>
}
801037af:	89 d8                	mov    %ebx,%eax
  return 0;
801037b1:	83 c4 10             	add    $0x10,%esp
}
801037b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801037b7:	c9                   	leave  
801037b8:	c3                   	ret    
    p->state = UNUSED;
801037b9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801037c0:	31 db                	xor    %ebx,%ebx
}
801037c2:	89 d8                	mov    %ebx,%eax
801037c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801037c7:	c9                   	leave  
801037c8:	c3                   	ret    
801037c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801037d0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801037d0:	55                   	push   %ebp
801037d1:	89 e5                	mov    %esp,%ebp
801037d3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801037d6:	68 20 2d 11 80       	push   $0x80112d20
801037db:	e8 f0 0d 00 00       	call   801045d0 <release>

  if (first) {
801037e0:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801037e5:	83 c4 10             	add    $0x10,%esp
801037e8:	85 c0                	test   %eax,%eax
801037ea:	75 04                	jne    801037f0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801037ec:	c9                   	leave  
801037ed:	c3                   	ret    
801037ee:	66 90                	xchg   %ax,%ax
    first = 0;
801037f0:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
801037f7:	00 00 00 
    iinit(ROOTDEV);
801037fa:	83 ec 0c             	sub    $0xc,%esp
801037fd:	6a 01                	push   $0x1
801037ff:	e8 1c dd ff ff       	call   80101520 <iinit>
    initlog(ROOTDEV);
80103804:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010380b:	e8 f0 f3 ff ff       	call   80102c00 <initlog>
80103810:	83 c4 10             	add    $0x10,%esp
}
80103813:	c9                   	leave  
80103814:	c3                   	ret    
80103815:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103819:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103820 <pinit>:
{
80103820:	55                   	push   %ebp
80103821:	89 e5                	mov    %esp,%ebp
80103823:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103826:	68 75 75 10 80       	push   $0x80107575
8010382b:	68 20 2d 11 80       	push   $0x80112d20
80103830:	e8 7b 0b 00 00       	call   801043b0 <initlock>
}
80103835:	83 c4 10             	add    $0x10,%esp
80103838:	c9                   	leave  
80103839:	c3                   	ret    
8010383a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103840 <mycpu>:
{
80103840:	55                   	push   %ebp
80103841:	89 e5                	mov    %esp,%ebp
80103843:	56                   	push   %esi
80103844:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103845:	9c                   	pushf  
80103846:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103847:	f6 c4 02             	test   $0x2,%ah
8010384a:	75 5d                	jne    801038a9 <mycpu+0x69>
  apicid = lapicid();
8010384c:	e8 df ef ff ff       	call   80102830 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103851:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
80103857:	85 f6                	test   %esi,%esi
80103859:	7e 41                	jle    8010389c <mycpu+0x5c>
    if (cpus[i].apicid == apicid)
8010385b:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
80103862:	39 d0                	cmp    %edx,%eax
80103864:	74 2f                	je     80103895 <mycpu+0x55>
  for (i = 0; i < ncpu; ++i) {
80103866:	31 d2                	xor    %edx,%edx
80103868:	90                   	nop
80103869:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103870:	83 c2 01             	add    $0x1,%edx
80103873:	39 f2                	cmp    %esi,%edx
80103875:	74 25                	je     8010389c <mycpu+0x5c>
    if (cpus[i].apicid == apicid)
80103877:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
8010387d:	0f b6 99 80 27 11 80 	movzbl -0x7feed880(%ecx),%ebx
80103884:	39 c3                	cmp    %eax,%ebx
80103886:	75 e8                	jne    80103870 <mycpu+0x30>
80103888:	8d 81 80 27 11 80    	lea    -0x7feed880(%ecx),%eax
}
8010388e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103891:	5b                   	pop    %ebx
80103892:	5e                   	pop    %esi
80103893:	5d                   	pop    %ebp
80103894:	c3                   	ret    
    if (cpus[i].apicid == apicid)
80103895:	b8 80 27 11 80       	mov    $0x80112780,%eax
      return &cpus[i];
8010389a:	eb f2                	jmp    8010388e <mycpu+0x4e>
  panic("unknown apicid\n");
8010389c:	83 ec 0c             	sub    $0xc,%esp
8010389f:	68 7c 75 10 80       	push   $0x8010757c
801038a4:	e8 e7 ca ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
801038a9:	83 ec 0c             	sub    $0xc,%esp
801038ac:	68 b4 76 10 80       	push   $0x801076b4
801038b1:	e8 da ca ff ff       	call   80100390 <panic>
801038b6:	8d 76 00             	lea    0x0(%esi),%esi
801038b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801038c0 <cpuid>:
cpuid() {
801038c0:	55                   	push   %ebp
801038c1:	89 e5                	mov    %esp,%ebp
801038c3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801038c6:	e8 75 ff ff ff       	call   80103840 <mycpu>
}
801038cb:	c9                   	leave  
  return mycpu()-cpus;
801038cc:	2d 80 27 11 80       	sub    $0x80112780,%eax
801038d1:	c1 f8 04             	sar    $0x4,%eax
801038d4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801038da:	c3                   	ret    
801038db:	90                   	nop
801038dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801038e0 <myproc>:
myproc(void) {
801038e0:	55                   	push   %ebp
801038e1:	89 e5                	mov    %esp,%ebp
801038e3:	53                   	push   %ebx
801038e4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801038e7:	e8 74 0b 00 00       	call   80104460 <pushcli>
  c = mycpu();
801038ec:	e8 4f ff ff ff       	call   80103840 <mycpu>
  p = c->proc;
801038f1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801038f7:	e8 74 0c 00 00       	call   80104570 <popcli>
}
801038fc:	83 c4 04             	add    $0x4,%esp
801038ff:	89 d8                	mov    %ebx,%eax
80103901:	5b                   	pop    %ebx
80103902:	5d                   	pop    %ebp
80103903:	c3                   	ret    
80103904:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010390a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103910 <userinit>:
{
80103910:	55                   	push   %ebp
80103911:	89 e5                	mov    %esp,%ebp
80103913:	53                   	push   %ebx
80103914:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103917:	e8 e4 fd ff ff       	call   80103700 <allocproc>
8010391c:	89 c3                	mov    %eax,%ebx
  initproc = p;
8010391e:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
80103923:	e8 78 34 00 00       	call   80106da0 <setupkvm>
80103928:	89 43 04             	mov    %eax,0x4(%ebx)
8010392b:	85 c0                	test   %eax,%eax
8010392d:	0f 84 bd 00 00 00    	je     801039f0 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103933:	83 ec 04             	sub    $0x4,%esp
80103936:	68 2c 00 00 00       	push   $0x2c
8010393b:	68 60 a4 10 80       	push   $0x8010a460
80103940:	50                   	push   %eax
80103941:	e8 3a 31 00 00       	call   80106a80 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103946:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103949:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
8010394f:	6a 4c                	push   $0x4c
80103951:	6a 00                	push   $0x0
80103953:	ff 73 18             	pushl  0x18(%ebx)
80103956:	e8 c5 0c 00 00       	call   80104620 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010395b:	8b 43 18             	mov    0x18(%ebx),%eax
8010395e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103963:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103966:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010396b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010396f:	8b 43 18             	mov    0x18(%ebx),%eax
80103972:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103976:	8b 43 18             	mov    0x18(%ebx),%eax
80103979:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010397d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103981:	8b 43 18             	mov    0x18(%ebx),%eax
80103984:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103988:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010398c:	8b 43 18             	mov    0x18(%ebx),%eax
8010398f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103996:	8b 43 18             	mov    0x18(%ebx),%eax
80103999:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801039a0:	8b 43 18             	mov    0x18(%ebx),%eax
801039a3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
801039aa:	8d 43 6c             	lea    0x6c(%ebx),%eax
801039ad:	6a 10                	push   $0x10
801039af:	68 a5 75 10 80       	push   $0x801075a5
801039b4:	50                   	push   %eax
801039b5:	e8 36 0e 00 00       	call   801047f0 <safestrcpy>
  p->cwd = namei("/");
801039ba:	c7 04 24 ae 75 10 80 	movl   $0x801075ae,(%esp)
801039c1:	e8 fa e5 ff ff       	call   80101fc0 <namei>
801039c6:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
801039c9:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801039d0:	e8 db 0a 00 00       	call   801044b0 <acquire>
  p->state = RUNNABLE;
801039d5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
801039dc:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801039e3:	e8 e8 0b 00 00       	call   801045d0 <release>
}
801039e8:	83 c4 10             	add    $0x10,%esp
801039eb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801039ee:	c9                   	leave  
801039ef:	c3                   	ret    
    panic("userinit: out of memory?");
801039f0:	83 ec 0c             	sub    $0xc,%esp
801039f3:	68 8c 75 10 80       	push   $0x8010758c
801039f8:	e8 93 c9 ff ff       	call   80100390 <panic>
801039fd:	8d 76 00             	lea    0x0(%esi),%esi

80103a00 <growproc>:
{
80103a00:	55                   	push   %ebp
80103a01:	89 e5                	mov    %esp,%ebp
80103a03:	56                   	push   %esi
80103a04:	53                   	push   %ebx
80103a05:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103a08:	e8 53 0a 00 00       	call   80104460 <pushcli>
  c = mycpu();
80103a0d:	e8 2e fe ff ff       	call   80103840 <mycpu>
  p = c->proc;
80103a12:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103a18:	e8 53 0b 00 00       	call   80104570 <popcli>
  sz = curproc->sz;
80103a1d:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103a1f:	85 f6                	test   %esi,%esi
80103a21:	7f 1d                	jg     80103a40 <growproc+0x40>
  } else if(n < 0){
80103a23:	75 3b                	jne    80103a60 <growproc+0x60>
  switchuvm(curproc);
80103a25:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103a28:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103a2a:	53                   	push   %ebx
80103a2b:	e8 40 2f 00 00       	call   80106970 <switchuvm>
  return 0;
80103a30:	83 c4 10             	add    $0x10,%esp
80103a33:	31 c0                	xor    %eax,%eax
}
80103a35:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a38:	5b                   	pop    %ebx
80103a39:	5e                   	pop    %esi
80103a3a:	5d                   	pop    %ebp
80103a3b:	c3                   	ret    
80103a3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103a40:	83 ec 04             	sub    $0x4,%esp
80103a43:	01 c6                	add    %eax,%esi
80103a45:	56                   	push   %esi
80103a46:	50                   	push   %eax
80103a47:	ff 73 04             	pushl  0x4(%ebx)
80103a4a:	e8 71 31 00 00       	call   80106bc0 <allocuvm>
80103a4f:	83 c4 10             	add    $0x10,%esp
80103a52:	85 c0                	test   %eax,%eax
80103a54:	75 cf                	jne    80103a25 <growproc+0x25>
      return -1;
80103a56:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103a5b:	eb d8                	jmp    80103a35 <growproc+0x35>
80103a5d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103a60:	83 ec 04             	sub    $0x4,%esp
80103a63:	01 c6                	add    %eax,%esi
80103a65:	56                   	push   %esi
80103a66:	50                   	push   %eax
80103a67:	ff 73 04             	pushl  0x4(%ebx)
80103a6a:	e8 81 32 00 00       	call   80106cf0 <deallocuvm>
80103a6f:	83 c4 10             	add    $0x10,%esp
80103a72:	85 c0                	test   %eax,%eax
80103a74:	75 af                	jne    80103a25 <growproc+0x25>
80103a76:	eb de                	jmp    80103a56 <growproc+0x56>
80103a78:	90                   	nop
80103a79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103a80 <fork>:
{
80103a80:	55                   	push   %ebp
80103a81:	89 e5                	mov    %esp,%ebp
80103a83:	57                   	push   %edi
80103a84:	56                   	push   %esi
80103a85:	53                   	push   %ebx
80103a86:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103a89:	e8 d2 09 00 00       	call   80104460 <pushcli>
  c = mycpu();
80103a8e:	e8 ad fd ff ff       	call   80103840 <mycpu>
  p = c->proc;
80103a93:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103a99:	e8 d2 0a 00 00       	call   80104570 <popcli>
  if((np = allocproc()) == 0){
80103a9e:	e8 5d fc ff ff       	call   80103700 <allocproc>
80103aa3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103aa6:	85 c0                	test   %eax,%eax
80103aa8:	0f 84 b7 00 00 00    	je     80103b65 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103aae:	83 ec 08             	sub    $0x8,%esp
80103ab1:	ff 33                	pushl  (%ebx)
80103ab3:	89 c7                	mov    %eax,%edi
80103ab5:	ff 73 04             	pushl  0x4(%ebx)
80103ab8:	e8 b3 33 00 00       	call   80106e70 <copyuvm>
80103abd:	83 c4 10             	add    $0x10,%esp
80103ac0:	89 47 04             	mov    %eax,0x4(%edi)
80103ac3:	85 c0                	test   %eax,%eax
80103ac5:	0f 84 a1 00 00 00    	je     80103b6c <fork+0xec>
  np->sz = curproc->sz;
80103acb:	8b 03                	mov    (%ebx),%eax
80103acd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103ad0:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103ad2:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103ad5:	89 c8                	mov    %ecx,%eax
80103ad7:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103ada:	b9 13 00 00 00       	mov    $0x13,%ecx
80103adf:	8b 73 18             	mov    0x18(%ebx),%esi
80103ae2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103ae4:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103ae6:	8b 40 18             	mov    0x18(%eax),%eax
80103ae9:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103af0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103af4:	85 c0                	test   %eax,%eax
80103af6:	74 13                	je     80103b0b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103af8:	83 ec 0c             	sub    $0xc,%esp
80103afb:	50                   	push   %eax
80103afc:	e8 6f d3 ff ff       	call   80100e70 <filedup>
80103b01:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103b04:	83 c4 10             	add    $0x10,%esp
80103b07:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103b0b:	83 c6 01             	add    $0x1,%esi
80103b0e:	83 fe 10             	cmp    $0x10,%esi
80103b11:	75 dd                	jne    80103af0 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103b13:	83 ec 0c             	sub    $0xc,%esp
80103b16:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103b19:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103b1c:	e8 cf db ff ff       	call   801016f0 <idup>
80103b21:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103b24:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103b27:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103b2a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103b2d:	6a 10                	push   $0x10
80103b2f:	53                   	push   %ebx
80103b30:	50                   	push   %eax
80103b31:	e8 ba 0c 00 00       	call   801047f0 <safestrcpy>
  pid = np->pid;
80103b36:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103b39:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103b40:	e8 6b 09 00 00       	call   801044b0 <acquire>
  np->state = RUNNABLE;
80103b45:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103b4c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103b53:	e8 78 0a 00 00       	call   801045d0 <release>
  return pid;
80103b58:	83 c4 10             	add    $0x10,%esp
}
80103b5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103b5e:	89 d8                	mov    %ebx,%eax
80103b60:	5b                   	pop    %ebx
80103b61:	5e                   	pop    %esi
80103b62:	5f                   	pop    %edi
80103b63:	5d                   	pop    %ebp
80103b64:	c3                   	ret    
    return -1;
80103b65:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103b6a:	eb ef                	jmp    80103b5b <fork+0xdb>
    kfree(np->kstack);
80103b6c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103b6f:	83 ec 0c             	sub    $0xc,%esp
80103b72:	ff 73 08             	pushl  0x8(%ebx)
80103b75:	e8 76 e8 ff ff       	call   801023f0 <kfree>
    np->kstack = 0;
80103b7a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103b81:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103b84:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103b8b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103b90:	eb c9                	jmp    80103b5b <fork+0xdb>
80103b92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ba0 <scheduler>:
{
80103ba0:	55                   	push   %ebp
80103ba1:	89 e5                	mov    %esp,%ebp
80103ba3:	57                   	push   %edi
80103ba4:	56                   	push   %esi
80103ba5:	53                   	push   %ebx
80103ba6:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103ba9:	e8 92 fc ff ff       	call   80103840 <mycpu>
  c->proc = 0;
80103bae:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103bb5:	00 00 00 
  struct cpu *c = mycpu();
80103bb8:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103bba:	8d 78 04             	lea    0x4(%eax),%edi
80103bbd:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103bc0:	fb                   	sti    
    acquire(&ptable.lock);
80103bc1:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103bc4:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
    acquire(&ptable.lock);
80103bc9:	68 20 2d 11 80       	push   $0x80112d20
80103bce:	e8 dd 08 00 00       	call   801044b0 <acquire>
80103bd3:	83 c4 10             	add    $0x10,%esp
80103bd6:	8d 76 00             	lea    0x0(%esi),%esi
80103bd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      if(p->state != RUNNABLE)
80103be0:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103be4:	75 33                	jne    80103c19 <scheduler+0x79>
      switchuvm(p);
80103be6:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103be9:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103bef:	53                   	push   %ebx
80103bf0:	e8 7b 2d 00 00       	call   80106970 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103bf5:	58                   	pop    %eax
80103bf6:	5a                   	pop    %edx
80103bf7:	ff 73 1c             	pushl  0x1c(%ebx)
80103bfa:	57                   	push   %edi
      p->state = RUNNING;
80103bfb:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103c02:	e8 44 0c 00 00       	call   8010484b <swtch>
      switchkvm();
80103c07:	e8 54 2d 00 00       	call   80106960 <switchkvm>
      c->proc = 0;
80103c0c:	83 c4 10             	add    $0x10,%esp
80103c0f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103c16:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c19:	83 c3 7c             	add    $0x7c,%ebx
80103c1c:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103c22:	75 bc                	jne    80103be0 <scheduler+0x40>
    release(&ptable.lock);
80103c24:	83 ec 0c             	sub    $0xc,%esp
80103c27:	68 20 2d 11 80       	push   $0x80112d20
80103c2c:	e8 9f 09 00 00       	call   801045d0 <release>
    sti();
80103c31:	83 c4 10             	add    $0x10,%esp
80103c34:	eb 8a                	jmp    80103bc0 <scheduler+0x20>
80103c36:	8d 76 00             	lea    0x0(%esi),%esi
80103c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103c40 <sched>:
{
80103c40:	55                   	push   %ebp
80103c41:	89 e5                	mov    %esp,%ebp
80103c43:	56                   	push   %esi
80103c44:	53                   	push   %ebx
  pushcli();
80103c45:	e8 16 08 00 00       	call   80104460 <pushcli>
  c = mycpu();
80103c4a:	e8 f1 fb ff ff       	call   80103840 <mycpu>
  p = c->proc;
80103c4f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c55:	e8 16 09 00 00       	call   80104570 <popcli>
  if(!holding(&ptable.lock))
80103c5a:	83 ec 0c             	sub    $0xc,%esp
80103c5d:	68 20 2d 11 80       	push   $0x80112d20
80103c62:	e8 b9 07 00 00       	call   80104420 <holding>
80103c67:	83 c4 10             	add    $0x10,%esp
80103c6a:	85 c0                	test   %eax,%eax
80103c6c:	74 4f                	je     80103cbd <sched+0x7d>
  if(mycpu()->ncli != 1)
80103c6e:	e8 cd fb ff ff       	call   80103840 <mycpu>
80103c73:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103c7a:	75 68                	jne    80103ce4 <sched+0xa4>
  if(p->state == RUNNING)
80103c7c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103c80:	74 55                	je     80103cd7 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103c82:	9c                   	pushf  
80103c83:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103c84:	f6 c4 02             	test   $0x2,%ah
80103c87:	75 41                	jne    80103cca <sched+0x8a>
  intena = mycpu()->intena;
80103c89:	e8 b2 fb ff ff       	call   80103840 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103c8e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103c91:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103c97:	e8 a4 fb ff ff       	call   80103840 <mycpu>
80103c9c:	83 ec 08             	sub    $0x8,%esp
80103c9f:	ff 70 04             	pushl  0x4(%eax)
80103ca2:	53                   	push   %ebx
80103ca3:	e8 a3 0b 00 00       	call   8010484b <swtch>
  mycpu()->intena = intena;
80103ca8:	e8 93 fb ff ff       	call   80103840 <mycpu>
}
80103cad:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103cb0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103cb6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103cb9:	5b                   	pop    %ebx
80103cba:	5e                   	pop    %esi
80103cbb:	5d                   	pop    %ebp
80103cbc:	c3                   	ret    
    panic("sched ptable.lock");
80103cbd:	83 ec 0c             	sub    $0xc,%esp
80103cc0:	68 b0 75 10 80       	push   $0x801075b0
80103cc5:	e8 c6 c6 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
80103cca:	83 ec 0c             	sub    $0xc,%esp
80103ccd:	68 dc 75 10 80       	push   $0x801075dc
80103cd2:	e8 b9 c6 ff ff       	call   80100390 <panic>
    panic("sched running");
80103cd7:	83 ec 0c             	sub    $0xc,%esp
80103cda:	68 ce 75 10 80       	push   $0x801075ce
80103cdf:	e8 ac c6 ff ff       	call   80100390 <panic>
    panic("sched locks");
80103ce4:	83 ec 0c             	sub    $0xc,%esp
80103ce7:	68 c2 75 10 80       	push   $0x801075c2
80103cec:	e8 9f c6 ff ff       	call   80100390 <panic>
80103cf1:	eb 0d                	jmp    80103d00 <exit>
80103cf3:	90                   	nop
80103cf4:	90                   	nop
80103cf5:	90                   	nop
80103cf6:	90                   	nop
80103cf7:	90                   	nop
80103cf8:	90                   	nop
80103cf9:	90                   	nop
80103cfa:	90                   	nop
80103cfb:	90                   	nop
80103cfc:	90                   	nop
80103cfd:	90                   	nop
80103cfe:	90                   	nop
80103cff:	90                   	nop

80103d00 <exit>:
{
80103d00:	55                   	push   %ebp
80103d01:	89 e5                	mov    %esp,%ebp
80103d03:	57                   	push   %edi
80103d04:	56                   	push   %esi
80103d05:	53                   	push   %ebx
80103d06:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80103d09:	e8 52 07 00 00       	call   80104460 <pushcli>
  c = mycpu();
80103d0e:	e8 2d fb ff ff       	call   80103840 <mycpu>
  p = c->proc;
80103d13:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103d19:	e8 52 08 00 00       	call   80104570 <popcli>
  if(curproc == initproc)
80103d1e:	8d 5e 28             	lea    0x28(%esi),%ebx
80103d21:	8d 7e 68             	lea    0x68(%esi),%edi
80103d24:	39 35 b8 a5 10 80    	cmp    %esi,0x8010a5b8
80103d2a:	0f 84 e7 00 00 00    	je     80103e17 <exit+0x117>
    if(curproc->ofile[fd]){
80103d30:	8b 03                	mov    (%ebx),%eax
80103d32:	85 c0                	test   %eax,%eax
80103d34:	74 12                	je     80103d48 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80103d36:	83 ec 0c             	sub    $0xc,%esp
80103d39:	50                   	push   %eax
80103d3a:	e8 81 d1 ff ff       	call   80100ec0 <fileclose>
      curproc->ofile[fd] = 0;
80103d3f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103d45:	83 c4 10             	add    $0x10,%esp
80103d48:	83 c3 04             	add    $0x4,%ebx
  for(fd = 0; fd < NOFILE; fd++){
80103d4b:	39 fb                	cmp    %edi,%ebx
80103d4d:	75 e1                	jne    80103d30 <exit+0x30>
  begin_op();
80103d4f:	e8 4c ef ff ff       	call   80102ca0 <begin_op>
  iput(curproc->cwd);
80103d54:	83 ec 0c             	sub    $0xc,%esp
80103d57:	ff 76 68             	pushl  0x68(%esi)
80103d5a:	e8 f1 da ff ff       	call   80101850 <iput>
  end_op();
80103d5f:	e8 ac ef ff ff       	call   80102d10 <end_op>
  curproc->cwd = 0;
80103d64:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80103d6b:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103d72:	e8 39 07 00 00       	call   801044b0 <acquire>
  wakeup1(curproc->parent);
80103d77:	8b 56 14             	mov    0x14(%esi),%edx
80103d7a:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d7d:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103d82:	eb 0e                	jmp    80103d92 <exit+0x92>
80103d84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d88:	83 c0 7c             	add    $0x7c,%eax
80103d8b:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103d90:	74 1c                	je     80103dae <exit+0xae>
    if(p->state == SLEEPING && p->chan == chan)
80103d92:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103d96:	75 f0                	jne    80103d88 <exit+0x88>
80103d98:	3b 50 20             	cmp    0x20(%eax),%edx
80103d9b:	75 eb                	jne    80103d88 <exit+0x88>
      p->state = RUNNABLE;
80103d9d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103da4:	83 c0 7c             	add    $0x7c,%eax
80103da7:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103dac:	75 e4                	jne    80103d92 <exit+0x92>
      p->parent = initproc;
80103dae:	8b 0d b8 a5 10 80    	mov    0x8010a5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103db4:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103db9:	eb 10                	jmp    80103dcb <exit+0xcb>
80103dbb:	90                   	nop
80103dbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103dc0:	83 c2 7c             	add    $0x7c,%edx
80103dc3:	81 fa 54 4c 11 80    	cmp    $0x80114c54,%edx
80103dc9:	74 33                	je     80103dfe <exit+0xfe>
    if(p->parent == curproc){
80103dcb:	39 72 14             	cmp    %esi,0x14(%edx)
80103dce:	75 f0                	jne    80103dc0 <exit+0xc0>
      if(p->state == ZOMBIE)
80103dd0:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103dd4:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103dd7:	75 e7                	jne    80103dc0 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103dd9:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103dde:	eb 0a                	jmp    80103dea <exit+0xea>
80103de0:	83 c0 7c             	add    $0x7c,%eax
80103de3:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103de8:	74 d6                	je     80103dc0 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80103dea:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103dee:	75 f0                	jne    80103de0 <exit+0xe0>
80103df0:	3b 48 20             	cmp    0x20(%eax),%ecx
80103df3:	75 eb                	jne    80103de0 <exit+0xe0>
      p->state = RUNNABLE;
80103df5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103dfc:	eb e2                	jmp    80103de0 <exit+0xe0>
  curproc->state = ZOMBIE;
80103dfe:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80103e05:	e8 36 fe ff ff       	call   80103c40 <sched>
  panic("zombie exit");
80103e0a:	83 ec 0c             	sub    $0xc,%esp
80103e0d:	68 fd 75 10 80       	push   $0x801075fd
80103e12:	e8 79 c5 ff ff       	call   80100390 <panic>
    panic("init exiting");
80103e17:	83 ec 0c             	sub    $0xc,%esp
80103e1a:	68 f0 75 10 80       	push   $0x801075f0
80103e1f:	e8 6c c5 ff ff       	call   80100390 <panic>
80103e24:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103e2a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103e30 <yield>:
{
80103e30:	55                   	push   %ebp
80103e31:	89 e5                	mov    %esp,%ebp
80103e33:	53                   	push   %ebx
80103e34:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103e37:	68 20 2d 11 80       	push   $0x80112d20
80103e3c:	e8 6f 06 00 00       	call   801044b0 <acquire>
  pushcli();
80103e41:	e8 1a 06 00 00       	call   80104460 <pushcli>
  c = mycpu();
80103e46:	e8 f5 f9 ff ff       	call   80103840 <mycpu>
  p = c->proc;
80103e4b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e51:	e8 1a 07 00 00       	call   80104570 <popcli>
  myproc()->state = RUNNABLE;
80103e56:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80103e5d:	e8 de fd ff ff       	call   80103c40 <sched>
  release(&ptable.lock);
80103e62:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e69:	e8 62 07 00 00       	call   801045d0 <release>
}
80103e6e:	83 c4 10             	add    $0x10,%esp
80103e71:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103e74:	c9                   	leave  
80103e75:	c3                   	ret    
80103e76:	8d 76 00             	lea    0x0(%esi),%esi
80103e79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103e80 <sleep>:
{
80103e80:	55                   	push   %ebp
80103e81:	89 e5                	mov    %esp,%ebp
80103e83:	57                   	push   %edi
80103e84:	56                   	push   %esi
80103e85:	53                   	push   %ebx
80103e86:	83 ec 0c             	sub    $0xc,%esp
80103e89:	8b 7d 08             	mov    0x8(%ebp),%edi
80103e8c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80103e8f:	e8 cc 05 00 00       	call   80104460 <pushcli>
  c = mycpu();
80103e94:	e8 a7 f9 ff ff       	call   80103840 <mycpu>
  p = c->proc;
80103e99:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e9f:	e8 cc 06 00 00       	call   80104570 <popcli>
  if(p == 0)
80103ea4:	85 db                	test   %ebx,%ebx
80103ea6:	0f 84 87 00 00 00    	je     80103f33 <sleep+0xb3>
  if(lk == 0)
80103eac:	85 f6                	test   %esi,%esi
80103eae:	74 76                	je     80103f26 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103eb0:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80103eb6:	74 50                	je     80103f08 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103eb8:	83 ec 0c             	sub    $0xc,%esp
80103ebb:	68 20 2d 11 80       	push   $0x80112d20
80103ec0:	e8 eb 05 00 00       	call   801044b0 <acquire>
    release(lk);
80103ec5:	89 34 24             	mov    %esi,(%esp)
80103ec8:	e8 03 07 00 00       	call   801045d0 <release>
  p->chan = chan;
80103ecd:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103ed0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103ed7:	e8 64 fd ff ff       	call   80103c40 <sched>
  p->chan = 0;
80103edc:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80103ee3:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103eea:	e8 e1 06 00 00       	call   801045d0 <release>
    acquire(lk);
80103eef:	89 75 08             	mov    %esi,0x8(%ebp)
80103ef2:	83 c4 10             	add    $0x10,%esp
}
80103ef5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ef8:	5b                   	pop    %ebx
80103ef9:	5e                   	pop    %esi
80103efa:	5f                   	pop    %edi
80103efb:	5d                   	pop    %ebp
    acquire(lk);
80103efc:	e9 af 05 00 00       	jmp    801044b0 <acquire>
80103f01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80103f08:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103f0b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103f12:	e8 29 fd ff ff       	call   80103c40 <sched>
  p->chan = 0;
80103f17:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80103f1e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f21:	5b                   	pop    %ebx
80103f22:	5e                   	pop    %esi
80103f23:	5f                   	pop    %edi
80103f24:	5d                   	pop    %ebp
80103f25:	c3                   	ret    
    panic("sleep without lk");
80103f26:	83 ec 0c             	sub    $0xc,%esp
80103f29:	68 0f 76 10 80       	push   $0x8010760f
80103f2e:	e8 5d c4 ff ff       	call   80100390 <panic>
    panic("sleep");
80103f33:	83 ec 0c             	sub    $0xc,%esp
80103f36:	68 09 76 10 80       	push   $0x80107609
80103f3b:	e8 50 c4 ff ff       	call   80100390 <panic>

80103f40 <wait>:
{
80103f40:	55                   	push   %ebp
80103f41:	89 e5                	mov    %esp,%ebp
80103f43:	56                   	push   %esi
80103f44:	53                   	push   %ebx
  pushcli();
80103f45:	e8 16 05 00 00       	call   80104460 <pushcli>
  c = mycpu();
80103f4a:	e8 f1 f8 ff ff       	call   80103840 <mycpu>
  p = c->proc;
80103f4f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103f55:	e8 16 06 00 00       	call   80104570 <popcli>
  acquire(&ptable.lock);
80103f5a:	83 ec 0c             	sub    $0xc,%esp
80103f5d:	68 20 2d 11 80       	push   $0x80112d20
80103f62:	e8 49 05 00 00       	call   801044b0 <acquire>
80103f67:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80103f6a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f6c:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103f71:	eb 10                	jmp    80103f83 <wait+0x43>
80103f73:	90                   	nop
80103f74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f78:	83 c3 7c             	add    $0x7c,%ebx
80103f7b:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103f81:	74 1b                	je     80103f9e <wait+0x5e>
      if(p->parent != curproc)
80103f83:	39 73 14             	cmp    %esi,0x14(%ebx)
80103f86:	75 f0                	jne    80103f78 <wait+0x38>
      if(p->state == ZOMBIE){
80103f88:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103f8c:	74 32                	je     80103fc0 <wait+0x80>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f8e:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
80103f91:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f96:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103f9c:	75 e5                	jne    80103f83 <wait+0x43>
    if(!havekids || curproc->killed){
80103f9e:	85 c0                	test   %eax,%eax
80103fa0:	74 74                	je     80104016 <wait+0xd6>
80103fa2:	8b 46 24             	mov    0x24(%esi),%eax
80103fa5:	85 c0                	test   %eax,%eax
80103fa7:	75 6d                	jne    80104016 <wait+0xd6>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103fa9:	83 ec 08             	sub    $0x8,%esp
80103fac:	68 20 2d 11 80       	push   $0x80112d20
80103fb1:	56                   	push   %esi
80103fb2:	e8 c9 fe ff ff       	call   80103e80 <sleep>
    havekids = 0;
80103fb7:	83 c4 10             	add    $0x10,%esp
80103fba:	eb ae                	jmp    80103f6a <wait+0x2a>
80103fbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        kfree(p->kstack);
80103fc0:	83 ec 0c             	sub    $0xc,%esp
80103fc3:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
80103fc6:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103fc9:	e8 22 e4 ff ff       	call   801023f0 <kfree>
        freevm(p->pgdir);
80103fce:	5a                   	pop    %edx
80103fcf:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
80103fd2:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103fd9:	e8 42 2d 00 00       	call   80106d20 <freevm>
        release(&ptable.lock);
80103fde:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
        p->pid = 0;
80103fe5:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103fec:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103ff3:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103ff7:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103ffe:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104005:	e8 c6 05 00 00       	call   801045d0 <release>
        return pid;
8010400a:	83 c4 10             	add    $0x10,%esp
}
8010400d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104010:	89 f0                	mov    %esi,%eax
80104012:	5b                   	pop    %ebx
80104013:	5e                   	pop    %esi
80104014:	5d                   	pop    %ebp
80104015:	c3                   	ret    
      release(&ptable.lock);
80104016:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104019:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010401e:	68 20 2d 11 80       	push   $0x80112d20
80104023:	e8 a8 05 00 00       	call   801045d0 <release>
      return -1;
80104028:	83 c4 10             	add    $0x10,%esp
8010402b:	eb e0                	jmp    8010400d <wait+0xcd>
8010402d:	8d 76 00             	lea    0x0(%esi),%esi

80104030 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104030:	55                   	push   %ebp
80104031:	89 e5                	mov    %esp,%ebp
80104033:	53                   	push   %ebx
80104034:	83 ec 10             	sub    $0x10,%esp
80104037:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010403a:	68 20 2d 11 80       	push   $0x80112d20
8010403f:	e8 6c 04 00 00       	call   801044b0 <acquire>
80104044:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104047:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
8010404c:	eb 0c                	jmp    8010405a <wakeup+0x2a>
8010404e:	66 90                	xchg   %ax,%ax
80104050:	83 c0 7c             	add    $0x7c,%eax
80104053:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80104058:	74 1c                	je     80104076 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
8010405a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010405e:	75 f0                	jne    80104050 <wakeup+0x20>
80104060:	3b 58 20             	cmp    0x20(%eax),%ebx
80104063:	75 eb                	jne    80104050 <wakeup+0x20>
      p->state = RUNNABLE;
80104065:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010406c:	83 c0 7c             	add    $0x7c,%eax
8010406f:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80104074:	75 e4                	jne    8010405a <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
80104076:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
8010407d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104080:	c9                   	leave  
  release(&ptable.lock);
80104081:	e9 4a 05 00 00       	jmp    801045d0 <release>
80104086:	8d 76 00             	lea    0x0(%esi),%esi
80104089:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104090 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104090:	55                   	push   %ebp
80104091:	89 e5                	mov    %esp,%ebp
80104093:	53                   	push   %ebx
80104094:	83 ec 10             	sub    $0x10,%esp
80104097:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010409a:	68 20 2d 11 80       	push   $0x80112d20
8010409f:	e8 0c 04 00 00       	call   801044b0 <acquire>
801040a4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040a7:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
801040ac:	eb 0c                	jmp    801040ba <kill+0x2a>
801040ae:	66 90                	xchg   %ax,%ax
801040b0:	83 c0 7c             	add    $0x7c,%eax
801040b3:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
801040b8:	74 36                	je     801040f0 <kill+0x60>
    if(p->pid == pid){
801040ba:	39 58 10             	cmp    %ebx,0x10(%eax)
801040bd:	75 f1                	jne    801040b0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801040bf:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801040c3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801040ca:	75 07                	jne    801040d3 <kill+0x43>
        p->state = RUNNABLE;
801040cc:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801040d3:	83 ec 0c             	sub    $0xc,%esp
801040d6:	68 20 2d 11 80       	push   $0x80112d20
801040db:	e8 f0 04 00 00       	call   801045d0 <release>
      return 0;
801040e0:	83 c4 10             	add    $0x10,%esp
801040e3:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
801040e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801040e8:	c9                   	leave  
801040e9:	c3                   	ret    
801040ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
801040f0:	83 ec 0c             	sub    $0xc,%esp
801040f3:	68 20 2d 11 80       	push   $0x80112d20
801040f8:	e8 d3 04 00 00       	call   801045d0 <release>
  return -1;
801040fd:	83 c4 10             	add    $0x10,%esp
80104100:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104105:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104108:	c9                   	leave  
80104109:	c3                   	ret    
8010410a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104110 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104110:	55                   	push   %ebp
80104111:	89 e5                	mov    %esp,%ebp
80104113:	57                   	push   %edi
80104114:	56                   	push   %esi
80104115:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104118:	53                   	push   %ebx
80104119:	bb c0 2d 11 80       	mov    $0x80112dc0,%ebx
8010411e:	83 ec 3c             	sub    $0x3c,%esp
80104121:	eb 24                	jmp    80104147 <procdump+0x37>
80104123:	90                   	nop
80104124:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104128:	83 ec 0c             	sub    $0xc,%esp
8010412b:	68 86 76 10 80       	push   $0x80107686
80104130:	e8 7b c5 ff ff       	call   801006b0 <cprintf>
80104135:	83 c4 10             	add    $0x10,%esp
80104138:	83 c3 7c             	add    $0x7c,%ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010413b:	81 fb c0 4c 11 80    	cmp    $0x80114cc0,%ebx
80104141:	0f 84 81 00 00 00    	je     801041c8 <procdump+0xb8>
    if(p->state == UNUSED)
80104147:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010414a:	85 c0                	test   %eax,%eax
8010414c:	74 ea                	je     80104138 <procdump+0x28>
      state = "???";
8010414e:	ba 20 76 10 80       	mov    $0x80107620,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104153:	83 f8 05             	cmp    $0x5,%eax
80104156:	77 11                	ja     80104169 <procdump+0x59>
80104158:	8b 14 85 dc 76 10 80 	mov    -0x7fef8924(,%eax,4),%edx
      state = "???";
8010415f:	b8 20 76 10 80       	mov    $0x80107620,%eax
80104164:	85 d2                	test   %edx,%edx
80104166:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104169:	53                   	push   %ebx
8010416a:	52                   	push   %edx
8010416b:	ff 73 a4             	pushl  -0x5c(%ebx)
8010416e:	68 24 76 10 80       	push   $0x80107624
80104173:	e8 38 c5 ff ff       	call   801006b0 <cprintf>
    if(p->state == SLEEPING){
80104178:	83 c4 10             	add    $0x10,%esp
8010417b:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
8010417f:	75 a7                	jne    80104128 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104181:	83 ec 08             	sub    $0x8,%esp
80104184:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104187:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010418a:	50                   	push   %eax
8010418b:	8b 43 b0             	mov    -0x50(%ebx),%eax
8010418e:	8b 40 0c             	mov    0xc(%eax),%eax
80104191:	83 c0 08             	add    $0x8,%eax
80104194:	50                   	push   %eax
80104195:	e8 36 02 00 00       	call   801043d0 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
8010419a:	83 c4 10             	add    $0x10,%esp
8010419d:	8d 76 00             	lea    0x0(%esi),%esi
801041a0:	8b 17                	mov    (%edi),%edx
801041a2:	85 d2                	test   %edx,%edx
801041a4:	74 82                	je     80104128 <procdump+0x18>
        cprintf(" %p", pc[i]);
801041a6:	83 ec 08             	sub    $0x8,%esp
801041a9:	83 c7 04             	add    $0x4,%edi
801041ac:	52                   	push   %edx
801041ad:	68 61 70 10 80       	push   $0x80107061
801041b2:	e8 f9 c4 ff ff       	call   801006b0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801041b7:	83 c4 10             	add    $0x10,%esp
801041ba:	39 fe                	cmp    %edi,%esi
801041bc:	75 e2                	jne    801041a0 <procdump+0x90>
801041be:	e9 65 ff ff ff       	jmp    80104128 <procdump+0x18>
801041c3:	90                   	nop
801041c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
}
801041c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801041cb:	5b                   	pop    %ebx
801041cc:	5e                   	pop    %esi
801041cd:	5f                   	pop    %edi
801041ce:	5d                   	pop    %ebp
801041cf:	c3                   	ret    

801041d0 <cps>:

//current process status
int
cps()
{
801041d0:	55                   	push   %ebp
801041d1:	89 e5                	mov    %esp,%ebp
801041d3:	53                   	push   %ebx
801041d4:	83 ec 10             	sub    $0x10,%esp
  asm volatile("sti");
801041d7:	fb                   	sti    

    //Enable interrupts on this processor
    sti();
    
    //Loop over process talble looking for process with pid
    acquire(&ptable.lock);
801041d8:	68 20 2d 11 80       	push   $0x80112d20
    cprintf("name \t pid \t state \t \n");
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801041dd:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
    acquire(&ptable.lock);
801041e2:	e8 c9 02 00 00       	call   801044b0 <acquire>
    cprintf("name \t pid \t state \t \n");
801041e7:	c7 04 24 2d 76 10 80 	movl   $0x8010762d,(%esp)
801041ee:	e8 bd c4 ff ff       	call   801006b0 <cprintf>
801041f3:	83 c4 10             	add    $0x10,%esp
801041f6:	eb 1d                	jmp    80104215 <cps+0x45>
801041f8:	90                   	nop
801041f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    {
        if(p->state == SLEEPING)
            cprintf("%s \t %d \t SLEEPING \t \n", p->name, p->pid);
        else if(p->state == RUNNING)
80104200:	83 f8 04             	cmp    $0x4,%eax
80104203:	74 5b                	je     80104260 <cps+0x90>
            cprintf("%s \t %d \t RUNNING \t \n", p->name, p->pid);
        else if(p->state == RUNNABLE)
80104205:	83 f8 03             	cmp    $0x3,%eax
80104208:	74 76                	je     80104280 <cps+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010420a:	83 c3 7c             	add    $0x7c,%ebx
8010420d:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80104213:	74 2a                	je     8010423f <cps+0x6f>
        if(p->state == SLEEPING)
80104215:	8b 43 0c             	mov    0xc(%ebx),%eax
80104218:	83 f8 02             	cmp    $0x2,%eax
8010421b:	75 e3                	jne    80104200 <cps+0x30>
            cprintf("%s \t %d \t SLEEPING \t \n", p->name, p->pid);
8010421d:	83 ec 04             	sub    $0x4,%esp
80104220:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104223:	ff 73 10             	pushl  0x10(%ebx)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104226:	83 c3 7c             	add    $0x7c,%ebx
            cprintf("%s \t %d \t SLEEPING \t \n", p->name, p->pid);
80104229:	50                   	push   %eax
8010422a:	68 44 76 10 80       	push   $0x80107644
8010422f:	e8 7c c4 ff ff       	call   801006b0 <cprintf>
80104234:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104237:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
8010423d:	75 d6                	jne    80104215 <cps+0x45>
            cprintf("%s \t %d \t RUNNABLE \t \n", p->name, p->pid);
    }
    
    release(&ptable.lock);
8010423f:	83 ec 0c             	sub    $0xc,%esp
80104242:	68 20 2d 11 80       	push   $0x80112d20
80104247:	e8 84 03 00 00       	call   801045d0 <release>

    return 22;
}
8010424c:	b8 16 00 00 00       	mov    $0x16,%eax
80104251:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104254:	c9                   	leave  
80104255:	c3                   	ret    
80104256:	8d 76 00             	lea    0x0(%esi),%esi
80104259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
            cprintf("%s \t %d \t RUNNING \t \n", p->name, p->pid);
80104260:	83 ec 04             	sub    $0x4,%esp
80104263:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104266:	ff 73 10             	pushl  0x10(%ebx)
80104269:	50                   	push   %eax
8010426a:	68 5b 76 10 80       	push   $0x8010765b
8010426f:	e8 3c c4 ff ff       	call   801006b0 <cprintf>
80104274:	83 c4 10             	add    $0x10,%esp
80104277:	eb 91                	jmp    8010420a <cps+0x3a>
80104279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            cprintf("%s \t %d \t RUNNABLE \t \n", p->name, p->pid);
80104280:	83 ec 04             	sub    $0x4,%esp
80104283:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104286:	ff 73 10             	pushl  0x10(%ebx)
80104289:	50                   	push   %eax
8010428a:	68 71 76 10 80       	push   $0x80107671
8010428f:	e8 1c c4 ff ff       	call   801006b0 <cprintf>
80104294:	83 c4 10             	add    $0x10,%esp
80104297:	e9 6e ff ff ff       	jmp    8010420a <cps+0x3a>
8010429c:	66 90                	xchg   %ax,%ax
8010429e:	66 90                	xchg   %ax,%ax

801042a0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801042a0:	55                   	push   %ebp
801042a1:	89 e5                	mov    %esp,%ebp
801042a3:	53                   	push   %ebx
801042a4:	83 ec 0c             	sub    $0xc,%esp
801042a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801042aa:	68 f4 76 10 80       	push   $0x801076f4
801042af:	8d 43 04             	lea    0x4(%ebx),%eax
801042b2:	50                   	push   %eax
801042b3:	e8 f8 00 00 00       	call   801043b0 <initlock>
  lk->name = name;
801042b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801042bb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801042c1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801042c4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801042cb:	89 43 38             	mov    %eax,0x38(%ebx)
}
801042ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801042d1:	c9                   	leave  
801042d2:	c3                   	ret    
801042d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801042d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801042e0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801042e0:	55                   	push   %ebp
801042e1:	89 e5                	mov    %esp,%ebp
801042e3:	56                   	push   %esi
801042e4:	53                   	push   %ebx
801042e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801042e8:	8d 73 04             	lea    0x4(%ebx),%esi
801042eb:	83 ec 0c             	sub    $0xc,%esp
801042ee:	56                   	push   %esi
801042ef:	e8 bc 01 00 00       	call   801044b0 <acquire>
  while (lk->locked) {
801042f4:	8b 13                	mov    (%ebx),%edx
801042f6:	83 c4 10             	add    $0x10,%esp
801042f9:	85 d2                	test   %edx,%edx
801042fb:	74 16                	je     80104313 <acquiresleep+0x33>
801042fd:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104300:	83 ec 08             	sub    $0x8,%esp
80104303:	56                   	push   %esi
80104304:	53                   	push   %ebx
80104305:	e8 76 fb ff ff       	call   80103e80 <sleep>
  while (lk->locked) {
8010430a:	8b 03                	mov    (%ebx),%eax
8010430c:	83 c4 10             	add    $0x10,%esp
8010430f:	85 c0                	test   %eax,%eax
80104311:	75 ed                	jne    80104300 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104313:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104319:	e8 c2 f5 ff ff       	call   801038e0 <myproc>
8010431e:	8b 40 10             	mov    0x10(%eax),%eax
80104321:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104324:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104327:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010432a:	5b                   	pop    %ebx
8010432b:	5e                   	pop    %esi
8010432c:	5d                   	pop    %ebp
  release(&lk->lk);
8010432d:	e9 9e 02 00 00       	jmp    801045d0 <release>
80104332:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104339:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104340 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104340:	55                   	push   %ebp
80104341:	89 e5                	mov    %esp,%ebp
80104343:	56                   	push   %esi
80104344:	53                   	push   %ebx
80104345:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104348:	8d 73 04             	lea    0x4(%ebx),%esi
8010434b:	83 ec 0c             	sub    $0xc,%esp
8010434e:	56                   	push   %esi
8010434f:	e8 5c 01 00 00       	call   801044b0 <acquire>
  lk->locked = 0;
80104354:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010435a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104361:	89 1c 24             	mov    %ebx,(%esp)
80104364:	e8 c7 fc ff ff       	call   80104030 <wakeup>
  release(&lk->lk);
80104369:	89 75 08             	mov    %esi,0x8(%ebp)
8010436c:	83 c4 10             	add    $0x10,%esp
}
8010436f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104372:	5b                   	pop    %ebx
80104373:	5e                   	pop    %esi
80104374:	5d                   	pop    %ebp
  release(&lk->lk);
80104375:	e9 56 02 00 00       	jmp    801045d0 <release>
8010437a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104380 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104380:	55                   	push   %ebp
80104381:	89 e5                	mov    %esp,%ebp
80104383:	56                   	push   %esi
80104384:	53                   	push   %ebx
80104385:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;
  
  acquire(&lk->lk);
80104388:	8d 5e 04             	lea    0x4(%esi),%ebx
8010438b:	83 ec 0c             	sub    $0xc,%esp
8010438e:	53                   	push   %ebx
8010438f:	e8 1c 01 00 00       	call   801044b0 <acquire>
  r = lk->locked;
80104394:	8b 36                	mov    (%esi),%esi
  release(&lk->lk);
80104396:	89 1c 24             	mov    %ebx,(%esp)
80104399:	e8 32 02 00 00       	call   801045d0 <release>
  return r;
}
8010439e:	8d 65 f8             	lea    -0x8(%ebp),%esp
801043a1:	89 f0                	mov    %esi,%eax
801043a3:	5b                   	pop    %ebx
801043a4:	5e                   	pop    %esi
801043a5:	5d                   	pop    %ebp
801043a6:	c3                   	ret    
801043a7:	66 90                	xchg   %ax,%ax
801043a9:	66 90                	xchg   %ax,%ax
801043ab:	66 90                	xchg   %ax,%ax
801043ad:	66 90                	xchg   %ax,%ax
801043af:	90                   	nop

801043b0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801043b0:	55                   	push   %ebp
801043b1:	89 e5                	mov    %esp,%ebp
801043b3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801043b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801043b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801043bf:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801043c2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801043c9:	5d                   	pop    %ebp
801043ca:	c3                   	ret    
801043cb:	90                   	nop
801043cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801043d0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801043d0:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801043d1:	31 d2                	xor    %edx,%edx
{
801043d3:	89 e5                	mov    %esp,%ebp
801043d5:	53                   	push   %ebx
  ebp = (uint*)v - 2;
801043d6:	8b 45 08             	mov    0x8(%ebp),%eax
{
801043d9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
801043dc:	83 e8 08             	sub    $0x8,%eax
801043df:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801043e0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801043e6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801043ec:	77 1a                	ja     80104408 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
801043ee:	8b 58 04             	mov    0x4(%eax),%ebx
801043f1:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
801043f4:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
801043f7:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801043f9:	83 fa 0a             	cmp    $0xa,%edx
801043fc:	75 e2                	jne    801043e0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801043fe:	5b                   	pop    %ebx
801043ff:	5d                   	pop    %ebp
80104400:	c3                   	ret    
80104401:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104408:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010440b:	8d 51 28             	lea    0x28(%ecx),%edx
8010440e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104410:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104416:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104419:	39 c2                	cmp    %eax,%edx
8010441b:	75 f3                	jne    80104410 <getcallerpcs+0x40>
}
8010441d:	5b                   	pop    %ebx
8010441e:	5d                   	pop    %ebp
8010441f:	c3                   	ret    

80104420 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104420:	55                   	push   %ebp
80104421:	89 e5                	mov    %esp,%ebp
80104423:	53                   	push   %ebx
80104424:	83 ec 04             	sub    $0x4,%esp
80104427:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
8010442a:	8b 02                	mov    (%edx),%eax
8010442c:	85 c0                	test   %eax,%eax
8010442e:	75 10                	jne    80104440 <holding+0x20>
}
80104430:	83 c4 04             	add    $0x4,%esp
80104433:	31 c0                	xor    %eax,%eax
80104435:	5b                   	pop    %ebx
80104436:	5d                   	pop    %ebp
80104437:	c3                   	ret    
80104438:	90                   	nop
80104439:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return lock->locked && lock->cpu == mycpu();
80104440:	8b 5a 08             	mov    0x8(%edx),%ebx
80104443:	e8 f8 f3 ff ff       	call   80103840 <mycpu>
80104448:	39 c3                	cmp    %eax,%ebx
8010444a:	0f 94 c0             	sete   %al
}
8010444d:	83 c4 04             	add    $0x4,%esp
  return lock->locked && lock->cpu == mycpu();
80104450:	0f b6 c0             	movzbl %al,%eax
}
80104453:	5b                   	pop    %ebx
80104454:	5d                   	pop    %ebp
80104455:	c3                   	ret    
80104456:	8d 76 00             	lea    0x0(%esi),%esi
80104459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104460 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104460:	55                   	push   %ebp
80104461:	89 e5                	mov    %esp,%ebp
80104463:	53                   	push   %ebx
80104464:	83 ec 04             	sub    $0x4,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104467:	9c                   	pushf  
80104468:	5b                   	pop    %ebx
  asm volatile("cli");
80104469:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010446a:	e8 d1 f3 ff ff       	call   80103840 <mycpu>
8010446f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104475:	85 c0                	test   %eax,%eax
80104477:	74 17                	je     80104490 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104479:	e8 c2 f3 ff ff       	call   80103840 <mycpu>
8010447e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104485:	83 c4 04             	add    $0x4,%esp
80104488:	5b                   	pop    %ebx
80104489:	5d                   	pop    %ebp
8010448a:	c3                   	ret    
8010448b:	90                   	nop
8010448c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    mycpu()->intena = eflags & FL_IF;
80104490:	e8 ab f3 ff ff       	call   80103840 <mycpu>
80104495:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010449b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
801044a1:	eb d6                	jmp    80104479 <pushcli+0x19>
801044a3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801044a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801044b0 <acquire>:
{
801044b0:	55                   	push   %ebp
801044b1:	89 e5                	mov    %esp,%ebp
801044b3:	56                   	push   %esi
801044b4:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
801044b5:	e8 a6 ff ff ff       	call   80104460 <pushcli>
  if(holding(lk))
801044ba:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return lock->locked && lock->cpu == mycpu();
801044bd:	8b 03                	mov    (%ebx),%eax
801044bf:	85 c0                	test   %eax,%eax
801044c1:	0f 85 81 00 00 00    	jne    80104548 <acquire+0x98>
  asm volatile("lock; xchgl %0, %1" :
801044c7:	ba 01 00 00 00       	mov    $0x1,%edx
801044cc:	eb 05                	jmp    801044d3 <acquire+0x23>
801044ce:	66 90                	xchg   %ax,%ax
801044d0:	8b 5d 08             	mov    0x8(%ebp),%ebx
801044d3:	89 d0                	mov    %edx,%eax
801044d5:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
801044d8:	85 c0                	test   %eax,%eax
801044da:	75 f4                	jne    801044d0 <acquire+0x20>
  __sync_synchronize();
801044dc:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801044e1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801044e4:	e8 57 f3 ff ff       	call   80103840 <mycpu>
  ebp = (uint*)v - 2;
801044e9:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
801044eb:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
801044ee:	31 c0                	xor    %eax,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801044f0:	8d 8a 00 00 00 80    	lea    -0x80000000(%edx),%ecx
801044f6:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
801044fc:	77 22                	ja     80104520 <acquire+0x70>
    pcs[i] = ebp[1];     // saved %eip
801044fe:	8b 4a 04             	mov    0x4(%edx),%ecx
80104501:	89 4c 83 0c          	mov    %ecx,0xc(%ebx,%eax,4)
  for(i = 0; i < 10; i++){
80104505:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104508:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
8010450a:	83 f8 0a             	cmp    $0xa,%eax
8010450d:	75 e1                	jne    801044f0 <acquire+0x40>
}
8010450f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104512:	5b                   	pop    %ebx
80104513:	5e                   	pop    %esi
80104514:	5d                   	pop    %ebp
80104515:	c3                   	ret    
80104516:	8d 76 00             	lea    0x0(%esi),%esi
80104519:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104520:	8d 44 83 0c          	lea    0xc(%ebx,%eax,4),%eax
80104524:	83 c3 34             	add    $0x34,%ebx
80104527:	89 f6                	mov    %esi,%esi
80104529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
80104530:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104536:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104539:	39 c3                	cmp    %eax,%ebx
8010453b:	75 f3                	jne    80104530 <acquire+0x80>
}
8010453d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104540:	5b                   	pop    %ebx
80104541:	5e                   	pop    %esi
80104542:	5d                   	pop    %ebp
80104543:	c3                   	ret    
80104544:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return lock->locked && lock->cpu == mycpu();
80104548:	8b 73 08             	mov    0x8(%ebx),%esi
8010454b:	e8 f0 f2 ff ff       	call   80103840 <mycpu>
80104550:	39 c6                	cmp    %eax,%esi
80104552:	0f 85 6f ff ff ff    	jne    801044c7 <acquire+0x17>
    panic("acquire");
80104558:	83 ec 0c             	sub    $0xc,%esp
8010455b:	68 ff 76 10 80       	push   $0x801076ff
80104560:	e8 2b be ff ff       	call   80100390 <panic>
80104565:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104569:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104570 <popcli>:

void
popcli(void)
{
80104570:	55                   	push   %ebp
80104571:	89 e5                	mov    %esp,%ebp
80104573:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104576:	9c                   	pushf  
80104577:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104578:	f6 c4 02             	test   $0x2,%ah
8010457b:	75 35                	jne    801045b2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010457d:	e8 be f2 ff ff       	call   80103840 <mycpu>
80104582:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104589:	78 34                	js     801045bf <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010458b:	e8 b0 f2 ff ff       	call   80103840 <mycpu>
80104590:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104596:	85 d2                	test   %edx,%edx
80104598:	74 06                	je     801045a0 <popcli+0x30>
    sti();
}
8010459a:	c9                   	leave  
8010459b:	c3                   	ret    
8010459c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
801045a0:	e8 9b f2 ff ff       	call   80103840 <mycpu>
801045a5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801045ab:	85 c0                	test   %eax,%eax
801045ad:	74 eb                	je     8010459a <popcli+0x2a>
  asm volatile("sti");
801045af:	fb                   	sti    
}
801045b0:	c9                   	leave  
801045b1:	c3                   	ret    
    panic("popcli - interruptible");
801045b2:	83 ec 0c             	sub    $0xc,%esp
801045b5:	68 07 77 10 80       	push   $0x80107707
801045ba:	e8 d1 bd ff ff       	call   80100390 <panic>
    panic("popcli");
801045bf:	83 ec 0c             	sub    $0xc,%esp
801045c2:	68 1e 77 10 80       	push   $0x8010771e
801045c7:	e8 c4 bd ff ff       	call   80100390 <panic>
801045cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801045d0 <release>:
{
801045d0:	55                   	push   %ebp
801045d1:	89 e5                	mov    %esp,%ebp
801045d3:	56                   	push   %esi
801045d4:	53                   	push   %ebx
801045d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return lock->locked && lock->cpu == mycpu();
801045d8:	8b 03                	mov    (%ebx),%eax
801045da:	85 c0                	test   %eax,%eax
801045dc:	75 12                	jne    801045f0 <release+0x20>
    panic("release");
801045de:	83 ec 0c             	sub    $0xc,%esp
801045e1:	68 25 77 10 80       	push   $0x80107725
801045e6:	e8 a5 bd ff ff       	call   80100390 <panic>
801045eb:	90                   	nop
801045ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return lock->locked && lock->cpu == mycpu();
801045f0:	8b 73 08             	mov    0x8(%ebx),%esi
801045f3:	e8 48 f2 ff ff       	call   80103840 <mycpu>
801045f8:	39 c6                	cmp    %eax,%esi
801045fa:	75 e2                	jne    801045de <release+0xe>
  lk->pcs[0] = 0;
801045fc:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104603:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
8010460a:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010460f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104615:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104618:	5b                   	pop    %ebx
80104619:	5e                   	pop    %esi
8010461a:	5d                   	pop    %ebp
  popcli();
8010461b:	e9 50 ff ff ff       	jmp    80104570 <popcli>

80104620 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104620:	55                   	push   %ebp
80104621:	89 e5                	mov    %esp,%ebp
80104623:	57                   	push   %edi
80104624:	8b 55 08             	mov    0x8(%ebp),%edx
80104627:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010462a:	53                   	push   %ebx
  if ((int)dst%4 == 0 && n%4 == 0){
8010462b:	89 d0                	mov    %edx,%eax
8010462d:	09 c8                	or     %ecx,%eax
8010462f:	a8 03                	test   $0x3,%al
80104631:	75 2d                	jne    80104660 <memset+0x40>
    c &= 0xFF;
80104633:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104637:	c1 e9 02             	shr    $0x2,%ecx
8010463a:	89 f8                	mov    %edi,%eax
8010463c:	89 fb                	mov    %edi,%ebx
8010463e:	c1 e0 18             	shl    $0x18,%eax
80104641:	c1 e3 10             	shl    $0x10,%ebx
80104644:	09 d8                	or     %ebx,%eax
80104646:	09 f8                	or     %edi,%eax
80104648:	c1 e7 08             	shl    $0x8,%edi
8010464b:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
8010464d:	89 d7                	mov    %edx,%edi
8010464f:	fc                   	cld    
80104650:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104652:	5b                   	pop    %ebx
80104653:	89 d0                	mov    %edx,%eax
80104655:	5f                   	pop    %edi
80104656:	5d                   	pop    %ebp
80104657:	c3                   	ret    
80104658:	90                   	nop
80104659:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
80104660:	89 d7                	mov    %edx,%edi
80104662:	8b 45 0c             	mov    0xc(%ebp),%eax
80104665:	fc                   	cld    
80104666:	f3 aa                	rep stos %al,%es:(%edi)
80104668:	5b                   	pop    %ebx
80104669:	89 d0                	mov    %edx,%eax
8010466b:	5f                   	pop    %edi
8010466c:	5d                   	pop    %ebp
8010466d:	c3                   	ret    
8010466e:	66 90                	xchg   %ax,%ax

80104670 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104670:	55                   	push   %ebp
80104671:	89 e5                	mov    %esp,%ebp
80104673:	56                   	push   %esi
80104674:	8b 75 10             	mov    0x10(%ebp),%esi
80104677:	8b 45 08             	mov    0x8(%ebp),%eax
8010467a:	53                   	push   %ebx
8010467b:	8b 55 0c             	mov    0xc(%ebp),%edx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010467e:	85 f6                	test   %esi,%esi
80104680:	74 22                	je     801046a4 <memcmp+0x34>
    if(*s1 != *s2)
80104682:	0f b6 08             	movzbl (%eax),%ecx
80104685:	0f b6 1a             	movzbl (%edx),%ebx
80104688:	01 c6                	add    %eax,%esi
8010468a:	38 cb                	cmp    %cl,%bl
8010468c:	74 0c                	je     8010469a <memcmp+0x2a>
8010468e:	eb 20                	jmp    801046b0 <memcmp+0x40>
80104690:	0f b6 08             	movzbl (%eax),%ecx
80104693:	0f b6 1a             	movzbl (%edx),%ebx
80104696:	38 d9                	cmp    %bl,%cl
80104698:	75 16                	jne    801046b0 <memcmp+0x40>
      return *s1 - *s2;
    s1++, s2++;
8010469a:	83 c0 01             	add    $0x1,%eax
8010469d:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
801046a0:	39 c6                	cmp    %eax,%esi
801046a2:	75 ec                	jne    80104690 <memcmp+0x20>
  }

  return 0;
}
801046a4:	5b                   	pop    %ebx
  return 0;
801046a5:	31 c0                	xor    %eax,%eax
}
801046a7:	5e                   	pop    %esi
801046a8:	5d                   	pop    %ebp
801046a9:	c3                   	ret    
801046aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      return *s1 - *s2;
801046b0:	0f b6 c1             	movzbl %cl,%eax
801046b3:	29 d8                	sub    %ebx,%eax
}
801046b5:	5b                   	pop    %ebx
801046b6:	5e                   	pop    %esi
801046b7:	5d                   	pop    %ebp
801046b8:	c3                   	ret    
801046b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801046c0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801046c0:	55                   	push   %ebp
801046c1:	89 e5                	mov    %esp,%ebp
801046c3:	57                   	push   %edi
801046c4:	8b 45 08             	mov    0x8(%ebp),%eax
801046c7:	8b 4d 10             	mov    0x10(%ebp),%ecx
801046ca:	56                   	push   %esi
801046cb:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801046ce:	39 c6                	cmp    %eax,%esi
801046d0:	73 26                	jae    801046f8 <memmove+0x38>
801046d2:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
801046d5:	39 f8                	cmp    %edi,%eax
801046d7:	73 1f                	jae    801046f8 <memmove+0x38>
801046d9:	8d 51 ff             	lea    -0x1(%ecx),%edx
    s += n;
    d += n;
    while(n-- > 0)
801046dc:	85 c9                	test   %ecx,%ecx
801046de:	74 0f                	je     801046ef <memmove+0x2f>
      *--d = *--s;
801046e0:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
801046e4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
801046e7:	83 ea 01             	sub    $0x1,%edx
801046ea:	83 fa ff             	cmp    $0xffffffff,%edx
801046ed:	75 f1                	jne    801046e0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801046ef:	5e                   	pop    %esi
801046f0:	5f                   	pop    %edi
801046f1:	5d                   	pop    %ebp
801046f2:	c3                   	ret    
801046f3:	90                   	nop
801046f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046f8:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
    while(n-- > 0)
801046fb:	89 c7                	mov    %eax,%edi
801046fd:	85 c9                	test   %ecx,%ecx
801046ff:	74 ee                	je     801046ef <memmove+0x2f>
80104701:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104708:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104709:	39 d6                	cmp    %edx,%esi
8010470b:	75 fb                	jne    80104708 <memmove+0x48>
}
8010470d:	5e                   	pop    %esi
8010470e:	5f                   	pop    %edi
8010470f:	5d                   	pop    %ebp
80104710:	c3                   	ret    
80104711:	eb 0d                	jmp    80104720 <memcpy>
80104713:	90                   	nop
80104714:	90                   	nop
80104715:	90                   	nop
80104716:	90                   	nop
80104717:	90                   	nop
80104718:	90                   	nop
80104719:	90                   	nop
8010471a:	90                   	nop
8010471b:	90                   	nop
8010471c:	90                   	nop
8010471d:	90                   	nop
8010471e:	90                   	nop
8010471f:	90                   	nop

80104720 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104720:	eb 9e                	jmp    801046c0 <memmove>
80104722:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104730 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104730:	55                   	push   %ebp
80104731:	89 e5                	mov    %esp,%ebp
80104733:	57                   	push   %edi
80104734:	8b 7d 10             	mov    0x10(%ebp),%edi
80104737:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010473a:	56                   	push   %esi
8010473b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010473e:	53                   	push   %ebx
  while(n > 0 && *p && *p == *q)
8010473f:	85 ff                	test   %edi,%edi
80104741:	74 2f                	je     80104772 <strncmp+0x42>
80104743:	0f b6 11             	movzbl (%ecx),%edx
80104746:	0f b6 1e             	movzbl (%esi),%ebx
80104749:	84 d2                	test   %dl,%dl
8010474b:	74 37                	je     80104784 <strncmp+0x54>
8010474d:	38 da                	cmp    %bl,%dl
8010474f:	75 33                	jne    80104784 <strncmp+0x54>
80104751:	01 f7                	add    %esi,%edi
80104753:	eb 13                	jmp    80104768 <strncmp+0x38>
80104755:	8d 76 00             	lea    0x0(%esi),%esi
80104758:	0f b6 11             	movzbl (%ecx),%edx
8010475b:	84 d2                	test   %dl,%dl
8010475d:	74 21                	je     80104780 <strncmp+0x50>
8010475f:	0f b6 18             	movzbl (%eax),%ebx
80104762:	89 c6                	mov    %eax,%esi
80104764:	38 da                	cmp    %bl,%dl
80104766:	75 1c                	jne    80104784 <strncmp+0x54>
    n--, p++, q++;
80104768:	8d 46 01             	lea    0x1(%esi),%eax
8010476b:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010476e:	39 f8                	cmp    %edi,%eax
80104770:	75 e6                	jne    80104758 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104772:	5b                   	pop    %ebx
    return 0;
80104773:	31 c0                	xor    %eax,%eax
}
80104775:	5e                   	pop    %esi
80104776:	5f                   	pop    %edi
80104777:	5d                   	pop    %ebp
80104778:	c3                   	ret    
80104779:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104780:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80104784:	0f b6 c2             	movzbl %dl,%eax
80104787:	29 d8                	sub    %ebx,%eax
}
80104789:	5b                   	pop    %ebx
8010478a:	5e                   	pop    %esi
8010478b:	5f                   	pop    %edi
8010478c:	5d                   	pop    %ebp
8010478d:	c3                   	ret    
8010478e:	66 90                	xchg   %ax,%ax

80104790 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104790:	55                   	push   %ebp
80104791:	89 e5                	mov    %esp,%ebp
80104793:	57                   	push   %edi
80104794:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104797:	8b 4d 08             	mov    0x8(%ebp),%ecx
{
8010479a:	56                   	push   %esi
8010479b:	53                   	push   %ebx
8010479c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  while(n-- > 0 && (*s++ = *t++) != 0)
8010479f:	eb 1a                	jmp    801047bb <strncpy+0x2b>
801047a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047a8:	83 c2 01             	add    $0x1,%edx
801047ab:	0f b6 42 ff          	movzbl -0x1(%edx),%eax
801047af:	83 c1 01             	add    $0x1,%ecx
801047b2:	88 41 ff             	mov    %al,-0x1(%ecx)
801047b5:	84 c0                	test   %al,%al
801047b7:	74 09                	je     801047c2 <strncpy+0x32>
801047b9:	89 fb                	mov    %edi,%ebx
801047bb:	8d 7b ff             	lea    -0x1(%ebx),%edi
801047be:	85 db                	test   %ebx,%ebx
801047c0:	7f e6                	jg     801047a8 <strncpy+0x18>
    ;
  while(n-- > 0)
801047c2:	89 ce                	mov    %ecx,%esi
801047c4:	85 ff                	test   %edi,%edi
801047c6:	7e 1b                	jle    801047e3 <strncpy+0x53>
801047c8:	90                   	nop
801047c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
801047d0:	83 c6 01             	add    $0x1,%esi
801047d3:	c6 46 ff 00          	movb   $0x0,-0x1(%esi)
801047d7:	89 f2                	mov    %esi,%edx
801047d9:	f7 d2                	not    %edx
801047db:	01 ca                	add    %ecx,%edx
801047dd:	01 da                	add    %ebx,%edx
  while(n-- > 0)
801047df:	85 d2                	test   %edx,%edx
801047e1:	7f ed                	jg     801047d0 <strncpy+0x40>
  return os;
}
801047e3:	5b                   	pop    %ebx
801047e4:	8b 45 08             	mov    0x8(%ebp),%eax
801047e7:	5e                   	pop    %esi
801047e8:	5f                   	pop    %edi
801047e9:	5d                   	pop    %ebp
801047ea:	c3                   	ret    
801047eb:	90                   	nop
801047ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801047f0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801047f0:	55                   	push   %ebp
801047f1:	89 e5                	mov    %esp,%ebp
801047f3:	56                   	push   %esi
801047f4:	8b 4d 10             	mov    0x10(%ebp),%ecx
801047f7:	8b 45 08             	mov    0x8(%ebp),%eax
801047fa:	53                   	push   %ebx
801047fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
801047fe:	85 c9                	test   %ecx,%ecx
80104800:	7e 26                	jle    80104828 <safestrcpy+0x38>
80104802:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104806:	89 c1                	mov    %eax,%ecx
80104808:	eb 17                	jmp    80104821 <safestrcpy+0x31>
8010480a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104810:	83 c2 01             	add    $0x1,%edx
80104813:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104817:	83 c1 01             	add    $0x1,%ecx
8010481a:	88 59 ff             	mov    %bl,-0x1(%ecx)
8010481d:	84 db                	test   %bl,%bl
8010481f:	74 04                	je     80104825 <safestrcpy+0x35>
80104821:	39 f2                	cmp    %esi,%edx
80104823:	75 eb                	jne    80104810 <safestrcpy+0x20>
    ;
  *s = 0;
80104825:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104828:	5b                   	pop    %ebx
80104829:	5e                   	pop    %esi
8010482a:	5d                   	pop    %ebp
8010482b:	c3                   	ret    
8010482c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104830 <strlen>:

int
strlen(const char *s)
{
80104830:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104831:	31 c0                	xor    %eax,%eax
{
80104833:	89 e5                	mov    %esp,%ebp
80104835:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104838:	80 3a 00             	cmpb   $0x0,(%edx)
8010483b:	74 0c                	je     80104849 <strlen+0x19>
8010483d:	8d 76 00             	lea    0x0(%esi),%esi
80104840:	83 c0 01             	add    $0x1,%eax
80104843:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104847:	75 f7                	jne    80104840 <strlen+0x10>
    ;
  return n;
}
80104849:	5d                   	pop    %ebp
8010484a:	c3                   	ret    

8010484b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010484b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010484f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80104853:	55                   	push   %ebp
  pushl %ebx
80104854:	53                   	push   %ebx
  pushl %esi
80104855:	56                   	push   %esi
  pushl %edi
80104856:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104857:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104859:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
8010485b:	5f                   	pop    %edi
  popl %esi
8010485c:	5e                   	pop    %esi
  popl %ebx
8010485d:	5b                   	pop    %ebx
  popl %ebp
8010485e:	5d                   	pop    %ebp
  ret
8010485f:	c3                   	ret    

80104860 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104860:	55                   	push   %ebp
80104861:	89 e5                	mov    %esp,%ebp
80104863:	53                   	push   %ebx
80104864:	83 ec 04             	sub    $0x4,%esp
80104867:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010486a:	e8 71 f0 ff ff       	call   801038e0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010486f:	8b 00                	mov    (%eax),%eax
80104871:	39 d8                	cmp    %ebx,%eax
80104873:	76 1b                	jbe    80104890 <fetchint+0x30>
80104875:	8d 53 04             	lea    0x4(%ebx),%edx
80104878:	39 d0                	cmp    %edx,%eax
8010487a:	72 14                	jb     80104890 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
8010487c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010487f:	8b 13                	mov    (%ebx),%edx
80104881:	89 10                	mov    %edx,(%eax)
  return 0;
80104883:	31 c0                	xor    %eax,%eax
}
80104885:	83 c4 04             	add    $0x4,%esp
80104888:	5b                   	pop    %ebx
80104889:	5d                   	pop    %ebp
8010488a:	c3                   	ret    
8010488b:	90                   	nop
8010488c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104890:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104895:	eb ee                	jmp    80104885 <fetchint+0x25>
80104897:	89 f6                	mov    %esi,%esi
80104899:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801048a0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801048a0:	55                   	push   %ebp
801048a1:	89 e5                	mov    %esp,%ebp
801048a3:	53                   	push   %ebx
801048a4:	83 ec 04             	sub    $0x4,%esp
801048a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
801048aa:	e8 31 f0 ff ff       	call   801038e0 <myproc>

  if(addr >= curproc->sz)
801048af:	39 18                	cmp    %ebx,(%eax)
801048b1:	76 29                	jbe    801048dc <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
801048b3:	8b 55 0c             	mov    0xc(%ebp),%edx
801048b6:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
801048b8:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
801048ba:	39 d3                	cmp    %edx,%ebx
801048bc:	73 1e                	jae    801048dc <fetchstr+0x3c>
    if(*s == 0)
801048be:	80 3b 00             	cmpb   $0x0,(%ebx)
801048c1:	74 35                	je     801048f8 <fetchstr+0x58>
801048c3:	89 d8                	mov    %ebx,%eax
801048c5:	eb 0e                	jmp    801048d5 <fetchstr+0x35>
801048c7:	89 f6                	mov    %esi,%esi
801048c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801048d0:	80 38 00             	cmpb   $0x0,(%eax)
801048d3:	74 1b                	je     801048f0 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
801048d5:	83 c0 01             	add    $0x1,%eax
801048d8:	39 c2                	cmp    %eax,%edx
801048da:	77 f4                	ja     801048d0 <fetchstr+0x30>
    return -1;
801048dc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
801048e1:	83 c4 04             	add    $0x4,%esp
801048e4:	5b                   	pop    %ebx
801048e5:	5d                   	pop    %ebp
801048e6:	c3                   	ret    
801048e7:	89 f6                	mov    %esi,%esi
801048e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801048f0:	83 c4 04             	add    $0x4,%esp
801048f3:	29 d8                	sub    %ebx,%eax
801048f5:	5b                   	pop    %ebx
801048f6:	5d                   	pop    %ebp
801048f7:	c3                   	ret    
    if(*s == 0)
801048f8:	31 c0                	xor    %eax,%eax
      return s - *pp;
801048fa:	eb e5                	jmp    801048e1 <fetchstr+0x41>
801048fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104900 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104900:	55                   	push   %ebp
80104901:	89 e5                	mov    %esp,%ebp
80104903:	56                   	push   %esi
80104904:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104905:	e8 d6 ef ff ff       	call   801038e0 <myproc>
8010490a:	8b 55 08             	mov    0x8(%ebp),%edx
8010490d:	8b 40 18             	mov    0x18(%eax),%eax
80104910:	8b 40 44             	mov    0x44(%eax),%eax
80104913:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104916:	e8 c5 ef ff ff       	call   801038e0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010491b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010491e:	8b 00                	mov    (%eax),%eax
80104920:	39 c6                	cmp    %eax,%esi
80104922:	73 1c                	jae    80104940 <argint+0x40>
80104924:	8d 53 08             	lea    0x8(%ebx),%edx
80104927:	39 d0                	cmp    %edx,%eax
80104929:	72 15                	jb     80104940 <argint+0x40>
  *ip = *(int*)(addr);
8010492b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010492e:	8b 53 04             	mov    0x4(%ebx),%edx
80104931:	89 10                	mov    %edx,(%eax)
  return 0;
80104933:	31 c0                	xor    %eax,%eax
}
80104935:	5b                   	pop    %ebx
80104936:	5e                   	pop    %esi
80104937:	5d                   	pop    %ebp
80104938:	c3                   	ret    
80104939:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104940:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104945:	eb ee                	jmp    80104935 <argint+0x35>
80104947:	89 f6                	mov    %esi,%esi
80104949:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104950 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104950:	55                   	push   %ebp
80104951:	89 e5                	mov    %esp,%ebp
80104953:	56                   	push   %esi
80104954:	53                   	push   %ebx
80104955:	83 ec 10             	sub    $0x10,%esp
80104958:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010495b:	e8 80 ef ff ff       	call   801038e0 <myproc>
 
  if(argint(n, &i) < 0)
80104960:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
80104963:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
80104965:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104968:	50                   	push   %eax
80104969:	ff 75 08             	pushl  0x8(%ebp)
8010496c:	e8 8f ff ff ff       	call   80104900 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104971:	83 c4 10             	add    $0x10,%esp
80104974:	85 c0                	test   %eax,%eax
80104976:	78 28                	js     801049a0 <argptr+0x50>
80104978:	85 db                	test   %ebx,%ebx
8010497a:	78 24                	js     801049a0 <argptr+0x50>
8010497c:	8b 16                	mov    (%esi),%edx
8010497e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104981:	39 c2                	cmp    %eax,%edx
80104983:	76 1b                	jbe    801049a0 <argptr+0x50>
80104985:	01 c3                	add    %eax,%ebx
80104987:	39 da                	cmp    %ebx,%edx
80104989:	72 15                	jb     801049a0 <argptr+0x50>
    return -1;
  *pp = (char*)i;
8010498b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010498e:	89 02                	mov    %eax,(%edx)
  return 0;
80104990:	31 c0                	xor    %eax,%eax
}
80104992:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104995:	5b                   	pop    %ebx
80104996:	5e                   	pop    %esi
80104997:	5d                   	pop    %ebp
80104998:	c3                   	ret    
80104999:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801049a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801049a5:	eb eb                	jmp    80104992 <argptr+0x42>
801049a7:	89 f6                	mov    %esi,%esi
801049a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801049b0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801049b0:	55                   	push   %ebp
801049b1:	89 e5                	mov    %esp,%ebp
801049b3:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
801049b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801049b9:	50                   	push   %eax
801049ba:	ff 75 08             	pushl  0x8(%ebp)
801049bd:	e8 3e ff ff ff       	call   80104900 <argint>
801049c2:	83 c4 10             	add    $0x10,%esp
801049c5:	85 c0                	test   %eax,%eax
801049c7:	78 17                	js     801049e0 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
801049c9:	83 ec 08             	sub    $0x8,%esp
801049cc:	ff 75 0c             	pushl  0xc(%ebp)
801049cf:	ff 75 f4             	pushl  -0xc(%ebp)
801049d2:	e8 c9 fe ff ff       	call   801048a0 <fetchstr>
801049d7:	83 c4 10             	add    $0x10,%esp
}
801049da:	c9                   	leave  
801049db:	c3                   	ret    
801049dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801049e0:	c9                   	leave  
    return -1;
801049e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801049e6:	c3                   	ret    
801049e7:	89 f6                	mov    %esi,%esi
801049e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801049f0 <syscall>:
[SYS_cps]     sys_cps,
};

void
syscall(void)
{
801049f0:	55                   	push   %ebp
801049f1:	89 e5                	mov    %esp,%ebp
801049f3:	53                   	push   %ebx
801049f4:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
801049f7:	e8 e4 ee ff ff       	call   801038e0 <myproc>
801049fc:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
801049fe:	8b 40 18             	mov    0x18(%eax),%eax
80104a01:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104a04:	8d 50 ff             	lea    -0x1(%eax),%edx
80104a07:	83 fa 15             	cmp    $0x15,%edx
80104a0a:	77 1c                	ja     80104a28 <syscall+0x38>
80104a0c:	8b 14 85 60 77 10 80 	mov    -0x7fef88a0(,%eax,4),%edx
80104a13:	85 d2                	test   %edx,%edx
80104a15:	74 11                	je     80104a28 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80104a17:	ff d2                	call   *%edx
80104a19:	8b 53 18             	mov    0x18(%ebx),%edx
80104a1c:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104a1f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a22:	c9                   	leave  
80104a23:	c3                   	ret    
80104a24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104a28:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104a29:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104a2c:	50                   	push   %eax
80104a2d:	ff 73 10             	pushl  0x10(%ebx)
80104a30:	68 2d 77 10 80       	push   $0x8010772d
80104a35:	e8 76 bc ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
80104a3a:	8b 43 18             	mov    0x18(%ebx),%eax
80104a3d:	83 c4 10             	add    $0x10,%esp
80104a40:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104a47:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a4a:	c9                   	leave  
80104a4b:	c3                   	ret    
80104a4c:	66 90                	xchg   %ax,%ax
80104a4e:	66 90                	xchg   %ax,%ax

80104a50 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104a50:	55                   	push   %ebp
80104a51:	89 e5                	mov    %esp,%ebp
80104a53:	57                   	push   %edi
80104a54:	56                   	push   %esi
80104a55:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104a56:	8d 5d da             	lea    -0x26(%ebp),%ebx
{
80104a59:	83 ec 44             	sub    $0x44,%esp
80104a5c:	89 4d c0             	mov    %ecx,-0x40(%ebp)
80104a5f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104a62:	53                   	push   %ebx
80104a63:	50                   	push   %eax
{
80104a64:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80104a67:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104a6a:	e8 71 d5 ff ff       	call   80101fe0 <nameiparent>
80104a6f:	83 c4 10             	add    $0x10,%esp
80104a72:	85 c0                	test   %eax,%eax
80104a74:	0f 84 46 01 00 00    	je     80104bc0 <create+0x170>
    return 0;
  ilock(dp);
80104a7a:	83 ec 0c             	sub    $0xc,%esp
80104a7d:	89 c6                	mov    %eax,%esi
80104a7f:	50                   	push   %eax
80104a80:	e8 9b cc ff ff       	call   80101720 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104a85:	83 c4 0c             	add    $0xc,%esp
80104a88:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104a8b:	50                   	push   %eax
80104a8c:	53                   	push   %ebx
80104a8d:	56                   	push   %esi
80104a8e:	e8 bd d1 ff ff       	call   80101c50 <dirlookup>
80104a93:	83 c4 10             	add    $0x10,%esp
80104a96:	89 c7                	mov    %eax,%edi
80104a98:	85 c0                	test   %eax,%eax
80104a9a:	74 54                	je     80104af0 <create+0xa0>
    iunlockput(dp);
80104a9c:	83 ec 0c             	sub    $0xc,%esp
80104a9f:	56                   	push   %esi
80104aa0:	e8 0b cf ff ff       	call   801019b0 <iunlockput>
    ilock(ip);
80104aa5:	89 3c 24             	mov    %edi,(%esp)
80104aa8:	e8 73 cc ff ff       	call   80101720 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104aad:	83 c4 10             	add    $0x10,%esp
80104ab0:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104ab5:	75 19                	jne    80104ad0 <create+0x80>
80104ab7:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80104abc:	75 12                	jne    80104ad0 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104abe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ac1:	89 f8                	mov    %edi,%eax
80104ac3:	5b                   	pop    %ebx
80104ac4:	5e                   	pop    %esi
80104ac5:	5f                   	pop    %edi
80104ac6:	5d                   	pop    %ebp
80104ac7:	c3                   	ret    
80104ac8:	90                   	nop
80104ac9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    iunlockput(ip);
80104ad0:	83 ec 0c             	sub    $0xc,%esp
80104ad3:	57                   	push   %edi
    return 0;
80104ad4:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80104ad6:	e8 d5 ce ff ff       	call   801019b0 <iunlockput>
    return 0;
80104adb:	83 c4 10             	add    $0x10,%esp
}
80104ade:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ae1:	89 f8                	mov    %edi,%eax
80104ae3:	5b                   	pop    %ebx
80104ae4:	5e                   	pop    %esi
80104ae5:	5f                   	pop    %edi
80104ae6:	5d                   	pop    %ebp
80104ae7:	c3                   	ret    
80104ae8:	90                   	nop
80104ae9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if((ip = ialloc(dp->dev, type)) == 0)
80104af0:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80104af4:	83 ec 08             	sub    $0x8,%esp
80104af7:	50                   	push   %eax
80104af8:	ff 36                	pushl  (%esi)
80104afa:	e8 b1 ca ff ff       	call   801015b0 <ialloc>
80104aff:	83 c4 10             	add    $0x10,%esp
80104b02:	89 c7                	mov    %eax,%edi
80104b04:	85 c0                	test   %eax,%eax
80104b06:	0f 84 cd 00 00 00    	je     80104bd9 <create+0x189>
  ilock(ip);
80104b0c:	83 ec 0c             	sub    $0xc,%esp
80104b0f:	50                   	push   %eax
80104b10:	e8 0b cc ff ff       	call   80101720 <ilock>
  ip->major = major;
80104b15:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80104b19:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
80104b1d:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80104b21:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80104b25:	b8 01 00 00 00       	mov    $0x1,%eax
80104b2a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
80104b2e:	89 3c 24             	mov    %edi,(%esp)
80104b31:	e8 3a cb ff ff       	call   80101670 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104b36:	83 c4 10             	add    $0x10,%esp
80104b39:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
80104b3e:	74 30                	je     80104b70 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104b40:	83 ec 04             	sub    $0x4,%esp
80104b43:	ff 77 04             	pushl  0x4(%edi)
80104b46:	53                   	push   %ebx
80104b47:	56                   	push   %esi
80104b48:	e8 b3 d3 ff ff       	call   80101f00 <dirlink>
80104b4d:	83 c4 10             	add    $0x10,%esp
80104b50:	85 c0                	test   %eax,%eax
80104b52:	78 78                	js     80104bcc <create+0x17c>
  iunlockput(dp);
80104b54:	83 ec 0c             	sub    $0xc,%esp
80104b57:	56                   	push   %esi
80104b58:	e8 53 ce ff ff       	call   801019b0 <iunlockput>
  return ip;
80104b5d:	83 c4 10             	add    $0x10,%esp
}
80104b60:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b63:	89 f8                	mov    %edi,%eax
80104b65:	5b                   	pop    %ebx
80104b66:	5e                   	pop    %esi
80104b67:	5f                   	pop    %edi
80104b68:	5d                   	pop    %ebp
80104b69:	c3                   	ret    
80104b6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104b70:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104b73:	66 83 46 56 01       	addw   $0x1,0x56(%esi)
    iupdate(dp);
80104b78:	56                   	push   %esi
80104b79:	e8 f2 ca ff ff       	call   80101670 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104b7e:	83 c4 0c             	add    $0xc,%esp
80104b81:	ff 77 04             	pushl  0x4(%edi)
80104b84:	68 d8 77 10 80       	push   $0x801077d8
80104b89:	57                   	push   %edi
80104b8a:	e8 71 d3 ff ff       	call   80101f00 <dirlink>
80104b8f:	83 c4 10             	add    $0x10,%esp
80104b92:	85 c0                	test   %eax,%eax
80104b94:	78 18                	js     80104bae <create+0x15e>
80104b96:	83 ec 04             	sub    $0x4,%esp
80104b99:	ff 76 04             	pushl  0x4(%esi)
80104b9c:	68 d7 77 10 80       	push   $0x801077d7
80104ba1:	57                   	push   %edi
80104ba2:	e8 59 d3 ff ff       	call   80101f00 <dirlink>
80104ba7:	83 c4 10             	add    $0x10,%esp
80104baa:	85 c0                	test   %eax,%eax
80104bac:	79 92                	jns    80104b40 <create+0xf0>
      panic("create dots");
80104bae:	83 ec 0c             	sub    $0xc,%esp
80104bb1:	68 cb 77 10 80       	push   $0x801077cb
80104bb6:	e8 d5 b7 ff ff       	call   80100390 <panic>
80104bbb:	90                   	nop
80104bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}
80104bc0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104bc3:	31 ff                	xor    %edi,%edi
}
80104bc5:	5b                   	pop    %ebx
80104bc6:	89 f8                	mov    %edi,%eax
80104bc8:	5e                   	pop    %esi
80104bc9:	5f                   	pop    %edi
80104bca:	5d                   	pop    %ebp
80104bcb:	c3                   	ret    
    panic("create: dirlink");
80104bcc:	83 ec 0c             	sub    $0xc,%esp
80104bcf:	68 da 77 10 80       	push   $0x801077da
80104bd4:	e8 b7 b7 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80104bd9:	83 ec 0c             	sub    $0xc,%esp
80104bdc:	68 bc 77 10 80       	push   $0x801077bc
80104be1:	e8 aa b7 ff ff       	call   80100390 <panic>
80104be6:	8d 76 00             	lea    0x0(%esi),%esi
80104be9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104bf0 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80104bf0:	55                   	push   %ebp
80104bf1:	89 e5                	mov    %esp,%ebp
80104bf3:	56                   	push   %esi
80104bf4:	89 d6                	mov    %edx,%esi
80104bf6:	53                   	push   %ebx
80104bf7:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80104bf9:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80104bfc:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104bff:	50                   	push   %eax
80104c00:	6a 00                	push   $0x0
80104c02:	e8 f9 fc ff ff       	call   80104900 <argint>
80104c07:	83 c4 10             	add    $0x10,%esp
80104c0a:	85 c0                	test   %eax,%eax
80104c0c:	78 2a                	js     80104c38 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104c0e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104c12:	77 24                	ja     80104c38 <argfd.constprop.0+0x48>
80104c14:	e8 c7 ec ff ff       	call   801038e0 <myproc>
80104c19:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104c1c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104c20:	85 c0                	test   %eax,%eax
80104c22:	74 14                	je     80104c38 <argfd.constprop.0+0x48>
  if(pfd)
80104c24:	85 db                	test   %ebx,%ebx
80104c26:	74 02                	je     80104c2a <argfd.constprop.0+0x3a>
    *pfd = fd;
80104c28:	89 13                	mov    %edx,(%ebx)
    *pf = f;
80104c2a:	89 06                	mov    %eax,(%esi)
  return 0;
80104c2c:	31 c0                	xor    %eax,%eax
}
80104c2e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c31:	5b                   	pop    %ebx
80104c32:	5e                   	pop    %esi
80104c33:	5d                   	pop    %ebp
80104c34:	c3                   	ret    
80104c35:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104c38:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c3d:	eb ef                	jmp    80104c2e <argfd.constprop.0+0x3e>
80104c3f:	90                   	nop

80104c40 <sys_dup>:
{
80104c40:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80104c41:	31 c0                	xor    %eax,%eax
{
80104c43:	89 e5                	mov    %esp,%ebp
80104c45:	56                   	push   %esi
80104c46:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80104c47:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80104c4a:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80104c4d:	e8 9e ff ff ff       	call   80104bf0 <argfd.constprop.0>
80104c52:	85 c0                	test   %eax,%eax
80104c54:	78 1a                	js     80104c70 <sys_dup+0x30>
  if((fd=fdalloc(f)) < 0)
80104c56:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104c59:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80104c5b:	e8 80 ec ff ff       	call   801038e0 <myproc>
    if(curproc->ofile[fd] == 0){
80104c60:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104c64:	85 d2                	test   %edx,%edx
80104c66:	74 18                	je     80104c80 <sys_dup+0x40>
  for(fd = 0; fd < NOFILE; fd++){
80104c68:	83 c3 01             	add    $0x1,%ebx
80104c6b:	83 fb 10             	cmp    $0x10,%ebx
80104c6e:	75 f0                	jne    80104c60 <sys_dup+0x20>
}
80104c70:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104c73:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104c78:	89 d8                	mov    %ebx,%eax
80104c7a:	5b                   	pop    %ebx
80104c7b:	5e                   	pop    %esi
80104c7c:	5d                   	pop    %ebp
80104c7d:	c3                   	ret    
80104c7e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80104c80:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104c84:	83 ec 0c             	sub    $0xc,%esp
80104c87:	ff 75 f4             	pushl  -0xc(%ebp)
80104c8a:	e8 e1 c1 ff ff       	call   80100e70 <filedup>
  return fd;
80104c8f:	83 c4 10             	add    $0x10,%esp
}
80104c92:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c95:	89 d8                	mov    %ebx,%eax
80104c97:	5b                   	pop    %ebx
80104c98:	5e                   	pop    %esi
80104c99:	5d                   	pop    %ebp
80104c9a:	c3                   	ret    
80104c9b:	90                   	nop
80104c9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104ca0 <sys_read>:
{
80104ca0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104ca1:	31 c0                	xor    %eax,%eax
{
80104ca3:	89 e5                	mov    %esp,%ebp
80104ca5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104ca8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104cab:	e8 40 ff ff ff       	call   80104bf0 <argfd.constprop.0>
80104cb0:	85 c0                	test   %eax,%eax
80104cb2:	78 4c                	js     80104d00 <sys_read+0x60>
80104cb4:	83 ec 08             	sub    $0x8,%esp
80104cb7:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104cba:	50                   	push   %eax
80104cbb:	6a 02                	push   $0x2
80104cbd:	e8 3e fc ff ff       	call   80104900 <argint>
80104cc2:	83 c4 10             	add    $0x10,%esp
80104cc5:	85 c0                	test   %eax,%eax
80104cc7:	78 37                	js     80104d00 <sys_read+0x60>
80104cc9:	83 ec 04             	sub    $0x4,%esp
80104ccc:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ccf:	ff 75 f0             	pushl  -0x10(%ebp)
80104cd2:	50                   	push   %eax
80104cd3:	6a 01                	push   $0x1
80104cd5:	e8 76 fc ff ff       	call   80104950 <argptr>
80104cda:	83 c4 10             	add    $0x10,%esp
80104cdd:	85 c0                	test   %eax,%eax
80104cdf:	78 1f                	js     80104d00 <sys_read+0x60>
  return fileread(f, p, n);
80104ce1:	83 ec 04             	sub    $0x4,%esp
80104ce4:	ff 75 f0             	pushl  -0x10(%ebp)
80104ce7:	ff 75 f4             	pushl  -0xc(%ebp)
80104cea:	ff 75 ec             	pushl  -0x14(%ebp)
80104ced:	e8 fe c2 ff ff       	call   80100ff0 <fileread>
80104cf2:	83 c4 10             	add    $0x10,%esp
}
80104cf5:	c9                   	leave  
80104cf6:	c3                   	ret    
80104cf7:	89 f6                	mov    %esi,%esi
80104cf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104d00:	c9                   	leave  
    return -1;
80104d01:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d06:	c3                   	ret    
80104d07:	89 f6                	mov    %esi,%esi
80104d09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d10 <sys_write>:
{
80104d10:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104d11:	31 c0                	xor    %eax,%eax
{
80104d13:	89 e5                	mov    %esp,%ebp
80104d15:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104d18:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104d1b:	e8 d0 fe ff ff       	call   80104bf0 <argfd.constprop.0>
80104d20:	85 c0                	test   %eax,%eax
80104d22:	78 4c                	js     80104d70 <sys_write+0x60>
80104d24:	83 ec 08             	sub    $0x8,%esp
80104d27:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104d2a:	50                   	push   %eax
80104d2b:	6a 02                	push   $0x2
80104d2d:	e8 ce fb ff ff       	call   80104900 <argint>
80104d32:	83 c4 10             	add    $0x10,%esp
80104d35:	85 c0                	test   %eax,%eax
80104d37:	78 37                	js     80104d70 <sys_write+0x60>
80104d39:	83 ec 04             	sub    $0x4,%esp
80104d3c:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d3f:	ff 75 f0             	pushl  -0x10(%ebp)
80104d42:	50                   	push   %eax
80104d43:	6a 01                	push   $0x1
80104d45:	e8 06 fc ff ff       	call   80104950 <argptr>
80104d4a:	83 c4 10             	add    $0x10,%esp
80104d4d:	85 c0                	test   %eax,%eax
80104d4f:	78 1f                	js     80104d70 <sys_write+0x60>
  return filewrite(f, p, n);
80104d51:	83 ec 04             	sub    $0x4,%esp
80104d54:	ff 75 f0             	pushl  -0x10(%ebp)
80104d57:	ff 75 f4             	pushl  -0xc(%ebp)
80104d5a:	ff 75 ec             	pushl  -0x14(%ebp)
80104d5d:	e8 1e c3 ff ff       	call   80101080 <filewrite>
80104d62:	83 c4 10             	add    $0x10,%esp
}
80104d65:	c9                   	leave  
80104d66:	c3                   	ret    
80104d67:	89 f6                	mov    %esi,%esi
80104d69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104d70:	c9                   	leave  
    return -1;
80104d71:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d76:	c3                   	ret    
80104d77:	89 f6                	mov    %esi,%esi
80104d79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d80 <sys_close>:
{
80104d80:	55                   	push   %ebp
80104d81:	89 e5                	mov    %esp,%ebp
80104d83:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80104d86:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104d89:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104d8c:	e8 5f fe ff ff       	call   80104bf0 <argfd.constprop.0>
80104d91:	85 c0                	test   %eax,%eax
80104d93:	78 2b                	js     80104dc0 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80104d95:	e8 46 eb ff ff       	call   801038e0 <myproc>
80104d9a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80104d9d:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80104da0:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104da7:	00 
  fileclose(f);
80104da8:	ff 75 f4             	pushl  -0xc(%ebp)
80104dab:	e8 10 c1 ff ff       	call   80100ec0 <fileclose>
  return 0;
80104db0:	83 c4 10             	add    $0x10,%esp
80104db3:	31 c0                	xor    %eax,%eax
}
80104db5:	c9                   	leave  
80104db6:	c3                   	ret    
80104db7:	89 f6                	mov    %esi,%esi
80104db9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104dc0:	c9                   	leave  
    return -1;
80104dc1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104dc6:	c3                   	ret    
80104dc7:	89 f6                	mov    %esi,%esi
80104dc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104dd0 <sys_fstat>:
{
80104dd0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104dd1:	31 c0                	xor    %eax,%eax
{
80104dd3:	89 e5                	mov    %esp,%ebp
80104dd5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104dd8:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104ddb:	e8 10 fe ff ff       	call   80104bf0 <argfd.constprop.0>
80104de0:	85 c0                	test   %eax,%eax
80104de2:	78 2c                	js     80104e10 <sys_fstat+0x40>
80104de4:	83 ec 04             	sub    $0x4,%esp
80104de7:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104dea:	6a 14                	push   $0x14
80104dec:	50                   	push   %eax
80104ded:	6a 01                	push   $0x1
80104def:	e8 5c fb ff ff       	call   80104950 <argptr>
80104df4:	83 c4 10             	add    $0x10,%esp
80104df7:	85 c0                	test   %eax,%eax
80104df9:	78 15                	js     80104e10 <sys_fstat+0x40>
  return filestat(f, st);
80104dfb:	83 ec 08             	sub    $0x8,%esp
80104dfe:	ff 75 f4             	pushl  -0xc(%ebp)
80104e01:	ff 75 f0             	pushl  -0x10(%ebp)
80104e04:	e8 97 c1 ff ff       	call   80100fa0 <filestat>
80104e09:	83 c4 10             	add    $0x10,%esp
}
80104e0c:	c9                   	leave  
80104e0d:	c3                   	ret    
80104e0e:	66 90                	xchg   %ax,%ax
80104e10:	c9                   	leave  
    return -1;
80104e11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e16:	c3                   	ret    
80104e17:	89 f6                	mov    %esi,%esi
80104e19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e20 <sys_link>:
{
80104e20:	55                   	push   %ebp
80104e21:	89 e5                	mov    %esp,%ebp
80104e23:	57                   	push   %edi
80104e24:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104e25:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80104e28:	53                   	push   %ebx
80104e29:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104e2c:	50                   	push   %eax
80104e2d:	6a 00                	push   $0x0
80104e2f:	e8 7c fb ff ff       	call   801049b0 <argstr>
80104e34:	83 c4 10             	add    $0x10,%esp
80104e37:	85 c0                	test   %eax,%eax
80104e39:	0f 88 fb 00 00 00    	js     80104f3a <sys_link+0x11a>
80104e3f:	83 ec 08             	sub    $0x8,%esp
80104e42:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104e45:	50                   	push   %eax
80104e46:	6a 01                	push   $0x1
80104e48:	e8 63 fb ff ff       	call   801049b0 <argstr>
80104e4d:	83 c4 10             	add    $0x10,%esp
80104e50:	85 c0                	test   %eax,%eax
80104e52:	0f 88 e2 00 00 00    	js     80104f3a <sys_link+0x11a>
  begin_op();
80104e58:	e8 43 de ff ff       	call   80102ca0 <begin_op>
  if((ip = namei(old)) == 0){
80104e5d:	83 ec 0c             	sub    $0xc,%esp
80104e60:	ff 75 d4             	pushl  -0x2c(%ebp)
80104e63:	e8 58 d1 ff ff       	call   80101fc0 <namei>
80104e68:	83 c4 10             	add    $0x10,%esp
80104e6b:	89 c3                	mov    %eax,%ebx
80104e6d:	85 c0                	test   %eax,%eax
80104e6f:	0f 84 e4 00 00 00    	je     80104f59 <sys_link+0x139>
  ilock(ip);
80104e75:	83 ec 0c             	sub    $0xc,%esp
80104e78:	50                   	push   %eax
80104e79:	e8 a2 c8 ff ff       	call   80101720 <ilock>
  if(ip->type == T_DIR){
80104e7e:	83 c4 10             	add    $0x10,%esp
80104e81:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104e86:	0f 84 b5 00 00 00    	je     80104f41 <sys_link+0x121>
  iupdate(ip);
80104e8c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80104e8f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80104e94:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80104e97:	53                   	push   %ebx
80104e98:	e8 d3 c7 ff ff       	call   80101670 <iupdate>
  iunlock(ip);
80104e9d:	89 1c 24             	mov    %ebx,(%esp)
80104ea0:	e8 5b c9 ff ff       	call   80101800 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80104ea5:	58                   	pop    %eax
80104ea6:	5a                   	pop    %edx
80104ea7:	57                   	push   %edi
80104ea8:	ff 75 d0             	pushl  -0x30(%ebp)
80104eab:	e8 30 d1 ff ff       	call   80101fe0 <nameiparent>
80104eb0:	83 c4 10             	add    $0x10,%esp
80104eb3:	89 c6                	mov    %eax,%esi
80104eb5:	85 c0                	test   %eax,%eax
80104eb7:	74 5b                	je     80104f14 <sys_link+0xf4>
  ilock(dp);
80104eb9:	83 ec 0c             	sub    $0xc,%esp
80104ebc:	50                   	push   %eax
80104ebd:	e8 5e c8 ff ff       	call   80101720 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104ec2:	83 c4 10             	add    $0x10,%esp
80104ec5:	8b 03                	mov    (%ebx),%eax
80104ec7:	39 06                	cmp    %eax,(%esi)
80104ec9:	75 3d                	jne    80104f08 <sys_link+0xe8>
80104ecb:	83 ec 04             	sub    $0x4,%esp
80104ece:	ff 73 04             	pushl  0x4(%ebx)
80104ed1:	57                   	push   %edi
80104ed2:	56                   	push   %esi
80104ed3:	e8 28 d0 ff ff       	call   80101f00 <dirlink>
80104ed8:	83 c4 10             	add    $0x10,%esp
80104edb:	85 c0                	test   %eax,%eax
80104edd:	78 29                	js     80104f08 <sys_link+0xe8>
  iunlockput(dp);
80104edf:	83 ec 0c             	sub    $0xc,%esp
80104ee2:	56                   	push   %esi
80104ee3:	e8 c8 ca ff ff       	call   801019b0 <iunlockput>
  iput(ip);
80104ee8:	89 1c 24             	mov    %ebx,(%esp)
80104eeb:	e8 60 c9 ff ff       	call   80101850 <iput>
  end_op();
80104ef0:	e8 1b de ff ff       	call   80102d10 <end_op>
  return 0;
80104ef5:	83 c4 10             	add    $0x10,%esp
80104ef8:	31 c0                	xor    %eax,%eax
}
80104efa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104efd:	5b                   	pop    %ebx
80104efe:	5e                   	pop    %esi
80104eff:	5f                   	pop    %edi
80104f00:	5d                   	pop    %ebp
80104f01:	c3                   	ret    
80104f02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80104f08:	83 ec 0c             	sub    $0xc,%esp
80104f0b:	56                   	push   %esi
80104f0c:	e8 9f ca ff ff       	call   801019b0 <iunlockput>
    goto bad;
80104f11:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80104f14:	83 ec 0c             	sub    $0xc,%esp
80104f17:	53                   	push   %ebx
80104f18:	e8 03 c8 ff ff       	call   80101720 <ilock>
  ip->nlink--;
80104f1d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104f22:	89 1c 24             	mov    %ebx,(%esp)
80104f25:	e8 46 c7 ff ff       	call   80101670 <iupdate>
  iunlockput(ip);
80104f2a:	89 1c 24             	mov    %ebx,(%esp)
80104f2d:	e8 7e ca ff ff       	call   801019b0 <iunlockput>
  end_op();
80104f32:	e8 d9 dd ff ff       	call   80102d10 <end_op>
  return -1;
80104f37:	83 c4 10             	add    $0x10,%esp
80104f3a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f3f:	eb b9                	jmp    80104efa <sys_link+0xda>
    iunlockput(ip);
80104f41:	83 ec 0c             	sub    $0xc,%esp
80104f44:	53                   	push   %ebx
80104f45:	e8 66 ca ff ff       	call   801019b0 <iunlockput>
    end_op();
80104f4a:	e8 c1 dd ff ff       	call   80102d10 <end_op>
    return -1;
80104f4f:	83 c4 10             	add    $0x10,%esp
80104f52:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f57:	eb a1                	jmp    80104efa <sys_link+0xda>
    end_op();
80104f59:	e8 b2 dd ff ff       	call   80102d10 <end_op>
    return -1;
80104f5e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f63:	eb 95                	jmp    80104efa <sys_link+0xda>
80104f65:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f70 <sys_unlink>:
{
80104f70:	55                   	push   %ebp
80104f71:	89 e5                	mov    %esp,%ebp
80104f73:	57                   	push   %edi
80104f74:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80104f75:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80104f78:	53                   	push   %ebx
80104f79:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
80104f7c:	50                   	push   %eax
80104f7d:	6a 00                	push   $0x0
80104f7f:	e8 2c fa ff ff       	call   801049b0 <argstr>
80104f84:	83 c4 10             	add    $0x10,%esp
80104f87:	85 c0                	test   %eax,%eax
80104f89:	0f 88 91 01 00 00    	js     80105120 <sys_unlink+0x1b0>
  begin_op();
80104f8f:	e8 0c dd ff ff       	call   80102ca0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104f94:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80104f97:	83 ec 08             	sub    $0x8,%esp
80104f9a:	53                   	push   %ebx
80104f9b:	ff 75 c0             	pushl  -0x40(%ebp)
80104f9e:	e8 3d d0 ff ff       	call   80101fe0 <nameiparent>
80104fa3:	83 c4 10             	add    $0x10,%esp
80104fa6:	89 c6                	mov    %eax,%esi
80104fa8:	85 c0                	test   %eax,%eax
80104faa:	0f 84 7a 01 00 00    	je     8010512a <sys_unlink+0x1ba>
  ilock(dp);
80104fb0:	83 ec 0c             	sub    $0xc,%esp
80104fb3:	50                   	push   %eax
80104fb4:	e8 67 c7 ff ff       	call   80101720 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104fb9:	58                   	pop    %eax
80104fba:	5a                   	pop    %edx
80104fbb:	68 d8 77 10 80       	push   $0x801077d8
80104fc0:	53                   	push   %ebx
80104fc1:	e8 6a cc ff ff       	call   80101c30 <namecmp>
80104fc6:	83 c4 10             	add    $0x10,%esp
80104fc9:	85 c0                	test   %eax,%eax
80104fcb:	0f 84 0f 01 00 00    	je     801050e0 <sys_unlink+0x170>
80104fd1:	83 ec 08             	sub    $0x8,%esp
80104fd4:	68 d7 77 10 80       	push   $0x801077d7
80104fd9:	53                   	push   %ebx
80104fda:	e8 51 cc ff ff       	call   80101c30 <namecmp>
80104fdf:	83 c4 10             	add    $0x10,%esp
80104fe2:	85 c0                	test   %eax,%eax
80104fe4:	0f 84 f6 00 00 00    	je     801050e0 <sys_unlink+0x170>
  if((ip = dirlookup(dp, name, &off)) == 0)
80104fea:	83 ec 04             	sub    $0x4,%esp
80104fed:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104ff0:	50                   	push   %eax
80104ff1:	53                   	push   %ebx
80104ff2:	56                   	push   %esi
80104ff3:	e8 58 cc ff ff       	call   80101c50 <dirlookup>
80104ff8:	83 c4 10             	add    $0x10,%esp
80104ffb:	89 c3                	mov    %eax,%ebx
80104ffd:	85 c0                	test   %eax,%eax
80104fff:	0f 84 db 00 00 00    	je     801050e0 <sys_unlink+0x170>
  ilock(ip);
80105005:	83 ec 0c             	sub    $0xc,%esp
80105008:	50                   	push   %eax
80105009:	e8 12 c7 ff ff       	call   80101720 <ilock>
  if(ip->nlink < 1)
8010500e:	83 c4 10             	add    $0x10,%esp
80105011:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105016:	0f 8e 37 01 00 00    	jle    80105153 <sys_unlink+0x1e3>
  if(ip->type == T_DIR && !isdirempty(ip)){
8010501c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105021:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105024:	74 6a                	je     80105090 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80105026:	83 ec 04             	sub    $0x4,%esp
80105029:	6a 10                	push   $0x10
8010502b:	6a 00                	push   $0x0
8010502d:	57                   	push   %edi
8010502e:	e8 ed f5 ff ff       	call   80104620 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105033:	6a 10                	push   $0x10
80105035:	ff 75 c4             	pushl  -0x3c(%ebp)
80105038:	57                   	push   %edi
80105039:	56                   	push   %esi
8010503a:	e8 c1 ca ff ff       	call   80101b00 <writei>
8010503f:	83 c4 20             	add    $0x20,%esp
80105042:	83 f8 10             	cmp    $0x10,%eax
80105045:	0f 85 fb 00 00 00    	jne    80105146 <sys_unlink+0x1d6>
  if(ip->type == T_DIR){
8010504b:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105050:	0f 84 aa 00 00 00    	je     80105100 <sys_unlink+0x190>
  iunlockput(dp);
80105056:	83 ec 0c             	sub    $0xc,%esp
80105059:	56                   	push   %esi
8010505a:	e8 51 c9 ff ff       	call   801019b0 <iunlockput>
  ip->nlink--;
8010505f:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105064:	89 1c 24             	mov    %ebx,(%esp)
80105067:	e8 04 c6 ff ff       	call   80101670 <iupdate>
  iunlockput(ip);
8010506c:	89 1c 24             	mov    %ebx,(%esp)
8010506f:	e8 3c c9 ff ff       	call   801019b0 <iunlockput>
  end_op();
80105074:	e8 97 dc ff ff       	call   80102d10 <end_op>
  return 0;
80105079:	83 c4 10             	add    $0x10,%esp
8010507c:	31 c0                	xor    %eax,%eax
}
8010507e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105081:	5b                   	pop    %ebx
80105082:	5e                   	pop    %esi
80105083:	5f                   	pop    %edi
80105084:	5d                   	pop    %ebp
80105085:	c3                   	ret    
80105086:	8d 76 00             	lea    0x0(%esi),%esi
80105089:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105090:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105094:	76 90                	jbe    80105026 <sys_unlink+0xb6>
80105096:	ba 20 00 00 00       	mov    $0x20,%edx
8010509b:	eb 0f                	jmp    801050ac <sys_unlink+0x13c>
8010509d:	8d 76 00             	lea    0x0(%esi),%esi
801050a0:	83 c2 10             	add    $0x10,%edx
801050a3:	39 53 58             	cmp    %edx,0x58(%ebx)
801050a6:	0f 86 7a ff ff ff    	jbe    80105026 <sys_unlink+0xb6>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801050ac:	6a 10                	push   $0x10
801050ae:	52                   	push   %edx
801050af:	57                   	push   %edi
801050b0:	53                   	push   %ebx
801050b1:	89 55 b4             	mov    %edx,-0x4c(%ebp)
801050b4:	e8 47 c9 ff ff       	call   80101a00 <readi>
801050b9:	83 c4 10             	add    $0x10,%esp
801050bc:	8b 55 b4             	mov    -0x4c(%ebp),%edx
801050bf:	83 f8 10             	cmp    $0x10,%eax
801050c2:	75 75                	jne    80105139 <sys_unlink+0x1c9>
    if(de.inum != 0)
801050c4:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801050c9:	74 d5                	je     801050a0 <sys_unlink+0x130>
    iunlockput(ip);
801050cb:	83 ec 0c             	sub    $0xc,%esp
801050ce:	53                   	push   %ebx
801050cf:	e8 dc c8 ff ff       	call   801019b0 <iunlockput>
    goto bad;
801050d4:	83 c4 10             	add    $0x10,%esp
801050d7:	89 f6                	mov    %esi,%esi
801050d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  iunlockput(dp);
801050e0:	83 ec 0c             	sub    $0xc,%esp
801050e3:	56                   	push   %esi
801050e4:	e8 c7 c8 ff ff       	call   801019b0 <iunlockput>
  end_op();
801050e9:	e8 22 dc ff ff       	call   80102d10 <end_op>
  return -1;
801050ee:	83 c4 10             	add    $0x10,%esp
801050f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050f6:	eb 86                	jmp    8010507e <sys_unlink+0x10e>
801050f8:	90                   	nop
801050f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    iupdate(dp);
80105100:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105103:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105108:	56                   	push   %esi
80105109:	e8 62 c5 ff ff       	call   80101670 <iupdate>
8010510e:	83 c4 10             	add    $0x10,%esp
80105111:	e9 40 ff ff ff       	jmp    80105056 <sys_unlink+0xe6>
80105116:	8d 76 00             	lea    0x0(%esi),%esi
80105119:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105120:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105125:	e9 54 ff ff ff       	jmp    8010507e <sys_unlink+0x10e>
    end_op();
8010512a:	e8 e1 db ff ff       	call   80102d10 <end_op>
    return -1;
8010512f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105134:	e9 45 ff ff ff       	jmp    8010507e <sys_unlink+0x10e>
      panic("isdirempty: readi");
80105139:	83 ec 0c             	sub    $0xc,%esp
8010513c:	68 fc 77 10 80       	push   $0x801077fc
80105141:	e8 4a b2 ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80105146:	83 ec 0c             	sub    $0xc,%esp
80105149:	68 0e 78 10 80       	push   $0x8010780e
8010514e:	e8 3d b2 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105153:	83 ec 0c             	sub    $0xc,%esp
80105156:	68 ea 77 10 80       	push   $0x801077ea
8010515b:	e8 30 b2 ff ff       	call   80100390 <panic>

80105160 <sys_open>:

int
sys_open(void)
{
80105160:	55                   	push   %ebp
80105161:	89 e5                	mov    %esp,%ebp
80105163:	57                   	push   %edi
80105164:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105165:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105168:	53                   	push   %ebx
80105169:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010516c:	50                   	push   %eax
8010516d:	6a 00                	push   $0x0
8010516f:	e8 3c f8 ff ff       	call   801049b0 <argstr>
80105174:	83 c4 10             	add    $0x10,%esp
80105177:	85 c0                	test   %eax,%eax
80105179:	0f 88 8e 00 00 00    	js     8010520d <sys_open+0xad>
8010517f:	83 ec 08             	sub    $0x8,%esp
80105182:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105185:	50                   	push   %eax
80105186:	6a 01                	push   $0x1
80105188:	e8 73 f7 ff ff       	call   80104900 <argint>
8010518d:	83 c4 10             	add    $0x10,%esp
80105190:	85 c0                	test   %eax,%eax
80105192:	78 79                	js     8010520d <sys_open+0xad>
    return -1;

  begin_op();
80105194:	e8 07 db ff ff       	call   80102ca0 <begin_op>

  if(omode & O_CREATE){
80105199:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
8010519d:	75 79                	jne    80105218 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
8010519f:	83 ec 0c             	sub    $0xc,%esp
801051a2:	ff 75 e0             	pushl  -0x20(%ebp)
801051a5:	e8 16 ce ff ff       	call   80101fc0 <namei>
801051aa:	83 c4 10             	add    $0x10,%esp
801051ad:	89 c6                	mov    %eax,%esi
801051af:	85 c0                	test   %eax,%eax
801051b1:	0f 84 7e 00 00 00    	je     80105235 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
801051b7:	83 ec 0c             	sub    $0xc,%esp
801051ba:	50                   	push   %eax
801051bb:	e8 60 c5 ff ff       	call   80101720 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801051c0:	83 c4 10             	add    $0x10,%esp
801051c3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801051c8:	0f 84 c2 00 00 00    	je     80105290 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801051ce:	e8 2d bc ff ff       	call   80100e00 <filealloc>
801051d3:	89 c7                	mov    %eax,%edi
801051d5:	85 c0                	test   %eax,%eax
801051d7:	74 23                	je     801051fc <sys_open+0x9c>
  struct proc *curproc = myproc();
801051d9:	e8 02 e7 ff ff       	call   801038e0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801051de:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
801051e0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801051e4:	85 d2                	test   %edx,%edx
801051e6:	74 60                	je     80105248 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
801051e8:	83 c3 01             	add    $0x1,%ebx
801051eb:	83 fb 10             	cmp    $0x10,%ebx
801051ee:	75 f0                	jne    801051e0 <sys_open+0x80>
    if(f)
      fileclose(f);
801051f0:	83 ec 0c             	sub    $0xc,%esp
801051f3:	57                   	push   %edi
801051f4:	e8 c7 bc ff ff       	call   80100ec0 <fileclose>
801051f9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801051fc:	83 ec 0c             	sub    $0xc,%esp
801051ff:	56                   	push   %esi
80105200:	e8 ab c7 ff ff       	call   801019b0 <iunlockput>
    end_op();
80105205:	e8 06 db ff ff       	call   80102d10 <end_op>
    return -1;
8010520a:	83 c4 10             	add    $0x10,%esp
8010520d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105212:	eb 6d                	jmp    80105281 <sys_open+0x121>
80105214:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105218:	83 ec 0c             	sub    $0xc,%esp
8010521b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010521e:	31 c9                	xor    %ecx,%ecx
80105220:	ba 02 00 00 00       	mov    $0x2,%edx
80105225:	6a 00                	push   $0x0
80105227:	e8 24 f8 ff ff       	call   80104a50 <create>
    if(ip == 0){
8010522c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010522f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105231:	85 c0                	test   %eax,%eax
80105233:	75 99                	jne    801051ce <sys_open+0x6e>
      end_op();
80105235:	e8 d6 da ff ff       	call   80102d10 <end_op>
      return -1;
8010523a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010523f:	eb 40                	jmp    80105281 <sys_open+0x121>
80105241:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105248:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
8010524b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010524f:	56                   	push   %esi
80105250:	e8 ab c5 ff ff       	call   80101800 <iunlock>
  end_op();
80105255:	e8 b6 da ff ff       	call   80102d10 <end_op>

  f->type = FD_INODE;
8010525a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105260:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105263:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105266:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105269:	89 d0                	mov    %edx,%eax
  f->off = 0;
8010526b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105272:	f7 d0                	not    %eax
80105274:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105277:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
8010527a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010527d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105281:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105284:	89 d8                	mov    %ebx,%eax
80105286:	5b                   	pop    %ebx
80105287:	5e                   	pop    %esi
80105288:	5f                   	pop    %edi
80105289:	5d                   	pop    %ebp
8010528a:	c3                   	ret    
8010528b:	90                   	nop
8010528c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105290:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105293:	85 c9                	test   %ecx,%ecx
80105295:	0f 84 33 ff ff ff    	je     801051ce <sys_open+0x6e>
8010529b:	e9 5c ff ff ff       	jmp    801051fc <sys_open+0x9c>

801052a0 <sys_mkdir>:

int
sys_mkdir(void)
{
801052a0:	55                   	push   %ebp
801052a1:	89 e5                	mov    %esp,%ebp
801052a3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801052a6:	e8 f5 d9 ff ff       	call   80102ca0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801052ab:	83 ec 08             	sub    $0x8,%esp
801052ae:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052b1:	50                   	push   %eax
801052b2:	6a 00                	push   $0x0
801052b4:	e8 f7 f6 ff ff       	call   801049b0 <argstr>
801052b9:	83 c4 10             	add    $0x10,%esp
801052bc:	85 c0                	test   %eax,%eax
801052be:	78 30                	js     801052f0 <sys_mkdir+0x50>
801052c0:	83 ec 0c             	sub    $0xc,%esp
801052c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052c6:	31 c9                	xor    %ecx,%ecx
801052c8:	ba 01 00 00 00       	mov    $0x1,%edx
801052cd:	6a 00                	push   $0x0
801052cf:	e8 7c f7 ff ff       	call   80104a50 <create>
801052d4:	83 c4 10             	add    $0x10,%esp
801052d7:	85 c0                	test   %eax,%eax
801052d9:	74 15                	je     801052f0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801052db:	83 ec 0c             	sub    $0xc,%esp
801052de:	50                   	push   %eax
801052df:	e8 cc c6 ff ff       	call   801019b0 <iunlockput>
  end_op();
801052e4:	e8 27 da ff ff       	call   80102d10 <end_op>
  return 0;
801052e9:	83 c4 10             	add    $0x10,%esp
801052ec:	31 c0                	xor    %eax,%eax
}
801052ee:	c9                   	leave  
801052ef:	c3                   	ret    
    end_op();
801052f0:	e8 1b da ff ff       	call   80102d10 <end_op>
    return -1;
801052f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801052fa:	c9                   	leave  
801052fb:	c3                   	ret    
801052fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105300 <sys_mknod>:

int
sys_mknod(void)
{
80105300:	55                   	push   %ebp
80105301:	89 e5                	mov    %esp,%ebp
80105303:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105306:	e8 95 d9 ff ff       	call   80102ca0 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010530b:	83 ec 08             	sub    $0x8,%esp
8010530e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105311:	50                   	push   %eax
80105312:	6a 00                	push   $0x0
80105314:	e8 97 f6 ff ff       	call   801049b0 <argstr>
80105319:	83 c4 10             	add    $0x10,%esp
8010531c:	85 c0                	test   %eax,%eax
8010531e:	78 60                	js     80105380 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105320:	83 ec 08             	sub    $0x8,%esp
80105323:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105326:	50                   	push   %eax
80105327:	6a 01                	push   $0x1
80105329:	e8 d2 f5 ff ff       	call   80104900 <argint>
  if((argstr(0, &path)) < 0 ||
8010532e:	83 c4 10             	add    $0x10,%esp
80105331:	85 c0                	test   %eax,%eax
80105333:	78 4b                	js     80105380 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105335:	83 ec 08             	sub    $0x8,%esp
80105338:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010533b:	50                   	push   %eax
8010533c:	6a 02                	push   $0x2
8010533e:	e8 bd f5 ff ff       	call   80104900 <argint>
     argint(1, &major) < 0 ||
80105343:	83 c4 10             	add    $0x10,%esp
80105346:	85 c0                	test   %eax,%eax
80105348:	78 36                	js     80105380 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010534a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010534e:	83 ec 0c             	sub    $0xc,%esp
80105351:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105355:	ba 03 00 00 00       	mov    $0x3,%edx
8010535a:	50                   	push   %eax
8010535b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010535e:	e8 ed f6 ff ff       	call   80104a50 <create>
     argint(2, &minor) < 0 ||
80105363:	83 c4 10             	add    $0x10,%esp
80105366:	85 c0                	test   %eax,%eax
80105368:	74 16                	je     80105380 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010536a:	83 ec 0c             	sub    $0xc,%esp
8010536d:	50                   	push   %eax
8010536e:	e8 3d c6 ff ff       	call   801019b0 <iunlockput>
  end_op();
80105373:	e8 98 d9 ff ff       	call   80102d10 <end_op>
  return 0;
80105378:	83 c4 10             	add    $0x10,%esp
8010537b:	31 c0                	xor    %eax,%eax
}
8010537d:	c9                   	leave  
8010537e:	c3                   	ret    
8010537f:	90                   	nop
    end_op();
80105380:	e8 8b d9 ff ff       	call   80102d10 <end_op>
    return -1;
80105385:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010538a:	c9                   	leave  
8010538b:	c3                   	ret    
8010538c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105390 <sys_chdir>:

int
sys_chdir(void)
{
80105390:	55                   	push   %ebp
80105391:	89 e5                	mov    %esp,%ebp
80105393:	56                   	push   %esi
80105394:	53                   	push   %ebx
80105395:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105398:	e8 43 e5 ff ff       	call   801038e0 <myproc>
8010539d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010539f:	e8 fc d8 ff ff       	call   80102ca0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801053a4:	83 ec 08             	sub    $0x8,%esp
801053a7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801053aa:	50                   	push   %eax
801053ab:	6a 00                	push   $0x0
801053ad:	e8 fe f5 ff ff       	call   801049b0 <argstr>
801053b2:	83 c4 10             	add    $0x10,%esp
801053b5:	85 c0                	test   %eax,%eax
801053b7:	78 77                	js     80105430 <sys_chdir+0xa0>
801053b9:	83 ec 0c             	sub    $0xc,%esp
801053bc:	ff 75 f4             	pushl  -0xc(%ebp)
801053bf:	e8 fc cb ff ff       	call   80101fc0 <namei>
801053c4:	83 c4 10             	add    $0x10,%esp
801053c7:	89 c3                	mov    %eax,%ebx
801053c9:	85 c0                	test   %eax,%eax
801053cb:	74 63                	je     80105430 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801053cd:	83 ec 0c             	sub    $0xc,%esp
801053d0:	50                   	push   %eax
801053d1:	e8 4a c3 ff ff       	call   80101720 <ilock>
  if(ip->type != T_DIR){
801053d6:	83 c4 10             	add    $0x10,%esp
801053d9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801053de:	75 30                	jne    80105410 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801053e0:	83 ec 0c             	sub    $0xc,%esp
801053e3:	53                   	push   %ebx
801053e4:	e8 17 c4 ff ff       	call   80101800 <iunlock>
  iput(curproc->cwd);
801053e9:	58                   	pop    %eax
801053ea:	ff 76 68             	pushl  0x68(%esi)
801053ed:	e8 5e c4 ff ff       	call   80101850 <iput>
  end_op();
801053f2:	e8 19 d9 ff ff       	call   80102d10 <end_op>
  curproc->cwd = ip;
801053f7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801053fa:	83 c4 10             	add    $0x10,%esp
801053fd:	31 c0                	xor    %eax,%eax
}
801053ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105402:	5b                   	pop    %ebx
80105403:	5e                   	pop    %esi
80105404:	5d                   	pop    %ebp
80105405:	c3                   	ret    
80105406:	8d 76 00             	lea    0x0(%esi),%esi
80105409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
80105410:	83 ec 0c             	sub    $0xc,%esp
80105413:	53                   	push   %ebx
80105414:	e8 97 c5 ff ff       	call   801019b0 <iunlockput>
    end_op();
80105419:	e8 f2 d8 ff ff       	call   80102d10 <end_op>
    return -1;
8010541e:	83 c4 10             	add    $0x10,%esp
80105421:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105426:	eb d7                	jmp    801053ff <sys_chdir+0x6f>
80105428:	90                   	nop
80105429:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105430:	e8 db d8 ff ff       	call   80102d10 <end_op>
    return -1;
80105435:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010543a:	eb c3                	jmp    801053ff <sys_chdir+0x6f>
8010543c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105440 <sys_exec>:

int
sys_exec(void)
{
80105440:	55                   	push   %ebp
80105441:	89 e5                	mov    %esp,%ebp
80105443:	57                   	push   %edi
80105444:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105445:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010544b:	53                   	push   %ebx
8010544c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105452:	50                   	push   %eax
80105453:	6a 00                	push   $0x0
80105455:	e8 56 f5 ff ff       	call   801049b0 <argstr>
8010545a:	83 c4 10             	add    $0x10,%esp
8010545d:	85 c0                	test   %eax,%eax
8010545f:	0f 88 87 00 00 00    	js     801054ec <sys_exec+0xac>
80105465:	83 ec 08             	sub    $0x8,%esp
80105468:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010546e:	50                   	push   %eax
8010546f:	6a 01                	push   $0x1
80105471:	e8 8a f4 ff ff       	call   80104900 <argint>
80105476:	83 c4 10             	add    $0x10,%esp
80105479:	85 c0                	test   %eax,%eax
8010547b:	78 6f                	js     801054ec <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010547d:	83 ec 04             	sub    $0x4,%esp
80105480:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
80105486:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105488:	68 80 00 00 00       	push   $0x80
8010548d:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105493:	6a 00                	push   $0x0
80105495:	50                   	push   %eax
80105496:	e8 85 f1 ff ff       	call   80104620 <memset>
8010549b:	83 c4 10             	add    $0x10,%esp
8010549e:	66 90                	xchg   %ax,%ax
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801054a0:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801054a6:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
801054ad:	83 ec 08             	sub    $0x8,%esp
801054b0:	57                   	push   %edi
801054b1:	01 f0                	add    %esi,%eax
801054b3:	50                   	push   %eax
801054b4:	e8 a7 f3 ff ff       	call   80104860 <fetchint>
801054b9:	83 c4 10             	add    $0x10,%esp
801054bc:	85 c0                	test   %eax,%eax
801054be:	78 2c                	js     801054ec <sys_exec+0xac>
      return -1;
    if(uarg == 0){
801054c0:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801054c6:	85 c0                	test   %eax,%eax
801054c8:	74 36                	je     80105500 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801054ca:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
801054d0:	83 ec 08             	sub    $0x8,%esp
801054d3:	8d 14 31             	lea    (%ecx,%esi,1),%edx
801054d6:	52                   	push   %edx
801054d7:	50                   	push   %eax
801054d8:	e8 c3 f3 ff ff       	call   801048a0 <fetchstr>
801054dd:	83 c4 10             	add    $0x10,%esp
801054e0:	85 c0                	test   %eax,%eax
801054e2:	78 08                	js     801054ec <sys_exec+0xac>
  for(i=0;; i++){
801054e4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
801054e7:	83 fb 20             	cmp    $0x20,%ebx
801054ea:	75 b4                	jne    801054a0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
801054ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801054ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801054f4:	5b                   	pop    %ebx
801054f5:	5e                   	pop    %esi
801054f6:	5f                   	pop    %edi
801054f7:	5d                   	pop    %ebp
801054f8:	c3                   	ret    
801054f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105500:	83 ec 08             	sub    $0x8,%esp
80105503:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
80105509:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105510:	00 00 00 00 
  return exec(path, argv);
80105514:	50                   	push   %eax
80105515:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
8010551b:	e8 60 b5 ff ff       	call   80100a80 <exec>
80105520:	83 c4 10             	add    $0x10,%esp
}
80105523:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105526:	5b                   	pop    %ebx
80105527:	5e                   	pop    %esi
80105528:	5f                   	pop    %edi
80105529:	5d                   	pop    %ebp
8010552a:	c3                   	ret    
8010552b:	90                   	nop
8010552c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105530 <sys_pipe>:

int
sys_pipe(void)
{
80105530:	55                   	push   %ebp
80105531:	89 e5                	mov    %esp,%ebp
80105533:	57                   	push   %edi
80105534:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105535:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105538:	53                   	push   %ebx
80105539:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010553c:	6a 08                	push   $0x8
8010553e:	50                   	push   %eax
8010553f:	6a 00                	push   $0x0
80105541:	e8 0a f4 ff ff       	call   80104950 <argptr>
80105546:	83 c4 10             	add    $0x10,%esp
80105549:	85 c0                	test   %eax,%eax
8010554b:	78 4a                	js     80105597 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
8010554d:	83 ec 08             	sub    $0x8,%esp
80105550:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105553:	50                   	push   %eax
80105554:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105557:	50                   	push   %eax
80105558:	e8 f3 dd ff ff       	call   80103350 <pipealloc>
8010555d:	83 c4 10             	add    $0x10,%esp
80105560:	85 c0                	test   %eax,%eax
80105562:	78 33                	js     80105597 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105564:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105567:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105569:	e8 72 e3 ff ff       	call   801038e0 <myproc>
8010556e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105570:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105574:	85 f6                	test   %esi,%esi
80105576:	74 28                	je     801055a0 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
80105578:	83 c3 01             	add    $0x1,%ebx
8010557b:	83 fb 10             	cmp    $0x10,%ebx
8010557e:	75 f0                	jne    80105570 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105580:	83 ec 0c             	sub    $0xc,%esp
80105583:	ff 75 e0             	pushl  -0x20(%ebp)
80105586:	e8 35 b9 ff ff       	call   80100ec0 <fileclose>
    fileclose(wf);
8010558b:	58                   	pop    %eax
8010558c:	ff 75 e4             	pushl  -0x1c(%ebp)
8010558f:	e8 2c b9 ff ff       	call   80100ec0 <fileclose>
    return -1;
80105594:	83 c4 10             	add    $0x10,%esp
80105597:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010559c:	eb 53                	jmp    801055f1 <sys_pipe+0xc1>
8010559e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
801055a0:	8d 73 08             	lea    0x8(%ebx),%esi
801055a3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801055a7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801055aa:	e8 31 e3 ff ff       	call   801038e0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801055af:	31 d2                	xor    %edx,%edx
801055b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
801055b8:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801055bc:	85 c9                	test   %ecx,%ecx
801055be:	74 20                	je     801055e0 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
801055c0:	83 c2 01             	add    $0x1,%edx
801055c3:	83 fa 10             	cmp    $0x10,%edx
801055c6:	75 f0                	jne    801055b8 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
801055c8:	e8 13 e3 ff ff       	call   801038e0 <myproc>
801055cd:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
801055d4:	00 
801055d5:	eb a9                	jmp    80105580 <sys_pipe+0x50>
801055d7:	89 f6                	mov    %esi,%esi
801055d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      curproc->ofile[fd] = f;
801055e0:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
801055e4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801055e7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801055e9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801055ec:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801055ef:	31 c0                	xor    %eax,%eax
}
801055f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801055f4:	5b                   	pop    %ebx
801055f5:	5e                   	pop    %esi
801055f6:	5f                   	pop    %edi
801055f7:	5d                   	pop    %ebp
801055f8:	c3                   	ret    
801055f9:	66 90                	xchg   %ax,%ax
801055fb:	66 90                	xchg   %ax,%ax
801055fd:	66 90                	xchg   %ax,%ax
801055ff:	90                   	nop

80105600 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105600:	e9 7b e4 ff ff       	jmp    80103a80 <fork>
80105605:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105609:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105610 <sys_exit>:
}

int
sys_exit(void)
{
80105610:	55                   	push   %ebp
80105611:	89 e5                	mov    %esp,%ebp
80105613:	83 ec 08             	sub    $0x8,%esp
  exit();
80105616:	e8 e5 e6 ff ff       	call   80103d00 <exit>
  return 0;  // not reached
}
8010561b:	31 c0                	xor    %eax,%eax
8010561d:	c9                   	leave  
8010561e:	c3                   	ret    
8010561f:	90                   	nop

80105620 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80105620:	e9 1b e9 ff ff       	jmp    80103f40 <wait>
80105625:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105629:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105630 <sys_kill>:
}

int
sys_kill(void)
{
80105630:	55                   	push   %ebp
80105631:	89 e5                	mov    %esp,%ebp
80105633:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105636:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105639:	50                   	push   %eax
8010563a:	6a 00                	push   $0x0
8010563c:	e8 bf f2 ff ff       	call   80104900 <argint>
80105641:	83 c4 10             	add    $0x10,%esp
80105644:	85 c0                	test   %eax,%eax
80105646:	78 18                	js     80105660 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105648:	83 ec 0c             	sub    $0xc,%esp
8010564b:	ff 75 f4             	pushl  -0xc(%ebp)
8010564e:	e8 3d ea ff ff       	call   80104090 <kill>
80105653:	83 c4 10             	add    $0x10,%esp
}
80105656:	c9                   	leave  
80105657:	c3                   	ret    
80105658:	90                   	nop
80105659:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105660:	c9                   	leave  
    return -1;
80105661:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105666:	c3                   	ret    
80105667:	89 f6                	mov    %esi,%esi
80105669:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105670 <sys_getpid>:

int
sys_getpid(void)
{
80105670:	55                   	push   %ebp
80105671:	89 e5                	mov    %esp,%ebp
80105673:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105676:	e8 65 e2 ff ff       	call   801038e0 <myproc>
8010567b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010567e:	c9                   	leave  
8010567f:	c3                   	ret    

80105680 <sys_sbrk>:

int
sys_sbrk(void)
{
80105680:	55                   	push   %ebp
80105681:	89 e5                	mov    %esp,%ebp
80105683:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105684:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105687:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010568a:	50                   	push   %eax
8010568b:	6a 00                	push   $0x0
8010568d:	e8 6e f2 ff ff       	call   80104900 <argint>
80105692:	83 c4 10             	add    $0x10,%esp
80105695:	85 c0                	test   %eax,%eax
80105697:	78 27                	js     801056c0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105699:	e8 42 e2 ff ff       	call   801038e0 <myproc>
  if(growproc(n) < 0)
8010569e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
801056a1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801056a3:	ff 75 f4             	pushl  -0xc(%ebp)
801056a6:	e8 55 e3 ff ff       	call   80103a00 <growproc>
801056ab:	83 c4 10             	add    $0x10,%esp
801056ae:	85 c0                	test   %eax,%eax
801056b0:	78 0e                	js     801056c0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
801056b2:	89 d8                	mov    %ebx,%eax
801056b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801056b7:	c9                   	leave  
801056b8:	c3                   	ret    
801056b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801056c0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801056c5:	eb eb                	jmp    801056b2 <sys_sbrk+0x32>
801056c7:	89 f6                	mov    %esi,%esi
801056c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801056d0 <sys_sleep>:

int
sys_sleep(void)
{
801056d0:	55                   	push   %ebp
801056d1:	89 e5                	mov    %esp,%ebp
801056d3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801056d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801056d7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801056da:	50                   	push   %eax
801056db:	6a 00                	push   $0x0
801056dd:	e8 1e f2 ff ff       	call   80104900 <argint>
801056e2:	83 c4 10             	add    $0x10,%esp
801056e5:	85 c0                	test   %eax,%eax
801056e7:	0f 88 8a 00 00 00    	js     80105777 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
801056ed:	83 ec 0c             	sub    $0xc,%esp
801056f0:	68 60 4c 11 80       	push   $0x80114c60
801056f5:	e8 b6 ed ff ff       	call   801044b0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801056fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
801056fd:	8b 1d a0 54 11 80    	mov    0x801154a0,%ebx
  while(ticks - ticks0 < n){
80105703:	83 c4 10             	add    $0x10,%esp
80105706:	85 d2                	test   %edx,%edx
80105708:	75 27                	jne    80105731 <sys_sleep+0x61>
8010570a:	eb 54                	jmp    80105760 <sys_sleep+0x90>
8010570c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105710:	83 ec 08             	sub    $0x8,%esp
80105713:	68 60 4c 11 80       	push   $0x80114c60
80105718:	68 a0 54 11 80       	push   $0x801154a0
8010571d:	e8 5e e7 ff ff       	call   80103e80 <sleep>
  while(ticks - ticks0 < n){
80105722:	a1 a0 54 11 80       	mov    0x801154a0,%eax
80105727:	83 c4 10             	add    $0x10,%esp
8010572a:	29 d8                	sub    %ebx,%eax
8010572c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010572f:	73 2f                	jae    80105760 <sys_sleep+0x90>
    if(myproc()->killed){
80105731:	e8 aa e1 ff ff       	call   801038e0 <myproc>
80105736:	8b 40 24             	mov    0x24(%eax),%eax
80105739:	85 c0                	test   %eax,%eax
8010573b:	74 d3                	je     80105710 <sys_sleep+0x40>
      release(&tickslock);
8010573d:	83 ec 0c             	sub    $0xc,%esp
80105740:	68 60 4c 11 80       	push   $0x80114c60
80105745:	e8 86 ee ff ff       	call   801045d0 <release>
      return -1;
8010574a:	83 c4 10             	add    $0x10,%esp
8010574d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80105752:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105755:	c9                   	leave  
80105756:	c3                   	ret    
80105757:	89 f6                	mov    %esi,%esi
80105759:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
80105760:	83 ec 0c             	sub    $0xc,%esp
80105763:	68 60 4c 11 80       	push   $0x80114c60
80105768:	e8 63 ee ff ff       	call   801045d0 <release>
  return 0;
8010576d:	83 c4 10             	add    $0x10,%esp
80105770:	31 c0                	xor    %eax,%eax
}
80105772:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105775:	c9                   	leave  
80105776:	c3                   	ret    
    return -1;
80105777:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010577c:	eb f4                	jmp    80105772 <sys_sleep+0xa2>
8010577e:	66 90                	xchg   %ax,%ax

80105780 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105780:	55                   	push   %ebp
80105781:	89 e5                	mov    %esp,%ebp
80105783:	53                   	push   %ebx
80105784:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105787:	68 60 4c 11 80       	push   $0x80114c60
8010578c:	e8 1f ed ff ff       	call   801044b0 <acquire>
  xticks = ticks;
80105791:	8b 1d a0 54 11 80    	mov    0x801154a0,%ebx
  release(&tickslock);
80105797:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
8010579e:	e8 2d ee ff ff       	call   801045d0 <release>
  return xticks;
}
801057a3:	89 d8                	mov    %ebx,%eax
801057a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801057a8:	c9                   	leave  
801057a9:	c3                   	ret    
801057aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801057b0 <sys_cps>:

int 
sys_cps (void)
{
    return cps();
801057b0:	e9 1b ea ff ff       	jmp    801041d0 <cps>

801057b5 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801057b5:	1e                   	push   %ds
  pushl %es
801057b6:	06                   	push   %es
  pushl %fs
801057b7:	0f a0                	push   %fs
  pushl %gs
801057b9:	0f a8                	push   %gs
  pushal
801057bb:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801057bc:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801057c0:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801057c2:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801057c4:	54                   	push   %esp
  call trap
801057c5:	e8 c6 00 00 00       	call   80105890 <trap>
  addl $4, %esp
801057ca:	83 c4 04             	add    $0x4,%esp

801057cd <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801057cd:	61                   	popa   
  popl %gs
801057ce:	0f a9                	pop    %gs
  popl %fs
801057d0:	0f a1                	pop    %fs
  popl %es
801057d2:	07                   	pop    %es
  popl %ds
801057d3:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801057d4:	83 c4 08             	add    $0x8,%esp
  iret
801057d7:	cf                   	iret   
801057d8:	66 90                	xchg   %ax,%ax
801057da:	66 90                	xchg   %ax,%ax
801057dc:	66 90                	xchg   %ax,%ax
801057de:	66 90                	xchg   %ax,%ax

801057e0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801057e0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
801057e1:	31 c0                	xor    %eax,%eax
{
801057e3:	89 e5                	mov    %esp,%ebp
801057e5:	83 ec 08             	sub    $0x8,%esp
801057e8:	90                   	nop
801057e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801057f0:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
801057f7:	c7 04 c5 a2 4c 11 80 	movl   $0x8e000008,-0x7feeb35e(,%eax,8)
801057fe:	08 00 00 8e 
80105802:	66 89 14 c5 a0 4c 11 	mov    %dx,-0x7feeb360(,%eax,8)
80105809:	80 
8010580a:	c1 ea 10             	shr    $0x10,%edx
8010580d:	66 89 14 c5 a6 4c 11 	mov    %dx,-0x7feeb35a(,%eax,8)
80105814:	80 
  for(i = 0; i < 256; i++)
80105815:	83 c0 01             	add    $0x1,%eax
80105818:	3d 00 01 00 00       	cmp    $0x100,%eax
8010581d:	75 d1                	jne    801057f0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
8010581f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105822:	a1 08 a1 10 80       	mov    0x8010a108,%eax
80105827:	c7 05 a2 4e 11 80 08 	movl   $0xef000008,0x80114ea2
8010582e:	00 00 ef 
  initlock(&tickslock, "time");
80105831:	68 1d 78 10 80       	push   $0x8010781d
80105836:	68 60 4c 11 80       	push   $0x80114c60
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010583b:	66 a3 a0 4e 11 80    	mov    %ax,0x80114ea0
80105841:	c1 e8 10             	shr    $0x10,%eax
80105844:	66 a3 a6 4e 11 80    	mov    %ax,0x80114ea6
  initlock(&tickslock, "time");
8010584a:	e8 61 eb ff ff       	call   801043b0 <initlock>
}
8010584f:	83 c4 10             	add    $0x10,%esp
80105852:	c9                   	leave  
80105853:	c3                   	ret    
80105854:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010585a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105860 <idtinit>:

void
idtinit(void)
{
80105860:	55                   	push   %ebp
  pd[0] = size-1;
80105861:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105866:	89 e5                	mov    %esp,%ebp
80105868:	83 ec 10             	sub    $0x10,%esp
8010586b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010586f:	b8 a0 4c 11 80       	mov    $0x80114ca0,%eax
80105874:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105878:	c1 e8 10             	shr    $0x10,%eax
8010587b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010587f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105882:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105885:	c9                   	leave  
80105886:	c3                   	ret    
80105887:	89 f6                	mov    %esi,%esi
80105889:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105890 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105890:	55                   	push   %ebp
80105891:	89 e5                	mov    %esp,%ebp
80105893:	57                   	push   %edi
80105894:	56                   	push   %esi
80105895:	53                   	push   %ebx
80105896:	83 ec 1c             	sub    $0x1c,%esp
80105899:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
8010589c:	8b 47 30             	mov    0x30(%edi),%eax
8010589f:	83 f8 40             	cmp    $0x40,%eax
801058a2:	0f 84 b8 01 00 00    	je     80105a60 <trap+0x1d0>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
801058a8:	83 e8 20             	sub    $0x20,%eax
801058ab:	83 f8 1f             	cmp    $0x1f,%eax
801058ae:	77 10                	ja     801058c0 <trap+0x30>
801058b0:	ff 24 85 c4 78 10 80 	jmp    *-0x7fef873c(,%eax,4)
801058b7:	89 f6                	mov    %esi,%esi
801058b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
801058c0:	e8 1b e0 ff ff       	call   801038e0 <myproc>
801058c5:	8b 5f 38             	mov    0x38(%edi),%ebx
801058c8:	85 c0                	test   %eax,%eax
801058ca:	0f 84 17 02 00 00    	je     80105ae7 <trap+0x257>
801058d0:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
801058d4:	0f 84 0d 02 00 00    	je     80105ae7 <trap+0x257>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801058da:	0f 20 d1             	mov    %cr2,%ecx
801058dd:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801058e0:	e8 db df ff ff       	call   801038c0 <cpuid>
801058e5:	8b 77 30             	mov    0x30(%edi),%esi
801058e8:	89 45 dc             	mov    %eax,-0x24(%ebp)
801058eb:	8b 47 34             	mov    0x34(%edi),%eax
801058ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801058f1:	e8 ea df ff ff       	call   801038e0 <myproc>
801058f6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801058f9:	e8 e2 df ff ff       	call   801038e0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801058fe:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105901:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105904:	51                   	push   %ecx
80105905:	53                   	push   %ebx
80105906:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80105907:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010590a:	ff 75 e4             	pushl  -0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
8010590d:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105910:	56                   	push   %esi
80105911:	52                   	push   %edx
80105912:	ff 70 10             	pushl  0x10(%eax)
80105915:	68 80 78 10 80       	push   $0x80107880
8010591a:	e8 91 ad ff ff       	call   801006b0 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
8010591f:	83 c4 20             	add    $0x20,%esp
80105922:	e8 b9 df ff ff       	call   801038e0 <myproc>
80105927:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010592e:	e8 ad df ff ff       	call   801038e0 <myproc>
80105933:	85 c0                	test   %eax,%eax
80105935:	74 1d                	je     80105954 <trap+0xc4>
80105937:	e8 a4 df ff ff       	call   801038e0 <myproc>
8010593c:	8b 50 24             	mov    0x24(%eax),%edx
8010593f:	85 d2                	test   %edx,%edx
80105941:	74 11                	je     80105954 <trap+0xc4>
80105943:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105947:	83 e0 03             	and    $0x3,%eax
8010594a:	66 83 f8 03          	cmp    $0x3,%ax
8010594e:	0f 84 44 01 00 00    	je     80105a98 <trap+0x208>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105954:	e8 87 df ff ff       	call   801038e0 <myproc>
80105959:	85 c0                	test   %eax,%eax
8010595b:	74 0b                	je     80105968 <trap+0xd8>
8010595d:	e8 7e df ff ff       	call   801038e0 <myproc>
80105962:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105966:	74 38                	je     801059a0 <trap+0x110>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105968:	e8 73 df ff ff       	call   801038e0 <myproc>
8010596d:	85 c0                	test   %eax,%eax
8010596f:	74 1d                	je     8010598e <trap+0xfe>
80105971:	e8 6a df ff ff       	call   801038e0 <myproc>
80105976:	8b 40 24             	mov    0x24(%eax),%eax
80105979:	85 c0                	test   %eax,%eax
8010597b:	74 11                	je     8010598e <trap+0xfe>
8010597d:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105981:	83 e0 03             	and    $0x3,%eax
80105984:	66 83 f8 03          	cmp    $0x3,%ax
80105988:	0f 84 fb 00 00 00    	je     80105a89 <trap+0x1f9>
    exit();
}
8010598e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105991:	5b                   	pop    %ebx
80105992:	5e                   	pop    %esi
80105993:	5f                   	pop    %edi
80105994:	5d                   	pop    %ebp
80105995:	c3                   	ret    
80105996:	8d 76 00             	lea    0x0(%esi),%esi
80105999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(myproc() && myproc()->state == RUNNING &&
801059a0:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
801059a4:	75 c2                	jne    80105968 <trap+0xd8>
    yield();
801059a6:	e8 85 e4 ff ff       	call   80103e30 <yield>
801059ab:	eb bb                	jmp    80105968 <trap+0xd8>
801059ad:	8d 76 00             	lea    0x0(%esi),%esi
    if(cpuid() == 0){
801059b0:	e8 0b df ff ff       	call   801038c0 <cpuid>
801059b5:	85 c0                	test   %eax,%eax
801059b7:	0f 84 eb 00 00 00    	je     80105aa8 <trap+0x218>
    lapiceoi();
801059bd:	e8 8e ce ff ff       	call   80102850 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801059c2:	e8 19 df ff ff       	call   801038e0 <myproc>
801059c7:	85 c0                	test   %eax,%eax
801059c9:	0f 85 68 ff ff ff    	jne    80105937 <trap+0xa7>
801059cf:	eb 83                	jmp    80105954 <trap+0xc4>
801059d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
801059d8:	e8 33 cd ff ff       	call   80102710 <kbdintr>
    lapiceoi();
801059dd:	e8 6e ce ff ff       	call   80102850 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801059e2:	e8 f9 de ff ff       	call   801038e0 <myproc>
801059e7:	85 c0                	test   %eax,%eax
801059e9:	0f 85 48 ff ff ff    	jne    80105937 <trap+0xa7>
801059ef:	e9 60 ff ff ff       	jmp    80105954 <trap+0xc4>
801059f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
801059f8:	e8 83 02 00 00       	call   80105c80 <uartintr>
    lapiceoi();
801059fd:	e8 4e ce ff ff       	call   80102850 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105a02:	e8 d9 de ff ff       	call   801038e0 <myproc>
80105a07:	85 c0                	test   %eax,%eax
80105a09:	0f 85 28 ff ff ff    	jne    80105937 <trap+0xa7>
80105a0f:	e9 40 ff ff ff       	jmp    80105954 <trap+0xc4>
80105a14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105a18:	8b 77 38             	mov    0x38(%edi),%esi
80105a1b:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80105a1f:	e8 9c de ff ff       	call   801038c0 <cpuid>
80105a24:	56                   	push   %esi
80105a25:	53                   	push   %ebx
80105a26:	50                   	push   %eax
80105a27:	68 28 78 10 80       	push   $0x80107828
80105a2c:	e8 7f ac ff ff       	call   801006b0 <cprintf>
    lapiceoi();
80105a31:	e8 1a ce ff ff       	call   80102850 <lapiceoi>
    break;
80105a36:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105a39:	e8 a2 de ff ff       	call   801038e0 <myproc>
80105a3e:	85 c0                	test   %eax,%eax
80105a40:	0f 85 f1 fe ff ff    	jne    80105937 <trap+0xa7>
80105a46:	e9 09 ff ff ff       	jmp    80105954 <trap+0xc4>
80105a4b:	90                   	nop
80105a4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
80105a50:	e8 0b c7 ff ff       	call   80102160 <ideintr>
80105a55:	e9 63 ff ff ff       	jmp    801059bd <trap+0x12d>
80105a5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed)
80105a60:	e8 7b de ff ff       	call   801038e0 <myproc>
80105a65:	8b 58 24             	mov    0x24(%eax),%ebx
80105a68:	85 db                	test   %ebx,%ebx
80105a6a:	75 74                	jne    80105ae0 <trap+0x250>
    myproc()->tf = tf;
80105a6c:	e8 6f de ff ff       	call   801038e0 <myproc>
80105a71:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80105a74:	e8 77 ef ff ff       	call   801049f0 <syscall>
    if(myproc()->killed)
80105a79:	e8 62 de ff ff       	call   801038e0 <myproc>
80105a7e:	8b 48 24             	mov    0x24(%eax),%ecx
80105a81:	85 c9                	test   %ecx,%ecx
80105a83:	0f 84 05 ff ff ff    	je     8010598e <trap+0xfe>
}
80105a89:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a8c:	5b                   	pop    %ebx
80105a8d:	5e                   	pop    %esi
80105a8e:	5f                   	pop    %edi
80105a8f:	5d                   	pop    %ebp
      exit();
80105a90:	e9 6b e2 ff ff       	jmp    80103d00 <exit>
80105a95:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
80105a98:	e8 63 e2 ff ff       	call   80103d00 <exit>
80105a9d:	e9 b2 fe ff ff       	jmp    80105954 <trap+0xc4>
80105aa2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80105aa8:	83 ec 0c             	sub    $0xc,%esp
80105aab:	68 60 4c 11 80       	push   $0x80114c60
80105ab0:	e8 fb e9 ff ff       	call   801044b0 <acquire>
      wakeup(&ticks);
80105ab5:	c7 04 24 a0 54 11 80 	movl   $0x801154a0,(%esp)
      ticks++;
80105abc:	83 05 a0 54 11 80 01 	addl   $0x1,0x801154a0
      wakeup(&ticks);
80105ac3:	e8 68 e5 ff ff       	call   80104030 <wakeup>
      release(&tickslock);
80105ac8:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
80105acf:	e8 fc ea ff ff       	call   801045d0 <release>
80105ad4:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105ad7:	e9 e1 fe ff ff       	jmp    801059bd <trap+0x12d>
80105adc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      exit();
80105ae0:	e8 1b e2 ff ff       	call   80103d00 <exit>
80105ae5:	eb 85                	jmp    80105a6c <trap+0x1dc>
80105ae7:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105aea:	e8 d1 dd ff ff       	call   801038c0 <cpuid>
80105aef:	83 ec 0c             	sub    $0xc,%esp
80105af2:	56                   	push   %esi
80105af3:	53                   	push   %ebx
80105af4:	50                   	push   %eax
80105af5:	ff 77 30             	pushl  0x30(%edi)
80105af8:	68 4c 78 10 80       	push   $0x8010784c
80105afd:	e8 ae ab ff ff       	call   801006b0 <cprintf>
      panic("trap");
80105b02:	83 c4 14             	add    $0x14,%esp
80105b05:	68 22 78 10 80       	push   $0x80107822
80105b0a:	e8 81 a8 ff ff       	call   80100390 <panic>
80105b0f:	90                   	nop

80105b10 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105b10:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
80105b15:	85 c0                	test   %eax,%eax
80105b17:	74 17                	je     80105b30 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105b19:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105b1e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105b1f:	a8 01                	test   $0x1,%al
80105b21:	74 0d                	je     80105b30 <uartgetc+0x20>
80105b23:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105b28:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105b29:	0f b6 c0             	movzbl %al,%eax
80105b2c:	c3                   	ret    
80105b2d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105b30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b35:	c3                   	ret    
80105b36:	8d 76 00             	lea    0x0(%esi),%esi
80105b39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105b40 <uartputc.part.0>:
uartputc(int c)
80105b40:	55                   	push   %ebp
80105b41:	89 e5                	mov    %esp,%ebp
80105b43:	57                   	push   %edi
80105b44:	89 c7                	mov    %eax,%edi
80105b46:	56                   	push   %esi
80105b47:	be fd 03 00 00       	mov    $0x3fd,%esi
80105b4c:	53                   	push   %ebx
80105b4d:	bb 80 00 00 00       	mov    $0x80,%ebx
80105b52:	83 ec 0c             	sub    $0xc,%esp
80105b55:	eb 1b                	jmp    80105b72 <uartputc.part.0+0x32>
80105b57:	89 f6                	mov    %esi,%esi
80105b59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80105b60:	83 ec 0c             	sub    $0xc,%esp
80105b63:	6a 0a                	push   $0xa
80105b65:	e8 06 cd ff ff       	call   80102870 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105b6a:	83 c4 10             	add    $0x10,%esp
80105b6d:	83 eb 01             	sub    $0x1,%ebx
80105b70:	74 07                	je     80105b79 <uartputc.part.0+0x39>
80105b72:	89 f2                	mov    %esi,%edx
80105b74:	ec                   	in     (%dx),%al
80105b75:	a8 20                	test   $0x20,%al
80105b77:	74 e7                	je     80105b60 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105b79:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105b7e:	89 f8                	mov    %edi,%eax
80105b80:	ee                   	out    %al,(%dx)
}
80105b81:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b84:	5b                   	pop    %ebx
80105b85:	5e                   	pop    %esi
80105b86:	5f                   	pop    %edi
80105b87:	5d                   	pop    %ebp
80105b88:	c3                   	ret    
80105b89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105b90 <uartinit>:
{
80105b90:	55                   	push   %ebp
80105b91:	31 c9                	xor    %ecx,%ecx
80105b93:	89 c8                	mov    %ecx,%eax
80105b95:	89 e5                	mov    %esp,%ebp
80105b97:	57                   	push   %edi
80105b98:	56                   	push   %esi
80105b99:	53                   	push   %ebx
80105b9a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105b9f:	89 da                	mov    %ebx,%edx
80105ba1:	83 ec 0c             	sub    $0xc,%esp
80105ba4:	ee                   	out    %al,(%dx)
80105ba5:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105baa:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105baf:	89 fa                	mov    %edi,%edx
80105bb1:	ee                   	out    %al,(%dx)
80105bb2:	b8 0c 00 00 00       	mov    $0xc,%eax
80105bb7:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105bbc:	ee                   	out    %al,(%dx)
80105bbd:	be f9 03 00 00       	mov    $0x3f9,%esi
80105bc2:	89 c8                	mov    %ecx,%eax
80105bc4:	89 f2                	mov    %esi,%edx
80105bc6:	ee                   	out    %al,(%dx)
80105bc7:	b8 03 00 00 00       	mov    $0x3,%eax
80105bcc:	89 fa                	mov    %edi,%edx
80105bce:	ee                   	out    %al,(%dx)
80105bcf:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105bd4:	89 c8                	mov    %ecx,%eax
80105bd6:	ee                   	out    %al,(%dx)
80105bd7:	b8 01 00 00 00       	mov    $0x1,%eax
80105bdc:	89 f2                	mov    %esi,%edx
80105bde:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105bdf:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105be4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105be5:	3c ff                	cmp    $0xff,%al
80105be7:	74 56                	je     80105c3f <uartinit+0xaf>
  uart = 1;
80105be9:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
80105bf0:	00 00 00 
80105bf3:	89 da                	mov    %ebx,%edx
80105bf5:	ec                   	in     (%dx),%al
80105bf6:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105bfb:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105bfc:	83 ec 08             	sub    $0x8,%esp
80105bff:	be 76 00 00 00       	mov    $0x76,%esi
  for(p="xv6...\n"; *p; p++)
80105c04:	bb 44 79 10 80       	mov    $0x80107944,%ebx
  ioapicenable(IRQ_COM1, 0);
80105c09:	6a 00                	push   $0x0
80105c0b:	6a 04                	push   $0x4
80105c0d:	e8 9e c7 ff ff       	call   801023b0 <ioapicenable>
80105c12:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80105c15:	b8 78 00 00 00       	mov    $0x78,%eax
80105c1a:	eb 08                	jmp    80105c24 <uartinit+0x94>
80105c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c20:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
80105c24:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
80105c2a:	85 d2                	test   %edx,%edx
80105c2c:	74 08                	je     80105c36 <uartinit+0xa6>
    uartputc(*p);
80105c2e:	0f be c0             	movsbl %al,%eax
80105c31:	e8 0a ff ff ff       	call   80105b40 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
80105c36:	89 f0                	mov    %esi,%eax
80105c38:	83 c3 01             	add    $0x1,%ebx
80105c3b:	84 c0                	test   %al,%al
80105c3d:	75 e1                	jne    80105c20 <uartinit+0x90>
}
80105c3f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c42:	5b                   	pop    %ebx
80105c43:	5e                   	pop    %esi
80105c44:	5f                   	pop    %edi
80105c45:	5d                   	pop    %ebp
80105c46:	c3                   	ret    
80105c47:	89 f6                	mov    %esi,%esi
80105c49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105c50 <uartputc>:
{
80105c50:	55                   	push   %ebp
  if(!uart)
80105c51:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
{
80105c57:	89 e5                	mov    %esp,%ebp
80105c59:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80105c5c:	85 d2                	test   %edx,%edx
80105c5e:	74 10                	je     80105c70 <uartputc+0x20>
}
80105c60:	5d                   	pop    %ebp
80105c61:	e9 da fe ff ff       	jmp    80105b40 <uartputc.part.0>
80105c66:	8d 76 00             	lea    0x0(%esi),%esi
80105c69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105c70:	5d                   	pop    %ebp
80105c71:	c3                   	ret    
80105c72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105c80 <uartintr>:

void
uartintr(void)
{
80105c80:	55                   	push   %ebp
80105c81:	89 e5                	mov    %esp,%ebp
80105c83:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105c86:	68 10 5b 10 80       	push   $0x80105b10
80105c8b:	e8 d0 ab ff ff       	call   80100860 <consoleintr>
}
80105c90:	83 c4 10             	add    $0x10,%esp
80105c93:	c9                   	leave  
80105c94:	c3                   	ret    

80105c95 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105c95:	6a 00                	push   $0x0
  pushl $0
80105c97:	6a 00                	push   $0x0
  jmp alltraps
80105c99:	e9 17 fb ff ff       	jmp    801057b5 <alltraps>

80105c9e <vector1>:
.globl vector1
vector1:
  pushl $0
80105c9e:	6a 00                	push   $0x0
  pushl $1
80105ca0:	6a 01                	push   $0x1
  jmp alltraps
80105ca2:	e9 0e fb ff ff       	jmp    801057b5 <alltraps>

80105ca7 <vector2>:
.globl vector2
vector2:
  pushl $0
80105ca7:	6a 00                	push   $0x0
  pushl $2
80105ca9:	6a 02                	push   $0x2
  jmp alltraps
80105cab:	e9 05 fb ff ff       	jmp    801057b5 <alltraps>

80105cb0 <vector3>:
.globl vector3
vector3:
  pushl $0
80105cb0:	6a 00                	push   $0x0
  pushl $3
80105cb2:	6a 03                	push   $0x3
  jmp alltraps
80105cb4:	e9 fc fa ff ff       	jmp    801057b5 <alltraps>

80105cb9 <vector4>:
.globl vector4
vector4:
  pushl $0
80105cb9:	6a 00                	push   $0x0
  pushl $4
80105cbb:	6a 04                	push   $0x4
  jmp alltraps
80105cbd:	e9 f3 fa ff ff       	jmp    801057b5 <alltraps>

80105cc2 <vector5>:
.globl vector5
vector5:
  pushl $0
80105cc2:	6a 00                	push   $0x0
  pushl $5
80105cc4:	6a 05                	push   $0x5
  jmp alltraps
80105cc6:	e9 ea fa ff ff       	jmp    801057b5 <alltraps>

80105ccb <vector6>:
.globl vector6
vector6:
  pushl $0
80105ccb:	6a 00                	push   $0x0
  pushl $6
80105ccd:	6a 06                	push   $0x6
  jmp alltraps
80105ccf:	e9 e1 fa ff ff       	jmp    801057b5 <alltraps>

80105cd4 <vector7>:
.globl vector7
vector7:
  pushl $0
80105cd4:	6a 00                	push   $0x0
  pushl $7
80105cd6:	6a 07                	push   $0x7
  jmp alltraps
80105cd8:	e9 d8 fa ff ff       	jmp    801057b5 <alltraps>

80105cdd <vector8>:
.globl vector8
vector8:
  pushl $8
80105cdd:	6a 08                	push   $0x8
  jmp alltraps
80105cdf:	e9 d1 fa ff ff       	jmp    801057b5 <alltraps>

80105ce4 <vector9>:
.globl vector9
vector9:
  pushl $0
80105ce4:	6a 00                	push   $0x0
  pushl $9
80105ce6:	6a 09                	push   $0x9
  jmp alltraps
80105ce8:	e9 c8 fa ff ff       	jmp    801057b5 <alltraps>

80105ced <vector10>:
.globl vector10
vector10:
  pushl $10
80105ced:	6a 0a                	push   $0xa
  jmp alltraps
80105cef:	e9 c1 fa ff ff       	jmp    801057b5 <alltraps>

80105cf4 <vector11>:
.globl vector11
vector11:
  pushl $11
80105cf4:	6a 0b                	push   $0xb
  jmp alltraps
80105cf6:	e9 ba fa ff ff       	jmp    801057b5 <alltraps>

80105cfb <vector12>:
.globl vector12
vector12:
  pushl $12
80105cfb:	6a 0c                	push   $0xc
  jmp alltraps
80105cfd:	e9 b3 fa ff ff       	jmp    801057b5 <alltraps>

80105d02 <vector13>:
.globl vector13
vector13:
  pushl $13
80105d02:	6a 0d                	push   $0xd
  jmp alltraps
80105d04:	e9 ac fa ff ff       	jmp    801057b5 <alltraps>

80105d09 <vector14>:
.globl vector14
vector14:
  pushl $14
80105d09:	6a 0e                	push   $0xe
  jmp alltraps
80105d0b:	e9 a5 fa ff ff       	jmp    801057b5 <alltraps>

80105d10 <vector15>:
.globl vector15
vector15:
  pushl $0
80105d10:	6a 00                	push   $0x0
  pushl $15
80105d12:	6a 0f                	push   $0xf
  jmp alltraps
80105d14:	e9 9c fa ff ff       	jmp    801057b5 <alltraps>

80105d19 <vector16>:
.globl vector16
vector16:
  pushl $0
80105d19:	6a 00                	push   $0x0
  pushl $16
80105d1b:	6a 10                	push   $0x10
  jmp alltraps
80105d1d:	e9 93 fa ff ff       	jmp    801057b5 <alltraps>

80105d22 <vector17>:
.globl vector17
vector17:
  pushl $17
80105d22:	6a 11                	push   $0x11
  jmp alltraps
80105d24:	e9 8c fa ff ff       	jmp    801057b5 <alltraps>

80105d29 <vector18>:
.globl vector18
vector18:
  pushl $0
80105d29:	6a 00                	push   $0x0
  pushl $18
80105d2b:	6a 12                	push   $0x12
  jmp alltraps
80105d2d:	e9 83 fa ff ff       	jmp    801057b5 <alltraps>

80105d32 <vector19>:
.globl vector19
vector19:
  pushl $0
80105d32:	6a 00                	push   $0x0
  pushl $19
80105d34:	6a 13                	push   $0x13
  jmp alltraps
80105d36:	e9 7a fa ff ff       	jmp    801057b5 <alltraps>

80105d3b <vector20>:
.globl vector20
vector20:
  pushl $0
80105d3b:	6a 00                	push   $0x0
  pushl $20
80105d3d:	6a 14                	push   $0x14
  jmp alltraps
80105d3f:	e9 71 fa ff ff       	jmp    801057b5 <alltraps>

80105d44 <vector21>:
.globl vector21
vector21:
  pushl $0
80105d44:	6a 00                	push   $0x0
  pushl $21
80105d46:	6a 15                	push   $0x15
  jmp alltraps
80105d48:	e9 68 fa ff ff       	jmp    801057b5 <alltraps>

80105d4d <vector22>:
.globl vector22
vector22:
  pushl $0
80105d4d:	6a 00                	push   $0x0
  pushl $22
80105d4f:	6a 16                	push   $0x16
  jmp alltraps
80105d51:	e9 5f fa ff ff       	jmp    801057b5 <alltraps>

80105d56 <vector23>:
.globl vector23
vector23:
  pushl $0
80105d56:	6a 00                	push   $0x0
  pushl $23
80105d58:	6a 17                	push   $0x17
  jmp alltraps
80105d5a:	e9 56 fa ff ff       	jmp    801057b5 <alltraps>

80105d5f <vector24>:
.globl vector24
vector24:
  pushl $0
80105d5f:	6a 00                	push   $0x0
  pushl $24
80105d61:	6a 18                	push   $0x18
  jmp alltraps
80105d63:	e9 4d fa ff ff       	jmp    801057b5 <alltraps>

80105d68 <vector25>:
.globl vector25
vector25:
  pushl $0
80105d68:	6a 00                	push   $0x0
  pushl $25
80105d6a:	6a 19                	push   $0x19
  jmp alltraps
80105d6c:	e9 44 fa ff ff       	jmp    801057b5 <alltraps>

80105d71 <vector26>:
.globl vector26
vector26:
  pushl $0
80105d71:	6a 00                	push   $0x0
  pushl $26
80105d73:	6a 1a                	push   $0x1a
  jmp alltraps
80105d75:	e9 3b fa ff ff       	jmp    801057b5 <alltraps>

80105d7a <vector27>:
.globl vector27
vector27:
  pushl $0
80105d7a:	6a 00                	push   $0x0
  pushl $27
80105d7c:	6a 1b                	push   $0x1b
  jmp alltraps
80105d7e:	e9 32 fa ff ff       	jmp    801057b5 <alltraps>

80105d83 <vector28>:
.globl vector28
vector28:
  pushl $0
80105d83:	6a 00                	push   $0x0
  pushl $28
80105d85:	6a 1c                	push   $0x1c
  jmp alltraps
80105d87:	e9 29 fa ff ff       	jmp    801057b5 <alltraps>

80105d8c <vector29>:
.globl vector29
vector29:
  pushl $0
80105d8c:	6a 00                	push   $0x0
  pushl $29
80105d8e:	6a 1d                	push   $0x1d
  jmp alltraps
80105d90:	e9 20 fa ff ff       	jmp    801057b5 <alltraps>

80105d95 <vector30>:
.globl vector30
vector30:
  pushl $0
80105d95:	6a 00                	push   $0x0
  pushl $30
80105d97:	6a 1e                	push   $0x1e
  jmp alltraps
80105d99:	e9 17 fa ff ff       	jmp    801057b5 <alltraps>

80105d9e <vector31>:
.globl vector31
vector31:
  pushl $0
80105d9e:	6a 00                	push   $0x0
  pushl $31
80105da0:	6a 1f                	push   $0x1f
  jmp alltraps
80105da2:	e9 0e fa ff ff       	jmp    801057b5 <alltraps>

80105da7 <vector32>:
.globl vector32
vector32:
  pushl $0
80105da7:	6a 00                	push   $0x0
  pushl $32
80105da9:	6a 20                	push   $0x20
  jmp alltraps
80105dab:	e9 05 fa ff ff       	jmp    801057b5 <alltraps>

80105db0 <vector33>:
.globl vector33
vector33:
  pushl $0
80105db0:	6a 00                	push   $0x0
  pushl $33
80105db2:	6a 21                	push   $0x21
  jmp alltraps
80105db4:	e9 fc f9 ff ff       	jmp    801057b5 <alltraps>

80105db9 <vector34>:
.globl vector34
vector34:
  pushl $0
80105db9:	6a 00                	push   $0x0
  pushl $34
80105dbb:	6a 22                	push   $0x22
  jmp alltraps
80105dbd:	e9 f3 f9 ff ff       	jmp    801057b5 <alltraps>

80105dc2 <vector35>:
.globl vector35
vector35:
  pushl $0
80105dc2:	6a 00                	push   $0x0
  pushl $35
80105dc4:	6a 23                	push   $0x23
  jmp alltraps
80105dc6:	e9 ea f9 ff ff       	jmp    801057b5 <alltraps>

80105dcb <vector36>:
.globl vector36
vector36:
  pushl $0
80105dcb:	6a 00                	push   $0x0
  pushl $36
80105dcd:	6a 24                	push   $0x24
  jmp alltraps
80105dcf:	e9 e1 f9 ff ff       	jmp    801057b5 <alltraps>

80105dd4 <vector37>:
.globl vector37
vector37:
  pushl $0
80105dd4:	6a 00                	push   $0x0
  pushl $37
80105dd6:	6a 25                	push   $0x25
  jmp alltraps
80105dd8:	e9 d8 f9 ff ff       	jmp    801057b5 <alltraps>

80105ddd <vector38>:
.globl vector38
vector38:
  pushl $0
80105ddd:	6a 00                	push   $0x0
  pushl $38
80105ddf:	6a 26                	push   $0x26
  jmp alltraps
80105de1:	e9 cf f9 ff ff       	jmp    801057b5 <alltraps>

80105de6 <vector39>:
.globl vector39
vector39:
  pushl $0
80105de6:	6a 00                	push   $0x0
  pushl $39
80105de8:	6a 27                	push   $0x27
  jmp alltraps
80105dea:	e9 c6 f9 ff ff       	jmp    801057b5 <alltraps>

80105def <vector40>:
.globl vector40
vector40:
  pushl $0
80105def:	6a 00                	push   $0x0
  pushl $40
80105df1:	6a 28                	push   $0x28
  jmp alltraps
80105df3:	e9 bd f9 ff ff       	jmp    801057b5 <alltraps>

80105df8 <vector41>:
.globl vector41
vector41:
  pushl $0
80105df8:	6a 00                	push   $0x0
  pushl $41
80105dfa:	6a 29                	push   $0x29
  jmp alltraps
80105dfc:	e9 b4 f9 ff ff       	jmp    801057b5 <alltraps>

80105e01 <vector42>:
.globl vector42
vector42:
  pushl $0
80105e01:	6a 00                	push   $0x0
  pushl $42
80105e03:	6a 2a                	push   $0x2a
  jmp alltraps
80105e05:	e9 ab f9 ff ff       	jmp    801057b5 <alltraps>

80105e0a <vector43>:
.globl vector43
vector43:
  pushl $0
80105e0a:	6a 00                	push   $0x0
  pushl $43
80105e0c:	6a 2b                	push   $0x2b
  jmp alltraps
80105e0e:	e9 a2 f9 ff ff       	jmp    801057b5 <alltraps>

80105e13 <vector44>:
.globl vector44
vector44:
  pushl $0
80105e13:	6a 00                	push   $0x0
  pushl $44
80105e15:	6a 2c                	push   $0x2c
  jmp alltraps
80105e17:	e9 99 f9 ff ff       	jmp    801057b5 <alltraps>

80105e1c <vector45>:
.globl vector45
vector45:
  pushl $0
80105e1c:	6a 00                	push   $0x0
  pushl $45
80105e1e:	6a 2d                	push   $0x2d
  jmp alltraps
80105e20:	e9 90 f9 ff ff       	jmp    801057b5 <alltraps>

80105e25 <vector46>:
.globl vector46
vector46:
  pushl $0
80105e25:	6a 00                	push   $0x0
  pushl $46
80105e27:	6a 2e                	push   $0x2e
  jmp alltraps
80105e29:	e9 87 f9 ff ff       	jmp    801057b5 <alltraps>

80105e2e <vector47>:
.globl vector47
vector47:
  pushl $0
80105e2e:	6a 00                	push   $0x0
  pushl $47
80105e30:	6a 2f                	push   $0x2f
  jmp alltraps
80105e32:	e9 7e f9 ff ff       	jmp    801057b5 <alltraps>

80105e37 <vector48>:
.globl vector48
vector48:
  pushl $0
80105e37:	6a 00                	push   $0x0
  pushl $48
80105e39:	6a 30                	push   $0x30
  jmp alltraps
80105e3b:	e9 75 f9 ff ff       	jmp    801057b5 <alltraps>

80105e40 <vector49>:
.globl vector49
vector49:
  pushl $0
80105e40:	6a 00                	push   $0x0
  pushl $49
80105e42:	6a 31                	push   $0x31
  jmp alltraps
80105e44:	e9 6c f9 ff ff       	jmp    801057b5 <alltraps>

80105e49 <vector50>:
.globl vector50
vector50:
  pushl $0
80105e49:	6a 00                	push   $0x0
  pushl $50
80105e4b:	6a 32                	push   $0x32
  jmp alltraps
80105e4d:	e9 63 f9 ff ff       	jmp    801057b5 <alltraps>

80105e52 <vector51>:
.globl vector51
vector51:
  pushl $0
80105e52:	6a 00                	push   $0x0
  pushl $51
80105e54:	6a 33                	push   $0x33
  jmp alltraps
80105e56:	e9 5a f9 ff ff       	jmp    801057b5 <alltraps>

80105e5b <vector52>:
.globl vector52
vector52:
  pushl $0
80105e5b:	6a 00                	push   $0x0
  pushl $52
80105e5d:	6a 34                	push   $0x34
  jmp alltraps
80105e5f:	e9 51 f9 ff ff       	jmp    801057b5 <alltraps>

80105e64 <vector53>:
.globl vector53
vector53:
  pushl $0
80105e64:	6a 00                	push   $0x0
  pushl $53
80105e66:	6a 35                	push   $0x35
  jmp alltraps
80105e68:	e9 48 f9 ff ff       	jmp    801057b5 <alltraps>

80105e6d <vector54>:
.globl vector54
vector54:
  pushl $0
80105e6d:	6a 00                	push   $0x0
  pushl $54
80105e6f:	6a 36                	push   $0x36
  jmp alltraps
80105e71:	e9 3f f9 ff ff       	jmp    801057b5 <alltraps>

80105e76 <vector55>:
.globl vector55
vector55:
  pushl $0
80105e76:	6a 00                	push   $0x0
  pushl $55
80105e78:	6a 37                	push   $0x37
  jmp alltraps
80105e7a:	e9 36 f9 ff ff       	jmp    801057b5 <alltraps>

80105e7f <vector56>:
.globl vector56
vector56:
  pushl $0
80105e7f:	6a 00                	push   $0x0
  pushl $56
80105e81:	6a 38                	push   $0x38
  jmp alltraps
80105e83:	e9 2d f9 ff ff       	jmp    801057b5 <alltraps>

80105e88 <vector57>:
.globl vector57
vector57:
  pushl $0
80105e88:	6a 00                	push   $0x0
  pushl $57
80105e8a:	6a 39                	push   $0x39
  jmp alltraps
80105e8c:	e9 24 f9 ff ff       	jmp    801057b5 <alltraps>

80105e91 <vector58>:
.globl vector58
vector58:
  pushl $0
80105e91:	6a 00                	push   $0x0
  pushl $58
80105e93:	6a 3a                	push   $0x3a
  jmp alltraps
80105e95:	e9 1b f9 ff ff       	jmp    801057b5 <alltraps>

80105e9a <vector59>:
.globl vector59
vector59:
  pushl $0
80105e9a:	6a 00                	push   $0x0
  pushl $59
80105e9c:	6a 3b                	push   $0x3b
  jmp alltraps
80105e9e:	e9 12 f9 ff ff       	jmp    801057b5 <alltraps>

80105ea3 <vector60>:
.globl vector60
vector60:
  pushl $0
80105ea3:	6a 00                	push   $0x0
  pushl $60
80105ea5:	6a 3c                	push   $0x3c
  jmp alltraps
80105ea7:	e9 09 f9 ff ff       	jmp    801057b5 <alltraps>

80105eac <vector61>:
.globl vector61
vector61:
  pushl $0
80105eac:	6a 00                	push   $0x0
  pushl $61
80105eae:	6a 3d                	push   $0x3d
  jmp alltraps
80105eb0:	e9 00 f9 ff ff       	jmp    801057b5 <alltraps>

80105eb5 <vector62>:
.globl vector62
vector62:
  pushl $0
80105eb5:	6a 00                	push   $0x0
  pushl $62
80105eb7:	6a 3e                	push   $0x3e
  jmp alltraps
80105eb9:	e9 f7 f8 ff ff       	jmp    801057b5 <alltraps>

80105ebe <vector63>:
.globl vector63
vector63:
  pushl $0
80105ebe:	6a 00                	push   $0x0
  pushl $63
80105ec0:	6a 3f                	push   $0x3f
  jmp alltraps
80105ec2:	e9 ee f8 ff ff       	jmp    801057b5 <alltraps>

80105ec7 <vector64>:
.globl vector64
vector64:
  pushl $0
80105ec7:	6a 00                	push   $0x0
  pushl $64
80105ec9:	6a 40                	push   $0x40
  jmp alltraps
80105ecb:	e9 e5 f8 ff ff       	jmp    801057b5 <alltraps>

80105ed0 <vector65>:
.globl vector65
vector65:
  pushl $0
80105ed0:	6a 00                	push   $0x0
  pushl $65
80105ed2:	6a 41                	push   $0x41
  jmp alltraps
80105ed4:	e9 dc f8 ff ff       	jmp    801057b5 <alltraps>

80105ed9 <vector66>:
.globl vector66
vector66:
  pushl $0
80105ed9:	6a 00                	push   $0x0
  pushl $66
80105edb:	6a 42                	push   $0x42
  jmp alltraps
80105edd:	e9 d3 f8 ff ff       	jmp    801057b5 <alltraps>

80105ee2 <vector67>:
.globl vector67
vector67:
  pushl $0
80105ee2:	6a 00                	push   $0x0
  pushl $67
80105ee4:	6a 43                	push   $0x43
  jmp alltraps
80105ee6:	e9 ca f8 ff ff       	jmp    801057b5 <alltraps>

80105eeb <vector68>:
.globl vector68
vector68:
  pushl $0
80105eeb:	6a 00                	push   $0x0
  pushl $68
80105eed:	6a 44                	push   $0x44
  jmp alltraps
80105eef:	e9 c1 f8 ff ff       	jmp    801057b5 <alltraps>

80105ef4 <vector69>:
.globl vector69
vector69:
  pushl $0
80105ef4:	6a 00                	push   $0x0
  pushl $69
80105ef6:	6a 45                	push   $0x45
  jmp alltraps
80105ef8:	e9 b8 f8 ff ff       	jmp    801057b5 <alltraps>

80105efd <vector70>:
.globl vector70
vector70:
  pushl $0
80105efd:	6a 00                	push   $0x0
  pushl $70
80105eff:	6a 46                	push   $0x46
  jmp alltraps
80105f01:	e9 af f8 ff ff       	jmp    801057b5 <alltraps>

80105f06 <vector71>:
.globl vector71
vector71:
  pushl $0
80105f06:	6a 00                	push   $0x0
  pushl $71
80105f08:	6a 47                	push   $0x47
  jmp alltraps
80105f0a:	e9 a6 f8 ff ff       	jmp    801057b5 <alltraps>

80105f0f <vector72>:
.globl vector72
vector72:
  pushl $0
80105f0f:	6a 00                	push   $0x0
  pushl $72
80105f11:	6a 48                	push   $0x48
  jmp alltraps
80105f13:	e9 9d f8 ff ff       	jmp    801057b5 <alltraps>

80105f18 <vector73>:
.globl vector73
vector73:
  pushl $0
80105f18:	6a 00                	push   $0x0
  pushl $73
80105f1a:	6a 49                	push   $0x49
  jmp alltraps
80105f1c:	e9 94 f8 ff ff       	jmp    801057b5 <alltraps>

80105f21 <vector74>:
.globl vector74
vector74:
  pushl $0
80105f21:	6a 00                	push   $0x0
  pushl $74
80105f23:	6a 4a                	push   $0x4a
  jmp alltraps
80105f25:	e9 8b f8 ff ff       	jmp    801057b5 <alltraps>

80105f2a <vector75>:
.globl vector75
vector75:
  pushl $0
80105f2a:	6a 00                	push   $0x0
  pushl $75
80105f2c:	6a 4b                	push   $0x4b
  jmp alltraps
80105f2e:	e9 82 f8 ff ff       	jmp    801057b5 <alltraps>

80105f33 <vector76>:
.globl vector76
vector76:
  pushl $0
80105f33:	6a 00                	push   $0x0
  pushl $76
80105f35:	6a 4c                	push   $0x4c
  jmp alltraps
80105f37:	e9 79 f8 ff ff       	jmp    801057b5 <alltraps>

80105f3c <vector77>:
.globl vector77
vector77:
  pushl $0
80105f3c:	6a 00                	push   $0x0
  pushl $77
80105f3e:	6a 4d                	push   $0x4d
  jmp alltraps
80105f40:	e9 70 f8 ff ff       	jmp    801057b5 <alltraps>

80105f45 <vector78>:
.globl vector78
vector78:
  pushl $0
80105f45:	6a 00                	push   $0x0
  pushl $78
80105f47:	6a 4e                	push   $0x4e
  jmp alltraps
80105f49:	e9 67 f8 ff ff       	jmp    801057b5 <alltraps>

80105f4e <vector79>:
.globl vector79
vector79:
  pushl $0
80105f4e:	6a 00                	push   $0x0
  pushl $79
80105f50:	6a 4f                	push   $0x4f
  jmp alltraps
80105f52:	e9 5e f8 ff ff       	jmp    801057b5 <alltraps>

80105f57 <vector80>:
.globl vector80
vector80:
  pushl $0
80105f57:	6a 00                	push   $0x0
  pushl $80
80105f59:	6a 50                	push   $0x50
  jmp alltraps
80105f5b:	e9 55 f8 ff ff       	jmp    801057b5 <alltraps>

80105f60 <vector81>:
.globl vector81
vector81:
  pushl $0
80105f60:	6a 00                	push   $0x0
  pushl $81
80105f62:	6a 51                	push   $0x51
  jmp alltraps
80105f64:	e9 4c f8 ff ff       	jmp    801057b5 <alltraps>

80105f69 <vector82>:
.globl vector82
vector82:
  pushl $0
80105f69:	6a 00                	push   $0x0
  pushl $82
80105f6b:	6a 52                	push   $0x52
  jmp alltraps
80105f6d:	e9 43 f8 ff ff       	jmp    801057b5 <alltraps>

80105f72 <vector83>:
.globl vector83
vector83:
  pushl $0
80105f72:	6a 00                	push   $0x0
  pushl $83
80105f74:	6a 53                	push   $0x53
  jmp alltraps
80105f76:	e9 3a f8 ff ff       	jmp    801057b5 <alltraps>

80105f7b <vector84>:
.globl vector84
vector84:
  pushl $0
80105f7b:	6a 00                	push   $0x0
  pushl $84
80105f7d:	6a 54                	push   $0x54
  jmp alltraps
80105f7f:	e9 31 f8 ff ff       	jmp    801057b5 <alltraps>

80105f84 <vector85>:
.globl vector85
vector85:
  pushl $0
80105f84:	6a 00                	push   $0x0
  pushl $85
80105f86:	6a 55                	push   $0x55
  jmp alltraps
80105f88:	e9 28 f8 ff ff       	jmp    801057b5 <alltraps>

80105f8d <vector86>:
.globl vector86
vector86:
  pushl $0
80105f8d:	6a 00                	push   $0x0
  pushl $86
80105f8f:	6a 56                	push   $0x56
  jmp alltraps
80105f91:	e9 1f f8 ff ff       	jmp    801057b5 <alltraps>

80105f96 <vector87>:
.globl vector87
vector87:
  pushl $0
80105f96:	6a 00                	push   $0x0
  pushl $87
80105f98:	6a 57                	push   $0x57
  jmp alltraps
80105f9a:	e9 16 f8 ff ff       	jmp    801057b5 <alltraps>

80105f9f <vector88>:
.globl vector88
vector88:
  pushl $0
80105f9f:	6a 00                	push   $0x0
  pushl $88
80105fa1:	6a 58                	push   $0x58
  jmp alltraps
80105fa3:	e9 0d f8 ff ff       	jmp    801057b5 <alltraps>

80105fa8 <vector89>:
.globl vector89
vector89:
  pushl $0
80105fa8:	6a 00                	push   $0x0
  pushl $89
80105faa:	6a 59                	push   $0x59
  jmp alltraps
80105fac:	e9 04 f8 ff ff       	jmp    801057b5 <alltraps>

80105fb1 <vector90>:
.globl vector90
vector90:
  pushl $0
80105fb1:	6a 00                	push   $0x0
  pushl $90
80105fb3:	6a 5a                	push   $0x5a
  jmp alltraps
80105fb5:	e9 fb f7 ff ff       	jmp    801057b5 <alltraps>

80105fba <vector91>:
.globl vector91
vector91:
  pushl $0
80105fba:	6a 00                	push   $0x0
  pushl $91
80105fbc:	6a 5b                	push   $0x5b
  jmp alltraps
80105fbe:	e9 f2 f7 ff ff       	jmp    801057b5 <alltraps>

80105fc3 <vector92>:
.globl vector92
vector92:
  pushl $0
80105fc3:	6a 00                	push   $0x0
  pushl $92
80105fc5:	6a 5c                	push   $0x5c
  jmp alltraps
80105fc7:	e9 e9 f7 ff ff       	jmp    801057b5 <alltraps>

80105fcc <vector93>:
.globl vector93
vector93:
  pushl $0
80105fcc:	6a 00                	push   $0x0
  pushl $93
80105fce:	6a 5d                	push   $0x5d
  jmp alltraps
80105fd0:	e9 e0 f7 ff ff       	jmp    801057b5 <alltraps>

80105fd5 <vector94>:
.globl vector94
vector94:
  pushl $0
80105fd5:	6a 00                	push   $0x0
  pushl $94
80105fd7:	6a 5e                	push   $0x5e
  jmp alltraps
80105fd9:	e9 d7 f7 ff ff       	jmp    801057b5 <alltraps>

80105fde <vector95>:
.globl vector95
vector95:
  pushl $0
80105fde:	6a 00                	push   $0x0
  pushl $95
80105fe0:	6a 5f                	push   $0x5f
  jmp alltraps
80105fe2:	e9 ce f7 ff ff       	jmp    801057b5 <alltraps>

80105fe7 <vector96>:
.globl vector96
vector96:
  pushl $0
80105fe7:	6a 00                	push   $0x0
  pushl $96
80105fe9:	6a 60                	push   $0x60
  jmp alltraps
80105feb:	e9 c5 f7 ff ff       	jmp    801057b5 <alltraps>

80105ff0 <vector97>:
.globl vector97
vector97:
  pushl $0
80105ff0:	6a 00                	push   $0x0
  pushl $97
80105ff2:	6a 61                	push   $0x61
  jmp alltraps
80105ff4:	e9 bc f7 ff ff       	jmp    801057b5 <alltraps>

80105ff9 <vector98>:
.globl vector98
vector98:
  pushl $0
80105ff9:	6a 00                	push   $0x0
  pushl $98
80105ffb:	6a 62                	push   $0x62
  jmp alltraps
80105ffd:	e9 b3 f7 ff ff       	jmp    801057b5 <alltraps>

80106002 <vector99>:
.globl vector99
vector99:
  pushl $0
80106002:	6a 00                	push   $0x0
  pushl $99
80106004:	6a 63                	push   $0x63
  jmp alltraps
80106006:	e9 aa f7 ff ff       	jmp    801057b5 <alltraps>

8010600b <vector100>:
.globl vector100
vector100:
  pushl $0
8010600b:	6a 00                	push   $0x0
  pushl $100
8010600d:	6a 64                	push   $0x64
  jmp alltraps
8010600f:	e9 a1 f7 ff ff       	jmp    801057b5 <alltraps>

80106014 <vector101>:
.globl vector101
vector101:
  pushl $0
80106014:	6a 00                	push   $0x0
  pushl $101
80106016:	6a 65                	push   $0x65
  jmp alltraps
80106018:	e9 98 f7 ff ff       	jmp    801057b5 <alltraps>

8010601d <vector102>:
.globl vector102
vector102:
  pushl $0
8010601d:	6a 00                	push   $0x0
  pushl $102
8010601f:	6a 66                	push   $0x66
  jmp alltraps
80106021:	e9 8f f7 ff ff       	jmp    801057b5 <alltraps>

80106026 <vector103>:
.globl vector103
vector103:
  pushl $0
80106026:	6a 00                	push   $0x0
  pushl $103
80106028:	6a 67                	push   $0x67
  jmp alltraps
8010602a:	e9 86 f7 ff ff       	jmp    801057b5 <alltraps>

8010602f <vector104>:
.globl vector104
vector104:
  pushl $0
8010602f:	6a 00                	push   $0x0
  pushl $104
80106031:	6a 68                	push   $0x68
  jmp alltraps
80106033:	e9 7d f7 ff ff       	jmp    801057b5 <alltraps>

80106038 <vector105>:
.globl vector105
vector105:
  pushl $0
80106038:	6a 00                	push   $0x0
  pushl $105
8010603a:	6a 69                	push   $0x69
  jmp alltraps
8010603c:	e9 74 f7 ff ff       	jmp    801057b5 <alltraps>

80106041 <vector106>:
.globl vector106
vector106:
  pushl $0
80106041:	6a 00                	push   $0x0
  pushl $106
80106043:	6a 6a                	push   $0x6a
  jmp alltraps
80106045:	e9 6b f7 ff ff       	jmp    801057b5 <alltraps>

8010604a <vector107>:
.globl vector107
vector107:
  pushl $0
8010604a:	6a 00                	push   $0x0
  pushl $107
8010604c:	6a 6b                	push   $0x6b
  jmp alltraps
8010604e:	e9 62 f7 ff ff       	jmp    801057b5 <alltraps>

80106053 <vector108>:
.globl vector108
vector108:
  pushl $0
80106053:	6a 00                	push   $0x0
  pushl $108
80106055:	6a 6c                	push   $0x6c
  jmp alltraps
80106057:	e9 59 f7 ff ff       	jmp    801057b5 <alltraps>

8010605c <vector109>:
.globl vector109
vector109:
  pushl $0
8010605c:	6a 00                	push   $0x0
  pushl $109
8010605e:	6a 6d                	push   $0x6d
  jmp alltraps
80106060:	e9 50 f7 ff ff       	jmp    801057b5 <alltraps>

80106065 <vector110>:
.globl vector110
vector110:
  pushl $0
80106065:	6a 00                	push   $0x0
  pushl $110
80106067:	6a 6e                	push   $0x6e
  jmp alltraps
80106069:	e9 47 f7 ff ff       	jmp    801057b5 <alltraps>

8010606e <vector111>:
.globl vector111
vector111:
  pushl $0
8010606e:	6a 00                	push   $0x0
  pushl $111
80106070:	6a 6f                	push   $0x6f
  jmp alltraps
80106072:	e9 3e f7 ff ff       	jmp    801057b5 <alltraps>

80106077 <vector112>:
.globl vector112
vector112:
  pushl $0
80106077:	6a 00                	push   $0x0
  pushl $112
80106079:	6a 70                	push   $0x70
  jmp alltraps
8010607b:	e9 35 f7 ff ff       	jmp    801057b5 <alltraps>

80106080 <vector113>:
.globl vector113
vector113:
  pushl $0
80106080:	6a 00                	push   $0x0
  pushl $113
80106082:	6a 71                	push   $0x71
  jmp alltraps
80106084:	e9 2c f7 ff ff       	jmp    801057b5 <alltraps>

80106089 <vector114>:
.globl vector114
vector114:
  pushl $0
80106089:	6a 00                	push   $0x0
  pushl $114
8010608b:	6a 72                	push   $0x72
  jmp alltraps
8010608d:	e9 23 f7 ff ff       	jmp    801057b5 <alltraps>

80106092 <vector115>:
.globl vector115
vector115:
  pushl $0
80106092:	6a 00                	push   $0x0
  pushl $115
80106094:	6a 73                	push   $0x73
  jmp alltraps
80106096:	e9 1a f7 ff ff       	jmp    801057b5 <alltraps>

8010609b <vector116>:
.globl vector116
vector116:
  pushl $0
8010609b:	6a 00                	push   $0x0
  pushl $116
8010609d:	6a 74                	push   $0x74
  jmp alltraps
8010609f:	e9 11 f7 ff ff       	jmp    801057b5 <alltraps>

801060a4 <vector117>:
.globl vector117
vector117:
  pushl $0
801060a4:	6a 00                	push   $0x0
  pushl $117
801060a6:	6a 75                	push   $0x75
  jmp alltraps
801060a8:	e9 08 f7 ff ff       	jmp    801057b5 <alltraps>

801060ad <vector118>:
.globl vector118
vector118:
  pushl $0
801060ad:	6a 00                	push   $0x0
  pushl $118
801060af:	6a 76                	push   $0x76
  jmp alltraps
801060b1:	e9 ff f6 ff ff       	jmp    801057b5 <alltraps>

801060b6 <vector119>:
.globl vector119
vector119:
  pushl $0
801060b6:	6a 00                	push   $0x0
  pushl $119
801060b8:	6a 77                	push   $0x77
  jmp alltraps
801060ba:	e9 f6 f6 ff ff       	jmp    801057b5 <alltraps>

801060bf <vector120>:
.globl vector120
vector120:
  pushl $0
801060bf:	6a 00                	push   $0x0
  pushl $120
801060c1:	6a 78                	push   $0x78
  jmp alltraps
801060c3:	e9 ed f6 ff ff       	jmp    801057b5 <alltraps>

801060c8 <vector121>:
.globl vector121
vector121:
  pushl $0
801060c8:	6a 00                	push   $0x0
  pushl $121
801060ca:	6a 79                	push   $0x79
  jmp alltraps
801060cc:	e9 e4 f6 ff ff       	jmp    801057b5 <alltraps>

801060d1 <vector122>:
.globl vector122
vector122:
  pushl $0
801060d1:	6a 00                	push   $0x0
  pushl $122
801060d3:	6a 7a                	push   $0x7a
  jmp alltraps
801060d5:	e9 db f6 ff ff       	jmp    801057b5 <alltraps>

801060da <vector123>:
.globl vector123
vector123:
  pushl $0
801060da:	6a 00                	push   $0x0
  pushl $123
801060dc:	6a 7b                	push   $0x7b
  jmp alltraps
801060de:	e9 d2 f6 ff ff       	jmp    801057b5 <alltraps>

801060e3 <vector124>:
.globl vector124
vector124:
  pushl $0
801060e3:	6a 00                	push   $0x0
  pushl $124
801060e5:	6a 7c                	push   $0x7c
  jmp alltraps
801060e7:	e9 c9 f6 ff ff       	jmp    801057b5 <alltraps>

801060ec <vector125>:
.globl vector125
vector125:
  pushl $0
801060ec:	6a 00                	push   $0x0
  pushl $125
801060ee:	6a 7d                	push   $0x7d
  jmp alltraps
801060f0:	e9 c0 f6 ff ff       	jmp    801057b5 <alltraps>

801060f5 <vector126>:
.globl vector126
vector126:
  pushl $0
801060f5:	6a 00                	push   $0x0
  pushl $126
801060f7:	6a 7e                	push   $0x7e
  jmp alltraps
801060f9:	e9 b7 f6 ff ff       	jmp    801057b5 <alltraps>

801060fe <vector127>:
.globl vector127
vector127:
  pushl $0
801060fe:	6a 00                	push   $0x0
  pushl $127
80106100:	6a 7f                	push   $0x7f
  jmp alltraps
80106102:	e9 ae f6 ff ff       	jmp    801057b5 <alltraps>

80106107 <vector128>:
.globl vector128
vector128:
  pushl $0
80106107:	6a 00                	push   $0x0
  pushl $128
80106109:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010610e:	e9 a2 f6 ff ff       	jmp    801057b5 <alltraps>

80106113 <vector129>:
.globl vector129
vector129:
  pushl $0
80106113:	6a 00                	push   $0x0
  pushl $129
80106115:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010611a:	e9 96 f6 ff ff       	jmp    801057b5 <alltraps>

8010611f <vector130>:
.globl vector130
vector130:
  pushl $0
8010611f:	6a 00                	push   $0x0
  pushl $130
80106121:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106126:	e9 8a f6 ff ff       	jmp    801057b5 <alltraps>

8010612b <vector131>:
.globl vector131
vector131:
  pushl $0
8010612b:	6a 00                	push   $0x0
  pushl $131
8010612d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106132:	e9 7e f6 ff ff       	jmp    801057b5 <alltraps>

80106137 <vector132>:
.globl vector132
vector132:
  pushl $0
80106137:	6a 00                	push   $0x0
  pushl $132
80106139:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010613e:	e9 72 f6 ff ff       	jmp    801057b5 <alltraps>

80106143 <vector133>:
.globl vector133
vector133:
  pushl $0
80106143:	6a 00                	push   $0x0
  pushl $133
80106145:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010614a:	e9 66 f6 ff ff       	jmp    801057b5 <alltraps>

8010614f <vector134>:
.globl vector134
vector134:
  pushl $0
8010614f:	6a 00                	push   $0x0
  pushl $134
80106151:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106156:	e9 5a f6 ff ff       	jmp    801057b5 <alltraps>

8010615b <vector135>:
.globl vector135
vector135:
  pushl $0
8010615b:	6a 00                	push   $0x0
  pushl $135
8010615d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106162:	e9 4e f6 ff ff       	jmp    801057b5 <alltraps>

80106167 <vector136>:
.globl vector136
vector136:
  pushl $0
80106167:	6a 00                	push   $0x0
  pushl $136
80106169:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010616e:	e9 42 f6 ff ff       	jmp    801057b5 <alltraps>

80106173 <vector137>:
.globl vector137
vector137:
  pushl $0
80106173:	6a 00                	push   $0x0
  pushl $137
80106175:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010617a:	e9 36 f6 ff ff       	jmp    801057b5 <alltraps>

8010617f <vector138>:
.globl vector138
vector138:
  pushl $0
8010617f:	6a 00                	push   $0x0
  pushl $138
80106181:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106186:	e9 2a f6 ff ff       	jmp    801057b5 <alltraps>

8010618b <vector139>:
.globl vector139
vector139:
  pushl $0
8010618b:	6a 00                	push   $0x0
  pushl $139
8010618d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106192:	e9 1e f6 ff ff       	jmp    801057b5 <alltraps>

80106197 <vector140>:
.globl vector140
vector140:
  pushl $0
80106197:	6a 00                	push   $0x0
  pushl $140
80106199:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010619e:	e9 12 f6 ff ff       	jmp    801057b5 <alltraps>

801061a3 <vector141>:
.globl vector141
vector141:
  pushl $0
801061a3:	6a 00                	push   $0x0
  pushl $141
801061a5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801061aa:	e9 06 f6 ff ff       	jmp    801057b5 <alltraps>

801061af <vector142>:
.globl vector142
vector142:
  pushl $0
801061af:	6a 00                	push   $0x0
  pushl $142
801061b1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801061b6:	e9 fa f5 ff ff       	jmp    801057b5 <alltraps>

801061bb <vector143>:
.globl vector143
vector143:
  pushl $0
801061bb:	6a 00                	push   $0x0
  pushl $143
801061bd:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801061c2:	e9 ee f5 ff ff       	jmp    801057b5 <alltraps>

801061c7 <vector144>:
.globl vector144
vector144:
  pushl $0
801061c7:	6a 00                	push   $0x0
  pushl $144
801061c9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801061ce:	e9 e2 f5 ff ff       	jmp    801057b5 <alltraps>

801061d3 <vector145>:
.globl vector145
vector145:
  pushl $0
801061d3:	6a 00                	push   $0x0
  pushl $145
801061d5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801061da:	e9 d6 f5 ff ff       	jmp    801057b5 <alltraps>

801061df <vector146>:
.globl vector146
vector146:
  pushl $0
801061df:	6a 00                	push   $0x0
  pushl $146
801061e1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801061e6:	e9 ca f5 ff ff       	jmp    801057b5 <alltraps>

801061eb <vector147>:
.globl vector147
vector147:
  pushl $0
801061eb:	6a 00                	push   $0x0
  pushl $147
801061ed:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801061f2:	e9 be f5 ff ff       	jmp    801057b5 <alltraps>

801061f7 <vector148>:
.globl vector148
vector148:
  pushl $0
801061f7:	6a 00                	push   $0x0
  pushl $148
801061f9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801061fe:	e9 b2 f5 ff ff       	jmp    801057b5 <alltraps>

80106203 <vector149>:
.globl vector149
vector149:
  pushl $0
80106203:	6a 00                	push   $0x0
  pushl $149
80106205:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010620a:	e9 a6 f5 ff ff       	jmp    801057b5 <alltraps>

8010620f <vector150>:
.globl vector150
vector150:
  pushl $0
8010620f:	6a 00                	push   $0x0
  pushl $150
80106211:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106216:	e9 9a f5 ff ff       	jmp    801057b5 <alltraps>

8010621b <vector151>:
.globl vector151
vector151:
  pushl $0
8010621b:	6a 00                	push   $0x0
  pushl $151
8010621d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106222:	e9 8e f5 ff ff       	jmp    801057b5 <alltraps>

80106227 <vector152>:
.globl vector152
vector152:
  pushl $0
80106227:	6a 00                	push   $0x0
  pushl $152
80106229:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010622e:	e9 82 f5 ff ff       	jmp    801057b5 <alltraps>

80106233 <vector153>:
.globl vector153
vector153:
  pushl $0
80106233:	6a 00                	push   $0x0
  pushl $153
80106235:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010623a:	e9 76 f5 ff ff       	jmp    801057b5 <alltraps>

8010623f <vector154>:
.globl vector154
vector154:
  pushl $0
8010623f:	6a 00                	push   $0x0
  pushl $154
80106241:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106246:	e9 6a f5 ff ff       	jmp    801057b5 <alltraps>

8010624b <vector155>:
.globl vector155
vector155:
  pushl $0
8010624b:	6a 00                	push   $0x0
  pushl $155
8010624d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106252:	e9 5e f5 ff ff       	jmp    801057b5 <alltraps>

80106257 <vector156>:
.globl vector156
vector156:
  pushl $0
80106257:	6a 00                	push   $0x0
  pushl $156
80106259:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010625e:	e9 52 f5 ff ff       	jmp    801057b5 <alltraps>

80106263 <vector157>:
.globl vector157
vector157:
  pushl $0
80106263:	6a 00                	push   $0x0
  pushl $157
80106265:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010626a:	e9 46 f5 ff ff       	jmp    801057b5 <alltraps>

8010626f <vector158>:
.globl vector158
vector158:
  pushl $0
8010626f:	6a 00                	push   $0x0
  pushl $158
80106271:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106276:	e9 3a f5 ff ff       	jmp    801057b5 <alltraps>

8010627b <vector159>:
.globl vector159
vector159:
  pushl $0
8010627b:	6a 00                	push   $0x0
  pushl $159
8010627d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106282:	e9 2e f5 ff ff       	jmp    801057b5 <alltraps>

80106287 <vector160>:
.globl vector160
vector160:
  pushl $0
80106287:	6a 00                	push   $0x0
  pushl $160
80106289:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010628e:	e9 22 f5 ff ff       	jmp    801057b5 <alltraps>

80106293 <vector161>:
.globl vector161
vector161:
  pushl $0
80106293:	6a 00                	push   $0x0
  pushl $161
80106295:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010629a:	e9 16 f5 ff ff       	jmp    801057b5 <alltraps>

8010629f <vector162>:
.globl vector162
vector162:
  pushl $0
8010629f:	6a 00                	push   $0x0
  pushl $162
801062a1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801062a6:	e9 0a f5 ff ff       	jmp    801057b5 <alltraps>

801062ab <vector163>:
.globl vector163
vector163:
  pushl $0
801062ab:	6a 00                	push   $0x0
  pushl $163
801062ad:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801062b2:	e9 fe f4 ff ff       	jmp    801057b5 <alltraps>

801062b7 <vector164>:
.globl vector164
vector164:
  pushl $0
801062b7:	6a 00                	push   $0x0
  pushl $164
801062b9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801062be:	e9 f2 f4 ff ff       	jmp    801057b5 <alltraps>

801062c3 <vector165>:
.globl vector165
vector165:
  pushl $0
801062c3:	6a 00                	push   $0x0
  pushl $165
801062c5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801062ca:	e9 e6 f4 ff ff       	jmp    801057b5 <alltraps>

801062cf <vector166>:
.globl vector166
vector166:
  pushl $0
801062cf:	6a 00                	push   $0x0
  pushl $166
801062d1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801062d6:	e9 da f4 ff ff       	jmp    801057b5 <alltraps>

801062db <vector167>:
.globl vector167
vector167:
  pushl $0
801062db:	6a 00                	push   $0x0
  pushl $167
801062dd:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801062e2:	e9 ce f4 ff ff       	jmp    801057b5 <alltraps>

801062e7 <vector168>:
.globl vector168
vector168:
  pushl $0
801062e7:	6a 00                	push   $0x0
  pushl $168
801062e9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801062ee:	e9 c2 f4 ff ff       	jmp    801057b5 <alltraps>

801062f3 <vector169>:
.globl vector169
vector169:
  pushl $0
801062f3:	6a 00                	push   $0x0
  pushl $169
801062f5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801062fa:	e9 b6 f4 ff ff       	jmp    801057b5 <alltraps>

801062ff <vector170>:
.globl vector170
vector170:
  pushl $0
801062ff:	6a 00                	push   $0x0
  pushl $170
80106301:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106306:	e9 aa f4 ff ff       	jmp    801057b5 <alltraps>

8010630b <vector171>:
.globl vector171
vector171:
  pushl $0
8010630b:	6a 00                	push   $0x0
  pushl $171
8010630d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106312:	e9 9e f4 ff ff       	jmp    801057b5 <alltraps>

80106317 <vector172>:
.globl vector172
vector172:
  pushl $0
80106317:	6a 00                	push   $0x0
  pushl $172
80106319:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010631e:	e9 92 f4 ff ff       	jmp    801057b5 <alltraps>

80106323 <vector173>:
.globl vector173
vector173:
  pushl $0
80106323:	6a 00                	push   $0x0
  pushl $173
80106325:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010632a:	e9 86 f4 ff ff       	jmp    801057b5 <alltraps>

8010632f <vector174>:
.globl vector174
vector174:
  pushl $0
8010632f:	6a 00                	push   $0x0
  pushl $174
80106331:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106336:	e9 7a f4 ff ff       	jmp    801057b5 <alltraps>

8010633b <vector175>:
.globl vector175
vector175:
  pushl $0
8010633b:	6a 00                	push   $0x0
  pushl $175
8010633d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106342:	e9 6e f4 ff ff       	jmp    801057b5 <alltraps>

80106347 <vector176>:
.globl vector176
vector176:
  pushl $0
80106347:	6a 00                	push   $0x0
  pushl $176
80106349:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010634e:	e9 62 f4 ff ff       	jmp    801057b5 <alltraps>

80106353 <vector177>:
.globl vector177
vector177:
  pushl $0
80106353:	6a 00                	push   $0x0
  pushl $177
80106355:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010635a:	e9 56 f4 ff ff       	jmp    801057b5 <alltraps>

8010635f <vector178>:
.globl vector178
vector178:
  pushl $0
8010635f:	6a 00                	push   $0x0
  pushl $178
80106361:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106366:	e9 4a f4 ff ff       	jmp    801057b5 <alltraps>

8010636b <vector179>:
.globl vector179
vector179:
  pushl $0
8010636b:	6a 00                	push   $0x0
  pushl $179
8010636d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106372:	e9 3e f4 ff ff       	jmp    801057b5 <alltraps>

80106377 <vector180>:
.globl vector180
vector180:
  pushl $0
80106377:	6a 00                	push   $0x0
  pushl $180
80106379:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010637e:	e9 32 f4 ff ff       	jmp    801057b5 <alltraps>

80106383 <vector181>:
.globl vector181
vector181:
  pushl $0
80106383:	6a 00                	push   $0x0
  pushl $181
80106385:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010638a:	e9 26 f4 ff ff       	jmp    801057b5 <alltraps>

8010638f <vector182>:
.globl vector182
vector182:
  pushl $0
8010638f:	6a 00                	push   $0x0
  pushl $182
80106391:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106396:	e9 1a f4 ff ff       	jmp    801057b5 <alltraps>

8010639b <vector183>:
.globl vector183
vector183:
  pushl $0
8010639b:	6a 00                	push   $0x0
  pushl $183
8010639d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801063a2:	e9 0e f4 ff ff       	jmp    801057b5 <alltraps>

801063a7 <vector184>:
.globl vector184
vector184:
  pushl $0
801063a7:	6a 00                	push   $0x0
  pushl $184
801063a9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801063ae:	e9 02 f4 ff ff       	jmp    801057b5 <alltraps>

801063b3 <vector185>:
.globl vector185
vector185:
  pushl $0
801063b3:	6a 00                	push   $0x0
  pushl $185
801063b5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801063ba:	e9 f6 f3 ff ff       	jmp    801057b5 <alltraps>

801063bf <vector186>:
.globl vector186
vector186:
  pushl $0
801063bf:	6a 00                	push   $0x0
  pushl $186
801063c1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801063c6:	e9 ea f3 ff ff       	jmp    801057b5 <alltraps>

801063cb <vector187>:
.globl vector187
vector187:
  pushl $0
801063cb:	6a 00                	push   $0x0
  pushl $187
801063cd:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801063d2:	e9 de f3 ff ff       	jmp    801057b5 <alltraps>

801063d7 <vector188>:
.globl vector188
vector188:
  pushl $0
801063d7:	6a 00                	push   $0x0
  pushl $188
801063d9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801063de:	e9 d2 f3 ff ff       	jmp    801057b5 <alltraps>

801063e3 <vector189>:
.globl vector189
vector189:
  pushl $0
801063e3:	6a 00                	push   $0x0
  pushl $189
801063e5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801063ea:	e9 c6 f3 ff ff       	jmp    801057b5 <alltraps>

801063ef <vector190>:
.globl vector190
vector190:
  pushl $0
801063ef:	6a 00                	push   $0x0
  pushl $190
801063f1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801063f6:	e9 ba f3 ff ff       	jmp    801057b5 <alltraps>

801063fb <vector191>:
.globl vector191
vector191:
  pushl $0
801063fb:	6a 00                	push   $0x0
  pushl $191
801063fd:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106402:	e9 ae f3 ff ff       	jmp    801057b5 <alltraps>

80106407 <vector192>:
.globl vector192
vector192:
  pushl $0
80106407:	6a 00                	push   $0x0
  pushl $192
80106409:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010640e:	e9 a2 f3 ff ff       	jmp    801057b5 <alltraps>

80106413 <vector193>:
.globl vector193
vector193:
  pushl $0
80106413:	6a 00                	push   $0x0
  pushl $193
80106415:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010641a:	e9 96 f3 ff ff       	jmp    801057b5 <alltraps>

8010641f <vector194>:
.globl vector194
vector194:
  pushl $0
8010641f:	6a 00                	push   $0x0
  pushl $194
80106421:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106426:	e9 8a f3 ff ff       	jmp    801057b5 <alltraps>

8010642b <vector195>:
.globl vector195
vector195:
  pushl $0
8010642b:	6a 00                	push   $0x0
  pushl $195
8010642d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106432:	e9 7e f3 ff ff       	jmp    801057b5 <alltraps>

80106437 <vector196>:
.globl vector196
vector196:
  pushl $0
80106437:	6a 00                	push   $0x0
  pushl $196
80106439:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010643e:	e9 72 f3 ff ff       	jmp    801057b5 <alltraps>

80106443 <vector197>:
.globl vector197
vector197:
  pushl $0
80106443:	6a 00                	push   $0x0
  pushl $197
80106445:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010644a:	e9 66 f3 ff ff       	jmp    801057b5 <alltraps>

8010644f <vector198>:
.globl vector198
vector198:
  pushl $0
8010644f:	6a 00                	push   $0x0
  pushl $198
80106451:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106456:	e9 5a f3 ff ff       	jmp    801057b5 <alltraps>

8010645b <vector199>:
.globl vector199
vector199:
  pushl $0
8010645b:	6a 00                	push   $0x0
  pushl $199
8010645d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106462:	e9 4e f3 ff ff       	jmp    801057b5 <alltraps>

80106467 <vector200>:
.globl vector200
vector200:
  pushl $0
80106467:	6a 00                	push   $0x0
  pushl $200
80106469:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010646e:	e9 42 f3 ff ff       	jmp    801057b5 <alltraps>

80106473 <vector201>:
.globl vector201
vector201:
  pushl $0
80106473:	6a 00                	push   $0x0
  pushl $201
80106475:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010647a:	e9 36 f3 ff ff       	jmp    801057b5 <alltraps>

8010647f <vector202>:
.globl vector202
vector202:
  pushl $0
8010647f:	6a 00                	push   $0x0
  pushl $202
80106481:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106486:	e9 2a f3 ff ff       	jmp    801057b5 <alltraps>

8010648b <vector203>:
.globl vector203
vector203:
  pushl $0
8010648b:	6a 00                	push   $0x0
  pushl $203
8010648d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106492:	e9 1e f3 ff ff       	jmp    801057b5 <alltraps>

80106497 <vector204>:
.globl vector204
vector204:
  pushl $0
80106497:	6a 00                	push   $0x0
  pushl $204
80106499:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010649e:	e9 12 f3 ff ff       	jmp    801057b5 <alltraps>

801064a3 <vector205>:
.globl vector205
vector205:
  pushl $0
801064a3:	6a 00                	push   $0x0
  pushl $205
801064a5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801064aa:	e9 06 f3 ff ff       	jmp    801057b5 <alltraps>

801064af <vector206>:
.globl vector206
vector206:
  pushl $0
801064af:	6a 00                	push   $0x0
  pushl $206
801064b1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801064b6:	e9 fa f2 ff ff       	jmp    801057b5 <alltraps>

801064bb <vector207>:
.globl vector207
vector207:
  pushl $0
801064bb:	6a 00                	push   $0x0
  pushl $207
801064bd:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801064c2:	e9 ee f2 ff ff       	jmp    801057b5 <alltraps>

801064c7 <vector208>:
.globl vector208
vector208:
  pushl $0
801064c7:	6a 00                	push   $0x0
  pushl $208
801064c9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801064ce:	e9 e2 f2 ff ff       	jmp    801057b5 <alltraps>

801064d3 <vector209>:
.globl vector209
vector209:
  pushl $0
801064d3:	6a 00                	push   $0x0
  pushl $209
801064d5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801064da:	e9 d6 f2 ff ff       	jmp    801057b5 <alltraps>

801064df <vector210>:
.globl vector210
vector210:
  pushl $0
801064df:	6a 00                	push   $0x0
  pushl $210
801064e1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801064e6:	e9 ca f2 ff ff       	jmp    801057b5 <alltraps>

801064eb <vector211>:
.globl vector211
vector211:
  pushl $0
801064eb:	6a 00                	push   $0x0
  pushl $211
801064ed:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801064f2:	e9 be f2 ff ff       	jmp    801057b5 <alltraps>

801064f7 <vector212>:
.globl vector212
vector212:
  pushl $0
801064f7:	6a 00                	push   $0x0
  pushl $212
801064f9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801064fe:	e9 b2 f2 ff ff       	jmp    801057b5 <alltraps>

80106503 <vector213>:
.globl vector213
vector213:
  pushl $0
80106503:	6a 00                	push   $0x0
  pushl $213
80106505:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010650a:	e9 a6 f2 ff ff       	jmp    801057b5 <alltraps>

8010650f <vector214>:
.globl vector214
vector214:
  pushl $0
8010650f:	6a 00                	push   $0x0
  pushl $214
80106511:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106516:	e9 9a f2 ff ff       	jmp    801057b5 <alltraps>

8010651b <vector215>:
.globl vector215
vector215:
  pushl $0
8010651b:	6a 00                	push   $0x0
  pushl $215
8010651d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106522:	e9 8e f2 ff ff       	jmp    801057b5 <alltraps>

80106527 <vector216>:
.globl vector216
vector216:
  pushl $0
80106527:	6a 00                	push   $0x0
  pushl $216
80106529:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010652e:	e9 82 f2 ff ff       	jmp    801057b5 <alltraps>

80106533 <vector217>:
.globl vector217
vector217:
  pushl $0
80106533:	6a 00                	push   $0x0
  pushl $217
80106535:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010653a:	e9 76 f2 ff ff       	jmp    801057b5 <alltraps>

8010653f <vector218>:
.globl vector218
vector218:
  pushl $0
8010653f:	6a 00                	push   $0x0
  pushl $218
80106541:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106546:	e9 6a f2 ff ff       	jmp    801057b5 <alltraps>

8010654b <vector219>:
.globl vector219
vector219:
  pushl $0
8010654b:	6a 00                	push   $0x0
  pushl $219
8010654d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106552:	e9 5e f2 ff ff       	jmp    801057b5 <alltraps>

80106557 <vector220>:
.globl vector220
vector220:
  pushl $0
80106557:	6a 00                	push   $0x0
  pushl $220
80106559:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010655e:	e9 52 f2 ff ff       	jmp    801057b5 <alltraps>

80106563 <vector221>:
.globl vector221
vector221:
  pushl $0
80106563:	6a 00                	push   $0x0
  pushl $221
80106565:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010656a:	e9 46 f2 ff ff       	jmp    801057b5 <alltraps>

8010656f <vector222>:
.globl vector222
vector222:
  pushl $0
8010656f:	6a 00                	push   $0x0
  pushl $222
80106571:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106576:	e9 3a f2 ff ff       	jmp    801057b5 <alltraps>

8010657b <vector223>:
.globl vector223
vector223:
  pushl $0
8010657b:	6a 00                	push   $0x0
  pushl $223
8010657d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106582:	e9 2e f2 ff ff       	jmp    801057b5 <alltraps>

80106587 <vector224>:
.globl vector224
vector224:
  pushl $0
80106587:	6a 00                	push   $0x0
  pushl $224
80106589:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010658e:	e9 22 f2 ff ff       	jmp    801057b5 <alltraps>

80106593 <vector225>:
.globl vector225
vector225:
  pushl $0
80106593:	6a 00                	push   $0x0
  pushl $225
80106595:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010659a:	e9 16 f2 ff ff       	jmp    801057b5 <alltraps>

8010659f <vector226>:
.globl vector226
vector226:
  pushl $0
8010659f:	6a 00                	push   $0x0
  pushl $226
801065a1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801065a6:	e9 0a f2 ff ff       	jmp    801057b5 <alltraps>

801065ab <vector227>:
.globl vector227
vector227:
  pushl $0
801065ab:	6a 00                	push   $0x0
  pushl $227
801065ad:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801065b2:	e9 fe f1 ff ff       	jmp    801057b5 <alltraps>

801065b7 <vector228>:
.globl vector228
vector228:
  pushl $0
801065b7:	6a 00                	push   $0x0
  pushl $228
801065b9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801065be:	e9 f2 f1 ff ff       	jmp    801057b5 <alltraps>

801065c3 <vector229>:
.globl vector229
vector229:
  pushl $0
801065c3:	6a 00                	push   $0x0
  pushl $229
801065c5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801065ca:	e9 e6 f1 ff ff       	jmp    801057b5 <alltraps>

801065cf <vector230>:
.globl vector230
vector230:
  pushl $0
801065cf:	6a 00                	push   $0x0
  pushl $230
801065d1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801065d6:	e9 da f1 ff ff       	jmp    801057b5 <alltraps>

801065db <vector231>:
.globl vector231
vector231:
  pushl $0
801065db:	6a 00                	push   $0x0
  pushl $231
801065dd:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801065e2:	e9 ce f1 ff ff       	jmp    801057b5 <alltraps>

801065e7 <vector232>:
.globl vector232
vector232:
  pushl $0
801065e7:	6a 00                	push   $0x0
  pushl $232
801065e9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801065ee:	e9 c2 f1 ff ff       	jmp    801057b5 <alltraps>

801065f3 <vector233>:
.globl vector233
vector233:
  pushl $0
801065f3:	6a 00                	push   $0x0
  pushl $233
801065f5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801065fa:	e9 b6 f1 ff ff       	jmp    801057b5 <alltraps>

801065ff <vector234>:
.globl vector234
vector234:
  pushl $0
801065ff:	6a 00                	push   $0x0
  pushl $234
80106601:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106606:	e9 aa f1 ff ff       	jmp    801057b5 <alltraps>

8010660b <vector235>:
.globl vector235
vector235:
  pushl $0
8010660b:	6a 00                	push   $0x0
  pushl $235
8010660d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106612:	e9 9e f1 ff ff       	jmp    801057b5 <alltraps>

80106617 <vector236>:
.globl vector236
vector236:
  pushl $0
80106617:	6a 00                	push   $0x0
  pushl $236
80106619:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010661e:	e9 92 f1 ff ff       	jmp    801057b5 <alltraps>

80106623 <vector237>:
.globl vector237
vector237:
  pushl $0
80106623:	6a 00                	push   $0x0
  pushl $237
80106625:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010662a:	e9 86 f1 ff ff       	jmp    801057b5 <alltraps>

8010662f <vector238>:
.globl vector238
vector238:
  pushl $0
8010662f:	6a 00                	push   $0x0
  pushl $238
80106631:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106636:	e9 7a f1 ff ff       	jmp    801057b5 <alltraps>

8010663b <vector239>:
.globl vector239
vector239:
  pushl $0
8010663b:	6a 00                	push   $0x0
  pushl $239
8010663d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106642:	e9 6e f1 ff ff       	jmp    801057b5 <alltraps>

80106647 <vector240>:
.globl vector240
vector240:
  pushl $0
80106647:	6a 00                	push   $0x0
  pushl $240
80106649:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010664e:	e9 62 f1 ff ff       	jmp    801057b5 <alltraps>

80106653 <vector241>:
.globl vector241
vector241:
  pushl $0
80106653:	6a 00                	push   $0x0
  pushl $241
80106655:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010665a:	e9 56 f1 ff ff       	jmp    801057b5 <alltraps>

8010665f <vector242>:
.globl vector242
vector242:
  pushl $0
8010665f:	6a 00                	push   $0x0
  pushl $242
80106661:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106666:	e9 4a f1 ff ff       	jmp    801057b5 <alltraps>

8010666b <vector243>:
.globl vector243
vector243:
  pushl $0
8010666b:	6a 00                	push   $0x0
  pushl $243
8010666d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106672:	e9 3e f1 ff ff       	jmp    801057b5 <alltraps>

80106677 <vector244>:
.globl vector244
vector244:
  pushl $0
80106677:	6a 00                	push   $0x0
  pushl $244
80106679:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010667e:	e9 32 f1 ff ff       	jmp    801057b5 <alltraps>

80106683 <vector245>:
.globl vector245
vector245:
  pushl $0
80106683:	6a 00                	push   $0x0
  pushl $245
80106685:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010668a:	e9 26 f1 ff ff       	jmp    801057b5 <alltraps>

8010668f <vector246>:
.globl vector246
vector246:
  pushl $0
8010668f:	6a 00                	push   $0x0
  pushl $246
80106691:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106696:	e9 1a f1 ff ff       	jmp    801057b5 <alltraps>

8010669b <vector247>:
.globl vector247
vector247:
  pushl $0
8010669b:	6a 00                	push   $0x0
  pushl $247
8010669d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801066a2:	e9 0e f1 ff ff       	jmp    801057b5 <alltraps>

801066a7 <vector248>:
.globl vector248
vector248:
  pushl $0
801066a7:	6a 00                	push   $0x0
  pushl $248
801066a9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801066ae:	e9 02 f1 ff ff       	jmp    801057b5 <alltraps>

801066b3 <vector249>:
.globl vector249
vector249:
  pushl $0
801066b3:	6a 00                	push   $0x0
  pushl $249
801066b5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801066ba:	e9 f6 f0 ff ff       	jmp    801057b5 <alltraps>

801066bf <vector250>:
.globl vector250
vector250:
  pushl $0
801066bf:	6a 00                	push   $0x0
  pushl $250
801066c1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801066c6:	e9 ea f0 ff ff       	jmp    801057b5 <alltraps>

801066cb <vector251>:
.globl vector251
vector251:
  pushl $0
801066cb:	6a 00                	push   $0x0
  pushl $251
801066cd:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801066d2:	e9 de f0 ff ff       	jmp    801057b5 <alltraps>

801066d7 <vector252>:
.globl vector252
vector252:
  pushl $0
801066d7:	6a 00                	push   $0x0
  pushl $252
801066d9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801066de:	e9 d2 f0 ff ff       	jmp    801057b5 <alltraps>

801066e3 <vector253>:
.globl vector253
vector253:
  pushl $0
801066e3:	6a 00                	push   $0x0
  pushl $253
801066e5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801066ea:	e9 c6 f0 ff ff       	jmp    801057b5 <alltraps>

801066ef <vector254>:
.globl vector254
vector254:
  pushl $0
801066ef:	6a 00                	push   $0x0
  pushl $254
801066f1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801066f6:	e9 ba f0 ff ff       	jmp    801057b5 <alltraps>

801066fb <vector255>:
.globl vector255
vector255:
  pushl $0
801066fb:	6a 00                	push   $0x0
  pushl $255
801066fd:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106702:	e9 ae f0 ff ff       	jmp    801057b5 <alltraps>
80106707:	66 90                	xchg   %ax,%ax
80106709:	66 90                	xchg   %ax,%ax
8010670b:	66 90                	xchg   %ax,%ax
8010670d:	66 90                	xchg   %ax,%ax
8010670f:	90                   	nop

80106710 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106710:	55                   	push   %ebp
80106711:	89 e5                	mov    %esp,%ebp
80106713:	57                   	push   %edi
80106714:	56                   	push   %esi
80106715:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106717:	c1 ea 16             	shr    $0x16,%edx
{
8010671a:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
8010671b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
8010671e:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106721:	8b 07                	mov    (%edi),%eax
80106723:	a8 01                	test   $0x1,%al
80106725:	74 29                	je     80106750 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106727:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010672c:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106732:	c1 ee 0a             	shr    $0xa,%esi
}
80106735:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106738:	89 f2                	mov    %esi,%edx
8010673a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106740:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106743:	5b                   	pop    %ebx
80106744:	5e                   	pop    %esi
80106745:	5f                   	pop    %edi
80106746:	5d                   	pop    %ebp
80106747:	c3                   	ret    
80106748:	90                   	nop
80106749:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106750:	85 c9                	test   %ecx,%ecx
80106752:	74 2c                	je     80106780 <walkpgdir+0x70>
80106754:	e8 57 be ff ff       	call   801025b0 <kalloc>
80106759:	89 c3                	mov    %eax,%ebx
8010675b:	85 c0                	test   %eax,%eax
8010675d:	74 21                	je     80106780 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
8010675f:	83 ec 04             	sub    $0x4,%esp
80106762:	68 00 10 00 00       	push   $0x1000
80106767:	6a 00                	push   $0x0
80106769:	50                   	push   %eax
8010676a:	e8 b1 de ff ff       	call   80104620 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010676f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106775:	83 c4 10             	add    $0x10,%esp
80106778:	83 c8 07             	or     $0x7,%eax
8010677b:	89 07                	mov    %eax,(%edi)
8010677d:	eb b3                	jmp    80106732 <walkpgdir+0x22>
8010677f:	90                   	nop
}
80106780:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106783:	31 c0                	xor    %eax,%eax
}
80106785:	5b                   	pop    %ebx
80106786:	5e                   	pop    %esi
80106787:	5f                   	pop    %edi
80106788:	5d                   	pop    %ebp
80106789:	c3                   	ret    
8010678a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106790 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106790:	55                   	push   %ebp
80106791:	89 e5                	mov    %esp,%ebp
80106793:	57                   	push   %edi
80106794:	56                   	push   %esi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106795:	89 d6                	mov    %edx,%esi
{
80106797:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106798:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
{
8010679e:	83 ec 1c             	sub    $0x1c,%esp
801067a1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801067a4:	8b 7d 08             	mov    0x8(%ebp),%edi
801067a7:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
801067ab:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801067b0:	89 45 e0             	mov    %eax,-0x20(%ebp)
801067b3:	29 f7                	sub    %esi,%edi
801067b5:	eb 21                	jmp    801067d8 <mappages+0x48>
801067b7:	89 f6                	mov    %esi,%esi
801067b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
801067c0:	f6 00 01             	testb  $0x1,(%eax)
801067c3:	75 45                	jne    8010680a <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
801067c5:	0b 5d 0c             	or     0xc(%ebp),%ebx
801067c8:	83 cb 01             	or     $0x1,%ebx
801067cb:	89 18                	mov    %ebx,(%eax)
    if(a == last)
801067cd:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801067d0:	74 2e                	je     80106800 <mappages+0x70>
      break;
    a += PGSIZE;
801067d2:	81 c6 00 10 00 00    	add    $0x1000,%esi
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801067d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801067db:	b9 01 00 00 00       	mov    $0x1,%ecx
801067e0:	89 f2                	mov    %esi,%edx
801067e2:	8d 1c 3e             	lea    (%esi,%edi,1),%ebx
801067e5:	e8 26 ff ff ff       	call   80106710 <walkpgdir>
801067ea:	85 c0                	test   %eax,%eax
801067ec:	75 d2                	jne    801067c0 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
801067ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801067f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801067f6:	5b                   	pop    %ebx
801067f7:	5e                   	pop    %esi
801067f8:	5f                   	pop    %edi
801067f9:	5d                   	pop    %ebp
801067fa:	c3                   	ret    
801067fb:	90                   	nop
801067fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106800:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106803:	31 c0                	xor    %eax,%eax
}
80106805:	5b                   	pop    %ebx
80106806:	5e                   	pop    %esi
80106807:	5f                   	pop    %edi
80106808:	5d                   	pop    %ebp
80106809:	c3                   	ret    
      panic("remap");
8010680a:	83 ec 0c             	sub    $0xc,%esp
8010680d:	68 4c 79 10 80       	push   $0x8010794c
80106812:	e8 79 9b ff ff       	call   80100390 <panic>
80106817:	89 f6                	mov    %esi,%esi
80106819:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106820 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106820:	55                   	push   %ebp
80106821:	89 e5                	mov    %esp,%ebp
80106823:	57                   	push   %edi
80106824:	89 c7                	mov    %eax,%edi
80106826:	56                   	push   %esi
80106827:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106828:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
8010682e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106834:	83 ec 1c             	sub    $0x1c,%esp
80106837:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
8010683a:	39 d3                	cmp    %edx,%ebx
8010683c:	73 5a                	jae    80106898 <deallocuvm.part.0+0x78>
8010683e:	89 d6                	mov    %edx,%esi
80106840:	eb 10                	jmp    80106852 <deallocuvm.part.0+0x32>
80106842:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106848:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010684e:	39 de                	cmp    %ebx,%esi
80106850:	76 46                	jbe    80106898 <deallocuvm.part.0+0x78>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106852:	31 c9                	xor    %ecx,%ecx
80106854:	89 da                	mov    %ebx,%edx
80106856:	89 f8                	mov    %edi,%eax
80106858:	e8 b3 fe ff ff       	call   80106710 <walkpgdir>
    if(!pte)
8010685d:	85 c0                	test   %eax,%eax
8010685f:	74 47                	je     801068a8 <deallocuvm.part.0+0x88>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106861:	8b 10                	mov    (%eax),%edx
80106863:	f6 c2 01             	test   $0x1,%dl
80106866:	74 e0                	je     80106848 <deallocuvm.part.0+0x28>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106868:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
8010686e:	74 46                	je     801068b6 <deallocuvm.part.0+0x96>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106870:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106873:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106879:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
8010687c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106882:	52                   	push   %edx
80106883:	e8 68 bb ff ff       	call   801023f0 <kfree>
      *pte = 0;
80106888:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010688b:	83 c4 10             	add    $0x10,%esp
8010688e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80106894:	39 de                	cmp    %ebx,%esi
80106896:	77 ba                	ja     80106852 <deallocuvm.part.0+0x32>
    }
  }
  return newsz;
}
80106898:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010689b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010689e:	5b                   	pop    %ebx
8010689f:	5e                   	pop    %esi
801068a0:	5f                   	pop    %edi
801068a1:	5d                   	pop    %ebp
801068a2:	c3                   	ret    
801068a3:	90                   	nop
801068a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801068a8:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
801068ae:	81 c3 00 00 40 00    	add    $0x400000,%ebx
801068b4:	eb 98                	jmp    8010684e <deallocuvm.part.0+0x2e>
        panic("kfree");
801068b6:	83 ec 0c             	sub    $0xc,%esp
801068b9:	68 86 72 10 80       	push   $0x80107286
801068be:	e8 cd 9a ff ff       	call   80100390 <panic>
801068c3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801068c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801068d0 <seginit>:
{
801068d0:	55                   	push   %ebp
801068d1:	89 e5                	mov    %esp,%ebp
801068d3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
801068d6:	e8 e5 cf ff ff       	call   801038c0 <cpuid>
  pd[0] = size-1;
801068db:	ba 2f 00 00 00       	mov    $0x2f,%edx
801068e0:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801068e6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801068ea:	c7 80 f8 27 11 80 ff 	movl   $0xffff,-0x7feed808(%eax)
801068f1:	ff 00 00 
801068f4:	c7 80 fc 27 11 80 00 	movl   $0xcf9a00,-0x7feed804(%eax)
801068fb:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801068fe:	c7 80 00 28 11 80 ff 	movl   $0xffff,-0x7feed800(%eax)
80106905:	ff 00 00 
80106908:	c7 80 04 28 11 80 00 	movl   $0xcf9200,-0x7feed7fc(%eax)
8010690f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106912:	c7 80 08 28 11 80 ff 	movl   $0xffff,-0x7feed7f8(%eax)
80106919:	ff 00 00 
8010691c:	c7 80 0c 28 11 80 00 	movl   $0xcffa00,-0x7feed7f4(%eax)
80106923:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106926:	c7 80 10 28 11 80 ff 	movl   $0xffff,-0x7feed7f0(%eax)
8010692d:	ff 00 00 
80106930:	c7 80 14 28 11 80 00 	movl   $0xcff200,-0x7feed7ec(%eax)
80106937:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010693a:	05 f0 27 11 80       	add    $0x801127f0,%eax
  pd[1] = (uint)p;
8010693f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106943:	c1 e8 10             	shr    $0x10,%eax
80106946:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010694a:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010694d:	0f 01 10             	lgdtl  (%eax)
}
80106950:	c9                   	leave  
80106951:	c3                   	ret    
80106952:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106959:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106960 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106960:	a1 a4 54 11 80       	mov    0x801154a4,%eax
80106965:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010696a:	0f 22 d8             	mov    %eax,%cr3
}
8010696d:	c3                   	ret    
8010696e:	66 90                	xchg   %ax,%ax

80106970 <switchuvm>:
{
80106970:	55                   	push   %ebp
80106971:	89 e5                	mov    %esp,%ebp
80106973:	57                   	push   %edi
80106974:	56                   	push   %esi
80106975:	53                   	push   %ebx
80106976:	83 ec 1c             	sub    $0x1c,%esp
80106979:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
8010697c:	85 db                	test   %ebx,%ebx
8010697e:	0f 84 cb 00 00 00    	je     80106a4f <switchuvm+0xdf>
  if(p->kstack == 0)
80106984:	8b 43 08             	mov    0x8(%ebx),%eax
80106987:	85 c0                	test   %eax,%eax
80106989:	0f 84 da 00 00 00    	je     80106a69 <switchuvm+0xf9>
  if(p->pgdir == 0)
8010698f:	8b 43 04             	mov    0x4(%ebx),%eax
80106992:	85 c0                	test   %eax,%eax
80106994:	0f 84 c2 00 00 00    	je     80106a5c <switchuvm+0xec>
  pushcli();
8010699a:	e8 c1 da ff ff       	call   80104460 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010699f:	e8 9c ce ff ff       	call   80103840 <mycpu>
801069a4:	89 c6                	mov    %eax,%esi
801069a6:	e8 95 ce ff ff       	call   80103840 <mycpu>
801069ab:	89 c7                	mov    %eax,%edi
801069ad:	e8 8e ce ff ff       	call   80103840 <mycpu>
801069b2:	83 c7 08             	add    $0x8,%edi
801069b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801069b8:	e8 83 ce ff ff       	call   80103840 <mycpu>
801069bd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801069c0:	ba 67 00 00 00       	mov    $0x67,%edx
801069c5:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
801069cc:	83 c0 08             	add    $0x8,%eax
801069cf:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801069d6:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801069db:	83 c1 08             	add    $0x8,%ecx
801069de:	c1 e8 18             	shr    $0x18,%eax
801069e1:	c1 e9 10             	shr    $0x10,%ecx
801069e4:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
801069ea:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
801069f0:	b9 99 40 00 00       	mov    $0x4099,%ecx
801069f5:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801069fc:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80106a01:	e8 3a ce ff ff       	call   80103840 <mycpu>
80106a06:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106a0d:	e8 2e ce ff ff       	call   80103840 <mycpu>
80106a12:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106a16:	8b 73 08             	mov    0x8(%ebx),%esi
80106a19:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106a1f:	e8 1c ce ff ff       	call   80103840 <mycpu>
80106a24:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106a27:	e8 14 ce ff ff       	call   80103840 <mycpu>
80106a2c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106a30:	b8 28 00 00 00       	mov    $0x28,%eax
80106a35:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106a38:	8b 43 04             	mov    0x4(%ebx),%eax
80106a3b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106a40:	0f 22 d8             	mov    %eax,%cr3
}
80106a43:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a46:	5b                   	pop    %ebx
80106a47:	5e                   	pop    %esi
80106a48:	5f                   	pop    %edi
80106a49:	5d                   	pop    %ebp
  popcli();
80106a4a:	e9 21 db ff ff       	jmp    80104570 <popcli>
    panic("switchuvm: no process");
80106a4f:	83 ec 0c             	sub    $0xc,%esp
80106a52:	68 52 79 10 80       	push   $0x80107952
80106a57:	e8 34 99 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80106a5c:	83 ec 0c             	sub    $0xc,%esp
80106a5f:	68 7d 79 10 80       	push   $0x8010797d
80106a64:	e8 27 99 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80106a69:	83 ec 0c             	sub    $0xc,%esp
80106a6c:	68 68 79 10 80       	push   $0x80107968
80106a71:	e8 1a 99 ff ff       	call   80100390 <panic>
80106a76:	8d 76 00             	lea    0x0(%esi),%esi
80106a79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106a80 <inituvm>:
{
80106a80:	55                   	push   %ebp
80106a81:	89 e5                	mov    %esp,%ebp
80106a83:	57                   	push   %edi
80106a84:	56                   	push   %esi
80106a85:	53                   	push   %ebx
80106a86:	83 ec 1c             	sub    $0x1c,%esp
80106a89:	8b 45 08             	mov    0x8(%ebp),%eax
80106a8c:	8b 75 10             	mov    0x10(%ebp),%esi
80106a8f:	8b 7d 0c             	mov    0xc(%ebp),%edi
80106a92:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106a95:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106a9b:	77 49                	ja     80106ae6 <inituvm+0x66>
  mem = kalloc();
80106a9d:	e8 0e bb ff ff       	call   801025b0 <kalloc>
  memset(mem, 0, PGSIZE);
80106aa2:	83 ec 04             	sub    $0x4,%esp
80106aa5:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80106aaa:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106aac:	6a 00                	push   $0x0
80106aae:	50                   	push   %eax
80106aaf:	e8 6c db ff ff       	call   80104620 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106ab4:	58                   	pop    %eax
80106ab5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106abb:	5a                   	pop    %edx
80106abc:	6a 06                	push   $0x6
80106abe:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106ac3:	31 d2                	xor    %edx,%edx
80106ac5:	50                   	push   %eax
80106ac6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106ac9:	e8 c2 fc ff ff       	call   80106790 <mappages>
  memmove(mem, init, sz);
80106ace:	89 75 10             	mov    %esi,0x10(%ebp)
80106ad1:	83 c4 10             	add    $0x10,%esp
80106ad4:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106ad7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106ada:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106add:	5b                   	pop    %ebx
80106ade:	5e                   	pop    %esi
80106adf:	5f                   	pop    %edi
80106ae0:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106ae1:	e9 da db ff ff       	jmp    801046c0 <memmove>
    panic("inituvm: more than a page");
80106ae6:	83 ec 0c             	sub    $0xc,%esp
80106ae9:	68 91 79 10 80       	push   $0x80107991
80106aee:	e8 9d 98 ff ff       	call   80100390 <panic>
80106af3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106af9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106b00 <loaduvm>:
{
80106b00:	55                   	push   %ebp
80106b01:	89 e5                	mov    %esp,%ebp
80106b03:	57                   	push   %edi
80106b04:	56                   	push   %esi
80106b05:	53                   	push   %ebx
80106b06:	83 ec 1c             	sub    $0x1c,%esp
80106b09:	8b 45 0c             	mov    0xc(%ebp),%eax
80106b0c:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80106b0f:	a9 ff 0f 00 00       	test   $0xfff,%eax
80106b14:	0f 85 8d 00 00 00    	jne    80106ba7 <loaduvm+0xa7>
80106b1a:	01 f0                	add    %esi,%eax
  for(i = 0; i < sz; i += PGSIZE){
80106b1c:	89 f3                	mov    %esi,%ebx
80106b1e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106b21:	8b 45 14             	mov    0x14(%ebp),%eax
80106b24:	01 f0                	add    %esi,%eax
80106b26:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80106b29:	85 f6                	test   %esi,%esi
80106b2b:	75 11                	jne    80106b3e <loaduvm+0x3e>
80106b2d:	eb 61                	jmp    80106b90 <loaduvm+0x90>
80106b2f:	90                   	nop
80106b30:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80106b36:	89 f0                	mov    %esi,%eax
80106b38:	29 d8                	sub    %ebx,%eax
80106b3a:	39 c6                	cmp    %eax,%esi
80106b3c:	76 52                	jbe    80106b90 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106b3e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106b41:	8b 45 08             	mov    0x8(%ebp),%eax
80106b44:	31 c9                	xor    %ecx,%ecx
80106b46:	29 da                	sub    %ebx,%edx
80106b48:	e8 c3 fb ff ff       	call   80106710 <walkpgdir>
80106b4d:	85 c0                	test   %eax,%eax
80106b4f:	74 49                	je     80106b9a <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
80106b51:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106b53:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
80106b56:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106b5b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106b60:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80106b66:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106b69:	29 d9                	sub    %ebx,%ecx
80106b6b:	05 00 00 00 80       	add    $0x80000000,%eax
80106b70:	57                   	push   %edi
80106b71:	51                   	push   %ecx
80106b72:	50                   	push   %eax
80106b73:	ff 75 10             	pushl  0x10(%ebp)
80106b76:	e8 85 ae ff ff       	call   80101a00 <readi>
80106b7b:	83 c4 10             	add    $0x10,%esp
80106b7e:	39 f8                	cmp    %edi,%eax
80106b80:	74 ae                	je     80106b30 <loaduvm+0x30>
}
80106b82:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106b85:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106b8a:	5b                   	pop    %ebx
80106b8b:	5e                   	pop    %esi
80106b8c:	5f                   	pop    %edi
80106b8d:	5d                   	pop    %ebp
80106b8e:	c3                   	ret    
80106b8f:	90                   	nop
80106b90:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106b93:	31 c0                	xor    %eax,%eax
}
80106b95:	5b                   	pop    %ebx
80106b96:	5e                   	pop    %esi
80106b97:	5f                   	pop    %edi
80106b98:	5d                   	pop    %ebp
80106b99:	c3                   	ret    
      panic("loaduvm: address should exist");
80106b9a:	83 ec 0c             	sub    $0xc,%esp
80106b9d:	68 ab 79 10 80       	push   $0x801079ab
80106ba2:	e8 e9 97 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80106ba7:	83 ec 0c             	sub    $0xc,%esp
80106baa:	68 4c 7a 10 80       	push   $0x80107a4c
80106baf:	e8 dc 97 ff ff       	call   80100390 <panic>
80106bb4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106bba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106bc0 <allocuvm>:
{
80106bc0:	55                   	push   %ebp
80106bc1:	89 e5                	mov    %esp,%ebp
80106bc3:	57                   	push   %edi
80106bc4:	56                   	push   %esi
80106bc5:	53                   	push   %ebx
80106bc6:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80106bc9:	8b 7d 10             	mov    0x10(%ebp),%edi
80106bcc:	85 ff                	test   %edi,%edi
80106bce:	0f 88 bc 00 00 00    	js     80106c90 <allocuvm+0xd0>
  if(newsz < oldsz)
80106bd4:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106bd7:	0f 82 a3 00 00 00    	jb     80106c80 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80106bdd:	8b 45 0c             	mov    0xc(%ebp),%eax
80106be0:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106be6:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80106bec:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80106bef:	0f 86 8e 00 00 00    	jbe    80106c83 <allocuvm+0xc3>
80106bf5:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80106bf8:	8b 7d 08             	mov    0x8(%ebp),%edi
80106bfb:	eb 42                	jmp    80106c3f <allocuvm+0x7f>
80106bfd:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80106c00:	83 ec 04             	sub    $0x4,%esp
80106c03:	68 00 10 00 00       	push   $0x1000
80106c08:	6a 00                	push   $0x0
80106c0a:	50                   	push   %eax
80106c0b:	e8 10 da ff ff       	call   80104620 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106c10:	58                   	pop    %eax
80106c11:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106c17:	5a                   	pop    %edx
80106c18:	6a 06                	push   $0x6
80106c1a:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106c1f:	89 da                	mov    %ebx,%edx
80106c21:	50                   	push   %eax
80106c22:	89 f8                	mov    %edi,%eax
80106c24:	e8 67 fb ff ff       	call   80106790 <mappages>
80106c29:	83 c4 10             	add    $0x10,%esp
80106c2c:	85 c0                	test   %eax,%eax
80106c2e:	78 70                	js     80106ca0 <allocuvm+0xe0>
  for(; a < newsz; a += PGSIZE){
80106c30:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106c36:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80106c39:	0f 86 a1 00 00 00    	jbe    80106ce0 <allocuvm+0x120>
    mem = kalloc();
80106c3f:	e8 6c b9 ff ff       	call   801025b0 <kalloc>
80106c44:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80106c46:	85 c0                	test   %eax,%eax
80106c48:	75 b6                	jne    80106c00 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80106c4a:	83 ec 0c             	sub    $0xc,%esp
80106c4d:	68 c9 79 10 80       	push   $0x801079c9
80106c52:	e8 59 9a ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80106c57:	83 c4 10             	add    $0x10,%esp
80106c5a:	8b 45 0c             	mov    0xc(%ebp),%eax
80106c5d:	39 45 10             	cmp    %eax,0x10(%ebp)
80106c60:	74 2e                	je     80106c90 <allocuvm+0xd0>
80106c62:	89 c1                	mov    %eax,%ecx
80106c64:	8b 55 10             	mov    0x10(%ebp),%edx
80106c67:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
80106c6a:	31 ff                	xor    %edi,%edi
80106c6c:	e8 af fb ff ff       	call   80106820 <deallocuvm.part.0>
}
80106c71:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c74:	89 f8                	mov    %edi,%eax
80106c76:	5b                   	pop    %ebx
80106c77:	5e                   	pop    %esi
80106c78:	5f                   	pop    %edi
80106c79:	5d                   	pop    %ebp
80106c7a:	c3                   	ret    
80106c7b:	90                   	nop
80106c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80106c80:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
80106c83:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c86:	89 f8                	mov    %edi,%eax
80106c88:	5b                   	pop    %ebx
80106c89:	5e                   	pop    %esi
80106c8a:	5f                   	pop    %edi
80106c8b:	5d                   	pop    %ebp
80106c8c:	c3                   	ret    
80106c8d:	8d 76 00             	lea    0x0(%esi),%esi
80106c90:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80106c93:	31 ff                	xor    %edi,%edi
}
80106c95:	5b                   	pop    %ebx
80106c96:	89 f8                	mov    %edi,%eax
80106c98:	5e                   	pop    %esi
80106c99:	5f                   	pop    %edi
80106c9a:	5d                   	pop    %ebp
80106c9b:	c3                   	ret    
80106c9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      cprintf("allocuvm out of memory (2)\n");
80106ca0:	83 ec 0c             	sub    $0xc,%esp
80106ca3:	68 e1 79 10 80       	push   $0x801079e1
80106ca8:	e8 03 9a ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80106cad:	83 c4 10             	add    $0x10,%esp
80106cb0:	8b 45 0c             	mov    0xc(%ebp),%eax
80106cb3:	39 45 10             	cmp    %eax,0x10(%ebp)
80106cb6:	74 0d                	je     80106cc5 <allocuvm+0x105>
80106cb8:	89 c1                	mov    %eax,%ecx
80106cba:	8b 55 10             	mov    0x10(%ebp),%edx
80106cbd:	8b 45 08             	mov    0x8(%ebp),%eax
80106cc0:	e8 5b fb ff ff       	call   80106820 <deallocuvm.part.0>
      kfree(mem);
80106cc5:	83 ec 0c             	sub    $0xc,%esp
      return 0;
80106cc8:	31 ff                	xor    %edi,%edi
      kfree(mem);
80106cca:	56                   	push   %esi
80106ccb:	e8 20 b7 ff ff       	call   801023f0 <kfree>
      return 0;
80106cd0:	83 c4 10             	add    $0x10,%esp
}
80106cd3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106cd6:	89 f8                	mov    %edi,%eax
80106cd8:	5b                   	pop    %ebx
80106cd9:	5e                   	pop    %esi
80106cda:	5f                   	pop    %edi
80106cdb:	5d                   	pop    %ebp
80106cdc:	c3                   	ret    
80106cdd:	8d 76 00             	lea    0x0(%esi),%esi
80106ce0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80106ce3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ce6:	5b                   	pop    %ebx
80106ce7:	5e                   	pop    %esi
80106ce8:	89 f8                	mov    %edi,%eax
80106cea:	5f                   	pop    %edi
80106ceb:	5d                   	pop    %ebp
80106cec:	c3                   	ret    
80106ced:	8d 76 00             	lea    0x0(%esi),%esi

80106cf0 <deallocuvm>:
{
80106cf0:	55                   	push   %ebp
80106cf1:	89 e5                	mov    %esp,%ebp
80106cf3:	8b 55 0c             	mov    0xc(%ebp),%edx
80106cf6:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80106cfc:	39 d1                	cmp    %edx,%ecx
80106cfe:	73 10                	jae    80106d10 <deallocuvm+0x20>
}
80106d00:	5d                   	pop    %ebp
80106d01:	e9 1a fb ff ff       	jmp    80106820 <deallocuvm.part.0>
80106d06:	8d 76 00             	lea    0x0(%esi),%esi
80106d09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106d10:	89 d0                	mov    %edx,%eax
80106d12:	5d                   	pop    %ebp
80106d13:	c3                   	ret    
80106d14:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106d1a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106d20 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106d20:	55                   	push   %ebp
80106d21:	89 e5                	mov    %esp,%ebp
80106d23:	57                   	push   %edi
80106d24:	56                   	push   %esi
80106d25:	53                   	push   %ebx
80106d26:	83 ec 0c             	sub    $0xc,%esp
80106d29:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106d2c:	85 f6                	test   %esi,%esi
80106d2e:	74 59                	je     80106d89 <freevm+0x69>
  if(newsz >= oldsz)
80106d30:	31 c9                	xor    %ecx,%ecx
80106d32:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106d37:	89 f0                	mov    %esi,%eax
80106d39:	89 f3                	mov    %esi,%ebx
80106d3b:	e8 e0 fa ff ff       	call   80106820 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106d40:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80106d46:	eb 0f                	jmp    80106d57 <freevm+0x37>
80106d48:	90                   	nop
80106d49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d50:	83 c3 04             	add    $0x4,%ebx
80106d53:	39 df                	cmp    %ebx,%edi
80106d55:	74 23                	je     80106d7a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106d57:	8b 03                	mov    (%ebx),%eax
80106d59:	a8 01                	test   $0x1,%al
80106d5b:	74 f3                	je     80106d50 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106d5d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80106d62:	83 ec 0c             	sub    $0xc,%esp
80106d65:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106d68:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80106d6d:	50                   	push   %eax
80106d6e:	e8 7d b6 ff ff       	call   801023f0 <kfree>
80106d73:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80106d76:	39 df                	cmp    %ebx,%edi
80106d78:	75 dd                	jne    80106d57 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80106d7a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106d7d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d80:	5b                   	pop    %ebx
80106d81:	5e                   	pop    %esi
80106d82:	5f                   	pop    %edi
80106d83:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80106d84:	e9 67 b6 ff ff       	jmp    801023f0 <kfree>
    panic("freevm: no pgdir");
80106d89:	83 ec 0c             	sub    $0xc,%esp
80106d8c:	68 fd 79 10 80       	push   $0x801079fd
80106d91:	e8 fa 95 ff ff       	call   80100390 <panic>
80106d96:	8d 76 00             	lea    0x0(%esi),%esi
80106d99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106da0 <setupkvm>:
{
80106da0:	55                   	push   %ebp
80106da1:	89 e5                	mov    %esp,%ebp
80106da3:	56                   	push   %esi
80106da4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80106da5:	e8 06 b8 ff ff       	call   801025b0 <kalloc>
80106daa:	89 c6                	mov    %eax,%esi
80106dac:	85 c0                	test   %eax,%eax
80106dae:	74 42                	je     80106df2 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80106db0:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106db3:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80106db8:	68 00 10 00 00       	push   $0x1000
80106dbd:	6a 00                	push   $0x0
80106dbf:	50                   	push   %eax
80106dc0:	e8 5b d8 ff ff       	call   80104620 <memset>
80106dc5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80106dc8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106dcb:	83 ec 08             	sub    $0x8,%esp
80106dce:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106dd1:	ff 73 0c             	pushl  0xc(%ebx)
80106dd4:	8b 13                	mov    (%ebx),%edx
80106dd6:	50                   	push   %eax
80106dd7:	29 c1                	sub    %eax,%ecx
80106dd9:	89 f0                	mov    %esi,%eax
80106ddb:	e8 b0 f9 ff ff       	call   80106790 <mappages>
80106de0:	83 c4 10             	add    $0x10,%esp
80106de3:	85 c0                	test   %eax,%eax
80106de5:	78 19                	js     80106e00 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106de7:	83 c3 10             	add    $0x10,%ebx
80106dea:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106df0:	75 d6                	jne    80106dc8 <setupkvm+0x28>
}
80106df2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106df5:	89 f0                	mov    %esi,%eax
80106df7:	5b                   	pop    %ebx
80106df8:	5e                   	pop    %esi
80106df9:	5d                   	pop    %ebp
80106dfa:	c3                   	ret    
80106dfb:	90                   	nop
80106dfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80106e00:	83 ec 0c             	sub    $0xc,%esp
80106e03:	56                   	push   %esi
      return 0;
80106e04:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80106e06:	e8 15 ff ff ff       	call   80106d20 <freevm>
      return 0;
80106e0b:	83 c4 10             	add    $0x10,%esp
}
80106e0e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106e11:	89 f0                	mov    %esi,%eax
80106e13:	5b                   	pop    %ebx
80106e14:	5e                   	pop    %esi
80106e15:	5d                   	pop    %ebp
80106e16:	c3                   	ret    
80106e17:	89 f6                	mov    %esi,%esi
80106e19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106e20 <kvmalloc>:
{
80106e20:	55                   	push   %ebp
80106e21:	89 e5                	mov    %esp,%ebp
80106e23:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106e26:	e8 75 ff ff ff       	call   80106da0 <setupkvm>
80106e2b:	a3 a4 54 11 80       	mov    %eax,0x801154a4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106e30:	05 00 00 00 80       	add    $0x80000000,%eax
80106e35:	0f 22 d8             	mov    %eax,%cr3
}
80106e38:	c9                   	leave  
80106e39:	c3                   	ret    
80106e3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106e40 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106e40:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106e41:	31 c9                	xor    %ecx,%ecx
{
80106e43:	89 e5                	mov    %esp,%ebp
80106e45:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80106e48:	8b 55 0c             	mov    0xc(%ebp),%edx
80106e4b:	8b 45 08             	mov    0x8(%ebp),%eax
80106e4e:	e8 bd f8 ff ff       	call   80106710 <walkpgdir>
  if(pte == 0)
80106e53:	85 c0                	test   %eax,%eax
80106e55:	74 05                	je     80106e5c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106e57:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106e5a:	c9                   	leave  
80106e5b:	c3                   	ret    
    panic("clearpteu");
80106e5c:	83 ec 0c             	sub    $0xc,%esp
80106e5f:	68 0e 7a 10 80       	push   $0x80107a0e
80106e64:	e8 27 95 ff ff       	call   80100390 <panic>
80106e69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106e70 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106e70:	55                   	push   %ebp
80106e71:	89 e5                	mov    %esp,%ebp
80106e73:	57                   	push   %edi
80106e74:	56                   	push   %esi
80106e75:	53                   	push   %ebx
80106e76:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106e79:	e8 22 ff ff ff       	call   80106da0 <setupkvm>
80106e7e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106e81:	85 c0                	test   %eax,%eax
80106e83:	0f 84 a0 00 00 00    	je     80106f29 <copyuvm+0xb9>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106e89:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106e8c:	85 c9                	test   %ecx,%ecx
80106e8e:	0f 84 95 00 00 00    	je     80106f29 <copyuvm+0xb9>
80106e94:	31 f6                	xor    %esi,%esi
80106e96:	eb 4e                	jmp    80106ee6 <copyuvm+0x76>
80106e98:	90                   	nop
80106e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106ea0:	83 ec 04             	sub    $0x4,%esp
80106ea3:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80106ea9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106eac:	68 00 10 00 00       	push   $0x1000
80106eb1:	57                   	push   %edi
80106eb2:	50                   	push   %eax
80106eb3:	e8 08 d8 ff ff       	call   801046c0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80106eb8:	58                   	pop    %eax
80106eb9:	5a                   	pop    %edx
80106eba:	53                   	push   %ebx
80106ebb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106ebe:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106ec1:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106ec6:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106ecc:	52                   	push   %edx
80106ecd:	89 f2                	mov    %esi,%edx
80106ecf:	e8 bc f8 ff ff       	call   80106790 <mappages>
80106ed4:	83 c4 10             	add    $0x10,%esp
80106ed7:	85 c0                	test   %eax,%eax
80106ed9:	78 39                	js     80106f14 <copyuvm+0xa4>
  for(i = 0; i < sz; i += PGSIZE){
80106edb:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106ee1:	39 75 0c             	cmp    %esi,0xc(%ebp)
80106ee4:	76 43                	jbe    80106f29 <copyuvm+0xb9>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106ee6:	8b 45 08             	mov    0x8(%ebp),%eax
80106ee9:	31 c9                	xor    %ecx,%ecx
80106eeb:	89 f2                	mov    %esi,%edx
80106eed:	e8 1e f8 ff ff       	call   80106710 <walkpgdir>
80106ef2:	85 c0                	test   %eax,%eax
80106ef4:	74 3e                	je     80106f34 <copyuvm+0xc4>
    if(!(*pte & PTE_P))
80106ef6:	8b 18                	mov    (%eax),%ebx
80106ef8:	f6 c3 01             	test   $0x1,%bl
80106efb:	74 44                	je     80106f41 <copyuvm+0xd1>
    pa = PTE_ADDR(*pte);
80106efd:	89 df                	mov    %ebx,%edi
    flags = PTE_FLAGS(*pte);
80106eff:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
    pa = PTE_ADDR(*pte);
80106f05:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80106f0b:	e8 a0 b6 ff ff       	call   801025b0 <kalloc>
80106f10:	85 c0                	test   %eax,%eax
80106f12:	75 8c                	jne    80106ea0 <copyuvm+0x30>
      goto bad;
  }
  return d;

bad:
  freevm(d);
80106f14:	83 ec 0c             	sub    $0xc,%esp
80106f17:	ff 75 e0             	pushl  -0x20(%ebp)
80106f1a:	e8 01 fe ff ff       	call   80106d20 <freevm>
  return 0;
80106f1f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80106f26:	83 c4 10             	add    $0x10,%esp
}
80106f29:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106f2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f2f:	5b                   	pop    %ebx
80106f30:	5e                   	pop    %esi
80106f31:	5f                   	pop    %edi
80106f32:	5d                   	pop    %ebp
80106f33:	c3                   	ret    
      panic("copyuvm: pte should exist");
80106f34:	83 ec 0c             	sub    $0xc,%esp
80106f37:	68 18 7a 10 80       	push   $0x80107a18
80106f3c:	e8 4f 94 ff ff       	call   80100390 <panic>
      panic("copyuvm: page not present");
80106f41:	83 ec 0c             	sub    $0xc,%esp
80106f44:	68 32 7a 10 80       	push   $0x80107a32
80106f49:	e8 42 94 ff ff       	call   80100390 <panic>
80106f4e:	66 90                	xchg   %ax,%ax

80106f50 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106f50:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106f51:	31 c9                	xor    %ecx,%ecx
{
80106f53:	89 e5                	mov    %esp,%ebp
80106f55:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80106f58:	8b 55 0c             	mov    0xc(%ebp),%edx
80106f5b:	8b 45 08             	mov    0x8(%ebp),%eax
80106f5e:	e8 ad f7 ff ff       	call   80106710 <walkpgdir>
  if((*pte & PTE_P) == 0)
80106f63:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80106f65:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80106f66:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80106f68:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80106f6d:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80106f70:	05 00 00 00 80       	add    $0x80000000,%eax
80106f75:	83 fa 05             	cmp    $0x5,%edx
80106f78:	ba 00 00 00 00       	mov    $0x0,%edx
80106f7d:	0f 45 c2             	cmovne %edx,%eax
}
80106f80:	c3                   	ret    
80106f81:	eb 0d                	jmp    80106f90 <copyout>
80106f83:	90                   	nop
80106f84:	90                   	nop
80106f85:	90                   	nop
80106f86:	90                   	nop
80106f87:	90                   	nop
80106f88:	90                   	nop
80106f89:	90                   	nop
80106f8a:	90                   	nop
80106f8b:	90                   	nop
80106f8c:	90                   	nop
80106f8d:	90                   	nop
80106f8e:	90                   	nop
80106f8f:	90                   	nop

80106f90 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80106f90:	55                   	push   %ebp
80106f91:	89 e5                	mov    %esp,%ebp
80106f93:	57                   	push   %edi
80106f94:	56                   	push   %esi
80106f95:	53                   	push   %ebx
80106f96:	83 ec 0c             	sub    $0xc,%esp
80106f99:	8b 75 14             	mov    0x14(%ebp),%esi
80106f9c:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106f9f:	85 f6                	test   %esi,%esi
80106fa1:	75 38                	jne    80106fdb <copyout+0x4b>
80106fa3:	eb 6b                	jmp    80107010 <copyout+0x80>
80106fa5:	8d 76 00             	lea    0x0(%esi),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80106fa8:	8b 55 0c             	mov    0xc(%ebp),%edx
80106fab:	89 fb                	mov    %edi,%ebx
80106fad:	29 d3                	sub    %edx,%ebx
80106faf:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
80106fb5:	39 f3                	cmp    %esi,%ebx
80106fb7:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106fba:	29 fa                	sub    %edi,%edx
80106fbc:	83 ec 04             	sub    $0x4,%esp
80106fbf:	01 c2                	add    %eax,%edx
80106fc1:	53                   	push   %ebx
80106fc2:	ff 75 10             	pushl  0x10(%ebp)
80106fc5:	52                   	push   %edx
80106fc6:	e8 f5 d6 ff ff       	call   801046c0 <memmove>
    len -= n;
    buf += n;
80106fcb:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
80106fce:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while(len > 0){
80106fd4:	83 c4 10             	add    $0x10,%esp
80106fd7:	29 de                	sub    %ebx,%esi
80106fd9:	74 35                	je     80107010 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
80106fdb:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80106fdd:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80106fe0:	89 55 0c             	mov    %edx,0xc(%ebp)
80106fe3:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80106fe9:	57                   	push   %edi
80106fea:	ff 75 08             	pushl  0x8(%ebp)
80106fed:	e8 5e ff ff ff       	call   80106f50 <uva2ka>
    if(pa0 == 0)
80106ff2:	83 c4 10             	add    $0x10,%esp
80106ff5:	85 c0                	test   %eax,%eax
80106ff7:	75 af                	jne    80106fa8 <copyout+0x18>
  }
  return 0;
}
80106ff9:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106ffc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107001:	5b                   	pop    %ebx
80107002:	5e                   	pop    %esi
80107003:	5f                   	pop    %edi
80107004:	5d                   	pop    %ebp
80107005:	c3                   	ret    
80107006:	8d 76 00             	lea    0x0(%esi),%esi
80107009:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80107010:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107013:	31 c0                	xor    %eax,%eax
}
80107015:	5b                   	pop    %ebx
80107016:	5e                   	pop    %esi
80107017:	5f                   	pop    %edi
80107018:	5d                   	pop    %ebp
80107019:	c3                   	ret    
