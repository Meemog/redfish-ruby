class HistorySerializer
  def self.call(history)
    {
      text: history.RawJson,
      filename: history.Filename,
      id: history.ID
    }
  end

  def self.collection(histories)
    histories.map { |history| call(history) }
  end
end
