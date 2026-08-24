enum ReportReason { inappropriate, spam, harassment, wrongLocation, other }

extension ReportReasonLabel on ReportReason {
  String get label => switch (this) {
        ReportReason.inappropriate => 'Uygunsuz içerik',
        ReportReason.spam => 'Spam',
        ReportReason.harassment => 'Taciz veya tehdit',
        ReportReason.wrongLocation => 'Yanlış konum bilgisi',
        ReportReason.other => 'Diğer',
      };
}
