//
//  RHAboutViewController.m
//  TrackMyTour
//
//  Created by Christopher Meyer on 8/26/12.
//  Copyright (c) 2012 Red House Consulting GmbH. All rights reserved.
//

#import "RHAboutViewController.h"
#import "NSString+analytics.h"
#import "RHWebViewController.h"
#import "RHPromptForReview.h"

@interface RHAboutViewController ()
-(UITableViewCell *)headerCell;
-(void)showMeTheApp:(NSString *)appid;
@end

@implementation RHAboutViewController

-(void)viewDidLoad {
    [super viewDidLoad];
	[self setTitle:NSLocalizedString(@"About", nil)];
	
	UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self.navigationController action:@selector(dismissModalViewControllerAnimated:)];
	
	self.navigationItem.leftBarButtonItem = doneButton;
	// self.navigationController.navigationBar.tintColor = [UIColor colorFromHexString:@"2E74A5"];
}

-(void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self.navigationController setToolbarHidden:YES animated:YES];
}

#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
		case 0:
			return 1;
		case 1:
			return 3;
		default:
			return 1;
	}
}

-(UITableViewCell *)headerCell {
	UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
	
	[cell.imageView setImage:[UIImage imageNamed:@"ws-50"]];
	
	[cell.textLabel setFont:[UIFont boldSystemFontOfSize:20]];
	[cell.detailTextLabel setFont:[UIFont systemFontOfSize:14]];
	[cell.detailTextLabel setTextColor:[UIColor darkTextColor]];
	
	NSString *build_number = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
	NSString *short_version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
#ifdef DEBUG
    NSString *debug_string = @"D";
#else
    NSString *debug_string = @"";
#endif
    
	NSString *versionLabel = [NSString stringWithFormat:@" %@ %@ (%@)%@", NSLocalizedString(@"Version", nil), short_version, build_number, debug_string];
	
	NSString *appName = @"Warmshowers.org";
	
	[cell.textLabel setText:appName];
	[cell.detailTextLabel setText:versionLabel];
	// [cell setBackgroundColor:[UIColor clearColor]];
	// [cell setBackgroundView:[[UIView alloc] initWithFrame:CGRectZero]];
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	
	return cell;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.section == 0) {
		return [self headerCell];
	}
	
	UITableViewCell *cell;
	
	switch (indexPath.section) {
		case 0:
			break;
		case 1:
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
			[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
			
			if ( indexPath.row == 0) {
				[cell.textLabel setText:NSLocalizedString(@"Follow us on Twitter", nil)];
			} else if (indexPath.row == 1) {
				[cell.textLabel setText:NSLocalizedString(@"Like us on Facebook", nil)];
			} else { // if (indexPath.row == 1) {
				[cell.textLabel setText:NSLocalizedString(@"Rate this App", nil)];
			}
            
			break;
		case 2:
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
			[cell.imageView setImage:[UIImage imageNamed:@"trackmytour"]];
			[cell.textLabel setText:@"TrackMyTour"];
			[cell.detailTextLabel setText:NSLocalizedString(@"A tracking app for bike touring", nil)];
			[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
			
			break;
	}
	
    return cell;
}

#pragma mark - Table view delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case 0:
			break;
		case 1:
			if (indexPath.row == 0) {
				[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://twitter.com/warmshowers"]];
			} else if (indexPath.row == 1) {
				[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.facebook.com/groups/135049549858210/"]];
			} else {
				[[RHPromptForReview sharedInstance] promptNow:nil];
			}
			break;
			
		default:
			if (indexPath.row == 0) {
				[self showMeTheApp:@"307303960"];
				break;
			}
	}
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case 0:
			if (indexPath.row == 0) {
				return 80;
			}
		case 2:
			return 80;
		default:
			return 44;
	}
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (section == 1) {
		return @"Warmshowers";
	} else if (section == 2) {
		return @"Other Apps";
	}
	
	return @"";
}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
	switch (section) {
			//case 1:
			//	return @"\nTrackMyTour is another app";
		case 2:
			return NSLocalizedString(@"The Warmshowers and TrackMyTour apps developed by Christopher Meyer. Contact me at chris@schwiiz.org or visit my blog at http://schwiiz.org/.", nil);
			
		default:
			return @"";
	}
	
}

-(void)showMeTheApp:(NSString *)appid {
    NSDictionary *appParameters = @{SKStoreProductParameterITunesItemIdentifier:appid};
    SKStoreProductViewController *productViewController = [[SKStoreProductViewController alloc] init];

    [productViewController setDelegate:self];

    [productViewController loadProductWithParameters:appParameters completionBlock:^(BOOL result, NSError *error) {
        [self.navigationController presentViewController:productViewController animated:YES completion:nil];
    }];
}

-(void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

@end