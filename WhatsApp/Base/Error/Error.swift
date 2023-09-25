typealias StatusCode = Int

enum AppErrorType {
    case noInternet
    case server
    case generic
}

class AppError: Error {
    var statusCode: StatusCode?
    
    var isRetryable: Bool {
        false
    }
    
    var message: String {
        "Ошибка"
    }
    
    var type: AppErrorType {
        .generic
    }
}

class NetworkingError: AppError {
    init(statusCode: StatusCode?) {
        super.init()
        self.statusCode = statusCode
    }
}

class NoInternetError: NetworkingError {
    override var message: String {
        "Нет интернета"
    }
    
    override var isRetryable: Bool {
        true
    }
    
    override var type: AppErrorType {
        .noInternet
    }
}

class DecodingError: NetworkingError {
    override var message: String {
        "Ошибка декодинга"
    }
    
    override var type: AppErrorType {
        .server
    }
}

class ServerError: NetworkingError {
    override var message: String {
        "Ошибка сервера"
    }
    
    override var type: AppErrorType {
        .server
    }
}
