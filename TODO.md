# ProductDetailsViewModel

private let product : Product

private let ratingManager: RatingManager

init(product: Product, ratingManager: RatingManager = .shared) {
self.product = product
self.ratingManager = ratingManager
}

### functions

saveUserFeedback(for productID: Int, rating: Int, comment: String) {
ratingManager.addRating(ProductRating(rating: Int, comment: comment), for product)
if let index =  products.filterIndex(where : { $0.id == productID })
}

# ProductListViewModel

# Like Manager

# RatingManager

# UserDefaultsManager

## Likes

### Functions
isProductLiked() -> Bool


## Rating

saveRating(score: Int, comment: String for: Product)

updateAverageRating

# RatingRepository

# ProductRating
