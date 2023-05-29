//
//  BDIMDebugModelProtocal.h
//  ByteBusiness
//
//  Created by Weibai on 2022/10/13.
//  Copyright © 2022 loulan. All rights reserved.
//

#ifndef BDIMDebugModelProtocal_h
#define BDIMDebugModelProtocal_h

@protocol BDIMDebugModelProtocal <NSObject>

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, assign) BOOL enable;

@property (nonatomic, copy) void(^click)(void);

@end

#endif /* BDIMDebugModelProtocal_h */
