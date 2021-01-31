//
//  KaelTableViewFunctionBuilder.swift
//  KaelTableViewFunctionBuilder
//
//  Created by zhipeng liu on 2021/1/30.
//

import Foundation

@_functionBuilder
public struct KaelTableViewSectionsBuilder {
    public static func buildBlock(_ sections: KaelTableViewSection...) -> [KaelTableViewSection] {
        return sections.filter({ !$0.isEmpty })
    }
    
    public static func buildBlock(_ section: KaelTableViewSection) -> KaelTableViewSection {
        return section
    }

    public static func buildIf(_ value: KaelTableViewSection?) -> KaelTableViewSection {
        return value ?? KaelTableViewSection.empty
    }
    
    public static func buildEither(first: KaelTableViewSection) -> KaelTableViewSection {
        first
    }

    public static func buildEither(second: KaelTableViewSection) -> KaelTableViewSection {
        second
    }
}

@_functionBuilder
public struct KaelTableViewRowsBuilder {
    public static func buildBlock(_ elements: KaelTableViewSectionElement...) -> [KaelTableViewSectionElement] {
        return elements.filter({ !($0 is KaelTableViewSectionElementEmpty.Type) })
    }
    
    public static func buildBlock(_ element: KaelTableViewSectionElement) -> KaelTableViewSectionElement {
        return element
    }

    public static func buildIf(_ value: KaelTableViewSectionElement?) -> KaelTableViewSectionElement {
        return value ?? KaelTableViewSectionElementEmpty()
    }

    public static func buildEither(first: KaelTableViewSectionElement) -> KaelTableViewSectionElement {
        first
    }

    public static func buildEither(second: KaelTableViewSectionElement) -> KaelTableViewSectionElement {
        second
    }
}
