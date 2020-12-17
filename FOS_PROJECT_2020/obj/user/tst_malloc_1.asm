
obj/user/tst_malloc_1:     file format elf32-i386


Disassembly of section .text:

00800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	mov $0, %eax
  800020:	b8 00 00 00 00       	mov    $0x0,%eax
	cmpl $USTACKTOP, %esp
  800025:	81 fc 00 e0 bf ee    	cmp    $0xeebfe000,%esp
	jne args_exist
  80002b:	75 04                	jne    800031 <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushl $0
  80002d:	6a 00                	push   $0x0
	pushl $0
  80002f:	6a 00                	push   $0x0

00800031 <args_exist>:

args_exist:
	call libmain
  800031:	e8 99 05 00 00       	call   8005cf <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/* *********************************************************** */

#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	53                   	push   %ebx
  80003d:	83 ec 70             	sub    $0x70,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  800040:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800044:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80004b:	eb 23                	jmp    800070 <_main+0x38>
		{
			if (myEnv->__uptr_pws[i].empty)
  80004d:	a1 20 30 80 00       	mov    0x803020,%eax
  800052:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800058:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80005b:	c1 e2 04             	shl    $0x4,%edx
  80005e:	01 d0                	add    %edx,%eax
  800060:	8a 40 04             	mov    0x4(%eax),%al
  800063:	84 c0                	test   %al,%al
  800065:	74 06                	je     80006d <_main+0x35>
			{
				fullWS = 0;
  800067:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  80006b:	eb 12                	jmp    80007f <_main+0x47>
void _main(void)
{
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  80006d:	ff 45 f0             	incl   -0x10(%ebp)
  800070:	a1 20 30 80 00       	mov    0x803020,%eax
  800075:	8b 50 74             	mov    0x74(%eax),%edx
  800078:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80007b:	39 c2                	cmp    %eax,%edx
  80007d:	77 ce                	ja     80004d <_main+0x15>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  80007f:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800083:	74 14                	je     800099 <_main+0x61>
  800085:	83 ec 04             	sub    $0x4,%esp
  800088:	68 c0 20 80 00       	push   $0x8020c0
  80008d:	6a 14                	push   $0x14
  80008f:	68 dc 20 80 00       	push   $0x8020dc
  800094:	e8 7b 06 00 00       	call   800714 <_panic>
	}


	int Mega = 1024*1024;
  800099:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000a0:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)

	void* ptr_allocations[20] = {0};
  8000a7:	8d 55 90             	lea    -0x70(%ebp),%edx
  8000aa:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000af:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b4:	89 d7                	mov    %edx,%edi
  8000b6:	f3 ab                	rep stos %eax,%es:(%edi)
	{
		int freeFrames = sys_calculate_free_frames() ;
  8000b8:	e8 97 18 00 00       	call   801954 <sys_calculate_free_frames>
  8000bd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000c0:	e8 12 19 00 00       	call   8019d7 <sys_pf_calculate_allocated_pages>
  8000c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  8000c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000cb:	01 c0                	add    %eax,%eax
  8000cd:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8000d0:	83 ec 0c             	sub    $0xc,%esp
  8000d3:	50                   	push   %eax
  8000d4:	e8 67 16 00 00       	call   801740 <malloc>
  8000d9:	83 c4 10             	add    $0x10,%esp
  8000dc:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[0] <  (USER_HEAP_START) || (uint32) ptr_allocations[0] > (USER_HEAP_START + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  8000df:	8b 45 90             	mov    -0x70(%ebp),%eax
  8000e2:	85 c0                	test   %eax,%eax
  8000e4:	79 0a                	jns    8000f0 <_main+0xb8>
  8000e6:	8b 45 90             	mov    -0x70(%ebp),%eax
  8000e9:	3d 00 10 00 80       	cmp    $0x80001000,%eax
  8000ee:	76 14                	jbe    800104 <_main+0xcc>
  8000f0:	83 ec 04             	sub    $0x4,%esp
  8000f3:	68 f0 20 80 00       	push   $0x8020f0
  8000f8:	6a 20                	push   $0x20
  8000fa:	68 dc 20 80 00       	push   $0x8020dc
  8000ff:	e8 10 06 00 00       	call   800714 <_panic>
		//		if ((freeFrames - sys_calculate_free_frames()) != 512+1 ) panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800104:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800107:	e8 48 18 00 00       	call   801954 <sys_calculate_free_frames>
  80010c:	29 c3                	sub    %eax,%ebx
  80010e:	89 d8                	mov    %ebx,%eax
  800110:	83 f8 01             	cmp    $0x1,%eax
  800113:	74 14                	je     800129 <_main+0xf1>
  800115:	83 ec 04             	sub    $0x4,%esp
  800118:	68 20 21 80 00       	push   $0x802120
  80011d:	6a 22                	push   $0x22
  80011f:	68 dc 20 80 00       	push   $0x8020dc
  800124:	e8 eb 05 00 00       	call   800714 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  800129:	e8 a9 18 00 00       	call   8019d7 <sys_pf_calculate_allocated_pages>
  80012e:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800131:	3d 00 02 00 00       	cmp    $0x200,%eax
  800136:	74 14                	je     80014c <_main+0x114>
  800138:	83 ec 04             	sub    $0x4,%esp
  80013b:	68 8c 21 80 00       	push   $0x80218c
  800140:	6a 23                	push   $0x23
  800142:	68 dc 20 80 00       	push   $0x8020dc
  800147:	e8 c8 05 00 00       	call   800714 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  80014c:	e8 03 18 00 00       	call   801954 <sys_calculate_free_frames>
  800151:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800154:	e8 7e 18 00 00       	call   8019d7 <sys_pf_calculate_allocated_pages>
  800159:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[1] = malloc(2*Mega-kilo);
  80015c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80015f:	01 c0                	add    %eax,%eax
  800161:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800164:	83 ec 0c             	sub    $0xc,%esp
  800167:	50                   	push   %eax
  800168:	e8 d3 15 00 00       	call   801740 <malloc>
  80016d:	83 c4 10             	add    $0x10,%esp
  800170:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[1] < (USER_HEAP_START + 2*Mega) || (uint32) ptr_allocations[1] > (USER_HEAP_START + 2*Mega + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  800173:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800176:	89 c2                	mov    %eax,%edx
  800178:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80017b:	01 c0                	add    %eax,%eax
  80017d:	05 00 00 00 80       	add    $0x80000000,%eax
  800182:	39 c2                	cmp    %eax,%edx
  800184:	72 13                	jb     800199 <_main+0x161>
  800186:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800189:	89 c2                	mov    %eax,%edx
  80018b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80018e:	01 c0                	add    %eax,%eax
  800190:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800195:	39 c2                	cmp    %eax,%edx
  800197:	76 14                	jbe    8001ad <_main+0x175>
  800199:	83 ec 04             	sub    $0x4,%esp
  80019c:	68 f0 20 80 00       	push   $0x8020f0
  8001a1:	6a 28                	push   $0x28
  8001a3:	68 dc 20 80 00       	push   $0x8020dc
  8001a8:	e8 67 05 00 00       	call   800714 <_panic>
		//		if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8001ad:	e8 a2 17 00 00       	call   801954 <sys_calculate_free_frames>
  8001b2:	89 c2                	mov    %eax,%edx
  8001b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001b7:	39 c2                	cmp    %eax,%edx
  8001b9:	74 14                	je     8001cf <_main+0x197>
  8001bb:	83 ec 04             	sub    $0x4,%esp
  8001be:	68 20 21 80 00       	push   $0x802120
  8001c3:	6a 2a                	push   $0x2a
  8001c5:	68 dc 20 80 00       	push   $0x8020dc
  8001ca:	e8 45 05 00 00       	call   800714 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  8001cf:	e8 03 18 00 00       	call   8019d7 <sys_pf_calculate_allocated_pages>
  8001d4:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8001d7:	3d 00 02 00 00       	cmp    $0x200,%eax
  8001dc:	74 14                	je     8001f2 <_main+0x1ba>
  8001de:	83 ec 04             	sub    $0x4,%esp
  8001e1:	68 8c 21 80 00       	push   $0x80218c
  8001e6:	6a 2b                	push   $0x2b
  8001e8:	68 dc 20 80 00       	push   $0x8020dc
  8001ed:	e8 22 05 00 00       	call   800714 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8001f2:	e8 5d 17 00 00       	call   801954 <sys_calculate_free_frames>
  8001f7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001fa:	e8 d8 17 00 00       	call   8019d7 <sys_pf_calculate_allocated_pages>
  8001ff:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[2] = malloc(3*kilo);
  800202:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800205:	89 c2                	mov    %eax,%edx
  800207:	01 d2                	add    %edx,%edx
  800209:	01 d0                	add    %edx,%eax
  80020b:	83 ec 0c             	sub    $0xc,%esp
  80020e:	50                   	push   %eax
  80020f:	e8 2c 15 00 00       	call   801740 <malloc>
  800214:	83 c4 10             	add    $0x10,%esp
  800217:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[2] < (USER_HEAP_START + 4*Mega) || (uint32) ptr_allocations[2] > (USER_HEAP_START + 4*Mega + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  80021a:	8b 45 98             	mov    -0x68(%ebp),%eax
  80021d:	89 c2                	mov    %eax,%edx
  80021f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800222:	c1 e0 02             	shl    $0x2,%eax
  800225:	05 00 00 00 80       	add    $0x80000000,%eax
  80022a:	39 c2                	cmp    %eax,%edx
  80022c:	72 14                	jb     800242 <_main+0x20a>
  80022e:	8b 45 98             	mov    -0x68(%ebp),%eax
  800231:	89 c2                	mov    %eax,%edx
  800233:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800236:	c1 e0 02             	shl    $0x2,%eax
  800239:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  80023e:	39 c2                	cmp    %eax,%edx
  800240:	76 14                	jbe    800256 <_main+0x21e>
  800242:	83 ec 04             	sub    $0x4,%esp
  800245:	68 f0 20 80 00       	push   $0x8020f0
  80024a:	6a 30                	push   $0x30
  80024c:	68 dc 20 80 00       	push   $0x8020dc
  800251:	e8 be 04 00 00       	call   800714 <_panic>
		//		if ((freeFrames - sys_calculate_free_frames()) != 1+1 ) panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800256:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800259:	e8 f6 16 00 00       	call   801954 <sys_calculate_free_frames>
  80025e:	29 c3                	sub    %eax,%ebx
  800260:	89 d8                	mov    %ebx,%eax
  800262:	83 f8 01             	cmp    $0x1,%eax
  800265:	74 14                	je     80027b <_main+0x243>
  800267:	83 ec 04             	sub    $0x4,%esp
  80026a:	68 20 21 80 00       	push   $0x802120
  80026f:	6a 32                	push   $0x32
  800271:	68 dc 20 80 00       	push   $0x8020dc
  800276:	e8 99 04 00 00       	call   800714 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 1) panic("Extra or less pages are allocated in PageFile");
  80027b:	e8 57 17 00 00       	call   8019d7 <sys_pf_calculate_allocated_pages>
  800280:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800283:	83 f8 01             	cmp    $0x1,%eax
  800286:	74 14                	je     80029c <_main+0x264>
  800288:	83 ec 04             	sub    $0x4,%esp
  80028b:	68 8c 21 80 00       	push   $0x80218c
  800290:	6a 33                	push   $0x33
  800292:	68 dc 20 80 00       	push   $0x8020dc
  800297:	e8 78 04 00 00       	call   800714 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  80029c:	e8 b3 16 00 00       	call   801954 <sys_calculate_free_frames>
  8002a1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8002a4:	e8 2e 17 00 00       	call   8019d7 <sys_pf_calculate_allocated_pages>
  8002a9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[3] = malloc(3*kilo);
  8002ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002af:	89 c2                	mov    %eax,%edx
  8002b1:	01 d2                	add    %edx,%edx
  8002b3:	01 d0                	add    %edx,%eax
  8002b5:	83 ec 0c             	sub    $0xc,%esp
  8002b8:	50                   	push   %eax
  8002b9:	e8 82 14 00 00       	call   801740 <malloc>
  8002be:	83 c4 10             	add    $0x10,%esp
  8002c1:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if ((uint32) ptr_allocations[3] < (USER_HEAP_START + 4*Mega + 4*kilo) || (uint32) ptr_allocations[3] > (USER_HEAP_START + 4*Mega + 4*kilo + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  8002c4:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8002c7:	89 c2                	mov    %eax,%edx
  8002c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002cc:	c1 e0 02             	shl    $0x2,%eax
  8002cf:	89 c1                	mov    %eax,%ecx
  8002d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002d4:	c1 e0 02             	shl    $0x2,%eax
  8002d7:	01 c8                	add    %ecx,%eax
  8002d9:	05 00 00 00 80       	add    $0x80000000,%eax
  8002de:	39 c2                	cmp    %eax,%edx
  8002e0:	72 1e                	jb     800300 <_main+0x2c8>
  8002e2:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8002e5:	89 c2                	mov    %eax,%edx
  8002e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002ea:	c1 e0 02             	shl    $0x2,%eax
  8002ed:	89 c1                	mov    %eax,%ecx
  8002ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002f2:	c1 e0 02             	shl    $0x2,%eax
  8002f5:	01 c8                	add    %ecx,%eax
  8002f7:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8002fc:	39 c2                	cmp    %eax,%edx
  8002fe:	76 14                	jbe    800314 <_main+0x2dc>
  800300:	83 ec 04             	sub    $0x4,%esp
  800303:	68 f0 20 80 00       	push   $0x8020f0
  800308:	6a 38                	push   $0x38
  80030a:	68 dc 20 80 00       	push   $0x8020dc
  80030f:	e8 00 04 00 00       	call   800714 <_panic>
		//		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800314:	e8 3b 16 00 00       	call   801954 <sys_calculate_free_frames>
  800319:	89 c2                	mov    %eax,%edx
  80031b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80031e:	39 c2                	cmp    %eax,%edx
  800320:	74 14                	je     800336 <_main+0x2fe>
  800322:	83 ec 04             	sub    $0x4,%esp
  800325:	68 20 21 80 00       	push   $0x802120
  80032a:	6a 3a                	push   $0x3a
  80032c:	68 dc 20 80 00       	push   $0x8020dc
  800331:	e8 de 03 00 00       	call   800714 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 1) panic("Extra or less pages are allocated in PageFile");
  800336:	e8 9c 16 00 00       	call   8019d7 <sys_pf_calculate_allocated_pages>
  80033b:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80033e:	83 f8 01             	cmp    $0x1,%eax
  800341:	74 14                	je     800357 <_main+0x31f>
  800343:	83 ec 04             	sub    $0x4,%esp
  800346:	68 8c 21 80 00       	push   $0x80218c
  80034b:	6a 3b                	push   $0x3b
  80034d:	68 dc 20 80 00       	push   $0x8020dc
  800352:	e8 bd 03 00 00       	call   800714 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800357:	e8 f8 15 00 00       	call   801954 <sys_calculate_free_frames>
  80035c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80035f:	e8 73 16 00 00       	call   8019d7 <sys_pf_calculate_allocated_pages>
  800364:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[4] = malloc(7*kilo);
  800367:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80036a:	89 d0                	mov    %edx,%eax
  80036c:	01 c0                	add    %eax,%eax
  80036e:	01 d0                	add    %edx,%eax
  800370:	01 c0                	add    %eax,%eax
  800372:	01 d0                	add    %edx,%eax
  800374:	83 ec 0c             	sub    $0xc,%esp
  800377:	50                   	push   %eax
  800378:	e8 c3 13 00 00       	call   801740 <malloc>
  80037d:	83 c4 10             	add    $0x10,%esp
  800380:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[4] < (USER_HEAP_START + 4*Mega + 8*kilo) || (uint32) ptr_allocations[4] > (USER_HEAP_START + 4*Mega + 8*kilo + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  800383:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800386:	89 c2                	mov    %eax,%edx
  800388:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80038b:	c1 e0 02             	shl    $0x2,%eax
  80038e:	89 c1                	mov    %eax,%ecx
  800390:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800393:	c1 e0 03             	shl    $0x3,%eax
  800396:	01 c8                	add    %ecx,%eax
  800398:	05 00 00 00 80       	add    $0x80000000,%eax
  80039d:	39 c2                	cmp    %eax,%edx
  80039f:	72 1e                	jb     8003bf <_main+0x387>
  8003a1:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8003a4:	89 c2                	mov    %eax,%edx
  8003a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003a9:	c1 e0 02             	shl    $0x2,%eax
  8003ac:	89 c1                	mov    %eax,%ecx
  8003ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003b1:	c1 e0 03             	shl    $0x3,%eax
  8003b4:	01 c8                	add    %ecx,%eax
  8003b6:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8003bb:	39 c2                	cmp    %eax,%edx
  8003bd:	76 14                	jbe    8003d3 <_main+0x39b>
  8003bf:	83 ec 04             	sub    $0x4,%esp
  8003c2:	68 f0 20 80 00       	push   $0x8020f0
  8003c7:	6a 40                	push   $0x40
  8003c9:	68 dc 20 80 00       	push   $0x8020dc
  8003ce:	e8 41 03 00 00       	call   800714 <_panic>
		//		if ((freeFrames - sys_calculate_free_frames()) != 2)panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8003d3:	e8 7c 15 00 00       	call   801954 <sys_calculate_free_frames>
  8003d8:	89 c2                	mov    %eax,%edx
  8003da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003dd:	39 c2                	cmp    %eax,%edx
  8003df:	74 14                	je     8003f5 <_main+0x3bd>
  8003e1:	83 ec 04             	sub    $0x4,%esp
  8003e4:	68 20 21 80 00       	push   $0x802120
  8003e9:	6a 42                	push   $0x42
  8003eb:	68 dc 20 80 00       	push   $0x8020dc
  8003f0:	e8 1f 03 00 00       	call   800714 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 2) panic("Extra or less pages are allocated in PageFile");
  8003f5:	e8 dd 15 00 00       	call   8019d7 <sys_pf_calculate_allocated_pages>
  8003fa:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8003fd:	83 f8 02             	cmp    $0x2,%eax
  800400:	74 14                	je     800416 <_main+0x3de>
  800402:	83 ec 04             	sub    $0x4,%esp
  800405:	68 8c 21 80 00       	push   $0x80218c
  80040a:	6a 43                	push   $0x43
  80040c:	68 dc 20 80 00       	push   $0x8020dc
  800411:	e8 fe 02 00 00       	call   800714 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800416:	e8 39 15 00 00       	call   801954 <sys_calculate_free_frames>
  80041b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80041e:	e8 b4 15 00 00       	call   8019d7 <sys_pf_calculate_allocated_pages>
  800423:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  800426:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800429:	89 c2                	mov    %eax,%edx
  80042b:	01 d2                	add    %edx,%edx
  80042d:	01 d0                	add    %edx,%eax
  80042f:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800432:	83 ec 0c             	sub    $0xc,%esp
  800435:	50                   	push   %eax
  800436:	e8 05 13 00 00       	call   801740 <malloc>
  80043b:	83 c4 10             	add    $0x10,%esp
  80043e:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if ((uint32) ptr_allocations[5] < (USER_HEAP_START + 4*Mega + 16*kilo) || (uint32) ptr_allocations[5] > (USER_HEAP_START + 4*Mega + 16*kilo + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  800441:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800444:	89 c2                	mov    %eax,%edx
  800446:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800449:	c1 e0 02             	shl    $0x2,%eax
  80044c:	89 c1                	mov    %eax,%ecx
  80044e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800451:	c1 e0 04             	shl    $0x4,%eax
  800454:	01 c8                	add    %ecx,%eax
  800456:	05 00 00 00 80       	add    $0x80000000,%eax
  80045b:	39 c2                	cmp    %eax,%edx
  80045d:	72 1e                	jb     80047d <_main+0x445>
  80045f:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800462:	89 c2                	mov    %eax,%edx
  800464:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800467:	c1 e0 02             	shl    $0x2,%eax
  80046a:	89 c1                	mov    %eax,%ecx
  80046c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80046f:	c1 e0 04             	shl    $0x4,%eax
  800472:	01 c8                	add    %ecx,%eax
  800474:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800479:	39 c2                	cmp    %eax,%edx
  80047b:	76 14                	jbe    800491 <_main+0x459>
  80047d:	83 ec 04             	sub    $0x4,%esp
  800480:	68 f0 20 80 00       	push   $0x8020f0
  800485:	6a 48                	push   $0x48
  800487:	68 dc 20 80 00       	push   $0x8020dc
  80048c:	e8 83 02 00 00       	call   800714 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  800491:	e8 be 14 00 00       	call   801954 <sys_calculate_free_frames>
  800496:	89 c2                	mov    %eax,%edx
  800498:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80049b:	39 c2                	cmp    %eax,%edx
  80049d:	74 14                	je     8004b3 <_main+0x47b>
  80049f:	83 ec 04             	sub    $0x4,%esp
  8004a2:	68 ba 21 80 00       	push   $0x8021ba
  8004a7:	6a 49                	push   $0x49
  8004a9:	68 dc 20 80 00       	push   $0x8020dc
  8004ae:	e8 61 02 00 00       	call   800714 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 3*Mega/4096) panic("Extra or less pages are allocated in PageFile");
  8004b3:	e8 1f 15 00 00       	call   8019d7 <sys_pf_calculate_allocated_pages>
  8004b8:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8004bb:	89 c2                	mov    %eax,%edx
  8004bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8004c0:	89 c1                	mov    %eax,%ecx
  8004c2:	01 c9                	add    %ecx,%ecx
  8004c4:	01 c8                	add    %ecx,%eax
  8004c6:	85 c0                	test   %eax,%eax
  8004c8:	79 05                	jns    8004cf <_main+0x497>
  8004ca:	05 ff 0f 00 00       	add    $0xfff,%eax
  8004cf:	c1 f8 0c             	sar    $0xc,%eax
  8004d2:	39 c2                	cmp    %eax,%edx
  8004d4:	74 14                	je     8004ea <_main+0x4b2>
  8004d6:	83 ec 04             	sub    $0x4,%esp
  8004d9:	68 8c 21 80 00       	push   $0x80218c
  8004de:	6a 4a                	push   $0x4a
  8004e0:	68 dc 20 80 00       	push   $0x8020dc
  8004e5:	e8 2a 02 00 00       	call   800714 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8004ea:	e8 65 14 00 00       	call   801954 <sys_calculate_free_frames>
  8004ef:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8004f2:	e8 e0 14 00 00       	call   8019d7 <sys_pf_calculate_allocated_pages>
  8004f7:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[6] = malloc(2*Mega-kilo);
  8004fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8004fd:	01 c0                	add    %eax,%eax
  8004ff:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800502:	83 ec 0c             	sub    $0xc,%esp
  800505:	50                   	push   %eax
  800506:	e8 35 12 00 00       	call   801740 <malloc>
  80050b:	83 c4 10             	add    $0x10,%esp
  80050e:	89 45 a8             	mov    %eax,-0x58(%ebp)
		if ((uint32) ptr_allocations[6] < (USER_HEAP_START + 7*Mega + 16*kilo) || (uint32) ptr_allocations[6] > (USER_HEAP_START + 7*Mega + 16*kilo + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  800511:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800514:	89 c1                	mov    %eax,%ecx
  800516:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800519:	89 d0                	mov    %edx,%eax
  80051b:	01 c0                	add    %eax,%eax
  80051d:	01 d0                	add    %edx,%eax
  80051f:	01 c0                	add    %eax,%eax
  800521:	01 d0                	add    %edx,%eax
  800523:	89 c2                	mov    %eax,%edx
  800525:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800528:	c1 e0 04             	shl    $0x4,%eax
  80052b:	01 d0                	add    %edx,%eax
  80052d:	05 00 00 00 80       	add    $0x80000000,%eax
  800532:	39 c1                	cmp    %eax,%ecx
  800534:	72 25                	jb     80055b <_main+0x523>
  800536:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800539:	89 c1                	mov    %eax,%ecx
  80053b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80053e:	89 d0                	mov    %edx,%eax
  800540:	01 c0                	add    %eax,%eax
  800542:	01 d0                	add    %edx,%eax
  800544:	01 c0                	add    %eax,%eax
  800546:	01 d0                	add    %edx,%eax
  800548:	89 c2                	mov    %eax,%edx
  80054a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80054d:	c1 e0 04             	shl    $0x4,%eax
  800550:	01 d0                	add    %edx,%eax
  800552:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800557:	39 c1                	cmp    %eax,%ecx
  800559:	76 14                	jbe    80056f <_main+0x537>
  80055b:	83 ec 04             	sub    $0x4,%esp
  80055e:	68 f0 20 80 00       	push   $0x8020f0
  800563:	6a 4f                	push   $0x4f
  800565:	68 dc 20 80 00       	push   $0x8020dc
  80056a:	e8 a5 01 00 00       	call   800714 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
  80056f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800572:	e8 dd 13 00 00       	call   801954 <sys_calculate_free_frames>
  800577:	29 c3                	sub    %eax,%ebx
  800579:	89 d8                	mov    %ebx,%eax
  80057b:	83 f8 01             	cmp    $0x1,%eax
  80057e:	74 14                	je     800594 <_main+0x55c>
  800580:	83 ec 04             	sub    $0x4,%esp
  800583:	68 ba 21 80 00       	push   $0x8021ba
  800588:	6a 50                	push   $0x50
  80058a:	68 dc 20 80 00       	push   $0x8020dc
  80058f:	e8 80 01 00 00       	call   800714 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  800594:	e8 3e 14 00 00       	call   8019d7 <sys_pf_calculate_allocated_pages>
  800599:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80059c:	3d 00 02 00 00       	cmp    $0x200,%eax
  8005a1:	74 14                	je     8005b7 <_main+0x57f>
  8005a3:	83 ec 04             	sub    $0x4,%esp
  8005a6:	68 8c 21 80 00       	push   $0x80218c
  8005ab:	6a 51                	push   $0x51
  8005ad:	68 dc 20 80 00       	push   $0x8020dc
  8005b2:	e8 5d 01 00 00       	call   800714 <_panic>
	}

	cprintf("Congratulations!! test malloc (1) completed successfully.\n");
  8005b7:	83 ec 0c             	sub    $0xc,%esp
  8005ba:	68 d0 21 80 00       	push   $0x8021d0
  8005bf:	e8 f2 03 00 00       	call   8009b6 <cprintf>
  8005c4:	83 c4 10             	add    $0x10,%esp

	return;
  8005c7:	90                   	nop
}
  8005c8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8005cb:	5b                   	pop    %ebx
  8005cc:	5f                   	pop    %edi
  8005cd:	5d                   	pop    %ebp
  8005ce:	c3                   	ret    

008005cf <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8005cf:	55                   	push   %ebp
  8005d0:	89 e5                	mov    %esp,%ebp
  8005d2:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8005d5:	e8 af 12 00 00       	call   801889 <sys_getenvindex>
  8005da:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8005dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8005e0:	89 d0                	mov    %edx,%eax
  8005e2:	c1 e0 03             	shl    $0x3,%eax
  8005e5:	01 d0                	add    %edx,%eax
  8005e7:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8005ee:	01 c8                	add    %ecx,%eax
  8005f0:	01 c0                	add    %eax,%eax
  8005f2:	01 d0                	add    %edx,%eax
  8005f4:	01 c0                	add    %eax,%eax
  8005f6:	01 d0                	add    %edx,%eax
  8005f8:	89 c2                	mov    %eax,%edx
  8005fa:	c1 e2 05             	shl    $0x5,%edx
  8005fd:	29 c2                	sub    %eax,%edx
  8005ff:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  800606:	89 c2                	mov    %eax,%edx
  800608:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  80060e:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800613:	a1 20 30 80 00       	mov    0x803020,%eax
  800618:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  80061e:	84 c0                	test   %al,%al
  800620:	74 0f                	je     800631 <libmain+0x62>
		binaryname = myEnv->prog_name;
  800622:	a1 20 30 80 00       	mov    0x803020,%eax
  800627:	05 40 3c 01 00       	add    $0x13c40,%eax
  80062c:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800631:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800635:	7e 0a                	jle    800641 <libmain+0x72>
		binaryname = argv[0];
  800637:	8b 45 0c             	mov    0xc(%ebp),%eax
  80063a:	8b 00                	mov    (%eax),%eax
  80063c:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800641:	83 ec 08             	sub    $0x8,%esp
  800644:	ff 75 0c             	pushl  0xc(%ebp)
  800647:	ff 75 08             	pushl  0x8(%ebp)
  80064a:	e8 e9 f9 ff ff       	call   800038 <_main>
  80064f:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800652:	e8 cd 13 00 00       	call   801a24 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800657:	83 ec 0c             	sub    $0xc,%esp
  80065a:	68 24 22 80 00       	push   $0x802224
  80065f:	e8 52 03 00 00       	call   8009b6 <cprintf>
  800664:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800667:	a1 20 30 80 00       	mov    0x803020,%eax
  80066c:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  800672:	a1 20 30 80 00       	mov    0x803020,%eax
  800677:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  80067d:	83 ec 04             	sub    $0x4,%esp
  800680:	52                   	push   %edx
  800681:	50                   	push   %eax
  800682:	68 4c 22 80 00       	push   $0x80224c
  800687:	e8 2a 03 00 00       	call   8009b6 <cprintf>
  80068c:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  80068f:	a1 20 30 80 00       	mov    0x803020,%eax
  800694:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  80069a:	a1 20 30 80 00       	mov    0x803020,%eax
  80069f:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  8006a5:	83 ec 04             	sub    $0x4,%esp
  8006a8:	52                   	push   %edx
  8006a9:	50                   	push   %eax
  8006aa:	68 74 22 80 00       	push   $0x802274
  8006af:	e8 02 03 00 00       	call   8009b6 <cprintf>
  8006b4:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8006b7:	a1 20 30 80 00       	mov    0x803020,%eax
  8006bc:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  8006c2:	83 ec 08             	sub    $0x8,%esp
  8006c5:	50                   	push   %eax
  8006c6:	68 b5 22 80 00       	push   $0x8022b5
  8006cb:	e8 e6 02 00 00       	call   8009b6 <cprintf>
  8006d0:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8006d3:	83 ec 0c             	sub    $0xc,%esp
  8006d6:	68 24 22 80 00       	push   $0x802224
  8006db:	e8 d6 02 00 00       	call   8009b6 <cprintf>
  8006e0:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8006e3:	e8 56 13 00 00       	call   801a3e <sys_enable_interrupt>

	// exit gracefully
	exit();
  8006e8:	e8 19 00 00 00       	call   800706 <exit>
}
  8006ed:	90                   	nop
  8006ee:	c9                   	leave  
  8006ef:	c3                   	ret    

008006f0 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8006f0:	55                   	push   %ebp
  8006f1:	89 e5                	mov    %esp,%ebp
  8006f3:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  8006f6:	83 ec 0c             	sub    $0xc,%esp
  8006f9:	6a 00                	push   $0x0
  8006fb:	e8 55 11 00 00       	call   801855 <sys_env_destroy>
  800700:	83 c4 10             	add    $0x10,%esp
}
  800703:	90                   	nop
  800704:	c9                   	leave  
  800705:	c3                   	ret    

00800706 <exit>:

void
exit(void)
{
  800706:	55                   	push   %ebp
  800707:	89 e5                	mov    %esp,%ebp
  800709:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  80070c:	e8 aa 11 00 00       	call   8018bb <sys_env_exit>
}
  800711:	90                   	nop
  800712:	c9                   	leave  
  800713:	c3                   	ret    

00800714 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800714:	55                   	push   %ebp
  800715:	89 e5                	mov    %esp,%ebp
  800717:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80071a:	8d 45 10             	lea    0x10(%ebp),%eax
  80071d:	83 c0 04             	add    $0x4,%eax
  800720:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800723:	a1 18 31 80 00       	mov    0x803118,%eax
  800728:	85 c0                	test   %eax,%eax
  80072a:	74 16                	je     800742 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80072c:	a1 18 31 80 00       	mov    0x803118,%eax
  800731:	83 ec 08             	sub    $0x8,%esp
  800734:	50                   	push   %eax
  800735:	68 cc 22 80 00       	push   $0x8022cc
  80073a:	e8 77 02 00 00       	call   8009b6 <cprintf>
  80073f:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800742:	a1 00 30 80 00       	mov    0x803000,%eax
  800747:	ff 75 0c             	pushl  0xc(%ebp)
  80074a:	ff 75 08             	pushl  0x8(%ebp)
  80074d:	50                   	push   %eax
  80074e:	68 d1 22 80 00       	push   $0x8022d1
  800753:	e8 5e 02 00 00       	call   8009b6 <cprintf>
  800758:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80075b:	8b 45 10             	mov    0x10(%ebp),%eax
  80075e:	83 ec 08             	sub    $0x8,%esp
  800761:	ff 75 f4             	pushl  -0xc(%ebp)
  800764:	50                   	push   %eax
  800765:	e8 e1 01 00 00       	call   80094b <vcprintf>
  80076a:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80076d:	83 ec 08             	sub    $0x8,%esp
  800770:	6a 00                	push   $0x0
  800772:	68 ed 22 80 00       	push   $0x8022ed
  800777:	e8 cf 01 00 00       	call   80094b <vcprintf>
  80077c:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80077f:	e8 82 ff ff ff       	call   800706 <exit>

	// should not return here
	while (1) ;
  800784:	eb fe                	jmp    800784 <_panic+0x70>

00800786 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800786:	55                   	push   %ebp
  800787:	89 e5                	mov    %esp,%ebp
  800789:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80078c:	a1 20 30 80 00       	mov    0x803020,%eax
  800791:	8b 50 74             	mov    0x74(%eax),%edx
  800794:	8b 45 0c             	mov    0xc(%ebp),%eax
  800797:	39 c2                	cmp    %eax,%edx
  800799:	74 14                	je     8007af <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80079b:	83 ec 04             	sub    $0x4,%esp
  80079e:	68 f0 22 80 00       	push   $0x8022f0
  8007a3:	6a 26                	push   $0x26
  8007a5:	68 3c 23 80 00       	push   $0x80233c
  8007aa:	e8 65 ff ff ff       	call   800714 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8007af:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8007b6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8007bd:	e9 b6 00 00 00       	jmp    800878 <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  8007c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007c5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cf:	01 d0                	add    %edx,%eax
  8007d1:	8b 00                	mov    (%eax),%eax
  8007d3:	85 c0                	test   %eax,%eax
  8007d5:	75 08                	jne    8007df <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8007d7:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8007da:	e9 96 00 00 00       	jmp    800875 <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  8007df:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8007e6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8007ed:	eb 5d                	jmp    80084c <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8007ef:	a1 20 30 80 00       	mov    0x803020,%eax
  8007f4:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8007fa:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8007fd:	c1 e2 04             	shl    $0x4,%edx
  800800:	01 d0                	add    %edx,%eax
  800802:	8a 40 04             	mov    0x4(%eax),%al
  800805:	84 c0                	test   %al,%al
  800807:	75 40                	jne    800849 <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800809:	a1 20 30 80 00       	mov    0x803020,%eax
  80080e:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800814:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800817:	c1 e2 04             	shl    $0x4,%edx
  80081a:	01 d0                	add    %edx,%eax
  80081c:	8b 00                	mov    (%eax),%eax
  80081e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800821:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800824:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800829:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80082b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80082e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800835:	8b 45 08             	mov    0x8(%ebp),%eax
  800838:	01 c8                	add    %ecx,%eax
  80083a:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80083c:	39 c2                	cmp    %eax,%edx
  80083e:	75 09                	jne    800849 <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  800840:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800847:	eb 12                	jmp    80085b <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800849:	ff 45 e8             	incl   -0x18(%ebp)
  80084c:	a1 20 30 80 00       	mov    0x803020,%eax
  800851:	8b 50 74             	mov    0x74(%eax),%edx
  800854:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800857:	39 c2                	cmp    %eax,%edx
  800859:	77 94                	ja     8007ef <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80085b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80085f:	75 14                	jne    800875 <CheckWSWithoutLastIndex+0xef>
			panic(
  800861:	83 ec 04             	sub    $0x4,%esp
  800864:	68 48 23 80 00       	push   $0x802348
  800869:	6a 3a                	push   $0x3a
  80086b:	68 3c 23 80 00       	push   $0x80233c
  800870:	e8 9f fe ff ff       	call   800714 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800875:	ff 45 f0             	incl   -0x10(%ebp)
  800878:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80087b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80087e:	0f 8c 3e ff ff ff    	jl     8007c2 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800884:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80088b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800892:	eb 20                	jmp    8008b4 <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800894:	a1 20 30 80 00       	mov    0x803020,%eax
  800899:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80089f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008a2:	c1 e2 04             	shl    $0x4,%edx
  8008a5:	01 d0                	add    %edx,%eax
  8008a7:	8a 40 04             	mov    0x4(%eax),%al
  8008aa:	3c 01                	cmp    $0x1,%al
  8008ac:	75 03                	jne    8008b1 <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  8008ae:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008b1:	ff 45 e0             	incl   -0x20(%ebp)
  8008b4:	a1 20 30 80 00       	mov    0x803020,%eax
  8008b9:	8b 50 74             	mov    0x74(%eax),%edx
  8008bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008bf:	39 c2                	cmp    %eax,%edx
  8008c1:	77 d1                	ja     800894 <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8008c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008c6:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8008c9:	74 14                	je     8008df <CheckWSWithoutLastIndex+0x159>
		panic(
  8008cb:	83 ec 04             	sub    $0x4,%esp
  8008ce:	68 9c 23 80 00       	push   $0x80239c
  8008d3:	6a 44                	push   $0x44
  8008d5:	68 3c 23 80 00       	push   $0x80233c
  8008da:	e8 35 fe ff ff       	call   800714 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8008df:	90                   	nop
  8008e0:	c9                   	leave  
  8008e1:	c3                   	ret    

008008e2 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8008e2:	55                   	push   %ebp
  8008e3:	89 e5                	mov    %esp,%ebp
  8008e5:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8008e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008eb:	8b 00                	mov    (%eax),%eax
  8008ed:	8d 48 01             	lea    0x1(%eax),%ecx
  8008f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008f3:	89 0a                	mov    %ecx,(%edx)
  8008f5:	8b 55 08             	mov    0x8(%ebp),%edx
  8008f8:	88 d1                	mov    %dl,%cl
  8008fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008fd:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800901:	8b 45 0c             	mov    0xc(%ebp),%eax
  800904:	8b 00                	mov    (%eax),%eax
  800906:	3d ff 00 00 00       	cmp    $0xff,%eax
  80090b:	75 2c                	jne    800939 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80090d:	a0 24 30 80 00       	mov    0x803024,%al
  800912:	0f b6 c0             	movzbl %al,%eax
  800915:	8b 55 0c             	mov    0xc(%ebp),%edx
  800918:	8b 12                	mov    (%edx),%edx
  80091a:	89 d1                	mov    %edx,%ecx
  80091c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80091f:	83 c2 08             	add    $0x8,%edx
  800922:	83 ec 04             	sub    $0x4,%esp
  800925:	50                   	push   %eax
  800926:	51                   	push   %ecx
  800927:	52                   	push   %edx
  800928:	e8 e6 0e 00 00       	call   801813 <sys_cputs>
  80092d:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800930:	8b 45 0c             	mov    0xc(%ebp),%eax
  800933:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800939:	8b 45 0c             	mov    0xc(%ebp),%eax
  80093c:	8b 40 04             	mov    0x4(%eax),%eax
  80093f:	8d 50 01             	lea    0x1(%eax),%edx
  800942:	8b 45 0c             	mov    0xc(%ebp),%eax
  800945:	89 50 04             	mov    %edx,0x4(%eax)
}
  800948:	90                   	nop
  800949:	c9                   	leave  
  80094a:	c3                   	ret    

0080094b <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80094b:	55                   	push   %ebp
  80094c:	89 e5                	mov    %esp,%ebp
  80094e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800954:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80095b:	00 00 00 
	b.cnt = 0;
  80095e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800965:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800968:	ff 75 0c             	pushl  0xc(%ebp)
  80096b:	ff 75 08             	pushl  0x8(%ebp)
  80096e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800974:	50                   	push   %eax
  800975:	68 e2 08 80 00       	push   $0x8008e2
  80097a:	e8 11 02 00 00       	call   800b90 <vprintfmt>
  80097f:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800982:	a0 24 30 80 00       	mov    0x803024,%al
  800987:	0f b6 c0             	movzbl %al,%eax
  80098a:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800990:	83 ec 04             	sub    $0x4,%esp
  800993:	50                   	push   %eax
  800994:	52                   	push   %edx
  800995:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80099b:	83 c0 08             	add    $0x8,%eax
  80099e:	50                   	push   %eax
  80099f:	e8 6f 0e 00 00       	call   801813 <sys_cputs>
  8009a4:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8009a7:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  8009ae:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8009b4:	c9                   	leave  
  8009b5:	c3                   	ret    

008009b6 <cprintf>:

int cprintf(const char *fmt, ...) {
  8009b6:	55                   	push   %ebp
  8009b7:	89 e5                	mov    %esp,%ebp
  8009b9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8009bc:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  8009c3:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8009c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cc:	83 ec 08             	sub    $0x8,%esp
  8009cf:	ff 75 f4             	pushl  -0xc(%ebp)
  8009d2:	50                   	push   %eax
  8009d3:	e8 73 ff ff ff       	call   80094b <vcprintf>
  8009d8:	83 c4 10             	add    $0x10,%esp
  8009db:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8009de:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009e1:	c9                   	leave  
  8009e2:	c3                   	ret    

008009e3 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8009e3:	55                   	push   %ebp
  8009e4:	89 e5                	mov    %esp,%ebp
  8009e6:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8009e9:	e8 36 10 00 00       	call   801a24 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8009ee:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8009f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f7:	83 ec 08             	sub    $0x8,%esp
  8009fa:	ff 75 f4             	pushl  -0xc(%ebp)
  8009fd:	50                   	push   %eax
  8009fe:	e8 48 ff ff ff       	call   80094b <vcprintf>
  800a03:	83 c4 10             	add    $0x10,%esp
  800a06:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800a09:	e8 30 10 00 00       	call   801a3e <sys_enable_interrupt>
	return cnt;
  800a0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a11:	c9                   	leave  
  800a12:	c3                   	ret    

00800a13 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a13:	55                   	push   %ebp
  800a14:	89 e5                	mov    %esp,%ebp
  800a16:	53                   	push   %ebx
  800a17:	83 ec 14             	sub    $0x14,%esp
  800a1a:	8b 45 10             	mov    0x10(%ebp),%eax
  800a1d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a20:	8b 45 14             	mov    0x14(%ebp),%eax
  800a23:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800a26:	8b 45 18             	mov    0x18(%ebp),%eax
  800a29:	ba 00 00 00 00       	mov    $0x0,%edx
  800a2e:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a31:	77 55                	ja     800a88 <printnum+0x75>
  800a33:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a36:	72 05                	jb     800a3d <printnum+0x2a>
  800a38:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800a3b:	77 4b                	ja     800a88 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a3d:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800a40:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800a43:	8b 45 18             	mov    0x18(%ebp),%eax
  800a46:	ba 00 00 00 00       	mov    $0x0,%edx
  800a4b:	52                   	push   %edx
  800a4c:	50                   	push   %eax
  800a4d:	ff 75 f4             	pushl  -0xc(%ebp)
  800a50:	ff 75 f0             	pushl  -0x10(%ebp)
  800a53:	e8 ec 13 00 00       	call   801e44 <__udivdi3>
  800a58:	83 c4 10             	add    $0x10,%esp
  800a5b:	83 ec 04             	sub    $0x4,%esp
  800a5e:	ff 75 20             	pushl  0x20(%ebp)
  800a61:	53                   	push   %ebx
  800a62:	ff 75 18             	pushl  0x18(%ebp)
  800a65:	52                   	push   %edx
  800a66:	50                   	push   %eax
  800a67:	ff 75 0c             	pushl  0xc(%ebp)
  800a6a:	ff 75 08             	pushl  0x8(%ebp)
  800a6d:	e8 a1 ff ff ff       	call   800a13 <printnum>
  800a72:	83 c4 20             	add    $0x20,%esp
  800a75:	eb 1a                	jmp    800a91 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800a77:	83 ec 08             	sub    $0x8,%esp
  800a7a:	ff 75 0c             	pushl  0xc(%ebp)
  800a7d:	ff 75 20             	pushl  0x20(%ebp)
  800a80:	8b 45 08             	mov    0x8(%ebp),%eax
  800a83:	ff d0                	call   *%eax
  800a85:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800a88:	ff 4d 1c             	decl   0x1c(%ebp)
  800a8b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800a8f:	7f e6                	jg     800a77 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800a91:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800a94:	bb 00 00 00 00       	mov    $0x0,%ebx
  800a99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a9c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a9f:	53                   	push   %ebx
  800aa0:	51                   	push   %ecx
  800aa1:	52                   	push   %edx
  800aa2:	50                   	push   %eax
  800aa3:	e8 ac 14 00 00       	call   801f54 <__umoddi3>
  800aa8:	83 c4 10             	add    $0x10,%esp
  800aab:	05 14 26 80 00       	add    $0x802614,%eax
  800ab0:	8a 00                	mov    (%eax),%al
  800ab2:	0f be c0             	movsbl %al,%eax
  800ab5:	83 ec 08             	sub    $0x8,%esp
  800ab8:	ff 75 0c             	pushl  0xc(%ebp)
  800abb:	50                   	push   %eax
  800abc:	8b 45 08             	mov    0x8(%ebp),%eax
  800abf:	ff d0                	call   *%eax
  800ac1:	83 c4 10             	add    $0x10,%esp
}
  800ac4:	90                   	nop
  800ac5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ac8:	c9                   	leave  
  800ac9:	c3                   	ret    

00800aca <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800aca:	55                   	push   %ebp
  800acb:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800acd:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800ad1:	7e 1c                	jle    800aef <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800ad3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad6:	8b 00                	mov    (%eax),%eax
  800ad8:	8d 50 08             	lea    0x8(%eax),%edx
  800adb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ade:	89 10                	mov    %edx,(%eax)
  800ae0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae3:	8b 00                	mov    (%eax),%eax
  800ae5:	83 e8 08             	sub    $0x8,%eax
  800ae8:	8b 50 04             	mov    0x4(%eax),%edx
  800aeb:	8b 00                	mov    (%eax),%eax
  800aed:	eb 40                	jmp    800b2f <getuint+0x65>
	else if (lflag)
  800aef:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800af3:	74 1e                	je     800b13 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800af5:	8b 45 08             	mov    0x8(%ebp),%eax
  800af8:	8b 00                	mov    (%eax),%eax
  800afa:	8d 50 04             	lea    0x4(%eax),%edx
  800afd:	8b 45 08             	mov    0x8(%ebp),%eax
  800b00:	89 10                	mov    %edx,(%eax)
  800b02:	8b 45 08             	mov    0x8(%ebp),%eax
  800b05:	8b 00                	mov    (%eax),%eax
  800b07:	83 e8 04             	sub    $0x4,%eax
  800b0a:	8b 00                	mov    (%eax),%eax
  800b0c:	ba 00 00 00 00       	mov    $0x0,%edx
  800b11:	eb 1c                	jmp    800b2f <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800b13:	8b 45 08             	mov    0x8(%ebp),%eax
  800b16:	8b 00                	mov    (%eax),%eax
  800b18:	8d 50 04             	lea    0x4(%eax),%edx
  800b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1e:	89 10                	mov    %edx,(%eax)
  800b20:	8b 45 08             	mov    0x8(%ebp),%eax
  800b23:	8b 00                	mov    (%eax),%eax
  800b25:	83 e8 04             	sub    $0x4,%eax
  800b28:	8b 00                	mov    (%eax),%eax
  800b2a:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800b2f:	5d                   	pop    %ebp
  800b30:	c3                   	ret    

00800b31 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800b31:	55                   	push   %ebp
  800b32:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b34:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b38:	7e 1c                	jle    800b56 <getint+0x25>
		return va_arg(*ap, long long);
  800b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3d:	8b 00                	mov    (%eax),%eax
  800b3f:	8d 50 08             	lea    0x8(%eax),%edx
  800b42:	8b 45 08             	mov    0x8(%ebp),%eax
  800b45:	89 10                	mov    %edx,(%eax)
  800b47:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4a:	8b 00                	mov    (%eax),%eax
  800b4c:	83 e8 08             	sub    $0x8,%eax
  800b4f:	8b 50 04             	mov    0x4(%eax),%edx
  800b52:	8b 00                	mov    (%eax),%eax
  800b54:	eb 38                	jmp    800b8e <getint+0x5d>
	else if (lflag)
  800b56:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b5a:	74 1a                	je     800b76 <getint+0x45>
		return va_arg(*ap, long);
  800b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5f:	8b 00                	mov    (%eax),%eax
  800b61:	8d 50 04             	lea    0x4(%eax),%edx
  800b64:	8b 45 08             	mov    0x8(%ebp),%eax
  800b67:	89 10                	mov    %edx,(%eax)
  800b69:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6c:	8b 00                	mov    (%eax),%eax
  800b6e:	83 e8 04             	sub    $0x4,%eax
  800b71:	8b 00                	mov    (%eax),%eax
  800b73:	99                   	cltd   
  800b74:	eb 18                	jmp    800b8e <getint+0x5d>
	else
		return va_arg(*ap, int);
  800b76:	8b 45 08             	mov    0x8(%ebp),%eax
  800b79:	8b 00                	mov    (%eax),%eax
  800b7b:	8d 50 04             	lea    0x4(%eax),%edx
  800b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b81:	89 10                	mov    %edx,(%eax)
  800b83:	8b 45 08             	mov    0x8(%ebp),%eax
  800b86:	8b 00                	mov    (%eax),%eax
  800b88:	83 e8 04             	sub    $0x4,%eax
  800b8b:	8b 00                	mov    (%eax),%eax
  800b8d:	99                   	cltd   
}
  800b8e:	5d                   	pop    %ebp
  800b8f:	c3                   	ret    

00800b90 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800b90:	55                   	push   %ebp
  800b91:	89 e5                	mov    %esp,%ebp
  800b93:	56                   	push   %esi
  800b94:	53                   	push   %ebx
  800b95:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b98:	eb 17                	jmp    800bb1 <vprintfmt+0x21>
			if (ch == '\0')
  800b9a:	85 db                	test   %ebx,%ebx
  800b9c:	0f 84 af 03 00 00    	je     800f51 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800ba2:	83 ec 08             	sub    $0x8,%esp
  800ba5:	ff 75 0c             	pushl  0xc(%ebp)
  800ba8:	53                   	push   %ebx
  800ba9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bac:	ff d0                	call   *%eax
  800bae:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bb1:	8b 45 10             	mov    0x10(%ebp),%eax
  800bb4:	8d 50 01             	lea    0x1(%eax),%edx
  800bb7:	89 55 10             	mov    %edx,0x10(%ebp)
  800bba:	8a 00                	mov    (%eax),%al
  800bbc:	0f b6 d8             	movzbl %al,%ebx
  800bbf:	83 fb 25             	cmp    $0x25,%ebx
  800bc2:	75 d6                	jne    800b9a <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800bc4:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800bc8:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800bcf:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800bd6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800bdd:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800be4:	8b 45 10             	mov    0x10(%ebp),%eax
  800be7:	8d 50 01             	lea    0x1(%eax),%edx
  800bea:	89 55 10             	mov    %edx,0x10(%ebp)
  800bed:	8a 00                	mov    (%eax),%al
  800bef:	0f b6 d8             	movzbl %al,%ebx
  800bf2:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800bf5:	83 f8 55             	cmp    $0x55,%eax
  800bf8:	0f 87 2b 03 00 00    	ja     800f29 <vprintfmt+0x399>
  800bfe:	8b 04 85 38 26 80 00 	mov    0x802638(,%eax,4),%eax
  800c05:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800c07:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800c0b:	eb d7                	jmp    800be4 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c0d:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800c11:	eb d1                	jmp    800be4 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c13:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800c1a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c1d:	89 d0                	mov    %edx,%eax
  800c1f:	c1 e0 02             	shl    $0x2,%eax
  800c22:	01 d0                	add    %edx,%eax
  800c24:	01 c0                	add    %eax,%eax
  800c26:	01 d8                	add    %ebx,%eax
  800c28:	83 e8 30             	sub    $0x30,%eax
  800c2b:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800c2e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c31:	8a 00                	mov    (%eax),%al
  800c33:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c36:	83 fb 2f             	cmp    $0x2f,%ebx
  800c39:	7e 3e                	jle    800c79 <vprintfmt+0xe9>
  800c3b:	83 fb 39             	cmp    $0x39,%ebx
  800c3e:	7f 39                	jg     800c79 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c40:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c43:	eb d5                	jmp    800c1a <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800c45:	8b 45 14             	mov    0x14(%ebp),%eax
  800c48:	83 c0 04             	add    $0x4,%eax
  800c4b:	89 45 14             	mov    %eax,0x14(%ebp)
  800c4e:	8b 45 14             	mov    0x14(%ebp),%eax
  800c51:	83 e8 04             	sub    $0x4,%eax
  800c54:	8b 00                	mov    (%eax),%eax
  800c56:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800c59:	eb 1f                	jmp    800c7a <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800c5b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c5f:	79 83                	jns    800be4 <vprintfmt+0x54>
				width = 0;
  800c61:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800c68:	e9 77 ff ff ff       	jmp    800be4 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800c6d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800c74:	e9 6b ff ff ff       	jmp    800be4 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800c79:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c7a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c7e:	0f 89 60 ff ff ff    	jns    800be4 <vprintfmt+0x54>
				width = precision, precision = -1;
  800c84:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c87:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c8a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800c91:	e9 4e ff ff ff       	jmp    800be4 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c96:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800c99:	e9 46 ff ff ff       	jmp    800be4 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800c9e:	8b 45 14             	mov    0x14(%ebp),%eax
  800ca1:	83 c0 04             	add    $0x4,%eax
  800ca4:	89 45 14             	mov    %eax,0x14(%ebp)
  800ca7:	8b 45 14             	mov    0x14(%ebp),%eax
  800caa:	83 e8 04             	sub    $0x4,%eax
  800cad:	8b 00                	mov    (%eax),%eax
  800caf:	83 ec 08             	sub    $0x8,%esp
  800cb2:	ff 75 0c             	pushl  0xc(%ebp)
  800cb5:	50                   	push   %eax
  800cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb9:	ff d0                	call   *%eax
  800cbb:	83 c4 10             	add    $0x10,%esp
			break;
  800cbe:	e9 89 02 00 00       	jmp    800f4c <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800cc3:	8b 45 14             	mov    0x14(%ebp),%eax
  800cc6:	83 c0 04             	add    $0x4,%eax
  800cc9:	89 45 14             	mov    %eax,0x14(%ebp)
  800ccc:	8b 45 14             	mov    0x14(%ebp),%eax
  800ccf:	83 e8 04             	sub    $0x4,%eax
  800cd2:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800cd4:	85 db                	test   %ebx,%ebx
  800cd6:	79 02                	jns    800cda <vprintfmt+0x14a>
				err = -err;
  800cd8:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800cda:	83 fb 64             	cmp    $0x64,%ebx
  800cdd:	7f 0b                	jg     800cea <vprintfmt+0x15a>
  800cdf:	8b 34 9d 80 24 80 00 	mov    0x802480(,%ebx,4),%esi
  800ce6:	85 f6                	test   %esi,%esi
  800ce8:	75 19                	jne    800d03 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800cea:	53                   	push   %ebx
  800ceb:	68 25 26 80 00       	push   $0x802625
  800cf0:	ff 75 0c             	pushl  0xc(%ebp)
  800cf3:	ff 75 08             	pushl  0x8(%ebp)
  800cf6:	e8 5e 02 00 00       	call   800f59 <printfmt>
  800cfb:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800cfe:	e9 49 02 00 00       	jmp    800f4c <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d03:	56                   	push   %esi
  800d04:	68 2e 26 80 00       	push   $0x80262e
  800d09:	ff 75 0c             	pushl  0xc(%ebp)
  800d0c:	ff 75 08             	pushl  0x8(%ebp)
  800d0f:	e8 45 02 00 00       	call   800f59 <printfmt>
  800d14:	83 c4 10             	add    $0x10,%esp
			break;
  800d17:	e9 30 02 00 00       	jmp    800f4c <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800d1c:	8b 45 14             	mov    0x14(%ebp),%eax
  800d1f:	83 c0 04             	add    $0x4,%eax
  800d22:	89 45 14             	mov    %eax,0x14(%ebp)
  800d25:	8b 45 14             	mov    0x14(%ebp),%eax
  800d28:	83 e8 04             	sub    $0x4,%eax
  800d2b:	8b 30                	mov    (%eax),%esi
  800d2d:	85 f6                	test   %esi,%esi
  800d2f:	75 05                	jne    800d36 <vprintfmt+0x1a6>
				p = "(null)";
  800d31:	be 31 26 80 00       	mov    $0x802631,%esi
			if (width > 0 && padc != '-')
  800d36:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d3a:	7e 6d                	jle    800da9 <vprintfmt+0x219>
  800d3c:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800d40:	74 67                	je     800da9 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d42:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d45:	83 ec 08             	sub    $0x8,%esp
  800d48:	50                   	push   %eax
  800d49:	56                   	push   %esi
  800d4a:	e8 0c 03 00 00       	call   80105b <strnlen>
  800d4f:	83 c4 10             	add    $0x10,%esp
  800d52:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800d55:	eb 16                	jmp    800d6d <vprintfmt+0x1dd>
					putch(padc, putdat);
  800d57:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800d5b:	83 ec 08             	sub    $0x8,%esp
  800d5e:	ff 75 0c             	pushl  0xc(%ebp)
  800d61:	50                   	push   %eax
  800d62:	8b 45 08             	mov    0x8(%ebp),%eax
  800d65:	ff d0                	call   *%eax
  800d67:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d6a:	ff 4d e4             	decl   -0x1c(%ebp)
  800d6d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d71:	7f e4                	jg     800d57 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d73:	eb 34                	jmp    800da9 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800d75:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800d79:	74 1c                	je     800d97 <vprintfmt+0x207>
  800d7b:	83 fb 1f             	cmp    $0x1f,%ebx
  800d7e:	7e 05                	jle    800d85 <vprintfmt+0x1f5>
  800d80:	83 fb 7e             	cmp    $0x7e,%ebx
  800d83:	7e 12                	jle    800d97 <vprintfmt+0x207>
					putch('?', putdat);
  800d85:	83 ec 08             	sub    $0x8,%esp
  800d88:	ff 75 0c             	pushl  0xc(%ebp)
  800d8b:	6a 3f                	push   $0x3f
  800d8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d90:	ff d0                	call   *%eax
  800d92:	83 c4 10             	add    $0x10,%esp
  800d95:	eb 0f                	jmp    800da6 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800d97:	83 ec 08             	sub    $0x8,%esp
  800d9a:	ff 75 0c             	pushl  0xc(%ebp)
  800d9d:	53                   	push   %ebx
  800d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800da1:	ff d0                	call   *%eax
  800da3:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800da6:	ff 4d e4             	decl   -0x1c(%ebp)
  800da9:	89 f0                	mov    %esi,%eax
  800dab:	8d 70 01             	lea    0x1(%eax),%esi
  800dae:	8a 00                	mov    (%eax),%al
  800db0:	0f be d8             	movsbl %al,%ebx
  800db3:	85 db                	test   %ebx,%ebx
  800db5:	74 24                	je     800ddb <vprintfmt+0x24b>
  800db7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800dbb:	78 b8                	js     800d75 <vprintfmt+0x1e5>
  800dbd:	ff 4d e0             	decl   -0x20(%ebp)
  800dc0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800dc4:	79 af                	jns    800d75 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800dc6:	eb 13                	jmp    800ddb <vprintfmt+0x24b>
				putch(' ', putdat);
  800dc8:	83 ec 08             	sub    $0x8,%esp
  800dcb:	ff 75 0c             	pushl  0xc(%ebp)
  800dce:	6a 20                	push   $0x20
  800dd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd3:	ff d0                	call   *%eax
  800dd5:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800dd8:	ff 4d e4             	decl   -0x1c(%ebp)
  800ddb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ddf:	7f e7                	jg     800dc8 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800de1:	e9 66 01 00 00       	jmp    800f4c <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800de6:	83 ec 08             	sub    $0x8,%esp
  800de9:	ff 75 e8             	pushl  -0x18(%ebp)
  800dec:	8d 45 14             	lea    0x14(%ebp),%eax
  800def:	50                   	push   %eax
  800df0:	e8 3c fd ff ff       	call   800b31 <getint>
  800df5:	83 c4 10             	add    $0x10,%esp
  800df8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dfb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800dfe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e01:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e04:	85 d2                	test   %edx,%edx
  800e06:	79 23                	jns    800e2b <vprintfmt+0x29b>
				putch('-', putdat);
  800e08:	83 ec 08             	sub    $0x8,%esp
  800e0b:	ff 75 0c             	pushl  0xc(%ebp)
  800e0e:	6a 2d                	push   $0x2d
  800e10:	8b 45 08             	mov    0x8(%ebp),%eax
  800e13:	ff d0                	call   *%eax
  800e15:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800e18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e1b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e1e:	f7 d8                	neg    %eax
  800e20:	83 d2 00             	adc    $0x0,%edx
  800e23:	f7 da                	neg    %edx
  800e25:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e28:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800e2b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e32:	e9 bc 00 00 00       	jmp    800ef3 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800e37:	83 ec 08             	sub    $0x8,%esp
  800e3a:	ff 75 e8             	pushl  -0x18(%ebp)
  800e3d:	8d 45 14             	lea    0x14(%ebp),%eax
  800e40:	50                   	push   %eax
  800e41:	e8 84 fc ff ff       	call   800aca <getuint>
  800e46:	83 c4 10             	add    $0x10,%esp
  800e49:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e4c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800e4f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e56:	e9 98 00 00 00       	jmp    800ef3 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800e5b:	83 ec 08             	sub    $0x8,%esp
  800e5e:	ff 75 0c             	pushl  0xc(%ebp)
  800e61:	6a 58                	push   $0x58
  800e63:	8b 45 08             	mov    0x8(%ebp),%eax
  800e66:	ff d0                	call   *%eax
  800e68:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e6b:	83 ec 08             	sub    $0x8,%esp
  800e6e:	ff 75 0c             	pushl  0xc(%ebp)
  800e71:	6a 58                	push   $0x58
  800e73:	8b 45 08             	mov    0x8(%ebp),%eax
  800e76:	ff d0                	call   *%eax
  800e78:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e7b:	83 ec 08             	sub    $0x8,%esp
  800e7e:	ff 75 0c             	pushl  0xc(%ebp)
  800e81:	6a 58                	push   $0x58
  800e83:	8b 45 08             	mov    0x8(%ebp),%eax
  800e86:	ff d0                	call   *%eax
  800e88:	83 c4 10             	add    $0x10,%esp
			break;
  800e8b:	e9 bc 00 00 00       	jmp    800f4c <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800e90:	83 ec 08             	sub    $0x8,%esp
  800e93:	ff 75 0c             	pushl  0xc(%ebp)
  800e96:	6a 30                	push   $0x30
  800e98:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9b:	ff d0                	call   *%eax
  800e9d:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ea0:	83 ec 08             	sub    $0x8,%esp
  800ea3:	ff 75 0c             	pushl  0xc(%ebp)
  800ea6:	6a 78                	push   $0x78
  800ea8:	8b 45 08             	mov    0x8(%ebp),%eax
  800eab:	ff d0                	call   *%eax
  800ead:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800eb0:	8b 45 14             	mov    0x14(%ebp),%eax
  800eb3:	83 c0 04             	add    $0x4,%eax
  800eb6:	89 45 14             	mov    %eax,0x14(%ebp)
  800eb9:	8b 45 14             	mov    0x14(%ebp),%eax
  800ebc:	83 e8 04             	sub    $0x4,%eax
  800ebf:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ec1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ec4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800ecb:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ed2:	eb 1f                	jmp    800ef3 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ed4:	83 ec 08             	sub    $0x8,%esp
  800ed7:	ff 75 e8             	pushl  -0x18(%ebp)
  800eda:	8d 45 14             	lea    0x14(%ebp),%eax
  800edd:	50                   	push   %eax
  800ede:	e8 e7 fb ff ff       	call   800aca <getuint>
  800ee3:	83 c4 10             	add    $0x10,%esp
  800ee6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ee9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800eec:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ef3:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ef7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800efa:	83 ec 04             	sub    $0x4,%esp
  800efd:	52                   	push   %edx
  800efe:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f01:	50                   	push   %eax
  800f02:	ff 75 f4             	pushl  -0xc(%ebp)
  800f05:	ff 75 f0             	pushl  -0x10(%ebp)
  800f08:	ff 75 0c             	pushl  0xc(%ebp)
  800f0b:	ff 75 08             	pushl  0x8(%ebp)
  800f0e:	e8 00 fb ff ff       	call   800a13 <printnum>
  800f13:	83 c4 20             	add    $0x20,%esp
			break;
  800f16:	eb 34                	jmp    800f4c <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f18:	83 ec 08             	sub    $0x8,%esp
  800f1b:	ff 75 0c             	pushl  0xc(%ebp)
  800f1e:	53                   	push   %ebx
  800f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f22:	ff d0                	call   *%eax
  800f24:	83 c4 10             	add    $0x10,%esp
			break;
  800f27:	eb 23                	jmp    800f4c <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f29:	83 ec 08             	sub    $0x8,%esp
  800f2c:	ff 75 0c             	pushl  0xc(%ebp)
  800f2f:	6a 25                	push   $0x25
  800f31:	8b 45 08             	mov    0x8(%ebp),%eax
  800f34:	ff d0                	call   *%eax
  800f36:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f39:	ff 4d 10             	decl   0x10(%ebp)
  800f3c:	eb 03                	jmp    800f41 <vprintfmt+0x3b1>
  800f3e:	ff 4d 10             	decl   0x10(%ebp)
  800f41:	8b 45 10             	mov    0x10(%ebp),%eax
  800f44:	48                   	dec    %eax
  800f45:	8a 00                	mov    (%eax),%al
  800f47:	3c 25                	cmp    $0x25,%al
  800f49:	75 f3                	jne    800f3e <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800f4b:	90                   	nop
		}
	}
  800f4c:	e9 47 fc ff ff       	jmp    800b98 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800f51:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800f52:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f55:	5b                   	pop    %ebx
  800f56:	5e                   	pop    %esi
  800f57:	5d                   	pop    %ebp
  800f58:	c3                   	ret    

00800f59 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f59:	55                   	push   %ebp
  800f5a:	89 e5                	mov    %esp,%ebp
  800f5c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800f5f:	8d 45 10             	lea    0x10(%ebp),%eax
  800f62:	83 c0 04             	add    $0x4,%eax
  800f65:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800f68:	8b 45 10             	mov    0x10(%ebp),%eax
  800f6b:	ff 75 f4             	pushl  -0xc(%ebp)
  800f6e:	50                   	push   %eax
  800f6f:	ff 75 0c             	pushl  0xc(%ebp)
  800f72:	ff 75 08             	pushl  0x8(%ebp)
  800f75:	e8 16 fc ff ff       	call   800b90 <vprintfmt>
  800f7a:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800f7d:	90                   	nop
  800f7e:	c9                   	leave  
  800f7f:	c3                   	ret    

00800f80 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f80:	55                   	push   %ebp
  800f81:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800f83:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f86:	8b 40 08             	mov    0x8(%eax),%eax
  800f89:	8d 50 01             	lea    0x1(%eax),%edx
  800f8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f8f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800f92:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f95:	8b 10                	mov    (%eax),%edx
  800f97:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f9a:	8b 40 04             	mov    0x4(%eax),%eax
  800f9d:	39 c2                	cmp    %eax,%edx
  800f9f:	73 12                	jae    800fb3 <sprintputch+0x33>
		*b->buf++ = ch;
  800fa1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa4:	8b 00                	mov    (%eax),%eax
  800fa6:	8d 48 01             	lea    0x1(%eax),%ecx
  800fa9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fac:	89 0a                	mov    %ecx,(%edx)
  800fae:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb1:	88 10                	mov    %dl,(%eax)
}
  800fb3:	90                   	nop
  800fb4:	5d                   	pop    %ebp
  800fb5:	c3                   	ret    

00800fb6 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800fb6:	55                   	push   %ebp
  800fb7:	89 e5                	mov    %esp,%ebp
  800fb9:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800fbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800fc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc5:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcb:	01 d0                	add    %edx,%eax
  800fcd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fd0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800fd7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800fdb:	74 06                	je     800fe3 <vsnprintf+0x2d>
  800fdd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800fe1:	7f 07                	jg     800fea <vsnprintf+0x34>
		return -E_INVAL;
  800fe3:	b8 03 00 00 00       	mov    $0x3,%eax
  800fe8:	eb 20                	jmp    80100a <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800fea:	ff 75 14             	pushl  0x14(%ebp)
  800fed:	ff 75 10             	pushl  0x10(%ebp)
  800ff0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ff3:	50                   	push   %eax
  800ff4:	68 80 0f 80 00       	push   $0x800f80
  800ff9:	e8 92 fb ff ff       	call   800b90 <vprintfmt>
  800ffe:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801001:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801004:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801007:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80100a:	c9                   	leave  
  80100b:	c3                   	ret    

0080100c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80100c:	55                   	push   %ebp
  80100d:	89 e5                	mov    %esp,%ebp
  80100f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801012:	8d 45 10             	lea    0x10(%ebp),%eax
  801015:	83 c0 04             	add    $0x4,%eax
  801018:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80101b:	8b 45 10             	mov    0x10(%ebp),%eax
  80101e:	ff 75 f4             	pushl  -0xc(%ebp)
  801021:	50                   	push   %eax
  801022:	ff 75 0c             	pushl  0xc(%ebp)
  801025:	ff 75 08             	pushl  0x8(%ebp)
  801028:	e8 89 ff ff ff       	call   800fb6 <vsnprintf>
  80102d:	83 c4 10             	add    $0x10,%esp
  801030:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801033:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801036:	c9                   	leave  
  801037:	c3                   	ret    

00801038 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801038:	55                   	push   %ebp
  801039:	89 e5                	mov    %esp,%ebp
  80103b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80103e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801045:	eb 06                	jmp    80104d <strlen+0x15>
		n++;
  801047:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80104a:	ff 45 08             	incl   0x8(%ebp)
  80104d:	8b 45 08             	mov    0x8(%ebp),%eax
  801050:	8a 00                	mov    (%eax),%al
  801052:	84 c0                	test   %al,%al
  801054:	75 f1                	jne    801047 <strlen+0xf>
		n++;
	return n;
  801056:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801059:	c9                   	leave  
  80105a:	c3                   	ret    

0080105b <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80105b:	55                   	push   %ebp
  80105c:	89 e5                	mov    %esp,%ebp
  80105e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801061:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801068:	eb 09                	jmp    801073 <strnlen+0x18>
		n++;
  80106a:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80106d:	ff 45 08             	incl   0x8(%ebp)
  801070:	ff 4d 0c             	decl   0xc(%ebp)
  801073:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801077:	74 09                	je     801082 <strnlen+0x27>
  801079:	8b 45 08             	mov    0x8(%ebp),%eax
  80107c:	8a 00                	mov    (%eax),%al
  80107e:	84 c0                	test   %al,%al
  801080:	75 e8                	jne    80106a <strnlen+0xf>
		n++;
	return n;
  801082:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801085:	c9                   	leave  
  801086:	c3                   	ret    

00801087 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801087:	55                   	push   %ebp
  801088:	89 e5                	mov    %esp,%ebp
  80108a:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80108d:	8b 45 08             	mov    0x8(%ebp),%eax
  801090:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801093:	90                   	nop
  801094:	8b 45 08             	mov    0x8(%ebp),%eax
  801097:	8d 50 01             	lea    0x1(%eax),%edx
  80109a:	89 55 08             	mov    %edx,0x8(%ebp)
  80109d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010a0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010a3:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010a6:	8a 12                	mov    (%edx),%dl
  8010a8:	88 10                	mov    %dl,(%eax)
  8010aa:	8a 00                	mov    (%eax),%al
  8010ac:	84 c0                	test   %al,%al
  8010ae:	75 e4                	jne    801094 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8010b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010b3:	c9                   	leave  
  8010b4:	c3                   	ret    

008010b5 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8010b5:	55                   	push   %ebp
  8010b6:	89 e5                	mov    %esp,%ebp
  8010b8:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8010bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010be:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8010c1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010c8:	eb 1f                	jmp    8010e9 <strncpy+0x34>
		*dst++ = *src;
  8010ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cd:	8d 50 01             	lea    0x1(%eax),%edx
  8010d0:	89 55 08             	mov    %edx,0x8(%ebp)
  8010d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010d6:	8a 12                	mov    (%edx),%dl
  8010d8:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8010da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010dd:	8a 00                	mov    (%eax),%al
  8010df:	84 c0                	test   %al,%al
  8010e1:	74 03                	je     8010e6 <strncpy+0x31>
			src++;
  8010e3:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8010e6:	ff 45 fc             	incl   -0x4(%ebp)
  8010e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ec:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010ef:	72 d9                	jb     8010ca <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8010f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010f4:	c9                   	leave  
  8010f5:	c3                   	ret    

008010f6 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8010f6:	55                   	push   %ebp
  8010f7:	89 e5                	mov    %esp,%ebp
  8010f9:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8010fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ff:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801102:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801106:	74 30                	je     801138 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801108:	eb 16                	jmp    801120 <strlcpy+0x2a>
			*dst++ = *src++;
  80110a:	8b 45 08             	mov    0x8(%ebp),%eax
  80110d:	8d 50 01             	lea    0x1(%eax),%edx
  801110:	89 55 08             	mov    %edx,0x8(%ebp)
  801113:	8b 55 0c             	mov    0xc(%ebp),%edx
  801116:	8d 4a 01             	lea    0x1(%edx),%ecx
  801119:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80111c:	8a 12                	mov    (%edx),%dl
  80111e:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801120:	ff 4d 10             	decl   0x10(%ebp)
  801123:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801127:	74 09                	je     801132 <strlcpy+0x3c>
  801129:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112c:	8a 00                	mov    (%eax),%al
  80112e:	84 c0                	test   %al,%al
  801130:	75 d8                	jne    80110a <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801132:	8b 45 08             	mov    0x8(%ebp),%eax
  801135:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801138:	8b 55 08             	mov    0x8(%ebp),%edx
  80113b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80113e:	29 c2                	sub    %eax,%edx
  801140:	89 d0                	mov    %edx,%eax
}
  801142:	c9                   	leave  
  801143:	c3                   	ret    

