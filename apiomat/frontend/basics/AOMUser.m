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
#import "AOMUser.h"
#import "AOMDatastore.h"
#import "AOMModelStore.h"
#import "AOMModelHelper.h"
#import "NSString+Extensions.h"
#import "AOMTokenContainer.h"
NSString* const apiKey = @"2453126609223988488";
NSString* const baseUrl = @"http://ext-dev.apiomat.enterprises/yambas/rest/apps/Pundit";
NSString* const AMSystem = @"TEST";
NSString* const sdkVersion = @"2.2.5-4";
/*
* Generated default class representing a user in your app
*/
@implementation AOMUser

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

- (id) initWithUserName:(NSString *)_username andPassword:(NSString*) _password {
    self = [super init];
    if (self) {
        self.userName = _username;
        self.password = _password;
    }
    return self;
}

- (void)loadMe{
    [self initDSWithMembersCredsIfNeeded:FALSE];
    NSString* href =[[[AOMDatastore sharedInstance] baseUrl] stringByAppendingFormat: @"/models/me"];
    [self loadWithHref:href];
}
- (void)loadMeAsyncWithFinishingBlock:(AOMEmptyBlock) _block{
    [self initDSWithMembersCredsIfNeeded:FALSE];
    NSString* href =[[[AOMDatastore sharedInstance] baseUrl] stringByAppendingFormat: @"/models/me"];
    [self loadAsyncWithHref:href andBlock:_block];
}

- (BOOL)saveAndLoad:(BOOL) _loadAfterwards{
    [self initDSWithMembersCredsIfNeeded:FALSE];
    return [super saveAndLoad: _loadAfterwards];
}

- (void)saveAndLoadAsync:(BOOL) _loadAfterwards withBlock:(AOMEmptyBlock) _block{
    [self initDSWithMembersCredsIfNeeded:FALSE];
    [super saveAndLoadAsync:_loadAfterwards withBlock:_block];
}
- (void)saveAndLoadAsync:(BOOL) _loadAfterwards UsePersistentStorage:(BOOL) _usePersistentStorage withBlock:(AOMEmptyBlock) _block{
    [self initDSWithMembersCredsIfNeeded:FALSE];
    [super saveAndLoadAsync:_loadAfterwards UsePersistentStorage:_usePersistentStorage withBlock:_block];
}

- (void)requestNewPassword{
    [[AOMDatastore sharedInstance] postOnServerAsync:self withHref:@"models/requestResetPassword/" UsePersistentStorage:FALSE andFinishingBlock:^(NSString *href, NSError *error) {
        NSLog(@"Requesting new password: %@", error);
    }];
}

- (void)resetPassword:(NSString*) _newPassword{
    [[self data] setObject:_newPassword?:[NSNull null] forKey:@"password"];
    [[AOMDatastore sharedInstance] updateOnServer:self];
    [AOMDatastore configureWithUser:self];
}

- (void)resetPasswordAsync:(NSString*) _newPassword andWithFinishingBlock: (AOMEmptyBlock) _block{
    [[self data] setObject:_newPassword?:[NSNull null] forKey:@"password"];
    [[AOMDatastore sharedInstance] updateOnServerAsync:self UsePersistentStorage:FALSE withFinishingBlock:^(NSError *error) {
        if(error == Nil)
        {
            /* Configure AOMDatastore with new user credentials */
            [AOMDatastore configureWithUser:self];
        }
        //Call caller
        if(_block)
        {
            _block(error);
        }
    }];
}

- (void)requestSessionTokenAsync:(AOMResponseSessionBlock) _responseBlock{
    [self requestSessionTokenAsyncAndConfigure:true Block:_responseBlock];
}

- (void)requestSessionTokenAsyncAndConfigure:(BOOL) _configure Block:(AOMResponseSessionBlock) _responseBlock{
    [self requestSessionTokenAsyncWithRrefreshToken:nil configure:_configure Block:_responseBlock];
}

