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

/*!
 Generated default class representing a user in your app
*/
@interface AOMUser : AOMAbstractClientDataModel








    /* contains apiKey for your app */
    extern NSString * const apiKey;
    /* base server URL for requests */
    extern NSString * const baseUrl;
    /* NSString which provides information which system is used (LIVE,TEST,STAGING) */
    extern NSString * const AMSystem;
    /* provides information about currently used SDK version */
    extern NSString * const sdkVersion;

/*!
 Create new User object with username and password
*/
- (id) initWithUserName:(NSString *)_username andPassword:(NSString*) _password;
/*!
 Init datastore if needed
*/
- (void) initDSWithMembersCredsIfNeeded:(BOOL) _allowGuest;
/*!
 Updates this class from server
*/
- (void)loadMe;
/*!
 Load data for member from server on a Non-UI-Thread

 @param _block block which will be called after request was finished
*/
- (void)loadMeAsyncWithFinishingBlock:(AOMEmptyBlock) _block;
/*!
 Requests a new password; user will receive an email to confirm
*/
- (void)requestNewPassword;
/*!
Reset password

@param _newPassword the new password
*/
- (void)resetPassword:(NSString*) _newPassword;
/*!
Reset password. This method will be executed on a Non-UI-Thread

@param _newPassword the new password
@param _block code which will be called after request was finished
*/
- (void)resetPasswordAsync:(NSString*) _newPassword andWithFinishingBlock: (AOMEmptyBlock) _block;
/*!
 * Request a session token with the credentials saved in this User object. Also configures the datastore with the received token and saves it in the user object.
 *
 * @param _responseBlock block which will be executed after request is finished. Contains returned session information and error information
*/
- (void)requestSessionTokenAsync:(AOMResponseSessionBlock) _responseBlock;

/*!
 * Request a session token with the credentials saved in this User object.
 * Optionally sets the attribute of the user and configures the datastore with the session token automatically.
 *
 * @param _configure Set flag to false if you don't want the Datastore to automatically be configured with the received session token and also don't want to save the token in the user object
 * @param _responseBlock block which will be executed after request is finished. Contains returned session information and error information
 */
- (void)requestSessionTokenAsyncAndConfigure:(BOOL) _configure Block:(AOMResponseSessionBlock) _responseBlock;

/*!
 * Request a session token with a refresh token. Optionally configures the datastore with the received token and saves it in the user object.
 * @param _refreshToken The refresh token to use for requesting a new session token
 * @param _configure Set flag to true if you want the Datastore to automatically be configured with the received session token and also save it in the user object.
 * @param _responseBlock block which will be executed after request is finished. Contains returned session information and error information
 */
- (void)requestSessionTokenAsyncWithRrefreshToken:(NSString*) _refreshToken configure:(BOOL) _configure Block:(AOMResponseSessionBlock) _responseBlock;

                - (NSDate*
)dateOfBirth;
        
                        - (void)setDateOfBirth:(NSDate*
)_dateOfBirth;
            

                - (NSString*
)firstName;
        
                        - (void)setFirstName:(NSString*
)_firstName;
            
                - (NSString*
)lastName;
        
                        - (void)setLastName:(NSString*
)_lastName;
            
        - (double)locLatitude;
    - (double)locLongitude;
    - (void)setLocLatitude:(double)_latitude;
    - (void)setLocLongitude:(double)_longitude;

                - (NSString*
)password;
        
                        - (void)setPassword:(NSString*
)_password;
            
                - (NSString*
)sessionToken;
        
                        - (void)setSessionToken:(NSString*
)_sessionToken;
            
                - (NSString*
)userName;
        
                        - (void)setUserName:(NSString*
)_userName;
            

@end