00801144 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801144:	55                   	push   %ebp
  801145:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801147:	eb 06                	jmp    80114f <strcmp+0xb>
		p++, q++;
  801149:	ff 45 08             	incl   0x8(%ebp)
  80114c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80114f:	8b 45 08             	mov    0x8(%ebp),%eax
  801152:	8a 00                	mov    (%eax),%al
  801154:	84 c0                	test   %al,%al
  801156:	74 0e                	je     801166 <strcmp+0x22>
  801158:	8b 45 08             	mov    0x8(%ebp),%eax
  80115b:	8a 10                	mov    (%eax),%dl
  80115d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801160:	8a 00                	mov    (%eax),%al
  801162:	38 c2                	cmp    %al,%dl
  801164:	74 e3                	je     801149 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801166:	8b 45 08             	mov    0x8(%ebp),%eax
  801169:	8a 00                	mov    (%eax),%al
  80116b:	0f b6 d0             	movzbl %al,%edx
  80116e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801171:	8a 00                	mov    (%eax),%al
  801173:	0f b6 c0             	movzbl %al,%eax
  801176:	29 c2                	sub    %eax,%edx
  801178:	89 d0                	mov    %edx,%eax
}
  80117a:	5d                   	pop    %ebp
  80117b:	c3                   	ret    