- (void)requestSessionTokenAsyncWithRrefreshToken:(NSString*) _refreshToken configure:(BOOL) _configure Block:(AOMResponseSessionBlock) _responseBlock{
    [self initDSWithMembersCredsIfNeeded:_refreshToken != Nil];
    AOMResponseSessionBlock _block = ^(AOMTokenContainer* sessionData, NSError *error)
    {
        if(error==FALSE)
        {
            NSString *sessionToken = [sessionData sessionToken];
            if(_configure && ( sessionToken == FALSE || [sessionToken isEmpty] ))
            {
                error = [AOMDatastore createApiomatErrorWithStatus:AOMNO_TOKEN_RECEIVED];
                sessionData = nil;
            }
            else if(_configure)
            {
                [self setSessionToken:sessionToken];
                [AOMDatastore configureWithSessionToken:sessionToken andWithUrl:[[AOMDatastore sharedInstance] baseUrl] andApiKey:[[AOMDatastore sharedInstance] apiKey] andUsedSystem:[[AOMDatastore sharedInstance] usedSystem]];
            }
        }

        if(_responseBlock)
        {
            _responseBlock(sessionData, error);
        }
    };
    [[AOMDatastore sharedInstance] requestSessionTokenAsync:_refreshToken FinishingBlock:_block];
}

- (void)initDSWithMembersCredsIfNeeded:(BOOL) _allowGuest{
    if(([AOMDatastore sharedInstance].userName == false || [AOMDatastore sharedInstance].password == false) && [AOMDatastore sharedInstance].sessionToken == false)
    {
        if([self userName] && [self password])
        {
            [AOMDatastore configureWithCredentials:self];
        }
        else if([self sessionToken])
        {
            [AOMDatastore configureWithSessionToken:[self sessionToken] andWithUrl:baseUrl andApiKey:apiKey andUsedSystem:[AOMAbstractClientDataModel getSystem]];
        }
        else if(_allowGuest)
        {
            [AOMDatastore configureAsGuestWithUrl:baseUrl andApiKey:apiKey];
        }
    }
}

     + (NSString*)getSimpleName    {
        return @"User";
    }
    + (NSString*)getModuleName    {
        return @"Basics";
    }

