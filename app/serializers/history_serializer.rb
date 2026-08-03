class HistorySerializer
  def self.call(history)
    {
      text: history.rawJson,
      filename: history.filename,
      id: history.id
    }
  end

  def self.collection(histories)
    histories.map { |history| call(history) }
  end
end
