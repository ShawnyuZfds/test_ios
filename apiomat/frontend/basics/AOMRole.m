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
#import "AOMRole.h"
#import "AOMDatastore.h"
#import "AOMModelStore.h"
#import "AOMModelHelper.h"
#import "NSString+Extensions.h"
#import "AOMTokenContainer.h"
/*
* Generated class for Role
*/
@implementation AOMRole

static BOOL storeOffline = FALSE;

- (void) initAttributes {
    [super initAttributes];
}
- (id) init {
    self = [super init];
    if (self) {
        [self initAttributes];
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initAttributes];
    }
    return self;
}


     + (NSString*)getSimpleName    {
        return @"Role";
    }
    + (NSString*)getModuleName    {
        return @"Basics";
    }

+ (NSMutableArray*)getWithQuery:(NSString*) _query{
    return [[AOMDatastore sharedInstance] loadListFromServerWithClass:[AOMRole class] andQuery:_query];
}
+ (void)getAsyncWithQuery:(NSString*) _query withBlock:(AOMBlockWithResults) _block{
    [[AOMDatastore sharedInstance] loadListFromServerAsyncWithClass:[AOMRole class] andQuery:_query andFinishingBlock:_block andStoreOffline:[AOMRole storeOffline]];
}
+ (void)getAsyncWithQuery:(NSString*) _query withBlock:(AOMBlockWithResults) _block andStoreOffline:(BOOL)_storeOffline{
    [[AOMDatastore sharedInstance] loadListFromServerAsyncWithClass:[AOMRole class] andQuery:_query andFinishingBlock:_block andStoreOffline:_storeOffline];
}
+ (long)getCountWithQuery:(NSString*) _query{
    return [[AOMDatastore sharedInstance] loadCountFromServerWithClass:[AOMRole class] andQuery:_query];
}
+ (void)getCountAsyncWithQuery:(NSString*) _query withBlock:(AOMBlockWithLongResults) _block{
    [[AOMDatastore sharedInstance] loadCountFromServerAsyncWithClass:[AOMRole class] andQuery:_query andFinishingBlock:_block];
}


     - (NSMutableArray*)members {


 return [[self data] objectForKey:@"members"];
}

            - (void)setMembers:(NSMutableArray*) _members {
                            [[self data] setObject:_members?:[[NSMutableArray alloc] init] forKey:@"members"];
                        }

     - (NSString*
)name {


 return [[self data] objectForKey:@"name"];
}

            - (void)setName:(NSString*
)_name {
                            [[self data] setObject:_name?:[NSNull null] forKey:@"name"];
                        }

/*!
 Set this property to store instances of this class in disc-cache
 */
+ (void) setStoreOffline:(BOOL)_storeOffline
{
    storeOffline = _storeOffline;
}
/*!
 Returns true if instances of this class will be stored in disc-cache
 */
+ (BOOL) storeOffline
{
    return storeOffline;
}

+ (void) clearCacheForClassWithQuery: (NSString*) _query
{
    [[AOMDatastore sharedInstance] clearCachedResultForClass:[AOMRole class] andQuery:_query];
}

@end
