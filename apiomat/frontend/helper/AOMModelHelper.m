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
#import "AOMModelHelper.h"
#import "AOMDatastore.h"

@implementation AOMModelHelper
+ (BOOL) containsList:(NSArray*) _list thisHref:(NSString*) _href
{
   return [[AOMModelHelper getElementsFromList:_list ByHref:_href] count] > 0;
}

+ (NSArray*) getElementsFromList:(NSArray*) _list ByHref:(NSString*) _href
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"href == %@", _href];
    return [_list filteredArrayUsingPredicate:predicate];
}

+ (void) updateHref:(NSString*) _href forModel:(AOMAbstractClientDataModel*)_model
{
    [[_model data] setObject:_href forKey:@"href"];
    [_model setValue:_href forKey:@"href"];
}

+ (NSString*) getResourceURL:(NSString*) url WithSuffix:(NSString*)_suffix
{
    return [url stringByAppendingFormat:@"%@?apiKey=%@&system=%@", _suffix, [[AOMDatastore sharedInstance] apiKey],[[AOMDatastore sharedInstance] usedSystem]];
}
+ (NSString*) createReferenceURL:(AOMAbstractClientDataModel*)_model ReferenceName:(NSString*)_referenceName
{
    NSString *refUrl = [[_model getHref] stringByAppendingPathComponent:_referenceName];
    return refUrl;
}

+ (NSString*) getIDFromHref:(NSString*)_href
{
    NSURL *url = [NSURL URLWithString:[_href lastPathComponent]];
    return [url lastPathComponent];
}

+ (NSInteger) hashOfModels:(NSArray*) _models
{
    NSInteger collHash = [_models hash];
    for (AOMAbstractClientDataModel *model in _models) {
        collHash += [model hash];
    }
    return collHash;
}
@end
