//
//  KaelTableViewDataSource.swift
//  KaelTableViewDataSource
//
//  Created by zhipeng liu on 2021/1/25.
//

@objc public protocol KaelTableViewDataSourceDelegate: AnyObject {
}

public class KaelTableViewDataSource: NSObject {
    weak var delegate: KaelTableViewDataSourceDelegate?
    private weak var tableView: UITableView?
    private var snapshot = KaelTableViewSnapshot()
    
    public init(tableView: UITableView) {
        self.tableView = tableView
        super.init()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    public func apply(_ snapshot: KaelTableViewSnapshot) {
        self.snapshot = snapshot
        tableView?.reloadData()
    }
}

extension KaelTableViewDataSource: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return snapshot.sections.count
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section < snapshot.sections.count, section >= 0 else { return 0 }
        return snapshot.sections[section].rows.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let rowObject = snapshot.getRow(indexPath) else {
            return UITableViewCell()
        }
        return rowObject.cellFactory() ?? UITableViewCell()
    }
}

extension KaelTableViewDataSource: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cellObject = snapshot.getRow(indexPath) else { return }
        cellObject.action?(indexPath)
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let section = snapshot.getSection(section) else {
            return .leastNormalMagnitude
        }
        return section.header?.height ?? .leastNormalMagnitude
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let section = snapshot.getSection(section) else {
            return nil
        }
        return section.header?.viewFactory()
    }

    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let section = snapshot.getSection(section) else {
            return .leastNormalMagnitude
        }
        return section.footer?.height ?? .leastNormalMagnitude
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let section = snapshot.getSection(section) else {
            return nil
        }
        return section.footer?.viewFactory()
    }
}
