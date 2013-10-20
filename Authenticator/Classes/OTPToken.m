//
//  OTPToken.m
//  Authenticator
//
//  Copyright (c) 2013 Matt Rubin
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of
//  this software and associated documentation files (the "Software"), to deal in
//  the Software without restriction, including without limitation the rights to
//  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//  the Software, and to permit persons to whom the Software is furnished to do so,
//  subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//  FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "OTPToken.h"
@import Security;


@implementation OTPToken

+ (NSDictionary *)keychainItemForPersistentRef:(NSData *)persistentRef
{
    NSDictionary *queryDict = @{(__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
                                (__bridge id)kSecValuePersistentRef: persistentRef,
                                (__bridge id)kSecReturnAttributes: (id)kCFBooleanTrue,
                                (__bridge id)kSecReturnData: (id)kCFBooleanTrue
                                };

    CFDictionaryRef query = (__bridge CFDictionaryRef)(queryDict);
    CFTypeRef result = NULL;
    OSStatus resultCode = SecItemCopyMatching(query, &result);

    return (resultCode == errSecSuccess) ? (__bridge NSDictionary *)(result) : nil;
}

+ (BOOL)updateKeychainItemForPersistentRef:(NSData *)persistentRef withAttributes:(NSDictionary *)attributesToUpdate
{
    NSDictionary *queryDict = @{(__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
                                (__bridge id)kSecValuePersistentRef: persistentRef,
                                };

    CFDictionaryRef query = (__bridge CFDictionaryRef)(queryDict);
    OSStatus resultCode = SecItemUpdate(query, (__bridge CFDictionaryRef)(attributesToUpdate));

    return (resultCode == errSecSuccess);
}

+ (BOOL)deleteKeychainItemForPersistentRef:(NSData *)persistentRef
{
    NSDictionary *queryDict = @{(__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
                                (__bridge id)kSecValuePersistentRef: persistentRef,
                                };

    CFDictionaryRef query = (__bridge CFDictionaryRef)(queryDict);
    OSStatus resultCode = SecItemDelete(query);

    return (resultCode == errSecSuccess);
}

@end
