
import Foundation

enum LogEvent: String {
    case e = "[‼️]"   // error
    case i = "[ℹ️]"   // info
    case d = "[💬]"   // debug
    case v = "[🔬]"   // verbose
    case w = "[⚠️]"   // warning
    case u = "[🌎]"   // url
    case rq = "[📲]"   // Request
    case rs = "[🤷]"   // Response
    case er = "[😡🙅😡]"   // Error_Response
    case ss = "[🥶🔌🥶🔌🥶]"
    case sr = "[🥶🔌🤷🔌🥶]"
}

class Log {
    static var dateFormat = "yyyy-MM-dd hh:mm:ssSSS"
    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter
    }
    
    private static var isLoggingEnabled: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
    
    class func e( _ object: Any, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
        if isLoggingEnabled {
            print("\(Date().toString()) \(LogEvent.e.rawValue)[\(sourceFileName(filePath: filename))]:\(line) \(column) \(funcName) -> \(object)")
        }
    }
    
    class func i ( _ object: Any, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
        if isLoggingEnabled {
            print("\(Date().toString()) \(LogEvent.i.rawValue)[\(sourceFileName(filePath: filename))]:\(line) \(column) \(funcName) -> \(object)")
        }
    }
    
    class func d( _ object: Any, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
        if isLoggingEnabled {
            print("\(Date().toString()) \(LogEvent.d.rawValue)[\(sourceFileName(filePath: filename))]:\(line) \(column) \(funcName) -> \(object)")
        }
    }
    
    class func v( _ object: Any, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
        if isLoggingEnabled {
            print("\(Date().toString()) \(LogEvent.v.rawValue)[\(sourceFileName(filePath: filename))]:\(line) \(column) \(funcName) -> \(object)")
        }
    }
    
    class func w( _ object: Any, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
        if isLoggingEnabled {
            print("\(Date().toString()) \(LogEvent.w.rawValue)[\(sourceFileName(filePath: filename))]:\(line) \(column) \(funcName) -> \(object)")
        }
    }
    
    class func u( _ object: Any, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
        if isLoggingEnabled {
            print("\(Date().toString()) \(LogEvent.u.rawValue)[\(sourceFileName(filePath: filename))]:\(line) \(column) \(funcName) -> \(object)")
        }
    }
    
    class func rq(url : String = "" , _ object: Any, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
         if isLoggingEnabled {
             print("\(Date().toString()))[\(sourceFileName(filePath: filename))]: \(LogEvent.rq.rawValue) ==> \(url) ===> \(object)")
         }
     }
    
    class func rs(url : String = "" , _ object: Any, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
         if isLoggingEnabled {
             print("\(Date().toString()))[\(sourceFileName(filePath: filename))]: \(LogEvent.rs.rawValue) ==> \(url) ===> \(object)")
         }
     }
    
    class func er(url : String = "" , _ object: Any, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
         if isLoggingEnabled {
             print("\(Date().toString()))[\(sourceFileName(filePath: filename))]: \(LogEvent.er.rawValue) ==> \(url) ===> \(object)")
         }
     }
    
    class func ss( _ object: Any, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
        if isLoggingEnabled {
            print("\(Date().toString()))[\(sourceFileName(filePath: filename))]: \(LogEvent.ss.rawValue) ==> ===> \(object)")
        }
    }
    class func sr( _ object: Any, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
         if isLoggingEnabled {
             print("\(Date().toString()))[\(sourceFileName(filePath: filename))]: \(LogEvent.sr.rawValue) ==> ===> \(object)")
         }
     }
    private class func sourceFileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.isEmpty ? "" : components.last!
    }
}

extension Date {
    func toString() -> String {
        return Log.dateFormatter.string(from: self as Date)
    }
}
