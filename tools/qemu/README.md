
qemu 0.10 for X86 on Linux.

Built from [Linux Lab](https://github.com/tinyclub/linux-lab)

    $ vim machines/pc/Makefile  // uncomment the following line
    QEMU = 0.10

    $ make B=pc
    $ make qemu
