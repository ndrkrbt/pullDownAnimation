//
//  UIGesture+Extension.swift
//  TempAnimation
//
//  Created by Andrey on 12/08/2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import UIKit

extension UIPanGestureRecognizer {
    enum GestureDirection {
        case up
        case down
        case left
        case right
        case stop
    }

    func verticalDirection(target: UIView) -> GestureDirection {
        if self.velocity(in: target).y == 0 {
            return .stop
        }
        return self.velocity(in: target).y > 0 ? .down : .up
    }

    func horizontalDirection(target: UIView) -> GestureDirection {
        if self.velocity(in: target).x == 0 {
            return .stop
        }
        return self.velocity(in: target).x > 0 ? .right : .left
    }
}

