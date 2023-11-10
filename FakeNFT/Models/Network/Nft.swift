import Foundation

struct Nft: Decodable {
    let id: String
    let name: String
    let images: [URL]
    let rating: Int
    let price: Float
    let author: String
    
    init(id: String, name: String, images: [URL], rating: Int, price: Float, author: String) {
        self.id = id
        self.name = name
        self.images = images
        self.rating = rating
        self.price = price
        self.author = author
    }
    init() {
        self.id = String()
        self.name = String()
        self.images = [URL(fileURLWithPath: String())]
        self.rating = Int()
        self.price = Float()
        self.author = String()
    }
}
