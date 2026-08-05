require "json"

class AssetSerializer
  def initialize(asset, json_history = nil)
    @asset = asset
    @json_history = json_history || asset.latest_json
  end

  def as_json
    {
      id: @asset.id,
      rackId: @asset.rackId,
      name: @asset.name,
      size: @asset.size,
      position: @asset.position,

      paths: @asset.asset_paths.map do |path|
        {
          path: path.path,
          name: path.name,
          value: extract_value(path.path, @json_history&.rawJson),
          id: path.id
        }
      end,

      json: HistorySerializer.call(@json_history).merge(
        position: json_history_position,
        total: @asset.asset_jsons.count
      )
    }
  end

  private

  def json_history_position
    return 0 unless @json_history

    @asset.asset_jsons
         .order(uploadDate: :desc)
         .pluck(:id)
         .index(@json_history.id)
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

      if part =~ /^\[(\d+)\]$/
        index = $1.to_i
        current = current[index]
      else
        current = current[part]
      end
    end

    current
  end
end
