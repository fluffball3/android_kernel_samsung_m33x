.. SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note

==================
DebugFS interface
==================

**Copyright:** \(C) 2022-2024 ARM Limited. All rights reserved.
..
    This program is free software and is provided to you under the terms of the
    GNU General Public License version 2 as published by the Free Software
    Foundation, and any use by you of this program is subject to the terms
    of such GNU license.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, you can access it online at
    http://www.gnu.org/licenses/gpl-2.0.html.

A new per-kbase-context debugfs file called csf_sync has been implemented
which captures the current KCPU & GPU queue state of the not-yet-completed
operations and displayed through the debugfs file.
This file is at

::

        /sys/kernel/debug/mali0/ctx/<pid>_<context id>/csf_sync


Output Format
-------------

The csf_sync file contains important data for the currently active queues.
This data is formatted into two segments, which are separated by a
pipe character: the common properties and the operation-specific properties.

Common Properties
-----------------

* Queue type: GPU or KCPU.
* kbase context id and the queue id.
* If the queue type is a GPU queue then the group handle is also noted,in the middle of the other two IDs. The slot value is also dumped.
* Execution status, which can either be 'P' for pending or 'S' for started.
* Command type is then output which indicates the type of dependency (i.e. wait or signal).
* Object address which is a pointer to the sync object that the command operates on.

* The live value, which is the value of the synchronization object at the time of dumping. This could help to determine why wait operations might be blocked.

Operation-Specific Properties
------------------------------

The operation-specific values for KCPU queue fence operations
are as follows: a unique timeline name, timeline context, and a fence
sequence number. The CQS WAIT and CQS SET are denoted in the sync dump
as their OPERATION counterparts, and therefore show the same operation
specific values; the argument value to wait on or set to, and operation type,
being (by definition) op:gt and op:set for CQS_WAIT and CQS_SET respectively.

There are only two operation-specific values for operations in GPU queues
which are always shown; the argument value to wait on or set/add to,
and the operation type (set/add) or wait condition (e.g. LE, GT, GE).

Examples
========

GPU Queue Example
------------------

The following output is of a GPU queue, from a process that has a KCTX ID of 52,
is in Queue Group (CSG) 0, and has Queue ID 0. It has started and is waiting on
the object at address **0x0000007f81ffc800**. The live value is 0,
as is the arg value. However, the operation "op" is GT, indicating it's waiting
for the live value to surpass the arg value:

::

        queue:GPU-52-0-0 exec:S cmd:SYNC_WAIT slot:4 obj:0x0000007f81ffc800 live_value:0x0000000000000000 | op:gt arg_value:0x0000000000000000

The following is an example of GPU queue dump, where the SYNC SET operation
is blocked by the preceding SYNC WAIT operation. This shows two GPU queues,
with the same KCTX ID of 8, Queue Group (CSG) 0, and Queue ID 0. The SYNC WAIT
operation has started, while the SYNC SET is pending, blocked by the SYNC WAIT.
Both operations are on the same slot, 2 and have live value of 0. The SYNC WAIT
is waiting on the object at address **0x0000007f81ffc800**, while the SYNC SET will
set the object at address **0x00000000a3bad4fb** when it is unblocked.
The operation "op" is GT for the SYNC WAIT, indicating it's waiting for the
live value to surpass the arg value, while the operation and arg value for the
SYNC SET is "set" and "1" respectively.

::

        queue:GPU-8-0-0 exec:S cmd:SYNC_WAIT slot:2 obj:0x0000007f81ffc800 live_value:0x0000000000000000 | op:gt arg_value:0x0000000000000000
        queue:GPU-8-0-0 exec:P cmd:SYNC_SET slot:2 obj:0x00000000a3bad4fb live_value:0x0000000000000000 | op:set arg_value:0x0000000000000001

KCPU Queue Example
------------------

The following is an example of a KCPU queue, from a process that has
a KCTX ID of 0 and has Queue ID 1. It has started and is waiting on the
object at address **0x0000007fbf6f2ff8**. The live value is currently 0 with
the "op" being GT indicating it is waiting on the live value to
surpass the arg value.

::

        queue:KCPU-0-1 exec:S cmd:CQS_WAIT_OPERATION obj:0x0000007fbf6f2ff8 live_value:0x0000000000000000 | op:gt arg_value: 0x00000000

CSF Sync State Dump For Fence Signal Timeouts
---------------------------------------------

Summary
-------
A timer has been added to the KCPU queues which is checked to ensure
the queues have not "timed out" between the enqueuing of a fence signal command
and it's eventual execution. If this timeout happens then the CSF sync state
of all KCPU queues of the offending context is dumped. This feature is enabled
by default, but can be disabled/enabled later.

Explanation
------------
This new timer is created and destroyed alongside the creation and destruction
of each KCPU queue. It is started when a fence signal is enqueued, and cancelled
when the fence signal command has been processed. The timer times out after
10 seconds (at 100 MHz) if the execution of that fence signal event was never
processed. If this timeout occurs then the timer callback function identifies
the KCPU queue which the timer belongs to and invokes the CSF synchronisation
state dump mechanism, writing the sync state for the context of the queue
causing the timeout is dump to dmesg.

Fence Timeouts Controls
-----------------------
Disable/Enable Feature
----------------------
This feature is enabled by default, but can be disabled/ re-enabled via DebugFS
controls. The 'fence_signal_timeout_enable' debugfs entry is a global flag
which is written to, to turn this feature on and off.

Example:
--------
when writing to fence_signal_timeout_enable entry

::

        echo 1 > /sys/kernel/debug/mali0/fence_signal_timeout_enable -> feature is enabled.
        echo 0 > /sys/kernel/debug/mali0/fence_signal_timeout_enable -> feature is disabled.

It is also possible to read from this file to check if the feature is currently
enabled or not checking the return value of fence_signal_timeout_enable.

Example:
--------
when reading from fence_signal_timeout_enable entry, if
::

        cat /sys/kernel/debug/mali0/fence_signal_timeout_enable returns 1 -> feature is enabled.
        cat /sys/kernel/debug/mali0/fence_signal_timeout_enable returns 0 -> feature is disabled.

Update Timer Duration
---------------------
The timeout duration can be accessed through the 'fence_signal_timeout_ms'
debugfs entry. This can be read from to retrieve the current time in
milliseconds.

Example:
--------
::

        cat /sys/kernel/debug/mali0/fence_signal_timeout_ms

The 'fence_signal_timeout_ms' debugfs entry can also be written to, to update
the time in milliseconds.

Example:
--------
::

        echo 10000 > /sys/kernel/debug/mali0/fence_signal_timeout_ms
