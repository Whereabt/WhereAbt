// Copyright (c) 2015 Microsoft Corporation
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
// 
// 
// This file was generated and any chanes will be overwritten.


#import "ODModels.h"

@interface ODObject()

@property (strong, nonatomic) NSMutableDictionary *dictionary;

@end

@interface ODOpenWithSet()
{
    ODOpenWithApp *_web;
    ODOpenWithApp *_webEmbedded;
}
@end

@implementation ODOpenWithSet	

- (ODOpenWithApp *)web
{
    if (!_web){
        _web = [[ODOpenWithApp alloc] initWithDictionary:self.dictionary[@"web"]];
        if (_web){
            self.dictionary[@"web"] = _web;
        }
    }
    return _web;
}

- (void)setWeb:(ODOpenWithApp *)web
{
    _web = web;
    self.dictionary[@"web"] = web; 
}

- (ODOpenWithApp *)webEmbedded
{
    if (!_webEmbedded){
        _webEmbedded = [[ODOpenWithApp alloc] initWithDictionary:self.dictionary[@"webEmbedded"]];
        if (_webEmbedded){
            self.dictionary[@"webEmbedded"] = _webEmbedded;
        }
    }
    return _webEmbedded;
}

- (void)setWebEmbedded:(ODOpenWithApp *)webEmbedded
{
    _webEmbedded = webEmbedded;
    self.dictionary[@"webEmbedded"] = webEmbedded; 
}

@end