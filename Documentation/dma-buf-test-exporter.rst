..  SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note

=====================
dma-buf-test-exporter
=====================

**Copyright:** \(C) 2012-2013, 2020-2022, 2024 ARM Limited. All rights reserved.

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

Overview
--------

The dma-buf-test-exporter is a simple exporter of dma_buf objects.
It has a private API to allocate and manipulate the buffers which are represented as dma_buf fds.
The private API allows:

* simple allocation of physically non-contiguous buffers
* simple allocation of physically contiguous buffers
* query kernel side API usage stats (number of attachments, number of mappings, mmaps)
* failure mode configuration (fail attach, mapping, mmap)
* kernel side memset of buffers

The buffers support all of the dma_buf API, including mmap.

It supports being compiled as a module both in-tree and out-of-tree.

See **include/uapi/base/arm/dma_buf_test_exporter/dma-buf-test-exporter.h** for the ioctl interface.
See **Documentation/dma-buf-sharing.txt** for details on dma_buf.
