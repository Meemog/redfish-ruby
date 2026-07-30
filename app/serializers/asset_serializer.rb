require "json"

class AssetSerializer
  def initialize(asset, json_history = nil)
    @asset = asset
    @json_history = json_history || asset.latest_json
  end

  def as_json
    {
      id: @asset.ID,
      rackId: @asset.RackId,
      name: @asset.Name,
      size: @asset.Size,
      position: @asset.Position,

      data: @asset.paths.map do |path|
        {
          path: path.Path,
          name: path.Name,
          value: extract_value(path.Path, @json_history&.RawJson),
          id: path.id
        }
      end,

      json: HistorySerializer.call(@json_history),

      pagination: {
        position: json_history_position,
        total: @asset.json_histories.count
      }
    }
  end

  private

  def json_history_position
    return 0 unless @json_history

    @asset.json_histories
         .order(UploadDate: :desc)
         .pluck(:ID)
         .index(@json_history.ID)
  end

  def extract_value(path, json_string)
    begin
      data = JSON.parse(json_string)
    rescue
      return nil
    end

    parts = path.sub(%r{^/}, "").split("/")

    current = data

    parts.each do |part|
      return nil if current.nil?

      if part =~ /^(.+)\[(\d+)\]$/
        key = $1
        index = $2.to_i

        current = current[key]
        current = current[index] if current
      else
        current = current[part]
      end
    end

    current
  end
end