0080117c <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80117c:	55                   	push   %ebp
  80117d:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80117f:	eb 09                	jmp    80118a <strncmp+0xe>
		n--, p++, q++;
  801181:	ff 4d 10             	decl   0x10(%ebp)
  801184:	ff 45 08             	incl   0x8(%ebp)
  801187:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80118a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80118e:	74 17                	je     8011a7 <strncmp+0x2b>
  801190:	8b 45 08             	mov    0x8(%ebp),%eax
  801193:	8a 00                	mov    (%eax),%al
  801195:	84 c0                	test   %al,%al
  801197:	74 0e                	je     8011a7 <strncmp+0x2b>
  801199:	8b 45 08             	mov    0x8(%ebp),%eax
  80119c:	8a 10                	mov    (%eax),%dl
  80119e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a1:	8a 00                	mov    (%eax),%al
  8011a3:	38 c2                	cmp    %al,%dl
  8011a5:	74 da                	je     801181 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8011a7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011ab:	75 07                	jne    8011b4 <strncmp+0x38>
		return 0;
  8011ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8011b2:	eb 14                	jmp    8011c8 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8011b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b7:	8a 00                	mov    (%eax),%al
  8011b9:	0f b6 d0             	movzbl %al,%edx
  8011bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011bf:	8a 00                	mov    (%eax),%al
  8011c1:	0f b6 c0             	movzbl %al,%eax
  8011c4:	29 c2                	sub    %eax,%edx
  8011c6:	89 d0                	mov    %edx,%eax
}
  8011c8:	5d                   	pop    %ebp
  8011c9:	c3                   	ret    

