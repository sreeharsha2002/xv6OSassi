
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
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
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
80100028:	bc c0 c5 10 80       	mov    $0x8010c5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 50 30 10 80       	mov    $0x80103050,%eax
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
80100040:	f3 0f 1e fb          	endbr32 
80100044:	55                   	push   %ebp
80100045:	89 e5                	mov    %esp,%ebp
80100047:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100048:	bb f4 c5 10 80       	mov    $0x8010c5f4,%ebx
{
8010004d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
80100050:	68 00 79 10 80       	push   $0x80107900
80100055:	68 c0 c5 10 80       	push   $0x8010c5c0
8010005a:	e8 b1 4a 00 00       	call   80104b10 <initlock>
  bcache.head.next = &bcache.head;
8010005f:	83 c4 10             	add    $0x10,%esp
80100062:	b8 bc 0c 11 80       	mov    $0x80110cbc,%eax
  bcache.head.prev = &bcache.head;
80100067:	c7 05 0c 0d 11 80 bc 	movl   $0x80110cbc,0x80110d0c
8010006e:	0c 11 80 
  bcache.head.next = &bcache.head;
80100071:	c7 05 10 0d 11 80 bc 	movl   $0x80110cbc,0x80110d10
80100078:	0c 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010007b:	eb 05                	jmp    80100082 <binit+0x42>
8010007d:	8d 76 00             	lea    0x0(%esi),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 07 79 10 80       	push   $0x80107907
80100097:	50                   	push   %eax
80100098:	e8 33 49 00 00       	call   801049d0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 0d 11 80       	mov    0x80110d10,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 10 0d 11 80    	mov    %ebx,0x80110d10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb 60 0a 11 80    	cmp    $0x80110a60,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave  
801000c2:	c3                   	ret    
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	f3 0f 1e fb          	endbr32 
801000d4:	55                   	push   %ebp
801000d5:	89 e5                	mov    %esp,%ebp
801000d7:	57                   	push   %edi
801000d8:	56                   	push   %esi
801000d9:	53                   	push   %ebx
801000da:	83 ec 18             	sub    $0x18,%esp
801000dd:	8b 7d 08             	mov    0x8(%ebp),%edi
801000e0:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&bcache.lock);
801000e3:	68 c0 c5 10 80       	push   $0x8010c5c0
801000e8:	e8 a3 4b 00 00       	call   80104c90 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000ed:	8b 1d 10 0d 11 80    	mov    0x80110d10,%ebx
801000f3:	83 c4 10             	add    $0x10,%esp
801000f6:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
801000fc:	75 0d                	jne    8010010b <bread+0x3b>
801000fe:	eb 20                	jmp    80100120 <bread+0x50>
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
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
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c 0d 11 80    	mov    0x80110d0c,%ebx
80100126:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 70                	jmp    801001a0 <bread+0xd0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
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
8010015d:	68 c0 c5 10 80       	push   $0x8010c5c0
80100162:	e8 e9 4b 00 00       	call   80104d50 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 9e 48 00 00       	call   80104a10 <acquiresleep>
      return b;
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
8010018c:	e8 ff 20 00 00       	call   80102290 <iderw>
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
801001a3:	68 0e 79 10 80       	push   $0x8010790e
801001a8:	e8 e3 01 00 00       	call   80100390 <panic>
801001ad:	8d 76 00             	lea    0x0(%esi),%esi

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	f3 0f 1e fb          	endbr32 
801001b4:	55                   	push   %ebp
801001b5:	89 e5                	mov    %esp,%ebp
801001b7:	53                   	push   %ebx
801001b8:	83 ec 10             	sub    $0x10,%esp
801001bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001be:	8d 43 0c             	lea    0xc(%ebx),%eax
801001c1:	50                   	push   %eax
801001c2:	e8 e9 48 00 00       	call   80104ab0 <holdingsleep>
801001c7:	83 c4 10             	add    $0x10,%esp
801001ca:	85 c0                	test   %eax,%eax
801001cc:	74 0f                	je     801001dd <bwrite+0x2d>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ce:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001d1:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d7:	c9                   	leave  
  iderw(b);
801001d8:	e9 b3 20 00 00       	jmp    80102290 <iderw>
    panic("bwrite");
801001dd:	83 ec 0c             	sub    $0xc,%esp
801001e0:	68 1f 79 10 80       	push   $0x8010791f
801001e5:	e8 a6 01 00 00       	call   80100390 <panic>
801001ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	f3 0f 1e fb          	endbr32 
801001f4:	55                   	push   %ebp
801001f5:	89 e5                	mov    %esp,%ebp
801001f7:	56                   	push   %esi
801001f8:	53                   	push   %ebx
801001f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001fc:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ff:	83 ec 0c             	sub    $0xc,%esp
80100202:	56                   	push   %esi
80100203:	e8 a8 48 00 00       	call   80104ab0 <holdingsleep>
80100208:	83 c4 10             	add    $0x10,%esp
8010020b:	85 c0                	test   %eax,%eax
8010020d:	74 66                	je     80100275 <brelse+0x85>
    panic("brelse");

  releasesleep(&b->lock);
8010020f:	83 ec 0c             	sub    $0xc,%esp
80100212:	56                   	push   %esi
80100213:	e8 58 48 00 00       	call   80104a70 <releasesleep>

  acquire(&bcache.lock);
80100218:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
8010021f:	e8 6c 4a 00 00       	call   80104c90 <acquire>
  b->refcnt--;
80100224:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100227:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
8010022a:	83 e8 01             	sub    $0x1,%eax
8010022d:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
80100230:	85 c0                	test   %eax,%eax
80100232:	75 2f                	jne    80100263 <brelse+0x73>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100234:	8b 43 54             	mov    0x54(%ebx),%eax
80100237:	8b 53 50             	mov    0x50(%ebx),%edx
8010023a:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010023d:	8b 43 50             	mov    0x50(%ebx),%eax
80100240:	8b 53 54             	mov    0x54(%ebx),%edx
80100243:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100246:	a1 10 0d 11 80       	mov    0x80110d10,%eax
    b->prev = &bcache.head;
8010024b:	c7 43 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%ebx)
    b->next = bcache.head.next;
80100252:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100255:	a1 10 0d 11 80       	mov    0x80110d10,%eax
8010025a:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010025d:	89 1d 10 0d 11 80    	mov    %ebx,0x80110d10
  }
  
  release(&bcache.lock);
80100263:	c7 45 08 c0 c5 10 80 	movl   $0x8010c5c0,0x8(%ebp)
}
8010026a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010026d:	5b                   	pop    %ebx
8010026e:	5e                   	pop    %esi
8010026f:	5d                   	pop    %ebp
  release(&bcache.lock);
80100270:	e9 db 4a 00 00       	jmp    80104d50 <release>
    panic("brelse");
80100275:	83 ec 0c             	sub    $0xc,%esp
80100278:	68 26 79 10 80       	push   $0x80107926
8010027d:	e8 0e 01 00 00       	call   80100390 <panic>
80100282:	66 90                	xchg   %ax,%ax
80100284:	66 90                	xchg   %ax,%ax
80100286:	66 90                	xchg   %ax,%ax
80100288:	66 90                	xchg   %ax,%ax
8010028a:	66 90                	xchg   %ax,%ax
8010028c:	66 90                	xchg   %ax,%ax
8010028e:	66 90                	xchg   %ax,%ax

80100290 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100290:	f3 0f 1e fb          	endbr32 
80100294:	55                   	push   %ebp
80100295:	89 e5                	mov    %esp,%ebp
80100297:	57                   	push   %edi
80100298:	56                   	push   %esi
80100299:	53                   	push   %ebx
8010029a:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
8010029d:	ff 75 08             	pushl  0x8(%ebp)
{
801002a0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  target = n;
801002a3:	89 de                	mov    %ebx,%esi
  iunlock(ip);
801002a5:	e8 a6 15 00 00       	call   80101850 <iunlock>
  acquire(&cons.lock);
801002aa:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
801002b1:	e8 da 49 00 00       	call   80104c90 <acquire>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002b6:	8b 7d 0c             	mov    0xc(%ebp),%edi
  while(n > 0){
801002b9:	83 c4 10             	add    $0x10,%esp
    *dst++ = c;
801002bc:	01 df                	add    %ebx,%edi
  while(n > 0){
801002be:	85 db                	test   %ebx,%ebx
801002c0:	0f 8e 97 00 00 00    	jle    8010035d <consoleread+0xcd>
    while(input.r == input.w){
801002c6:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
801002cb:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
801002d1:	74 27                	je     801002fa <consoleread+0x6a>
801002d3:	eb 5b                	jmp    80100330 <consoleread+0xa0>
801002d5:	8d 76 00             	lea    0x0(%esi),%esi
      sleep(&input.r, &cons.lock);
801002d8:	83 ec 08             	sub    $0x8,%esp
801002db:	68 20 b5 10 80       	push   $0x8010b520
801002e0:	68 a0 0f 11 80       	push   $0x80110fa0
801002e5:	e8 e6 3e 00 00       	call   801041d0 <sleep>
    while(input.r == input.w){
801002ea:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
801002ef:	83 c4 10             	add    $0x10,%esp
801002f2:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
801002f8:	75 36                	jne    80100330 <consoleread+0xa0>
      if(myproc()->killed){
801002fa:	e8 01 37 00 00       	call   80103a00 <myproc>
801002ff:	8b 48 24             	mov    0x24(%eax),%ecx
80100302:	85 c9                	test   %ecx,%ecx
80100304:	74 d2                	je     801002d8 <consoleread+0x48>
        release(&cons.lock);
80100306:	83 ec 0c             	sub    $0xc,%esp
80100309:	68 20 b5 10 80       	push   $0x8010b520
8010030e:	e8 3d 4a 00 00       	call   80104d50 <release>
        ilock(ip);
80100313:	5a                   	pop    %edx
80100314:	ff 75 08             	pushl  0x8(%ebp)
80100317:	e8 54 14 00 00       	call   80101770 <ilock>
        return -1;
8010031c:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
8010031f:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100322:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100327:	5b                   	pop    %ebx
80100328:	5e                   	pop    %esi
80100329:	5f                   	pop    %edi
8010032a:	5d                   	pop    %ebp
8010032b:	c3                   	ret    
8010032c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100330:	8d 50 01             	lea    0x1(%eax),%edx
80100333:	89 15 a0 0f 11 80    	mov    %edx,0x80110fa0
80100339:	89 c2                	mov    %eax,%edx
8010033b:	83 e2 7f             	and    $0x7f,%edx
8010033e:	0f be 8a 20 0f 11 80 	movsbl -0x7feef0e0(%edx),%ecx
    if(c == C('D')){  // EOF
80100345:	80 f9 04             	cmp    $0x4,%cl
80100348:	74 38                	je     80100382 <consoleread+0xf2>
    *dst++ = c;
8010034a:	89 d8                	mov    %ebx,%eax
    --n;
8010034c:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
8010034f:	f7 d8                	neg    %eax
80100351:	88 0c 07             	mov    %cl,(%edi,%eax,1)
    if(c == '\n')
80100354:	83 f9 0a             	cmp    $0xa,%ecx
80100357:	0f 85 61 ff ff ff    	jne    801002be <consoleread+0x2e>
  release(&cons.lock);
8010035d:	83 ec 0c             	sub    $0xc,%esp
80100360:	68 20 b5 10 80       	push   $0x8010b520
80100365:	e8 e6 49 00 00       	call   80104d50 <release>
  ilock(ip);
8010036a:	58                   	pop    %eax
8010036b:	ff 75 08             	pushl  0x8(%ebp)
8010036e:	e8 fd 13 00 00       	call   80101770 <ilock>
  return target - n;
80100373:	89 f0                	mov    %esi,%eax
80100375:	83 c4 10             	add    $0x10,%esp
}
80100378:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
8010037b:	29 d8                	sub    %ebx,%eax
}
8010037d:	5b                   	pop    %ebx
8010037e:	5e                   	pop    %esi
8010037f:	5f                   	pop    %edi
80100380:	5d                   	pop    %ebp
80100381:	c3                   	ret    
      if(n < target){
80100382:	39 f3                	cmp    %esi,%ebx
80100384:	73 d7                	jae    8010035d <consoleread+0xcd>
        input.r--;
80100386:	a3 a0 0f 11 80       	mov    %eax,0x80110fa0
8010038b:	eb d0                	jmp    8010035d <consoleread+0xcd>
8010038d:	8d 76 00             	lea    0x0(%esi),%esi

80100390 <panic>:
{
80100390:	f3 0f 1e fb          	endbr32 
80100394:	55                   	push   %ebp
80100395:	89 e5                	mov    %esp,%ebp
80100397:	56                   	push   %esi
80100398:	53                   	push   %ebx
80100399:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
8010039c:	fa                   	cli    
  cons.locking = 0;
8010039d:	c7 05 54 b5 10 80 00 	movl   $0x0,0x8010b554
801003a4:	00 00 00 
  getcallerpcs(&s, pcs);
801003a7:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003aa:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003ad:	e8 fe 24 00 00       	call   801028b0 <lapicid>
801003b2:	83 ec 08             	sub    $0x8,%esp
801003b5:	50                   	push   %eax
801003b6:	68 2d 79 10 80       	push   $0x8010792d
801003bb:	e8 f0 02 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003c0:	58                   	pop    %eax
801003c1:	ff 75 08             	pushl  0x8(%ebp)
801003c4:	e8 e7 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003c9:	c7 04 24 a3 82 10 80 	movl   $0x801082a3,(%esp)
801003d0:	e8 db 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003d5:	8d 45 08             	lea    0x8(%ebp),%eax
801003d8:	5a                   	pop    %edx
801003d9:	59                   	pop    %ecx
801003da:	53                   	push   %ebx
801003db:	50                   	push   %eax
801003dc:	e8 4f 47 00 00       	call   80104b30 <getcallerpcs>
  for(i=0; i<10; i++)
801003e1:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e4:	83 ec 08             	sub    $0x8,%esp
801003e7:	ff 33                	pushl  (%ebx)
801003e9:	83 c3 04             	add    $0x4,%ebx
801003ec:	68 41 79 10 80       	push   $0x80107941
801003f1:	e8 ba 02 00 00       	call   801006b0 <cprintf>
  for(i=0; i<10; i++)
801003f6:	83 c4 10             	add    $0x10,%esp
801003f9:	39 f3                	cmp    %esi,%ebx
801003fb:	75 e7                	jne    801003e4 <panic+0x54>
  panicked = 1; // freeze other CPU
801003fd:	c7 05 58 b5 10 80 01 	movl   $0x1,0x8010b558
80100404:	00 00 00 
  for(;;)
80100407:	eb fe                	jmp    80100407 <panic+0x77>
80100409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

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
8010042a:	e8 d1 60 00 00       	call   80106500 <uartputc>
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
801004e7:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
801004eb:	be 00 80 0b 80       	mov    $0x800b8000,%esi
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
80100515:	e8 e6 5f 00 00       	call   80106500 <uartputc>
8010051a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100521:	e8 da 5f 00 00       	call   80106500 <uartputc>
80100526:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010052d:	e8 ce 5f 00 00       	call   80106500 <uartputc>
80100532:	83 c4 10             	add    $0x10,%esp
80100535:	e9 f8 fe ff ff       	jmp    80100432 <consputc.part.0+0x22>
8010053a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100540:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100543:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100546:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
8010054d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100552:	68 60 0e 00 00       	push   $0xe60
80100557:	68 a0 80 0b 80       	push   $0x800b80a0
8010055c:	68 00 80 0b 80       	push   $0x800b8000
80100561:	e8 da 48 00 00       	call   80104e40 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 25 48 00 00       	call   80104da0 <memset>
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 22 ff ff ff       	jmp    801004a8 <consputc.part.0+0x98>
    panic("pos under/overflow");
80100586:	83 ec 0c             	sub    $0xc,%esp
80100589:	68 45 79 10 80       	push   $0x80107945
8010058e:	e8 fd fd ff ff       	call   80100390 <panic>
80100593:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010059a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

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
801005b2:	78 6d                	js     80100621 <printint+0x81>
    x = xx;
801005b4:	89 c1                	mov    %eax,%ecx
801005b6:	31 f6                	xor    %esi,%esi
  i = 0;
801005b8:	89 75 cc             	mov    %esi,-0x34(%ebp)
801005bb:	31 db                	xor    %ebx,%ebx
801005bd:	8d 7d d7             	lea    -0x29(%ebp),%edi
    buf[i++] = digits[x % base];
801005c0:	89 c8                	mov    %ecx,%eax
801005c2:	31 d2                	xor    %edx,%edx
801005c4:	89 ce                	mov    %ecx,%esi
801005c6:	f7 75 d4             	divl   -0x2c(%ebp)
801005c9:	0f b6 92 70 79 10 80 	movzbl -0x7fef8690(%edx),%edx
801005d0:	89 45 d0             	mov    %eax,-0x30(%ebp)
801005d3:	89 d8                	mov    %ebx,%eax
801005d5:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
801005d8:	8b 4d d0             	mov    -0x30(%ebp),%ecx
801005db:	89 75 d0             	mov    %esi,-0x30(%ebp)
    buf[i++] = digits[x % base];
801005de:	88 14 1f             	mov    %dl,(%edi,%ebx,1)
  }while((x /= base) != 0);
801005e1:	8b 75 d4             	mov    -0x2c(%ebp),%esi
801005e4:	39 75 d0             	cmp    %esi,-0x30(%ebp)
801005e7:	73 d7                	jae    801005c0 <printint+0x20>
801005e9:	8b 75 cc             	mov    -0x34(%ebp),%esi
  if(sign)
801005ec:	85 f6                	test   %esi,%esi
801005ee:	74 0c                	je     801005fc <printint+0x5c>
    buf[i++] = '-';
801005f0:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
801005f5:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
801005f7:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
801005fc:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
80100600:	0f be c2             	movsbl %dl,%eax
  if(panicked){
80100603:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
80100609:	85 d2                	test   %edx,%edx
8010060b:	74 03                	je     80100610 <printint+0x70>
  asm volatile("cli");
8010060d:	fa                   	cli    
    for(;;)
8010060e:	eb fe                	jmp    8010060e <printint+0x6e>
80100610:	e8 fb fd ff ff       	call   80100410 <consputc.part.0>
  while(--i >= 0)
80100615:	39 fb                	cmp    %edi,%ebx
80100617:	74 10                	je     80100629 <printint+0x89>
80100619:	0f be 03             	movsbl (%ebx),%eax
8010061c:	83 eb 01             	sub    $0x1,%ebx
8010061f:	eb e2                	jmp    80100603 <printint+0x63>
    x = -xx;
80100621:	f7 d8                	neg    %eax
80100623:	89 ce                	mov    %ecx,%esi
80100625:	89 c1                	mov    %eax,%ecx
80100627:	eb 8f                	jmp    801005b8 <printint+0x18>
}
80100629:	83 c4 2c             	add    $0x2c,%esp
8010062c:	5b                   	pop    %ebx
8010062d:	5e                   	pop    %esi
8010062e:	5f                   	pop    %edi
8010062f:	5d                   	pop    %ebp
80100630:	c3                   	ret    
80100631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100638:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010063f:	90                   	nop

80100640 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100640:	f3 0f 1e fb          	endbr32 
80100644:	55                   	push   %ebp
80100645:	89 e5                	mov    %esp,%ebp
80100647:	57                   	push   %edi
80100648:	56                   	push   %esi
80100649:	53                   	push   %ebx
8010064a:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
8010064d:	ff 75 08             	pushl  0x8(%ebp)
{
80100650:	8b 5d 10             	mov    0x10(%ebp),%ebx
  iunlock(ip);
80100653:	e8 f8 11 00 00       	call   80101850 <iunlock>
  acquire(&cons.lock);
80100658:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010065f:	e8 2c 46 00 00       	call   80104c90 <acquire>
  for(i = 0; i < n; i++)
80100664:	83 c4 10             	add    $0x10,%esp
80100667:	85 db                	test   %ebx,%ebx
80100669:	7e 24                	jle    8010068f <consolewrite+0x4f>
8010066b:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010066e:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
  if(panicked){
80100671:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
80100677:	85 d2                	test   %edx,%edx
80100679:	74 05                	je     80100680 <consolewrite+0x40>
8010067b:	fa                   	cli    
    for(;;)
8010067c:	eb fe                	jmp    8010067c <consolewrite+0x3c>
8010067e:	66 90                	xchg   %ax,%ax
    consputc(buf[i] & 0xff);
80100680:	0f b6 07             	movzbl (%edi),%eax
80100683:	83 c7 01             	add    $0x1,%edi
80100686:	e8 85 fd ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; i < n; i++)
8010068b:	39 fe                	cmp    %edi,%esi
8010068d:	75 e2                	jne    80100671 <consolewrite+0x31>
  release(&cons.lock);
8010068f:	83 ec 0c             	sub    $0xc,%esp
80100692:	68 20 b5 10 80       	push   $0x8010b520
80100697:	e8 b4 46 00 00       	call   80104d50 <release>
  ilock(ip);
8010069c:	58                   	pop    %eax
8010069d:	ff 75 08             	pushl  0x8(%ebp)
801006a0:	e8 cb 10 00 00       	call   80101770 <ilock>

  return n;
}
801006a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801006a8:	89 d8                	mov    %ebx,%eax
801006aa:	5b                   	pop    %ebx
801006ab:	5e                   	pop    %esi
801006ac:	5f                   	pop    %edi
801006ad:	5d                   	pop    %ebp
801006ae:	c3                   	ret    
801006af:	90                   	nop

801006b0 <cprintf>:
{
801006b0:	f3 0f 1e fb          	endbr32 
801006b4:	55                   	push   %ebp
801006b5:	89 e5                	mov    %esp,%ebp
801006b7:	57                   	push   %edi
801006b8:	56                   	push   %esi
801006b9:	53                   	push   %ebx
801006ba:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006bd:	a1 54 b5 10 80       	mov    0x8010b554,%eax
801006c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
801006c5:	85 c0                	test   %eax,%eax
801006c7:	0f 85 e8 00 00 00    	jne    801007b5 <cprintf+0x105>
  if (fmt == 0)
801006cd:	8b 45 08             	mov    0x8(%ebp),%eax
801006d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006d3:	85 c0                	test   %eax,%eax
801006d5:	0f 84 5a 01 00 00    	je     80100835 <cprintf+0x185>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006db:	0f b6 00             	movzbl (%eax),%eax
801006de:	85 c0                	test   %eax,%eax
801006e0:	74 36                	je     80100718 <cprintf+0x68>
  argp = (uint*)(void*)(&fmt + 1);
801006e2:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006e5:	31 f6                	xor    %esi,%esi
    if(c != '%'){
801006e7:	83 f8 25             	cmp    $0x25,%eax
801006ea:	74 44                	je     80100730 <cprintf+0x80>
  if(panicked){
801006ec:	8b 0d 58 b5 10 80    	mov    0x8010b558,%ecx
801006f2:	85 c9                	test   %ecx,%ecx
801006f4:	74 0f                	je     80100705 <cprintf+0x55>
801006f6:	fa                   	cli    
    for(;;)
801006f7:	eb fe                	jmp    801006f7 <cprintf+0x47>
801006f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100700:	b8 25 00 00 00       	mov    $0x25,%eax
80100705:	e8 06 fd ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010070a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010070d:	83 c6 01             	add    $0x1,%esi
80100710:	0f b6 04 30          	movzbl (%eax,%esi,1),%eax
80100714:	85 c0                	test   %eax,%eax
80100716:	75 cf                	jne    801006e7 <cprintf+0x37>
  if(locking)
80100718:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010071b:	85 c0                	test   %eax,%eax
8010071d:	0f 85 fd 00 00 00    	jne    80100820 <cprintf+0x170>
}
80100723:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100726:	5b                   	pop    %ebx
80100727:	5e                   	pop    %esi
80100728:	5f                   	pop    %edi
80100729:	5d                   	pop    %ebp
8010072a:	c3                   	ret    
8010072b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010072f:	90                   	nop
    c = fmt[++i] & 0xff;
80100730:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100733:	83 c6 01             	add    $0x1,%esi
80100736:	0f b6 3c 30          	movzbl (%eax,%esi,1),%edi
    if(c == 0)
8010073a:	85 ff                	test   %edi,%edi
8010073c:	74 da                	je     80100718 <cprintf+0x68>
    switch(c){
8010073e:	83 ff 70             	cmp    $0x70,%edi
80100741:	74 5a                	je     8010079d <cprintf+0xed>
80100743:	7f 2a                	jg     8010076f <cprintf+0xbf>
80100745:	83 ff 25             	cmp    $0x25,%edi
80100748:	0f 84 92 00 00 00    	je     801007e0 <cprintf+0x130>
8010074e:	83 ff 64             	cmp    $0x64,%edi
80100751:	0f 85 a1 00 00 00    	jne    801007f8 <cprintf+0x148>
      printint(*argp++, 10, 1);
80100757:	8b 03                	mov    (%ebx),%eax
80100759:	8d 7b 04             	lea    0x4(%ebx),%edi
8010075c:	b9 01 00 00 00       	mov    $0x1,%ecx
80100761:	ba 0a 00 00 00       	mov    $0xa,%edx
80100766:	89 fb                	mov    %edi,%ebx
80100768:	e8 33 fe ff ff       	call   801005a0 <printint>
      break;
8010076d:	eb 9b                	jmp    8010070a <cprintf+0x5a>
    switch(c){
8010076f:	83 ff 73             	cmp    $0x73,%edi
80100772:	75 24                	jne    80100798 <cprintf+0xe8>
      if((s = (char*)*argp++) == 0)
80100774:	8d 7b 04             	lea    0x4(%ebx),%edi
80100777:	8b 1b                	mov    (%ebx),%ebx
80100779:	85 db                	test   %ebx,%ebx
8010077b:	75 55                	jne    801007d2 <cprintf+0x122>
        s = "(null)";
8010077d:	bb 58 79 10 80       	mov    $0x80107958,%ebx
      for(; *s; s++)
80100782:	b8 28 00 00 00       	mov    $0x28,%eax
  if(panicked){
80100787:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
8010078d:	85 d2                	test   %edx,%edx
8010078f:	74 39                	je     801007ca <cprintf+0x11a>
80100791:	fa                   	cli    
    for(;;)
80100792:	eb fe                	jmp    80100792 <cprintf+0xe2>
80100794:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100798:	83 ff 78             	cmp    $0x78,%edi
8010079b:	75 5b                	jne    801007f8 <cprintf+0x148>
      printint(*argp++, 16, 0);
8010079d:	8b 03                	mov    (%ebx),%eax
8010079f:	8d 7b 04             	lea    0x4(%ebx),%edi
801007a2:	31 c9                	xor    %ecx,%ecx
801007a4:	ba 10 00 00 00       	mov    $0x10,%edx
801007a9:	89 fb                	mov    %edi,%ebx
801007ab:	e8 f0 fd ff ff       	call   801005a0 <printint>
      break;
801007b0:	e9 55 ff ff ff       	jmp    8010070a <cprintf+0x5a>
    acquire(&cons.lock);
801007b5:	83 ec 0c             	sub    $0xc,%esp
801007b8:	68 20 b5 10 80       	push   $0x8010b520
801007bd:	e8 ce 44 00 00       	call   80104c90 <acquire>
801007c2:	83 c4 10             	add    $0x10,%esp
801007c5:	e9 03 ff ff ff       	jmp    801006cd <cprintf+0x1d>
801007ca:	e8 41 fc ff ff       	call   80100410 <consputc.part.0>
      for(; *s; s++)
801007cf:	83 c3 01             	add    $0x1,%ebx
801007d2:	0f be 03             	movsbl (%ebx),%eax
801007d5:	84 c0                	test   %al,%al
801007d7:	75 ae                	jne    80100787 <cprintf+0xd7>
      if((s = (char*)*argp++) == 0)
801007d9:	89 fb                	mov    %edi,%ebx
801007db:	e9 2a ff ff ff       	jmp    8010070a <cprintf+0x5a>
  if(panicked){
801007e0:	8b 3d 58 b5 10 80    	mov    0x8010b558,%edi
801007e6:	85 ff                	test   %edi,%edi
801007e8:	0f 84 12 ff ff ff    	je     80100700 <cprintf+0x50>
801007ee:	fa                   	cli    
    for(;;)
801007ef:	eb fe                	jmp    801007ef <cprintf+0x13f>
801007f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(panicked){
801007f8:	8b 0d 58 b5 10 80    	mov    0x8010b558,%ecx
801007fe:	85 c9                	test   %ecx,%ecx
80100800:	74 06                	je     80100808 <cprintf+0x158>
80100802:	fa                   	cli    
    for(;;)
80100803:	eb fe                	jmp    80100803 <cprintf+0x153>
80100805:	8d 76 00             	lea    0x0(%esi),%esi
80100808:	b8 25 00 00 00       	mov    $0x25,%eax
8010080d:	e8 fe fb ff ff       	call   80100410 <consputc.part.0>
  if(panicked){
80100812:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
80100818:	85 d2                	test   %edx,%edx
8010081a:	74 2c                	je     80100848 <cprintf+0x198>
8010081c:	fa                   	cli    
    for(;;)
8010081d:	eb fe                	jmp    8010081d <cprintf+0x16d>
8010081f:	90                   	nop
    release(&cons.lock);
80100820:	83 ec 0c             	sub    $0xc,%esp
80100823:	68 20 b5 10 80       	push   $0x8010b520
80100828:	e8 23 45 00 00       	call   80104d50 <release>
8010082d:	83 c4 10             	add    $0x10,%esp
}
80100830:	e9 ee fe ff ff       	jmp    80100723 <cprintf+0x73>
    panic("null fmt");
80100835:	83 ec 0c             	sub    $0xc,%esp
80100838:	68 5f 79 10 80       	push   $0x8010795f
8010083d:	e8 4e fb ff ff       	call   80100390 <panic>
80100842:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100848:	89 f8                	mov    %edi,%eax
8010084a:	e8 c1 fb ff ff       	call   80100410 <consputc.part.0>
8010084f:	e9 b6 fe ff ff       	jmp    8010070a <cprintf+0x5a>
80100854:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010085b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010085f:	90                   	nop

80100860 <consoleintr>:
{
80100860:	f3 0f 1e fb          	endbr32 
80100864:	55                   	push   %ebp
80100865:	89 e5                	mov    %esp,%ebp
80100867:	57                   	push   %edi
80100868:	56                   	push   %esi
  int c, doprocdump = 0;
80100869:	31 f6                	xor    %esi,%esi
{
8010086b:	53                   	push   %ebx
8010086c:	83 ec 18             	sub    $0x18,%esp
8010086f:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
80100872:	68 20 b5 10 80       	push   $0x8010b520
80100877:	e8 14 44 00 00       	call   80104c90 <acquire>
  while((c = getc()) >= 0){
8010087c:	83 c4 10             	add    $0x10,%esp
8010087f:	eb 17                	jmp    80100898 <consoleintr+0x38>
    switch(c){
80100881:	83 fb 08             	cmp    $0x8,%ebx
80100884:	0f 84 f6 00 00 00    	je     80100980 <consoleintr+0x120>
8010088a:	83 fb 10             	cmp    $0x10,%ebx
8010088d:	0f 85 15 01 00 00    	jne    801009a8 <consoleintr+0x148>
80100893:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
80100898:	ff d7                	call   *%edi
8010089a:	89 c3                	mov    %eax,%ebx
8010089c:	85 c0                	test   %eax,%eax
8010089e:	0f 88 23 01 00 00    	js     801009c7 <consoleintr+0x167>
    switch(c){
801008a4:	83 fb 15             	cmp    $0x15,%ebx
801008a7:	74 77                	je     80100920 <consoleintr+0xc0>
801008a9:	7e d6                	jle    80100881 <consoleintr+0x21>
801008ab:	83 fb 7f             	cmp    $0x7f,%ebx
801008ae:	0f 84 cc 00 00 00    	je     80100980 <consoleintr+0x120>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008b4:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
801008b9:	89 c2                	mov    %eax,%edx
801008bb:	2b 15 a0 0f 11 80    	sub    0x80110fa0,%edx
801008c1:	83 fa 7f             	cmp    $0x7f,%edx
801008c4:	77 d2                	ja     80100898 <consoleintr+0x38>
        c = (c == '\r') ? '\n' : c;
801008c6:	8d 48 01             	lea    0x1(%eax),%ecx
801008c9:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
801008cf:	83 e0 7f             	and    $0x7f,%eax
        input.buf[input.e++ % INPUT_BUF] = c;
801008d2:	89 0d a8 0f 11 80    	mov    %ecx,0x80110fa8
        c = (c == '\r') ? '\n' : c;
801008d8:	83 fb 0d             	cmp    $0xd,%ebx
801008db:	0f 84 02 01 00 00    	je     801009e3 <consoleintr+0x183>
        input.buf[input.e++ % INPUT_BUF] = c;
801008e1:	88 98 20 0f 11 80    	mov    %bl,-0x7feef0e0(%eax)
  if(panicked){
801008e7:	85 d2                	test   %edx,%edx
801008e9:	0f 85 ff 00 00 00    	jne    801009ee <consoleintr+0x18e>
801008ef:	89 d8                	mov    %ebx,%eax
801008f1:	e8 1a fb ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008f6:	83 fb 0a             	cmp    $0xa,%ebx
801008f9:	0f 84 0f 01 00 00    	je     80100a0e <consoleintr+0x1ae>
801008ff:	83 fb 04             	cmp    $0x4,%ebx
80100902:	0f 84 06 01 00 00    	je     80100a0e <consoleintr+0x1ae>
80100908:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
8010090d:	83 e8 80             	sub    $0xffffff80,%eax
80100910:	39 05 a8 0f 11 80    	cmp    %eax,0x80110fa8
80100916:	75 80                	jne    80100898 <consoleintr+0x38>
80100918:	e9 f6 00 00 00       	jmp    80100a13 <consoleintr+0x1b3>
8010091d:	8d 76 00             	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100920:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100925:	39 05 a4 0f 11 80    	cmp    %eax,0x80110fa4
8010092b:	0f 84 67 ff ff ff    	je     80100898 <consoleintr+0x38>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100931:	83 e8 01             	sub    $0x1,%eax
80100934:	89 c2                	mov    %eax,%edx
80100936:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100939:	80 ba 20 0f 11 80 0a 	cmpb   $0xa,-0x7feef0e0(%edx)
80100940:	0f 84 52 ff ff ff    	je     80100898 <consoleintr+0x38>
  if(panicked){
80100946:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
        input.e--;
8010094c:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
  if(panicked){
80100951:	85 d2                	test   %edx,%edx
80100953:	74 0b                	je     80100960 <consoleintr+0x100>
80100955:	fa                   	cli    
    for(;;)
80100956:	eb fe                	jmp    80100956 <consoleintr+0xf6>
80100958:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010095f:	90                   	nop
80100960:	b8 00 01 00 00       	mov    $0x100,%eax
80100965:	e8 a6 fa ff ff       	call   80100410 <consputc.part.0>
      while(input.e != input.w &&
8010096a:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
8010096f:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
80100975:	75 ba                	jne    80100931 <consoleintr+0xd1>
80100977:	e9 1c ff ff ff       	jmp    80100898 <consoleintr+0x38>
8010097c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(input.e != input.w){
80100980:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100985:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
8010098b:	0f 84 07 ff ff ff    	je     80100898 <consoleintr+0x38>
        input.e--;
80100991:	83 e8 01             	sub    $0x1,%eax
80100994:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
  if(panicked){
80100999:	a1 58 b5 10 80       	mov    0x8010b558,%eax
8010099e:	85 c0                	test   %eax,%eax
801009a0:	74 16                	je     801009b8 <consoleintr+0x158>
801009a2:	fa                   	cli    
    for(;;)
801009a3:	eb fe                	jmp    801009a3 <consoleintr+0x143>
801009a5:	8d 76 00             	lea    0x0(%esi),%esi
      if(c != 0 && input.e-input.r < INPUT_BUF){
801009a8:	85 db                	test   %ebx,%ebx
801009aa:	0f 84 e8 fe ff ff    	je     80100898 <consoleintr+0x38>
801009b0:	e9 ff fe ff ff       	jmp    801008b4 <consoleintr+0x54>
801009b5:	8d 76 00             	lea    0x0(%esi),%esi
801009b8:	b8 00 01 00 00       	mov    $0x100,%eax
801009bd:	e8 4e fa ff ff       	call   80100410 <consputc.part.0>
801009c2:	e9 d1 fe ff ff       	jmp    80100898 <consoleintr+0x38>
  release(&cons.lock);
801009c7:	83 ec 0c             	sub    $0xc,%esp
801009ca:	68 20 b5 10 80       	push   $0x8010b520
801009cf:	e8 7c 43 00 00       	call   80104d50 <release>
  if(doprocdump) {
801009d4:	83 c4 10             	add    $0x10,%esp
801009d7:	85 f6                	test   %esi,%esi
801009d9:	75 1d                	jne    801009f8 <consoleintr+0x198>
}
801009db:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009de:	5b                   	pop    %ebx
801009df:	5e                   	pop    %esi
801009e0:	5f                   	pop    %edi
801009e1:	5d                   	pop    %ebp
801009e2:	c3                   	ret    
        input.buf[input.e++ % INPUT_BUF] = c;
801009e3:	c6 80 20 0f 11 80 0a 	movb   $0xa,-0x7feef0e0(%eax)
  if(panicked){
801009ea:	85 d2                	test   %edx,%edx
801009ec:	74 16                	je     80100a04 <consoleintr+0x1a4>
801009ee:	fa                   	cli    
    for(;;)
801009ef:	eb fe                	jmp    801009ef <consoleintr+0x18f>
801009f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
801009f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009fb:	5b                   	pop    %ebx
801009fc:	5e                   	pop    %esi
801009fd:	5f                   	pop    %edi
801009fe:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
801009ff:	e9 bc 3b 00 00       	jmp    801045c0 <procdump>
80100a04:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a09:	e8 02 fa ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100a0e:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
          wakeup(&input.r);
80100a13:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a16:	a3 a4 0f 11 80       	mov    %eax,0x80110fa4
          wakeup(&input.r);
80100a1b:	68 a0 0f 11 80       	push   $0x80110fa0
80100a20:	e8 9b 3a 00 00       	call   801044c0 <wakeup>
80100a25:	83 c4 10             	add    $0x10,%esp
80100a28:	e9 6b fe ff ff       	jmp    80100898 <consoleintr+0x38>
80100a2d:	8d 76 00             	lea    0x0(%esi),%esi

80100a30 <consoleinit>:

void
consoleinit(void)
{
80100a30:	f3 0f 1e fb          	endbr32 
80100a34:	55                   	push   %ebp
80100a35:	89 e5                	mov    %esp,%ebp
80100a37:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a3a:	68 68 79 10 80       	push   $0x80107968
80100a3f:	68 20 b5 10 80       	push   $0x8010b520
80100a44:	e8 c7 40 00 00       	call   80104b10 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a49:	58                   	pop    %eax
80100a4a:	5a                   	pop    %edx
80100a4b:	6a 00                	push   $0x0
80100a4d:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a4f:	c7 05 6c 19 11 80 40 	movl   $0x80100640,0x8011196c
80100a56:	06 10 80 
  devsw[CONSOLE].read = consoleread;
80100a59:	c7 05 68 19 11 80 90 	movl   $0x80100290,0x80111968
80100a60:	02 10 80 
  cons.locking = 1;
80100a63:	c7 05 54 b5 10 80 01 	movl   $0x1,0x8010b554
80100a6a:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a6d:	e8 ce 19 00 00       	call   80102440 <ioapicenable>
}
80100a72:	83 c4 10             	add    $0x10,%esp
80100a75:	c9                   	leave  
80100a76:	c3                   	ret    
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
80100a80:	f3 0f 1e fb          	endbr32 
80100a84:	55                   	push   %ebp
80100a85:	89 e5                	mov    %esp,%ebp
80100a87:	57                   	push   %edi
80100a88:	56                   	push   %esi
80100a89:	53                   	push   %ebx
80100a8a:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100a90:	e8 6b 2f 00 00       	call   80103a00 <myproc>
80100a95:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100a9b:	e8 a0 22 00 00       	call   80102d40 <begin_op>

  if((ip = namei(path)) == 0){
80100aa0:	83 ec 0c             	sub    $0xc,%esp
80100aa3:	ff 75 08             	pushl  0x8(%ebp)
80100aa6:	e8 95 15 00 00       	call   80102040 <namei>
80100aab:	83 c4 10             	add    $0x10,%esp
80100aae:	85 c0                	test   %eax,%eax
80100ab0:	0f 84 08 03 00 00    	je     80100dbe <exec+0x33e>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ab6:	83 ec 0c             	sub    $0xc,%esp
80100ab9:	89 c3                	mov    %eax,%ebx
80100abb:	50                   	push   %eax
80100abc:	e8 af 0c 00 00       	call   80101770 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100ac1:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100ac7:	6a 34                	push   $0x34
80100ac9:	6a 00                	push   $0x0
80100acb:	50                   	push   %eax
80100acc:	53                   	push   %ebx
80100acd:	e8 9e 0f 00 00       	call   80101a70 <readi>
80100ad2:	83 c4 20             	add    $0x20,%esp
80100ad5:	83 f8 34             	cmp    $0x34,%eax
80100ad8:	74 26                	je     80100b00 <exec+0x80>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100ada:	83 ec 0c             	sub    $0xc,%esp
80100add:	53                   	push   %ebx
80100ade:	e8 2d 0f 00 00       	call   80101a10 <iunlockput>
    end_op();
80100ae3:	e8 c8 22 00 00       	call   80102db0 <end_op>
80100ae8:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100aeb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100af0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100af3:	5b                   	pop    %ebx
80100af4:	5e                   	pop    %esi
80100af5:	5f                   	pop    %edi
80100af6:	5d                   	pop    %ebp
80100af7:	c3                   	ret    
80100af8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100aff:	90                   	nop
  if(elf.magic != ELF_MAGIC)
80100b00:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b07:	45 4c 46 
80100b0a:	75 ce                	jne    80100ada <exec+0x5a>
  if((pgdir = setupkvm()) == 0)
80100b0c:	e8 5f 6b 00 00       	call   80107670 <setupkvm>
80100b11:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b17:	85 c0                	test   %eax,%eax
80100b19:	74 bf                	je     80100ada <exec+0x5a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b1b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b22:	00 
80100b23:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b29:	0f 84 ae 02 00 00    	je     80100ddd <exec+0x35d>
  sz = 0;
80100b2f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b36:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b39:	31 ff                	xor    %edi,%edi
80100b3b:	e9 86 00 00 00       	jmp    80100bc6 <exec+0x146>
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
80100b73:	e8 18 69 00 00       	call   80107490 <allocuvm>
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
80100ba9:	e8 12 68 00 00       	call   801073c0 <loaduvm>
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
80100bd1:	e8 9a 0e 00 00       	call   80101a70 <readi>
80100bd6:	83 c4 10             	add    $0x10,%esp
80100bd9:	83 f8 20             	cmp    $0x20,%eax
80100bdc:	0f 84 5e ff ff ff    	je     80100b40 <exec+0xc0>
    freevm(pgdir);
80100be2:	83 ec 0c             	sub    $0xc,%esp
80100be5:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100beb:	e8 00 6a 00 00       	call   801075f0 <freevm>
  if(ip){
80100bf0:	83 c4 10             	add    $0x10,%esp
80100bf3:	e9 e2 fe ff ff       	jmp    80100ada <exec+0x5a>
80100bf8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100bff:	90                   	nop
80100c00:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100c06:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100c0c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100c12:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100c18:	83 ec 0c             	sub    $0xc,%esp
80100c1b:	53                   	push   %ebx
80100c1c:	e8 ef 0d 00 00       	call   80101a10 <iunlockput>
  end_op();
80100c21:	e8 8a 21 00 00       	call   80102db0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c26:	83 c4 0c             	add    $0xc,%esp
80100c29:	56                   	push   %esi
80100c2a:	57                   	push   %edi
80100c2b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c31:	57                   	push   %edi
80100c32:	e8 59 68 00 00       	call   80107490 <allocuvm>
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
80100c53:	e8 b8 6a 00 00       	call   80107710 <clearpteu>
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
80100ca3:	e8 f8 42 00 00       	call   80104fa0 <strlen>
80100ca8:	f7 d0                	not    %eax
80100caa:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cac:	58                   	pop    %eax
80100cad:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cb0:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cb3:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cb6:	e8 e5 42 00 00       	call   80104fa0 <strlen>
80100cbb:	83 c0 01             	add    $0x1,%eax
80100cbe:	50                   	push   %eax
80100cbf:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cc2:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cc5:	53                   	push   %ebx
80100cc6:	56                   	push   %esi
80100cc7:	e8 a4 6b 00 00       	call   80107870 <copyout>
80100ccc:	83 c4 20             	add    $0x20,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	79 ad                	jns    80100c80 <exec+0x200>
80100cd3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cd7:	90                   	nop
    freevm(pgdir);
80100cd8:	83 ec 0c             	sub    $0xc,%esp
80100cdb:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ce1:	e8 0a 69 00 00       	call   801075f0 <freevm>
80100ce6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100ce9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100cee:	e9 fd fd ff ff       	jmp    80100af0 <exec+0x70>
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
80100d33:	e8 38 6b 00 00       	call   80107870 <copyout>
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
80100d71:	e8 ea 41 00 00       	call   80104f60 <safestrcpy>
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
  curproc->priority = 3;
80100d9a:	c7 81 8c 00 00 00 03 	movl   $0x3,0x8c(%ecx)
80100da1:	00 00 00 
  switchuvm(curproc);
80100da4:	89 0c 24             	mov    %ecx,(%esp)
80100da7:	e8 84 64 00 00       	call   80107230 <switchuvm>
  freevm(oldpgdir);
80100dac:	89 3c 24             	mov    %edi,(%esp)
80100daf:	e8 3c 68 00 00       	call   801075f0 <freevm>
  return 0;
80100db4:	83 c4 10             	add    $0x10,%esp
80100db7:	31 c0                	xor    %eax,%eax
80100db9:	e9 32 fd ff ff       	jmp    80100af0 <exec+0x70>
    end_op();
80100dbe:	e8 ed 1f 00 00       	call   80102db0 <end_op>
    cprintf("exec: fail\n");
80100dc3:	83 ec 0c             	sub    $0xc,%esp
80100dc6:	68 81 79 10 80       	push   $0x80107981
80100dcb:	e8 e0 f8 ff ff       	call   801006b0 <cprintf>
    return -1;
80100dd0:	83 c4 10             	add    $0x10,%esp
80100dd3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100dd8:	e9 13 fd ff ff       	jmp    80100af0 <exec+0x70>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100ddd:	31 ff                	xor    %edi,%edi
80100ddf:	be 00 20 00 00       	mov    $0x2000,%esi
80100de4:	e9 2f fe ff ff       	jmp    80100c18 <exec+0x198>
80100de9:	66 90                	xchg   %ax,%ax
80100deb:	66 90                	xchg   %ax,%ax
80100ded:	66 90                	xchg   %ax,%ax
80100def:	90                   	nop

80100df0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100df0:	f3 0f 1e fb          	endbr32 
80100df4:	55                   	push   %ebp
80100df5:	89 e5                	mov    %esp,%ebp
80100df7:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100dfa:	68 8d 79 10 80       	push   $0x8010798d
80100dff:	68 c0 0f 11 80       	push   $0x80110fc0
80100e04:	e8 07 3d 00 00       	call   80104b10 <initlock>
}
80100e09:	83 c4 10             	add    $0x10,%esp
80100e0c:	c9                   	leave  
80100e0d:	c3                   	ret    
80100e0e:	66 90                	xchg   %ax,%ax

80100e10 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e10:	f3 0f 1e fb          	endbr32 
80100e14:	55                   	push   %ebp
80100e15:	89 e5                	mov    %esp,%ebp
80100e17:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e18:	bb f4 0f 11 80       	mov    $0x80110ff4,%ebx
{
80100e1d:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e20:	68 c0 0f 11 80       	push   $0x80110fc0
80100e25:	e8 66 3e 00 00       	call   80104c90 <acquire>
80100e2a:	83 c4 10             	add    $0x10,%esp
80100e2d:	eb 0c                	jmp    80100e3b <filealloc+0x2b>
80100e2f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e30:	83 c3 18             	add    $0x18,%ebx
80100e33:	81 fb 54 19 11 80    	cmp    $0x80111954,%ebx
80100e39:	74 25                	je     80100e60 <filealloc+0x50>
    if(f->ref == 0){
80100e3b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e3e:	85 c0                	test   %eax,%eax
80100e40:	75 ee                	jne    80100e30 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e42:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e45:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e4c:	68 c0 0f 11 80       	push   $0x80110fc0
80100e51:	e8 fa 3e 00 00       	call   80104d50 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e56:	89 d8                	mov    %ebx,%eax
      return f;
80100e58:	83 c4 10             	add    $0x10,%esp
}
80100e5b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e5e:	c9                   	leave  
80100e5f:	c3                   	ret    
  release(&ftable.lock);
80100e60:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e63:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e65:	68 c0 0f 11 80       	push   $0x80110fc0
80100e6a:	e8 e1 3e 00 00       	call   80104d50 <release>
}
80100e6f:	89 d8                	mov    %ebx,%eax
  return 0;
80100e71:	83 c4 10             	add    $0x10,%esp
}
80100e74:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e77:	c9                   	leave  
80100e78:	c3                   	ret    
80100e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100e80 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100e80:	f3 0f 1e fb          	endbr32 
80100e84:	55                   	push   %ebp
80100e85:	89 e5                	mov    %esp,%ebp
80100e87:	53                   	push   %ebx
80100e88:	83 ec 10             	sub    $0x10,%esp
80100e8b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100e8e:	68 c0 0f 11 80       	push   $0x80110fc0
80100e93:	e8 f8 3d 00 00       	call   80104c90 <acquire>
  if(f->ref < 1)
80100e98:	8b 43 04             	mov    0x4(%ebx),%eax
80100e9b:	83 c4 10             	add    $0x10,%esp
80100e9e:	85 c0                	test   %eax,%eax
80100ea0:	7e 1a                	jle    80100ebc <filedup+0x3c>
    panic("filedup");
  f->ref++;
80100ea2:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100ea5:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100ea8:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100eab:	68 c0 0f 11 80       	push   $0x80110fc0
80100eb0:	e8 9b 3e 00 00       	call   80104d50 <release>
  return f;
}
80100eb5:	89 d8                	mov    %ebx,%eax
80100eb7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100eba:	c9                   	leave  
80100ebb:	c3                   	ret    
    panic("filedup");
80100ebc:	83 ec 0c             	sub    $0xc,%esp
80100ebf:	68 94 79 10 80       	push   $0x80107994
80100ec4:	e8 c7 f4 ff ff       	call   80100390 <panic>
80100ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ed0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100ed0:	f3 0f 1e fb          	endbr32 
80100ed4:	55                   	push   %ebp
80100ed5:	89 e5                	mov    %esp,%ebp
80100ed7:	57                   	push   %edi
80100ed8:	56                   	push   %esi
80100ed9:	53                   	push   %ebx
80100eda:	83 ec 28             	sub    $0x28,%esp
80100edd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100ee0:	68 c0 0f 11 80       	push   $0x80110fc0
80100ee5:	e8 a6 3d 00 00       	call   80104c90 <acquire>
  if(f->ref < 1)
80100eea:	8b 53 04             	mov    0x4(%ebx),%edx
80100eed:	83 c4 10             	add    $0x10,%esp
80100ef0:	85 d2                	test   %edx,%edx
80100ef2:	0f 8e a1 00 00 00    	jle    80100f99 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100ef8:	83 ea 01             	sub    $0x1,%edx
80100efb:	89 53 04             	mov    %edx,0x4(%ebx)
80100efe:	75 40                	jne    80100f40 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f00:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f04:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f07:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100f09:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f0f:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f12:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f15:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f18:	68 c0 0f 11 80       	push   $0x80110fc0
  ff = *f;
80100f1d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f20:	e8 2b 3e 00 00       	call   80104d50 <release>

  if(ff.type == FD_PIPE)
80100f25:	83 c4 10             	add    $0x10,%esp
80100f28:	83 ff 01             	cmp    $0x1,%edi
80100f2b:	74 53                	je     80100f80 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f2d:	83 ff 02             	cmp    $0x2,%edi
80100f30:	74 26                	je     80100f58 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f32:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f35:	5b                   	pop    %ebx
80100f36:	5e                   	pop    %esi
80100f37:	5f                   	pop    %edi
80100f38:	5d                   	pop    %ebp
80100f39:	c3                   	ret    
80100f3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100f40:	c7 45 08 c0 0f 11 80 	movl   $0x80110fc0,0x8(%ebp)
}
80100f47:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f4a:	5b                   	pop    %ebx
80100f4b:	5e                   	pop    %esi
80100f4c:	5f                   	pop    %edi
80100f4d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f4e:	e9 fd 3d 00 00       	jmp    80104d50 <release>
80100f53:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f57:	90                   	nop
    begin_op();
80100f58:	e8 e3 1d 00 00       	call   80102d40 <begin_op>
    iput(ff.ip);
80100f5d:	83 ec 0c             	sub    $0xc,%esp
80100f60:	ff 75 e0             	pushl  -0x20(%ebp)
80100f63:	e8 38 09 00 00       	call   801018a0 <iput>
    end_op();
80100f68:	83 c4 10             	add    $0x10,%esp
}
80100f6b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f6e:	5b                   	pop    %ebx
80100f6f:	5e                   	pop    %esi
80100f70:	5f                   	pop    %edi
80100f71:	5d                   	pop    %ebp
    end_op();
80100f72:	e9 39 1e 00 00       	jmp    80102db0 <end_op>
80100f77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f7e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100f80:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100f84:	83 ec 08             	sub    $0x8,%esp
80100f87:	53                   	push   %ebx
80100f88:	56                   	push   %esi
80100f89:	e8 82 25 00 00       	call   80103510 <pipeclose>
80100f8e:	83 c4 10             	add    $0x10,%esp
}
80100f91:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f94:	5b                   	pop    %ebx
80100f95:	5e                   	pop    %esi
80100f96:	5f                   	pop    %edi
80100f97:	5d                   	pop    %ebp
80100f98:	c3                   	ret    
    panic("fileclose");
80100f99:	83 ec 0c             	sub    $0xc,%esp
80100f9c:	68 9c 79 10 80       	push   $0x8010799c
80100fa1:	e8 ea f3 ff ff       	call   80100390 <panic>
80100fa6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fad:	8d 76 00             	lea    0x0(%esi),%esi

80100fb0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100fb0:	f3 0f 1e fb          	endbr32 
80100fb4:	55                   	push   %ebp
80100fb5:	89 e5                	mov    %esp,%ebp
80100fb7:	53                   	push   %ebx
80100fb8:	83 ec 04             	sub    $0x4,%esp
80100fbb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100fbe:	83 3b 02             	cmpl   $0x2,(%ebx)
80100fc1:	75 2d                	jne    80100ff0 <filestat+0x40>
    ilock(f->ip);
80100fc3:	83 ec 0c             	sub    $0xc,%esp
80100fc6:	ff 73 10             	pushl  0x10(%ebx)
80100fc9:	e8 a2 07 00 00       	call   80101770 <ilock>
    stati(f->ip, st);
80100fce:	58                   	pop    %eax
80100fcf:	5a                   	pop    %edx
80100fd0:	ff 75 0c             	pushl  0xc(%ebp)
80100fd3:	ff 73 10             	pushl  0x10(%ebx)
80100fd6:	e8 65 0a 00 00       	call   80101a40 <stati>
    iunlock(f->ip);
80100fdb:	59                   	pop    %ecx
80100fdc:	ff 73 10             	pushl  0x10(%ebx)
80100fdf:	e8 6c 08 00 00       	call   80101850 <iunlock>
    return 0;
  }
  return -1;
}
80100fe4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80100fe7:	83 c4 10             	add    $0x10,%esp
80100fea:	31 c0                	xor    %eax,%eax
}
80100fec:	c9                   	leave  
80100fed:	c3                   	ret    
80100fee:	66 90                	xchg   %ax,%ax
80100ff0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80100ff3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100ff8:	c9                   	leave  
80100ff9:	c3                   	ret    
80100ffa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101000 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101000:	f3 0f 1e fb          	endbr32 
80101004:	55                   	push   %ebp
80101005:	89 e5                	mov    %esp,%ebp
80101007:	57                   	push   %edi
80101008:	56                   	push   %esi
80101009:	53                   	push   %ebx
8010100a:	83 ec 0c             	sub    $0xc,%esp
8010100d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101010:	8b 75 0c             	mov    0xc(%ebp),%esi
80101013:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101016:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
8010101a:	74 64                	je     80101080 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
8010101c:	8b 03                	mov    (%ebx),%eax
8010101e:	83 f8 01             	cmp    $0x1,%eax
80101021:	74 45                	je     80101068 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80101023:	83 f8 02             	cmp    $0x2,%eax
80101026:	75 5f                	jne    80101087 <fileread+0x87>
    ilock(f->ip);
80101028:	83 ec 0c             	sub    $0xc,%esp
8010102b:	ff 73 10             	pushl  0x10(%ebx)
8010102e:	e8 3d 07 00 00       	call   80101770 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101033:	57                   	push   %edi
80101034:	ff 73 14             	pushl  0x14(%ebx)
80101037:	56                   	push   %esi
80101038:	ff 73 10             	pushl  0x10(%ebx)
8010103b:	e8 30 0a 00 00       	call   80101a70 <readi>
80101040:	83 c4 20             	add    $0x20,%esp
80101043:	89 c6                	mov    %eax,%esi
80101045:	85 c0                	test   %eax,%eax
80101047:	7e 03                	jle    8010104c <fileread+0x4c>
      f->off += r;
80101049:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
8010104c:	83 ec 0c             	sub    $0xc,%esp
8010104f:	ff 73 10             	pushl  0x10(%ebx)
80101052:	e8 f9 07 00 00       	call   80101850 <iunlock>
    return r;
80101057:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
8010105a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010105d:	89 f0                	mov    %esi,%eax
8010105f:	5b                   	pop    %ebx
80101060:	5e                   	pop    %esi
80101061:	5f                   	pop    %edi
80101062:	5d                   	pop    %ebp
80101063:	c3                   	ret    
80101064:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return piperead(f->pipe, addr, n);
80101068:	8b 43 0c             	mov    0xc(%ebx),%eax
8010106b:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010106e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101071:	5b                   	pop    %ebx
80101072:	5e                   	pop    %esi
80101073:	5f                   	pop    %edi
80101074:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80101075:	e9 36 26 00 00       	jmp    801036b0 <piperead>
8010107a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101080:	be ff ff ff ff       	mov    $0xffffffff,%esi
80101085:	eb d3                	jmp    8010105a <fileread+0x5a>
  panic("fileread");
80101087:	83 ec 0c             	sub    $0xc,%esp
8010108a:	68 a6 79 10 80       	push   $0x801079a6
8010108f:	e8 fc f2 ff ff       	call   80100390 <panic>
80101094:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010109b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010109f:	90                   	nop

801010a0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801010a0:	f3 0f 1e fb          	endbr32 
801010a4:	55                   	push   %ebp
801010a5:	89 e5                	mov    %esp,%ebp
801010a7:	57                   	push   %edi
801010a8:	56                   	push   %esi
801010a9:	53                   	push   %ebx
801010aa:	83 ec 1c             	sub    $0x1c,%esp
801010ad:	8b 45 0c             	mov    0xc(%ebp),%eax
801010b0:	8b 75 08             	mov    0x8(%ebp),%esi
801010b3:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010b6:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801010b9:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
801010bd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801010c0:	0f 84 c1 00 00 00    	je     80101187 <filewrite+0xe7>
    return -1;
  if(f->type == FD_PIPE)
801010c6:	8b 06                	mov    (%esi),%eax
801010c8:	83 f8 01             	cmp    $0x1,%eax
801010cb:	0f 84 c3 00 00 00    	je     80101194 <filewrite+0xf4>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010d1:	83 f8 02             	cmp    $0x2,%eax
801010d4:	0f 85 cc 00 00 00    	jne    801011a6 <filewrite+0x106>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801010dd:	31 ff                	xor    %edi,%edi
    while(i < n){
801010df:	85 c0                	test   %eax,%eax
801010e1:	7f 34                	jg     80101117 <filewrite+0x77>
801010e3:	e9 98 00 00 00       	jmp    80101180 <filewrite+0xe0>
801010e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801010ef:	90                   	nop
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801010f0:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
801010f3:	83 ec 0c             	sub    $0xc,%esp
801010f6:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
801010f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801010fc:	e8 4f 07 00 00       	call   80101850 <iunlock>
      end_op();
80101101:	e8 aa 1c 00 00       	call   80102db0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
80101106:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101109:	83 c4 10             	add    $0x10,%esp
8010110c:	39 c3                	cmp    %eax,%ebx
8010110e:	75 60                	jne    80101170 <filewrite+0xd0>
        panic("short filewrite");
      i += r;
80101110:	01 df                	add    %ebx,%edi
    while(i < n){
80101112:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101115:	7e 69                	jle    80101180 <filewrite+0xe0>
      int n1 = n - i;
80101117:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010111a:	b8 00 06 00 00       	mov    $0x600,%eax
8010111f:	29 fb                	sub    %edi,%ebx
      if(n1 > max)
80101121:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101127:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
8010112a:	e8 11 1c 00 00       	call   80102d40 <begin_op>
      ilock(f->ip);
8010112f:	83 ec 0c             	sub    $0xc,%esp
80101132:	ff 76 10             	pushl  0x10(%esi)
80101135:	e8 36 06 00 00       	call   80101770 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010113a:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010113d:	53                   	push   %ebx
8010113e:	ff 76 14             	pushl  0x14(%esi)
80101141:	01 f8                	add    %edi,%eax
80101143:	50                   	push   %eax
80101144:	ff 76 10             	pushl  0x10(%esi)
80101147:	e8 24 0a 00 00       	call   80101b70 <writei>
8010114c:	83 c4 20             	add    $0x20,%esp
8010114f:	85 c0                	test   %eax,%eax
80101151:	7f 9d                	jg     801010f0 <filewrite+0x50>
      iunlock(f->ip);
80101153:	83 ec 0c             	sub    $0xc,%esp
80101156:	ff 76 10             	pushl  0x10(%esi)
80101159:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010115c:	e8 ef 06 00 00       	call   80101850 <iunlock>
      end_op();
80101161:	e8 4a 1c 00 00       	call   80102db0 <end_op>
      if(r < 0)
80101166:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101169:	83 c4 10             	add    $0x10,%esp
8010116c:	85 c0                	test   %eax,%eax
8010116e:	75 17                	jne    80101187 <filewrite+0xe7>
        panic("short filewrite");
80101170:	83 ec 0c             	sub    $0xc,%esp
80101173:	68 af 79 10 80       	push   $0x801079af
80101178:	e8 13 f2 ff ff       	call   80100390 <panic>
8010117d:	8d 76 00             	lea    0x0(%esi),%esi
    }
    return i == n ? n : -1;
80101180:	89 f8                	mov    %edi,%eax
80101182:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
80101185:	74 05                	je     8010118c <filewrite+0xec>
80101187:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
8010118c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010118f:	5b                   	pop    %ebx
80101190:	5e                   	pop    %esi
80101191:	5f                   	pop    %edi
80101192:	5d                   	pop    %ebp
80101193:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
80101194:	8b 46 0c             	mov    0xc(%esi),%eax
80101197:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010119a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010119d:	5b                   	pop    %ebx
8010119e:	5e                   	pop    %esi
8010119f:	5f                   	pop    %edi
801011a0:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801011a1:	e9 0a 24 00 00       	jmp    801035b0 <pipewrite>
  panic("filewrite");
801011a6:	83 ec 0c             	sub    $0xc,%esp
801011a9:	68 b5 79 10 80       	push   $0x801079b5
801011ae:	e8 dd f1 ff ff       	call   80100390 <panic>
801011b3:	66 90                	xchg   %ax,%ax
801011b5:	66 90                	xchg   %ax,%ax
801011b7:	66 90                	xchg   %ax,%ax
801011b9:	66 90                	xchg   %ax,%ax
801011bb:	66 90                	xchg   %ax,%ax
801011bd:	66 90                	xchg   %ax,%ax
801011bf:	90                   	nop

801011c0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801011c0:	55                   	push   %ebp
801011c1:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801011c3:	89 d0                	mov    %edx,%eax
801011c5:	c1 e8 0c             	shr    $0xc,%eax
801011c8:	03 05 d8 19 11 80    	add    0x801119d8,%eax
{
801011ce:	89 e5                	mov    %esp,%ebp
801011d0:	56                   	push   %esi
801011d1:	53                   	push   %ebx
801011d2:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801011d4:	83 ec 08             	sub    $0x8,%esp
801011d7:	50                   	push   %eax
801011d8:	51                   	push   %ecx
801011d9:	e8 f2 ee ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801011de:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801011e0:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
801011e3:	ba 01 00 00 00       	mov    $0x1,%edx
801011e8:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
801011eb:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
801011f1:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
801011f4:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
801011f6:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
801011fb:	85 d1                	test   %edx,%ecx
801011fd:	74 25                	je     80101224 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
801011ff:	f7 d2                	not    %edx
  log_write(bp);
80101201:	83 ec 0c             	sub    $0xc,%esp
80101204:	89 c6                	mov    %eax,%esi
  bp->data[bi/8] &= ~m;
80101206:	21 ca                	and    %ecx,%edx
80101208:	88 54 18 5c          	mov    %dl,0x5c(%eax,%ebx,1)
  log_write(bp);
8010120c:	50                   	push   %eax
8010120d:	e8 0e 1d 00 00       	call   80102f20 <log_write>
  brelse(bp);
80101212:	89 34 24             	mov    %esi,(%esp)
80101215:	e8 d6 ef ff ff       	call   801001f0 <brelse>
}
8010121a:	83 c4 10             	add    $0x10,%esp
8010121d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101220:	5b                   	pop    %ebx
80101221:	5e                   	pop    %esi
80101222:	5d                   	pop    %ebp
80101223:	c3                   	ret    
    panic("freeing free block");
80101224:	83 ec 0c             	sub    $0xc,%esp
80101227:	68 bf 79 10 80       	push   $0x801079bf
8010122c:	e8 5f f1 ff ff       	call   80100390 <panic>
80101231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101238:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010123f:	90                   	nop

80101240 <balloc>:
{
80101240:	55                   	push   %ebp
80101241:	89 e5                	mov    %esp,%ebp
80101243:	57                   	push   %edi
80101244:	56                   	push   %esi
80101245:	53                   	push   %ebx
80101246:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101249:	8b 0d c0 19 11 80    	mov    0x801119c0,%ecx
{
8010124f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101252:	85 c9                	test   %ecx,%ecx
80101254:	0f 84 87 00 00 00    	je     801012e1 <balloc+0xa1>
8010125a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101261:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101264:	83 ec 08             	sub    $0x8,%esp
80101267:	89 f0                	mov    %esi,%eax
80101269:	c1 f8 0c             	sar    $0xc,%eax
8010126c:	03 05 d8 19 11 80    	add    0x801119d8,%eax
80101272:	50                   	push   %eax
80101273:	ff 75 d8             	pushl  -0x28(%ebp)
80101276:	e8 55 ee ff ff       	call   801000d0 <bread>
8010127b:	83 c4 10             	add    $0x10,%esp
8010127e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101281:	a1 c0 19 11 80       	mov    0x801119c0,%eax
80101286:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101289:	31 c0                	xor    %eax,%eax
8010128b:	eb 2f                	jmp    801012bc <balloc+0x7c>
8010128d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101290:	89 c1                	mov    %eax,%ecx
80101292:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101297:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
8010129a:	83 e1 07             	and    $0x7,%ecx
8010129d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010129f:	89 c1                	mov    %eax,%ecx
801012a1:	c1 f9 03             	sar    $0x3,%ecx
801012a4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801012a9:	89 fa                	mov    %edi,%edx
801012ab:	85 df                	test   %ebx,%edi
801012ad:	74 41                	je     801012f0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801012af:	83 c0 01             	add    $0x1,%eax
801012b2:	83 c6 01             	add    $0x1,%esi
801012b5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801012ba:	74 05                	je     801012c1 <balloc+0x81>
801012bc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801012bf:	77 cf                	ja     80101290 <balloc+0x50>
    brelse(bp);
801012c1:	83 ec 0c             	sub    $0xc,%esp
801012c4:	ff 75 e4             	pushl  -0x1c(%ebp)
801012c7:	e8 24 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801012cc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801012d3:	83 c4 10             	add    $0x10,%esp
801012d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801012d9:	39 05 c0 19 11 80    	cmp    %eax,0x801119c0
801012df:	77 80                	ja     80101261 <balloc+0x21>
  panic("balloc: out of blocks");
801012e1:	83 ec 0c             	sub    $0xc,%esp
801012e4:	68 d2 79 10 80       	push   $0x801079d2
801012e9:	e8 a2 f0 ff ff       	call   80100390 <panic>
801012ee:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801012f0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801012f3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801012f6:	09 da                	or     %ebx,%edx
801012f8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801012fc:	57                   	push   %edi
801012fd:	e8 1e 1c 00 00       	call   80102f20 <log_write>
        brelse(bp);
80101302:	89 3c 24             	mov    %edi,(%esp)
80101305:	e8 e6 ee ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010130a:	58                   	pop    %eax
8010130b:	5a                   	pop    %edx
8010130c:	56                   	push   %esi
8010130d:	ff 75 d8             	pushl  -0x28(%ebp)
80101310:	e8 bb ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101315:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101318:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010131a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010131d:	68 00 02 00 00       	push   $0x200
80101322:	6a 00                	push   $0x0
80101324:	50                   	push   %eax
80101325:	e8 76 3a 00 00       	call   80104da0 <memset>
  log_write(bp);
8010132a:	89 1c 24             	mov    %ebx,(%esp)
8010132d:	e8 ee 1b 00 00       	call   80102f20 <log_write>
  brelse(bp);
80101332:	89 1c 24             	mov    %ebx,(%esp)
80101335:	e8 b6 ee ff ff       	call   801001f0 <brelse>
}
8010133a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010133d:	89 f0                	mov    %esi,%eax
8010133f:	5b                   	pop    %ebx
80101340:	5e                   	pop    %esi
80101341:	5f                   	pop    %edi
80101342:	5d                   	pop    %ebp
80101343:	c3                   	ret    
80101344:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010134b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010134f:	90                   	nop

80101350 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101350:	55                   	push   %ebp
80101351:	89 e5                	mov    %esp,%ebp
80101353:	57                   	push   %edi
80101354:	89 c7                	mov    %eax,%edi
80101356:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101357:	31 f6                	xor    %esi,%esi
{
80101359:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010135a:	bb 14 1a 11 80       	mov    $0x80111a14,%ebx
{
8010135f:	83 ec 28             	sub    $0x28,%esp
80101362:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101365:	68 e0 19 11 80       	push   $0x801119e0
8010136a:	e8 21 39 00 00       	call   80104c90 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010136f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101372:	83 c4 10             	add    $0x10,%esp
80101375:	eb 1b                	jmp    80101392 <iget+0x42>
80101377:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010137e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101380:	39 3b                	cmp    %edi,(%ebx)
80101382:	74 6c                	je     801013f0 <iget+0xa0>
80101384:	81 c3 90 00 00 00    	add    $0x90,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010138a:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
80101390:	73 26                	jae    801013b8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101392:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101395:	85 c9                	test   %ecx,%ecx
80101397:	7f e7                	jg     80101380 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101399:	85 f6                	test   %esi,%esi
8010139b:	75 e7                	jne    80101384 <iget+0x34>
8010139d:	89 d8                	mov    %ebx,%eax
8010139f:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013a5:	85 c9                	test   %ecx,%ecx
801013a7:	75 6e                	jne    80101417 <iget+0xc7>
801013a9:	89 c6                	mov    %eax,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013ab:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
801013b1:	72 df                	jb     80101392 <iget+0x42>
801013b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801013b7:	90                   	nop
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801013b8:	85 f6                	test   %esi,%esi
801013ba:	74 73                	je     8010142f <iget+0xdf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801013bc:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801013bf:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801013c1:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801013c4:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801013cb:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801013d2:	68 e0 19 11 80       	push   $0x801119e0
801013d7:	e8 74 39 00 00       	call   80104d50 <release>

  return ip;
801013dc:	83 c4 10             	add    $0x10,%esp
}
801013df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013e2:	89 f0                	mov    %esi,%eax
801013e4:	5b                   	pop    %ebx
801013e5:	5e                   	pop    %esi
801013e6:	5f                   	pop    %edi
801013e7:	5d                   	pop    %ebp
801013e8:	c3                   	ret    
801013e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013f0:	39 53 04             	cmp    %edx,0x4(%ebx)
801013f3:	75 8f                	jne    80101384 <iget+0x34>
      release(&icache.lock);
801013f5:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801013f8:	83 c1 01             	add    $0x1,%ecx
      return ip;
801013fb:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801013fd:	68 e0 19 11 80       	push   $0x801119e0
      ip->ref++;
80101402:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101405:	e8 46 39 00 00       	call   80104d50 <release>
      return ip;
8010140a:	83 c4 10             	add    $0x10,%esp
}
8010140d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101410:	89 f0                	mov    %esi,%eax
80101412:	5b                   	pop    %ebx
80101413:	5e                   	pop    %esi
80101414:	5f                   	pop    %edi
80101415:	5d                   	pop    %ebp
80101416:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101417:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
8010141d:	73 10                	jae    8010142f <iget+0xdf>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010141f:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101422:	85 c9                	test   %ecx,%ecx
80101424:	0f 8f 56 ff ff ff    	jg     80101380 <iget+0x30>
8010142a:	e9 6e ff ff ff       	jmp    8010139d <iget+0x4d>
    panic("iget: no inodes");
8010142f:	83 ec 0c             	sub    $0xc,%esp
80101432:	68 e8 79 10 80       	push   $0x801079e8
80101437:	e8 54 ef ff ff       	call   80100390 <panic>
8010143c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101440 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101440:	55                   	push   %ebp
80101441:	89 e5                	mov    %esp,%ebp
80101443:	57                   	push   %edi
80101444:	56                   	push   %esi
80101445:	89 c6                	mov    %eax,%esi
80101447:	53                   	push   %ebx
80101448:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010144b:	83 fa 0b             	cmp    $0xb,%edx
8010144e:	0f 86 84 00 00 00    	jbe    801014d8 <bmap+0x98>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101454:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101457:	83 fb 7f             	cmp    $0x7f,%ebx
8010145a:	0f 87 98 00 00 00    	ja     801014f8 <bmap+0xb8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101460:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101466:	8b 16                	mov    (%esi),%edx
80101468:	85 c0                	test   %eax,%eax
8010146a:	74 54                	je     801014c0 <bmap+0x80>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010146c:	83 ec 08             	sub    $0x8,%esp
8010146f:	50                   	push   %eax
80101470:	52                   	push   %edx
80101471:	e8 5a ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101476:	83 c4 10             	add    $0x10,%esp
80101479:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
    bp = bread(ip->dev, addr);
8010147d:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
8010147f:	8b 1a                	mov    (%edx),%ebx
80101481:	85 db                	test   %ebx,%ebx
80101483:	74 1b                	je     801014a0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101485:	83 ec 0c             	sub    $0xc,%esp
80101488:	57                   	push   %edi
80101489:	e8 62 ed ff ff       	call   801001f0 <brelse>
    return addr;
8010148e:	83 c4 10             	add    $0x10,%esp
  }

  panic("bmap: out of range");
}
80101491:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101494:	89 d8                	mov    %ebx,%eax
80101496:	5b                   	pop    %ebx
80101497:	5e                   	pop    %esi
80101498:	5f                   	pop    %edi
80101499:	5d                   	pop    %ebp
8010149a:	c3                   	ret    
8010149b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010149f:	90                   	nop
      a[bn] = addr = balloc(ip->dev);
801014a0:	8b 06                	mov    (%esi),%eax
801014a2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801014a5:	e8 96 fd ff ff       	call   80101240 <balloc>
801014aa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
801014ad:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801014b0:	89 c3                	mov    %eax,%ebx
801014b2:	89 02                	mov    %eax,(%edx)
      log_write(bp);
801014b4:	57                   	push   %edi
801014b5:	e8 66 1a 00 00       	call   80102f20 <log_write>
801014ba:	83 c4 10             	add    $0x10,%esp
801014bd:	eb c6                	jmp    80101485 <bmap+0x45>
801014bf:	90                   	nop
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801014c0:	89 d0                	mov    %edx,%eax
801014c2:	e8 79 fd ff ff       	call   80101240 <balloc>
801014c7:	8b 16                	mov    (%esi),%edx
801014c9:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801014cf:	eb 9b                	jmp    8010146c <bmap+0x2c>
801014d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((addr = ip->addrs[bn]) == 0)
801014d8:	8d 3c 90             	lea    (%eax,%edx,4),%edi
801014db:	8b 5f 5c             	mov    0x5c(%edi),%ebx
801014de:	85 db                	test   %ebx,%ebx
801014e0:	75 af                	jne    80101491 <bmap+0x51>
      ip->addrs[bn] = addr = balloc(ip->dev);
801014e2:	8b 00                	mov    (%eax),%eax
801014e4:	e8 57 fd ff ff       	call   80101240 <balloc>
801014e9:	89 47 5c             	mov    %eax,0x5c(%edi)
801014ec:	89 c3                	mov    %eax,%ebx
}
801014ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014f1:	89 d8                	mov    %ebx,%eax
801014f3:	5b                   	pop    %ebx
801014f4:	5e                   	pop    %esi
801014f5:	5f                   	pop    %edi
801014f6:	5d                   	pop    %ebp
801014f7:	c3                   	ret    
  panic("bmap: out of range");
801014f8:	83 ec 0c             	sub    $0xc,%esp
801014fb:	68 f8 79 10 80       	push   $0x801079f8
80101500:	e8 8b ee ff ff       	call   80100390 <panic>
80101505:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010150c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101510 <readsb>:
{
80101510:	f3 0f 1e fb          	endbr32 
80101514:	55                   	push   %ebp
80101515:	89 e5                	mov    %esp,%ebp
80101517:	56                   	push   %esi
80101518:	53                   	push   %ebx
80101519:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
8010151c:	83 ec 08             	sub    $0x8,%esp
8010151f:	6a 01                	push   $0x1
80101521:	ff 75 08             	pushl  0x8(%ebp)
80101524:	e8 a7 eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101529:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
8010152c:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010152e:	8d 40 5c             	lea    0x5c(%eax),%eax
80101531:	6a 1c                	push   $0x1c
80101533:	50                   	push   %eax
80101534:	56                   	push   %esi
80101535:	e8 06 39 00 00       	call   80104e40 <memmove>
  brelse(bp);
8010153a:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010153d:	83 c4 10             	add    $0x10,%esp
}
80101540:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101543:	5b                   	pop    %ebx
80101544:	5e                   	pop    %esi
80101545:	5d                   	pop    %ebp
  brelse(bp);
80101546:	e9 a5 ec ff ff       	jmp    801001f0 <brelse>
8010154b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010154f:	90                   	nop

80101550 <iinit>:
{
80101550:	f3 0f 1e fb          	endbr32 
80101554:	55                   	push   %ebp
80101555:	89 e5                	mov    %esp,%ebp
80101557:	53                   	push   %ebx
80101558:	bb 20 1a 11 80       	mov    $0x80111a20,%ebx
8010155d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80101560:	68 0b 7a 10 80       	push   $0x80107a0b
80101565:	68 e0 19 11 80       	push   $0x801119e0
8010156a:	e8 a1 35 00 00       	call   80104b10 <initlock>
  for(i = 0; i < NINODE; i++) {
8010156f:	83 c4 10             	add    $0x10,%esp
80101572:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    initsleeplock(&icache.inode[i].lock, "inode");
80101578:	83 ec 08             	sub    $0x8,%esp
8010157b:	68 12 7a 10 80       	push   $0x80107a12
80101580:	53                   	push   %ebx
80101581:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101587:	e8 44 34 00 00       	call   801049d0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
8010158c:	83 c4 10             	add    $0x10,%esp
8010158f:	81 fb 40 36 11 80    	cmp    $0x80113640,%ebx
80101595:	75 e1                	jne    80101578 <iinit+0x28>
  readsb(dev, &sb);
80101597:	83 ec 08             	sub    $0x8,%esp
8010159a:	68 c0 19 11 80       	push   $0x801119c0
8010159f:	ff 75 08             	pushl  0x8(%ebp)
801015a2:	e8 69 ff ff ff       	call   80101510 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801015a7:	ff 35 d8 19 11 80    	pushl  0x801119d8
801015ad:	ff 35 d4 19 11 80    	pushl  0x801119d4
801015b3:	ff 35 d0 19 11 80    	pushl  0x801119d0
801015b9:	ff 35 cc 19 11 80    	pushl  0x801119cc
801015bf:	ff 35 c8 19 11 80    	pushl  0x801119c8
801015c5:	ff 35 c4 19 11 80    	pushl  0x801119c4
801015cb:	ff 35 c0 19 11 80    	pushl  0x801119c0
801015d1:	68 78 7a 10 80       	push   $0x80107a78
801015d6:	e8 d5 f0 ff ff       	call   801006b0 <cprintf>
}
801015db:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801015de:	83 c4 30             	add    $0x30,%esp
801015e1:	c9                   	leave  
801015e2:	c3                   	ret    
801015e3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801015ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801015f0 <ialloc>:
{
801015f0:	f3 0f 1e fb          	endbr32 
801015f4:	55                   	push   %ebp
801015f5:	89 e5                	mov    %esp,%ebp
801015f7:	57                   	push   %edi
801015f8:	56                   	push   %esi
801015f9:	53                   	push   %ebx
801015fa:	83 ec 1c             	sub    $0x1c,%esp
801015fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
80101600:	83 3d c8 19 11 80 01 	cmpl   $0x1,0x801119c8
{
80101607:	8b 75 08             	mov    0x8(%ebp),%esi
8010160a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
8010160d:	0f 86 8d 00 00 00    	jbe    801016a0 <ialloc+0xb0>
80101613:	bf 01 00 00 00       	mov    $0x1,%edi
80101618:	eb 1d                	jmp    80101637 <ialloc+0x47>
8010161a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    brelse(bp);
80101620:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101623:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101626:	53                   	push   %ebx
80101627:	e8 c4 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010162c:	83 c4 10             	add    $0x10,%esp
8010162f:	3b 3d c8 19 11 80    	cmp    0x801119c8,%edi
80101635:	73 69                	jae    801016a0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101637:	89 f8                	mov    %edi,%eax
80101639:	83 ec 08             	sub    $0x8,%esp
8010163c:	c1 e8 03             	shr    $0x3,%eax
8010163f:	03 05 d4 19 11 80    	add    0x801119d4,%eax
80101645:	50                   	push   %eax
80101646:	56                   	push   %esi
80101647:	e8 84 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010164c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010164f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101651:	89 f8                	mov    %edi,%eax
80101653:	83 e0 07             	and    $0x7,%eax
80101656:	c1 e0 06             	shl    $0x6,%eax
80101659:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010165d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101661:	75 bd                	jne    80101620 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101663:	83 ec 04             	sub    $0x4,%esp
80101666:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101669:	6a 40                	push   $0x40
8010166b:	6a 00                	push   $0x0
8010166d:	51                   	push   %ecx
8010166e:	e8 2d 37 00 00       	call   80104da0 <memset>
      dip->type = type;
80101673:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101677:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010167a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010167d:	89 1c 24             	mov    %ebx,(%esp)
80101680:	e8 9b 18 00 00       	call   80102f20 <log_write>
      brelse(bp);
80101685:	89 1c 24             	mov    %ebx,(%esp)
80101688:	e8 63 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
8010168d:	83 c4 10             	add    $0x10,%esp
}
80101690:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101693:	89 fa                	mov    %edi,%edx
}
80101695:	5b                   	pop    %ebx
      return iget(dev, inum);
80101696:	89 f0                	mov    %esi,%eax
}
80101698:	5e                   	pop    %esi
80101699:	5f                   	pop    %edi
8010169a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010169b:	e9 b0 fc ff ff       	jmp    80101350 <iget>
  panic("ialloc: no inodes");
801016a0:	83 ec 0c             	sub    $0xc,%esp
801016a3:	68 18 7a 10 80       	push   $0x80107a18
801016a8:	e8 e3 ec ff ff       	call   80100390 <panic>
801016ad:	8d 76 00             	lea    0x0(%esi),%esi

801016b0 <iupdate>:
{
801016b0:	f3 0f 1e fb          	endbr32 
801016b4:	55                   	push   %ebp
801016b5:	89 e5                	mov    %esp,%ebp
801016b7:	56                   	push   %esi
801016b8:	53                   	push   %ebx
801016b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016bc:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016bf:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016c2:	83 ec 08             	sub    $0x8,%esp
801016c5:	c1 e8 03             	shr    $0x3,%eax
801016c8:	03 05 d4 19 11 80    	add    0x801119d4,%eax
801016ce:	50                   	push   %eax
801016cf:	ff 73 a4             	pushl  -0x5c(%ebx)
801016d2:	e8 f9 e9 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
801016d7:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016db:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016de:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016e0:	8b 43 a8             	mov    -0x58(%ebx),%eax
801016e3:	83 e0 07             	and    $0x7,%eax
801016e6:	c1 e0 06             	shl    $0x6,%eax
801016e9:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801016ed:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801016f0:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016f4:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
801016f7:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
801016fb:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801016ff:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
80101703:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101707:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
8010170b:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010170e:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101711:	6a 34                	push   $0x34
80101713:	53                   	push   %ebx
80101714:	50                   	push   %eax
80101715:	e8 26 37 00 00       	call   80104e40 <memmove>
  log_write(bp);
8010171a:	89 34 24             	mov    %esi,(%esp)
8010171d:	e8 fe 17 00 00       	call   80102f20 <log_write>
  brelse(bp);
80101722:	89 75 08             	mov    %esi,0x8(%ebp)
80101725:	83 c4 10             	add    $0x10,%esp
}
80101728:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010172b:	5b                   	pop    %ebx
8010172c:	5e                   	pop    %esi
8010172d:	5d                   	pop    %ebp
  brelse(bp);
8010172e:	e9 bd ea ff ff       	jmp    801001f0 <brelse>
80101733:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010173a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101740 <idup>:
{
80101740:	f3 0f 1e fb          	endbr32 
80101744:	55                   	push   %ebp
80101745:	89 e5                	mov    %esp,%ebp
80101747:	53                   	push   %ebx
80101748:	83 ec 10             	sub    $0x10,%esp
8010174b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010174e:	68 e0 19 11 80       	push   $0x801119e0
80101753:	e8 38 35 00 00       	call   80104c90 <acquire>
  ip->ref++;
80101758:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010175c:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101763:	e8 e8 35 00 00       	call   80104d50 <release>
}
80101768:	89 d8                	mov    %ebx,%eax
8010176a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010176d:	c9                   	leave  
8010176e:	c3                   	ret    
8010176f:	90                   	nop

80101770 <ilock>:
{
80101770:	f3 0f 1e fb          	endbr32 
80101774:	55                   	push   %ebp
80101775:	89 e5                	mov    %esp,%ebp
80101777:	56                   	push   %esi
80101778:	53                   	push   %ebx
80101779:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
8010177c:	85 db                	test   %ebx,%ebx
8010177e:	0f 84 b3 00 00 00    	je     80101837 <ilock+0xc7>
80101784:	8b 53 08             	mov    0x8(%ebx),%edx
80101787:	85 d2                	test   %edx,%edx
80101789:	0f 8e a8 00 00 00    	jle    80101837 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010178f:	83 ec 0c             	sub    $0xc,%esp
80101792:	8d 43 0c             	lea    0xc(%ebx),%eax
80101795:	50                   	push   %eax
80101796:	e8 75 32 00 00       	call   80104a10 <acquiresleep>
  if(ip->valid == 0){
8010179b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010179e:	83 c4 10             	add    $0x10,%esp
801017a1:	85 c0                	test   %eax,%eax
801017a3:	74 0b                	je     801017b0 <ilock+0x40>
}
801017a5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017a8:	5b                   	pop    %ebx
801017a9:	5e                   	pop    %esi
801017aa:	5d                   	pop    %ebp
801017ab:	c3                   	ret    
801017ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017b0:	8b 43 04             	mov    0x4(%ebx),%eax
801017b3:	83 ec 08             	sub    $0x8,%esp
801017b6:	c1 e8 03             	shr    $0x3,%eax
801017b9:	03 05 d4 19 11 80    	add    0x801119d4,%eax
801017bf:	50                   	push   %eax
801017c0:	ff 33                	pushl  (%ebx)
801017c2:	e8 09 e9 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017c7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017ca:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017cc:	8b 43 04             	mov    0x4(%ebx),%eax
801017cf:	83 e0 07             	and    $0x7,%eax
801017d2:	c1 e0 06             	shl    $0x6,%eax
801017d5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801017d9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017dc:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801017df:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801017e3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801017e7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801017eb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801017ef:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801017f3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801017f7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801017fb:	8b 50 fc             	mov    -0x4(%eax),%edx
801017fe:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101801:	6a 34                	push   $0x34
80101803:	50                   	push   %eax
80101804:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101807:	50                   	push   %eax
80101808:	e8 33 36 00 00       	call   80104e40 <memmove>
    brelse(bp);
8010180d:	89 34 24             	mov    %esi,(%esp)
80101810:	e8 db e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101815:	83 c4 10             	add    $0x10,%esp
80101818:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010181d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101824:	0f 85 7b ff ff ff    	jne    801017a5 <ilock+0x35>
      panic("ilock: no type");
8010182a:	83 ec 0c             	sub    $0xc,%esp
8010182d:	68 30 7a 10 80       	push   $0x80107a30
80101832:	e8 59 eb ff ff       	call   80100390 <panic>
    panic("ilock");
80101837:	83 ec 0c             	sub    $0xc,%esp
8010183a:	68 2a 7a 10 80       	push   $0x80107a2a
8010183f:	e8 4c eb ff ff       	call   80100390 <panic>
80101844:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010184b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010184f:	90                   	nop

80101850 <iunlock>:
{
80101850:	f3 0f 1e fb          	endbr32 
80101854:	55                   	push   %ebp
80101855:	89 e5                	mov    %esp,%ebp
80101857:	56                   	push   %esi
80101858:	53                   	push   %ebx
80101859:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
8010185c:	85 db                	test   %ebx,%ebx
8010185e:	74 28                	je     80101888 <iunlock+0x38>
80101860:	83 ec 0c             	sub    $0xc,%esp
80101863:	8d 73 0c             	lea    0xc(%ebx),%esi
80101866:	56                   	push   %esi
80101867:	e8 44 32 00 00       	call   80104ab0 <holdingsleep>
8010186c:	83 c4 10             	add    $0x10,%esp
8010186f:	85 c0                	test   %eax,%eax
80101871:	74 15                	je     80101888 <iunlock+0x38>
80101873:	8b 43 08             	mov    0x8(%ebx),%eax
80101876:	85 c0                	test   %eax,%eax
80101878:	7e 0e                	jle    80101888 <iunlock+0x38>
  releasesleep(&ip->lock);
8010187a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010187d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101880:	5b                   	pop    %ebx
80101881:	5e                   	pop    %esi
80101882:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101883:	e9 e8 31 00 00       	jmp    80104a70 <releasesleep>
    panic("iunlock");
80101888:	83 ec 0c             	sub    $0xc,%esp
8010188b:	68 3f 7a 10 80       	push   $0x80107a3f
80101890:	e8 fb ea ff ff       	call   80100390 <panic>
80101895:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010189c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801018a0 <iput>:
{
801018a0:	f3 0f 1e fb          	endbr32 
801018a4:	55                   	push   %ebp
801018a5:	89 e5                	mov    %esp,%ebp
801018a7:	57                   	push   %edi
801018a8:	56                   	push   %esi
801018a9:	53                   	push   %ebx
801018aa:	83 ec 28             	sub    $0x28,%esp
801018ad:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801018b0:	8d 7b 0c             	lea    0xc(%ebx),%edi
801018b3:	57                   	push   %edi
801018b4:	e8 57 31 00 00       	call   80104a10 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801018b9:	8b 53 4c             	mov    0x4c(%ebx),%edx
801018bc:	83 c4 10             	add    $0x10,%esp
801018bf:	85 d2                	test   %edx,%edx
801018c1:	74 07                	je     801018ca <iput+0x2a>
801018c3:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801018c8:	74 36                	je     80101900 <iput+0x60>
  releasesleep(&ip->lock);
801018ca:	83 ec 0c             	sub    $0xc,%esp
801018cd:	57                   	push   %edi
801018ce:	e8 9d 31 00 00       	call   80104a70 <releasesleep>
  acquire(&icache.lock);
801018d3:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
801018da:	e8 b1 33 00 00       	call   80104c90 <acquire>
  ip->ref--;
801018df:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801018e3:	83 c4 10             	add    $0x10,%esp
801018e6:	c7 45 08 e0 19 11 80 	movl   $0x801119e0,0x8(%ebp)
}
801018ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018f0:	5b                   	pop    %ebx
801018f1:	5e                   	pop    %esi
801018f2:	5f                   	pop    %edi
801018f3:	5d                   	pop    %ebp
  release(&icache.lock);
801018f4:	e9 57 34 00 00       	jmp    80104d50 <release>
801018f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&icache.lock);
80101900:	83 ec 0c             	sub    $0xc,%esp
80101903:	68 e0 19 11 80       	push   $0x801119e0
80101908:	e8 83 33 00 00       	call   80104c90 <acquire>
    int r = ip->ref;
8010190d:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101910:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101917:	e8 34 34 00 00       	call   80104d50 <release>
    if(r == 1){
8010191c:	83 c4 10             	add    $0x10,%esp
8010191f:	83 fe 01             	cmp    $0x1,%esi
80101922:	75 a6                	jne    801018ca <iput+0x2a>
80101924:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
8010192a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
8010192d:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101930:	89 cf                	mov    %ecx,%edi
80101932:	eb 0b                	jmp    8010193f <iput+0x9f>
80101934:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101938:	83 c6 04             	add    $0x4,%esi
8010193b:	39 fe                	cmp    %edi,%esi
8010193d:	74 19                	je     80101958 <iput+0xb8>
    if(ip->addrs[i]){
8010193f:	8b 16                	mov    (%esi),%edx
80101941:	85 d2                	test   %edx,%edx
80101943:	74 f3                	je     80101938 <iput+0x98>
      bfree(ip->dev, ip->addrs[i]);
80101945:	8b 03                	mov    (%ebx),%eax
80101947:	e8 74 f8 ff ff       	call   801011c0 <bfree>
      ip->addrs[i] = 0;
8010194c:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101952:	eb e4                	jmp    80101938 <iput+0x98>
80101954:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101958:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
8010195e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101961:	85 c0                	test   %eax,%eax
80101963:	75 33                	jne    80101998 <iput+0xf8>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101965:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101968:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
8010196f:	53                   	push   %ebx
80101970:	e8 3b fd ff ff       	call   801016b0 <iupdate>
      ip->type = 0;
80101975:	31 c0                	xor    %eax,%eax
80101977:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
8010197b:	89 1c 24             	mov    %ebx,(%esp)
8010197e:	e8 2d fd ff ff       	call   801016b0 <iupdate>
      ip->valid = 0;
80101983:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
8010198a:	83 c4 10             	add    $0x10,%esp
8010198d:	e9 38 ff ff ff       	jmp    801018ca <iput+0x2a>
80101992:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101998:	83 ec 08             	sub    $0x8,%esp
8010199b:	50                   	push   %eax
8010199c:	ff 33                	pushl  (%ebx)
8010199e:	e8 2d e7 ff ff       	call   801000d0 <bread>
801019a3:	89 7d e0             	mov    %edi,-0x20(%ebp)
801019a6:	83 c4 10             	add    $0x10,%esp
801019a9:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801019af:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
801019b2:	8d 70 5c             	lea    0x5c(%eax),%esi
801019b5:	89 cf                	mov    %ecx,%edi
801019b7:	eb 0e                	jmp    801019c7 <iput+0x127>
801019b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019c0:	83 c6 04             	add    $0x4,%esi
801019c3:	39 f7                	cmp    %esi,%edi
801019c5:	74 19                	je     801019e0 <iput+0x140>
      if(a[j])
801019c7:	8b 16                	mov    (%esi),%edx
801019c9:	85 d2                	test   %edx,%edx
801019cb:	74 f3                	je     801019c0 <iput+0x120>
        bfree(ip->dev, a[j]);
801019cd:	8b 03                	mov    (%ebx),%eax
801019cf:	e8 ec f7 ff ff       	call   801011c0 <bfree>
801019d4:	eb ea                	jmp    801019c0 <iput+0x120>
801019d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019dd:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
801019e0:	83 ec 0c             	sub    $0xc,%esp
801019e3:	ff 75 e4             	pushl  -0x1c(%ebp)
801019e6:	8b 7d e0             	mov    -0x20(%ebp),%edi
801019e9:	e8 02 e8 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801019ee:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801019f4:	8b 03                	mov    (%ebx),%eax
801019f6:	e8 c5 f7 ff ff       	call   801011c0 <bfree>
    ip->addrs[NDIRECT] = 0;
801019fb:	83 c4 10             	add    $0x10,%esp
801019fe:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101a05:	00 00 00 
80101a08:	e9 58 ff ff ff       	jmp    80101965 <iput+0xc5>
80101a0d:	8d 76 00             	lea    0x0(%esi),%esi

80101a10 <iunlockput>:
{
80101a10:	f3 0f 1e fb          	endbr32 
80101a14:	55                   	push   %ebp
80101a15:	89 e5                	mov    %esp,%ebp
80101a17:	53                   	push   %ebx
80101a18:	83 ec 10             	sub    $0x10,%esp
80101a1b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101a1e:	53                   	push   %ebx
80101a1f:	e8 2c fe ff ff       	call   80101850 <iunlock>
  iput(ip);
80101a24:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a27:	83 c4 10             	add    $0x10,%esp
}
80101a2a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101a2d:	c9                   	leave  
  iput(ip);
80101a2e:	e9 6d fe ff ff       	jmp    801018a0 <iput>
80101a33:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101a40 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101a40:	f3 0f 1e fb          	endbr32 
80101a44:	55                   	push   %ebp
80101a45:	89 e5                	mov    %esp,%ebp
80101a47:	8b 55 08             	mov    0x8(%ebp),%edx
80101a4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101a4d:	8b 0a                	mov    (%edx),%ecx
80101a4f:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101a52:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a55:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a58:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a5c:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a5f:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a63:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101a67:	8b 52 58             	mov    0x58(%edx),%edx
80101a6a:	89 50 10             	mov    %edx,0x10(%eax)
}
80101a6d:	5d                   	pop    %ebp
80101a6e:	c3                   	ret    
80101a6f:	90                   	nop

80101a70 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101a70:	f3 0f 1e fb          	endbr32 
80101a74:	55                   	push   %ebp
80101a75:	89 e5                	mov    %esp,%ebp
80101a77:	57                   	push   %edi
80101a78:	56                   	push   %esi
80101a79:	53                   	push   %ebx
80101a7a:	83 ec 1c             	sub    $0x1c,%esp
80101a7d:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101a80:	8b 45 08             	mov    0x8(%ebp),%eax
80101a83:	8b 75 10             	mov    0x10(%ebp),%esi
80101a86:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101a89:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a8c:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a91:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a94:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101a97:	0f 84 a3 00 00 00    	je     80101b40 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101a9d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101aa0:	8b 40 58             	mov    0x58(%eax),%eax
80101aa3:	39 c6                	cmp    %eax,%esi
80101aa5:	0f 87 b6 00 00 00    	ja     80101b61 <readi+0xf1>
80101aab:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101aae:	31 c9                	xor    %ecx,%ecx
80101ab0:	89 da                	mov    %ebx,%edx
80101ab2:	01 f2                	add    %esi,%edx
80101ab4:	0f 92 c1             	setb   %cl
80101ab7:	89 cf                	mov    %ecx,%edi
80101ab9:	0f 82 a2 00 00 00    	jb     80101b61 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101abf:	89 c1                	mov    %eax,%ecx
80101ac1:	29 f1                	sub    %esi,%ecx
80101ac3:	39 d0                	cmp    %edx,%eax
80101ac5:	0f 43 cb             	cmovae %ebx,%ecx
80101ac8:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101acb:	85 c9                	test   %ecx,%ecx
80101acd:	74 63                	je     80101b32 <readi+0xc2>
80101acf:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ad0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101ad3:	89 f2                	mov    %esi,%edx
80101ad5:	c1 ea 09             	shr    $0x9,%edx
80101ad8:	89 d8                	mov    %ebx,%eax
80101ada:	e8 61 f9 ff ff       	call   80101440 <bmap>
80101adf:	83 ec 08             	sub    $0x8,%esp
80101ae2:	50                   	push   %eax
80101ae3:	ff 33                	pushl  (%ebx)
80101ae5:	e8 e6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101aea:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101aed:	b9 00 02 00 00       	mov    $0x200,%ecx
80101af2:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101af5:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101af7:	89 f0                	mov    %esi,%eax
80101af9:	25 ff 01 00 00       	and    $0x1ff,%eax
80101afe:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b00:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101b03:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101b05:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b09:	39 d9                	cmp    %ebx,%ecx
80101b0b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b0e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b0f:	01 df                	add    %ebx,%edi
80101b11:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101b13:	50                   	push   %eax
80101b14:	ff 75 e0             	pushl  -0x20(%ebp)
80101b17:	e8 24 33 00 00       	call   80104e40 <memmove>
    brelse(bp);
80101b1c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b1f:	89 14 24             	mov    %edx,(%esp)
80101b22:	e8 c9 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b27:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b2a:	83 c4 10             	add    $0x10,%esp
80101b2d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101b30:	77 9e                	ja     80101ad0 <readi+0x60>
  }
  return n;
80101b32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101b35:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b38:	5b                   	pop    %ebx
80101b39:	5e                   	pop    %esi
80101b3a:	5f                   	pop    %edi
80101b3b:	5d                   	pop    %ebp
80101b3c:	c3                   	ret    
80101b3d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101b40:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b44:	66 83 f8 09          	cmp    $0x9,%ax
80101b48:	77 17                	ja     80101b61 <readi+0xf1>
80101b4a:	8b 04 c5 60 19 11 80 	mov    -0x7feee6a0(,%eax,8),%eax
80101b51:	85 c0                	test   %eax,%eax
80101b53:	74 0c                	je     80101b61 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101b55:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b5b:	5b                   	pop    %ebx
80101b5c:	5e                   	pop    %esi
80101b5d:	5f                   	pop    %edi
80101b5e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101b5f:	ff e0                	jmp    *%eax
      return -1;
80101b61:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b66:	eb cd                	jmp    80101b35 <readi+0xc5>
80101b68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b6f:	90                   	nop

80101b70 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101b70:	f3 0f 1e fb          	endbr32 
80101b74:	55                   	push   %ebp
80101b75:	89 e5                	mov    %esp,%ebp
80101b77:	57                   	push   %edi
80101b78:	56                   	push   %esi
80101b79:	53                   	push   %ebx
80101b7a:	83 ec 1c             	sub    $0x1c,%esp
80101b7d:	8b 45 08             	mov    0x8(%ebp),%eax
80101b80:	8b 75 0c             	mov    0xc(%ebp),%esi
80101b83:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b86:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101b8b:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101b8e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101b91:	8b 75 10             	mov    0x10(%ebp),%esi
80101b94:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101b97:	0f 84 b3 00 00 00    	je     80101c50 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101b9d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101ba0:	39 70 58             	cmp    %esi,0x58(%eax)
80101ba3:	0f 82 e3 00 00 00    	jb     80101c8c <writei+0x11c>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101ba9:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101bac:	89 f8                	mov    %edi,%eax
80101bae:	01 f0                	add    %esi,%eax
80101bb0:	0f 82 d6 00 00 00    	jb     80101c8c <writei+0x11c>
80101bb6:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101bbb:	0f 87 cb 00 00 00    	ja     80101c8c <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bc1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101bc8:	85 ff                	test   %edi,%edi
80101bca:	74 75                	je     80101c41 <writei+0xd1>
80101bcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101bd0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101bd3:	89 f2                	mov    %esi,%edx
80101bd5:	c1 ea 09             	shr    $0x9,%edx
80101bd8:	89 f8                	mov    %edi,%eax
80101bda:	e8 61 f8 ff ff       	call   80101440 <bmap>
80101bdf:	83 ec 08             	sub    $0x8,%esp
80101be2:	50                   	push   %eax
80101be3:	ff 37                	pushl  (%edi)
80101be5:	e8 e6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101bea:	b9 00 02 00 00       	mov    $0x200,%ecx
80101bef:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101bf2:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101bf5:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101bf7:	89 f0                	mov    %esi,%eax
80101bf9:	83 c4 0c             	add    $0xc,%esp
80101bfc:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c01:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101c03:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c07:	39 d9                	cmp    %ebx,%ecx
80101c09:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101c0c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c0d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101c0f:	ff 75 dc             	pushl  -0x24(%ebp)
80101c12:	50                   	push   %eax
80101c13:	e8 28 32 00 00       	call   80104e40 <memmove>
    log_write(bp);
80101c18:	89 3c 24             	mov    %edi,(%esp)
80101c1b:	e8 00 13 00 00       	call   80102f20 <log_write>
    brelse(bp);
80101c20:	89 3c 24             	mov    %edi,(%esp)
80101c23:	e8 c8 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c28:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c2b:	83 c4 10             	add    $0x10,%esp
80101c2e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c31:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101c34:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101c37:	77 97                	ja     80101bd0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101c39:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c3c:	3b 70 58             	cmp    0x58(%eax),%esi
80101c3f:	77 37                	ja     80101c78 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101c41:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101c44:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c47:	5b                   	pop    %ebx
80101c48:	5e                   	pop    %esi
80101c49:	5f                   	pop    %edi
80101c4a:	5d                   	pop    %ebp
80101c4b:	c3                   	ret    
80101c4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c50:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c54:	66 83 f8 09          	cmp    $0x9,%ax
80101c58:	77 32                	ja     80101c8c <writei+0x11c>
80101c5a:	8b 04 c5 64 19 11 80 	mov    -0x7feee69c(,%eax,8),%eax
80101c61:	85 c0                	test   %eax,%eax
80101c63:	74 27                	je     80101c8c <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101c65:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101c68:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c6b:	5b                   	pop    %ebx
80101c6c:	5e                   	pop    %esi
80101c6d:	5f                   	pop    %edi
80101c6e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101c6f:	ff e0                	jmp    *%eax
80101c71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101c78:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101c7b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101c7e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101c81:	50                   	push   %eax
80101c82:	e8 29 fa ff ff       	call   801016b0 <iupdate>
80101c87:	83 c4 10             	add    $0x10,%esp
80101c8a:	eb b5                	jmp    80101c41 <writei+0xd1>
      return -1;
80101c8c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c91:	eb b1                	jmp    80101c44 <writei+0xd4>
80101c93:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101ca0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101ca0:	f3 0f 1e fb          	endbr32 
80101ca4:	55                   	push   %ebp
80101ca5:	89 e5                	mov    %esp,%ebp
80101ca7:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101caa:	6a 0e                	push   $0xe
80101cac:	ff 75 0c             	pushl  0xc(%ebp)
80101caf:	ff 75 08             	pushl  0x8(%ebp)
80101cb2:	e8 f9 31 00 00       	call   80104eb0 <strncmp>
}
80101cb7:	c9                   	leave  
80101cb8:	c3                   	ret    
80101cb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101cc0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101cc0:	f3 0f 1e fb          	endbr32 
80101cc4:	55                   	push   %ebp
80101cc5:	89 e5                	mov    %esp,%ebp
80101cc7:	57                   	push   %edi
80101cc8:	56                   	push   %esi
80101cc9:	53                   	push   %ebx
80101cca:	83 ec 1c             	sub    $0x1c,%esp
80101ccd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101cd0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101cd5:	0f 85 89 00 00 00    	jne    80101d64 <dirlookup+0xa4>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101cdb:	8b 53 58             	mov    0x58(%ebx),%edx
80101cde:	31 ff                	xor    %edi,%edi
80101ce0:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101ce3:	85 d2                	test   %edx,%edx
80101ce5:	74 42                	je     80101d29 <dirlookup+0x69>
80101ce7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cee:	66 90                	xchg   %ax,%ax
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101cf0:	6a 10                	push   $0x10
80101cf2:	57                   	push   %edi
80101cf3:	56                   	push   %esi
80101cf4:	53                   	push   %ebx
80101cf5:	e8 76 fd ff ff       	call   80101a70 <readi>
80101cfa:	83 c4 10             	add    $0x10,%esp
80101cfd:	83 f8 10             	cmp    $0x10,%eax
80101d00:	75 55                	jne    80101d57 <dirlookup+0x97>
      panic("dirlookup read");
    if(de.inum == 0)
80101d02:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d07:	74 18                	je     80101d21 <dirlookup+0x61>
  return strncmp(s, t, DIRSIZ);
80101d09:	83 ec 04             	sub    $0x4,%esp
80101d0c:	8d 45 da             	lea    -0x26(%ebp),%eax
80101d0f:	6a 0e                	push   $0xe
80101d11:	50                   	push   %eax
80101d12:	ff 75 0c             	pushl  0xc(%ebp)
80101d15:	e8 96 31 00 00       	call   80104eb0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d1a:	83 c4 10             	add    $0x10,%esp
80101d1d:	85 c0                	test   %eax,%eax
80101d1f:	74 17                	je     80101d38 <dirlookup+0x78>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d21:	83 c7 10             	add    $0x10,%edi
80101d24:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d27:	72 c7                	jb     80101cf0 <dirlookup+0x30>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101d29:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101d2c:	31 c0                	xor    %eax,%eax
}
80101d2e:	5b                   	pop    %ebx
80101d2f:	5e                   	pop    %esi
80101d30:	5f                   	pop    %edi
80101d31:	5d                   	pop    %ebp
80101d32:	c3                   	ret    
80101d33:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d37:	90                   	nop
      if(poff)
80101d38:	8b 45 10             	mov    0x10(%ebp),%eax
80101d3b:	85 c0                	test   %eax,%eax
80101d3d:	74 05                	je     80101d44 <dirlookup+0x84>
        *poff = off;
80101d3f:	8b 45 10             	mov    0x10(%ebp),%eax
80101d42:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101d44:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101d48:	8b 03                	mov    (%ebx),%eax
80101d4a:	e8 01 f6 ff ff       	call   80101350 <iget>
}
80101d4f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d52:	5b                   	pop    %ebx
80101d53:	5e                   	pop    %esi
80101d54:	5f                   	pop    %edi
80101d55:	5d                   	pop    %ebp
80101d56:	c3                   	ret    
      panic("dirlookup read");
80101d57:	83 ec 0c             	sub    $0xc,%esp
80101d5a:	68 59 7a 10 80       	push   $0x80107a59
80101d5f:	e8 2c e6 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101d64:	83 ec 0c             	sub    $0xc,%esp
80101d67:	68 47 7a 10 80       	push   $0x80107a47
80101d6c:	e8 1f e6 ff ff       	call   80100390 <panic>
80101d71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d7f:	90                   	nop

80101d80 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101d80:	55                   	push   %ebp
80101d81:	89 e5                	mov    %esp,%ebp
80101d83:	57                   	push   %edi
80101d84:	56                   	push   %esi
80101d85:	53                   	push   %ebx
80101d86:	89 c3                	mov    %eax,%ebx
80101d88:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101d8b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101d8e:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101d91:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101d94:	0f 84 86 01 00 00    	je     80101f20 <namex+0x1a0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101d9a:	e8 61 1c 00 00       	call   80103a00 <myproc>
  acquire(&icache.lock);
80101d9f:	83 ec 0c             	sub    $0xc,%esp
80101da2:	89 df                	mov    %ebx,%edi
    ip = idup(myproc()->cwd);
80101da4:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101da7:	68 e0 19 11 80       	push   $0x801119e0
80101dac:	e8 df 2e 00 00       	call   80104c90 <acquire>
  ip->ref++;
80101db1:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101db5:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101dbc:	e8 8f 2f 00 00       	call   80104d50 <release>
80101dc1:	83 c4 10             	add    $0x10,%esp
80101dc4:	eb 0d                	jmp    80101dd3 <namex+0x53>
80101dc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dcd:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
80101dd0:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101dd3:	0f b6 07             	movzbl (%edi),%eax
80101dd6:	3c 2f                	cmp    $0x2f,%al
80101dd8:	74 f6                	je     80101dd0 <namex+0x50>
  if(*path == 0)
80101dda:	84 c0                	test   %al,%al
80101ddc:	0f 84 ee 00 00 00    	je     80101ed0 <namex+0x150>
  while(*path != '/' && *path != 0)
80101de2:	0f b6 07             	movzbl (%edi),%eax
80101de5:	84 c0                	test   %al,%al
80101de7:	0f 84 fb 00 00 00    	je     80101ee8 <namex+0x168>
80101ded:	89 fb                	mov    %edi,%ebx
80101def:	3c 2f                	cmp    $0x2f,%al
80101df1:	0f 84 f1 00 00 00    	je     80101ee8 <namex+0x168>
80101df7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dfe:	66 90                	xchg   %ax,%ax
80101e00:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
    path++;
80101e04:	83 c3 01             	add    $0x1,%ebx
  while(*path != '/' && *path != 0)
80101e07:	3c 2f                	cmp    $0x2f,%al
80101e09:	74 04                	je     80101e0f <namex+0x8f>
80101e0b:	84 c0                	test   %al,%al
80101e0d:	75 f1                	jne    80101e00 <namex+0x80>
  len = path - s;
80101e0f:	89 d8                	mov    %ebx,%eax
80101e11:	29 f8                	sub    %edi,%eax
  if(len >= DIRSIZ)
80101e13:	83 f8 0d             	cmp    $0xd,%eax
80101e16:	0f 8e 84 00 00 00    	jle    80101ea0 <namex+0x120>
    memmove(name, s, DIRSIZ);
80101e1c:	83 ec 04             	sub    $0x4,%esp
80101e1f:	6a 0e                	push   $0xe
80101e21:	57                   	push   %edi
    path++;
80101e22:	89 df                	mov    %ebx,%edi
    memmove(name, s, DIRSIZ);
80101e24:	ff 75 e4             	pushl  -0x1c(%ebp)
80101e27:	e8 14 30 00 00       	call   80104e40 <memmove>
80101e2c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e2f:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e32:	75 0c                	jne    80101e40 <namex+0xc0>
80101e34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e38:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101e3b:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e3e:	74 f8                	je     80101e38 <namex+0xb8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e40:	83 ec 0c             	sub    $0xc,%esp
80101e43:	56                   	push   %esi
80101e44:	e8 27 f9 ff ff       	call   80101770 <ilock>
    if(ip->type != T_DIR){
80101e49:	83 c4 10             	add    $0x10,%esp
80101e4c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e51:	0f 85 a1 00 00 00    	jne    80101ef8 <namex+0x178>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e57:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101e5a:	85 d2                	test   %edx,%edx
80101e5c:	74 09                	je     80101e67 <namex+0xe7>
80101e5e:	80 3f 00             	cmpb   $0x0,(%edi)
80101e61:	0f 84 d9 00 00 00    	je     80101f40 <namex+0x1c0>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101e67:	83 ec 04             	sub    $0x4,%esp
80101e6a:	6a 00                	push   $0x0
80101e6c:	ff 75 e4             	pushl  -0x1c(%ebp)
80101e6f:	56                   	push   %esi
80101e70:	e8 4b fe ff ff       	call   80101cc0 <dirlookup>
80101e75:	83 c4 10             	add    $0x10,%esp
80101e78:	89 c3                	mov    %eax,%ebx
80101e7a:	85 c0                	test   %eax,%eax
80101e7c:	74 7a                	je     80101ef8 <namex+0x178>
  iunlock(ip);
80101e7e:	83 ec 0c             	sub    $0xc,%esp
80101e81:	56                   	push   %esi
80101e82:	e8 c9 f9 ff ff       	call   80101850 <iunlock>
  iput(ip);
80101e87:	89 34 24             	mov    %esi,(%esp)
80101e8a:	89 de                	mov    %ebx,%esi
80101e8c:	e8 0f fa ff ff       	call   801018a0 <iput>
80101e91:	83 c4 10             	add    $0x10,%esp
80101e94:	e9 3a ff ff ff       	jmp    80101dd3 <namex+0x53>
80101e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ea0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101ea3:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80101ea6:	89 4d dc             	mov    %ecx,-0x24(%ebp)
    memmove(name, s, len);
80101ea9:	83 ec 04             	sub    $0x4,%esp
80101eac:	50                   	push   %eax
80101ead:	57                   	push   %edi
    name[len] = 0;
80101eae:	89 df                	mov    %ebx,%edi
    memmove(name, s, len);
80101eb0:	ff 75 e4             	pushl  -0x1c(%ebp)
80101eb3:	e8 88 2f 00 00       	call   80104e40 <memmove>
    name[len] = 0;
80101eb8:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101ebb:	83 c4 10             	add    $0x10,%esp
80101ebe:	c6 00 00             	movb   $0x0,(%eax)
80101ec1:	e9 69 ff ff ff       	jmp    80101e2f <namex+0xaf>
80101ec6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ecd:	8d 76 00             	lea    0x0(%esi),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101ed0:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101ed3:	85 c0                	test   %eax,%eax
80101ed5:	0f 85 85 00 00 00    	jne    80101f60 <namex+0x1e0>
    iput(ip);
    return 0;
  }
  return ip;
}
80101edb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ede:	89 f0                	mov    %esi,%eax
80101ee0:	5b                   	pop    %ebx
80101ee1:	5e                   	pop    %esi
80101ee2:	5f                   	pop    %edi
80101ee3:	5d                   	pop    %ebp
80101ee4:	c3                   	ret    
80101ee5:	8d 76 00             	lea    0x0(%esi),%esi
  while(*path != '/' && *path != 0)
80101ee8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101eeb:	89 fb                	mov    %edi,%ebx
80101eed:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101ef0:	31 c0                	xor    %eax,%eax
80101ef2:	eb b5                	jmp    80101ea9 <namex+0x129>
80101ef4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101ef8:	83 ec 0c             	sub    $0xc,%esp
80101efb:	56                   	push   %esi
80101efc:	e8 4f f9 ff ff       	call   80101850 <iunlock>
  iput(ip);
80101f01:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101f04:	31 f6                	xor    %esi,%esi
  iput(ip);
80101f06:	e8 95 f9 ff ff       	call   801018a0 <iput>
      return 0;
80101f0b:	83 c4 10             	add    $0x10,%esp
}
80101f0e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f11:	89 f0                	mov    %esi,%eax
80101f13:	5b                   	pop    %ebx
80101f14:	5e                   	pop    %esi
80101f15:	5f                   	pop    %edi
80101f16:	5d                   	pop    %ebp
80101f17:	c3                   	ret    
80101f18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f1f:	90                   	nop
    ip = iget(ROOTDEV, ROOTINO);
80101f20:	ba 01 00 00 00       	mov    $0x1,%edx
80101f25:	b8 01 00 00 00       	mov    $0x1,%eax
80101f2a:	89 df                	mov    %ebx,%edi
80101f2c:	e8 1f f4 ff ff       	call   80101350 <iget>
80101f31:	89 c6                	mov    %eax,%esi
80101f33:	e9 9b fe ff ff       	jmp    80101dd3 <namex+0x53>
80101f38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f3f:	90                   	nop
      iunlock(ip);
80101f40:	83 ec 0c             	sub    $0xc,%esp
80101f43:	56                   	push   %esi
80101f44:	e8 07 f9 ff ff       	call   80101850 <iunlock>
      return ip;
80101f49:	83 c4 10             	add    $0x10,%esp
}
80101f4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f4f:	89 f0                	mov    %esi,%eax
80101f51:	5b                   	pop    %ebx
80101f52:	5e                   	pop    %esi
80101f53:	5f                   	pop    %edi
80101f54:	5d                   	pop    %ebp
80101f55:	c3                   	ret    
80101f56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f5d:	8d 76 00             	lea    0x0(%esi),%esi
    iput(ip);
80101f60:	83 ec 0c             	sub    $0xc,%esp
80101f63:	56                   	push   %esi
    return 0;
80101f64:	31 f6                	xor    %esi,%esi
    iput(ip);
80101f66:	e8 35 f9 ff ff       	call   801018a0 <iput>
    return 0;
80101f6b:	83 c4 10             	add    $0x10,%esp
80101f6e:	e9 68 ff ff ff       	jmp    80101edb <namex+0x15b>
80101f73:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101f80 <dirlink>:
{
80101f80:	f3 0f 1e fb          	endbr32 
80101f84:	55                   	push   %ebp
80101f85:	89 e5                	mov    %esp,%ebp
80101f87:	57                   	push   %edi
80101f88:	56                   	push   %esi
80101f89:	53                   	push   %ebx
80101f8a:	83 ec 20             	sub    $0x20,%esp
80101f8d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101f90:	6a 00                	push   $0x0
80101f92:	ff 75 0c             	pushl  0xc(%ebp)
80101f95:	53                   	push   %ebx
80101f96:	e8 25 fd ff ff       	call   80101cc0 <dirlookup>
80101f9b:	83 c4 10             	add    $0x10,%esp
80101f9e:	85 c0                	test   %eax,%eax
80101fa0:	75 6b                	jne    8010200d <dirlink+0x8d>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101fa2:	8b 7b 58             	mov    0x58(%ebx),%edi
80101fa5:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101fa8:	85 ff                	test   %edi,%edi
80101faa:	74 2d                	je     80101fd9 <dirlink+0x59>
80101fac:	31 ff                	xor    %edi,%edi
80101fae:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101fb1:	eb 0d                	jmp    80101fc0 <dirlink+0x40>
80101fb3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101fb7:	90                   	nop
80101fb8:	83 c7 10             	add    $0x10,%edi
80101fbb:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101fbe:	73 19                	jae    80101fd9 <dirlink+0x59>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fc0:	6a 10                	push   $0x10
80101fc2:	57                   	push   %edi
80101fc3:	56                   	push   %esi
80101fc4:	53                   	push   %ebx
80101fc5:	e8 a6 fa ff ff       	call   80101a70 <readi>
80101fca:	83 c4 10             	add    $0x10,%esp
80101fcd:	83 f8 10             	cmp    $0x10,%eax
80101fd0:	75 4e                	jne    80102020 <dirlink+0xa0>
    if(de.inum == 0)
80101fd2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101fd7:	75 df                	jne    80101fb8 <dirlink+0x38>
  strncpy(de.name, name, DIRSIZ);
80101fd9:	83 ec 04             	sub    $0x4,%esp
80101fdc:	8d 45 da             	lea    -0x26(%ebp),%eax
80101fdf:	6a 0e                	push   $0xe
80101fe1:	ff 75 0c             	pushl  0xc(%ebp)
80101fe4:	50                   	push   %eax
80101fe5:	e8 16 2f 00 00       	call   80104f00 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fea:	6a 10                	push   $0x10
  de.inum = inum;
80101fec:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fef:	57                   	push   %edi
80101ff0:	56                   	push   %esi
80101ff1:	53                   	push   %ebx
  de.inum = inum;
80101ff2:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ff6:	e8 75 fb ff ff       	call   80101b70 <writei>
80101ffb:	83 c4 20             	add    $0x20,%esp
80101ffe:	83 f8 10             	cmp    $0x10,%eax
80102001:	75 2a                	jne    8010202d <dirlink+0xad>
  return 0;
80102003:	31 c0                	xor    %eax,%eax
}
80102005:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102008:	5b                   	pop    %ebx
80102009:	5e                   	pop    %esi
8010200a:	5f                   	pop    %edi
8010200b:	5d                   	pop    %ebp
8010200c:	c3                   	ret    
    iput(ip);
8010200d:	83 ec 0c             	sub    $0xc,%esp
80102010:	50                   	push   %eax
80102011:	e8 8a f8 ff ff       	call   801018a0 <iput>
    return -1;
80102016:	83 c4 10             	add    $0x10,%esp
80102019:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010201e:	eb e5                	jmp    80102005 <dirlink+0x85>
      panic("dirlink read");
80102020:	83 ec 0c             	sub    $0xc,%esp
80102023:	68 68 7a 10 80       	push   $0x80107a68
80102028:	e8 63 e3 ff ff       	call   80100390 <panic>
    panic("dirlink");
8010202d:	83 ec 0c             	sub    $0xc,%esp
80102030:	68 8a 80 10 80       	push   $0x8010808a
80102035:	e8 56 e3 ff ff       	call   80100390 <panic>
8010203a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102040 <namei>:

struct inode*
namei(char *path)
{
80102040:	f3 0f 1e fb          	endbr32 
80102044:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102045:	31 d2                	xor    %edx,%edx
{
80102047:	89 e5                	mov    %esp,%ebp
80102049:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
8010204c:	8b 45 08             	mov    0x8(%ebp),%eax
8010204f:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80102052:	e8 29 fd ff ff       	call   80101d80 <namex>
}
80102057:	c9                   	leave  
80102058:	c3                   	ret    
80102059:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102060 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102060:	f3 0f 1e fb          	endbr32 
80102064:	55                   	push   %ebp
  return namex(path, 1, name);
80102065:	ba 01 00 00 00       	mov    $0x1,%edx
{
8010206a:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
8010206c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010206f:	8b 45 08             	mov    0x8(%ebp),%eax
}
80102072:	5d                   	pop    %ebp
  return namex(path, 1, name);
80102073:	e9 08 fd ff ff       	jmp    80101d80 <namex>
80102078:	66 90                	xchg   %ax,%ax
8010207a:	66 90                	xchg   %ax,%ax
8010207c:	66 90                	xchg   %ax,%ax
8010207e:	66 90                	xchg   %ax,%ax

80102080 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102080:	55                   	push   %ebp
80102081:	89 e5                	mov    %esp,%ebp
80102083:	57                   	push   %edi
80102084:	56                   	push   %esi
80102085:	53                   	push   %ebx
80102086:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102089:	85 c0                	test   %eax,%eax
8010208b:	0f 84 b4 00 00 00    	je     80102145 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102091:	8b 70 08             	mov    0x8(%eax),%esi
80102094:	89 c3                	mov    %eax,%ebx
80102096:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010209c:	0f 87 96 00 00 00    	ja     80102138 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020a2:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801020a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020ae:	66 90                	xchg   %ax,%ax
801020b0:	89 ca                	mov    %ecx,%edx
801020b2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020b3:	83 e0 c0             	and    $0xffffffc0,%eax
801020b6:	3c 40                	cmp    $0x40,%al
801020b8:	75 f6                	jne    801020b0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801020ba:	31 ff                	xor    %edi,%edi
801020bc:	ba f6 03 00 00       	mov    $0x3f6,%edx
801020c1:	89 f8                	mov    %edi,%eax
801020c3:	ee                   	out    %al,(%dx)
801020c4:	b8 01 00 00 00       	mov    $0x1,%eax
801020c9:	ba f2 01 00 00       	mov    $0x1f2,%edx
801020ce:	ee                   	out    %al,(%dx)
801020cf:	ba f3 01 00 00       	mov    $0x1f3,%edx
801020d4:	89 f0                	mov    %esi,%eax
801020d6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
801020d7:	89 f0                	mov    %esi,%eax
801020d9:	ba f4 01 00 00       	mov    $0x1f4,%edx
801020de:	c1 f8 08             	sar    $0x8,%eax
801020e1:	ee                   	out    %al,(%dx)
801020e2:	ba f5 01 00 00       	mov    $0x1f5,%edx
801020e7:	89 f8                	mov    %edi,%eax
801020e9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801020ea:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
801020ee:	ba f6 01 00 00       	mov    $0x1f6,%edx
801020f3:	c1 e0 04             	shl    $0x4,%eax
801020f6:	83 e0 10             	and    $0x10,%eax
801020f9:	83 c8 e0             	or     $0xffffffe0,%eax
801020fc:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
801020fd:	f6 03 04             	testb  $0x4,(%ebx)
80102100:	75 16                	jne    80102118 <idestart+0x98>
80102102:	b8 20 00 00 00       	mov    $0x20,%eax
80102107:	89 ca                	mov    %ecx,%edx
80102109:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010210a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010210d:	5b                   	pop    %ebx
8010210e:	5e                   	pop    %esi
8010210f:	5f                   	pop    %edi
80102110:	5d                   	pop    %ebp
80102111:	c3                   	ret    
80102112:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102118:	b8 30 00 00 00       	mov    $0x30,%eax
8010211d:	89 ca                	mov    %ecx,%edx
8010211f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102120:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102125:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102128:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010212d:	fc                   	cld    
8010212e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102130:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102133:	5b                   	pop    %ebx
80102134:	5e                   	pop    %esi
80102135:	5f                   	pop    %edi
80102136:	5d                   	pop    %ebp
80102137:	c3                   	ret    
    panic("incorrect blockno");
80102138:	83 ec 0c             	sub    $0xc,%esp
8010213b:	68 d4 7a 10 80       	push   $0x80107ad4
80102140:	e8 4b e2 ff ff       	call   80100390 <panic>
    panic("idestart");
80102145:	83 ec 0c             	sub    $0xc,%esp
80102148:	68 cb 7a 10 80       	push   $0x80107acb
8010214d:	e8 3e e2 ff ff       	call   80100390 <panic>
80102152:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102160 <ideinit>:
{
80102160:	f3 0f 1e fb          	endbr32 
80102164:	55                   	push   %ebp
80102165:	89 e5                	mov    %esp,%ebp
80102167:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
8010216a:	68 e6 7a 10 80       	push   $0x80107ae6
8010216f:	68 80 b5 10 80       	push   $0x8010b580
80102174:	e8 97 29 00 00       	call   80104b10 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102179:	58                   	pop    %eax
8010217a:	a1 00 3d 11 80       	mov    0x80113d00,%eax
8010217f:	5a                   	pop    %edx
80102180:	83 e8 01             	sub    $0x1,%eax
80102183:	50                   	push   %eax
80102184:	6a 0e                	push   $0xe
80102186:	e8 b5 02 00 00       	call   80102440 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
8010218b:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010218e:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102193:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102197:	90                   	nop
80102198:	ec                   	in     (%dx),%al
80102199:	83 e0 c0             	and    $0xffffffc0,%eax
8010219c:	3c 40                	cmp    $0x40,%al
8010219e:	75 f8                	jne    80102198 <ideinit+0x38>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021a0:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801021a5:	ba f6 01 00 00       	mov    $0x1f6,%edx
801021aa:	ee                   	out    %al,(%dx)
801021ab:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021b0:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021b5:	eb 0e                	jmp    801021c5 <ideinit+0x65>
801021b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021be:	66 90                	xchg   %ax,%ax
  for(i=0; i<1000; i++){
801021c0:	83 e9 01             	sub    $0x1,%ecx
801021c3:	74 0f                	je     801021d4 <ideinit+0x74>
801021c5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801021c6:	84 c0                	test   %al,%al
801021c8:	74 f6                	je     801021c0 <ideinit+0x60>
      havedisk1 = 1;
801021ca:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
801021d1:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021d4:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801021d9:	ba f6 01 00 00       	mov    $0x1f6,%edx
801021de:	ee                   	out    %al,(%dx)
}
801021df:	c9                   	leave  
801021e0:	c3                   	ret    
801021e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021ef:	90                   	nop

801021f0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801021f0:	f3 0f 1e fb          	endbr32 
801021f4:	55                   	push   %ebp
801021f5:	89 e5                	mov    %esp,%ebp
801021f7:	57                   	push   %edi
801021f8:	56                   	push   %esi
801021f9:	53                   	push   %ebx
801021fa:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801021fd:	68 80 b5 10 80       	push   $0x8010b580
80102202:	e8 89 2a 00 00       	call   80104c90 <acquire>

  if((b = idequeue) == 0){
80102207:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
8010220d:	83 c4 10             	add    $0x10,%esp
80102210:	85 db                	test   %ebx,%ebx
80102212:	74 5f                	je     80102273 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102214:	8b 43 58             	mov    0x58(%ebx),%eax
80102217:	a3 64 b5 10 80       	mov    %eax,0x8010b564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
8010221c:	8b 33                	mov    (%ebx),%esi
8010221e:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102224:	75 2b                	jne    80102251 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102226:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010222b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010222f:	90                   	nop
80102230:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102231:	89 c1                	mov    %eax,%ecx
80102233:	83 e1 c0             	and    $0xffffffc0,%ecx
80102236:	80 f9 40             	cmp    $0x40,%cl
80102239:	75 f5                	jne    80102230 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010223b:	a8 21                	test   $0x21,%al
8010223d:	75 12                	jne    80102251 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010223f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102242:	b9 80 00 00 00       	mov    $0x80,%ecx
80102247:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010224c:	fc                   	cld    
8010224d:	f3 6d                	rep insl (%dx),%es:(%edi)
8010224f:	8b 33                	mov    (%ebx),%esi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102251:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102254:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102257:	83 ce 02             	or     $0x2,%esi
8010225a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010225c:	53                   	push   %ebx
8010225d:	e8 5e 22 00 00       	call   801044c0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102262:	a1 64 b5 10 80       	mov    0x8010b564,%eax
80102267:	83 c4 10             	add    $0x10,%esp
8010226a:	85 c0                	test   %eax,%eax
8010226c:	74 05                	je     80102273 <ideintr+0x83>
    idestart(idequeue);
8010226e:	e8 0d fe ff ff       	call   80102080 <idestart>
    release(&idelock);
80102273:	83 ec 0c             	sub    $0xc,%esp
80102276:	68 80 b5 10 80       	push   $0x8010b580
8010227b:	e8 d0 2a 00 00       	call   80104d50 <release>

  release(&idelock);
}
80102280:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102283:	5b                   	pop    %ebx
80102284:	5e                   	pop    %esi
80102285:	5f                   	pop    %edi
80102286:	5d                   	pop    %ebp
80102287:	c3                   	ret    
80102288:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010228f:	90                   	nop

80102290 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102290:	f3 0f 1e fb          	endbr32 
80102294:	55                   	push   %ebp
80102295:	89 e5                	mov    %esp,%ebp
80102297:	53                   	push   %ebx
80102298:	83 ec 10             	sub    $0x10,%esp
8010229b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010229e:	8d 43 0c             	lea    0xc(%ebx),%eax
801022a1:	50                   	push   %eax
801022a2:	e8 09 28 00 00       	call   80104ab0 <holdingsleep>
801022a7:	83 c4 10             	add    $0x10,%esp
801022aa:	85 c0                	test   %eax,%eax
801022ac:	0f 84 cf 00 00 00    	je     80102381 <iderw+0xf1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801022b2:	8b 03                	mov    (%ebx),%eax
801022b4:	83 e0 06             	and    $0x6,%eax
801022b7:	83 f8 02             	cmp    $0x2,%eax
801022ba:	0f 84 b4 00 00 00    	je     80102374 <iderw+0xe4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801022c0:	8b 53 04             	mov    0x4(%ebx),%edx
801022c3:	85 d2                	test   %edx,%edx
801022c5:	74 0d                	je     801022d4 <iderw+0x44>
801022c7:	a1 60 b5 10 80       	mov    0x8010b560,%eax
801022cc:	85 c0                	test   %eax,%eax
801022ce:	0f 84 93 00 00 00    	je     80102367 <iderw+0xd7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801022d4:	83 ec 0c             	sub    $0xc,%esp
801022d7:	68 80 b5 10 80       	push   $0x8010b580
801022dc:	e8 af 29 00 00       	call   80104c90 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801022e1:	a1 64 b5 10 80       	mov    0x8010b564,%eax
  b->qnext = 0;
801022e6:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801022ed:	83 c4 10             	add    $0x10,%esp
801022f0:	85 c0                	test   %eax,%eax
801022f2:	74 6c                	je     80102360 <iderw+0xd0>
801022f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801022f8:	89 c2                	mov    %eax,%edx
801022fa:	8b 40 58             	mov    0x58(%eax),%eax
801022fd:	85 c0                	test   %eax,%eax
801022ff:	75 f7                	jne    801022f8 <iderw+0x68>
80102301:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102304:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102306:	39 1d 64 b5 10 80    	cmp    %ebx,0x8010b564
8010230c:	74 42                	je     80102350 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010230e:	8b 03                	mov    (%ebx),%eax
80102310:	83 e0 06             	and    $0x6,%eax
80102313:	83 f8 02             	cmp    $0x2,%eax
80102316:	74 23                	je     8010233b <iderw+0xab>
80102318:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010231f:	90                   	nop
    sleep(b, &idelock);
80102320:	83 ec 08             	sub    $0x8,%esp
80102323:	68 80 b5 10 80       	push   $0x8010b580
80102328:	53                   	push   %ebx
80102329:	e8 a2 1e 00 00       	call   801041d0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010232e:	8b 03                	mov    (%ebx),%eax
80102330:	83 c4 10             	add    $0x10,%esp
80102333:	83 e0 06             	and    $0x6,%eax
80102336:	83 f8 02             	cmp    $0x2,%eax
80102339:	75 e5                	jne    80102320 <iderw+0x90>
  }


  release(&idelock);
8010233b:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
80102342:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102345:	c9                   	leave  
  release(&idelock);
80102346:	e9 05 2a 00 00       	jmp    80104d50 <release>
8010234b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010234f:	90                   	nop
    idestart(b);
80102350:	89 d8                	mov    %ebx,%eax
80102352:	e8 29 fd ff ff       	call   80102080 <idestart>
80102357:	eb b5                	jmp    8010230e <iderw+0x7e>
80102359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102360:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
80102365:	eb 9d                	jmp    80102304 <iderw+0x74>
    panic("iderw: ide disk 1 not present");
80102367:	83 ec 0c             	sub    $0xc,%esp
8010236a:	68 15 7b 10 80       	push   $0x80107b15
8010236f:	e8 1c e0 ff ff       	call   80100390 <panic>
    panic("iderw: nothing to do");
80102374:	83 ec 0c             	sub    $0xc,%esp
80102377:	68 00 7b 10 80       	push   $0x80107b00
8010237c:	e8 0f e0 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102381:	83 ec 0c             	sub    $0xc,%esp
80102384:	68 ea 7a 10 80       	push   $0x80107aea
80102389:	e8 02 e0 ff ff       	call   80100390 <panic>
8010238e:	66 90                	xchg   %ax,%ax

80102390 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102390:	f3 0f 1e fb          	endbr32 
80102394:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102395:	c7 05 34 36 11 80 00 	movl   $0xfec00000,0x80113634
8010239c:	00 c0 fe 
{
8010239f:	89 e5                	mov    %esp,%ebp
801023a1:	56                   	push   %esi
801023a2:	53                   	push   %ebx
  ioapic->reg = reg;
801023a3:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801023aa:	00 00 00 
  return ioapic->data;
801023ad:	8b 15 34 36 11 80    	mov    0x80113634,%edx
801023b3:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801023b6:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801023bc:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801023c2:	0f b6 15 60 37 11 80 	movzbl 0x80113760,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801023c9:	c1 ee 10             	shr    $0x10,%esi
801023cc:	89 f0                	mov    %esi,%eax
801023ce:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
801023d1:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
801023d4:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
801023d7:	39 c2                	cmp    %eax,%edx
801023d9:	74 16                	je     801023f1 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801023db:	83 ec 0c             	sub    $0xc,%esp
801023de:	68 34 7b 10 80       	push   $0x80107b34
801023e3:	e8 c8 e2 ff ff       	call   801006b0 <cprintf>
801023e8:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
801023ee:	83 c4 10             	add    $0x10,%esp
801023f1:	83 c6 21             	add    $0x21,%esi
{
801023f4:	ba 10 00 00 00       	mov    $0x10,%edx
801023f9:	b8 20 00 00 00       	mov    $0x20,%eax
801023fe:	66 90                	xchg   %ax,%ax
  ioapic->reg = reg;
80102400:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102402:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102404:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
8010240a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010240d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102413:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102416:	8d 5a 01             	lea    0x1(%edx),%ebx
80102419:	83 c2 02             	add    $0x2,%edx
8010241c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010241e:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
80102424:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010242b:	39 f0                	cmp    %esi,%eax
8010242d:	75 d1                	jne    80102400 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010242f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102432:	5b                   	pop    %ebx
80102433:	5e                   	pop    %esi
80102434:	5d                   	pop    %ebp
80102435:	c3                   	ret    
80102436:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010243d:	8d 76 00             	lea    0x0(%esi),%esi

80102440 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102440:	f3 0f 1e fb          	endbr32 
80102444:	55                   	push   %ebp
  ioapic->reg = reg;
80102445:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
{
8010244b:	89 e5                	mov    %esp,%ebp
8010244d:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102450:	8d 50 20             	lea    0x20(%eax),%edx
80102453:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102457:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102459:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010245f:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102462:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102465:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102468:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
8010246a:	a1 34 36 11 80       	mov    0x80113634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010246f:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
80102472:	89 50 10             	mov    %edx,0x10(%eax)
}
80102475:	5d                   	pop    %ebp
80102476:	c3                   	ret    
80102477:	66 90                	xchg   %ax,%ax
80102479:	66 90                	xchg   %ax,%ax
8010247b:	66 90                	xchg   %ax,%ax
8010247d:	66 90                	xchg   %ax,%ax
8010247f:	90                   	nop

80102480 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102480:	f3 0f 1e fb          	endbr32 
80102484:	55                   	push   %ebp
80102485:	89 e5                	mov    %esp,%ebp
80102487:	53                   	push   %ebx
80102488:	83 ec 04             	sub    $0x4,%esp
8010248b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010248e:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102494:	75 7a                	jne    80102510 <kfree+0x90>
80102496:	81 fb a8 72 11 80    	cmp    $0x801172a8,%ebx
8010249c:	72 72                	jb     80102510 <kfree+0x90>
8010249e:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801024a4:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801024a9:	77 65                	ja     80102510 <kfree+0x90>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801024ab:	83 ec 04             	sub    $0x4,%esp
801024ae:	68 00 10 00 00       	push   $0x1000
801024b3:	6a 01                	push   $0x1
801024b5:	53                   	push   %ebx
801024b6:	e8 e5 28 00 00       	call   80104da0 <memset>

  if(kmem.use_lock)
801024bb:	8b 15 74 36 11 80    	mov    0x80113674,%edx
801024c1:	83 c4 10             	add    $0x10,%esp
801024c4:	85 d2                	test   %edx,%edx
801024c6:	75 20                	jne    801024e8 <kfree+0x68>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801024c8:	a1 78 36 11 80       	mov    0x80113678,%eax
801024cd:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801024cf:	a1 74 36 11 80       	mov    0x80113674,%eax
  kmem.freelist = r;
801024d4:	89 1d 78 36 11 80    	mov    %ebx,0x80113678
  if(kmem.use_lock)
801024da:	85 c0                	test   %eax,%eax
801024dc:	75 22                	jne    80102500 <kfree+0x80>
    release(&kmem.lock);
}
801024de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801024e1:	c9                   	leave  
801024e2:	c3                   	ret    
801024e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024e7:	90                   	nop
    acquire(&kmem.lock);
801024e8:	83 ec 0c             	sub    $0xc,%esp
801024eb:	68 40 36 11 80       	push   $0x80113640
801024f0:	e8 9b 27 00 00       	call   80104c90 <acquire>
801024f5:	83 c4 10             	add    $0x10,%esp
801024f8:	eb ce                	jmp    801024c8 <kfree+0x48>
801024fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102500:	c7 45 08 40 36 11 80 	movl   $0x80113640,0x8(%ebp)
}
80102507:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010250a:	c9                   	leave  
    release(&kmem.lock);
8010250b:	e9 40 28 00 00       	jmp    80104d50 <release>
    panic("kfree");
80102510:	83 ec 0c             	sub    $0xc,%esp
80102513:	68 66 7b 10 80       	push   $0x80107b66
80102518:	e8 73 de ff ff       	call   80100390 <panic>
8010251d:	8d 76 00             	lea    0x0(%esi),%esi

80102520 <freerange>:
{
80102520:	f3 0f 1e fb          	endbr32 
80102524:	55                   	push   %ebp
80102525:	89 e5                	mov    %esp,%ebp
80102527:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102528:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010252b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010252e:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010252f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102535:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010253b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102541:	39 de                	cmp    %ebx,%esi
80102543:	72 1f                	jb     80102564 <freerange+0x44>
80102545:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102548:	83 ec 0c             	sub    $0xc,%esp
8010254b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102551:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102557:	50                   	push   %eax
80102558:	e8 23 ff ff ff       	call   80102480 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010255d:	83 c4 10             	add    $0x10,%esp
80102560:	39 f3                	cmp    %esi,%ebx
80102562:	76 e4                	jbe    80102548 <freerange+0x28>
}
80102564:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102567:	5b                   	pop    %ebx
80102568:	5e                   	pop    %esi
80102569:	5d                   	pop    %ebp
8010256a:	c3                   	ret    
8010256b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010256f:	90                   	nop

80102570 <kinit1>:
{
80102570:	f3 0f 1e fb          	endbr32 
80102574:	55                   	push   %ebp
80102575:	89 e5                	mov    %esp,%ebp
80102577:	56                   	push   %esi
80102578:	53                   	push   %ebx
80102579:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
8010257c:	83 ec 08             	sub    $0x8,%esp
8010257f:	68 6c 7b 10 80       	push   $0x80107b6c
80102584:	68 40 36 11 80       	push   $0x80113640
80102589:	e8 82 25 00 00       	call   80104b10 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010258e:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102591:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102594:	c7 05 74 36 11 80 00 	movl   $0x0,0x80113674
8010259b:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010259e:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025a4:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025aa:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025b0:	39 de                	cmp    %ebx,%esi
801025b2:	72 20                	jb     801025d4 <kinit1+0x64>
801025b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025b8:	83 ec 0c             	sub    $0xc,%esp
801025bb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025c1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025c7:	50                   	push   %eax
801025c8:	e8 b3 fe ff ff       	call   80102480 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025cd:	83 c4 10             	add    $0x10,%esp
801025d0:	39 de                	cmp    %ebx,%esi
801025d2:	73 e4                	jae    801025b8 <kinit1+0x48>
}
801025d4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025d7:	5b                   	pop    %ebx
801025d8:	5e                   	pop    %esi
801025d9:	5d                   	pop    %ebp
801025da:	c3                   	ret    
801025db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025df:	90                   	nop

801025e0 <kinit2>:
{
801025e0:	f3 0f 1e fb          	endbr32 
801025e4:	55                   	push   %ebp
801025e5:	89 e5                	mov    %esp,%ebp
801025e7:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801025e8:	8b 45 08             	mov    0x8(%ebp),%eax
{
801025eb:	8b 75 0c             	mov    0xc(%ebp),%esi
801025ee:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801025ef:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025f5:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025fb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102601:	39 de                	cmp    %ebx,%esi
80102603:	72 1f                	jb     80102624 <kinit2+0x44>
80102605:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102608:	83 ec 0c             	sub    $0xc,%esp
8010260b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102611:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102617:	50                   	push   %eax
80102618:	e8 63 fe ff ff       	call   80102480 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010261d:	83 c4 10             	add    $0x10,%esp
80102620:	39 de                	cmp    %ebx,%esi
80102622:	73 e4                	jae    80102608 <kinit2+0x28>
  kmem.use_lock = 1;
80102624:	c7 05 74 36 11 80 01 	movl   $0x1,0x80113674
8010262b:	00 00 00 
}
8010262e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102631:	5b                   	pop    %ebx
80102632:	5e                   	pop    %esi
80102633:	5d                   	pop    %ebp
80102634:	c3                   	ret    
80102635:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010263c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102640 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102640:	f3 0f 1e fb          	endbr32 
  struct run *r;

  if(kmem.use_lock)
80102644:	a1 74 36 11 80       	mov    0x80113674,%eax
80102649:	85 c0                	test   %eax,%eax
8010264b:	75 1b                	jne    80102668 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
8010264d:	a1 78 36 11 80       	mov    0x80113678,%eax
  if(r)
80102652:	85 c0                	test   %eax,%eax
80102654:	74 0a                	je     80102660 <kalloc+0x20>
    kmem.freelist = r->next;
80102656:	8b 10                	mov    (%eax),%edx
80102658:	89 15 78 36 11 80    	mov    %edx,0x80113678
  if(kmem.use_lock)
8010265e:	c3                   	ret    
8010265f:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
80102660:	c3                   	ret    
80102661:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
80102668:	55                   	push   %ebp
80102669:	89 e5                	mov    %esp,%ebp
8010266b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
8010266e:	68 40 36 11 80       	push   $0x80113640
80102673:	e8 18 26 00 00       	call   80104c90 <acquire>
  r = kmem.freelist;
80102678:	a1 78 36 11 80       	mov    0x80113678,%eax
  if(r)
8010267d:	8b 15 74 36 11 80    	mov    0x80113674,%edx
80102683:	83 c4 10             	add    $0x10,%esp
80102686:	85 c0                	test   %eax,%eax
80102688:	74 08                	je     80102692 <kalloc+0x52>
    kmem.freelist = r->next;
8010268a:	8b 08                	mov    (%eax),%ecx
8010268c:	89 0d 78 36 11 80    	mov    %ecx,0x80113678
  if(kmem.use_lock)
80102692:	85 d2                	test   %edx,%edx
80102694:	74 16                	je     801026ac <kalloc+0x6c>
    release(&kmem.lock);
80102696:	83 ec 0c             	sub    $0xc,%esp
80102699:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010269c:	68 40 36 11 80       	push   $0x80113640
801026a1:	e8 aa 26 00 00       	call   80104d50 <release>
  return (char*)r;
801026a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
801026a9:	83 c4 10             	add    $0x10,%esp
}
801026ac:	c9                   	leave  
801026ad:	c3                   	ret    
801026ae:	66 90                	xchg   %ax,%ax

801026b0 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
801026b0:	f3 0f 1e fb          	endbr32 
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026b4:	ba 64 00 00 00       	mov    $0x64,%edx
801026b9:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801026ba:	a8 01                	test   $0x1,%al
801026bc:	0f 84 be 00 00 00    	je     80102780 <kbdgetc+0xd0>
{
801026c2:	55                   	push   %ebp
801026c3:	ba 60 00 00 00       	mov    $0x60,%edx
801026c8:	89 e5                	mov    %esp,%ebp
801026ca:	53                   	push   %ebx
801026cb:	ec                   	in     (%dx),%al
  return data;
801026cc:	8b 1d b4 b5 10 80    	mov    0x8010b5b4,%ebx
    return -1;
  data = inb(KBDATAP);
801026d2:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
801026d5:	3c e0                	cmp    $0xe0,%al
801026d7:	74 57                	je     80102730 <kbdgetc+0x80>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801026d9:	89 d9                	mov    %ebx,%ecx
801026db:	83 e1 40             	and    $0x40,%ecx
801026de:	84 c0                	test   %al,%al
801026e0:	78 5e                	js     80102740 <kbdgetc+0x90>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801026e2:	85 c9                	test   %ecx,%ecx
801026e4:	74 09                	je     801026ef <kbdgetc+0x3f>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801026e6:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801026e9:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
801026ec:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
801026ef:	0f b6 8a a0 7c 10 80 	movzbl -0x7fef8360(%edx),%ecx
  shift ^= togglecode[data];
801026f6:	0f b6 82 a0 7b 10 80 	movzbl -0x7fef8460(%edx),%eax
  shift |= shiftcode[data];
801026fd:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
801026ff:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102701:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102703:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102709:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
8010270c:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
8010270f:	8b 04 85 80 7b 10 80 	mov    -0x7fef8480(,%eax,4),%eax
80102716:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
8010271a:	74 0b                	je     80102727 <kbdgetc+0x77>
    if('a' <= c && c <= 'z')
8010271c:	8d 50 9f             	lea    -0x61(%eax),%edx
8010271f:	83 fa 19             	cmp    $0x19,%edx
80102722:	77 44                	ja     80102768 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102724:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102727:	5b                   	pop    %ebx
80102728:	5d                   	pop    %ebp
80102729:	c3                   	ret    
8010272a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    shift |= E0ESC;
80102730:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102733:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102735:	89 1d b4 b5 10 80    	mov    %ebx,0x8010b5b4
}
8010273b:	5b                   	pop    %ebx
8010273c:	5d                   	pop    %ebp
8010273d:	c3                   	ret    
8010273e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102740:	83 e0 7f             	and    $0x7f,%eax
80102743:	85 c9                	test   %ecx,%ecx
80102745:	0f 44 d0             	cmove  %eax,%edx
    return 0;
80102748:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
8010274a:	0f b6 8a a0 7c 10 80 	movzbl -0x7fef8360(%edx),%ecx
80102751:	83 c9 40             	or     $0x40,%ecx
80102754:	0f b6 c9             	movzbl %cl,%ecx
80102757:	f7 d1                	not    %ecx
80102759:	21 d9                	and    %ebx,%ecx
}
8010275b:	5b                   	pop    %ebx
8010275c:	5d                   	pop    %ebp
    shift &= ~(shiftcode[data] | E0ESC);
8010275d:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
}
80102763:	c3                   	ret    
80102764:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102768:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010276b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010276e:	5b                   	pop    %ebx
8010276f:	5d                   	pop    %ebp
      c += 'a' - 'A';
80102770:	83 f9 1a             	cmp    $0x1a,%ecx
80102773:	0f 42 c2             	cmovb  %edx,%eax
}
80102776:	c3                   	ret    
80102777:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010277e:	66 90                	xchg   %ax,%ax
    return -1;
80102780:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102785:	c3                   	ret    
80102786:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010278d:	8d 76 00             	lea    0x0(%esi),%esi

80102790 <kbdintr>:

void
kbdintr(void)
{
80102790:	f3 0f 1e fb          	endbr32 
80102794:	55                   	push   %ebp
80102795:	89 e5                	mov    %esp,%ebp
80102797:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
8010279a:	68 b0 26 10 80       	push   $0x801026b0
8010279f:	e8 bc e0 ff ff       	call   80100860 <consoleintr>
}
801027a4:	83 c4 10             	add    $0x10,%esp
801027a7:	c9                   	leave  
801027a8:	c3                   	ret    
801027a9:	66 90                	xchg   %ax,%ax
801027ab:	66 90                	xchg   %ax,%ax
801027ad:	66 90                	xchg   %ax,%ax
801027af:	90                   	nop

801027b0 <lapicinit>:
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
801027b0:	f3 0f 1e fb          	endbr32 
  if(!lapic)
801027b4:	a1 7c 36 11 80       	mov    0x8011367c,%eax
801027b9:	85 c0                	test   %eax,%eax
801027bb:	0f 84 c7 00 00 00    	je     80102888 <lapicinit+0xd8>
  lapic[index] = value;
801027c1:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801027c8:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027cb:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027ce:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801027d5:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027d8:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027db:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801027e2:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801027e5:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027e8:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801027ef:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801027f2:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027f5:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801027fc:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801027ff:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102802:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102809:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010280c:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010280f:	8b 50 30             	mov    0x30(%eax),%edx
80102812:	c1 ea 10             	shr    $0x10,%edx
80102815:	81 e2 fc 00 00 00    	and    $0xfc,%edx
8010281b:	75 73                	jne    80102890 <lapicinit+0xe0>
  lapic[index] = value;
8010281d:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102824:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102827:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010282a:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102831:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102834:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102837:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010283e:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102841:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102844:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
8010284b:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010284e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102851:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102858:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010285b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010285e:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102865:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102868:	8b 50 20             	mov    0x20(%eax),%edx
8010286b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010286f:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102870:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102876:	80 e6 10             	and    $0x10,%dh
80102879:	75 f5                	jne    80102870 <lapicinit+0xc0>
  lapic[index] = value;
8010287b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102882:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102885:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102888:	c3                   	ret    
80102889:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102890:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102897:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010289a:	8b 50 20             	mov    0x20(%eax),%edx
}
8010289d:	e9 7b ff ff ff       	jmp    8010281d <lapicinit+0x6d>
801028a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801028b0 <lapicid>:

int
lapicid(void)
{
801028b0:	f3 0f 1e fb          	endbr32 
  if (!lapic)
801028b4:	a1 7c 36 11 80       	mov    0x8011367c,%eax
801028b9:	85 c0                	test   %eax,%eax
801028bb:	74 0b                	je     801028c8 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
801028bd:	8b 40 20             	mov    0x20(%eax),%eax
801028c0:	c1 e8 18             	shr    $0x18,%eax
801028c3:	c3                   	ret    
801028c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
801028c8:	31 c0                	xor    %eax,%eax
}
801028ca:	c3                   	ret    
801028cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028cf:	90                   	nop

801028d0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
801028d0:	f3 0f 1e fb          	endbr32 
  if(lapic)
801028d4:	a1 7c 36 11 80       	mov    0x8011367c,%eax
801028d9:	85 c0                	test   %eax,%eax
801028db:	74 0d                	je     801028ea <lapiceoi+0x1a>
  lapic[index] = value;
801028dd:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801028e4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028e7:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
801028ea:	c3                   	ret    
801028eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028ef:	90                   	nop

801028f0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
801028f0:	f3 0f 1e fb          	endbr32 
}
801028f4:	c3                   	ret    
801028f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102900 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102900:	f3 0f 1e fb          	endbr32 
80102904:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102905:	b8 0f 00 00 00       	mov    $0xf,%eax
8010290a:	ba 70 00 00 00       	mov    $0x70,%edx
8010290f:	89 e5                	mov    %esp,%ebp
80102911:	53                   	push   %ebx
80102912:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102915:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102918:	ee                   	out    %al,(%dx)
80102919:	b8 0a 00 00 00       	mov    $0xa,%eax
8010291e:	ba 71 00 00 00       	mov    $0x71,%edx
80102923:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102924:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102926:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102929:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010292f:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102931:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102934:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102936:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102939:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
8010293c:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102942:	a1 7c 36 11 80       	mov    0x8011367c,%eax
80102947:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010294d:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102950:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102957:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010295a:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010295d:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102964:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102967:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010296a:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102970:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102973:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102979:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010297c:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102982:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102985:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
    microdelay(200);
  }
}
8010298b:	5b                   	pop    %ebx
  lapic[ID];  // wait for write to finish, by reading
8010298c:	8b 40 20             	mov    0x20(%eax),%eax
}
8010298f:	5d                   	pop    %ebp
80102990:	c3                   	ret    
80102991:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102998:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010299f:	90                   	nop

801029a0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
801029a0:	f3 0f 1e fb          	endbr32 
801029a4:	55                   	push   %ebp
801029a5:	b8 0b 00 00 00       	mov    $0xb,%eax
801029aa:	ba 70 00 00 00       	mov    $0x70,%edx
801029af:	89 e5                	mov    %esp,%ebp
801029b1:	57                   	push   %edi
801029b2:	56                   	push   %esi
801029b3:	53                   	push   %ebx
801029b4:	83 ec 4c             	sub    $0x4c,%esp
801029b7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029b8:	ba 71 00 00 00       	mov    $0x71,%edx
801029bd:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
801029be:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029c1:	bb 70 00 00 00       	mov    $0x70,%ebx
801029c6:	88 45 b3             	mov    %al,-0x4d(%ebp)
801029c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029d0:	31 c0                	xor    %eax,%eax
801029d2:	89 da                	mov    %ebx,%edx
801029d4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029d5:	b9 71 00 00 00       	mov    $0x71,%ecx
801029da:	89 ca                	mov    %ecx,%edx
801029dc:	ec                   	in     (%dx),%al
801029dd:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029e0:	89 da                	mov    %ebx,%edx
801029e2:	b8 02 00 00 00       	mov    $0x2,%eax
801029e7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029e8:	89 ca                	mov    %ecx,%edx
801029ea:	ec                   	in     (%dx),%al
801029eb:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029ee:	89 da                	mov    %ebx,%edx
801029f0:	b8 04 00 00 00       	mov    $0x4,%eax
801029f5:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029f6:	89 ca                	mov    %ecx,%edx
801029f8:	ec                   	in     (%dx),%al
801029f9:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029fc:	89 da                	mov    %ebx,%edx
801029fe:	b8 07 00 00 00       	mov    $0x7,%eax
80102a03:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a04:	89 ca                	mov    %ecx,%edx
80102a06:	ec                   	in     (%dx),%al
80102a07:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a0a:	89 da                	mov    %ebx,%edx
80102a0c:	b8 08 00 00 00       	mov    $0x8,%eax
80102a11:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a12:	89 ca                	mov    %ecx,%edx
80102a14:	ec                   	in     (%dx),%al
80102a15:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a17:	89 da                	mov    %ebx,%edx
80102a19:	b8 09 00 00 00       	mov    $0x9,%eax
80102a1e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a1f:	89 ca                	mov    %ecx,%edx
80102a21:	ec                   	in     (%dx),%al
80102a22:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a24:	89 da                	mov    %ebx,%edx
80102a26:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a2b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a2c:	89 ca                	mov    %ecx,%edx
80102a2e:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102a2f:	84 c0                	test   %al,%al
80102a31:	78 9d                	js     801029d0 <cmostime+0x30>
  return inb(CMOS_RETURN);
80102a33:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102a37:	89 fa                	mov    %edi,%edx
80102a39:	0f b6 fa             	movzbl %dl,%edi
80102a3c:	89 f2                	mov    %esi,%edx
80102a3e:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102a41:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102a45:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a48:	89 da                	mov    %ebx,%edx
80102a4a:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102a4d:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102a50:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102a54:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102a57:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102a5a:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102a5e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102a61:	31 c0                	xor    %eax,%eax
80102a63:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a64:	89 ca                	mov    %ecx,%edx
80102a66:	ec                   	in     (%dx),%al
80102a67:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a6a:	89 da                	mov    %ebx,%edx
80102a6c:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102a6f:	b8 02 00 00 00       	mov    $0x2,%eax
80102a74:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a75:	89 ca                	mov    %ecx,%edx
80102a77:	ec                   	in     (%dx),%al
80102a78:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a7b:	89 da                	mov    %ebx,%edx
80102a7d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102a80:	b8 04 00 00 00       	mov    $0x4,%eax
80102a85:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a86:	89 ca                	mov    %ecx,%edx
80102a88:	ec                   	in     (%dx),%al
80102a89:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a8c:	89 da                	mov    %ebx,%edx
80102a8e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102a91:	b8 07 00 00 00       	mov    $0x7,%eax
80102a96:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a97:	89 ca                	mov    %ecx,%edx
80102a99:	ec                   	in     (%dx),%al
80102a9a:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a9d:	89 da                	mov    %ebx,%edx
80102a9f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102aa2:	b8 08 00 00 00       	mov    $0x8,%eax
80102aa7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aa8:	89 ca                	mov    %ecx,%edx
80102aaa:	ec                   	in     (%dx),%al
80102aab:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aae:	89 da                	mov    %ebx,%edx
80102ab0:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102ab3:	b8 09 00 00 00       	mov    $0x9,%eax
80102ab8:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ab9:	89 ca                	mov    %ecx,%edx
80102abb:	ec                   	in     (%dx),%al
80102abc:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102abf:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102ac2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102ac5:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102ac8:	6a 18                	push   $0x18
80102aca:	50                   	push   %eax
80102acb:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102ace:	50                   	push   %eax
80102acf:	e8 1c 23 00 00       	call   80104df0 <memcmp>
80102ad4:	83 c4 10             	add    $0x10,%esp
80102ad7:	85 c0                	test   %eax,%eax
80102ad9:	0f 85 f1 fe ff ff    	jne    801029d0 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
80102adf:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102ae3:	75 78                	jne    80102b5d <cmostime+0x1bd>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102ae5:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102ae8:	89 c2                	mov    %eax,%edx
80102aea:	83 e0 0f             	and    $0xf,%eax
80102aed:	c1 ea 04             	shr    $0x4,%edx
80102af0:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102af3:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102af6:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102af9:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102afc:	89 c2                	mov    %eax,%edx
80102afe:	83 e0 0f             	and    $0xf,%eax
80102b01:	c1 ea 04             	shr    $0x4,%edx
80102b04:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b07:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b0a:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102b0d:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b10:	89 c2                	mov    %eax,%edx
80102b12:	83 e0 0f             	and    $0xf,%eax
80102b15:	c1 ea 04             	shr    $0x4,%edx
80102b18:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b1b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b1e:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102b21:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b24:	89 c2                	mov    %eax,%edx
80102b26:	83 e0 0f             	and    $0xf,%eax
80102b29:	c1 ea 04             	shr    $0x4,%edx
80102b2c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b2f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b32:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102b35:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b38:	89 c2                	mov    %eax,%edx
80102b3a:	83 e0 0f             	and    $0xf,%eax
80102b3d:	c1 ea 04             	shr    $0x4,%edx
80102b40:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b43:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b46:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102b49:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b4c:	89 c2                	mov    %eax,%edx
80102b4e:	83 e0 0f             	and    $0xf,%eax
80102b51:	c1 ea 04             	shr    $0x4,%edx
80102b54:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b57:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b5a:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102b5d:	8b 75 08             	mov    0x8(%ebp),%esi
80102b60:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b63:	89 06                	mov    %eax,(%esi)
80102b65:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b68:	89 46 04             	mov    %eax,0x4(%esi)
80102b6b:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b6e:	89 46 08             	mov    %eax,0x8(%esi)
80102b71:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b74:	89 46 0c             	mov    %eax,0xc(%esi)
80102b77:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b7a:	89 46 10             	mov    %eax,0x10(%esi)
80102b7d:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b80:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102b83:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102b8a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102b8d:	5b                   	pop    %ebx
80102b8e:	5e                   	pop    %esi
80102b8f:	5f                   	pop    %edi
80102b90:	5d                   	pop    %ebp
80102b91:	c3                   	ret    
80102b92:	66 90                	xchg   %ax,%ax
80102b94:	66 90                	xchg   %ax,%ax
80102b96:	66 90                	xchg   %ax,%ax
80102b98:	66 90                	xchg   %ax,%ax
80102b9a:	66 90                	xchg   %ax,%ax
80102b9c:	66 90                	xchg   %ax,%ax
80102b9e:	66 90                	xchg   %ax,%ax

80102ba0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102ba0:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
80102ba6:	85 c9                	test   %ecx,%ecx
80102ba8:	0f 8e 8a 00 00 00    	jle    80102c38 <install_trans+0x98>
{
80102bae:	55                   	push   %ebp
80102baf:	89 e5                	mov    %esp,%ebp
80102bb1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102bb2:	31 ff                	xor    %edi,%edi
{
80102bb4:	56                   	push   %esi
80102bb5:	53                   	push   %ebx
80102bb6:	83 ec 0c             	sub    $0xc,%esp
80102bb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102bc0:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80102bc5:	83 ec 08             	sub    $0x8,%esp
80102bc8:	01 f8                	add    %edi,%eax
80102bca:	83 c0 01             	add    $0x1,%eax
80102bcd:	50                   	push   %eax
80102bce:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102bd4:	e8 f7 d4 ff ff       	call   801000d0 <bread>
80102bd9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bdb:	58                   	pop    %eax
80102bdc:	5a                   	pop    %edx
80102bdd:	ff 34 bd cc 36 11 80 	pushl  -0x7feec934(,%edi,4)
80102be4:	ff 35 c4 36 11 80    	pushl  0x801136c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102bea:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bed:	e8 de d4 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102bf2:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bf5:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102bf7:	8d 46 5c             	lea    0x5c(%esi),%eax
80102bfa:	68 00 02 00 00       	push   $0x200
80102bff:	50                   	push   %eax
80102c00:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102c03:	50                   	push   %eax
80102c04:	e8 37 22 00 00       	call   80104e40 <memmove>
    bwrite(dbuf);  // write dst to disk
80102c09:	89 1c 24             	mov    %ebx,(%esp)
80102c0c:	e8 9f d5 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102c11:	89 34 24             	mov    %esi,(%esp)
80102c14:	e8 d7 d5 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102c19:	89 1c 24             	mov    %ebx,(%esp)
80102c1c:	e8 cf d5 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c21:	83 c4 10             	add    $0x10,%esp
80102c24:	39 3d c8 36 11 80    	cmp    %edi,0x801136c8
80102c2a:	7f 94                	jg     80102bc0 <install_trans+0x20>
  }
}
80102c2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c2f:	5b                   	pop    %ebx
80102c30:	5e                   	pop    %esi
80102c31:	5f                   	pop    %edi
80102c32:	5d                   	pop    %ebp
80102c33:	c3                   	ret    
80102c34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c38:	c3                   	ret    
80102c39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102c40 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102c40:	55                   	push   %ebp
80102c41:	89 e5                	mov    %esp,%ebp
80102c43:	53                   	push   %ebx
80102c44:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c47:	ff 35 b4 36 11 80    	pushl  0x801136b4
80102c4d:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102c53:	e8 78 d4 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102c58:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c5b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102c5d:	a1 c8 36 11 80       	mov    0x801136c8,%eax
80102c62:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102c65:	85 c0                	test   %eax,%eax
80102c67:	7e 19                	jle    80102c82 <write_head+0x42>
80102c69:	31 d2                	xor    %edx,%edx
80102c6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c6f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102c70:	8b 0c 95 cc 36 11 80 	mov    -0x7feec934(,%edx,4),%ecx
80102c77:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102c7b:	83 c2 01             	add    $0x1,%edx
80102c7e:	39 d0                	cmp    %edx,%eax
80102c80:	75 ee                	jne    80102c70 <write_head+0x30>
  }
  bwrite(buf);
80102c82:	83 ec 0c             	sub    $0xc,%esp
80102c85:	53                   	push   %ebx
80102c86:	e8 25 d5 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102c8b:	89 1c 24             	mov    %ebx,(%esp)
80102c8e:	e8 5d d5 ff ff       	call   801001f0 <brelse>
}
80102c93:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c96:	83 c4 10             	add    $0x10,%esp
80102c99:	c9                   	leave  
80102c9a:	c3                   	ret    
80102c9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c9f:	90                   	nop

80102ca0 <initlog>:
{
80102ca0:	f3 0f 1e fb          	endbr32 
80102ca4:	55                   	push   %ebp
80102ca5:	89 e5                	mov    %esp,%ebp
80102ca7:	53                   	push   %ebx
80102ca8:	83 ec 2c             	sub    $0x2c,%esp
80102cab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102cae:	68 a0 7d 10 80       	push   $0x80107da0
80102cb3:	68 80 36 11 80       	push   $0x80113680
80102cb8:	e8 53 1e 00 00       	call   80104b10 <initlock>
  readsb(dev, &sb);
80102cbd:	58                   	pop    %eax
80102cbe:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102cc1:	5a                   	pop    %edx
80102cc2:	50                   	push   %eax
80102cc3:	53                   	push   %ebx
80102cc4:	e8 47 e8 ff ff       	call   80101510 <readsb>
  log.start = sb.logstart;
80102cc9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102ccc:	59                   	pop    %ecx
  log.dev = dev;
80102ccd:	89 1d c4 36 11 80    	mov    %ebx,0x801136c4
  log.size = sb.nlog;
80102cd3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102cd6:	a3 b4 36 11 80       	mov    %eax,0x801136b4
  log.size = sb.nlog;
80102cdb:	89 15 b8 36 11 80    	mov    %edx,0x801136b8
  struct buf *buf = bread(log.dev, log.start);
80102ce1:	5a                   	pop    %edx
80102ce2:	50                   	push   %eax
80102ce3:	53                   	push   %ebx
80102ce4:	e8 e7 d3 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102ce9:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102cec:	8b 48 5c             	mov    0x5c(%eax),%ecx
80102cef:	89 0d c8 36 11 80    	mov    %ecx,0x801136c8
  for (i = 0; i < log.lh.n; i++) {
80102cf5:	85 c9                	test   %ecx,%ecx
80102cf7:	7e 19                	jle    80102d12 <initlog+0x72>
80102cf9:	31 d2                	xor    %edx,%edx
80102cfb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102cff:	90                   	nop
    log.lh.block[i] = lh->block[i];
80102d00:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
80102d04:	89 1c 95 cc 36 11 80 	mov    %ebx,-0x7feec934(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102d0b:	83 c2 01             	add    $0x1,%edx
80102d0e:	39 d1                	cmp    %edx,%ecx
80102d10:	75 ee                	jne    80102d00 <initlog+0x60>
  brelse(buf);
80102d12:	83 ec 0c             	sub    $0xc,%esp
80102d15:	50                   	push   %eax
80102d16:	e8 d5 d4 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102d1b:	e8 80 fe ff ff       	call   80102ba0 <install_trans>
  log.lh.n = 0;
80102d20:	c7 05 c8 36 11 80 00 	movl   $0x0,0x801136c8
80102d27:	00 00 00 
  write_head(); // clear the log
80102d2a:	e8 11 ff ff ff       	call   80102c40 <write_head>
}
80102d2f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d32:	83 c4 10             	add    $0x10,%esp
80102d35:	c9                   	leave  
80102d36:	c3                   	ret    
80102d37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d3e:	66 90                	xchg   %ax,%ax

80102d40 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102d40:	f3 0f 1e fb          	endbr32 
80102d44:	55                   	push   %ebp
80102d45:	89 e5                	mov    %esp,%ebp
80102d47:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102d4a:	68 80 36 11 80       	push   $0x80113680
80102d4f:	e8 3c 1f 00 00       	call   80104c90 <acquire>
80102d54:	83 c4 10             	add    $0x10,%esp
80102d57:	eb 1c                	jmp    80102d75 <begin_op+0x35>
80102d59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102d60:	83 ec 08             	sub    $0x8,%esp
80102d63:	68 80 36 11 80       	push   $0x80113680
80102d68:	68 80 36 11 80       	push   $0x80113680
80102d6d:	e8 5e 14 00 00       	call   801041d0 <sleep>
80102d72:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102d75:	a1 c0 36 11 80       	mov    0x801136c0,%eax
80102d7a:	85 c0                	test   %eax,%eax
80102d7c:	75 e2                	jne    80102d60 <begin_op+0x20>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102d7e:	a1 bc 36 11 80       	mov    0x801136bc,%eax
80102d83:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
80102d89:	83 c0 01             	add    $0x1,%eax
80102d8c:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102d8f:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102d92:	83 fa 1e             	cmp    $0x1e,%edx
80102d95:	7f c9                	jg     80102d60 <begin_op+0x20>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102d97:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102d9a:	a3 bc 36 11 80       	mov    %eax,0x801136bc
      release(&log.lock);
80102d9f:	68 80 36 11 80       	push   $0x80113680
80102da4:	e8 a7 1f 00 00       	call   80104d50 <release>
      break;
    }
  }
}
80102da9:	83 c4 10             	add    $0x10,%esp
80102dac:	c9                   	leave  
80102dad:	c3                   	ret    
80102dae:	66 90                	xchg   %ax,%ax

80102db0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102db0:	f3 0f 1e fb          	endbr32 
80102db4:	55                   	push   %ebp
80102db5:	89 e5                	mov    %esp,%ebp
80102db7:	57                   	push   %edi
80102db8:	56                   	push   %esi
80102db9:	53                   	push   %ebx
80102dba:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102dbd:	68 80 36 11 80       	push   $0x80113680
80102dc2:	e8 c9 1e 00 00       	call   80104c90 <acquire>
  log.outstanding -= 1;
80102dc7:	a1 bc 36 11 80       	mov    0x801136bc,%eax
  if(log.committing)
80102dcc:	8b 35 c0 36 11 80    	mov    0x801136c0,%esi
80102dd2:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102dd5:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102dd8:	89 1d bc 36 11 80    	mov    %ebx,0x801136bc
  if(log.committing)
80102dde:	85 f6                	test   %esi,%esi
80102de0:	0f 85 1e 01 00 00    	jne    80102f04 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102de6:	85 db                	test   %ebx,%ebx
80102de8:	0f 85 f2 00 00 00    	jne    80102ee0 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102dee:	c7 05 c0 36 11 80 01 	movl   $0x1,0x801136c0
80102df5:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102df8:	83 ec 0c             	sub    $0xc,%esp
80102dfb:	68 80 36 11 80       	push   $0x80113680
80102e00:	e8 4b 1f 00 00       	call   80104d50 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102e05:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
80102e0b:	83 c4 10             	add    $0x10,%esp
80102e0e:	85 c9                	test   %ecx,%ecx
80102e10:	7f 3e                	jg     80102e50 <end_op+0xa0>
    acquire(&log.lock);
80102e12:	83 ec 0c             	sub    $0xc,%esp
80102e15:	68 80 36 11 80       	push   $0x80113680
80102e1a:	e8 71 1e 00 00       	call   80104c90 <acquire>
    wakeup(&log);
80102e1f:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
    log.committing = 0;
80102e26:	c7 05 c0 36 11 80 00 	movl   $0x0,0x801136c0
80102e2d:	00 00 00 
    wakeup(&log);
80102e30:	e8 8b 16 00 00       	call   801044c0 <wakeup>
    release(&log.lock);
80102e35:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80102e3c:	e8 0f 1f 00 00       	call   80104d50 <release>
80102e41:	83 c4 10             	add    $0x10,%esp
}
80102e44:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e47:	5b                   	pop    %ebx
80102e48:	5e                   	pop    %esi
80102e49:	5f                   	pop    %edi
80102e4a:	5d                   	pop    %ebp
80102e4b:	c3                   	ret    
80102e4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102e50:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80102e55:	83 ec 08             	sub    $0x8,%esp
80102e58:	01 d8                	add    %ebx,%eax
80102e5a:	83 c0 01             	add    $0x1,%eax
80102e5d:	50                   	push   %eax
80102e5e:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102e64:	e8 67 d2 ff ff       	call   801000d0 <bread>
80102e69:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e6b:	58                   	pop    %eax
80102e6c:	5a                   	pop    %edx
80102e6d:	ff 34 9d cc 36 11 80 	pushl  -0x7feec934(,%ebx,4)
80102e74:	ff 35 c4 36 11 80    	pushl  0x801136c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102e7a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e7d:	e8 4e d2 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102e82:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e85:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102e87:	8d 40 5c             	lea    0x5c(%eax),%eax
80102e8a:	68 00 02 00 00       	push   $0x200
80102e8f:	50                   	push   %eax
80102e90:	8d 46 5c             	lea    0x5c(%esi),%eax
80102e93:	50                   	push   %eax
80102e94:	e8 a7 1f 00 00       	call   80104e40 <memmove>
    bwrite(to);  // write the log
80102e99:	89 34 24             	mov    %esi,(%esp)
80102e9c:	e8 0f d3 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102ea1:	89 3c 24             	mov    %edi,(%esp)
80102ea4:	e8 47 d3 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102ea9:	89 34 24             	mov    %esi,(%esp)
80102eac:	e8 3f d3 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102eb1:	83 c4 10             	add    $0x10,%esp
80102eb4:	3b 1d c8 36 11 80    	cmp    0x801136c8,%ebx
80102eba:	7c 94                	jl     80102e50 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102ebc:	e8 7f fd ff ff       	call   80102c40 <write_head>
    install_trans(); // Now install writes to home locations
80102ec1:	e8 da fc ff ff       	call   80102ba0 <install_trans>
    log.lh.n = 0;
80102ec6:	c7 05 c8 36 11 80 00 	movl   $0x0,0x801136c8
80102ecd:	00 00 00 
    write_head();    // Erase the transaction from the log
80102ed0:	e8 6b fd ff ff       	call   80102c40 <write_head>
80102ed5:	e9 38 ff ff ff       	jmp    80102e12 <end_op+0x62>
80102eda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102ee0:	83 ec 0c             	sub    $0xc,%esp
80102ee3:	68 80 36 11 80       	push   $0x80113680
80102ee8:	e8 d3 15 00 00       	call   801044c0 <wakeup>
  release(&log.lock);
80102eed:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80102ef4:	e8 57 1e 00 00       	call   80104d50 <release>
80102ef9:	83 c4 10             	add    $0x10,%esp
}
80102efc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102eff:	5b                   	pop    %ebx
80102f00:	5e                   	pop    %esi
80102f01:	5f                   	pop    %edi
80102f02:	5d                   	pop    %ebp
80102f03:	c3                   	ret    
    panic("log.committing");
80102f04:	83 ec 0c             	sub    $0xc,%esp
80102f07:	68 a4 7d 10 80       	push   $0x80107da4
80102f0c:	e8 7f d4 ff ff       	call   80100390 <panic>
80102f11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f1f:	90                   	nop

80102f20 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102f20:	f3 0f 1e fb          	endbr32 
80102f24:	55                   	push   %ebp
80102f25:	89 e5                	mov    %esp,%ebp
80102f27:	53                   	push   %ebx
80102f28:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f2b:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
{
80102f31:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f34:	83 fa 1d             	cmp    $0x1d,%edx
80102f37:	0f 8f 91 00 00 00    	jg     80102fce <log_write+0xae>
80102f3d:	a1 b8 36 11 80       	mov    0x801136b8,%eax
80102f42:	83 e8 01             	sub    $0x1,%eax
80102f45:	39 c2                	cmp    %eax,%edx
80102f47:	0f 8d 81 00 00 00    	jge    80102fce <log_write+0xae>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102f4d:	a1 bc 36 11 80       	mov    0x801136bc,%eax
80102f52:	85 c0                	test   %eax,%eax
80102f54:	0f 8e 81 00 00 00    	jle    80102fdb <log_write+0xbb>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102f5a:	83 ec 0c             	sub    $0xc,%esp
80102f5d:	68 80 36 11 80       	push   $0x80113680
80102f62:	e8 29 1d 00 00       	call   80104c90 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102f67:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
80102f6d:	83 c4 10             	add    $0x10,%esp
80102f70:	85 d2                	test   %edx,%edx
80102f72:	7e 4e                	jle    80102fc2 <log_write+0xa2>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f74:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102f77:	31 c0                	xor    %eax,%eax
80102f79:	eb 0c                	jmp    80102f87 <log_write+0x67>
80102f7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102f7f:	90                   	nop
80102f80:	83 c0 01             	add    $0x1,%eax
80102f83:	39 c2                	cmp    %eax,%edx
80102f85:	74 29                	je     80102fb0 <log_write+0x90>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f87:	39 0c 85 cc 36 11 80 	cmp    %ecx,-0x7feec934(,%eax,4)
80102f8e:	75 f0                	jne    80102f80 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102f90:	89 0c 85 cc 36 11 80 	mov    %ecx,-0x7feec934(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102f97:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80102f9a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80102f9d:	c7 45 08 80 36 11 80 	movl   $0x80113680,0x8(%ebp)
}
80102fa4:	c9                   	leave  
  release(&log.lock);
80102fa5:	e9 a6 1d 00 00       	jmp    80104d50 <release>
80102faa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102fb0:	89 0c 95 cc 36 11 80 	mov    %ecx,-0x7feec934(,%edx,4)
    log.lh.n++;
80102fb7:	83 c2 01             	add    $0x1,%edx
80102fba:	89 15 c8 36 11 80    	mov    %edx,0x801136c8
80102fc0:	eb d5                	jmp    80102f97 <log_write+0x77>
  log.lh.block[i] = b->blockno;
80102fc2:	8b 43 08             	mov    0x8(%ebx),%eax
80102fc5:	a3 cc 36 11 80       	mov    %eax,0x801136cc
  if (i == log.lh.n)
80102fca:	75 cb                	jne    80102f97 <log_write+0x77>
80102fcc:	eb e9                	jmp    80102fb7 <log_write+0x97>
    panic("too big a transaction");
80102fce:	83 ec 0c             	sub    $0xc,%esp
80102fd1:	68 b3 7d 10 80       	push   $0x80107db3
80102fd6:	e8 b5 d3 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80102fdb:	83 ec 0c             	sub    $0xc,%esp
80102fde:	68 c9 7d 10 80       	push   $0x80107dc9
80102fe3:	e8 a8 d3 ff ff       	call   80100390 <panic>
80102fe8:	66 90                	xchg   %ax,%ax
80102fea:	66 90                	xchg   %ax,%ax
80102fec:	66 90                	xchg   %ax,%ax
80102fee:	66 90                	xchg   %ax,%ax

80102ff0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102ff0:	55                   	push   %ebp
80102ff1:	89 e5                	mov    %esp,%ebp
80102ff3:	53                   	push   %ebx
80102ff4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102ff7:	e8 e4 09 00 00       	call   801039e0 <cpuid>
80102ffc:	89 c3                	mov    %eax,%ebx
80102ffe:	e8 dd 09 00 00       	call   801039e0 <cpuid>
80103003:	83 ec 04             	sub    $0x4,%esp
80103006:	53                   	push   %ebx
80103007:	50                   	push   %eax
80103008:	68 e4 7d 10 80       	push   $0x80107de4
8010300d:	e8 9e d6 ff ff       	call   801006b0 <cprintf>
  idtinit();       // load idt register
80103012:	e8 19 31 00 00       	call   80106130 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103017:	e8 54 09 00 00       	call   80103970 <mycpu>
8010301c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010301e:	b8 01 00 00 00       	mov    $0x1,%eax
80103023:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010302a:	e8 41 0d 00 00       	call   80103d70 <scheduler>
8010302f:	90                   	nop

80103030 <mpenter>:
{
80103030:	f3 0f 1e fb          	endbr32 
80103034:	55                   	push   %ebp
80103035:	89 e5                	mov    %esp,%ebp
80103037:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
8010303a:	e8 d1 41 00 00       	call   80107210 <switchkvm>
  seginit();
8010303f:	e8 3c 41 00 00       	call   80107180 <seginit>
  lapicinit();
80103044:	e8 67 f7 ff ff       	call   801027b0 <lapicinit>
  mpmain();
80103049:	e8 a2 ff ff ff       	call   80102ff0 <mpmain>
8010304e:	66 90                	xchg   %ax,%ax

80103050 <main>:
{
80103050:	f3 0f 1e fb          	endbr32 
80103054:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103058:	83 e4 f0             	and    $0xfffffff0,%esp
8010305b:	ff 71 fc             	pushl  -0x4(%ecx)
8010305e:	55                   	push   %ebp
8010305f:	89 e5                	mov    %esp,%ebp
80103061:	53                   	push   %ebx
80103062:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103063:	83 ec 08             	sub    $0x8,%esp
80103066:	68 00 00 40 80       	push   $0x80400000
8010306b:	68 a8 72 11 80       	push   $0x801172a8
80103070:	e8 fb f4 ff ff       	call   80102570 <kinit1>
  kvmalloc();      // kernel page table
80103075:	e8 76 46 00 00       	call   801076f0 <kvmalloc>
  mpinit();        // detect other processors
8010307a:	e8 81 01 00 00       	call   80103200 <mpinit>
  lapicinit();     // interrupt controller
8010307f:	e8 2c f7 ff ff       	call   801027b0 <lapicinit>
  seginit();       // segment descriptors
80103084:	e8 f7 40 00 00       	call   80107180 <seginit>
  picinit();       // disable pic
80103089:	e8 52 03 00 00       	call   801033e0 <picinit>
  ioapicinit();    // another interrupt controller
8010308e:	e8 fd f2 ff ff       	call   80102390 <ioapicinit>
  consoleinit();   // console hardware
80103093:	e8 98 d9 ff ff       	call   80100a30 <consoleinit>
  uartinit();      // serial port
80103098:	e8 a3 33 00 00       	call   80106440 <uartinit>
  pinit();         // process table
8010309d:	e8 ae 08 00 00       	call   80103950 <pinit>
  tvinit();        // trap vectors
801030a2:	e8 09 30 00 00       	call   801060b0 <tvinit>
  binit();         // buffer cache
801030a7:	e8 94 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
801030ac:	e8 3f dd ff ff       	call   80100df0 <fileinit>
  ideinit();       // disk 
801030b1:	e8 aa f0 ff ff       	call   80102160 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801030b6:	83 c4 0c             	add    $0xc,%esp
801030b9:	68 8a 00 00 00       	push   $0x8a
801030be:	68 8c b4 10 80       	push   $0x8010b48c
801030c3:	68 00 70 00 80       	push   $0x80007000
801030c8:	e8 73 1d 00 00       	call   80104e40 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801030cd:	83 c4 10             	add    $0x10,%esp
801030d0:	69 05 00 3d 11 80 b0 	imul   $0xb0,0x80113d00,%eax
801030d7:	00 00 00 
801030da:	05 80 37 11 80       	add    $0x80113780,%eax
801030df:	3d 80 37 11 80       	cmp    $0x80113780,%eax
801030e4:	76 7a                	jbe    80103160 <main+0x110>
801030e6:	bb 80 37 11 80       	mov    $0x80113780,%ebx
801030eb:	eb 1c                	jmp    80103109 <main+0xb9>
801030ed:	8d 76 00             	lea    0x0(%esi),%esi
801030f0:	69 05 00 3d 11 80 b0 	imul   $0xb0,0x80113d00,%eax
801030f7:	00 00 00 
801030fa:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103100:	05 80 37 11 80       	add    $0x80113780,%eax
80103105:	39 c3                	cmp    %eax,%ebx
80103107:	73 57                	jae    80103160 <main+0x110>
    if(c == mycpu())  // We've started already.
80103109:	e8 62 08 00 00       	call   80103970 <mycpu>
8010310e:	39 c3                	cmp    %eax,%ebx
80103110:	74 de                	je     801030f0 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103112:	e8 29 f5 ff ff       	call   80102640 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103117:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010311a:	c7 05 f8 6f 00 80 30 	movl   $0x80103030,0x80006ff8
80103121:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103124:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
8010312b:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010312e:	05 00 10 00 00       	add    $0x1000,%eax
80103133:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103138:	0f b6 03             	movzbl (%ebx),%eax
8010313b:	68 00 70 00 00       	push   $0x7000
80103140:	50                   	push   %eax
80103141:	e8 ba f7 ff ff       	call   80102900 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103146:	83 c4 10             	add    $0x10,%esp
80103149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103150:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103156:	85 c0                	test   %eax,%eax
80103158:	74 f6                	je     80103150 <main+0x100>
8010315a:	eb 94                	jmp    801030f0 <main+0xa0>
8010315c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103160:	83 ec 08             	sub    $0x8,%esp
80103163:	68 00 00 00 8e       	push   $0x8e000000
80103168:	68 00 00 40 80       	push   $0x80400000
8010316d:	e8 6e f4 ff ff       	call   801025e0 <kinit2>
  userinit();      // first user process
80103172:	e8 b9 08 00 00       	call   80103a30 <userinit>
  mpmain();        // finish this processor's setup
80103177:	e8 74 fe ff ff       	call   80102ff0 <mpmain>
8010317c:	66 90                	xchg   %ax,%ax
8010317e:	66 90                	xchg   %ax,%ax

80103180 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103180:	55                   	push   %ebp
80103181:	89 e5                	mov    %esp,%ebp
80103183:	57                   	push   %edi
80103184:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103185:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010318b:	53                   	push   %ebx
  e = addr+len;
8010318c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010318f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103192:	39 de                	cmp    %ebx,%esi
80103194:	72 10                	jb     801031a6 <mpsearch1+0x26>
80103196:	eb 50                	jmp    801031e8 <mpsearch1+0x68>
80103198:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010319f:	90                   	nop
801031a0:	89 fe                	mov    %edi,%esi
801031a2:	39 fb                	cmp    %edi,%ebx
801031a4:	76 42                	jbe    801031e8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031a6:	83 ec 04             	sub    $0x4,%esp
801031a9:	8d 7e 10             	lea    0x10(%esi),%edi
801031ac:	6a 04                	push   $0x4
801031ae:	68 f8 7d 10 80       	push   $0x80107df8
801031b3:	56                   	push   %esi
801031b4:	e8 37 1c 00 00       	call   80104df0 <memcmp>
801031b9:	83 c4 10             	add    $0x10,%esp
801031bc:	85 c0                	test   %eax,%eax
801031be:	75 e0                	jne    801031a0 <mpsearch1+0x20>
801031c0:	89 f2                	mov    %esi,%edx
801031c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801031c8:	0f b6 0a             	movzbl (%edx),%ecx
801031cb:	83 c2 01             	add    $0x1,%edx
801031ce:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801031d0:	39 fa                	cmp    %edi,%edx
801031d2:	75 f4                	jne    801031c8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031d4:	84 c0                	test   %al,%al
801031d6:	75 c8                	jne    801031a0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801031d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031db:	89 f0                	mov    %esi,%eax
801031dd:	5b                   	pop    %ebx
801031de:	5e                   	pop    %esi
801031df:	5f                   	pop    %edi
801031e0:	5d                   	pop    %ebp
801031e1:	c3                   	ret    
801031e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801031e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801031eb:	31 f6                	xor    %esi,%esi
}
801031ed:	5b                   	pop    %ebx
801031ee:	89 f0                	mov    %esi,%eax
801031f0:	5e                   	pop    %esi
801031f1:	5f                   	pop    %edi
801031f2:	5d                   	pop    %ebp
801031f3:	c3                   	ret    
801031f4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801031ff:	90                   	nop

80103200 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103200:	f3 0f 1e fb          	endbr32 
80103204:	55                   	push   %ebp
80103205:	89 e5                	mov    %esp,%ebp
80103207:	57                   	push   %edi
80103208:	56                   	push   %esi
80103209:	53                   	push   %ebx
8010320a:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
8010320d:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103214:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
8010321b:	c1 e0 08             	shl    $0x8,%eax
8010321e:	09 d0                	or     %edx,%eax
80103220:	c1 e0 04             	shl    $0x4,%eax
80103223:	75 1b                	jne    80103240 <mpinit+0x40>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103225:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010322c:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103233:	c1 e0 08             	shl    $0x8,%eax
80103236:	09 d0                	or     %edx,%eax
80103238:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
8010323b:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
80103240:	ba 00 04 00 00       	mov    $0x400,%edx
80103245:	e8 36 ff ff ff       	call   80103180 <mpsearch1>
8010324a:	89 c6                	mov    %eax,%esi
8010324c:	85 c0                	test   %eax,%eax
8010324e:	0f 84 4c 01 00 00    	je     801033a0 <mpinit+0x1a0>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103254:	8b 5e 04             	mov    0x4(%esi),%ebx
80103257:	85 db                	test   %ebx,%ebx
80103259:	0f 84 61 01 00 00    	je     801033c0 <mpinit+0x1c0>
  if(memcmp(conf, "PCMP", 4) != 0)
8010325f:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103262:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103268:	6a 04                	push   $0x4
8010326a:	68 fd 7d 10 80       	push   $0x80107dfd
8010326f:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103270:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103273:	e8 78 1b 00 00       	call   80104df0 <memcmp>
80103278:	83 c4 10             	add    $0x10,%esp
8010327b:	85 c0                	test   %eax,%eax
8010327d:	0f 85 3d 01 00 00    	jne    801033c0 <mpinit+0x1c0>
  if(conf->version != 1 && conf->version != 4)
80103283:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
8010328a:	3c 01                	cmp    $0x1,%al
8010328c:	74 08                	je     80103296 <mpinit+0x96>
8010328e:	3c 04                	cmp    $0x4,%al
80103290:	0f 85 2a 01 00 00    	jne    801033c0 <mpinit+0x1c0>
  if(sum((uchar*)conf, conf->length) != 0)
80103296:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  for(i=0; i<len; i++)
8010329d:	66 85 d2             	test   %dx,%dx
801032a0:	74 26                	je     801032c8 <mpinit+0xc8>
801032a2:	8d 3c 1a             	lea    (%edx,%ebx,1),%edi
801032a5:	89 d8                	mov    %ebx,%eax
  sum = 0;
801032a7:	31 d2                	xor    %edx,%edx
801032a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
801032b0:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
801032b7:	83 c0 01             	add    $0x1,%eax
801032ba:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801032bc:	39 f8                	cmp    %edi,%eax
801032be:	75 f0                	jne    801032b0 <mpinit+0xb0>
  if(sum((uchar*)conf, conf->length) != 0)
801032c0:	84 d2                	test   %dl,%dl
801032c2:	0f 85 f8 00 00 00    	jne    801033c0 <mpinit+0x1c0>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801032c8:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
801032ce:	a3 7c 36 11 80       	mov    %eax,0x8011367c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032d3:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
801032d9:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  ismp = 1;
801032e0:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032e5:	03 55 e4             	add    -0x1c(%ebp),%edx
801032e8:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801032eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801032ef:	90                   	nop
801032f0:	39 c2                	cmp    %eax,%edx
801032f2:	76 15                	jbe    80103309 <mpinit+0x109>
    switch(*p){
801032f4:	0f b6 08             	movzbl (%eax),%ecx
801032f7:	80 f9 02             	cmp    $0x2,%cl
801032fa:	74 5c                	je     80103358 <mpinit+0x158>
801032fc:	77 42                	ja     80103340 <mpinit+0x140>
801032fe:	84 c9                	test   %cl,%cl
80103300:	74 6e                	je     80103370 <mpinit+0x170>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103302:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103305:	39 c2                	cmp    %eax,%edx
80103307:	77 eb                	ja     801032f4 <mpinit+0xf4>
80103309:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
8010330c:	85 db                	test   %ebx,%ebx
8010330e:	0f 84 b9 00 00 00    	je     801033cd <mpinit+0x1cd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103314:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
80103318:	74 15                	je     8010332f <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010331a:	b8 70 00 00 00       	mov    $0x70,%eax
8010331f:	ba 22 00 00 00       	mov    $0x22,%edx
80103324:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103325:	ba 23 00 00 00       	mov    $0x23,%edx
8010332a:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
8010332b:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010332e:	ee                   	out    %al,(%dx)
  }
}
8010332f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103332:	5b                   	pop    %ebx
80103333:	5e                   	pop    %esi
80103334:	5f                   	pop    %edi
80103335:	5d                   	pop    %ebp
80103336:	c3                   	ret    
80103337:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010333e:	66 90                	xchg   %ax,%ax
    switch(*p){
80103340:	83 e9 03             	sub    $0x3,%ecx
80103343:	80 f9 01             	cmp    $0x1,%cl
80103346:	76 ba                	jbe    80103302 <mpinit+0x102>
80103348:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010334f:	eb 9f                	jmp    801032f0 <mpinit+0xf0>
80103351:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103358:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
8010335c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010335f:	88 0d 60 37 11 80    	mov    %cl,0x80113760
      continue;
80103365:	eb 89                	jmp    801032f0 <mpinit+0xf0>
80103367:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010336e:	66 90                	xchg   %ax,%ax
      if(ncpu < NCPU) {
80103370:	8b 0d 00 3d 11 80    	mov    0x80113d00,%ecx
80103376:	83 f9 07             	cmp    $0x7,%ecx
80103379:	7f 19                	jg     80103394 <mpinit+0x194>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010337b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103381:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103385:	83 c1 01             	add    $0x1,%ecx
80103388:	89 0d 00 3d 11 80    	mov    %ecx,0x80113d00
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010338e:	88 9f 80 37 11 80    	mov    %bl,-0x7feec880(%edi)
      p += sizeof(struct mpproc);
80103394:	83 c0 14             	add    $0x14,%eax
      continue;
80103397:	e9 54 ff ff ff       	jmp    801032f0 <mpinit+0xf0>
8010339c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return mpsearch1(0xF0000, 0x10000);
801033a0:	ba 00 00 01 00       	mov    $0x10000,%edx
801033a5:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801033aa:	e8 d1 fd ff ff       	call   80103180 <mpsearch1>
801033af:	89 c6                	mov    %eax,%esi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801033b1:	85 c0                	test   %eax,%eax
801033b3:	0f 85 9b fe ff ff    	jne    80103254 <mpinit+0x54>
801033b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
801033c0:	83 ec 0c             	sub    $0xc,%esp
801033c3:	68 02 7e 10 80       	push   $0x80107e02
801033c8:	e8 c3 cf ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
801033cd:	83 ec 0c             	sub    $0xc,%esp
801033d0:	68 1c 7e 10 80       	push   $0x80107e1c
801033d5:	e8 b6 cf ff ff       	call   80100390 <panic>
801033da:	66 90                	xchg   %ax,%ax
801033dc:	66 90                	xchg   %ax,%ax
801033de:	66 90                	xchg   %ax,%ax

801033e0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
801033e0:	f3 0f 1e fb          	endbr32 
801033e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801033e9:	ba 21 00 00 00       	mov    $0x21,%edx
801033ee:	ee                   	out    %al,(%dx)
801033ef:	ba a1 00 00 00       	mov    $0xa1,%edx
801033f4:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801033f5:	c3                   	ret    
801033f6:	66 90                	xchg   %ax,%ax
801033f8:	66 90                	xchg   %ax,%ax
801033fa:	66 90                	xchg   %ax,%ax
801033fc:	66 90                	xchg   %ax,%ax
801033fe:	66 90                	xchg   %ax,%ax

80103400 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103400:	f3 0f 1e fb          	endbr32 
80103404:	55                   	push   %ebp
80103405:	89 e5                	mov    %esp,%ebp
80103407:	57                   	push   %edi
80103408:	56                   	push   %esi
80103409:	53                   	push   %ebx
8010340a:	83 ec 0c             	sub    $0xc,%esp
8010340d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103410:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80103413:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103419:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010341f:	e8 ec d9 ff ff       	call   80100e10 <filealloc>
80103424:	89 03                	mov    %eax,(%ebx)
80103426:	85 c0                	test   %eax,%eax
80103428:	0f 84 ac 00 00 00    	je     801034da <pipealloc+0xda>
8010342e:	e8 dd d9 ff ff       	call   80100e10 <filealloc>
80103433:	89 06                	mov    %eax,(%esi)
80103435:	85 c0                	test   %eax,%eax
80103437:	0f 84 8b 00 00 00    	je     801034c8 <pipealloc+0xc8>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
8010343d:	e8 fe f1 ff ff       	call   80102640 <kalloc>
80103442:	89 c7                	mov    %eax,%edi
80103444:	85 c0                	test   %eax,%eax
80103446:	0f 84 b4 00 00 00    	je     80103500 <pipealloc+0x100>
    goto bad;
  p->readopen = 1;
8010344c:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103453:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103456:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103459:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103460:	00 00 00 
  p->nwrite = 0;
80103463:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010346a:	00 00 00 
  p->nread = 0;
8010346d:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103474:	00 00 00 
  initlock(&p->lock, "pipe");
80103477:	68 3b 7e 10 80       	push   $0x80107e3b
8010347c:	50                   	push   %eax
8010347d:	e8 8e 16 00 00       	call   80104b10 <initlock>
  (*f0)->type = FD_PIPE;
80103482:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103484:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103487:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
8010348d:	8b 03                	mov    (%ebx),%eax
8010348f:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103493:	8b 03                	mov    (%ebx),%eax
80103495:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103499:	8b 03                	mov    (%ebx),%eax
8010349b:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010349e:	8b 06                	mov    (%esi),%eax
801034a0:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801034a6:	8b 06                	mov    (%esi),%eax
801034a8:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801034ac:	8b 06                	mov    (%esi),%eax
801034ae:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801034b2:	8b 06                	mov    (%esi),%eax
801034b4:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801034b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801034ba:	31 c0                	xor    %eax,%eax
}
801034bc:	5b                   	pop    %ebx
801034bd:	5e                   	pop    %esi
801034be:	5f                   	pop    %edi
801034bf:	5d                   	pop    %ebp
801034c0:	c3                   	ret    
801034c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
801034c8:	8b 03                	mov    (%ebx),%eax
801034ca:	85 c0                	test   %eax,%eax
801034cc:	74 1e                	je     801034ec <pipealloc+0xec>
    fileclose(*f0);
801034ce:	83 ec 0c             	sub    $0xc,%esp
801034d1:	50                   	push   %eax
801034d2:	e8 f9 d9 ff ff       	call   80100ed0 <fileclose>
801034d7:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801034da:	8b 06                	mov    (%esi),%eax
801034dc:	85 c0                	test   %eax,%eax
801034de:	74 0c                	je     801034ec <pipealloc+0xec>
    fileclose(*f1);
801034e0:	83 ec 0c             	sub    $0xc,%esp
801034e3:	50                   	push   %eax
801034e4:	e8 e7 d9 ff ff       	call   80100ed0 <fileclose>
801034e9:	83 c4 10             	add    $0x10,%esp
}
801034ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801034ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801034f4:	5b                   	pop    %ebx
801034f5:	5e                   	pop    %esi
801034f6:	5f                   	pop    %edi
801034f7:	5d                   	pop    %ebp
801034f8:	c3                   	ret    
801034f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103500:	8b 03                	mov    (%ebx),%eax
80103502:	85 c0                	test   %eax,%eax
80103504:	75 c8                	jne    801034ce <pipealloc+0xce>
80103506:	eb d2                	jmp    801034da <pipealloc+0xda>
80103508:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010350f:	90                   	nop

80103510 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103510:	f3 0f 1e fb          	endbr32 
80103514:	55                   	push   %ebp
80103515:	89 e5                	mov    %esp,%ebp
80103517:	56                   	push   %esi
80103518:	53                   	push   %ebx
80103519:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010351c:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010351f:	83 ec 0c             	sub    $0xc,%esp
80103522:	53                   	push   %ebx
80103523:	e8 68 17 00 00       	call   80104c90 <acquire>
  if(writable){
80103528:	83 c4 10             	add    $0x10,%esp
8010352b:	85 f6                	test   %esi,%esi
8010352d:	74 41                	je     80103570 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010352f:	83 ec 0c             	sub    $0xc,%esp
80103532:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103538:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010353f:	00 00 00 
    wakeup(&p->nread);
80103542:	50                   	push   %eax
80103543:	e8 78 0f 00 00       	call   801044c0 <wakeup>
80103548:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
8010354b:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103551:	85 d2                	test   %edx,%edx
80103553:	75 0a                	jne    8010355f <pipeclose+0x4f>
80103555:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
8010355b:	85 c0                	test   %eax,%eax
8010355d:	74 31                	je     80103590 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010355f:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103562:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103565:	5b                   	pop    %ebx
80103566:	5e                   	pop    %esi
80103567:	5d                   	pop    %ebp
    release(&p->lock);
80103568:	e9 e3 17 00 00       	jmp    80104d50 <release>
8010356d:	8d 76 00             	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103570:	83 ec 0c             	sub    $0xc,%esp
80103573:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103579:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103580:	00 00 00 
    wakeup(&p->nwrite);
80103583:	50                   	push   %eax
80103584:	e8 37 0f 00 00       	call   801044c0 <wakeup>
80103589:	83 c4 10             	add    $0x10,%esp
8010358c:	eb bd                	jmp    8010354b <pipeclose+0x3b>
8010358e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103590:	83 ec 0c             	sub    $0xc,%esp
80103593:	53                   	push   %ebx
80103594:	e8 b7 17 00 00       	call   80104d50 <release>
    kfree((char*)p);
80103599:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010359c:	83 c4 10             	add    $0x10,%esp
}
8010359f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035a2:	5b                   	pop    %ebx
801035a3:	5e                   	pop    %esi
801035a4:	5d                   	pop    %ebp
    kfree((char*)p);
801035a5:	e9 d6 ee ff ff       	jmp    80102480 <kfree>
801035aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801035b0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801035b0:	f3 0f 1e fb          	endbr32 
801035b4:	55                   	push   %ebp
801035b5:	89 e5                	mov    %esp,%ebp
801035b7:	57                   	push   %edi
801035b8:	56                   	push   %esi
801035b9:	53                   	push   %ebx
801035ba:	83 ec 28             	sub    $0x28,%esp
801035bd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801035c0:	53                   	push   %ebx
801035c1:	e8 ca 16 00 00       	call   80104c90 <acquire>
  for(i = 0; i < n; i++){
801035c6:	8b 45 10             	mov    0x10(%ebp),%eax
801035c9:	83 c4 10             	add    $0x10,%esp
801035cc:	85 c0                	test   %eax,%eax
801035ce:	0f 8e bc 00 00 00    	jle    80103690 <pipewrite+0xe0>
801035d4:	8b 45 0c             	mov    0xc(%ebp),%eax
801035d7:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801035dd:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
801035e3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801035e6:	03 45 10             	add    0x10(%ebp),%eax
801035e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035ec:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801035f2:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035f8:	89 ca                	mov    %ecx,%edx
801035fa:	05 00 02 00 00       	add    $0x200,%eax
801035ff:	39 c1                	cmp    %eax,%ecx
80103601:	74 3b                	je     8010363e <pipewrite+0x8e>
80103603:	eb 63                	jmp    80103668 <pipewrite+0xb8>
80103605:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->readopen == 0 || myproc()->killed){
80103608:	e8 f3 03 00 00       	call   80103a00 <myproc>
8010360d:	8b 48 24             	mov    0x24(%eax),%ecx
80103610:	85 c9                	test   %ecx,%ecx
80103612:	75 34                	jne    80103648 <pipewrite+0x98>
      wakeup(&p->nread);
80103614:	83 ec 0c             	sub    $0xc,%esp
80103617:	57                   	push   %edi
80103618:	e8 a3 0e 00 00       	call   801044c0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010361d:	58                   	pop    %eax
8010361e:	5a                   	pop    %edx
8010361f:	53                   	push   %ebx
80103620:	56                   	push   %esi
80103621:	e8 aa 0b 00 00       	call   801041d0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103626:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010362c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103632:	83 c4 10             	add    $0x10,%esp
80103635:	05 00 02 00 00       	add    $0x200,%eax
8010363a:	39 c2                	cmp    %eax,%edx
8010363c:	75 2a                	jne    80103668 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010363e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103644:	85 c0                	test   %eax,%eax
80103646:	75 c0                	jne    80103608 <pipewrite+0x58>
        release(&p->lock);
80103648:	83 ec 0c             	sub    $0xc,%esp
8010364b:	53                   	push   %ebx
8010364c:	e8 ff 16 00 00       	call   80104d50 <release>
        return -1;
80103651:	83 c4 10             	add    $0x10,%esp
80103654:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103659:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010365c:	5b                   	pop    %ebx
8010365d:	5e                   	pop    %esi
8010365e:	5f                   	pop    %edi
8010365f:	5d                   	pop    %ebp
80103660:	c3                   	ret    
80103661:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103668:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010366b:	8d 4a 01             	lea    0x1(%edx),%ecx
8010366e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103674:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
8010367a:	0f b6 06             	movzbl (%esi),%eax
8010367d:	83 c6 01             	add    $0x1,%esi
80103680:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80103683:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103687:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010368a:	0f 85 5c ff ff ff    	jne    801035ec <pipewrite+0x3c>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103690:	83 ec 0c             	sub    $0xc,%esp
80103693:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103699:	50                   	push   %eax
8010369a:	e8 21 0e 00 00       	call   801044c0 <wakeup>
  release(&p->lock);
8010369f:	89 1c 24             	mov    %ebx,(%esp)
801036a2:	e8 a9 16 00 00       	call   80104d50 <release>
  return n;
801036a7:	8b 45 10             	mov    0x10(%ebp),%eax
801036aa:	83 c4 10             	add    $0x10,%esp
801036ad:	eb aa                	jmp    80103659 <pipewrite+0xa9>
801036af:	90                   	nop

801036b0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801036b0:	f3 0f 1e fb          	endbr32 
801036b4:	55                   	push   %ebp
801036b5:	89 e5                	mov    %esp,%ebp
801036b7:	57                   	push   %edi
801036b8:	56                   	push   %esi
801036b9:	53                   	push   %ebx
801036ba:	83 ec 18             	sub    $0x18,%esp
801036bd:	8b 75 08             	mov    0x8(%ebp),%esi
801036c0:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801036c3:	56                   	push   %esi
801036c4:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801036ca:	e8 c1 15 00 00       	call   80104c90 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801036cf:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801036d5:	83 c4 10             	add    $0x10,%esp
801036d8:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
801036de:	74 33                	je     80103713 <piperead+0x63>
801036e0:	eb 3b                	jmp    8010371d <piperead+0x6d>
801036e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed){
801036e8:	e8 13 03 00 00       	call   80103a00 <myproc>
801036ed:	8b 48 24             	mov    0x24(%eax),%ecx
801036f0:	85 c9                	test   %ecx,%ecx
801036f2:	0f 85 88 00 00 00    	jne    80103780 <piperead+0xd0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801036f8:	83 ec 08             	sub    $0x8,%esp
801036fb:	56                   	push   %esi
801036fc:	53                   	push   %ebx
801036fd:	e8 ce 0a 00 00       	call   801041d0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103702:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103708:	83 c4 10             	add    $0x10,%esp
8010370b:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103711:	75 0a                	jne    8010371d <piperead+0x6d>
80103713:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103719:	85 c0                	test   %eax,%eax
8010371b:	75 cb                	jne    801036e8 <piperead+0x38>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010371d:	8b 55 10             	mov    0x10(%ebp),%edx
80103720:	31 db                	xor    %ebx,%ebx
80103722:	85 d2                	test   %edx,%edx
80103724:	7f 28                	jg     8010374e <piperead+0x9e>
80103726:	eb 34                	jmp    8010375c <piperead+0xac>
80103728:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010372f:	90                   	nop
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103730:	8d 48 01             	lea    0x1(%eax),%ecx
80103733:	25 ff 01 00 00       	and    $0x1ff,%eax
80103738:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010373e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103743:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103746:	83 c3 01             	add    $0x1,%ebx
80103749:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010374c:	74 0e                	je     8010375c <piperead+0xac>
    if(p->nread == p->nwrite)
8010374e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103754:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010375a:	75 d4                	jne    80103730 <piperead+0x80>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010375c:	83 ec 0c             	sub    $0xc,%esp
8010375f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103765:	50                   	push   %eax
80103766:	e8 55 0d 00 00       	call   801044c0 <wakeup>
  release(&p->lock);
8010376b:	89 34 24             	mov    %esi,(%esp)
8010376e:	e8 dd 15 00 00       	call   80104d50 <release>
  return i;
80103773:	83 c4 10             	add    $0x10,%esp
}
80103776:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103779:	89 d8                	mov    %ebx,%eax
8010377b:	5b                   	pop    %ebx
8010377c:	5e                   	pop    %esi
8010377d:	5f                   	pop    %edi
8010377e:	5d                   	pop    %ebp
8010377f:	c3                   	ret    
      release(&p->lock);
80103780:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103783:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103788:	56                   	push   %esi
80103789:	e8 c2 15 00 00       	call   80104d50 <release>
      return -1;
8010378e:	83 c4 10             	add    $0x10,%esp
}
80103791:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103794:	89 d8                	mov    %ebx,%eax
80103796:	5b                   	pop    %ebx
80103797:	5e                   	pop    %esi
80103798:	5f                   	pop    %edi
80103799:	5d                   	pop    %ebp
8010379a:	c3                   	ret    
8010379b:	66 90                	xchg   %ax,%ax
8010379d:	66 90                	xchg   %ax,%ax
8010379f:	90                   	nop

801037a0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801037a0:	55                   	push   %ebp
801037a1:	89 e5                	mov    %esp,%ebp
801037a3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037a4:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
{
801037a9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801037ac:	68 20 3d 11 80       	push   $0x80113d20
801037b1:	e8 da 14 00 00       	call   80104c90 <acquire>
801037b6:	83 c4 10             	add    $0x10,%esp
801037b9:	eb 17                	jmp    801037d2 <allocproc+0x32>
801037bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037bf:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037c0:	81 c3 b4 00 00 00    	add    $0xb4,%ebx
801037c6:	81 fb 54 6a 11 80    	cmp    $0x80116a54,%ebx
801037cc:	0f 84 fe 00 00 00    	je     801038d0 <allocproc+0x130>
    if(p->state == UNUSED)
801037d2:	8b 43 0c             	mov    0xc(%ebx),%eax
801037d5:	85 c0                	test   %eax,%eax
801037d7:	75 e7                	jne    801037c0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801037d9:	a1 04 b0 10 80       	mov    0x8010b004,%eax
  p->q[4]=0;
#ifdef YESPLOT
  cprintf("%d %d %d\n", ticks, p->pid, p->cur_q);           //for plotting graph
#endif

  release(&ptable.lock);
801037de:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801037e1:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->rtime=0;
801037e8:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
801037ef:	00 00 00 
  p->pid = nextpid++;
801037f2:	8d 50 01             	lea    0x1(%eax),%edx
801037f5:	89 43 10             	mov    %eax,0x10(%ebx)
  p->ctime=ticks;              //initialising ctime to current ticks
801037f8:	a1 a0 72 11 80       	mov    0x801172a0,%eax
  p->etime=0;
801037fd:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
80103804:	00 00 00 
  p->ctime=ticks;              //initialising ctime to current ticks
80103807:	89 43 7c             	mov    %eax,0x7c(%ebx)
  p->lastexecuted=ticks;         //initialsing lastexecuted to current ticks
8010380a:	89 83 94 00 00 00    	mov    %eax,0x94(%ebx)
  p->iotime=0;
80103810:	c7 83 88 00 00 00 00 	movl   $0x0,0x88(%ebx)
80103817:	00 00 00 
  p->priority=60;                 //default priority
8010381a:	c7 83 8c 00 00 00 3c 	movl   $0x3c,0x8c(%ebx)
80103821:	00 00 00 
  p->n_run=0;
80103824:	c7 83 98 00 00 00 00 	movl   $0x0,0x98(%ebx)
8010382b:	00 00 00 
  p->cur_q=-1;                   //for other schedulers initialisation to -1 as of no use
8010382e:	c7 83 9c 00 00 00 ff 	movl   $0xffffffff,0x9c(%ebx)
80103835:	ff ff ff 
  p->currentslice=0;
80103838:	c7 83 90 00 00 00 00 	movl   $0x0,0x90(%ebx)
8010383f:	00 00 00 
  p->q[0]=0;
80103842:	c7 83 a0 00 00 00 00 	movl   $0x0,0xa0(%ebx)
80103849:	00 00 00 
  p->q[1]=0;
8010384c:	c7 83 a4 00 00 00 00 	movl   $0x0,0xa4(%ebx)
80103853:	00 00 00 
  p->q[2]=0;
80103856:	c7 83 a8 00 00 00 00 	movl   $0x0,0xa8(%ebx)
8010385d:	00 00 00 
  p->q[3]=0;
80103860:	c7 83 ac 00 00 00 00 	movl   $0x0,0xac(%ebx)
80103867:	00 00 00 
  p->q[4]=0;
8010386a:	c7 83 b0 00 00 00 00 	movl   $0x0,0xb0(%ebx)
80103871:	00 00 00 
  release(&ptable.lock);
80103874:	68 20 3d 11 80       	push   $0x80113d20
  p->pid = nextpid++;
80103879:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
8010387f:	e8 cc 14 00 00       	call   80104d50 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103884:	e8 b7 ed ff ff       	call   80102640 <kalloc>
80103889:	83 c4 10             	add    $0x10,%esp
8010388c:	89 43 08             	mov    %eax,0x8(%ebx)
8010388f:	85 c0                	test   %eax,%eax
80103891:	74 56                	je     801038e9 <allocproc+0x149>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103893:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103899:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010389c:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
801038a1:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
801038a4:	c7 40 14 9f 60 10 80 	movl   $0x8010609f,0x14(%eax)
  p->context = (struct context*)sp;
801038ab:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801038ae:	6a 14                	push   $0x14
801038b0:	6a 00                	push   $0x0
801038b2:	50                   	push   %eax
801038b3:	e8 e8 14 00 00       	call   80104da0 <memset>
  p->context->eip = (uint)forkret;
801038b8:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
801038bb:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801038be:	c7 40 10 00 39 10 80 	movl   $0x80103900,0x10(%eax)
}
801038c5:	89 d8                	mov    %ebx,%eax
801038c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038ca:	c9                   	leave  
801038cb:	c3                   	ret    
801038cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
801038d0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
801038d3:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
801038d5:	68 20 3d 11 80       	push   $0x80113d20
801038da:	e8 71 14 00 00       	call   80104d50 <release>
}
801038df:	89 d8                	mov    %ebx,%eax
  return 0;
801038e1:	83 c4 10             	add    $0x10,%esp
}
801038e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038e7:	c9                   	leave  
801038e8:	c3                   	ret    
    p->state = UNUSED;
801038e9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801038f0:	31 db                	xor    %ebx,%ebx
}
801038f2:	89 d8                	mov    %ebx,%eax
801038f4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038f7:	c9                   	leave  
801038f8:	c3                   	ret    
801038f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103900 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103900:	f3 0f 1e fb          	endbr32 
80103904:	55                   	push   %ebp
80103905:	89 e5                	mov    %esp,%ebp
80103907:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
8010390a:	68 20 3d 11 80       	push   $0x80113d20
8010390f:	e8 3c 14 00 00       	call   80104d50 <release>

  if (first) {
80103914:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103919:	83 c4 10             	add    $0x10,%esp
8010391c:	85 c0                	test   %eax,%eax
8010391e:	75 08                	jne    80103928 <forkret+0x28>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103920:	c9                   	leave  
80103921:	c3                   	ret    
80103922:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    first = 0;
80103928:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
8010392f:	00 00 00 
    iinit(ROOTDEV);
80103932:	83 ec 0c             	sub    $0xc,%esp
80103935:	6a 01                	push   $0x1
80103937:	e8 14 dc ff ff       	call   80101550 <iinit>
    initlog(ROOTDEV);
8010393c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103943:	e8 58 f3 ff ff       	call   80102ca0 <initlog>
}
80103948:	83 c4 10             	add    $0x10,%esp
8010394b:	c9                   	leave  
8010394c:	c3                   	ret    
8010394d:	8d 76 00             	lea    0x0(%esi),%esi

80103950 <pinit>:
{
80103950:	f3 0f 1e fb          	endbr32 
80103954:	55                   	push   %ebp
80103955:	89 e5                	mov    %esp,%ebp
80103957:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
8010395a:	68 40 7e 10 80       	push   $0x80107e40
8010395f:	68 20 3d 11 80       	push   $0x80113d20
80103964:	e8 a7 11 00 00       	call   80104b10 <initlock>
}
80103969:	83 c4 10             	add    $0x10,%esp
8010396c:	c9                   	leave  
8010396d:	c3                   	ret    
8010396e:	66 90                	xchg   %ax,%ax

80103970 <mycpu>:
{
80103970:	f3 0f 1e fb          	endbr32 
80103974:	55                   	push   %ebp
80103975:	89 e5                	mov    %esp,%ebp
80103977:	56                   	push   %esi
80103978:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103979:	9c                   	pushf  
8010397a:	58                   	pop    %eax
  if(readeflags()&FL_IF)
8010397b:	f6 c4 02             	test   $0x2,%ah
8010397e:	75 4a                	jne    801039ca <mycpu+0x5a>
  apicid = lapicid();
80103980:	e8 2b ef ff ff       	call   801028b0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103985:	8b 35 00 3d 11 80    	mov    0x80113d00,%esi
  apicid = lapicid();
8010398b:	89 c3                	mov    %eax,%ebx
  for (i = 0; i < ncpu; ++i) {
8010398d:	85 f6                	test   %esi,%esi
8010398f:	7e 2c                	jle    801039bd <mycpu+0x4d>
80103991:	31 d2                	xor    %edx,%edx
80103993:	eb 0a                	jmp    8010399f <mycpu+0x2f>
80103995:	8d 76 00             	lea    0x0(%esi),%esi
80103998:	83 c2 01             	add    $0x1,%edx
8010399b:	39 f2                	cmp    %esi,%edx
8010399d:	74 1e                	je     801039bd <mycpu+0x4d>
    if (cpus[i].apicid == apicid)
8010399f:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
801039a5:	0f b6 81 80 37 11 80 	movzbl -0x7feec880(%ecx),%eax
801039ac:	39 d8                	cmp    %ebx,%eax
801039ae:	75 e8                	jne    80103998 <mycpu+0x28>
}
801039b0:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
801039b3:	8d 81 80 37 11 80    	lea    -0x7feec880(%ecx),%eax
}
801039b9:	5b                   	pop    %ebx
801039ba:	5e                   	pop    %esi
801039bb:	5d                   	pop    %ebp
801039bc:	c3                   	ret    
  panic("unknown apicid\n");
801039bd:	83 ec 0c             	sub    $0xc,%esp
801039c0:	68 47 7e 10 80       	push   $0x80107e47
801039c5:	e8 c6 c9 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
801039ca:	83 ec 0c             	sub    $0xc,%esp
801039cd:	68 54 7f 10 80       	push   $0x80107f54
801039d2:	e8 b9 c9 ff ff       	call   80100390 <panic>
801039d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039de:	66 90                	xchg   %ax,%ax

801039e0 <cpuid>:
cpuid() {
801039e0:	f3 0f 1e fb          	endbr32 
801039e4:	55                   	push   %ebp
801039e5:	89 e5                	mov    %esp,%ebp
801039e7:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801039ea:	e8 81 ff ff ff       	call   80103970 <mycpu>
}
801039ef:	c9                   	leave  
  return mycpu()-cpus;
801039f0:	2d 80 37 11 80       	sub    $0x80113780,%eax
801039f5:	c1 f8 04             	sar    $0x4,%eax
801039f8:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801039fe:	c3                   	ret    
801039ff:	90                   	nop

80103a00 <myproc>:
myproc(void) {
80103a00:	f3 0f 1e fb          	endbr32 
80103a04:	55                   	push   %ebp
80103a05:	89 e5                	mov    %esp,%ebp
80103a07:	53                   	push   %ebx
80103a08:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103a0b:	e8 80 11 00 00       	call   80104b90 <pushcli>
  c = mycpu();
80103a10:	e8 5b ff ff ff       	call   80103970 <mycpu>
  p = c->proc;
80103a15:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103a1b:	e8 c0 11 00 00       	call   80104be0 <popcli>
}
80103a20:	83 c4 04             	add    $0x4,%esp
80103a23:	89 d8                	mov    %ebx,%eax
80103a25:	5b                   	pop    %ebx
80103a26:	5d                   	pop    %ebp
80103a27:	c3                   	ret    
80103a28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a2f:	90                   	nop

80103a30 <userinit>:
{
80103a30:	f3 0f 1e fb          	endbr32 
80103a34:	55                   	push   %ebp
80103a35:	89 e5                	mov    %esp,%ebp
80103a37:	53                   	push   %ebx
80103a38:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103a3b:	e8 60 fd ff ff       	call   801037a0 <allocproc>
80103a40:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103a42:	a3 b8 b5 10 80       	mov    %eax,0x8010b5b8
  if((p->pgdir = setupkvm()) == 0)
80103a47:	e8 24 3c 00 00       	call   80107670 <setupkvm>
80103a4c:	89 43 04             	mov    %eax,0x4(%ebx)
80103a4f:	85 c0                	test   %eax,%eax
80103a51:	0f 84 bd 00 00 00    	je     80103b14 <userinit+0xe4>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103a57:	83 ec 04             	sub    $0x4,%esp
80103a5a:	68 2c 00 00 00       	push   $0x2c
80103a5f:	68 60 b4 10 80       	push   $0x8010b460
80103a64:	50                   	push   %eax
80103a65:	e8 d6 38 00 00       	call   80107340 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103a6a:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103a6d:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103a73:	6a 4c                	push   $0x4c
80103a75:	6a 00                	push   $0x0
80103a77:	ff 73 18             	pushl  0x18(%ebx)
80103a7a:	e8 21 13 00 00       	call   80104da0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a7f:	8b 43 18             	mov    0x18(%ebx),%eax
80103a82:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a87:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a8a:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a8f:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a93:	8b 43 18             	mov    0x18(%ebx),%eax
80103a96:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103a9a:	8b 43 18             	mov    0x18(%ebx),%eax
80103a9d:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103aa1:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103aa5:	8b 43 18             	mov    0x18(%ebx),%eax
80103aa8:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103aac:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103ab0:	8b 43 18             	mov    0x18(%ebx),%eax
80103ab3:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103aba:	8b 43 18             	mov    0x18(%ebx),%eax
80103abd:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103ac4:	8b 43 18             	mov    0x18(%ebx),%eax
80103ac7:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103ace:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103ad1:	6a 10                	push   $0x10
80103ad3:	68 70 7e 10 80       	push   $0x80107e70
80103ad8:	50                   	push   %eax
80103ad9:	e8 82 14 00 00       	call   80104f60 <safestrcpy>
  p->cwd = namei("/");
80103ade:	c7 04 24 79 7e 10 80 	movl   $0x80107e79,(%esp)
80103ae5:	e8 56 e5 ff ff       	call   80102040 <namei>
80103aea:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103aed:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103af4:	e8 97 11 00 00       	call   80104c90 <acquire>
  p->state = RUNNABLE;
80103af9:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103b00:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103b07:	e8 44 12 00 00       	call   80104d50 <release>
}
80103b0c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b0f:	83 c4 10             	add    $0x10,%esp
80103b12:	c9                   	leave  
80103b13:	c3                   	ret    
    panic("userinit: out of memory?");
80103b14:	83 ec 0c             	sub    $0xc,%esp
80103b17:	68 57 7e 10 80       	push   $0x80107e57
80103b1c:	e8 6f c8 ff ff       	call   80100390 <panic>
80103b21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b2f:	90                   	nop

80103b30 <growproc>:
{
80103b30:	f3 0f 1e fb          	endbr32 
80103b34:	55                   	push   %ebp
80103b35:	89 e5                	mov    %esp,%ebp
80103b37:	56                   	push   %esi
80103b38:	53                   	push   %ebx
80103b39:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103b3c:	e8 4f 10 00 00       	call   80104b90 <pushcli>
  c = mycpu();
80103b41:	e8 2a fe ff ff       	call   80103970 <mycpu>
  p = c->proc;
80103b46:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b4c:	e8 8f 10 00 00       	call   80104be0 <popcli>
  sz = curproc->sz;
80103b51:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103b53:	85 f6                	test   %esi,%esi
80103b55:	7f 19                	jg     80103b70 <growproc+0x40>
  } else if(n < 0){
80103b57:	75 37                	jne    80103b90 <growproc+0x60>
  switchuvm(curproc);
80103b59:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103b5c:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103b5e:	53                   	push   %ebx
80103b5f:	e8 cc 36 00 00       	call   80107230 <switchuvm>
  return 0;
80103b64:	83 c4 10             	add    $0x10,%esp
80103b67:	31 c0                	xor    %eax,%eax
}
80103b69:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b6c:	5b                   	pop    %ebx
80103b6d:	5e                   	pop    %esi
80103b6e:	5d                   	pop    %ebp
80103b6f:	c3                   	ret    
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b70:	83 ec 04             	sub    $0x4,%esp
80103b73:	01 c6                	add    %eax,%esi
80103b75:	56                   	push   %esi
80103b76:	50                   	push   %eax
80103b77:	ff 73 04             	pushl  0x4(%ebx)
80103b7a:	e8 11 39 00 00       	call   80107490 <allocuvm>
80103b7f:	83 c4 10             	add    $0x10,%esp
80103b82:	85 c0                	test   %eax,%eax
80103b84:	75 d3                	jne    80103b59 <growproc+0x29>
      return -1;
80103b86:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103b8b:	eb dc                	jmp    80103b69 <growproc+0x39>
80103b8d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b90:	83 ec 04             	sub    $0x4,%esp
80103b93:	01 c6                	add    %eax,%esi
80103b95:	56                   	push   %esi
80103b96:	50                   	push   %eax
80103b97:	ff 73 04             	pushl  0x4(%ebx)
80103b9a:	e8 21 3a 00 00       	call   801075c0 <deallocuvm>
80103b9f:	83 c4 10             	add    $0x10,%esp
80103ba2:	85 c0                	test   %eax,%eax
80103ba4:	75 b3                	jne    80103b59 <growproc+0x29>
80103ba6:	eb de                	jmp    80103b86 <growproc+0x56>
80103ba8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103baf:	90                   	nop

80103bb0 <fork>:
{
80103bb0:	f3 0f 1e fb          	endbr32 
80103bb4:	55                   	push   %ebp
80103bb5:	89 e5                	mov    %esp,%ebp
80103bb7:	57                   	push   %edi
80103bb8:	56                   	push   %esi
80103bb9:	53                   	push   %ebx
80103bba:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103bbd:	e8 ce 0f 00 00       	call   80104b90 <pushcli>
  c = mycpu();
80103bc2:	e8 a9 fd ff ff       	call   80103970 <mycpu>
  p = c->proc;
80103bc7:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103bcd:	e8 0e 10 00 00       	call   80104be0 <popcli>
  if((np = allocproc()) == 0){
80103bd2:	e8 c9 fb ff ff       	call   801037a0 <allocproc>
80103bd7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103bda:	85 c0                	test   %eax,%eax
80103bdc:	0f 84 bb 00 00 00    	je     80103c9d <fork+0xed>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103be2:	83 ec 08             	sub    $0x8,%esp
80103be5:	ff 33                	pushl  (%ebx)
80103be7:	89 c7                	mov    %eax,%edi
80103be9:	ff 73 04             	pushl  0x4(%ebx)
80103bec:	e8 4f 3b 00 00       	call   80107740 <copyuvm>
80103bf1:	83 c4 10             	add    $0x10,%esp
80103bf4:	89 47 04             	mov    %eax,0x4(%edi)
80103bf7:	85 c0                	test   %eax,%eax
80103bf9:	0f 84 a5 00 00 00    	je     80103ca4 <fork+0xf4>
  np->sz = curproc->sz;
80103bff:	8b 03                	mov    (%ebx),%eax
80103c01:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103c04:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103c06:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103c09:	89 c8                	mov    %ecx,%eax
80103c0b:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103c0e:	b9 13 00 00 00       	mov    $0x13,%ecx
80103c13:	8b 73 18             	mov    0x18(%ebx),%esi
80103c16:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103c18:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103c1a:	8b 40 18             	mov    0x18(%eax),%eax
80103c1d:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80103c24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[i])
80103c28:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103c2c:	85 c0                	test   %eax,%eax
80103c2e:	74 13                	je     80103c43 <fork+0x93>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103c30:	83 ec 0c             	sub    $0xc,%esp
80103c33:	50                   	push   %eax
80103c34:	e8 47 d2 ff ff       	call   80100e80 <filedup>
80103c39:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103c3c:	83 c4 10             	add    $0x10,%esp
80103c3f:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103c43:	83 c6 01             	add    $0x1,%esi
80103c46:	83 fe 10             	cmp    $0x10,%esi
80103c49:	75 dd                	jne    80103c28 <fork+0x78>
  np->cwd = idup(curproc->cwd);
80103c4b:	83 ec 0c             	sub    $0xc,%esp
80103c4e:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c51:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103c54:	e8 e7 da ff ff       	call   80101740 <idup>
80103c59:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c5c:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103c5f:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c62:	8d 47 6c             	lea    0x6c(%edi),%eax
80103c65:	6a 10                	push   $0x10
80103c67:	53                   	push   %ebx
80103c68:	50                   	push   %eax
80103c69:	e8 f2 12 00 00       	call   80104f60 <safestrcpy>
  pid = np->pid;
80103c6e:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103c71:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103c78:	e8 13 10 00 00       	call   80104c90 <acquire>
  np->state = RUNNABLE;
80103c7d:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103c84:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103c8b:	e8 c0 10 00 00       	call   80104d50 <release>
  return pid;
80103c90:	83 c4 10             	add    $0x10,%esp
}
80103c93:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c96:	89 d8                	mov    %ebx,%eax
80103c98:	5b                   	pop    %ebx
80103c99:	5e                   	pop    %esi
80103c9a:	5f                   	pop    %edi
80103c9b:	5d                   	pop    %ebp
80103c9c:	c3                   	ret    
    return -1;
80103c9d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103ca2:	eb ef                	jmp    80103c93 <fork+0xe3>
    kfree(np->kstack);
80103ca4:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103ca7:	83 ec 0c             	sub    $0xc,%esp
80103caa:	ff 73 08             	pushl  0x8(%ebx)
80103cad:	e8 ce e7 ff ff       	call   80102480 <kfree>
    np->kstack = 0;
80103cb2:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103cb9:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103cbc:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103cc3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103cc8:	eb c9                	jmp    80103c93 <fork+0xe3>
80103cca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103cd0 <updatetimes>:
{
80103cd0:	f3 0f 1e fb          	endbr32 
80103cd4:	55                   	push   %ebp
80103cd5:	89 e5                	mov    %esp,%ebp
80103cd7:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);
80103cda:	68 20 3d 11 80       	push   $0x80113d20
80103cdf:	e8 ac 0f 00 00       	call   80104c90 <acquire>
      p->lastexecuted=ticks;
80103ce4:	8b 0d a0 72 11 80    	mov    0x801172a0,%ecx
80103cea:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ced:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80103cf2:	eb 22                	jmp    80103d16 <updatetimes+0x46>
80103cf4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if(p->state==SLEEPING)
80103cf8:	83 fa 02             	cmp    $0x2,%edx
80103cfb:	75 0d                	jne    80103d0a <updatetimes+0x3a>
      p->iotime++;
80103cfd:	83 80 88 00 00 00 01 	addl   $0x1,0x88(%eax)
      p->lastexecuted=ticks;
80103d04:	89 88 94 00 00 00    	mov    %ecx,0x94(%eax)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d0a:	05 b4 00 00 00       	add    $0xb4,%eax
80103d0f:	3d 54 6a 11 80       	cmp    $0x80116a54,%eax
80103d14:	74 3b                	je     80103d51 <updatetimes+0x81>
    if(p->state==RUNNING)
80103d16:	8b 50 0c             	mov    0xc(%eax),%edx
80103d19:	83 fa 04             	cmp    $0x4,%edx
80103d1c:	75 da                	jne    80103cf8 <updatetimes+0x28>
      if(p->cur_q!=-1)
80103d1e:	8b 90 9c 00 00 00    	mov    0x9c(%eax),%edx
      p->rtime++;                        //updating runtime
80103d24:	83 80 80 00 00 00 01 	addl   $0x1,0x80(%eax)
      p->currentslice++;
80103d2b:	83 80 90 00 00 00 01 	addl   $0x1,0x90(%eax)
      p->lastexecuted=ticks;           
80103d32:	89 88 94 00 00 00    	mov    %ecx,0x94(%eax)
      if(p->cur_q!=-1)
80103d38:	83 fa ff             	cmp    $0xffffffff,%edx
80103d3b:	74 cd                	je     80103d0a <updatetimes+0x3a>
        p->q[p->cur_q]++;
80103d3d:	83 84 90 a0 00 00 00 	addl   $0x1,0xa0(%eax,%edx,4)
80103d44:	01 
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d45:	05 b4 00 00 00       	add    $0xb4,%eax
80103d4a:	3d 54 6a 11 80       	cmp    $0x80116a54,%eax
80103d4f:	75 c5                	jne    80103d16 <updatetimes+0x46>
  release(&ptable.lock);
80103d51:	83 ec 0c             	sub    $0xc,%esp
80103d54:	68 20 3d 11 80       	push   $0x80113d20
80103d59:	e8 f2 0f 00 00       	call   80104d50 <release>
}
80103d5e:	83 c4 10             	add    $0x10,%esp
80103d61:	c9                   	leave  
80103d62:	c3                   	ret    
80103d63:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103d70 <scheduler>:
{
80103d70:	f3 0f 1e fb          	endbr32 
80103d74:	55                   	push   %ebp
80103d75:	89 e5                	mov    %esp,%ebp
80103d77:	57                   	push   %edi
80103d78:	56                   	push   %esi
80103d79:	53                   	push   %ebx
80103d7a:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
80103d7d:	e8 ee fb ff ff       	call   80103970 <mycpu>
  c->proc = 0;
80103d82:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103d89:	00 00 00 
  struct cpu *c = mycpu();
80103d8c:	89 c3                	mov    %eax,%ebx
  c->proc = 0;
80103d8e:	8d 40 04             	lea    0x4(%eax),%eax
80103d91:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103d94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("sti");
80103d98:	fb                   	sti    
    acquire(&ptable.lock);
80103d99:	83 ec 0c             	sub    $0xc,%esp
    struct proc *nxt = 0;
80103d9c:	31 ff                	xor    %edi,%edi
    acquire(&ptable.lock);
80103d9e:	68 20 3d 11 80       	push   $0x80113d20
80103da3:	e8 e8 0e 00 00       	call   80104c90 <acquire>
80103da8:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) //finiding minimum priority
80103dab:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80103db0:	eb 21                	jmp    80103dd3 <scheduler+0x63>
80103db2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        if (p->priority < nxt->priority)
80103db8:	8b 8f 8c 00 00 00    	mov    0x8c(%edi),%ecx
80103dbe:	39 88 8c 00 00 00    	cmp    %ecx,0x8c(%eax)
80103dc4:	0f 4c f8             	cmovl  %eax,%edi
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) //finiding minimum priority
80103dc7:	05 b4 00 00 00       	add    $0xb4,%eax
80103dcc:	3d 54 6a 11 80       	cmp    $0x80116a54,%eax
80103dd1:	74 1d                	je     80103df0 <scheduler+0x80>
      if (p->state != RUNNABLE)
80103dd3:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80103dd7:	75 ee                	jne    80103dc7 <scheduler+0x57>
      if (nxt == 0)
80103dd9:	85 ff                	test   %edi,%edi
80103ddb:	75 db                	jne    80103db8 <scheduler+0x48>
80103ddd:	89 c7                	mov    %eax,%edi
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) //finiding minimum priority
80103ddf:	05 b4 00 00 00       	add    $0xb4,%eax
80103de4:	3d 54 6a 11 80       	cmp    $0x80116a54,%eax
80103de9:	75 e8                	jne    80103dd3 <scheduler+0x63>
80103deb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103def:	90                   	nop
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)//round robin for same priority things
80103df0:	be 54 3d 11 80       	mov    $0x80113d54,%esi
    if (nxt == 0)
80103df5:	85 ff                	test   %edi,%edi
80103df7:	0f 85 9d 00 00 00    	jne    80103e9a <scheduler+0x12a>
      release(&ptable.lock);
80103dfd:	83 ec 0c             	sub    $0xc,%esp
80103e00:	68 20 3d 11 80       	push   $0x80113d20
80103e05:	e8 46 0f 00 00       	call   80104d50 <release>
      continue;
80103e0a:	83 c4 10             	add    $0x10,%esp
80103e0d:	eb 89                	jmp    80103d98 <scheduler+0x28>
80103e0f:	90                   	nop
        switchuvm(p);
80103e10:	83 ec 0c             	sub    $0xc,%esp
        c->proc = p;
80103e13:	89 b3 ac 00 00 00    	mov    %esi,0xac(%ebx)
        switchuvm(p);
80103e19:	56                   	push   %esi
80103e1a:	e8 11 34 00 00       	call   80107230 <switchuvm>
        swtch(&(c->scheduler), p->context);
80103e1f:	58                   	pop    %eax
80103e20:	5a                   	pop    %edx
80103e21:	ff 76 1c             	pushl  0x1c(%esi)
80103e24:	ff 75 e4             	pushl  -0x1c(%ebp)
        p->n_run++;
80103e27:	83 86 98 00 00 00 01 	addl   $0x1,0x98(%esi)
        p->state = RUNNING;
80103e2e:	c7 46 0c 04 00 00 00 	movl   $0x4,0xc(%esi)
        swtch(&(c->scheduler), p->context);
80103e35:	e8 89 11 00 00       	call   80104fc3 <swtch>
        switchkvm();
80103e3a:	e8 d1 33 00 00       	call   80107210 <switchkvm>
        p->lastexecuted = ticks;
80103e3f:	8b 15 a0 72 11 80    	mov    0x801172a0,%edx
        c->proc = 0;
80103e45:	83 c4 10             	add    $0x10,%esp
        p->lastexecuted = ticks;
80103e48:	89 96 94 00 00 00    	mov    %edx,0x94(%esi)
        for(next = ptable.proc; next < &ptable.proc[NPROC]; next++)
80103e4e:	ba 54 3d 11 80       	mov    $0x80113d54,%edx
        c->proc = 0;
80103e53:	c7 83 ac 00 00 00 00 	movl   $0x0,0xac(%ebx)
80103e5a:	00 00 00 
        for(next = ptable.proc; next < &ptable.proc[NPROC]; next++)
80103e5d:	8d 76 00             	lea    0x0(%esi),%esi
          if(next->state!=RUNNABLE)
80103e60:	83 7a 0c 03          	cmpl   $0x3,0xc(%edx)
80103e64:	75 0e                	jne    80103e74 <scheduler+0x104>
          if(next->state==RUNNABLE && next->priority < nxt->priority)
80103e66:	8b 87 8c 00 00 00    	mov    0x8c(%edi),%eax
80103e6c:	39 82 8c 00 00 00    	cmp    %eax,0x8c(%edx)
80103e72:	7c 89                	jl     80103dfd <scheduler+0x8d>
        for(next = ptable.proc; next < &ptable.proc[NPROC]; next++)
80103e74:	81 c2 b4 00 00 00    	add    $0xb4,%edx
80103e7a:	81 fa 54 6a 11 80    	cmp    $0x80116a54,%edx
80103e80:	75 de                	jne    80103e60 <scheduler+0xf0>
80103e82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)//round robin for same priority things
80103e88:	81 c6 b4 00 00 00    	add    $0xb4,%esi
80103e8e:	81 fe 54 6a 11 80    	cmp    $0x80116a54,%esi
80103e94:	0f 84 63 ff ff ff    	je     80103dfd <scheduler+0x8d>
      if (p->state != RUNNABLE)
80103e9a:	83 7e 0c 03          	cmpl   $0x3,0xc(%esi)
80103e9e:	75 e8                	jne    80103e88 <scheduler+0x118>
      if (p->state==RUNNABLE && nxt->priority == p->priority)    //if the process is runnable and equal to minprioritythen we have to assign it
80103ea0:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
80103ea6:	39 87 8c 00 00 00    	cmp    %eax,0x8c(%edi)
80103eac:	75 da                	jne    80103e88 <scheduler+0x118>
80103eae:	e9 5d ff ff ff       	jmp    80103e10 <scheduler+0xa0>
80103eb3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103eba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103ec0 <sched>:
{
80103ec0:	f3 0f 1e fb          	endbr32 
80103ec4:	55                   	push   %ebp
80103ec5:	89 e5                	mov    %esp,%ebp
80103ec7:	56                   	push   %esi
80103ec8:	53                   	push   %ebx
  pushcli();
80103ec9:	e8 c2 0c 00 00       	call   80104b90 <pushcli>
  c = mycpu();
80103ece:	e8 9d fa ff ff       	call   80103970 <mycpu>
  p = c->proc;
80103ed3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ed9:	e8 02 0d 00 00       	call   80104be0 <popcli>
  if(!holding(&ptable.lock))
80103ede:	83 ec 0c             	sub    $0xc,%esp
80103ee1:	68 20 3d 11 80       	push   $0x80113d20
80103ee6:	e8 55 0d 00 00       	call   80104c40 <holding>
80103eeb:	83 c4 10             	add    $0x10,%esp
80103eee:	85 c0                	test   %eax,%eax
80103ef0:	74 4f                	je     80103f41 <sched+0x81>
  if(mycpu()->ncli != 1)
80103ef2:	e8 79 fa ff ff       	call   80103970 <mycpu>
80103ef7:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103efe:	75 68                	jne    80103f68 <sched+0xa8>
  if(p->state == RUNNING)
80103f00:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103f04:	74 55                	je     80103f5b <sched+0x9b>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103f06:	9c                   	pushf  
80103f07:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103f08:	f6 c4 02             	test   $0x2,%ah
80103f0b:	75 41                	jne    80103f4e <sched+0x8e>
  intena = mycpu()->intena;
80103f0d:	e8 5e fa ff ff       	call   80103970 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103f12:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103f15:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103f1b:	e8 50 fa ff ff       	call   80103970 <mycpu>
80103f20:	83 ec 08             	sub    $0x8,%esp
80103f23:	ff 70 04             	pushl  0x4(%eax)
80103f26:	53                   	push   %ebx
80103f27:	e8 97 10 00 00       	call   80104fc3 <swtch>
  mycpu()->intena = intena;
80103f2c:	e8 3f fa ff ff       	call   80103970 <mycpu>
}
80103f31:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103f34:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103f3a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103f3d:	5b                   	pop    %ebx
80103f3e:	5e                   	pop    %esi
80103f3f:	5d                   	pop    %ebp
80103f40:	c3                   	ret    
    panic("sched ptable.lock");
80103f41:	83 ec 0c             	sub    $0xc,%esp
80103f44:	68 7b 7e 10 80       	push   $0x80107e7b
80103f49:	e8 42 c4 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
80103f4e:	83 ec 0c             	sub    $0xc,%esp
80103f51:	68 a7 7e 10 80       	push   $0x80107ea7
80103f56:	e8 35 c4 ff ff       	call   80100390 <panic>
    panic("sched running");
80103f5b:	83 ec 0c             	sub    $0xc,%esp
80103f5e:	68 99 7e 10 80       	push   $0x80107e99
80103f63:	e8 28 c4 ff ff       	call   80100390 <panic>
    panic("sched locks");
80103f68:	83 ec 0c             	sub    $0xc,%esp
80103f6b:	68 8d 7e 10 80       	push   $0x80107e8d
80103f70:	e8 1b c4 ff ff       	call   80100390 <panic>
80103f75:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103f80 <exit>:
{
80103f80:	f3 0f 1e fb          	endbr32 
80103f84:	55                   	push   %ebp
80103f85:	89 e5                	mov    %esp,%ebp
80103f87:	57                   	push   %edi
80103f88:	56                   	push   %esi
80103f89:	53                   	push   %ebx
80103f8a:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80103f8d:	e8 fe 0b 00 00       	call   80104b90 <pushcli>
  c = mycpu();
80103f92:	e8 d9 f9 ff ff       	call   80103970 <mycpu>
  p = c->proc;
80103f97:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f9d:	e8 3e 0c 00 00       	call   80104be0 <popcli>
  if(curproc == initproc)
80103fa2:	8d 73 28             	lea    0x28(%ebx),%esi
80103fa5:	8d 7b 68             	lea    0x68(%ebx),%edi
80103fa8:	39 1d b8 b5 10 80    	cmp    %ebx,0x8010b5b8
80103fae:	0f 84 12 01 00 00    	je     801040c6 <exit+0x146>
80103fb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd]){
80103fb8:	8b 06                	mov    (%esi),%eax
80103fba:	85 c0                	test   %eax,%eax
80103fbc:	74 12                	je     80103fd0 <exit+0x50>
      fileclose(curproc->ofile[fd]);
80103fbe:	83 ec 0c             	sub    $0xc,%esp
80103fc1:	50                   	push   %eax
80103fc2:	e8 09 cf ff ff       	call   80100ed0 <fileclose>
      curproc->ofile[fd] = 0;
80103fc7:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103fcd:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103fd0:	83 c6 04             	add    $0x4,%esi
80103fd3:	39 f7                	cmp    %esi,%edi
80103fd5:	75 e1                	jne    80103fb8 <exit+0x38>
  begin_op();
80103fd7:	e8 64 ed ff ff       	call   80102d40 <begin_op>
  iput(curproc->cwd);
80103fdc:	83 ec 0c             	sub    $0xc,%esp
80103fdf:	ff 73 68             	pushl  0x68(%ebx)
80103fe2:	e8 b9 d8 ff ff       	call   801018a0 <iput>
  end_op();
80103fe7:	e8 c4 ed ff ff       	call   80102db0 <end_op>
  curproc->cwd = 0;
80103fec:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80103ff3:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103ffa:	e8 91 0c 00 00       	call   80104c90 <acquire>
  wakeup1(curproc->parent);
80103fff:	8b 53 14             	mov    0x14(%ebx),%edx
80104002:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104005:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
8010400a:	eb 10                	jmp    8010401c <exit+0x9c>
8010400c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104010:	05 b4 00 00 00       	add    $0xb4,%eax
80104015:	3d 54 6a 11 80       	cmp    $0x80116a54,%eax
8010401a:	74 1e                	je     8010403a <exit+0xba>
    if(p->state == SLEEPING && p->chan == chan)
8010401c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104020:	75 ee                	jne    80104010 <exit+0x90>
80104022:	3b 50 20             	cmp    0x20(%eax),%edx
80104025:	75 e9                	jne    80104010 <exit+0x90>
      p->state = RUNNABLE;
80104027:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010402e:	05 b4 00 00 00       	add    $0xb4,%eax
80104033:	3d 54 6a 11 80       	cmp    $0x80116a54,%eax
80104038:	75 e2                	jne    8010401c <exit+0x9c>
      p->parent = initproc;
8010403a:	8b 0d b8 b5 10 80    	mov    0x8010b5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104040:	ba 54 3d 11 80       	mov    $0x80113d54,%edx
80104045:	eb 17                	jmp    8010405e <exit+0xde>
80104047:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010404e:	66 90                	xchg   %ax,%ax
80104050:	81 c2 b4 00 00 00    	add    $0xb4,%edx
80104056:	81 fa 54 6a 11 80    	cmp    $0x80116a54,%edx
8010405c:	74 3a                	je     80104098 <exit+0x118>
    if(p->parent == curproc){
8010405e:	39 5a 14             	cmp    %ebx,0x14(%edx)
80104061:	75 ed                	jne    80104050 <exit+0xd0>
      if(p->state == ZOMBIE)
80104063:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80104067:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
8010406a:	75 e4                	jne    80104050 <exit+0xd0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010406c:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80104071:	eb 11                	jmp    80104084 <exit+0x104>
80104073:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104077:	90                   	nop
80104078:	05 b4 00 00 00       	add    $0xb4,%eax
8010407d:	3d 54 6a 11 80       	cmp    $0x80116a54,%eax
80104082:	74 cc                	je     80104050 <exit+0xd0>
    if(p->state == SLEEPING && p->chan == chan)
80104084:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104088:	75 ee                	jne    80104078 <exit+0xf8>
8010408a:	3b 48 20             	cmp    0x20(%eax),%ecx
8010408d:	75 e9                	jne    80104078 <exit+0xf8>
      p->state = RUNNABLE;
8010408f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104096:	eb e0                	jmp    80104078 <exit+0xf8>
  curproc->etime = ticks; //endtime for a process
80104098:	a1 a0 72 11 80       	mov    0x801172a0,%eax
  curproc->state = ZOMBIE;
8010409d:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  curproc->cur_q=-1;
801040a4:	c7 83 9c 00 00 00 ff 	movl   $0xffffffff,0x9c(%ebx)
801040ab:	ff ff ff 
  curproc->etime = ticks; //endtime for a process
801040ae:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  sched();
801040b4:	e8 07 fe ff ff       	call   80103ec0 <sched>
  panic("zombie exit");
801040b9:	83 ec 0c             	sub    $0xc,%esp
801040bc:	68 c8 7e 10 80       	push   $0x80107ec8
801040c1:	e8 ca c2 ff ff       	call   80100390 <panic>
    panic("init exiting");
801040c6:	83 ec 0c             	sub    $0xc,%esp
801040c9:	68 bb 7e 10 80       	push   $0x80107ebb
801040ce:	e8 bd c2 ff ff       	call   80100390 <panic>
801040d3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801040e0 <yield>:
{
801040e0:	f3 0f 1e fb          	endbr32 
801040e4:	55                   	push   %ebp
801040e5:	89 e5                	mov    %esp,%ebp
801040e7:	53                   	push   %ebx
801040e8:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801040eb:	68 20 3d 11 80       	push   $0x80113d20
801040f0:	e8 9b 0b 00 00       	call   80104c90 <acquire>
  pushcli();
801040f5:	e8 96 0a 00 00       	call   80104b90 <pushcli>
  c = mycpu();
801040fa:	e8 71 f8 ff ff       	call   80103970 <mycpu>
  p = c->proc;
801040ff:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104105:	e8 d6 0a 00 00       	call   80104be0 <popcli>
  myproc()->state = RUNNABLE;
8010410a:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80104111:	e8 aa fd ff ff       	call   80103ec0 <sched>
  release(&ptable.lock);
80104116:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
8010411d:	e8 2e 0c 00 00       	call   80104d50 <release>
}
80104122:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104125:	83 c4 10             	add    $0x10,%esp
80104128:	c9                   	leave  
80104129:	c3                   	ret    
8010412a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104130 <set_priority>:
{
80104130:	f3 0f 1e fb          	endbr32 
80104134:	55                   	push   %ebp
80104135:	89 e5                	mov    %esp,%ebp
80104137:	56                   	push   %esi
80104138:	8b 75 08             	mov    0x8(%ebp),%esi
8010413b:	53                   	push   %ebx
8010413c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  if(new_priority<0 || new_priority>100 || pid<0)
8010413f:	83 fe 64             	cmp    $0x64,%esi
80104142:	77 7c                	ja     801041c0 <set_priority+0x90>
80104144:	85 db                	test   %ebx,%ebx
80104146:	78 78                	js     801041c0 <set_priority+0x90>
  acquire(&ptable.lock);
80104148:	83 ec 0c             	sub    $0xc,%esp
8010414b:	68 20 3d 11 80       	push   $0x80113d20
80104150:	e8 3b 0b 00 00       	call   80104c90 <acquire>
80104155:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104158:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
8010415d:	eb 0d                	jmp    8010416c <set_priority+0x3c>
8010415f:	90                   	nop
80104160:	05 b4 00 00 00       	add    $0xb4,%eax
80104165:	3d 54 6a 11 80       	cmp    $0x80116a54,%eax
8010416a:	74 44                	je     801041b0 <set_priority+0x80>
    if(p->pid==pid)
8010416c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010416f:	75 ef                	jne    80104160 <set_priority+0x30>
  release(&ptable.lock);
80104171:	83 ec 0c             	sub    $0xc,%esp
  int old_priority=p->priority;
80104174:	8b 98 8c 00 00 00    	mov    0x8c(%eax),%ebx
  p->priority = new_priority;
8010417a:	89 b0 8c 00 00 00    	mov    %esi,0x8c(%eax)
  release(&ptable.lock);
80104180:	68 20 3d 11 80       	push   $0x80113d20
80104185:	e8 c6 0b 00 00       	call   80104d50 <release>
  if(new_priority <  old_priority) //if oldpriority is greater then we have to again schedule 
8010418a:	83 c4 10             	add    $0x10,%esp
8010418d:	39 de                	cmp    %ebx,%esi
8010418f:	7c 0f                	jl     801041a0 <set_priority+0x70>
}
80104191:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104194:	89 d8                	mov    %ebx,%eax
80104196:	5b                   	pop    %ebx
80104197:	5e                   	pop    %esi
80104198:	5d                   	pop    %ebp
80104199:	c3                   	ret    
8010419a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    yield();
801041a0:	e8 3b ff ff ff       	call   801040e0 <yield>
}
801041a5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801041a8:	89 d8                	mov    %ebx,%eax
801041aa:	5b                   	pop    %ebx
801041ab:	5e                   	pop    %esi
801041ac:	5d                   	pop    %ebp
801041ad:	c3                   	ret    
801041ae:	66 90                	xchg   %ax,%ax
    release(&ptable.lock);
801041b0:	83 ec 0c             	sub    $0xc,%esp
801041b3:	68 20 3d 11 80       	push   $0x80113d20
801041b8:	e8 93 0b 00 00       	call   80104d50 <release>
    return -1;
801041bd:	83 c4 10             	add    $0x10,%esp
801041c0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801041c5:	eb ca                	jmp    80104191 <set_priority+0x61>
801041c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041ce:	66 90                	xchg   %ax,%ax

801041d0 <sleep>:
{
801041d0:	f3 0f 1e fb          	endbr32 
801041d4:	55                   	push   %ebp
801041d5:	89 e5                	mov    %esp,%ebp
801041d7:	57                   	push   %edi
801041d8:	56                   	push   %esi
801041d9:	53                   	push   %ebx
801041da:	83 ec 0c             	sub    $0xc,%esp
801041dd:	8b 7d 08             	mov    0x8(%ebp),%edi
801041e0:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
801041e3:	e8 a8 09 00 00       	call   80104b90 <pushcli>
  c = mycpu();
801041e8:	e8 83 f7 ff ff       	call   80103970 <mycpu>
  p = c->proc;
801041ed:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801041f3:	e8 e8 09 00 00       	call   80104be0 <popcli>
  if(p == 0)
801041f8:	85 db                	test   %ebx,%ebx
801041fa:	0f 84 83 00 00 00    	je     80104283 <sleep+0xb3>
  if(lk == 0)
80104200:	85 f6                	test   %esi,%esi
80104202:	74 72                	je     80104276 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104204:	81 fe 20 3d 11 80    	cmp    $0x80113d20,%esi
8010420a:	74 4c                	je     80104258 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
8010420c:	83 ec 0c             	sub    $0xc,%esp
8010420f:	68 20 3d 11 80       	push   $0x80113d20
80104214:	e8 77 0a 00 00       	call   80104c90 <acquire>
    release(lk);
80104219:	89 34 24             	mov    %esi,(%esp)
8010421c:	e8 2f 0b 00 00       	call   80104d50 <release>
  p->chan = chan;
80104221:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104224:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
8010422b:	e8 90 fc ff ff       	call   80103ec0 <sched>
  p->chan = 0;
80104230:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104237:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
8010423e:	e8 0d 0b 00 00       	call   80104d50 <release>
    acquire(lk);
80104243:	89 75 08             	mov    %esi,0x8(%ebp)
80104246:	83 c4 10             	add    $0x10,%esp
}
80104249:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010424c:	5b                   	pop    %ebx
8010424d:	5e                   	pop    %esi
8010424e:	5f                   	pop    %edi
8010424f:	5d                   	pop    %ebp
    acquire(lk);
80104250:	e9 3b 0a 00 00       	jmp    80104c90 <acquire>
80104255:	8d 76 00             	lea    0x0(%esi),%esi
  p->chan = chan;
80104258:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010425b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104262:	e8 59 fc ff ff       	call   80103ec0 <sched>
  p->chan = 0;
80104267:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010426e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104271:	5b                   	pop    %ebx
80104272:	5e                   	pop    %esi
80104273:	5f                   	pop    %edi
80104274:	5d                   	pop    %ebp
80104275:	c3                   	ret    
    panic("sleep without lk");
80104276:	83 ec 0c             	sub    $0xc,%esp
80104279:	68 da 7e 10 80       	push   $0x80107eda
8010427e:	e8 0d c1 ff ff       	call   80100390 <panic>
    panic("sleep");
80104283:	83 ec 0c             	sub    $0xc,%esp
80104286:	68 d4 7e 10 80       	push   $0x80107ed4
8010428b:	e8 00 c1 ff ff       	call   80100390 <panic>

80104290 <wait>:
{
80104290:	f3 0f 1e fb          	endbr32 
80104294:	55                   	push   %ebp
80104295:	89 e5                	mov    %esp,%ebp
80104297:	56                   	push   %esi
80104298:	53                   	push   %ebx
  pushcli();
80104299:	e8 f2 08 00 00       	call   80104b90 <pushcli>
  c = mycpu();
8010429e:	e8 cd f6 ff ff       	call   80103970 <mycpu>
  p = c->proc;
801042a3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801042a9:	e8 32 09 00 00       	call   80104be0 <popcli>
  acquire(&ptable.lock);
801042ae:	83 ec 0c             	sub    $0xc,%esp
801042b1:	68 20 3d 11 80       	push   $0x80113d20
801042b6:	e8 d5 09 00 00       	call   80104c90 <acquire>
801042bb:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801042be:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042c0:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
801042c5:	eb 17                	jmp    801042de <wait+0x4e>
801042c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042ce:	66 90                	xchg   %ax,%ax
801042d0:	81 c3 b4 00 00 00    	add    $0xb4,%ebx
801042d6:	81 fb 54 6a 11 80    	cmp    $0x80116a54,%ebx
801042dc:	74 1e                	je     801042fc <wait+0x6c>
      if(p->parent != curproc)
801042de:	39 73 14             	cmp    %esi,0x14(%ebx)
801042e1:	75 ed                	jne    801042d0 <wait+0x40>
      if(p->state == ZOMBIE){
801042e3:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801042e7:	74 37                	je     80104320 <wait+0x90>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042e9:	81 c3 b4 00 00 00    	add    $0xb4,%ebx
      havekids = 1;
801042ef:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042f4:	81 fb 54 6a 11 80    	cmp    $0x80116a54,%ebx
801042fa:	75 e2                	jne    801042de <wait+0x4e>
    if(!havekids || curproc->killed){
801042fc:	85 c0                	test   %eax,%eax
801042fe:	74 76                	je     80104376 <wait+0xe6>
80104300:	8b 46 24             	mov    0x24(%esi),%eax
80104303:	85 c0                	test   %eax,%eax
80104305:	75 6f                	jne    80104376 <wait+0xe6>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104307:	83 ec 08             	sub    $0x8,%esp
8010430a:	68 20 3d 11 80       	push   $0x80113d20
8010430f:	56                   	push   %esi
80104310:	e8 bb fe ff ff       	call   801041d0 <sleep>
    havekids = 0;
80104315:	83 c4 10             	add    $0x10,%esp
80104318:	eb a4                	jmp    801042be <wait+0x2e>
8010431a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
80104320:	83 ec 0c             	sub    $0xc,%esp
80104323:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
80104326:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104329:	e8 52 e1 ff ff       	call   80102480 <kfree>
        freevm(p->pgdir);
8010432e:	5a                   	pop    %edx
8010432f:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
80104332:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104339:	e8 b2 32 00 00       	call   801075f0 <freevm>
        release(&ptable.lock);
8010433e:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
        p->pid = 0;
80104345:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
8010434c:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80104353:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104357:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
8010435e:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104365:	e8 e6 09 00 00       	call   80104d50 <release>
        return pid;
8010436a:	83 c4 10             	add    $0x10,%esp
}
8010436d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104370:	89 f0                	mov    %esi,%eax
80104372:	5b                   	pop    %ebx
80104373:	5e                   	pop    %esi
80104374:	5d                   	pop    %ebp
80104375:	c3                   	ret    
      release(&ptable.lock);
80104376:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104379:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010437e:	68 20 3d 11 80       	push   $0x80113d20
80104383:	e8 c8 09 00 00       	call   80104d50 <release>
      return -1;
80104388:	83 c4 10             	add    $0x10,%esp
8010438b:	eb e0                	jmp    8010436d <wait+0xdd>
8010438d:	8d 76 00             	lea    0x0(%esi),%esi

80104390 <waitx>:
{
80104390:	f3 0f 1e fb          	endbr32 
80104394:	55                   	push   %ebp
80104395:	89 e5                	mov    %esp,%ebp
80104397:	56                   	push   %esi
80104398:	53                   	push   %ebx
  pushcli();
80104399:	e8 f2 07 00 00       	call   80104b90 <pushcli>
  c = mycpu();
8010439e:	e8 cd f5 ff ff       	call   80103970 <mycpu>
  p = c->proc;
801043a3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801043a9:	e8 32 08 00 00       	call   80104be0 <popcli>
  acquire(&ptable.lock);
801043ae:	83 ec 0c             	sub    $0xc,%esp
801043b1:	68 20 3d 11 80       	push   $0x80113d20
801043b6:	e8 d5 08 00 00       	call   80104c90 <acquire>
801043bb:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801043be:	31 c0                	xor    %eax,%eax
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043c0:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
801043c5:	eb 17                	jmp    801043de <waitx+0x4e>
801043c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043ce:	66 90                	xchg   %ax,%ax
801043d0:	81 c3 b4 00 00 00    	add    $0xb4,%ebx
801043d6:	81 fb 54 6a 11 80    	cmp    $0x80116a54,%ebx
801043dc:	74 1e                	je     801043fc <waitx+0x6c>
      if (p->parent != curproc)
801043de:	39 73 14             	cmp    %esi,0x14(%ebx)
801043e1:	75 ed                	jne    801043d0 <waitx+0x40>
      if (p->state == ZOMBIE)
801043e3:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801043e7:	74 3f                	je     80104428 <waitx+0x98>
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043e9:	81 c3 b4 00 00 00    	add    $0xb4,%ebx
      havekids = 1;
801043ef:	b8 01 00 00 00       	mov    $0x1,%eax
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043f4:	81 fb 54 6a 11 80    	cmp    $0x80116a54,%ebx
801043fa:	75 e2                	jne    801043de <waitx+0x4e>
    if (!havekids || curproc->killed)
801043fc:	85 c0                	test   %eax,%eax
801043fe:	0f 84 9f 00 00 00    	je     801044a3 <waitx+0x113>
80104404:	8b 46 24             	mov    0x24(%esi),%eax
80104407:	85 c0                	test   %eax,%eax
80104409:	0f 85 94 00 00 00    	jne    801044a3 <waitx+0x113>
    sleep(curproc, &ptable.lock); //DOC: wait-sleep
8010440f:	83 ec 08             	sub    $0x8,%esp
80104412:	68 20 3d 11 80       	push   $0x80113d20
80104417:	56                   	push   %esi
80104418:	e8 b3 fd ff ff       	call   801041d0 <sleep>
    havekids = 0;
8010441d:	83 c4 10             	add    $0x10,%esp
80104420:	eb 9c                	jmp    801043be <waitx+0x2e>
80104422:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        *wtime=p->etime - p->ctime - p->iotime - p->rtime;  
80104428:	8b 55 08             	mov    0x8(%ebp),%edx
8010442b:	8b 83 84 00 00 00    	mov    0x84(%ebx),%eax
        kfree(p->kstack);
80104431:	83 ec 0c             	sub    $0xc,%esp
        *wtime=p->etime - p->ctime - p->iotime - p->rtime;  
80104434:	2b 43 7c             	sub    0x7c(%ebx),%eax
80104437:	2b 83 88 00 00 00    	sub    0x88(%ebx),%eax
8010443d:	2b 83 80 00 00 00    	sub    0x80(%ebx),%eax
80104443:	89 02                	mov    %eax,(%edx)
        *rtime=p->rtime;
80104445:	8b 45 0c             	mov    0xc(%ebp),%eax
80104448:	8b 93 80 00 00 00    	mov    0x80(%ebx),%edx
8010444e:	89 10                	mov    %edx,(%eax)
        pid = p->pid;
80104450:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104453:	ff 73 08             	pushl  0x8(%ebx)
80104456:	e8 25 e0 ff ff       	call   80102480 <kfree>
        freevm(p->pgdir);
8010445b:	5a                   	pop    %edx
8010445c:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
8010445f:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104466:	e8 85 31 00 00       	call   801075f0 <freevm>
        release(&ptable.lock);
8010446b:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
        p->pid = 0;
80104472:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104479:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80104480:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104484:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
8010448b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104492:	e8 b9 08 00 00       	call   80104d50 <release>
        return pid;
80104497:	83 c4 10             	add    $0x10,%esp
}
8010449a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010449d:	89 f0                	mov    %esi,%eax
8010449f:	5b                   	pop    %ebx
801044a0:	5e                   	pop    %esi
801044a1:	5d                   	pop    %ebp
801044a2:	c3                   	ret    
      release(&ptable.lock);
801044a3:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801044a6:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
801044ab:	68 20 3d 11 80       	push   $0x80113d20
801044b0:	e8 9b 08 00 00       	call   80104d50 <release>
      return -1;
801044b5:	83 c4 10             	add    $0x10,%esp
801044b8:	eb e0                	jmp    8010449a <waitx+0x10a>
801044ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801044c0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801044c0:	f3 0f 1e fb          	endbr32 
801044c4:	55                   	push   %ebp
801044c5:	89 e5                	mov    %esp,%ebp
801044c7:	53                   	push   %ebx
801044c8:	83 ec 10             	sub    $0x10,%esp
801044cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801044ce:	68 20 3d 11 80       	push   $0x80113d20
801044d3:	e8 b8 07 00 00       	call   80104c90 <acquire>
801044d8:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801044db:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
801044e0:	eb 12                	jmp    801044f4 <wakeup+0x34>
801044e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801044e8:	05 b4 00 00 00       	add    $0xb4,%eax
801044ed:	3d 54 6a 11 80       	cmp    $0x80116a54,%eax
801044f2:	74 1e                	je     80104512 <wakeup+0x52>
    if(p->state == SLEEPING && p->chan == chan)
801044f4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801044f8:	75 ee                	jne    801044e8 <wakeup+0x28>
801044fa:	3b 58 20             	cmp    0x20(%eax),%ebx
801044fd:	75 e9                	jne    801044e8 <wakeup+0x28>
      p->state = RUNNABLE;
801044ff:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104506:	05 b4 00 00 00       	add    $0xb4,%eax
8010450b:	3d 54 6a 11 80       	cmp    $0x80116a54,%eax
80104510:	75 e2                	jne    801044f4 <wakeup+0x34>
  wakeup1(chan);
  release(&ptable.lock);
80104512:	c7 45 08 20 3d 11 80 	movl   $0x80113d20,0x8(%ebp)
}
80104519:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010451c:	c9                   	leave  
  release(&ptable.lock);
8010451d:	e9 2e 08 00 00       	jmp    80104d50 <release>
80104522:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104529:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104530 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104530:	f3 0f 1e fb          	endbr32 
80104534:	55                   	push   %ebp
80104535:	89 e5                	mov    %esp,%ebp
80104537:	53                   	push   %ebx
80104538:	83 ec 10             	sub    $0x10,%esp
8010453b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010453e:	68 20 3d 11 80       	push   $0x80113d20
80104543:	e8 48 07 00 00       	call   80104c90 <acquire>
80104548:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010454b:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80104550:	eb 12                	jmp    80104564 <kill+0x34>
80104552:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104558:	05 b4 00 00 00       	add    $0xb4,%eax
8010455d:	3d 54 6a 11 80       	cmp    $0x80116a54,%eax
80104562:	74 34                	je     80104598 <kill+0x68>
    if(p->pid == pid){
80104564:	39 58 10             	cmp    %ebx,0x10(%eax)
80104567:	75 ef                	jne    80104558 <kill+0x28>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104569:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
8010456d:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
80104574:	75 07                	jne    8010457d <kill+0x4d>
        p->state = RUNNABLE;
80104576:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
8010457d:	83 ec 0c             	sub    $0xc,%esp
80104580:	68 20 3d 11 80       	push   $0x80113d20
80104585:	e8 c6 07 00 00       	call   80104d50 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
8010458a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
8010458d:	83 c4 10             	add    $0x10,%esp
80104590:	31 c0                	xor    %eax,%eax
}
80104592:	c9                   	leave  
80104593:	c3                   	ret    
80104594:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104598:	83 ec 0c             	sub    $0xc,%esp
8010459b:	68 20 3d 11 80       	push   $0x80113d20
801045a0:	e8 ab 07 00 00       	call   80104d50 <release>
}
801045a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801045a8:	83 c4 10             	add    $0x10,%esp
801045ab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801045b0:	c9                   	leave  
801045b1:	c3                   	ret    
801045b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801045c0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801045c0:	f3 0f 1e fb          	endbr32 
801045c4:	55                   	push   %ebp
801045c5:	89 e5                	mov    %esp,%ebp
801045c7:	57                   	push   %edi
801045c8:	56                   	push   %esi
801045c9:	8d 75 e8             	lea    -0x18(%ebp),%esi
801045cc:	53                   	push   %ebx
801045cd:	bb c0 3d 11 80       	mov    $0x80113dc0,%ebx
801045d2:	83 ec 3c             	sub    $0x3c,%esp
801045d5:	eb 2b                	jmp    80104602 <procdump+0x42>
801045d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045de:	66 90                	xchg   %ax,%ax
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801045e0:	83 ec 0c             	sub    $0xc,%esp
801045e3:	68 a3 82 10 80       	push   $0x801082a3
801045e8:	e8 c3 c0 ff ff       	call   801006b0 <cprintf>
801045ed:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801045f0:	81 c3 b4 00 00 00    	add    $0xb4,%ebx
801045f6:	81 fb c0 6a 11 80    	cmp    $0x80116ac0,%ebx
801045fc:	0f 84 8e 00 00 00    	je     80104690 <procdump+0xd0>
    if(p->state == UNUSED)
80104602:	8b 43 a0             	mov    -0x60(%ebx),%eax
80104605:	85 c0                	test   %eax,%eax
80104607:	74 e7                	je     801045f0 <procdump+0x30>
      state = "???";
80104609:	ba eb 7e 10 80       	mov    $0x80107eeb,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010460e:	83 f8 05             	cmp    $0x5,%eax
80104611:	77 11                	ja     80104624 <procdump+0x64>
80104613:	8b 14 85 7c 7f 10 80 	mov    -0x7fef8084(,%eax,4),%edx
      state = "???";
8010461a:	b8 eb 7e 10 80       	mov    $0x80107eeb,%eax
8010461f:	85 d2                	test   %edx,%edx
80104621:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104624:	53                   	push   %ebx
80104625:	52                   	push   %edx
80104626:	ff 73 a4             	pushl  -0x5c(%ebx)
80104629:	68 ef 7e 10 80       	push   $0x80107eef
8010462e:	e8 7d c0 ff ff       	call   801006b0 <cprintf>
    if(p->state == SLEEPING){
80104633:	83 c4 10             	add    $0x10,%esp
80104636:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
8010463a:	75 a4                	jne    801045e0 <procdump+0x20>
      getcallerpcs((uint*)p->context->ebp+2, pc);
8010463c:	83 ec 08             	sub    $0x8,%esp
8010463f:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104642:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104645:	50                   	push   %eax
80104646:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104649:	8b 40 0c             	mov    0xc(%eax),%eax
8010464c:	83 c0 08             	add    $0x8,%eax
8010464f:	50                   	push   %eax
80104650:	e8 db 04 00 00       	call   80104b30 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104655:	83 c4 10             	add    $0x10,%esp
80104658:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010465f:	90                   	nop
80104660:	8b 17                	mov    (%edi),%edx
80104662:	85 d2                	test   %edx,%edx
80104664:	0f 84 76 ff ff ff    	je     801045e0 <procdump+0x20>
        cprintf(" %p", pc[i]);
8010466a:	83 ec 08             	sub    $0x8,%esp
8010466d:	83 c7 04             	add    $0x4,%edi
80104670:	52                   	push   %edx
80104671:	68 41 79 10 80       	push   $0x80107941
80104676:	e8 35 c0 ff ff       	call   801006b0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
8010467b:	83 c4 10             	add    $0x10,%esp
8010467e:	39 fe                	cmp    %edi,%esi
80104680:	75 de                	jne    80104660 <procdump+0xa0>
80104682:	e9 59 ff ff ff       	jmp    801045e0 <procdump+0x20>
80104687:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010468e:	66 90                	xchg   %ax,%ax
  }
}
80104690:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104693:	5b                   	pop    %ebx
80104694:	5e                   	pop    %esi
80104695:	5f                   	pop    %edi
80104696:	5d                   	pop    %ebp
80104697:	c3                   	ret    
80104698:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010469f:	90                   	nop

801046a0 <my_strcpy>:
char *my_strcpy(char *destination, char *source)
{
801046a0:	f3 0f 1e fb          	endbr32 
801046a4:	55                   	push   %ebp
801046a5:	89 e5                	mov    %esp,%ebp
801046a7:	53                   	push   %ebx
801046a8:	8b 55 0c             	mov    0xc(%ebp),%edx
801046ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *start = destination;

  while (*source != '\0')
801046ae:	0f b6 02             	movzbl (%edx),%eax
801046b1:	89 d9                	mov    %ebx,%ecx
801046b3:	84 c0                	test   %al,%al
801046b5:	74 18                	je     801046cf <my_strcpy+0x2f>
801046b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046be:	66 90                	xchg   %ax,%ax
  {
    *destination = *source;
    destination++;
    source++;
801046c0:	83 c2 01             	add    $0x1,%edx
    *destination = *source;
801046c3:	88 01                	mov    %al,(%ecx)
    destination++;
801046c5:	83 c1 01             	add    $0x1,%ecx
  while (*source != '\0')
801046c8:	0f b6 02             	movzbl (%edx),%eax
801046cb:	84 c0                	test   %al,%al
801046cd:	75 f1                	jne    801046c0 <my_strcpy+0x20>
  }

  *destination = '\0'; // add '\0' at the end
801046cf:	c6 01 00             	movb   $0x0,(%ecx)
  return start;
}
801046d2:	89 d8                	mov    %ebx,%eax
801046d4:	5b                   	pop    %ebx
801046d5:	5d                   	pop    %ebp
801046d6:	c3                   	ret    
801046d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046de:	66 90                	xchg   %ax,%ax

801046e0 <ps>:
int ps(struct procstatus *arr)
{
801046e0:	f3 0f 1e fb          	endbr32 
801046e4:	55                   	push   %ebp
801046e5:	89 e5                	mov    %esp,%ebp
801046e7:	57                   	push   %edi
801046e8:	56                   	push   %esi
801046e9:	53                   	push   %ebx
801046ea:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  int i = 0;
  acquire(&ptable.lock);
801046ed:	68 20 3d 11 80       	push   $0x80113d20
801046f2:	e8 99 05 00 00       	call   80104c90 <acquire>
  int i = 0;
801046f7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  acquire(&ptable.lock);
801046fe:	83 c4 10             	add    $0x10,%esp
  
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104701:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80104706:	eb 7c                	jmp    80104784 <ps+0xa4>
80104708:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010470f:	90                   	nop
    }
    if (p->state == UNUSED)
    {
      my_strcpy(arr[i].state, "UNUSED");
    }
    if (p->state == EMBRYO)
80104710:	83 f9 01             	cmp    $0x1,%ecx
80104713:	0f 84 01 01 00 00    	je     8010481a <ps+0x13a>
    {
      my_strcpy(arr[i].state, "EMBRYO");
    }
    arr[i].n_run=p->n_run;
80104719:	8b 88 98 00 00 00    	mov    0x98(%eax),%ecx
    arr[i].q[0]=p->q[0];
    arr[i].q[1] = p->q[1];
    arr[i].q[2] = p->q[2];
    arr[i].q[3] = p->q[3];
    arr[i].q[4] = p->q[4];
    i++;
8010471f:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
    arr[i].n_run=p->n_run;
80104723:	89 4a 20             	mov    %ecx,0x20(%edx)
    arr[i].cur_q=p->cur_q;
80104726:	8b 88 9c 00 00 00    	mov    0x9c(%eax),%ecx
8010472c:	89 4a 24             	mov    %ecx,0x24(%edx)
    arr[i].rtime=p->rtime;
8010472f:	8b 88 80 00 00 00    	mov    0x80(%eax),%ecx
80104735:	89 4a 14             	mov    %ecx,0x14(%edx)
    arr[i].w_timeforrunning=ticks - p->lastexecuted;
80104738:	8b 0d a0 72 11 80    	mov    0x801172a0,%ecx
8010473e:	2b 88 94 00 00 00    	sub    0x94(%eax),%ecx
80104744:	89 4a 1c             	mov    %ecx,0x1c(%edx)
    arr[i].q[0]=p->q[0];
80104747:	8b 88 a0 00 00 00    	mov    0xa0(%eax),%ecx
8010474d:	89 4a 28             	mov    %ecx,0x28(%edx)
    arr[i].q[1] = p->q[1];
80104750:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
80104756:	89 4a 2c             	mov    %ecx,0x2c(%edx)
    arr[i].q[2] = p->q[2];
80104759:	8b 88 a8 00 00 00    	mov    0xa8(%eax),%ecx
8010475f:	89 4a 30             	mov    %ecx,0x30(%edx)
    arr[i].q[3] = p->q[3];
80104762:	8b 88 ac 00 00 00    	mov    0xac(%eax),%ecx
80104768:	89 4a 34             	mov    %ecx,0x34(%edx)
    arr[i].q[4] = p->q[4];
8010476b:	8b 88 b0 00 00 00    	mov    0xb0(%eax),%ecx
80104771:	89 4a 38             	mov    %ecx,0x38(%edx)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104774:	05 b4 00 00 00       	add    $0xb4,%eax
80104779:	3d 54 6a 11 80       	cmp    $0x80116a54,%eax
8010477e:	0f 84 2a 02 00 00    	je     801049ae <ps+0x2ce>
    if(p->state==UNUSED)
80104784:	8b 50 0c             	mov    0xc(%eax),%edx
80104787:	85 d2                	test   %edx,%edx
80104789:	74 e9                	je     80104774 <ps+0x94>
    arr[i].pid=p->pid;
8010478b:	8b 48 10             	mov    0x10(%eax),%ecx
8010478e:	6b 55 e0 3c          	imul   $0x3c,-0x20(%ebp),%edx
80104792:	03 55 08             	add    0x8(%ebp),%edx
80104795:	89 0a                	mov    %ecx,(%edx)
    arr[i].priority=p->priority;
80104797:	8b 88 8c 00 00 00    	mov    0x8c(%eax),%ecx
8010479d:	89 4a 18             	mov    %ecx,0x18(%edx)
    if(p->state==RUNNABLE)
801047a0:	8b 48 0c             	mov    0xc(%eax),%ecx
801047a3:	83 f9 03             	cmp    $0x3,%ecx
801047a6:	0f 84 b4 01 00 00    	je     80104960 <ps+0x280>
    if (p->state == RUNNING)
801047ac:	83 f9 04             	cmp    $0x4,%ecx
801047af:	0f 84 5b 01 00 00    	je     80104910 <ps+0x230>
    if (p->state == SLEEPING)
801047b5:	83 f9 02             	cmp    $0x2,%ecx
801047b8:	0f 84 02 01 00 00    	je     801048c0 <ps+0x1e0>
    if (p->state == ZOMBIE)
801047be:	83 f9 05             	cmp    $0x5,%ecx
801047c1:	0f 84 a1 00 00 00    	je     80104868 <ps+0x188>
    if (p->state == UNUSED)
801047c7:	85 c9                	test   %ecx,%ecx
801047c9:	0f 85 41 ff ff ff    	jne    80104710 <ps+0x30>
      my_strcpy(arr[i].state, "UNUSED");
801047cf:	bb 19 7f 10 80       	mov    $0x80107f19,%ebx
  while (*source != '\0')
801047d4:	bf 55 00 00 00       	mov    $0x55,%edi
      my_strcpy(arr[i].state, "UNUSED");
801047d9:	8d 4a 04             	lea    0x4(%edx),%ecx
801047dc:	be 4e 00 00 00       	mov    $0x4e,%esi
  while (*source != '\0')
801047e1:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801047e4:	89 fb                	mov    %edi,%ebx
801047e6:	89 c7                	mov    %eax,%edi
801047e8:	89 f0                	mov    %esi,%eax
801047ea:	89 d6                	mov    %edx,%esi
801047ec:	89 da                	mov    %ebx,%edx
801047ee:	eb 06                	jmp    801047f6 <ps+0x116>
801047f0:	89 c2                	mov    %eax,%edx
801047f2:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
    source++;
801047f6:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
    destination++;
801047fa:	83 c1 01             	add    $0x1,%ecx
    source++;
801047fd:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    *destination = *source;
80104800:	88 51 ff             	mov    %dl,-0x1(%ecx)
  while (*source != '\0')
80104803:	84 c0                	test   %al,%al
80104805:	75 e9                	jne    801047f0 <ps+0x110>
  *destination = '\0'; // add '\0' at the end
80104807:	c6 01 00             	movb   $0x0,(%ecx)
8010480a:	8b 4f 0c             	mov    0xc(%edi),%ecx
8010480d:	89 f2                	mov    %esi,%edx
8010480f:	89 f8                	mov    %edi,%eax
    if (p->state == EMBRYO)
80104811:	83 f9 01             	cmp    $0x1,%ecx
80104814:	0f 85 ff fe ff ff    	jne    80104719 <ps+0x39>
      my_strcpy(arr[i].state, "EMBRYO");
8010481a:	bb 20 7f 10 80       	mov    $0x80107f20,%ebx
  while (*source != '\0')
8010481f:	bf 45 00 00 00       	mov    $0x45,%edi
      my_strcpy(arr[i].state, "EMBRYO");
80104824:	8d 4a 04             	lea    0x4(%edx),%ecx
80104827:	be 4d 00 00 00       	mov    $0x4d,%esi
  while (*source != '\0')
8010482c:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
8010482f:	89 fb                	mov    %edi,%ebx
80104831:	89 c7                	mov    %eax,%edi
80104833:	89 f0                	mov    %esi,%eax
80104835:	89 d6                	mov    %edx,%esi
80104837:	89 da                	mov    %ebx,%edx
80104839:	eb 0b                	jmp    80104846 <ps+0x166>
8010483b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010483f:	90                   	nop
80104840:	89 c2                	mov    %eax,%edx
80104842:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
    source++;
80104846:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
    destination++;
8010484a:	83 c1 01             	add    $0x1,%ecx
    source++;
8010484d:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    *destination = *source;
80104850:	88 51 ff             	mov    %dl,-0x1(%ecx)
  while (*source != '\0')
80104853:	84 c0                	test   %al,%al
80104855:	75 e9                	jne    80104840 <ps+0x160>
  *destination = '\0'; // add '\0' at the end
80104857:	c6 01 00             	movb   $0x0,(%ecx)
8010485a:	89 f2                	mov    %esi,%edx
8010485c:	89 f8                	mov    %edi,%eax
  return start;
8010485e:	e9 b6 fe ff ff       	jmp    80104719 <ps+0x39>
80104863:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104867:	90                   	nop
      my_strcpy(arr[i].state, "ZOMBIE");
80104868:	bb 12 7f 10 80       	mov    $0x80107f12,%ebx
  while (*source != '\0')
8010486d:	bf 5a 00 00 00       	mov    $0x5a,%edi
      my_strcpy(arr[i].state, "ZOMBIE");
80104872:	8d 4a 04             	lea    0x4(%edx),%ecx
80104875:	be 4f 00 00 00       	mov    $0x4f,%esi
  while (*source != '\0')
8010487a:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
8010487d:	89 fb                	mov    %edi,%ebx
8010487f:	89 c7                	mov    %eax,%edi
80104881:	89 f0                	mov    %esi,%eax
80104883:	89 d6                	mov    %edx,%esi
80104885:	89 da                	mov    %ebx,%edx
80104887:	eb 0d                	jmp    80104896 <ps+0x1b6>
80104889:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104890:	89 c2                	mov    %eax,%edx
80104892:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
    source++;
80104896:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
    destination++;
8010489a:	83 c1 01             	add    $0x1,%ecx
    source++;
8010489d:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    *destination = *source;
801048a0:	88 51 ff             	mov    %dl,-0x1(%ecx)
  while (*source != '\0')
801048a3:	84 c0                	test   %al,%al
801048a5:	75 e9                	jne    80104890 <ps+0x1b0>
  *destination = '\0'; // add '\0' at the end
801048a7:	c6 01 00             	movb   $0x0,(%ecx)
801048aa:	89 f2                	mov    %esi,%edx
801048ac:	8b 4f 0c             	mov    0xc(%edi),%ecx
801048af:	89 f8                	mov    %edi,%eax
  return start;
801048b1:	e9 11 ff ff ff       	jmp    801047c7 <ps+0xe7>
801048b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048bd:	8d 76 00             	lea    0x0(%esi),%esi
      my_strcpy(arr[i].state, "SLEEPING");
801048c0:	bb 09 7f 10 80       	mov    $0x80107f09,%ebx
  while (*source != '\0')
801048c5:	bf 53 00 00 00       	mov    $0x53,%edi
      my_strcpy(arr[i].state, "SLEEPING");
801048ca:	8d 4a 04             	lea    0x4(%edx),%ecx
801048cd:	be 4c 00 00 00       	mov    $0x4c,%esi
  while (*source != '\0')
801048d2:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801048d5:	89 fb                	mov    %edi,%ebx
801048d7:	89 c7                	mov    %eax,%edi
801048d9:	89 f0                	mov    %esi,%eax
801048db:	89 d6                	mov    %edx,%esi
801048dd:	89 da                	mov    %ebx,%edx
801048df:	eb 0d                	jmp    801048ee <ps+0x20e>
801048e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048e8:	89 c2                	mov    %eax,%edx
801048ea:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
    source++;
801048ee:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
    destination++;
801048f2:	83 c1 01             	add    $0x1,%ecx
    source++;
801048f5:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    *destination = *source;
801048f8:	88 51 ff             	mov    %dl,-0x1(%ecx)
  while (*source != '\0')
801048fb:	84 c0                	test   %al,%al
801048fd:	75 e9                	jne    801048e8 <ps+0x208>
  *destination = '\0'; // add '\0' at the end
801048ff:	c6 01 00             	movb   $0x0,(%ecx)
80104902:	89 f2                	mov    %esi,%edx
80104904:	8b 4f 0c             	mov    0xc(%edi),%ecx
80104907:	89 f8                	mov    %edi,%eax
  return start;
80104909:	e9 b0 fe ff ff       	jmp    801047be <ps+0xde>
8010490e:	66 90                	xchg   %ax,%ax
      my_strcpy(arr[i].state, "RUNNING");
80104910:	bb 01 7f 10 80       	mov    $0x80107f01,%ebx
  while (*source != '\0')
80104915:	bf 52 00 00 00       	mov    $0x52,%edi
      my_strcpy(arr[i].state, "RUNNING");
8010491a:	8d 4a 04             	lea    0x4(%edx),%ecx
8010491d:	be 55 00 00 00       	mov    $0x55,%esi
  while (*source != '\0')
80104922:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80104925:	89 fb                	mov    %edi,%ebx
80104927:	89 c7                	mov    %eax,%edi
80104929:	89 f0                	mov    %esi,%eax
8010492b:	89 d6                	mov    %edx,%esi
8010492d:	89 da                	mov    %ebx,%edx
8010492f:	eb 0d                	jmp    8010493e <ps+0x25e>
80104931:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104938:	89 c2                	mov    %eax,%edx
8010493a:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
    source++;
8010493e:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
    destination++;
80104942:	83 c1 01             	add    $0x1,%ecx
    source++;
80104945:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    *destination = *source;
80104948:	88 51 ff             	mov    %dl,-0x1(%ecx)
  while (*source != '\0')
8010494b:	84 c0                	test   %al,%al
8010494d:	75 e9                	jne    80104938 <ps+0x258>
  *destination = '\0'; // add '\0' at the end
8010494f:	c6 01 00             	movb   $0x0,(%ecx)
80104952:	89 f2                	mov    %esi,%edx
80104954:	8b 4f 0c             	mov    0xc(%edi),%ecx
80104957:	89 f8                	mov    %edi,%eax
  return start;
80104959:	e9 57 fe ff ff       	jmp    801047b5 <ps+0xd5>
8010495e:	66 90                	xchg   %ax,%ax
      my_strcpy(arr[i].state,"RUNNABLE");
80104960:	bb f8 7e 10 80       	mov    $0x80107ef8,%ebx
  while (*source != '\0')
80104965:	bf 52 00 00 00       	mov    $0x52,%edi
      my_strcpy(arr[i].state,"RUNNABLE");
8010496a:	8d 4a 04             	lea    0x4(%edx),%ecx
8010496d:	be 55 00 00 00       	mov    $0x55,%esi
  while (*source != '\0')
80104972:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80104975:	89 fb                	mov    %edi,%ebx
80104977:	89 c7                	mov    %eax,%edi
80104979:	89 f0                	mov    %esi,%eax
8010497b:	89 d6                	mov    %edx,%esi
8010497d:	89 da                	mov    %ebx,%edx
8010497f:	eb 0d                	jmp    8010498e <ps+0x2ae>
80104981:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104988:	89 c2                	mov    %eax,%edx
8010498a:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
    source++;
8010498e:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
    destination++;
80104992:	83 c1 01             	add    $0x1,%ecx
    source++;
80104995:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    *destination = *source;
80104998:	88 51 ff             	mov    %dl,-0x1(%ecx)
  while (*source != '\0')
8010499b:	84 c0                	test   %al,%al
8010499d:	75 e9                	jne    80104988 <ps+0x2a8>
  *destination = '\0'; // add '\0' at the end
8010499f:	c6 01 00             	movb   $0x0,(%ecx)
801049a2:	89 f2                	mov    %esi,%edx
801049a4:	8b 4f 0c             	mov    0xc(%edi),%ecx
801049a7:	89 f8                	mov    %edi,%eax
  return start;
801049a9:	e9 fe fd ff ff       	jmp    801047ac <ps+0xcc>
  }
  release(&ptable.lock);
801049ae:	83 ec 0c             	sub    $0xc,%esp
801049b1:	68 20 3d 11 80       	push   $0x80113d20
801049b6:	e8 95 03 00 00       	call   80104d50 <release>
  return i;
}
801049bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
801049be:	8d 65 f4             	lea    -0xc(%ebp),%esp
801049c1:	5b                   	pop    %ebx
801049c2:	5e                   	pop    %esi
801049c3:	5f                   	pop    %edi
801049c4:	5d                   	pop    %ebp
801049c5:	c3                   	ret    
801049c6:	66 90                	xchg   %ax,%ax
801049c8:	66 90                	xchg   %ax,%ax
801049ca:	66 90                	xchg   %ax,%ax
801049cc:	66 90                	xchg   %ax,%ax
801049ce:	66 90                	xchg   %ax,%ax

801049d0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801049d0:	f3 0f 1e fb          	endbr32 
801049d4:	55                   	push   %ebp
801049d5:	89 e5                	mov    %esp,%ebp
801049d7:	53                   	push   %ebx
801049d8:	83 ec 0c             	sub    $0xc,%esp
801049db:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801049de:	68 94 7f 10 80       	push   $0x80107f94
801049e3:	8d 43 04             	lea    0x4(%ebx),%eax
801049e6:	50                   	push   %eax
801049e7:	e8 24 01 00 00       	call   80104b10 <initlock>
  lk->name = name;
801049ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801049ef:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801049f5:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801049f8:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801049ff:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104a02:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a05:	c9                   	leave  
80104a06:	c3                   	ret    
80104a07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a0e:	66 90                	xchg   %ax,%ax

80104a10 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104a10:	f3 0f 1e fb          	endbr32 
80104a14:	55                   	push   %ebp
80104a15:	89 e5                	mov    %esp,%ebp
80104a17:	56                   	push   %esi
80104a18:	53                   	push   %ebx
80104a19:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104a1c:	8d 73 04             	lea    0x4(%ebx),%esi
80104a1f:	83 ec 0c             	sub    $0xc,%esp
80104a22:	56                   	push   %esi
80104a23:	e8 68 02 00 00       	call   80104c90 <acquire>
  while (lk->locked) {
80104a28:	8b 13                	mov    (%ebx),%edx
80104a2a:	83 c4 10             	add    $0x10,%esp
80104a2d:	85 d2                	test   %edx,%edx
80104a2f:	74 1a                	je     80104a4b <acquiresleep+0x3b>
80104a31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80104a38:	83 ec 08             	sub    $0x8,%esp
80104a3b:	56                   	push   %esi
80104a3c:	53                   	push   %ebx
80104a3d:	e8 8e f7 ff ff       	call   801041d0 <sleep>
  while (lk->locked) {
80104a42:	8b 03                	mov    (%ebx),%eax
80104a44:	83 c4 10             	add    $0x10,%esp
80104a47:	85 c0                	test   %eax,%eax
80104a49:	75 ed                	jne    80104a38 <acquiresleep+0x28>
  }
  lk->locked = 1;
80104a4b:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104a51:	e8 aa ef ff ff       	call   80103a00 <myproc>
80104a56:	8b 40 10             	mov    0x10(%eax),%eax
80104a59:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104a5c:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104a5f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a62:	5b                   	pop    %ebx
80104a63:	5e                   	pop    %esi
80104a64:	5d                   	pop    %ebp
  release(&lk->lk);
80104a65:	e9 e6 02 00 00       	jmp    80104d50 <release>
80104a6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104a70 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104a70:	f3 0f 1e fb          	endbr32 
80104a74:	55                   	push   %ebp
80104a75:	89 e5                	mov    %esp,%ebp
80104a77:	56                   	push   %esi
80104a78:	53                   	push   %ebx
80104a79:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104a7c:	8d 73 04             	lea    0x4(%ebx),%esi
80104a7f:	83 ec 0c             	sub    $0xc,%esp
80104a82:	56                   	push   %esi
80104a83:	e8 08 02 00 00       	call   80104c90 <acquire>
  lk->locked = 0;
80104a88:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104a8e:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104a95:	89 1c 24             	mov    %ebx,(%esp)
80104a98:	e8 23 fa ff ff       	call   801044c0 <wakeup>
  release(&lk->lk);
80104a9d:	89 75 08             	mov    %esi,0x8(%ebp)
80104aa0:	83 c4 10             	add    $0x10,%esp
}
80104aa3:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104aa6:	5b                   	pop    %ebx
80104aa7:	5e                   	pop    %esi
80104aa8:	5d                   	pop    %ebp
  release(&lk->lk);
80104aa9:	e9 a2 02 00 00       	jmp    80104d50 <release>
80104aae:	66 90                	xchg   %ax,%ax

80104ab0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104ab0:	f3 0f 1e fb          	endbr32 
80104ab4:	55                   	push   %ebp
80104ab5:	89 e5                	mov    %esp,%ebp
80104ab7:	57                   	push   %edi
80104ab8:	31 ff                	xor    %edi,%edi
80104aba:	56                   	push   %esi
80104abb:	53                   	push   %ebx
80104abc:	83 ec 18             	sub    $0x18,%esp
80104abf:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104ac2:	8d 73 04             	lea    0x4(%ebx),%esi
80104ac5:	56                   	push   %esi
80104ac6:	e8 c5 01 00 00       	call   80104c90 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104acb:	8b 03                	mov    (%ebx),%eax
80104acd:	83 c4 10             	add    $0x10,%esp
80104ad0:	85 c0                	test   %eax,%eax
80104ad2:	75 1c                	jne    80104af0 <holdingsleep+0x40>
  release(&lk->lk);
80104ad4:	83 ec 0c             	sub    $0xc,%esp
80104ad7:	56                   	push   %esi
80104ad8:	e8 73 02 00 00       	call   80104d50 <release>
  return r;
}
80104add:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ae0:	89 f8                	mov    %edi,%eax
80104ae2:	5b                   	pop    %ebx
80104ae3:	5e                   	pop    %esi
80104ae4:	5f                   	pop    %edi
80104ae5:	5d                   	pop    %ebp
80104ae6:	c3                   	ret    
80104ae7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104aee:	66 90                	xchg   %ax,%ax
  r = lk->locked && (lk->pid == myproc()->pid);
80104af0:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104af3:	e8 08 ef ff ff       	call   80103a00 <myproc>
80104af8:	39 58 10             	cmp    %ebx,0x10(%eax)
80104afb:	0f 94 c0             	sete   %al
80104afe:	0f b6 c0             	movzbl %al,%eax
80104b01:	89 c7                	mov    %eax,%edi
80104b03:	eb cf                	jmp    80104ad4 <holdingsleep+0x24>
80104b05:	66 90                	xchg   %ax,%ax
80104b07:	66 90                	xchg   %ax,%ax
80104b09:	66 90                	xchg   %ax,%ax
80104b0b:	66 90                	xchg   %ax,%ax
80104b0d:	66 90                	xchg   %ax,%ax
80104b0f:	90                   	nop

80104b10 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104b10:	f3 0f 1e fb          	endbr32 
80104b14:	55                   	push   %ebp
80104b15:	89 e5                	mov    %esp,%ebp
80104b17:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104b1a:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104b1d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104b23:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104b26:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104b2d:	5d                   	pop    %ebp
80104b2e:	c3                   	ret    
80104b2f:	90                   	nop

80104b30 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104b30:	f3 0f 1e fb          	endbr32 
80104b34:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104b35:	31 d2                	xor    %edx,%edx
{
80104b37:	89 e5                	mov    %esp,%ebp
80104b39:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104b3a:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104b3d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104b40:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80104b43:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b47:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104b48:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104b4e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104b54:	77 1a                	ja     80104b70 <getcallerpcs+0x40>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104b56:	8b 58 04             	mov    0x4(%eax),%ebx
80104b59:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104b5c:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104b5f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104b61:	83 fa 0a             	cmp    $0xa,%edx
80104b64:	75 e2                	jne    80104b48 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104b66:	5b                   	pop    %ebx
80104b67:	5d                   	pop    %ebp
80104b68:	c3                   	ret    
80104b69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104b70:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104b73:	8d 51 28             	lea    0x28(%ecx),%edx
80104b76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b7d:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80104b80:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104b86:	83 c0 04             	add    $0x4,%eax
80104b89:	39 d0                	cmp    %edx,%eax
80104b8b:	75 f3                	jne    80104b80 <getcallerpcs+0x50>
}
80104b8d:	5b                   	pop    %ebx
80104b8e:	5d                   	pop    %ebp
80104b8f:	c3                   	ret    

80104b90 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104b90:	f3 0f 1e fb          	endbr32 
80104b94:	55                   	push   %ebp
80104b95:	89 e5                	mov    %esp,%ebp
80104b97:	53                   	push   %ebx
80104b98:	83 ec 04             	sub    $0x4,%esp
80104b9b:	9c                   	pushf  
80104b9c:	5b                   	pop    %ebx
  asm volatile("cli");
80104b9d:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104b9e:	e8 cd ed ff ff       	call   80103970 <mycpu>
80104ba3:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104ba9:	85 c0                	test   %eax,%eax
80104bab:	74 13                	je     80104bc0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104bad:	e8 be ed ff ff       	call   80103970 <mycpu>
80104bb2:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104bb9:	83 c4 04             	add    $0x4,%esp
80104bbc:	5b                   	pop    %ebx
80104bbd:	5d                   	pop    %ebp
80104bbe:	c3                   	ret    
80104bbf:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
80104bc0:	e8 ab ed ff ff       	call   80103970 <mycpu>
80104bc5:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104bcb:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104bd1:	eb da                	jmp    80104bad <pushcli+0x1d>
80104bd3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104be0 <popcli>:

void
popcli(void)
{
80104be0:	f3 0f 1e fb          	endbr32 
80104be4:	55                   	push   %ebp
80104be5:	89 e5                	mov    %esp,%ebp
80104be7:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104bea:	9c                   	pushf  
80104beb:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104bec:	f6 c4 02             	test   $0x2,%ah
80104bef:	75 31                	jne    80104c22 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104bf1:	e8 7a ed ff ff       	call   80103970 <mycpu>
80104bf6:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104bfd:	78 30                	js     80104c2f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104bff:	e8 6c ed ff ff       	call   80103970 <mycpu>
80104c04:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104c0a:	85 d2                	test   %edx,%edx
80104c0c:	74 02                	je     80104c10 <popcli+0x30>
    sti();
}
80104c0e:	c9                   	leave  
80104c0f:	c3                   	ret    
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104c10:	e8 5b ed ff ff       	call   80103970 <mycpu>
80104c15:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104c1b:	85 c0                	test   %eax,%eax
80104c1d:	74 ef                	je     80104c0e <popcli+0x2e>
  asm volatile("sti");
80104c1f:	fb                   	sti    
}
80104c20:	c9                   	leave  
80104c21:	c3                   	ret    
    panic("popcli - interruptible");
80104c22:	83 ec 0c             	sub    $0xc,%esp
80104c25:	68 9f 7f 10 80       	push   $0x80107f9f
80104c2a:	e8 61 b7 ff ff       	call   80100390 <panic>
    panic("popcli");
80104c2f:	83 ec 0c             	sub    $0xc,%esp
80104c32:	68 b6 7f 10 80       	push   $0x80107fb6
80104c37:	e8 54 b7 ff ff       	call   80100390 <panic>
80104c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104c40 <holding>:
{
80104c40:	f3 0f 1e fb          	endbr32 
80104c44:	55                   	push   %ebp
80104c45:	89 e5                	mov    %esp,%ebp
80104c47:	56                   	push   %esi
80104c48:	53                   	push   %ebx
80104c49:	8b 75 08             	mov    0x8(%ebp),%esi
80104c4c:	31 db                	xor    %ebx,%ebx
  pushcli();
80104c4e:	e8 3d ff ff ff       	call   80104b90 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104c53:	8b 06                	mov    (%esi),%eax
80104c55:	85 c0                	test   %eax,%eax
80104c57:	75 0f                	jne    80104c68 <holding+0x28>
  popcli();
80104c59:	e8 82 ff ff ff       	call   80104be0 <popcli>
}
80104c5e:	89 d8                	mov    %ebx,%eax
80104c60:	5b                   	pop    %ebx
80104c61:	5e                   	pop    %esi
80104c62:	5d                   	pop    %ebp
80104c63:	c3                   	ret    
80104c64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  r = lock->locked && lock->cpu == mycpu();
80104c68:	8b 5e 08             	mov    0x8(%esi),%ebx
80104c6b:	e8 00 ed ff ff       	call   80103970 <mycpu>
80104c70:	39 c3                	cmp    %eax,%ebx
80104c72:	0f 94 c3             	sete   %bl
  popcli();
80104c75:	e8 66 ff ff ff       	call   80104be0 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104c7a:	0f b6 db             	movzbl %bl,%ebx
}
80104c7d:	89 d8                	mov    %ebx,%eax
80104c7f:	5b                   	pop    %ebx
80104c80:	5e                   	pop    %esi
80104c81:	5d                   	pop    %ebp
80104c82:	c3                   	ret    
80104c83:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104c90 <acquire>:
{
80104c90:	f3 0f 1e fb          	endbr32 
80104c94:	55                   	push   %ebp
80104c95:	89 e5                	mov    %esp,%ebp
80104c97:	56                   	push   %esi
80104c98:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104c99:	e8 f2 fe ff ff       	call   80104b90 <pushcli>
  if(holding(lk))
80104c9e:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104ca1:	83 ec 0c             	sub    $0xc,%esp
80104ca4:	53                   	push   %ebx
80104ca5:	e8 96 ff ff ff       	call   80104c40 <holding>
80104caa:	83 c4 10             	add    $0x10,%esp
80104cad:	85 c0                	test   %eax,%eax
80104caf:	0f 85 7f 00 00 00    	jne    80104d34 <acquire+0xa4>
80104cb5:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104cb7:	ba 01 00 00 00       	mov    $0x1,%edx
80104cbc:	eb 05                	jmp    80104cc3 <acquire+0x33>
80104cbe:	66 90                	xchg   %ax,%ax
80104cc0:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104cc3:	89 d0                	mov    %edx,%eax
80104cc5:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104cc8:	85 c0                	test   %eax,%eax
80104cca:	75 f4                	jne    80104cc0 <acquire+0x30>
  __sync_synchronize();
80104ccc:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104cd1:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104cd4:	e8 97 ec ff ff       	call   80103970 <mycpu>
80104cd9:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80104cdc:	89 e8                	mov    %ebp,%eax
80104cde:	66 90                	xchg   %ax,%ax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104ce0:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80104ce6:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
80104cec:	77 22                	ja     80104d10 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104cee:	8b 50 04             	mov    0x4(%eax),%edx
80104cf1:	89 54 b3 0c          	mov    %edx,0xc(%ebx,%esi,4)
  for(i = 0; i < 10; i++){
80104cf5:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80104cf8:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104cfa:	83 fe 0a             	cmp    $0xa,%esi
80104cfd:	75 e1                	jne    80104ce0 <acquire+0x50>
}
80104cff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d02:	5b                   	pop    %ebx
80104d03:	5e                   	pop    %esi
80104d04:	5d                   	pop    %ebp
80104d05:	c3                   	ret    
80104d06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d0d:	8d 76 00             	lea    0x0(%esi),%esi
  for(; i < 10; i++)
80104d10:	8d 44 b3 0c          	lea    0xc(%ebx,%esi,4),%eax
80104d14:	83 c3 34             	add    $0x34,%ebx
80104d17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d1e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104d20:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104d26:	83 c0 04             	add    $0x4,%eax
80104d29:	39 d8                	cmp    %ebx,%eax
80104d2b:	75 f3                	jne    80104d20 <acquire+0x90>
}
80104d2d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d30:	5b                   	pop    %ebx
80104d31:	5e                   	pop    %esi
80104d32:	5d                   	pop    %ebp
80104d33:	c3                   	ret    
    panic("acquire");
80104d34:	83 ec 0c             	sub    $0xc,%esp
80104d37:	68 bd 7f 10 80       	push   $0x80107fbd
80104d3c:	e8 4f b6 ff ff       	call   80100390 <panic>
80104d41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d4f:	90                   	nop

80104d50 <release>:
{
80104d50:	f3 0f 1e fb          	endbr32 
80104d54:	55                   	push   %ebp
80104d55:	89 e5                	mov    %esp,%ebp
80104d57:	53                   	push   %ebx
80104d58:	83 ec 10             	sub    $0x10,%esp
80104d5b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80104d5e:	53                   	push   %ebx
80104d5f:	e8 dc fe ff ff       	call   80104c40 <holding>
80104d64:	83 c4 10             	add    $0x10,%esp
80104d67:	85 c0                	test   %eax,%eax
80104d69:	74 22                	je     80104d8d <release+0x3d>
  lk->pcs[0] = 0;
80104d6b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104d72:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104d79:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104d7e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104d84:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d87:	c9                   	leave  
  popcli();
80104d88:	e9 53 fe ff ff       	jmp    80104be0 <popcli>
    panic("release");
80104d8d:	83 ec 0c             	sub    $0xc,%esp
80104d90:	68 c5 7f 10 80       	push   $0x80107fc5
80104d95:	e8 f6 b5 ff ff       	call   80100390 <panic>
80104d9a:	66 90                	xchg   %ax,%ax
80104d9c:	66 90                	xchg   %ax,%ax
80104d9e:	66 90                	xchg   %ax,%ax

80104da0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104da0:	f3 0f 1e fb          	endbr32 
80104da4:	55                   	push   %ebp
80104da5:	89 e5                	mov    %esp,%ebp
80104da7:	57                   	push   %edi
80104da8:	8b 55 08             	mov    0x8(%ebp),%edx
80104dab:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104dae:	53                   	push   %ebx
80104daf:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80104db2:	89 d7                	mov    %edx,%edi
80104db4:	09 cf                	or     %ecx,%edi
80104db6:	83 e7 03             	and    $0x3,%edi
80104db9:	75 25                	jne    80104de0 <memset+0x40>
    c &= 0xFF;
80104dbb:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104dbe:	c1 e0 18             	shl    $0x18,%eax
80104dc1:	89 fb                	mov    %edi,%ebx
80104dc3:	c1 e9 02             	shr    $0x2,%ecx
80104dc6:	c1 e3 10             	shl    $0x10,%ebx
80104dc9:	09 d8                	or     %ebx,%eax
80104dcb:	09 f8                	or     %edi,%eax
80104dcd:	c1 e7 08             	shl    $0x8,%edi
80104dd0:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104dd2:	89 d7                	mov    %edx,%edi
80104dd4:	fc                   	cld    
80104dd5:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104dd7:	5b                   	pop    %ebx
80104dd8:	89 d0                	mov    %edx,%eax
80104dda:	5f                   	pop    %edi
80104ddb:	5d                   	pop    %ebp
80104ddc:	c3                   	ret    
80104ddd:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("cld; rep stosb" :
80104de0:	89 d7                	mov    %edx,%edi
80104de2:	fc                   	cld    
80104de3:	f3 aa                	rep stos %al,%es:(%edi)
80104de5:	5b                   	pop    %ebx
80104de6:	89 d0                	mov    %edx,%eax
80104de8:	5f                   	pop    %edi
80104de9:	5d                   	pop    %ebp
80104dea:	c3                   	ret    
80104deb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104def:	90                   	nop

80104df0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104df0:	f3 0f 1e fb          	endbr32 
80104df4:	55                   	push   %ebp
80104df5:	89 e5                	mov    %esp,%ebp
80104df7:	56                   	push   %esi
80104df8:	8b 75 10             	mov    0x10(%ebp),%esi
80104dfb:	8b 55 08             	mov    0x8(%ebp),%edx
80104dfe:	53                   	push   %ebx
80104dff:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104e02:	85 f6                	test   %esi,%esi
80104e04:	74 2a                	je     80104e30 <memcmp+0x40>
80104e06:	01 c6                	add    %eax,%esi
80104e08:	eb 10                	jmp    80104e1a <memcmp+0x2a>
80104e0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104e10:	83 c0 01             	add    $0x1,%eax
80104e13:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104e16:	39 f0                	cmp    %esi,%eax
80104e18:	74 16                	je     80104e30 <memcmp+0x40>
    if(*s1 != *s2)
80104e1a:	0f b6 0a             	movzbl (%edx),%ecx
80104e1d:	0f b6 18             	movzbl (%eax),%ebx
80104e20:	38 d9                	cmp    %bl,%cl
80104e22:	74 ec                	je     80104e10 <memcmp+0x20>
      return *s1 - *s2;
80104e24:	0f b6 c1             	movzbl %cl,%eax
80104e27:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104e29:	5b                   	pop    %ebx
80104e2a:	5e                   	pop    %esi
80104e2b:	5d                   	pop    %ebp
80104e2c:	c3                   	ret    
80104e2d:	8d 76 00             	lea    0x0(%esi),%esi
80104e30:	5b                   	pop    %ebx
  return 0;
80104e31:	31 c0                	xor    %eax,%eax
}
80104e33:	5e                   	pop    %esi
80104e34:	5d                   	pop    %ebp
80104e35:	c3                   	ret    
80104e36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e3d:	8d 76 00             	lea    0x0(%esi),%esi

80104e40 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104e40:	f3 0f 1e fb          	endbr32 
80104e44:	55                   	push   %ebp
80104e45:	89 e5                	mov    %esp,%ebp
80104e47:	57                   	push   %edi
80104e48:	8b 55 08             	mov    0x8(%ebp),%edx
80104e4b:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104e4e:	56                   	push   %esi
80104e4f:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104e52:	39 d6                	cmp    %edx,%esi
80104e54:	73 2a                	jae    80104e80 <memmove+0x40>
80104e56:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104e59:	39 fa                	cmp    %edi,%edx
80104e5b:	73 23                	jae    80104e80 <memmove+0x40>
80104e5d:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80104e60:	85 c9                	test   %ecx,%ecx
80104e62:	74 13                	je     80104e77 <memmove+0x37>
80104e64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80104e68:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104e6c:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104e6f:	83 e8 01             	sub    $0x1,%eax
80104e72:	83 f8 ff             	cmp    $0xffffffff,%eax
80104e75:	75 f1                	jne    80104e68 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104e77:	5e                   	pop    %esi
80104e78:	89 d0                	mov    %edx,%eax
80104e7a:	5f                   	pop    %edi
80104e7b:	5d                   	pop    %ebp
80104e7c:	c3                   	ret    
80104e7d:	8d 76 00             	lea    0x0(%esi),%esi
    while(n-- > 0)
80104e80:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80104e83:	89 d7                	mov    %edx,%edi
80104e85:	85 c9                	test   %ecx,%ecx
80104e87:	74 ee                	je     80104e77 <memmove+0x37>
80104e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104e90:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104e91:	39 f0                	cmp    %esi,%eax
80104e93:	75 fb                	jne    80104e90 <memmove+0x50>
}
80104e95:	5e                   	pop    %esi
80104e96:	89 d0                	mov    %edx,%eax
80104e98:	5f                   	pop    %edi
80104e99:	5d                   	pop    %ebp
80104e9a:	c3                   	ret    
80104e9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e9f:	90                   	nop

80104ea0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104ea0:	f3 0f 1e fb          	endbr32 
  return memmove(dst, src, n);
80104ea4:	eb 9a                	jmp    80104e40 <memmove>
80104ea6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ead:	8d 76 00             	lea    0x0(%esi),%esi

80104eb0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104eb0:	f3 0f 1e fb          	endbr32 
80104eb4:	55                   	push   %ebp
80104eb5:	89 e5                	mov    %esp,%ebp
80104eb7:	56                   	push   %esi
80104eb8:	8b 75 10             	mov    0x10(%ebp),%esi
80104ebb:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104ebe:	53                   	push   %ebx
80104ebf:	8b 45 0c             	mov    0xc(%ebp),%eax
  while(n > 0 && *p && *p == *q)
80104ec2:	85 f6                	test   %esi,%esi
80104ec4:	74 32                	je     80104ef8 <strncmp+0x48>
80104ec6:	01 c6                	add    %eax,%esi
80104ec8:	eb 14                	jmp    80104ede <strncmp+0x2e>
80104eca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104ed0:	38 da                	cmp    %bl,%dl
80104ed2:	75 14                	jne    80104ee8 <strncmp+0x38>
    n--, p++, q++;
80104ed4:	83 c0 01             	add    $0x1,%eax
80104ed7:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104eda:	39 f0                	cmp    %esi,%eax
80104edc:	74 1a                	je     80104ef8 <strncmp+0x48>
80104ede:	0f b6 11             	movzbl (%ecx),%edx
80104ee1:	0f b6 18             	movzbl (%eax),%ebx
80104ee4:	84 d2                	test   %dl,%dl
80104ee6:	75 e8                	jne    80104ed0 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104ee8:	0f b6 c2             	movzbl %dl,%eax
80104eeb:	29 d8                	sub    %ebx,%eax
}
80104eed:	5b                   	pop    %ebx
80104eee:	5e                   	pop    %esi
80104eef:	5d                   	pop    %ebp
80104ef0:	c3                   	ret    
80104ef1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ef8:	5b                   	pop    %ebx
    return 0;
80104ef9:	31 c0                	xor    %eax,%eax
}
80104efb:	5e                   	pop    %esi
80104efc:	5d                   	pop    %ebp
80104efd:	c3                   	ret    
80104efe:	66 90                	xchg   %ax,%ax

80104f00 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104f00:	f3 0f 1e fb          	endbr32 
80104f04:	55                   	push   %ebp
80104f05:	89 e5                	mov    %esp,%ebp
80104f07:	57                   	push   %edi
80104f08:	56                   	push   %esi
80104f09:	8b 75 08             	mov    0x8(%ebp),%esi
80104f0c:	53                   	push   %ebx
80104f0d:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104f10:	89 f2                	mov    %esi,%edx
80104f12:	eb 1b                	jmp    80104f2f <strncpy+0x2f>
80104f14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f18:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104f1c:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104f1f:	83 c2 01             	add    $0x1,%edx
80104f22:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
80104f26:	89 f9                	mov    %edi,%ecx
80104f28:	88 4a ff             	mov    %cl,-0x1(%edx)
80104f2b:	84 c9                	test   %cl,%cl
80104f2d:	74 09                	je     80104f38 <strncpy+0x38>
80104f2f:	89 c3                	mov    %eax,%ebx
80104f31:	83 e8 01             	sub    $0x1,%eax
80104f34:	85 db                	test   %ebx,%ebx
80104f36:	7f e0                	jg     80104f18 <strncpy+0x18>
    ;
  while(n-- > 0)
80104f38:	89 d1                	mov    %edx,%ecx
80104f3a:	85 c0                	test   %eax,%eax
80104f3c:	7e 15                	jle    80104f53 <strncpy+0x53>
80104f3e:	66 90                	xchg   %ax,%ax
    *s++ = 0;
80104f40:	83 c1 01             	add    $0x1,%ecx
80104f43:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  while(n-- > 0)
80104f47:	89 c8                	mov    %ecx,%eax
80104f49:	f7 d0                	not    %eax
80104f4b:	01 d0                	add    %edx,%eax
80104f4d:	01 d8                	add    %ebx,%eax
80104f4f:	85 c0                	test   %eax,%eax
80104f51:	7f ed                	jg     80104f40 <strncpy+0x40>
  return os;
}
80104f53:	5b                   	pop    %ebx
80104f54:	89 f0                	mov    %esi,%eax
80104f56:	5e                   	pop    %esi
80104f57:	5f                   	pop    %edi
80104f58:	5d                   	pop    %ebp
80104f59:	c3                   	ret    
80104f5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104f60 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104f60:	f3 0f 1e fb          	endbr32 
80104f64:	55                   	push   %ebp
80104f65:	89 e5                	mov    %esp,%ebp
80104f67:	56                   	push   %esi
80104f68:	8b 55 10             	mov    0x10(%ebp),%edx
80104f6b:	8b 75 08             	mov    0x8(%ebp),%esi
80104f6e:	53                   	push   %ebx
80104f6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104f72:	85 d2                	test   %edx,%edx
80104f74:	7e 21                	jle    80104f97 <safestrcpy+0x37>
80104f76:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104f7a:	89 f2                	mov    %esi,%edx
80104f7c:	eb 12                	jmp    80104f90 <safestrcpy+0x30>
80104f7e:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104f80:	0f b6 08             	movzbl (%eax),%ecx
80104f83:	83 c0 01             	add    $0x1,%eax
80104f86:	83 c2 01             	add    $0x1,%edx
80104f89:	88 4a ff             	mov    %cl,-0x1(%edx)
80104f8c:	84 c9                	test   %cl,%cl
80104f8e:	74 04                	je     80104f94 <safestrcpy+0x34>
80104f90:	39 d8                	cmp    %ebx,%eax
80104f92:	75 ec                	jne    80104f80 <safestrcpy+0x20>
    ;
  *s = 0;
80104f94:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104f97:	89 f0                	mov    %esi,%eax
80104f99:	5b                   	pop    %ebx
80104f9a:	5e                   	pop    %esi
80104f9b:	5d                   	pop    %ebp
80104f9c:	c3                   	ret    
80104f9d:	8d 76 00             	lea    0x0(%esi),%esi

80104fa0 <strlen>:

int
strlen(const char *s)
{
80104fa0:	f3 0f 1e fb          	endbr32 
80104fa4:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104fa5:	31 c0                	xor    %eax,%eax
{
80104fa7:	89 e5                	mov    %esp,%ebp
80104fa9:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104fac:	80 3a 00             	cmpb   $0x0,(%edx)
80104faf:	74 10                	je     80104fc1 <strlen+0x21>
80104fb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fb8:	83 c0 01             	add    $0x1,%eax
80104fbb:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104fbf:	75 f7                	jne    80104fb8 <strlen+0x18>
    ;
  return n;
}
80104fc1:	5d                   	pop    %ebp
80104fc2:	c3                   	ret    

80104fc3 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104fc3:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104fc7:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104fcb:	55                   	push   %ebp
  pushl %ebx
80104fcc:	53                   	push   %ebx
  pushl %esi
80104fcd:	56                   	push   %esi
  pushl %edi
80104fce:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104fcf:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104fd1:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104fd3:	5f                   	pop    %edi
  popl %esi
80104fd4:	5e                   	pop    %esi
  popl %ebx
80104fd5:	5b                   	pop    %ebx
  popl %ebp
80104fd6:	5d                   	pop    %ebp
  ret
80104fd7:	c3                   	ret    
80104fd8:	66 90                	xchg   %ax,%ax
80104fda:	66 90                	xchg   %ax,%ax
80104fdc:	66 90                	xchg   %ax,%ax
80104fde:	66 90                	xchg   %ax,%ax

80104fe0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104fe0:	f3 0f 1e fb          	endbr32 
80104fe4:	55                   	push   %ebp
80104fe5:	89 e5                	mov    %esp,%ebp
80104fe7:	53                   	push   %ebx
80104fe8:	83 ec 04             	sub    $0x4,%esp
80104feb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104fee:	e8 0d ea ff ff       	call   80103a00 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104ff3:	8b 00                	mov    (%eax),%eax
80104ff5:	39 d8                	cmp    %ebx,%eax
80104ff7:	76 17                	jbe    80105010 <fetchint+0x30>
80104ff9:	8d 53 04             	lea    0x4(%ebx),%edx
80104ffc:	39 d0                	cmp    %edx,%eax
80104ffe:	72 10                	jb     80105010 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80105000:	8b 45 0c             	mov    0xc(%ebp),%eax
80105003:	8b 13                	mov    (%ebx),%edx
80105005:	89 10                	mov    %edx,(%eax)
  return 0;
80105007:	31 c0                	xor    %eax,%eax
}
80105009:	83 c4 04             	add    $0x4,%esp
8010500c:	5b                   	pop    %ebx
8010500d:	5d                   	pop    %ebp
8010500e:	c3                   	ret    
8010500f:	90                   	nop
    return -1;
80105010:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105015:	eb f2                	jmp    80105009 <fetchint+0x29>
80105017:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010501e:	66 90                	xchg   %ax,%ax

80105020 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105020:	f3 0f 1e fb          	endbr32 
80105024:	55                   	push   %ebp
80105025:	89 e5                	mov    %esp,%ebp
80105027:	53                   	push   %ebx
80105028:	83 ec 04             	sub    $0x4,%esp
8010502b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010502e:	e8 cd e9 ff ff       	call   80103a00 <myproc>

  if(addr >= curproc->sz)
80105033:	39 18                	cmp    %ebx,(%eax)
80105035:	76 31                	jbe    80105068 <fetchstr+0x48>
    return -1;
  *pp = (char*)addr;
80105037:	8b 55 0c             	mov    0xc(%ebp),%edx
8010503a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
8010503c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010503e:	39 d3                	cmp    %edx,%ebx
80105040:	73 26                	jae    80105068 <fetchstr+0x48>
80105042:	89 d8                	mov    %ebx,%eax
80105044:	eb 11                	jmp    80105057 <fetchstr+0x37>
80105046:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010504d:	8d 76 00             	lea    0x0(%esi),%esi
80105050:	83 c0 01             	add    $0x1,%eax
80105053:	39 c2                	cmp    %eax,%edx
80105055:	76 11                	jbe    80105068 <fetchstr+0x48>
    if(*s == 0)
80105057:	80 38 00             	cmpb   $0x0,(%eax)
8010505a:	75 f4                	jne    80105050 <fetchstr+0x30>
      return s - *pp;
  }
  return -1;
}
8010505c:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
8010505f:	29 d8                	sub    %ebx,%eax
}
80105061:	5b                   	pop    %ebx
80105062:	5d                   	pop    %ebp
80105063:	c3                   	ret    
80105064:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105068:	83 c4 04             	add    $0x4,%esp
    return -1;
8010506b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105070:	5b                   	pop    %ebx
80105071:	5d                   	pop    %ebp
80105072:	c3                   	ret    
80105073:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010507a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105080 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105080:	f3 0f 1e fb          	endbr32 
80105084:	55                   	push   %ebp
80105085:	89 e5                	mov    %esp,%ebp
80105087:	56                   	push   %esi
80105088:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105089:	e8 72 e9 ff ff       	call   80103a00 <myproc>
8010508e:	8b 55 08             	mov    0x8(%ebp),%edx
80105091:	8b 40 18             	mov    0x18(%eax),%eax
80105094:	8b 40 44             	mov    0x44(%eax),%eax
80105097:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
8010509a:	e8 61 e9 ff ff       	call   80103a00 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010509f:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801050a2:	8b 00                	mov    (%eax),%eax
801050a4:	39 c6                	cmp    %eax,%esi
801050a6:	73 18                	jae    801050c0 <argint+0x40>
801050a8:	8d 53 08             	lea    0x8(%ebx),%edx
801050ab:	39 d0                	cmp    %edx,%eax
801050ad:	72 11                	jb     801050c0 <argint+0x40>
  *ip = *(int*)(addr);
801050af:	8b 45 0c             	mov    0xc(%ebp),%eax
801050b2:	8b 53 04             	mov    0x4(%ebx),%edx
801050b5:	89 10                	mov    %edx,(%eax)
  return 0;
801050b7:	31 c0                	xor    %eax,%eax
}
801050b9:	5b                   	pop    %ebx
801050ba:	5e                   	pop    %esi
801050bb:	5d                   	pop    %ebp
801050bc:	c3                   	ret    
801050bd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801050c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801050c5:	eb f2                	jmp    801050b9 <argint+0x39>
801050c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050ce:	66 90                	xchg   %ax,%ax

801050d0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801050d0:	f3 0f 1e fb          	endbr32 
801050d4:	55                   	push   %ebp
801050d5:	89 e5                	mov    %esp,%ebp
801050d7:	56                   	push   %esi
801050d8:	53                   	push   %ebx
801050d9:	83 ec 10             	sub    $0x10,%esp
801050dc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
801050df:	e8 1c e9 ff ff       	call   80103a00 <myproc>
 
  if(argint(n, &i) < 0)
801050e4:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
801050e7:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
801050e9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801050ec:	50                   	push   %eax
801050ed:	ff 75 08             	pushl  0x8(%ebp)
801050f0:	e8 8b ff ff ff       	call   80105080 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801050f5:	83 c4 10             	add    $0x10,%esp
801050f8:	85 c0                	test   %eax,%eax
801050fa:	78 24                	js     80105120 <argptr+0x50>
801050fc:	85 db                	test   %ebx,%ebx
801050fe:	78 20                	js     80105120 <argptr+0x50>
80105100:	8b 16                	mov    (%esi),%edx
80105102:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105105:	39 c2                	cmp    %eax,%edx
80105107:	76 17                	jbe    80105120 <argptr+0x50>
80105109:	01 c3                	add    %eax,%ebx
8010510b:	39 da                	cmp    %ebx,%edx
8010510d:	72 11                	jb     80105120 <argptr+0x50>
    return -1;
  *pp = (char*)i;
8010510f:	8b 55 0c             	mov    0xc(%ebp),%edx
80105112:	89 02                	mov    %eax,(%edx)
  return 0;
80105114:	31 c0                	xor    %eax,%eax
}
80105116:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105119:	5b                   	pop    %ebx
8010511a:	5e                   	pop    %esi
8010511b:	5d                   	pop    %ebp
8010511c:	c3                   	ret    
8010511d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105120:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105125:	eb ef                	jmp    80105116 <argptr+0x46>
80105127:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010512e:	66 90                	xchg   %ax,%ax

80105130 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105130:	f3 0f 1e fb          	endbr32 
80105134:	55                   	push   %ebp
80105135:	89 e5                	mov    %esp,%ebp
80105137:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
8010513a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010513d:	50                   	push   %eax
8010513e:	ff 75 08             	pushl  0x8(%ebp)
80105141:	e8 3a ff ff ff       	call   80105080 <argint>
80105146:	83 c4 10             	add    $0x10,%esp
80105149:	85 c0                	test   %eax,%eax
8010514b:	78 13                	js     80105160 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
8010514d:	83 ec 08             	sub    $0x8,%esp
80105150:	ff 75 0c             	pushl  0xc(%ebp)
80105153:	ff 75 f4             	pushl  -0xc(%ebp)
80105156:	e8 c5 fe ff ff       	call   80105020 <fetchstr>
8010515b:	83 c4 10             	add    $0x10,%esp
}
8010515e:	c9                   	leave  
8010515f:	c3                   	ret    
80105160:	c9                   	leave  
    return -1;
80105161:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105166:	c3                   	ret    
80105167:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010516e:	66 90                	xchg   %ax,%ax

80105170 <syscall>:
[SYS_ps]      sys_ps,
};

void
syscall(void)
{
80105170:	f3 0f 1e fb          	endbr32 
80105174:	55                   	push   %ebp
80105175:	89 e5                	mov    %esp,%ebp
80105177:	53                   	push   %ebx
80105178:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
8010517b:	e8 80 e8 ff ff       	call   80103a00 <myproc>
80105180:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80105182:	8b 40 18             	mov    0x18(%eax),%eax
80105185:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105188:	8d 50 ff             	lea    -0x1(%eax),%edx
8010518b:	83 fa 17             	cmp    $0x17,%edx
8010518e:	77 20                	ja     801051b0 <syscall+0x40>
80105190:	8b 14 85 00 80 10 80 	mov    -0x7fef8000(,%eax,4),%edx
80105197:	85 d2                	test   %edx,%edx
80105199:	74 15                	je     801051b0 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
8010519b:	ff d2                	call   *%edx
8010519d:	89 c2                	mov    %eax,%edx
8010519f:	8b 43 18             	mov    0x18(%ebx),%eax
801051a2:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
801051a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801051a8:	c9                   	leave  
801051a9:	c3                   	ret    
801051aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
801051b0:	50                   	push   %eax
            curproc->pid, curproc->name, num);
801051b1:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
801051b4:	50                   	push   %eax
801051b5:	ff 73 10             	pushl  0x10(%ebx)
801051b8:	68 cd 7f 10 80       	push   $0x80107fcd
801051bd:	e8 ee b4 ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
801051c2:	8b 43 18             	mov    0x18(%ebx),%eax
801051c5:	83 c4 10             	add    $0x10,%esp
801051c8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
801051cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801051d2:	c9                   	leave  
801051d3:	c3                   	ret    
801051d4:	66 90                	xchg   %ax,%ax
801051d6:	66 90                	xchg   %ax,%ax
801051d8:	66 90                	xchg   %ax,%ax
801051da:	66 90                	xchg   %ax,%ax
801051dc:	66 90                	xchg   %ax,%ax
801051de:	66 90                	xchg   %ax,%ax

801051e0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801051e0:	55                   	push   %ebp
801051e1:	89 e5                	mov    %esp,%ebp
801051e3:	57                   	push   %edi
801051e4:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801051e5:	8d 7d da             	lea    -0x26(%ebp),%edi
{
801051e8:	53                   	push   %ebx
801051e9:	83 ec 34             	sub    $0x34,%esp
801051ec:	89 4d d0             	mov    %ecx,-0x30(%ebp)
801051ef:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
801051f2:	57                   	push   %edi
801051f3:	50                   	push   %eax
{
801051f4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
801051f7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
801051fa:	e8 61 ce ff ff       	call   80102060 <nameiparent>
801051ff:	83 c4 10             	add    $0x10,%esp
80105202:	85 c0                	test   %eax,%eax
80105204:	0f 84 46 01 00 00    	je     80105350 <create+0x170>
    return 0;
  ilock(dp);
8010520a:	83 ec 0c             	sub    $0xc,%esp
8010520d:	89 c3                	mov    %eax,%ebx
8010520f:	50                   	push   %eax
80105210:	e8 5b c5 ff ff       	call   80101770 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80105215:	83 c4 0c             	add    $0xc,%esp
80105218:	6a 00                	push   $0x0
8010521a:	57                   	push   %edi
8010521b:	53                   	push   %ebx
8010521c:	e8 9f ca ff ff       	call   80101cc0 <dirlookup>
80105221:	83 c4 10             	add    $0x10,%esp
80105224:	89 c6                	mov    %eax,%esi
80105226:	85 c0                	test   %eax,%eax
80105228:	74 56                	je     80105280 <create+0xa0>
    iunlockput(dp);
8010522a:	83 ec 0c             	sub    $0xc,%esp
8010522d:	53                   	push   %ebx
8010522e:	e8 dd c7 ff ff       	call   80101a10 <iunlockput>
    ilock(ip);
80105233:	89 34 24             	mov    %esi,(%esp)
80105236:	e8 35 c5 ff ff       	call   80101770 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010523b:	83 c4 10             	add    $0x10,%esp
8010523e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105243:	75 1b                	jne    80105260 <create+0x80>
80105245:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
8010524a:	75 14                	jne    80105260 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010524c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010524f:	89 f0                	mov    %esi,%eax
80105251:	5b                   	pop    %ebx
80105252:	5e                   	pop    %esi
80105253:	5f                   	pop    %edi
80105254:	5d                   	pop    %ebp
80105255:	c3                   	ret    
80105256:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010525d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105260:	83 ec 0c             	sub    $0xc,%esp
80105263:	56                   	push   %esi
    return 0;
80105264:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80105266:	e8 a5 c7 ff ff       	call   80101a10 <iunlockput>
    return 0;
8010526b:	83 c4 10             	add    $0x10,%esp
}
8010526e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105271:	89 f0                	mov    %esi,%eax
80105273:	5b                   	pop    %ebx
80105274:	5e                   	pop    %esi
80105275:	5f                   	pop    %edi
80105276:	5d                   	pop    %ebp
80105277:	c3                   	ret    
80105278:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010527f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80105280:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105284:	83 ec 08             	sub    $0x8,%esp
80105287:	50                   	push   %eax
80105288:	ff 33                	pushl  (%ebx)
8010528a:	e8 61 c3 ff ff       	call   801015f0 <ialloc>
8010528f:	83 c4 10             	add    $0x10,%esp
80105292:	89 c6                	mov    %eax,%esi
80105294:	85 c0                	test   %eax,%eax
80105296:	0f 84 cd 00 00 00    	je     80105369 <create+0x189>
  ilock(ip);
8010529c:	83 ec 0c             	sub    $0xc,%esp
8010529f:	50                   	push   %eax
801052a0:	e8 cb c4 ff ff       	call   80101770 <ilock>
  ip->major = major;
801052a5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
801052a9:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
801052ad:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
801052b1:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
801052b5:	b8 01 00 00 00       	mov    $0x1,%eax
801052ba:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
801052be:	89 34 24             	mov    %esi,(%esp)
801052c1:	e8 ea c3 ff ff       	call   801016b0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
801052c6:	83 c4 10             	add    $0x10,%esp
801052c9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
801052ce:	74 30                	je     80105300 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
801052d0:	83 ec 04             	sub    $0x4,%esp
801052d3:	ff 76 04             	pushl  0x4(%esi)
801052d6:	57                   	push   %edi
801052d7:	53                   	push   %ebx
801052d8:	e8 a3 cc ff ff       	call   80101f80 <dirlink>
801052dd:	83 c4 10             	add    $0x10,%esp
801052e0:	85 c0                	test   %eax,%eax
801052e2:	78 78                	js     8010535c <create+0x17c>
  iunlockput(dp);
801052e4:	83 ec 0c             	sub    $0xc,%esp
801052e7:	53                   	push   %ebx
801052e8:	e8 23 c7 ff ff       	call   80101a10 <iunlockput>
  return ip;
801052ed:	83 c4 10             	add    $0x10,%esp
}
801052f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801052f3:	89 f0                	mov    %esi,%eax
801052f5:	5b                   	pop    %ebx
801052f6:	5e                   	pop    %esi
801052f7:	5f                   	pop    %edi
801052f8:	5d                   	pop    %ebp
801052f9:	c3                   	ret    
801052fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80105300:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80105303:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105308:	53                   	push   %ebx
80105309:	e8 a2 c3 ff ff       	call   801016b0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010530e:	83 c4 0c             	add    $0xc,%esp
80105311:	ff 76 04             	pushl  0x4(%esi)
80105314:	68 80 80 10 80       	push   $0x80108080
80105319:	56                   	push   %esi
8010531a:	e8 61 cc ff ff       	call   80101f80 <dirlink>
8010531f:	83 c4 10             	add    $0x10,%esp
80105322:	85 c0                	test   %eax,%eax
80105324:	78 18                	js     8010533e <create+0x15e>
80105326:	83 ec 04             	sub    $0x4,%esp
80105329:	ff 73 04             	pushl  0x4(%ebx)
8010532c:	68 7f 80 10 80       	push   $0x8010807f
80105331:	56                   	push   %esi
80105332:	e8 49 cc ff ff       	call   80101f80 <dirlink>
80105337:	83 c4 10             	add    $0x10,%esp
8010533a:	85 c0                	test   %eax,%eax
8010533c:	79 92                	jns    801052d0 <create+0xf0>
      panic("create dots");
8010533e:	83 ec 0c             	sub    $0xc,%esp
80105341:	68 73 80 10 80       	push   $0x80108073
80105346:	e8 45 b0 ff ff       	call   80100390 <panic>
8010534b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010534f:	90                   	nop
}
80105350:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80105353:	31 f6                	xor    %esi,%esi
}
80105355:	5b                   	pop    %ebx
80105356:	89 f0                	mov    %esi,%eax
80105358:	5e                   	pop    %esi
80105359:	5f                   	pop    %edi
8010535a:	5d                   	pop    %ebp
8010535b:	c3                   	ret    
    panic("create: dirlink");
8010535c:	83 ec 0c             	sub    $0xc,%esp
8010535f:	68 82 80 10 80       	push   $0x80108082
80105364:	e8 27 b0 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105369:	83 ec 0c             	sub    $0xc,%esp
8010536c:	68 64 80 10 80       	push   $0x80108064
80105371:	e8 1a b0 ff ff       	call   80100390 <panic>
80105376:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010537d:	8d 76 00             	lea    0x0(%esi),%esi

80105380 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80105380:	55                   	push   %ebp
80105381:	89 e5                	mov    %esp,%ebp
80105383:	56                   	push   %esi
80105384:	89 d6                	mov    %edx,%esi
80105386:	53                   	push   %ebx
80105387:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80105389:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
8010538c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010538f:	50                   	push   %eax
80105390:	6a 00                	push   $0x0
80105392:	e8 e9 fc ff ff       	call   80105080 <argint>
80105397:	83 c4 10             	add    $0x10,%esp
8010539a:	85 c0                	test   %eax,%eax
8010539c:	78 2a                	js     801053c8 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010539e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801053a2:	77 24                	ja     801053c8 <argfd.constprop.0+0x48>
801053a4:	e8 57 e6 ff ff       	call   80103a00 <myproc>
801053a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801053ac:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
801053b0:	85 c0                	test   %eax,%eax
801053b2:	74 14                	je     801053c8 <argfd.constprop.0+0x48>
  if(pfd)
801053b4:	85 db                	test   %ebx,%ebx
801053b6:	74 02                	je     801053ba <argfd.constprop.0+0x3a>
    *pfd = fd;
801053b8:	89 13                	mov    %edx,(%ebx)
    *pf = f;
801053ba:	89 06                	mov    %eax,(%esi)
  return 0;
801053bc:	31 c0                	xor    %eax,%eax
}
801053be:	8d 65 f8             	lea    -0x8(%ebp),%esp
801053c1:	5b                   	pop    %ebx
801053c2:	5e                   	pop    %esi
801053c3:	5d                   	pop    %ebp
801053c4:	c3                   	ret    
801053c5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801053c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053cd:	eb ef                	jmp    801053be <argfd.constprop.0+0x3e>
801053cf:	90                   	nop

801053d0 <sys_dup>:
{
801053d0:	f3 0f 1e fb          	endbr32 
801053d4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
801053d5:	31 c0                	xor    %eax,%eax
{
801053d7:	89 e5                	mov    %esp,%ebp
801053d9:	56                   	push   %esi
801053da:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
801053db:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
801053de:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
801053e1:	e8 9a ff ff ff       	call   80105380 <argfd.constprop.0>
801053e6:	85 c0                	test   %eax,%eax
801053e8:	78 1e                	js     80105408 <sys_dup+0x38>
  if((fd=fdalloc(f)) < 0)
801053ea:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
801053ed:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801053ef:	e8 0c e6 ff ff       	call   80103a00 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801053f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
801053f8:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801053fc:	85 d2                	test   %edx,%edx
801053fe:	74 20                	je     80105420 <sys_dup+0x50>
  for(fd = 0; fd < NOFILE; fd++){
80105400:	83 c3 01             	add    $0x1,%ebx
80105403:	83 fb 10             	cmp    $0x10,%ebx
80105406:	75 f0                	jne    801053f8 <sys_dup+0x28>
}
80105408:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
8010540b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105410:	89 d8                	mov    %ebx,%eax
80105412:	5b                   	pop    %ebx
80105413:	5e                   	pop    %esi
80105414:	5d                   	pop    %ebp
80105415:	c3                   	ret    
80105416:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010541d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80105420:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80105424:	83 ec 0c             	sub    $0xc,%esp
80105427:	ff 75 f4             	pushl  -0xc(%ebp)
8010542a:	e8 51 ba ff ff       	call   80100e80 <filedup>
  return fd;
8010542f:	83 c4 10             	add    $0x10,%esp
}
80105432:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105435:	89 d8                	mov    %ebx,%eax
80105437:	5b                   	pop    %ebx
80105438:	5e                   	pop    %esi
80105439:	5d                   	pop    %ebp
8010543a:	c3                   	ret    
8010543b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010543f:	90                   	nop

80105440 <sys_read>:
{
80105440:	f3 0f 1e fb          	endbr32 
80105444:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105445:	31 c0                	xor    %eax,%eax
{
80105447:	89 e5                	mov    %esp,%ebp
80105449:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010544c:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010544f:	e8 2c ff ff ff       	call   80105380 <argfd.constprop.0>
80105454:	85 c0                	test   %eax,%eax
80105456:	78 48                	js     801054a0 <sys_read+0x60>
80105458:	83 ec 08             	sub    $0x8,%esp
8010545b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010545e:	50                   	push   %eax
8010545f:	6a 02                	push   $0x2
80105461:	e8 1a fc ff ff       	call   80105080 <argint>
80105466:	83 c4 10             	add    $0x10,%esp
80105469:	85 c0                	test   %eax,%eax
8010546b:	78 33                	js     801054a0 <sys_read+0x60>
8010546d:	83 ec 04             	sub    $0x4,%esp
80105470:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105473:	ff 75 f0             	pushl  -0x10(%ebp)
80105476:	50                   	push   %eax
80105477:	6a 01                	push   $0x1
80105479:	e8 52 fc ff ff       	call   801050d0 <argptr>
8010547e:	83 c4 10             	add    $0x10,%esp
80105481:	85 c0                	test   %eax,%eax
80105483:	78 1b                	js     801054a0 <sys_read+0x60>
  return fileread(f, p, n);
80105485:	83 ec 04             	sub    $0x4,%esp
80105488:	ff 75 f0             	pushl  -0x10(%ebp)
8010548b:	ff 75 f4             	pushl  -0xc(%ebp)
8010548e:	ff 75 ec             	pushl  -0x14(%ebp)
80105491:	e8 6a bb ff ff       	call   80101000 <fileread>
80105496:	83 c4 10             	add    $0x10,%esp
}
80105499:	c9                   	leave  
8010549a:	c3                   	ret    
8010549b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010549f:	90                   	nop
801054a0:	c9                   	leave  
    return -1;
801054a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801054a6:	c3                   	ret    
801054a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801054ae:	66 90                	xchg   %ax,%ax

801054b0 <sys_write>:
{
801054b0:	f3 0f 1e fb          	endbr32 
801054b4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801054b5:	31 c0                	xor    %eax,%eax
{
801054b7:	89 e5                	mov    %esp,%ebp
801054b9:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801054bc:	8d 55 ec             	lea    -0x14(%ebp),%edx
801054bf:	e8 bc fe ff ff       	call   80105380 <argfd.constprop.0>
801054c4:	85 c0                	test   %eax,%eax
801054c6:	78 48                	js     80105510 <sys_write+0x60>
801054c8:	83 ec 08             	sub    $0x8,%esp
801054cb:	8d 45 f0             	lea    -0x10(%ebp),%eax
801054ce:	50                   	push   %eax
801054cf:	6a 02                	push   $0x2
801054d1:	e8 aa fb ff ff       	call   80105080 <argint>
801054d6:	83 c4 10             	add    $0x10,%esp
801054d9:	85 c0                	test   %eax,%eax
801054db:	78 33                	js     80105510 <sys_write+0x60>
801054dd:	83 ec 04             	sub    $0x4,%esp
801054e0:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054e3:	ff 75 f0             	pushl  -0x10(%ebp)
801054e6:	50                   	push   %eax
801054e7:	6a 01                	push   $0x1
801054e9:	e8 e2 fb ff ff       	call   801050d0 <argptr>
801054ee:	83 c4 10             	add    $0x10,%esp
801054f1:	85 c0                	test   %eax,%eax
801054f3:	78 1b                	js     80105510 <sys_write+0x60>
  return filewrite(f, p, n);
801054f5:	83 ec 04             	sub    $0x4,%esp
801054f8:	ff 75 f0             	pushl  -0x10(%ebp)
801054fb:	ff 75 f4             	pushl  -0xc(%ebp)
801054fe:	ff 75 ec             	pushl  -0x14(%ebp)
80105501:	e8 9a bb ff ff       	call   801010a0 <filewrite>
80105506:	83 c4 10             	add    $0x10,%esp
}
80105509:	c9                   	leave  
8010550a:	c3                   	ret    
8010550b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010550f:	90                   	nop
80105510:	c9                   	leave  
    return -1;
80105511:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105516:	c3                   	ret    
80105517:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010551e:	66 90                	xchg   %ax,%ax

80105520 <sys_close>:
{
80105520:	f3 0f 1e fb          	endbr32 
80105524:	55                   	push   %ebp
80105525:	89 e5                	mov    %esp,%ebp
80105527:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
8010552a:	8d 55 f4             	lea    -0xc(%ebp),%edx
8010552d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105530:	e8 4b fe ff ff       	call   80105380 <argfd.constprop.0>
80105535:	85 c0                	test   %eax,%eax
80105537:	78 27                	js     80105560 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80105539:	e8 c2 e4 ff ff       	call   80103a00 <myproc>
8010553e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80105541:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105544:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
8010554b:	00 
  fileclose(f);
8010554c:	ff 75 f4             	pushl  -0xc(%ebp)
8010554f:	e8 7c b9 ff ff       	call   80100ed0 <fileclose>
  return 0;
80105554:	83 c4 10             	add    $0x10,%esp
80105557:	31 c0                	xor    %eax,%eax
}
80105559:	c9                   	leave  
8010555a:	c3                   	ret    
8010555b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010555f:	90                   	nop
80105560:	c9                   	leave  
    return -1;
80105561:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105566:	c3                   	ret    
80105567:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010556e:	66 90                	xchg   %ax,%ax

80105570 <sys_fstat>:
{
80105570:	f3 0f 1e fb          	endbr32 
80105574:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105575:	31 c0                	xor    %eax,%eax
{
80105577:	89 e5                	mov    %esp,%ebp
80105579:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
8010557c:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010557f:	e8 fc fd ff ff       	call   80105380 <argfd.constprop.0>
80105584:	85 c0                	test   %eax,%eax
80105586:	78 30                	js     801055b8 <sys_fstat+0x48>
80105588:	83 ec 04             	sub    $0x4,%esp
8010558b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010558e:	6a 14                	push   $0x14
80105590:	50                   	push   %eax
80105591:	6a 01                	push   $0x1
80105593:	e8 38 fb ff ff       	call   801050d0 <argptr>
80105598:	83 c4 10             	add    $0x10,%esp
8010559b:	85 c0                	test   %eax,%eax
8010559d:	78 19                	js     801055b8 <sys_fstat+0x48>
  return filestat(f, st);
8010559f:	83 ec 08             	sub    $0x8,%esp
801055a2:	ff 75 f4             	pushl  -0xc(%ebp)
801055a5:	ff 75 f0             	pushl  -0x10(%ebp)
801055a8:	e8 03 ba ff ff       	call   80100fb0 <filestat>
801055ad:	83 c4 10             	add    $0x10,%esp
}
801055b0:	c9                   	leave  
801055b1:	c3                   	ret    
801055b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801055b8:	c9                   	leave  
    return -1;
801055b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055be:	c3                   	ret    
801055bf:	90                   	nop

801055c0 <sys_link>:
{
801055c0:	f3 0f 1e fb          	endbr32 
801055c4:	55                   	push   %ebp
801055c5:	89 e5                	mov    %esp,%ebp
801055c7:	57                   	push   %edi
801055c8:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801055c9:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801055cc:	53                   	push   %ebx
801055cd:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801055d0:	50                   	push   %eax
801055d1:	6a 00                	push   $0x0
801055d3:	e8 58 fb ff ff       	call   80105130 <argstr>
801055d8:	83 c4 10             	add    $0x10,%esp
801055db:	85 c0                	test   %eax,%eax
801055dd:	0f 88 ff 00 00 00    	js     801056e2 <sys_link+0x122>
801055e3:	83 ec 08             	sub    $0x8,%esp
801055e6:	8d 45 d0             	lea    -0x30(%ebp),%eax
801055e9:	50                   	push   %eax
801055ea:	6a 01                	push   $0x1
801055ec:	e8 3f fb ff ff       	call   80105130 <argstr>
801055f1:	83 c4 10             	add    $0x10,%esp
801055f4:	85 c0                	test   %eax,%eax
801055f6:	0f 88 e6 00 00 00    	js     801056e2 <sys_link+0x122>
  begin_op();
801055fc:	e8 3f d7 ff ff       	call   80102d40 <begin_op>
  if((ip = namei(old)) == 0){
80105601:	83 ec 0c             	sub    $0xc,%esp
80105604:	ff 75 d4             	pushl  -0x2c(%ebp)
80105607:	e8 34 ca ff ff       	call   80102040 <namei>
8010560c:	83 c4 10             	add    $0x10,%esp
8010560f:	89 c3                	mov    %eax,%ebx
80105611:	85 c0                	test   %eax,%eax
80105613:	0f 84 e8 00 00 00    	je     80105701 <sys_link+0x141>
  ilock(ip);
80105619:	83 ec 0c             	sub    $0xc,%esp
8010561c:	50                   	push   %eax
8010561d:	e8 4e c1 ff ff       	call   80101770 <ilock>
  if(ip->type == T_DIR){
80105622:	83 c4 10             	add    $0x10,%esp
80105625:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010562a:	0f 84 b9 00 00 00    	je     801056e9 <sys_link+0x129>
  iupdate(ip);
80105630:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80105633:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105638:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
8010563b:	53                   	push   %ebx
8010563c:	e8 6f c0 ff ff       	call   801016b0 <iupdate>
  iunlock(ip);
80105641:	89 1c 24             	mov    %ebx,(%esp)
80105644:	e8 07 c2 ff ff       	call   80101850 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105649:	58                   	pop    %eax
8010564a:	5a                   	pop    %edx
8010564b:	57                   	push   %edi
8010564c:	ff 75 d0             	pushl  -0x30(%ebp)
8010564f:	e8 0c ca ff ff       	call   80102060 <nameiparent>
80105654:	83 c4 10             	add    $0x10,%esp
80105657:	89 c6                	mov    %eax,%esi
80105659:	85 c0                	test   %eax,%eax
8010565b:	74 5f                	je     801056bc <sys_link+0xfc>
  ilock(dp);
8010565d:	83 ec 0c             	sub    $0xc,%esp
80105660:	50                   	push   %eax
80105661:	e8 0a c1 ff ff       	call   80101770 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105666:	8b 03                	mov    (%ebx),%eax
80105668:	83 c4 10             	add    $0x10,%esp
8010566b:	39 06                	cmp    %eax,(%esi)
8010566d:	75 41                	jne    801056b0 <sys_link+0xf0>
8010566f:	83 ec 04             	sub    $0x4,%esp
80105672:	ff 73 04             	pushl  0x4(%ebx)
80105675:	57                   	push   %edi
80105676:	56                   	push   %esi
80105677:	e8 04 c9 ff ff       	call   80101f80 <dirlink>
8010567c:	83 c4 10             	add    $0x10,%esp
8010567f:	85 c0                	test   %eax,%eax
80105681:	78 2d                	js     801056b0 <sys_link+0xf0>
  iunlockput(dp);
80105683:	83 ec 0c             	sub    $0xc,%esp
80105686:	56                   	push   %esi
80105687:	e8 84 c3 ff ff       	call   80101a10 <iunlockput>
  iput(ip);
8010568c:	89 1c 24             	mov    %ebx,(%esp)
8010568f:	e8 0c c2 ff ff       	call   801018a0 <iput>
  end_op();
80105694:	e8 17 d7 ff ff       	call   80102db0 <end_op>
  return 0;
80105699:	83 c4 10             	add    $0x10,%esp
8010569c:	31 c0                	xor    %eax,%eax
}
8010569e:	8d 65 f4             	lea    -0xc(%ebp),%esp
801056a1:	5b                   	pop    %ebx
801056a2:	5e                   	pop    %esi
801056a3:	5f                   	pop    %edi
801056a4:	5d                   	pop    %ebp
801056a5:	c3                   	ret    
801056a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056ad:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
801056b0:	83 ec 0c             	sub    $0xc,%esp
801056b3:	56                   	push   %esi
801056b4:	e8 57 c3 ff ff       	call   80101a10 <iunlockput>
    goto bad;
801056b9:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801056bc:	83 ec 0c             	sub    $0xc,%esp
801056bf:	53                   	push   %ebx
801056c0:	e8 ab c0 ff ff       	call   80101770 <ilock>
  ip->nlink--;
801056c5:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801056ca:	89 1c 24             	mov    %ebx,(%esp)
801056cd:	e8 de bf ff ff       	call   801016b0 <iupdate>
  iunlockput(ip);
801056d2:	89 1c 24             	mov    %ebx,(%esp)
801056d5:	e8 36 c3 ff ff       	call   80101a10 <iunlockput>
  end_op();
801056da:	e8 d1 d6 ff ff       	call   80102db0 <end_op>
  return -1;
801056df:	83 c4 10             	add    $0x10,%esp
801056e2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056e7:	eb b5                	jmp    8010569e <sys_link+0xde>
    iunlockput(ip);
801056e9:	83 ec 0c             	sub    $0xc,%esp
801056ec:	53                   	push   %ebx
801056ed:	e8 1e c3 ff ff       	call   80101a10 <iunlockput>
    end_op();
801056f2:	e8 b9 d6 ff ff       	call   80102db0 <end_op>
    return -1;
801056f7:	83 c4 10             	add    $0x10,%esp
801056fa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056ff:	eb 9d                	jmp    8010569e <sys_link+0xde>
    end_op();
80105701:	e8 aa d6 ff ff       	call   80102db0 <end_op>
    return -1;
80105706:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010570b:	eb 91                	jmp    8010569e <sys_link+0xde>
8010570d:	8d 76 00             	lea    0x0(%esi),%esi

80105710 <sys_unlink>:
{
80105710:	f3 0f 1e fb          	endbr32 
80105714:	55                   	push   %ebp
80105715:	89 e5                	mov    %esp,%ebp
80105717:	57                   	push   %edi
80105718:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105719:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
8010571c:	53                   	push   %ebx
8010571d:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
80105720:	50                   	push   %eax
80105721:	6a 00                	push   $0x0
80105723:	e8 08 fa ff ff       	call   80105130 <argstr>
80105728:	83 c4 10             	add    $0x10,%esp
8010572b:	85 c0                	test   %eax,%eax
8010572d:	0f 88 7d 01 00 00    	js     801058b0 <sys_unlink+0x1a0>
  begin_op();
80105733:	e8 08 d6 ff ff       	call   80102d40 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105738:	8d 5d ca             	lea    -0x36(%ebp),%ebx
8010573b:	83 ec 08             	sub    $0x8,%esp
8010573e:	53                   	push   %ebx
8010573f:	ff 75 c0             	pushl  -0x40(%ebp)
80105742:	e8 19 c9 ff ff       	call   80102060 <nameiparent>
80105747:	83 c4 10             	add    $0x10,%esp
8010574a:	89 c6                	mov    %eax,%esi
8010574c:	85 c0                	test   %eax,%eax
8010574e:	0f 84 66 01 00 00    	je     801058ba <sys_unlink+0x1aa>
  ilock(dp);
80105754:	83 ec 0c             	sub    $0xc,%esp
80105757:	50                   	push   %eax
80105758:	e8 13 c0 ff ff       	call   80101770 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010575d:	58                   	pop    %eax
8010575e:	5a                   	pop    %edx
8010575f:	68 80 80 10 80       	push   $0x80108080
80105764:	53                   	push   %ebx
80105765:	e8 36 c5 ff ff       	call   80101ca0 <namecmp>
8010576a:	83 c4 10             	add    $0x10,%esp
8010576d:	85 c0                	test   %eax,%eax
8010576f:	0f 84 03 01 00 00    	je     80105878 <sys_unlink+0x168>
80105775:	83 ec 08             	sub    $0x8,%esp
80105778:	68 7f 80 10 80       	push   $0x8010807f
8010577d:	53                   	push   %ebx
8010577e:	e8 1d c5 ff ff       	call   80101ca0 <namecmp>
80105783:	83 c4 10             	add    $0x10,%esp
80105786:	85 c0                	test   %eax,%eax
80105788:	0f 84 ea 00 00 00    	je     80105878 <sys_unlink+0x168>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010578e:	83 ec 04             	sub    $0x4,%esp
80105791:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105794:	50                   	push   %eax
80105795:	53                   	push   %ebx
80105796:	56                   	push   %esi
80105797:	e8 24 c5 ff ff       	call   80101cc0 <dirlookup>
8010579c:	83 c4 10             	add    $0x10,%esp
8010579f:	89 c3                	mov    %eax,%ebx
801057a1:	85 c0                	test   %eax,%eax
801057a3:	0f 84 cf 00 00 00    	je     80105878 <sys_unlink+0x168>
  ilock(ip);
801057a9:	83 ec 0c             	sub    $0xc,%esp
801057ac:	50                   	push   %eax
801057ad:	e8 be bf ff ff       	call   80101770 <ilock>
  if(ip->nlink < 1)
801057b2:	83 c4 10             	add    $0x10,%esp
801057b5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801057ba:	0f 8e 23 01 00 00    	jle    801058e3 <sys_unlink+0x1d3>
  if(ip->type == T_DIR && !isdirempty(ip)){
801057c0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801057c5:	8d 7d d8             	lea    -0x28(%ebp),%edi
801057c8:	74 66                	je     80105830 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801057ca:	83 ec 04             	sub    $0x4,%esp
801057cd:	6a 10                	push   $0x10
801057cf:	6a 00                	push   $0x0
801057d1:	57                   	push   %edi
801057d2:	e8 c9 f5 ff ff       	call   80104da0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801057d7:	6a 10                	push   $0x10
801057d9:	ff 75 c4             	pushl  -0x3c(%ebp)
801057dc:	57                   	push   %edi
801057dd:	56                   	push   %esi
801057de:	e8 8d c3 ff ff       	call   80101b70 <writei>
801057e3:	83 c4 20             	add    $0x20,%esp
801057e6:	83 f8 10             	cmp    $0x10,%eax
801057e9:	0f 85 e7 00 00 00    	jne    801058d6 <sys_unlink+0x1c6>
  if(ip->type == T_DIR){
801057ef:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801057f4:	0f 84 96 00 00 00    	je     80105890 <sys_unlink+0x180>
  iunlockput(dp);
801057fa:	83 ec 0c             	sub    $0xc,%esp
801057fd:	56                   	push   %esi
801057fe:	e8 0d c2 ff ff       	call   80101a10 <iunlockput>
  ip->nlink--;
80105803:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105808:	89 1c 24             	mov    %ebx,(%esp)
8010580b:	e8 a0 be ff ff       	call   801016b0 <iupdate>
  iunlockput(ip);
80105810:	89 1c 24             	mov    %ebx,(%esp)
80105813:	e8 f8 c1 ff ff       	call   80101a10 <iunlockput>
  end_op();
80105818:	e8 93 d5 ff ff       	call   80102db0 <end_op>
  return 0;
8010581d:	83 c4 10             	add    $0x10,%esp
80105820:	31 c0                	xor    %eax,%eax
}
80105822:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105825:	5b                   	pop    %ebx
80105826:	5e                   	pop    %esi
80105827:	5f                   	pop    %edi
80105828:	5d                   	pop    %ebp
80105829:	c3                   	ret    
8010582a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105830:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105834:	76 94                	jbe    801057ca <sys_unlink+0xba>
80105836:	ba 20 00 00 00       	mov    $0x20,%edx
8010583b:	eb 0b                	jmp    80105848 <sys_unlink+0x138>
8010583d:	8d 76 00             	lea    0x0(%esi),%esi
80105840:	83 c2 10             	add    $0x10,%edx
80105843:	39 53 58             	cmp    %edx,0x58(%ebx)
80105846:	76 82                	jbe    801057ca <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105848:	6a 10                	push   $0x10
8010584a:	52                   	push   %edx
8010584b:	57                   	push   %edi
8010584c:	53                   	push   %ebx
8010584d:	89 55 b4             	mov    %edx,-0x4c(%ebp)
80105850:	e8 1b c2 ff ff       	call   80101a70 <readi>
80105855:	83 c4 10             	add    $0x10,%esp
80105858:	8b 55 b4             	mov    -0x4c(%ebp),%edx
8010585b:	83 f8 10             	cmp    $0x10,%eax
8010585e:	75 69                	jne    801058c9 <sys_unlink+0x1b9>
    if(de.inum != 0)
80105860:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105865:	74 d9                	je     80105840 <sys_unlink+0x130>
    iunlockput(ip);
80105867:	83 ec 0c             	sub    $0xc,%esp
8010586a:	53                   	push   %ebx
8010586b:	e8 a0 c1 ff ff       	call   80101a10 <iunlockput>
    goto bad;
80105870:	83 c4 10             	add    $0x10,%esp
80105873:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105877:	90                   	nop
  iunlockput(dp);
80105878:	83 ec 0c             	sub    $0xc,%esp
8010587b:	56                   	push   %esi
8010587c:	e8 8f c1 ff ff       	call   80101a10 <iunlockput>
  end_op();
80105881:	e8 2a d5 ff ff       	call   80102db0 <end_op>
  return -1;
80105886:	83 c4 10             	add    $0x10,%esp
80105889:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010588e:	eb 92                	jmp    80105822 <sys_unlink+0x112>
    iupdate(dp);
80105890:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105893:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105898:	56                   	push   %esi
80105899:	e8 12 be ff ff       	call   801016b0 <iupdate>
8010589e:	83 c4 10             	add    $0x10,%esp
801058a1:	e9 54 ff ff ff       	jmp    801057fa <sys_unlink+0xea>
801058a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058ad:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801058b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058b5:	e9 68 ff ff ff       	jmp    80105822 <sys_unlink+0x112>
    end_op();
801058ba:	e8 f1 d4 ff ff       	call   80102db0 <end_op>
    return -1;
801058bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058c4:	e9 59 ff ff ff       	jmp    80105822 <sys_unlink+0x112>
      panic("isdirempty: readi");
801058c9:	83 ec 0c             	sub    $0xc,%esp
801058cc:	68 a4 80 10 80       	push   $0x801080a4
801058d1:	e8 ba aa ff ff       	call   80100390 <panic>
    panic("unlink: writei");
801058d6:	83 ec 0c             	sub    $0xc,%esp
801058d9:	68 b6 80 10 80       	push   $0x801080b6
801058de:	e8 ad aa ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
801058e3:	83 ec 0c             	sub    $0xc,%esp
801058e6:	68 92 80 10 80       	push   $0x80108092
801058eb:	e8 a0 aa ff ff       	call   80100390 <panic>

801058f0 <sys_open>:

int
sys_open(void)
{
801058f0:	f3 0f 1e fb          	endbr32 
801058f4:	55                   	push   %ebp
801058f5:	89 e5                	mov    %esp,%ebp
801058f7:	57                   	push   %edi
801058f8:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801058f9:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801058fc:	53                   	push   %ebx
801058fd:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105900:	50                   	push   %eax
80105901:	6a 00                	push   $0x0
80105903:	e8 28 f8 ff ff       	call   80105130 <argstr>
80105908:	83 c4 10             	add    $0x10,%esp
8010590b:	85 c0                	test   %eax,%eax
8010590d:	0f 88 8a 00 00 00    	js     8010599d <sys_open+0xad>
80105913:	83 ec 08             	sub    $0x8,%esp
80105916:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105919:	50                   	push   %eax
8010591a:	6a 01                	push   $0x1
8010591c:	e8 5f f7 ff ff       	call   80105080 <argint>
80105921:	83 c4 10             	add    $0x10,%esp
80105924:	85 c0                	test   %eax,%eax
80105926:	78 75                	js     8010599d <sys_open+0xad>
    return -1;

  begin_op();
80105928:	e8 13 d4 ff ff       	call   80102d40 <begin_op>

  if(omode & O_CREATE){
8010592d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105931:	75 75                	jne    801059a8 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105933:	83 ec 0c             	sub    $0xc,%esp
80105936:	ff 75 e0             	pushl  -0x20(%ebp)
80105939:	e8 02 c7 ff ff       	call   80102040 <namei>
8010593e:	83 c4 10             	add    $0x10,%esp
80105941:	89 c6                	mov    %eax,%esi
80105943:	85 c0                	test   %eax,%eax
80105945:	74 7e                	je     801059c5 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105947:	83 ec 0c             	sub    $0xc,%esp
8010594a:	50                   	push   %eax
8010594b:	e8 20 be ff ff       	call   80101770 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105950:	83 c4 10             	add    $0x10,%esp
80105953:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105958:	0f 84 c2 00 00 00    	je     80105a20 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010595e:	e8 ad b4 ff ff       	call   80100e10 <filealloc>
80105963:	89 c7                	mov    %eax,%edi
80105965:	85 c0                	test   %eax,%eax
80105967:	74 23                	je     8010598c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105969:	e8 92 e0 ff ff       	call   80103a00 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010596e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105970:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105974:	85 d2                	test   %edx,%edx
80105976:	74 60                	je     801059d8 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105978:	83 c3 01             	add    $0x1,%ebx
8010597b:	83 fb 10             	cmp    $0x10,%ebx
8010597e:	75 f0                	jne    80105970 <sys_open+0x80>
    if(f)
      fileclose(f);
80105980:	83 ec 0c             	sub    $0xc,%esp
80105983:	57                   	push   %edi
80105984:	e8 47 b5 ff ff       	call   80100ed0 <fileclose>
80105989:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010598c:	83 ec 0c             	sub    $0xc,%esp
8010598f:	56                   	push   %esi
80105990:	e8 7b c0 ff ff       	call   80101a10 <iunlockput>
    end_op();
80105995:	e8 16 d4 ff ff       	call   80102db0 <end_op>
    return -1;
8010599a:	83 c4 10             	add    $0x10,%esp
8010599d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801059a2:	eb 6d                	jmp    80105a11 <sys_open+0x121>
801059a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
801059a8:	83 ec 0c             	sub    $0xc,%esp
801059ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
801059ae:	31 c9                	xor    %ecx,%ecx
801059b0:	ba 02 00 00 00       	mov    $0x2,%edx
801059b5:	6a 00                	push   $0x0
801059b7:	e8 24 f8 ff ff       	call   801051e0 <create>
    if(ip == 0){
801059bc:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
801059bf:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801059c1:	85 c0                	test   %eax,%eax
801059c3:	75 99                	jne    8010595e <sys_open+0x6e>
      end_op();
801059c5:	e8 e6 d3 ff ff       	call   80102db0 <end_op>
      return -1;
801059ca:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801059cf:	eb 40                	jmp    80105a11 <sys_open+0x121>
801059d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
801059d8:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801059db:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
801059df:	56                   	push   %esi
801059e0:	e8 6b be ff ff       	call   80101850 <iunlock>
  end_op();
801059e5:	e8 c6 d3 ff ff       	call   80102db0 <end_op>

  f->type = FD_INODE;
801059ea:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801059f0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801059f3:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801059f6:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
801059f9:	89 d0                	mov    %edx,%eax
  f->off = 0;
801059fb:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105a02:	f7 d0                	not    %eax
80105a04:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105a07:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105a0a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105a0d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105a11:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a14:	89 d8                	mov    %ebx,%eax
80105a16:	5b                   	pop    %ebx
80105a17:	5e                   	pop    %esi
80105a18:	5f                   	pop    %edi
80105a19:	5d                   	pop    %ebp
80105a1a:	c3                   	ret    
80105a1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105a1f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105a20:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105a23:	85 c9                	test   %ecx,%ecx
80105a25:	0f 84 33 ff ff ff    	je     8010595e <sys_open+0x6e>
80105a2b:	e9 5c ff ff ff       	jmp    8010598c <sys_open+0x9c>

80105a30 <sys_mkdir>:

int
sys_mkdir(void)
{
80105a30:	f3 0f 1e fb          	endbr32 
80105a34:	55                   	push   %ebp
80105a35:	89 e5                	mov    %esp,%ebp
80105a37:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105a3a:	e8 01 d3 ff ff       	call   80102d40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105a3f:	83 ec 08             	sub    $0x8,%esp
80105a42:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a45:	50                   	push   %eax
80105a46:	6a 00                	push   $0x0
80105a48:	e8 e3 f6 ff ff       	call   80105130 <argstr>
80105a4d:	83 c4 10             	add    $0x10,%esp
80105a50:	85 c0                	test   %eax,%eax
80105a52:	78 34                	js     80105a88 <sys_mkdir+0x58>
80105a54:	83 ec 0c             	sub    $0xc,%esp
80105a57:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a5a:	31 c9                	xor    %ecx,%ecx
80105a5c:	ba 01 00 00 00       	mov    $0x1,%edx
80105a61:	6a 00                	push   $0x0
80105a63:	e8 78 f7 ff ff       	call   801051e0 <create>
80105a68:	83 c4 10             	add    $0x10,%esp
80105a6b:	85 c0                	test   %eax,%eax
80105a6d:	74 19                	je     80105a88 <sys_mkdir+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105a6f:	83 ec 0c             	sub    $0xc,%esp
80105a72:	50                   	push   %eax
80105a73:	e8 98 bf ff ff       	call   80101a10 <iunlockput>
  end_op();
80105a78:	e8 33 d3 ff ff       	call   80102db0 <end_op>
  return 0;
80105a7d:	83 c4 10             	add    $0x10,%esp
80105a80:	31 c0                	xor    %eax,%eax
}
80105a82:	c9                   	leave  
80105a83:	c3                   	ret    
80105a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105a88:	e8 23 d3 ff ff       	call   80102db0 <end_op>
    return -1;
80105a8d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a92:	c9                   	leave  
80105a93:	c3                   	ret    
80105a94:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105a9f:	90                   	nop

80105aa0 <sys_mknod>:

int
sys_mknod(void)
{
80105aa0:	f3 0f 1e fb          	endbr32 
80105aa4:	55                   	push   %ebp
80105aa5:	89 e5                	mov    %esp,%ebp
80105aa7:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105aaa:	e8 91 d2 ff ff       	call   80102d40 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105aaf:	83 ec 08             	sub    $0x8,%esp
80105ab2:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105ab5:	50                   	push   %eax
80105ab6:	6a 00                	push   $0x0
80105ab8:	e8 73 f6 ff ff       	call   80105130 <argstr>
80105abd:	83 c4 10             	add    $0x10,%esp
80105ac0:	85 c0                	test   %eax,%eax
80105ac2:	78 64                	js     80105b28 <sys_mknod+0x88>
     argint(1, &major) < 0 ||
80105ac4:	83 ec 08             	sub    $0x8,%esp
80105ac7:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105aca:	50                   	push   %eax
80105acb:	6a 01                	push   $0x1
80105acd:	e8 ae f5 ff ff       	call   80105080 <argint>
  if((argstr(0, &path)) < 0 ||
80105ad2:	83 c4 10             	add    $0x10,%esp
80105ad5:	85 c0                	test   %eax,%eax
80105ad7:	78 4f                	js     80105b28 <sys_mknod+0x88>
     argint(2, &minor) < 0 ||
80105ad9:	83 ec 08             	sub    $0x8,%esp
80105adc:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105adf:	50                   	push   %eax
80105ae0:	6a 02                	push   $0x2
80105ae2:	e8 99 f5 ff ff       	call   80105080 <argint>
     argint(1, &major) < 0 ||
80105ae7:	83 c4 10             	add    $0x10,%esp
80105aea:	85 c0                	test   %eax,%eax
80105aec:	78 3a                	js     80105b28 <sys_mknod+0x88>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105aee:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105af2:	83 ec 0c             	sub    $0xc,%esp
80105af5:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105af9:	ba 03 00 00 00       	mov    $0x3,%edx
80105afe:	50                   	push   %eax
80105aff:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105b02:	e8 d9 f6 ff ff       	call   801051e0 <create>
     argint(2, &minor) < 0 ||
80105b07:	83 c4 10             	add    $0x10,%esp
80105b0a:	85 c0                	test   %eax,%eax
80105b0c:	74 1a                	je     80105b28 <sys_mknod+0x88>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105b0e:	83 ec 0c             	sub    $0xc,%esp
80105b11:	50                   	push   %eax
80105b12:	e8 f9 be ff ff       	call   80101a10 <iunlockput>
  end_op();
80105b17:	e8 94 d2 ff ff       	call   80102db0 <end_op>
  return 0;
80105b1c:	83 c4 10             	add    $0x10,%esp
80105b1f:	31 c0                	xor    %eax,%eax
}
80105b21:	c9                   	leave  
80105b22:	c3                   	ret    
80105b23:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b27:	90                   	nop
    end_op();
80105b28:	e8 83 d2 ff ff       	call   80102db0 <end_op>
    return -1;
80105b2d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b32:	c9                   	leave  
80105b33:	c3                   	ret    
80105b34:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b3f:	90                   	nop

80105b40 <sys_chdir>:

int
sys_chdir(void)
{
80105b40:	f3 0f 1e fb          	endbr32 
80105b44:	55                   	push   %ebp
80105b45:	89 e5                	mov    %esp,%ebp
80105b47:	56                   	push   %esi
80105b48:	53                   	push   %ebx
80105b49:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105b4c:	e8 af de ff ff       	call   80103a00 <myproc>
80105b51:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105b53:	e8 e8 d1 ff ff       	call   80102d40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105b58:	83 ec 08             	sub    $0x8,%esp
80105b5b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b5e:	50                   	push   %eax
80105b5f:	6a 00                	push   $0x0
80105b61:	e8 ca f5 ff ff       	call   80105130 <argstr>
80105b66:	83 c4 10             	add    $0x10,%esp
80105b69:	85 c0                	test   %eax,%eax
80105b6b:	78 73                	js     80105be0 <sys_chdir+0xa0>
80105b6d:	83 ec 0c             	sub    $0xc,%esp
80105b70:	ff 75 f4             	pushl  -0xc(%ebp)
80105b73:	e8 c8 c4 ff ff       	call   80102040 <namei>
80105b78:	83 c4 10             	add    $0x10,%esp
80105b7b:	89 c3                	mov    %eax,%ebx
80105b7d:	85 c0                	test   %eax,%eax
80105b7f:	74 5f                	je     80105be0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105b81:	83 ec 0c             	sub    $0xc,%esp
80105b84:	50                   	push   %eax
80105b85:	e8 e6 bb ff ff       	call   80101770 <ilock>
  if(ip->type != T_DIR){
80105b8a:	83 c4 10             	add    $0x10,%esp
80105b8d:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105b92:	75 2c                	jne    80105bc0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105b94:	83 ec 0c             	sub    $0xc,%esp
80105b97:	53                   	push   %ebx
80105b98:	e8 b3 bc ff ff       	call   80101850 <iunlock>
  iput(curproc->cwd);
80105b9d:	58                   	pop    %eax
80105b9e:	ff 76 68             	pushl  0x68(%esi)
80105ba1:	e8 fa bc ff ff       	call   801018a0 <iput>
  end_op();
80105ba6:	e8 05 d2 ff ff       	call   80102db0 <end_op>
  curproc->cwd = ip;
80105bab:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105bae:	83 c4 10             	add    $0x10,%esp
80105bb1:	31 c0                	xor    %eax,%eax
}
80105bb3:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105bb6:	5b                   	pop    %ebx
80105bb7:	5e                   	pop    %esi
80105bb8:	5d                   	pop    %ebp
80105bb9:	c3                   	ret    
80105bba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80105bc0:	83 ec 0c             	sub    $0xc,%esp
80105bc3:	53                   	push   %ebx
80105bc4:	e8 47 be ff ff       	call   80101a10 <iunlockput>
    end_op();
80105bc9:	e8 e2 d1 ff ff       	call   80102db0 <end_op>
    return -1;
80105bce:	83 c4 10             	add    $0x10,%esp
80105bd1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bd6:	eb db                	jmp    80105bb3 <sys_chdir+0x73>
80105bd8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bdf:	90                   	nop
    end_op();
80105be0:	e8 cb d1 ff ff       	call   80102db0 <end_op>
    return -1;
80105be5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bea:	eb c7                	jmp    80105bb3 <sys_chdir+0x73>
80105bec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105bf0 <sys_exec>:

int
sys_exec(void)
{
80105bf0:	f3 0f 1e fb          	endbr32 
80105bf4:	55                   	push   %ebp
80105bf5:	89 e5                	mov    %esp,%ebp
80105bf7:	57                   	push   %edi
80105bf8:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105bf9:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105bff:	53                   	push   %ebx
80105c00:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105c06:	50                   	push   %eax
80105c07:	6a 00                	push   $0x0
80105c09:	e8 22 f5 ff ff       	call   80105130 <argstr>
80105c0e:	83 c4 10             	add    $0x10,%esp
80105c11:	85 c0                	test   %eax,%eax
80105c13:	0f 88 8b 00 00 00    	js     80105ca4 <sys_exec+0xb4>
80105c19:	83 ec 08             	sub    $0x8,%esp
80105c1c:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105c22:	50                   	push   %eax
80105c23:	6a 01                	push   $0x1
80105c25:	e8 56 f4 ff ff       	call   80105080 <argint>
80105c2a:	83 c4 10             	add    $0x10,%esp
80105c2d:	85 c0                	test   %eax,%eax
80105c2f:	78 73                	js     80105ca4 <sys_exec+0xb4>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105c31:	83 ec 04             	sub    $0x4,%esp
80105c34:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
80105c3a:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105c3c:	68 80 00 00 00       	push   $0x80
80105c41:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105c47:	6a 00                	push   $0x0
80105c49:	50                   	push   %eax
80105c4a:	e8 51 f1 ff ff       	call   80104da0 <memset>
80105c4f:	83 c4 10             	add    $0x10,%esp
80105c52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105c58:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105c5e:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105c65:	83 ec 08             	sub    $0x8,%esp
80105c68:	57                   	push   %edi
80105c69:	01 f0                	add    %esi,%eax
80105c6b:	50                   	push   %eax
80105c6c:	e8 6f f3 ff ff       	call   80104fe0 <fetchint>
80105c71:	83 c4 10             	add    $0x10,%esp
80105c74:	85 c0                	test   %eax,%eax
80105c76:	78 2c                	js     80105ca4 <sys_exec+0xb4>
      return -1;
    if(uarg == 0){
80105c78:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105c7e:	85 c0                	test   %eax,%eax
80105c80:	74 36                	je     80105cb8 <sys_exec+0xc8>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105c82:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105c88:	83 ec 08             	sub    $0x8,%esp
80105c8b:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105c8e:	52                   	push   %edx
80105c8f:	50                   	push   %eax
80105c90:	e8 8b f3 ff ff       	call   80105020 <fetchstr>
80105c95:	83 c4 10             	add    $0x10,%esp
80105c98:	85 c0                	test   %eax,%eax
80105c9a:	78 08                	js     80105ca4 <sys_exec+0xb4>
  for(i=0;; i++){
80105c9c:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105c9f:	83 fb 20             	cmp    $0x20,%ebx
80105ca2:	75 b4                	jne    80105c58 <sys_exec+0x68>
      return -1;
  }
  return exec(path, argv);
}
80105ca4:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105ca7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105cac:	5b                   	pop    %ebx
80105cad:	5e                   	pop    %esi
80105cae:	5f                   	pop    %edi
80105caf:	5d                   	pop    %ebp
80105cb0:	c3                   	ret    
80105cb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105cb8:	83 ec 08             	sub    $0x8,%esp
80105cbb:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
80105cc1:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105cc8:	00 00 00 00 
  return exec(path, argv);
80105ccc:	50                   	push   %eax
80105ccd:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105cd3:	e8 a8 ad ff ff       	call   80100a80 <exec>
80105cd8:	83 c4 10             	add    $0x10,%esp
}
80105cdb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105cde:	5b                   	pop    %ebx
80105cdf:	5e                   	pop    %esi
80105ce0:	5f                   	pop    %edi
80105ce1:	5d                   	pop    %ebp
80105ce2:	c3                   	ret    
80105ce3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105cf0 <sys_pipe>:

int
sys_pipe(void)
{
80105cf0:	f3 0f 1e fb          	endbr32 
80105cf4:	55                   	push   %ebp
80105cf5:	89 e5                	mov    %esp,%ebp
80105cf7:	57                   	push   %edi
80105cf8:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105cf9:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105cfc:	53                   	push   %ebx
80105cfd:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105d00:	6a 08                	push   $0x8
80105d02:	50                   	push   %eax
80105d03:	6a 00                	push   $0x0
80105d05:	e8 c6 f3 ff ff       	call   801050d0 <argptr>
80105d0a:	83 c4 10             	add    $0x10,%esp
80105d0d:	85 c0                	test   %eax,%eax
80105d0f:	78 4e                	js     80105d5f <sys_pipe+0x6f>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105d11:	83 ec 08             	sub    $0x8,%esp
80105d14:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105d17:	50                   	push   %eax
80105d18:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105d1b:	50                   	push   %eax
80105d1c:	e8 df d6 ff ff       	call   80103400 <pipealloc>
80105d21:	83 c4 10             	add    $0x10,%esp
80105d24:	85 c0                	test   %eax,%eax
80105d26:	78 37                	js     80105d5f <sys_pipe+0x6f>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105d28:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105d2b:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105d2d:	e8 ce dc ff ff       	call   80103a00 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105d32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
80105d38:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105d3c:	85 f6                	test   %esi,%esi
80105d3e:	74 30                	je     80105d70 <sys_pipe+0x80>
  for(fd = 0; fd < NOFILE; fd++){
80105d40:	83 c3 01             	add    $0x1,%ebx
80105d43:	83 fb 10             	cmp    $0x10,%ebx
80105d46:	75 f0                	jne    80105d38 <sys_pipe+0x48>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105d48:	83 ec 0c             	sub    $0xc,%esp
80105d4b:	ff 75 e0             	pushl  -0x20(%ebp)
80105d4e:	e8 7d b1 ff ff       	call   80100ed0 <fileclose>
    fileclose(wf);
80105d53:	58                   	pop    %eax
80105d54:	ff 75 e4             	pushl  -0x1c(%ebp)
80105d57:	e8 74 b1 ff ff       	call   80100ed0 <fileclose>
    return -1;
80105d5c:	83 c4 10             	add    $0x10,%esp
80105d5f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d64:	eb 5b                	jmp    80105dc1 <sys_pipe+0xd1>
80105d66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d6d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80105d70:	8d 73 08             	lea    0x8(%ebx),%esi
80105d73:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105d77:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105d7a:	e8 81 dc ff ff       	call   80103a00 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105d7f:	31 d2                	xor    %edx,%edx
80105d81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105d88:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105d8c:	85 c9                	test   %ecx,%ecx
80105d8e:	74 20                	je     80105db0 <sys_pipe+0xc0>
  for(fd = 0; fd < NOFILE; fd++){
80105d90:	83 c2 01             	add    $0x1,%edx
80105d93:	83 fa 10             	cmp    $0x10,%edx
80105d96:	75 f0                	jne    80105d88 <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
80105d98:	e8 63 dc ff ff       	call   80103a00 <myproc>
80105d9d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105da4:	00 
80105da5:	eb a1                	jmp    80105d48 <sys_pipe+0x58>
80105da7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105dae:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105db0:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105db4:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105db7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105db9:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105dbc:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105dbf:	31 c0                	xor    %eax,%eax
}
80105dc1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105dc4:	5b                   	pop    %ebx
80105dc5:	5e                   	pop    %esi
80105dc6:	5f                   	pop    %edi
80105dc7:	5d                   	pop    %ebp
80105dc8:	c3                   	ret    
80105dc9:	66 90                	xchg   %ax,%ax
80105dcb:	66 90                	xchg   %ax,%ax
80105dcd:	66 90                	xchg   %ax,%ax
80105dcf:	90                   	nop

80105dd0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105dd0:	f3 0f 1e fb          	endbr32 
  return fork();
80105dd4:	e9 d7 dd ff ff       	jmp    80103bb0 <fork>
80105dd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105de0 <sys_exit>:
}

int
sys_exit(void)
{
80105de0:	f3 0f 1e fb          	endbr32 
80105de4:	55                   	push   %ebp
80105de5:	89 e5                	mov    %esp,%ebp
80105de7:	83 ec 08             	sub    $0x8,%esp
  exit();
80105dea:	e8 91 e1 ff ff       	call   80103f80 <exit>
  return 0;  // not reached
}
80105def:	31 c0                	xor    %eax,%eax
80105df1:	c9                   	leave  
80105df2:	c3                   	ret    
80105df3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105dfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105e00 <sys_wait>:

int
sys_wait(void)
{
80105e00:	f3 0f 1e fb          	endbr32 
  return wait();
80105e04:	e9 87 e4 ff ff       	jmp    80104290 <wait>
80105e09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105e10 <sys_kill>:
}

int
sys_kill(void)
{
80105e10:	f3 0f 1e fb          	endbr32 
80105e14:	55                   	push   %ebp
80105e15:	89 e5                	mov    %esp,%ebp
80105e17:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105e1a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e1d:	50                   	push   %eax
80105e1e:	6a 00                	push   $0x0
80105e20:	e8 5b f2 ff ff       	call   80105080 <argint>
80105e25:	83 c4 10             	add    $0x10,%esp
80105e28:	85 c0                	test   %eax,%eax
80105e2a:	78 14                	js     80105e40 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105e2c:	83 ec 0c             	sub    $0xc,%esp
80105e2f:	ff 75 f4             	pushl  -0xc(%ebp)
80105e32:	e8 f9 e6 ff ff       	call   80104530 <kill>
80105e37:	83 c4 10             	add    $0x10,%esp
}
80105e3a:	c9                   	leave  
80105e3b:	c3                   	ret    
80105e3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105e40:	c9                   	leave  
    return -1;
80105e41:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e46:	c3                   	ret    
80105e47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e4e:	66 90                	xchg   %ax,%ax

80105e50 <sys_getpid>:

int
sys_getpid(void)
{
80105e50:	f3 0f 1e fb          	endbr32 
80105e54:	55                   	push   %ebp
80105e55:	89 e5                	mov    %esp,%ebp
80105e57:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105e5a:	e8 a1 db ff ff       	call   80103a00 <myproc>
80105e5f:	8b 40 10             	mov    0x10(%eax),%eax
}
80105e62:	c9                   	leave  
80105e63:	c3                   	ret    
80105e64:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105e6f:	90                   	nop

80105e70 <sys_sbrk>:

int
sys_sbrk(void)
{
80105e70:	f3 0f 1e fb          	endbr32 
80105e74:	55                   	push   %ebp
80105e75:	89 e5                	mov    %esp,%ebp
80105e77:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105e78:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105e7b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105e7e:	50                   	push   %eax
80105e7f:	6a 00                	push   $0x0
80105e81:	e8 fa f1 ff ff       	call   80105080 <argint>
80105e86:	83 c4 10             	add    $0x10,%esp
80105e89:	85 c0                	test   %eax,%eax
80105e8b:	78 23                	js     80105eb0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105e8d:	e8 6e db ff ff       	call   80103a00 <myproc>
  if(growproc(n) < 0)
80105e92:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105e95:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105e97:	ff 75 f4             	pushl  -0xc(%ebp)
80105e9a:	e8 91 dc ff ff       	call   80103b30 <growproc>
80105e9f:	83 c4 10             	add    $0x10,%esp
80105ea2:	85 c0                	test   %eax,%eax
80105ea4:	78 0a                	js     80105eb0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105ea6:	89 d8                	mov    %ebx,%eax
80105ea8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105eab:	c9                   	leave  
80105eac:	c3                   	ret    
80105ead:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105eb0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105eb5:	eb ef                	jmp    80105ea6 <sys_sbrk+0x36>
80105eb7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ebe:	66 90                	xchg   %ax,%ax

80105ec0 <sys_sleep>:

int
sys_sleep(void)
{
80105ec0:	f3 0f 1e fb          	endbr32 
80105ec4:	55                   	push   %ebp
80105ec5:	89 e5                	mov    %esp,%ebp
80105ec7:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105ec8:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105ecb:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105ece:	50                   	push   %eax
80105ecf:	6a 00                	push   $0x0
80105ed1:	e8 aa f1 ff ff       	call   80105080 <argint>
80105ed6:	83 c4 10             	add    $0x10,%esp
80105ed9:	85 c0                	test   %eax,%eax
80105edb:	0f 88 86 00 00 00    	js     80105f67 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105ee1:	83 ec 0c             	sub    $0xc,%esp
80105ee4:	68 60 6a 11 80       	push   $0x80116a60
80105ee9:	e8 a2 ed ff ff       	call   80104c90 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105eee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105ef1:	8b 1d a0 72 11 80    	mov    0x801172a0,%ebx
  while(ticks - ticks0 < n){
80105ef7:	83 c4 10             	add    $0x10,%esp
80105efa:	85 d2                	test   %edx,%edx
80105efc:	75 23                	jne    80105f21 <sys_sleep+0x61>
80105efe:	eb 50                	jmp    80105f50 <sys_sleep+0x90>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105f00:	83 ec 08             	sub    $0x8,%esp
80105f03:	68 60 6a 11 80       	push   $0x80116a60
80105f08:	68 a0 72 11 80       	push   $0x801172a0
80105f0d:	e8 be e2 ff ff       	call   801041d0 <sleep>
  while(ticks - ticks0 < n){
80105f12:	a1 a0 72 11 80       	mov    0x801172a0,%eax
80105f17:	83 c4 10             	add    $0x10,%esp
80105f1a:	29 d8                	sub    %ebx,%eax
80105f1c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105f1f:	73 2f                	jae    80105f50 <sys_sleep+0x90>
    if(myproc()->killed){
80105f21:	e8 da da ff ff       	call   80103a00 <myproc>
80105f26:	8b 40 24             	mov    0x24(%eax),%eax
80105f29:	85 c0                	test   %eax,%eax
80105f2b:	74 d3                	je     80105f00 <sys_sleep+0x40>
      release(&tickslock);
80105f2d:	83 ec 0c             	sub    $0xc,%esp
80105f30:	68 60 6a 11 80       	push   $0x80116a60
80105f35:	e8 16 ee ff ff       	call   80104d50 <release>
  }
  release(&tickslock);
  return 0;
}
80105f3a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
80105f3d:	83 c4 10             	add    $0x10,%esp
80105f40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f45:	c9                   	leave  
80105f46:	c3                   	ret    
80105f47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f4e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105f50:	83 ec 0c             	sub    $0xc,%esp
80105f53:	68 60 6a 11 80       	push   $0x80116a60
80105f58:	e8 f3 ed ff ff       	call   80104d50 <release>
  return 0;
80105f5d:	83 c4 10             	add    $0x10,%esp
80105f60:	31 c0                	xor    %eax,%eax
}
80105f62:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105f65:	c9                   	leave  
80105f66:	c3                   	ret    
    return -1;
80105f67:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f6c:	eb f4                	jmp    80105f62 <sys_sleep+0xa2>
80105f6e:	66 90                	xchg   %ax,%ax

80105f70 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105f70:	f3 0f 1e fb          	endbr32 
80105f74:	55                   	push   %ebp
80105f75:	89 e5                	mov    %esp,%ebp
80105f77:	53                   	push   %ebx
80105f78:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105f7b:	68 60 6a 11 80       	push   $0x80116a60
80105f80:	e8 0b ed ff ff       	call   80104c90 <acquire>
  xticks = ticks;
80105f85:	8b 1d a0 72 11 80    	mov    0x801172a0,%ebx
  release(&tickslock);
80105f8b:	c7 04 24 60 6a 11 80 	movl   $0x80116a60,(%esp)
80105f92:	e8 b9 ed ff ff       	call   80104d50 <release>
  return xticks;
}
80105f97:	89 d8                	mov    %ebx,%eax
80105f99:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105f9c:	c9                   	leave  
80105f9d:	c3                   	ret    
80105f9e:	66 90                	xchg   %ax,%ax

80105fa0 <sys_waitx>:

int sys_waitx(void)
{
80105fa0:	f3 0f 1e fb          	endbr32 
80105fa4:	55                   	push   %ebp
80105fa5:	89 e5                	mov    %esp,%ebp
80105fa7:	83 ec 1c             	sub    $0x1c,%esp
  int *wtime;
  int *rtime;
  if(argptr(0,(void *)&wtime,sizeof(int)) <0   || argptr(1,(void*)&rtime,sizeof(int))<0)
80105faa:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105fad:	6a 04                	push   $0x4
80105faf:	50                   	push   %eax
80105fb0:	6a 00                	push   $0x0
80105fb2:	e8 19 f1 ff ff       	call   801050d0 <argptr>
80105fb7:	83 c4 10             	add    $0x10,%esp
80105fba:	85 c0                	test   %eax,%eax
80105fbc:	78 32                	js     80105ff0 <sys_waitx+0x50>
80105fbe:	83 ec 04             	sub    $0x4,%esp
80105fc1:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105fc4:	6a 04                	push   $0x4
80105fc6:	50                   	push   %eax
80105fc7:	6a 01                	push   $0x1
80105fc9:	e8 02 f1 ff ff       	call   801050d0 <argptr>
80105fce:	83 c4 10             	add    $0x10,%esp
80105fd1:	85 c0                	test   %eax,%eax
80105fd3:	78 1b                	js     80105ff0 <sys_waitx+0x50>
  {
    return -1;
  }
  // cprintf("w %p ",wtime);
  // cprintf("r %p ",rtime);
  return waitx(wtime, rtime);
80105fd5:	83 ec 08             	sub    $0x8,%esp
80105fd8:	ff 75 f4             	pushl  -0xc(%ebp)
80105fdb:	ff 75 f0             	pushl  -0x10(%ebp)
80105fde:	e8 ad e3 ff ff       	call   80104390 <waitx>
80105fe3:	83 c4 10             	add    $0x10,%esp
}
80105fe6:	c9                   	leave  
80105fe7:	c3                   	ret    
80105fe8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105fef:	90                   	nop
80105ff0:	c9                   	leave  
    return -1;
80105ff1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ff6:	c3                   	ret    
80105ff7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ffe:	66 90                	xchg   %ax,%ax

80106000 <sys_set_priority>:

int sys_set_priority(void)
{
80106000:	f3 0f 1e fb          	endbr32 
80106004:	55                   	push   %ebp
80106005:	89 e5                	mov    %esp,%ebp
80106007:	83 ec 20             	sub    $0x20,%esp
  int new_priority,pid;
  if(argint(0,&new_priority)<0 || argint(1,&pid)<0)
8010600a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010600d:	50                   	push   %eax
8010600e:	6a 00                	push   $0x0
80106010:	e8 6b f0 ff ff       	call   80105080 <argint>
80106015:	83 c4 10             	add    $0x10,%esp
80106018:	85 c0                	test   %eax,%eax
8010601a:	78 2c                	js     80106048 <sys_set_priority+0x48>
8010601c:	83 ec 08             	sub    $0x8,%esp
8010601f:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106022:	50                   	push   %eax
80106023:	6a 01                	push   $0x1
80106025:	e8 56 f0 ff ff       	call   80105080 <argint>
8010602a:	83 c4 10             	add    $0x10,%esp
8010602d:	85 c0                	test   %eax,%eax
8010602f:	78 17                	js     80106048 <sys_set_priority+0x48>
  {
    return -1;
  }
  return set_priority(new_priority,pid);
80106031:	83 ec 08             	sub    $0x8,%esp
80106034:	ff 75 f4             	pushl  -0xc(%ebp)
80106037:	ff 75 f0             	pushl  -0x10(%ebp)
8010603a:	e8 f1 e0 ff ff       	call   80104130 <set_priority>
8010603f:	83 c4 10             	add    $0x10,%esp
}
80106042:	c9                   	leave  
80106043:	c3                   	ret    
80106044:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106048:	c9                   	leave  
    return -1;
80106049:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010604e:	c3                   	ret    
8010604f:	90                   	nop

80106050 <sys_ps>:

int sys_ps(void)
{
80106050:	f3 0f 1e fb          	endbr32 
80106054:	55                   	push   %ebp
80106055:	89 e5                	mov    %esp,%ebp
80106057:	83 ec 1c             	sub    $0x1c,%esp
  struct procstatus *arr;
  if(argptr(0,(void *)&arr,sizeof(arr))<0)
8010605a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010605d:	6a 04                	push   $0x4
8010605f:	50                   	push   %eax
80106060:	6a 00                	push   $0x0
80106062:	e8 69 f0 ff ff       	call   801050d0 <argptr>
80106067:	83 c4 10             	add    $0x10,%esp
8010606a:	85 c0                	test   %eax,%eax
8010606c:	78 12                	js     80106080 <sys_ps+0x30>
  {
    return -1;
  }
  return ps(arr);
8010606e:	83 ec 0c             	sub    $0xc,%esp
80106071:	ff 75 f4             	pushl  -0xc(%ebp)
80106074:	e8 67 e6 ff ff       	call   801046e0 <ps>
80106079:	83 c4 10             	add    $0x10,%esp
}
8010607c:	c9                   	leave  
8010607d:	c3                   	ret    
8010607e:	66 90                	xchg   %ax,%ax
80106080:	c9                   	leave  
    return -1;
80106081:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106086:	c3                   	ret    

80106087 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106087:	1e                   	push   %ds
  pushl %es
80106088:	06                   	push   %es
  pushl %fs
80106089:	0f a0                	push   %fs
  pushl %gs
8010608b:	0f a8                	push   %gs
  pushal
8010608d:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
8010608e:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106092:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106094:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80106096:	54                   	push   %esp
  call trap
80106097:	e8 c4 00 00 00       	call   80106160 <trap>
  addl $4, %esp
8010609c:	83 c4 04             	add    $0x4,%esp

8010609f <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
8010609f:	61                   	popa   
  popl %gs
801060a0:	0f a9                	pop    %gs
  popl %fs
801060a2:	0f a1                	pop    %fs
  popl %es
801060a4:	07                   	pop    %es
  popl %ds
801060a5:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801060a6:	83 c4 08             	add    $0x8,%esp
  iret
801060a9:	cf                   	iret   
801060aa:	66 90                	xchg   %ax,%ax
801060ac:	66 90                	xchg   %ax,%ax
801060ae:	66 90                	xchg   %ax,%ax

801060b0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801060b0:	f3 0f 1e fb          	endbr32 
801060b4:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
801060b5:	31 c0                	xor    %eax,%eax
{
801060b7:	89 e5                	mov    %esp,%ebp
801060b9:	83 ec 08             	sub    $0x8,%esp
801060bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801060c0:	8b 14 85 1c b0 10 80 	mov    -0x7fef4fe4(,%eax,4),%edx
801060c7:	c7 04 c5 a2 6a 11 80 	movl   $0x8e000008,-0x7fee955e(,%eax,8)
801060ce:	08 00 00 8e 
801060d2:	66 89 14 c5 a0 6a 11 	mov    %dx,-0x7fee9560(,%eax,8)
801060d9:	80 
801060da:	c1 ea 10             	shr    $0x10,%edx
801060dd:	66 89 14 c5 a6 6a 11 	mov    %dx,-0x7fee955a(,%eax,8)
801060e4:	80 
  for(i = 0; i < 256; i++)
801060e5:	83 c0 01             	add    $0x1,%eax
801060e8:	3d 00 01 00 00       	cmp    $0x100,%eax
801060ed:	75 d1                	jne    801060c0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
801060ef:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801060f2:	a1 1c b1 10 80       	mov    0x8010b11c,%eax
801060f7:	c7 05 a2 6c 11 80 08 	movl   $0xef000008,0x80116ca2
801060fe:	00 00 ef 
  initlock(&tickslock, "time");
80106101:	68 c5 80 10 80       	push   $0x801080c5
80106106:	68 60 6a 11 80       	push   $0x80116a60
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010610b:	66 a3 a0 6c 11 80    	mov    %ax,0x80116ca0
80106111:	c1 e8 10             	shr    $0x10,%eax
80106114:	66 a3 a6 6c 11 80    	mov    %ax,0x80116ca6
  initlock(&tickslock, "time");
8010611a:	e8 f1 e9 ff ff       	call   80104b10 <initlock>
}
8010611f:	83 c4 10             	add    $0x10,%esp
80106122:	c9                   	leave  
80106123:	c3                   	ret    
80106124:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010612b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010612f:	90                   	nop

80106130 <idtinit>:

void
idtinit(void)
{
80106130:	f3 0f 1e fb          	endbr32 
80106134:	55                   	push   %ebp
  pd[0] = size-1;
80106135:	b8 ff 07 00 00       	mov    $0x7ff,%eax
8010613a:	89 e5                	mov    %esp,%ebp
8010613c:	83 ec 10             	sub    $0x10,%esp
8010613f:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106143:	b8 a0 6a 11 80       	mov    $0x80116aa0,%eax
80106148:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
8010614c:	c1 e8 10             	shr    $0x10,%eax
8010614f:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80106153:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106156:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106159:	c9                   	leave  
8010615a:	c3                   	ret    
8010615b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010615f:	90                   	nop

80106160 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106160:	f3 0f 1e fb          	endbr32 
80106164:	55                   	push   %ebp
80106165:	89 e5                	mov    %esp,%ebp
80106167:	57                   	push   %edi
80106168:	56                   	push   %esi
80106169:	53                   	push   %ebx
8010616a:	83 ec 1c             	sub    $0x1c,%esp
8010616d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80106170:	8b 43 30             	mov    0x30(%ebx),%eax
80106173:	83 f8 40             	cmp    $0x40,%eax
80106176:	0f 84 c4 01 00 00    	je     80106340 <trap+0x1e0>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
8010617c:	83 e8 20             	sub    $0x20,%eax
8010617f:	83 f8 1f             	cmp    $0x1f,%eax
80106182:	77 08                	ja     8010618c <trap+0x2c>
80106184:	3e ff 24 85 6c 81 10 	notrack jmp *-0x7fef7e94(,%eax,4)
8010618b:	80 
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
8010618c:	e8 6f d8 ff ff       	call   80103a00 <myproc>
80106191:	8b 7b 38             	mov    0x38(%ebx),%edi
80106194:	85 c0                	test   %eax,%eax
80106196:	0f 84 f3 01 00 00    	je     8010638f <trap+0x22f>
8010619c:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
801061a0:	0f 84 e9 01 00 00    	je     8010638f <trap+0x22f>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801061a6:	0f 20 d1             	mov    %cr2,%ecx
801061a9:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801061ac:	e8 2f d8 ff ff       	call   801039e0 <cpuid>
801061b1:	8b 73 30             	mov    0x30(%ebx),%esi
801061b4:	89 45 dc             	mov    %eax,-0x24(%ebp)
801061b7:	8b 43 34             	mov    0x34(%ebx),%eax
801061ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801061bd:	e8 3e d8 ff ff       	call   80103a00 <myproc>
801061c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
801061c5:	e8 36 d8 ff ff       	call   80103a00 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801061ca:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801061cd:	8b 55 dc             	mov    -0x24(%ebp),%edx
801061d0:	51                   	push   %ecx
801061d1:	57                   	push   %edi
801061d2:	52                   	push   %edx
801061d3:	ff 75 e4             	pushl  -0x1c(%ebp)
801061d6:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
801061d7:	8b 75 e0             	mov    -0x20(%ebp),%esi
801061da:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801061dd:	56                   	push   %esi
801061de:	ff 70 10             	pushl  0x10(%eax)
801061e1:	68 28 81 10 80       	push   $0x80108128
801061e6:	e8 c5 a4 ff ff       	call   801006b0 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
801061eb:	83 c4 20             	add    $0x20,%esp
801061ee:	e8 0d d8 ff ff       	call   80103a00 <myproc>
801061f3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801061fa:	e8 01 d8 ff ff       	call   80103a00 <myproc>
801061ff:	85 c0                	test   %eax,%eax
80106201:	74 1d                	je     80106220 <trap+0xc0>
80106203:	e8 f8 d7 ff ff       	call   80103a00 <myproc>
80106208:	8b 50 24             	mov    0x24(%eax),%edx
8010620b:	85 d2                	test   %edx,%edx
8010620d:	74 11                	je     80106220 <trap+0xc0>
8010620f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106213:	83 e0 03             	and    $0x3,%eax
80106216:	66 83 f8 03          	cmp    $0x3,%ax
8010621a:	0f 84 58 01 00 00    	je     80106378 <trap+0x218>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80106220:	e8 db d7 ff ff       	call   80103a00 <myproc>
80106225:	85 c0                	test   %eax,%eax
80106227:	74 0f                	je     80106238 <trap+0xd8>
80106229:	e8 d2 d7 ff ff       	call   80103a00 <myproc>
8010622e:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106232:	0f 84 f0 00 00 00    	je     80106328 <trap+0x1c8>
    yield();
    #endif

  }
  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106238:	e8 c3 d7 ff ff       	call   80103a00 <myproc>
8010623d:	85 c0                	test   %eax,%eax
8010623f:	74 1d                	je     8010625e <trap+0xfe>
80106241:	e8 ba d7 ff ff       	call   80103a00 <myproc>
80106246:	8b 40 24             	mov    0x24(%eax),%eax
80106249:	85 c0                	test   %eax,%eax
8010624b:	74 11                	je     8010625e <trap+0xfe>
8010624d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106251:	83 e0 03             	and    $0x3,%eax
80106254:	66 83 f8 03          	cmp    $0x3,%ax
80106258:	0f 84 0b 01 00 00    	je     80106369 <trap+0x209>
    exit();
}
8010625e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106261:	5b                   	pop    %ebx
80106262:	5e                   	pop    %esi
80106263:	5f                   	pop    %edi
80106264:	5d                   	pop    %ebp
80106265:	c3                   	ret    
    ideintr();
80106266:	e8 85 bf ff ff       	call   801021f0 <ideintr>
    lapiceoi();
8010626b:	e8 60 c6 ff ff       	call   801028d0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106270:	e8 8b d7 ff ff       	call   80103a00 <myproc>
80106275:	85 c0                	test   %eax,%eax
80106277:	75 8a                	jne    80106203 <trap+0xa3>
80106279:	eb a5                	jmp    80106220 <trap+0xc0>
    if(cpuid() == 0){
8010627b:	e8 60 d7 ff ff       	call   801039e0 <cpuid>
80106280:	85 c0                	test   %eax,%eax
80106282:	75 e7                	jne    8010626b <trap+0x10b>
      acquire(&tickslock);
80106284:	83 ec 0c             	sub    $0xc,%esp
80106287:	68 60 6a 11 80       	push   $0x80116a60
8010628c:	e8 ff e9 ff ff       	call   80104c90 <acquire>
      wakeup(&ticks);
80106291:	c7 04 24 a0 72 11 80 	movl   $0x801172a0,(%esp)
      ticks++;
80106298:	83 05 a0 72 11 80 01 	addl   $0x1,0x801172a0
      wakeup(&ticks);
8010629f:	e8 1c e2 ff ff       	call   801044c0 <wakeup>
      release(&tickslock);
801062a4:	c7 04 24 60 6a 11 80 	movl   $0x80116a60,(%esp)
801062ab:	e8 a0 ea ff ff       	call   80104d50 <release>
      updatetimes();
801062b0:	e8 1b da ff ff       	call   80103cd0 <updatetimes>
801062b5:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
801062b8:	eb b1                	jmp    8010626b <trap+0x10b>
    kbdintr();
801062ba:	e8 d1 c4 ff ff       	call   80102790 <kbdintr>
    lapiceoi();
801062bf:	e8 0c c6 ff ff       	call   801028d0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801062c4:	e8 37 d7 ff ff       	call   80103a00 <myproc>
801062c9:	85 c0                	test   %eax,%eax
801062cb:	0f 85 32 ff ff ff    	jne    80106203 <trap+0xa3>
801062d1:	e9 4a ff ff ff       	jmp    80106220 <trap+0xc0>
    uartintr();
801062d6:	e8 55 02 00 00       	call   80106530 <uartintr>
    lapiceoi();
801062db:	e8 f0 c5 ff ff       	call   801028d0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801062e0:	e8 1b d7 ff ff       	call   80103a00 <myproc>
801062e5:	85 c0                	test   %eax,%eax
801062e7:	0f 85 16 ff ff ff    	jne    80106203 <trap+0xa3>
801062ed:	e9 2e ff ff ff       	jmp    80106220 <trap+0xc0>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801062f2:	8b 7b 38             	mov    0x38(%ebx),%edi
801062f5:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
801062f9:	e8 e2 d6 ff ff       	call   801039e0 <cpuid>
801062fe:	57                   	push   %edi
801062ff:	56                   	push   %esi
80106300:	50                   	push   %eax
80106301:	68 d0 80 10 80       	push   $0x801080d0
80106306:	e8 a5 a3 ff ff       	call   801006b0 <cprintf>
    lapiceoi();
8010630b:	e8 c0 c5 ff ff       	call   801028d0 <lapiceoi>
    break;
80106310:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106313:	e8 e8 d6 ff ff       	call   80103a00 <myproc>
80106318:	85 c0                	test   %eax,%eax
8010631a:	0f 85 e3 fe ff ff    	jne    80106203 <trap+0xa3>
80106320:	e9 fb fe ff ff       	jmp    80106220 <trap+0xc0>
80106325:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80106328:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
8010632c:	0f 85 06 ff ff ff    	jne    80106238 <trap+0xd8>
    yield();
80106332:	e8 a9 dd ff ff       	call   801040e0 <yield>
80106337:	e9 fc fe ff ff       	jmp    80106238 <trap+0xd8>
8010633c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80106340:	e8 bb d6 ff ff       	call   80103a00 <myproc>
80106345:	8b 70 24             	mov    0x24(%eax),%esi
80106348:	85 f6                	test   %esi,%esi
8010634a:	75 3c                	jne    80106388 <trap+0x228>
    myproc()->tf = tf;
8010634c:	e8 af d6 ff ff       	call   80103a00 <myproc>
80106351:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80106354:	e8 17 ee ff ff       	call   80105170 <syscall>
    if(myproc()->killed)
80106359:	e8 a2 d6 ff ff       	call   80103a00 <myproc>
8010635e:	8b 48 24             	mov    0x24(%eax),%ecx
80106361:	85 c9                	test   %ecx,%ecx
80106363:	0f 84 f5 fe ff ff    	je     8010625e <trap+0xfe>
}
80106369:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010636c:	5b                   	pop    %ebx
8010636d:	5e                   	pop    %esi
8010636e:	5f                   	pop    %edi
8010636f:	5d                   	pop    %ebp
      exit();
80106370:	e9 0b dc ff ff       	jmp    80103f80 <exit>
80106375:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
80106378:	e8 03 dc ff ff       	call   80103f80 <exit>
8010637d:	e9 9e fe ff ff       	jmp    80106220 <trap+0xc0>
80106382:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106388:	e8 f3 db ff ff       	call   80103f80 <exit>
8010638d:	eb bd                	jmp    8010634c <trap+0x1ec>
8010638f:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106392:	e8 49 d6 ff ff       	call   801039e0 <cpuid>
80106397:	83 ec 0c             	sub    $0xc,%esp
8010639a:	56                   	push   %esi
8010639b:	57                   	push   %edi
8010639c:	50                   	push   %eax
8010639d:	ff 73 30             	pushl  0x30(%ebx)
801063a0:	68 f4 80 10 80       	push   $0x801080f4
801063a5:	e8 06 a3 ff ff       	call   801006b0 <cprintf>
      panic("trap");
801063aa:	83 c4 14             	add    $0x14,%esp
801063ad:	68 ca 80 10 80       	push   $0x801080ca
801063b2:	e8 d9 9f ff ff       	call   80100390 <panic>
801063b7:	66 90                	xchg   %ax,%ax
801063b9:	66 90                	xchg   %ax,%ax
801063bb:	66 90                	xchg   %ax,%ax
801063bd:	66 90                	xchg   %ax,%ax
801063bf:	90                   	nop

801063c0 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
801063c0:	f3 0f 1e fb          	endbr32 
  if(!uart)
801063c4:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
801063c9:	85 c0                	test   %eax,%eax
801063cb:	74 1b                	je     801063e8 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801063cd:	ba fd 03 00 00       	mov    $0x3fd,%edx
801063d2:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801063d3:	a8 01                	test   $0x1,%al
801063d5:	74 11                	je     801063e8 <uartgetc+0x28>
801063d7:	ba f8 03 00 00       	mov    $0x3f8,%edx
801063dc:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801063dd:	0f b6 c0             	movzbl %al,%eax
801063e0:	c3                   	ret    
801063e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801063e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801063ed:	c3                   	ret    
801063ee:	66 90                	xchg   %ax,%ax

801063f0 <uartputc.part.0>:
uartputc(int c)
801063f0:	55                   	push   %ebp
801063f1:	89 e5                	mov    %esp,%ebp
801063f3:	57                   	push   %edi
801063f4:	89 c7                	mov    %eax,%edi
801063f6:	56                   	push   %esi
801063f7:	be fd 03 00 00       	mov    $0x3fd,%esi
801063fc:	53                   	push   %ebx
801063fd:	bb 80 00 00 00       	mov    $0x80,%ebx
80106402:	83 ec 0c             	sub    $0xc,%esp
80106405:	eb 1b                	jmp    80106422 <uartputc.part.0+0x32>
80106407:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010640e:	66 90                	xchg   %ax,%ax
    microdelay(10);
80106410:	83 ec 0c             	sub    $0xc,%esp
80106413:	6a 0a                	push   $0xa
80106415:	e8 d6 c4 ff ff       	call   801028f0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010641a:	83 c4 10             	add    $0x10,%esp
8010641d:	83 eb 01             	sub    $0x1,%ebx
80106420:	74 07                	je     80106429 <uartputc.part.0+0x39>
80106422:	89 f2                	mov    %esi,%edx
80106424:	ec                   	in     (%dx),%al
80106425:	a8 20                	test   $0x20,%al
80106427:	74 e7                	je     80106410 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106429:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010642e:	89 f8                	mov    %edi,%eax
80106430:	ee                   	out    %al,(%dx)
}
80106431:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106434:	5b                   	pop    %ebx
80106435:	5e                   	pop    %esi
80106436:	5f                   	pop    %edi
80106437:	5d                   	pop    %ebp
80106438:	c3                   	ret    
80106439:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106440 <uartinit>:
{
80106440:	f3 0f 1e fb          	endbr32 
80106444:	55                   	push   %ebp
80106445:	31 c9                	xor    %ecx,%ecx
80106447:	89 c8                	mov    %ecx,%eax
80106449:	89 e5                	mov    %esp,%ebp
8010644b:	57                   	push   %edi
8010644c:	56                   	push   %esi
8010644d:	53                   	push   %ebx
8010644e:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80106453:	89 da                	mov    %ebx,%edx
80106455:	83 ec 0c             	sub    $0xc,%esp
80106458:	ee                   	out    %al,(%dx)
80106459:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010645e:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80106463:	89 fa                	mov    %edi,%edx
80106465:	ee                   	out    %al,(%dx)
80106466:	b8 0c 00 00 00       	mov    $0xc,%eax
8010646b:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106470:	ee                   	out    %al,(%dx)
80106471:	be f9 03 00 00       	mov    $0x3f9,%esi
80106476:	89 c8                	mov    %ecx,%eax
80106478:	89 f2                	mov    %esi,%edx
8010647a:	ee                   	out    %al,(%dx)
8010647b:	b8 03 00 00 00       	mov    $0x3,%eax
80106480:	89 fa                	mov    %edi,%edx
80106482:	ee                   	out    %al,(%dx)
80106483:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106488:	89 c8                	mov    %ecx,%eax
8010648a:	ee                   	out    %al,(%dx)
8010648b:	b8 01 00 00 00       	mov    $0x1,%eax
80106490:	89 f2                	mov    %esi,%edx
80106492:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106493:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106498:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106499:	3c ff                	cmp    $0xff,%al
8010649b:	74 52                	je     801064ef <uartinit+0xaf>
  uart = 1;
8010649d:	c7 05 bc b5 10 80 01 	movl   $0x1,0x8010b5bc
801064a4:	00 00 00 
801064a7:	89 da                	mov    %ebx,%edx
801064a9:	ec                   	in     (%dx),%al
801064aa:	ba f8 03 00 00       	mov    $0x3f8,%edx
801064af:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
801064b0:	83 ec 08             	sub    $0x8,%esp
801064b3:	be 76 00 00 00       	mov    $0x76,%esi
  for(p="xv6...\n"; *p; p++)
801064b8:	bb ec 81 10 80       	mov    $0x801081ec,%ebx
  ioapicenable(IRQ_COM1, 0);
801064bd:	6a 00                	push   $0x0
801064bf:	6a 04                	push   $0x4
801064c1:	e8 7a bf ff ff       	call   80102440 <ioapicenable>
801064c6:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
801064c9:	b8 78 00 00 00       	mov    $0x78,%eax
801064ce:	eb 04                	jmp    801064d4 <uartinit+0x94>
801064d0:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
801064d4:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
801064da:	85 d2                	test   %edx,%edx
801064dc:	74 08                	je     801064e6 <uartinit+0xa6>
    uartputc(*p);
801064de:	0f be c0             	movsbl %al,%eax
801064e1:	e8 0a ff ff ff       	call   801063f0 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
801064e6:	89 f0                	mov    %esi,%eax
801064e8:	83 c3 01             	add    $0x1,%ebx
801064eb:	84 c0                	test   %al,%al
801064ed:	75 e1                	jne    801064d0 <uartinit+0x90>
}
801064ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
801064f2:	5b                   	pop    %ebx
801064f3:	5e                   	pop    %esi
801064f4:	5f                   	pop    %edi
801064f5:	5d                   	pop    %ebp
801064f6:	c3                   	ret    
801064f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801064fe:	66 90                	xchg   %ax,%ax

80106500 <uartputc>:
{
80106500:	f3 0f 1e fb          	endbr32 
80106504:	55                   	push   %ebp
  if(!uart)
80106505:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
{
8010650b:	89 e5                	mov    %esp,%ebp
8010650d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80106510:	85 d2                	test   %edx,%edx
80106512:	74 0c                	je     80106520 <uartputc+0x20>
}
80106514:	5d                   	pop    %ebp
80106515:	e9 d6 fe ff ff       	jmp    801063f0 <uartputc.part.0>
8010651a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106520:	5d                   	pop    %ebp
80106521:	c3                   	ret    
80106522:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106529:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106530 <uartintr>:

void
uartintr(void)
{
80106530:	f3 0f 1e fb          	endbr32 
80106534:	55                   	push   %ebp
80106535:	89 e5                	mov    %esp,%ebp
80106537:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
8010653a:	68 c0 63 10 80       	push   $0x801063c0
8010653f:	e8 1c a3 ff ff       	call   80100860 <consoleintr>
}
80106544:	83 c4 10             	add    $0x10,%esp
80106547:	c9                   	leave  
80106548:	c3                   	ret    

80106549 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106549:	6a 00                	push   $0x0
  pushl $0
8010654b:	6a 00                	push   $0x0
  jmp alltraps
8010654d:	e9 35 fb ff ff       	jmp    80106087 <alltraps>

80106552 <vector1>:
.globl vector1
vector1:
  pushl $0
80106552:	6a 00                	push   $0x0
  pushl $1
80106554:	6a 01                	push   $0x1
  jmp alltraps
80106556:	e9 2c fb ff ff       	jmp    80106087 <alltraps>

8010655b <vector2>:
.globl vector2
vector2:
  pushl $0
8010655b:	6a 00                	push   $0x0
  pushl $2
8010655d:	6a 02                	push   $0x2
  jmp alltraps
8010655f:	e9 23 fb ff ff       	jmp    80106087 <alltraps>

80106564 <vector3>:
.globl vector3
vector3:
  pushl $0
80106564:	6a 00                	push   $0x0
  pushl $3
80106566:	6a 03                	push   $0x3
  jmp alltraps
80106568:	e9 1a fb ff ff       	jmp    80106087 <alltraps>

8010656d <vector4>:
.globl vector4
vector4:
  pushl $0
8010656d:	6a 00                	push   $0x0
  pushl $4
8010656f:	6a 04                	push   $0x4
  jmp alltraps
80106571:	e9 11 fb ff ff       	jmp    80106087 <alltraps>

80106576 <vector5>:
.globl vector5
vector5:
  pushl $0
80106576:	6a 00                	push   $0x0
  pushl $5
80106578:	6a 05                	push   $0x5
  jmp alltraps
8010657a:	e9 08 fb ff ff       	jmp    80106087 <alltraps>

8010657f <vector6>:
.globl vector6
vector6:
  pushl $0
8010657f:	6a 00                	push   $0x0
  pushl $6
80106581:	6a 06                	push   $0x6
  jmp alltraps
80106583:	e9 ff fa ff ff       	jmp    80106087 <alltraps>

80106588 <vector7>:
.globl vector7
vector7:
  pushl $0
80106588:	6a 00                	push   $0x0
  pushl $7
8010658a:	6a 07                	push   $0x7
  jmp alltraps
8010658c:	e9 f6 fa ff ff       	jmp    80106087 <alltraps>

80106591 <vector8>:
.globl vector8
vector8:
  pushl $8
80106591:	6a 08                	push   $0x8
  jmp alltraps
80106593:	e9 ef fa ff ff       	jmp    80106087 <alltraps>

80106598 <vector9>:
.globl vector9
vector9:
  pushl $0
80106598:	6a 00                	push   $0x0
  pushl $9
8010659a:	6a 09                	push   $0x9
  jmp alltraps
8010659c:	e9 e6 fa ff ff       	jmp    80106087 <alltraps>

801065a1 <vector10>:
.globl vector10
vector10:
  pushl $10
801065a1:	6a 0a                	push   $0xa
  jmp alltraps
801065a3:	e9 df fa ff ff       	jmp    80106087 <alltraps>

801065a8 <vector11>:
.globl vector11
vector11:
  pushl $11
801065a8:	6a 0b                	push   $0xb
  jmp alltraps
801065aa:	e9 d8 fa ff ff       	jmp    80106087 <alltraps>

801065af <vector12>:
.globl vector12
vector12:
  pushl $12
801065af:	6a 0c                	push   $0xc
  jmp alltraps
801065b1:	e9 d1 fa ff ff       	jmp    80106087 <alltraps>

801065b6 <vector13>:
.globl vector13
vector13:
  pushl $13
801065b6:	6a 0d                	push   $0xd
  jmp alltraps
801065b8:	e9 ca fa ff ff       	jmp    80106087 <alltraps>

801065bd <vector14>:
.globl vector14
vector14:
  pushl $14
801065bd:	6a 0e                	push   $0xe
  jmp alltraps
801065bf:	e9 c3 fa ff ff       	jmp    80106087 <alltraps>

801065c4 <vector15>:
.globl vector15
vector15:
  pushl $0
801065c4:	6a 00                	push   $0x0
  pushl $15
801065c6:	6a 0f                	push   $0xf
  jmp alltraps
801065c8:	e9 ba fa ff ff       	jmp    80106087 <alltraps>

801065cd <vector16>:
.globl vector16
vector16:
  pushl $0
801065cd:	6a 00                	push   $0x0
  pushl $16
801065cf:	6a 10                	push   $0x10
  jmp alltraps
801065d1:	e9 b1 fa ff ff       	jmp    80106087 <alltraps>

801065d6 <vector17>:
.globl vector17
vector17:
  pushl $17
801065d6:	6a 11                	push   $0x11
  jmp alltraps
801065d8:	e9 aa fa ff ff       	jmp    80106087 <alltraps>

801065dd <vector18>:
.globl vector18
vector18:
  pushl $0
801065dd:	6a 00                	push   $0x0
  pushl $18
801065df:	6a 12                	push   $0x12
  jmp alltraps
801065e1:	e9 a1 fa ff ff       	jmp    80106087 <alltraps>

801065e6 <vector19>:
.globl vector19
vector19:
  pushl $0
801065e6:	6a 00                	push   $0x0
  pushl $19
801065e8:	6a 13                	push   $0x13
  jmp alltraps
801065ea:	e9 98 fa ff ff       	jmp    80106087 <alltraps>

801065ef <vector20>:
.globl vector20
vector20:
  pushl $0
801065ef:	6a 00                	push   $0x0
  pushl $20
801065f1:	6a 14                	push   $0x14
  jmp alltraps
801065f3:	e9 8f fa ff ff       	jmp    80106087 <alltraps>

801065f8 <vector21>:
.globl vector21
vector21:
  pushl $0
801065f8:	6a 00                	push   $0x0
  pushl $21
801065fa:	6a 15                	push   $0x15
  jmp alltraps
801065fc:	e9 86 fa ff ff       	jmp    80106087 <alltraps>

80106601 <vector22>:
.globl vector22
vector22:
  pushl $0
80106601:	6a 00                	push   $0x0
  pushl $22
80106603:	6a 16                	push   $0x16
  jmp alltraps
80106605:	e9 7d fa ff ff       	jmp    80106087 <alltraps>

8010660a <vector23>:
.globl vector23
vector23:
  pushl $0
8010660a:	6a 00                	push   $0x0
  pushl $23
8010660c:	6a 17                	push   $0x17
  jmp alltraps
8010660e:	e9 74 fa ff ff       	jmp    80106087 <alltraps>

80106613 <vector24>:
.globl vector24
vector24:
  pushl $0
80106613:	6a 00                	push   $0x0
  pushl $24
80106615:	6a 18                	push   $0x18
  jmp alltraps
80106617:	e9 6b fa ff ff       	jmp    80106087 <alltraps>

8010661c <vector25>:
.globl vector25
vector25:
  pushl $0
8010661c:	6a 00                	push   $0x0
  pushl $25
8010661e:	6a 19                	push   $0x19
  jmp alltraps
80106620:	e9 62 fa ff ff       	jmp    80106087 <alltraps>

80106625 <vector26>:
.globl vector26
vector26:
  pushl $0
80106625:	6a 00                	push   $0x0
  pushl $26
80106627:	6a 1a                	push   $0x1a
  jmp alltraps
80106629:	e9 59 fa ff ff       	jmp    80106087 <alltraps>

8010662e <vector27>:
.globl vector27
vector27:
  pushl $0
8010662e:	6a 00                	push   $0x0
  pushl $27
80106630:	6a 1b                	push   $0x1b
  jmp alltraps
80106632:	e9 50 fa ff ff       	jmp    80106087 <alltraps>

80106637 <vector28>:
.globl vector28
vector28:
  pushl $0
80106637:	6a 00                	push   $0x0
  pushl $28
80106639:	6a 1c                	push   $0x1c
  jmp alltraps
8010663b:	e9 47 fa ff ff       	jmp    80106087 <alltraps>

80106640 <vector29>:
.globl vector29
vector29:
  pushl $0
80106640:	6a 00                	push   $0x0
  pushl $29
80106642:	6a 1d                	push   $0x1d
  jmp alltraps
80106644:	e9 3e fa ff ff       	jmp    80106087 <alltraps>

80106649 <vector30>:
.globl vector30
vector30:
  pushl $0
80106649:	6a 00                	push   $0x0
  pushl $30
8010664b:	6a 1e                	push   $0x1e
  jmp alltraps
8010664d:	e9 35 fa ff ff       	jmp    80106087 <alltraps>

80106652 <vector31>:
.globl vector31
vector31:
  pushl $0
80106652:	6a 00                	push   $0x0
  pushl $31
80106654:	6a 1f                	push   $0x1f
  jmp alltraps
80106656:	e9 2c fa ff ff       	jmp    80106087 <alltraps>

8010665b <vector32>:
.globl vector32
vector32:
  pushl $0
8010665b:	6a 00                	push   $0x0
  pushl $32
8010665d:	6a 20                	push   $0x20
  jmp alltraps
8010665f:	e9 23 fa ff ff       	jmp    80106087 <alltraps>

80106664 <vector33>:
.globl vector33
vector33:
  pushl $0
80106664:	6a 00                	push   $0x0
  pushl $33
80106666:	6a 21                	push   $0x21
  jmp alltraps
80106668:	e9 1a fa ff ff       	jmp    80106087 <alltraps>

8010666d <vector34>:
.globl vector34
vector34:
  pushl $0
8010666d:	6a 00                	push   $0x0
  pushl $34
8010666f:	6a 22                	push   $0x22
  jmp alltraps
80106671:	e9 11 fa ff ff       	jmp    80106087 <alltraps>

80106676 <vector35>:
.globl vector35
vector35:
  pushl $0
80106676:	6a 00                	push   $0x0
  pushl $35
80106678:	6a 23                	push   $0x23
  jmp alltraps
8010667a:	e9 08 fa ff ff       	jmp    80106087 <alltraps>

8010667f <vector36>:
.globl vector36
vector36:
  pushl $0
8010667f:	6a 00                	push   $0x0
  pushl $36
80106681:	6a 24                	push   $0x24
  jmp alltraps
80106683:	e9 ff f9 ff ff       	jmp    80106087 <alltraps>

80106688 <vector37>:
.globl vector37
vector37:
  pushl $0
80106688:	6a 00                	push   $0x0
  pushl $37
8010668a:	6a 25                	push   $0x25
  jmp alltraps
8010668c:	e9 f6 f9 ff ff       	jmp    80106087 <alltraps>

80106691 <vector38>:
.globl vector38
vector38:
  pushl $0
80106691:	6a 00                	push   $0x0
  pushl $38
80106693:	6a 26                	push   $0x26
  jmp alltraps
80106695:	e9 ed f9 ff ff       	jmp    80106087 <alltraps>

8010669a <vector39>:
.globl vector39
vector39:
  pushl $0
8010669a:	6a 00                	push   $0x0
  pushl $39
8010669c:	6a 27                	push   $0x27
  jmp alltraps
8010669e:	e9 e4 f9 ff ff       	jmp    80106087 <alltraps>

801066a3 <vector40>:
.globl vector40
vector40:
  pushl $0
801066a3:	6a 00                	push   $0x0
  pushl $40
801066a5:	6a 28                	push   $0x28
  jmp alltraps
801066a7:	e9 db f9 ff ff       	jmp    80106087 <alltraps>

801066ac <vector41>:
.globl vector41
vector41:
  pushl $0
801066ac:	6a 00                	push   $0x0
  pushl $41
801066ae:	6a 29                	push   $0x29
  jmp alltraps
801066b0:	e9 d2 f9 ff ff       	jmp    80106087 <alltraps>

801066b5 <vector42>:
.globl vector42
vector42:
  pushl $0
801066b5:	6a 00                	push   $0x0
  pushl $42
801066b7:	6a 2a                	push   $0x2a
  jmp alltraps
801066b9:	e9 c9 f9 ff ff       	jmp    80106087 <alltraps>

801066be <vector43>:
.globl vector43
vector43:
  pushl $0
801066be:	6a 00                	push   $0x0
  pushl $43
801066c0:	6a 2b                	push   $0x2b
  jmp alltraps
801066c2:	e9 c0 f9 ff ff       	jmp    80106087 <alltraps>

801066c7 <vector44>:
.globl vector44
vector44:
  pushl $0
801066c7:	6a 00                	push   $0x0
  pushl $44
801066c9:	6a 2c                	push   $0x2c
  jmp alltraps
801066cb:	e9 b7 f9 ff ff       	jmp    80106087 <alltraps>

801066d0 <vector45>:
.globl vector45
vector45:
  pushl $0
801066d0:	6a 00                	push   $0x0
  pushl $45
801066d2:	6a 2d                	push   $0x2d
  jmp alltraps
801066d4:	e9 ae f9 ff ff       	jmp    80106087 <alltraps>

801066d9 <vector46>:
.globl vector46
vector46:
  pushl $0
801066d9:	6a 00                	push   $0x0
  pushl $46
801066db:	6a 2e                	push   $0x2e
  jmp alltraps
801066dd:	e9 a5 f9 ff ff       	jmp    80106087 <alltraps>

801066e2 <vector47>:
.globl vector47
vector47:
  pushl $0
801066e2:	6a 00                	push   $0x0
  pushl $47
801066e4:	6a 2f                	push   $0x2f
  jmp alltraps
801066e6:	e9 9c f9 ff ff       	jmp    80106087 <alltraps>

801066eb <vector48>:
.globl vector48
vector48:
  pushl $0
801066eb:	6a 00                	push   $0x0
  pushl $48
801066ed:	6a 30                	push   $0x30
  jmp alltraps
801066ef:	e9 93 f9 ff ff       	jmp    80106087 <alltraps>

801066f4 <vector49>:
.globl vector49
vector49:
  pushl $0
801066f4:	6a 00                	push   $0x0
  pushl $49
801066f6:	6a 31                	push   $0x31
  jmp alltraps
801066f8:	e9 8a f9 ff ff       	jmp    80106087 <alltraps>

801066fd <vector50>:
.globl vector50
vector50:
  pushl $0
801066fd:	6a 00                	push   $0x0
  pushl $50
801066ff:	6a 32                	push   $0x32
  jmp alltraps
80106701:	e9 81 f9 ff ff       	jmp    80106087 <alltraps>

80106706 <vector51>:
.globl vector51
vector51:
  pushl $0
80106706:	6a 00                	push   $0x0
  pushl $51
80106708:	6a 33                	push   $0x33
  jmp alltraps
8010670a:	e9 78 f9 ff ff       	jmp    80106087 <alltraps>

8010670f <vector52>:
.globl vector52
vector52:
  pushl $0
8010670f:	6a 00                	push   $0x0
  pushl $52
80106711:	6a 34                	push   $0x34
  jmp alltraps
80106713:	e9 6f f9 ff ff       	jmp    80106087 <alltraps>

80106718 <vector53>:
.globl vector53
vector53:
  pushl $0
80106718:	6a 00                	push   $0x0
  pushl $53
8010671a:	6a 35                	push   $0x35
  jmp alltraps
8010671c:	e9 66 f9 ff ff       	jmp    80106087 <alltraps>

80106721 <vector54>:
.globl vector54
vector54:
  pushl $0
80106721:	6a 00                	push   $0x0
  pushl $54
80106723:	6a 36                	push   $0x36
  jmp alltraps
80106725:	e9 5d f9 ff ff       	jmp    80106087 <alltraps>

8010672a <vector55>:
.globl vector55
vector55:
  pushl $0
8010672a:	6a 00                	push   $0x0
  pushl $55
8010672c:	6a 37                	push   $0x37
  jmp alltraps
8010672e:	e9 54 f9 ff ff       	jmp    80106087 <alltraps>

80106733 <vector56>:
.globl vector56
vector56:
  pushl $0
80106733:	6a 00                	push   $0x0
  pushl $56
80106735:	6a 38                	push   $0x38
  jmp alltraps
80106737:	e9 4b f9 ff ff       	jmp    80106087 <alltraps>

8010673c <vector57>:
.globl vector57
vector57:
  pushl $0
8010673c:	6a 00                	push   $0x0
  pushl $57
8010673e:	6a 39                	push   $0x39
  jmp alltraps
80106740:	e9 42 f9 ff ff       	jmp    80106087 <alltraps>

80106745 <vector58>:
.globl vector58
vector58:
  pushl $0
80106745:	6a 00                	push   $0x0
  pushl $58
80106747:	6a 3a                	push   $0x3a
  jmp alltraps
80106749:	e9 39 f9 ff ff       	jmp    80106087 <alltraps>

8010674e <vector59>:
.globl vector59
vector59:
  pushl $0
8010674e:	6a 00                	push   $0x0
  pushl $59
80106750:	6a 3b                	push   $0x3b
  jmp alltraps
80106752:	e9 30 f9 ff ff       	jmp    80106087 <alltraps>

80106757 <vector60>:
.globl vector60
vector60:
  pushl $0
80106757:	6a 00                	push   $0x0
  pushl $60
80106759:	6a 3c                	push   $0x3c
  jmp alltraps
8010675b:	e9 27 f9 ff ff       	jmp    80106087 <alltraps>

80106760 <vector61>:
.globl vector61
vector61:
  pushl $0
80106760:	6a 00                	push   $0x0
  pushl $61
80106762:	6a 3d                	push   $0x3d
  jmp alltraps
80106764:	e9 1e f9 ff ff       	jmp    80106087 <alltraps>

80106769 <vector62>:
.globl vector62
vector62:
  pushl $0
80106769:	6a 00                	push   $0x0
  pushl $62
8010676b:	6a 3e                	push   $0x3e
  jmp alltraps
8010676d:	e9 15 f9 ff ff       	jmp    80106087 <alltraps>

80106772 <vector63>:
.globl vector63
vector63:
  pushl $0
80106772:	6a 00                	push   $0x0
  pushl $63
80106774:	6a 3f                	push   $0x3f
  jmp alltraps
80106776:	e9 0c f9 ff ff       	jmp    80106087 <alltraps>

8010677b <vector64>:
.globl vector64
vector64:
  pushl $0
8010677b:	6a 00                	push   $0x0
  pushl $64
8010677d:	6a 40                	push   $0x40
  jmp alltraps
8010677f:	e9 03 f9 ff ff       	jmp    80106087 <alltraps>

80106784 <vector65>:
.globl vector65
vector65:
  pushl $0
80106784:	6a 00                	push   $0x0
  pushl $65
80106786:	6a 41                	push   $0x41
  jmp alltraps
80106788:	e9 fa f8 ff ff       	jmp    80106087 <alltraps>

8010678d <vector66>:
.globl vector66
vector66:
  pushl $0
8010678d:	6a 00                	push   $0x0
  pushl $66
8010678f:	6a 42                	push   $0x42
  jmp alltraps
80106791:	e9 f1 f8 ff ff       	jmp    80106087 <alltraps>

80106796 <vector67>:
.globl vector67
vector67:
  pushl $0
80106796:	6a 00                	push   $0x0
  pushl $67
80106798:	6a 43                	push   $0x43
  jmp alltraps
8010679a:	e9 e8 f8 ff ff       	jmp    80106087 <alltraps>

8010679f <vector68>:
.globl vector68
vector68:
  pushl $0
8010679f:	6a 00                	push   $0x0
  pushl $68
801067a1:	6a 44                	push   $0x44
  jmp alltraps
801067a3:	e9 df f8 ff ff       	jmp    80106087 <alltraps>

801067a8 <vector69>:
.globl vector69
vector69:
  pushl $0
801067a8:	6a 00                	push   $0x0
  pushl $69
801067aa:	6a 45                	push   $0x45
  jmp alltraps
801067ac:	e9 d6 f8 ff ff       	jmp    80106087 <alltraps>

801067b1 <vector70>:
.globl vector70
vector70:
  pushl $0
801067b1:	6a 00                	push   $0x0
  pushl $70
801067b3:	6a 46                	push   $0x46
  jmp alltraps
801067b5:	e9 cd f8 ff ff       	jmp    80106087 <alltraps>

801067ba <vector71>:
.globl vector71
vector71:
  pushl $0
801067ba:	6a 00                	push   $0x0
  pushl $71
801067bc:	6a 47                	push   $0x47
  jmp alltraps
801067be:	e9 c4 f8 ff ff       	jmp    80106087 <alltraps>

801067c3 <vector72>:
.globl vector72
vector72:
  pushl $0
801067c3:	6a 00                	push   $0x0
  pushl $72
801067c5:	6a 48                	push   $0x48
  jmp alltraps
801067c7:	e9 bb f8 ff ff       	jmp    80106087 <alltraps>

801067cc <vector73>:
.globl vector73
vector73:
  pushl $0
801067cc:	6a 00                	push   $0x0
  pushl $73
801067ce:	6a 49                	push   $0x49
  jmp alltraps
801067d0:	e9 b2 f8 ff ff       	jmp    80106087 <alltraps>

801067d5 <vector74>:
.globl vector74
vector74:
  pushl $0
801067d5:	6a 00                	push   $0x0
  pushl $74
801067d7:	6a 4a                	push   $0x4a
  jmp alltraps
801067d9:	e9 a9 f8 ff ff       	jmp    80106087 <alltraps>

801067de <vector75>:
.globl vector75
vector75:
  pushl $0
801067de:	6a 00                	push   $0x0
  pushl $75
801067e0:	6a 4b                	push   $0x4b
  jmp alltraps
801067e2:	e9 a0 f8 ff ff       	jmp    80106087 <alltraps>

801067e7 <vector76>:
.globl vector76
vector76:
  pushl $0
801067e7:	6a 00                	push   $0x0
  pushl $76
801067e9:	6a 4c                	push   $0x4c
  jmp alltraps
801067eb:	e9 97 f8 ff ff       	jmp    80106087 <alltraps>

801067f0 <vector77>:
.globl vector77
vector77:
  pushl $0
801067f0:	6a 00                	push   $0x0
  pushl $77
801067f2:	6a 4d                	push   $0x4d
  jmp alltraps
801067f4:	e9 8e f8 ff ff       	jmp    80106087 <alltraps>

801067f9 <vector78>:
.globl vector78
vector78:
  pushl $0
801067f9:	6a 00                	push   $0x0
  pushl $78
801067fb:	6a 4e                	push   $0x4e
  jmp alltraps
801067fd:	e9 85 f8 ff ff       	jmp    80106087 <alltraps>

80106802 <vector79>:
.globl vector79
vector79:
  pushl $0
80106802:	6a 00                	push   $0x0
  pushl $79
80106804:	6a 4f                	push   $0x4f
  jmp alltraps
80106806:	e9 7c f8 ff ff       	jmp    80106087 <alltraps>

8010680b <vector80>:
.globl vector80
vector80:
  pushl $0
8010680b:	6a 00                	push   $0x0
  pushl $80
8010680d:	6a 50                	push   $0x50
  jmp alltraps
8010680f:	e9 73 f8 ff ff       	jmp    80106087 <alltraps>

80106814 <vector81>:
.globl vector81
vector81:
  pushl $0
80106814:	6a 00                	push   $0x0
  pushl $81
80106816:	6a 51                	push   $0x51
  jmp alltraps
80106818:	e9 6a f8 ff ff       	jmp    80106087 <alltraps>

8010681d <vector82>:
.globl vector82
vector82:
  pushl $0
8010681d:	6a 00                	push   $0x0
  pushl $82
8010681f:	6a 52                	push   $0x52
  jmp alltraps
80106821:	e9 61 f8 ff ff       	jmp    80106087 <alltraps>

80106826 <vector83>:
.globl vector83
vector83:
  pushl $0
80106826:	6a 00                	push   $0x0
  pushl $83
80106828:	6a 53                	push   $0x53
  jmp alltraps
8010682a:	e9 58 f8 ff ff       	jmp    80106087 <alltraps>

8010682f <vector84>:
.globl vector84
vector84:
  pushl $0
8010682f:	6a 00                	push   $0x0
  pushl $84
80106831:	6a 54                	push   $0x54
  jmp alltraps
80106833:	e9 4f f8 ff ff       	jmp    80106087 <alltraps>

80106838 <vector85>:
.globl vector85
vector85:
  pushl $0
80106838:	6a 00                	push   $0x0
  pushl $85
8010683a:	6a 55                	push   $0x55
  jmp alltraps
8010683c:	e9 46 f8 ff ff       	jmp    80106087 <alltraps>

80106841 <vector86>:
.globl vector86
vector86:
  pushl $0
80106841:	6a 00                	push   $0x0
  pushl $86
80106843:	6a 56                	push   $0x56
  jmp alltraps
80106845:	e9 3d f8 ff ff       	jmp    80106087 <alltraps>

8010684a <vector87>:
.globl vector87
vector87:
  pushl $0
8010684a:	6a 00                	push   $0x0
  pushl $87
8010684c:	6a 57                	push   $0x57
  jmp alltraps
8010684e:	e9 34 f8 ff ff       	jmp    80106087 <alltraps>

80106853 <vector88>:
.globl vector88
vector88:
  pushl $0
80106853:	6a 00                	push   $0x0
  pushl $88
80106855:	6a 58                	push   $0x58
  jmp alltraps
80106857:	e9 2b f8 ff ff       	jmp    80106087 <alltraps>

8010685c <vector89>:
.globl vector89
vector89:
  pushl $0
8010685c:	6a 00                	push   $0x0
  pushl $89
8010685e:	6a 59                	push   $0x59
  jmp alltraps
80106860:	e9 22 f8 ff ff       	jmp    80106087 <alltraps>

80106865 <vector90>:
.globl vector90
vector90:
  pushl $0
80106865:	6a 00                	push   $0x0
  pushl $90
80106867:	6a 5a                	push   $0x5a
  jmp alltraps
80106869:	e9 19 f8 ff ff       	jmp    80106087 <alltraps>

8010686e <vector91>:
.globl vector91
vector91:
  pushl $0
8010686e:	6a 00                	push   $0x0
  pushl $91
80106870:	6a 5b                	push   $0x5b
  jmp alltraps
80106872:	e9 10 f8 ff ff       	jmp    80106087 <alltraps>

80106877 <vector92>:
.globl vector92
vector92:
  pushl $0
80106877:	6a 00                	push   $0x0
  pushl $92
80106879:	6a 5c                	push   $0x5c
  jmp alltraps
8010687b:	e9 07 f8 ff ff       	jmp    80106087 <alltraps>

80106880 <vector93>:
.globl vector93
vector93:
  pushl $0
80106880:	6a 00                	push   $0x0
  pushl $93
80106882:	6a 5d                	push   $0x5d
  jmp alltraps
80106884:	e9 fe f7 ff ff       	jmp    80106087 <alltraps>

80106889 <vector94>:
.globl vector94
vector94:
  pushl $0
80106889:	6a 00                	push   $0x0
  pushl $94
8010688b:	6a 5e                	push   $0x5e
  jmp alltraps
8010688d:	e9 f5 f7 ff ff       	jmp    80106087 <alltraps>

80106892 <vector95>:
.globl vector95
vector95:
  pushl $0
80106892:	6a 00                	push   $0x0
  pushl $95
80106894:	6a 5f                	push   $0x5f
  jmp alltraps
80106896:	e9 ec f7 ff ff       	jmp    80106087 <alltraps>

8010689b <vector96>:
.globl vector96
vector96:
  pushl $0
8010689b:	6a 00                	push   $0x0
  pushl $96
8010689d:	6a 60                	push   $0x60
  jmp alltraps
8010689f:	e9 e3 f7 ff ff       	jmp    80106087 <alltraps>

801068a4 <vector97>:
.globl vector97
vector97:
  pushl $0
801068a4:	6a 00                	push   $0x0
  pushl $97
801068a6:	6a 61                	push   $0x61
  jmp alltraps
801068a8:	e9 da f7 ff ff       	jmp    80106087 <alltraps>

801068ad <vector98>:
.globl vector98
vector98:
  pushl $0
801068ad:	6a 00                	push   $0x0
  pushl $98
801068af:	6a 62                	push   $0x62
  jmp alltraps
801068b1:	e9 d1 f7 ff ff       	jmp    80106087 <alltraps>

801068b6 <vector99>:
.globl vector99
vector99:
  pushl $0
801068b6:	6a 00                	push   $0x0
  pushl $99
801068b8:	6a 63                	push   $0x63
  jmp alltraps
801068ba:	e9 c8 f7 ff ff       	jmp    80106087 <alltraps>

801068bf <vector100>:
.globl vector100
vector100:
  pushl $0
801068bf:	6a 00                	push   $0x0
  pushl $100
801068c1:	6a 64                	push   $0x64
  jmp alltraps
801068c3:	e9 bf f7 ff ff       	jmp    80106087 <alltraps>

801068c8 <vector101>:
.globl vector101
vector101:
  pushl $0
801068c8:	6a 00                	push   $0x0
  pushl $101
801068ca:	6a 65                	push   $0x65
  jmp alltraps
801068cc:	e9 b6 f7 ff ff       	jmp    80106087 <alltraps>

801068d1 <vector102>:
.globl vector102
vector102:
  pushl $0
801068d1:	6a 00                	push   $0x0
  pushl $102
801068d3:	6a 66                	push   $0x66
  jmp alltraps
801068d5:	e9 ad f7 ff ff       	jmp    80106087 <alltraps>

801068da <vector103>:
.globl vector103
vector103:
  pushl $0
801068da:	6a 00                	push   $0x0
  pushl $103
801068dc:	6a 67                	push   $0x67
  jmp alltraps
801068de:	e9 a4 f7 ff ff       	jmp    80106087 <alltraps>

801068e3 <vector104>:
.globl vector104
vector104:
  pushl $0
801068e3:	6a 00                	push   $0x0
  pushl $104
801068e5:	6a 68                	push   $0x68
  jmp alltraps
801068e7:	e9 9b f7 ff ff       	jmp    80106087 <alltraps>

801068ec <vector105>:
.globl vector105
vector105:
  pushl $0
801068ec:	6a 00                	push   $0x0
  pushl $105
801068ee:	6a 69                	push   $0x69
  jmp alltraps
801068f0:	e9 92 f7 ff ff       	jmp    80106087 <alltraps>

801068f5 <vector106>:
.globl vector106
vector106:
  pushl $0
801068f5:	6a 00                	push   $0x0
  pushl $106
801068f7:	6a 6a                	push   $0x6a
  jmp alltraps
801068f9:	e9 89 f7 ff ff       	jmp    80106087 <alltraps>

801068fe <vector107>:
.globl vector107
vector107:
  pushl $0
801068fe:	6a 00                	push   $0x0
  pushl $107
80106900:	6a 6b                	push   $0x6b
  jmp alltraps
80106902:	e9 80 f7 ff ff       	jmp    80106087 <alltraps>

80106907 <vector108>:
.globl vector108
vector108:
  pushl $0
80106907:	6a 00                	push   $0x0
  pushl $108
80106909:	6a 6c                	push   $0x6c
  jmp alltraps
8010690b:	e9 77 f7 ff ff       	jmp    80106087 <alltraps>

80106910 <vector109>:
.globl vector109
vector109:
  pushl $0
80106910:	6a 00                	push   $0x0
  pushl $109
80106912:	6a 6d                	push   $0x6d
  jmp alltraps
80106914:	e9 6e f7 ff ff       	jmp    80106087 <alltraps>

80106919 <vector110>:
.globl vector110
vector110:
  pushl $0
80106919:	6a 00                	push   $0x0
  pushl $110
8010691b:	6a 6e                	push   $0x6e
  jmp alltraps
8010691d:	e9 65 f7 ff ff       	jmp    80106087 <alltraps>

80106922 <vector111>:
.globl vector111
vector111:
  pushl $0
80106922:	6a 00                	push   $0x0
  pushl $111
80106924:	6a 6f                	push   $0x6f
  jmp alltraps
80106926:	e9 5c f7 ff ff       	jmp    80106087 <alltraps>

8010692b <vector112>:
.globl vector112
vector112:
  pushl $0
8010692b:	6a 00                	push   $0x0
  pushl $112
8010692d:	6a 70                	push   $0x70
  jmp alltraps
8010692f:	e9 53 f7 ff ff       	jmp    80106087 <alltraps>

80106934 <vector113>:
.globl vector113
vector113:
  pushl $0
80106934:	6a 00                	push   $0x0
  pushl $113
80106936:	6a 71                	push   $0x71
  jmp alltraps
80106938:	e9 4a f7 ff ff       	jmp    80106087 <alltraps>

8010693d <vector114>:
.globl vector114
vector114:
  pushl $0
8010693d:	6a 00                	push   $0x0
  pushl $114
8010693f:	6a 72                	push   $0x72
  jmp alltraps
80106941:	e9 41 f7 ff ff       	jmp    80106087 <alltraps>

80106946 <vector115>:
.globl vector115
vector115:
  pushl $0
80106946:	6a 00                	push   $0x0
  pushl $115
80106948:	6a 73                	push   $0x73
  jmp alltraps
8010694a:	e9 38 f7 ff ff       	jmp    80106087 <alltraps>

8010694f <vector116>:
.globl vector116
vector116:
  pushl $0
8010694f:	6a 00                	push   $0x0
  pushl $116
80106951:	6a 74                	push   $0x74
  jmp alltraps
80106953:	e9 2f f7 ff ff       	jmp    80106087 <alltraps>

80106958 <vector117>:
.globl vector117
vector117:
  pushl $0
80106958:	6a 00                	push   $0x0
  pushl $117
8010695a:	6a 75                	push   $0x75
  jmp alltraps
8010695c:	e9 26 f7 ff ff       	jmp    80106087 <alltraps>

80106961 <vector118>:
.globl vector118
vector118:
  pushl $0
80106961:	6a 00                	push   $0x0
  pushl $118
80106963:	6a 76                	push   $0x76
  jmp alltraps
80106965:	e9 1d f7 ff ff       	jmp    80106087 <alltraps>

8010696a <vector119>:
.globl vector119
vector119:
  pushl $0
8010696a:	6a 00                	push   $0x0
  pushl $119
8010696c:	6a 77                	push   $0x77
  jmp alltraps
8010696e:	e9 14 f7 ff ff       	jmp    80106087 <alltraps>

80106973 <vector120>:
.globl vector120
vector120:
  pushl $0
80106973:	6a 00                	push   $0x0
  pushl $120
80106975:	6a 78                	push   $0x78
  jmp alltraps
80106977:	e9 0b f7 ff ff       	jmp    80106087 <alltraps>

8010697c <vector121>:
.globl vector121
vector121:
  pushl $0
8010697c:	6a 00                	push   $0x0
  pushl $121
8010697e:	6a 79                	push   $0x79
  jmp alltraps
80106980:	e9 02 f7 ff ff       	jmp    80106087 <alltraps>

80106985 <vector122>:
.globl vector122
vector122:
  pushl $0
80106985:	6a 00                	push   $0x0
  pushl $122
80106987:	6a 7a                	push   $0x7a
  jmp alltraps
80106989:	e9 f9 f6 ff ff       	jmp    80106087 <alltraps>

8010698e <vector123>:
.globl vector123
vector123:
  pushl $0
8010698e:	6a 00                	push   $0x0
  pushl $123
80106990:	6a 7b                	push   $0x7b
  jmp alltraps
80106992:	e9 f0 f6 ff ff       	jmp    80106087 <alltraps>

80106997 <vector124>:
.globl vector124
vector124:
  pushl $0
80106997:	6a 00                	push   $0x0
  pushl $124
80106999:	6a 7c                	push   $0x7c
  jmp alltraps
8010699b:	e9 e7 f6 ff ff       	jmp    80106087 <alltraps>

801069a0 <vector125>:
.globl vector125
vector125:
  pushl $0
801069a0:	6a 00                	push   $0x0
  pushl $125
801069a2:	6a 7d                	push   $0x7d
  jmp alltraps
801069a4:	e9 de f6 ff ff       	jmp    80106087 <alltraps>

801069a9 <vector126>:
.globl vector126
vector126:
  pushl $0
801069a9:	6a 00                	push   $0x0
  pushl $126
801069ab:	6a 7e                	push   $0x7e
  jmp alltraps
801069ad:	e9 d5 f6 ff ff       	jmp    80106087 <alltraps>

801069b2 <vector127>:
.globl vector127
vector127:
  pushl $0
801069b2:	6a 00                	push   $0x0
  pushl $127
801069b4:	6a 7f                	push   $0x7f
  jmp alltraps
801069b6:	e9 cc f6 ff ff       	jmp    80106087 <alltraps>

801069bb <vector128>:
.globl vector128
vector128:
  pushl $0
801069bb:	6a 00                	push   $0x0
  pushl $128
801069bd:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801069c2:	e9 c0 f6 ff ff       	jmp    80106087 <alltraps>

801069c7 <vector129>:
.globl vector129
vector129:
  pushl $0
801069c7:	6a 00                	push   $0x0
  pushl $129
801069c9:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801069ce:	e9 b4 f6 ff ff       	jmp    80106087 <alltraps>

801069d3 <vector130>:
.globl vector130
vector130:
  pushl $0
801069d3:	6a 00                	push   $0x0
  pushl $130
801069d5:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801069da:	e9 a8 f6 ff ff       	jmp    80106087 <alltraps>

801069df <vector131>:
.globl vector131
vector131:
  pushl $0
801069df:	6a 00                	push   $0x0
  pushl $131
801069e1:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801069e6:	e9 9c f6 ff ff       	jmp    80106087 <alltraps>

801069eb <vector132>:
.globl vector132
vector132:
  pushl $0
801069eb:	6a 00                	push   $0x0
  pushl $132
801069ed:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801069f2:	e9 90 f6 ff ff       	jmp    80106087 <alltraps>

801069f7 <vector133>:
.globl vector133
vector133:
  pushl $0
801069f7:	6a 00                	push   $0x0
  pushl $133
801069f9:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801069fe:	e9 84 f6 ff ff       	jmp    80106087 <alltraps>

80106a03 <vector134>:
.globl vector134
vector134:
  pushl $0
80106a03:	6a 00                	push   $0x0
  pushl $134
80106a05:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106a0a:	e9 78 f6 ff ff       	jmp    80106087 <alltraps>

80106a0f <vector135>:
.globl vector135
vector135:
  pushl $0
80106a0f:	6a 00                	push   $0x0
  pushl $135
80106a11:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106a16:	e9 6c f6 ff ff       	jmp    80106087 <alltraps>

80106a1b <vector136>:
.globl vector136
vector136:
  pushl $0
80106a1b:	6a 00                	push   $0x0
  pushl $136
80106a1d:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106a22:	e9 60 f6 ff ff       	jmp    80106087 <alltraps>

80106a27 <vector137>:
.globl vector137
vector137:
  pushl $0
80106a27:	6a 00                	push   $0x0
  pushl $137
80106a29:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106a2e:	e9 54 f6 ff ff       	jmp    80106087 <alltraps>

80106a33 <vector138>:
.globl vector138
vector138:
  pushl $0
80106a33:	6a 00                	push   $0x0
  pushl $138
80106a35:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106a3a:	e9 48 f6 ff ff       	jmp    80106087 <alltraps>

80106a3f <vector139>:
.globl vector139
vector139:
  pushl $0
80106a3f:	6a 00                	push   $0x0
  pushl $139
80106a41:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106a46:	e9 3c f6 ff ff       	jmp    80106087 <alltraps>

80106a4b <vector140>:
.globl vector140
vector140:
  pushl $0
80106a4b:	6a 00                	push   $0x0
  pushl $140
80106a4d:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106a52:	e9 30 f6 ff ff       	jmp    80106087 <alltraps>

80106a57 <vector141>:
.globl vector141
vector141:
  pushl $0
80106a57:	6a 00                	push   $0x0
  pushl $141
80106a59:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106a5e:	e9 24 f6 ff ff       	jmp    80106087 <alltraps>

80106a63 <vector142>:
.globl vector142
vector142:
  pushl $0
80106a63:	6a 00                	push   $0x0
  pushl $142
80106a65:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106a6a:	e9 18 f6 ff ff       	jmp    80106087 <alltraps>

80106a6f <vector143>:
.globl vector143
vector143:
  pushl $0
80106a6f:	6a 00                	push   $0x0
  pushl $143
80106a71:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106a76:	e9 0c f6 ff ff       	jmp    80106087 <alltraps>

80106a7b <vector144>:
.globl vector144
vector144:
  pushl $0
80106a7b:	6a 00                	push   $0x0
  pushl $144
80106a7d:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106a82:	e9 00 f6 ff ff       	jmp    80106087 <alltraps>

80106a87 <vector145>:
.globl vector145
vector145:
  pushl $0
80106a87:	6a 00                	push   $0x0
  pushl $145
80106a89:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106a8e:	e9 f4 f5 ff ff       	jmp    80106087 <alltraps>

80106a93 <vector146>:
.globl vector146
vector146:
  pushl $0
80106a93:	6a 00                	push   $0x0
  pushl $146
80106a95:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106a9a:	e9 e8 f5 ff ff       	jmp    80106087 <alltraps>

80106a9f <vector147>:
.globl vector147
vector147:
  pushl $0
80106a9f:	6a 00                	push   $0x0
  pushl $147
80106aa1:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106aa6:	e9 dc f5 ff ff       	jmp    80106087 <alltraps>

80106aab <vector148>:
.globl vector148
vector148:
  pushl $0
80106aab:	6a 00                	push   $0x0
  pushl $148
80106aad:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106ab2:	e9 d0 f5 ff ff       	jmp    80106087 <alltraps>

80106ab7 <vector149>:
.globl vector149
vector149:
  pushl $0
80106ab7:	6a 00                	push   $0x0
  pushl $149
80106ab9:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106abe:	e9 c4 f5 ff ff       	jmp    80106087 <alltraps>

80106ac3 <vector150>:
.globl vector150
vector150:
  pushl $0
80106ac3:	6a 00                	push   $0x0
  pushl $150
80106ac5:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106aca:	e9 b8 f5 ff ff       	jmp    80106087 <alltraps>

80106acf <vector151>:
.globl vector151
vector151:
  pushl $0
80106acf:	6a 00                	push   $0x0
  pushl $151
80106ad1:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106ad6:	e9 ac f5 ff ff       	jmp    80106087 <alltraps>

80106adb <vector152>:
.globl vector152
vector152:
  pushl $0
80106adb:	6a 00                	push   $0x0
  pushl $152
80106add:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106ae2:	e9 a0 f5 ff ff       	jmp    80106087 <alltraps>

80106ae7 <vector153>:
.globl vector153
vector153:
  pushl $0
80106ae7:	6a 00                	push   $0x0
  pushl $153
80106ae9:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106aee:	e9 94 f5 ff ff       	jmp    80106087 <alltraps>

80106af3 <vector154>:
.globl vector154
vector154:
  pushl $0
80106af3:	6a 00                	push   $0x0
  pushl $154
80106af5:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106afa:	e9 88 f5 ff ff       	jmp    80106087 <alltraps>

80106aff <vector155>:
.globl vector155
vector155:
  pushl $0
80106aff:	6a 00                	push   $0x0
  pushl $155
80106b01:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106b06:	e9 7c f5 ff ff       	jmp    80106087 <alltraps>

80106b0b <vector156>:
.globl vector156
vector156:
  pushl $0
80106b0b:	6a 00                	push   $0x0
  pushl $156
80106b0d:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106b12:	e9 70 f5 ff ff       	jmp    80106087 <alltraps>

80106b17 <vector157>:
.globl vector157
vector157:
  pushl $0
80106b17:	6a 00                	push   $0x0
  pushl $157
80106b19:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106b1e:	e9 64 f5 ff ff       	jmp    80106087 <alltraps>

80106b23 <vector158>:
.globl vector158
vector158:
  pushl $0
80106b23:	6a 00                	push   $0x0
  pushl $158
80106b25:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106b2a:	e9 58 f5 ff ff       	jmp    80106087 <alltraps>

80106b2f <vector159>:
.globl vector159
vector159:
  pushl $0
80106b2f:	6a 00                	push   $0x0
  pushl $159
80106b31:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106b36:	e9 4c f5 ff ff       	jmp    80106087 <alltraps>

80106b3b <vector160>:
.globl vector160
vector160:
  pushl $0
80106b3b:	6a 00                	push   $0x0
  pushl $160
80106b3d:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106b42:	e9 40 f5 ff ff       	jmp    80106087 <alltraps>

80106b47 <vector161>:
.globl vector161
vector161:
  pushl $0
80106b47:	6a 00                	push   $0x0
  pushl $161
80106b49:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106b4e:	e9 34 f5 ff ff       	jmp    80106087 <alltraps>

80106b53 <vector162>:
.globl vector162
vector162:
  pushl $0
80106b53:	6a 00                	push   $0x0
  pushl $162
80106b55:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106b5a:	e9 28 f5 ff ff       	jmp    80106087 <alltraps>

80106b5f <vector163>:
.globl vector163
vector163:
  pushl $0
80106b5f:	6a 00                	push   $0x0
  pushl $163
80106b61:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106b66:	e9 1c f5 ff ff       	jmp    80106087 <alltraps>

80106b6b <vector164>:
.globl vector164
vector164:
  pushl $0
80106b6b:	6a 00                	push   $0x0
  pushl $164
80106b6d:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106b72:	e9 10 f5 ff ff       	jmp    80106087 <alltraps>

80106b77 <vector165>:
.globl vector165
vector165:
  pushl $0
80106b77:	6a 00                	push   $0x0
  pushl $165
80106b79:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106b7e:	e9 04 f5 ff ff       	jmp    80106087 <alltraps>

80106b83 <vector166>:
.globl vector166
vector166:
  pushl $0
80106b83:	6a 00                	push   $0x0
  pushl $166
80106b85:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106b8a:	e9 f8 f4 ff ff       	jmp    80106087 <alltraps>

80106b8f <vector167>:
.globl vector167
vector167:
  pushl $0
80106b8f:	6a 00                	push   $0x0
  pushl $167
80106b91:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106b96:	e9 ec f4 ff ff       	jmp    80106087 <alltraps>

80106b9b <vector168>:
.globl vector168
vector168:
  pushl $0
80106b9b:	6a 00                	push   $0x0
  pushl $168
80106b9d:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106ba2:	e9 e0 f4 ff ff       	jmp    80106087 <alltraps>

80106ba7 <vector169>:
.globl vector169
vector169:
  pushl $0
80106ba7:	6a 00                	push   $0x0
  pushl $169
80106ba9:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106bae:	e9 d4 f4 ff ff       	jmp    80106087 <alltraps>

80106bb3 <vector170>:
.globl vector170
vector170:
  pushl $0
80106bb3:	6a 00                	push   $0x0
  pushl $170
80106bb5:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106bba:	e9 c8 f4 ff ff       	jmp    80106087 <alltraps>

80106bbf <vector171>:
.globl vector171
vector171:
  pushl $0
80106bbf:	6a 00                	push   $0x0
  pushl $171
80106bc1:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106bc6:	e9 bc f4 ff ff       	jmp    80106087 <alltraps>

80106bcb <vector172>:
.globl vector172
vector172:
  pushl $0
80106bcb:	6a 00                	push   $0x0
  pushl $172
80106bcd:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106bd2:	e9 b0 f4 ff ff       	jmp    80106087 <alltraps>

80106bd7 <vector173>:
.globl vector173
vector173:
  pushl $0
80106bd7:	6a 00                	push   $0x0
  pushl $173
80106bd9:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106bde:	e9 a4 f4 ff ff       	jmp    80106087 <alltraps>

80106be3 <vector174>:
.globl vector174
vector174:
  pushl $0
80106be3:	6a 00                	push   $0x0
  pushl $174
80106be5:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106bea:	e9 98 f4 ff ff       	jmp    80106087 <alltraps>

80106bef <vector175>:
.globl vector175
vector175:
  pushl $0
80106bef:	6a 00                	push   $0x0
  pushl $175
80106bf1:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106bf6:	e9 8c f4 ff ff       	jmp    80106087 <alltraps>

80106bfb <vector176>:
.globl vector176
vector176:
  pushl $0
80106bfb:	6a 00                	push   $0x0
  pushl $176
80106bfd:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106c02:	e9 80 f4 ff ff       	jmp    80106087 <alltraps>

80106c07 <vector177>:
.globl vector177
vector177:
  pushl $0
80106c07:	6a 00                	push   $0x0
  pushl $177
80106c09:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106c0e:	e9 74 f4 ff ff       	jmp    80106087 <alltraps>

80106c13 <vector178>:
.globl vector178
vector178:
  pushl $0
80106c13:	6a 00                	push   $0x0
  pushl $178
80106c15:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106c1a:	e9 68 f4 ff ff       	jmp    80106087 <alltraps>

80106c1f <vector179>:
.globl vector179
vector179:
  pushl $0
80106c1f:	6a 00                	push   $0x0
  pushl $179
80106c21:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106c26:	e9 5c f4 ff ff       	jmp    80106087 <alltraps>

80106c2b <vector180>:
.globl vector180
vector180:
  pushl $0
80106c2b:	6a 00                	push   $0x0
  pushl $180
80106c2d:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106c32:	e9 50 f4 ff ff       	jmp    80106087 <alltraps>

80106c37 <vector181>:
.globl vector181
vector181:
  pushl $0
80106c37:	6a 00                	push   $0x0
  pushl $181
80106c39:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106c3e:	e9 44 f4 ff ff       	jmp    80106087 <alltraps>

80106c43 <vector182>:
.globl vector182
vector182:
  pushl $0
80106c43:	6a 00                	push   $0x0
  pushl $182
80106c45:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106c4a:	e9 38 f4 ff ff       	jmp    80106087 <alltraps>

80106c4f <vector183>:
.globl vector183
vector183:
  pushl $0
80106c4f:	6a 00                	push   $0x0
  pushl $183
80106c51:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106c56:	e9 2c f4 ff ff       	jmp    80106087 <alltraps>

80106c5b <vector184>:
.globl vector184
vector184:
  pushl $0
80106c5b:	6a 00                	push   $0x0
  pushl $184
80106c5d:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106c62:	e9 20 f4 ff ff       	jmp    80106087 <alltraps>

80106c67 <vector185>:
.globl vector185
vector185:
  pushl $0
80106c67:	6a 00                	push   $0x0
  pushl $185
80106c69:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106c6e:	e9 14 f4 ff ff       	jmp    80106087 <alltraps>

80106c73 <vector186>:
.globl vector186
vector186:
  pushl $0
80106c73:	6a 00                	push   $0x0
  pushl $186
80106c75:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106c7a:	e9 08 f4 ff ff       	jmp    80106087 <alltraps>

80106c7f <vector187>:
.globl vector187
vector187:
  pushl $0
80106c7f:	6a 00                	push   $0x0
  pushl $187
80106c81:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106c86:	e9 fc f3 ff ff       	jmp    80106087 <alltraps>

80106c8b <vector188>:
.globl vector188
vector188:
  pushl $0
80106c8b:	6a 00                	push   $0x0
  pushl $188
80106c8d:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106c92:	e9 f0 f3 ff ff       	jmp    80106087 <alltraps>

80106c97 <vector189>:
.globl vector189
vector189:
  pushl $0
80106c97:	6a 00                	push   $0x0
  pushl $189
80106c99:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106c9e:	e9 e4 f3 ff ff       	jmp    80106087 <alltraps>

80106ca3 <vector190>:
.globl vector190
vector190:
  pushl $0
80106ca3:	6a 00                	push   $0x0
  pushl $190
80106ca5:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106caa:	e9 d8 f3 ff ff       	jmp    80106087 <alltraps>

80106caf <vector191>:
.globl vector191
vector191:
  pushl $0
80106caf:	6a 00                	push   $0x0
  pushl $191
80106cb1:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106cb6:	e9 cc f3 ff ff       	jmp    80106087 <alltraps>

80106cbb <vector192>:
.globl vector192
vector192:
  pushl $0
80106cbb:	6a 00                	push   $0x0
  pushl $192
80106cbd:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106cc2:	e9 c0 f3 ff ff       	jmp    80106087 <alltraps>

80106cc7 <vector193>:
.globl vector193
vector193:
  pushl $0
80106cc7:	6a 00                	push   $0x0
  pushl $193
80106cc9:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106cce:	e9 b4 f3 ff ff       	jmp    80106087 <alltraps>

80106cd3 <vector194>:
.globl vector194
vector194:
  pushl $0
80106cd3:	6a 00                	push   $0x0
  pushl $194
80106cd5:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106cda:	e9 a8 f3 ff ff       	jmp    80106087 <alltraps>

80106cdf <vector195>:
.globl vector195
vector195:
  pushl $0
80106cdf:	6a 00                	push   $0x0
  pushl $195
80106ce1:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106ce6:	e9 9c f3 ff ff       	jmp    80106087 <alltraps>

80106ceb <vector196>:
.globl vector196
vector196:
  pushl $0
80106ceb:	6a 00                	push   $0x0
  pushl $196
80106ced:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106cf2:	e9 90 f3 ff ff       	jmp    80106087 <alltraps>

80106cf7 <vector197>:
.globl vector197
vector197:
  pushl $0
80106cf7:	6a 00                	push   $0x0
  pushl $197
80106cf9:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106cfe:	e9 84 f3 ff ff       	jmp    80106087 <alltraps>

80106d03 <vector198>:
.globl vector198
vector198:
  pushl $0
80106d03:	6a 00                	push   $0x0
  pushl $198
80106d05:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106d0a:	e9 78 f3 ff ff       	jmp    80106087 <alltraps>

80106d0f <vector199>:
.globl vector199
vector199:
  pushl $0
80106d0f:	6a 00                	push   $0x0
  pushl $199
80106d11:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106d16:	e9 6c f3 ff ff       	jmp    80106087 <alltraps>

80106d1b <vector200>:
.globl vector200
vector200:
  pushl $0
80106d1b:	6a 00                	push   $0x0
  pushl $200
80106d1d:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106d22:	e9 60 f3 ff ff       	jmp    80106087 <alltraps>

80106d27 <vector201>:
.globl vector201
vector201:
  pushl $0
80106d27:	6a 00                	push   $0x0
  pushl $201
80106d29:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106d2e:	e9 54 f3 ff ff       	jmp    80106087 <alltraps>

80106d33 <vector202>:
.globl vector202
vector202:
  pushl $0
80106d33:	6a 00                	push   $0x0
  pushl $202
80106d35:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106d3a:	e9 48 f3 ff ff       	jmp    80106087 <alltraps>

80106d3f <vector203>:
.globl vector203
vector203:
  pushl $0
80106d3f:	6a 00                	push   $0x0
  pushl $203
80106d41:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106d46:	e9 3c f3 ff ff       	jmp    80106087 <alltraps>

80106d4b <vector204>:
.globl vector204
vector204:
  pushl $0
80106d4b:	6a 00                	push   $0x0
  pushl $204
80106d4d:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106d52:	e9 30 f3 ff ff       	jmp    80106087 <alltraps>

80106d57 <vector205>:
.globl vector205
vector205:
  pushl $0
80106d57:	6a 00                	push   $0x0
  pushl $205
80106d59:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106d5e:	e9 24 f3 ff ff       	jmp    80106087 <alltraps>

80106d63 <vector206>:
.globl vector206
vector206:
  pushl $0
80106d63:	6a 00                	push   $0x0
  pushl $206
80106d65:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106d6a:	e9 18 f3 ff ff       	jmp    80106087 <alltraps>

80106d6f <vector207>:
.globl vector207
vector207:
  pushl $0
80106d6f:	6a 00                	push   $0x0
  pushl $207
80106d71:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106d76:	e9 0c f3 ff ff       	jmp    80106087 <alltraps>

80106d7b <vector208>:
.globl vector208
vector208:
  pushl $0
80106d7b:	6a 00                	push   $0x0
  pushl $208
80106d7d:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106d82:	e9 00 f3 ff ff       	jmp    80106087 <alltraps>

80106d87 <vector209>:
.globl vector209
vector209:
  pushl $0
80106d87:	6a 00                	push   $0x0
  pushl $209
80106d89:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106d8e:	e9 f4 f2 ff ff       	jmp    80106087 <alltraps>

80106d93 <vector210>:
.globl vector210
vector210:
  pushl $0
80106d93:	6a 00                	push   $0x0
  pushl $210
80106d95:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106d9a:	e9 e8 f2 ff ff       	jmp    80106087 <alltraps>

80106d9f <vector211>:
.globl vector211
vector211:
  pushl $0
80106d9f:	6a 00                	push   $0x0
  pushl $211
80106da1:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106da6:	e9 dc f2 ff ff       	jmp    80106087 <alltraps>

80106dab <vector212>:
.globl vector212
vector212:
  pushl $0
80106dab:	6a 00                	push   $0x0
  pushl $212
80106dad:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106db2:	e9 d0 f2 ff ff       	jmp    80106087 <alltraps>

80106db7 <vector213>:
.globl vector213
vector213:
  pushl $0
80106db7:	6a 00                	push   $0x0
  pushl $213
80106db9:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106dbe:	e9 c4 f2 ff ff       	jmp    80106087 <alltraps>

80106dc3 <vector214>:
.globl vector214
vector214:
  pushl $0
80106dc3:	6a 00                	push   $0x0
  pushl $214
80106dc5:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106dca:	e9 b8 f2 ff ff       	jmp    80106087 <alltraps>

80106dcf <vector215>:
.globl vector215
vector215:
  pushl $0
80106dcf:	6a 00                	push   $0x0
  pushl $215
80106dd1:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106dd6:	e9 ac f2 ff ff       	jmp    80106087 <alltraps>

80106ddb <vector216>:
.globl vector216
vector216:
  pushl $0
80106ddb:	6a 00                	push   $0x0
  pushl $216
80106ddd:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106de2:	e9 a0 f2 ff ff       	jmp    80106087 <alltraps>

80106de7 <vector217>:
.globl vector217
vector217:
  pushl $0
80106de7:	6a 00                	push   $0x0
  pushl $217
80106de9:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106dee:	e9 94 f2 ff ff       	jmp    80106087 <alltraps>

80106df3 <vector218>:
.globl vector218
vector218:
  pushl $0
80106df3:	6a 00                	push   $0x0
  pushl $218
80106df5:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106dfa:	e9 88 f2 ff ff       	jmp    80106087 <alltraps>

80106dff <vector219>:
.globl vector219
vector219:
  pushl $0
80106dff:	6a 00                	push   $0x0
  pushl $219
80106e01:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106e06:	e9 7c f2 ff ff       	jmp    80106087 <alltraps>

80106e0b <vector220>:
.globl vector220
vector220:
  pushl $0
80106e0b:	6a 00                	push   $0x0
  pushl $220
80106e0d:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106e12:	e9 70 f2 ff ff       	jmp    80106087 <alltraps>

80106e17 <vector221>:
.globl vector221
vector221:
  pushl $0
80106e17:	6a 00                	push   $0x0
  pushl $221
80106e19:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106e1e:	e9 64 f2 ff ff       	jmp    80106087 <alltraps>

80106e23 <vector222>:
.globl vector222
vector222:
  pushl $0
80106e23:	6a 00                	push   $0x0
  pushl $222
80106e25:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106e2a:	e9 58 f2 ff ff       	jmp    80106087 <alltraps>

80106e2f <vector223>:
.globl vector223
vector223:
  pushl $0
80106e2f:	6a 00                	push   $0x0
  pushl $223
80106e31:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106e36:	e9 4c f2 ff ff       	jmp    80106087 <alltraps>

80106e3b <vector224>:
.globl vector224
vector224:
  pushl $0
80106e3b:	6a 00                	push   $0x0
  pushl $224
80106e3d:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106e42:	e9 40 f2 ff ff       	jmp    80106087 <alltraps>

80106e47 <vector225>:
.globl vector225
vector225:
  pushl $0
80106e47:	6a 00                	push   $0x0
  pushl $225
80106e49:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106e4e:	e9 34 f2 ff ff       	jmp    80106087 <alltraps>

80106e53 <vector226>:
.globl vector226
vector226:
  pushl $0
80106e53:	6a 00                	push   $0x0
  pushl $226
80106e55:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106e5a:	e9 28 f2 ff ff       	jmp    80106087 <alltraps>

80106e5f <vector227>:
.globl vector227
vector227:
  pushl $0
80106e5f:	6a 00                	push   $0x0
  pushl $227
80106e61:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106e66:	e9 1c f2 ff ff       	jmp    80106087 <alltraps>

80106e6b <vector228>:
.globl vector228
vector228:
  pushl $0
80106e6b:	6a 00                	push   $0x0
  pushl $228
80106e6d:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106e72:	e9 10 f2 ff ff       	jmp    80106087 <alltraps>

80106e77 <vector229>:
.globl vector229
vector229:
  pushl $0
80106e77:	6a 00                	push   $0x0
  pushl $229
80106e79:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106e7e:	e9 04 f2 ff ff       	jmp    80106087 <alltraps>

80106e83 <vector230>:
.globl vector230
vector230:
  pushl $0
80106e83:	6a 00                	push   $0x0
  pushl $230
80106e85:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106e8a:	e9 f8 f1 ff ff       	jmp    80106087 <alltraps>

80106e8f <vector231>:
.globl vector231
vector231:
  pushl $0
80106e8f:	6a 00                	push   $0x0
  pushl $231
80106e91:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106e96:	e9 ec f1 ff ff       	jmp    80106087 <alltraps>

80106e9b <vector232>:
.globl vector232
vector232:
  pushl $0
80106e9b:	6a 00                	push   $0x0
  pushl $232
80106e9d:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106ea2:	e9 e0 f1 ff ff       	jmp    80106087 <alltraps>

80106ea7 <vector233>:
.globl vector233
vector233:
  pushl $0
80106ea7:	6a 00                	push   $0x0
  pushl $233
80106ea9:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106eae:	e9 d4 f1 ff ff       	jmp    80106087 <alltraps>

80106eb3 <vector234>:
.globl vector234
vector234:
  pushl $0
80106eb3:	6a 00                	push   $0x0
  pushl $234
80106eb5:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106eba:	e9 c8 f1 ff ff       	jmp    80106087 <alltraps>

80106ebf <vector235>:
.globl vector235
vector235:
  pushl $0
80106ebf:	6a 00                	push   $0x0
  pushl $235
80106ec1:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106ec6:	e9 bc f1 ff ff       	jmp    80106087 <alltraps>

80106ecb <vector236>:
.globl vector236
vector236:
  pushl $0
80106ecb:	6a 00                	push   $0x0
  pushl $236
80106ecd:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106ed2:	e9 b0 f1 ff ff       	jmp    80106087 <alltraps>

80106ed7 <vector237>:
.globl vector237
vector237:
  pushl $0
80106ed7:	6a 00                	push   $0x0
  pushl $237
80106ed9:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106ede:	e9 a4 f1 ff ff       	jmp    80106087 <alltraps>

80106ee3 <vector238>:
.globl vector238
vector238:
  pushl $0
80106ee3:	6a 00                	push   $0x0
  pushl $238
80106ee5:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106eea:	e9 98 f1 ff ff       	jmp    80106087 <alltraps>

80106eef <vector239>:
.globl vector239
vector239:
  pushl $0
80106eef:	6a 00                	push   $0x0
  pushl $239
80106ef1:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106ef6:	e9 8c f1 ff ff       	jmp    80106087 <alltraps>

80106efb <vector240>:
.globl vector240
vector240:
  pushl $0
80106efb:	6a 00                	push   $0x0
  pushl $240
80106efd:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106f02:	e9 80 f1 ff ff       	jmp    80106087 <alltraps>

80106f07 <vector241>:
.globl vector241
vector241:
  pushl $0
80106f07:	6a 00                	push   $0x0
  pushl $241
80106f09:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106f0e:	e9 74 f1 ff ff       	jmp    80106087 <alltraps>

80106f13 <vector242>:
.globl vector242
vector242:
  pushl $0
80106f13:	6a 00                	push   $0x0
  pushl $242
80106f15:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106f1a:	e9 68 f1 ff ff       	jmp    80106087 <alltraps>

80106f1f <vector243>:
.globl vector243
vector243:
  pushl $0
80106f1f:	6a 00                	push   $0x0
  pushl $243
80106f21:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106f26:	e9 5c f1 ff ff       	jmp    80106087 <alltraps>

80106f2b <vector244>:
.globl vector244
vector244:
  pushl $0
80106f2b:	6a 00                	push   $0x0
  pushl $244
80106f2d:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106f32:	e9 50 f1 ff ff       	jmp    80106087 <alltraps>

80106f37 <vector245>:
.globl vector245
vector245:
  pushl $0
80106f37:	6a 00                	push   $0x0
  pushl $245
80106f39:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106f3e:	e9 44 f1 ff ff       	jmp    80106087 <alltraps>

80106f43 <vector246>:
.globl vector246
vector246:
  pushl $0
80106f43:	6a 00                	push   $0x0
  pushl $246
80106f45:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106f4a:	e9 38 f1 ff ff       	jmp    80106087 <alltraps>

80106f4f <vector247>:
.globl vector247
vector247:
  pushl $0
80106f4f:	6a 00                	push   $0x0
  pushl $247
80106f51:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106f56:	e9 2c f1 ff ff       	jmp    80106087 <alltraps>

80106f5b <vector248>:
.globl vector248
vector248:
  pushl $0
80106f5b:	6a 00                	push   $0x0
  pushl $248
80106f5d:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106f62:	e9 20 f1 ff ff       	jmp    80106087 <alltraps>

80106f67 <vector249>:
.globl vector249
vector249:
  pushl $0
80106f67:	6a 00                	push   $0x0
  pushl $249
80106f69:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106f6e:	e9 14 f1 ff ff       	jmp    80106087 <alltraps>

80106f73 <vector250>:
.globl vector250
vector250:
  pushl $0
80106f73:	6a 00                	push   $0x0
  pushl $250
80106f75:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106f7a:	e9 08 f1 ff ff       	jmp    80106087 <alltraps>

80106f7f <vector251>:
.globl vector251
vector251:
  pushl $0
80106f7f:	6a 00                	push   $0x0
  pushl $251
80106f81:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106f86:	e9 fc f0 ff ff       	jmp    80106087 <alltraps>

80106f8b <vector252>:
.globl vector252
vector252:
  pushl $0
80106f8b:	6a 00                	push   $0x0
  pushl $252
80106f8d:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106f92:	e9 f0 f0 ff ff       	jmp    80106087 <alltraps>

80106f97 <vector253>:
.globl vector253
vector253:
  pushl $0
80106f97:	6a 00                	push   $0x0
  pushl $253
80106f99:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106f9e:	e9 e4 f0 ff ff       	jmp    80106087 <alltraps>

80106fa3 <vector254>:
.globl vector254
vector254:
  pushl $0
80106fa3:	6a 00                	push   $0x0
  pushl $254
80106fa5:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106faa:	e9 d8 f0 ff ff       	jmp    80106087 <alltraps>

80106faf <vector255>:
.globl vector255
vector255:
  pushl $0
80106faf:	6a 00                	push   $0x0
  pushl $255
80106fb1:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106fb6:	e9 cc f0 ff ff       	jmp    80106087 <alltraps>
80106fbb:	66 90                	xchg   %ax,%ax
80106fbd:	66 90                	xchg   %ax,%ax
80106fbf:	90                   	nop

80106fc0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106fc0:	55                   	push   %ebp
80106fc1:	89 e5                	mov    %esp,%ebp
80106fc3:	57                   	push   %edi
80106fc4:	56                   	push   %esi
80106fc5:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106fc7:	c1 ea 16             	shr    $0x16,%edx
{
80106fca:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
80106fcb:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
80106fce:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106fd1:	8b 1f                	mov    (%edi),%ebx
80106fd3:	f6 c3 01             	test   $0x1,%bl
80106fd6:	74 28                	je     80107000 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106fd8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80106fde:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106fe4:	89 f0                	mov    %esi,%eax
}
80106fe6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106fe9:	c1 e8 0a             	shr    $0xa,%eax
80106fec:	25 fc 0f 00 00       	and    $0xffc,%eax
80106ff1:	01 d8                	add    %ebx,%eax
}
80106ff3:	5b                   	pop    %ebx
80106ff4:	5e                   	pop    %esi
80106ff5:	5f                   	pop    %edi
80106ff6:	5d                   	pop    %ebp
80106ff7:	c3                   	ret    
80106ff8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fff:	90                   	nop
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107000:	85 c9                	test   %ecx,%ecx
80107002:	74 2c                	je     80107030 <walkpgdir+0x70>
80107004:	e8 37 b6 ff ff       	call   80102640 <kalloc>
80107009:	89 c3                	mov    %eax,%ebx
8010700b:	85 c0                	test   %eax,%eax
8010700d:	74 21                	je     80107030 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
8010700f:	83 ec 04             	sub    $0x4,%esp
80107012:	68 00 10 00 00       	push   $0x1000
80107017:	6a 00                	push   $0x0
80107019:	50                   	push   %eax
8010701a:	e8 81 dd ff ff       	call   80104da0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010701f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107025:	83 c4 10             	add    $0x10,%esp
80107028:	83 c8 07             	or     $0x7,%eax
8010702b:	89 07                	mov    %eax,(%edi)
8010702d:	eb b5                	jmp    80106fe4 <walkpgdir+0x24>
8010702f:	90                   	nop
}
80107030:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80107033:	31 c0                	xor    %eax,%eax
}
80107035:	5b                   	pop    %ebx
80107036:	5e                   	pop    %esi
80107037:	5f                   	pop    %edi
80107038:	5d                   	pop    %ebp
80107039:	c3                   	ret    
8010703a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107040 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107040:	55                   	push   %ebp
80107041:	89 e5                	mov    %esp,%ebp
80107043:	57                   	push   %edi
80107044:	89 c7                	mov    %eax,%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107046:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
{
8010704a:	56                   	push   %esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010704b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  a = (char*)PGROUNDDOWN((uint)va);
80107050:	89 d6                	mov    %edx,%esi
{
80107052:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80107053:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
{
80107059:	83 ec 1c             	sub    $0x1c,%esp
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010705c:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010705f:	8b 45 08             	mov    0x8(%ebp),%eax
80107062:	29 f0                	sub    %esi,%eax
80107064:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107067:	eb 1f                	jmp    80107088 <mappages+0x48>
80107069:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80107070:	f6 00 01             	testb  $0x1,(%eax)
80107073:	75 45                	jne    801070ba <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80107075:	0b 5d 0c             	or     0xc(%ebp),%ebx
80107078:	83 cb 01             	or     $0x1,%ebx
8010707b:	89 18                	mov    %ebx,(%eax)
    if(a == last)
8010707d:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80107080:	74 2e                	je     801070b0 <mappages+0x70>
      break;
    a += PGSIZE;
80107082:	81 c6 00 10 00 00    	add    $0x1000,%esi
  for(;;){
80107088:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
8010708b:	b9 01 00 00 00       	mov    $0x1,%ecx
80107090:	89 f2                	mov    %esi,%edx
80107092:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
80107095:	89 f8                	mov    %edi,%eax
80107097:	e8 24 ff ff ff       	call   80106fc0 <walkpgdir>
8010709c:	85 c0                	test   %eax,%eax
8010709e:	75 d0                	jne    80107070 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
801070a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801070a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801070a8:	5b                   	pop    %ebx
801070a9:	5e                   	pop    %esi
801070aa:	5f                   	pop    %edi
801070ab:	5d                   	pop    %ebp
801070ac:	c3                   	ret    
801070ad:	8d 76 00             	lea    0x0(%esi),%esi
801070b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801070b3:	31 c0                	xor    %eax,%eax
}
801070b5:	5b                   	pop    %ebx
801070b6:	5e                   	pop    %esi
801070b7:	5f                   	pop    %edi
801070b8:	5d                   	pop    %ebp
801070b9:	c3                   	ret    
      panic("remap");
801070ba:	83 ec 0c             	sub    $0xc,%esp
801070bd:	68 f4 81 10 80       	push   $0x801081f4
801070c2:	e8 c9 92 ff ff       	call   80100390 <panic>
801070c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070ce:	66 90                	xchg   %ax,%ax

801070d0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801070d0:	55                   	push   %ebp
801070d1:	89 e5                	mov    %esp,%ebp
801070d3:	57                   	push   %edi
801070d4:	56                   	push   %esi
801070d5:	89 c6                	mov    %eax,%esi
801070d7:	53                   	push   %ebx
801070d8:	89 d3                	mov    %edx,%ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801070da:	8d 91 ff 0f 00 00    	lea    0xfff(%ecx),%edx
801070e0:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801070e6:	83 ec 1c             	sub    $0x1c,%esp
801070e9:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801070ec:	39 da                	cmp    %ebx,%edx
801070ee:	73 5b                	jae    8010714b <deallocuvm.part.0+0x7b>
801070f0:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801070f3:	89 d7                	mov    %edx,%edi
801070f5:	eb 14                	jmp    8010710b <deallocuvm.part.0+0x3b>
801070f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070fe:	66 90                	xchg   %ax,%ax
80107100:	81 c7 00 10 00 00    	add    $0x1000,%edi
80107106:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80107109:	76 40                	jbe    8010714b <deallocuvm.part.0+0x7b>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010710b:	31 c9                	xor    %ecx,%ecx
8010710d:	89 fa                	mov    %edi,%edx
8010710f:	89 f0                	mov    %esi,%eax
80107111:	e8 aa fe ff ff       	call   80106fc0 <walkpgdir>
80107116:	89 c3                	mov    %eax,%ebx
    if(!pte)
80107118:	85 c0                	test   %eax,%eax
8010711a:	74 44                	je     80107160 <deallocuvm.part.0+0x90>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
8010711c:	8b 00                	mov    (%eax),%eax
8010711e:	a8 01                	test   $0x1,%al
80107120:	74 de                	je     80107100 <deallocuvm.part.0+0x30>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80107122:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107127:	74 47                	je     80107170 <deallocuvm.part.0+0xa0>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80107129:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010712c:	05 00 00 00 80       	add    $0x80000000,%eax
80107131:	81 c7 00 10 00 00    	add    $0x1000,%edi
      kfree(v);
80107137:	50                   	push   %eax
80107138:	e8 43 b3 ff ff       	call   80102480 <kfree>
      *pte = 0;
8010713d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80107143:	83 c4 10             	add    $0x10,%esp
  for(; a  < oldsz; a += PGSIZE){
80107146:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80107149:	77 c0                	ja     8010710b <deallocuvm.part.0+0x3b>
    }
  }
  return newsz;
}
8010714b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010714e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107151:	5b                   	pop    %ebx
80107152:	5e                   	pop    %esi
80107153:	5f                   	pop    %edi
80107154:	5d                   	pop    %ebp
80107155:	c3                   	ret    
80107156:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010715d:	8d 76 00             	lea    0x0(%esi),%esi
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107160:	89 fa                	mov    %edi,%edx
80107162:	81 e2 00 00 c0 ff    	and    $0xffc00000,%edx
80107168:	8d ba 00 00 40 00    	lea    0x400000(%edx),%edi
8010716e:	eb 96                	jmp    80107106 <deallocuvm.part.0+0x36>
        panic("kfree");
80107170:	83 ec 0c             	sub    $0xc,%esp
80107173:	68 66 7b 10 80       	push   $0x80107b66
80107178:	e8 13 92 ff ff       	call   80100390 <panic>
8010717d:	8d 76 00             	lea    0x0(%esi),%esi

80107180 <seginit>:
{
80107180:	f3 0f 1e fb          	endbr32 
80107184:	55                   	push   %ebp
80107185:	89 e5                	mov    %esp,%ebp
80107187:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
8010718a:	e8 51 c8 ff ff       	call   801039e0 <cpuid>
  pd[0] = size-1;
8010718f:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107194:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
8010719a:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010719e:	c7 80 f8 37 11 80 ff 	movl   $0xffff,-0x7feec808(%eax)
801071a5:	ff 00 00 
801071a8:	c7 80 fc 37 11 80 00 	movl   $0xcf9a00,-0x7feec804(%eax)
801071af:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801071b2:	c7 80 00 38 11 80 ff 	movl   $0xffff,-0x7feec800(%eax)
801071b9:	ff 00 00 
801071bc:	c7 80 04 38 11 80 00 	movl   $0xcf9200,-0x7feec7fc(%eax)
801071c3:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801071c6:	c7 80 08 38 11 80 ff 	movl   $0xffff,-0x7feec7f8(%eax)
801071cd:	ff 00 00 
801071d0:	c7 80 0c 38 11 80 00 	movl   $0xcffa00,-0x7feec7f4(%eax)
801071d7:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801071da:	c7 80 10 38 11 80 ff 	movl   $0xffff,-0x7feec7f0(%eax)
801071e1:	ff 00 00 
801071e4:	c7 80 14 38 11 80 00 	movl   $0xcff200,-0x7feec7ec(%eax)
801071eb:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
801071ee:	05 f0 37 11 80       	add    $0x801137f0,%eax
  pd[1] = (uint)p;
801071f3:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801071f7:	c1 e8 10             	shr    $0x10,%eax
801071fa:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
801071fe:	8d 45 f2             	lea    -0xe(%ebp),%eax
80107201:	0f 01 10             	lgdtl  (%eax)
}
80107204:	c9                   	leave  
80107205:	c3                   	ret    
80107206:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010720d:	8d 76 00             	lea    0x0(%esi),%esi

80107210 <switchkvm>:
{
80107210:	f3 0f 1e fb          	endbr32 
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107214:	a1 a4 72 11 80       	mov    0x801172a4,%eax
80107219:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010721e:	0f 22 d8             	mov    %eax,%cr3
}
80107221:	c3                   	ret    
80107222:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107230 <switchuvm>:
{
80107230:	f3 0f 1e fb          	endbr32 
80107234:	55                   	push   %ebp
80107235:	89 e5                	mov    %esp,%ebp
80107237:	57                   	push   %edi
80107238:	56                   	push   %esi
80107239:	53                   	push   %ebx
8010723a:	83 ec 1c             	sub    $0x1c,%esp
8010723d:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80107240:	85 f6                	test   %esi,%esi
80107242:	0f 84 cb 00 00 00    	je     80107313 <switchuvm+0xe3>
  if(p->kstack == 0)
80107248:	8b 46 08             	mov    0x8(%esi),%eax
8010724b:	85 c0                	test   %eax,%eax
8010724d:	0f 84 da 00 00 00    	je     8010732d <switchuvm+0xfd>
  if(p->pgdir == 0)
80107253:	8b 46 04             	mov    0x4(%esi),%eax
80107256:	85 c0                	test   %eax,%eax
80107258:	0f 84 c2 00 00 00    	je     80107320 <switchuvm+0xf0>
  pushcli();
8010725e:	e8 2d d9 ff ff       	call   80104b90 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107263:	e8 08 c7 ff ff       	call   80103970 <mycpu>
80107268:	89 c3                	mov    %eax,%ebx
8010726a:	e8 01 c7 ff ff       	call   80103970 <mycpu>
8010726f:	89 c7                	mov    %eax,%edi
80107271:	e8 fa c6 ff ff       	call   80103970 <mycpu>
80107276:	83 c7 08             	add    $0x8,%edi
80107279:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010727c:	e8 ef c6 ff ff       	call   80103970 <mycpu>
80107281:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107284:	ba 67 00 00 00       	mov    $0x67,%edx
80107289:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80107290:	83 c0 08             	add    $0x8,%eax
80107293:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010729a:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010729f:	83 c1 08             	add    $0x8,%ecx
801072a2:	c1 e8 18             	shr    $0x18,%eax
801072a5:	c1 e9 10             	shr    $0x10,%ecx
801072a8:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
801072ae:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
801072b4:	b9 99 40 00 00       	mov    $0x4099,%ecx
801072b9:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801072c0:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
801072c5:	e8 a6 c6 ff ff       	call   80103970 <mycpu>
801072ca:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801072d1:	e8 9a c6 ff ff       	call   80103970 <mycpu>
801072d6:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801072da:	8b 5e 08             	mov    0x8(%esi),%ebx
801072dd:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801072e3:	e8 88 c6 ff ff       	call   80103970 <mycpu>
801072e8:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801072eb:	e8 80 c6 ff ff       	call   80103970 <mycpu>
801072f0:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801072f4:	b8 28 00 00 00       	mov    $0x28,%eax
801072f9:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
801072fc:	8b 46 04             	mov    0x4(%esi),%eax
801072ff:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107304:	0f 22 d8             	mov    %eax,%cr3
}
80107307:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010730a:	5b                   	pop    %ebx
8010730b:	5e                   	pop    %esi
8010730c:	5f                   	pop    %edi
8010730d:	5d                   	pop    %ebp
  popcli();
8010730e:	e9 cd d8 ff ff       	jmp    80104be0 <popcli>
    panic("switchuvm: no process");
80107313:	83 ec 0c             	sub    $0xc,%esp
80107316:	68 fa 81 10 80       	push   $0x801081fa
8010731b:	e8 70 90 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80107320:	83 ec 0c             	sub    $0xc,%esp
80107323:	68 25 82 10 80       	push   $0x80108225
80107328:	e8 63 90 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
8010732d:	83 ec 0c             	sub    $0xc,%esp
80107330:	68 10 82 10 80       	push   $0x80108210
80107335:	e8 56 90 ff ff       	call   80100390 <panic>
8010733a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107340 <inituvm>:
{
80107340:	f3 0f 1e fb          	endbr32 
80107344:	55                   	push   %ebp
80107345:	89 e5                	mov    %esp,%ebp
80107347:	57                   	push   %edi
80107348:	56                   	push   %esi
80107349:	53                   	push   %ebx
8010734a:	83 ec 1c             	sub    $0x1c,%esp
8010734d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107350:	8b 75 10             	mov    0x10(%ebp),%esi
80107353:	8b 7d 08             	mov    0x8(%ebp),%edi
80107356:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80107359:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010735f:	77 4b                	ja     801073ac <inituvm+0x6c>
  mem = kalloc();
80107361:	e8 da b2 ff ff       	call   80102640 <kalloc>
  memset(mem, 0, PGSIZE);
80107366:	83 ec 04             	sub    $0x4,%esp
80107369:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
8010736e:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107370:	6a 00                	push   $0x0
80107372:	50                   	push   %eax
80107373:	e8 28 da ff ff       	call   80104da0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107378:	58                   	pop    %eax
80107379:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010737f:	5a                   	pop    %edx
80107380:	6a 06                	push   $0x6
80107382:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107387:	31 d2                	xor    %edx,%edx
80107389:	50                   	push   %eax
8010738a:	89 f8                	mov    %edi,%eax
8010738c:	e8 af fc ff ff       	call   80107040 <mappages>
  memmove(mem, init, sz);
80107391:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107394:	89 75 10             	mov    %esi,0x10(%ebp)
80107397:	83 c4 10             	add    $0x10,%esp
8010739a:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010739d:	89 45 0c             	mov    %eax,0xc(%ebp)
}
801073a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073a3:	5b                   	pop    %ebx
801073a4:	5e                   	pop    %esi
801073a5:	5f                   	pop    %edi
801073a6:	5d                   	pop    %ebp
  memmove(mem, init, sz);
801073a7:	e9 94 da ff ff       	jmp    80104e40 <memmove>
    panic("inituvm: more than a page");
801073ac:	83 ec 0c             	sub    $0xc,%esp
801073af:	68 39 82 10 80       	push   $0x80108239
801073b4:	e8 d7 8f ff ff       	call   80100390 <panic>
801073b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801073c0 <loaduvm>:
{
801073c0:	f3 0f 1e fb          	endbr32 
801073c4:	55                   	push   %ebp
801073c5:	89 e5                	mov    %esp,%ebp
801073c7:	57                   	push   %edi
801073c8:	56                   	push   %esi
801073c9:	53                   	push   %ebx
801073ca:	83 ec 1c             	sub    $0x1c,%esp
801073cd:	8b 45 0c             	mov    0xc(%ebp),%eax
801073d0:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
801073d3:	a9 ff 0f 00 00       	test   $0xfff,%eax
801073d8:	0f 85 99 00 00 00    	jne    80107477 <loaduvm+0xb7>
  for(i = 0; i < sz; i += PGSIZE){
801073de:	01 f0                	add    %esi,%eax
801073e0:	89 f3                	mov    %esi,%ebx
801073e2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
801073e5:	8b 45 14             	mov    0x14(%ebp),%eax
801073e8:	01 f0                	add    %esi,%eax
801073ea:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
801073ed:	85 f6                	test   %esi,%esi
801073ef:	75 15                	jne    80107406 <loaduvm+0x46>
801073f1:	eb 6d                	jmp    80107460 <loaduvm+0xa0>
801073f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801073f7:	90                   	nop
801073f8:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
801073fe:	89 f0                	mov    %esi,%eax
80107400:	29 d8                	sub    %ebx,%eax
80107402:	39 c6                	cmp    %eax,%esi
80107404:	76 5a                	jbe    80107460 <loaduvm+0xa0>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107406:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107409:	8b 45 08             	mov    0x8(%ebp),%eax
8010740c:	31 c9                	xor    %ecx,%ecx
8010740e:	29 da                	sub    %ebx,%edx
80107410:	e8 ab fb ff ff       	call   80106fc0 <walkpgdir>
80107415:	85 c0                	test   %eax,%eax
80107417:	74 51                	je     8010746a <loaduvm+0xaa>
    pa = PTE_ADDR(*pte);
80107419:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010741b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
8010741e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107423:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107428:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
8010742e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107431:	29 d9                	sub    %ebx,%ecx
80107433:	05 00 00 00 80       	add    $0x80000000,%eax
80107438:	57                   	push   %edi
80107439:	51                   	push   %ecx
8010743a:	50                   	push   %eax
8010743b:	ff 75 10             	pushl  0x10(%ebp)
8010743e:	e8 2d a6 ff ff       	call   80101a70 <readi>
80107443:	83 c4 10             	add    $0x10,%esp
80107446:	39 f8                	cmp    %edi,%eax
80107448:	74 ae                	je     801073f8 <loaduvm+0x38>
}
8010744a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010744d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107452:	5b                   	pop    %ebx
80107453:	5e                   	pop    %esi
80107454:	5f                   	pop    %edi
80107455:	5d                   	pop    %ebp
80107456:	c3                   	ret    
80107457:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010745e:	66 90                	xchg   %ax,%ax
80107460:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107463:	31 c0                	xor    %eax,%eax
}
80107465:	5b                   	pop    %ebx
80107466:	5e                   	pop    %esi
80107467:	5f                   	pop    %edi
80107468:	5d                   	pop    %ebp
80107469:	c3                   	ret    
      panic("loaduvm: address should exist");
8010746a:	83 ec 0c             	sub    $0xc,%esp
8010746d:	68 53 82 10 80       	push   $0x80108253
80107472:	e8 19 8f ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107477:	83 ec 0c             	sub    $0xc,%esp
8010747a:	68 f4 82 10 80       	push   $0x801082f4
8010747f:	e8 0c 8f ff ff       	call   80100390 <panic>
80107484:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010748b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010748f:	90                   	nop

80107490 <allocuvm>:
{
80107490:	f3 0f 1e fb          	endbr32 
80107494:	55                   	push   %ebp
80107495:	89 e5                	mov    %esp,%ebp
80107497:	57                   	push   %edi
80107498:	56                   	push   %esi
80107499:	53                   	push   %ebx
8010749a:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
8010749d:	8b 45 10             	mov    0x10(%ebp),%eax
{
801074a0:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
801074a3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801074a6:	85 c0                	test   %eax,%eax
801074a8:	0f 88 b2 00 00 00    	js     80107560 <allocuvm+0xd0>
  if(newsz < oldsz)
801074ae:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
801074b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
801074b4:	0f 82 96 00 00 00    	jb     80107550 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
801074ba:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
801074c0:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
801074c6:	39 75 10             	cmp    %esi,0x10(%ebp)
801074c9:	77 40                	ja     8010750b <allocuvm+0x7b>
801074cb:	e9 83 00 00 00       	jmp    80107553 <allocuvm+0xc3>
    memset(mem, 0, PGSIZE);
801074d0:	83 ec 04             	sub    $0x4,%esp
801074d3:	68 00 10 00 00       	push   $0x1000
801074d8:	6a 00                	push   $0x0
801074da:	50                   	push   %eax
801074db:	e8 c0 d8 ff ff       	call   80104da0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801074e0:	58                   	pop    %eax
801074e1:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801074e7:	5a                   	pop    %edx
801074e8:	6a 06                	push   $0x6
801074ea:	b9 00 10 00 00       	mov    $0x1000,%ecx
801074ef:	89 f2                	mov    %esi,%edx
801074f1:	50                   	push   %eax
801074f2:	89 f8                	mov    %edi,%eax
801074f4:	e8 47 fb ff ff       	call   80107040 <mappages>
801074f9:	83 c4 10             	add    $0x10,%esp
801074fc:	85 c0                	test   %eax,%eax
801074fe:	78 78                	js     80107578 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80107500:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107506:	39 75 10             	cmp    %esi,0x10(%ebp)
80107509:	76 48                	jbe    80107553 <allocuvm+0xc3>
    mem = kalloc();
8010750b:	e8 30 b1 ff ff       	call   80102640 <kalloc>
80107510:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107512:	85 c0                	test   %eax,%eax
80107514:	75 ba                	jne    801074d0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107516:	83 ec 0c             	sub    $0xc,%esp
80107519:	68 71 82 10 80       	push   $0x80108271
8010751e:	e8 8d 91 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80107523:	8b 45 0c             	mov    0xc(%ebp),%eax
80107526:	83 c4 10             	add    $0x10,%esp
80107529:	39 45 10             	cmp    %eax,0x10(%ebp)
8010752c:	74 32                	je     80107560 <allocuvm+0xd0>
8010752e:	8b 55 10             	mov    0x10(%ebp),%edx
80107531:	89 c1                	mov    %eax,%ecx
80107533:	89 f8                	mov    %edi,%eax
80107535:	e8 96 fb ff ff       	call   801070d0 <deallocuvm.part.0>
      return 0;
8010753a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107541:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107544:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107547:	5b                   	pop    %ebx
80107548:	5e                   	pop    %esi
80107549:	5f                   	pop    %edi
8010754a:	5d                   	pop    %ebp
8010754b:	c3                   	ret    
8010754c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80107550:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107553:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107556:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107559:	5b                   	pop    %ebx
8010755a:	5e                   	pop    %esi
8010755b:	5f                   	pop    %edi
8010755c:	5d                   	pop    %ebp
8010755d:	c3                   	ret    
8010755e:	66 90                	xchg   %ax,%ax
    return 0;
80107560:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107567:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010756a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010756d:	5b                   	pop    %ebx
8010756e:	5e                   	pop    %esi
8010756f:	5f                   	pop    %edi
80107570:	5d                   	pop    %ebp
80107571:	c3                   	ret    
80107572:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107578:	83 ec 0c             	sub    $0xc,%esp
8010757b:	68 89 82 10 80       	push   $0x80108289
80107580:	e8 2b 91 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80107585:	8b 45 0c             	mov    0xc(%ebp),%eax
80107588:	83 c4 10             	add    $0x10,%esp
8010758b:	39 45 10             	cmp    %eax,0x10(%ebp)
8010758e:	74 0c                	je     8010759c <allocuvm+0x10c>
80107590:	8b 55 10             	mov    0x10(%ebp),%edx
80107593:	89 c1                	mov    %eax,%ecx
80107595:	89 f8                	mov    %edi,%eax
80107597:	e8 34 fb ff ff       	call   801070d0 <deallocuvm.part.0>
      kfree(mem);
8010759c:	83 ec 0c             	sub    $0xc,%esp
8010759f:	53                   	push   %ebx
801075a0:	e8 db ae ff ff       	call   80102480 <kfree>
      return 0;
801075a5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801075ac:	83 c4 10             	add    $0x10,%esp
}
801075af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801075b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801075b5:	5b                   	pop    %ebx
801075b6:	5e                   	pop    %esi
801075b7:	5f                   	pop    %edi
801075b8:	5d                   	pop    %ebp
801075b9:	c3                   	ret    
801075ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801075c0 <deallocuvm>:
{
801075c0:	f3 0f 1e fb          	endbr32 
801075c4:	55                   	push   %ebp
801075c5:	89 e5                	mov    %esp,%ebp
801075c7:	8b 55 0c             	mov    0xc(%ebp),%edx
801075ca:	8b 4d 10             	mov    0x10(%ebp),%ecx
801075cd:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
801075d0:	39 d1                	cmp    %edx,%ecx
801075d2:	73 0c                	jae    801075e0 <deallocuvm+0x20>
}
801075d4:	5d                   	pop    %ebp
801075d5:	e9 f6 fa ff ff       	jmp    801070d0 <deallocuvm.part.0>
801075da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801075e0:	89 d0                	mov    %edx,%eax
801075e2:	5d                   	pop    %ebp
801075e3:	c3                   	ret    
801075e4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801075eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801075ef:	90                   	nop

801075f0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801075f0:	f3 0f 1e fb          	endbr32 
801075f4:	55                   	push   %ebp
801075f5:	89 e5                	mov    %esp,%ebp
801075f7:	57                   	push   %edi
801075f8:	56                   	push   %esi
801075f9:	53                   	push   %ebx
801075fa:	83 ec 0c             	sub    $0xc,%esp
801075fd:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80107600:	85 f6                	test   %esi,%esi
80107602:	74 55                	je     80107659 <freevm+0x69>
  if(newsz >= oldsz)
80107604:	31 c9                	xor    %ecx,%ecx
80107606:	ba 00 00 00 80       	mov    $0x80000000,%edx
8010760b:	89 f0                	mov    %esi,%eax
8010760d:	89 f3                	mov    %esi,%ebx
8010760f:	e8 bc fa ff ff       	call   801070d0 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107614:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
8010761a:	eb 0b                	jmp    80107627 <freevm+0x37>
8010761c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107620:	83 c3 04             	add    $0x4,%ebx
80107623:	39 df                	cmp    %ebx,%edi
80107625:	74 23                	je     8010764a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107627:	8b 03                	mov    (%ebx),%eax
80107629:	a8 01                	test   $0x1,%al
8010762b:	74 f3                	je     80107620 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010762d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107632:	83 ec 0c             	sub    $0xc,%esp
80107635:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107638:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010763d:	50                   	push   %eax
8010763e:	e8 3d ae ff ff       	call   80102480 <kfree>
80107643:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107646:	39 df                	cmp    %ebx,%edi
80107648:	75 dd                	jne    80107627 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010764a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010764d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107650:	5b                   	pop    %ebx
80107651:	5e                   	pop    %esi
80107652:	5f                   	pop    %edi
80107653:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107654:	e9 27 ae ff ff       	jmp    80102480 <kfree>
    panic("freevm: no pgdir");
80107659:	83 ec 0c             	sub    $0xc,%esp
8010765c:	68 a5 82 10 80       	push   $0x801082a5
80107661:	e8 2a 8d ff ff       	call   80100390 <panic>
80107666:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010766d:	8d 76 00             	lea    0x0(%esi),%esi

80107670 <setupkvm>:
{
80107670:	f3 0f 1e fb          	endbr32 
80107674:	55                   	push   %ebp
80107675:	89 e5                	mov    %esp,%ebp
80107677:	56                   	push   %esi
80107678:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107679:	e8 c2 af ff ff       	call   80102640 <kalloc>
8010767e:	89 c6                	mov    %eax,%esi
80107680:	85 c0                	test   %eax,%eax
80107682:	74 42                	je     801076c6 <setupkvm+0x56>
  memset(pgdir, 0, PGSIZE);
80107684:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107687:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
8010768c:	68 00 10 00 00       	push   $0x1000
80107691:	6a 00                	push   $0x0
80107693:	50                   	push   %eax
80107694:	e8 07 d7 ff ff       	call   80104da0 <memset>
80107699:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
8010769c:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010769f:	83 ec 08             	sub    $0x8,%esp
801076a2:	8b 4b 08             	mov    0x8(%ebx),%ecx
801076a5:	ff 73 0c             	pushl  0xc(%ebx)
801076a8:	8b 13                	mov    (%ebx),%edx
801076aa:	50                   	push   %eax
801076ab:	29 c1                	sub    %eax,%ecx
801076ad:	89 f0                	mov    %esi,%eax
801076af:	e8 8c f9 ff ff       	call   80107040 <mappages>
801076b4:	83 c4 10             	add    $0x10,%esp
801076b7:	85 c0                	test   %eax,%eax
801076b9:	78 15                	js     801076d0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801076bb:	83 c3 10             	add    $0x10,%ebx
801076be:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
801076c4:	75 d6                	jne    8010769c <setupkvm+0x2c>
}
801076c6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801076c9:	89 f0                	mov    %esi,%eax
801076cb:	5b                   	pop    %ebx
801076cc:	5e                   	pop    %esi
801076cd:	5d                   	pop    %ebp
801076ce:	c3                   	ret    
801076cf:	90                   	nop
      freevm(pgdir);
801076d0:	83 ec 0c             	sub    $0xc,%esp
801076d3:	56                   	push   %esi
      return 0;
801076d4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
801076d6:	e8 15 ff ff ff       	call   801075f0 <freevm>
      return 0;
801076db:	83 c4 10             	add    $0x10,%esp
}
801076de:	8d 65 f8             	lea    -0x8(%ebp),%esp
801076e1:	89 f0                	mov    %esi,%eax
801076e3:	5b                   	pop    %ebx
801076e4:	5e                   	pop    %esi
801076e5:	5d                   	pop    %ebp
801076e6:	c3                   	ret    
801076e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801076ee:	66 90                	xchg   %ax,%ax

801076f0 <kvmalloc>:
{
801076f0:	f3 0f 1e fb          	endbr32 
801076f4:	55                   	push   %ebp
801076f5:	89 e5                	mov    %esp,%ebp
801076f7:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801076fa:	e8 71 ff ff ff       	call   80107670 <setupkvm>
801076ff:	a3 a4 72 11 80       	mov    %eax,0x801172a4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107704:	05 00 00 00 80       	add    $0x80000000,%eax
80107709:	0f 22 d8             	mov    %eax,%cr3
}
8010770c:	c9                   	leave  
8010770d:	c3                   	ret    
8010770e:	66 90                	xchg   %ax,%ax

80107710 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107710:	f3 0f 1e fb          	endbr32 
80107714:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107715:	31 c9                	xor    %ecx,%ecx
{
80107717:	89 e5                	mov    %esp,%ebp
80107719:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
8010771c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010771f:	8b 45 08             	mov    0x8(%ebp),%eax
80107722:	e8 99 f8 ff ff       	call   80106fc0 <walkpgdir>
  if(pte == 0)
80107727:	85 c0                	test   %eax,%eax
80107729:	74 05                	je     80107730 <clearpteu+0x20>
    panic("clearpteu");
  *pte &= ~PTE_U;
8010772b:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010772e:	c9                   	leave  
8010772f:	c3                   	ret    
    panic("clearpteu");
80107730:	83 ec 0c             	sub    $0xc,%esp
80107733:	68 b6 82 10 80       	push   $0x801082b6
80107738:	e8 53 8c ff ff       	call   80100390 <panic>
8010773d:	8d 76 00             	lea    0x0(%esi),%esi

80107740 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107740:	f3 0f 1e fb          	endbr32 
80107744:	55                   	push   %ebp
80107745:	89 e5                	mov    %esp,%ebp
80107747:	57                   	push   %edi
80107748:	56                   	push   %esi
80107749:	53                   	push   %ebx
8010774a:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
8010774d:	e8 1e ff ff ff       	call   80107670 <setupkvm>
80107752:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107755:	85 c0                	test   %eax,%eax
80107757:	0f 84 9b 00 00 00    	je     801077f8 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
8010775d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107760:	85 c9                	test   %ecx,%ecx
80107762:	0f 84 90 00 00 00    	je     801077f8 <copyuvm+0xb8>
80107768:	31 f6                	xor    %esi,%esi
8010776a:	eb 46                	jmp    801077b2 <copyuvm+0x72>
8010776c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107770:	83 ec 04             	sub    $0x4,%esp
80107773:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107779:	68 00 10 00 00       	push   $0x1000
8010777e:	57                   	push   %edi
8010777f:	50                   	push   %eax
80107780:	e8 bb d6 ff ff       	call   80104e40 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107785:	58                   	pop    %eax
80107786:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010778c:	5a                   	pop    %edx
8010778d:	ff 75 e4             	pushl  -0x1c(%ebp)
80107790:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107795:	89 f2                	mov    %esi,%edx
80107797:	50                   	push   %eax
80107798:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010779b:	e8 a0 f8 ff ff       	call   80107040 <mappages>
801077a0:	83 c4 10             	add    $0x10,%esp
801077a3:	85 c0                	test   %eax,%eax
801077a5:	78 61                	js     80107808 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
801077a7:	81 c6 00 10 00 00    	add    $0x1000,%esi
801077ad:	39 75 0c             	cmp    %esi,0xc(%ebp)
801077b0:	76 46                	jbe    801077f8 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801077b2:	8b 45 08             	mov    0x8(%ebp),%eax
801077b5:	31 c9                	xor    %ecx,%ecx
801077b7:	89 f2                	mov    %esi,%edx
801077b9:	e8 02 f8 ff ff       	call   80106fc0 <walkpgdir>
801077be:	85 c0                	test   %eax,%eax
801077c0:	74 61                	je     80107823 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
801077c2:	8b 00                	mov    (%eax),%eax
801077c4:	a8 01                	test   $0x1,%al
801077c6:	74 4e                	je     80107816 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
801077c8:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
801077ca:	25 ff 0f 00 00       	and    $0xfff,%eax
801077cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
801077d2:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
801077d8:	e8 63 ae ff ff       	call   80102640 <kalloc>
801077dd:	89 c3                	mov    %eax,%ebx
801077df:	85 c0                	test   %eax,%eax
801077e1:	75 8d                	jne    80107770 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
801077e3:	83 ec 0c             	sub    $0xc,%esp
801077e6:	ff 75 e0             	pushl  -0x20(%ebp)
801077e9:	e8 02 fe ff ff       	call   801075f0 <freevm>
  return 0;
801077ee:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
801077f5:	83 c4 10             	add    $0x10,%esp
}
801077f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801077fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801077fe:	5b                   	pop    %ebx
801077ff:	5e                   	pop    %esi
80107800:	5f                   	pop    %edi
80107801:	5d                   	pop    %ebp
80107802:	c3                   	ret    
80107803:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107807:	90                   	nop
      kfree(mem);
80107808:	83 ec 0c             	sub    $0xc,%esp
8010780b:	53                   	push   %ebx
8010780c:	e8 6f ac ff ff       	call   80102480 <kfree>
      goto bad;
80107811:	83 c4 10             	add    $0x10,%esp
80107814:	eb cd                	jmp    801077e3 <copyuvm+0xa3>
      panic("copyuvm: page not present");
80107816:	83 ec 0c             	sub    $0xc,%esp
80107819:	68 da 82 10 80       	push   $0x801082da
8010781e:	e8 6d 8b ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80107823:	83 ec 0c             	sub    $0xc,%esp
80107826:	68 c0 82 10 80       	push   $0x801082c0
8010782b:	e8 60 8b ff ff       	call   80100390 <panic>

80107830 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107830:	f3 0f 1e fb          	endbr32 
80107834:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107835:	31 c9                	xor    %ecx,%ecx
{
80107837:	89 e5                	mov    %esp,%ebp
80107839:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
8010783c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010783f:	8b 45 08             	mov    0x8(%ebp),%eax
80107842:	e8 79 f7 ff ff       	call   80106fc0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107847:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107849:	c9                   	leave  
  if((*pte & PTE_U) == 0)
8010784a:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
8010784c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107851:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107854:	05 00 00 00 80       	add    $0x80000000,%eax
80107859:	83 fa 05             	cmp    $0x5,%edx
8010785c:	ba 00 00 00 00       	mov    $0x0,%edx
80107861:	0f 45 c2             	cmovne %edx,%eax
}
80107864:	c3                   	ret    
80107865:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010786c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107870 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107870:	f3 0f 1e fb          	endbr32 
80107874:	55                   	push   %ebp
80107875:	89 e5                	mov    %esp,%ebp
80107877:	57                   	push   %edi
80107878:	56                   	push   %esi
80107879:	53                   	push   %ebx
8010787a:	83 ec 0c             	sub    $0xc,%esp
8010787d:	8b 75 14             	mov    0x14(%ebp),%esi
80107880:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107883:	85 f6                	test   %esi,%esi
80107885:	75 3c                	jne    801078c3 <copyout+0x53>
80107887:	eb 67                	jmp    801078f0 <copyout+0x80>
80107889:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107890:	8b 55 0c             	mov    0xc(%ebp),%edx
80107893:	89 fb                	mov    %edi,%ebx
80107895:	29 d3                	sub    %edx,%ebx
80107897:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
8010789d:	39 f3                	cmp    %esi,%ebx
8010789f:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801078a2:	29 fa                	sub    %edi,%edx
801078a4:	83 ec 04             	sub    $0x4,%esp
801078a7:	01 c2                	add    %eax,%edx
801078a9:	53                   	push   %ebx
801078aa:	ff 75 10             	pushl  0x10(%ebp)
801078ad:	52                   	push   %edx
801078ae:	e8 8d d5 ff ff       	call   80104e40 <memmove>
    len -= n;
    buf += n;
801078b3:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
801078b6:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while(len > 0){
801078bc:	83 c4 10             	add    $0x10,%esp
801078bf:	29 de                	sub    %ebx,%esi
801078c1:	74 2d                	je     801078f0 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
801078c3:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
801078c5:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
801078c8:	89 55 0c             	mov    %edx,0xc(%ebp)
801078cb:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
801078d1:	57                   	push   %edi
801078d2:	ff 75 08             	pushl  0x8(%ebp)
801078d5:	e8 56 ff ff ff       	call   80107830 <uva2ka>
    if(pa0 == 0)
801078da:	83 c4 10             	add    $0x10,%esp
801078dd:	85 c0                	test   %eax,%eax
801078df:	75 af                	jne    80107890 <copyout+0x20>
  }
  return 0;
}
801078e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801078e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801078e9:	5b                   	pop    %ebx
801078ea:	5e                   	pop    %esi
801078eb:	5f                   	pop    %edi
801078ec:	5d                   	pop    %ebp
801078ed:	c3                   	ret    
801078ee:	66 90                	xchg   %ax,%ax
801078f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801078f3:	31 c0                	xor    %eax,%eax
}
801078f5:	5b                   	pop    %ebx
801078f6:	5e                   	pop    %esi
801078f7:	5f                   	pop    %edi
801078f8:	5d                   	pop    %ebp
801078f9:	c3                   	ret    
