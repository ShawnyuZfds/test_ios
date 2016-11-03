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
#import "AOMAbstractClientDataModel.h"
#import "NSString+Extensions.h"
#import "AOMUser.h"
#import "AOMDatastore.h"
#import "AOMModelHelper.h"

@interface AOMAbstractClientDataModel ()
@property (strong, nonatomic) NSString *href;
@property (strong, nonatomic) NSString *type;
@end

@implementation AOMAbstractClientDataModel

@synthesize data = m_data;
@synthesize href = m_href;
@synthesize objectState = m_objectState;
@synthesize type = m_type;

- (void) initAttributes {
}

-(id)init {
    if (self = [super init])
    {
        m_data = [[NSMutableDictionary alloc] init];
        [m_data setValue:self.type forKey:@"@type"];
        m_objectState = ObjectState_NEW;
    }
    return self;
}

#pragma mark - NSCoding delegate for archiving
- (id)initWithCoder:(NSCoder *)decoder
{
    if ((self = [super init]))
    {
        m_data = [decoder decodeObjectForKey:@"kWrappedModel"];
        m_href = [decoder decodeObjectForKey:@"kWrappedModelHref"];
        m_objectState = [decoder decodeIntForKey:@"kWrappedModelObjectstate"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:m_data forKey:@"kWrappedModel"];
    [encoder encodeObject:m_href forKey:@"kWrappedModelHref"];
    [encoder encodeInt:m_objectState forKey:@"kWrappedModelObjectstate"];
}

- (NSString*)debugDescription
{
    return [NSString stringWithFormat:@"%@", [self data]];
}

- (NSString*)description
{
    return [self getHref];
}

/**
 * Returns the unique type of this class to get identified via REST interface
 *
 */
- (NSString *) type
{
    m_type = [m_data objectForKey:@"@type"];
    if(m_type == nil || m_type == false)
    {
        m_type = [NSString stringWithFormat:@"%@$%@",[[self class] performSelector:@selector(getModuleName)] , [[self class] performSelector:@selector(getSimpleName)]];
    }
    return m_type;
}

- (NSString*) objectType
{
    return [AOMAbstractClientDataModel objectTypeFromType:self.type];
}

+ (NSString*) objectTypeFromJson:(NSDictionary*) jsonDict
{
    return [self objectTypeFromType:[jsonDict objectForKey:@"@type"]];
}

+ (NSString*) objectTypeFromType:(NSString*) type
{
    NSString *objectType = nil;
    if(type)
    {
        NSArray *parts = [type componentsSeparatedByString:@"$"];
        if([parts count] > 1)
        {
            objectType = parts[1];
        }
        
    }
    return objectType;
}

- (NSString *) getHref
{
    return [self href];
}

- (NSString*) getID
{
    NSString *objId = [[self data] objectForKey:@"id"];
    if(objId == FALSE)
    {
        /* Extract from HREF */
        objId = [AOMModelHelper getIDFromHref:[self getHref]];
    }
    return objId;
}

- (NSString *) getForeignId
{
    return [self.data objectForKey: (@"foreignId")];
}

- (void) setForeignId: (NSString*) _foreignID
{
    [[self data] setObject:_foreignID forKey:@"foreignId"];
}

- (NSDate *) getCreatedAt
{
    return [NSDate dateWithTimeIntervalSince1970:[[self.data objectForKey: (@"createdAt")]longLongValue]/1000.0];
}

- (NSDate *) getLastModifiedAt
{
    return [NSDate dateWithTimeIntervalSince1970:[[self.data objectForKey: (@"lastModifiedAt")]longLongValue]/1000.0];
}
- (NSString *) getAppName
{
    return [self.data objectForKey: (@"applicationName")];
}
+ (NSString *) getSimpleName
{
    NSAssert(false, @"You must override %@ in a subclass", NSStringFromSelector(_cmd));
    return nil;
}
+ (NSString *) getModuleName
{
    NSAssert(false, @"You must override %@ in a subclass", NSStringFromSelector(_cmd));
    return nil;
}

- (void) fromJson : (NSData*)_jsonData
{
    NSError* error;
    NSMutableDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:_jsonData options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:&error];
    
    if (_jsonData && error == nil) [self fromJSONWithObject:jsonData];
}


