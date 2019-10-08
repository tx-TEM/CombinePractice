import UIKit
import Combine

func asyncProcess(number: Int, completion: (_ number: Int) -> Void) {
    print("#\(number) Start")
    sleep((arc4random() % 100 + 1) / 100)
    completion(number)
}

var publisher1 = Future<String, Error> { promise in
    print("publisher1スタート")
    promise(.success("synchronous1"))
}
var publisher2 = Future<String, Error> { promise in
    print("publisher2スタート")
    promise(.success("synchronous2"))
}

var publisher3 = Future<String, Error> { promise in
    print("publisher3スタート")
    asyncProcess(number: 10, completion: { _ in
        promise(.success("asynchronous"))
    })
}


let _ = publisher1.merge(with: publisher2, publisher3)
    .sink(receiveCompletion: { completion in
        switch completion {
        case .finished:
            print("finish")
        case .failure(_):
            print("error")
        }

    }, receiveValue: { value in
        print(value)
    })

