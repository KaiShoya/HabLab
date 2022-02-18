class Tag {
  final int id;
  final String tag;
  Tag(this.id, this.tag);
}

List<Tag> Tags() {
  return [
    Tag(0, '株式'),
    Tag(1, 'FX'),
    Tag(2, '仮想通貨'),
    Tag(3, 'ギャンブル'),
  ];
}

final _tags = Tags();