008011ca <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8011ca:	55                   	push   %ebp
  8011cb:	89 e5                	mov    %esp,%ebp
  8011cd:	83 ec 04             	sub    $0x4,%esp
  8011d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011d6:	eb 12                	jmp    8011ea <strchr+0x20>
		if (*s == c)
  8011d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011db:	8a 00                	mov    (%eax),%al
  8011dd:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011e0:	75 05                	jne    8011e7 <strchr+0x1d>
			return (char *) s;
  8011e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e5:	eb 11                	jmp    8011f8 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8011e7:	ff 45 08             	incl   0x8(%ebp)
  8011ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ed:	8a 00                	mov    (%eax),%al
  8011ef:	84 c0                	test   %al,%al
  8011f1:	75 e5                	jne    8011d8 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8011f3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011f8:	c9                   	leave  
  8011f9:	c3                   	ret    

008011fa <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8011fa:	55                   	push   %ebp
  8011fb:	89 e5                	mov    %esp,%ebp
  8011fd:	83 ec 04             	sub    $0x4,%esp
  801200:	8b 45 0c             	mov    0xc(%ebp),%eax
  801203:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801206:	eb 0d                	jmp    801215 <strfind+0x1b>
		if (*s == c)
  801208:	8b 45 08             	mov    0x8(%ebp),%eax
  80120b:	8a 00                	mov    (%eax),%al
  80120d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801210:	74 0e                	je     801220 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801212:	ff 45 08             	incl   0x8(%ebp)
  801215:	8b 45 08             	mov    0x8(%ebp),%eax
  801218:	8a 00                	mov    (%eax),%al
  80121a:	84 c0                	test   %al,%al
  80121c:	75 ea                	jne    801208 <strfind+0xe>
  80121e:	eb 01                	jmp    801221 <strfind+0x27>
		if (*s == c)
			break;
  801220:	90                   	nop
	return (char *) s;
  801221:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801224:	c9                   	leave  
  801225:	c3                   	ret    

