/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
/*
 *
 * (C) COPYRIGHT 2014-2017, 2020-2022 ARM Limited. All rights reserved.
 *
 * This program is free software and is provided to you under the terms of the
 * GNU General Public License version 2 as published by the Free Software
 * Foundation, and any use by you of this program is subject to the terms
 * of such GNU license.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, you can access it online at
 * http://www.gnu.org/licenses/gpl-2.0.html.
 *
 */

#ifndef _MALI_KBASE_CONFIG_PLATFORM_H_
#define _MALI_KBASE_CONFIG_PLATFORM_H_

#include "mali_exynos_kbase_entrypoint.h"

/**
 * POWER_MANAGEMENT_CALLBACKS - Power management configuration
 *
 * Attached value: pointer to @ref kbase_pm_callback_conf
 * Default value: See @ref kbase_pm_callback_conf
 */
#if IS_ENABLED(CONFIG_MALI_EXYNOS_RTPM)
#define POWER_MANAGEMENT_CALLBACKS (&pm_callbacks)
#else
#define POWER_MANAGEMENT_CALLBACKS (NULL)
#endif

/**
 * PLATFORM_FUNCS - Platform specific configuration functions
 *
 * Attached value: pointer to @ref kbase_platform_funcs_conf
 * Default value: See @ref kbase_platform_funcs_conf
 */
/* MALI_SEC_INTEGRATION */
#define PLATFORM_FUNCS (&platform_funcs)

#define CLK_RATE_TRACE_OPS (&clk_rate_trace_ops)

extern struct kbase_pm_callback_conf pm_callbacks;
extern struct kbase_clk_rate_trace_op_conf clk_rate_trace_ops;
/**
 * AUTO_SUSPEND_DELAY - Autosuspend delay
 *
 * The delay time (in milliseconds) to be used for autosuspend
 */

#if IS_ENABLED(CONFIG_MALI_EXYNOS_SECURE_RENDERING_LEGACY) ||                                      \
	IS_ENABLED(CONFIG_MALI_EXYNOS_SECURE_RENDERING_ARM)
#define PLATFORM_PROTECTED_CALLBACKS mali_exynos_get_protected_ops()
#endif

extern struct kbase_platform_funcs_conf platform_funcs;

#endif /* _MALI_KBASE_CONFIG_PLATFORM_H_ */

#define AUTO_SUSPEND_DELAY (100)
