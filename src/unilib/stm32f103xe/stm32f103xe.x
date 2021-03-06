   /* Entry Point */
   ENTRY(reset_addr)

   /* Specify the memory areas */
   MEMORY
   {
	FLASH (rx)	: ORIGIN = 0x08000000, LENGTH = 0x080000 /* 512 K */
	RAM (rwx)	: ORIGIN = 0x20000000, LENGTH = 0x010000 /* 64 K */
   }

   /* define stack size and heap size here */
   stack_size = 1024;
   heap_size = 256;

   /* define beginning and ending of stack */
   _stack_start = ORIGIN(RAM)+LENGTH(RAM);
   _stack_end = _stack_start - stack_size;

   /* Define output sections */
   SECTIONS
   {
     .text :
     {
       . = ALIGN(4);
       *(.startup)	  /* .startup section */
       *(.text)           /* .text sections (code) */
       *(.text*)          /* .text* sections (code) */
       *(.libs)          /* .libs sections (code) */
       *(.rodata)         /* .rodata sections (constants, strings, etc.) */
       *(.rodata*)        /* .rodata* sections (constants, strings, etc.) */
       . = ALIGN(4);
       _etext = .;        /* define a global symbols at end of code */
     } >FLASH

      .ARM.extab   : { *(.ARM.extab* .gnu.linkonce.armextab.*) } >FLASH
       .ARM : {
       __exidx_start = .;
         *(.ARM.exidx*)
         __exidx_end = .;
       } >FLASH

     /* used by the startup to initialize data */
     _sidata = .;

     /* Initialized data sections goes into RAM, load LMA copy after code */
     .data : AT ( _sidata )
     {
       . = ALIGN(4);
       _sdata = .;        /* create a global symbol at data start */
       *(.data)           /* .data sections */
       *(.data*)          /* .data* sections */

       . = ALIGN(4);
       _edata = .;        /* define a global symbol at data end */
     } >RAM

     /* Uninitialized data section */
     . = ALIGN(4);
     .bss :
     {
       /*  Used by the startup in order to initialize the .bss secion */
       _sbss = .;         /* define a global symbol at bss start */
       __bss_start__ = _sbss;
       *(.bss)
       *(.bss*)
       *(COMMON)

       . = ALIGN(4);
       _ebss = .;         /* define a global symbol at bss end */
       __bss_end__ = _ebss;
     } >RAM

       . = ALIGN(4);
       .heap :
       {
           _heap_start = .;
           . = . + heap_size;
                   _heap_end = .;
       } > RAM

       .ARM.attributes 0 : { *(.ARM.attributes) }
   }