00801226 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801226:	55                   	push   %ebp
  801227:	89 e5                	mov    %esp,%ebp
  801229:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80122c:	8b 45 08             	mov    0x8(%ebp),%eax
  80122f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801232:	8b 45 10             	mov    0x10(%ebp),%eax
  801235:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801238:	eb 0e                	jmp    801248 <memset+0x22>
		*p++ = c;
  80123a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80123d:	8d 50 01             	lea    0x1(%eax),%edx
  801240:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801243:	8b 55 0c             	mov    0xc(%ebp),%edx
  801246:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801248:	ff 4d f8             	decl   -0x8(%ebp)
  80124b:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80124f:	79 e9                	jns    80123a <memset+0x14>
		*p++ = c;

	return v;
  801251:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801254:	c9                   	leave  
  801255:	c3                   	ret    

00801256 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801256:	55                   	push   %ebp
  801257:	89 e5                	mov    %esp,%ebp
  801259:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80125c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801262:	8b 45 08             	mov    0x8(%ebp),%eax
  801265:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801268:	eb 16                	jmp    801280 <memcpy+0x2a>
		*d++ = *s++;
  80126a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80126d:	8d 50 01             	lea    0x1(%eax),%edx
  801270:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801273:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801276:	8d 4a 01             	lea    0x1(%edx),%ecx
  801279:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80127c:	8a 12                	mov    (%edx),%dl
  80127e:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801280:	8b 45 10             	mov    0x10(%ebp),%eax
  801283:	8d 50 ff             	lea    -0x1(%eax),%edx
  801286:	89 55 10             	mov    %edx,0x10(%ebp)
  801289:	85 c0                	test   %eax,%eax
  80128b:	75 dd                	jne    80126a <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80128d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801290:	c9                   	leave  
  801291:	c3                   	ret    

00801292 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801292:	55                   	push   %ebp
  801293:	89 e5                	mov    %esp,%ebp
  801295:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801298:	8b 45 0c             	mov    0xc(%ebp),%eax
  80129b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80129e:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8012a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012a7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8012aa:	73 50                	jae    8012fc <memmove+0x6a>
  8012ac:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012af:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b2:	01 d0                	add    %edx,%eax
  8012b4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8012b7:	76 43                	jbe    8012fc <memmove+0x6a>
		s += n;
  8012b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8012bc:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8012bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8012c2:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8012c5:	eb 10                	jmp    8012d7 <memmove+0x45>
			*--d = *--s;
  8012c7:	ff 4d f8             	decl   -0x8(%ebp)
  8012ca:	ff 4d fc             	decl   -0x4(%ebp)
  8012cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012d0:	8a 10                	mov    (%eax),%dl
  8012d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012d5:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8012d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8012da:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012dd:	89 55 10             	mov    %edx,0x10(%ebp)
  8012e0:	85 c0                	test   %eax,%eax
  8012e2:	75 e3                	jne    8012c7 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8012e4:	eb 23                	jmp    801309 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8012e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012e9:	8d 50 01             	lea    0x1(%eax),%edx
  8012ec:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012ef:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012f2:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012f5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8012f8:	8a 12                	mov    (%edx),%dl
  8012fa:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8012fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ff:	8d 50 ff             	lea    -0x1(%eax),%edx
  801302:	89 55 10             	mov    %edx,0x10(%ebp)
  801305:	85 c0                	test   %eax,%eax
  801307:	75 dd                	jne    8012e6 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801309:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80130c:	c9                   	leave  
  80130d:	c3                   	ret    

0080130e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80130e:	55                   	push   %ebp
  80130f:	89 e5                	mov    %esp,%ebp
  801311:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801314:	8b 45 08             	mov    0x8(%ebp),%eax
  801317:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80131a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80131d:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801320:	eb 2a                	jmp    80134c <memcmp+0x3e>
		if (*s1 != *s2)
  801322:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801325:	8a 10                	mov    (%eax),%dl
  801327:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80132a:	8a 00                	mov    (%eax),%al
  80132c:	38 c2                	cmp    %al,%dl
  80132e:	74 16                	je     801346 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801330:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801333:	8a 00                	mov    (%eax),%al
  801335:	0f b6 d0             	movzbl %al,%edx
  801338:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80133b:	8a 00                	mov    (%eax),%al
  80133d:	0f b6 c0             	movzbl %al,%eax
  801340:	29 c2                	sub    %eax,%edx
  801342:	89 d0                	mov    %edx,%eax
  801344:	eb 18                	jmp    80135e <memcmp+0x50>
		s1++, s2++;
  801346:	ff 45 fc             	incl   -0x4(%ebp)
  801349:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80134c:	8b 45 10             	mov    0x10(%ebp),%eax
  80134f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801352:	89 55 10             	mov    %edx,0x10(%ebp)
  801355:	85 c0                	test   %eax,%eax
  801357:	75 c9                	jne    801322 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801359:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80135e:	c9                   	leave  
  80135f:	c3                   	ret    

00801360 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801360:	55                   	push   %ebp
  801361:	89 e5                	mov    %esp,%ebp
  801363:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801366:	8b 55 08             	mov    0x8(%ebp),%edx
  801369:	8b 45 10             	mov    0x10(%ebp),%eax
  80136c:	01 d0                	add    %edx,%eax
  80136e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801371:	eb 15                	jmp    801388 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801373:	8b 45 08             	mov    0x8(%ebp),%eax
  801376:	8a 00                	mov    (%eax),%al
  801378:	0f b6 d0             	movzbl %al,%edx
  80137b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80137e:	0f b6 c0             	movzbl %al,%eax
  801381:	39 c2                	cmp    %eax,%edx
  801383:	74 0d                	je     801392 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801385:	ff 45 08             	incl   0x8(%ebp)
  801388:	8b 45 08             	mov    0x8(%ebp),%eax
  80138b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80138e:	72 e3                	jb     801373 <memfind+0x13>
  801390:	eb 01                	jmp    801393 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801392:	90                   	nop
	return (void *) s;
  801393:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801396:	c9                   	leave  
  801397:	c3                   	ret    

00801398 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801398:	55                   	push   %ebp
  801399:	89 e5                	mov    %esp,%ebp
  80139b:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80139e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8013a5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013ac:	eb 03                	jmp    8013b1 <strtol+0x19>
		s++;
  8013ae:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b4:	8a 00                	mov    (%eax),%al
  8013b6:	3c 20                	cmp    $0x20,%al
  8013b8:	74 f4                	je     8013ae <strtol+0x16>
  8013ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bd:	8a 00                	mov    (%eax),%al
  8013bf:	3c 09                	cmp    $0x9,%al
  8013c1:	74 eb                	je     8013ae <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8013c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c6:	8a 00                	mov    (%eax),%al
  8013c8:	3c 2b                	cmp    $0x2b,%al
  8013ca:	75 05                	jne    8013d1 <strtol+0x39>
		s++;
  8013cc:	ff 45 08             	incl   0x8(%ebp)
  8013cf:	eb 13                	jmp    8013e4 <strtol+0x4c>
	else if (*s == '-')
  8013d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d4:	8a 00                	mov    (%eax),%al
  8013d6:	3c 2d                	cmp    $0x2d,%al
  8013d8:	75 0a                	jne    8013e4 <strtol+0x4c>
		s++, neg = 1;
  8013da:	ff 45 08             	incl   0x8(%ebp)
  8013dd:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8013e4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013e8:	74 06                	je     8013f0 <strtol+0x58>
  8013ea:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8013ee:	75 20                	jne    801410 <strtol+0x78>
  8013f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f3:	8a 00                	mov    (%eax),%al
  8013f5:	3c 30                	cmp    $0x30,%al
  8013f7:	75 17                	jne    801410 <strtol+0x78>
  8013f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fc:	40                   	inc    %eax
  8013fd:	8a 00                	mov    (%eax),%al
  8013ff:	3c 78                	cmp    $0x78,%al
  801401:	75 0d                	jne    801410 <strtol+0x78>
		s += 2, base = 16;
  801403:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801407:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80140e:	eb 28                	jmp    801438 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801410:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801414:	75 15                	jne    80142b <strtol+0x93>
  801416:	8b 45 08             	mov    0x8(%ebp),%eax
  801419:	8a 00                	mov    (%eax),%al
  80141b:	3c 30                	cmp    $0x30,%al
  80141d:	75 0c                	jne    80142b <strtol+0x93>
		s++, base = 8;
  80141f:	ff 45 08             	incl   0x8(%ebp)
  801422:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801429:	eb 0d                	jmp    801438 <strtol+0xa0>
	else if (base == 0)
  80142b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80142f:	75 07                	jne    801438 <strtol+0xa0>
		base = 10;
  801431:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801438:	8b 45 08             	mov    0x8(%ebp),%eax
  80143b:	8a 00                	mov    (%eax),%al
  80143d:	3c 2f                	cmp    $0x2f,%al
  80143f:	7e 19                	jle    80145a <strtol+0xc2>
  801441:	8b 45 08             	mov    0x8(%ebp),%eax
  801444:	8a 00                	mov    (%eax),%al
  801446:	3c 39                	cmp    $0x39,%al
  801448:	7f 10                	jg     80145a <strtol+0xc2>
			dig = *s - '0';
  80144a:	8b 45 08             	mov    0x8(%ebp),%eax
  80144d:	8a 00                	mov    (%eax),%al
  80144f:	0f be c0             	movsbl %al,%eax
  801452:	83 e8 30             	sub    $0x30,%eax
  801455:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801458:	eb 42                	jmp    80149c <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80145a:	8b 45 08             	mov    0x8(%ebp),%eax
  80145d:	8a 00                	mov    (%eax),%al
  80145f:	3c 60                	cmp    $0x60,%al
  801461:	7e 19                	jle    80147c <strtol+0xe4>
  801463:	8b 45 08             	mov    0x8(%ebp),%eax
  801466:	8a 00                	mov    (%eax),%al
  801468:	3c 7a                	cmp    $0x7a,%al
  80146a:	7f 10                	jg     80147c <strtol+0xe4>
			dig = *s - 'a' + 10;
  80146c:	8b 45 08             	mov    0x8(%ebp),%eax
  80146f:	8a 00                	mov    (%eax),%al
  801471:	0f be c0             	movsbl %al,%eax
  801474:	83 e8 57             	sub    $0x57,%eax
  801477:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80147a:	eb 20                	jmp    80149c <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80147c:	8b 45 08             	mov    0x8(%ebp),%eax
  80147f:	8a 00                	mov    (%eax),%al
  801481:	3c 40                	cmp    $0x40,%al
  801483:	7e 39                	jle    8014be <strtol+0x126>
  801485:	8b 45 08             	mov    0x8(%ebp),%eax
  801488:	8a 00                	mov    (%eax),%al
  80148a:	3c 5a                	cmp    $0x5a,%al
  80148c:	7f 30                	jg     8014be <strtol+0x126>
			dig = *s - 'A' + 10;
  80148e:	8b 45 08             	mov    0x8(%ebp),%eax
  801491:	8a 00                	mov    (%eax),%al
  801493:	0f be c0             	movsbl %al,%eax
  801496:	83 e8 37             	sub    $0x37,%eax
  801499:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80149c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80149f:	3b 45 10             	cmp    0x10(%ebp),%eax
  8014a2:	7d 19                	jge    8014bd <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8014a4:	ff 45 08             	incl   0x8(%ebp)
  8014a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014aa:	0f af 45 10          	imul   0x10(%ebp),%eax
  8014ae:	89 c2                	mov    %eax,%edx
  8014b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014b3:	01 d0                	add    %edx,%eax
  8014b5:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8014b8:	e9 7b ff ff ff       	jmp    801438 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8014bd:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8014be:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8014c2:	74 08                	je     8014cc <strtol+0x134>
		*endptr = (char *) s;
  8014c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c7:	8b 55 08             	mov    0x8(%ebp),%edx
  8014ca:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8014cc:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8014d0:	74 07                	je     8014d9 <strtol+0x141>
  8014d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014d5:	f7 d8                	neg    %eax
  8014d7:	eb 03                	jmp    8014dc <strtol+0x144>
  8014d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014dc:	c9                   	leave  
  8014dd:	c3                   	ret    

008014de <ltostr>:

