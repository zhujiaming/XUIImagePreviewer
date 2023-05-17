### XUIImagePreviewer

 使用swift实现的iOS端图片预览工具

### Main Class

`UIImagePreviewController`

Params: 
- `imageArray` : UIImage Array
- `position` : the location of the first image to be displayed
- `bgColor` : page background color


### Usage

```swift
 self?.navigationController?.pushViewController(UIImagePreviewController(imageArray: targets, bgColor: .black), animated: true)
```

### SnapShot

![demo](./snapshot/1.png)
