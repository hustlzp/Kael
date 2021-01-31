//
//  KaelTableViewSnapshot.swift
//  KaelTableViewSnapshot
//
//  Created by zhipeng liu on 2021/1/25.
//

import Foundation

public class KaelTableViewSnapshot {
    private(set) var sections: [KaelTableViewSection]
    
    public init(_ sections: [KaelTableViewSection] = []) {
        self.sections = sections
    }
    
    public static func Snapshot(@KaelTableViewSectionsBuilder builder: () -> [KaelTableViewSection]) -> KaelTableViewSnapshot {
        let snapshot = KaelTableViewSnapshot()
        snapshot.sections = builder()
        return snapshot
    }

    public init(@KaelTableViewSectionsBuilder builder: () -> [KaelTableViewSection]) {
        self.sections = builder()
    }

    public func getSection(_ section: Int) -> KaelTableViewSection? {
        guard section < sections.count,
              section >= 0 else {
            return nil
        }
        return sections[section]
    }
    
    public func getRow(_ indexPath: IndexPath) -> KaelTableViewRow? {
        guard let section = getSection(indexPath.section) else { return nil }
        guard indexPath.row < section.rows.count,
              indexPath.row >= 0 else {
            return nil
        }
        return section.rows[indexPath.row]
    }
    
    @discardableResult
    public func config(_ handler: (KaelTableViewSnapshot) -> Void) -> KaelTableViewSnapshot {
        handler(self)
        return self
    }

    @discardableResult
    public func addSection(_ sectionConfigor: (KaelTableViewSection) -> Void) -> KaelTableViewSnapshot {
        let section = KaelTableViewSection()
        sectionConfigor(section)
        sections.append(section)
        return self
    }
}

public class KaelTableViewSection {
    private(set) var rows: [KaelTableViewRow]
    private(set) var header: KaelTableViewSectionHeader?
    private(set) var footer: KaelTableViewSectionFooter?
    
    var isEmpty: Bool {
        return rows.count == 0 && header == nil && footer == nil
    }

    static let empty = KaelTableViewSection(rows: [], header: nil, footer: nil)

    public init(
        rows: [KaelTableViewRow] = [],
        header: KaelTableViewSectionHeader? = nil,
        footer: KaelTableViewSectionFooter? = nil
    ) {
        self.rows = rows
        self.header = header
        self.footer = footer
    }

    public init(@KaelTableViewRowsBuilder builder: () -> [KaelTableViewSectionElement]) {
        let elements = builder()
        self.rows = elements.compactMap({ $0 as? KaelTableViewRow })
        self.header = elements.compactMap({ $0 as? KaelTableViewSectionHeader }).last
        self.footer = elements.compactMap({ $0 as? KaelTableViewSectionFooter }).last
    }

    @discardableResult
    public func addRow(
        _ cellFactory: @escaping () -> UITableViewCell?,
        _ action: ((IndexPath) -> Void)? = nil
    ) -> KaelTableViewSection {
        let row = KaelTableViewRow(cellFactory, action)
        rows.append(row)
        return self
    }

    @discardableResult
    public func addHeader(
        _ viewFactory: @escaping () -> UIView?,
        _ height: CGFloat
    ) -> KaelTableViewSection {
        let header = KaelTableViewSectionHeader(viewFactory, height)
        self.header = header
        return self
    }

    @discardableResult
    public func addFooter(
        _ viewFactory: @escaping () -> UIView?,
        _ height: CGFloat
    ) -> KaelTableViewSection {
        let footer = KaelTableViewSectionFooter(viewFactory, height)
        self.footer = footer
        return self
    }
}

public protocol KaelTableViewSectionElement {}

public class KaelTableViewSectionElementEmpty: KaelTableViewSectionElement {
}

public class KaelTableViewSectionHeader: KaelTableViewSectionElement {
    var viewFactory: () -> UIView?
    var height: CGFloat
    
    public init(_ viewFactory: @escaping () -> UIView?, _ height: CGFloat) {
        self.viewFactory = viewFactory
        self.height = height
    }
}

public class KaelTableViewSectionFooter: KaelTableViewSectionElement {
    var viewFactory: () -> UIView?
    var height: CGFloat
    
    public init(_ viewFactory: @escaping () -> UIView?, _ height: CGFloat) {
        self.viewFactory = viewFactory
        self.height = height
    }
}

public class KaelTableViewRow: KaelTableViewSectionElement {
    var cellFactory: () -> UITableViewCell?
    var action: ((IndexPath) -> Void)?

    public init(_ cellFactory: @escaping () -> UITableViewCell?, _ action: ((IndexPath) -> Void)? = nil) {
        self.cellFactory = cellFactory
        self.action = action
    }
}
