//
//  GenericTagView.swift
//  MMTagView
//
//  Created by Миляев Максим on 08.04.2024.
//

import SwiftUI

@available(iOS 15.0, *)
public struct AnyContentView<T: View,B:View, SelectableContent: Hashable>: View {
    
    public var sourceContent: [SelectableContent]
    @State private var identableContent: [(SelectableContent, Int)] = []
    
    @Binding public var selectedContent: [SelectableContent]
    @State private var selectedCases: [(SelectableContent,Int)] = []
    @State public var allCases: [(SelectableContent,Int)] = []
    
    @State private var editMode: Bool = false
    
    @State private var totalHeight: Double = .zero
    
    @ViewBuilder public var backgroundView: () -> B
    @ViewBuilder public var cellView: (SelectableContent) -> T
    
    public var horizontalPadding: Double = 4
    public var verticalPadding: Double = 4
    public var promptPlaceholder: String = "Make choise  "
    public var freezePosition: Bool = true
    
    @Namespace var tagPositionNameSpace
    

    
    public init(sourceContent: [SelectableContent], selectedContent: Binding<[SelectableContent]>, selectedCases: [(SelectableContent, Int)] = [], allCases: [(SelectableContent, Int)] = [], backgroundView: @escaping () -> B, cellView: @escaping (SelectableContent) -> T) {
        self.sourceContent = sourceContent
        self._selectedContent = selectedContent
        self.selectedCases = selectedCases
        self.allCases = allCases
        
        self.backgroundView = backgroundView
        self.cellView = cellView
    }
    
    public var body: some View {
        VStack{
            VStack {
                GeometryReader { g in
                    var width = Double.zero
                    var height = Double.zero
                    ZStack(alignment: .topLeading) {
                        Text(promptPlaceholder)
                            .opacity((selectedCases.isEmpty && !editMode) ? 1 : 0)
                        
                        ForEach(allCases.indices, id: \.self) { index in
                            cellView(allCases[index].0)
                                .id(allCases[index].1)
                                .padding(.horizontal, horizontalPadding)
                                .padding(.vertical, verticalPadding)
                                .matchedGeometryEffect(id:allCases[index].1, in: tagPositionNameSpace)
                                .alignmentGuide(.leading, computeValue: { d in
                                    if (abs(width - d.width) > g.size.width) {
                                        width = 0
                                        height -= d.height
                                    }
                                    let result = width
                                    if allCases[index].1 == allCases.last!.1 {
                                        width = 0 //last item
                                    } else {
                                        width -= d.width
                                    }
                                    return result
                                })
                                .alignmentGuide(.top, computeValue: {d in
                                    let result = height
                                    if allCases[index].1 ==  allCases.last!.1 {
                                        height = 0 // last item
                                    }
                                    return result
                                })
                                .opacity(isSelected(element: allCases[index]) ? 1 : 0.5)
                                .onTapGesture {
                                    withAnimation {
                                        if editMode{
                                            tap(element: allCases[index])
                                        }
                                    }
                                }
                        }
                    }
                    .background {
                        GeometryReader { geometry in
                            Color.clear.preference(key: AnyContentViewSizePreferenceKey.self, value: geometry.size)
                        }
                    }
                    .onPreferenceChange(AnyContentViewSizePreferenceKey.self, perform: {
                        self.totalHeight = $0.height
                    })
                }
            }
            .frame(height: totalHeight)
            .padding()
            .background {
                backgroundView()
            }
            
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)){
                    editMode.toggle()
                    allCases = editMode ? identableContent : filteredContent()
                    selectedContent = selectedCases.map { $0.0 }
                }
            }, label: {
                Text(editMode ? "Done":"Edit")
                    .fixedSize()
                    .padding(5)
                    .padding(.horizontal,40)
                    .background {
                        RoundedRectangle(cornerRadius: 8).fill(.ultraThickMaterial)
                    }
            })
        }
        .onAppear {
            for (index, element) in sourceContent.enumerated(){
                identableContent.append((element, index))
            }
        }
    }
    
    private func filteredContent() -> [(SelectableContent,Int)]{
        if freezePosition {
            return identableContent.filter { el in
                selectedCases.contains { $0.1 == el.1
                }
            }
        } else {
            return selectedCases
        }
    }
    
    private func isSelected(element: (SelectableContent, Int)) -> Bool {
        return selectedCases.contains { el in
            el == element
        }
    }
    
    // MARK: - selection handler
    private func tap(element: (SelectableContent,Int)){
        if selectedCases.contains(where: { el in
            el == element
        }) {
            selectedCases.removeAll { el in
                el == element
            }
        } else {
            self.selectedCases.append(element)
        }
    }
}

//#Preview {
//    ContentView()
//}

// MARK: - size preference key

public struct AnyContentViewSizePreferenceKey: PreferenceKey{
    public static let defaultValue: CGSize = .zero
    public static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        
    }
}
