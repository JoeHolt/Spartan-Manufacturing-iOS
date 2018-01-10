#  Spartan Manufacturing iOS

An iOS front end to the Spartan Manufacturing web service. This was an adition to my Spartan Manufacturing project that was made purely for my enjoyment as we have no method to deploy iOS app's to student's devices at McFarland (we would need an enterprise development cert)

# Learnign Goals

My goal with this was to improve my knowlage on making GET/POST requests from iOS apps aswell as working with the correct thread and async code.

# Features (Some are not yet update to match backend changes)

- View all products
- View all orders
- Add product
- Delete product
- Delete order
- Modify order
- Modify inventory
- Fully thred and async sage

# Running the app

Simply download this project, open it in Xcode, resolve signing issues and deploy it to device. You will likely need to change the data url if you want to use your own custom database with this. It is currently pointing to an AWS server that is used for McFarland's Spartan Manufacturing class. The line of code you need to change is:

```swift
let urlString = "http://192.169.0.1"
```

in /SpartanManufacturing/Model/APIHelper.swift

# Questions

If you have any questions feel free to contact me on github. If you would like to help out, feel free to make a pull request.
