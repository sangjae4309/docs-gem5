Running SE mode
==============================================

gem5 standard library (stlib)
------------------------------------------------

- The gem5.stdlib framework is similar to assembling a PC: each component—CPU, cache, memory, etc
- Those components are encapsulated as a modular Python class

.. code-block:: python
    
    import os
    import argparse
    from gem5.isas import ISA
    from gem5.utils.requires import requires
    from gem5.resources.resource import CustomResource
    from gem5.components.cachehierarchies.classic\
        .private_l1_private_l2_cache_hierarchy import (
        PrivateL1PrivateL2CacheHierarchy,
    )
    from gem5.components.processors.cpu_types import CPUTypes
    from gem5.components.boards.x86_board import X86Board
    from gem5.components.boards.simple_board import SimpleBoard
    from gem5.components.processors.simple_processor import SimpleProcessor
    from gem5.simulate.simulator import Simulator
    from gem5.simulate.exit_event import ExitEvent
    from m5.util import fatal

    cache_hierarchy = PrivateL1PrivateL2CacheHierarchy(
        l1d_size="16kB",
        l1i_size="16kB",
        l2_size="256kB",
    )
    memory = SingleChannelDDR4_2400(size="3GB")
    processor = SimpleProcessor(
        cpu_type=CPUTypes.TIMING,
        isa=ISA.X86,
        num_cores=1
    )
    board = SimpleBoard(
        clk_freq = "3GHz",
        processor = processor,
        memory = memory,
        cache_hierarchy = cache_hierarchy,
    )
    board.set_se_binary_workload(
        CustomResource(
            os.path.join(
                os.getcwd(), "{path to your program}"
            )
        )
    )
    simulator = Simulator(board=board)
    simulator.run()

- Just execute the script via ``gem5.opt``

.. code-block:: bash

    cd gem5
    build/X86/gem5.opt <path-to-stdlib-script>.py



Running multiple program
------------------------------------------------
- The stdlib framework supports easily configurable multi-core systems and assign separate workloads to each core
- Assume that the binary files ``x86-matrix-multiply`` and ``x86-print-this`` exist as local files

.. code-block:: python

    board.set_se_multi_binary_workload(
        binaries=[Workload("x86-print-this"),
                Workload("x86-print-this"),
                Workload("x86-matrix-multiply"),
                Workload("x86-matrix-multiply"),
                ],
        arguments=[[f"Hello World!! 1", 1],
                   [f"Hello World!! 2", 1],
                   [],
                   [],
                   ],
    )