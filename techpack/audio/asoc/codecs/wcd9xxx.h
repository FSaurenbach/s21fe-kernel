// SPDX-License-Identifier: GPL-2.0-only
/* Copyright (c) 2011-2021, The Linux Foundation. All rights reserved.
 */

 #ifndef _WCD9XXX_H
 #define _WCD9XXX_H
 
 #include <linux/regmap.h>
 #include <linux/slimbus.h>
 
 struct wcd9xxx {
     struct device *dev;
     struct regmap *regmap;
     struct slim_device *slim;
     struct mutex io_lock;
     struct mutex xfer_lock;
     struct mutex reset_lock;
     bool dev_up;
     int (*read_dev)(struct wcd9xxx *wcd9xxx, unsigned short reg,
             int bytes, void *dest, bool interface);
     int (*write_dev)(struct wcd9xxx *wcd9xxx, unsigned short reg,
             int bytes, void *src, bool interface);
     int num_of_supplies;
     struct regulator_bulk_data *supplies;
     struct wcd9xxx_pdata *pdata;
     struct notifier_block nblock;
     struct wcd9xxx_codec_type *codec_type;
     u8 type;
     u8 version;
     u16 reset_gpio;
     u8 mclk_rate;
     u8 wcd_rst_np;
     struct wcd9xxx_core_resource core_res;
     struct wcd9xxx_slim_slave_info *slim_slave;
 };
 
 struct wcd9xxx_pdata {
     int num_supplies;
     struct regulator_init_data *regulator;
     struct regulator_init_data *vote_regulator_on_demand;
     struct device_node *wcd_rst_np;
     int reset_gpio;
 };
 
 int wcd9xxx_vote_ondemand_regulator(struct wcd9xxx *wcd9xxx,
                     struct wcd9xxx_pdata *pdata,
                     const char *supply_name,
                     bool enable);
 
 #endif /* _WCD9XXX_H */