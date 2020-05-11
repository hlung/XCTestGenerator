import Foundation

struct SimpleStruct {
  let foo: String = "foo!"
  let bar: String? = "bar"
}

struct SimpleClass {
  let foo: String = "foo!"
  let bar: String? = "bar"
}

class Media {
  let name: String = "Some media"
  let array: [String] = ["foo", "bar"]
  // note: printing a dictionary randomizes order, making test fails sometimes.
  // so just test with one entry for now.
  let stringDict: [String: String] = ["en": "Hi"]
}

class Episode: Media {
  let number: Int = 42
  let intDict: [String: Int]? = ["en": 11]
  let someOptional: String? = "some optional"
  let someNil: String? = nil
  let date: Date = Date(timeIntervalSince1970: 12345)
  let bool: Bool = true
  let url: URL = URL(string: "https://www.google.com")!
  let simpleStruct = SimpleStruct()
  let simpleClass: SimpleClass? = SimpleClass()
}

struct VeryLongPropertyStruct {
  let string = "During the time of the Chinese Northern Qi dynasty, a lady-in-waiting could never become a princess because of the rigid social hierarchy and the actions of many jealous rivals. Lu Zhen (Zhao Li Ying) flees from an arranged marriage and her evil stepmother and enters the palace as an attendant. She meets Prince Gao Zhan (Chen Xiao), and the two fall in love but know that their social differences would never allow them to marry."
}