+ (NSMutableArray*)getWithQuery:(NSString*) _query{
    return [[AOMDatastore sharedInstance] loadListFromServerWithClass:[AOMUser class] andQuery:_query];
}
+ (void)getAsyncWithQuery:(NSString*) _query withBlock:(AOMBlockWithResults) _block{
    [[AOMDatastore sharedInstance] loadListFromServerAsyncWithClass:[AOMUser class] andQuery:_query andFinishingBlock:_block andStoreOffline:[AOMUser storeOffline]];
}
+ (void)getAsyncWithQuery:(NSString*) _query withBlock:(AOMBlockWithResults) _block andStoreOffline:(BOOL)_storeOffline{
    [[AOMDatastore sharedInstance] loadListFromServerAsyncWithClass:[AOMUser class] andQuery:_query andFinishingBlock:_block andStoreOffline:_storeOffline];
}
+ (long)getCountWithQuery:(NSString*) _query{
    return [[AOMDatastore sharedInstance] loadCountFromServerWithClass:[AOMUser class] andQuery:_query];
}
+ (void)getCountAsyncWithQuery:(NSString*) _query withBlock:(AOMBlockWithLongResults) _block{
    [[AOMDatastore sharedInstance] loadCountFromServerAsyncWithClass:[AOMUser class] andQuery:_query andFinishingBlock:_block];
}


        - (NSDate*)dateOfBirth {
        double timeInMs = [[[self data] objectForKey:@"dateOfBirth"] doubleValue];
        if(timeInMs)
        {
            NSDate* date = [NSDate dateWithTimeIntervalSince1970:timeInMs/1000.0];
            return date;
        }
        return nil;
    }
    - (void)setDateOfBirth:(NSDate*) _dateOfBirth {
        double timeInS = [_dateOfBirth timeIntervalSince1970] * 1000;
        [[self data] setValue:[NSNumber numberWithDouble: timeInS] forKey:@"dateOfBirth"] ;
    }

        - (NSMutableDictionary*)dynamicAttributes {
        NSMutableDictionary* dict = [[self data] objectForKey:@"dynamicAttributes"];
        //Return empty dict
        if (dict == nil)
        {
            dict = [[NSMutableDictionary alloc] init];
            [[self data] setObject:dict forKey:@"dynamicAttributes"];
        }
        return dict;
    }

    - (void)setDynamicAttributes:(NSMutableDictionary*) _dynamicAttributes {
        [[self data] setObject:_dynamicAttributes?:[NSNull null] forKey:@"dynamicAttributes"];
    }

     - (NSString*
)firstName {


 return [[self data] objectForKey:@"firstName"];
}

            - (void)setFirstName:(NSString*
)_firstName {
                            [[self data] setObject:_firstName?:[NSNull null] forKey:@"firstName"];
                        }

     - (NSString*
)lastName {


 return [[self data] objectForKey:@"lastName"];
}

            - (void)setLastName:(NSString*
)_lastName {
                            [[self data] setObject:_lastName?:[NSNull null] forKey:@"lastName"];
                        }

        - (double)locLatitude    {
      NSArray* loc = [[self data] objectForKey:@"loc"];
      return [[loc objectAtIndex:0] doubleValue];
    }
    - (void)setLocLatitude:(double)_latitude    {
        if([[self data] objectForKey:@"loc"] == nil)
        {
            NSMutableArray* loc = [[NSMutableArray alloc] init ];
            [loc insertObject:[NSNumber numberWithDouble: 0] atIndex:0];
            [loc insertObject:[NSNumber numberWithDouble: 0] atIndex:1];
            [[self data] setObject:loc forKey:@"loc"];
        }
        NSMutableArray* loc = [[self data] objectForKey:@"loc"];
        [loc replaceObjectAtIndex:0 withObject:[NSNumber numberWithDouble: _latitude]];
    }

    - (double)locLongitude    {
        NSArray* loc = [[self data] objectForKey:@"loc"];
        return [[loc objectAtIndex:1] doubleValue];
    }
    - (void)setLocLongitude:(double)_longitude    {
        if([[self data] objectForKey:@"loc"] == nil)
        {
            NSMutableArray* loc = [[NSMutableArray alloc] init ];
            [loc insertObject:[NSNumber numberWithDouble: 0] atIndex:0];
            [loc insertObject:[NSNumber numberWithDouble: 0] atIndex:1];
            [[self data] setObject:loc forKey:@"loc"];
        }
        NSMutableArray* loc = [[self data] objectForKey:@"loc"];
        [loc replaceObjectAtIndex:1 withObject:[NSNumber numberWithDouble: _longitude]];
    }


     - (NSString*
)password {


 return [[self data] objectForKey:@"password"];
}

            - (void)setPassword:(NSString*
)_password {
                            [[self data] setObject:_password?:[NSNull null] forKey:@"password"];
                        }

     - (NSString*
)sessionToken {


 return [[self data] objectForKey:@"sessionToken"];
}

            - (void)setSessionToken:(NSString*
)_sessionToken {
                            [[self data] setObject:_sessionToken?:[NSNull null] forKey:@"sessionToken"];
                        }

     - (NSString*
)userName {


 return [[self data] objectForKey:@"userName"];
}

            - (void)setUserName:(NSString*
)_userName {
                            [[self data] setObject:_userName?:[NSNull null] forKey:@"userName"];
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
    [[AOMDatastore sharedInstance] clearCachedResultForClass:[AOMUser class] andQuery:_query];
}

@end
