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
@class AOMAbstractClientDataModel;
@class AOMURLConnection;
@class AOMTokenContainer;

FOUNDATION_EXPORT NSString * const ApiomatRequestException;
FOUNDATION_EXPORT NSString * const EmptyHrefException;
FOUNDATION_EXPORT NSString * const AOM_SSO_REDIRECT_URL;
FOUNDATION_EXPORT NSString * const AOM_SSO_REDIRECT_DATA;

/*!
 Defines block for HTTP responses from ApiOmat backend.
 
 @param error If HTTP request throws an error then you can find them in this parameter
 */
typedef void (^AOMEmptyBlock)(NSError *error);
/*!
 Defines block for HTTP POST responses from ApiOmat backend.
 
 @param href Contains HREF of new created class instance
 @param error If HTTP request throws an error then you can find them in this parameter else Nil
 */
typedef void (^AOMBlockWithHref)(NSString* href, NSError *error);
/*!
 Defines block for HTTP GET responses from ApiOmat backend.
 
 @param model Contains returned class instance
 @param error If HTTP request throws an error then you can find them in this parameter else Nil
 */
typedef void (^AOMBlockWithResult)(AOMAbstractClientDataModel* model, NSError *error);
/*!
 Defines block for HTTP GET responses from ApiOmat backend.
 
 @param models Contains list returned class instances
 @param error If HTTP request throws an error then you can find them in this parameter else Nil
 */
typedef void (^AOMBlockWithResults)(NSMutableArray* models, NSError *error);

/*!
 Defines block for HTTP GET response from ApiOmat backend with binary data.
 
 @param data Contains NSData
 @param error If HTTP request throws an error then you can find them in this parameter else Nil
 */
typedef void (^AOMBlockWithNSDataResults)(NSData* data, NSError *error);

/*!
 Defines block for HTTP count response from ApiOmat backend.
 
 @param long Contains NSData]
 @param error If HTTP request throws an error then you can find them in this parameter else Nil
 */
typedef void (^AOMBlockWithLongResults)(long count, NSError *error);

typedef void (^AOMResponseDataBlock)(NSData* responseBlock, NSError *error);

typedef void (^AOMResponseSessionBlock)(AOMTokenContainer* sessionData, NSError *error);

typedef void (^ CompleteBlock)(AOMURLConnection* connection);

/* Enum which contains options for caching strategy of HTTP requests */
typedef enum {
    AOM_NETWORK_ONLY = NSURLRequestReloadIgnoringLocalCacheData, // Dont use caching (save and read)
    AOM_NETWORK_ELSE_CACHE = NSURLRequestUseProtocolCachePolicy,  // Use the cache only if the server is unreachable or returned 304
    AOM_CACHE_ELSE_NETWORK = NSURLRequestReturnCacheDataElseLoad,  // Check first cache, else load from network
    AOM_CACHE_THEN_NETWORK = 100 // First read from cache, than send request to server
} AOMCacheStrategy;
