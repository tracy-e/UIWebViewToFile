//
//  UIWebView+ToFile.h
//  UIWebViewToFile
//
//  Created by Tracy E on 13-6-10.
//  Copyright (c) 2013 EsoftMobile.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWebView (ToFile)

- (UIImage *)imageRepresentation;

- (NSData *)PDFData;

@end