- (void) fromJSONWithObject:(NSMutableDictionary*)_jsonObject
{
    
    self.data = _jsonObject;
    self.href=[self.data objectForKey:@"href"];
}

- (NSData *) toJson
{
    NSError* error;
    if([self getHref])
    {
        /* Add ID field */
        [m_data setObject:[self getID] forKey:@"id"];
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:m_data
                                           options:kNilOptions error:&error];
    /* Remove ID field */
    [m_data removeObjectForKey:@"id"];
    return jsonData;
}
#pragma mark - CRUD operations
- (BOOL) save
{
    return [self saveAndLoad: true];
}

- (BOOL) saveAndLoad:(BOOL) _loadAfterwards
{
    BOOL ret = NO;
    if (m_href)
    {
        ret = [[AOMDatastore sharedInstance] updateOnServer:self];
    } else {
        NSString* location = [[AOMDatastore sharedInstance] postOnServer:self];
        ret=[NSString isEmptyString:location]==NO;
    }
	if (_loadAfterwards && [[AOMDatastore sharedInstance] hasConnection])
	{
	    [self load];
	}
    return ret;
}

- (void) load
{
    [[AOMDatastore sharedInstance]loadFromServerWithHref:[self getHref]  andStoreIn:self];
}

- (void) loadWithHref: (NSString*) _href
{
    [[AOMDatastore sharedInstance]loadFromServerWithHref:_href andStoreIn:self];
    
    self.href=[self.data objectForKey: (@"href")];
}
- (BOOL) delete
{
    return [[AOMDatastore sharedInstance] deleteOnServer:self];
}

#pragma mark - Async CRUD operations
- (void) saveAsyncWithBlock:(AOMEmptyBlock) _block
{
    [self saveAsyncUsePersistentStorage:[self handleOffline] WithBlock:_block];
}

- (void) saveAsyncUsePersistentStorage:(BOOL) _usePersistentStorage WithBlock:(AOMEmptyBlock) _block
{
    [self saveAndLoadAsync:TRUE UsePersistentStorage:_usePersistentStorage withBlock:_block];
}

- (void) saveAndLoadAsync:(BOOL) _loadAfterwards withBlock:(AOMEmptyBlock) _block
{
    [self saveAndLoadAsync:_loadAfterwards UsePersistentStorage:[self handleOffline] withBlock:_block];
}

- (void) saveAndLoadAsync:(BOOL) _loadAfterwards UsePersistentStorage:(BOOL) _usePersistentStorage withBlock:(AOMEmptyBlock) _block
{
    __block NSError *_error = Nil;
    if (m_href)
    {
        [[AOMDatastore sharedInstance] updateOnServerAsync:self UsePersistentStorage:_usePersistentStorage  withFinishingBlock:^(NSError *error) {
            _error = error;
            
            if(_error == FALSE && _loadAfterwards)
            {
                [self loadAsyncWithBlock:^(NSError *error) {
                    //Call caller
                    if(_block)
                    {
                        //Use error from prev req if exists
                        _block(_error?:error);
                    }
                }];
            }
            else if(_block)
            {
                _block(_error);
            }
        }];
    }
    else
    {
        [[AOMDatastore sharedInstance] postOnServerAsync:self UsePersistentStorage:_usePersistentStorage withFinishingBlock:^(NSString *href, NSError *error) {
            _error = error;
            if(_error == FALSE && _loadAfterwards)
            {
                [self loadAsyncWithBlock:^(NSError *error) {
                    //Call caller
                    if(_block)
                    {
                        //Use error from prev req if exists
                        _block(_error?:error);
                    }
                }];
            }
            else if(_block)
            {
                _block(_error);
            }
        }];
    }
}

