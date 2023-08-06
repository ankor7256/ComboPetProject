// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen
import UIKit.UIImage


// swiftlint:disable superfluous_disable_command
// swiftlint:disable identifier_name line_length nesting type_body_length type_name file_length
internal enum Asset {
    internal static var launchLogo: UIImage {
        return image(named: "launchLogo")
    }
    internal static var user: UIImage {
        return image(named: "user")
    }

    // swiftlint:disable trailing_comma
    internal static let allImages: [UIImage] = [
        launchLogo,
        user,
    ]

    private static func image(named name: String) -> UIImage {
        let bundle = Bundle(for: BundleToken.self)
        guard let image = UIImage(named: name, in: bundle, compatibleWith: nil) else {
            fatalError("Unable to load image named \(name).")
        }
        return image
    }
}

private final class BundleToken {}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name file_length
