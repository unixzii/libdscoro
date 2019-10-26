//
//  ctx_x86_64.h
//  libdscoro
//
//  Created by Hongyu on 10/26/19.
//  Copyright © 2019 Cyandev. All rights reserved.
//

#ifndef ctx_x86_h
#define ctx_x86_h

#ifdef __x86_64__

struct dsco_ctx_x86_64 {
    void *rip;
    void *rsp;
    void *rbp;
    /* General purpose */
    void *rbx;
    void *rdi;
    void *rsi;
    void *r8;
    void *r9;
    void *r10;
    void *r11;
    void *r12;
    void *r13;
    void *r14;
    void *r15;
};
typedef struct dsco_ctx_x86_64 dsco_ctx_t;

#endif

#endif /* ctx_x86_h */