- (void) loadAsyncWithBlock:(AOMEmptyBlock) _block
{
    [self loadAsyncWithBlock:_block andStoreOffline:[self handleOffline]];
}
- (void) loadAsyncWithBlock:(AOMEmptyBlock) _block andStoreOffline:(BOOL)_storeOffline
{
    [[AOMDatastore sharedInstance] loadFromServerAsyncWithHref:[self getHref] andStoreIn:self andFinishingBlock:^(AOMAbstractClientDataModel *model, NSError *error) {
        if(_block)
        {
            _block(error);
        }
    } andStoreOffline:_storeOffline];
}
- (void) loadAsyncWithHref:_modelHref andBlock:(AOMEmptyBlock) _block
{
    [self loadAsyncWithHref:_modelHref andBlock:_block andStoreOffline:[self handleOffline]];
}
- (void) loadAsyncWithHref:_modelHref andBlock:(AOMEmptyBlock) _block andStoreOffline:(BOOL)_storeOffline
{
    [[AOMDatastore sharedInstance] loadFromServerAsyncWithHref:_modelHref andStoreIn:self andFinishingBlock:^(AOMAbstractClientDataModel *model, NSError *error) {
        if(error==FALSE)
        {
            self.href=[self.data objectForKey: (@"href")];
        }
        
        if(_block)
        {
            _block(error);
        }
    } andStoreOffline:_storeOffline];
}
- (void) deleteAsyncWithBlock:(AOMEmptyBlock) _block
{
    [self deleteAsyncUsePersistentStorage:[self handleOffline] WithBlock:_block];
}

- (void) deleteAsyncUsePersistentStorage:(BOOL) _usePersistentStorage WithBlock:(AOMEmptyBlock) _block
{
    [[AOMDatastore sharedInstance] deleteOnServerAsync:self UsePersistentStorage:_usePersistentStorage withFinishingBlock:^(NSError *error) {
        if(_block)
        {
            _block(error);
        }
    }];
}

- (BOOL) getRestrictResourceAccess
{
    NSString *value = [self.data objectForKey:@"restrictResourceAccess"];
    return [value boolValue];
}

- (void) setRestrictResourceAccess: (BOOL)_restrictedResourceAccess
{
    NSString *value =  (_restrictedResourceAccess) ? @"true" : @"false";
    [self.data setObject:value forKey:@"restrictResourceAccess"];
}

- (NSMutableArray*) getAllowedRolesGrant
{
    return [self.data objectForKey:@"allowedRolesGrant"];
}

- (void) setAllowedRolesGrant:(NSMutableArray*) _allowedRolesGrant
{
    [self.data setObject:_allowedRolesGrant forKey:@"allowedRolesGrant"];
}

- (NSMutableArray*) getAllowedRolesWrite
{
    return [self.data objectForKey:@"allowedRolesWrite"];
}

- (void) setAllowedRolesWrite:(NSMutableArray*) _allowedRolesWrite
{
    [self.data setObject:_allowedRolesWrite forKey:@"allowedRolesWrite"];
}

- (NSMutableArray*) getAllowedRolesRead
{
    return [self.data objectForKey:@"allowedRolesRead"];
}

- (void) setAllowedRolesRead:(NSMutableArray*) _allowedRolesRead
{
    [self.data setObject:_allowedRolesRead forKey:@"allowedRolesRead"];
}

#pragma mark - other stuff
+ (NSString *) getSystem {
    return AMSystem;
}

+ (NSMutableArray*)getWithQuery: (NSString*) _query {
    //is overwritten by concrete classes
    return nil;
}

+ (void)getAsyncWithQuery: (NSString*) _query withBlock:(AOMBlockWithResults) _block
{
    //is overwritten by concrete classes
}

+ (void)getAsyncWithQuery: (NSString*) _query withBlock:(AOMBlockWithResults) _block andStoreOffline:(BOOL)_storeOffline
{
    //is overwritten by concrete classes
}

