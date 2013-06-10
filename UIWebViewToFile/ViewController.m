//
//  ViewController.m
//  UIWebViewToFile
//
//  Created by Tracy E on 13-6-10.
//  Copyright (c) 2013 EsoftMobile.com. All rights reserved.
//

#import "ViewController.h"
#import "UIWebView+ToFile.h"

@interface ViewController ()<UIWebViewDelegate, UIDocumentInteractionControllerDelegate>{
    UIWebView *_webView;
    UIDocumentInteractionController *_docInteractionController;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"To image"
                                     style:UIBarButtonItemStyleBordered
                                    target:self
                                    action:@selector(convertToImage:)];
    
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"To PDF"
                                     style:UIBarButtonItemStyleBordered
                                    target:self
                                    action:@selector(convertToPDF:)];
    
    _docInteractionController = [[UIDocumentInteractionController alloc] init];
    _docInteractionController.delegate = self;
    
    self.view.autoresizesSubviews = YES;
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    _webView.scalesPageToFit = YES;
    _webView.delegate = self;
    _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://esoftmobile.com"]]];
    [self.view addSubview:_webView];
}

- (void)convertToImage:(UIBarButtonItem *)item{
    UIImage *image = [_webView imageRepresentation];
    NSData *imageData = UIImagePNGRepresentation(image);
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *imagePath = [documentPath stringByAppendingPathComponent:@"temp.png"];
    BOOL result = [imageData writeToFile:imagePath atomically:YES];
    if (result) {
        _docInteractionController.URL = [NSURL fileURLWithPath:imagePath];
        [_docInteractionController presentPreviewAnimated:YES];
    }
}

- (void)convertToPDF:(UIBarButtonItem *)item{
    NSData *pdfData = [_webView PDFData];
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *pdfPath = [documentPath stringByAppendingPathComponent:@"temp.pdf"];
    BOOL result = [pdfData writeToFile:pdfPath atomically:YES];
    if (result) {
        _docInteractionController.URL = [NSURL fileURLWithPath:pdfPath];
        [_docInteractionController presentPreviewAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIDocumentInteractionControllerDelegate Methods
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller{
    return self;
}


#pragma mark - UIWebViewDelegate Methods
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerText='Hello'"];
}

@end
