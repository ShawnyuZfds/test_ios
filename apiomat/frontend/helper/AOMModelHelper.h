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
#import <Foundation/Foundation.h>
#import "AOMAbstractClientDataModel.h"

/*!
 Class contains helper methods for AbsctractClientDataModel and childs
 */
@interface AOMModelHelper : NSObject
/*!
 Returns true if given _list contains given _href
 
 @param _list List which maybe contains _href
 @param _href HREF for which we search for in _list
 @return True if list contains HREF else false
 */
+ (BOOL) containsList:(NSArray*) _list thisHref:(NSString*) _href;
+ (NSArray*) getElementsFromList:(NSArray*) _list ByHref:(NSString*) _href;
+ (void) updateHref:(NSString*) _href forModel:(AOMAbstractClientDataModel*)_model;
+ (NSString*) getResourceURL:(NSString*) url WithSuffix:(NSString*)_suffix;
+ (NSString*) createReferenceURL:(AOMAbstractClientDataModel*)_model ReferenceName:(NSString*)_referenceName;
+ (NSString*) getIDFromHref:(NSString*)_href;
+ (NSInteger) hashOfModels:(NSArray*) _models;
@end