+ (long)getCountWithQuery: (NSString*) _query
{
    //is overwritten by concrete classes
    return 0;
}

+ (void)getCountAsyncWithQuery: (NSString*) _query withBlock:(AOMBlockWithLongResults) _block
{
    //is overwritten by concrete classes
}

- (NSMutableDictionary* ) getRefModelHrefs {
    return [self.data objectForKey: (@"referencedHrefs")];
}

- (NSMutableArray* ) getRefModelHrefsForName:(NSString*) _name {
    NSMutableArray* linkedHrefs = [[NSMutableArray alloc] init];
    NSMutableDictionary* linkedHrefsMap =  [self getRefModelHrefs];
    if(linkedHrefsMap) {
        linkedHrefs = [linkedHrefsMap objectForKey:_name];
    }
    return linkedHrefs;
}

- (void) addRefModelHrefWithName:(NSString*) _name andHref:(NSString*)_href {
    NSMutableDictionary* linkedHrefsMap =  [self getRefModelHrefs];
    if(linkedHrefsMap) {
        NSMutableArray* hrefsForName = [linkedHrefsMap objectForKey:_name];
        if(hrefsForName==nil) {
            hrefsForName = [[NSMutableArray alloc] init];
            [linkedHrefsMap setObject:hrefsForName forKey:_name];
        }
        
        if([hrefsForName containsObject:_href]==NO) {
            [hrefsForName addObject:_href];
        }
    }
}

- (void) removeFromRefModelHrefsWithName:(NSString*)_name andHref:(NSString*)_href {
    NSMutableArray* linkedHrefsMap =  [self getRefModelHrefsForName:_name];
    if(linkedHrefsMap) {
        [linkedHrefsMap removeObject:_href];
    }
}

#pragma mark -
- (BOOL)isEqual:(id)object
{
    if (self == object)
    {
        return YES;
    }
    
    if ([object isKindOfClass:[AOMAbstractClientDataModel class]] && [self getHref])
    {
        return ([[self getHref] isEqualToString:[(AOMAbstractClientDataModel*)object getHref]]);
    }
    return [super isEqual:object];
}
- (NSUInteger)hash
{
    if([self getHref])
    {
        return [[self getHref] hash];
    }
    return [super hash];
}

#pragma mark Offline handling

- (BOOL) handleOffline
{
    Class _clazz = [self class];
    BOOL _storeOffline = FALSE;
    SEL selector = @selector(storeOffline);
    NSMethodSignature *sig = [_clazz methodSignatureForSelector:selector];
    NSInvocation *getOp = [NSInvocation invocationWithMethodSignature:sig];
    [getOp setSelector:selector];
    [getOp invokeWithTarget:_clazz];
    [getOp getReturnValue:&_storeOffline];
    return _storeOffline;
}
/*!
 Set this property to store instances of this class in disc-cache
 */
+ (void) setStoreOffline:(BOOL)_storeOffline
{
    //Will be implemented on each subclass
}
/*!
 Returns true if instances of this class will be stored in disc-cache
 */
+ (BOOL) storeOffline
{
    //Will be implemented on each subclass
    return false;
}

- (BOOL) isOffline
{
    return (BOOL)[[self data] objectForKey:@"isOffline"]?:FALSE;
}

- (BOOL) isIllegalObjectState:(NSString*) _httpMethod
{
    BOOL result = FALSE;
    if([[AOMDatastore sharedInstance] checkObjectState])
    {
        result = self.objectState == ObjectState_PERSISTING || self.objectState == ObjectState_DELETING;
    }
    return result;
}

#pragma mark Persistent helper
+ (void) clearCacheForClassWithQuery: (NSString*) _query
{
    //Will be implemented on each subclass
}

- (void) clearCachedResult
{
    [[AOMDatastore sharedInstance] clearCachedResultForObject:self];
}
@end
