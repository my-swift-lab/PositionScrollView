//
//  Sample.swift
//  PositionScrollViewExample
//
//  Created by 松本和也 on 2020/04/02.
//  Copyright © 2020 松本和也. All rights reserved.
//

import Foundation

import SwiftUI

/// Extended ScrollView which can controll position
public struct SampleView: View {
    var pageSize = CGSize(width: 200, height: 200)
    var colors = Color.sGradation()
    // 本来viewModelをPositionScrollViewないに含めて、↓のDelegateで変更を検知するインターフェースにしたいが、その変更を検知して親Viewで再renderするとPositionScrollViewが初期化されてスクロールがうまくいかなくなるのでStateを親から渡している。
    // → 多分PositionScrollView自体がviewModelを@ObservedObjectとして持っているから
    @ObservedObject var viewModel = PositionScrollViewModel(
        pageSize: CGSize(width: 200, height: 200),
        horizontalScroll: Scroll(
            scrollSetting: ScrollSetting(
                pageCount: 6,
                pageSize: 200,
                afterMoveType: .unit
            )
        )
    )
    
    init() {
        viewModel.horizontalScroll?.scrollSetting.positionScrollDelegate = self
    }
    
    public var body: some View {
        return VStack {
            PositionScrollView(viewModel: self.viewModel) {
                HStack(spacing: 0) {
                    ForEach(0...5, id: \.self){ i in
                        ZStack {
                            Rectangle()
                                .fill(self.colors[i])
                                .frame(
                                    width: self.pageSize.width, height: self.pageSize.height
                            )
                            Text("page\(i)")
                        }
                    }
                    
                }
            }
            VStack {
                Text("position: \(self.viewModel.horizontalScroll!.position)")
                Text("page: \(self.viewModel.horizontalScroll!.page)")
                Text("unit: \(self.viewModel.horizontalScroll!.unit)")
                Text("positionInUnit: \(self.viewModel.horizontalScroll!.positionInUnit)")
            }
        }
    }
    
    struct SampleView_Previews: PreviewProvider {
        static var previews: some View {
            return SampleView()
        }
    }
}

extension SampleView: PositionScrollViewDelegate {
    public func onScrollEnd() {
        print("onScrollEnd")
    }
    
    public func onChangePage(page: Int) {
        print("onChangePage")
//        self.positionInfo.page = page
    }
    
    public func onChangeUnit(unit: Int) {
        print("onChangeUnit")
//        self.positionInfo.unit = unit
    }
    
    public func onChangePositionInUnit(positionInUnit: CGFloat) {
//        self.positionInfo.positionInUnit = positionInUnit
    }
    
    public func onChangePosition(position: CGFloat) {
//        self.position = position
    }
}
