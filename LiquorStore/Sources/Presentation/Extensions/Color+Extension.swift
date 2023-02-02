import SwiftUI

extension Color {
    init(r: Double, g: Double, b: Double) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0)
    }

    static var moth: Color { .init("Moth") }
    static var cappuccino: Color { .init("Cappuccino") }
    static var hinterlandsGreen: Color { .init("HinterlandsGreen") }
    static var raceCarRed: Color { .init("RaceCarRed") }
}
