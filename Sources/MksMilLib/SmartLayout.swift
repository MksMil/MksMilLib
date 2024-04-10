//
//  SmartLayout.swift
//  MMTagView
//
//  Created by Миляев Максим on 09.04.2024.
//

import SwiftUI

// MARK: - Any View and Size Grid Layout
@available(iOS 16.0, *)
public struct SmartLayout: Layout{
    
    var hSpacing: Double
    var vSpacing: Double
    
    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        guard !subviews.isEmpty else { return proposal.replacingUnspecifiedDimensions() }
        let totalWidth = proposal.width ?? proposal.replacingUnspecifiedDimensions().width
        var width = Double.zero
        var height = subviews.isEmpty ? 0: subviews[0].sizeThatFits(.unspecified).height
        var maxAddedHeight = Double.zero
        var firstElementHeight: Double = subviews[0].sizeThatFits(.unspecified).height
        
        for index in subviews.indices{
            let size = subviews[index].sizeThatFits(.unspecified)
            if (width + size.width) > totalWidth {
                //next row
                if index == subviews.count - 1 {
                    // if last
                    height += maxAddedHeight + size.height
                } else {
                    width = size.width
                    maxAddedHeight = size.height
                    height += maxAddedHeight + vSpacing
                    firstElementHeight = size.height
                }
                
            } else {
                //current row
                if index == subviews.count - 1 {
                    //if last
                    height -= firstElementHeight
                    maxAddedHeight = max(maxAddedHeight, size.height)
                    height += maxAddedHeight
                } else {
                    width += size.width + hSpacing
                    maxAddedHeight = max(maxAddedHeight, size.height)
                }
            }
        }
        return CGSize(width: totalWidth, height: height)
    }
    
    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var point = bounds.origin
        let maxX = bounds.width + bounds.origin.x
        var maxAddedHeight = Double.zero
        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if (point.x + size.width) <= maxX {
                //current row
                subview.place(at: point, anchor: .topLeading, proposal: .unspecified)
                point.x += size.width + hSpacing
                maxAddedHeight = max(maxAddedHeight, size.height)
            } else {
                //next row
                point.x = bounds.origin.x
                point.y += maxAddedHeight + vSpacing
                maxAddedHeight = size.height
                subview.place(at: point, anchor: .topLeading, proposal: .unspecified)
                point.x += size.width + hSpacing
            }
        }
    }
}
