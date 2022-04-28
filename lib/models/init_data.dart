class InitData {
  String? uniqueChatIdentifier;
  bool noHeader;

  InitData({
    this.uniqueChatIdentifier,
    this.noHeader = false,
  });

  Map<String, dynamic> toJson() => {
        'uniqueChatIdentifier': uniqueChatIdentifier,
        'noHeader': noHeader,
      };
}
