//
//  NumericTweakTableViewCell
//  Copyright (c) 2016 Just Eat Holding Ltd. All rights reserved.
//

#if canImport(UIKit)
import UIKit

class NumericTweakTableViewCell: TextTweakTableViewCell {
    
    override var keyboardType: UIKeyboardType {
        get {
            return .numberPad
        }
    }

}

#endif
