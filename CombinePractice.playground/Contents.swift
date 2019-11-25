import UIKit
import Combine

func asyncProcess(number: Int, completion: (_ number: Int) -> Void) {
    print("#\(number) 秒スリープ")
    sleep(UInt32(number))
    completion(number)
}

var publisher1 = Deferred {
    Future<String, Error> { promise in
        print("publisher1スタート")
        asyncProcess(number: 3, completion: { _ in
            promise(.success("asynchronous"))
        })
        print("publisher1終了")
    }
}.eraseToAnyPublisher()

var publisher2 = Deferred {
    Future<String, Error> { promise in
        print("publisher2スタート")
        asyncProcess(number: 5, completion: { _ in
            promise(.success("publisher2の結果"))
        })
        print("publisher2終了")
    }
}.eraseToAnyPublisher()

//var publisher3 = Future<String, Error> { promise in
//    print("publisher3スタート")
//    promise(.success("synchronous2"))
//}.eraseToAnyPublisher()

let _ = publisher1.flatMap { (text) in
    return publisher2
}.sink(receiveCompletion: { completion in
    switch completion {
        case .finished:
            print("finish")
        case .failure(_):
            print("error")
    }

}, receiveValue: { value in
    print(value)
})

//let _ = publisher1.merge(with: publisher2, publisher3)
//    .sink(receiveCompletion: { completion in
//        switch completion {
//            case .finished:
//                print("finish")
//            case .failure(_):
//                print("error")
//        }
//
//    }, receiveValue: { value in
//        print(value)
//    })

