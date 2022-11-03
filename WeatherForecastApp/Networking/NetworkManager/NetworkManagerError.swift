
import Foundation

enum NetworkManagerError: Error {
    case errorStatusCode
    case errorMimeType
    case errorUrl
    case errorServer
    case errorParseJSON
    case errorInstanceDestroyed
}
