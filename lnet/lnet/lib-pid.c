/* -*- mode: c; c-basic-offset: 8; indent-tabs-mode: nil; -*-
 * vim:expandtab:shiftwidth=8:tabstop=8:
 *
 * lib/lib-pid.c
 *
 * Process identification routines
 * Copyright (C) 2001-2003 Cluster File Systems, Inc.
 *
 *   This file is part of Lustre, http://www.lustre.org
 *
 *   Lustre is free software; you can redistribute it and/or
 *   modify it under the terms of version 2 of the GNU General Public
 *   License as published by the Free Software Foundation.
 *
 *   Lustre is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with Lustre; if not, write to the Free Software
 *   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */

/* This should be removed.  The NAL should have the PID information */
#define DEBUG_SUBSYSTEM S_PORTALS

#if defined (__KERNEL__)
extern int getpid(void);
#else
#       include <stdio.h>
#       include <unistd.h>
#endif
#include <portals/lib-p30.h>

int
lib_api_get_id(nal_t *apinal, ptl_process_id_t *pid)
{
        lib_nal_t *nal = apinal->nal_data;
        
        *pid = nal->libnal_ni.ni_pid;
        return PTL_OK;
}
