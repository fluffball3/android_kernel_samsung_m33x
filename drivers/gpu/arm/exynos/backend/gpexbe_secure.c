/* SPDX-License-Identifier: GPL-2.0 */

/*
 * (C) COPYRIGHT 2021 Samsung Electronics Inc. All rights reserved.
 *
 * This program is free software and is provided to you under the terms of the
 * GNU General Public License version 2 as published by the Free Software
 * Foundation, and any use by you of this program is subject to the terms
 * of such GNU licence.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, you can access it online at
 * http://www.gnu.org/licenses/gpl-2.0.html.
 */

/* Implements */
#include <gpexbe_secure.h>

#ifdef CONFIG_MALI_DDK_VALHALL_R53P0
#include "../../bv_r53p0/mali_kbase_hwaccess_pm.h"
#include <linux/mali_drivers/bv_r53p0/protected_mode_switcher.h>
#endif
#ifdef CONFIG_MALI_DDK_VALHALL_R49P3
#include "../../bv_r49p3/mali_kbase_hwaccess_pm.h"
#include <linux/mali_drivers/bv_r49p3/protected_mode_switcher.h>
#endif

/* Uses */
#include <mali_kbase.h>

#ifndef CONFIG_MALI_DDK_VALHALL_R53P0
#ifndef CONFIG_MALI_DDK_VALHALL_R49P3
#include <linux/protected_mode_switcher.h>
#endif
#endif

#include <gpex_utils.h>
#include <gpexbe_smc_hvc.h>

static int exynos_secure_mode_enable(struct protected_mode_device *pdev)
{
	int ret = 0;

	if (!pdev)
		return -EINVAL;

	ret = kbase_pm_protected_mode_enable(pdev->data);
	if (ret != 0)
		return ret;

	return gpexbe_smc_hvc_protection_enable();
}

static int exynos_secure_mode_disable(struct protected_mode_device *pdev)
{
	int ret = 0;

	if (!pdev)
		return -EINVAL;

	ret = kbase_pm_protected_mode_disable(pdev->data);
	if (ret != 0)
		return ret;

	return gpexbe_smc_hvc_protection_disable();
}

struct protected_mode_ops *gpexbe_secure_get_protected_mode_ops(void)
{
	static struct protected_mode_ops exynos_protected_ops = {
		.protected_mode_enable = &exynos_secure_mode_enable,
		.protected_mode_disable = &exynos_secure_mode_disable
	};

	return &exynos_protected_ops;
}

int gpexbe_secure_legacy_jm_enter_protected_mode(struct kbase_device *kbdev)
{
	return -ENOSYS;
}

int gpexbe_secure_legacy_jm_exit_protected_mode(struct kbase_device *kbdev)
{
	return -ENOSYS;
}

int gpexbe_secure_legacy_pm_exit_protected_mode(struct kbase_device *kbdev)
{
	return -ENOSYS;
}
