// SPDX-License-Identifier: GPL-2.0-only
/* Copyright (c) 2011-2021, The Linux Foundation. All rights reserved.
 */

#ifndef _WCD9XXX_H
#define _WCD9XXX_H

#include <linux/regmap.h>
#include <linux/slimbus.h>
#include <asoc/core.h>  // Include the core header for wcd9xxx structure
#include <asoc/pdata.h> // Include the pdata header for wcd9xxx_pdata structure

int wcd9xxx_vote_ondemand_regulator(struct wcd9xxx *wcd9xxx,
                                    struct wcd9xxx_pdata *pdata,
                                    const char *supply_name,
                                    bool enable);

#endif /* _WCD9XXX_H */
