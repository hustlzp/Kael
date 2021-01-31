# Kael

[![Kael](https://static.wikia.nocookie.net/dota2_gamepedia/images/7/7d/Invoker_minimap_icon.png/revision/latest/scale-to-width-down/32?cb=20120717000939)]

> I am a beacon of knowledge blazing out across a black sea of ignorance.
> from Carl, the Invoker

Build UI with the power of Function Builder.

[![CI Status](https://img.shields.io/travis/hustlzp/Kael.svg?style=flat)](https://travis-ci.org/hustlzp/Kael)
[![Version](https://img.shields.io/cocoapods/v/Kael.svg?style=flat)](https://cocoapods.org/pods/Kael)
[![License](https://img.shields.io/cocoapods/l/Kael.svg?style=flat)](https://cocoapods.org/pods/Kael)
[![Platform](https://img.shields.io/cocoapods/p/Kael.svg?style=flat)](https://cocoapods.org/pods/Kael)

## Installation

Kael is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Kael'
```

## Usage

Firstly, define your dataSource:

```swift
private lazy var dataSource: KaelTableViewDataSource = {
    let dataSource = KaelTableViewDataSource(tableView: tableView)
    return dataSource
}()
```

then build `KaelTableViewSnapshot` like Kael, example:

```swift
private func createSnapshot() -> KaelTableViewSnapshot {
    typealias Section = KaelTableViewSection
    typealias SectionHeader = KaelTableViewSectionHeader
    typealias SectionFooter = KaelTableViewSectionFooter
    typealias Row = KaelTableViewRow

    return KaelTableViewSnapshot {
        Section {
            SectionHeader({ [weak self] in
                return self?.createSectionHeader()
            }, 40)

            Row({ [weak self] in
                return self?.createCell()
            }, { [weak self] _ in
                // do something
            })
            
            SectionFooter({ [weak self] in
                return self?.createSectionFooter()
            }, 20)
        }

        Section {
            SectionHeader({ [weak self] in
                return self?.createSectionHeader()
            }, 40)

            Row({ [weak self] in
                return self?.createCell()
            }, { [weak self] _ in
                // do something
            })

            if rowConditionCheck() {
                Row({ [weak self] in
                    return self?.createCell()
                }, { [weak self] _ in
                    // do something
                })
            } else {
                Row({ [weak self] in
                    return self?.createCell()
                }, { [weak self] _ in
                    // do something
                })
            }
        }

        if sectionConditionCheck() {
            Section {
                SectionHeader({ [weak self] in
                    return self?.createSectionHeader()
                }, 40)

                Row({ [weak self] in
                    return self?.createCell()
                }, { [weak self] _ in
                    // do something
                })
            }
        } 
    }
}
```

finally, apply the snapshot to data source:

```swift
dataSource.apply(createSnapshot())
```

## References

* Proposal: [SE-0289](https://github.com/apple/swift-evolution/blob/main/proposals/0289-result-builders.md)

## Author

hustlzp, hustlzp@qq.com

## License

Kael is available under the MIT license. See the LICENSE file for more info.
