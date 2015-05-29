//
//  Copyright (C) 2015 Warm Showers Foundation
//  http://warmshowers.org/
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "LoginViewController.h"
#import "WSRequests.h"
#import "WSAppDelegate.h"

@interface LoginViewController ()
@property (nonatomic, strong) NSLayoutConstraint *bottomConstraint;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.loginButton setType:BButtonTypePrimary];
    [self.scrunchView setBackgroundColor:kWSBaseColour];
    __weak LoginViewController *bself = self;
    
    [self.usernameTextField setText:[[WSAppDelegate sharedInstance] username]];
    
    [self.usernameTextField setShouldReturnBlock:^BOOL(RHTextField *textField) {
        [bself.passwordTextField becomeFirstResponder];
        return YES;
    }];
    
    [self.passwordTextField setShouldReturnBlock:^BOOL(RHTextField *textField) {
        [bself loginButtonTapped:nil];
        return YES;
    }];
}

// things get tight when the keyboard shows on the iPhone in landscape mode
-(NSUInteger)supportedInterfaceOrientations {
    if IsIPhone {
        return UIInterfaceOrientationMaskPortrait;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

-(IBAction)loginButtonTapped:(id)sender {
    
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    
    [self.usernameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    
    __weak LoginViewController *bself = self;
    
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Logging in...", nil) maskType:SVProgressHUDMaskTypeBlack];
    
    [WSRequests loginWithUsername:username
                         password:password
                          success:^(NSURLSessionDataTask *task, id responseObject) {
                              
                              [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Success!", nil)];
                              
                              [[WSAppDelegate sharedInstance] setUsername:username];
                              [[WSAppDelegate sharedInstance] setPassword:password];
                              [[WSAppDelegate sharedInstance] loginSuccess];
                              
                              [bself dismissViewControllerAnimated:YES completion:^{
                                  
                              }];
                              
                          } failure:^(NSURLSessionDataTask *task, NSError *error) {
                              [SVProgressHUD dismiss];
                              RHAlertView *alert = [RHAlertView alertWithTitle:NSLocalizedString(@"Warm Showers", nil)
                                                                       message:NSLocalizedString(@"Login failed. Please check your username and password and try again. If you don't have an account you can tap the Sign Up button to register.", nil)];
                              
                              [alert addButtonWithTitle:kOK block:^{
                                  //  [self logout];
                              }];
                              
                              [alert show];
                          }];
    
}

-(IBAction)createAccountButtonTapped:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.warmshowers.org/user/register"]];
}

-(IBAction)learnAboutButtonTapped:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.warmshowers.org/faq"]];
}


@end