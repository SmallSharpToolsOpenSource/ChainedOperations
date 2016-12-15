//
//  AsyncOperation.swift
//  ChainedOperations
//
//  Created by Brennan Stehling on 4/24/16.
//  Copyright © 2016 Acme. All rights reserved.
//

import UIKit

enum AsyncOperationState {
    case None
    case Ready
    case Executing
    case Cancelled
    case Finished
}

public class AsyncOperation: NSOperation {

    var state : AsyncOperationState = .None

}