void
ltostr(long value, char *str)
{
  8014de:	55                   	push   %ebp
  8014df:	89 e5                	mov    %esp,%ebp
  8014e1:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8014e4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8014eb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8014f2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014f6:	79 13                	jns    80150b <ltostr+0x2d>
	{
		neg = 1;
  8014f8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8014ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801502:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801505:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801508:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80150b:	8b 45 08             	mov    0x8(%ebp),%eax
  80150e:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801513:	99                   	cltd   
  801514:	f7 f9                	idiv   %ecx
  801516:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801519:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80151c:	8d 50 01             	lea    0x1(%eax),%edx
  80151f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801522:	89 c2                	mov    %eax,%edx
  801524:	8b 45 0c             	mov    0xc(%ebp),%eax
  801527:	01 d0                	add    %edx,%eax
  801529:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80152c:	83 c2 30             	add    $0x30,%edx
  80152f:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801531:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801534:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801539:	f7 e9                	imul   %ecx
  80153b:	c1 fa 02             	sar    $0x2,%edx
  80153e:	89 c8                	mov    %ecx,%eax
  801540:	c1 f8 1f             	sar    $0x1f,%eax
  801543:	29 c2                	sub    %eax,%edx
  801545:	89 d0                	mov    %edx,%eax
  801547:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80154a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80154d:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801552:	f7 e9                	imul   %ecx
  801554:	c1 fa 02             	sar    $0x2,%edx
  801557:	89 c8                	mov    %ecx,%eax
  801559:	c1 f8 1f             	sar    $0x1f,%eax
  80155c:	29 c2                	sub    %eax,%edx
  80155e:	89 d0                	mov    %edx,%eax
  801560:	c1 e0 02             	shl    $0x2,%eax
  801563:	01 d0                	add    %edx,%eax
  801565:	01 c0                	add    %eax,%eax
  801567:	29 c1                	sub    %eax,%ecx
  801569:	89 ca                	mov    %ecx,%edx
  80156b:	85 d2                	test   %edx,%edx
  80156d:	75 9c                	jne    80150b <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80156f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801576:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801579:	48                   	dec    %eax
  80157a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80157d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801581:	74 3d                	je     8015c0 <ltostr+0xe2>
		start = 1 ;
  801583:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80158a:	eb 34                	jmp    8015c0 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80158c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80158f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801592:	01 d0                	add    %edx,%eax
  801594:	8a 00                	mov    (%eax),%al
  801596:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801599:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80159c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80159f:	01 c2                	add    %eax,%edx
  8015a1:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8015a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a7:	01 c8                	add    %ecx,%eax
  8015a9:	8a 00                	mov    (%eax),%al
  8015ab:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8015ad:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015b3:	01 c2                	add    %eax,%edx
  8015b5:	8a 45 eb             	mov    -0x15(%ebp),%al
  8015b8:	88 02                	mov    %al,(%edx)
		start++ ;
  8015ba:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8015bd:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8015c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015c3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8015c6:	7c c4                	jl     80158c <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8015c8:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8015cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ce:	01 d0                	add    %edx,%eax
  8015d0:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8015d3:	90                   	nop
  8015d4:	c9                   	leave  
  8015d5:	c3                   	ret    

008015d6 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8015d6:	55                   	push   %ebp
  8015d7:	89 e5                	mov    %esp,%ebp
  8015d9:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8015dc:	ff 75 08             	pushl  0x8(%ebp)
  8015df:	e8 54 fa ff ff       	call   801038 <strlen>
  8015e4:	83 c4 04             	add    $0x4,%esp
  8015e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8015ea:	ff 75 0c             	pushl  0xc(%ebp)
  8015ed:	e8 46 fa ff ff       	call   801038 <strlen>
  8015f2:	83 c4 04             	add    $0x4,%esp
  8015f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8015f8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8015ff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801606:	eb 17                	jmp    80161f <strcconcat+0x49>
		final[s] = str1[s] ;
  801608:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80160b:	8b 45 10             	mov    0x10(%ebp),%eax
  80160e:	01 c2                	add    %eax,%edx
  801610:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801613:	8b 45 08             	mov    0x8(%ebp),%eax
  801616:	01 c8                	add    %ecx,%eax
  801618:	8a 00                	mov    (%eax),%al
  80161a:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80161c:	ff 45 fc             	incl   -0x4(%ebp)
  80161f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801622:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801625:	7c e1                	jl     801608 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801627:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80162e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801635:	eb 1f                	jmp    801656 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801637:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80163a:	8d 50 01             	lea    0x1(%eax),%edx
  80163d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801640:	89 c2                	mov    %eax,%edx
  801642:	8b 45 10             	mov    0x10(%ebp),%eax
  801645:	01 c2                	add    %eax,%edx
  801647:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80164a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80164d:	01 c8                	add    %ecx,%eax
  80164f:	8a 00                	mov    (%eax),%al
  801651:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801653:	ff 45 f8             	incl   -0x8(%ebp)
  801656:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801659:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80165c:	7c d9                	jl     801637 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80165e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801661:	8b 45 10             	mov    0x10(%ebp),%eax
  801664:	01 d0                	add    %edx,%eax
  801666:	c6 00 00             	movb   $0x0,(%eax)
}
  801669:	90                   	nop
  80166a:	c9                   	leave  
  80166b:	c3                   	ret    

0080166c <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80166c:	55                   	push   %ebp
  80166d:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80166f:	8b 45 14             	mov    0x14(%ebp),%eax
  801672:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801678:	8b 45 14             	mov    0x14(%ebp),%eax
  80167b:	8b 00                	mov    (%eax),%eax
  80167d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801684:	8b 45 10             	mov    0x10(%ebp),%eax
  801687:	01 d0                	add    %edx,%eax
  801689:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80168f:	eb 0c                	jmp    80169d <strsplit+0x31>
			*string++ = 0;
  801691:	8b 45 08             	mov    0x8(%ebp),%eax
  801694:	8d 50 01             	lea    0x1(%eax),%edx
  801697:	89 55 08             	mov    %edx,0x8(%ebp)
  80169a:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80169d:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a0:	8a 00                	mov    (%eax),%al
  8016a2:	84 c0                	test   %al,%al
  8016a4:	74 18                	je     8016be <strsplit+0x52>
  8016a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a9:	8a 00                	mov    (%eax),%al
  8016ab:	0f be c0             	movsbl %al,%eax
  8016ae:	50                   	push   %eax
  8016af:	ff 75 0c             	pushl  0xc(%ebp)
  8016b2:	e8 13 fb ff ff       	call   8011ca <strchr>
  8016b7:	83 c4 08             	add    $0x8,%esp
  8016ba:	85 c0                	test   %eax,%eax
  8016bc:	75 d3                	jne    801691 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8016be:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c1:	8a 00                	mov    (%eax),%al
  8016c3:	84 c0                	test   %al,%al
  8016c5:	74 5a                	je     801721 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8016c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8016ca:	8b 00                	mov    (%eax),%eax
  8016cc:	83 f8 0f             	cmp    $0xf,%eax
  8016cf:	75 07                	jne    8016d8 <strsplit+0x6c>
		{
			return 0;
  8016d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8016d6:	eb 66                	jmp    80173e <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8016d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8016db:	8b 00                	mov    (%eax),%eax
  8016dd:	8d 48 01             	lea    0x1(%eax),%ecx
  8016e0:	8b 55 14             	mov    0x14(%ebp),%edx
  8016e3:	89 0a                	mov    %ecx,(%edx)
  8016e5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ef:	01 c2                	add    %eax,%edx
  8016f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f4:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016f6:	eb 03                	jmp    8016fb <strsplit+0x8f>
			string++;
  8016f8:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fe:	8a 00                	mov    (%eax),%al
  801700:	84 c0                	test   %al,%al
  801702:	74 8b                	je     80168f <strsplit+0x23>
  801704:	8b 45 08             	mov    0x8(%ebp),%eax
  801707:	8a 00                	mov    (%eax),%al
  801709:	0f be c0             	movsbl %al,%eax
  80170c:	50                   	push   %eax
  80170d:	ff 75 0c             	pushl  0xc(%ebp)
  801710:	e8 b5 fa ff ff       	call   8011ca <strchr>
  801715:	83 c4 08             	add    $0x8,%esp
  801718:	85 c0                	test   %eax,%eax
  80171a:	74 dc                	je     8016f8 <strsplit+0x8c>
			string++;
	}
  80171c:	e9 6e ff ff ff       	jmp    80168f <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801721:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801722:	8b 45 14             	mov    0x14(%ebp),%eax
  801725:	8b 00                	mov    (%eax),%eax
  801727:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80172e:	8b 45 10             	mov    0x10(%ebp),%eax
  801731:	01 d0                	add    %edx,%eax
  801733:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801739:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80173e:	c9                   	leave  
  80173f:	c3                   	ret    

00801740 <malloc>:
//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//

void* malloc(uint32 size)
{
  801740:	55                   	push   %ebp
  801741:	89 e5                	mov    %esp,%ebp
  801743:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020  - User Heap] malloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801746:	83 ec 04             	sub    $0x4,%esp
  801749:	68 90 27 80 00       	push   $0x802790
  80174e:	6a 19                	push   $0x19
  801750:	68 b5 27 80 00       	push   $0x8027b5
  801755:	e8 ba ef ff ff       	call   800714 <_panic>

0080175a <smalloc>:
	//change this "return" according to your answer
	return 0;
}

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80175a:	55                   	push   %ebp
  80175b:	89 e5                	mov    %esp,%ebp
  80175d:	83 ec 18             	sub    $0x18,%esp
  801760:	8b 45 10             	mov    0x10(%ebp),%eax
  801763:	88 45 f4             	mov    %al,-0xc(%ebp)
	//TODO: [PROJECT 2020  - Shared Variables: Creation] smalloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801766:	83 ec 04             	sub    $0x4,%esp
  801769:	68 c4 27 80 00       	push   $0x8027c4
  80176e:	6a 31                	push   $0x31
  801770:	68 b5 27 80 00       	push   $0x8027b5
  801775:	e8 9a ef ff ff       	call   800714 <_panic>

0080177a <sget>:
	//change this "return" according to your answer
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80177a:	55                   	push   %ebp
  80177b:	89 e5                	mov    %esp,%ebp
  80177d:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020 -  Shared Variables: Get] sget() [User Side]
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801780:	83 ec 04             	sub    $0x4,%esp
  801783:	68 ec 27 80 00       	push   $0x8027ec
  801788:	6a 4a                	push   $0x4a
  80178a:	68 b5 27 80 00       	push   $0x8027b5
  80178f:	e8 80 ef ff ff       	call   800714 <_panic>

00801794 <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  801794:	55                   	push   %ebp
  801795:	89 e5                	mov    %esp,%ebp
  801797:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020 - User Heap] free() [User Side]
	// Write your code here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  80179a:	83 ec 04             	sub    $0x4,%esp
  80179d:	68 10 28 80 00       	push   $0x802810
  8017a2:	6a 70                	push   $0x70
  8017a4:	68 b5 27 80 00       	push   $0x8027b5
  8017a9:	e8 66 ef ff ff       	call   800714 <_panic>

008017ae <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8017ae:	55                   	push   %ebp
  8017af:	89 e5                	mov    %esp,%ebp
  8017b1:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020 - BOUNS3] Free Shared Variable [User Side]
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8017b4:	83 ec 04             	sub    $0x4,%esp
  8017b7:	68 34 28 80 00       	push   $0x802834
  8017bc:	68 8b 00 00 00       	push   $0x8b
  8017c1:	68 b5 27 80 00       	push   $0x8027b5
  8017c6:	e8 49 ef ff ff       	call   800714 <_panic>

008017cb <realloc>:
//		which switches to the kernel mode, calls moveMem(struct Env* e, uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
//		in "memory_manager.c", then switch back to the user mode here
//	the moveMem function is empty, make sure to implement it.

void *realloc(void *virtual_address, uint32 new_size)
{
  8017cb:	55                   	push   %ebp
  8017cc:	89 e5                	mov    %esp,%ebp
  8017ce:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020 - BONUS1] User Heap Realloc [User Side]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8017d1:	83 ec 04             	sub    $0x4,%esp
  8017d4:	68 58 28 80 00       	push   $0x802858
  8017d9:	68 a8 00 00 00       	push   $0xa8
  8017de:	68 b5 27 80 00       	push   $0x8027b5
  8017e3:	e8 2c ef ff ff       	call   800714 <_panic>

008017e8 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8017e8:	55                   	push   %ebp
  8017e9:	89 e5                	mov    %esp,%ebp
  8017eb:	57                   	push   %edi
  8017ec:	56                   	push   %esi
  8017ed:	53                   	push   %ebx
  8017ee:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017f7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017fa:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017fd:	8b 7d 18             	mov    0x18(%ebp),%edi
  801800:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801803:	cd 30                	int    $0x30
  801805:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801808:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80180b:	83 c4 10             	add    $0x10,%esp
  80180e:	5b                   	pop    %ebx
  80180f:	5e                   	pop    %esi
  801810:	5f                   	pop    %edi
  801811:	5d                   	pop    %ebp
  801812:	c3                   	ret    

00801813 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801813:	55                   	push   %ebp
  801814:	89 e5                	mov    %esp,%ebp
  801816:	83 ec 04             	sub    $0x4,%esp
  801819:	8b 45 10             	mov    0x10(%ebp),%eax
  80181c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80181f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801823:	8b 45 08             	mov    0x8(%ebp),%eax
  801826:	6a 00                	push   $0x0
  801828:	6a 00                	push   $0x0
  80182a:	52                   	push   %edx
  80182b:	ff 75 0c             	pushl  0xc(%ebp)
  80182e:	50                   	push   %eax
  80182f:	6a 00                	push   $0x0
  801831:	e8 b2 ff ff ff       	call   8017e8 <syscall>
  801836:	83 c4 18             	add    $0x18,%esp
}
  801839:	90                   	nop
  80183a:	c9                   	leave  
  80183b:	c3                   	ret    

0080183c <sys_cgetc>:

int
sys_cgetc(void)
{
  80183c:	55                   	push   %ebp
  80183d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80183f:	6a 00                	push   $0x0
  801841:	6a 00                	push   $0x0
  801843:	6a 00                	push   $0x0
  801845:	6a 00                	push   $0x0
  801847:	6a 00                	push   $0x0
  801849:	6a 01                	push   $0x1
  80184b:	e8 98 ff ff ff       	call   8017e8 <syscall>
  801850:	83 c4 18             	add    $0x18,%esp
}
  801853:	c9                   	leave  
  801854:	c3                   	ret    

00801855 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  801855:	55                   	push   %ebp
  801856:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  801858:	8b 45 08             	mov    0x8(%ebp),%eax
  80185b:	6a 00                	push   $0x0
  80185d:	6a 00                	push   $0x0
  80185f:	6a 00                	push   $0x0
  801861:	6a 00                	push   $0x0
  801863:	50                   	push   %eax
  801864:	6a 05                	push   $0x5
  801866:	e8 7d ff ff ff       	call   8017e8 <syscall>
  80186b:	83 c4 18             	add    $0x18,%esp
}
  80186e:	c9                   	leave  
  80186f:	c3                   	ret    

00801870 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801870:	55                   	push   %ebp
  801871:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801873:	6a 00                	push   $0x0
  801875:	6a 00                	push   $0x0
  801877:	6a 00                	push   $0x0
  801879:	6a 00                	push   $0x0
  80187b:	6a 00                	push   $0x0
  80187d:	6a 02                	push   $0x2
  80187f:	e8 64 ff ff ff       	call   8017e8 <syscall>
  801884:	83 c4 18             	add    $0x18,%esp
}
  801887:	c9                   	leave  
  801888:	c3                   	ret    

00801889 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801889:	55                   	push   %ebp
  80188a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80188c:	6a 00                	push   $0x0
  80188e:	6a 00                	push   $0x0
  801890:	6a 00                	push   $0x0
  801892:	6a 00                	push   $0x0
  801894:	6a 00                	push   $0x0
  801896:	6a 03                	push   $0x3
  801898:	e8 4b ff ff ff       	call   8017e8 <syscall>
  80189d:	83 c4 18             	add    $0x18,%esp
}
  8018a0:	c9                   	leave  
  8018a1:	c3                   	ret    

008018a2 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8018a2:	55                   	push   %ebp
  8018a3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8018a5:	6a 00                	push   $0x0
  8018a7:	6a 00                	push   $0x0
  8018a9:	6a 00                	push   $0x0
  8018ab:	6a 00                	push   $0x0
  8018ad:	6a 00                	push   $0x0
  8018af:	6a 04                	push   $0x4
  8018b1:	e8 32 ff ff ff       	call   8017e8 <syscall>
  8018b6:	83 c4 18             	add    $0x18,%esp
}
  8018b9:	c9                   	leave  
  8018ba:	c3                   	ret    

008018bb <sys_env_exit>:


void sys_env_exit(void)
{
  8018bb:	55                   	push   %ebp
  8018bc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  8018be:	6a 00                	push   $0x0
  8018c0:	6a 00                	push   $0x0
  8018c2:	6a 00                	push   $0x0
  8018c4:	6a 00                	push   $0x0
  8018c6:	6a 00                	push   $0x0
  8018c8:	6a 06                	push   $0x6
  8018ca:	e8 19 ff ff ff       	call   8017e8 <syscall>
  8018cf:	83 c4 18             	add    $0x18,%esp
}
  8018d2:	90                   	nop
  8018d3:	c9                   	leave  
  8018d4:	c3                   	ret    

008018d5 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  8018d5:	55                   	push   %ebp
  8018d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8018d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018db:	8b 45 08             	mov    0x8(%ebp),%eax
  8018de:	6a 00                	push   $0x0
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 00                	push   $0x0
  8018e4:	52                   	push   %edx
  8018e5:	50                   	push   %eax
  8018e6:	6a 07                	push   $0x7
  8018e8:	e8 fb fe ff ff       	call   8017e8 <syscall>
  8018ed:	83 c4 18             	add    $0x18,%esp
}
  8018f0:	c9                   	leave  
  8018f1:	c3                   	ret    

008018f2 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018f2:	55                   	push   %ebp
  8018f3:	89 e5                	mov    %esp,%ebp
  8018f5:	56                   	push   %esi
  8018f6:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018f7:	8b 75 18             	mov    0x18(%ebp),%esi
  8018fa:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018fd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801900:	8b 55 0c             	mov    0xc(%ebp),%edx
  801903:	8b 45 08             	mov    0x8(%ebp),%eax
  801906:	56                   	push   %esi
  801907:	53                   	push   %ebx
  801908:	51                   	push   %ecx
  801909:	52                   	push   %edx
  80190a:	50                   	push   %eax
  80190b:	6a 08                	push   $0x8
  80190d:	e8 d6 fe ff ff       	call   8017e8 <syscall>
  801912:	83 c4 18             	add    $0x18,%esp
}
  801915:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801918:	5b                   	pop    %ebx
  801919:	5e                   	pop    %esi
  80191a:	5d                   	pop    %ebp
  80191b:	c3                   	ret    

0080191c <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80191c:	55                   	push   %ebp
  80191d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80191f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801922:	8b 45 08             	mov    0x8(%ebp),%eax
  801925:	6a 00                	push   $0x0
  801927:	6a 00                	push   $0x0
  801929:	6a 00                	push   $0x0
  80192b:	52                   	push   %edx
  80192c:	50                   	push   %eax
  80192d:	6a 09                	push   $0x9
  80192f:	e8 b4 fe ff ff       	call   8017e8 <syscall>
  801934:	83 c4 18             	add    $0x18,%esp
}
  801937:	c9                   	leave  
  801938:	c3                   	ret    

00801939 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801939:	55                   	push   %ebp
  80193a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80193c:	6a 00                	push   $0x0
  80193e:	6a 00                	push   $0x0
  801940:	6a 00                	push   $0x0
  801942:	ff 75 0c             	pushl  0xc(%ebp)
  801945:	ff 75 08             	pushl  0x8(%ebp)
  801948:	6a 0a                	push   $0xa
  80194a:	e8 99 fe ff ff       	call   8017e8 <syscall>
  80194f:	83 c4 18             	add    $0x18,%esp
}
  801952:	c9                   	leave  
  801953:	c3                   	ret    

00801954 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801954:	55                   	push   %ebp
  801955:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801957:	6a 00                	push   $0x0
  801959:	6a 00                	push   $0x0
  80195b:	6a 00                	push   $0x0
  80195d:	6a 00                	push   $0x0
  80195f:	6a 00                	push   $0x0
  801961:	6a 0b                	push   $0xb
  801963:	e8 80 fe ff ff       	call   8017e8 <syscall>
  801968:	83 c4 18             	add    $0x18,%esp
}
  80196b:	c9                   	leave  
  80196c:	c3                   	ret    

0080196d <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80196d:	55                   	push   %ebp
  80196e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801970:	6a 00                	push   $0x0
  801972:	6a 00                	push   $0x0
  801974:	6a 00                	push   $0x0
  801976:	6a 00                	push   $0x0
  801978:	6a 00                	push   $0x0
  80197a:	6a 0c                	push   $0xc
  80197c:	e8 67 fe ff ff       	call   8017e8 <syscall>
  801981:	83 c4 18             	add    $0x18,%esp
}
  801984:	c9                   	leave  
  801985:	c3                   	ret    

00801986 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801986:	55                   	push   %ebp
  801987:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801989:	6a 00                	push   $0x0
  80198b:	6a 00                	push   $0x0
  80198d:	6a 00                	push   $0x0
  80198f:	6a 00                	push   $0x0
  801991:	6a 00                	push   $0x0
  801993:	6a 0d                	push   $0xd
  801995:	e8 4e fe ff ff       	call   8017e8 <syscall>
  80199a:	83 c4 18             	add    $0x18,%esp
}
  80199d:	c9                   	leave  
  80199e:	c3                   	ret    

0080199f <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  80199f:	55                   	push   %ebp
  8019a0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  8019a2:	6a 00                	push   $0x0
  8019a4:	6a 00                	push   $0x0
  8019a6:	6a 00                	push   $0x0
  8019a8:	ff 75 0c             	pushl  0xc(%ebp)
  8019ab:	ff 75 08             	pushl  0x8(%ebp)
  8019ae:	6a 11                	push   $0x11
  8019b0:	e8 33 fe ff ff       	call   8017e8 <syscall>
  8019b5:	83 c4 18             	add    $0x18,%esp
	return;
  8019b8:	90                   	nop
}
  8019b9:	c9                   	leave  
  8019ba:	c3                   	ret    

