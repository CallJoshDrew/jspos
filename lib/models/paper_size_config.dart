enum PaperSizeConfig {
  mm58(
    orderTypeWidth: 280,
    orderTimeWidth: 280,
    qtyWidth: 330,
    dottedLineWidth: '--------------------------------',
    itemQtyWidth: 300,
    totalWidth: 240,
    totalDottedLineWidth: 220,
    totalQtyWidth: 300,
    lastDottedLineWidth: '-------------',
  ),
  mm80(
    orderTypeWidth: 320,
    orderTimeWidth: 280,
    qtyWidth: 450,
    dottedLineWidth: '------------------------------------------------',
    itemQtyWidth: 470,
    totalWidth: 400,
    totalDottedLineWidth: 390,
    totalQtyWidth: 470,
    lastDottedLineWidth: '---------------',
  );

  final int orderTypeWidth;
  final int orderTimeWidth;
  final int qtyWidth;
  final String dottedLineWidth;
  final int itemQtyWidth;
  final int totalWidth;
  final int totalDottedLineWidth;
  final int totalQtyWidth;
  final String lastDottedLineWidth;

  const PaperSizeConfig({
    required this.orderTypeWidth,
    required this.orderTimeWidth,
    required this.qtyWidth,
    required this.dottedLineWidth,
    required this.itemQtyWidth,
    required this.totalWidth,
    required this.totalDottedLineWidth,
    required this.totalQtyWidth,
    required this.lastDottedLineWidth,
  });
}
