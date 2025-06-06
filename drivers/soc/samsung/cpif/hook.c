// SPDX-License-Identifier: GPL-2.0
/*
 * tracepoint hook handling
 *
 * Copyright (C) 2021 Samsung Electronics Co., Ltd
 *
 */

#include <trace/hooks/sched.h>
#include "../../../kernel/sched/sched.h"

#define TASK_VENDOR 0x2000

int hook_init(void)
{
	return 0;
}
EXPORT_SYMBOL(hook_init);

MODULE_LICENSE("GPL");
MODULE_DESCRIPTION("Samsung CPIF vendor hook driver");