008019bb <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  8019bb:	55                   	push   %ebp
  8019bc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  8019be:	6a 00                	push   $0x0
  8019c0:	6a 00                	push   $0x0
  8019c2:	6a 00                	push   $0x0
  8019c4:	ff 75 0c             	pushl  0xc(%ebp)
  8019c7:	ff 75 08             	pushl  0x8(%ebp)
  8019ca:	6a 12                	push   $0x12
  8019cc:	e8 17 fe ff ff       	call   8017e8 <syscall>
  8019d1:	83 c4 18             	add    $0x18,%esp
	return ;
  8019d4:	90                   	nop
}
  8019d5:	c9                   	leave  
  8019d6:	c3                   	ret    

008019d7 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8019d7:	55                   	push   %ebp
  8019d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8019da:	6a 00                	push   $0x0
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 0e                	push   $0xe
  8019e6:	e8 fd fd ff ff       	call   8017e8 <syscall>
  8019eb:	83 c4 18             	add    $0x18,%esp
}
  8019ee:	c9                   	leave  
  8019ef:	c3                   	ret    

008019f0 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8019f0:	55                   	push   %ebp
  8019f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8019f3:	6a 00                	push   $0x0
  8019f5:	6a 00                	push   $0x0
  8019f7:	6a 00                	push   $0x0
  8019f9:	6a 00                	push   $0x0
  8019fb:	ff 75 08             	pushl  0x8(%ebp)
  8019fe:	6a 0f                	push   $0xf
  801a00:	e8 e3 fd ff ff       	call   8017e8 <syscall>
  801a05:	83 c4 18             	add    $0x18,%esp
}
  801a08:	c9                   	leave  
  801a09:	c3                   	ret    

00801a0a <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a0a:	55                   	push   %ebp
  801a0b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a0d:	6a 00                	push   $0x0
  801a0f:	6a 00                	push   $0x0
  801a11:	6a 00                	push   $0x0
  801a13:	6a 00                	push   $0x0
  801a15:	6a 00                	push   $0x0
  801a17:	6a 10                	push   $0x10
  801a19:	e8 ca fd ff ff       	call   8017e8 <syscall>
  801a1e:	83 c4 18             	add    $0x18,%esp
}
  801a21:	90                   	nop
  801a22:	c9                   	leave  
  801a23:	c3                   	ret    

00801a24 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801a24:	55                   	push   %ebp
  801a25:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801a27:	6a 00                	push   $0x0
  801a29:	6a 00                	push   $0x0
  801a2b:	6a 00                	push   $0x0
  801a2d:	6a 00                	push   $0x0
  801a2f:	6a 00                	push   $0x0
  801a31:	6a 14                	push   $0x14
  801a33:	e8 b0 fd ff ff       	call   8017e8 <syscall>
  801a38:	83 c4 18             	add    $0x18,%esp
}
  801a3b:	90                   	nop
  801a3c:	c9                   	leave  
  801a3d:	c3                   	ret    

00801a3e <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801a3e:	55                   	push   %ebp
  801a3f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801a41:	6a 00                	push   $0x0
  801a43:	6a 00                	push   $0x0
  801a45:	6a 00                	push   $0x0
  801a47:	6a 00                	push   $0x0
  801a49:	6a 00                	push   $0x0
  801a4b:	6a 15                	push   $0x15
  801a4d:	e8 96 fd ff ff       	call   8017e8 <syscall>
  801a52:	83 c4 18             	add    $0x18,%esp
}
  801a55:	90                   	nop
  801a56:	c9                   	leave  
  801a57:	c3                   	ret    

00801a58 <sys_cputc>:


void
sys_cputc(const char c)
{
  801a58:	55                   	push   %ebp
  801a59:	89 e5                	mov    %esp,%ebp
  801a5b:	83 ec 04             	sub    $0x4,%esp
  801a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a61:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a64:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a68:	6a 00                	push   $0x0
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 00                	push   $0x0
  801a70:	50                   	push   %eax
  801a71:	6a 16                	push   $0x16
  801a73:	e8 70 fd ff ff       	call   8017e8 <syscall>
  801a78:	83 c4 18             	add    $0x18,%esp
}
  801a7b:	90                   	nop
  801a7c:	c9                   	leave  
  801a7d:	c3                   	ret    

00801a7e <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a7e:	55                   	push   %ebp
  801a7f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a81:	6a 00                	push   $0x0
  801a83:	6a 00                	push   $0x0
  801a85:	6a 00                	push   $0x0
  801a87:	6a 00                	push   $0x0
  801a89:	6a 00                	push   $0x0
  801a8b:	6a 17                	push   $0x17
  801a8d:	e8 56 fd ff ff       	call   8017e8 <syscall>
  801a92:	83 c4 18             	add    $0x18,%esp
}
  801a95:	90                   	nop
  801a96:	c9                   	leave  
  801a97:	c3                   	ret    

00801a98 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a98:	55                   	push   %ebp
  801a99:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9e:	6a 00                	push   $0x0
  801aa0:	6a 00                	push   $0x0
  801aa2:	6a 00                	push   $0x0
  801aa4:	ff 75 0c             	pushl  0xc(%ebp)
  801aa7:	50                   	push   %eax
  801aa8:	6a 18                	push   $0x18
  801aaa:	e8 39 fd ff ff       	call   8017e8 <syscall>
  801aaf:	83 c4 18             	add    $0x18,%esp
}
  801ab2:	c9                   	leave  
  801ab3:	c3                   	ret    

00801ab4 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801ab4:	55                   	push   %ebp
  801ab5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ab7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aba:	8b 45 08             	mov    0x8(%ebp),%eax
  801abd:	6a 00                	push   $0x0
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 00                	push   $0x0
  801ac3:	52                   	push   %edx
  801ac4:	50                   	push   %eax
  801ac5:	6a 1b                	push   $0x1b
  801ac7:	e8 1c fd ff ff       	call   8017e8 <syscall>
  801acc:	83 c4 18             	add    $0x18,%esp
}
  801acf:	c9                   	leave  
  801ad0:	c3                   	ret    

00801ad1 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ad1:	55                   	push   %ebp
  801ad2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ad4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  801ada:	6a 00                	push   $0x0
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	52                   	push   %edx
  801ae1:	50                   	push   %eax
  801ae2:	6a 19                	push   $0x19
  801ae4:	e8 ff fc ff ff       	call   8017e8 <syscall>
  801ae9:	83 c4 18             	add    $0x18,%esp
}
  801aec:	90                   	nop
  801aed:	c9                   	leave  
  801aee:	c3                   	ret    

00801aef <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801aef:	55                   	push   %ebp
  801af0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801af2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801af5:	8b 45 08             	mov    0x8(%ebp),%eax
  801af8:	6a 00                	push   $0x0
  801afa:	6a 00                	push   $0x0
  801afc:	6a 00                	push   $0x0
  801afe:	52                   	push   %edx
  801aff:	50                   	push   %eax
  801b00:	6a 1a                	push   $0x1a
  801b02:	e8 e1 fc ff ff       	call   8017e8 <syscall>
  801b07:	83 c4 18             	add    $0x18,%esp
}
  801b0a:	90                   	nop
  801b0b:	c9                   	leave  
  801b0c:	c3                   	ret    

00801b0d <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b0d:	55                   	push   %ebp
  801b0e:	89 e5                	mov    %esp,%ebp
  801b10:	83 ec 04             	sub    $0x4,%esp
  801b13:	8b 45 10             	mov    0x10(%ebp),%eax
  801b16:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b19:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b1c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b20:	8b 45 08             	mov    0x8(%ebp),%eax
  801b23:	6a 00                	push   $0x0
  801b25:	51                   	push   %ecx
  801b26:	52                   	push   %edx
  801b27:	ff 75 0c             	pushl  0xc(%ebp)
  801b2a:	50                   	push   %eax
  801b2b:	6a 1c                	push   $0x1c
  801b2d:	e8 b6 fc ff ff       	call   8017e8 <syscall>
  801b32:	83 c4 18             	add    $0x18,%esp
}
  801b35:	c9                   	leave  
  801b36:	c3                   	ret    

00801b37 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b37:	55                   	push   %ebp
  801b38:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b40:	6a 00                	push   $0x0
  801b42:	6a 00                	push   $0x0
  801b44:	6a 00                	push   $0x0
  801b46:	52                   	push   %edx
  801b47:	50                   	push   %eax
  801b48:	6a 1d                	push   $0x1d
  801b4a:	e8 99 fc ff ff       	call   8017e8 <syscall>
  801b4f:	83 c4 18             	add    $0x18,%esp
}
  801b52:	c9                   	leave  
  801b53:	c3                   	ret    

00801b54 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b54:	55                   	push   %ebp
  801b55:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b57:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b5a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b60:	6a 00                	push   $0x0
  801b62:	6a 00                	push   $0x0
  801b64:	51                   	push   %ecx
  801b65:	52                   	push   %edx
  801b66:	50                   	push   %eax
  801b67:	6a 1e                	push   $0x1e
  801b69:	e8 7a fc ff ff       	call   8017e8 <syscall>
  801b6e:	83 c4 18             	add    $0x18,%esp
}
  801b71:	c9                   	leave  
  801b72:	c3                   	ret    

00801b73 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b73:	55                   	push   %ebp
  801b74:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b76:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b79:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7c:	6a 00                	push   $0x0
  801b7e:	6a 00                	push   $0x0
  801b80:	6a 00                	push   $0x0
  801b82:	52                   	push   %edx
  801b83:	50                   	push   %eax
  801b84:	6a 1f                	push   $0x1f
  801b86:	e8 5d fc ff ff       	call   8017e8 <syscall>
  801b8b:	83 c4 18             	add    $0x18,%esp
}
  801b8e:	c9                   	leave  
  801b8f:	c3                   	ret    

00801b90 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b90:	55                   	push   %ebp
  801b91:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b93:	6a 00                	push   $0x0
  801b95:	6a 00                	push   $0x0
  801b97:	6a 00                	push   $0x0
  801b99:	6a 00                	push   $0x0
  801b9b:	6a 00                	push   $0x0
  801b9d:	6a 20                	push   $0x20
  801b9f:	e8 44 fc ff ff       	call   8017e8 <syscall>
  801ba4:	83 c4 18             	add    $0x18,%esp
}
  801ba7:	c9                   	leave  
  801ba8:	c3                   	ret    

00801ba9 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int percent_WS_pages_to_remove)
{
  801ba9:	55                   	push   %ebp
  801baa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size, (uint32)percent_WS_pages_to_remove, 0,0);
  801bac:	8b 45 08             	mov    0x8(%ebp),%eax
  801baf:	6a 00                	push   $0x0
  801bb1:	6a 00                	push   $0x0
  801bb3:	ff 75 10             	pushl  0x10(%ebp)
  801bb6:	ff 75 0c             	pushl  0xc(%ebp)
  801bb9:	50                   	push   %eax
  801bba:	6a 21                	push   $0x21
  801bbc:	e8 27 fc ff ff       	call   8017e8 <syscall>
  801bc1:	83 c4 18             	add    $0x18,%esp
}
  801bc4:	c9                   	leave  
  801bc5:	c3                   	ret    

00801bc6 <sys_run_env>:


void
sys_run_env(int32 envId)
{
  801bc6:	55                   	push   %ebp
  801bc7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcc:	6a 00                	push   $0x0
  801bce:	6a 00                	push   $0x0
  801bd0:	6a 00                	push   $0x0
  801bd2:	6a 00                	push   $0x0
  801bd4:	50                   	push   %eax
  801bd5:	6a 22                	push   $0x22
  801bd7:	e8 0c fc ff ff       	call   8017e8 <syscall>
  801bdc:	83 c4 18             	add    $0x18,%esp
}
  801bdf:	90                   	nop
  801be0:	c9                   	leave  
  801be1:	c3                   	ret    

00801be2 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  801be2:	55                   	push   %ebp
  801be3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  801be5:	8b 45 08             	mov    0x8(%ebp),%eax
  801be8:	6a 00                	push   $0x0
  801bea:	6a 00                	push   $0x0
  801bec:	6a 00                	push   $0x0
  801bee:	6a 00                	push   $0x0
  801bf0:	50                   	push   %eax
  801bf1:	6a 23                	push   $0x23
  801bf3:	e8 f0 fb ff ff       	call   8017e8 <syscall>
  801bf8:	83 c4 18             	add    $0x18,%esp
}
  801bfb:	90                   	nop
  801bfc:	c9                   	leave  
  801bfd:	c3                   	ret    

00801bfe <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  801bfe:	55                   	push   %ebp
  801bff:	89 e5                	mov    %esp,%ebp
  801c01:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c04:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c07:	8d 50 04             	lea    0x4(%eax),%edx
  801c0a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c0d:	6a 00                	push   $0x0
  801c0f:	6a 00                	push   $0x0
  801c11:	6a 00                	push   $0x0
  801c13:	52                   	push   %edx
  801c14:	50                   	push   %eax
  801c15:	6a 24                	push   $0x24
  801c17:	e8 cc fb ff ff       	call   8017e8 <syscall>
  801c1c:	83 c4 18             	add    $0x18,%esp
	return result;
  801c1f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c22:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c25:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c28:	89 01                	mov    %eax,(%ecx)
  801c2a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c30:	c9                   	leave  
  801c31:	c2 04 00             	ret    $0x4

00801c34 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c34:	55                   	push   %ebp
  801c35:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c37:	6a 00                	push   $0x0
  801c39:	6a 00                	push   $0x0
  801c3b:	ff 75 10             	pushl  0x10(%ebp)
  801c3e:	ff 75 0c             	pushl  0xc(%ebp)
  801c41:	ff 75 08             	pushl  0x8(%ebp)
  801c44:	6a 13                	push   $0x13
  801c46:	e8 9d fb ff ff       	call   8017e8 <syscall>
  801c4b:	83 c4 18             	add    $0x18,%esp
	return ;
  801c4e:	90                   	nop
}
  801c4f:	c9                   	leave  
  801c50:	c3                   	ret    

00801c51 <sys_rcr2>:
uint32 sys_rcr2()
{
  801c51:	55                   	push   %ebp
  801c52:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c54:	6a 00                	push   $0x0
  801c56:	6a 00                	push   $0x0
  801c58:	6a 00                	push   $0x0
  801c5a:	6a 00                	push   $0x0
  801c5c:	6a 00                	push   $0x0
  801c5e:	6a 25                	push   $0x25
  801c60:	e8 83 fb ff ff       	call   8017e8 <syscall>
  801c65:	83 c4 18             	add    $0x18,%esp
}
  801c68:	c9                   	leave  
  801c69:	c3                   	ret    

00801c6a <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801c6a:	55                   	push   %ebp
  801c6b:	89 e5                	mov    %esp,%ebp
  801c6d:	83 ec 04             	sub    $0x4,%esp
  801c70:	8b 45 08             	mov    0x8(%ebp),%eax
  801c73:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c76:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c7a:	6a 00                	push   $0x0
  801c7c:	6a 00                	push   $0x0
  801c7e:	6a 00                	push   $0x0
  801c80:	6a 00                	push   $0x0
  801c82:	50                   	push   %eax
  801c83:	6a 26                	push   $0x26
  801c85:	e8 5e fb ff ff       	call   8017e8 <syscall>
  801c8a:	83 c4 18             	add    $0x18,%esp
	return ;
  801c8d:	90                   	nop
}
  801c8e:	c9                   	leave  
  801c8f:	c3                   	ret    

00801c90 <rsttst>:
void rsttst()
{
  801c90:	55                   	push   %ebp
  801c91:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c93:	6a 00                	push   $0x0
  801c95:	6a 00                	push   $0x0
  801c97:	6a 00                	push   $0x0
  801c99:	6a 00                	push   $0x0
  801c9b:	6a 00                	push   $0x0
  801c9d:	6a 28                	push   $0x28
  801c9f:	e8 44 fb ff ff       	call   8017e8 <syscall>
  801ca4:	83 c4 18             	add    $0x18,%esp
	return ;
  801ca7:	90                   	nop
}
  801ca8:	c9                   	leave  
  801ca9:	c3                   	ret    

00801caa <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801caa:	55                   	push   %ebp
  801cab:	89 e5                	mov    %esp,%ebp
  801cad:	83 ec 04             	sub    $0x4,%esp
  801cb0:	8b 45 14             	mov    0x14(%ebp),%eax
  801cb3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801cb6:	8b 55 18             	mov    0x18(%ebp),%edx
  801cb9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801cbd:	52                   	push   %edx
  801cbe:	50                   	push   %eax
  801cbf:	ff 75 10             	pushl  0x10(%ebp)
  801cc2:	ff 75 0c             	pushl  0xc(%ebp)
  801cc5:	ff 75 08             	pushl  0x8(%ebp)
  801cc8:	6a 27                	push   $0x27
  801cca:	e8 19 fb ff ff       	call   8017e8 <syscall>
  801ccf:	83 c4 18             	add    $0x18,%esp
	return ;
  801cd2:	90                   	nop
}
  801cd3:	c9                   	leave  
  801cd4:	c3                   	ret    

00801cd5 <chktst>:
void chktst(uint32 n)
{
  801cd5:	55                   	push   %ebp
  801cd6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801cd8:	6a 00                	push   $0x0
  801cda:	6a 00                	push   $0x0
  801cdc:	6a 00                	push   $0x0
  801cde:	6a 00                	push   $0x0
  801ce0:	ff 75 08             	pushl  0x8(%ebp)
  801ce3:	6a 29                	push   $0x29
  801ce5:	e8 fe fa ff ff       	call   8017e8 <syscall>
  801cea:	83 c4 18             	add    $0x18,%esp
	return ;
  801ced:	90                   	nop
}
  801cee:	c9                   	leave  
  801cef:	c3                   	ret    

00801cf0 <inctst>:

void inctst()
{
  801cf0:	55                   	push   %ebp
  801cf1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801cf3:	6a 00                	push   $0x0
  801cf5:	6a 00                	push   $0x0
  801cf7:	6a 00                	push   $0x0
  801cf9:	6a 00                	push   $0x0
  801cfb:	6a 00                	push   $0x0
  801cfd:	6a 2a                	push   $0x2a
  801cff:	e8 e4 fa ff ff       	call   8017e8 <syscall>
  801d04:	83 c4 18             	add    $0x18,%esp
	return ;
  801d07:	90                   	nop
}
  801d08:	c9                   	leave  
  801d09:	c3                   	ret    

00801d0a <gettst>:
uint32 gettst()
{
  801d0a:	55                   	push   %ebp
  801d0b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d0d:	6a 00                	push   $0x0
  801d0f:	6a 00                	push   $0x0
  801d11:	6a 00                	push   $0x0
  801d13:	6a 00                	push   $0x0
  801d15:	6a 00                	push   $0x0
  801d17:	6a 2b                	push   $0x2b
  801d19:	e8 ca fa ff ff       	call   8017e8 <syscall>
  801d1e:	83 c4 18             	add    $0x18,%esp
}
  801d21:	c9                   	leave  
  801d22:	c3                   	ret    

00801d23 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d23:	55                   	push   %ebp
  801d24:	89 e5                	mov    %esp,%ebp
  801d26:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d29:	6a 00                	push   $0x0
  801d2b:	6a 00                	push   $0x0
  801d2d:	6a 00                	push   $0x0
  801d2f:	6a 00                	push   $0x0
  801d31:	6a 00                	push   $0x0
  801d33:	6a 2c                	push   $0x2c
  801d35:	e8 ae fa ff ff       	call   8017e8 <syscall>
  801d3a:	83 c4 18             	add    $0x18,%esp
  801d3d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d40:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d44:	75 07                	jne    801d4d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d46:	b8 01 00 00 00       	mov    $0x1,%eax
  801d4b:	eb 05                	jmp    801d52 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d4d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d52:	c9                   	leave  
  801d53:	c3                   	ret    

