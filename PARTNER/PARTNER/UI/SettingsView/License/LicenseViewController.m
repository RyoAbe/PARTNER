//
//  LicenseViewController.m
//  RandomPocket
//
//  Created by RyoAbe on 2014/02/12.
//  Copyright (c) 2014年 RyoAbe. All rights reserved.
//

#import "LicenseViewController.h"
#import "LicenseCell.h"

static NSString* const LicenseCellIdentifier = @"LicenseCell";
const NSString* TitleKey = @"title";
const NSString* CopyrightKey = @"copyright";
const NSString* DescriptionKey = @"description";
const NSString* TypeKey = @"type";

@interface LicenseViewController ()
@property (nonatomic) NSArray *licenses;
@end

@implementation LicenseViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"LicenseCell" bundle:nil] forCellReuseIdentifier:LicenseCellIdentifier];
    self.licenses = self.licenseData;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.licenses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LicenseCell *cell = [tableView dequeueReusableCellWithIdentifier:LicenseCellIdentifier forIndexPath:indexPath];
    cell.LicenseData = self.licenses[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LicenseCell *cell = [tableView dequeueReusableCellWithIdentifier:LicenseCellIdentifier];
    cell.LicenseData = self.licenses[indexPath.row];
    
    if([cell.LicenseData[TypeKey] isEqualToString:@"Image"]){
        return 125.f;
    }
    
    return cell.cellHeight;
}

#pragma mark -

- (NSArray*)licenseData
{
    return @[
             @{TitleKey: @"AFNetworking",
               TypeKey:@"Library",
               CopyrightKey: @"Copyright (c) 2013-2015 AFNetworking (http://afnetworking.com/)",
               DescriptionKey: @"Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the \"Software\"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\n\nThe above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.\n\nTHE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE."},

             @{TitleKey: @"Parse",
               TypeKey:@"Library",
               CopyrightKey: @"Copyright © 2015 Parse",
               DescriptionKey: @"https://www.parse.com/about/terms\n\n7.1 Parse grants you a revocable, personal, worldwide, royalty-free, non-assignable and non-exclusive license to use the software provided to you by Parse as part of the Parse Services as provided to you by Parse. This license is for the sole purpose of enabling you to use and enjoy the benefit of the Parse Services as provided by Parse, in the manner permitted by the Terms.7.2 You may not (and you may not permit anyone else to): (a) copy, modify, create a derivative work of, reverse engineer, decompile or otherwise attempt to extract the source code of the Parse Services or any part thereof, unless this is expressly permitted or required by law, or unless you have been specifically told that you may do so by Parse, in writing (e.g., through an open source software license); (b) attempt to disable or circumvent any security mechanisms used by the Parse Services or any applications running on the Parse Services; or (c) use the Parse Services in any way that may subject the Parse Services to any obligations under any open source software license, including, without limitation any license which imposes any obligation or restriction with respect to Parse’s patent or other intellectual property rights in the Parse Services.7.3 Open source software licenses for components of the Parse Services released under an open source license constitute separate written agreements. To the limited extent that the open source software licenses expressly supersede these Terms, the open source licenses govern your agreement with Parse for the use of the components of the Parse Services released under an open source license. "},

             @{TitleKey: @"Toast for iOS",
               TypeKey:@"Library",
               CopyrightKey: @"Copyright (c) 2013 Charles Scalesse.",
               DescriptionKey: @"Permission is hereby granted, free of charge, to any person obtaining acopy of this software and associated documentation files (the \"Software\"), to deal in the Software without restriction, includingwithout limitation the rights to use, copy, modify, merge, publish,\ndistribute, sublicense, and/or sell copies of the Software, and topermit persons to whom the Software is furnished to do so, subject to\nthe following conditions:\n    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.\n\nTHE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,        TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE."},

             @{TitleKey: @"MRProgress",
               TypeKey:@"Library",
               CopyrightKey: @"Copyright (c) 2013 Marius Rackwitz git@mariusrackwitz.de",
               DescriptionKey: @"The MIT License\n\nPermission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the \"Software\"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\n\nThe above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.\n\nTHE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE."},

             @{TitleKey: @"FXBlurView",
               TypeKey:@"Library",
               CopyrightKey: @"Copyright (C) 2013 Charcoal Design",
               DescriptionKey: @"This software is provided 'as-is', without any express or implied warranty. In no event will the authors be held liable for any damages arising from the use of this software.\n\nPermission is granted to anyone to use this software for any purpose, including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:\n\nThe origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.\nAltered source versions must be plainly marked as such, and must not be misrepresented as being the original software.\nThis notice may not be removed or altered from any source distribution."},

             ];
}

@end
