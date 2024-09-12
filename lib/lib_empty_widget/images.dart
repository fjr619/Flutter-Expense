enum PackageImage {
  Image_1,
  Image_2,
  Image_3,
  Image_4,
}

const _packageImageTypeMap = {
  PackageImage.Image_1: 'assets/images/emptyImage.png',
  PackageImage.Image_2: 'assets/images/im_emptyIcon_1.png',
  PackageImage.Image_3: 'assets/images/im_emptyIcon_2.png',
  PackageImage.Image_4: 'assets/images/im_emptyIcon_3.png',
};

extension Convert on PackageImage? {
  String? encode() => _packageImageTypeMap[this!];

  PackageImage? key(String value) => decodePackageImage(value);

  PackageImage? decodePackageImage(String value) {
    return _packageImageTypeMap.entries
        .singleWhere((element) => element.value == value)
        .key;
  }
}
