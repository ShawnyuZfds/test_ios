/*
 * Copyright (c) 2011 - 2016, Apinauten GmbH
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, 
 * are permitted provided that the following conditions are met:
 *
 *  * Redistributions of source code must retain the above copyright notice, this 
 *    list of conditions and the following disclaimer.
 *  * Redistributions in binary form must reproduce the above copyright notice, 
 *    this list of conditions and the following disclaimer in the documentation 
 *    and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. 
 * IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, 
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 * BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, 
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF 
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE 
 * OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED 
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * THIS FILE IS GENERATED AUTOMATICALLY. DON'T MODIFY IT.
 */

#import "AOMRequest.h"

@implementation AOMRequest
@synthesize  expectedCodes, httpBody, httpMehod, isBinaryData, responseBlock, url, storeInCache, useDeltaSync, addtionalHeaders, useAuthorization, processResponse;

- (id) initWithURL:(NSString*)_url httpMethod:(NSString*)_httpMethod expectedCodes:(NSArray*) _exptectedCodes responseBlock:(AOMResponseDataBlock) _responseBlock
{
    if (self = [super init])
    {
        self.url = _url;
        self.httpMehod = _httpMethod;
        self.expectedCodes = _exptectedCodes;
        self.responseBlock = _responseBlock;
        self.isBinaryData = FALSE;
        self.storeInCache = FALSE;
        self.useAuthorization = TRUE;
        self.processResponse = TRUE;
    }
    return self;
}

- (id) initWithURL:(NSString*)_url httpMethod:(NSString*)_httpMethod expectedCode:(NSInteger) _exptectedCode responseBlock:(AOMResponseDataBlock) _responseBlock
{
    return [self initWithURL:_url httpMethod:_httpMethod expectedCodes:[NSArray arrayWithObject:[NSNumber numberWithInteger:_exptectedCode ]] responseBlock:_responseBlock];
}
@end