00801d54 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d54:	55                   	push   %ebp
  801d55:	89 e5                	mov    %esp,%ebp
  801d57:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d5a:	6a 00                	push   $0x0
  801d5c:	6a 00                	push   $0x0
  801d5e:	6a 00                	push   $0x0
  801d60:	6a 00                	push   $0x0
  801d62:	6a 00                	push   $0x0
  801d64:	6a 2c                	push   $0x2c
  801d66:	e8 7d fa ff ff       	call   8017e8 <syscall>
  801d6b:	83 c4 18             	add    $0x18,%esp
  801d6e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d71:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d75:	75 07                	jne    801d7e <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d77:	b8 01 00 00 00       	mov    $0x1,%eax
  801d7c:	eb 05                	jmp    801d83 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d7e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d83:	c9                   	leave  
  801d84:	c3                   	ret    

00801d85 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d85:	55                   	push   %ebp
  801d86:	89 e5                	mov    %esp,%ebp
  801d88:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d8b:	6a 00                	push   $0x0
  801d8d:	6a 00                	push   $0x0
  801d8f:	6a 00                	push   $0x0
  801d91:	6a 00                	push   $0x0
  801d93:	6a 00                	push   $0x0
  801d95:	6a 2c                	push   $0x2c
  801d97:	e8 4c fa ff ff       	call   8017e8 <syscall>
  801d9c:	83 c4 18             	add    $0x18,%esp
  801d9f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801da2:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801da6:	75 07                	jne    801daf <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801da8:	b8 01 00 00 00       	mov    $0x1,%eax
  801dad:	eb 05                	jmp    801db4 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801daf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801db4:	c9                   	leave  
  801db5:	c3                   	ret    

00801db6 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801db6:	55                   	push   %ebp
  801db7:	89 e5                	mov    %esp,%ebp
  801db9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dbc:	6a 00                	push   $0x0
  801dbe:	6a 00                	push   $0x0
  801dc0:	6a 00                	push   $0x0
  801dc2:	6a 00                	push   $0x0
  801dc4:	6a 00                	push   $0x0
  801dc6:	6a 2c                	push   $0x2c
  801dc8:	e8 1b fa ff ff       	call   8017e8 <syscall>
  801dcd:	83 c4 18             	add    $0x18,%esp
  801dd0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801dd3:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801dd7:	75 07                	jne    801de0 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801dd9:	b8 01 00 00 00       	mov    $0x1,%eax
  801dde:	eb 05                	jmp    801de5 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801de0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801de5:	c9                   	leave  
  801de6:	c3                   	ret    

00801de7 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801de7:	55                   	push   %ebp
  801de8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801dea:	6a 00                	push   $0x0
  801dec:	6a 00                	push   $0x0
  801dee:	6a 00                	push   $0x0
  801df0:	6a 00                	push   $0x0
  801df2:	ff 75 08             	pushl  0x8(%ebp)
  801df5:	6a 2d                	push   $0x2d
  801df7:	e8 ec f9 ff ff       	call   8017e8 <syscall>
  801dfc:	83 c4 18             	add    $0x18,%esp
	return ;
  801dff:	90                   	nop
}
  801e00:	c9                   	leave  
  801e01:	c3                   	ret    

00801e02 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e02:	55                   	push   %ebp
  801e03:	89 e5                	mov    %esp,%ebp
  801e05:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e06:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e09:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e0c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e12:	6a 00                	push   $0x0
  801e14:	53                   	push   %ebx
  801e15:	51                   	push   %ecx
  801e16:	52                   	push   %edx
  801e17:	50                   	push   %eax
  801e18:	6a 2e                	push   $0x2e
  801e1a:	e8 c9 f9 ff ff       	call   8017e8 <syscall>
  801e1f:	83 c4 18             	add    $0x18,%esp
}
  801e22:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e25:	c9                   	leave  
  801e26:	c3                   	ret    

00801e27 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e27:	55                   	push   %ebp
  801e28:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e30:	6a 00                	push   $0x0
  801e32:	6a 00                	push   $0x0
  801e34:	6a 00                	push   $0x0
  801e36:	52                   	push   %edx
  801e37:	50                   	push   %eax
  801e38:	6a 2f                	push   $0x2f
  801e3a:	e8 a9 f9 ff ff       	call   8017e8 <syscall>
  801e3f:	83 c4 18             	add    $0x18,%esp
}
  801e42:	c9                   	leave  
  801e43:	c3                   	ret    

00801e44 <__udivdi3>:
  801e44:	55                   	push   %ebp
  801e45:	57                   	push   %edi
  801e46:	56                   	push   %esi
  801e47:	53                   	push   %ebx
  801e48:	83 ec 1c             	sub    $0x1c,%esp
  801e4b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801e4f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801e53:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801e57:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801e5b:	89 ca                	mov    %ecx,%edx
  801e5d:	89 f8                	mov    %edi,%eax
  801e5f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801e63:	85 f6                	test   %esi,%esi
  801e65:	75 2d                	jne    801e94 <__udivdi3+0x50>
  801e67:	39 cf                	cmp    %ecx,%edi
  801e69:	77 65                	ja     801ed0 <__udivdi3+0x8c>
  801e6b:	89 fd                	mov    %edi,%ebp
  801e6d:	85 ff                	test   %edi,%edi
  801e6f:	75 0b                	jne    801e7c <__udivdi3+0x38>
  801e71:	b8 01 00 00 00       	mov    $0x1,%eax
  801e76:	31 d2                	xor    %edx,%edx
  801e78:	f7 f7                	div    %edi
  801e7a:	89 c5                	mov    %eax,%ebp
  801e7c:	31 d2                	xor    %edx,%edx
  801e7e:	89 c8                	mov    %ecx,%eax
  801e80:	f7 f5                	div    %ebp
  801e82:	89 c1                	mov    %eax,%ecx
  801e84:	89 d8                	mov    %ebx,%eax
  801e86:	f7 f5                	div    %ebp
  801e88:	89 cf                	mov    %ecx,%edi
  801e8a:	89 fa                	mov    %edi,%edx
  801e8c:	83 c4 1c             	add    $0x1c,%esp
  801e8f:	5b                   	pop    %ebx
  801e90:	5e                   	pop    %esi
  801e91:	5f                   	pop    %edi
  801e92:	5d                   	pop    %ebp
  801e93:	c3                   	ret    
  801e94:	39 ce                	cmp    %ecx,%esi
  801e96:	77 28                	ja     801ec0 <__udivdi3+0x7c>
  801e98:	0f bd fe             	bsr    %esi,%edi
  801e9b:	83 f7 1f             	xor    $0x1f,%edi
  801e9e:	75 40                	jne    801ee0 <__udivdi3+0x9c>
  801ea0:	39 ce                	cmp    %ecx,%esi
  801ea2:	72 0a                	jb     801eae <__udivdi3+0x6a>
  801ea4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801ea8:	0f 87 9e 00 00 00    	ja     801f4c <__udivdi3+0x108>
  801eae:	b8 01 00 00 00       	mov    $0x1,%eax
  801eb3:	89 fa                	mov    %edi,%edx
  801eb5:	83 c4 1c             	add    $0x1c,%esp
  801eb8:	5b                   	pop    %ebx
  801eb9:	5e                   	pop    %esi
  801eba:	5f                   	pop    %edi
  801ebb:	5d                   	pop    %ebp
  801ebc:	c3                   	ret    
  801ebd:	8d 76 00             	lea    0x0(%esi),%esi
  801ec0:	31 ff                	xor    %edi,%edi
  801ec2:	31 c0                	xor    %eax,%eax
  801ec4:	89 fa                	mov    %edi,%edx
  801ec6:	83 c4 1c             	add    $0x1c,%esp
  801ec9:	5b                   	pop    %ebx
  801eca:	5e                   	pop    %esi
  801ecb:	5f                   	pop    %edi
  801ecc:	5d                   	pop    %ebp
  801ecd:	c3                   	ret    
  801ece:	66 90                	xchg   %ax,%ax
  801ed0:	89 d8                	mov    %ebx,%eax
  801ed2:	f7 f7                	div    %edi
  801ed4:	31 ff                	xor    %edi,%edi
  801ed6:	89 fa                	mov    %edi,%edx
  801ed8:	83 c4 1c             	add    $0x1c,%esp
  801edb:	5b                   	pop    %ebx
  801edc:	5e                   	pop    %esi
  801edd:	5f                   	pop    %edi
  801ede:	5d                   	pop    %ebp
  801edf:	c3                   	ret    
  801ee0:	bd 20 00 00 00       	mov    $0x20,%ebp
  801ee5:	89 eb                	mov    %ebp,%ebx
  801ee7:	29 fb                	sub    %edi,%ebx
  801ee9:	89 f9                	mov    %edi,%ecx
  801eeb:	d3 e6                	shl    %cl,%esi
  801eed:	89 c5                	mov    %eax,%ebp
  801eef:	88 d9                	mov    %bl,%cl
  801ef1:	d3 ed                	shr    %cl,%ebp
  801ef3:	89 e9                	mov    %ebp,%ecx
  801ef5:	09 f1                	or     %esi,%ecx
  801ef7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801efb:	89 f9                	mov    %edi,%ecx
  801efd:	d3 e0                	shl    %cl,%eax
  801eff:	89 c5                	mov    %eax,%ebp
  801f01:	89 d6                	mov    %edx,%esi
  801f03:	88 d9                	mov    %bl,%cl
  801f05:	d3 ee                	shr    %cl,%esi
  801f07:	89 f9                	mov    %edi,%ecx
  801f09:	d3 e2                	shl    %cl,%edx
  801f0b:	8b 44 24 08          	mov    0x8(%esp),%eax
  801f0f:	88 d9                	mov    %bl,%cl
  801f11:	d3 e8                	shr    %cl,%eax
  801f13:	09 c2                	or     %eax,%edx
  801f15:	89 d0                	mov    %edx,%eax
  801f17:	89 f2                	mov    %esi,%edx
  801f19:	f7 74 24 0c          	divl   0xc(%esp)
  801f1d:	89 d6                	mov    %edx,%esi
  801f1f:	89 c3                	mov    %eax,%ebx
  801f21:	f7 e5                	mul    %ebp
  801f23:	39 d6                	cmp    %edx,%esi
  801f25:	72 19                	jb     801f40 <__udivdi3+0xfc>
  801f27:	74 0b                	je     801f34 <__udivdi3+0xf0>
  801f29:	89 d8                	mov    %ebx,%eax
  801f2b:	31 ff                	xor    %edi,%edi
  801f2d:	e9 58 ff ff ff       	jmp    801e8a <__udivdi3+0x46>
  801f32:	66 90                	xchg   %ax,%ax
  801f34:	8b 54 24 08          	mov    0x8(%esp),%edx
  801f38:	89 f9                	mov    %edi,%ecx
  801f3a:	d3 e2                	shl    %cl,%edx
  801f3c:	39 c2                	cmp    %eax,%edx
  801f3e:	73 e9                	jae    801f29 <__udivdi3+0xe5>
  801f40:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801f43:	31 ff                	xor    %edi,%edi
  801f45:	e9 40 ff ff ff       	jmp    801e8a <__udivdi3+0x46>
  801f4a:	66 90                	xchg   %ax,%ax
  801f4c:	31 c0                	xor    %eax,%eax
  801f4e:	e9 37 ff ff ff       	jmp    801e8a <__udivdi3+0x46>
  801f53:	90                   	nop

00801f54 <__umoddi3>:
  801f54:	55                   	push   %ebp
  801f55:	57                   	push   %edi
  801f56:	56                   	push   %esi
  801f57:	53                   	push   %ebx
  801f58:	83 ec 1c             	sub    $0x1c,%esp
  801f5b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801f5f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801f63:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801f67:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801f6b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801f6f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801f73:	89 f3                	mov    %esi,%ebx
  801f75:	89 fa                	mov    %edi,%edx
  801f77:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801f7b:	89 34 24             	mov    %esi,(%esp)
  801f7e:	85 c0                	test   %eax,%eax
  801f80:	75 1a                	jne    801f9c <__umoddi3+0x48>
  801f82:	39 f7                	cmp    %esi,%edi
  801f84:	0f 86 a2 00 00 00    	jbe    80202c <__umoddi3+0xd8>
  801f8a:	89 c8                	mov    %ecx,%eax
  801f8c:	89 f2                	mov    %esi,%edx
  801f8e:	f7 f7                	div    %edi
  801f90:	89 d0                	mov    %edx,%eax
  801f92:	31 d2                	xor    %edx,%edx
  801f94:	83 c4 1c             	add    $0x1c,%esp
  801f97:	5b                   	pop    %ebx
  801f98:	5e                   	pop    %esi
  801f99:	5f                   	pop    %edi
  801f9a:	5d                   	pop    %ebp
  801f9b:	c3                   	ret    
  801f9c:	39 f0                	cmp    %esi,%eax
  801f9e:	0f 87 ac 00 00 00    	ja     802050 <__umoddi3+0xfc>
  801fa4:	0f bd e8             	bsr    %eax,%ebp
  801fa7:	83 f5 1f             	xor    $0x1f,%ebp
  801faa:	0f 84 ac 00 00 00    	je     80205c <__umoddi3+0x108>
  801fb0:	bf 20 00 00 00       	mov    $0x20,%edi
  801fb5:	29 ef                	sub    %ebp,%edi
  801fb7:	89 fe                	mov    %edi,%esi
  801fb9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801fbd:	89 e9                	mov    %ebp,%ecx
  801fbf:	d3 e0                	shl    %cl,%eax
  801fc1:	89 d7                	mov    %edx,%edi
  801fc3:	89 f1                	mov    %esi,%ecx
  801fc5:	d3 ef                	shr    %cl,%edi
  801fc7:	09 c7                	or     %eax,%edi
  801fc9:	89 e9                	mov    %ebp,%ecx
  801fcb:	d3 e2                	shl    %cl,%edx
  801fcd:	89 14 24             	mov    %edx,(%esp)
  801fd0:	89 d8                	mov    %ebx,%eax
  801fd2:	d3 e0                	shl    %cl,%eax
  801fd4:	89 c2                	mov    %eax,%edx
  801fd6:	8b 44 24 08          	mov    0x8(%esp),%eax
  801fda:	d3 e0                	shl    %cl,%eax
  801fdc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fe0:	8b 44 24 08          	mov    0x8(%esp),%eax
  801fe4:	89 f1                	mov    %esi,%ecx
  801fe6:	d3 e8                	shr    %cl,%eax
  801fe8:	09 d0                	or     %edx,%eax
  801fea:	d3 eb                	shr    %cl,%ebx
  801fec:	89 da                	mov    %ebx,%edx
  801fee:	f7 f7                	div    %edi
  801ff0:	89 d3                	mov    %edx,%ebx
  801ff2:	f7 24 24             	mull   (%esp)
  801ff5:	89 c6                	mov    %eax,%esi
  801ff7:	89 d1                	mov    %edx,%ecx
  801ff9:	39 d3                	cmp    %edx,%ebx
  801ffb:	0f 82 87 00 00 00    	jb     802088 <__umoddi3+0x134>
  802001:	0f 84 91 00 00 00    	je     802098 <__umoddi3+0x144>
  802007:	8b 54 24 04          	mov    0x4(%esp),%edx
  80200b:	29 f2                	sub    %esi,%edx
  80200d:	19 cb                	sbb    %ecx,%ebx
  80200f:	89 d8                	mov    %ebx,%eax
  802011:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802015:	d3 e0                	shl    %cl,%eax
  802017:	89 e9                	mov    %ebp,%ecx
  802019:	d3 ea                	shr    %cl,%edx
  80201b:	09 d0                	or     %edx,%eax
  80201d:	89 e9                	mov    %ebp,%ecx
  80201f:	d3 eb                	shr    %cl,%ebx
  802021:	89 da                	mov    %ebx,%edx
  802023:	83 c4 1c             	add    $0x1c,%esp
  802026:	5b                   	pop    %ebx
  802027:	5e                   	pop    %esi
  802028:	5f                   	pop    %edi
  802029:	5d                   	pop    %ebp
  80202a:	c3                   	ret    
  80202b:	90                   	nop
  80202c:	89 fd                	mov    %edi,%ebp
  80202e:	85 ff                	test   %edi,%edi
  802030:	75 0b                	jne    80203d <__umoddi3+0xe9>
  802032:	b8 01 00 00 00       	mov    $0x1,%eax
  802037:	31 d2                	xor    %edx,%edx
  802039:	f7 f7                	div    %edi
  80203b:	89 c5                	mov    %eax,%ebp
  80203d:	89 f0                	mov    %esi,%eax
  80203f:	31 d2                	xor    %edx,%edx
  802041:	f7 f5                	div    %ebp
  802043:	89 c8                	mov    %ecx,%eax
  802045:	f7 f5                	div    %ebp
  802047:	89 d0                	mov    %edx,%eax
  802049:	e9 44 ff ff ff       	jmp    801f92 <__umoddi3+0x3e>
  80204e:	66 90                	xchg   %ax,%ax
  802050:	89 c8                	mov    %ecx,%eax
  802052:	89 f2                	mov    %esi,%edx
  802054:	83 c4 1c             	add    $0x1c,%esp
  802057:	5b                   	pop    %ebx
  802058:	5e                   	pop    %esi
  802059:	5f                   	pop    %edi
  80205a:	5d                   	pop    %ebp
  80205b:	c3                   	ret    
  80205c:	3b 04 24             	cmp    (%esp),%eax
  80205f:	72 06                	jb     802067 <__umoddi3+0x113>
  802061:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802065:	77 0f                	ja     802076 <__umoddi3+0x122>
  802067:	89 f2                	mov    %esi,%edx
  802069:	29 f9                	sub    %edi,%ecx
  80206b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80206f:	89 14 24             	mov    %edx,(%esp)
  802072:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802076:	8b 44 24 04          	mov    0x4(%esp),%eax
  80207a:	8b 14 24             	mov    (%esp),%edx
  80207d:	83 c4 1c             	add    $0x1c,%esp
  802080:	5b                   	pop    %ebx
  802081:	5e                   	pop    %esi
  802082:	5f                   	pop    %edi
  802083:	5d                   	pop    %ebp
  802084:	c3                   	ret    
  802085:	8d 76 00             	lea    0x0(%esi),%esi
  802088:	2b 04 24             	sub    (%esp),%eax
  80208b:	19 fa                	sbb    %edi,%edx
  80208d:	89 d1                	mov    %edx,%ecx
  80208f:	89 c6                	mov    %eax,%esi
  802091:	e9 71 ff ff ff       	jmp    802007 <__umoddi3+0xb3>
  802096:	66 90                	xchg   %ax,%ax
  802098:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80209c:	72 ea                	jb     802088 <__umoddi3+0x134>
  80209e:	89 d9                	mov    %ebx,%ecx
  8020a0:	e9 62 ff ff ff       	jmp    802007 <__umoddi3+0xb3>